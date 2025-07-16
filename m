Return-Path: <kvm+bounces-52669-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8BB0BB08037
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 00:07:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 720E93BF93F
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 22:07:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E8212EE600;
	Wed, 16 Jul 2025 22:07:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="T3mC9kav"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2087.outbound.protection.outlook.com [40.107.93.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA780EACE;
	Wed, 16 Jul 2025 22:07:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.87
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752703654; cv=fail; b=scH1fp/r84kGLjzbYHFZdJWbiUowk0Liux7qnpa8rL1OPI6vkfjt4tTh/6tg8eRaDjgcWBS+vswLr/OmBAtP/Bgi9YCnvhOL9C/dhe3qgZXnVkqn9bRQS6yPGhDsHpU23D07AM8EazruylhSuHw7koY9pFISA0+lwFqBNfTdVPE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752703654; c=relaxed/simple;
	bh=B3K3eeckamuq4iXdSt1NMK25VjwJwXP0jr8IfKWm0xY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ZyVumMuqjwyLxnzsQDB8cOzZzL/3CD3qIPG/AA2XSRxv4EbDBodmTnuJAfaCMsidBw+DWhLjuZPBfxCrqKu3wcAcv09LVRtBw003beR1Ar+hbmWVUIIDvCt99KsMtKJxSJWiEQw2pN1iKH06nPoVenPdm2YVkMYMKsHBe1LSP14=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=T3mC9kav; arc=fail smtp.client-ip=40.107.93.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UJ7br0eQwDXtCKmsAw1ueMrVrkADG9mmZJMRNmqt9as4M+XDsOVgvicJHYvOLqeAijqPMZTBfP/mMJ7pGOf+JrsB9jf49Ahem4RKRIn6H6XmLxGJtGdYsHJKdm9GJYPvehT2dXxXPveF+WKVKSOIIQzfCOvGBjNuT7IiRj47oxMKKSGZoq7LWHdVQ3/82HQHFyFE1MBih8sMvjRe9BOv9/lLRRdC7xUydVEYN9x+XcjK+bN0SedLQ6gaM+ki0QsRj8tZJ8sOGvkR1DVP/mYCRIn2yXwHUm4WF6Pqf3mOEmlZhK6oVfLC1Nu+2Gt+wrKrenwUAXV4wvUyx/H3H9ZNZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XeWJ+Aq+TmVAtjCgOsZ+dOatrP1GFDVKzRUa7Oq0tnE=;
 b=Vk6+ng/Z+xp0j9MxVbu7axLaSvNGt1Pp/9aOWuPX33Bvr4eSbE7AKSC9i7yQLd3lbqT3I4RlVTcoTAfjMvnfguiqzZLYK8V1g+jztnrGGraN13Oka6icxqyp4Utw0CcJian2HO/Bq9ZFDXC/W06vHRm90n487Q9jjb23Bk9qkjXwPXyI8Q6FSQxVa9ViaEIiR3oiGELIdxRW/YZfDfvqLinEtabKERkkk5zOlClzDs+pzibdaeU7pW6Pl2e5XgNaTr0bQbhsAso8x+xW119k2TTy7lEGkfPqxAFNMaeY1gISfPaXK+ihJTiFXl7Flcr6GSMQzDToux3Npk6qsdOy4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XeWJ+Aq+TmVAtjCgOsZ+dOatrP1GFDVKzRUa7Oq0tnE=;
 b=T3mC9kavAf8OaQ51dZVW0FGEe5C5JVhZ0sRg67Tw3neR02prK4FnKtMrZwsBRjS81KH3LY5Y9pCzMCbqtFJWO67RaBGsv2tierHQo9yc/jIST+QAnUq9pWTlnW9HVaYgMr+TUBbYVHDPq0l+6bQ4slG9kY/XomTtrl6unzGGHcw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by SJ0PR12MB8613.namprd12.prod.outlook.com (2603:10b6:a03:44d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.26; Wed, 16 Jul
 2025 22:07:29 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad%6]) with mapi id 15.20.8901.024; Wed, 16 Jul 2025
 22:07:29 +0000
