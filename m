Return-Path: <kvm+bounces-22895-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3243E9445C6
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 09:46:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B63781F2417F
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 07:46:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9500616DEA5;
	Thu,  1 Aug 2024 07:45:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IzVOn76F"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE43F16DC12
	for <kvm@vger.kernel.org>; Thu,  1 Aug 2024 07:45:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722498349; cv=fail; b=YUIfxTFO24QgxKY4HhMKkptMCV5qoE3ue15QdBH3jKbkROCvVwgKjCWf7AXhXyaCnONCHZEzGXMsmx/8Qv7ogT7NC/YJIm07P6BbAkMZXUo3kt1qS3CgGp0NbxtOXyEHSo1gJejkQF7WdD89jt69VCQreqSndOgoCLVXRIGvfVI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722498349; c=relaxed/simple;
	bh=2elq0fy6t+ENQSsmNIgqfRPbvWjQeS9A1L+/NKRc1xA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=oDRRU7hw7urE7UtDWON7VEJZmo1m9nC5pHCBxtDfI3nxU12ZsipV6k6GB+bdI8hxlf+/8bTIuiM0qqsIZff43mbevWzzQQ5Tcwdsol0Rl8y1Q4F7HGlCtdd7lMXrBFBnYOw6yii1WwxDNO4xJpYJl7Mp2lZBJ3RwG5BE5IBSyps=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IzVOn76F; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1722498348; x=1754034348;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=2elq0fy6t+ENQSsmNIgqfRPbvWjQeS9A1L+/NKRc1xA=;
  b=IzVOn76FoPsdE9ssGoV283V4AZLyVcHi8aZyFkEB30YTZnZqGBgL3FBQ
   FzDY9jNlqBnJwEkuqkjPULgtveMloTCclvvUPpwZaE0m9OeomabrZKlVV
   cs3w9qB3bYjNXHb0ZX2tPucU+cYQ2yfJ1b3Lg0FTshSW/+XFfWaQFT3I3
   1pHxVqqCXBdOCt7IK5ZOGJP2VOlg6WBK/fA7RF7TWUNLL0DlFWCn/pKJ9
   0lnZrfHGXAJtQs7IZaYGtemR4yMnt4/B2rRt6CHaxOA8WYjhe+84EeCoP
   HnUJ/PaszG7l/qvsFkkciNKxBLxS7P00bmxxyD9uv8jHPYfwH8+R41t7m
   g==;
X-CSE-ConnectionGUID: 1P486U6PQxuuA+MEdkBlwg==
X-CSE-MsgGUID: jWPna976RWGNd4f/bO3lGA==
X-IronPort-AV: E=McAfee;i="6700,10204,11150"; a="20592787"
X-IronPort-AV: E=Sophos;i="6.09,253,1716274800"; 
   d="scan'208";a="20592787"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Aug 2024 00:45:48 -0700
