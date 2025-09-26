Return-Path: <kvm+bounces-58849-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B2F11BA2A7A
	for <lists+kvm@lfdr.de>; Fri, 26 Sep 2025 09:13:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DDB8C1882A59
	for <lists+kvm@lfdr.de>; Fri, 26 Sep 2025 07:13:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E33002868BA;
	Fri, 26 Sep 2025 07:13:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="AIS8tK5E"
X-Original-To: kvm@vger.kernel.org
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012022.outbound.protection.outlook.com [52.101.43.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EA6227F4CE;
	Fri, 26 Sep 2025 07:13:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.22
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758870793; cv=fail; b=L/YlxWMHeZgY0fqupYO/CfXUjsXy3Q3gt3PKaNuG2kTbBB1JgnA7n9hJDFED7bVD8Ll07ZHOjGd5xRM2eBmNlo2SGyztRudYTeHv86j5KBAaEvZYC6E9i+Pq8DKaQ/YaxYtsxjh5ZmLiwj9yhdt1BBso4C+trD4OQ/sJkdyhsAU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758870793; c=relaxed/simple;
	bh=KoLXqJMKnPNS0wWvOb1w1E4jMz19Cy+J1BHiemsjprQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=L0nXJxrzOe6Yr5qX001CbZvtFrTDQzIbT/GocWYXj6SxNwI9lrNz4AlWjXt2FoMtrUKow1ITaHVRuEriio5ys+iNN/zOUskTt2aW7NhjaQ80YQPTGfuMVrXUr65i2ZHoamc/uCH+FXZy1b6kHHL/FoYuSjejYy03uIM5mvEi4vk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=AIS8tK5E; arc=fail smtp.client-ip=52.101.43.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nzua3Sox0lAXBVSaPMqEk8USCdF32UzaJhFu78/PtVrItVuIh+0/zLUZ+YTrOSMlnGcjBrkpd+FjdJCz8PZ/XRAk6ldKOKx3L8Pydahzj3RZcc9kMUyLGx/avXtCrWo6ZHstjJQ79RWLmJeiNWUjQfENJKFjC/dOUqxkWSGiXOesFM5YySs7RUJNKo93W6ySkmzgTRNjxgeDSIL2qdl+VluH9qlWSrplvx/lTMzuQdGeAPQuHg93VwW4AZ1PHvT0DhKKHTmg6R3Tq4/1YN3oK75ct10mqDyu69LPJOwF6/S9ZJPVOSwdbrS3y8fIPuo1wmhTyObJdaUwBHdC/AR50Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2vpVfG7RLRw8H16WuZjgOBjnzonFtRr6h55U0N8epS8=;
 b=eeoYeRW248aF1M5KTe1owC9KaEIg2lVfvdIsYrcy80VDgl/JGJU/t53Kbb1VkJjZYyyu2mIz2mwbkNrGKnUHjiuU8Jmx5oH70KbXpvHVAHy9+eoQ7j5FQaU77YhcRaauOx611uOpL3jMUHpgWyksvh/OXUMhIrGhu3ThsOLmfxTS52xfb1ADNBmDnVeuemQvHMnrkpSTX9Nf2WA3vCofyZEIGnm/6c/8vshMVapVOZll9GcW00YxS90cfyxlWxKdAviboBy2THCUHZkinnMc2z6laydgb2lkYCByc/YNwFq5nXU1hBs7e3/OzcVC5dstF0qYD1lpeZEmgkewcahjYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2vpVfG7RLRw8H16WuZjgOBjnzonFtRr6h55U0N8epS8=;
 b=AIS8tK5EUfT6YP9QFpeCeFtNCNYN9zcHWPhDgbDJzlPtTMg5FBP6f6O47OxgYteNgHcGwT8R/aVI9RSlJWpkt4xs/WCkdaauPf8H8sOmKbLlgsgGQXuNd3lF/m4dreb7wNC/oGf/NwPQwnGkc/iK1+jPs0YojrV9QcsgiHIlBVk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB5712.namprd12.prod.outlook.com (2603:10b6:510:1e3::13)
 by PH7PR12MB8121.namprd12.prod.outlook.com (2603:10b6:510:2b5::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.13; Fri, 26 Sep
 2025 07:13:08 +0000
Received: from PH7PR12MB5712.namprd12.prod.outlook.com
 ([fe80::2efc:dc9f:3ba8:3291]) by PH7PR12MB5712.namprd12.prod.outlook.com
 ([fe80::2efc:dc9f:3ba8:3291%6]) with mapi id 15.20.9160.008; Fri, 26 Sep 2025
 07:13:08 +0000
Message-ID: <f896966e-8925-4b4f-8f0d-f1ae8aa197f7@amd.com>
Date: Fri, 26 Sep 2025 12:42:50 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 32/44] KVM: x86/pmu: Disable interception of select PMU
 MSRs for mediated vPMUs
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
 Sandipan Das <sandipan.das@amd.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>
References: <20250806195706.1650976-1-seanjc@google.com>
 <20250806195706.1650976-33-seanjc@google.com>
Content-Language: en-US
From: Sandipan Das <sandidas@amd.com>
In-Reply-To: <20250806195706.1650976-33-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0184.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:e8::8) To PH7PR12MB5712.namprd12.prod.outlook.com
 (2603:10b6:510:1e3::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5712:EE_|PH7PR12MB8121:EE_
X-MS-Office365-Filtering-Correlation-Id: cc94f5c9-f0ee-468d-94f6-08ddfccc24b8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|921020|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dFhROFNlSkYxbWs3SFJnQXVmMVpDZkJ0eStKTFBxQXBPczFoNlhrcEVnclM3?=
 =?utf-8?B?UFR2NmR0bjdEM0xKNUJZMVZHNDBKWUczcXM5MTB0QzNOZzdDVXdOK1dhTGRN?=
 =?utf-8?B?Y0tQM1RBVGl2M3ZaMU9IMXpyVFBsS3hVQkpGaVpPOW83SURvdjVGa3lySjZJ?=
 =?utf-8?B?QmxtRlRiUHhxRHlETjR5UjEyNnkwVjl1d01xRE9ZRXMvNEpSQVgxS0NEeGZE?=
 =?utf-8?B?cThNa1BUbXZUSGJYazVzZXBDMlMvUUR4TWhEVjRuWXo2eStMWU9yV3ErYTR5?=
 =?utf-8?B?eVBOYzMyd2dmMjd1OXZua1h0N0dId2Y5WGlibVZ4Rlg1ZUttanowZzNFeU5j?=
 =?utf-8?B?M0czaUQzUUdraDNDMjJ4NTRmc1FJdEVLbHdIckFGZmJ2YUkyMXlrQzNSSTAw?=
 =?utf-8?B?U0hJYWF5TUxxRFFjWTMwT2pqK0JjUmRMYnY0NmhiVlR4VVhURm5QdHYvT1BR?=
 =?utf-8?B?NTBTZDRFeEk5SDl3R1dKekFFNlpueHhqK3NMSEt0NXRPVkVuZ2JWVHpRVy9R?=
 =?utf-8?B?SlA3M3VRbCtjWTJMdVJkSU1lU0l1VzdJNDFvRUdvTWkrRFJWemFTZVhvMTA1?=
 =?utf-8?B?dml0dlM2QXVXa3BqdDZQU1pxNUh2U2dvRUpxS3FFQUFlamRuR1VWRFU3bXhN?=
 =?utf-8?B?U3VSL3FOUnhtU212bG1zMlhMUjcvQmhzWjArQWh3VEp6NVFqRHRzSERUSTd6?=
 =?utf-8?B?bVRkei9vYkxId0ZuWE5nOVZtMjNTaUxBRlJKcVdOUlQ3b0lraVZwMlRWWEdH?=
 =?utf-8?B?WEJTT2F6NEJuSkhOWWxsMThiNVd1VFVVNzlBbG5zMkpieVNtdGNGcGd6dG5T?=
 =?utf-8?B?cUlUSytWOS8zbk84cFRXNmJQVzlidkZnM2Rwak1xaDk3QnljWjVENUx1NmRN?=
 =?utf-8?B?SEt5UkRxZ3pYSkNybXRkLzZJVkpqS3duZ3h2WllUU1AyZE5KcDVUKzd0Kytn?=
 =?utf-8?B?ZWhMaWdBSmsrZzVJcjMyKzd3QURra1Y2bS9rMThCMlI3MXJGUUhWNGJFWnox?=
 =?utf-8?B?SXpaNXhkYnc5QnBHVmordnFkWis1ZG4yU0lvdXNUZEZ5UUtKYTBlOW5xS2VK?=
 =?utf-8?B?ek1OeTVXUHlkRFg5MGhGTlBzdVpTWm4yZS9DQzZKcDRVbjlwZEpseTUzUWx1?=
 =?utf-8?B?RXhabXJuQ2JHTHNianpBUnQyQ0tSQzFiVXp3UkN4ajEyanVlbnBac1BDSnlJ?=
 =?utf-8?B?OWQrRGFYSFN0aUQ2a2F5L0tZaGdOVEFaengrbnhBU2d1M3hpUGhGTXZUS0pQ?=
 =?utf-8?B?U2NYcEwxRmZ2Y0pjNER0Z1RiN2k4azlDbHowMDhlbm9xTGZoblhCL1J5QjV3?=
 =?utf-8?B?U3EwaTVnZWVib21JUGFwUGxPUjVESU56SzNCaHc4QjNCT082RWJTV29CYjNZ?=
 =?utf-8?B?OHF0SFIrbFdEb1Z6TDVyYi84SElGTjRNTzI5ZzJiclpPRlI0ZExKeWVOZDhv?=
 =?utf-8?B?SzN3YUVQejlKT2ZxQVY3bjJmemp5c0RJaXk1RVJSOHFCdHpVNjlKR3ZHb3Yy?=
 =?utf-8?B?aWZBL0ZMelRhZnpuOHBNbmMxWTRjSGtRQ0xZQlVybE01WGdiNmJub2trOUhI?=
 =?utf-8?B?NjJLTzlXcm9hdEpYNXlXdyttMEFUN0dTMW93S3BLWVM3WGJxd2plRXk0QWJI?=
 =?utf-8?B?Y3dGYUdMcGE0bGNLWGFXTEtCMUU0UG4xQml0d3VqZ1BVS0xkbEp0ZDcyN0hL?=
 =?utf-8?B?UGdnblA4Z3FoaWZyRnhlME9KVS9BMTkvU3ZvTTNhNDYveUNyeDNlOEJHT1VU?=
 =?utf-8?B?WUVFOFdYNXZ2Q1ZjQVg5MlI0TlJFL2dzdVR1cC9XdWhjc0R5TGxRQ2tFNTFO?=
 =?utf-8?B?TkxYaWlYNlhhZHhOdjd5bDNJYUxLdXp2MnlyRDArYTZRZ1FXSXVVak0rRk5l?=
 =?utf-8?B?cGl1OEFoaW5NcnFhY0NXMUZqcWRxa1Y4MUQ5YVdTREVRcnIvNjA4RU41UmRD?=
 =?utf-8?B?OVd5ZmxlSEpMMEF0TEpyL1hqWThVUE1mVUVNK0xXR25JS1duZURJWG1ySFJN?=
 =?utf-8?B?NDcxSFhVOXZRPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5712.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(921020)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?REZJSXdZTStoMG5pdDZTejQ5ODZ5Qlh3ZnM0ZytUSnlMZG9zQzBCTW9SVEo2?=
 =?utf-8?B?WUZVckpEOWV5TmVpWkZZYjBHbzM5ZDNSNjd2ZzFnQ2I4a1dndUNIK1BIVEN5?=
 =?utf-8?B?MlF3R2NlVTVMM3htR1d4VTNkTVpBUkc3RVR3SmxnV0lsL0N0ems4bWdPVlhl?=
 =?utf-8?B?UlRiZ2M2emF0WXVtak5mSWxaRittRnZndkgyWWw0Vk1PcXZmNkVJWWJNcEJz?=
 =?utf-8?B?S20zbGRLNnI5Wi9xZGh2U1ZIMHQxRTV0VUpQbVQ0YUVCc0k3WDR5Z2x0bE5P?=
 =?utf-8?B?Um9pQmUwZk1BdFFOSXFHeEZvYjl0L0hrajZEdGVHV1dicTBzUnhCdkJTWWdz?=
 =?utf-8?B?aUwrUllzSktSeVY5dFRZYng1bEFlNGMwMW52U3R2NmFud0NVeEVKbUhkRmJk?=
 =?utf-8?B?Q2kvZHFoNW11UWlLTWVJRGdpMnpIM3FEUlBQOWhQOEM0VGNhakJqeHhxOTVF?=
 =?utf-8?B?VFNiUUFycnBXR0NILzJiU1JqSjdIMjc0RmpuSDZkSjNYenVwemtpOFRuVjJn?=
 =?utf-8?B?MHZWZFo0TUV0ek8xYlZDa2dwTzZnZEVpQkYrNm4vZmY2UG1YdjMvd0VST0NV?=
 =?utf-8?B?cmtXalJxbTJoR1MvSm9nUGVodzFoUkViMWZrRFk4SnhGQXJXeTNzWGV2c2lK?=
 =?utf-8?B?bzN1eExqd29IRHFPZk91bTRTUjJ6NFkrQjhkd0ZzZEZGOFFTd0M4RmNpSjhU?=
 =?utf-8?B?UnFweXZoWGxDa1AwNEJKcXZpREhGSnZKS2dWZVVIRHNDNDRpWWY2Nk9Qa0Y4?=
 =?utf-8?B?NFdzbDhXZUpZTWVIcGFrNyswblBhWDJPK0NHNm1pNXlrS1Z1WUlqZ0Zhayt1?=
 =?utf-8?B?d2xhYkhoQ1NWODJrUHhLV3BNdVBiMzM4RWZwMGo2Y3BYVElwMllJNkhiWlp6?=
 =?utf-8?B?a2J5WHk5M3lhbFZib2I2SzV3TDEyc21QKzFNdnlBcEQzbkdiNGN0U2ZlaGNR?=
 =?utf-8?B?b09kU1puQkwvM1VQbDVhcXg5NWZkaWZDcy9JUithK0RNNGRqWVZ0bUhjcCtX?=
 =?utf-8?B?VmNlS25mV1ZJTm1Wb2ZFR2orTWRkZklKcVJoVzhlSGlpOER6Y0psZEtOTjhH?=
 =?utf-8?B?MzhPK0VHdWJZRTEvcHBsNWpKNGRZWWErdGIrWm90NU9MY3UxQ1JjZFdpRXBY?=
 =?utf-8?B?VXJ1QXNUY3hqeC9wcUxPRDBEYzdMVmZOZHd3RXNRUmttUTlIRk4rUHpYNlNK?=
 =?utf-8?B?TkEwMmtzSlQ3SWdqU2Qyd0lPRlpVWUxHQW9nUmdyeU5YcGpsWWI3bGZKL3JD?=
 =?utf-8?B?QVBtRjFzVmF0WkRsVkVhM3R0VGxjMG1vcGVVTEl6ajFZSHZXbzhKTzVGWm0z?=
 =?utf-8?B?b2ZmQkE5Q2ZDOEdVMTRvR0FNaWFSV1ZjejNpOGoveWdNT1FFWTA4eUVmL3hl?=
 =?utf-8?B?THQwdkM3UTl6S1RnTnQ3YTNnR0E4QlFWS1U5dnBUUjFKako3WjhXeXRJdnlS?=
 =?utf-8?B?ajdrcnZTVmJYY3k4RnpIOVNNc21pTHdZdjVTbDEvNFN3dGJHQldPeGE5MlJ3?=
 =?utf-8?B?NUNWL1ZtR3lTMzhMYXpLTmtMYm1lbW1aektVOGxqd285OUtzQ1g5U0Roa3Vo?=
 =?utf-8?B?VUJDVy9kK0h3cUY1TDR1c2kwbjNLMTlxV1RUMlBNa2RrSCtoKzQ5cThIWTJ2?=
 =?utf-8?B?V003VUlKVXJmY2lXYWxJcnpvaFlCakxnSVNpUFo1ZUM1N1JSSUlCODYxSHFV?=
 =?utf-8?B?eEFnZEpiOHQ4dm5rYVpxN24zUEdRZ1oxdGVhdTlMckJIZ2tvaU8zSnlFVGE1?=
 =?utf-8?B?NVJGL2VMVHpUcXNzODJTcFpMb2wyOG9KQWo3SDJqUnZhTk1xdytiZVZScXpX?=
 =?utf-8?B?U0UrTnJxckQ3bGpOUGxrRm5rNTd6OUt0bmVSU3E0QzN0NnYyR0J2ZTVHcno2?=
 =?utf-8?B?RFBIQ2x1cUFzUm8rdGQzWkd0UTgvYWlSRWlvelVMSzZRdVduWDlVZTdlb1l0?=
 =?utf-8?B?S1dhSkJGUXhGQnNGRWhNaDByUE9lVlhCdnJ3VElMUThZL2RLUnovaEc4YS8y?=
 =?utf-8?B?c2pVc0QrRmdaTXdFUUlVMzNva2ROYTllanhSMlZNRWV1aVZ0Y21HSVNqc1FR?=
 =?utf-8?B?OUZ0VFhadmN2U3ZocmkrNzhQOW5qc0ZtbDRrdnFMTk5IekN0L3V5SWJTVmhi?=
 =?utf-8?Q?dGMU2WIj7J3DZKmgi6VrmV7y2?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc94f5c9-f0ee-468d-94f6-08ddfccc24b8
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5712.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2025 07:13:08.0442
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3DOCVJ15s68FUHCLwewWv+n/BYJGdzjXwaWofriXgT00d0pCfmxE4y0lT7CTE/Q9MOuy/vImG91TiQBXnuCI+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8121

On 8/7/2025 1:26 AM, Sean Christopherson wrote:
> From: Dapeng Mi <dapeng1.mi@linux.intel.com>
> 
> For vCPUs with a mediated vPMU, disable interception of counter MSRs for
> PMCs that are exposed to the guest, and for GLOBAL_CTRL and related MSRs
> if they are fully supported according to the vCPU model, i.e. if the MSRs
> and all bits supported by hardware exist from the guest's point of view.
> 
> Do NOT passthrough event selector or fixed counter control MSRs, so that
> KVM can enforce userspace-defined event filters, e.g. to prevent use of
> AnyThread events (which is unfortunately a setting in the fixed counter
> control MSR).
> 
> Defer support for nested passthrough of mediated PMU MSRs to the future,
> as the logic for nested MSR interception is unfortunately vendor specific.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Co-developed-by: Mingwei Zhang <mizhang@google.com>
> Signed-off-by: Mingwei Zhang <mizhang@google.com>
> Co-developed-by: Sandipan Das <sandipan.das@amd.com>
> Signed-off-by: Sandipan Das <sandipan.das@amd.com>
> Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
> [sean: squash patches, massage changelog, refresh VMX MSRs on filter change]
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/include/asm/msr-index.h |  1 +
>  arch/x86/kvm/pmu.c               | 34 ++++++++++++------
>  arch/x86/kvm/pmu.h               |  1 +
>  arch/x86/kvm/svm/svm.c           | 36 +++++++++++++++++++
>  arch/x86/kvm/vmx/pmu_intel.c     | 13 -------
>  arch/x86/kvm/vmx/pmu_intel.h     | 15 ++++++++
>  arch/x86/kvm/vmx/vmx.c           | 59 ++++++++++++++++++++++++++------
>  7 files changed, 124 insertions(+), 35 deletions(-)
> 
> diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
> index f19d1ee9a396..06bd7aaae931 100644
> --- a/arch/x86/include/asm/msr-index.h
> +++ b/arch/x86/include/asm/msr-index.h
> @@ -736,6 +736,7 @@
>  #define MSR_AMD64_PERF_CNTR_GLOBAL_STATUS	0xc0000300
>  #define MSR_AMD64_PERF_CNTR_GLOBAL_CTL		0xc0000301
>  #define MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_CLR	0xc0000302
> +#define MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_SET	0xc0000303
>  
>  /* AMD Last Branch Record MSRs */
>  #define MSR_AMD64_LBR_SELECT			0xc000010e
> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> index 4246e1d2cfcc..817ef852bdf9 100644
> --- a/arch/x86/kvm/pmu.c
> +++ b/arch/x86/kvm/pmu.c
> @@ -715,18 +715,14 @@ int kvm_pmu_rdpmc(struct kvm_vcpu *vcpu, unsigned idx, u64 *data)
>  	return 0;
>  }
>  
> -bool kvm_need_rdpmc_intercept(struct kvm_vcpu *vcpu)
> +bool kvm_need_perf_global_ctrl_intercept(struct kvm_vcpu *vcpu)
>  {
>  	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
>  
>  	if (!kvm_vcpu_has_mediated_pmu(vcpu))
>  		return true;
>  
> -	/*
> -	 * VMware allows access to these Pseduo-PMCs even when read via RDPMC
> -	 * in Ring3 when CR4.PCE=0.
> -	 */
> -	if (enable_vmware_backdoor)
> +	if (!kvm_pmu_has_perf_global_ctrl(pmu))
>  		return true;
>  
>  	/*
> @@ -735,7 +731,22 @@ bool kvm_need_rdpmc_intercept(struct kvm_vcpu *vcpu)
>  	 * capabilities themselves may be a subset of hardware capabilities.
>  	 */
>  	return pmu->nr_arch_gp_counters != kvm_host_pmu.num_counters_gp ||
> -	       pmu->nr_arch_fixed_counters != kvm_host_pmu.num_counters_fixed ||
> +	       pmu->nr_arch_fixed_counters != kvm_host_pmu.num_counters_fixed;
> +}
> +EXPORT_SYMBOL_GPL(kvm_need_perf_global_ctrl_intercept);
> +
> +bool kvm_need_rdpmc_intercept(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
> +
> +	/*
> +	 * VMware allows access to these Pseduo-PMCs even when read via RDPMC
> +	 * in Ring3 when CR4.PCE=0.
> +	 */
> +	if (enable_vmware_backdoor)
> +		return true;
> +
> +	return kvm_need_perf_global_ctrl_intercept(vcpu) ||
>  	       pmu->counter_bitmask[KVM_PMC_GP] != (BIT_ULL(kvm_host_pmu.bit_width_gp) - 1) ||
>  	       pmu->counter_bitmask[KVM_PMC_FIXED] != (BIT_ULL(kvm_host_pmu.bit_width_fixed) - 1);
>  }

