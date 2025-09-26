Return-Path: <kvm+bounces-58901-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5EE12BA4FFD
	for <lists+kvm@lfdr.de>; Fri, 26 Sep 2025 21:52:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 782DB1C205A9
	for <lists+kvm@lfdr.de>; Fri, 26 Sep 2025 19:53:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 945EB283142;
	Fri, 26 Sep 2025 19:52:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KFtdQS9k"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D43E1C28E;
	Fri, 26 Sep 2025 19:52:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758916360; cv=fail; b=UJs7tAcM1BH9T7W7wwr0npRUoOjWAeupPMZ/dXJFz6eDKtjSVlCLhnsjXz+XcTb1Lj/oqC5BMyRcfPUFTDzVrjfvM0I0xHDcId1gaIQo08lVp/pq+APNTSTDCCmavXlJ2FtbqlZILUItRjCBrZJWWUsbLNknBOgMaEVD/gusSqA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758916360; c=relaxed/simple;
	bh=r6+sh3GyG8l6xwpvb76qySv2AnOkeVokd8qKyvW63l4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=sH5txT6dZNcwZxnagaPIaYKq+wlAk8GLYurXqk14OsCDYrktpVfv8oLKYt6krnpXpX/tkWi8IUMRizZAlSxKWCGTR8z+r2130fFhsbv4d+Kb1S5jySMJNQuQ3jUzBS+Vmga2kvetWC0lArLAEh14YiD8FTix9kuDyb9/cZko1ss=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KFtdQS9k; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758916359; x=1790452359;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=r6+sh3GyG8l6xwpvb76qySv2AnOkeVokd8qKyvW63l4=;
  b=KFtdQS9khYoCp13XUnuiyKfgwkcg/8G/mrm+zOsWyqxndGUoljdPAzWH
   k+8MoQWBKEDWHVGOPjbUi+eNh7Iz54ElXrXb3iUuC+io3b7DhRW2+DGf/
   U//5yCm/BZdxmm7URvCRVNEG9dl8plDCeGc+cOoezQ5juEgUmNsaNgyXk
   b6FMzBLJXHaW46wPW19lyIc7/0DTMYN62T0PD3vWlZFYx/6r8hPPIg+kY
   iDtUpF/FSpwOH5CjnY+BwDEq0Q7zAdrvlQj8QjW3CPcV0TwrMRJXTT6Ci
   cvpSZY2O6mgMcekASlZ6ffPy+5vEueyHN57Hl51Vy1bdnxh1npwm7daK7
   g==;
X-CSE-ConnectionGUID: UZovmGT2QSivhN6T17Ep1Q==
X-CSE-MsgGUID: 6VVByjmwQCeb3FMXry/i6A==
X-IronPort-AV: E=McAfee;i="6800,10657,11565"; a="61173321"
X-IronPort-AV: E=Sophos;i="6.18,295,1751266800"; 
   d="scan'208";a="61173321"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2025 12:52:38 -0700
X-CSE-ConnectionGUID: wzhgpAWYQYSdmU612A1u6w==
X-CSE-MsgGUID: AnYO7lpvTH2U3ONg30+Jkw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,295,1751266800"; 
   d="scan'208";a="177750628"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2025 12:52:38 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 26 Sep 2025 12:52:37 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Fri, 26 Sep 2025 12:52:37 -0700
