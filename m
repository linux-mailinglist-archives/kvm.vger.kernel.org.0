Return-Path: <kvm+bounces-290-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B78F37DDE5B
	for <lists+kvm@lfdr.de>; Wed,  1 Nov 2023 10:23:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DABE51C20BCB
	for <lists+kvm@lfdr.de>; Wed,  1 Nov 2023 09:23:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 769117480;
	Wed,  1 Nov 2023 09:22:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NVZWQaWb"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 446AB746B
	for <kvm@vger.kernel.org>; Wed,  1 Nov 2023 09:22:55 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.88])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEBEA98;
	Wed,  1 Nov 2023 02:22:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698830570; x=1730366570;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=3SrIkXX0HNvcMvBInnN+hF624nAFxK8VxZnMpPz+OCk=;
  b=NVZWQaWbcP04pTo5Skai1HHjTPvcG96dVOIzB8EeKiqpjAKb2dPmr7fd
   5TjBEi4Ewiur0fzMXiGj9xZdC3+6UoN+eSZzqhsnNCz7ktvxoCamQuMe8
   oMM67639p/GfVtZxutpZp/2/mXDA+4evSyDYOi63LHqQ2siH1qTyDBYit
   kpFcjHbBhRtnV5PDslLc2q/rmIOCcN4VCu8POQmk9EO69wByt15v5CRNU
   +xvclXLy/+/4yCy2I9zNHSg70H+3Rei+ZGPajdmvntgBOnl55vgNXP+qt
   cgZBHHXj+0/M4xympWghui4TVm2c85j3H5SJH3vRmNG1Hp7RUrSQTxLrG
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10880"; a="419581589"
X-IronPort-AV: E=Sophos;i="6.03,267,1694761200"; 
   d="scan'208";a="419581589"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Nov 2023 02:22:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10880"; a="1092291812"
X-IronPort-AV: E=Sophos;i="6.03,267,1694761200"; 
   d="scan'208";a="1092291812"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 01 Nov 2023 02:22:49 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Wed, 1 Nov 2023 02:22:48 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Wed, 1 Nov 2023 02:22:48 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Wed, 1 Nov 2023 02:22:48 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.101)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Wed, 1 Nov 2023 02:22:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BHnNRlG75mdvqkvonPsm1vdTjCGfK1Gui55m7a7gF9BzC3dRRv/ZNYPid1aZV9ShAp2QiDGXL2HMlcOV7f85S8qyfZswOWGVeiwY2oL5LTyu5gSI48icLoJ2ylkGDF962NWJ8v5YAClspT0x6hqUIBIetTwnwqzcdwptbyJky0c/L2ZlM+Bph+fuAK6+8V95C5zdn2u4sHSfA7FBQdHYqErBLYfuyZ4hevjeCZSHMbgwOJYnymecOc3FFHcGBp83Mm4eagyu8QmANLq7NAuW16JIhwfpF3XU1lPqjaRDsvAsXwT/bOeQnR7Bk51bJFPgAg+pcJq75kB0UHoba9sIYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yCLcH9Tqr2OW+d7Xc57GYU70mFBjJAW+dnpUgX4b2BI=;
 b=U746IzDrzHq5lV5EDaYWT9ATLTjcMkvXX/exJCcLaeOOrGHX5DuO2HBRxkjYQ76AV5lMvULyHIawGLg1zXoBE9PqG5Z3bcLmGkSrZ4J+9eE7vQTI9cC0QfVx60rSusTa+cJkcT9LvRaWAA1h5H3XZTGOdJPNa7LfOswod/26EVXEIick4PBiU87Bxk0IwcHE1LkzEB0G52KlauMV546czR9fMVopy24ljUHvm8kTGukfNrNbEqaa+efDd3Eltvl9l7ZevccEXSaQM1hgno8ysarmR4kxxBPUucBMeGUFyZ7o3yGpjTT3Z4rl69zg+950VAbSjne1af8/Tzwy2nrZzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by DM6PR11MB4612.namprd11.prod.outlook.com (2603:10b6:5:2a8::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6954.19; Wed, 1 Nov
 2023 09:22:39 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::ea04:122f:f20c:94e8]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::ea04:122f:f20c:94e8%2]) with mapi id 15.20.6933.029; Wed, 1 Nov 2023
 09:22:38 +0000
