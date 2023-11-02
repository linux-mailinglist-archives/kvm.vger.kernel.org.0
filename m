Return-Path: <kvm+bounces-351-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 38C517DEAF5
	for <lists+kvm@lfdr.de>; Thu,  2 Nov 2023 03:52:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5A3A41C20E86
	for <lists+kvm@lfdr.de>; Thu,  2 Nov 2023 02:52:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D804D1861;
	Thu,  2 Nov 2023 02:52:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WzOsusjI"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D6FC1860
	for <kvm@vger.kernel.org>; Thu,  2 Nov 2023 02:52:12 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.20])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EFC412F;
	Wed,  1 Nov 2023 19:51:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698893505; x=1730429505;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=FF8UdXCANKgBiV4TmqH6TYCPDAHyJ1+Dw0MoGEfBIBc=;
  b=WzOsusjITKtbRqCqucmjTuUHDm1fI1pVqQtgwGj/PK71YQv8mKsO65Tn
   af4u8AnooqXH09O6L4ihTOlzMs9CQDkty75YjIXJYihr1DRHS8pdi22qp
   gW92YwKwoylZyW5KmSlBmHswEgpsuyhwjhLii5jm8MhUiT/0y+FsntAA7
   p8em2kQnjAmAm+3Wdx3wPNP4EcRYqzMzfX+sBMpag28YU5OTsUQh6myfp
   iJMLvldpl8jQRVZUDTwFvh+99yY5GuDYi9M4V/U0ctCW5iWus0g2LN94k
   y/5QId0hReOLaIREpnhPbdk5dRlb3+DOCEPNpehfJrVKBq2X5Tqwtxygt
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10881"; a="379020151"
X-IronPort-AV: E=Sophos;i="6.03,270,1694761200"; 
   d="scan'208";a="379020151"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Nov 2023 19:51:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10881"; a="754648658"
X-IronPort-AV: E=Sophos;i="6.03,270,1694761200"; 
   d="scan'208";a="754648658"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 01 Nov 2023 19:51:44 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Wed, 1 Nov 2023 19:51:43 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Wed, 1 Nov 2023 19:51:43 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Wed, 1 Nov 2023 19:51:43 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Wed, 1 Nov 2023 19:51:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BB9A3hRCKMUFZueZyMt3xC/y8KNnAEWhsNPUuVPh2m+zfYnviNYzijtLSwEIyz0dpR3PpDsU0Xx1AVRcQsbmsLBkVFfSM84w2eRnVkOReTCRXJK4Gw/CQtXAUuyqBJvZTSluyWKt4ey5oN88eIXtCSjF2wqO11y27la6IyuO3NHfTtUMESrfJ0TyZt0MKUuJiWDY6xZY2XzuoGPkNIMsA5SipRLotbZpuNx16Fy+VjyP4MlMM8Eg+w/JUeHnaZCQ5vQioiKohHXqfztG+WqgRT98CjLM4UCK4FmuXyFZqeyX9tFxGwspr+2vsjqSglZei/AYzxdT1sJpQs+JtA5U4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8YUajQIIGXKm7jueBvaZaNY5L6IX1oWmAV5wyxepftY=;
 b=bYZKBEtQUzrBaHdbNwGnUSYb1aGnfT0Eh5M7yNyJJm2kjTh0sGtZBkvEbivHmS8RT6BbuzNPE7oTT4LwDH1UhXTYYIpLY7i+GJlBgNHUMekgLZVXcilVZULEKdyBpl3EzE3dXYzklEi3tW10zSD71eFBfcS9FvMBBfoRfhC16Cm4CHfknGOyGJz2CRl0WVd0ldvCSUfMhczVKoB1ct7k4kQ9bna40F3LxBc23ATJ5+bDVd2seqgIwctlQy9L8bVwJnA6X68hGzIm/YWz05+XEG/o6kPeUF6RmV142TCSj7QB8m6Tf0R6LH2GngkDvkuDYghghCpUIp47D5L5u8tcYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by MW5PR11MB5929.namprd11.prod.outlook.com (2603:10b6:303:194::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6933.29; Thu, 2 Nov
 2023 02:51:40 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::e7a4:a757:2f2e:f96a]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::e7a4:a757:2f2e:f96a%3]) with mapi id 15.20.6954.019; Thu, 2 Nov 2023
 02:51:40 +0000
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
Thread-Index: AQHaCPdEtaV8qeHO6EmMpiKLQ58cQ7BjhMFwgAJFzACAAIkGYA==
Date: Thu, 2 Nov 2023 02:51:40 +0000
Message-ID: <BN9PR11MB52769533F79F35B8E1D747A38CA6A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <cover.1698422237.git.reinette.chatre@intel.com>
	<BL1PR11MB52710EAB683507AD7FAD6A5B8CA0A@BL1PR11MB5271.namprd11.prod.outlook.com>
 <20231101120714.7763ed35.alex.williamson@redhat.com>
