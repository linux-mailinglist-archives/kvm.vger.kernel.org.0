Return-Path: <kvm+bounces-51687-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CA04AAFB9F9
	for <lists+kvm@lfdr.de>; Mon,  7 Jul 2025 19:36:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 049473AFCCA
	for <lists+kvm@lfdr.de>; Mon,  7 Jul 2025 17:35:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44BBB2957C1;
	Mon,  7 Jul 2025 17:35:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="OH+IEvfB"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2058.outbound.protection.outlook.com [40.107.96.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 929201DEFD2;
	Mon,  7 Jul 2025 17:35:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751909751; cv=fail; b=JwIlQWdg1ut4OeE4DkTLqMngOlG7XFERO0/Ds/CaiFqOeaQOGcWERJk8yQYySXIuCU0w8JDIaHza349gWOOtN60dxLBiJZ/cZxHAdSOdeSFmY9CtiVQCf+Z3OkkK2fB4mkghF4UFKcL/fMnryhaXMmSQ8keDEdtaLbY4SVUumV8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751909751; c=relaxed/simple;
	bh=kKebJ6nni7JKsGpb1/j2u8aqPKNX8Q9+SGJ9hwi0AKg=;
	h=Message-ID:Date:To:Cc:References:From:Subject:In-Reply-To:
	 Content-Type:MIME-Version; b=bEwRGXJpoT4zzdikkyZWBq7EDMKuJjb5oAHSB3zyGMkmQER8PYj1a/zQnTzDdRiZOXVbD4VIubWMtzj+kja8qpOlA9H/LJue5QaRWv5HNyqql/WXgLj1mnTENATAIzc+ldOlx5IV2BNUexjN/aDq7QPdIUmTytMcGRG6sf5HzMc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=OH+IEvfB; arc=fail smtp.client-ip=40.107.96.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GLbFDL4oifmhpvXXPlThtQo7gicqf+YCV6ABbAL12rBXDcbyF7NGqPxOwh5aZ9j2u1K2GjxszcDw6LL+qbaMcphPowoWwrXgmjtpkNBgEa4nThgqtLn3/L531YY3saxRNLFuq4CiZ9WXR+gkqU3emZV/UPMLBEWQhokr7+aJi9P80kXNlIwcX1aN7RcfjZjzSYFvjdVgTWPFqAs+QDrynZVkr3TyWGFbktgMoUy6TdMMvvdfHYX2INJQw23huJDfK5WhF+RojgKLD6LaCOAcTtc++AvlamICxs2v+w/U1TegP3dg4x8j6J62h+w7h6arGBPvFhOChh5s2i4/PCJV8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cy/3aePUkI3ggpAkfvor78fqeQMbQZKqC2XYM50TI8Y=;
 b=y1B3Zlyvy+TmLcpekud+xQfl9DCHpboICTM+N91hKFxSdXE6FYeu5y5IfW3GRDd4rxEpyCx6D1QD8GBc1ZBojQ/9yJyDhYVsd0jJEh03+VaA+0otCFBnPYxphPjsSHPmH8MhLRPtSbhoZb1BObw5eUSpyEBEoK1pJdqfO4/JyBQjtjDXIwnxxm+KnQksnBawN4SJN/YeBkpu1SQgZtuX0RQ1kLYl3T6hIZdcsrMtKIm3nZbXOKIZhEyXsfS0d51r8alLHcgan4DqNSZoComYFVhE6EF86Di4IfDk43lIMes9ODAtU8Pgas378kQS0xD/RaVTPoVKNS6fpqmZyTHlXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cy/3aePUkI3ggpAkfvor78fqeQMbQZKqC2XYM50TI8Y=;
 b=OH+IEvfBNfZfWl3I8NRdYGA2CdhflRZr4pIwynJP4UG6mvJcXpMtNoSBW3dykuCq58RvLsKOA+HfO5nBwTJXj19/PFoG8RW/EORS3Ud+Ho1YxBBcCy+rLs+0JjZYtbkEhSRZFSscJZtI7fPwP4jEw725nfquGR/K7MeuRKe2y/E=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by PH7PR12MB5653.namprd12.prod.outlook.com (2603:10b6:510:132::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.23; Mon, 7 Jul
 2025 17:35:46 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%7]) with mapi id 15.20.8901.023; Mon, 7 Jul 2025
 17:35:46 +0000
