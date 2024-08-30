Return-Path: <kvm+bounces-25508-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8EC85965FED
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 13:04:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B30371C22FF5
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 11:04:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8611192D6C;
	Fri, 30 Aug 2024 11:02:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MNFl2B+R"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4901018E37B;
	Fri, 30 Aug 2024 11:02:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725015766; cv=fail; b=QG6Eg0yecSda3dnePmylHF1dK6S4dt9zMNzVQM2s+OpORqV/OnKv/GkZ7eVk0Fte2x2e6ScalWLVtZT0VdVWZH/K/WY6s0KPNauZk+tm+VHON0NyyxFB/eTFcwNBsw0Qcsma8cxkb9cmcw4kKZEyCxlPPLcc4NM8UNj9s2vGf20=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725015766; c=relaxed/simple;
	bh=ddiGxUuWLIvn2/3eep6f+Z4CIDZpz3N1t+g8Ld0ve8g=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=T0QMO+E/WFvbpg9pNndHV/2VFgiGnPxxGmurpqo6TUAHwXj2qmdavt2WxPZMD+gPXOi//Ov/2ClDovKA5q8mqaH0CJNhohfpBxyxZiSrxlx/KUE0EmLI5r4HetmlSQAOsodRQnWqL72SuN8wpU9ZrJX25tQIDBFEN2IG9zwXyAA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MNFl2B+R; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725015764; x=1756551764;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=ddiGxUuWLIvn2/3eep6f+Z4CIDZpz3N1t+g8Ld0ve8g=;
  b=MNFl2B+RvFvL8bPA4udHd27PJ9vAddrSUcGNnDS2lJNB4Nn3b/uu2pyG
   GCewNiyKYLY84Tk1mI9UnxQawRCeH2GHI9fCdrFGgaLgiDBpS7NVNtgSQ
   OqEw6pPXEliQZR2xtqeZFn3lXIwAyb1hHdLpBnz627YaH8yyjWsPZlkgM
   E1vzIMfFbZJ7agjiZYMBNM6rKMVKdw2VMwjXdUL2YoRBV/scpTt+q/d5U
   /TS1VIdWWwdJb0hTzNkGtradANiCc+MhRsBtjlWgENhV9DCABula8nhkb
   Uz0QO+k3CfdfxXLYDVwFEl82CnYMNxQEjiemibx79vzr7G86iW4KkBWds
   A==;
X-CSE-ConnectionGUID: UZPGWgTrSZ+brUSZlZf5SQ==
X-CSE-MsgGUID: l3q/H4/XSPuKw+mkbQ8U6A==
X-IronPort-AV: E=McAfee;i="6700,10204,11179"; a="23809526"
X-IronPort-AV: E=Sophos;i="6.10,188,1719903600"; 
   d="scan'208";a="23809526"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2024 04:02:40 -0700
