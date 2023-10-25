Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 638967D6E4A
	for <lists+kvm@lfdr.de>; Wed, 25 Oct 2023 16:04:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235018AbjJYNuM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Oct 2023 09:50:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234986AbjJYNuK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Oct 2023 09:50:10 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BF1C13A;
        Wed, 25 Oct 2023 06:50:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698241805; x=1729777805;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=A+/BdsoScteskfXdWNqQ6YPpf2+hwYLLZUpgpTTBA0g=;
  b=HoeMuJVyHimrnXQToWHuC1nE9QJ9G51xda2Iti8MVDmY2IOaz7pZn9KW
   PYdzXG+H4lvmTZ72HTi6Wo07Z8VCxUYrv5sfQue3sSx4iAoGzzQigXxPy
   A1l879Pl3set8FMxY2co33sRPnNWh7IQBgKkimmcBnRhF+hVY1n82wwL5
   yCQ57z5M5ZjYHLmy71C32PLz/ZyUKyWzGbgIfgZUtl6BhhJ+eFniYDX1U
   GuMarmeTBYPODkqy5TXHJGdATQ8pEewInIQUk63SJapJ9ki/feu2VjxrO
   UG9oyLUSHLWm24fFiEfpWHpa0MjKItKfcy5NQHf78N2vD4x5toI4gmTzV
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10874"; a="390162461"
X-IronPort-AV: E=Sophos;i="6.03,250,1694761200"; 
   d="scan'208";a="390162461"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Oct 2023 06:50:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.03,250,1694761200"; 
   d="scan'208";a="6554148"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 25 Oct 2023 06:48:45 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Wed, 25 Oct 2023 06:50:04 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Wed, 25 Oct 2023 06:50:03 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Wed, 25 Oct 2023 06:50:03 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.169)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Wed, 25 Oct 2023 06:50:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eoPHhGMWrZakPfCDHVhAQUYk712hCl7sQYIDEhzpgx0NqtE9OlRiHWPiUZqq8mqMrR2bI5si4o/TYXFewPVC0HAhuSEn/sHGjp0R6CKHHLj4WOR3Ml+b9q7CdaST+5DpTElVi1I2CJ4m+9h0OpFHEGBQycHrXjTwpOg3PiAITFBs5sGTn7ScRvZkhbNtuQ2fYiPB1okJ3X19IowdlTmuN4yFDpmoWkAkX8jx9DWLEND4+SNgKY/qCJjBOIBEsid8QSkeystGDZO3d1hZOjn6iKR44hoIWI0ws8qSeqNwI5gWmk6PSXwDLquggjL3kQS4T3d6zplBaLlYKbbV1CRLlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4S9kl5ccW/AneraCNB69tyNFPXiP8FSsM4qmqSyw6JE=;
 b=cTwmZEqwarwSuQsmZFUi3wNqZ2vr1eMIkSpDAdT7+YVLgiilHAEn0bIa2iMvxRpewtzUJW/Yz7vxivxOUW7P3dIqtMZ132IfsDgTOJKhlpCL7b/bm5s3592a8oiLFbgZnIU2O2YM+vy+ZKDvnMACCaazV413d8bSEKB6v0i6Y8vaDgV/HRDegCAooBsaXESxpJ2Qkq5wmhydTUznr12bY5x0kxtTUVQkNzL5fckMGr8pEvHGYLOz0CNOBPfmJNeMf7MYi9gY9ZXXyHCHLBTDdX/kajuTXyV18w3CGJcW0te1DILsPqmP8WrvuXt2809L3fy6Ix8rYNwEuKJJmqVdVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by SJ0PR11MB6816.namprd11.prod.outlook.com (2603:10b6:a03:485::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.29; Wed, 25 Oct
 2023 13:49:55 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::ea04:122f:f20c:94e8]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::ea04:122f:f20c:94e8%2]) with mapi id 15.20.6907.028; Wed, 25 Oct 2023
 13:49:55 +0000
Message-ID: <b867fba0-ccdd-7020-7bf9-6572aa9dd408@intel.com>
Date:   Wed, 25 Oct 2023 21:49:45 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v6 02/25] x86/fpu/xstate: Fix guest fpstate allocation
 size calculation
To:     Sean Christopherson <seanjc@google.com>
CC:     <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <dave.hansen@intel.com>,
        <peterz@infradead.org>, <chao.gao@intel.com>,
        <rick.p.edgecombe@intel.com>, <john.allen@amd.com>
