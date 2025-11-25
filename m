Return-Path: <kvm+bounces-64573-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 34C8BC876BF
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 00:07:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C3E2A3B2437
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 23:07:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B51C42DCBEB;
	Tue, 25 Nov 2025 23:07:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="J8exMI5Y"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C097296BA2;
	Tue, 25 Nov 2025 23:07:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764112033; cv=fail; b=D2nBrwi/RbLDGjW+AS4UdjJo6Yu3zX9E9xK/0Z0EY0g13kUZmMSJ1wU4Qzecu5S4oMDUWGAqH6bKiCuC05AO1bBI3GmyQG3Cboi1AdrelKbeMayKF8OA8oQ3/hNoHhxG1xLvLt1dcbq5jVZHDNIZTRqkmyREYL/Ij/7HkvXTjLU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764112033; c=relaxed/simple;
	bh=oJoBtsSlecFwIIuOdyEZk4s7yLW7TU5LVfXNmlwOiDw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=jkZdOszok/EUfGmhPU4aJ5H0cdTmjAKh/wBPsA9IRPrPZBVjpJe2JiMvDRsGZm9o9XaeVcWNb0f4IGT4N13YoOUF1RtgpdHNMb4CS27XJ+QraeoKhlaq7NtUDXpbTiSuwp5/yUnPZIeG/7GRIbs9VUVaIo4YErYyGWW9mXr7oj0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=J8exMI5Y; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764112032; x=1795648032;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=oJoBtsSlecFwIIuOdyEZk4s7yLW7TU5LVfXNmlwOiDw=;
  b=J8exMI5YuUCXF392l/48+EgQHvPTkKukF0pN6GM7jHSMHZT9r2u1w8l8
   gdl7BH767RbKujSpY0IJmvp8aQ7VrStf+JI/Uu5qKtIr3sigyKftSO7tB
   Aa3q+diOXt+xZo13vZ0s7mDaAnNHL2tUvgcQjtjVoEh4d66hZPFvBSD1L
   utScAlLiA8TAjzawlsGnHJQlfWWv51roUr38XPgztOp1gFM9xRA/6TlSG
   tzxNxzdxVmIGvLbPQi2MdwxM3AYTjJ09L0Cq/xxXAHwNP5+v+VtuV50FE
   wD3p+/eUkujY1ZfiJcl9WinC42QDc8DYRtPZjyrsijNIVIymFMUXb5Jp4
   g==;
X-CSE-ConnectionGUID: 9hfECVAyRZKvrKIhua241w==
X-CSE-MsgGUID: rP0JFV9qQNaanfbISrwlhQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11624"; a="66221709"
X-IronPort-AV: E=Sophos;i="6.20,226,1758610800"; 
   d="scan'208";a="66221709"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2025 15:07:12 -0800
X-CSE-ConnectionGUID: s8tA14tUSPKZrrjAEL2orA==
X-CSE-MsgGUID: /qF1KvSIRqGDSjAzI6g2ng==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,226,1758610800"; 
   d="scan'208";a="191922463"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2025 15:07:11 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 25 Nov 2025 15:07:10 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Tue, 25 Nov 2025 15:07:10 -0800
