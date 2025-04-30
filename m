Return-Path: <kvm+bounces-44936-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 19B2EAA50A4
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 17:44:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 81D8246632B
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 15:44:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5DF3E2609C3;
	Wed, 30 Apr 2025 15:44:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="O78epCKr"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFF4425B660
	for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 15:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746027862; cv=fail; b=uR7e4lbU28VbkickkIhd8ryhkm0yYni6CfCnCvlwidpBCQeUCyexxLibiZMG8q91gSLM0NbkHkygN3jvAbKUSNRg+ktcv+Eu0He/GfKRw9TxhedOMbvhB4QT8UtTyYfTHBKLDnCuoxkPN95VovIE4nf7AJ2IZ0mLHNmPBbcrjTY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746027862; c=relaxed/simple;
	bh=zAZA4UgZNWoimfi4iKDi1ZNXqYc7bQk9vA3XeszCm4s=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=NgkKtPd6GDpVmdgbqt5Nl5daNHnW5ra65cZ2Yhs/ISq5E6oExSSFsZcXcvfuhR4XvwK/1KAjAKqCwkEQihvDcy8gs4HlQtNGnDcFRQ1kq2/Q0Svq/31JXhbwkz4Gv2a+1cu7efbhiizJngD4gAOpiCTiegPRFS78TNwDueVw5+I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=O78epCKr; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746027860; x=1777563860;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=zAZA4UgZNWoimfi4iKDi1ZNXqYc7bQk9vA3XeszCm4s=;
  b=O78epCKrVB7j6WhOozW4iQm3tV97iySJJgyMJ7amy9XH3CQG2WwrS8QH
   PK5rUfoMqTmF5MzBes8ZR5Ee4+ynUaXgQZIh9QF5oc0Yq0nyXjYiXwOam
   6ZEC7bu0mGD/piBXFqR5hAKptxGOEpst25Lu/V+vweLbl23x5KuoC75Xs
   M0doU+JprPELVA3bHnuyCGfJ/ruRp0I+bb+/9Uxq9aIuelOUmne8lvqtN
   UGvKAC2j8tmpez6vnJEQfy2dkV9KcpkkmKizugCbWxp9nYnyZOgNNyoG6
   hODF3QUwg1fo2nKt7bgcyjjpn+MsRHEZ8Y5WK1pOKPOOJlL6MDXSyJ2rQ
   w==;
X-CSE-ConnectionGUID: hIjNr92PQQWUwx/YKeDE9g==
X-CSE-MsgGUID: VGPWWSndR7yI/TI5620Q9g==
X-IronPort-AV: E=McAfee;i="6700,10204,11419"; a="47603750"
X-IronPort-AV: E=Sophos;i="6.15,251,1739865600"; 
   d="scan'208";a="47603750"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2025 08:44:20 -0700
