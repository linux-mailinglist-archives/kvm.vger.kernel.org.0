Return-Path: <kvm+bounces-38555-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C04CDA3B489
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2025 09:44:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 07DB3189B82A
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2025 08:40:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3EA71DE4D9;
	Wed, 19 Feb 2025 08:34:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FA7WnJR4"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 927141CAA8E;
	Wed, 19 Feb 2025 08:34:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954061; cv=fail; b=ox2lECzcd/rOxSzYlYJI2zeQah3/Sy5neaMQRsK8oKmEJ/omvPWVrdIlJL3hK1GZ2Fc66gdrAXzIf+rB4N08bHQA2fFX5qveJmMrnck7pHCJWsyKPAnzRQLp4V1hbdlY/nQGlaTT0rw3TJ11D/lKsEghpkV08zXiUFEH309PkMA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954061; c=relaxed/simple;
	bh=brUz8zMavMeIrwHSI01yKp4kca+WhqurqbWD2ChNCyE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=SOqPNJX2EAcSVIyJvyHnjFWbUD+kjXqKvQTbKkEMUKowPgEjmcb2Zpi7uFx6gee5skMDxUIJ8vARWKFcqVstUg6jRIc8vG0SFvjPyThLDCTmzDsPxDwdkRmpQvUdv28oW+G/CSFBPgUbrzBwe38TbtHq5AY+H3R0WXtN7AeAj3M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FA7WnJR4; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739954056; x=1771490056;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=brUz8zMavMeIrwHSI01yKp4kca+WhqurqbWD2ChNCyE=;
  b=FA7WnJR47jNHtHPjrJnAzjYNA3fWQAM5E0WJKRUhPkNiYwsXt6/JPeRi
   iHaJr6GzP3s5Qylo1SE5zAPPhawY6EWnQFoYu6TCWkmAfkYBOzFN+srCp
   O/sqfa/Ga1x7yujk852LXzo5mxx+RzKC1ZoAlymzpiRatpmpe5d9ZDemn
   t8xxUoMqxy7e0z9w5n8qhDGpoCTbLDGcc56GLF9xuwiSWpzmcrwlvxoCi
   qccxSijiq3MPcM0wXsQaCZjYCOOWZqWEKeUG3DYsWgz7nXIXVr1mtkLJU
   PosH/91Sm+HL2nPLy5r1dr+rojUnOU2y4fm9VpO88jfqVNJSwajdbKcos
   Q==;
X-CSE-ConnectionGUID: FKGMaHeOTLKdZM1NkgD4aQ==
X-CSE-MsgGUID: CZa6u2cLRH2zhv9BP87caA==
X-IronPort-AV: E=McAfee;i="6700,10204,11348"; a="44328619"
X-IronPort-AV: E=Sophos;i="6.13,298,1732608000"; 
   d="scan'208";a="44328619"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2025 00:34:15 -0800
X-CSE-ConnectionGUID: x+BBFUgMQVefBegLcmXIFg==
X-CSE-MsgGUID: nOdnUgFFS7WpfUJfeMhOpg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,298,1732608000"; 
   d="scan'208";a="119757255"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa004.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 19 Feb 2025 00:34:13 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Wed, 19 Feb 2025 00:34:13 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Wed, 19 Feb 2025 00:34:13 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Wed, 19 Feb 2025 00:34:11 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OemBwK46MrKWplyE9fzLek4r2KBP9NLXMYMs86eaAuswG9RkBrFWsmarzBe+gYqq8kH00AO+HxOv5bbQ+s87d8ikSTIawHB343p8/hCrG23e6td7/zJnK/cgT4ZatTJZCeBwBSIIvtrmHkDswzP4WnaAoV6JtIOjwib96L+oXbSh4Jt/F1q8GD2F/ZLtU6gBZ8vP1Dmnbm56m647NKQNlrn81b8cs3IyLv3c0YK1PgaZjyYbXJYP3/FgAp7SfnL7PFq7eD6L4Zu1HFcWKA00q30qFUnPXPpteY43YkXhyO6GvVbzfvpggxi5HTf8XdpISeEKTsgQCGZvNx0jURGv1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=brUz8zMavMeIrwHSI01yKp4kca+WhqurqbWD2ChNCyE=;
 b=Uq1/soURvfHCjDgG+G7iXJNhx0GYuLknoXhyCzbn0AXRB96c8Tja+V7cKcIhSUc4cnYRM7HxBC+EVlMHmDRF9VNK+T9AjGtrUCgWJAPGNZfPXTRNGZT1bpB+ga1H63CNJZqH6b9PtQzwf0B9P/EM/6cixfZkzkEyFIsCtEgGMwow1BuT3S5YRjxSj9Wi++QCzsLQMRyaewisLr32SEZrzBILME0i/LBtWyE5i+gg9od+a5SBf2TWCVPgA5ANIzLonSBxABaaOpBuMBt+q/AG3dnsVKrl1BJSATO8v9AXyBdX1iw6/I5uRdBL43aOlkr9l6YuAJi21Os0kb8GTk9dMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DS0PR11MB7309.namprd11.prod.outlook.com (2603:10b6:8:13e::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.19; Wed, 19 Feb
 2025 08:34:04 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%6]) with mapi id 15.20.8466.013; Wed, 19 Feb 2025
 08:34:04 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Baolu Lu <baolu.lu@linux.intel.com>, Jason Gunthorpe <jgg@nvidia.com>
