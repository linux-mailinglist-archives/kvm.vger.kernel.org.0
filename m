Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57A7A75F8EF
	for <lists+kvm@lfdr.de>; Mon, 24 Jul 2023 15:53:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230479AbjGXNxi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jul 2023 09:53:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232041AbjGXNxW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Jul 2023 09:53:22 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5BDD46A0;
        Mon, 24 Jul 2023 06:50:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690206651; x=1721742651;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=4+U4cvwHqJNis3kW6F5xcfRq6Hkk+s7UstPUzKRK15s=;
  b=nk7Cn+eO1AXr5G/L1W4RUvdIie8m6gMK8AeA1xMt5nkAhfUYoQCIOMrg
   SAGwdM9B2vVkmy3GncgEZHdonqOhQoxC3kT3GEF+tFWG5Ok/g0QaO5yvi
   IwCYSvtrJhBGLtD5FRkGlhWb41R0L4t/v8QJ00BYQOoZKKmpvhJ7FXEP6
   duapxShVmPGICRG+y5i3ITJXCcnXQe0STaoFRVm61PzMITke+aOsDf6IF
   JN4apHUeWJYRQnGiEr3ZIzpmLlnUoaEguecMnUGDYEMA80wyZu0+RhcRP
   qz+IUOsyX4+7o1a/r2Ao3yQlwAUSJoaUENbe89R5cAaLcEw7mv2Db+3As
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10781"; a="398351336"
X-IronPort-AV: E=Sophos;i="6.01,228,1684825200"; 
   d="scan'208";a="398351336"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jul 2023 06:50:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10781"; a="702892652"
X-IronPort-AV: E=Sophos;i="6.01,228,1684825200"; 
   d="scan'208";a="702892652"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga006.jf.intel.com with ESMTP; 24 Jul 2023 06:50:36 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 24 Jul 2023 06:50:35 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 24 Jul 2023 06:50:35 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Mon, 24 Jul 2023 06:50:35 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.175)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Mon, 24 Jul 2023 06:50:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DFON3gIjjIKHvvkymJZLiPb20rqO0tmnoqKcqBGTOhkUOMDebiWiJeJdVQTnA9Aj785+Z5/pb8XYIOQpd01BVt6kup60MRbwE86ZVkZ2pKlDWD74QDgbtDEqnu3uefizIuobLB6dQC1njpeQyjDLzxtCnmhKgeQaXJxA9k59Fz0TklvlXBpzLVLlxPOJydh+NnePCwq5ZbrVYbAx9pFurCfPV69T9LJPoW47J1smRd+BKCpib6ICwxz31geBEjiAEacr1lvekBZS9+/SUFZM9lTJbI25+J+0dbbJrb+zHX2Bw9UxZ77C5ShKuRNYAWMBKHFt4vR8c/YkejhD8TrKrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MnTgULI/9kItQEuayTCGPtQ6MoqwmF2ISIqQyRVAWKw=;
 b=FSXQ6rrn/ShG9MsXO4ifuxrIrDjSY22+JtQ1oUSLK9ouoHgVW6i36JgDx5DShRXPpFhxrRSykB7DY4bD33Jb4giRILF1M06xBbb2x7xgVqeH3EHneDztkC3khG2g8bftV4VT7zd+6P1Z2K/+Mg7Elu+FQP5KEGK5R0xy5OsD25nC3adj8LXAkghIB+zMJsOmMmBud/nxwNsXt2nIj3VYQ+Mh4jU0FvfAoFqSe9XSRwzAw7BfmXGKNy7dTND3M1l+J6JKnQAoSqeFoXNTVNLmn7nU8gwCMBk7NG1Tjk9xX8+bkfOPCk+k2Ih5l1Ll9tvUYqNiOaFzL/vLMDWY0bE6Cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by CO1PR11MB5044.namprd11.prod.outlook.com (2603:10b6:303:92::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.30; Mon, 24 Jul
 2023 13:50:32 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::f99f:b4d:65e6:7d47]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::f99f:b4d:65e6:7d47%6]) with mapi id 15.20.6609.032; Mon, 24 Jul 2023
 13:50:32 +0000
