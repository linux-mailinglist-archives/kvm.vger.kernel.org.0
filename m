Return-Path: <kvm+bounces-36579-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A3E0A1BE01
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 22:47:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DC71F163DB6
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 21:47:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9129A1E7C1F;
	Fri, 24 Jan 2025 21:47:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="fhiV3JSF"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2076.outbound.protection.outlook.com [40.107.212.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E318C1BD9E7;
	Fri, 24 Jan 2025 21:47:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737755227; cv=fail; b=LLFmF36PBRG3ODFFPs8QL5HiFCjM+aLoN2++Hv0UfZ0QV+16TFrVlGA7waOJ5qp0VJDzeujzrTuJI+frjQKMtqwRCG3zSwbeAWKTlX1SSbnhLsIaviVBVOOFWTRVroKU1CZMzpTl9SiPZ7JPdOluSskcADWGCkfYvnWEtnfUiM4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737755227; c=relaxed/simple;
	bh=QFgikPdF9Mv+VaU/qFXHp1yxueF0Js3SCocfwPOqBGg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=foijoT+jWkNYyqgvKaMt75QpDCV0Brbr/c9Ub58cn2NKSl588w1ouxZS7YtXRY4737nYgZyqDSPS8FQJ06KElO2uBkDCrODRBT+kRPmxvc7EAKtmfJI2bPW1bN7QRE/Q5eiNciSnD2z/jQvrSaN6FtaVAeh6k/loWEBmR3+Uj6k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=fhiV3JSF; arc=fail smtp.client-ip=40.107.212.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=y2GVQEkEfgFBmWqWbaxqqHPfZP/MiDLUZBfQYPCgiokroisNuwebgiZG+hJKmoYQKJYUKpzj4lBqVqdQ79d1qB5gAiFt8qGfMDNa3KzKW84dIzuHxN4sFUH7hWsiSiAx+poQqFH2Nwm3ALV4aBZMLlB7c+6sBD+7TuUBgnmQdUBypvi4Tw8rSk48QRThFfCc6oFil4MQ7sR2XFvPuJWZslXt5Ph1QbN0XnxxwAxPEaMeSqzV0T3fBln6HBJmIXfECUgBBMfwV+XoyKWjgjO+7WECqC8N85+YpEZPZMbySNLK3YsNlZr2jECcxPWE1YgtXADQlOlSvj3q3zidv3+Lgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TbiR+w+sdzxdciIBrC6PiEKPjHcT/TKVslBMtDVXp04=;
 b=OM4HuGN2P6OKA1lyzOe0R//7vgZWUb06AucQYxbo4exwF3CPq9I1x+G5bpUN23J2/Yc347B56YKIBOR8yx1QN3GWy+lT/5t9C1JCEgXD93QHNWKOp1kl2ADx9GLfrrRbLAyfcFdaOWZHbiK8aOPU+d5HwRNdnOQELcWniKOojMKSSjS9y4UDdFHQdYl87bZAm4O09PMXy2tmo9BJURnXiA9zlv1mOqzUEndiJXJyHQd7fzADLSU/KuXZYI0npWZb23EHV2ING3uqpQdnkwUsJ5opl6Eh3GSeNZKcjTEMsEOLHboQ+KOhyLDe5BCz9ufnfHOuJauGE8yoOtj7TL8d8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TbiR+w+sdzxdciIBrC6PiEKPjHcT/TKVslBMtDVXp04=;
 b=fhiV3JSFtqr9xj+I8FwU87dVk1FuflnrKuX2EW6ufMLwd0l5NRxkZJtQUnwkFPuymecl4F+RXJ21O4QFkSMB5FSCfVsUbr9mxPa1Ifpy6PrIRWSczXVFxfXsMRFJfbbX/nJJ2BmuIAsBNKPcOo/D+MnUM750cmFMpkxn8ffw8eM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by SN7PR12MB7812.namprd12.prod.outlook.com (2603:10b6:806:329::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.20; Fri, 24 Jan
 2025 21:47:03 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::c170:6906:9ef3:ecef]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::c170:6906:9ef3:ecef%3]) with mapi id 15.20.8377.009; Fri, 24 Jan 2025
 21:47:03 +0000
