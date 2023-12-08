Return-Path: <kvm+bounces-3897-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B2D2C809A94
	for <lists+kvm@lfdr.de>; Fri,  8 Dec 2023 04:42:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BF5391C20CE1
	for <lists+kvm@lfdr.de>; Fri,  8 Dec 2023 03:42:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D514D4C80;
	Fri,  8 Dec 2023 03:42:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ABCi6HyN"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.20])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFC5D10E6;
	Thu,  7 Dec 2023 19:42:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1702006947; x=1733542947;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=L0aPB/0kx7GYAD5aNSyy4sjDz8M7QgNcwz/dbUOftWc=;
  b=ABCi6HyNSR9rBknxE050D9YVZQz/gx24swtxJWM1xn7FqJkACzM9vQir
   om4OzfzWoHqu5rNfpD+4jUZIEP8CKH+kaK4HAG1Q8fmZ3RadFNqZV3CxO
   MMU3bIPIbXtRJyGBQNAGmo1GgAXwmxuBhhqxYtBjZb9mrBzw/R5wFI/RU
   XWWWslTwdnoiEmM7sipZuQ7BtaYL0CvVH7Lz/jOujZpbrlg4v5WWdvZiV
   m7Y6VD9mEo3N9Th33r1gNjnuA936jzesNUb99EyJO82GUtUXlUSOpB4sA
   qx7ByIhjamVxClpwjWZqlAtwTYk0D66I3KyFJfvNAmjT9LgCVjY0lbMu6
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10917"; a="384754104"
X-IronPort-AV: E=Sophos;i="6.04,259,1695711600"; 
   d="scan'208";a="384754104"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2023 19:42:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10917"; a="1103423835"
X-IronPort-AV: E=Sophos;i="6.04,259,1695711600"; 
   d="scan'208";a="1103423835"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 07 Dec 2023 19:42:26 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 7 Dec 2023 19:42:25 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 7 Dec 2023 19:42:25 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 7 Dec 2023 19:42:25 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UQ2jW9gz0tlC5YNZPP71V0vW0wVKJJdVHPkPaqiCHl4sREoULarjkeWAMIKKZAObVfTiDDNl4Xwhk9dIJE/yF4siPq6hJPtnj9dr8D9RWxDAjbXYYfGJr90DwZuW8M23NhgncoU7tV28VOXBhSIIUM4yFU0hrlAD2un4uDNE9Qnd06Z/QyPwmqsxFq/l3oeZ7L6s1X5RllsVhTuv2ZV9orLm7GZ1Z2DViYkk5reS2kTU2BEpOeuNH0+xct8FB2kgIoeFBycnCISrjMdHtrJjSg7dh2GAvLA30OxR6mmrnqcKMPOM4Pu2nWOrVFgUDtH2XdBebGtMVjATfwZqaVGlrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YPYYeQ0bwxEkZvQnUDKZOox5ADvCq+4sVsF3gj+NnB4=;
 b=ncwSAvLPPPiWgiD53X/FUp1rUss8YsqWxoojPqcko5IK/IrZCg5MPj5L9VlQBX4zy3IJFBQRMMSFT2wjWZx01Z1RLlguR3htrpjP/sg0wuLHyxo79A8fNiWjF802GMhbALtz/L7GV/btvn4ek6s4GZ1Ow4LvT4M0pXLTzn7TjDXwB8x75AFDVq55pwPebAC1k8lDQIWSuntTK9+AIUMYDlrRPLLd6vLvyPdAZuL2s36EGIeOFQb43tyqXPMycvITqLqeYkwvIGSN2UiS08Vuiy+a51MTdB1QRhad2mOcc9gLfzorLBvZzkaPrwe7h7/4VZY1TmYUlaML198pFmH33A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by CO1PR11MB5123.namprd11.prod.outlook.com (2603:10b6:303:94::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7068.28; Fri, 8 Dec
 2023 03:42:23 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::e7a4:a757:2f2e:f96a]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::e7a4:a757:2f2e:f96a%3]) with mapi id 15.20.7068.025; Fri, 8 Dec 2023
 03:42:23 +0000
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
Thread-Index: AQHaHCWMRtdDji/zHEGUpzx0eLlIz7CehUqAgABGAZA=
Date: Fri, 8 Dec 2023 03:42:23 +0000
Message-ID: <BN9PR11MB5276B67DCF9D1538CD425FBB8C8AA@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20231121025111.257597-1-yahui.cao@intel.com>
	<20231121025111.257597-13-yahui.cao@intel.com>
 <20231207154327.4bd74c98.alex.williamson@redhat.com>
