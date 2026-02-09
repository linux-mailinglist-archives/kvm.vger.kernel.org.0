Return-Path: <kvm+bounces-70594-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OL/RDvu5iWlmBQUAu9opvQ
	(envelope-from <kvm+bounces-70594-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 11:42:03 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id C397710E389
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 11:42:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 86F393016D1E
	for <lists+kvm@lfdr.de>; Mon,  9 Feb 2026 10:42:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F38E5368278;
	Mon,  9 Feb 2026 10:41:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eSrRQoyz"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54B8F3644D7;
	Mon,  9 Feb 2026 10:41:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770633719; cv=fail; b=Uxe0vRHqKhURLipCayS31kQwIch2DqMny+mqLiMvdF61dXFJ8zzZbFsQcuk6GE3fj9VjXS3VHEY3h2ZzuOlJ+XnkyZwT8u8wkSpp4sAYEViMn3U/BmJHHtiQOrvCHhx7lWYDom/MPQalMCnmhA2sko+4zdC2wuBGWsx887ZPPdQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770633719; c=relaxed/simple;
	bh=BcmXnLA1Ezfda+EnN6moxNpNShFTZDR+aAy7Z6BK3Lw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=eAJgJrRNgykG4roJOQAUEDFI9sGwqX/GddNgbdcmknj1ZXpC0cuoudqTduEj+m4yI9t3265q0FhFMkXMyeKfLhmm8vQNQa2Vo6S16u+NpkNcOtSSsqXrYyJdjYuMUvRdsEkkJ4FNTVxI6GmeDmLhdyFzyyyTbCG79OrEexz9lEc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eSrRQoyz; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770633718; x=1802169718;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=BcmXnLA1Ezfda+EnN6moxNpNShFTZDR+aAy7Z6BK3Lw=;
  b=eSrRQoyzxcC2Z48/NYSPPJQrOswlGumTgAc+8RjiBxDw7CObRD5PCAx4
   aZ1ljWGCiGogLrU+yXF3SCzuxcpoWjtOXITufHZWSCdvWWEAYFUFwDLa8
   8GpSXpz2zehaeFBsHiA+epdEUBngEspuaXcLghU0mTluEvCFPrPTOXLal
   epsZfnug4r965AFsIWeU/M5T6JDt5CrZDdUlvDOXD4aqzKA0UD7TSUfMZ
   DChldkcFMb7NpPG5VlNpHG2Vsqu0xxXbtXnv7B2bWXK9HTMr0ld4GeFBu
   koflbdvMen3lw9gDYRLvopkTeiJiDmFVJss2Uil6c7faFJdGwvo8C8Vn+
   g==;
X-CSE-ConnectionGUID: 60+VtieJSTq2EDJMSCxhJA==
X-CSE-MsgGUID: ++8whICQSzChAg+iZOcVow==
X-IronPort-AV: E=McAfee;i="6800,10657,11695"; a="71634735"
X-IronPort-AV: E=Sophos;i="6.21,282,1763452800"; 
   d="scan'208";a="71634735"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2026 02:41:57 -0800
X-CSE-ConnectionGUID: pGZ63+8gRa+ydHxfEenJ7w==
X-CSE-MsgGUID: WuErf9B5QFGtSbatDtVXUg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,282,1763452800"; 
   d="scan'208";a="215722320"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2026 02:41:57 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Mon, 9 Feb 2026 02:41:57 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Mon, 9 Feb 2026 02:41:57 -0800
Received: from BN1PR04CU002.outbound.protection.outlook.com (52.101.56.43) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Mon, 9 Feb 2026 02:41:56 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=j2yppj+lK0CaxSt/Pj/aQhO1xi2snHZfyAFwAZWxu8h0LZ8bI35fdmR2cApKPs3gPPZ2f2kXPXmyKkjzmEStJwfsQGuy1YbAAmJUm+1tvgyNuO4R6c2oM22iQNd5uCf048SV2QW5vSkzfiRTqsENM/llBUGChE3vIp1FRBTCRNGBeczWdyTaEnFQF6lLQ+NwXPH7lUBcB17m/rP9RnA7Ex0WY0huEXRTfHuhSRticjmBu74TA+YB5zvrQcET6/LHpYJD5rWfeQzMQQHZaxpTsYnvjYMYoMAy+fj0VZBuGMdD8CKkJBjqCeRZltUfugRB1wN/7CbZqS6jMyFh0AnUAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BcmXnLA1Ezfda+EnN6moxNpNShFTZDR+aAy7Z6BK3Lw=;
 b=vJtPvhLnksUbZAuegdgr67/Bz46mjzRd7evSv7SuIyvOz1zPOvyjSuBvJA2T7/X9tyfhO72YHelye1p1coM5ro9V3h3xo/6dlcnkvSw/hLFyRGhNYte/lLGImPCI3V/V5CaphlUrV5kmztZfhQTCmUNYWxIlJt2D/dNwYQ0cvp88Z8F4JEDjpTaQpkmOezgZZB9eic2P6RDO9haAtz7BX27t3itIB0hsV+ihnM22/LyWrYx9PlTfXkMhihviREor5kH9T7+mI53PraxFjsw7+rpD/W85WZa7tEUCpuhPIKWDW4pURIy+NL/QNKoZKkYXC+n0CsyBflvZAnNnqun2VA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN7PR11MB2673.namprd11.prod.outlook.com (2603:10b6:406:b7::13)
 by PH0PR11MB5829.namprd11.prod.outlook.com (2603:10b6:510:140::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.18; Mon, 9 Feb
 2026 10:41:53 +0000
Received: from BN7PR11MB2673.namprd11.prod.outlook.com
 ([fe80::9543:510b:f117:24d7]) by BN7PR11MB2673.namprd11.prod.outlook.com
 ([fe80::9543:510b:f117:24d7%4]) with mapi id 15.20.9587.017; Mon, 9 Feb 2026
 10:41:52 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "seanjc@google.com" <seanjc@google.com>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "Li, Xiaoyao" <xiaoyao.li@intel.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "kas@kernel.org"
	<kas@kernel.org>, "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
	"mingo@redhat.com" <mingo@redhat.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "ackerleytng@google.com" <ackerleytng@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Yamahata,
 Isaku" <isaku.yamahata@intel.com>, "sagis@google.com" <sagis@google.com>,
	"tglx@kernel.org" <tglx@kernel.org>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "bp@alien8.de" <bp@alien8.de>, "Annapurve,
 Vishal" <vannapurve@google.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH v5 20/45] KVM: x86/mmu: Allocate/free S-EPT pages
 using tdx_{alloc,free}_control_page()
Thread-Topic: [RFC PATCH v5 20/45] KVM: x86/mmu: Allocate/free S-EPT pages
 using tdx_{alloc,free}_control_page()
Thread-Index: AQHckLzhSspC1sJAD0G07NT4Ge5PXLV1eiWAgABXQQCABG6CAA==
Date: Mon, 9 Feb 2026 10:41:52 +0000
Message-ID: <c753636171f82c3b6d64e7734be3a70c60775546.camel@intel.com>
References: <20260129011517.3545883-1-seanjc@google.com>
	 <20260129011517.3545883-21-seanjc@google.com>
	 <aYW5CbUvZrLogsWF@yzhao56-desk.sh.intel.com> <aYYCOiMvWfSJR1AL@google.com>
In-Reply-To: <aYYCOiMvWfSJR1AL@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN7PR11MB2673:EE_|PH0PR11MB5829:EE_
x-ms-office365-filtering-correlation-id: e3ca7971-7fd1-44fa-5f30-08de67c7d67c
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?VUwvNjFtczJSOEYvTi96SUwzYitMMjFxVVlNdlZUdTRZVVk2NG4wYVR6R3BK?=
 =?utf-8?B?MDZkMjdTekw3UDdSME9oVHFGRlFxSThhTjVNZVc5MkxhaTdDRkJLajdldlYw?=
 =?utf-8?B?alcwdXZqVGlXTUludlVTdDVyMFZDdE53VFRWc2lqLy9UMXpuS2oyWGV6blRU?=
 =?utf-8?B?VXhXc0lzazZkWXl1dHZhcENJaVFGVzZhMFBibUhDUGZpdzJwSno0Tll1SFBa?=
 =?utf-8?B?Vm9IMlAvcERTT3hkMWVBdkhma3NBQTRZMHF1TSt3bE5VQm4wcWRZT2wwRlgr?=
 =?utf-8?B?ZXN4Z1ZSZ1BDWEh1c1FMeFdPQzhhbjFzOTRpbkdiRFhidVllWFljQ3h6eWUw?=
 =?utf-8?B?K0FsSDZpM0JnU0ljSlo3amdlTGhkaXBLN3lhM0tvTkZYMTJEVEJacGVmWnh3?=
 =?utf-8?B?MlFhWE9LUGxIdlVaUk1jU2k3QzZmalFPeDFENW95WHI1NCtSdGdXZ2l6ODBU?=
 =?utf-8?B?TFRNWTc1dE5BYStyY0FlSmQ4cHIvcDRCcHZYbDV0NzlsTzBCNy91ZGhnZmxM?=
 =?utf-8?B?NnBFT292TDByNzludW50eVF2OGk2NklGZDQ0cThNUnVDRWxnNjRaN04xRkVT?=
 =?utf-8?B?RkJFL0kycTZ5UFVGZjZzVFFlcXdIZTV5enlWUmc1NzlSaGk1emJkSHZGbCsv?=
 =?utf-8?B?WEFkYWd5Q1M2QjlTRXhuTTF5OGpRV1E5anFCV2czODFGT252SDQrdDJpM05h?=
 =?utf-8?B?RGlBeVFkNUhZaUR2cmpkRHovZnhYSDBNdmp4NXBtT1A0OWNRVnlaZGUyamhs?=
 =?utf-8?B?anpZNHhnTThObnlCb0E3cmtjWDBISk5IaW1ZZVp1ZTBtczlIcUc3RkE3SnJ2?=
 =?utf-8?B?RXBMZ0tORk1ZRjMrbTFna1FQcTR6MmhEU0xucTdpSHYvcEUzdWZob0RmRlgw?=
 =?utf-8?B?UHdyTWZtSjY4RUk3aC91aXZrM0U4MVRVS3V1cjUzaXZzRldETk1TQ3h3a3R5?=
 =?utf-8?B?b3FFK0F2VlFIV0JkdCs4STJWeWZzL20yckRJTzUxaDR2N1ZOeUlPSnpNeG10?=
 =?utf-8?B?RW9RNFNuS2lTdXZlNkx5YlBrM3BiY2NKa3hCdWh5WjV1YlRJNkRpay9wSTFS?=
 =?utf-8?B?OG5jRGhXSUVYWWJndWZEZGtOTUdmMTNpTmhPbUdBNkRMUFFTTi9ia1hGUC81?=
 =?utf-8?B?SGUzd0VMYVlXSFduU3NsbXZ6R2xMNmlyaUhoNkRQcXVLT1FxblRKVXZTT0ZB?=
 =?utf-8?B?OGdKcHdoMDVGS0xCOFoyZG5qMFNzeHlKV050dmtmMXg1MEV2am9GWWhMWE9J?=
 =?utf-8?B?ZXhQUGJobmRXWmk5dmJrbjVPRjhrRExqNTFJN01UUHkwNElyTWRzYWhQSmNP?=
 =?utf-8?B?cy9vODRMYUF6bDZBWE1nSW1YcXFLREVvQ3RQaVN1eEFJc3hEQkhPRjI4OUs2?=
 =?utf-8?B?NXh1a1gvZmgrcjBWUDhXQ0pTN1N3OEdyeEszY011Y0JPNG5icEtaUzFJSGI3?=
 =?utf-8?B?akdPNVdpb0FzdGxWdzNGNGZNa1pna29EZEltMHRZWFUwNEFEaFNpbkhYSWhl?=
 =?utf-8?B?WEJadEo4dnU1YWZjYkFsT1hNR0dwZHZLWlFaZjg0SVVoN0Nwb1NTS1dTZ2dk?=
 =?utf-8?B?NW1CeWd3b2syMzlhQWx0UHV0R0ZEUzRiZFBadU5vdHBGMnFCUEtjdGdVK25R?=
 =?utf-8?B?SUFMbXBRZE1IZjFVSE5pZ0NOby9QQWNDNGo5d0YrQ3BpY29QWERtakkyZEsx?=
 =?utf-8?B?aEJGbTZlZi9xSE1KR1loaEVoNGd2eWRJcGovMklBYXltT3FSTWdvMDNhMno5?=
 =?utf-8?B?eWE3bUR1MUtOK3dxaENmbVVlVXB5Z0lGR0drbkhOT2pwMUphV2xqcFdzSXUr?=
 =?utf-8?B?TmU3OHgvNVpSRTlpR1FkNUhmdVcycHovelpPcXluRnVyb3VyQXFLQVM1eHNz?=
 =?utf-8?B?Q3VOYUNxYndRMDRVdG0xS3lsOVdJaFI5eHp0RTN4T0ZaSGVISVpzSVlGTEZN?=
 =?utf-8?B?Yk8rc0w3R3RlZkUwRHBwNDRTTlBlY24rdDVGcDJZOStQRm82QTlLdDBUdkNy?=
 =?utf-8?B?alBhWkdOdGVCZGc4OWJVa1V3THdnVndWNGZrMFlJOWI0bHlWMHFvejc5WGg0?=
 =?utf-8?B?N29xS0tiZEpBdy9CUDNaaTdRN0Vod3RrcTlvaG9qdWJ4Z0RNZk4vT3EyTkFR?=
 =?utf-8?B?eUswSENJSi9YamJqK3V5UVk1Y1hqU2Jrbnl0RXcxZHFaYm5Jb0ZZSERyRk9J?=
 =?utf-8?Q?wqW3qmMUnPXLfzgp0LD8m9c=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN7PR11MB2673.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bms4MzRJMkI1Ry9YZlB1dDNSY09QbWpCK0UxeGltOHNnSU9yaGxzUXhWZDBy?=
 =?utf-8?B?NnFreTZ0VnROVkpyRHhyS01HTnZoaWtUcHc3MVVhNlhVMmY1KzhTUVFFVkhY?=
 =?utf-8?B?UFJlc0RIMWEyWXo5Y0NqY2M1MEtZTzZWS05NVFdEVmR1aTBHMllXOGxEWDdY?=
 =?utf-8?B?dmw2UUVLelphN0NOWHcyZCt1bWZiUXBDUE9ja3dYS3BtTzVMcFhGYmlIUFJK?=
 =?utf-8?B?Vm1RdEcxN0hWdEduU3d1WHVQemZldkxyTlA2Z3p0VE5PcWVsZDdhTG9CQlcw?=
 =?utf-8?B?RUZJZnpLazIrVVdZdDhpREFXekE5T3Izb0ZvaDBoY0pualpTMGNnanRZam5J?=
 =?utf-8?B?dURneEU5ZnZOaHJYd1BydHovcTdXZkpvQ0FoQ2poTTdNQ1dPTldIN0E3N2xr?=
 =?utf-8?B?NzIyOHdYQWxFY1N6aWVvcnpaTXdib1dKWkRsRm9FWTJHMURMbGExek5tbERM?=
 =?utf-8?B?Wk1MMkJCTHphc1U3Q0ZTOEQ2RG85REFyYkd2c0tJVXdyOS8ySHVXNmMzOG56?=
 =?utf-8?B?V2krblRTRDlUTVVVUnhKQ1RiYXR6dmRxa1FMWFB6M1lub0ZraXM1UHRZZW9x?=
 =?utf-8?B?eDdJZWNTVEJaQU1rS2tyemdXRTBPalEyaWRoeEt3cjdpd1Rwb3FldFZTOVZu?=
 =?utf-8?B?UmtiZldROUJTYVFGZ2ZzRTBFcGFKOTJkZ1FvUHRNVFJKcmYwMVdyaXhDS1Qw?=
 =?utf-8?B?TldYY0ZMcHNSMVgxejlNQmYxamFldnBzMVJKTlBXY1pCQ2pQL3VxWGdMdmlU?=
 =?utf-8?B?V3U4a2R1MHFrRnpUU1oxMUY0SDN3M05Hb0F1U1F4bFhSVkVlN0YxcGw4bXRK?=
 =?utf-8?B?M2xpV2Zla00zV3hQUnRZY01xU0pCMmowWDlNZGJUWE9Ud0t3Q3pZV3lFSG9G?=
 =?utf-8?B?ODFxOXF2V2E5MElCNHVMSmFQbzJ6VjZrSnVoSU5tdG5QV21zdkZLM0pPRHlp?=
 =?utf-8?B?T0M0Y1NVR2thOFNMQ3FpVk9nNXY3bnhqY0ZhcUZxZzNmV1pKcmQvaDl4MmFh?=
 =?utf-8?B?UGVuY1JFV1g0cFJ3V1NGN1ZVbG8zc1dmbkpvazBoSTMrOGQ1Uk5GOUFpVVZQ?=
 =?utf-8?B?RmczcEtmZVlXNHhSZXlyU1JXM2dUWDdtOGhkeXVmZEM0Z1R1UUpRbXB2ckMr?=
 =?utf-8?B?VTl1Smo2QkFHWWVkYkw0SnZnNWpLZ3I3ZjJwUTZvQm4xVlFVdFd1aFd5T25Y?=
 =?utf-8?B?ei9ZbWphQnBwSFJ3cVl6LytURmRSSWlJSFJVakt0OEpaMWkrd0xjQjhINysz?=
 =?utf-8?B?YzE3ZnFaSTFMMlhLSWlrN09EN0dsZjg1eGZoeVdqQ2dSd2FRRy8rNDI0NTVx?=
 =?utf-8?B?UXY3RTVJYWRKWWhJT0ZLU3RraXBZZ21SenFMakVQeG1Bc3Z3NU5uR1I1Ulhz?=
 =?utf-8?B?dDBHWm95YzJudnJVUGZEYysrTk4rTnYrVXZZMURvdC90WWkrWXprc2JiMjVK?=
 =?utf-8?B?UWtuNFdMUU5UY2kxYkRFMUwyMVErby9nUlhoZllwa05JbzV2VjZuaHorSGVp?=
 =?utf-8?B?MVlROWxKR0xhK2E1VE1HbWN1cGpON2k4STJvZTdzZW5nckR6OEY4NTN2aFh3?=
 =?utf-8?B?d3VRS2k5RnJtd3d4R05XTlM5aFZ6eEJFVnBYK2ZYbnBoa3lQUDNJRWx3MkNm?=
 =?utf-8?B?Wm4zRFd0aHFiVVAvZmI4cThRdFk3MUdKd0psQmtFbWMveG43b2sweW1jaDg2?=
 =?utf-8?B?OHhlNTVJOUt2ZDVTTjNLdUliY1kyZjVyTWF5MTlQWERUaWFlSS91RlRCVm95?=
 =?utf-8?B?QnBNWHNqN2R0SGVscXNsK0JKRzhxcnBJaERSVENCYWlJUFZsR3FWTzFzelZ2?=
 =?utf-8?B?NE8zUWZCNzhEUWljN0xLWnlJQk93Uk9JaWxuQmxSV0JrTER2bUlyTGFWa2Fa?=
 =?utf-8?B?ajJYZlVPcml5ZDlzZFBMcXV0bFJjRGhHVEc0YmZpSzloRm0zdWhnYnVkTXFK?=
 =?utf-8?B?ZXQxQnNiM1RkSG8xSHdFSCs4RHlGRC9lbkFjQkJnaHJIaHRIMTNuR1RIendB?=
 =?utf-8?B?SXFkcXVwTEQxOWViMFUzM2F3dWduYTZjRVErelM3ZlJvc2hFbG96Q3BzWGJN?=
 =?utf-8?B?WHkyTlpibXptSlpYcHRiWjRFejlqOC9tV2Rlb2VGYzhzakRIRkhGcFRsN0tx?=
 =?utf-8?B?L1hQZ0htZ0dURXJJWjdMRFBabmNlY1FiMzJ0SHZPUGxXY1VTb0NEVVZ5S3h0?=
 =?utf-8?B?WmZndkh1N1VCZG41VUJUcEc1dUc1eFh4UDRIazhScHF0ZE1GL01sOXpBaExK?=
 =?utf-8?B?dWd3ekJSS2FRZURBNFpkTGEyaXhrTHZtMllGOHZnbUUwU1JqTmJKcHQ1RlVz?=
 =?utf-8?B?LzhkeDZMVWQwdk5OQW0xRUJyb0MvZi9XUEw0ZkIvc09PWFJJMysrdz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C7FBF2029BF12C4CB0E54D908893745D@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN7PR11MB2673.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e3ca7971-7fd1-44fa-5f30-08de67c7d67c
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2026 10:41:52.7184
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ds9T52mnQyu9ffvGxaVDvTibVxg2M72zUO6c2c5V6llmXk2jTjifl5M7Ler7A/DGL8JXS6Arc/S3ZmJvBKNZ1Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5829
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.94 / 15.00];
	MIME_BASE64_TEXT_BOGUS(1.00)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	MIME_BASE64_TEXT(0.10)[];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70594-lists,kvm=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[19];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,intel.com:mid,intel.com:dkim];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kai.huang@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: C397710E389
