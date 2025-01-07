Return-Path: <kvm+bounces-34692-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 022DBA046EA
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2025 17:45:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 860BC1664A6
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2025 16:45:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3FF71F76AF;
	Tue,  7 Jan 2025 16:43:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="k85sfnsI"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2076.outbound.protection.outlook.com [40.107.220.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD0811F4739;
	Tue,  7 Jan 2025 16:43:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736268188; cv=fail; b=aWXxfAt1PyGyu0yx/Q+y6RJUyY4qiouoaBKRVdYpk5iWmb4YSqPmS/tvULYVBKLy5tcuAkJDpqzdhTz3+pzKIMJ3OVPnb9Q8BYCz7qOYEC1ZVOlFfnSPFANj3A/AVlTuWFINrPYTai1G6Kl6uMIegFl6fQAUtyEKGaN+TE8aEmE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736268188; c=relaxed/simple;
	bh=L8Qi3YGP9NOMRyQcT4J8w5AqA/JzoTLphDRPvv4XDW0=;
	h=Message-ID:Date:To:Cc:References:From:Subject:In-Reply-To:
	 Content-Type:MIME-Version; b=RGttu3ZIh8DR/IoNXiA2hhVfEPiXibVPKkna1PjhuyKHVXFz8OvKJycROAlnt2Xjv2oRLbJGpcRKuTLFc/GNdhhQJPC7yPeYXTa2FRpUzylPCxFmknXNVODBxa1NkaUbRLnyT6fdxRWPQvoONynDMXPrZZnhKsmU4ypALi8hu8g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=k85sfnsI; arc=fail smtp.client-ip=40.107.220.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ccoTN9tRHe4NDYunYxjCD1W6DfgYuYWOwaFGel9Miq2FWsKnVJhoTA7PsFH9Ytq/I8rBjcWqjc8fDD5AXjAM9XTLvml4+qodPqwr9baacXQhtiegkquiEbykJI3emL2o040jqWxEDdGzLIL38LbW2t4XbWyfDQ6EH3cvGfJlWsLdcwVtAGP0sfJoqordn5kYzHESkPYnvFeBFwk8Lqli5mgF73cRp1bnFgQRG+OzgV79bRiultz/knIf10OKZCDapL+pfDNB7UG1iX2SYBuj8opPeMrULuNIfs+FOuPY1hLUGGjgPjsQ3Yv+H199l8rClgCO8TYUSVB68ppOA2nrFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vBx/x9FuMWMGztHI6FMrYfQlI3suypVfeYddQib1H6c=;
 b=IDFCmXcCPKtJnx5+AjXSHgc4ULHeoCsiOCSLys688mDlD0DZnKglRLDf1wXr7QP2/6JMkF7ZMfPVIAq/awH56/0JAgf7Q7b1OIYnIFhdT5agdtTcjlMFnd6hprraOvP5yQzA+Tmqxdqy6bwLiF+OsqvoI99TUa55cwyezupapNEOUqjbJHc0UP76hr9kg+2afGWa5lUGR0pyFMf5uSUSa8pN6odAAEf4gNNJk0538xNfijlF4HttYuhTpgmIgNOXkfy7TALUxIMUm/DMHFCLu5KGN4KFjRWg/nWxwcbAjDyoJqw2xAQT1wIo6e2O5qfkdfmpoZx4fQpLJ9rLCI+c0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vBx/x9FuMWMGztHI6FMrYfQlI3suypVfeYddQib1H6c=;
 b=k85sfnsIAUnxaXaw1BdMZd4DhrXnOlGUCO8045UJBpfyPKUxa8ivQEJ6Mo0DEZt8wZ/B9bw7zdnGvmUMcMi1MvjYH/m9f6Q6i89ibDVHGaHVvxsTf67ptdhhHVaJ4jdVkPc5B+nGcBC1/DCvIv+UVsPCylvaPOYqJ9ZWQ/s8kgQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by SA1PR12MB9247.namprd12.prod.outlook.com (2603:10b6:806:3af::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.16; Tue, 7 Jan
 2025 16:42:58 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%7]) with mapi id 15.20.8335.010; Tue, 7 Jan 2025
 16:42:58 +0000
