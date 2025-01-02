Return-Path: <kvm+bounces-34483-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C52609FF9B2
	for <lists+kvm@lfdr.de>; Thu,  2 Jan 2025 14:11:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3B8403A3725
	for <lists+kvm@lfdr.de>; Thu,  2 Jan 2025 13:11:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 402E61B07AE;
	Thu,  2 Jan 2025 13:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="sFGqWwYf"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2075.outbound.protection.outlook.com [40.107.102.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 832641DA5F;
	Thu,  2 Jan 2025 13:10:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735823458; cv=fail; b=V+rfh5iwX3qyFzGhFXKf617YC0+xrGgBruyD+zhrpgYI5H7VXsi0qYHocEW1xFHSwutYoIGXWUdcaYYGvdqIq3zGb00ZU6yf1+7O7JpeaTgGs90WBzFLtGnuwSLroK9UrIeyHemZeyNxJtR6f/dFjZykOwMwkJRG05ClH5c4ntM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735823458; c=relaxed/simple;
	bh=eAelnunqKn+2amAXsIlmTjuunce5Pe7Ht2ve3zVbykE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=LJpbrL5/r+eu4nsKDM0H7bS7IhFITLmE2DkVTdOS6f+plm/HPCSOj+rA31s8KUR14V0dJ5mX7QQ/9e9jI1fbfeafpALKc1qdiOJVBiEnHNQG7daEd/F6abVuFyU6N+CXnRXCPZQs2EC6eXcD2VJMHkTnFF2G1oZ+GIq1qpTeJak=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=sFGqWwYf; arc=fail smtp.client-ip=40.107.102.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kGltBkxkNgSU7AVX9EqxdSVSJ8Pcdhv7xr9TENsez3/gjDag1fqkAwI86MQzkDWC46eUA0BgvkcGLLy7faJ8DpU5U4SIxjAdv3iZYTSdQeIacWKcSHhQkoQQ2HqFyLKtAkrAzGDTt5jY5qyv6TV4+3J6NFJA+5ce/aa2fjFb/iziplbGhH8JcJM/1NDK3Culq+saxJ00NcTwg2s6QT08wL1zvQk16wYKBF7bUefaOovcsi4hp96lxFmSuqyDBOVkvw3CoF6LRtLD4gT3B+aJXNI2bvkSICpNNXW48DhV3ihWR/NfzgHl6mjQq4IgvDPDPNHw4srTmbLaLwRIfkTt9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xirzIRCJGKkkiaf8TdOG7x5YHhft5ZbWe/2tCHuwQ6w=;
 b=wqXLDK3r/j8nhWoJ4Imswwdb/m1l88eJPQ3xGbXkbxNkahQNSrfRhCQBjqnB168WoiCs6mjQUCN8gbFAPvM8qy/acUWexNZYBQXRWavShPJqyUrmF0MRYAegMwuVVNNGiTBOXn0a+4EJ8+2b6Ha3ct6aps6lSv2DT/DMJ+N6ZchPCc2gLHhJZc2Ftkowc3N89hm+N+ct9XAivyu1rySp7l7OPwLKmIt4KhRQe7Jnht6T7d6AAbLuCNwDKxi3Y6waWz4tFZoLf2a0VVS2Gr3TBijW+ygJOr0Zqa/95oT0Dde2jwD2KJNzschMvsuHP4aLuUetTrMLPEJPr6mnhFDS3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xirzIRCJGKkkiaf8TdOG7x5YHhft5ZbWe/2tCHuwQ6w=;
 b=sFGqWwYfU0IJ0wAW3vex57DclwqJUUk3daEWwIXR/gW4TjMWqw104a8Rq685KLIz5FlcHzqZGcv0UhKy0k6xCaY5Eo6XF1ROy5kn+QuA0/Lhx9AIDkExbD+v34W7ol8prOTYOGggtKCuZNgzAsCt2/6srYhEVLnHLHrhcjvr35o=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 MW6PR12MB8866.namprd12.prod.outlook.com (2603:10b6:303:24c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.13; Thu, 2 Jan
 2025 13:10:49 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec%6]) with mapi id 15.20.8314.012; Thu, 2 Jan 2025
 13:10:49 +0000
Message-ID: <061b675d-529b-4175-93bc-67e4fa670cd3@amd.com>
Date: Thu, 2 Jan 2025 18:40:38 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 09/13] tsc: Use the GUEST_TSC_FREQ MSR for discovering
 TSC frequency
