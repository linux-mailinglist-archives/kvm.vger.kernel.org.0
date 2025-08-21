Return-Path: <kvm+bounces-55272-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3369AB2F6F9
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 13:45:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 850CC5E788F
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 11:45:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2EF9F2DC321;
	Thu, 21 Aug 2025 11:45:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="U2K9Yivm"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2042.outbound.protection.outlook.com [40.107.223.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEEA838F91;
	Thu, 21 Aug 2025 11:45:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755776744; cv=fail; b=aIuAAGd6EREsIpJIAOKoUvRErOHXzJ5jeALIBJdtgVcFzkG1mXP01ZA4qEAWnXj4vXhTW9UG3auxd0jxCGvVum1Xl6Tx2TU8PdL9GxZSVpprj7ZAolewq24e5nCQ3hVF3bbyMvQTILG4nIOXmTHZO9aw9XaztVsJqPDU9Ac8QtU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755776744; c=relaxed/simple;
	bh=Pw0njIpuPxLdALq02kDBH6pA2zCB9sUV84BupNVUI4I=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=gf08Z/0YP3tXkQyslvc1rOBOuXdBPdUtz+pbSVZ0cIwCWdIsQWyKsDo9eb7b7Hpq+ts8atE40YJbZPDIQqMLoEkTIejxEYoSm/oLQllmXm9iGnlAmhH4zg1h4ekjFdlzm/mLOhvCNmkzMUQGDfCcAgFuwF4lff0Rd13K0VjOEd4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=U2K9Yivm; arc=fail smtp.client-ip=40.107.223.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=R9rTCivnviCrAqkRtcTVBEgbULAW39JsLhmGoH+a8l2I7rRTeavuaApDuH98tqmYECis2jmrtey4B74xkP7RAjktf/1PYCOhNFcwuA2Moe/ae2x+LTIy6ovlBddYMeLj252DoMQOQ0vAJ114MrHa/rIqe6NpCl75Mog12wHXzcBNuESU+MJRiSD5HHbhUCb8k+acVtPTl1/DLEVoxGuhh82dU0cvDL0X6zQa9cOxYOnR2Vw1mzALu2yMaMDiFxIztB0nfPCtac3XuKG6taEAlw0MC09OWSBdPfed7x8CKUdO//udyeEMk96ow+VoIqwS7p5HA/KPrrJv6jfivoQCRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ufov+3BBgoPwXKwszXRxy4bCUt3sOk3r/kNdGZ9tuiE=;
 b=XBLP14rzlz+Zrgjbtfx5t6A2VyMWUfzb5hD9UF5YwV9VQjODYWPPgiRaHfIVdXt7w/2hMpRlttiQ6czYJjr4gcTZpe2H3AWERuUhOuOO2ttojfYtoTxsJY7KvWAZ1cDxy33WHGl7taYUxTJBirqG9GBu4DOUva4/ijXjquupLD1rhvx2xhx1cFBkz6LrEHSh4af6GpiiZv+H9uquj7d+mJ3aBmFD4TUIpQALM9Zd4r9cf7re/Pc69AST0rzW84hGKn1rk7I4QP3Yna0F1kkSjgqeU+GteCMuKUv5yLOyPcTb9HMuliO2tiDU/B3VuOLaIW8dp+GdlwmDl1TtGfOy4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ufov+3BBgoPwXKwszXRxy4bCUt3sOk3r/kNdGZ9tuiE=;
 b=U2K9Yivm50F6Dikl0wVZ4cSj03rPDT67RK3RFOy89O0FC09etOSFuRif0VrC6tA2dyetKkAnQ2VCeJa4x/KO6cXxtwPgwDCe32uMF2vMJvWdE+Jo6iJ5TUUth++ETISYioK3N/Ex+3/g0eXWnmzclQIOOJv3NqMr5CjJMRtonMU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6048.namprd12.prod.outlook.com (2603:10b6:8:9f::5) by
 IA1PR12MB6236.namprd12.prod.outlook.com (2603:10b6:208:3e4::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.14; Thu, 21 Aug
 2025 11:45:38 +0000
Received: from DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5]) by DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5%4]) with mapi id 15.20.9052.013; Thu, 21 Aug 2025
 11:45:37 +0000
Message-ID: <4281e562-0dfa-41a0-bcff-02b7bb1d67ca@amd.com>
Date: Thu, 21 Aug 2025 17:15:27 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 2/4] iommu/amd: Reuse device table for kdump
To: Ashish Kalra <Ashish.Kalra@amd.com>, joro@8bytes.org,
 suravee.suthikulpanit@amd.com, thomas.lendacky@amd.com,
 Sairaj.ArunKodilkar@amd.com, herbert@gondor.apana.org.au
