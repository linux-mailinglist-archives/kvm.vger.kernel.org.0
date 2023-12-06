Return-Path: <kvm+bounces-3650-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C04EE8063F5
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 02:04:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1FCFCB20F4D
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 01:04:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79C37A3F;
	Wed,  6 Dec 2023 01:04:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RHLm9Mko"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03D99AC;
	Tue,  5 Dec 2023 17:04:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701824648; x=1733360648;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=4JRXy0UkdHIWz31stWjcN5PRZ3DayqZnmaLnbpw6Wsk=;
  b=RHLm9MkojzTpVNIBITVfxi7joOmy72m5h0Oryp/0X5By9QsfUpWi/z+b
   l+xvr/sPos+5/ffihu/ipiBtEha8DdR6bK0OQoYkfeeJYEjD1WTSJ9ROT
   xQ4DPBJqUkGoHQ0Yl3WAbGUVYHDiMDDVyg3o4zhu3mRS1mJCNNonSDjWS
   WlNViEbLVT87hgbb0+OMeC1Sk6iG4SYxJjeMxO0C3cwLWGtna7vLEFPsk
   7wD8DlzPQGpc6cygtYqlJA9atJYRxhC2ybNd6AJd8/agleHosgFJUm/Jq
   hl1UJx76IJthGhVos70Wmkc+qBH4RFspRUFC4OQ1lPxH85oQCeL+EOos3
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10915"; a="458307287"
X-IronPort-AV: E=Sophos;i="6.04,254,1695711600"; 
   d="scan'208";a="458307287"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2023 17:04:06 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10915"; a="841656006"
X-IronPort-AV: E=Sophos;i="6.04,254,1695711600"; 
   d="scan'208";a="841656006"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga004.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 05 Dec 2023 17:04:04 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 5 Dec 2023 17:04:04 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 5 Dec 2023 17:04:04 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.100)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Tue, 5 Dec 2023 17:04:04 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RbSKy1u13PPjmupFuJbKJ4I/KFqS8Thb1Ad0Pgx/IoW6+MDBdqjU2K/piHViBmQg+c2ThUGL098K8FcOprfbRYTOUYy6VGsaKYsgMImL5EUm0GPQ12oRRY5XMlpeQAh8VeWLjkFmAqib792DcsNVVwQXL72mbB3wZeNkyYwoGEd0n0AfQq0cJqVvA/sKjwnK+EckwruYP+IVXLBrJmZ+3PIWqmTMPFlpcm2z5Y2kZXGA4W8Q17J+WxoIpoL8pNUm3YTbDPkNPy5/9R55zvl1lNrMlrbbX1bw7mqoBwAiKPmuipzZSKbj7KqLZ41GuRbE6qW5x8+LqosX9rRVHumXcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3C/zGudiA7gOmIA3fkUtQ2wN6GuDAKOcLDGfGZKzLVo=;
 b=KUaa6hqi3CIaJdVCjrKY+1BbgjGs6S8wnn8g7PSmgBwAOJYj8hcFmXmzx1kbCZGI1QjzzgSGEgBcMcAt1V9sBJNhLJtkH6qH/mkAWXGBH40UgaJHBpmGXyLvIRroPFZSoNQlS+Ve2Z+8eDd6eVYqiODUqrxd6u8BOnjRadn2tj7eC8HwkNIflxcta2g2BQJM8h7AEdN5S+Za8H7v2yKQkShC4A35MOCXBSMjrNxz3ZeYMrYstD0KGCGCa6R3DhbsUQcbj8TpEb4IskbIe8kwMk7B+vh0H+v9p8WNM50cIUJoqEDqOxov2Rlt85jUC7Elupn4ANU/NaMDy1YW94fJlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by MN2PR11MB4551.namprd11.prod.outlook.com (2603:10b6:208:269::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7068.25; Wed, 6 Dec
 2023 01:04:02 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::ea04:122f:f20c:94e8]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::ea04:122f:f20c:94e8%2]) with mapi id 15.20.7046.033; Wed, 6 Dec 2023
 01:04:02 +0000