Message-ID: <048b3919-f2af-8136-59ae-fc3bf6e1b3e8@amd.com>
Date: Mon, 7 Jul 2025 12:35:43 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Content-Language: en-US
To: Ashish Kalra <Ashish.Kalra@amd.com>, corbet@lwn.net, seanjc@google.com,
 pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 john.allen@amd.com, herbert@gondor.apana.org.au, davem@davemloft.net,
 akpm@linux-foundation.org, rostedt@goodmis.org, paulmck@kernel.org
Cc: nikunj@amd.com, Neeraj.Upadhyay@amd.com, aik@amd.com, ardb@kernel.org,
 michael.roth@amd.com, arnd@arndb.de, linux-doc@vger.kernel.org,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org
References: <cover.1751397223.git.ashish.kalra@amd.com>
 <b43351fec4d513c6efcf9550461cb4c895357196.1751397223.git.ashish.kalra@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH v5 7/7] KVM: SEV: Add SEV-SNP CipherTextHiding support
In-Reply-To: <b43351fec4d513c6efcf9550461cb4c895357196.1751397223.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7PR04CA0233.namprd04.prod.outlook.com
 (2603:10b6:806:127::28) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|PH7PR12MB5653:EE_
X-MS-Office365-Filtering-Correlation-Id: 37bb9903-0fdb-43bb-6f99-08ddbd7cb46c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?alorMXI4K1ArL0VkamJ2RzM2L1ZRcnM4SnRqbE5IM0tUQUEyM3pZWnF6Z1ph?=
 =?utf-8?B?ZGpEN1RKcSt3QzdBQk1lcGhSU0xSZnRGZWNiTFNLNmlBNVlXVnhYL1ZKWXlF?=
 =?utf-8?B?T0pJekIrOStUcFpmQkd2Yk4wREdoL2tYaFBKYmhndWZlTlRGaFBydGZtK1Ew?=
 =?utf-8?B?WUl4ZStJNjNMckFyRkh6NjB0R3FRNlgrbkdlcVlzMXNWUitjNnBXaVlvY2xi?=
 =?utf-8?B?dit4dzIrellPSHJ2UHRZMmhsekVLTlRMeVp3R3hlQUNZdkVzcTZiU1pTZ2F6?=
 =?utf-8?B?VTh4TXpTWHRsaFNZb0pPNEFaaUVCOVc2Q29HWjNxcUN6WVNZWFd2NXA5MkRz?=
 =?utf-8?B?NWVNRW14dnlYTWp2TTlzdFRqNjdRZklacDRtbjZqaXFDazZVSjlpUVd5c1dI?=
 =?utf-8?B?NC85eWRudEFJVkxUTDJTZ2FXaGx4TWFKZzl5ZGxzakppQlorV0UrZGYxUzJW?=
 =?utf-8?B?MmJyNVdLNVpWM2Qxc0tkZFdzSHp5SnMxcHVHcWc0aXZNM1VZL25hTGgyVExB?=
 =?utf-8?B?Ui82QStUN0x6WmxMZjlqN1YrTG9TVmlJTmNFcFlGRFhRUDlLMjdHdkJzTUsr?=
 =?utf-8?B?YWJuT0s1YXVtV0JNNitra1M5eW5UeEtoRWhtWFBDSlpIZ0puQmhXV2drdTQ4?=
 =?utf-8?B?MmNVMCt5VXJ4MFlzanZKd1p2U1d6dklOalA3WjdVNFdMVmQyZVo1SDJoSTBy?=
 =?utf-8?B?VHJHRU1TSGI0bXU3SlRlUDdvRjMvcFgrTG5uUzJmUFNCdzVsbmZUZzUvQkJJ?=
 =?utf-8?B?RzVRSzdyWlRzc2VMbnIydVAvVVVIbDBycnFLMUVlbmExMUl1cTJBWkQ0YWxM?=
 =?utf-8?B?cmFqcHpiSnlMZHBhOWorODFvS0g3ME9kQnh1TVNlcGhCMUtLaXFCT25WZzlY?=
 =?utf-8?B?UU5rZDRUc2JhQi9OUVZtVnVxbkk5WjZhclUwc3BEOERjcURZS1pWR1hHTFNt?=
 =?utf-8?B?RkhqYkVlcXRBS0R3SGdqV1dxN0tFL1JrWmRSTnFYalJodXZLMlRCOG05OGll?=
 =?utf-8?B?NTFwOVpsVGRzMUN5d2x2R3ZNQWN6SkIwYkFFZlVVQlBrTGlaNXdGVE1BMEdR?=
 =?utf-8?B?b29hNFNBNHFHTzlQbUhsSUhmc000a2Z5SzF3SHV6Q2wwR0pxamFGdVJIa05S?=
 =?utf-8?B?TkZid0l4dzhuVGNxVXdPRDg5MGNoMXpJUm5RMzBhOEFIdUN0VlZTQUFhd1Zk?=
 =?utf-8?B?ZzdkWUkyWjA5Tk1tQ1M4Uy9WWExsOWJGK2t3TnQweHBmdzJTdU04OFovcXJy?=
 =?utf-8?B?SGIwOUg2MTVXT3pOZm12Nm9mNWlKYmVoVlFMOUpuWjY4b2t6VDhLQzhBREg4?=
 =?utf-8?B?Mk55WWJEWUpGUVI3bWZsVWlYcVZqMjhtS2hQcXNnbjZieDgrRVJmdWx0Qkpp?=
 =?utf-8?B?bE9zbVBVMXBtajR6cmIvbnBvSFJaU3FLYnlLa3RYeG0zMStiMlkrUHoxTndp?=
 =?utf-8?B?WFROUW9yV3BvZkxNeG9rVWxDaDJCZW84ZWZsTVUwOE5qcXlObHhnYmRWWSs2?=
 =?utf-8?B?M2NIdE9KSXRENW5Yc040Uy8rRU91VFYvYUZTN3JqdkplRytHbzU4Qmo1c21D?=
 =?utf-8?B?QTRZNGNlYXRiUVF4RnB6aXdQdDBzeEpyOEZzNkNwbWFxRWdqa21WdU9yV1JM?=
 =?utf-8?B?VmdhaDBVbHViSjJnaDU1Vzk2eEdZZ2pVWUVQdDJydEtDNGpDY3BlNjYxbmNU?=
 =?utf-8?B?TlFhaXRSVXFTMzlNYnU2SkNoRHg1TEJUSEx3ZExsSUcxQ1BjMncxUDMvQWdq?=
 =?utf-8?B?WE1PSDRDbkhCNzBHOTl0ZnE4SHVCZnFndDZiYTZVZnVVK3p2UExGR252RmJj?=
 =?utf-8?B?WGFxTFpadkpseTdFMkt4bUNDMmlJaEw3VExMdVhaOFNZL2Y3MXJRNFk4aFRo?=
 =?utf-8?B?d2t5ZElETkNmTzlHcm1IVTRYTzVIMXRiNWdUT0RGK1BUeGVmODMzdnNLcHN6?=
 =?utf-8?B?ekpxbUszdTR2OXRuaXJIaHo5bks5djVtOFY2Mm1BRm5OOFUwc1ovTVFTUW5F?=
 =?utf-8?B?cGRuWEt1c0ZRPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UGVwNEdoT0RybFJZZ1VHZWgyZG5FV2t3STd2QkIxM3pQbnFiTkc2QVhQcitE?=
 =?utf-8?B?SEJZUmxER0I2RXpaL0FsanZaSzlPeG9ubDVBMTByTWx4dkY0dDlkZ2YzMW1N?=
 =?utf-8?B?cFlqZjRGbER0V2RCYXdYMk1ybmRWMjF1czZ1R0ljUjBpQ0ZFM0ZEYlpQeVFj?=
 =?utf-8?B?Z081cnZrWitmRi9FNTRUS0hzeVNEQmdKL1cyME1zSUR2MmsvcEJGbStvMHlL?=
 =?utf-8?B?RVZIVy9EaW5paGYvNHRZQlpHNXZTbHpzRHh3RHFvcEJrMEt5VCs0SjdZQ1pq?=
 =?utf-8?B?Y0ltSm9KRDhZRFdwdnRYK0szSmY0STc2Ujh1dW1KbkpINU5MaGJFL3FXZ2oz?=
 =?utf-8?B?Z04vVlNtVmhzKzF3SGZSbE03dUhRYnd5dDJyMlhCWmRQRnVrbGx2TDJaVWE0?=
 =?utf-8?B?bS94bjcybCtOQThBWnZORHdqa3VZNHg0aXZqa0l5SlU1Mi9TRERoMEU3UVht?=
 =?utf-8?B?eTN3aTNjNU1ubTR0TTgvSGpTK0VndjdtZmxOMTJIVHZMbVYwOGl5YnYyRjcr?=
 =?utf-8?B?UXgzRkpBakpwM21UdmhFQkdKZXhlUTQ1RVgvcjdXSWNoZVVkamQ5VnBoNUlx?=
 =?utf-8?B?NGpxNTZqOE9XeUZ6cmsreG5FWWExbDJqQzFNNVBNdDZnWE02VUE1UnJGVkta?=
 =?utf-8?B?UklocFBySGtFMTRQYWx5UnRyVUV1ZmV1bytFelppU3dMMHRGN0M4LzFYVU4r?=
 =?utf-8?B?MEM1czJBVVV2ZFhVNHY0S1BHV3V1cDNKc2trREJONm1xMllSYnhLUWovNWk1?=
 =?utf-8?B?RXlxMkRQZEhSZitVMGhhOWRkSDFiMlI4WVlJWnZTTmZpSnVzT0ZlTEZscHhv?=
 =?utf-8?B?SXBFUkNOditrZjVHNzhKemJVY0hsRFFJWHU1dHdMejA5Yms5WllzQWNBdlBn?=
 =?utf-8?B?cWVUNGN5L0EzVFoxUmd5OGJPQkcwdWZvT3llZ29mTnFBeHRQaWtxM2tndXda?=
 =?utf-8?B?aFpLeDVCalcxWWtqZ3k2LzZGbGUvYkVENHEwOGNqTUx2Q29iMld1K01TYnRQ?=
 =?utf-8?B?YjBuV2g1VmJHV0lwb3pPemlkcGZnNmNZQ0F2Vkp6ejMxMEkzaXJNWXVHaWYz?=
 =?utf-8?B?ZW1UOTVnMm9QaWdWSTFtRHRXY0U0RGFTanJtbzlEQStVdjdXSGk1QmY1eits?=
 =?utf-8?B?N1VUbmVXQTQ5dWhyQlJUaWRXOVRLS3J4QStkdWFxNWUrVTEwd3IvcVBTMXNP?=
 =?utf-8?B?NGxKRHRxTnRqVXVlTVhFOFFsYnlrLzVEMVM4eElTQWpFb0FTeHRsUkxuRVcv?=
 =?utf-8?B?Y1h5cXdWZlEzM3NLYU5UOW9KeFRmL0hBdVYzSjVNdFZxTGZhYmlHUXc0eENw?=
 =?utf-8?B?aTVrQ25UclJOQU91WSt5Z0NBdk9ZRWlRbTZxc0x5U2U2QkVCc2pTb2RyQU8r?=
 =?utf-8?B?YVEzaC8wZERhM2tGTC91YWJRdkFYSTUzYytQbkxMWTFHYlM1V3hodm1LZlAz?=
 =?utf-8?B?dFJPdHFFUGhubzViS2dsYnNBQW5TQlVoSTBDN2VYS2xvYm85SUNNQ3ZyQ253?=
 =?utf-8?B?R1RUUG1ETk40NW5OZzRTRUt5cmovbFlSZmhTWk9OUmlQUkJwVlZlSmZkVWJT?=
 =?utf-8?B?anZqS20wSFhsYmM0RjZhd2tzQlk1LzlVdytwMWY1c0Y4d3ZtQk9GTE5GRnU4?=
 =?utf-8?B?ZTd5eGExdFZYdUJzYjN3NmZ4TFFuQWdRWUMxcnBiaGZSZGJaL1FycE54QWVD?=
 =?utf-8?B?WWszODVZZG13bVBJcEtVM09MS2RkcGdhZlpWYVVYZ3pxem9RYWNDS1ZHSkVa?=
 =?utf-8?B?RVg5c2pNYnkyWkUyZUlyUGJpMWxNd212Tk1mZjJGNDVXVWhHbUUvVytyd3FE?=
 =?utf-8?B?M3VoZFJraXJXTzRrdktzdGJ5UkdBVUFva3ZYMnZyMEo5ejArN2pla0s5RG5o?=
 =?utf-8?B?TndIbzR1cW5nOVdMWG5meXU1WWVkcmJDZFpOTFBsbGh1N0c1a2xVYm5CZ05X?=
 =?utf-8?B?NlVNNXpnb0tUTjBFa1RiYXVtK1FnbytsMnplaWgyRUpwYWl0R2xSemY2Uzh6?=
 =?utf-8?B?ZzZJRHBZV1ZNYkZCSytlUERBUzJ2OE1sc09JaVNqUVZyR2hxTVdQZnpUejJk?=
 =?utf-8?B?RXVFY1NwUHVMVlpnZEhua0NmbU9reFVBb0FwNFNOb0dTVk5aaUdqRUx3ZS9q?=
 =?utf-8?Q?Yg1TiI9bnbIQWLV9qYpR51DP1?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37bb9903-0fdb-43bb-6f99-08ddbd7cb46c
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2025 17:35:45.9567
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ta5k49dR4iaxKEWBe4gKRTDc2p/+NZEDWecXSHSG1rJYKaoxd8dNqgiDzOx0ktfvUxw653bzVaZgceioU5BMLg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5653

