Return-Path: <kvm+bounces-9292-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8DD0E85D2C2
	for <lists+kvm@lfdr.de>; Wed, 21 Feb 2024 09:44:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 036331F22B3A
	for <lists+kvm@lfdr.de>; Wed, 21 Feb 2024 08:44:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 061093CF40;
	Wed, 21 Feb 2024 08:44:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="j4XQyt99"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAABA3C6A4;
	Wed, 21 Feb 2024 08:44:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708505078; cv=fail; b=lb1pkw+tl2py8ByIXzVEJiimsW5ZT7lnYh91NYJfxjHjC7V+4uVyIj+DdXyTEos83RdRbTJS9U4qamkUmUFUfWx+p5Cij9ZeuSdMUcybPBSmKiKieYijxwDqUBc88zuI+BSxBAkFYO3w8P14vMTWMbP4dfV9vkI2FmMVeY+6OD8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708505078; c=relaxed/simple;
	bh=2L2XnyXvLBXGvmqL9Br+jsDpNqLL2e0paCdCAJ5PPPA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=SQ/wOl9JTHofYI1rHeuX2FxNTFgFIVEK6wAkkyCvxuwqgVcyhahnG6GiqEHPmdZocC9pAVMqLBVukRcV/LudUT8erMWNj5xFmnJ6/QlCD9pxkucwiD16W/D0ib7NEcXVKc20kdzKoBgof7qp9c2K+6OQFmVDkvL2hrXuZIqgktg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=j4XQyt99; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708505076; x=1740041076;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=2L2XnyXvLBXGvmqL9Br+jsDpNqLL2e0paCdCAJ5PPPA=;
  b=j4XQyt992jLsGnDKG+uAS2jRViDUbzYjpQldluTncNjU7xVKgJYRV+Lr
   S7WcFFMgXOkXrvI9mrWI7Aw9swMw7KkaETZHwtpb1M1LbGxdI69A5Dif0
   EVaPaaKKXsfoBiDJp3SDUu7o7uemEgLE9A9EF2d1aiXBbjoLgkTtHjvwV
   MnXKuD9JwIj4n0cGp/GCGe8bo76NIYHTnyFy1yUXhKS71SV+2bRTwoib9
   dnv4tzEmA0zdFbvOcE5/N+5NZafI4CapMJhrj6z7FVyt+fll9ghj1As7S
   B3A1RHBKPns9/xW70+d63GzWj3Rwcyk8hj9ndF8NDErmLYXAg+ES8amxK
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10990"; a="20193040"
X-IronPort-AV: E=Sophos;i="6.06,175,1705392000"; 
   d="scan'208";a="20193040"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2024 00:44:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,175,1705392000"; 
   d="scan'208";a="9705261"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 21 Feb 2024 00:44:35 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 21 Feb 2024 00:44:33 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 21 Feb 2024 00:44:33 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.101)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 21 Feb 2024 00:44:33 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dD6pz3JY5zl5SBrBaroWc/PQgj4r9TJp/BMjbhalDa5KCTkiQ3wbixwiB1n2Xf2oNy50D7fifPYNobnRe1IznmadGkB2VB19mh5LRPOBbL0lI08Ln1WGw6UK6rmYpU69UBBjXEtwUX6/NSlPZhbMZH16DEvjeNnTzcvAxEtKFyGldzkmQqRln63GEBSy5Gk3fK+wZw8Dpa9mn1WT9ed1AmnDeIiP0BUw0jy8TQi9qG4NwsX6eBqhAvEUvtjyAOz336bY7eq1JGUmti5ci0Gf85z8rzFasVDr9pE7UgrJvJ7vN0aWIxP7OQd4PqdNS7cFxjybYBZyBRXpdMWMNWQfwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XNe4jSprJdXc657n+ngehqnRzgo3FmIAaNuxCEkHkv0=;
 b=OW+e2vDjdtMS49GKUv8WwvcKaYs9q5Nne4sh3FLf7kqFbpJk/8785Je1OaNTUeGTdjTWfanbNfabb0nPweVJXixmzjpmtne+2CNsggw8sHC+sybrepEUSzE5O3PDr+Y9eV+O9THs2vstjKsUNAE0gUZwOiUMVl+Wuksg4IlJ0W8LcHCxfJCl3WDVRS/88+15BbI00e5ITcqc8RWBDJf3FJT8Xxixs1GmDydgEtVAMc6ee8pgA/mkKMqVKa8dmwOjeaCjhUtLovNmFXKiN/nHqcFei6eDOmiarDCfvhDKU2BcFp9QEE6Wf6ZbXrYlwPEgqabegnCEl/F6nX9ugA00uw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM4PR11MB5502.namprd11.prod.outlook.com (2603:10b6:5:39e::23)
 by SJ1PR11MB6132.namprd11.prod.outlook.com (2603:10b6:a03:45d::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.39; Wed, 21 Feb
 2024 08:44:31 +0000
Received: from DM4PR11MB5502.namprd11.prod.outlook.com
 ([fe80::502d:eb38:b486:eef0]) by DM4PR11MB5502.namprd11.prod.outlook.com
 ([fe80::502d:eb38:b486:eef0%4]) with mapi id 15.20.7292.036; Wed, 21 Feb 2024
 08:44:31 +0000
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
Thread-Index: AQHaVSVFJ9K0TVMQD0C9btTtb+JmirD9TRgAgAQ3vqCAAHLkgIAC42sAgAhyjxCABghogIAADukQgAAuE4CAAQBLIA==
Date: Wed, 21 Feb 2024 08:44:31 +0000
Message-ID: <DM4PR11MB550223E2A68FA6A95970873888572@DM4PR11MB5502.namprd11.prod.outlook.com>
References: <20240201153337.4033490-1-xin.zeng@intel.com>
 <20240201153337.4033490-11-xin.zeng@intel.com>
 <20240206125500.GC10476@nvidia.com>
 <DM4PR11MB550222F7A5454DF9DBEE7FEC884B2@DM4PR11MB5502.namprd11.prod.outlook.com>
 <20240209121045.GP10476@nvidia.com>
 <e740d9ec-6783-4777-b984-98262566974c@nvidia.com>
 <DM4PR11MB550274B713F6AE416CDF7FDB88532@DM4PR11MB5502.namprd11.prod.outlook.com>
 <20240220132459.GM13330@nvidia.com>
 <DM4PR11MB5502BE3CC8BD098584F31E8D88502@DM4PR11MB5502.namprd11.prod.outlook.com>
 <20240220170315.GO13330@nvidia.com>
In-Reply-To: <20240220170315.GO13330@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM4PR11MB5502:EE_|SJ1PR11MB6132:EE_
x-ms-office365-filtering-correlation-id: a4b77399-5800-4f99-7930-08dc32b9526b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1pfjhTGZIPcyC54XMV2pNrL4630amzM6bmQ1e7PbafmgUaQtv7C0rr2c8Hzx3DiVzaUWaj+Dr4xK7qwbgRaXwlgFHcndE/KPQOeoAXU8skbXCigK8XQ67dB961UiUAagwvG4GsA9NSxBxoAgvXROoovHFT0uwvXhK5YBnSc0L0Vy8NhOd/Firw4dGB/Wpbrq9O6D61xEzj3HbwDOFZyeymX7n962HwhvvbcF4twWAjSJvKqbeL1dI5/e0OxSWsqyfcEIUXsTzNNRUc6a1cOO6DnJzcx1wbCp+dgHHa6iyVwOE/jepuTASoxntsIEZxPmA+ToLcsuoJi5J59acZtVysy7k5YMuP2CHCrkcPorw22vDYCRWwSB0zBDt4FI5a03b6TkXbV3W6vnSx6ByvKj6Uf5nHOpTRO7Bhfgah+YRG12dqt5kvplk7RhFQBBF7AEta5V+X3KYCoGy7eqzdEX4z9FF0QbRsA0Pr5Cz6iAVxxVpJUd5hSpq7M5XrP/oMnJG+F2aXj9EPfy6WNLghCqHV7hUjhSclz0ymw6cPtcvJGlmw7SfDZWdcyRb2RkUZ4xUXG/OU9PSGVvjzfp0AS6zwtjCpxf6Yoodl59M+CZiGgAcbYrPULYLlFC3KF/xz2y
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5502.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?m64YW1c09uUEESGSB2fPrREZAriQi3JB8p5PPWpFPoISwh6vI1rxQVi6f2DL?=
 =?us-ascii?Q?DfZb3gKNI2lKuUcYqCezLOegCCRDZLEfTPk+5F02ob0YSIdvTiRtdPjpcEGE?=
 =?us-ascii?Q?be5sTCq1uVtp29+dW9dptoJY39xaUFHnK+Di0FatZwKy3nOObr294daYJYAc?=
 =?us-ascii?Q?8zNcHzSzl1zPQwpSughW65WlJ1fE9nfePQqkqU3nhXoYNwJ1zPidiRr94YEl?=
 =?us-ascii?Q?F+lpUTOk/B3LQwFUDTON9GpIx19FrBz2p+/IcN0zcekn8SsMCueP7LABILFp?=
 =?us-ascii?Q?v9c45ozP8fEBN07wPobtw75p586iNiVAro4EUifrz9hd33OquAsaQrBq0WG0?=
 =?us-ascii?Q?w/X1sgZ+nVj5ruvsVlJ47JQphRNEZRU4vDLzG9rYQzLf7dAQGKpiweFctr/f?=
 =?us-ascii?Q?8YXL1pmGB+ND4Aqc0jFHM2D1vInwm5p9UcF1j8rP1n8hkcVfR+DtT3cHTL3U?=
 =?us-ascii?Q?kbsxYmgUsd0elGuodhRfMjdSRk2U3up/SNGYU6nkVwzDOhdG0Uotixv6v6Gt?=
 =?us-ascii?Q?aAwKNXIVoSUpjAGLzZFdOz801lJmY+w408QNb1uN69LxL5jnmh3Zr+cNT7cr?=
 =?us-ascii?Q?yNbj5darbNcmiHu7n1DrJKuctjV3SoVrVKtqDRHG7fGnEjCcvjoW+/5bHM+Q?=
 =?us-ascii?Q?GtkXgNy7noQzSdVAr6rBWc9MWu319HxToGzvcuZng6mzKABqZnAlMN3w4Y4z?=
 =?us-ascii?Q?C3rH8h5ntm9bCWx8z/Rri4mACBS6f8w+HNdhlpSZ5aZ/pRejajnwoM2nCZYz?=
 =?us-ascii?Q?6p5rV8SPS6zSv6z//eRI1sPcijkgMocx3NxtLtKUcQc59hMphztjx6p9iF1p?=
 =?us-ascii?Q?DKu9ZNgvC4YGLXD2V9OH+8/6GyFiGTOBTmNDeFFHIuuG6m6DjcUbEKtCDAJK?=
 =?us-ascii?Q?I/jDEAn2teRYlK78inIYfi/94u4usiEo090zit4ENq2SRvuYZCfuDXE1ACcv?=
 =?us-ascii?Q?UuI/fhQgZlpJvrp3I6MHEsL3nmnx9IDkILEmKEHIv8vDpStkbngzeIDKm4qT?=
 =?us-ascii?Q?iku28/I0TWtarqATaQai6GYChq8pG+guYPYH2fCRm+klz0PC7sScs1MJ4LW5?=
 =?us-ascii?Q?vkC6MJBri++VD95RL4fEYemVgG/H8rA6c7Dnwe9YBJSWmZoSDTXszfF3jrTK?=
 =?us-ascii?Q?FdsbdGaPicrEofPulgzVVaryR1s2cQfleyu9z6S31FU2sB99fEgpkAcTuTxY?=
 =?us-ascii?Q?CiAq+DWNOimVpMQdWl4Y7XCtXuEiEKMrcb6b5+lGAoIgPYzbqkSV6xahiVJm?=
 =?us-ascii?Q?VOUDERbASLFsHDOVaJSModmK61i5bgKKByIKRMq2O0tVvalvhyS7BbASEw5c?=
 =?us-ascii?Q?1Xjf+ezUi3ttXqpjtERkrU4PaX0BT8iWhIJ8QN+r00AHOJEOULB0Vp1hgg9k?=
 =?us-ascii?Q?6m/2GMVcaEWPWFijiTedfQSTsPS7fR4670vlDkbPYhVeFPOEmLQCULg8jLJC?=
 =?us-ascii?Q?eKdKLvAkX9XNL63VnuTde3c344DgVCX8d5OLUHcRpfTWf4nrRIU+CSj6JkzD?=
 =?us-ascii?Q?bQ+b+VqNfy+o5y5NTyu5Ov65uBzwzA75SukQ4x35MZdpjtFiulsUZoMVoMfe?=
 =?us-ascii?Q?8LlRBk9JlKFszR4KKsQbwmnm3vg8Q+y08WeyAt4m?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: a4b77399-5800-4f99-7930-08dc32b9526b
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Feb 2024 08:44:31.2783
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uc0nkSlR8BVMJHQSWMzEqKX1rE+y1HbE6qpGj44dJW32Nac7QB8Qq5MD+iyA774WRLDobygQha2w704PUmDOEg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR11MB6132
X-OriginatorOrg: intel.com

On Wednesday, February 21, 2024 1:03 AM, Jason Gunthorpe wrote:
> On Tue, Feb 20, 2024 at 03:53:08PM +0000, Zeng, Xin wrote:
> > On Tuesday, February 20, 2024 9:25 PM, Jason Gunthorpe wrote:
> > > To: Zeng, Xin <xin.zeng@intel.com>
> > > Cc: Yishai Hadas <yishaih@nvidia.com>; herbert@gondor.apana.org.au;
> > > alex.williamson@redhat.com; shameerali.kolothum.thodi@huawei.com;
> Tian,
> > > Kevin <kevin.tian@intel.com>; linux-crypto@vger.kernel.org;
> > > kvm@vger.kernel.org; qat-linux <qat-linux@intel.com>; Cao, Yahui
> > > <yahui.cao@intel.com>
> > > Subject: Re: [PATCH 10/10] vfio/qat: Add vfio_pci driver for Intel QA=
T VF
> devices
> > >
> > > On Sat, Feb 17, 2024 at 04:20:20PM +0000, Zeng, Xin wrote:
> > >
> > > > Thanks for this information, but this flow is not clear to me why i=
t
> > > > cause deadlock. From this flow, CPU0 is not waiting for any resourc=
e
> > > > held by CPU1, so after CPU0 releases mmap_lock, CPU1 can continue
> > > > to run. Am I missing something?
> > >
> > > At some point it was calling copy_to_user() under the state
> > > mutex. These days it doesn't.
> > >
> > > copy_to_user() would nest the mm_lock under the state mutex which is
> a
> > > locking inversion.
> > >
> > > So I wonder if we still have this problem now that the copy_to_user()
> > > is not under the mutex?
> >
> > In protocol v2, we still have the scenario in precopy_ioctl where
> copy_to_user is
> > called under state_mutex.
>=20
> Why? Does mlx5 do that? It looked Ok to me:
>=20
>         mlx5vf_state_mutex_unlock(mvdev);
>         if (copy_to_user((void __user *)arg, &info, minsz))
>                 return -EFAULT;

Indeed, thanks, Jason. BTW, is there any reason why was "deferred_reset" mo=
de
still implemented in mlx5 driver given this deadlock condition has been avo=
ided
with migration protocol v2 implementation.
Anyway, I'll use state_mutex directly instead of the "deferred_reset" mode =
in qat
variant driver and update it in next version soon, please help to review.
Thanks,
Xin


