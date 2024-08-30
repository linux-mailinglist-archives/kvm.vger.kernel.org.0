Return-Path: <kvm+bounces-25465-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 313E39658E9
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 09:44:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5CD8AB26E60
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 07:44:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E11BA16726E;
	Fri, 30 Aug 2024 07:41:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lR+lH1cP"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49275165F05;
	Fri, 30 Aug 2024 07:41:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725003705; cv=fail; b=d9MeTrplJ5TiTgkXXwFfE2MWADTjgfD8yaqDnDPO8L289u1biW7RKlVClMOCB7pyHvAEKDJf4hPPsb84W5kKOwoUAwbFVHLeebPaLTcg9sdTdT647c8CCiMrb0YqF5RvtX9TPnkZkiEmrOByD+u+rmlbDs6GBuObE4ogMFv7GZA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725003705; c=relaxed/simple;
	bh=sDCkmVZNet13W+aArK923lDlPytJFx3vHwZMbw9gpKo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=RMofvCQqBYyidPtH9+sXs73BTaNiw5X2yRpAgqe6Imxt17/byyRVqxgLnoGeSGj9H/Uwo/ITlwvcYgR0THKQ9x57qKrcKTfL8e5g9DmIOP9a/YsAZojWtaKmguLrT8OZRs1ZcgkcgP+C+4fE36jLRdzgtYgv0TZ78SiknJ8OWDA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lR+lH1cP; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725003703; x=1756539703;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=sDCkmVZNet13W+aArK923lDlPytJFx3vHwZMbw9gpKo=;
  b=lR+lH1cPTr2FPPnji1btOqLnxV4fumTFqHvAZI8fkaURFC3uxDUUjlwQ
   E5Q4SRHkNcALkFTobgai/ns7dHk3QOrbXsnipFoBoyAx+43qUJP49Dau5
   Uvd6nr19oYwbUut4bFgKHO5kjXkmL5Vvbz7UUHMbMapnQjB74rRVWQHrM
   +PxDeo+a+vuRwM5J643Rh3ZH0EvAKcQPkpLQOTBg7vy/7PvZjNKRJ8Zzo
   WFhQjTi+ti0yHzj2IQmBG/TfgQMqb8RNXfacHT/r2lV6UGBP7SEU/TJUV
   ZW8McmPomMbz0+0tYTeHCcVXX4XlPHD62+sJ14hxRTr1zJC1VN2FpJl1s
   w==;
X-CSE-ConnectionGUID: lJUpBwN7RpqRWMHCwlZykA==
X-CSE-MsgGUID: RdyIxGyETpKLE+LaD8R/IA==
X-IronPort-AV: E=McAfee;i="6700,10204,11179"; a="49018964"
X-IronPort-AV: E=Sophos;i="6.10,188,1719903600"; 
   d="scan'208";a="49018964"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2024 00:40:34 -0700
X-CSE-ConnectionGUID: z/MiR91+T+qwcwU+M1viiA==
X-CSE-MsgGUID: jhKEl6rYTKmKLz9r0NeFWg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,188,1719903600"; 
   d="scan'208";a="64010658"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa010.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 30 Aug 2024 00:40:34 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 30 Aug 2024 00:40:33 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 30 Aug 2024 00:40:33 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.174)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 30 Aug 2024 00:40:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ue5JgkqornA+QhDzqKYHgYg/UAO7ThpA0umQxHqzSDtqKMDeiGU+OKjbMO/2DAzA8smpoUmmVV9T2HbFyhpVIe788VRYkzv4D80pV5tye5Zdi9cy7x1dvZOruLsTPx2MYj6UPy4UUrZ7yWbY2WMAm3e6gKcuqINaEXpZdwK2DQEk/nMAw/bMBo6qNOhW1dvuxQjwqC1hcS5IwREUvKcmMR6GLFDEtaYmqsUNVl4aPcQvWQl6POnWE69UkK/tn2crutpKpbkRnsz1IOAWGJ5ZdWmG+0B+yZSWL2/5hxYS2sSqUAdPWh0FZbUUmrmZBKIGU3Lckx4B4frM4uk2mzeEXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UN8qttGQycXgladUcQfD8lS1AZLSP1kIR9eXBrLfpFk=;
 b=yYc9KGrmNEMSUbbFZy/YunBLdXTu0ZYUyTfOE+f/pn7HrMDNLXlPz90si6XGN6Spe7KCivQ9BWw7eAghQWN7jReSjLGM1ySsEb0eElekeHSh22ZOu84/o6MgStdpRMkoNVNmnNEtOqoj38acRFEa9svr96tPqrytSCCNPBBJllo8lFOc+zrMB1/PpHKF3Beu0v7P/Z59CFkHJrh/Op7it6+HtMrgPnkPy5oQSbgGwx2k+jGXckf7PPms09HroDTLgjD9m9Gb2oKlHQGrCvjriPwzVZXSuQai5m8mE1PTaaVqf8sv9/oFcocFItjaZCnXjk4u5aN6qbw+5f09480SHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DS0PR11MB7459.namprd11.prod.outlook.com (2603:10b6:8:144::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.20; Fri, 30 Aug
 2024 07:40:30 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%3]) with mapi id 15.20.7918.019; Fri, 30 Aug 2024
 07:40:30 +0000
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
Subject: RE: [PATCH v2 1/8] vfio: Remove VFIO_TYPE1_NESTING_IOMMU
Thread-Topic: [PATCH v2 1/8] vfio: Remove VFIO_TYPE1_NESTING_IOMMU
Thread-Index: AQHa+JkRShYcEgF0W0ijVi7Y0E1AK7I/bUFQ
Date: Fri, 30 Aug 2024 07:40:30 +0000
Message-ID: <BN9PR11MB52760C7D96310C934AABCED98C972@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
 <1-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
