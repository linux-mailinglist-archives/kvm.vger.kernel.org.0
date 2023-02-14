Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39098695912
	for <lists+kvm@lfdr.de>; Tue, 14 Feb 2023 07:19:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231466AbjBNGTI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Feb 2023 01:19:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230199AbjBNGTA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Feb 2023 01:19:00 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 600C04680
        for <kvm@vger.kernel.org>; Mon, 13 Feb 2023 22:18:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676355539; x=1707891539;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=sKZGrjkwAyFj0OLfFCjTQ3K866XAMEVb2PnYW/GSrXU=;
  b=g1g9PFAd6/z7fTqN9xTLDUbvGecIJ1lltY+5nUQ9zXe6leslz/q9Pnu7
   KwRAC2RkmSczCvRJps7mU0b3yPjLjZXnnqXX7+KntIbidZn8M3w7+mFPG
   RZcTDd3J6Ol2rWE/iopsFED7tLR7OS1BpBxr+/5Sx7EmAnlWJXF/kw8Xo
   /nL6geGUvl7qXJ9OvPmWgTnbcmCtoBSB9nynpZNw3ibDm14mqCJaZ4wqc
   M9jkvN8rmMrmSdWVbsgchMmm9ipw5BQiiuWp2rnnwfqjIus9rIEUDbY7L
   oOa417Y4htHGW997P08sSDL30R8EapxzgeawH1LUy+z+hpfzB3hnj57M4
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="331090784"
X-IronPort-AV: E=Sophos;i="5.97,294,1669104000"; 
   d="scan'208";a="331090784"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2023 22:18:45 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="843049686"
X-IronPort-AV: E=Sophos;i="5.97,294,1669104000"; 
   d="scan'208";a="843049686"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga005.jf.intel.com with ESMTP; 13 Feb 2023 22:18:44 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 13 Feb 2023 22:18:44 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 13 Feb 2023 22:18:43 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 13 Feb 2023 22:18:43 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.104)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 13 Feb 2023 22:18:43 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oOhExmnZf165ZQEYki8VOSONn9OAsvwjyHe09C/vWk6yz571dnsDf+0rlE3dmdPP9JZKKaCEd44r1OweoDELEAcckTjqc+H37CmjPiUsILtXCVmpWY4I7AA7d4XxU3ADb2YlKf54E+KyCMHwY6V+c2ikIdCmYJNTPel18/wjflds0baQsLg2OLOXhfP8APzXpKtAZk9guOfV698h+Kgvx1qhzC4hnhokz6kXrjOLjj/uC0E6WRQCDrzQXKfzgbKm+EjSVRPpzK0kNp/0GG5Fd3OOMhFj9gE+N1oHHJAjYQMRr01/cFhOkOR5XpbZ7/jjni8oyJCCInZp/KLUfYTADg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xOs7MxqkAVNeO36F+dyFHVqRNrsxelTHLZEd1ukcqlQ=;
 b=HRtdsAM2yYh8Zj8oS0LNqkdf0faS8W6IR1W1i/izgxxpD2L8ZAhL2jo4wdvfrLvIUGTHCtU8xaqQE6aMwsbUaOjlUQFLJnDg5aqZRu2TqWDGkFGXbJJNI52mXEr/YPpxVsV8PdGpIf0BuVUnyWeczZyFbkn/T3LtuJQJmaxkVfN31Dh3ruTJWSONzBzbDHgmBpurAsepMaV/aEOM1inYAybaWj3TJsUorlkMT4I4UJvqHSmyUl42G6HQ1dkXgaasLOyiyrIg9DdM4I8an3F/DXkZQUZ8Y2cv12/Y4zz1boRo+wtwm8alvgS8Mx+BsazvxAAzH/n872EGdkpd78zp2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
 by PH0PR11MB4999.namprd11.prod.outlook.com (2603:10b6:510:37::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24; Tue, 14 Feb
 2023 06:18:41 +0000
Received: from PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::5cb1:c8ce:6f60:4e09]) by PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::5cb1:c8ce:6f60:4e09%8]) with mapi id 15.20.6086.022; Tue, 14 Feb 2023
 06:18:41 +0000
Date:   Tue, 14 Feb 2023 14:18:59 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Robert Hoo <robert.hu@linux.intel.com>
CC:     <seanjc@google.com>, <pbonzini@redhat.com>,
        <yu.c.zhang@linux.intel.com>, <yuan.yao@linux.intel.com>,
        <jingqi.liu@intel.com>, <weijiang.yang@intel.com>,
        <isaku.yamahata@intel.com>, <kirill.shutemov@linux.intel.com>,
        <kvm@vger.kernel.org>
Subject: Re: [PATCH v4 6/9] KVM: x86: When KVM judges CR3 valid or not,
 consider LAM bits
Message-ID: <Y+sn09U4wTIxoDKN@gao-cwp>
References: <20230209024022.3371768-1-robert.hu@linux.intel.com>
 <20230209024022.3371768-7-robert.hu@linux.intel.com>
 <Y+mZ/ja1bt5L9jfl@gao-cwp>
 <cd11d9bd2ab1560f0adce5da32190739f7550b06.camel@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <cd11d9bd2ab1560f0adce5da32190739f7550b06.camel@linux.intel.com>