Message-ID: <a3a14562-db72-4c19-9f40-7778f14fc516@intel.com>
Date: Wed, 6 Dec 2023 09:03:50 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 02/26] x86/fpu/xstate: Refine CET user xstate bit
 enabling
To: Maxim Levitsky <mlevitsk@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<dave.hansen@intel.com>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<peterz@infradead.org>, <chao.gao@intel.com>, <rick.p.edgecombe@intel.com>,
	<john.allen@amd.com>
References: <20231124055330.138870-1-weijiang.yang@intel.com>
 <20231124055330.138870-3-weijiang.yang@intel.com>
 <c22d17ab04bf5f27409518e3e79477d579b55071.camel@redhat.com>
 <cdf53e44-62d0-452d-9c06-5c2d2ce3ce66@intel.com>
 <20d45cb6adaa4a8203822535e069cdbbf3b8ba2d.camel@redhat.com>
Content-Language: en-US
From: "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <20d45cb6adaa4a8203822535e069cdbbf3b8ba2d.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2PR06CA0233.apcprd06.prod.outlook.com
 (2603:1096:4:ac::17) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|MN2PR11MB4551:EE_
X-MS-Office365-Filtering-Correlation-Id: cad64bbe-c625-4619-2068-08dbf5f73ba0
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /GItKfqemRCKI5VWZsOVksgTZ32YwpihELP8MiO9xxfeGDNLp3faOYYLKK/sobRYETpRE9GOoKHvBWTs2uxsOvfVJ3TjZSERelVAYAM9B0dnB7O07nNs/yreCWiWOmW30BNMlURpVCUcj9W9+ZG0wABrOPc/685hekLicTZdf/Tyyi3pEvOjWV/MdY9fUxlGHshx0UBOhGv52qlu6CgacXTW6pSZeVcYarZ3nr9hAlREcLdc973g0cDYUSIw01xVj7nV2evmfzjPf8X9xzOJZTJqM6JDG33kI2s9cdtyhzWU5aahdsm1YF1oIMIZzoO6Gx9iR/WIaYHKrl6YqUIcQnTh6NkwoZN1mTd+7uCr9uPgroZI2YGG9u8XpP1I23Jry3QBMPtlmk5TV+oczcsxvLcYX8F1JbVhi9rQOMRWzhxsXusgiLQzymfi6koXaCz0zoekgInggRQyRMMOpr4aYbIIvwuFhItlV9sHpDoqnB91qP4PQ4ZgM8xyMsplg2w03F2upIeHn8O22Ymf4NIc2ghqiLI+ZznPNoil4/SFeWZcVg1eF0p+tmsSCZoLUB1EnynzBV+uqAvF8js5yyoRKprZmDnHq+90FyJHe8EjZ4n9idKOSrq5H/tkBubTk1rcjm5M1Yn1aHe0S7RD4z3nig==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(346002)(366004)(136003)(376002)(396003)(230922051799003)(451199024)(186009)(1800799012)(64100799003)(41300700001)(36756003)(86362001)(5660300002)(4001150100001)(2906002)(2616005)(26005)(53546011)(6506007)(6512007)(82960400001)(83380400001)(6666004)(966005)(6486002)(478600001)(38100700002)(31686004)(4326008)(8936002)(8676002)(66946007)(66556008)(66476007)(316002)(6916009)(31696002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NlROVEFvVzQ3SEF2cC8yY2FsOHlQU3YvcW82VzVtekgxdTJObVlYRDhBOGVM?=
 =?utf-8?B?VXdDRnFBUlVjYzk0R1ViUllOL3dZc3BuQXZHdE9uQUVLUUQ3RzAwVjRxRzZv?=
 =?utf-8?B?VHRDTTEyOVVRSjVtNjRQQ0E0VTJlb0dWUE9BTHZlNzRqRk94eWttbjhMMjgv?=
 =?utf-8?B?MUJFUE5LZ0drb0d6VGVCaFRqQ2oyTSt5QURHQjZoME01c25sVnFVY2ZPTjNm?=
 =?utf-8?B?dytoZDdhR3J0bDVDZWhLVE5SUjcyNndINExpQ3E0bittZEE4Zk1hOHQ1Q0RR?=
 =?utf-8?B?emJ2V1hiZWxxUlkwVU92WEdZK2M1SDQ4bDRFcGxlcjJVcDhjYmZIK0hWdTJq?=
 =?utf-8?B?dG12QktsSHErWkV3NUlZL09HaWNsSmlwZHdoWDJ0WHpqMTJsaEdJM3ZCVlNQ?=
 =?utf-8?B?cXVBMmF2azRITVpuT1dMZ0E2enhsQXNTQXBpU1ljd005UFEwUnpIVHBSdFZt?=
 =?utf-8?B?akVQeXlrZ0FOL0ZHbUxaT3c0YytkaU1sSVhrQWp3bWJVRkcxRDNPZEF0VWlq?=
 =?utf-8?B?VzM0cXhzQUZlam8xcEtNbWo2NGM1ZnV0ZmhSL2llVHI2SGlhV1k0aHU1WS84?=
 =?utf-8?B?OG5uaWQ5akk1NWZpanlrRFc3L0xiaVVVRUpDb241bUZva1RCN3ZNQWNHMVFH?=
 =?utf-8?B?TnhuYnRMNjhjM2s3OTE3c3YzMGlxa2VMdUZDM1J3VXVldVVtd0x5ZUN6YW1h?=
 =?utf-8?B?akdJdWwzL0lZRVpTWW16SUhhWFdrUHE2dC93eU1oakpqeXVpK2hMTXBETTM2?=
 =?utf-8?B?b29xTUdMaGMwRDhCd2VrWm1xajF2MEdKK1NuVlRxdjNYTmR5R1ZmQlA2THdR?=
 =?utf-8?B?MlExSUc2TjlFV3ZFWFVEaTdFZkZRZFBFdC9zd0R5ME9ua2tnUlNnNjFWRXZa?=
 =?utf-8?B?M0dOTVFnWkRvQmF3bUF4V0M3bDhMdHdIYnVyKzVZckZwYzkvdi9jVzZ4ajM5?=
 =?utf-8?B?V3lDbUtvRGhmRUVFV3ZXRU9SWHlwM3Q1SFp6d0xSVXRSNGsrYnZsSnpETEhq?=
 =?utf-8?B?U0E2UUlhQnhzZGV3aGswYjB3anppa2ZwNTRRSnh4UVYyN3gzdGI4cTZiL2dQ?=
 =?utf-8?B?ZEhaTDg2RWdCLzkrTEJqREFXa3VEVG1HWXN2VDVjc3pZTTdENGNTVzQ1aE5G?=
 =?utf-8?B?aUNHNjVJS1dTbFlIbWQ3WFgyejUvRkFkYU9OMDNya1BZT25UZ3VIKytQcVAx?=
 =?utf-8?B?OFVsNFRmODZkdHFRMnQvb3VjQWsrMnRrU3VYOS8yMER3L1VjdUg1UUpPelRB?=
 =?utf-8?B?OWZTTldic2cybXpySFJqalRSa1l4VWV2NURoYUFRWGEyRmRnd2VSQ0hJMjZO?=
 =?utf-8?B?anB5eUV1angwZ04xZWRNWjEyZkRxU3VBWWxqd2JvdjBkdFY0TElTSHRYdHRN?=
 =?utf-8?B?RXhLZkJleXArd0VCaG52b0haNVJ2c0lJQ2lrZFRMOHozczJZS0k1K0R3ZGN6?=
 =?utf-8?B?eUNTYzBERnk5Tll0bitBVjBjUWNmdHJpOTMvdGlEK2hkNDBIa0Fna2xMSlZB?=
 =?utf-8?B?WW1zRm44eldoMFE0M0FiM0plNXd6cmx5S1lud0h0UGNDMGg0L21ndlF1R1NB?=
 =?utf-8?B?T2l2NjZVdVRnZlU2cU1lZC9hSFZHMXppU04vTUQrd3U1VzZ4b2RsSWV3Q0ph?=
 =?utf-8?B?VzBDdHpqSVdNaWVqcnRrRXdJMG9qMWcrNzY3N3FRdTJxUlhJZ1RqK2xZRHJK?=
 =?utf-8?B?a2gxOFFDUXdXcHYxdE5Bc2RpbUFDL2xuelRtaGJCdVRyYy91L2Q0Mm83bnBT?=
 =?utf-8?B?VEt4bWhjMWhWNHZhaytWN09mNHZVYlZzc3RIZDh1T1FOUGFqTVNVL0J4cEJO?=
 =?utf-8?B?YlVHRzJCZGpJOVZOU0hLdHk5eWVLdDBrcWMrcTljY1diUlBaTjByVGFCUnFB?=
 =?utf-8?B?ZkZCVHZ4QjFnT0k4LytwelZ5ODRneWVMK1hrbUtPYy9CdnBhOEpTSklBalNj?=
 =?utf-8?B?b1F0WFFmYUNLcHl1NzF2eUdKOUZOZXBCOTc1WjJGZktkd2x1WllPNkwwNzJq?=
 =?utf-8?B?ZGQwV2JJTEo4bDNCTDN0OEhFRnNSUlRmbDZzOTlNbkE2ZTNFaHU2L2JXSFoy?=
 =?utf-8?B?ZklmeVdyeEp4a3BObS9Zelg0RFFJUzFrbFZxN2wwRUg5SDFZV3JRc2hhQTQv?=
 =?utf-8?B?d0R3aHY0dW8wUnM2c28rUTJYcnBWMHdBeWN2aDRXczNoTmpDSkxaMWEyd200?=
 =?utf-8?B?OVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: cad64bbe-c625-4619-2068-08dbf5f73ba0
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2023 01:04:01.5844
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LYlXvHZaCiYAxZQQaMXXglPExqiZQdLxRN+VQoWJWmW/EOta0e2zJUpr0U6qu3IXLl2zjy0KKoizP+L8VltQWw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4551
X-OriginatorOrg: intel.com

On 12/5/2023 5:53 PM, Maxim Levitsky wrote:
> On Fri, 2023-12-01 at 14:51 +0800, Yang, Weijiang wrote:
>> On 12/1/2023 1:26 AM, Maxim Levitsky wrote:
>>> On Fri, 2023-11-24 at 00:53 -0500, Yang Weijiang wrote:
>>>> Remove XFEATURE_CET_USER entry from dependency array as the entry doesn't
>>>> reflect true dependency between CET features and the user xstate bit.
>>>> Enable the bit in fpu_kernel_cfg.max_features when either SHSTK or IBT is
>>>> available.
>>>>
>>>> Both user mode shadow stack and indirect branch tracking features depend
>>>> on XFEATURE_CET_USER bit in XSS to automatically save/restore user mode
>>>> xstate registers, i.e., IA32_U_CET and IA32_PL3_SSP whenever necessary.
>>>>
>>>> Note, the issue, i.e., CPUID only enumerates IBT but no SHSTK is resulted
>>>> from CET KVM series which synthesizes guest CPUIDs based on userspace
>>>> settings,in real world the case is rare. In other words, the exitings
>>>> dependency check is correct when only user mode SHSTK is available.
>>>>
>>>> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
>>>> Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
>>>> Tested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
>>>> ---
>>>>    arch/x86/kernel/fpu/xstate.c | 9 ++++++++-
>>>>    1 file changed, 8 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
>>>> index 73f6bc00d178..6e50a4251e2b 100644
>>>> --- a/arch/x86/kernel/fpu/xstate.c
>>>> +++ b/arch/x86/kernel/fpu/xstate.c
>>>> @@ -73,7 +73,6 @@ static unsigned short xsave_cpuid_features[] __initdata = {
>>>>    	[XFEATURE_PT_UNIMPLEMENTED_SO_FAR]	= X86_FEATURE_INTEL_PT,
>>>>    	[XFEATURE_PKRU]				= X86_FEATURE_OSPKE,
>>>>    	[XFEATURE_PASID]			= X86_FEATURE_ENQCMD,
>>>> -	[XFEATURE_CET_USER]			= X86_FEATURE_SHSTK,
>>>>    	[XFEATURE_XTILE_CFG]			= X86_FEATURE_AMX_TILE,
>>>>    	[XFEATURE_XTILE_DATA]			= X86_FEATURE_AMX_TILE,
>>>>    };
>>>> @@ -798,6 +797,14 @@ void __init fpu__init_system_xstate(unsigned int legacy_size)
>>>>    			fpu_kernel_cfg.max_features &= ~BIT_ULL(i);
>>>>    	}
>>>>    
>>>> +	/*
>>>> +	 * CET user mode xstate bit has been cleared by above sanity check.
>>>> +	 * Now pick it up if either SHSTK or IBT is available. Either feature
>>>> +	 * depends on the xstate bit to save/restore user mode states.
>>>> +	 */
>>>> +	if (boot_cpu_has(X86_FEATURE_SHSTK) || boot_cpu_has(X86_FEATURE_IBT))
>>>> +		fpu_kernel_cfg.max_features |= BIT_ULL(XFEATURE_CET_USER);
>>>> +
>>>>    	if (!cpu_feature_enabled(X86_FEATURE_XFD))
>>>>    		fpu_kernel_cfg.max_features &= ~XFEATURE_MASK_USER_DYNAMIC;
>>>>    
>>> I am curious:
>>>
>>> Any reason why my review feedback was not applied even though you did agree
>>> that it is reasonable?
>> My apology! I changed the patch per you feedback but found XFEATURE_CET_USER didn't
>> work before sending out v7 version, after a close look at the existing code:
>>
>>           for (i = 0; i < ARRAY_SIZE(xsave_cpuid_features); i++) {
>>                   unsigned short cid = xsave_cpuid_features[i];
>>
>>                   /* Careful: X86_FEATURE_FPU is 0! */
>>                   if ((i != XFEATURE_FP && !cid) || !boot_cpu_has(cid))
>>                           fpu_kernel_cfg.max_features &= ~BIT_ULL(i);
>>           }
>>
>> With removal of XFEATURE_CET_USER entry from xsave_cpuid_features, actually
>> above check will clear the bit from fpu_kernel_cfg.max_features.
> Are you sure about this? If we remove the XFEATURE_CET_USER from the xsave_cpuid_features,
> then the above loop will not touch it - it loops only over the items in the xsave_cpuid_features
> array.

