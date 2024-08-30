Return-Path: <kvm+bounces-25474-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 84C169659EF
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 10:17:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DBF1028A23B
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 08:17:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65F9F16DC27;
	Fri, 30 Aug 2024 08:16:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CcpJDvEa"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C14AB1531CD;
	Fri, 30 Aug 2024 08:16:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725005798; cv=fail; b=rt1tipKOHR2IBQLVRxvAIIV/2o2MzdY0p9VCPYG6L6sh5LVV8nYc0iD29N/D9wtzo/qBPv4T8IrDGGrAIqXc504iD+nnMfdoCyWyRf8wQeDSCUrR/sf8NsSG3FBUqjyeauu0vOeLTn2mTskQiMYzqFUZ1jLn/GsEUSTQqAxrkNw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725005798; c=relaxed/simple;
	bh=+dDk0syzNLKExk51LLZ9LMQYe7BbxG1OtQIGZLTICWU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=rM9cCEgIG+eIBR8bjqWXhSj3gRJB4Cpxgqq7YMrK933/Bxht4AkFffsEg1om+HuYsmZ4HvhgV1r+LYp1YlZc7RhL4KBuuYTMx+lz3LbepNbayDQK2Plhg1SgGKM9AoNe1Mh8zDvjpCoBp9sSExhnWQRTBnA1rjhqOjG3Eb07+zM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CcpJDvEa; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725005797; x=1756541797;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=+dDk0syzNLKExk51LLZ9LMQYe7BbxG1OtQIGZLTICWU=;
  b=CcpJDvEajERFu9XWSsEQhiUXrFahxsZnj6WDA0rTztDy2V8E2/x0TiLD
   OK/SJ6mHRzkycjJIUKrswPahpuIjM8B3CQzStUXgOPJMa2OYkCXOgHb94
   jHhn3YDdfS0rqXXysOkv3F9X9gxRWD5e0vlRiOi8T3stiWpcEdOblGfRu
   1Pfxtsjd7JgSMVeGIMQ/tCHTRuPNHggEdfqZRDu8weDoC95LJfdCfgL0g
   I3Dute9MTkZHxKyw7ZQQvvxN795RwlCNJCt3xyK9ma2futrATVX7SSHps
   lNTiQPfYMZ9jF5waQArL+LYCgxGuGEyoBA188ghj77hrPZfS89+NIj7pr
   g==;
X-CSE-ConnectionGUID: xRAcclk5SFmaC1DPBCLQlg==
X-CSE-MsgGUID: 2s4y9LGeRzuhoK+UJKrQlw==
X-IronPort-AV: E=McAfee;i="6700,10204,11179"; a="26533417"
X-IronPort-AV: E=Sophos;i="6.10,188,1719903600"; 
   d="scan'208";a="26533417"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2024 01:16:36 -0700
X-CSE-ConnectionGUID: YOeF2zCRTZihBayuF6K5ew==
X-CSE-MsgGUID: 3H4O29DRQiK5agt2Y4EzKg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,188,1719903600"; 
   d="scan'208";a="64569050"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa008.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 30 Aug 2024 01:16:36 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 30 Aug 2024 01:16:35 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 30 Aug 2024 01:16:35 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.175)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 30 Aug 2024 01:16:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cjF+i6a8/TQH7Jf+rwFVUqdT9QFqwqGOvzl1Qh0Us0Fb1ILXBIwe0/HumOSTf8QXHAOEU+Tun5t6wK1lK2/2/2AfLxOln5aEEPhe4Gzmr1tr0wB0uWAYP/xcs1LvJ4RWppX1RJP92A5d4Yy5krfO3i6PYEtzzOC4wW+yNNt5zP7fWa6ZdWFPTCHX5c64oige0aFlYIXBarvE1mG9JL05J47FVngiivZbfGYFkaaEntbAq2oFxf8LBjEzKMkN1HUyQs2oGdP7LdiHqtveA7js3r2X9pgNTB20yhlvj8662xXO8XHA0Jhy/IfmV0ESfaJk1qMgqcAab/VI00df+VKD5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l3cyiIeXB2oS5hBdNzg4Um77WodFuuDTrhiqSkJg1qY=;
 b=btYlGsYqrI1biXYuUAWY9847/PEQquMjgI0p05JjBfXPcsppb1dmZSWpnaddd9vVj+n0MDCUStYxrX30K3iM6MlcJm5g42W0xIXDAGcrBmZFC9oU3Qzpdh6BAa32xAGKdLv/u8xY/t2vPOHUEGYu9gtswgPoX8SVOmQeerGEg1H5/yJM1yeGeo52bXfpUyai4L8Uki2DAMg7ytQyULoUNSQB8uhG9hdvqtiruXRG1KiIX04o0dwqP1IQTD04Qx+Frj8Ol09pJ/SX1zu1hVu4UttMVLfAon2LaWwfFKfwi/MAuD+kfsirzhEGpGO/OK8DvLdBqovUyftZdVkWbhgCCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BN9PR11MB5289.namprd11.prod.outlook.com (2603:10b6:408:136::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.20; Fri, 30 Aug
 2024 08:16:28 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%3]) with mapi id 15.20.7918.019; Fri, 30 Aug 2024
 08:16:27 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>, "acpica-devel@lists.linux.dev"
	<acpica-devel@lists.linux.dev>, Hanjun Guo <guohanjun@huawei.com>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>, Joerg Roedel
	<joro@8bytes.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Len Brown
	<lenb@kernel.org>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, Lorenzo Pieralisi
	<lpieralisi@kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>, "Moore,
 Robert" <robert.moore@intel.com>, Robin Murphy <robin.murphy@arm.com>, Sudeep
 Holla <sudeep.holla@arm.com>, Will Deacon <will@kernel.org>
