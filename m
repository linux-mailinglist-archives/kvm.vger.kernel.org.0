Return-Path: <kvm+bounces-48302-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CA657ACC8AA
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 16:04:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 454343A6F29
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 14:03:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88C1123956E;
	Tue,  3 Jun 2025 14:04:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="qQF5T6xw"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2048.outbound.protection.outlook.com [40.107.100.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CEFA238D2B;
	Tue,  3 Jun 2025 14:04:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748959443; cv=fail; b=aP6xS+O1myWBCEr3NcGR1ZXKEIXNj5GdXoKtpxZjAGNo82aDFWxSJmxinhAPfLdWDBrTcpZKPO/Q8Hh3ADfCvKlicPnTCUj4WA5w+mIziQoEgQi8XLoqGbhwDTVnWtEpnUqh3GUoZzvndqmSgr9yOTXTCfwcwUNSAR7+4aC4+2o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748959443; c=relaxed/simple;
	bh=9TvR8XqR0yO77hbxk5PiWYsrwnozVdpvbBZNqjKr0fw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=GLkY5U/hOtlizVV9GGttmoEBowFdKikZ52Md82FrtEA18wsK8Fm1WLBtVcuoJX81XCmdzbCoL9Zs4s8lZ48wSEGyg9r83YvN1P6SOVSyf95C8PurIrvFQw2vOgNWjZA7eHT1x/gikC6iXRUhxyNLyQmlTGC6res0pCb4qGzd0ig=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=qQF5T6xw; arc=fail smtp.client-ip=40.107.100.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Q1SoQcHGoW31hFfNVcrJUT4rM5fR+dqjwOjMdrSGJ/MmFl80dC/w6yCq3u4PNxBhJwU8TZaUOX5ucEr854l3gd/gLQo/nGp1lHpdpnAS/jXsPje2C4XuqjEtCV1ch6gJu9RZNxGfsnm7BMWpy9dyM3oQUw/bHaS6uJjsO5DBAFH5AqmnZA/l0h4Ym5P4/SbUaOrWkIbIw5dvBD67dxPjbKZBdXJqbvHI91TF85eunxasVBE+XlrFBoFeI0JJtZgmXeESTdB4ACy0iTf7+6toebQpFUcNv1mjlGUMn0ErNbsOAp1M0RBep6r+fg3i34wUlT3A3+G5JSFTPKgR7BAi/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/zQ5TIsZ9GPwWcvnKzv9P/KVJpsbEN/DYokEKL1JyTo=;
 b=f6xp10SykhglL3O5TQLBIVC3uMDUbAz2Y4rZTy34obSH4558qHgXPHsH9tRz3Eg1l4JUUI7zaKCsrkLi9vfrVVSBiKTQ1gs6ahNb/uzzOonWIdiWdVKeEfdT4gWVhsmDU3bTHyhI2zu2ziwYrefBKZWx2JwdJSd2mzcr+hHTHHYLDn4vb4NxHmI+o21QIpyazZDOV08r3Mz+tgkmPjNz6sFEh4C4Um3vm2kb58x4EFBTzAsOsd6NFpg1Bsm56Jg5DdJ/E+NaLykfgPPK0Te/VETkoseL6L6mwyeUPLQLPTKHMIkK8+LBdkH96wuHAD/e7NtKR0J5jXKlAvrxWCZe7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/zQ5TIsZ9GPwWcvnKzv9P/KVJpsbEN/DYokEKL1JyTo=;
 b=qQF5T6xwkN7L7rsFBVlQOnfhTc1iB5ZcKHkT4wuamtw8Hfg+uy+lN/PKK6iPqddl/6/tcUiDUIAdLmR+vz6uEl3yUFuSc9GqTZhrgw6JvBEKKkgC4LlReSfGXfeDoNeAKYU6nOB1N4mFKmCUBZe43epMlyYUFe3QisjSQh7GfaY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by BY5PR12MB4179.namprd12.prod.outlook.com (2603:10b6:a03:211::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.37; Tue, 3 Jun
 2025 14:03:58 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%7]) with mapi id 15.20.8792.034; Tue, 3 Jun 2025
 14:03:58 +0000
