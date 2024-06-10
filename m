Return-Path: <kvm+bounces-19237-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A3B490251E
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2024 17:13:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1EFBD1F25C55
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2024 15:13:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2290D139578;
	Mon, 10 Jun 2024 15:12:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hAE0h7ad"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D146713F43B;
	Mon, 10 Jun 2024 15:12:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718032367; cv=fail; b=YBrOa9qh3E1MnoFb3W47JefrNmO0hvMyMdAGY2SCZPHzR51On4w7BPPvATtKH0EvuLAzIc0POwb0ldLyCedLcSfX+SYZTn2o99Vd91HIpdsnD2WfAE0t23cFzvikCiNKVLKnLMD6mm5A9AAwvJUXzd4QTPMp4qaouGCJZgf1qvM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718032367; c=relaxed/simple;
	bh=wP52WjSZJNRvx87h1yg3jA9FIwKbCbE/t5cIQtCNbRc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=hv9jAwDwWse6eWh6QvLht2K8xp9gLiCmlXPuzdFSN0sNlNPSAs6EZRdbRx8SsaCwEqvNhRCjkn4D7RdcowhawtcfBna5WRrtMtxNIV8Uwh/vmJxgMStTBH/vWlhRuiQnU7Tb4qT0JusFa0tfYjcEfCs0Depb3a+AF1njALWa99s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hAE0h7ad; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718032365; x=1749568365;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=wP52WjSZJNRvx87h1yg3jA9FIwKbCbE/t5cIQtCNbRc=;
  b=hAE0h7adiIFgjknPaFvKhwPbmAi1sEPrKQ5VKYbdmWKqaV+ukDyVnKMz
   Bse+UGGKN8qAP82+zBkMUedLZwL2FpgozphquWwOUPMAW7I6AQ9OHMyGp
   ryH2ALfySFNF//S8AavLSxo1OLAC+Yh7V/1OVx6hSF+i7NnHFFbtTRM3q
   E6G9w+Tim61FxRrUFfrEtCCX9W3CW2X4kK2agKZEMx15acPxuAzmJwqaV
   s4dIilGyn7PG6mbncPPcPQ0twdgWcB6jpBgOSC8lnwnMBIy0F3ontfLF3
   1YT00/gGak2mqvFB2QNyf3RBhHmLLRR1Dm1I+nNhKbYqy4IFSEuTvrWYF
   A==;
X-CSE-ConnectionGUID: pRcoYMkIQo+ZE0iTbUvxMQ==
X-CSE-MsgGUID: w9kXtVDzQl2xBvRrbsZr3g==
X-IronPort-AV: E=McAfee;i="6600,9927,11099"; a="18552417"
X-IronPort-AV: E=Sophos;i="6.08,227,1712646000"; 
   d="scan'208";a="18552417"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2024 08:12:30 -0700
