Return-Path: <kvm+bounces-3898-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C1A7809A98
	for <lists+kvm@lfdr.de>; Fri,  8 Dec 2023 04:43:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DCCF8282003
	for <lists+kvm@lfdr.de>; Fri,  8 Dec 2023 03:43:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 239DE4C87;
	Fri,  8 Dec 2023 03:43:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WFTou0bI"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A29710E6;
	Thu,  7 Dec 2023 19:43:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1702006982; x=1733542982;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=DXpn5pdtx3O+VrUhZvDaiCrTOPYmNAtGBYpsHx93FiI=;
  b=WFTou0bIaTwdIaBKcXv9099RJZOCZIKP2Iw/yKCUf19DoXvTxK8nc4Wg
   +H6jbRupvei125jTZY0P9dD+l2x/c87QGTQfRdCDYOjmrhdxTTm+hgqS9
   vrQ94Hau9korPOrs28ggqcYrHVguHob/2WKiNQ9ATHNJjpJ13o+Fka6t6
   jUq3TSDiFAj0nTbuBfwCseEBGNctEKgC/YIUGtByDXoezaOKTnCprzpjE
   EJ/q7lkgYAWsFjVp6TD50gbkZwR1+NxHBtQPrfRJOY9bpOxmEhIqasyUY
   RbMjgLTGZdiX4K762p5/F6NC0nPXaOiih/zm6zMUMgxKAK7G3gs5USH+z
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10917"; a="7713763"
X-IronPort-AV: E=Sophos;i="6.04,259,1695711600"; 
   d="scan'208";a="7713763"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2023 19:43:02 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10917"; a="862723139"
X-IronPort-AV: E=Sophos;i="6.04,259,1695711600"; 
   d="scan'208";a="862723139"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by FMSMGA003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 07 Dec 2023 19:43:00 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 7 Dec 2023 19:43:00 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 7 Dec 2023 19:42:59 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 7 Dec 2023 19:42:59 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 7 Dec 2023 19:42:59 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aEP5sy6z9zQgP8q4r13E9BdrFs4LkyO+sJPcaprL/Uw+vLrXv/ci7yCFZBD2XSp25xrM5rO9oqyi0KiaQ+4unSzW4aa/YKPb1fPmZnPve5ZLbuV9h3AbdmDw17wjis0PXl5XZAWT5XJCExzX6e8lbivJlNBDk6Wr3hIL8p8N9lt5sTFc0Lf8tBxoQyRfRd5IecEV5Gs0iFFTiMHL+NKDWHB2qe5fmR05aS2C/fT6jdtHB07hIivxx0cBjBTLtwuSXHF6IwmGmXpDDYS0khrOy/uq85PMR7SIYKXl9FNZFQuosri1xSqDdsdKrqycpY9HSUj56bcbMx2C1ScwAqkn1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8IXsm47SFQ1lj4vW9Z+GHZoz4IScIDpSMViQ47iN4Kg=;
 b=PFezFO8FIZSzllyv/ZUuOa5eQG2OVpd6TnLVzXWsatr98Sh5AfjiKHh5T/L//QYJDgWoeRTVcY/mp6bNEiIrvPUjDZSJb/ZJ0QQGGPJDVW+snq5x28OfyyDO2s6E/YfhP9IpYkUQ+e1YSi1QqT1rysWvWXedDDkSI3Uf3YC60eplXXTC089ZlaIN8BsSLSwrjxEiVEYB6rztZ55D03Q/hPZyQqQuxmL+txnFuAwXZgfFIsJDZAdLf2EV9tsUHXHXRySMxBenoT4Zm8Y0VOpp9ksH+DucgujroqI2TyDAhPh0OmGViKARdvikOxRPLZdpB676CcUBgpl/qvmt1I5row==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by CO1PR11MB5123.namprd11.prod.outlook.com (2603:10b6:303:94::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7068.28; Fri, 8 Dec
 2023 03:42:57 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::e7a4:a757:2f2e:f96a]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::e7a4:a757:2f2e:f96a%3]) with mapi id 15.20.7068.025; Fri, 8 Dec 2023
 03:42:57 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Alex Williamson <alex.williamson@redhat.com>, "Cao, Yahui"
	<yahui.cao@intel.com>