X-CSE-ConnectionGUID: X0eVxig+SsqtsYiOQCTvsw==
X-CSE-MsgGUID: 1mv57Y9VSy64sp0DFcKMPg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,188,1719903600"; 
   d="scan'208";a="63871951"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa008.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 30 Aug 2024 04:02:40 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 30 Aug 2024 04:02:39 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 30 Aug 2024 04:02:39 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.46) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 30 Aug 2024 04:02:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GxGe9B35DqFJwAH61Azv/0qA6c0imsxpS1bVirU6K8/R689YDT4n8ycOrpnn+eb3Vvs4bgJj9a7YxDB5sFiayL43AEU1uSVRjy2T7s1Z7GKjeAzUkSrFBuHPfYAdZJCWWrKYJXKoRpRkpQBXYFn9yr3CKBNxzA4T/D5YvcB8BE5YRWalQaTBvGWTU6NaEprccOt3RUiRR6JfNm4HFVQL7pt54Ga9CbcIZ7/fwJTqW1HD+kEaOsCFhGUPO8NQZxvgZL4+2vogovPwKpIk5COP6GNTqg9y1b9Fk1QruTF2BvygQ3MjEG6ER3uT4TJ+DBwPkM9f+89hCPI9hQ0duhH4fw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ddiGxUuWLIvn2/3eep6f+Z4CIDZpz3N1t+g8Ld0ve8g=;
 b=TuI3AyGci4oJ9BmzCvVLz/ZByGjdyTPRhSGjl0/sFxJuaZRrbNXut7KPCACcQaQF142YPNgI1l6E4kYGRgQsuT3bfzq8L6Bdo9YjhaRZmKFI2vLiH0BmF7eiwTCQ54Z9zvawY9lAhcAaJ7OHp3pH372cSK0auy976u3zZVMHZ/qzFmKi/D6aJEFS/JtNL++JXa7RJxRxCNiUY2MZKKoM4LGP6eT2fEyxt8rA7bkzgoylIR+MznBs+cPkM9yU1VS4EcwefQmcFYjmJph+63abp2Z67FP7/YnRYmJPFyi3YovxW+jj6IoZ/RnBe1mlIUlQcZY+e1NLjCw3sNdG99NoaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SJ2PR11MB8299.namprd11.prod.outlook.com (2603:10b6:a03:53f::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.20; Fri, 30 Aug
 2024 11:02:36 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%7]) with mapi id 15.20.7918.019; Fri, 30 Aug 2024
 11:02:35 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Hansen, Dave" <dave.hansen@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "bp@alien8.de" <bp@alien8.de>, "peterz@infradead.org"
	<peterz@infradead.org>, "hpa@zytor.com" <hpa@zytor.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "kirill.shutemov@linux.intel.com"
	<kirill.shutemov@linux.intel.com>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Hunter, Adrian"
	<adrian.hunter@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>
CC: "Gao, Chao" <chao.gao@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "x86@kernel.org" <x86@kernel.org>, "Yamahata,
 Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH v3 3/8] x86/virt/tdx: Prepare to support reading other
 global metadata fields
Thread-Topic: [PATCH v3 3/8] x86/virt/tdx: Prepare to support reading other
 global metadata fields
Thread-Index: AQHa+E/xnJeJIU2HBUe1bw/wL2vrsbI/X0UAgABIVYA=
Date: Fri, 30 Aug 2024 11:02:35 +0000
Message-ID: <0d68a8ae2aeb3545857d069a037128aadd354acd.camel@intel.com>
References: <cover.1724741926.git.kai.huang@intel.com>
	 <0403cdb142b40b9838feeb222eb75a4831f6b46d.1724741926.git.kai.huang@intel.com>
	 <9c281652-c554-48a1-8ea5-fe7aecf822b6@intel.com>
