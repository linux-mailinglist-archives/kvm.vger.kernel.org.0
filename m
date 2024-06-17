Return-Path: <kvm+bounces-19753-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E7CE690A2DF
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2024 05:30:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5691CB2139D
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2024 03:30:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD5F717F36D;
	Mon, 17 Jun 2024 03:29:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WqhiuHXS"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78993256A;
	Mon, 17 Jun 2024 03:29:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718594994; cv=fail; b=egubcIQB0FLp6qDQv/pRJA2hhj9LFdB7lEvJHyPyzfXn6cEROqIh+q228J54kTFtwi98lrZ+lMGthrZ9Unw6wMJ6VTutr1EVBUXaEHEW4c4nBNE8XkyLckH48ySj8TgMuoN6/YQUYDNpD0Zk7keNawiyVB7Jvpxc9e8sWLnsC0Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718594994; c=relaxed/simple;
	bh=kWlH+Ur82fzHLaZ+9kYbY/oHEpNOOd+gFo1366xP4TM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=mAXIzRBT/OlTqK4SrcCyDFgy2gL1HioqYCJ2X8O8lV2NbTIT3p4S2YgkSGMmGt5NWZbyMNRHM4t5wQeMdnHIw1BJ6ldng0/FGmR9Fj9MmzP0VqVNradKwErBq477dcap40+yJRD5xvzJvFcVWejoCi8XJ6rK2uaKFZCNPEUG7QU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WqhiuHXS; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718594993; x=1750130993;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=kWlH+Ur82fzHLaZ+9kYbY/oHEpNOOd+gFo1366xP4TM=;
  b=WqhiuHXS8FSR3psTBBj8a4NoPvry65/Q7U764rjEXMYtvNGJcaTVGJsJ
   sC57aVALaRxXPiUAuRBS7s6kfLGlwlnFqrpBkwNgUuaI+5LFFuVcCR3Ys
   bj71lXUFOlolmVbbPXMFUQp4YUIqqMdIORUgmH5Sk0etPkXwtb/LL/O2c
   RdSVoYxuHfUm/epE2ZMPztUK/aWZbcHuF79jClEbFbEX51Ginm1nQj4aQ
   kN7r5p/w0kORgP5IQThAvVqPMvt5Ov6ded8ZGUsvg0Pr0i8emE3wkcEzO
   hOjndnTjpM/wmf5OMcnm8UsnH+FUtRQhRFc4UWyh8KUUWkyWZ20LvaZwS
   A==;
X-CSE-ConnectionGUID: SVH/WNN2RPOQz3cgnovs4g==
X-CSE-MsgGUID: 2Ur+xbZmTfCvAVCvRYFdFw==
X-IronPort-AV: E=McAfee;i="6700,10204,11105"; a="26805217"
X-IronPort-AV: E=Sophos;i="6.08,244,1712646000"; 
   d="scan'208";a="26805217"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2024 20:29:52 -0700
X-CSE-ConnectionGUID: nB8VmvHyT/S2w98xnrUDLA==
X-CSE-MsgGUID: KKoM9NMwTYeVo+eXTKjPJQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,244,1712646000"; 
   d="scan'208";a="72274374"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 16 Jun 2024 20:29:52 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Sun, 16 Jun 2024 20:29:51 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Sun, 16 Jun 2024 20:29:50 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Sun, 16 Jun 2024 20:29:50 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Sun, 16 Jun 2024 20:29:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QvaU4l8fsYLuqqJKR7fac3h40+i1S09zxY16i8bqA7oMJTEccDFiTjpbb+H6PLicgi5DSTaVHbcJINJr9qQSsgzK1e7zxHzOZ7LxhVSHeOK24y8q8PvRUmCw3NQo0Rz43Hlm61l/vQUtpFHLcXqZ0hM5zuMgfAg+wRUPm9jFZ/DNzocFhNOTzHp5pdGn7xy1PnvnphSKD6xpxJGk0LthJVUa+yEXAfqAam4u4Ip6lVMIk0Fb75R39EKINkWSwLIArnfFnSLZEp4xSICVUCoRSR0PfZ48kWkPmCvr9BMYvhssBLDM28T2Typ9dncYLJIVHzzEJ33fizNUhscYSx53xA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w9eJNxn4zonJmLm3KyCLBJ73kk/XeM/8SrBof+0dDM0=;
 b=cC1cwObXoZE7x36fz15EXzp2CVHF7aOGqheHXZbparL2yY8LD3KwahqvV+/m55UNUFz9D+HhxKdrjGRS3WXXuVwdluxspQfwtmmLWBLuvuimYGJlt/aZ5YSFzHWC1tMaTNguQAqL+Tr0gWccjSk39oA2XHa8WgSmu3YwBjBExpWICt2mSEJgoYCdgdRWHcF3ig7JwIUL2SW89XyL7K7nSFmQalotZda3iAr8nY7/1eMyFNowus7LmyoLbKR1/WoOTO+w6amb1WUaoHlXXTAjAzup3ul2LwLzF4i09L7fjvJUEc6K6E6tjexg4JQa5yfE0BxeSBdh2E2/vPk3rm+TXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DS0PR11MB7766.namprd11.prod.outlook.com (2603:10b6:8:138::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.30; Mon, 17 Jun
 2024 03:29:48 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%5]) with mapi id 15.20.7677.030; Mon, 17 Jun 2024
 03:29:47 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: "Zeng, Xin" <xin.zeng@intel.com>, "herbert@gondor.apana.org.au"
	<herbert@gondor.apana.org.au>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, "jgg@nvidia.com" <jgg@nvidia.com>,
	"yishaih@nvidia.com" <yishaih@nvidia.com>,
	"shameerali.kolothum.thodi@huawei.com"
	<shameerali.kolothum.thodi@huawei.com>, "arnd@arndb.de" <arnd@arndb.de>
