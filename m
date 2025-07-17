Return-Path: <kvm+bounces-52700-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5EB30B084C9
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 08:22:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 44E5D4E036D
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 06:22:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F018A21767D;
	Thu, 17 Jul 2025 06:22:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="a6ZIqCWe"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2048.outbound.protection.outlook.com [40.107.102.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5016E215F48;
	Thu, 17 Jul 2025 06:22:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752733348; cv=fail; b=Tjkvs18hxbLLh6/OH2AHG769YNxI3VuEhCoNd6FhhvgpoOWtK64I7saBdWDJfNhA/toIcTcxt3PIRFBszes7X6sS9R9x4DoQfAy6GZmUwyLMYPT9m2xZvAegdBzwkTzjZvllNPBLsnDKkjv2dxstYGgQXxXJPUXRonmP+9xCi9M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752733348; c=relaxed/simple;
	bh=gV8bIhhqAzAUxMIW3DKT2+ocqCAlil8Rq0+0q6BwFXs=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=q3UbSfVTFOkKShtuzV/FWvoympU+u1j4Q8o/c/SXmz8ltihnGUwSl77cDUp9m03ynm5ceVKXVs+4rYXxeOnsQepZfi58O9spd5db3sp4XYatqdTheVB//CJ7GeubrKteSV2WdesCVg5PnTU7TuXTxqVGBxngGOHQgzBzEGWePCQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=a6ZIqCWe; arc=fail smtp.client-ip=40.107.102.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rRI3CP3klQwe4iZHhjYrybh6A1Rxh4vQXFTNSzV7jVQtczqDWDh/wQAqU/Mya6Iqm/fAvKT0zlsogjEI9nFbtPDBr1n0wp07f/WrqdSFEyLIuykrRPtL5vXoTE/n93HCfMJVkIenUGlhvwKWqsqZvcTeA3CXAqd1W6DBBQTF/IeWWxxMY+5RnJflZxlZchajUZXBlXYyopN3vxctquugS4qYf9iGTJKRU6t/LyuVtv5WRuHvG1amI/vvGQuOx0AmP60JbQnKdPwRC882y5egl+7xph2HlYVtqKOitVoF4PEIysdmJIQRq3yrA0BLKsu3D3F0fd+COD+bEPqmdUINAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yjcGWJ3UkuIQifUi0zdAVeEXl6U6X9ewC/g4Shg5KRA=;
 b=n8KbC+dkXKt7Ybt4hIgfSh3NqLZFTxdk6CnJJqJUU9fz/OreTj2liGe+hS+zSGh9cxYFXIgW2QNYL8LEogU2etc/d/ppYCT+HAQ7wdjVkMNn+3zpbt1iy/vkPzDukpMT00JKuUGbHbVOjMfdL79pMWWv1JdR9pFPBtxLQBvWSGLq93/LKT7YyXJeMuKsXYr6Y1EGcsh9q5p2kXeQYJEwByjtXpp+aEPV1nk9ukEOs2Bo/wS4kWT9KjVlT/cl+SknH8L+X72/2fIRcM1AV2G/1wWSZ0zp7tL2lfevc5vN1OX89aYKF+5eYyvOgMQY7u8MAdcFOtzl/qqgIJi/iL7Ndg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yjcGWJ3UkuIQifUi0zdAVeEXl6U6X9ewC/g4Shg5KRA=;
 b=a6ZIqCWe7ILOACeT9t4z34+/F15+ju2i28j6cPYi1wrOBGmL6T3sv6eLfRskArgmec3G0mA8Bp+mcQRxS/W1x1KWko9WXq6FCi+KpIbDj5fFJ1HcTeMRYQsZ5sVD2E02ZhvKLx5u5flzQqNZsxhCeQYOF3zcKFjgoyT53n9U1I8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6048.namprd12.prod.outlook.com (2603:10b6:8:9f::5) by
 CY5PR12MB6297.namprd12.prod.outlook.com (2603:10b6:930:22::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8922.39; Thu, 17 Jul 2025 06:22:23 +0000
Received: from DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5]) by DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5%5]) with mapi id 15.20.8922.037; Thu, 17 Jul 2025
 06:22:23 +0000
