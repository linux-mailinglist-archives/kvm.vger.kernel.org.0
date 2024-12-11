Return-Path: <kvm+bounces-33478-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 165A09EC708
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2024 09:24:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9739B2868C0
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2024 08:24:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99C741D86FF;
	Wed, 11 Dec 2024 08:24:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SipT3kvD"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 510C01D86E6
	for <kvm@vger.kernel.org>; Wed, 11 Dec 2024 08:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733905452; cv=fail; b=AID4QtrbyP1syi6n14iRqPdcBeraVSCGnxnd6h+wH1CuOmqohx9REz77y6p7N1wUP2NbS9eDebMeIaJCYHKxdY6CUMYiiJBmzwLRuEbpiKDbl6mZ5vEeZGRagyuWHsUvy2KCLyOCFdvNBA/wXBeUNqfWz8l1XT3K2q/ZVfawnSw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733905452; c=relaxed/simple;
	bh=wO/3iPKDlRmaPo/g6n1Xl+L5mrpR23xYR7vJnYjIFxE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=aNm4eFA4yMdYdZ/MXKEvnMJStjSEgZ7oR93Qfp1qIw6I3jfQJg2vJRTjKWZliBtNhCE0MhjKP4C9yXNEA0zkfywnqkdCvPDCTmGhqVsDR2PkhHaEitsu0ZOnvnjfKxxIdAC4utzUpJI5EPbbU5R0lr6MB+Jt6jOHMvin/giAIPM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SipT3kvD; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733905451; x=1765441451;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=wO/3iPKDlRmaPo/g6n1Xl+L5mrpR23xYR7vJnYjIFxE=;
  b=SipT3kvD/UXrzmumhYdqPZT2rNF8S2mU0Qadc2IJp2GzIhF8whBwPcnH
   8XJBNofLWLo6t+5MdMueYDgGmF0RcLIqE5DD5fu5bn/mr3GJy6m9Xr92E
   nqEQH2SwzhFHXP9NW7+GljZdZSlewarWPQaIWaPyvcz/mtA9BpaSA1mdv
   O6Zi0LRxRAIZxgBu4vvERzfNJD6lWliUKXiiZv2FhBsuZiUsWpvdtrmEa
   kY00bt0tnFex06BX4eoogoalFS0fBY8OiiAGDSyP7i8SQgEFZn73TGjrh
   6LkwkFDCZ/QRVhc5Ec+NORj6C3IZpACN1JUqu3Az589KeS84NqigaG7Sc
   w==;
X-CSE-ConnectionGUID: r72GyKJlSQS8y/rRLKh5wQ==
X-CSE-MsgGUID: KWBphwGATVKH2jiDGKSPlQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11282"; a="33594554"
X-IronPort-AV: E=Sophos;i="6.12,225,1728975600"; 
   d="scan'208";a="33594554"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Dec 2024 00:24:11 -0800