CC: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, qat-linux <qat-linux@intel.com>
Subject: RE: [PATCH] crypto: qat - fix linking errors when PCI_IOV is disabled
Thread-Topic: [PATCH] crypto: qat - fix linking errors when PCI_IOV is
 disabled
Thread-Index: AQHau0U7e/vnG3Z9BESfhgom+C1gi7HLVpRQ
Date: Mon, 17 Jun 2024 03:29:47 +0000
Message-ID: <BN9PR11MB5276A9F4FC72273C1FBEDEC38CCD2@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240610143756.2031626-1-xin.zeng@intel.com>
In-Reply-To: <20240610143756.2031626-1-xin.zeng@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|DS0PR11MB7766:EE_
x-ms-office365-filtering-correlation-id: c16ccffc-50db-421a-7b08-08dc8e7dbd13
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230037|366013|376011|1800799021|38070700015;
x-microsoft-antispam-message-info: =?us-ascii?Q?muktyA6M0yOAz5JRrd2BIBKTX8QPZT0qGXXlbSuHFiknTclAwdS/0dD3Nyg0?=
 =?us-ascii?Q?mvSOFIFcKAOcaCItNuAkhG2dnp0RJCxDKJYfU4LaeTrdPWxQnHSz11us2I0Z?=
 =?us-ascii?Q?j+tA1pSh8Mh34EfRwJ8lhQxUI1sLJoftI+OHdpleZDlo3cQedzEgwbYq2NQY?=
 =?us-ascii?Q?VBy/ow8M4kzpThWoGufZeHyc/4rHLOzzOsLaeFsHbO1C+gz7Cn6UlLNobuFQ?=
 =?us-ascii?Q?UmuMOBVWfjMSxXB/mh2ZAc/qj0IEOCfh+Ve8yF6GpVf9EArjrk9orf+kKyHA?=
 =?us-ascii?Q?GfsIBM7lO+SQ8Y5DIdBCs5LiUQUuv6rcRNON6gFZJ2NvA8iJXOtmzY9D+mcQ?=
 =?us-ascii?Q?18DysAIGLrAccY6H4yvDNavEydAQouQ4OjYHML/gyDfMQfLS8aJCh4PGKYwN?=
 =?us-ascii?Q?46tX+W9g15Hsf+3tO9pOUoHK/FXbTmAaNviwbMxmy5hqflNVN10h+RW5xl01?=
 =?us-ascii?Q?CqrwRP+VW2ZbjppR9zulGzYoxES8QAA/EIs11eZJJDal558v7on/xv+PYSoa?=
 =?us-ascii?Q?6B7BqbDpodB9ILGHdKk6gb1S5HG+BGTK1fUhkpncoI6tStvDrsHnnDtLTB2j?=
 =?us-ascii?Q?XfNI9oAk3iZfIX7XY4wVTLDoBh928946CHPnboJC5erlPvm1L/P/IO1ITDkx?=
 =?us-ascii?Q?OfrOWOb1objupiXpvYT7rGLbAOZJ6HBzsRrtZEt1/p6l3DkOQIkyYdHExNNV?=
 =?us-ascii?Q?y5J84C6VUNl1oIezJiCHe1QUkqL3+GA/wFUF/e0YJvZdk8jXOUy6dcEMCrO8?=
 =?us-ascii?Q?0QeGTPvOa3uu/EJZnwiAzJOodCA/35q7xu32yH0IQgFlhhAR6apTx1XLcLYC?=
 =?us-ascii?Q?7xW4rWwzltKGK8POi4TUVXmN2z2lG5CMROlwoixL8hNzM3h2rkWTjqbDqd4S?=
 =?us-ascii?Q?W8Q3ExVVgdkyRjFdYU74C8dlNIUXo1fpqZsvnx2PGUn86CwZH4znjUOE/46A?=
 =?us-ascii?Q?mVXF9K1Kd9y2LSn3Kd0itoAfH/R+tPvAgoHlNDdXz57xIFWNOMkXe+T+yo4u?=
 =?us-ascii?Q?AnJxsh6hOxR1M3wbs0+kGlXVFoPGvfZdo+FF2MvVeqA0+etTCeQHwNnbhS79?=
 =?us-ascii?Q?PdqMLtjQ6QOIbFInNed8j6jjGROI+vsJwoVwF8FC4M0+8g4d4JnvuGQtjDzl?=
 =?us-ascii?Q?uTCk5NkFzCO8+4tJW+fCEvSb5CeM+wPzCQUNo1dT4NUcBlFCdnQM/K0Nz645?=
 =?us-ascii?Q?kRICHDLRuRMbt8LXbonp86txbRATjPuiFqBF/FQmv5Vql17Q1uyhUdmGfl5/?=
 =?us-ascii?Q?sIUDjrbZaPakgdICh25PQ95FWJdseVdOt9VWaRDX+A5QcOmHO0XhHAfutlWV?=
 =?us-ascii?Q?XMTKrlvhe+g3OTWnvD8CC9sP?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(366013)(376011)(1800799021)(38070700015);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ra9yAjqcLeBEb7fbm+MRSv93gOabhw/HvdYOl7PEfr5Gc2llqezi7wTLC3S9?=
 =?us-ascii?Q?uwktFQhCGP0VV5KBnCX+02yLEsuUV9QgSsHfgFxMtiILFgyQKx0ImMdUEldh?=
 =?us-ascii?Q?sR8L5cBxj5J7tg4MEqaGZu0p2d5Ok/9Zd3Fw3MT+eHyG0dtV/MRCXSMgghxj?=
 =?us-ascii?Q?lRyQQzM018YNyp0+F/i5EmVD8f2eSNOqeGgMh0+d1BcYHGGi4y9wTc1orlvj?=
 =?us-ascii?Q?8z+uTqxTWWx5SYTupTHqrHbpDJTKx4jY+ma2Ab+TQOvR17JpO1mVUiLTrdb+?=
 =?us-ascii?Q?9/9J724RJyxjz38m9eloZSkqdd/OuJqHTx+N/CH49JBm7RAKaNMinStjd9rn?=
 =?us-ascii?Q?WyHwWI6gtcyg63Htykq+lFY00RZ3aYHMphpuepbCQx1Z+We3l3dewE4Vx43b?=
 =?us-ascii?Q?2EI8jF1XMlqPfzOUbUmZVOYRqS/IJ3YQ+E1ncXy5aMmkNOzbhqoowUt2AGve?=
 =?us-ascii?Q?DiQaWuFpF98pszK+MUD7f+tLhMZZUaT72iSyPRw34U5v3JyPhycQvG0qfvfU?=
 =?us-ascii?Q?l5cQhucbKBXQlqVDVN4R1O6rkL5le/mZOsdfNgXdV3Q6mTbpraAaOR7oEBWl?=
 =?us-ascii?Q?jHBGtpstpzZEPu+aKbe78BeaDZ/cg3ghYY4n3VE/Cp26MUV+oejgHAZm4I+u?=
 =?us-ascii?Q?KEqWNUOVlgUkT0KLvHRsqw7QygYWNh5/4GX/tlKpDLn3CzIRC+rVukpPtGK6?=
 =?us-ascii?Q?1M8H5wGTR6GGW938pBcGCLPwMtCK2nkUylNgMrsI7bNEHUIten37ASTgLqFO?=
 =?us-ascii?Q?z8j/NMSyJ6jiLhKl8N1HmAYsoB3cNsAoWAe8HceZONe8swR7fneD9KXc+Gj7?=
 =?us-ascii?Q?MEjil9OGAF0xado7W3gPyNIsbgLA8IFpnbs6oh8K4G9SOXnFQ+++fE42w0iP?=
 =?us-ascii?Q?4dY8zAJ+QkaEzh2NFMeUJjG0YD5ycCjyhkR2qTaSL1aGVAxDxz4Bv95GHD7J?=
 =?us-ascii?Q?f5BKuXna6GKY292+8HX4O2YP20xMpnOuszBTaB4pk19jx9vNQZq9qSzQ08Kf?=
 =?us-ascii?Q?rdO2uMDIBxPiu9kQxl/shnD/VGNiLa8Z/p1P8OphZBm+1pcwWlYk3lpV9oQm?=
 =?us-ascii?Q?zyXLkcGlzaTsA9kwOZ0QmtY2J5DaLPQzZdigV5RJvaut4wtNC2zf2knGG4s1?=
 =?us-ascii?Q?80s0B64LYgVc78ShxHt4h1GTGZqafZvAvZjO4e1by6gCbtR6HutNJ8QWI4H8?=
 =?us-ascii?Q?Xv24tmHsrSyvTNutWTXLORzMKZCq9jSHK7hf1DnV7bqD1prffcOSaLJeqh2m?=
 =?us-ascii?Q?2flRHg3rnjkNTiE8cd7HH8HCrWwp6oaQQTznN7nbJO8NbS0kRk1XHobsv5SQ?=
 =?us-ascii?Q?MR+UEftIrFTTCBsdCMLAhmh8xh1Y0xWjPZzWLadTemvI1NzjPX9O1bhIQGJk?=
 =?us-ascii?Q?iKTdWP6CyG8/0v49cK+93rYW/eqd7s9Dwx++zMojzO6hHbifBaoXBvx2M64E?=
 =?us-ascii?Q?uugwXf1F8JDKvhc2ZgOa4gJqgjCSLCSujIJ7DPZIqZeoPyIlN6WtHzZZ19NM?=
 =?us-ascii?Q?PGRWZg0dzv58h6zduF9e1hZ5Yu29Hj2CH60vy16YeoFjxAA/kA3L6xOyqgv5?=
 =?us-ascii?Q?r6/JRNKr+aGn0hx9kcvi8GVPXGwelyNXoafb0e03?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: c16ccffc-50db-421a-7b08-08dc8e7dbd13
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jun 2024 03:29:47.3975
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: grEFWJP3ZfsHu9JBkvj7gEq+Ov8tU5oTfPcalzRoH76hKFr5GuPL7uJ0l0eCzm6RO8nS/s1ppy+JfDrAZcSybA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7766
X-OriginatorOrg: intel.com