X-CSE-ConnectionGUID: VTkae4s4SSWdgOFRwqmVIw==
X-CSE-MsgGUID: VnBPOkCPQ+Oxnq7aBBYeXQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,251,1739865600"; 
   d="scan'208";a="134097457"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2025 08:44:20 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Wed, 30 Apr 2025 08:44:19 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Wed, 30 Apr 2025 08:44:19 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.43) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Wed, 30 Apr 2025 08:44:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pA41jjzulT57NaxM4Vp/RzZ6fA/vTYST3eNOvj1E7ZchzzSXjF4fx5oD5djGSltIYoQ/2QrbtiCGjulvB34s4Thx7E3ByGme8d0ry0d/wREEDTD0lo02eUyy08sMIk1VI7K8A68wkICp6bAm5H6SiT8nK78S/jGx1Aw5ncOJKOGfv3L0RLt/DhOlw0ifn68zVBA9AvBLCgKDEwEDIN9cOd+aftHoSMhAVXCKjecv9NavAftoV6KNxoSGa34myngOmeMkJ4HKncqNQyJo+0gfN7PxN4ogHczN2F5m5GW5ZUFKcXruW0N8bNHdR+DtUlT0fGe+rMJhCrdI0KEzb9xGwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zAZA4UgZNWoimfi4iKDi1ZNXqYc7bQk9vA3XeszCm4s=;
 b=EcDmOVFA7sQ0UVQto6KujB3bIi1pw3YmRNiZlm2i+Cuw/Qt6FWTlE1uUL3e0CHZkWeFCTxHMyro1o6nrSjVQOKp7NzlUugN2slqJ2nDbMAIN3h/ZRlOez8AX353nje7C2nkpC1bF7lLUTQxh4nu6Z6AKmSCcoEPCqgM47HsedEgweawyONQq9kjr7lF1Od8eXrbdE9FVpfLNZoQyh9fmftK3CV5CXpiaydFhwPuaOxXFaqzdthKppPFPIXCiyYbe77hi2DIawn90w2elc/dLwVtthbRekys8mZptXy4djfL//QtyCWwntcvxA+ZhYztfIaYTvquVvFP74RQfgg+CMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH0PR11MB7494.namprd11.prod.outlook.com (2603:10b6:510:283::18)
 by SA1PR11MB6846.namprd11.prod.outlook.com (2603:10b6:806:2b0::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.33; Wed, 30 Apr
 2025 15:44:00 +0000
Received: from PH0PR11MB7494.namprd11.prod.outlook.com
 ([fe80::353f:c8a8:2933:d288]) by PH0PR11MB7494.namprd11.prod.outlook.com
 ([fe80::353f:c8a8:2933:d288%4]) with mapi id 15.20.8699.012; Wed, 30 Apr 2025
 15:44:00 +0000
From: "Chen, Farrah" <farrah.chen@intel.com>
To: "seanjc@google.com" <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "Huang, Kai" <kai.huang@intel.com>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "Chatre, Reinette" <reinette.chatre@intel.com>,
	"Hunter, Adrian" <adrian.hunter@intel.com>, "Lindgren, Tony"
	<tony.lindgren@intel.com>, "Wu, Binbin" <binbin.wu@intel.com>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>, "Peng, Chao P" <chao.p.peng@intel.com>, "Shutemov,
 Kirill" <kirill.shutemov@intel.com>
Subject: Linux-next TDX regression test report
Thread-Topic: Linux-next TDX regression test report
Thread-Index: Adu55ktoCTF94mWcSCGQNi1ZUgJ8xA==
Date: Wed, 30 Apr 2025 15:44:00 +0000
Message-ID: <PH0PR11MB7494B578E926F89250FB21CBEF832@PH0PR11MB7494.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR11MB7494:EE_|SA1PR11MB6846:EE_
x-ms-office365-filtering-correlation-id: 74806a20-cadc-4ada-2765-08dd87fdd3c6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?hpo/389YxZbH1JnmzvuilUhB4vQsUKTobBaNq9+VGg3lD0vrEpH1TQYWb+tv?=
 =?us-ascii?Q?2W9DbVu1jSQnSu/Q3RzZo6p2KXIvRq35HIRC2Oycu9eVfqFR4vn+8w1spkEJ?=
 =?us-ascii?Q?R+TRoRp44Dcsv7phdM4xYhBEgv35LgluFAEOudcBUXmzwSSu/1L+gp9qBgIB?=
 =?us-ascii?Q?OOO94FVnqfklMQLg/R55S3/k66O1nFJCTMZQDpGQAoXSkX5hksD0u5OxgkCb?=
 =?us-ascii?Q?zvkmdCqUnmt/iT/wImf1mfUkuRBAjB7pm5pKforpA+yASHNo+c1mmKAYUNAY?=
 =?us-ascii?Q?HB9Dyx57vPl2mam8BpJE8QG7rLhkH+6ngkf6tpHTc6hv4oSPzKqSVTQcE1ON?=
 =?us-ascii?Q?2sZq92HnbvI4wVSrgVieCGY4EoN74Nv8wO4DsZbAqKUo8w002XpQMNjfQuxU?=
 =?us-ascii?Q?syV8GXQz40UKdQ+7ozSMIc8jVRcCHiyKK1TKazMIdCG1b7kB+1zcHJMOl5TF?=
 =?us-ascii?Q?22KeRFY8tHGnpgXp2wejDgCj/OfcL5dBYXOAyVGxlNDACqChVP3k88lqpMUZ?=
 =?us-ascii?Q?c7VqPaVISBHoO3bGFLkDbPfybAOAqXlf/Ml31wenoIoaVKRZujystb5GCVqG?=
 =?us-ascii?Q?mvSaysEUaziIig/niENED2QOSBEBhn2W7dGZa45Zh4ziAgg60SRNqYnBVAHV?=
 =?us-ascii?Q?UaF3osmvkUuWhNppLfTlTzn/tqLU3ZNkHvP3l7OiUqhZdUhCy8czQvBIRhLV?=
 =?us-ascii?Q?5VZ8FZnfgFB0jPj9q4bZxzFlTC9H2oOsTXbL5jXZ9pGNCla9aHshY4kq0w6K?=
 =?us-ascii?Q?xq0YPwUyxuWyjPM2rtxOJ2JeU6v+1UL35gXAem6SRpUe48LpJj+eYk55KX+3?=
 =?us-ascii?Q?PO09sFQgcisNZCHhY2pigTFa8LV2f5SfrSkQtetLmQ3jyySiqtp89xzpdJPM?=
 =?us-ascii?Q?E/iUPPXZnTu5pjzIZoPMa0XxcYQnR43vLUTPcxUGTVSdpTykZw9oKvRc/DR+?=
 =?us-ascii?Q?met4Yl6OXDfS7FufrMhfx/WGTWVDfTD1SaXeHENr1KUbjLegIoy1zxyoeASD?=
 =?us-ascii?Q?yOEqVDfQPcbx13R0jEUs92r/SSz9RkUddGpPVSaEfqOC1VSkPg7IslFy41lv?=
 =?us-ascii?Q?puH+j5/ZGvf/fEldsxqQOPgJLoG2VlLkwtGRrbL99QrS8D0ueBjG9/934Zvl?=
 =?us-ascii?Q?C88DbEQuOs5yy5sqbMa+f/sAvS6d6aO3QKNO9Q25rN/CRR3+32SRV6Cbgjpx?=
 =?us-ascii?Q?k5JZQBMT09zBFqtlY9H//8kUwSkI4ZzTX6nXGY+zLo4+IPDSGT5al5q+aulJ?=
 =?us-ascii?Q?PDLTHyzO05Z7mW+x8cn1YIdhkQyZ/RmY8eiuD3PpVTYDLjJoOmix7ybe86x0?=
 =?us-ascii?Q?y4mEk39bAHd5Noi0eeyV2rQMPPzHawUxS8DMqRMW08EAvo/UewK+UDSa/svZ?=
 =?us-ascii?Q?BvPg0XlyTmRUtUcbnlkNVqddvlGS0bjzQ2Ade6WjG2jKjwZGZKvPactECV8r?=
 =?us-ascii?Q?i8gixuy7RuvNeJLGqSr34rSUD8NRJSNsEsCDyql8BB21z84NtD10NrOA1imf?=
 =?us-ascii?Q?IRFkYXN9p/+tNEc=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB7494.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?R+5n7d29tU01qR2GV7pMGG9F03jehVBEO335bpfHpHo3ETWMnDAb5VUYn4AQ?=
 =?us-ascii?Q?FF9IDff6ugBU3+0ZSZ6jQ6711FdS5Pd4Z8aAC3om2ICM588ZEcxArZumCnrV?=
 =?us-ascii?Q?Aw0f/s+I1pwRXj45dqfrQ5AmfcbBeIj4IB+Q/ZaO5vzUPpScUVlEvE2qUkf0?=
 =?us-ascii?Q?Nw9vtdUvMptBLtChXJqtaxJ6DsK4GAQrpJx9ERYtnCIwRpiXIOLKRbbOmcum?=
 =?us-ascii?Q?osQBjy7y0VpeJx+QK26mYOqZNVz79gtB4d5RKWypyQVgKacm3q4NUXqQ+mMe?=
 =?us-ascii?Q?HEbNPF9I2ucGiex3CV+Z3K1XO5G+2IdQIBIzdIdDKvx78gbLRJO5QjohWss8?=
 =?us-ascii?Q?6QI/2KDUNeS55SYOhaS4Ao4tRPDLgYvKMIpl0ta4mXIc/bvN6BS/Ookly0CK?=
 =?us-ascii?Q?8cIaWAUBhhC3D9w/MWeb/Ao22jIiMlZTujJ59CcVfYDPBru0je9f+GVwUohM?=
 =?us-ascii?Q?KP4+ZhQ1qjfA5yG8UGYNt6jmc1Miznv7IL74605qZLIT+zaalIvI8ESeeEBm?=
 =?us-ascii?Q?tn9ZzSbm97XugAQvmTGeiPHl3kbRp2TVER4OPiMw5rjTUdwbokUset6JhvWB?=
 =?us-ascii?Q?ttBnzZITWLtn71oYjeOF73pJ6gLoMGISzqQglfjt0u/XkCRKep8rxuBesEGv?=
 =?us-ascii?Q?Yoz20nayEM+87zindl+oKaog0LXZj+Eyw/Q9wv3KoalndagewNToMmTZU53n?=
 =?us-ascii?Q?TDC+9aX3jj8NzfhxH9kHjDXw653mz4TrnD1DkaebbqhGLpg6m9q6xMN3QzSA?=
 =?us-ascii?Q?pit4oQIzSNWu/NwLI5Tvn8lD//d3pL4b2+h/KQUlr6V0oIUvfn0AAexB/9Fr?=
 =?us-ascii?Q?T5mLAkK+OTO6V8frqLoQNr6H5DEw4zStFJFAspxzkoBeSET3MiLLm4WUczQB?=
 =?us-ascii?Q?pFtUqa9YOt33xVEbkD3iObfx3PswSCzcokQmJzuxox6J5+hWZIujSvRGC1EC?=
 =?us-ascii?Q?64I4ufc6hKt+Ul/4T4Pcildpnc8a0TgyAkAAdCb8TdUrEZ4vnBG6n37vNDfV?=
 =?us-ascii?Q?y2wdRE3SGo4ebl3WMBoTmqSbSzUCbOewKEKc8YXS0At7rBc5x/jwTnT6vQbJ?=
 =?us-ascii?Q?qjySWFEcHMbPOP7xPadFqsoibL3ACq6d54hHxtNoZLt89r77v/6g67T35kDO?=
 =?us-ascii?Q?65AKAL2BtYJqSyhfSZ+E/cHqhSaE5vnow12IKuEHPNF1hGPxddTpxkJXgj7g?=
 =?us-ascii?Q?7Pq0OFG4uA5c4yTIMrGHeOVu4Nj22IFlp54vRUA3RyxYya8epdgoIJFX8o2c?=
 =?us-ascii?Q?ofxcr3f3xdsS9TDgCrkedm/+Ia3veM2JRz2jK3X4ZHD/L20aSK8s8NPcSSFG?=
 =?us-ascii?Q?RrlYxExHbod5gsFJIVFr74WkF/BsRx7qJasfpvHFxxedA7M0z6annZt7qaF/?=
 =?us-ascii?Q?kHRYCuScSiiPIXTJeFgw9+v4ehq83PKoUJXEXJ7WlP4NNGhPEapaKXoipWE7?=
 =?us-ascii?Q?U3eEmr7xXWanIGzbOk/NT99RbrXuU0VhCZsk40DSzzPGnsnRHjMZbLjMbKxE?=
 =?us-ascii?Q?OGVp1RxbFv73M/iTRgJG6m7nL7MzAIwS9LoKhDQNhXkkG3IdXvzWIEyzh7id?=
 =?us-ascii?Q?gi2Z+duw3vwjnhYqrjz0EvzPMPr4ZkpnEXLZaAA8?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB7494.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 74806a20-cadc-4ada-2765-08dd87fdd3c6
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Apr 2025 15:44:00.5718
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7J0nGMOM0pA206tUjfD5YzSgSgYsgYdoAQgTyHdQ0/Lw7o4Kj70yFrMc6qMdH6O7Jj8VndsbEYmwcN6B0uxodw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6846
X-OriginatorOrg: intel.com

Hi

As TDX support has been merged into linux-next, we thought it's the time to=
 do a new round of regression testing on normal VM and it might be useful t=
o share the results on the list.
This time, we tested 2 configurations to increase the test coverage: 1) Dis=
able TDX in BIOS and kernel Kconfig 2) Enable TDX in BIOS and initialize TD=
X successfully on host.=20
The test results of these 2 configurations are the same.

During the testing, we encountered 2 PMU bugs[0][1], which are not related =
to TDX patches.
No other new issues were hit.

Details
--------------------------
Test Environment
CPU: Granite Rapids
Kernel: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
QEMU: https://github.com/intel-staging/qemu-tdx/releases/tag/tdx-qemu-upstr=
eam-v8
OVMF: https://github.com/tianocore/edk2/tree/edk2-stable202411

Tested features or cases:
- VM basic boot, stress boot
- Boot multiple VMs, boot various distros(including Windows)
- Boot VM with huge resource/complex cpu topology
- Memory hotplug/unplug, memory with NX hugepage on
- Memory workload in high/low memory VMs with NX hugepage on
- Device passthrough(NIC)
- Live migration
- Nested
- PMU/vPMU
- SGX
- 5 level paging
- Intel key features

[0] https://bugzilla.kernel.org/show_bug.cgi?id=3D220019
[1] https://lore.kernel.org/all/a0e3eccd-314a-4073-a570-0fe7b27c25c8@linux.=
intel.com/#t


Best Regards
Fan