To: Borislav Petkov <bp@alien8.de>
Cc: thomas.lendacky@amd.com, linux-kernel@vger.kernel.org, x86@kernel.org,
 kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
 dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
 pbonzini@redhat.com
References: <20241203090045.942078-1-nikunj@amd.com>
 <20241203090045.942078-10-nikunj@amd.com>
 <20241230112904.GJZ3KEAAcU5m2hDuwD@fat_crate.local>
 <343bfd4c-97b2-45f5-8a6a-5dbe0a809af3@amd.com>
 <20250101161537.GCZ3VqKY9GNlVVH647@fat_crate.local>
 <a978259b-355b-4271-ad54-43bb013e5704@amd.com>
 <20250102091722.GCZ3ZZosVREObWSfX_@fat_crate.local>
 <cc8acb94-04e7-4ef3-a5a7-12e62a6c0b3d@amd.com>
 <20250102104519.GFZ3ZuPx8z57jowOWr@fat_crate.local>
Content-Language: en-US
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <20250102104519.GFZ3ZuPx8z57jowOWr@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PN2PR01CA0077.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:23::22) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|MW6PR12MB8866:EE_
X-MS-Office365-Filtering-Correlation-Id: 19790659-6d3b-486e-d8ca-08dd2b2ee076
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dTZYdUtFTDYySUZJcjdvTEdnS2lkK1o1OHpHbERaeTNvcDdTQ2Q2eWVOZHdB?=
 =?utf-8?B?bXpUN3ZMam5PRFRWM0VjbHZSaEM1TlhWL2RwQUl0QjVjaGFUVUtMMy95d1dW?=
 =?utf-8?B?bi8xaUhEajRVS0ZmTTFHMTRzcCswRXJHbXlDb0xoekFLMzJ2MzcvQVFRTjJk?=
 =?utf-8?B?Wmk5cHpiTllyQ1dMSEVsdzVwSEJaTU90dEp4elFpcGVPcEFMNUtTUXZXQnhS?=
 =?utf-8?B?OU9zZFIrMlQvWEd4VzFmV1RRNjI3VktDcEZ1Z3k2S25lS2xnRUQrcXRQK1pU?=
 =?utf-8?B?YWtwNnFUZnVOOXFoRVYxWVNXWER2YnU2K1BaMUV6dVVPR1JWOVdQWVBJRVYv?=
 =?utf-8?B?L2x1aE5jeHUrNDYrLzdLQ1JnSXZsMVVqM3BVekF5OHJ0L2h6TUl0Nk9nb1Ex?=
 =?utf-8?B?TThvd25OSXc0ZUtlOGJSRk9GSElGR2UydUdoZGdBbDhzcTNFQmY2QmFwQ2VJ?=
 =?utf-8?B?UWtkVDFCVFRNL2VDejN2eWMzbXE3T0g0QzlDaTZnbDRUeHU4NjhtUTBBRE5D?=
 =?utf-8?B?MzRVcXl3L3ZTSitjbFhhMDZzU1JmeVAxZHYrc2g0Z1J5bmFlT29Vbk1oVDdw?=
 =?utf-8?B?bGtMVjhBSzF4SWpKY0dORWlObmxycnZVeTlNUU1tSkh4THN3NU9qMkNkTmM4?=
 =?utf-8?B?MjJIUmFOblI2MWZ0dG9panpSK2Z2MFNpczMxMEk3WlExOTZKZG14ZnRKR0J4?=
 =?utf-8?B?Qmp6R0dSWC9jNTNubHVMZHZ2VGF1TWRzZzlBMTNCVzNzQWJQVmxhTWFlaDVy?=
 =?utf-8?B?VjRsbk1sQXZRbGdheVVneWVFUkZsQ0pXOWVFSGFSaWVpSWpPL0pqaUx5L2Jk?=
 =?utf-8?B?VlR6RmJKL0lmNVVBSUwwR2w0RVVEMGNIcHZ6TE9PZE5zNmJ0dmVKR1cvZHFX?=
 =?utf-8?B?WXFtS0UwSWxDVnVtcVVYQmx0OERka1BOK0VlcXhyVktSUWhJLzNOcnpDYTNz?=
 =?utf-8?B?TGRRd3lHWSsrdU1hTG96cHhMTjlTaloyWVlFRXcybmlNYTZvV3YyZ3psSm1S?=
 =?utf-8?B?SkR5eU5mQ0Jac2pXczFqMCsySGxyOGRCS25WNlpIVVp2QkhEc2VyTjk4YUo0?=
 =?utf-8?B?ZFgyeWdCdlRITUZPR3o1NWNWekFuOGNyWDlSNFgycEY2c2MxejRza1Z0R0tL?=
 =?utf-8?B?aGJrU1oxdTVnWUhwWFlLVTQ1UEpSMXVoUTBRZG51aFczZkxQUk5pbXN2R0lx?=
 =?utf-8?B?MUVxWXByZXVpMnpvc1hieUZQS0VoaWNVTlFHbzl3WC9zcWpac05OV3BLdnlW?=
 =?utf-8?B?NTluUEN5d2toSnRFQjhuZ002N3MwOG1adTdKbzlTZVM3T1JEV0ZwY1YxdjNF?=
 =?utf-8?B?aW1oK053aTk5a1ZKa2hXcG1zTFZkK2pldXBEUkhpdEd3QTZHaGhnKzJvdTUz?=
 =?utf-8?B?TDgvNmV6RmlKanIrUjliR1kwWTZ0eTJVS0xjOEl0dms1cU8vajZ6NlpENVhq?=
 =?utf-8?B?OGhtZWV2cWYxV2ZZRVZxT2x2YWYwWk15aTlMWm84R0JhNm1mZ2xwLzA5UDF2?=
 =?utf-8?B?cC9VdGtHOGc3MnhhV01EUHZhaWNJVk5nZ2JMUjV2dHArYWppaWpzWlVRamlD?=
 =?utf-8?B?UDU3UEgyS29FbmV1QmdnRnBrYXp4UkNaNyt6Z0hEYUlycFExcThrQ293WEo4?=
 =?utf-8?B?S2xidy9mdnRZSG1jU1RnWXNhYzB1RUhnQ29EVERsaVFIY1hOKzRRcXZNaGRO?=
 =?utf-8?B?cjdUVUJDNGFhd2dPMUpDQ1F2K1V5ZU9pblE3dDFHODZoKzdKelBhc3QwaUg3?=
 =?utf-8?B?andLc0YzN29GNS9sRGNUdHkya1llZ2xNU2xOKzRQcmozRU1kUGpndklNMnBw?=
 =?utf-8?B?MkQ5R1l4OFJUdktxUE5JejhLTU5yb29sVDcxK3ljeVJSNzFuR3A5WDFsTTNP?=
 =?utf-8?Q?UWXu5KzPRhO3u?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UE45bFpYdmZmejkzMkltU1EwZmduSURReGkzYjV6WmF0VXFrZFJ3V2dOYVky?=
 =?utf-8?B?UHpwZGRtQWZlTFZWdTh0MnhINGI0YUU0ZmY2NEx1TGJJVmRidDIrWlBFRDZS?=
 =?utf-8?B?OWJaRk9TQXRMRERUSytLSHlaVURaMGt4OS9QOTBVdlBPY3k1VWx2c3p2L2c0?=
 =?utf-8?B?Uk5tMnZKc0ZyOW9TUDJQMnFMMG1CcjFUYUtIcVROT3Q4c2s5VVdVVFJnZGgz?=
 =?utf-8?B?SmNGaWVIZnlzTkRjSHVrZFBxU1NoeGpSdjRMdXh1cExnajV6YThabCtmc1JW?=
 =?utf-8?B?anVCTnorQ0QwVEo0dW1tMm1hRlJ3ZkpyYm5iT2FBSUNvUklLVGtyUkgzcmlK?=
 =?utf-8?B?ZDRXQ3VsdnQ4cG9VUEtyN3R4SDRPLy90ckt2N2lxVHpmQVY5bUxSdTgyLzl4?=
 =?utf-8?B?N0FjbnBQb2tZM2xERzhOajV3UWcwOGpld0ttYmgwc2tZZXFLd3Rvb2EwSXZu?=
 =?utf-8?B?VVNYdGJNc25xV3ZqZ0VCRDZMVWE4TGF3aTVtaW9SVElKd25JamJkcjYzWmJM?=
 =?utf-8?B?VlNCckdsOHhQdmFycE0xWElRSjltOXVoMXdaV0hwZ1p2MkxvRFNFM2ZzcU5T?=
 =?utf-8?B?blcyQndaOVYrK0NkWTYyenY0b2U3YkNWVUhQSWo5VDZsOHNrWGd1d1UvRmdC?=
 =?utf-8?B?cTNaMEJ2U3dTMUpzUlRVcmtWT0VqUGxMcWIrc3NIZkVnL2JPUUxoTWtPdlhD?=
 =?utf-8?B?bmdudEthaEVHRWZoSzlIa092Vm4wdm1EbkR2RDRRNzFJeU1SUGxYL0JJcGFP?=
 =?utf-8?B?SDNnYkFVNGdSc1hMQW9wWnZGOTl2V3A0QVN5ZC9pNVNQcXNJZUpqcjVWWjZz?=
 =?utf-8?B?emVkNTFSam8vUjNCckxFRXJCNWs1ZGlMY2dmMVRPSzhsU0V4NTRIYis0M21j?=
 =?utf-8?B?U1JTSzlaQldEUDMzbll1TUlDWjJRTFIwQXpMaTN1Q01UUWxyd0JHZXdWWjM3?=
 =?utf-8?B?RUl2RHlUanNuSEVVSVdEMlVkcVBMOHd5T3JnWEppMXI5U2kxRzYwaFc2RlE1?=
 =?utf-8?B?UWxKQUFlRFB2MEVOMUpYcjdLcDlTMkxPSXo5R25NeWxLQ2lkMFdPRUhGMjR6?=
 =?utf-8?B?ek5pS0tJRVZlUGZOTVoxTDBXd2RxZjdCOFo3TUhncndJYW9sa24wRnN5V083?=
 =?utf-8?B?b1NJdW1yaE14WE5zc3JnRXkvQ3lOL09qTi9NN1JPSE9NbjhBQkhVSUlTZ080?=
 =?utf-8?B?VktTRUZ4emxWaXJBSGZXNEhQVWlRejZXTlByMmE0YWV6aEwzRDhMcDl4VjMr?=
 =?utf-8?B?Q241TmxZdWtPdXBiR3pObnJvMHBRWmJDUWdWemNSdVFNMW5CdEVWQXplSHJH?=
 =?utf-8?B?azUrR1dEaUZ0cjNMUllrMkwxVVVodnhCSVJDOTJnR0NkVnRUZFljY3E1NGlk?=
 =?utf-8?B?RWxvNzdGZzFzYkd4RGVqME42ZHpiNDlpU0F1NGJJWVg0bitFOW5qV292RGxV?=
 =?utf-8?B?dWx5Ni8zaEwyWWtublV6Y2lMWUZERHpUVVdEMG1uNDd4YWI1TkVXTk96Mk8r?=
 =?utf-8?B?UHFiNHNFTkxRMkpUV21PL21TUlZFWmU1dFlIQmxIaWt6a2l0WTBGMHNQUGpu?=
 =?utf-8?B?S0pLS01Lbm9oQzJDVm1TL0w3ZTdFaENZRk9aYksyRloyb2pZREpqaEZHb2hs?=
 =?utf-8?B?UDFwb2MxNkV5Y0dSV2IrZ1ZwMU9oUnpqR1ZoVzUyRFJPZmVQUFNBdm90VFBB?=
 =?utf-8?B?V2dUbk0ramNhazJjb3hNRVVHbExVQTJidDgyZW96ZFVYRWFWL09sQnE4T01K?=
 =?utf-8?B?ZWo3YWppT2FtbFNSTFdyeCtsb2xJdnR5RzFBSlJUKzhnVU9Bc0czeGZwMm5y?=
 =?utf-8?B?UDhVUjdwN0o1anFIOFM2YzBsNWVtb0o5MGxyWTlOaEtldkFPQTlHQXdvL3R6?=
 =?utf-8?B?TFBwb0lIK2l4bXVYUnp3OUF0bVgzNmFSbks1Y0pkRGRnUDVvNEdCNEpESTAv?=
 =?utf-8?B?NEgzajB0UEpvQ2ZZQzhHZkdpLzBMS2FzMDdKNVBibG1KY1lyK3F4VGNKdytm?=
 =?utf-8?B?SXA0VmRUeDZWb3RkNENCRVFhWXFwV2k3SnB2aHhwT2F4K2VzeFZyVnh4bnpq?=
 =?utf-8?B?Tm9aVXVrSjh0MTQycnYrOWtYeXhieUV5em9LMzFNaUhUQ2I4MnBMcm03SHFC?=
 =?utf-8?Q?d54qneCOAAOBZ8emVkvo92oBU?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 19790659-6d3b-486e-d8ca-08dd2b2ee076
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jan 2025 13:10:49.4461
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qLzBHlX9i4N/P0yndyX+VUsFoKnanonqJilyhAmmiofB2MWzsyrgH5hq1nmyPG7wAKGIB3dh6dfY9ThbX1rMnw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB8866