CC: Alex Williamson <alex.williamson@redhat.com>, Eric Auger
	<eric.auger@redhat.com>, Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Moritz Fischer <mdf@kernel.org>, Michael Shavit <mshavit@google.com>, Nicolin
 Chen <nicolinc@nvidia.com>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>, Shameerali Kolothum Thodi
	<shameerali.kolothum.thodi@huawei.com>, Mostafa Saleh <smostafa@google.com>
Subject: RE: [PATCH v2 8/8] iommu/arm-smmu-v3: Support IOMMU_DOMAIN_NESTED
Thread-Topic: [PATCH v2 8/8] iommu/arm-smmu-v3: Support IOMMU_DOMAIN_NESTED
Thread-Index: AQHa+JkQ2KrEUmTJHkGRZASIwq1fGbI/dLGw
Date: Fri, 30 Aug 2024 08:16:27 +0000
Message-ID: <BN9PR11MB5276AD532C8F43608A8D30048C972@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
 <8-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
In-Reply-To: <8-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|BN9PR11MB5289:EE_
x-ms-office365-filtering-correlation-id: 13084e03-e5bb-47c4-3cb0-08dcc8cc0be1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|921020|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?GygQBf2+rz5BfqcUTwp6irn8DEP6nsIgFO7w12BT0ioC/ne8vY9WA0eHMDh3?=
 =?us-ascii?Q?Lfmb1PN5qjVLFUXLwtcGfeGbYXzLKmzd4A70RA+/Hsyn9QUBHwPOAfOD+v/v?=
 =?us-ascii?Q?6gYDe302OrduFj5jgQ5+ISLn65RFwOafFrbCcL3PQuc05Bigppr0L7JLE4Jd?=
 =?us-ascii?Q?rNi5AAT/M2SG0EDte0u70jQsoGOoThSJq+rowxvjUTxQ36KzwPdX4l4M1+OI?=
 =?us-ascii?Q?9bBShrRaIlVsK24oxaHfaSUGiMDA3uvT5MOH36apF4cnIQLzkEO1sZC2n0nT?=
 =?us-ascii?Q?/3jAT6bjG0vo/SLnFah4ZvvIAmiJVK6fg5n8gbCiMnBfsLX6kc9LpEJP4VoZ?=
 =?us-ascii?Q?Lva56zgyRuBAL0FiDhDW2M17CsFP5enrs8/RKBUL9s6q+e1vWLTdpmp8pKV+?=
 =?us-ascii?Q?ZOCZQz1TWcb6ZSpS28yZxvhjO1pfyDcHjYJ6KXOeznY9U4neENl43I9yY3jo?=
 =?us-ascii?Q?Q/QncAgJDVc9rLoHvkHSEiaqjBhlQg09iUxD2NutmTr/+CmQzYDzlZtcVfoM?=
 =?us-ascii?Q?NEPWZCPAScFgwb62FLe0j6u6goLSkXHfcHhpzDjtbYBR3VVa/KAQFI15TIp6?=
 =?us-ascii?Q?cJ/Lkkn4DYE+vvvTGtrnNq0FwWZ058eeUdf9eO2QTHGYvZ3WnZ1ofmhte0HI?=
 =?us-ascii?Q?YapFY+EA3PhxFhSmQpTW7l7mUIq2rQaf5tp6+qHDWnRsxCsagdjfPF5TESg0?=
 =?us-ascii?Q?+D9VpVfoWhNAFmnRhHIUX5rpAseISlm5COb3DRdwpZWZ249i4GUnGYBJRtl0?=
 =?us-ascii?Q?nai+1gnOR9ZWwiRSiB7lwiQOKmeP5Zs2QvikRKaLNHcU5PnE7PxahES1wVuF?=
 =?us-ascii?Q?qJX5Rmwum/4aCr9ZsxLo+DL0NiZ8WmdCoRdNt0SBzHKu4JoU4SKS/kg/hDZt?=
 =?us-ascii?Q?GDfixoR9WahIfDjefQcRNt+rIMJEaNnIIaYAQVfXG29G1dmFRhyij0fm6UW/?=
 =?us-ascii?Q?4vaM5EILEvxB+jh3EsCGVJeD5tfectoVRcCBUwbxXwenSsZVYKqSlTCKQQo5?=
 =?us-ascii?Q?t+4ubPtwNsXlYQ6k0IsYZRHsLaw5y0N/ie/wPIMel9RF4WUX878DBEZaLHC+?=
 =?us-ascii?Q?hg1XoQS8bmka+YP+y+Fi2uoyzRrsg4KRDbjyK4UvauLOAZ9GmCTfNXxVzLoI?=
 =?us-ascii?Q?oCR3S5uMiAclW0a34DboyzBv7Znq6KX6PeSzX063clOyyPNmXfJGhpgnPeGQ?=
 =?us-ascii?Q?BukYKUQu/7S+YdPBGqdgUpTFU7bBXhGL95O1gK0PgFEiw06ZgukypRH+83kt?=
 =?us-ascii?Q?8G3coFTiykXqi8MrAiBLYpHTX8YhFYGT+QzxoJfC304iXvQxm5F9c+9uuEFv?=
 =?us-ascii?Q?jRzbE6XppufMPF6T4MdisJ+l50Y7If6uh2P4pGiWIK2MrKN/9+K4zCFanrGq?=
 =?us-ascii?Q?u5exrPtFj4RRW6K6Ld6xopl1VZ64XeJFB7OdtQj73QohKOzSCLv0mdjQT6nt?=
 =?us-ascii?Q?DeDHYlKwE6g=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(921020)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?/CxMoJ/G4BAuQyQI08wKZS+NLSuHNu4rRE8VakQWaoHJbJ0pLYZ7uGEyPh2f?=
 =?us-ascii?Q?Tc1AeKLllVAS/fRQfPtxzbbm7J5qDTjIuPGvNH23lA6RidQVYg9BrCkzYpFX?=
 =?us-ascii?Q?IXCul7HvF1omRfTIs2j95GH1IcD3kjXjfqwhBxtOcnmuq/YYWbBoMbMo1Vpv?=
 =?us-ascii?Q?zu63Efp92c1jJmtfq3TTJpxDkhffpPM/WldUy55EUwDwFAW2aC4DX21MHS1D?=
 =?us-ascii?Q?aBBZw6LKCZYXCl/OBf+rl0L/cb4Sl1V/t8RQkoXHyvo6UHPDrJaATZNXvnaY?=
 =?us-ascii?Q?NzAm9LxB5y+CfNGYuoCK+dH7HYvhkH6+X0h8y1yTqtMfgaSMC8wWkes3jVRN?=
 =?us-ascii?Q?YLEgeSwVLDUk9f+SykD2YtLqDXQZzIFgbPEPV33ctXHae65xFh8YRZsBwdDw?=
 =?us-ascii?Q?2GEuKykjaJ4k4/A2FCrDEdEQ7tUqgwhJNNL55jJGGueQ5l/PJN4N5KtAk5RO?=
 =?us-ascii?Q?i9LfoBsmu7V+FUpNlt/ZgEd9JPNpukGwuxyEG5hyY90ffqxjN7M3Z83Pdf4n?=
 =?us-ascii?Q?5dCUT1l+6kPaJqRaaSpBbxRu24v3MDJJLvn0HxF6TyabUIeV/gInMMgn25Qz?=
 =?us-ascii?Q?TzumdbJ+OPatp7Gbb21xHzwCYLjNbNvYyVBw9opswb3s+Gj2Yqcj475J5dQD?=
 =?us-ascii?Q?mFYR11QqXO7uBaowwk3mewhIcbn319n5Xv/oShFU7N9xwHq8rn++0BElC71s?=
 =?us-ascii?Q?TMLnOWevTEDQntsQGSvqHdeYPY3IfUeAAcoWeMc4sJBxB3kP58OI0ZNE1wT0?=
 =?us-ascii?Q?AZJVIDO/gDHiKgAFJJYMNK1AhA5im5PhX3OpouJSkGUxIecXI8rY2Sc5SwEL?=
 =?us-ascii?Q?UmHU2zeKLFVzj9vmgtk3/KklppMhSSDZyt42XRj7WhBrT0Z3ncljNZM4otBO?=
 =?us-ascii?Q?Gn/SjzvQ9SYF0IpiB0pTzNVNHh6GtxfIGxtLlVSscgwZl5SwLm0x9FKimI3x?=
 =?us-ascii?Q?WvD3nlfE5edVaC/gZ3X77w83nBvmf7RJpbXKOrDbRFiZ5LBrXjOgyimS1jnh?=
 =?us-ascii?Q?BpBCctQILHKODdvlz9FI7kfIbeo/tF22WYqcOwna2qxyCloLThkaW0198sOV?=
 =?us-ascii?Q?iBzgvTP7ulOu+hGmBHpusA6pkvEPSt8PfSMlS+1gQnvhRW2GBc+NdnRf6k6q?=
 =?us-ascii?Q?pQRGBzbTk0l2N9j1b6GXWSmuT8LLdkZv3RhcS8Lq1yX0/h8e9I3WrtirfmhY?=
 =?us-ascii?Q?lSJMYMdQnRSonbNO4IwVIRt7+6NNWG2xwzYmH1hA14PutbDCF8o7IG8VxCvb?=
 =?us-ascii?Q?WmJn5bStbg7CMEWZlngzPV5Wjwhf9YAQp9PVMoyUhMDKGl2LYNwscZ38xn4L?=
 =?us-ascii?Q?VvpeC4hWmnsNf9uIMoYo9SjwyqLz/tEJ7He98aGQjQwFbni4G6CUKAFj/9vn?=
 =?us-ascii?Q?NDySIUclpfILWodsubYvuY64ICREIhVq2JTDK2vS9KDNSaFC6voTRkRn4qRF?=
 =?us-ascii?Q?RgtslGi6qeCc7IPY2aIP2aJZ+Pe5wOVj+yj5fcW7NglSeRG+BBbQoKqu/8GS?=
 =?us-ascii?Q?Yf1kd0lo8wLVT0qZoV3xLX/AMJ2BlonZDa+rKb54woXEA7cy767IBB+YdNvY?=
 =?us-ascii?Q?HvFR9lOT5SVOBqUQpaDZhYgH/JvFkQe7xuoUMSEm?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 13084e03-e5bb-47c4-3cb0-08dcc8cc0be1
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Aug 2024 08:16:27.7506
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vkNkK0xjheCzE+NQDxEhUh7psy+FZ2smh+PSQ8d3+PZCerloSj10scCHKyzN9a27TNQFee9G8qYzNufdpc0D9g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5289
X-OriginatorOrg: intel.com

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Tuesday, August 27, 2024 11:52 PM
>=20
> For SMMUv3 a IOMMU_DOMAIN_NESTED is composed of a S2
> iommu_domain acting
> as the parent and a user provided STE fragment that defines the CD table
> and related data with addresses translated by the S2 iommu_domain.
>=20
> The kernel only permits userspace to control certain allowed bits of the
> STE that are safe for user/guest control.
>=20
> IOTLB maintenance is a bit subtle here, the S1 implicitly includes the S2
> translation, but there is no way of knowing which S1 entries refer to a
> range of S2.
>=20
> For the IOTLB we follow ARM's guidance and issue a
> CMDQ_OP_TLBI_NH_ALL to
> flush all ASIDs from the VMID after flushing the S2 on any change to the
> S2.
>=20
> Similarly we have to flush the entire ATC if the S2 is changed.

