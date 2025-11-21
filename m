Return-Path: <kvm+bounces-64077-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 00857C77C7A
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 09:00:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id A3EF0362A5E
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 07:59:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BAEA3339B32;
	Fri, 21 Nov 2025 07:59:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MdJsRdc0"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0634E3191C4;
	Fri, 21 Nov 2025 07:59:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763711957; cv=fail; b=ffc8fccB+jUYBYl9S/W8fopHq3kVpb5/LOMPJlWF65pY0AqdqFdvMjWwx+SnURMiQ9evTUoD+flb14Jjy2MZ/O9Y5OiSlNHD7LL9sz5/ril4Mdj0F7gYFaQwvu52NEKS9gD/bTVv9bTv4A6fDocfx8TdjZbW8uZmn9frNHVmjtg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763711957; c=relaxed/simple;
	bh=60W50gPZpwtXMUwWHSnm4gD/GBy63f5ogo9HMXefvUA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=kbZBLONapzOYm9m8XtBBlrtqQAKDL6XaROcr6PaRkjANRcWRuGBJe3r72fPP44UjFX8BCL/8gcrXgHe+xgADJfuP4ETEIDTu0sv3vacPzFZothe+8D2bh+IePV5WYV+mINBghuDjOd5du0AALvScVCZ85l42KzfRX0UfgLrUhMY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MdJsRdc0; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763711956; x=1795247956;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=60W50gPZpwtXMUwWHSnm4gD/GBy63f5ogo9HMXefvUA=;
  b=MdJsRdc0pcqYyeGJ4fjVOvUnWH2sr60QFmZ8byHKn8RVH5QE/7qeqLlu
   piUNpYtV7dvHoc75wMe3wbiOwk7DfNzLvHl0jCxjc3+N+/ZDn01uB7Amb
   m6Fdbq+iIi2xqiO3mzfK77IdMs6LpV/yaADroFQ4PiVsOWHijKFSmARK2
   EN7iK6lj8zw70GVDAICPmvYFph6c/lSgb5uupPExhIArpcMYb4ZRa1O7H
   OqRBd1LHZ0XpfXt64MWM1owcRbENcvQFHnFft9dMspB17pjYw284cG4LF
   gukV+dgiUDl3dNmIVk/VXzGpSJvDnvSI8VagBw5ankY6ANkERobrVQxRi
   A==;
X-CSE-ConnectionGUID: hNGhs57BTXCDXFFP68GSqw==
X-CSE-MsgGUID: 0SSOYsrVTVmXlaD/gSeAXQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11619"; a="53372980"
X-IronPort-AV: E=Sophos;i="6.20,215,1758610800"; 
   d="scan'208";a="53372980"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2025 23:59:15 -0800
X-CSE-ConnectionGUID: S6/n9lJXQ8aEV4I+yt6Nxw==
X-CSE-MsgGUID: OH7ez1CWTsudA5dKpNJxxA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,215,1758610800"; 
   d="scan'208";a="192081218"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2025 23:59:15 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 20 Nov 2025 23:59:14 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Thu, 20 Nov 2025 23:59:14 -0800
Received: from BL0PR03CU003.outbound.protection.outlook.com (52.101.53.2) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 20 Nov 2025 23:59:14 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yrZTs1kVGfq9sxaKX3HpnPAXgDvonFw7MbaZnD5Kq4tKnpug8ELshSYltBJgMgVxJaEd7Goct8sDL1o5HB0Tu7vawKWTuTKvjQIDnWTQFr+2HLRC9/VsF1Lv9peNWIGgqWHMgqzIghpi975goK1wQSoDfIopDqBS+++7KiA8zHZ8noxKp7JdUkNyHQJg89u+MvTPTEJIZSPrV0G1CV+NW2qeVviemRoyZ1N79cOpq/AYsbpukCC3B97003dcXkPHnBZo1ChrzmIGvNU8bJiUNt8TB38giCtqU98ZNFGQsxlqfwNAo1DMlAKuksInklcu7cNzw4LX+VGs9tsuj/RY6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k654dRzz9XQ5jzX5UlHR4iWD8cZAihCpChulVsturNk=;
 b=nxGQrFBVZ1nCZeambrd+4C/I7wIO1arKLVM2ESVPto/HQiWnzAcJRp/U5w21azG8GQEv6bNs7mC8TNDCc0BJGU3sAyDDOAaMtJW2qeiPpgppjx8sw0S8OuilxLlV0sFhxX+1+7K4UQBAw5AgfB3yg/D/rzIaX1KG1PTMHlgxyzc8ZuFwiKlzkbQgVTD8X9Wl4svdyp7LSBI9HN9IzFq6cw+32L8tq+Vx32yguuVN6oXAwxSDUFc0Ty+fy/z+aARtGzdg/sm5iDrp8BwLy+QZosHmvM1ub7taWCRkySOXQrVXnl99qZ94MOhoAeQZW/arhwckwd/uJjHBl4TVJkEvxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by MW4PR11MB7031.namprd11.prod.outlook.com (2603:10b6:303:22c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.10; Fri, 21 Nov
 2025 07:59:09 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%5]) with mapi id 15.20.9343.011; Fri, 21 Nov 2025
 07:59:08 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Nicolin Chen <nicolinc@nvidia.com>, "robin.murphy@arm.com"
	<robin.murphy@arm.com>, "joro@8bytes.org" <joro@8bytes.org>,
	"afael@kernel.org" <afael@kernel.org>, "bhelgaas@google.com"
	<bhelgaas@google.com>, "alex@shazbot.org" <alex@shazbot.org>,
	"jgg@nvidia.com" <jgg@nvidia.com>
