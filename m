Return-Path: <kvm+bounces-60019-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A0D9BDA99D
	for <lists+kvm@lfdr.de>; Tue, 14 Oct 2025 18:24:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 88F2A5808D0
	for <lists+kvm@lfdr.de>; Tue, 14 Oct 2025 16:24:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C337301466;
	Tue, 14 Oct 2025 16:24:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MnIV4ZpT"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D3AC255F22;
	Tue, 14 Oct 2025 16:24:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760459056; cv=fail; b=kO+kNptcm14syRZQ4eWPaiMnyruEzngZd6OOJFjiLvPVZGAU7fvTmhN7t+tjmWGdjNpPxey2I9Zvz6FmCHeaICPjx9CX/O3p17JKWp5z+Ww0cU1L4beYaoSLyEKz51TK0aDbcKcEsIJwFknnW5xXgRawhuBM4paijiIIQkXD8s4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760459056; c=relaxed/simple;
	bh=cUT9N4/WPBnYWc3mjV4lqaxdFQNg/hfAN+ac+tig7tQ=;
	h=Message-ID:Date:Subject:From:To:CC:References:In-Reply-To:
	 Content-Type:MIME-Version; b=hnJAo3LycLGC9/ZXzGdp8I3BconpXY78sPxI9VBs7qX6utWwI9E7nbssoKAApeudJ+04cDF16jNp3h+6aZxC6MKgfy31BRb7ZrvypZiXQT5QW/X4ExsgjpFDA7wVMc3112nTcUFDg/KaWPRbaQyC6V/Gf8L6R6cu8RhwxMQ8Ed8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MnIV4ZpT; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760459054; x=1791995054;
  h=message-id:date:subject:from:to:cc:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=cUT9N4/WPBnYWc3mjV4lqaxdFQNg/hfAN+ac+tig7tQ=;
  b=MnIV4ZpT/iQpZHL9dWL/ZDvhDkR4HQyNdz5Qa/ksACM9XT1w2wTTiHdo
   ulLeFOHBRiy/Mdx7PEQ9nXg1cKdaBe0SIcV8MRNLGlTLSJhNtYRrcrlo5
   C1NfMdUeinAChVOOrzE0c32a+skiD0rEctNNmNa2itrIBrvxrdSjgRk+Z
   3rCTJzpJYh8iien6yROKxcuayiQAVy5rBjmvAalyM95trGpxpgu1j3eHY
   yudB/9OXdAzISO26kwhzdzvWnsZeevHW85dK4YWaDTH/yUIQMVbsZA1o3
   CKc/An4C9mm8WqqZr9CVwBmqRfioU/uPKgQb/TfEVZd73eSeK1SYMr5wN
   g==;
X-CSE-ConnectionGUID: IuQLI+a+QTmacmaG6WywLA==
X-CSE-MsgGUID: s2NwADI0Ru6NYXLMCX5e/g==
X-IronPort-AV: E=McAfee;i="6800,10657,11582"; a="65244893"
X-IronPort-AV: E=Sophos;i="6.19,228,1754982000"; 
   d="scan'208";a="65244893"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2025 09:24:14 -0700
X-CSE-ConnectionGUID: nF3uqKStSgqfcoPJ/uNpxg==
X-CSE-MsgGUID: jNH6D8rWRUKNfra47DywhA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,228,1754982000"; 
   d="scan'208";a="181607336"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2025 09:24:14 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 14 Oct 2025 09:24:12 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Tue, 14 Oct 2025 09:24:12 -0700
