Return-Path: <kvm+bounces-63195-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 57809C5C42D
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 10:28:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 86A0D34EA05
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 09:20:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6403C30215B;
	Fri, 14 Nov 2025 09:19:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="d5V5JVPm"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 307EB2F6567;
	Fri, 14 Nov 2025 09:19:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763111944; cv=fail; b=cdyH6cb9d15t4ByMGnDWg7AmZPtgOnhEkIhBz4ZDdS72gR/LJjl9Tz3SZK71S0unWPvxjQuyfCKDHu8MCwuTemnzhYeHor1wxYo3GOJrxdbM2wMGJOAaQqj3h/oJBQrNXthW7uvCz3iaovPAqSx/lwA5rvhQDyNFtdVfuPiVe10=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763111944; c=relaxed/simple;
	bh=RwyJw+hPrYrzvXrzwMZnoRGJQQBuVFeFvRgqHK2wbQ4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=F+Xp+n96fusrNg/GFJWJxy9PyQDXKdfvJYT0syGKIZHsODaIUDysdnJ/PLdgxG3t41u/oieBf5BkYkc9+E03TH5/AYWU7RxfwTOnQEr/NXoaPrtO6W1Fjjvr67R7qRFugj2FMbSOZSpzJAneNp1u+1UD2NLMZ2StUE0GPhnXyO4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=d5V5JVPm; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763111944; x=1794647944;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=RwyJw+hPrYrzvXrzwMZnoRGJQQBuVFeFvRgqHK2wbQ4=;
  b=d5V5JVPm7e/NobNFyH0VRpT5ii9skNxZLHgpA7Vsq81L4qcJDiuSkLOM
   EeyXmtcBqCW1DP21bTABGHmZf6D4IjCMvSnmp+AvF/vKtl3jrNfAJggZH
   F390o7xlir00EtXQdfP7MkpRl4Z4LrpkF0z7LNq/MKxvtFq/Z39zIvNxn
   6NT9QFTBQKN2lahCyAZOhO4XxqwHiFMnY549D2bKhSAwG7veve1r4kSA8
   o6DFKQ1vZ1IG8wZtAHjUB/Fbhy4oUAMGBWB9tbv4iskqz+BHyK/HiPmeV
   gkRWZV9s9u38fYoE/yTgmJ8DroOFW0Fj5z4eLKPa2sOjc/9h/pBXAAd6T
   Q==;
X-CSE-ConnectionGUID: 2IGRSNo9Qx2TftWMUVa68w==
X-CSE-MsgGUID: EYHuvpW7SOOa0+EytjHukw==
X-IronPort-AV: E=McAfee;i="6800,10657,11612"; a="65239114"
X-IronPort-AV: E=Sophos;i="6.19,304,1754982000"; 
   d="scan'208";a="65239114"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2025 01:19:02 -0800
X-CSE-ConnectionGUID: 74xcelYTSxSOEi34RpY93Q==
X-CSE-MsgGUID: hnHWlgnASJmGuKmaEqSwUg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,304,1754982000"; 
   d="scan'208";a="189751358"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2025 01:19:02 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 14 Nov 2025 01:19:01 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Fri, 14 Nov 2025 01:19:01 -0800
