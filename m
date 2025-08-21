Return-Path: <kvm+bounces-55270-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id AD849B2F6BE
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 13:33:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id ADA4D7A8F7C
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 11:31:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0FD5D30F7E8;
	Thu, 21 Aug 2025 11:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="LfDOn47v"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2067.outbound.protection.outlook.com [40.107.94.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D88BA1FBEA6;
	Thu, 21 Aug 2025 11:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755775963; cv=fail; b=putD4gKCXdHIpYRsByLsdcybIL3eR68RYT6cNpUmvu01Xl4/2OI1gQggVYmcFBLqRgj01H8MeqHkqEpRrWMVhPUNNSDhYU++avRRwfjLwKAoNg2G8uURRp7TaQ3urrSAdIO1tDR+LgXCHxl1IcI9wQFcaTPnPHgmtZ1CbWqSKQM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755775963; c=relaxed/simple;
	bh=IoBCMq8iDYrRvH8NRn5VoeCu3/TpIh5HiNXbWPO23Nc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=CdKRVmkFivrHDrj6og3v8Jj41WIJCo4lIPJ9oqmdkck/l7/9JxzvWdWlcUAPEIbpNq5jQydQmoelRxBfdZVy0CIK2AvSTQoAFqt2sVYjVqxuRVHakQV0Psr72xZYaAet27IIpr/7ehTde8GChp2iW59atqRI4p6airwxUqHG56U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=LfDOn47v; arc=fail smtp.client-ip=40.107.94.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=v2K7Euv1vOfDhdI4lZX5LGmUQvbsda+ht3kYa1cr9deePt9DmvEt5fnzb1WjRXUXrK/67toGq1ECwidxxBWzvBV9HwJRVF2fait37bTzao1+1CBeGQKZSk7KIKO43A1S4XNTQGYVlWVXY3X1F2f4T6pRsaMpHeX9fMHNdxTqEwFcWRZON4syNnEpgtBweUpgSb1PjHQYGnWyo+SbaPOS1fJx0BIl6ziglXiNdDadYO5QwFuBqYPtZUobvUbnBPRaEYLlr+fjgcRdV/2maXm0nK+4tTgIGS0xIaZMQ7+pzKzgkCi6jvusz4M17qa/Ms0OZF+Sn9mf6/PAtjcKMnC+cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xCsb+OQv9K8+hYO1CvmgTEgvssWe9pqBzBSIhi28Abw=;
 b=jcDC+NVieJjLzqPthmrS/yBXwCOw66eoHyoCx5qnu1TigTwHTAqW3kKxeBB/lgznvdpZ7uZQ609MnGRNEsusNooaJMI1pT9QYAum9AQOyUQt9gT/GNffmWjSZZOHayNj2uIMQ5onYDCfJpbMe+5tSDHpbej8pCzxpmYT6OEGq/yBE3omb1ILuxLHVN8ltjDXXk5LryY98aKoec5dDy2hx/NIb6R5jVonfsDe3u7Rqo6dfypBn55eeUMolrbpvYueYOkdPLwOKcnn3qFJXi7ZcIrP0epgRxxECwhsdBljOETVfE+EIpKQTE++TfHUZ2liFCXrd0NNCAjtRqN+o1/jVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xCsb+OQv9K8+hYO1CvmgTEgvssWe9pqBzBSIhi28Abw=;
 b=LfDOn47vpOSKsyv+os7sH2rRDMa7pEewFgaDhIVg5/YjQgY9iQ7104TSN3OlyhoofpuHpm51hHUH9rcGWdOIMRkmIB2/k4/AS1S94WwZGFw1yWL9zE5SgD545NDanWbQ2WJajMuDWagc0ZAS9UZXEuJgQZEDYROr8rUZKBSC7yE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6048.namprd12.prod.outlook.com (2603:10b6:8:9f::5) by
 DS7PR12MB9502.namprd12.prod.outlook.com (2603:10b6:8:250::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9052.14; Thu, 21 Aug 2025 11:32:36 +0000
Received: from DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5]) by DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5%4]) with mapi id 15.20.9052.013; Thu, 21 Aug 2025
 11:32:36 +0000
Message-ID: <7deb2d90-8a42-480b-b4e2-f784927160f8@amd.com>
Date: Thu, 21 Aug 2025 17:02:17 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 4/4] iommu/amd: Skip enabling command/event buffers for
 kdump
To: Ashish Kalra <Ashish.Kalra@amd.com>, joro@8bytes.org,
 suravee.suthikulpanit@amd.com, thomas.lendacky@amd.com,
 Sairaj.ArunKodilkar@amd.com, herbert@gondor.apana.org.au