Message-ID: <7f08c03f-a618-4ea4-ab57-f7078afe49c9@amd.com>
Date: Wed, 16 Jul 2025 17:07:25 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/4] iommu/amd: Reuse device table for kdump
To: Vasant Hegde <vasant.hegde@amd.com>, joro@8bytes.org,
 suravee.suthikulpanit@amd.com, thomas.lendacky@amd.com,
 Sairaj.ArunKodilkar@amd.com, herbert@gondor.apana.org.au
Cc: seanjc@google.com, pbonzini@redhat.com, will@kernel.org,
 robin.murphy@arm.com, john.allen@amd.com, davem@davemloft.net, bp@alien8.de,
 michael.roth@amd.com, iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, kvm@vger.kernel.org
References: <cover.1752605725.git.ashish.kalra@amd.com>
 <42842f0455c1439327aaa593ef22576ef97c16ee.1752605725.git.ashish.kalra@amd.com>
 <7db3a4b2-dff6-4391-a642-b4c374646ca7@amd.com>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <7db3a4b2-dff6-4391-a642-b4c374646ca7@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA0PR12CA0011.namprd12.prod.outlook.com
 (2603:10b6:806:6f::16) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|SJ0PR12MB8613:EE_
X-MS-Office365-Filtering-Correlation-Id: 37a44ccd-6b96-4e00-9533-08ddc4b527d6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?YzBDZ3BGTjJ6d3VvVGczZGltbWVYbG82NERvT0hyS3hMeXhWTlhjeTdoTGhs?=
 =?utf-8?B?Q25tZXExek81WXFnanlhQlVmVUFtakU1Nkp1TmJQUi9lY0dIRzh5ZHF2S3ZP?=
 =?utf-8?B?ZGk4TWNzdXRFeUpTWENxQ0lHY29Wd0JHN3NJRWJGVmYxTTg3VGNuNERSQW52?=
 =?utf-8?B?a0d0T2cvOUI2eHBlVnlBWm00M0tCbUtyRGp6N1JZOU9JTkRrUnBvbktXWkoz?=
 =?utf-8?B?cHlZaUQ5eGdLenJQUzh1QU9nQ2tlSzFkc2J1ZGdiZUo4ZUc3dG90d0w1cWN0?=
 =?utf-8?B?YzNVeG5FbjJZazA2dzBUZVdkVk5NR1FrL2hoNGtZOS9URnpHeENqOXk2S3R5?=
 =?utf-8?B?ZFRHV3pkREJkSm1GcUFoMXpiNVV2T1pFOURJRVVJYzgxSVdvMXl5eGpaRlNQ?=
 =?utf-8?B?WUFzOXBRMncxSVJveHgvQk14M1E4TE1DZmI3clU4UVo1bEVZd0FoYU1kT3hD?=
 =?utf-8?B?MFJKbmp5cnIxUXNEalY0R3VpWklLTnRuZnk2N3E5cld0dC8vUlloWEd5R3Vt?=
 =?utf-8?B?YzFZK1NsUWR0NmljYTJrWmtRMlNmcWpTM3I0U0VuejM1dFF0bERUMGlJcHh2?=
 =?utf-8?B?anplYjhRTGFxOVJkU2FTK1B6bVM2UEdpUUhkK0Z3V1gwOEpqVVBpYUtKU0JB?=
 =?utf-8?B?b3VZTmZSSWNrdGZEKzI2Mmc2QUlOR2FOU05DZGxyWHl1R1dQdnB2VjJwUEE1?=
 =?utf-8?B?NndZWUtBTk9vVXFLbXUzV3pLUkZsQjVpM3hLRDBqVjF3VkVSSk5HRFZlRmJN?=
 =?utf-8?B?M3Fob2YxQ1JzejQxdWtXdFV5Q01MN3NsVVA2MU5OUGRVMTZFb0lldU5Cd1Js?=
 =?utf-8?B?TnZxdXEyd3Y2b1d4RGQyZ1kwdThscmFFR01Vblo5TTR4UkdPaVRVMG41WDU0?=
 =?utf-8?B?d1hzY3htZEpoMFZjVUR4TTc2UXoxcXF5eU5Nc1dlbWhoSkhmSmxDT1daK0hR?=
 =?utf-8?B?blhqcWhVaDV4ZVY2alZxWUUza0JTWThRaG1mc2lXSEhSUGRXT2t2aXAzdlpv?=
 =?utf-8?B?ZmkyanJJTHZ0OVo0WERKSEoyM0FWcEJQL2xjajZLbGhVRkJKVnF4RktLZWV2?=
 =?utf-8?B?Q09aWkg1L2ZGZGJObFozWmlLWjF3SmdTR3B6dER3cnhwSFZVRFFLbG01bzlh?=
 =?utf-8?B?YXlsd0owTHRzaTN1T1pzSDhnaE5uREtoYmk5NjNLdXd0NjlYeDhKdzJUb0NS?=
 =?utf-8?B?dzJMbzVpeFdYdXRFV0pJYjFsYjcxKzZrTDl6TW5DcjFTSnJaVFA4Wkd2dE1N?=
 =?utf-8?B?N1lYU1lvTlNjSGNXRWZJamFjWDVJeVhwUElDaDYwNVQ2VnRyNjRpL0psZHBW?=
 =?utf-8?B?UzZNWWpNcGM5NjZmUWtFR2N2Z0FDTGw4VlRRL28za0FyQkJkMGtJdVZWSi9a?=
 =?utf-8?B?ckNVelFsdzVXN0tnTEg1Mys5OFk5MHdKV0tMTS9qeEtpZE8vREVyeCtHckJj?=
 =?utf-8?B?V1AwYmVCaHlsczN1SThMYk5PeDVIR1QzQlp1K05FVWIzZjBRWlFGa0U2UXRL?=
 =?utf-8?B?c3dRZ05lYW5BS3VWcW9NMXFyazBGaElNZktnbDFnMWprV3ZUeXI4V1l5RXAx?=
 =?utf-8?B?bFNVSlpwdlM3WFJnaklYTkx5SzhYV0JrK3Z0UTU0Q1FaaVNFOW90R1M0a0VU?=
 =?utf-8?B?a2taZEJkbmhkRWxRZkZYZ1A2RTRLazVsTlhvTTlYYzlpYURHVnpKNEpXZGJ4?=
 =?utf-8?B?Yjk3VGgzOStrUTNDQmRGcTRzODR0YVFhazRTZ0pVWEJKSXRNT05DcGFIaXR2?=
 =?utf-8?B?cDdqRk1YMTdDWUhXVWpBa0s4YjljMThEc0xsTE9sRGlKaXJNaWgwYUNMdjFy?=
 =?utf-8?B?M2pCYVRrd0FreGJON2drZVV4bjM5ZVFDTDJFZyszbFJzaDIyM0hDOXdyKzRx?=
 =?utf-8?B?cG1QQlUwSEdYdUFaazdONlhBMjR4eFYveVl3eEdvNE80YkRXd0JETDZ4dlk2?=
 =?utf-8?Q?z9tJhA6FvKQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UENtOXNLTEtQbDFtRVdFM1dLemFmNGdlQ1hSTWZBcjFkeWxlUEZtVDdsODNL?=
 =?utf-8?B?d1JPOTRkdUZXenIvU1N3bGEwOEo0T3JlVVBiQzF6cnBsR0dpVDhkMlBoN3g5?=
 =?utf-8?B?Nkhxb0d5SDhnVnlFYlpFeG5uSXVjZi96ZnArWXVqdmdsdGRNNEZnMk10bFpy?=
 =?utf-8?B?TVRxRjdrc0dtVFpvTnFHSGFxV0NhWWNjc3FFSHNWVTF3LzJ3R0pYeWhleExL?=
 =?utf-8?B?UzFMZjFzeHJ1dUJQNmJyanVua0tOU0J2cGM2Z2pTb3Zxcy93SW1KMEVVZ09k?=
 =?utf-8?B?SERUcTNhZUFjVjYycmVMNms5aFdzVVlVcmg1YjdoYmF3Y0dFRnVXVncxNHhy?=
 =?utf-8?B?UVg2VURZdkVGcEJFQ2VFdzVveGNBTE93TDRGejJ1VURadGFBTEp3Q3laMTcw?=
 =?utf-8?B?KzJZVG1hK3FYTXZQRUluQlNWY2dOaW1HWFVBMkNPUDI0M3FQRldjeDB2QjJp?=
 =?utf-8?B?TGYwWEdZM00ydEJkamR2eXdsdE82UFd6VFZBVDdLSUNqZi9USk1sbUtuOXM0?=
 =?utf-8?B?SjgrbGsyUWpUTnkxLzJYSlpnTUg5TkJTekFrTEt2NjF0UytTUFBOT3BEWWJw?=
 =?utf-8?B?OEd4eUpMblVwRXlqbXM1V1dZWjhwRWNFU1lvNFkxb05Hcko1N1EzVE1uT2RP?=
 =?utf-8?B?bWFNcjVzWEcvS1hwOW5GeDJldjV5dXFPQi9vL1RqMDBrR0FDdHNqTTQrekw2?=
 =?utf-8?B?WGROOHpCL0VrSTc3eWZMSXRNczR0dnRqR1dpQmJQR0hTdTV3K0NlRldNYk9D?=
 =?utf-8?B?T0s1OW0xWlBPdFpTVzlXUC9abTVvMmtkRlp4NnF2MkpDeXpJbUxiNWdrZktO?=
 =?utf-8?B?eDhuUzJ0d3lpRjJpR3NjRjVoVndLcS9BUzdaQm84RFJ2KzNTeFUwMGo1bGc1?=
 =?utf-8?B?UkJzLzdxNVJRc3J1QmVuVlNaa0hVd0ZrRW9XQTF0SmdoUWZDQ1pjRmUwN2E2?=
 =?utf-8?B?YzJmclVVNnVwT2plWXhxNis0cmZNQXNnbmJzMnpLNWUwd0NvbEpIUy8zZCs3?=
 =?utf-8?B?dVA3VXpCRGZHRUpvN2ZXSGtFN2FrOU5VWlc1Tk1pQ2VXbFZGcjRCMGxOS1lD?=
 =?utf-8?B?Tm91eThuYTNBVFFOZjBEU3RHWklBaU15azdrazlZMWFGbHpTbnIvcWF1aitS?=
 =?utf-8?B?NFdjWCtYbXUyc1BiZzZDSXU4WjduR3hFbzltUUxrbXhsMzY5NmdZdTNFdGZr?=
 =?utf-8?B?bzV6MXVZS3YwVHpPaXczWU56eTdGNkF0eHZQSmhaSEJPcjFHcEwycEVITlpO?=
 =?utf-8?B?NTR0THdDTEZzWHJnOHdPZHhza21QYUtLZjVPUnRYNGI5dTB6TFlDckJiQU8w?=
 =?utf-8?B?MlhybkdpSzI3WU1PSFkrclMyUHhRRnFWRHFQeXIvR1doNnNxeDZWSUVkMDNC?=
 =?utf-8?B?TmloOThZS2h4UkNtajZQV2Ridk5xOGptZTBjbEZ1VGdGYUt6bFNka1VFTFZB?=
 =?utf-8?B?SGhBRURVMTc0ZEhOR0VwdG1nZTYzUVpUc2hMSFZHQXNmb1NtZXp1RWh4Z1JJ?=
 =?utf-8?B?TFlib2JxUUVXcGN5L0lvbFh2WGsxOEJLQjI0M08rUGNtRTBtUno5SDlOREhQ?=
 =?utf-8?B?RWlIVHJCZEdWSFlwaDNPOHoyYWZCYXJ4RzFmSy9aa2RjSExVWC81OHd0cnVV?=
 =?utf-8?B?NzZJTTZsbzREOCttZitoSWxjblh5Y3l5Qm13SmtmQklvZ0ZKSC9zUzk2RzI5?=
 =?utf-8?B?emJ4bktmMHZNalNrRWZhQnlycGZrRXZMRSttbEZJTStZSXM5anl6K0UzQjEw?=
 =?utf-8?B?LzJMK1VncEkzZmtpMkhqRzFGWG1oUGw3UGZUU0V4Q24ycHorTFNTY3Y5RC9T?=
 =?utf-8?B?Nm00Rys5QUZaSnNqOWMwTUNxSVlWM0Y1elNYQlZMSnFmQ3R2eE9Temt3WFFH?=
 =?utf-8?B?N3ZBWE55NzFFQVoyOXllb1NTZllRTk05K0E1NnFROHZIN2JXWEI0QWNyNzJJ?=
 =?utf-8?B?WGx6eDRYRVczeE5naVF2MWFKZXZXTzJzSTI2bzRySkpCT1hjSlVEWkx4azdK?=
 =?utf-8?B?WU5CM09yYTFOUWxCT3c5QkNjWXowOXhuT0t4UVhqR0tQd01tWWhsdVZPZWIr?=
 =?utf-8?B?R2tBaTlYbUUxNkRGMG4wZCtHTjlhZTg1NnA3Q2I0Z0ppaGFab29pYStES2Vu?=
 =?utf-8?Q?17ZdAQk9kV2HvQyGjFfYDc0A6?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37a44ccd-6b96-4e00-9533-08ddc4b527d6
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2025 22:07:29.6050
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s33YVPG2rJpLpK34g/rSR7qr13ktKH0mq417vrcNgKHxmj1tbxxcwQf2r7yI8AySmMtoU5ZvgkBNjxEi+YoEBg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB8613

