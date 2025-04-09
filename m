Return-Path: <kvm+bounces-42980-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6572FA81B47
	for <lists+kvm@lfdr.de>; Wed,  9 Apr 2025 04:47:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3BB734C308D
	for <lists+kvm@lfdr.de>; Wed,  9 Apr 2025 02:47:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88FA218DF62;
	Wed,  9 Apr 2025 02:47:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="f9Ttj3Dc"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2058.outbound.protection.outlook.com [40.107.212.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80CD726ACB
	for <kvm@vger.kernel.org>; Wed,  9 Apr 2025 02:47:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744166842; cv=fail; b=ufgXsAlrH2pkqtEzPoakQHMPd4AelseO9jWDWW/8OURNnJAeOOwZDOR8m3f/htSvQy/QYotDFE9Sas0D1sJ2bAcCeYOUVxhMVGWnxmPJqFI2vDcP76uBcKwcxxG+of/Q7caWSO7LOHYCSa5ZCwWYs5TVQ4jvEDrtfEFOb348xOc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744166842; c=relaxed/simple;
	bh=MiycXxZvjsGlWrRKmGWidN1ww13+oWj2dCnnq43yVdM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Er1Lu6XIkt2asyfxAFgN0D/KDfKnrikmBSnmQZtNnr7fKA/8FJDYqSygFvsGiqVLPVqWFWMR/yyHgE54TWvZqVrhE5WMtmaFdMUhFLAoh4wZU0bTszU9O5MUP9xwsPqB9DW4TilvHI9gHMIH8HdwKlo0FT5BlUWRViLiJhcjjLU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=f9Ttj3Dc; arc=fail smtp.client-ip=40.107.212.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Z9LTj7sMhM1+Tm0PmtyV6rgklTtL7gkJ8DFVExsstVoSmpGUQsgy1k18BmIXF+ovi+J7TJNYVy3wBU6mTtKb4fmYpboZg2j2myfoaQTo8tONrYhxssGMMhTYeqGbaF1jwARikmwjLVWfQemIeCDhWwuGoos6z8E+Ag4cq70xZsCk/UfvsOmRaXGc1vP0w7zF2vzJNM4f8ewJiPUkiahseVJarZjwr2oMarVgp8ncxoZFWWn+HH1UkVwAN+qo/XZCTLl1oLt4MMRdlIw3eymaOt5pX/tVkBw5M1eF60vidG6dJ7kwhEJfDOBQNv6kW8XgBqoypsBjZVmYzsTDgRRhaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rQg9fNNUHQCsVyLVCyujJeQHObnUM4Dxvztuw1pyeHQ=;
 b=nx2zxf5YDBeZQcnLa30U7Zjy7RsEv+TQedQXcaNupdzb7cFWweSqGnvgCW3PicegrHXjD+vuTGU8n+AnG37y9+gCPJ13ObT1JX/Rnp32m2NfYVQS6oABQJU3sMM+u9SoxY3WErU/mf63aOVmF8ieyzseYZUUlE+0FSRps0sd6yMt/esxpBi/PXGkKhMK4rwR4Bfijh+dILbMNm6sYZ7vzpxxrnBfnIwGNSmBdjmrpUWHRlkSQMvC9kRzePZnAigRFlYmY0ya9rfi2PtajXjERTai0PVvIB9NgVdk6kuIXgPvrGRCIzKSEj/Txx0QWbnzZnWfno7wK099cOEmrS+SDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rQg9fNNUHQCsVyLVCyujJeQHObnUM4Dxvztuw1pyeHQ=;
 b=f9Ttj3Dcdh1oDBT0fwKUdKlzrjIBE8KyDIh13d7qo1fWeIycR/84mMu9EcpuCbxHU7Gx9cb76VfGIZPMQrwvPL6yQOqOwJh727j0HxESNHbgnWcpt7K3C7h4kxi3e3kd51u0DpQ1Tuyrz58bykY7n0CuqXee48yzmStFMmJS4Hg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB9194.namprd12.prod.outlook.com (2603:10b6:610:19f::7)
 by CY8PR12MB7707.namprd12.prod.outlook.com (2603:10b6:930:86::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.21; Wed, 9 Apr
 2025 02:47:17 +0000
Received: from CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f]) by CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f%4]) with mapi id 15.20.8606.029; Wed, 9 Apr 2025
 02:47:16 +0000
