Return-Path: <kvm+bounces-30858-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 92C0E9BDFD7
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 08:58:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1F5831F24746
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 07:58:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8DD71D278B;
	Wed,  6 Nov 2024 07:58:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="c7IeCTZQ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C8E61D1E96
	for <kvm@vger.kernel.org>; Wed,  6 Nov 2024 07:58:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730879915; cv=fail; b=da/uIlikkQBUSAls3IRUUpKSAlUd25Ym82p9rM3rGi3NJXnN/DQnYxDtbmUI7sU9dXYvjWjV+71ZTkoJILnLyhxAPSUSp4QZKk1Oetr+5BhMuNgHZTDBtY7uo5L5UqsKPa7Ie5x7wNSAdqkSiq+QnIQlsJaFfuwaw/lmG9FHZ6A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730879915; c=relaxed/simple;
	bh=tSTVGHxh0SHmP17AfdB8x+2t0y6eMSeqmhBrSt1Q574=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=EvfpzzKZwLUNT7wqONV2Zik8xatJwPqXWRqhnOufxKZ/CnrD6P1nYxjMuVsxC7fhJ8oSNADYDNV6yyFwaDQPMtQpM/da5/uLc3KwUslJTIuF0k1/g/IoUyjJ5nOYykPk0iwcfmLQahlaGLQSEOdqR2vwH2TSB94+3Z1xzKBox/A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=c7IeCTZQ; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730879912; x=1762415912;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=tSTVGHxh0SHmP17AfdB8x+2t0y6eMSeqmhBrSt1Q574=;
  b=c7IeCTZQ4LBYDYHQfbV4lALa0u604ZZKAySd4sG+r821kBWIEPsxiviX
   4CgpwffWRnea3S1bzazOsqxjfo+FpOvasU1oOikW7hpQGI7gyrTn/HciR
   xtM7kkDu+nCnfDnJf++UnJ6vBXgMzPyOLKCeo0d1eSYqE+nK3/RDx8PTa
   ijiqi+ZyMgd0nMFgX9MElXik+jr4Wwe11UnSOSrnQuCfK5rawAKSdYeT0
   6zyp+8412H0+sfZBsNCknrGvw1PVidCqzD2/XkOg9hn5JTQpHqCdmBJw6
   t2yR4FURMRKiJzO2iFtHsPkqG5T/Sj7e7aE6mr1CxFy2FBqDDqTpfn2KL
   Q==;
X-CSE-ConnectionGUID: DvWEm7eoSUykO02YbDzW0A==
X-CSE-MsgGUID: VQtXwG+BSBWDeAkMNMxTrQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="30824517"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="30824517"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2024 23:58:32 -0800
X-CSE-ConnectionGUID: 7+VM5ggnTr6i+qOKOTTw1A==
X-CSE-MsgGUID: qz9upmruTbW+SWaI/tJRkQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,262,1725346800"; 
   d="scan'208";a="121908592"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 05 Nov 2024 23:58:31 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 5 Nov 2024 23:58:31 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 5 Nov 2024 23:58:31 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.173)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 5 Nov 2024 23:58:30 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LYEAFlHgnN9tAZGf6zhHeNiczrfbVRbxiE8dTGkk19G31QIrhmfW/pqwC3DSX/e78DFNc9oM0lcyX6ygSkSU58qaRAHB9CPRVdDk/TmpL86yQj23ceePJxr0soMAAtnI52RXIxvdSgNV8hWjaiK61/dJw+o2kDQ+8aZ+MhQFiIDTMUYza6ncibgThttucSQvAPaJ86z4NBzAKjh4b7bpRW85X+3uz8Yw5GcuqvmGtJT//eCGbFayzarQ23PEcKd5GD+hJ1mfaiy27rYt8LGTa3c8/7RhQ7EciNBtZwgugD5pJjaAuXSsrBwaJNV5wjMG3RdnuN/iMv/pz37M10OGsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bJUWub6ARASfn4Q7TTfGbiStD02u/fN9F4PAxpxJlx8=;
 b=AaAsBx3s5CPdhL3Pn8zmhcyuB/EIWGKAldlmAdOL9/Y1cHSmx1btxUzQlfxOdxuvkc90+On+iA2jIphUgUZJ/asvUcehkSUTevm81KJAXF7HBygw2YhKYQbPlEoOonTNWzO/Reg094RIqsyRY1f6O4CyvttshEIyN1vkesF1SUoP3LWtnjQK4vvEfsySVWA6fItIl3q2ar56XPTcLQ7e+O67ce98rAA+sYVymFxG2TDXiof+u8tERo5SIyT5gTos6ynVGk8lUfN1EHqpFIuzdIoZ3pKVXM9cqJXc3LMytADa/1mDupWsewtHtEROS//nOk5kw9cjRKDDFjMga7TZMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by CO1PR11MB4948.namprd11.prod.outlook.com (2603:10b6:303:9b::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.19; Wed, 6 Nov
 2024 07:58:23 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%5]) with mapi id 15.20.8137.018; Wed, 6 Nov 2024
 07:58:23 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: "Liu, Yi L" <yi.l.liu@intel.com>, "joro@8bytes.org" <joro@8bytes.org>,
	"jgg@nvidia.com" <jgg@nvidia.com>, "baolu.lu@linux.intel.com"
	<baolu.lu@linux.intel.com>
