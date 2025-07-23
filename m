Return-Path: <kvm+bounces-53259-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 27DBCB0F5AF
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 16:45:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EA5451891656
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 14:45:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6AD422F431E;
	Wed, 23 Jul 2025 14:45:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WNSqTvmm"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D40272EBDEF;
	Wed, 23 Jul 2025 14:45:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753281905; cv=fail; b=RcuLLMHPCrXcdep5PPr9QLNZoIIg3qtR53XoPL9YPTY5+S0MsvXDEcCs9StNTsNtMjBS+FN65Nsesxr93JkB7ZpQmeBljw96bIQcjw9XzUsSzRRLnQsL6mUqf/eb27nKgw+OIln169rKk63r+6445GK5TvZ2lAKJ0e55OVSgdBc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753281905; c=relaxed/simple;
	bh=9Ul1MLH2w5XWnE4ZS9Lzo9YTfJdjqjNtOVnsCkMc/ok=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=fDVL08WL8+C5QvbZZiASV4I3KQnSDbMB/MlDKT+sECbG0FnHvl82Yzg9vh87MlYoDVCk5e/uCaEcWZKDYJj5CCZw6kpzzTwpx7Ub3/i5KAQ+IAoCO/aBdXxSgQbfr9V9slpPwkbSvcIPpTzf/vghej4Kz91QORVkdqBFnDh5aPY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WNSqTvmm; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753281904; x=1784817904;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=9Ul1MLH2w5XWnE4ZS9Lzo9YTfJdjqjNtOVnsCkMc/ok=;
  b=WNSqTvmmHJHCKDk69ZzwHn6Xj50s/MCbhoChFT75J2AG8D4itMjPPN3F
   XMXNMgyQ/R+ppBV4KYRLkfSFfUfKBBBfXmTW0NFVX+4auY/1eDIvKe3Wi
   TRpg+88wLaAxcTGj+CkihiadtzO7gZ8pEh0+tp9m/Wpon51xnoqZw5nVc
   dtrOlXFnqSD17gQ0E5Pl4g3gzjgrbblyyxtOQRRlAs/Cvlzsq1UV9t4cr
   z35QFJAhEyP2U1GEOd8GgZilFEXHOrdihi2JXCrw4WVql1ilSUFiJ3lMJ
   0sX+va8ezq2qPAIr9PXJ4E40T0u1D+QAM8Fw6OhnfbDZCsoUaF/31elHU
   g==;
X-CSE-ConnectionGUID: WyNNYa9HRsCyAaG+btxwMQ==
X-CSE-MsgGUID: 39PG3eLqTTGR5GZ8y9C6cw==
X-IronPort-AV: E=McAfee;i="6800,10657,11501"; a="58182503"
X-IronPort-AV: E=Sophos;i="6.16,333,1744095600"; 
   d="scan'208";a="58182503"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2025 07:44:53 -0700
X-CSE-ConnectionGUID: X7QqFEYCRQCvtygFTTN7Zg==
X-CSE-MsgGUID: B/udQ0QuQCqVzj1uzRJtEQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,333,1744095600"; 
   d="scan'208";a="159571606"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2025 07:44:53 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Wed, 23 Jul 2025 07:44:51 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Wed, 23 Jul 2025 07:44:51 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (40.107.92.83) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Wed, 23 Jul 2025 07:44:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DLyq0Czvhr8PcJW0D+tjkihsHLUqUPNCQtodbQiNSI7lxem1A1pAiN9ZN9H9N7BkCajv8O8qCfRH4GULEXaEY5Iqx/Qz1lp2LkNCAHe6gAxXk1iWTUUE3hdQKW2ap7CUjbXfUThdJ06Q/DAsyg/2Qyo6P/2PLv//9b7qDDdnxPSjgCJ7e80fbIbOuRbmrMrCYbpMvBUSyvdHzIuuHrW+TzXXANAvOEsp3PpRhrRNF+5ENal8XNn+0vGO003uXoXSLvAqbBYHwsnrHmuLsi9H12IXjg9bUD0wb83+gHdS+720cqElahAgjvz3DFVf36ydc85S5vxqkDYGAc3jlTdTXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9Ul1MLH2w5XWnE4ZS9Lzo9YTfJdjqjNtOVnsCkMc/ok=;
 b=egnwJLT9Dual9AWPnSY4Kv1vQX4a9rSg6rFJyBaAJLA8425bW5qb0UipcoTL8JE7flhjfSVtYIN0stIsNkWFtLGqn4VEQnOj9QMxW0mWv0uYNr3Qn4yVArkRFidNy8NH8UCFQnXGeL3D8APdU0adajLLPXfnCzrXuw8oTnvrxG0IH0K+bVUPzRSnR1qZQo9LLOo7o2pSkOdahffihSnWYeqyg1RdkCUXd4XlT1CSkphkrwN84E+DBEHXMxEiWID3xhw/+pG3e3LVfvL8CSjOdJ7abu1oJu/esGtYnWr1cudSTYMhTLv7AH1vnL6nPH/K5jOzPGA9jNtNjCStpjrq3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DS7PR11MB6294.namprd11.prod.outlook.com (2603:10b6:8:96::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.23; Wed, 23 Jul
 2025 14:44:06 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%6]) with mapi id 15.20.8943.029; Wed, 23 Jul 2025
 14:44:06 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "Hunter, Adrian"
	<adrian.hunter@intel.com>, "Annapurve, Vishal" <vannapurve@google.com>,
	"seanjc@google.com" <seanjc@google.com>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "Huang, Kai" <kai.huang@intel.com>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>, "Luck, Tony" <tony.luck@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>, "Chatre,
 Reinette" <reinette.chatre@intel.com>, "kas@kernel.org" <kas@kernel.org>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "hpa@zytor.com" <hpa@zytor.com>,
	"mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>, "Gao,
 Chao" <chao.gao@intel.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH V4 1/2] x86/tdx: Eliminate duplicate code in
 tdx_clear_page()
