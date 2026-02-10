Return-Path: <kvm+bounces-70809-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YIRpGxK5i2kUZwAAu9opvQ
	(envelope-from <kvm+bounces-70809-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 00:02:42 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E2BF111FE02
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 00:02:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5BF083069AD4
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 23:02:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0E0E314B6A;
	Tue, 10 Feb 2026 23:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BX6ITPEE"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF6AD313E0D;
	Tue, 10 Feb 2026 23:02:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770764535; cv=fail; b=EpOcwxu54TGV1JWafkXpM7mpWU/M9vCKsSCJblAdLx3DRLnxf5m0rSNP2m4E4MQS45As1I0emuAIBlqtoTjRLVaGNm604NthpTEuC2G/rI3XwgDLsmqgs7Sdy/Cl8TwwqDIbL1RyvMRaCwUiirrcZuIbQ6UkROButnjmxhQwPl8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770764535; c=relaxed/simple;
	bh=klzvWXz6z3/0eA7KSP21kd21zrYuoW70onX2QLFdPcw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=UM00pnxTAafxPofrpr7JXKezxgaY6Sb4ecLJUFFg/D2O9c8VdotFTLhDygUXLPuLkPtk7Gn6Cdyehg4ZReTyafEqfsyZpch8/B+EfrH7sKNJi9vbJnN3FemRffqum866MtRzZMZOiHJhhvD00rXjUM5g6/1UhikUxg1msd8CJKk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BX6ITPEE; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770764534; x=1802300534;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=klzvWXz6z3/0eA7KSP21kd21zrYuoW70onX2QLFdPcw=;
  b=BX6ITPEEeNyAjNLSQdsc3EFuFgDl+d+WVUMfLadEvpbUT3QaYHZ2oxGZ
   OLZWbZcsW3x9dsX8zPdlG48JiZj8kMftuaTaQdqa6bY3m1Uuej4WE44EC
   3zIAgCaygid5fdC0jXtD+7VILM2Moz1DSFkXTgW/El57F30OjvGbiGa2F
   5sd6kPab5YyBV/dwH9Fco5MGYwECoLlGI+3zLMCfPP1m4pYzVc5Ma24SN
   451Xs7JG0xO+q+B5ro7L4k/IUmB/SanzvJhSMoRkq+ZHiZUipomMeSIwT
   WC60AOttZ/dMNq5X8TVhNNpjYQbsli8gnwr2/SA4PCoAC2yxCkT/3q56O
   Q==;
X-CSE-ConnectionGUID: f99TCNOZS3aQweHxtw0IiA==
X-CSE-MsgGUID: Holqi/8sQQGDYFNeyzLmfg==
X-IronPort-AV: E=McAfee;i="6800,10657,11697"; a="74507394"
X-IronPort-AV: E=Sophos;i="6.21,283,1763452800"; 
   d="scan'208";a="74507394"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2026 15:02:14 -0800
X-CSE-ConnectionGUID: mvNiQuU0TvuME+zmyq8zZA==
X-CSE-MsgGUID: 6i0hhE7rQISquX3g9CcuIg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,283,1763452800"; 
   d="scan'208";a="211688128"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2026 15:02:14 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 10 Feb 2026 15:02:13 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Tue, 10 Feb 2026 15:02:13 -0800
Received: from SN4PR0501CU005.outbound.protection.outlook.com (40.93.194.45)
 by edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 10 Feb 2026 15:02:13 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jgaxcO3mbH92wMcxC3ePDBacBWzQyd1zl15gmkp75Vjuljl307aUyErqxvFy5VRUScLDvgoikALbJETCO21D/iyJtx9vzcZqcjPg0lAnU+LwAMHVympsedy84XSLs0Ib7EXLMb3GrA8CbZczz8OW5s6KRp3iNRN13SXY+/EL9jqnm6oJnXV27V8EbbGIcTRxcpJqDkFeBroKq2663ltzPh1rwOtEWZCUPX5+LvYPzGA8H/RNXSIip7rqBQYlREuMALxyqBcI/ufpWuB63SRfeezaG9iiYzdOWdF2E+WZ9CEtFxJqwOlkMq7C3tJHC3zQS0WUyOw6g7iH6b2rZicWTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=klzvWXz6z3/0eA7KSP21kd21zrYuoW70onX2QLFdPcw=;
 b=Mn/f/YuBjl1GcAP0Hu8PJ4GPVLrktcenTCiMLSh6sDA6Sj7gljLLQ7mJHl9n5Pc3ohXYQjuZWIGkMlH+eSkLCCeR2hfBNnp6bmkHXzqwaGDSuzxwKL4HhEYRXijCR32Jzl0+RDX2IwgtB7g8AUZUs5h+a0ehQEbOVmNjfA6UJBDLmia89DhFrvsmcbsC1PhVUgWku0YLZxEsEujHfDAZCMQHHSieLWwuzUAqeXqw6KuRkdYdENDEjD4ff2BMFIzubpnKbys9ygjzyTueWfOQYlC/Msl0sz6+MpxUQ74yOjmgZ5I6qpMpV9x0KlQy5LLVjauMS5Sjk8+esP1am0gQdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN7PR11MB2673.namprd11.prod.outlook.com (2603:10b6:406:b7::13)
 by IA4PR11MB8914.namprd11.prod.outlook.com (2603:10b6:208:56b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.8; Tue, 10 Feb
 2026 23:02:10 +0000
Received: from BN7PR11MB2673.namprd11.prod.outlook.com
 ([fe80::9543:510b:f117:24d7]) by BN7PR11MB2673.namprd11.prod.outlook.com
 ([fe80::9543:510b:f117:24d7%4]) with mapi id 15.20.9587.017; Tue, 10 Feb 2026
 23:02:10 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Hansen, Dave" <dave.hansen@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "x86@kernel.org" <x86@kernel.org>, "kas@kernel.org"
	<kas@kernel.org>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "mingo@redhat.com" <mingo@redhat.com>,
	"bp@alien8.de" <bp@alien8.de>, "tglx@kernel.org" <tglx@kernel.org>,
	"Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>
CC: "ackerleytng@google.com" <ackerleytng@google.com>, "sagis@google.com"
	<sagis@google.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "Annapurve, Vishal" <vannapurve@google.com>
Subject: Re: [RFC PATCH v5 16/45] x86/virt/tdx: Add
 tdx_alloc/free_control_page() helpers
Thread-Topic: [RFC PATCH v5 16/45] x86/virt/tdx: Add
 tdx_alloc/free_control_page() helpers
Thread-Index: AQHckLzZ61zp4LHq+06z7n/dSkCkD7V8SEYAgABL1wCAAAD7gIAAB3wAgAABH4CAAAMagA==
Date: Tue, 10 Feb 2026 23:02:10 +0000
Message-ID: <b9b4b1aa3efad11e20b5935e08287d78825fefdd.camel@intel.com>
References: <20260129011517.3545883-1-seanjc@google.com>
	 <20260129011517.3545883-17-seanjc@google.com>
	 <655724f8-0098-40ee-a097-ce4c0249933d@intel.com>
	 <ebd424718bb0b2754b7cbacb277746a3076faea3.camel@intel.com>
	 <4fe6121b-6fe3-4c97-b796-806533ed6806@intel.com>
	 <b9b4b80a3818e9ebb3cb1aec76d1a1083fb91c7c.camel@intel.com>
	 <17d3ba24-7d58-4507-a5d7-43237974ba09@intel.com>
In-Reply-To: <17d3ba24-7d58-4507-a5d7-43237974ba09@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN7PR11MB2673:EE_|IA4PR11MB8914:EE_
x-ms-office365-filtering-correlation-id: f1e27b6a-cf63-4683-9ec0-08de68f86c12
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016|38070700021|921020;
x-microsoft-antispam-message-info: =?utf-8?B?ME05ampHTWM0SlJVTStmTnB3c2ZRMGYxV2gyUkUyY1l5Yyt3b0o5anlCWis3?=
 =?utf-8?B?WDJHOEZKUkxBSUg0VWZDRnFEODE1K1dlL0Rzb1I2dUxTbkovNWlqdUdWNGdI?=
 =?utf-8?B?SVNheHF3Nkt5YUNYT0UxYXpHWU4zWHJncU1BQ3BPNWJ5aEpWR25oVkZQNmZX?=
 =?utf-8?B?Nm9WWlFJanZRSHlzYVdDS1VSdjZiQ1RWblRRcm8rcnVJSjliZHQyOXlWZmx5?=
 =?utf-8?B?YnZUVWNFa0FYeVNhSm10bTRWZitzTk16QTUwbWw4NnZHaStSbGpqOW9yWFZP?=
 =?utf-8?B?SytXM0dXa0xLbnRMcGxZdENTSDJUM05XN1RDcFI4Tk43cHl1L3NnUjdSYkRK?=
 =?utf-8?B?Rlg4VERELytvbVVYOGxtZlBNelFoUklTRGJVUXAwaVdrWFNvRFpOeGNsRWdu?=
 =?utf-8?B?bWlyK3pVTmRaZUJ6ZjJaWDZBODVReVJicjVmaEtmaXZnZTlucXlVWTVrTFNs?=
 =?utf-8?B?OHhyZkJPak93UjVtSis4M3VHdW43Z0xkRHdaRmJDMUFRVDVueTFQeUdsS01P?=
 =?utf-8?B?ZUh5UUdDVEY2T0lzNTRMdHhmK2RhbXpCNEJRd0poSXpodkRYQ1VOUXVEUmVI?=
 =?utf-8?B?SWRvcjhCRFdENHVlUGdVNmQ3dFY5dk0vZDFEejlJcGd6OUE5K3A1ZVhFY1N0?=
 =?utf-8?B?c3ZRd2tyWmtjb3RrTmJ3ZmNRM3p0NW9tZE55MzlxRlYxd01veE1LbUF1azVC?=
 =?utf-8?B?VzlDa0U2UnRaWVZYdU9nRm0vcXVKQ3hORjJYTFkxd3BmVFQrdWI0eG9FUGtI?=
 =?utf-8?B?MmQxK3kwczhPQ296SSs1NHJqYVNNeTRBV3ZXd2pYRjhKTmUzY2lCNkRzV1Nw?=
 =?utf-8?B?VTA1aFdHL1pEK1U1WXFaVUR3QnA2Z3l1clhjb2JLbzlDMW5wRDVGcitRb3VZ?=
 =?utf-8?B?YUpkWUh1U1lBNHRlT09zaDhMbS9teE5HZUFhUElXU0RwV3VHN1BEeTJhVHdC?=
 =?utf-8?B?dnJ3b3lCbTZiUzJ6VVo3bHZzRWV6YitjTmhvcXM2WkQ0Z0Nnc0VJa0QxclAr?=
 =?utf-8?B?cDNJTEFNTnhsVTZHRTBqUFc1NVJrbUxkQVA1MVRFUGpUQmttVFhJSnZrazA0?=
 =?utf-8?B?cmpPZ1RNRFYvVS8xRzVxSXVEdllyR2toeGgwelRIVDZsZTA4RThENk5Pc0lG?=
 =?utf-8?B?VXRnak1JTCs4Ti9laFdZZjhwbVMxM1dCVmxPdjRpSDFtMTBqU21mWGFpNjhv?=
 =?utf-8?B?U1BFcURubDhiMjg1RHdKRDhZUWsrM1ZNZEt0QUdSaE5mQ3hJZGxpVTY2RFVL?=
 =?utf-8?B?Y2lQcVZTaWQ1emRjMldidnR0U2liSDdPQ0duY0NWUFh2OGVlTTl6U0hUTTlh?=
 =?utf-8?B?Tzl3b2krdmFvVTR5ZzBuSGpVbHc4T3lEWHY2UkpQQ0J0ajcxNXplOFBPSFF6?=
 =?utf-8?B?eFJWU0s4c1huR1llajBKb0ZFVy9teXNldHJQUGE5QmxPdklQMm9HRWxEZ1Uv?=
 =?utf-8?B?REVUazhxNXZ0WTB4a1NjYW1Od2R0cFNucE1sRmtLRXB6NE93T1dPK2I3a3RC?=
 =?utf-8?B?dnFUVUx0a2loKzF0ZDJaRzFkR0lhU2RQSmpoNjg3UXltLy8xaGJubER3RjlC?=
 =?utf-8?B?a2ZtSjExMTh0RWVmWGtYVlEvNUNEZkgrcnFqbkthWDFtVlI2Zm1jWk5oVm5R?=
 =?utf-8?B?cVFUQUM3Q3R4cHdvOW8xWkNwaDBLWjZRcGx5bU5XdktYVXpWVWhQOXBPVlZt?=
 =?utf-8?B?djZVSElnM2hOWGZGNlpIdG5BWXpsSVpQZnRRdTJZWVVWNVpqcEt2dmVxbVdn?=
 =?utf-8?B?Y3Yzc0lJdE8vOW5CL2xrNnp0S2s0QUZlNEM3Tjc5NFJtSkRQR25WQXl6WUs1?=
 =?utf-8?B?Sk9aYUZ0ckZnTHhHVWJJNW1CWWNIbXdGV05nNXd6cEdiYzh4U0ZvM0Fmdnhu?=
 =?utf-8?B?aHRRV3VxSUZCdThMUmFLb21IaVdGR3djUllYSFhjbHJNQWhJSUQzYTlVQWpy?=
 =?utf-8?B?Ykkya2puSmswUkxpck53aFhJMEwwMTk4NHhtaUFqR091SEUyYld1TlNrcHFT?=
 =?utf-8?B?aW1EQS9DeHZkQU92M24ySVhucmlhb0hBd0YvTXNUdW1wS0t0d3lPUGJyNnRU?=
 =?utf-8?B?Y3pObHNtS3phM1FwOXNxUVZLWTRpaXFIbmRrRWRHcWowSVRuZENxTnRUM0VE?=
 =?utf-8?B?MkZBRmtCWUtndjRUWEc5VG1KeS9PWFRNcnZRajlDdllyR3lPM0xWcE4yWG1a?=
 =?utf-8?Q?epWAHF3ro4iq6hfsi/nDopULzAdE8B10bAWZloTA+b8E?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN7PR11MB2673.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(38070700021)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MFR0OWY3SHZxOVMycXlHN1R3WVdiaWZHc3NSVGJTVjJhakRha3dzVGRwSmd4?=
 =?utf-8?B?a3VaQkNFQVJNK0hUekh6RWYyVGdrTFdkWXAzZzlOR3ltbUxUWW1rY3kxQjZT?=
 =?utf-8?B?cVIxN2NSNElzUWxmUmI4RS9WOWxnNkMrcWZneitvUjRtdGZVbXNZTXVXQVdk?=
 =?utf-8?B?ZTNHU21JT3o5aUJ6U1JsRCtuVUlwdDJCVTh6eWxZSjI0eE50ZXoySzFVYmhw?=
 =?utf-8?B?d3JXVk1TL3BrSTdyQ2Q5UTBSa0RsTzl2TUxHVHF0NjR6UnBiTkRPVmJ5OVYv?=
 =?utf-8?B?bHQ1c2ExY2ViY29Dcm9rbG0vd2Q0Ny9yK0dxY1VRTTRiQ0ZxbnhoRk41TG9u?=
 =?utf-8?B?djNSbkZiU2ozMTA0b1ZPdVp5dTFxcmQwRmJVazZXTHp6cXVocWZhMnNXYm9w?=
 =?utf-8?B?RUhMMElRWUtndDcrYk42dkcvMndFSDBSWFBWN3dDOUFSelFmZkVqd1R3UWZj?=
 =?utf-8?B?Ny9DTGpPWVRBa3RmMkQ5bE1kVGVMTnZTWVV5ZTlxam9ZK251RlFuRTZaejN1?=
 =?utf-8?B?c3NhZjNiZkk4ZW9rQ0dZL21MV3FVaTA3cjBkYllkbXgrTndGdDVYbk9SelVU?=
 =?utf-8?B?ZkFnWURCaVNiZEpvVStGVklReWluNnM1NVIxSDk4SnpsTmRCNlgxQ2J1UG12?=
 =?utf-8?B?RnllbUtuTjRKQ1BiWUZEY3pObzRsM2Z0Tytsc3dLTldvcWRFVGovZXBQdHNo?=
 =?utf-8?B?aG15dHZCUWhHWDVpY0wyUmk3aStDZi9xYUJmbUZRcktkaU5BcG4rczlJdFJt?=
 =?utf-8?B?MUFOV3NEUjdiY2xvNFdHVERWMmROdHVtMU5LcEp5RXZHemhrMk51TnV5aWdu?=
 =?utf-8?B?OVhMdEFxUzlmb0RYQTEzdTFraWhpeDI1MGFaeERqTzlob0VTa0dueGVIY0xI?=
 =?utf-8?B?MFRQSTlMUUJQY09GRmo2SUNTM0pDMXdwbWFiOTh3NHFHQmtXQVpHTUhtZmJu?=
 =?utf-8?B?M1VidTgrcXVSWTRibFkrVlJ6bmtpVkRSaGtyOFg2SEZKY1ZTanFLbU93ZmJJ?=
 =?utf-8?B?Y2FlWTQrbHFRdXZEZzJVUDhEK2x2S1VIQnhQQ0kyODhjcVVJaWZ2NXFMZ1dy?=
 =?utf-8?B?SGVRZzFnbEVxY2JZdENydnZCTHA4VDNJRDBzYVZqN1VVTFlXNlpBTDMwRk9E?=
 =?utf-8?B?QUg0WGtxYXVmNEF6UjlqdHdVWVE0THNuQ0pWZ0FGUlNCSXIyTTRaL1VkUGRX?=
 =?utf-8?B?YnJIQlpKY3NPeWdlQVFuNStZa1JERmc2M1ZHK2x2aDlwR04zTGlyMXd4REx4?=
 =?utf-8?B?TmhrckM1RU9aeW43U05TelJRRHJUMTVlR1hiaUpQU3cxdTZOdHRQUUpzV3R4?=
 =?utf-8?B?ZUFibHFpREdZb05KRWxvV1dXeGdyYzhrRERqWEJuWnhSNkRHcE9kMzMzempD?=
 =?utf-8?B?a0Z6MmdWaW5jQXR4SGM3dmUrQllYdHVCMW1zT0VBT29FQlNsL090aHI2QjAz?=
 =?utf-8?B?dVZCQU9NMXBkOXdDeVZWN0RZUUdHa0FzQlNzZjVwYWw1ZGlEWnk0UHBZdDc1?=
 =?utf-8?B?eWN5OTVSVVJra2E4VFRhMHRCNTNpdkdHcGxLTTR0UnV6c3JkVjl4Q3lPZ0Ni?=
 =?utf-8?B?VGd1d0tudXdmeVI4MEZ3emxqZnhaZUdyRjkvT21lYWxRdzhDSlpKRXllZ0lQ?=
 =?utf-8?B?UmZYdzVPVVdGQ216b01OTVRDdmNKZ0Z1aTRUZjJrU1RmTlJ6bFFRZHd4dEht?=
 =?utf-8?B?ajkwVmZYM1Q5TGRLeW9ndWZwZWNxclBGN1BRUWZJRVpsMEFPOVRkYitQT1Iy?=
 =?utf-8?B?b0MvZWdoWWhEOXhXdmNpTHoyd0N3TTFlMGZLcXh5VGxBMlo5RWJKdlJpMWxK?=
 =?utf-8?B?TXQwN2hCY2F4dzA4MU9xRXdWWXhNSCtBWUw0QUYrb3d1SmxnalMvZjhoVlRj?=
 =?utf-8?B?b0R6NGUzK0xBSkU2WEZXVHRoWG1lV01VS1BwT2cvcWx4L3lsRnRRL2pHcDE0?=
 =?utf-8?B?R243cGVTbnI3SVRPbGVrTGw2QzJxTWo2R1B3cm9WL3VHS3lLWmcxU2tIUWdo?=
 =?utf-8?B?NW1IOHRTSElqS3VjRDN4ZUs5OTFUWjZvNjkwdVRHMVlHSW5KcGlBaVFMdXU4?=
 =?utf-8?B?Q0FsQnNkS1JTQVRlaUh4bXA3TUFBaGpjYjBrc00yVzRuUGMwQ1czSVpCaktx?=
 =?utf-8?B?akE3bkRLNzdENVdYR2ZEM3NFVGVoMUFnMVJ0ampLU01hU3kzbmhRQWRxWURP?=
 =?utf-8?B?ejJZN2NicTBQOCtnZzBSbUFvM2lib1JJS3l1YVpHT3Bod1hrTUNDMXlUUFVT?=
 =?utf-8?B?cUtWUlFkY0hKL0tjcm5JNzliNUoyNEx6QXJPYWdkUmI5WGNBZGdYSTVHVTYy?=
 =?utf-8?B?dis0WkJwOEJ6U0tHNGhsYStBWjIzY28rSkdOM2lrbEQwdHpqRStUZz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8A7B2116206B5F4AA88CB686278C8995@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN7PR11MB2673.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f1e27b6a-cf63-4683-9ec0-08de68f86c12
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Feb 2026 23:02:10.7007
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0ZHx6Vk5AORA0ZXnPUsPURplKqV/KABAcXuHSohjjh00NCpHVcUsRyn8z0x737sBSvfSbtIM6dYOzw3wE/2g0w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR11MB8914
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.94 / 15.00];
	MIME_BASE64_TEXT_BOGUS(1.00)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	MIME_BASE64_TEXT(0.10)[];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70809-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[20];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:mid,intel.com:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kai.huang@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: E2BF111FE02
X-Rspamd-Action: no action

T24gVHVlLCAyMDI2LTAyLTEwIGF0IDE0OjUwIC0wODAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
T24gMi8xMC8yNiAxNDo0NiwgSHVhbmcsIEthaSB3cm90ZToNCj4gPiBTb3JyeSBJIGFtIGEgYml0
IGNvbmZ1c2VkLiAgQnV0IEkgdGhpbmsgdGhlICIxPT4wIGFuZCBsb2NrIiBhcmUgYXRvbWljDQo+
ID4gdG9nZXRoZXI/DQo+IA0KPiBNYXliZSBJJ20gYmVpbmcgcGVkYW50aWMuIFRoZSAxPT4wIGhh
cHBlbnMgdW5kZXIgdGhlIGxvY2ssIGJ1dCB0aGUgMT0+MA0KPiBhbmQgdGhlIGxvY2sgYWNxdWlz
aXRpb24gaXRzZWxmIGFyZSBub3QgYXRvbWljLiBZb3UgY2FuIHNlZSB0aGVtDQo+IGhhcHBlbmlu
ZyBhdCBkaWZmZXJlbnQgdGltZXM6DQoNCk9oIEkgc2VlLiAgVGhhbmtzLg0KDQo+IA0KPiBpbnQg
X2F0b21pY19kZWNfYW5kX2xvY2soYXRvbWljX3QgKmF0b21pYywgc3BpbmxvY2tfdCAqbG9jaykN
Cj4gew0KPiAgICAgICAgIC8qIFN1YnRyYWN0IDEgZnJvbSBjb3VudGVyIHVubGVzcyB0aGF0IGRy
b3BzIGl0IHRvIDAuLi4NCj4gICAgICAgICBpZiAoYXRvbWljX2FkZF91bmxlc3MoYXRvbWljLCAt
MSwgMSkpDQo+ICAgICAgICAgICAgICAgICByZXR1cm4gMDsNCj4gDQo+ICAgICAgICAgLyogT3Ro
ZXJ3aXNlIGRvIGl0IHRoZSBzbG93IHdheSAqLw0KPiAgICAgICAgIHNwaW5fbG9jayhsb2NrKTsN
Cj4gICAgICAgICBpZiAoYXRvbWljX2RlY19hbmRfdGVzdChhdG9taWMpKQ0KPiAgICAgICAgICAg
ICAgICAgcmV0dXJuIDE7DQo+ICAgICAgICAgc3Bpbl91bmxvY2sobG9jayk7DQo+ICAgICAgICAg
cmV0dXJuIDA7DQo+IH0NCj4gDQo+IHRsO2RyOiBLaXJpbGwgd2FzIHJpZ2h0LCBhdG9taWNfZGVj
X2FuZF90ZXN0KCkgZG9lc24ndCB3b3JrIGJ5IGl0c2VsZiBoZXJlLg0KPiANCj4gQnV0IEkgdGhp
bmsgYXRvbWljX2RlY19hbmRfbG9jaygpIHdpbGwuDQoNCkFncmVlZC4NCg==

