Return-Path: <kvm+bounces-24622-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 01CE295852F
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 12:52:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4F1822893B7
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 10:52:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3E3218DF71;
	Tue, 20 Aug 2024 10:52:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="iWwxaQfe"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2067.outbound.protection.outlook.com [40.107.94.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5334F178376;
	Tue, 20 Aug 2024 10:52:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724151160; cv=fail; b=iqJHG+rftaFg9XqUbDyhCWgO/CECgpiM2DOoLIH/p6R9t6RQUCZoNAo9bA9xhPg+2aV6LjCdDt5yntum2SSJ17/6RawPOD8uwqQuj1E1ofGZEzXYm4GZ+rb8oCX8e7WErIgQ2c76ozvO0cgNo03shSvquchAeofd3bgDq/zhoRw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724151160; c=relaxed/simple;
	bh=jtX4oNw1yG7EkJF8JOcCiq7tXI7jSdnG0kiAKanhwcw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=FkWszrWEWa3gu5PNQTxbNHH755EF7OspuOhhSU382nzEw72wz/BZYUZbnEVwrvHxIQCKinPKzkzbxvBGPLw4E+AgDzBusd4XRAHJkVtMn4yJeFVRxmswkVyC4GDxZPLkSW2/hnp4AbG55nW8+bUISB7HuijjUneAg/Lj1KkKUeA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=iWwxaQfe; arc=fail smtp.client-ip=40.107.94.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zGAoJrJe1yS1GY6d3UTEjphrvYsCLXvStYy9UUTyJUYuS1UnNNz/kBVTwFnElvnU+cNIsVK6kZRoPSn+K/sWt0cBviqvvi03yxIKKyu+wXztEVEwKB73hZAilhDaB6Ed/YUUCieFiI0RuinUFylYKOKxldGjbjSVC+93+BikGJooAxRgUYpaCymFZxN4BwufoU97pz5oersT3Wrl7DIvf2RK3eUchmyyfa/p687yaFbPEdaFtsuGVNs8kJaXC6o58y0MqAPA8pjM9/Jq2iQM2siUQdfi9wI7KCsdhedTzsSIN1pavHVcwrC4MXapco1Y1SeEZb43IXomTotnd1UGuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1oKLKEiAxcreahO1cFou/nrFSunI5jWYFrgvv5RMo7U=;
 b=WbeBgaBagU/5wXtUPbH/N7OdDFUjEcshZRSVNs1sV8HZD50U+scVaxVEFuWXcvHKY5zJs87d2YJaMqPtiW8rufmWID85w/6wc7UwLo6g0kPbiOR1sFfLiTFnnCzMU2jMvxZCf5KdH65xt3IiY4KR5YJGs/5S6hIb2OVbbUIFcv4xabSmRnqabDWt7MIkb4VLWzRelWKfTB3OdHt1bbDeaajOTNE7qChqSogccvpJexL1bJZF22Lfac2oNujvtzGpWGqaJ5qG8+u8IWWM4365KKmJy0Ob8HLREFxrXAWT5H0YF/0Q+A29Z5J07ENvBlrVZjp8CfNQYCLIkchVlOfWDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1oKLKEiAxcreahO1cFou/nrFSunI5jWYFrgvv5RMo7U=;
 b=iWwxaQfeCfHhkT0ebLSKZRpmcdpztjiYgtK7ytLzzTtYGo3Ymskps6kLqsbQ+7ws3lk4ZBlwdabGbMbgvFlknY5cYEDEuLQ0aPEhkYA8z3msGLOxUsCQJb+82k25nZHGAiMcaL6X4GmKpnEHmfQoNcmqxrSjL4gpY2mItx2xQmo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH2PR12MB4262.namprd12.prod.outlook.com (2603:10b6:610:af::8)
 by DM6PR12MB4252.namprd12.prod.outlook.com (2603:10b6:5:211::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.21; Tue, 20 Aug
 2024 10:52:36 +0000
Received: from CH2PR12MB4262.namprd12.prod.outlook.com
 ([fe80::3bdb:bf3d:8bde:7870]) by CH2PR12MB4262.namprd12.prod.outlook.com
 ([fe80::3bdb:bf3d:8bde:7870%7]) with mapi id 15.20.7875.019; Tue, 20 Aug 2024
 10:52:36 +0000
Message-ID: <49849e0b-5ed6-44a4-94b3-1d5dd54b9a29@amd.com>
Date: Tue, 20 Aug 2024 16:22:18 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 26/26] KVM: x86: asi: Add some mitigations on address
 space transitions
To: Brendan Jackman <jackmanb@google.com>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 "H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>,
 Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Alexandre Chartre <alexandre.chartre@oracle.com>,
 Liran Alon <liran.alon@oracle.com>,
 Jan Setje-Eilers <jan.setjeeilers@oracle.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
 Lorenzo Stoakes <lstoakes@gmail.com>, David Hildenbrand <david@redhat.com>,
 Vlastimil Babka <vbabka@suse.cz>, Michal Hocko <mhocko@kernel.org>,
 Khalid Aziz <khalid.aziz@oracle.com>, Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Dietmar Eggemann <dietmar.eggemann@arm.com>,
 Steven Rostedt <rostedt@goodmis.org>,
 Valentin Schneider <vschneid@redhat.com>, Paul Turner <pjt@google.com>,
 Reiji Watanabe <reijiw@google.com>, Junaid Shahid <junaids@google.com>,
 Ofir Weisse <oweisse@google.com>, Yosry Ahmed <yosryahmed@google.com>,
 Patrick Bellasi <derkling@google.com>, KP Singh <kpsingh@google.com>,
 Alexandra Sandulescu <aesa@google.com>, Matteo Rizzo
 <matteorizzo@google.com>, Jann Horn <jannh@google.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 kvm@vger.kernel.org
References: <20240712-asi-rfc-24-v1-0-144b319a40d8@google.com>
 <20240712-asi-rfc-24-v1-26-144b319a40d8@google.com>
Content-Language: en-US
From: Shivank Garg <shivankg@amd.com>
In-Reply-To: <20240712-asi-rfc-24-v1-26-144b319a40d8@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BMXPR01CA0090.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:b00:54::30) To CH2PR12MB4262.namprd12.prod.outlook.com
 (2603:10b6:610:af::8)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PR12MB4262:EE_|DM6PR12MB4252:EE_