Received: from CH1PR05CU001.outbound.protection.outlook.com (52.101.193.46) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 14 Nov 2025 01:19:00 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dd/mbVWPg91tnkLV5CF2HGTF3xsZPNxGuUvuPVfWNY6R+dM4NH2stIlGAb/YFte0XmQWimLoT5ldfsnOhfMTLrCeg2hLxJpnlieOkbDehTvJd5m3ymP0l/R3GtwUaLQvNpV2QF4pCrhOVqFy5/zo0u+hk19cxIaS86m0iAjDddeM1veLw9r3LlvoC+v3Gt4rcDPTkZG9uFi0UEC42xaaLV/o4HOJ4cKJ7Y3pGdDnRcHYrD+033MkhuCmGAFR4PdDBnkCFuioCyYAKAWbOfjaoiEclG6PMEmFLiV8LK08K51Lwe41ghSUC4a58A2wpCuaVuY2xsqw8OakLhKMNh4DcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RwyJw+hPrYrzvXrzwMZnoRGJQQBuVFeFvRgqHK2wbQ4=;
 b=FtxEmWbwxgGDWI3jv3PXRIWKiRV2Ut3N8ya2Av7WizP+GDZZrskpRHw5PKsbENORftZUb2HPRHq90aNaPjdHGIBe3c5bqP89gl9del45SvmjSOKxmXOOeuuV0Bj0ZbwjCqD8zovSowNkHm44KD2cyfMYNg8UQwGycaJ6eZeWASwQyl2PKutTgwMjH7VbmOuf/2QVsJcvtaxJcs8gt7l2GmkStGXlS4LCIYe3pdJbbGkM70obzYmn6IZojcSj+SrbpeLSL2kE//C9ujg/nyrjKipVmEwgjSwJojTWGcdcHlPOMsxPbbg4F2KNzeNrYoJ0WBNzg4cjeBTm4rHrxsHUrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by PH0PR11MB5078.namprd11.prod.outlook.com (2603:10b6:510:3e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.17; Fri, 14 Nov
 2025 09:18:58 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%5]) with mapi id 15.20.9320.013; Fri, 14 Nov 2025
 09:18:58 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Nicolin Chen <nicolinc@nvidia.com>, "joro@8bytes.org" <joro@8bytes.org>,
	"afael@kernel.org" <afael@kernel.org>, "bhelgaas@google.com"
	<bhelgaas@google.com>, "alex@shazbot.org" <alex@shazbot.org>,
	"jgg@nvidia.com" <jgg@nvidia.com>
CC: "will@kernel.org" <will@kernel.org>, "robin.murphy@arm.com"
	<robin.murphy@arm.com>, "lenb@kernel.org" <lenb@kernel.org>,
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
Subject: RE: [PATCH v5 3/5] iommu: Add iommu_driver_get_domain_for_dev()
 helper
Thread-Topic: [PATCH v5 3/5] iommu: Add iommu_driver_get_domain_for_dev()
 helper
Thread-Index: AQHcUsoPpfLoaM2cuES0GsNCd75abLTx6alw
Date: Fri, 14 Nov 2025 09:18:57 +0000
Message-ID: <BN9PR11MB527660654210CCC3C12690468CCAA@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <cover.1762835355.git.nicolinc@nvidia.com>
 <0303739735f3f49bcebc244804e9eeb82b1c41dc.1762835355.git.nicolinc@nvidia.com>
