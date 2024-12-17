Return-Path: <kvm+bounces-34003-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C66709F5A3F
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2024 00:16:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 01A947A2683
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2024 23:16:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC4E81FA826;
	Tue, 17 Dec 2024 23:16:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="MlcMqVQT"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2050.outbound.protection.outlook.com [40.107.243.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD7571E009A;
	Tue, 17 Dec 2024 23:16:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734477371; cv=fail; b=HZZ107sPI0Fj86yKk0JssHelRRNF3uxgCqbAMAyT6JFGs+QQDYGaDtcdKnH0/bSU99yewpFWCXfp71kXL7ud4mda4PicTboRh0KGasrcHWcRrUMFO/Q221UYKEEIBwueqZLrL6Buy7bE5SalO6UGJeU31Q+64tIv+WtBMEM2F5s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734477371; c=relaxed/simple;
	bh=mA5Yi0gojElGUiHLLW292MNuBV2BoGIYQ7Sem9ARXLs=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=UoYZxofcwWWyekOOmJEGq8VPEZ/wBQqXTMR3Ueji+t85aUOMfatrSPnZz+mCrNhtJPDMsIRyjP0M5DnhRCsdU9iheEWtGjYpH+KBEqlBs5hE2/4r8K4jdlt7+u8pz4ZtEu8I+9PfCCJeNGFILVMQkBRb38Bv0o+QPgJAop7Sw6Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=MlcMqVQT; arc=fail smtp.client-ip=40.107.243.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BkJltzd+h/y+NYsyHn/KFD6ErykQLbo1RumXjDbxPI/e3DTuXuX9r6R/WWpis4F69zZcNMwLdixzcD3jE5XE4q/iwPUSuqj3Udj5BmxlnaUE6VpW+FEYHjZt/V5ZWVsiDRAk1t0k2nIqMQu1stlBWKrVMZA4XLhf1yitatQp6vC4cpM567uO/ujWjt2RR/goah44IQxIdL1SNq/HtSDphsdRql4F39GKe5HRW0pynZwFBeXnvLU1KXkLsKqpsDqCODpC4sUp1kvBxIUvQpylZN9jAjGJbtU0gmaAIAhtSExGT4QlH89r2u0A5EQ7uGI3yZyQFD6SCZM4hrTZsj/kng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DadkDfnMXF+IkCyrAsJXcY75YCzdTfcl9imh7c8bN5c=;
 b=XJ9C04Gmezm02Y6//KxgD0Y6Z6DyK51R9Wnc29XZcXB9AmIS6IDCqMIvOINuEgrSPclowN5/PyST6ASUuwvOW4r/g0M5ZIVDod5THAMCsv0unGSbsiWboUKNq4lCAG2Q4/UoC7upoiq3+1UOcgDNZB0FNbqC8Tm7++di1SQzuuyyDKRJbLr0grrm0Q7c96W3tbUTYNTxH4Gw7bsOxT3GtqVGU2NRhVlKLcrDQsf/dKVRf5oDNMTRBRzSI32p3wBR1SItO6XRKfdNU3z5od6uQgUi6t9MXctC3QSCXq1WdoeErI2tsm80qZPS3f4RWD8s+vGtF8w6kBZ+rVLUOceeLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DadkDfnMXF+IkCyrAsJXcY75YCzdTfcl9imh7c8bN5c=;
 b=MlcMqVQTUAb8ZMfnvN4VI12oPU2ybRcgZPzKW7TEtpY279m0RMxzwUKNefZnngZbheGNtKX5Lm6YkPttCwNqjptQE7UWhhUqPvQH53uJrftl38KfGoQubHeZ0TuaxEf48KuQ9biapRp2cFpL1/71FRFVfVh3BU8zUFgHa97TR/I=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by LV8PR12MB9357.namprd12.prod.outlook.com (2603:10b6:408:1ff::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8251.22; Tue, 17 Dec
 2024 23:16:05 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::c170:6906:9ef3:ecef]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::c170:6906:9ef3:ecef%7]) with mapi id 15.20.8251.015; Tue, 17 Dec 2024
 23:16:05 +0000