X-ClientProxiedBy: SGBP274CA0023.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b0::35)
 To PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6780:EE_|PH0PR11MB4999:EE_
X-MS-Office365-Filtering-Correlation-Id: b2f0ec68-28af-4c6c-0da7-08db0e53511a
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: F1Hzw9QGMLiSB6zQxzW2aB1dyM7wiQb/Cw6ovQvrx+adaGvrvtBpWGczjDK1h9TOQWwCCysjVWXqFw+G2DLk/Wwsh2at1BM6xuj/x6WJSxjl8Tpy3+VyNQAyxGBEkmksxRsuETEyMCcKiI+Ec1BAS0lD9whL0j64a+NrF8nfBMX2NO81A0Awq3eLCIXqZ6TU/NDdnsaBUavCivsnk1tgBiI7+F8s3hlelUdOK9247hSUHB0/HCiq2Dp9qO7svD8+jZdl9OvT6cA+NevJKdT5evQWVnaD4kAupgd9EV+8AbDVNIt9j4dYyTSV1ZFIBRlCsmcf3CH7JngSITMmIlG/udn8D2ZryaIqeEpmmhq3oLHr+veusIgtd5vywTowDStjS/TDxsM/YACgre1TCYZcXSX/5qi/y9Mnr7i73Ky81tholmarL4oYY0wPadeZdCR+lIteI0MRHcz0Nu8wO7gLZpDGKTbB+DtQFeQxTHWZVABXcic6KUVm4hsiRF8FpjkeAPLfjD3JtBO4thAAurgkeN1jO74L6Mqwf8B5DcQ3BfZTgnx5xlwZsD5wDqzx7HSkH4H00FuHnc7Ww/AbExdJ3t6R1yM4DFzWGNTfcCqZ8qkV+ULV44plWSxMZYojnbzN6pqpLTqf6EOTox1jPrp9SiyZ04J58OiU+dOVe39faHsojOh+9+4gymxIBrwCN28z
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(396003)(376002)(136003)(346002)(39860400002)(366004)(451199018)(2906002)(5660300002)(8936002)(41300700001)(66946007)(66556008)(4326008)(66476007)(6916009)(44832011)(8676002)(316002)(6506007)(6666004)(6486002)(478600001)(186003)(6512007)(26005)(9686003)(38100700002)(86362001)(82960400001)(83380400001)(33716001)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bEWuyvK9OsKzJScFDCWrqTMJ/6GHDOpL25YvTDHKlWK62P1m1j4C/+1erHPd?=
 =?us-ascii?Q?yo/mxAkBMxgFJNzi2KdbiajjGwS3MWaUDMHXjiQ3qyAkEp0U8UrUY1hgTeqZ?=
 =?us-ascii?Q?Nx0w+VJ9wDqbreUId1h1EWKaAfYtyuu7YVZNs8bBpuf96CmwdIW3nm8UJsKL?=
 =?us-ascii?Q?MLEN6fldDoxfVsSsOvOX2m5AwINe9569GK4SzVyYiIrbaFGdUfHVpJRxFqV0?=
 =?us-ascii?Q?HWw6dN9Mh06pBsRW8mojsJQG2xpc3rQMBgJloV5N58yitiOAQ/XQ/M16xigw?=
 =?us-ascii?Q?1AC5NPgyP+w04g9lfpztrFcHHiMEBDKD3PE8imkuXlk42QXdP2/Hvn6qEVD/?=
 =?us-ascii?Q?x59LBuY+QUA9KwYcFDQ5ZTGDvy3GURdTjhDqDc0POewvE1v0TQdJxwRLvQdD?=
 =?us-ascii?Q?UjaK2+j4dCoomcUYQfHwZkuFyhbT7OY7FwLwSoZvLqfKIh1v4NpRhDHwEBVE?=
 =?us-ascii?Q?v1zS6ICcASwDgnWyHbkr+JKK51OuyUweN6tdZU+tYcte5VoIXWKM1i98uvnN?=
 =?us-ascii?Q?1Lfd06rdWbeWKNez+eZpd2GK2LiyxgkOUgAcMK6b3Ak7avstFhM2NiBYYnKt?=
 =?us-ascii?Q?rMhaDS67n5fYDoJGNFpmq2MJODqHYIyY/9cGs1kvOOJ4jaRt0u0AX32RkPxQ?=
 =?us-ascii?Q?cdWpafQXi6kthwVYawAsuVt9v3pLKgjPdNe5//IZrLDanO5jnWNgI2UFzC3H?=
 =?us-ascii?Q?OD53Tib7zKP4OU48x9lJGtNzkKZohBnYVry2WkOryg9wMEBeWzfkvsdXa7xW?=
 =?us-ascii?Q?QZkjvwh2DnvY3xvhc6wz014y4eZoTsLY4QOoeEEMyp8gWTvIo4ZnnLxtMupF?=
 =?us-ascii?Q?USCbmVDCfBsM8V4Mn6nmaKMorxP4050aHczSDRpqi5E90h0vgUrbHOPNJd+9?=
 =?us-ascii?Q?VgAI/O/cIzTtqkOy/zUZkeEUNz6ky6muUPP5mk/9Ym89Tjef8Q751JtdFfKg?=
 =?us-ascii?Q?cJsvi5/+Ei4KoplK8ATmWPKPfJNWFkU6PwTDMPiSPkQ8ACoLyCiAPVLq0dw2?=
 =?us-ascii?Q?j9fG2grvi/VlovwjriA3mh9bDxP208VPpsf/Gh4M7crcMjfMbWghbgYAq7cc?=
 =?us-ascii?Q?PGbYtQn2cwoEiSouJmcpd8S+cV8jXjQ5OY5jB6RSLLN9wK1uxf7m1s44/YeG?=
 =?us-ascii?Q?RSVuL0CwVmHGNGF47Hue7opgg3siovkcAg9s1RJj1miesUnF0VUTFp1cuL9f?=
 =?us-ascii?Q?rilu8Bla/I5PsV8keLBIwIUQ55goa8nR8DESVJVNbCDuY87y4+EtqtJ5sPqV?=
 =?us-ascii?Q?0TuTLa5eHymQsgkUEaA3WImhsa9ddlVox0PpOW3E7X2Lfy9VdF2YNxHQ3xPz?=
 =?us-ascii?Q?vjFFIwPHEP/9q8c0HprxemCugd+0HGhkCeFxplRLPLVwUYHmzKMNkhdafz3r?=
 =?us-ascii?Q?5wlMw8adF2XQ6itpLrGw4rJ1CnwkltF3Jqr/LRw8eglq2RRBmEvkxoJ+Ucxa?=
 =?us-ascii?Q?5MmvPAAHwb9GeaToWYionIYSnG7ZNspdLP6m89hg6zWctww8AwyxCoRkHar0?=
 =?us-ascii?Q?4yPpNzQVrQ/udrPKVrhAbieMWrajTi5f15aiCUtTIHEqO9L4kAKJ5vndesU4?=
 =?us-ascii?Q?dMLdoe17muP8rdceASXiyM1FlIUOValSBFeSUmTa?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b2f0ec68-28af-4c6c-0da7-08db0e53511a
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2023 06:18:41.0668
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xNK3VX5Z4UehcM41kndm8EyefJcALoyI/h/lleyHe9RJCyOg4BUhPmGtmTGcR2x4KJX+3PvwcewxhbVEfZkuxg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4999
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 13, 2023 at 09:25:50PM +0800, Robert Hoo wrote:
>On Mon, 2023-02-13 at 10:01 +0800, Chao Gao wrote:
>> On Thu, Feb 09, 2023 at 10:40:19AM +0800, Robert Hoo wrote:
>> > Before apply to kvm_vcpu_is_illegal_gpa(), clear LAM bits if it's
>> > valid.
>> 
>> I prefer to squash this patch into patch 2 because it is also related
>> to
>> CR3 LAM bits handling.
>> 
>Though all surround CR3, I would prefer split into pieces, so that
>easier for review and accept. I can change their order to group
>together. Is is all right for you?

