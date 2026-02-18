Return-Path: <kvm+bounces-71207-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8FoxEF4zlWliNAIAu9opvQ
	(envelope-from <kvm+bounces-71207-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 04:34:54 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 852B4152DD3
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 04:34:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 76B9630474DA
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 03:34:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B4142EBDC0;
	Wed, 18 Feb 2026 03:34:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="CVWI3CvJ"
X-Original-To: kvm@vger.kernel.org
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013047.outbound.protection.outlook.com [40.93.201.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AAAC3EBF13;
	Wed, 18 Feb 2026 03:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771385675; cv=fail; b=ECOezFfjaXbskdyk0AxzHgIekWiAlih74vnPIEp5hRj3MU+9JUNxfakqlumMcatzR4Xll42a6kRCkrFTOX9mzcUbbgX9deR3l1iZraSSQS6wANN4LKeoUGLOmSiP/6uF7ZYe2djRE1QHqT+eKigJ3y6fst5Mp9beaAbe8Sxbp6g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771385675; c=relaxed/simple;
	bh=fU+fT8Ni+nQIelpqijgvUTatYDv2GqhAUub5ZYK41nw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Z1NRy9Cs8gU/+iGMHEV4S55B0O1w3ItGIoaCuSfqW0a3kCKIN3yrZShU6YiIWIqZxEFomRWM4QZ6YFgXi9JeIVT4hhNxBvIFrBcc4AdsCrIzmlF1wq5qD/t2YX8KMwmezmbajTUVBfHNdk4qvteAj+NYs6g1sD/gaYYTFrZRp4U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=CVWI3CvJ; arc=fail smtp.client-ip=40.93.201.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RPF9GDRYnCYV54cdxPWR+WxrGkewLNbZvPr9LNyoJATw4Sezuz5v50Oegzm14BqPNhz2HuHiFvuouZEpdrvs+SU4pal6AetaQqMVVk/SZTdmEH8vAfymQrIMIFE533yLXwFJjRHMAxdZvM4A6Y0VlygMkPE98Wpo58AkTe0ThZhBO4KgnH618oWwdaMLuh2Tg5XIhx54b/IdWLZGEbV3yz7DBTxd2+7VrfRKqOWIY5/hDDOn1ubBEmv9sd2sgZI/YoKIcO5N6UHXii72pg7bgtX66rNQaQviwXFAZYOuW9aDMYMmPgag5beQXDu0sJXAgTNaURaL+u+916oeRgY//w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=89rpYNmfmC6uFQNmSOsVqbNSB+leD/5gKjaKvMEsiiI=;
 b=NWjPFLN2P7KGlbTOd8bx8AVKuzE09NP894oyXNgZ08i1P9qG6BLFf05NfWpoimr808IVqWJc9+Mh+VVoZDCVJ83Yc/mU5o9wPZy5wEP2FdKxGFDNKn7PAUP9UlvJEbgHjq2BSMDM3FAfE+v6HUGgA8kK05jBBbpio8ZJv66D3kbFwsm8oha2lRqvkzScXSRNr/06kjmkGc9zjZsSkgm5hxqVP/eq0QaU89fcWRlOMBkUvm8PrJyTxF/Vd5KL+BzpvYwb/pWzxMmP3X3JLuYhCRcDSyUtYHxTf1r9Wxlp2P5PmKC6h8j3NlzBRwPV9CqgXtsFE13uOFcsVv2jnlYPKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=89rpYNmfmC6uFQNmSOsVqbNSB+leD/5gKjaKvMEsiiI=;
 b=CVWI3CvJyZZX6oz/t8EjQ4b5erCL0nr5qUl+hqbrSaTfUUri/QOYCDCJ2xy25H5q1ejOM25AFvNSXLjYUA6g8MGxXkmRbcYXaxXi60EgzSutiNiqQ0u5BKKzztG4XTyOsnivsHsB3JlxEgyyK7VFdkc26eZbYS8sp7FZhRUXIP8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by PH8PR12MB7182.namprd12.prod.outlook.com (2603:10b6:510:229::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.13; Wed, 18 Feb
 2026 03:34:27 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad%5]) with mapi id 15.20.9632.010; Wed, 18 Feb 2026
 03:34:27 +0000
Message-ID: <e72165ed-c65d-4d21-bff6-9981b46311cf@amd.com>
Date: Tue, 17 Feb 2026 21:34:21 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/6] x86/sev: Use configfs to re-enable RMP optimizations.
To: Dave Hansen <dave.hansen@intel.com>, tglx@kernel.org, mingo@redhat.com,
 bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 seanjc@google.com, peterz@infradead.org, thomas.lendacky@amd.com,
 herbert@gondor.apana.org.au, davem@davemloft.net, ardb@kernel.org
