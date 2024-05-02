Return-Path: <kvm+bounces-16449-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 58F298BA407
	for <lists+kvm@lfdr.de>; Fri,  3 May 2024 01:33:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0FBBD28566D
	for <lists+kvm@lfdr.de>; Thu,  2 May 2024 23:33:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 156244CB35;
	Thu,  2 May 2024 23:33:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZI2mXCae"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A54646542;
	Thu,  2 May 2024 23:33:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714692783; cv=fail; b=QLMnvDCXWVkJJlMwh37JPgfMUZgU9ueensikgcY3CXdU19XjX8s0Co/WUZzTYYkFj5uXL6nyDjac8uvBlLx5CDs027I5kcwbaPPuvzCw2UXz6wrpqEzHeCALHeDDAP7tPXniK+mTngEWIfSQh5Yfxlvwgwfx+5hBxR/UucIHAsY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714692783; c=relaxed/simple;
	bh=Tc24v7nHuvbnj9JvyGwO9rKzxFnSB3r8nE2VCDSjQOE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=P0ahPyaZjbzyR0QTEyj5lN93e+P2fOqnhmr+VRq3vMUk1glV2tawAhY7EC/vhCU/zN/sRrezL5CTUJ9U8HLaF+h3CZBwX1aAxbKdRpcshzEtcmEeTXsNIkb6C8y4nXmZdcIUdBO21naKwiFZj+PR8+Dl+XCgTeGPWO2gyrS2FfY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZI2mXCae; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714692781; x=1746228781;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Tc24v7nHuvbnj9JvyGwO9rKzxFnSB3r8nE2VCDSjQOE=;
  b=ZI2mXCaeoR50z9vLR172DS9YsEbos6Nhw/XQWAVsyO83t0XXLqTcvxSl
   TXWzxQ1VOhD9gGOY+yIMSt0XihlhYli46uaDq7sPdY+WK1dHNcxeMdxPc
   n16HIUmtGcksc7O5TMJRmTiwdvwtFSqZyUkXWTL/0DrLX04/W458uQ98a
   hHih4i/Tx9H2FzcImFIoZ4TQ3b12EmaYQDiqdpvEwybKoD1R8sZmoYTP/
   iX3ouSm+10AqVMYUOdDP9OtQGIGFe2nVoViG3BVbzD7OvBZv7OgasXF/2
   9ImwTbmlbXtBarP2KBIoigVvBPgZmBpbQKV92RaD1P/8n6tfgI/YlOnod
   Q==;
X-CSE-ConnectionGUID: OupMdOD3SHCn2WpH9ukotw==
X-CSE-MsgGUID: JQdXezKJTEaRDPO11y2VXw==
X-IronPort-AV: E=McAfee;i="6600,9927,11062"; a="14306173"
X-IronPort-AV: E=Sophos;i="6.07,247,1708416000"; 
   d="scan'208";a="14306173"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 May 2024 16:33:00 -0700