CC: "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"eric.auger@redhat.com" <eric.auger@redhat.com>, "nicolinc@nvidia.com"
	<nicolinc@nvidia.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>, "Duan, Zhenzhong"
	<zhenzhong.duan@intel.com>, "vasant.hegde@amd.com" <vasant.hegde@amd.com>,
	"will@kernel.org" <will@kernel.org>
Subject: RE: [PATCH v4 09/13] iommu/vt-d: Consolidate the dev_pasid code in
 intel_svm_set_dev_pasid()
Thread-Topic: [PATCH v4 09/13] iommu/vt-d: Consolidate the dev_pasid code in
 intel_svm_set_dev_pasid()
Thread-Index: AQHbLrwiEex+Yt8D1Em3EU85llHf+LKp5AdQ
Date: Wed, 6 Nov 2024 07:58:23 +0000
Message-ID: <BN9PR11MB52761D13658EC399BA2DE4BD8C532@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20241104131842.13303-1-yi.l.liu@intel.com>
 <20241104131842.13303-10-yi.l.liu@intel.com>
In-Reply-To: <20241104131842.13303-10-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|CO1PR11MB4948:EE_
x-ms-office365-filtering-correlation-id: 673fa87d-4dd7-4a4f-a68d-08dcfe38c97d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?1CWSLJBKmx/kCKQpI0fXDSK30oNy7dbXxruHryktQRWpkQmIjoZJjt5vmQQH?=
 =?us-ascii?Q?0mHN+rsYJ0UpZryEamPQ6f74vyi2SrpHZ4HShDos+39IqMEGMB4LXDobF04n?=
 =?us-ascii?Q?l9ai+infB6xkBNKwodSenQ15lD1nPv1eiIRnWwNpiCRgeTwYwg9HbtQIeL58?=
 =?us-ascii?Q?REEntwT38QYT+kejo7Vd0G2E8CdX+BP2zLC8o2Kmtv2bvHfb0aIW8eM9DmbV?=
 =?us-ascii?Q?KDE4cawxhqSKTyyJKtBM9GB0xUDU/i/XdHEC0VIP6cv1ec8stxyQt5EipjsR?=
 =?us-ascii?Q?Zi8AXCDtjZ/E/olAWFSsd2D3v7jWEYsHB4lC0UwUEHrwxgtkM8BRUxIpbouy?=
 =?us-ascii?Q?qDSFp+eJPZE7oXRq+ZAUfqjOXHHuBBnmLR1wN1GVR5CpVxXHGcLnKYcQYzhs?=
 =?us-ascii?Q?tJ8IU6EfYA9Nxi6nGJ0rzOBXU9lTbfB9D8ZDS3H813M29PbRAnuoJHq0Rtgy?=
 =?us-ascii?Q?Q7PA66eZZyRzQ0Xsz4DdJZZTRlqmyjNWi68qvFM9xHnbgw2UhrIIQcKwA41l?=
 =?us-ascii?Q?/m41xCLs90VZV6XbAGlM/16C0t4YVznnfLF0VZLctfvN4m589ZP0SGcSpIXZ?=
 =?us-ascii?Q?YecaHbBp/yzLiE2JXnVHvJuOwVWsA6zzOFnawPh1ZnbNDAZmc38xn7V7Pj4C?=
 =?us-ascii?Q?8SoXYGS3VZA0/0fb6Hc+Ax2O6IKF5hMgqLocdH8d/Uxtm9rgrv9PMCbuwgUQ?=
 =?us-ascii?Q?0dmlMaW156/45Ux7tb1+LeORdY4DESlYHzhQ9Mj4Weh3cR/InwaAneZ43PHt?=
 =?us-ascii?Q?eYtpICwI/zLfsNUEeG6QvkJ3u0MCZdfLJ/5vCKtGbuqulpm++75XEXYFwPiX?=
 =?us-ascii?Q?rNNCtZmDUQB5NIsv+zINrLwMDqu1MmntC/zp8seBtHcKRy9RfifLWaGZwf2S?=
 =?us-ascii?Q?M1U5TFo7kU4k4Nk3EXBGKLxWO482o9wQhdzWK4IIqj7sfzQ5p6v71+MJtjCz?=
 =?us-ascii?Q?S3I2qny6DxmgHgrL79zc9+8pdmdYGIO9z4zmM+oNF4uTbs243SPyCiojCIju?=
 =?us-ascii?Q?22oUeP3RoUA/asH2dN4HuTPf5lG7LRgMkyYMhHjLJGoiy+NhTCDSwK4gYkSE?=
 =?us-ascii?Q?1uZwJPUmqyLzdejrjvtjRBdks3e8s1fr8sN37ImPDeKZ/sraM9y7iS3GEDgS?=
 =?us-ascii?Q?pVzpiqY7jrimiAPnIOATc2bNahXPXrxveZ/lCe/95jx/sU0jBXj9uKgzltAP?=
 =?us-ascii?Q?9jWElsjNL2jUY0TGurQyKtz0dgwuvAeULIe4BKmZDzupidbThwEjhDM+9CMB?=
 =?us-ascii?Q?+QpHcvAeGf5tXqKPh8nh9FM+pq1R3uTFfUnlVOxh+QXfCqC/3kYI2BfwQVcQ?=
 =?us-ascii?Q?prQicWfI18m2v7nlY/LAMlbuwxqb6dhOyVjbG7TO/u6sNg1jrtIAfONUZRlz?=
 =?us-ascii?Q?xro8vXk=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?cBG31C5IwVWcTksVV3sNTAeyODmxFR2txUHMQAuKHuUseY9YnJxa5Y87Da3v?=
 =?us-ascii?Q?quL8N87+YA+A/k7J+pKOqe93WDQSNO5amuYU1rEtL0bnQI20DijMyjb/8xoF?=
 =?us-ascii?Q?2OlhGDA8innw/rh3mdFbtKqzhc4OcoI56yC2n+Uu3luCaqN+TgQRyk0GkRAZ?=
 =?us-ascii?Q?6wS+fxaXvaaBGBLq/eWLc88yP2J85THIw5z+3Gb90NOHz/fZZqx/cs5dyMKv?=
 =?us-ascii?Q?ZVJEBp3MfbCkbuT1W+E8ZhbmGnE2n99FnbEYuuUt4bvex1kK2CRDqT8V3oPB?=
 =?us-ascii?Q?owOTo1AK4GyRI4U7bu+3fKjcRB5rjQWiYy5TewPxSQQGoBJwzGg7QmNXDHtL?=
 =?us-ascii?Q?I8dLQByxTKw4jqTWPSjSthz4q1qw0N0E1FhUtTsks3uD/iZkmS8gjS/qtotU?=
 =?us-ascii?Q?LToXV+/VlxTcz4PGjOSwaTZjRBEgle3MN2HUeh3B6owKPih+hQTduSl3xihq?=
 =?us-ascii?Q?8LsFTExRMuyEDWtvmyps7FpgEov4+FCzVlgZrmKpk12mqjPfw8XonJjiKCLA?=
 =?us-ascii?Q?aa2jK0symjIA7o6s7Hc+8Tr/HNOerBelfMfG6YywYsVCEPuuQRi0DuhZMW0i?=
 =?us-ascii?Q?DJJAEWlUCRAJeY377V0sDxWfO4L/V9rzsjHgCZX80N0EZw1qwuE2ISKx28xB?=
 =?us-ascii?Q?M7SLMoCzTDeL3GTkxq5zK2RLRtcHgguAdPthTetO1gEZOE1kv8Ma5k5rj/dR?=
 =?us-ascii?Q?Pf6xgNyejepH66EHtV+HGL9k5Q7IVeD/qhONB/7k92xvJQqb4qYaIZYHVPT1?=
 =?us-ascii?Q?eP8P7w15IdFoTgrxjA4PTaRmNTByQ8+3psATWR3MnxJxHvfwJ6Jk0Plslq+m?=
 =?us-ascii?Q?CowKTZJlXkfYyfMfSelssQiAwRAHRB1L6lOLwmmd9UkxQ4jb1vlVGQCI13Ua?=
 =?us-ascii?Q?E30jzgStEnRREHWJmT7oybn0aiDuJDWfTKIGX/MlzqjaPrMYa+mVPv8u/GWQ?=
 =?us-ascii?Q?uAa+zY9zFcbl4WsdHIurGDBatUstfJWPfokY7gw/GDqsjtCiPMlI6BaPjVZG?=
 =?us-ascii?Q?br3dpkg75tX5+RXpcPpVR8OHfL96J/wh/OWfemQocSh0wfoGUzPabMXAb4vY?=
 =?us-ascii?Q?1nrUrb7My/sp78uYWaVeMktB/KAml28PCvUBOsGabb13/on5WCq+YYKUJo1w?=
 =?us-ascii?Q?o1JL3+l30dpIKAOGiky+DVVKfMIAcoluiqN994I49oGN9PTvfWEzjZrWbr6E?=
 =?us-ascii?Q?OUCxUT9KakThJzSD/RH2cpLpLl5AuFaKy+H4i13+uQxNDoLehIoYRSMFedhJ?=
 =?us-ascii?Q?yNezTCk1VzNyx2uMZ0uvlCVHlayfhj87ID6aMq9q38fla/bp60ObGjst1fGN?=
 =?us-ascii?Q?fBi8TPUsLu8VUygO1jsaXQWv1F5NLOTSwXoZFYfhnHkQVlapGdeD8Aznvff1?=
 =?us-ascii?Q?Xhi+MQRk8JRAyZwX/8iAWLGePk4mvD7oPodMV5cQn3/Ti8HFbZV8v40RnY/j?=
 =?us-ascii?Q?HYO2yJYp+uSz5HqevONfFbtN0P+AlupgUcVvNVteoBPodDNHiNwpIbsLvCI1?=
 =?us-ascii?Q?SMM0go723bGxtbvQwOowUNm55VDVZzaA63AFdlw4wlSF1l3VzD0qO+S3BQ9n?=
 =?us-ascii?Q?FqtrBSu7l0OCwhTqBW8N1/G1TcLLLqMyc6JWPzl9?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 673fa87d-4dd7-4a4f-a68d-08dcfe38c97d
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Nov 2024 07:58:23.1468
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qKERk/RoLJbLbRODxipNDEHU8yjNh+VGQ7MA7ito3V8qXOZhYNJ1uhnUCjF6mC3I43K5pjUUnr74kIKJH7/0Dw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4948
X-OriginatorOrg: intel.com

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Monday, November 4, 2024 9:19 PM
>=20
> Use the domain_add_dev_pasid() and domain_remove_dev_pasid().
>=20
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>

