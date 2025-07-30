Return-Path: <kvm+bounces-53732-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C40F8B15FDE
	for <lists+kvm@lfdr.de>; Wed, 30 Jul 2025 13:58:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 02AE218C3E9F
	for <lists+kvm@lfdr.de>; Wed, 30 Jul 2025 11:58:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0F12296159;
	Wed, 30 Jul 2025 11:58:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UpfLdHQl"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AC9C78F4C;
	Wed, 30 Jul 2025 11:57:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753876681; cv=fail; b=LnpCIr1QRT5ihHSgZNP052YrZGY0CdFpPlADiLYJqe1cHIaNh4kys4FVqgYUYPxzD09XMDVACaDcHtn0Hgqrb3bQGxlf7X6ftu9uGn12j3TSmGa3QSf9d0fRZPm8vFThV9pU5RMcSXBtl2Zmf5Gs2VP+vv1+nufd9mZ4TIdMpUQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753876681; c=relaxed/simple;
	bh=LT0ZIDYGAYjrpalF+cuzVx3ZIYCrCi1KgW00f2HrgVQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=lsNZq5O+MAFF4EgvsGNL0Or8MFEhMgmMP9rwi2Cw9iita/pGSQoetzfiv3eX5mUbJ8VBBgAWF4nyFOJF6rrCUnhZJYyc66BChkCf+skr+cNfl80EIwF+b8eJwhFGkeCjYDvJzTkZfLGrSjtjuGV73r9a0ujzyFnttaO+iDkZxdc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UpfLdHQl; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753876680; x=1785412680;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=LT0ZIDYGAYjrpalF+cuzVx3ZIYCrCi1KgW00f2HrgVQ=;
  b=UpfLdHQlSjUOfgreY7Iq2S6QNqpuAI8JgiL9PZ6dPA7KEImTYhq4vH9t
   R2kctiClQwgoqZEUeJbdKc1wQrvWC+mFOqZZYjTS0uPbE7gUCWs7JOmKH
   8kcaQUZixhuZC+6/YKfWuteh3YIzydUHTvbydgLKRjuEmtjJ5oF5wYkLh
   6Qeq0srKjbBbhz/yNTxyIuxQnAelWtVFWQAOMeJA9KU+HAjXpolryclbI
   ThatbqthraEUcOm3hLMy8yHwdUVNaCw1uOuKWKx5V/zWbs2ifWYVTZ8pw
   jK2MyHEd8M6sF0hX5C8SwQGXuCZIMi0/9UKLBGU/QkFtgiCbBpGV5Xp5s
   Q==;
X-CSE-ConnectionGUID: zm6wmxrpRa6XXlAE1gLSow==
X-CSE-MsgGUID: C3l34rtyS7OPjcavuhoOlg==
X-IronPort-AV: E=McAfee;i="6800,10657,11507"; a="66445754"
X-IronPort-AV: E=Sophos;i="6.16,350,1744095600"; 
   d="scan'208";a="66445754"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2025 04:57:59 -0700
