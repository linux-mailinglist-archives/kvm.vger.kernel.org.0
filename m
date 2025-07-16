Return-Path: <kvm+bounces-52598-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D133B07178
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 11:19:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 814C65684F3
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 09:19:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 770A02F0C78;
	Wed, 16 Jul 2025 09:19:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="yQGvf9J5"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2076.outbound.protection.outlook.com [40.107.94.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9E312BFC85;
	Wed, 16 Jul 2025 09:19:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752657574; cv=fail; b=rXprFoe8v5bpgDjaDJd/8BKhAkRALCTdLUkeT1lSU83VrBh6OWCHSCn9DARsm2vWihy97S6aVe1UZaOJFFkGCU9hkNhhhxG33S9wXHZSlnaLevR77tCYIb0mmfY2nhSRP76OTqPQYyMzNHAiajHSAZspKNWd1BU7f1D5kHjcQ54=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752657574; c=relaxed/simple;
	bh=nqvf0/9PelaE7X6e8orjRws5sQX1ufC5FF/bkb8lxkQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=EI0MC8AN5LuiOXFSJdeM75sjMZMnqDKhHh7hoWNL3X80o/mZ4ZkyEbLUipI1PyRuvf1plsHEdtwIClzCjAzmoa9Y76EzyshFYo19AyDnqjeZvyBCc5cADyLygrXQKzfMAZM6nwI3XGBuZ3/4Th5VJOCuLX/5NziNsS4e3AOQtBc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=yQGvf9J5; arc=fail smtp.client-ip=40.107.94.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ggtdHp2AwVmeFqSTTA6ykW+K3SH8On4rFCov4ih1aP/zV7MTvmlVGNp88nCvmxqavafTOM9hHQG6V2ctd95G6ZptW31gnmpyG3WNT4zTctamYMNAKaentEqUwwVoI+X2GWpEo5oRn6zAAuMKtShlhzuMH8yTDtaj7YP+LQ0IXujhf45DZNenCTkkNyp/vqa9emO+Fz9UjVOISHnAVc993fgqWZrk/8xAKkA2zub4IJi2N/Q7rqR4+NpxPs5x3fImnZsGG/oZZUOc9b0d9D+Aq+CEVNvxFsG2Y4xeD1Mr+ILYOs7E16LzLKz3O6K0guWGlFT2sAdZNeEi7Zy3SQtilg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GT/ozUCgZO7VeLZrZ0ws74536BkA2FqHtcRTfB6aoD4=;
 b=erl0UoqG1CkiJpmZNPNIqM0w7JYwi3dYPV6G09mKrTWp+keVc8OY13No4Eg7EM0A+OgvVH9euaviJLYu21haV3h8LbC9DKm22NlH+fjqMIJKBzAoO0E71U3k1PPuRg+YTrMj1hqaZJJUQzSUozON+2XVdgkfBrPLxPFoeS+8X8RhQDt1R9qZ9R+aIcQ8DY/fMhPFq1IR5sSSCdUzPRbzTsCWQqtt6aSYJoNLdJdP7xWTP5clpUb94jDD4eBbyzf8JAApInMypJjYkra24DOjqb9JdRDzCfOL++KGBb7tbFlac5/BSzMK8P7TEEPnUQ0/nptXnl/T/6cFDhEls3ftPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GT/ozUCgZO7VeLZrZ0ws74536BkA2FqHtcRTfB6aoD4=;
 b=yQGvf9J5xQY6D7V4WcYdEHpXu2dnjcPTS2CSeFk5T8vga7GTBuhfGMCb+XyXc1uUgyPA8Kt7Np6medPQTziFlWjE5osnd4EA4D2fE/9NtIg3i1yIrxT6l4DdbxsKs56IQoeWSco6sOQRbqiJ3p/0xj3bNEn2Uc7FThTovDtDAu4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6048.namprd12.prod.outlook.com (2603:10b6:8:9f::5) by
 SN7PR12MB6813.namprd12.prod.outlook.com (2603:10b6:806:267::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.35; Wed, 16 Jul
 2025 09:19:29 +0000
Received: from DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5]) by DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5%5]) with mapi id 15.20.8922.035; Wed, 16 Jul 2025
 09:19:29 +0000
Message-ID: <e71a581f-00b2-482f-8343-c2854baeebee@amd.com>
Date: Wed, 16 Jul 2025 14:49:04 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/4] iommu/amd: Add support to remap/unmap IOMMU
 buffers for kdump
