Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21A38775108
	for <lists+kvm@lfdr.de>; Wed,  9 Aug 2023 04:51:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230088AbjHICvS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Aug 2023 22:51:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbjHICvR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Aug 2023 22:51:17 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AE7A1996;
        Tue,  8 Aug 2023 19:51:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691549477; x=1723085477;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=hWvarDSLEfQ5f0V0cnwJeOWLljIVrmvyj4VFRg3AB64=;
  b=VmhiXx8qJs0iDfbvurbna3vQE5XiQeypcj/hOYW185Q2SNjAoUwGFBJR
   fys1Ja3ph4AJg3MQFzHTo0Ch5T3btb9qMHUoP8yDK6uN39hsDTk+KKXJU
   V6iXDUY4geojxLAzkZfLModO65HTTOv7YF6/ueFkkxwBwce6mpPQtasSC
   sfWCH2K3d3dTIb1pMvr/iW8bUUyg1xhwx/UwpHn8lNNgyCAm3EpU5nSIm
   1ldtPfpBE5WgT6jrvXzkZzbUZTDFa9b0txUFsrluqLTe+5Le8Udb3jCOh
   RiwLRhC5qSZPwaNOR0NSaEX31IfAOAhW5aGDyn+rdvVSUE8qi+vsuWzic
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10795"; a="457386371"
X-IronPort-AV: E=Sophos;i="6.01,158,1684825200"; 
   d="scan'208";a="457386371"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Aug 2023 19:51:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10795"; a="731635264"
X-IronPort-AV: E=Sophos;i="6.01,158,1684825200"; 
   d="scan'208";a="731635264"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga002.jf.intel.com with ESMTP; 08 Aug 2023 19:51:16 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 8 Aug 2023 19:51:16 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 8 Aug 2023 19:51:15 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Tue, 8 Aug 2023 19:51:15 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.172)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Tue, 8 Aug 2023 19:51:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kmQHlBxH2/jk9UZ21Mitc4dSEkx4qV6i4gYDz/oUq9lC6VG1QrsAex3l9FKTbXNstHULmJuNxEyvazCApPmu5qtS6FTURuUVFQAvagdNdxtnKvqHbXSK9ouSpNmyyzM6pBq+CqZ+rBAER7fYFoo6zV0hrhQ2M1RL/gfIvTRG0fPxET6xaKUSTU1LvlvKlxNf44xZjIixjS+i0ne4lyWmGD8ztWvtdq16aXZfIVJV3t4IErHnxd56HzgBHh5Q6s4kqtu58KIeSz8B0hJ5CLxYopdWvVrv5cuy0B9JxsyvQBa4Ylj5/IAvSX2O4MZRALSS1aWfRGHukbKi2mUukIjoCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hWvarDSLEfQ5f0V0cnwJeOWLljIVrmvyj4VFRg3AB64=;
 b=gytHNRtxnvUt+ChoN0r6yxslfNvflpV/BKtZUTOBf4HYl572IJe+5oDGHhvgFRySxDu/8Ul0Ug56xEDNhDffSjG4EGUeC05KOdny6jVw2S0ss9l8ZRBZzDq9mCoWPfNvFDKX/VuJ7il4xO2KJkYa5tMTuM0Gew8WKYKcTfPULjvZrPyXbWy4o57BzAtHRJbE/Jm9eJvYpyClV7NP3UUZ5a/BZzK7eozaC3IxIRaQW19vWK4MeqjeNAXM1tUt3o/wfdMlWQe9MDY9O5OA/xSY1qgnspExLFgD9EyRdT4LkTEUxnANZ8juuSIK5FtfrSr/ZSi/GvxLJHKkUhPz3n9v8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by IA1PR11MB7810.namprd11.prod.outlook.com (2603:10b6:208:3f3::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6652.27; Wed, 9 Aug
 2023 02:51:13 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::94f8:4717:4e7c:2c6b]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::94f8:4717:4e7c:2c6b%6]) with mapi id 15.20.6652.026; Wed, 9 Aug 2023
 02:51:12 +0000
