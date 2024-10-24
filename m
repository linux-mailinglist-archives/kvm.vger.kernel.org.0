Return-Path: <kvm+bounces-29600-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 87E8C9ADE4D
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 09:54:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 408F7281195
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 07:54:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B68E21AD403;
	Thu, 24 Oct 2024 07:54:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="me0/oVr+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3814198E9B;
	Thu, 24 Oct 2024 07:54:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729756462; cv=fail; b=by+nxl5zBX4GqZM9SCtxpUXFKLmlhF6LxQfC4vLJdvl/7w0EYj1r5nVnyPvcFi79k79/ABWVkwsWeXON/o763HUFPrwD/MpJzcCeYo5XyZs+IZxvSkXO8fOSZUTB+NFK67TP9rTdGl1cpW17cECj84dPIXCZYCxtwr7NhS0HRtc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729756462; c=relaxed/simple;
	bh=V0QDtFO/JMIFlr8JK3dEhj+Al6CAcPpKkl4tv0a6DQw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=IY3dyqZHypgPzEWPzbqPd6CU3AtnlDON9mfz1paYmKEOZ0pcnSDMmpE4CCnkAA7BaJ3ltOJxlNhS5Br2DMiYWQuvhSs/iv4b/VF41NN85jiX1Sryc0fdUqPUw2FxUJDha7v9bDEhb1Y1JEh2Dii0p7NDlcn/HFBh1s4+WvMjrJE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=me0/oVr+; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1729756461; x=1761292461;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=V0QDtFO/JMIFlr8JK3dEhj+Al6CAcPpKkl4tv0a6DQw=;
  b=me0/oVr+e3rZuHX9Cs/Yj2Riyi6y8MHtvdSHj0u0urRVlEkJPnkZhXyS
   cgsnm9+AH/aTZLfRAglN/wkGoPlOGTS0TcDt0Xc37t/X4+BARF9qVJjds
   i/WmzkFxcIGC01q4pjauMyzZvp+9qWkysTHqIADF7uhQvy/CMvKGRCDJ+
   ylAUUc5cL6Sx8mDarSGbIQv5za3+Cs5Mrz0pG9xrFuK/U/IzMxuQTDvEO
   ggl92LueUnoljBxPHZR26eS2TaolDh5pUYdKyAyzNN1+b413VeIOvuYwl
   T4TIeZ1qFszmuwZLSZ0L8lo1Wrv+rqsEzfhezx/8ecq3MN2GrKs37WDEt
   g==;
X-CSE-ConnectionGUID: F0o/Qn14TIKd1B8imBDZUQ==
X-CSE-MsgGUID: bdzlomXBQomkuDk8McdFtA==
X-IronPort-AV: E=McAfee;i="6700,10204,11234"; a="33175615"
X-IronPort-AV: E=Sophos;i="6.11,228,1725346800"; 
   d="scan'208";a="33175615"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2024 00:54:21 -0700
X-CSE-ConnectionGUID: MbgJwSx8RviUq1K28nXQTQ==
X-CSE-MsgGUID: KjhJJVd6TTelQ/VfdOyA9A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,228,1725346800"; 
   d="scan'208";a="80101316"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 24 Oct 2024 00:54:19 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 24 Oct 2024 00:54:18 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 24 Oct 2024 00:54:18 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.175)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 24 Oct 2024 00:54:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=N+ESbxZmHYIuuLBKWd4VQVH2/medN3PZR+A6cBBz+51eSBiIUsAzY6afHKmayCBaQjQdXUBA9+RFAn+0si1WTjEcXiCK4zjz24J0CA3bP+KgP84xEjgD6mOCsE/6nGpz9r97qNSSEd6OdGt3Wgi+Bel0Vvf0wQCUfOZsfQUKMBs9tfHQ9XBJ9AjcoyOeg1xY8oRydWFWgMl0VpF2jP67zjdhuY5vPjbXg+AZtbMU79wnWyfBpWAHsIEIGteXPxx8gY+7hCJwpOsb4j7WZauHydkc4BIz0sr00Y3phuoyLOTPQbp6jKQjwJ6OHEEPfL17o1NeYRWKAMtb6MVnJYbJDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mpqMk2dQLlsNj8IRz1WeyCttR5cnVPDVT+UahenLEh0=;
 b=JnsS4hZrPNDq6HLj9iEMswYw22RZEZBMEWF+GHeCcekkUS8qvlr+88Uutvu+vSCevk3EpG7rgzvnhLqsaXU/swpMy8k1uiGlrHnN6YOrC45ZMPvo5BsKFpB+LRCY6ti1qAZv5sjKZejyTQn0mDLYckgjdlM7P6VTX0PprZKqvWzrElUKUZqaZRYoGncoC4vAXulBWGI5W+Bxgy3+/lrh4odpEcV8ITgru1lKeN2YXzbKDn6Hd1ctz8Nb6iqG4kg66AEhF5qWuXe8C0I3JfPsGQR0pCDIztJiTbGlPa6BhiW6RGdXP9vBxGUMn69qECUZzMPi5xvFycrYctMHAaWseQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BY1PR11MB8056.namprd11.prod.outlook.com (2603:10b6:a03:533::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.18; Thu, 24 Oct
 2024 07:54:11 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%6]) with mapi id 15.20.8093.018; Thu, 24 Oct 2024
 07:54:10 +0000
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
	<patches@lists.linux.dev>, "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>, "Mostafa
 Saleh" <smostafa@google.com>