CC: "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>, "Liu, Lingyu" <lingyu.liu@intel.com>, "Chittim,
 Madhu" <madhu.chittim@intel.com>, "Samudrala, Sridhar"
	<sridhar.samudrala@intel.com>, "jgg@nvidia.com" <jgg@nvidia.com>,
	"yishaih@nvidia.com" <yishaih@nvidia.com>,
	"shameerali.kolothum.thodi@huawei.com"
	<shameerali.kolothum.thodi@huawei.com>, "brett.creeley@amd.com"
	<brett.creeley@amd.com>, "davem@davemloft.net" <davem@davemloft.net>,
	"edumazet@google.com" <edumazet@google.com>, "kuba@kernel.org"
	<kuba@kernel.org>, "pabeni@redhat.com" <pabeni@redhat.com>
Subject: RE: [PATCH iwl-next v4 12/12] vfio/ice: Implement vfio_pci driver for
 E800 devices
Thread-Topic: [PATCH iwl-next v4 12/12] vfio/ice: Implement vfio_pci driver
 for E800 devices
Thread-Index: AQHaHCWMRtdDji/zHEGUpzx0eLlIz7CehUqAgABGAZCAAA2Y8A==
Date: Fri, 8 Dec 2023 03:42:57 +0000
Message-ID: <BN9PR11MB527602684F6583FDAC82A2AE8C8AA@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20231121025111.257597-1-yahui.cao@intel.com>
	<20231121025111.257597-13-yahui.cao@intel.com>
 <20231207154327.4bd74c98.alex.williamson@redhat.com>
 <BN9PR11MB5276B67DCF9D1538CD425FBB8C8AA@BN9PR11MB5276.namprd11.prod.outlook.com>