X-CSE-ConnectionGUID: eef2+05iTJm0DTcPoUasdw==
X-CSE-MsgGUID: H0iXmQXPQySsjxSlNPjPJw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,253,1716274800"; 
   d="scan'208";a="59601985"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa004.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 01 Aug 2024 00:45:47 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 1 Aug 2024 00:45:46 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 1 Aug 2024 00:45:46 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 1 Aug 2024 00:45:46 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 1 Aug 2024 00:45:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=k1SoDEI33IB4UxK9u11IxJyFeyG8jGNiYRhTSSa6B5rqKD79rWCg0P6osQ5B600PdrtwQDrpmUWTacnx/tI3kfadDsgTUotpM1mLjrfSoXjWF2nDxxwd0STEDOcp1+ZakmJoqigEm8YPImAeWDHM5/V0iG7FTL0/4VWpFm+nYW5RRzKOzCGeeLZK36MX64L+q4anSeQih9rhWxDg1bRAx2XZc+kbS0+Hu2YKfH1wlH49mjT4iBVkDBjIT0ZncjmJC2aSCSkah78JA+btKh1bOin/VuMOdROgGNfsUyIxW3osfy7027Y5m1VT+IXLD8FCNYzshNgAcL4VCdrSMf9L5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cOxZa/S2fr8dL9YoKxzAxHSiV04Q2zhjlQNnY+5+p3Q=;
 b=BI+QDhtKGGX5ZNBMXRrPRqFEclbHdY+DQNnlY9RIrJ6iunf4fj1v3M7bfklA9deN6MK4hbTzZV2c/eyLMvgwe3m5G1ncBoPegNQHF7xqbdiCmiZCZKjRxPocY27jfdLijmnYW6N5J4N89aJFrA9K9DlMnxe//BySSeiYfSI5MYXgLFz4Qso0NRkTxuKUy0AytsnIqi0hhU4LcPShgzPxun97Wm3BGmNz0LEAFUXFi7cgKHvhNm2BV/q16jMXUNSU/Hb8oFj812brJ5rKxL7Pt0UMu9TUWOK7qknt7KCcBMBzCFT90MzD6/gVFfR+F1Q051ML0JcUG9LSRYPGF8I6PQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by CH0PR11MB5267.namprd11.prod.outlook.com (2603:10b6:610:e2::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7807.28; Thu, 1 Aug
 2024 07:45:44 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%3]) with mapi id 15.20.7828.021; Thu, 1 Aug 2024
 07:45:43 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Alex Williamson <alex.williamson@redhat.com>
CC: Jason Gunthorpe <jgg@nvidia.com>, "Liu, Yi L" <yi.l.liu@intel.com>,
	"joro@8bytes.org" <joro@8bytes.org>, "robin.murphy@arm.com"
	<robin.murphy@arm.com>, "eric.auger@redhat.com" <eric.auger@redhat.com>,
	"nicolinc@nvidia.com" <nicolinc@nvidia.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "chao.p.peng@linux.intel.com"
	<chao.p.peng@linux.intel.com>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, "baolu.lu@linux.intel.com"
	<baolu.lu@linux.intel.com>, "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
	"Pan, Jacob jun" <jacob.jun.pan@intel.com>,
	=?iso-8859-1?Q?C=E9dric_Le_Goater?= <clg@redhat.com>
Subject: RE: [PATCH v2 0/4] vfio-pci support pasid attach/detach
Thread-Topic: [PATCH v2 0/4] vfio-pci support pasid attach/detach
Thread-Index: AQHajLJtgFipqDFp5kGVxfWLZ+e8jbFqmBhwgACbmQCAANtx0IAAWtiAgACzNgCAAAsdMIAAnMyAgADCDYCAAJZRIIAAuGoAgAWh6eCAAFrQgIAAvzfAgAAM8ICAATEtgIAAA00AgAAbNoCAAr9fgIAAZVAAgASNTwCAhOTNIIALrw6AgACT05CAAPXvAIAA2q0A
Date: Thu, 1 Aug 2024 07:45:43 +0000
Message-ID: <BN9PR11MB5276BEBDDD6720C2FEFD4B718CB22@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240419103550.71b6a616.alex.williamson@redhat.com>
	<BN9PR11MB52766862E17DF94F848575248C112@BN9PR11MB5276.namprd11.prod.outlook.com>
	<20240423120139.GD194812@nvidia.com>
	<BN9PR11MB5276B3F627368E869ED828558C112@BN9PR11MB5276.namprd11.prod.outlook.com>
	<20240424001221.GF941030@nvidia.com>
	<20240424122437.24113510.alex.williamson@redhat.com>
	<20240424183626.GT941030@nvidia.com>
	<20240424141349.376bdbf9.alex.williamson@redhat.com>
	<20240426141117.GY941030@nvidia.com>
	<20240426141354.1f003b5f.alex.williamson@redhat.com>
	<20240429174442.GJ941030@nvidia.com>
	<BN9PR11MB5276C4EF3CFB6075C7FC60AC8CAA2@BN9PR11MB5276.namprd11.prod.outlook.com>
	<20240730113517.27b06160.alex.williamson@redhat.com>
	<BN9PR11MB5276D184783C687B0B1B6FE68CB12@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240731110436.7a569ce0.alex.williamson@redhat.com>