Hello Vasant,

On 7/16/2025 4:42 AM, Vasant Hegde wrote:
> 
> 
> On 7/16/2025 12:57 AM, Ashish Kalra wrote:
>> From: Ashish Kalra <ashish.kalra@amd.com>
>>
>> After a panic if SNP is enabled in the previous kernel then the kdump
>> kernel boots with IOMMU SNP enforcement still enabled.
>>
>> IOMMU device table register is locked and exclusive to the previous
>> kernel. Attempts to copy old device table from the previous kernel
>> fails in kdump kernel as hardware ignores writes to the locked device
>> table base address register as per AMD IOMMU spec Section 2.12.2.1.
>>
>> This results in repeated "Completion-Wait loop timed out" errors and a
>> second kernel panic: "Kernel panic - not syncing: timer doesn't work
>> through Interrupt-remapped IO-APIC".
>>
>> Reuse device table instead of copying device table in case of kdump
>> boot and remove all copying device table code.
>>
>> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
>> ---
>>  drivers/iommu/amd/init.c | 97 ++++++++++++----------------------------
>>  1 file changed, 28 insertions(+), 69 deletions(-)
>>
>> diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
>> index 32295f26be1b..18bd869a82d9 100644
>> --- a/drivers/iommu/amd/init.c
>> +++ b/drivers/iommu/amd/init.c
>> @@ -406,6 +406,9 @@ static void iommu_set_device_table(struct amd_iommu *iommu)
>>  
>>  	BUG_ON(iommu->mmio_base == NULL);
>>  
>> +	if (is_kdump_kernel())
> 
> This is fine.. but its becoming too many places with kdump check! I don't know
> what is the better way here.
> Is it worth to keep it like this -OR- add say iommu ops that way during init we
> check is_kdump_kernel() and adjust the ops ?
> 
> @Joerg, any preference?
> 
> 
>> +		return;
>> +
>>  	entry = iommu_virt_to_phys(dev_table);
>>  	entry |= (dev_table_size >> 12) - 1;
>>  	memcpy_toio(iommu->mmio_base + MMIO_DEV_TABLE_OFFSET,
>> @@ -646,7 +649,10 @@ static inline int __init alloc_dev_table(struct amd_iommu_pci_seg *pci_seg)
>>  
>>  static inline void free_dev_table(struct amd_iommu_pci_seg *pci_seg)
>>  {
>> -	iommu_free_pages(pci_seg->dev_table);
>> +	if (is_kdump_kernel())
>> +		memunmap((void *)pci_seg->dev_table);
>> +	else
>> +		iommu_free_pages(pci_seg->dev_table);
>>  	pci_seg->dev_table = NULL;
>>  }
>>  
>> @@ -1128,15 +1134,12 @@ static void set_dte_bit(struct dev_table_entry *dte, u8 bit)
>>  	dte->data[i] |= (1UL << _bit);
>>  }
>>  
>> -static bool __copy_device_table(struct amd_iommu *iommu)
>> +static bool __reuse_device_table(struct amd_iommu *iommu)
>>  {
>> -	u64 int_ctl, int_tab_len, entry = 0;
>>  	struct amd_iommu_pci_seg *pci_seg = iommu->pci_seg;
>> -	struct dev_table_entry *old_devtb = NULL;
>> -	u32 lo, hi, devid, old_devtb_size;
>> +	u32 lo, hi, old_devtb_size;
>>  	phys_addr_t old_devtb_phys;
>> -	u16 dom_id, dte_v, irq_v;
>> -	u64 tmp;
>> +	u64 entry;
>>  
>>  	/* Each IOMMU use separate device table with the same size */
>>  	lo = readl(iommu->mmio_base + MMIO_DEV_TABLE_OFFSET);
>> @@ -1161,66 +1164,22 @@ static bool __copy_device_table(struct amd_iommu *iommu)
>>  		pr_err("The address of old device table is above 4G, not trustworthy!\n");
>>  		return false;
>>  	}
>> -	old_devtb = (cc_platform_has(CC_ATTR_HOST_MEM_ENCRYPT) && is_kdump_kernel())
>> -		    ? (__force void *)ioremap_encrypted(old_devtb_phys,
>> -							pci_seg->dev_table_size)
>> -		    : memremap(old_devtb_phys, pci_seg->dev_table_size, MEMREMAP_WB);
>> -
>> -	if (!old_devtb)
>> -		return false;
>>  
>> -	pci_seg->old_dev_tbl_cpy = iommu_alloc_pages_sz(
>> -		GFP_KERNEL | GFP_DMA32, pci_seg->dev_table_size);
>> +	/*
>> +	 * IOMMU Device Table Base Address MMIO register is locked
>> +	 * if SNP is enabled during kdump, reuse the previous kernel's
>> +	 * device table.
>> +	 */
>> +	pci_seg->old_dev_tbl_cpy = iommu_memremap(old_devtb_phys, pci_seg->dev_table_size);
>>  	if (pci_seg->old_dev_tbl_cpy == NULL) {
>> -		pr_err("Failed to allocate memory for copying old device table!\n");
>> -		memunmap(old_devtb);
>> +		pr_err("Failed to remap memory for reusing old device table!\n");
>>  		return false;
>>  	}
>>  
>> -	for (devid = 0; devid <= pci_seg->last_bdf; ++devid) {
>> -		pci_seg->old_dev_tbl_cpy[devid] = old_devtb[devid];
>> -		dom_id = old_devtb[devid].data[1] & DEV_DOMID_MASK;
>> -		dte_v = old_devtb[devid].data[0] & DTE_FLAG_V;
>> -
>> -		if (dte_v && dom_id) {
>> -			pci_seg->old_dev_tbl_cpy[devid].data[0] = old_devtb[devid].data[0];
>> -			pci_seg->old_dev_tbl_cpy[devid].data[1] = old_devtb[devid].data[1];
>> -			/* Reserve the Domain IDs used by previous kernel */
>> -			if (ida_alloc_range(&pdom_ids, dom_id, dom_id, GFP_ATOMIC) != dom_id) {
>> -				pr_err("Failed to reserve domain ID 0x%x\n", dom_id);
>> -				memunmap(old_devtb);
>> -				return false;
>> -			}
>> -			/* If gcr3 table existed, mask it out */
>> -			if (old_devtb[devid].data[0] & DTE_FLAG_GV) {
>> -				tmp = (DTE_GCR3_30_15 | DTE_GCR3_51_31);
>> -				pci_seg->old_dev_tbl_cpy[devid].data[1] &= ~tmp;
>> -				tmp = (DTE_GCR3_14_12 | DTE_FLAG_GV);
>> -				pci_seg->old_dev_tbl_cpy[devid].data[0] &= ~tmp;
>> -			}
>> -		}
>> -
>> -		irq_v = old_devtb[devid].data[2] & DTE_IRQ_REMAP_ENABLE;
>> -		int_ctl = old_devtb[devid].data[2] & DTE_IRQ_REMAP_INTCTL_MASK;
>> -		int_tab_len = old_devtb[devid].data[2] & DTE_INTTABLEN_MASK;
>> -		if (irq_v && (int_ctl || int_tab_len)) {
>> -			if ((int_ctl != DTE_IRQ_REMAP_INTCTL) ||
>> -			    (int_tab_len != DTE_INTTABLEN_512 &&
>> -			     int_tab_len != DTE_INTTABLEN_2K)) {
>> -				pr_err("Wrong old irq remapping flag: %#x\n", devid);
>> -				memunmap(old_devtb);
>> -				return false;
>> -			}
>> -
>> -			pci_seg->old_dev_tbl_cpy[devid].data[2] = old_devtb[devid].data[2];
>> -		}
>> -	}
>> -	memunmap(old_devtb);
>> -
>>  	return true;
>>  }
>>  
>> -static bool copy_device_table(void)
>> +static bool reuse_device_table(void)
>>  {
>>  	struct amd_iommu *iommu;
>>  	struct amd_iommu_pci_seg *pci_seg;
>> @@ -1228,17 +1187,17 @@ static bool copy_device_table(void)
>>  	if (!amd_iommu_pre_enabled)
>>  		return false;
>>  
>> -	pr_warn("Translation is already enabled - trying to copy translation structures\n");
>> +	pr_warn("Translation is already enabled - trying to reuse translation structures\n");
>>  
>>  	/*
>>  	 * All IOMMUs within PCI segment shares common device table.
>> -	 * Hence copy device table only once per PCI segment.
>> +	 * Hence reuse device table only once per PCI segment.
>>  	 */
>>  	for_each_pci_segment(pci_seg) {
>>  		for_each_iommu(iommu) {
>>  			if (pci_seg->id != iommu->pci_seg->id)
>>  				continue;
>> -			if (!__copy_device_table(iommu))
>> +			if (!__reuse_device_table(iommu))
>>  				return false;
>>  			break;
>>  		}
>> @@ -2917,8 +2876,8 @@ static void early_enable_iommu(struct amd_iommu *iommu)
>>   * This function finally enables all IOMMUs found in the system after
>>   * they have been initialized.
>>   *
>> - * Or if in kdump kernel and IOMMUs are all pre-enabled, try to copy
>> - * the old content of device table entries. Not this case or copy failed,
>> + * Or if in kdump kernel and IOMMUs are all pre-enabled, try to reuse
>> + * the old content of device table entries. Not this case or reuse failed,
>>   * just continue as normal kernel does.
>>   */
>>  static void early_enable_iommus(void)
>> @@ -2926,18 +2885,18 @@ static void early_enable_iommus(void)
>>  	struct amd_iommu *iommu;
>>  	struct amd_iommu_pci_seg *pci_seg;
>>  
>> -	if (!copy_device_table()) {
>> +	if (!reuse_device_table()) {
> 
> Hmmm. What happens if SNP enabled and reuse_device_table() couldn't setup
> previous DTE?
> In non-SNP case it works fine as we can rebuild new DTE. But in SNP case we
> should fail the kdump right?
> 

Which will happen automatically, if we can't setup previous DTE for SNP case
then IOMMU commands will time-out and subsequenly cause a panic as IRQ remapping
won't be setup.

So this is as good as failing the kdump, which will have the same result.

Thanks,
Ashish