On 1/2/2025 4:15 PM, Borislav Petkov wrote:
> On Thu, Jan 02, 2025 at 03:31:49PM +0530, Nikunj A. Dadhania wrote:
>> Sure, how about the below:
>>
>> For SecureTSC enabled guests, TSC frequency should be obtained from the platform 
>> provided GUEST_TSC_FREQ MSR (C001_0134h). As paravirt clock(kvm-clock) has over-ridden 
>> x86_platform.calibrate_cpu() and x86_platform.calibrate_tsc() callbacks, 
>> SecureTSC needs to override them with its own callbacks.
> 
> Not really.
> 
> It's like you're in a contest of "how to write a commit message which is the
> shortest and has as less information as possible."

That is not the goal :-)

Patch 9

---------------------------------------------------------------------------
x86/tsc: Use the GUEST_TSC_FREQ MSR for discovering TSC frequency

Although the kernel switches over to stable TSC clocksource instead of
kvm-clock, TSC frequency calibration still keeps on using the kvm-clock
based frequency calibration. This is due to kvmclock_init() updating the
x86_platform's CPU and TSC callbacks unconditionally.

For SecureTSC enabled guests, use the GUEST_TSC_FREQ MSR to discover the
TSC frequency instead of relying on kvm-clock based frequency calibration.
Override both CPU and TSC frequency calibration callbacks with
securetsc_get_tsc_khz(). As difference between CPU base and TSC frequency
does not apply in this case same callback is being used.
---------------------------------------------------------------------------