In-Reply-To: <20240731110436.7a569ce0.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|CH0PR11MB5267:EE_
x-ms-office365-filtering-correlation-id: e7d36952-6be0-4268-dd9a-08dcb1fdf2d6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016|38070700018;
x-microsoft-antispam-message-info: =?iso-8859-1?Q?PoW3IIYcAfFw5u+a9WcG8oi7hRtMAjEfc/EXruziT0K3uw7qZG22XLX1aL?=
 =?iso-8859-1?Q?L7Vk+DtJobctbszTCJ16TbWNs1wcXQ1HT/niSWtBGj4OPGczxyogZPawaA?=
 =?iso-8859-1?Q?cgayuQeB/VyxVvg/Mb06cekBI9lXUTOyHGUOajSjXmmtruviMUC3a4RiV6?=
 =?iso-8859-1?Q?oDtrCelytXPbsQG6jVl+r7mIdgV6Pukgse1TcichH6yKS/AmjcvT9yOJpN?=
 =?iso-8859-1?Q?R3Wcd0jhanw8RSp/h6dscq6UxOt580gPWOnm3sIR7GjdAtYkH3OOy0zcDa?=
 =?iso-8859-1?Q?5Mv7u1iLd1mKIvkzV9aDbjoZJtQaj2wALSLOCUmtqdfN7O9JBa83aCZ0H4?=
 =?iso-8859-1?Q?QS44U3FKgLNIHwjIzoox623Se8wxsKW+nYm1BWiwkEB1Y68q4spj9mKI4v?=
 =?iso-8859-1?Q?lcFyEP/nvCP5Jeua7u/KkyI2rJeI3zg797JH5Ck1KHlRkff1TYMhlds4tM?=
 =?iso-8859-1?Q?it0RvJVkhP/dL5tpIqz+rgYhh2GVB+XGfBs0vU/zaRJS0T2Xp5BeEUzvGD?=
 =?iso-8859-1?Q?xgAn+kHn1bOJp59ss1EO1cFD8vdfarXRolWqke2TMbwrvAPuYAcCPKAcPk?=
 =?iso-8859-1?Q?BIWeobCnoVZ1qpedAeNuWA9kNggkPeFKLG7Ft+XEpRCg0751dm7Qmkeq4A?=
 =?iso-8859-1?Q?QUIiY7B9gylmgr19bIhhFc03UOJhGy9hvdT8XK2xG//Ju40F+WZ53ipWO+?=
 =?iso-8859-1?Q?Kesk1t7G/EwlViAgmRJT0v375EGhvYMQ6D33Siu9juXnYWnkOJnSm9/+GZ?=
 =?iso-8859-1?Q?79PJ8efzqt5klomiS/IzGtIThWvn6ZYF0pCWefPiO9uLKLQkOFm0/Gmev3?=
 =?iso-8859-1?Q?YKGCzz3J+KlM8nag1UessQy/Ve9SGapMW0gAM8VdDOcpbtIWwiAIsWF24K?=
 =?iso-8859-1?Q?ngucUXC+Mikvm6uMnwANBHmUnli8dYJaBndBxqbuiHDQDrQHkWmHwQnZeA?=
 =?iso-8859-1?Q?EFkUEIPnfbsxyvzyfApIGSVJyH82a5nE7tzgHNpBYaOynDMx5CgyNp30+8?=
 =?iso-8859-1?Q?/et+KgH6Pi/YjG96BMca2qs5zy/bWmAtzV+/cnrmxN79hBozV71a4LJxoU?=
 =?iso-8859-1?Q?GW5rSdZpzldotOqaKGiNKYUfmUxnfQzxZLVKPNJUcF89JwQkHKH2LfXpKJ?=
 =?iso-8859-1?Q?Z3nzao/O9SnubwpBgblbqvT3OmgBpbki8Pk5ARf3Q0XtjMvlI9Gw1PCXtC?=
 =?iso-8859-1?Q?/QjD77EdxR3YbIgwUq3OtjaY3vc9a8tFXzXISDYZU7F1/xlBtDYxQ3fskp?=
 =?iso-8859-1?Q?6RGdtEpp8gyR2hFDNyfIerWgxj/qpessr1TKJuJLGL3EcAcGrp22islBPc?=
 =?iso-8859-1?Q?EcG8oaAMYWzb3gFqFToQoMArQvwBsVzERz040gD157CkFrslcugvlfDRp1?=
 =?iso-8859-1?Q?YosFEGJYA44qzJYuH9NXg1C0VP4N18+qh6hulZ4wv0WjfpfD4OJ90=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?El7VxaftxRTeJse8NuteFg/igCsqG7staZ1+MrAe4mA88MNxfbBugXRoGU?=
 =?iso-8859-1?Q?O4mDgwOIJWfWjAYt3wYGtkPvUemY4dne84PtpuMiyzktSWdcEj9UvXU1K+?=
 =?iso-8859-1?Q?Zm6MCS0LyydgWocUjolVh5b85TqJOhvE0w8+59/z//L1tgoxAWuxQtZbLI?=
 =?iso-8859-1?Q?K+c4mch1jE0QiWElQVZa8Kjuo0zQarMD7Zr5cTK5gN+Ll06VSBxg8XNDds?=
 =?iso-8859-1?Q?9d9j3XBCb6sAez6rbZMGTK/vuAijRfPAelaeNqfl0r1He2aZTAvzUc+lrj?=
 =?iso-8859-1?Q?VEx1QvV46JO68h8Z7crCdMy9i4iHH1my/b49XPiWAXLqkpGgE+esnA4n5b?=
 =?iso-8859-1?Q?5kL85uQ2WeWGJ6FSr6YhNNOSAgzHimQRWzclXKd2XGWyFiTZjh4Rs19HQZ?=
 =?iso-8859-1?Q?2aMT3fQhD/xmfla0zgkQrnDpcdx2KxWD+9CLBiz4087T73/Dwb4UFpX8OZ?=
 =?iso-8859-1?Q?broKWhPFpERzzJ1ksbBr67KOQ+9GF7T849jtKfvXzQJndQnwAUs5f6HyJK?=
 =?iso-8859-1?Q?Ijio2Tqrhle8HoaaxxX6Pl+5fcBNW/HvSgFsNFTJwT8CoIC3+fDU559SPv?=
 =?iso-8859-1?Q?uNOzRnqul7nbD6WV87u32Un4oZqsg6V2vQUNfaj/7k5d25VxblASjq2dSt?=
 =?iso-8859-1?Q?V6lr0qvZa5QjA+ndMhEMuSkqxuJPoYxtGYcsnyiUD4GVO8uOtrCkonqrTP?=
 =?iso-8859-1?Q?e55VN+cautk/Ilb8pRRzqiHZWsjOEP+rL0Ajh5Lq8TpM7DK1rTOn9nuAwP?=
 =?iso-8859-1?Q?YwHKDlkISJRwiDNIuTh+p098p0Bmym/RZ3zoLXJB2voiTFtM8gNVdIIaAV?=
 =?iso-8859-1?Q?4zweUbLEGgXVqe9pyATZOp1Y1IyfSTfHhZDMOC//zX0wpKYvIsTGLT6ZaQ?=
 =?iso-8859-1?Q?/Z3OJvi6uHcxANMPLAbXxfk7hnVUw0KlZxdjzyR/HHa10hHt2mQZDh2IAt?=
 =?iso-8859-1?Q?Vye9fLAfUoFbrk4s0MGdnN58b56rUudBuyv3S4CeiehCnrLduUdocSUKS/?=
 =?iso-8859-1?Q?HaTsepzGCOQihAr8MHqwrowlMkEviDH//cb9/ZYcD6j1/FJxBjfQSBmjqJ?=
 =?iso-8859-1?Q?DYleW7h4ECt9o/eDi1y7+GK57JrWtdhkkA79dl7oIziSdjrTLjX6JXp0Jg?=
 =?iso-8859-1?Q?o9bzNyp1ZMiW21oeE7EKDEXEu7/uXaAQJ0775thbxHeCd57GzjjR5O+6wN?=
 =?iso-8859-1?Q?NrliOk0KIPqVnF/FoTTh3SrXvrdVUr8pPvqMtMgClxmirXGrC3LiSkWZWw?=
 =?iso-8859-1?Q?WDg9eeYEH0NM/agROeBJDmqlnWsCh0plKZcsquXf1y8am5V8sEX0ue8Rlb?=
 =?iso-8859-1?Q?UwuzD3Bi1IgXYVKyxGsQYZYIbTYfB8iKwFiiyudMuQLo5OW2BrAAGxKnC7?=
 =?iso-8859-1?Q?20zl9l/9yB/ND0kGN8FJX8A7L02FqB0GDwjgEIobYvPeVmlKEeCecDOSya?=
 =?iso-8859-1?Q?7cxWGLgpAgHV7VYRLuL4YwhZf0pA+Twz+P+xW5nwkSogf3yVNLm5EkLvl4?=
 =?iso-8859-1?Q?vlwQTCx5+TdyfPwc1xyWLQYHjuclF7Ftik3buGZKoghYASiaD2/qRwlHCJ?=
 =?iso-8859-1?Q?DVFsRPLI1k7mnFbXM78OnAe/Wu0q84wpafRzA7UrK6hOnNhUMD4dor9SHz?=
 =?iso-8859-1?Q?f8b34zD/A6u3pWeLkv7TXPOLLrQ8blDwye?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7d36952-6be0-4268-dd9a-08dcb1fdf2d6
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Aug 2024 07:45:43.8654
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: d/ZV1o6E7ZSkdupYQcnUnerX1QJ87JUvDtuiix9FLuWqKUH9dMiLkq5jIZwkAAWyK9If0n1N6N5l7hSv4KLDAw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5267
X-OriginatorOrg: intel.com

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Thursday, August 1, 2024 1:05 AM
>=20
> On Wed, 31 Jul 2024 05:15:25 +0000
> "Tian, Kevin" <kevin.tian@intel.com> wrote:
>=20
> > > From: Alex Williamson <alex.williamson@redhat.com>
> > > Sent: Wednesday, July 31, 2024 1:35 AM
> > >
> > >  - Seamless live migration of devices requires that configuration spa=
ce
> > >    remains at least consistent, if not identical for much of it.
> >
> > I didn't quite get it. I thought being consistent means fully identical
> > config space from guest p.o.v.
>=20
> See for example:
>=20
> https://gitlab.com/qemu-project/qemu/-
> /commit/187716feeba406b5a3879db66a7bafd687472a1f

