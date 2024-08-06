Return-Path: <kvm+bounces-23440-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A82DC9499CB
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 23:02:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 31DC51F21CCA
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 21:02:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12A9515E5CE;
	Tue,  6 Aug 2024 21:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dZhXX48E"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DB004315D;
	Tue,  6 Aug 2024 21:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722978126; cv=fail; b=LV3VZD5AkShv9U0Am86IIUfUGY7h7Lzt9O5A7LUngIBRTcCHMqGJ+2jDEMW7EzLcvZbP1Ea8cGlMYLNw9LGzQ+VEWoAh8VhsRH7P/EmZGkrFlgij0X0ipskBMqnMSwV5Kp1xgZCB6bwOTQe9RVZCC1QU8wt7LurkZmjs5/p9vJ8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722978126; c=relaxed/simple;
	bh=aRGfUUWb/gq5R8Z/4ks2vBQBF9QQr7gtyfxNPypuRNY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=FLFHTryR7tBseGRUXEpy059sUZk/M7IJmnQGpg0TqTg9yPkAYbkCW06c+sJlA3QrmidgBQLJyWwr4x5IaQxlRNywVD0Zuvjwn+Dens6Q+h9crWGdz0Q8h8apHOoe3rOfCebAEUyybEvp0mbXMsS3r/WT8zMcQseUi6zyk4pcIPc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dZhXX48E; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1722978124; x=1754514124;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=aRGfUUWb/gq5R8Z/4ks2vBQBF9QQr7gtyfxNPypuRNY=;
  b=dZhXX48E/lwfHVOoDuxeUNkutBa7N0q6zkrz70q5/CjolNNMQ1ySRb+s
   +XoHOf8y1wC0PbS6iTSQ7pckpxk7Hutw1oFvgSKlLWuHLDgghXSXreoqO
   aGKMrWS7XMxja3joNrGknkWWy6kEdsJhZIY8IE5jThl2U9lBplozm8wog
   qG/KGKFSIZGOhEsajLrq+p0S1DHlx40bQ2sJKWeXtvFn6I75LGdHiPBGI
   9bycMga5M3ynTlugrlrerUaYGkqdCWeMWRnY9HOVTUXtRuBDQ2QuAyqyH
   6L5M0gykse8wAdzQILE5s8ZiaeRjqdDmb8WzanJ1nuzszBNtmu9SmTTaY
   g==;
X-CSE-ConnectionGUID: qlZ7j+x0Rlm95wwYbYqvKg==
X-CSE-MsgGUID: ZTZM5j6vS0WcpsZLuum0VQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11156"; a="24897637"
X-IronPort-AV: E=Sophos;i="6.09,268,1716274800"; 
   d="scan'208";a="24897637"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2024 14:02:02 -0700
X-CSE-ConnectionGUID: XpfjCVdoTUWk6Ms86lc8HA==
X-CSE-MsgGUID: wBnMnrVCRpiVDaa5Ywmu1Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,268,1716274800"; 
   d="scan'208";a="56283037"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Aug 2024 14:02:02 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 6 Aug 2024 14:02:01 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 6 Aug 2024 14:02:00 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 6 Aug 2024 14:02:00 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.175)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 6 Aug 2024 14:02:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sk5f5/xsaErGPDVmckxXocH9bpfRH6LUjn6mjZr6Q5gThQety+NX3x8GFvb7EwG/PRddBDBO+B+dyGqGdvCnusYxJu14JKQrFRsJSJ0bL3vOTvCRgsCC9p0t3nhlyK/4W6jW+aVtO8c1MCY/d/7z7pIeNaitDs9Q7dYk6n0XkzWn0yW42lxchHM8vlchBdSUyM9Kbwblb0W0g91ys5cDK4ORLJNkAV+BfGkfuprxQaqHK/EAPTuKXY2ASV+giiO5RSvUti9I0Rw7M1+Pk5vpxTZRBnYGjBvGf6U1muiRBVQTCXy7fBUuQ8fnNMIT71KAti8+UWYeeYZyjh8BEf+I2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aRGfUUWb/gq5R8Z/4ks2vBQBF9QQr7gtyfxNPypuRNY=;
 b=x+Ya2HhN0XrJbjPDEG3YZAQmTpqNZZ6y4uuIQJgARJXxFj7upnKSKxzUoReK+Poesjztwmqfis2T10zAi5Dh0DVvsmXYfXTRazh0OKmZtWC3sOwyNH/uftNwr81SIYp07ehpymYDZrKo25JT15FIj1IFY7KCclOPsC5YpbxrO0V3gVQiXciYNYG0pf+CPovS6v85KHmvbXixGxsaL1puVOAZyJgeJvy+GoRE9Qa3/xoSS2AZiCqCtYRHcA1UXFoWW01DnrInLsU9YSlAOFYnYdr75mSnC8Kx7xbvSGhIl1wxBHXB6WwjAEIWcNK4vjlFPOa+tLdtZ9TlEAOemOPVJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SA1PR11MB8593.namprd11.prod.outlook.com (2603:10b6:806:3ab::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.23; Tue, 6 Aug
 2024 21:01:54 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%7]) with mapi id 15.20.7828.023; Tue, 6 Aug 2024
 21:01:53 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Hansen, Dave" <dave.hansen@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "bp@alien8.de" <bp@alien8.de>, "peterz@infradead.org"
	<peterz@infradead.org>, "hpa@zytor.com" <hpa@zytor.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "Williams, Dan J" <dan.j.williams@intel.com>,
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>
CC: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Gao, Chao"
	<chao.gao@intel.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v2 06/10] x86/virt/tdx: Refine a comment to reflect the
 latest TDX spec
