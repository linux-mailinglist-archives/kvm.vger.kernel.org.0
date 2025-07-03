Return-Path: <kvm+bounces-51373-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C6E24AF6A81
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 08:41:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 67D503AF5DA
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 06:40:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C844E291C22;
	Thu,  3 Jul 2025 06:41:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="d0MVdABY"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C7981C84D3
	for <kvm@vger.kernel.org>; Thu,  3 Jul 2025 06:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751524863; cv=fail; b=GJWI2N9U82atZW45lNMtJhCIcDEPU68w0Cci03+oqB1LHVhGbo9Fi0KPllDnYv6ye+Qu2wKm7ki/IQJLvTKmgNW+9IwaBs1X+pol0RZ084b3/pv//GABmKrBBfUeOU/jN0OPqwNAVxX6zTUu6eyJawYxOk4qBomMYx2cK7swklY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751524863; c=relaxed/simple;
	bh=Z8z7B17GwLBbLYxKttV96sC2CTa7RkHSewL/rG0RaaE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ikSmknagvwWfYRw1y+gC0XLnUlZTz/opT5Vl5UAPJ2FHCNiIOCOKx9etnORjEunnUNx/jNzBQesB5L51ymMkQQrXegj5KoGym9bv8mAy1Tg5Otg4/Yx1bjt8ZceOs32iHL30L8QpvP50uDQMlNg0/GIi9+u9jPnAHWTQHuCjsYE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=d0MVdABY; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751524862; x=1783060862;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Z8z7B17GwLBbLYxKttV96sC2CTa7RkHSewL/rG0RaaE=;
  b=d0MVdABYKFzJzRZVq572eBmNSHFE0AZtqY2DLu8TK5NJE6triz8s3cub
   3NEMfWOZxfvG9gZaN0Ec2GY2JhCZkl3wkN9I8OKbb1hLtOG48uj5b8TbQ
   kOGywyZ7jYT3E1Nbb6LaDvF1Tt4Yhn/StjhQzzEj5J0S6QXb7zhP7sO2S
   DFJtzX65OxxhbelbtQMwzdyYKgipK9rmz1EZN0FYeyObg31qopgpvPvyI
   u3b+/tQp0feuqL3LxdaCmx1RJCvU0IV/6hqp/QtvXYjYZuY4riXnzt9zL
   QjHyULSw/5Bs2fxr7DniOquUQXX8uHBXjIAC8E3yEk9Vc9lYv3GQjdP/U
   w==;
X-CSE-ConnectionGUID: KkabqkEUS5e9OrhOxZdixg==
X-CSE-MsgGUID: 2IGqS2aUQXyHccsBFvfzBg==
X-IronPort-AV: E=McAfee;i="6800,10657,11482"; a="53953984"
X-IronPort-AV: E=Sophos;i="6.16,283,1744095600"; 
   d="scan'208";a="53953984"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2025 23:41:01 -0700
X-CSE-ConnectionGUID: ZL5PS58tRtCSRtUu1mk9sQ==
X-CSE-MsgGUID: SC8yhW5UQAe8eLRGFp0rDQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,283,1744095600"; 
   d="scan'208";a="191454572"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2025 23:40:56 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 2 Jul 2025 23:40:52 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 2 Jul 2025 23:40:52 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (40.107.92.71) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 2 Jul 2025 23:40:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=C/gvjdG0ZESf87btARoE8yoxQPm+IKuSKvkeYux0qw4MubbBacPTLdz0gME20FjIs7weBPfRFJSU4hVV9UQopk08fXFHOp+mRGhDw3YPv5zrDBbSJmcC4l53DxPMxfhoMt0O5GuEE3T4Uxhf2wOrMGiMZPOlFxTqqJn5OK4OyahWW5zxMpimkVqBKnGtrlVcGVOXxHmaMsYuU4VfdXkocKRswmuVKTJ2ZeT4I+hucsAYF1ZG1y3U98l1p2wNK6POwEA4qWRI/XroUNV7W+EE+JjNUGnfKCdXEkthEFNJNH3xE0HTk9A8T/kFUN5JfvPwW11YmfWcg+aHO8WAJ6mTOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TGh0MwjSmTfkh9Be4EotJf4rZ7iA0WRcKGpkB/Xs+fo=;
 b=E1v0a7jy2znxl/Mmd8g9FSOa/hBgtCmWCf+YqlE+YMmNtc9znVT+N2KXmWmH9wmcVu04WHtBymFSIRsyz7BiL5ZM8vbyeNbFvE6Qv2ylYLzPPPBM1EAxI5a5KCeV4FUdi3llldr3vl61TVnW0QNcoJ9Bp3O4l+qywiVVAy+brv44NV/dwtWYFPO988+0m3U6hXvpSvkRikBw9QfbuaggeX+jVJXKskYLnrhdjfLkrauH912ZF6tbsKE8nyf/rCriBOniwn90n2eDtUWJeeiJJi05hA4jwFSg9h3fK/3sXoafehBaWgCGjQZ5swrGyBFTNerK2Pupd+bs2vB2U0wSfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by LV8PR11MB8746.namprd11.prod.outlook.com (2603:10b6:408:202::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.37; Thu, 3 Jul
 2025 06:40:49 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%4]) with mapi id 15.20.8880.029; Thu, 3 Jul 2025
 06:40:48 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>, Ankit Agrawal <ankita@nvidia.com>, Brett
 Creeley <brett.creeley@amd.com>, "Cabiddu, Giovanni"
	<giovanni.cabiddu@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	Longfang Liu <liulongfang@huawei.com>, qat-linux <qat-linux@intel.com>,
	"virtualization@lists.linux.dev" <virtualization@lists.linux.dev>, "Zeng,
 Xin" <xin.zeng@intel.com>, Yishai Hadas <yishaih@nvidia.com>