Received: from MW6PR02CU001.outbound.protection.outlook.com (52.101.48.40) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 14 Oct 2025 09:24:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cPaEhvKAmAYhiasdij0Q1xGIpiZy/yf1c0ucq7ybzgMqZX+ABwm+k0YcuNMExI2G7vCMDWZsTcr3h2nYtM3BHjYxbRZLR6yS9xidgwxv1qMFSJtySOJu4lxpW2/NVEALB78uakSmkt7QiCuuEW6WroZK3Hx9J1+7yUyQsxDEXCybIkgB7IwTmmT9G3uSd6hFacRdndFmPhEslL81F20vtWUT1fvQLj+XrxMHO4uwY6Yu3jDWUcvw+mH++Bhl9LxW43S8zwE8YX27+9IHyhc1J+kSKPVTqx7CQQ2fr/SKX5gHH6Cp+eZv9buEtPlvd4AKBfzkRDu/vLfX7GTsCHbv+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oFwwq6TTpL7AjZUrjSkEQD+uLZEw+NNIME8r2ghi+Ns=;
 b=Xka5jkB4yfXFQhrrCW4WUYVZqXIODLcgIf2EvEEdCWzLOa0MIim961vgn/Xn6U3Pso8UYAnU1G2XeSj1fCo9AuPfikHmHQ+69fxmYSkhSWAkAoQuxK7/ZlPwWynRUJCFp1w3RdRaMvedAgsLXCQBWc1gjU5LbJlyjzD8exLjvRqaUvOmM0UkWdlKUs7N/m7KoJhEU34vrWJGr93pOcC92eCUbLTZD8n0ld8SYToRWYqOmEQ64sbExbQZPcudnhF4XpdkonSYYlffGqX7wtt9H5C+46JbadVIcstwUqb7JjOvIZKA4HkKDNj5ZXCjo3xNcM/K6uWaLJf2rrJBHK2B0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by DS0PR11MB8083.namprd11.prod.outlook.com (2603:10b6:8:15e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.10; Tue, 14 Oct
 2025 16:24:10 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.9228.009; Tue, 14 Oct 2025
 16:24:10 +0000
Message-ID: <3f3b4ca6-e11e-4258-b60c-48b823b7db4f@intel.com>
Date: Tue, 14 Oct 2025 09:24:08 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] fs/resctrl: Fix MBM events being unconditionally enabled
 in mbm_event mode
From: Reinette Chatre <reinette.chatre@intel.com>
To: Babu Moger <bmoger@amd.com>, <babu.moger@amd.com>, <tony.luck@intel.com>,
	<Dave.Martin@arm.com>, <james.morse@arm.com>, <dave.hansen@linux.intel.com>,
	<bp@alien8.de>
CC: <kas@kernel.org>, <rick.p.edgecombe@intel.com>,
	<linux-kernel@vger.kernel.org>, <x86@kernel.org>,
	<linux-coco@lists.linux.dev>, <kvm@vger.kernel.org>
References: <6082147693739c4514e4a650a62f805956331d51.1759263540.git.babu.moger@amd.com>
 <a8f30dba-8319-4ce4-918c-288934be456e@intel.com>
 <b86dca12-bccc-46b1-8466-998357deae69@amd.com>
 <2cdc5b52-a00c-4772-8221-8d98b787722a@intel.com>
 <0cd2c8ac-8dee-4280-b726-af0119baa4a1@amd.com>
 <1315076d-24f9-4e27-b945-51564cadfaed@intel.com>
Content-Language: en-US
In-Reply-To: <1315076d-24f9-4e27-b945-51564cadfaed@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MW4PR04CA0191.namprd04.prod.outlook.com
 (2603:10b6:303:86::16) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|DS0PR11MB8083:EE_