On 7/1/25 15:16, Ashish Kalra wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> Ciphertext hiding prevents host accesses from reading the ciphertext of
> SNP guest private memory. Instead of reading ciphertext, the host reads
> will see constant default values (0xff).
> 
> The SEV ASID space is basically split into legacy SEV and SEV-ES+.

s/basically//
s/legacy//

s|SEV-ES+.|SEV-ES/SEV-SNP ASID ranges.|

> Ciphertext hiding further partitions the SEV-ES+ ASID space into SEV-ES
> and SEV-SNP.

Enabling ciphertext hiding further splits the SEV-ES/SEV-SNP ASID space
into separate ASID ranges for SEV-ES and SEV-SNP guests.

> 
> Add new module parameter to the KVM module to enable Ciphertext hiding

s/Ciphertext/ciphertext/

> support and a user configurable system-wide maximum SNP ASID value. If
> the module parameter value is "max" then the complete SEV-ES+ ASID

s|SEV-ES+|SEV-ES/SEV-SNP|

> space is allocated to SEV-SNP guests.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---
>  .../admin-guide/kernel-parameters.txt         | 19 ++++++
>  arch/x86/kvm/svm/sev.c                        | 58 ++++++++++++++++++-
>  2 files changed, 76 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> index ee0735c6b8e2..05e50c37969e 100644
> --- a/Documentation/admin-guide/kernel-parameters.txt
> +++ b/Documentation/admin-guide/kernel-parameters.txt
> @@ -2942,6 +2942,25 @@
>  			(enabled). Disable by KVM if hardware lacks support
>  			for NPT.
>  
> +	kvm-amd.ciphertext_hiding_asids=
> +			[KVM,AMD] Ciphertext hiding prevents host accesses from reading
> +			the ciphertext of SNP guest private memory. Instead of reading
> +			ciphertext, the host will see constant default values (0xff).
> +			The SEV ASID space is split into legacy SEV and joint