Message-ID: <b9fac2d4-61f3-b704-fb43-d3e012239d72@intel.com>
Date: Wed, 1 Nov 2023 17:22:30 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v6 25/25] KVM: nVMX: Enable CET support for nested guest
Content-Language: en-US
To: Chao Gao <chao.gao@intel.com>
CC: <seanjc@google.com>, <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <dave.hansen@intel.com>,
	<peterz@infradead.org>, <rick.p.edgecombe@intel.com>, <john.allen@amd.com>
References: <20230914063325.85503-1-weijiang.yang@intel.com>
 <20230914063325.85503-26-weijiang.yang@intel.com>
 <ZUGzZiF0Jn8GVcr+@chao-email>
From: "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <ZUGzZiF0Jn8GVcr+@chao-email>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR02CA0132.apcprd02.prod.outlook.com
 (2603:1096:4:188::15) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|DM6PR11MB4612:EE_
X-MS-Office365-Filtering-Correlation-Id: 9e55dfdf-cbb3-4984-c864-08dbdabc1778
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +ZoAuKiT9l1sAsyfCGd8n/OZ1L32PFRIPIv4jouvxqO5+PNGnKeoJ8z7uGdtyu5WDQb1CEEje7rNgYxMi9uKvvVTy1ks0GZCxZ4aeBfvxGpoVGon3tgfHYN/NPQfFsCGzp0uSycLQJMY55qHb4hA1yurkZS7ITwPZbsOb7Dz0m1NKzwV38dgq7Rf8dEPeNlRPpdQUXP/GnQFgY6jVTYxvXcpDoQcnX0GmuvmiGxDQBHxHj32znDShCc1n2GLi6cEuk5YubF3UHZW9m3nQYkW2d6aQ3P88E3xOHQHJRHqyA3a2DRGiZLiEXDkkxloi4tLhn7MVNpxTTCprIVFsCpac8TF/4J3to1z68QANv6KQm+Doa0RMgO4WwBF/Dz8iERXJlWX0DjZOsq+6bmeoWw5cNK91Mmwf8ukNGrVqBdtEG9CKC2QAVEbv7Hm6+fU8jo8UBpZeEWw5vd69H5WneAIm3skMZIOsrVU5YUr6JGNZo/O9nYEQsI/qECLiKO9Sq2/AnaX8cTnW5igZrtSkKeCvjgeLaIkZV3U1R38oz1PR3LYWQeT5sc4EJrg/cth++77Z98sWCADrVu7h1QCI7DHhdm2bn94mUQ5BCqwxtYCxcyn/8nm47ZoclgCUtmJEMZVznbrkdTjh95pn7kmJJNQow==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(366004)(346002)(136003)(376002)(39860400002)(230922051799003)(1800799009)(451199024)(186009)(64100799003)(86362001)(36756003)(41300700001)(53546011)(478600001)(6506007)(6512007)(38100700002)(66556008)(66946007)(5660300002)(6486002)(82960400001)(8676002)(8936002)(4326008)(6862004)(6666004)(31686004)(2616005)(316002)(37006003)(31696002)(6636002)(26005)(83380400001)(2906002)(66476007)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NUZLdHJYM3FhbW1Nc3BoNjN3QWdFMFlxK1d6eEJhaGdHNG9qVkE1MkJ0VW9F?=
 =?utf-8?B?Mzk1NWhMd3NuRVJJU3AxNDRYT2lwbVBLRlBRQjZkQWpCTDhZbXpQc0RPQm5C?=
 =?utf-8?B?a1oxY0RpcEtPMDAyTm9GTXM5MGRaZ29wUUJHWFhuTm1pYzNPUGUwZFdzblNa?=
 =?utf-8?B?UzhnVzVXUzNiUkdBWFd4VHRXTWNPY0dJVXIvWUwrT3IraVM0d3Z0NHFEdGNQ?=
 =?utf-8?B?TGR4d1BCQTJsOGlPUkc4M2FzSnU3c0JobWZRbnZESWFHRzJNeWtsLzJDWUJs?=
 =?utf-8?B?UFVKczNFeVVwRGNnSGNvRUtob3Z6TGZIWkpzMStHeGVreHg4dUd5OHFhSE93?=
 =?utf-8?B?TzZXbkprM3E3aDVtWUxzRTdJSXJLWUorR2M4REdnV29zajM3bUZ6OGN6YUEr?=
 =?utf-8?B?N2ZtUGtSRmxGK0NldjJuaytja1lpUGg3aHQ4RmNhem9YTkl4a1cwRkFyYmlF?=
 =?utf-8?B?NDk1RDdBa0srQlQrL215bktPYnFHL25hK0FSMXZvUmg2Yk11ZjI0aERWZG5T?=
 =?utf-8?B?SU0vc2dwb2UrajdFdi9VUG5KbHl0WWZ4WWlMNFdHbnFRSWJGRUJyR2lSQkc1?=
 =?utf-8?B?UjRNei9LL1dzWTE3RWJtSGFnM2VOSDF5Y2JNM3Y2N3JtL3N3UGI3aTFsd1ho?=
 =?utf-8?B?S1dTbGZVSnp3MzUrRGlRV2ZZZWNWYVQzWUlEa3hQbVF0T2ZIV0x1Nm52WTI1?=
 =?utf-8?B?b01GUzJhNldWVmIrU3l0bG45NHJJMG9ucEdVTFdnT3ZraDZuTUE2amxtNmJ0?=
 =?utf-8?B?WTdySWhnaXZSRkNucloyeG01TllxZE9ROHZGWm5JWk5rQmszeXBHR0s1dkFV?=
 =?utf-8?B?bmJzbGtFOGJjcEd6aU1USnhVY2RFWnlsRWwrZUE5ZTV4UEFjYmlVbnhjK1Nt?=
 =?utf-8?B?WmM2WUFWWCtEN0VWZjBqQ004QjBlWFozdzE1RlIxcXFtbEhlSzlUVlQ5MlFq?=
 =?utf-8?B?eHpscWFwdXhMSy9Nb0VvZ3MxOFdsU2FCMm5HbVk3UUNSbnREajlnWWpsTFdT?=
 =?utf-8?B?OHUveHdGQkl6QVNHMm4zU1A1M3ArdHkxWXBRbDhReEIwckExQjFpWVgvVVNa?=
 =?utf-8?B?Zm54LzE0SWk3MVlaMEc4cEY1WWtWYzl0ditUTUE5WklMNTRKazdGeUM5WG1h?=
 =?utf-8?B?VUkxWDhQUWxUc3o4M25hSzEwaFBaSWdiZXJ5MHgxc2hXS1hIYUtTeUp2WDMw?=
 =?utf-8?B?WlozT1FTRVBEcDc1Z2puK1kvMlkzYlpIT1VlUTFnZVFaMy9UK09CcGFnS2ov?=
 =?utf-8?B?MHhoZjVjMW5ScnpETUNTSE9vV0J6Ym93ampJeHdMVzlrbVBzZ3RsSCtvdmts?=
 =?utf-8?B?MDMrNTJXV0NBbjJodjFwbFdiczhLZWNnTkRPSG5VRVp1ZTRJRlFXRUhTU1Uz?=
 =?utf-8?B?NXVmUnF6UHU5VXFhSWFCQ2FpdWI5QlBuVG1xTFdEbUV2VFFERURrWVdhRU5B?=
 =?utf-8?B?MHk1d2lhQnh6c3dQQjVydmJzeFB0UDVmdDNTMzJERDZhWEcrZGF0S0NoOC9v?=
 =?utf-8?B?clhvNmNQNUdoemlOZDY0b2ZiK1ZGQ083UU0rb3RNemdUN3dEa3NBdUJ5SVRC?=
 =?utf-8?B?T3F3eFRoaEJVU1pyKzF5ZUN2d1JJWndIbUZpTkdXTGtYVS8wSzYxZHhFY1Fh?=
 =?utf-8?B?djVJOTg5cDFLZnRzYmxnU0N2aFRQR21pVFRoQ2I5YWlpMFBmaWFxc0ZGN1Z5?=
 =?utf-8?B?YnovSEdtRlNUY1JTRzQwU1M0MFJJK2pSaTRId3M3SmxYNUpVNzdYZ2VOTnha?=
 =?utf-8?B?RmU2WG03NlEzdjhKaDJjL2FZM1FRUytBb1BjV1lDeE5sQ2lsSVg5Q0tQSTJC?=
 =?utf-8?B?Snc2OU1IK2FXbE1rNWpYSUNVZ1lPRGd0TXlJM1VBUlRFcHBFVHJrdWMwTVc2?=
 =?utf-8?B?N2pyNEsxTXR4NWRMaFp2MDEyUWdQY3p6VTA2ZTk5czBmeFlxQ3ZHMTJUWWox?=
 =?utf-8?B?d1lCVVU4dUNabEpjWU13VE9WS0JrQXVibVNIaGlnNTR2emp3SkMweEliMGhi?=
 =?utf-8?B?NVg1WXNIQzRoWUU1U2ZSeG1STERZc2RnbVN0K2V3M092endWSGFzRjJpSGdL?=
 =?utf-8?B?ZXhlZEN4WkZlMEZKbjM1SEZLYndQMTBKSkM3L2Jzdjc0MStsZ2hoTXZYM3FH?=
 =?utf-8?B?YnJkWiszenFObUtXZjdkTDZlbi9xRFV2bkRhcy8rUzAwMzNOZ3hzdlV4ZHJq?=
 =?utf-8?B?M2c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e55dfdf-cbb3-4984-c864-08dbdabc1778
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Nov 2023 09:22:38.8352
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AKbpGsg9IyfCDcwN1sG4ywEsAiVVZXosZq4c2TfrtjX4idc06L5QCm46nCMqUBo0OIeRMnpGHhy1jByybHmbHg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4612
X-OriginatorOrg: intel.com