Message-ID: <90152e8d-0af2-4735-b39a-8100cfb16d16@amd.com>
Date: Wed, 9 Apr 2025 12:47:08 +1000
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH v4 01/13] memory: Export a helper to get intersection of a
 MemoryRegionSection with a given range
To: Chenyi Qiang <chenyi.qiang@intel.com>,
 David Hildenbrand <david@redhat.com>, Peter Xu <peterx@redhat.com>,
 Gupta Pankaj <pankaj.gupta@amd.com>, Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Michael Roth <michael.roth@amd.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org,
 Williams Dan J <dan.j.williams@intel.com>,
 Peng Chao P <chao.p.peng@intel.com>, Gao Chao <chao.gao@intel.com>,
 Xu Yilun <yilun.xu@intel.com>, Li Xiaoyao <xiaoyao.li@intel.com>
References: <20250407074939.18657-1-chenyi.qiang@intel.com>
 <20250407074939.18657-2-chenyi.qiang@intel.com>
Content-Language: en-US
From: Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <20250407074939.18657-2-chenyi.qiang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ME0P300CA0078.AUSP300.PROD.OUTLOOK.COM
 (2603:10c6:220:234::29) To CH3PR12MB9194.namprd12.prod.outlook.com
 (2603:10b6:610:19f::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9194:EE_|CY8PR12MB7707:EE_
X-MS-Office365-Filtering-Correlation-Id: 4bba1deb-5a24-400e-8beb-08dd7710d692
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|366016|1800799024|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Skd6Q0w3MTN0Y1NRdVVkZVZmcXd6SmlIMHZqQ1FDWTZzUmZjQTBVdUgrcGdu?=
 =?utf-8?B?Q2Rwa2dEazlvdGtzTFkyZzBqVGxjSjBKVW5icUk1eUpjZTJrT0I2U0FkRm02?=
 =?utf-8?B?QU9TZ2NPcjRLdjhTZVRNZUJDdXN1OU5pdzNWS1E4dUYySjZwQWFMODJPSVhh?=
 =?utf-8?B?SGRYZW9qWFk3UFNJWU5ORzh3ZFR6cjk5UUtqQWo0UVRRNTVYTmh5VmVpeVRQ?=
 =?utf-8?B?OVVPZHZ6cHRVSFdpeEdxaVpXa3c3K292WWxRQUo0aGkvZUxmczJoaFM2Zldm?=
 =?utf-8?B?WW8zYlZBSGU5bS9zUU1aNkxObWRXL3ltek42dzRzUXR0SWhha0hhK0wwMDlO?=
 =?utf-8?B?TEF5eXV6L1dTNmJHMXgrd2Z0cEE0R2NnbUNRb2RQbWdOUlpuWjVhMjMreFV1?=
 =?utf-8?B?emdOeDQ5UzVSbGJYT3BRdGcxOXVaTGZNK1drRWZFM2NXTkZkMW9iMVNuVTFP?=
 =?utf-8?B?Q3FVdGhKWDJpOG1pR1FqVHFhQjhZWDgveUFmSGRBOWs0WURQU2I2VEw4RS9H?=
 =?utf-8?B?VW9ySERIV3NJVVFMLzdoaThZVGRRN1d4YWxydmxoamg4TENIQkhYZmVGQ2FL?=
 =?utf-8?B?d3ExcWI2emNQbURTNWdBaTg4aEtNakh5KzFMTjc4L3p3bXFzUGxjamFDMnA5?=
 =?utf-8?B?T095Wi9wY3ZIUnZrSm1keXlocjBHcmJHeWV1ZWl0MzNDVTB3enJYa28wcnBo?=
 =?utf-8?B?TWkwYW9RcXR4VkI3V2Jsbm1MVlZnWjkvSm04NzFqTlpKQkpEdk1Qd3VnaDdR?=
 =?utf-8?B?RDMvcXdqTFYvaVhRdjBGL2p4SUU5NGl2Q21mc1cxS2ZtdEN3OFhXY0RmK2Jh?=
 =?utf-8?B?NEx1NFJTekV3dHFRaHBpMDRSeXk5aTBLWk9SUUV6d004dU1oYlN3VU1za3hw?=
 =?utf-8?B?SXl4WlBHZm1Vc0Q5dXNEbFJ1ZStGUy9uN0ZpallTYTdDVHo0d0syRVRKS0Yv?=
 =?utf-8?B?ZWFOcHlFb1dQcE10SUlDeVZMdWx3c01lU1Y1Ym81ZjRLQW84QmF6N2xoMklw?=
 =?utf-8?B?WmdOUGxxK0kvNUh5aCtuREhXUVdrTVF4WlZ2TGFGUjJpM3FQVEthdjk4OEEr?=
 =?utf-8?B?OVlzdEV1cHhlaXlPNHQ2S1hBWFNHaDdVZGN0dUlxZjBXbXIyM0RuaGRZMmRI?=
 =?utf-8?B?ZkpLc0RoWmkwcEJQYkR4VmdQY1JPU3B4MG9JSGVjTTQxUW1ZTUd0MmMxUTNX?=
 =?utf-8?B?Q2dFODNqQW9PenVidk5NVUxGbENHNElxMDlwWFNZTTkrdEN6djJZS2Mzd29q?=
 =?utf-8?B?aXZmTlo2UFBVbnBBbE9VamI0V3R4WVd3QnBhSnBjWCtjdTRsMitQZDlYUU9m?=
 =?utf-8?B?ZHBsVTR2MmtnaFdPOW11OUFJV2NER2x4SFB0OVp3OWN6dTgyODl4VnFJTVhp?=
 =?utf-8?B?VzAvT3ZHOVdobG1kRzJKenRXUTlMTUI2eDAzUlloM1hzOGdqenU2MFRlMVRN?=
 =?utf-8?B?WnJzY3pCRVRCYmpNVGFzcVB5N0hBT0hjbHdKeC9ZTUdGdUVnbGhCaEZoVHNT?=
 =?utf-8?B?MjZnZ090RXRQa1hWd2c5UUIyRURwb2xrWW5CNURVRUsrNFBmOE1oRUtsNkhw?=
 =?utf-8?B?R2lGZXdPM1FOd2dZRk1veDVydFJIenY5RW55bUhaVjQ4N1prNlJMWU9wSjJB?=
 =?utf-8?B?RTU4S0pwWFg4ZWhrMGZiSnEvZWVpMVk4OTZzcnQ1bXFrWmpraUJjK0lDMlVt?=
 =?utf-8?B?L05zUWh2eEFadDJtcmMzbmdsQ0Q1KytidXg3WmhlS283bUpjWDdwcHhHd1dJ?=
 =?utf-8?B?NzhGTU1nUGh0QVkzUit6QnA0V2QvNklGZENuZmNQQkRnMTYxVVEwV1JVQm9I?=
 =?utf-8?B?aXNxOEV6dm5IN1NPczJkSzVjbEY3eCtYakF6dVFkQVNiMkRsZE5uQkxKR0tS?=
 =?utf-8?B?ZTNabTh4OE5NVXdRYlNWUWc0N3pVYklTUHFXTlY5MUdVdGRjSHl2Lzl1NHRm?=
 =?utf-8?Q?fC/psOyBryo=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9194.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(1800799024)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bTNMM3hiT2Y5ZnczaFV0SGNlTXZZSHFXVUVvSWMwSXd5eW1iUVBTR2w3UG43?=
 =?utf-8?B?L1BBNTFKb1NGSW5WTW94QURZSkxjYzJ2SDdVZ0lWd04vRmRBZk1UQWlpSmg4?=
 =?utf-8?B?NlNQZWhWbjFhdVk0dlJmS2RPOWR1clJQQnhHN05WUkhFQ3Bmb29rMk5tQUI0?=
 =?utf-8?B?VCs1REVRWGFicENrTE4yUkFkbjF5aDRRdEtCMXFpMGZJSDllREtXTzR3c2FI?=
 =?utf-8?B?RGIvS09rMytERm5JZ0lXWUQrSitwdnhYLzBEa09rMVcvSmNiOTZYTWNEVVU4?=
 =?utf-8?B?cnI3Z1l5WUcrQkQ1YVMwUDU5NXdSbzZrUWROenlmYTdzcXFLNUpxTEFnT1dO?=
 =?utf-8?B?bG93c2Y0Z25VUDFYdUFZQzV4QnBsSk0wazZITXpHQnVqOXRGLzl3QjBGN3p6?=
 =?utf-8?B?MXEvR1R0ZSs0LzkrVFRuUVBiRlBvcTNGb3Qwek5TTjVaNVhHVUNwYTNqQ1VB?=
 =?utf-8?B?Zm1Ub2IwQUhqU2Ntb0xFVUFwV0NmaUkvSWZ0ZUowb3RmUWN4R0RJR2hyVk9F?=
 =?utf-8?B?aklUM3l5T3FBTWVWb1pzWllHOVdLUmRrMG05SzZsMlBVSGFhNlBHTHJyTGlS?=
 =?utf-8?B?N3BMUEZkVGx6MWV2cWI5L1BuT1dPQS85VHlHV0hiMHhKdUp1WUI0bGZySzNP?=
 =?utf-8?B?Z0dMS3lOUVNmUndPZTVPZ2h3RWJEL1QrNnpRZ2pXOVVxWWNTb1hUMkNQM0No?=
 =?utf-8?B?bXBUbkh6eExIWk5QYlRtMDNZT2w4VnMvRHNWNmF1Ukp6US9tVWo3cG1oN0ZR?=
 =?utf-8?B?STVhZWErUTg4aW5ueTdicjVqK0VtS2p6M1ZMRmZ0NnlCeDNrZTVVSGhEdUFn?=
 =?utf-8?B?UVQ3bVI1N01DS092YkVzTXdlWm81TFNscGU4TGNJamFJS3FBNEVSUXVXaDhl?=
 =?utf-8?B?WjVGUldWbHhWdFVYSFZKbTcxRDlCUmVnWjJyaEN0dVpicDlZMTFvT0RxUzBv?=
 =?utf-8?B?MUw1ZUlIOXhNVEpBb1Q3OHFieXJRbW4wVGVCT0ROaS9HTWxLVm5TQnR4WEh0?=
 =?utf-8?B?T0lzejYyYXlPYmx6NDZ5ZFJsNGJNUUt4d3JQVUdNL0F1MXpUV08wenFSSDhE?=
 =?utf-8?B?TzlCdzhQKzB3YVdLUW5IbXp5aHF4bmJITjV1VjFNbEpCNWFMemNNVVFPSjZL?=
 =?utf-8?B?Y1NXdDU3R3VJN3BSVkNKRHJRZWhHRXFSSTlrL3JFSFk2QzdSVFZxbjFqMHdl?=
 =?utf-8?B?dXM4T0IvS2xmU3VWd3ZhczZ1bUlPNEhnS1dWZWswaEdVbk80MTh4MFpMNjFj?=
 =?utf-8?B?Y3dRbU0zTEQ1bVRqWEhrcUQzUXdhbXdtN250RjgyZ2VXM2RaN3ovOWdIcXo5?=
 =?utf-8?B?b1VYdFR6SkpqYWY4cFRYTlg2ejZEUTZEd2xKK2NuZU1jdFRSTE96Sjl1ejVk?=
 =?utf-8?B?Z0N3YVhIQjFPZFVMSFdKbkptRVZzbXpXMkJBTk5LSU53WThVM1JaQkdxcVRu?=
 =?utf-8?B?V0t4TjNiMCtaSTA1NXdiTmxZemMvejV5TGF1Y2RCQldrQ3FFNk54d0tMdFUr?=
 =?utf-8?B?MXp3MStFTFlEWnF0SjFLcjdCKytDOUNtek9QYzAwcXl2VHQrZWVzWjlXMmNX?=
 =?utf-8?B?cnFXZ1lvV0hWaU03ZDBGSTBjNEpiSHNQd292YktOcTNmblBMK05CcTVDcURx?=
 =?utf-8?B?azIrTWJVTFc3dU5GYi8xZ2ZsTFhKZXozbjVJN0lSVkhkZHhDWER4akZEM2Zh?=
 =?utf-8?B?NkxBVTVVSEswZUVQYkg0Q1M2TitQem4waVZSVWlad3JrY2l4YXVJQ1dQTk4r?=
 =?utf-8?B?UVVxckVaUXJHSytseFB0WWxNaXA3NHpnNmlFTEhXQnByM0JGWEZPUGZyTlNw?=
 =?utf-8?B?c0dZUC85V1VWRnZLR0t4eTZVQnkvZnlpanB2czB0Ni9WWldGWE9Kcm16TnZS?=
 =?utf-8?B?S0lZWXBmaTYzZkNFc043RTE3SXBNN0gxNUdCUnFsdEF6THpIb2pOaWpCa2ti?=
 =?utf-8?B?MGRucDJvN2RDVmVzTGQ3NStZMHJva2NPQU5WN2k3OVQyVWM3Z0p4dSttaHhO?=
 =?utf-8?B?ZkJsWktvRlZFUFJTQWtyckNjWWRoS2FPbDE4bWdNQkRzcy80Sng0c0w5eHFS?=
 =?utf-8?B?STg2bE1xNmRRcFJFSm5KT0l2d1d6dGxJcGwwUEVISU43bytYSjlpUm8zbXpi?=
 =?utf-8?Q?9w/Zqh5VePJaoBAZ6TJ7cWSUa?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4bba1deb-5a24-400e-8beb-08dd7710d692
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9194.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2025 02:47:16.4475
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zcRsOvLByJJvLpgpp1r8izyIIdGVAdbrKGZHVB/JyPL2yQ8P47CCJmu1+0yvjZ7xf+hyeeU8t5lmMGrYI7QPaA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7707


On 7/4/25 17:49, Chenyi Qiang wrote:
> Rename the helper to memory_region_section_intersect_range() to make it
> more generic. Meanwhile, define the @end as Int128 and replace the
> related operations with Int128_* format since the helper is exported as
> a wider API.
> 
> Suggested-by: Alexey Kardashevskiy <aik@amd.com>
> Reviewed-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>

./scripts/checkpatch.pl complains "WARNING: line over 80 characters"

with that fixed,

Reviewed-by: Alexey Kardashevskiy <aik@amd.com>

> ---
> Changes in v4:
>      - No change.
> 
> Changes in v3:
>      - No change
> 
> Changes in v2:
>      - Make memory_region_section_intersect_range() an inline function.
>      - Add Reviewed-by from David
>      - Define the @end as Int128 and use the related Int128_* ops as a wilder
>        API (Alexey)
> ---
>   hw/virtio/virtio-mem.c | 32 +++++---------------------------
>   include/exec/memory.h  | 27 +++++++++++++++++++++++++++
>   2 files changed, 32 insertions(+), 27 deletions(-)
> 
> diff --git a/hw/virtio/virtio-mem.c b/hw/virtio/virtio-mem.c
> index b1a003736b..21f16e4912 100644
> --- a/hw/virtio/virtio-mem.c
> +++ b/hw/virtio/virtio-mem.c
> @@ -244,28 +244,6 @@ static int virtio_mem_for_each_plugged_range(VirtIOMEM *vmem, void *arg,
>       return ret;
>   }
>   
> -/*
> - * Adjust the memory section to cover the intersection with the given range.
> - *
> - * Returns false if the intersection is empty, otherwise returns true.
> - */
> -static bool virtio_mem_intersect_memory_section(MemoryRegionSection *s,
> -                                                uint64_t offset, uint64_t size)
> -{
> -    uint64_t start = MAX(s->offset_within_region, offset);
> -    uint64_t end = MIN(s->offset_within_region + int128_get64(s->size),
> -                       offset + size);
> -
> -    if (end <= start) {
> -        return false;
> -    }
> -
> -    s->offset_within_address_space += start - s->offset_within_region;
> -    s->offset_within_region = start;
> -    s->size = int128_make64(end - start);
> -    return true;
> -}
> -
>   typedef int (*virtio_mem_section_cb)(MemoryRegionSection *s, void *arg);
>   
>   static int virtio_mem_for_each_plugged_section(const VirtIOMEM *vmem,
> @@ -287,7 +265,7 @@ static int virtio_mem_for_each_plugged_section(const VirtIOMEM *vmem,
>                                         first_bit + 1) - 1;
>           size = (last_bit - first_bit + 1) * vmem->block_size;
>   
> -        if (!virtio_mem_intersect_memory_section(&tmp, offset, size)) {
> +        if (!memory_region_section_intersect_range(&tmp, offset, size)) {
>               break;
>           }
>           ret = cb(&tmp, arg);
> @@ -319,7 +297,7 @@ static int virtio_mem_for_each_unplugged_section(const VirtIOMEM *vmem,
>                                    first_bit + 1) - 1;
>           size = (last_bit - first_bit + 1) * vmem->block_size;
>   
> -        if (!virtio_mem_intersect_memory_section(&tmp, offset, size)) {
> +        if (!memory_region_section_intersect_range(&tmp, offset, size)) {
>               break;
>           }
>           ret = cb(&tmp, arg);
> @@ -355,7 +333,7 @@ static void virtio_mem_notify_unplug(VirtIOMEM *vmem, uint64_t offset,
>       QLIST_FOREACH(rdl, &vmem->rdl_list, next) {
>           MemoryRegionSection tmp = *rdl->section;
>   
> -        if (!virtio_mem_intersect_memory_section(&tmp, offset, size)) {
> +        if (!memory_region_section_intersect_range(&tmp, offset, size)) {
>               continue;
>           }
>           rdl->notify_discard(rdl, &tmp);
> @@ -371,7 +349,7 @@ static int virtio_mem_notify_plug(VirtIOMEM *vmem, uint64_t offset,
>       QLIST_FOREACH(rdl, &vmem->rdl_list, next) {
>           MemoryRegionSection tmp = *rdl->section;
>   
> -        if (!virtio_mem_intersect_memory_section(&tmp, offset, size)) {
> +        if (!memory_region_section_intersect_range(&tmp, offset, size)) {
>               continue;
>           }
>           ret = rdl->notify_populate(rdl, &tmp);
> @@ -388,7 +366,7 @@ static int virtio_mem_notify_plug(VirtIOMEM *vmem, uint64_t offset,
>               if (rdl2 == rdl) {
>                   break;
>               }
> -            if (!virtio_mem_intersect_memory_section(&tmp, offset, size)) {
> +            if (!memory_region_section_intersect_range(&tmp, offset, size)) {
>                   continue;
>               }
>               rdl2->notify_discard(rdl2, &tmp);
> diff --git a/include/exec/memory.h b/include/exec/memory.h
> index 3ee1901b52..3bebc43d59 100644
> --- a/include/exec/memory.h
> +++ b/include/exec/memory.h
> @@ -1202,6 +1202,33 @@ MemoryRegionSection *memory_region_section_new_copy(MemoryRegionSection *s);
>    */
>   void memory_region_section_free_copy(MemoryRegionSection *s);
>   
> +/**
> + * memory_region_section_intersect_range: Adjust the memory section to cover
> + * the intersection with the given range.
> + *
> + * @s: the #MemoryRegionSection to be adjusted
> + * @offset: the offset of the given range in the memory region
> + * @size: the size of the given range
> + *
> + * Returns false if the intersection is empty, otherwise returns true.
> + */
> +static inline bool memory_region_section_intersect_range(MemoryRegionSection *s,
> +                                                         uint64_t offset, uint64_t size)
> +{
> +    uint64_t start = MAX(s->offset_within_region, offset);
> +    Int128 end = int128_min(int128_add(int128_make64(s->offset_within_region), s->size),
> +                            int128_add(int128_make64(offset), int128_make64(size)));
> +
> +    if (int128_le(end, int128_make64(start))) {
> +        return false;
> +    }
> +
> +    s->offset_within_address_space += start - s->offset_within_region;
> +    s->offset_within_region = start;
> +    s->size = int128_sub(end, int128_make64(start));
> +    return true;
> +}
> +
>   /**
>    * memory_region_init: Initialize a memory region
>    *

-- 
Alexey