X-CSE-ConnectionGUID: bQU+gfKXRZ22J1FWzimNeQ==
X-CSE-MsgGUID: bJ8BGunaQxeIA4YQBN+mCw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,225,1728975600"; 
   d="scan'208";a="95547578"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 11 Dec 2024 00:24:11 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 11 Dec 2024 00:24:10 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 11 Dec 2024 00:24:10 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.170)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 11 Dec 2024 00:24:10 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fnITnsHmKncR77pSi57iIXUKgUGpEMJNmGE3ES+FzNMsIMDfjFlsfJ2/6urrNkWVfO2mSx3FPjl8zlV/gTzyLQUU12CdfTkle1/ID/Os0y+2B8ps1M75C3Cw4+hsJqZossCpCn2J42bbRVzXOeI0lYlNblRgSAkxIbRz1H681fueYz/ieKSPCrPcQGNoQXxIa1UDXXg4fb0seXChpyMpss1bg5clzPOeNAUwjAXSBW7wtd8FZ/Lijht9No7RlX17hlPMF2OwLFJ2wBdxgqLg6v2wXmQvUEWTcpfTZL/I6z8SbK9ARPKCm4fhj/PzeYEMyvpcYto1cO2vUlZlH2Oy7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wO/3iPKDlRmaPo/g6n1Xl+L5mrpR23xYR7vJnYjIFxE=;
 b=jZa9pinG0sLJitsz7g6uCQHfw9jP/cfhjJOHd7AQ6hHMKmfw/UrsUomPcmfvF+heS1BTrmDBIeEzpLNkmovhPNNdZZE+jse6irwYyb+2JorsWqEVdjWTnd6y/ZXPTc10QRRK1GP1ZOnkzuZSafyTyrWHmfL9Lt/9jkJbXMhpxGJqosAMvlgAGlQhzI802JqKfKv9x5YtjvEqo1IpdV2870LK0ToH5ys7detQgYZBsQCETYWwDRT/XfuexbFp3iJo031eKUM6sEBAkIL0/b4hlcGIRxKHoIY06y9HoCllTdXFhmAfqcIRv9lko3xoGDTBYTSKuFqs+0UKyCPaJJNf5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BL3PR11MB6436.namprd11.prod.outlook.com (2603:10b6:208:3bc::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8230.18; Wed, 11 Dec
 2024 08:24:07 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%5]) with mapi id 15.20.8251.008; Wed, 11 Dec 2024
 08:24:07 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: "Liu, Yi L" <yi.l.liu@intel.com>, "joro@8bytes.org" <joro@8bytes.org>,
	"jgg@nvidia.com" <jgg@nvidia.com>, "baolu.lu@linux.intel.com"
	<baolu.lu@linux.intel.com>
CC: "eric.auger@redhat.com" <eric.auger@redhat.com>, "nicolinc@nvidia.com"
	<nicolinc@nvidia.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>, "Duan, Zhenzhong"
	<zhenzhong.duan@intel.com>, "vasant.hegde@amd.com" <vasant.hegde@amd.com>,
	"will@kernel.org" <will@kernel.org>
Subject: RE: [PATCH v6 1/7] iommu: Prevent pasid attach if no
 ops->remove_dev_pasid
Thread-Topic: [PATCH v6 1/7] iommu: Prevent pasid attach if no
 ops->remove_dev_pasid
Thread-Index: AQHbRkgyB8ce9RGAJECrmGcvJoXCP7Lgv28g
Date: Wed, 11 Dec 2024 08:24:07 +0000
Message-ID: <BN9PR11MB527647D5B2F24E8B69A4EE3B8C3E2@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20241204122928.11987-1-yi.l.liu@intel.com>
 <20241204122928.11987-2-yi.l.liu@intel.com>
