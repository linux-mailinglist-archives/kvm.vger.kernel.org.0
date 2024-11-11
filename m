Return-Path: <kvm+bounces-31533-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A6EF89C482C
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 22:37:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 70818B28888
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 20:49:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5EC411AC423;
	Mon, 11 Nov 2024 20:49:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="A+POsD2Z"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55E8214F9F9;
	Mon, 11 Nov 2024 20:49:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731358157; cv=fail; b=EFGD1gTgMRs9GkLbmek/eT/DKe7qHDWP5C/O6fYeZ2/YN6QLP4U8JD0KkkAkrpCCiPnFE27b4mw2/9x8jDMjDgotQ90upLUkeRtyChc/ghwvqBNgJJZE0wD7gdMCFIqxcizu7aopdXqLZ5arpidcen1X6gZ7oxwpU0ws7nfFH0k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731358157; c=relaxed/simple;
	bh=gGVrWJjBoPI6hZwBmxzdNqUcLfF54Uz/Et7kjaxV49Q=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=YwJPTNGOQaqY3nbHb7+s8p3r8xFmO8KIU008cf++PbKERWcQZNqwISqlyBQqtWsSqWZm0vgI0OMy4DZi1Mim8afUoYSF1JDXtyCnwBQ9HcjpzLADKt2wow7OfoBFD9GBD9AEhv3LC95P85HwI3PEFv+kGhQtil2hsysZYyl5CUw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=A+POsD2Z; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731358155; x=1762894155;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=gGVrWJjBoPI6hZwBmxzdNqUcLfF54Uz/Et7kjaxV49Q=;
  b=A+POsD2ZXIEh4swShMpqH2NeHwu9P1GP1rmXGaZGQ/l16O8iEEK0RAvX
   lR5me2RsF9R+32RDqeCZlhPmLuR5Ey/OEffnE+Kgcd7YI9OhrP7/cH3tO
   poQGZh/yfacrSYYKRI1ayWI9pOnK9Au7/OoBKN3kSpbBIcvgfM6Rs2tQF
   BwgkdOSb8UsWOIwfXzTg3kFCD407Ankjmo1uvEsjBiMBVf/pogjlEBSaO
   f9ZLTcFguJEdavL9ThgFZzXiIiQMZnKeeV1vTsXB/ZOZR75EizR58v09a
   QKf+pNTDD5oSjccDa0z9nZH08D5pV4X/tm6lIF49faB10N3p+RWqKnxdr
   g==;
X-CSE-ConnectionGUID: 4noCRNgqTEeuRRA6MjWXlQ==
X-CSE-MsgGUID: /bS0ZA9uQ5iyf37iOaD20w==
X-IronPort-AV: E=McAfee;i="6700,10204,11253"; a="34047617"
X-IronPort-AV: E=Sophos;i="6.12,146,1728975600"; 
   d="scan'208";a="34047617"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2024 12:49:15 -0800
