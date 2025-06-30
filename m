Return-Path: <kvm+bounces-51092-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7EB2EAEDB27
	for <lists+kvm@lfdr.de>; Mon, 30 Jun 2025 13:34:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D9C683A9982
	for <lists+kvm@lfdr.de>; Mon, 30 Jun 2025 11:34:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FE1625E454;
	Mon, 30 Jun 2025 11:34:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cuKyiKr0"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24DD1242D83;
	Mon, 30 Jun 2025 11:34:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751283267; cv=fail; b=RxK7PtgZeW6+sbg91IW7KK0tF5QMLTWG8H7kAF0DfrJnwg/g8WROr9a+R70PHYt833MVHPon4ZqBFdP7a4S4RA3hvqLMggc2mT1Tw5D3Dvjtq0QXxKR6GqFSSxRbe5n2mlSPrkj4/TSwQMHIxJkcHcH3cHXS3X4m19WcJ0qHszE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751283267; c=relaxed/simple;
	bh=9x7W4fooE7NOTOatF6fJOFUkMMX3vy85yauTdjKiLZw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=eDDt56CeOzL4KKZDvBY9JAJryIRGTsASgMhNenjbIPKR78EfGcpbMSmI1z7amz7SkP7BozqSnwGOWo00aYwMX6wGv5C28/NOrKgAaFZV+qgt8st8tNmASXiZL0NIkBsQ9aXpPvs9vxw8bfDX0fAJSXRiNFT/giwScFroidG0M2w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cuKyiKr0; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751283266; x=1782819266;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=9x7W4fooE7NOTOatF6fJOFUkMMX3vy85yauTdjKiLZw=;
  b=cuKyiKr0DeSKAPRryJKn2ixNiSyFcfFGz/ZlYUMDrsV078apmztX/iWi
   RQTpobBg52yMnMr3GrUZTVFiemW1GVFh31WsHl6jA+oQ+VrH67FFoOFUg
   HNmW5Ot0REBoXB08GAvXfR4AntK4++PRXjpBwaIXdjzs4yBUd0GrTDqFy
   7DJzOk3pQixOZ/A3NG8z/KcVsGY8lKqPQ5iUmd4mJEuV1dQ665rEjQPLZ
   8QF5/5sM1lyaCwpZBkDVGfo+zz4IpGk4M+Rn9jyMil2D1+2D05tSNO1uy
   YcYlxlPpFiuATFm/xigrTj5mhuLtXOGS0kKuyVMlfL3sHx6pzspE0YTUh
   w==;
X-CSE-ConnectionGUID: wtQL/zVPRIGXCrJbED98WA==
X-CSE-MsgGUID: P1iMYSSHSWO+kK9RaL6Jpg==
X-IronPort-AV: E=McAfee;i="6800,10657,11479"; a="41132568"
X-IronPort-AV: E=Sophos;i="6.16,277,1744095600"; 
   d="scan'208";a="41132568"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2025 04:34:25 -0700
X-CSE-ConnectionGUID: tCPq905tTn+0BU09MQ0E/w==
X-CSE-MsgGUID: ZsNQLhxaTmau2dOADrw9YQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,277,1744095600"; 
   d="scan'208";a="157709742"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2025 04:34:24 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 30 Jun 2025 04:34:24 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Mon, 30 Jun 2025 04:34:24 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (40.107.212.46)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 30 Jun 2025 04:34:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eLE2pVtQ1jw95BH3vYVhLXJ7C3cZPOvYia9DWEcnnT66NRRQbDbPXbrRp/DmPwUCygSHgyoYNnGuoafwb8+2vv76LSYhB9f1V1TfVFknGTXOBZGH5nDyfdGx+dKjpO0PF6EAMBRiQ25KpIW86nX6M+BlkP3FR+NZ9FRHEAHHICUMmS5sktWxyVCzAJD7FcL+d+7Yu0ojCtwF8k21XmoLkzSfdntsQ6BaRT5VuR/dBpFDxn3+BAKOsOOLUc9JdCsLmc2YZmm8d8lQvsCp34uimOlCTBdDQBzoumeZPwWeOrwOT6YZVy0p2cXp6WDgPryd8z7crpB8YEscCfoO2oFQpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9x7W4fooE7NOTOatF6fJOFUkMMX3vy85yauTdjKiLZw=;
 b=W8wlh4IPIHHq6jvJAAMtHf93H0Mda+7teaDP46FxMwYQldGH8zkex7sxJtK7rikYe1wAfXXQE3etFLYqJYqS8kls7pPcyxvIejwacP4+1mAlglq5G51smlUdZntLxknLq3U5AxUIO+BVKuf0Cp4iXRe5CPyLQhYCvro9Hp7/dcNnwFg98vrWTEcJrhvAX0/cjsp4U1itxupHjQPtl99VE2aOf4BNF3R7ii/klX8qRmkIvUPFMCUWau9Uexmaq1AFWN6iFMZhSaNhs+AfpUic7aMLVFqUh/AdWbZ6uMUHAbXXIzPjYW/cLhrpuVqJWtocGwgJj8YYHhFrDXm8tEzCPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CH0PR11MB5521.namprd11.prod.outlook.com (2603:10b6:610:d4::21)
 by DS4PPF382351574.namprd11.prod.outlook.com (2603:10b6:f:fc02::1d) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.29; Mon, 30 Jun
 2025 11:34:21 +0000