Subject: RE: [PATCH v3 9/9] iommu/arm-smmu-v3: Use S2FWB for NESTED domains
Thread-Topic: [PATCH v3 9/9] iommu/arm-smmu-v3: Use S2FWB for NESTED domains
Thread-Index: AQHbGmeggfhRQtBEeEG2NWkBBDuT57KVnl2A
Date: Thu, 24 Oct 2024 07:54:10 +0000
Message-ID: <BN9PR11MB5276A5BCD028849E1658416D8C4E2@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v3-e2e16cd7467f+2a6a1-smmuv3_nesting_jgg@nvidia.com>
 <9-v3-e2e16cd7467f+2a6a1-smmuv3_nesting_jgg@nvidia.com>
In-Reply-To: <9-v3-e2e16cd7467f+2a6a1-smmuv3_nesting_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|BY1PR11MB8056:EE_
x-ms-office365-filtering-correlation-id: 490da002-da5f-409b-c745-08dcf4010bc0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|921020|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?JsNexZZLlyYZB1xNFO8GVd4ouSZCT7uCjz4K7Qf1baBUjms+GbTqSX1wIyP/?=
 =?us-ascii?Q?PAlTg0z21hTB/e/l7cFgvhnf2lI/QsiIK7pokH6gvDYQGx5gIfL3ic1X45tY?=
 =?us-ascii?Q?b8/WPFVN3rY3LVMnp+fqhLi3YH+NG5CNOFQjZxKwsXzNyT3H9HxCKAgdfDZ/?=
 =?us-ascii?Q?YQNrdTSjN3K1LIBbu1lcVMur6dSEZk4gFvOQXJ6Y8Q2oXcv6FsG2FD/rzkBs?=
 =?us-ascii?Q?SwrxoJF1/YpzbtqR62h05V+bagbc01AqTohcvZfVTs3L2Cvc3vtQMfYZruMw?=
 =?us-ascii?Q?nmzLxvEVkXFOXhY+5oP7vy/8HQq9HynU3uqS+ax4lW0tlGlUAqA8rLuU75pM?=
 =?us-ascii?Q?pn+Xu6dNeEvWaIorDzD1UoBmQRcghYvmYnREXUXfvzrc0fTX8yq7J0sjzE4e?=
 =?us-ascii?Q?h8BzKnmn6OvXjuIgBbve3DTkCQ8BsBAShlrnq2zRwKJs11ruW2HKy3qHNdrp?=
 =?us-ascii?Q?H4CNpbPa6czJf40xGH0XpH4/SQe8rAGXWs5sJeakBT4C6T5vHA6KRjh1n5SY?=
 =?us-ascii?Q?vY0jf/Wdfe1h6dZKMwl6otUYRGCnDHZgsz7c8pdT9dfYBH8HO6AIA0cTZQqC?=
 =?us-ascii?Q?t0tLyKatZKbcEktoIg9yAQq6bsG5GEvtoC14YgZrEgSSu2rYaq+tikGa5qhj?=
 =?us-ascii?Q?c9ReUoSM37cCWOHn7BBY7SW4uMug+k0ovH6nCy634BhTFQjOQ7N+rkhfUVDK?=
 =?us-ascii?Q?41u+eg1lHeHJoPQQBF/GYLJI8c4vV+/9qYOOJV0r5lHwXLi/MlTLv+pzOq+x?=
 =?us-ascii?Q?is4fEFYaNoigucmG1+ErdFa8KFTuYb7SxnX4yvvNSh4WFw71DB1k5hc4+0eW?=
 =?us-ascii?Q?5qDNt6fREnNlRVmijifb5X6EbiAd44PK37XZ8lfXrJ77y4R5cxCdemORBrtm?=
 =?us-ascii?Q?CPanTbrbKdKuMMoJ/SxOibf0bgV+4fYaAzNE4xebKyw0dr2scEnRT90y2nI6?=
 =?us-ascii?Q?vujxyYkp5Bf+zZ1Fp5uC4OUj+rkIGSXhAKYmA4dhmLSttZ4S4qGbFv6uRht9?=
 =?us-ascii?Q?7KDEwcOJkee9KEwsivGZ+IPuInoHuYrIhKT32vr3mTOi9SCWdSMAs57zTh8G?=
 =?us-ascii?Q?uFEILedTj0EnbVqe9pkTijjMfLE1CITZrUWxtF1B+7sB0FQuJEz4Nnvab6f7?=
 =?us-ascii?Q?aQEXK2UAMFe6GNk6j02dGpJBrvw3vMto8vFKXRSQTp1+MlysSE4mjZB7xWRl?=
 =?us-ascii?Q?FPJx40bSuyDs0Zovwz3hLxLm7b7RIzEYSQxCoW61PdGc0xMBh1mH0pJNjdEU?=
 =?us-ascii?Q?ITLJkZ4RJwDq+N0tJeUa8EfpbxxRZShcHt1kN9d8JuWAy0YtoV55BRBr4QJP?=
 =?us-ascii?Q?qUg17zMpBFuF4zD4yTqmFkwSqj2BPZgR0981tiPmekIRekrvud76lkspIJQo?=
 =?us-ascii?Q?hixZoJjsmgy+aM0+n7HjB5tkqXl9?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(921020)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?rYE1xYSSwqvkwdmTeOLxGsWqOMTqDVr3JdImeeuMmN9wlF+O5XAyvFYryzSY?=
 =?us-ascii?Q?btPl2zWyiHP1IdjQDZ+dklAvboQlJ09nP6hTUuWm3+XakJgv6XId/zG1mp6r?=
 =?us-ascii?Q?VClkZUub+SqiT3DjsH9Cn841HNoRzSL4CO2vHN3HS6K9nT9EDhZw3hYzqZCG?=
 =?us-ascii?Q?ZUjBnSlSE6uJc0+lTqtTArJ9uDihQWswWZclm88zG3dI7inPQzVRLGzwsJ1L?=
 =?us-ascii?Q?nyzN788lx/lWTbm9wF/k90omtWcjTVkIChAuOxked9kHDSXSAEdFO6GxHQk8?=
 =?us-ascii?Q?ateWqB4HwbCVbox9f6VcZj/lu4ADPtTYCdiyfRwm02fwbgxOj1JB/eu4sFNQ?=
 =?us-ascii?Q?f9X82QFQYYdPBz6pmnP5A32AJ8nsFYtrsMaBiKf/yQY5e6Mlj7ak9Xcr0Oa2?=
 =?us-ascii?Q?qU0EJqh8/DWVXC9juufqJ+atH/7MdpJIzzUZyku9zWj6OLHwdsEDVQZFflVm?=
 =?us-ascii?Q?KDHVMmMGhQmlEMYrMOrW38pwbcqLSaX4UAVuS9RQG6ILLnFYVFlHmCAxeVQl?=
 =?us-ascii?Q?1tf8r9TWA5ciI0JqYw/TOdw1DbvR8bHuQieu6jyTaFmxp4SnHu9hnvBF5Dvg?=
 =?us-ascii?Q?W5HsY4Tru2Uacwp4erQzyZXhNFaaRGKT6aI4M1YVa2mThTQykkRzrYFS3a48?=
 =?us-ascii?Q?cjb5SId5OMpQxj1oBECJ90arWouPbik3GXuWz9PK/XUx2iAku8MXFFN1Dgzh?=
 =?us-ascii?Q?d4Weqav9CyOcxV4ErRg0ZGvnKah9VMN5zKLlUnCtBYVF2miWX7I7IuQHIlJi?=
 =?us-ascii?Q?rl+wwnbimxtJdLc6Fax0rhxhXsvHabuosTqIYASS7Hux8Id4OgIdE7lJdEGW?=
 =?us-ascii?Q?mloRBn8cScrabVYjbKhT53kFvREwNpyQuwP0pLkz6jxmPzuiV8pvsMDiRqv3?=
 =?us-ascii?Q?xU4rslp/zFgQ0oFfuhZX3d50zvACOYutBUXBt6i3In7rb+D/oMNxi9EqKW3C?=
 =?us-ascii?Q?aJjjJRauZIVeEhRSWpj6ZBqzONAQQDQUebNcuV7aoNwJrJbwZ5673CT5oG+r?=
 =?us-ascii?Q?qyRH5ymVZCrf5uu9dFw3XuZ977Crf588WZsvlMWTyiDh26mNCLAJQftAdBHD?=
 =?us-ascii?Q?OYU/Srjzm2uBcOrbYJpmbm5wK3WQEvZVv0XONgl7TGhAvD7pI3G08G0Btlxr?=
 =?us-ascii?Q?T6czkALuoOpanag03tsVIzIb2cw6fLvkFYD7tLCbnBw9/d8u84WC8S0gEWOU?=
 =?us-ascii?Q?J/sFEqahHdqZ7b5ZSPJhFScX+sMZLWG5yN+m3qepCOjQrpNGxS7wq8FumPlC?=
 =?us-ascii?Q?xSrJv9kZbYcR6wKxmSPSjZ794YEy5LiPBtxsbNcxKDWUrOQzNQfrsjU+1H5g?=
 =?us-ascii?Q?A7BnQ1RATa3tbMCiGm2TbbiA8tAz+eu8zZW5LNj1xHSJoed6ZedCZ57myAEI?=
 =?us-ascii?Q?bT0QPiWUraPi8Rkpih8D6i2hwbiwxZs9bE9yEvJ7ri9Lml31P2ZQigROjnAK?=
 =?us-ascii?Q?wqRxJpV1NFD/Yrf6yCatbPeD8NPZPQVOQ3K7qd43lSgkmSRETDct3Spj2PzQ?=
 =?us-ascii?Q?AGsM8FnspOuLjeBBi8WL0ZWVNPJyww+Fy9HiS+pn0VkXQFgn2lJShj7SJlfY?=
 =?us-ascii?Q?dnOFoKD5NPa2F0C8vzi+htU93Pvhxb1+AuPLQTYW?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 490da002-da5f-409b-c745-08dcf4010bc0
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Oct 2024 07:54:10.8642
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /IZlIADcLLr8oELGgKWYzFeWd2G8arQAYJ4Ac6u6+XG6vDVrL1CXM3R4t5hmR7kfmumc4yuOkAlQttDvs61IxQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR11MB8056
X-OriginatorOrg: intel.com

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Thursday, October 10, 2024 12:23 AM
>=20
> Force Write Back (FWB) changes how the S2 IOPTE's MemAttr field
> works. When S2FWB is supported and enabled the IOPTE will force cachable
> access to IOMMU_CACHE memory when nesting with a S1 and deny cachable
> access otherwise.

didn't get the last part "deny cacheable access otherwise"

> @@ -169,7 +169,8 @@ arm_smmu_domain_alloc_nesting(struct device *dev,
> u32 flags,
>  	 * Must support some way to prevent the VM from bypassing the
> cache
>  	 * because VFIO currently does not do any cache maintenance.
>  	 */
> -	if (!arm_smmu_master_canwbs(master))
> +	if (!arm_smmu_master_canwbs(master) &&
> +	    !(master->smmu->features & ARM_SMMU_FEAT_S2FWB))
>  		return ERR_PTR(-EOPNOTSUPP);

Probably can clarify the difference between CANWBS and S2FWB here
by copying some words from the previous commit message. especially
about the part of PCI nosnoop.

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

