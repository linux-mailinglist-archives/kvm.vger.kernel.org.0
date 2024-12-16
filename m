Return-Path: <kvm+bounces-33865-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 449BE9F3639
	for <lists+kvm@lfdr.de>; Mon, 16 Dec 2024 17:38:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7535C18802BD
	for <lists+kvm@lfdr.de>; Mon, 16 Dec 2024 16:37:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB2781C9B9B;
	Mon, 16 Dec 2024 16:37:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="f5biWyTV"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2065.outbound.protection.outlook.com [40.107.100.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FDB084A3E;
	Mon, 16 Dec 2024 16:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.65
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734367022; cv=fail; b=K/uQ3TXj4yDhvOQRW6nYXm0wPgAkPCxrBqkT5Wne4N07xGfqcJiSIAoKxutbNb6LZahoEdqtAjk3+xeQU6OMOEkzQSynEcDgV7FWF4nZSu8z9I7w68g/FLihY53s+Xw0T3wvtbSh1DJDLynHaG+zi/8NYTUSZ+VUXi8K9DWe9G8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734367022; c=relaxed/simple;
	bh=LPja9XFRk40Fy/DBWIujyQmCteyE2QiJlYhuY24wbGY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Vgr0RbEl+3e8yAmi8fG3U58uSotY9dV/pCZXMgeqwRL1yuD+Ot6Grgqgo4gk7r3kC4+PN1df6N5hjfGquwJ1NJbkclE0CtDVPDnZvOxlPXStQOFyFe2lgeZzJfZIdGBgzkivFDrUQ9bFbqr3SrssnD6zs34SVWoJTYGvZ2/C4j0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=f5biWyTV; arc=fail smtp.client-ip=40.107.100.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mfJnOdPbxrnsknXMmgr9U3eo64PO+dCjGHh3RXDnDg+TvXREQxdcNxwD+1qoCm0wPk0l9AUOfLfrgwbuFbLV8fMJITPfdGe4hgy3WCb37Hncqfx6lEd+UNcgK7Vw3YAfy7k/mOEFPky3zgil/SorERsvyQR4hEUuiakZ3X0PCw0N0qgtMRP8iN/nd+s1UfDlK+SihOJEUGx4qd2LodN7BcuXIFjs9UdEVzcE2SFmNUux4L8LhbBlmP/8QLbVaswJIUwWgze4B00Tl2egCLpDAeZf9rAwRohT7kVdbVV7Mc7CmAyIOtagHj8cXBgHOit1ECnY+wEJDFuw+PycD5XFIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qVA5nkt9u9FDW8pQdsOBy+wIuicXVgns2IDL43Ks4Ak=;
 b=JzFJRwwGfmHj+wyoLlv8h2CtWhajZCzlv2lcAU6P4LllsV4BH8OA/uQsh4q9qc7KB8FSTjVNikLi8AWlyILBzaizpnrTzLAlo5zTHVlxgOBRklIAHYhuNSmj1zHJsClbDFMcl9g0SVFmmWNNdCn+z0cZxM9y35SoqidMmQzklwQqzB8EaJJahTy12PqEdx11+y74+CLsfWQg5OgyiX1/pk0izUSdjc61C1Nb91vWh2uTaUDkmaIbWFYsbFTAqzTGhxfgr2ru1K3DMl1h3/Hwsq0dTSkPSePJ8MIRu4eu7Id4a/E2sMuys0iqXO+S5QwNEvyji+RrOAsbxhRayHlAYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qVA5nkt9u9FDW8pQdsOBy+wIuicXVgns2IDL43Ks4Ak=;
 b=f5biWyTVM6F7cTvHVmBwkLdNDR9UQYzexnprlfr6UwdYeSR1zGfad//DSwgZVnLcPCNKTiyBqkoE51UGWCr+Qv3AnjQV64gtwqUX2SebgIfxXg8c1189YOmzO4ymaV02NKlQ8LxUUsSu8lLuRKfb7omWpEuAu1wOtrmwOgadejQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by SJ2PR12MB7893.namprd12.prod.outlook.com (2603:10b6:a03:4cc::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8251.21; Mon, 16 Dec
 2024 16:36:57 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%5]) with mapi id 15.20.8251.015; Mon, 16 Dec 2024
 16:36:57 +0000
Message-ID: <c8aa0e90-3e65-7e6b-23e0-6aea37a5439e@amd.com>
Date: Mon, 16 Dec 2024 10:36:54 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v15 12/13] x86/kvmclock: Abort SecureTSC enabled guest
 when kvmclock is selected
