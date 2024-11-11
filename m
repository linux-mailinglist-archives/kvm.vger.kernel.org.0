Return-Path: <kvm+bounces-31421-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F6C69C39F4
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 09:46:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A51A41F22335
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 08:46:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26F5516F0F0;
	Mon, 11 Nov 2024 08:45:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="5ct9Q/Ou"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2079.outbound.protection.outlook.com [40.107.236.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B14243A8F7;
	Mon, 11 Nov 2024 08:45:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.79
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731314752; cv=fail; b=WodMGt4nmI8erSD4NfdbIQ/ob7Fbl0nWIS+X4p/PXWEvBJSZvU8sgy9sl+J9LHxTszmdKNQeuaZ1soUEWBQ0n+xorExa792w/2KY1tHuLNaJJEZ3/a1ktlJsCZ1SDaBRxutqFkgJiHEGwycuwVRBE2flc78LwNQ+LmqBCPv/dIk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731314752; c=relaxed/simple;
	bh=XbGHpEESgrezz7Xtqo6P5/XU2M+voqeHOF/+BxyC6kY=;
	h=Message-ID:Date:Subject:From:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=cI1KGrF9F3ftrlNptaP3TdMrq2o5C1+BKgLMzrS2QHdJ2g/xepa+70DjOyfoyWz1nvpUP0b25i/9em0cJYnDh569rD3kNmwOG12STl6Gm/42hcURFvOrCD3QtoALD/Ej8Q5mFP1kgwxIsqsrWt/q7YoqQ4fZVKyTLHQqeGZYsC8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=5ct9Q/Ou; arc=fail smtp.client-ip=40.107.236.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MImFjH31xaDMnJ6+VxalbwmVIrQfadkED2OACWszchX6kgxfDr3B3pY0SDp3rO0MSPwCqTZg1LRRcYCOgC0mrk447UvtHxYjLLA7gvge49ZfH0XiEZkmfMFz2TWmOKEJL41uNZl9iJqRg0oh9bsDH/do/YFoC9hjONtOhkbzfoqjF2Q4orZAusfRl5HUYO4qgcDNJmzNOyO5aL5LZRmwSiRsMJS5i4Hs17jOzp39bhizuNDnqZH0JVCN7teZhsopJ3ABHCvspzDoSBCV1qdliOQL1tipk9PE1ecKareTNcFhK8C3iKSjq1DJhxE/LKjjp82rJ+wN+yLLKzG5HdhPbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GAMRuNbPgPFMPfQ5zNzD+KfQN6Ei7TvkQD/DZHLNFHg=;
 b=FeUiyCWFnGxjchLL1pfSm77QN+BnZsOXcnzkOZVi9OxGpVmeO9OukP3FIYslagOb6y2ci/h+dKD57UzQ9VEnZ3nvAF+tlm0NU8SndDAPbxqzdcLBnSieQAC6tSqB2Atzrr+O/5edJ505Hl7vS+no7EcxlvkP1SUjt2dhplsXqY8905RwV90b+FPrf5nbH4Xq940dVETmBpcJ3lIcyY6esU9OIM5vck2XlpIjJQjquTghlIotQUdZscCxGaKp2lC2JhiTFwBzeTDYSDpxJNdjJv3K0+sV4G6YdA/mkPUFVN2GRwHSrN1i29bTZzfXkHkmC+3LX7tO/7GjMHT9sFV18A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GAMRuNbPgPFMPfQ5zNzD+KfQN6Ei7TvkQD/DZHLNFHg=;
 b=5ct9Q/OuO2DoNJhhgFi2ggzt3Biz866mtbfiYCVgvtqFtiOeujbWaZyp9gpaWbKL0m0Lp/vA9NgLDfmZWGd3SNdjYybrSPu4M0qc0aKsobtrk3KX0NgXuPeux5TY8CpQDmcj9tj/juLq9obQASYp8CVKqAf32QK/DwfIw4rZO/k=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 MN2PR12MB4063.namprd12.prod.outlook.com (2603:10b6:208:1dc::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8137.28; Mon, 11 Nov 2024 08:45:48 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec%4]) with mapi id 15.20.8137.027; Mon, 11 Nov 2024
 08:45:47 +0000
Message-ID: <4115f048-5032-8849-bb92-bdc79fc5a741@amd.com>
Date: Mon, 11 Nov 2024 14:16:00 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.1
Subject: Re: [PATCH v14 03/13] x86/sev: Add Secure TSC support for SNP guests
From: "Nikunj A. Dadhania" <nikunj@amd.com>
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org,
 kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
 dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
 pbonzini@redhat.com
