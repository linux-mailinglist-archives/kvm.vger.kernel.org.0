Return-Path: <kvm+bounces-8079-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6841A84AF0D
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 08:35:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2048C281B73
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 07:35:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CFCD9128833;
	Tue,  6 Feb 2024 07:35:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WWCJKy//"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 707AB7EEE0
	for <kvm@vger.kernel.org>; Tue,  6 Feb 2024 07:35:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707204936; cv=fail; b=ox140l+bB5GAHiSyntBLVZNfU4EKntHMtrSTdUP8HSK2x5pLImpzdh+mRXdcvb1ehOJLxrK174CxlaZAsOXOdJdfW0FBNaLbwj4AwLlAQcyj8+6mQFfVw3+gW/SSUvfFEgaaxJHMKKiPeP/G5cvWlDfj+TyNzo/7kR8ztVqCbS4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707204936; c=relaxed/simple;
	bh=E/lj+STgycbQ6CGxEl5N6+7AnQBsjKBWOzLfwUnNJN8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=npU0WBvs28pl84bCjkTuA6qBm92ul6Q0Iy1mD6ZSletnm383Km0g//BHc4ViQZXHxYYYPCd0Pnu2np+nqsXWP18J98BN95pQspmhH2cyngDirjA79ecjCFVEBXFLhb4sX2YtZOij0AnNYwK4GvGP80cLeGnwBh7JxLzBnfjOyLA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WWCJKy//; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1707204934; x=1738740934;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=E/lj+STgycbQ6CGxEl5N6+7AnQBsjKBWOzLfwUnNJN8=;
  b=WWCJKy//giED9OnNHu5pzYizUC1V9mSvrA4wReYtj/420GxBiZUI6C3o
   CG0SjWx4gBcoH8TmdTmK6SOrhevNPOChaeIwpAVKlzGB+z0pxSZCz2bHt
   pP6TTsqsdxqrJ8b/k3vE8NiDI3ThuDcaoT40SwNGdslQGDZ7/rK8lJiTU
   J5Pzyhbh2NULgCBFkY26n1I6fKNX+vC+Khtkb7FkqOQv4HTo4DCk0zD6N
   EujAoLsYTJosyvVuS69qwE08v3KRlUwWp+Yr/NULJutO0pMw/qmZ4HqgG
   +4gBbDbimVwf+6lJ2B9T1/hXSss4n6mhFYuqy+rmKiwjiGLVEvIERQ7fC
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10975"; a="18208056"
X-IronPort-AV: E=Sophos;i="6.05,246,1701158400"; 
   d="scan'208";a="18208056"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2024 23:35:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,246,1701158400"; 
   d="scan'208";a="1262381"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa006.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 05 Feb 2024 23:35:33 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 5 Feb 2024 23:35:32 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 5 Feb 2024 23:35:32 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 5 Feb 2024 23:35:32 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.100)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 5 Feb 2024 23:35:32 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zi7XdIoUGXzKDAuFBviRhBjIAVwlg1eiZhcGVHYC5PQuTajVTDWn/Bx61QciGebpRzx456AsJ4jmxdhV8AArVLDPM1fYHmEeyYVYeixUQzadVKqmCIR/uwnA9HY2HPFphBFFWj3SEiqPj1GXTR5BtQ2BOUWeejJVt+3k89Zl/Zbtl4A+BgeYevWxYd4HF4fC2ygQtxRm4gDUH3/nOXWI6O6SGuW97MqxYnZskEE5cvPsEye3ykGkBX9Er049SXrvmVSVxSummhXC9yLDgMHKX5FOtdJ5gW1SD794wYO0NLHNroneA4PSCKzkLfue3e2rL+tCw/nU7RHwMbxYU6yiQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E/lj+STgycbQ6CGxEl5N6+7AnQBsjKBWOzLfwUnNJN8=;
 b=MGn58XVu83efzuuJu9sRK5HaGuhhRxWffOTd1f5tFzI43sYivTIuDLMunBpoBPAE1t7D6fU9guVMLs9Ngl4/m6AJ1PGo5HoIPxM2xsmb+vbGMy0GvlGU2K4xHiXMGWk+h8NYGXCtsSQBzdi17VjxcpmDuGD4mzUIW3y2YeGSVWoLxIwLhKYKI3Aw66HAqz8pNsSL1PlAqBRvg/TQaNmpvdPt2NlPDJczsq3gd0lWECN6kfr+I6/NN4OLTUoZH4QyG4Usl07bZcyB6Dv13PWQKRxYinvGdldDM+rY/5PTCfIUia2+QTe1gq2zaP9D2PKfP4hQoUH8Pz1x3sQSd0QlLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by IA0PR11MB8334.namprd11.prod.outlook.com (2603:10b6:208:483::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7249.36; Tue, 6 Feb
 2024 07:35:30 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::a8e9:c80f:9484:f7cb]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::a8e9:c80f:9484:f7cb%3]) with mapi id 15.20.7249.035; Tue, 6 Feb 2024
 07:35:30 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Yishai Hadas <yishaih@nvidia.com>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, "jgg@nvidia.com" <jgg@nvidia.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "joao.m.martins@oracle.com"
	<joao.m.martins@oracle.com>, "leonro@nvidia.com" <leonro@nvidia.com>,
	"maorg@nvidia.com" <maorg@nvidia.com>
