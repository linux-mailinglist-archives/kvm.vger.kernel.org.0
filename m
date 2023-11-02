Return-Path: <kvm+bounces-353-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D11587DEB35
	for <lists+kvm@lfdr.de>; Thu,  2 Nov 2023 04:14:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F33181C20DF0
	for <lists+kvm@lfdr.de>; Thu,  2 Nov 2023 03:14:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 674401861;
	Thu,  2 Nov 2023 03:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eNyf/VGU"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAE471849
	for <kvm@vger.kernel.org>; Thu,  2 Nov 2023 03:14:43 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC6C4127;
	Wed,  1 Nov 2023 20:14:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698894879; x=1730430879;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=Ry5OrLHhK7mQo2BT047TShcJGFz8wk2lkx5PgK1RiXc=;
  b=eNyf/VGUzZBLnx7fLNd7vOuFV4Q685xsA8WUUTSXytYbJMafoNkhwTxQ
   wccfk/+nZit4qIVl/JYcH5wjiwvZPX9eOB5ghlKj94nFUmKRQHWvf1sd+
   bUlv+Ja5j6QUpBQ1N12PVrIFKGBjAL69/EbC/Z41FI+13zc6w6UCfDZ+i
   CFOOGt+kOt2KumxUScqM2l+PlKpPsYlX+djjDWQt9qNirMEtUeBMqHa7g
   kTlGoq+sewDYmnkKR+ru7zVWxQ310Q/EB49mhePgrw/ifJhLGDCCOer12
   U4kRAgLx3OfmcL/gOo1ONWhgdjBfranxk004fTPPX545B7hlLIcKU0lJW
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10881"; a="392511740"
X-IronPort-AV: E=Sophos;i="6.03,270,1694761200"; 
   d="scan'208";a="392511740"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Nov 2023 20:14:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10881"; a="826976187"
X-IronPort-AV: E=Sophos;i="6.03,270,1694761200"; 
   d="scan'208";a="826976187"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga008.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 01 Nov 2023 20:14:17 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Wed, 1 Nov 2023 20:14:12 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Wed, 1 Nov 2023 20:14:12 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Wed, 1 Nov 2023 20:14:12 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.100)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Wed, 1 Nov 2023 20:14:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QFkexeKChjs8CTSxEl4hA/KROOjo39VKmS7RBNw7V80NPnl4/SeUnv/t9uY1Xc1terGxqlVemnL3L29ET7LIaW73DmjLu8dFt44Ts3WQMv6kT7jyEzUfsZ+p4DSDfQ5TYWMzQr8/nx0Fi2dYo2xIXsSG45tALycTt+unjtvlA36B+/JiJefRD4RnCM+A9TgcOEn3IS/LU0UYZsUBDk+9SHFPeREn7baqgohuPmHm6m5IiOX2MsKb6WQr/YYLspHDcabGQvZ0Ou6lmO1mAII6iFycgOxWhdwtbC5dgJN5B31wC/pBXz4V6Ioa0evz0oEwARW/i8TtjikhEOGypyxgoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sBYDg3FKIZjQPuyLRGVkTUMKIOxWFLrOI05Pf7Ikg44=;
 b=jNIaAA2GHZv2+WtZzmP16TqJsEottJWVv2teUwFa/7MUcYVxT8QL71uNOgH54zEm8B8w45hjlfbsQFBcwvsjaxVrs3LrujNh0WfcuHZE747VGpWpABM7WwnqC0mWShc8K3+9Dz/+zIsLdtRXIZFH1ZXwFzlE2f/EQyJSqHj5mlkdXVfbeLspyVDNT4GAeOHcnCh8fk0L7lG7h0LgXaENCTWgyczKFHUMAd8HOBFoLt1BFNM2HppX4GAequqlWqOSxBGG2dQ+sv1je3DBZetpGWkyxo/JMHqg6UDfPQll1WBuqbmp0upv+DcwKhu8BGWFNUz4iUsarHxpsro0rk2v1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by MN2PR11MB4632.namprd11.prod.outlook.com (2603:10b6:208:24f::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6954.21; Thu, 2 Nov
 2023 03:14:10 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::e7a4:a757:2f2e:f96a]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::e7a4:a757:2f2e:f96a%3]) with mapi id 15.20.6954.019; Thu, 2 Nov 2023
 03:14:09 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Alex Williamson <alex.williamson@redhat.com>
CC: "Chatre, Reinette" <reinette.chatre@intel.com>, "jgg@nvidia.com"
	<jgg@nvidia.com>, "yishaih@nvidia.com" <yishaih@nvidia.com>,
	"shameerali.kolothum.thodi@huawei.com"
	<shameerali.kolothum.thodi@huawei.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "Jiang, Dave" <dave.jiang@intel.com>, "Liu, Jing2"
	<jing2.liu@intel.com>, "Raj, Ashok" <ashok.raj@intel.com>, "Yu, Fenghua"
	<fenghua.yu@intel.com>, "tom.zanussi@linux.intel.com"
	<tom.zanussi@linux.intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>