CC: Alex Williamson <alex.williamson@redhat.com>, Matthew Rosato
	<mjrosato@linux.ibm.com>, Nicolin Chen <nicolinc@nvidia.com>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>, Shameer Kolothum
	<shameerali.kolothum.thodi@huawei.com>, "Xu, Terrence"
	<terrence.xu@intel.com>, "Jiang, Yanting" <yanting.jiang@intel.com>, "Liu, Yi
 L" <yi.l.liu@intel.com>, "Duan, Zhenzhong" <zhenzhong.duan@intel.com>
Subject: RE: [PATCH] vfio/pci: Do vf_token checks for VFIO_DEVICE_BIND_IOMMUFD
Thread-Topic: [PATCH] vfio/pci: Do vf_token checks for
 VFIO_DEVICE_BIND_IOMMUFD
Thread-Index: AQHb5Ta1f4N3tNOt70+6wANikunSFrQf/pyA
Date: Thu, 3 Jul 2025 06:40:48 +0000
Message-ID: <BN9PR11MB5276CD6181F932C70CBC800E8C43A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v1-8639f9aed215+853-vfio_token_jgg@nvidia.com>
In-Reply-To: <0-v1-8639f9aed215+853-vfio_token_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|LV8PR11MB8746:EE_
x-ms-office365-filtering-correlation-id: f9abce31-daea-49b2-f682-08ddb9fc8c10
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014|921020|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?CZ16Ru0+rRjsvrGM56yd5WUsnTm4zVcMQcPlSjXq2a7V2a3LRrbaYmEeiYLj?=
 =?us-ascii?Q?mYRxkWNacwCYMhLIVcsRFN+4l467rq9Mthboyl2bh2dCJ5WjV2ZHvq6eeGgQ?=
 =?us-ascii?Q?KqStArvW8zQx6rYS9yk1ymMyvWeA3GZGfFgY+AC9Eu0UN2M3PfYwqBE0Xz/t?=
 =?us-ascii?Q?hyeOaF4bAf0mrbHIPlIsWKU6A9MIpXg4iZNRiXPtT/+qure3EU+6H8qK7iSk?=
 =?us-ascii?Q?jCun0iDhOTEbxibxHquz07KrLOShuwPd0zpKpn1lmE484omFVtO9RgPqdFv+?=
 =?us-ascii?Q?rzJt5fvqVhaOcy/+QFyxbyXqevPD9/sAraRiDXV9pmxmEWrsGKJQkI5KYHNn?=
 =?us-ascii?Q?si43J2T9FPxoRYu0OOTKGD5z/0HwAaIYWBWcoDEZzwDhiOxQNkikvEf09gXK?=
 =?us-ascii?Q?wwJ/dl8L/XoLfWej9/JFIixQZiqMKkeHKIvq+yRuGxYCItkZIc8puIhrZylv?=
 =?us-ascii?Q?7TYH2fP3pQVZNsvDdyQaRxGuhdSolm7Ti0mGBlkDnleQnI8tSk/nlec7md4M?=
 =?us-ascii?Q?1aEMLqW7IjbPBGqVj+pYN70odWiIPJaJrlpEHnvcS84B29kgoU706cDBaMWx?=
 =?us-ascii?Q?7/gswJwxgVxRSJdqKCfy8wuuDVkKtgPIxSQQFOQO/WtnvGmIJuWPS1hY1AhE?=
 =?us-ascii?Q?yKxW+rlhc8mgNIPCykQN3s+i/Un5hWjSeXao1lSUajzfa9RnDYBhhb9dcrvR?=
 =?us-ascii?Q?fo4yjzO8Z2GZz505yY+iPYLjr8VsBHh3E54/kkJMYnyus7iNV8fNwN9VkQu1?=
 =?us-ascii?Q?RrRTN6f4Lf8JkBmTJ5uKmJKXeVNIGADd2O1Jxff/1blPRvNJcdsJ3H88WWzu?=
 =?us-ascii?Q?wdc6xmR22x8aJUEzsKtyxA86gkGqwpp+v9Nma2WvpcATL9aGVsgPHkr3GojX?=
 =?us-ascii?Q?3KvPhRgOvGYN/HKugjs4ciuPe/evzwTy2yoOVINAnIOS0pwE5LCVZrj+XV5A?=
 =?us-ascii?Q?dVMLaCf/xjnAIC5MK8IgLSBQIRM8ldP5Sch7wnR+oHjIXqc/+vGp8xlWOpqT?=
 =?us-ascii?Q?ez1Rlcc3sNF3pfHd2DyyJ+67W8koxGd6euxF55qd4KGSS94Hzrug+LKky6Qr?=
 =?us-ascii?Q?pV7OfggVwFGMYj1Wz3IiU2AWl+zd4GmH24GRCpCBJR50GFuTcCHPRATIhU09?=
 =?us-ascii?Q?bbWhknIPSGApIaCHgtq9i0PBApLcUTHNq4wfN6eP86cbb9BcFHgyZOvp16ln?=
 =?us-ascii?Q?e2ZG7NGzUJFCOxUhul1aoUrOI9hVMMETYyglqWoRH8ZL48zBO+OWWbPSZa8X?=
 =?us-ascii?Q?SO2vNhao7Y9wbf3eNK3aJpyInhxh6nLJKqOz5eTVDudnK7tLfu8AQ7xpUj8R?=
 =?us-ascii?Q?UtFzawyBAETqjzWPcqjanBXnwsalndLpTtw/OYLAUpEXyvcCgaXCDPGVcoBb?=
 =?us-ascii?Q?ZNZsJU31gqzwukhJYZ88RnI6ISSRyQtyX99xI2BDd1leen6jFSvZynPCYeDK?=
 =?us-ascii?Q?SOYBijur5w92tWBbX0CYrpP7/nogFU7XIPxWyR/jFIuE6r/wlQDr0CtBzLPg?=
 =?us-ascii?Q?7rwyWOPrkJtux2U=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(921020)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?r2kMeYCC71KdI9RWlJpEt041V4xkmen3rcpZ8T+r2G/rUXDQEw/G8sRu4Fis?=
 =?us-ascii?Q?RGOsf/cyojmg6v/hPl7/O1+PuAI2DcqScl6P7KvrhLvAL0Q86KTR3O1cie9p?=
 =?us-ascii?Q?7OCqWvQhLGVXpcgukRBIa1v2w+O/aa0LTDadrO011bVzuRDFjfrYCQiUP/k7?=
 =?us-ascii?Q?d4Somyt5nOHm7aicMOuLlcRGGLz2s4bnXISd2B0gNBzGhLaYkj3vLDF6NdWG?=
 =?us-ascii?Q?3juBJaeOjJJYnhBHgSJeF4oVw7Q1/GDYCFV0fOjYqTyrTb1O2zxvo8WOa0Hg?=
 =?us-ascii?Q?CcLiGXEK+pWdhCdBCWdT359bXtI6W7NpiX3swO2m1fqEJVuVjtyHx0Nbdhbk?=
 =?us-ascii?Q?sq2Hrr62lx3VPmDFGA/NC5KV/5WeAc8wNOeN5p379wO5s7+4cpIWfAIMG3/Q?=
 =?us-ascii?Q?gs47evvoPGZRj8doeQT4Lk3s2RsXFmnR8m2+pyi3GZq1XauMuAOWOJ3VJMs9?=
 =?us-ascii?Q?WQ5pPVG4YPEAJhuoiVPodJCawBdHOE2vKkC16qxHr8sHkGZoGyr7j0HRghdv?=
 =?us-ascii?Q?Zwkd/qgvoxFPo6NrLKZJ1Co4eMa3RTPL77ZHTQCyHJ55dDWQ17Fn63bRZPIX?=
 =?us-ascii?Q?NOGG/M2/0PvSFf0JcnhVlcD2LQPg27f7JO2q0ra4M1+DwIT/oZ37GaWytlMl?=
 =?us-ascii?Q?Iyn0TDbult4APF1GgrNhzTXt/7m1UFSP24/hJi0I/in1djqBeCG4bGFLCJPC?=
 =?us-ascii?Q?HQCt0MsUbD+q6/8koQp/tonZCJU8ehNhnFziziZuMJ6j+HVpq+F5R5UZjFGh?=
 =?us-ascii?Q?Iy8XR6/oO72cgl+6cqz7WoW4kAy9K16fx0LoGxlE3c0rTUfuV2kj9eZaIdro?=
 =?us-ascii?Q?B3IlvpeFnaEeBhzv3kegaL2XQg9AsXqQ0Ye1y4VOKso1PR4BpZytPKTyfZX2?=
 =?us-ascii?Q?nol75cqUyrS+mwInDRwH76NyZOYvbAvCoqEdCwLuyPaxcQ+KGm1egBj6Q0Lu?=
 =?us-ascii?Q?GfBUvAtCdCoG46clZD0FlGZAE3PPgp66WyL0Ef9k7TT4sEdqo6sefAoNOPfv?=
 =?us-ascii?Q?GUESphpLqafJx2w/yTAbHHfw8zcb+64hwNAw2rGJLdrxwtQvBu0h13NV0mkm?=
 =?us-ascii?Q?Z74DuKSjTckiXq2nEbt/yCWkunx5Cotb28htRaOCazywNOrDO0QUywt/HW50?=
 =?us-ascii?Q?4bsnCKtrILvVsAMRoJQkVZKVG5/OSoRshAVRlB8znaysTqbtvEGY4k7KehJL?=
 =?us-ascii?Q?kk6gYNvcCJnpI2oDrhS4hIeLzc9EKaxa+TMN1AR4cpYwMsrYYMuX36fcDSXz?=
 =?us-ascii?Q?VMJUucfRBJIS0y3jPtgZGPulaXfZULtMrw/f6weLU3dBWD6p2FD0sGK3dRNW?=
 =?us-ascii?Q?mOSdP1ihTgvsDEtlSqK+D5oYn72y4hgehUmq5EqMnl2WYZ7sitijtlSTsPt8?=
 =?us-ascii?Q?W7DNwg70wKZ71lOoC2F/TMAtq+LUxXlRNBPTCTufqk77pEUn0jPoZHVXuUzp?=
 =?us-ascii?Q?+uAChc8jr9FN1F1DLQn11KrLi2EutEhfPfMcndfk+ItFwOu3cn1C/xduk03H?=
 =?us-ascii?Q?jAYdbjQZ1nQeYohI3D6FFqXDEnkZ5WpqpdG7gJuRsqUqojPMuhebkI7qwRjV?=
 =?us-ascii?Q?Vv/g44nSQIwt0T7pcF/RbadUqOcpmFoj4DtmMH02?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: f9abce31-daea-49b2-f682-08ddb9fc8c10
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jul 2025 06:40:48.8765
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: M9CrzOH4VX6QQc5dZ29m3gMtyLI4LCMGRIcZClRVYdaIhurPn6c+5MvaCU2+6ci8xSe4i5sTrCL0eJSO0/0kpQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR11MB8746
X-OriginatorOrg: intel.com

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Wednesday, June 25, 2025 2:35 AM
>=20
> This was missed during the initial implementation. The VFIO PCI encodes
> the vf_token inside the device name when opening the device from the
> group
> FD, something like:
>=20
>   "0000:04:10.0 vf_token=3Dbd8d9d2b-5a5f-4f5a-a211-f591514ba1f3"
>=20
> This is used to control access to a VF unless there is co-ordination with
> the owner of the PF.
>=20
> Since we no longer have a device name pass the token directly though
> VFIO_DEVICE_BIND_IOMMUFD with an optional field indicated by
> VFIO_DEVICE_BIND_TOKEN.

not a complete sentence?

> Only users using a PCI SRIOV VF will need to
> provide this. This is done in the usual backwards compatible way.

and PF also needs to provide it when there are in-use VFs:

vfio_pci_validate_vf_token():
         * When presented with a PF which has VFs in use, the user must als=
o
         * provide the current VF token to prove collaboration with existin=
g
         * VF users.  If VFs are not in use, the VF token provided for the =
PF
         * device will act to set the VF token.

> @@ -1583,6 +1583,7 @@ static const struct vfio_device_ops
> hisi_acc_vfio_pci_ops =3D {
>  	.mmap =3D vfio_pci_core_mmap,
>  	.request =3D vfio_pci_core_request,
>  	.match =3D vfio_pci_core_match,
> +	.match_token_uuid =3D vfio_pci_core_match_token_uuid,

this matters only when the driver supports SR-IOV. currently only
vfio-pci does.

what about adding a check of it with .sriov_configure() in
vfio_pci_core_register_device() to save changes in every driver?