On 11/1/2023 10:09 AM, Chao Gao wrote:
> On Thu, Sep 14, 2023 at 02:33:25AM -0400, Yang Weijiang wrote:
>> Set up CET MSRs, related VM_ENTRY/EXIT control bits and fixed CR4 setting
>> to enable CET for nested VM.
>>
>> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
>> ---
>> arch/x86/kvm/vmx/nested.c | 27 +++++++++++++++++++++++++--
>> arch/x86/kvm/vmx/vmcs12.c |  6 ++++++
>> arch/x86/kvm/vmx/vmcs12.h | 14 +++++++++++++-
>> arch/x86/kvm/vmx/vmx.c    |  2 ++
>> 4 files changed, 46 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
>> index 78a3be394d00..2c4ff13fddb0 100644
>> --- a/arch/x86/kvm/vmx/nested.c
>> +++ b/arch/x86/kvm/vmx/nested.c
>> @@ -660,6 +660,28 @@ static inline bool nested_vmx_prepare_msr_bitmap(struct kvm_vcpu *vcpu,
>> 	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
>> 					 MSR_IA32_FLUSH_CMD, MSR_TYPE_W);
>>
>> +	/* Pass CET MSRs to nested VM if L0 and L1 are set to pass-through. */
>> +	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
>> +					 MSR_IA32_U_CET, MSR_TYPE_RW);
>> +
>> +	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
>> +					 MSR_IA32_S_CET, MSR_TYPE_RW);
>> +
>> +	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
>> +					 MSR_IA32_PL0_SSP, MSR_TYPE_RW);
>> +
>> +	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
>> +					 MSR_IA32_PL1_SSP, MSR_TYPE_RW);
>> +
>> +	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
>> +					 MSR_IA32_PL2_SSP, MSR_TYPE_RW);
>> +
>> +	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
>> +					 MSR_IA32_PL3_SSP, MSR_TYPE_RW);
>> +
>> +	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
>> +					 MSR_IA32_INT_SSP_TAB, MSR_TYPE_RW);
>> +
>> 	kvm_vcpu_unmap(vcpu, &vmx->nested.msr_bitmap_map, false);
>>
>> 	vmx->nested.force_msr_bitmap_recalc = false;
>> @@ -6794,7 +6816,7 @@ static void nested_vmx_setup_exit_ctls(struct vmcs_config *vmcs_conf,
>> 		VM_EXIT_HOST_ADDR_SPACE_SIZE |
>> #endif
>> 		VM_EXIT_LOAD_IA32_PAT | VM_EXIT_SAVE_IA32_PAT |
>> -		VM_EXIT_CLEAR_BNDCFGS;
>> +		VM_EXIT_CLEAR_BNDCFGS | VM_EXIT_LOAD_CET_STATE;
>> 	msrs->exit_ctls_high |=
>> 		VM_EXIT_ALWAYSON_WITHOUT_TRUE_MSR |
>> 		VM_EXIT_LOAD_IA32_EFER | VM_EXIT_SAVE_IA32_EFER |
>> @@ -6816,7 +6838,8 @@ static void nested_vmx_setup_entry_ctls(struct vmcs_config *vmcs_conf,
>> #ifdef CONFIG_X86_64
>> 		VM_ENTRY_IA32E_MODE |
>> #endif
>> -		VM_ENTRY_LOAD_IA32_PAT | VM_ENTRY_LOAD_BNDCFGS;
>> +		VM_ENTRY_LOAD_IA32_PAT | VM_ENTRY_LOAD_BNDCFGS |
>> +		VM_ENTRY_LOAD_CET_STATE;
>> 	msrs->entry_ctls_high |=
>> 		(VM_ENTRY_ALWAYSON_WITHOUT_TRUE_MSR | VM_ENTRY_LOAD_IA32_EFER |
>> 		 VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL);
>> diff --git a/arch/x86/kvm/vmx/vmcs12.c b/arch/x86/kvm/vmx/vmcs12.c
>> index 106a72c923ca..4233b5ca9461 100644
>> --- a/arch/x86/kvm/vmx/vmcs12.c
>> +++ b/arch/x86/kvm/vmx/vmcs12.c
>> @@ -139,6 +139,9 @@ const unsigned short vmcs12_field_offsets[] = {
>> 	FIELD(GUEST_PENDING_DBG_EXCEPTIONS, guest_pending_dbg_exceptions),
>> 	FIELD(GUEST_SYSENTER_ESP, guest_sysenter_esp),
>> 	FIELD(GUEST_SYSENTER_EIP, guest_sysenter_eip),
>> +	FIELD(GUEST_S_CET, guest_s_cet),
>> +	FIELD(GUEST_SSP, guest_ssp),
>> +	FIELD(GUEST_INTR_SSP_TABLE, guest_ssp_tbl),
> I think we need to sync guest states, e.g., guest_s_cet/guest_ssp/guest_ssp_tbl,
> between vmcs02 and vmcs12 on nested VM entry/exit, probably in
> sync_vmcs02_to_vmcs12() and prepare_vmcs12() or "_rare" variants of them.

Thanks Chao!
Let me double check the nested code part and reply.