Subject: RE: [PATCH V1 vfio 0/5] Improve mlx5 driver to better handle some
 error cases
Thread-Topic: [PATCH V1 vfio 0/5] Improve mlx5 driver to better handle some
 error cases
Thread-Index: AQHaWDG3TgHBDyu6tUyZ6NxMX59wurD87Tug
Date: Tue, 6 Feb 2024 07:35:30 +0000
Message-ID: <BN9PR11MB527688453C0D5D4789ADDF968C462@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240205124828.232701-1-yishaih@nvidia.com>
In-Reply-To: <20240205124828.232701-1-yishaih@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|IA0PR11MB8334:EE_
x-ms-office365-filtering-correlation-id: 74bc35db-3f4c-46a7-5f90-08dc26e631fd
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JP89AwNaWx2EzrJX72S5jICHhGtdDKyg0fmaW6AiwE54l9NsikZW61/ZMBWKjK/ShfER/CT7j5L6ZG/6RJyO8MtL2Y1HXZ2V/PXaH3FnD3V+ExFr1BXInk0qHtPsuUZODF6r6PvhepZSQhqkTuTrsQX923icqlaSD0yZnFfrSrQQn0/HcLSx5CkVoBmcRjnN1p7f7kywG0hRjm6+x+UQiR2fU0aapT+UC+fmEQ02n+vVlYfbnN7ONUWgRODINvRx9DG+aaw2dI3f6ne3/Avs5CxpnzA4FSGthZJWyUTmUjBpXrVQVe8CsIBkglB/JvbaWzlPd7svjTEXbuHmr0y6lX9cCeJLDaJilpzpKtsT+TEw+Gz6pEkGYIXWeyrOakif9v9UNfS1j3+nCcft9qmkNwOn64zpLkqU2mYw3Bxioin79WcLqEFy7j4qQ/bw2VO2iB0enOXeXzyWU2DYH34KUvL6rR1TXWghz7QNZf86ZPMk9sHMhGC3bPBzPepkXRqPGJK+3Q370xtiYeoMSoN221gbXbUDYALpxYuNUlR8GdaYN0A8NxrKKkYAutVmbNOjjJYVQsLq/MlXM4N9rHU6+zNSnDAAOHiAOaq9Ld8aRXY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(396003)(376002)(136003)(346002)(366004)(230922051799003)(451199024)(1800799012)(64100799003)(186009)(41300700001)(38070700009)(64756008)(66446008)(110136005)(66556008)(54906003)(66476007)(66946007)(76116006)(316002)(5660300002)(2906002)(4326008)(52536014)(8676002)(8936002)(83380400001)(82960400001)(38100700002)(122000001)(55016003)(33656002)(6506007)(7696005)(71200400001)(9686003)(478600001)(966005)(26005)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ZvM0J3CyG4VvfYsvYW5TuQ8zdXeo/vzWE0jjd6Be931lM3RtCrSTJiGCGD48?=
 =?us-ascii?Q?I5UvzY+kMA1AbyREP4Je+iGntvsz0foCfDPvjfRbSpK/GwHhBgJGCh0YCIdU?=
 =?us-ascii?Q?v3e2PBwKOz0+hD9n9YYs8xrecy0Lzs6x8RT+ED7MRGGE+uP9Lq6+N59DH/Ui?=
 =?us-ascii?Q?lgMeG55+EZjxTkt1pTG4v4ssVsp2Y8NVt4PRxgS/rtqA2BCFcGJt1Iv8yhJe?=
 =?us-ascii?Q?Mk3oEPdEEYCZHq6UcQRMcac9zymS/+7FQkrO1boYV0MUbaTmUdymUm5g3BWG?=
 =?us-ascii?Q?/MpH2hDWTZT0IMLCLyZ78UIm1v98QKOFss+x/S7iONtJozpzg6xl/e7GlTXA?=
 =?us-ascii?Q?Mt12KePGSxRtjLoKrrNykeNPugxPoUAy+GJ9lAjjDjWJt4eZuzFBTdVrx0QD?=
 =?us-ascii?Q?kvzXS2C2u8vzYKKU4p7QzvzznJwGvfrdqRZ7056Z+o741B0q7xUTnHvU1SjX?=
 =?us-ascii?Q?6Qh4bhB4sPcVMp9dF/lUn67CBPLu20TxoPmwJkU1yv2VYU6Lt5qAjZT9oQz2?=
 =?us-ascii?Q?HCbMuMCVW6Y6DceG5jzYjVvB1PRmPfADbP68Nu0YoGhQUvbqzp043Pjlm5tX?=
 =?us-ascii?Q?CKMJCziYY7GD7p09RNIwBLNsXCIsKRFjRNzZvg8sHFe0/UzrOetqcfuWR2Px?=
 =?us-ascii?Q?PUnd1JeOgyMTXtiO04H1lYuUWDltCMMMRSBgTo8sFxIYgbY+jevfqDkXtICT?=
 =?us-ascii?Q?+vroWNKR0ErY79TcUaxgif49DIk8sjNceR6y9FVohWw62451gop7AKNMA7KJ?=
 =?us-ascii?Q?Htd9+N7DRymkDOAhaxhfkYkOWMjmpWIZHOn4hVU3ZUAFFAuoGm8ectVWRZ/W?=
 =?us-ascii?Q?w6WbtnCHrC9JXS3JIG1qqwL/5tFGmitSbvGePWMTdBumpTJ9S5VLQWUKCEoD?=
 =?us-ascii?Q?8NwljLu/aA0DtF+quNvSsix5t3//UVF09VXVtrRoKwRHr1NGyTXOuw3/tpAg?=
 =?us-ascii?Q?qAuaRTonQfn6A+xLBf/5HcQS62/0oVfmuUTi95mG49586uWhn0kQz4fGb9FA?=
 =?us-ascii?Q?F0l1gwl1FsyNHOwkGqVc9XtO2E2gfMJBFgbnpmgpsrH4VC4RSTEGTwSyysfv?=
 =?us-ascii?Q?72lcwMElorwJo9ibJboftecaiU8IOVl5nFj0SAS2j2K2VzHxtZbVa3LzEc81?=
 =?us-ascii?Q?pzP4vSM4PZrsuSajVqghGXhySg0nycaJpoJosweOliTcW+IIg3PasqQ9hMB2?=
 =?us-ascii?Q?gasQThsm9zHLEi2oXciDcm55at8Zd2OqE5XY1mfNVTSs0bbO5iEgHS4MhcQP?=
 =?us-ascii?Q?v0Kn1M2aXv9I0RspS0hd6glFVqfKffrfvMkNIxJPNEEwunHvcFrDWXN9U3wt?=
 =?us-ascii?Q?rJaefA6TSu9I7Ad5d+q8bTEy9MI/LxW3S+h26q7dkw8SbtRVlSlZfSIHzjmO?=
 =?us-ascii?Q?GWCbOk4gM11D1V3qOqIHPGdebQEMaj7pcIZ2Jh9ccsW8BSXB0fLympK8xI3k?=
 =?us-ascii?Q?b6OvUgfA52UBOvLOfzZcARMnKCbKVfW+Rc0VvTHhpPKRz6D/2GW8NZ4YShYQ?=
 =?us-ascii?Q?Sc+Nga7K9K/HrmlX8DWd1U9I68fIh/apsv7s4EPGQjLGxhjK0aOVyzUkTKPz?=
 =?us-ascii?Q?3enuiBgoD2QHiadW0fumPypSJL9Nh5csvoh1g9AP?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 74bc35db-3f4c-46a7-5f90-08dc26e631fd
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Feb 2024 07:35:30.2510
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: j1+mqhZZ89rEU/P6WEI1TV/eMWM9cIUHwrnYS7a9bVAnrKQ+IcLknX41iwr3V0L0kKRAqazsPPmsX911CR6mtQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB8334
X-OriginatorOrg: intel.com