Cc: pbonzini@redhat.com, aik@amd.com, Michael.Roth@amd.com,
 KPrateek.Nayak@amd.com, Tycho.Andersen@amd.com, Nathan.Fontenot@amd.com,
 jackyli@google.com, pgonda@google.com, rientjes@google.com,
 jacobhxu@google.com, xin@zytor.com, pawan.kumar.gupta@linux.intel.com,
 babu.moger@amd.com, dyoung@redhat.com, nikunj@amd.com, john.allen@amd.com,
 darwi@linutronix.de, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, kvm@vger.kernel.org, linux-coco@lists.linux.dev
References: <cover.1771321114.git.ashish.kalra@amd.com>
 <88ddc178dcab3d27d6296e471218f13a4826f4a8.1771321114.git.ashish.kalra@amd.com>
 <21250a3e-536c-4348-bf4c-a7356a13939b@intel.com>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <21250a3e-536c-4348-bf4c-a7356a13939b@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR13CA0036.namprd13.prod.outlook.com
 (2603:10b6:806:22::11) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|PH8PR12MB7182:EE_
X-MS-Office365-Filtering-Correlation-Id: ddee493d-c0bb-49da-0715-08de6e9e9dfa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?c05DeEFUTUtNOGF0RitZTHFINlNTRC9UL1g5cDkxTlZBQXhIUkorSktVRU40?=
 =?utf-8?B?eGt4bWNITDFOdURqaUM5NElVZWRQdlNhRXdrWENSeGlQSFlHUjRKUi80M3JU?=
 =?utf-8?B?U3VFRmc1Z2c0bjNCOEJ5WHpraDVDRFhydHVrZWxkVzRqenlVVm1zTXFGWmxS?=
 =?utf-8?B?RlR1M0d6dldtZklpVGZGZzFhVitCa2NFUVRBQzlwRVdmQStMcE14a2R6MHJv?=
 =?utf-8?B?ZFdlbko3bmpqQmtFN1Z5NnBNaXpwaWR2MUZ3SkhWZllzb1JjOU9YUm1LakdV?=
 =?utf-8?B?RHdHMS9TZE5NRUVxUTdjVnpoaGNoV3Y5UE83YjZjQit2TFZFeW5QMXRyOWho?=
 =?utf-8?B?eUZvRDRXTTV1dTl0NUd0WEVuVXVNbXdUakpBZWg3WWlxdFZvK1h0YXkrK2hl?=
 =?utf-8?B?WWlnR2o3dlByZEFTS1cxcXNVeVhxTUpFT2FuZVUxbUlXcFVpM3hzMlNrZ2R4?=
 =?utf-8?B?OS9Gd25xTXFaVlZvbVg3SU1jamVjTXAxMHBLaVRzVU9nOGswTHhaMzVBdHZ2?=
 =?utf-8?B?THphbEx6dUxURzdKbjRYallvNnJPZEpnWkN0eU5jaUNwYVhlZllocmdqZkIv?=
 =?utf-8?B?MkhWNUF2R1JWRE9ZdFQ3WmZOd2VQbDZXNCt4blVNcFNJL1RHWVFJVkZ4WkFV?=
 =?utf-8?B?eUozREw1VUxtS0pMcmE0cFB1RTVidjlFV3NOQjZzNWNWTklZb2tuaEdsTzJN?=
 =?utf-8?B?NVN3LzJQc0lWTVNEWHVuZXFLbWF1a0crV3BYODlWRlRkbnhxRXp4MlFTNWRO?=
 =?utf-8?B?emxGRTByd3ZUUDJWZDAyN2JvSytrRkduMTZQVTNQT0hHU09lUk9QdFBRamtG?=
 =?utf-8?B?UHFrZDFYS3h4bm1oSEVIZWJibVpKVmh4UkxPRWVKekorTGUxcWNQeU1FaHBk?=
 =?utf-8?B?QU5yampKOVBpdVdhclJTbThKOW4wYk53Z2d1bHJWS2ozVlkrM0ViWW1ualRk?=
 =?utf-8?B?RkpCeVczUWZneDQxUkJVK1haZk1pTjZlc1lPQ1Rac21mQkllMlMwZnB5Nkk5?=
 =?utf-8?B?SEpwclpKRHowMVlxelVrR0syaFhFcGtqdk02UDFLTUR3Qm5hR0oycHo1SmNo?=
 =?utf-8?B?aDBKckRUZGswclhhV3BWd3FaM2Z1dGJDQXNLb1ZGR2Q3bDhkeCtyUE5ES0RN?=
 =?utf-8?B?cW1oQzBRenZPNHJoc1czOXZHUDdLVS95R3pTejVFNXI0eGowUTdDUjJIWXNY?=
 =?utf-8?B?VDFGcDl0VFVaMWl4SnBaUDlsQjB1bVhVNDAya1BJbE1naFMrcVJNTnJHVUlk?=
 =?utf-8?B?eWx1cHVQd242dUIydkI5K0F5OGcrem53M295YjBCaUhabFozajN0d3BFQTNk?=
 =?utf-8?B?NzA1dFl2d2FaOWhwZlhSZWM4U3AvaGVVTjg5K0RFN0UxS2VUQnQzQ1Y5LzR0?=
 =?utf-8?B?NS9oRERLL0RFWFNEMTRJdHNHSDlmbVA5eER2TjQrdVY4OGJpaCtQVWEzdXZk?=
 =?utf-8?B?R21LZnNpZWJodTBMa1NSaG5aWm1HV05wY0N0ejNPbVRYLzArdkZweU5zSlRY?=
 =?utf-8?B?VUpGTkFkT25XVGdrRWo2MWtLN3g4YVZKaVpocjk0UGNSVTRadXNvSXpkamRT?=
 =?utf-8?B?N3ZnWStYUXlyNGh2L1Z6UmlDTUNhS1hYRzNEdTVyWTJzUkNCQ2hBTDFaeHlC?=
 =?utf-8?B?TEVtVjgvdHV6ZXYvclJOR3BUSzRQdCtmNndNWVV3SVQ0c1k1cS84UnNtMThE?=
 =?utf-8?B?Zmk2Y2habDVYcTd1RXJrbkYraitQVlNzck5JMGNHYk96NEdWQkU0Qk5hTHZv?=
 =?utf-8?B?WW1VaFhnOS9HNjJ5akRTMFAwY3F4aCtVQkg1SFM5VUtzMXBsdDlDQjBYSmk0?=
 =?utf-8?B?WktCV21nanFnS0I0dzhyT0NkcVRUTzRUYnJwQkhXa2R4aFgzYzhQbHdVL3lh?=
 =?utf-8?B?QnNITlhjbTlCUHptMnZGSWlIQnA5SjNiV3htRTJWM1EwUkF1azBycXRtVWJi?=
 =?utf-8?B?NzhBSmxCS29kbGZlcmNLbDA3NDgwV2dWbmkyeElBMlA0ZFRKWHVxa3VGTFov?=
 =?utf-8?B?U0liU00xRjd6Q1ppNHlkMWxHaExaZ0xRWjVoNDJhOUhrbE93WUh2amgzSGR0?=
 =?utf-8?B?T2V2MENmVm16SDdwZENrbVFQUDRKalpOaVBBTk9yQ2dIU3dyMkExVnNVa3Nk?=
 =?utf-8?B?MU9hMitVZ2FhSG9ZYTNIeDdFQU9rNTdrRllOZ3RSZnV2UTNDVmhHUzYzSGlR?=
 =?utf-8?B?OXc9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RU1pc3BGd0IyaTVjKzIzUlhVZjY3MG5kU2dHY29MNnRjczE1TE5xb1pBajVG?=
 =?utf-8?B?VjB5NGEvQ0t2M2JzUVlkS2FPRXhRS2x0b3JZd0JZRnh5RjNOUWlaeCsvOGxO?=
 =?utf-8?B?OUVzSXpEVGFwL1VQTjg3a1ZtRWhGdlgvUUU5VXFDZEo4REtwQTJoYjdyY2Jn?=
 =?utf-8?B?bkR2ZWhHdUVMbk5OMXNoeHcxTVdteXhrRDdZYnFlVUFnbTZpM1I4bUJUNlVC?=
 =?utf-8?B?aW9EMVA1MWVMZ2ZGVWQ3UW1UU0tUL2xjMENmbllOSm5PZ1oxNmNUdDdDMVBh?=
 =?utf-8?B?TDRibzdzeVNzTUZadU0wYk1hRUQ3K0lrL3RhK3Rxc1VKWXZQZHNBNTJDUi84?=
 =?utf-8?B?Q1JYRWhTK3VpcjdhaWJocWhUbU5TN2hLRXV0VVAxTlV1ckoraGUvSllPU1l1?=
 =?utf-8?B?RVU1M3pQZUl6enphS3BQOWo2eW9rMHhldC9WNTRiekJNK2ZEbGhkdUNicWEy?=
 =?utf-8?B?UHFNVmx6Nm9GV1daQTB6bUhKbWpkUld1TDllNXJnazR1NzJ3Q2xScXBhTTRo?=
 =?utf-8?B?QWlLYzBqbVVhNzRIcDAxL1FvYytDcXJlOFhveUpzWHhBU2JsSXQ5b0I4NVMx?=
 =?utf-8?B?aUlRbVB4cnRVWDJpSEhkOWw5QWpIVklob2d6YXpHTTdlUlZMUExsUzhiTzkz?=
 =?utf-8?B?ZkVJMXlLRWM5M2R6SUs4Ym56bC8xc0xOeGpJb05IdHlnbE92K0xMVTlZb05D?=
 =?utf-8?B?a1AvYkRXKzlBakFOSmhFU2d1dEJIMkljYVZoVjFzVE1JWGV5NzllN2dTbGx4?=
 =?utf-8?B?Tnl5QjdKcGpMdU5VZ2ZHbVdEaVNQb1cyRU1UMmg1TmhhRUljVmprWW5MRmVn?=
 =?utf-8?B?QUNTeXoxYVBCUWNFSU54S1BtbmFReE15QmtpcUNFUnVCUDU1Q1NKOVNFZUQr?=
 =?utf-8?B?aElwczdncHBSTWUzNUFSMEhaM1B6dlBKWldKMkJRUHZmeUt4UE1uQUx5Mm43?=
 =?utf-8?B?TlVrZC92aXhsY3luUERVREo3UmtvL1lXRTdKUXVFZnpwQlJkempOQU9NbnAy?=
 =?utf-8?B?eUZROWdxeFBpckZZZjhsSEZoakNZRU1CREFYdDAxT25Hci81TEg0ZWlvYzVs?=
 =?utf-8?B?RkFPbDBOcjAzNUpFVkRLZXRKbkZtYzlZWTdPVVhnNkIwWmYva2t2aGFHd0V5?=
 =?utf-8?B?RnNMSXROL0pkQlZtdFRyR3pMVFpNTWZpcnNmZ01XWVF5VUpJN1hodFcyNkpU?=
 =?utf-8?B?TzA4VFU3OGsxbUQ2ZlkvUWorWEFBcVpEZWE3ekd6M1o4UHhsQ25Kb3d3ZkhN?=
 =?utf-8?B?SU9iaXRDZlg4RC91MDhTZmw4czNMYnhIYTVyUWdUdTJwemp0RVN0dDZCU2VX?=
 =?utf-8?B?MTRZTmQ5MWViVUZjektCbUxHQW5MM3FzS0RxdTRwM3hNVnNwRXlZNlllaHhE?=
 =?utf-8?B?dnBCUzQvSXJiNEVIRlFQbWRpU1ZBRE9pMC91aHNPQXlQN3NKb2xrTXlXS3lS?=
 =?utf-8?B?K1hQQ1IyWW0vSDI0WFV1M0NiUlVwMmhWQ3c0OHNQSXcwSDlicFo5MkJkemM1?=
 =?utf-8?B?NW0xOGxlcFhhUmpQbWV5VHp0VEJGVkUwdEtDdUlPbzZyd0xPZldtYk50THF0?=
 =?utf-8?B?NXdUZXdaWnRHNnVocGNUMGx1Y1doeG1GSkU4QlNEQ1pJL3oxbUxkRkRyalpF?=
 =?utf-8?B?c3ZJbVgvSitpdGJDeGZONWNWbyt3aUQ3bzZRMEFNMnNWbHUwbjRJczkyVU55?=
 =?utf-8?B?SHNsL1VvenJkaVlIYzFlb01wUWZIY3ByTndLbzdldGFLMzV6MDI4Q2hEMXR3?=
 =?utf-8?B?N3FRVmZsWHMwSFNNREhxQnB3L25rQWJZeHVWOXhpcTVEVDBSZlhyUjFOdGR6?=
 =?utf-8?B?YnFPVzJiU3kzN0toVUxQbXo3VHphbWhyL2lmbzdKcVk0OWxhOEFyQlRFYWd2?=
 =?utf-8?B?bW9tak1Pb1ZSZU9nb2ZabTduZUNLMDdkdHFNUDY1Um9xbXdrQ0c1bXUrdHhp?=
 =?utf-8?B?MGVjTDg5ckczbm9rUUZ0WlhSc042SEVKekxSTWIwa2I3bHZzUmhVQmxvU0Jy?=
 =?utf-8?B?dmJKdHpPa1d0eWg1a0xsSVg4TG5MeFlRcTBkMitUcXljTVhXTldEeC9wckZZ?=
 =?utf-8?B?RWlWRmE4UFF2UkdTMnFUNWhrMGV0bUk5WDJScGRJTlUySWFiOHpvdDBzT2Uw?=
 =?utf-8?B?RFZIaWhUaG9Yb21sREREbUVtQTB4S21sb3g5TGV2R1FKSDM3KzZpcGNYdFNS?=
 =?utf-8?B?U3ErMW9xSWhzczAyd3AxUklZa0dXWDBtRnIzaE5zM2QrenMwVU52WXpQdDlv?=
 =?utf-8?B?NDRtTkVsZUZEN3pLTStLQkZwT0daQ0YwcnZ2OXE0MVVNNWNkdThRY0RaS1Jx?=
 =?utf-8?B?NVVuNzRRWUtkLzIzN0M2R2w5cTFWL0ljVHdRdnVURlBtTG0zWHdSZz09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ddee493d-c0bb-49da-0715-08de6e9e9dfa
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2026 03:34:27.2392
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d6IzCI3STf6YNtYzfGFQLvzhk6aLA1Lxdc7IksuTVwJKDRdRArgGGjo34ZdqQJ5ai21Kg6plQAlSorOU82jxYQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7182
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_COUNT_FIVE(0.00)[5];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[34];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_FROM(0.00)[bounces-71207-lists,kvm=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,amd.com:mid,amd.com:dkim,amd.com:email];
	PRECEDENCE_BULK(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ashish.kalra@amd.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[amd.com:+]
X-Rspamd-Queue-Id: 852B4152DD3
X-Rspamd-Action: no action

Hello Dave, 

On 2/17/2026 4:19 PM, Dave Hansen wrote:
> On 2/17/26 12:11, Ashish Kalra wrote:
>> From: Ashish Kalra <ashish.kalra@amd.com>
>>
>> Use configfs as an interface to re-enable RMP optimizations at runtime
>>
>> When SNP guests are launched, RMPUPDATE disables the corresponding
>> RMPOPT optimizations. Therefore, an interface is required to manually
>> re-enable RMP optimizations, as no mechanism currently exists to do so
>> during SNP guest cleanup.
> 
> Is this like a proof-of-concept to poke the hardware and show it works?
> Or, is this intended to be the way that folks actually interact with
> SEV-SNP optimization in real production scenarios?
> 
> Shouldn't freeing SEV-SNP memory back to the system do this
> automatically? Worst case, keep a 1-bit-per-GB bitmap of memory that's
> been freed and schedule_work() to run in 1 or 10 or 100 seconds. That
> should batch things up nicely enough. No?

Actually, the RMPOPT implementation is going to be a multi-phased development.

In the first phase (which is this patch-series) we enable RMPOPT globally, and let RMPUPDATE(s)
slowly switch it off over time as SNP guest spin up, and then in phase#2 once 1GB hugetlb is in place,
we enable re-issuing of RMPOPT during 1GB page cleanup.

So automatic re-issuing of RMPOPT will be done when SNP guests are shutdown and as part of 
SNP guest cleanup once 1GB hugetlb support (for guest_memfd) has been merged. 

As currently, i.e, as part of this patch series, there is no mechanism to re-issue RMPOPT
automatically as part of SNP guest cleanup, therefore this support exists to doing it
manually at runtime via configfs.

I will describe this multi-phased RMPOPT implementation plan in the cover letter for 
next revision of this patch series.

Thanks,
Ashish

> 
> I can't fathom that users don't want this to be done automatically for them.
> 
> Is the optimization scan really expensive or something? 1GB of memory
> should have a small number of megabytes of metadata to scan.