In-Reply-To: <9c281652-c554-48a1-8ea5-fe7aecf822b6@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.4 (3.52.4-1.fc40) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SJ2PR11MB8299:EE_
x-ms-office365-filtering-correlation-id: caa5d62d-9514-4668-34f5-08dcc8e34152
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014|921020|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?VmRZMXlyY2lST002MTVXRzRFNWg0aXlVRWY3aGc4VUdyQXBHTXZBWmVWUElN?=
 =?utf-8?B?bWNlVGJlekZIZDhCckNrYlhQMVh2b3BRczFlZkpMTFMrUGVJR3FsQThCc0pH?=
 =?utf-8?B?WWxkWEVQZGdCV0RGeW5INlBaTlVUdG5LdU5hNmFyenFSUnZiMG5nc2dxeWhO?=
 =?utf-8?B?SitWOG91VzlsMTVrWTVGSkRzSUdZS0V1ck9zaGFXMlRNSFNjdllpWGRIYUdX?=
 =?utf-8?B?UzJvd3grQ08rUkRTYVRTM1FQcitOaUtSMzJsMmttS3g4U29zTDlXWG5UL2hK?=
 =?utf-8?B?Qy9LVmQyR1JUaHg4ay84QVBIaE53QlJDaUxFYUp2Y2dOU0JHNFBoMVpyb25o?=
 =?utf-8?B?MktudElIeEx2NW02azl3clNRNm4rWTRKNkl3c05waFZiTGpQZTZPMWxyOXNu?=
 =?utf-8?B?cDZoSVRrRVBBVzVjZ2NKTGNiL0NCWTd4NHpiWWJKK3k4azdyeHF5R3VXbEhE?=
 =?utf-8?B?NGJ4bUc4L0NpK0pQd0pIallDY1R0bXNtdllxM0RBejBnNkdYSXM3UlZVeGFU?=
 =?utf-8?B?anBiM0cvSXJDbS9sN0U0Rzl0VlNySG1OeThMZWQ2cFBtNE9XKzZ3RExQb3J5?=
 =?utf-8?B?clowSGplNHNCeUlOckVHUklPc0NUbW0venZSakYwcktSRjlkeGxtbWxHaVlS?=
 =?utf-8?B?T2NSVW90Q21RMFF4NUFXenZDUGExNkpINkF6U2RMTUVRRlBtUU9Od0tjZWli?=
 =?utf-8?B?TWlyRTUwS0JMS1N6bjhnU3lqK0JXZlpoeTNUK3F6NUtMOEZvSDBtRElvVlJT?=
 =?utf-8?B?WkYzY0Jqek0zWFlwV2ZtUXpxTk9GRmF0OC93WGZQUlUrUTFxMWpsSG1BRFUw?=
 =?utf-8?B?UlRVKzRRZUU2Vm1JZUc2L0xiYWtZRDRCZHNXb3lmb3pzM2hnUG5ObXdpRndp?=
 =?utf-8?B?R3lWaFRnSTFuUENCdkhhNnNzMkNnVTV5bzVHZ1N6VWRKR2VRQWErREMrL3Fh?=
 =?utf-8?B?dVhmNDN5a1JpdE1sMWNpY0JPVS9hK1ZZa1dSWlRjR1IwdEg5emNWUE9XdVIv?=
 =?utf-8?B?cE1RQTFQN3dvRUpxR1NXOGtteVpDKzhycm92SjBYQjk1VEhNVC9PZ085YlJO?=
 =?utf-8?B?bmdBNFlxdkpmSE1PQmNkYm1EOGhaL2pFalVGWjRQZzdzUkJzQllzeERPa21P?=
 =?utf-8?B?QjNCTjNmUE41amwrTjg3eldFSmN2dWthNFQzVkEvOGZLMlFKK1ZtR2ZGUVF2?=
 =?utf-8?B?bFBkSE5IYk9KMC9zWmxSSG1NYUYrQ2JqY1lFbHROMGI1TitxU3ozcnZkR0Fr?=
 =?utf-8?B?Wk9NWndIMmVydUdsNEd0a052TmR4TThQWEkxUEVBUnZ4cnlMNWVCdUF3VjhF?=
 =?utf-8?B?bHZSWFVXTDN2NjI5WUVzc0hVSEFVUUp4cm9OdFZwZFhEZno2bVRCT204d3Ni?=
 =?utf-8?B?THd5LzJzWnVkS3I1Nmk0K1ZuTjA0eDJSY0hKYXE2UjB2ZWxZYVF3YXBwa01j?=
 =?utf-8?B?MmpJejJUbHZjTXh5MUVBMlovOTFrbnBEZTJHbWNYRWJ5S1R1LzgxcldmQjhT?=
 =?utf-8?B?ZmRhZ2R2ZVd3cHA2Rnl5aFhEVnJrQy9IbEYvTUsycFVObkdoRExDZEZWMVZQ?=
 =?utf-8?B?ejFSYk1NSWprNjljbHMyRlZheDl3bVVyUnVHNy9zb2JhUmVYdS9PN0pDOGt3?=
 =?utf-8?B?YkxlQ2w3QzVZaWFUMXJ3a3laSSs1KzQ1OS95OWYzRkdsRzlIZkZtVGc4VjVy?=
 =?utf-8?B?MWtqcG9ldXhaeVdQREtITVJHZlFMMWllbEVvVE9uSlZlL09DTE5rR005dXd5?=
 =?utf-8?B?YzFXTFRlQmdlU3R2Z2ZIY1hlQk1Kc0dIcnJzTnBkdGxyTzUxTU9pY2lZMWZI?=
 =?utf-8?B?NEZwTHJCY2hrOUQzbUtHTzhJb0wyYkUrNHl1Q21GMEZyc2xncjhuODQ2RGZD?=
 =?utf-8?B?cWlReVZiQ2QyTVFJbktleXpJK0x2UTBBbVA0Q0t3RDVia3hqNk5Wd1NUWHBk?=
 =?utf-8?Q?YdrtwjPbh8Q=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(921020)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dGpBZHhEdkZES1RtYTFCRlJZSWR2RnluSDhaM2YvMzZ0bHZ4K3pIZUVnL2lq?=
 =?utf-8?B?REdnN3g5bW9sbk04VWFaTDNHS2g5dEFBc1FpaE1ZaXI2bnN3K2E1em9YSlJG?=
 =?utf-8?B?OGxXdXFxdDY5a1dhVW5neFNjbjV0NjlsSlQ4Y2grb0FDWmtiNHJRUDJySkVR?=
 =?utf-8?B?YUNteXFaRnlsa3pJTk5rMTRPY3ErLzZXcGYzMFFMQzNGT01RbUc3RHZRaW16?=
 =?utf-8?B?MnQrdEdjN24zS21xUCtUbzFWUytkZzJNejNQdWVwcUREOWxIOWVCc1NSVXFD?=
 =?utf-8?B?ZHlwemlRVWRJckpPM1hPYkY5MlEzdzdGVDhMcjdXUTFsYW8xR1YyRVZSZ0pT?=
 =?utf-8?B?THpZVWdQY0t5Mkppa2FoWjI1N3gxb29qcm0vNHd1ZUVRMTJGMU5adldnU2dt?=
 =?utf-8?B?T3p2Q1VqT0NyeG9FNkN1ME5TZVNMY0haWWxud2lNclBLR2VUYkp1aUI5UDM1?=
 =?utf-8?B?cWlVQWJTVVdtSHVkQ3NNa0V0Si8vbkx5MGp3Tlo0cU5Vd1l3Q2ViN2JZOUxk?=
 =?utf-8?B?TkdQRG95MFZUNndnZ2p0eVA1bWdYT0RNRkVjK3h5bGdrNUhXSXZhb0NUQVFV?=
 =?utf-8?B?Tkw1RXRkdmZtSHhjWlBDSW9BQy95LzlsWFQ0NklzU09xV2RneTNqUS9IcUYx?=
 =?utf-8?B?YXIybHljSmtJSVRSaXdpWG1aZ3dFU0lueWMxcUlxU21yaUFGSkNMSDVoUkwr?=
 =?utf-8?B?eVdhdDBvbTM1YU1oVCtHOUg4UDFqdHZlY3g2T3dOdUlQVytOVE1MU0JyQWtO?=
 =?utf-8?B?M0pHMCtyN2pSRnlIL1EydEJ0SmEralM0ZlBZSUprTDB0Q0xJci9oL1JROGsz?=
 =?utf-8?B?SGNETlNvM2x1YnZUV0IzbzQvQjk3S052cGgrTDRQU3hkZGdSaXUyUzFLNVl1?=
 =?utf-8?B?SXpoS00yaTA4YzdQSGY0dmMxcVpoUWI5NFJlNnhCT0JpUHVYaXprOXpIeTZt?=
 =?utf-8?B?VENzYk41RWcwNDluUXg2SmNEelRkdk5VQ2FiQ3IxNklvcVkvVnRtT0M2MU9u?=
 =?utf-8?B?WlZVTWwyVERhc21VbWRWdkpDcXhZeGVIdm9NeWtiUjlEZ216bDlwcmlha0dh?=
 =?utf-8?B?UXdYSERUalF2Z1c4OFZvV0dZQXlEZTRkNTQzMDQ4RUc5SWI3OU51bXpMaWcv?=
 =?utf-8?B?MXlOZC9xRVF6NWtUeThOVXlHSjBlOFo4cGtBOW9vOC8reHBnak9aZ2lxS1Nr?=
 =?utf-8?B?UGFORzZvSEttZGJ0U1BVVi9PYkJTTHZ2TVE5NWduenhkNGZXL3lwdmxPMnk2?=
 =?utf-8?B?bitNZEc4N0g1WFVWSzFuY2luYWtpbm9rZ3hpTVBlNWtCNVR3ZzBNbkI1M2My?=
 =?utf-8?B?RHhTU1RyalBNVktWNHM4dWkvVmk1MlNoY0JadzhLNHZLaTRJUllDTlNLQnR0?=
 =?utf-8?B?ZUZGbTRQRC95WTRWeDMvZG1GZlBvL2pyYWxjSXBtdnI1RHBzY3owUmo0cUdS?=
 =?utf-8?B?R2tyNVVmVllKS29vNTc3bklxNWlvM2JKTmhJTDZSNStHQ0xDSlpxM3VQeGRG?=
 =?utf-8?B?TCs5UWRXbm1UM2JaUzJRQzVrSzExVzB0Yk9JZUdGYS81NHpBTlQyekdDbmd5?=
 =?utf-8?B?WS9NM09wdzBvb2x0Rk1zOEY5NjUreHNoRldueVdzMXROcTRETk52WlhyaStq?=
 =?utf-8?B?QjVTZml0RVBhaG1abVVDQlNUTmRJeFdyK2E4ZldiRXhmdkVUbVJoVU04YWVw?=
 =?utf-8?B?bnpYbUduMmpuSzNLNzhHTmFIcHdNU0hCQVY2aFhQUGVYY0RrUCs4UHFlV3c4?=
 =?utf-8?B?aUhEc3NNVW50a25sVHN5SlFXRk5nb2g1eTkxMnRpL0o3NGkvM2JWU2RyVHFR?=
 =?utf-8?B?N0JQZUVZa1JkaVhNNkZQaFpabWRVMXp0bFNELzhPdHovQlR2OE1ZcHZtOFlo?=
 =?utf-8?B?K1JIZFl5dHhzaVdSOUNXc3FFbnh5RjlVM0JTdHFBOUdZTmNUcWkxanViVFh0?=
 =?utf-8?B?TEpWeEZoeFd1dDN4T3lId3VUNnAwSmZmdXkwTXhrTEZiaTFVVU9MVEs5Wit2?=
 =?utf-8?B?NXJJbjVrT0E5U3ppMTA5cThXeWg1S2wxMFFVVTNFNFRYSEMzNDAxV3FHc3I5?=
 =?utf-8?B?Wmk0d3hzb1BwVExPTEF0bW1xNU9MTG0rM2wzY0JzRjVJUDdUS28yS2ZkbitO?=
 =?utf-8?Q?sm/gljy9DjvYwufYpmB1vuF9I?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <689C676680F4ED45A5E58BD32876E8AE@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: caa5d62d-9514-4668-34f5-08dcc8e34152
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Aug 2024 11:02:35.8264
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: otV9xby4wewxvtiRc5/t5ajy4heQgO3Pa8RuHhX2iN1RpjdMvjDLypo6B9zz6xu7jpF3iVvtKIQi4c3oOAUfGA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB8299
X-OriginatorOrg: intel.com