X-MS-Office365-Filtering-Correlation-Id: 49904f33-b2f6-481c-633a-08de0b3e1b3c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?MjlSTFJuNStkUnZiVEFXL1N4WHdaeDZjZG1tTi85eWtZemhzUllDUW1wT3Bp?=
 =?utf-8?B?eGphUGt2dzZRSGZxY0hYc1FuRWdmUlZZVWdVUm9tbUhtTkVETm1tTGpFMHV3?=
 =?utf-8?B?V25JeUM0NzloTzg0RnlGTzkvNWtlQjNzUFRoMnhuSWZyRC9rcGtjWGtSTHZL?=
 =?utf-8?B?WGFLNFhwTVNOWkNLNG0yR2pha0NSUFFrZHpRUk5sOGFxQ3dSME9HUzlhQ0t4?=
 =?utf-8?B?NzhacTRCc1NwV1pzU014QWNGYjRzTW9hbTNRdm1wVU1CY0NoTGdWQkRpdWhH?=
 =?utf-8?B?em5sV1Z6S2JGSE10bVhFL1BJQ2NoUHBnSzIzSWU2SWVDWWtucXBpSzljRXFY?=
 =?utf-8?B?UXNsVTB0OXN2RnpDYlorVGVqRWl3Q2FjSzd5K0R6Q1VxRUt2N1FEMVQ2dmdN?=
 =?utf-8?B?ZTgxaDVIcThWVkJpaVV3dU9oSWlmYnFNUzJzd2ZvdER2ZS9YQ2x5TGZjOXNU?=
 =?utf-8?B?RkZMRUdqaHFsSytRMFBIQTVhU1dsN2ZMUzMvMkxEYlNqRzNLYUpyck9TaE1E?=
 =?utf-8?B?UHdKVDljbjNMM0F4UnFGMUZSQmJjdU0zNml1RlBnRk5oSmc3cWJyZGZRNmtk?=
 =?utf-8?B?M0Y3VDQzOGwvSUlMNGFwRWp2U3ZiL2FvRTk1TFNsRVZMMjRNUFhtN1NEOVRq?=
 =?utf-8?B?ZXlXbUg2OU9ZUFQ1cEZOVFQ5N3VSdEhTQWZMT3VveFJvZzdVK1RtMWZxeExv?=
 =?utf-8?B?NDYwMFJvQk1YTlJBaFFjOUJsWS9MeEh3T0ppdDhzY2UxL2RnQ0VWT2NWSDhs?=
 =?utf-8?B?VFBoWkhROTl2bGZsVHBlaDV0R1ZhUTk5QUpySGpCOE9oMGJRS01mRVR0aFV3?=
 =?utf-8?B?WkJSUCtvZmRqL1lCSmsyb0tTUG8vQ2hvZHJQQVMxU1dlOXRXWkRPaGNLR0lm?=
 =?utf-8?B?T1cydEl6T0FkcnJUVStUek01ZjBrZG00SnpIWW43MFJSdmFTZkNVd0JWclVJ?=
 =?utf-8?B?dzBKL2pCK25vZU5EMGRLdWFaYVpiZ3h6S1UvRWNCVjVLZkR2NkdkZzRNQUdo?=
 =?utf-8?B?NThOZ3RuQmxOaUt0anJ1anpNbFppL0ZWclRtaU9EblFHMnlNTVVxdkxVK25V?=
 =?utf-8?B?UGdpMzh5TS9vRUROTlFoSC93Q1hyUmwrY3BqalYwbVVlaVQ2UXRWMCtWUGZq?=
 =?utf-8?B?dDFEV0VSczFNUHo5VGkybllDaWZUQmF1bnFUZU03Zmc3TStZbDVjcGlQbEll?=
 =?utf-8?B?U2picVoySUJJa2VpU2t3NWZkTy8xQlFjQzJjaGRxbUxWSXdBS0FrTXg1QStH?=
 =?utf-8?B?ZW9nUTVBblVsK3NBQ1kxankyTjcvTThaQUtqR1ZCN2VXMUpxeVFjaDJFbStn?=
 =?utf-8?B?aG1pUDYydms1bUNGcytrV1Fsd0FlUFVrc1I3b044MmhPL256K1MwNWEzRjQ1?=
 =?utf-8?B?Sm5aakdXMkQ5a25VYVU3eVNGM2NKeWVDeWxEbVcyWjViUVc1WHlpS0wyaXZq?=
 =?utf-8?B?RlVJTUgzbzFZRE5HT1lhMkVQOElmOEZUTGhUL0h0bTRVWEdvemNRcVIvYnMw?=
 =?utf-8?B?SlpVa0lvaW9pamN4a0JvNEU5d2I2NitLWGV4VVNnRnN6cUlXMk5uYk9TYXF3?=
 =?utf-8?B?TnYxRjFtSmtXQ2NBKzd4ZWZLeisxUFI4bGhuQzlMUmlpQzdRdVFVaEhkRXNx?=
 =?utf-8?B?TDVsTm9Ja1A0MXFKbDRIWUFoMHdSL0FIOHRWVDUyT0lmTEhRRW5mdU9sWDd2?=
 =?utf-8?B?dlN2aEFDTUVvVGIrelhGSDVkRHR5b2lJcUR0bVlRd1l1WjgwSmNXK1hpUWUv?=
 =?utf-8?B?QkhOazF2ajZDOVN0OEFxVGdCWERSUW16YkpxS3NMN2R6RkdZbXpmbHVyZGMv?=
 =?utf-8?B?UVppUFdXdFZvaWpRbUErMVdDSFBtaGRVNVNOTTRVMTR6VGhHS3YvUWNpWTdW?=
 =?utf-8?B?SGorTExrVTQ4d0tBSXQ5UFlXUnRHZTlHdCt3M3hRZlpoWkJSZ0xHREYxYlAr?=
 =?utf-8?Q?ideS2PoJ7ulCFHoMCL1LYdiNXsLMo95r?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eTk5STJyUVZhMCtYajBjTmhNNjNGQmNtS2t1TkZ5dStUaEZ3MndrN1Y0Q3Vn?=
 =?utf-8?B?ZWhyRUlDc3U2aDRJQUZ2dG4yVDVsRWkxRWZYcFhRRXJST3BZajJQMVhCbGRY?=
 =?utf-8?B?NkJWVDFBajNycEJ1U2wvWUdlUEgwbFJyNDFBQ0UzeUZmclR4UkU4WU9iUm1X?=
 =?utf-8?B?T2dFSGdWUERqelJmMmFtUEgvRUxWRjlnSG9hdXREclpCTkJBbnRzS2lCMEdP?=
 =?utf-8?B?M2Q0dlczTlpQeUZLaU10TDF4QzVhek1GQms0eFpvSmk1K0J2MXJwcjhleUNS?=
 =?utf-8?B?WkJxQ3NtNFE0VDdzSm9sVlFXbTQ2Z0RaUzNFdXhJM1k1Mm4rSGpPTjVwVE5S?=
 =?utf-8?B?WHI1MThGL3A2MlBlVDFHMWMvR3c1UkhaaWpMTTNRVTRWMEhiNlAzRkNYTGVu?=
 =?utf-8?B?cmlZeU1SRmpKVUJMd2dHUnl0MUJNcUFDNkRYdzJOV1pXbkpSOGpnSXdGS1pS?=
 =?utf-8?B?ejByMVVlN3JLOEp0QVlTcERzRDFaSUhTRkhYaHI0R2VqVzRHZEQ5cTdSWmhK?=
 =?utf-8?B?VzNyMUJheHBOTTZBVWlSK28wOElrL2NHZHlXdXRRZis0WWhxQjNOOXpBOW80?=
 =?utf-8?B?SDRsUkU0YUl1VGpqT3N6d0pib29KTE9mZUJFb1NEZzhxTmhpaStNWnI5cHFO?=
 =?utf-8?B?RlZzcTRJRTQwNEM4c0VGd0gxd29xaFNYRjFWaFNuc0RoekZjRXFUM3p3cWVJ?=
 =?utf-8?B?YlNIcjBBdHhTbGpvM0wwbTFuNk1PQnVuR1JZOWtGMGU3RVFleHJ1T0ZTN251?=
 =?utf-8?B?RUh1Vy9oZGFjMWp0M1VVV1kvZTVONzNYTi9EcEJsb01vSGJZUHJiQTZmVTVt?=
 =?utf-8?B?TlpSS1EyZlliSE9DNCtWQzh5blFVTG9CbFlpN2xVNVZGMkt3QjVoaWRIK2dB?=
 =?utf-8?B?cXJyTSt6WjdIQjBZZ1pFRnhNSnRFSitoc1Zibm41VFZLOTdDVTEwVFBQMStO?=
 =?utf-8?B?QURLRDZFSUF2Rm9MckxKTDJVcmhOYUF0b2R6Q3h0QllVWCtqYVkwM2VjQ2w4?=
 =?utf-8?B?LzdSbXgrVVFrUitzVDZwV0JoTDd3TlN6OXhPNmZNaFI2VjNzWXN1aklmQVFv?=
 =?utf-8?B?ODRja0NGbEI4aE82NWFBeTg2eTFvV0hLQ0E5WmdvdG5GbkJGKytXa2lKTGQ0?=
 =?utf-8?B?cEdCR0xyajVzYUY4VWszaEY4YkpHbTNrNXpQMFRQR2p1NEpDNEoyZVBqc0N6?=
 =?utf-8?B?SC9sVVhjdG9MUkpzeDdnd2I4enBmOWg1SWtyci9PKzVnQWtYbXhoa1V5VytV?=
 =?utf-8?B?MkN5ZnVWMkNKdml4R2ZmcWxHWDRwYlZDT1M0Tm1aRTF6QWN2TnNUYTFnTDdF?=
 =?utf-8?B?dzY2QjkrUG8vQ2hwRnlFSXBTS0liTEpXVXV1VkVCNUR0dGhDZWhsRHFoc2FW?=
 =?utf-8?B?NnZScUNES25ObkRFcitoUFNYV3YrQy9pTGpscGY3UlU0bThwZTR3UkhuOFBy?=
 =?utf-8?B?MVN3V0tMcU12bkhYYkVWRTEzZXNBOFJMS0ZzeGFRRkpaQVRuSUd0eHlMdDZy?=
 =?utf-8?B?akk5c3lxVnFsbzVqL01QQ25tNGNsZW01WVJ2WDB1SjBmV3FOZHkvMnBlbnh5?=
 =?utf-8?B?ZXhSdDhHejQ1QmMrV1EzNmx1VHdNSmtKemo4QkM1aHl1Tm5aMUNweTdIRFZa?=
 =?utf-8?B?c01yaTBRNVE5d2JNVW1ZVXczSm1aYVVGVnZPNzRhZnlwWGRQYkJDZTVvYm0r?=
 =?utf-8?B?YVM4R2Y1TFZrMlBRU1V6Q0lGUlBYbWIrY3ppTVFxK0R1TkhvRGQvQjltRFFk?=
 =?utf-8?B?ZG1CRlRJc01iTkk4RTNtRUxjbW1IQUFac0V3cGpoOGJSSWx2UHErK3dVVnMx?=
 =?utf-8?B?Q2d1Ym1xQ1VjV0h5aGtGRGMrQjB5MmtnaUd5YWgvNFBtb0ZEUWlXbktQd0hC?=
 =?utf-8?B?cnJIUWxUNlc3Slo1N2VTZURHdC9MaDdSMGFMWWV5TXM4NUFmRDZHcDNIWWZa?=
 =?utf-8?B?S0kvK3M4Wk4zV1JKdVFYc3VTMHc2WjA0dlVycFltc0I2WGdWSmlFd04xTG5q?=
 =?utf-8?B?cjZ2TUpwa0NUK0F2M21HVm9DVEtDVmJQeWV0ejV2YUh2VDM3UkRMRExuL2tL?=
 =?utf-8?B?RGJPREJFamh1UXhveENGMlYvdnlaL3hUMEFmM2JlbTJKYlFjTlVqQUw5ZHRn?=
 =?utf-8?B?NHVlQVlLUWlKV1dXeDBGR0F1WDVBUTI4YWVscDl5M1FjL2tkeFdnNHVGQWRn?=
 =?utf-8?B?aVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 49904f33-b2f6-481c-633a-08de0b3e1b3c
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2025 16:24:10.7980
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5pGp0lvrT7FlP0kPFLNCEyLnFVbcNV3UQw5zf7GiZB5ICW6KcuoMiuX3Nzkzmi1AaCU3BGXkGL7eUp8V8tBAsRM9UUHuiQNnJN8sNNVJ9m4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB8083
X-OriginatorOrg: intel.com