X-CSE-ConnectionGUID: JbLLLpRzTOGFbLuAmbzkQQ==
X-CSE-MsgGUID: aNr6jRpPSM+yQZEZXatfNA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,350,1744095600"; 
   d="scan'208";a="163313394"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2025 04:57:59 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Wed, 30 Jul 2025 04:57:58 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Wed, 30 Jul 2025 04:57:58 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (40.107.92.44) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Wed, 30 Jul 2025 04:57:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=n/Qx58vEmOEglwaXPmiJ8xpwplJFo2DXIoy4tiCN7wCCoP5BuYIdOn7h98ugTfqRf2SwLcFnRj/G0kwTZqnGVpwN65VJPLMezN+cEZcHq44swTcZ8K7MG0MCjcBJjDuenyXNRGdG80A85S/n5ori5x94AT79W3zIfXHJlhGlRlk0m/UwrTV02LMMijbIiyE5dZl19cwPY/KqmGJBznFLmjExC4JwM4nfs/IrqG1PYB6qY9GDFSRk85KIKlYJ8PIrnyUkWALaAsYZ6AWiQC4wtolAjFpqpO3svUeVov6ep9VvHCInrHMzon+sCkSthZP+73AynxhLxjnh7V6fdLRKDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LT0ZIDYGAYjrpalF+cuzVx3ZIYCrCi1KgW00f2HrgVQ=;
 b=xfFYw7Nm260k2kLCuHIoVaYwEpeQom8TV3oxV6fWG13XcbuEWEoz6KT9qaJ3FFAbDzHIoadi/d3wpbrmXQAnR+f7FSlwvTiT5KHvhV4JEjAPUrOLj6X1yYvLhkAheEesSbuFHm6/ZFQwKNwvOacOW+GCdtPCNk5wRvPqZ6lF6mUOz0KXuYX/qzMGfOhfUo6lOMWN5aZK7d2GnZD+oEfE4wX4mEAI2SQCqHne2DFIr9qYq1vVJQEx7MK6ZCly3TGqYCbsBt2RCDDGr5XnLJ+wtxGfNH+nYanFOLZd/Cit1PHxk2crBPRsWW8mLNLxLs/RWPZAw83hNh/VJfyfbvbZtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by DS7PR11MB6174.namprd11.prod.outlook.com (2603:10b6:8:9a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.24; Wed, 30 Jul
 2025 11:57:08 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%6]) with mapi id 15.20.8964.023; Wed, 30 Jul 2025
 11:57:08 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Luck, Tony" <tony.luck@intel.com>, "Hunter, Adrian"
	<adrian.hunter@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"Annapurve, Vishal" <vannapurve@google.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "mingo@redhat.com" <mingo@redhat.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "linux-edac@vger.kernel.org"
	<linux-edac@vger.kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
	"seanjc@google.com" <seanjc@google.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"bp@alien8.de" <bp@alien8.de>, "Gao, Chao" <chao.gao@intel.com>,
	"x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH 1/2] x86/mce: Fix missing address mask in recovery for
 errors in TDX/SEAM non-root mode
Thread-Topic: [PATCH 1/2] x86/mce: Fix missing address mask in recovery for
 errors in TDX/SEAM non-root mode
Thread-Index: AQHb4Em/yMlXy4vBpkewoE3shZA4ALQJAXsAgAFgjQCADMwmgIAAAM+AgAAQVoCAAAJ5AIAzfjCAgAARk4A=
Date: Wed, 30 Jul 2025 11:57:08 +0000
Message-ID: <287caf7fda25b8ac27211d2e50fa1077e0bf0bf6.camel@intel.com>
References: <20250618120806.113884-1-adrian.hunter@intel.com>
	 <20250618120806.113884-2-adrian.hunter@intel.com>
	 <487c5e63-07d3-41ad-bfc0-bda14b3c435e@intel.com>
	 <ccee2a0f-18fa-4037-bf97-f359e0791bf6@intel.com>
	 <d443db90-ced5-43d0-9f85-ad436e445c3a@intel.com>
	 <9a4752a4-e783-4f03-babf-23c31cee4ff9@intel.com>
	 <SJ1PR11MB60836014330204B2FBCC7418FC45A@SJ1PR11MB6083.namprd11.prod.outlook.com>
	 <79eca29a-8ba4-4ad9-b2e0-54d8e668f731@intel.com>
	 <807ff02d-7af0-419d-8d14-a4d6c5d5420d@intel.com>