In-Reply-To: <BN9PR11MB5276B67DCF9D1538CD425FBB8C8AA@BN9PR11MB5276.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|CO1PR11MB5123:EE_
x-ms-office365-filtering-correlation-id: 983372f8-1562-4a0b-d9ef-08dbf79fc470
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lHECf/E/T61EdV1OppxAqiz4G7/YF2fdeyXkjiag6a73AoFhS79urxxjKV6Hm7wJVfBP+QMTa9yvqkN0SrOWujpWJtDqwY89jxr+BBxP8WGl8hxH2cyCA9OKfzLStZJjJu5hv/X3Cs8GqcYodbszY8HK+UybSDaXBWxpaXm6wrkfxKfw8jvqpSbAm0c87P47jGdD9C0mRx2jUudfCa+BZFLRio2MOq+MTvMSK4j4iBgqXXL/t0CDAeCRLETHRihb4NOviYHoQG2rhbl15TJBxXABgoNADWRPEwyEuT8BXOIs76Ne0817YOfEgwr+5DM4Cz0A+00UVweDeEDS7NakgFyayHlS5u/cmffTilRhj3kotheRRF5B4MZ+cZdfCqBQg9n0pg5RrHavuZEpTo1pvc4ZWVA4zrvxThDC/x0O4ZEIQfEGakv9ddAfRsROi4OvWeOnanhkZgIehB+gSP47VmVM+3/RtxjjIQ0vY+mV7NlaqAa63AbY2i6cELnslHgNK9UQH7DISdnh7DXGd8TyROpaAYGfHbIR5e0TfLIEDHEtfmFcVYu/iD9AGtjpPuydFJ4HUFa0d2hBfghjTA7yjJwTbxO/Hob3yaMoaV8LvGGceT1Y1JlgH3P31EY1607upQ3aNAcxbIJIh5m3b+p1dA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(136003)(346002)(39860400002)(396003)(366004)(230273577357003)(230173577357003)(230922051799003)(64100799003)(451199024)(1800799012)(186009)(110136005)(76116006)(54906003)(64756008)(66446008)(66946007)(66556008)(66476007)(7416002)(6636002)(316002)(82960400001)(2906002)(83380400001)(55016003)(86362001)(2940100002)(9686003)(122000001)(52536014)(26005)(38070700009)(71200400001)(478600001)(8676002)(8936002)(4326008)(38100700002)(966005)(7696005)(6506007)(41300700001)(33656002)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?AUBhkaMn1eqDWSSCE99EqzeG4ZQ6DtFhichwcJeMSN0UIysnlQ0rHU+AjIfZ?=
 =?us-ascii?Q?4zPULdNzzrmfmiykwJp3xJHmHENI3/CRgjok/zaIitLwHiRuScL4hdwghKSF?=
 =?us-ascii?Q?sLNtfuOT5x7gj5el14wNF4Ut7hTgAnyC45sYxyju+hv64MIWLKFgS5IJGXKn?=
 =?us-ascii?Q?LbjTHOj1f/d48eBkq1azTQV9jc7rzmT/GH3naFEQaTiRII3nHkdHqsltIykN?=
 =?us-ascii?Q?gQd/JdD6gBoPAUbf2TX6FWSRnnlw/scQ78fK/5J5aCVfoVyxHRUQEcrXV0w7?=
 =?us-ascii?Q?W32YLlEdPa5orHYL/6DNPiodHxtM87xh4M2DoX/RpWcaPUZwy3bSRkzx6l/T?=
 =?us-ascii?Q?nmmPzdBYkUD5XHPcK58/ZP/9sUfppxfhYTSwl0+pd9EilGWYiQ2l0SXOlBae?=
 =?us-ascii?Q?o0GyfJKO9QTkWAV5O7uvt3TQY6iexVJ/OIgv+OV11Gdc9OKQibLoYZBtBuDp?=
 =?us-ascii?Q?JMXbS/wBcsS1iL1RIBvp/scX36ApHO01etgYqI/FPK9vz4jVRIQhLPqHBDnk?=
 =?us-ascii?Q?nqZKh+KLHK9sQhfqsyWc9OquLpFxYZdv8b9NFvcpRwUaf+KMoYULBioxa4pw?=
 =?us-ascii?Q?snQyy9Zw/+4u9t9b4WM08wPM/fsPCZ0Uq7LuyjtrOPqBUJaCVN1n9TlUkeEH?=
 =?us-ascii?Q?NWQyW/QF8Da+JA5ATX/PvdP0J8gdkZSr2j6BtWSf+K4/ADcafy9JZK1ruCNB?=
 =?us-ascii?Q?bbVW9t7sdC6cNxwmhEh9z1dMrPXUNvGmiSUFcotH7h+/ppi3+uHfyMyc8GSr?=
 =?us-ascii?Q?X8hZQyL+tTyGCsxhQI2X3G0LqaMFh1eDjk5wFt6iB/rB805/bQRf+E3z2Lkj?=
 =?us-ascii?Q?mgBkX61XB6xxvwvaOVOw501nSLLt0KKoiBXF5T7qKUfqmkZDD8hTD7OtioIu?=
 =?us-ascii?Q?nhGcSEIUYMCY25S1y2Qc9rjgTVc2IAP4zT/VH6wayMpQnPmNsKyRWmf+alY3?=
 =?us-ascii?Q?YQUmBNQV78vnHhdefR5WFWTw7t+rHrI0yO3G14FEd/seGObZ/QypJ/kqv+uQ?=
 =?us-ascii?Q?sbwua9mMEu4l248DeqCNbuVLPypdLniJXpdIr33CrtS4X3xDK7ajs9t4KtfB?=
 =?us-ascii?Q?58v6QYNX355bESnP1se7m9o1ynySVJbdIxCv4Am2PpeGWld/DZ7TFNKn5UBy?=
 =?us-ascii?Q?ZfJAuw8fZMazj9zeOV0X5uCSUwTzJ0OsIZm2SzrtX239zCPxhL3BC04bLMaN?=
 =?us-ascii?Q?/DeBSU6czWuSje7TsrTlhBpu0tN+QiKIDf38c0KAHP0tVg30F0TJoiDOxs5J?=
 =?us-ascii?Q?wFxGparc39fcxW93VzZHEWsJAm2Kt0EpFvmY47bw6wOH2BkPsBT4+2rBM4PP?=
 =?us-ascii?Q?lkk0WEVy1KX1RYHFZu5692b/t/f7CiMOrb5hzPG1d5L1S+b7Ey4fEbLyw68X?=
 =?us-ascii?Q?oUAyAwkge7nhNZIgy+hwIJOZP3eWy3jMlzdgcu788WpDrZv3rKJPemCAw7Vg?=
 =?us-ascii?Q?BCvnogblQ7YeGFuo1ifBRWWTspPp0FTiQROl6O99NLdH/9u678hhkL3LzoL4?=
 =?us-ascii?Q?PrTy4HwzcQlbVl5PBNHK84NqtvO4+19ysa4QUKUDTbNbV6jCr+ACEO59/+T0?=
 =?us-ascii?Q?8og9AT0gd0M/yJIROu3wKpzwenPpJ1Jv0IN2zlAO?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 983372f8-1562-4a0b-d9ef-08dbf79fc470
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Dec 2023 03:42:57.0505
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IZb6I8IKzMUqwpnNY8gcKcHB+/siCPRBUaYpbX4JWWxfOiAX8kONFXstw+gp6fzy98WszVGRoKPOeisBb6bbCQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5123
X-OriginatorOrg: intel.com

