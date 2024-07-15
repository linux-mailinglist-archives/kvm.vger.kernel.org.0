Return-Path: <kvm+bounces-21629-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 78E01930F40
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2024 10:02:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 948A1B20E50
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2024 08:02:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D760B1836E4;
	Mon, 15 Jul 2024 08:02:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Xr/91f8F"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 732E92837F
	for <kvm@vger.kernel.org>; Mon, 15 Jul 2024 08:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721030551; cv=fail; b=loYPGhJ8A1gg6t5w4odSzOy3Qwg9peA3scq5AWS40iitsG6zn6XjlvSwDlkNootkPOqhdbVYyXTQ8WimHqE+qCUONxuhccBLVpXSg5p7sJ6Q5iRH5ipxdXwCDpL572NIyWKHNOAOnktG+jSFBwAhNVunJTcHb4BxgLYa7QagcGo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721030551; c=relaxed/simple;
	bh=70pNK7WxlUSlB7lO7uMB9zX/q8PfEbagigca54Hfbow=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ldZMKuaU737eTUHjjd+DM9KDMHPGlprvrWi2G1AAoKlBquvLidYh3eFbWhpRG2AkDXdyATUY3fNLsoeGGA/1Zss0cpLOAXOwQNKZW6kHzbSHbHa9REFpZDHp/pTPr6dGxG7oPUCBA+tFy/cRX2eS4FKdXMUo59s7xHgqFKuNysI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Xr/91f8F; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721030550; x=1752566550;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=70pNK7WxlUSlB7lO7uMB9zX/q8PfEbagigca54Hfbow=;
  b=Xr/91f8FeoIPMqvRhMdCfj5Ros2eo+hOWgl+FPxv0uEGGKTiij1sXb2T
   DPrwei1qMMHhqo4ZyYy1WCGuLPkejmwptXP0kdz4tJgKEdYuhHE/4S56N
   kOfbQ2Kxdm7247NJ4Xd3MaRS7MGx4g3dc97rRgf/BoSP7yWbQ6xV/mXDN
   GlDvMr4c1NfduABFUzY4Z5lBvu7wSfpZ/MVktaxBHbiLGLOO5l3Re22Al
   1/rXexdxyWVGY423oC3I9hEJr/fIzMREjXtZeX12/TA2dxR16w2kiHvGW
   s5dIQ2MCrguJja3KoEKEsGmwrjS/qS1Bd1v7CEIITylfzAcjGFutwO5li
   Q==;
X-CSE-ConnectionGUID: brPgzGkBSQWQJZLjo/Qxuw==
X-CSE-MsgGUID: keWqLg4hScm/FVToc6nmkg==
X-IronPort-AV: E=McAfee;i="6700,10204,11133"; a="18347001"
X-IronPort-AV: E=Sophos;i="6.09,209,1716274800"; 
   d="scan'208";a="18347001"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2024 01:02:28 -0700
X-CSE-ConnectionGUID: +0J+zAzNQoqwCkE6Cj6NxA==
X-CSE-MsgGUID: illoDbAcQcOTaWjUWKQVDA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,209,1716274800"; 
   d="scan'208";a="53916557"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 15 Jul 2024 01:02:11 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 15 Jul 2024 01:02:10 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 15 Jul 2024 01:02:10 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.41) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 15 Jul 2024 01:02:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=W1o4YjJZX9mZ1M2Yzu++JXBtLXXjOPXK0wAu5H/sfis89myFHq+mvPHiT4D8UyFWaKVu7DJ1FWGdzhP2Dus6Hg0KmssIvbWldSi0yRDFtXNWb0T0SeyHdH6+OdKw43nWITT/bhcvaT+gLF2pfQKl7aPkpdaedKBfLNo9RA6E8uLIuvwYPCGs6FL8U2p/IrdNyZd1LhKd6WUl07WtK730zRXK0wC5GIx91MgWfWKUQHdKkz+ONn2xokkFgmRu+v/HpNBlo6ISFys61kfP2uvvrWYCbkRWlewIfkDWuZfpOBfrxXTok5D6ZQrb8+oX3xcW0qfH9uYX6Ii1nvZUu2gEWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yGFrofKVS2SWiDChjB/hUctZTuOT/zl4a8drhabF1/k=;
 b=piOSKTOSaXx5OGcE/DFuoX9KO2exV9R3KOL7GoQXIcqTjQhDBd3xRI8jkZuJltmjWh6soX34hivQtDOdS4So7JU2Oev9o+mcZiR+u+pnbRoLFaJFm1dEWVB8dMgcK38aspw6Z9IKJiK+oHnvYcuaKbewlva1SXa07WRi1AvEv1Eb2Zx0md8JKqKiQ4iUTEnaM/TEJbwog527cIObPpwIX4GFhaDbXbn165PhLyRSdBysYkPwQD1GifIobA6COCRl9s7qwY/mJ6PWsdEB0E+1xgXrfXdOnFtXOLxsGY75UNwy2PNxsVarayfk8h8NDjNFdq8dYAaIzYlKfFr+Pc1syQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SA2PR11MB5209.namprd11.prod.outlook.com (2603:10b6:806:110::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.28; Mon, 15 Jul
 2024 08:02:08 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%3]) with mapi id 15.20.7762.027; Mon, 15 Jul 2024
 08:02:08 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: "Liu, Yi L" <yi.l.liu@intel.com>, "joro@8bytes.org" <joro@8bytes.org>,
	"jgg@nvidia.com" <jgg@nvidia.com>, "baolu.lu@linux.intel.com"
	<baolu.lu@linux.intel.com>