Received: from CH0PR11MB5521.namprd11.prod.outlook.com
 ([fe80::df20:b825:ae72:5814]) by CH0PR11MB5521.namprd11.prod.outlook.com
 ([fe80::df20:b825:ae72:5814%5]) with mapi id 15.20.8880.015; Mon, 30 Jun 2025
 11:34:21 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "bp@alien8.de"
	<bp@alien8.de>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "ashish.kalra@amd.com"
	<ashish.kalra@amd.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>, "Chatre,
 Reinette" <reinette.chatre@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"mingo@redhat.com" <mingo@redhat.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"nik.borisov@suse.com" <nik.borisov@suse.com>, "hpa@zytor.com"
	<hpa@zytor.com>, "peterz@infradead.org" <peterz@infradead.org>,
	"sagis@google.com" <sagis@google.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "x86@kernel.org" <x86@kernel.org>, "Williams,
 Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v3 1/6] x86/sme: Use percpu boolean to control wbinvd
 during kexec
Thread-Topic: [PATCH v3 1/6] x86/sme: Use percpu boolean to control wbinvd
 during kexec
Thread-Index: AQHb5ob1Aej6jhsWsE288GxQicmcLLQYiUSAgABHCQCAAsh4gA==
Date: Mon, 30 Jun 2025 11:34:21 +0000
Message-ID: <3dbc579b2a3163de983547351c9563a495b1234b.camel@intel.com>
References: <cover.1750934177.git.kai.huang@intel.com>
	 <b963fcd60abe26c7ec5dc20b42f1a2ebbcc72397.1750934177.git.kai.huang@intel.com>
	 <20250628125001.GDaF_k-e2KTo4QlKjl@fat_crate.local>
	 <92c7f4b9-5f08-f01e-a711-69fef94c2628@amd.com>
