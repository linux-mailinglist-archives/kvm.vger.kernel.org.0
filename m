Return-Path: <kvm+bounces-16717-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A5C4C8BCCAB
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 13:15:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C8D7E1C2180A
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 11:15:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 275A6142E8F;
	Mon,  6 May 2024 11:15:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Io5Vlbap"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5407A142E80;
	Mon,  6 May 2024 11:15:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714994127; cv=fail; b=XgN/2ksWDvdEDXlmf0kEYaHk4ykdVacT5m8Ovz+I8rU+TXsHXvYdw7DcQ2ivPxTChlnCa338AkmQez0xj6nd08cSJpqxpHA/PNIswVDYOs0zRQL6iGXhU8roJkOfneg7/litaNVA+DNbWkxoxBbUNUyUrIHj2xwa6vziUl6iMzA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714994127; c=relaxed/simple;
	bh=r0r6tfWEONWDPI5TboujHK8Vfy21nltNarS+KZYLB3M=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=cYVQoo4SXuye8737A3r7bfVeZV3UZIXaAw4VxGKwguwnWLEktFo7s/8gA3K1dLpSRwyHOSWhqq/dDF5iT/yLFUQQmsHOQJlFErZHMlnxvXtBxFwUkTxUotX4K5zFGVWXXk0wFcAl4LTOUwhGCYRGQBz++a6oSk7K9Q3rOoeANnU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Io5Vlbap; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714994125; x=1746530125;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=r0r6tfWEONWDPI5TboujHK8Vfy21nltNarS+KZYLB3M=;
  b=Io5Vlbap9r/krg4ZdgZp00TkoZQG/vBslhur4HhExCBcFqtmTvbb80X0
   22/7EoLsI+9RLdbd+INMhuDdgPrVzCDRgtiql7cSh7t4V4qjYXJ46Dx+E
   7JeoWTTtFsOU3UVqr6iKRndxPwLImcu5N7HgN7OIIMGOI4lsGcGUDEsH8
   SLD91YpaBH+5Z66aXNEZ1m2EGIFk1zpuYyWMCp09Nt8OLcBs9pAtyJNNy
   mdMN/71n7oe+pB/x5puxfFwE0bQT2nRA+9y1hqCVVFt9/gh1+q2kf29zI
   b2IescjRJ7S60pKQnEpAUUZa6Vhs+2PzhxspmEAnZWMoEfhwT6Et/d3Dz
   g==;
X-CSE-ConnectionGUID: a9vym/dcT6+hJT1tdS44DA==
X-CSE-MsgGUID: 02uiSq+OSwinlqGy9uZ1xA==
X-IronPort-AV: E=McAfee;i="6600,9927,11064"; a="10856142"
X-IronPort-AV: E=Sophos;i="6.07,258,1708416000"; 
   d="scan'208";a="10856142"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2024 04:15:24 -0700