No. To me, it doesn't make review easier at all.

This patch itself is incomplete and lacks proper justification. Merging
related patches together can show the whole picture and it is easier
to write some justification.

There are two ways that make sense to me:
option 1:

patch 1: virtualize CR4.LAM_SUP
patch 2: virtualize CR3.LAM_U48/U57
patch 3: virtualize LAM masking on applicable data accesses
patch 4: expose LAM CPUID bit to user sapce VMM

option 2:
given the series has only 100 LoC, you can merge all patches into a
single patch.


>> > {
>> > 	bool skip_tlb_flush = false;
>> > @@ -1254,7 +1262,7 @@ int kvm_set_cr3(struct kvm_vcpu *vcpu,
>> > unsigned long cr3)
>> > 	 * stuff CR3, e.g. for RSM emulation, and there is no guarantee
>> > that
>> > 	 * the current vCPU mode is accurate.
>> > 	 */
>> > -	if (kvm_vcpu_is_illegal_gpa(vcpu, cr3))
>> > +	if (!kvm_is_valid_cr3(vcpu, cr3))
>> 
>> There are other call sites of kvm_vcpu_is_illegal_gpa() to validate
>> cr3.
>> Do you need to modify them?
>
>I don't think so. Others are for gpa validation, no need to change.
>Here is for CR3.

how about the call in kvm_is_valid_sregs()? if you don't change it, when
user space VMM tries to set a CR3 with any LAM bits, KVM thinks the CR3
is illegal and returns an error. To me it means live migration probably
is broken.

And the call in nested_vmx_check_host_state()? L1 VMM should be allowed to
program a CR3 with LAM bits set to VMCS's HOST_CR3 field. Actually, it
is exactly what this patch 6 is doing.

Please inspect other call sites carefully.

>> 
>> > 		return 1;
>> > 
>> > 	if (is_pae_paging(vcpu) && !load_pdptrs(vcpu, cr3))
>> > -- 
>> > 2.31.1
>> > 
>