In-Reply-To: <92c7f4b9-5f08-f01e-a711-69fef94c2628@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH0PR11MB5521:EE_|DS4PPF382351574:EE_
x-ms-office365-filtering-correlation-id: 58bad426-cee2-445d-6805-08ddb7ca0eaa
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7416014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?Zm5vaHNUOFlzMWFORVNVdE5RMUtNNVRVbnM5cUNsRGtjVzFnZW9BSUJ5Sit5?=
 =?utf-8?B?RU1TbnlSaC82WUJMN3AvU2M2c2c4bW13UkRIUTJvaDk4RkF2OGJhanp3UWtU?=
 =?utf-8?B?Mll0dlJBMzhoRkZoN0JTTjA4akJFdnZkdW1oWXoxY2tkRmpUSTZRTTRPRWoz?=
 =?utf-8?B?Z2ZFRmxWY1IwWkZYTGE3WDJWZjhzZThocnVIcU83UjVuUWlaTFU3dnVoT1ZC?=
 =?utf-8?B?bXlGR0Ryc05yeXNnaFR0eUNCRStOM0xDTHdLVDhuNUFGUTIrQWV4a1AvdFZh?=
 =?utf-8?B?bU53bk8wbUFvMHY1dEJTYjJuaDFBMFNXVGhwdGJYNUdINVF6ZVB5M24vUEVB?=
 =?utf-8?B?VjY4aWFvSnZuZmYraG1aT3h2bWdyUmpmbjNGcURVYm53R1J6UDI1STN0cDRt?=
 =?utf-8?B?UVBEREg5N3BWa0V4ZHQwSTdCT0lWYkxVcG5zT3NvZTlGUmJubDJHc1FNTk9F?=
 =?utf-8?B?N2ZpNTYxV0lXWXZzL2lVRXhnN1Z3a0FzVEEwTHpRdGtNMGlVSlhKNytzSTYr?=
 =?utf-8?B?YklMcEMwTEpFMFp6ZGMwOHhwcld2Njd2RnRMOElvSUdqMFF0UWc3RSttRE9u?=
 =?utf-8?B?VTdBUUhEcFI0ZDF2NU9aMW81TnJwQ0NxWFFWZG15amlkeDRCb05zMjQzb09V?=
 =?utf-8?B?S09IUEhLdSt4WVV4UDhreFBkVnJTR1JUR0Q5RmNMS1l4RzZDcGFYdHBNazJ3?=
 =?utf-8?B?bjhNMWlmNHp1andENy93V2JXZ3JQS2tiRENBUjlEYTkvUHdrdUcrR2k2SzFC?=
 =?utf-8?B?VE4wTGU1bTNnVk8vZWVPcjBWQzVSUUwwREhTbzVNZkRKRm1pV2c4bXdtd3R1?=
 =?utf-8?B?cWJNOThlNE4zOXFjQms3M0RwN2NQRnFIeHorNFZoUXZNOWErUFZ5VlpvdHdv?=
 =?utf-8?B?eCs4alpoZzVRMVc3MjJOOS9tTVVNaTRKbHd0RmJDVVZlNGRlRVN0WjNxSTdT?=
 =?utf-8?B?YmVWR0NkaGROazZYSjd0Z05LSnlkQlJCcVltZ0NaWm0yTmMybUpUSDJNWjh5?=
 =?utf-8?B?c0dCU0JZaW1IbWVpM1k0R1prUTNNYWszalVrZ1BXUFRrYXBhSzdEckUwdXhR?=
 =?utf-8?B?bUZyNTFmMUJrN09TNkplQnU4ZlY1VUxPMVVXOXgzVUk2UC9Va0hsenVzYThs?=
 =?utf-8?B?ZDBncVZXdkhLeGI1bkdEUE8wOVR3SElwU3hFQUVldm9Ucnk2R09OY2Vibk5V?=
 =?utf-8?B?V1BKUDZ5bUxIYzljZDRPUzFTSlZLb204K2puSU50OWdWaHJscVRhUEkyVW5P?=
 =?utf-8?B?ckEzWjIwbFNKQnpOTmd5c1FORFYvYURxMjhaSHEzK09QdkxtNlk1ZlJ5UDhr?=
 =?utf-8?B?MWFqTFBKZ2x3RXVIMlRjcThMVUgzNEE1dG9zdFQzS0M5NnRWdHIvaGg0eUtE?=
 =?utf-8?B?aUxWSVc4dmt0STQzbVNJL3VFcnpSY1NmNGZ2T3hLNjZtUTllZDhhVDlNWSt5?=
 =?utf-8?B?bXlYY2Exa0FzNnlNZUNBcHN5NWdkcVFSY3FtVTFGYnp1OW9wWXcxZi9PMGJS?=
 =?utf-8?B?blpkR2NJaW5iSW5ZWjNaYWsrNVQ0Ym9MbUlyQ1JnS25pemZ4WGQ1cVR6Vkx4?=
 =?utf-8?B?Y1VJVS9HbHpyaGVqZkVySCtGNVJkc0ZGZ2Y3bTFpRHQyYWxOY09uNVZmK1N2?=
 =?utf-8?B?aGVzWmU0QW82d0pTakdGeUV3YVo1aFN2cTZnUklXUDlaN1BJSy9tWDdRMGZW?=
 =?utf-8?B?UFJaLzQ0c3JpS05BZkRCcmdLaE4vWDhZUXhUMmV6RS9YWnlHOWk3L3dzQU5L?=
 =?utf-8?B?SGFzR2RBTUhZaWxyWHcrcC8rZG5YUit3WjdVQkFxalN4amdzeE9uTmFQNDBN?=
 =?utf-8?B?d0dCU1FUbG5xeURIb3BEam96M2YvbmFyR05WSDE5eTBNZkZyV1BnUXhmVDBi?=
 =?utf-8?B?SlNWY1ZSc0hxVmpaaElaUEdBL3BqZTNsTjNDQ3NlcTl2YlZYYTdGZHdhWHRD?=
 =?utf-8?B?V1VtWExlY0s2UjRMUURzTjJNMDF1anJ1YWVHekpIc3VLVEN5SmkxNDNObkFJ?=
 =?utf-8?Q?lz3qF3sYrl2n/ItcTRd3hogjgJmPCg=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR11MB5521.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cWplZ2FkZEJ1dnh3R0piZ01mQ0ZLenMxK3FXbk9CU25EZUxNQlJXZi9pbVdH?=
 =?utf-8?B?OEY0dndMZ1YwUUxNVXF2VHBLY1RuQUVPdmw0RnR2eEN2TUNpVWxLTEE2d2JK?=
 =?utf-8?B?TktPZ2RDZkdEeFJDdXdSeVcvOGlLdkd3MlZTa0piSnZxRVZsL0l4Sm5CZHBC?=
 =?utf-8?B?MzMvbit2RU9YZnovNTZJbUIwdGFkNDBMTGw2M1NScmdZU29MZ2tFMTd1amVT?=
 =?utf-8?B?U2VPWkovQzRaWDJPaVhZSVh1a2hESVEzZjFBSjJxekVmL0hTR1kxbGZBSzRh?=
 =?utf-8?B?MGtkR1RjSlZJK0krbDZvcnlWcmg0T2JyN0dyVUFRemI5T3VBa2NSazhlb2xm?=
 =?utf-8?B?Rk5tOGpuRG9tY0RiQ3UwbWk4Wm1ncDlLTGl0eVlKNG1nd01IclZUTytoTXZa?=
 =?utf-8?B?d3VQMVczbFRpV0FsMVltMEdUNDc0U0RvRCtJTnBWYnczYXQ1d1JraTBTYVAx?=
 =?utf-8?B?Mmp6UGdCai9saHl3bDJhK0MxTVV1KzJLQU0yQ2NFckxVOHNZditvS3pTZjFB?=
 =?utf-8?B?eXhrRUJGMitJZVBIcDg4RkNxT1c2MDF5aklPZHhCU29SVW9VZ2doalZJRWk0?=
 =?utf-8?B?WlJGYUZEQStiVjZHMGRWdktrTStiNnZFaHRpVHhUbWJuOUpVNkxCRTdvSHpn?=
 =?utf-8?B?L1IrU2w5TGt2Q1hHQk93NlJLY29URkdZZGt3QnZINyt4YVVkK09aSWJSelM0?=
 =?utf-8?B?ZGJkZGtxTGVIUjlhZUtVL2d2NzJLa1hsbmR1ellGdTJRR0QyWnhPODd4MWdZ?=
 =?utf-8?B?SDMxNHlXa0xja3ZlL3h1UkNaYWQ3bzNUK3QwL3MwT2c3UGxZai94andjWWhG?=
 =?utf-8?B?alNrOTVBTFUzN1JTMDJNVHFkKzNDeUoxcVFTRWVpWnRWYnhqUkY5WERxUXFl?=
 =?utf-8?B?WXZGekExQ3lmcUhxRzlhdlRWeXB1eDNxU3lEVXRuNWlPZGxKMnYzT0QvQ2hO?=
 =?utf-8?B?TDRFU3RMS013YjJyS2lpZVU1RXZRdVpQc01DWGVwcndDT3BXeWpiWnhLeFJr?=
 =?utf-8?B?MCtKR3ZHMGZybC93dktJWmh4Q1hKQzBaUGpkbDc0Y3VGSDJuQzc0b3puaDhp?=
 =?utf-8?B?VkpzWkMrU2RjMkdoZnBZLzgwWVRFRXpoZ0ZmdTFxQ0FyNVN0RHNqUktqRXF3?=
 =?utf-8?B?b3B3YnNNUHVGWkY5dVlyVTZrc1pycW8zcmg5WXRud0ZzZDljdzBsS1QvMUp0?=
 =?utf-8?B?UzhWdlpnSjZFSStqbFBkR1RkYml1U1RTcVIxKyt0cEF0YWlia1ZXOUdqTE9X?=
 =?utf-8?B?aFllclpDb09CM1BDUHBPOFBxdnROSExJeDcvRzdMV0E3NFQrVG1NNzZDMFAz?=
 =?utf-8?B?S2tzcFUwcE9JdEpxS2pMcGFrRVhCbFBibUU0K0VRSktUL2ZnMUNhemFhT0hj?=
 =?utf-8?B?SzhUSnZUMWRlT2M3aFV6NURPUmhrVWcyOVlBak0wSUZWRnpCdjhKSE1wMWQw?=
 =?utf-8?B?SVYzLzRqcStkUmt2L2dCT2VrWk8rbFhOSDZlcnJsUllWMjNXcjJGWGxXQW5m?=
 =?utf-8?B?VGhwTVNQcTh5eExzWW5yd2J3eVh6LytCRk1xbUE2YlY1azBKY3g5bExlSlht?=
 =?utf-8?B?OWRHUWtuOXdZZmpEcUFmRXBycE1SY0NzalFvNXhiN2Vad3QrYTlCWDJLNndu?=
 =?utf-8?B?RmVucDRWS1FFZENwM3VpelZNbVpMUXd6Vm5NUUI5VmZRK0c1TFFwK2tHaDBm?=
 =?utf-8?B?U2g2b241bDlaeEdoNXdIbTFoYjJ3YWxMdUEwd3MyUzFnRW11OExvakgyL2R6?=
 =?utf-8?B?ZkQwOCtLQlEvNW9jQXJnWWxaV2Q4dzA1NEdmTE1RMUVBMjFnZTFWL2Qva1Ar?=
 =?utf-8?B?TlZpS2hxekxJMUJjVlN5WmV5QzVCOWU0Q2l5dlRMcHp6R1ZZMXBuS0FIc2JU?=
 =?utf-8?B?Yk1kSThMaFhzWXVSOW5RSnJkaGJLS3NVWWVVY2hjeGhlRXhJbkR0VHc5dDM4?=
 =?utf-8?B?R1pJeHp2cGhXd2Vtdzd4N1Ixem1vc3JiWlpWOG5WbVpSQXprUkdxMUw5VW8w?=
 =?utf-8?B?MDlyUEhueElrMzQ3dTRqV1FNV3hudVl0d2l2Qlk3SE5jeUV2cGVlcXFzSXdk?=
 =?utf-8?B?Y3h4eWRlWENVVUVYMzE2TlZKVWM4blZuaTVBSnBaVkRFQ0ZoSFZEMk93OEJJ?=
 =?utf-8?Q?uABiVkIfJkEGys3VBjIK/rkHS?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7D9D634329EB7C43BE5B8749D50D2479@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH0PR11MB5521.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 58bad426-cee2-445d-6805-08ddb7ca0eaa
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jun 2025 11:34:21.3630
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vkc+LmopbZkNCjyB13Qws3qWCNUVAQPDkvcCE8G/LmVO/GBc7UoD9NrDAfYdaIU0PYZXkwvCVpRU3XwG3hcrkA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPF382351574
X-OriginatorOrg: intel.com