Thread-Topic: [PATCH V4 1/2] x86/tdx: Eliminate duplicate code in
 tdx_clear_page()
Thread-Index: AQHb+8ovx0yLPSIy6USdKkSakZSGBrQ/vkCAgAAI0oCAAAHTgA==
Date: Wed, 23 Jul 2025 14:44:06 +0000
Message-ID: <4b7190de91c59a5d5b3fdbb39174e4e48c69f9e7.camel@intel.com>
References: <20250723120539.122752-1-adrian.hunter@intel.com>
	 <20250723120539.122752-2-adrian.hunter@intel.com>
	 <f7f99ab69867a547e3d7ef4f73a9307c3874ad6f.camel@intel.com>
	 <ee2f8d16-be3c-403e-8b9c-e5bec6d010ce@intel.com>
In-Reply-To: <ee2f8d16-be3c-403e-8b9c-e5bec6d010ce@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DS7PR11MB6294:EE_
x-ms-office365-filtering-correlation-id: 29822492-3bd5-46e4-9c29-08ddc9f76013
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?cWJRZnhXelJwd2s0bm1BV2M4SXFWY0p3aURKQk5BOFo4VlQzQ09SRDJ6U3FP?=
 =?utf-8?B?dGY0YXFkdFByNmlIdVQ1VUtHbEZmVEZEL0o0Z0J6WURIT1lDcWNuZ1Bmck5W?=
 =?utf-8?B?aHJhYXlINUQ4VVVyVFEyellHNWtGZWVxSkxGYWt6eTUzOEFPdU1mcjRZU2N5?=
 =?utf-8?B?QWdmRHRidm5NSFQ2OEJYdHNiZTNVTWpEbkJsQTJWSXdZWmtBWURQdkYrbWtm?=
 =?utf-8?B?TWkzNnNRcGcvTXpYblNpWVA4NURlaDk4d0Nzalp1Z1dnMndvNUpLVGJHNU1l?=
 =?utf-8?B?Z1FoVnVvc25NSnFScHBsVkVXQ250c2xGcDQwSkpLM2RxVlFURWtTSkw0UHRN?=
 =?utf-8?B?QXQ0Q0Z3RWI2aGdOQnk0azVDZVFCT2JiTWhOOTR4M0hTUStQdE8vY0xieTZU?=
 =?utf-8?B?eml5VytlY3VrNXhqVlVscEdLL0tWSXNrZkRSMmxYaFpJR2lscmdpdm1nME56?=
 =?utf-8?B?NUJBUDZmMjdkemlvWitzZ0NQb0VXeisvK2VsUkdzMm96a09XeXpiK1d4YzJU?=
 =?utf-8?B?cThmYThRblYyUndGU3RKMHJaemdRL1NNeldlbXpNZG9uRnVMTnJkQW81T0lo?=
 =?utf-8?B?bW1lL0FORllNQTEwZStWOVZ5Q1BrTVpoeFVkQkZUUmlMd2NWbmYrZDBHM2Uw?=
 =?utf-8?B?QU1POG1seEY2Q0kyYm9qQkxQS0gzVUZKUVZ5eGwyRkptdTFYUnp5a3RNN2lX?=
 =?utf-8?B?STJrclFtTmErTUN6RWs2bUlMeVRiR3N0QmtXR29XLzIzMFBhcGZzM09HaE92?=
 =?utf-8?B?ckJlN0dlczBWeXh4Y1hjUXdoZHZDOWtKWXc2enBFU2tFbVFmbmo3RU5zUXVM?=
 =?utf-8?B?ZFhmMkFXVkFmbWdEbjFyUHNnaFh0UE50RlFUR0dIeWpDNSs1bWR1am5QcUFk?=
 =?utf-8?B?NDVwUXVyTkpxNk5QYzk0dUQwakUyZ3FhY0RWUmZsRkN5cHhlbFNxQmZobVV0?=
 =?utf-8?B?VHIrZ25ORnE1Wmp2WU04K2NZTENXUWhSMWRTbWcwVENhR0dJUWU2THJUOEdC?=
 =?utf-8?B?WWRoeXdpRDZhL1JWbjRxS0FpU2ZJQXlrc2doQUxIVVd1YU9iNDZ1ZEE0cWN3?=
 =?utf-8?B?L2tUaTZydktRMHZGVkdDa2ZnbElnSXhyWmFrWUR0L2Ixb3VsUVJYL3A1b1ls?=
 =?utf-8?B?MndycVA2VE5tWGpqWDNTTE5xbEFLdElpOEk1TjFIRmxwQ3FsZ25HRDNwRmxw?=
 =?utf-8?B?bEw4bnZxUnZSRHFzRDZlNTdtVitjVi9TNTNKZy9QZXFiem1VSjBFQ1NlNHZH?=
 =?utf-8?B?K0hta0xyaDJvZW5Hb1ZMQWxXamVQWHNuY0ozQ0tRdk1PMDVnVnkxT0RMSk1z?=
 =?utf-8?B?bFRPZUZybThGbExSZDRsSThpWEVSVU0rKzBUd2E0eUtNTnp3TG1KNk9iNmRw?=
 =?utf-8?B?YXNJcTBlUzRZeEhZUkxiZ0NETkdnT2g5di9kUUdhQmtVWEFrM01ua0I1UUhl?=
 =?utf-8?B?bTNoSnhxWVozV1czdSt4ZmgybnNra0xEa1kyWXYxdmlKbXhqUWlBUFBWYXBX?=
 =?utf-8?B?bTBnOHBWNXpZTFNvbG45MFJxSVlYVXlrTGw1OVkrK2h1YTFqWU1PTXZLRm40?=
 =?utf-8?B?MUwvWGFnTEVsTTQ0Yi9iZGtUUHpxZlI4QlV2UkFEODJaYjFCdzZYaHAvd09Z?=
 =?utf-8?B?MVgrNCttb0VGOGdFNE5iWktYYktHVjZKK2dsSUE1TktYMStwUEgyZTdFcDEz?=
 =?utf-8?B?cys1bmFXVXdaTUt3NWpEOEVKRVdpK1I0dnN1ZnJ0ZnhvUm1jbVJ0ZEVYZ3lW?=
 =?utf-8?B?TnhoZndXNExjN0wrUGRITlpFMXdUZTdML090TWJrK1hqOU5YWGlQSkZUeEc0?=
 =?utf-8?B?Ni9NOFNtTFplWGFJVFJmak05M0tKL0h5N0xQT3JNTXhobXU3SVU1TkpxUDdM?=
 =?utf-8?B?RVozZW1pS2E0R0I3Q3B6STdrc3FmRHUwYlZzQ0pQTk1QV0owN0p0RlZLVncr?=
 =?utf-8?B?dkI1UEV2YlpEN3lrVVB4ZmUwQk9yMTFxUUtGRmRaaEV5NVV2RUExMkVCeGVn?=
 =?utf-8?B?ak50TmRCamRnPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?My92VjZ1YUM3dWNha3JYRE8zU0wrejliQnlNTTlrcjJnQ05FWVNuRHFCTEU3?=
 =?utf-8?B?VmxvR2l0TEMxcllZWTZMYzB6alpSVzlsMmVtQW9tSjJobHZkQldjSHRrR2FD?=
 =?utf-8?B?blVpc20zU1kyVVVrQyttNm1GOTVEVlRqY0VMeWNqdVJpZnFDQ1VsK2k4RFQz?=
 =?utf-8?B?bVlLR2FQNnFxYVJJQkZ4S3ZCbjQ5MnV2Zzd3ZUF3cFhpejF1T3NPbDBiaDVX?=
 =?utf-8?B?TkxSdEhXS3Fub2hrWWQrS1NGeGU1R2tNUDhTNE5wbUhZVkZOYm5keFJ2QTht?=
 =?utf-8?B?V0lueTQ1cXNNVEQ5eW9XTzZxa0FaVlpFQmt6Rmszc2phNDdvdmtIM0dCWjFz?=
 =?utf-8?B?ci9iMjh4aHo0NGozN2FUQ0d5OS83a1UwMXBCUjg0YmJ2NVRNb0o3WDFQQ1hS?=
 =?utf-8?B?ZVZhbHh6VkNvTnl0eUtJaVBTUVlwTWFhQVBwMmpraUdkN2FrQlFHNWN1OUtO?=
 =?utf-8?B?bXBZOFVCZjJwZFF3L0J6WWIwbmFyQlFBOW85RGtva2Exa212V0FwYzByMHZI?=
 =?utf-8?B?MWROT2ZCTTE2R2puN2JEWHg0QjZlQjNaS3ZSQ0dzcTVJUlpSWnQ1Rk5PL0Jp?=
 =?utf-8?B?TE1wbkxSckpOZkZiaXBydHM0bllIQm1mbVhhNXdGZDdQRlFZdVpCbFhMbXov?=
 =?utf-8?B?Vzh1NlhwQjIwTFhhUkthTDN4WkpKQ3Q2RWpmQjBVYTFOMmRYcUF0S255d25E?=
 =?utf-8?B?dDZyWG1XK0ZxOFB0dlJOQkpYSDNDbXFEWWlKTkl1d2FxSDlhNzRyVVZ5R1Nw?=
 =?utf-8?B?Z2xMVktNZTYxQkpURyt3SWhPcFhBeDlwSlh2eUFZdk5HU005eWV1YTNtK29l?=
 =?utf-8?B?bHNtSDhjZ1dFT0FZNW1zM3BJMkFHRllIRFBNeGFFRTJXbU1HMHY5cVBWbmda?=
 =?utf-8?B?TVpQdTk2aGhNd3FuWUM1enRRQkkrdGNqMGFYZElhemp6aS9pQTNzeUVRUTI4?=
 =?utf-8?B?TjdWenZRMTY3SWZ1R2xJZnRVMG85Ym03cW1wM05zdFErZjQ2MC9WR3BIQ08v?=
 =?utf-8?B?M2VIMmI0SzRRbis5NHdKWnJYaEdvcFhRZW8xRml2SWlCbWlDMmFOSnVmWDZn?=
 =?utf-8?B?YnY5YWJySVlSSGx0ekx6c0V2Y1ZTbDRHQnREVTZsazZuNnBKMldvMHZDZmJF?=
 =?utf-8?B?M3c0L0VoT09DbGZUNks3T2F4QkR5UGUvVUhXWGhVdDFtUzdlM2swQWVoSnd3?=
 =?utf-8?B?ZjRuYVVIdEdhQ3BtaHNtRExlTFRVSVNmUitmeFBtN1pyQlNCQUdQN0tuT3cy?=
 =?utf-8?B?MGVFT2U4WkFrdUJxY3NxV2pjWmhaSzNvVzhaY2k4K0dJNWtZelVzVjRTcktR?=
 =?utf-8?B?a0MwRnF0T3FMQkF4SDFwVXl3RldKdktpL2xodGpod0pmZ3dmbXFFUEhoR2J5?=
 =?utf-8?B?b1k1OEQ0dkZBekpJWkVVbkIrbmVoRGpKZnRpR0dubFNJVkF0dGZhTmN3RTBr?=
 =?utf-8?B?aTJvL1hFUlgxcVNnNU5xbkVQalQzcDhVcmpuVVVJeDIrcGtPL0wzUXA1VkZw?=
 =?utf-8?B?WjA0S05OQnhwUDN4cDJYbUNoazRaWnJnaEt3TExvOVQzSnFiOVFZeG9xN3pZ?=
 =?utf-8?B?elBIemtLaXpRWnhXeUZnUGo5YXJYbWRmMmFFR05WTXNMdUZzbjEydzdrTTVj?=
 =?utf-8?B?Q2s5eU5vNUJuekNwVGFLYU5sVUFSVlpybk1JcVQxQlRSeU0zeEFRblVpVXdv?=
 =?utf-8?B?VWZDc2pidEhETXp2ZFBkK1F3T0ttb0kxVnlqZyt0cEVvSnpTVjV3aEJlVVR3?=
 =?utf-8?B?YTRvRU5aT1NWdjZ3ejF2YTNqZVFlQUpOK1l0bHgwcS9pK09PSHVJdGpUZUhv?=
 =?utf-8?B?U1ppTU5vOXFYUSthdFBZbG1IV2ZnbHd6RENRbysrWW14K3RqK3pvbk5VRG51?=
 =?utf-8?B?VldiRTVNVGZUNUl2akgwSk8wQ2wxVGhBVGdWbGxDbUdvTS82d2tCOW9NSW0z?=
 =?utf-8?B?emhEM3VwZEtsVFBBZUNxZWkrdSt6OTROOWI0VHdwSGxnbUt5WG84VTRBclU0?=
 =?utf-8?B?K1piR05jMGEvaWRuVS9CTWZsc0RCSFRaZ0lyUkhvWnNCT1o1QXYrQXdLZ01z?=
 =?utf-8?B?Vi9yZW9tQ3RqYkJzU28zM2RHT3ovVDFDQ2MvNWViUXFGekdwRGd3TFUzRjNr?=
 =?utf-8?B?clN5VGllRVd0TC9MZnErNzJ0RzhpZTRaZGpjS3hiQ2xHSzMrRFFpdEs2TWhI?=
 =?utf-8?B?YVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E73539097CC92B4AA731ABE3F4DA8B25@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 29822492-3bd5-46e4-9c29-08ddc9f76013
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jul 2025 14:44:06.2409
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TZrRUTje59mpQ8LfD9GKKvgPTrbcCwkVNVeUkdg/5DywkawI96VdJJw2EdowbXTZ11NR73cYsrTaM4lkEP+CfG5Ghhg3WoM9GpyPK/NW0jI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6294
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI1LTA3LTIzIGF0IDE3OjM3ICswMzAwLCBBZHJpYW4gSHVudGVyIHdyb3RlOg0K
PiA+IFRoZSBsYXR0ZXIgc2VlbXMgYmV0dGVyIHRvIG1lIGZvciB0aGUgc2FrZSBvZiBsZXNzIGNo
dXJuLg0KPiANCj4gV2h5IG1ha2UgdGR4X3F1aXJrX3Jlc2V0X3BhZ2UoKSBhbmQgdGR4X3F1aXJr
X3Jlc2V0X3BhZGRyKCkgZm9sbG93DQo+IGRpZmZlcmVudCBydWxlcy4NCj4gDQo+IEhvdyBhYm91
dCB0aGlzOg0KPiANCj4gRnJvbTogQWRyaWFuIEh1bnRlciA8YWRyaWFuLmh1bnRlckBpbnRlbC5j
b20+DQo+IFN1YmplY3Q6IFtQQVRDSF0geDg2L3RkeDogVGlkeSByZXNldF9wYW10IGZ1bmN0aW9u
cw0KPiANCj4gUmVuYW1lIHJlc2V0X3BhbXQgZnVuY3Rpb25zIHRvIGNvbnRhaW4gInF1aXJrIiB0
byByZWZsZWN0IHRoZSBuZXcNCj4gZnVuY3Rpb25hbGl0eSwgYW5kIHJlbW92ZSB0aGUgbm93IG1p
c2xlYWRpbmcgY29tbWVudC4NCg0KVGhpcyBsb29rcyBsaWtlIHRoZSAiZm9ybWVyIiBvcHRpb24u
IENodXJuIGlzIG5vdCB0b28gYmFkLCBhbmQgaXQgaGFzIHRoZQ0KYmVuZWZpdCBvZiBjbGVhciBj
b2RlIHZzIGxvbmcgY29tbWVudC4gSSdtIG9rIGVpdGhlciB3YXkuIEJ1dCBpdCBuZWVkcyB0byBn
bw0KY2xlYW51cCBmaXJzdCBpbiB0aGUgcGF0Y2ggb3JkZXIuDQoNClRoZSBsb2cgc2hvdWxkIGV4
cGxhaW4gd2h5IGl0J3Mgb2sgdG8gY2hhbmdlIG5vdywgd2l0aCByZXNwZWN0IHRvIHRoZSByZWFz
b25pbmcNCmluIHRoZSBjb21tZW50IHRoYXQgaXMgYmVpbmcgcmVtb3ZlZC4NCg==