Cc: seanjc@google.com, pbonzini@redhat.com, will@kernel.org,
 robin.murphy@arm.com, john.allen@amd.com, davem@davemloft.net,
 michael.roth@amd.com, iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, kvm@vger.kernel.org
References: <cover.1753911773.git.ashish.kalra@amd.com>
 <e66b75e126fa245e126fe81ed73baffdf603369a.1753911773.git.ashish.kalra@amd.com>
Content-Language: en-US
From: Vasant Hegde <vasant.hegde@amd.com>
In-Reply-To: <e66b75e126fa245e126fe81ed73baffdf603369a.1753911773.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN4P287CA0119.INDP287.PROD.OUTLOOK.COM
 (2603:1096:c01:2b0::9) To DS7PR12MB6048.namprd12.prod.outlook.com
 (2603:10b6:8:9f::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6048:EE_|DS7PR12MB9502:EE_
X-MS-Office365-Filtering-Correlation-Id: 5f0e4ee6-2ef1-47a5-2638-08dde0a66c74
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?c1JiYllvbnpTaFlpYzk1MkZSMzUwc2Y1WHFveDVkbHgzWFlQNGVTZWlpWnhn?=
 =?utf-8?B?Z1VkVGRuRHFmZE53cjB1WXVaTWZZMHJFUVVCNkhhWit5TFRrcUhNcm9WZ0J0?=
 =?utf-8?B?S1FDZ2xvakVjdlFSS00wYm82SUM0Ny9BcWVGSVBFbzRiRVE0elNRdkdZOUhK?=
 =?utf-8?B?RHdVeUNJMWM3aHZ1TURmSWFGMkJTbWV5eFczZWlhbUxWMlAzcVhGdjRqSjYz?=
 =?utf-8?B?ekFMcDJuWlhqMmFjWGJKQ09WOTJ4ZHZFUVVhSUFLR1ZmNjBLaGp6czI4TWlZ?=
 =?utf-8?B?ZHpvRWF2R2IvTytSNHdGVWk3Znh1UlNldGxVUmpzMlp2RGdGNW04amRGdThx?=
 =?utf-8?B?U0VJMmNwSVRIZU1MdCtSN0NSUDJEL1B1SHI5TU5UL3hHdUlVY2svc2dWUFZj?=
 =?utf-8?B?TGx0SHRLSWJZQWdRWHBZMVp3VlFhd1R4QmREMEUreVludXhFTWhpN1ZpQWd2?=
 =?utf-8?B?MjdoWVcvWmNMMjBBRVRkUjhIaHZseXlMZXBWd1pPcFI2bzZPYVdyRlZaRGhT?=
 =?utf-8?B?MFpUaE1PQmFyeDZrcTlRWDNYQ2xmN0VUK0plQzlSeUFuVzlFSFlzSURDNU56?=
 =?utf-8?B?L2dMOU1JNlVreXhpUzVLMHVKTHBDRFJZaHJpbkxaYnRrbENtTDA5YWhHazZu?=
 =?utf-8?B?Rm5JSkl3c3FYd1h0MlEzU3hLTmJFb0gwNGJCY08xcm5IaWhiYVpIMUlmTmRo?=
 =?utf-8?B?MHc0OHdaMUlSVk5xTXZ0VjMzNllHWHc0UTNEcGc5OTVsamJ6dnh0L3lnWWFt?=
 =?utf-8?B?Z2JmOUVtWDY4ZGtlWTFiNjBzU2NEOWJhU0ZQSmxQZ0RjNENNUjlzSTlHckJQ?=
 =?utf-8?B?N0VKQXowTHkzL0YrWnc5Ym43NjhMSTJsenFQMU56WDVzOTNmTFJYalJlUGw1?=
 =?utf-8?B?VTlXcEdnMnpSZTJRS08yYUxQd1FsaFlEdzdEQ09sQTNuZ3lDSUZVYVUvZ3Zl?=
 =?utf-8?B?TEhJRkF6dkdlUDJINFY4V1pYbmxoZlY2RDRFRFprTnhJeVVmcGRGOWlUWjls?=
 =?utf-8?B?YWJhTnVOaCsrbHhJTDJOKzdoMk82SlcxNGt2eWdFckxDNmZzbDBjWFJERWMx?=
 =?utf-8?B?K2Q0eDNZWUhnZm1ZcnJwS21zVWd0SVAzOUZPL2MxZlZ3YlN4SjdGVlNNQXpq?=
 =?utf-8?B?NGVQWUtCRzFjR1hGZDY4eW9ob00rMmFudFcrVi9yS0FsaWI3RFV2NC9udXdq?=
 =?utf-8?B?VnRvc0ZyYlR1TlNLZU5NODlqMlBmNVA2NmVsZDBtZithNTFpQ0l2MEZEaXV3?=
 =?utf-8?B?U09wTURsWHNTQzRQYWJlSTRQcEt3VnBROFJNM3RkRGk5R01sUVZxWXdTV3A2?=
 =?utf-8?B?Qk9ORFh0ckhWdmdVSzc1cnBWV3V6Q2JSdmdULzJKMm5OeEoxK3poZkx3R0I4?=
 =?utf-8?B?Y2ZhbnoyVjZ5eGkxOG5WTkZQMDBHc3lCQW9zTGhRYWpxbGJ4QmlodzFEaFJG?=
 =?utf-8?B?Y002REpKZGxQUzFYeGRHcjA4VG80U3ZaTzdvclBiNTFQZzJFUXlqbWE5UDhy?=
 =?utf-8?B?bWxQYnR2d0pMbmFJZCsrbUpwRGQrbEZ5TDZSSEVZU1JHU3hHRWZ2Lzc0RzFo?=
 =?utf-8?B?V0I1Nmk5aldia2FCSnY1ejVNSWdRZWpvQXZNVG5hcVo0aGV1RjhWRnJaTnFQ?=
 =?utf-8?B?Wkh2T3pvZzBiWGNnc2I4Vk5HNHlSU3FhbjlzODBWaVBsYzFveE01Z2QzRUxY?=
 =?utf-8?B?TmxFOFhhbWc1TTI3VE1OWktMaTg2ZElsOXlkcXdMblZMc3pOZTFSTHBpVXNz?=
 =?utf-8?B?eUVXKzd0ZXZFWGtQQ3hqT2hyZ1FBZzh5cVovdzhUWnJMUGMwMUR3MkFFWUp0?=
 =?utf-8?B?L0hOT0N3QytXQlphSnpQQ2dIYk1Lb0ZvRTlqcUwyeDBhSU5xK1A2Q1Jpd3M4?=
 =?utf-8?B?djNjSGdHN3lVcXB2VXQ5c3FYaGN2NFJ1R3hHOE84N3pHQTBBV051bWNTdjd4?=
 =?utf-8?Q?8uVNc8/vdBU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6048.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eTJtd09RUGZOUEdKR1RibTRVVzFSenZOWUxnRGdLNFNTNEZyNzlSMklzWDFX?=
 =?utf-8?B?NTl0enUyNWdWRUtjaUcrM29rSWtLWndQZXNndmNHd2tCQVRPVmJqdDRvM1FO?=
 =?utf-8?B?UjZnTXlLQXdLVzczcDRIUS9Nbk5zalVFNldEU2pWZFBhTmNDZXZueVdkakF1?=
 =?utf-8?B?eHdvOE1jQTN6MjlERVVsRWpNcUZTSmN2N1I5TlBaRUx2b2tDNERXSFQ1dVpo?=
 =?utf-8?B?cmFnSExTTmdoMG1idmZXb1NGU1g3ZWNRT0MwUVh4Vy9pOU9nYnBrSkVzbmI4?=
 =?utf-8?B?MnpSN29qU1JMTkJYTE1lc2tjVHJIQmR0Q3NNOGlNZHNSQjZRUjdIQnRLWmVO?=
 =?utf-8?B?Vm9HclZ0dy8rOHk4ZWdIRE9hdTcxb3BkMVdlTFA0UDlSM01PWHVFWnhkblFE?=
 =?utf-8?B?V1hUMEJWYkU0UXc0ZEFLdlA2RlJhTHV0d29OWHlva01pdmZyQzdvWEVQM0Rq?=
 =?utf-8?B?WU5RdDZIVWpMMkNGTkpGdkFQYUpuak5zZFRHSXdGQmVmVExIVU5SMTVML2RJ?=
 =?utf-8?B?d2Q1eTlEejBWNW1oNWZha1ZCdk9MVm1HWUZ0L2MzYzZyVGtrK3hJYTRBMHJB?=
 =?utf-8?B?akFBTDJDVVp1MXNOM1d0YjFFZExOY0RqK0RjVkxFUXRYeHV2bWJrak9pbzY0?=
 =?utf-8?B?YnNWaG8raGVJWWN3NWZuRkQzYkxYYk80anNoSFZ5eE9sZ0xubThLbVh2QWcw?=
 =?utf-8?B?elh4b2daUkd1WG5vdEFGMWRxNmY2Yk1MRk5STTF3MUdFTHpWcjEyRHNHYmUz?=
 =?utf-8?B?MWNiY1cvOHZVUGtlL1ZsaWR6cVhtVVZSOVpjY1lKZ05McWcrV2p4a2k0Z1Nl?=
 =?utf-8?B?bU9rZ3FmRk9qc0o3emNYUDlsSHUvUVNMUmRwMm1oR1ZZL3N2aUxvK3lNT1ZW?=
 =?utf-8?B?c21RN1lHVGIvSkxhb3JjTzdJMlp4aDFYdHZUV3JhbnBQcTM1UENCRSt4aUhJ?=
 =?utf-8?B?eDRoUTcxeGpIbytzbi9rRHBDMTNvcXBjL3VJNVc1MVdtWU1FQVl1YlFtR1Z5?=
 =?utf-8?B?aEpZN1lhR2l6SnF6NGpCa2wxUEhHdWR3N3VwQnZxcEF3K3dKRTM0dDYveWVF?=
 =?utf-8?B?aWtvUzFGMTZYOFBJL1JHeEIzbkd4RnVTdDZTZGMzUXZNd2ZJUE1Hdk5nTjNr?=
 =?utf-8?B?b2ZpdlpoeGxjTk9IMU5qUVNHRjQ0NzdTNFVtNUc1cnJsZVNWbk02aXNIR1Vk?=
 =?utf-8?B?UG04Q052SVl6MlZYdVFqcElFK1hKdmYwVHhKNTNYUjlnbElsUDFvV3prM3Q1?=
 =?utf-8?B?anQ5M01pSXRwNHc4TXI5YnBXVFB6WlYydE41dTNVMElsOWZLYUJmMUVqT2p5?=
 =?utf-8?B?UC9UR0llczRKOFo0a0JyMWtCR2JCUXlTMWMxLzFZNldLbVpyc0VjY002V1d5?=
 =?utf-8?B?d2hHSnNUQ0s1TkNvV3RKSk1GM2lPTmhkS2Q3eDRIVnNkS0hRZWhrMGthSHkw?=
 =?utf-8?B?allPZERXZG55dy96Wk9EQW9wRFNHT1JSVmROODlra0QxZjNTSVkyQTFvcTcv?=
 =?utf-8?B?dktIS0xrRGEyYlpaWk9WSXRNSUhDTWNFV3dQVHBtYlByQk1WY3lhWkhGa0dl?=
 =?utf-8?B?K1dURkdZNkNXdnFSc2ZocW8weXlMTnZtMWR0QVVvVVAwR2VnTFRiTkJjVThl?=
 =?utf-8?B?TnF5dkhPVWVXSkNLa3dhUmJBYXhNZVhLVmJ4bSt6S1BWVVVrWTRwQ0NrUzcy?=
 =?utf-8?B?U0wzM2lxUzJ4ejVrcUNGZXlyWVpTMktmbzBkc1RLaEdwM1o0QzFVVSs1TjdD?=
 =?utf-8?B?NGZlVnNlL0ZoWGJ1UEw3VmtqSHkrSmZ4bkZTZytsdTV2d1FHWGJSS2Y0dUcz?=
 =?utf-8?B?Smk5Q21mMFJTVnZ6QjJxalB5SWFBYXBMNXQwQURERkVUbEJ4RitlRnZLRTF3?=
 =?utf-8?B?QTZMLzkwdlVnREdzTGN1QWhzbk40YlI0TWd5TmFXb2ZTSUdZd0x2RitZOVZO?=
 =?utf-8?B?RVJiY1BkN2YvOWR5ays1Qm02TkIrTUxUVU5hSjZEVmgxaHd6TXl1dm93bXpa?=
 =?utf-8?B?NVY5dHJuM3RoVlZkZVVUdmRUYzBWaWc2QXljR0xIRnhOdldyQ2l3V0laWC9J?=
 =?utf-8?B?cjdOYXROMU9jWmI0SmQ1ZnJlSnd1N0t1V2JoNXNxSFBWQmxhRHFwUXRxY0ta?=
 =?utf-8?Q?ypENsNxFmzdBnp4YoLIUpLAQT?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f0e4ee6-2ef1-47a5-2638-08dde0a66c74
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6048.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2025 11:32:35.2294
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oLc406Fv0kLvJRBLLsUwaI32xLz62yk1LkJWDdQXUsmHTYPr8V3+w/MuZBaU3DkuKqm75ylGDqT3hEbTutLe8A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB9502



On 7/31/2025 3:26 AM, Ashish Kalra wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> After a panic if SNP is enabled in the previous kernel then the kdump
> kernel boots with IOMMU SNP enforcement still enabled.
> 
> IOMMU command buffers and event buffer registers remain locked and
> exclusive to the previous kernel. Attempts to enable command and event
> buffers in the kdump kernel will fail, as hardware ignores writes to
> the locked MMIO registers as per AMD IOMMU spec Section 2.12.2.1.
> 
> Skip enabling command buffers and event buffers for kdump boot as they
> are already enabled in the previous kernel.
> 
> Tested-by: Sairaj Kodilkar <sarunkod@amd.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>

Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>


-Vasant