> From: Zeng, Xin <xin.zeng@intel.com>
> Sent: Monday, June 10, 2024 10:38 PM
>=20
> When CONFIG_PCI_IOV=3Dn, the build of the QAT vfio pci variant driver
> fails reporting the following linking errors:
>=20
>     ERROR: modpost: "qat_vfmig_open" [drivers/vfio/pci/qat/qat_vfio_pci.k=
o]
> undefined!
>     ERROR: modpost: "qat_vfmig_resume"
> [drivers/vfio/pci/qat/qat_vfio_pci.ko] undefined!
>     ERROR: modpost: "qat_vfmig_save_state"
> [drivers/vfio/pci/qat/qat_vfio_pci.ko] undefined!
>     ERROR: modpost: "qat_vfmig_suspend"
> [drivers/vfio/pci/qat/qat_vfio_pci.ko] undefined!
>     ERROR: modpost: "qat_vfmig_load_state"
> [drivers/vfio/pci/qat/qat_vfio_pci.ko] undefined!
>     ERROR: modpost: "qat_vfmig_reset" [drivers/vfio/pci/qat/qat_vfio_pci.=
ko]
> undefined!
>     ERROR: modpost: "qat_vfmig_save_setup"
> [drivers/vfio/pci/qat/qat_vfio_pci.ko] undefined!
>     ERROR: modpost: "qat_vfmig_destroy"
> [drivers/vfio/pci/qat/qat_vfio_pci.ko] undefined!
>     ERROR: modpost: "qat_vfmig_close" [drivers/vfio/pci/qat/qat_vfio_pci.=
ko]
> undefined!
>     ERROR: modpost: "qat_vfmig_cleanup"
> [drivers/vfio/pci/qat/qat_vfio_pci.ko] undefined!
>     WARNING: modpost: suppressed 1 unresolved symbol warnings because
> there were too many)
>=20
> Make live migration helpers provided by QAT PF driver always available
> even if CONFIG_PCI_IOV is not selected. This does not cause any side
> effect.
>=20
> Reported-by: Arnd Bergmann <arnd@arndb.de>
> Closes:
> https://lore.kernel.org/lkml/20240607153406.60355e6c.alex.williamson@re
> dhat.com/T/
> Fixes: bb208810b1ab ("vfio/qat: Add vfio_pci driver for Intel QAT SR-IOV =
VF
> devices")
> Signed-off-by: Xin Zeng <xin.zeng@intel.com>
> Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