In-Reply-To: <20231101120714.7763ed35.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|MW5PR11MB5929:EE_
x-ms-office365-filtering-correlation-id: 6ca3350b-dc47-4fbc-88ab-08dbdb4ea3cc
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fQEa384+XHztBPCD8O6LZ+VXjMboRtGtp4SAR2lAbElxpMP4ZtGW1UdH+FrPHuotY3Qu76sRcMwgylyAwy60e1rq1EcOgOQeYypi2aM0edKK7EqnC5xA8+wBcvO1WpI3mxoJ4MoAAmA5WW5a8pgQrD3siQ62L7SZ321LIApeFAshdpEV0aib3MgZMsxiOMrsqCBiOK0WOc74nRFZpv2DF2p6iyFqpCv1j7OHP4KIfm4tYhpSwMmzq6PgUZsPkh5uhvp7enqbm6LwjyJ7vwmN1OGI78noqulrGTVrvIJsZuyTPrwjiN+1ZYeilsV0MmK51PdQDbbQqYNNQwrIwCUvwJKGvjzgKSL9BeXRBS6wZRYtS2Er1LvA/YkplChTf6OlMzFjrvKXo2vJJi9OlTZzeQxo9+DV09eydNqnM2LVwO8yJDqhm1W2g570/4RNUCIiqFwlE0eUgG1l2FNxiEKq/hlj6GCJBcgp7Izt82iug2VnS3xJVPdWVJ4OPJmmR4Q43212eUo+6OxerC563yicY2KN7IqpxM0AT5F1qlWbRgcB4t31Q3ICDD/9zrwiFUIEQLbEqICrAeFFzTJ4Xb3zeSRRhtk3ojk8eloT7kFcyzQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(136003)(346002)(376002)(396003)(366004)(230922051799003)(1800799009)(64100799003)(451199024)(186009)(41300700001)(66476007)(66556008)(64756008)(66446008)(6916009)(316002)(54906003)(8936002)(8676002)(52536014)(66946007)(76116006)(5660300002)(4326008)(55016003)(122000001)(2906002)(82960400001)(478600001)(966005)(83380400001)(33656002)(9686003)(6506007)(7696005)(38100700002)(86362001)(26005)(71200400001)(38070700009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?50j/swTpOZkxdV63nCqUWaCn3bMpbj5C7CjsAb4rClCzXuWpbmAl8zu11bdD?=
 =?us-ascii?Q?D759XeGaD7yYF4ZXtrp8w7yrrJGpI85o89zEHISFUA3gC6c5rjH8KtEofJMG?=
 =?us-ascii?Q?U2Sek/8JWwZZ8u5Q/f6R3tJTz5tc95Rg+uJ7hUkY5e8LTj496i6+9uPvzlgX?=
 =?us-ascii?Q?XsLMQZas5aIKi+mQwkT7VRLms7tZq9xLB2dkUNT+kLGnFydmt5/i0Y1D8JJ1?=
 =?us-ascii?Q?HndSeEedXng2mlm5FlWL35z9fJdp0B26pTt88r+JWcwINkygLBks9rNYkPyf?=
 =?us-ascii?Q?ZqhxosNcQmIo0sCLXa83irzX/9RmaDzXcmKDFHxzEC5ygQJxWfWhl3liqe7x?=
 =?us-ascii?Q?P/qq2QP7gFfJs7+xX7iWUdPC83NUl1fToogsoof5zXZ8KEYy3setyzKGYM85?=
 =?us-ascii?Q?pqWVSToxREqtdagGjMyI9Wd06FsJbyHCTzYkhYNI7gIL8NCzI/yYVpjU4yrC?=
 =?us-ascii?Q?sCcXYNL7wQjpZnV3cvp4sPm2AL13DmgImj7il4OZJ4BDA7ozfEkIg9cap5bx?=
 =?us-ascii?Q?H4C4U3maI4eSYqzhtOoHRBd9U86Itbe0UB6hMS6a0O8Dpr5xdGygMweY9ZfF?=
 =?us-ascii?Q?YnTBq82oWVb27iHzitfbjuT1H2WHp9yCNT1051qsD45Uy2Relvj0VRk+qdC3?=
 =?us-ascii?Q?84ko4a2ribQXlVN60B6DuHpCC+DipaSJ7d0vneSPa+nsjHbRa5K6VX0f7Yn/?=
 =?us-ascii?Q?9NZK4wxDEo5C7G3DT2gMZ/FNy9LWgjxTnfUWpORsMrZFx8CRvxP7y8dtKwsI?=
 =?us-ascii?Q?KDpJ/WkXfalrlUfCeSDMYfwTkNomeykTAH/pqCXa44xsHCLB7QwMksesnVVD?=
 =?us-ascii?Q?nX5EfhFlTuE9rGvbyI1UDDpsl1TFpXJs0eBxOItF7Z4mACFenqAXMY9SiNB9?=
 =?us-ascii?Q?mxsc+lWUkvUpLAy8btNWJJJ8eZlrdtVH8hU12XryYXvlxbmJbEHBsvYe6buc?=
 =?us-ascii?Q?EpeJ464aRgd56fMit71RcUeBWhvT/hcDfZbejtH83fCInamtMAB0ObbiFVNx?=
 =?us-ascii?Q?AegukT5kZlfbPg32BrxMFoemDw8/yJRIrF0rclsUB1fxR5JsI94UXPIgi6Vl?=
 =?us-ascii?Q?TW9dmpV7RTKT0eHET0Jz3/uKyrnBGNOtcLuqtUIz9bwrKY7mYlO8BHaGsXkm?=
 =?us-ascii?Q?pMm8nzwl/fWHySeky3yFfoORjEK4o1pjeL795UQb4RO7whFKZe7CUR2WwMH3?=
 =?us-ascii?Q?qJB+NfefcPc5ryYDQq0S4JDINchLQSr9fRqWJ7dOz8nnfI5QrISF0oRmcevl?=
 =?us-ascii?Q?fgIBshcRZvUogGRmYNeGkDWOCXqb2ZpibfRzBOsT00MgATKydKqfdLxfn/Af?=
 =?us-ascii?Q?w+KueKa4G7hP8WASM/W2ED2Q9hDVFUyuuWTTMMKq/cswrs9vhbJ0ufxn9TEe?=
 =?us-ascii?Q?W2HcvTUwgqxSWML2Pj99osBNiSEzHLQPEALhyumHn6uFF45rKVsk4qJRR1c5?=
 =?us-ascii?Q?aNjRqCr29o7AUa6dQcuWncfVP6MNJhQVX7bxarmk4ACJ7Mb/kQxVPbiGHEQj?=
 =?us-ascii?Q?08rmBCrYleFoqx8iCoehByA0a+kGudZtXaTCipmKHYu8G3y9Lf7sXYYYrJQr?=
 =?us-ascii?Q?3mczoC9FQ0SYICnZjox6l0uncK912ucbpptsnvru?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ca3350b-dc47-4fbc-88ab-08dbdb4ea3cc
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Nov 2023 02:51:40.5009
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 32ac1++0azA6vth9f/Qupv0DkzMBZT+GGQ54p9Li7kphf3x4hDDrNkU3eXZGDHSlJoH0T2MwQtDGtj2CDJyJGw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR11MB5929
X-OriginatorOrg: intel.com

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Thursday, November 2, 2023 2:07 AM
>=20
> On Tue, 31 Oct 2023 07:31:24 +0000
> "Tian, Kevin" <kevin.tian@intel.com> wrote:
>=20
> > > From: Chatre, Reinette <reinette.chatre@intel.com>
> > > Sent: Saturday, October 28, 2023 1:01 AM
> > >
> > > Changes since RFC V2:
> > > - RFC V2:
> > >
> https://lore.kernel.org/lkml/cover.1696609476.git.reinette.chatre@intel.c=
om
> > > /
> > > - Still submiting this as RFC series. I believe that this now matches=
 the
> > >   expectatations raised during earlier reviews. If you agree this is
> > >   the right direction then I can drop the RFC prefix on next submissi=
on.
> > >   If you do not agree then please do let me know where I missed
> > >   expectations.
> >
> > Overall this matches my expectation. Let's wait for Alex/Jason's though=
ts
> > before moving to next-level refinement.
>=20
> It feels like there's a lot of gratuitous change without any clear
> purpose.  We create an ops structure so that a variant/mdev driver can
> make use of the vfio-pci-core set_irqs ioctl piecemeal, but then the
> two entry points that are actually implemented by the ims version are
> the same as the core version, so the ops appear to be at the wrong
> level.  The use of the priv pointer for the core callbacks looks like
> it's just trying to justify the existence of the opaque pointer, it
> should really just be using container_of().  We drill down into various
> support functions for MSI (ie. enable, disable, request_interrupt,
> free_interrupt, device name), but INTx is largely ignored, where we
> haven't even kept is_intx() consistent with the other helpers.

All above are good points. The main interest of this series is to share
MSI frontend interface with various backends (PCI MSI/X, IMS, and
purely emulated). From this angle the current ops abstraction does
sound to sit in a wrong level. But if counting your suggestion to also
refactor mdev sample driver (e.g. mtty emulates INTx) then there
might be a different outcome.

>=20
> Without an in-tree user of this code, we're just chopping up code for
> no real purpose.  There's no reason that a variant driver requiring IMS
> couldn't initially implement their own SET_IRQS ioctl.  Doing that

this is an interesting idea. We haven't seen a real usage which wants
such MSI emulation on IMS for variant drivers. but if the code is
simple enough to demonstrate the 1st user of IMS it might not be
a bad choice. There are additional trap-emulation required in the
device MMIO bar (mostly copying MSI permission entry which contains
PASID info to the corresponding IMS entry). At a glance that area
is 4k-aligned so should be doable.

let's explore more into this option.

> might lead to a more organic solution where we create interfaces where
> they're actually needed.  The existing mdev sample drivers should also
> be considered in any schemes to refactor the core code into a generic
> SET_IRQS helper for devices exposing a vfio-pci API.  Thanks,
>=20

In this case we'll have mtty to demonstrate an emulated INTx backend
and intel vgpu to contain an emulated MSI backend.

and moving forward all drivers with a vfio-pci API should share a same
frontend interface.

