Return-Path: <kvm+bounces-27828-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E9F7498E585
	for <lists+kvm@lfdr.de>; Wed,  2 Oct 2024 23:49:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 18D801C22260
	for <lists+kvm@lfdr.de>; Wed,  2 Oct 2024 21:49:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88C2219939D;
	Wed,  2 Oct 2024 21:49:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="S4gSmj8t"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2046.outbound.protection.outlook.com [40.107.93.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F28BD198E79;
	Wed,  2 Oct 2024 21:49:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727905765; cv=fail; b=Y9u83GOqzFcHTkArlIt4n5RtW3W78wpn1oCoaBrljxau8xmFvHq8rarAQsOJkdAu9Qu2g+qjbPn2vvGsLiIdg32NO4Tv6zdq/NUJFzyJhMjg2Se+f1N68XchJuiTwRm6Gta0s+OL6MoJK3k86DomFSmO5FOzbxaogLi6F9YoQ3M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727905765; c=relaxed/simple;
	bh=+E/4nf05TVRLLFffFLiNfg0IfDC/kYnzkxiWTrGk2sQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=UdkmHgaAq7dqTAXdh45Xe7xrgjgFl+7qa0Ch1XXjFJAgkr5QFG2ilK5o+iiFHqoBaV38cjzceWEHTz50/7Zlmrjs7wVRghgWEZoqFouYlko44yULCwfZVdpf4dpLwRxDF1o+0QShI6qRYkbdaoW8kkH39R/sGi7AD742N6B2K94=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=S4gSmj8t; arc=fail smtp.client-ip=40.107.93.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PcDbzDeMUhGO4auSE+3xsGkjkDISx6X13hkCETgN4pvsTl5jzmM0lvlu49a2IAIri4Q2VUEt3wCgkaD6e8erAY+95jigmwoTj7UhcrJxT3Lsl9x71zZR9CABn+3tUPOE+pLUgKzK5J47MF0RswqlDGjg5ZKwPfsG5+pGCu3u0+yJ2RdbrPUmMptZT6spUMzFoNjmxYDIE2bkp3luhGssJDk5s6+FQZrod/kxctt15QGUhQTcJVGonQ5Vh88IVFAli5+2zA4lQpjnM3HK1TbjTNbuk1fFx873FT3CsCqok7WOd93CppUMDbyiIa5bQUdh8ALU9KcA/gWPRcbkHOyX6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7nQiU0oGQvUcK9meGsLSBF0N9lXPu1U+iEi7uK6aX70=;
 b=Wx2GHjVWFrbEHQHb+7HIIWLi76cbq1lUU1kDlF2X4UQqIdIzNIgvPRXbMjVgzBxnagLv8RZvIMZ/VkS1OaPM2gM6WbS6b5sBmLMt8MJouk6lNHSte+raOReQuwt8JcJUQBtP7kQvBNdmzDqi272f2GwUy+NXFSZr1htqtdoMi6wgJjpZMXBdjU1i4HgM1ooJx2dogwMrg7tO83QTIRVN/t4fTPkpujNvZ7vd6t9QZ43Urd9MWGYfDM0HTGxTbxwSu+DWgPBuSyEhWxSIecXR4pn7Sk1sumotid1d4AJT8NCsrT6FtqB3RLrXcI3JpAo2G+rVv6K4uI67K6wU5lmh3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7nQiU0oGQvUcK9meGsLSBF0N9lXPu1U+iEi7uK6aX70=;
 b=S4gSmj8tyxb2SzO3HdeMHs5+CfvoV4PFO9Gg/sa7i9u/yo6B3QxBGgPNTkaBmnLgbXRuJBFkcgeYoU4Cs9/DQjxAkBPQfav1NxNIS+2wcn58L5p99I1GEVWPKK60tTOjfXKfwXp54FO95tfsfLordRYgG8WISwKfLbh9XHYFLLY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by BL1PR12MB5874.namprd12.prod.outlook.com (2603:10b6:208:396::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8026.16; Wed, 2 Oct
 2024 21:49:19 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%5]) with mapi id 15.20.8026.016; Wed, 2 Oct 2024
 21:49:19 +0000
Message-ID: <08e55c68-f027-1213-bc3e-180a9127c82d@amd.com>
Date: Wed, 2 Oct 2024 16:49:17 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v2 2/3] crypto: ccp: Add support for SNP_FEATURE_INFO
 command
