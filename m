Return-Path: <kvm+bounces-14936-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B57B8A7CEB
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 09:16:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 59AFBB2196C
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 07:16:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0EB96A8CF;
	Wed, 17 Apr 2024 07:16:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PoODbPdX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 401F76A026
	for <kvm@vger.kernel.org>; Wed, 17 Apr 2024 07:16:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713338175; cv=fail; b=LCxLeJDKGKz6wSJY8e0UTGcUqra8WtnIY4JhhvOtJO3VGNewOJNX4GDenH0wjtmAlZDmbm2EkouKejXffDz0XDdcKlHcEuipX7ii++1pe3lBpUcXNVfCxubcnGhCe/uZXFGRLx85CSllUX2Lp7b4PCbnzAZd2FHhpmdkzOHVORI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713338175; c=relaxed/simple;
	bh=ZYGIwMGVMRHMplX3xMf+TknzFwDN5NPBV+XI5zJ1tsc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=J/YSco9nya8ddwgx5J0CTGyZtDip7TgCp4yGq6xnCkC2SRf/Z8mgBt6/KOFWxblAPDe+tC+RaWaSYxkvh+yIUlLSZ+eqTpNOKT8QH3WXQnD6K5Y1LC2QDsdxZL/xCcyKofaG5sC9ZuTmXbtdk4NAOcqe+WZ13f1nLDYAXDhRIkU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PoODbPdX; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713338174; x=1744874174;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ZYGIwMGVMRHMplX3xMf+TknzFwDN5NPBV+XI5zJ1tsc=;
  b=PoODbPdXLW0pYvmHBNBqsb9ySMU36+PVwyygMO+bx8OzJENzitzWR8DI
   zKFAi2FAqcc1v34/AZ2qEN4aOXn+HRI8vfuYseC3GJX16Gbqh+1+UCRxv
   8aAUyalePCtPQhT8tbcQvg/hfYjIHf2+IGWrnyvOKkKCT7Cj8wg7iyoUE
   mo+za14QO+0YrjgkxtLWczSYoEBYm7ENmFLF1MK1hTYcsfg9KPFp7Pf0C
   J14FkhN7+yxB1CJwsr79bfClT1oGfhZRnBW/nosNoUSMXrtt1KQOQtCMq
   S2rxm0tDbFreX3V3wdNcGAiivl9FXtyavXYhFJv8Fpwm4TGOE61mpr1xn
   Q==;
X-CSE-ConnectionGUID: d2iRIIkSRCypnDx88JmW8w==
X-CSE-MsgGUID: 43EPxG8ETkqeTveRwStI9Q==
X-IronPort-AV: E=McAfee;i="6600,9927,11046"; a="20202904"
X-IronPort-AV: E=Sophos;i="6.07,208,1708416000"; 
   d="scan'208";a="20202904"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2024 00:16:14 -0700
