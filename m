Return-Path: <kvm+bounces-14481-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C1F388A2B26
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 11:26:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 76EDC28D113
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 09:26:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8EE6650A66;
	Fri, 12 Apr 2024 09:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KCHrp6bW"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6348151C49;
	Fri, 12 Apr 2024 09:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712913962; cv=fail; b=Dbpx/+mVFkH7iiHQBi65nEXnadcA6jYRwA35DxV7TiecAI4lhk5SI6vrlAsR6MpgzXr6VuXMjmdPqFMFnBieULY1jH+y3nHB3vU2xOa6OqvsdBYzhMBD+78aWgg90fCDvZ9VgoKeXKniEAIy2IG18pHMB8LywME7X6I8aue/Tyc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712913962; c=relaxed/simple;
	bh=TYpE1BNEjhHbmJHkOdWXlZcuKk4sy+8XCnadbERvybU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=fSYg6ixlF9igZnktMxmyoJeXAVQsHc6hnSogn8oYKaKnWpDHaJYzGsF/CRL/zWqHWHUvk3xlVQFt+ZwLtvvVa7R6BSBg+2khMFWIuECVwi2yzB9J8pnEHgZkWYTX4IOkIwpsUmgvMjF2fho4I2uiIpAcWTFY+4UGck418ZYFR0w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KCHrp6bW; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712913961; x=1744449961;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=TYpE1BNEjhHbmJHkOdWXlZcuKk4sy+8XCnadbERvybU=;
  b=KCHrp6bWieVi5oV7G7AOMthloBCX/Ikp+Im891o8Dhgell2TasUO20Gh
   n8zyyyw0X7Q6hSICmm/Kczk2XriiuO245QMf5aLOMJRVGovJbKLstX3N8
   K0uTKNOgjHNZYPBZSZAIxYe8N/D7OKSfh45bLl+ybHT6M6PeFA6iFF4vq
   ZW3SgFCUDXo6QotZ3mTZV971GRQF6F2h2odXdWsIg32c2owSNic9QAiY6
   JDgHdcm12D1WwtjMcaxYXbEBjU5d3apPmZmkr9D3aDJrKOwQiPQOwh0V1
   upxsx0rLYJXJSNLZLUYMwIoy6t0YkD/DLEWRb6pbbk9CLcm/hh1X5BgrA
   w==;
X-CSE-ConnectionGUID: XzTI71btSkC8m3wb8mad3w==
X-CSE-MsgGUID: KwWAHbr7T5CdAaT1roMxYQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11041"; a="8281211"
X-IronPort-AV: E=Sophos;i="6.07,195,1708416000"; 
   d="scan'208";a="8281211"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2024 02:26:00 -0700