Content-Language: en-US
To: "Kalra, Ashish" <ashish.kalra@amd.com>, seanjc@google.com,
 pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, hpa@zytor.com, herbert@gondor.apana.org.au
Cc: x86@kernel.org, john.allen@amd.com, davem@davemloft.net,
 michael.roth@amd.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org
References: <cover.1726602374.git.ashish.kalra@amd.com>
 <0f225b9d547694cc473ec14d90d1a821845534c3.1726602374.git.ashish.kalra@amd.com>
 <3b2e58da-33da-1b40-2599-e7992e1674c7@amd.com>
 <5ac11cd9-dfd5-499f-b232-5c9d0ed485eb@amd.com>
 <c80e8b87-cd39-4d6f-a170-19e66d83c273@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <c80e8b87-cd39-4d6f-a170-19e66d83c273@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR13CA0106.namprd13.prod.outlook.com
 (2603:10b6:806:24::21) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|BL1PR12MB5874:EE_
X-MS-Office365-Filtering-Correlation-Id: cea91969-615e-4475-3783-08dce32c11d7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dWNodEVjUUlISkY1VVYzSWJXUWdtdVBXYzJ1SWtTQlFSalhHMGMzcHYzc24z?=
 =?utf-8?B?MEZZQk00aXc5bGN4SkdNcVZSeldmWHVWVk8zOTFmdlpuY1FSazV5WkpidTEw?=
 =?utf-8?B?ZnNISlNueHNQMUJkbDFSMUlpN3pHOHh6UHhORDhsOVRBbW9scStEWWx5WXdL?=
 =?utf-8?B?RFM5S0pRVWhPUVUyVjRXNHlCTC9GUjVDU01UaU5QTU0yMnZ6RnNpdGVNMHV0?=
 =?utf-8?B?ZEIzOUNIa29QS3B0aUZoanUvN0pwTHBuZS9Wc0lQL2hQeUVvcnA5Mm5uK2Zw?=
 =?utf-8?B?eU5mSXIxLzBDdHVBU0NBN2NDSU5rZ3VhSldrTnQzd3pwWEx0eVlPd1VFcm14?=
 =?utf-8?B?VVRyVDlJaWNpQlREQ3QzZC9LUVN3RnBBaDdkbFRLdSsvYXRvMURvbUM4eFUw?=
 =?utf-8?B?MGlOajNyUi9idU9NcUxkUnJNZXZLZkJTL0NTUGtwVTNvQUIrWkU3eG82TlNY?=
 =?utf-8?B?WWl2ZzF1MkIwT1VzdXF5YVd5ZWVmazlZc1cwbUx5NFUrNnFLb0V0cEdTRytG?=
 =?utf-8?B?dml5cWRTQ1JaR3BvZFlyYUV5ZlBoSEN6Qm9VTU5Kc2hJbW10VWYzYVdGR2Z0?=
 =?utf-8?B?QkxtWTNpQmR5YmU4Znp2d3I1SVVyVi9abHkzWjRQTTQvK0RpZ3M1SXpXdG8y?=
 =?utf-8?B?RUgyYTgrR3JzQjBHSXFYMGhJd20yNWJWdk9FTHplSFVIdVJDMlRTV09nYWZz?=
 =?utf-8?B?MWkwdzZHKzdqSG9oamxWaWVGS0FuSHBiRlVacFdGbGlBbi9kdW1NemQ4YTFt?=
 =?utf-8?B?NVgwRFpZQ2FQZjlJT3R5M2VCMkR5NFFNVFUyaXY2czc3Y0l0blpMczNtNnJw?=
 =?utf-8?B?c2R1Z3BQVXJxeXBremxtdlV0ODU4NFVyMTRXTXlMMzE3aTA2YmhsbTVCYTBh?=
 =?utf-8?B?Nm5pREVtS1VXVjhDelJwOWlyOExWQUpHVEJDOXBQaWUxSHhmMHV5TytvV2dW?=
 =?utf-8?B?N0lkNzVYR3gweEdZM2pjNHF6TDlmYy9QZ0MwS0dwZS9YSzg3d1JiR0VMbGd3?=
 =?utf-8?B?YjVFQnlRYTQvNGpRTmlWU2lnajVza0x5bTRMS2tSNHVXaXlxa051WW5HeUdL?=
 =?utf-8?B?QWVXRHFnT3laekwvMXIrRWlVY3VXNFNQeGpBeHhvYzZucThvaEE0aHpYQjZR?=
 =?utf-8?B?L1FHVUtqRGlLand0bHo5UWZERVZXMjZnc09PenhmSTVFeUMvR0tWb3RIdThF?=
 =?utf-8?B?UWZOSDFSTFYzaHlyekxyZUQvS0FGNFZ3ZzFpSGFaSUJFaXc2Yjd4OStrL1Jt?=
 =?utf-8?B?cGNNM3M5MVU2NmRwNVIrNzRYSXNPamtRejFyMktQTGsveSsrZDB6cFBQUWxt?=
 =?utf-8?B?bENzSmRzWC8wV2R4cWh6b214bnQyTXRoWHJnaUkwWFNuSUdlQm1mNTRnT29v?=
 =?utf-8?B?TWZuTUliWHkzZ0FYRVdqdjdFYlU3eisxZktaaElHaWxRUDNGckJWNDZxMWRn?=
 =?utf-8?B?akoyUzdROFJTanZ5cUhDQjhXcitjRWZGd3Avbk9rd3pCVmZmVGtQZnhzRSth?=
 =?utf-8?B?dmpyV3NyU01HSlJvWXRTNDBCT2RIUUIwRnp4Qjd0eUx5RDBKb2liVk53Tm5u?=
 =?utf-8?B?amhxZmR0ZTF0UlZ4dndmYzdEZXl0YWxhc2lteVpGU2taOWxkNE9WMWtPZ2pK?=
 =?utf-8?B?aE9XVWx2djhQZ1NDZkhhV2FTNlIwTFlYOWFlUGIvemExSzgxSFNyK2RxQ1hS?=
 =?utf-8?B?bFRGRnJiL2pxRitiK0RBNEtRSm00UjRqRTl1WFhrenJqVlRtZXNDZVZ0Y3lu?=
 =?utf-8?Q?1bpmjWJ9jGOxdCmY1suMHpw5GM3fYBAiSaS2j4s?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?d0NLSXVGRHliQnQzUW40UmdEVWJtVHM2Ykx5NnNXYmczc2NXL3hRNytXR3p3?=
 =?utf-8?B?TVZJajhaRXg2dXdma2U0bWZUR3pYUkJ3MkRoZWgyNERVVndBSUEzTkxmOWcv?=
 =?utf-8?B?V1FYckI5cEJPSGJoU3JZalliOUtBWjdITTUvVDJUSGdjMURjWVhJc0tKYkE1?=
 =?utf-8?B?TXJnemlTcEd2VnFZU2hNVE9yN21EWnFOejRidmNjaThmZ25TL2xTOFBQeGNL?=
 =?utf-8?B?a09aWG5sWkJDdkJ2SmQ1UUZMVW0zWm9vY085MU5ZNFRrL1lvL3kxa294NW5Q?=
 =?utf-8?B?QUxHRFJ6bm1MM1VxK0xCczMzaUgrUExXZzJJZW13b0pYekhkaGdPYzVhVmpV?=
 =?utf-8?B?TEhpOFBtSjdFazF4Z3lBK3RvdFRSNU5YTVBNQXpseGZhVDdaVW04V3Frd29C?=
 =?utf-8?B?U0R1ZXZIMVk1U1k1YTg0VC9sMStPa0FCWXV5VGtWMlVtb0dvYnpTa2RIVFlo?=
 =?utf-8?B?ODUxWVNpSlo0Z29mMzVXaGZ4MStuWlA2ZzdCTjlFUkVtcmVHWVQvYTAxUHRl?=
 =?utf-8?B?aExZa3ZHVXVHUnUxN0hLRnZ0aC9EMWNjd2IzNHhLU1VPMDdKZi8xbmxEbHVK?=
 =?utf-8?B?TFhOUzQzUUhsNW5KaDlpSjNRS1dsR2FXUjAwYTZvOS9Oa3JTcCtTWS9CM09I?=
 =?utf-8?B?RWFRdm9JdkNMN0oxQ2psNUVIeGFreHcyczNMZEpORUJKSTBTOVA4M1VYLzZu?=
 =?utf-8?B?czhvUTVFWXdQZkZCZVlyb3htUEV4cWVQTGtIa2VpVXZocUoyOUs0TDhXNzA2?=
 =?utf-8?B?WGdKWDduZkZ0NkRFTjIxSVVRa25yQWUyVlNhNVFqRjlwRWt5eXV0MXRDa05m?=
 =?utf-8?B?QVBaeTIyVmJmajcxZURCMjY1QkU5ZlpxTFZqbE8wVWFQREVwZFloTVRUYy9h?=
 =?utf-8?B?UTM0TUlJMExHUjBCWmRyT09TZm5RSExyeGtUSElHU1VYK3NIQnZmZkErRXpE?=
 =?utf-8?B?QjFBcWU1VkN2NUVXdXZwdnBKTU5qUGFpelgvblY5NVZaYzkreVVKTFcvY2kr?=
 =?utf-8?B?bTBTVFo0ZisxbENDdTc5Q0k3b1kvb3EvTEJZaE1QaXVtY2RvU01KV2VaMnRt?=
 =?utf-8?B?RDl6S2UzUE5BR0dKMys1d2ZnZmNJeUU0NXBmK00vd2h6cWhYZUt0dFQ1dklU?=
 =?utf-8?B?dmdxMVhZRVhYVGFTTXpZS0NBUFErRllIZS9Ocm5MREdLS2xDVjBHTWs5alFx?=
 =?utf-8?B?bXdnVDhzN2Z0S1VhVGcyQ2JtM3VBcjJFeTFaMERPMVljY29iWW9UYTBKdTJQ?=
 =?utf-8?B?YWtKRm9xMUxpbTNBK2o5Q21oeHhmY3lEVzFGakRWUWlNL1ZzWlEyM3J6R3pP?=
 =?utf-8?B?Mm9nZC8xMHFQNStmVGh4VngwNm9FOEpUS2VCbENGRGZoc2hZNnFsMmR4Z0hP?=
 =?utf-8?B?ZS9DOW9FWnJDMEJOblFJRGs5ekNLTzNWdmZvWFJta3Fyb0FhWDB1WU1URzlQ?=
 =?utf-8?B?TmZLVFI1a2FIT3IzWFl6cGx3TXIzMkRjMWNadDV6QVQvRXBnNUROR2Z2djI0?=
 =?utf-8?B?TXpuK1FhcXRQK0FIRnhicVlEcGZVMU1tenRvZ3ZNRGhrd1IzcHJwQVVMM1BX?=
 =?utf-8?B?dmtWeWlSdDR3OWtSc0lWb043azk2VS9BbmlqZStFWkh0NjFBbEpZOUZMMHMw?=
 =?utf-8?B?Q1VvZTd5UjVIa1FVVG1pWkxwSUE2YitaMDR0a0M1dVg4UmV0YTVoVTEyOVho?=
 =?utf-8?B?UDdCS3hNTjVwTlR1N05MMGNSbHJsNlc4aUpLV0pJMUh2anpzSjVkcDJpRlgw?=
 =?utf-8?B?SWxIZWFKWEQrWkRvZjBvWVc3ZzJqZmcrS212UmQxZDUvVUcwMlh0eHIxRVV2?=
 =?utf-8?B?ZTNZYVY5MjBlU0ZML2l2MEczbnlXL3E2V3JWNXZSdHJ0UUx4NFpSN3lJZkVa?=
 =?utf-8?B?TnUrMnNwM0hlY0FYdjlBUENIRmlaMFVZSDF2TitNZXA5bEhpVG1sdy8vYlNl?=
 =?utf-8?B?ekVJcXFUQ2RtUFdzeWJWVFZTWnBSSzlWVkpad0NjM3dpTHVoVUxueUdXeGp6?=
 =?utf-8?B?eHN0NE4vTEMyWTdXSTZxL0hWcGliRE1qY0dWSjBwQkdXc2o4RFhEMEtOTTFT?=
 =?utf-8?B?WWNXQXNlblBpMUF6WnZHRW81TTdBRlBNZzNTcncwd1orMjB6eDk5N1hTbGFG?=
 =?utf-8?Q?z7lt5nYIRWnwfrs9qdudYNbzK?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cea91969-615e-4475-3783-08dce32c11d7
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2024 21:49:19.8490
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GCxtHS8jDQRW8gFoNmgdB7NjLbWD8yHSagaOeNViLX3g+3ilagspps8r1tTB/hAwEkVBR/ReL0dh/ABTjn1g7g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5874