X-CSE-ConnectionGUID: tkh9ROa/Q/G2ZA8EJ0TUqA==
X-CSE-MsgGUID: otUnhpG5T2S9mGNJtDrMhQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,146,1728975600"; 
   d="scan'208";a="87200214"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa008.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 11 Nov 2024 12:49:14 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 11 Nov 2024 12:49:13 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 11 Nov 2024 12:49:13 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.170)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 11 Nov 2024 12:49:13 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=m//gga6Wk/8XoaVCS3sZaISK1UVZvE5MCYKnuAp7Cu4bkIZsgoaLfqLRGzFeWDzS9q320ZNRtY+fMyKUwPITHW4mKPRFMBPJJFSGpV2KXoxIC5gyKi3UHerXR53W+LiR1befUYIuK1wL7NyOucLPsNSLETbWWCINfQ1xAgrGgmS5o7xxNc4Zh8l/oWsLVAohvF4sejUf/d8X+A9fHyCa0MrQb8gDIxL5tqcQxrwfnUAY6MYb0/NybIuNgiLXyXF1dFjXqtFOhTYY0SJc39codQcYAnzegvr+WhEYunfidskAu9PImWHxI0c0aGL4/IulZ58TorGZiyCkQ/bXh+P+Xg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gGVrWJjBoPI6hZwBmxzdNqUcLfF54Uz/Et7kjaxV49Q=;
 b=OqbX0kDpt5CZg0gwWWbWWfIyiT/jVeunw2Fpwy5B69pyIiO1xvzwwBWVLPnW4AT5R4UVpwWGsYhJD2NrNYjT/bQ7yryMQWNi/0kftVxZ+YHeL+wTUiCkQH7y44Jl4trjnreBUxLhcUN8LoHowQJKNMG7Gk5jzO6JVQ153MMtflWEl3Vnr976w4oKC2ch6YKnLI7MOvDMaTuPqMh5meGK5GBX/cKB0AQ6I1rMBxz/TGyLhFJKDOtxt8CzoeNDoU++paIzM5j3NaL39W1u4xjFbGoaZiR8F8WvmMpfhM+IIPLwNZeJgt32jXt6zEQ4+LDLUASnuypURJQ+nDBc5aY9qA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB5983.namprd11.prod.outlook.com (2603:10b6:510:1e2::13)
 by DM4PR11MB6549.namprd11.prod.outlook.com (2603:10b6:8:8e::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8137.29; Mon, 11 Nov 2024 20:49:06 +0000
Received: from PH7PR11MB5983.namprd11.prod.outlook.com
 ([fe80::a5b0:59af:6300:72ad]) by PH7PR11MB5983.namprd11.prod.outlook.com
 ([fe80::a5b0:59af:6300:72ad%4]) with mapi id 15.20.8137.027; Mon, 11 Nov 2024
 20:49:06 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Hansen, Dave" <dave.hansen@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "bp@alien8.de" <bp@alien8.de>, "peterz@infradead.org"
	<peterz@infradead.org>, "hpa@zytor.com" <hpa@zytor.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "kirill.shutemov@linux.intel.com"
	<kirill.shutemov@linux.intel.com>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Williams, Dan J"
	<dan.j.williams@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "nik.borisov@suse.com"
	<nik.borisov@suse.com>, "Hunter, Adrian" <adrian.hunter@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Edgecombe,
 Rick P" <rick.p.edgecombe@intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH v7 00/10] TDX host: metadata reading tweaks, bug fix and
 info dump
Thread-Topic: [PATCH v7 00/10] TDX host: metadata reading tweaks, bug fix and
 info dump
Thread-Index: AQHbNCWIZ2qemHMuw0G7kdYKKGDupbKyiauAgAAEUoA=
Date: Mon, 11 Nov 2024 20:49:05 +0000
Message-ID: <f5bc2da140f16da41af948adb50a369840ff890c.camel@intel.com>
References: <cover.1731318868.git.kai.huang@intel.com>
	 <0adb0785-286c-4702-8454-372d4bb3b862@intel.com>
In-Reply-To: <0adb0785-286c-4702-8454-372d4bb3b862@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.4 (3.52.4-1.fc40) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR11MB5983:EE_|DM4PR11MB6549:EE_
x-ms-office365-filtering-correlation-id: 3e5393b6-3872-4aba-77db-08dd02924861
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016|921020|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?WXRvYngzL0tQU3dtNjdkMFdCUXkxZTRmaTR2My9obDhFekNpS3ozdkQ2dTFt?=
 =?utf-8?B?MWZEd3Y4Y2x1NTNGK1RlTjkwdnFFQVB2dENzMjBxVnV3STVyakppTWxPZVRu?=
 =?utf-8?B?aEs5U1lobUltUWlzclZhMHdVRHVoYjhLVVR2elhBQnBRczJIVHQ0TENXb29i?=
 =?utf-8?B?M2FBL0pjVTN4cWV0aFNCUUVWeTVTTTI3ZThHejQ3dzlLeGNsZnlCdEVtWVo1?=
 =?utf-8?B?ZUIrSnFzbVZBWnVab1ZBUXFiSGZ3SkFWdEw4c3JtUmovMGJWa2toRkd6dGEy?=
 =?utf-8?B?Tjd3Q0lBUlZGOXNXSEFNbFYxT2ZxNC93UHZTRllmVFdmbzBlUU1ucm80b0Ix?=
 =?utf-8?B?bHZJb2F3T3QzVC8wNUxPM2Zad3RISUpBT2s2NVpnOWxINmNBTmlFUTB5cUNC?=
 =?utf-8?B?alRDOFY2eDVXaThIeTRSeitveGw4VWVuUG9CczVsK3c0elpVa0RYV05sM3JR?=
 =?utf-8?B?TEFaVDJKczlibkRPTHZmTG50U1BQckdNUmVRWFFoa2VNcmNaTkNnbzJnRXZu?=
 =?utf-8?B?UkU2SWRVTVp0aEJDbU4xUmxwbVpmdVNGbENwbko5Z2NEaUNmcXF3Y3ZEYTho?=
 =?utf-8?B?dEZZdXIyRHhxNkg2YmVVcFZ4em9sKy9qcW9MckZSQys3RENJQXI0V1hGK2pV?=
 =?utf-8?B?S3pPczQ3eU5oMVNWLzVNLzNmUGRxYWoxN1hxSWRTbis3WUl3MlYzMHR1ZW5z?=
 =?utf-8?B?Z0RwVmdESmU4MFVNUENsaXAydmw1eHg2dHY2Q2xCOGdjUVV6RkRDYXhzRkEy?=
 =?utf-8?B?bHdQNlNiVkZlK1pncWxZS3lzcTIrbW4rbEJRd2NtWEp0OXRaaE52dW1WY1lx?=
 =?utf-8?B?MzFMMlJDOWxyT2w1NzBMV0hCYWI0dS9jTXgxbFdJMURoMTFRWVpnRXV2aHQ5?=
 =?utf-8?B?ZVh2SkJvT3lWT1FEWSt3am1Fa2VWcFA0dnZ5QzBxRjJxUVZCdmxzeWFrbVUy?=
 =?utf-8?B?QXdZc0NwUlpiM1B1RG42R0kyTFA4a0ZjYkd5VzZvbGhmNHExMXRZbVdvZjdy?=
 =?utf-8?B?c09sU0hlTlB1dlE1SFpPb1Y1YnFqT0hyQTh2T0ltd3htQWdKWnEvTzVNRmxi?=
 =?utf-8?B?czllc21MYzJGcUlrNHJ1ODRpemx5ckp4MDFiYW5oRU91aTNkOWwySG85ZVY4?=
 =?utf-8?B?K2QrZXNTcmdBR3dlNDZvQWg3VlJ4WFFJUmFITXNFc0cwRE5WeG0yeVhDWTZn?=
 =?utf-8?B?RVpRcnk1UE5tVmlXeHVOUC9sUDNtWnc4RTVaNjlHY1Zid2pMUnhnYUc1N0pj?=
 =?utf-8?B?MHE0RnNlS2orZjc3Sjg1K05qTUdDWXRRbFprclU0WEI1Q01XWktuVXE4OWlN?=
 =?utf-8?B?WVQ4VDhUQmdhTHc2RDFXSTVvSG1nTzdsMHdHZk5lTzNSSUdEakh1UEJnNXZu?=
 =?utf-8?B?QzdacXpzemFhdWxaSC9HZE5wdXRkV2RVSjViL0lsd3BibVZSK3Jsb0xzT0Jh?=
 =?utf-8?B?ZnBodkNWdW5qRXVteXBWV0hmclFEMENsNHQ0SHB5SEQyZXJFZ0grQlZtOVgv?=
 =?utf-8?B?KzdTTTZ5akxCcEJUWmh0Tmh5bXpZMCt0ZXZmSmJ0Y0h0dG5XOXF2OXFYQUZF?=
 =?utf-8?B?b0NLZVgwcXhIOXYrMGpuZnJvUmcvUWRma2N3dS9FQVBPOGZKTGw3T0lMVnVK?=
 =?utf-8?B?Q1U4Vk5sZjNtd1NKSk0xOXVJSTlscDErcVJud0hQUCtkcXg5R2pSRTFRWlBI?=
 =?utf-8?B?OE1DaVZVd0ZwRWZ4QkxMM2ZBVVpmQmVOTjdDN21pMXpWMmlJV1lpblNYK1pj?=
 =?utf-8?B?V2d2TXV0NlNMOExXOW5qdjAvZEhaSkpaay92V1BTK0djU3R1MGZEQUJzWU1H?=
 =?utf-8?B?bW9XajBMb3V5RE5BK0RVOVltUmlsV0U3YnpWRytrZUdPNHNVUE1UK0NQSU5t?=
 =?utf-8?Q?tHqzGhYhry593?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB5983.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(921020)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MTVUV2lveFNUSGo5Z1JTVnNjR1Frd0NENEhpNER3YVJUR1VDZXFUNzlxZjB0?=
 =?utf-8?B?endQRzBTaEJVaWFnQVZEbSt1VExoWGJBUmFSeVZsS3ZEdTRxUWxVdUIrQ1ha?=
 =?utf-8?B?emppblEyZmNlWmhnTCtQblk3TnZXR0ZEUjl6MkplUzFROG5mbjAzL0ZzUEJo?=
 =?utf-8?B?aU1UOEFZZzFMOW1vbFZEVVhWNmZCdkdjbFN2eTc2Y0NJN0NzSGxjRFUyZ1dM?=
 =?utf-8?B?cVFhSEJJejBGb1pkSm1QRFN5SlRlWEo1eTdoZHkweFRmR3pYUXZHZmxUUUs1?=
 =?utf-8?B?USszNUtTYVhnNyt6eHJrN3gzeFJzVDA3MnJzK3pMcDFvYTVNU0NnQzlLZE8w?=
 =?utf-8?B?eTdRcHhZNU9Rdk9aMUIyZUJ2YnkxVkdZbUNuczFGMGJlTDNOL21uOVVHTlEy?=
 =?utf-8?B?Qmd0R3ZmYlA5RWlxWVZmMHRUZzhJaGwzOVZZa2NDMWFJT0g3YU12cGZ2bUp2?=
 =?utf-8?B?azdCYmtRTURValdqVnFoZkJWeTM4OXc5aVp5elJzdm02bzFQZnpwYm1JQzBO?=
 =?utf-8?B?USs1M29hd1J0NmhBeWNsUjFCa1lGd1JSa3ZWSTFxaFhYLy9WQkRqUjhNV05a?=
 =?utf-8?B?bFBURnFrdkpGaHRpS0U5MFZlVHErV2RablFjVzlFcGE2N0ZodlQzbHJBLzBU?=
 =?utf-8?B?dGFnaGZ6WmhVenBGd2ZrZ3JsT0pNbVRWQVZMUytoR3ZwOFRhWVNMcm5lUzdR?=
 =?utf-8?B?eDFYMlk4bzBsSzV0ck9ZN0JaWDRtTmZzNml2MUE2TUZWRUxjc25WV1cxQmdG?=
 =?utf-8?B?azJMWjJ2SHpDbUZ3Vy9mMUJ1bmtsMjdxbTBwbUZaNGFlYngzOWRrVS9Cb29i?=
 =?utf-8?B?eHNpaElzRzhHZS9PL1lWdysvOHVaQ3dyQkRFVm1iTDdPMGE1TkdmUkp2SzRh?=
 =?utf-8?B?NktWWGdSNG1RVXMvV2dWaG5nNFRJdkJNWnFGRStVc3hRUDFIYkNwZ3ZpcVRO?=
 =?utf-8?B?TXZDdUxlUGs1N3VZWHIrc1Q1OC85Q1hXa09KckkvaWs3aUFPd2s0V25DM1Uw?=
 =?utf-8?B?emNvbmVJUEhiR0hEd0h0OVBFMXlZK21VTDhucjB2MklQcnZVR0M4M0RLRmh2?=
 =?utf-8?B?VUdiRGxWSTdMT2UxdlBkLzV2UVQ2ZTF6WTJQS1JxUTdwaVd3S2h1VVZmMlBw?=
 =?utf-8?B?aXU0OVB6aXI4Y3RBUjI5NTVGWW40TXpIUUlydS9XTGZRNFVydjBxVktTelZ5?=
 =?utf-8?B?UjZ0SE9YRVVNVWFyRXhDcTJJbFVvSDgrNit4ZHhVV2hCU0c0ei9raXMvaGFR?=
 =?utf-8?B?T1R3QmNZVnJxUWNsdUZpYmFWTXlHcGw2d2I4TnFCMFFrVHNrdjk4MC90ME9j?=
 =?utf-8?B?cktWVkxLZnRVdFhoNlpTeWdmejV6U0Rnd3ZTSk5yNlNhK29yUlpEN0p5NHRK?=
 =?utf-8?B?RmYwZ3NOZTRPb3dtQzlFcHlZRlllN3R4ZEtSYllHWHdOOXd1RTJESlFHbFpL?=
 =?utf-8?B?V0tEMm9VZkdFdFR0ZmhYMzFLbWI3WUF0U2UyeUllNmdnaTF5dW44YXY5RUd2?=
 =?utf-8?B?OG1jNlNORHhqc01WL1FXQ2o0Ly9sR3M3RmV2TlVwNThtSFFhSlZDMnB2THdV?=
 =?utf-8?B?eGdDOG0zRHkzdXBoQW9YK3ZOWk1kcFljYzZnMkVadGtnZC9Ib3FjMzQvTktN?=
 =?utf-8?B?RlJEOTFuRk01TXdyVk1xWFhreXJyU0lYbE94RmduNmdSUjlldVR2bC9TRkhU?=
 =?utf-8?B?dHRZOFhRQUUzNGFnZFBQVUZwTmgzRDdRdStZdTdhS0ZZQndmcHI5VDBjM1BY?=
 =?utf-8?B?OWJVZFo4MXRCNGR0LzMxVGZBNnpZMTBkMXQxb2FnVVVPVTBST3RCeEpGU2NB?=
 =?utf-8?B?bmlLdnBsSkV3alh3TlZGUkJLekpnZEY2cmF3b1dRU21SWUhNM3NJd0JGVkhK?=
 =?utf-8?B?QkhKL1RVM0VVUWRCM2FVMEFJVjZ5VEVjWWVldysxcWsvMFdSZzcvakVadHpK?=
 =?utf-8?B?aVh6bjhCUXlpR3BYVm5nSXJFZTNUMmZyQTcvMEY3c3ArUGJkRnYrM3RZR05M?=
 =?utf-8?B?ZEhGdm1ySHZNMFVxaXBRS3VlczMvYzR0cWx0UFJ2OEc2VnFFWmFpK2RMcTVo?=
 =?utf-8?B?Y2MySDZxc2JneGJZblpCMnVzZktVTk1tQ2VXSFgwRDBBK2xqNzRqNW96Tnkx?=
 =?utf-8?Q?yR1OhW4cHx0F7mtfYin5tcwpR?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C41F8F377135A7448350910C0369911F@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB5983.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e5393b6-3872-4aba-77db-08dd02924861
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Nov 2024 20:49:05.8703
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wmYhi0f5etYyuGVEl8HiSpWKFv8f3VENA6m85NojWRzoPKViXXw+9W2KaG3fyyNu+gif2/UU9NwQosq9ZV998g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6549
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI0LTExLTExIGF0IDEyOjMzIC0wODAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
T24gMTEvMTEvMjQgMDI6MzksIEthaSBIdWFuZyB3cm90ZToNCj4gPiBUaGlzIHNlcmllcyBkb2Vz
IG5lY2Vzc2FyeSB0d2Vha3MgdG8gVERYIGhvc3QgImdsb2JhbCBtZXRhZGF0YSIgcmVhZGluZw0K
PiA+IGNvZGUgdG8gZml4IHNvbWUgaW1tZWRpYXRlIGlzc3VlcyBpbiB0aGUgVERYIG1vZHVsZSBp
bml0aWFsaXphdGlvbiBjb2RlLA0KPiA+IHdpdGggaW50ZW50aW9uIHRvIGFsc28gcHJvdmlkZSBh
IGZsZXhpYmxlIGNvZGUgYmFzZSB0byBzdXBwb3J0IHNoYXJpbmcNCj4gPiBnbG9iYWwgbWV0YWRh
dGEgdG8gS1ZNIChhbmQgb3RoZXIga2VybmVsIGNvbXBvbmVudHMpIGZvciBmdXR1cmUgbmVlZHMu
DQo+IA0KPiBDb3VsZCB3ZSBwbGVhc2UganVzdCBsaW1pdCB0aGlzIHRvIHRoZSBidWcgZml4IGFu
ZCB0aGUgbmV3IFREIG1ldGFkYXRhDQo+IGluZnJhc3RydWN0dXJlPyAgTGV0J3Mgbm90IG1peCBp
dCBhbGwgdXAgd2l0aCB0aGUgZGVidWdnaW5nIHByaW50aygpcy4NCg0KSXQgYWxzbyBoYXMgYSBw
YXRjaCB0byBmYWlsIG1vZHVsZSBpbml0aWFsaXphdGlvbiB3aGVuIE5PX01PRF9CQlAgZmVhdHVy
ZSBpcyBub3QNCnN1cHBvcnQuDQoNCkp1c3Qgd2FudCB0byBjb25maXJtLCBkbyB5b3Ugd2FudCB0
byByZW1vdmUgdGhlIGNvZGUgdG86DQoNCiAtIHByaW50IENNUnM7DQogLSBwcmludCBURFggbW9k
dWxlIHZlcnNvaW47DQoNCj8NCg0KVGhlbiBJIHdpbGwgbmVlZCB0bzoNCg0KIC0gcmVtb3ZlICJw
cmludGluZyBDTVJzIiBpbiBwYXRjaCA3ICgieDg2L3ZpcnQvdGR4OiBUcmltIGF3YXkgdGFpbCBu
dWxsIENNUnMiKS4NCiAtIHJlbW92ZSBwYXRjaCAxMCAoIng4Ni92aXJ0L3RkeDogUHJpbnQgVERY
IG1vZHVsZSB2ZXJzaW9uIikuDQo=