There is a case for AMD processors where the global MSRs are absent in the guest
but the guest still uses the same number of counters as what is advertised by the
host capabilities. So RDPMC interception is not necessary for all cases where
global control is unavailable.

> @@ -927,11 +938,12 @@ void kvm_pmu_refresh(struct kvm_vcpu *vcpu)
>  	 * in the global controls).  Emulate that behavior when refreshing the
>  	 * PMU so that userspace doesn't need to manually set PERF_GLOBAL_CTRL.
>  	 */
> -	if (kvm_pmu_has_perf_global_ctrl(pmu) && pmu->nr_arch_gp_counters) {
> +	if (pmu->nr_arch_gp_counters &&
> +	    (kvm_pmu_has_perf_global_ctrl(pmu) || kvm_vcpu_has_mediated_pmu(vcpu)))
>  		pmu->global_ctrl = GENMASK_ULL(pmu->nr_arch_gp_counters - 1, 0);
> -		if (kvm_vcpu_has_mediated_pmu(vcpu))
> -			kvm_pmu_call(write_global_ctrl)(pmu->global_ctrl);
> -	}
> +
> +	if (kvm_vcpu_has_mediated_pmu(vcpu))
> +		kvm_pmu_call(write_global_ctrl)(pmu->global_ctrl);
>  
>  	bitmap_set(pmu->all_valid_pmc_idx, 0, pmu->nr_arch_gp_counters);
>  	bitmap_set(pmu->all_valid_pmc_idx, KVM_FIXED_PMC_BASE_IDX,
> diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
> index dcf4e2253875..51963a3a167a 100644
> --- a/arch/x86/kvm/pmu.h
> +++ b/arch/x86/kvm/pmu.h
> @@ -239,6 +239,7 @@ void kvm_pmu_instruction_retired(struct kvm_vcpu *vcpu);
>  void kvm_pmu_branch_retired(struct kvm_vcpu *vcpu);
>  
>  bool is_vmware_backdoor_pmc(u32 pmc_idx);
> +bool kvm_need_perf_global_ctrl_intercept(struct kvm_vcpu *vcpu);
>  bool kvm_need_rdpmc_intercept(struct kvm_vcpu *vcpu);
>  
>  extern struct kvm_pmu_ops intel_pmu_ops;
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 2d42962b47aa..add50b64256c 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -790,6 +790,40 @@ void svm_vcpu_free_msrpm(void *msrpm)
>  	__free_pages(virt_to_page(msrpm), get_order(MSRPM_SIZE));
>  }
>  
> +static void svm_recalc_pmu_msr_intercepts(struct kvm_vcpu *vcpu)
> +{
> +	bool intercept = !kvm_vcpu_has_mediated_pmu(vcpu);
> +	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
> +	int i;
> +
> +	if (!enable_mediated_pmu)
> +		return;
> +
> +	/* Legacy counters are always available for AMD CPUs with a PMU. */
> +	for (i = 0; i < min(pmu->nr_arch_gp_counters, AMD64_NUM_COUNTERS); i++)
> +		svm_set_intercept_for_msr(vcpu, MSR_K7_PERFCTR0 + i,
> +					  MSR_TYPE_RW, intercept);
> +
> +	intercept |= !guest_cpu_cap_has(vcpu, X86_FEATURE_PERFCTR_CORE);
> +	for (i = 0; i < pmu->nr_arch_gp_counters; i++)
> +		svm_set_intercept_for_msr(vcpu, MSR_F15H_PERF_CTR + 2 * i,
> +					  MSR_TYPE_RW, intercept);
> +
> +	for ( ; i < kvm_pmu_cap.num_counters_gp; i++)
> +		svm_enable_intercept_for_msr(vcpu, MSR_F15H_PERF_CTR + 2 * i,
> +					     MSR_TYPE_RW);
> +
> +	intercept = kvm_need_perf_global_ctrl_intercept(vcpu);
> +	svm_set_intercept_for_msr(vcpu, MSR_AMD64_PERF_CNTR_GLOBAL_CTL,
> +				  MSR_TYPE_RW, intercept);
> +	svm_set_intercept_for_msr(vcpu, MSR_AMD64_PERF_CNTR_GLOBAL_STATUS,
> +				  MSR_TYPE_RW, intercept);
> +	svm_set_intercept_for_msr(vcpu, MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_CLR,
> +				  MSR_TYPE_RW, intercept);
> +	svm_set_intercept_for_msr(vcpu, MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_SET,
> +				  MSR_TYPE_RW, intercept);
> +}
> +
>  static void svm_recalc_msr_intercepts(struct kvm_vcpu *vcpu)
>  {
>  	struct vcpu_svm *svm = to_svm(vcpu);
> @@ -847,6 +881,8 @@ static void svm_recalc_msr_intercepts(struct kvm_vcpu *vcpu)
>  	if (sev_es_guest(vcpu->kvm))
>  		sev_es_recalc_msr_intercepts(vcpu);
>  
> +	svm_recalc_pmu_msr_intercepts(vcpu);
> +
>  	/*
>  	 * x2APIC intercepts are modified on-demand and cannot be filtered by
>  	 * userspace.
> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
> index 779b4e64acac..2bdddb95816e 100644
> --- a/arch/x86/kvm/vmx/pmu_intel.c
> +++ b/arch/x86/kvm/vmx/pmu_intel.c
> @@ -128,19 +128,6 @@ static struct kvm_pmc *intel_rdpmc_ecx_to_pmc(struct kvm_vcpu *vcpu,
>  	return &counters[array_index_nospec(idx, num_counters)];
>  }
>  
> -static inline u64 vcpu_get_perf_capabilities(struct kvm_vcpu *vcpu)
> -{
> -	if (!guest_cpu_cap_has(vcpu, X86_FEATURE_PDCM))
> -		return 0;
> -
> -	return vcpu->arch.perf_capabilities;
> -}
> -
> -static inline bool fw_writes_is_enabled(struct kvm_vcpu *vcpu)
> -{
> -	return (vcpu_get_perf_capabilities(vcpu) & PERF_CAP_FW_WRITES) != 0;
> -}
> -
>  static inline struct kvm_pmc *get_fw_gp_pmc(struct kvm_pmu *pmu, u32 msr)
>  {
>  	if (!fw_writes_is_enabled(pmu_to_vcpu(pmu)))
> diff --git a/arch/x86/kvm/vmx/pmu_intel.h b/arch/x86/kvm/vmx/pmu_intel.h
> index 5620d0882cdc..5d9357640aa1 100644
> --- a/arch/x86/kvm/vmx/pmu_intel.h
> +++ b/arch/x86/kvm/vmx/pmu_intel.h
> @@ -4,6 +4,21 @@
>  
>  #include <linux/kvm_host.h>
>  
> +#include "cpuid.h"
> +
> +static inline u64 vcpu_get_perf_capabilities(struct kvm_vcpu *vcpu)
> +{
> +	if (!guest_cpu_cap_has(vcpu, X86_FEATURE_PDCM))
> +		return 0;
> +
> +	return vcpu->arch.perf_capabilities;
> +}
> +
> +static inline bool fw_writes_is_enabled(struct kvm_vcpu *vcpu)
> +{
> +	return (vcpu_get_perf_capabilities(vcpu) & PERF_CAP_FW_WRITES) != 0;
> +}
> +
>  bool intel_pmu_lbr_is_enabled(struct kvm_vcpu *vcpu);
>  int intel_pmu_create_guest_lbr_event(struct kvm_vcpu *vcpu);
>  
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 1233a0afb31e..85bd82d41f94 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -4068,6 +4068,53 @@ void pt_update_intercept_for_msr(struct kvm_vcpu *vcpu)
>  	}
>  }
>  
> +static void vmx_recalc_pmu_msr_intercepts(struct kvm_vcpu *vcpu)
> +{
> +	bool has_mediated_pmu = kvm_vcpu_has_mediated_pmu(vcpu);
> +	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
> +	struct vcpu_vmx *vmx = to_vmx(vcpu);
> +	bool intercept = !has_mediated_pmu;
> +	int i;
> +
> +	if (!enable_mediated_pmu)
> +		return;
> +
> +	vm_entry_controls_changebit(vmx, VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL,
> +				    has_mediated_pmu);
> +
> +	vm_exit_controls_changebit(vmx, VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL |
> +					VM_EXIT_SAVE_IA32_PERF_GLOBAL_CTRL,
> +				   has_mediated_pmu);
> +
> +	for (i = 0; i < pmu->nr_arch_gp_counters; i++) {
> +		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PERFCTR0 + i,
> +					  MSR_TYPE_RW, intercept);
> +		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PMC0 + i, MSR_TYPE_RW,
> +					  intercept || !fw_writes_is_enabled(vcpu));
> +	}
> +	for ( ; i < kvm_pmu_cap.num_counters_gp; i++) {
> +		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PERFCTR0 + i,
> +					  MSR_TYPE_RW, true);
> +		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PMC0 + i,
> +					  MSR_TYPE_RW, true);
> +	}
> +
> +	for (i = 0; i < pmu->nr_arch_fixed_counters; i++)
> +		vmx_set_intercept_for_msr(vcpu, MSR_CORE_PERF_FIXED_CTR0 + i,
> +					  MSR_TYPE_RW, intercept);
> +	for ( ; i < kvm_pmu_cap.num_counters_fixed; i++)
> +		vmx_set_intercept_for_msr(vcpu, MSR_CORE_PERF_FIXED_CTR0 + i,
> +					  MSR_TYPE_RW, true);
> +
> +	intercept = kvm_need_perf_global_ctrl_intercept(vcpu);
> +	vmx_set_intercept_for_msr(vcpu, MSR_CORE_PERF_GLOBAL_STATUS,
> +				  MSR_TYPE_RW, intercept);
> +	vmx_set_intercept_for_msr(vcpu, MSR_CORE_PERF_GLOBAL_CTRL,
> +				  MSR_TYPE_RW, intercept);
> +	vmx_set_intercept_for_msr(vcpu, MSR_CORE_PERF_GLOBAL_OVF_CTRL,
> +				  MSR_TYPE_RW, intercept);
> +}
> +
>  static void vmx_recalc_msr_intercepts(struct kvm_vcpu *vcpu)
>  {
>  	if (!cpu_has_vmx_msr_bitmap())
> @@ -4115,17 +4162,7 @@ static void vmx_recalc_msr_intercepts(struct kvm_vcpu *vcpu)
>  		vmx_set_intercept_for_msr(vcpu, MSR_IA32_FLUSH_CMD, MSR_TYPE_W,
>  					  !guest_cpu_cap_has(vcpu, X86_FEATURE_FLUSH_L1D));
>  
> -	if (enable_mediated_pmu) {
> -		bool is_mediated_pmu = kvm_vcpu_has_mediated_pmu(vcpu);
> -		struct vcpu_vmx *vmx = to_vmx(vcpu);
> -
> -		vm_entry_controls_changebit(vmx,
> -					    VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL, is_mediated_pmu);
> -
> -		vm_exit_controls_changebit(vmx,
> -					   VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL |
> -					   VM_EXIT_SAVE_IA32_PERF_GLOBAL_CTRL, is_mediated_pmu);
> -	}
> +	vmx_recalc_pmu_msr_intercepts(vcpu);
>  
>  	/*
>  	 * x2APIC and LBR MSR intercepts are modified on-demand and cannot be