Message-ID: <5af2cc74-c56d-4bcf-870e-afa98d6456b3@amd.com>
Date: Fri, 24 Jan 2025 15:46:58 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] iommu/amd: Check SNP support before enabling IOMMU
To: Vasant Hegde <vasant.hegde@amd.com>,
 Tom Lendacky <thomas.lendacky@amd.com>, seanjc@google.com,
 pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 john.allen@amd.com, herbert@gondor.apana.org.au, davem@davemloft.net,
 joro@8bytes.org, suravee.suthikulpanit@amd.com, will@kernel.org,
 robin.murphy@arm.com
Cc: michael.roth@amd.com, dionnaglaze@google.com, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
 linux-coco@lists.linux.dev, iommu@lists.linux.dev
References: <cover.1737505394.git.ashish.kalra@amd.com>
 <0b74c3fce90ea464621c0be1dbf681bf46f1aadd.1737505394.git.ashish.kalra@amd.com>
 <c310e42d-d8a8-4ca0-f308-e5bb4e978002@amd.com>
 <5df43bd9-e154-4227-9202-bd72b794fdfb@amd.com>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <5df43bd9-e154-4227-9202-bd72b794fdfb@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA1P222CA0190.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:3c4::27) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|SN7PR12MB7812:EE_
X-MS-Office365-Filtering-Correlation-Id: 0917e301-2f23-4ac8-65d2-08dd3cc0a355
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZEpsZEt1WnA0cDVJVmtDT3RMWnorQlZmUmJNOGNmbG1aOGxJei9STlFmTlBQ?=
 =?utf-8?B?Ky8xM0EvcUZpa0pZTTR3bnN0clVnM3NWekdaWTVhZWovVlNibXVuYktQbk5q?=
 =?utf-8?B?aGs0c2FHaytTMEZ5S3RKK255L3NKMG9wSmxvRjBOSFlpS29WanV2TUh0NnhF?=
 =?utf-8?B?S0YyN1dyVW1xQXA5NUJuMzVXdjhUd2dCcHJMRThQU2VnTDJFd3JJNUVrdUx5?=
 =?utf-8?B?c1JlYXJWVmduUGFIcTR0ZmhoalkxVnk5bGFYQmtWdGNjOHlvZzJEWW9PaHAx?=
 =?utf-8?B?ZVhRQjFmQ0NpbFZKVkJrcjFQaDhvVUtlZUZkSmI4MTBrbUgyQkZ6b3ZWQVRR?=
 =?utf-8?B?YUpWOG5hUWlDbHVuYTY4WjYvRkswTGZIZGlzMDZneHd6UG8vMWdUbDlIR3Bi?=
 =?utf-8?B?STM2bkdEYWd6TVZrWmU2aW52SFF5TWR2SHVmR2VJSzhSMFdwNHlyZVhQbzNE?=
 =?utf-8?B?MGpJRWR6dFZFQ2ZvbStBbFBhUDNHTS9ENmY4S3pZSTM0V1R3WkZPVVM3cStu?=
 =?utf-8?B?TFFjbjgxRG1oN1VrRnNPUzhUbVJ0K1k3VUJJMWxQZ3hTU3p2cDIva29PbVln?=
 =?utf-8?B?T3RPQlVpbHBxREFJUTJwU1FJblJOc2NDcVBTWEc4aUF1Q3dKU3A2MmlSWXF6?=
 =?utf-8?B?U2RUU0tmWFVQR1ZnYWM5aThLdDhHQzNVZnhJRUpvQTVaY1ArTVlOa0hteFcx?=
 =?utf-8?B?Rjc2VlFZZXd6SVRLa050NTdDNlhzaG5yd2d5bFcwQUlRSUxicWlGdGFjTFFo?=
 =?utf-8?B?QW9lM2tvTzVvbk8zUVlVMUtnVG5pZXF5TWFCb3lTRFNSZHpOVUg5NTA2bTdy?=
 =?utf-8?B?THdJRmVaR3hLellkTVJEN0FQcld0TDhXdXY2L1JiTE5WeHZUZ3Z4NjVEdU5r?=
 =?utf-8?B?SE0wWnVCQ0hwRFpjR0c5ODRtN0N2bFl0MXZmMFM3dkk0dlZzaHRaRUNtMlZj?=
 =?utf-8?B?YjROZENrdFpPZzJPVGlTdU1Pdk4vVEd5MlhUNkxXTkZoV2w1dWpmNHNhallP?=
 =?utf-8?B?MVgxcER3TklOWHVJeDhZU1Bab1BZczNKdDJWRzBHaVJmVkxBS29JdmVVZWV2?=
 =?utf-8?B?am5xWXlzSXlBc2I0TG1xbnJHNDFFUmVQM2dDYUJuZUc0cW5xZ1MxTlZuemVY?=
 =?utf-8?B?S3pKdDRmU0M1ZTBvdnpCUmQ5K3IyVk50MnVSWDI2OTlYRjB5L2NOcEM5OU9W?=
 =?utf-8?B?UlRrVGl3WWo5OVpYSS9yVkE4Lzd2MmM3RDBKbGl3cnQzNmpOQXJlaEorZGF5?=
 =?utf-8?B?c3VXMll0VGx2TGRRVEtVTjkvNk96Rmk4LzNFM0hkQ1BjcEhxUnNBZitMM2pM?=
 =?utf-8?B?T1BqTklQR1JndE1WZTdlQlk5UGlnVmhxZDhLNkdSNVNLTDVUangrQU0vMWRV?=
 =?utf-8?B?eUlOaS8vNkRldVQxTDhaTnE1QnlEWW05QkVFQ1JlT1JzOVVIM21BOFc3cjIr?=
 =?utf-8?B?d253cnlieDNkaEg1QzZnNXJjbnIzN1kzd21PbHVMQmh4bjV4S2dOeUlVYlNN?=
 =?utf-8?B?dWhRSmdhTTE3aE9LbmZLdGg0YVB2MVhPRHFCeFlKYjRGck84Q0xNYWVPWWhX?=
 =?utf-8?B?Z1U2LzhlRjNBRE1kb0hjejhub3lyR25pN3libUlNeFRoZGFQdEpoZGE3VDM0?=
 =?utf-8?B?TExSdURpRVoxWS8vb1VnWW5INjE4K1J5Q2orQ1IwMFl2dXFka1E5MGRJa0xr?=
 =?utf-8?B?a2RYWUVGbkJPZTljZ3NMMFUwM29MRkYxSU5kTUhsZENMUkRqRkRCTE9XUXli?=
 =?utf-8?B?Uk1RL1hNUmg0WWM0YVQ5c1J2YUNSN2lIVnJKbVl4QnFHdkRlT2lxWWVLVzY2?=
 =?utf-8?B?clhpd3N3dVpWYk40VGQ0SjhCaU5SQlB3TG9PU0hkSTFKZ0pHWGQ2SXpMaUp1?=
 =?utf-8?B?OE11WDlSdEJJanNmVjBSOUNNaFBUUTE0Tkt2UW1iVHgyVTRuQS9CSWZMNW51?=
 =?utf-8?Q?3VoUwzPnI7M=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?d1dHNGlMNlByWWhRV3ZIOWpIZCt1aHp0YlpSWVB5cVBVWnQ1TS94Z1c3T2F4?=
 =?utf-8?B?dUFmRGpxQjdTTEc1aWdBWEdsTnozY3kvVzA2cHUyR2t2N1lpMlM3VjVVNytX?=
 =?utf-8?B?b1F5YW9KdkR2YjRkQXdlMG1OeXl0U25FZkxyS2VFZnR0bFhadzU1ZkJpc3c1?=
 =?utf-8?B?bmh6S2NYNlpDNjZNU1Vaa0J0WTIwN0R0Qmc0TUNyZjlkVklob1lPcXY3c2Z2?=
 =?utf-8?B?b1M3dGhnOUVJY3VvTW9mY0hGd0YyN1ZZNjRSR0NYMkNReklYM0w1OVVpQVhS?=
 =?utf-8?B?OVpyVlJUbnhmWHk2VE5wU0xoY1IyTHNEbTE1eGg2QWFJVS84UWxWYTFzSzRM?=
 =?utf-8?B?QW5vUHZNa3NtRmJWendJcEZIMG90d2dFcndGMi9zUHQ3ZUJmcUE5QzMxOE9E?=
 =?utf-8?B?emZ0VzBpTkpjQ3RvREpQcnpqeE54a3NQcVY2UjdMZHkwVzhQWFNnSFRHdG15?=
 =?utf-8?B?UG91OTJsSWJUSDgxR0dwU0dGM0N5Zk83U1pQdGNwaXhWV1lEQ2xGdEJMSW0v?=
 =?utf-8?B?TThzMmhaM2dxY0FkWklBbFZrWUZMMGl3bzRHQjdOamR4MkViZkFTWjcwOTBP?=
 =?utf-8?B?T1Y2RDF4M05FMUtmTVhnU083bFdia1l3OGl4UHhjeU5kOTJtWGtDNnZyRktE?=
 =?utf-8?B?SXZ4b2QxQ0E0OUVuNkYyS0tBT1ZKWk0rZFBtREhOMEhkV0E4QThzYzNnMkVC?=
 =?utf-8?B?d2lhZkw5S0dMb1RoY2hkb2xzeTk1cnBDRE1HeFZkb2lPZlVVSEpCSGdiU2lE?=
 =?utf-8?B?UDI4VnM5ZUZ3R1hmYythSkczZ3R5dmdTaVkvd3lILy9oL3U0cnpNd2NtT24v?=
 =?utf-8?B?RnVkR2hId0d4QWhUQ2ZjV1loT042ME4vWmo1SVZtTE5UWlFFd1BjWXhobTBU?=
 =?utf-8?B?L3RweTBXWWhOV2M1SVcvQk9tUmt2c0QxMTBjZ0VyK3N2Q0FrZWpOWE1XUjUx?=
 =?utf-8?B?VFFCcWVWdHVFVUUvek5kS2E3S0tRMm9hRjRORnhNMUZPTGpqNFlCNm1rbFhi?=
 =?utf-8?B?N2c3aDc3V2w0Y2tJWGh1QU9NaEROcWY4ZTMwcUp6OUF0RFF2dnZkUWEvY0ti?=
 =?utf-8?B?d01RbVZpR1dwSGl0a0RHWVh3eVR4QTcrY2RoUHBhcytVLzgwMkUybU5uZDRT?=
 =?utf-8?B?MjNOcWwyR3l1R2V3TmNFTFFDcTAwYW51ZHdUNEsxVnhWRytSK2s0eENnenp2?=
 =?utf-8?B?eHRoV0hFaHR3cUJrWHg4VjlBNDRNdW83aFo4T0dVajJ1TERmbnBOd3NUKzly?=
 =?utf-8?B?Wit2RHRHeVUrU3gwdjNrTndKRUJYZlNDZkxTVjNjNjBoQXRMTVVXcHBNNHJx?=
 =?utf-8?B?YlRXRzR1b2ExSSt5UTcwaWUrZTFhWm5leW95SHhJeWdyNnE5MkU4ZFV3WU5y?=
 =?utf-8?B?ZFBNYUc5aEVFS2lseHJFN0ZReVJRNkJHMnFXRmp0TjlmUGx1VjBtUEJuZ29s?=
 =?utf-8?B?ZjJVSkVNWFRBOWtGbFVlS3dyZGZFWWdlTEtRL3JYK1VIRnpNclRVc2xSWHYr?=
 =?utf-8?B?MEIyLysxcFhhdllhc0VWRDQ2eXptK0lJYi9XOUtaOUJpMjZlK2Iwcm9Ram5N?=
 =?utf-8?B?UksrQlg4NmhaVDJ3aHJXM1pjOWdaTGFQa0NtOXNUL2diRGdUUzlIcDE3T0M4?=
 =?utf-8?B?ekkwMDliLzVXNWgwR0hJL2Q1Y3RpSDhLdFczTE44YTdxaHRCcXlDMEtzaEdE?=
 =?utf-8?B?cnMvSklNYzdHZFpOemZoRFRGTFplUUlYNkkzZFR2TWlTcE5GZExDbXpCak5U?=
 =?utf-8?B?TjRmT3doczNuai8rZmhPV0pRSGZMRW11KzhaOVdiVk5neDRUU05NYy9STTZL?=
 =?utf-8?B?MTROV1V1VFNHTTd4M3RZYll0ZDh1cEd1MVIwYWdGcmFMdW5nUDExeG01LzVW?=
 =?utf-8?B?RzBrSHV1ZFlRekY2bWhpMHZtYWJBQ05lTGoxeEovUmZLTEMwY1FMVW9tSFJM?=
 =?utf-8?B?Mm1Nb2hYMzluN1NaUHZzT0pGU1lncVZub2c3bXJGTDB0RmROUURCeXpxMjdF?=
 =?utf-8?B?VWdrZWQwc3hvamI1cmRoamt5clVHdGJrTTBOcHNhWWU2bGt3R1ZDTkZabkNv?=
 =?utf-8?B?a2pUMUdWUUZ5em5tQnFJVjFZcllTSmZheE1WaG1sbXRwaHJxUnEzeW9ESUVa?=
 =?utf-8?Q?hJuKWQqfQ55rum9u7PKnwM0vr?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0917e301-2f23-4ac8-65d2-08dd3cc0a355
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2025 21:47:03.0160
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qneR0fCI4SCA/h0T/KNbIGXNLer1GvWJd8csTgDkqZCSaa3mlKBhiVtyFTXtDaYA/eoZv6w7PYE8oK8jJtoofA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7812