X-CSE-ConnectionGUID: WMJeNCmuSSWKDEac0OxFvA==
X-CSE-MsgGUID: i0t7kQMTS1qbHzaOVddltg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,208,1708416000"; 
   d="scan'208";a="22615853"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa009.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 17 Apr 2024 00:16:13 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 17 Apr 2024 00:16:13 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 17 Apr 2024 00:16:12 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 17 Apr 2024 00:16:12 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.41) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 17 Apr 2024 00:16:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AtpCy9Duost8mWh9lwnQY+7IgQX/5ro6yaUQdqlnW8J86DT9EmxmG1+SM62ow97c+saDKDDLbxmZrOTKNgWGgFXWiKAOSNWfjnQKHZbOQT4NDEuLSYhh9aDlDNtB042Czp5YuK1Shrwkn6Ba4k1t1BwU0Et5tW8kOTZd9DoPMUn/vNOU9UaEROKzLP5WX54FPT5tMOr1z+xKBQRVviK0K3/pzwMl5Druex5xmT/B9cLVDGfNlfK5ThnO0iyOcfRvZAXx22XXeiXIwh52ZL6dDJ81TyvI01WpBYUNAUk9ORcaVd+8QZE7d+KVqOJTLZLVNp3NgD3TfjwtJtf+OxbDzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NVeyE01ibCMVWiXWD6VXDk9PEILFTkF6UU9zDS9fzy0=;
 b=DA3yJobB3Y08vNy/fRkppm2Y6DiMMp/+0Sz4kXeYRakt7VCeooA4jC5lbjgf3EA5PpGuLu3ebOUnGe0cBneZsENrmRsJ5ojlif4LtGFycsGoCnKoH9SdaoONfPO8sxZdPcnLcy//qeHS+EXt2FPt6EIuGwRdbcGVx4CdieeA5lKBLbbDVEajXdikFW565xrvqRF+O554TxU8+hCorDo59ql999jXNdek7WQlMTAxPD60ubAFLGdgQcpm7Ib38jp23KW0fLQa56XTr+quVS5EAcYxYajog+88AkOKBrDKJ8/WbUcBHUG9LAffT//zX0f9LmmCLZvKa8cYe5OjlBNacQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by PH0PR11MB5783.namprd11.prod.outlook.com (2603:10b6:510:128::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7452.50; Wed, 17 Apr
 2024 07:16:05 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6c9f:86e:4b8e:8234]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6c9f:86e:4b8e:8234%6]) with mapi id 15.20.7472.027; Wed, 17 Apr 2024
 07:16:05 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: "Liu, Yi L" <yi.l.liu@intel.com>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, "joro@8bytes.org" <joro@8bytes.org>,
	"robin.murphy@arm.com" <robin.murphy@arm.com>, "eric.auger@redhat.com"
	<eric.auger@redhat.com>, "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "chao.p.peng@linux.intel.com"
	<chao.p.peng@linux.intel.com>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, "baolu.lu@linux.intel.com"
	<baolu.lu@linux.intel.com>, "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
	"Pan, Jacob jun" <jacob.jun.pan@intel.com>
Subject: RE: [PATCH v2 0/4] vfio-pci support pasid attach/detach
Thread-Topic: [PATCH v2 0/4] vfio-pci support pasid attach/detach
Thread-Index: AQHajLJtgFipqDFp5kGVxfWLZ+e8jbFqmBhwgACbmQCAANtx0A==
Date: Wed, 17 Apr 2024 07:16:05 +0000
Message-ID: <BN9PR11MB5276E6975F78AE96F8DEC66D8C0F2@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240412082121.33382-1-yi.l.liu@intel.com>
 <BN9PR11MB5276318EF2CD66BEF826F59A8C082@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240416175018.GJ3637727@nvidia.com>