Message-ID: <57d43fae-ab5e-4686-9fed-82cd3c0e0a3c@amd.com>
Date: Tue, 17 Dec 2024 17:16:01 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/9] Move initializing SEV/SNP functionality to KVM
To: Sean Christopherson <seanjc@google.com>
Cc: Dionna Amalie Glaze <dionnaglaze@google.com>, pbonzini@redhat.com,
 tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 thomas.lendacky@amd.com, john.allen@amd.com, herbert@gondor.apana.org.au,
 davem@davemloft.net, michael.roth@amd.com, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
 linux-coco@lists.linux.dev
References: <cover.1734392473.git.ashish.kalra@amd.com>
 <CAAH4kHa2msL_gvk12h_qv9h2M43hVKQQaaYeEXV14=R3VtqsPg@mail.gmail.com>
 <cc27bfe2-de7c-4038-86e3-58da65f84e50@amd.com> <Z2HvJESqpc7Gd-dG@google.com>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <Z2HvJESqpc7Gd-dG@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA1P222CA0152.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:3c3::20) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|LV8PR12MB9357:EE_
X-MS-Office365-Filtering-Correlation-Id: e08408b6-7b3d-4871-41c0-08dd1ef0c7d5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?S3dqdUsyU1dLdzRvUlhSUWZkMW1jbVVhQVhxSFFSa2hORTJjNU9RL3lHU3N2?=
 =?utf-8?B?cUwyTjkzQXFZaStTa05KOFRtVExQczUzWWw1OTdKWUZHeHB4WUFYdEtIYkh5?=
 =?utf-8?B?QUFMWEhZWDVRMEVuazZ4RW9MT0w3d2FScVJrUlRvdExmVjJuQWI2L09ZUGlK?=
 =?utf-8?B?MXFLQzh6azhxOW5oMzlzNkl4VEpKdUNOQ0daMnpSYzlzK29nWXA2REQxUXBX?=
 =?utf-8?B?eXJTeUlZa3N6dThnZ2F4RnVyR1VMZHFSQXhKODlzcDdhdGtYcm14bXZuTjR0?=
 =?utf-8?B?cFFjN1Q0ZG1YYmlzT3VJVVRFcno0UEh3WnA1L210ZlNHRGd0Mk4xanpsbXR6?=
 =?utf-8?B?NlM0VEhxL0oyc1hpeFdkVThVQkRRZzkvSXkrR0psK3RxQnRrcDE0eWNmSDF6?=
 =?utf-8?B?MXZmMitCdFNUYmJFWThBNmp0amc1UkpxczZlcVc3YWlYZWtMVzZmcXlsTVNw?=
 =?utf-8?B?b2JnQXByaGQ1eEtsbnR3Ti90cURnWjR1aXNtWTI0dnV2d1V4amdvNXRWU2ZU?=
 =?utf-8?B?YXE5b00wSnQwOVhHbGpBKzlFbEdlc2ZHTTBRMzFyUW85QzZlOFdnbkxuSkQ0?=
 =?utf-8?B?N3Y1dTIyRDVkV05QWHJSS0pNY0pIZllxS0MxWW1TTlB1RzFIWStFME5qTWRI?=
 =?utf-8?B?SHRZVUtqTy9GNGJjVk14ekpmcnJHcnp3VEMzeXpVMk9taVZUNGptWTI3Rjda?=
 =?utf-8?B?emZpQW5jazNyZWFPTlhmOXpiYnViSzNxUjZFZHBvZ3ZiVkdma2J4QTVUM25Y?=
 =?utf-8?B?L1BqSytQYmEvTStKOEpFYjNjSjBnSGkxTzBOWVIyRDM1U2t5aVNMd0FlQnJs?=
 =?utf-8?B?NkZwWmZHamsxZGlTTlM2ZEgzNnVNSVZzZ2htS2p4ZXF5eThvdXpMWEQxa3Fx?=
 =?utf-8?B?NkJNMlVOVTJ4UjZwQytEZnR0V21WSU5xNzdMeitvRWZhTTRjM3NySnlwYnlB?=
 =?utf-8?B?ckxNQzlzUUo4MHRPMW1PaGF3bnJWUTJyWWxWVnN1MUx5ajdrK1cvbXduNzFj?=
 =?utf-8?B?RDRmS0lDR2NnUmlQMFZMTWNvdWF5U3VHZmFqTXpwWkt6b1lXclVEYTFZZUNS?=
 =?utf-8?B?bzNRbTBPREFvQUN3Z1R2a0prK3JCSFBxaXFKL0xtMmZxb0pxTTNETmN5VDBt?=
 =?utf-8?B?bUdJUTNHMS91eld5OENHYWpOMVp6OHlUMzFjbHN4d283U3RYOHFQRVo1eWx6?=
 =?utf-8?B?dFhTYW4xTytObTFYQko5N2FXTUZZUjZlOE9LN0wvcUJxSTl4S0wxdU91Zmx0?=
 =?utf-8?B?enk5R3dXZEY4cXhyT0Yyc1UrZGY1clVRZUJueGlIVDVMallDQkpGQjBYckYx?=
 =?utf-8?B?Vm9QWG5mQUo0UzJSRGd2L2NuVjBQT1NVRzgvT0w4bWFHR1hqMis4RzFYcVdm?=
 =?utf-8?B?ZFdRQlJIMFREWUJBMEh1NnEwVG40c3ROYU5LTEFlVkRmOXNVV3YxTDcySGZN?=
 =?utf-8?B?V2VSdEp0MFhnQ1luZVROZTRocVZWY0ZlYjVnd1JybjlIV3g2VDdRNkluSFBn?=
 =?utf-8?B?UTlBWnkwWlMvRnpaZ1ZBSHBHeXYrd1FxeE42Y2Nydkc5ZThmUWVCSEJuMWlm?=
 =?utf-8?B?VmZFN0dhWDFRV0wvNG5DWWRGRTFucVNQd3V0UlhKMlZIMWlxOUtXTUFubDU3?=
 =?utf-8?B?bEliSEpVZzZ0T1J6U21ldUVBdmtzZmxyUGFQMGJjUHNKWWpyWHk1cDJtc013?=
 =?utf-8?B?S0NWN3pqbThzbTFNSFFKSExUWFVSaFRGQVZpbGZGZENYaVBWYngrY3Z6a3la?=
 =?utf-8?B?T0lBLy9BMFRrRkMyS2MyMlZzbmJZVHpFTWlqVXZqK3VYWUI5c2k5RXd4NGgw?=
 =?utf-8?B?L1FsSFg3a01vVkh1RGpUSDJtcWw0Snl4emxQNHUwR3kweC8yU1V4NzBDVHJK?=
 =?utf-8?Q?dCj4PoJQAIXWl?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cStud09ZZ254cTJEaWJ2TDFIOGRnT0twNk9Oak42TncrdzMyNHhBekZFM1R0?=
 =?utf-8?B?OFN4ZzNDTnk0eE5GanlYbUJNczdtSy9jQndCc01uZ1JpMnBnVTB3MzRoTER6?=
 =?utf-8?B?OVpHdGc1YmZvbm9oS3Q4VkcxMnlKOEZ0RHFUVEVIcldLcjFkQVBLU0pmd091?=
 =?utf-8?B?TWRraDZWSk5VWmZGTGk1M0wvRWVkVnk0M1p6STBkbTMvU0lhSUNrL0lHcTZy?=
 =?utf-8?B?cHU4aWhnWFcvN0FiRHp5bGhvSEVoV1NxbS9JdnBPM2hmeEgzaTZYa0VtVXBx?=
 =?utf-8?B?MEFLWG5Bdlhtd2ZpenZBUTFyd2R0eTlYRkJCTDVZcUF0Mk1PRktFdm5JMXdU?=
 =?utf-8?B?ZXM5RTRYTTFtTHFNWDV1SmU3dmRkeUZKR3Z4UmFaZnVOZ1VkRWozQlhxZEFJ?=
 =?utf-8?B?a3lzMXh3YnZYRkJ3Tzc0Vm9nNkpGMXY2R2hhOHNOK0laMW45ek9TUjNZUlRX?=
 =?utf-8?B?dkxnRDA2MFRMdmdmOTY4YjJKWDk3VC83WExEYTQ3TzU5bEJWcjI0Snd0bUpz?=
 =?utf-8?B?MGRJa3owWHZMUXY4YW40RzFJcWxIbEsvUHU4T1VwSXdZZGVKUlI3RmxLWG5G?=
 =?utf-8?B?MkJqRFRFck5WWGZjMllkcXlsUVRlTnVuVzRmZklVS2FValpVVUUxamhDbGRo?=
 =?utf-8?B?VHN1SGZ5NWdGWC9lSVdFQVpkQlUzUTcyVFN6Ly8xV2ZSVUdtc29NZDdNQkI5?=
 =?utf-8?B?TXNXbm9NUEMrdU1TNTd3ZDdkMTF6VEtVMXMyem9ibjdFSmFjeXp6N1l3SzhI?=
 =?utf-8?B?YTBwclU3ek9Ba3NJSmo2MXNrZFV5TUQyVXVteVFXTG5NdDZubTZPSzJSTTFR?=
 =?utf-8?B?Y21USjJOWldsZzIwZWRjanZqa0g4R1F3ZmpSOHpFbk00OG5TU3REeWNhWDVr?=
 =?utf-8?B?NUNMcTdQT3JLaENEd0Q5U0U1aDhlVjJ6a2dlcjNLcG8vSm5FL3RxWjZDSjhZ?=
 =?utf-8?B?dDJmVWpyZ0FWeGwvUDN1bWpLY1p1M0FiWnRISW5DVWF2U01LRCt6aWZBT2p5?=
 =?utf-8?B?ZlN5NlpxTlgvd3FnWStoRXl2RExVVUJnMlduQ2ptbDQ0ck4wQUdRQm51UzJt?=
 =?utf-8?B?N0NKRklDQ3oyVm5zS3hCYWk4WGVCWWVGanRhVUdLemJoajRyeTdYV0Raa3J4?=
 =?utf-8?B?T2daYi9TZUZXWXlxbHBwMWVVK2tiTER2bkhIbmhaa2xPUWlyWnQyaE8xbzBr?=
 =?utf-8?B?RnBONHh4QWo4UlIwbG93UldTU2YwcTdQbEtuLzFWc1R1YmRXL2VaM09hWTV0?=
 =?utf-8?B?MGc4SGZDVml0WHFtczNtQmdxMkNFb084TEZ1dWhnTXYycnc2K0NabjkxWXM3?=
 =?utf-8?B?UUdhRmJLcDF3QVNkcWlkTFlNdGpSWE1DcC8xcnlzZW9YYkEzYXlGQ2l3NXQ4?=
 =?utf-8?B?SXlRbWFKR1ljcFB3MlQ0VzljQ2wrUTNET0pQeXFtK2QzSmRWOFNZUHpMTVpu?=
 =?utf-8?B?dEVoQ2l0WHBvOXJMSmRyMEpLQkhldUlzSUplVUZDNXozUFk2SFZWZXFqamYy?=
 =?utf-8?B?bWg2bzc0R2hkb0xiUE1LVlBETFY3MGQ3TFlYd2pTbnFCZHNWNUJkdDVwa3JG?=
 =?utf-8?B?UHczR3BUcHpWNjN5T3cxeG1Pa01wR2ZhZ3JmT1ZiakdiMnk1ZEpVWFB2b3ov?=
 =?utf-8?B?Y2puSGRDTFBQTVUvTUE3K3VEUnRKTXlyK1krb2dWT2xUSExxcDROUTdpOXFn?=
 =?utf-8?B?eDVVYlFCdjlYdWZyck1WeEllVUZiYWZYUWxrQUZWL1czQThCR29LM29NaXdT?=
 =?utf-8?B?SmdVemt0ejJvcm5oRi9RUUtGdUJXWlVFNmpRYnU0SHBYeVNXd0FpRGU3a0tp?=
 =?utf-8?B?T1VvaXdHcTQyRjUrV1hkNjIvUCtTRHAybm1yOUp3TXRoR0xnMGtYQXVicm9k?=
 =?utf-8?B?bWhkWlZOOVRralI3c1VWSzlFbTdPZUVUTVpvejBtTW5UK0dKQ3NkODFET0Jq?=
 =?utf-8?B?UVFLK2pVaVhreEtVNy9vSUhEUmtvN2h4TkZpVTFQbjZLc3pPbzI3WjlSQ3BF?=
 =?utf-8?B?clpEMmtaMVRGUW44Y3o2azF0QTAzSHBPNXJjU0g4QkFiTnVCZVBUaG1Ha2hM?=
 =?utf-8?B?ekV5RjBEZG5TWEhPZ3ZHMTFVSXlhYjlqcldLQ0xjQThaa0FOKysxMHBxcjVK?=
 =?utf-8?Q?0Em4Ohwd7p7HFGIuJN4GYWh7m?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e08408b6-7b3d-4871-41c0-08dd1ef0c7d5
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2024 23:16:05.2234
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vr+6fPaXlnIfX/7gy1lrVFcOB7PDG7oEKtWowz+N72Cu19zCP+3Z9avZ2vgQAH54+/vAOR6g0PIzQugQh+KKiw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9357



