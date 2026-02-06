Return-Path: <kvm+bounces-70509-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0PMUBNxBhmmbLQQAu9opvQ
	(envelope-from <kvm+bounces-70509-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 20:32:44 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 65649102C7A
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 20:32:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3B58A3064E83
	for <lists+kvm@lfdr.de>; Fri,  6 Feb 2026 19:27:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9AA4A3093DE;
	Fri,  6 Feb 2026 19:27:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iqL9Y6L3"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AA392D949F;
	Fri,  6 Feb 2026 19:27:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770406061; cv=fail; b=WzKakY4D+JAbdqmzVy201ll40TAPCaC9HlPc8kiCUiYXOazVq/n9Pg9L5aJAK91XBtTROAz1EviSgf5BnliNIq6ubbfeBolBRLMch7yOS64chyQ0QIvGzwuM5LHSW3nODc3P9jw5Kx3ZvyVLeu0u1i88RJg9PEZE1jziTXWwbIA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770406061; c=relaxed/simple;
	bh=gO/l6TsF/3dms3ycLHETnCv+MYxoWlX/YE56gCq0jjQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=oRUnFOrWp5r4oKGnzpAdlTPtAxstzriO8quWyCZAd0yF8tY8JUBArh/+prKtiM2qqTkJmiccrIRc9rg0Na2Z4xSXntfe/+Jblt6DYTLfAVa3JOLM0iRUHn6C9XHPtueS76pQbgSEQCut8t3y154EMDM3aspxPJdrGR4j3DUAihk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iqL9Y6L3; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770406061; x=1801942061;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=gO/l6TsF/3dms3ycLHETnCv+MYxoWlX/YE56gCq0jjQ=;
  b=iqL9Y6L3pmoXroNAQ8MosZ8dta+HpwS9ZynniCXrGNHuGM+PSVQvuZJW
   Q/4H34u4GhK7b7I0WQ8BOI0Q/GTsFDcIzJ7Agsj0ljcdpulMlkkP69AoO
   ehpyo6tkSdwMGbBhjr/R5bvXTVOU1gGfRNOFoY7FBT6BvV6/tdfIKv2Rw
   XBEQcHZ+/MC90tRO9nXAhXKNmYvUUaBgfktcN0NL7oB/d7bTMc+P1ECiP
   TBzqXEvAOkfB8w5JxpwEIC4N/UcIfAtU+ZzGIaYd/ZpwH8Ov5L8rKApE3
   Vfo2MZt/Og0YJsjX//0/nxkm8nPYJsgXmzPwe3KIq5jD17PQFBS5dChEO
   A==;
X-CSE-ConnectionGUID: Ynmgk903TCyiLPHyFvYR9g==
X-CSE-MsgGUID: e4J07TwiRM2sX4QytAwNIw==
X-IronPort-AV: E=McAfee;i="6800,10657,11693"; a="75240444"
X-IronPort-AV: E=Sophos;i="6.21,277,1763452800"; 
   d="scan'208";a="75240444"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2026 11:27:41 -0800
X-CSE-ConnectionGUID: yDUdu41nTG+/GGwokLY5Rg==
X-CSE-MsgGUID: aB25kGNZTu+gTtV/DMsDtQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,277,1763452800"; 
   d="scan'208";a="241363717"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2026 11:27:40 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Fri, 6 Feb 2026 11:27:39 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Fri, 6 Feb 2026 11:27:39 -0800
Received: from MW6PR02CU001.outbound.protection.outlook.com (52.101.48.23) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Fri, 6 Feb 2026 11:27:39 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=p8g1X6uV5RPFYEB1q2wDByhLL5KhrY/PuFfEA9f1332++R9f7vDhGzHeBZAeTXIOJ2kKPYbxeNuCD2M2uRtoiRmKLX8N1HHai+WRHxB8hWynPGlGnAnZkpIP3DD37SmOUvv71rvCz27/Vfrsd/U/SxVv43QK0r7CcO/R3s6qkFbPVBJc2bqhVQVVQXX1DmrX8U3R8wjkshE6ZIxHTk6WkU7zWNTugMQiECcAVWDJORVz1luZRvK7c6qy9ma+0WJnHbY9a0px34grz6DU3RHshU9+opwCWd+4tX9cdKOs1D4MJJ0Qtt6/303so4ki2Csv7YB4OsuYgyt/BhwHDk64pQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gO/l6TsF/3dms3ycLHETnCv+MYxoWlX/YE56gCq0jjQ=;
 b=PFie/7aHsDYOM0o58cuzqvAqdOrUaLY32Kcs8FLBzM0vKvhFe6QOtuIeVLPzIe2k/a63FdfCz5IIHjpNSa5iVcika/0t6aSVcCACIGdo/WMF1CD8fv7gGGx+I/lWii4TDlRM/B+n+2eObDta9+J+zvJ+43tuoR9gbrrCf0JHAw5Flazy3gnYqntRgBrYKuIUTO8ONyMBb94y5bDMJye6/TvQx4Bi8DiiLV3xk9DgJU3w1pdMAzgIu/iYM2jfydwTXykXGa9U7DwC/sAlZuZHpXBKodWMG7d5nl0S0Y0Nj0qwZsT6TJa9MyWT4Xjhprbni0qoBts6hdAnBOaWNnlRhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DS0PR11MB8717.namprd11.prod.outlook.com (2603:10b6:8:1ab::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.15; Fri, 6 Feb
 2026 19:27:36 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::3ad:5845:3ab9:5b65]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::3ad:5845:3ab9:5b65%6]) with mapi id 15.20.9587.013; Fri, 6 Feb 2026
 19:27:36 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "Li, Xiaoyao" <xiaoyao.li@intel.com>, "Huang,
 Kai" <kai.huang@intel.com>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "kas@kernel.org" <kas@kernel.org>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"ackerleytng@google.com" <ackerleytng@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Yamahata,
 Isaku" <isaku.yamahata@intel.com>, "sagis@google.com" <sagis@google.com>,
	"tglx@kernel.org" <tglx@kernel.org>, "bp@alien8.de" <bp@alien8.de>,
	"Annapurve, Vishal" <vannapurve@google.com>, "x86@kernel.org"
	<x86@kernel.org>
