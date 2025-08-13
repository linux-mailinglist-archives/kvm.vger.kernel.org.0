Return-Path: <kvm+bounces-54576-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 522A2B24662
	for <lists+kvm@lfdr.de>; Wed, 13 Aug 2025 12:01:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D2FCA883C8C
	for <lists+kvm@lfdr.de>; Wed, 13 Aug 2025 09:56:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D05A62BE03C;
	Wed, 13 Aug 2025 09:53:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="YnrY86Lo"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2064.outbound.protection.outlook.com [40.107.237.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4933A2BEFFF;
	Wed, 13 Aug 2025 09:53:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.64
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755078816; cv=fail; b=IspBBSzEMNovN6UoQ33eznuh8e4KRGsEFsqbnIQ90A9oRg4K6ztrck5I1w4m/DZKL1OZiFi6jeiYBl3k0oGnnQd5VEQZAQbgxGuijs2/hmfvXvDkxuEzSUh+8mWguxGQKpTZZEXIgIcrCvweLEQx2TwFFcQQJZB79WtfTny8u0s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755078816; c=relaxed/simple;
	bh=tJNg8UUS7XS/Wn0CZGsCbA2af9oA5aL6O5h0ia+0ksE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=s9b/MoLJ4S0nrXlz+STb8tDWGEOS2cac28m6juUUfcFR1DygnaBbPXQUDH8LaCuv8yPa8U7Wh7hNICvKOi9eKo7gsSLEVi54V1OwRcWjLoJaxyle7ht/8qPW+pJMb7nJ0Uiexu8xaatMAcPKIrcdUGuAr2IM1mhsHVot973OGv0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=YnrY86Lo; arc=fail smtp.client-ip=40.107.237.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QnRZ2LCgnfqaPZ2spfbhslsly1921CV+QBJ67XxcXPmS6imDXwn+GM5p8rHdyDHgk4EvOOBAMl1jX8PPRQGKoO8I/NoGy2gI1cdOMwnjfAk90E/P//PytysXWClP1SptfVFPhppWInCXTCQ6q356i0gassL3mU8d1T/asxD1DsnRusxM3/EVXnd6h88eF8wTmch8oPbSISPygbfhNN/ssi2y0+jeIUsqOZNcDDFA1CYotnlZDCAsclU6TwizKGf8QB4C9wnWRiPj069zq+iTwBmdh5ZFllDpMuXNIgCRHbC6Ggll6k2St//5JzgIHYPThnA/Zn5kfaWXOUnTgVhtwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OrSkvfYToHTUyge/jo6dP5fOjlkp1/mR//tsyWA3By8=;
 b=QIAezNpwH+QyUP7eQFpleyDMnb8l2Y1ruOOCI3gdZuEhz+KhUivF4j1Qyxuzh/CcUp/nXOMNRKlpkAGTY4aO1hpU3kRkjSFWs7NyHTm+4dJkEiEkfMzWQLrHGi7oz8+6rEiCK0KiUI4KOnzOWS3lJ9cEuiyGDCPyH4eVCKosif3yO+lnnNnbg0E2URV6gDfgqdj4ZVEqeC4YLGQQZJ8HieM64VKpLoHFWy2GSeA9YoZaA29q3aPhW09E3vegBd9dk1aQ1qsV8yYkuRYHMBFr42gqgLXrOwDlXnCGmUJksGxfG+Cpa0vQhWCtUa1ehuhMVGCIXWOhgfgy0ptmv3FYdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OrSkvfYToHTUyge/jo6dP5fOjlkp1/mR//tsyWA3By8=;
 b=YnrY86LooqEckW9JF4w/L2AQ4vxx8nfTJcBh/cGnKB0Ezy0E2Xz48jbJdQSkn2byOkawYe5rYNrfrmwEIsysDubam4JEC7KtPAQiS3wyLWqPl+VVFW+TrPFhnr78CwbOUjvQS2cWhsHSKNwflvblgibkzNjOaZUNxMtf/hSceJo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB5712.namprd12.prod.outlook.com (2603:10b6:510:1e3::13)
 by MW3PR12MB4458.namprd12.prod.outlook.com (2603:10b6:303:5d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.13; Wed, 13 Aug
 2025 09:53:31 +0000
Received: from PH7PR12MB5712.namprd12.prod.outlook.com
 ([fe80::2efc:dc9f:3ba8:3291]) by PH7PR12MB5712.namprd12.prod.outlook.com
 ([fe80::2efc:dc9f:3ba8:3291%4]) with mapi id 15.20.9009.021; Wed, 13 Aug 2025
 09:53:31 +0000
Message-ID: <91412178-04c6-4319-a5bc-a957217fea14@amd.com>
Date: Wed, 13 Aug 2025 15:23:17 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 38/44] KVM: x86/pmu: Disallow emulation in the fastpath
 if mediated PMCs are active
To: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oliver.upton@linux.dev>, Tianrui Zhao
 <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>,
 Huacai Chen <chenhuacai@kernel.org>, Anup Patel <anup@brainfault.org>,
 Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt
 <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Xin Li <xin@zytor.com>, "H. Peter Anvin" <hpa@zytor.com>,
 Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org, loongarch@lists.linux.dev,
 kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
 linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
 Kan Liang <kan.liang@linux.intel.com>, Yongwei Ma <yongwei.ma@intel.com>,
 Mingwei Zhang <mizhang@google.com>,
 Xiong Zhang <xiong.y.zhang@linux.intel.com>,
 Dapeng Mi <dapeng1.mi@linux.intel.com>
References: <20250806195706.1650976-1-seanjc@google.com>
 <20250806195706.1650976-39-seanjc@google.com>
Content-Language: en-US
From: Sandipan Das <sandipan.das@amd.com>
In-Reply-To: <20250806195706.1650976-39-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BMXP287CA0011.INDP287.PROD.OUTLOOK.COM
 (2603:1096:b00:2c::21) To PH7PR12MB5712.namprd12.prod.outlook.com
 (2603:10b6:510:1e3::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5712:EE_|MW3PR12MB4458:EE_
X-MS-Office365-Filtering-Correlation-Id: 27a5bb88-324e-4748-b788-08ddda4f428c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|921020|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?enVDWW9LNVRwNjNZQ2I0M2EwanphTmJ0M1ltcUtHSVpyVTE4NW5mVFd6ZXlE?=
 =?utf-8?B?dTNkakplY09mKzMrTWVMYndTSHQweVlBQWh6QUsxYW5EakNTTEgyeGdwQ1Vp?=
 =?utf-8?B?c1UzMFRsSmg0dU5mUWFhN3A1aEdqQnQrZzdtYVg5MGZad29aVnd1TXdPeU5U?=
 =?utf-8?B?ckNBMUlRNTBNNWJoMkhTOVEwRmREZkdHNVpIMkx5aVRTa090V1g0dW5KVFJ4?=
 =?utf-8?B?SE8yMmhkMVhGSTBsbnVJYnpkSDVKN1FKZG0rUG1leHhKTllUbEJuYkpzeUlE?=
 =?utf-8?B?TXA0eTdUMEV5NEdwUTF4MGxxSkpFa1VYSVJjRXpWTytRYjBiRjBhS3VXakxD?=
 =?utf-8?B?V3JTdWxXN3VZcW11bmQyb2hNcFZnYXN6eTVGclA2c0hNWXBqYWZCU3I1bjc5?=
 =?utf-8?B?c0lmdWl3OFI0M01Qc2dLWXVqSDFxeWRhbGxsQ0dNaGNETFNSU3A5VzdxN1dX?=
 =?utf-8?B?TzY2Y0Z2ODhTZGhsRUVuUWhVeHBhV2RHeGR3T0Vhc0N5STJ3dWZFc2JDcHJL?=
 =?utf-8?B?YTVWL3pURW9OdEZnU1Nsd0lLUTBvQTZoODVUK1FyQ05tYkRORVUwYVZMUENU?=
 =?utf-8?B?RzZPaTcrbmZiS0ROT0QxWkRtRFJCck9UemlXMU5tMHg1cXVMVXdVYW5Fellp?=
 =?utf-8?B?WTN3UWFMZG1mSDMwZDJ6bTV6TytaWXBsT0ZXUDNEK09ub0NZNWNsczRTZHNy?=
 =?utf-8?B?K3dQKy9uTEhGa2dWVjNPekFNSnN3Q0Rqa1YzY0FydFcvQ0RaeDg4ZTJiNTVE?=
 =?utf-8?B?T29VQ0tKVkJHc0NsMUMrOXdVZ2Jta0JjYkJPQ2N2VlpmcHpkV2Y1d1RlQWtu?=
 =?utf-8?B?MGprTFNXTGt4TUEzTElyTjJVUkJIMkZCTTc2SXVnUDNESkF3YkJiRU5CbEVz?=
 =?utf-8?B?S295NW94STh3Z2VGVzlWT3JOeGdhMXNMN0lGYkFnRzRYU1dzMlFHWmNmNWlo?=
 =?utf-8?B?SkZSUzNEYkRQWmtKVjdHOFBrV1ovRkVlQWpVVmxXcS9YMXY4TytQQ240TDhl?=
 =?utf-8?B?UEFHY0hHWmJ3TkNlOEptM2lRVTBycDV1d1YwWG93clpqbFpoUDhSQ21BWGo3?=
 =?utf-8?B?TWJkd1BvZUZaemlJZzFtb2ZGd1lqWUxvRjlTN0w4MURnYnY0QjNLVVFFQy9X?=
 =?utf-8?B?a3cvamVpU0w5S0dPaFI2eFlsQnRlWDBnWk4raFh5OUlhai9sU3FYME1QNUU5?=
 =?utf-8?B?OEsyd00rWnNOcWJaRFdURnd1dnl2RDBNY2RMNk5PRVl2dG9ES3JVeCtPekI2?=
 =?utf-8?B?Qm1jQVVXQ2hCdHdUYlRsaGJMcFp0eGFLWWl2eWJ2VkV5MDVOTWZFKzVQcTls?=
 =?utf-8?B?OWhqcjgxd1VmdFNDaGdLRXdxWVBtM2w0YWlhVThkNkFoTW5VRUpieFRBS2Ix?=
 =?utf-8?B?c0pEN3dabk43U1N4OU5tTjNtK0gvbkVRbEFRa2MvWlJIYUNjQjhLaWdoMGZC?=
 =?utf-8?B?VXBHQ0FUczloT0FCSktsbE9GWDBQaE9jZDdoQ1FlbStRWGp1dG43VUdhS2dv?=
 =?utf-8?B?dVRsQW54UUxCNVl3WGQ5cUo3VFZRSWVVMW1Ga0JTeXY4a3Nta3E4YkZmanhZ?=
 =?utf-8?B?M0lONlozYjBMWXBlUW1nVUsvSTBPeUVUMW9sNTNBc1ltek5YcWtDRVBibU44?=
 =?utf-8?B?VkJkVzRTcnp3cUZGZkQ5UEp0aDBzWHFDMUlhQnNOa0txQWdKeTNjZFhLVCtN?=
 =?utf-8?B?R2xPd1pkN3JXN3hMZWhmMlczS2h4akxJTDc0d3FqKzRUU3VhbXBOVDhLLzVY?=
 =?utf-8?B?aDl5VlZUeGxvVSt2YTRBL3pPZjM3UU8wdU9VVnlxbU42U0p3c01zTlJ1S0Zz?=
 =?utf-8?B?cGgxTjB0WFZhQVJxTDNnSnBVWDhLTjFXNEo1djVuelgrdlA3cXFJbmpiUGpj?=
 =?utf-8?B?Tmc0QjVTMVJnY3FYQTRIZkVMZnJRWU1oNFJKRlVTM20xWUs0QUR5R09oWGVj?=
 =?utf-8?Q?AAwdYzsWewVRG7/fpQMIbtjDNQ4dtkO7?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5712.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(921020)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NE1ic3VKQlN6ZG1PckYxMHdUbXVJZXV6eDh3bGlRbHNNdnN4UmgrSXJlTUQ5?=
 =?utf-8?B?YmpEb3Bkb3psWWJCYlVjVVNrTE0yUDFOK2FhVC9wQ3hXc3V4RmhqVmhLRzly?=
 =?utf-8?B?T1VCZDhISFRvaXczcmlpMUVkTzh6SEwzVndJMHBVVThKVjdDRHhiR2xiZy9W?=
 =?utf-8?B?YlhySElJQ3c2dDVKNGVRNGRpbHZ5eDFkNEVVY2hNMGhyMHQxVXM3SENhaHdK?=
 =?utf-8?B?LzV3T0wralBvbFFSRmRiRmlxQVhpSitJTE9sUjdpc3N3WXVTeEM5bGJCVjNT?=
 =?utf-8?B?V1liUUltWTNNRFExZjNWaEdZTUVHK0lRNmZDNnZrcktDa3IyYTJZckpLNkFI?=
 =?utf-8?B?akU3aG1BRkxrNnl4QVFXS3Z6NkFxZ2JKVVVDRWhlbVI3NjlDSEhYeFlTbGts?=
 =?utf-8?B?REFXaGxJbTIycjBFcFE2NldqN1ZkOGxVaFA3OGpxenhObjZMYVluM3FVUjBN?=
 =?utf-8?B?THEzbU5QTFkvU0EyaWMvRG5CRmtmOG80Zk5nOE5aRW14QmNPZ2g1dHlRVyt1?=
 =?utf-8?B?VzVyRlZ4QnF0UkU3OTQzemZNWnp6Q3c2ZHJxUDBKdWlPSUNYeWgrcll6ckRk?=
 =?utf-8?B?ZE1NckF6ZDJURHk2WVp2QTMzUWY0ZXB0c3hyMy9lYXpCY3ZFOVVLRVoxYWVZ?=
 =?utf-8?B?Ujl3UE53amhSa2d2MUV0azFRV0QzdHZwV3gwTVZlR1Z4VzdFdUhMVnEzeTdx?=
 =?utf-8?B?UE1jVXo0NDg5aHFUV2tZQU5OemE5US9xQzREWk5IYVNVZGcxTmk5aDZLZXdp?=
 =?utf-8?B?K0xwZ3JiL3JTTU1nTkt2YUE2U0Rycmt3Q0VMM0tWYTZOcWdsNFhoeDFWUVdh?=
 =?utf-8?B?OUJ2cnI5SEpRUUIxNTBjaWJnY09DQW5VUnV0bHlNV2FOZk1qeFYrNzdKL3Rm?=
 =?utf-8?B?THdMSTg3enFGOW11VU8rcVlGR2hzT2RhMXdZM2J4ejBwOGNhdzQvNGgzS0hn?=
 =?utf-8?B?YTFuQ0h6VDNhaEJyQ3l1SjZhVnRXRVlCbm05c3Q3bERuWm4xZGI2Ti90Y0ZC?=
 =?utf-8?B?U1AzbjI1UFFUc0xqZU1WaGFPTUVKajVQUkRkd1hmdWkvb2RrT2lRQm0xa2tM?=
 =?utf-8?B?MFcxQllzUGhBVDR2VU5MRGZoZUFpK0dWRmNocTdESklOaG9MUEJpeHloYjBZ?=
 =?utf-8?B?Q0pkYlVQaDVBV1hOejdNVVRqdjBPZmUxcllPSWNiWXlLZkFKaUhZakpZQlpI?=
 =?utf-8?B?dHFNNENoYktaZEtwTDQwUTJweS9jOTg5SG1TUi8wQmVOKzRMZjcrZzB1MWM1?=
 =?utf-8?B?Z1ZxTjRGRWErR1dPU1pIZzhFMmF6cVJvN2ZzZlgvSEFjeVYvS3ZhdXpKU29p?=
 =?utf-8?B?UVdlQ2dtelVwZjgxUmxrVW1HMzlyb2RCTUhNdi9XQlBndzVTZDRsTDQrN01j?=
 =?utf-8?B?RWRpT1l4OC9qZnBRZnk4Ukdob3ZrT25WQzdiSHBCQmg1bmtaVFZDR29BUDZi?=
 =?utf-8?B?SStsM0g4WmNsTDhpaWkrR2p2WG5NRm12a1ovNVhLMkFsOVB0SFVhTW5nZHV4?=
 =?utf-8?B?Zk9GbDR5aTJFbXJxalpqUG1tamhaWFNzNDA0NVkwWCtyZDRjQjJ0RkVwdzIx?=
 =?utf-8?B?Sk8wNnllV0xTcVV3ZVAyZFdIMzJBR29zQm8zT2Raak9yNEZiS2k5STdReEQ1?=
 =?utf-8?B?WUp0b01JYlhsenYxVm5OMllOaEgrcnZvSXl5Z0RUS0duRHU1cWo2aDBvaVQ4?=
 =?utf-8?B?bDhVZ3FOLytKbXJYR1RFclFNSnFnNzI5S2d4Q0Y1NWlMdzVabnVaMVB2OEUx?=
 =?utf-8?B?MTlNeDdFUEdoOWdPeHF3SjhKcngzcytsQUJSQnplVzhacHg4SWx1MTdiZVBk?=
 =?utf-8?B?cjBxWTJzTjFxa0NJS3FUR1ZzZkJtNHhBYXVVcXRqaXR5c0pWUU1BYnFoRmdG?=
 =?utf-8?B?TjRYS3FzNkNzYVZLVWdRNEZBSmIxQWJSbkxaVkpLRG40cnNpUnlNdW5mSHJz?=
 =?utf-8?B?S3JydWhrN3d2WGNjWERaQ1ZkeThvNFRYa3RMbitXNkYwTGg2WWJNay8yeXdk?=
 =?utf-8?B?ZjZlZHhQWloyTThXZ2xVRDJuTDlBbnJWT2h2U2UzcmhwVUxWYnAzeWN5djRU?=
 =?utf-8?B?VllwSmJFQ1pnRjRoV0dMR29JSDlXWm8xQStrenNGTzJGb1VJekZ3Situazl5?=
 =?utf-8?Q?0DR3pU4XF5pa0g+hKrRhnFMYX?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 27a5bb88-324e-4748-b788-08ddda4f428c
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5712.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Aug 2025 09:53:31.4109
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bize9yUD5qWua65zTBWx+3wLS0cbG3sZINjDIPP2BKXuIRRBRWVh6tIANH+/uxhl03w2b38dluC87g9Qh9dTLA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4458

On 07-08-2025 01:27, Sean Christopherson wrote:
> Don't handle exits in the fastpath if emulation is required, i.e. if an
> instruction needs to be skipped, the mediated PMU is enabled, and one or
> more PMCs is counting instructions.  With the mediated PMU, KVM's cache of
> PMU state is inconsistent with respect to hardware until KVM exits the
> inner run loop (when the mediated PMU is "put").
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/pmu.h | 10 ++++++++++
>  arch/x86/kvm/x86.c |  9 +++++++++
>  2 files changed, 19 insertions(+)
> 
> diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
> index e2e2d8476a3f..a0cd42cbea9d 100644
> --- a/arch/x86/kvm/pmu.h
> +++ b/arch/x86/kvm/pmu.h
> @@ -234,6 +234,16 @@ static inline bool pmc_is_globally_enabled(struct kvm_pmc *pmc)
>  	return test_bit(pmc->idx, (unsigned long *)&pmu->global_ctrl);
>  }
>  
> +static inline bool kvm_pmu_is_fastpath_emulation_allowed(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
> +
> +	return !kvm_vcpu_has_mediated_pmu(vcpu) ||
> +	       !bitmap_intersects(pmu->pmc_counting_instructions,
> +				  (unsigned long *)&pmu->global_ctrl,
> +				  X86_PMC_IDX_MAX);
> +}
> +
>  void kvm_pmu_deliver_pmi(struct kvm_vcpu *vcpu);
>  void kvm_pmu_handle_event(struct kvm_vcpu *vcpu);
>  int kvm_pmu_rdpmc(struct kvm_vcpu *vcpu, unsigned pmc, u64 *data);
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 7fb94ef64e18..6bdf7ef0b535 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -2092,6 +2092,9 @@ EXPORT_SYMBOL_GPL(kvm_emulate_invd);
>  
>  fastpath_t handle_fastpath_invd(struct kvm_vcpu *vcpu)
>  {
> +	if (!kvm_pmu_is_fastpath_emulation_allowed(vcpu))
> +		return EXIT_FASTPATH_NONE;
> +
>  	if (!kvm_emulate_invd(vcpu))
>  		return EXIT_FASTPATH_EXIT_USERSPACE;
>  
> @@ -2151,6 +2154,9 @@ fastpath_t handle_fastpath_set_msr_irqoff(struct kvm_vcpu *vcpu)
>  	u64 data = kvm_read_edx_eax(vcpu);
>  	u32 msr = kvm_rcx_read(vcpu);
>  
> +	if (!kvm_pmu_is_fastpath_emulation_allowed(vcpu))
> +		return EXIT_FASTPATH_NONE;
> +
>  	switch (msr) {
>  	case APIC_BASE_MSR + (APIC_ICR >> 4):
>  		if (!lapic_in_kernel(vcpu) || !apic_x2apic_mode(vcpu->arch.apic) ||
> @@ -11267,6 +11273,9 @@ EXPORT_SYMBOL_GPL(kvm_emulate_halt);
>  
>  fastpath_t handle_fastpath_hlt(struct kvm_vcpu *vcpu)
>  {
> +	if (!kvm_pmu_is_fastpath_emulation_allowed(vcpu))
> +		return EXIT_FASTPATH_NONE;
> +
>  	if (!kvm_emulate_halt(vcpu))
>  		return EXIT_FASTPATH_EXIT_USERSPACE;
>  

Reviewed-by: Sandipan Das <sandipan.das@amd.com>