CC: Zhangfei Gao <zhangfei.gao@linaro.org>, "acpica-devel@lists.linux.dev"
	<acpica-devel@lists.linux.dev>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, Len Brown <lenb@kernel.org>,
	"linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, Lorenzo Pieralisi
	<lpieralisi@kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>, "Moore,
 Robert" <robert.moore@intel.com>, Robin Murphy <robin.murphy@arm.com>, Sudeep
 Holla <sudeep.holla@arm.com>, Will Deacon <will@kernel.org>, "Alex
 Williamson" <alex.williamson@redhat.com>, Donald Dutile <ddutile@redhat.com>,
	Eric Auger <eric.auger@redhat.com>, Hanjun Guo <guohanjun@huawei.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>, Jerry Snitselaar
	<jsnitsel@redhat.com>, Moritz Fischer <mdf@kernel.org>, Michael Shavit
	<mshavit@google.com>, Nicolin Chen <nicolinc@nvidia.com>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>, "Wysocki, Rafael J"
	<rafael.j.wysocki@intel.com>, Shameerali Kolothum Thodi
	<shameerali.kolothum.thodi@huawei.com>, Mostafa Saleh <smostafa@google.com>
Subject: RE: [PATCH v4 00/12] Initial support for SMMUv3 nested translation
Thread-Topic: [PATCH v4 00/12] Initial support for SMMUv3 nested translation
Thread-Index: AQHbKyrWDF3jObQSjkeRms2pcvbWarK0C1MAgABtioCAAAY7gIAAGZ+AgADnOQCAAIh9gIACsFIAgGr39QCAFPmxgIANHEiAgABxR4CAALdzAIAAdeUAgAFjOYCABOwsgIAA26KAgABqtxA=
Date: Wed, 19 Feb 2025 08:34:04 +0000
Message-ID: <BN9PR11MB5276EAD07C3B32517D339DF28CC52@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20241113164316.GL35230@nvidia.com>
 <6ed97a10-853f-429e-8506-94b218050ad3@linux.intel.com>
 <20241115175522.GA35230@nvidia.com> <20250122192622.GA965540@nvidia.com>
 <284dd081-8d53-45ef-ae18-78b0388c98ca@linux.intel.com>
 <f7b6c833-b6c1-4154-9b77-13553e501f2b@linux.intel.com>
 <20250213184317.GB3886819@nvidia.com>
 <bc9f4477-7976-4955-85dc-3e05ebe95ead@linux.intel.com>
 <20250214124150.GF3886819@nvidia.com>
 <58e7fbee-6688-4a49-8b7a-f0e81e6562db@linux.intel.com>
 <20250218130333.GA4099685@nvidia.com>
 <f7e30bd8-ae1f-42fe-a8a6-2b448a474044@linux.intel.com>
