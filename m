Return-Path: <kvm+bounces-55046-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 12E31B2CEFE
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 00:01:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3C0FC5E5920
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 22:00:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A2A4327782;
	Tue, 19 Aug 2025 21:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FLtlmmbr"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7EB9202983;
	Tue, 19 Aug 2025 21:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755640664; cv=fail; b=sZ4P5jC7TQIKVNielkbhYo977H4hevOWP2IUihDZczqYC+wo6zIgqGDKOukXAi4CWRLA9dznIgyaG5inV2c/P302SwfvjexrDibqFduuqVJkV8qqSvkwASLRmNnVM3T0szUdIJJutwFMOJqcW6wIWOa7fqKpzPghIPj+mjMdo1Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755640664; c=relaxed/simple;
	bh=lMEwFTs6Wh1vn2X1M/HtZM/CcoLrJ10lbfch4PnSBeE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=BA5hxtGF9RhWGOz8B03ePDoGc5HlI4wJHsPMax6Mb+1W8ocWJquFrEnRXkWoY05tOq+vvokaa6bL2qOfoBkl/4gFrtbS+QCQzbcnc2lDmdJZ/IisXw8OneSkZw6Q7CuaMIT50YEggbaaX+bH0W1y3uRc9xnQolpFjYbgMyEsh1M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FLtlmmbr; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755640663; x=1787176663;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=lMEwFTs6Wh1vn2X1M/HtZM/CcoLrJ10lbfch4PnSBeE=;
  b=FLtlmmbr1FdThBDFGXJ5EYWSVe4qRBKABhBLLoi5oOhTieoYN+WNhAyw
   rES9RfzIwz15GGNhaP2jmA6nHP7D/mt6r66pHeRPL9CDEBYeqES34kxmn
   Qbge0318AlQUlZmZynGrugU4ExqNAPSerkd4yOl8JwUVsFyrrU/xVx+48
   SfgGv1gHAvWUttV3x03jzVeGETz6UppvW8XdtZOkcRy8zap65IWU7HFbY
   aXDXfpwmlsJ8ckYJGio4odrP3lcVA/X44zmlrqZmhKoxqfp5yHpujyu4u
   JLIGh4JlI4hK/hO9f2Ajht8kfdykhEwww2C4wuQHAebWL7A6qG2l5hfUf
   w==;
X-CSE-ConnectionGUID: mZIN7317S1Kt+yIyvqUeXg==
X-CSE-MsgGUID: XWX1v8oUST+aUCVvtMCo0w==
X-IronPort-AV: E=McAfee;i="6800,10657,11527"; a="61713125"
X-IronPort-AV: E=Sophos;i="6.17,302,1747724400"; 
   d="scan'208";a="61713125"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2025 14:57:42 -0700
