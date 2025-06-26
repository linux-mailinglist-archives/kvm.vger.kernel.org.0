Return-Path: <kvm+bounces-50870-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E4321AEA583
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 20:37:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2DD854A432C
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 18:37:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B20722EE610;
	Thu, 26 Jun 2025 18:37:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XYJovZw9"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2A211DF739;
	Thu, 26 Jun 2025 18:37:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750963066; cv=fail; b=f3kwi0XqXt5EobaHSCocOuQtTDiBWomTqEZxLw28szx1xuNF0J4GAhYVSIxjK02SJZ6No4vgpB9eP02mEwBqVU5xYvFf3TlPb51qCBpcNYw2IAU0UskGDYp5Uub2k9PQ1VAhSeg741lG4QuX39bNATfn/Clwdn1k44JRaJhud8I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750963066; c=relaxed/simple;
	bh=w2R0CQY4mTxSqJnd1svn9EgipFgHRno98ymdb7PAxE4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ZTq8zR6N7QuhiHLbMxF9t7OKN3vMlSYLHDVVqsJmEYnEqXjP/4dcKKTa5TNVVBAUZLALCnYOeyzjvwziunZYGJj/MLZX+VyQKZFcymu77FYHCQyiHRtOSDSNmGRuPEhh2W3Elh5D0DBEdvYIrq1AoB0aRPcbVZdHA7QV1dtsSnk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XYJovZw9; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750963064; x=1782499064;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=w2R0CQY4mTxSqJnd1svn9EgipFgHRno98ymdb7PAxE4=;
  b=XYJovZw96+DqGsMQbGCXXPcvIoHA7dkvdyJR+GhS1XKZ9VBYUq3VC+Ib
   TWqwTKWQohwDMAm2+EoTNEtM2LpmaZXmCbqST/7ZJk+mXwioyR5u+iYI1
   yGpLMh+IP5PyO3p5UlOFf0DcRuozKaufEO4LdBwpIM99QFe6Kx2LUCsWX
   dhTdtIBryOeXpp99q+6quEu1yofRJPWlyrsWaZHTDS7vzMW9MxHrgmi4t
   +AQm4HLMuSKp3oqxH+m3bLJnhFOz+cMsrXCrln3uDGPOl7Qx9eMHTENxN
   Zg0pJ+FXUAPB76xY9+7+Thm2JCFZJLosAj+76gNhf/1HLaIQSn93NbHz3
   A==;
X-CSE-ConnectionGUID: XJehbxdTQGy8q1w1A6BWDA==
X-CSE-MsgGUID: wnP67LYRTfmu//9ENW9Whg==
X-IronPort-AV: E=McAfee;i="6800,10657,11476"; a="53414606"
X-IronPort-AV: E=Sophos;i="6.16,268,1744095600"; 
   d="scan'208";a="53414606"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2025 11:37:44 -0700