CC: "will@kernel.org" <will@kernel.org>, "lenb@kernel.org" <lenb@kernel.org>,
	"baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-acpi@vger.kernel.org"
	<linux-acpi@vger.kernel.org>, "linux-pci@vger.kernel.org"
	<linux-pci@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>, "Jaroszynski, Piotr"
	<pjaroszynski@nvidia.com>, "Sethi, Vikram" <vsethi@nvidia.com>,
	"helgaas@kernel.org" <helgaas@kernel.org>, "etzhao1900@gmail.com"
	<etzhao1900@gmail.com>
Subject: RE: [PATCH v6 4/5] iommu: Introduce
 pci_dev_reset_iommu_prepare/done()
Thread-Topic: [PATCH v6 4/5] iommu: Introduce
 pci_dev_reset_iommu_prepare/done()
Thread-Index: AQHcWO7mmxogfvDl1EeplWWw/aIYAbT8x1vw
Date: Fri, 21 Nov 2025 07:59:08 +0000
Message-ID: <BN9PR11MB5276D40AC7105D19F4E54FA18CD5A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <cover.1763512374.git.nicolinc@nvidia.com>
 <246a652600f2ba510354a1a670fa1177280528be.1763512374.git.nicolinc@nvidia.com>
In-Reply-To: <246a652600f2ba510354a1a670fa1177280528be.1763512374.git.nicolinc@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|MW4PR11MB7031:EE_
x-ms-office365-filtering-correlation-id: 13f5a20f-8b1c-401e-67d7-08de28d3d9ad
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7416014|38070700021;
x-microsoft-antispam-message-info: =?us-ascii?Q?mPjlFtQ6VjfXzwmRYsFhbethdtsdaAdQfGQn7eO5equXcZlcURilNk1d97NU?=
 =?us-ascii?Q?3nsw7rgelnUhR7+sNgtaI+Z1fujUENvKgZVbOeymXprly1tFSKz0xrrD3RBp?=
 =?us-ascii?Q?3qXSeP3Ak1P8jICxs4k60AImZYXZbeELpeFmZsHBkGczQVrstU2n15aB6uuE?=
 =?us-ascii?Q?1b00iycAzPydQBQd/HM4hu4xfUuwjFtpAJ60b2R0uauP5+riokajOk3OvIcS?=
 =?us-ascii?Q?nmHRFqRXAIAc3lkOE0XLJn2mSC23NQA2gocgDY1ulrpdj1lk8QHMnKOXte2v?=
 =?us-ascii?Q?4ghyCWLq4hS8vQdJorMSb2PJwU0FD98sCUAd6P27CfwXHY4v4XARHdo0P6dW?=
 =?us-ascii?Q?h6j5Z2MJVSOjZ4q2c/LD1T6NqK29fC5WB19JU+KpFLU+tMY4UlxmmbHhoEi+?=
 =?us-ascii?Q?Nb70DfRQmD/ys70ksUzvEI8RRPsgrEwYWCBsWH5yRhPt7pf5mU3eZPrOFd2v?=
 =?us-ascii?Q?049nNsz6m+PiGCFeGO+ovS2PVjzT1mI3GTFp4x7Tm1KqmutUb5mAvs6aea8S?=
 =?us-ascii?Q?bAYVqjEy/GHO2VwmWePthrlmtSTLs86U42NKp67fB4NmSdUXgxlko3Cc0HY4?=
 =?us-ascii?Q?bjLAHgH5uSt+Go/kuaeJJ58ojQyie4wTB97AS8JXFFKCwg4XVhvzOPT9eSlO?=
 =?us-ascii?Q?hetXebcsIyRSO26EuWOd25A6sMagPuzZILFv/QnOSHmHUZ/Z9VyFUNGsqZuw?=
 =?us-ascii?Q?B/Xauju+JCsOUFiZ3QXzEk0dbRgJMzpR0DEFGkTxFpq9dmNbscDjqcVBJqjF?=
 =?us-ascii?Q?TF+rTnj+BzJZoIxUhp7JT0gKJGoh9pVETbyu/sAMHq4A+5KsNPWIoh98I1+d?=
 =?us-ascii?Q?ATgtZpRxHjFeA1mwGaNvTSWRXd8nRJjmqr2il+uH5HikSooVK/BgVSTupUz4?=
 =?us-ascii?Q?kVuZsHHlwvcL+9DRtV0e+YYMTA9qBmZWp9rV8o8KI/ZnnvoF+5pSJGP/6MiM?=
 =?us-ascii?Q?fRJvbjE37BLQffOtrWpolzeGOey6/sb4iWI+9fcuqXd60CC7CW4Aei32yfK3?=
 =?us-ascii?Q?VxgIPLLNQ33Ckf1VlUsNQGuYe9aWsfxQfW35GoHAKznR8dgk7/1gklVBy/lt?=
 =?us-ascii?Q?7B9MUXbDQIyb77CKPmer7++iiC+7F7aMQza7IxK9cgPYw3GylVfIe2u5Z1vi?=
 =?us-ascii?Q?GK1tzS56lbkmNnK3548Id+QgGOjRx20e+jXkno++yG0iVKrbXsobaMLGGaTP?=
 =?us-ascii?Q?fJF576snHqFcVBAdWjfK5gQ1MHp2nJR5GZAGqnstYc6zkMVCzqDojxwbfMZV?=
 =?us-ascii?Q?KRknIp3eT4jcQNjzjUE5lmsh42u6i+JOgjW08xu80vR4MZEn2lxg+qSQGcgs?=
 =?us-ascii?Q?Oxd0iFnzo2TvRi2cbDgWmwL1VWKXsz6V4AJtEuYrgnrwKggkVBrKmyRSoo7G?=
 =?us-ascii?Q?14xwKJhRf2bWxc1LupRlm0hMhBSXMg+pvqLTpNw281jQyeKXi9ZOT4ub+gbT?=
 =?us-ascii?Q?0R2TF0KNvFBDzB7eP73+/aeMLksHDCzymVe8DuP0ut256M2q206iCro6nzwE?=
 =?us-ascii?Q?lQktGnz04SPf8yTf5arnTMe6oOrviJ4O62f4?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7416014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?8NRNcA0qXo3yKbGS+hwCKudglobxX7rWNrZawbJfp4w03Flf+SzMBdpZJIwM?=
 =?us-ascii?Q?p/gZNPOWuICQ9QOgq3H+lPfRjRAL1b/R1zJoY6RpGDPQxNNDCjzdYlhjlhm1?=
 =?us-ascii?Q?bA9xvgVDjbmDEKfpWFXSV6NvDFQ4EceppdRMd8bUjN6txzFII15SzXi/jrY3?=
 =?us-ascii?Q?80BqSjBtHCFI+87aMzfSTI72pShUCETWqgiX5Oyiedp+iCfAVsoYppR2OVlk?=
 =?us-ascii?Q?zEQucauVWDFUuBRf7rzTtvkd7ZYEH3QTT5WCtMwIq8CRcnaHQF50X7HJTb1z?=
 =?us-ascii?Q?DzS0SE6kpxDU0sMWp+M41dw5MLyUlZGDTZSZsgNGIDVJlDqIIyIBuTysgW2Z?=
 =?us-ascii?Q?Pqsa69EryxZITcQ2ShdHQ23eNr7GgWzKD2CZkUPHRWHhpBImwNFsh8vrIOJT?=
 =?us-ascii?Q?2FbK7ZVMa6/gwpKRtQjwqMYGLecfaFr+l+AI5+DW5ctXAwdyXc2G40UiVEVO?=
 =?us-ascii?Q?YuNc9x7sKwaioxO5s/crz8pgTi/plj6+LP1DOVKqZE/FPwqOXtjngTH8hOem?=
 =?us-ascii?Q?2DPJ1NhAQqb5axLgZfwQvEv79DOtKhbHLhRFrgpeMJ4+47j2dz9rh+33z/sp?=
 =?us-ascii?Q?Rd21gwKxaNERP9FqbRTLH8VEns+mCOJwvQgZX9HIvGi0RjsFXg+p4ynwkDc6?=
 =?us-ascii?Q?Ir3OV+GalBub6vp2w/XQMWJgJMfigLbmVRF4ZZlpJALQN9ggWvoXpRUhAH1n?=
 =?us-ascii?Q?ggk++ZV5Q4ZDIklXgaVB++lsc4Mbh8oz0RNetQqzk1FKeRpFpiLWXakNNbLq?=
 =?us-ascii?Q?bNtHn1aCq/FI45fToB5Sc8bD4J9DdFMFki5vOZ2YtL/MwuIvMfIHBkneasg2?=
 =?us-ascii?Q?7lp/yrAw6X+yOxY+8ob3ET+AIBkGg5qHtf09v9gVhfWyoaKW5VU7z/dB0RTH?=
 =?us-ascii?Q?Msgixu2ZJg3xnYPBOAc8xT/dUC2Bdv3ctJyaUwsW/FvnvxTpAgMqazKL2Bj7?=
 =?us-ascii?Q?ZIQFXz7l+j71YapCQwn2kTHHeovdmd1pVamWX5e6EMxvJ+bihd/GCmkeRFl5?=
 =?us-ascii?Q?07lOoWkhKEHdvWzunnAWm3pxp1MPY93+7N7L+W2i+R1Y92GVGMyfchqEMn/t?=
 =?us-ascii?Q?1bZcbIYowgmu29CvyJ5zlNwG/iCCTOC0KFeBbpmv8eqSlnF6jx7XB1OcyMa3?=
 =?us-ascii?Q?25PwJaTg32iCJcEYYBPtDAYduxUUfzOU/kOPSLI2Z6RKxeNfDqcFgomFALXm?=
 =?us-ascii?Q?mDzZpsH2jkFDUyUN3UUdYTASYO5OwpAjLNUWZCpFadk79wAza77fEBAvhhzN?=
 =?us-ascii?Q?9ZeGEUYL8CFOQArr5qAaxpV7U7FETogLcffz5XCv8vZnHYCul96qkB13C/YS?=
 =?us-ascii?Q?LTp/kVU2/N6F49LwA/vokM/aiAFraR8+z5Ayc4GUVClJ6I+0FCzhY1//QlH3?=
 =?us-ascii?Q?HfuUPOyih9M7xlLQGE5UiZPvAtEkWk7HsJMr83Xn6VLls0R7fr7n7ek4umd/?=
 =?us-ascii?Q?6ZFkAs/HSWUvV4eY0O6boB3ewmyAWEXWYRrwEokTvc6x+f5Z3gJNxCqY3JdI?=
 =?us-ascii?Q?H/1jMOSXq2i8a7jmPAOrVihtrzBsUB3HRleOPPigTE3o2w1LjyQ6f934TFEP?=
 =?us-ascii?Q?XmjVHZBFD4ka476rpQOILV/se58Wf7UOWICcrd4F?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 13f5a20f-8b1c-401e-67d7-08de28d3d9ad
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Nov 2025 07:59:08.8390
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5lllP3tafzIRGzw5Idzst8N+uELozFiK/kZOBOQD2IUTnAwrAXZbBj6JcysAWZtT8BHbcGdoTRS+TK0ZN3aewQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB7031
X-OriginatorOrg: intel.com