References: <20241028053431.3439593-1-nikunj@amd.com>
 <20241028053431.3439593-4-nikunj@amd.com>
 <20241101160019.GKZyT7E6DrVhCijDAH@fat_crate.local>
 <6816f40e-f5aa-1855-ef7e-690e2b0fcd1b@amd.com>
In-Reply-To: <6816f40e-f5aa-1855-ef7e-690e2b0fcd1b@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0121.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:6::6) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|MN2PR12MB4063:EE_
X-MS-Office365-Filtering-Correlation-Id: 67cea65b-925c-4e8f-8273-08dd022d3cdc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?QVMzYmNyUmgyZjRHR29BUFhtc2d5K1NsWGdoY054RmZ6UFJ4YlBUMzlJNlVm?=
 =?utf-8?B?NXdPaUczT2pZaGFlWml1NG1KWjZiVE5rdk9sWmlUNUlvRE9iT0M3ZjdYTDdD?=
 =?utf-8?B?Q0hCdFMreldQcnNicWdBYVlvVEI3blpxd0hQN2kxcWc1UERJOWZGVDJvUzNm?=
 =?utf-8?B?OTN1b0hyUHUrZndxaHdVMWF6VmMvMFpYTkJxTFJDYU9STitienp0Y2hsTis1?=
 =?utf-8?B?QVduTFhMZFlUejh1YVJWZStyTUEzaWtxRk9oVElWS1djbWM5T2dJcEQ1YlRP?=
 =?utf-8?B?Y1FvVzB3RnpzNk5GZzB5R1pOZXVaZ2pYcWs1YkxCYXhHejB0WC9aUjdEMzg3?=
 =?utf-8?B?YkloYWJFeXI4OXREWlpQb0RoNU03MVh2TS8wa0kxTlVhZGc3c2t2TmlOQUdh?=
 =?utf-8?B?NGlXczkxcGxteEFkNTgweGtlbnZNWWp1cld3Sis4UzBEWGw5VFhSZk5zK2JJ?=
 =?utf-8?B?dlBnUkEyNkJOU3YzUG5MOEkvRHVzbm9RK01Nb3VoRSsrSkp6Y1Z1MlhaU08w?=
 =?utf-8?B?N285SDNabHpYL2ZPWWVSOTdKd25yY1h4MndJVE0xS0pRNXlLYnNpSXd0Uk1x?=
 =?utf-8?B?cWYwQURKdU1yVHA5MVR4Uzk3MHN3SmF2Q21uamN4TDdBZnp4ckc4SWtKbksx?=
 =?utf-8?B?UGE5SXhXTzZFNWFaMGdVTDZLbVlWZlFBWEFQazdCYy9HaGxNMWgrTGJZVEpE?=
 =?utf-8?B?YXFOWkg3M2FzYWJaMUlCbWhsUmRDODdiUmhRMzFFaGVuMk9qWXIzZC9qandL?=
 =?utf-8?B?UWhiZ0hGdHp4c2NnYVNoOFg1SVdVcTR0Z2JaSnRtc1lZWXZlL3J0ZlpVU012?=
 =?utf-8?B?MytmNHRYbDNDN05wUGREMVhQcGZ0Mlp4Uk5ZczhoK0VRcmlESGdUUWF0bytU?=
 =?utf-8?B?RkNaeUpiMm5Mb2ZNNlFWdWNTd0ZzaVp3bnFLWmszcW5aOGpnMngwOHFPVWNE?=
 =?utf-8?B?Vi9EV0RMaTBkWDhiWkRBbnliKzlJZFZjZXF6MHEzblc5dDUyK3V6bGRnNjJa?=
 =?utf-8?B?UEtONVdqQ21qQUp0NkE4SHZyQitFb2UwVVIrWmlPU2Z1OEI5OGRLUEQ5cVlH?=
 =?utf-8?B?OWVxYU9SZXZSVG9sM25vY2JQYkhDOHVuc1hjd3FWNWxBSU8wcm4rOENTUndL?=
 =?utf-8?B?ZWwyOTcrSCtxMzJ5cE9PVS8xZTlvNEZFaEk0cEpSQllMWUtDZEZmOGZFWDRX?=
 =?utf-8?B?M1U5d0FCOHZvRFdKY1J6UEMzZ00vckwvbEVGZWhLOTdNVVppM2hrSlIwOUE2?=
 =?utf-8?B?aTRCMlNVZjJ2WHZmM0RWUUMxdDE2b0lGTnd4MnF6LzN3aHhzYlRFWjZjVytx?=
 =?utf-8?B?eDlDbGZsMEN1ZmlWV1ROK1lhZFUxVU9YVXlFdkRvbEpaYTNFMmVqR3p3Y0Ju?=
 =?utf-8?B?bzNLbjNmd2VQeFlDWjArR29zVnpnSVU5a3V4c2VPTHA2bXFLVXdRVnJnaXd3?=
 =?utf-8?B?cHdMUzY3b0ZmQ2lJOWtoZlZwMzVOd3kyUlRQR0xIaVhHNFh0bkREc3ZYWVJm?=
 =?utf-8?B?Q05TTmJuYWlqcVpPS1ltVC9OZlJXcUFCa1NuNXVtWlNUbnpPNWtuaHdKN0Zo?=
 =?utf-8?B?WGl2dTYwZ3I0TjQ0Qnc5eFMwbHV0a3RzbWtIQ09oRGlnTGU5aFdNUldURDAy?=
 =?utf-8?B?eTZ1cDJTVjAxRHd6ZkRPdFJWaDd5MzVhOXVxUXBQSm1JK0MybDBZZkZWYXh5?=
 =?utf-8?B?VFpQenNFK0tNVVg1YW5FVXZzWVBKTm1Vd2hOZTN6R3l1WFh0ZlZPVmpwNGp2?=
 =?utf-8?Q?Ee9JaBDelDDzvmuHYq0HnTi92KmpdUW4lSOa0yy?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RlJJR2xMZ0x4RjgzZ3JqMTZFMmZNRFVlR2xMS2FxdVRjSG45WmxSV05FNElq?=
 =?utf-8?B?bnRIS0ZWUHFYejVWclorQUNIYXpqSjNmUTdzVTNUTlNPVmxwOHhoclNOUTZI?=
 =?utf-8?B?czdzTHJ1NWNaVEQ2Y2NlbEROQUptSDRQR1BzWWdMU0tad1lkdmg5bzI4d2FT?=
 =?utf-8?B?cStTZ0pLSUsySHNMZ3VzT252Mk1BY1lRUDZqS2FJc2hYcWlkM1JjcXJMU0Ix?=
 =?utf-8?B?K3FEZjdFcGN6bFk1U2hER1Vtdk5pSmRYT0ZFb3JpSThPNVdpbWlvUldndisw?=
 =?utf-8?B?Zk5sNGpQUVRGc3BWR250QktIWWFxdFk2OVhWaHNmYWpsOXQ4VE0xSHVIb1pv?=
 =?utf-8?B?UFRvOGZjWDhoeUF0RWFnOTdGWkhRSFJpRW52Yi9KNVBsc3kyQURUemFKN1M2?=
 =?utf-8?B?czRMSGhXN3QvZzBscDlLTGVlbFZ3anlOWmRHYngxcFpybWtVZFFDUlo3aVZ0?=
 =?utf-8?B?c3UzNmMweEFmNEdib0FSOXFDeUhFT3ZCWGVuVTNLeFdGZFk0WHRzbHNBYm5U?=
 =?utf-8?B?UWJmcEtCKzB1T251ZGNWRWJTYWI2bXRPYm9QblphSFZ2a2szcWptbmxERG1w?=
 =?utf-8?B?RjlrOUxmTHlHU1BTSWtwSUVMOTBLc3YwWDZUdGlTUndDUks2TU5LSFhpM213?=
 =?utf-8?B?SDhmaU5BWjR1TzU4TEtqQkdUKzJhRHdUOGM5SzVlaTFBQVd1cXlDTWEvdlZr?=
 =?utf-8?B?UUxKVXVlN2VyaS96MHpCZTFIb09EWjZzZWppenF2dHltVnRnQ05wT2pBck92?=
 =?utf-8?B?U2RRY0RYSmF5cGMrY09INUM4dU1oenhwSTYxMjRrL0FpSnMrRHJPNEwva2tk?=
 =?utf-8?B?c0szUTJoemVpcGlyOGNOeDhwZ0VOc2N4YXJrLzlFS01ZTkoxZHUxSVJsVGcy?=
 =?utf-8?B?TkFEdHk0d0tmNi9CSHhEclFJTmtncy9KbG1qRWhWek1KdUNIWlNNS0kvSFVP?=
 =?utf-8?B?a0NtSEIwNE53cXRyY3hiOHUzRUtjYXVMczlNR1o1N3diQTgwcHdhNmxhUDZs?=
 =?utf-8?B?UUJNdHlwMlIxbjBZbTNvY1VoYlJiUWJhRTJONWtwcktUQnpibm1Jd1lEenBw?=
 =?utf-8?B?VWRiTmxDSms3NGZTOWNYcEdiVkdyd0M4TEIzSmFsdGpzdkxRRU16bEFZUTVL?=
 =?utf-8?B?eHZOU2xjcG00ZmE1eDRla0RKdHl0RUZLRVpxdi9YVkplc3d4U2pYdS9mczJm?=
 =?utf-8?B?ZzIzRUJObmtibllXS0xNbHZkSDBiaUx4UjBuTFc5TVhJSC8ySGdGNUdubGk0?=
 =?utf-8?B?RWk5NzR5QTJmZ3E0cXgwREsyT3hyZUg1cVpsT2pncWtaeHlGT0xZVklReUps?=
 =?utf-8?B?WlJFZEFSZVl2aHMrb082V1YrVEZFMXZqdDJrVTk3blVHN0pjaTZjMy9qWFJO?=
 =?utf-8?B?Sm9FVEpSeHZPRk1GS3YvSVFmaXNLWHN5NEZhRGZRaEcvbU1qNDFNYzBMWTQ2?=
 =?utf-8?B?MHNPRjlJSU82aFI5YldOSHltN0xPNU1Wa05yQmthcFEyTDEyTHErMmQwV21F?=
 =?utf-8?B?eVd2dGxzdFFJLzNXTVdIK2VqbEpIS2JERTNOallxMjlta3paSjZUNExyNllI?=
 =?utf-8?B?eFJFZVRNQXhXbU4xL3lXSjFTY3pYVHp3Yk1EeDFadnQxNkxaNnFXWDJRbmFK?=
 =?utf-8?B?TWtXb21vcCtGM3NqS2tmcmRRandJcUpXVEpIckFRTjluK3puaEtPTDlZYjF6?=
 =?utf-8?B?TDVaYzBkMGErYWhYZDh3djZaRkg2N3dBRXh2dFNlS2Vwbkx4eldBeXBpaVA3?=
 =?utf-8?B?Y2hJdWl3NExZSkx4OGpZdmVyNWozS3RxTjRIMHo0THNXZzd2QzgyczJYUHFZ?=
 =?utf-8?B?THh4VGdnODZRcUkxREFnV1BxL09vbithZ3ZRT0QyWjByOUx5bFNYMVE3WXd3?=
 =?utf-8?B?aW5lOVNHOVNGektkQzhIbVB1dnZ5aGc5RG9vaTcvek05K3k0L3UvUUNMV0xJ?=
 =?utf-8?B?cTlaUWdaaE1ScTd3SjFlSW9yQTRwNzNNUFBHQTFzYXMrZSsxVVM4MkFvSVVw?=
 =?utf-8?B?ZHEzeFR6T0xQR0ZYNG95K1FLL3UrclNNUW95cVVER3lWZ2VnQ2dKd3pERTlk?=
 =?utf-8?B?bnNBTXloL0p4WHhHSlo1a0U2Z0Rza0NoM1VFMkZJTVJmeDlLV0h3S004YTU2?=
 =?utf-8?Q?UI+vxG70CYxifr7DLTJ6L2veK?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 67cea65b-925c-4e8f-8273-08dd022d3cdc
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2024 08:45:47.8263
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mriFvKBxoVVkPEbFXhw4RvmZYVM2DJgOZqJ2zC6+sPp/Lqv/aUCBUXlFBJQCd0q8QeVbHCeXgcOq35kkLErhSw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4063