On 12/17/2024 3:37 PM, Sean Christopherson wrote:
> On Tue, Dec 17, 2024, Ashish Kalra wrote:
>>
>>
>> On 12/17/2024 10:00 AM, Dionna Amalie Glaze wrote:
>>> On Mon, Dec 16, 2024 at 3:57 PM Ashish Kalra <Ashish.Kalra@amd.com> wrote:
>>>>
>>>> From: Ashish Kalra <ashish.kalra@amd.com>
>>>
>>>> The on-demand SEV initialization support requires a fix in QEMU to
>>>> remove check for SEV initialization to be done prior to launching
>>>> SEV/SEV-ES VMs.
>>>> NOTE: With the above fix for QEMU, older QEMU versions will be broken
>>>> with respect to launching SEV/SEV-ES VMs with the newer kernel/KVM as
>>>> older QEMU versions require SEV initialization to be done before
>>>> launching SEV/SEV-ES VMs.
>>>>
>>>
>>> I don't think this is okay. I think you need to introduce a KVM
>>> capability to switch over to the new way of initializing SEV VMs and
>>> deprecate the old way so it doesn't need to be supported for any new
>>> additions to the interface.
>>>
>>
>> But that means KVM will need to support both mechanisms of doing SEV
>> initialization - during KVM module load time and the deferred/lazy
>> (on-demand) SEV INIT during VM launch.
> 
> What's the QEMU change?  Dionna is right, we can't break userspace, but maybe
> there's an alternative to supporting both models.

Here is the QEMU fix : (makes a SEV PLATFORM STATUS firmware call via PSP driver ioctl
to check if SEV is in INIT state)
 
diff --git a/target/i386/sev.c b/target/i386/sev.c
index 1a4eb1ada6..4fa8665395 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -1503,15 +1503,6 @@ static int sev_common_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
         }
     }

-    if (sev_es_enabled() && !sev_snp_enabled()) {
-        if (!(status.flags & SEV_STATUS_FLAGS_CONFIG_ES)) {
-            error_setg(errp, "%s: guest policy requires SEV-ES, but "
-                         "host SEV-ES support unavailable",
-                         __func__);
-            return -1;
-        }
-    }
-
     trace_kvm_sev_init();
     switch (x86_klass->kvm_type(X86_CONFIDENTIAL_GUEST(sev_common))) {
     case KVM_X86_DEFAULT_VM:


