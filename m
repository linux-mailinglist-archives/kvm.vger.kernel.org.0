Return-Path: <kvm+bounces-50579-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E893AE7204
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 00:01:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D407B17BE0E
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 22:01:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C86F25A640;
	Tue, 24 Jun 2025 22:01:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BIGFSYnf"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AA20259CBB;
	Tue, 24 Jun 2025 22:01:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750802496; cv=fail; b=d/nSFWbWR/jL49DGb0MzR4BdEpKmZ/voNBMschCygsCz/LOstTIkLoLBiDP34salhCWbDYRrCj3fuyiJpS4Myh1jaIHD/c1PL135c/tLmR5OCt65kiriiNi/XA7vDy9UcpFVvNbIpWV8iifxx2ZhbK39MKmmSKxF5wbt7gg8mjk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750802496; c=relaxed/simple;
	bh=7NtpqXtZx+O56lDk4gXyJSMyVlnzX7AB7Ix+jonz9r8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ZSBdHZ4PwVS0trENxHhL5A1UBf/a0UKmwQgCNN5tin7SXjZAbYb7GrwqPJHVbZu7/BJLYc6DTt0RYC4K9UHvCIEezV0Slb2+ZmzgDa3cPxO8umrOSZd/IMfeB9AaJUjtlqnKETg529UqqENhACagr7kxcZ2PLu3P8wu9/qUnqPQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BIGFSYnf; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750802495; x=1782338495;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=7NtpqXtZx+O56lDk4gXyJSMyVlnzX7AB7Ix+jonz9r8=;
  b=BIGFSYnf6uL8iREs8bGCkIArQeqJxRrUOiwWoRjtpXFoUnxITAtYcLgk
   EKiGZkC7aaM51uh2G7LjLhqIwS55eLHQBiXnuO64Y3zZ/90dWqBFtE6Oa
   DJNk/gkGsnIWeXgJzVCgoWGiLyO73uXVk0YIZhWtivOt6FL0dAk/ttjIa
   uKZfNqYKxJRXaNVPXkuANc8zyHmockl8H9AvquJOz4jbpqcj7PMtORdW1
   yfUY17WmkD3SpX0+wjk1PaOR3rDRyDTTO3fmGqfciovR3GnijiEg7h/ct
   lMOSw10/Qnkx1fcmzrDHaQnpOilHubC692YdMcGaI2nZlYpiE0qwsttdE
   g==;
X-CSE-ConnectionGUID: Q5AQAKlNS5mNgB9vdISmLQ==
X-CSE-MsgGUID: TxjPqoxXSuqnGeNE6Ei4Zg==
X-IronPort-AV: E=McAfee;i="6800,10657,11474"; a="64492585"
X-IronPort-AV: E=Sophos;i="6.16,263,1744095600"; 
   d="scan'208";a="64492585"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2025 15:01:34 -0700
X-CSE-ConnectionGUID: H8kJ2BDiR82Tl1Pf/DZsLQ==
X-CSE-MsgGUID: q6PDnalMTyqbeK/er1j2aw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,263,1744095600"; 
   d="scan'208";a="151781356"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2025 15:01:34 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 24 Jun 2025 15:01:33 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 24 Jun 2025 15:01:33 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (40.107.93.87) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 24 Jun 2025 15:01:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=y2Wxas6HlzfYKH1ury59Nsbwt/TYmBNMG6JZ38dSRF52zKY6FNo6f5rEZBi4mLHsxQw0ud4kFsal5ywCk1eiTWXDXb+zJcN2DuCs/knHbw5dtvrvwrZGdBFArgm64MHOXnRWNPPj+M3hNnG5NSC56Opvxxu6L3lP0QkCGtTqUTtjienp0KEPAQ5G5QZEFS3TVjAjIYwDhQcRmHvl+ptvwGIlD/6zVxrAsDBrLBCizz19w/tMVXN9LnEe+zaSFW0nQGXAxm6DfrNAbbRpX03OyKZPd1DoIWcITJ7bL3ukF1SF2LhYwhB/n9KV04ut4wEjKyHCP2gXfIPoMkHWemAB8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7NtpqXtZx+O56lDk4gXyJSMyVlnzX7AB7Ix+jonz9r8=;
 b=UCJ0Y6hx7t39Tx2Ie1+RvHFiC7Cu6lnSfqBZZKXxYnyiwUqqXQy9FguR1ARbgO4PYdh27jq4DwIt3HYueAm1mpl1bjD3V1OM1RzEYnDGSL7f+CedE0y5Rcjog3cEMpOG5I9oojb27In3j7Fx3bM+l1M3Kc0bYdR5FrLwkU7qHyRXam/OqSZJh1Uqo276nkt026pCmF0RcKCobWlqWW8kj1KiXTm3kYXE1Kguectg0rhC9y0tQsUlvHyyAW/X6Gklo8i7BrzmO2L7yQG6d2aH+Z3p8jeYh5M+T4YMIB2T/6GopIrGs6d5q3UkUoOansBoS1Jjt2e1vmMoBcbGlLSBYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SA2PR11MB4937.namprd11.prod.outlook.com (2603:10b6:806:118::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.26; Tue, 24 Jun
 2025 22:00:56 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.8857.025; Tue, 24 Jun 2025
 22:00:56 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "ackerleytng@google.com" <ackerleytng@google.com>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>
CC: "quic_eberman@quicinc.com" <quic_eberman@quicinc.com>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "Du, Fan" <fan.du@intel.com>, "Hansen, Dave"
	<dave.hansen@intel.com>, "david@redhat.com" <david@redhat.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "tabba@google.com"
	<tabba@google.com>, "vbabka@suse.cz" <vbabka@suse.cz>, "Shutemov, Kirill"
	<kirill.shutemov@intel.com>, "michael.roth@amd.com" <michael.roth@amd.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"seanjc@google.com" <seanjc@google.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"Peng, Chao P" <chao.p.peng@intel.com>, "Weiny, Ira" <ira.weiny@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Annapurve, Vishal"
	<vannapurve@google.com>, "jroedel@suse.de" <jroedel@suse.de>, "Miao, Jun"
	<jun.miao@intel.com>, "Li, Zhiquan1" <zhiquan1.li@intel.com>,
	"pgonda@google.com" <pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 08/21] KVM: TDX: Increase/decrease folio ref for huge
 pages
