Return-Path: <kvm+bounces-12927-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 538AC88F488
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 02:25:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 033381F30D08
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 01:25:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42D67200D5;
	Thu, 28 Mar 2024 01:24:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZlhEfXJZ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CEA9FBEE;
	Thu, 28 Mar 2024 01:24:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711589089; cv=fail; b=DuWwmtgACfmiFDX8ZJYTSyH77n+m33AybYIOUJbG4HJ5JJKGaUJ3cRys4zjmuu1LmfZVyy29lsSegUA3ZS3Vd25urPuYvR5GBBVlT1iqqXMp88D68W7libOUoJpk/4VRLec0Yi3l4lBjKKAchAyAtTj2R2Ifk7iOrcR5KP5Bg0U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711589089; c=relaxed/simple;
	bh=qf5nys2JZU1s7uqltsRp9bh411OkwP6eERN6oGzgqlA=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=b9MN3fnxDGlHEcx+iQv2Q4xEzt1s+38pfnKqO2O7j5L8AzX0nJiT/skXUyWY14iQkMws2fXgp7S3bYnP++2Le9oHSKEoFAXt7S1ueywe30OARnP9rRrsFxZYR1cW9odR0BB62t3KSdRzSOjrjTKFa7VH40MI7xmpywYpKQPVD7E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZlhEfXJZ; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711589088; x=1743125088;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=qf5nys2JZU1s7uqltsRp9bh411OkwP6eERN6oGzgqlA=;
  b=ZlhEfXJZgSd3OugEKiRZn2ydyegdNCOyC3NiVfBDXRV/zedYNOjopP4L
   AYtfPdDY0/2iewI4JEpkjM0IffMWxNsgM5T6ZEW7kS5u5cOyV+WtLt9/g
   405OS5DWT8HBoF/sLCaUU9a5oL7JydCdCbx1du40N54JYC1odNawailyI
   BPYv5n34KWpIbayw9Sr52Rq5DfDYrnBUMYZwtqHenuafX+nc1K/910ajq
   Gm2AdzkD/GFJLRxwxowabunQT1kznr9CqKXn0/HsvWDd2E+lP72qdMKEI
   LpsPoI2NHdjRZFOgZD26iftva6NZC8Zz3HIKpNWfbUjf7WUQ3SVffBakm
   Q==;
X-CSE-ConnectionGUID: lGP6cH6VSNKx2gZhv0MqtQ==
X-CSE-MsgGUID: oxW43SK9RTmque6NQ5hRAA==
X-IronPort-AV: E=McAfee;i="6600,9927,11026"; a="17452763"
X-IronPort-AV: E=Sophos;i="6.07,160,1708416000"; 
   d="scan'208";a="17452763"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2024 18:24:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,160,1708416000"; 
   d="scan'208";a="16310675"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa010.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 27 Mar 2024 18:24:29 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 27 Mar 2024 18:24:29 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 27 Mar 2024 18:24:29 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.101)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 27 Mar 2024 18:23:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cHVAu+p7yOVhS4hB8R+ubo5Sf0VuPsbpbJO0wISQJhGVwl5i6jla3O0vLwyulfzv9veKgUppjHep2IwfpW0Gd886o7wMUUVUPf7TlIPEF0yv0Dx9mZlpHxylYRlcXMDk8uKoImZSMneAeW4NFxNtLtzKTyaesgE/Jx9PC7D4/8Mcr8E5fCHeRx619YRwMTttDLG1DHGxHCxG52zczuITVK0n7rriI/a2XL6MnF5puB4P8vJg+6iQ4khrsgtqA/sfnSvfu/rC4KixWveoaRCgN6jGHp2jtWHywr4rOiN5jBSWtdW207Tr3/t2gYfgbctpj8hXJ0duxm8seUcA+BT52g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W5gkRquqd9UgRIL+UgYY3LS02HEjDTGY177SS3Z0WLA=;
 b=NWKZNhYqJg5EZ2o4t39Apt9BVfukq15CvmRE300IhBDrxUbHk9Cvt2/W0J94xgfufOL+JepPmgIP6108XPAKPZyq30T6+hriwQLS+DRudeoXP+UDEjIF7EFC/r5kPTRvBo4bmpIt6OZ/ywbuS1FZKvNp7PiRCWDKlsPDsO/Ky0BhjA8ULelYOPHJqC7yPRAhwevBoAzLSipd34KO4MZANDmJw57LMDPhLfeK1JIiBz0Q7zPqSNQRu83gAbDBeeRhT3Ti4GqRIT4Obo+vuLoL8nN5vuAGIlxCcIeSFkmI5ZBoZZf5/GxD7R+/Q88r8Bsw+tCid5siezjYTIeETVvmRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by DS0PR11MB8720.namprd11.prod.outlook.com (2603:10b6:8:1aa::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.32; Thu, 28 Mar
 2024 01:23:45 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::3e4d:bb33:667c:ecff]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::3e4d:bb33:667c:ecff%5]) with mapi id 15.20.7409.031; Thu, 28 Mar 2024
 01:23:45 +0000