In-Reply-To: <20231207154327.4bd74c98.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|CO1PR11MB5123:EE_
x-ms-office365-filtering-correlation-id: e39c8534-d442-4a14-354a-08dbf79fb02a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZZ70KETTeeKq7UiSMKhsO8Beteb4BQUELqjH3IlAeQJ0ZNM44JqZT4tBL88NJN8fejUTngdPgNkwNi7r4A8BWclYNAAOmlmwXNbHKRUYI0BiN3ZYluTXvbMLOrUOpkQPwghQNOoVvoqR69EjOg2LgZqjYALFbnz1xJQQCTdopE/MDjeqb9pS+KmzRr0NlwOGo4dO6F/SC5yhXLB60cZfWPwK/mQO6lU4RZ1jRB6Pw/LU+EgrPhFShBnEDZizojgKT78EFW3hSeiel7bdhrD3vZpMiPvbESf5EgItp09fkPEe5ZekIGpc6S/ZQEuHEvP2yVr0+APv6Bax/9fZAS9/16kc9wcL4jFafcGGeK5ur4DpoF6gbIEC+Znw8sUkjDgtDpK4INPoGWq2AzCBdpT1/lTpIVs8kGeR0ptHdIXV6kBhQCazP14CkHCYyQLXpxIIis7D1EBzV6wAO7Y21bVa9H2mJdm/vK7P4S8ySykfly/AAI6hlRh2fCGzKT6QArd+EOnFRPXok9bZvKKSUHAF9n8iWZVPlgS13SoZzHD0O6vHEdKbT9Sa4zx0i3u0lCijbXcQniSLkgOXewiE++8ErMcyCiN4BCuzGDMCUlaXIafCXRgQWHER7EcKSqjCib28L86MgjwleB/weCLTR5qg+GL/At33/NeIVjPK+Y+KnbQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(136003)(346002)(39860400002)(396003)(366004)(230273577357003)(230173577357003)(230922051799003)(64100799003)(451199024)(1800799012)(186009)(110136005)(76116006)(54906003)(64756008)(66446008)(66946007)(66556008)(66476007)(7416002)(6636002)(316002)(82960400001)(2906002)(83380400001)(55016003)(86362001)(9686003)(122000001)(52536014)(26005)(38070700009)(71200400001)(478600001)(8676002)(8936002)(4326008)(38100700002)(7696005)(6506007)(41300700001)(33656002)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?TT6ERm5wBSnodjNV6/crcb1St7wp1eY8cO8MW3edwPE2ZYjjPkwYeJqz9/w0?=
 =?us-ascii?Q?NSwZSkbRoW/kR0/36lraB1CRgtNF3x0pljlFJ36zAVWrnQXIFbMcuMqjTgzP?=
 =?us-ascii?Q?hwI0vMc8ZcCeAnCykSXWFEiJUFGT73fy6D+g6Bgm3GJg9yuKK9yX7VExOLe1?=
 =?us-ascii?Q?Y1BTgatLWx97o58SaGlrbN27BfG5KoRSZ/0r3CXSQQ+nFIAk3KqI9PLW8VE3?=
 =?us-ascii?Q?B94ZkP2NdUVmNMBfNXQ6dk3l2Q7aP0qAExk43/VaisUvhzi2creHVA1hw31H?=
 =?us-ascii?Q?5ZMFPl4zaqkdA0BpEd9lI/pVkmefDTGBOIawsQtH/NXn0k+zkzROTK/akZFn?=
 =?us-ascii?Q?9W6sdsHqo6Jocj/VMOgb0SnSbeGSALsaBF1MwODZJbQzwh2X5M7VTrKwDUd5?=
 =?us-ascii?Q?rKokfNoNGQDZc3BoAXDkFshwZjhc84K8gko8lpIaK3p2yuW7B38rpsZRrJtZ?=
 =?us-ascii?Q?LN1GYFt+t23k1RezgFLASwquQB7LqHl/mvfI0hdapFOet5hJ90y4HGwDCyko?=
 =?us-ascii?Q?bJmtB7z8RHY8ikitvnz25pWUCKCpzzsJS9PUyCdjw4ziK26agJE3ve9mWM32?=
 =?us-ascii?Q?Ku0Ql0SaSH+hiiC335d7KcUh5ndkzjNe6tI+EQ3x2Q6D7X1+O+lNpEcQO9Oq?=
 =?us-ascii?Q?jonvYjuzJnGO2/ABe5LleF46eUJ4IeHymGJdEZ5HZ9gbK8/KXRnna4DCOin9?=
 =?us-ascii?Q?b5pRe5XPsgaSV9b7XXTSE1dkRYKaCqO4GU50sK9v9XUg2hTE2ZcWj7S/M/+5?=
 =?us-ascii?Q?zW9uoYiaeWtz6UlleNFhtWsQtUJmzqYmJ74C8oQvQLmXCozRAqRSAiF7Yn3z?=
 =?us-ascii?Q?LsflZjXA5zB3ibnN9E1FM+A/Opea+mrTczKpNM6g3zOyUzArCDJCxvrq20yX?=
 =?us-ascii?Q?SgLRzd2QbaycVn4ypEDzSFSQY0+t/0iDjjEFpwBGru/W+ZQMZ+JUB9pT2q9j?=
 =?us-ascii?Q?8Zdv2ObUMHB7d+FvfzpyYc6/RS6/Bj0/arhTs5piWIzxWqn5LoAY4wk/xEHs?=
 =?us-ascii?Q?nwpCfO5Lmru/stAU/gV1A/zZSwij7eYz3oP3cdudvCNVgQsPVAl+7F8uT4fH?=
 =?us-ascii?Q?AoVchhta2G0r0uv91QXMnVP9Xx0gGIgAB74gP86QWH3Fyx1dKaocHva4Miex?=
 =?us-ascii?Q?pFz1cKVw7N3toNy328ptZXXYvSlMhpYIEynd38ZdkLnT6gn5GWF9G4IJ4pcz?=
 =?us-ascii?Q?rgLE7PtkDYNnf92IKFpChkK5lSaw7YiZhnbI+2c3G8H1kyGPtw5yQi2ogkIg?=
 =?us-ascii?Q?71CcpR7wYv8vGo/qE7JygBFikETNANwnsH/xEwj4UmPK2I6e94taNFCWWxE6?=
 =?us-ascii?Q?WYjw9xYcErJlAxRAzIaiXU4A1fJwx3lkbHiEu5pbQTC1awLr0IA032t9NB9M?=
 =?us-ascii?Q?RGwtHToE0Twvg6sFMQ4mkxl6TnhkBdoEMAxMY250hYmd0JBZr51grSOdBssI?=
 =?us-ascii?Q?qQDCHZzxLcSbZXXNEz5PpUysK0HlN3DZVHA5iWczTmf/gdq9AbjnEXL41aQG?=
 =?us-ascii?Q?Dw/jDPm536OtRDr3ikUAAi1QVDEaNt9jBefVllsS3CO/CGuP1brHThQnB3d0?=
 =?us-ascii?Q?5VH3SEct4A2d7yDSTrW9U6ises7Ph/evaFE13RoQ?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: e39c8534-d442-4a14-354a-08dbf79fb02a
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Dec 2023 03:42:23.0447
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: J+x4LKMHd2su0UMKzJYD6cIwjVuPJMMEr/1H6KjfbsG+Z8jWTISdfU0ismFUUYgcaMO1ARmrybEWK1szlQdpGw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5123
X-OriginatorOrg: intel.com

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Friday, December 8, 2023 6:43 AM
> > +
> > +	if (cur =3D=3D VFIO_DEVICE_STATE_RUNNING &&
> > +	    new =3D=3D VFIO_DEVICE_STATE_RUNNING_P2P) {
> > +		ice_migration_suspend_dev(ice_vdev->pf, ice_vdev->vf_id);
> > +		return NULL;
> > +	}
> > +
> > +	if (cur =3D=3D VFIO_DEVICE_STATE_RUNNING_P2P &&
> > +	    new =3D=3D VFIO_DEVICE_STATE_STOP)
> > +		return NULL;
>=20
> This looks suspicious, are we actually able to freeze the internal
> device state?  It should happen here.
>=20
>  * RUNNING_P2P -> STOP
>  * STOP_COPY -> STOP
>  *   While in STOP the device must stop the operation of the device. The
> device
>  *   must not generate interrupts, DMA, or any other change to external s=
tate.
>  *   It must not change its internal state. When stopped the device and k=
ernel
>  *   migration driver must accept and respond to interaction to support
> external
>  *   subsystems in the STOP state, for example PCI MSI-X and PCI config s=
pace.
>  *   Failure by the user to restrict device access while in STOP must not=
 result
>  *   in error conditions outside the user context (ex. host system faults=
).
>  *
>  *   The STOP_COPY arc will terminate a data transfer session.
>=20

It was discussed in v3 [1].

This device only provides a way to drain/stop outgoing traffic (for
RUNNING->RUNNING_P2P). No interface for stopping the incoming
requests.

Jason explained that RUNNING_P2P->STOP transition can be a 'nop' as long
as there is guarantee that the device state is frozen at this point.

By definition the user should request this transition only after all device=
s
are put in RUNNING_P2P. At that point no one is sending P2P requests to
further affect the internal state of this device. Then an explicit "stop
responder" action is not strictly required and 'nop' can still meet
above definition.