Received: from SJ2PR03CU001.outbound.protection.outlook.com (52.101.43.17) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 25 Nov 2025 15:07:10 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rWGoFXKLIDlxmWfYxHK5rJjMyF/3a/Pr5SukaS1+986ktXEcS73Iz2HDZVdSMlQgYB+BzctAf+OQIxVj5OCvn644wp2Fx02UZHcWpuPC0Px3OengVtNc8j62Alp7bLjh/XVIAAfTjBrDEJWhEkwEV+i0Z6g8BPW5CAwjXDIga/xa8kwlqKL0za2QIy8AJmUlyY4tLpO2NkeWONlUhqO1LgCbIVU+QsjPkgFf5iD0U25h08OZeyPtzP1YGBEnhgqdpARs9hNyAyyflyd7R7/Z6k3WHNOVeZsNWlmNvY25134AAyHx56eSR5A+8OPtkElmXbN75M5sZAZ9baIzjk9xzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oJoBtsSlecFwIIuOdyEZk4s7yLW7TU5LVfXNmlwOiDw=;
 b=Mnhf4rR9Er38HkFGmhPEPHJ2iWNv71PY2LLpzuGxQ+rrnhCX5Qpvnf6e3mEmsHjG2lgdQOSlM5klsjOegIxDorOCMXUNgzwdvyJUQI2EZEngQdI2UZy8o677W8n2r2WRA5otGwCi0C/f1+alhlcPW04QHnxWh2he5PItLbtxlBoF46TkW7FQ5M2c80adNX4xzBn5s8VDa2eqIffEyDygUXp0fLw5vw1VfFPjYoNFWb1WIe6ctXUT2AkVhQul7MFtRXzzW0GVTclmvcZXFTGOmOmI/kTv5QSLL7kdqAciFuvVMSmZbfeBgfrwMsqaCXd4BTmIv9hwQDIGZxMydPP0XA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by SN7PR11MB6727.namprd11.prod.outlook.com (2603:10b6:806:265::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.11; Tue, 25 Nov
 2025 23:07:07 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::7181:6f6e:ae0e:3a4a]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::7181:6f6e:ae0e:3a4a%5]) with mapi id 15.20.9343.016; Tue, 25 Nov 2025
 23:07:07 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "Li, Xiaoyao" <xiaoyao.li@intel.com>, "Hansen,
 Dave" <dave.hansen@intel.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>, "Wu,
 Binbin" <binbin.wu@intel.com>, "kas@kernel.org" <kas@kernel.org>,
	"seanjc@google.com" <seanjc@google.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "Annapurve, Vishal" <vannapurve@google.com>, "Gao,
 Chao" <chao.gao@intel.com>, "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"bp@alien8.de" <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>
CC: "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>
Subject: Re: [PATCH v4 02/16] x86/tdx: Add helpers to check return status
 codes
Thread-Topic: [PATCH v4 02/16] x86/tdx: Add helpers to check return status
 codes
Thread-Index: AQHcWoEHQQezcHKYAEykK+ygupjQrLUEC2sA
Date: Tue, 25 Nov 2025 23:07:07 +0000
Message-ID: <a2ac55888596ddf081084804c0276e3686515cd4.camel@intel.com>
References: <20251121005125.417831-1-rick.p.edgecombe@intel.com>
	 <20251121005125.417831-3-rick.p.edgecombe@intel.com>
