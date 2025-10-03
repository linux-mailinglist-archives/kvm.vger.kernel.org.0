Return-Path: <kvm+bounces-59453-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4BA9BBB5EF3
	for <lists+kvm@lfdr.de>; Fri, 03 Oct 2025 07:04:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B755019E32E2
	for <lists+kvm@lfdr.de>; Fri,  3 Oct 2025 05:04:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 766AE1F4CB7;
	Fri,  3 Oct 2025 05:04:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="dNwffRs5"
X-Original-To: kvm@vger.kernel.org
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013016.outbound.protection.outlook.com [40.93.196.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D12461CBEAA;
	Fri,  3 Oct 2025 05:04:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759467854; cv=fail; b=bOe+SQGOwrN1Bcy9nFvVrjClaK3dZZuUUhfqHg84EZosZn36yhnyVhdCoI09aqqchKeBq5Iev3gO9uHtjOX3YNECqZCT/bs2QE4VL4fLEmio+LbSxWQJJO9dWfoLcmgUy0LmbphFh1uTuT+QVySp1d4C57684YTmBm5ocpcsmPQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759467854; c=relaxed/simple;
	bh=hMN1xOLEngw5N1qCoblctLSmBnpV/HL1uGQcOhkljyU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=u++3/tjL1tvRzFZ3D53UqtTYf8fjnPJceU3n5pbAfNMBaVDitgghNswZaLdCUTAN6o8hALDtE/4e+JRFvOV90NkQ1vw+ra7RZTAhV76kp3H+xXNSoOLKziPrtbPypgSrmjNHxqIu0KHLl7m7Ot15VlVyy7PU35Kh5QciRkO2UfM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=dNwffRs5; arc=fail smtp.client-ip=40.93.196.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZmnvLqQJoPH6PjcpyXkHZzqsEBFfrHe0BVPWwEdgYEmlJK9XGZYTSmbWQbBPGCCQoF1HS5HYqm9soumGUOWXMAvXTkVVzlXWDcdY4BC3XX/bPFUtWo9Sgr4Mh8XAHkKZRIGmD+fYLdc32PkCowglJtoHO4cR+3bPrD88V5Qm8wIBcL0l25XRR10vTm9XWYKNHNfBfVZfFPD90aQXmJZoB9MnINMGMWAo/GjmknUYDqu0s/2qxhIKjKhkGSPc27lHxjIBUoc2GzcNEyb5KxNGvk5KxM1qIfyM3Tv2oq0vHiHdFcgRCdVdiuaTpbeIHmeXPHFV09BCzdKPA0fEn+cclw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iplH5jn4C0klpNNVCzIs9dMDCkQEOLLe2i1eeO4XarY=;
 b=vdgbh3Gp9yFbWD4rJGqZpviupTcgFHFRHQo4y7XG4awCqVb9kfzHOtnBeyCHaJJA0to4xsuTCbnJ5LewkSOf1Y9twNdo//1y35GMhUNhlfAzoyRAXLZr2g4OBZa/3O6NT0EL4GSFrb+oIX/aH3tk3bT8Fr2HyF7IefJqW1IV6p7SlqPR653Q+VixvtNoUfkNPCljQPay+PR5b03Jv1J06WwY74D2qaICVIqblj0pjoslvJ1KpU5thdsKoM6N3Z641/gunYqspyJtagDAtMgddPdmq5z5KAc/CnIzV/9/+Krug9XrED2YKnLBRlLWmz8hLasDjZGzZ/+cTUrNWjNJEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iplH5jn4C0klpNNVCzIs9dMDCkQEOLLe2i1eeO4XarY=;
 b=dNwffRs5+LA+dIMsnCJDDcCNynYbNF5HU90An3uQvFIAeVfRPPlm67Ff9SERr26VTJBXtlKzDGSxjS1PT6wbnaWuza7FuvqC3mh+cET+TOzcbYdioq0yyNBSdlpc7Bg8TFuqm9rp03wbMQucHiINJN1289+fff5Tr52Swcv8v3Q=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB5712.namprd12.prod.outlook.com (2603:10b6:510:1e3::13)
 by LV2PR12MB5989.namprd12.prod.outlook.com (2603:10b6:408:171::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.18; Fri, 3 Oct
 2025 05:04:05 +0000
Received: from PH7PR12MB5712.namprd12.prod.outlook.com
 ([fe80::2efc:dc9f:3ba8:3291]) by PH7PR12MB5712.namprd12.prod.outlook.com
 ([fe80::2efc:dc9f:3ba8:3291%6]) with mapi id 15.20.9160.017; Fri, 3 Oct 2025
 05:04:04 +0000
Message-ID: <bd144177-94e6-49b2-8c9e-b5edbaa42aeb@amd.com>
Date: Fri, 3 Oct 2025 10:33:43 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 32/44] KVM: x86/pmu: Disable interception of select PMU
 MSRs for mediated vPMUs
To: Sean Christopherson <seanjc@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
 Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>,
 Huacai Chen <chenhuacai@kernel.org>, Anup Patel <anup@brainfault.org>,
 Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt
 <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Xin Li <xin@zytor.com>, "H. Peter Anvin" <hpa@zytor.com>,
 Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org, loongarch@lists.linux.dev,
 kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
 linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
 Kan Liang <kan.liang@linux.intel.com>, Yongwei Ma <yongwei.ma@intel.com>,
 Mingwei Zhang <mizhang@google.com>,
 Xiong Zhang <xiong.y.zhang@linux.intel.com>,
 Sandipan Das <sandipan.das@amd.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>
References: <20250806195706.1650976-1-seanjc@google.com>
 <20250806195706.1650976-33-seanjc@google.com>
 <f896966e-8925-4b4f-8f0d-f1ae8aa197f7@amd.com> <aN1vfykNs8Dmv_g0@google.com>
Content-Language: en-US
From: Sandipan Das <sandidas@amd.com>
In-Reply-To: <aN1vfykNs8Dmv_g0@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA0PR01CA0091.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:ae::14) To PH7PR12MB5712.namprd12.prod.outlook.com
 (2603:10b6:510:1e3::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5712:EE_|LV2PR12MB5989:EE_
X-MS-Office365-Filtering-Correlation-Id: 65c033f2-89d6-4143-610e-08de023a4632
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bVp2UEQ3UkRVNk5VKzZWZUtrK1l5OXFVVUMraCtOSUZOdisxQ0pQZXo0bUlt?=
 =?utf-8?B?YXE0aytESTloZkhkTm5HRHByTk5JYUZEaEpWQWNuRzBlNThqWWYraUNpOU45?=
 =?utf-8?B?K0Q1alNJR2FLSGlCeklHV25TZld0bmI0Yk1mMnVRWCtCclJiWGNCK0dqUjRM?=
 =?utf-8?B?NGFtenNKZS9WZjUwdVNMeDcrWHVhbm5yd3JkdHFveGRmVWZFTzl4UkVtUy9v?=
 =?utf-8?B?dWxtQXd2QVFpWklXQWNFM0xYWXRIM0RsLzlhT2U4cVBGNHBYb1dDYXVLN1ZS?=
 =?utf-8?B?SDJlU2t6NTBWZy9VYU1HTWZZdlorQUxiWjdMakthZnNXUmVVQUx3R1pXYUJv?=
 =?utf-8?B?Wk9maW02VGgyNzZoSGtTa0h3aU5YSDdZdStRQk42c0VOUkRjR3NyVGdTQ0JD?=
 =?utf-8?B?Y3JZNGI5a2hIYytqSjVpYnhJa1RiSGx1WG0yTm9mRFhzbytmaFdNZ1BaWU4w?=
 =?utf-8?B?YTZGRWxBbW05S0prWGVCL2lzdjBURkw3K0JpVG5WRjkzdWlSLzkzVmFGK0hI?=
 =?utf-8?B?U256VEI4eSthOXRuQmFucFpoZU9BWWdzMUM1RVBpQUFDdjBoOFdMcG1ybEp4?=
 =?utf-8?B?WC9IQ3BZMzI2WlFSTUtPQjBuUUhSaDR5TVM5TEVrNGtVZGR5R3FDNGZvNWZl?=
 =?utf-8?B?ZDZoaStXQ0xSWExwMXZWeFhGaGxvSXVzUnZNRmRGL21XWG0zcXNjS2U5THFv?=
 =?utf-8?B?UmdsS2szcEhNRVJoWjU3SU5UWFVyUGdEcmYxdkUwUE5hVDZ2SWNzVFhIY0xk?=
 =?utf-8?B?QjRRMVE3cE43aU5QcXduZ3BIbVBtbzl2SWhkQVh6VU9JSUxsSWlDd1RrOGIv?=
 =?utf-8?B?Vm9uMGE2T2h2eXQvNUVjQWF2SmhlZEhaUEZpNlMvUDlQWXRVeVkvWkhqUHhh?=
 =?utf-8?B?QXNvSjJvTCthSVc1THUvZUtlbVJQdGxxdWxiUzVVVjBHKzhaNk41dGhrNGpN?=
 =?utf-8?B?MHRtemhKV2hwTUE3R0gyaDhhU20wcldFTmNDZWZDTzg3Q28yZ2Y0bUhMaDVx?=
 =?utf-8?B?RTN6Q3gvaGsxMXBMMnhvQ1UxdDN3SFI1VlQyWUFYbGZWeWwzTWZYOTZldnBP?=
 =?utf-8?B?cFZzWU1pQlJRbWhlcUVTZ1liZDNTTHVzWE5iZUo4MkJKc1p2d0FsMlNWR21v?=
 =?utf-8?B?QTJVcHp4WkZzaU10MTI5cTFVd3d6cmk0WTdRVGcyQTNSRkhpUmNxdW5Qb2Ux?=
 =?utf-8?B?THdsdTYwa0UzYkpHWHpSbzl2c0p1UGtXN1dTVjdSQ3lnWE1CNHVJVnE5aU1a?=
 =?utf-8?B?NkU4SVRhRHZMTFlybkgwcWRyRlVGbW1LaEU1S2VITHhyajZoUUhsS0R6UU5s?=
 =?utf-8?B?VHhaRElybWJhQWdTL0tGSUEwQkNyaEpqNk1Hb3RKUGxtVFNhWi9UUUg5L2gy?=
 =?utf-8?B?TW52OHBkREs0eVN5bVMzQlhOUFcrdnQ3R0tOSDZwN2FrU1pJTi9vWUZHK2Jo?=
 =?utf-8?B?NmNyeWg4blYvTkdRRTBrRGNpVFlWdldTZTlodWxnU3ExVEZJOHUzVWVocEt4?=
 =?utf-8?B?MnRiZXdFbnRSQ0FPckZ5Uzhna0lseDE4UmVMUnp4c1hvT210ajZGa0k4Z2o3?=
 =?utf-8?B?Y0t0RzdaUnFYd0lhWGhzcU96Z3RVWjdvWHVtNTNrTUZicUpzR1hYdUhlbUpF?=
 =?utf-8?B?TG5PVEJzcFIrMC9hYVJud1p5MFRWS01QbmhuYndkMG1RZlNOTW1hSlVOL0Fp?=
 =?utf-8?B?MGhnZnBRR3VqMERjTU9xbDNucFNlN3oyUC9UMG0wQmRVT2VQWjc5eGhrMnZ6?=
 =?utf-8?B?UklQemI0T2ZaMm1BeitWWGEvemhIZnhueVBTVXdtQitBUHRZQkwxRkF0NkFv?=
 =?utf-8?B?dC90d0hpQVVUTFV4WkhoUC9WTkZQb3JLanAzQmpYRmdKbnpGNC9sRzlybUNV?=
 =?utf-8?B?enZ2V2VSSEs5QU8xQ1ZINUk5RzNORWgyeW9LRGthWWF3SVFpQTdqaU4yZm56?=
 =?utf-8?Q?IOKUBlLsm9RZmsfMOxp8tXAeRHuEOGN9?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5712.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eXpwbzc0L1c0ZGlTYW41UFMrQlp5eEk0dDJVZ0xYUEtadmdIZE5PVTFrNXNw?=
 =?utf-8?B?VzExK0pVd0E1RnFOWjk5OVFwUml6Q0tqRGIwODZTU0dQVkt4VE9rWWV6eEF4?=
 =?utf-8?B?U2pDeXI3VFRydFd1MjF1VFUydE10MmZCY2Y1Z3VwY1phdzBwbkVzektEdUJW?=
 =?utf-8?B?Mnp4WWEyd3hKajB0anVtNlpCdldQUjFwSktPWktkVkRtR1h3cElTSWVBVlJ3?=
 =?utf-8?B?UzNLSXk5YkNUTUh5SHlPeTdabHBQNy9HZGc2WGR3R09Ob1RIUGI5dSt1R3FF?=
 =?utf-8?B?ZGg4VXprNzd2QTVkckNvaGZIWVIrTjJRaTRwcytueDRtMG5LSmdxSktlM0gy?=
 =?utf-8?B?WDlRbC9wdkxieExTYytIN1cxU3VldFJzcHhtaldFa1NGdi9Mb3BXZC83THI1?=
 =?utf-8?B?NGRxMjFpSzZPYnQ2WEpoRVBGQ2REZ0lab0cyWWQ0Z0lkVEVrMUEvVnhaaCt3?=
 =?utf-8?B?WXZ0aWZ5NVFhNVFscTNmY3hwdW1TNStPMjRjZjF5bklFR0N2NWhOU0ZRMEll?=
 =?utf-8?B?U2hSbEJBS1JsVW1UUWp4QWl6eFU5TzRWbjk3bGFqM21vTUNpRHlxZUZUN0pw?=
 =?utf-8?B?NUt5VkJsYnMyN1dsUFdnWk9LajhtZHUyMXU1emtRalMyblROZm9Qa1hnM1pN?=
 =?utf-8?B?YWt1WFZzMGlHSFFvNFA4Sjd1UFc5R3B3YlUxWko1Q2VOdVR0SzlkK3BlV3JM?=
 =?utf-8?B?UmlZUHpmNGRETC8vdFRjMVc0aDVKMC82T3NWaEtHSUxRcDVQR3VYMjZDT3kr?=
 =?utf-8?B?UW5RbnlEQmZ0LzNtelhRclZjZzdtYVpwTmI5anEyWnBjWGl5R0xWekt3ZDVz?=
 =?utf-8?B?STR2TzREQmkxVEhnZzkyMkwrTDZpcjIrb1BxTVpuOXprWlRKZzJFZVlWS1M5?=
 =?utf-8?B?TWFxRDJ4bldGaU5veVdMNXJOS3dESEJxVVE2bnlSOVJsWTdWYTFqc1FZRG1I?=
 =?utf-8?B?VWVTenlRZGJqRy9xUmljSTZmVTFNc2diYzlMM2JUUER4QXI3SW5mWmU2RnJV?=
 =?utf-8?B?QmcyaFlGamR3YWZONTl2T1lXMkVwNWVzRzNPQUtqbGx1QzlqWHE2TWRxbXNW?=
 =?utf-8?B?bkM2TWljbld4a2kxVlNwbnY0VllzUnI2aHBhREtEMWpSNG9qdENodEQyQTdu?=
 =?utf-8?B?T1JEYzJOMnBMb1ZiODhRSmR1V3JucVRHOGdjdFZ6SWQzUytUNm5QRGlGT3dV?=
 =?utf-8?B?ZHdCSmhXZk11ZEZvZ3E5VnhnOVQwKzdndkFaMVU5eW8xdnladzREV3dId0tG?=
 =?utf-8?B?Uk12cW1zeHFOV2VGRjdEVHdLSkRYa25YbDVnZk13bXFWYkxpOWdhU1N4cDdp?=
 =?utf-8?B?ZGFpNnUwcSt0UHZuN3pBOTRUcm9tdmZzU3lnRnY1OFdDbTFnaHlOQlV2d0Jh?=
 =?utf-8?B?NGRWMzR6bWc2ZFprTWQraGx6WVVTaGVCWjVwcmF4ME8rb3NoOFd0N01hVmRj?=
 =?utf-8?B?TG5IQ3hGbzNIUnd5SGsyaytqWnhQRFVkL0NEWERITUdza3dzUTdxd1k3eENu?=
 =?utf-8?B?OTRsSVhCeTk0Umg4ZE5Kd3VjR0NvRW1iTFBKL3E1TjYzaWdtc0loSkp0SUsv?=
 =?utf-8?B?Tit6cFdic09ZSUJIU1lGZldYQlFHK2dhUGtBbHdkNk9RRDhqbTM2YmJXcTJI?=
 =?utf-8?B?d3JSQnN6NHVOUGFrc0dUQWtsV0w2d3BmU2lOcDRSRm1PT29GUzU4anBqSVFp?=
 =?utf-8?B?YkdEOUpKRkVGV3RHRUhsVEJrRERVRyt0eFBPVzF5SkUrTnhlZFpPUFpjNDVP?=
 =?utf-8?B?R3E0ditlMTNkWjFzcFZpRVRWeWVlOGMzZlFOS1lHSm0rYXVxYVM5U1VwSU5R?=
 =?utf-8?B?VGh4TE53VG9oNTFnOXJ2OCtrV25sZkZwb2xkckFhbU5GVm40bHEwbVF0NnhK?=
 =?utf-8?B?ODViUUlXaFRoaVF4bDF2VlRsc3JDUXdEaHN5dXd0NjNyZ0k3Ly9JK2RuUXVl?=
 =?utf-8?B?akNmN2tMdm9WTHgwU0Q1SUtGeVo4ckNXWFdtQXBBYzArYjVaWUMxZDY5RVRs?=
 =?utf-8?B?QWZYQUJyM0ljcHE1MXpha2JUY2FnQUxRamg0VTJUQUJ0YWJzZ0ExZWk4N3k1?=
 =?utf-8?B?dE1palRRL2Y1cDJYVEJRaU9sODJvN1J4TC9TTGoxck0wZTZhSjhhZFdBbGtL?=
 =?utf-8?Q?pvW0351KuCOmuyN4OUOboxpDi?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 65c033f2-89d6-4143-610e-08de023a4632
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5712.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2025 05:04:04.6435
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WSYiXZXU/+Js+nYnbGsNH396/VpLDn+SsYlivjFMDLKwA68AxYMyyLRWBUnrq5wubBY8CVyZUeiFUDXjKOXjFA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5989

On 10/1/2025 11:44 PM, Sean Christopherson wrote:
> On Fri, Sep 26, 2025, Sandipan Das wrote:
>> On 8/7/2025 1:26 AM, Sean Christopherson wrote:
>>> From: Dapeng Mi <dapeng1.mi@linux.intel.com>
>>>
>>> For vCPUs with a mediated vPMU, disable interception of counter MSRs for
>>> PMCs that are exposed to the guest, and for GLOBAL_CTRL and related MSRs
>>> if they are fully supported according to the vCPU model, i.e. if the MSRs
>>> and all bits supported by hardware exist from the guest's point of view.
>>>
>>> Do NOT passthrough event selector or fixed counter control MSRs, so that
>>> KVM can enforce userspace-defined event filters, e.g. to prevent use of
>>> AnyThread events (which is unfortunately a setting in the fixed counter
>>> control MSR).
>>>
>>> Defer support for nested passthrough of mediated PMU MSRs to the future,
>>> as the logic for nested MSR interception is unfortunately vendor specific.
> 
> ...
> 
>>>  #define MSR_AMD64_LBR_SELECT			0xc000010e
>>> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
>>> index 4246e1d2cfcc..817ef852bdf9 100644
>>> --- a/arch/x86/kvm/pmu.c
>>> +++ b/arch/x86/kvm/pmu.c
>>> @@ -715,18 +715,14 @@ int kvm_pmu_rdpmc(struct kvm_vcpu *vcpu, unsigned idx, u64 *data)
>>>  	return 0;
>>>  }
>>>  
>>> -bool kvm_need_rdpmc_intercept(struct kvm_vcpu *vcpu)
>>> +bool kvm_need_perf_global_ctrl_intercept(struct kvm_vcpu *vcpu)
>>>  {
>>>  	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
>>>  
>>>  	if (!kvm_vcpu_has_mediated_pmu(vcpu))
>>>  		return true;
>>>  
>>> -	/*
>>> -	 * VMware allows access to these Pseduo-PMCs even when read via RDPMC
>>> -	 * in Ring3 when CR4.PCE=0.
>>> -	 */
>>> -	if (enable_vmware_backdoor)
>>> +	if (!kvm_pmu_has_perf_global_ctrl(pmu))
>>>  		return true;
>>>  
>>>  	/*
>>> @@ -735,7 +731,22 @@ bool kvm_need_rdpmc_intercept(struct kvm_vcpu *vcpu)
>>>  	 * capabilities themselves may be a subset of hardware capabilities.
>>>  	 */
>>>  	return pmu->nr_arch_gp_counters != kvm_host_pmu.num_counters_gp ||
>>> -	       pmu->nr_arch_fixed_counters != kvm_host_pmu.num_counters_fixed ||
>>> +	       pmu->nr_arch_fixed_counters != kvm_host_pmu.num_counters_fixed;
>>> +}
>>> +EXPORT_SYMBOL_GPL(kvm_need_perf_global_ctrl_intercept);
>>> +
>>> +bool kvm_need_rdpmc_intercept(struct kvm_vcpu *vcpu)
>>> +{
>>> +	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
>>> +
>>> +	/*
>>> +	 * VMware allows access to these Pseduo-PMCs even when read via RDPMC
>>> +	 * in Ring3 when CR4.PCE=0.
>>> +	 */
>>> +	if (enable_vmware_backdoor)
>>> +		return true;
>>> +
>>> +	return kvm_need_perf_global_ctrl_intercept(vcpu) ||
>>>  	       pmu->counter_bitmask[KVM_PMC_GP] != (BIT_ULL(kvm_host_pmu.bit_width_gp) - 1) ||
>>>  	       pmu->counter_bitmask[KVM_PMC_FIXED] != (BIT_ULL(kvm_host_pmu.bit_width_fixed) - 1);
>>>  }
>>
>> There is a case for AMD processors where the global MSRs are absent in the guest
>> but the guest still uses the same number of counters as what is advertised by the
>> host capabilities. So RDPMC interception is not necessary for all cases where
>> global control is unavailable.o
> 
> Hmm, I think Intel would be the same?  Ah, no, because the host will have fixed
> counters, but the guest will not.  However, that's not directly related to
> kvm_pmu_has_perf_global_ctrl(), so I think this would be correct?
> 
> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> index 4414d070c4f9..4c5b2712ee4c 100644
> --- a/arch/x86/kvm/pmu.c
> +++ b/arch/x86/kvm/pmu.c
> @@ -744,16 +744,13 @@ int kvm_pmu_rdpmc(struct kvm_vcpu *vcpu, unsigned idx, u64 *data)
>         return 0;
>  }
>  
> -bool kvm_need_perf_global_ctrl_intercept(struct kvm_vcpu *vcpu)
> +static bool kvm_need_pmc_intercept(struct kvm_vcpu *vcpu)
>  {
>         struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
>  
>         if (!kvm_vcpu_has_mediated_pmu(vcpu))
>                 return true;
>  
> -       if (!kvm_pmu_has_perf_global_ctrl(pmu))
> -               return true;
> -
>         /*
>          * Note!  Check *host* PMU capabilities, not KVM's PMU capabilities, as
>          * KVM's capabilities are constrained based on KVM support, i.e. KVM's
> @@ -762,6 +759,13 @@ bool kvm_need_perf_global_ctrl_intercept(struct kvm_vcpu *vcpu)
>         return pmu->nr_arch_gp_counters != kvm_host_pmu.num_counters_gp ||
>                pmu->nr_arch_fixed_counters != kvm_host_pmu.num_counters_fixed;
>  }
> +
> +bool kvm_need_perf_global_ctrl_intercept(struct kvm_vcpu *vcpu)
> +{
> +
> +       return kvm_need_pmc_intercept(vcpu) ||
> +              !kvm_pmu_has_perf_global_ctrl(vcpu_to_pmu(vcpu));
> +}
>  EXPORT_SYMBOL_GPL(kvm_need_perf_global_ctrl_intercept);
>  
>  bool kvm_need_rdpmc_intercept(struct kvm_vcpu *vcpu)
> @@ -775,7 +779,7 @@ bool kvm_need_rdpmc_intercept(struct kvm_vcpu *vcpu)
>         if (enable_vmware_backdoor)
>                 return true;
>  
> -       return kvm_need_perf_global_ctrl_intercept(vcpu) ||
> +       return kvm_need_pmc_intercept(vcpu) ||
>                pmu->counter_bitmask[KVM_PMC_GP] != (BIT_ULL(kvm_host_pmu.bit_width_gp) - 1) ||
>                pmu->counter_bitmask[KVM_PMC_FIXED] != (BIT_ULL(kvm_host_pmu.bit_width_fixed) - 1);
>  }

This looks good. Thanks.

