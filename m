Return-Path: <kvm+bounces-42989-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E6008A81D62
	for <lists+kvm@lfdr.de>; Wed,  9 Apr 2025 08:46:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7C1511B60197
	for <lists+kvm@lfdr.de>; Wed,  9 Apr 2025 06:46:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBBC41DE8AD;
	Wed,  9 Apr 2025 06:45:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="NZdRRgIl"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2068.outbound.protection.outlook.com [40.107.93.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 179951D90AD
	for <kvm@vger.kernel.org>; Wed,  9 Apr 2025 06:45:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744181157; cv=fail; b=RFHrVDOSKxfIc85rv5hViL+YyNE0y7FJfwq6Uc6z7Cyo1h3nKcjUeaptVjmrk1FFFCKyLKbcfQXJDrs3CDG88PJL1agjj2Sb1kU+zV2Zc5q4NgvlOKgBIzkhT7BLSZFpgmNy3U/hGo4dhe7E5kvdt9mcNvTOTW9wE6u8BXuQRWY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744181157; c=relaxed/simple;
	bh=UeumfvtiLK5ksNjcNJ6hooE2gK2o2R4sAoMH+1OjUUM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=h4VtWXmxeaQiKgCSOvf6IMchvL4Z7RaEl3fBvFOTbkP36R6ZeQmHRSeRm+bU8Vag6fMepkDM7TFpLLoRsvw5c5gH6AgPoWmilTw/LqF3+d4VgRRwqw0ATCTJbrazmKq5OSUoB/lzwTsRr4i8MC4whiTp1H9wgB92feRhJO0L+8w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=NZdRRgIl; arc=fail smtp.client-ip=40.107.93.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=O4x0dCrcaeVDlstvuGdSCPMvv5EG6bnSSGyRpFzjdhcAjKWcyvRBFEMf/P/ebl7Opg49d5RLCLJoLt6GZsOMb7x9YndpKxCMx3p/3IOa6bJjDTsSaeByF1b5Qi0+3M/uducxw2HEeWIfsgxKrfozyD8pAvc2ZHPfrKs8Yn2/xXJqbgbYuMwfy/Dt8quCWhkDKqhs4qHx59fKZ000gVNisxp6/DopVQWrze57wl9NdxsvgmhQiGsrckcFmIqAWUW5+jN7zpesMHeI8StTe2Ahel5jaJC2IgIsP6vB3qSXpQD6ioyxq9rLZDz4fM0ozS5jfBEgbzl7VKXFPC2I/kCaEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ASefF7dTPFu+t0S5vnugVxf3hBlR950CRndfrvvI0gk=;
 b=Ui7FtEg9xHoRFmqX4Dsg4spV/FvwuEOa/pc705JezRDKpMJhI7B3p4x1q4PS8nYOB8SGeGCWFT/DNLOZ3nglFqwSro+ZI7dSSGpRHTeK+NGEisIeYGAIMxGjsWNT+pJPupgYBdOsiQjz7ih3iBB+q94aMx72LlfMs3R1aBhdd7haV5FfXLFo2uh+cPIBN+ztt/Ug9n0jC7U3fzABkm3Cm5DpQ+c+LUJqpliIFolmoh98af85FUJlaGlpGs1wj1gBXjKHUioAF8F0wmHQSyarJ1aiVh/O1k3pB1mCv9wtTvLpKUrfptIDfrMfWMpr4z7dvjujfskmqivU8Fb4026LRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ASefF7dTPFu+t0S5vnugVxf3hBlR950CRndfrvvI0gk=;
 b=NZdRRgIl4HhhTSALUNEkbARRJEFuyFTOzaQ5dELWSEtCRxAYMdLl0rQ29OLOzmIR0zQBnx2hyQ1Td9NTwOqQlKW9L1rs0tZTbEg1hfcxXFLhs3MTU/7/nky6G7SgFa+qMg8R5k+JyIDTbX/VJYl8mzvSPiNxZrzHILzvnZK8FH4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB9194.namprd12.prod.outlook.com (2603:10b6:610:19f::7)
 by SN7PR12MB8436.namprd12.prod.outlook.com (2603:10b6:806:2e3::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8606.29; Wed, 9 Apr
 2025 06:45:51 +0000
Received: from CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f]) by CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f%4]) with mapi id 15.20.8606.029; Wed, 9 Apr 2025
 06:45:51 +0000