In-Reply-To: <20240416175018.GJ3637727@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|PH0PR11MB5783:EE_
x-ms-office365-filtering-correlation-id: 5d4493e2-7be2-4056-d2ad-08dc5eae3f18
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0Toa4+so8L88tzlUKK3kX/5yvcBj9imdnfGHmuIs5L+rVYdwocfqWtfYLGskVADzDI1bd9etp0/cRvLD/SQG88F84pGt8kZKjrI2tWzr+WQfub5xXQv/qYGEyfoi2y1nietw8PpxNJSkNOLnuR0nU7/jAMy4A3IM6+CEVNlTqTmfyQm+IMZAij1wjB98JmZS4SoemIKlOmRylnbSivDjseP0VWlWY/QAvyiItUhfKx16KK5Y07bJ4y6wwohYkK94zvvRf4K2W8SIB6otb4E4eH5m21cS0tS7dPP3gUP4GKR4bU6fHAPg2JgvodCZfeMELW1FyHueFdEqQr56sqS6LkR5fXMxPEB/BEpIgjY1DVBoYLMnJXhv9fXFz56+nhklUCvzj12DxKtLoJUSCyoE4DXgB1/Q9PJKlN390WYTuH8NmZWK1QGND79uQN7HogpbkmOV/XUqbIasduQc+WVzszwqkvWWVtMEUctzm4f/sjswU+zODx8mi8R0m0RRCC0VB6YrNDeVOa+YyyUDkHqsdYVens2h7nJhYKZE9741cNfh+wvHgviNM/LkRNf82Hy5kRo4065vRBwrL7+NbQ939gxrgoIwWoqkwFIybbhREbrSpV8gyRHDEBEXDy6i50DvyOtz5m1Bax8qC9u3xJkaqipU2LsouaP5LhyObuw2bqvVFO98Xqw1QqQmy4gnqPxOP0/aI3tQVr2BdnzV7jP3lY9A6Djcpcnva4ig3KAx/N0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007)(7416005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?rtwmCg45h+iaDKyS7sY0YihcNdAoHzrRKUZj/mkJ52otD/7vATz3Ez5LaOGV?=
 =?us-ascii?Q?ZWW7ZY7tM2+fvS7wSvTe/c+OCrhvYQ/9Pi5GnVSlxjIgw9bO+Dy9hIRjkglS?=
 =?us-ascii?Q?T5SOv2u1yXYb8Tk2GFo4dimZ74mU99Uj7D3myvFjeDtaitR+OQliY2hQxH4P?=
 =?us-ascii?Q?8HsbbZvt4wH84hrLyrhbUSBGmcl1gFETKWCskH+lJux48JI03yo/0TMjSwQl?=
 =?us-ascii?Q?ZVj5xaMri27e/U02hPIRli5+jBw3xKLplfZ3HlSquQWMvyDinHjuMBg7Kffu?=
 =?us-ascii?Q?moDcKQOCFD4/hge2a+GEDcXRhsu7DS6dn+6XwMkzfHmb5+9x/2XTlI0zEOzd?=
 =?us-ascii?Q?SzWw7tmLhlww+4jn2RpgfA5I13+ScJ4OGtd76Vwh762dZEBn+aBtj6OWjVW4?=
 =?us-ascii?Q?tYlXdccP09pGtZCqIN9l8IpMDHQG5AQUC4e7doY6MM1zgdgoUyXQN8+N41H9?=
 =?us-ascii?Q?z4hNJAwzFFi6JFRjkdaGYGXjxmoVg0RrILvsMpa42aNbcbu/dir94q6FSJ18?=
 =?us-ascii?Q?QM07NXH4AG3YG0i5yRDJKSelAU+GPFugb9nd7SwGQV7tgpO0ymSTl+ZicwpI?=
 =?us-ascii?Q?LUZU4wz0cD85qVyEVs43A05ah+AknsBYZw8LAseZ6QKMumeQ84cfLlV1cFCB?=
 =?us-ascii?Q?t6V/FK+Pbfuo2z8s+RGyCXXgm+0/O3bFeXR/DuD5I2f+3DoqAobe67m6e1zw?=
 =?us-ascii?Q?ZHYXI5JTn+Lv9ZXHm9APpmKkvubXqG1AQUcQ/cveQjEff3RK1Sph9GnSKpln?=
 =?us-ascii?Q?5utIOQVHwpJ2BaKlS1y5avij/a51g06XXMySwDcar6JBvHkcbu5X5XeWYgVy?=
 =?us-ascii?Q?9K1K1kqlIY0Qz1eh6Q3MGfWl0nj8EOSzV+oucQZgedLvEcjCxrQrRWs448S/?=
 =?us-ascii?Q?QcO4Iuc0V1trgwucz9wEHoEnEE4HnBHlmJjWGqkCeD7URpilIeRZBlxsjXCQ?=
 =?us-ascii?Q?kXsZy2F3vqSi4WM68A+anxg3a4q7Xc26LN84d6Pz2L3F/9isxK06mp6iUlgS?=
 =?us-ascii?Q?BUTXbMkiW20Anh/kweAgsN8PS4KAuUKZhizRPDo2hxWqr3A6y0gZXVQ1CniY?=
 =?us-ascii?Q?tTXHGDU7AJ6XRunTzChKhUDalkVquOz0FtlGnPBh5wHznIKvJiO1/+RHGPWy?=
 =?us-ascii?Q?4VVckh2OUCtTMaFT8iVAGaeulhOa3zrfxCyEwZnICBXfop4X2mYFAAVDHYbE?=
 =?us-ascii?Q?wyl83kSP8fyBlpiFVW4jhNrIUhqWRIZLIlldKV8eu9HYmpxZLbSp3E1uozRb?=
 =?us-ascii?Q?cQD95hp3AxYCSP1at6kMtOaNWj8U4s944NH22QU1hDzSwKGT0JCHh37IN/G0?=
 =?us-ascii?Q?h4iJOFr+HFFhnVINEQUWE4B3NKUT3hlJpkcSYnJXFqTtexUVGkrltWCphF4V?=
 =?us-ascii?Q?Fdkpide2EridGvPrDWxR9v/uBbSdk3f16L2u1Wwo2NW+AUyUT+lVj+7CO3HY?=
 =?us-ascii?Q?WTZnX4V+9yD5vAIpczDOpN74QxHC458+GZDZ1AQzMhdsxIaJOdRqXR2tmiMC?=
 =?us-ascii?Q?Y6K+JpGMrJ1my1KUfIoT0yM+xXlk4PFQA2mIYkhs5B/Dt/m0nSiHJs9F0qen?=
 =?us-ascii?Q?V97LjWtSs5MHmwley/6vThCYufAV3SsXyABuC/NQ?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d4493e2-7be2-4056-d2ad-08dc5eae3f18
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Apr 2024 07:16:05.5116
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TgRO9eKrhMVu40fVsd40AfncZ1xMrnCRnXYsuzf6saKlU+4N3rQmJMn9uV/rD+RkC2VaigIosq+xZb3SbCB8fg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5783
X-OriginatorOrg: intel.com

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Wednesday, April 17, 2024 1:50 AM
>=20
> On Tue, Apr 16, 2024 at 08:38:50AM +0000, Tian, Kevin wrote:
> > > From: Liu, Yi L <yi.l.liu@intel.com>
> > > Sent: Friday, April 12, 2024 4:21 PM
> > >
> > > A userspace VMM is supposed to get the details of the device's PASID
> > > capability
> > > and assemble a virtual PASID capability in a proper offset in the vir=
tual
> PCI
> > > configuration space. While it is still an open on how to get the avai=
lable
> > > offsets. Devices may have hidden bits that are not in the PCI cap cha=
in.
> For
> > > now, there are two options to get the available offsets.[2]
> > >
> > > - Report the available offsets via ioctl. This requires device-specif=
ic logic
> > >   to provide available offsets. e.g., vfio-pci variant driver. Or may=
 the
> device
> > >   provide the available offset by DVSEC.
> > > - Store the available offsets in a static table in userspace VMM. VMM=
 gets
> the
> > >   empty offsets from this table.
> > >
> >
> > I'm not a fan of requesting a variant driver for every PASID-capable
> > VF just for the purpose of reporting a free range in the PCI config spa=
ce.
> >
> > It's easier to do that quirk in userspace.
> >
> > But I like Alex's original comment that at least for PF there is no rea=
son
> > to hide the offset. there could be a flag+field to communicate it. or
> > if there will be a new variant VF driver for other purposes e.g. migrat=
ion
> > it can certainly fill the field too.
>=20
> Yes, since this has been such a sticking point can we get a clean
> series that just enables it for PF and then come with a solution for
> VF?
>=20

sure but we at least need to reach consensus on a minimal required
uapi covering both PF/VF to move forward so the user doesn't need
to touch different contracts for PF vs. VF.