Thanks!

>=20
> The layout of config space and most of the contents therein need to be
> identical, but there are arguably elements that could be volatile which
> only need to be consistent.

hmm IMHO it's more that the guest doesn't care volatile content in that
field instead of the guest view being strictly consistent. Probably I
don't really understand the meaning of consistency in this context...

btw that fix claims:

  "
  Here consistency could mean that VSC format should be same on
  source and destination, however actual Vendor Specific Info may
  not be byte-to-byte identical.
  "

Does it apply to all devices supporting VSC? It's OK for NVDIA vGPU
but I'm not sure whether some vendor driver might be sensitive to
byte-to-byte consistency in VSC.

> > >
> > >  - We've discussed in the community and seem to have a consensus that=
 a
> > >    DVSEC (Designated Vendor Specific Extended Capability) could be
> > >    defined to describe unused configuration space.  Such a DVSEC coul=
d
> > >    be implemented natively by the device or supplied by a vfio-pci
> > >    variant driver.  There is currently no definition of such a DVSEC.
> >
> > I'm not sure whether DVSEC is still that necessary if the direction is
> > to go userspace-defined layout. In a synthetic world the unused
> > physical space doesn't really matter.
> >
> > So this consensus IMHO was better placed under the umbrella of
> > the other direction having the kernel define the layout.
>=20
> I agree that we don't seem to be headed in a direction that requires
> this, but I just wanted to include that there was a roughly agreed upon
> way for devices and variant drivers to annotate unused config space
> ranges for higher levels.  If we head in a direction where the VMM
> chooses an offset for the PASID capability, we need to keep track of
> whether this DVSEC comes to fruition and how that affects the offset
> that QEMU might choose.

