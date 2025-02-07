Return-Path: <kvm+bounces-37637-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 72EC6A2CFF6
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2025 22:46:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6E26518894B3
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2025 21:46:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3BE41C1F08;
	Fri,  7 Feb 2025 21:46:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="clseq8qr"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2061.outbound.protection.outlook.com [40.107.220.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CF071B6525;
	Fri,  7 Feb 2025 21:45:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738964760; cv=fail; b=Q8GNWvmignxeGUuGEmSKCF7V38b40rWS/ZkMfxTRSFEG2wSZiJZIDgFqeTQ9/Xi/G0lirmkBwV2bJ5YQQGbHHglcr0LHdRQj/6MwpP1pG14aqoyhDL2JRK2h2D+HbmgWUQHJVS5oyZrv86zacPyjlsAdb8se8S8Rlk5WafhRNgQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738964760; c=relaxed/simple;
	bh=3jUQO2438vpKOSMo8g+eM+1r84ZjYXFMXzabbg84/hc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=dhK7lI+S/quXBC0xeIQoUOuOZByonqhIjc3602IfhGxpXtWXzO6Ad8n0HmzDkS7XdIuBFIDfnYNMdflvznA4+w1aT1Y/WNjR8KLWw1t4nv0LNb/3rG+kR0tJEU9Zfy6lGcVUj9hSEoLt3CwVse27c6/nZ8wXqN+VAey2wo6r3C0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=clseq8qr; arc=fail smtp.client-ip=40.107.220.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=o2FDwcijkSbyp3hnzSM1sJR5yzV8Hyeeiym5BdmmrYlkoHEYk98eWCF5/nqrdp+WkgGkKk0rqjZNo0lvIRr8QmTimtsrdiFCLzvw2qRjAs/a1SNlrJHzrATplROHYDC0fFXIQwXaGMzJ6deDmXuaizir64R0prL2B74FgMH+qSwW3oFnoVlTtnK8JrgefmXujxcLDhtMU8IiCaQbZ6cNRm2Ns04hcxvRAteyVtbuC1kIQKT1ssvMuA0S7hYQ4r7f8ZQ6BGp8QzT3MaJ+mRAvb2ljlqdYlteGyFbGCWAmpADivhDxSAONCLZKJOkPDfRl2mPy4LuY9PaZLx0CK3Kjig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HF8nwi8qjU/jJG1a02yZjGM1UgyeJbmbaDKPFnTba1w=;
 b=NBNLjL3HNB3B7BPH7kFhMGod1gJQPnIIB9lQKf49e41nqwAK7B6LSpqtWcr6TC4BX/UXAFseSg/nig4cxT0On2HMYhHzNgEpu+y+jPyymdaM+J9G04GNKMmtPtXdpscSQ6EWoXpzImY7A4geynDWuQQrl064xZV8zNSgIrpPj/TCGO93ZBkSdeRkuUtbCQdXQIPstVVBXHb+3DqEBCQN/J1mh3ebsSuls2qZ+NQ3+RunS+XxfFiEF5dcwYkaf4wD8P4I0h2O/TvM7sCojMNysmZo6zwtea2glohy9h8YCMh/Ucr7xJHqLFDd34Zz9q/f05n2d5WQ7gwf3/pDL4PHsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HF8nwi8qjU/jJG1a02yZjGM1UgyeJbmbaDKPFnTba1w=;
 b=clseq8qrgc/z1LhMddGwANJaxk+JHTojuPEvj1Q9r8Np5HaiOd2jAFfyCxUMMEANY1ISryGnVIhn50d6aWS5qNxoXWcSOJ2LTlt5MYdQsbnw7LnVEXtt4XYmMs7kQZ1/lukO9iCZvgcOXaAzIcLIq2Xlxb08aIfhJ8fsyJnaUYg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5062.namprd12.prod.outlook.com (2603:10b6:208:313::6)
 by MW4PR12MB6754.namprd12.prod.outlook.com (2603:10b6:303:1eb::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8422.12; Fri, 7 Feb
 2025 21:45:55 +0000
Received: from BL1PR12MB5062.namprd12.prod.outlook.com
 ([fe80::fe03:ef1f:3fee:9d4a]) by BL1PR12MB5062.namprd12.prod.outlook.com
 ([fe80::fe03:ef1f:3fee:9d4a%5]) with mapi id 15.20.8422.012; Fri, 7 Feb 2025
 21:45:55 +0000
Message-ID: <2794745e-c33a-68dc-f0e7-961e1631299e@amd.com>
Date: Fri, 7 Feb 2025 15:45:51 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v3 1/3] crypto: ccp: Add external API interface for PSP
 module initialization
Content-Language: en-US
To: Ashish Kalra <Ashish.Kalra@amd.com>, seanjc@google.com,
 pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 john.allen@amd.com, herbert@gondor.apana.org.au, davem@davemloft.net,
 joro@8bytes.org, suravee.suthikulpanit@amd.com, will@kernel.org,
 robin.murphy@arm.com
Cc: michael.roth@amd.com, dionnaglaze@google.com, nikunj@amd.com,
 ardb@kernel.org, kevinloughlin@google.com, Neeraj.Upadhyay@amd.com,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, linux-coco@lists.linux.dev,
 iommu@lists.linux.dev
References: <cover.1738618801.git.ashish.kalra@amd.com>
 <02f6935e6156df959d0542899c5e1a12d65d2b61.1738618801.git.ashish.kalra@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <02f6935e6156df959d0542899c5e1a12d65d2b61.1738618801.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7P222CA0011.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:124::32) To BL1PR12MB5062.namprd12.prod.outlook.com
 (2603:10b6:208:313::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5062:EE_|MW4PR12MB6754:EE_
X-MS-Office365-Filtering-Correlation-Id: c924f232-d790-4c0b-9846-08dd47c0ccbf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|921020|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Sy9tQmJhSWNEa0VPczN6WEsxd2haSHRxVjFpUnVCQzhPMU55aHYrdTdtaVJk?=
 =?utf-8?B?K0V6UllFZXByUmpnQ0Q1Ri8xdE9ZOWYvMVVsSDFLNmo4MXhZR3NuZ0hSWHRr?=
 =?utf-8?B?b2hGTSs1YnJRTmdCMlI0Ny9QaDRramRJQUEva296OU9sSERBTFVNbWM3Y0dm?=
 =?utf-8?B?MXhONGVSOGE3UG1BeWZ5UXU4Z2l2Q3IwY2RaR1JzVnE2NG5abUJ6djBidlZS?=
 =?utf-8?B?MnVSaVpQMy8rUE9jNEFPWEUxeVcrUzRLN00yQVRyaWNlNmlnK0RNWUJuK0hZ?=
 =?utf-8?B?OVE5UmFZR2tQWWE4WHRUOUNWcGxCYmRNSFhXMy83SmlMSU1NTlp4Y1ZKcXhQ?=
 =?utf-8?B?TTBza1NTU2Y4eUpRKzdTWlBtZHI5MVpVS21uYWJnMEgycXVCdlkya01SVXRv?=
 =?utf-8?B?VEVOMTZHR25YeVBhdExlZjA2NGNrblN1QnFKa2xEclhRVDlpUC9Da0pzdW1R?=
 =?utf-8?B?UVhMN3NBMVhZQkhkRThqRHZPanNHMHlrRjd3SEpmYXdUckNDcGNNd0Z3UEV4?=
 =?utf-8?B?NXlYUVkrTVloTGR3bng0bUd1WTBFQUdnQVlWYVVJK051bCtOdXdua2dLZWpy?=
 =?utf-8?B?bUk0d05oWlZLVmRaYUdIZE1mc2gxUkpyTFlOY3g5REZ5Skt0NXBBeGJuRG5C?=
 =?utf-8?B?K2FicHI5UjVGQWl1WEZBUmN2K0JJaHM3MlYrQk5sVEI4MTFoOTFqUEJydXpW?=
 =?utf-8?B?Znc0SUoxVHZ6c05RbEdGcFJ3QmdQM0xCd3BWMEh3Z2tzWi9uZHZDNExndXpu?=
 =?utf-8?B?bXlTMy9WUysxVFFtYnI2UU10ekVNZWRUWWQ5WG9kb0JjVUFKNW1zRnA0QmpT?=
 =?utf-8?B?NFF5THFMYlVDZnkra1NITXNTa2VnMGFhT1l5cThKdy83NG9aZlJiWWpyOEZp?=
 =?utf-8?B?b3FvbSsvMUJLd09lUDlsK29tVXJxOUhKYzU1bzFoUTZrVk9CUUhBelpvSWRw?=
 =?utf-8?B?UlNGYW5yaXB6K0NYeXlNUTNzdXZvWmkvNFMzRTErQjluREh3Q2VHWlpjclI5?=
 =?utf-8?B?M21wMmhwQ0dBRTM3a1dNVE04UEdaWHVGM3oxNU4rZWdWRnhzTlFJR2ZsMEgx?=
 =?utf-8?B?ZStOdlNtalZDUE5LU1VBZEhqK3BhU1lYZmp2c0NnUldwaThMclNKK05FV1FK?=
 =?utf-8?B?ZnRmMXBuZ3NzMThmSHV6R3p6WmpncXB3QnFqbTdETVhoSG02Y1g4K2NpMU9l?=
 =?utf-8?B?Y3hpem51bzhqeVUyUXQyMUQwaUhFTG1OMU9wakxRZEJRcXBVNE9EbDBmUldD?=
 =?utf-8?B?NWxrZ1FCT3JJblpXV0hxOGtvbjErdmFHMHZMNTlzczVCNU54Rk4zeVcwdkxN?=
 =?utf-8?B?OTk3TlhuY3ZTSWZjbGp1bXQ5UUZFMFNScERlaU9jVGlmZ1VZRHRYZk5JQTFJ?=
 =?utf-8?B?UFhsZE02b25CQVR2NjlkbWtLd0FTVFBVMFp5S3FKVWxDMGlDcnpIK3NzZUFG?=
 =?utf-8?B?djg2b2ttL3c3MU5GSmhiVEZlU1RTU2V3b2RXUlNKejgvaGJiZ0JhdTJmK21F?=
 =?utf-8?B?eVBNajg4Y1g0cDlGdzBrcWxYdENmdU0yQ2VITmw1WDFWWE5GbWZsTFNNZTdU?=
 =?utf-8?B?QUk4bmNhVkhUM2RScEZmdGFJbHptSE8rUUhnOWprQTgxZ0xiWHhaZUpndnZL?=
 =?utf-8?B?QVZnQ0t3V25vSDV1R2VoU2dLbEc2MUd5U0VDRmdqN0lMTnl0SndtK1hpOUN1?=
 =?utf-8?B?UUZJQjlSR2hOMWE5OThVaUxVUDVsMXlMU3VOSE1KZ3g1TDNFbGovb1RzQ1Ar?=
 =?utf-8?B?YlRWTzdJRVFXYU4zUHk4M1VRZ2pza2VnZzRpOFdFekJBUnlCa2VQelpIdG1h?=
 =?utf-8?B?V0xoTGdialNOSE1HRFJ5dTlpdkpTN2VvdkpUdTZEOVVTTHU4Z2txQ3l6MnBa?=
 =?utf-8?B?d1owQ081Y1hwS1BYKytNMGc1ZWJWK1NlNnVXWGhYSjFFK29YS2RqcDJtQkVQ?=
 =?utf-8?Q?n8X63Xqfyls=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5062.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(921020)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dWhmTm80L21keGRhQ2hEWGJEZHE0YmtTNGxkYnpZNnFtMUhLRFVnMjBaYWxK?=
 =?utf-8?B?Mk42Q2Z0WlQ0M244dmFpV01UTmJBaUc2YnI2T2hLOEU3SElXcWpqejg0L05z?=
 =?utf-8?B?alZmSUs1UVdwT2RtZVljekV6MjFVM1crMnJGMlFrTThuNWNzOFFaQ2Y0VDhH?=
 =?utf-8?B?UjByRUFSRVVWNTB3cjRiZ3ozdGIyOU54KzZ4ekdvYVc3ajU5NnFLV25iRXo3?=
 =?utf-8?B?aU85WTF2dlN0VS9qek5XT2IvME9GUVVFeXk1cHg0WXRnTytQbXpXN3ZvOE54?=
 =?utf-8?B?MnhPRC9QaGl6RnBaTEZyT1VzbUptWFhYY0lQTzBjM1Z1VDlvSjlPaHNpV3lq?=
 =?utf-8?B?V0lHdHg3ZjcxZEZHRmdRTG1ocVpwT05lK2hzM0ZRa2lVdXFoNWwwRGVIbXpY?=
 =?utf-8?B?NFZEdjhlTStsaG9ndzJNMlVteXpLMFJTcW1KaGM4WFJpQWlTN1JpNmRQNjZ6?=
 =?utf-8?B?R2JYbHR4ZVJNVzJFL0ZyMHo5aHIwMmZiVHRsU202Y0c5QytzME1TaUptOTda?=
 =?utf-8?B?OU5TbHRKcXFuYTRWOTgxc2FkYWxEc2YvUFpqbytTNVJwU2dDTjY5WUFSQ3FM?=
 =?utf-8?B?OHNzc1hxc0xSMkphY0VnSDJHdFd5SnZNaFRFa3JKOTdxLzl5OTVhek9WU2Ns?=
 =?utf-8?B?Sm1PTHIrMjQ2NHZlTWxyQUdRUEFxSmo0WnpSRmdac3BJNGl2Z1BuS210WVNI?=
 =?utf-8?B?SFBjUENlZHRrWWR0ZFovYlRZR1d4ZTdFOVh1aHp5RWdQbkJnbHVYUmhIOC84?=
 =?utf-8?B?T1ZqSzdaa2JVOTNCNVo1NFJpdzduZU1mWGcydFNzdnJwaHhFbmhyZXVNd21L?=
 =?utf-8?B?Q1M3enZYelNMem8yRFpkbGFZMFVaTlJFenFnaVQ4OXJnV0IyWU5pNDNpL3Rp?=
 =?utf-8?B?YThXVkdQZXhZWlZXMFA4TERCV1lpbFBaUzFUOE1sRm43ZjVoK2JXMlpxWTAz?=
 =?utf-8?B?cUJsQjY2YVVkY3cyZTVBVGp6Q3NMNWlId1pQOEQrWDN0QzRuanZwVmY3WlB0?=
 =?utf-8?B?Nnc4ems0WjFtbkwyMU1kTEREcnB3d2M3U2VSb3VQTWorWHJ2NkN5OGZHSWFn?=
 =?utf-8?B?dkFDWWJtbDM3SFptSE1JU243dzZPbEZtMWZlN0c4UndYOWF5WjJ6VDJoQVJ3?=
 =?utf-8?B?ZXJvY3MrRGcvS29uTEducTFGOTNGSW9zb0NrZm5mMlVWVnlHd0hpc3hiRk1k?=
 =?utf-8?B?U2Z4NC9HUnNuS2ZNL2FHWVZOajRGWXpHZHFySnczY3hFTG5QSkFkbE0vSkZS?=
 =?utf-8?B?NmwrTzBtMWVjanA1bm9QdHBVWHlGcHhWYUhObFlsTzQvV0haaUp4NUtYaE0w?=
 =?utf-8?B?a2dFeEhCL1AzZUxDcGY2enYrcmIzV3pBYUpLbkZPSnFBd0J0eXJha2FTM2lG?=
 =?utf-8?B?dDJzRTVhaFBYdVpxdUxmK0U4ODJFNlpuYmNFazUvL20xdTBDQVhWT3M3N25Z?=
 =?utf-8?B?ZkVwaVozcUV5c2d5dkxJTkovTlZKY1A4R3psdW94Q0JIdTZ5aXhzN1ZpcEI3?=
 =?utf-8?B?OFNEVFhjOG5Ra3JyWHZOMDVkbGJpNmNRbTJiN3hsTXZSQjNoOGhvcDZPeXlN?=
 =?utf-8?B?UWYzQU54bmVFWkhxdHBuQ0dUVXczeGp6VGdRNE9jQzNOYXpaLytFdm1kUWVD?=
 =?utf-8?B?S09yQTVBRTZMZzBPYStUbkNFSHlsNTZJNXdpZjJmWmtVcEpCRy9BbUhtZFFT?=
 =?utf-8?B?QW5yNWtBcmkxWHVKTFVYeC81eDc1NHp2eUx4bUlwRHQ0MzlFSDdxdkFYVGR3?=
 =?utf-8?B?NUY5cHQ0RGRDcjM4ZVA0WjlESXhwWWs3MnVodzVhaG9nUVFYM244TWZMdW96?=
 =?utf-8?B?UmtudlpqY2Zod3l1V21DN3NGSWdlNUJ5eUdhaFo5Rld5OWdvaytnZ2hkRkpa?=
 =?utf-8?B?ZGpWbnZPMEViN0lrQXFVNkN3eE1PKzFONE9YS2kxV2NRWFUzaE5kVFFBMGRI?=
 =?utf-8?B?UWY2aVBVT1A0WXBEazJwa2RuSXhMb2lCT0tEdHNEQWhYbzNER2xaNGJuSGwr?=
 =?utf-8?B?bUVxQmFVRjc3M3R1K25yRjVneUdHUEE5NGNyUFFNLzB1TDFDSkdTVkJNeXI4?=
 =?utf-8?B?ZVZuSkQ4SWd4ckxxckUzbldySjI5SWZKWmdnZFVGV043emkrNjA2Z1cxNEJO?=
 =?utf-8?Q?4J2zhrk2pJGrSTy3SFKbRdMzq?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c924f232-d790-4c0b-9846-08dd47c0ccbf
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5062.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2025 21:45:55.3873
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BZbHzfBe7+4ekJU01wU7/mFp6LaWUYxXeXyx9jKg8X2p6Fs8YuEhYmEpZ3gIIaD6TgHH3f8GvWvnFn5VapOlPw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6754

On 2/3/25 15:56, Ashish Kalra wrote:
> From: Sean Christopherson <seanjc@google.com>
> 
> KVM is dependent on the PSP SEV driver and PSP SEV driver needs to be
> loaded before KVM module. In case of module loading any dependent
> modules are automatically loaded but in case of built-in modules there
> is no inherent mechanism available to specify dependencies between
> modules and ensure that any dependent modules are loaded implicitly.
> 
> Add a new external API interface for PSP module initialization which
> allows PSP SEV driver to be loaded explicitly if KVM is built-in.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Co-developed-by: Ashish Kalra <ashish.kalra@amd.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---
>  drivers/crypto/ccp/sp-dev.c | 14 ++++++++++++++
>  include/linux/psp-sev.h     |  9 +++++++++
>  2 files changed, 23 insertions(+)
> 
> diff --git a/drivers/crypto/ccp/sp-dev.c b/drivers/crypto/ccp/sp-dev.c
> index 7eb3e4668286..3467f6db4f50 100644
> --- a/drivers/crypto/ccp/sp-dev.c
> +++ b/drivers/crypto/ccp/sp-dev.c
> @@ -19,6 +19,7 @@
>  #include <linux/types.h>
>  #include <linux/ccp.h>
>  
> +#include "sev-dev.h"
>  #include "ccp-dev.h"
>  #include "sp-dev.h"
>  
> @@ -253,8 +254,12 @@ struct sp_device *sp_get_psp_master_device(void)
>  static int __init sp_mod_init(void)
>  {
>  #ifdef CONFIG_X86
> +	static bool initialized;
>  	int ret;
>  
> +	if (initialized)
> +		return 0;

Do we need any kind of mutex protection here? Is the init process
parallelized? We only have one caller today, so probably not a big deal.

If we don't need that:

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

Thanks,
Tom

> +
>  	ret = sp_pci_init();
>  	if (ret)
>  		return ret;
> @@ -263,6 +268,8 @@ static int __init sp_mod_init(void)
>  	psp_pci_init();
>  #endif
>  
> +	initialized = true;
> +
>  	return 0;
>  #endif
>  
> @@ -279,6 +286,13 @@ static int __init sp_mod_init(void)
>  	return -ENODEV;
>  }
>  
> +#if IS_BUILTIN(CONFIG_KVM_AMD) && IS_ENABLED(CONFIG_KVM_AMD_SEV)
> +int __init sev_module_init(void)
> +{
> +	return sp_mod_init();
> +}
> +#endif
> +
>  static void __exit sp_mod_exit(void)
>  {
>  #ifdef CONFIG_X86
> diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
> index 903ddfea8585..f3cad182d4ef 100644
> --- a/include/linux/psp-sev.h
> +++ b/include/linux/psp-sev.h
> @@ -814,6 +814,15 @@ struct sev_data_snp_commit {
>  
>  #ifdef CONFIG_CRYPTO_DEV_SP_PSP
>  
> +/**
> + * sev_module_init - perform PSP SEV module initialization
> + *
> + * Returns:
> + * 0 if the PSP module is successfully initialized
> + * negative value if the PSP module initialization fails
> + */
> +int sev_module_init(void);
> +
>  /**
>   * sev_platform_init - perform SEV INIT command
>   *