Hi Babu,

On 10/7/25 7:38 PM, Reinette Chatre wrote:
> On 10/7/25 10:36 AM, Babu Moger wrote:
>> On 10/6/25 20:23, Reinette Chatre wrote:
>>> On 10/6/25 1:38 PM, Moger, Babu wrote:
>>>> On 10/6/25 12:56, Reinette Chatre wrote:
>>>>> On 9/30/25 1:26 PM, Babu Moger wrote:
>>>>>> resctrl features can be enabled or disabled using boot-time kernel
>>>>>> parameters. To turn off the memory bandwidth events (mbmtotal and
>>>>>> mbmlocal), users need to pass the following parameter to the kernel:
>>>>>> "rdt=!mbmtotal,!mbmlocal".
>>>>>
>>>>> ah, indeed ... although, the intention behind the mbmtotal and mbmlocal kernel
>>>>> parameters was to connect them to the actual hardware features identified
>>>>> by X86_FEATURE_CQM_MBM_TOTAL and X86_FEATURE_CQM_MBM_LOCAL respectively.
>>>>>
>>>>>
>>>>>> Found that memory bandwidth events (mbmtotal and mbmlocal) cannot be
>>>>>> disabled when mbm_event mode is enabled. resctrl_mon_resource_init()
>>>>>> unconditionally enables these events without checking if the underlying
>>>>>> hardware supports them.
>>>>>
>>>>> Technically this is correct since if hardware supports ABMC then the
>>>>> hardware is no longer required to support X86_FEATURE_CQM_MBM_TOTAL and
>>>>> X86_FEATURE_CQM_MBM_LOCAL in order to provide mbm_total_bytes
>>>>> and mbm_local_bytes.
>>>>>
>>>>> I can see how this may be confusing to user space though ...
>>>>>
>>>>>>
>>>>>> Remove the unconditional enablement of MBM features in
>>>>>> resctrl_mon_resource_init() to fix the problem. The hardware support
>>>>>> verification is already done in get_rdt_mon_resources().
>>>>>
>>>>> I believe by "hardware support" you mean hardware support for
>>>>> X86_FEATURE_CQM_MBM_TOTAL and X86_FEATURE_CQM_MBM_LOCAL. Wouldn't a fix like
>>>>> this then require any system that supports ABMC to also support
>>>>> X86_FEATURE_CQM_MBM_TOTAL and X86_FEATURE_CQM_MBM_LOCAL to be able to
>>>>> support mbm_total_bytes and mbm_local_bytes?
>>>>
>>>> Yes. That is correct. Right now, ABMC and X86_FEATURE_CQM_MBM_TOTAL/
>>>> X86_FEATURE_CQM_MBM_LOCAL are kind of tightly coupled. We have not clearly
>>>> separated the that.
>>>
>>> Are you speaking from resctrl side since from what I understand these are
>>> independent features from the hardware side?
>>
>> It is independent from hardware side. I meant we still use legacy events from "default" mode.
> 
> Thank you for confirming. I was wondering if we need to fix it via cpuid_deps[]
> and resctrl_cpu_detect() to address a hardware dependency. If hardware self
> does not have the dependency then we need to fix it another way.
> 
>>
>>>
>>>>> This problem seems to be similar to the one solved by [1] since
>>>>> by supporting ABMC there is no "hardware does not support mbmtotal/mbmlocal"
>>>>> but instead there only needs to be a check if the feature has been disabled
>>>>> by command line. That is, add a rdt_is_feature_enabled() check to the
>>>>> existing "!resctrl_is_mon_event_enabled()" check?
>>>>
>>>> Enable or disable needs to be done at get_rdt_mon_resources(). It needs to
>>>> be done early in  the initialization before calling domain_add_cpu() where
>>>> event data structures (mbm_states aarch_mbm_states) are allocated.
>>>
>>> Good point. My mistake to suggest the event should be enabled by
>>> resctrl fs.
>>
>>
>> How about adding another check in get_rdt_mon_resources()?
>>
>> if (rdt_cpu_has(X86_FEATURE_CQM_MBM_TOTAL)
>>     || rdt_is_feature_enabled(mbmtotal)) {
>>                 resctrl_enable_mon_event(QOS_L3_MBM_TOTAL_EVENT_ID);
>>                 ret = true;
>>         }
> 
> Something like this yes. I think it should be in rdt_get_mon_l3_config() though, within
> the ABMC feature settings. If not then there may be an issue if the user boots with
> rdt=!abmc? I cannot see why the rdt_cpu_has(X86_FEATURE_CQM_MBM_TOTAL) check is needed,
> which flow are you addressing?
> 
> Before we exchange code I would like to step back a bit just to be clear that we agree
> on the current issues and what user space may expect. After this it should be easier to
> exchange code. (more below)
> 
>>
>> I need to take Tony's patch for this.
>>
>>>
>>>>
>>>>>
>>>>> But wait ... I think there may be a bigger problem when considering systems
>>>>> that support ABMC but not X86_FEATURE_CQM_MBM_TOTAL and X86_FEATURE_CQM_MBM_LOCAL.
>>>>> Shouldn't resctrl prevent such a system from switching to "default"
>>>>> mbm_assign_mode? Otherwise resctrl will happily let such a system switch
>>>>> to default mode and when user attempts to read an event file resctrl will
>>>>> attempt to read it via MSRs that are not supported.
>>>>> Looks like ABMC may need something similar to CONFIG_RESCTRL_ASSIGN_FIXED
>>>>> to handle this case in show() while preventing user space from switching to
>>>>> "default" mode on write()?
>>>>
>>>> This may not be an issue right now. When X86_FEATURE_CQM_MBM_TOTAL and
>>>> X86_FEATURE_CQM_MBM_LOCAL are not supported then mon_data files of these
>>>> events are not created.
>>>
>>> By "right now" I assume you mean the current implementation? I think your statement
>>> assumes that no CPUs come or go after resctrl_mon_resource_init() enables the MBM events?
>>> Current implementation will enable MBM events if ABMC is supported. When the
>>> first CPU of a domain comes online after that then resctrl will create the mon_data
>>> files. These files will remain if a user then switches to default mode and if
>>> the user then attempts to read one of these counters then I expect problems.
>>
>> Yes. It will be a problem in the that case.
> 
> Thinking about this more the issue is not about the mon_data files being created since
> they are only created if resctrl is mounted and resctrl_mon_resource_init() is run
> before creating the mountpoint. From what I can tell current MBM events supported by
> ABMC will be enabled at the time resctrl can be mounted so if X86_FEATURE_CQM_MBM_TOTAL
> and X86_FEATURE_CQM_MBM_LOCAL are not supported but ABMC is then I believe the
> mon_data files will be created.
> 
> There is a problem with the actual domain creation during resctrl initialization
> where the MBM state data structures are created and depend on the events being
> enabled then.
> resctrl assumes that if an event is enabled then that event's associated
> rdt_mon_domain::mbm_states and rdt_hw_mon_domain::arch_mbm_states exist and if
> those data structures are created (or not created) during CPU online and MBM
> event comes online later then there will be invalid memory accesses.
> 
> The conclusion is the same though ... the events need to be initialized during
> resctrl initialization as you note above.
> 
>>
>> I am not clear on using config option you mentioned above.
> 
> This is more about what is accomplished by the config option than whether it is
> a config option that controls the flow. More below but I believe there may be
> scenarios where only mbm_event is supported and in that case I expect, even on AMD,
> it may be possible that there is no supported "default" mode and thus:
>  # cat /sys/fs/resctrl/info/L3_MON/mbm_assign_mode                             
>   [mbm_event]
> 
>>
>> What about using the check resctrl_is_mon_event_enabled() in
>>
>> resctrl_mbm_assign_mode_show() and resctrl_mbm_assign_mode_write() ?
>>
> 
> Trying to think through how to support a system that can switch between default
> and mbm_event mode I see a couple of things to consider. This is as I am thinking
> through the flows without able to experiment. I think it may help if you could sanity
> check this with perhaps a few experiments to considering the flows yourself to see where
> I am missing things.
> 
> When we are clear on the flows to support and how to interact with user space it will
> be easier to start exchanging code.
> 
> a) MBM state data structures
>    As mentioned above, rdt_mon_domain::mbm_states and rdt_hw_mon_domain::arch_mbm_states
>    are created during CPU online based on MBM event enabled state. During runtime
>    an enabled MBM event is assumed to have state.
>    To me this implies that any possible MBM event should be enabled during early
>    initialization.
>    A consequence is that any possible MBM event will have its associated event file
>    created even if the active mode of the time cannot support it. (I do not think
>    we want to have event files come and go).
> b) Switching between modes.
>    From what I can tell switching mode is always allowed as long as system supports
>    assignable counters and that may not be correct. Consider a system that supports
>    ABMC but does not support X86_FEATURE_CQM_MBM_TOTAL and/or X86_FEATURE_CQM_MBM_LOCAL ...
>    should it be allowed to switch to "default" mode? At this time I believe this is allowed
>    yet this is an unusable state (as far as MBM goes) and I expect any attempt at reading
>    an event file will result in invalid MSR access?
>    Complexity increases if there is a mismatch in supported events, for example if mbm_event
>    mode supports total and local but default mode only supports one. Should it be allowed
>    to switch modes? If so, user can then still read from both files, the check whether assignable
>    counters is enabled will fail and resctrl will attempt to read both via the counter MSRs,
>    even an unsupported event (continued below).
> c) Read of event file
>    A user can read from event file any time even if active mode (default or mbm_event) does
>    not support it. If mbm_event mode is enabled then resctrl will attempt to use counters,
>    if default mode is enabled then resctrl will attempt to use MSRs.
>    This currently entirely depends on whether mbm_event mode is enabled or not.
>    Perhaps we should add checks here to prevent user from reading an event if the
>    active mode does not support it? Alternatively prevent user from switching to a mode
>    that cannot be supported.
> 
> Look forward to how you view things and thoughts on how user may expect to interact with these
> features.