X-CSE-ConnectionGUID: iiX8x1tUSLiQ5Gw0OtD7zQ==
X-CSE-MsgGUID: sR30zlLXT0Kzm4YknY9jnQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,268,1744095600"; 
   d="scan'208";a="176267652"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2025 11:37:44 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 26 Jun 2025 11:37:43 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Thu, 26 Jun 2025 11:37:43 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (40.107.220.61)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 26 Jun 2025 11:37:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=u+TotoBP60vgVwr3xLeCT8ut68zPdAqgS8FU/YV9AKpdyojigguZxzifcXvS+JoGtxBL0ncqeJv7Q7xJAqkGPpeNI3IGwtIuXoNQxSFDTa8gehA0BxwHGjUWMUfUmLV6pyZOeRbFwXv+rHtLFuHOzwdHBu2AXH0o3R2YbE/NrmXJJM89lP46WOt8TqtUyr7rOqkYrSrYo4iuCIYluoJGhIULqo39CIULwsxKBfdVJbDA4RN+Meq4Z39FCajeSGMFk1o/4T38iMl20VLtSuCa46ezjQ/Hm8T7pRTVoEcpF2Fhr6niCHBZqEPL7XMnm6/hTEXOcK6uvtXcl162l797Uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w2R0CQY4mTxSqJnd1svn9EgipFgHRno98ymdb7PAxE4=;
 b=NbYRmzBbxMv5scj6db1NKk9+RBCUcaSGzniw47OQwdR5A874e1rJQi5nvkrZY7UrMTj1XMbikfSGcXryqGrDFeHUEWSYNDod+jWgja2vdeEPrMq40A/6RGDozfUtFYB4zL/VS8EK90K7KA2WUZrPtqhBZaKiTxF9ax0dUQScosXfBx8xJKu36IAtIOEm4epYqL5zKaZG+qS30mXZUhmsxvqcJ3sIv175EYZ0B4b7gH2+GDDZjj5YjKBKS4bhK+42q5MswMkj9U30W/zwxSjjCfkRK1C4hZuZln7pE1MF6P3z5K77qOd1iq51a7fiVPonUoBiyA0ncLROO9PpJVQhMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by BL1PR11MB6026.namprd11.prod.outlook.com (2603:10b6:208:391::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.28; Thu, 26 Jun
 2025 18:37:19 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.8857.025; Thu, 26 Jun 2025
 18:37:18 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Hansen, Dave" <dave.hansen@intel.com>, "Huang, Kai"
	<kai.huang@intel.com>, "bp@alien8.de" <bp@alien8.de>, "peterz@infradead.org"
	<peterz@infradead.org>, "hpa@zytor.com" <hpa@zytor.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>
CC: "seanjc@google.com" <seanjc@google.com>, "x86@kernel.org"
	<x86@kernel.org>, "sagis@google.com" <sagis@google.com>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "kirill.shutemov@linux.intel.com"
	<kirill.shutemov@linux.intel.com>, "Williams, Dan J"
	<dan.j.williams@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "ashish.kalra@amd.com" <ashish.kalra@amd.com>,
	"Chen, Farrah" <farrah.chen@intel.com>, "nik.borisov@suse.com"
	<nik.borisov@suse.com>
Subject: Re: [PATCH v3 2/6] x86/virt/tdx: Mark memory cache state incoherent
 when making SEAMCALL
Thread-Topic: [PATCH v3 2/6] x86/virt/tdx: Mark memory cache state incoherent
 when making SEAMCALL
Thread-Index: AQHb5ogI6Y7iL9CkW0uTZON0g1sc7rQVxZ+A
Date: Thu, 26 Jun 2025 18:37:17 +0000
Message-ID: <554c46b80d9cc6c6dce651f839ac3998e9e605e1.camel@intel.com>
References: <cover.1750934177.git.kai.huang@intel.com>
	 <323dc9e1de6a2576ca21b9c446480e5b6c6a3116.1750934177.git.kai.huang@intel.com>
In-Reply-To: <323dc9e1de6a2576ca21b9c446480e5b6c6a3116.1750934177.git.kai.huang@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|BL1PR11MB6026:EE_
x-ms-office365-filtering-correlation-id: a12e36ca-fe19-4e0c-27d7-08ddb4e07aa8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024|38070700018|921020;
x-microsoft-antispam-message-info: =?utf-8?B?TjZrT2ZHSTNialRHejFHajFtZExoV0dXRnBUM2o0eDRITENiWG52VjJRbHpU?=
 =?utf-8?B?N1Z6SGlTcWNuRGpKdTErb0Ftdk9oT0dyczIzMkk3a2NiTERWZklwRytZWExz?=
 =?utf-8?B?N0tKbk1yOTVrZjJQL0VpUC9ZaFJPMkJRdkFlSFErRzlYcndadlRXUTNDWVNk?=
 =?utf-8?B?SHpyd2NHRzZoZkpQcUEyeHZvQWZ6Ny96cnhUMzdwcTJ0ZDRyRU45ZWsxODQ3?=
 =?utf-8?B?RjkzeEV1YU9YcGVtRkJ4NTJQOXBiWUtkc3h6bnJId3Z6L1Z4eWNhaldLaklr?=
 =?utf-8?B?ZXRPb1FPa056V05rRlZVZ2RwMG1HSzRSQmJGRnFUNTFnRXhYQTArRW0vUXdY?=
 =?utf-8?B?K0N6Rk12UzlJRGZ6VE1TUS8yV3o0YzVxdnkvY3RvV0NqYytSWU1sbk9US04r?=
 =?utf-8?B?TDdBM3ZNQm9wTmdyeEtGaTBnRFcxZUprVTRtU0p6cVBmUVVuTndmLzNocGZG?=
 =?utf-8?B?aHdubVU1RGJkcVlFZmhFUWJRcDl1ckVrWDZRTkFZNThBUERPaHB4Y1kyNEhI?=
 =?utf-8?B?U3ZmUUVaZXIzcnh5MkxnR3YwdGlsb1c5WWRUZXc2d2EvTUVDVzQ5OUgyVENE?=
 =?utf-8?B?NXZRMytKNnVYY3QrZ3NBY215bi9mRjB1emhhMm1GSHRGV1ZKQ0g3dTV0U3pT?=
 =?utf-8?B?UUpYdzRZRVk5WGVNbXlnKy9Pck9CUmVFMDZ6VVJldVFzaHlFRlRHV0RBbERC?=
 =?utf-8?B?eUlLQUZVc0RoMWVNekhoNEs1RFp0bk90dENvRlZGTUtlRmhKbEFISlZyMnYw?=
 =?utf-8?B?NU9wOVpyaDMrV3RQZVBFZzhaWkNLaS9adFRCQWZweVJQM1JMRjUzTXdRbjhU?=
 =?utf-8?B?bExyVExGeXR2Ym53QjJKdGMrK28yTGR4NVc3TVZtVFZTMU5zUmE0S1htcHZS?=
 =?utf-8?B?YmEwQzBmbDJJVUVTdk9iQlBreGtxcnN1c3RUV0RKTlJnM3p3eDVoUzEzeEdS?=
 =?utf-8?B?MDVlZUxzME1YRXVISEVvdzQ1S3dVREFxTjlzN2ZXMWJwNE9ycFpPTkdDam5k?=
 =?utf-8?B?bGFNdTQ4S0t3d0YxNktQNjltWmdjOEh1bUdqcmtpOENvMUdPdlZmYm5KbUV1?=
 =?utf-8?B?SEkxUHRHdjZQaXRPL1NqalBnVTcwNXFjWm95M2NaOU8vc1BaVUxzNllZM1p0?=
 =?utf-8?B?bGlSbk5WbnhIdUYwZ0gyRi9Mbk1Bdmd4U2lya1UzU3hGSy9Db1BrZndCOCtY?=
 =?utf-8?B?a01yUEVscTFOSUdpTWY0Wm9uL2Q3TDhqcDdhRDhiMk5pQXExTllya3hQMm9h?=
 =?utf-8?B?eG8wMDJab05acGpWTUVhUHZ1UmhwWDlYYVdSL2MzOGFyUWhsRlIzVEJVZEdq?=
 =?utf-8?B?MWl1TXpwcXhqWDUrVzZKWGFBeVZhaGtpTlgwYVhnbXh3WUNMUkZzbk5wdXJI?=
 =?utf-8?B?Wmh1Q2JjWkdxR2hGY0RzMVMzSlBnV1AwcUpEaEFrb0Q2SnZ3Y09pbW05SnMw?=
 =?utf-8?B?Tmx1YmF4N3B0aU1ZQnNxMWVHR3BLWHNHeHpPaXV4MmRmV3FLZjh2UEltTGR3?=
 =?utf-8?B?SXZCQlV0UTFOcTlJeWIrUE10RWpQWHRzTGQ3QTVEQk9MSmJ6ajQ0NUVXN1Rn?=
 =?utf-8?B?akpYMnpqL0tLVzZja21JVHV2SFJnR0lOMTJmSFJtRllmc3p3TnZVaTdYTW9T?=
 =?utf-8?B?cEU0a0hJRXZhTXI1ZkQ0MTlwN000MVBWL3Bvc1lEa2k5cDNxL09uYjRTQTE2?=
 =?utf-8?B?YjNib3ZNNU9pWjB3cEdFMWVkOUVaSDQzMGhUZXpVMjArSWdrV01MQkhOS0Vi?=
 =?utf-8?B?MmMwa3J0dFVNWStPaVNhTU1CUmFxa1Y0V3hTV1E0TWpDSXFtUmdwc0VxYzdO?=
 =?utf-8?B?OVVzMkY4dGdCVUF1RmNyZnk0V1orcDJGZkVOWU8wSUtuVGlHbC82TjNRZExq?=
 =?utf-8?B?M2UxRmg3SmJOUEx1RHdEWDZVS1lTTHpKNGxXdUltbmxabkNZWTQxVTkxdXlR?=
 =?utf-8?B?UTFscHlRaFlWbWFubEpudGpJOEpqZXd4VkdTbzlpTzJTRUdzMDU0NStiSyti?=
 =?utf-8?Q?Yj4G6ZpreExT+tKk4ZHpLNQUg5P8CA=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(38070700018)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YTdnZTJXd1htNTJ2OTRnYllCYkx0Y2p0NTdxODlrSmwrUVlYZ3BTaFY3RE9E?=
 =?utf-8?B?NEpkQzhlU0NJYzNPQWlyUDQ3VzFpN29qRGpYMERiZFBGNC83TnpTUDlENzRQ?=
 =?utf-8?B?ZGx0Q3JvdFRKRkthTGh5ZXdkS0hmOXdwTUo5aVVCQm02M2NLZlZwYTdqb1kv?=
 =?utf-8?B?cHQwdENZRFo3WGxMY3RGSEZTVHI0MVkxM2RsNExBcGhBZ3lKNmk4WE1obDRO?=
 =?utf-8?B?aEJCMjhIaEpXc0hvOWZCTzIrRXZzMmlVRGpOUjdVSzA3ZWszWkNadXRHZG0x?=
 =?utf-8?B?KzVkdXdQSlJIUFVGZG1pMmUyclVKblovLzh2M0ZyR09KNmR3LzNQdWdPTVN5?=
 =?utf-8?B?TG5LdHQ3VTVJRmVxMnpiaDl3cUpRb0Q4NW1Sa2FUWVB4YTRHRlg3d3NRdmpk?=
 =?utf-8?B?ZUZORXZrVW5aak41ZEFHZzVwQ1pzMXdmQkxZdUNmYmxRMXJaWmdkbzRBVWVw?=
 =?utf-8?B?Vm5MOG5ZVjZqS2FzU1hvM3lndnQxVWlFMUMvT2UvTjc0WVJLU2IxRkpSMyt4?=
 =?utf-8?B?Z2cyb2dVY0FlM0wyblZocGpObkUwVC9ENXF6VUpKVW1LL0lvbVZiQXpVYXhT?=
 =?utf-8?B?NmtYZlNaRUh5ckFOV3RTSTR2WTFYNDloaU5ZbUl0MVBibGFIYUpNcVZJSkVT?=
 =?utf-8?B?bDg1dVQxVk9SYnI4eUFLZ2grTXozcGtpK0hPSE4wWnlIam0zMnFSQTdXT3Jv?=
 =?utf-8?B?UHZISDdKcDdiekRVK0dWT0haSkFFZU82NlNHS3FlSjl6MjhLK2gzRzZxRXNC?=
 =?utf-8?B?Ync1eTU3cDFDTkNmMWJtaEQrVG9CU04zNjFjeUVnd1JlS01ydThpaE4xUk9O?=
 =?utf-8?B?SVk3eHZCYjhWRm1IQ1ZiTjhhc0N2cExSSXp3aGt0SEhYS09vanZkWlFUOU9Q?=
 =?utf-8?B?UnpVekEyMGdRaXgyNVkzRGRRQXBKc0tYSHBVOGRCT1Ntb0JuOGJRb0Uya2tm?=
 =?utf-8?B?MFkyZThpTXp5U3QrRlRPT3VHQWhzVDdYVFdoR0QwMEZqcTdKekNmbkNXNW1N?=
 =?utf-8?B?TG8zekJKVFQ1ayszMnd3aFdTbzNGZUpIazR5NlFIcGR3Q3EweGFCNEhVMHkv?=
 =?utf-8?B?U1dHRzBseEM5Mlk5VmEvdFJEWEtEREkwMFZFdDJPa21sdUpWZjRFTy8wNmFy?=
 =?utf-8?B?elNuU2c3dHJoQWhjQnoyTi9zUFp0L0padG10UDFwOXQwS3Njb1pJZDlMdmhU?=
 =?utf-8?B?TUdOU0NyT0xJTjV1ZWZJbFdLV05Zb25ObEJ2VTFXZEhyRDNZaHN0UWg3YWJw?=
 =?utf-8?B?amludkYwelJmN0hpS1pqVlJtY0VkekFvU09FcTUyWWpmODFtT1p4L1k0c0ZH?=
 =?utf-8?B?MW1jU0pnWXdMREw0dWUzMkNpTGtuOXg4UEQwNWNLa21NemcrVjd3cWhDMGZk?=
 =?utf-8?B?Um96bDBYUmhmN0VjdWNpYmpRTzZkYVk1d1puaXFZQitiaW1vMnhaK2hManZW?=
 =?utf-8?B?bzNDUjdZVG1QYXduV1UxM3Vidlh6UFVVeE5wWFFxdndIUTI5SVFTbmkrcWo0?=
 =?utf-8?B?cndYTy9jZGFZS210N3JvcUNQREptQkxJdXlZSDZjaW5mK25rWG9EVlU4YXdG?=
 =?utf-8?B?NkFxNVFVOTA5Q3pFeFh1L2RGODR0WjBzY2ZGbW5kNml6RnZyVThHbmk5cDVo?=
 =?utf-8?B?aHh2VnBGNnZ0UmNFeFNrQ2hIbFFKNDhSVXhBbW9NdWlZMjU3dWdoekkxV2Fr?=
 =?utf-8?B?VEpMVUJzWERHK2g0Q2RCM2czdmlXU3ZpQU8wUVRwTitKM3UwbDFoTnA4dTBG?=
 =?utf-8?B?Q3I5WVg5amdvRFRldGFXaGpTd1JuV0xrVnVLRml1Vjh6RGJrbUl2V0czRnZP?=
 =?utf-8?B?dXRBeDdpZHYzUGdwTVNrdVdVdGFHT3U2YUd5UVNTQzlRQ1doVVphU05VYUlB?=
 =?utf-8?B?YTRzdW1GZE5FTldENlAxV0ovS2VidENYUjN0RGhLdS9LU0NJUmVONzZKaXNX?=
 =?utf-8?B?cy94V3l2M2xIQ3ZYS0NLTnk5VUl6OTZCUDBQanZTNFFsUis0OFZCeURBVUVt?=
 =?utf-8?B?WFhnOTZKRW9JZ1ZBcHF3UlBrOGRZNHNpSGdjTlh0b2h3TUZGNm56ZzZuUXdm?=
 =?utf-8?B?bmhldTNHbmx2SjhIUXRrUjlFa1hpNnpUdDJYNWRORFcydncrNW1EdEl1Y1Rh?=
 =?utf-8?B?WW1GODZ6S2J6RFE3T1ZPNjZCMzBNMDBObUtKMjlGVXBybTdZOVFQUFB4dlBk?=
 =?utf-8?B?UFE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E5A4971FF7AC0C40BB7250698A882133@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a12e36ca-fe19-4e0c-27d7-08ddb4e07aa8
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jun 2025 18:37:17.9971
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /GJoLbzjBxhHIr4ssFMz9vSlp4KEvAVI4zCZWi8OXM7aqw2HWOKtU3UcGLjBJRyvbMhxd8LJOvIM3KpUq05zSOAQGD8J3JaYt61KaB4MAFs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB6026
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTA2LTI2IGF0IDIyOjQ4ICsxMjAwLCBLYWkgSHVhbmcgd3JvdGU6DQo+IE9u
IFREWCBwbGF0Zm9ybXMsIGF0IGhhcmR3YXJlIGxldmVsIGRpcnR5IGNhY2hlbGluZXMgd2l0aCBh
bmQgd2l0aG91dA0KPiBURFgga2V5SUQgY2FuIGNvZXhpc3QsIGFuZCBDUFUgY2FuIGZsdXNoIHRo
ZW0gYmFjayB0byBtZW1vcnkgaW4gcmFuZG9tDQo+IG9yZGVyLg0KPiANCg0KU2FtZSBjb21tZW50
IGFzIHRoZSBwcmV2aW91cyBwYXRjaC4NCg0KPiAgIER1cmluZyBrZXhlYywgdGhlIGNhY2hlcyBt
dXN0IGJlIGZsdXNoZWQgYmVmb3JlIGp1bXBpbmcgdG8gdGhlDQo+IG5ldyBrZXJuZWwgdG8gYXZv
aWQgc2lsZW50IG1lbW9yeSBjb3JydXB0aW9uIHdoZW4gYSBjYWNoZWxpbmUgd2l0aCBhDQo+IGRp
ZmZlcmVudCBlbmNyeXB0aW9uIHByb3BlcnR5IGlzIHdyaXR0ZW4gYmFjayBvdmVyIHdoYXRldmVy
IGVuY3J5cHRpb24NCj4gcHJvcGVydGllcyB0aGUgbmV3IGtlcm5lbCBpcyB1c2luZy4NCj4gDQo+
IEEgcGVyY3B1IGJvb2xlYW4gaXMgdXNlZCB0byBtYXJrIHdoZXRoZXIgdGhlIGNhY2hlIG9mIGEg
Z2l2ZW4gQ1BVIG1heSBiZQ0KPiBpbiBhbiBpbmNvaGVyZW50IHN0YXRlLCBhbmQgdGhlIGtleGVj
IHBlcmZvcm1zIFdCSU5WRCBvbiB0aGUgQ1BVcyB3aXRoDQo+IHRoYXQgYm9vbGVhbiB0dXJuZWQg
b24uDQo+IA0KPiBGb3IgVERYLCBvbmx5IHRoZSBURFggbW9kdWxlIG9yIHRoZSBURFggZ3Vlc3Rz
IGNhbiBnZW5lcmF0ZSBkaXJ0eQ0KPiBjYWNoZWxpbmVzIG9mIFREWCBwcml2YXRlIG1lbW9yeSwg
aS5lLiwgdGhleSBhcmUgb25seSBnZW5lcmF0ZWQgd2hlbiB0aGUNCj4ga2VybmVsIGRvZXMgU0VB
TUNBTEwuDQogICAgICAgICAgICAgXmENCj4gDQo+IFR1cm4gb24gdGhhdCBib29sZWFuIHdoZW4g
dGhlIGtlcm5lbCBkb2VzIFNFQU1DQUxMIHNvIHRoYXQga2V4ZWMgY2FuDQpOaXQ6ICJUdXJuIG9u
IiBpcyBhIGxpdHRsZSBhbWJpZ3VvdXMuICJTZXQiPw0KDQo+IGNvcnJlY3RseSBmbHVzaCBjYWNo
ZS4NCj4gDQo+IFNFQU1DQUxMIGNhbiBiZSBtYWRlIGZyb20gYm90aCB0YXNrIGNvbnRleHQgYW5k
IElSUSBkaXNhYmxlZCBjb250ZXh0Lg0KDQpTRUFNQ0FMTHMNCg0KPiBHaXZlbiBTRUFNQ0FMTCBp
cyBqdXN0IGEgbGVuZ3RoeSBpbnN0cnVjdGlvbiAoZS5nLiwgdGhvdXNhbmRzIG9mIGN5Y2xlcykN
Cj4gZnJvbSBrZXJuZWwncyBwb2ludCBvZiB2aWV3IGFuZCBwcmVlbXB0X3tkaXNhYmxlfGVuYWJs
ZX0oKSBpcyBjaGVhcA0KPiBjb21wYXJlZCB0byBpdCwgc2ltcGx5IHVuY29uZGl0aW9uYWxseSBk
aXNhYmxlIHByZWVtcHRpb24gZHVyaW5nIHNldHRpbmcNCj4gdGhlIHBlcmNwdSBib29sZWFuIGFu
ZCBtYWtpbmcgU0VBTUNBTEwuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBLYWkgSHVhbmcgPGthaS5o
dWFuZ0BpbnRlbC5jb20+DQo+IFRlc3RlZC1ieTogRmFycmFoIENoZW4gPGZhcnJhaC5jaGVuQGlu
dGVsLmNvbT4NCj4gLS0tDQo+IA0KPiB2MiAtPiB2MzoNCj4gIC0gQ2hhbmdlIHRvIHVzZSBfX2Fs
d2F5c19pbmxpbmUgZm9yIGRvX3NlYW1jYWxsKCkgdG8gYXZvaWQgaW5kaXJlY3QNCj4gICAgY2Fs
bCBpbnN0cnVjdGlvbnMgb2YgbWFraW5nIFNFQU1DQUxMLg0KDQpIb3cgZGlkIHRoaXMgY29tZSBh
Ym91dD8NCg0KPiAgLSBSZW1vdmUgdGhlIHNlbnN0ZW5jZSAibm90IGFsbCBTRUFNQ0FMTHMgZ2Vu
ZXJhdGUgZGlydHkgY2FjaGVsaW5lcyBvZg0KPiAgICBURFggcHJpdmF0ZSBtZW1vcnkgYnV0IGp1
c3QgdHJlYXQgYWxsIG9mIHRoZW0gZG8uIiBpbiBjaGFuZ2Vsb2cgYW5kDQo+ICAgIHRoZSBjb2Rl
IGNvbW1lbnQuIC0tIERhdmUNCj4gDQo+IC0tLQ0KPiAgYXJjaC94ODYvaW5jbHVkZS9hc20vdGR4
LmggfCAyOSArKysrKysrKysrKysrKysrKysrKysrKysrKysrLQ0KPiAgMSBmaWxlIGNoYW5nZWQs
IDI4IGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9hcmNo
L3g4Ni9pbmNsdWRlL2FzbS90ZHguaCBiL2FyY2gveDg2L2luY2x1ZGUvYXNtL3RkeC5oDQo+IGlu
ZGV4IDdkZGVmM2E2OTg2Ni4uZDRjNjI0YzY5ZDdmIDEwMDY0NA0KPiAtLS0gYS9hcmNoL3g4Ni9p
bmNsdWRlL2FzbS90ZHguaA0KPiArKysgYi9hcmNoL3g4Ni9pbmNsdWRlL2FzbS90ZHguaA0KPiBA
QCAtMTAyLDEwICsxMDIsMzcgQEAgdTY0IF9fc2VhbWNhbGxfcmV0KHU2NCBmbiwgc3RydWN0IHRk
eF9tb2R1bGVfYXJncyAqYXJncyk7DQo+ICB1NjQgX19zZWFtY2FsbF9zYXZlZF9yZXQodTY0IGZu
LCBzdHJ1Y3QgdGR4X21vZHVsZV9hcmdzICphcmdzKTsNCj4gIHZvaWQgdGR4X2luaXQodm9pZCk7
DQo+ICANCj4gKyNpbmNsdWRlIDxsaW51eC9wcmVlbXB0Lmg+DQo+ICAjaW5jbHVkZSA8YXNtL2Fy
Y2hyYW5kb20uaD4NCj4gKyNpbmNsdWRlIDxhc20vcHJvY2Vzc29yLmg+DQo+ICANCj4gIHR5cGVk
ZWYgdTY0ICgqc2NfZnVuY190KSh1NjQgZm4sIHN0cnVjdCB0ZHhfbW9kdWxlX2FyZ3MgKmFyZ3Mp
Ow0KPiAgDQo+ICtzdGF0aWMgX19hbHdheXNfaW5saW5lIHU2NCBkb19zZWFtY2FsbChzY19mdW5j
X3QgZnVuYywgdTY0IGZuLA0KPiArCQkJCSAgICAgICBzdHJ1Y3QgdGR4X21vZHVsZV9hcmdzICph
cmdzKQ0KPiArew0KDQpTbyBub3cgd2UgaGF2ZToNCg0Kc2VhbWNhbGwoKQ0KCXNjX3JldHJ5KCkN
CgkJZG9fc2VhbWNhbGwoKQ0KCQkJX19zZWFtY2FsbCgpDQoNCg0KZG9fc2VhbWNhbGwoKSBpcyBv
bmx5IGNhbGxlZCBmcm9tIHNjX3JldHJ5KCkuIFdoeSBhZGQgeWV0IGFub3RoZXIgaGVscGVyIGlu
IHRoZQ0Kc3RhY2s/IFlvdSBjb3VsZCBqdXN0IGJ1aWxkIGl0IGludG8gc2NfcmV0cnkoKS4NCg0K
T2gsIGFuZCBfX3NlYW1jYWxsXyooKSB2YXJpZXR5IGlzIGNhbGxlZCBkaXJlY3RseSB0b28sIHNv
IHNraXBzIHRoZQ0KZG9fc2VhbWNhbGwoKSBwZXItY3B1IHZhciBsb2dpYyBpbiB0aG9zZSBjYXNl
cy4gU28sIG1heWJlIGRvX3NlYW1jYWxsKCkgaXMNCm5lZWRlZCwgYnV0IGl0IG5lZWRzIGEgYmV0
dGVyIG5hbWUgY29uc2lkZXJpbmcgd2hlcmUgaXQgd291bGQgZ2V0IGNhbGxlZCBmcm9tLg0KDQpU
aGVzZSB3cmFwcGVycyBuZWVkIGFuIG92ZXJoYXVsIEkgdGhpbmssIGJ1dCBtYXliZSBmb3Igbm93
IGp1c3QgaGF2ZQ0KZG9fZGlydHlfc2VhbWNhbGwoKSB3aGljaCBpcyBjYWxsZWQgZnJvbSB0ZGhf
dnBfZW50ZXIoKSBhbmQgc2NfcmV0cnkoKS4NCg0KT2ggbm8sIGFjdHVhbGx5IHNjcmF0Y2ggdGhh
dCEgVGhlIGlubGluZS9mbGF0dGVuIGlzc3VlIHdpbGwgaGFwcGVuIGFnYWluIGlmIHdlDQphZGQg
dGhlIHBlci1jcHUgdmFycyB0byB0ZGhfdnBfZW50ZXIoKS4uLiBXaGljaCBtZWFucyB3ZSBwcm9i
YWJseSBuZWVkIHRvIHNldA0KdGhlIHBlci1jcHUgdmFyIGluIHRkeF92Y3B1X2VudGVyX2V4aXQo
KS4gQW5kIHRoZSBvdGhlciBfX3NlYW1jYWxsKCkgY2FsbGVyIGlzDQp0aGUgbWFjaGluZSBjaGVj
ayBoYW5kbGVyLi4uDQoNCkFtIEkgbWlzc2luZyBzb21ldGhpbmc/IEl0IHNlZW1zIHRoaXMgcGF0
Y2ggaXMgaW5jb21wbGV0ZS4gSWYgc29tZSBvZiB0aGVzZQ0KbWlzc2VkIFNFQU1DQUxMcyBkb24n
dCBkaXJ0eSBhIGNhY2hlbGluZSwgdGhlbiB0aGUganVzdGlmaWNhdGlvbiB0aGF0IGl0IHdvcmtz
DQpieSBqdXN0IGNvdmVyaW5nIGFsbCBzZWFtY2FsbHMgbmVlZHMgdG8gYmUgdXBkYXRlZC4NCg0K
DQpTaWRlIHRvcGljLiBEbyBhbGwgdGhlIFNFQU1DQUxMIHdyYXBwZXJzIGNhbGxpbmcgaW50byB0
aGUgc2VhbWNhbGxfKigpIHZhcmlldHkNCm9mIHdyYXBwZXJzIG5lZWQgdGhlIGVudHJvcHkgcmV0
cnkgbG9naWM/IEkgdGhpbmsgbm8sIGFuZCBzb21lIGNhbGxlcnMgYWN0dWFsbHkNCmRlcGVuZCBv
biBpdCBub3QgaGFwcGVuaW5nLg0KDQoNCj4gKwl1NjQgcmV0Ow0KPiArDQo+ICsJcHJlZW1wdF9k
aXNhYmxlKCk7DQo+ICsNCj4gKwkvKg0KPiArCSAqIFNFQU1DQUxMcyBhcmUgbWFkZSB0byB0aGUg
VERYIG1vZHVsZSBhbmQgY2FuIGdlbmVyYXRlIGRpcnR5DQo+ICsJICogY2FjaGVsaW5lcyBvZiBU
RFggcHJpdmF0ZSBtZW1vcnkuICBNYXJrIGNhY2hlIHN0YXRlIGluY29oZXJlbnQNCj4gKwkgKiBz
byB0aGF0IHRoZSBjYWNoZSBjYW4gYmUgZmx1c2hlZCBkdXJpbmcga2V4ZWMuDQo+ICsJICoNCj4g
KwkgKiBUaGlzIG5lZWRzIHRvIGJlIGRvbmUgYmVmb3JlIGFjdHVhbGx5IG1ha2luZyB0aGUgU0VB
TUNBTEwsDQo+ICsJICogYmVjYXVzZSBrZXhlYy1pbmcgQ1BVIGNvdWxkIHNlbmQgTk1JIHRvIHN0
b3AgcmVtb3RlIENQVXMsDQo+ICsJICogaW4gd2hpY2ggY2FzZSBldmVuIGRpc2FibGluZyBJUlEg
d29uJ3QgaGVscCBoZXJlLg0KPiArCSAqLw0KPiArCXRoaXNfY3B1X3dyaXRlKGNhY2hlX3N0YXRl
X2luY29oZXJlbnQsIHRydWUpOw0KPiArDQo+ICsJcmV0ID0gZnVuYyhmbiwgYXJncyk7DQo+ICsN
Cj4gKwlwcmVlbXB0X2VuYWJsZSgpOw0KPiArDQo+ICsJcmV0dXJuIHJldDsNCj4gK30NCj4gKw0K
PiAgc3RhdGljIF9fYWx3YXlzX2lubGluZSB1NjQgc2NfcmV0cnkoc2NfZnVuY190IGZ1bmMsIHU2
NCBmbiwNCj4gIAkJCSAgIHN0cnVjdCB0ZHhfbW9kdWxlX2FyZ3MgKmFyZ3MpDQo+ICB7DQo+IEBA
IC0xMTMsNyArMTQwLDcgQEAgc3RhdGljIF9fYWx3YXlzX2lubGluZSB1NjQgc2NfcmV0cnkoc2Nf
ZnVuY190IGZ1bmMsIHU2NCBmbiwNCj4gIAl1NjQgcmV0Ow0KPiAgDQo+ICAJZG8gew0KPiAtCQly
ZXQgPSBmdW5jKGZuLCBhcmdzKTsNCj4gKwkJcmV0ID0gZG9fc2VhbWNhbGwoZnVuYywgZm4sIGFy
Z3MpOw0KPiAgCX0gd2hpbGUgKHJldCA9PSBURFhfUk5EX05PX0VOVFJPUFkgJiYgLS1yZXRyeSk7
DQo+ICANCj4gIAlyZXR1cm4gcmV0Ow0KDQo=