T24gU2F0LCAyMDI1LTA2LTI4IGF0IDEyOjA0IC0wNTAwLCBUb20gTGVuZGFja3kgd3JvdGU6DQo+
IE9uIDYvMjgvMjUgMDc6NTAsIEJvcmlzbGF2IFBldGtvdiB3cm90ZToNCj4gPiBPbiBUaHUsIEp1
biAyNiwgMjAyNSBhdCAxMDo0ODo0N1BNICsxMjAwLCBLYWkgSHVhbmcgd3JvdGU6DQo+ID4gDQo+
IA0KPiA+ID4gKwkgKiBzdXBwb3J0IFNNRS4gVGhpcyBwcm92aWRlcyBzdXBwb3J0IGZvciBwZXJm
b3JtaW5nIGEgc3VjY2Vzc2Z1bA0KPiA+ID4gKwkgKiBrZXhlYyB3aGVuIGdvaW5nIGZyb20gU01F
IGluYWN0aXZlIHRvIFNNRSBhY3RpdmUgKG9yIHZpY2UtdmVyc2EpLg0KPiA+ID4gKwkgKg0KPiA+
ID4gKwkgKiBUaGUgY2FjaGUgbXVzdCBiZSBjbGVhcmVkIHNvIHRoYXQgaWYgdGhlcmUgYXJlIGVu
dHJpZXMgd2l0aCB0aGUNCj4gPiA+ICsJICogc2FtZSBwaHlzaWNhbCBhZGRyZXNzLCBib3RoIHdp
dGggYW5kIHdpdGhvdXQgdGhlIGVuY3J5cHRpb24gYml0LA0KPiA+ID4gKwkgKiB0aGV5IGRvbid0
IHJhY2UgZWFjaCBvdGhlciB3aGVuIGZsdXNoZWQgYW5kIHBvdGVudGlhbGx5IGVuZCB1cA0KPiA+
ID4gKwkgKiB3aXRoIHRoZSB3cm9uZyBlbnRyeSBiZWluZyBjb21taXR0ZWQgdG8gbWVtb3J5Lg0K
PiA+ID4gKwkgKg0KPiA+ID4gKwkgKiBUZXN0IHRoZSBDUFVJRCBiaXQgZGlyZWN0bHkgYmVjYXVz
ZSB0aGUgbWFjaGluZSBtaWdodCd2ZSBjbGVhcmVkDQo+ID4gPiArCSAqIFg4Nl9GRUFUVVJFX1NN
RSBkdWUgdG8gY21kbGluZSBvcHRpb25zLg0KPiA+IA0KPiA+IFdoZXJlPw0KPiA+IA0KPiA+IFRo
YXQgc2FtZSBmdW5jdGlvbiBkb2VzIHRoZSBjbGVhcmluZyBsYXRlci4uLg0KPiANCj4gSSB0aGlu
ayBoZSBtZWFucyB0aGF0IGlmIHRoaXMgZnVuY3Rpb24gZG9lcyBjbGVhciBYODZfRkVBVFVSRV9T
TUUgZHVyaW5nDQo+IHRoZSBCU1AgYm9vdCwgdGhlbiB3aGVuIHRoZSBBUHMgYm9vdCB0aGV5IHdv
bid0IHNlZSB0aGUgZmVhdHVyZSBzZXQsIHNvDQo+IHlvdSBoYXZlIHRvIGNoZWNrIHRoZSBDUFVJ
RCBpbmZvcm1hdGlvbiBkaXJlY3RseS4gU28gbWF5YmUgdGhhdCBjYW4gYmV0dGVyDQo+IHdvcmRl
ZC4NCj4gDQo+IEkgZGlkIHZlcmlmeSB0aGF0IGJvb3Rpbmcgd2l0aCBtZW1fZW5jcnlwdD1vZmYg
d2lsbCBzdGFydCB3aXRoDQo+IFg4Nl9GRUFUVVJFX1NNRSBzZXQsIHRoZSBCU1Agd2lsbCBjbGVh
ciBpdCBhbmQgdGhlbiBhbGwgQVBzIHdpbGwgbm90IHNlZQ0KPiBpdCBzZXQgYWZ0ZXIgdGhhdC4N
Cg0KSSB0aGluayBJIGFjdHVhbGx5IG1lYW4gaXQgY291bGQgYmUgY2xlYXJlZCBieSAnY2xlYXJj
cHVpZCcgY29tbWFuZGxpbmUuIDotKQ0KDQpJSVVDIHRoZSBBUCB0YWtpbmcgb3V0IGZlYXR1cmUg
Yml0cyB0aGF0IGFyZSBub3Qgc2V0IGluIEJTUCBoYXBwZW5zIGF0IHRoZQ0KZW5kIG9mIGlkZW50
aWZ5X2NwdSgpLCBzbyBpdCBoYXBwZW5zIGFmdGVyIGVhcmx5X2RldGVjdF9tZW1fZW5jcnlwdCgp
LCB3aGljaA0KaXMgY2FsbGVkIGluIGluaXRfYW1kKCkuDQoNClNvIHRoZSBtZW1fZW5jcnlwdD1v
ZmYgd2lsbCBldmVudHVhbGx5IGNsZWFyIHRoZSBYODZfRkVBVFVSRV9TTUUsIGJ1dCB3aGVuIA0K
ZWFybHlfZGV0ZWN0X21lbV9lbmNyeXB0KCkgZm9yIEJTUCBhbmQgQVAsIElJUkMgaXQgd2lsbCBz
dGlsbCBzZWUgdGhlDQpYODZfRkVBVFVSRV9TTUUgYml0Lg0KDQpCdXQgSUlVQyB0aGUgJ2NsZWFy
Y3B1aWQnIGNvbW1hbmRsaW5lIGNvdWxkIHN0aWxsIGp1c3QgbWFrZQ0KZWFybHlfZGV0ZWN0X21l
bV9lbmNyeXB0KCkgdW5hYmxlIHRvIHNlZSBYODZfRkVBVFVSRV9TTUUgYml0IG9uIHRoZSBTTUUN
CmNhcGFibGUgcGxhdGZvcm0uDQo=