In-Reply-To: <1-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|DS0PR11MB7459:EE_
x-ms-office365-filtering-correlation-id: 562fe538-f99a-469e-1780-08dcc8c705f4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024|38070700018|921020;
x-microsoft-antispam-message-info: =?us-ascii?Q?vxX3sksZAgVPDYTX1WxtX/cBHVX30PFNxTE45QwwLsGudrvhB8RQasub/KDc?=
 =?us-ascii?Q?/QuhhotvNk4bCVs10XcC4A5vGDrIwLVwRN6ZsNVfn76Rte9jw5EnBURFYXqU?=
 =?us-ascii?Q?RfqALr+552hKaZ7/b7hSVZfr8bm+4asVCWS3XkRwAzj1Sphbl1inPRb5r9y5?=
 =?us-ascii?Q?GuEpG2THN+p110n24DYH6cY/1gZDHZbwkpzH+b8+G1CM9sHg7Z6cNECF/rN+?=
 =?us-ascii?Q?Xc9BJ+pqP159gbC2+tFd6MqASCHdQg7VTBWWTbcjaAiuAuXJrHGlMD6k/qoz?=
 =?us-ascii?Q?q6+X9oYlU/+mvu/xziIBlehzp6Lxd0xILD8lag9YjfFEwLyg+ubmarUt69Bw?=
 =?us-ascii?Q?dgHIw+V12b/XMg/Q1b3N5SL5YtNuI27v7k8ap+a+cuvCTYG0eBBlsbE4LOii?=
 =?us-ascii?Q?zi62RXd0nsglFhlwToUsXkAkSqcY9gk/FEFRhOcijQZtulPhS+2olwaPlJDf?=
 =?us-ascii?Q?2hd7mNAyniPG7B9VLw+2QIkbJoMBliEqnHldCZXsQAOdldY+X0nrOiDULH7V?=
 =?us-ascii?Q?f34WfuAsJq1klIrKRxiTObumBO9kLH2FAEBw58JNW6T+AUgrG79PKMDOO2nM?=
 =?us-ascii?Q?wcnrasDro0n7eY3vf7A/gebXTBG7tLWSZVHwxiqeEozeo+jFmtfS6MfqT4hB?=
 =?us-ascii?Q?6986hTuI3XRyVRB0Hkrv1QuiW9CqXGURIegwbaB/+laAuaI9dO0Y9gFCVQbF?=
 =?us-ascii?Q?kZ6HAM6m0DiGxUqZ328reQvRg2ASTnw/IAftI1HR5T1n5F6VnFjfT3nTV/Qq?=
 =?us-ascii?Q?H/888Oh6fm8gj1pAtA/l88MY18NPEmRz4Az3DVHVOp9gO0au+ko3pMY4+krk?=
 =?us-ascii?Q?1Jds4JeGUp6PbSMAdtkkXD1HrDbnRaoFHuDPrr93w0uSbfU0b2LAB+XKahtQ?=
 =?us-ascii?Q?ZGbl53pv5uyxOQD6DIwyHPcsWL8+Rq5MAFsqbVStxxdX18flpEjPfSnYiDr7?=
 =?us-ascii?Q?qJ0esanRINpXktQGcGHK7oT5SuTF4Ig9tVuloE34ZDJCYtLSO3p9bdE7asRV?=
 =?us-ascii?Q?KcUOFj9MBc+lOa29zv8L0igc1ZzzjqCcGR8mH2y9rmCBy/FueCrixrptjjz9?=
 =?us-ascii?Q?txVk5A9Yp0/Ql2oXSpL1PzvaWjFAxDhnm4/EHP9ePS8jWl25DsnHZAb8YV0i?=
 =?us-ascii?Q?UXKNKP++KzzPa0Xrh1SgBMrJfhmr2YOKfpLMY9YP7RD05pDW/IpirQcd52+u?=
 =?us-ascii?Q?jdaZgOycIH0vF7mBz4GNiclfV8vv/qhvSsa9higNKQRKbtbiKU/Frd8WKthX?=
 =?us-ascii?Q?dIjWhokoak8Y1obMZPopVuqz5637ksg95F8khdnGKjqyHEBVEB7BQcRV1edm?=
 =?us-ascii?Q?eZh1qqhn+AlNGEehb1OOSDbEXqXAnUVaO3Jl9N87kogfGj/RgE+3Af0UJHII?=
 =?us-ascii?Q?rms2jMT83yLiW3b9m8i2RtkJ5fGiDfIQEL9nl27kEGtX9LqNRxengXNwRzRE?=
 =?us-ascii?Q?WJH+0/dBUec=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(38070700018)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?RnmyP34D0HLcf2j82aTm07Md8gZjUdHKzV5RKdHrANt2lHk2+Poqdm3D/F6X?=
 =?us-ascii?Q?JNsS04RhSZpAEhtCdWcKgeQACiBTG7n+J5jCbzlvhDO3CBpOgijy2a+J5Ymn?=
 =?us-ascii?Q?wFDjod1oMCqYg7vSYhTdLJaUamqH9dNM35PvEandCy3z3MuQS3x+POzbCwQh?=
 =?us-ascii?Q?cTEPb1/0v9zyAIAf+yqnacua46TSk0yPtRZTwtRr7fLQbbCgUIgxCxf+OBnT?=
 =?us-ascii?Q?zOOpfvPSkR5wxbYDT35F0IVWxKZGsKhY/ts6FkU78kKatvBMgDARu46Vp7/8?=
 =?us-ascii?Q?tMbm+yIxmyTrnHhE4j7+rbe2LBaEEQOk53IjIlkySV8TVk24rw82JJTZyrNW?=
 =?us-ascii?Q?0AKDyiI71o7GwZe0kIdatzD8BTrGb8HafyrCdlRb3bvNrLVkZIrws+Vey56W?=
 =?us-ascii?Q?BiMwBqxDDcUpCdgh9FoKXugh6RZnHKZGdo4VERqXPC5wST5pAcv+5xkHDsJ8?=
 =?us-ascii?Q?3qSCkNX5uAjL7ntrbd5/BS+KltKiGVuLOXPk8L3KVaxl5v2KiNEv0lvxBmiG?=
 =?us-ascii?Q?9qHkkqjSNb+VtJpnbIv9typndZPkSdPRPTyibmfDWvmVpBqNRpMvm42oeTgt?=
 =?us-ascii?Q?5/AxsRZDg85Y4FZTuHE7tjFTSdfvbD/bR8NVQt2/xuFniMrcz2UmFeppObfA?=
 =?us-ascii?Q?YYlDHTy36tJ2aBAIEjo9zq3xJzaebkywTkgav3W3HKj0I0RoToZLEhdICMFa?=
 =?us-ascii?Q?FDf52pfZ5h93eNL5FkFYWQm+L3WRVpIsMzdQBaWZn5kWMvt4xvnkrgRn5XMg?=
 =?us-ascii?Q?M/glzL7+hV7/VIldKgZWLuv0uabAoQjghAPPGgzIu3nL0QOP2HRdp1rjPmCy?=
 =?us-ascii?Q?b+SYL7Ef/BVCtndQCGPuXbWI31LMHKdSUJdHVRkah3kTibFRqKnMn4NwO7G/?=
 =?us-ascii?Q?mAdE6jHby5dcU2zHc3J+75mKGVOv7TP2sMnTFPgl+qbBhah77k3tj5rLVTJj?=
 =?us-ascii?Q?CP2W/AWpBOtHn1eHdES7yQ407ls9oq4fYhSsVQDMoDUKZfhBmJuFi0kjNGTt?=
 =?us-ascii?Q?ar4XHEYEaYlbsjKGmQ7lP8Jp60Xwrj1hToEApWIPhQdeJ2TFTpVo0VhqCfua?=
 =?us-ascii?Q?M/5u0KPBl544PDwJNFJsVVWAqixg6yKsOOSyRji9FUA1zb9FukHG4MNPRFo1?=
 =?us-ascii?Q?dZuBaW+SD0N0pPPU5LGv+/JQvc07FfAvKFih2V+CgolOWeSbJfI+Bio5UO4X?=
 =?us-ascii?Q?bxGEAhg4FLQCJPrHOamHBRdfjky6Rk9amk1TNDJsCkzyhO+QPypwjjxB7Qxo?=
 =?us-ascii?Q?YBTd8NknbEGQ52N07Tik3MpYf89aVAkxSbkvXUM4WP15yrXKEAxpLUAhhiMG?=
 =?us-ascii?Q?FW9knBA/9iSMLM3cz4iJrQNbmZV5L6UZKZ6wYxzAPLFHksqkMdjq8YUL66Rt?=
 =?us-ascii?Q?RRJMWegEgIiX5l6I/20Vw/QZQaAAs3jkK6QYxmB40C+bqqP8J0lBd0+8ZPna?=
 =?us-ascii?Q?G+jj991deodtlsBcwSq79ecaaqSF+auJP/7Gr10C1WTnL4svkykRn0tJWL/E?=
 =?us-ascii?Q?GRq/X5v/mW5XU+WF/KZ+CK2PJU5tYhX8aK1BdrlXlFF1pn5FeBUkrV98Pac9?=
 =?us-ascii?Q?n0ROoDkgC8ZZGO0sB3+J1TGGYPlSAaXCGAHkQwr2?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 562fe538-f99a-469e-1780-08dcc8c705f4
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Aug 2024 07:40:30.3490
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UFLtwJrd7fBCxMafylq4WL8++UlytXmr6FNw3hrDhEFjPONvVNIaee9D9xHjVWuS/988L1xyIzZ/SpaE2rDERw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7459
X-OriginatorOrg: intel.com

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Tuesday, August 27, 2024 11:52 PM
>=20
> This control causes the ARM SMMU drivers to choose a stage 2
> implementation for the IO pagetable (vs the stage 1 usual default),
> however this choice has no significant visible impact to the VFIO
> user. Further qemu never implemented this and no other userspace user is
> known.
>=20
> The original description in commit f5c9ecebaf2a ("vfio/iommu_type1: add
> new VFIO_TYPE1_NESTING_IOMMU IOMMU type") suggested this was to
> "provide
> SMMU translation services to the guest operating system" however the rest
> of the API to set the guest table pointer for the stage 1 and manage
> invalidation was never completed, or at least never upstreamed, rendering
> this part useless dead code.
>=20
> Upstream has now settled on iommufd as the uAPI for controlling nested
> translation. Choosing the stage 2 implementation should be done by throug=
h
> the IOMMU_HWPT_ALLOC_NEST_PARENT flag during domain allocation.
>=20
> Remove VFIO_TYPE1_NESTING_IOMMU and everything under it including the
> enable_nesting iommu_domain_op.
>=20
> Just in-case there is some userspace using this continue to treat
> requesting it as a NOP, but do not advertise support any more.

It took me a while to understand why we still allow the user setting the
IOMMU type to nesting below...

> @@ -2545,9 +2538,7 @@ static void *vfio_iommu_type1_open(unsigned
> long arg)
>  	switch (arg) {
>  	case VFIO_TYPE1_IOMMU:
>  		break;
> -	case VFIO_TYPE1_NESTING_IOMMU:
> -		iommu->nesting =3D true;
> -		fallthrough;
> +	case __VFIO_RESERVED_TYPE1_NESTING_IOMMU:
>  	case VFIO_TYPE1v2_IOMMU:
>  		iommu->v2 =3D true;
>  		break;

I guess the reason was that NESTING_IOMMU implies V2 so an user can
legitimately uses it as V2 w/o counting on any removed nesting logic.

So,

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

