Return-Path: <kvm+bounces-45268-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A91B0AA7BBB
	for <lists+kvm@lfdr.de>; Fri,  2 May 2025 23:56:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B6D933B9C3C
	for <lists+kvm@lfdr.de>; Fri,  2 May 2025 21:55:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16202213E7A;
	Fri,  2 May 2025 21:55:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="J8YIypub"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2043.outbound.protection.outlook.com [40.107.237.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDF2420D50B;
	Fri,  2 May 2025 21:54:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746222902; cv=fail; b=rBaFc7rL9NjDhcrmS5sJDMD1VKUVyK/Zge1FlI52m1vurrvprcUnaQXJyfYjM2LtqQvNyWgpodQU9F1inkCpdhC5eF3Hayo/LlFQ+PDfV9JorEWM6RCYoUdjryTfYWxl6bzM925npAnK6c+msuk+sqYFOTyYaEUg2dyQ5LA02EY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746222902; c=relaxed/simple;
	bh=Da7QdjyKilWVbgosbcIzb+gKc5ysK7YCci08TfKLZDE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=uQ3q53z5SCQAN/8OqxWeKv7ofxRzav6sBWKpj8GNC5017tLWCDb8GtinXUXmM+TWaRk5RX5OKUaFu3SUU/48jnWnuW8y6aHRUK778W1RNrHZ+x5k6jIPky6cOzxyfrwnRfoWH/tNgka7xDvK/XIaX1YO/9BETFW0NZNdWigHwf0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=J8YIypub; arc=fail smtp.client-ip=40.107.237.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tWKlHumCZuNK1uiW+IDfkVMbwR5pU9kwraiAAxJMm2kQ2IAvqTK0sVbzOJaV1aHxvcywydHTPx9u+4wbr6fvPhXko2UqNLoUzNkTEpUlY77frS/p5drG6gcNC5uM10Tvw/VVnT6jNaIKVJEr37v04tB8x2SypzT2yYAzdz221Tlh9NqA+nfzvGZlmUnrzqkbAtlYw3U8t8kwd+mFeWE1oNg8hEQkRqHuRZemw0BgdrxDoS4Y2p7gKa0Y25N1lzIEz82bqHigtWeUTsCWHtqZ1waQSviRTWV1qt3KJJyk8TTv45ZrBzZhEaYLI9wm6ti6cBlcNa12IkxplJyA3g5HJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HXDDXrOKgAiXeHbv6MCE7mNC4JpqorC/5Zgy4wkAdOs=;
 b=TSdORCpxuX10EkfZUPsRcUq+R8srThsU2FVhe5utxz3wxHJCrReKvjSh8WvUpEbU1VeRpYVHHyzoFvLMOMZmQ/owon+aIYmk0fSw7BWx21DOqap/r0auQklbfQidIDF/sMntsfYT5Jd4gJQ4jXTGNLxkrn8W6T4lbMwVOrNBKh3APUaney2GsaD0LTHHZm+ZYxJgnqQfmQi9QA6v4D4TZrEcj69aDHNYzf69RsEm9vUtnLjnpj4CzWQc5WJ8aP8iPSVj2dLsD0GmaxdjoTDPwUZ4JgaztZcBuj/fYhJfNc9fAcIWl+L+lKjrTaRVPetQWiztPcf8RVrb1tn90f0GPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HXDDXrOKgAiXeHbv6MCE7mNC4JpqorC/5Zgy4wkAdOs=;
 b=J8YIypubEJhYr5F/Srjva+N81b6ZLYh+8fw7h3GxsttVZEthngO2BCQyHNObOFBYCHk3twLniYmrw4g4BQkfI23yYAZBe4LJXEhfjPEdZLsNhoNAmdwdpNXx98oB62NxJOcvBgsGwejgjKv1GxNLZkFkNP85tcSnwSI8fMVmf80=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by PH7PR12MB8427.namprd12.prod.outlook.com (2603:10b6:510:242::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.19; Fri, 2 May
 2025 21:54:57 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%5]) with mapi id 15.20.8699.022; Fri, 2 May 2025
 21:54:56 +0000
Message-ID: <32758131-c92f-dd70-a3c0-ab7fc1c94880@amd.com>
Date: Fri, 2 May 2025 16:54:51 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH] KVM: SVM: Update dump_ghcb() to use the GHCB snapshot
 fields
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, x86@kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, Ingo Molnar <mingo@redhat.com>,
 Thomas Gleixner <tglx@linutronix.de>, Michael Roth <michael.roth@amd.com>