X-CSE-ConnectionGUID: UVm+nQqPSpmD9pl5ziUDug==
X-CSE-MsgGUID: Bg8E7CltQyapmhRzM2oNMQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,195,1708416000"; 
   d="scan'208";a="52155880"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 12 Apr 2024 02:26:00 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 12 Apr 2024 02:25:59 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Fri, 12 Apr 2024 02:25:59 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.40) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Fri, 12 Apr 2024 02:25:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LmWrRQHuqpCor4jLN5x5UIP1nUlwBlGQ+eFtFDwlUoGu5/Gkdliv9ovWE/B+4aOpHZrvxT6AYWnCs7VY2GpMuNv71KCk/mfa1nCb2LUwKaCnT562FVi+s8dkcJdOwl5rvKrYV4fU+wjxeA3GC46w4OcxFheMC3520MvEtOikWf7MtD9iupO5Fnvy/KmF3nVGhJywTKkTbtPEf3Zp4g7F/7Pp9qw6ppDQun7EUwD9TIrMczt1NHqWtpOaMnYNlxdM20sE8fDofHaMiGYMxRhlIbk4R5z5zwWB7bm8J6DjERB2pItATWiRWg3X0+dJjPuAAEfD+EQiCoETCjjfpRaYxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0qVvUmyWvtac6dOYLl8Wy6gRQm151GUFehFdhY6kcbU=;
 b=YiOOZ2olTDgzw3wXlKUO2WTNgfttTTIwtDkPwBFHy3/C+S5A3zMOXRfeFTPNcWEAVChJ/QQvfMA0v7vG43bjZSezRa/o8I2jEn6Xo7wq2Fbrprvr1xt5Gcqc/7asEuExxvkaXpRCXdz1KGGJhFh9gBYIQla7bvkjtaJYWx71swb658edHlDYV5pIRmMNmmlMMB9VINML5WUnrxkiNndn15cGM447I6qGva2JrahZhUwDMV4dvAPnX+0JlUQMekwQKNm6jiBwDkhKDUWbzoQ9APV49YA0rUbx59KEH07JnZ8APGO27Yosi8F2hABLdmtoWukHxMhZXahf6hnOjIQBCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by MN2PR11MB4664.namprd11.prod.outlook.com (2603:10b6:208:26e::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7452.26; Fri, 12 Apr
 2024 09:25:57 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6c9f:86e:4b8e:8234]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6c9f:86e:4b8e:8234%6]) with mapi id 15.20.7452.019; Fri, 12 Apr 2024
 09:25:57 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Jacob Pan <jacob.jun.pan@linux.intel.com>, LKML
	<linux-kernel@vger.kernel.org>, X86 Kernel <x86@kernel.org>, Peter Zijlstra
	<peterz@infradead.org>, "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	Thomas Gleixner <tglx@linutronix.de>, Lu Baolu <baolu.lu@linux.intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Hansen, Dave"
	<dave.hansen@intel.com>, Joerg Roedel <joro@8bytes.org>, "H. Peter Anvin"
	<hpa@zytor.com>, Borislav Petkov <bp@alien8.de>, Ingo Molnar
	<mingo@redhat.com>
CC: "Luse, Paul E" <paul.e.luse@intel.com>, "Williams, Dan J"
	<dan.j.williams@intel.com>, Jens Axboe <axboe@kernel.dk>, "Raj, Ashok"
	<ashok.raj@intel.com>, "maz@kernel.org" <maz@kernel.org>, "seanjc@google.com"
	<seanjc@google.com>, Robin Murphy <robin.murphy@arm.com>,
	"jim.harris@samsung.com" <jim.harris@samsung.com>, "a.manzanares@samsung.com"
	<a.manzanares@samsung.com>, Bjorn Helgaas <helgaas@kernel.org>, "Zeng, Guang"
	<guang.zeng@intel.com>, "robert.hoo.linux@gmail.com"
	<robert.hoo.linux@gmail.com>
Subject: RE: [PATCH v2 10/13] x86/irq: Extend checks for pending vectors to
 posted interrupts
Thread-Topic: [PATCH v2 10/13] x86/irq: Extend checks for pending vectors to
 posted interrupts
Thread-Index: AQHah6hgttNy4xVG0Emr3Eje1s1aQLFkZmJA
Date: Fri, 12 Apr 2024 09:25:57 +0000
Message-ID: <BN9PR11MB5276215478903C50701D05498C042@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240405223110.1609888-1-jacob.jun.pan@linux.intel.com>
 <20240405223110.1609888-11-jacob.jun.pan@linux.intel.com>