Received: from CO1PR03CU002.outbound.protection.outlook.com (52.101.46.35) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 26 Sep 2025 12:52:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GU9Tokj9PFBuqUjOa/5AQMqYUiLXF9RNGMxVG2SFNf2Hla8FwmiL4SwjuwJztI6r0Dm17IkPgT9l90N9y76Z94vOHc6dfzowH7WKo1puJJYP8eSo+fBiiu1dPZG4nu5fR+NVk6jhO/jeVgBzIndnq5y4o0+rUAn6qgU28fC0nCoMP0CG2f4mCWO9mgWxBmtqnuopy77T+WIP7Iu25Vm6G0b2H0Mw3+y4hW2EXSz25L7fHAgI3u00zmlyDtN/98zS6Oyy7vxEwVuzOMtZE4RVTXdZ99L97mcbAhvICBm6WRRgQjC8KzY7LMrqKkADxkh+2hIjrXXb5u6zGlUUFnM+3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r6+sh3GyG8l6xwpvb76qySv2AnOkeVokd8qKyvW63l4=;
 b=vJW1Cn4rWqrUijudekWdHCELJuplb0y91B9jK1ymAaydc4cQh1d1ekoPLqpN8klkGkD7fQ+7W4AAamVXQCUMG3yvpndZbuv3l7/U9mucwcPnHDrjNkUlqH2xTlC8BPK6R4j08RVt/4SPLeAoQNvnif1TmLQaIsOo6nWHPlsN/ALzqYiae9dtp6uV27oek7Eb0VdPtFqfyGcs2uc6l0ltRwpJtUsdGyqI4x4EyhlFM2cXEcp2rmoYEQsLhYK3QTgso9Nwq15OE+3uxVHnesUSO/GVsRtwYTilIVSga665yg5ppV/s6TyxO1EYEbOq0mTl7tGq52JoftpcnLgKXiTv4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SN7PR11MB7438.namprd11.prod.outlook.com (2603:10b6:806:32b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.11; Fri, 26 Sep
 2025 19:52:34 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.9160.008; Fri, 26 Sep 2025
 19:52:34 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Hansen, Dave" <dave.hansen@intel.com>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>
CC: "Gao, Chao" <chao.gao@intel.com>, "seanjc@google.com" <seanjc@google.com>,
	"Huang, Kai" <kai.huang@intel.com>, "kas@kernel.org" <kas@kernel.org>,
	"Annapurve, Vishal" <vannapurve@google.com>, "bp@alien8.de" <bp@alien8.de>,
	"mingo@redhat.com" <mingo@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v3 00/16] TDX: Enable Dynamic PAMT
Thread-Topic: [PATCH v3 00/16] TDX: Enable Dynamic PAMT
Thread-Index: AQHcKPMxbI3n4d0yEEyHrd2rA1fcBLSkyKKAgADDrQCAAB+VAIAAAsIAgAAvCACAAADpAIAADaKA
Date: Fri, 26 Sep 2025 19:52:34 +0000
Message-ID: <ac8b269d0e06ace9d4dab75130483aad77768cc1.camel@intel.com>
References: <20250918232224.2202592-1-rick.p.edgecombe@intel.com>
	 <aNX6V6OSIwly1hu4@yzhao56-desk.sh.intel.com>
	 <8f772a23-ea7f-40eb-8852-49f5e3e16c15@intel.com>
	 <2b951e427c3f3f06fc310d151b7c9e960c32ec3f.camel@intel.com>
	 <7927271c-61e6-4f90-9127-c855a92fe766@intel.com>
	 <2fc6595ba9b2b3dc59a251fbac33daa73a107a92.camel@intel.com>
	 <0b3e3123-b15d-4dfd-8af5-710d140d1f7b@intel.com>