Message-ID: <a058d191-6fd7-bdf6-4cfe-2988521a8e6a@amd.com>
Date: Tue, 3 Jun 2025 09:03:55 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v4 1/5] crypto: ccp: New bit-field definitions for
 SNP_PLATFORM_STATUS command
Content-Language: en-US
To: Ashish Kalra <Ashish.Kalra@amd.com>, seanjc@google.com,
 pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, hpa@zytor.com, herbert@gondor.apana.org.au
Cc: x86@kernel.org, john.allen@amd.com, davem@davemloft.net,
 michael.roth@amd.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org
References: <cover.1747696092.git.ashish.kalra@amd.com>
 <5f4bb8f321c57cddd06f4205ee3cbf6bde0b3915.1747696092.git.ashish.kalra@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <5f4bb8f321c57cddd06f4205ee3cbf6bde0b3915.1747696092.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR06CA0004.namprd06.prod.outlook.com
 (2603:10b6:208:23d::9) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|BY5PR12MB4179:EE_
X-MS-Office365-Filtering-Correlation-Id: 7b82134b-d657-48b3-d7b8-08dda2a77c24
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ODUyZ1dRN2JKS3RVVmhGcmNpeUN3dk1pYmZpRTJITE5zWVJBTXhUWnVrNk1E?=
 =?utf-8?B?VVJUYW5MZ0QySjY3ekpDc1pSNUp4NDM3V05jS1poejJ4VzRETXlsZytRWWVo?=
 =?utf-8?B?Y01mVUc3MVo2c2k4RWttWnNtS25heVBwNkVEWnZDeU5wYmhkQjI3aUlWa0pT?=
 =?utf-8?B?T3pYTS9MMTA2WkhmTm9lZlRLUmNHK0dnUG5QM3BTYkFuWGkrQi9iQ1F0bCtR?=
 =?utf-8?B?dUp4L1QvS3ZKWG1YMEQ2ZWsxaDVJdURibmFPdERUdXIzektSM2ZudmFPSUor?=
 =?utf-8?B?QUNsYzZaejNUK1Z3SUk5eXlPc1UrRnBxendwN2dwMWpNaEJvYmNFZXd4bUNs?=
 =?utf-8?B?S2N1Q0J5clcyNmZZSVdZZzVCdlUrWno1U0kwTCs5cUJEVkE5S1JwTUZYSi82?=
 =?utf-8?B?dUJkbytsVG4waHltR25XdGIydnB2VXByQUtKTys2UFFFZ3RLZytxRXYzWWov?=
 =?utf-8?B?MlNhcUJmNCtnMW5CNGZDbXdKcnhpV212MVMzL1N6YmtjTFJMQ2N3QVRKNXZQ?=
 =?utf-8?B?YWExaGNyaUdwUXNCWmlWRkVSUElUejJEVFR3Z2RaeXlNS1NGcldTZFdTTDBz?=
 =?utf-8?B?bTVraHZVaGk1a1MyN2V2M0QweGNuSWd5M0p6MlRPR2M1RXdOUzNvWEIrblFU?=
 =?utf-8?B?cXZvV1gxYXI3bjVQTC8wendLZHA5d1dCUjRDbU5vWnowNzUxTVJwT1VYclp3?=
 =?utf-8?B?dCtpM1dnNzl3eU9ldldHSGJNTjJFVVBMUGl5UklGZFFJUFVKOXBHa0ZJaDcw?=
 =?utf-8?B?ZUIxMG55RUwrcy92LzVZV2JBcm1JNWg2ekVjK0F5OWc5bzI4RDl4dkQ5TWt1?=
 =?utf-8?B?OFhsU2RKUDZBbzRhZ2tSdlY4SThLUnprRkhqc2tWNWZvcDUza09vdXV5c2ph?=
 =?utf-8?B?Zmp4M1lLOUVVNkxIeDg3VUpuNGgzZCs5cUZiWE1FSUJaUlZpeFB3VHByTVFz?=
 =?utf-8?B?VlBnRGw2OW9aYnVaQXRmMi9qbHRkd2I1NTZCb2lOQlpGM0J3T0Y1RGZUQ295?=
 =?utf-8?B?RVRGTEMzcFNOaklVWGNwTjVDQ1NnYzFqTTJHL1g0YUI2ckxtYmw3cDhpVnhr?=
 =?utf-8?B?YlN4RFZZdm82UWFMOXcwWU56SUFydTNGSW1rTkpMN2FaaWM5aUp2RVJqYkhJ?=
 =?utf-8?B?Z3c5SFFJdXh2K0MzdkNPOHd1SUoxckhWVnp4VnZDRllaT0VFcnpibWdFcDFB?=
 =?utf-8?B?QWlDMSt6dFE0YnhPUERrR0pmUjZxMnRtVWtmUXcrRHNrZnAxWnQ3QXNOZnZz?=
 =?utf-8?B?dTF5RHM1bEJGdjJiQ0ErYWpuemc2ekdzOWRDNGF6UEhUMmYzdVI3U2tiakdQ?=
 =?utf-8?B?QytrUllNcnVoSXgxRGtpY2RVbmRxc1hIS3B6dGNua2lCbFI3NDZVNC9uVWRF?=
 =?utf-8?B?a1RqKzRDUlQwZ2ZtRjBVRjJqM2xoeldMNzI4OXY0aUUyRWVMbFk2NGxXM0xm?=
 =?utf-8?B?VEwwMlFDOHdjbEFoWWlLT0NVZkpZTHVQTmJ5UG1zR1NoUVpEcm5jeW1lOVhX?=
 =?utf-8?B?cVRBVzFCbHNxc2pBOGpoVzZXdzVWUFloWHpsMndmOVF6NEx2N0xxNSt2K1VU?=
 =?utf-8?B?MnhvdktqdkRUUUcyVzJCZ0NxSDdROHBlUlR0ZVJVaU11L0NmMEtpOHBaNmlP?=
 =?utf-8?B?U2M5aGticXZVYzFTb1JKcllDVHNqRXdpMGNRMVdoMkwwbEo0YXN5b1AzeVMz?=
 =?utf-8?B?dXc5SFdrRlRETis0Qm00ZGQ1YTRHS2FxVmZxaVVkVThjd0RkUy9JbHExV1pH?=
 =?utf-8?B?aWZkMnZ1Tm04QkZjOFJZT1ZURVFrU29BZGpId01LUWNraGhNWUVPV1JvaUpV?=
 =?utf-8?B?THEwSi9FMFNhK3QyMDZXZ043dlNxaE44NUVkNXplSnlqdkF5V0wyRG9Pek5Z?=
 =?utf-8?B?bnNqNXJRVnhOTGZybHVJNGVvVnlRQVU4QnY3bGhmRHRLdHhEaCtIYWljZy92?=
 =?utf-8?Q?pKtgain7+4w=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?L2c1STZ2OWY2TDB4MmVobE1YSE4zc3JZaWVxZVNFOGc3UlRuVHFnaWluMkM0?=
 =?utf-8?B?Z252cFN3YmlDVHd1T1Q0YlZuakp3QS8zQ0czbFEwLzdnTm5wejJTT3dZNXZz?=
 =?utf-8?B?cjYveDFPNnU0YWtRc3IzdkJxZzBPRXNlRGtVVkZHQXhnSDN2ZC9GdDRKcDlN?=
 =?utf-8?B?SDlmNktuemVURXFKZlE2ZnRialhzK2JxMFVXL2xsRXRXaDh4WTNjY2FZL3Rj?=
 =?utf-8?B?TnVnaXY2bUNGMW5QNkQzRHl6Z05YK3NVWWZOZ3pTeTJESFZkMmIzVm9mekFv?=
 =?utf-8?B?bG5QTW5aZkwyMDVkTzk1c0FtR29XN3N0c2dYWWZFWnFRVlJtaXFKNlV2dm1Y?=
 =?utf-8?B?VmFtNzVkZDBWZERiU0ZUc1phSy9jNjZlVjBiVmk5cjYrb29qMDlYUjBHck5j?=
 =?utf-8?B?bHNsWDBRakZvenJIR3NDVTlCeXdKaXZSWUhkNTQzejVjVkNsZVJheXJnZlNS?=
 =?utf-8?B?aEpHYzhuWEZLK0ROcm9mRUtNODM2YVVrUVNGZjliUmhwWkNnc0F6S1ZBMml6?=
 =?utf-8?B?RFRyY1RrMUMrVFNkM05ZMkpFaTVsZHVjS3NpU0VjNGx6bURocitMRmNIcDdD?=
 =?utf-8?B?NGVZNmNXUmtQVnhGM2VuSFJRRVVOTEg2R2pjZ2dUN3ZuSDdSMWRDZTkxYjRT?=
 =?utf-8?B?Um12Y2JaZG9GWVFhZTRqM2FkY1UyS3MrRm9CbW45NmFZVFkxV0VpeDc3S2RS?=
 =?utf-8?B?U3A2enBRY3VMcUVuV3JrNWhPT0M1YTBxOTZJbTQ3bHpxc3dGL29mKzhkSXh6?=
 =?utf-8?B?R2RJc3VTc1dPNFlsS3EzSzhXU3JUZWNVQ0NiQTRuRTRFZk9zYTRUQ2ZhS1ow?=
 =?utf-8?B?Y1JLa2R1T1NyRWtHTXlLLzNaZTJjMDc2Nzlqa0xsT3FXZnlsS3BseXV4dEFk?=
 =?utf-8?B?MC9xY0w4NHBDc3FYSUUzd2ZCdG8wQXpXaG9KZ3VpTnp5VE5IbkdJdlVCeC81?=
 =?utf-8?B?anVQT0JzTWk1RGhHYWt1THhYSkZrVm9sQ3p2amN0Ti9xT05jUFVYRkxURHBT?=
 =?utf-8?B?Ym5QMVd2QldFc2NrNW5DQ1FFM3pyVmsyY2VETjFVbmI5dHd1WmJ5b3NOcEhh?=
 =?utf-8?B?Q3VqVnNYdWhjVkpXRkJrVlZNTDVWMHowbThQdjd2Q01Ea2FzeDNwTDNxVmF4?=
 =?utf-8?B?OXV3U3ZkY010UEpRRVZYUUdRMmtieXcvSVgrTE9nMnlBbU11SzhsZHV6OStl?=
 =?utf-8?B?RTNoVGg1bkM1bGtTSVcxZ0U2SlJvcDVnOTVhZUJ5Z1hSMmtDK3pDUFdJcEpa?=
 =?utf-8?B?MXlvbjJJM1JJbmxQVXVmbmZ0OW5kdHpQV1pmWlRkd0JsSWozRjA2WkF1YlBI?=
 =?utf-8?B?Tys4UWJFL0RjdG5QWnQyZFVrMmJrQzNpeHZtTzJWMEF6UmVuMVp6TWhyVGZJ?=
 =?utf-8?B?Z0Vqc0VhSi9xRnlZT1A5MFJSWjc2YlN6ZjB2MllnL1U4SHB0RjE3cWdJYVJ1?=
 =?utf-8?B?RlpzNFpOVnpGaVNIcUJROUhDY1pPeEdhbTNwOXRHTjhpV2tPTEgzWXdYdGU3?=
 =?utf-8?B?VWpSRGxTVnpZUm4yRDZLR3h6ZCsvaTJDWGFuK0RzSEdmU2E4SjJGbk10YmZi?=
 =?utf-8?B?MDRSRGxvd1Z0bGZ0YWhydXVkWkRQcXpWK294VHRYV0ZPdmhCTlNJSEowRVo2?=
 =?utf-8?B?K3plYm9reDZ0WDIyREdpclYxSjRiRlkzakM0OXVpaFJpQ1NvelUyUUJXZ3ZK?=
 =?utf-8?B?aDdUVDJmQ1k0YllrZjVaNG4zaUh1OVhMQUFHdi94MHA2Z2d0Z1F5VjBwVGVN?=
 =?utf-8?B?V1JwSTBnUUN0Rll0L2dZdEVRblR6MUUzZVFwU01rR3pXbEtBa2kxc2dROEZk?=
 =?utf-8?B?OGpXQ0tBbUs1UlVuRUd5OUc1MW91cWhFTE9hQmpvUDdZQjFEN0xuOGxpWkNx?=
 =?utf-8?B?RVVEUEpCaGEyNUgvM0lWMmI5Rm5GRzIwWWd5dEpOR1BON1FSUzRjZ0hFNmRo?=
 =?utf-8?B?QzA2Wm5NWWxncGVKZTQzRW11ekxWcmxvTDEyUWM2OUErQUZtV1M4c0RsM1ZK?=
 =?utf-8?B?U1FuQzNSZkw1MUl0bzBxWEJJaitMTEdGUGQrM3RLY2hPYXlYOU5ub29wY3lU?=
 =?utf-8?B?OC9LcDBWUlY1TSthNjd1M1NIckZJbE8weTByMm01NHZBZnRUQ0U5NlYzalI1?=
 =?utf-8?Q?bUy9xd56O3ckwwgtsdJQyFKXb?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b82134b-d657-48b3-d7b8-08dda2a77c24
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2025 14:03:58.3753
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uyjQvXlXQdEejn15I/qM1wV+99sV/FfZke7cBlRCdsTEx8koQPPoqz/mT3s2SG5RrlrGZlAa9eNUAJ9WpWvMkg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4179