X-MS-Office365-Filtering-Correlation-Id: 611419c0-21dc-4821-6a31-08dcc10633a6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|7416014|366016|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SDRBSjVtdjRvV3YwUUdJem1mbVpxQVltV25Jb1NFMW1JUW9KUTBaL3hnbHlY?=
 =?utf-8?B?alRYNXBPU1k5cGJNYzVMOVdOdUR4VCtHUFZkcGJoSks4blFxSDlkR2VjK1Zv?=
 =?utf-8?B?NkJsa28wNWEwSXlzVjdQeWoxZjVMUExjYktuZWNyUEdBeVFiVUwrRGRLNzBI?=
 =?utf-8?B?MmE1bkdpWXdpb2lmZHNGVFMrSDJMdjd6ZVhuNzFmd3Y3QUpBZDlPenBoUGZY?=
 =?utf-8?B?SEFsdU8vNVFEdjBZSG5LRnM4YjBaZ2s4TFhKc0pyTCtibHEvV2FWUGJzdnVj?=
 =?utf-8?B?cDNNWVVockVocTNGL3ZJSm1qSVpvRUpzeUpxWUZpUFVqWGJOVkNnWlRyTDQ5?=
 =?utf-8?B?UlZJMjBDVnUxYy8wN0ZKVXF6YmUrRGZVaVlCWktudzZHaE5vTmRyL2s1dHJl?=
 =?utf-8?B?ZXlybytnOGt3Wmd3ZnpRUEtOVVhiQm5RSG9iUmJhYmhSYVQ1MG9yOElkVEJW?=
 =?utf-8?B?d1puTFdpNld2bTFNc25DcnN6alcxTmpqdmVsVDU0VFJLK2tVMW9rT0RsNEpq?=
 =?utf-8?B?R1cxKzJFeHJ3aFdMY3M0cGF3ZkhKVFlJMVoveGw1TUpQV0RjTGlBWFl2OWk3?=
 =?utf-8?B?NjFQU1hiMExFdXo0UFU2K2xxMkM4RTB2UFN4czRKTnhEeU5YZlA4amdLRWVl?=
 =?utf-8?B?ai9IRGUxTGZRRGVtS3VodUtWL0g3MEtDazB5Y3VsUUNzMzdUUi90RisxRUxI?=
 =?utf-8?B?T3FWY0gwWDlhYWdsMXJZajNmN0lrZ2JvUEFrSTZ3dzBJakhuQVhKbHN2VWpL?=
 =?utf-8?B?eHA0aUZ3SUF4cHNwSlREU3Mzejl0ZTVQOXdLS0o0WVFZQUxDbTMvaHJsTzB4?=
 =?utf-8?B?b0RTRFhUR0tHR1BDVUJRYXduTFo5S2E3S0Iva3AyTEV3ZHhXT2dEOFRkUXlw?=
 =?utf-8?B?Z1hQcXVoMHdiUENjOTJCVTRUcVd6L0RmMG9aQWZtVmE5bG0rZ2t2NGgwUzd0?=
 =?utf-8?B?dktlVWpuaDYwT2p2MnNkMjgzazNXeTNQMVozTUJJNkFrVkY1ektCUFUvSytS?=
 =?utf-8?B?VndvTnN2bFhUaHFDWFNEaERnUHRrVWRTV2VjU2FjdnNtWmVNMEZMR0t1VnRw?=
 =?utf-8?B?eEt1S2FPUXBMaVJZeXBhUklVT2FVaXVncVZZOVNUTjg5Qm1NYW9BQisvM1hU?=
 =?utf-8?B?TmluWDVKWm8vdUptSVNGV3IrTmxGclJpVURhTzJXdjViTUlSdHo4cGhhOG1F?=
 =?utf-8?B?aGh6Z0d4VWFiK1hScThsaklvamlJbE9nbDNYOCs0UEhZZFUwWGQ2UkxqZXh3?=
 =?utf-8?B?Szdrc1NEVEZxQ0kyNkI1NVVhZ3dmQ2Ntd2VXcTA1MHZsV3JubnFxV1hkeGx4?=
 =?utf-8?B?MWQ0UkZodndZb3Rqc1duNmNoZDEyUlpBcHpzSDBZWmoyb2s2UC9MZnAyWTlU?=
 =?utf-8?B?RjhQU1pHaEpFMldqSmlmdVpTTTZVNHVWSi95R0praU5iRldaQjk0ZHNPYllk?=
 =?utf-8?B?NksvOWViT2F2SVpGbW1DWVZRMVZ3bUo3MmtVazN3UVdVZWUzcnEyZ1MwL1JH?=
 =?utf-8?B?ZWRqV0N0dHJobmE3WEttMHpLOXpmN2Z3VmR1emFiQk0zYmtxUnNNM3FXVXNU?=
 =?utf-8?B?MjlvU1hhTTdsVmNJSUh3bzhYNXZtN3NOOTFqcEpLdGZKM3ljc21kbllIdmhV?=
 =?utf-8?B?WUMwQ1JmZmErN0E3RjhIRC96Q0l0bStYL3hqeXRjVzJDNXBQOS9kY054b0da?=
 =?utf-8?B?YzhJeXc0bFp5S254UUQ1M2J4UFFZSUtPSVE3SE5BWjlXVzVPUEpWbjhyeVp6?=
 =?utf-8?B?VW9Rd1Jqb3dhZ3dUcU56a0ZSeWZqY2xnMzFtaS9wdDcwTkpSaCt3bE9NaVIx?=
 =?utf-8?B?L2ZKTVNJTEJlQTZLYnhDUnZ3OG5GRkxxbUxyNERLRzNpYk1sc0JFYkdURUFt?=
 =?utf-8?Q?2JM3gMnuTpEq7?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR12MB4262.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ckEwMENyL2hYYWt6RnJnaVV0dEJIcXB5RXg1NVBFRHVyNXF2dTVFTk1hdmRS?=
 =?utf-8?B?QXRseDVVS01xM0EwcGVzTDd0ZjMyRnhrWDRtWjBvcHNCWDJDcDdtZ0FiaVhp?=
 =?utf-8?B?ZGRFYWdtTm9qakZBREF6eFI5ZHYyRjNlWDg0dTNZU1FoTkRsQzE0QUdLMTFz?=
 =?utf-8?B?REdvTFc1VmZtTlVNNWVqK01aQjUyY1R0a3pWelhCVzdpTmkvb0dYcStQMFJX?=
 =?utf-8?B?eHZ2MUQzeFdvejdUSmsraDV0SHZHaXYvR2E3dFlTYTNlSUR3SVVUOTMvVW1E?=
 =?utf-8?B?dkM2bDM5cU9QcjBnZEJKdWpIRURQNlJPeHZBd1ZJNUR4aUt3YmRrWWZQWDB6?=
 =?utf-8?B?ZTJ6RURuTkhBM2lMTzdwYU1vQ2hteU1PZHdOalRER0loVTQydW5UWEE1bU9D?=
 =?utf-8?B?Yjd1dnpIU0lQNEZqbjU1cnVXNGNQaWl4WUdCVGF4MkRSZmxEUVpPRFQ0RnFX?=
 =?utf-8?B?K2pNamVyQkhZQ1M3Q1FEQnFTSnhuQU9pZzhIbHo0OFJQaGxFcUJVN1N1d3pp?=
 =?utf-8?B?MHJTL1kza1pLYnBjQmI2YUN5a05HMm9aa3J4L3MwL0tHeGcvbWNwRHBQclla?=
 =?utf-8?B?a2NmQkpzWUFnaDc3bGVGWmswRTZOUS8xRzdVSGxKYXllV2lDWUEzdnM4a2FY?=
 =?utf-8?B?RS9mU2w2aEdCamU4TWtXbk1pL1gvWjVodHR3MHJjalpvK2lSeWI4elBLQmdE?=
 =?utf-8?B?MGJwdmcwVU9DTkkxcHVCM0ZacG4yUEZnK0FJeXc3bVpqWkVrNVBxYmtOK2l3?=
 =?utf-8?B?dU96aUpuZWxrTE1PMWRtdExlbjFVQXNVOW5ZK3FpclNIVFB4M1VCeU5PM29k?=
 =?utf-8?B?dDhHa1o4OGdhWEJnNkRWZW1JMUk5RzJxZTU3MWpCS2FhRFAvZGtXN1R3dVhh?=
 =?utf-8?B?TDBHNnd4Uk9DVjZVc2R0WjFTcDVpalRnMlIxYU9sYndTNThhaGlJRHZpNkZB?=
 =?utf-8?B?ZitIcENaN2licldqeDRDYU9FbEQ2dWNRNmZ1QW5RSTJTZ2xvUVM4TVZhS2dl?=
 =?utf-8?B?UXVWdGtoMEZ6NlAzWldudXNjaUhLdGJmUzBwZDM5UW52RDZ3THNPSWZSTExM?=
 =?utf-8?B?bHNmUzErZ0kxdWpLdHBsVlY5TUNVdVkwc2x5TDVGeS9Ud1JjMTBSSkl6WXd2?=
 =?utf-8?B?TDZ4L3hHR25ZVFJUMzF3VkxkYkh0VTFBa1FSYW9YTkFIbFFoUkdhN0FlaWx0?=
 =?utf-8?B?cGhyQnhyMTJHdmRTRi96YkdGcTVSNjZ1R3hXaHpUWitiT0Z3T0taSnlHRE03?=
 =?utf-8?B?RWlsWlVoOU8vbTZjNFl4LzZaM0NFU2ZhL1BHaXIyam0xdytqcmpHZWlnYzE1?=
 =?utf-8?B?dDB3YkZBdHRoWG9IRUhZMnA3elpBbUJGT0xUcDBRVm9nc0dtZ2RsZ0M3eG9m?=
 =?utf-8?B?MzJkOUNLanZ4NVBaRWc1eDlWdVRVMFgzSXZUUGU0eXhvWVFQT2pDN2pmdTds?=
 =?utf-8?B?Z0xzcVkxZ1JFMHFrTFZmbHBLazk2RllKcG1NVHFJdjM3T2wzODlsMCtMMDlx?=
 =?utf-8?B?c3JSaVgzUXhaZVdKOFM2MHNVL0Z0T2pnZkpHT2dON0U0amFDL3J1YTEwZzk2?=
 =?utf-8?B?bVU4MHJaMTJibXNZeGRoTXNOOXRpWjJ4TnVmM2xObGVvRmRFTGtCR0FGcENS?=
 =?utf-8?B?YXByc2xHcWswYnVTbUJVaHM3UU0wSlNIYU9oSWw3OXBHakc3U0dyMXZWWXBH?=
 =?utf-8?B?aHJWdVgvY3FIMmVhYVVBcjB6TDBQc2ZOK1NnOWUwV1c0NGFxUDlML3duT0JV?=
 =?utf-8?B?SG5yRUJYZi9IUFU0cGhobHlkR3NHSDVydk5yQjZHd1RJZFBJN0lpaHpWdVVy?=
 =?utf-8?B?MHFqd29HSUhPS01sNUhkRjBiVDNQb0svZFQrTUJsY0pTc0J5cXVlSXFJcldm?=
 =?utf-8?B?Znl2WUJFNUhSQXZxbERST2pyaUhDV3lLNEJHUmZrSnNrWjJNNUdhNGFnV2tD?=
 =?utf-8?B?RUNvZ0E1K0ZKTkloMmQ3N1VURUtGVlIxNFFvVDdjN2Y1SFFWYytUVU4zaEc3?=
 =?utf-8?B?b0ZpMnVxZUtEUVJ3QzNlcXF6Q0U4UWZuQ0tJYUFWaW9mN1VoZ0tlMUNFcWsy?=
 =?utf-8?B?WURSeS9tZmNjZ0pWRHNxNllVWldFSkNweHFaa0FuT1VzQjBsb1lMZ21CM2Y3?=
 =?utf-8?Q?aHHrtdHKDJy1n+8mdBGTRcLMD?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 611419c0-21dc-4821-6a31-08dcc10633a6
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB4262.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2024 10:52:36.5677
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: caN5tWD56bIOKVhcX/29MQj12ngse5aCApVsG0AiS3KXop2csyM99Ne0zUMUaRlLPtWXA3cSFZEeek+9h7DhgQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4252