Message-ID: <e5665a37-d9b0-428b-bb6c-6d05c60bdd51@amd.com>
Date: Thu, 17 Jul 2025 11:52:14 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 4/4] iommu/amd: Fix host kdump support for SNP
To: "Kalra, Ashish" <ashish.kalra@amd.com>, joro@8bytes.org,
 suravee.suthikulpanit@amd.com, thomas.lendacky@amd.com,
 Sairaj.ArunKodilkar@amd.com, herbert@gondor.apana.org.au
Cc: seanjc@google.com, pbonzini@redhat.com, will@kernel.org,
 robin.murphy@arm.com, john.allen@amd.com, davem@davemloft.net, bp@alien8.de,
 michael.roth@amd.com, iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, kvm@vger.kernel.org
References: <cover.1752605725.git.ashish.kalra@amd.com>
 <ce33833e743a6018efe19aa2d0e555eba41dcb96.1752605725.git.ashish.kalra@amd.com>
 <529c8436-1aeb-41bc-94bd-8b0f128e6222@amd.com>
 <49ef7e43-6a5d-452a-936b-87a573225d1e@amd.com>
Content-Language: en-US
From: Vasant Hegde <vasant.hegde@amd.com>
In-Reply-To: <49ef7e43-6a5d-452a-936b-87a573225d1e@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PN3PR01CA0187.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:be::10) To DS7PR12MB6048.namprd12.prod.outlook.com
 (2603:10b6:8:9f::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6048:EE_|CY5PR12MB6297:EE_
X-MS-Office365-Filtering-Correlation-Id: 94f7980b-3763-4a25-2512-08ddc4fa4aad
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TTZIeFNGNnJ3c1NHN1dlVzM2d0JCQUNOWFkrcVU4b1B4MFBVZmJVbWJWUktJ?=
 =?utf-8?B?Zm5EVGtvUlZ0aitJN2UzYTg2aU9xRmIxQmhzVkxESlN0T2dHaUpUNzRPVktX?=
 =?utf-8?B?UGN1VmRhb3BRZEdlN0JDZFJXdE1jNkNyalFrb2k4UHJic2IxeWg0bzArUXMw?=
 =?utf-8?B?bVJTNjA1Q2s5K1drWWorb2dCOTBvNWhlblBiUGptbWdMUVhzdHFiT1Q5SGdX?=
 =?utf-8?B?NHNpM1ZHeVFLTlNPWllZakVGaVdJTGQ0K3M3ckdTNXNxWEp1SWdRbTZCa0g0?=
 =?utf-8?B?NlVoNDdOTjJiNEdRZUwvRXVmTWZNL2Rvemt0TzRwY25BaURoc2paSm9kOXF2?=
 =?utf-8?B?VmRpOGJEb1JEZ24vNTVZUTVKRDcvZE8rb2lGZkZFMEVqQkRGelVBb3Rsd29t?=
 =?utf-8?B?UzhTdU0zb3Z3bzg0WlJuMkdKeDU2SWZQNElZbHYxMGxXRlRiQlFjMGYzbnFK?=
 =?utf-8?B?Uk5xclpuaTNNdTBFTTh0amJ3S0E2ZkQ2VWtGbU9hRU0xZTFFZzZFRzlabUFG?=
 =?utf-8?B?WHRZekYwM0RYS2p3eDNvc2ZhYmpOTXVCdnNyaFpobk9TcVlRcnRBVFlidXQ1?=
 =?utf-8?B?QWNHSVpXYy9uSjIyYkxiSlVtNlIvZmFHZ0xVMlhUSk5HSGJuNWJvRmZzVkMy?=
 =?utf-8?B?Z3lJNmx3M1phL1NkQUNJb1NLcEt6aUxFVTl3UUVLWkJjLzMyS0tLV1ljZjFu?=
 =?utf-8?B?ajdOTDVhUFozS0hxeG0rZEp6SmxHTU50OGlaS1FDSloyQWdDcHJVZWhEVDhX?=
 =?utf-8?B?NXNXTjRWZFQ2U1ZBODROYW5MbXlUOTJpMjZDOGo3a3d1c3paYVJZc3FDd25l?=
 =?utf-8?B?WG5SQlprNGtXaEE1aEFlbUczb0l5Y2RITDd4Y044YVgrKzE3Ym04cThFY05x?=
 =?utf-8?B?aGtXOXhxVE1MdVNTaGVaZE1wdHV6YzVGQkNEL0pQZTB5dFBUUWowRldiaktp?=
 =?utf-8?B?UE1IViswUXl6YTIvcVkvN25lc3c0cko3Nkw2UUNUTVZiNEFvMXdVenp6L1BC?=
 =?utf-8?B?NFYrZzhBWkxTVEI5c3ZXeUFnalRnY2Exb1dtRjRkQlVlZGFndkVDTEF1SGdN?=
 =?utf-8?B?S1JoNHJZdWlka0o0SFIrZzJ1TlZNc1FoNFZYSlJSN0dJSzdrOHFtYktVd3BO?=
 =?utf-8?B?SS9iYlRmZDlzangwVlM2dnhRSzB2aGl5NjY0MlpIdlZRYStsT0NLNXNLQlRN?=
 =?utf-8?B?ZDNoWFFLVlhwc1FTMkN4bG5nQWV3SndTRTQ5VzdzMTZKbjNDNGtLRXkvaHFp?=
 =?utf-8?B?NzE5eHQxcDZ6KzljZFFLaW1BU3NYYWJmT1VhRnk1L1hsN096UGRrTWJTd1VJ?=
 =?utf-8?B?Umg2dDU4d2dkVmJYRGhMSGc1YnJpeUJwcE1NUFhSZHRiR3VIdFB5bUhKdkhM?=
 =?utf-8?B?NzFFdFpmRW9NSlJWL2F0SjVvWVI4cUJxYThlbjN0TlVUY3NXcEFmUDVkNUxC?=
 =?utf-8?B?L01tMHd4dE5HanJrSzUwN2tjOXBsQ2E4YzYrSWhBY2ZISmkyQ2tIZzB2d25X?=
 =?utf-8?B?Z0VSZzNlSDFnWHVCcjRJc0VYVlJISzdrR0I3WnpEaDJ1clZIU0xuQ2t0a1gw?=
 =?utf-8?B?Sk1hU2NLU3MybFVOcFFjUE1TNGxORW1PaWhzYVdKKzZnQlMyTnpGNDUxYjFk?=
 =?utf-8?B?djlEZ1hBODdWQ3NpcVh1YnE2UEFsOWJ5WVdLZWd2RDRnOEZ5QVdleUs0eWNp?=
 =?utf-8?B?WnZHMGNTdG5yVGozUTRLbzdCNEk1dzA2cmdEWWZ0WjNabW1DczRqNE8wcEtu?=
 =?utf-8?B?MURIcjBSQXNpamlEYTBLb2poRlJVZmlnVXk2RXdtYUJ4aVh4T0RCRTdCZTMr?=
 =?utf-8?B?UGl5WnNTZ2VzNksyNjd5cjdrRVJyWG9YcVduS3pzWDBrK2YxWHdqQW8yZDdJ?=
 =?utf-8?B?eTM4RVlVYk12cTF5RG1wdXUxTXpoSEtwMVZqdnBOdzZ6dDR5Vmtza09XODZl?=
 =?utf-8?Q?AnBd/Git5SI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6048.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cm0xZ2xpL09XZDlDK1NxUzFDdnNWSHY5anArQWdDdDNLWVh3STVES1NZdzUz?=
 =?utf-8?B?aVNWNzdjMXBveG9DRUFrSTIxZmNaajBXUURCTmp6TGtJSDdKN281SXNXUGZF?=
 =?utf-8?B?Rko5c0o0eGFVV0NPcGFFTXRuN09HMDJ1VFZUbUFqQjYyUXRJT3BaeHZTYThC?=
 =?utf-8?B?TkJ3Y0x0YlgrTzlUaGw3RWhYNGhtekhuZUx6ZEh2Ykx5Ujd0WlhBMmNtb1RI?=
 =?utf-8?B?ZmFMOXRPTzBKMWV6VjVDU3BtZFlUREhtN0ZJRUdrUVFLYjFPSVVpN1BYeERJ?=
 =?utf-8?B?ajBhSzQyVnNxRTRPSHJtN0xuVUQ3UTF3dXlyeG12bXpUd0ovMkc5MmxPMHBP?=
 =?utf-8?B?QS9MZm10SEhIbWlwRXJrMmJQNmlVdGRQYmYyMENITy93R2thWmxQWU9Ydm9l?=
 =?utf-8?B?dW9BSmQ3ZjlPb2syeGMyR2VwbzY4T1RobGZxRFlCOTd1OEJ4V1pxNFdSaWZi?=
 =?utf-8?B?UW94MVFOUUUwY21GV3NlTmoxc1pnTEl5QXBDZUJuNW5hSnVtb2JkOHl3VXNq?=
 =?utf-8?B?S3dTTGtGbXdjY2pIcDNEOFB1RkpNWnZ5dVJXdWtjODU3eXQrS3RhaEdHSW1Q?=
 =?utf-8?B?Z0NkZnl6OVhJRW5WeENjTitnL1hlWlI2R05keEsxUFBkOTYvOFdORjFja2U3?=
 =?utf-8?B?UkYydjdTTUE5RjlyRFlIRTYvbEFLbHYrZ3pwczAybk9hUmNISFJRT0hhbEJo?=
 =?utf-8?B?WnRqVXZtK1FEWENrSWdTS2tkWTJ4K0RPSm81TndnVkxPeTlSQkZBSTlQZWRD?=
 =?utf-8?B?Z0pETG1xWUJpT1J0dG90Mmd4VFRTdWcxNXpVOG5TeC91MVdYUWlqTXhxY2tP?=
 =?utf-8?B?aFBVdy9jY2Q2RzgzUXNuUkxVZDNiQWZ0ci9ESjN5L1JibmpsWVg3Qno3SWht?=
 =?utf-8?B?VWhITmxTZFF0Q2ptTHp2ZXBSNnZSMXdvMUxBTUg3enQ0UUN3bHlTVzE0YnJv?=
 =?utf-8?B?TTY4cFRVNkZ2UHdPV000aHJudU85SnZhREpKdFdBbmpBY08yblBvN1hydVZ2?=
 =?utf-8?B?SlNVRmZCdi9TYnI2RmhhQXE4cUdXdWRIeENFRWVYNnlDL3VPeDVCUXpLSjgy?=
 =?utf-8?B?SVd3Zzg2NXhyNEVRVjJWVUN6bnZRR1EybUlVd2J2Y1dqV3RyNFU1TjZ1YXlx?=
 =?utf-8?B?LzM4aWlnNC9qSTMyczF0NCtKQXJiTmVBQ3NaZndrWEFsNFNrWStUTWN4b01r?=
 =?utf-8?B?Y2c1YzJhbDRhbkpkSlNxVDMvdmlqdjlHMURTZWo4SUYyZS82ZCtIVmRNMGp1?=
 =?utf-8?B?UTkvSDhpNkJ6amZ5SGxXcS9odkNPUDE1bjJNWTVlaFZlYVd3VkNKZE1DaVVp?=
 =?utf-8?B?ZE9GZVF6cGVZVHVBUTJybm16VS9HWGhRUHVWa0xRdWx2Yk85VWNPR21oYzAx?=
 =?utf-8?B?MUFPK0xOMDRueHg5cE1PbUZ5bmFsU2wwcUtRN2xvNVROYmpZM2dPZGtlSEUz?=
 =?utf-8?B?emlyMDNZcUhyeHlDV1VGeXN0RmRXNjQ3V1lCS3JtZzJCVFFObUlZVWdnQk5x?=
 =?utf-8?B?MWdISGxaUzA0MkRPYUlOZ3B4T0FaQzBWMHR5eFpKV1FzRUxpbklmZWorVENt?=
 =?utf-8?B?RGpsaDlBajZ5Mmd3bTR0aTVJUWFJa0ZQRGF0UjNxSmtESWl0M05VeE1RcXow?=
 =?utf-8?B?VkMveGZ2Z1poVW1GVExuMGJ0VU8zNDJLZU9QaU1CNlZGZ05oSkwrOXJRa3hz?=
 =?utf-8?B?Qi9KNlRoTXpWaEEyYmh4Z1hia1ZoYWZBUWZDRmYwUEtEamJOUUw5SGtzcWJv?=
 =?utf-8?B?T3phUkZ2RnFmdmFkSkRwUlJsRy9VUVdubVhQMHowcFREMkFEM0RBdW9PZGVm?=
 =?utf-8?B?ZllGMEhicWppZkNaRFpWVWc1Q2hVL1NRZWRYSVRCUW0vYkxNTjNPMFBlZ0dG?=
 =?utf-8?B?bHUvMlZ5SVhTNzl3YXhNVUovdTArUEt5bG1haGg2Z0lOT3VsWGJ6YXZtakxN?=
 =?utf-8?B?NER1TDBnUUIyRWhSb20zVndPUzdqVlFJbUxxZXpITWZRRkNUOWdqSzJrc2tu?=
 =?utf-8?B?VXR0VElWUzJlMUl4bmJSbEZOckhOcUV3M3V3NVZ1Mm5HWUNiR0VRNXZ3b3V4?=
 =?utf-8?B?SDBQd0VCbGhSUVlENWJqT1AyUHY5NXVRUW8vRUpiM21JZGllVEhNVE1hMXNU?=
 =?utf-8?Q?RSzUnSPjFBMDh35Wm2+vIjxIu?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 94f7980b-3763-4a25-2512-08ddc4fa4aad
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6048.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jul 2025 06:22:23.2071
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V3+s4yyyjOjnc+OrNb0oqneNgfw6GwZVlwr03tHxJq3G1zzAzMOsryMtOroN6Qon85hAASDghh3PrLMMfYISUg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6297



On 7/17/2025 3:42 AM, Kalra, Ashish wrote:
> Hello Vasant,
> 
> On 7/16/2025 4:46 AM, Vasant Hegde wrote:
>>
>>
>> On 7/16/2025 12:57 AM, Ashish Kalra wrote:
>>> From: Ashish Kalra <ashish.kalra@amd.com>
>>>
>>> When a crash is triggered the kernel attempts to shut down SEV-SNP
>>> using the SNP_SHUTDOWN_EX command. If active SNP VMs are present,
>>> SNP_SHUTDOWN_EX fails as firmware checks all encryption-capable ASIDs
>>> to ensure none are in use and that a DF_FLUSH is not required. If a
>>> DF_FLUSH is required, the firmware returns DFFLUSH_REQUIRED, causing
>>> SNP_SHUTDOWN_EX to fail.
>>>
>>> This casues the kdump kernel to boot with IOMMU SNP enforcement still
>>> enabled and IOMMU completion wait buffers (CWBs), command buffers,
>>> device tables and event buffer registers remain locked and exclusive
>>> to the previous kernel. Attempts to allocate and use new buffers in
>>> the kdump kernel fail, as the hardware ignores writes to the locked
>>> MMIO registers (per AMD IOMMU spec Section 2.12.2.1).
>>>
>>> As a result, the kdump kernel cannot initialize the IOMMU or enable IRQ
>>> remapping which is required for proper operation.
>>>
>>> This results in repeated "Completion-Wait loop timed out" errors and a
>>> second kernel panic: "Kernel panic - not syncing: timer doesn't work
>>> through Interrupt-remapped IO-APIC"
>>>
>>> The following MMIO registers are locked and ignore writes after failed
>>> SNP shutdown:
>>> Device Table Base Address Register
>>> Command Buffer Base Address Register
>>> Event Buffer Base Address Register
>>> Completion Store Base Register/Exclusion Base Register
>>> Completion Store Limit Register/Exclusion Range Limit Register
>>>
>>
>> May be you can rephrase the description as first patch covered some of these
>> details
> 
> We do need to include the complete description here as this is the final
> patch of the series which fixes the kdump boot.
> 
> Do note, that the description in the first patch only mentions the 
> IOMMU buffers - command, CWB and event buffers for reuse and this commit
> log covers all reusing and remapping required - IOMMU buffers, device table,
> etc.
>  
>>> Instead of allocating new buffers, re-use the previous kernel’s pages
>>> for completion wait buffers, command buffers, event buffers and device
>>> tables and operate with the already enabled SNP configuration and
>>> existing data structures.
>>>
>>> This approach is now used for kdump boot regardless of whether SNP is
>>> enabled during kdump.
>>>
>>> The fix enables successful crashkernel/kdump operation on SNP hosts
>>> even when SNP_SHUTDOWN_EX fails.
>>>
>>> Fixes: c3b86e61b756 ("x86/cpufeatures: Enable/unmask SEV-SNP CPU feature")
>>
>> I am not sure why you have marked only this patch as Fixes? Also it won't fix
>> the kdump if someone just backports only this patch right?
>>
> 
> As mentioned in the cover letter, this is the final patch of the series which 
> actually fixes the SNP kdump boot, so i kept Fixes: tag as part of this patch.
> > I am not sure if i can add Fixes: tag to all the four patches in this series ?

But just adding Fixes to this one patch is adding more confusion and
complicating backport process.

Is this really a fix? Did kdump ever worked on SNP enabled system? If yes then
add Fixes to all patches. If not call it as an enhancement.


-Vasant