s/legacy//

> +			SEV-ES and SEV-SNP ASID space. Ciphertext hiding further
> +			partitions the joint SEV-ES/SEV-SNP ASID space into separate
> +			SEV-ES and SEV-SNP ASID ranges with the SEV-SNP ASID range
> +			starting at 1. For SEV-ES/SEV-SNP guests the maximum ASID
> +			available is MIN_SEV_ASID - 1 and MIN_SEV_ASID value is

s/and/where/

> +			discovered by CPUID Fn8000_001F[EDX].
> +
> +			Format: { <unsigned int> | "max" }
> +			A non-zero value enables SEV-SNP CipherTextHiding feature and sets

s/CipherTextHiding feature/ciphertext hiding/

> +			how many ASIDs are available for SEV-SNP guests.

the ASID range available for SEV-SNP guests.

> +			A Value of "max" assigns all ASIDs available in the joint SEV-ES
> +			and SEV-SNP ASID range to SNP guests and also effectively disables

s/and also effectively disables/, effectively disabling/

> +			SEV-ES.
> +
>  	kvm-arm.mode=
>  			[KVM,ARM,EARLY] Select one of KVM/arm64's modes of
>  			operation.
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 89ce9e298201..16723b8e0e37 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -59,6 +59,11 @@ static bool sev_es_debug_swap_enabled = true;
>  module_param_named(debug_swap, sev_es_debug_swap_enabled, bool, 0444);
>  static u64 sev_supported_vmsa_features;
>  
> +static char ciphertext_hiding_asids[16];
> +module_param_string(ciphertext_hiding_asids, ciphertext_hiding_asids,
> +		    sizeof(ciphertext_hiding_asids), 0444);
> +MODULE_PARM_DESC(ciphertext_hiding_asids, "  Enable ciphertext hiding for SEV-SNP guests and set the number of ASIDs to use ('max' to use all available SEV-SNP ASIDs");