Thread-Topic: [RFC PATCH 08/21] KVM: TDX: Increase/decrease folio ref for huge
 pages
Thread-Index: AQHb1Yuw8TDhKPA9uUiYAoJtWQa0+LPz2/CAgAozpACAB4/5gIAA7nmAgAAX8oCAAO6tAIAAjZiAgAAGKoCACG6bAIAA3+42gAGE44A=
Date: Tue, 24 Jun 2025 22:00:56 +0000
Message-ID: <c69ed125c25cd3b7f7400ed3ef9206cd56ebe3c9.camel@intel.com>
References: <aCVZIuBHx51o7Pbl@yzhao56-desk.sh.intel.com>
	 <diqzfrgfp95d.fsf@ackerleytng-ctop.c.googlers.com>
	 <aEEEJbTzlncbRaRA@yzhao56-desk.sh.intel.com>
	 <CAGtprH_Vj=KS0BmiX=P6nUTdYeAZhNEyjrRFXVK0sG=k4gbBMg@mail.gmail.com>
	 <aE/q9VKkmaCcuwpU@yzhao56-desk.sh.intel.com>
	 <9169a530e769dea32164c8eee5edb12696646dfb.camel@intel.com>
	 <aFDHF51AjgtbG8Lz@yzhao56-desk.sh.intel.com>
	 <6afbee726c4d8d95c0d093874fb37e6ce7fd752a.camel@intel.com>
	 <aFIGFesluhuh2xAS@yzhao56-desk.sh.intel.com>
	 <0072a5c0cf289b3ba4d209c9c36f54728041e12d.camel@intel.com>
	 <aFkeBtuNBN1RrDAJ@yzhao56-desk.sh.intel.com>
	 <draft-diqzh606mcz0.fsf@ackerleytng-ctop.c.googlers.com>
	 <diqzy0tikran.fsf@ackerleytng-ctop.c.googlers.com>