X-CSE-ConnectionGUID: R0VuW2npTiCjhyimNKfuMA==
X-CSE-MsgGUID: GpKJfzVARyy74Qi0yvMvGg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,302,1747724400"; 
   d="scan'208";a="198954567"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2025 14:57:42 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 19 Aug 2025 14:57:41 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Tue, 19 Aug 2025 14:57:41 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (40.107.236.60)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 19 Aug 2025 14:57:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NQBUPgpHPpTwr9VBukjxrpbZZAtrTbNNtVVSA1oIMC7RsyjvW+jnz3jbXXMakW1UwaHPv/5vUhz/QVZkGRB4iMVPfwzI54LGYLnyCxLoKq10+wtGRd0c2fgejbIM/hcOP5DmQZFs3ugCra2J2yqLd8M9hXn66ykRyT3Dp98IiznN/dHrkcMW+tzwB+wflLffbFPT7UDpaYUBbtLVvSinV9LEHcgfNaplajLs9ETlQWWmTgjBG10LNUZm4KIrPs2Dq5KQdA10+UBgr1RBY5hp4nPO6MyfGmVwovF+w4icI0K7fQPfMZei/cbMwexpLYyZaoh4K7HS8BNz7aXS7RCC2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lMEwFTs6Wh1vn2X1M/HtZM/CcoLrJ10lbfch4PnSBeE=;
 b=KtS9YqOFSfHMyA4pxKXq25OOq5pCX92vET2ZMMFw7qTtk/Uf9qodBe32RMFB2V86Z8CVRlOgYjSrgOtS+TuTZdutq6WpBcCR42keX7ugjGHOsxNgrRU1msaWZPlv9NKM5EA9hw5u/23LN+BOV6caNmN52mh9uZJUVNVRY9AUO6ylQ+qIYC0aOe8lhw/UxBP54m2MNcC5Z0W7Jxk01hAgUAq1qs4g8MqQCT5KDBu4NCTg1tzMfEvco46umlWbkNvre/1VSU7k1DehlFuXf6jJenw4u3cJysdByScoux9cDZ1n+B7FyL4Yd6Eesr9Ly8cCKxXgZo/5jh/FJ3r137GOHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by PH7PR11MB6748.namprd11.prod.outlook.com (2603:10b6:510:1b6::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.24; Tue, 19 Aug
 2025 21:57:36 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%4]) with mapi id 15.20.9031.023; Tue, 19 Aug 2025
 21:57:36 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "bp@alien8.de" <bp@alien8.de>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "Hansen, Dave" <dave.hansen@intel.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "ashish.kalra@amd.com"
	<ashish.kalra@amd.com>, "kas@kernel.org" <kas@kernel.org>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "dwmw@amazon.co.uk" <dwmw@amazon.co.uk>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"mingo@redhat.com" <mingo@redhat.com>, "nik.borisov@suse.com"
	<nik.borisov@suse.com>, "hpa@zytor.com" <hpa@zytor.com>,
	"peterz@infradead.org" <peterz@infradead.org>, "sagis@google.com"
	<sagis@google.com>, "Chen, Farrah" <farrah.chen@intel.com>, "Edgecombe, Rick
 P" <rick.p.edgecombe@intel.com>, "Gao, Chao" <chao.gao@intel.com>,
	"x86@kernel.org" <x86@kernel.org>, "Williams, Dan J"
	<dan.j.williams@intel.com>
Subject: Re: [PATCH v6 2/7] x86/sme: Use percpu boolean to control WBINVD
 during kexec
Thread-Topic: [PATCH v6 2/7] x86/sme: Use percpu boolean to control WBINVD
 during kexec
Thread-Index: AQHcDKjxblwuDV1+F0e8aiEQzaHXe7RqZYiAgAAproA=
Date: Tue, 19 Aug 2025 21:57:35 +0000
Message-ID: <4d82901fe00485fe30ec6b334dc83a6de9878bdc.camel@intel.com>
References: <cover.1755126788.git.kai.huang@intel.com>
	 <c09d17677fa127a7b23b24b6c225f7dc5b68fd98.1755126788.git.kai.huang@intel.com>
	 <20250819192823.GLaKTQVxIV4n7p60hU@fat_crate.local>