This reads a bit awkward, but I don't really have a suggestion for a
short, concise message.

> +
>  #define AP_RESET_HOLD_NONE		0
>  #define AP_RESET_HOLD_NAE_EVENT		1
>  #define AP_RESET_HOLD_MSR_PROTO		2
> @@ -200,6 +205,9 @@ static int sev_asid_new(struct kvm_sev_info *sev, unsigned long vm_type)
>  	/*
>  	 * The min ASID can end up larger than the max if basic SEV support is
>  	 * effectively disabled by disallowing use of ASIDs for SEV guests.
> +	 * Similarly for SEV-ES guests the min ASID can end up larger than the
> +	 * max when ciphertext hiding is enabled, effectively disabling SEV-ES
> +	 * support.
>  	 */
>  	if (min_asid > max_asid)
>  		return -ENOTTY;
> @@ -2913,10 +2921,46 @@ static bool is_sev_snp_initialized(void)
>  	return initialized;
>  }
>  
> +static bool check_and_enable_sev_snp_ciphertext_hiding(void)
> +{
> +	unsigned int ciphertext_hiding_asid_nr = 0;
> +
> +	if (!sev_is_snp_ciphertext_hiding_supported()) {
> +		pr_warn("Module parameter ciphertext_hiding_asids specified but ciphertext hiding not supported or enabled\n");

s/or enabled//

> +		return false;
> +	}
> +
> +	if (isdigit(ciphertext_hiding_asids[0])) {
> +		if (kstrtoint(ciphertext_hiding_asids, 10, &ciphertext_hiding_asid_nr)) {
> +			pr_warn("Module parameter ciphertext_hiding_asids (%s) invalid\n",
> +				ciphertext_hiding_asids);
> +			return false;
> +		}

Add a blank line.

> +		/* Do sanity checks on user-defined ciphertext_hiding_asids */

s/checks/check/

> +		if (ciphertext_hiding_asid_nr >= min_sev_asid) {
> +			pr_warn("Requested ciphertext hiding ASIDs (%u) exceeds or equals minimum SEV ASID (%u)\n",

Module parameter ciphertext_hiding_asids (%u) ...

> +				ciphertext_hiding_asid_nr, min_sev_asid);
> +			return false;
> +		}
> +	} else if (!strcmp(ciphertext_hiding_asids, "max")) {


> +		ciphertext_hiding_asid_nr = min_sev_asid - 1;
> +	} else {
> +		pr_warn("Module parameter ciphertext_hiding_asids (%s) invalid\n",
> +			ciphertext_hiding_asids);
> +		return false;
> +	}
> +
> +	max_snp_asid = ciphertext_hiding_asid_nr;
> +	min_sev_es_asid = max_snp_asid + 1;
> +	pr_info("SEV-SNP ciphertext hiding enabled\n");

Add a blank line.

Thanks,
Tom

> +	return true;
> +}
> +
>  void __init sev_hardware_setup(void)
>  {
>  	unsigned int eax, ebx, ecx, edx, sev_asid_count, sev_es_asid_count;
>  	struct sev_platform_init_args init_args = {0};
> +	bool snp_ciphertext_hiding_enabled = false;
>  	bool sev_snp_supported = false;
>  	bool sev_es_supported = false;
>  	bool sev_supported = false;
> @@ -3014,6 +3058,14 @@ void __init sev_hardware_setup(void)
>  	min_sev_es_asid = min_snp_asid = 1;
>  	max_sev_es_asid = max_snp_asid = min_sev_asid - 1;
>  
> +	/*
> +	 * The ciphertext hiding feature partitions the joint SEV-ES/SEV-SNP
> +	 * ASID range into separate SEV-ES and SEV-SNP ASID ranges with
> +	 * the SEV-SNP ASID starting at 1.
> +	 */
> +	if (ciphertext_hiding_asids[0])
> +		snp_ciphertext_hiding_enabled = check_and_enable_sev_snp_ciphertext_hiding();
> +
>  	sev_es_asid_count = min_sev_asid - 1;
>  	WARN_ON_ONCE(misc_cg_set_capacity(MISC_CG_RES_SEV_ES, sev_es_asid_count));
>  	sev_es_supported = true;
> @@ -3022,6 +3074,8 @@ void __init sev_hardware_setup(void)
>  out:
>  	if (sev_enabled) {
>  		init_args.probe = true;
> +		if (snp_ciphertext_hiding_enabled)
> +			init_args.max_snp_asid = max_snp_asid;
>  		if (sev_platform_init(&init_args))
>  			sev_supported = sev_es_supported = sev_snp_supported = false;
>  		else if (sev_snp_supported)
> @@ -3036,7 +3090,9 @@ void __init sev_hardware_setup(void)
>  			min_sev_asid, max_sev_asid);
>  	if (boot_cpu_has(X86_FEATURE_SEV_ES))
>  		pr_info("SEV-ES %s (ASIDs %u - %u)\n",
> -			str_enabled_disabled(sev_es_supported),
> +			sev_es_supported ? min_sev_es_asid < min_sev_asid ? "enabled" :
> +									    "unusable" :
> +									    "disabled",
>  			min_sev_es_asid, max_sev_es_asid);
>  	if (boot_cpu_has(X86_FEATURE_SEV_SNP))
>  		pr_info("SEV-SNP %s (ASIDs %u - %u)\n",