On 5/19/25 18:56, Ashish Kalra wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> Define new bit-field definitions returned by SNP_PLATFORM_STATUS command
> such as new capabilities like SNP_FEATURE_INFO command availability,
> ciphertext hiding enabled and capability.
> 
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  include/uapi/linux/psp-sev.h | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/include/uapi/linux/psp-sev.h b/include/uapi/linux/psp-sev.h
> index eeb20dfb1fda..c2fd324623c4 100644
> --- a/include/uapi/linux/psp-sev.h
> +++ b/include/uapi/linux/psp-sev.h
> @@ -185,6 +185,10 @@ struct sev_user_data_get_id2 {
>   * @mask_chip_id: whether chip id is present in attestation reports or not
>   * @mask_chip_key: whether attestation reports are signed or not
>   * @vlek_en: VLEK (Version Loaded Endorsement Key) hashstick is loaded
> + * @feature_info: whether SNP_FEATURE_INFO command is available
> + * @rapl_dis: whether RAPL is disabled
> + * @ciphertext_hiding_cap: whether platform has ciphertext hiding capability
> + * @ciphertext_hiding_en: whether ciphertext hiding is enabled
>   * @rsvd1: reserved
>   * @guest_count: the number of guest currently managed by the firmware
>   * @current_tcb_version: current TCB version
> @@ -200,7 +204,11 @@ struct sev_user_data_snp_status {
>  	__u32 mask_chip_id:1;		/* Out */
>  	__u32 mask_chip_key:1;		/* Out */
>  	__u32 vlek_en:1;		/* Out */
> -	__u32 rsvd1:29;
> +	__u32 feature_info:1;		/* Out */
> +	__u32 rapl_dis:1;		/* Out */
> +	__u32 ciphertext_hiding_cap:1;	/* Out */
> +	__u32 ciphertext_hiding_en:1;	/* Out */
> +	__u32 rsvd1:25;
>  	__u32 guest_count;		/* Out */
>  	__u64 current_tcb_version;	/* Out */
>  	__u64 reported_tcb_version;	/* Out */

