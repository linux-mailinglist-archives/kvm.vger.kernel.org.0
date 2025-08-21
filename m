Return-Path: <kvm+bounces-55268-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 40EE0B2F6CF
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 13:35:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EAC78AC5E95
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 11:29:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D10030E853;
	Thu, 21 Aug 2025 11:29:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="dugO9JyM"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2059.outbound.protection.outlook.com [40.107.93.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F05611DF756;
	Thu, 21 Aug 2025 11:29:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755775757; cv=fail; b=cHketTIcla//oONiQRoJoWW3hYWSRsRqwj2ZSp+MPJRqtNNTL6vjP6fRovUR06mpzRYkbUEmPdjxwwhsd8Jpg0heMBI8FIriwMwxL1tng0EfU00M6aIahn2ELQXlLGEF1N66+tTIZK0BJk15qK+h/w37d6f1v/3HMe7TP3QLAr0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755775757; c=relaxed/simple;
	bh=/5BtKMgCvbTBQleNIeOgj98i4IzjhXz6LtmeOZrVePA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=RA7Cxt0dwsPRVGvqK2chpjljN7br4SMId3ZO00RRc396rGmVFDKC+73gOCaxba6LMz5fIxVjIOHnLIp12Tmd/d3hVF9GvojhDWMTs9WyDGuDNRmAhQI5dhlOrfRMxhRXilChW/dRzPneoO8fy6kPqi1Ge9vyLd4Lnlqo2RjKK6s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=dugO9JyM; arc=fail smtp.client-ip=40.107.93.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YApnSGFTp6ilokHnFo4B89GgpEeIA1busEid5tzKx0a8Utb8KKYbOs6gvtoU/j7PYLaDksBLWVxIlPlsH6eUBexnn2lI+7dzcpSrYaGG9ooBRX1AP2OAnvt8ceCvaDWDpEfFsQjCQT1B3qhp0GWMEmVe8KpwL0CWpMsD3kEGEWYCocC+7w1LIvA94zYPshVpM6zDf5NQEbQeK6x7Z+tUBm+zHYx/as6n91bT3igffKD6mNDRzCxtu8JFC+qIj37JGwlCXurPBtethJecv4iYC8COLrJZYIdQOw2GoxhI2lnn5vCCvq/ejK5g1/qpm9yzbsYHP7FGo5akQ9m9BxySjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6ZzaXxrbyruf1J54w2UBobuMDLswmschzJFabjbjkDY=;
 b=ADn/LaYG1wZYpkFnfmCCcmUVxUEd9CzACPDgHvJZPQ17IktFzCtHlbyKSt2SNoh7eN7TsZaGHo+dEMGrUL8c0lBv4GVkW4vYxrZmayt+Rs5/UIZ1l8jRadgkp+ogQCiZ8cSW73c2CAn/Q+s4Xc6XzV7sfKjaQ2a/9O7CNmyjqQWheaH91vIrx9yGG6UdGBOdZvcjrZkdIg4jUsSxT2g+BkgKmfd/2ne9tON3JVc3tiX6JcXCAvS6a4wubNSx+cH7RnuWfFBoHOAvnDg9bjdievVZUGAOAPdKBFDF1qHK93yBGekZXJSr6DGxKhyUOcrW4KM/nmJVa4Zu334f4MxKIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6ZzaXxrbyruf1J54w2UBobuMDLswmschzJFabjbjkDY=;
 b=dugO9JyMs/k5TfRIBvW+vsQWm55I9knXKwxdOYhd8ce761P6/qoSP4rLSf7ZsacRBLCYUoSz3nu6ZS19NG7HWIxw35fRgrkL2gzykfdo7ZUK/XhmGDcpgY1UxD+LSalibVl+dPIBsJORfaoqKdRLyoSgNVAB5rbhEXB4OrJNEgg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6048.namprd12.prod.outlook.com (2603:10b6:8:9f::5) by
 DS7PR12MB9502.namprd12.prod.outlook.com (2603:10b6:8:250::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9052.14; Thu, 21 Aug 2025 11:29:11 +0000
Received: from DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5]) by DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5%4]) with mapi id 15.20.9052.013; Thu, 21 Aug 2025
 11:29:11 +0000