> 
> Go back, read the subthread and summarize, please, what has been discussed
> here and for patch 12.

Here is the updated commit log for patch 12:

---------------------------------------------------------------------------
x86/kvmclock: Warn when kvmclock is selected for SecureTSC enabled guests

Warn users when kvmclock is selected as the clock source for SecureTSC enabled
guests. Users can change the clock source to kvm-clock using the sysfs interface
while running on a Secure TSC enabled guest. Switching to the hypervisor-controlled
kvmclock defeats the purpose of using SecureTSC.

Taint the kernel and issue a warning to the user when the clock source switches
to kvmclock, ensuring they are aware of the change and its implications.

---------------------------------------------------------------------------

 
> I'm missing the big picture about the relationship between kvmclock and TSC
> in STSC guests. 

kvmclock_init() always runs before tsc_early_init(). kvm-clock registers the
following during the initialization:

1) TSC calibration callbacks (addressed by patch 9)
2) sched clock (addressed by patch 11)
3) kvm-clock as the clocksource (addressed by patch 10)
4) wall clock callbacks (we don't have a solution for this yet)

I had a summary about this here [1], below snippet with slight modifications after review:

---
To summarise this thread with respect to TSC vs KVM clock, there three key questions:

1) When should kvmclock init be done?
2) How should the TSC frequency be discovered?
3) What should be the sched clock source and how should it be selected in a generic way?

○ Legacy CPU/VMs: VMs running on platforms without non-stop/constant TSC 
  + kvm-clock should be registered before tsc-early/tsc
  + Need to calibrate TSC frequency
  + Use kvmclock wallclock
  + Use kvmclock for sched clock

○ Modern CPU/VMs: VMs running on platforms supporting constant, non-stop and reliable TSC
  + kvm-clock should be registered before tsc-early/tsc
  + TSC Frequency:
      For SecureTSC: GUEST_TSC_FREQ MSR (C001_0134h) provides the TSC frequency, other 
      AMD guests need to calibrate the TSC frequency.
  + Use kvmclock wallclock
  + Use TSC for sched clock

----

> 
> After asking so many questions, it sounds to me like this patch and patch 12
> should be merged into one and there it should be explained what the strategy
> is when a STSC guest loads and how kvmclock is supposed to be handled, what is
> allowed, what is warned about, when the guest terminates what is tainted,
> yadda yadda. 
> > This all belongs in a single patch logically.



Regards
Nikunj
 
1: https://lore.kernel.org/lkml/64813123-e1e2-17e2-19e8-bd5c852b6a32@amd.com/