I am concerned about this issue. The original changelog only mentions that events are enabled when
they should not be but it looks to me that there is a more serious issue if the user then attempts
to read from such an event. Have you tried the scenario when a user boots with the parameters
mentioned in changelog (rdt=!mbmtotal,!mbmlocal) and then attempts to read one of these events?
Reading from the event will attempt to access its architectural state but from what I can tell
that will not be allocated since the events are not enabled at the time of the allocation.

This needs to be fixed during this cycle. A week has passed since my previous message so I do not
think that it will be possible to create a full featured solution that keeps X86_FEATURE_ABMC
and X86_FEATURE_CQM_MBM_TOTAL/X86_FEATURE_CQM_MBM_LOCAL independent.

What do you think of something like below that builds on your original change and additionally
enforces dependency between these features to support the resctrl assumptions? From what I understand
this is ok for current AMD hardware? A not-as-urgent follow-up can make these features independent
again?


diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
index c8945610d455..fd42fe7b2fdc 100644
--- a/arch/x86/kernel/cpu/resctrl/monitor.c
+++ b/arch/x86/kernel/cpu/resctrl/monitor.c
@@ -452,7 +452,16 @@ int __init rdt_get_mon_l3_config(struct rdt_resource *r)
 		r->mon.mbm_cfg_mask = ecx & MAX_EVT_CONFIG_BITS;
 	}
 