Message-ID: <6241f868-98ee-592b-9475-7e6cec09d977@amd.com>
Date: Tue, 7 Jan 2025 10:42:55 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Content-Language: en-US
To: Ashish Kalra <Ashish.Kalra@amd.com>, seanjc@google.com,
 pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 john.allen@amd.com, herbert@gondor.apana.org.au, davem@davemloft.net
Cc: michael.roth@amd.com, dionnaglaze@google.com, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
 linux-coco@lists.linux.dev
References: <cover.1735931639.git.ashish.kalra@amd.com>
 <14f97f58d6150c6784909261db7f9a05d8d32566.1735931639.git.ashish.kalra@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH v3 6/7] KVM: SVM: Add support to initialize SEV/SNP
 functionality in KVM
In-Reply-To: <14f97f58d6150c6784909261db7f9a05d8d32566.1735931639.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN4PR0501CA0026.namprd05.prod.outlook.com
 (2603:10b6:803:40::39) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|SA1PR12MB9247:EE_
X-MS-Office365-Filtering-Correlation-Id: 087f8c3f-397f-48b6-417d-08dd2f3a5790
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SHNTMmdLc2NyTC9pYkdtckc5bGlvTHZwdWovbWhEMG1OZzEyRW1uQUJOSVdu?=
 =?utf-8?B?TEJKL0Y4UEp5ZktWWnY3K2ZFTVg1NkhqYnQrMmNOSExuNkk5MFloZnlKcGYy?=
 =?utf-8?B?NVNLZ2labFRmdTBqVXl0UlkvUHRzNG1UaXExbUhqTkxaTHFKa3FVTWxLbUdp?=
 =?utf-8?B?dEdRS0NBOVBLL0VidGJIM1NqM2cyU3YyQ1R6SEE4S1dybW5CUHh3ZGhiK0xh?=
 =?utf-8?B?dDhLTTkzNkF4Qy90cmYxM0RUelUwZFVNQWlIVnZmakZjVmp1WmErZFF6WE1t?=
 =?utf-8?B?Qm1zNTFISHRHN3E5c2dWaGt1NE43UVZXYzJ4ekV3VTFTdzlRamlIOVNXNXZm?=
 =?utf-8?B?Tm41UFRGVlJ3YTBleUV3WnM4elNVT1hld1RBL2pxd2dTYXRJSTY2WVdheFhE?=
 =?utf-8?B?bVZpYko4QVhJUWQ3QlAwVk9QL1pWa2xiOUtCbTRFeXBxMTJwZVN4NzdxYUtP?=
 =?utf-8?B?N0h1K1N0SEdYd1FBaXZKNDVrWVBnL09oRzdBWWN2c0p6QUYyUitSL3FrT0xF?=
 =?utf-8?B?OGg5ejhVMGI0YmVsTGczOXJzNXNScyt1bkU4ZjEwbXQyOW90WnJhTndvZXBG?=
 =?utf-8?B?T01JY010dUI2bEtueFhHaVJKYXRFSHUzWHFoK25MM01LQ2Q4TldMN1pyNzB1?=
 =?utf-8?B?ZzQ0dEFqR1cxY3lrR1FvSndMR0tEYnFoTHdHUjQxUm1WR3pJdzFQYmYwMGtz?=
 =?utf-8?B?a0xOUHhDZlYzSURLOGVlZUErd001ZnJyM1QxajZGL0JVL2xrWFp5Ni9VL0oy?=
 =?utf-8?B?Tmg0SnR4NFM3NURacHMwYURuSTBKeHh5TzJiZVpCMmwrRXMvK2dLUVdzN0NG?=
 =?utf-8?B?ekdaYVFpemhjaGtOaDdxdHg4RzBTTTRsNk1vWmc3anRZV1NRSkpRYUliTytM?=
 =?utf-8?B?SVFGb05oK3haK29EWm9OYitmc2pFbE5TcmZ6YytCQkdkbFRLSlk3ZnlSem9w?=
 =?utf-8?B?TmQ3VVMyVzUxVmJqdGFJZnphenA3dTRYL2JadnEyUll3ZEtFcklmekI4Vks4?=
 =?utf-8?B?TWNxaWZaVkZQaUdCT2Y1SjhrQjhMUDRTTHVOMnhwVit0dU9NZzVJWnIzN2Yx?=
 =?utf-8?B?MGxwNXJycHFBb1FjUWlLVEpkY0wwZTB0aWV6blp3TXFLa3JjaytsYVJmQUxD?=
 =?utf-8?B?Y3M3T1RoVm9pelhjVEJXNjEzWGtLa3cyVjJnQk9jaUZBam5DZWROVXFsaHhx?=
 =?utf-8?B?U3FMNVFpYlRtbFVreVZlN1FWSThVanY2MDVFQTVKUWEzdDNaYWt2YlJna2Jz?=
 =?utf-8?B?eFlXRkt4U2J6N3daOHRtaU53eXBPYVFZaTBNcHdnOW5TelhTdVhNM0hIZG5V?=
 =?utf-8?B?bjFNcVBOTHFLK2g5M0tEa2FtbWFaMFovbC9mY29obEIxeVBYcU9HSUIzZlpo?=
 =?utf-8?B?VWJzL09sMDJHL1creERFMjZWMlNLb2UvVi9GcGlJTkNoVTRVdGh6aEtxNFhT?=
 =?utf-8?B?bjVhRGhXY1hxM01ZaVdGR1BYVU1rbjJqeHBER2llV3FHQkUvUFJONkhhRitq?=
 =?utf-8?B?ZEtSTjY0N0VjTlB3WmxXT2Jnd0FIWkVINmxaUVlRYU9iZG5lQVZNajEydVMz?=
 =?utf-8?B?eDhtekhrUzREKzQ0Q0xLcUZzNXRkbXkva0IvT3BCWE5QM2dpaVlNbG44OFBx?=
 =?utf-8?B?ck9ONy9FVGp3VFNkR1ZjMEZhZFBhNzRSLzk3Szh4S05hUVJNTGZsVG5qVGFH?=
 =?utf-8?B?V21IZjJVRnZNb3MzY0xjNFY0QXY4RFZsOFF4eHlhdnhqZ01SWitLRXZ5bkpE?=
 =?utf-8?B?UkNrb0xBTGlDNkVNYWF2WVpmUUptaHAyU2w5c2ZQZFZKU1k0cm9RajBGeFR3?=
 =?utf-8?B?bkU1ZkxEakhIVzBsNXZhVWZKeG9ZYWtydTd3MkNsOTB1elhpYmRvZzllQlR2?=
 =?utf-8?B?a20rZEgyaDF3RklEM05hc0cyNmVVWGZpZHhqalFQUUpIdk9lZHNOUnhYVWw1?=
 =?utf-8?Q?xnbHbyz/Arw=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?K3JHa1JadTMrRWcwUk5EUnVjWFVQanlhL21qNGlNNFRSM245YmFtODgrSUls?=
 =?utf-8?B?TUErdngyN3h4TFJSd1c4OHdvckhVSUJqbVEyTkNMSDBVT21LRGdkRWVOd095?=
 =?utf-8?B?aHN1Yi9oOUdhL1hRVHFkazh1NmtBQjZaY2xkRTgyVnBjalg0THcxUURES3o5?=
 =?utf-8?B?SStNODZEc29ieG9VdTcxM3hSVzVUOC9IMFgxTjlwQXJVYkZ1SlZBZjloWnZF?=
 =?utf-8?B?UXVYSWtUMzI3Y2hId0xlMStwazNRWXR6b2lXejVPTVFFYzVwTS9ReDRzUXdz?=
 =?utf-8?B?eVZyVlJqaHdPRTBJWTd6d2lTNXYrZHEreTM5eEIwRGZCRzZwWGdjNXM0M0sx?=
 =?utf-8?B?UisvVENNMENzeTBSMnprdkthTFJaMjkrSzN5OUlKMnNwT1RoTEl2RHhxbFNx?=
 =?utf-8?B?bTV6cnJnd0wvRGJ5eTBVSWRDNDF5U2lWV0JyUWJJZDdoczQxL3ZDSUxoY2pp?=
 =?utf-8?B?L3JQYm5xd0dMT0tUYkFsbm9BM04waHJ0b3VWRWhrNFpFQ0s3aURDaEtMR09x?=
 =?utf-8?B?cVNnT0ZCTU8yenQ3bHlEVStyaXU2eXdsTG5NRzhHVnVBUHNTUWZPRWJEVXNv?=
 =?utf-8?B?dVM0K1NINGlPdkxULzJ3MDRBcGovWWJ0SitaVGJPcGl4cU0xWmRjR1p0UWlI?=
 =?utf-8?B?TG5nM1pRNFRMVG5zaGY5bzVHRWhVMDNKazI5djFNT01Sa0JzUzlEdHU5NnpU?=
 =?utf-8?B?N3pkZ1BUWlZzTSs1Ymtkc0VYenRFeTFDTDZLTDd4RTBpUHhpcU1tYVo2NkhV?=
 =?utf-8?B?THJEdUd4d05VVENyTDcwZ1VSREdOQVI1OXNPa1YzUk1HazVEOFdPSzBpL2ZU?=
 =?utf-8?B?SjRySXlCSXlSM2xWSExGOWFYbjVEQlZQaFJoNU9yZXhPWjBGdTZJWkRIdkZv?=
 =?utf-8?B?c082NU4rZVBiTjJyR3luaEl5UFE2K2ZCREtBa0I1V0NXZjRTbE5OMktibElx?=
 =?utf-8?B?TW5iU1pQTXpXQ1h2Ly9iZ0R5b1NidThEa0M0UkFYNTZHMGEyQnU4WWU2dFVj?=
 =?utf-8?B?aDNXamxIMGVZUUN0dnVGQWh2NTArMlFZVXNZdUJ6Wk5Na2Y0T1NTQUt5OVgw?=
 =?utf-8?B?b1N1N1crUjM5RGozbGlwcFRqNVUwTXV2NGsveG9CL3RxMEcrdkRIb2Q0S2kz?=
 =?utf-8?B?QXd4S1p0UDh0WEtSdlgxWFR4RUNuZC9rK3hwbUxYNG1qdnc5akUzRDV4d1FS?=
 =?utf-8?B?eXh1M21HblBnV1hzM1pqT003QnJmQm5sR0dCb1d6Z0lEZUxZU2JwSUg1M2tR?=
 =?utf-8?B?VXQzUGxkUlg2U1NKbURYdFJpUWc1cWlmNjMxZUdqcWtYV3grNzJOQU94VDJI?=
 =?utf-8?B?bG1yNXFWSmluMFRidVNDS05RcUpyYS9HbUg3MndqNHJ1YS9ISmVMTUNtYVVi?=
 =?utf-8?B?K3NvQXVONEhZenpWUFpjUFdUYW5ZZVkvMk5sSTUxVi9GMVFvVEU4TDhFUmhn?=
 =?utf-8?B?RVNnZE4rVXFVMmZWQ0ovdTV1SzlLeU1NRG5lWERDSEVYTzNublJmSjJpbHF5?=
 =?utf-8?B?U3FZSWRPeVZyNkNvRjJqby9tb3Y3Um5FclVwNmRESXpzMkVpbHN1S3lBL2lU?=
 =?utf-8?B?L1dJb1lrSEtRcDd3WWp4ZEltZHVnNjhLb1YzclFYN2pDbmc5Q3JKc0p6c0Fm?=
 =?utf-8?B?VExVV2NORE1NWXBvYWx4aXg4NzAzZnJuNGJESmtmSW1JNWRvRUR5SGZFK3Np?=
 =?utf-8?B?UFJVYnZ6Q2lucGZhYjFydzJ3SkZmNVQ3MXZxU0tiSmdBOFpIQUtGM2lLbW1M?=
 =?utf-8?B?SGdaN2xEZ0plNFRUOEc3dVNKL2pMREIvM1l1SFUxcDVUZ2VERzRrSEk2YzVk?=
 =?utf-8?B?cXJDOU8wbUN4Zkp6ckt6Z1Y2b2YySFNtbjFqQTZzWVhBcHpUdVVVcnRTWlE5?=
 =?utf-8?B?c01KMm1FdVBiZnpuUjNLRlJxdjFvYUc2V1lQVk5WTWtucEMvTnJwMDl2MFEr?=
 =?utf-8?B?OCtkY2J0bHhXeXg2WnFCZDN2NXdTUm9DR3JkUkFndmNydTA3d1J6QmRPV0xM?=
 =?utf-8?B?ajFKK0ZJRHRjeXlTWXp2S1N0SE92RHNvMW96S1RtU0d0WjdUR2pGSnlsYUcy?=
 =?utf-8?B?NUlMa1M3MG9YUHVRSzBaeEM0UWVqM3dKNnQwTFpmWnNsaTJZNzhadkM4Rk0r?=
 =?utf-8?Q?8XN6Q1YfjpFX7V6OvuqEVaVLG?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 087f8c3f-397f-48b6-417d-08dd2f3a5790
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2025 16:42:58.2319
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sxcDkD8Y2iGFHuCaGn/8UO0q5is5BjQ/Hj5vGddZ9qSIlj9QBXiREDBmSxAkPCw0QLFt/C32ML6Y9BEXXXQY8A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB9247