this could move to follow patch5 as it's an immediate user on the
two helpers before talking about replacement.

> @@ -201,43 +201,29 @@ static int intel_svm_set_dev_pasid(struct
> iommu_domain *domain,
>  				   struct iommu_domain *old)
>  {
>  	struct device_domain_info *info =3D dev_iommu_priv_get(dev);
> -	struct dmar_domain *dmar_domain =3D to_dmar_domain(domain);
>  	struct intel_iommu *iommu =3D info->iommu;
>  	struct mm_struct *mm =3D domain->mm;
>  	struct dev_pasid_info *dev_pasid;
>  	unsigned long sflags;
> -	unsigned long flags;
>  	int ret =3D 0;
>=20
> -	dev_pasid =3D kzalloc(sizeof(*dev_pasid), GFP_KERNEL);
> -	if (!dev_pasid)
> -		return -ENOMEM;
> -
> -	dev_pasid->dev =3D dev;
> -	dev_pasid->pasid =3D pasid;
> -
> -	ret =3D cache_tag_assign_domain(to_dmar_domain(domain), dev,
> pasid);
> -	if (ret)
> -		goto free_dev_pasid;
> +	dev_pasid =3D domain_add_dev_pasid(domain, dev, pasid);
> +	if (IS_ERR(dev_pasid))
> +		return PTR_ERR(dev_pasid);
>=20
>  	/* Setup the pasid table: */
>  	sflags =3D cpu_feature_enabled(X86_FEATURE_LA57) ?
> PASID_FLAG_FL5LP : 0;
>  	ret =3D intel_pasid_setup_first_level(iommu, dev, mm->pgd, pasid,
>  					    FLPT_DEFAULT_DID, sflags);
>  	if (ret)
> -		goto unassign_tag;
> +		goto out_remove_dev_pasid;
>=20
> -	spin_lock_irqsave(&dmar_domain->lock, flags);
> -	list_add(&dev_pasid->link_domain, &dmar_domain->dev_pasids);
> -	spin_unlock_irqrestore(&dmar_domain->lock, flags);
> +	domain_remove_dev_pasid(old, dev, pasid);
>=20

this also changes the order between pasid entry setup and the list
update. and intel_mm_release() walks the dev_pasids list and
call intel_pasid_tear_down_entry() which WARN_ON if an entry
is not valid.

but looks it's still OK here as intel_mm_release() is triggered in
the last step of iommu_domain_free() which cannot happen
when an attach is still in progress.

Just raise this point in case something is overlooked. otherwise,

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