In-Reply-To: <0303739735f3f49bcebc244804e9eeb82b1c41dc.1762835355.git.nicolinc@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|PH0PR11MB5078:EE_
x-ms-office365-filtering-correlation-id: 61dbcf9a-83a0-499a-80bd-08de235ed753
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016|38070700021;
x-microsoft-antispam-message-info: =?us-ascii?Q?Srj/mOIaskZeG1ILG56aIu/jcRow/Pj2QEtKAUjNSSDuIlFBPwcCj72XgMDM?=
 =?us-ascii?Q?7ijPZGjvB2bzQLEIepFgphcaY65xokOswra334Nu9fCsH/JKp5B+tRwR7UM9?=
 =?us-ascii?Q?XB4Fc61XGvv1VZOuArBx/lyFqvLBBZrUGKRpCNSpJCWP7M6T9Jk4nbprB8wn?=
 =?us-ascii?Q?DezH/R1xbZAQRilbhxG6qZVk9W90Snw0y1tZREy4ryEblfYyu5zUlHth3meL?=
 =?us-ascii?Q?diHwql83S9PsZ/pI/cFN2ck+fHAr1jb4WvBRtKwcg+wRLCBInFGl0fOAwJGs?=
 =?us-ascii?Q?OZg0z2dtlGFLdCy2xTN+LK+CN6c4WlFQkY3QRN5AzO3lkqlubXw8VuPuiAo5?=
 =?us-ascii?Q?CpAxKH/iPUcVB+1kycP1fYEdrr0gcTNMQb4pnEfLkw3yRyPjOruRA98DKiz2?=
 =?us-ascii?Q?HletRnoyp7t1xAqMzvVUMpHuUEUBXI+GeHqJBCABklIqPpxw8k+df5iiica0?=
 =?us-ascii?Q?Ff2TKGN/0yCGuMl9tBZyZDB+3RUO3HWQIGIk5vIXUbleHJBnatrxwWpkLi92?=
 =?us-ascii?Q?RhzEZgkLjH9SmyNfpFnulz4pbu6qtSVSJsXGpXu8obKGyQgrYTy7WqwlgT2H?=
 =?us-ascii?Q?0P9uLmp/xvyjonCfSWPvlPRqc5STDIu1rmGY4f7bFf9mu0DUEBDVaAVUu/hx?=
 =?us-ascii?Q?FxZSM9714dcKAlSyLNp9JwVjYByQvwO4zx4gWEMSeiAqqWYE+p/DA8Fl5acq?=
 =?us-ascii?Q?q9LOZ62LAXNuWzO56PMNXKxhWWXfJUHAPfzrIki0lYntKG70hol784/H18by?=
 =?us-ascii?Q?tz/v854PQZ3sDv4N+Mexhvii4bpvTf0tv33Bm8adW1GaMM2tq5FvZVKd5giv?=
 =?us-ascii?Q?/CDediu9bZlWIHBTDvUk3PiIu247L/xjRgW8+DqJdHsYW4O8CgYQ575szCLr?=
 =?us-ascii?Q?chj6sD/+7Q66Lw+UB5b4DTTajiWEv1PngZ4z/CSkoQfsrWTJJf3NVfMCzuH8?=
 =?us-ascii?Q?/0ou5F0ckIykWJdFkwivn/EugWIjyAAu4FKnrypm2kZRoAkm0fTER4BM+J85?=
 =?us-ascii?Q?Q5Hi+vv77hHInzJN+ChxBrNAjl5a5oWzklc+NvSWiz+03Nb2JEWMbIacSH6B?=
 =?us-ascii?Q?XW0prUdHwMJvVDSQUnZOczJSnGNcaXyGjkz50K05tAQBa0lizvlPgrKVx5LO?=
 =?us-ascii?Q?RulHn0DBIB5p+5PjrPpDcnvQxYZHLVXnTG+r7wFfmZa6uBG1ekjYQrcF377H?=
 =?us-ascii?Q?UsiLhNol5rzNt0oThIjE2ckRzhqfxBwzBJPJcGSpiup4oZEYgn8WQSwoeFdz?=
 =?us-ascii?Q?/5q/mukJWxzfzMusESy1IgykSZ+UlzWHhejRDNKC3xzHN0QMkhQlm25gbfTC?=
 =?us-ascii?Q?z7pLHwDdobdEvICrgYqePfcR+AQK2uMn4oGti7Sf8gbqHpvmiT7MRKVAiP0s?=
 =?us-ascii?Q?1KoRfs+4n7vlve90rxYpSRc36I8rHt7btHl9suacVIzx4kwxouZUoWQAgV8a?=
 =?us-ascii?Q?he4KOI5+DPDtILWBiuZiYOObv6ODZDTgyTCWVL5Rc4mh0PvwtN7XOa/AHQZF?=
 =?us-ascii?Q?CJFZM8rzsXYKH8EJa1TgO1Z7ZTXkGpi6Awil?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?CgW7O9v0EuoYAniI/Dd/5SyOKxT7zWKWvqXJONTmDCjT+SAG9id1l7khiCEV?=
 =?us-ascii?Q?kCfWtGMuk8vybFNK3FrVP1rZVsgbnFsZxv5pNPD07n4sPMwlhLiyDw9ahTHA?=
 =?us-ascii?Q?IrHb+xUhBfnlPPkXHnfoYDPMbB5O0aEPL5p91naedVjhbkpEvKXZ9gq+amsH?=
 =?us-ascii?Q?88RDlQwDeQfAW+rzoWrDY4uJ2kYAM4XYMXy54yCroIp+AYVDdp94l7gGKhEg?=
 =?us-ascii?Q?iXpwxa8IEbrwkTvK8up2XLQnJLkIkl6n4hnoq5Inpp/gM8VWS86Dl9feRrj0?=
 =?us-ascii?Q?ja7EaOlu0Tny4kkG2ZLuI00X5JqpvwfXuHpfuSOPy1MX3uqngeV3v2HmlKqK?=
 =?us-ascii?Q?BSxS7+O+vohDv0d+Hiz5zU5bcBda8CJ065+ghGb/WvX75ytcbhViqB3z28JD?=
 =?us-ascii?Q?8dQ1DIy2A4wlHquQcTAiYf9pX1USD4Zcgd1RmdhlmcwIWk7rQNZ+HWdEFi6e?=
 =?us-ascii?Q?kaYiVkMg1QWCVMZO77IgdXCaA4ZeCTxT9u/kQvaoHTatqiTztguNmwxlVus5?=
 =?us-ascii?Q?Ey3cUaiZssPRuU1Q7KskV4nopxZmVsN3x5GTTVwJNCBV0+qGje1JmRdxHkXu?=
 =?us-ascii?Q?sGDkBxvFlY6zRxX9BTXPeM7vAPNACFfsPVUfLbHgnT8+YnGs+a4953K16Rxg?=
 =?us-ascii?Q?wYNjO/MvrKDsL6ZyFoIRqela+LtQs/iIueuGm8xZz4BxgpGsMyCp/oCqeD3M?=
 =?us-ascii?Q?00HpdEiqN6u+hlk9s7EJSVhNL78sUYB8MVh4fFzfN/I03uu7HQ6HeNlg+S5V?=
 =?us-ascii?Q?KrZ9ymDg8i/chqn8FAR5F+8Aj9N3wU4+T3jm1nF89xgP04SE5r2nR3d1S6Id?=
 =?us-ascii?Q?WCMGTpcR+O0zOOkROaWUnhxfXhtKa6xDMbDT65p44rZJo4rcGVLHsOPfm03W?=
 =?us-ascii?Q?BdDviT+jrIDhxLfDTkJU9UIaoq46n2N5Lv5z46iuJZA12VdaLtwjL9PVlb8/?=
 =?us-ascii?Q?DakDfghxY4nB/lKLKK7bJxNKa9rqfHUGLHJGicfuKZgvpoU+YbomuUa3h4QS?=
 =?us-ascii?Q?R09E+Xbi40fDL9GsbK0kacpMEgVhGKE1XrX6LEJvb7gLDF6bB2Ru5sV0yCop?=
 =?us-ascii?Q?elV4UyUumggahWBIYoievoasj7K2RBCAIPsc7iuQR/hVIA3feCLcEpAIz7So?=
 =?us-ascii?Q?6yVhagk45bkajZfaV87mUrPRtd7vsDcnWYJQA9ppLrnFZG9aK5hQiEjUF1DR?=
 =?us-ascii?Q?qd2F+27gay0Ln3/wFSW2Ywm642qyvhsoAgWEX/JLZsBCvM0oujzgOpdqSWQs?=
 =?us-ascii?Q?KbvW8d7uWkke3G6Wi1HmvRp1RK5SzU+gx4J73+APMFVJefrlxT0F+7DvSY4c?=
 =?us-ascii?Q?E3VZy7iw2AhIW0kbnOr1UvLeLOs5PDaJsQG2zP6YH9rntP1uK3yJqcnKLcTJ?=
 =?us-ascii?Q?49G/EXbhpGL0+/nE+drTxAhgpGWBXyD85DQcsa36UGYB81fdpsNdToX9g0xu?=
 =?us-ascii?Q?JsuyHXKNGpjDaVVjNCTmhTYSFtgBXXQoKexravH6oN7WBHNZr3fnyHmwrjBd?=
 =?us-ascii?Q?O+WD5JbIaipLdmo5ZsjCz9hCtvuzeZvyp3fERSgP1mcoSfw39i6twTSKdi4S?=
 =?us-ascii?Q?/LhH7tkKYh5V9vB+H7SiwcdNlKyRrj+UB7zJcnrE?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 61dbcf9a-83a0-499a-80bd-08de235ed753
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Nov 2025 09:18:57.9242
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ady25NFH0zdBtwdjU7khfIWHGeSpqXMD2zqaRwUuiLa19hd+jSDZ0tA6DJc8SR5VYEv0YmgBuchHyCvR8wEj/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5078
X-OriginatorOrg: intel.com

> From: Nicolin Chen <nicolinc@nvidia.com>
> Sent: Tuesday, November 11, 2025 1:13 PM
>=20
> There is a need to stage a resetting PCI device to temporally the blocked

s/temporally/temporarily/