-	if (rdt_cpu_has(X86_FEATURE_ABMC)) {
+	/*
+	 * resctrl assumes a system that supports assignable counters can
+	 * switch to "default" mode. Ensure that there is a "default" mode
+	 * to switch to. This enforces a dependency between the independent
+	 * X86_FEATURE_ABMC and X86_FEATURE_CQM_MBM_TOTAL/X86_FEATURE_CQM_MBM_LOCAL
+	 * hardware features.
+	 */
+	if (rdt_cpu_has(X86_FEATURE_ABMC) &&
+	    (rdt_cpu_has(X86_FEATURE_CQM_MBM_TOTAL) ||
+	     rdt_cpu_has(X86_FEATURE_CQM_MBM_LOCAL))) {
 		r->mon.mbm_cntr_assignable = true;
 		cpuid_count(0x80000020, 5, &eax, &ebx, &ecx, &edx);
 		r->mon.num_mbm_cntrs = (ebx & GENMASK(15, 0)) + 1;
diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
index 4076336fbba6..572a9925bd6c 100644
--- a/fs/resctrl/monitor.c
+++ b/fs/resctrl/monitor.c
@@ -1782,15 +1782,13 @@ int resctrl_mon_resource_init(void)
 		mba_mbps_default_event = QOS_L3_MBM_TOTAL_EVENT_ID;
 
 	if (r->mon.mbm_cntr_assignable) {
-		if (!resctrl_is_mon_event_enabled(QOS_L3_MBM_TOTAL_EVENT_ID))
-			resctrl_enable_mon_event(QOS_L3_MBM_TOTAL_EVENT_ID);
-		if (!resctrl_is_mon_event_enabled(QOS_L3_MBM_LOCAL_EVENT_ID))
-			resctrl_enable_mon_event(QOS_L3_MBM_LOCAL_EVENT_ID);
-		mon_event_all[QOS_L3_MBM_TOTAL_EVENT_ID].evt_cfg = r->mon.mbm_cfg_mask;
-		mon_event_all[QOS_L3_MBM_LOCAL_EVENT_ID].evt_cfg = r->mon.mbm_cfg_mask &
-								   (READS_TO_LOCAL_MEM |
-								    READS_TO_LOCAL_S_MEM |
-								    NON_TEMP_WRITE_TO_LOCAL_MEM);
+		if (resctrl_is_mon_event_enabled(QOS_L3_MBM_TOTAL_EVENT_ID))
+			mon_event_all[QOS_L3_MBM_TOTAL_EVENT_ID].evt_cfg = r->mon.mbm_cfg_mask;
+		if (resctrl_is_mon_event_enabled(QOS_L3_MBM_LOCAL_EVENT_ID))
+			mon_event_all[QOS_L3_MBM_LOCAL_EVENT_ID].evt_cfg = r->mon.mbm_cfg_mask &
+									   (READS_TO_LOCAL_MEM |
+									    READS_TO_LOCAL_S_MEM |
+									    NON_TEMP_WRITE_TO_LOCAL_MEM);
 		r->mon.mbm_assign_on_mkdir = true;
 		resctrl_file_fflags_init("num_mbm_cntrs",
 					 RFTYPE_MON_INFO | RFTYPE_RES_CACHE);








