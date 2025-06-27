Return-Path: <kvm+bounces-50923-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E73AAEAB94
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 02:09:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AF11E4E47C0
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 00:09:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15E733FC2;
	Fri, 27 Jun 2025 00:02:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OhiWWkP7"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 502AEF510;
	Fri, 27 Jun 2025 00:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750982529; cv=fail; b=KnhPFeMmhC0RIgPZJKkOYuSgMBIDTdN1VV8INvhuR0Z/Aj/JYZYezWHfBt6dtbSZbR+sCkW3yTSG5BDlFXgTPasVu+DbXQHQJLtCLfZytislWaM3SM2pwfwC7/EHwl9NBps+tziKSKwu3dHPe6+80Ithx/LHOHeKnMiIN1jeo3A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750982529; c=relaxed/simple;
	bh=40j4X4fGd81YIVGClhTsV7VWplRntP6LoZ/uYfjgFWY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=jetNnZYcpkqkg0ynxOZ5PUcOE1d1XVY20eHpl5eRIUGgPcQ8GQHIk4TFZ6zfH1Yw36KtbZ9el2MPDwcH/94igwHLM64Ral3SwrwcTN8LTjKe2fbOTq6QIxd3pdeflqzMVeZk+KpRLORAMwbi8rtvHQj6aAuTTRk/SVBYcdp1Apg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OhiWWkP7; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750982527; x=1782518527;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=40j4X4fGd81YIVGClhTsV7VWplRntP6LoZ/uYfjgFWY=;
  b=OhiWWkP744YZjbYbMwxNa/O61eyTR8JyZivibiL0MKX296PdmWQtRTaK
   5h0ZpGHrTEFG5+0qzOPE/lpjZV109sdgUGb331oSYnWvFr9fQWDxVwVkS
   9D12lteO1bKqOHqXYeogxjPz2Bqpa083r/GYV5qix3Uw2czoZSPEchHZs
   FiMbG6PAqClZ45tSGl1JJRLRFKxQ27H+GvILEPnldcaZR7uH9Pkm5+2Zs
   fcgaEDHeNIL2to6c4EYQJcE6fYQHESLhcjuZRZkGIFC/FGNx54CBPZOKQ
   M3G5GXy310GSSdZSJwknTgbuk2yECqzDVqSeqbCxMZrIr1bX8dU7c08Kd
   w==;
X-CSE-ConnectionGUID: ZeFv9pKJQh6NoQ6a4OxCBg==
X-CSE-MsgGUID: g9ouaTEBQw6s6+6mGIOMBA==
X-IronPort-AV: E=McAfee;i="6800,10657,11476"; a="53020003"
X-IronPort-AV: E=Sophos;i="6.16,268,1744095600"; 
   d="scan'208";a="53020003"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2025 17:02:06 -0700