Subject: RE: [RFC PATCH V3 00/26] vfio/pci: Back guest interrupts from
 Interrupt Message Store (IMS)
Thread-Topic: [RFC PATCH V3 00/26] vfio/pci: Back guest interrupts from
 Interrupt Message Store (IMS)
Thread-Index: AQHaCPdEtaV8qeHO6EmMpiKLQ58cQ7BjhMFwgAJFzACAAIkGYIAADu6Q
Date: Thu, 2 Nov 2023 03:14:09 +0000
Message-ID: <BN9PR11MB52769292F138F69D8717BE8D8CA6A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <cover.1698422237.git.reinette.chatre@intel.com>
	<BL1PR11MB52710EAB683507AD7FAD6A5B8CA0A@BL1PR11MB5271.namprd11.prod.outlook.com>
 <20231101120714.7763ed35.alex.williamson@redhat.com> 
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|MN2PR11MB4632:EE_
x-ms-office365-filtering-correlation-id: ad7c7d13-1675-43fa-2562-08dbdb51c804
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: l//kgVqQJswtyg/IBIm1mBtU41J1SQqWEHLDStNMbgRzFnE3xDpy299wXcxFBczcZVuS9SosIXVZdIxB+kaWxkdSvvZ4fhLx4cnmmJXwOPjtDKfnqvJDj8yeYXn2Bt52lViBtbl90eNRfsBStVtaatrpMXE2FLoe2tK+VPeRBpvzZe18r9820wIuEkhOApLrPb1tRRP2j0frp/q/lcH4/JwromPDUw929VJwsIUPlGwu/3nLVT9Zlp1lKV3W7CFq6hrUK9OzGZljyfJ4Jqwv1zqXX8cnaqqYtJ+/IbnPZMwXz7FZ6SobMpo0mbqG0LIp+rzr8Kt9ZUKfNPcYzmvpIyCDNElo4XzISBu25JJkXSi2GRLyixoGK5ZYuyj2ZvJKccXRsqQTyZVZfxI0My8UAs1khfkYU0qxQiKwFOY28xurviJGE07S1QAFIX2Tqgq8Gn4KlxfM9h5cdXTHUshcFU8QyiiZfED4OY5UFTfxuodHXDi7UxD/DNzrVJxwawYUd2YHzHar9l8Gweuru1UYxmjNZp40lwZwDWgdybhB51hRm+3NsSxGq6p7TPU3DbuTo4YBKyjvurc/+DHb5XHnmWXGPBK20AAvWDRYeaG39ONd339Se19vIGNnrxzH39nK
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(376002)(39860400002)(366004)(396003)(136003)(230922051799003)(186009)(1800799009)(451199024)(64100799003)(478600001)(7696005)(6506007)(55016003)(38100700002)(82960400001)(122000001)(9686003)(33656002)(41300700001)(2906002)(86362001)(4326008)(8936002)(8676002)(5660300002)(52536014)(71200400001)(54906003)(66556008)(66476007)(66446008)(64756008)(66946007)(6916009)(316002)(76116006)(26005)(38070700009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?KupFKCLhCNyplcdCHYH05aq0hbnnDR8Mej1Lgivu8O++nuYFqiPL8S65lO+A?=
 =?us-ascii?Q?YqDck04KR9dE/O9zpqYWT+Sf/FFmoZgHsmFo6i96oMeCsy7Hg70MawVSOPAE?=
 =?us-ascii?Q?XuvA70aokLEoTsfemJruHMq9PkK5EgkHBEOcc1Jn0YwcyoLl3wM8WBEaztrP?=
 =?us-ascii?Q?2y/LOSYYb8GXUfL32v0uQYJHJWtPMfBk/RpXEyLYYmuMFKdkNd+xaWCgmDAn?=
 =?us-ascii?Q?Yx41RkBX81N7fiGPOSlYrW6n0Ng/8Fbl/xaKkhThv4XktMPNWkOoGAHj4pql?=
 =?us-ascii?Q?R7zy1TldVu97b0q6pSzstgU2CwN5D6uXXaGXRcBBGb1zsqM5jXTAyEkMVDhL?=
 =?us-ascii?Q?PAKQyAflHnA/l0eT+sOzULdnh/TOb8H/oMq3XpM5QMNla2DGwS4SjQGkkkl6?=
 =?us-ascii?Q?yDZOOgrt0/mWOXGKvDLUMHLPSU5jHBzAFJqabo3CBMQc/TQc4kC72VVX9+fB?=
 =?us-ascii?Q?E3f1gSnDRugQykjmqiG8vafYmzcGGJs+/4nxjkEEBuWI2V0acglTbdCMeQup?=
 =?us-ascii?Q?5o6Z4KtxIk1AoG7G9RrDHpX4VYYnDhIECWMwZh4SKedpA2JT5zJJ1pcIQKo3?=
 =?us-ascii?Q?X5OuwuIIjSUEW/ylteA52q4uvMsM4mUW45ZJ2hI0YRr6wJNQ30VhGGAjXvU+?=
 =?us-ascii?Q?dhhb9O/dSWCN2XuMOEMplznSdS6LaQyvJaZI8NVyOJf4HS30KUVKKhGDzT03?=
 =?us-ascii?Q?gUFbF7PLJ4P1doRaKkHw8Fcgzrr/YpIw47xoA5Ozm/RY95BLqMg8Lf//+PUW?=
 =?us-ascii?Q?TNWKjaTkSNRdM+h32yMQMga5P6BaHwrcAp4pvkTtrR1oPmyiMXWrOQIG8TPG?=
 =?us-ascii?Q?RHwBXUd1K9OMzL+GprgRwKYCFM67j+5ZkfYheez0bBGLMYg6IiDVlePwC/hH?=
 =?us-ascii?Q?riZuHeF07q+/0zXZIntak9LFz4kjcQ8mia56/a3q3gFAHy+GTgNh1nhLM7PO?=
 =?us-ascii?Q?sI42/zFbAEcldSAVtoZx+Ecu+Gf0Yw5ullXURFFgpXzlAE5qT7cUoujPDOMs?=
 =?us-ascii?Q?S2xwedCdyLGdAy0oCmmIE4ZYmC0Cr1yliVU2BXMDntpnPZWDrGOKb8tieYwE?=
 =?us-ascii?Q?A/J/lieW1eu7NHIg4TuCVwJ1uhMKKfyHi+1oRJQN7Z4A6tcP46ib/8HE2jLA?=
 =?us-ascii?Q?c2PAWDdDsijHn3U+DgMer2weGGHcmuIhBtFIQkxPcECsUU8qcNMRNiT9sq2W?=
 =?us-ascii?Q?umSbDXIJMJaLuIl8guGOe/qKpgXTWG1HEzc8SFVeubJ1fkjBvVcOjkto/S1N?=
 =?us-ascii?Q?vR6CXEXiBIKtsYjDLUdH5tEGtVn2lx6sBczKXRvAk0EvTu9a5DtBp/uoxYP0?=
 =?us-ascii?Q?Cp/v+6GRdZGD7WJilXDj60klzDgc9mE+WB3zzU+vxu7LKQ663EAlEF6s7pbv?=
 =?us-ascii?Q?4+djk82Pqs3nZ6QxXu/lVRimnkBYrWR6fRFdXD+omhJcGHZ001YUlaKqHefJ?=
 =?us-ascii?Q?I2+p3n8Flf+hXar8IluFaDpv431FFY+r+BIzlBFVYIMt8BSJ52qsP0War+nH?=
 =?us-ascii?Q?sAfN+LOzwYgN9owh77IrQll+3Pc6SLKhvKqwzoKXpJLHgwpl2cvZsObM+01s?=
 =?us-ascii?Q?jnmWrTTeGun2NfPRWYH47osx0JfdTiCO35SIsrA2?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: ad7c7d13-1675-43fa-2562-08dbdb51c804
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Nov 2023 03:14:09.7442
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Wr6HuYC4liLJ06KiAXdnipjZ0e9wK3vP6gbYzhDlxhJlv+bo9WEnIDW1cRVzeJdmJ0RViINs9+A3+62cRSHwFw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4632
X-OriginatorOrg: intel.com

> From: Tian, Kevin
> Sent: Thursday, November 2, 2023 10:52 AM
>=20
> >
> > Without an in-tree user of this code, we're just chopping up code for
> > no real purpose.  There's no reason that a variant driver requiring IMS
> > couldn't initially implement their own SET_IRQS ioctl.  Doing that
>=20
> this is an interesting idea. We haven't seen a real usage which wants
> such MSI emulation on IMS for variant drivers. but if the code is
> simple enough to demonstrate the 1st user of IMS it might not be
> a bad choice. There are additional trap-emulation required in the
> device MMIO bar (mostly copying MSI permission entry which contains
> PASID info to the corresponding IMS entry). At a glance that area
> is 4k-aligned so should be doable.
>=20

misread the spec. the MSI-X permission table which provides
auxiliary data to MSI-X table is not 4k-aligned. It sits in the 1st
4k page together with many other registers. emulation of them
could be simple with a native read/write handler but not sure
whether any of them may sit in a hot path to affect perf due to
trap...