Subject: Re: [RFC PATCH v5 22/45] KVM: TDX: Get/put PAMT pages when
 (un)mapping private memory
Thread-Topic: [RFC PATCH v5 22/45] KVM: TDX: Get/put PAMT pages when
 (un)mapping private memory
Thread-Index: AQHckLzwCgvmuzjovk6gFrXf+s6dG7V1gv0AgABf7oCAADjnAA==
Date: Fri, 6 Feb 2026 19:27:36 +0000
Message-ID: <b3ad6d9cce83681f548b35881ebad0c5bb4fed23.camel@intel.com>
References: <20260129011517.3545883-1-seanjc@google.com>
	 <20260129011517.3545883-23-seanjc@google.com>
	 <aYXAdJV8rvWn4EQf@yzhao56-desk.sh.intel.com> <aYYQ7Vx95ZrsqwCv@google.com>
In-Reply-To: <aYYQ7Vx95ZrsqwCv@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2.1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DS0PR11MB8717:EE_
x-ms-office365-filtering-correlation-id: 8c49ade7-ece3-4ae5-3b88-08de65b5c8f8
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?RWNxT1lEYm1LZXRZQzlxdjhuUXNIOG1wQjE5YUJjTFBraFpWN2JaWkNhSlly?=
 =?utf-8?B?M1g3dklhUmNwaXNaWVZCZEhPbk5POGt3ZGRFcm5SdE05NExhVGpwSlFQWnp0?=
 =?utf-8?B?Wm80ZWc4TVdqeWNKRHJ3TjM5TXR1QTI0a1RYL0ZjRFNVK0FzZzVTVGlaaVM1?=
 =?utf-8?B?RWJmczFiTnl4R2taMHJEcUR3VUcxWERDME1vU05YUDl1WGtJN3FzTTVTU3g1?=
 =?utf-8?B?eW95R0tjV0VESktFSTlsYXE0V2J3Q2RrN3NaVzVDalYrd21zZ1pvaDYvL3o5?=
 =?utf-8?B?SzRxMktGYSs5SXREekFaenh2ZGN5OVZUdlplU3VxL2pRR1Joa09BVkY3WG9T?=
 =?utf-8?B?ZGc0Z01NOFUxZnpBZWxselRPVXU4Mmd1RjNPNXZIMVRKL1VvcldQZGNzaUYy?=
 =?utf-8?B?cWp5S25KVHg1N3FOd1g4dVR0ZVpqNnFUbE9mSVNXdlI5by9wV3BnSTM3VGFr?=
 =?utf-8?B?QyswWFVUbGRFOHpTelJOM0d6dlZ4cVpUcDhJTjI3akVVUTBwdjAySlpPeDBR?=
 =?utf-8?B?akFrR0p1RXlrRHk1eVVsVzU3M3JLMHIySGx6WFo2R0NTOFdFWkZ4d1J5REZO?=
 =?utf-8?B?MFpWSTNtN2JVRlltZ0paU01vK3dSc0ZDMGZRdGtzRVJadXpaTzMrRWxDd0FF?=
 =?utf-8?B?TGtlSkJoQSsvem4wSHBZbENMejhWMklVQ3MrYllxbTFieHZjbTF3TnpKcVB4?=
 =?utf-8?B?VHYvWXZnT0ZFRFdmU3pYTzZPSSt2b0FrZjd0c2xDNS9nT2VhcHZUcEl5Y3pK?=
 =?utf-8?B?Y2NRZVBXbERHZlJUdTJkYkE0c2xqMmcwMUh1T1hXZTl4SEdNSnJsa1VjSEhY?=
 =?utf-8?B?Rkp6VUVucFRwbVhINGNocjkzZmZjRGlFN3VOZUZiaytlVUtLRWMzbkRnYmhq?=
 =?utf-8?B?b1B5YzkwU0JyVVU5eERXT2Y0U1U5NjJacWUza3JNZmt4SXFKOWhPcGRnNnZU?=
 =?utf-8?B?enJ2a3p3bWUwMHBPclYwSHBaMmIzQzRGeHB4d3NwUkVPNjBueVFqUHRqUjAw?=
 =?utf-8?B?OGgxaDJxNGlZMk9Sb0FhU1dYeXZJcTJOMDhGaGhaL0NsVFNLYW5uYVV3aGNR?=
 =?utf-8?B?R2Z6TmhhM2Q2cGxWQUZiMjZDeWllVzRobmFtSFVZS2U1czVETXI0N1dWOHRL?=
 =?utf-8?B?UHlhNkU4eUxvWHpnWjFKeG40NWxNTElzSzFOWXJzb1FNU0xZVU4rSmtwRDVF?=
 =?utf-8?B?L3hDZjJZR3VsYW5FQ05idnphMmVVenZSMTFSS1Z3YzN5VndXcXY1Z09zV2hD?=
 =?utf-8?B?MkU3MG9GSW9YY1RIQ1IvbElaVHhoVzhhR0JIMHJWamNIS2h6VmRrNEJ6MTNr?=
 =?utf-8?B?Q1RFazdNOVBkQnJveDRjdU9LdW9scGcvNTUzcEp2dnh0Q2hVMUw0Q055T2gy?=
 =?utf-8?B?MjRTNENNMncvVnBOdlJkUndjeWltZzRRaklGWUFUN2g0ZzBNdEFsVXdnVGFH?=
 =?utf-8?B?V1RJMXV3bnphTjJRTjRtVjhhT3ByYjJyOWxvaUM5NG50b1ZNRXdyaEdtYVVV?=
 =?utf-8?B?WG1NR1lRTCtseG5hL2RwZy95ckxQNkF2NHFsOVZRa1BRWmQvamtJMUJJSHBI?=
 =?utf-8?B?NTBkUXd3U3NKWFhGSStkeW9Za2Rab1RkKzNnN1QwbFhDOUg5aUI3OTc4NGho?=
 =?utf-8?B?ZExjajc0YWJCN3F4T0xidnRwbU5tbkZGWk4xOHlyMXd0MkkxenJKUFNXTGt1?=
 =?utf-8?B?UUNhMVZTNFVvMkx0aEhIc0QzVUIza0NYU29HeDlWWWxQdnh2V29XN2t3VFVt?=
 =?utf-8?B?NzZjdGgzMlJOS3NYdHJuc2s3aXRQWU4yUVpGSmNGLzAxZENUd25VaXpwdHR5?=
 =?utf-8?B?bmFpUk9ZZFFyNkpySjlidDl4di90ZnJqZzZOS0ZEaTBIdjZMRTJ2RWtUUHRM?=
 =?utf-8?B?SG9uUU9lcTBKTlpnMlU5NUxHT3dyMHdnbTZPREErRXhvemVCSnV6eW5BMm93?=
 =?utf-8?B?aDFrSjJMMjdKZWFuM2RuZkFlOVh3VmNpdElhRVdQUFEzYmRJNGdIa3VnZEdL?=
 =?utf-8?B?S2dmRlhXY3RWK09sSzN6OG1RYlNybVZhU2JhWDRFeC85elVOSWNhQlVmanpS?=
 =?utf-8?B?T1RleGh6Rkcrc3BpdVhXcXVEUjV2aTlCcU43SlNzS0ljSzd0UnQ0SWJCcVBn?=
 =?utf-8?B?QTlSZ3p3NURUVVduemR1RENKVVJPM2hZMTZPbklNNUFKM1ArQ200NmRxczZ1?=
 =?utf-8?Q?lE9JZjt1xMcMpGx0AOppcH0=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TDFERzNwanFmSXJ3UXhwdXk3VWd4QUtJYkxvNWRIOUx5aFlFTVZHZXlaKzNE?=
 =?utf-8?B?REdTOWhmSUZZK0JNY1IvV0dGQWN5LzNmeC9oaXRRU3liaGFIT2NnaVhzWkUy?=
 =?utf-8?B?VnFqSit1ZjA1dVlkNUQ3Uk44TkxVYVF4NGVuMjFoZnpUdzhhVU1qOUpqaFg1?=
 =?utf-8?B?RHM0T3Jmd0VPOUNjOHZwNkNaQ3gyM0ZiTFE4NG5NQ2RtRE1pTmdJVm5tQXlt?=
 =?utf-8?B?TnNZN2tFb1FUSEM2eUZ4U053ckxLTnc1cVl3N0VWV1VyTi9QR1RNd2E1Z3Rt?=
 =?utf-8?B?dWFXNXdjbDFQMFhrQ2w3UXJZSzVXWTdCNnRsYjBMTndBekxQc0pSeG5qLzVJ?=
 =?utf-8?B?WWc3UU5IR0I3cGVielBkb2N4Q2diNlp6N3FLU2dFVnhvUFBVbERIblZOak9H?=
 =?utf-8?B?c1Z6S1JZVkFvWFo3VGtva0hxd3haRXdjZ2NGQU9EejRGSTIzNUtiN3R4Z25o?=
 =?utf-8?B?Ry9hVE9laHFvSUNOOGtiUHFtV1NwOU5uOEg4MkF1UmwyNGM0OW1XYjFlZk4r?=
 =?utf-8?B?Y0JrSk1icGRmdyt5TlZxY0RLVlg4cWt3YTZiaU55aENodU90SGtrOVRONklx?=
 =?utf-8?B?VXNoNVRleUgwSWhjMEpaRHVRalkyRXI4Tm5qbHNnTVN6a1RuOUxpWmpLdDNn?=
 =?utf-8?B?K09XS0NGSm9nUTBMZzVZdFg3NzJWMG1ORWoxMHlqaVRoZjNub3luQ21vS0xj?=
 =?utf-8?B?cW9md2oyZlpaRUtiNEczamhNU2NnT1I5Z2EyOXd4QnhXSUxEVjZ0bm1lYzBk?=
 =?utf-8?B?eDBGbmxNUzJqSDVZTENOL1V0SDVqM1ROck9wL0dnMnRCK3JSejRtelQ1aENQ?=
 =?utf-8?B?MkZoS1ZlVzJ4TWVqVGtqSTEvYmxlbngyNFBBSklQMUNKckpmLzVtcUN1Q2Rp?=
 =?utf-8?B?a0RNQWg2cEhNMnM5aU9Pb2VjdmloL2pmR3JicG1LMmg0d0czVXZxeGdONzR0?=
 =?utf-8?B?TlQ1OE5kNlZSWlpKN2ZrRkJ0bWtWY0JFaHB1N0VJck5HSlpNUWR5b1ZiZnJ4?=
 =?utf-8?B?S3RtWmxmYnV0aWxXdmZFWlMyOEtKcnRNVVhwYmE1eW8yYm9XT0hQZVhEcmVn?=
 =?utf-8?B?NUl1RVRSMmNDbHRhR2JTYUNVVkpMQnZpYnh0NDZmL3ljMkxUdW1jSlE3dEtM?=
 =?utf-8?B?SVcwbENGN1JYR3hESmZyRWVnQzNXQVNyMENLSnBEV0ZWakI5aEJnVEJnUzIv?=
 =?utf-8?B?NUd6d3VCK05wcDZkU0l0aWluZU1VRUQ0Qjd3TFFZclF1WFdZb0FRZXBaR0tB?=
 =?utf-8?B?SHRZM0pwOElZMUpQNGRzVDZ3eWVDVUUzWkVBSktnRzBXYzlwdkVjTFdqVFg5?=
 =?utf-8?B?T3laSUZ3ZENNeExEV25STFhEUkQ5TVJiRWttc2pSK1FXakJsUUpFUjNLZHdQ?=
 =?utf-8?B?RkJXdk9pdEJRbFdDamtobUdTNTY1bE9iZmRNdmM3cUJBcU02aVYvcDRNWmdR?=
 =?utf-8?B?c3IrSVdHLzZJNm9VSFM0UHpGbjhUMFhiRDhTUzdrcmdtZ3RjK1VpTHcyR2xZ?=
 =?utf-8?B?amtuUCtNenAyQktmb01HeW16aTIrZGlSSkh4a0IyZDNGYVY0WFNJNFk1NDZ1?=
 =?utf-8?B?cncvTElqSFdjeGpRRm1VRGNUVEZPeDAxbjBYTjJkczRqYkVMR29vNUtPZjFz?=
 =?utf-8?B?UmlmaDJHTnlXSG44bW9RTzVwTzJkMS9JYVllZEc0WXkveHBVcGlaeWx2RUNM?=
 =?utf-8?B?dHM1VXlKaGZMak1pSWZmcE42STNkUEREL2tKMTRERU9vUHMxREpRdjllUllC?=
 =?utf-8?B?Y2ptOTY3aXorKzNrTGdOTm5vVDlvaXUvSnAycnVuMDNhc2dkc25yaDF4bnMz?=
 =?utf-8?B?b20vWXhWMG8yVjNwa2NNV1QrV2ttWW02b0g5cmJja0lOQmpoLzg5RUcvU0hj?=
 =?utf-8?B?cE9Xc1NJcE1URkdtMzhVZjhxQTBRTTZEV2NZbzVIcWpkSENyRkZYeTUxSGU0?=
 =?utf-8?B?bjFoYi9QMUwweVVvS2VSeXNhbjIyUnpiL000cDEyM0NjT0IwOEtONTB4djY1?=
 =?utf-8?B?OWdHTzM3RHJPSkE2aHZTczVFVnNrdko1YkxCUEJyN1Y4VWxObDVGUUxrTmRy?=
 =?utf-8?B?Um9nM1JrU3Zkb3c4WWpKR0duQXRBODF2Z3dpa3N3eFZrTE5PQ2EvMzZQTU5Q?=
 =?utf-8?B?UytaL0tPVm85c0VuQmtSd0JudXpGSDd2Yy9BY0wyWm1ZNzRtQjd5U2hJeDNp?=
 =?utf-8?B?QjNkV3AzVVZYKzZmV29udTdlanpjWFZGQ0NtbmZvbTJRQzhPd0JySWlxMUtq?=
 =?utf-8?B?ZjNiVGU0VnBpcnJyb3JpMVIrZUgzeW42OTRWQ1d4ZFlOZlFBWkF4L2JxR0JG?=
 =?utf-8?B?bEI4NHB0M2s1Q2tPS0VGZHdHckhBOVcvOTBOUUIwaW1GeUlyakNodHBjWExM?=
 =?utf-8?Q?92vCjN0rHo5jRt5w=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <98330D3BB98963418D13EAAF0CCACC23@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c49ade7-ece3-4ae5-3b88-08de65b5c8f8
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Feb 2026 19:27:36.7780
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BVXvhNrTU8tSQTFh08ERmW+fqsqDB8caNwRMKn6gstMrVq15llJs7ETTAvVmnuZpk7jPC7pcWnXUlG3gKvcYEepFeu/K2z60+KJev4082MY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB8717
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.06 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	MIME_BASE64_TEXT(0.10)[];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70509-lists,kvm=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[19];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[rick.p.edgecombe@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: 65649102C7A
X-Rspamd-Action: no action

T24gRnJpLCAyMDI2LTAyLTA2IGF0IDA4OjAzIC0wODAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiA+IElmIHRoaXMgZXh0ZXJuYWwgY2FjaGUgaXMgZm9yIFBBTVQgcGFnZXMgYWxsb2Nh
dGlvbiBmb3IgZ3Vlc3QgcGFnZXMgb25seSwNCj4gPiBoZXJlDQo+ID4gdGhlIG1pbiBjb3VudCBz
aG91bGQgYmUgMSBpbnN0ZWFkIG9mIFBUNjRfUk9PVF9NQVhfTEVWRUw/DQo+IA0KPiBPaCHCoCBS
aWdodC7CoCBIbW0sIHdpdGggdGhhdCBpbiBtaW5kLCBpdCBzZWVtcyBsaWtlIHRvcHVwX2V4dGVy
bmFsX2NhY2hlKCkNCj4gaXNuJ3QNCj4gcXVpdGUgdGhlIHJpZ2h0IGludGVyYWNlLsKgIEl0J3Mg
bm90IGF0IGFsbCBjbGVhciB0aGF0LCB1bmxpa2UgdGhlIG90aGVyDQo+IGNhY2hlcywNCj4gdGhl
IERQQU1UIGNhY2hlIGlzbid0IHRpZWQgdG8gdGhlIHBhZ2UgdGFibGVzLCBpdCdzIHRpZWQgdG8g
dGhlIHBoeXNpY2FsDQo+IG1lbW9yeQ0KPiBiZWluZyBtYXBwZWQgaW50byB0aGUgZ3Vlc3QuDQo+
IA0KPiBBdCB0aGUgdmVyeSBsZWFzdCwgaXQgc2VlbXMgbGlrZSB3ZSBzaG91bGQgZHJvcCB0aGUg
QG1pbiBwYXJhbWV0ZXI/DQo+IA0KPiAJaW50ICgqdG9wdXBfZXh0ZXJuYWxfY2FjaGUpKHN0cnVj
dCBrdm0gKmt2bSwgc3RydWN0IGt2bV92Y3B1ICp2Y3B1KTsNCj4gDQo+IFRob3VnaCBpZiBzb21l
b25lIGhhcyBhIG5hbWUgdGhhdCBiZXR0ZXIgY2FwdHVyZXMgd2hhdCB0aGUgY2FjaGUgaXMgdXNl
ZCBmb3IsDQo+IHdpdGhvdXQgYmxlZWRpbmcgdG9vIG1hbnkgZGV0YWlscyBpbnRvIGNvbW1vbiB4
ODYuLi4NCg0KRnJvbSB0aGUgVERYIHBlcnNwZWN0aXZlIHdlIGhhdmUgNCB0eXBlcyBvZiBwYWdl
cyB0aGF0IGFyZSBuZWVkZWQgdG8gc2VydmljZQ0KZmF1bHRzOg0KMS4gIkNvbnRyb2wgcGFnZXMi
IChpLmUuIGV4dGVybmFsIHBhZ2UgdGFibGVzIHRoZW1zZWx2ZXMpDQoyLiBQcml2YXRlIGd1ZXN0
IG1lbW9yeSBwYWdlcw0KMy4gRFBBTVQgYmFja2luZyBwYWdlcyBmb3IgY29udHJvbCBwYWdlcw0K
NC4gRFBBTVQgYmFja2luZyBwYWdlcyBmb3IgcHJpdmF0ZSBwYWdlcw0KDQooMykgaXMgdG90YWxs
eSBoaWRkZW4gbm93LCBidXQgd2UgbmVlZCBhIGhvb2sgdG8gYWxsb2NhdGUgKDQpLiBCdXQgZnJv
bSBjb3JlDQpNTVUncyBwZXJzcGVjdGl2ZSB3ZSBoaWRlIHRoZSBleGlzdGVuY2Ugb2YgRFBBTVQg
YmFja2luZyBwYWdlcy4gU28gd2UgZG9uJ3Qgd2FudA0KdG8gbGVhayB0aGF0IGNvbmNlcHQuDQoN
ClRoZSBwYWdlIHdlIG5lZWQgaXMga2luZCBvZiBsaWtlIHNvbWV0aGluZyB0byAicHJlcGFyZSIg
dGhlIHByaXZhdGUgcGFnZSBiZWZvcmUNCmluc3RhbGxpbmcgaXQuIEl0IGFjdHVhbGx5IGlzbid0
IHRoYXQgcmVsYXRlZCB0byB0aGUgbWlycm9yL2V4dGVybmFsIGNvbmNlcHQuIFNvDQppZiB3ZSBz
ZXBhcmF0ZSBpdCBmcm9tICJleHRlcm5hbCIgYW5kIG1ha2UgaXQgYWJvdXQgaW5zdGFsbGluZyBw
cml2YXRlIGd1ZXN0DQptZW1vcnksIGl0IGZpdHMgYmV0dGVyIGNvbmNlcHR1YWxseSBJIHRoaW5r
LiBCdXQgaXQgY291bGQgYmUgYSBiaXQgY29uZnVzaW5nIGZvcg0Kb3RoZXIgdHlwZXMgb2YgVk1z
IHdobyBoYXZlIHRvIHRyYWNlIHRvIHNlZSBpZiBhbnl0aGluZyBzcGVjaWFsIGlzIGhhcHBlbmlu
Zw0KaW5zaWRlIHRoZSBvcCBmb3IgdGhlaXIgcHJpdmF0ZSBtZW1vcnkuIEluIHRoYXQgY2FzZSBp
dCBjb3VsZCBiZToNCg0KKCp0b3B1cF9wcml2YXRlX21lbV9wcmVwYXJlX2NhY2hlKShzdHJ1Y3Qg
a3ZtX3ZjcHUgKnZjcHUpDQoNCg0KVGhlIGNvcmUgTU1VIGRvZXNuJ3Qga25vdyBhYm91dCBEUEFN
VCBiYWNraW5nIHBhZ2VzLCBidXQgaXQgZG9lcyBrbm93IGFib3V0IHRoZQ0Kc2V0X2V4dGVybmFs
X3NwdGUgb3AgdGhhdCBjb25zdW1lcyB0aGlzIGNhY2hlLiBTbyBob3cgYWJvdXQgdGhlIHNsaWdo
dGx5DQptaXNsZWFkaW5nOg0KDQooKnRvcHVwX3NldF9leHRlcm5hbF9zcHRlX2NhY2hlKShzdHJ1
Y3Qga3ZtX3ZjcHUgKnZjcHUpDQoNCg0KSXQgaXMgZWFzaWVyIGZvciBvdGhlciBWTSB0eXBlcyB0
byBpZ25vcmUsIGFuZCBub3QgdGhhdCBzZW1hbnRpY2FsbHkgd3JvbmcgZnJvbQ0Kd2hhdCBpcyBo
YXBwZW5pbmcgb24gdGhlIFREWCBzaWRlLg0K