> From: Tian, Kevin
> Sent: Friday, December 8, 2023 11:42 AM
>=20
> > From: Alex Williamson <alex.williamson@redhat.com>
> > Sent: Friday, December 8, 2023 6:43 AM
> > > +
> > > +	if (cur =3D=3D VFIO_DEVICE_STATE_RUNNING &&
> > > +	    new =3D=3D VFIO_DEVICE_STATE_RUNNING_P2P) {
> > > +		ice_migration_suspend_dev(ice_vdev->pf, ice_vdev->vf_id);
> > > +		return NULL;
> > > +	}
> > > +
> > > +	if (cur =3D=3D VFIO_DEVICE_STATE_RUNNING_P2P &&
> > > +	    new =3D=3D VFIO_DEVICE_STATE_STOP)
> > > +		return NULL;
> >
> > This looks suspicious, are we actually able to freeze the internal
> > device state?  It should happen here.
> >
> >  * RUNNING_P2P -> STOP
> >  * STOP_COPY -> STOP
> >  *   While in STOP the device must stop the operation of the device. Th=
e
> > device
> >  *   must not generate interrupts, DMA, or any other change to external
> state.
> >  *   It must not change its internal state. When stopped the device and
> kernel
> >  *   migration driver must accept and respond to interaction to support
> > external
> >  *   subsystems in the STOP state, for example PCI MSI-X and PCI config
> space.
> >  *   Failure by the user to restrict device access while in STOP must n=
ot
> result
> >  *   in error conditions outside the user context (ex. host system faul=
ts).
> >  *
> >  *   The STOP_COPY arc will terminate a data transfer session.
> >
>=20
> It was discussed in v3 [1].
>=20
> This device only provides a way to drain/stop outgoing traffic (for
> RUNNING->RUNNING_P2P). No interface for stopping the incoming
> requests.
>=20
> Jason explained that RUNNING_P2P->STOP transition can be a 'nop' as long
> as there is guarantee that the device state is frozen at this point.
>=20
> By definition the user should request this transition only after all devi=
ces
> are put in RUNNING_P2P. At that point no one is sending P2P requests to
> further affect the internal state of this device. Then an explicit "stop
> responder" action is not strictly required and 'nop' can still meet
> above definition.

[1] https://lore.kernel.org/intel-wired-lan/20231013140744.GT3952@nvidia.co=
m/

