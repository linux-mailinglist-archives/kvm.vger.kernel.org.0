Return-Path: <kvm+bounces-9208-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D3FAB85C05F
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 16:53:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8ADFC2861A3
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 15:53:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D73F5762F4;
	Tue, 20 Feb 2024 15:53:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lKe0/fez"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C624762E0;
	Tue, 20 Feb 2024 15:53:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708444395; cv=fail; b=haQ2wvdFY0pdsTqSjaC8ugpYvNDOh1M3mGgLDPA91lUhes79RRHYCGSlX1W1qPu/JPPsRemTrV2/g/IuCvbRL8R9NFlxx80/1/YyKCW08mxOEUvlSQwRlSKiZPreMS3M3Gwp+o7mpTlPFrzgbl8DqB1XyqPaOqTB5LVy6UDijIo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708444395; c=relaxed/simple;
	bh=trmtpXt0zdm0Q5Xcp8sqGATMiV5Q9WOWH8NltYT+PdQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=CAeZ0DI6CihyiixQ0TUMuIT1AomoqwnaqN/eY7fRa0noryrAjQQlOUy6YA15tTbiYj9PQZXKdr2ty40lgdiioC9m6KB8VwGCN+JxfKE+UpPU/QZW08QmFCwkxf4F3vkQRIG7Z+fqyYr89lrF0bHLHbtfPuChktakOMXzGX0hwMo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lKe0/fez; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708444393; x=1739980393;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=trmtpXt0zdm0Q5Xcp8sqGATMiV5Q9WOWH8NltYT+PdQ=;
  b=lKe0/feznJkiPTrO69XizSFceiQ4T00NezCN0ncfRZYVmJuASOpR1mrM
   lDb0uE3qUkx9O83Uav2uX+yWxPSpa6llJOl99crlMLIcHgcC8XmqaMGbz
   UNlWN9uaHtSpancmWJZv4vcgiM+XIf+F/LoezktqZSuQYRpiAU0P0PKab
   /oeR78wran4Y71FEF9Y3N9ODZZZebnt21PYtM99irsWgvi+nXLIoE+OkX
   kXyIWahHcXMTdnugkXrkeYhZ+WQZAy4o0y2A5fGEL1qW//CW2ZgOCZk5f
   kxTin+BicIcrZiXu97CDOyc9cTOdaLE9COPJkfpfjK9n2wUTsFZ305+xv
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10990"; a="2416356"
X-IronPort-AV: E=Sophos;i="6.06,174,1705392000"; 
   d="scan'208";a="2416356"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2024 07:53:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,174,1705392000"; 
   d="scan'208";a="9479934"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 20 Feb 2024 07:53:13 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 20 Feb 2024 07:53:12 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 20 Feb 2024 07:53:11 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 20 Feb 2024 07:53:11 -0800
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.41) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 20 Feb 2024 07:53:11 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OAFcsdUgLwIhMsH4KTmIP0cLKT4GXY2OuK7L5h8fLZWN6QQ61mGx2zEtJtxo33or2ETijkURI8oGZ2riCsTaqWHO2suzvnRHLf7koz3JFwTMmbWah39Te0fw6nwQsggzxUsgY67eZLeEtezgca7uALz3B1YtPRBnOCdTxPMPsne5K0yvJD3fVkNp34F+t3M+0WhQW/Ip2V97DjJXnSJYger5fQERJ0g2l+r8wXYOGvl7nneaUdT+fi+RoGKO1odal4S298zMCgIjIuLhw0uGX5ht+680nlinGMe0HNlJArMJWBC0fBG74GXo0tDhSIfhbXQ6SoM0/eb5fp0HdBEySA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=trmtpXt0zdm0Q5Xcp8sqGATMiV5Q9WOWH8NltYT+PdQ=;
 b=ekWS6flWy7bHzrsxRMo4zy1UsLiJ+6C5LMGyQpHStWlOU81EXAKjW+Zi7PSst4sgM/L5JVzl241d4s5YT3bCIv6XryfgsbFcmA0pu813vNEcBs8Oom600cgSyAawtu7xwgN9QOKmyZOdRkI4SDzrBrJZILRdCqTtKpN8y89Q6SU0Xst5tuGnvhUIlGzSlw4zR5V2scHFn3F0KbdWXO+oX0u1/NogYBIXCSEjfV56+zzU3arrRiUY8X5RL5PhwtDsq3iexunYlui3+zh6vEEeeePUg0sl2gAbvUG2mqWRXs3sofAuYP4jWZ2zuU7HAbalqS6gx4ekVOkyPRmNDNxTRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM4PR11MB5502.namprd11.prod.outlook.com (2603:10b6:5:39e::23)
 by SJ2PR11MB7453.namprd11.prod.outlook.com (2603:10b6:a03:4cb::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7181.30; Tue, 20 Feb
 2024 15:53:08 +0000
Received: from DM4PR11MB5502.namprd11.prod.outlook.com
 ([fe80::502d:eb38:b486:eef0]) by DM4PR11MB5502.namprd11.prod.outlook.com
 ([fe80::502d:eb38:b486:eef0%4]) with mapi id 15.20.7292.036; Tue, 20 Feb 2024
 15:53:08 +0000
From: "Zeng, Xin" <xin.zeng@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: Yishai Hadas <yishaih@nvidia.com>, "herbert@gondor.apana.org.au"
	<herbert@gondor.apana.org.au>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, "shameerali.kolothum.thodi@huawei.com"
	<shameerali.kolothum.thodi@huawei.com>, "Tian, Kevin" <kevin.tian@intel.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, qat-linux <qat-linux@intel.com>,
	"Cao, Yahui" <yahui.cao@intel.com>
Subject: RE: [PATCH 10/10] vfio/qat: Add vfio_pci driver for Intel QAT VF
 devices
Thread-Topic: [PATCH 10/10] vfio/qat: Add vfio_pci driver for Intel QAT VF
 devices
Thread-Index: AQHaVSVFJ9K0TVMQD0C9btTtb+JmirD9TRgAgAQ3vqCAAHLkgIAC42sAgAhyjxCABghogIAADukQ
Date: Tue, 20 Feb 2024 15:53:08 +0000
Message-ID: <DM4PR11MB5502BE3CC8BD098584F31E8D88502@DM4PR11MB5502.namprd11.prod.outlook.com>
References: <20240201153337.4033490-1-xin.zeng@intel.com>
 <20240201153337.4033490-11-xin.zeng@intel.com>
 <20240206125500.GC10476@nvidia.com>
 <DM4PR11MB550222F7A5454DF9DBEE7FEC884B2@DM4PR11MB5502.namprd11.prod.outlook.com>
 <20240209121045.GP10476@nvidia.com>
 <e740d9ec-6783-4777-b984-98262566974c@nvidia.com>
 <DM4PR11MB550274B713F6AE416CDF7FDB88532@DM4PR11MB5502.namprd11.prod.outlook.com>
 <20240220132459.GM13330@nvidia.com>
In-Reply-To: <20240220132459.GM13330@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM4PR11MB5502:EE_|SJ2PR11MB7453:EE_
x-ms-office365-filtering-correlation-id: 389ad2e2-7810-4d94-98cf-08dc322c08c0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DFyTvyLwbp/o42diJ9vHOwz0aIPI8xLg4b8Q4VP5Mx5bk5njUGFYM0QYUL0tYC6IKQpeETLB8yYR0wWdvJ3885yhynYYmW/LIve7optYT5XQbPWYeCl8DvGFFYmripJqVFngDCVAmrvu2Z4i52+yNy4PDN2E8qccB4Q3N4EYrKMD7Gne51F51yLA+OxT6Wf8bRkylCY8BIfvnds346SGwaE4C37Xcmg3DTppTSA0MElRrSbc7dOWp6EaxZ2heqEL+slYPOnfB3H/wLwo7pgCuIH4N1L0Pl/ScInidzBiyWWDCeu6rPcGbAIOLn2U4dCmOHXd+vwhPLuZ5KCiJ11RgHiPgwyVwLQJ5Fxpj5GapkGjoJwRBQDYjnRO/V4Rz9KSq8kR89GiQWQZLgdP3PgT9pBMmBaQNSaoZdio8bhNbW2XAERJCrhnp/iGnCiA9QF6viwo0tL8SJXFvuA3cYJIxA4W2dJQVHRZozqVtdoPeAg9sPUTYLJNkARVY3Vpgkro3ZExjhWVqa3HRwy+uz0bn8VJad1Katr79e6QMDhrhhuWiK9Vp72SvvE+kcrdLYPgjH4fBs7Tz8Ob8MQGN7Bo50+kRB30FGdVAAquTD3z2QhbdngU6MapxodfNnvgg57Z
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5502.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?atYyu+u3DWVdLj8cFrmvpPECYmxP0Ylfm2HJqUBs8ShAbIhneaJrLVBgWk04?=
 =?us-ascii?Q?S3YdlxeWDSiMjmbXT2SXfR2gx2suMEpZ2Aj6E1km3T3iefsI1DaAHZuzoXey?=
 =?us-ascii?Q?76hP3iZDGMK72puX+rWAsNYOh5EvmtoRixO5GB9dmif/b1aaScwRqBGQG4af?=
 =?us-ascii?Q?So83O0QNg3jge77eq5/cQ6Iqvz4AAKjc8uHjUqdkQukvFzpnFyIVVZwB7pNu?=
 =?us-ascii?Q?pneTkFkSUmqTJylqEiy+tjegxnNknlOEUbsxehnmAdy1RCUS7SqjXqlwtjDI?=
 =?us-ascii?Q?LC+bi1YbZRrIoHhRpNnEK0G+OmKUv/yDcQyjWGX1wJZOsGNCSB2vhVWbPcj6?=
 =?us-ascii?Q?ygw3Yl5S+Zg4qPVOcY0Ag17ZX906hCvOs/sd+p8bpL7cFtqayxJId43fBODc?=
 =?us-ascii?Q?M+Su8TrDDeQtK38agF45PK5+FhUaXlon32tLA4iW5J5VpX0vEHJYnERjnLoV?=
 =?us-ascii?Q?tfHNMjbpMVcSec50Mbi7uXJvQjyV8ibvCPrfZCXY9SZX8G4kny1tb1EetOz6?=
 =?us-ascii?Q?Y1Lqh7ZO3+uAsjtmnbl0Vj9f4iu7MgXYloKi/sBaW6F+4Jbz+U0YRbr5Y1d8?=
 =?us-ascii?Q?q6hi2H0gFRJpJwU+Tvir2nAhutWMWO/BbTn48kjeQnAR2LqWJmW6WTOi25NL?=
 =?us-ascii?Q?TQNxeqpVrlmhh1rh3JERnpIn9HEMDzA+R/OPlIDR3sboEEnnzGN88rKWxQ/p?=
 =?us-ascii?Q?P/VDD0Q0iqoKhxcZoFZckoiiQ4BnSlfjJ74EmnYZt2TdN4UPHa48V/djnYTx?=
 =?us-ascii?Q?Enh67oTehVwu0QWILJwGjEnHI9tZs76f/a8C/ru0aUd9YkH2Wh8/AiAQuKP1?=
 =?us-ascii?Q?NVTr/YjBATHv802Y6bIKVOhBkghQICWh5Z17F1IrqwP8Y8LFVMdZVwHi+/qH?=
 =?us-ascii?Q?gH5vzHCCO6ESMKXF/HuVppDcsMV4gQp6hd2KiRCmpI46vHzC8VDwvfIzK84b?=
 =?us-ascii?Q?6YcrVpqLesOhX44n32bfY2L7ZV+VYFTWG+vNfe2Pwy607hYyu9byLUB0LLl3?=
 =?us-ascii?Q?W8Hz8oYSfffbEb3vrs5yuxMI6NDN2VrPbYyUAXhspnUHz2jEfb9TCy/TzLko?=
 =?us-ascii?Q?ZHT03NiGlIJvUl1GVKR9Cnf/ICrET7dXK8Pyq1MgKzn2jYU67IoZeyvhJ+fG?=
 =?us-ascii?Q?jsNcxhKnDjNenHxy4QQdn4+2DWf2HFgCPkI9k12zJlvA1+9Zw1RoKMIi37rS?=
 =?us-ascii?Q?qWc3yOxpRDJjp6uuxapgqeyntO38++bMP5K7NALLOM0wvTUBfL4970ugynE8?=
 =?us-ascii?Q?GWTDT7LK2T+UAYU+xzagcYSF0m/6SbpmGBLeEvSeXAgoS6Ei+kMG6u9FlZTO?=
 =?us-ascii?Q?ta37Y0uq4d6KZc9YLbiAGG4ktVGBQez2FMKziXXoXyUrWDyU2ic8MlA1RLLI?=
 =?us-ascii?Q?zUtzI7+EP2GBCcvma9XknEFQMf17a3toGacLfapmsg7Uri/EurVOqDLexCym?=
 =?us-ascii?Q?mwaJPVKSdQmt3UrJfxkITW/+p1WUWoN6EGe5cxlMU+dkYZU1Dv8EimyDNq3Y?=
 =?us-ascii?Q?VF5FPvjNWaQOUOa5NM0qnx13vfsm0Z38pcIlzKyAqkiJ8r4BHe4KnBRlxUHP?=
 =?us-ascii?Q?53wCC0KEo21xzUoLL+26YNJ97aRc/Ro+xyuMTNVc?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5502.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 389ad2e2-7810-4d94-98cf-08dc322c08c0
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Feb 2024 15:53:08.6304
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3GpU+nmhAaHFion+8pjcG7nbXv+NEevwd8QIGNzVpSlv4V26C+geUpyEU8w2FlSTrZmXAHrxZRQwgro/8HfsCg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB7453
X-OriginatorOrg: intel.com

On Tuesday, February 20, 2024 9:25 PM, Jason Gunthorpe wrote:
> To: Zeng, Xin <xin.zeng@intel.com>
> Cc: Yishai Hadas <yishaih@nvidia.com>; herbert@gondor.apana.org.au;
> alex.williamson@redhat.com; shameerali.kolothum.thodi@huawei.com; Tian,
> Kevin <kevin.tian@intel.com>; linux-crypto@vger.kernel.org;
> kvm@vger.kernel.org; qat-linux <qat-linux@intel.com>; Cao, Yahui
> <yahui.cao@intel.com>
> Subject: Re: [PATCH 10/10] vfio/qat: Add vfio_pci driver for Intel QAT VF=
 devices
>=20
> On Sat, Feb 17, 2024 at 04:20:20PM +0000, Zeng, Xin wrote:
>=20
> > Thanks for this information, but this flow is not clear to me why it
> > cause deadlock. From this flow, CPU0 is not waiting for any resource
> > held by CPU1, so after CPU0 releases mmap_lock, CPU1 can continue
> > to run. Am I missing something?
>=20
> At some point it was calling copy_to_user() under the state
> mutex. These days it doesn't.
>=20
> copy_to_user() would nest the mm_lock under the state mutex which is a
> locking inversion.
>=20
> So I wonder if we still have this problem now that the copy_to_user()
> is not under the mutex?

In protocol v2, we still have the scenario in precopy_ioctl where copy_to_u=
ser is
called under state_mutex.

Thanks,
Xin