Hello All,

On 1/22/2025 11:07 AM, Vasant Hegde wrote:
> Hi Tom,
> 
> 
> On 1/22/2025 8:52 PM, Tom Lendacky wrote:
>> On 1/21/25 19:00, Ashish Kalra wrote:
>>> From: Vasant Hegde <vasant.hegde@amd.com>
>>>
>>> iommu_snp_enable() checks for IOMMU feature support and page table
>>> compatibility. Ideally this check should be done before enabling
>>> IOMMUs. Currently its done after enabling IOMMUs. Also its causes
>>
>> Why should it be done before enabling the IOMMUs? In other words, at
>> some more detail here.
> 
> Sure. Basically IOMMU enable stage checks for SNP support. I will update it.
> 
>>
>>> issue if kvm_amd is builtin.
>>>
>>> Hence move SNP enable check before enabling IOMMUs.
>>>
>>> Fixes: 04d65a9dbb33 ("iommu/amd: Don't rely on external callers to enable IOMMU SNP support")
>>> Cc: Ashish Kalra <ashish.kalra@amd.com>
>>> Signed-off-by: Vasant Hegde <vasant.hegde@amd.com>
>>
>> Ashish, as the submitter, this requires your Signed-off-by:.
>>
>>> ---
>>>  drivers/iommu/amd/init.c | 3 ++-
>>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
>>> index c5cd92edada0..419a0bc8eeea 100644
>>> --- a/drivers/iommu/amd/init.c
>>> +++ b/drivers/iommu/amd/init.c
>>> @@ -3256,13 +3256,14 @@ static int __init state_next(void)
>>>  		}
>>>  		break;
>>>  	case IOMMU_ACPI_FINISHED:
>>> +		/* SNP enable has to be called after early_amd_iommu_init() */
>>
>> This comment doesn't really explain anything, so I think it should
>> either be improved or just remove it.
> 
> Sure. I will remove it.

