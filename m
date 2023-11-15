Return-Path: <kvm+bounces-1802-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 795B47EBE94
	for <lists+kvm@lfdr.de>; Wed, 15 Nov 2023 09:31:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9048B1C20A22
	for <lists+kvm@lfdr.de>; Wed, 15 Nov 2023 08:31:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 706CD944D;
	Wed, 15 Nov 2023 08:31:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FNkabxS+"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6401525F
	for <kvm@vger.kernel.org>; Wed, 15 Nov 2023 08:31:39 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.20])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF339DF;
	Wed, 15 Nov 2023 00:31:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700037098; x=1731573098;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=+7gQqGdK4ccBi5iG49UehUNCK/4aEKRAUlOU3Hj+V3g=;
  b=FNkabxS+2ryIkwoiIY1xO6cUC1Zl+FW7WmMagjHRYnFgTwyTbaO7m14a
   YZYfXMnrNGmMCLJukSZYv72LYWKI+9HeBGvi8gAuQ74OP1w6R4JOJySSh
   4JI8kp5dd9tr5fIVT0Fn3htI1etd9Dt5ePA5Pd9i9bU08mIAt2JVnRBa5
   HYQ1N/Qp6yLwQe0XUmSKhtH7/UVA7GsYvANpuzJjBqGxVozlM5u9Z7Rdk
   P+YQqQz899YzSDQN7Y0KCqRgxm1KvE92M3m5ZQrpgI9ITghAEw7gnSFln
   wLJpdYCz3/sLr1kIVbOVJM9aMvtpWsoPszXg55CAsL7/TQ5aoVZbPBWxk
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10894"; a="381231137"
X-IronPort-AV: E=Sophos;i="6.03,304,1694761200"; 
   d="scan'208";a="381231137"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2023 00:31:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.03,304,1694761200"; 
   d="scan'208";a="6087914"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 15 Nov 2023 00:31:38 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Wed, 15 Nov 2023 00:31:37 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Wed, 15 Nov 2023 00:31:37 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Wed, 15 Nov 2023 00:31:37 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.100)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Wed, 15 Nov 2023 00:31:37 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HxOVKb0QexL10V92Nv41LgZCSdDgL5jSPehyr0G7viNhfe1yGbrp2OctQuqW2aFa199Ygwy42FgJadKmion6/tqft0ek/562S7XDc+yZKA3vrqeD+1Bkupp3ZE8myLopattQeFAsWIPiyzeaUgSx7sOKeIPpkM4tij/o2AxY0u2jOoLgIagZDC3J4GGYY7av7IJMiALJW7Dbe8T3rzEJzM05L+pHaR1ld5OvEEsxZDAryojL/fgo/fJ1zfFUsMbPl0J0ZISfgwvdMPKMf/cr/szgWHIgIPUFTj51cmbXcQS71PEJyusvMaSEio0RVulpBzPUMkKlmVTAtb56Lsb4Hw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wEpZXNMaUCVc2kG0q8T/K9jG2wr11xklNgXamEDT5zY=;
 b=W37bSWuFY5YnnEBkMCVH6PbTTpqNFSi4ej5Bk6nx024qgrVGVxG9/vboMEoQSW3M3WmJVVIuqV1fGD6PSWJwD4NTZmSMdekh8DIuNvl1m24z3NAkaRrmvl/707qtOOYyhV48m/q3AoOucGJ57I3Ap2cHP/bzWFYa5h2r9iS12S+3MUeKFGBjw7jiNB6kIj5Dih++2oXtEVzbxZv+GmkbfgZ3sywXxY1ew89Hl+txqmTuTdTusFSYN5GZEYVWunI9mpTvBco9wt8FcVZFT2GpaY1brdeUGbSDQeqAsBdjsPATBLW8KHdxWu5E8+uzaO5eQiQdjew5luCTWN7+ljEB3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by DS0PR11MB7309.namprd11.prod.outlook.com (2603:10b6:8:13e::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6977.31; Wed, 15 Nov
 2023 08:31:35 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::ea04:122f:f20c:94e8]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::ea04:122f:f20c:94e8%2]) with mapi id 15.20.7002.015; Wed, 15 Nov 2023
 08:31:35 +0000
Message-ID: <d377806e-43af-4ac7-8e7a-291fb19a2091@intel.com>
Date: Wed, 15 Nov 2023 16:31:25 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 24/25] KVM: nVMX: Introduce new VMX_BASIC bit for event
 error_code delivery to L1