> From: Yishai Hadas <yishaih@nvidia.com>
> Sent: Monday, February 5, 2024 8:48 PM
>=20
> This series improves the mlx5 driver to better handle some error cases
> as of below.
>=20
> The first two patches let the driver recognize whether the firmware
> moved the tracker object to an error state. In that case, the driver
> will skip/block any usage of that object.
>=20
> The next two patches (#3, #4), improve the driver to better include the
> proper firmware syndrome in dmesg upon a failure in some firmware
> commands.
>=20
> The last patch follows the device specification to let the firmware know
> upon leaving PRE_COPY back to RUNNING. (e.g. error in the target,
> migration cancellation, etc.).
>=20
> This will let the firmware clean its internal resources that were turned
> on upon PRE_COPY.
>=20
> Note:
> As the first patch should go to net/mlx5, we may need to send it as a
> pull request format to vfio before acceptance of the series, to avoid
> conflicts.
>=20
> Changes from V0: https://lore.kernel.org/kvm/20240130170227.153464-1-
> yishaih@nvidia.com/
> Patch #2:
> - Rename to use 'object changed' in some places to make it clearer.
> - Enhance the commit log to better clarify the usage/use case.
>=20
> The above was suggested by Tian, Kevin <kevin.tian@intel.com>.
>=20

this series looks good to me except a small remark on patch2:

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