No,  the code is a bit tricky, the actual array size is XFEATURE_XTILE_DATA( ie, 18) + 1, those xfeature bits not listed in init code leave a blank entry with xsave_cpuid_features[i] == 0, so for the blank elements, the loop hits (i != XFEATURE_FP && !cid) then the relevant xfeature bit for i is cleared in fpu_kernel_cfg.max_features. I had the same illusion at first when I replied your comments in v6, and modified the code as you suggested but found the issue during tests. Please double check it.
> What I suggested was that we remove the XFEATURE_CET_USER from the xsave_cpuid_features
> and instead do this after the above loop.
>
> if (!boot_cpu_has(X86_FEATURE_SHSTK) && !boot_cpu_has(X86_FEATURE_IBT))
>     fpu_kernel_cfg.max_features &= ~BIT_ULL(XFEATURE_CET_USER);
>
> Which is pretty much just a manual iteration of the loop, just instead of checking
> for absence of single feature, it checks that both features are absent.
>
> Best regards,
> 	Maxim Levitsky
>
>
>> So now I need
>> to add it back conditionally.
>> Your sample code is more consistent with existing code in style, but I don't want to
>> hack into the loop and handle XFEATURE_CET_USER specifically.  Just keep the handling
>> and rewording the comments which is also straightforward.
>>
>>> https://lore.kernel.org/lkml/c72dfaac-1622-94cf-a81d-9d7ed81b2f55@intel.com/
>>>
>>> Best regard
>>> 	Maxim Levitsky
>>>
>
>
>