Content-Language: en-US
To: Chao Gao <chao.gao@intel.com>
CC: <seanjc@google.com>, <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <dave.hansen@intel.com>,
	<peterz@infradead.org>, <rick.p.edgecombe@intel.com>, <john.allen@amd.com>
References: <20230914063325.85503-1-weijiang.yang@intel.com>
 <20230914063325.85503-25-weijiang.yang@intel.com>
 <ZUHSTEGpdWGjL93M@chao-email>
From: "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <ZUHSTEGpdWGjL93M@chao-email>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR04CA0016.apcprd04.prod.outlook.com
 (2603:1096:4:197::7) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|DS0PR11MB7309:EE_
X-MS-Office365-Filtering-Correlation-Id: a00d6314-20f9-456f-1b3f-08dbe5b5470b
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KRC5ZZUgY1BPlI1X0v5B3BYAcpTOtyHGJCmsV8TKUVj/tMoVSU5Z6jOxWwuqCoZUdXwv+MBifwvDOM1UWsubC4b2Y3R1aDTA3L5eaNZFr4tXsH0VRczWqgZOAkssRSJq96ESd/gKUR8qQGBgvp0Tab2PxqQcWGtWpthMAuBac/Z4qlTIdiKNPiMxwEgrHkpMNDecmraSKK4GEALXw/30AX3iAB9txUcVH+gZ/lMOgNbL3Kvz0axqstdXalO+7XOJ+bQFYeFHlDSYLCsHVM08QorC44aZf2Qcrr36HGdo5Sziy5gMDZOr+7JMHfJSMSV12tzTTLITphBwlSpCZ9+zhsRo6sAUGFwyRcvLP2F0iH746Es4x5IpfO0qLejpUMMIhvOK/77KBiavP21vEZlerqodrEMT6H93Fefax9MXAW6gDNtsO2zDrTwH5LCfqPU0pzwBLWXGHOMer0PoiALy8NBU5cav/qS7KWAKqlZ+/THVCOxMngargCD227z+Z8qecZvc0F2elV9zzy7aLz7y86sPyGPNna2FHfjMphJc1aK4Izm9FcvGy7lnz8CQB0OSLcpU1JdyRa5JhQkox+OKmzioRzr9PGR+CmMFIJVgX/qHe7KhI6lN/lfqqlNNXq8/vzC3T9nywob8WxRQw/AV7w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(136003)(376002)(346002)(39860400002)(396003)(230922051799003)(64100799003)(451199024)(1800799009)(186009)(4326008)(6506007)(53546011)(2616005)(31696002)(86362001)(5660300002)(8676002)(8936002)(38100700002)(6666004)(2906002)(478600001)(31686004)(66946007)(37006003)(316002)(66556008)(6512007)(66476007)(6636002)(26005)(6486002)(6862004)(82960400001)(41300700001)(36756003)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dWVuRzh3ZERDMm9yajRBejhIVDdDaWE5dU5QamtmalVOaXRiWmhWRkQrVGRa?=
 =?utf-8?B?cFJFbXNKRkc5Zzl2ajNGSVg0L0NjVzVFczZvZCswMEpwSVdJL2lyV1JmQ2VQ?=
 =?utf-8?B?dGZJRUY3elZHdXdjK0ZzaGpDZFNrQ0dGZ3JwUEIzS3pRTkFXckdBWkVPU1lr?=
 =?utf-8?B?YzhYazF5ckplbGN1Wm44N1BDeXN5TGJOOGlQUGVtdVJILzFqeW5CanVzVXRZ?=
 =?utf-8?B?Wi9sbFhOcFZSUnBFeEVzVk16a05Xd0w1c0lOQ1FBdENCVk5adVppYW11R1hZ?=
 =?utf-8?B?WTNDTnNGaFlMeUgzQWtkR0F6RnFBQk5HRkxJWTNVWnJ1TkxoZTJoZVBwakY0?=
 =?utf-8?B?ZUgyNm03THo3d2o1Y2Q2d05HWHBxbWNrY20zVlBMa0hvMlhnUkFuUncyUXMv?=
 =?utf-8?B?UDV0MzJrb2o2QktqOW1vc0RPak5YS1VsMVVIZVpTemhkR0YxQSs3bFI5OGw5?=
 =?utf-8?B?R01BbDJsblAxckNMWXpBakZQaHI3aE5XM0RLSkUxV0JZTHRRVmxkZjFjUW5v?=
 =?utf-8?B?N0llTnVGeTRHK1FqekNFWnlVU1JqU3VKQzVBNzBtaDR5VDB6OWEranZwKzlq?=
 =?utf-8?B?RjlDR1BNSG1kUXEyOW9HRnNVTXFhUGRhZW9HMjFwZ2hSTmtqbVBObEljUTh2?=
 =?utf-8?B?NkNiSmRad1lhcnlqTzdmdUt2eW4yTzQvaUlkL2E1dFBOc1FjK2x3V0tHM1JB?=
 =?utf-8?B?VU84OHFEZUFUNGl3Y0FuWTM0ZVU5T3N6Q3c0OCtOMWZ6QXF2RURRbDRPSkFB?=
 =?utf-8?B?ZWNPa2RuMnZiZGZJMWs2WmcyYTVnOHJqRjlXLzE5YVF4SlZHeVRSSTI4ZXpv?=
 =?utf-8?B?ZE5OcWVMWGpuTDI5VG14dlZTV1c4ZGdBUVpBcUVnKzM2N203aXhCYUk2SXUw?=
 =?utf-8?B?WUZ3SlRHSFQ1Z0ZxMm9zdnJNNWlSMXN1NU9EYytPOExSQ3o1TjN0NUVkZWNQ?=
 =?utf-8?B?d0hsY1BDb2szaE42cnFQR2JVa21xcnIrSkgvUVFvNE95U3YyREZzMENSaWZZ?=
 =?utf-8?B?cC9tMDJhc3k3U0ZNQ2tvU3VaR2RkczNsYitoekd2dC91eHZYOWMvNVgxSXZX?=
 =?utf-8?B?ZzJjUy9WUjFEY1V2cXFOcmhIMC9IcWZBOW5mZzJxb1ZnVU9ubjhPdGR6M0N5?=
 =?utf-8?B?MnNOTGUwMXB0UzZFY2xWSThoRng0WmZUK0tjSWp3OEkxeVpZRnQwWEd1SWo2?=
 =?utf-8?B?ZUMxOXZMbUVSTFY5R3FTc2M5UEVVckxJTkVlR2JzQUljcURCY0RnU3FuTVlS?=
 =?utf-8?B?TmtPWk9CYWFMdWNWUm96dzh4VXU0NFhUdjV2MTV5aU16NXR6QmNCc3lXSTYw?=
 =?utf-8?B?UlZ0TSs2SnBreVoyd1lTYkNFaFJRb25tT09vSFhFRTdGOURNbUpXeWh5dGJP?=
 =?utf-8?B?YkVBWFpETEVKUlR3Q3dFT3BYdHdtTmMwcXdlYzRwd0dDa292ZWNiVSs3Vllu?=
 =?utf-8?B?MWVOSG52YUVZM1ZyNkoyZyt1ZDU3WmtnNlBJeHdjbGdxeGN4T1V0NnFJRFBm?=
 =?utf-8?B?cTlUWERGcFdLdU5BQ3R2TTdRUkhzZnl1cHdYQ2FUbGIyQ2ZKUWxobzl5WjdH?=
 =?utf-8?B?VHByTzJmRmNyMGIyQzBZclJnSGpORWR0NWFpK2swN3M0NzB2Yjh3RkQ4eGVQ?=
 =?utf-8?B?L2Q2UU5oY2NLeSs2aXNRR3BRYVBDMEpVRWFpUjl4T2VjNzdqT0R1KzJSYnZR?=
 =?utf-8?B?bzZOYzRqSkFUNVM0aXFtUFh1MkZuOUdBWGhaVmVVTnJiQ3VsSDFuVTZmdG9G?=
 =?utf-8?B?eUhSOGUrQStKZmFtSmRuNTJBZ09zdHZqQ0h1bkNvS0txRGFIdjV5eG5Hemt1?=
 =?utf-8?B?MExEcDFudjRWTXo0enFSZzRFdFV5VzV5MjZYRXRac3NLUjU4YnMxSzkvTjVr?=
 =?utf-8?B?V1NDR2FxeEFkbTFScjN1RnB2QU5XQU1rVWpuam9uSFlydHRkNENBb2VJV0xP?=
 =?utf-8?B?V29JNEc4dy9DaGJ4cTZNUnl3T1NIUEd4M1R6N2ZkNndvanNEMzAydWtiL2JK?=
 =?utf-8?B?dm9lTFBHYllndWVXS1RJZzY5M092bXNCdjR2NDZudy9OUkRiakZxZ3hSOXQ4?=
 =?utf-8?B?akNaRTFaY0FjdEtOZTJPUlZSeFcrczE0VUtKU29YL3VtY1RHTXRNeWJjM3E2?=
 =?utf-8?B?Q1llaER1QURVSVhjZ3pwTUhaUVEvdEE2cDBSS3BrSEpGcmxWMXRiZVMydUQ4?=
 =?utf-8?B?Z3c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a00d6314-20f9-456f-1b3f-08dbe5b5470b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2023 08:31:35.1560
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jvYLFHZu+Xk2SoMcO9mXtwswn8eOGtuoSYdWGhXXd4qOdtCcWvDqkmAf4WDINoA61w9Y/2IsOkObL49qdRp5Bg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7309
X-OriginatorOrg: intel.com