References: <8f03878443681496008b1b37b7c4bf77a342b459.1745866531.git.thomas.lendacky@amd.com>
 <174622206797.880734.10916535986146752236.b4-ty@google.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <174622206797.880734.10916535986146752236.b4-ty@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA0PR11CA0028.namprd11.prod.outlook.com
 (2603:10b6:806:d3::33) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|PH7PR12MB8427:EE_
X-MS-Office365-Filtering-Correlation-Id: d1dff626-ad99-4209-1f27-08dd89c3fa36
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dlFVWjFsL0RPN0xpQ0g5TWlVOHhseSt5NFFzbzZXcUY3a1hscEdJUlBiRjdU?=
 =?utf-8?B?dTUwRUM4UThRTlVYU21KMUJseC8rb053SEd4WlZGVi9YQ2l5SUVuNFFZZ1lu?=
 =?utf-8?B?Y2NWTklvRHhRK2J0RU90alIyWWFFa3VtNWowL201cG5KT0xaUmFxMi9MbHl2?=
 =?utf-8?B?ODBZRmV5TmpINWw4cnZTd3F4ck5FU3diZ293ODhXaXlWdEZhZDl2ZXFNV1l2?=
 =?utf-8?B?VktvdmJpZElsaHpqUm1xczc2bWlONythQ05KRnRneGg0VWlqenJjTnZuSTFX?=
 =?utf-8?B?dEdLK2J1TitmTnVpSXFIWFFENWxIYlJ6VEo0L2djci9Nbkl2REJDcVo5VjhS?=
 =?utf-8?B?Y0ZQYmR5TTlxOXVZWVg3aEdndTErWHh1REthUzgzdko0b0dhV20rM3ZnNWZk?=
 =?utf-8?B?QnVIYUx1VHViT3MzOWp4NWV0ak8zbEgxOUYvYUxNWWpGN0pTa3hXY3hTUURq?=
 =?utf-8?B?Q1pocVVsTzhyWmxaWi9ZcUwxaUVNZ2FENGxOUWVUTVlGZTc1N2JOc2dFTjBV?=
 =?utf-8?B?VjNQR3NscDgxcDk0ZGdndEZlT0oxc0FmQUxLTnNqTnJRNzFVa2Z4a0c4MmFq?=
 =?utf-8?B?Y2lkM2h4Uks4ZU15TkhsV3ViVmpLTkRtSlZ5S1dBWU5GRjFQVjEybklFNDli?=
 =?utf-8?B?Z1RUK0F6NmR4T2ptZnBpRDM2cnZibVF2WExEUXFCZVJ5MVpaQmFObEk3VWZq?=
 =?utf-8?B?N1haQ1d1bk5sN01Wamc2OHZYR3laODBndzlFdkZkdE4vUnhLUGl2ZnZlQzg0?=
 =?utf-8?B?WVJ1MGVlVXZ2b1VGUENRLzJlcnNjSDFYNG9TSExkZkN0MVNrQStHOVcrVGdi?=
 =?utf-8?B?VWZIdlpzMENXd0lEbnNWbU9EWGFuS1pYcHYrQ2QwWkpvbVpXdlFTdzZXTktO?=
 =?utf-8?B?SzdwQnpNeWtacDFFeFVrTzlGS0U3SzRaWUFZRVJNaUlsZ0g1Y2REQWRRMVNk?=
 =?utf-8?B?dlA3TWxvRUdYRUs3VmlPaVZnQlpMbnlRK2NZZHdoQWVtLzh3Y3RIZDJIcXhU?=
 =?utf-8?B?VDduT2xMS2p2d25jSWlGM2FsWE9ZRlVoOWY3Tkg3dWNvNjE4M3lCYitMaHI0?=
 =?utf-8?B?TElIQzlDWUh3d0JWNm9qL1pIbjJwUlRXTENHa0hYLzdJVDVXVnN5SnBHc2tv?=
 =?utf-8?B?dVhxM0VNSTZHemViMXUxbHg1eEYvVUtFSjFwSkhWVDZKZ2gway90alZNZk1Q?=
 =?utf-8?B?Wk51OXVjN2tmeExFT0FqZzQvSkIwNTlRRURtczYyQlZzM3Rvc3pna1R1Y1pW?=
 =?utf-8?B?aFVCcys4NWVDWVovUUQzaitDMTYzbVl2K09NQmswRE85bzB0U2NkUGV2V09l?=
 =?utf-8?B?cGlGSUZINkRXOXd2djVTVEV6RitvcVJYd0lwNWNndHpOQVMybFRGUkw3WEIy?=
 =?utf-8?B?YmNtRno2bG9hVnNCTWdmSUVuWUE3YkpxM0dyYWYxdWVzbUlpbldKV3VrTThP?=
 =?utf-8?B?R0xKN2d0akJaREFNb2FrSHBuY0JXMHRsVWRzaG1vYXlGYStWTytFYmw4UHlw?=
 =?utf-8?B?RnY1d2xaRk10Zm1jaDlGOHIwUytRcUh0b1FYQUI3aml4cDdieG15RkhtQ29F?=
 =?utf-8?B?SEV3cFRJL3RYUzVGcEQ2aDlZbEczb0xYV2xCM1g0aGIzb1hrdy9VMmVVUnhs?=
 =?utf-8?B?NFR0Q2NUMllsQWo1SGU5K1MwVlhrTU9HTlR6emEyUGRjREs4U21uZjU5Qkda?=
 =?utf-8?B?eU4wcnJ2ZmFncmFZZzMybnZESFVHZGk3bnQ0Skd1K29Damt5VUFiMTg2YTh6?=
 =?utf-8?B?Rk93eDVyQUxrVGRFeFIrK092MnhNUE1Wd3ozbnMzeDJaTzR1TUVUVW0ycGZp?=
 =?utf-8?B?VUdZY0sxS3RHc0kraTBFdDhkWFZpeWwvQ2ZjcnU2cGFTVHNEbm9BUTZFZUlm?=
 =?utf-8?B?aWZmM2xNb2ZTakljSVJqYmhqcTdySTV3RGRSU3I1aVcwd1ViYk1Mb1B3c2pQ?=
 =?utf-8?Q?96ZzmlEM0lk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?b2FXUS9MeHl0STA5R0Z1dkRrUnFTd0ZpZzQwNS9rVVVhcS9nWnYrVkw3TkJU?=
 =?utf-8?B?Qm5mSVkwb29ld3NhdHFPMVYxWGVKekk2MFRZODdyMzU0Vk9CNFd4eUNVWkVK?=
 =?utf-8?B?MlNEV0NJdFFFZFdLNXN4dDFla0hyRmQ3UTB0ODg4eXBOa2tUeHFSL1NraENE?=
 =?utf-8?B?TGpCcnRyK0daK1IxajkzMlVxKzhhN2ZEcmxJamNJb3lqNFdYK2lwdGM1b3Rm?=
 =?utf-8?B?SDdMM29lNTRwMGUwYlRqNjV0UEVaa3hsN3lZMFlHdWhVL2hocVVBWFlDMmFa?=
 =?utf-8?B?YUd4VGpDZlJNaWp3eWhLdlBrRFFDQWxEN2tRd2NFTXFVcXpZbURPTytHeGNl?=
 =?utf-8?B?Ny9Kb2U1V05aUmUxZWl0cnE2Ymo3REsxWCtqbk1raDVBNW5Hbzh6eDdHa0hI?=
 =?utf-8?B?dmF2WmxLdDNMY1RIVVZVQzJTS0NEM2FCZ0RPcVlwaFlkL20xcXdpQVRSQVBS?=
 =?utf-8?B?NkV3disrWnF0SzFGNDd1L0tENjFyUkZURW1zWUVKYWxhcG1mbHVZQm9qUlQr?=
 =?utf-8?B?TlBMdS9iMjdUYUJGQjVNUC83ODFoSEFHTHV2SWRhTmlYZWhJdldKNmxPUnow?=
 =?utf-8?B?QzFaSGx5eEFBYW9kVzhaTGFpTW8xaUNNczZzSWZ6UVdaTzZ4RjFWSDZKbmJE?=
 =?utf-8?B?bnR5S2R1WDZCTzBwckorVzErc1VoaUx4eHNSM04xcHlySkNqMGVxaDg1dWRN?=
 =?utf-8?B?NjA1V1pwYUJGSENkV3FjVk1IUFJ2ZjVvRmVjRlhIMGhDVElqSzg5ZVZ4MjFU?=
 =?utf-8?B?SHZpVGR2WElOWmxreWxCSkNmWXM3MXdQd1hvTW9FYzVIaUNFK3oxMlI1WXU2?=
 =?utf-8?B?R2h6VXNIOTByMjZCNXgwSVh6ckFHL2NXL2lUWUdKZGhwaG9JNm1MWWlHcnU3?=
 =?utf-8?B?RmkxV01xZjVlYk14SXd1ZXVza21XaTZ4cWpnMEVxUUdoazFXSUdOSFo5TVFT?=
 =?utf-8?B?V0E3QjlBYnpPbEt1eGhrbTZFZThQaWh3cTYyQ3hZSERRZWpuYUxzc3B1ZXE1?=
 =?utf-8?B?QTBTcnY1QndUQ01KSFdRTHRoU0E3R2NyTEt1UkVsUEFEdEdxaFZpTFFwenVK?=
 =?utf-8?B?RmU5aU5qY2pKTk5zTmU2VG9pbEl5aHd1VVFHOXREQS93VWF2a2ZCRWFReFV5?=
 =?utf-8?B?RWQvRkV1TEdOcmxxMXlYdjRVYTJacVdoNmR4bS9ad3RkKzJYS0FpZHpESU1W?=
 =?utf-8?B?dmlFcU00eENXc2NCYkhIcUZ2ak9oQTIwdEdjN2Y5cDRNb0o2d2N5dVpxNy9Q?=
 =?utf-8?B?LzdXN0V0T2JYNG1CNW03NWFmUmJiNk5XQTZBSXlvdU1SUDZkM1pXM1hFTGVE?=
 =?utf-8?B?azl4UUtQTTdtTWhXeTczSFRLQmVtQkg2d1QzNUVvK3JOaGY1UnNxcnRNUkx5?=
 =?utf-8?B?c3VUVGlFUGtNeFNGbCtXRzFxVFpwRkI3Q0VkRWtoR3Exa3gvT1ZyRnI5bjJx?=
 =?utf-8?B?dExRSk83RTIrN1c1aTIvQ1l5anRCaEJDcFR4NW1tcHFEbE55bEZheVFSRmVy?=
 =?utf-8?B?eFgrc2pKN0tRbkdCV2dqaUFUQ2xwVENPRTV3em05bjl2bEhyekNhayt5c1Er?=
 =?utf-8?B?cEF5TTQwVU5LdEdkRmZvZUdJRnpHVGgvT01pT1NoV2U0QjdVekZNZGZ3N1dq?=
 =?utf-8?B?MGpLRFRHZ0RsMzFvRldYQnQ4NG9DallhaUJRTVR0blJ2VkZQN2ZLYi9WMVBP?=
 =?utf-8?B?bTFReHNPeXRSWTJoRGdtWWJLb3ZvSDVZeUZETDF2aXNzcE1lR1pHQkozZElZ?=
 =?utf-8?B?M1gvRHppU3NiRkliYStKZFZ3cWE0SW1Pa2RiUDRYODRtMGhWcWxibm1WSk1u?=
 =?utf-8?B?UE9Ud0pUY1AzYkNmMlpDZ2tSSVBRZWd3azdHOEsveXVaZmQ4YklZUFFmeFd3?=
 =?utf-8?B?NlEwVUtTYkNoRHlTZElJUlQ1eWxMcE5rYUg0UjNna1lSdk5RY0dXb05JbDJZ?=
 =?utf-8?B?MEVjVjN2Unh5NnZhUFlHNm90SkZJWFB1WllXejY1UUU3TGk2dkVoWStGYTJS?=
 =?utf-8?B?d1VlaWNUVGxnQ1hEUDR6Njd6aERnNCtXb25BbkV6SVFycHdlbTVJNzNSV0VD?=
 =?utf-8?B?dnk1a1plamd3bGxMajZlTWQxcDhMeFdid0hCQVVIcE9GYTJ6em9ZQ2lsMU9u?=
 =?utf-8?Q?8vngjFUzJwNyWlM1hup//ILof?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1dff626-ad99-4209-1f27-08dd89c3fa36
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 May 2025 21:54:56.7578
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZewrdcKJlj8yX0M9h89vgjzXtm3yNxSP3evPHQ191GAhtCrar1icYJLHyY6Hj5q/aWXq6duqwEcFu4m/huJ+og==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8427

On 5/2/25 16:50, Sean Christopherson wrote:
> On Mon, 28 Apr 2025 13:55:31 -0500, Tom Lendacky wrote:
>> Commit 4e15a0ddc3ff ("KVM: SEV: snapshot the GHCB before accessing it")
>> updated the SEV code to take a snapshot of the GHCB before using it. But
>> the dump_ghcb() function wasn't updated to use the snapshot locations.
>> This results in incorrect output from dump_ghcb() for the "is_valid" and
>> "valid_bitmap" fields.
>>
>> Update dump_ghcb() to use the proper locations.
>>
>> [...]
> 
> Applied to kvm-x86 fixes.
> 
> Tom, I tried to find a middle ground between capturing the "snapshot" behavior
> and not making it seem like the reported GPA is the GPA of the snapshot.  Holler
> if you don't like the end result.

No hollerin' here. Looks good, Sean.

Thanks,
Tom

> 
> [1/1] KVM: SVM: Update dump_ghcb() to use the GHCB snapshot fields
>       https://github.com/kvm-x86/linux/commit/5fea0c6c0ebe
> 
> --
> https://github.com/kvm-x86/linux/tree/next