it's clearer to mention that ATS is not supported at this point.=20

> @@ -2614,7 +2687,8 @@ arm_smmu_find_master_domain(struct
> arm_smmu_domain *smmu_domain,
>  	list_for_each_entry(master_domain, &smmu_domain->devices,
>  			    devices_elm) {
>  		if (master_domain->master =3D=3D master &&
> -		    master_domain->ssid =3D=3D ssid)
> +		    master_domain->ssid =3D=3D ssid &&
> +		    master_domain->nest_parent =3D=3D nest_parent)
>  			return master_domain;
>  	}

there are two nest_parent flags in master_domain and smmu_domain.
Probably duplicating?

> +static struct iommu_domain *
> +arm_smmu_domain_alloc_nesting(struct device *dev, u32 flags,
> +			      struct iommu_domain *parent,
> +			      const struct iommu_user_data *user_data)
> +{
> +	struct arm_smmu_master *master =3D dev_iommu_priv_get(dev);
> +	struct iommu_fwspec *fwspec =3D dev_iommu_fwspec_get(dev);
> +	struct arm_smmu_nested_domain *nested_domain;
> +	struct arm_smmu_domain *smmu_parent;
> +	struct iommu_hwpt_arm_smmuv3 arg;
> +	unsigned int eats;
> +	unsigned int cfg;
> +	int ret;
> +
> +	if (!(master->smmu->features & ARM_SMMU_FEAT_NESTING))
> +		return ERR_PTR(-EOPNOTSUPP);
> +
> +	/*
> +	 * Must support some way to prevent the VM from bypassing the
> cache
> +	 * because VFIO currently does not do any cache maintenance.
> +	 */
> +	if (!(fwspec->flags & IOMMU_FWSPEC_PCI_RC_CANWBS) &&
> +	    !(master->smmu->features & ARM_SMMU_FEAT_S2FWB))
> +		return ERR_PTR(-EOPNOTSUPP);

this can be saved if we guard the setting of NESTING upon them.

> +
> +	ret =3D iommu_copy_struct_from_user(&arg, user_data,
> +
> IOMMU_HWPT_DATA_ARM_SMMUV3, ste);
> +	if (ret)
> +		return ERR_PTR(ret);

prefer to allocating resource after static condition checks below.

> +
> +	if (flags || !(master->smmu->features &
> ARM_SMMU_FEAT_TRANS_S1))
> +		return ERR_PTR(-EOPNOTSUPP);

Is it possible when NESTING is supported?

> +
> +	if (!(parent->type & __IOMMU_DOMAIN_PAGING))
> +		return ERR_PTR(-EINVAL);

Just check parent->nest_parent

> +
> +	smmu_parent =3D to_smmu_domain(parent);
> +	if (smmu_parent->stage !=3D ARM_SMMU_DOMAIN_S2 ||
> +	    smmu_parent->smmu !=3D master->smmu)
> +		return ERR_PTR(-EINVAL);

again S2 should be implied when parent->nest_parent is true.

> +
> +	/* EIO is reserved for invalid STE data. */
> +	if ((arg.ste[0] & ~STRTAB_STE_0_NESTING_ALLOWED) ||
> +	    (arg.ste[1] & ~STRTAB_STE_1_NESTING_ALLOWED))
> +		return ERR_PTR(-EIO);
> +
> +	cfg =3D FIELD_GET(STRTAB_STE_0_CFG, le64_to_cpu(arg.ste[0]));
> +	if (cfg !=3D STRTAB_STE_0_CFG_ABORT && cfg !=3D
> STRTAB_STE_0_CFG_BYPASS &&
> +	    cfg !=3D STRTAB_STE_0_CFG_S1_TRANS)
> +		return ERR_PTR(-EIO);

If vSTE is invalid those bits can be ignored?

> +
> +	eats =3D FIELD_GET(STRTAB_STE_1_EATS, le64_to_cpu(arg.ste[1]));
> +	if (eats !=3D STRTAB_STE_1_EATS_ABT)
> +		return ERR_PTR(-EIO);
> +
> +	if (cfg !=3D STRTAB_STE_0_CFG_S1_TRANS)
> +		eats =3D STRTAB_STE_1_EATS_ABT;

this check sounds redundant. If the last check passes then eats is
already set to _ABT.=20

>=20
> +/**
> + * struct iommu_hwpt_arm_smmuv3 - ARM SMMUv3 Context Descriptor
> Table info
> + *                                (IOMMU_HWPT_DATA_ARM_SMMUV3)
> + *
> + * @ste: The first two double words of the user space Stream Table Entry
> for
> + *       a user stage-1 Context Descriptor Table. Must be little-endian.
> + *       Allowed fields: (Refer to "5.2 Stream Table Entry" in SMMUv3 HW
> Spec)
> + *       - word-0: V, Cfg, S1Fmt, S1ContextPtr, S1CDMax
> + *       - word-1: S1DSS, S1CIR, S1COR, S1CSH, S1STALLD

Not sure whether EATS should be documented here or not. It's handled=20
but must be ZERO at this point.