We have hit a blocker issue with this patch. 

With discussions with the AMD IOMMU team, here is the AMD IOMMU initialization flow:

IOMMU initialization happens in various stages.

1) Detect IOMMU Presence
   start_kernel() -> mm_core_init() -> mem_init() -> pci_iommu_alloc() -> amd_iommu_detect()
   At this stage memory subsystem is not initialized completely. So we just detect the IOMMU presence.

2) Interrupt Remapping
   During APIC init it checks for IOMMU interrupt remapping. At this stage, we initialize the IOMMU and
   enable the IOMMU.
   start_kernel() -> x86_late_time_init() -> apic_intr_mode_init() -> x86_64_probe_apic() -> 
		enable_IR_x2apic() -> irq_remapping_prepare() -> amd_iommu_prepare()

3) PCI init
   This is done using rootfs_initcall(pci_iommu_init);
   pci_iommu_init() -> amd_iommu_init()
   At this stage we enable the IOMMU interrupt, probe device etc. IOMMU is ready to use.

IOMMU SNP check
  Core IOMMU subsystem init is done during iommu_subsys_init() via subsys_initcall.
  This function does change the DMA mode depending on kernel config.
  Hence, SNP check should be done after subsys_initcall. That's why its done currently during IOMMU PCI init (IOMMU_PCI_INIT stage).
  And for that reason snp_rmptable_init() is currently invoked via device_initcall().
 