> From: Nicolin Chen <nicolinc@nvidia.com>
> Sent: Wednesday, November 19, 2025 8:52 AM
>=20
> PCIe permits a device to ignore ATS invalidation TLPs while processing a
> reset. This creates a problem visible to the OS where an ATS invalidation
> command will time out. E.g. an SVA domain will have no coordination with =
a
> reset event and can racily issue ATS invalidations to a resetting device.
>=20
> The OS should do something to mitigate this as we do not want production
> systems to be reporting critical ATS failures, especially in a hypervisor
> environment. Broadly, OS could arrange to ignore the timeouts, block page
> table mutations to prevent invalidations, or disable and block ATS.
>=20
> The PCIe r6.0, sec 10.3.1 IMPLEMENTATION NOTE recommends SW to
> disable and
> block ATS before initiating a Function Level Reset. It also mentions that
> other reset methods could have the same vulnerability as well.
>=20
> Provide a callback from the PCI subsystem that will enclose the reset and
> have the iommu core temporarily change all the attached RID/PASID
> domains
> group->blocking_domain so that the IOMMU hardware would fence any
> incoming
> ATS queries. And IOMMU drivers should also synchronously stop issuing new
> ATS invalidations and wait for all ATS invalidations to complete. This ca=
n
> avoid any ATS invaliation timeouts.
>=20
> However, if there is a domain attachment/replacement happening during an
> ongoing reset, ATS routines may be re-activated between the two function
> calls. So, introduce a new resetting_domain in the iommu_group structure
> to reject any concurrent attach_dev/set_dev_pasid call during a reset for
> a concern of compatibility failure. Since this changes the behavior of an
> attach operation, update the uAPI accordingly.
>=20
> Note that there are two corner cases:
>  1. Devices in the same iommu_group
>     Since an attachment is always per iommu_group, this means that any
>     sibling devices in the iommu_group cannot change domain, to prevent
>     race conditions.
>  2. An SR-IOV PF that is being reset while its VF is not
>     In such case, the VF itself is already broken. So, there is no point
>     in preventing PF from going through the iommu reset.
>=20
> Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
> Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

