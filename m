Return-Path: <kvm+bounces-838-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C4D77E36A0
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 09:29:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 39BCE280FAD
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 08:29:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BD3C10A25;
	Tue,  7 Nov 2023 08:29:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dYn6dAM6"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C36111094E
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 08:29:14 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04746DF;
	Tue,  7 Nov 2023 00:29:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1699345753; x=1730881753;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=sC5p3A6npWIfNItWRgHFJ90wL7G+7unD67P0lpbayiQ=;
  b=dYn6dAM6QxlMmq2G7lzewxR0xAF5Cca1NCFgAb4+UNOytvsNB14IzwTP
   2L1DBnsJDbzqlwTHKrtYsa1FQTszCI71kGWxHNrn6/4MAgx8EVKdlCMsn
   c48dcwS9WzY6JirPCBD8eUQtQYMp5fRYVPJ0k9eKsALGxE0vHpuxjiEH3
   i7mZkQfy7L3ZqCQLeWiSrOfcOoaFP8GfqtjMLZ7k3/xo8y6aX+V83E3ee
   ZqUSv23HCN9xUNZUmiExVlb2ao41Ni/4VBPspaAjHu0KSgqcn0WCcQX82
   pbBqNekcmFJzJDaNThqKwBPVslZVfQEIjl1ajbni1BVeUZVsNjLUbR4xS
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10886"; a="374487551"
X-IronPort-AV: E=Sophos;i="6.03,283,1694761200"; 
   d="scan'208";a="374487551"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2023 00:29:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10886"; a="797599621"
X-IronPort-AV: E=Sophos;i="6.03,283,1694761200"; 
   d="scan'208";a="797599621"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 07 Nov 2023 00:29:12 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Tue, 7 Nov 2023 00:29:12 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Tue, 7 Nov 2023 00:29:11 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Tue, 7 Nov 2023 00:29:11 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.40) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Tue, 7 Nov 2023 00:29:11 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NU5oanAvSM1kw5G4iVNI87aRI92ccxpdc9hi83wDZ/RC7Ux5w4ufFZLXHMgL123mJrqRMJ2L9pax47H9iWF6KW6EN+g5m5cIqh5X8qh/SmZoa2TLngj3rDNNmBOrenvnnrOTLuNHfPNCVyEk2hNWnBFtnk/qECH4Gw8vl1eOveTk6OUM2wHB3FshiWPRnNsakYAwEhRUMu8zT6w2vsgED7wcfFX9aRXUbDXScIVE0p4Jz7BmMI3ooayTggsy7k71B3D9qBH/0WZeeWSSn7DGxYD8pZvyrn129s26nCf7RXOTZ4RlUgpT0MJfUeF5dWCX35Pu2s+ZIy1mzjtHkjVFPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d522EpTkDJqbauP15CSYyb3hxK6bssVtCpM9//2BG+0=;
 b=V0uchjIuSnciK9U5Wym0yPONu1S/f7JjuE/E/0DeFbxPXKB93coHvqxYMA4C0vtkwzjGBBJDyG7ExBagBGQJ8tMw7aYjVy7cFZs6Uw+zLZ15qi4uJa8cQtBXza166PdkdSTiTaGgr+wG5a1A4tCnQ8qWFR5bl8j3AS2zYuaqUhQ08satgCBqz+f/NVGBY+rqD4Lg4HduG+953PhoMJBM28XfmENGr2kdrJn3DSrMZyYid1IG+jjc1CJaHil0DE6kT3tZYQBmHOiASRDNMrGfxrFR2pUxcAongeuWM8/zFL8XytaGHWEOCoyrH3qni7eU1RXi5hcpNQ+0JliAHqF3LA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by CH0PR11MB5460.namprd11.prod.outlook.com (2603:10b6:610:d3::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6954.28; Tue, 7 Nov
 2023 08:29:09 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::e7a4:a757:2f2e:f96a]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::e7a4:a757:2f2e:f96a%3]) with mapi id 15.20.6954.029; Tue, 7 Nov 2023
 08:29:08 +0000
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
Thread-Index: AQHaCPdEtaV8qeHO6EmMpiKLQ58cQ7BjhMFwgAJFzACAAIkGYIAADu6QgAEuhgCAAKTv8IAAk0eAgAXJGJA=
Date: Tue, 7 Nov 2023 08:29:08 +0000
Message-ID: <BN9PR11MB52765E82CB809DA7C04A3EF18CA9A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <cover.1698422237.git.reinette.chatre@intel.com>
	<BL1PR11MB52710EAB683507AD7FAD6A5B8CA0A@BL1PR11MB5271.namprd11.prod.outlook.com>
	<20231101120714.7763ed35.alex.williamson@redhat.com>
	<BN9PR11MB52769292F138F69D8717BE8D8CA6A@BN9PR11MB5276.namprd11.prod.outlook.com>
	<20231102151352.1731de78.alex.williamson@redhat.com>
	<BN9PR11MB5276BCEA3275EC7203E06FDA8CA5A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20231103095119.63aa796f.alex.williamson@redhat.com>