PiA+IA0KPiA+IEZvciBub3cgdGhlIGtlcm5lbCBvbmx5IHJlYWRzICJURCBNZW1vcnkgUmVnaW9u
IiAoVERNUikgcmVsYXRlZCBmaWVsZHMNCj4gPiBmb3IgbW9kdWxlIGluaXRpYWxpemF0aW9uLiAg
VGhlcmUgYXJlIGJvdGggaW1tZWRpYXRlIG5lZWRzIHRvIHJlYWQgbW9yZQ0KPiA+IGZpZWxkcyBm
b3IgbW9kdWxlIGluaXRpYWxpemF0aW9uIGFuZCBuZWFyLWZ1dHVyZSBuZWVkcyBmb3Igb3RoZXIg
a2VybmVsDQo+ID4gY29tcG9uZW50cyBsaWtlIEtWTSB0byBydW4gVERYIGd1ZXN0cy4NCj4gPiB3
aWxsIGJlIG9yZ2FuaXplZCBpbiBkaWZmZXJlbnQgc3RydWN0dXJlcyBkZXBlbmRpbmcgb24gdGhl
aXIgbWVhbmluZ3MuDQo+IA0KPiBMaW5lIGFib3ZlIHNlZW1zIGxvc3QNCg0KSG1tLi4gSXQgc2hv
dWxkIGJlIHJlbW92ZWQuICBJIHRob3VnaHQgSSBoYXZlIGRvbmUgdGhlIHNwZWxsIGNoZWNrIGZv
ciBhbGwgdGhlDQpwYXRjaGVzIDotKA0KPiANCj4gPiANCj4gPiBGb3Igbm93IHRoZSBrZXJuZWwg
b25seSByZWFkcyBURE1SIHJlbGF0ZWQgZmllbGRzLiAgVGhlIFREX1NZU0lORk9fTUFQKCkNCj4g
PiBtYWNybyBoYXJkLWNvZGVzIHRoZSAnc3RydWN0IHRkeF9zeXNfaW5mb190ZG1yJyBpbnN0YW5j
ZSBuYW1lLiAgVG8gbWFrZQ0KPiA+IGl0IHdvcmsgd2l0aCBkaWZmZXJlbnQgaW5zdGFuY2VzIG9m
IGRpZmZlcmVudCBzdHJ1Y3R1cmVzLCBleHRlbmQgaXQgdG8NCj4gPiB0YWtlIHRoZSBzdHJ1Y3R1
cmUgaW5zdGFuY2UgbmFtZSBhcyBhbiBhcmd1bWVudC4NCj4gPiANCj4gPiBUaGlzIGFsc28gbWVh
bnMgdGhlIGN1cnJlbnQgY29kZSB3aGljaCB1c2VzIFREX1NZU0lORk9fTUFQKCkgbXVzdCB0eXBl
DQo+ID4gJ3N0cnVjdCB0ZHhfc3lzX2luZm9fdGRtcicgaW5zdGFuY2UgbmFtZSBleHBsaWNpdGx5
IGZvciBlYWNoIHVzZS4gIFRvDQo+ID4gbWFrZSB0aGUgY29kZSBlYXNpZXIgdG8gcmVhZCwgYWRk
IGEgd3JhcHBlciBURF9TWVNJTkZPX01BUF9URE1SX0lORk8oKQ0KPiA+IHdoaWNoIGhpZGVzIHRo
ZSBpbnN0YW5jZSBuYW1lLg0KPiANCj4gTm90ZSwgd2VyZSB5b3UgdG8gYWNjZXB0IG15IHN1Z2dl
c3Rpb24gZm9yIHBhdGNoIDIsIFREX1NZU0lORk9fTUFQKCkgd291bGQNCj4gaGF2ZSBnb25lIGF3
YXksIGFuZCBubyBjaGFuZ2VzIHdvdWxkIGJlIG5lZWRlZCB0byBnZXRfdGR4X3N5c19pbmZvX3Rk
bXIoKS4NCj4gU28gdGhlIGFib3ZlIDIgcGFyYWdyYXBocyBjb3VsZCBiZSBkcm9wcGVkLg0KDQpZ
ZWFoIHNlZW1zIGJldHRlciB0byBtZS4gIEknbGwgdXNlIHlvdXIgd2F5IHVubGVzcyBzb21lb25l
IG9iamVjdHMuDQoNCj4gDQo+ID4gDQo+ID4gVERYIGFsc28gc3VwcG9ydCA4LzE2LzMyLzY0IGJp
dHMgbWV0YWRhdGEgZmllbGQgZWxlbWVudCBzaXplcy4gIEZvciBub3cNCj4gPiBhbGwgVERNUiBy
ZWxhdGVkIGZpZWxkcyBhcmUgMTYtYml0IGxvbmcgdGh1cyB0aGUga2VybmVsIG9ubHkgaGFzIG9u
ZQ0KPiA+IGhlbHBlcjoNCj4gPiANCj4gPiAgIHN0YXRpYyBpbnQgcmVhZF9zeXNfbWV0YWRhdGFf
ZmllbGQxNih1NjQgZmllbGRfaWQsIHUxNiAqdmFsKSB7fQ0KPiA+IA0KPiA+IEZ1dHVyZSBjaGFu
Z2VzIHdpbGwgbmVlZCB0byByZWFkIG1vcmUgbWV0YWRhdGEgZmllbGRzIHdpdGggZGlmZmVyZW50
DQo+ID4gZWxlbWVudCBzaXplcy4gIFRvIG1ha2UgdGhlIGNvZGUgc2hvcnQsIGV4dGVuZCB0aGUg
aGVscGVyIHRvIHRha2UgYQ0KPiA+ICd2b2lkIConIGJ1ZmZlciBhbmQgdGhlIGJ1ZmZlciBzaXpl
IHNvIGl0IGNhbiB3b3JrIHdpdGggYWxsIGVsZW1lbnQNCj4gPiBzaXplcy4NCj4gPiANCj4gPiBO
b3RlIGluIHRoaXMgd2F5IHRoZSBoZWxwZXIgbG9zZXMgdGhlIHR5cGUgc2FmZXR5IGFuZCB0aGUg
YnVpbGQtdGltZQ0KPiA+IGNoZWNrIGluc2lkZSB0aGUgaGVscGVyIGNhbm5vdCB3b3JrIGFueW1v
cmUgYmVjYXVzZSB0aGUgY29tcGlsZXIgY2Fubm90DQo+ID4gZGV0ZXJtaW5lIHRoZSBleGFjdCB2
YWx1ZSBvZiB0aGUgYnVmZmVyIHNpemUuDQo+ID4gDQo+ID4gVG8gcmVzb2x2ZSB0aG9zZSwgYWRk
IGEgd3JhcHBlciBvZiB0aGUgaGVscGVyIHdoaWNoIG9ubHkgd29ya3Mgd2l0aA0KPiA+IHU4L3Ux
Ni91MzIvdTY0IGRpcmVjdGx5IGFuZCBkbyBidWlsZC10aW1lIGNoZWNrLCB3aGVyZSB0aGUgY29t
cGlsZXINCj4gPiBjYW4gZWFzaWx5IGtub3cgYm90aCB0aGUgZWxlbWVudCBzaXplIChmcm9tIGZp
ZWxkIElEKSBhbmQgdGhlIGJ1ZmZlcg0KPiA+IHNpemUodXNpbmcgc2l6ZW9mKCkpLCBiZWZvcmUg
Y2FsbGluZyB0aGUgaGVscGVyLg0KPiA+IA0KPiA+IEFuIGFsdGVybmF0aXZlIG9wdGlvbiBpcyB0
byBwcm92aWRlIG9uZSBoZWxwZXIgZm9yIGVhY2ggZWxlbWVudCBzaXplOg0KPiANCj4gSU1ITywg
aXQgaXMgbm90IG5lY2Vzc2FyeSB0byBkZXNjcmliZSBhbHRlcm5hdGl2ZSBvcHRpb25zLsKgDQo+
IA0KDQpJIGFtIG5vdCBzdXJlPyAgTXkgdW5kZXJzdGFuZGluZyBpcyB3ZSBzaG91bGQgbWVudGlv
biB0aG9zZSBhbHRlcm5hdGl2ZXMgaW4NCnRoZSBjaGFuZ2Vsb2cgc28gdGhhdCB0aGUgcmV2aWV3
ZXJzIGNhbiBoYXZlIGEgYmV0dGVyIHZpZXc/DQoNClsuLi5dDQoNCg==