In-Reply-To: <20251121005125.417831-3-rick.p.edgecombe@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|SN7PR11MB6727:EE_
x-ms-office365-filtering-correlation-id: 5a3966e5-9c2b-403f-ab54-08de2c775af1
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016|38070700021|921020;
x-microsoft-antispam-message-info: =?utf-8?B?ekg3eURLbmZ6QWpvVE4vejJwb0wvc0l4VW8rcGhabnEzVHRtWFpXWmJKeXUv?=
 =?utf-8?B?OCtGUll3cXdoRWZqb24rVy9PRUV5N1lnV1dNTVBCZDJ3WjdyZzMvVU91QUpB?=
 =?utf-8?B?QzZzREVrQmZpS09veTc5Nm1qajZwZlo0QTV5ei83Z3l6SUNkbU8rWGdwaXZJ?=
 =?utf-8?B?S3N0OVdqc2RTMnhVVzZGU2poYTlZNFVZbE1lMUNWUFJhK2g4MFhlUFByV2Jz?=
 =?utf-8?B?bWdzQ1N4NmZsRncwTzl2SWpMczdITkxmSEMrR3dOeVZEcTgzcU80cWo3ODJH?=
 =?utf-8?B?c2ZRUE1QTGlrV20waFYvczNRWjZ6Zm04UndwbGt5aUVrcnR2U3Nwa3ZWcS9j?=
 =?utf-8?B?UGZiZGVaUlZ0cHZQVGhsN0RFUFFXZ3U5bWR5UnFzSm1sYVpGSTZYZnVtQ0F3?=
 =?utf-8?B?MUVHTVhldnZXdUNnNkp1cmhkMUtNSjlNZGhYd1JMMXM1NWRjT2JzZ2lVNitR?=
 =?utf-8?B?NmJyNHJ2MFZiYWNFRy9SQ0RnVFNWRjdzRnh6dUxWWGxsSE5HZ0k5Q1lJN1VX?=
 =?utf-8?B?VlhWbTZ5TlFKQTdMVU1wSDJ0ZVltajNwUTJwNUJ5dURLbjVUeERtUjFTQWJP?=
 =?utf-8?B?ZXBGSVNLSUEwZjlqMmM4aFRqLzNSUnVubDRpclEvc0c5VDQ5Wm9QZ1hSYTNm?=
 =?utf-8?B?NzcxSldjWWhDcHJOb2J2elJxcEwvMUFCZXkvU0Q5aVg3QVNCRTJGOGVqWnYr?=
 =?utf-8?B?OGFJOEVnVHZVTFhDSjZidTNkcm1vSEhJd2xSZjI3NCtIWVRvM2RuWU5JYWJH?=
 =?utf-8?B?U2hUWmExMU5SWVlvMGRaR2JPUm1xbHBNQWZXRGR2WjFXcllmNFljeE1CNU1j?=
 =?utf-8?B?RUM1QzNESEJpdi9IMHVWSE8wVWZQeUJ3NUJvczhGdDZVdG01UGhLaG04bytF?=
 =?utf-8?B?L0RtS2VVTWJRV0hEWi9KK3Q0aXprZkl6OHloZmgwb2lkYThyOWF5dTRMVGZX?=
 =?utf-8?B?bEc5d3F4WlJ5UThDZ1U3R3ErclhpNXZ0YUpzRXU2NUZYNXVJOGlCVkE3UHZ1?=
 =?utf-8?B?bXh3WTRQVGRIaVVPdXBmNkg2cm14NVV3ZDlTSXYrcDZKYU1DQlUzWkpiMFVK?=
 =?utf-8?B?cnhpcDFoTXNzd1lvQ1hSd3F2VGJna1hwVkNjOGtLcDNuU3dsVnVHS3BFVVR4?=
 =?utf-8?B?ZUpRbnBaUk93WDQ5Sk5zcHBqa05Sc1ZCYkxleFJENXgvNWpyZVNnR0NTRU1M?=
 =?utf-8?B?RmtyUVp2QzV2NVQzUXplZXhUbWkzcEFrcWlrUFZNa05vZGVGYWRGYnd5c1B6?=
 =?utf-8?B?ZEdzeG4yMmlxVnh1aG1qTXVxamhYajRvLzNVWjFJc0tEZjJMQTNCZDNkRHMr?=
 =?utf-8?B?STV4a3BPdFB0c2JUOEIwTHpZUVNNandHQWFONkZ2a3Z3cVk5aGFTeXVCa0FI?=
 =?utf-8?B?Z25Kc09hSGRaQUlYeStUOVNVeVNqYXA0UlhLamhHTzl6SnhDaDhKaWNNWE9a?=
 =?utf-8?B?cDNQTXdVdk9JMERGaVlMZmlsS3dRTkNyWnVSblpxNXgydGd6MzFnQXJxaHJO?=
 =?utf-8?B?d1h2a1h3YU0wQURJRTlvdWVsY1dGbC9aaVdmb2ZuY3ZXNng0K01ZMnFJS0dY?=
 =?utf-8?B?ME1LNWhROEFPR0RzQU01b3pWaXUzcmNYbEc2WkZieEhnYmlVMW1GNG8vZ1RE?=
 =?utf-8?B?ZWZsWkw3ZFM3V2toWis1aWhObWV0dWJjTnQ1RGRDT0txd0lFb0FJOVl4VFZ4?=
 =?utf-8?B?NmxJc3VjeHJ3dEptWS9BSXk5aVlGbUJDUVZXT05Wc1FUT0d4SWsvMEFXNk5X?=
 =?utf-8?B?dFZWcDY5SUhVSk9nMEl2OGc3VDUvNWxqakJaQTFteml3UFJUSFpUTEM2ekVH?=
 =?utf-8?B?SVFra3Z0UFBkbW56TmI1OFo1aXRqdEtybHJISzltY3JGT2ZNSTNNT3dhR2NY?=
 =?utf-8?B?MUFRUnNJckxTMGlPcUNUTXBFOFczWXRmUmxoQ2R2VFZqMHNqZjlZL3l5NDM3?=
 =?utf-8?B?bjR2Z3lWS2hGRmJSMlFmWXBLbWVmMDFIZ1pjS2E4dEJEQjVVMWUyOHQrRlQz?=
 =?utf-8?B?alIzN0RseVNzTENtQ1V6QUFFSmJQOVhuZTUxRnh5SDlIYnRwZndHYVBmNmMz?=
 =?utf-8?B?YW5nRDFhZXV2dXJ0dHZvR2gzSVpEd3oyZXBQUT09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(38070700021)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TkFtbHFBMU1BN0YwRk1uTXA1ZVI0ZVFuV2JYVkFqOW1NUEtNcVFZVSttMUhh?=
 =?utf-8?B?NGdRRXAzN2dnbkpScm9jVUJrNjNDN0RzLzVxdHRFWGFZM0RzeVFLVnlwUENK?=
 =?utf-8?B?SmY0dmdSYW9oNjZDb3FqcVhxQzM2QzZsSEhuenpXd3MrajJTUVBkNHI1NUJS?=
 =?utf-8?B?ZWY5M2FpdVM4b01aQzc1YWluKzk4N2FRWUdielA3dStLa3dZb0UzUVRLd3dU?=
 =?utf-8?B?bTNrandnS1RyZ0hsak9MeGgzY25XRUlZYWgrUXBDWkVPYTZ6MVBXeVkzaVl0?=
 =?utf-8?B?clg1THdpTW5pQkV1QW1FNGhKRDJVUXdJSElBZVRLT1pSUURWaFllQkluMS9j?=
 =?utf-8?B?RUMzMW91V04veUtTQ0ZKUzBpekR3MHF3SFF0VzI5Qm1rd0txU28rc3RFL0pv?=
 =?utf-8?B?SkhhTDJhNmhGWi9oWFBQQUNZZloxak5ZaHhzRkxvMFJNdFRnbjlEMjlOQ1BH?=
 =?utf-8?B?TFNwdjBpQTAyMEQyVXMxdEtyZDBhU1NWTTdPTDB4SjQvM2pmMlZGdUcwS2dM?=
 =?utf-8?B?bFJkSXlKeHpHWXJKRHhDTGhYWTFlbjVscWYwRm00dmpBWFU4YU5YZGVOVy9F?=
 =?utf-8?B?QjEyUm1CdVp0MXZMU2pBS2NNQUJpMW5hYWpqTzZwQUh5SmZkdFRxbEZhb21v?=
 =?utf-8?B?cW5XOGdrTTRud2ZMVGlIZGovQXZPOUs5cnlRQXRuWFVHYmJPVlZRS0dNSTRJ?=
 =?utf-8?B?T080SnFFMjFobHl4VTNEb2k2SVEzQUVzTkRwNnBRUFZoOWlyZjl3aURIbXhM?=
 =?utf-8?B?bzArTFJ3WENOY3B6OGlFcEsrbmJsZEhOZ1N3alNUdzFKKzhwQ00wazlhckxH?=
 =?utf-8?B?Y1ZPRWRDcEF3TzVQUFI4MDVoRDBLWHVNR0I4SjFqTWNjM2hablIrUGx5Q0I4?=
 =?utf-8?B?cEZwa1JZbGU4Mm0zbSs1c0lKOVFmOTIvTkxNN0psNEFqc0hjTFEvSzBaZ2Rt?=
 =?utf-8?B?NFBhdjExek95bHB1aDdVTG9VTUp5YWdyeXpEdDZweFZobzE1cHE4Vmt6eFFU?=
 =?utf-8?B?aTNDMjhjeTQvM1dJUjE3bEJ0bEJwdkdhbG9IZm1DWTRucjhBSkhEMkJMT0gx?=
 =?utf-8?B?aUoyemk0SEF4S3ZkKytaRmQrUHBpazRBaElUeVZhaElOcCtDUDYvV25Ca05H?=
 =?utf-8?B?bXZLYWVCK1VtemRrTGxlNkRsTFRwc3pDWXhXZ2xyZlVoZk02ZjQrUmt6Z01K?=
 =?utf-8?B?Tkx3eUx4U1NTWXl1aDBTbUprRlFucE1UMGJqTXp5c3haV2NxK1Jkamxjc2JP?=
 =?utf-8?B?SHhuV1JVSjNORWVFem12cGlkMG5rVVFtSFlTSUNLcVc2Y1lNencrVzRMY3h6?=
 =?utf-8?B?cFNPNWtvaEJWNDk0b2ZjZlV0ckxPdUIzNlI2VGFuU2hZRmlLd09OTjdEeENj?=
 =?utf-8?B?SjdNMi8rSVpnMGRRdEt1MFkyT0xEakdYTW9vTCt3OForZ0NZSE82UUVjOE4r?=
 =?utf-8?B?UVBmNW82SmQ0c1lHS2Z5a2g5cU1RSzdKbzg3b2pyNTZxU3MzS3dROFpldmNI?=
 =?utf-8?B?T1NNb2ZZblV2SUJpS2trWTYyZVRnVzh3c0tzYmRNMFc5RjFaRnBYQ254OERB?=
 =?utf-8?B?ME56K2o4Mk9MSGZmZWdtbEU1MjRnbEN1UWhJVFBLZWphd2YwL3lXTXVDTXJm?=
 =?utf-8?B?SXZKWnlLTFBGbU1tMEhRaTUrNHBFRTBaVEFVT0YzdTZtcGQ5ZUlHNVBOUnVz?=
 =?utf-8?B?SHd1dU5tNlRTU3d4aVBrdmdCYmFLVVE0RmJYWTVYdHVNT1JCbDJ5ZUNtSlNL?=
 =?utf-8?B?N0NxWll1SDMrYWszeHJDQXNFRmNUbUFTVjNXdW9xQmhsV3M1Y2xjT0p6ZFBE?=
 =?utf-8?B?alN1YnM5dVRRVEhPRG1RUXJlb2E3aExKMGQ2NnVVT0xwMWZ1Sk5zMHoxalVu?=
 =?utf-8?B?YlZ0djJNNjgyeDNkYU1EdmU4Q3JHU3d0a2VWK2l4M0x5am4yVlJCcVVzVjBm?=
 =?utf-8?B?NEpqZldTdTlJWFhpY2RRZ1g1OUxEeVMzWk5vOHE1Ukp1QnpEcFVaeVIyeFdx?=
 =?utf-8?B?Nm51S1JTVTNVcElzMHB2b2lTanpOd283N3R1aDBPSzFaanZlWE5xMzNHMlM2?=
 =?utf-8?B?NjVxQk1LMlZqa1FJNEJkYlJhUzRhcElWM0lRTTZlY1E4Z2tVaGcrS0pGamtl?=
 =?utf-8?Q?D9snoxtCUu8Da4hNiKP5z2AmN?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A72DFD5EEB916141AB5C0DAB5866BD76@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a3966e5-9c2b-403f-ab54-08de2c775af1
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Nov 2025 23:07:07.1221
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /QNBIplbOOhQy2I0uXrQlfgXvF4ekzFZBBh17lDsPXdFtBXtESsdGRmzo+Q3XMlUr7+aQXnRzlIYZ7IkNiS7Gw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6727
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTExLTIwIGF0IDE2OjUxIC0wODAwLCBSaWNrIEVkZ2Vjb21iZSB3cm90ZToN
Cj4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L2luY2x1ZGUvYXNtL3NoYXJlZC90ZHhfZXJybm8uaCBi
L2FyY2gveDg2L2luY2x1ZGUvYXNtL3NoYXJlZC90ZHhfZXJybm8uaA0KPiBpbmRleCAzYWE3NGY2
YTYxMTkuLmUzMDJhZWQzMWI1MCAxMDA2NDQNCj4gLS0tIGEvYXJjaC94ODYvaW5jbHVkZS9hc20v
c2hhcmVkL3RkeF9lcnJuby5oDQo+ICsrKyBiL2FyY2gveDg2L2luY2x1ZGUvYXNtL3NoYXJlZC90
ZHhfZXJybm8uaA0KPiBAQCAtNSw3ICs1LDcgQEANCj4gwqAjaW5jbHVkZSA8YXNtL3RyYXBuci5o
Pg0KPiDCoA0KPiDCoC8qIFVwcGVyIDMyIGJpdCBvZiB0aGUgVERYIGVycm9yIGNvZGUgZW5jb2Rl
cyB0aGUgc3RhdHVzICovDQo+IC0jZGVmaW5lIFREWF9TRUFNQ0FMTF9TVEFUVVNfTUFTSwkJMHhG
RkZGRkZGRjAwMDAwMDAwVUxMDQo+ICsjZGVmaW5lIFREWF9TVEFUVVNfTUFTSwkJCQkweEZGRkZG
RkZGMDAwMDAwMDBVTEwNCj4gwqANCj4gwqAvKg0KPiDCoCAqIFREWCBTRUFNQ0FMTCBTdGF0dXMg
Q29kZXMNCj4gQEAgLTU0LDQgKzU0LDQ5IEBADQo+IMKgI2RlZmluZSBURFhfT1BFUkFORF9JRF9T
RVBUCQkJMHg5Mg0KPiDCoCNkZWZpbmUgVERYX09QRVJBTkRfSURfVERfRVBPQ0gJCQkweGE5DQo+
IMKgDQo+ICsjaWZuZGVmIF9fQVNTRU1CTEVSX18NCj4gKyNpbmNsdWRlIDxsaW51eC9iaXRzLmg+
DQo+ICsjaW5jbHVkZSA8bGludXgvdHlwZXMuaD4NCg0KSU1ITzoNCg0KWW91IG1pZ2h0IHdhbnQg
dG8gbW92ZSAjaW5jbHVkZSA8bGludXgvYml0cy5oPiBvdXQgb2YgX19BU1NFTUJMRVJfXyB0byB0
aGUgdG9wDQpvZiB0aGlzIGZpbGUgc2luY2UgbWFjcm9zIGxpa2UgR0VOTUFTS19VTEwoKSBhcmUg
dXNlZCBieSBTVy1kZWZpbmVkIGVycm9yIGNvZGVzDQphbHJlYWR5LiAgQW5kIHlvdSBtaWdodCB3
YW50IHRvIG1vdmUgdGhlIGluY2x1c2lvbiBvZiB0aGlzIGhlYWRlciB0byB0aGUNCnByZXZpb3Vz
IHBhdGNoIHdoZW4gdGhlc2UgZXJyb3IgY29kZXMgd2VyZSBtb3ZlZCB0byA8YXNtL3NoYXJlZC90
ZHhfZXJybm8uaD4uDQoNCllvdSBtYXkgYWxzbyBtb3ZlIDxsaW51eC90eXBlcy5oPiBvdXQgb2Yg
X19BU1NFTUJMRVJfXyBzaW5jZSBBRkFJQ1QgdGhpcyBmaWxlIGlzDQphc3NlbWJseSBpbmNsdXNp
b24gc2FmZS4NCg0KPiArDQo+ICtzdGF0aWMgaW5saW5lIHU2NCBURFhfU1RBVFVTKHU2NCBlcnIp
DQo+ICt7DQo+ICsJcmV0dXJuIGVyciAmIFREWF9TVEFUVVNfTUFTSzsNCj4gK30NCj4gKw0K