CC: "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"robin.murphy@arm.com" <robin.murphy@arm.com>, "eric.auger@redhat.com"
	<eric.auger@redhat.com>, "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "chao.p.peng@linux.intel.com"
	<chao.p.peng@linux.intel.com>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>
Subject: RE: [PATCH 6/6] iommu: Make set_dev_pasid op support domain
 replacement
Thread-Topic: [PATCH 6/6] iommu: Make set_dev_pasid op support domain
 replacement
Thread-Index: AQHayTj7IcSunTJlWUCyfM94ydnR4rH3h89g
Date: Mon, 15 Jul 2024 08:02:08 +0000
Message-ID: <BN9PR11MB527693855A23F517DE3830FB8CA12@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240628085538.47049-1-yi.l.liu@intel.com>
 <20240628085538.47049-7-yi.l.liu@intel.com>
In-Reply-To: <20240628085538.47049-7-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SA2PR11MB5209:EE_
x-ms-office365-filtering-correlation-id: 1d241e64-1c3d-4720-e6af-08dca4a46c72
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?kiPOfQ90kuihEAhGEfXdrn7zddbSn5gJoex+oblIH+bKFs9YXsw8DtwdG/nW?=
 =?us-ascii?Q?NS9ScLeigBdHCslPU7Qtr40ErKAkCqB1DRikK+9+4dHcBxaOgepKG27x4zK+?=
 =?us-ascii?Q?1peGwQD1nqMbQPT37xSn1yee+8/QUpWcXHleiglM2DyPqrCi2fOjuR1Y9xX8?=
 =?us-ascii?Q?xAjgQFYnAoNgjZg6HdzualIopvGBRcIKOL3vhlFGfnPI/+sFkJ7aiSXDWYss?=
 =?us-ascii?Q?eM9fMtYBLz4HWFBBQLkBR0byTpNP4VvcF/kNDJzPmb9vcoWipPPSKdL5lYZ7?=
 =?us-ascii?Q?Z3Pm9SXDeCKu7bxjKBrpx8pPDDyxk/PMs3QsK/Q9uNXZNeBeZ8b8pcM0/bPz?=
 =?us-ascii?Q?tNEOwBZQaFLn+ASlvV8Gqbt5QyMRVITnUP4Loean2EzNlbzp/I4nNsDHRicx?=
 =?us-ascii?Q?jBZnsrYf/6ow7KEtnyuloWZ1GcsMpYBJ0SimMuklrKbRDmdasQ8OYWLj08dg?=
 =?us-ascii?Q?7Z4pBtS07dqETdA9NP730krR6/U1ptPefLsBEs3gHnxkh6b/VAchC9KxuERV?=
 =?us-ascii?Q?nBYDfSsgFvBQkOWwIhKvkyZ1HCNdiQeUixqj75EbhFPJDrZBlmpdr8w2x5SN?=
 =?us-ascii?Q?kXlnubwREF0mF25D34FcBrWXMyzm80isjNlIX2eIB8FpV9to9iweqPw9zJBm?=
 =?us-ascii?Q?6Ltk9P+UpnXouKFJ2g8AeaSPD5gITJFNvPVl734BJ5J2k5wk9GTVGj2Hbj4h?=
 =?us-ascii?Q?4j7HRVgSb//+Oaq1ImrCmeSZRhnE3XCbvJAt/Ce2TGndkAUoTgeDe4ONchWm?=
 =?us-ascii?Q?s36+9QKAJ+Wyg6IgjC1/WCTc8EnBLr5qdSQz+Hw4LPyoCEgtbQ8kaM1eeUWc?=
 =?us-ascii?Q?wFnwZQTYnUd9xXJuhvwKDDt4kkSmdDOcN7xfBae/gx1XySGvawcwr/foTYYf?=
 =?us-ascii?Q?YG27ZSt/r4Cwrw6a6CpXRXAIgChYS2/GsaYqWLN9D7wSP3OejBNcEkZqMEgM?=
 =?us-ascii?Q?7fsS6M01vLttpGNMAw5kQMjZvIrR5c/l4i8bFrgeuDWCcDlmhoEEEeam2TxY?=
 =?us-ascii?Q?NJIZxtVK2f5tBY6J8GFgHjfugA2VihCp54ssix1Mkejg3RTdcMAzU7pqQQ/k?=
 =?us-ascii?Q?ruVbGdICS1JGW2hKsQ1vYnWjIX1kBAfqFM+RSFqOLB53RZ6r7kMNCTnsVQyH?=
 =?us-ascii?Q?mNb2wGHh0mh3s9vPRivvxcI5qJ1mG1J+x+yntg+WGhxlg3Sx9y3oCBx7HJPT?=
 =?us-ascii?Q?iJaA2uKHhPteHaBpdDiLikqqBJ3JZYqf8ozrzW3VMsOBtj5U8aPlMo5g1C9G?=
 =?us-ascii?Q?FUiDVQUg149rkxEGB6F6T0+pgjj0hZt8ySdzJufHRk5WRT4v6uCCOHEnyCed?=
 =?us-ascii?Q?KHF6kFpD+YDEx5/NUOP1p9QXXcGI+pFnuDfhJ8T9VpccucnsTRBImaKkyOye?=
 =?us-ascii?Q?XCZ/CiokfQB+/p+FknqSTgdnrU+w3m4m6o74TibCRdAJ8ouGag=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ED0GqSEpMuuSFcFMIUg8AYSRNM8PKj11H6MQMMEmizgZyBYO2tBPlAHTlf1R?=
 =?us-ascii?Q?56oiG+sjZavkIX3VsWaHuAdZqiJC+Gg9VmlaFaBOdgDx24OV366k35EwFIFf?=
 =?us-ascii?Q?DYwJn6tnd1V/C0uKbN+FbRraf/LQKM1pfm746x6vXR4uJHVQIymcpi8G3EG7?=
 =?us-ascii?Q?ptHXuruCenk4EAXjpyi8x/70ebzb19GuQpBw3il/y01US06qzrOVm6zn5RST?=
 =?us-ascii?Q?SoTqRbmz0Fe3kkJFFTeMxV20g2FJBdxTf37dFtQQHCg2tTkPyFV2Dx0dNkO5?=
 =?us-ascii?Q?RS/d+KGjXqcLYoNe66fKhXuzJsBXfWjJXQBnSMNOnQZRORcCjtnCHZbOSczx?=
 =?us-ascii?Q?k82S2JAYfyqpIA1oZYdQxNRtt4oxqcsxe+UwXXjrKibX8fvZ1PEWLPhY8Phq?=
 =?us-ascii?Q?NXVQMtzlT33/Z+i/INZvoIyB/Rm5dgyOsb1a1nUtIIdq4S3EuBhKXHPjG/n+?=
 =?us-ascii?Q?Wo7h29rIkyrrV7jtYXha6R4o7AwC2ga+G82VXVRWBw4MKZ/ALttxqy2juW5X?=
 =?us-ascii?Q?OMQBMajOSELJRCOe4G7jZB8JMMLnv8iflEdmV5T2QgVtiaf+ZHHz1M3TgrC+?=
 =?us-ascii?Q?+a1wzVJiHpkVaSmWfRLTuv7S0z5Ss37UmRU2uKA1VYHvPxJ68FW1GiAws9po?=
 =?us-ascii?Q?TQQpoibm/UZbO9FHw2IFf3mXX5U9L60A8Uu2l0OXoDOFHQAUZIrryxq9oQRN?=
 =?us-ascii?Q?GE69CMZgmCUxpjIpXQgn6hD/m/2Oa+nO59AGzRUkPhMfc5l5pJuAeESpvOsw?=
 =?us-ascii?Q?QU0zQ9shrXWSYQFKKDgOEv5Natvmnr/6YdVu762RmNJ7K8jZW9Wo2aqq9Dgo?=
 =?us-ascii?Q?1WuvIfLpQbX1DNUM/CdAg9iKPsjGQddL/nnYCgaAVKn6l0KkCAIHbVCfY4pl?=
 =?us-ascii?Q?SE5CgxaYOqCKf4NpsAD8DwFHlvf0PHAu4abprfjV4pqOWFmok/YyXz3cPQXr?=
 =?us-ascii?Q?wCE4fd0Nf/NgPZcjjiMP41k+EVgEmm4ux9F5YdksAaQ5cl9Eg2un6eys+s06?=
 =?us-ascii?Q?YfUilWwjIq4H3iBtZwrHKRQC7VOoYm0tCa/vlPzlRQrYk7BWNLJQ5M4ECx3z?=
 =?us-ascii?Q?9Mw38On4NDMihKDJzjfqeQRSiB6MjV8u3lZa6MtqjQ/2z5nPbZ+eUw6Lr4cC?=
 =?us-ascii?Q?MUbyFr4ok6TYBj8HpjeUyHWDDy2eAVKA5O8LMREDfcyvoNgMGOXGF1FFVYyG?=
 =?us-ascii?Q?jxymfLYMmNkeQk8N9oSWVgKauzjSH3qoW514SPLYzhV2NQlf+odOr597nNk0?=
 =?us-ascii?Q?1lhgGv0FV3jjzJJvlJUQ9kd/S1l7j5+IvUoqWMOcKX8DOYZc1Gbhvl4rqwOy?=
 =?us-ascii?Q?iGFrhxPcnBcwAL/dw2qlQUpxWQySvD83VBvY3Kke1Qrz0HT/uL3AmO4Ttc3I?=
 =?us-ascii?Q?+NNYKDficXLMsTUf7NaVZYU1m7ZYeetYBGdi3xbcfH8xU7NK3rUGeL3slbGt?=
 =?us-ascii?Q?h5iyUjvA2DDukKE1VWemtHzgrlOMZu2wweqOa9nxmTOpXF3N5T7Ge2JmI5rs?=
 =?us-ascii?Q?wV07cJ4bLkhmM+LeCbPU2DWkF3oGE65YOo7J5oI7o1yXkjNR2wsaAO8so5Io?=
 =?us-ascii?Q?5cHKRLkPzhHuY2WAhmnF9uCK4+JdQvYYh6O0qRhk?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d241e64-1c3d-4720-e6af-08dca4a46c72
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jul 2024 08:02:08.0798
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: v7Dj/1HJMYF8T5IUiBKo1UsQraZ86tQRAmK0U9JkYIGQKfCJykFUANCXZVJ/4HAQkz6yFpzRfR7VRNf0XrjwGg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5209
X-OriginatorOrg: intel.com

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Friday, June 28, 2024 4:56 PM
>=20
> The iommu core is going to support domain replacement for pasid, it needs
> to make the set_dev_pasid op support replacing domain and keep the old
> domain config in the failure case.
>=20
> Currently only the Intel iommu driver supports the latest set_dev_pasid
> op definition. ARM and AMD iommu driver do not support domain
> replacement
> for pasid yet, both drivers would fail the set_dev_pasid op to keep the
> old config if the input @old is non-NULL.