Message-ID: <0045ea05-3af5-4f07-84d5-546b0bc8bb91@amd.com>
Date: Wed, 9 Apr 2025 16:45:43 +1000
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH v4 01/13] memory: Export a helper to get intersection of a
 MemoryRegionSection with a given range
Content-Language: en-US
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
 <90152e8d-0af2-4735-b39a-8100cfb16d16@amd.com>
 <47b04426-73c7-41d9-b7b7-ee2fa40886ae@intel.com>
From: Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <47b04426-73c7-41d9-b7b7-ee2fa40886ae@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MEWP282CA0153.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:220:1d7::11) To CH3PR12MB9194.namprd12.prod.outlook.com
 (2603:10b6:610:19f::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9194:EE_|SN7PR12MB8436:EE_
X-MS-Office365-Filtering-Correlation-Id: 28272b8d-eeea-465b-8ff2-08dd77322b34
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SUpkTC9sUDNYaG5sdkxQMmNEWEFqSDY5Y1BZeU41eGFVWFpPQklSQndpelA3?=
 =?utf-8?B?NnBlUjBMNTcvVVF1ZjFFNWpmTGQzcHlOMERlSkJReXVXWnRZdlhNYW1TYU1M?=
 =?utf-8?B?R3NsUGIwNTR2Nmp5WjhxVEdNbUc2TEpjd21VRnU3SncwQTBMc3ByQ3pJSExz?=
 =?utf-8?B?YzdTRkp5cEpxdDJwWG5TNk9UUTVGNktpVmJna2VHdGhHRmxTaTFmY0l6dWRo?=
 =?utf-8?B?bFVxM0JlYkVjZnB6b3JLamc2YmlJQ0R1b3Jqck9LUGMvQXROU0dSckpHWUdK?=
 =?utf-8?B?OTYzL0hvdEh6L1lSRHpkajY2TFJKZGpZYXJOdHltZE11TzhEeit2cC9xd1RT?=
 =?utf-8?B?TE0rWEpsZ2VNaGhYTkMvYnJaNlhHSDNQbjhlT2hxMDBXaFZUWStlSjYvOEtu?=
 =?utf-8?B?VStaNlV0TzNEY0N4VHNVbGxGQVVvWjJ0ZkEwSnlIS0lNamppYW9PS292V2pk?=
 =?utf-8?B?dE9qalM3Qzd5bWZzNTA4VkZaRGVHdGhCSnE5UFQxNndicTVzQnRIcFU4NVJI?=
 =?utf-8?B?eFJXUlc2YStiVG5KQXcwejB2WlpmblNmcE1oc1doM3hvTFNOZi9mMEZnYlhl?=
 =?utf-8?B?UmlGMDliUi9jV1d6bTY3RG9KM0dDalVrSFFxRmRIRlZPQzRkVkR0bloyQU1W?=
 =?utf-8?B?ZEt6U3B5bnhwSzZ4RW5wTkQ4VU5VQzNPT2ptaW5vRWFxdkpDenNFLzdJN0N3?=
 =?utf-8?B?Wlg3azJNeXVMRXdtZTQrdXFHYTdEWmxwR2ZNY0lKNlBTNTBYWC9xZmJ6S0FZ?=
 =?utf-8?B?Z2pCM2hOUUlaL1ZJZGJJdURBaENSSXoveFFmb3dhMmpBdkhJeGdWYklSVmpJ?=
 =?utf-8?B?Wi9ZWWQ5ZkJqUFhrenlJOEt0NWNyUTZXcURtbjRzUkoxcWhtYWhUYVVtUDc3?=
 =?utf-8?B?dVBOMHBQYlEwYThRZHdnQURUTXAwRWZqZkluKzc2WnVoYVhiQSthTkxNTlNz?=
 =?utf-8?B?cDl4cU5LbzF4Ni8zUW5rVk5tcXVpUURBcTduMllEOVVsVnNzRjhXQzdHbVV4?=
 =?utf-8?B?bzhyNDBiL2hCUHhZWmdpUjBpb0hlSHNjakRoc2JlQ2U1K0JuekMyd1FyOUN3?=
 =?utf-8?B?UmQwcWVDVHFKQ0M2cDRmSUdZb1hTMjVyZXZqUGlRUm1YbitCdE8rSVZHS0FY?=
 =?utf-8?B?OW44VHFzNGdZK00wZDVRdzFCNXlicEovcUY0QVVVNm9IcElWUzZtUkM5WTJK?=
 =?utf-8?B?ZjI4R09JYUJYbWpqc2VoazY4NEgwQ25lS0o5bUNBSWpFL0xMcEZFUS9zQjNw?=
 =?utf-8?B?d0l6N0xja0NqNzdQaUh3SEMyM1NzREtSSTUzM3lZZ2tZUGx3MWpBODYxSXI4?=
 =?utf-8?B?d2RkNTRNeGNtOWpjZnpicEpuelArTTR2WXI1RGY1QWkwd3cvVUpuVzBhaEcx?=
 =?utf-8?B?ckN6Skk5OTJxZGQweG9WVkRGY2xpUERvYVRJQ2pNK1hoYURGTHBmN0g5MG13?=
 =?utf-8?B?dStkU3RySVRSYWRTVjF1YnQrWUdxWW1WenhUS1orbFVUak8rRFlySVRlbkcz?=
 =?utf-8?B?U1pZMTRGaEc5bUlFQzhoTndzVmJyUEd1US9IUUtwdGRwWnM4K3FLREljSDhm?=
 =?utf-8?B?bUhLYjhWT2lZOVd0anhVVGhBWkpaQmxpQktEMHdQVnJKU1ZUaW9xSjVMLzZD?=
 =?utf-8?B?c0dmejg0UjhqRnF5djFhQWo2NTQ1YjNUdnZZUWZ1aTFjdVNOZE0xQzd5bkdy?=
 =?utf-8?B?VGdkWkJzbFovUVVja2pZQnhOT1U3eGVKVFo0UmFQRXpJVGI2TkMwaXBYVW9D?=
 =?utf-8?B?U2J0TXlJNndKRE5NbzRNM2hWQ1VZUm5kaWxmeGFjYllxYU5Rcms5NFZIb0p4?=
 =?utf-8?B?QkV0RkFGM3NxbGI1dlBJWk9ZWTIrRHpaSGhNNUJPMGtUSHJNM01Yd1A3SUdT?=
 =?utf-8?Q?sEGVMT2/swHOj?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9194.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WE84ekhuYWQyWGl6ZGlLUElid3JQMnUwRWNFTGMyeGFmMDhmU2VYNGVQWS81?=
 =?utf-8?B?akNhbXhLMTAwRS82ekdwNXpRTGo1QmxURUdTSWxkdlhXditBVUdNVi9iYTBh?=
 =?utf-8?B?ZHdoa1R4SmkybWI1UDRseHRKRVZkTTd1TWlyckNtYXZ6K1lMMk5lc0Zreldr?=
 =?utf-8?B?VlZYKy9uZlFuK1ZqVTVoTjRYNDhmaEJjeHVDZXRhaWRWdERlTW9CNXZWUExp?=
 =?utf-8?B?NVNnTU9MUmxzQ0FKRWoybTFNazVqQitpTXBJVFdyaHkySGxOcm9qRld0Qy9J?=
 =?utf-8?B?R3FLblhzU3J0dDR6QVd3cGlEME8rMVBLT1ZyVnRnN0pnVmR6dUtVbWExdlBU?=
 =?utf-8?B?em5MNHpKYkxtQXlrcitHbjhrRXhMK09OczdTaHNmeWZlUVpmMzNEdmg5RWdT?=
 =?utf-8?B?UTRUUXF1WWZveGtlT0RDWGhNeGFsRnBVc282SjJVYlRDZU5UK3JGZTczOXlH?=
 =?utf-8?B?aUJ6ZXljT1dvcDdRRUZrOUt6Nmt4WXJ3NERKQVBEbVV6N2YzUWxjYXdaUWJR?=
 =?utf-8?B?RzlCZ0tLU1EzeWM1bmFpUjhjZVZOV0lWSm5Oc0k1dzZFRVIrVGR0SXh3Zkgy?=
 =?utf-8?B?cmgzcEZlVXg1ZTFibmoyc01qWC9EVXVySlVqL0RjYUhSbjV3MGFxeERScnNP?=
 =?utf-8?B?VU9oWmdXK09OL0VCL1lEWTNZK3N2NnJidjBxL0NKMy9wRU1MUjhZTUpLQ0Uy?=
 =?utf-8?B?ckNuM2Q5M3dPL3FBNVZFQncvdGtkd1FMRXlOajhGQmZaaExlKzE0b0ZVd3Nt?=
 =?utf-8?B?aDJLcmxTcVU5bU1SbTUwRUdOa3ZTcndETjROWHJ0ejZYUVNPc295aGVIS1A4?=
 =?utf-8?B?UXR6RjY2R0VZZjBXNEYyeUJyS05oUWp5UmtNUUk4ckIvQU81TGhSRUtBS05X?=
 =?utf-8?B?alc3N1VyZWx5YlhoNGhHbWVPakQvMHQ4cFlEZjBtQlc2N0pvVWlnNlFWY2c3?=
 =?utf-8?B?d0lYUmhZekFQWlBIQWkrQWpycVpiSjlwdWxsclB1WW9BY0k4TGdxd21tMVlD?=
 =?utf-8?B?cDFOeEhIa2hqVmNEeHQvbDIwOU1hMmVEWVpMMjYxQ0hubFpPWjRvUUFGUFpp?=
 =?utf-8?B?czkzbkpXdC9Vd2VFMGpZNHEzR3Q2S3BHNFF0cjZZTmFsK3ZFa0kwV05kZnEy?=
 =?utf-8?B?SkYxNG8yV2V6U3BLZUhBUzk4Nlp5WGQvbURHbVVnb2pneGxKTWZucFJ1aGZ4?=
 =?utf-8?B?QkZoZlBEc3RlL21ISzFObDlqYktOdGlPYy9Bc3VsWXROSUpCSmx2ejRjZDZn?=
 =?utf-8?B?cWYwbjBsQ09hdmFvb1gzalhTai8yaDJ4ajJCZzh4QUNDeU41U1hCOVVwN3JI?=
 =?utf-8?B?dTEyTWdQaTBDbm1RSzEwRUNJZTBrd2tvenlvaXBWVlVzY2pabm1lSlQ0RmRq?=
 =?utf-8?B?ZjU0enFCT05UZDcyK2VIaWxwL2JoR0NWUU93RCtpV2tRRktHcEtyR0FIWmhD?=
 =?utf-8?B?V2NodlgvdStxYjd0STVaTDZrT3Y3NWRkczFuTzY3RkZ6YmJxNlU3eHQrbnFQ?=
 =?utf-8?B?MnBHWWo1bDhtNWI2LzNPZTlVdENNYlF0QklKTVlYYUp5dVlmMGNPcWw2RkRX?=
 =?utf-8?B?emhuNHpsb2pSZTNZaHpzUzcwdWxGclNpeHNybndQcEpocTNqU09DZ0cwbFhJ?=
 =?utf-8?B?dWU5UG1rVEQ3QWVYVk0rMEdqS0U1L29lbmxCa2h1ejlWWG4rd3FpcHgycW5D?=
 =?utf-8?B?ZVVORXRITGZ1M293eTBCdlVMbXl0ajhCdGdXaUpzOGkrcmN3RHNiUVlINVFF?=
 =?utf-8?B?S29lV3kzQVZJY0UydEE3ZFIzbzFnd0NFbGJHdW1jck5RR3ZsZXlnWktUS01u?=
 =?utf-8?B?RklTQytWZmlaaHpOcUFZS1Bnc2p2VGN6SXNSWms4NFJPYUVHTjZ0elN1dHFv?=
 =?utf-8?B?NUN4Z1BnODljblB0L0xYU05kUkV4MlNNenh0VHByVXBZKzAyZ3RvUUR5NkNy?=
 =?utf-8?B?MWJEWjkrbWNxakNTUWdsd0k3bkJ1Z29jczRuMW1SdXc0L3VxZVB5RDhvbk0v?=
 =?utf-8?B?T045L21pL3ZrUVRPWHo3UnM5T3M2Nlh2U0tUUGpYNzRENHR5STFwZlZWNmFz?=
 =?utf-8?B?RDJlcGZBSkpTTjhMSmtUQ2YvVWl5SjE1aERaajNsQ01ldktMU1l4clEzRjI1?=
 =?utf-8?Q?RI6kji8TOwvjMkHJiicFPr32r?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 28272b8d-eeea-465b-8ff2-08dd77322b34
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9194.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2025 06:45:51.5210
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BjrRPbZRQy36aoOm/2WVqa+5zqmLeMs13JvkIxULCZabTdcZwhANqBQ6NH88+KggAq93858cSO6b9ZxESU/TJw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8436



On 9/4/25 16:26, Chenyi Qiang wrote:
> 
> 
> On 4/9/2025 10:47 AM, Alexey Kardashevskiy wrote:
>>
>> On 7/4/25 17:49, Chenyi Qiang wrote:
>>> Rename the helper to memory_region_section_intersect_range() to make it
>>> more generic. Meanwhile, define the @end as Int128 and replace the
>>> related operations with Int128_* format since the helper is exported as
>>> a wider API.
>>>
>>> Suggested-by: Alexey Kardashevskiy <aik@amd.com>
>>> Reviewed-by: David Hildenbrand <david@redhat.com>
>>> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
>>
>> ./scripts/checkpatch.pl complains "WARNING: line over 80 characters"
>>
>> with that fixed,
> 
> I observed many places in QEMU ignore the WARNING for over 80
> characters, so I also ignored them in my series.
> 
> After checking the rule in docs/devel/style.rst, I think I should try
> best to make it not longer than 80. But if it is hard to do so due to
> long function or symbol names, it is acceptable to not wrap it.
 >
> Then, I would modify the first warning code. For the latter two
> warnings, see code below
> 
>>
>> Reviewed-by: Alexey Kardashevskiy <aik@amd.com>
>>
>>> ---
>>> Changes in v4:
>>>       - No change.
>>>
>>> Changes in v3:
>>>       - No change
>>>
>>> Changes in v2:
>>>       - Make memory_region_section_intersect_range() an inline function.
>>>       - Add Reviewed-by from David
>>>       - Define the @end as Int128 and use the related Int128_* ops as a
>>> wilder
>>>         API (Alexey)
>>> ---
>>>    hw/virtio/virtio-mem.c | 32 +++++---------------------------
>>>    include/exec/memory.h  | 27 +++++++++++++++++++++++++++
>>>    2 files changed, 32 insertions(+), 27 deletions(-)
>>>
>>> diff --git a/hw/virtio/virtio-mem.c b/hw/virtio/virtio-mem.c
>>> index b1a003736b..21f16e4912 100644
>>> --- a/hw/virtio/virtio-mem.c
>>> +++ b/hw/virtio/virtio-mem.c
>>> @@ -244,28 +244,6 @@ static int
>>> virtio_mem_for_each_plugged_range(VirtIOMEM *vmem, void *arg,
>>>        return ret;
>>>    }
>>>    -/*
>>> - * Adjust the memory section to cover the intersection with the given
>>> range.
>>> - *
>>> - * Returns false if the intersection is empty, otherwise returns true.
>>> - */
>>> -static bool virtio_mem_intersect_memory_section(MemoryRegionSection *s,
>>> -                                                uint64_t offset,
>>> uint64_t size)
>>> -{
>>> -    uint64_t start = MAX(s->offset_within_region, offset);
>>> -    uint64_t end = MIN(s->offset_within_region + int128_get64(s->size),
>>> -                       offset + size);
>>> -
>>> -    if (end <= start) {
>>> -        return false;
>>> -    }
>>> -
>>> -    s->offset_within_address_space += start - s->offset_within_region;
>>> -    s->offset_within_region = start;
>>> -    s->size = int128_make64(end - start);
>>> -    return true;
>>> -}
>>> -
>>>    typedef int (*virtio_mem_section_cb)(MemoryRegionSection *s, void
>>> *arg);
>>>      static int virtio_mem_for_each_plugged_section(const VirtIOMEM *vmem,
>>> @@ -287,7 +265,7 @@ static int
>>> virtio_mem_for_each_plugged_section(const VirtIOMEM *vmem,
>>>                                          first_bit + 1) - 1;
>>>            size = (last_bit - first_bit + 1) * vmem->block_size;
>>>    -        if (!virtio_mem_intersect_memory_section(&tmp, offset,
>>> size)) {
>>> +        if (!memory_region_section_intersect_range(&tmp, offset,
>>> size)) {
>>>                break;
>>>            }
>>>            ret = cb(&tmp, arg);
>>> @@ -319,7 +297,7 @@ static int
>>> virtio_mem_for_each_unplugged_section(const VirtIOMEM *vmem,
>>>                                     first_bit + 1) - 1;
>>>            size = (last_bit - first_bit + 1) * vmem->block_size;
>>>    -        if (!virtio_mem_intersect_memory_section(&tmp, offset,
>>> size)) {
>>> +        if (!memory_region_section_intersect_range(&tmp, offset,
>>> size)) {
>>>                break;
>>>            }
>>>            ret = cb(&tmp, arg);
>>> @@ -355,7 +333,7 @@ static void virtio_mem_notify_unplug(VirtIOMEM
>>> *vmem, uint64_t offset,
>>>        QLIST_FOREACH(rdl, &vmem->rdl_list, next) {
>>>            MemoryRegionSection tmp = *rdl->section;
>>>    -        if (!virtio_mem_intersect_memory_section(&tmp, offset,
>>> size)) {
>>> +        if (!memory_region_section_intersect_range(&tmp, offset,
>>> size)) {
>>>                continue;
>>>            }
>>>            rdl->notify_discard(rdl, &tmp);
>>> @@ -371,7 +349,7 @@ static int virtio_mem_notify_plug(VirtIOMEM *vmem,
>>> uint64_t offset,
>>>        QLIST_FOREACH(rdl, &vmem->rdl_list, next) {
>>>            MemoryRegionSection tmp = *rdl->section;
>>>    -        if (!virtio_mem_intersect_memory_section(&tmp, offset,
>>> size)) {
>>> +        if (!memory_region_section_intersect_range(&tmp, offset,
>>> size)) {
>>>                continue;
>>>            }
>>>            ret = rdl->notify_populate(rdl, &tmp);
>>> @@ -388,7 +366,7 @@ static int virtio_mem_notify_plug(VirtIOMEM *vmem,
>>> uint64_t offset,
>>>                if (rdl2 == rdl) {
>>>                    break;
>>>                }
>>> -            if (!virtio_mem_intersect_memory_section(&tmp, offset,
>>> size)) {
>>> +            if (!memory_region_section_intersect_range(&tmp, offset,
>>> size)) {
>>>                    continue;
>>>                }
>>>                rdl2->notify_discard(rdl2, &tmp);
>>> diff --git a/include/exec/memory.h b/include/exec/memory.h
>>> index 3ee1901b52..3bebc43d59 100644
>>> --- a/include/exec/memory.h
>>> +++ b/include/exec/memory.h
>>> @@ -1202,6 +1202,33 @@ MemoryRegionSection
>>> *memory_region_section_new_copy(MemoryRegionSection *s);
>>>     */
>>>    void memory_region_section_free_copy(MemoryRegionSection *s);
>>>    +/**
>>> + * memory_region_section_intersect_range: Adjust the memory section
>>> to cover
>>> + * the intersection with the given range.
>>> + *
>>> + * @s: the #MemoryRegionSection to be adjusted
>>> + * @offset: the offset of the given range in the memory region
>>> + * @size: the size of the given range
>>> + *
>>> + * Returns false if the intersection is empty, otherwise returns true.
>>> + */
>>> +static inline bool
>>> memory_region_section_intersect_range(MemoryRegionSection *s,
>>> +                                                         uint64_t
>>> offset, uint64_t size)
>>> +{
>>> +    uint64_t start = MAX(s->offset_within_region, offset);
>>> +    Int128 end = int128_min(int128_add(int128_make64(s-
>>>> offset_within_region), s->size),
>>> +                            int128_add(int128_make64(offset),
>>> int128_make64(size)));
> 
> The Int128_* format helper make the line over 80. I think it's better
> not wrap it for readability.

I'd just reduce indent to previous line + 4 spaces vs the current "under 
the opening bracket" rule which I dislike anyway :) Thanks,


>>> +
>>> +    if (int128_le(end, int128_make64(start))) {
>>> +        return false;
>>> +    }
>>> +
>>> +    s->offset_within_address_space += start - s->offset_within_region;
>>> +    s->offset_within_region = start;
>>> +    s->size = int128_sub(end, int128_make64(start));
>>> +    return true;
>>> +}
>>> +
>>>    /**
>>>     * memory_region_init: Initialize a memory region
>>>     *
>>
> 

-- 
Alexey