Thread-Topic: [PATCH v2 06/10] x86/virt/tdx: Refine a comment to reflect the
 latest TDX spec
Thread-Index: AQHa1/rKNPBipNV/VEC5hoJmd+/L8rIZta8AgACAeQCAAIF3AIAAICOA
Date: Tue, 6 Aug 2024 21:01:53 +0000
Message-ID: <152887381150e434e6080347abf23cec45ca6cf3.camel@intel.com>
References: <cover.1721186590.git.kai.huang@intel.com>
	 <bafe7cfc3c78473aac78499c1eca5abf9bb3ecf5.1721186590.git.kai.huang@intel.com>
	 <66b19beaadd28_4fc729410@dwillia2-xfh.jf.intel.com.notmuch>
	 <e0447cc1ce172e1c845405c828cd3b6934b85917.camel@intel.com>
	 <66b2744ad5b48_4fc7294f4@dwillia2-xfh.jf.intel.com.notmuch>
In-Reply-To: <66b2744ad5b48_4fc7294f4@dwillia2-xfh.jf.intel.com.notmuch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3 (3.52.3-1.fc40) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SA1PR11MB8593:EE_
x-ms-office365-filtering-correlation-id: aa8a1728-9632-44a8-0283-08dcb65b0012
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014|38070700018|921020;
x-microsoft-antispam-message-info: =?utf-8?B?bTFYNGs4Tm9QTk1UVFNLMjJUUVN3aFRsdmlKYlpwN2JsWGtvbWw1ME1xcE9u?=
 =?utf-8?B?MWFDTDVDRHU2TldVcmtWZEJTV1pDZS83RmNpTklnZCtDTmJkOVJwN0hlUzdm?=
 =?utf-8?B?aTkvWHBXcWVsb0Y0ZHlvMCs0SG5CdkFDNUFVUndIQlYxdHhTMThoczBZU0h1?=
 =?utf-8?B?eXJEcXB4TExYbDIxMkNVMi9lWWR3N0IzbFRUY2prMlU0aEluTlNnT2ErYXEz?=
 =?utf-8?B?NE5xZEZwUHdxUlBVV1dBeUpRRFFDSWl6OEZzazFQZkFib0MyZElXbTBQdndY?=
 =?utf-8?B?VHVOY1pDZHJpQ1d5bDdzUkJ3NEJtbXFDU05kQ3FqR0lmWndLMmlJQmE1cXB1?=
 =?utf-8?B?b2ZuVGhQdmRyS1lZekhIK1lITDMvNldNb1lReWFDTWhWWVptSVZZVjVrekkz?=
 =?utf-8?B?U2VzaW1jOXJxOFIrT1UrTHZLRWZhWHRwcFFsOWZrbm1KUjIzd3M5UHl5bzZ6?=
 =?utf-8?B?UnVPM3F0K1g2bWtrUmlrYWJLUkZvRXh4NmxtSkVJdU1EY0dkZlRWM1h2ZXFO?=
 =?utf-8?B?czNxQXYzUUVadWtsZG1lN0xhelVlWXBpalhaZ3dSTm04L0xJYmlMTndWdURI?=
 =?utf-8?B?VloxZVhSdFBBQWFLNllzSnhUMFA2b29XUW9YRUhHUThOQTNJU3V6WVVrTEhx?=
 =?utf-8?B?SjJqcW5MSnlPNzdLR2FaRmlxZjR5aDRhUFpxanRScDViVy9HbE5UMlF5NUdF?=
 =?utf-8?B?Si9BVjJRZ2dweUo5RjVXb3J0cDcrdlhudDh5TjZZU0RUWTU3M0xSb3FmNldr?=
 =?utf-8?B?WE9IOEFkV0JVYnBIWUtuR3p0QUo1dlRIRWs5V1hlajhFMTBhSkdKTnBDaTlp?=
 =?utf-8?B?NEttL3czWVByQndpc1ZxSXhzNWp2TEhKaVVQVTAySkhSWS9jM1h5Ty96OENr?=
 =?utf-8?B?ejM5UGRVNndYS1Q3MlBjbTFRR1NZSnR1VTMzUS8zZC82amcvekttMC9VbUgx?=
 =?utf-8?B?bU1jSWlQZTVmMU1PNkgxOC9qM2dlYTV1NklyV3VqRXh1VlN5T0R2d2NJWDJQ?=
 =?utf-8?B?eXRXOHdoLzI3azdJcDcvNFNmUnBLbHJZbUc4MVZ1bjc3cTZmLzArdEhZRk8v?=
 =?utf-8?B?V081NkJjN1poMlg2M25xcmFmYWVSbWVPU3ZZdG9adnJrdVdZVG5HSWhIbXNJ?=
 =?utf-8?B?bC9IOEUwNlNaRUozeWRGeUgrei9uVXhidUh3MHBqeGF5N1Z4NktFenMwaVFU?=
 =?utf-8?B?ZFk4UkVrR3FlYnpua1NUTkdVU1grQnRySmRuRC9oaWl1ZTB0MWZMTEFOSDJq?=
 =?utf-8?B?ZVR6VVpTSXRZcGRZQzY1eGV4NHpsenR6RTFjL1VEL1ZFYVZhWCtVbE9JZE53?=
 =?utf-8?B?dXovREVzcVkxeS9SbEw3NDJ0K09hUTEzYjY2TFFRQll1UitLaE1zc1prNVg0?=
 =?utf-8?B?WDNDRmpTT0MzbkZoeEFPUmpNNXBpMFJmZzFxdVJPai9hRUJkVDdTdWNVL1dw?=
 =?utf-8?B?enU5WUVKSW1rZ0I4VDVoTWZWSHFQTWR3NUJZQmcxb254VmNqZjA2LzZaNDVZ?=
 =?utf-8?B?RkJMdmlXL0dmQmthM3R0dTZPQ3ZGc3NGUTV1UUNqMVlnamdOT0drK0ZpcE5O?=
 =?utf-8?B?czVmaFcxdGZtaFBJRDROK2hKTytQWlBnUFpSYlZBdklRUXZ5VGZEMmU1T2Rk?=
 =?utf-8?B?ZzYxRDNzZkZGR1BIV2owTkJGd2VxbXZwUUp6QnoyVy82NXM2L0ZoRmhFbjBk?=
 =?utf-8?B?STF3RDhVZlF2NEE5VFVReFY2TlZPMjdpZVRPeHVMcGxLb2F5SzhoZythM2xM?=
 =?utf-8?B?Y2xmZjJyR2IwWEFncmpvaG96MUFtMmo0Rm9sUEVEenRoNXpSK2hDMUdYQU5w?=
 =?utf-8?B?R1JvYnI4eWYybndZdFRLb1dHTE1wWjZmS1BXV0VYQk9PWFBRS2hJVE5IRm0w?=
 =?utf-8?B?OFZXVHpSd0hucHhyZXllYStRRHo2Y0VkSzI1dFdUeXdwSlFXOTI5aVpNUnk5?=
 =?utf-8?Q?QwupoW/+5jk=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(38070700018)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RkYwK1lUTXBxMlgzd1ZIOUNYYjBWMHBrbXdCTmlsWGJ2UnpjVzcxZ2dTUU85?=
 =?utf-8?B?RG5JZ05pdEdPVHpTYmFUcTBPNGVVSGNWYk9tSEF3SU4vMFpXaHRxMlFDS0Mr?=
 =?utf-8?B?aHI4eGsvNDdrNXlsZmNXUWtDQmJpNHpPUVlPTXdCYTZyRURDQkl6aEFqd0RB?=
 =?utf-8?B?RXFNODRQRlJucVROZjhudUI1ZUFxeDRkWlMrcHZ5UHlxeGh5L1RveFFOWUFI?=
 =?utf-8?B?VSsrZk90eTc3UmlSVC9hQzcyV2RZS2I0aWdFMEFMbEsrTXZXcGJIL3c3V3Nt?=
 =?utf-8?B?YktrRHB0Ky9hR3UwOU14aVl2WnJWUXNiZjU4ZDh1bXVZZW5WWVkxRGQ4MXQx?=
 =?utf-8?B?Z21mTHR2L2JnaTBSY01vaFZ3NmlWdlVYd2llNkJDcUxoWXVRNjVzM1NPSUlr?=
 =?utf-8?B?TUo1alBScTJtUmpBdys4dWJVcHUwWkZYQ0JkcDRsOHNnUUhqUmg5M1JPSjJJ?=
 =?utf-8?B?bG5UYXFTWVJOeVd3S21pZHBnYWFnRUlrenppVytQbTk1Zkt1R0JDK2VyTkp4?=
 =?utf-8?B?dE9iNUFXUC80aXpZbldFYVdIWWo0L0hEUTFLWFFNM3J6MGpjSkdkREFLQk5z?=
 =?utf-8?B?Y1F1YUZoQUhNOTlSZEJaY3ZoWjF1RTd5SDFudmVrK2N4RDhzNEk3d3dMU0tJ?=
 =?utf-8?B?andOcldwbVhQYlRZbkY4Q1JaNGV3QlppSlA5bGlBY2FYRzJzYXViN1FOSUd2?=
 =?utf-8?B?UUExWlpPdEsyeXhuY1M1bnBhMnEwcFYvSENEdStGbFRHRi9UYm1Jb096dmNO?=
 =?utf-8?B?VDJ2YkJXakdsSVdFVVh1eldneHY2UWY4Ukt4ODc4cFE0QXI2Wmpndlk3SmVN?=
 =?utf-8?B?MjJpSFczcGhtNTY4Q1pwZzd6YS80bHlnY3prREZoMTJXcC82NTYyaHFSVnlW?=
 =?utf-8?B?R3pPeC9nMXBtbTA0czFpNTdDMGpBYmxOVGp2Zy8zZVc2RGxzcVQrSmtIVENF?=
 =?utf-8?B?S3YvNXpxSGRFR1l2aDcycUJQVHhuenZ0MmJOTk5vVXJ6WUxoV1FDd1FJTUxZ?=
 =?utf-8?B?R0w2T0txQ1BPUjRMdFpMdTNRajlYOFM0WUhLRU5oZTUzRkNHMUlDb0svNUlC?=
 =?utf-8?B?U2JkUWVzZGVoRWdqQWQzSmVNdlJTbVA0ZEtNRjhFNXE4bmN0UlFLc2hxMk9a?=
 =?utf-8?B?alQ5alluVy9XWUVxcm8xak9VS21WdHVMMThDRE9SVGlUV04xVHE0YUZQR3hX?=
 =?utf-8?B?MEZDRE9aL1JOOTBsOW1kcjgxMUlGMEVLM1NVZyt4eENwT0Y5THJFbzBCVm1a?=
 =?utf-8?B?QS9mOSs1dWlJQXAybXpDSmZtSXdkVTdBRmk5N1RDbmw1MEVZUXViczlQTVJP?=
 =?utf-8?B?SnJ1aXRSVVg4ZVBtSEpHQ0hJUXp2TzF6ME50Nm5OWlZlZlU2RFI0THNiKy9V?=
 =?utf-8?B?QlFQZVRxSWZvdGhabjk3ZEZjZ3JhcjhOa0dKL3RvOXlMZG9PL0lvSUd2TGU0?=
 =?utf-8?B?TEJDdkZNYitRNWhlckFGcVhsT3lXemhaZ3YwM0grZjZxOWlRUnBQNVlRLy9C?=
 =?utf-8?B?ZzkxN0x6TUNJK0N3bk10RU5hM2VjUytzZ3V3K1cxeFBnQXAralFFRW5rK01G?=
 =?utf-8?B?VTdFSkZmeUVUZ3E2VWZzV2VXdkJrRUdRejZKUEQ1eURnbFVTQVZtMWtyU2hv?=
 =?utf-8?B?L2U3Tm9heVM4MEQ3dWxUZ3hYYTFZK2JvcjlQb3oyaFR1bXlsZ3pPZHBLemtZ?=
 =?utf-8?B?R2pvVjRDaHorcWxDemJKUXUxbzdWZVpXTVlJLzBackFIOGhiNE1mcVdGY293?=
 =?utf-8?B?MDMrek80NEFUb3dZaG5EWjVpaVpaVmgyemZieG9BL3QycTg5eUpJcXkxSVRJ?=
 =?utf-8?B?ZVhNc0YrRnFXVEhjd3BtUGNkQUp3d0c1cVUzT3h3ZmRLT0lobEFZRU96MmQ5?=
 =?utf-8?B?Q0pFeUFGcHNZbnBhSFJOdm9Icm0wM3JiSEgrVWFyb0l0T2Rjd1JLT0pNWTNh?=
 =?utf-8?B?VEFqVGJJVm9nZnV3NndYUFpHYlBuazVZRkYzSU1hVlZzcjJNc1hvMUExZlNX?=
 =?utf-8?B?N2ZNZzB0LzZmSTYwR3BXMGFyTnoxMGNTejluVzJaazJKd1p2RjAzUW9aVWxE?=
 =?utf-8?B?b3o3T2pjdHh5ZEgzMWFrd2ZEdEt4NzM4ZE1ndUEvSkRaRWxQMVIxR3d3YmVs?=
 =?utf-8?Q?3TI1/6AiuPE9DOP703O6G571m?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C794436911B4C04EA1134D7EB39B276F@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa8a1728-9632-44a8-0283-08dcb65b0012
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Aug 2024 21:01:53.8595
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BvqD3taPc9oAlX55MoYQaLTYdF666vXvolsxoK1erF+m7qG1apOpJ9z/aLNMP1KrouxUT4TtwSVB90x8N7z5ag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB8593
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI0LTA4LTA2IGF0IDEyOjA2IC0wNzAwLCBXaWxsaWFtcywgRGFuIEogd3JvdGU6
DQo+IEh1YW5nLCBLYWkgd3JvdGU6DQo+IFsuLl0NCj4gPiA+IEdpdmVuIHRoaXMgaXMgSlNPTiBh
bnkgcGxhbiB0byBqdXN0IGNoZWNrLWluICJnbG9iYWxfbWV0YWRhdGEuanNvbiINCj4gPiA+IHNv
bWV3aGVyZSBpbiB0b29scy8gd2l0aCBhIHNjcmlwdCB0aGF0IHF1ZXJpZXMgZm9yIGEgc2V0IG9m
IGZpZWxkcyBhbmQNCj4gPiA+IHNwaXRzIHRoZW0gb3V0IGludG8gYSBMaW51eCBkYXRhIHN0cnVj
dHVyZSArIHNldCBvZiBURF9TWVNJTkZPXypfTUFQKCkNCj4gPiA+IGNhbGxzPyBUaGVuIG5vIGZ1
dHVyZSByZXZpZXcgYmFuZHdpZHRoIG5lZWRzIHRvIGJlIHNwZW50IG9uIG1hbnVhbGx5DQo+ID4g
PiBjaGVja2luZyBvZmZzZXRzIG5hbWVzIGFuZCB2YWx1ZXMsIHRoZXkgd2lsbCBqdXN0IGJlIHB1
bGxlZCBmcm9tIHRoZQ0KPiA+ID4gc2NyaXB0Lg0KPiA+IA0KPiA+IFRoaXMgc2VlbXMgYSBnb29k
IGlkZWEuICBJJ2xsIGFkZCB0aGlzIHRvIG15IFRPRE8gbGlzdCBhbmQgZXZhbHVhdGUgaXQNCj4g
PiBmaXJzdC4NCj4gPiANCj4gPiBPbmUgbWlub3IgaXNzdWUgaXMgc29tZSBtZXRhZGF0YSBmaWVs
ZHMgbWF5IG5lZWQgc3BlY2lhbCBoYW5kbGluZy4gIEUuZy4sDQo+ID4gTUFYX1ZDUFVTX1BFUl9U
RCAod2hpY2ggaXMgdTE2KSBtYXkgbm90IGJlIHN1cHBvcnRlZCBieSBzb21lIG9sZCBURFgNCj4g
PiBtb2R1bGVzLCBidXQgdGhpcyBpc24ndCBhbiBlcnJvciBiZWNhdXNlIHdlIGNhbiBqdXN0IHRy
ZWF0cyBpdCBhcw0KPiA+IFUxNl9NQVguDQo+IA0KPiBURFggTW9kdWxlIGhhZCBiZXR0ZXIgbm90
IGJlIGJyZWFraW5nIHVzIHdoZW4gdGhleSByZW1vdmUgbWV0YWRhdGENCj4gZmllbGRzLiBTbyBp
ZiB5b3Uga25vdyBvZiBmaWVsZHMgdGhhdCBnZXQgcmVtb3ZlZCB0aGUgbW9kdWxlIGFic29sdXRl
bHkNCj4gY2Fubm90IGNhdXNlIGV4aXN0aW5nIGNvZGUgcGF0aHMuwqANCj4gDQoNCkkgZG9uJ3Qg
dGhpbmsgdGhleSB3aWxsIHJlbW92ZSBhbnkgbWV0YWRhdGEgZmllbGQuICBUaGV5IG1heSBhZGQg
bW9yZQ0KZmllbGQocykgd2hlbiBuZXcgZmVhdHVyZSBpcyBhZGRlZCB0byBhIG5ldyB2ZXJzaW9u
IG1vZHVsZSwgYnV0IG5vdA0KcmVtb3ZlLg0KDQpPbmUgdGhpbmcgd2UgbWlnaHQgbmVlZCB0byBj
b25maXJtIGlzIGFuIG5ldyB2ZXJzaW9uIG9mIG1vZHVsZSBzaG91bGQNCmFsd2F5cyBzdXBwb3J0
IHRoZSBmZWF0dXJlcyB0aGF0IG9sZCBtb2R1bGVzIHN1cHBvcnQuICBCdXQgSU1ITyB0aGlzDQpz
aG91bGQgbm90IGJlIHJlbGV2YW50IGlmIHdlIGhhdmUgYSBwb2xpY3kgYmVsb3cuDQoNCj4gTGlu
dXggY291bGQgbWF5YmUgZ3JhbnQgdGhhdCBzb21lDQo+IHZhbHVlcyBzdGFydCByZXR1cm5pbmcg
YW4gZXhwbGljaXQgImRlcHJlY2F0ZWQiIGVycm9yIGNvZGUgaW4gdGhlIGZ1dHVyZQ0KPiBhbmQg
TGludXggYWRkcyBoYW5kbGluZyBmb3IgdGhhdCBjb21tb24gY2FzZS4gT3V0c2lkZSBvZiB0aGF0
IG1ldGFkYXRhDQo+IGZpZWxkcyBhcmUgZm9yZXZlciBhbmQgdGhlIG1vZHVsZSBuZWVkcyB0byBz
aGlwIHBsYWNlaG9sZGVyIHZhbHVlcyB0aGF0DQo+IGZhaWwgZ3JhY2VmdWxseSBvbiBvbGRlciBr
ZXJuZWxzLg0KPiANCj4gT1Mgc29mdHdhcmUgc2hvdWxkIG5vdCBiZSBleHBlY3RlZCB0byBrZWVw
IHVwIHdpdGggdGhlIHdoaW1zIG9mIG1ldGFkYXRhDQo+IGZpZWxkIHJlbW92YWxzIHdpdGhvdXQg
YW4gZXhwbGljaXQgcGxhbiB0byBtYWtlIHRob3NlIGZ1dHVyZSByZW1vdmFscw0KPiBiZW5pZ24g
dG8gbGVnYWN5IGtlcm5lbHMuDQoNCkkgdGhpbmsgd2UgY2FuIGhhdmUgYSBzaW1wbGUgcnVsZSBs
aWtlIGJlbG93Pw0KDQpUaGUga2VybmVsIGRlY2lkZXMgd2hpY2ggbWV0YWRhdGEgZmllbGRzIGFy
ZSBlc3NlbnRpYWwsIGFuZCB3aGljaCBhcmUNCm9wdGlvbmFsLiAgSWYgYW55IGVzc2VudGlhbCBm
aWVsZCBpcyBtaXNzaW5nLCB0aGVuIGtlcm5lbCBjYW5ub3QgdXNlIFREWC4NCg0KSW4gdGhpcyB3
YXkgdGhlIGtlcm5lbCBkb2Vzbid0IGRlcGVuZCBvbiB3aGltcyBvZiBURFggbW9kdWxlIHZlcnNp
b24NCmNoYW5nZXMuDQo=