Message-ID: <359fe9cf-d12b-4f75-8cae-7ce830ec76d9@intel.com>
Date: Thu, 28 Mar 2024 09:23:35 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests Patch v3 06/11] x86: pmu: Remove blank line and
 redundant space
To: Dapeng Mi <dapeng1.mi@linux.intel.com>
CC: Jim Mattson <jmattson@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, Zhenyu Wang <zhenyuw@linux.intel.com>,
	"Zhang, Xiong Y" <xiong.y.zhang@intel.com>, Mingwei Zhang
	<mizhang@google.com>, Like Xu <like.xu.linux@gmail.com>, Jinrong Liang
	<cloudliang@tencent.com>, "Mi, Dapeng1" <dapeng1.mi@intel.com>
References: <20240103031409.2504051-1-dapeng1.mi@linux.intel.com>
 <20240103031409.2504051-7-dapeng1.mi@linux.intel.com>
Content-Language: en-US
From: "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <20240103031409.2504051-7-dapeng1.mi@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR01CA0020.apcprd01.prod.exchangelabs.com
 (2603:1096:4:192::6) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|DS0PR11MB8720:EE_
X-MS-Office365-Filtering-Correlation-Id: 2704decd-7bd5-4a2b-ae9a-08dc4ec5b623
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gwGM9pfEctAzIgXLEKEYDb1X9qXw36gFe2hiVpB3v91RMPVfRO73dPIjvKQX90OwYNwiNVEH3L/ONNn65vjoFsddSn6aOviWtwm5CL1L13yBB7jOonGNgIZxVRTH7c+rUwgXt0dnhPsWQmtUDK3MHk/CV3anRL3y6YM5PEz8xXZyZun/8Nq+Wnr+Bfi/pRjkg/zHe3caipSHXw8PASLQLBEWA38CRk5w9zXtNnfFv/mPSPeY0tvGyCkOMJQT4YyP96h2tDP1NKsSLAg0df6heFaQnbjtpLp6BhtqQq+cCDg0niEVJAQxm83b75mh+8jq4WE8/CxaHWV+iX82r9c8Gzfqti+Psdo+MZBqB4pQvOAnJ1J30ZhlRJxIq34InQrLWO1/lAl2XJT07RqTbhqECZC/Mgb642ziA0ER9HOTZjrgZnjQMHUZXvhdxZKjiMDWXR9is4bOO/eOWXaM/2hO0eaAoCO3EoFp2/U6pjZUK761cQGS7eADuOsdTxjIewvX7ZifZkAcfg4xvbOt1/ZV4J0qXLlMGHr0fq2pKErdz4SQDOWc5qwK9IWqt3J+BXdezN5VgH7iReMh3g8yENHHEZOEJtW/iobjHH+np/lXdq40VDYDufNTG1z0j+/aWO7cnPjgxw5YWKB2YGSDwGswBOkj0C1OXYbji/BRAvDBC2s=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(7416005)(1800799015)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SlpYdFJqNk1qeStoNXg4ZDlhOVdDa2E3NXFHYllQUWV6ejVKZmhDOUlyb29r?=
 =?utf-8?B?Z2dWMmx2MEZEcEdyOEZoZktMZnBIekpTZUFrSFNRSzN0OWZ1VVhmMlVKRk5O?=
 =?utf-8?B?S1lGV0kyRlozejVUQnBuMGNtQnFUaVVuQmJYaTZENENXZC8zZ1dYV3NpWkM4?=
 =?utf-8?B?bUF6TkFING15K1B3a1pWZEY5clE5VGkzQUJ0N0F6QzVVT09XalpINzZVeWZG?=
 =?utf-8?B?dytKdFZsMk1iUnRFZzBaanRPamVaV3E5ZkRYUHE3MnE2OW9xS0d2NTVPUERw?=
 =?utf-8?B?YU44eWppY0VTTzFrem11VDhvWSt5QUVRMHJzWGo0RmdxQ3A3VU1Va215QjF2?=
 =?utf-8?B?dEM2UkdrVFNWR05kVHl2MWc5aDhhTG5jaTYyWGNGQkZ5ODFGZWxpRjNTekN1?=
 =?utf-8?B?Y2I5NkpjZGlDaU9iS2wzLzNwUXI2M0k4Y1dSTmtXeDQ3a1UxUEhtdVBkeEJl?=
 =?utf-8?B?TTI4L0IxYW0ydEp5UktjWUJEUnkzTFNhQkxTdUNGZ1ZyK3FkZ3NzendYNGFY?=
 =?utf-8?B?bEtlZDVBeHhhRnJiWStkZUNwNVA1eFd3bFVpNEF5RXNweHl1allGbzQrU2M5?=
 =?utf-8?B?ZzM5b0R6L0h6RzNGeDltcTNGejVpbEQvTjdwRVlHSzF5UDdhSWN6LzdDd0gy?=
 =?utf-8?B?M1BEVzdJRnlrbE1Bb0VpMFp2eWpiazNiazJmT1JyQlpKWEMwY3pJSi9LODR6?=
 =?utf-8?B?ajUycWZCTHNhaUNGK0RDbm1BOUsvVDFEcEYxM203dUMydnRoUkxsS0dUMG5p?=
 =?utf-8?B?WU05cXM1TU9qZTBQN25yeTBoOXFwMFJ0M25ZOEhmZWFtRlVoVWdOcmNqRVNm?=
 =?utf-8?B?cWwwV2VWODhNeFRNakF4Z3RhWGVyT2dTb2ZOckZRQ2lya2Z0cEZpMFlaVS9B?=
 =?utf-8?B?SXMzbkx3aHEwei9iUU4wMFZyanVNaFlONlJCVFdWWlVlb05EcndNdVZPWmlj?=
 =?utf-8?B?OXhneHBsN0k0K1kzTm9vQ2NXZVRkUTFwMlFEMTlna1I1Ry9Pd3B2a2pObFZ6?=
 =?utf-8?B?YnBjZnluQko3eUlIdXFKM2RqZjNTdzhaZXlLUVIzMWZsK0pnajhrWlFJM0hT?=
 =?utf-8?B?dGlTNGxJRk1od0hWZ1E2anpLbzJCYzVtV1FWTko5WUdGTUZkV2k1Vmp2TlM1?=
 =?utf-8?B?ekhOam84YktXaXB6VTljOHlSdWVNWDlGMkxSOTcwdkxtbVVkcWQ2Zy9oTTYx?=
 =?utf-8?B?YzBSL2phYVU0eENPME1ZT2FNbDF6SUZPbTdid1RBbFA3MG5nN2xuZVJzck9n?=
 =?utf-8?B?djJqSXc1dUo4OHVIMVJlKzNnTWJiTEhTYXZJK2V5WjBpMFpkWlFDaXUzM21x?=
 =?utf-8?B?YjNKSzdacU5rV2VFQzQzc2NMb0lIQk54eS91YzJGOWluVGtJVm5QV1BwT1JP?=
 =?utf-8?B?a3ZJdXUrUEllRmhIWVp4bFRQN21UbEVCUFdzTzkrZ3EyYk5qR05QWXdmWGt5?=
 =?utf-8?B?aEplV0IxVGp6azdwcGN2Sm9ObHBiM0tHSFRsN1hBcmhnSzNKajRBQ3lPK0lL?=
 =?utf-8?B?RkRvMlo3WjNkdllSSHFna0NLUGhZUEJJdnZqSWxSRThxZzA2ZkphYWRNTVVU?=
 =?utf-8?B?MzBGWEwyNjcvUm5kWWR0bDloZ2hOZ1YrU1ZHbHhPM2hnMG93K2ZiSkVYYjl5?=
 =?utf-8?B?bE44S1RDbnErQVM2WUVEemZjSUswVVZPOUgvTlpadmhxRU5WK3Bia283ek9G?=
 =?utf-8?B?aDRGaDBaTXpkZWQwaGpDUGNDZ3NGTUtqbWpjbDBVUVJuWlFWem9XbXFuVVND?=
 =?utf-8?B?NkpaSzlBZGVjMmgrOHBTczhWRUxXSFRVTkdreWxBM1hwTitCaUN2TzBuWE9Y?=
 =?utf-8?B?WEVlSGJPNzVXUlFHS3Qya0dCclJEZHJoYkRKc0JldkhHQ3RIN2RCdEZwVzRP?=
 =?utf-8?B?MmtQeWFQYS94K3lrWFBBY1libTJiRzlNMG51WWxkTWdRVlJMaW9zVGFMcEN2?=
 =?utf-8?B?MG96N3Uvdm5oN21BKzVnZEU0MUF1ZHMwa2lITCsrRXNON2xSVjUxTi9qTjZ4?=
 =?utf-8?B?TEZndUp1bWNwMnRZazNCY1I4QUpET2hZMU5DZjdpbktTUWZMcCtlOUlLTmhT?=
 =?utf-8?B?ajNBOG80VEdTQ1A2U1YwS0ZoQ1dZVkRWbjJaL3hSZVpDbllDMHZyd0dkazhM?=
 =?utf-8?B?TjJJemd0K21WVmZ6Ri95MnhxZlJzMEhJVTN4QTBwS3FVUkYwenZXUXAvcmYw?=
 =?utf-8?B?NHc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2704decd-7bd5-4a2b-ae9a-08dc4ec5b623
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Mar 2024 01:23:45.4162
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xQxCkxWjjiQ/PNk0hoViqxqbYGsbHllQSjcNYsD3kRRfTdjm7Y+nyokveoVDLWx+V5NID0G/awYfK8VFcS2ACA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB8720
X-OriginatorOrg: intel.com

On 1/3/2024 11:14 AM, Dapeng Mi wrote:
> code style changes.
>
> Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
> ---
>   x86/pmu.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/x86/pmu.c b/x86/pmu.c
> index a2c64a1ce95b..46bed66c5c9f 100644
> --- a/x86/pmu.c
> +++ b/x86/pmu.c
> @@ -207,8 +207,7 @@ static noinline void __measure(pmu_counter_t *evt, uint64_t count)
>   static bool verify_event(uint64_t count, struct pmu_event *e)
>   {
>   	// printf("%d <= %ld <= %d\n", e->min, count, e->max);
> -	return count >= e->min  && count <= e->max;
> -
> +	return count >= e->min && count <= e->max;

I don't think it's necessary to fix the nit in a separate patch, just squash it in some patch with
"Opportunistically ...."

>   }
>   
>   static bool verify_counter(pmu_counter_t *cnt)