In-Reply-To: <0b3e3123-b15d-4dfd-8af5-710d140d1f7b@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SN7PR11MB7438:EE_
x-ms-office365-filtering-correlation-id: 349a177d-f8c2-4f99-7211-08ddfd363cbc
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?Y2pvdzUyd1RXSWVESHd2a0ZOZlY2UUtyUjB2SFpmeGFrTHVFaEVxS1M4SmtW?=
 =?utf-8?B?NDVOQVpjNWR5TmRYS2N0NzFET3RQbkNGcGVIYW1BaHhCTUhzQ2hsWitaMzkw?=
 =?utf-8?B?QUk2eHovWUxpVHdRaENXU21MTGFwYTlBL0o3V2NXa1hBc1RTVU1YaFdNTDlk?=
 =?utf-8?B?Ri9Xbk9leWZUQnVlT0FSdGZZTUlLR3BQS1k4NU1QRXRlRXJ6MjR5aWx4UGZs?=
 =?utf-8?B?Y2RaZm1CcjUvdUF1Z2hKaksxaGo0UDduNENGbHZ1bGZ4b0JOaWo2aFhUaHNv?=
 =?utf-8?B?UTNpV2o5Y3gzbFhsV0VzWFlITGFFc3lKY0tlR21lMm1RTCtsQ0UrMElLR3Vp?=
 =?utf-8?B?aWFqOVFCWG5Ccmg3NDNsRmFaOG5oRmJ5RGpFWjBwQXZFTTNIaWduL043dm9P?=
 =?utf-8?B?dUFmSjFZMFkrcFROV3I0UXhZYU0xRE9qVjhJVDMxdXdOeVUxOGJFekZRenR1?=
 =?utf-8?B?Rm1hVWZYclQzdjFMTDMvQVJ5THZsVGhzOGJpK2MzRW1MYk5ZRFRQODBWKzNj?=
 =?utf-8?B?dWFkcVo1dGJkVVhMUi9iRHVPTDhlZ3NqLzdIekNqaW1QNEViMU1JNmhSdFAw?=
 =?utf-8?B?bTA2a1IvRXNGQy9oay9iUFN2c3dVOCtRb0dIdnkzYTd6YlBydmEvUkkxSWlI?=
 =?utf-8?B?RVgwUVFWam5QVFhmT1hETHkvQ0hwVHhNYlJrVXF1aTgxdjQ0UnBad1FYOTNU?=
 =?utf-8?B?R2RBV2kyN1pkeFhoVmZQdjlFeGczVEg5c1NUSWpHSTc2akVuaTZQZ3hPOHY5?=
 =?utf-8?B?ZDFmTXhONERLZkNsYUNvekxnamdyRGwraXdYaTg3RVJuZkdWUWFDMHkzUGt3?=
 =?utf-8?B?TDJyRWkvNnlmVG44WmR3VjR0Qy9yQUlITzZjcGV5QU9teTByVkF5UXJIZUxw?=
 =?utf-8?B?VnpZMVpiQmF1QWNscnlhQjJUMmtmYm9LNmk0enE4TEpra1dvNUVBRSthT2FT?=
 =?utf-8?B?SWJnbTl0QXhsUXJ0dlZydTFoelFDak8zU1ZGTzgzUXNnVnFNT09JNXEvYXRm?=
 =?utf-8?B?K2lqK0Y1TVhJMDNWdDBUVjk1WGtpMDFDenZLY3pzNDdCZENnazJxVzRrM2lT?=
 =?utf-8?B?Zkp4Y2JtQ01EOU90OGtlL04rUEk4bmYxYmpVZ1pyZ0ZTeTc1R3lKd2hrVmxW?=
 =?utf-8?B?OGhYTUZGNFdHT3U4MkJDWGpLM2pDbVJJVDFiWkNBT2k4RWhPcThidDNxcmMr?=
 =?utf-8?B?ZEkrcDloRnRsOGJETEdpR1dGVkpCOFIrYmZHK1N3OG92QTd3U0ZZVmIvQ2d1?=
 =?utf-8?B?c3R0eUNleUJNVVlkODI4Vzh1SGt5K1U4RjRrUlhScEtQS05ndVF1Nkt6WTl6?=
 =?utf-8?B?VjZiY09TOW4yZ3RsVXkzQ3pWdGpobEpMT2UyVldOZG00UmhqdkxGS1pNSlcy?=
 =?utf-8?B?b0g3bUw2WmFOaEFJbi9vTnRGc1Byd0VzaGpGOGtocHJUUVFmSlVyMGV3Q3R6?=
 =?utf-8?B?VVZKbWxmZkVVZnY2QndzZWtTalN6bE9MclZyNGIwYnVOcThCVUg2cTR4SmJa?=
 =?utf-8?B?TmJiY3VtLzl4NGlldC9KT0ZORkxiZmFjMldwRW9oMVM2cTBoUFVCVXNoMkVk?=
 =?utf-8?B?cjJnLzg0d2RRNUFVQWFpYkU4ZXBhYkFzdGV4akdpcXlkb2RrTUJGT2k0ajdr?=
 =?utf-8?B?WTdLQmVnYkQrV3BjQVdFK2tJSkhzaVFxK0dhcnA2Yzd6L3R1WWxPOFNrN2Fy?=
 =?utf-8?B?dU5jWFR6ZlFndTJtM3ZiYmpJenZqdnJQaUdObDIyOHM4alJ0QmtBSWkzUjls?=
 =?utf-8?B?N2ZiUFhJZEx5WWhjMkUvUklxMzBEeXJPRDNxRmlEa1JkNndIRmt5eTNOUkgz?=
 =?utf-8?B?VXViS3VTWFhQRDN6THErbzUyZnVSb2xra2luaDdtSjNidklkanlpcS9oSUpG?=
 =?utf-8?B?eTZCS0NIa3RJVjFnam9QNURHMGM5SEd0VWYzbkIvbnBDSlZtQjJGRzVVcTlk?=
 =?utf-8?B?TWxUSFRINUFTVDltS1RpRWJuTThmd1oyWk1YSmpWVkJmUXJDZWJ3NmhCczl6?=
 =?utf-8?B?cTN0R0VzQW92RWhDRE5SelFVY1NFSk0yVkwyVWI0UFMva1hscFY0elZBSlNN?=
 =?utf-8?Q?LSnbTi?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?T28xTlRvend4akFIbndmdlZxR2pTWUFiZXl1QkUxZ0QzWTJzRFNoaTVkemQ4?=
 =?utf-8?B?a254dlkyTVBucld6K2pXV2VsOWwzTmxocVhrWWhyL2puVFFXRXZQWFEwa0tN?=
 =?utf-8?B?VVRKamk1eEZaN1RFRk5YWm5aUnpSWFlhMWVUeHVwclE1cjc0aFFKRlNSd0Fz?=
 =?utf-8?B?elZ3ZnN6TUpzVEp1NGREbndNWkVpRXBwZVVQY1RLZ0JzeWZQWjlieXY5L1hh?=
 =?utf-8?B?NG15a1BTMlpZMEhvRlFiSWZDaHdYSDhpMmh5dTFjbHJ0NHg5NXlIS3VwUlpI?=
 =?utf-8?B?VURMQmJZSUVPMHVzaWMwU1U3YjYrNTdGMnh6OFRJN1lzRGlOanZtbGpqaVFq?=
 =?utf-8?B?TjhPSTl1VVlTcVUzVzZpSzB3RU9yWURrYXdoKzNmOWc4NXdLRFpZR2hkdkEz?=
 =?utf-8?B?WWxsNm5NQXpJTm9uRWJmOTREM0EySGxzbkR6cy9YTXpmVyt2UURNb2lBRTlS?=
 =?utf-8?B?WjNDSmZWdHdYNWx4bFM0c0JEY2tZOW9MTHhBVlpDcjZIem5rVDZaQ1N3Z2J1?=
 =?utf-8?B?Nnd5RU1PaS9RTjZ6T3N1aDJJeS9GcEpraFYyVWlJeFpSKzQxanI2TzJHcHdG?=
 =?utf-8?B?b1BBandaMy9hcC8reENuZ3U1RWVnb0RlWTZrSldRdzJTNm9IREVxMjNYb1d1?=
 =?utf-8?B?KzVBZG5pTWNBZy95VFZLQnhBc0VNYlk1UG5RUzMrNE9CRnJvdTY3UWVZRmll?=
 =?utf-8?B?VlBhU1dUNWpJTDRVTXFCQVNQRmtjOTN6U3M0VFZiVkxjRm5WTW1wQ3Q3YkFx?=
 =?utf-8?B?YWt3SzZhUWtpaWNCTGNnVHRvMlhhWHZOcmxGVDV1b3lZc0JzQ0hFeUx4U3Fp?=
 =?utf-8?B?MWFPS0N1WmM2RlUyb1RQd2ttVmtwY3R1ZmpNakdpcTBjaUlSdjRuYnh2ZEtk?=
 =?utf-8?B?clQ1V2YwejBqVlpTVWFJMTZxR2tQVG9qd29GTXAvQmxwdHNQVC9pb0hEVUxh?=
 =?utf-8?B?eDN3NWh6UGZ6YmphVDdFWFl1SUJaQ3Vrek41T3ZHajNUQ0lGbEJjWUhkSlVU?=
 =?utf-8?B?emUrNUs0dmMvQWI1U0x0bzkrSmdSZjU3S1JSbFBjVWFDUkNVN3k1WVBWalMv?=
 =?utf-8?B?Q2ZXc3hRSjlib0dMeFNYVjVNWlRIdThkUVBLQ01DMUc5bTNCNzdXSlhTTTdC?=
 =?utf-8?B?eStWVDViN3JiQzhXMlFYNnllMEwvaGREalY1UmVwK3h5Z3hVQmhITEpGM29o?=
 =?utf-8?B?TzJaSDBaSFUvUVFTamVJV1hSWE9pV2RmUDQ2Q0pRdUNXcUF2RjdQWWJWRGUw?=
 =?utf-8?B?bmZJQ1RCTy9DWk56UGFNWUd1ZlhqZjI0L0xpdEVUN3R6YUR6bkdQZTZEYktx?=
 =?utf-8?B?Wlp6TXU4aFF2aFlLcmI5bkZJNDl6RFFKRU5FTCtOSVZBdWFKU1dnaFRwdk9V?=
 =?utf-8?B?NURmK0VhV2drUEgxVWRxRzJ3NXZnUTRKL3V1WGhBWDRUNkl0VkNwZXVISlMx?=
 =?utf-8?B?S1BaWm94TzJsVWlhbTdtMnA1dXdiTzRrRXZZWE43VVcyYXZSM2pyOU9LRisr?=
 =?utf-8?B?MG1jdEZxaS8wcW5LODlDYkt6RnZNeTJXd1JFUVJ4MDE4RENjZ0hJSVJrR1c0?=
 =?utf-8?B?SGZPNDI2d1Y1bTQ2M2djNmlmWVBwWEIrSE9sRjhuZHorM1lsb1hFK0FJc0R5?=
 =?utf-8?B?WjR2eURZaFBMZnhrTDZmc2d5UW8yTUlvb0ZTMGNlbG9jL0pPbGFkdFZKTjJM?=
 =?utf-8?B?Wk82WUZZRlUwLzFWZXc2NWJoNVJqVnBabXl3akdjeFdwVmFZSXEvMEs0ejlC?=
 =?utf-8?B?UXd4OTQzalNOdGYyNDlZeVlMZ1d3Q2FmQWZWdm9GdFBITVAzY1pBRDNnUWNt?=
 =?utf-8?B?d3M3MmxsUitnamVyWC9VYldvaHl5REpKN0w1bTY2ODNlOUlTaGRZL1kvc3do?=
 =?utf-8?B?NTd0SE1qZlorOExLWm9YZGpRdkwxZzcvdkFZZXR5WFFxckNudDk3aG0zL1RC?=
 =?utf-8?B?OWlTdC9MaVdvVm43NXRXek5wVmJ1aTZlRWQ2alBLeElkWVFIckNYSXo3dDdz?=
 =?utf-8?B?MjJkTUt3YmhscTdoV1pBdmpXSjFDL3dPMFYyUFBjUjl3Mzc5aVI3YytlSE1B?=
 =?utf-8?B?TDRRQ3dQK3RwQjdYUWpvOHVSWkJ3dk1mKy8wR0pHaFE5bThjT2E2SG5vVmMw?=
 =?utf-8?B?c2NuVEtJMndibUE2NDNtdVVsUGJlZTdpT3MzdVlpSjdJZjNSa0NxNVliZzMw?=
 =?utf-8?Q?Uu/0QPkzbUcwapHLhiKINFo=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <31ACBCBBA246FD47A1422580A3B32EBC@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 349a177d-f8c2-4f99-7211-08ddfd363cbc
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Sep 2025 19:52:34.5233
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: N5ZsxjFrVqafk/tS6X/p7ZAxc8Xyf6G3lT5tfGp2KXEquVyLwd+LGU/tSHCJ03XTfWhijQQ/+7GmrS4WArn3U3VIZR9ZE6561cDBKwJzLCg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7438
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI1LTA5LTI2IGF0IDEyOjAzIC0wNzAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
DQo+IFllYWgsIGJ1dCB3aGF0IGlmIHRoZSBURFggbW9kdWxlIGNoYW5nZXMgaXRzIGxvY2tpbmcg
c2NoZW1lIGluIDUNCj4geWVhcnMNCj4gb3IgMTA/IFdoYXQgaGFwcGVucyB0byA2LjE3Ljk5OTkt
c3RhYmxlPw0KDQpZZWEsIHdlIGV4cGVjdGVkIHdlIHdlcmUgdHVybmluZyB0aGUgbG9ja2luZyBi
ZWhhdmlvciBpbnRvIEFCSSBldmVuIGluDQp0aGUgZXhpc3RpbmcgUy1FUFQgbWFuYWdlbWVudCBj
b2RlLiBUbyBjaGFuZ2UgaXQgd291bGQgcmVxdWlyZSBhIGhvc3QNCm9wdC1pbi4NCg0KV2Ugb3Jp
Z2luYWxseSBhc3N1cmVkIGNvcnJlY3RuZXNzIHZpYSBURFggbW9kdWxlIHNvdXJjZSBjb2RlDQpp
bnNwZWN0aW9uLCBidXQgcmVjZW50bHkgdGhlIFREWCBtb2R1bGUgZm9sa3MgcG9pbnRlZCBvdXQg
dGhhdCB0aGUgVERYDQptb2R1bGUgQUJJIGRvY3MgYWN0dWFsbHkgbGlzdCBpbmZvcm1hdGlvbiBh
Ym91dCB3aGF0IGxvY2tzIGFyZSB0YWtlbg0KZm9yIGVhY2ggU0VBTUNBTEwuIE9yIGluIGl0J3Mg
dGVybXMsIHdoaWNoIHJlc291cmNlcyBhcmUgaGVsZCBpbiB3aGljaA0KY29udGV4dC4gSXQgaXMg
aW4gdGhlIHRhYmxlcyBsYWJlbGVkICJDb25jdXJyZW5jeSBSZXN0cmljdGlvbnMiLiBMb2NrDQpv
cmRlcmluZyAobGlrZSB3ZSB3b3VsZCBuZWVkIHRvIGRvIHRoZSBhYm92ZSkgaXMgbm90IGxpc3Rl
ZCB0aG91Z2guDQo=