why splitting this from patch01?

>=20
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> ---
>  drivers/iommu/amd/pasid.c                       | 3 +++
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c | 3 +++
>  include/linux/iommu.h                           | 3 ++-
>  3 files changed, 8 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/iommu/amd/pasid.c b/drivers/iommu/amd/pasid.c
> index 77bf5f5f947a..30e27bda3fac 100644
> --- a/drivers/iommu/amd/pasid.c
> +++ b/drivers/iommu/amd/pasid.c
> @@ -109,6 +109,9 @@ int iommu_sva_set_dev_pasid(struct iommu_domain
> *domain,
>  	unsigned long flags;
>  	int ret =3D -EINVAL;
>=20
> +	if (old)
> +		return -EOPNOTSUPP;
> +
>  	/* PASID zero is used for requests from the I/O device without PASID
> */
>  	if (!is_pasid_valid(dev_data, pasid))
>  		return ret;
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> index c058949749cb..a1e411c71efa 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> @@ -637,6 +637,9 @@ static int arm_smmu_sva_set_dev_pasid(struct
> iommu_domain *domain,
>  	int ret =3D 0;
>  	struct mm_struct *mm =3D domain->mm;
>=20
> +	if (old)
> +		return -EOPNOTSUPP;
> +
>  	if (mm_get_enqcmd_pasid(mm) !=3D id)
>  		return -EINVAL;
>=20
> diff --git a/include/linux/iommu.h b/include/linux/iommu.h
> index a33f53aab61b..3259f77ff2e3 100644
> --- a/include/linux/iommu.h
> +++ b/include/linux/iommu.h
> @@ -607,7 +607,8 @@ struct iommu_ops {
>   * * EBUSY	- device is attached to a domain and cannot be changed
>   * * ENODEV	- device specific errors, not able to be attached
>   * * <others>	- treated as ENODEV by the caller. Use is discouraged
> - * @set_dev_pasid: set an iommu domain to a pasid of device
> + * @set_dev_pasid: set or replace an iommu domain to a pasid of device.
> The pasid of
> + *                 the device should be left in the old config in error =
case.
>   * @map_pages: map a physically contiguous set of pages of the same size
> to
>   *             an iommu domain.
>   * @unmap_pages: unmap a number of pages of the same size from an
> iommu domain
> --
> 2.34.1


