Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EA107329B4
	for <lists+kvm@lfdr.de>; Fri, 16 Jun 2023 10:25:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245256AbjFPIZY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Jun 2023 04:25:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234233AbjFPIZV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Jun 2023 04:25:21 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C31C2212B;
        Fri, 16 Jun 2023 01:25:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686903920; x=1718439920;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=MvQUGCoVbPAwQ9fBTI2yB/ewXIpwBnC9ip77dy5I508=;
  b=O7IPoNXZmAwWsqWdQMtjT5Uc2H/YdO6m8KfMKitbN6h0Os6YbLZjX0s4
   mIPpMggPpjeDlO5WkYw4VtMoMMwwT96e94jBcSCuikM9LabanpH+hWrWp
   thl8Scl8l9GSeEPKpS3sgPMN4y2C4zJ9vAY5dFI2drtBiRhi/rmpNwMsM
   hx2SOTyDVZfXH6iViEVBO/HFo3S7/RWDQV1Ee8c59XATobj3bX2bipoH/
   Uvmr/aJJmDLVy2CyUBrmz8WSYV41DuRdA3Ta8ZnusECm2CRFJu2Ld8PhO
   WdR3BdPFYAdj8aLnQ9WGnjevh+XnZ6j5G+gdBHQmRy6xPYEUZ49/y4GZ3
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="359166666"
X-IronPort-AV: E=Sophos;i="6.00,247,1681196400"; 
   d="scan'208";a="359166666"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2023 01:25:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="778069444"
X-IronPort-AV: E=Sophos;i="6.00,247,1681196400"; 
   d="scan'208";a="778069444"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga008.fm.intel.com with ESMTP; 16 Jun 2023 01:25:18 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 16 Jun 2023 01:25:17 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 16 Jun 2023 01:25:17 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Fri, 16 Jun 2023 01:25:17 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.177)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Fri, 16 Jun 2023 01:25:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b0hcoMOiSiNCmew75njPVX9KULKVQ7ULKgSNMM7Lo5JjMeY95zr5sjBwEqnHn0RzQNqJYMsfFq9cWPXEEYiIKH8FpoxNZWEFbsEZy/YNUEVujO947UYPxvHrV5DZ1Ud3OopZs2qu6cM4njC0/h49UyBthnA8bI2LTfPAmOf0MJDRwrMeBYz/hhTNt9zpVMu6/RoM/FUySI0jaqCCnxt2RXIvQxX9886UGM1vH5y09PYs74ZxZUxnLYOsd+AqDyyxxoXM1iDxqezQh3PH4MHNgj3cOhpaNg4GOoMHKyAw7qlstzRs3qwuDiu/z+m477gki76K+TfjVAmqxL6s9TX0/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u+8EapwhVBZq7x768OBZ9aWxNwSOXp3QVKqt546ucpI=;
 b=Jmnuo17jf/QQ/nyhUE0lP0QTIssYm3tam9LUlrvZLC5LJIj1mHtBn2H8jrYjD20jla3nrawQpoBM8mPyHWNfnFAAbkEBh0fNb1E+mbHusQIb+0CTDUD9B/NtOPkeaQcaO3ZAOwyMknGPyJYLFUKLG9vNxVvE35OB8OkhEjJCyz0Qq6e4ZKo972guk8oEPvQpm/ovcXiGjg2U/CDA1JZq7BVt2vmGsC9Roqg265hCuxXbDmxMLAGL/L6uA5yaVuPSCKberM0Ep5q3zjFAXUkBdNqVfesLt0bxMQl1otlyg4GYwjFRP0nNcoOEV//EF6ZjolPimndCZkIX+5xqMxg9GQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by IA0PR11MB7284.namprd11.prod.outlook.com (2603:10b6:208:438::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.42; Fri, 16 Jun
 2023 08:25:13 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::4707:8818:a403:f7a9]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::4707:8818:a403:f7a9%6]) with mapi id 15.20.6500.029; Fri, 16 Jun 2023
 08:25:13 +0000