The summary is that we cannot move snp_rmptable_init() to subsys_initcall as core IOMMU subsystem gets initialized via subsys_initcall.

As discussed internally, we have 2 possible options to fix this: 

1 ) Similar to calling sp_mod_init() to explicitly initialize the PSP driver, we call snp_rmptable_init() from KVM_AMD if it's built-in. 
    So that we don't need changes to IOMMU driver ... as IOMMU driver does SNP check as part of rootfs_initcall()  (amd_iommu_init())
 
2) Rework it such that  
   Core IOMMU (iommu_subsys_init()) initialized (as currently) via subsys_initcall
   FIX: 
   And then we add a fix to invoke snp_rmptable_init() via a subsys_initcall_sync() (instead of device_initcall()).
   (again as core IOMMU subsystem init is called by subsys_initcall()) 
   --> snp_rmptable_init() will additionally need to call iommu_snp_enable() to check and enable SNP support on the IOMMU.

Issues with option (1): 

Here, snp_rmptable_init() is still invoked via device_initcall() for normal module loading case and i remember Sean had concerns of enabling
host SNP at device_initcall level generally as it is too late, though looking at AMD IOMMU driver initialization flow, i don't think there is
much of a choice here.

One other possibility is moving snp_rmptable_init() call to KVM initialization, but that has issues with PSP driver loading and
initializing before KVM (with module loading case) and that will cause PSP's SEV/SNP init to fail as SNP is not enabled yet.
 
But again that will work when SEV/SNP init will move to KVM module load time where PSP module will be simply be loaded and initialized
before KVM, but will not attempt to do SEV/SNP init.
 
This approach is quite fragile and will need to be tested and needs to work with multiple scenarios and cases as explained above, there is
a good chance of this breaking something.

And that's why option (2) is preferred. 

Issues with option (2): 

How to call iommu_snp_enable() from snp_rmptable_init() ?

We probably can't call iommu_snp_enable() explicitly from snp_rmptable_init() as i remember the last time we proposed this, it was rejected as
maintainers were not in favor of core kernel code calling driver functions, though the AMD IOMMU driver is always built-in ?

Therefore, probably the approach will be something like AMD_IOMMU driver registering some kind of callback interface and that callback is 
invoked via snp_rmptable_init() to check and enable SNP support on the IOMMU. 

Boris, it will be nice to have your feedback/thoughts on this approach/option? 

Looking fwd. to more feedback/thoughts/comments on the above.

Thanks,
Ashish
 