X-CSE-ConnectionGUID: Non9j5k3SLyqFL4n9BNJXQ==
X-CSE-MsgGUID: jih4WAmkR1qDV3Ik1VuQNw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,227,1712646000"; 
   d="scan'208";a="69882416"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 10 Jun 2024 08:12:29 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 10 Jun 2024 08:12:29 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 10 Jun 2024 08:12:28 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 10 Jun 2024 08:12:28 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.175)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 10 Jun 2024 08:12:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O3RObYZVyUcyUXGYkji6IoRpX1uU9Op7YW20trqmRT7pgLIJxqjOw8yaRba7keqJO/ffCsyOh0GrwJ6eeoh07tBLtGcRYZ9kPIaLYiBHZtwfms4QQRYKpPT05nSdXNPCFpBXvny/FCO6IU/P4awuW8gmhmTiw2FlrU9L9wYPxKimkx5+zjqyvZ4Hr63mTgn2+eyvLBZuM5C7B/ROPLKeDprxKWdGnc8J0VrgKKcjj41Kh2UAb2RmOh6d0+s+IsS3CJDsVHVN25hjwW9jb1Ot7riwyKE3Clx4zcK3Y8oko8aoJ4HRKQMr3BlT/e5D4xOFqCYUVN2UDRP+kT31hxiPbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wP52WjSZJNRvx87h1yg3jA9FIwKbCbE/t5cIQtCNbRc=;
 b=BCUWrUgUwvBmWbiui5fnnPeZ6CvRa5b6Kq1fUxYTgY/vTqilmYhFdUECMUgngDJTud3mnYDWh15jGGwDZNqt3GvaNrl1+Z0QuUoVKa2yXJzs5OJ97BKzg2rQJ52T6ZXrzC4cMA7uRMn/jZ5FBG2Vzkk1czA8uSUiIMy/vXzZqIFCHrCpcv90sp80DO0g5hqxZld5aVmkTLp4tPyUGF5Fbyh7iUBdSxjB23NZqtVNBleyrlGDuAurmN6eby7GPgT+Pm7oZK4Y5SHGGunRmu4i1MzSIAfXpOcP9gkyx4vuoTxdQUFNhEpwPQJbfjD53TroSW6LuTTiRALkaUFA4rGPaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB7004.namprd11.prod.outlook.com (2603:10b6:510:20b::6)
 by CO1PR11MB5026.namprd11.prod.outlook.com (2603:10b6:303:9c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.36; Mon, 10 Jun
 2024 15:12:25 +0000
Received: from PH7PR11MB7004.namprd11.prod.outlook.com
 ([fe80::8c26:2819:d0f9:1984]) by PH7PR11MB7004.namprd11.prod.outlook.com
 ([fe80::8c26:2819:d0f9:1984%3]) with mapi id 15.20.7633.036; Mon, 10 Jun 2024
 15:12:25 +0000
From: "Zeng, Oak" <oak.zeng@intel.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
CC: "leon@kernel.org" <leon@kernel.org>, Christoph Hellwig <hch@lst.de>,
	"Robin Murphy" <robin.murphy@arm.com>, Marek Szyprowski
	<m.szyprowski@samsung.com>, Joerg Roedel <joro@8bytes.org>, Will Deacon
	<will@kernel.org>, "Chaitanya Kulkarni" <chaitanyak@nvidia.com>, "Brost,
 Matthew" <matthew.brost@intel.com>, "Hellstrom, Thomas"
	<thomas.hellstrom@intel.com>, Jonathan Corbet <corbet@lwn.net>, Jens Axboe
	<axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>, Sagi Grimberg
	<sagi@grimberg.me>, Yishai Hadas <yishaih@nvidia.com>, Shameer Kolothum
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
	<zyjzyj2000@gmail.com>, "Bommu, Krishnaiah" <krishnaiah.bommu@intel.com>,
	"Ghimiray, Himal Prasad" <himal.prasad.ghimiray@intel.com>
Subject: RE: [RFC RESEND 00/16] Split IOMMU DMA mapping operation to two steps
Thread-Topic: [RFC RESEND 00/16] Split IOMMU DMA mapping operation to two
 steps
Thread-Index: AQHanOEtbi0VHTnLn0mNwgftYB7xRbGEmFqggAEftYCAO5ykoA==
Date: Mon, 10 Jun 2024 15:12:25 +0000
Message-ID: <PH7PR11MB70047236290DC1CFF9150B8592C62@PH7PR11MB7004.namprd11.prod.outlook.com>
References: <cover.1709635535.git.leon@kernel.org>
 <SA1PR11MB6991CB2B1398948F4241E51992182@SA1PR11MB6991.namprd11.prod.outlook.com>
 <20240503164239.GB901876@ziepe.ca>
In-Reply-To: <20240503164239.GB901876@ziepe.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR11MB7004:EE_|CO1PR11MB5026:EE_
x-ms-office365-filtering-correlation-id: 415cb717-016e-45cd-c3dc-08dc895fbc81
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|1800799015|366007|376005|7416005|38070700009;
x-microsoft-antispam-message-info: =?iso-8859-1?Q?iq33ugLrE1/gqik5x7T1YS3lusghZukzBcYSksC8GDlN9e5e8CQWNJD5U1?=
 =?iso-8859-1?Q?k3vixyMZSEjjnap3nIZqXItLIdyVOiKy0RgqYqi4Qdt5Nx0JDlnqgCKELl?=
 =?iso-8859-1?Q?+ojmMUdzab2ClT+x+Ab24RYcypi3XdauJX5YwRitMquxqfPKlEU9+RVDzZ?=
 =?iso-8859-1?Q?RTrRuUqrBrUyDdxQ+PjnXFMP9ehWsdVIcwmUyuCrYFHV+QrT115gdLBCcf?=
 =?iso-8859-1?Q?N1qbZZp58B7os/wtlyZeEljHTcluB7Wyj7RqPOTadF3kvhgxyVuu41fRDg?=
 =?iso-8859-1?Q?K7m/+w2XiC/miNClLIBla6XRb3Z5ygCLjbUZtjrCMzxpOw2NCC8sygTFry?=
 =?iso-8859-1?Q?Vwq/v8TgaeT1CZijANqmaetbw4ycFDgYgePn3By6lgVShhCLw26MXqXfHK?=
 =?iso-8859-1?Q?fUsxBkkHO3iOrhpK7U4q+UVgwtkZlNzlSO0hBBf5pfGFU3ghQxSyrS0Pwf?=
 =?iso-8859-1?Q?Zsnhd8wjEp87OGsVwWXF40nnHUaK+PlMk2jyoRGwqIf5bxjn8oMYgyyIEr?=
 =?iso-8859-1?Q?+7nGqhcXNiqR7CTEjmoB+FmS1RsUels4eQZm5fptt24I59JZJ3z2KXRObc?=
 =?iso-8859-1?Q?yX2r4cGijPNRsOcZWdO8LdHZdyaJZq7zI8KSOEBMMQH0jxwYbGGw0Lwofh?=
 =?iso-8859-1?Q?FjMOujD9aC/rXyC2tZgHNuuOfAW79lrlItbnk4YACiziNVQTn0/htp+QUP?=
 =?iso-8859-1?Q?xbHt9/WaSMEkT/2Bpr37qnu+kc8SodSM2CpYld6yMUsjmQ78+mFSf2K3t5?=
 =?iso-8859-1?Q?8aFy/t2YlvJLCc3DE51pLUyu0jZ9cviq5xAfZQdN1eC82q9qP10rrvuX64?=
 =?iso-8859-1?Q?7KBRR40uaCmOKxMevWcjg925lz6/3OKjlFlUIUdF1Td39EKlcbszqE5Rs4?=
 =?iso-8859-1?Q?J/xnSQu6hozSr+9CcgUNrHIVCr+vZ7duQ4AizANP9TQ1nGDJ2fUvqk6DrN?=
 =?iso-8859-1?Q?HSBjphd2uHD3N8LNvgaYRHD+kaMzrsCCwQOdH5VoNiUewcLQXibSZzlHDh?=
 =?iso-8859-1?Q?p/D3OxAOIL3JuinyRKUPpTXyZzUNNdImC2fcmAurRMnuolEdRbp2iX876P?=
 =?iso-8859-1?Q?cUmY169/eBLyAbcv+sVbdp912yf3KU9eLVV6F6lXwodDsSaAneZAIYg0FC?=
 =?iso-8859-1?Q?hctZ2sXB7MM4tXXju6K+5WfLYU94JL3cdUqw7LVksXyAyebSgbERFozKkH?=
 =?iso-8859-1?Q?nVwtYmgmnR5hz/DujKqFGRB7WgfyHlWgs+tgOFQzbyrmKqsvZyLHsWMXQW?=
 =?iso-8859-1?Q?iWrEJYJ0/JJHCxZ6FxzNgqW9LYfnDPvIyXr9Y9mAd8RaGYo/69JbJ5UeM0?=
 =?iso-8859-1?Q?EGLCm0R1OFz9eavVzXUHZYXedhVkX8vOyThilt53r2V/6sF/bx4Z7cqZIW?=
 =?iso-8859-1?Q?kLP1mzZpnEF8jqMzquUALwpMytnu4jhY4Q6RD3FAnAAsqkLkSwHi4=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB7004.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005)(7416005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?2X+emzaduGjmW3aGIKukkqNS8/Zm1DeplWqDIiloB5HL9vSpLFnljzz849?=
 =?iso-8859-1?Q?8KPMzFtA2f9AenlsQuikry1a9MRWdIufdIX8E+2rAnxeT5W+zSvvgzndJH?=
 =?iso-8859-1?Q?WVkCWZGJcqI6CZ+2oQDuSL/35yYstkLwOmcPlcoJkiCXNUGteuhqhbwhSm?=
 =?iso-8859-1?Q?63n1r+blIgOnHXklZFKM6msjOF+A6VlJh2XaHkCGWnW7xFBcT6aq5Goj6i?=
 =?iso-8859-1?Q?ZgtJSHc+Z9378AlcmyC+bD4KOkQffAlocVt+mJs0RR1rfinIJkiqC3FnPa?=
 =?iso-8859-1?Q?Lf5BHupUoDb0WlW7MlLZSwRDc5ScYaNse1NUqY3NJrp9Pfaa5y5N0/Xx0T?=
 =?iso-8859-1?Q?9dvUZu8n5j755VkCYHYPaTG/dXBqBhayR3XSk1v7B3CfYOyizC6sRhyRIX?=
 =?iso-8859-1?Q?FA83SCyJNUjjd8k9EjSFW1+/WXPjb1zursbdGOh4qCzB9ft8tHHCI9/NKI?=
 =?iso-8859-1?Q?sHzW4/fQINDtvXEmuYMMNfFvOvEinq86FRT/2s+OwauOfLZyPl04x9pOLM?=
 =?iso-8859-1?Q?flBDKKsiyMqhg7cDvCBZ1ZDNL4qlvtKc+UlXDXfy1wo1h0pQmDrPZD3xEG?=
 =?iso-8859-1?Q?OYen63P3gej9NDOn1en16lateFCMkfjuV5L1JhJpvRi+HLbNqaJgg6CS7f?=
 =?iso-8859-1?Q?2uvX/0Re8iKjgapk/Qi66J62mlU6jE4JlJxXNLXogps5Eh8CTkgA2PA7Dd?=
 =?iso-8859-1?Q?JccG4fUdcK3bOjVQ4qxdLlwLQ7+NXgttAXmAs8LDOdf/gRDAXDcy/DiJ+6?=
 =?iso-8859-1?Q?ddx0ytXHMaYC4KHAvQNQLbDaQCcCp3C5rhVFRhMsGl2xOYsER0SF6Qvgt6?=
 =?iso-8859-1?Q?ocX8ZDgstCUTfa/GIFR9rfMguZ7dJaFUNNXv7PaU1d15Pnfswjlz+v1K+C?=
 =?iso-8859-1?Q?rQdTqo7iDtfzgzTvtm6EzSxqWVqyPGO+vgn6KtINJCuBPaMQWWjiSu6s8X?=
 =?iso-8859-1?Q?pa0VSKwtIoaihNzgU0L/bjRHtlPePFkJYLbRZz2DhKlHmQWsXZEoCEuyhu?=
 =?iso-8859-1?Q?TElmnZT9ZsqrOzhdG7DySmOwY5hD/uAU+cMaRZ5RogsJUQOvpmKshCzQxI?=
 =?iso-8859-1?Q?ZjESh87rO3V++jZxgT55Fc8h83lAGzyymzBG353uR3MyxRiRS7JFmVfkzy?=
 =?iso-8859-1?Q?WZFdGnDDnRhc7EXJGGMwyTCK5yd0VLRBRAIQ0dhvFx6S/JwGd/ewL06TIY?=
 =?iso-8859-1?Q?gRArwUT6jFpY4qV4l82FPWQSljdDpFdQbeeVC2CGQ7dSKEyCf7LlEdwRTv?=
 =?iso-8859-1?Q?NlypSd8a/+vNyZE4VMXW/It+b/AATjosGKUgCVuX+lg3hRij6eQyTZyhxD?=
 =?iso-8859-1?Q?GTFaRitHX1J5cadgAj33PM4XtpK1aJDI65f3xmRAlaMSQ7YBQ5FJ2sYzig?=
 =?iso-8859-1?Q?JajEh2Ub9SUZBT/zOCNaXm73IBAc5T8ILQKPUYY/12IdErUH/Ld+KnSrrd?=
 =?iso-8859-1?Q?azaYYC3VVQ5HXSt4JNRoK3Kl2FQeTeeFWLE08his9bMsvbPvMgxf0zsNfO?=
 =?iso-8859-1?Q?bvueJ7dQZLOew44vSuk+HPqBF+TV3Rm7wSIWGPLGM5KYmTcC0ySA+5lj2N?=
 =?iso-8859-1?Q?nox2w2I8mxJKDV4cImCd/c/b/OpSyYFERHqOLI+NtJomEot92YclhaJnPI?=
 =?iso-8859-1?Q?8bgUU//K4xFyM=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB7004.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 415cb717-016e-45cd-c3dc-08dc895fbc81
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jun 2024 15:12:25.7198
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dPoMx2tlf098Vc0YA+SzVf+jQQYG+ICixPVfQt+fWbALhBsVt2YFGBnt5FAtkcZdJANKtMcyNPwdRM3Y6QrJDg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5026
X-OriginatorOrg: intel.com

Hi Jason, Leon,

I come back to this thread to ask a question. Per the discussion in another=
 thread, I have integrated the new dma-mapping API (the first 6 patches of =
this series) to DRM subsystem. The new API seems fit pretty good to our pur=
pose, better than scatter-gather dma-mapping. So we want to continue work w=
ith you to adopt this new API.

Did you test the new API in RDMA subsystem? Or this RFC series was just som=
e untested codes sending out to get people's design feedback? Do you have r=
efined version for us to try? I ask because we are seeing some issues but n=
ot sure whether it is caused by the new API. We are debugging but it would =
be good to also ask at the same time.

Cc Himal/Krishna who are also working/testing the new API.

Thanks,
Oak

> -----Original Message-----
> From: Jason Gunthorpe <jgg@ziepe.ca>
> Sent: Friday, May 3, 2024 12:43 PM
> To: Zeng, Oak <oak.zeng@intel.com>
> Cc: leon@kernel.org; Christoph Hellwig <hch@lst.de>; Robin Murphy
> <robin.murphy@arm.com>; Marek Szyprowski
> <m.szyprowski@samsung.com>; Joerg Roedel <joro@8bytes.org>; Will
> Deacon <will@kernel.org>; Chaitanya Kulkarni <chaitanyak@nvidia.com>;
> Brost, Matthew <matthew.brost@intel.com>; Hellstrom, Thomas
> <thomas.hellstrom@intel.com>; Jonathan Corbet <corbet@lwn.net>; Jens
> Axboe <axboe@kernel.dk>; Keith Busch <kbusch@kernel.org>; Sagi
> Grimberg <sagi@grimberg.me>; Yishai Hadas <yishaih@nvidia.com>;
> Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>; Tian, Kevin
> <kevin.tian@intel.com>; Alex Williamson <alex.williamson@redhat.com>;
> J=E9r=F4me Glisse <jglisse@redhat.com>; Andrew Morton <akpm@linux-
> foundation.org>; linux-doc@vger.kernel.org; linux-kernel@vger.kernel.org;
> linux-block@vger.kernel.org; linux-rdma@vger.kernel.org;
> iommu@lists.linux.dev; linux-nvme@lists.infradead.org;
> kvm@vger.kernel.org; linux-mm@kvack.org; Bart Van Assche
> <bvanassche@acm.org>; Damien Le Moal
> <damien.lemoal@opensource.wdc.com>; Amir Goldstein
> <amir73il@gmail.com>; josef@toxicpanda.com; Martin K. Petersen
> <martin.petersen@oracle.com>; daniel@iogearbox.net; Williams, Dan J
> <dan.j.williams@intel.com>; jack@suse.com; Leon Romanovsky
> <leonro@nvidia.com>; Zhu Yanjun <zyjzyj2000@gmail.com>
> Subject: Re: [RFC RESEND 00/16] Split IOMMU DMA mapping operation to
> two steps
>=20
> On Thu, May 02, 2024 at 11:32:55PM +0000, Zeng, Oak wrote:
>=20
> > > Instead of teaching DMA to know these specific datatypes, let's separ=
ate
> > > existing DMA mapping routine to two steps and give an option to
> advanced
> > > callers (subsystems) perform all calculations internally in advance a=
nd
> > > map pages later when it is needed.
> >
> > I looked into how this scheme can be applied to DRM subsystem and GPU
> drivers.
> >
> > I figured RDMA can apply this scheme because RDMA can calculate the
> > iova size. Per my limited knowledge of rdma, user can register a
> > memory region (the reg_user_mr vfunc) and memory region's sized is
> > used to pre-allocate iova space. And in the RDMA use case, it seems
> > the user registered region can be very big, e.g., 512MiB or even GiB
>=20
> In RDMA the iova would be linked to the SVA granual we discussed
> previously.
>=20
> > In GPU driver, we have a few use cases where we need dma-mapping. Just
> name two:
> >
> > 1) userptr: it is user malloc'ed/mmap'ed memory and registers to gpu
> > (in Intel's driver it is through a vm_bind api, similar to mmap). A
> > userptr can be of any random size, depending on user malloc
> > size. Today we use dma-map-sg for this use case. The down side of
> > our approach is, during userptr invalidation, even if user only
> > munmap partially of an userptr, we invalidate the whole userptr from
> > gpu page table, because there is no way for us to partially
> > dma-unmap the whole sg list. I think we can try your new API in this
> > case. The main benefit of the new approach is the partial munmap
> > case.
>=20
> Yes, this is one of the main things it will improve.
>=20
> > We will have to pre-allocate iova for each userptr, and we have many
> > userptrs of random size... So we might be not as efficient as RDMA
> > case where I assume user register a few big memory regions.
>=20
> You are already doing this. dma_map_sg() does exactly the same IOVA
> allocation under the covers.
>=20
> > 2) system allocator: it is malloc'ed/mmap'ed memory be used for GPU
> > program directly, without any other extra driver API call. We call
> > this use case system allocator.
>=20
> > For system allocator, driver have no knowledge of which virtual
> > address range is valid in advance. So when GPU access a
> > malloc'ed/mmap'ed address, we have a page fault. We then look up a
> > CPU vma which contains the fault address. I guess we can use the CPU
> > vma size to allocate the iova space of the same size?
>=20
> No. You'd follow what we discussed in the other thread.
>=20
> If you do a full SVA then you'd split your MM space into granuals and
> when a fault hits a granual you'd allocate the IOVA for the whole
> granual. RDMA ODP is using a 512M granual currently.
>=20
> If you are doing sub ranges then you'd probably allocate the IOVA for
> the well defined sub range (assuming the typical use case isn't huge)
>=20
> > But there will be a true difficulty to apply your scheme to this use
> > case. It is related to the STICKY flag. As I understand it, the
> > sticky flag is designed for driver to mark "this page/pfn has been
> > populated, no need to re-populate again", roughly...Unlike userptr
> > and RDMA use cases where the backing store of a buffer is always in
> > system memory, in the system allocator use case, the backing store
> > can be changing b/t system memory and GPU's device private
> > memory. Even worse, we have to assume the data migration b/t system
> > and GPU is dynamic. When data is migrated to GPU, we don't need
> > dma-map. And when migration happens to a pfn with STICKY flag, we
> > still need to repopulate this pfn. So you can see, it is not easy to
> > apply this scheme to this use case. At least I can't see an obvious
> > way.
>=20
> You are already doing this today, you are keeping the sg list around
> until you unmap it.
>=20
> Instead of keeping the sg list you'd keep a much smaller datastructure
> per-granual. The sticky bit is simply a convient way for ODP to manage
> the smaller data structure, you don't have to use it.
>=20
> But you do need to keep track of what pages in the granual have been
> DMA mapped - sg list was doing this before. This could be a simple
> bitmap array matching the granual size.
>=20
> Looking (far) forward we may be able to have a "replace" API that
> allows installing a new page unconditionally regardless of what is
> already there.
>=20
> Jason