Message-ID: <8613b5a8-aef5-4457-a1ca-646443da8d5b@amd.com>
Date: Thu, 21 Aug 2025 16:59:01 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 1/4] iommu/amd: Add support to remap/unmap IOMMU
 buffers for kdump
To: Ashish Kalra <Ashish.Kalra@amd.com>, joro@8bytes.org,
 suravee.suthikulpanit@amd.com, thomas.lendacky@amd.com,
 Sairaj.ArunKodilkar@amd.com, herbert@gondor.apana.org.au
Cc: seanjc@google.com, pbonzini@redhat.com, will@kernel.org,
 robin.murphy@arm.com, john.allen@amd.com, davem@davemloft.net,
 michael.roth@amd.com, iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, kvm@vger.kernel.org
References: <cover.1753911773.git.ashish.kalra@amd.com>
 <d1285938266d753b9d215e7c649126d261208143.1753911773.git.ashish.kalra@amd.com>
Content-Language: en-US
From: Vasant Hegde <vasant.hegde@amd.com>
In-Reply-To: <d1285938266d753b9d215e7c649126d261208143.1753911773.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PN3PR01CA0002.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:95::22) To DS7PR12MB6048.namprd12.prod.outlook.com
 (2603:10b6:8:9f::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6048:EE_|DS7PR12MB9502:EE_
X-MS-Office365-Filtering-Correlation-Id: 4b538a90-5d68-414a-3be4-08dde0a5f335
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SXJsYlFrOTEzSWpmc09GWERrOEVPZnJKcWwrUkE5Yjd0WmNJblRCVGRxTTgr?=
 =?utf-8?B?cmNySmRvZVh2TmxxRWhkeGtOTWhEMFdseFB4N01QZnFTSG1PYWNob2xBdG52?=
 =?utf-8?B?YU5WdzF3UUM5ak5MRDdYdjhBN1RVcnkwZ1l2RHlxR28yRFpHb3AwdTBBeWZW?=
 =?utf-8?B?S2FkQm5nQXVyUFREd0NaREtScEJVRHdROUJ1QWdvalZiU3VTMHNEWEcyaGZo?=
 =?utf-8?B?QkhncXA5NVdLc2xhTHpsMlN2QjJNeHZydElJRFJGODMyY0QvVGRlV00xRkVv?=
 =?utf-8?B?ek50dkl4dUExOVYwdGcwQzRDWGE4WlZSTzZJd09aa1JXcGtTbmVNYWVFak9O?=
 =?utf-8?B?b2hpVjdYSU90NUhOZ2tka29ObnBHWDl1eXREQjZLYlY3eXJDaTdoWlE1V005?=
 =?utf-8?B?U0o2WTN2ZFZDUFFmWFJNL0dwV1g5M1A1N0oyWERMQ0dWVnFvNDk0OFhtSmY1?=
 =?utf-8?B?R3JaVTlZeFR5MDdIazRkYjBRdWFsOUtXZi9mNXV1R0xHYmtPQ2d3a2Z1VTZ0?=
 =?utf-8?B?RHk0UGR2Nkt4amtSaUdEeEJEOENxS1Fmd3pYM21yNENjSnhtMGdmVE9pYmJt?=
 =?utf-8?B?V3hmdDZxcEMyTG9waGhLQWFTcllMZnpGUWpiRXYyeEh0a2tteEhtVXBGL0cy?=
 =?utf-8?B?Smp4YkhxTkpwM254V0lTa3pWUDVpSk9nY293RmNMM1NlOHVlcnVIZ1FpSFRV?=
 =?utf-8?B?N3VzQnorbjlWZjRxZldiNTkwSC9pQTBJbEhQOUJMRld6UHVuQ2J0citnR2I4?=
 =?utf-8?B?TjNjZHM5MVc0SFBtVkFNRnhUM0twaS9UWU9YVmUvblA1aUE4b0E1dEZGWW81?=
 =?utf-8?B?T3ZkUUQwQjYra2JNMmNNaEFZbFB6UGJZb1F5VlNWOExWcVZqSmpSenNHWnBQ?=
 =?utf-8?B?MWNEWXVvZU1XRzFEUjArdFdnK2ZzOXVTc055V2ZEall6ZnhXdjI0Rk1FUGln?=
 =?utf-8?B?bXVFMXdNb0VFRVRkWm5hdUJZcDI5bFV3dkh2VDd6SjIwNEZHSVJMWTU0eVVU?=
 =?utf-8?B?U0tXd09jSXJ4UDlONW93SXFXYi9ndWVKWlFJd0NFbkErQ1ltNkVsS3RmdUVC?=
 =?utf-8?B?Uk5mcjVNd3M5c1VFcHJoY0tON3p3dUdjaVJQS0czMUljOEp5N2o0Q3dPMngv?=
 =?utf-8?B?bmtQQ0VNVHAwUklOTDdTeVRYYkR1eTJnYXp6STFNUjY1bk55OEszajBlWTAx?=
 =?utf-8?B?Y0ovVHJSOUpFMFU4U2dyRGxJY29YUUYrdFhYWW5PS2ViWlo4N2dQK051VEQy?=
 =?utf-8?B?WktKNklJaGRFbUc1WnZ0eG5yMUN2T1FBNlo2aU1ONy9STTNZOGVKcmFPbEhn?=
 =?utf-8?B?L0JhZVdzdnlXQUF4b3V1dStMQTl3cFVpeXJ2cDNIbm42ci9mdWliQmVSd0hw?=
 =?utf-8?B?MXJGbEdodWtVYmRXL3pEWXlrQlpKWG8yWlFtaFA3aEFaRGhJaGd0NGVwTmI5?=
 =?utf-8?B?WHE0RTlpcCtqYUJHaVNxUlhKMHFFdEpsejg2S05tcURXa2JpSklyTUdTYVFZ?=
 =?utf-8?B?Q0pBMVpXa3cwOWU4Y1J2VmIxdERzV1V6VGc1VUFJUmh0YWUvZG8rS3JTSGFi?=
 =?utf-8?B?T0xsZjlId3IxU1cvN3MyKzVKaThkK3Fnc0diUWNJdFo3WFdia1dXK0kzeUwy?=
 =?utf-8?B?bE5VSXd5QVRwT3d0RXgvclNTckNWL2wrU1NOTm9xWTdCTHR1a3ArcFMrK25N?=
 =?utf-8?B?L1dDTW1HNHcyOTdsU2VLS3NLTFRJSzI3OEVsSWRRRjdsemxuVVRPaEliZERj?=
 =?utf-8?B?SnJHWG5tdzFuSmltMGFCOG9JK0xEZ0dLeis2Sk1zWWo4R3h2M09ibkNEd2tU?=
 =?utf-8?B?NmVCWGhxQS9kdmlpU3Y5RnM4VGxiSnBKc1FXRHNobFBXdDd1REdvVDhxV1A0?=
 =?utf-8?B?TjdBeWRCeHY0am8zZktZQk90WVpJUTZVOWdHb2YrcExJNWN0U0NKcjFOOWdZ?=
 =?utf-8?Q?pbW/yimxsK0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6048.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MzhYaHdIZGVXenBvbEIvZmZQZFgxaGY4d0ZtcHI3cm9INHBPWkNxREcxMzA5?=
 =?utf-8?B?VS9SMHo4bm43VVhBVzFwbTExTEtxaFF5a2dXQ2JRQnErWDRXMWZaMFpsL2tq?=
 =?utf-8?B?dEJ6bDQ5dTZuTGU4ck11NDVOcncrNEZOMVVxUVBLVGVRZ2xTcyswbEkzcVA4?=
 =?utf-8?B?NFREUmEvVTA2SXNOVkdCNllRaGNoYUg2OTloeFFWZnZMYUlmZVFuT05xVlRV?=
 =?utf-8?B?cjZaRWxFbnozNVdDNks3QWgzeU50Tk1PR1BUeXRENENvaE5RZnEyaUZmL1Zq?=
 =?utf-8?B?dmFqcjIwN3ZBN1dLNGxPVmhSbjZ5T3RsWGdJTjZxejhYSkJzZGZqSjljK1Qz?=
 =?utf-8?B?aEdCQjVFZ1VvazJzV09TNnRGbTJ4S2RsY1R5R3F2UlZsZUJaeTBPN3pXYk9H?=
 =?utf-8?B?SmhuekcxOUV4UE9uWERtclEyTXVBYjNVYkhRZmU5dkhWQmlQSERUVWVIc1M2?=
 =?utf-8?B?aVF2ZnJCM0cvZ01qbUVHallDVFpkcWZIQzlLZjc5ODNVdDl0aUl1TW5uOVpZ?=
 =?utf-8?B?RlorRDArTTVDNnJNczVHVkQyaUtJZWxhaW9GM1VsVW1CeDhpeFlORGNlcXpm?=
 =?utf-8?B?MUJacEpiclhacStQZGx2SUU4OXU0cWRUQzRKZ3BWcEZiSW1Kc0tnblpTNE1l?=
 =?utf-8?B?MGJNUWN3ZU03YjEzZzBEcWZGTEQyTDVXOTlGMEltT0xobTRwYUhOaitGbEZt?=
 =?utf-8?B?QjkxMG1zNFNrclJ5V1RQWTkvSHYwR1kyVDlXNDVPWjAyem5lenBvcUVRV3Jn?=
 =?utf-8?B?Y0dNVGo5aUwvNVNOb1RUalp2UGJkbmt1WXlGRDNkMVdDVFNFbXdrMW5aWTZi?=
 =?utf-8?B?ZERWazZMaTNBOWRTZUJMNFhld2RYNFd4cUgrek0xY2lHZFhIZFZ6Q1hyQ1hj?=
 =?utf-8?B?UU1BblNabjlURjRlQkhpMUdTQmxMc0k2dHlXTW1FS0lJc1h5UlJPUkxPTFlt?=
 =?utf-8?B?Q1hOUkRJNGVOVDBWaTJmTk52UEEveTdJeG5KbHBMZXhpYWM0Tm4xWU1GamFl?=
 =?utf-8?B?TDROcERPVkFUNi96OTZJaTVCUExSUW8yc1B4clRGSmF0RHFwTWhtNmVMR3BV?=
 =?utf-8?B?ZGFscWZCL2dZbEw1ZWhPTXBvWGZLekJjUjd2Uks0QkhsUjVlbzZBT3hWalUy?=
 =?utf-8?B?VHFPem9aLzRWMGo1S0hBT2hNdEQvNHRubTU2cVRVRGZvUTVxaVBiWVRXTVhv?=
 =?utf-8?B?YUIvaThmejhrV20va0J0VUxFbVF2MFpvbHJkbTV2YzlNeTNpY3FqZXgyVXhk?=
 =?utf-8?B?aFlaNDFxK1hUcGZ6dFZtdUNlOTVnVlBtTU5oNHNVSjkvdWtiTTFlY3N6RHhP?=
 =?utf-8?B?V2JySUFQWDlaVjlSS2hIMVpBdS81S3JzM3MrTHN2UnVZY0hlYWk2eElLcWFO?=
 =?utf-8?B?VEtyWTdkOXlidDhpYXh5NU9LUG5sclBDdzJJQlk3WWVoS2NZU3o4b3BDejBq?=
 =?utf-8?B?OVdJLzV5S2pRZkhpYnN1MHAxZEZKWmtBQ0haaHhOaGhhVklaZm9VQlMrR2p6?=
 =?utf-8?B?dm5BZU42MERZbkNITUJYVnVWYlkwQkhtNUlOVDBVWERKemxpQmNZTzFFYTZz?=
 =?utf-8?B?QVJ3TUxIWWRtWlRUb1UzVy9GdXowRW03WHVDclZYb2s0cWdJL1kxUHdMVmUy?=
 =?utf-8?B?cGM3U2NhcTlDQ1prT3gveG5mOEZWMmtoSW5sQ0JvaHdhelhJdGFUblRZMXVx?=
 =?utf-8?B?OGxqbDR6eEtmcjFjMzlsVC9xQ1paYTEySThiclFBVEtReWVsMUdhdEdHZFV5?=
 =?utf-8?B?TUtZMjkwMUs2QTZIYmVWMVdJalgrSW1BZDFncG03Z0xDUEEyVUNlUGwxMUky?=
 =?utf-8?B?UXZVMFRWRHZPYzBuVDIzRlBtWFFLUGw1MytFaTlUYk1WRjg2aHh5ckxuMERp?=
 =?utf-8?B?K1NJc1J3Q0paU0FhWW5DdTNUdS9Pajd5QUlTTDNVeG9YeTdmSU04enFoZXRy?=
 =?utf-8?B?YnNtMm5HcUdzUVM3ZjVyd2VWMUJrWkFiTjkvcUgvL2xTa3FDdzZ6aU5jZU8v?=
 =?utf-8?B?aTdvbVNibk5EOXVGQWFVNGw2ODhnVC9LcTFQWEZ0WGQzWTRDTjFaRC9OMjFM?=
 =?utf-8?B?NTRZWDRySzZ2cFpjV1FIcHJrRkhObE9kazltdUMvTHAycklGTVQ0c0k1QytF?=
 =?utf-8?Q?R+vRZ9DuS7VBolE8+On1Q/v2N?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b538a90-5d68-414a-3be4-08dde0a5f335
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6048.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2025 11:29:11.4264
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jh7Qh9rslMjAV/81IOXfMRizIkvlX+Qzpa7zxFIP9/ZjMlNJko7tLaHN+M0GD96dPffgJdz15dHYgmbbuYt0wA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB9502

Hi Ashish,


On 7/31/2025 3:25 AM, Ashish Kalra wrote:
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
> The list of MMIO registers locked and which ignore writes after failed
> SNP shutdown are mentioned in the AMD IOMMU specifications below:
> 
> Section 2.12.2.1.
> https://docs.amd.com/v/u/en-US/48882_3.10_PUB
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
> Tested-by: Sairaj Kodilkar <sarunkod@amd.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>

I'd still think introducing ops for various callback makes more sense than
having explicit is_kdump_kernel check everywhere. I am fine with having follow
up patch to fix that. With that and few minor nits below :

Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>


> ---
>  drivers/iommu/amd/amd_iommu_types.h |   5 +
>  drivers/iommu/amd/init.c            | 164 ++++++++++++++++++++++++++--
>  drivers/iommu/amd/iommu.c           |   2 +-
>  3 files changed, 158 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/iommu/amd/amd_iommu_types.h b/drivers/iommu/amd/amd_iommu_types.h
> index 5219d7ddfdaa..8a863cae99db 100644
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
>  
>  #ifdef CONFIG_AMD_IOMMU_DEBUGFS
>  	/* DebugFS Info */
> diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
> index 7b5af6176de9..aae1aa7723a5 100644
> --- a/drivers/iommu/amd/init.c
> +++ b/drivers/iommu/amd/init.c
> @@ -710,6 +710,26 @@ static void __init free_alias_table(struct amd_iommu_pci_seg *pci_seg)
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
> +	 * Currently, previous kernel with SME enabled and kdump kernel
> +	 * with SME support disabled is not supported.
> +	 */> +	phys = __sme_clr(paddr);
> +
> +	if (cc_platform_has(CC_ATTR_HOST_MEM_ENCRYPT))
> +		return (__force void *)ioremap_encrypted(phys, size);
> +	else
> +		return memremap(phys, size, MEMREMAP_WB);
> +}
> +
>  /*
>   * Allocates the command buffer. This buffer is per AMD IOMMU. We can
>   * write commands to that buffer later and the IOMMU will execute them
> @@ -942,8 +962,103 @@ static int iommu_init_ga_log(struct amd_iommu *iommu)
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

IMO this comment is redundant. Its implicit that we have to apply the addr_mask
to get the actual address.

> +	 */
> +	paddr = readq(iommu->mmio_base + MMIO_EVT_BUF_OFFSET) & PM_ADDR_MASK;
> +	iommu->evt_buf = iommu_memremap(paddr, EVT_BUFFER_SIZE);
>  
> -	return iommu->cmd_sem ? 0 : -ENOMEM;
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

ditto.


-Vasant