Yes. We can keep this option in case there is a demand, especially
if the file-based synthesized scheme won't be built in one day and
we need a default policy in VMM.

>=20
> > > So what are we trying to accomplish here.  PASID is the first
> > > non-device specific virtual capability that we'd like to insert into
> > > the VM view of the capability chain.  It won't be the last.
> > >
> > >  - Do we push the policy of defining the capability offset to the use=
r?
> >
> > Looks yes as I didn't see a strong argument for the opposite way.
>=20
> It's a policy choice though, so where and how is it implemented?  It
> works fine for those of us willing to edit xml or launch VMs by command
> line, but libvirt isn't going to sign up to insert a policy choice for
> a device.  If we get to even higher level tools, does anything that
> wants to implement PASID support required a vendor operator driver to
> make such policy choices (btw, I'm just throwing out the "operator"
> term as if I know what it means, I don't).

I had a rough feeling that there might be other usages requiring such
vendor plugin, e.g. provisioning VF/ADI may require vendor specific
configurations, but not really an expert in this area.

Overall I feel most of our discussions so far are about VMM-auto-
find-offset vs. file-based-policy-scheme which both belong to
user-defined policy, suggesting that we all agreed to drop the other
way having kernel define the offset (plus in-kernel quirks, etc.)?

Even the said DVSEC is to assist such user-defined direction.

>=20
> > >  - Do we do some hand waving that devices supporting PASID shouldn't
> > >    have hidden registers and therefore the VMM can simply find a gap?
> >
> > I assume 'handwaving' doesn't mean any measure in code to actually
> > block those devices (as doing so likely requires certain denylist based=
 on
> > device/vendor ID but then why not going a step further to also hard
> > code an offset?). It's more a try-and-fail model where vPASID is opted
> > in via a cmdline parameter then a device with hidden registers may
> > misbehave if the VMM happens to find a conflict gap. And the impact
> > is restricted only to a new setup where the user is interested in
> > PASID  to opt hence can afford diagnostics effort to figure out the
> restriction.
>=20
> If you want to hard code an offset then we're effectively introducing a
> device specific quirk to enable PASID support.  I thought we wanted
> this to work generically for any device exposing PASID, therefore I was
> thinking more of "find a gap" as the default strategy with quirks used
> to augment the resulting offset where necessary.
>=20
> I'd also be careful about command line parameters.  I think we require
> one for the vIOMMU to enable PASID support, but I'd prefer to avoid one
> on the vfio-pci device, instead simply enabling support when both the
> vIOMMU support is enabled and the device is detected to support it.
> Each command line option requires support in the upper level tools to
> enable it.

Make sense. btw will there be a requirement that the user wants to
disable PASID even if the device supports it, e.g. for testing purpose
or to workaround a HW errata disclosed after host driver claims the
support in an old kernel?

> > >
> > > I understand the desire to make some progress, but QEMU relies on
> > > integration with management tools, so a temporary option for a user t=
o
> > > specify a PASID offset in isolation sounds like a non-starter to me.
> > >
> > > This might be a better sell if the user interface allowed fully
> > > defining the capability chain layout from the command line and this
> > > interface would continue to exist and supersede how the VMM might
> > > otherwise define the capability chain when used.  A fully user define=
d
> > > layout would be complicated though, so I think there would still be a
> > > desire for QEMU to consume or define a consistent policy itself.
> > >
> > > Even if QEMU defines the layout for a device, there may be multiple
> > > versions of that device.  For example, maybe we just add PASID now, b=
ut
> > > at some point we decide that we do want to replicate the PF serial
> > > number capability.  At that point we have versions of the device whic=
h
> > > would need to be tied to versions of the machine and maybe also
> > > selected via a profile switch on the device command line.
> > >
> > > If we want to simplify this, maybe we do just look at whether the
> > > vIOMMU is configured for PASID support and if the device supports it,
> >
> > and this is related to the open which I raised in last mail - whether w=
e
> > want to report the PASID support both in iommufd and vfio-pci uAPI.
> >
> > My impression is yes as there may be requirement of exposing a virtual
> > capability which doesn't rely on the IOMMU.
>=20
> What's the purpose of reporting PASID via both iommufd and vfio-pci?  I
> agree that there will be capabilities related to the iommufd and
> capabilities only related to the device, but I disagree that that
> provides justification to report PASID via both uAPIs.  Are we also
> going to ask iommufd to report that a device has an optional serial
> number capability?  It clearly doesn't make sense for iommufd to be

Certainly no. My point was that vfio-pci/iommufd each reports its
own capability set. They may overlap but this fact just matches the
physical world.

> involved with that, so why does it make sense for vfio-pci to be
> involved in reporting something that is more iommufd specific?

It doesn't matter which one involves more. It's more akin to the
physical world.

btw vfio-pci already reports ATS/PRI which both rely on iommufd
in vconfig space. Throwing PASID alone to iommufd uAPI lacks of a
good justification for why it's special.

I envision an extension to vfio device feature or a new vfio uAPI
for reporting virtual capabilities as augment to the ones filled in
vconfig space.=20

>=20
> > > then we just look for a gap and add the capability.  If we end up wit=
h
> > > different results between source and target for migration, then
> > > migration will fail.  Possibly we end up with a quirk table to overri=
de
> > > the default placement of specific capabilities on specific devices.
> >
> > emm how does a quirk table work with devices having volatile config
> > space layout cross FW versions? Can VMM assigned with a VF be able
> > to check the FW version of the PF?
>=20
> If the VMM can't find the same gap between source and destination then
> a quirk could make sure that the PASID offset is consistent.  But also
> if the VMM doesn't find the same gap then that suggests the config
> space is already different and not only the offset of the PASID
> capability will need to be fixed via a quirk, so then we're into
> quirking the entire capability space for the device.

yes. So the quirk table is more for fixing the functional gap (i.e. not
overlap with a hidden register) instead of for migration. As long as
a device can function correctly with it, the virtual caps fall into the
same restriction as physical caps in migration i.e. upon inconsistent
layout between src/dest we'll need separate way to synthesize the
entire space.

>=20
> The VMM should not be assumed to have any additional privileges beyond
> what we provide it through the vfio device and iommufd interface.
> Testing anything about the PF would require access on the host that
> won't work in more secure environments.  Therefore if we can't
> consistently place the PASID for a device, we probably need to quirk it
> based on the vendor/device IDs or sub-IDs or we need to rely on a
> management implied policy such as a device profile option on the QEMU
> command line or maybe different classes of the vfio-pci driver in QEMU.
>=20
> > > That might evolve into a lookup for where we place all capabilities,
> > > which essentially turns into the "file" where the VMM defines the ent=
ire
> > > layout for some devices.
> >
> > Overall this sounds a feasible path to move forward - starting with
> > the VMM to find the gap automatically if a new PASID option is
> > opted in. Devices with hidden registers may fail. Devices with volatile
> > config space due to FW upgrade or cross vendors may fail to migrate.
> > Then evolving it to the file-based scheme, and there is time to discuss
> > any intermediate improvement (fixed quirks, cmdline offset, etc.) in
> > between.
>=20
> As above, let's be careful about introducing unnecessary command line
> options, especially if we expect support for them in higher level
> tools.  If we place the PASID somewhere that makes the device not work,
> then disabling PASID on the vIOMMU should resolve that.  It won't be a

vIOMMU is per-platform then it applies to all devices behind, including
those which don't have a problem with auto-selected offset. Not sure
whether one would want to continue enabling PASID for other devices
or should stop immediately to find a quirk for the problematic one and
then resume.

> regression, it will only be an incompatibility with a new feature.
> That incompatibility may require a quirk to resolve to have the PASID
> placed somewhere else.  If the PASID is placed at different offsets
> based on device firmware or vendor then the location of the PASID alone
> isn't the only thing preventing migration and we'll need to introduce
> code for the VMM to take ownership of the capability layout at that
> point.  Thanks,
>=20

Yes, the migration issue might be solved in a separate track as it applies
to both physical and virtual capabilities.