X-CSE-ConnectionGUID: YOJz+Fy/RYuUgD2/aWXLIw==
X-CSE-MsgGUID: ldSKZemEQymTLIbxyrjP1A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,247,1708416000"; 
   d="scan'208";a="27687435"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa006.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 02 May 2024 16:33:00 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 2 May 2024 16:32:59 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 2 May 2024 16:32:59 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 2 May 2024 16:32:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jDGzTS187WD9RY7340wqMIqrmqKTjSC76Pb6uaLxPPqKzzO0gw9BEV25jKx4QAh0EzIb1lzaSgJw+FXwfjmLCgv4HA2pgKfKulWBKct2Goj6xdQ43K4P8EElpyGDhC4EdocooIbgQzi8CZfwl3DbG8W5KQotUYFneO1eTi9Zl1MJRvmTpgrTVem7ue/uAoTOnAexT9AM9nWs82p/DYC9l0G2MihWuUVsn7rY4HRPGJPQWAQ5VNGw5xwUO5BcB8R99mrRiTqxwp7fvVm8Ace7UUYwxr02+4sHkeSKeE+F+lg2TygxEWbf4qBfHZP53U1vlnexcdyUSn4I8XBdSnArTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4DHOUlK6vzi+MogwUwB5rpfKVrK5dzjUWQQrcwsWy7w=;
 b=cQABDpHtLUrNZ8yXMU4IFALxcGar4RkWLV/gIqhACWAS+bdmC7hIoaVUT3CTqljqaGSrTtPY3zX37zNmeXYevFOkbEhSxgL8LL0up9CC9WHh4S4yfxiAqghizyQmzapzl6gCN1V0zi7DT8U3djFVLN4665IZEJ4uLYPw+LXHkatCMWBcKJPmKzTNs7iYkEg8VH9CYYoGncSKWTw17Hr+yxEjOTtA60rNcW0G/GicI2vM6ztilcS1vUkeIOY0nIsOclhzUqHkXTWA0X5xu4qpqg5g1xeINJBCjlx6ZCAhssN2j7tDE5+pg+x7L3o8d2vrcJyTKCFsxM95vH81P94EJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA1PR11MB6991.namprd11.prod.outlook.com (2603:10b6:806:2b8::21)
 by MW4PR11MB6840.namprd11.prod.outlook.com (2603:10b6:303:222::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.34; Thu, 2 May
 2024 23:32:55 +0000
Received: from SA1PR11MB6991.namprd11.prod.outlook.com
 ([fe80::c06c:bf95:b3f4:198d]) by SA1PR11MB6991.namprd11.prod.outlook.com
 ([fe80::c06c:bf95:b3f4:198d%5]) with mapi id 15.20.7519.021; Thu, 2 May 2024
 23:32:55 +0000
From: "Zeng, Oak" <oak.zeng@intel.com>
To: "leon@kernel.org" <leon@kernel.org>, Christoph Hellwig <hch@lst.de>, Robin
 Murphy <robin.murphy@arm.com>, Marek Szyprowski <m.szyprowski@samsung.com>,
	Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>, Jason
 Gunthorpe <jgg@ziepe.ca>, Chaitanya Kulkarni <chaitanyak@nvidia.com>, "Brost,
 Matthew" <matthew.brost@intel.com>, "Hellstrom, Thomas"
	<thomas.hellstrom@intel.com>
CC: Jonathan Corbet <corbet@lwn.net>, Jens Axboe <axboe@kernel.dk>, "Keith
 Busch" <kbusch@kernel.org>, Sagi Grimberg <sagi@grimberg.me>, Yishai Hadas
	<yishaih@nvidia.com>, Shameer Kolothum
	<shameerali.kolothum.thodi@huawei.com>, "Tian, Kevin" <kevin.tian@intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	=?iso-8859-1?Q?J=E9r=F4me_Glisse?= <jglisse@redhat.com>, Andrew Morton
	<akpm@linux-foundation.org>, "linux-doc@vger.kernel.org"
	<linux-doc@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-block@vger.kernel.org"
	<linux-block@vger.kernel.org>, "linux-rdma@vger.kernel.org"
	<linux-rdma@vger.kernel.org>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, "linux-nvme@lists.infradead.org"
	<linux-nvme@lists.infradead.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "Bart Van
 Assche" <bvanassche@acm.org>, Damien Le Moal
	<damien.lemoal@opensource.wdc.com>, Amir Goldstein <amir73il@gmail.com>,
	"josef@toxicpanda.com" <josef@toxicpanda.com>, "Martin K. Petersen"
	<martin.petersen@oracle.com>, "daniel@iogearbox.net" <daniel@iogearbox.net>,
	"Williams, Dan J" <dan.j.williams@intel.com>, "jack@suse.com"
	<jack@suse.com>, Leon Romanovsky <leonro@nvidia.com>, Zhu Yanjun
	<zyjzyj2000@gmail.com>
Subject: RE: [RFC RESEND 00/16] Split IOMMU DMA mapping operation to two steps
Thread-Topic: [RFC RESEND 00/16] Split IOMMU DMA mapping operation to two
 steps
Thread-Index: AQHanOEtbi0VHTnLn0mNwgftYB7xRbGEmFqg
Date: Thu, 2 May 2024 23:32:55 +0000
Message-ID: <SA1PR11MB6991CB2B1398948F4241E51992182@SA1PR11MB6991.namprd11.prod.outlook.com>
References: <cover.1709635535.git.leon@kernel.org>
In-Reply-To: <cover.1709635535.git.leon@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR11MB6991:EE_|MW4PR11MB6840:EE_
x-ms-office365-filtering-correlation-id: 85f468da-ca47-45f3-66e1-08dc6b0031af
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|1800799015|7416005|376005|366007|38070700009|921011;
x-microsoft-antispam-message-info: =?iso-8859-1?Q?Je2EIStEVtlde1RfiV2yyKGM/LtlmWCWjRp2xrmedv4aH2Zglzekj0KG5l?=
 =?iso-8859-1?Q?/zCZvGUpU8kakuy/ShBzptcVcHSRDtB1m58m/mGeaaBumDMxinMN6qqj7g?=
 =?iso-8859-1?Q?mc2mcPCj0/uG6TEv7vAtPZxLJ8QQy/JdMTtzpP1ajVCSHtr/shzOs0CW8b?=
 =?iso-8859-1?Q?T88ThT85GqUBOO0aWLVMDqQSGrGFwHRK6nPM9W9zL+K52K0EUQWrROqm2O?=
 =?iso-8859-1?Q?eLUYDTp/xRQFRoKTPhcKZFL3Vmj2cRyKJ07lCeQaZ5+ibyBrDSaJD3D7JM?=
 =?iso-8859-1?Q?fyIlBUZe97rLpGvQtTM5ntapTVesgRpJ0hJ9bqM0IJab1iFtDr7GrmBnsD?=
 =?iso-8859-1?Q?RtfB8AueSH0toe1zPv3bTP4Dq3/w43wLIN9RHFwzRYwJoa100cwTtDIl07?=
 =?iso-8859-1?Q?rzyE6IXxJ34xRpKyqemhanGnyWhg4F69U2Mt49rOiItlBpLpUkuU/NHCmi?=
 =?iso-8859-1?Q?R9gKdhU0gzoqzvw2sDDqyZEukqHgjle13ET1gIAwSBJGR2pQ7v2KmRtB+u?=
 =?iso-8859-1?Q?brZlMsj+FAyQuND0oW3w+kuZyGSNx91nglVskJj5zEYWuBtJS0joF7LaCI?=
 =?iso-8859-1?Q?sYfhvifzzt1N3Z+05BTjXq5pIisT6hShyqgU7c1euXzWwuh98TONdxBd+/?=
 =?iso-8859-1?Q?xREHqu2W9KN5WsP4piFEIahPbnAYACKtfGYeFR5Eg+Z4qt74zapKWRIOBl?=
 =?iso-8859-1?Q?jPRV6vXh9LhOvn1yGel2z/fsMIew1dIm+P0aylF0AUmK58auE2xusSnRfw?=
 =?iso-8859-1?Q?fwYQQ45ZS/2OPOxF3QoLOWWt7dbrdwmLAy0l2X1VbBILn6lfImnPyHKPSG?=
 =?iso-8859-1?Q?RoXgcYDex3MjAjj0Krrpu3uKmVHBbY5fyDNZ/kd7OvG6/xW7U2oUg5tWPO?=
 =?iso-8859-1?Q?4NgWKCiiPt+A1WgNH8AtLxKPvDJZrp39EEVXAQOE0OESW8KdMZJoDn+wEt?=
 =?iso-8859-1?Q?BgTTkCyl6QKnNscL60RK17qxVk0MrYVCgSiXpYKviShSGWhMvinx0++CSV?=
 =?iso-8859-1?Q?qzCvxRsiYYGhvN2TuSIAuH5oi1kON4nHRthuyUSaXB7PtIj8dPdQPVOXAm?=
 =?iso-8859-1?Q?5bqNWyiTXIh2E+H4gmAs/zgPFUYXJWvzyEXxa+hhFo6LZn5iL3BikLAvMW?=
 =?iso-8859-1?Q?rk29VPoJKEfYRztr1t/lHfd6gBpNKamOn284R5xl8+qCSi4gNhRtLohj0K?=
 =?iso-8859-1?Q?hrA6Rn+SnQwiXG5PSYLTbCH5zMet1XFkicm7XKzZ/+zBLgxXX5Eotfmt1k?=
 =?iso-8859-1?Q?S6c4rqkNSNgckNiCD+ZNuRbxI3xYZDB79XbTdJwc/oIH8Wbzl30OEF+ZX4?=
 =?iso-8859-1?Q?LpAzaC55kPlmQGYO/sElS7OwfApJaUOW8YRBIUbBUj1dl7vdB3xDTVkLFh?=
 =?iso-8859-1?Q?KcDs/KjL8D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6991.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(7416005)(376005)(366007)(38070700009)(921011);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?NRtLhnOqkQ+zlCTZLTRLr1oVzEY7CZDof/OxyG+fUK248HlSlOnEjnhTeU?=
 =?iso-8859-1?Q?Ivlp2sEN+uevYhJqtzJaB+gQvVVv8OgcjmrduzrAk95aSbuVA67oB17Icm?=
 =?iso-8859-1?Q?JgpV2Q5y/TZMZXg2UM02r+cGtNP9UJGBRoAB7k2nNi0Jiowl317I9rMAS+?=
 =?iso-8859-1?Q?a+fzuPQo7b405396hzj6ywOFaVPnhdxmzBa8ihkXKioYYYRl2wR9JXO2+3?=
 =?iso-8859-1?Q?FjjawZ6PRKRcgPFATboqLwZRdUEleXEQ0RwCHv2r081ERR3KXNSqjI+8U+?=
 =?iso-8859-1?Q?xkW1Zts20AGPth4uQv4tux7dAECce6Ip0GeQqLqHXASrH2TPgxINwLs8es?=
 =?iso-8859-1?Q?kcdyLZfHg1VcD/0Ppj33w3IghOC4AjhjT6Y3VO1A2j3ZxlVXHLoTarg7an?=
 =?iso-8859-1?Q?qwqM1mShNDhmv3bURnJiCMVs6n/fyaBox3P/VTMZuDFJnzjZLmvzilzKLh?=
 =?iso-8859-1?Q?jyr0sR2aMV+5BNntET6Mr0j2TCj0NVLX+Rh/e+bP+GCb4HKSfi0imXPluW?=
 =?iso-8859-1?Q?egOqkwi9ke+sec2VlUoC3nfucj1IOYrHif/jIh1s+yLEr/qicHY/vNTlMd?=
 =?iso-8859-1?Q?XsokAwArZrsEprxYf0eoeG97Jn/nGgUEadWZyN8GWZ3jah15s+UQlR8ev0?=
 =?iso-8859-1?Q?dMQTWETniuWrRDo2DUDu+l6ScF+NDeZITVcdMvjtTomeiGjeS4e2gWuIWt?=
 =?iso-8859-1?Q?TjJxZnf0sA+D4VYWvz7afTafRZPMwiUqZ9GhwdzARkE6oLeAcLpYEGHfiP?=
 =?iso-8859-1?Q?0w3yP42VenHVr000vJqaXLHRPqOmtF+yzTMqP2RWxN28OtF92BdAkJ0Y83?=
 =?iso-8859-1?Q?cdoW8sL3AaG1YxiOdcOmhQlBMlxPm+50T2Tna+p+ymgIyl4ijNlRaXggK2?=
 =?iso-8859-1?Q?0MW35rcMZggYknQnibJG0AnWF1qli7Ik+ExwpicO4xmUICTgRsMoORAOK9?=
 =?iso-8859-1?Q?KyL1cDwijK4BoyRVWHn6VmCafwy4mt7q+n5aCxguVbrBdjaYxkoog9mq3f?=
 =?iso-8859-1?Q?mQT38th/oFHc1V8DsosUnkGo9JGtkEfs6OYGlOhW0Jk4qlx0FyTgww1lTz?=
 =?iso-8859-1?Q?PxjHHztybCZ1rTi3LYY9xA6CqzeyFPE+cu55o3ZdRYqg9nz4UY+iH10DLP?=
 =?iso-8859-1?Q?iOpQHO3Y89hhKbuTfH+yFdyxOjAuzKSEyVkMex1oFXB/QG8Yhlc4gTJf1x?=
 =?iso-8859-1?Q?RfB7ZZDbqA393oX82rBjG/etnyNGgvQhG0Z9FMFkZ7uxC1lxL0HG8oqhHs?=
 =?iso-8859-1?Q?4DOtgyZnLXC0PwFfUxqKyK0B2/fn7ZAVnroOhBDE6jAaKOt+1de9noIMc9?=
 =?iso-8859-1?Q?rxsKNwzgO8bUw/Lcd86Q7ntLY+JwxAxYyAw+ApMmK/5yJtRU9+Y7H7IsE5?=
 =?iso-8859-1?Q?1t/8pohrC3cJdIatmpXDbQ5ONIBKw8t7pLxJpWdAk/UzRtRzDVnALYOMVl?=
 =?iso-8859-1?Q?QcUEmmZnDzUR0jruoYXiP0R1OkRr8I/DpOaO4s1aqNvfkZXKYVVGJZW6qs?=
 =?iso-8859-1?Q?JuIvxuSBh5o/2H2rqQ0u6HWLGD5yVd3aZZ2G2ec7PvolsBXPuWRm6Pk9BK?=
 =?iso-8859-1?Q?Nr4j2NFcPKLD58TvWJ+NIVwQl+Y6b647PKfdhyomS3uRxwHZx8V4cd0W08?=
 =?iso-8859-1?Q?dc3jJnyEQvE7k=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6991.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 85f468da-ca47-45f3-66e1-08dc6b0031af
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 May 2024 23:32:55.7109
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +pNAw/jRAiXC5Z5BTxN8yjQtFtcnZSeFvuwhora7K4yohqK/XyfU/3HT6BIBiBcFUuq6eUb/eaDgoWCszzzW7g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6840
X-OriginatorOrg: intel.com

Hi Leon, Jason

> -----Original Message-----
> From: Leon Romanovsky <leon@kernel.org>
> Sent: Tuesday, March 5, 2024 6:19 AM
> To: Christoph Hellwig <hch@lst.de>; Robin Murphy
> <robin.murphy@arm.com>; Marek Szyprowski
> <m.szyprowski@samsung.com>; Joerg Roedel <joro@8bytes.org>; Will
> Deacon <will@kernel.org>; Jason Gunthorpe <jgg@ziepe.ca>; Chaitanya
> Kulkarni <chaitanyak@nvidia.com>
> Cc: Jonathan Corbet <corbet@lwn.net>; Jens Axboe <axboe@kernel.dk>;
> Keith Busch <kbusch@kernel.org>; Sagi Grimberg <sagi@grimberg.me>;
> Yishai Hadas <yishaih@nvidia.com>; Shameer Kolothum
> <shameerali.kolothum.thodi@huawei.com>; Kevin Tian
> <kevin.tian@intel.com>; Alex Williamson <alex.williamson@redhat.com>;
> J=E9r=F4me Glisse <jglisse@redhat.com>; Andrew Morton <akpm@linux-
> foundation.org>; linux-doc@vger.kernel.org; linux-kernel@vger.kernel.org;
> linux-block@vger.kernel.org; linux-rdma@vger.kernel.org;
> iommu@lists.linux.dev; linux-nvme@lists.infradead.org;
> kvm@vger.kernel.org; linux-mm@kvack.org; Bart Van Assche
> <bvanassche@acm.org>; Damien Le Moal
> <damien.lemoal@opensource.wdc.com>; Amir Goldstein
> <amir73il@gmail.com>; josef@toxicpanda.com; Martin K. Petersen
> <martin.petersen@oracle.com>; daniel@iogearbox.net; Dan Williams
> <dan.j.williams@intel.com>; jack@suse.com; Leon Romanovsky
> <leonro@nvidia.com>; Zhu Yanjun <zyjzyj2000@gmail.com>
> Subject: [RFC RESEND 00/16] Split IOMMU DMA mapping operation to two
> steps
>=20
> This is complimentary part to the proposed LSF/MM topic.
> https://lore.kernel.org/linux-rdma/22df55f8-cf64-4aa8-8c0b-
> b556c867b926@linux.dev/T/#m85672c860539fdbbc8fe0f5ccabdc05b40269057
>=20
> This is posted as RFC to get a feedback on proposed split, but RDMA, VFIO
> and
> DMA patches are ready for review and inclusion, the NVMe patches are stil=
l
> in
> progress as they require agreement on API first.
>=20
> Thanks
>=20
> -------------------------------------------------------------------------=
------
> The DMA mapping operation performs two steps at one same time: allocates
> IOVA space and actually maps DMA pages to that space. This one shot
> operation works perfectly for non-complex scenarios, where callers use
> that DMA API in control path when they setup hardware.
>=20
> However in more complex scenarios, when DMA mapping is needed in data
> path and especially when some sort of specific datatype is involved,
> such one shot approach has its drawbacks.
>=20
> That approach pushes developers to introduce new DMA APIs for specific
> datatype. For example existing scatter-gather mapping functions, or
> latest Chuck's RFC series to add biovec related DMA mapping [1] and
> probably struct folio will need it too.
>=20
> These advanced DMA mapping APIs are needed to calculate IOVA size to
> allocate it as one chunk and some sort of offset calculations to know
> which part of IOVA to map.
>=20
> Instead of teaching DMA to know these specific datatypes, let's separate
> existing DMA mapping routine to two steps and give an option to advanced
> callers (subsystems) perform all calculations internally in advance and
> map pages later when it is needed.

I looked into how this scheme can be applied to DRM subsystem and GPU drive=
rs.=20

I figured RDMA can apply this scheme because RDMA can calculate the iova si=
ze. Per my limited knowledge of rdma, user can register a memory region (th=
e reg_user_mr vfunc) and memory region's sized is used to pre-allocate iova=
 space. And in the RDMA use case, it seems the user registered region can b=
e very big, e.g., 512MiB or even GiB

In GPU driver, we have a few use cases where we need dma-mapping. Just name=
 two:

1) userptr: it is user malloc'ed/mmap'ed memory and registers to gpu (in In=
tel's driver it is through a vm_bind api, similar to mmap). A userptr can b=
e of any random size, depending on user malloc size. Today we use dma-map-s=
g for this use case. The down side of our approach is, during userptr inval=
idation, even if user only munmap partially of an userptr, we invalidate th=
e whole userptr from gpu page table, because there is no way for us to part=
ially dma-unmap the whole sg list. I think we can try your new API in this =
case. The main benefit of the new approach is the partial munmap case.

We will have to pre-allocate iova for each userptr, and we have many userpt=
rs of random size... So we might be not as efficient as RDMA case where I a=
ssume user register a few big memory regions. =20

2) system allocator: it is malloc'ed/mmap'ed memory be used for GPU program=
 directly, without any other extra driver API call. We call this use case s=