Message-ID: <147246fc-79a2-3bb5-f51f-93dfc1cffcc0@intel.com>
Date:   Fri, 16 Jun 2023 16:25:02 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH v3 00/21] Enable CET Virtualization
To:     Sean Christopherson <seanjc@google.com>
CC:     <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <peterz@infradead.org>,
        <rppt@kernel.org>, <binbin.wu@linux.intel.com>,
        <rick.p.edgecombe@intel.com>, <john.allen@amd.com>
References: <20230511040857.6094-1-weijiang.yang@intel.com>
 <ZIufL7p/ZvxjXwK5@google.com>
Content-Language: en-US
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <ZIufL7p/ZvxjXwK5@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI2P153CA0028.APCP153.PROD.OUTLOOK.COM (2603:1096:4:190::9)
 To PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|IA0PR11MB7284:EE_
X-MS-Office365-Filtering-Correlation-Id: 388cad56-78a0-494f-23c9-08db6e43347f
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Kvr3Ta3/OMMmLB/r4RLg3J6bDtCA/kpGG6jHGfvhz3TjhSIdiKMYiUNRh3nvpRtCiRkJohJ8XN/+EpmMWsLKdkkdCSlUW4jNSHimvQiyXTnpfBhntqnmcRw2wo6npZ0CSJOgt5U5OmjUSg6hRuDr/4MdG6WarYFUv34KD+SnfVacEpbPcQ0L7B6B51/geqX8cP1uUzcaAm2u9ncSBOGz2gmem1E9VxUb5jkcgXdeNslfev6+aTNTiLvC+s2Juv1YEqnmHnnCBJduVxegoaDnAdpNKUa/c4B8dlV13rj1UmkowimeGqAlwFB3FR5+tYxSedEi1xuQBkcHzFLOVQNyPtfBNOaaHLUHYtb2Yyiu/pl79eRq0Hb3AdEImJ+vyJZ9qJLcpXMSwwhSbv8y1K9dRqbXmzEu9BzYfKpDzIzTisFxSc4ogACoJUrjtEtIBaFBSkyrI/Jjonp+F09TXLE0IaZhk/EGgtIVDvfbx4DycvrVwKsSZSTrokBLYKjkt3dx24MZT8WeTp8cXyk2vHBc3aA7l3jguXRyLQ4wuSNkTg9FL3mRIL9ZVFwblDpsFeir3OMfhK3RaqPJGKH2rScm3cahiME2Hfcyot/JGD+aarC7mYmrRGzao8Cbwpesk/F8V+WaIqVttVmZL9kN78Nueg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(366004)(39860400002)(346002)(136003)(376002)(451199021)(2906002)(31686004)(66556008)(5660300002)(41300700001)(8676002)(8936002)(66476007)(6916009)(316002)(66946007)(4326008)(6666004)(478600001)(36756003)(6486002)(2616005)(82960400001)(31696002)(186003)(86362001)(38100700002)(6512007)(53546011)(6506007)(26005)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ejB1YWZjODgxQ0NrRHFmYUc2ZlpURGdvek5HN3ZCaU9DUHJidlQ4TElaTzho?=
 =?utf-8?B?NlhwZ0VVUW5NZHJHMTBrb1N4eDZSSjczaUpIRXN3a0RpaExWL1g1NVNaeDJC?=
 =?utf-8?B?d1hFUTE4c3QwT2w2TVRIQTRoekRhSStqeUUwanUyUXV6UzBaQm5YVE1ydXBM?=
 =?utf-8?B?WW9XNkJnckNzb1g0NmlZSGdTWVJtREloTzc0dTJiNWVMOUlDbWJkY1FTVm9s?=
 =?utf-8?B?dERNMHU5ckpEMFRmcytlRHNjWDAxemoxdFpycmJFS1E2b2hBVWw5Q3YwbVo4?=
 =?utf-8?B?M1QwSHB4Y04zYVNSc29sajN5T2RzRTBRQlJRa2lIT2p0cTV0dDNhV3M2L2ov?=
 =?utf-8?B?UFVjcEVwZzBDVjBrRU5GVEU4ZzV2ZXdGOUZaR3hqejBKdVZ0Y1lCRlRvSUI2?=
 =?utf-8?B?WHUzZDNKTW16OWVjK05heEh6L1UvenRLTzk5M2F1cEdhZ2xVZ04vZ0wwQ1ZH?=
 =?utf-8?B?Ums3WkJXdnVOTXZ6ZGdOTEpSNHFSYWY1YjQvR1RNeXNEOWladTZXTEdkRlcw?=
 =?utf-8?B?RnA4TkhORy96N3hIZ3JkS0lMSEcwRHU0TnRMU3ZiTHZlZ3R6aXd0S09xSHJ5?=
 =?utf-8?B?SVh3dHpkeFFqMXByN2N4dkY5UFIwMVRxS1dvdjBBZDNmMkQ1MFp2RTFIUHQw?=
 =?utf-8?B?RkxlTkYzUERVSGYxOHRmSEw2eC94ZldXcFA5TTNhQUJKV0JDdjZrREVQVWJu?=
 =?utf-8?B?OVZKZzRGNXJwOEtRSXZkMW9LcFcrN09wbndHbkQ2a0RJZGNLbHlnOVVFMlhM?=
 =?utf-8?B?SU5ZRlY3NkxDejVtamdhK09kRFA4MHR1dzEvWVpEd2VuczFYUnhoQ1R0WXVi?=
 =?utf-8?B?WVZpQXZSQ1RON3dVVmpWclhmRzhONkErRzlmWEFGaFZCbVhGeTZCYjVIakh2?=
 =?utf-8?B?ODlhcHV5V1dUVngzTDJuVmhhaE93cm10VXZid0VuWmZZTHRiRGZWQ0s4Z2Fs?=
 =?utf-8?B?NFdtUXdhVFFoK1RBanZyRFZpdjZqRTZiSy9XN2pXQTFQbHFKS2x3NU44alJW?=
 =?utf-8?B?VEF5MGs4ZW01VmFtdVYwOUpMQnF5ZGxMdjJuUW94bFd3SXk5NlRsRjd4OUdj?=
 =?utf-8?B?bXlucFJTMjVYL21WQnBEZnZ5Qzh3ZUJPajVjVjVvZm9aS0RxUloxVktVaWlX?=
 =?utf-8?B?Y0hXemNMeVp2UGNpSFZrK3lrRXdOU3U1TUp1cHFBdkRybFFHZmJWSXR6cmxW?=
 =?utf-8?B?WmZtU2ZhRndtcktyWS9CRHp3b1VFMHZVaHQrRGx0ZEpULytKQTRKR01ZWWdy?=
 =?utf-8?B?WWZ5dDZrZ000OFhUU0pmOHB0Y29JTmMwaWFHbWVRcy96bEdIMTFHcmtQY1N5?=
 =?utf-8?B?ZVVRY3BqSzBGVTVoMGM5RlRGRnQ4dHpKQk05ZHU4Ym01MFczN3F0aUtrc0xP?=
 =?utf-8?B?TzUwcWhHQ0NrcVdwclJmQmk0YzVqR3hWTExpMXF3bmlRblh0QWtHUU1iNHJT?=
 =?utf-8?B?b09Wc0JaT2o2L005S2ZPMUZodjJjWHEyZkQzWnI4dlRYeEVpenEzeHY5SkJm?=
 =?utf-8?B?T3dvcThwcG9ZK1kzd3piTVVrVFVnSFVZNzk4VmkrRVJyVENEd2NGTHZ5ZnA1?=
 =?utf-8?B?YitQVzVIWEVtMVloUUQ3NlJXZG5VajFLTFlDTDhVVW9GNVNvMXdDeVA1dGt4?=
 =?utf-8?B?dHhaQzVtM3NRNzhlNHRtQWxqckpCaTZ1R2NvY2VLNitjT3pWZVFiNUZ3RTMw?=
 =?utf-8?B?ZlYyeFZlN3A5YzR0YWNwSmd0azNUT1dqYXQwY1NlNVIybXpleHBxeHpBR3pM?=
 =?utf-8?B?ZDduV1d0dERKMzdRVU1Payt6NElkOXpyOEFRZitWOUFrK2hiTjFlaDNYOTNS?=
 =?utf-8?B?ck84WHZBMElOWmllR0l3Y2pyRkNld0lDdUgwZUF0M1Y3eDFRVkJ5MFVYMmpG?=
 =?utf-8?B?MitkS0FtMGIrMnVKZ3czNisvRmNTUk1UeDhBOGlhU0IyZzdhSHRRNitIS2xr?=
 =?utf-8?B?Z09zblN3NVVxL3JEdzJEcEMyMGpOcEpOQ0RIdmpRMnliOGZtdGVyUTE1RXpG?=
 =?utf-8?B?NXdMd0N0TVJrektFTnpuVFFXWXBDWW5yTzVjSWZOV252YTl1VWZySzJLek1X?=
 =?utf-8?B?cUpYRXNwOU5MalFjRmdFaUZXckVRUnJkaGpobzVxT1NWMWpLdnc1OG5NREZ1?=
 =?utf-8?B?aXh3WGlibWZKdlRSYkswWUdFdEZtV1F0L1ltbURnRlJnRWhMQWxFS04vM1hn?=
 =?utf-8?B?MFE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 388cad56-78a0-494f-23c9-08db6e43347f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2023 08:25:13.0003
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sb4eB3a8wI9pHgX9LGx46IfLsl4dCcb/6sMxx59KR52Ohlkc3QgDbP1S448d+u8nS3DalaWwD5iMQf1x1wiSLw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7284
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 6/16/2023 7:30 AM, Sean Christopherson wrote:
> On Thu, May 11, 2023, Yang Weijiang wrote:
>> The last patch is introduced to support supervisor SHSTK but the feature is
>> not enabled on Intel platform for now, the main purpose of this patch is to
>> facilitate AMD folks to enable the feature.
> I am beyond confused by the SDM's wording of CET_SSS.
>
> First, it says that CET_SSS says the CPU isn't buggy (or maybe "less buggy" is
> more appropriate phrasing).
>
>    Bit 18: CET_SSS. If 1, indicates that an operating system can enable supervisor
>    shadow stacks as long as it ensures that certain supervisor shadow-stack pushes
>    will not cause page faults (see Section 17.2.3 of the Intel® 64 and IA-32
>    Architectures Software Developer’s Manual, Volume 1).
>
> But then it says says VMMs shouldn't set the bit.
>
>    When emulating the CPUID instruction, a virtual-machine monitor should return
>    this bit as 0 if those pushes can cause VM exits.
>
> Based on the Xen code (which is sadly a far better source of information than the
> SDM), I *think* that what the SDM is trying to say is that VMMs should not set
> CET_SS if VM-Exits can occur ***and*** the bit is not set in the host CPU.  Because
> if the SDM really means "VMMs should never set the bit", then what on earth is the
> point of the bit.

I need to double check for the vague description.

 From my understanding, on bare metal side, if the bit is 1, OS can 
enable SSS if pushes won't cause

page fault. But for VM case, it's not recommended(regardless of the bit 
state) to set the bit as vm-exits

caused by guest SSS pushes cannot be fully excluded.

In other word, the bit is mainly for bare metal guidance now.

>> In summary, this new series enables CET user SHSTK/IBT and kernel IBT, but
>> doesn't fully support CET supervisor SHSTK, the enabling work is left for
>> the future.
> Why?  If my interpretation of the SDM is correct, then all the pieces are there.

My assumption is,  VM supervisor SHSTK depends bare metal kernel support 
as PL0_SSP MSR is

backed by XSAVES via IA32_XSS:bit12(CET_S), but this part of support is 
not there in Rick's native series.

And also based on above SDM description, I don't want to add the support 
blindly now.

> [...]