On 11/11/2024 12:33 PM, Nikunj A. Dadhania wrote:
> On 11/1/2024 9:30 PM, Borislav Petkov wrote:
>> On Mon, Oct 28, 2024 at 11:04:21AM +0530, Nikunj A Dadhania wrote:

>>> +	BUILD_BUG_ON(sizeof(buf) < (sizeof(tsc_resp) + AUTHTAG_LEN));
>>> +
>>> +	mdesc = snp_msg_alloc();
>>> +	if (IS_ERR_OR_NULL(mdesc))
>>> +		return -ENOMEM;
>>> +
>>> +	rc = snp_msg_init(mdesc, snp_vmpl);
>>> +	if (rc)
>>> +		return rc;
>>> +
>>> +	tsc_req = kzalloc(sizeof(struct snp_tsc_info_req), GFP_KERNEL);
>>> +	if (!tsc_req)
>>> +		return -ENOMEM;
>>
>> You return here and you leak mdesc. 

mdesc is allocated only once in snp_msg_alloc() and is stored in static
variable snp_mdesc, subsequent snp_msg_alloc() calls from the sev-guest
driver will return snp_mdesc.

>> Where are those mdesc things even freed?

snp_mdesc is initialized once and is not freed.

>> I see snp_msg_alloc() but not a "free" counterpart...

That was the reason I had not implemented "free" counterpart.

Regards
Nikunj