In-Reply-To: <f7e30bd8-ae1f-42fe-a8a6-2b448a474044@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|DS0PR11MB7309:EE_
x-ms-office365-filtering-correlation-id: 306d0b81-0d62-4df0-5e53-08dd50c02b2d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?TnJxL3NVSm4vKzRnWWd2cEZaT21lVmFsRHFRZG5kT0JycUs5L1ZYZUVaWWNw?=
 =?utf-8?B?WHlXK25pSXJteG5pSXJBSFRKaG4rK05tUHQrMzAxbTVOdjEyRzB1RHgvaDda?=
 =?utf-8?B?VTFXSnVRd20vTkNxTG1YaXMwQW9uOTRiSkpYQzRiU1BrUDJsYVN0OVJmV3Vv?=
 =?utf-8?B?ZUd5OG9sQUR2dDFwMFNUVUNqMDkzWjBNd0ZiL0lSS0pLSlp1Mk11Rnd3UFZl?=
 =?utf-8?B?WFJQZnNiRW1zMXQrUkZFaGNOeU95VGJhc0RvcFEyUzNYb0oxUVhzOGJQRW1z?=
 =?utf-8?B?OGxsTldneERDQ3UxSndCWW9hSGhhYXlnZDhoeXlraXZMVFpzMzA0eVVWa05t?=
 =?utf-8?B?aXpDZDk0SnplQThYdURHWVJraUlCdTg4dWdnNmcyd0ViWXluN2JFUWdvY0dM?=
 =?utf-8?B?Y2c1aGt0MUwvM0ZUWTJOV1dKbkV1aFFuTEZaSUtSRWU0dk1rMHJ4a0owV1dX?=
 =?utf-8?B?bi9UZDloSUEvQmFDUTFFbi8zaW5WdytCYklBQ204cUxMc2s4d0VPK01vdm9T?=
 =?utf-8?B?TWNqdFZiRFV2dGtyLzROcEIrV1dUaEhwLzRvdVZpbVM3enBwa1F6NURneHQ3?=
 =?utf-8?B?VEovbmVKc0dBMkVBc2ZPU1drZmtldXlEWG9qb3o2bFN0TkRJRDM4VWhHYkZG?=
 =?utf-8?B?STNrMFk4QWRqZHZuSHRrUXExUzRtd3hOenFmK2R1cWl5UzlvMytoaEVFMzIy?=
 =?utf-8?B?SkYxbmRMb0w0c1o1aXk0dEVQK25QU0JnK1N0R3RmdS9NU2Q2Vjl1K3lFYTAz?=
 =?utf-8?B?ZFRMSFh1L09STE1LUXJ2TU4xM2s0UEZkWGxWUEFHRnJyMVVQbnR5MkdDMHBW?=
 =?utf-8?B?aEhicGRrSVRFL0dBdGgya0Vva2JvUmRYS2FoSGs2Qlp2QVYwRGhMdFFwQVlO?=
 =?utf-8?B?Y3o5QW5lNVVwV3NXSUx5eU1iQjJQTkVpZ25sWHM5YzViZ05iNEVBMElydXNN?=
 =?utf-8?B?bGxoc3JEdmpoWEJCRDVBTUNBQm1Bc2R6dGxZUThaOWN4Yk8rRUdqUG80dWpp?=
 =?utf-8?B?T05mbVdvZTViSUYwL1BZWEhmbGFnVmNlZlNUaUFvRFgwMitmT3pTeDJxVVRB?=
 =?utf-8?B?QWVVeFJ4M3gyOFZNRUUzWEw4WSs0TUlvYVovc25UOTltMkoweEdMdndoRzlB?=
 =?utf-8?B?N0NnTFNyaHhhUlFYaTFCMGFiYnVOc1dZK2U1NVJKTklPa09nRm1Jc3NsclZl?=
 =?utf-8?B?RWpRK3AvTFV5R3k1UCtqdFVCSHRTNjRkRlhYM0poZ2U4cmFHM3RUZG45dG16?=
 =?utf-8?B?ZzA3eVRzbkJJenZydGFLSGZuMzdLK1ZWSlF2NElweHk5cVk4dWh1cTQ4TWo4?=
 =?utf-8?B?ais1RnNoQWFQbUhpV1ExVVQvU2lLa1ZMdUhYWWdMcDNJNGEvV1plaHF3Y21K?=
 =?utf-8?B?Znhrc2pOS3Zxa3pUck13UUFySzN3UXdtcDh2ZTZsWGdscEtKOWJscTdSM2Vn?=
 =?utf-8?B?VUVyYU5pVU1tYXhBdGxaaU5xdWdNbmIyc2ZGS0xaUmZWSEc5YW0xMHZNK2dL?=
 =?utf-8?B?TlZja2lNTWc4NTFjdlhLN0ZOQmUyUGo2c3ZxeEtMNndnOHZCSjJkZFVjbmdT?=
 =?utf-8?B?NCtta1BUbUxJZ2pJVVArMG9PcmFIc2VXamptbytMeWZVcTdCbFZ2aXFudmtT?=
 =?utf-8?B?ZTJBdnhXeEtwSHE2RVBnSE41N016T0RObko4S0tRbXNjdC9DYUpJTW9iZGdF?=
 =?utf-8?B?ajA0ZXE2LzFKbXJ4ZWZhWlZyOFNKdzh2dlZQWExJZnY5eVk3dEs5ZWllRHFO?=
 =?utf-8?B?Y2Y4bTVSTmpTZUNvcFNDV1QxWERiOXkxZHVIQ1hTQm95ZnpTdUlTTkpQanlx?=
 =?utf-8?B?cEQ2OTFvZFdzSjBuYzEvRjNqaU1ydWdPWGRIQ3AwOUlTeU9CajZKMkxjMktM?=
 =?utf-8?B?RkQ2dHFpVEdhRlluUGQzVHNPQ3o4d1lKQVRYTUlsWU1Uaml6OHkwTE5wSDNB?=
 =?utf-8?Q?Pl9wnAH+QVPyKARAwDTgNIb86UjOT0MX?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QnVVdnRrV3pYMmEwcy9wYThRVUFHSnZMbmdPZ1ZmaVVsd2pBRUY3YkZPM25I?=
 =?utf-8?B?UDR1YXEzTGp6NUxEbWkydGxPZlJjYVY2c2NaUmVXTFZjWElyR0lVMUt4QVFV?=
 =?utf-8?B?ZjhoZTk1T3doL1E3Z2QxazVJRXZCcXpTRnR3V1Vodi9LdU0zcFk4QXBnSEpI?=
 =?utf-8?B?VU54akFzaVVieGJxZ0dzRjdkTml1M2hNSGJkdS9oOHdFdUphb21uenRsQ1FT?=
 =?utf-8?B?MzcrQzJQZXVnRW5QcldYTndLS1RBcnFJVUR6SzJUbjdiTEd2OElGYzZkY2pE?=
 =?utf-8?B?SUZiQXVEQ2x5bnU2NW8ybVlTODlRRE5idXVMbVFValFTNm9tWmRqajJWdlZV?=
 =?utf-8?B?WVc0TzN6WmlvdHdpWDZrai9rMWk0K2kwUHliSk1Ud2hzRHlVMEo3Mi9LOG1w?=
 =?utf-8?B?SzRUcVF1OVB4cnpSUFJRUUJJY0xpbW4xR1hzMVAybXR0amFSODRqcWk1S2xU?=
 =?utf-8?B?SnNFWU92eHFNbTY4am82eVBQOGlKaVA2MGxlak5UK0dITXBRd1U5bGZ4bXBp?=
 =?utf-8?B?Ly9DM3ZwVHV5NHJ2N2w4cFY0akQ3TkZvZGhMVWlpZXduSzZ5V0ZNOTFJMWZz?=
 =?utf-8?B?ek5kalRnS2dNME9IcnFCcGJ0dVZraURXTWt6MFpPbjJVZm93cWgwVG5ZM2Vu?=
 =?utf-8?B?Rm5UY0duYlQ3MjNxMUtOMkdGdHpHY25SWFNNRURvbk9TWm5EcENGeGRCOW5h?=
 =?utf-8?B?eUZURWxPcnNadHZmVkNxS3ExU2xSMU1EaE5VTmloMGJ0c1dzWTlTc1dSc3JX?=
 =?utf-8?B?eU4wZm1aci9sK0pWVVVRQmdMUVVFa0ExMjBVZWtZT0Fwb3FtUTQybjVzNThQ?=
 =?utf-8?B?R1E4cncwN2pYMjcyRzQxRzNYMmJ0SGtRdWdPL1MyRTh3Sm93VE15STRxdzhX?=
 =?utf-8?B?bDkzT0FPRmxLd3lWWHFzWlFFQ0Nyckl1UkdwRkllcDBXdng5eXhNSEQ5b1Yv?=
 =?utf-8?B?SzErRnV5K2U1Tnk0ZDJNT09hNHdHWUZEcEdJT25hZzJLS1NrRHdON3IzMGtw?=
 =?utf-8?B?anNDLytiaFVpeDBOK2tZT0pKYUJhV1ZxVzdETnhHdlVhVXdKOXg0ZGVxSUxN?=
 =?utf-8?B?Z3FJbXNkaGgzRTRXOHlNa1EzKytkOFFCWWhJT1djc0ZTS3JHck1IaUk2WElT?=
 =?utf-8?B?UEN6SkhIMTF6Z09WTE1GYXAycWVsclF3NGpxMzdNSnlpMUx5b0Rkcm91ZkZU?=
 =?utf-8?B?SzF2eHBrcnBleUM2OFZ2MEZXSVIwWk1Na0drZUVidW56VHZXZGx0cCtBaldW?=
 =?utf-8?B?aGlqZW9zbjExVkRwT1MyU1czQi9WY01KVFlyVWp3TllCdzNoZXlDSzFGTzBa?=
 =?utf-8?B?RmFMbEtlV3dYMXFOR0dEUHpnLzZ3Q213QXlJZmtQcXhuWit3ZzQzUURuWWlH?=
 =?utf-8?B?aHhycTJyRXBIZTNJYnl6WmVBUHhiVmxLV1krKzZkVWZrenBuRVBTUDVnQmky?=
 =?utf-8?B?RkRrNE9FeUpZck1IL2c2RnBuUmFHRzh2dm1pM2FENDN3ZFpXZlBEOG8reDNB?=
 =?utf-8?B?SjNYU1RiN0tYSjNhTU5uaGN5RmRGVW5zeERVLy9Lbnc5V2d6djFvTXRndjNv?=
 =?utf-8?B?Y0hOYlpnb0xIZS9rSEVrSzdLZ01PWUMxdS9NUm9yOHN2eXRlMW5DZEpscUR2?=
 =?utf-8?B?T2lhTG9QeGNrYWFMcW1IcjcvbkFEUXU1YVVWeWdHV0gyOFdzNUs0R0wrVng0?=
 =?utf-8?B?VkxnZWFmRHZOVWZ3Vy90bldPTGFwWXdPenFnekNuUlV0cFVsSklJM2U3ZmF3?=
 =?utf-8?B?dTRUMnB3dEg1NDZrQ0k5VHVoWmZIaHkzTkpLVVhPbFBhN085MEdvWGR3amx5?=
 =?utf-8?B?em8yYjM3REwyQlNLQnZCeG5jTGJTcmk5QktWaUJzV2hoTzE2SkQvaFJlZ3JD?=
 =?utf-8?B?L2NjNEhhTTkrMnNxMHp0US9XRklWdTJCNGtrUmJZOFVTSUxscktBU1ZSMXQ3?=
 =?utf-8?B?SkxCSGlCdTZZeDlpZzl6cThZRytMUm52SklaS0VIL2V1NUZqRWc0dHZQZ3VL?=
 =?utf-8?B?cjA4UFpQdXJYTmRsakZvT2ZGLy9VcmRTMEFwTk5BWjJSeE1XTDZPS1EyOE13?=
 =?utf-8?B?L1VkQzc1OS9pTVNoWGI1Q0F6ZHcyWmJHNGFMWmtrc1ZIZWZoWXZuN0xTN2h4?=
 =?utf-8?Q?zELwzKVv2zArGuxablGs+1z4S?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 306d0b81-0d62-4df0-5e53-08dd50c02b2d
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Feb 2025 08:34:04.4448
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rRXQXGulkU8IwBfWar/4k++Syk4kYM1t4jug2gHHIUGFETkd5i3RReyqOTRUjcp1eg24lN/zGylrjqgefosSBg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7309
X-OriginatorOrg: intel.com