In-Reply-To: <20240405223110.1609888-11-jacob.jun.pan@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|MN2PR11MB4664:EE_
x-ms-office365-filtering-correlation-id: 16f25c9b-c217-4048-d6de-08dc5ad28f88
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6K25LMAsOSHJwwKqHpxILYsZ65tUHKfVWN1CI2Br0GF9wYpaW7eJ3BG2RpjkOmnerLrHGIEqKEkKuRF46Mc6Q20x8ZY77/tu73xR3l5D7UPT0MSkABxAMlcrlG+zKJJ2/5OH38rsr6Ev9BAfRt2/F5BGmZzZSbG2A6ieKxaRpxTPtzbxUuC7nquqYhvqOLkOiSPv/KBFhGgLW4K3i8yfTbCr0Mm3xaJfGSoJvv//gPnPvlPQi/wt2seln1OqUcVYptLqNFqJK+cMv/qyH3SXz2WkBEAXGjHdWuUyP2RX59rz0PhNDDMJdWKEzAwc6BzS2Ox5PMhwVLdW7VDpHH3nqOAOtlEkodxcqBg/App49N7KRSWk95yldXF3TESbvc6WObr97UwS9bbMKrN2Va9bVPFWBFmABLLcdEfFpRYneYGR8pDNrsXQ0HzN6iBClC6TEA+14Oju4bkanN02UXfqIGIabqV0vdOfwV3PEo/YGk7qrqrGZmDQN1pUGi8a/Lz7rw7zoWkHx3yAkmMWdlSehZXY6kFJK5mFd3uK6tfAJn/YYfYSrn6dK1BjF07+Be7Ubn9ylOMeHlEHZQSEQJlfAOmfT1kDexTDRgwxf/tkmW/zLcGOCl2/D1kE5p8wPsmDKW6l073rV7ufOVLYNqohdbPZrFQ44XQS3wD6KVRcLKaDiu4k2wM7omsUvU6vCzIzHH483xMf/8QkbpLxss7GmoYGdxONQvKmT3NCnn4igqk=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(7416005)(1800799015)(921011)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?hb+B8rajX/06tcoocfWiJWu7eLTp7sL3Q17Em7K3EqYRiuM5eW0s25tKgeJB?=
 =?us-ascii?Q?5cFSpTfgi7kmdutHXDARkL9u7rs+We7F0/LPOyMWheRRpMWfW3AfXVgtNW1c?=
 =?us-ascii?Q?iMPtMeeK9XRx0l8CklwmDwSXl8SiC/NkVfRrYc6UN05vtcfu1fvk7f2ytA2l?=
 =?us-ascii?Q?eAXAWfOB4bU9s1wdqH7vYw5sNk9rv8Qoy3rq55p/4VzMSEA2CFv2e0H5XHFg?=
 =?us-ascii?Q?Z4OFDp/RcvtoV9GT3s4bbdr3td8FBVPobae+CE8Pt7ikoe6yJ43LQZUbuIw3?=
 =?us-ascii?Q?HnnHIlnAmo5Ow8Sx2AV6i3K2GrcOJVdLHZH3S1sRZR3Aajq+GGcsh6sT0+MG?=
 =?us-ascii?Q?JI/20TVVdIbIn6uMKqxDgNKFejbI3uvTIIeGDdgix6653gAlPav+dekIX8id?=
 =?us-ascii?Q?nEVBRWknKS4vjs8UN+DHNA5G2Vw8IuuhiyTGsv9lxdS65jJtCqzbYAM08tmC?=
 =?us-ascii?Q?9PBORyIiGFsy9p73gDzbKb1Mb1r9ylvfIBFWmOZv/sCVxvSSLKG+4SrttjZv?=
 =?us-ascii?Q?KOl9OsmNbBfXWeLtlmJ7YvC7SyeDblwyAB3LPRwQCukIQQqDTOItvEdVXkSk?=
 =?us-ascii?Q?uJLXDxcIpxipjLcDdST5MU2gpjEslAf/jpteoBxz1WWK39cj8pVTp+49Qyaw?=
 =?us-ascii?Q?cANMBzqVNhJekSTtZN//4QN3W9Rkc1sReNPBeBdVtkKs5fYJwc8zDf5YLue1?=
 =?us-ascii?Q?UgwVS4Ew0y0xJ2LICFM4MNogldtmLS6FdFm2bPKpuTRanyP8RtbJ8Vs+qjlm?=
 =?us-ascii?Q?9wWzdMRsgRbOgxsyqPvkxQtP8n6l/gapAMzgPSIJa+PKiEjt7MyyBFjSEFp+?=
 =?us-ascii?Q?7OIlNbkj0nyKi6ANg8t74piZiyYvPvuCL5QttmPys8fAbV+A10/Mkaqfbsf6?=
 =?us-ascii?Q?q8f51NuC10xT9awh26eL8cVGwg42PgwKCnp4/5uPM2/Yr0VYHmc1IuQxvRBy?=
 =?us-ascii?Q?qa7BOkwCtgF+QMCIG+uV/iwYc40HZbiKpvotrAn+TsSpc5SWGKJMQSN5uhff?=
 =?us-ascii?Q?6lDLeOAGqhChUi3ppXTYaqF7sHHY3eaFumHcshhNPkTG8De+6ajQp6V6nnzT?=
 =?us-ascii?Q?Bwxoj2uBdqqVVjjOqPBp6Lp4L/bK4a6m7GLhQNHGjC5urxGgnRjeKszpcxDu?=
 =?us-ascii?Q?9MSOWL+cgOe5sWJuKqmKb5n2wmkhaypEUr9etkJMEWxq37bjL/Tmgi6KqDQa?=
 =?us-ascii?Q?P2zcHbTDQpZDQicP/lM2tdAtzm0AKxj3jgP1JalOqDjkfGayVP//nV1aZD6f?=
 =?us-ascii?Q?5hs7Hgh2kTozkDhi0Vf5cW9vmc2Skt26RBeu+ElUvQrwNTeorO2dxiOE3G6Q?=
 =?us-ascii?Q?CoJnUiW14dLRmRWrBY2ltYtRMV86SVT5w/p+Jhi5Qk+A5XsAGWabFwQVTUjh?=
 =?us-ascii?Q?EOLkiooQ9BKRXCgBT46wbP2pdxeTOPwOfwcZ/9520RTzK1s4Do0nreOPkHad?=
 =?us-ascii?Q?gijjKG3FVSManpN/R0aKE3EX5mrNOQh33aiz8YhzypoihaLXm2qllDryXN+k?=
 =?us-ascii?Q?jZfteU1356RqQSx5G1EYUrRkJyqZGjQkspggCpyIHICPRr92jOOBpklfk/GR?=
 =?us-ascii?Q?LSUnPi7fCTVJL8ZZbVtO7Dpm7rK/ZxG8eWz4xt2+?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 16f25c9b-c217-4048-d6de-08dc5ad28f88
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Apr 2024 09:25:57.6931
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mJGAU8mUjUO4wKrsu5LqS9TmTTUWfKUKJVU9rSIcW5tiK+QENMuKgIU7gezZbOVhAIqiO1LHywuhMNEnVA2A0A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4664
X-OriginatorOrg: intel.com

> From: Jacob Pan <jacob.jun.pan@linux.intel.com>
> Sent: Saturday, April 6, 2024 6:31 AM
>=20
> During interrupt affinity change, it is possible to have interrupts deliv=
ered
> to the old CPU after the affinity has changed to the new one. To prevent =
lost
> interrupts, local APIC IRR is checked on the old CPU. Similar checks must=
 be
> done for posted MSIs given the same reason.
>=20
> Consider the following scenario:
> 	Device		system agent		iommu		memory
> 		CPU/LAPIC
> 1	FEEX_XXXX
> 2			Interrupt request
> 3						Fetch IRTE	->
> 4						->Atomic Swap PID.PIR(vec)
> 						Push to Global
> Observable(GO)
> 5						if (ON*)
> 	i						done;*

there is a stray 'i'

> 						else
> 6							send a notification ->
>=20
> * ON: outstanding notification, 1 will suppress new notifications
>=20
> If the affinity change happens between 3 and 5 in IOMMU, the old CPU's
> posted
> interrupt request (PIR) could have pending bit set for the vector being m=
oved.

how could affinity change be possible in 3/4 when the cache line is
locked by IOMMU? Strictly speaking it's about a change after 4 and
before 6.