In-Reply-To: <20250819192823.GLaKTQVxIV4n7p60hU@fat_crate.local>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|PH7PR11MB6748:EE_
x-ms-office365-filtering-correlation-id: b84ac0a7-cbfb-4a5a-566d-08dddf6b683d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?T2NVRkRTVE4vcWlidFA1elJ4T3pkWlAvemp5Z2ZXbmdMR01STEEwRk5ZdVRq?=
 =?utf-8?B?UGpHMGpiVU9kZ0pGWml6ZHZsTkRWUWcwY0pmeXg1VWVhbE5pV3BBYUpBcmtP?=
 =?utf-8?B?RWIwcnkyYTRGMndzMnpnNGZRUXg4WVllMjg1RHBKczE2WVhCVWFhWTVTQXc1?=
 =?utf-8?B?OUplMmpDWlh5SjNueVBRVUVOc0ZuME0za0JtamU2ekkrb3JubEhCMEFNWlhq?=
 =?utf-8?B?RDBnRGw5cW1EOTZXa1NIRXQyRDlUaVpNeTc3Y3BwYTlpRkRIc0dNWmM3ZU9h?=
 =?utf-8?B?LzNDMWovaWV5TC9JLzc2eGFPV0RkSEdBWlhBNElYdjFnSmdiOUsxdWRqMzE1?=
 =?utf-8?B?T3BNcWxoT3QySDZhWUFseHF1L3AxRE1KV1hsSFNoSHlTYlRxa1U4TkhqOXFB?=
 =?utf-8?B?SVBIVElUaGUyQXpZQ1Z3a2JXNHBNT1F0MW5ySHlIZ1UvZG9lam9JNEltcDNM?=
 =?utf-8?B?SnJvWHl1M08wVDBiajNvSjBuZ2NrQjdQN2pQWWViWUw4UWRWdXQxOENqUDhJ?=
 =?utf-8?B?RzhMS3U4Vm5TSDZUZHdRdFhJNnF0SkRoZTJNUzIvZjdqMkRXZ1FrQlVXazE4?=
 =?utf-8?B?VlZ1RGxONWpDWUhaeW1RdnBmQUNzcXNoUUdoYTB5cE5GQm0vNlRYWkgyYmFw?=
 =?utf-8?B?RW5WcjZaYXRJZUx5d1h0MGcvdm9YTHorUnowTUlualplRGZwaUlnNWtneWM2?=
 =?utf-8?B?cTRRbjQ3VGNmeVJwemtzYjdyUzJqVkVOdEdIN1hBZVJjYkhDODludEhZMUtM?=
 =?utf-8?B?eDQwYzBqZ0J4K1BEcUl1Mld6SWE5TTZXTXhuaitJa0FESENPWjFsTW9PVmxV?=
 =?utf-8?B?eWJZWmZMa3FaMUVvdTJjczBXTjZUVFVyZERqMDZUdDN5YSszUjNpVWlpYXdH?=
 =?utf-8?B?dThmRFl6WlRBMm9nUkRkRUI0QWxIb1RHRjdsbThUSTBFaDVtdTlDQVo5ZUFB?=
 =?utf-8?B?MTNDSS9idHRaRE9LanZCRWFzQ1ZyMVNFWjg5blZBUkg5M05va2xBVXNZUFB0?=
 =?utf-8?B?dUoyMkVEOS84cEtaaWxqWWlwQVF0MUNTY3VBQ2NOTTB5elV0VzFkRmNTaEJa?=
 =?utf-8?B?MkgzT2Erb3gwbUhtR0liMWJwbkdYUTRqZkRIa0VYVXVXcW1PNWJtaW1JeW4z?=
 =?utf-8?B?WXpnWlJINmh4S3JKZ2NubEVka3NTbm93a1pIelZ0QXJIdFJWVVlDaVE3NkNz?=
 =?utf-8?B?RXQ4TE90NW5aQ2RBbGQ0MDFLR0ErNEk3WGZRSDdPbUh6MVYwZC9TK2NVNkhL?=
 =?utf-8?B?NFprd2VYWUVGSllXUWhVandUdkEraUs2L0xFNmFFcHp3VlQzejMwbHJUNloz?=
 =?utf-8?B?dTVYZjNGZG4rZUVLSFRTb1FOemlsZGUxUXJKVXYxOG5FZm5BNHREVkFuS0hh?=
 =?utf-8?B?SC9Lb0ZWSFM4dFdoM1VzVXJRMUM5SlhGQk5yaXM1SEgvZmtKcFRaWjVDTXBV?=
 =?utf-8?B?RVBMaCtKZ3FpS1kvb2RTcGlDZnBWc2hSZU9wd1FFUW5BdENHUHloWHovWW4z?=
 =?utf-8?B?UXorRDF2S1pqR0pWbnJReStma25KRHRLVVFBdTMrTXdaSEdLdnptek8xS0Jr?=
 =?utf-8?B?VlRLcy9PUkNnc2NDdURkZ3VuQnN2Wm5UME1CcDBERVI5ZVJwc0NQc2ViWGZ1?=
 =?utf-8?B?WFJIRERWeGlsbFQ5YWZ5d2tJTHBta3h1NGQ3Z3AybmtHQTNxVHk0RldQYTFZ?=
 =?utf-8?B?NTJ3eEYwNXFiVVZ0SkJ3QkdhZXo0aDNrc3pvaXZhNndDeXVQZTFhZk5iaTgw?=
 =?utf-8?B?YlpKemlXSDRBdkh3cVpWMVJTYmt5di9LODErTzFrMWNvWlFCZzN3WDRzVG9j?=
 =?utf-8?B?cDZubXgwbkZnblM5STlKUFo1bitEeW4zRnBtRE5kOC9DTSs4TzJsVUNmWVow?=
 =?utf-8?B?Mm9FUVBaSkwxdWpwMkwrRHhGTmpkY2pnREI0dXVxaXVUUk93dWFQTGlGd3dC?=
 =?utf-8?B?dy83cGxVNXlqWEFuVDJXdHJDeEt0WlZuYzlrdUhFZGtMbjE0eUFqR0RwaWs5?=
 =?utf-8?B?RWNuWEtEeVN3PT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?V3VoUm9iVXQxRnUyT0NocTQvZ3hmcDBEdWtSdjFkMUVnRllHT2JyWi9qN3hw?=
 =?utf-8?B?cTVQeUtMZmZzV0lEd2lzNDA1ZzRnM0xWN3RkaHZDWmNqOWpHQm8xaFZ0Ri9D?=
 =?utf-8?B?Rzh4T092ZUx1cHp0aTlyQTRKcVkzWDZ0QTVnNHRRTTFtYnVBdEdsenhXeGRO?=
 =?utf-8?B?eXowZkliR2lSTno2RmNxOGRjWWo3dGlqZTQzYjBMNGZwTTBFVTc1NHI3WGpE?=
 =?utf-8?B?dWVrNm5DVklHMWs5VU9DRm9SSlRZMHdScFJHd3JNQ1paSjZKTkVYSTFqUkw1?=
 =?utf-8?B?ZXMvSDVZSmJxeUI4NkMrd3Mva1lPZi9WWGFNMDZxclpLSi94UURZczZkQWpp?=
 =?utf-8?B?NitnckRseU9NdER2Wk5aK2JKL0IwVktON1hNSlFQMmJObHErVlhZUEc1WUl3?=
 =?utf-8?B?YWt1TTJKTWN5R1BGYWlvUVRraFlEellIWjhiV2xLK2hrZjlzRGhrWkxDdy85?=
 =?utf-8?B?WTFXNWw0NFdrNms4Q0pycVQ0V3hQcGhHWUJSdVF3SXN1b3E1VWpDTjdydWdu?=
 =?utf-8?B?Z3hNL0pVS2JJOWduelRSelhvTlJYSDZudHp5VlFGakZOd0pPR0NqTkIrUEZE?=
 =?utf-8?B?RXNoblJUMjBuL0d4YlJqak5CRVFaOTZpOXBTVm9QTEhqRUlKQXAzZWhlR21M?=
 =?utf-8?B?Mm9TaDVsOEZNcE5BNmpZWjgwZWlYYVZQT2kzMWpUWk1zemF4MmJ3b3F6MC9h?=
 =?utf-8?B?RVBzVjZsbWFtUE9pc2JXMG5DVk1CR2paZU5CVHV1bE5qTmUrN3RrVEE2QUJ2?=
 =?utf-8?B?Qm1PYkpzOC9RVFZEa1V4c0tKUUdNRnJLdy9HaGNIcEU0cnNHei9aajE2QzJZ?=
 =?utf-8?B?a05OZTdsd0tFSFA4RFBwWnA1VGdtWkQ1T1lteTNTQmFjcFFSa0dHZUg1V21O?=
 =?utf-8?B?aTllZXUzSmhtTzl6TDdqTnpjcC8yMks3RlN5Y051T253ZTdtQVpRdU1aVXo4?=
 =?utf-8?B?ZlhGRXQvYkRwQk1DK3orbHdxZU1TTW9jRHcxTHRVOGNEZWpXSkRuM1g0WHYz?=
 =?utf-8?B?cU5zQU1WS1dEMm0xbHpmWTRWYmVaSTdTajZpcG5zeHBwZ3M2dHlBMFM3THBx?=
 =?utf-8?B?WFBmSHoraXlUQ0NNbk5vOTNzVHgxdjQ0dTVxaTMwUDV3aCtEUXRReEZqa3E0?=
 =?utf-8?B?QlNldVdzRStrT3FhMFZSd1ZaeW1CSVp3T3FNTE5sa2VNazJSaFlmOGtucnBy?=
 =?utf-8?B?bVF0YUhiK0pKaXJWREdXOXp1djNNcFJNdmNNOGYwNWNIaVBqZWpMY29zOVlP?=
 =?utf-8?B?aXlkcWZ3cE5JWEtLRmhMU21kWmVrNE81czk3U0h5bEpqa2pZVVEyQkR3OE5w?=
 =?utf-8?B?YXlneUd1b25CMC9ZSENkT0NTcXBVVW02Uy8xNGxJUWllc3dwVEl0SC9xekY3?=
 =?utf-8?B?dG42d0FjWXdnNFFCa21DS1BWd29oZWZGSUxtMk1aRU4xY1BOcDNnZDdkd1pk?=
 =?utf-8?B?Qjk5Y0k4eWlVUEs5MlR3ZUU4cVkrcksvU1dNOGIwUnd3RUV2dmNUQW5nOTU4?=
 =?utf-8?B?bEFrSUpmMVF2eFNCaTNlaVFCcERpZThOdnRvWERmaElPWHRWeE9sNk03d2JN?=
 =?utf-8?B?OC8wVHUwU2hlTlREenI0QmhxZ3lhZ0hYUHJqNUtRTzY2bjl3SGQ4TkgvUktE?=
 =?utf-8?B?aWR6UFFVcGlYYWM0YmlHbWNKa2U1UDQ0S200L1I4TENlSThXanhva2xyNTZj?=
 =?utf-8?B?M3psZFE2MzZPRkRLekVGd3lIVlVqaFg3TCtDbmN2eGtVYVpiS1hZU3FzeUtj?=
 =?utf-8?B?KzVndmx3alNlSTJlUnREMXA3Qkx0UitsQWpPQUxCNFdwMmJWN1hnUVlPZk8r?=
 =?utf-8?B?Mit4ZWZ3K1hITWZIQ2dyTVc0NUM0UE5FWVFTYW5Eek1TWTZtQVIwSnkrRjZT?=
 =?utf-8?B?Mm8zL0kwenhNNjJQSWgvU1VnU1NXVHo1L1FEcWRHb0ZyOTdIR1EvSlpNdGh1?=
 =?utf-8?B?OHFuRWd0N3ZkYmx3RU1YSlQ1OGJqQU92cnJIMm1FOGRRQ2lFdU1EWkQwMVZv?=
 =?utf-8?B?Q09FKzZRUi9hSStzNzhkajU0S1psR3ZrVzVzNFEvbENlT3BDY1BuVkhoQmEr?=
 =?utf-8?B?am9KRjhGKzFmQUZXZGp1dGllc0xXbVZMU0dDNU9JMjdpa21CeXFHMXdLUzA0?=
 =?utf-8?Q?D0PlhM7cuCpalpJSVt+Y+OQ8o?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <55A3FB4D02C11D45B3AAF9B353877024@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b84ac0a7-cbfb-4a5a-566d-08dddf6b683d
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Aug 2025 21:57:35.9407
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: swPYDc45+Mp3VrGfpwBWdVZVJdxl8Dnc8bqmNovGEjeZh11Va2QoDRKV2mnLa9mOX0MOzu8LUFz+UekMRRDuWA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6748
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI1LTA4LTE5IGF0IDIxOjI4ICswMjAwLCBCb3Jpc2xhdiBQZXRrb3Ygd3JvdGU6
DQo+IE9uIFRodSwgQXVnIDE0LCAyMDI1IGF0IDExOjU5OjAyQU0gKzEyMDAsIEthaSBIdWFuZyB3
cm90ZToNCj4gPiBUTDtEUjoNCj4gPiANCj4gPiBQcmVwYXJlIHRvIHVuaWZ5IGhvdyBURFggYW5k
IFNNRSBkbyBjYWNoZSBmbHVzaGluZyBkdXJpbmcga2V4ZWMgYnkNCj4gPiBtYWtpbmcgYSBwZXJj
cHUgYm9vbGVhbiBjb250cm9sIHdoZXRoZXIgdG8gZG8gdGhlIFdCSU5WRC4NCj4gPiANCj4gPiAt
LSBCYWNrZ3JvdW5kIC0tDQo+ID4gDQo+ID4gT24gU01FIHBsYXRmb3JtcywgZGlydHkgY2FjaGVs
aW5lIGFsaWFzZXMgd2l0aCBhbmQgd2l0aG91dCBlbmNyeXB0aW9uDQo+ID4gYml0IGNhbiBjb2V4
aXN0LCBhbmQgdGhlIENQVSBjYW4gZmx1c2ggdGhlbSBiYWNrIHRvIG1lbW9yeSBpbiByYW5kb20N
Cj4gPiBvcmRlci4gIER1cmluZyBrZXhlYywgdGhlIGNhY2hlcyBtdXN0IGJlIGZsdXNoZWQgYmVm
b3JlIGp1bXBpbmcgdG8gdGhlDQo+ID4gbmV3IGtlcm5lbCBvdGhlcndpc2UgdGhlIGRpcnR5IGNh
Y2hlbGluZXMgY291bGQgc2lsZW50bHkgY29ycnVwdCB0aGUNCj4gPiBtZW1vcnkgdXNlZCBieSB0
aGUgbmV3IGtlcm5lbCBkdWUgdG8gZGlmZmVyZW50IGVuY3J5cHRpb24gcHJvcGVydHkuDQo+ID4g
DQo+ID4gVERYIGFsc28gbmVlZHMgYSBjYWNoZSBmbHVzaCBkdXJpbmcga2V4ZWMgZm9yIHRoZSBz
YW1lIHJlYXNvbi4gIEl0IHdvdWxkDQo+ID4gYmUgZ29vZCB0byBoYXZlIGEgZ2VuZXJpYyB3YXkg
dG8gZmx1c2ggdGhlIGNhY2hlIGluc3RlYWQgb2Ygc2NhdHRlcmluZw0KPiA+IGNoZWNrcyBmb3Ig
ZWFjaCBmZWF0dXJlIGFsbCBhcm91bmQuDQo+ID4gDQo+ID4gV2hlbiBTTUUgaXMgZW5hYmxlZCwg
dGhlIGtlcm5lbCBiYXNpY2FsbHkgZW5jcnlwdHMgYWxsIG1lbW9yeSBpbmNsdWRpbmcNCj4gPiB0
aGUga2VybmVsIGl0c2VsZiBhbmQgYSBzaW1wbGUgbWVtb3J5IHdyaXRlIGZyb20gdGhlIGtlcm5l
bCBjb3VsZCBkaXJ0eQ0KPiA+IGNhY2hlbGluZXMuICBDdXJyZW50bHksIHRoZSBrZXJuZWwgdXNl
cyBXQklOVkQgdG8gZmx1c2ggdGhlIGNhY2hlIGZvcg0KPiA+IFNNRSBkdXJpbmcga2V4ZWMgaW4g
dHdvIHBsYWNlczoNCj4gPiANCj4gPiAxKSB0aGUgb25lIGluIHN0b3BfdGhpc19jcHUoKSBmb3Ig
YWxsIHJlbW90ZSBDUFVzIHdoZW4gdGhlIGtleGVjLWluZyBDUFUNCj4gPiAgICBzdG9wcyB0aGVt
Ow0KPiA+IDIpIHRoZSBvbmUgaW4gdGhlIHJlbG9jYXRlX2tlcm5lbCgpIHdoZXJlIHRoZSBrZXhl
Yy1pbmcgQ1BVIGp1bXBzIHRvIHRoZQ0KPiA+ICAgIG5ldyBrZXJuZWwuDQo+ID4gDQo+ID4gLS0g
U29sdXRpb24gLS0NCj4gPiANCj4gPiBVbmxpa2UgU01FLCBURFggY2FuIG9ubHkgZGlydHkgY2Fj
aGVsaW5lcyB3aGVuIGl0IGlzIHVzZWQgKGkuZS4sIHdoZW4NCj4gPiBTRUFNQ0FMTHMgYXJlIHBl
cmZvcm1lZCkuICBTaW5jZSB0aGVyZSBhcmUgbm8gbW9yZSBTRUFNQ0FMTHMgYWZ0ZXIgdGhlDQo+
ID4gYWZvcmVtZW50aW9uZWQgV0JJTlZEcywgbGV2ZXJhZ2UgdGhpcyBmb3IgVERYLg0KPiA+IA0K
PiA+IFRvIHVuaWZ5IHRoZSBhcHByb2FjaCBmb3IgU01FIGFuZCBURFgsIHVzZSBhIHBlcmNwdSBi
b29sZWFuIHRvIGluZGljYXRlDQo+ID4gdGhlIGNhY2hlIG1heSBiZSBpbiBhbiBpbmNvaGVyZW50
IHN0YXRlIGFuZCBuZWVkcyBmbHVzaGluZyBkdXJpbmcga2V4ZWMsDQo+ID4gYW5kIHNldCB0aGUg
Ym9vbGVhbiBmb3IgU01FLiAgVERYIGNhbiB0aGVuIGxldmVyYWdlIGl0Lg0KPiA+IA0KPiA+IFdo
aWxlIFNNRSBjb3VsZCB1c2UgYSBnbG9iYWwgZmxhZyAoc2luY2UgaXQncyBlbmFibGVkIGF0IGVh
cmx5IGJvb3QgYW5kDQo+ID4gZW5hYmxlZCBvbiBhbGwgQ1BVcyksIHRoZSBwZXJjcHUgZmxhZyBm
aXRzIFREWCBiZXR0ZXI6DQo+ID4gDQo+ID4gVGhlIHBlcmNwdSBmbGFnIGNhbiBiZSBzZXQgd2hl
biBhIENQVSBtYWtlcyBhIFNFQU1DQUxMLCBhbmQgY2xlYXJlZCB3aGVuDQo+ID4gYW5vdGhlciBX
QklOVkQgb24gdGhlIENQVSBvYnZpYXRlcyB0aGUgbmVlZCBmb3IgYSBrZXhlYy10aW1lIFdCSU5W
RC4NCj4gPiBTYXZpbmcga2V4ZWMtdGltZSBXQklOVkQgaXMgdmFsdWFibGUsIGJlY2F1c2UgdGhl
cmUgaXMgYW4gZXhpc3RpbmcNCj4gPiByYWNlWypdIHdoZXJlIGtleGVjIGNvdWxkIHByb2NlZWQg
d2hpbGUgYW5vdGhlciBDUFUgaXMgYWN0aXZlLiAgV0JJTlZEDQo+ID4gY291bGQgbWFrZSB0aGlz
IHJhY2Ugd29yc2UsIHNvIGl0J3Mgd29ydGggc2tpcHBpbmcgaXQgd2hlbiBwb3NzaWJsZS4NCj4g
PiANCj4gPiAtLSBTaWRlIGVmZmVjdCB0byBTTUUgLS0NCj4gPiANCj4gPiBUb2RheSB0aGUgZmly
c3QgV0JJTlZEIGluIHRoZSBzdG9wX3RoaXNfY3B1KCkgaXMgcGVyZm9ybWVkIHdoZW4gU01FIGlz
DQo+ID4gKnN1cHBvcnRlZCogYnkgdGhlIHBsYXRmb3JtLCBhbmQgdGhlIHNlY29uZCBXQklOVkQg
aXMgZG9uZSBpbg0KPiA+IHJlbG9jYXRlX2tlcm5lbCgpIHdoZW4gU01FIGlzICphY3RpdmF0ZWQq
IGJ5IHRoZSBrZXJuZWwuICBNYWtlIHRoaW5ncw0KPiA+IHNpbXBsZSBieSBjaGFuZ2luZyB0byBk
byB0aGUgc2Vjb25kIFdCSU5WRCB3aGVuIHRoZSBwbGF0Zm9ybSBzdXBwb3J0cw0KPiA+IFNNRS4g
IFRoaXMgYWxsb3dzIHRoZSBrZXJuZWwgdG8gc2ltcGx5IHR1cm4gb24gdGhpcyBwZXJjcHUgYm9v
bGVhbiB3aGVuDQo+ID4gYnJpbmdpbmcgdXAgYSBDUFUgYnkgY2hlY2tpbmcgd2hldGhlciB0aGUg
cGxhdGZvcm0gc3VwcG9ydHMgU01FLg0KPiA+IA0KPiA+IE5vIG90aGVyIGZ1bmN0aW9uYWwgY2hh
bmdlIGludGVuZGVkLg0KPiA+IA0KPiA+IFsqXSBUaGUgYWZvcmVtZW50aW9uZWQgcmFjZToNCj4g
PiANCj4gPiBEdXJpbmcga2V4ZWMgbmF0aXZlX3N0b3Bfb3RoZXJfY3B1cygpIGlzIGNhbGxlZCB0
byBzdG9wIGFsbCByZW1vdGUgQ1BVcw0KPiA+IGJlZm9yZSBqdW1waW5nIHRvIHRoZSBuZXcga2Vy
bmVsLiAgbmF0aXZlX3N0b3Bfb3RoZXJfY3B1cygpIGZpcnN0bHkNCj4gPiBzZW5kcyBub3JtYWwg
UkVCT09UIHZlY3RvciBJUElzIHRvIHN0b3AgcmVtb3RlIENQVXMgYW5kIHdhaXRzIHRoZW0gdG8N
Cj4gPiBzdG9wLiAgSWYgdGhhdCB0aW1lcyBvdXQsIGl0IHNlbmRzIE5NSSB0byBzdG9wIHRoZSBD
UFVzIHRoYXQgYXJlIHN0aWxsDQo+ID4gYWxpdmUuICBUaGUgcmFjZSBoYXBwZW5zIHdoZW4gbmF0
aXZlX3N0b3Bfb3RoZXJfY3B1cygpIGhhcyB0byBzZW5kIE5NSXMNCj4gPiBhbmQgY291bGQgcG90
ZW50aWFsbHkgcmVzdWx0IGluIHRoZSBzeXN0ZW0gaGFuZyAoZm9yIG1vcmUgaW5mb3JtYXRpb24N
Cj4gPiBwbGVhc2Ugc2VlIFsxXSkuDQo+IA0KPiBUaGlzIHRleHQgaXMgbWVhbmRlcmluZyBhIGJp
dCB0b28gbXVjaCBhY3Jvc3MgYSBidW5jaCBvZiB0aGluZ3MgYW5kIGNvdWxkIGJlDQo+IG1hZGUg
dGlnaHRlci4uLiBKdXN0IGEgbml0cGljayBhbnl3YXkuLi4NCg0KWWVhaCBhZ3JlZWQuICBJJ3Zl
IHdvcmtlZCB0byBpbXByb3ZlIGl0IGJ1dCAuLi4gOi0pDQoNCkknbGwga2VlcCB0aGlzIGluIG1p
bmQgYW5kIGRvIGJldHRlciBpbiB0aGUgZnV0dXJlIQ0KDQo+IA0KPiA+ICBhcmNoL3g4Ni9pbmNs
dWRlL2FzbS9rZXhlYy5oICAgICAgICAgfCAgNCArKy0tDQo+ID4gIGFyY2gveDg2L2luY2x1ZGUv
YXNtL3Byb2Nlc3Nvci5oICAgICB8ICAyICsrDQo+ID4gIGFyY2gveDg2L2tlcm5lbC9jcHUvYW1k
LmMgICAgICAgICAgICB8IDE3ICsrKysrKysrKysrKysrKysrDQo+ID4gIGFyY2gveDg2L2tlcm5l
bC9tYWNoaW5lX2tleGVjXzY0LmMgICB8IDE0ICsrKysrKysrKystLS0tDQo+ID4gIGFyY2gveDg2
L2tlcm5lbC9wcm9jZXNzLmMgICAgICAgICAgICB8IDI0ICsrKysrKysrKysrLS0tLS0tLS0tLS0t
LQ0KPiA+ICBhcmNoL3g4Ni9rZXJuZWwvcmVsb2NhdGVfa2VybmVsXzY0LlMgfCAxMyArKysrKysr
KysrLS0tDQo+ID4gIDYgZmlsZXMgY2hhbmdlZCwgNTIgaW5zZXJ0aW9ucygrKSwgMjIgZGVsZXRp
b25zKC0pDQo+IA0KPiBSZXZpZXdlZC1ieTogQm9yaXNsYXYgUGV0a292IChBTUQpIDxicEBhbGll
bjguZGU+DQoNClRoYW5rcyENCg==