On 10/2/24 16:40, Kalra, Ashish wrote:
> Hello Tom,
> 
> On 10/2/2024 4:19 PM, Tom Lendacky wrote:
>> On 10/2/24 16:18, Tom Lendacky wrote:
>>> On 9/17/24 15:16, Ashish Kalra wrote:
>>>> From: Ashish Kalra <ashish.kalra@amd.com>
>>>>
>>>> The FEATURE_INFO command provides host and guests a programmatic means
>>>> to learn about the supported features of the currently loaded firmware.
>>>> FEATURE_INFO command leverages the same mechanism as the CPUID instruction.
>>>> Instead of using the CPUID instruction to retrieve Fn8000_0024,
>>>> software can use FEATURE_INFO.
>>>>
>>>> Host/Hypervisor would use the FEATURE_INFO command, while guests would
>>>> actually issue the CPUID instruction.
>>>>
>>>> The hypervisor can provide Fn8000_0024 values to the guest via the CPUID
>>>> page in SNP_LAUNCH_UPDATE. As with all CPUID output recorded in that page,
>>>> the hypervisor can filter Fn8000_0024. The firmware will examine
>>>> Fn8000_0024 and apply its CPUID policy.
>>>>
>>>> During CCP module initialization, after firmware update, the SNP
>>>> platform status and feature information from CPUID 0x8000_0024,
>>>> sub-function 0, are cached in the sev_device structure.
>>>>
>>>> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
>>>> ---
>>>>  drivers/crypto/ccp/sev-dev.c | 47 ++++++++++++++++++++++++++++++++++++
>>>>  drivers/crypto/ccp/sev-dev.h |  3 +++
>>>>  include/linux/psp-sev.h      | 29 ++++++++++++++++++++++
>>>>  3 files changed, 79 insertions(+)
>>>>
>>>> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
>>>> index af018afd9cd7..564daf748293 100644
>>>> --- a/drivers/crypto/ccp/sev-dev.c
>>>> +++ b/drivers/crypto/ccp/sev-dev.c
>>>> @@ -223,6 +223,7 @@ static int sev_cmd_buffer_len(int cmd)
>>>>  	case SEV_CMD_SNP_GUEST_REQUEST:		return sizeof(struct sev_data_snp_guest_request);
>>>>  	case SEV_CMD_SNP_CONFIG:		return sizeof(struct sev_user_data_snp_config);
>>>>  	case SEV_CMD_SNP_COMMIT:		return sizeof(struct sev_data_snp_commit);
>>>> +	case SEV_CMD_SNP_FEATURE_INFO:		return sizeof(struct snp_feature_info);
>>>>  	default:				return 0;
>>>>  	}
>>>>  
>>>> @@ -1063,6 +1064,50 @@ static void snp_set_hsave_pa(void *arg)
>>>>  	wrmsrl(MSR_VM_HSAVE_PA, 0);
>>>>  }
>>>>  
>>>> +static void snp_get_platform_data(void)
>>>> +{
>>>> +	struct sev_device *sev = psp_master->sev_data;
>>>> +	struct sev_data_snp_feature_info snp_feat_info;
>>>> +	struct snp_feature_info *feat_info;
>>>> +	struct sev_data_snp_addr buf;
>>>> +	int error = 0, rc;
>>>> +
>>>> +	if (!cc_platform_has(CC_ATTR_HOST_SEV_SNP))
>>>> +		return;
>>>> +
>>>> +	/*
>>>> +	 * The output buffer must be firmware page if SEV-SNP is
>>>> +	 * initialized.
>>> This comment is a little confusing relative to the "if" check that is
>>> performed. Add some more detail about what this check is for.
>>>
>>> But... would this ever need to be called after SNP_INIT? Would we want
>>> to call this again after, say, a DOWNLOAD_FIRMWARE command?
>> Although, as I hit send I realized that we only do DOWNLOAD_FIRMWARE
>> before SNP is initialized (currently).
> 
> We do have DOWNLOAD_FIRMWARE_EX support coming up which can/will happen after SNP_INIT, but there we can still use SEV's PLATFORM_DATA command to get (updated) SEV/SNP firmware version.

But you probably also want to get updated platform data, too. So I would
think you would want to be able to call this routine again, post SNP_INIT.

Thanks,
Tom

> 
> Thanks, Ashish
> 
>>
>> Thanks,
>> Tom
>>
>>> Thanks,
>>> Tom
>>>
>>>> +	 */
>>>> +	if (sev->snp_initialized)
>>>> +		return;
>>>> +
>>>> +	buf.address = __psp_pa(&sev->snp_plat_status);
>>>> +	rc = __sev_do_cmd_locked(SEV_CMD_SNP_PLATFORM_STATUS, &buf, &error);
>>>> +
>>>> +	/*
>>>> +	 * Do feature discovery of the currently loaded firmware,
>>>> +	 * and cache feature information from CPUID 0x8000_0024,
>>>> +	 * sub-function 0.
>>>> +	 */
>>>> +	if (!rc && sev->snp_plat_status.feature_info) {
>>>> +		/*
>>>> +		 * Use dynamically allocated structure for the SNP_FEATURE_INFO
>>>> +		 * command to handle any alignment and page boundary check
>>>> +		 * requirements.
>>>> +		 */
>>>> +		feat_info = kzalloc(sizeof(*feat_info), GFP_KERNEL);
>>>> +		snp_feat_info.length = sizeof(snp_feat_info);
>>>> +		snp_feat_info.ecx_in = 0;
>>>> +		snp_feat_info.feature_info_paddr = __psp_pa(feat_info);
>>>> +
>>>> +		rc = __sev_do_cmd_locked(SEV_CMD_SNP_FEATURE_INFO, &snp_feat_info, &error);
>>>> +		if (!rc)
>>>> +			sev->feat_info = *feat_info;
>>>> +		kfree(feat_info);
>>>> +	}
>>>> +}
>>>> +
>>>>  static int snp_filter_reserved_mem_regions(struct resource *rs, void *arg)
>>>>  {
>>>>  	struct sev_data_range_list *range_list = arg;
>>>> @@ -2415,6 +2460,8 @@ void sev_pci_init(void)
>>>>  			 api_major, api_minor, build,
>>>>  			 sev->api_major, sev->api_minor, sev->build);
>>>>  
>>>> +	snp_get_platform_data();
>>>> +
>>>>  	/* Initialize the platform */
>>>>  	args.probe = true;
>>>>  	rc = sev_platform_init(&args);
>>>> diff --git a/drivers/crypto/ccp/sev-dev.h b/drivers/crypto/ccp/sev-dev.h
>>>> index 3e4e5574e88a..1c1a51e52d2b 100644
>>>> --- a/drivers/crypto/ccp/sev-dev.h
>>>> +++ b/drivers/crypto/ccp/sev-dev.h
>>>> @@ -57,6 +57,9 @@ struct sev_device {
>>>>  	bool cmd_buf_backup_active;
>>>>  
>>>>  	bool snp_initialized;
>>>> +
>>>> +	struct sev_user_data_snp_status snp_plat_status;
>>>> +	struct snp_feature_info feat_info;
>>>>  };
>>>>  
>>>>  int sev_dev_init(struct psp_device *psp);
>>>> diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
>>>> index 903ddfea8585..6068a89839e1 100644
>>>> --- a/include/linux/psp-sev.h
>>>> +++ b/include/linux/psp-sev.h
>>>> @@ -107,6 +107,7 @@ enum sev_cmd {
>>>>  	SEV_CMD_SNP_DOWNLOAD_FIRMWARE_EX = 0x0CA,
>>>>  	SEV_CMD_SNP_COMMIT		= 0x0CB,
>>>>  	SEV_CMD_SNP_VLEK_LOAD		= 0x0CD,
>>>> +	SEV_CMD_SNP_FEATURE_INFO	= 0x0CE,
>>>>  
>>>>  	SEV_CMD_MAX,
>>>>  };
>>>> @@ -812,6 +813,34 @@ struct sev_data_snp_commit {
>>>>  	u32 len;
>>>>  } __packed;
>>>>  
>>>> +/**
>>>> + * struct sev_data_snp_feature_info - SEV_SNP_FEATURE_INFO structure
>>>> + *
>>>> + * @length: len of the command buffer read by the PSP
>>>> + * @ecx_in: subfunction index
>>>> + * @feature_info_paddr : SPA of the FEATURE_INFO structure
>>>> + */
>>>> +struct sev_data_snp_feature_info {
>>>> +	u32 length;
>>>> +	u32 ecx_in;
>>>> +	u64 feature_info_paddr;
>>>> +} __packed;
>>>> +
>>>> +/**
>>>> + * struct feature_info - FEATURE_INFO structure
>>>> + *
>>>> + * @eax: output of SNP_FEATURE_INFO command
>>>> + * @ebx: output of SNP_FEATURE_INFO command
>>>> + * @ecx: output of SNP_FEATURE_INFO command
>>>> + * #edx: output of SNP_FEATURE_INFO command
>>>> + */
>>>> +struct snp_feature_info {
>>>> +	u32 eax;
>>>> +	u32 ebx;
>>>> +	u32 ecx;
>>>> +	u32 edx;
>>>> +} __packed;
>>>> +
>>>>  #ifdef CONFIG_CRYPTO_DEV_SP_PSP
>>>>  
>>>>  /**