X-Rspamd-Action: no action

DQo+IA0KPiBPcHRpb24gIzIgd291bGQgYmUgdG8gaW1tZWRpYXRlbHkgZnJlZSB0aGUgcGFnZSBp
biB0ZHhfc2VwdF9yZWNsYWltX3ByaXZhdGVfc3AoKSwNCj4gc28gdGhhdCBwYWdlcyB0aGF0IGZy
ZWVkIHZpYSBoYW5kbGVfcmVtb3ZlZF9wdCgpIGRvbid0IGRlZmVyIGZyZWVpbmcgdGhlIFMtRVBU
DQo+IHBhZ2UgdGFibGUgKHdoaWNoLCBJSVVDLCBpcyBzYWZlIHNpbmNlIHRoZSBURFgtTW9kdWxl
IGZvcmNlcyBUTEIgZmx1c2hlcyBhbmQgZXhpdHMpLg0KPiANCj4gSSByZWFsbHksIHJlYWxseSBk
b24ndCBsaWtlIHRoaXMgb3B0aW9uIChpZiBpdCBldmVuIHdvcmtzKS4NCj4gDQo+IGRpZmYgLS1n
aXQgYS9hcmNoL3g4Ni9rdm0vdm14L3RkeC5jIGIvYXJjaC94ODYva3ZtL3ZteC90ZHguYw0KPiBp
bmRleCBhZTdiOWJlYjMyNDkuLjQ3MjYwMTFhZDYyNCAxMDA2NDQNCj4gLS0tIGEvYXJjaC94ODYv
a3ZtL3ZteC90ZHguYw0KPiArKysgYi9hcmNoL3g4Ni9rdm0vdm14L3RkeC5jDQo+IEBAIC0yMDE0
LDcgKzIwMTQsMTUgQEAgc3RhdGljIHZvaWQgdGR4X3NlcHRfcmVjbGFpbV9wcml2YXRlX3NwKHN0
cnVjdCBrdm0gKmt2bSwgZ2ZuX3QgZ2ZuLA0KPiAgICAgICAgICAqLw0KPiAgICAgICAgIGlmIChL
Vk1fQlVHX09OKGlzX2hraWRfYXNzaWduZWQodG9fa3ZtX3RkeChrdm0pKSwga3ZtKSB8fA0KPiAg
ICAgICAgICAgICB0ZHhfcmVjbGFpbV9wYWdlKHZpcnRfdG9fcGFnZShzcC0+ZXh0ZXJuYWxfc3B0
KSkpDQo+IC0gICAgICAgICAgICAgICBzcC0+ZXh0ZXJuYWxfc3B0ID0gTlVMTDsNCj4gKyAgICAg
ICAgICAgICAgIGdvdG8gb3V0Ow0KPiArDQo+ICsgICAgICAgLyoNCj4gKyAgICAgICAgKiBJbW1l
ZGlhdGVseSBmcmVlIHRoZSBjb250cm9sIHBhZ2UsIGFzIHRoZSBURFggc3Vic3lzdGVtIGRvZXNu
J3QNCj4gKyAgICAgICAgKiBzdXBwb3J0IGZyZWVpbmcgcGFnZXMgZnJvbSBSQ1UgY2FsbGJhY2tz
Lg0KPiArICAgICAgICAqLw0KPiArICAgICAgIHRkeF9mcmVlX2NvbnRyb2xfcGFnZSgodW5zaWdu
ZWQgbG9uZylzcC0+ZXh0ZXJuYWxfc3B0KTsNCj4gK291dDoNCj4gKyAgICAgICBzcC0+ZXh0ZXJu
YWxfc3B0ID0gTlVMTDsNCj4gIH0NCj4gIA0KPiAgdm9pZCB0ZHhfZGVsaXZlcl9pbnRlcnJ1cHQo
c3RydWN0IGt2bV9sYXBpYyAqYXBpYywgaW50IGRlbGl2ZXJ5X21vZGUsDQoNCkkgZG9uJ3QgdGhp
bmsgdGhpcyBpcyBzbyBiYWQsIGdpdmVuIHdlIGFscmVhZHkgaGF2ZSBhIGJ1bmNoIG9mDQoNCglp
c19taXJyb3Jfc3Aoc3ApDQoJCWt2bV94ODZfY2FsbCh4eF9leHRlcm5hbF9zcHQpKC4uKTsNCg0K
aW4gVERQIE1NVSBjb2RlPw0KDQpJIHN1cHBvc2UgdGhpcyB3b24ndCBtYWtlIGEgbG90IG9mIGRp
ZmZlcmVuY2UsIGJ1dCBkb2VzIGJlbG93IG1ha2UgeW91DQpzbGlnaHRseSBoYXBwaWVyPw0KDQpk
aWZmIC0tZ2l0IGEvYXJjaC94ODYva3ZtL21tdS90ZHBfbW11LmMgYi9hcmNoL3g4Ni9rdm0vbW11
L3RkcF9tbXUuYw0KaW5kZXggMzE4MTQwNmM1ZTBiLi4zNTg4MjY1MDk4YTggMTAwNjQ0DQotLS0g
YS9hcmNoL3g4Ni9rdm0vbW11L3RkcF9tbXUuYw0KKysrIGIvYXJjaC94ODYva3ZtL21tdS90ZHBf
bW11LmMNCkBAIC01NSw4ICs1NSw3IEBAIHZvaWQga3ZtX21tdV91bmluaXRfdGRwX21tdShzdHJ1
Y3Qga3ZtICprdm0pDQogDQogc3RhdGljIHZvaWQgdGRwX21tdV9mcmVlX3NwKHN0cnVjdCBrdm1f
bW11X3BhZ2UgKnNwKQ0KIHsNCi0gICAgICAgaWYgKHNwLT5leHRlcm5hbF9zcHQpDQotICAgICAg
ICAgICAgICAga3ZtX3g4Nl9jYWxsKGZyZWVfZXh0ZXJuYWxfc3ApKCh1bnNpZ25lZCBsb25nKXNw
LQ0KPmV4dGVybmFsX3NwdCk7DQorICAgICAgIFdBUk5fT05fT05DRShzcC0+ZXh0ZXJuYWxfc3B0
KTsNCiAgICAgICAgZnJlZV9wYWdlKCh1bnNpZ25lZCBsb25nKXNwLT5zcHQpOw0KICAgICAgICBr
bWVtX2NhY2hlX2ZyZWUobW11X3BhZ2VfaGVhZGVyX2NhY2hlLCBzcCk7DQogfQ0KQEAgLTQ1Nyw4
ICs0NTYsMTcgQEAgc3RhdGljIHZvaWQgaGFuZGxlX3JlbW92ZWRfcHQoc3RydWN0IGt2bSAqa3Zt
LA0KdGRwX3B0ZXBfdCBwdCwgYm9vbCBzaGFyZWQpDQogICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICBvbGRfc3B0ZSwgRlJPWkVOX1NQVEUsIGxldmVsLCBzaGFyZWQpOw0KICAgICAg
ICB9DQogDQotICAgICAgIGlmIChpc19taXJyb3Jfc3Aoc3ApKQ0KKyAgICAgICBpZiAoaXNfbWly
cm9yX3NwKHNwKSkgew0KICAgICAgICAgICAgICAgIGt2bV94ODZfY2FsbChyZWNsYWltX2V4dGVy
bmFsX3NwKShrdm0sIGJhc2VfZ2ZuLCBzcCk7DQorICAgICAgICAgICAgICAgLyoNCisgICAgICAg
ICAgICAgICAgKiBJbW1lZGlhdGVseSBmcmVlIHRoZSBjb250cm9sIHBhZ2UsIGFzIHRoZSBURFgg
c3Vic3lzdGVtDQpkb2Vzbid0DQorICAgICAgICAgICAgICAgICogc3VwcG9ydCBmcmVlaW5nIHBh
Z2VzIGZyb20gUkNVIGNhbGxiYWNrcy4NCisgICAgICAgICAgICAgICAgKi8NCisgICAgICAgICAg
ICAgICBpZiAoc3AtPmV4dGVybmFsX3NwdCkgew0KKyAgICAgICAgICAgICAgICAgICAgICAga3Zt
X3g4Nl9jYWxsKGZyZWVfZXh0ZXJuYWxfc3ApKCh1bnNpZ25lZCBsb25nKXNwLQ0KPmV4dGVybmFs
X3NwdCk7DQorICAgICAgICAgICAgICAgICAgICAgICBzcC0+ZXh0ZXJuYWxfc3B0ID0gTlVMTDsN
CisgICAgICAgICAgICAgICB9DQorICAgICAgIH0NCiANCiAgICAgICAgY2FsbF9yY3UoJnNwLT5y
Y3VfaGVhZCwgdGRwX21tdV9mcmVlX3NwX3JjdV9jYWxsYmFjayk7DQogfQ0KDQoNCg==

