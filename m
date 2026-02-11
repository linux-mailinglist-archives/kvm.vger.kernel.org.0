Return-Path: <kvm+bounces-70881-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WKl2GQazjGlLsQAAu9opvQ
	(envelope-from <kvm+bounces-70881-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 17:49:10 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id BBE3F1264EB
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 17:49:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 088EE303A6FB
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 16:46:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB6D53451BA;
	Wed, 11 Feb 2026 16:46:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=citrix.com header.i=@citrix.com header.b="AXs5Mz8T"
X-Original-To: kvm@vger.kernel.org
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012047.outbound.protection.outlook.com [52.101.48.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04BB3223702;
	Wed, 11 Feb 2026 16:46:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770828409; cv=fail; b=Lq1HNQeTEBNTwEk2aG3bN0UPWsqaLk82GLS4k0Dev4K55YRy1ptUhw2qJ6r2PPsnhEQ1LUjPQcYGobqaAjxtDL5yKnp9o6nVTAROOL1y8/kajWmNUh+ojVt1IhO6f71JmJe0akGwNAgdlHCyAo4ODK7FB97VADoGgCLOBTvEsI4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770828409; c=relaxed/simple;
	bh=i59FZyx7MCJIBGjMlgyDibkWpQAR+b9zvOUnmHS+5fk=;
	h=Message-ID:Date:Cc:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=FAvDTaGvDylYHsKEoCvK+4ZlIJPovvWLICcRpaUdWb6d+zuiwcp2NiABofNkKPzqWnfjTyY1DHSxSHfkOg9mbTi9b5zCOsrmPwNBhGPbZr4HDn8/I4rXXg9vPlDcMDfH5gFHwxLf/dpR2aEU5UcuXWTKSNS8vdLB+YQt/0+SFbg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=citrix.com; spf=pass smtp.mailfrom=citrix.com; dkim=pass (1024-bit key) header.d=citrix.com header.i=@citrix.com header.b=AXs5Mz8T; arc=fail smtp.client-ip=52.101.48.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=citrix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=citrix.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=E6uN8piBK1zUNkv4fPIiFF63sNtjVbG/aZhaadFR3fJh5l4lF8J6DZKbA+I7V2XC32Fnv1uTXVGBLwvY/pSuiktNYvay7R/onhYyMQu/w2c6hzPU0rW1cAx+xf1KTgP6NgGhzVNGRToCALgFnU4j9yWXO8AOE5CtzVc7xASu2OytMEbxhn60df3D8+hg4DwaZtxIm8pVNplITR8GdtJA8P71deIQQavXba8FQN/7Rk+7Clw4QvtmmJtsvXXzyry9cu3H+lV2Yq0w2xe1/cxBjO2XAKgWUvimFEpPJSspgAVMLMZ9z08Xfv2eLNnAuC0cXXdgv+ozNiI/1lj5WqTAug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p0R5bZcWxa3rvhBEzqEuaXqY+va/srSAHI1Odr93uFQ=;
 b=Tq5yue1zQ9PINeGTnBWhBFQ8sAEzyEgiJMUrlc6P8zD+8RCfuArGULSFhjHo1C+AxBIEljtlySkMpeF8HloxiSl9tspD2mlerfvz22UvxuzvyFHOwrd0iqyUAA0mEqtztxEhMRbXjtXy/cRCJj0h7g/nVVlsX0LIqb23fHbrrJIldi3MmWnZWDMQSQGxZe6OWE+Y92PRzwWlyCi+1CvUOqyqVqxYkarqjPTn5zvytVFydokOQyj/lIozpx81p5BzlxzzdNLTwPJl6xjbwJGCHsN017ZegEhZTe4tHl6jgzOAIMiYYiH0hpTqrJSdTfUutnaQCP0CpFrk19VU+dt6Vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=citrix.com; dmarc=pass action=none header.from=citrix.com;
 dkim=pass header.d=citrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=citrix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p0R5bZcWxa3rvhBEzqEuaXqY+va/srSAHI1Odr93uFQ=;
 b=AXs5Mz8TZhSKjN0x34BwU1n3RT+Fbk0HQWL+qpN8L3JmYBLgqbsKKVg6LaE3a8v5eiZHDdN3HouDqmnThCQujzfpQbXmgEn9avJ9YGZRy/NL9dErwrWjUBUPyHRSSxuMkTWJeqPfepSxHic2DiZwVDG2Gsg+5G4QCRArmw+F8OE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=citrix.com;
Received: from CH8PR03MB8275.namprd03.prod.outlook.com (2603:10b6:610:2b9::7)
 by IA3PR03MB8381.namprd03.prod.outlook.com (2603:10b6:208:543::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.10; Wed, 11 Feb
 2026 16:46:45 +0000
Received: from CH8PR03MB8275.namprd03.prod.outlook.com
 ([fe80::a70d:dc32:bba8:ce37]) by CH8PR03MB8275.namprd03.prod.outlook.com
 ([fe80::a70d:dc32:bba8:ce37%6]) with mapi id 15.20.9611.008; Wed, 11 Feb 2026
 16:46:45 +0000
Message-ID: <18c8bccc-f57f-401c-9b86-248d1632f9d9@citrix.com>
Date: Wed, 11 Feb 2026 16:46:41 +0000
User-Agent: Mozilla Thunderbird
Cc: Andrew Cooper <andrew.cooper3@citrix.com>,
 David Laight <david.laight.linux@gmail.com>, ubizjak@gmail.com,
 bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@kernel.org,
 pbonzini@redhat.com, tglx@kernel.org, x86@kernel.org
Subject: Re: [PATCH 1/2] KVM: VMX: Drop obsolete branch hint prefixes from
 inline asm
To: Sean Christopherson <seanjc@google.com>
References: <20260211102928.100944-1-ubizjak@gmail.com>
 <2af5e3a8-f520-40fd-96a5-28555c3e4a5e@citrix.com>
 <20260211134342.45b7e19e@pumpkin>
 <5276256b-9669-46df-8fcd-b216f3d3e45b@citrix.com>
 <aYyjw0FxDfNqgPDn@google.com>
 <bc3784ea-3315-4e96-9cc9-7f837410e7d9@citrix.com>
 <aYyrnjV4ewtXlSeL@google.com>
Content-Language: en-GB
From: Andrew Cooper <andrew.cooper3@citrix.com>
In-Reply-To: <aYyrnjV4ewtXlSeL@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO2P123CA0091.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:139::6) To CH8PR03MB8275.namprd03.prod.outlook.com
 (2603:10b6:610:2b9::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH8PR03MB8275:EE_|IA3PR03MB8381:EE_
X-MS-Office365-Filtering-Correlation-Id: 3d073f94-dcf7-4364-a47f-08de698d246e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?QXdaOFBEYUlTRE9tTkN5QUpqZkpsSlduaFFWbk42QnNjZDhmdmMxczAvMnMw?=
 =?utf-8?B?eFZVZmRzYkVkczFCR1VXZEZ4aXA1VTZ1M2lCdFZrUWJKNDlXRjg5M3V6Ung0?=
 =?utf-8?B?azVKcmZiVCtMU0QwTUEvY2duek1RK0xZRmdQeDdOUG13ekRvRGRUUkRXSzN1?=
 =?utf-8?B?Z3N6dWdicUFCSFdzLzBXck5ISVVwSUdmZlpXSDJBVTdPWThVWlNodHNuYWRF?=
 =?utf-8?B?OXFDWTMzK1cwMWpaOTFqQURFZHVxRUF6Uit4azZKNXZaeW51WEhjdE9QNjJw?=
 =?utf-8?B?QlpXdzdEQXhFN2ExdU9YRnAxVm53d1pDbVk0Sm1SbU90NkhSK2RhME8xTC9D?=
 =?utf-8?B?SjNyUHJvUlZWYVR2RmtsU0xSbXpDQUZhQm93QzVDem91ZytEcWFxMkc5dWJl?=
 =?utf-8?B?amdRT0ZxLzhDS3hQMTB2Zmd2eXBaYStqY3RkcUZoWEM3clJqYWJEaGErZzFD?=
 =?utf-8?B?azFkdlNOWWRIT0tpc0dDdUxpSlNtdGpiWkxrWVkvaDB0MXBnM1l2WXlVMlRJ?=
 =?utf-8?B?R252ZkZKMnZxcG41bmZpbHA3bWdoczU2Sy9tTnlZN2QzYVRhemx3TnkxZGV1?=
 =?utf-8?B?Vng0NXpKSEVTUmI2S2VaVjVXckZFdEs1Smx5Z2h0UG1zRDNLVHZBQzM2cTEy?=
 =?utf-8?B?S0ZzTzNHbUtRWnUvdWg1eXpBaGJONjBVT1Mra29xbVo1VVhmdFVoWmpYVzdS?=
 =?utf-8?B?SGJyWjBEL2ZUYlB6Y3l3MnEzWTRRS1l3OEt3REZSVmM5REtkenZyVTlKQ2w3?=
 =?utf-8?B?ekViSllaYitKSEp2VHRodjRSRG9RdGI5M3huR0p4VEVBU0xNVXJkMG54UWZK?=
 =?utf-8?B?bURETGR4SmpEbU9hWkh3bzlhR1lEK1pwYVAxeER6NjdneHdnMHVNMXg2aHBj?=
 =?utf-8?B?b0JZZG1idmltZmtUMXF1YkNyUHdZRmRiUUgxbjhuZVBiS1I0Yzg3bWg4aGZ2?=
 =?utf-8?B?UlRLTjczaUpGRU5PZVFUeGdoZVo5cnFxNEtVMVY0N1pWUjlEc1M5b2QyaDJD?=
 =?utf-8?B?Zks4bi9JQnBWK2dBd0FWWjVmWnd2TG9sV0EzdlI1dUo2VUpndy92UStCOHdw?=
 =?utf-8?B?cTlEODh2dU9KSmxGN296UnkwbDNyVWxmNCt5czNiOU9pNmhZdE1MbEtJVTAy?=
 =?utf-8?B?T2U3TWdHWWgvRnRxdVFBbTc2d2dDQXFORDl5NkVuSUhhN1ZtcTVReDBwTFFS?=
 =?utf-8?B?VHlQY0psdVNldGV6bmg5RGZkcG0wNWxiY3FCV1lMMTZzVDRkWmZ5ZEpqTXFF?=
 =?utf-8?B?Q2RPbFhLSEtrdUhWY3MxQ1JRZ0xXbWFBTlByVTdYREdvMnBjMy9lV3pKbk10?=
 =?utf-8?B?UXBpUjIxa2dDUjc2Q2E2cFo1RVZCb0MzS2U3bUprS3M1d0VkQXQwR25CZVoy?=
 =?utf-8?B?dzhrajF4akoyNVJMc0wybFJrblcybDFLVlZyY2s0Qm1YMTZkclpLaHBSdmtP?=
 =?utf-8?B?N3kyY09MNDltclNvT1o4cllzeDUvTW13Q05kNllweXZyLzVYVmdoNVcvQ0pS?=
 =?utf-8?B?RVJwOURDUmRZNzQ3ME5uUkRyK2ErZTBYSzhPQWtEcnRkU2JoVVp2SHdha3dP?=
 =?utf-8?B?UkZsd3V3VnBka095cHpWRmx4R2tDOUI3Mzkra1J5eFBTUmI0N1RLc0s5Wld4?=
 =?utf-8?B?c3V4NFA1MGFGM2hOWmp5bWl1QjFKVWVYTDBFSGhlZ01CZktKL3EzSE9vaTVU?=
 =?utf-8?B?aXJtQmM0ZFdHZWphL09JTEpWQmJUMWdaeGs4bm9oYnpuWHFBSjd2emVNbTNn?=
 =?utf-8?B?YlZxT1RUQVhiNjFYTXpmTUxoYUZUUlQyb3l1eS9nS1hnM3c2RWgzT2VKRHM5?=
 =?utf-8?B?Q1N1SkxtazExUkxOeUhNOFhFNlZtSWZTclZtSFlZMXBwT1h4LzUrQW15UUEy?=
 =?utf-8?B?UE9CU2R6dFhGVU1IMC9KLzBqYzROcDVOcC9NYzdtZXJLamVEVzhKSFI0VWYy?=
 =?utf-8?B?NEVEejVkVElIeDZrZHJ1ODRFVE03QnhjWXVRZ0oyMlZGT21ES25qczlBN1ZN?=
 =?utf-8?B?T3V3UStqbjdGVm4ybU9zbWRPcmlPNk1mMkZlWnc3cWl1STNiU0JDNkhCSDc0?=
 =?utf-8?B?bXlkdFJkSmVkTUdDMEdXMldIQ1J0NUlPNUFSQThkZFM4a1hCTUkxSDVhWlZF?=
 =?utf-8?Q?8NFM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH8PR03MB8275.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?N3M4SGZDcnV0MEZLTE0xbzdORWdoMk5meUxkZ0tKRnRMSnRDTFF0KzNydmJy?=
 =?utf-8?B?aGFBN2ZwWjhFNGJzMWZqN1JVc1hhMG1vaWdFbzlPVXZySFM0Sk1TeUxTZlNU?=
 =?utf-8?B?OEdCVEh1VUN6REY4Rk03ZGlOZkIzMm9oN0Y4V3BGNXYwTVhVMzgyemJ4N3hh?=
 =?utf-8?B?QTJpTFRDa240S3Yzb0kyZVROTUVITm1iT3ZTNEk4SzFlcTBTUThjNXRxblJC?=
 =?utf-8?B?Q2E3WTRMa0RRVm10K2hYL2duUVRrN3RwYVdpbHFSRXNWZEM4ejd3QlVGTFJ1?=
 =?utf-8?B?NFFRSVpGb1hPdWs1NWEvV2MzRmxlSEdINE0yclU5VDhOZ3hCeXZobHp3K2dP?=
 =?utf-8?B?T01pRlB1RjYveTkrdkt0cGo2VWZtTGNhSFdZV1RZbm1yK0ExRjA1MTBqeXYz?=
 =?utf-8?B?RFgxcnZzQndHQVc0Z082TEQ0Q1BsUG5hWmFqRVFYb0tWVisxOXBvYWZHVlh5?=
 =?utf-8?B?WjlBVTlLTFF5QTYrMCtyU01kSGNHYUNvTDluODk2S2xrNUNiZTdsbjJYd1Rq?=
 =?utf-8?B?SEdPK1UrUmxRMk1yK1ArRE1DaHkxQmU1UjVQUnVVQnZMNlhvMktyejRYa3ky?=
 =?utf-8?B?UzdWbzJwTGpaTk43RnFZSW1Bb3NJL1VyT1N0WitQZEZDOXdEUDh1VzdIWUlh?=
 =?utf-8?B?dURuTTNxbDY5cXdURXNvdzdiWnVuSmt5eExsa2xCSTRhVEFiY1p1SUQ5WEJX?=
 =?utf-8?B?ZXNISVJXQURMaVVzYUZ6U2NQUFBwRkdtZmdVbW5QZTgzT3ZDWGtNVlcwQmU2?=
 =?utf-8?B?cXh0Ri91NE5LTVU5WVFpT2NPNElCQjVLR1RHdWtScTVzV0ZtVlordzRuU1c0?=
 =?utf-8?B?QllWNmdacmMwMjBEU1VMbFAvVVdpMmc4Tm5WWlNJczlraWVhVFdkOTFIYW5T?=
 =?utf-8?B?RDlid0wrRXI0U1lTUmVReVN5eDlod1hRdmZYZVFUQkhmYmJRUVRtK3U0ZDBU?=
 =?utf-8?B?SndsNVJQMUJoUGwxYnUvSzZlSVY5Tlo0Ly84bmJOeGlRUWpESlF0bVV1R2w0?=
 =?utf-8?B?QkRyaHgzenJieVNFRG5NUHEyaUpjcU41N1JtcE5IZjg5QUlXeGc1YUtTN1V0?=
 =?utf-8?B?bmErS1Z6djA5SlVhY3U4eHVQL3FHWUx1L2FaN0FpMW5MNm5VSnhURnZDYTdj?=
 =?utf-8?B?MVZBRTRROHB6WGlCV01QZGJoRkxOa1hVSEZ4ZEdhSGJoK1VLeitnQWtTSUVQ?=
 =?utf-8?B?QzdENmR5NmhhQldCRE9jNzRGM1VTcnkxWU1iQU81NlBGRDVSK21CeE9ac3RW?=
 =?utf-8?B?ZFlwUHRlRnlPNURCM3V6cXMyb0lERUxzZGFGaENpUWtkbElNZ1ZHeHBTYWhZ?=
 =?utf-8?B?ZEdkQjNpaXphdkI2YkxQZG9jSmNES2NCVzFDaElzcGpxK0tsUWFLcmF3RXFu?=
 =?utf-8?B?WVpOek9TOWxTWU40SlFiY04yK0RCVHN4Y2FLS0tuRlRjdUJGVjBPOS9yTm5I?=
 =?utf-8?B?SEt2YjduMUYxRnlRWStZQi9STSt3RWw2cFZNU0UxT1VyZFcrNzdJb1owdXNu?=
 =?utf-8?B?TkhvRFBiOVNidEhpQ0tMamVzMmZtdDBEY1g2Y0pQRG4vRVBCRjFiNFNPOUZk?=
 =?utf-8?B?K3BmK2FEa0VWYXJ1bVpzSWdqaGgza1YwS2gzMmhxTDF0Yk42THhPRUp6a1RF?=
 =?utf-8?B?Y2x5SDZxaUtZZWxsOEVxdERvMHVmQ29yWlE5SGprRnpzTkRFQUtIMG8zNjhX?=
 =?utf-8?B?TEJUTktVcE1TKzl1WVhOUTNrZjgzUVZSa3cwRlljalozdUI4QXp5U2RmK0hL?=
 =?utf-8?B?VXZKeGF5dkpXM3JmNXBsaFZLeDBUdHhPSlRReWFnUEtBT2t0RkdPR2ZrOFh0?=
 =?utf-8?B?RlUzenhhRkxGcmlhbWxkUkxRYUxqSUhJOGs1L0d0V1JVZVoyM2tvUGM4YWhz?=
 =?utf-8?B?VTZjOEljRTVUb0RhWkRVcytweXJIeDhsa3N2amRYaXdFQ3lvWkJaR3dYOWwx?=
 =?utf-8?B?NlpSMmlzclRSU0FTRkdLRkdzOVprZjM4YzJyY2M3ZXZzSFZIY1dKWmpEQmI3?=
 =?utf-8?B?QXR4emNRQ2NpYW9WSnppVlBFZ2ZIeENBUGV2by9VL3VIZ2FZU3pabFFxdzIw?=
 =?utf-8?B?OVo5RmhBRE9WTHZkSWtISDJkT1FWbjdTQlZsampYdTlEWE04SmhJWUlnYWc0?=
 =?utf-8?B?WlNZSTdFRkpZek0yMDF5UU5HdkU5SWFNUUU1eC8wbFQyMGJNenZYMUtRVU1h?=
 =?utf-8?B?OVZxUnNYRW1LbytMN2FpZkFkTmlLdWduV2x6bkJNbXExVkV6clVYTEpyaFoz?=
 =?utf-8?B?T0lhRmExcUVkcGhYelNqMERacmF2MW4yZm9lUXJlclArbkw2bityRG5LQTdT?=
 =?utf-8?B?clVkaHBQYjVKZFl0L01GaDhBQ3BVbWRRODEvWCtZR2xHZFdLYStlZz09?=
X-OriginatorOrg: citrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d073f94-dcf7-4364-a47f-08de698d246e
X-MS-Exchange-CrossTenant-AuthSource: CH8PR03MB8275.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2026 16:46:45.7342
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335836de-42ef-43a2-b145-348c2ee9ca5b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7lu/INzSbqnfPpxi4I3l2MaF/KCX4kXBr4cNzdYv9LkRM246SN+7/3rDZZ5xqNe9EvwyHwaActh01s+hzUpOCTBjwX+NsSW55lRr4cfHN0c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR03MB8381
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.34 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[citrix.com,reject];
	R_DKIM_ALLOW(-0.20)[citrix.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70881-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[citrix.com,gmail.com,alien8.de,linux.intel.com,zytor.com,vger.kernel.org,kernel.org,redhat.com];
	DKIM_TRACE(0.00)[citrix.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[andrew.cooper3@citrix.com,kvm@vger.kernel.org];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: BBE3F1264EB
X-Rspamd-Action: no action

On 11/02/2026 4:17 pm, Sean Christopherson wrote:
> On Wed, Feb 11, 2026, Andrew Cooper wrote:
>> On 11/02/2026 3:44 pm, Sean Christopherson wrote:
>>> On Wed, Feb 11, 2026, Andrew Cooper wrote:
>> This change is almost certainly marginal at best.  It's not as if
>> VMREAD/VMWRITE lead to good code gen even at the best of times.
> Yeah, but adding in them in the first place was even more marginal (I added the
> hints as much for documentation purposes as anything else).  Absent proof that
> having the hints is a net positive, I'm inclined to trust the compiler folks on
> what is/isn't optimal, and drop them.

Branch mispredicts in the P4 could easily eat up 150 cycles before the
frontend got it's act together.

However, optimising VMREAD/VMWRITE and not the whole kernel seems
somewhat futile.

~Andrew