In-Reply-To: <diqzy0tikran.fsf@ackerleytng-ctop.c.googlers.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SA2PR11MB4937:EE_
x-ms-office365-filtering-correlation-id: 79ff781c-1fb6-4537-14bd-08ddb36a98c5
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?OWd3aUNIOXRmZ2JWVUp1WlBxaTdFamxKY1k0emdFSzJBd2gxdGZvck51eGhH?=
 =?utf-8?B?Slh2RjdIWWQxcnlGSEx1S1VJNE85Q1BKQ2Q4N2ZCWWxKK0p0V2orbkUrbXRk?=
 =?utf-8?B?QzF2eTNsWkwwOURMeUtOM0FJYW10NDh6WU53dk1teHJDMy8xOHlsRFFHNkFD?=
 =?utf-8?B?M0ZOUjk5Ly9SY0NHaGdweGxLemExS0NLZHBJejJ2ZXpmVXMxTGJqdE10Ykw1?=
 =?utf-8?B?YlRxc1dGd2ZFK3hQVU43RXcvRnZDY2loRlA1Y3Y4UEpXeUlqT2JUZjFHdUw0?=
 =?utf-8?B?R0xPOEU4NWFBMVlnem8vczZVTzhFbnI0QjZtb3FKVmpYclNmTjhza1BaNTM3?=
 =?utf-8?B?dnNZa1AyV1YyV0JUUyt5NU9abU8rQkxOejRXc3NXREppbWJiaWhCLzMzZVc3?=
 =?utf-8?B?UVgreWlidEJkeVhkV3VjakwxNFE1R3c4RmlYcXlNUU9kMEpLd3JhL0tSaTM0?=
 =?utf-8?B?NkJmVytiUjM0bDI2bll6VXY2eUdBdFlzenlxYW0yQmk0QWE4a2NpRFM5VlU1?=
 =?utf-8?B?SjF4ajY1TExVWjN6czNDTEZyT2JhK1djOUp3RWJjeTlOeXFpUlJyV1VqQmlM?=
 =?utf-8?B?bXplcDRNUDE5cGhjTXA3Q3B2c29SVWtSTDQ1bnlTMTVkMkZXZ0tWVVBFUkZZ?=
 =?utf-8?B?MjdVNWdzSmc3dTB3eWlJekhWdnFsTTRzbVA3SUFIUkcvTmZjN2wxZ3U5Njh4?=
 =?utf-8?B?UXRRU0tYay9YakQrM21ER2VUdUxmWlFneHIvYS9JaFBGSmhRZUZkQ3NiSGd5?=
 =?utf-8?B?NisraEZtUHRaRjZqL29jd245ckNUaFBadFdVVllpblFIWFZ2Vk0yUzh3MGhM?=
 =?utf-8?B?NHk5WXBsTmJKNWxxeUxuWG5vbmdXN3BNa2xxNG9WaXJWUjU1VFlEVTJPZjVL?=
 =?utf-8?B?WHVCMG50QkdoVFJvLzBqTThGVXcvSDlOQjFGT2FheHdSc2g5U1VOL1ZZS2Zz?=
 =?utf-8?B?dFYzdCsxbVFCSHpYQ1R1R1JBY0NMVHZnUWtOaFcrWitCVW1ObVNEOThLaEJj?=
 =?utf-8?B?SzFWc3Y2aWlxY3hXOWpIK0JSQzdJWlV6aHF1aHhubDJoTzVyTWtlR3d5cFRm?=
 =?utf-8?B?aWFYR1AxR0JtZHlta2Fmc0FGeXlsTXRYbWh4dW9ZOXF0UTVrZmhwVW1nYlFW?=
 =?utf-8?B?TjNicUxKVGhheU1UcjdXRGhkcEdQWFg1d3JkTk16VFM4RS9neHVtMUtQNmN5?=
 =?utf-8?B?M01kQmM3YmFGTmFSL25rNGd1d21tbFVqR3FCQW5jMTVMQ1RrSHlPM3dYTjYz?=
 =?utf-8?B?Z0lHYWlqTnV3TGVrYnp0NFpseVlrVkh4bHk5aU1HV210Z3V2RHRVU2svcHpz?=
 =?utf-8?B?UlFwTWUyei9VT21oUnhhNlV1MW0xSGF2aVNtZDhBUjRlaFc2Q1BtcTZKN0x2?=
 =?utf-8?B?VVhDeXlwVXpKNkFVajlaWVB3VjZOYktjT0UyekgxTEVkQklCSlVJMVBTc3F0?=
 =?utf-8?B?dUFpMzlPWnZ1WXQyRGlJS0NNRmdsTE5malZpalkrYkF1Z0U0NUVaVnNXSDAx?=
 =?utf-8?B?NWNqNHF4SWRFZXVXazJOWml5c0NVbVlFNXcvTTJyQ21wMmRGcll6REE1cEli?=
 =?utf-8?B?T2xJVnBzSS9MamhZNjBYZjJqUWVPMmxOSWpsencvYXdoTTIycGNDcjRhdE96?=
 =?utf-8?B?VzJ2MnlhV0tZRktNclFnMG1wM2VKQVNzbytzSVM5V1lzazZnK1dHOXB4ZkRE?=
 =?utf-8?B?blpJdHk4dExqYXNwRXVoOGRveE1teVYrLzRQWjhFVzFtS3U0TndNUkt6RFR6?=
 =?utf-8?B?WXFMWUNQT2U1ak5xTHNjYjlaQWJQWVkvU253dE0zOW1sTHhXSFpUcGZzbWVn?=
 =?utf-8?B?clFSRkM5V1c3VWJRTzkzcWJxTDhKam1NNEhRdzFILzZUM0dVUzdwa2pWbkh0?=
 =?utf-8?B?cGozeTJnbEU0SjlKN1dpU28vRWh0KzRJNGNTeUI4VG9sTkdRNkdmSllrYk5C?=
 =?utf-8?B?VzJuU1hMbk42SUtMeFh1TEdGdldGd0d5NDErVjBadnRxNTI0blEvamtHSEZS?=
 =?utf-8?Q?wVH/BnoahDqOzXFazDxy6MbmibkV1Q=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UC9wTzlHZng3SUZ1N3NJU0JlUXhtTE9OTlQrakFVdkNnWEpLbnNPVWxORUE3?=
 =?utf-8?B?dTNER1M3WERzZXVadHl6L0VWdkpONnA0WUJBaFl4OFQxOVRnK3Zqd1JmaUtX?=
 =?utf-8?B?N29KZnRoeVFqbHVXbGg2YUNuUTltei9mQjF2Zk9QUlB2Mnp4L2x5QkN4dGJz?=
 =?utf-8?B?dkdYY3g3RVY1TzFkWDhLdmkxcDVrTE1KUVNOOVdLbWtzc1Y1ZDBKeTlhQ0RQ?=
 =?utf-8?B?Tm1kN0swMXQwUzIxU09Nd2JaUTdiU3VMcjRFMmNXbFZLWVZ5RVN0MElJTlNy?=
 =?utf-8?B?SnBZREcrWExiaVNPT3dSRXYvK1pZRmVUdmFnamc3czhQUW1KYkdzcTcrNGI1?=
 =?utf-8?B?bTZOZm1icVRBM2xqa2tyNjlWK0piaTltR1dYQXI4ZFpGc1VjNDdJL2pKWmVY?=
 =?utf-8?B?N0M0RWlXTlQyeXFESE1YYWgxQnZTQlNEZXlBeXJnUFZVeTZMWWwySkNHWExy?=
 =?utf-8?B?OGYwUWlLZVFvZ3F4SUo4RjVkWGJHVHZqZlMxMHVwT1VmWDlqUjc1dEIzQUxs?=
 =?utf-8?B?emFOMXpFd3NaLzVYYk5nbDJqc2ZLdmdGVmNrYXI3NnhldlVhQjZpWlFPZWZm?=
 =?utf-8?B?c1Z1aTVxOTVXeURRakNIQ3haZ0xKR1BSaDBmNXlwcitEWnFueDlnTmdVWHoy?=
 =?utf-8?B?NVF6TW5zSjV5RXZRaldSNTJFeWpUbUU2VFlmTkVidThJc3dNWFFQL242MWtK?=
 =?utf-8?B?R3VuUklCMXRpeldydXlybGZyZFN2L2VRWWtCQlJERUI4b3hhR2w1OVIwS0Vr?=
 =?utf-8?B?TFUvT2tINkhRVGVxTk1Jc2k3eTFDdUxIeHhjV1lVc3ZkOE1xTzBoZHpadkJz?=
 =?utf-8?B?dG12MnBhZlJoSVhjb2U3OWN4bFFXSEFUdGNqS21Yc0QrYlJsaFRpdHorOXRG?=
 =?utf-8?B?Z2JtYUZuYXJLZjJ6M3B5cjIvQmpnZEVaZ2ZFVU85TFlWSGU5cThZOVVrQXBF?=
 =?utf-8?B?RnJyWHpDTWVsQ0Q4YVVBYXVoVExjdDM2amZ5R1QvdHlHeWs3bGc2Q0JkMVRP?=
 =?utf-8?B?V3hpM1B6eGh4T2dLcDFKc1RiWko5NUNybThyNEtLV3ZWbkpPYlNUTFBTYnE1?=
 =?utf-8?B?VDN3UUNLRTVZc2tHcmN3akNxNjNaNEJkbE5KN1RmVnNFR3lCajFyZHgzd1Ey?=
 =?utf-8?B?YnJCN2dSb2FkU3NiTld1eEdLaTNPQW9neHRXb0dxM2o5WEhvdTRpNnNubEZD?=
 =?utf-8?B?OHFPckNveFlhVXNNeW5Ka0NBQ01mK3M0aW1rMndMYXZHajFxQ2ZodXY1SUw3?=
 =?utf-8?B?b0RaUkJKbWhaaTJCNktJS3c3aGZEblZKNWV0WnE1dUxmaWcxYjNuRG9tditZ?=
 =?utf-8?B?eVlMRXVwYUw2V2hvTDVkS0RmZXVkWm1KYS9yUmRiWkpzUGpMOXhBbXBpb0do?=
 =?utf-8?B?UThlU3hWekluZGdoTHJUR0FBanRKNE5kcmhDaUljLzJnbFZPYTFaTDdNNzdQ?=
 =?utf-8?B?TXZ1TTMwaVgzTkZhcEh0cUlNM1VCUHBNYXNEeng4TjFlUzlDeEE0Nm12SVFZ?=
 =?utf-8?B?Z3pSOTVuQ0trNlVyaHg0UjFJendsTDRHTlhzNG1sUUNPS2FGcVovMXRwTVUv?=
 =?utf-8?B?TGhtOWMzU2orb3lWVkhQWHhFb0IySWFsOHJyN3hUcnBuY01kSnlhMGVPUDY0?=
 =?utf-8?B?UGJ4OW9SbVArS3RFTUU4L0QyU0N1RHYvZWRoOHBzZjRDUWtGT0d0ZEd1NThI?=
 =?utf-8?B?SFhGdXhFS040bjg0aFl6MXBmZmp4TkYzR0tIY1dZa0Q3R2VZbENvOE01TnVV?=
 =?utf-8?B?L3laL1BTL3JmaWNDRHYvNUlXVlRONDRlbVhUb29VQTlTVWVJdFFSYlMvRFF3?=
 =?utf-8?B?emNEUHpZRDZtcUVNK2d0UGVjb0dYYWpad3lpZFhydjhaNzlCcmVVck9TQjlm?=
 =?utf-8?B?eHMxM21XSnh0YzQyaE9waE53Uy8zWUsybWx1YmJETEQrSlM2WTFQYTV4QnZQ?=
 =?utf-8?B?aTgzWFQrd0dVeVl1d3ZaZXZ4M0FnSkZKZ3pOcWhrNkRwMDRPcTlyVHQ3bXlD?=
 =?utf-8?B?K3FHRjZpbVgrdC94L3M5YW4wNVF1bGRqT1JFbWMxZ2NmeDlrNFRPb3p0eEdE?=
 =?utf-8?B?L2tJVmZjbHhjSVFleFlxaUt1TmpZUGFUd05VRkVWVWFLWTBBekxWT1hzaHZz?=
 =?utf-8?B?MFdIdkU5dmEzT1Z0T0JqN09CUHZsdUluUmJqQ1hPaWo4QXZTaHJpcmVFREFN?=
 =?utf-8?Q?2fsJp+21DY8+kJSOyV0P8YU=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9F1CC7A6CF48FD46B7D5A2560963F47B@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 79ff781c-1fb6-4537-14bd-08ddb36a98c5
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jun 2025 22:00:56.7222
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: P5JhuUwbeQxUerugROIPMGsvUbnMKdcd80En36G4lE1ASn451mA62zSfnTswvNKY5UzS+1YJOKF4Ym7ETk5bHfrmHHWPZStM0bpeK1WvKtY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4937
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI1LTA2LTIzIGF0IDE1OjQ4IC0wNzAwLCBBY2tlcmxleSBUbmcgd3JvdGU6DQo+
IExldCBtZSB0cnkgYW5kIHN1bW1hcml6ZSB0aGUgY3VycmVudCBzdGF0ZSBvZiB0aGlzIGRpc2N1
c3Npb246DQo+IA0KPiBUb3BpYyAxOiBEb2VzIFREWCBuZWVkIHRvIHNvbWVob3cgaW5kaWNhdGUg
dGhhdCBpdCBpcyB1c2luZyBhIHBhZ2U/DQo+IA0KPiBUaGlzIHBhdGNoIHNlcmllcyB1c2VzIHJl
ZmNvdW50cyB0byBpbmRpY2F0ZSB0aGF0IFREWCBpcyB1c2luZyBhIHBhZ2UsDQo+IGJ1dCB0aGF0
IGNvbXBsaWNhdGVzIHByaXZhdGUtdG8tc2hhcmVkIGNvbnZlcnNpb25zLg0KPiANCj4gRHVyaW5n
IGEgcHJpdmF0ZS10by1zaGFyZWQgY29udmVyc2lvbiwgZ3Vlc3RfbWVtZmQgYXNzdW1lcyB0aGF0
DQo+IGd1ZXN0X21lbWZkIGlzIHRydXN0ZWQgdG8gbWFuYWdlIHByaXZhdGUgbWVtb3J5LiBURFgg
YW5kIG90aGVyIHVzZXJzDQo+IHNob3VsZCB0cnVzdCBndWVzdF9tZW1mZCB0byBrZWVwIHRoZSBt
ZW1vcnkgYXJvdW5kLg0KPiANCj4gWWFuJ3MgcG9zaXRpb24gaXMgdGhhdCBob2xkaW5nIGEgcmVm
Y291bnQgaXMgaW4gbGluZSB3aXRoIGhvdyBJT01NVQ0KPiB0YWtlcyBhIHJlZmNvdW50IHdoZW4g
YSBwYWdlIGlzIG1hcHBlZCBpbnRvIHRoZSBJT01NVSBbMV0uDQo+IA0KPiBZYW4gaGFkIGFub3Ro
ZXIgc3VnZ2VzdGlvbiwgd2hpY2ggaXMgdG8gaW5kaWNhdGUgdXNpbmcgYSBwYWdlIGZsYWcgWzJd
Lg0KPiANCj4gSSB0aGluayB3ZSdyZSBpbiBhZ3JlZW1lbnQgdGhhdCB3ZSBkb24ndCB3YW50IHRv
IGhhdmUgVERYIGhvbGQgYQ0KPiByZWZjb3VudCB3aGlsZSB0aGUgcGFnZSBpcyBtYXBwZWQgaW50
byB0aGUgU2VjdXJlIEVQVHMsIGJ1dCB0YWtpbmcgYQ0KPiBzdGVwIGJhY2ssIGRvIHdlIHJlYWxs
eSBuZWVkIHRvIGluZGljYXRlIChhdCBhbGwpIHRoYXQgVERYIGlzIHVzaW5nIGENCj4gcGFnZT8N
Cj4gDQo+IEluIFszXSBZYW4gc2FpZA0KPiANCj4gPiBJZiBURFggZG9lcyBub3QgaG9sZCBhbnkg
cmVmY291bnQsIGd1ZXN0X21lbWZkIGhhcyB0byBrbm93IHRoYXQgd2hpY2gNCj4gPiBwcml2YXRl
DQo+ID4gcGFnZSBpcyBzdGlsbCBtYXBwZWQuIE90aGVyd2lzZSwgdGhlIHBhZ2UgbWF5IGJlIHJl
LWFzc2lnbmVkIHRvIG90aGVyDQo+ID4ga2VybmVsDQo+ID4gY29tcG9uZW50cyB3aGlsZSBpdCBt
YXkgc3RpbGwgYmUgbWFwcGVkIGluIHRoZSBTLUVQVC4NCj4gDQo+IElmIHRoZSBwcml2YXRlIHBh
Z2UgaXMgbWFwcGVkIGZvciByZWd1bGFyIFZNIHVzZSBhcyBwcml2YXRlIG1lbW9yeSwNCj4gZ3Vl
c3RfbWVtZmQgaXMgbWFuYWdpbmcgdGhhdCwgYW5kIHRoZSBzYW1lIHBhZ2Ugd2lsbCBub3QgYmUg
cmUtYXNzaWduZWQNCj4gdG8gYW55IG90aGVyIGtlcm5lbCBjb21wb25lbnQuIGd1ZXN0X21lbWZk
IGRvZXMgaG9sZCByZWZjb3VudHMgaW4NCj4gZ3Vlc3RfbWVtZmQncyBmaWxlbWFwLg0KPiANCj4g
SWYgdGhlIHByaXZhdGUgcGFnZSBpcyBzdGlsbCBtYXBwZWQgYmVjYXVzZSB0aGVyZSB3YXMgYW4g
dW5tYXBwaW5nDQo+IGZhaWx1cmUsIHdlIGNhbiBkaXNjdXNzIHRoYXQgc2VwYXJhdGVseSB1bmRl
ciBlcnJvciBoYW5kbGluZyBpbiBUb3BpYyAyLg0KPiANCj4gV2l0aCB0aGlzLCBjYW4gSSBjb25m
aXJtIHRoYXQgd2UgYXJlIGluIGFncmVlbWVudCB0aGF0IFREWCBkb2VzIG5vdCBuZWVkDQo+IHRv
IGluZGljYXRlIHRoYXQgaXQgaXMgdXNpbmcgYSBwYWdlLCBhbmQgY2FuIHRydXN0IGd1ZXN0X21l
bWZkIHRvIGtlZXANCj4gdGhlIHBhZ2UgYXJvdW5kIGZvciB0aGUgVk0/DQoNCk1pbm9yIGNvcnJl
Y3Rpb24gaGVyZS4gWWFuIHdhcyBjb25jZXJuZWQgYWJvdXQgKmJ1Z3MqIGhhcHBlbmluZyB3aGVu
IGZyZWVpbmcNCnBhZ2VzIHRoYXQgYXJlIGFjY2lkZW50YWxseSBzdGlsbCBtYXBwZWQgaW4gdGhl
IFMtRVBULiBNeSBvcGluaW9uIGlzIHRoYXQgdGhpcw0KaXMgbm90IGVzcGVjaWFsbHkgcmlza3kg
dG8gaGFwcGVuIGhlcmUgdnMgb3RoZXIgc2ltaWxhciBwbGFjZXMsIGJ1dCBpdCBjb3VsZCBiZQ0K
aGVscGZ1bCBpZiB0aGVyZSB3YXMgYSB3YXkgdG8gY2F0Y2ggc3VjaCBidWdzLiBUaGUgcGFnZSBm
bGFnLCBvciBwYWdlX2V4dA0KZGlyZWN0aW9uIGNhbWUgb3V0IG9mIGEgZGlzY3Vzc2lvbiB3aXRo
IERhdmUgYW5kIEtpcmlsbC4gSWYgaXQgY291bGQgcnVuIGFsbCB0aGUNCnRpbWUgdGhhdCB3b3Vs
ZCBiZSBncmVhdCwgYnV0IGlmIG5vdCBhIGRlYnVnIGNvbmZpZyBjb3VsZCBiZSBzdWZmaWNpZW50
LiBGb3INCmV4YW1wbGUgbGlrZSBDT05GSUdfUEFHRV9UQUJMRV9DSEVDSy4gSXQgZG9lc24ndCBu
ZWVkIHRvIHN1cHBvcnQgdm1lbW1hcA0Kb3B0aW1pemF0aW9ucyBiZWNhdXNlIHRoZSBkZWJ1ZyBj
aGVja2luZyBkb2Vzbid0IG5lZWQgdG8gcnVuIGFsbCB0aGUgdGltZS4NCk92ZXJoZWFkIGZvciBk
ZWJ1ZyBzZXR0aW5ncyBpcyB2ZXJ5IG5vcm1hbC4NCg0KPiANCj4gVG9waWMgMjogSG93IHRvIGhh
bmRsZSB1bm1hcHBpbmcvc3BsaXR0aW5nIGVycm9ycyBhcmlzaW5nIGZyb20gVERYPw0KPiANCj4g
UHJldmlvdXNseSBJIHdhcyBpbiBmYXZvciBvZiBoYXZpbmcgdW5tYXAoKSByZXR1cm4gYW4gZXJy
b3IgKFJpY2sNCj4gc3VnZ2VzdGVkIGRvaW5nIGEgUE9DLCBhbmQgaW4gYSBtb3JlIHJlY2VudCBl
bWFpbCBSaWNrIGFza2VkIGZvciBhDQo+IGRpZmZzdGF0KSwgYnV0IFZpc2hhbCBhbmQgSSB0YWxr
ZWQgYWJvdXQgdGhpcyBhbmQgbm93IEkgYWdyZWUgaGF2aW5nDQo+IHVubWFwcGluZyByZXR1cm4g
YW4gZXJyb3IgaXMgbm90IGEgZ29vZCBhcHByb2FjaCBmb3IgdGhlc2UgcmVhc29ucy4NCg0KT2ss
IGxldCdzIGNsb3NlIHRoaXMgb3B0aW9uIHRoZW4uDQoNCj4gDQo+IDEuIFVubWFwcGluZyB0YWtl
cyBhIHJhbmdlLCBhbmQgd2l0aGluIHRoZSByYW5nZSB0aGVyZSBjb3VsZCBiZSBtb3JlDQo+IMKg
wqAgdGhhbiBvbmUgdW5tYXBwaW5nIGVycm9yLiBJIHdhcyBwcmV2aW91c2x5IHRoaW5raW5nIHRo
YXQgdW5tYXAoKQ0KPiDCoMKgIGNvdWxkIHJldHVybiAwIGZvciBzdWNjZXNzIGFuZCB0aGUgZmFp
bGVkIFBGTiBvbiBlcnJvci4gUmV0dXJuaW5nIGENCj4gwqDCoCBzaW5nbGUgUEZOIG9uIGVycm9y
IGlzIG9rYXktaXNoIGJ1dCBpZiB0aGVyZSBhcmUgbW9yZSBlcnJvcnMgaXQgY291bGQNCj4gwqDC
oCBnZXQgY29tcGxpY2F0ZWQuDQo+IA0KPiDCoMKgIEFub3RoZXIgZXJyb3IgcmV0dXJuIG9wdGlv
biBjb3VsZCBiZSB0byByZXR1cm4gdGhlIGZvbGlvIHdoZXJlIHRoZQ0KPiDCoMKgIHVubWFwcGlu
Zy9zcGxpdHRpbmcgaXNzdWUgaGFwcGVuZWQsIGJ1dCB0aGF0IHdvdWxkIG5vdCBiZQ0KPiDCoMKg
IHN1ZmZpY2llbnRseSBwcmVjaXNlLCBzaW5jZSBhIGZvbGlvIGNvdWxkIGJlIGxhcmdlciB0aGFu
IDRLIGFuZCB3ZQ0KPiDCoMKgIHdhbnQgdG8gdHJhY2sgZXJyb3JzIGFzIHByZWNpc2VseSBhcyB3
ZSBjYW4gdG8gcmVkdWNlIG1lbW9yeSBsb3NzIGR1ZQ0KPiDCoMKgIHRvIGVycm9ycy4NCj4gDQo+
IDIuIFdoYXQgSSB0aGluayBZYW4gaGFzIGJlZW4gdHJ5aW5nIHRvIHNheTogdW5tYXAoKSByZXR1
cm5pbmcgYW4gZXJyb3INCj4gwqDCoCBpcyBub24tc3RhbmRhcmQgaW4gdGhlIGtlcm5lbC4NCj4g
DQo+IEkgdGhpbmsgKDEpIGlzIHRoZSBkZWFsYnJlYWtlciBoZXJlIGFuZCB0aGVyZSdzIG5vIG5l
ZWQgdG8gZG8gdGhlDQo+IHBsdW1iaW5nIFBPQyBhbmQgZGlmZnN0YXQuDQo+IA0KPiBTbyBJIHRo
aW5rIHdlJ3JlIGFsbCBpbiBzdXBwb3J0IG9mIGluZGljYXRpbmcgdW5tYXBwaW5nL3NwbGl0dGlu
ZyBpc3N1ZXMNCj4gd2l0aG91dCByZXR1cm5pbmcgYW55dGhpbmcgZnJvbSB1bm1hcCgpLCBhbmQg
dGhlIGRpc2N1c3NlZCBvcHRpb25zIGFyZQ0KPiANCj4gYS4gUmVmY291bnRzOiB3b24ndCB3b3Jr
IC0gbW9zdGx5IGRpc2N1c3NlZCBpbiB0aGlzIChzdWItKXRocmVhZA0KPiDCoMKgIFszXS4gVXNp
bmcgcmVmY291bnRzIG1ha2VzIGl0IGltcG9zc2libGUgdG8gZGlzdGluZ3Vpc2ggYmV0d2Vlbg0K
PiDCoMKgIHRyYW5zaWVudCByZWZjb3VudHMgYW5kIHJlZmNvdW50cyBkdWUgdG8gZXJyb3JzLg0K
PiANCj4gYi4gUGFnZSBmbGFnczogd29uJ3Qgd29yayB3aXRoL2Nhbid0IGJlbmVmaXQgZnJvbSBI
Vk8uDQoNCkFzIGFib3ZlLCB0aGlzIHdhcyBmb3IgdGhlIHB1cnBvc2Ugb2YgY2F0Y2hpbmcgYnVn
cywgbm90IGZvciBndWVzdG1lbWZkIHRvDQpsb2dpY2FsbHkgZGVwZW5kIG9uIGl0Lg0KDQo+IA0K
PiBTdWdnZXN0aW9ucyBzdGlsbCBpbiB0aGUgcnVubmluZzoNCj4gDQo+IGMuIEZvbGlvIGZsYWdz
IGFyZSBub3QgcHJlY2lzZSBlbm91Z2ggdG8gaW5kaWNhdGUgd2hpY2ggcGFnZSBhY3R1YWxseQ0K
PiDCoMKgIGhhZCBhbiBlcnJvciwgYnV0IHRoaXMgY291bGQgYmUgc3VmZmljaWVudCBpZiB3ZSdy
ZSB3aWxsaW5nIHRvIGp1c3QNCj4gwqDCoCB3YXN0ZSB0aGUgcmVzdCBvZiB0aGUgaHVnZSBwYWdl
IG9uIHVubWFwcGluZyBlcnJvci4NCg0KRm9yIGEgc2NlbmFyaW8gb2YgVERYIG1vZHVsZSBidWcs
IGl0IHNlZW1zIG9rIHRvIG1lLg0KDQo+IA0KPiBkLiBGb2xpbyBmbGFncyB3aXRoIGZvbGlvIHNw
bGl0dGluZyBvbiBlcnJvci4gVGhpcyBtZWFucyB0aGF0IG9uDQo+IMKgwqAgdW5tYXBwaW5nL1Nl
Y3VyZSBFUFQgUFRFIHNwbGl0dGluZyBlcnJvciwgd2UgaGF2ZSB0byBzcGxpdCB0aGUNCj4gwqDC
oCAobGFyZ2VyIHRoYW4gNEspIGZvbGlvIHRvIDRLLCBhbmQgdGhlbiBzZXQgYSBmbGFnIG9uIHRo
ZSBzcGxpdCBmb2xpby4NCj4gDQo+IMKgwqAgVGhlIGlzc3VlIEkgc2VlIHdpdGggdGhpcyBpcyB0
aGF0IHNwbGl0dGluZyBwYWdlcyB3aXRoIEhWTyBhcHBsaWVkDQo+IMKgwqAgbWVhbnMgZG9pbmcg
YWxsb2NhdGlvbnMsIGFuZCBpbiBhbiBlcnJvciBzY2VuYXJpbyB0aGVyZSBtYXkgbm90IGJlDQo+
IMKgwqAgbWVtb3J5IGxlZnQgdG8gc3BsaXQgdGhlIHBhZ2VzLg0KPiANCj4gZS4gU29tZSBvdGhl
ciBkYXRhIHN0cnVjdHVyZSBpbiBndWVzdF9tZW1mZCwgc2F5LCBhIGxpbmtlZCBsaXN0LCBhbmQg
YQ0KPiDCoMKgIGZ1bmN0aW9uIGxpa2Uga3ZtX2dtZW1fYWRkX2Vycm9yX3BmbihzdHJ1Y3QgcGFn
ZSAqcGFnZSkgdGhhdCB3b3VsZA0KPiDCoMKgIGxvb2sgdXAgdGhlIGd1ZXN0X21lbWZkIGlub2Rl
IGZyb20gdGhlIHBhZ2UgYW5kIGFkZCB0aGUgcGFnZSdzIHBmbiB0bw0KPiDCoMKgIHRoZSBsaW5r
ZWQgbGlzdC4NCj4gDQo+IMKgwqAgRXZlcnl3aGVyZSBpbiBndWVzdF9tZW1mZCB0aGF0IGRvZXMg
dW5tYXBwaW5nL3NwbGl0dGluZyB3b3VsZCB0aGVuDQo+IMKgwqAgY2hlY2sgdGhpcyBsaW5rZWQg
bGlzdCB0byBzZWUgaWYgdGhlIHVubWFwcGluZy9zcGxpdHRpbmcNCj4gwqDCoCBzdWNjZWVkZWQu
DQo+IA0KPiDCoMKgIEV2ZXJ5d2hlcmUgaW4gZ3Vlc3RfbWVtZmQgdGhhdCBhbGxvY2F0ZXMgcGFn
ZXMgd2lsbCBhbHNvIGNoZWNrIHRoaXMNCj4gwqDCoCBsaW5rZWQgbGlzdCB0byBtYWtlIHN1cmUg
dGhlIHBhZ2VzIGFyZSBmdW5jdGlvbmFsLg0KPiANCj4gwqDCoCBXaGVuIGd1ZXN0X21lbWZkIHRy
dW5jYXRlcywgaWYgdGhlIHBhZ2UgYmVpbmcgdHJ1bmNhdGVkIGlzIG9uIHRoZQ0KPiDCoMKgIGxp
c3QsIHJldGFpbiB0aGUgcmVmY291bnQgb24gdGhlIHBhZ2UgYW5kIGxlYWsgdGhhdCBwYWdlLg0K
DQpJIHRoaW5rIHRoaXMgaXMgYSBmaW5lIG9wdGlvbi4NCg0KPiANCj4gZi4gQ29tYmluYXRpb24g
b2YgYyBhbmQgZSwgc29tZXRoaW5nIHNpbWlsYXIgdG8gSHVnZVRMQidzDQo+IMKgwqAgZm9saW9f
c2V0X2h1Z2V0bGJfaHdwb2lzb24oKSwgd2hpY2ggc2V0cyBhIGZsYWcgQU5EIGFkZHMgdGhlIHBh
Z2VzIGluDQo+IMKgwqAgdHJvdWJsZSB0byBhIGxpbmtlZCBsaXN0IG9uIHRoZSBmb2xpby4NCj4g
DQo+IGcuIExpa2UgZiwgYnV0IGJhc2ljYWxseSB0cmVhdCBhbiB1bm1hcHBpbmcgZXJyb3IgYXMg
aGFyZHdhcmUgcG9pc29uaW5nLg0KPiANCj4gSSdtIGtpbmQgb2YgaW5jbGluZWQgdG93YXJkcyBn
LCB0byBqdXN0IHRyZWF0IHVubWFwcGluZyBlcnJvcnMgYXMNCj4gSFdQT0lTT04gYW5kIGJ1eWlu
ZyBpbnRvIGFsbCB0aGUgSFdQT0lTT04gaGFuZGxpbmcgcmVxdWlyZW1lbnRzLiBXaGF0IGRvDQo+
IHlhbGwgdGhpbms/IENhbiBhIFREWCB1bm1hcHBpbmcgZXJyb3IgYmUgY29uc2lkZXJlZCBhcyBt
ZW1vcnkgcG9pc29uaW5nPw0KDQpXaGF0IGRvZXMgSFdQT0lTT04gYnJpbmcgb3ZlciByZWZjb3Vu
dGluZyB0aGUgcGFnZS9mb2xpbyBzbyB0aGF0IGl0IG5ldmVyDQpyZXR1cm5zIHRvIHRoZSBwYWdl
IGFsbG9jYXRvcj8gV2UgYXJlIGJ1Z2dpbmcgdGhlIFREIGluIHRoZXNlIGNhc2VzLiBPaGhoLi4u
IElzDQp0aGlzIGFib3V0IHRoZSBjb2RlIHRvIGFsbG93IGdtZW0gZmRzIHRvIGJlIGhhbmRlZCB0
byBuZXcgVk1zPw0K