X-CSE-ConnectionGUID: 5qx/qjiiSaWFbZnrlC2xfw==
X-CSE-MsgGUID: WTe4UfdwQAm9XncZwUYJNg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,268,1744095600"; 
   d="scan'208";a="152275305"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2025 17:02:03 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 26 Jun 2025 17:02:03 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Thu, 26 Jun 2025 17:02:03 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (40.107.243.69)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 26 Jun 2025 17:02:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=seaU/LNyR4WrPzANgO0pdI7JNl9XId7RC5xmT+6kUjqmTlkAFA6Zv3M7mOjoNvY3HjgrcdF+y24RjDtTVcsTnYojtWpjafgh8eIODQht9g7fKeGJeFH2kyVARoKx13ZcBVXJq811jzxKjpRF27L1a259LM5JFJ6Ej4GlTngO7k0G2F2OmKqSAnp0gdR3Qa88lMpSkX6g8VnCE1Zt5ronU1628eoI7mmqOCD8BJsqGrVDiJObueRi9UtI/iVfJnOlzgK2UcyOugznZXbT5Xi7hLNX0z5XByUOECrhK4eKd/WQaTBT8GY1Bb9PFUomCPkG2bvyFmh3MIZttgsBazSWMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=40j4X4fGd81YIVGClhTsV7VWplRntP6LoZ/uYfjgFWY=;
 b=P7a2IGeOr4C5oQ1e4iunCHvBCZ+6r2hajq3RTcUiEmuNutiT2Vg589HMY2Rqc3Oa+MZVz00E5KX09VrHBULiM94t2c1eoNrRpqkc3pi3UB9X6uQJZO18GZlMbed8uKKO+/zT+nH6UFQqc7xA/db6TRx3CkvDvVzrfgPA2QqRDr8GZ0Eq5X4otKHMco7HQQ+ZPnZju+/VP82pmcQqeuKBj7KTExLlCgaZ8c+lhxghzQKGbAyh2CWYC6KJUoqTMGyhK23NuegZY472vr8dCOQ0ScYOFKARxM52WBp6hJISLt1DWuXzILSmFuB+97cOvZYTy9VxnDtw8cihN9eZTyt9Zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DS0PR11MB7580.namprd11.prod.outlook.com (2603:10b6:8:148::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.26; Fri, 27 Jun
 2025 00:01:52 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.8857.025; Fri, 27 Jun 2025
 00:01:52 +0000
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
Subject: Re: [PATCH v3 6/6] KVM: TDX: Explicitly do WBINVD upon reboot
 notifier
Thread-Topic: [PATCH v3 6/6] KVM: TDX: Explicitly do WBINVD upon reboot
 notifier
Thread-Index: AQHb5ogTGGCCoP9FGkGUzCNCos4MxLQWIE2A
Date: Fri, 27 Jun 2025 00:01:52 +0000
Message-ID: <f8ed9f899681e0aa9cc443c8c90a3a303655d0b8.camel@intel.com>
References: <cover.1750934177.git.kai.huang@intel.com>
	 <6cc612331718a8bdaae9ee7071b6a360d71f2ab8.1750934177.git.kai.huang@intel.com>
In-Reply-To: <6cc612331718a8bdaae9ee7071b6a360d71f2ab8.1750934177.git.kai.huang@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DS0PR11MB7580:EE_
x-ms-office365-filtering-correlation-id: f6affd0b-956d-4a6a-0d76-08ddb50dd27e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|7416014|1800799024|38070700018|921020;
x-microsoft-antispam-message-info: =?utf-8?B?TFRxdDVjQ0VhVjg4dmhubWszeFpMSkJwMmRUeTQ2SENINFFxa3c5NS9ZMkFa?=
 =?utf-8?B?NFUxdjBGamlzK3U3dmlFTVVYNzZjcGVPckVxYWxMQjVSK1F3MW1wQXhzMFZP?=
 =?utf-8?B?Wnd2eW41YUEvQ3hwVWlydlR1aVF5ZnI3ZHBISTJ5cjRnZC9jZ1BDcU1KTS9l?=
 =?utf-8?B?L1ZvbHE0MEtHMmNqZ2RlVXpLYXdNaW5EZ05mdFJJWlpieitrTURncEt5eEJn?=
 =?utf-8?B?SWxNcG5zUTRwQWVSbG5IOGUxY1pQMWJLTFFhVlpXcTNpUkNxcEZ2aVZtUHRo?=
 =?utf-8?B?c2tWcWJ5N3Ayc3NUSElwREo0Z3F0c2ZmS2VXbGxSeTc1eUxEZWF6MVltc3Ba?=
 =?utf-8?B?UWtDR0Zsbm4wUmJzb1VvdVNLbE5sMkdKbVhPTDNlZTlZRFBOZnZIN3ltdVpr?=
 =?utf-8?B?clRuaU00NmdCcDhQd0NjcFc4S3FLSTlpYWpoT0ZTSXl4REtCSjBNcnBsM2Qr?=
 =?utf-8?B?dHBFeHVvenF4MlMzUTJQZnpibHM2SGJ4L2EzczVacVh6QTJXaXJOUHpvQk5j?=
 =?utf-8?B?Y2xibW5saXF6endWNHZseTBlODkwVWxQSFgxbzhMY2VkQkh6T25taTZia0x5?=
 =?utf-8?B?VCs1YkdKalJJK2xDWXhmYXkrZlA2UVlKUmNDeWR5Zy9ydVJnOWRrcHVJRHdE?=
 =?utf-8?B?WWgvVDlPSDNFRU0zWkVjTFVjTU05aW04bEU1TzJkZFUvMUNJNGZpeUlCSnRk?=
 =?utf-8?B?d2tid2FYbDV3K2VoSGNVZUx4eWdPeVlWVzJxZkcwakF1Mis1ODlmL2RsS0VC?=
 =?utf-8?B?bGhXMjMrNS9XU0RCUTdnazhWaVRVbUMzejVtZWJlS05OUFNmby9sVkxnMGN6?=
 =?utf-8?B?V3E1eWxSK2NDeFJ0YU1HbTBVSTlKbGJyZHdaTnFqN2hxSnE1WE1OT2tpRkFk?=
 =?utf-8?B?ZXd3S1hnaHRvTW9FWEFnRTBTUnNLY3lNRU9VYUNNUDkwdWkwV0JROEkzSjFJ?=
 =?utf-8?B?MFg5cloyQlE2clZTSlNMdnA1ai9qRzF5MW9MVnRkTEhFR1VPK0IrSVhONUhZ?=
 =?utf-8?B?V0lsVTFqZHRlNzRNUWdXYmUyb1JTaHNVeHNYMTVwb1RaY09OeGlGMVNucGpo?=
 =?utf-8?B?RWNtbFpJYmMyR2lGSDRRZDk0WEx1MXhBODF5bHJUdGY5b2EvMmY3am52OGZB?=
 =?utf-8?B?QlpPUWdnUDRmcWNBTUtRc20xR3RxdFhFak1ORVNIL254c0MvYzFXVWlBbnVs?=
 =?utf-8?B?N3duSWV5Q2d2enBzbXFsSmhaaDhjN09UVmtXWitSOW16RmFodHpPcW1xb2cx?=
 =?utf-8?B?TVcwNVZXT3JvdFR1ZXJwTWVzTkhibG11L1BPczRvQ1RRUTRUaDRCemxqRXBE?=
 =?utf-8?B?N1BXTXBCRSswY1hmMHJNSWVMUG1QRjZQMkxnTWFzU3JCeDNONHkwWUR4VHZp?=
 =?utf-8?B?Q0N2d3dkVUJlQlVRSTF2dUFjWk4yNVJTWkczYkJod2JZS2UxNjJFNGxqNmRV?=
 =?utf-8?B?NldJSVhyWmM4aVFvTlRrSjlkZzBqTDJrM2pmTURNNktmaVJUUXNGbW91MHly?=
 =?utf-8?B?S09GV3ZzTHB3cWtyYkpNUGVENWtJT1U3Qk1oUE9kSmsvOUkrWE9mNnpsdU9N?=
 =?utf-8?B?bjBHUi9mbXhtZ0wxNEhQRkF6Q3EzT0hZQ3ZOajBveGpBN1FDL05uWndlYzRK?=
 =?utf-8?B?TXR1c0FKYlhDSkN0MVl6eFlaWlRlcjNSZEU3ZDhRM3pxM1FLNHBJWkhjODA1?=
 =?utf-8?B?QkFtZVFJNWFsT1FzQm9JMkRnUnhNWk56bE5Hc2lqSHNMNDdoRmFvNmhlQncr?=
 =?utf-8?B?VFljV3pFRS8zTXBET3FHbU5LQ0hyM1VGQjAzYWFERTFicklHTDNrUDc1TEUw?=
 =?utf-8?B?anRyMWN0c0IyUlNmYUt3bUIwOVQrSTlJa1k2alFjaDNBUCtGSzNONHh0LzVz?=
 =?utf-8?B?aWdkVFhlL3RvMi83dFhTbDQ2bnI4S1pBaGFlamhTMlVuV1JVZ3VvZEdVTmVJ?=
 =?utf-8?B?dlZTL0pmWElVYmVYWkpMOWg1QmxqcUtKZ0hRVzF2cWU1MXNFUTZjUlhaRXZv?=
 =?utf-8?B?OTFsdVpJVVlPNi9QT0tOUFA5Q1FTSW92cHZzU1BTcTJUVzhRVEtQcG9pV2Uy?=
 =?utf-8?Q?3rO/UD?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(7416014)(1800799024)(38070700018)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dVEyMWFLVTh4TE1GNkw3ZGtFVGdnMFF1c2cyVG5uUFhQZkMwcHFCRWNlUlds?=
 =?utf-8?B?TDd3a0RORWhhRE9od1RzWldvbGxLR1k4UkhqeHVTV2RnKzhBQVNrbks2d1kv?=
 =?utf-8?B?ZEQwQ1ozbWNXeGNESmhvWm05NUpwK3VzOGZJVnRvbkh0elJ0QUpsSUlFSGN4?=
 =?utf-8?B?c0U4d0VsMGM3a2EvMXpJUWNpMFFEcnp1MEFXQk1NS3N5QVorWTlXSytPYnV5?=
 =?utf-8?B?K2Z1TElNNkpJS2M5YTNoZ0FXVWdiYjNaa0c0bjFMZk9pRjVxMFR3UzRreWsz?=
 =?utf-8?B?SysvQWpFVDBHMXY4SGdtcUk1NE9UZ05ienNla0RGaFdLUzNOaDhJdXk3UW5K?=
 =?utf-8?B?UXk5QmdVYWpZMmhIcEhseGFEQ0hvMUNleWV6cmlKbWpjMHQycWxKOE5RM0R0?=
 =?utf-8?B?U0x0NmdwVFF4U3Z4SUgwbnIzSkh6TmgrbjlXdHMzZnhrUUZOdU1iUHZQbFdk?=
 =?utf-8?B?MXErNmJQRkl2c1FGUUdpdDYrcUFDWk1jeTZ4d0Vsd0xveWY0c2xxTUtvWU5J?=
 =?utf-8?B?cUJUQ2VoODRHNWFpa0oyc3F4WTIvd2hHQVlGc281VnhQUTJRL3pvSWpJdFQ5?=
 =?utf-8?B?NWJCU1dSRGVJQVZ6MFl3UDh2dnpFQ3JIN0oya28vSjM5Vy9NZ1BFcS9tS3c5?=
 =?utf-8?B?L1E0cGNITzN1eDlRczd1Q1Znd2pJVE85d0Fpa0lubG05a1d1MnBEY2J6VGtY?=
 =?utf-8?B?TS9XMW91SUZwRUdpcm1ESWFKOEhpMkFxdVo5TUE1ZEllcEFNL1UwWGJWNHla?=
 =?utf-8?B?TlAxdDM1dUt1U2xzL1kyeTIwQ0R4OXlCQitrbytJRXpzT2U5d1JybG1rS0s5?=
 =?utf-8?B?cXplVzRkTlVWSllUL3B1UitFejhKYmlnVjhDSkxxY09pc0czenYxZm5jYzBP?=
 =?utf-8?B?ZUdxZzBKN1lBRS90RkY5b1VlaVpJNUxTbEJMY0plQk5VM2NJenR2S0t0cGIy?=
 =?utf-8?B?cjV4MC83cDE3V3N1MHY0T1lzbTIwZ0duTmRKd3FsdXMyTVRvMmlTdVRmWlV6?=
 =?utf-8?B?ODJtcWtCNTVwNUNvSTJHQnpGMVNjRlczV05VQjBITEdwQWtpYnFGU0VSckxR?=
 =?utf-8?B?aDlmUmsvZndvak51a3ZiYm8zWFc1VkhGaXlWNCtPdVdKVk5HY2o2Si9wU2kr?=
 =?utf-8?B?Q3R2Zjk5MGIxUFBOQTFycmg5TkY5R0RmUng5K05XMkhEWmFBVHhFdHVPaTRi?=
 =?utf-8?B?TG1LRFpPUjR0UmxDdmkyQjdMY0JHUTFGMlN4WXFNdVJhQUJvMk5uSDFscFFr?=
 =?utf-8?B?Z3BQeEZJS0lGVWd3Wmd2NFFTbU1JUGIwOGtTQ01UY00rUlpZMzZlZDlPRTdT?=
 =?utf-8?B?Z21GUFhreVNWTnRndlM0QTdJT3Rxc0g2ZStlSktOV1ZTeHNhbmltcjJ6K0xm?=
 =?utf-8?B?c1JrZmNKbHJ4UGZRQXJoNEFCTFFKL3l5aUdpb2Z4c0g5Z2xNRHlsQklhNStz?=
 =?utf-8?B?cXVuWHNMUWliaUdUazFNVi9QRzl6RmxuMWhEMzZHT3J5YTVUUnVPMjhyL2lQ?=
 =?utf-8?B?NFlLM2w2UzhDeVQ3RFBsOU1WdE53emVlWTZDMGJpVHB1VUExVU5uZDFXM0kz?=
 =?utf-8?B?RWRJSkNubW55RXNIT3JPV2ZTUk5pMUNxRXNnaXRwR0lhOEJyamRwa3JWVC9R?=
 =?utf-8?B?cFROam9IZEFsdlF6czJBSHFWRnBaRVcrUUlUTGNYQzl1TElZbFNYZERPdUt4?=
 =?utf-8?B?TWFPRTkrdUFWZ1hmUUtQemxPQ0VSbEdaMk1YUHR6ZUFkYXBiK09Rc045TXpU?=
 =?utf-8?B?dlIwVVEyQ2dPa0NZTXJWRTVKeDNQdHhDZnlOUk5QcE5qLzZPMWw0WDNqZUxP?=
 =?utf-8?B?ZERWcUN6K0REQ05SZ05nSWQ3c3hHQkdRYThwUGFCdStWMkpRUmdlYnRvcFNM?=
 =?utf-8?B?OWVDZ3FmN0xjKzkxUzBxem93cXJaMklsNVNhNGI2ajNzeUxUaUQ5NTUxcDE0?=
 =?utf-8?B?akZKSjhmNis4NXFOVjhsVjBhSk84Mk5GeU5EaWt6R0MyVmttTDZ0SzV2SW1I?=
 =?utf-8?B?Y2pKOTVwclhoc0VzSjdqSHd4NkNDOWdFcjdKcWtUTG5RUnpEbExDanhTQ1BI?=
 =?utf-8?B?ZVBqV3N5Z2pOeWNrNC9keXZIS0JLTENkdTVZM2tZc1JqeldGNUNFZGZjZWRH?=
 =?utf-8?B?L0dCN1BlQjh4Q294UExvaWxMUXdKNTdObjdLY1BuUElaWUdmU1BKcEllZlQ4?=
 =?utf-8?B?N2c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3084BE056871CF41AC12D81692FEB6A8@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f6affd0b-956d-4a6a-0d76-08ddb50dd27e
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jun 2025 00:01:52.6834
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6r8y69iQUhmy0OBSaW20AghQKYFAsUPCl1Qroe15IakMpr5msG48TfeJrV1MbEgkcdtRg9EdODDdOqCPIR99K+iKu3OkQHOHYV1c5aIZFEw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7580
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTA2LTI2IGF0IDIyOjQ4ICsxMjAwLCBLYWkgSHVhbmcgd3JvdGU6DQo+IE9u
IFREWCBwbGF0Zm9ybXMsIGR1cmluZyBrZXhlYywgdGhlIGtlcm5lbCBuZWVkcyB0byBtYWtlIHN1
cmUgdGhlcmUncyBubw0KPiBkaXJ0eSBjYWNoZWxpbmVzIG9mIFREWCBwcml2YXRlIG1lbW9yeSBi
ZWZvcmUgYm9vdGluZyB0byB0aGUgbmV3IGtlcm5lbA0KPiB0byBhdm9pZCBzaWxlbnQgbWVtb3J5
IGNvcnJ1cHRpb24gdG8gdGhlIG5ldyBrZXJuZWwuDQo+IA0KPiBEdXJpbmcga2V4ZWMsIHRoZSBr
ZXhlYy1pbmcgQ1BVIGZpcnN0bHkgaW52b2tlcyBuYXRpdmVfc3RvcF9vdGhlcl9jcHVzKCkNCj4g
dG8gc3RvcCBhbGwgcmVtb3RlIENQVXMgYmVmb3JlIGJvb3RpbmcgdG8gdGhlIG5ldyBrZXJuZWwu
ICBUaGUgcmVtb3RlDQo+IENQVXMgd2lsbCB0aGVuIGV4ZWN1dGUgc3RvcF90aGlzX2NwdSgpIHRv
IHN0b3AgdGhlbXNlbHZlcy4NCj4gDQo+IFRoZSBrZXJuZWwgaGFzIGEgcGVyY3B1IGJvb2xlYW4g
dG8gaW5kaWNhdGUgd2hldGhlciB0aGUgY2FjaGUgb2YgYSBDUFUNCj4gbWF5IGJlIGluIGluY29o
ZXJlbnQgc3RhdGUuICBJbiBzdG9wX3RoaXNfY3B1KCksIHRoZSBrZXJuZWwgZG9lcyBXQklOVkQN
Cj4gaWYgdGhhdCBwZXJjcHUgYm9vbGVhbiBpcyB0cnVlLg0KPiANCj4gVERYIHR1cm5zIG9uIHRo
YXQgcGVyY3B1IGJvb2xlYW4gb24gYSBDUFUgd2hlbiB0aGUga2VybmVsIGRvZXMgU0VBTUNBTEwu
DQo+IFRoaXMgbWFrZXMgc3VyZSB0aGUgY2FjaGVzIHdpbGwgYmUgZmx1c2hlZCBkdXJpbmcga2V4
ZWMuDQo+IA0KPiBIb3dldmVyLCB0aGUgbmF0aXZlX3N0b3Bfb3RoZXJfY3B1cygpIGFuZCBzdG9w
X3RoaXNfY3B1KCkgaGF2ZSBhICJyYWNlIg0KPiB3aGljaCBpcyBleHRyZW1lbHkgcmFyZSB0byBo
YXBwZW4gYnV0IGNvdWxkIGNhdXNlIHN5c3RlbSB0byBoYW5nLg0KPiANCj4gU3BlY2lmaWNhbGx5
LCB0aGUgbmF0aXZlX3N0b3Bfb3RoZXJfY3B1cygpIGZpcnN0bHkgc2VuZHMgbm9ybWFsIHJlYm9v
dA0KPiBJUEkgdG8gcmVtb3RlIENQVXMgYW5kIHdhaXQgb25lIHNlY29uZCBmb3IgdGhlbSB0byBz
dG9wLiAgSWYgdGhhdCB0aW1lcw0KPiBvdXQsIG5hdGl2ZV9zdG9wX290aGVyX2NwdXMoKSB0aGVu
IHNlbmRzIE5NSXMgdG8gcmVtb3RlIENQVXMgdG8gc3RvcA0KPiB0aGVtLg0KPiANCj4gVGhlIGFm
b3JlbWVudGlvbmVkIHJhY2UgaGFwcGVucyB3aGVuIE5NSXMgYXJlIHNlbnQuICBEb2luZyBXQklO
VkQgaW4NCj4gc3RvcF90aGlzX2NwdSgpIG1ha2VzIGVhY2ggQ1BVIHRha2UgbG9uZ2VyIHRpbWUg
dG8gc3RvcCBhbmQgaW5jcmVhc2VzDQo+IHRoZSBjaGFuY2Ugb2YgdGhlIHJhY2UgdG8gaGFwcGVu
Lg0KPiANCj4gUmVnaXN0ZXIgcmVib290IG5vdGlmaWVyIGluIEtWTSB0byBleHBsaWNpdGx5IGZs
dXNoIGNhY2hlcyB1cG9uDQo+IHJlY2VpdmluZyByZWJvb3Qgbm90aWZpZXIgKGUuZy4sIGR1cmlu
ZyBrZXhlYykgZm9yIFREWC4gIFRoaXMgbW92ZXMgdGhlDQo+IFdCSU5WRCB0byBhbiBlYXJsaWVy
IHN0YWdlIHRoYW4gc3RvcF90aGlzX2NwdXMoKSwgYXZvaWRpbmcgYSBwb3NzaWJseQ0KPiBsZW5n
dGh5IG9wZXJhdGlvbiBhdCBhIHRpbWUgd2hlcmUgaXQgY291bGQgY2F1c2UgdGhpcyByYWNlLg0K
PiANCg0KSSB0aGluayB0aGlzIHdpbGwgcmVkdWNlIHRoZSBjaGFuY2Ugb2YgdGhlIHJhY2UsIGJ1
dCBpdCBmZWVscyBsaWtlIHRoZSB3cm9uZyB3YXkNCnRvIGFkZHJlc3MgdGhlIHJhY2UuIEJ1dCBJ
IGRvbid0IGtub3cgaG93IHRvIHByb3Blcmx5IGZpeCBpdCBlaXRoZXIuIE1heWJlIHRoaXMNCmlz
IGp1c3QgdGhlIG5hdHVyZSBvZiB4ODYgTk1JcywgdG8gaGF2ZSBjb2RlIGxpa2UgdGhpcy4NCg0K
RnVuY3Rpb25hbGx5IGl0IGxvb2tzIGdvb2QsIGJ1dCBhIGZldyBuaXRzIHRvIHRha2Ugb3IgbGVh
dmUgYmVsb3cuDQoNCj4gU2lnbmVkLW9mZi1ieTogS2FpIEh1YW5nIDxrYWkuaHVhbmdAaW50ZWwu
Y29tPg0KPiBBY2tlZC1ieTogUGFvbG8gQm9uemluaSA8cGJvbnppbmlAcmVkaGF0LmNvbT4NCj4g
VGVzdGVkLWJ5OiBGYXJyYWggQ2hlbiA8ZmFycmFoLmNoZW5AaW50ZWwuY29tPg0KPiAtLS0NCj4g
DQo+IHYyIC0+IHYzOg0KPiAgLSBVcGRhdGUgY2hhbmdlbG9nIHRvIGFkZHJlc3MgUGFvbG8ncyBj
b21tZW50cyBhbmQgQWRkIFBhb2xvJ3MgQWNrOg0KPiAgICBodHRwczovL2xvcmUua2VybmVsLm9y
Zy9sa21sLzNhN2MwODU2LTZlN2ItNGQzZC1iOTY2LTZmMTdmMWFjYTQyZUByZWRoYXQuY29tLw0K
PiANCj4gLS0tDQo+ICBhcmNoL3g4Ni9pbmNsdWRlL2FzbS90ZHguaCAgfCAgMyArKysNCj4gIGFy
Y2gveDg2L2t2bS92bXgvdGR4LmMgICAgICB8IDQ1ICsrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysNCj4gIGFyY2gveDg2L3ZpcnQvdm14L3RkeC90ZHguYyB8ICA5ICsrKysrKysr
DQo+ICAzIGZpbGVzIGNoYW5nZWQsIDU3IGluc2VydGlvbnMoKykNCj4gDQo+IGRpZmYgLS1naXQg
YS9hcmNoL3g4Ni9pbmNsdWRlL2FzbS90ZHguaCBiL2FyY2gveDg2L2luY2x1ZGUvYXNtL3RkeC5o
DQo+IGluZGV4IGQ0YzYyNGM2OWQ3Zi4uZTZiMTE5ODJjNmM2IDEwMDY0NA0KPiAtLS0gYS9hcmNo
L3g4Ni9pbmNsdWRlL2FzbS90ZHguaA0KPiArKysgYi9hcmNoL3g4Ni9pbmNsdWRlL2FzbS90ZHgu
aA0KPiBAQCAtMjIxLDYgKzIyMSw4IEBAIHU2NCB0ZGhfbWVtX3BhZ2VfcmVtb3ZlKHN0cnVjdCB0
ZHhfdGQgKnRkLCB1NjQgZ3BhLCB1NjQgbGV2ZWwsIHU2NCAqZXh0X2VycjEsIHU2DQo+ICB1NjQg
dGRoX3BoeW1lbV9jYWNoZV93Yihib29sIHJlc3VtZSk7DQo+ICB1NjQgdGRoX3BoeW1lbV9wYWdl
X3diaW52ZF90ZHIoc3RydWN0IHRkeF90ZCAqdGQpOw0KPiAgdTY0IHRkaF9waHltZW1fcGFnZV93
YmludmRfaGtpZCh1NjQgaGtpZCwgc3RydWN0IHBhZ2UgKnBhZ2UpOw0KPiArDQoNCk5pdDogVGhl
cmUgaXMgYSBuZXcgbGluZSBoZXJlLCBidXQgbm90IGJlbG93LiBJIGd1ZXNzIGl0J3Mgb2suDQoN
Cj4gK3ZvaWQgdGR4X2NwdV9mbHVzaF9jYWNoZSh2b2lkKTsNCj4gICNlbHNlDQo+ICBzdGF0aWMg
aW5saW5lIHZvaWQgdGR4X2luaXQodm9pZCkgeyB9DQo+ICBzdGF0aWMgaW5saW5lIGludCB0ZHhf
Y3B1X2VuYWJsZSh2b2lkKSB7IHJldHVybiAtRU5PREVWOyB9DQo+IEBAIC0yMjgsNiArMjMwLDcg
QEAgc3RhdGljIGlubGluZSBpbnQgdGR4X2VuYWJsZSh2b2lkKSAgeyByZXR1cm4gLUVOT0RFVjsg
fQ0KPiAgc3RhdGljIGlubGluZSB1MzIgdGR4X2dldF9ucl9ndWVzdF9rZXlpZHModm9pZCkgeyBy
ZXR1cm4gMDsgfQ0KPiAgc3RhdGljIGlubGluZSBjb25zdCBjaGFyICp0ZHhfZHVtcF9tY2VfaW5m
byhzdHJ1Y3QgbWNlICptKSB7IHJldHVybiBOVUxMOyB9DQo+ICBzdGF0aWMgaW5saW5lIGNvbnN0
IHN0cnVjdCB0ZHhfc3lzX2luZm8gKnRkeF9nZXRfc3lzaW5mbyh2b2lkKSB7IHJldHVybiBOVUxM
OyB9DQo+ICtzdGF0aWMgaW5saW5lIHZvaWQgdGR4X2NwdV9mbHVzaF9jYWNoZSh2b2lkKSB7IH0N
Cj4gICNlbmRpZgkvKiBDT05GSUdfSU5URUxfVERYX0hPU1QgKi8NCj4gIA0KPiAgI2VuZGlmIC8q
ICFfX0FTU0VNQkxFUl9fICovDQo+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rdm0vdm14L3RkeC5j
IGIvYXJjaC94ODYva3ZtL3ZteC90ZHguYw0KPiBpbmRleCAxYWQyMGMyNzNmM2IuLmM1NjdhNjRh
NmNiMCAxMDA2NDQNCj4gLS0tIGEvYXJjaC94ODYva3ZtL3ZteC90ZHguYw0KPiArKysgYi9hcmNo
L3g4Ni9rdm0vdm14L3RkeC5jDQo+IEBAIC01LDcgKzUsOSBAQA0KPiAgI2luY2x1ZGUgPGFzbS9m
cHUveGNyLmg+DQo+ICAjaW5jbHVkZSA8bGludXgvbWlzY19jZ3JvdXAuaD4NCj4gICNpbmNsdWRl
IDxsaW51eC9tbXVfY29udGV4dC5oPg0KPiArI2luY2x1ZGUgPGxpbnV4L3JlYm9vdC5oPg0KPiAg
I2luY2x1ZGUgPGFzbS90ZHguaD4NCj4gKyNpbmNsdWRlIDxhc20vcHJvY2Vzc29yLmg+DQo+ICAj
aW5jbHVkZSAiY2FwYWJpbGl0aWVzLmgiDQo+ICAjaW5jbHVkZSAibW11LmgiDQo+ICAjaW5jbHVk
ZSAieDg2X29wcy5oIg0KPiBAQCAtMzM0Nyw2ICszMzQ5LDMzIEBAIHN0YXRpYyBpbnQgdGR4X29m
ZmxpbmVfY3B1KHVuc2lnbmVkIGludCBjcHUpDQo+ICAJcmV0dXJuIC1FQlVTWTsNCj4gIH0NCj4g
IA0KPiArc3RhdGljIHZvaWQgc21wX2Z1bmNfY3B1X2ZsdXNoX2NhY2hlKHZvaWQgKnVudXNlZCkN
Cj4gK3sNCj4gKwl0ZHhfY3B1X2ZsdXNoX2NhY2hlKCk7DQo+ICt9DQo+ICsNCj4gK3N0YXRpYyBp
bnQgdGR4X3JlYm9vdF9ub3RpZnkoc3RydWN0IG5vdGlmaWVyX2Jsb2NrICpuYiwgdW5zaWduZWQg
bG9uZyBjb2RlLA0KPiArCQkJICAgICB2b2lkICp1bnVzZWQpDQo+ICt7DQo+ICsJLyoNCj4gKwkg
KiBGbHVzaCBjYWNoZSBmb3IgYWxsIENQVXMgdXBvbiB0aGUgcmVib290IG5vdGlmaWVyLiAgVGhp
cw0KPiArCSAqIGF2b2lkcyBoYXZpbmcgdG8gZG8gV0JJTlZEIGluIHN0b3BfdGhpc19jcHUoKSBk
dXJpbmcga2V4ZWMuDQo+ICsJICoNCj4gKwkgKiBLZXhlYyBjYWxscyBuYXRpdmVfc3RvcF9vdGhl
cl9jcHVzKCkgdG8gc3RvcCByZW1vdGUgQ1BVcw0KPiArCSAqIGJlZm9yZSBib290aW5nIHRvIG5l
dyBrZXJuZWwsIGJ1dCB0aGF0IGNvZGUgaGFzIGEgInJhY2UiDQo+ICsJICogd2hlbiB0aGUgbm9y
bWFsIFJFQk9PVCBJUEkgdGltZXNvdXQgYW5kIE5NSXMgYXJlIHNlbnQgdG8NCj4gKwkgKiByZW1v
dGUgQ1BVcyB0byBzdG9wIHRoZW0uICBEb2luZyBXQklOVkQgaW4gc3RvcF90aGlzX2NwdSgpDQo+
ICsJICogY291bGQgcG90ZW50aWFsbHkgaW5jcmVhc2UgdGhlIHBvc2liaWxpdHkgb2YgdGhlICJy
YWNlIi4NCj4gKwkgKi8NCj4gKwlpZiAoY29kZSA9PSBTWVNfUkVTVEFSVCkNCj4gKwkJb25fZWFj
aF9jcHUoc21wX2Z1bmNfY3B1X2ZsdXNoX2NhY2hlLCBOVUxMLCAxKTsNCj4gKwlyZXR1cm4gTk9U
SUZZX0RPTkU7DQo+ICt9DQo+ICsNCj4gK3N0YXRpYyBzdHJ1Y3Qgbm90aWZpZXJfYmxvY2sgdGR4
X3JlYm9vdF9uYiA9IHsNCj4gKwkubm90aWZpZXJfY2FsbCA9IHRkeF9yZWJvb3Rfbm90aWZ5LA0K
PiArfTsNCj4gKw0KPiAgc3RhdGljIHZvaWQgX19kb190ZHhfY2xlYW51cCh2b2lkKQ0KPiAgew0K
PiAgCS8qDQo+IEBAIC0zNTA0LDYgKzM1MzMsMTEgQEAgdm9pZCB0ZHhfY2xlYW51cCh2b2lkKQ0K
PiAgew0KPiAgCWlmIChlbmFibGVfdGR4KSB7DQo+ICAJCW1pc2NfY2dfc2V0X2NhcGFjaXR5KE1J
U0NfQ0dfUkVTX1REWCwgMCk7DQo+ICsJCS8qDQo+ICsJCSAqIElnbm9yZSB0aGUgcmV0dXJuIHZh
bHVlLiAgU2VlIHRoZSBjb21tZW50IGluDQo+ICsJCSAqIHRkeF9icmluZ3VwKCkuDQo+ICsJCSAq
Lw0KPiArCQl1bnJlZ2lzdGVyX3JlYm9vdF9ub3RpZmllcigmdGR4X3JlYm9vdF9uYik7DQo+ICAJ
CV9fdGR4X2NsZWFudXAoKTsNCj4gIAkJa3ZtX2Rpc2FibGVfdmlydHVhbGl6YXRpb24oKTsNCj4g
IAl9DQo+IEBAIC0zNTg3LDYgKzM2MjEsMTcgQEAgaW50IF9faW5pdCB0ZHhfYnJpbmd1cCh2b2lk
KQ0KPiAgCQllbmFibGVfdGR4ID0gMDsNCj4gIAl9DQo+ICANCj4gKwlpZiAoZW5hYmxlX3RkeCkN
Cj4gKwkJLyoNCj4gKwkJICogSWdub3JlIHRoZSByZXR1cm4gdmFsdWUuICBAdGR4X3JlYm9vdF9u
YiBpcyB1c2VkIHRvIGZsdXNoDQo+ICsJCSAqIGNhY2hlIGZvciBhbGwgQ1BVcyB1cG9uIHJlYm9v
dGluZyB0byBhdm9pZCBoYXZpbmcgdG8gZG8NCj4gKwkJICogV0JJTlZEIGluIGtleGVjIHdoaWxl
IHRoZSBrZXhlYy1pbmcgQ1BVIHN0b3BzIGFsbCByZW1vdGUNCj4gKwkJICogQ1BVcy4gIEZhaWx1
cmUgdG8gcmVnaXN0ZXIgaXNuJ3QgZmF0YWwsIGJlY2F1c2UgaWYgS1ZNDQo+ICsJCSAqIGRvZXNu
J3QgZmx1c2ggY2FjaGUgZXhwbGljaXRseSB1cG9uIHJlYm9vdGluZyB0aGUga2V4ZWMNCj4gKwkJ
ICogd2lsbCBkbyBpdCBhbnl3YXkuDQo+ICsJCSAqLw0KPiArCQlyZWdpc3Rlcl9yZWJvb3Rfbm90
aWZpZXIoJnRkeF9yZWJvb3RfbmIpOw0KPiArDQoNClRoZSBjb21tZW50IHNob3VsZCBiZSBpbnNp
ZGUgYSB7fS4NCg0KPiAgCXJldHVybiByOw0KPiAgDQo+ICBzdWNjZXNzX2Rpc2FibGVfdGR4Og0K
PiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYvdmlydC92bXgvdGR4L3RkeC5jIGIvYXJjaC94ODYvdmly
dC92bXgvdGR4L3RkeC5jDQo+IGluZGV4IGM3YTlhMDg3Y2NhZi4uNzM0MjVlOWJlZTM5IDEwMDY0
NA0KPiAtLS0gYS9hcmNoL3g4Ni92aXJ0L3ZteC90ZHgvdGR4LmMNCj4gKysrIGIvYXJjaC94ODYv
dmlydC92bXgvdGR4L3RkeC5jDQo+IEBAIC0xODcwLDMgKzE4NzAsMTIgQEAgdTY0IHRkaF9waHlt
ZW1fcGFnZV93YmludmRfaGtpZCh1NjQgaGtpZCwgc3RydWN0IHBhZ2UgKnBhZ2UpDQo+ICAJcmV0
dXJuIHNlYW1jYWxsKFRESF9QSFlNRU1fUEFHRV9XQklOVkQsICZhcmdzKTsNCj4gIH0NCj4gIEVY
UE9SVF9TWU1CT0xfR1BMKHRkaF9waHltZW1fcGFnZV93YmludmRfaGtpZCk7DQo+ICsNCj4gK3Zv
aWQgdGR4X2NwdV9mbHVzaF9jYWNoZSh2b2lkKQ0KPiArew0KPiArCWxvY2tkZXBfYXNzZXJ0X3By
ZWVtcHRpb25fZGlzYWJsZWQoKTsNCj4gKw0KPiArCXdiaW52ZCgpOw0KPiArCXRoaXNfY3B1X3dy
aXRlKGNhY2hlX3N0YXRlX2luY29oZXJlbnQsIGZhbHNlKTsNCj4gK30NCj4gK0VYUE9SVF9TWU1C
T0xfR1BMKHRkeF9jcHVfZmx1c2hfY2FjaGUpOw0KDQpEb2VzIHRoaXMgbmVlZCB0byBiZSBoZXJl
PyBXaHkgbm90IGluIEtWTT8NCg==