Message-ID: <41d6ef7c-f184-54b3-d0cf-81a111c2192f@intel.com>
Date:   Mon, 24 Jul 2023 21:50:20 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v4 10/20] KVM:x86: Make guest supervisor states as
 non-XSAVE managed
Content-Language: en-US
To:     Chao Gao <chao.gao@intel.com>
CC:     <seanjc@google.com>, <pbonzini@redhat.com>, <peterz@infradead.org>,
        <john.allen@amd.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <rick.p.edgecombe@intel.com>,
        <binbin.wu@linux.intel.com>
References: <20230721030352.72414-1-weijiang.yang@intel.com>
 <20230721030352.72414-11-weijiang.yang@intel.com>
 <ZL410xRbInlQMc5y@chao-email>
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <ZL410xRbInlQMc5y@chao-email>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2PR04CA0164.apcprd04.prod.outlook.com (2603:1096:4::26)
 To PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|CO1PR11MB5044:EE_
X-MS-Office365-Filtering-Correlation-Id: a68147b3-f592-46e6-4e56-08db8c4cf253
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oOI6AbT8/Lny1NVAeLu9BdaeGBMs5vB4cqboJhptkWvhHlBPH2MD6hhF0BH2YnUDtKlLoo1ovKcmPhuSIDg3atvAK70otSd0dnPAB9cPZznV0DJjZ0FulIvHg+ib2ebBsLa9ZkKxynE/tvb3owZ8LT8nVDnuxTle7yg0ffsd87uRiEYTcpyYFBCnz/0v4veMR5N98KXhHJM0OviYvAD5HQE/5rMQxoMdlUsD0/Z0hID9BAun8kjtN9C/uyjJ8URsGrvaigT1iU6IZMO9cVclCIJuSBtlYZXkpOGEP+qVOfcHuJXuyaZ8AgeAPUh+JpFUQzOUC5SUi1kjKVV+JxB+fc7Dr7MUV3nTGW97KwyIKjdLwvChCniAGLIXmlerGXRD2SJ+uxJIUKEhysRQwGt6y+Qxg2zzcgrl0rBBguwwaL6eXYpIOhJNdzqVpHq9zGzvHexYZsQJqMoQLStivSUALhUbIQN2xrIGRN88UNax9kXq1GW3CVivoYu9z9WqfctH5vn8+oaTPOCLplkINqdA+7AKDp48lsjpDNyEe3E1aoBM9oQMO8nXY02Ez7YqhdVcLas8yVSnWXCTrpbtz1z7iGG7EzAJbhAajKJS8C/wQUaJK7jKJaS5GOzZCnY0wsBOKbx8zRNUSLB6I7io6NdiPA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(136003)(39860400002)(346002)(396003)(366004)(451199021)(83380400001)(38100700002)(36756003)(86362001)(31696002)(82960400001)(37006003)(478600001)(2906002)(186003)(26005)(6506007)(6666004)(6512007)(6486002)(31686004)(8936002)(5660300002)(8676002)(6862004)(316002)(41300700001)(66946007)(4326008)(66476007)(6636002)(66556008)(53546011)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Z3htQ2pPdG53d09CLzl6OVVmZXB4UXdRV3p0MWhYN3NLMHRMLzgydExCeUNj?=
 =?utf-8?B?Rmx4eG8yQ1dRRDFVLzJIbEduZ3ExS3hLNzdqWkJmODVoUElVWWUrVVV1N2Vs?=
 =?utf-8?B?eGwrZy8vM2pjdE12eXNqZWk2cTl5ZHd3UzRMVmxCa2l4SkJQOVgyN1BLa3JL?=
 =?utf-8?B?djZaaExPcDJVdHlGZ053dFNOTFZ6ZzVTU2RoViswYkt6VlFNd1lyZ1Rka3Z1?=
 =?utf-8?B?MDhZbmx0cU11RWdTa091RWQ3V20xcDRJQmpHckh2R2t0SWFad3NDbThqcEV2?=
 =?utf-8?B?bWkyd0YyMjArbWE4NVZVZTZSMURKWFRSTGEzQ0tGaHgxTXBmaGo1QXJCZXdJ?=
 =?utf-8?B?YmVJTGtPOS9JdVorK0J6MWFTMEU1Z2ExTFg2TGlFOWtRWUpOVGJteG9jazJB?=
 =?utf-8?B?ZEE1SEFjYU9oYkEwOFRQRUFLQUVaNkRVdFB6eUFIdEtjRDlNZm1ST2NSa0JG?=
 =?utf-8?B?alFoMXd0bXNmeExqYWl4OWVTQmJFQnlJMWJTZGVSdmlqdjJ5NGREQ3FOcDFQ?=
 =?utf-8?B?NmErdHdxRHhIaWlNaVd4SDRhcVJSREdMMTdqN2dZMUhENXRWenBTcldrZHFh?=
 =?utf-8?B?REFRSTJ5Ri9ubTBZSHM3QVBOeE4waCtnSi9aaGI5eVg4ajNZVjdjendqU2xN?=
 =?utf-8?B?RUcvaGRncXNxazliU2RxU25hbjFTMjhORkl0anFTWTFhRUFVVy9MRzl0a0ZE?=
 =?utf-8?B?a2VhNWhBK1E2OG9MbzNHK1lIdnpzTHdhdlVhWW1lRDZEN1Q1azVueWxpc1c5?=
 =?utf-8?B?WXlXaGdUbnBGcUFPRzE0ZmZEV25RYVJDYUdkd1N3WDVFYldIbkhUcFNtR0dz?=
 =?utf-8?B?a1hHdE9VMzdRNFczYkNvdUs1SC9US0NLbEowZEtxRFRJM1VlNDAvbi9rei9P?=
 =?utf-8?B?KzJSazJOcEtrQjh4SzdLZnBkUDZScnB5RFM3Y04vWkJncHVCNUowQnNKVFZs?=
 =?utf-8?B?SXRvbUJ2WjNtTzZzM0Roc09rRVhrOFdtMStHeWEycVZjNGFyNEQwWEU4ZGxp?=
 =?utf-8?B?WTk0Vno4dUpzWDFQOXBFL293UEtYTjN1cWdDRjZnYm9ETGxkSUIwRjN6c2Yv?=
 =?utf-8?B?ekZtRUcxYlJUcGdrd01sM0E4aHZyUUFsS0ZPV3REd3NVczFNZkg4MmFDb2o2?=
 =?utf-8?B?bStnN3UrVlJBTS9NKzQ3RmVwOU85bzBOOE14OVFBQTFDUEk4MVFjZlY4QTBM?=
 =?utf-8?B?OHhML25FeVdEUnAzMlRxNHRVN21aUWhLeVpING1XbHRZSG5oQzhPaEtiODZT?=
 =?utf-8?B?SFk2dzFvck52L3B4WDdkYTZ6bnN6Vk11N0Zzd29WaVdJSXU3MFk5YnNmV3Bj?=
 =?utf-8?B?N3lwTDJMSHM3b1pJUkF0aVRJWjUxV09VbG1BdnF5R3NuUmJBNjdDL1F4K1lS?=
 =?utf-8?B?d0V4UVF2Ykx4OU9PL1NWV3QzMHQyNU5xMnA2MVhyYmpxM25oeTBsWFQxSjBR?=
 =?utf-8?B?UHJjNkxFRlljb3k0Skl5ZEhJdi9hcnVkR29zRVE5U3lQaEc5SEw5UGJoOE8x?=
 =?utf-8?B?eGJkQ01CV3ZXZWx4YmFqR2hNZWhhWkloQ0NVVDhSWEh4aDBYaDJWNGZETzBh?=
 =?utf-8?B?SDF1dTAwTTRPYWJVQUZsL0VUMHRwdHB5NVFqY0hFTFNYSVpMaDMwa3FBUHBn?=
 =?utf-8?B?NDlxR1ZjbGlEUE13Nk1Kd3NycFR3RGdqZ255ZEJxdnVXQi9sbTFIUVdCSm5K?=
 =?utf-8?B?WklMVE1oNVllWmE1SG10U1Q5cWJVSDZoV1BLakduQU4ycUxEWHhldXFQSkdB?=
 =?utf-8?B?SjU4eE1VUzE0eDh2ZUtYQldYMElVKzZPOVVsM0tJVFBDZWN6R3ZDSHFHZVF6?=
 =?utf-8?B?N1Y2ekJsZ2dVSkpodjk3THNoOHRlWnhmc21OcEpUSG95UVc2bDVtbXZHSFMr?=
 =?utf-8?B?c0NBWmFOWUE4ZWE4aFJHWGx0bkhKQ1ZMZGsvSXhhT0VYK3BNTEJ2cnJmQmVz?=
 =?utf-8?B?YVd5UURHbXFOb0xKRXRic25sZmxaYzdoejRRbnFrYkRIV0ZSWGZXdVpWVTVk?=
 =?utf-8?B?TkdGZEM3TzVqbnZ5cVpYRGlBR3FJOHdLeU5xbGtnZWNNVnpTc3FTNS9wdWd3?=
 =?utf-8?B?aVkzRm5qNVY3QnZOSkRVem5DOGUxbWZBbHlwdStjQVdoSGlWeGVBWHJ4Y3Nl?=
 =?utf-8?B?dXBRK2FwajF6dDMrQWYvWEpQS3FXcXY4WXhvQzRuRE9DaHJHd0hUeE0vM2d2?=
 =?utf-8?B?L3c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a68147b3-f592-46e6-4e56-08db8c4cf253
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2023 13:50:31.7555
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YTGgMx8+1D83oBs3VHN+VwJampp1EhPZIBaAlgKqJRD6tM+SDJ3GYBjUPiSL7acNGH7RN7lvJ49Q3s3GKWTX0w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5044
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 7/24/2023 4:26 PM, Chao Gao wrote:
> On Thu, Jul 20, 2023 at 11:03:42PM -0400, Yang Weijiang wrote:
>> +static void kvm_save_cet_supervisor_ssp(struct kvm_vcpu *vcpu)
>> +{
>> +	preempt_disable();
> what's the purpose of disabling preemption?

Thanks!

These preempt_disable/enable() becomes unnecessary due to the PLx_SSP 
handling

in sched_in/out(). Will remove them.

>
>> +	if (unlikely(guest_can_use(vcpu, X86_FEATURE_SHSTK))) {
>> +		rdmsrl(MSR_IA32_PL0_SSP, vcpu->arch.cet_s_ssp[0]);
>> +		rdmsrl(MSR_IA32_PL1_SSP, vcpu->arch.cet_s_ssp[1]);
>> +		rdmsrl(MSR_IA32_PL2_SSP, vcpu->arch.cet_s_ssp[2]);
>> +		/*
>> +		 * Omit reset to host PL{1,2}_SSP because Linux will never use
>> +		 * these MSRs.
>> +		 */
>> +		wrmsrl(MSR_IA32_PL0_SSP, 0);
> You don't need to reset the MSR because current host doesn't enable SSS
> and leaving guest value in the MSR won't affect host behavior.

Yes,  I just want to make the host PLx_SSPs as clean as possible.

>
>> +	}
>> +	preempt_enable();
>> +}
>> +
>> +static void kvm_reload_cet_supervisor_ssp(struct kvm_vcpu *vcpu)
>> +{
>> +	preempt_disable();
>> +	if (unlikely(guest_can_use(vcpu, X86_FEATURE_SHSTK))) {
>> +		wrmsrl(MSR_IA32_PL0_SSP, vcpu->arch.cet_s_ssp[0]);
>> +		wrmsrl(MSR_IA32_PL1_SSP, vcpu->arch.cet_s_ssp[1]);
>> +		wrmsrl(MSR_IA32_PL2_SSP, vcpu->arch.cet_s_ssp[2]);
>> +	}
>> +	preempt_enable();
>> +}
> save/load PLx_SSP in kvm_sched_in/out() and in VCPU_RUN ioctl is sub-optimal.
>
> How about:
> 1. expose kvm_save/reload_cet_supervisor_ssp()
> 2. reload guest PLx_SSP in {vmx,svm}_prepare_switch_to_guest()
> 3. save guest PLx_SSP in vmx_prepare_switch_to_host() and
>     svm_prepare_host_switch()?
>
> this way existing svm/vmx->guest_state_loaded can help to reduce a lot of
> unnecessary PLx_SSP MSR accesses.