To: Ashish Kalra <Ashish.Kalra@amd.com>, joro@8bytes.org,
 suravee.suthikulpanit@amd.com, thomas.lendacky@amd.com,
 Sairaj.ArunKodilkar@amd.com, herbert@gondor.apana.org.au
Cc: seanjc@google.com, pbonzini@redhat.com, will@kernel.org,
 robin.murphy@arm.com, john.allen@amd.com, davem@davemloft.net, bp@alien8.de,
 michael.roth@amd.com, iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, kvm@vger.kernel.org
References: <cover.1752605725.git.ashish.kalra@amd.com>
 <7c7e241f960759934aced9a04d7620d204ad5d68.1752605725.git.ashish.kalra@amd.com>
Content-Language: en-US
From: Vasant Hegde <vasant.hegde@amd.com>
In-Reply-To: <7c7e241f960759934aced9a04d7620d204ad5d68.1752605725.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PN4PR01CA0100.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:2ac::6) To DS7PR12MB6048.namprd12.prod.outlook.com
 (2603:10b6:8:9f::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6048:EE_|SN7PR12MB6813:EE_
X-MS-Office365-Filtering-Correlation-Id: 0ac73a63-c6f8-4c49-3e65-08ddc449de08
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?U05Qc1ltOTlqRytzYTZmMGM1SnAxRk1jc2JXM0QrcjJsZ3FyNVJEN21rSFRk?=
 =?utf-8?B?UVJiSnU3QTdLbFlkMHYvU2tiN2lkbHhRMWNkdEIvVG1WTml2Q09PaXl2TFNQ?=
 =?utf-8?B?bHVnZUw4R2RERXplWVEwd2pZaG1KVEMvdXI1RVlhMGVBVkVmSVBoYmNEVmx2?=
 =?utf-8?B?OTJOOUwvUmVNRUZxZHd6ejdXRTU3eVNTbWhmTmpZVHhXT3RCWHA3R1VDWWJm?=
 =?utf-8?B?amFJYW8zcWErcmxmL3dGYlJaU0tNdEJ5WEU2SCtraHZBbGNiQzUvTDRwcExP?=
 =?utf-8?B?Qlg0VFhPVFRIVVZ3L09sblp0dkhBM0FKZ1liZjBqcFVWMzlTYWVrVnExcm13?=
 =?utf-8?B?UlNyYUVscStVZG5TbnY0bmpsUVpOVzRlTFdQSEpiWlpIa3FlOForaVo2cFFa?=
 =?utf-8?B?U1lzMktMbkEvWWF5SGI1S3hOU1JyN05RTmY1NzViVURoSWtLRWtJcFM4MjdZ?=
 =?utf-8?B?b0J3K3JBWmx1THZKd1lueHVjMGt0Mm5Ud3pTbFI1U1lXbVYrYm9BQzhPQlY5?=
 =?utf-8?B?M1R0MnI3ZHVXYWlQREpsUkVCM3djMEJUcEptUmdGcGRXTFlXc0ZZa1dWZ3dR?=
 =?utf-8?B?UjVNVllPaHdZZ3ZQTGpNRHlLUDN3RlMvUUtPLzNIdGUxZHRQSzF6cnk0MVpD?=
 =?utf-8?B?SFhjUGduOU1xKzNKcHVMUDlMWi9pZVdmN0llUy82YWw2dSsxd1VqUDJSOTVS?=
 =?utf-8?B?anFkdEV3enFZT01yTVdPajF3a0FES3BXSkdSMjg4WmgvSWNWS0VYRTFPN0tY?=
 =?utf-8?B?QWRORmZ5QmJlRU1HbGsrdWU2SmZURmd3UVJRSUJKRWtQNFBJMkxKWEhadWln?=
 =?utf-8?B?d3dpQTJDcjZVSlhCQ2xaRmU4aVZzei9xNEQ3WDVqVnJLaHU1ZWJjcHdKR1Nw?=
 =?utf-8?B?SjJmUm9qZ3lNMkw4TVRZb2s1Nzk1ZU12YkE1OVpneE9jcHdXV3FhOEhLM0pL?=
 =?utf-8?B?cEFXVEVYakFRbEZOTStkRjQxeFpyRXdzU3ZQaGpHenAyT0pHNGxkeWVJQkxM?=
 =?utf-8?B?ZnRKdk0vOCtFNHFKSWJHcTF0bzh4YXNuNDY2MEE1eHFtUmVJTGJ3Q25Jb0tD?=
 =?utf-8?B?dEM5b1RBVkpOc0JOcFNmdFgvUzRqdDE2ektkcHFYWEtrblFQbk9SVi9KNnFm?=
 =?utf-8?B?TmhRcmFwZGZPdzUvVEVnOEIyR2dXbjAycVU4N25vQVpUWE54QzJibG01bUNI?=
 =?utf-8?B?c0VOZjNjNDNJSVQ3MXRCQVlPWUp4ek1aT0hINE5MeVVpckdFbEx0Sno1S0h2?=
 =?utf-8?B?T2ZXOHM2d09SWi92VFpueUw4L3BaeHpza0VTcGhDVGRBeCt1bTdjbmdmck9o?=
 =?utf-8?B?Qm9JRW43TTlSNWo5cnlOQnV5QVNrd1I1NHM3dGVjYmxZRHVtWE1ock9qa2M4?=
 =?utf-8?B?Q3RFd0lOYXY4enlBeG1EVEtYTWNia2k3M3BsSGhQZVdGRHMxemJUTzNKdXNz?=
 =?utf-8?B?dk9FZGlCVXc1c2xrcVpPdkdCMStLSVVGaG9oWVBsTHVmSWxJVElLVk1KSktC?=
 =?utf-8?B?VVVOVVdVTGlqUHpGM1F3SkwvamwwRlhQOU9GdHp6TTE0d3VFMWFNOWVKUXZY?=
 =?utf-8?B?ZW1LV0lSNTgvNCtGRS84aE9KVThrN2hkSWJvNVlVbU9ob3dBM3lxS0VBc2VJ?=
 =?utf-8?B?anpCQjZRWmduc0cwb0dnK2RMeGNIZUNockx0QjJ3S3k3YmQ2RWZNTXhuYUEx?=
 =?utf-8?B?eVI0L2kvbVBKb2p5ZnVNS3MzUnpZZS9nUXdsc0g0OUdlcFgxdUQyV2ZLZnRk?=
 =?utf-8?B?K2JPdUlYMndUODh3RnFqVWdtaVVRTi9iaUJtZC9iQXI5Q2RneFA1OHhSZy9X?=
 =?utf-8?B?L3NnNWkrbGRxcE5ZYXAwMnBuZHpGdGlXVHJNalpTdlIraVpNL0FLN2Z4Mlpr?=
 =?utf-8?B?ZUtsOHRQMjFwLzZ3c0hHV2dGRlNsa3R2NGQyYXN6ZU01YjZkcGIxaUsvM3N2?=
 =?utf-8?Q?rdDZDYHGTqc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6048.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Um9OK0phb3ZHWlZmTVViTmxIaEVwc3ROUGRVQjZmSjcyN2tUdXhZQWszQTNP?=
 =?utf-8?B?azJkRC9xK2Y5RkdUQ21QcnhlQ0J6RHl5L29OR3Fqa1BiS2tTdGFMZ0x2Y1dx?=
 =?utf-8?B?UjFLdXNtRXpNWnFZQnUwSHI0QUl1NSs5ZDZqVDlReFNFWndNZE14QVgyU2N2?=
 =?utf-8?B?Q3RlWnpsVnJxUUFORXNFWEZQN1JsNk5FUVM3OWZXQlVzRkJlQllaUHhkWWs3?=
 =?utf-8?B?Wm9nOVpUVzk3WkZ2cVFiR1gzdm1sNkpTR3dOZHlCYzhUWldHbjQvMlQ3bFM0?=
 =?utf-8?B?UXl4bldYY0xjWkp5VEJxTFRiQWxpVStkYzFkSXg0UUhJTmpXZElpdjgrU2hQ?=
 =?utf-8?B?NG1wUE9pS3JGcGo5NFp2WTZjMmlZdHk1SkU4QnE0Wi9peEM1RmJpSW8yQkVX?=
 =?utf-8?B?SXJOOXkxY1pDM3NRNUc3eHFEam9VRWo0NkowemlkK3N1WHoxZ0NoSUl1VGIr?=
 =?utf-8?B?QTFwVFgwSUVRM3pka0IwS2tXa293c0w3bWZReVViZURaSkxvSzlPSjlYa2tZ?=
 =?utf-8?B?K1pkM2dhNEVqSVNaS0FmejI0WjEvNTl1VDNKbEhwK2IrYVhwVmlFejRkVkpU?=
 =?utf-8?B?N2RXdjhWNmtJWmEyMFd5NVFYeXlGWnVJYVlYVG50VnF3WjhWMExFTEtmSTZG?=
 =?utf-8?B?cFZ2S3lEclhvOXVHVFl0ejBJNXp1SFR6eURYWmowbFNveG50QnB1TEt6Sy9w?=
 =?utf-8?B?UWZMMFBRVk1VNTVzZm1aSWxZaTJ3VkNLN3BVZXpZQ1NRQzRTa0hiTkNGUWFh?=
 =?utf-8?B?azh5QU92N2lJZUdMOGw5dUV0Y1R2NjIzejhXSlRIRjdVYm1uSnBBekJWWjVJ?=
 =?utf-8?B?Wk9vN0VrSkduU1pUSkVBc0lvVUxNak1XODNVaFB4VnY1ZXI5SmQrQjB0U1JV?=
 =?utf-8?B?dDhvMXJlS2dQZDJwM253QlhRMzZlVHN4azhScVdrc1ZEVDAyWFVrMUQzWG5P?=
 =?utf-8?B?L090cytIU0tJOE9LOHVuR0Z1L1RVY09kRUZyK1YrVnpaWWloT0hTQkJsbDkx?=
 =?utf-8?B?RGdBWXRoUjNhTGVvcHQ4anNFd2ZPQ2h5UkdLcU1ONzNkZnY2T3k3NnBXMjRR?=
 =?utf-8?B?cno1cU5Sd3VFZ2pMQXhMTktTZmR6SmpMYjNoVURtWE5MdWg4dkpQNk1zaDhL?=
 =?utf-8?B?UVlnd3V1RGN3WUR0a2ROQWpkL1d4aWpHRGgxUUxBMWpVNDNMUGtPdTdCVS9M?=
 =?utf-8?B?QzNzSnZjUThPTFV3M3hib29KeXNsK28rcXVZRzB6WG9YYXZOTVZVaFBBRUNu?=
 =?utf-8?B?ZmRCWEpvRXNLdDBLUlFvYmNMWE85c2FzOWRqTXR2dXlnTDhOZlNJMFBIMnRR?=
 =?utf-8?B?eDdHR1hRWnppQ1dyOGNNY0xHb2JQbXgwd0xEODVPUWEwLzJINiswZjZBZHMw?=
 =?utf-8?B?OVZtYm42WldVYkgyMUsyY0J3ZTF1d1dpdFZyeWtSWkpzYkdJZ2lLWUgyTllu?=
 =?utf-8?B?Ym1BVU44QVBEUEoxdUlWZCttdHFaRlhwOU9qOG5pT01HV1Qyc0JVTnpEbWlt?=
 =?utf-8?B?RjRQMGFrK1dFQ0dpVUMzbTVtL2VoWm5KcUNCdnVHd2diODNHVmd0S2R2MjRU?=
 =?utf-8?B?aG9KL1hUYjZMWElNd0wrdmYwNjFKeWlyaUlRcFNwUSt3dmt5Szh1cUhwcHh3?=
 =?utf-8?B?aGlrZVJ0TEphQTB4ZWF5L3g5cC9HOGYwTzhqUXB4WjRNUzM3cW93ZFkxUDR6?=
 =?utf-8?B?RDFCTU03Y1U4a1BBRmFPaHduYzFZUy9hc3RRbytlL09xQktGWUFLOGRZOTdX?=
 =?utf-8?B?Y0cxVXJmU3RESC9EV05OaTZiL1VxbnlLSWx0U3ZCSDIzUTJqTXBhN05rbkp5?=
 =?utf-8?B?ODdHVDkxd2tMTDdHM3Zmc0tKaTRNU0NYVm5IQzdzbE9KVGdvSjVMN1d4VDVW?=
 =?utf-8?B?d0IvbnFKWDY4K3MrcEN1OVZDS2xGRlE5OXFON3FTQjIya3ZRRXVYNGpSdG9j?=
 =?utf-8?B?SGgvY2oxcFZDZ3BVTVJxeGZmanZYeXRCSXk0REJCSFBKMmkxZHBIMldVanRz?=
 =?utf-8?B?eFpLYnZEeFJMc0sxb3pYVXpSNERnTmwvWXZ0S3M5aGcwcCtnM25lNjVyM3VR?=
 =?utf-8?B?QzZTS3FiRnlTRzJCYmJ3eDNoa0dGWmdQN3JBbDBoVk1KRXNsT1pyUU9PNjg1?=
 =?utf-8?Q?kTCXdsjwVeRlRB9sGrSxoHAuJ?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ac73a63-c6f8-4c49-3e65-08ddc449de08
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6048.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2025 09:19:29.5715
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qyGnhAZHmuenIg35hESLVOB1+le1yhdRlWTJVs88z2PtcTGXJzT84zpnxzg1cF8EIJa4oB6jo7mevuP+LoFvUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6813

Hi Ashish,


On 7/16/2025 12:56 AM, Ashish Kalra wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> After a panic if SNP is enabled in the previous kernel then the kdump
> kernel boots with IOMMU SNP enforcement still enabled.
> 
> IOMMU completion wait buffers (CWBs), command buffers and event buffer
> registers remain locked and exclusive to the previous kernel. Attempts
> to allocate and use new buffers in the kdump kernel fail, as hardware
> ignores writes to the locked MMIO registers as per AMD IOMMU spec
> Section 2.12.2.1.
> 
> This results in repeated "Completion-Wait loop timed out" errors and a
> second kernel panic: "Kernel panic - not syncing: timer doesn't work
> through Interrupt-remapped IO-APIC"
> 
> The following MMIO registers are locked and ignore writes after failed
> SNP shutdown:
> Command Buffer Base Address Register
> Event Log Base Address Register
> Completion Store Base Register/Exclusion Base Register
> Completion Store Limit Register/Exclusion Limit Register
> As a result, the kdump kernel cannot initialize the IOMMU or enable IRQ
> remapping, which is required for proper operation.

There are couple of other registers in locked list. Can you please rephrase
above paras?  Also you don't need to callout indivisual registers here. You can
just add link to IOMMU spec.

Unrelated to this patch :
  I went to some of the SNP related code in IOMMU driver. One thing confused me
is in amd_iommu_snp_disable() code why Command buffer is not marked as shared?
any idea?


> 
> Reuse the pages of the previous kernel for completion wait buffers,
> command buffers, event buffers and memremap them during kdump boot
> and essentially work with an already enabled IOMMU configuration and
> re-using the previous kernel’s data structures.
> 
> Reusing of command buffers and event buffers is now done for kdump boot
> irrespective of SNP being enabled during kdump.
> 
> Re-use of completion wait buffers is only done when SNP is enabled as
> the exclusion base register is used for the completion wait buffer
> (CWB) address only when SNP is enabled.
> 
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---
>  drivers/iommu/amd/amd_iommu_types.h |   5 +
>  drivers/iommu/amd/init.c            | 163 ++++++++++++++++++++++++++--
>  drivers/iommu/amd/iommu.c           |   2 +-
>  3 files changed, 157 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/iommu/amd/amd_iommu_types.h b/drivers/iommu/amd/amd_iommu_types.h
> index 9b64cd706c96..082eb1270818 100644
> --- a/drivers/iommu/amd/amd_iommu_types.h
> +++ b/drivers/iommu/amd/amd_iommu_types.h
> @@ -791,6 +791,11 @@ struct amd_iommu {
>  	u32 flags;
>  	volatile u64 *cmd_sem;
>  	atomic64_t cmd_sem_val;
> +	/*
> +	 * Track physical address to directly use it in build_completion_wait()
> +	 * and avoid adding any special checks and handling for kdump.
> +	 */
> +	u64 cmd_sem_paddr;

With this we are tracking both physical and virtual address? Is that really
needed? Can we just track PA and convert it into va?

>  
>  #ifdef CONFIG_AMD_IOMMU_DEBUGFS
>  	/* DebugFS Info */
> diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
> index cadb2c735ffc..32295f26be1b 100644
> --- a/drivers/iommu/amd/init.c
> +++ b/drivers/iommu/amd/init.c
> @@ -710,6 +710,23 @@ static void __init free_alias_table(struct amd_iommu_pci_seg *pci_seg)
>  	pci_seg->alias_table = NULL;
>  }
>  
> +static inline void *iommu_memremap(unsigned long paddr, size_t size)
> +{
> +	phys_addr_t phys;
> +
> +	if (!paddr)
> +		return NULL;
> +
> +	/*
> +	 * Obtain true physical address in kdump kernel when SME is enabled.
> +	 * Currently, IOMMU driver does not support booting into an unencrypted
> +	 * kdump kernel.

You mean production kernel w/ SME and kdump kernel with non-SME is not supported?


> +	 */
> +	phys = __sme_clr(paddr);
> +
> +	return ioremap_encrypted(phys, size);

You are clearing C bit and then immediately remapping using encrypted mode. Also
existing code checks for C bit before calling ioremap_encrypted(). So I am not
clear why you do this.



> +}
> +
>  /*
>   * Allocates the command buffer. This buffer is per AMD IOMMU. We can
>   * write commands to that buffer later and the IOMMU will execute them
> @@ -942,8 +959,105 @@ static int iommu_init_ga_log(struct amd_iommu *iommu)
>  static int __init alloc_cwwb_sem(struct amd_iommu *iommu)
>  {
>  	iommu->cmd_sem = iommu_alloc_4k_pages(iommu, GFP_KERNEL, 1);
> +	if (!iommu->cmd_sem)
> +		return -ENOMEM;
> +	iommu->cmd_sem_paddr = iommu_virt_to_phys((void *)iommu->cmd_sem);
> +	return 0;
> +}
> +
> +static int __init remap_event_buffer(struct amd_iommu *iommu)
> +{
> +	u64 paddr;
> +
> +	pr_info_once("Re-using event buffer from the previous kernel\n");
> +	/*
> +	 * Read-back the event log base address register and apply
> +	 * PM_ADDR_MASK to obtain the event log base address.
> +	 */
> +	paddr = readq(iommu->mmio_base + MMIO_EVT_BUF_OFFSET) & PM_ADDR_MASK;
> +	iommu->evt_buf = iommu_memremap(paddr, EVT_BUFFER_SIZE);
> +
> +	return iommu->evt_buf ? 0 : -ENOMEM;
> +}
> +
> +static int __init remap_command_buffer(struct amd_iommu *iommu)
> +{
> +	u64 paddr;
> +
> +	pr_info_once("Re-using command buffer from the previous kernel\n");
> +	/*
> +	 * Read-back the command buffer base address register and apply
> +	 * PM_ADDR_MASK to obtain the command buffer base address.
> +	 */
> +	paddr = readq(iommu->mmio_base + MMIO_CMD_BUF_OFFSET) & PM_ADDR_MASK;
> +	iommu->cmd_buf = iommu_memremap(paddr, CMD_BUFFER_SIZE);
> +
> +	return iommu->cmd_buf ? 0 : -ENOMEM;
> +}
> +
> +static int __init remap_cwwb_sem(struct amd_iommu *iommu)
> +{
> +	u64 paddr;
> +
> +	if (check_feature(FEATURE_SNP)) {
> +		/*
> +		 * When SNP is enabled, the exclusion base register is used for the
> +		 * completion wait buffer (CWB) address. Read and re-use it.
> +		 */
> +		pr_info_once("Re-using CWB buffers from the previous kernel\n");
> +		/*
> +		 * Read-back the exclusion base register and apply PM_ADDR_MASK
> +		 * to obtain the exclusion range base address.
> +		 */
> +		paddr = readq(iommu->mmio_base + MMIO_EXCL_BASE_OFFSET) & PM_ADDR_MASK;
> +		iommu->cmd_sem = iommu_memremap(paddr, PAGE_SIZE);
> +		if (!iommu->cmd_sem)
> +			return -ENOMEM;
> +		iommu->cmd_sem_paddr = paddr;
> +	} else {
> +		return alloc_cwwb_sem(iommu);

I understand this one is different from command/event buffer. But calling
function name as remap_*() and then allocating memory internally is bit odd.
Also this differs from previous functions.

> +	}
> +
> +	return 0;
> +}
> +
> +static int __init alloc_iommu_buffers(struct amd_iommu *iommu)
> +{
> +	int ret;
> +
> +	/*
> +	 * IOMMU Completion Store Base MMIO, Command Buffer Base Address MMIO
> +	 * registers are locked if SNP is enabled during kdump, reuse/remap

Redudant explaination because implementation is going to support non-SNP
scenario as well.


-Vasant