X-CSE-ConnectionGUID: yorGeQ/OSJCV9V1YhYCvTQ==
X-CSE-MsgGUID: aivZ6K1XTYOTtZL3l4ROSQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,258,1708416000"; 
   d="scan'208";a="51326954"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 May 2024 04:15:24 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 6 May 2024 04:15:23 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 6 May 2024 04:15:23 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 6 May 2024 04:15:23 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 6 May 2024 04:15:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U/oDMQIBe0WDoUN9owL83Tm9oBmoBhTW2OIW69HaeSWBqXVmam+YSQd2nWdjdzVj9mqH5WMOoTFfGnH4loSah9+zmu005gnYFu21kb3iWx7oUs4knE1SB9PMIlIKpuksmebUHG65uIrGI2TbBznRh25HChq6jcjsNbgUZ+jbFvm9BH0Tli0wRDWLNaXQT3FzBy3r35LlWD/Y1QgkaX4CrM9j8ofINhCFU4PZl+yZ1bafHhkJqV8TT3Dm8K5hqvTFYw3dUgzUjoLqnGTR/qse/wyAzRrHgNUyFBEKvPBjQhFX8lyUdcNhFMvfNU2WKF9MBvGVhHv+Cu6ts153wX+dJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r0r6tfWEONWDPI5TboujHK8Vfy21nltNarS+KZYLB3M=;
 b=hxTPvCTrfy2d6LA0IXSxxRIOfsWMQ9vN+Zk3z6+r8fiTKWldoYLFsJHKQybXfjzqp7tZCOtYbGU+qSs1NuyccEerqsAwxFLDu/xPEhRrt3q0FMiFHMbNRVoAw8Q0/1jPs+bvxl5HBpzGuEne6JQLy+LJww7kE+J0Q8X0OS0XdTL0otbaaYcV+2z+g8TUFustNh3uLZZuIkQ6A90bCX/Y3VommJOyaN+p0mp/16HEXPIsCgy3in8RCvOwj5ph7EtidmJ/j+2G8Cn5qKI0hlh6XRpCpawih32U1wBRWIuyI/tPkyxt4U7YVl+z2UxujcO4kOk04DuYYiJXwd/FjPSPYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH0PR11MB5143.namprd11.prod.outlook.com (2603:10b6:510:3f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.41; Mon, 6 May
 2024 11:15:15 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.7544.041; Mon, 6 May 2024
 11:15:15 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Edgecombe,
 Rick P" <rick.p.edgecombe@intel.com>
CC: "Hansen, Dave" <dave.hansen@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org"
	<x86@kernel.org>, "peterz@infradead.org" <peterz@infradead.org>,
	"hpa@zytor.com" <hpa@zytor.com>, "mingo@redhat.com" <mingo@redhat.com>,
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "jgross@suse.com" <jgross@suse.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>
Subject: Re: [PATCH 3/5] x86/virt/tdx: Unbind global metadata read with
 'struct tdx_tdmr_sysinfo'
Thread-Topic: [PATCH 3/5] x86/virt/tdx: Unbind global metadata read with
 'struct tdx_tdmr_sysinfo'
Thread-Index: AQHaa8I/7Fe3upzx+0yGXqWEQw9AYrGFBbCAgAALCYCAATDKAIAENEsA
Date: Mon, 6 May 2024 11:15:15 +0000
Message-ID: <c488e8ac174a1c4c478c52c2f35344c1dce0bb48.camel@intel.com>
References: <cover.1709288433.git.kai.huang@intel.com>
	 <393931ee1d8f0dfb199b3e81aa660f2af0351129.1709288433.git.kai.huang@intel.com>
	 <ebc3ef050ce889980c46275dac9eb21ab7289b8a.camel@intel.com>
	 <6940c326-bfca-4c67-badf-ab5c086bf492@intel.com>
	 <18f5114bd700f13fac5b36bd322745cb2ea2ab15.camel@intel.com>
In-Reply-To: <18f5114bd700f13fac5b36bd322745cb2ea2ab15.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.3 (3.50.3-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|PH0PR11MB5143:EE_
x-ms-office365-filtering-correlation-id: a2d75911-ea41-44a5-879e-08dc6dbdce4a
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|1800799015|376005|7416005|366007|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?YU0vUnJYNXlWZmthbk9zK013YnZUczU5RHNhYjRQblhRNEQyeVJRSjdUOGJu?=
 =?utf-8?B?eXg5TzVzaS9USW4zOVQ1L0dnUXZSdDlITlo4cXpmSHIxREFESHRWOU1Fai9Z?=
 =?utf-8?B?QU5wQS8yRmUwUnJldE1XNEx1OTJqU0RUcGh3N01hbFpWN0RVaCtRWWliSElq?=
 =?utf-8?B?VG1xNGQxUURNbUswWnlMTUY5ZExORFZPT0szM25CMzBoTTVWRnBLZDcwOGRx?=
 =?utf-8?B?OGRMSW5Rb3ZLU2JvYUxoVGduam1YQTZ2U1ZQMitjVTFFanAyOTRGclhDbWc5?=
 =?utf-8?B?THo3RUM3eHlrMHBMdW9wdUhuRGh4K1dzR2QxbjltMVdhUWd5MmZBcisyUXZ1?=
 =?utf-8?B?V3lrcFdBelB2MU1IaUxEdFBJMlM1OElxckd5eVRLMmdaQXJ3NDBWUVNXUjgv?=
 =?utf-8?B?eWVCL3pVeHUrNFU2MWV1ZG9YWUhuOHluQWkvUUhRZjMvTmh3Zkg5NExncmFS?=
 =?utf-8?B?N3E1cmNwTGN1bDlqTURFZmw0TnBXR0pCekhpM1h2QXlaUGJjR1c3cFZSanl6?=
 =?utf-8?B?VVJ5cnZhUXhkNVNQNXJRSEYwSGhYeUd6SzlyVkJpcDRHRGt0MXJyVDlHUGxQ?=
 =?utf-8?B?aHdTZ3lvb1NVOFFEZzk1bjI1a1pFQVBHbStZN0dxem1GdGVvcnYvZnhWcEFs?=
 =?utf-8?B?M1QzTjNWZXJQeHpzVmhJR0tHNkYrZ1RJNmJDRE9zU1JHMlRQUFhOVEdjekc4?=
 =?utf-8?B?UXVVbk1TNEx0MU5JT2ZlVnVMeWpEQkVtbzRkOGx4Nmp5SW0zdTB5S0ZMVEVv?=
 =?utf-8?B?SDFVWmNPem82eDFxRHhDN21Kc1V5YU1xazdHb3dKWEZ0eXVoMFU5SFlHZW9s?=
 =?utf-8?B?U3AxSUhiREgzcndEUElOVHZabkVya2J6czJDUTRiT1M5ZWs3T2FwL2UzdUZi?=
 =?utf-8?B?OHdCNHdUL2ZzUm1kOEQ4bkk1c0pHYW4wNEZ6SnhhOUhkNUt5d2tjckN3ZDZt?=
 =?utf-8?B?THRyemJaU3ErTzZZY3Y2d0FwU1ZQQWdJSUdVdHhJbGp5VE5qdTVLSkhCcVgr?=
 =?utf-8?B?RlF5YkdKc283R3QwU3NTOVlRZ0FtS3djckJtOUxnd2RndTMyWkh3ZjZvam9D?=
 =?utf-8?B?MlZ5UWU2amhFK0JLcVVhRHo4SGZyOWF2SlZnRkE0STB0b3VYSTNNcTFWYzM5?=
 =?utf-8?B?SWUwZmNLSms1dU8vZWZvblIvbUdRamlLT3hOSUNRNVhuSlRHTGlBUjcrM1Nv?=
 =?utf-8?B?OS9WOXpTQ3ZaSk5od0VZakxXbXpVd1Y2TzFHWk1ZMDBuRlFtWXVUbm9Ya1NY?=
 =?utf-8?B?QllMb2ZTK3hYVG1ubTNuTU93U0c4bHpjK05NZ1hrZWk5M3JnNmNLUVc1ZndD?=
 =?utf-8?B?V3BVZ3M3THpWdFpBT3JTMDNLS05ya09ueFlnazFBNUsxalJTNllXQkllUE15?=
 =?utf-8?B?ZTVzM21oNWk0MzVCMnVaaXYxM2hLQS9Rd3J2M3VVcTZFYXZPK1JFZmZMdVFp?=
 =?utf-8?B?NFh2NGtzMnh3Y1JtZURtSHN4TkhyL04zVDlUNUFUNjBldVFTQS91TU5Jdi9p?=
 =?utf-8?B?b3pad2pLQ1ZHbmdQRm05NXdXS05SeWtxcmFEeXVRMFVRbVcrZGFHZXFUU0NQ?=
 =?utf-8?B?RWY5a1MrRU5HNzBpbmxGRFdYT3BWdDdsTStDS0orQzM2M1c5T2xDODF4QlBL?=
 =?utf-8?B?QXVzVzJzMkpXYkhRR2ZkTkMyczlCeENFS2hTTThmczg4MVhrL3lNaVl3bWxH?=
 =?utf-8?B?RnpQV29QbG1NeTM3TUxYMkFxSDBweW1oWUYxcnJ2cTdjMnJ5K0xkbDE1SzI2?=
 =?utf-8?B?M3B3MWhmUkRSR3N0TmU1UWdZaTg0K3NTeE1yMGZtQzRSaW5jZDlJMGhadGtU?=
 =?utf-8?B?WU1hSXRORHZhZmJHckNTUT09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(7416005)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dFczbStLNmRBS3VITk5FWTZTclYxOXgvSjErQXBPZ2ZHeFZoM3RRTC9sNE8y?=
 =?utf-8?B?Q3lTZzdFYnk0VG40Y1BjNlBTcmk4UVJpRXhxc05oWndZa25IRVl5SGZ3SjF5?=
 =?utf-8?B?aVJzaDIvUXYwZDQxME56a3pya3ZsekdXcXA2WnllbEJDaUJPa2lHSjlGeEg5?=
 =?utf-8?B?OTlkTjhWMkxicGJHejBoRURpUXV2cjJOYm4xc0FhNTlGV0hLSFRoeFE1MG9C?=
 =?utf-8?B?clVKT3gzUmdBcmdwUVBUNDNUbGt0Z2I2L3pHem44OU51djBwaU9tUHNUcmk5?=
 =?utf-8?B?dGo0bUloeitKUXd1cTNYSnBNZ1ZZT2VMWGVGSHpvSThDSU4wNWZJcGtXWG03?=
 =?utf-8?B?WlJPWDVMVE51bHRKZUl6M1psaEhxemIveXEyUDBETWxzRVNxaWk0Q3lPUjZ3?=
 =?utf-8?B?YkVYdHRIMW1GNW5NMHpBcWtyZkwvck4vdUc1WkVoMkxoUGRsdW9rbUl5QW5H?=
 =?utf-8?B?ektja3pISDdlV3FPUzU5R3dOYVBLUDl4eTQrdG9WaEdWeFFLYUtKbWNkOEIw?=
 =?utf-8?B?LzJpd0pJUEpzMlpwMTRWY01iZkhFcTg1dDd0VXd5Vzg4Z0NjVlpqY2hCbVVz?=
 =?utf-8?B?dFBDN1ZSd24wMmVRdUlkM1hidkxPRndZMVRVREJRL1huRnppQmZ1bUxPa09K?=
 =?utf-8?B?alU4bVNWWHJxYXNzTUs0RHZyZzlrSFN4dE4wdG5JRXRUbytrVENaVFNjWTlO?=
 =?utf-8?B?TzNwamY5NXEzSHFQQlhoMlZMOE5QR0ZxVjRteGljK1o1eEJUVjVhbEpkQlBX?=
 =?utf-8?B?aTVRWWVoYlFsaUllV2ZFalpUSjhZN2pnMFFTa21naFZNVTJzZE1wcWc2QUJx?=
 =?utf-8?B?V2FKTTFhd3dOajlQMEJ3UmpOYUxKY3FqMjI3RkcwdjdDRlFUMTVwM2hmQWZu?=
 =?utf-8?B?T1VEbXlsRG42VEhYRHlRcVBPemp6K09ubEgxbEZsU1MyNzJXMVJXeTcveTQ3?=
 =?utf-8?B?WWhnZEVvR0gzQUhldEFzbVFab0FGbG55SkM0T0RwWEVnZUd1ZDR3d3RBLzRM?=
 =?utf-8?B?OXo4dWpnRlFWOTdhMkt3S21UT1B1SDBKaUZ4RDZJTlRvdi9SYVpJTnMvaDZB?=
 =?utf-8?B?RUQrNElhT01MMGdTdGowUUFkeHdvRTB2R2FCdCtLK0xlRS9HZnMrdkxTcUl1?=
 =?utf-8?B?ZHRmU0tBd1VYYWtTdGZoaXpZckMxZ3JWdkVVK05lUEluYTZrRDQrb2xMSk4z?=
 =?utf-8?B?MlRIb3RtOFVjVEJIb1NXU1ppNndHLzN3bmRXWW54QUpPcnM3N2xreGFudUtw?=
 =?utf-8?B?S0twMk1tcXBzQm1MYmt4YzUwZTIyMmoxZEEzNTJUaXBIaU4rNmxzMlBMUDNa?=
 =?utf-8?B?aEh0ajdnbFl0ZUNJSWI1K3BTYmFLMWhlbVFwR292SXR3QmU2UytMREozQzQz?=
 =?utf-8?B?cmFjcERwekZES1ZodnQ1cFJsQUhPN21BUXpxMU0vaFRaQWtzMUxkeGxNVGJn?=
 =?utf-8?B?WDhYM0thRlNjVlh5bVByQ1RaZ2hXTEtTRFhNNi9oZVh5QUY0d0FLbi9DSTFG?=
 =?utf-8?B?enRiZTgvQlQyMEo5NnM4MTJRWWpNYTRZOHQ5UGlld1JJNitMOUlnVVlIZHps?=
 =?utf-8?B?SXBBajhkWXp6Yzh6SXVpQTNKck1vZ1k3RTEzQmZITjFWU2tPQ1RVa004UUhS?=
 =?utf-8?B?bGR2My9lOHREODVXeStZcnF2UVVIWHRDT1dxK0dtZmdHS2ViZ1QwUkdweE9t?=
 =?utf-8?B?NDJWajZISlNkK3dLV3lzamI5NG5DNUxtOVNMRWU0R1V0ZWQxVEdYNDI0RExk?=
 =?utf-8?B?YTRWN1Z2c1Eya3U0UDNSZG9wdG1wbm53c1pIM05ITTFVb28rZ2k1ZkdVaSta?=
 =?utf-8?B?cHQyNzFVUUVIYjRtSHFhNjB6azVxNEJCeEFYalNnTXdUQlJzd2wzc2FoQVRy?=
 =?utf-8?B?VUU5NDhFeTdUaW1nblBJODhOb0pZT1hWek9tSUs3MVhrbVVZVFo2eW5ZeXBN?=
 =?utf-8?B?YmU0ZnhGQ0pmY1ZTc0pKTU9xRlU3Mko1aXl1dTRrSHJiUFk1Y0xqbGZvQU1P?=
 =?utf-8?B?WGU0MXcySUI5SEZMemU0bHhkNjRIOHJoSXA2M2lNYmp4UzIwTURXdENmaFR1?=
 =?utf-8?B?Ti9oRFlrTkVqN2hEMDY4VHlpUTBxZC9MSlh6Q1VETzVlNWhVWG5HNVdGdzhy?=
 =?utf-8?Q?BbOSAXc7riLTsPJ7yqVS51U4P?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <96419DF6CCE81643A17F176C645E2E93@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a2d75911-ea41-44a5-879e-08dc6dbdce4a
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 May 2024 11:15:15.6809
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Pz4lAO2qwbNt/PTUeGj/5L4ZL8Ch5D//3IUWe1Vho8hz0FwerurGn2ynXscGzeGnocBCDfZXFPv6NtsjDbQ7pQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5143
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI0LTA1LTAzIGF0IDE5OjAzICswMDAwLCBFZGdlY29tYmUsIFJpY2sgUCB3cm90
ZToNCj4gT24gRnJpLCAyMDI0LTA1LTAzIGF0IDEyOjUyICsxMjAwLCBIdWFuZywgS2FpIHdyb3Rl
Og0KPiA+ICINCj4gPiBUaGUgbWV0YWRhdGEgcmVhZGluZyBjb2RlIHVzZXMgdGhlIFREX1NZU0lO
Rk9fTUFQKCkgbWFjcm8gdG8gZGVzY3JpYmUgDQo+ID4gdGhlIG1hcHBpbmcgYmV0d2VlbiB0aGUg
bWV0YWRhdGEgZmllbGRzIGFuZCB0aGUgbWVtYmVycyBvZiB0aGUgJ3N0cnVjdCANCj4gPiB0ZHhf
dGRtcl9zeXNpbmZvJy7CoCBJLmUuLCBpdCBoYXJkLWNvZGVzIHRoZSAnc3RydWN0IHRkeF90ZG1y
X3N5c2luZm8nIA0KPiA+IGluc2lkZSB0aGUgbWFjcm8uDQo+IA0KPiBIb3cgYWJvdXQ6DQo+IA0K
PiBUaGUgVERYIG1vZHVsZSBpbml0aWFsaXphdGlvbiBjb2RlIGN1cnJlbnRseSB1c2VzIHRoZSBt
ZXRhZGF0YSByZWFkaW5nDQo+IGluZnJhc3RydWN0dXJlIHRvIHJlYWQgc2V2ZXJhbCBURFggbW9k
dWxlIGZpZWxkcywgYW5kIHBvcHVsYXRlIHRoZW0gYWxsIGludG8gdGhlDQo+IHNhbWUga2VybmVs
IGRlZmluZWQgc3RydWN0LCAic3RydWN0IHRkeF90ZG1yX3N5c2luZm8iLiBTbyB0aGUgaGVscGVy
IG1hY3JvcyBmb3INCj4gbWFyc2hhbGluZyB0aGUgZGF0YSBmcm9tIHRoZSBURFggbW9kdWxlIGlu
dG8gdGhlIHN0cnVjdCBmaWVsZHMgaGFyZGNvZGUgdGhhdA0KPiBzdHJ1Y3QgbmFtZS4NCj4gDQo+
ID4gDQo+ID4gQXMgcGFydCBvZiB1bmJpbmRpbmcgbWV0YWRhdGEgcmVhZCB3aXRoICdzdHJ1Y3Qg
dGR4X3RkbXJfc3lzaW5mbycsIHRoZSANCj4gPiBURF9TWVNJTkZPX01BUCgpIG1hY3JvIG5lZWRz
IHRvIGJlIGNoYW5nZWQgdG8gYWRkaXRpb25hbGx5IHRha2UgdGhlIA0KPiA+IHN0cnVjdHVyZSBh
cyBhcmd1bWVudCBzbyBpdCBjYW4gYWNjZXB0IGFueSBzdHJ1Y3R1cmUuwqAgVGhhdCB3b3VsZCBt
YWtlIA0KPiA+IHRoZSBjdXJyZW50IGNvZGUgdG8gcmVhZCBURE1SIHJlbGF0ZWQgbWV0YWRhdGEg
ZmllbGRzIGxvbmdlciBpZiB1c2luZyANCj4gPiBURF9TWVNJTkZPX01BUCgpIGRpcmVjdGx5Lg0K
PiANCj4gRnV0dXJlIGNoYW5nZXMgd2lsbCBhbGxvdyBmb3Igb3RoZXIgdHlwZXMgb2YgbWV0YWRh
dGEgdG8gYmUgcmVhZCwgdGhhdCBkb24ndA0KPiBtYWtlIHNlbnNlIHRvIHBvcHVsYXRlIHRvIHRo
YXQgc3BlY2lmaWMgc3RydWN0LiBUbyBhY2NvbW1vZGF0ZSB0aGlzIHRoZSBkYXRhDQo+IG1hcnNo
YWxpbmcgbWFjcm8sIFREX1NZU0lORk9fTUFQLCB3aWxsIGJlIGV4dGVuZGVkIHRvIHRha2UgZGlm
ZmVyZW50IHN0cnVjdHMuDQo+IFVuZm9ydHVuYXRlbHksIGl0IHdpbGwgcmVzdWx0IGluIHRoZSB1
c2FnZSBvZiBURF9TWVNJTkZPX01BUCBmb3IgcG9wdWxhdGluZw0KPiBzdHJ1Y3QgdGR4X3RkbXJf
c3lzaW5mbyB0byBjaGFuZ2UgdG8uLi4gW3NvbWUgdW5kZXNpcmFibGUgc2l0dWF0aW9uXS4NCg0K
SSdsbCBjaGFuZ2UgdG8gdXNlIHlvdXIgd29yZHMsIHdpdGggc29tZSBzbWFsbCB0d2Vha3MgdG8g
YWxzbyBtZW50aW9uIHRoZQ0KZnVuY3Rpb24gdG8gcmVhZCBtZXRhZGF0YSBmaWVsZCBzaG91bGQg
YWxzbyBiZSByZWxheGVkIHRvIHRha2UgYSB0eXBlbGVzcw0KJ3ZvaWQgKicgYnVmZmVyLg0KDQpQ
bGVhc2Ugc2VlIGJlbG93Lg0KDQo+IA0KPiBRdWVzdGlvbiBmb3IgeW91Og0KPiBJcyB0aGlzIGp1
c3QgdG8gbWFrZSBpdCBzaG9ydGVyLCBvciB0byBhdm9pZCBkdXBsaWNhdGlvbiBvZiBzcGVjaWZ5
aW5nIHRoZQ0KPiBzdHJ1Y3QgbmFtZT/CoA0KPiANCg0KVGhlIGludGVudGlvbiB3YXMgdG8gbWFr
ZSBpdCBzaG9ydGVyLCBidXQgSSB0aGluayBib3RoLg0KDQo+IExpa2UgaXMgaXQgYSBtaXRpZ2F0
aW9uIGZvciBleGNlZWRpbmcgODAgY2hhcnMgb3IgMTAwPw0KDQpZZXMgZm9yIG5vdCBleGNlZWRp
bmcgMTAwLg0KDQpXaXRoIHRoaXMgcGF0Y2gsIHRoZSBjb2RlIGFjdHVhbGx5IGV4Y2VlZHMgODAg
Y2hhcnMsIGJ1dCBJIGZvdW5kIGJyZWFraW5nDQp0aGVtIHRvIHNlcGFyYXRlIGxpbmVzIGh1cnQg
dGhlIHJlYWRhYmlsaXR5Lg0KDQo+IA0KPiA+IA0KPiA+IERlZmluZSBhIHdyYXBwZXIgbWFjcm8g
Zm9yIHJlYWRpbmcgVERNUiByZWxhdGVkIG1ldGFkYXRhIGZpZWxkcyB0byBtYWtlIA0KPiA+IHRo
ZSBjb2RlIHNob3J0ZXIuDQo+ID4gIg0KPiA+IA0KPiA+IEJ5IHR5cGluZywgaXQgcmVtaW5kcyBt
ZSB0aGF0IEkga2luZGEgbmVlZCB0byBsZWFybiBob3cgdG8gc2VwYXJhdGUgdGhlIA0KPiA+ICJo
aWdoIGxldmVsIGRlc2lnbiIgdnMgImxvdyBsZXZlbCBpbXBsZW1lbnRhdGlvbiBkZXRhaWxzIi7C
oCBJIHRoaW5rIHRoZSANCj4gPiBsYXR0ZXIgY2FuIGJlIHNlZW4gZWFzaWx5IGluIHRoZSBjb2Rl
LCBhbmQgcHJvYmFibHkgY2FuIGJlIGF2b2lkZWQgaW4gDQo+ID4gdGhlIGNoYW5nZWxvZy4NCj4g
DQo+IEVzcGVjaWFsbHkgZm9yIFREWCB3aXRoIGFsbCBpdCdzIGNvbXBsZXhpdHkgYW5kIGFjcm9u
eW1zIEkgdGhpbmsgaXQgaGVscHMgdG8NCj4gZXhwbGFpbiBpbiBzaW1wbGUgdGVybXMuIExpa2Ug
aW1hZ2luZSBpZiBzb21lb25lIHdhcyB3b3JraW5nIGF0IHRoZWlyIGNvbXB1dGVyDQo+IGFuZCB5
b3UgdGFwcGVkIG9uIHRoZWlyIHNob3VsZGVyLCBob3cgd291bGQgeW91IGludHJvZHVjZSB0aGlz
IGNoYW5nZT8gSWYgeW91DQo+IHN0YXJ0IHdpdGggIlRETVIgcmVsYXRlZCBnbG9iYWwgbWV0YWRh
dGEgZmllbGRzIiBhbmQgInN0cnVjdCB0ZHhfdGRtcl9zeXNpbmZvIg0KPiB0aGV5IGFyZSBnb2lu
ZyB0byBoYXZlIHRvIHN0cnVnZ2xlIHRvIGNvbnRleHQgc3dpdGNoIGludG8gaXQuDQo+IA0KPiBG
b3IgZWFjaCBwYXRjaCwgaWYgdGhlIGNvbm5lY3Rpb24gaXMgbm90IGNsZWFyLCBlYXNlIHRoZW0g
aW50byBpdC4gT2YgY291cnNlDQo+IGV2ZXJ5b25lIGhhcyB0aGUgZGlmZmVyZW50IHByZWZlcmVu
Y2VzLCBzbyBZTU1WLiBCdXQgZXNwZWNpYWxseSB0aGUgdGlwIGZvbGtzDQo+IHNlZW0gdG8gYXBw
cmVjaWF0ZSBpdC4NCj4gDQo+ID4gDQo+ID4gSSBhbSBub3Qgc3VyZSB3aGV0aGVyIGFkZGluZyB0
aGUgVERfU1lTSU5GT19NQVBfVERNUl9JTkZPKCkgbWFjcm8gYmVsb25nIA0KPiA+IHRvIHdoaWNo
IGNhdGVnb3J5LCBlc3BlY2lhbGx5IHdoZW4gSSBuZWVkZWQgYSBsb3QgdGV4dCB0byBqdXN0aWZ5
IHRoaXMgDQo+ID4gY2hhbmdlICh0aHVzIEkgd29uZGVyIHdoZXRoZXIgaXQgaXMgd29ydGggdG8g
ZG8pLg0KPiA+IA0KPiA+IE9yIGFueSBzaG9ydGVyIHZlcnNpb24gdGhhdCB5b3UgY2FuIHN1Z2dl
c3Q/DQo+ID4gDQo+IA0KPiBJIGRvbid0IHRoaW5rIGl0IGlzIHRvbyBsb25nLg0KDQpUaGUgbmV3
IGNoYW5nZWxvZyBiYXNlZCBvbiB5b3VyIHdvcmRzOg0KDQpUaGUgVERYIG1vZHVsZSBpbml0aWFs
aXphdGlvbiBjb2RlIGN1cnJlbnRseSB1c2VzIHRoZSBtZXRhZGF0YSByZWFkaW5nDQppbmZyYXN0
cnVjdHVyZSB0byByZWFkIHNldmVyYWwgVERYIG1vZHVsZSBmaWVsZHMsIGFuZCBwb3B1bGF0ZSB0
aGVtIGFsbA0KaW50byB0aGUgc2FtZSBrZXJuZWwgZGVmaW5lZCBzdHJ1Y3QsICJzdHJ1Y3QgdGR4
X3RkbXJfc3lzaW5mbyIuICBTbyB0aGUNCmZ1bmN0aW9uIHRvIHJlYWQgdGhlIG1ldGFkYXRhIGZp
ZWxkcyBhbmQgdGhlIGhlbHBlciBtYWNyb3MgZm9yIG1hcnNoYWxpbmcNCnRoZSBkYXRhIGZyb20g
dGhlIFREWCBtb2R1bGUgaW50byB0aGUgc3RydWN0IGZpZWxkcyBoYXJkY29kZSB0aGF0IHN0cnVj
dA0KbmFtZS4NCg0KRnV0dXJlIGNoYW5nZXMgd2lsbCBhbGxvdyBmb3Igb3RoZXIgdHlwZXMgb2Yg
bWV0YWRhdGEgdG8gYmUgcmVhZCwgdGhhdA0KZG9uJ3QgbWFrZSBzZW5zZSB0byBwb3B1bGF0ZSB0
byB0aGF0IHNwZWNpZmljIHN0cnVjdC4gIFRvIGFjY29tbW9kYXRlDQp0aGlzLCBjaGFuZ2UgdGhl
IG1ldGFkYXRhIHJlYWRpbmcgZnVuY3Rpb24gdG8gdGFrZSBhIHR5cGVsZXNzICd2b2lkIConDQpi
dWZmZXIsIGFuZCBleHRlbmQgdGhlIGRhdGEgbWFyc2hhbGluZyBtYWNybywgVERfU1lTSU5GT19N
QVAsIHRvIHRha2UNCmRpZmZlcmVudCBzdHJ1Y3RzLg0KDQpVbmZvcnR1bmF0ZWx5LCB0aGlzIHdp
bGwgcmVzdWx0IGluIHRoZSB1c2FnZSBvZiBURF9TWVNJTkZPX01BUCBmb3INCnBvcHVsYXRpbmcg
J3N0cnVjdCB0ZHhfdGRtcl9zeXNpbmZvJyB0byBiZSBjaGFuZ2VkIHRvIHVzZSB0aGUgc3RydWN0
IG5hbWUNCmV4cGxpY2l0bHkgZm9yIGVhY2ggc3RydWN0IG1lbWJlciBhbmQgbWFrZSB0aGUgY29k
ZSBsb25nZXIuICBEZWZpbmUgYQ0Kd3JhcHBlciBtYWNybyBmb3IgcmVhZGluZyBURE1SIHJlbGF0
ZWQgbWV0YWRhdGEgZmllbGRzIHRvIG1ha2UgdGhlIGNvZGUNCnNob3J0ZXIsIGkuZS4sIG5vdCBl
eGNlZWRpbmcgdGhlIDEwMCBjaGFyYWN0ZXJzIGxpbWl0IHdoaWxlIHN0aWxsIGtlZXBpbmcNCnRo
ZSB1c2Ugb2YgVERYX1NZU0lORk9fTUFQIGZvciBlYWNoIHN0cnVjdCBtZW1iZXIgaW4gb25lIGxp
bmUgZm9yIGJldHRlcg0KcmVhZGFiaWxpdHkuIA0KDQo=