In-Reply-To: <20241204122928.11987-2-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|BL3PR11MB6436:EE_
x-ms-office365-filtering-correlation-id: f18d5e7f-4f4e-41d9-8ac4-08dd19bd2e9c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?BWtjFdpYKuHETxMK/WgonGLjxlmiWmjT8F4C7t9wsrdz1CPAtlyw0Odgl2Tj?=
 =?us-ascii?Q?lSWegfV9vZ1iKKx9ALnRxS/J3QYFOTpUI6K9vo+RQkM8RryqFNs8OZ38mRxO?=
 =?us-ascii?Q?QLqpWJeT/906gkkBrKizn2twoM/12q5/CDfs5ZhgFurOFr4cxK4iGvl3Nr6h?=
 =?us-ascii?Q?afDCUvq35Fsfo8CL/g5w+8pt0Tz6yJTokFP31A2KIxylo5d/WvBtqEaKXdD4?=
 =?us-ascii?Q?Vrz7+EqIvhtr5Ta3qoH6ki4mL4gmqxZWTbPOce1Gxzl5D54aMu95dZuy0nx/?=
 =?us-ascii?Q?wLuYjg9pH4AXPt46cwbxsNayYxUgJS4v06BSGxRrguDCYQIBtK6dQfj7MZo5?=
 =?us-ascii?Q?BuYyWRxwqEm2Fb6CaZaoYVjrGlWVOjBWkLsyIlKVtUDVAPnAD3Z+O7OAjGXV?=
 =?us-ascii?Q?YmYV39eXXyZcMaQ5KeOqru76r4W9kjSukE6m+xV0o6D1SaSt0QJP1xwrP1Xb?=
 =?us-ascii?Q?0dqmiKgfX96cRDFL2+cXFqkK1fRyc6pIcFPOXQyJcfKUhxKM+I95K5AVtEdT?=
 =?us-ascii?Q?3gp5RjIjBvlP+Lei3kF1DlPFfbiQxNnRwgD6Zg+uoqnQWgM0mBiUzaeuyVgP?=
 =?us-ascii?Q?JWmzc3N+UqHSGe1sU49I/VwTQuOAWTTvEKi3OYrsS+V4bd8GMhVJVTLCiH6+?=
 =?us-ascii?Q?w3NkoZeoQIs7Heg9ptz0rw6MZyTt3C1N19dcCLIea7hgS6b444YpOtWgtgkL?=
 =?us-ascii?Q?JiCjq+pYT/FPTL5QK7T8EFdxsXar4Jnoh13ayQAAtJ/+Vo8YQEjg0fsBCPUv?=
 =?us-ascii?Q?Cx2ppeD2hhx/ja71HtqaupHEfh2dKjVcvXoHgEKBrOvNIvCGzFnx5me11620?=
 =?us-ascii?Q?P5X3FPdMMpEIu8QKA8gJVdwv9BQXdSTjfrkG3T4crTQvmcwX9PS/zQgs6p2K?=
 =?us-ascii?Q?k9m8QpGqwHIathfFo4byollbKnChSntmwesz8JywJ8F5a34LAKQJ2zJLZJMF?=
 =?us-ascii?Q?5+5RQc55GkzZfwyRZJmK9fn7+0ZSbRqXemzURYgajro2GzN8AEW0ER3LN/Rl?=
 =?us-ascii?Q?BWeIx7netbEZA1v20AVptUvglTWWP+iZA3LffzVUYmOGiV7UzcwsO6T98RYX?=
 =?us-ascii?Q?ODKJjSFk4pgiAoYd+WZeL1dnZ7YRKUzsCr6HtI2Ll0RUKVa48NN6OpntA+LC?=
 =?us-ascii?Q?JeQ+OwN5Bb8Ma/hF5vdw2mKMDGWU79vgbM4cjtRocrEBO2f5Rigu0ZSGNjkI?=
 =?us-ascii?Q?EXB+vJGjFP8ZqsW4soSpsOoog43Hktvjrj83S73tLFEoFXC1lwhM6jb8ud8C?=
 =?us-ascii?Q?X2P6dgejL3h60dMB6Anq9ZjbkQsaVwWqeBOBLE9IBnj8N1UHowLZ1/2gRxir?=
 =?us-ascii?Q?OkLyRQZ8PT2uN5L2LqaSSUvPSZipACbW9RKvvF7BTf89sVg/2Q90ujwsZhHk?=
 =?us-ascii?Q?Ipj5xk+sFvLPmqmY19+uD11LExBteEAMUIipbpOcd+FWTVXC7A=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?99swOfpZ9w+HAIrhft5at+GO6mcJXLDECFfGW2xyCr5YEs10AxwV/c2+Oo7q?=
 =?us-ascii?Q?wN6G7EhIJNgLV9Pg0b1uDduZWd4ILmP3zQE/M86j0kG2Cj3O3GWcARvwxWs9?=
 =?us-ascii?Q?tAhbI3p11LRWwF9ioWDegvBPqlJKBszdGXfaOAwwglMCJkEINsWBRELx2Viw?=
 =?us-ascii?Q?CmCtS6Pld6AdUAuDJdP1v4DdiJmv3ZWZmqhDwFOds6gdZrJB47khNd3ng6cC?=
 =?us-ascii?Q?Zp+BuN8qKavSfo3BNtn5/Ie1ml0kKl/uSNwdCspAqI26jITAJ3F9Lyp8WLGd?=
 =?us-ascii?Q?uwKno0GbGhUSmfGD0hkcKL6GWbeWym5aMO9J9tkHDg2mhNHDX+nz1kvmIHHM?=
 =?us-ascii?Q?A0aJbuc4cf7YCpF6zWosPHlGBg02XHaU1eobJT1mzipFOLHPKyGD6oRClZGh?=
 =?us-ascii?Q?IIma55iI0SQWajbYBD5cGxnFzuQv3JbPo/82dllN35t80cPdVARz6smULmEM?=
 =?us-ascii?Q?0uuRurGSYeIRL+bY7Lo1pBiejq4p2a1uEmge1YcZ+HdpiV4a6OeVjDyYHMed?=
 =?us-ascii?Q?nesYG2V24NuF5FKNPdjBilcivPQsNN0TjA6sBJZhFNOeU6RNz7t7K60OSp+P?=
 =?us-ascii?Q?DhbAGsKaNtjANTU0V2NP/nJ0UU1l26IerhWTxRjDkgXKvUNyFVuGCBbYxsHV?=
 =?us-ascii?Q?V6lQw1ov5RtIeByS0jJFBcfNaJ+vUkx4EJaNjSktRFKGjMBuGt8LRbVa5SYB?=
 =?us-ascii?Q?ilH4RPqhjZ0eDaScyG1EDq5QrUPIM5PCxx9gSu92Z6k18sCdQ0gPN8kzOmWZ?=
 =?us-ascii?Q?/F2fROCANyv/mDOafxgSnBGbUvKjUYMRKJ2vyyOsRT5/qMJl9Nq2/bVJr+gj?=
 =?us-ascii?Q?6fD1zGZyh3NZjOrnw1GP68Xmg0CD2+EgXUXqQ6Llmfp9Go//rPXpvh5rxYmE?=
 =?us-ascii?Q?oQNNda0Heh0u72Mc32sw7Ha8XNIQfwFesStU2LUKBz62pzKzEduVbLl3JSx/?=
 =?us-ascii?Q?COlsFL7MezEKOcV4YlRVU9Xr+0FSMMDGjKEHlzWwIF3a0CRayWKAIVc0yJw7?=
 =?us-ascii?Q?7y1Hdp8MXod4DNzhNe9hr6jVT9q4oGba7wdiTpRIAl8CtKsyTo98VaW6Uv2T?=
 =?us-ascii?Q?3MTbWJzT22Uygiyx1npETOpGFwf/D5hOminOIorNThsNDUtdUzL4eoWoyZKa?=
 =?us-ascii?Q?+PvTcuRWzgLHqDLSrFRQdWDA64C7+9W5/9qWoasDxZouaK8ag3iby9C/RPOX?=
 =?us-ascii?Q?N7+qg/x17kGGfn8V3lFvSrQJ3xd96saSKXyXX3YSvl6wbXuJdnlUkC+Y7IQS?=
 =?us-ascii?Q?2KPoZKNZA7OOe5lc25vmyyjJF5VRdyqOQVBo5imMdltdlGU8iw9tvSIDKStP?=
 =?us-ascii?Q?LXSB0XJXFPFKRdxKUdcKBQHkmmmlhlOikj2oqku+ekvyZYqS1SdgrQmMEIab?=
 =?us-ascii?Q?k/0fx3byJRv4xLi1zBL7vmGB2s/JDYtLC5z6Asd8Pu6tcrn5qwbdELNBLQHX?=
 =?us-ascii?Q?zJbiXGUISP/V0D/TwBxMJq/iScQ+mYsrsHnPCmI7Wl3LXUgmc2WjNTNV+WEC?=
 =?us-ascii?Q?KJGoLE3LKuqRPI3CB49jU/UlKdQt1qrcqZNGWkIMgDkw2whYSbAfSu37skm5?=
 =?us-ascii?Q?RNMuWAvvUTQpZq7uA73V5KTo/DJOBnPYNl7+QUck?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: f18d5e7f-4f4e-41d9-8ac4-08dd19bd2e9c
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Dec 2024 08:24:07.7759
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JNQnfrmUGBF+brua8qF6mU/5ec91oivkqHiuc2YHODGVLBLgZkhpNTeCqPVnZ9llY5651Ls9icCVgqJ+D7piWg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB6436
X-OriginatorOrg: intel.com

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Wednesday, December 4, 2024 8:29 PM
>=20
> driver should implement both set_dev_pasid and remove_dev_pasid op,
> otherwise
> it is a problem how to detach pasid. In reality, it is impossible that an
> iommu driver implements set_dev_pasid() but no remove_dev_pasid() op.
> However,
> it is better to check it.
>=20
> Move the group check to be the first as dev_iommu_ops() may fail when
> there
> is no valid group. Also take the chance to remove the dev_has_iommu()
> check
> as it is duplicated to the group check.
>=20
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