ystem allocator.

For system allocator, driver have no knowledge of which virtual address ran=
ge is valid in advance. So when GPU access a malloc'ed/mmap'ed address, we =
have a page fault. We then look up a CPU vma which contains the fault addre=
ss. I guess we can use the CPU vma size to allocate the iova space of the s=
ame size?

But there will be a true difficulty to apply your scheme to this use case. =
It is related to the STICKY flag. As I understand it, the sticky flag is de=
signed for driver to mark "this page/pfn has been populated, no need to re-=
populate again", roughly...Unlike userptr and RDMA use cases where the back=
ing store of a buffer is always in system memory, in the system allocator u=
se case, the backing store can be changing b/t system memory and GPU's devi=
ce private memory. Even worse, we have to assume the data migration b/t sys=
tem and GPU is dynamic. When data is migrated to GPU, we don't need dma-map=
. And when migration happens to a pfn with STICKY flag, we still need to re=
populate this pfn. So you can see, it is not easy to apply this scheme to t=
his use case. At least I can't see an obvious way.


Oak


>=20
> In this series, three users are converted and each of such conversion
> presents different positive gain:
> 1. RDMA simplifies and speeds up its pagefault handling for
>    on-demand-paging (ODP) mode.
> 2. VFIO PCI live migration code saves huge chunk of memory.
> 3. NVMe PCI avoids intermediate SG table manipulation and operates
>    directly on BIOs.
>=20
> Thanks
>=20
> [1]
> https://lore.kernel.org/all/169772852492.5232.17148564580779995849.stgit@
> klimt.1015granger.net
>=20
> Chaitanya Kulkarni (2):
>   block: add dma_link_range() based API
>   nvme-pci: use blk_rq_dma_map() for NVMe SGL
>=20
> Leon Romanovsky (14):
>   mm/hmm: let users to tag specific PFNs
>   dma-mapping: provide an interface to allocate IOVA
>   dma-mapping: provide callbacks to link/unlink pages to specific IOVA
>   iommu/dma: Provide an interface to allow preallocate IOVA
>   iommu/dma: Prepare map/unmap page functions to receive IOVA
>   iommu/dma: Implement link/unlink page callbacks
>   RDMA/umem: Preallocate and cache IOVA for UMEM ODP
>   RDMA/umem: Store ODP access mask information in PFN
>   RDMA/core: Separate DMA mapping to caching IOVA and page linkage
>   RDMA/umem: Prevent UMEM ODP creation with SWIOTLB
>   vfio/mlx5: Explicitly use number of pages instead of allocated length
>   vfio/mlx5: Rewrite create mkey flow to allow better code reuse
>   vfio/mlx5: Explicitly store page list
>   vfio/mlx5: Convert vfio to use DMA link API
>=20
>  Documentation/core-api/dma-attributes.rst |   7 +
>  block/blk-merge.c                         | 156 ++++++++++++++
>  drivers/infiniband/core/umem_odp.c        | 219 +++++++------------
>  drivers/infiniband/hw/mlx5/mlx5_ib.h      |   1 +
>  drivers/infiniband/hw/mlx5/odp.c          |  59 +++--
>  drivers/iommu/dma-iommu.c                 | 129 ++++++++---
>  drivers/nvme/host/pci.c                   | 220 +++++--------------
>  drivers/vfio/pci/mlx5/cmd.c               | 252 ++++++++++++----------
>  drivers/vfio/pci/mlx5/cmd.h               |  22 +-
>  drivers/vfio/pci/mlx5/main.c              | 136 +++++-------
>  include/linux/blk-mq.h                    |   9 +
>  include/linux/dma-map-ops.h               |  13 ++
>  include/linux/dma-mapping.h               |  39 ++++
>  include/linux/hmm.h                       |   3 +
>  include/rdma/ib_umem_odp.h                |  22 +-
>  include/rdma/ib_verbs.h                   |  54 +++++
>  kernel/dma/debug.h                        |   2 +
>  kernel/dma/direct.h                       |   7 +-
>  kernel/dma/mapping.c                      |  91 ++++++++
>  mm/hmm.c                                  |  34 +--
>  20 files changed, 870 insertions(+), 605 deletions(-)
>=20
> --
> 2.44.0