Cc: seanjc@google.com, pbonzini@redhat.com, will@kernel.org,
 robin.murphy@arm.com, john.allen@amd.com, davem@davemloft.net,
 michael.roth@amd.com, iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, kvm@vger.kernel.org
References: <cover.1753911773.git.ashish.kalra@amd.com>
 <5ad4c4525a2fd673cabcc763f0ccdb9b3595aaf4.1753911773.git.ashish.kalra@amd.com>
Content-Language: en-US
From: Vasant Hegde <vasant.hegde@amd.com>
In-Reply-To: <5ad4c4525a2fd673cabcc763f0ccdb9b3595aaf4.1753911773.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN4PR01CA0106.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:266::8) To DS7PR12MB6048.namprd12.prod.outlook.com
 (2603:10b6:8:9f::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6048:EE_|IA1PR12MB6236:EE_
X-MS-Office365-Filtering-Correlation-Id: 6cd51b77-c684-4413-9331-08dde0a83ef7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Z1VQUXc4bHhmazVFNVcwcjRqZVlZQkhpYWw0aU5GUU0ybngwN2FpQ0VSallZ?=
 =?utf-8?B?YXpNNlk4YWI3TnJPbGlVZ0NQQllXWVc0c2dUMVRYQ2xRaFVIeWZ1MElma2JJ?=
 =?utf-8?B?YnNIcXJ4UXZDOThUTi9iaTRHZGVOQnBVQU5DcUtuWG1Bcm9XOFBlTGMrb3h6?=
 =?utf-8?B?QXh0TzZZRExqdmRncGRNb0lteUxKczIwSjJ2SVI3U3FCV1lkU29Ua0Q3cUVK?=
 =?utf-8?B?ODYxSEk1dXlLb1pMQTZVMkN6MnRseEk4QVVSd3AzS2xvS0hWcDcrbjdPaFJm?=
 =?utf-8?B?emJlQzlUdFRwZlZrbVFJdTVzUDRPRS9heEVDV3I3MmxKcEJaRnBMdU90d3U4?=
 =?utf-8?B?S0lkbldhWld6eTgrbzJkM0ZuajNLRDFLanpjbUdGc3Vpb2ptQXdFZEcvdVMw?=
 =?utf-8?B?YWJ2MVFYSi8xaHV4YVdkL2dDZHRPNzMxSlRCL3JRSjhTNlZxbFFGRHZ0NXB5?=
 =?utf-8?B?YTM0RkEzOHFPSm1CNHJPemdJU0ZxbisvUCtEWVdncFM3cEU3S3VrSHU1Z0F5?=
 =?utf-8?B?OHNFTXdtVFFHQ2tJYktCaDBUUHJ1R01EbEpHaldRV042QXRna0h3OVNxL1dq?=
 =?utf-8?B?bWRrcysrb25VN1J6K0FOM2plVzFNMDBjdUVibGQwWDFwREM3dXZDYzF5U1d6?=
 =?utf-8?B?ZDFRMURJQTJ5MmMvSTJuaXlkYlhsc1ZYRm9OM3B4VjNVd3VjZFBFaHpCWnkz?=
 =?utf-8?B?TFpVRlowRlNobFVpbnZVbGc4MXBaaVZOeUhjSjRmc0gwMEo5U1ZpTFJRc01K?=
 =?utf-8?B?c0YrMnBvSTlzcDFjZVJGSzFNK1BSOEpKMlFBa25HWTV2WlFwcURuT0Y3SllH?=
 =?utf-8?B?TUJMUFNpMGRHc3JuMnd3cHBhMEZvck9qcDgrazdYRnJEVXUrM3c0dFJJLy84?=
 =?utf-8?B?SXF0R1MwVXdsckk2TlRGU1JGYkN4cmpObklGMmZlc3JuNWpWcjZCRDhiVmpi?=
 =?utf-8?B?MThjMjN1S1lHVUNUcUNQbGVFRlNFM1dJcktNMXphb2M0SXdic1BlcGlYQXVC?=
 =?utf-8?B?cUl3bEllS0hvM25MZDlpTlUvK3FMTVJ6MUFHcjZPUzAyRmZ4K2VJQnM1Q0da?=
 =?utf-8?B?Ym5HdjM4WEt6c0orNzc1ajFKMjNmOHArOFZEdE9sNStJMDRCakQybk96YkFp?=
 =?utf-8?B?QWc1WGgwNkt2bkZaV0Y4VUJZWnJjZC9tT044MGk3ZW9ScG44STFBSWlWb1RJ?=
 =?utf-8?B?RmpjMG1XS003WmJ2aGoxbXM0ZnpUK0dBbUNwNHZFZTBQWXFWSUpOd0xmeTQz?=
 =?utf-8?B?bWFyMGZEbEw2WTkxeDA1THRYRENUSnFiZmZJSmhjQktEN2JvZHg5K2VQaCsx?=
 =?utf-8?B?K3d4dHo4dkw0ZXRLUFEvRFI1Y0YySmREeVBkdjB2NWgvU1BaTWppbVZSMHVs?=
 =?utf-8?B?NUM1dW56R0pjRFdFSFFiOTFTaEppNTdlQ1RYc2ROY2VueEo2ZzdvemplNnVG?=
 =?utf-8?B?WTFKNXJFQkg3dUNtb213OHpZZVhvbGtOTytPSDh2MUFNaENHNGlBeEpyYXBR?=
 =?utf-8?B?N1R1V1BCdXIweUxYWGNvNkJxUSs0ZWxYT01kcEpDYTFGenlvMndQVkovYTRH?=
 =?utf-8?B?OXhSVnpITk50a2tJQ2R4R3E5SE9DajJBc2xRc0VVZ1Z1MHdhdWV0UHJQOUIy?=
 =?utf-8?B?NnMxUnhjUUJ4SmpkSlBUZEVJTTNHejNKcHZmckFVclZZRjU1NjE0bzZpYlU0?=
 =?utf-8?B?MG9hYVUxQ2xmcVJzYmNMSk92Z3djbVRqRjVSZjlnMXBpZ21JQldPZnRPZmlC?=
 =?utf-8?B?N1NvcVBRVkQ1TjdkbncwcWVEakJXKzV1OGpJT3FyVmI4ckg2Q28yUmh0SzFu?=
 =?utf-8?B?RXRtZi9pRWxXeUNyZm4rZTdFRTg2Zmd6UVRYWUE1WVFGWnM3VkliZTg3MDFU?=
 =?utf-8?B?SXVKcXFpd3lNVTBqUFZwaEs4SmJ4NmthSExFbmRRcG9qYnp1NHJJbmdWdzRn?=
 =?utf-8?Q?N6QFo7KxZEo=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6048.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TThwT0Y2U0tPdDZYOVg1aWxYV1ExMUFTL2hTcjNGWmNONXBQanFISjJQTUky?=
 =?utf-8?B?Sk9idnBselg1dmtqbWdWZTlVaWFEVW1ySTlUcnFjZ0ptT2pQN0NKd2ZDVlpG?=
 =?utf-8?B?M1lMYzcwcVFxbTlxM0JMQXFzdXduaXBZVGxsQ0VHbjczK0s5QTVRanBXN0gr?=
 =?utf-8?B?ZXJmazBjdkRqNWdCMkJNZ3BzdTdBQ0k3azN0YlVRRUh2WnhCVnB1KzZEbk96?=
 =?utf-8?B?aGNvWUdnOXhWelMzaWx5OTBhSi9HQzJYUVI4MnhQOHFra0hmZWl3bjNtYlc5?=
 =?utf-8?B?SWNKS0RNUlRsWUc4L2tLSjRENUppdWtabnEyQTh1enBkOVF2VDRyRDF0NFR3?=
 =?utf-8?B?M2pzMDkxbll1Y1BmY1RlRzR0S2xVQmdpY0tmb2s5akgxMzEzSG1xS2l5cjFo?=
 =?utf-8?B?MDkxUTdQZi9PNzRhd0FxU3lPT2o1QnZyMTRNNHZlazJmaHVxZGFJK1FJa2xz?=
 =?utf-8?B?V1FoYjhDS2t6ckpzT2NCeXpqbndoT1BkUUd2S0VLVm9DTmVtRUgxa2lUV2Rl?=
 =?utf-8?B?TzVPU1g4aG93TloxN3JrNkorL3o4dHVJelZLN0dmd1hNTTBtTTZYUUxXb3hI?=
 =?utf-8?B?NVRISWpubEk3Q01pWjUvd0x0c1k2bkg1a3doZlExZ09GSmxNNWF1SFlWVGpt?=
 =?utf-8?B?aE5oSEJONGN4L3g1UWRDNG5ZdmQ0NXdYZEl1SlpXT2w5RjFmRjFsWHg2dFZF?=
 =?utf-8?B?Tm1RTFhYcnQxRzhsZEMrSU81elhzUUsvcGRPUzJjd3BSTExSc21kWW9GdFFv?=
 =?utf-8?B?bmE2cXVUbC95YTE5Q2dRaXJONldWK3Z6K0JuWnZGaFdQL3BXSWRwQnMrbUNw?=
 =?utf-8?B?WSswT3RCRlpyMzhaejVVRXVVcEwydVRpT2xLTVlUZjgyblZIQm5oeGVpRjZt?=
 =?utf-8?B?a0QxR1VRWTdhbnFBbjFaejlMYUxWN0U1NHRYQlhFQUdScnJzUWZQYXBib3N6?=
 =?utf-8?B?TUhIL1MzMVdEc1JSajBzdThJdHNCM3ZIVDA1WmVsbElsbS9HOUN2aEN6Ymty?=
 =?utf-8?B?MmRrM294bDFObXd3Ymp3b1d3NjJZdnUxR1FpeUM4aC9kWUkrMmJxaXhJMytz?=
 =?utf-8?B?S1ZxOWVQVHZCVGhWalE3di9tOE5uaFUwZktsTkRSOG9pTDFXd2dZdGRmUlB6?=
 =?utf-8?B?RCt0K1A0OS9MREJBM1FaSFgzZERXQUJTa2NSeG45eTgvUzkwd1J6aU80dk5o?=
 =?utf-8?B?by8wQjczaVpxWDVsMTNjZXd4ZWhOVFpETHBIZG4zWFk4c1hzbnZOa2FvRmly?=
 =?utf-8?B?TGNlZklldFRiNnZCdnZyVWd6QW5DNkw1cGZJeFZTWDg1V0tqa0Z0YTQxVDRi?=
 =?utf-8?B?aFM0MlRqd2JvT1BTNGtLdkJpc295blNqMDRQeU1haStCdWNGeE5sUlp1OXpS?=
 =?utf-8?B?N3FSa1dLbzFEQkZrNHVlcnYwRTMxTCt2VGhTYklwR3lwOS9FME9Ya2FQSmJV?=
 =?utf-8?B?U2JRa3pVRmxTL1dYUmFNNXNkMS9adFo3aTNnOHdyRDlqSVE1aEJ5bExpaWR0?=
 =?utf-8?B?bG9QaDUxNWhqUHZCNzR2RFVMYlZmM3NqY0l6SWxoeHJmbWhTRHRyQUhwbFpm?=
 =?utf-8?B?TTdDMHBUb0k4eEcvUEhCWGYzMkY1aUNaeWRxMEMwTzhPZm4wcUwxaG1NcU1F?=
 =?utf-8?B?TExZaTAwK2h0Z2JNa2I4eHNZMUxva0NteHgvSXF6Z3ExVmFOMjlhKzNuaFZP?=
 =?utf-8?B?UzhUNnlXeVBMczRmRWtnbEdQSFhlNmVNTlZZREIxMVIzMmNHWlI5VFEzbGN3?=
 =?utf-8?B?eitESzJhOGJhVW5GS1djbXdUTlM3bzc3bEhtZ3NYbjJYc1M0anRJc3RkQXFN?=
 =?utf-8?B?Z0hxZzJNUnJyM1JZeXk0UDVZS0wxa0I2NDlGY1h6T3hBZ0sxNm5TRWtibmNv?=
 =?utf-8?B?V0craUNiK2F4b3k2bTJPTFFadE95YWZHZVJlcVkwc1p2VWNIWXBFaHBmSGph?=
 =?utf-8?B?TVdlOHVZL3MyS1Axd0MzeFd4VWp3U0piVmh0K2hJd0JNT1EyMlRQeit5bS9Y?=
 =?utf-8?B?UlM0VHdFYWRBYWVXZVhka3BaNW9RS21XWmZTNzJpUGs1d3gweXJtSE1zSVFY?=
 =?utf-8?B?aVI5RFRtbm9DaDh6bHZZR3JjaG1WQ1hDZ1laQWJlYktpU2lRWm5wYmVhdkFu?=
 =?utf-8?Q?1hT9ke/Gyg8vbPkCLGOe8HKxT?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6cd51b77-c684-4413-9331-08dde0a83ef7
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6048.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2025 11:45:37.6388
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oed4N4X8V8OHZNPDv2+G50BIUvZhepLXVYr6NNr66gXl1wtdjcaeKuqrIgmSQiJj4wW5Ekq+p0nNhezWnpD49g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6236



On 7/31/2025 3:26 AM, Ashish Kalra wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> After a panic if SNP is enabled in the previous kernel then the kdump
> kernel boots with IOMMU SNP enforcement still enabled.
> 
> IOMMU device table register is locked and exclusive to the previous
> kernel. Attempts to copy old device table from the previous kernel
> fails in kdump kernel as hardware ignores writes to the locked device
> table base address register as per AMD IOMMU spec Section 2.12.2.1.
> 

Can you please expand and add something like below so that actually issue is clear.

This causes the IOMMU driver (OS) and the hardware to reference different memory
locations. As a result, the IOMMU hardware cannot process the command.




> This results in repeated "Completion-Wait loop timed out" errors and a
> second kernel panic: "Kernel panic - not syncing: timer doesn't work
> through Interrupt-remapped IO-APIC".
> 
> Reuse device table instead of copying device table in case of kdump
> boot and remove all copying device table code.
>  
> Tested-by: Sairaj Kodilkar <sarunkod@amd.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>


Few minor nits. Otherwise patch looks ok.

Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>


> ---
>  drivers/iommu/amd/init.c | 106 +++++++++++++--------------------------
>  1 file changed, 36 insertions(+), 70 deletions(-)
> 
> diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
> index aae1aa7723a5..05d9c1764883 100644
> --- a/drivers/iommu/amd/init.c
> +++ b/drivers/iommu/amd/init.c
> @@ -406,6 +406,9 @@ static void iommu_set_device_table(struct amd_iommu *iommu)
>  
>  	BUG_ON(iommu->mmio_base == NULL);
>  
> +	if (is_kdump_kernel())
> +		return;
> +
>  	entry = iommu_virt_to_phys(dev_table);
>  	entry |= (dev_table_size >> 12) - 1;
>  	memcpy_toio(iommu->mmio_base + MMIO_DEV_TABLE_OFFSET,
> @@ -646,7 +649,10 @@ static inline int __init alloc_dev_table(struct amd_iommu_pci_seg *pci_seg)
>  
>  static inline void free_dev_table(struct amd_iommu_pci_seg *pci_seg)
>  {
> -	iommu_free_pages(pci_seg->dev_table);
> +	if (is_kdump_kernel())
> +		memunmap((void *)pci_seg->dev_table);
> +	else
> +		iommu_free_pages(pci_seg->dev_table);
>  	pci_seg->dev_table = NULL;
>  }
>  
> @@ -1129,15 +1135,12 @@ static void set_dte_bit(struct dev_table_entry *dte, u8 bit)
>  	dte->data[i] |= (1UL << _bit);
>  }
>  
> -static bool __copy_device_table(struct amd_iommu *iommu)
> +static bool __reuse_device_table(struct amd_iommu *iommu)
>  {
> -	u64 int_ctl, int_tab_len, entry = 0;
>  	struct amd_iommu_pci_seg *pci_seg = iommu->pci_seg;
> -	struct dev_table_entry *old_devtb = NULL;
> -	u32 lo, hi, devid, old_devtb_size;
> +	u32 lo, hi, old_devtb_size;
>  	phys_addr_t old_devtb_phys;
> -	u16 dom_id, dte_v, irq_v;
> -	u64 tmp;
> +	u64 entry;
>  
>  	/* Each IOMMU use separate device table with the same size */
>  	lo = readl(iommu->mmio_base + MMIO_DEV_TABLE_OFFSET);
> @@ -1162,66 +1165,22 @@ static bool __copy_device_table(struct amd_iommu *iommu)
>  		pr_err("The address of old device table is above 4G, not trustworthy!\n");
>  		return false;
>  	}
> -	old_devtb = (cc_platform_has(CC_ATTR_HOST_MEM_ENCRYPT) && is_kdump_kernel())
> -		    ? (__force void *)ioremap_encrypted(old_devtb_phys,
> -							pci_seg->dev_table_size)
> -		    : memremap(old_devtb_phys, pci_seg->dev_table_size, MEMREMAP_WB);
> -
> -	if (!old_devtb)
> -		return false;
>  
> -	pci_seg->old_dev_tbl_cpy = iommu_alloc_pages_sz(
> -		GFP_KERNEL | GFP_DMA32, pci_seg->dev_table_size);
> +	/*
> +	 * IOMMU Device Table Base Address MMIO register is locked
> +	 * if SNP is enabled during kdump, reuse the previous kernel's
> +	 * device table.

Can you please reword as its reusing crash kernel device table in all scenarios ?

-Vasant