Content-Language: en-US
To: Nikunj A Dadhania <nikunj@amd.com>, linux-kernel@vger.kernel.org,
 bp@alien8.de, x86@kernel.org, kvm@vger.kernel.org
Cc: mingo@redhat.com, tglx@linutronix.de, dave.hansen@linux.intel.com,
 pgonda@google.com, seanjc@google.com, pbonzini@redhat.com
References: <20241203090045.942078-1-nikunj@amd.com>
 <20241203090045.942078-13-nikunj@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20241203090045.942078-13-nikunj@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA0PR11CA0153.namprd11.prod.outlook.com
 (2603:10b6:806:1bb::8) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|SJ2PR12MB7893:EE_
X-MS-Office365-Filtering-Correlation-Id: 1450c70a-b078-4002-f603-08dd1defdb8d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cldGQVoxa2wzT1pWZDRzZkZDY2tOK2hUS0NjR0xJZnB5dmVqaUowaXR3UFpU?=
 =?utf-8?B?TWFCYVYvNjJSNlZTRlM5RVNRTXlWZkowd21lZnl0Z1REMEovNDl2aUpuRGNY?=
 =?utf-8?B?azNaNnZHTWg0Qk94YVI3STNsbG9DQ3lIRDBrYWlVRjFTQVVNcUdXVnpyQjh1?=
 =?utf-8?B?Sm9aQWxrdStTUUVtT2d0OUlFZERpOEhnbWFxcmlSNG9iaDJRVnBvcjIzUkV3?=
 =?utf-8?B?SkQ0aDQ2d3k3bDViYSs4aUd5N2loZ1U3dDNMVnJBbmo1R3hPd210dUhzUytK?=
 =?utf-8?B?YU9LUkw5WUlLY2pCdWdJNW1id3NIbExodDYxalpJcnlyaGJkZ2tlR1hyN3hE?=
 =?utf-8?B?N3U4WEtLbG5XOWcrWDFSYjVvV3QyZUkxcGhHdnhhZmN5Y1I3TU9GTzJTS0tY?=
 =?utf-8?B?Mm9JNk9hc2dES1UyRzJ2TUVzTURUa1BHK2R2TlBRVlRITmxuMmVlTnV2NHFo?=
 =?utf-8?B?Nk5SelRoZVRLdGJaTExhazZwV3JVMXFqUWQvVkNCMm1GTGdheEhsSUxhdXpo?=
 =?utf-8?B?REtMcTVJeVo4cXg2Y2JrQ1FrZ3ZJVkFoMzFDV3ZUYmFmUlpLcjFlWmpFWHRT?=
 =?utf-8?B?UDg4ZWRGbTFVMlgybXU3KzZVTXlmdUdXMmFzSjFIcUxGdHl0RTVyVXNKb1E3?=
 =?utf-8?B?Y3N0Tlp3WnByYlhKQ3lyb1pLZjYxdnp1N1ljRzk0SkVDRHRXcW03bDFnNFpw?=
 =?utf-8?B?NGlwTHg4eHVyanp3Ti83c09IUVpzWVpHazFVN1RLQU5uZlZLTWQ5TTJ0cWUv?=
 =?utf-8?B?bkNhaWVaTzNJYUFieHFxK0IyTElXaGF1NVpyQUUrcTRLeGNXbTlxbjdnaW95?=
 =?utf-8?B?UTBIdXl3YkxhR2tmUHV2ZjFUczNkVTBlZFV5L3NwNnNMVVJ5NlFVTWIvbUht?=
 =?utf-8?B?RGFKaENSKzFlWU1xcHdYWVVXWFoyaEUzTDhOeS9oYjdDWHRhazdjMFJUV2hF?=
 =?utf-8?B?b2FnSGVnaFRjTUtsZTZERzRkRDRKNzJLakFMOVEvR0FoL1VJMkI0L0RYNmZU?=
 =?utf-8?B?aWcxR0xFbGhZVHdUNGk4ekdSVU52UkNwQXBTZHliYzdTUXZJbVh5QnlOeE9s?=
 =?utf-8?B?RUczZXYxbTJVeDd1NUE4NDRIWWZyS0hFdUZzOHNGZDNpSjFocWEyOUNSdTE2?=
 =?utf-8?B?dkdiUG5TWkZjVWdTd2FKeDJqSGV6NXVDdndwNzRYU28xZW5lRzh6TlFKa0NQ?=
 =?utf-8?B?V2ZwWmdLZURpNURYQUZiNHNwSjhGbm1tMFJESTg2bGI0Z2F0U2IzMGJiY2Jn?=
 =?utf-8?B?YXQ5ZURML0Y3cGNvVVJjMUt2eUhHYzJ0VERFeU5xbGl6YWc4Sm1EdG5oSHly?=
 =?utf-8?B?Q3pqaGd5REpwa0pWWnQyOFNXeHordmU5bFRsN0tjdjI1L3M3aW1GaUdmbDlH?=
 =?utf-8?B?RWJzL0NPQnBSR3p0dmtNaHZKR1VaMlIwZGYzK2grNjhLTVhMSHp6Sm8rS3hU?=
 =?utf-8?B?UkZiWHJlajMzK05zUVlqVXdQbklna01DcE5QK3NXSDFCMUpIcTd1RThRamJI?=
 =?utf-8?B?NndocG5XWVRiVkUzZmpCNmx1U3NqUWdJaE91ZkJ0R2RobjBqNlpIY0lMUit3?=
 =?utf-8?B?QlMwempTSlBPUXNJa04rZzZRYlpsQlUvaDBnTHJ5WkZXQS93T21UUzUvaWRs?=
 =?utf-8?B?VzlzQ09ONzRRK21RcnZNa3NGY3hQYk1KZ2c4RmZJNVRRbUs5VzE2SC9TNWlh?=
 =?utf-8?B?WWJ2ajExcjByRUVoRElnOTFadDNNQ2prZ3R4ZGlQclRQaHRTNHE2RiswTFVI?=
 =?utf-8?B?bUc3LzBPVWVNcGJlMzNkQWFBeEtuRXh1Z2duWjg2VjFYcFRhTUlZamFnTFFG?=
 =?utf-8?B?Y3JYRDBUSlFlNmc2U2dWbHViMnd2QjVYdlVpNkpOR09UY0t3TG1HaEFiR3M1?=
 =?utf-8?Q?n2fm64wwwTKSG?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Tkd5U2NpYTJpZEN5UnRnbHhjRVBIRjlXYURFOHkzZVRtRWlOYVEzK2tSTFox?=
 =?utf-8?B?UEFNZ2hqWUF5V0ROU3hTQUFXQXVyaWJIL0tLT2lGY3k3TmlEUE04Uk42Q1RS?=
 =?utf-8?B?YzNhOWcybFl5SjlONUkwamQxQ0NRNmJiVGJlWFhpNkgzL29FVHhzeWEybVp1?=
 =?utf-8?B?TmJxbjl6ZnNNcFFUcUViejRtTjVKbE5VTFR5ZnY1YUVhRkxabmVGb3krYmxi?=
 =?utf-8?B?WVVDNE5jczdGcWsvc0d1dVdNN25IeXZZOU9xaXRtNDdvN2g4Wm9yaWtTUHlh?=
 =?utf-8?B?RzJDclhtUjUrT1phc2x2bVo3Q05ySWpOeWw4UGFUTGZqUWllVmtqdEFudzJz?=
 =?utf-8?B?ZFpDdzFXbmszdTFkdHl0OFpmUXA4a2FFKzMvNzhZZjU5czBobnNCc25UV3RU?=
 =?utf-8?B?ckVrOHZnd3VNMkpJTGd2M1RXaGo5VnMzdVpkTHJjM01SdnlIQmNKUkZpWUdT?=
 =?utf-8?B?OGZZelRXc1FKK1labzFmbDNhbktsdWZyanNyUWtJUzZ3QTdXZ2NKK1NFVnRY?=
 =?utf-8?B?RVBZcVpHakl3aDdyakJhdGVFMVJrN3ZCT0MvM21sWndncjRtVzBJUXh3c2ox?=
 =?utf-8?B?QXBZU1M3Y2ZrNmJqMk1CUENBRmlGOWR1OHNTZVA3TDZlOU9oVHprb1ZqUERr?=
 =?utf-8?B?VjVhcG5kelViS05rZ1RiTkNjVzVraGRBcncwTm1LejNjSmFjb2xCbERQTGVS?=
 =?utf-8?B?clh2RDU1RWdoSHhpNE14Z205SU5yZGpXaU5TaFIxSWkrbSsrU3l5ZUwyVDdy?=
 =?utf-8?B?TnpackRxM0htc0Y2VEVSWHR2S2hnN1JCU1BYL3BmUjFqeVRXTDloZnVJY0lB?=
 =?utf-8?B?YmlXM3lGeUt2b0NCb2VKVi9DbUhPNEdZOEVmb3h5VFRaSis3V0k3bGh2SEt5?=
 =?utf-8?B?UmNhSndJVkY4bnpjY3B5c2Rqc0pLTWFoR3p6QjZMeEh1b0E4aEIrbjRIYnpC?=
 =?utf-8?B?RVBMa0srMlRTdm94Y0hyUS9aaXpVK0xsTnF3dXNlQkUveDMxVERFaHdaUkd4?=
 =?utf-8?B?S2tqNjRqQ2UzQlFiQ05jVkVIYkJaeEIwVFZ1UHV4d2w5VW9GcWZONVBzeEpu?=
 =?utf-8?B?dUJwU2hVT0g1emN3cjRDUW9NcmMrS2pNZzRpdmkwZkc1T011c1NLSzNycjIw?=
 =?utf-8?B?WmI0eHFNbjNKL3hlV0xmbkFLYmxyQnJobkFsM1k1U1Fpd1U4U1oxdFNObi82?=
 =?utf-8?B?dzllVkFoTi9ZeHgrSlVXZE01ei84RzA2cXJTWERONFBVczY0ZWNQV1F3ak5l?=
 =?utf-8?B?bkEwSnROaHUycjcyZDJVbytERW1EME1UQS9TMGcxWTRnN2JKSmhhSnFtcUdR?=
 =?utf-8?B?VG9TVm5MbERIVW1GOVkwakNvVVJGbTVWR3NmMk5oYThLRkdzVUtoeXo2NHpx?=
 =?utf-8?B?Y09KU0ZsQUUzeFcxMldYRFMyU0x2Y0dodFpaTkRPQXAvOGQyZXRNdGxsRVcr?=
 =?utf-8?B?dzdFR09lTW1pSFV5cmkwTkRLc0ZRZE1Fait3RkMwQ1EzSEFMQ0tBNVNkUE9P?=
 =?utf-8?B?YTRsUlZod0RveVFvZDFLOWlYam4rSXBlbHM0dnlGWldYempiRGdocG93bHJM?=
 =?utf-8?B?aEVuWmRKd2kvZUt1YXJyb2hUWnZnUHVIb1VWQ2c5TGVwcjlNalV6cVpRSHV4?=
 =?utf-8?B?OHBQWkZkKzFBb2k0OHlVWVFKQWRxMmJudEs1a1krN2N1ZExXcjJ0S0p2RUlP?=
 =?utf-8?B?TFJPTWRUd1dXTGxNZGlNT1VTekd4SktMMFh3bFFVNUZENnNESitqcmNjWEpU?=
 =?utf-8?B?SVBoVy9hNzBFQzlWMmZMcVYxdlRJTi9ZRG1pZnVGSmNMVHlJQS9DSXpaR2ow?=
 =?utf-8?B?WFpFQ0MxQ3dMUGtlUDZ0QkVJbHJITjVpRGF2TDJHcmJTZVZvcHluRWMyb2tT?=
 =?utf-8?B?d1JEdWJGUUhTYlI1KzBWQXo4R2h3RlFaa0l1NE1ERVJpSzdzRXJkTk1FOGZz?=
 =?utf-8?B?QkpKVCtKdXBiT293azJmUitITk14cjRPWHNzOUs5OCtUeTJLbWZxQzMvSDNy?=
 =?utf-8?B?RGpnVU1YQjdtNENMK1dEakJ1dHZITWpTbkJaWEd4eE9Fa1BDWFpxOEhxRy83?=
 =?utf-8?B?QTFQdGNCNW1BbVhUUlFQSmVkSWU5a3UvNTV1cjZHaUl4dVVDVTU4N1l4eURq?=
 =?utf-8?Q?swyVOsb95zVbB64OERs/kcgx4?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1450c70a-b078-4002-f603-08dd1defdb8d
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Dec 2024 16:36:57.5432
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bbDMNCP2qurcls+XsIN98wIOiS/axmhb01IaNSCqxVVwgu9hYShM53pjRVTsriyYmB2YGLX+2bkjCsaOEMlokw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB7893