PiBGcm9tOiBCYW9sdSBMdSA8YmFvbHUubHVAbGludXguaW50ZWwuY29tPg0KPiBTZW50OiBXZWRu
ZXNkYXksIEZlYnJ1YXJ5IDE5LCAyMDI1IDEwOjEwIEFNDQo+IA0KPiBPbiAyLzE4LzI1IDIxOjAz
LCBKYXNvbiBHdW50aG9ycGUgd3JvdGU6DQo+ID4gT24gU2F0LCBGZWIgMTUsIDIwMjUgYXQgMDU6
NTM6MTNQTSArMDgwMCwgQmFvbHUgTHUgd3JvdGU6DQo+ID4+IE9uIDIvMTQvMjUgMjA6NDEsIEph
c29uIEd1bnRob3JwZSB3cm90ZToNCj4gPj4+IE9uIEZyaSwgRmViIDE0LCAyMDI1IGF0IDAxOjM5
OjUyUE0gKzA4MDAsIEJhb2x1IEx1IHdyb3RlOg0KPiA+Pj4NCj4gPj4+PiBXaGVuIHRoZSBJT01N
VSBpcyB3b3JraW5nIGluIHNjYWxhYmxlIG1vZGUsIFBBU0lEIGFuZCBQUkkgYXJlDQo+IHN1cHBv
cnRlZC4NCj4gPj4+PiBBVFMgd2lsbCBhbHdheXMgYmUgZW5hYmxlZCwgZXZlbiBpZiB0aGUgaWRl
bnRpdHkgZG9tYWluIGlzIGF0dGFjaGVkIHRvDQo+ID4+Pj4gdGhlIGRldmljZSwgYmVjYXVzZSB0
aGUgUEFTSUQgbWlnaHQgdXNlIFBSSSwgd2hpY2ggZGVwZW5kcyBvbiBBVFMNCj4gPj4+PiBmdW5j
dGlvbmFsaXR5LiBUaGlzIG1pZ2h0IG5vdCBiZSB0aGUgYmVzdCBjaG9pY2UsIGJ1dCBpdCBpcyB0
aGUNCj4gPj4+PiBzaW1wbGVzdCBhbmQgZnVuY3Rpb25hbC4NCj4gPj4+IFRoZSBhcm0gZHJpdmVy
IGtlZXBzIHRyYWNrIG9mIHRoaW5ncyBhbmQgZW5hYmxlcyBBVFMgd2hlbiBQQVNJRHMgYXJlDQo+
ID4+PiBwcmVzZW50DQo+ID4+IEkgYW0gbm90IGF3YXJlIG9mIGFueSBWVC1kIGhhcmR3YXJlIGlt
cGxlbWVudGF0aW9uIHRoYXQgc3VwcG9ydHMNCj4gPj4gc2NhbGFibGUgbW9kZSBidXQgbm90IFBB
U0lELiBJZiB0aGVyZSB3ZXJlIG9uZSwgaXQgd291bGQgYmUgd29ydGh3aGlsZQ0KPiA+PiB0byBh
ZGQgYW4gb3B0aW1pemF0aW9uIHRvIGF2b2lkIGVuYWJsaW5nIEFUUyBkdXJpbmcgcHJvYmUgaWYg
UEFTSUQgaXMNCj4gPj4gbm90IHN1cHBvcnRlZC4NCj4gPiBJIG1lYW4gZG9tYWlucyBhdHRhY2hl
ZCB0byBQQVNJRHMgdGhhdCBuZWVkIFBSSS9BVFMvZXRjDQo+IA0KPiBZZWFoLCB0aGF0J3MgYSBi
ZXR0ZXIgc29sdXRpb24uIFRoZSBQQ0kgUFJJL0FUUyBmZWF0dXJlcyBhcmUgb25seQ0KPiBlbmFi
bGVkIHdoZW4gYSBkb21haW4gdGhhdCByZXF1aXJlcyB0aGVtIGlzIGF0dGFjaGVkIHRvIGl0LiBJ
IHdpbGwNCj4gY29uc2lkZXIgaXQgaW4gdGhlIEludGVsIGRyaXZlciBsYXRlci4NCj4gDQoNCkkg
ZGlkbid0IGdldCB0aGUgY29ubmVjdGlvbiBoZXJlLiBBVFMgY2FuIHJ1biB3L28gUEFTSUQgcGVy
IFBDSWUNCnNwZWMuIFdoeSBkbyB3ZSB3YW50IHRvIGFkZCBhIGRlcGVuZGVuY3kgb24gUEFTSUQg
aGVyZT8NCg==