Message-ID: <5cba5a47-8863-2ac5-de44-94f4365bbca5@intel.com>
Date:   Wed, 9 Aug 2023 10:51:01 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.14.0
Subject: Re: [PATCH v5 09/19] KVM:x86: Make guest supervisor states as
 non-XSAVE managed
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
CC:     Chao Gao <chao.gao@intel.com>, <peterz@infradead.org>,
        <john.allen@amd.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <rick.p.edgecombe@intel.com>,
        <binbin.wu@linux.intel.com>
References: <20230803042732.88515-1-weijiang.yang@intel.com>
 <20230803042732.88515-10-weijiang.yang@intel.com>
 <ZMuMN/8Qa1sjJR/n@chao-email>
 <bfc0b3cb-c17a-0ad6-6378-0c4e38f23024@intel.com>
 <ZM1jV3UPL0AMpVDI@google.com>
 <cf97cfba-941a-5a77-6591-fa84ef6fe8d1@redhat.com>
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <cf97cfba-941a-5a77-6591-fa84ef6fe8d1@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI2PR01CA0002.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::21) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|IA1PR11MB7810:EE_
X-MS-Office365-Filtering-Correlation-Id: 3f9866f4-eacd-4f03-bfcc-08db98837db9
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4g+4dKVSQ/PLVJagwdeJr0eBxjbd7OVGDrjDPsaStM9wVOMh+mH6MSLH/cBhHwkVe3ueOZt5Wqktz2tK7D7X2CeptyPvnTm4RI0WFhZzJwnRwugWfZ7f9Wx/o0aNo/QJ7UBDYMQA0GC7tt0K0R+al1eXRRjILX10eJOOJ74P9J4Abkap2cU/wgLIi2TAosmJfqRxSp0QnWBMBRTDnB0HUHd2SI51TwFqS3YSSP3FcVoFBclCPSwZxXqIPKkUpvclTafxLLCqS2F7IKiLLQhicSJkBVtJWr3XAmuVZkPJuL2l/PAUsrad1oMKUUtqkqdH3tCSvdgoFtsoRQYdeVju3bd6HBpO5g/uw33LJFJ5uHJQ4LC1bvElHSnPgr/BNVohePf36Oq3ehOc9qhmsNtz1GwhizfyCq20Yt53x5DQlQNAr3xOzcZmeMWfIWl/4TncAqUppiDNRHDBGDHU/XU2LJz3dBIBtZQbWTppMMHhiUSYj69mCu99ueV4uSATRXpAnkai74IJN3ldaNqycdEqHYITRq56KR+XNWVrtbjLTwWXYMuKlKNwX+fAQz3YvM4NXL4EpTohmVH8pkQWSnw0mUz/fw1Nb40ZyHyW+foIAciZ18R9IVH/OqejXGRojQhIOxXV84BYnE7LthaEIEj4AQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(136003)(376002)(346002)(39860400002)(396003)(186006)(1800799006)(451199021)(83380400001)(31686004)(2616005)(2906002)(110136005)(4326008)(5660300002)(8936002)(38100700002)(8676002)(316002)(66476007)(66556008)(66946007)(86362001)(31696002)(6512007)(82960400001)(478600001)(6666004)(6486002)(41300700001)(26005)(53546011)(6506007)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?M2hiN1QxOW5WQmZZOTVJeGVvMys0bFNxQVNNcHlFMlVzdy9UN1JNZEtVVDBp?=
 =?utf-8?B?NWkyem9FS2dFdE1JWC9wUU1sVmRPdGUzSlRveklGbDBiMUkyNkNhMnNMbjd5?=
 =?utf-8?B?WFgxVVJmSlo4WWJtTjFQcXRrNEc3VUFoZldSTGZFMXhyRUlxcDV4dVA3OUxK?=
 =?utf-8?B?NFRhQ2J3Nnl1OXdxT2dWVy9mMGtvVUplSklMZEdDaDE0ekNqK2Z2cCtnRVBs?=
 =?utf-8?B?aWN1R0Y4c0NpYXVya0RPM2hIQlpHZ1k5MmNwTjY3K3BWRG9IU2pEVTEyZ2l0?=
 =?utf-8?B?SzNqQU03bU1zVGhFMTEvNURONHorOEVHa0c4NGVvaUowU3REZDFubERjeW5z?=
 =?utf-8?B?R2UxbC9ybENZdlVreDE5RWNXNW9lc0xGekVsN3E3bk9WR3IyeWRFZnRMVFhQ?=
 =?utf-8?B?dXVVZzBDRVNPOTl6SkNXaFIxQzMzTFF5c1lndTJubENmWGlpWGVzcUFzWmpS?=
 =?utf-8?B?aDE2L0ZjbExDRlc1VnB0ZWpabnF4U1VVT0NPUGhqbnl2a1dsQTFaR3hWUTYr?=
 =?utf-8?B?c3dKUDdSQ3ZucEgvYzR4Qm1wMk9tMDRqQi9VSFhxU3NmR0YyaFdQZUNhZ0p2?=
 =?utf-8?B?NVRGcUpsaTc5RGNwK0l6eENueEdpazhjTkErZ3I5dDZFTmFwaTNlMmIwQU9Y?=
 =?utf-8?B?K1NybjRhRXBKQW1Fb2tvNTM5Qm5kYURUMGRDUnEra1hZRUF6eXIxY0F4cDc0?=
 =?utf-8?B?SmZudWdOUElRQk14djIzMW5iZmIyZ0FVNHB0V2lsemJEc0lYQ01iZHRsck9r?=
 =?utf-8?B?eG1yNVFWaEphWjhJajlPZFgxTGVmbzRBU21oTk1tT2xzTHVDYU4wb1YyYzdj?=
 =?utf-8?B?M3RZRXdiNk9ROWJrZkFkN1BQc01Rd2VFSVBoeXVsc1RnZEVCeWlXT2ZPQXhh?=
 =?utf-8?B?a25JMlNrNUlBMSsyY2x2TVBMMllwRzJlcFBPbTNLdFkyTCt0L1lUREFBQVpp?=
 =?utf-8?B?NE9lTm5rTjQrMFZJZFFkbmZacXMyeE16WnNjR0thR2hQVjZ5REFNcEVHYmxW?=
 =?utf-8?B?d3VhN3RkOWZQR0p6T0c5dUJWN20yTnVPV2hnRUpKOUNjUm5EWVpQTndaYktC?=
 =?utf-8?B?ZUlwakpGMitCNlF1TFZ4VUJJSXNzU3l6VDgxZzRJSTM3Qm5jckxzTU5hNWsv?=
 =?utf-8?B?MzF5cVJodVM5Q2d1cjVoVnVjejUzbmlxd2I3TUdScXBuYk5selZaRDFkRHdV?=
 =?utf-8?B?Rm9Qc3JUVG13T0xCWHFYbXEvS2JXVDRqa05LT2ZSYXN5cXZEcitpQ2luQTNZ?=
 =?utf-8?B?M2syVGRZditJMVFsazhkVktDQnd1WnFMWW44QjVYRXU5VTd4SDl5NUp1REoz?=
 =?utf-8?B?ciswMktId0Q3ZXlBamxpamdxeVZsNTdsc1M1K1NyUlAwWHFCTGpURHRjelBS?=
 =?utf-8?B?aDFvTWltRTVBZEVDV3FTdGdQSmtmOEZEWGdlVEI3U2tpQnV2UEcrYmhOSXR4?=
 =?utf-8?B?NWI4d2pFcnFHWjdnOUZyL2YwRDVuVDVxZ3NXcnFxQmhFNi9Jd2hwZ0dHRUxW?=
 =?utf-8?B?bjVnTDQwaHhES2FSTnAvTFF4TVhTTDRGNkh3TnN1U1Y0UEJxbXJBSG4vWGtN?=
 =?utf-8?B?bzRmZUdqanh6UC90bzlKQlBWRXFwaUduZ2VvOFY1RDFMYjlNUURwUSt1bkFV?=
 =?utf-8?B?dUpaRG9sZi9HZW1pMUw3eHJvdjgzZjlPNUVCZHFoNmRVV2orVEdzd3JBNU9h?=
 =?utf-8?B?L0xtU0x6dU54Q1h2Q3ZNV2NoeEw0eVZ5dUIvYzZCT0NrQ3V0bWQ4cllqejNa?=
 =?utf-8?B?MUFBaThLZ2FJa09NcGhES0Zlc2pRTlA3TVZtTFladStaSzlwNGVud0NzK3hP?=
 =?utf-8?B?cWVNZy9MSFFmemJqOCtaUUN3cUYya3B1LzZENjMwT1ZBTDdQb2FLODduZGho?=
 =?utf-8?B?V1djbHd1TDBSSjBob2wyamRnQ2FkVGc2Q3dCYTNZZk9LSDVibFJKUDBNRXdz?=
 =?utf-8?B?Sng1MlpWcDAreUIrNE93SDVreFhrcUlJa0ZORk0wU0V4WnhSdlEyMzJXY2U4?=
 =?utf-8?B?ekl1Z1Bxc3RnTXhGTGY2NUZubUhmNis3dFJmdWR5cXA5aUtmRG5ubGFuZXQw?=
 =?utf-8?B?a2VOeDB3N3JGYzZPb2hEQWI5bThTNTV2emxqS0MzV1c3aTUwZmFLQVZoRWRp?=
 =?utf-8?B?ZDc2b1ErNVBpcEJGaUc1Nlh5K2ticWZ2WEhXTi9WUFp3Sys4a0pGak83R1M1?=
 =?utf-8?B?d3c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f9866f4-eacd-4f03-bfcc-08db98837db9
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2023 02:51:12.4338
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t01YiVYQRu20nA7P9UcpVfybNGNnWDMT/ap/z+RKz1fbge0zwgspvCMDKXFvrLVbLGtpuAUB7c2dNjr1Mm6c/Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7810
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/5/2023 5:32 AM, Paolo Bonzini wrote:
> On 8/4/23 22:45, Sean Christopherson wrote:
>>>>> +void save_cet_supervisor_ssp(struct kvm_vcpu *vcpu)
>>>>> +{
>>>>> +    if (unlikely(guest_can_use(vcpu, X86_FEATURE_SHSTK))) {
>> Drop the unlikely, KVM should not speculate on the guest configuration or underlying
>> hardware.
>
> In general unlikely() can still be a good idea if you have a fast path vs. a slow path; the extra cost of a branch will be much more visible on the fast path.  That said the compiler should already be doing that.
This is my original assumption that compiler can help do some level of optimization with the modifier. Thanks!
>>  the Pros:
>>   - Super easy to implement for KVM.
>>   - Automatically avoids saving and restoring this data when the vmexit
>>     is handled within KVM.
>>
>>  the Cons:
>>   - Unnecessarily restores XFEATURE_CET_KERNEL when switching to
>>     non-KVM task's userspace.
>>   - Forces allocating space for this state on all tasks, whether or not
>>     they use KVM, and with likely zero users today and the near future.
>>   - Complicates the FPU optimization thinking by including things that
>>     can have no affect on userspace in the FPU
>
> I'm not sure if Linux will ever use XFEATURE_CET_KERNEL.  Linux does not use MSR_IA32_PL{1,2}_SSP; MSR_IA32_PL0_SSP probably would be per-CPU but it is not used while in ring 0 (except for SETSSBSY) and the restore can be delayed until return to userspace.  It is not unlike the SYSCALL MSRs.
>
> So I would treat the bit similar to the dynamic features even if it's not guarded by XFD, for example
>
> #define XFEATURE_MASK_USER_DYNAMIC XFEATURE_MASK_XTILE_DATA
> #define XFEATURE_MASK_USER_OPTIONAL \
>     (XFEATURE_MASK_DYNAMIC | XFEATURE_MASK_CET_KERNEL)
>
> where XFEATURE_MASK_USER_DYNAMIC is used for xfd-related tasks but everything else uses XFEATURE_MASK_USER_OPTIONAL.
>
> Then you'd enable the feature by hand when allocating the guest fpstate.
Yes, this is another way to optimize the kernel-managed solution, I'll investigate it, thanks!
>> Especially because another big negative is that not utilizing XSTATE bleeds into
>> KVM's ABI.  Userspace has to be told to manually save+restore MSRs instead of just
>> letting KVM_{G,S}ET_XSAVE handle the state.  And that will create a bit of a
>> snafu if Linux does gain support for SSS.
>
> I don't think this matters, we don't have any MSRs in KVM_GET/SET_XSAVE and in fact we can't even add them since the uABI uses the non-compacted format.  MSRs should be retrieved and set via KVM_GET/SET_MSR and userspace will learn about the index automatically via KVM_GET_MSR_INDEX_LIST.
> Paolo
>