References: <20230914063325.85503-1-weijiang.yang@intel.com>
 <20230914063325.85503-3-weijiang.yang@intel.com>
 <ZTMdyR8e63sCTKWc@google.com>
 <e02b39c1-96aa-faf9-5750-4c53b5a5fb46@intel.com>
 <ZTfxly8573xdnruS@google.com>
Content-Language: en-US
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <ZTfxly8573xdnruS@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR02CA0045.apcprd02.prod.outlook.com
 (2603:1096:4:196::21) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|SJ0PR11MB6816:EE_
X-MS-Office365-Filtering-Correlation-Id: 6a2b32d4-792b-4c5f-9d65-08dbd5614531
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OnfGOQ8pSkNmEiyBgqmszKkT9yZiCq8PT/qOdcmd4KZLVduzli7cICAEn8xBR11cHxKGBsFHo1Dls6Tr6N2NIaEqv9V6sTXFmDDaWF90Tp4G+NHj4cJDIjnHO0l2aT2d9FuMaILHqFoGcrhcT8J8OM4FE9nnNxn310282pg0KDC8zT4UYUpMOKoi9mOmpGSwKoSX/Jp6JBZ69hkUvhjJ43ckwBXjGIrXV4dxhc18NaJmWvgkZGY5CyAcFODA78/vT5lFuJ10FLhpQ2gjPH1EifaxSme24eLBLCe6BSzUi2YUKtlzAMZzs1dXRQd558Wm+0AWqYJHOeH7UgcrYMeoHbgrKZ7oKpxTvqEVcJ9crOF+nS4DX640OlboS6gLthr0U3YS2GVn+R8TGuNG9efSGUt3Zt+ajvQZ4NgbJI9JuOCChAkkf/18IBwOTQeJ589sFuLX0wUOE8OvMIav5stM4y+v2iUlghA5CiDoPhgh8mC7wzFgeToZxTGs06ApF8LXcCTjnYWL3blCWW7S5vOd5LUYDVpAm4U+x8Zu3l5gaVfqkHqB3NJGLLruwg+D9HjYfgbLNhCKLuUvzG8MXw8tI0PP0wcwaPz3mbSXS5pCQ1A93TuXXMEOmrSUCWNIy+OnHMjgC2DbCu1WcRkgzzGB7w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(346002)(136003)(366004)(396003)(39860400002)(230922051799003)(451199024)(186009)(1800799009)(64100799003)(26005)(31686004)(38100700002)(2906002)(41300700001)(86362001)(31696002)(5660300002)(8676002)(8936002)(36756003)(4326008)(478600001)(2616005)(6916009)(6506007)(66556008)(316002)(82960400001)(66476007)(53546011)(66946007)(6666004)(83380400001)(6512007)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VGdpSVlqZWRVT3V2RGJWL3dpT0FMa3VPZ2U0MDYrbGVvWHRTVXFsajBaRGly?=
 =?utf-8?B?elNBQ25mblBNaFhSL0NCSklCRkUzeWxodWpQbVRVc3ZKQWNGZWJFV2hHNnBk?=
 =?utf-8?B?S3BQWm5kcWJEU1BIK1NKQVJNbVV2WndSTlVuRnNDenNYd2hnT1ZOa1JhZWpT?=
 =?utf-8?B?Z09VNnNRQUtvMWxBL25ibEd6T3FaUHpFR0FZRG9Fdk95L1QvVkZOVnlqTTRJ?=
 =?utf-8?B?LzFFTmFlNWYzdFhsbFhMNHBLUVNXZ1AzZU9ZelNtMTdVZWtCdWFLR0c2djMx?=
 =?utf-8?B?ZnRzWXFDRlh3SjdtdHZ3RHBJZzFUOU5ISGlWd0Z6SDFjc2hsdE9OeVR1cjhy?=
 =?utf-8?B?RERSdFE4RisvUnB6ZFhCQTY4QjJ4YjcrVzZGK0lZMk5vQ1V0UEMraFJJY3k4?=
 =?utf-8?B?VHE5MXlYOFZMUDVlRGJ6clpuckJNczJFTTZTMUkzZkwvaVhITGszTHUvenRV?=
 =?utf-8?B?anByZEZ4dWdTL0xkRm1PVmNMcytrZVk5TURKQ0daZWUzZEdvd2xXcVhXUUln?=
 =?utf-8?B?TVRJMGM4ZE83WVpxQVZFbjVlQTJHUUlYcGpSSVNtUkMxNFdPM25PblN6U3Uv?=
 =?utf-8?B?RWdRb1BkZ2VJZW9UWUY1V0tKL2hiZ2lIWmdzcXlFNmxZOVdDK2x0QVZneWxE?=
 =?utf-8?B?VVZPZ3hSQU5NMHpDQ1cvSjdBWitmQ2ZVVUUwYTE4bEZtb09uM0Zlc3ByWk9T?=
 =?utf-8?B?RGs0RHdEb3k3Tnhxd3BhTCtEL2RJK1FlcUhQczFnYXlRT1lodi9NcXE1dTNp?=
 =?utf-8?B?eDVLQkRtK3NyK202U1ZCWmgyZENzWXVFNkNCejdhMVdvY0JyYk1hZ0swSnRo?=
 =?utf-8?B?ZDhjODlRT2oxOHJ2ZFgyWGpWOHdVancvQjR3TFVwN1RpaDgxV1NMVUtCQnI4?=
 =?utf-8?B?WWRrZzZKcE5DZHlUd2lHazZyL3B4L3d3UEJjSmhOcHUyOHcvZ2RzTlVPRlkr?=
 =?utf-8?B?UEZUV3Y4dnphQUJ6a0c3aWpiWE90dzl1b1lSdWZIcEpRYjl0Mjg5RWJtUDhh?=
 =?utf-8?B?VDI2Y1Buc2Y0Z21kV1hmakZLclltV200UFNVM2VvMUpuTW1lZEk4a1lTUUpq?=
 =?utf-8?B?cmg0SWZjSmYxbDBEN0ljem5EbmxDVS9wMWQ1K1RSRjg1U1RsY3JHa0VWT2xO?=
 =?utf-8?B?T1F5NnBxNEFJVnRzZmpLelJnN1VNNXFQZmtSMHRNUjEybFNDQmhwT0xBcFdI?=
 =?utf-8?B?dTFvbEJkc29JTE1PTjVUK002WWdNWWRFUGhJYmIxV1hiaEg0MTNyNUk3ZEFU?=
 =?utf-8?B?MkJ5b2c0bGNHa3JDQk15R0tEbW01OFkvTWFkNXB4Y0RXR2YrR29CVHBzdnNl?=
 =?utf-8?B?R2Fhd0Zad2NkVkdOTlF6ellWTHhwQjVqTVpmcUs3bEJLaUgrUk9kdFhaQXNS?=
 =?utf-8?B?OWVSdmFkWkZwZWFzYzQ2Wi84b0RPL0pxKzVLNGpzNmo0M1k0RDBHNG9lV3Ez?=
 =?utf-8?B?WjJZcWhvWENjMzFqZnZKOUwyVEVpWFhpdWFSQ2xwTmJIZGFkSFYyNEZqeHJD?=
 =?utf-8?B?bE5jSUYvL3lDMTNlbVlKTENYMTdsZUZwcjdzTlluNWJEUUYvdmFqemdTK3Bw?=
 =?utf-8?B?YzBGMzAzbm96UnJadUJJeFF3VDhra2N3MGVvWStmaXpxN2EzLzdaTW5QMTE4?=
 =?utf-8?B?b2k5UjlpSHl5c045eWtydWxNemh6a3FYanVCNnRNbm1RZ3BabzNadUlxcTlv?=
 =?utf-8?B?b3p6UDBSbnVKaFVDL0NEUTFQTVNRbnQ0bjE3NlpYWTYzWDR6eDZQNWpGQ0pi?=
 =?utf-8?B?ekU3Q0dLQW4yVFZ0djIxbHFzdXhQLzVJb0pxS1JjcXNHK1BGK1BxbGVOR3ZP?=
 =?utf-8?B?aVNwUVgyS3JuRG1HdVd1eGdyOWtLWjZucmh5SkhDYTZhbjNJamdOWUtlbmY1?=
 =?utf-8?B?eWlvSUd1c3ZXazg5QTlvQTArcnhYWVlvSG11aG9QTHJOYk5BYjVIOTN2S0tN?=
 =?utf-8?B?dGIyTFl0bzhtZXdXWW1EQmQwSFU0cTRnTGI3V0N1cjY3ZW9pMEh5U1k4WXVs?=
 =?utf-8?B?U1NBeXNrZlNacW41Z3BRL25nSzFSY0NWTld5T3pxQ3czMG5HQ2xDbHpGMWtr?=
 =?utf-8?B?a3lCcVJmQ211TW5YcjJRVUx0ZHRtUXJ1YWsya1B5Y0hPcmFVeWJYZ21LaXdS?=
 =?utf-8?B?aXdhcDNIcjBURDVHN2VvV1ByM01Tb0FvVGZ2NXo5Q0tBYmdNWTZOL05qQW9R?=
 =?utf-8?B?anc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a2b32d4-792b-4c5f-9d65-08dbd5614531
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Oct 2023 13:49:55.6874
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vyimz4qSjmAGlLaIq/OHeQhnFFXfUseVLHe1zmgBcrH6t2yCjmj8anEh1MWsZmlY1wbkOx4pTyuc0mUbCM14pA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB6816
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/25/2023 12:32 AM, Sean Christopherson wrote:
> On Tue, Oct 24, 2023, Weijiang Yang wrote:
>> On 10/21/2023 8:39 AM, Sean Christopherson wrote:
>>> On Thu, Sep 14, 2023, Yang Weijiang wrote:
>>>> Fix guest xsave area allocation size from fpu_user_cfg.default_size to
>>>> fpu_kernel_cfg.default_size so that the xsave area size is consistent
>>>> with fpstate->size set in __fpstate_reset().
>>>>
>>>> With the fix, guest fpstate size is sufficient for KVM supported guest
>>>> xfeatures.
>>>>
>>>> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
>>>> ---
>>>>    arch/x86/kernel/fpu/core.c | 4 +++-
>>>>    1 file changed, 3 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
>>>> index a86d37052a64..a42d8ad26ce6 100644
>>>> --- a/arch/x86/kernel/fpu/core.c
>>>> +++ b/arch/x86/kernel/fpu/core.c
>>>> @@ -220,7 +220,9 @@ bool fpu_alloc_guest_fpstate(struct fpu_guest *gfpu)
>>>>    	struct fpstate *fpstate;
>>>>    	unsigned int size;
>>>> -	size = fpu_user_cfg.default_size + ALIGN(offsetof(struct fpstate, regs), 64);
>>>> +	size = fpu_kernel_cfg.default_size +
>>>> +	       ALIGN(offsetof(struct fpstate, regs), 64);
>>> Shouldn't all the other calculations in this function also switch to fpu_kernel_cfg?
>>> At the very least, this looks wrong when paired with the above:
>>>
>>> 	gfpu->uabi_size		= sizeof(struct kvm_xsave);
>>> 	if (WARN_ON_ONCE(fpu_user_cfg.default_size > gfpu->uabi_size))
>>> 		gfpu->uabi_size = fpu_user_cfg.default_size;
>> Hi, Sean,
>> Not sure what's your concerns.
>>  From my understanding fpu_kernel_cfg.default_size should include all enabled
>> xfeatures in host (XCR0 | XSS), this is also expected for supporting all
>> guest enabled xfeatures. gfpu->uabi_size only includes enabled user xfeatures
>> which are operated via KVM uABIs(KVM_GET_XSAVE/KVM_SET_XSAVE/KVM_GET_XSAVE2),
>> so the two sizes are relatively independent since guest supervisor xfeatures
>> are saved/restored via GET/SET_MSRS interfaces.
> Ah, right, I keep forgetting that KVM's ABI can't use XRSTOR because it forces
> the compacted format.
>
> This part still looks odd to me:
>
> 	gfpu->xfeatures		= fpu_user_cfg.default_features;
> 	gfpu->perm		= fpu_user_cfg.default_features;

I guess when the kernel FPU code was overhauled, the supervisor xstates were not taken into
account for guest supported xfeaures, so the first line looks reasonable until supervisor xfeatures
are landing. And for the second line, per current design, the user mode can only control user
xfeatures via arch_prctl() kernel uAPI, so it also makes sense to initialize perm with
fpu_user_cfg.default_features too.

But in this CET KVM series I'd like to expand the former to support all guest enabled xfeatures, i.e.,
both user and supervisor xfeaures, and keep the latter as-is since there seems no reason
to allow userspace to alter supervisor xfeatures.

> but I'm probably just not understanding something in the other patches changes yet.