On 12/3/24 03:00, Nikunj A Dadhania wrote:
> SecureTSC enabled guests should use TSC as the only clock source, terminate
> the guest with appropriate code when clock source switches to hypervisor
> controlled kvmclock.
> 
> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  arch/x86/include/asm/sev-common.h | 1 +
>  arch/x86/include/asm/sev.h        | 2 ++
>  arch/x86/coco/sev/shared.c        | 3 +--
>  arch/x86/kernel/kvmclock.c        | 9 +++++++++
>  4 files changed, 13 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/include/asm/sev-common.h b/arch/x86/include/asm/sev-common.h
> index 6ef92432a5ce..ad0743800b0e 100644
> --- a/arch/x86/include/asm/sev-common.h
> +++ b/arch/x86/include/asm/sev-common.h
> @@ -207,6 +207,7 @@ struct snp_psc_desc {
>  #define GHCB_TERM_SVSM_VMPL0		8	/* SVSM is present but has set VMPL to 0 */
>  #define GHCB_TERM_SVSM_CAA		9	/* SVSM is present but CAA is not page aligned */
>  #define GHCB_TERM_SECURE_TSC		10	/* Secure TSC initialization failed */
> +#define GHCB_TERM_SECURE_TSC_KVMCLOCK	11	/* KVM clock selected instead of Secure TSC */
>  
>  #define GHCB_RESP_CODE(v)		((v) & GHCB_MSR_INFO_MASK)
>  
> diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
> index c4dca06b3b01..12b167fd6475 100644
> --- a/arch/x86/include/asm/sev.h
> +++ b/arch/x86/include/asm/sev.h
> @@ -494,6 +494,7 @@ int snp_send_guest_request(struct snp_msg_desc *mdesc, struct snp_guest_req *req
>  
>  void __init snp_secure_tsc_prepare(void);
>  void __init snp_secure_tsc_init(void);
> +void __noreturn sev_es_terminate(unsigned int set, unsigned int reason);
>  
>  #else	/* !CONFIG_AMD_MEM_ENCRYPT */
>  
> @@ -538,6 +539,7 @@ static inline int snp_send_guest_request(struct snp_msg_desc *mdesc, struct snp_
>  					 struct snp_guest_request_ioctl *rio) { return -ENODEV; }
>  static inline void __init snp_secure_tsc_prepare(void) { }
>  static inline void __init snp_secure_tsc_init(void) { }
> +static inline void sev_es_terminate(unsigned int set, unsigned int reason) { }
>  
>  #endif	/* CONFIG_AMD_MEM_ENCRYPT */
>  
> diff --git a/arch/x86/coco/sev/shared.c b/arch/x86/coco/sev/shared.c
> index 879ab48b705c..840149556241 100644
> --- a/arch/x86/coco/sev/shared.c
> +++ b/arch/x86/coco/sev/shared.c
> @@ -117,8 +117,7 @@ static bool __init sev_es_check_cpu_features(void)
>  	return true;
>  }
>  
> -static void __head __noreturn
> -sev_es_terminate(unsigned int set, unsigned int reason)
> +void __head __noreturn sev_es_terminate(unsigned int set, unsigned int reason)
>  {
>  	u64 val = GHCB_MSR_TERM_REQ;
>  
> diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
> index 5b2c15214a6b..39dda04b5ba0 100644
> --- a/arch/x86/kernel/kvmclock.c
> +++ b/arch/x86/kernel/kvmclock.c
> @@ -21,6 +21,7 @@
>  #include <asm/hypervisor.h>
>  #include <asm/x86_init.h>
>  #include <asm/kvmclock.h>
> +#include <asm/sev.h>
>  
>  static int kvmclock __initdata = 1;
>  static int kvmclock_vsyscall __initdata = 1;
> @@ -150,6 +151,14 @@ bool kvm_check_and_clear_guest_paused(void)
>  
>  static int kvm_cs_enable(struct clocksource *cs)
>  {
> +	/*
> +	 * For a guest with SecureTSC enabled, the TSC should be the only clock
> +	 * source. Abort the guest when kvmclock is selected as the clock
> +	 * source.
> +	 */
> +	if (WARN_ON(cc_platform_has(CC_ATTR_GUEST_SNP_SECURE_TSC)))
> +		sev_es_terminate(SEV_TERM_SET_LINUX, GHCB_TERM_SECURE_TSC_KVMCLOCK);
> +
>  	vclocks_set_used(VDSO_CLOCKMODE_PVCLOCK);
>  	return 0;
>  }