In-Reply-To: <807ff02d-7af0-419d-8d14-a4d6c5d5420d@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|DS7PR11MB6174:EE_
x-ms-office365-filtering-correlation-id: 3b2f3fd6-4a9f-42bc-1639-08ddcf6035e1
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?SldNT2tmY0JpRDYrRXl1ZE5SZGZwS1QyVFNPcStaVnlqSDFudUhQSXJvWXdo?=
 =?utf-8?B?REFhbXIvN21tdkpuaWJkOWs3ay9wZ2RBZHhPTmRHUGwxL3JIeUNRWnZHY0J4?=
 =?utf-8?B?cWxoMFJiVld5cUswc1ZwVDJpYlNoYldDd2FUZGpEN0JncSt2MENWWFhnOUZy?=
 =?utf-8?B?NUEvZlFGK25JekNMQ09JdGlLT1FSbVlxdVRrUm5PQTYvc1RQSjVCWnBrTmVo?=
 =?utf-8?B?dWhac1AraG0vVFhCV0VuVExoeTVlTXpucDNHODdHYjRQWVJLd2tPSmdTcGlu?=
 =?utf-8?B?UVpTUjVQS1BXdFM4eC8xMEFyYWJza3BDZ3FleTNSMEFjMjlYVWYvKzVZQnNi?=
 =?utf-8?B?OGR2NHhBK2xSNVJ6VFFPNlpDak44dEJhR2dwRm1DNVVjQXdVM3BNdVppRSs2?=
 =?utf-8?B?NEd0aFJRNWhuMC9mOGlxdEpwRFFuSzYzd3FlbDNKSDFuVDZ5WWlBOHNJSTBL?=
 =?utf-8?B?Tk1qZXBZbFBCOVVKNXUrdWxrSzVNM1pIRXJMVmMzR3AxQk5zMXdOcWV6RFRX?=
 =?utf-8?B?aVB3VWE5Mm1MRTBkb0cwUi90cHVqYkF2Znpxam5rSkNtc0NkTHplQkF6bUFs?=
 =?utf-8?B?WTg4Y2Q3MEJ6aFlnNzZkYWFNSDNZQ3plMWUvUnUwVlpXdzRvUWs2Vno0R1R6?=
 =?utf-8?B?VTNlZ0pKdTRqeFN4WE54NStJUHFndnNiZkpqdmlmNHFCb1cxSldwcURSbUdq?=
 =?utf-8?B?QU5yQmxKNy96WnZHbW5yTDhIa0dEZjZoSjlLcE5mVmZybzB3Y2o4NVpoV1NF?=
 =?utf-8?B?WGNrNTJDNFQvMkRyVzRLUXJobFoveGdtZldUWVAzMzZud2YvUG9WZUNyeGlL?=
 =?utf-8?B?Q2p3NUxiUVA0SXFWWkpIWW1GRTJ4Z1lRWGo4M2tjd3VqWE5TM2tEQmV4VFl1?=
 =?utf-8?B?RmdHcFE0YkFlQTRmK1VKWEpJUW9ibXJUeThuV2dLbmNvSG1HelhqZGtnUVRp?=
 =?utf-8?B?SUM2Ymk5RGozcUdzTWpBOURYY1BkRUkvSXFpRWw5OXlaMkdaTkxDUFFlTDU3?=
 =?utf-8?B?YUo4SVRtcWN0SktjNDZ6MlcvVWxaMVVxbi96dEl6cHR5eWZDTU9DYjBJRUkr?=
 =?utf-8?B?bFNoSjhldE0xdnRscVVxVGRacnRMazdGTVJDYkdYbmJNN0M5dzAyTFZGMktJ?=
 =?utf-8?B?dnNONXlxNjVvMml0cktQZlZPVWJ5ZEgwWnA3MTl3M1BUb09GWU05bUtMRkFh?=
 =?utf-8?B?akJtNVc5NU1lWXp2N082T20wTTFyZlNBVlY3azZ3NC9PdWcrWTJHRGlNbXU4?=
 =?utf-8?B?MGRJc296SXRaekR4MDk1N01RVHFXcXNpUEtRN09kSTZwYks1QjN2b1JsU1JG?=
 =?utf-8?B?Z2hxWEtDeUxBS1RiSTVPcEFTcEg1ZFJUTXVHZzF2YkJLZmNiNmpzZTMyUFl0?=
 =?utf-8?B?bGZ3bER2T1RLYm9mZVdFT090aGJ3ZCswOGUvSjJnK2VDQmF6SldOY1NXKzdy?=
 =?utf-8?B?c05NVGxBbXhxK2FqMzlmQ1kvNEk0MENHMjFPQ094MWhDdFR6dkQ2RUtpWWpr?=
 =?utf-8?B?VzVBWWQ2Y3dsc3BKUzY2U0VUMU9aeitGbnF1Nnh6ZVQzUkpsTjY2b3d2cjF2?=
 =?utf-8?B?ajRBOWFjcFIyd0tQcUprOVFicU1YZmRaeHAxVGQvSjJzRGlqYzdBTkJJamZO?=
 =?utf-8?B?VVZBRTdNekNjUE1ORzBDMk9UNkcxRU1ISWF2L1JTNDc1WElLdXljbDk0eVQ5?=
 =?utf-8?B?czVTa2RIWHVtSjEzK2MzeXNoTk53c0dMUTRRbk5QRTYrQmVIaXRTT2Z1cElU?=
 =?utf-8?B?ZVJjTHh2N3NlYktiR1dsZDZ2SjllSGYwYUR4eFN3V2lhM0JNNXFVYzVzamJs?=
 =?utf-8?B?ZU5oSC82WSs1bXo2RXVkWEpiWnp1Q2VZK2dpTGVQZWdiVGc5SEVIdUNycHNr?=
 =?utf-8?B?TTRBa2JuYjVwV2xrejFWMjZlRzIyVjRxdjJieEptS0VBTGJoaU9YTW9KVW5T?=
 =?utf-8?B?WWJOUDdFNzFpMXpJbndkVzNIQlo1T2xrSnV3MklDbmlZTFdzWDNxVWs4dzNx?=
 =?utf-8?Q?BudPu5klYh5+wQ8AEyeFLcNtKuXg4E=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cTFPTXdlQWRGR3Z2ZnVuYTRiK3BRSVdPK3QxMU5HU25RRWNFZTR6dko5dHQ2?=
 =?utf-8?B?STIveFlnMlBteHhMaFZYeHExYjBSZSt0WjFlK1ZZcWY3VVpKbWMvTldReFAw?=
 =?utf-8?B?S2t4dXpuV0ZObFprSk1rU2xTZ1p2S2RiMXZiM2c4UGpscW14NStOeklwOXJa?=
 =?utf-8?B?N0dJSVJ2dVlDM29HQnlSU1RXWDdMR1NyendleWw2NkxGRGZsZEI0WURFVlYw?=
 =?utf-8?B?U3QzNDZQV1VLRHBMaWxwYkpSL3JoaW9GYlRweXlOY1FaaUdJVGhxcURlOFN6?=
 =?utf-8?B?T2FZS2Z0VTBCa3hVWlI5M3d2WjhqMTR2bW52OE1TaEVlVWFTbmxDVzBPYzho?=
 =?utf-8?B?YS90dlR4L2tycEh2NG9BSHM5d0VGWGZOazFRSEplZlg3cUJhdHFRZVdxUnND?=
 =?utf-8?B?L0RGbTlJbDgrUndrYUloVVBsRmZmT0F0VmJPYU1PMDZhSnRDQzU1aGpBQ0d3?=
 =?utf-8?B?bHpONW5PZjFXWlEwZUJSblZRZ2pDbmNhZEsvdmdocC9RS2drRG5PcEV4TUlm?=
 =?utf-8?B?ekgycW8vaFpKKzcxa1Y2SUptbzMwbTRLbXQ2UGR5aEVheEZjcTg4eGxTOUt0?=
 =?utf-8?B?L0cvMlB6YU1oSzhKRDNLY1pHT1g3eitGVXlwNUVKN05SRGM2eXdQeFFWaU41?=
 =?utf-8?B?ek5mc01kMzR2cStXSnV2TElDM1p3dTM2ek1Da2xCdjdKV292Yk42TUtkeGpE?=
 =?utf-8?B?VG5YYkh0Z0JVeHJlemtqNThlTWpSSTYyS0Zsa05ZRzErbkpVOUZSUi9jSkZQ?=
 =?utf-8?B?SlpXbjdyWndNQTY1eVgyRElIdEhFc0FaMFA0ekZPUUtqcGJOV1ZPeDRkSWdq?=
 =?utf-8?B?NVZmanBzdVRPMzZneWZFTFZ1ZytUNTI0V0szKzVPY29IbnFycjhBOC9FQnFw?=
 =?utf-8?B?dXZwVUp4Z0Z1VFFEQjl1akVuQ3p0alBiZmtxdzhpL0VtdkRyRWdoeTJMR29F?=
 =?utf-8?B?QVpjSmdnYVdNRVJ4WWlJb05NdkcrYnJTdStnQ2FoZmlvSkpiWnZ1QWJVbExx?=
 =?utf-8?B?L1Nhc1Jvc0t2N1NpVEhRVDRpa3pBSzVMYWpiVC9JMlpVUWJSWmUwbHZKRXgx?=
 =?utf-8?B?QkxndWYvdUsxYnp2cytaT0JXZ20va1hYUU9HZUkzVlpFcUZXMHZXcUE2aXZj?=
 =?utf-8?B?OWxaTkF1Q2h2RDc3UTFlVUV0MDk5NmVXazdEWDN0dUZ6Y0dSK01NWmJDSjJS?=
 =?utf-8?B?Q3JxODAzYmQ5OUJLNVdCKytRVXY0ZDc4cktrKzQxcVJldlU4YjcvMHlENG5V?=
 =?utf-8?B?NFdkWWcrOVduUlZjR255ZHVuZnpRbGJtSElDMExadHQ2a0U5KzRBTHVETy9q?=
 =?utf-8?B?NFluOEZXRnNHaWIxdzVycWVIeXNDOUZwbnFnb0VnV05RVUNSM3NpRCtHOUI3?=
 =?utf-8?B?N1psVU0zeHgwYjIrb0puTVVKeWprK0pkS1NnSXdkbkh1TzJWQmRINXFmYjNu?=
 =?utf-8?B?RlJRL2hSazR6ekRyUmFxVWNzeWNXcGtzSXJBbzJkejVMYTZkbHNQVUVZekZ3?=
 =?utf-8?B?S3JpOWRwZ3pnanRjVWVTUDduYjUvYWxCS0FuQkxpczlubjJycGVKbVZPWjQ2?=
 =?utf-8?B?cWRpRFpsS3h6SkNTODVKR2tSUjNMUkJrdEJ6Y1ZSSEo5eUl5aGZ6cjZhR0Fv?=
 =?utf-8?B?a2xPeGpvUzNzQlo4NEVUZzhTWGZRa3I4aFVscXFmb3V4K0s5dzhuUXRyWVlD?=
 =?utf-8?B?YmFRd0Y2SEc2OHdPT2szNjAxNzZoOEV6Y2pDTGNSWmtPNFk4bTNpNVduY0hN?=
 =?utf-8?B?b21IcUZ5aEJVbE5kZTVLOEx5V3NuKzNtbnFTVUxhVjc0K3Vsc2tOcWhtT1BZ?=
 =?utf-8?B?Qm1HdDhycVBvdFY4eUs2bTQ2bmMvUE9TbXFVTHRhV1VGVDZpNHhDN3BRNGRI?=
 =?utf-8?B?YUFUdUNTRVJET0FtdEh6ZEpMRGNZc2ZkQlREeUd4elMwbExkdlAxMXNlbm85?=
 =?utf-8?B?UXpycUVEdlJldnhkYkY4TUtVZnF1eXdhOS9NTVBQRWhGNG5meGpuaERudW5p?=
 =?utf-8?B?a0krMjdsTk1VdzNtVlZsTGx0aEhxb3ZxanBid2x0MVFjM0g3d0VTMjltZWFY?=
 =?utf-8?B?dXZGMHlhY29lMjQ1NVE5RzJaemswWUF3M3FYK0dIKzlvTTZiYVZ1T0Y4OXZU?=
 =?utf-8?Q?ZVXXW5lYjeg4+TtW6F06NkHw3?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F4757A2C31585542B525AB09A9F6F5E9@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b2f3fd6-4a9f-42bc-1639-08ddcf6035e1
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jul 2025 11:57:08.3607
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jAg+s3yMKp9TX1ocotHfSXnETgUsJbWlOtZmr1VUAXojPfQquf4q15JaUEgxNnS6CaWNr1mhu453SH8HlmrEdA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6174
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI1LTA3LTMwIGF0IDEzOjU0ICswMzAwLCBBZHJpYW4gSHVudGVyIHdyb3RlOg0K
PiBCdXQgdGhlcmUgYXJlIGFsc28gYWRkaXRpb25hbCBwbGFjZXMgd2hlcmUgaXQgc2VlbXMgbGlr
ZSBNQ0lfQUREUl9QSFlTQUREUg0KPiBpcyBtaXNzaW5nOg0KPiANCj4gCXRkeF9kdW1wX21jZV9p
bmZvKCkNCj4gCQlwYWRkcl9pc190ZHhfcHJpdmF0ZSgpDQo+IAkJCV9fc2VhbWNhbGxfcmV0KFRE
SF9QSFlNRU1fUEFHRV9SRE1ELCAmYXJncykNCj4gCQkJCVRESF9QSFlNRU1fUEFHRV9SRE1EIGV4
cGVjdHMgS2V5SUQgYml0cyB0byBiZSB6ZXJvDQoNClRoaXMgaXMgb25seSBjYWxsZWQgaW4gbWNl
X3BhbmljKCkgcGF0aCwgd2hpY2ggYmFzaWNhbGx5IG1lYW5zIHRoZSAjTUMgaXMNCmZhdGFsLCBl
LmcuLCBoYXBwZW5zIGluIGtlcm5lbCBjb250ZXh0Lg0KDQpUaGUgaW50ZW50aW9uIG9mIHRoaXMg
aXMgdG8gY2F0Y2ggYW55ICNNQyBkdWUgdG8ga2VybmVsIGJ1ZyAoaS5lLiwNCnNvZnR3YXJlIGlz
c3VlLCBidXQgbm90IGhhcmR3YXJlIGVycm9yKSB3aGljaCBkb2VzIHBhcnRpYWwgd3JpdGUgdG8g
VERYDQpwcml2YXRlIG1lbW9yeSBhbmQgcmVhZCBhdCBhIGxhdGVyIHRpbWUsIGFuZCByZXBvcnQg
YSBtb3JlIHByZWNpc2UNCmluZm9ybWF0aW9uIHRvIHRoZSB1c2VyIHRvIHBvaW50IG91dCB0aGlz
IGNvdWxkIGJlIGR1ZSB0byAicG9zc2libGUga2VybmVsDQpidWciLiAgU2VlIGNoYW5nZWxvZyBv
ZiA3MDA2MDQ2M2NiMmIgKCJ4ODYvbWNlOiBEaWZmZXJlbnRpYXRlIHJlYWwNCmhhcmR3YXJlICNN
Q3MgZnJvbSBURFggZXJyYXR1bSBvbmVzIikuDQoNCkluIG90aGVyIHdvcmRzLCBmb3IgdGhpcyBj
YXNlIHRoZSBhZGRyZXNzIHJlcG9ydGVkIHZpYSBNQ0lfQUREUl9QSFlTQUREUg0Kc2hvdWxkIG5v
dCBjb250YWluIGFueSBLZXlJRCBiaXRzIHNpbmNlIHRoZSBrZXJuZWwgYWx3YXlzIHVzZXMga2V5
SUQgMCB0bw0KcmVhZC4NCg0KSSBiZWxpZXZlIHRoZSBLZXlJRCBiaXRzIHdpbGwgb25seSBiZSBh
cHBlbmRlZCB0byB0aGUgcGh5c2ljYWwgYWRkcmVzcw0KcmVwb3J0ZWQgaW4gTUNJX0FERFJfUEhZ
U0FERFIgd2hlbiB0aGUgI01DIHdhcyB0cmlnZ2VyZWQgZnJvbSBURFggZ3Vlc3QsDQppLmUuLCB3
aGVuIHRoZSBDUFUgd2FzIGFjY2Vzc2luZyBtZW1vcnkgdXNpbmcgVERYIEtleUlELiAgU3VjaCAj
TUMgaXMgbm90DQpmYXRhbCBhbmQgd29uJ3QgY2FsbCBpbnRvIG1jZV9wYW5pYygpLg0KDQpUaGF0
IGJlaW5nIHNhaWQsIGZvciB0ZHhfZHVtcF9tY2VfaW5mbygpLCB3aGlsZSBleHBsaWNpdGx5IG1h
c2tpbmcgb3V0DQprZXlJRCBiaXRzIGluIE1DSV9BRERSX1BIWVNBRERSIG9idmlvdXNseSBkb2Vz
bid0IGh1cnQgKG9yIGFyZ3VhYmx5IGJldHRlcg0KaW4gc29tZSB3YXkpLCBpdCBpcyBub3QgbmVj
ZXNzYXJ5IEFGQUlDVC4NCg==