On 11/1/2023 12:21 PM, Chao Gao wrote:
> On Thu, Sep 14, 2023 at 02:33:24AM -0400, Yang Weijiang wrote:
>> Per SDM description(Vol.3D, Appendix A.1):
>> "If bit 56 is read as 1, software can use VM entry to deliver a hardware
>> exception with or without an error code, regardless of vector"
>>
>> Modify has_error_code check before inject events to nested guest. Only
>> enforce the check when guest is in real mode, the exception is not hard
>> exception and the platform doesn't enumerate bit56 in VMX_BASIC, in all
>> other case ignore the check to make the logic consistent with SDM.
>>
>> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
>> ---
>> arch/x86/kvm/vmx/nested.c | 22 ++++++++++++++--------
>> arch/x86/kvm/vmx/nested.h |  5 +++++
>> 2 files changed, 19 insertions(+), 8 deletions(-)
>>
>> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
>> index c5ec0ef51ff7..78a3be394d00 100644
>> --- a/arch/x86/kvm/vmx/nested.c
>> +++ b/arch/x86/kvm/vmx/nested.c
>> @@ -1205,9 +1205,9 @@ static int vmx_restore_vmx_basic(struct vcpu_vmx *vmx, u64 data)
>> {
>> 	const u64 feature_and_reserved =
>> 		/* feature (except bit 48; see below) */
>> -		BIT_ULL(49) | BIT_ULL(54) | BIT_ULL(55) |
>> +		BIT_ULL(49) | BIT_ULL(54) | BIT_ULL(55) | BIT_ULL(56) |
>> 		/* reserved */
>> -		BIT_ULL(31) | GENMASK_ULL(47, 45) | GENMASK_ULL(63, 56);
>> +		BIT_ULL(31) | GENMASK_ULL(47, 45) | GENMASK_ULL(63, 57);
>> 	u64 vmx_basic = vmcs_config.nested.basic;
>>
>> 	if (!is_bitwise_subset(vmx_basic, data, feature_and_reserved))
>> @@ -2846,12 +2846,16 @@ static int nested_check_vm_entry_controls(struct kvm_vcpu *vcpu,
>> 		    CC(intr_type == INTR_TYPE_OTHER_EVENT && vector != 0))
>> 			return -EINVAL;
>>
>> -		/* VM-entry interruption-info field: deliver error code */
>> -		should_have_error_code =
>> -			intr_type == INTR_TYPE_HARD_EXCEPTION && prot_mode &&
>> -			x86_exception_has_error_code(vector);
>> -		if (CC(has_error_code != should_have_error_code))
>> -			return -EINVAL;
>> +		if (!prot_mode || intr_type != INTR_TYPE_HARD_EXCEPTION ||
>> +		    !nested_cpu_has_no_hw_errcode_cc(vcpu)) {
>> +			/* VM-entry interruption-info field: deliver error code */
>> +			should_have_error_code =
>> +				intr_type == INTR_TYPE_HARD_EXCEPTION &&
>> +				prot_mode &&
>> +				x86_exception_has_error_code(vector);
>> +			if (CC(has_error_code != should_have_error_code))
>> +				return -EINVAL;
>> +		}
> prot_mode and intr_type are used twice, making the code a little hard to read.
>
> how about:
> 		/*
> 		 * Cannot deliver error code in real mode or if the
> 		 * interruption type is not hardware exception. For other
> 		 * cases, do the consistency check only if the vCPU doesn't
> 		 * enumerate VMX_BASIC_NO_HW_ERROR_CODE_CC.
> 		 */
> 		if (!prot_mode || intr_type != INTR_TYPE_HARD_EXCEPTION) {
> 			if (CC(has_error_code))
> 				return -EINVAL;
> 		} else if (!nested_cpu_has_no_hw_errcode_cc(vcpu)) {
> 			if (CC(has_error_code != x86_exception_has_error_code(vector)))
> 				return -EINVAL;
> 		}
>
> and drop should_have_error_code.

The change looks clearer, I'll take it, thanks!