In-Reply-To: <20231103095119.63aa796f.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|CH0PR11MB5460:EE_
x-ms-office365-filtering-correlation-id: 9ed1e9ca-fc91-441b-d3f9-08dbdf6b9cd9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 37RKtNbzdQ0jE7xlzJiZW+cW/ePOZKUylja+4s9sKC8KBY6Dppyoy2IbSfRgwL+dviJm4aQz+O2Ms2dZvalNJdirfJLMQ4Cxcce5WKP5p6oSmzQT9gCTB5NnHay9DjYSnYvwEyZPm3lOLILf1ZVSP7SBjUcDh5MuXgZLnq51UaJ2xPqwhz3ydoqMKawhQSD3TznMmi4e09Bt6gad1pIIdDTwzr/AAFsm38R5zekjNkcqAeKCt8zOaE5wHAjeexXSDUqU0cqnx9l+CygvwT0mkoPbm7dpnn5R8wODSs4K+O4jFxq4IslJyBloKnq4VlXaDEsqP0wSDFK9erVVIpbpDQN6ymzxRfsEUsHdrOQUK1toUYHgk8KvnOr8vcRbTfEbGIfLLbyhYIcJIphER3BeDcL2QhrEKDwd5avDMMQll+y7C79c22NpkIIirY5gKTsmfaO4Gj+otIKIw+rmA8aKVk/XQC+nvtbrrLE7giFtdUAeb2N2UAtrNMHU2SwBYGMSL89ScUNPRD5YKflF/+IppTjF4cLwEUZhEm4giG5qQbnjNP2mtj3IwK7QNEm2ib01UqEnPHVMucjOeJijAX6becRenko6H9fBXZZt9t2RZC757c6v0IBnJEbY8QNIU2jx
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(376002)(136003)(346002)(39860400002)(366004)(230922051799003)(64100799003)(186009)(1800799009)(451199024)(66899024)(38100700002)(86362001)(5660300002)(41300700001)(15650500001)(2906002)(38070700009)(33656002)(82960400001)(122000001)(478600001)(83380400001)(9686003)(66946007)(26005)(76116006)(66476007)(316002)(6916009)(64756008)(66446008)(54906003)(66556008)(7696005)(71200400001)(6506007)(55016003)(8936002)(4326008)(8676002)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?QhRQtUmqvDZX2ONzMuf4Ix3pwY5FOAq2Ld7WWYYxC+LRrXdIZjiQoay1APZw?=
 =?us-ascii?Q?FGb9EDX5hRStKAYd/sNA4PGMQVAJ2SfSYxGtIZNElD0Ylr8yYeRYHzNRywJi?=
 =?us-ascii?Q?j42fFRq8l60OUZeZ3hYY0gQVPBrvYfN7N6gjp/ncL6pqDDVSrslU8uNU8GLT?=
 =?us-ascii?Q?DHeZzWnXxBj8YDD9mHboRqG2xbmFaPPqYSy9hSH4NzemWlEOVCNAGP3HVM14?=
 =?us-ascii?Q?i6WyTz9C/FqbtkmE2bhLHQpZ25B7HoSKMfF+qeRuznW2UhD6xmmKH7pcUYFn?=
 =?us-ascii?Q?O31f9FqXxx+qdaOK+AQtognt8uD6nbvIUDm8vEZI/jFHFNPRTnveVc5knbTe?=
 =?us-ascii?Q?JJ09Loet7ybNVbD9L7k1FWBzVbJ9baxTAGRzLGMqI8aWnaS4hCSJftjI2v6/?=
 =?us-ascii?Q?ejonpkmIOYUNkZbhlifB+W7MfmFKgoIXplMIILY2nSvXf9totvx72HVVRbzi?=
 =?us-ascii?Q?Rw1PzvFBsSwSMHed8D5PxKwCTpDyKa8d5r/AGnJSq1QPS02KWbmjyOZ6VlYl?=
 =?us-ascii?Q?ocCxZj4iof9LMgESwoW1gzV9PrAlt87F9uh74JxYhuPZ+/EW+30y28pkT3lU?=
 =?us-ascii?Q?pci6RtaFtSqN98/a3ZL5QphFWCU2eNbe0gzfpA5Od6XDNgSpASfxft1GAnt3?=
 =?us-ascii?Q?K/KT9YVcbDB28qNqMCPuNR8FZ5aWAcCiBL8ChE1tIWhFwUsDBok34xdC2Dzy?=
 =?us-ascii?Q?VCbA9ZRDwbVgZwQDjhuzAGnjt/aHNywk4a2nKFXWULkbIoYZaCCDDD8zW7b4?=
 =?us-ascii?Q?2uPS+FTNdbuEUD7kyfjvEwz+DD+ykf8Ykh4bZXxcVoEKg+94Lx1EE8hdPDux?=
 =?us-ascii?Q?u8Q8qlFUDyOx00bs3KjcunkMR28tFPS+fe+WGZn7zXKoyAXN8mbGNvcXWaSk?=
 =?us-ascii?Q?TYPObo91Qzqef/ErCJztCeSR1ZXyVJKa6CvE5VCMN1Wl0wCvAbHTJfHvkTPQ?=
 =?us-ascii?Q?OK4W3nJFG5O+o7YBgSjhTF50bLUk7VKisY4AeiQ1q4qQ8o7/3yPj9oyhGBdE?=
 =?us-ascii?Q?a1R5Kdss+NqZyhdK39D98Av8NTKckonTywcl800s+3gspV+rKb/YAvZ0VfFr?=
 =?us-ascii?Q?Y4ZSuio66U2uoD+fzvoHGKOdLJ0iLwtVq/IVE4YhgUhNptvi0RFPgmhSftbl?=
 =?us-ascii?Q?x7gv3RkXFQlhR8IKkMZ1AAufN11986+a+dHnvi8pJGz1PZYPPBNl0BaVxNaF?=
 =?us-ascii?Q?zzCumrTZ2Ox8ciJ4mEeRKzjpxZd1SzzG09qpimeA6G+7IWpsgLVrqzV26koE?=
 =?us-ascii?Q?FsKKOHW1cRTrXfDLZDgJbWvHgaD2x+OokCNqZAFOd4J7XTkGs4aKWlnCD+IB?=
 =?us-ascii?Q?1EiJbD6/U+qoaS8VWPECJbFMIFtD1+e/cWCvre20D3wyCiDIiB+nKCIxDT5o?=
 =?us-ascii?Q?2sYLlmj+GPRvFhXjfFXiuA4NXryutLQkGAhMtc51g1XXvUeGRNqXFzqDP4DE?=
 =?us-ascii?Q?nAwAswDqGbTc2yOAy2Gev5to5ZwYkYYFP48+xF1mhrGjfZ6fPO2OC93b0f72?=
 =?us-ascii?Q?lfjaswceGHCXBCLWWzuN3GvliqxwzblMHAphTGE4qKxBpj5NOUoYk5JBR8TA?=
 =?us-ascii?Q?h7Xec9K996RLRCJ/cgFqj36pkanlY0woyRXrDlfO?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ed1e9ca-fc91-441b-d3f9-08dbdf6b9cd9
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Nov 2023 08:29:08.8458
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lcHqDE+pR8O/H1JmOPGcG0mwZS/wK9Rr/EYpcbSObhRJK01eDCB3PLSH6823XvaKrrSjpGtVn8Pl69LIX0WRGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5460
X-OriginatorOrg: intel.com

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Friday, November 3, 2023 11:51 PM
>=20
> On Fri, 3 Nov 2023 07:23:13 +0000
> "Tian, Kevin" <kevin.tian@intel.com> wrote:
>=20
> > > From: Alex Williamson <alex.williamson@redhat.com>
> > > Sent: Friday, November 3, 2023 5:14 AM
> > >
> > > On Thu, 2 Nov 2023 03:14:09 +0000
> > > "Tian, Kevin" <kevin.tian@intel.com> wrote:
> > >
> > > > > From: Tian, Kevin
> > > > > Sent: Thursday, November 2, 2023 10:52 AM
> > > > >
> > > > > >
> > > > > > Without an in-tree user of this code, we're just chopping up co=
de for
> > > > > > no real purpose.  There's no reason that a variant driver requi=
ring
> IMS
> > > > > > couldn't initially implement their own SET_IRQS ioctl.  Doing t=
hat
> > > > >
> > > > > this is an interesting idea. We haven't seen a real usage which w=
ants
> > > > > such MSI emulation on IMS for variant drivers. but if the code is
> > > > > simple enough to demonstrate the 1st user of IMS it might not be
> > > > > a bad choice. There are additional trap-emulation required in the
> > > > > device MMIO bar (mostly copying MSI permission entry which
> contains
> > > > > PASID info to the corresponding IMS entry). At a glance that area
> > > > > is 4k-aligned so should be doable.
> > > > >
> > > >
> > > > misread the spec. the MSI-X permission table which provides
> > > > auxiliary data to MSI-X table is not 4k-aligned. It sits in the 1st
> > > > 4k page together with many other registers. emulation of them
> > > > could be simple with a native read/write handler but not sure
> > > > whether any of them may sit in a hot path to affect perf due to
> > > > trap...
> > >
> > > I'm not sure if you're referring to a specific device spec or the PCI
> > > spec, but the PCI spec has long included an implementation note
> > > suggesting alignment of the MSI-X vector table and pba and separation
> > > from CSRs, and I see this is now even more strongly worded in the 6.0
> > > spec.
> > >
> > > Note though that for QEMU, these are emulated in the VMM and not
> > > written through to the device.  The result of writes to the vector
> > > table in the VMM are translated to vector use/unuse operations, which
> > > we see at the kernel level through SET_IRQS ioctl calls.  Are you
> > > expecting to get PASID information written by the guest through the
> > > emulated vector table?  That would entail something more than a simpl=
e
> > > IMS backend to MSI-X frontend.  Thanks,
> > >
> >
> > I was referring to IDXD device spec. Basically it allows a process to
> > submit a descriptor which contains a completion interrupt handle.
> > The handle is the index of a MSI-X entry or IMS entry allocated by
> > the idxd driver. To mark the association between application and
> > related handles the driver records the PASID of the application
> > in an auxiliary structure for MSI-X (called MSI-X permission table)
> > or directly in the IMS entry. This additional info includes whether
> > an MSI-X/IMS entry has PASID enabled and if yes what is the PASID
> > value to be checked against the descriptor.
> >
> > As you said virtualizing MSI-X table itself is via SET_IRQS and it's
> > 4k aligned. Then we also need to capture guest updates to the MSI-X
> > permission table and copy the PASID information into the
> > corresponding IMS entry when using the IMS backend. It's MSI-X
> > permission table not 4k aligned then trapping it will affect adjacent
> > registers.
> >
> > My quick check in idxd spec doesn't reveal an real impact in perf
> > critical path. Most registers are configuration/control registers
> > accessed at driver init time and a few interrupt registers related
> > to errors or administrative purpose.
>=20
> Right, it looks like you'll need to trap writes to the MSI-X
> Permissions Table via a sparse mmap capability to avoid assumptions
> whether it lives on the same page as the MSI-X vector table or PBA.
> Ideally the hardware folks have considered this to avoid any conflict
> with latency sensitive registers.
>=20
> The variant driver would use this for collecting the meta data relative
> to the IMS interrupt, but this is all tangential to whether we
> preemptively slice up vfio-pci-core's SET_IRQS ioctl or the iDXD driver
> implements its own.

Agree

>=20
> And just to be clear, I don't expect the iDXD variant driver to go to
> extraordinary lengths to duplicate the core ioctl, we can certainly
> refactor and export things where it makes sense, but I think it likely
> makes more sense for the variant driver to implement the shell of the
> ioctl rather than trying to multiplex the entire core ioctl with an ops
> structure that's so intimately tied to the core implementation and
> focused only on the MSI-X code paths.  Thanks,
>=20

btw I'll let Reinette to decide whether she wants to implement such
a variant driver or waits until idxd siov driver is ready to demonstrate
the usage. One concern with the variant driver approach is lacking
of a real-world usage (e.g. what IMS brings when guest only wants
MSI-X on an assigned PF). Though it may provide a shorter path
to enable the IMS backend support, also comes with the long-term
maintenance burden.