Nice suggestion! It looks workable. I'll try this,  thanks!

>
>> +
>> int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
>> {
>> 	struct kvm_queued_exception *ex = &vcpu->arch.exception;
>> @@ -11222,6 +11249,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
>> 	kvm_sigset_activate(vcpu);
>> 	kvm_run->flags = 0;
>> 	kvm_load_guest_fpu(vcpu);
>> +	kvm_reload_cet_supervisor_ssp(vcpu);
>>
>> 	kvm_vcpu_srcu_read_lock(vcpu);
>> 	if (unlikely(vcpu->arch.mp_state == KVM_MP_STATE_UNINITIALIZED)) {
>> @@ -11310,6 +11338,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
>> 	r = vcpu_run(vcpu);
>>
>> out:
>> +	kvm_save_cet_supervisor_ssp(vcpu);
>> 	kvm_put_guest_fpu(vcpu);
>> 	if (kvm_run->kvm_valid_regs)
>> 		store_regs(vcpu);
>> @@ -12398,9 +12427,17 @@ void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu)
>> 		pmu->need_cleanup = true;
>> 		kvm_make_request(KVM_REQ_PMU, vcpu);
>> 	}
>> +
>> +	kvm_reload_cet_supervisor_ssp(vcpu);
>> +
>> 	static_call(kvm_x86_sched_in)(vcpu, cpu);
>> }
>>
>> +void kvm_arch_sched_out(struct kvm_vcpu *vcpu, int cpu)
>> +{
> @cpu its meaning isn't clear and isn't used and ...
Yes, I should have removed it.
>
>> +	kvm_save_cet_supervisor_ssp(vcpu);
>> +}
>> +
>> void kvm_arch_free_vm(struct kvm *kvm)
>> {
>> 	kfree(to_kvm_hv(kvm)->hv_pa_pg);
>> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
>> index d90331f16db1..b3032a5f0641 100644
>> --- a/include/linux/kvm_host.h
>> +++ b/include/linux/kvm_host.h
>> @@ -1423,6 +1423,7 @@ int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
>> int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu);
>>
>> void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu);
>> +void kvm_arch_sched_out(struct kvm_vcpu *vcpu, int cpu);
>>
>> void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu);
>> void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu);
>> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
>> index 66c1447d3c7f..42f28e8905e1 100644
>> --- a/virt/kvm/kvm_main.c
>> +++ b/virt/kvm/kvm_main.c
>> @@ -5885,6 +5885,7 @@ static void kvm_sched_out(struct preempt_notifier *pn,
>> {
>> 	struct kvm_vcpu *vcpu = preempt_notifier_to_vcpu(pn);
>>
>> +	kvm_arch_sched_out(vcpu, 0);
> passing 0 always looks problematic.
Can you elaborate? I have no intent to use @cpu now.
>> 	if (current->on_rq) {
>> 		WRITE_ONCE(vcpu->preempted, true);
>> 		WRITE_ONCE(vcpu->ready, true);
>> -- 
>> 2.27.0
>>