Hi Brendan,

> .:: Minor issues
> 
> - fill_return_buffer() causes an “unreachable instruction” objtool
>  warning. I haven’t investigated this.

> +
> +.pushsection .noinstr.text, "ax"
> +SYM_CODE_START(fill_return_buffer)
> +	__FILL_RETURN_BUFFER(%_ASM_AX,RSB_CLEAR_LOOPS)
> +	RET
> +SYM_CODE_END(fill_return_buffer)
> +.popsection
> 

I'm getting this error when buiding the ASI patchset:

 OBJCOPY modules.builtin.modinfo
  GEN     modules.builtin
  GEN     .vmlinux.objs
  MODPOST Module.symvers
ERROR: modpost: "fill_return_buffer" [arch/x86/kvm/kvm.ko] undefined!
make[2]: *** [scripts/Makefile.modpost:145: Module.symvers] Error 1
make[1]: *** [/home/shivank/linux/Makefile:1871: modpost] Error 2
make: *** [Makefile:240: __sub-make] Error 2

I'm wondering if we need to annotate the asm code with 
UNWIND_HINT_FUNC and EXPORT the fill_return_buffer and to avoid this?

---
diff --git a/arch/x86/lib/retpoline.S b/arch/x86/lib/retpoline.S
index db5b8ee01efe..4084ab49e2a7 100644
--- a/arch/x86/lib/retpoline.S
+++ b/arch/x86/lib/retpoline.S
@@ -399,7 +399,9 @@ EXPORT_SYMBOL(__x86_return_thunk)

 .pushsection .noinstr.text, "ax"
 SYM_CODE_START(fill_return_buffer)
+       UNWIND_HINT_FUNC
        __FILL_RETURN_BUFFER(%_ASM_AX,RSB_CLEAR_LOOPS)
        RET
 SYM_CODE_END(fill_return_buffer)
+__EXPORT_THUNK(fill_return_buffer)
 .popsection
---

This solved the issue for me.

Thanks,
Shivank