On 1/3/25 14:01, Ashish Kalra wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> Remove platform initialization of SEV/SNP from PSP driver probe time and

Actually, you're not removing it, yet...

> move it to KVM module load time so that KVM can do SEV/SNP platform
> initialization explicitly if it actually wants to use SEV/SNP
> functionality.
> 
> With this patch, KVM will explicitly call into the PSP driver at load time
> to initialize SEV/SNP by default but this behavior can be altered with KVM
> module parameters to not do SEV/SNP platform initialization at module load
> time if required. Additionally SEV/SNP platform shutdown is invoked during
> KVM module unload time.
> 
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---
>  arch/x86/kvm/svm/sev.c | 15 ++++++++++++++-
>  1 file changed, 14 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 943bd074a5d3..0dc8294582c6 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -444,7 +444,6 @@ static int __sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp,
>  	if (ret)
>  		goto e_no_asid;
>  
> -	init_args.probe = false;
>  	ret = sev_platform_init(&init_args);
>  	if (ret)
>  		goto e_free;
> @@ -2953,6 +2952,7 @@ void __init sev_set_cpu_caps(void)
>  void __init sev_hardware_setup(void)
>  {
>  	unsigned int eax, ebx, ecx, edx, sev_asid_count, sev_es_asid_count;
> +	struct sev_platform_init_args init_args = {0};

Will this cause issues if KVM is built-in and INIT_EX is being used
(init_ex_path ccp parameter)? The probe parameter is used for
initialization done before the filesystem is available.

Thanks,
Tom

>  	bool sev_snp_supported = false;
>  	bool sev_es_supported = false;
>  	bool sev_supported = false;
> @@ -3069,6 +3069,16 @@ void __init sev_hardware_setup(void)
>  	sev_supported_vmsa_features = 0;
>  	if (sev_es_debug_swap_enabled)
>  		sev_supported_vmsa_features |= SVM_SEV_FEAT_DEBUG_SWAP;
> +
> +	if (!sev_enabled)
> +		return;
> +
> +	/*
> +	 * NOTE: Always do SNP INIT regardless of sev_snp_supported
> +	 * as SNP INIT has to be done to launch legacy SEV/SEV-ES
> +	 * VMs in case SNP is enabled system-wide.
> +	 */
> +	sev_platform_init(&init_args);
>  }
>  
>  void sev_hardware_unsetup(void)
> @@ -3084,6 +3094,9 @@ void sev_hardware_unsetup(void)
>  
>  	misc_cg_set_capacity(MISC_CG_RES_SEV, 0);
>  	misc_cg_set_capacity(MISC_CG_RES_SEV_ES, 0);
> +
> +	/* Do SEV and SNP Shutdown */
> +	sev_platform_shutdown();
>  }
>  
>  int sev_cpu_init(struct svm_cpu_data *sd)

