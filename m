Return-Path: <kvm+bounces-10256-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 54DF686B108
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 14:57:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 785A21C22FB6
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 13:57:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DD0215531E;
	Wed, 28 Feb 2024 13:57:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eB4qPhxC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9192B14F96D;
	Wed, 28 Feb 2024 13:57:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709128635; cv=fail; b=f/3QcWrYS9Y6WSn3dGgc4htMESBNbrS/1OzhUf464/syMmbBDbnrHYR02fyuOq0hL+zqECDFXmoYaUlW1XjLsM2hGRKozucUYGGT9qc89xUcdPgKqjF3ZXIUS8fwl6VDCHulM9oYYpS174th2sKG0EKi94+YDwrn67rZXh1ovws=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709128635; c=relaxed/simple;
	bh=uIN5KfE4fqfx+UHZ9KdDLoIt2McwA3Dk1z+4U0c+kxY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=VYPIhWPXBJfxuUmf9ka3z1tbFCED/Gmf93GKEEKztG29FHYKrdVf/Z4LoyBi1SaL8XdSa9KaHxM3xLCcCSe+HgPb2wCAR7sue6NlIQBtBd4xjU3BlI8DI+4kXJ3dhSz21vDJiGillJc/0Vju0aJAVRKBu0g4R7+7MkdO07HUvuc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eB4qPhxC; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709128634; x=1740664634;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=uIN5KfE4fqfx+UHZ9KdDLoIt2McwA3Dk1z+4U0c+kxY=;
  b=eB4qPhxC2YE/kyA/oiPR7e4/HdnXaodp3GvmHLqtiYwJdqoG8CNPiVV8
   M9u1dLLUrdlGJDazOohOb6EsJM/43XofxHks7axel1SprU/OZrjf1U1lK
   WgAS0/HNEKGOxtr1oVX0zMoKXqS/ygw8VNMX9JkHF/v6UqPyk1M1LS4mP
   IpEEzRr08pC/+tupuO5F4hLZLY4zAR7XOlEWOLO2+lKJpNqogysjRhCub
   4QTSTkIN4gHAkacmJ0gsSpis3qY6h3GG8EL0/h0AQH+Z1pHxxaE+h6XQW
   RRLVkrzjj1MNR0c8gtKD8p+6z23b2TMKaB2kfkHP/SkZyjm8JISLvN5lI
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10996"; a="3390597"
X-IronPort-AV: E=Sophos;i="6.06,190,1705392000"; 
   d="scan'208";a="3390597"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2024 05:57:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,190,1705392000"; 
   d="scan'208";a="7376345"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa009.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 28 Feb 2024 05:57:12 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 28 Feb 2024 05:57:12 -0800
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 28 Feb 2024 05:57:11 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 28 Feb 2024 05:57:11 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 28 Feb 2024 05:57:11 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OOqf+oUm40SHrHxRwxqIzLtq2yL1Dd8rRjQgahiOxC8B0cOf224BzwsnlpgzEuXoS6aYboKyb9gCRIm4tInomTe8Dlnv3Ec3Sm1aKSZDPXgQ2HOlmNcsR2vMdyqez5FHwNWONb2+MIjjZo9ub0V2EM9GoBzptInmyaNJOMwRrqKn3V9xMRs3Gvn2YWVLsc3DiB23ZUdo2uKDvS7VvyWOo6E6VA9D+niRywwrdbsG532BFhPqB0SRft3fGFLIg3kSuqMCqpVbIplMQBM/8epUcAm91xcGDLNA/jy0dR5WuGtgQuEOV1bivJucyXFKiJTbGaFRRNUGFXwyTUlmaW13iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HIuRMQ2lCHsqpjGQzdyxfyYi6xguvre2o5ngGxHL8mA=;
 b=VCrgxyIqCebY7gDT43sbAdozvr+8mWg1DjgXsWWmltqrWx9VMTelj7mYObSRC6/ySqsybRgI+04q6yhRt0xonG2dxkYgicRQreBN4CFxF3UMG/e7ICatoqC2U3/YwCYnSHIPzsoBcHOor8jfdUo8MEvXCXCe6XKtMlEFOgEYvwg4YES4covgzIrxUeAjb+f1gaBEVMaWfSt+Hz+WOPc9TkiJ4RLRtOOzb4OqpYsWn6C8tESb0l0Pv8Bc8caiTq7slcH6cjSYFLTXrwHSLpS8lZg96wWhQgZgvDNUManR01l/bV9iVWD9Xo6UvScOjTMjXKqGIjCszBCNKHIWvoeVyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM4PR11MB5502.namprd11.prod.outlook.com (2603:10b6:5:39e::23)
 by SJ0PR11MB4927.namprd11.prod.outlook.com (2603:10b6:a03:2d6::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7339.24; Wed, 28 Feb
 2024 13:57:09 +0000
Received: from DM4PR11MB5502.namprd11.prod.outlook.com
 ([fe80::3487:7a1:bef5:979e]) by DM4PR11MB5502.namprd11.prod.outlook.com
 ([fe80::3487:7a1:bef5:979e%7]) with mapi id 15.20.7362.010; Wed, 28 Feb 2024
 13:57:08 +0000
From: "Zeng, Xin" <xin.zeng@intel.com>
To: Alex Williamson <alex.williamson@redhat.com>, "jgg@nvidia.com"
	<jgg@nvidia.com>
CC: "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"yishaih@nvidia.com" <yishaih@nvidia.com>,
	"shameerali.kolothum.thodi@huawei.com"
	<shameerali.kolothum.thodi@huawei.com>, "Tian, Kevin" <kevin.tian@intel.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, qat-linux <qat-linux@intel.com>,
	"Cao, Yahui" <yahui.cao@intel.com>
Subject: RE: [PATCH v3 10/10] vfio/qat: Add vfio_pci driver for Intel QAT VF
 devices
Thread-Topic: [PATCH v3 10/10] vfio/qat: Add vfio_pci driver for Intel QAT VF
 devices
Thread-Index: AQHaZN7uGaDln+Lw/0+91W8o27GvhrEdAR0AgALB7iA=
Date: Wed, 28 Feb 2024 13:57:08 +0000
Message-ID: <DM4PR11MB5502450A52C4BE0E0465B76088582@DM4PR11MB5502.namprd11.prod.outlook.com>
References: <20240221155008.960369-1-xin.zeng@intel.com>
 <20240221155008.960369-11-xin.zeng@intel.com>
 <20240226115556.3f494157.alex.williamson@redhat.com>
In-Reply-To: <20240226115556.3f494157.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM4PR11MB5502:EE_|SJ0PR11MB4927:EE_
x-ms-office365-filtering-correlation-id: 6115ffe2-4c4f-48d1-67e0-08dc386527b4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DVi+i21IV/HUth2ymfbFuGZd5+9N4xv7ZQfXxaOPq6NZmrWeOVxydSfGtuPGOTs7kleJnh2KAn/YSsyQTC/RJgypcK/HCUC5N5Hph/rNK1AUM+49hwyg9hxeofMpfm4J9VTiF+xkczx+z0QYG9LF5MEJqBoFI/qdHlll6hGrzoFVrEUoZLli3LQ++Sjc+/dVrTIutKNNeBYT+PNg5AztN6iK8QU2gvaaINPkqz/wx/iw1L6NueD20dkrBsNuoVCoRxRBKFWIvaAyVxG0dKGTX0sysAMnP9lemNx6Ugk3ghNopP2/et4F6kpDjeb+dSThP0uyObLeQTMCsJHPOAI//lQDpqM3tAp20mMqcGUtHLe0l/CGm0IsAcM8vK2zKmCyE2NsDLlrboVj8kDRTZxjj65nppxbE4j58LvJUMmIzCLe+fR63SJnPWT2A0esmm2FU85ZCXolgsvEG9avwm7FaZMkbfvPPX46OXImXD1sXoROy5c9UkIVtQwSu9+g1evAO6urNfAKFvJX20cKjY5CyiHQiULdICPchSnPLevn9+MgSlLmnuDV6LJIApl6ZnWugNNScNlcE2JVq4NQOT/FOo+lMuSy1EoQVKDJWOYMEfq58fL3r01c9hZrKEUiJhVXj1IXWIpJWDE32oK6a1eCul7neJZDVj9+FjWuqYo9nGpBb9JR/xBHKVR/h2+AVsNVWP7yxr4HopCB86azUKkJyaSyF8IrheZAAz2lXP+vAIk=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5502.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?9QVBTBF9qI6bqkkICaeV6iehXGIrgVZ2Fc3hSW35eR2JuJdlisXcuS+pHRgF?=
 =?us-ascii?Q?FD4DKa+Qz6NfV4s/PCXTMOcn00DIT6mtsMks7FQpMktvrVNR/NxhiOCbDhqY?=
 =?us-ascii?Q?y/1NojpguoWJvwciTtdGuPpn9gnQO4QC9d4Y5ygjoXHUOPFicy/7zW1Yu9ZN?=
 =?us-ascii?Q?TTEuTTrHFasr6A/lu3OA/D2ziSR3WbQbJAC0BuCxpPBGD/Z4ISIqNlguZhLp?=
 =?us-ascii?Q?4FUa5EmUoAw800GBVtZFijatOsEkRDgx+s5IMWOcFi9xcPY0c2J1OxFGhjHB?=
 =?us-ascii?Q?IgXAoU5J/m0QfT11ay4Ihwpdms0ZNauION/vXK2SwJjypYjJCcGFXlmKbrsb?=
 =?us-ascii?Q?Tn/WSsTJ7qP6UeVcsbomnwCo6C65Zp+BdgpugigjhFp/5s6jgm8I/tUKe04D?=
 =?us-ascii?Q?RT/WtQmvoB2o4SV6XgXHIvezurlbraJ7GpBMls2b/DcoUKq2tI1wA9CJGRWy?=
 =?us-ascii?Q?BnDh99FGU52kHWoUbAunv92JEtlOAvMF5fgNyu6TStWPdgE1N/KK4De6ain/?=
 =?us-ascii?Q?LZpRr6lmIQqxX6YDis5+gZZYPAJOqjKnZ4frNnd57qsP7h1iPBkGwubxvEzo?=
 =?us-ascii?Q?43EvyTHe1tex3G1i7LKijodZUjvGdWwbp5eIp1CZn1duph35ceY4QtUqlH3H?=
 =?us-ascii?Q?bwyIwoRbdYQD0zxNEo6vapd84k1WUceLfigpglfipahTBnERmMheAIqYstyJ?=
 =?us-ascii?Q?IxiJLEBS5DYS3k/HI6JLlCQrCTfzcQPa55ZCVZtZ8wmYAfGRMIpWJF0yyE4V?=
 =?us-ascii?Q?wzTU0lEIdILOQrN+EnMy+wLafxklUA4m1+v69V5NuZlLDQhQe7dG4ntNuBZS?=
 =?us-ascii?Q?V5IhuoWI4+5aLBWErmu0+m/fyaDGQZtXrz3IdKXiLF2S6YoFgHYHiBFsK/rY?=
 =?us-ascii?Q?lQYFcUTbv/f2kKz/HSAxCBb3U3zQ6Em4/OIj8y3qrKhjyKcHz+q0F4GcJyYg?=
 =?us-ascii?Q?sVlSBTrCwU0Jo7issUCKyvvqb6XAM1zZcOXTmKu6OCmJyIhfd3bmVVRmZBmk?=
 =?us-ascii?Q?uKMNmIJojbXctYzKfhLZ0qaXX5VjgsRP+Whz3Ls+nDNfwPrOGXmtbfKY5c0X?=
 =?us-ascii?Q?B8dZc1Co1YsozkRI9HdSg2EZ4katJ4P/vXMYPYso42zv2uyoD9lAA51TGHob?=
 =?us-ascii?Q?v8ih0m4Aqkq+RC8ZZE8PwF08UtX+Bjo63hmO6u9rQAG5WhAl4FMap9EcymLY?=
 =?us-ascii?Q?R26aRuujQHeYMUoOrl/E41vctZKjeDTIx9q5ZHkXjagNokjN2OayCBbHG8Yk?=
 =?us-ascii?Q?Ujvo09yt+zBwa6hipnx3kQZHsx6Ds2Uvj4bU71SwbKCoXPE0CJYbK3wwRU6H?=
 =?us-ascii?Q?Byjwzshxx62x3MGioT3JmueS3r2Rw31SEdcnf/EhNBG9e0bbVZKRcbwd6HY5?=
 =?us-ascii?Q?Fmk61wlz7Ja+DK4Dkv9IztZbiSy+Zg7fqAtGI+rbA5/MKSXLmhxKFYokxzMQ?=
 =?us-ascii?Q?Qu53z3/613v9aSY3SOX0CYWlt/zybA1zHHjlQ6WoeWFytqKdo9xzFXxy0W4x?=
 =?us-ascii?Q?2dNB/CKSAAgvRVW82bRKxg58+vS4WXEsNof+gbSvaiTUI48/P6Vs2okoQmYh?=
 =?us-ascii?Q?X5jo48hAIHeiDX6R0vk=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 6115ffe2-4c4f-48d1-67e0-08dc386527b4
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Feb 2024 13:57:08.8595
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: W6YZeoSSwHUewzkpa7rpqMspt5Z2o7vXT323GDCiQej4x+F2mYdebwSXvq8G/Coi7Bx5S/u+UmH08nxwdofXVQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4927
X-OriginatorOrg: intel.com

On Tuesday, February 27, 2024 2:56 AM, Alex Williamson <alex.williamson@red=
hat.com> wrote:
> On Wed, 21 Feb 2024 23:50:08 +0800
> Xin Zeng <xin.zeng@intel.com> wrote:
>=20
> >  MAINTAINERS                         |   8 +
> >  drivers/vfio/pci/Kconfig            |   2 +
> >  drivers/vfio/pci/Makefile           |   2 +
> >  drivers/vfio/pci/intel/qat/Kconfig  |  12 +
> >  drivers/vfio/pci/intel/qat/Makefile |   3 +
> >  drivers/vfio/pci/intel/qat/main.c   | 663 ++++++++++++++++++++++++++++
> >  6 files changed, 690 insertions(+)
> >  create mode 100644 drivers/vfio/pci/intel/qat/Kconfig
> >  create mode 100644 drivers/vfio/pci/intel/qat/Makefile
> >  create mode 100644 drivers/vfio/pci/intel/qat/main.c
> >
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index 5a4051996f1e..8961c7033b31 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -23099,6 +23099,14 @@ S:	Maintained
> >  F:
> 	Documentation/networking/device_drivers/ethernet/amd/pds_vfio_pci
> .rst
> >  F:	drivers/vfio/pci/pds/
> >
> > +VFIO QAT PCI DRIVER
> > +M:	Xin Zeng <xin.zeng@intel.com>
> > +M:	Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> > +L:	kvm@vger.kernel.org
> > +L:	qat-linux@intel.com
> > +S:	Supported
> > +F:	drivers/vfio/pci/intel/qat/
> > +
>=20
> Alphabetical please.

Sure, will update it in next version.

>=20
> >  VFIO PLATFORM DRIVER
> >  M:	Eric Auger <eric.auger@redhat.com>
> >  L:	kvm@vger.kernel.org
> > diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
> > index 18c397df566d..329d25c53274 100644
> > --- a/drivers/vfio/pci/Kconfig
> > +++ b/drivers/vfio/pci/Kconfig
> > @@ -67,4 +67,6 @@ source "drivers/vfio/pci/pds/Kconfig"
> >
> >  source "drivers/vfio/pci/virtio/Kconfig"
> >
> > +source "drivers/vfio/pci/intel/qat/Kconfig"
>=20
> This will be the first intel vfio-pci variant driver, I don't think we
> need an intel sub-directory just yet.
>=20

Ok, will update it.

> Tangentially, I think an issue we're running into with
> PCI_DRIVER_OVERRIDE_DEVICE_VFIO is that we require driver_override to
> bind the device and therefore the id_table becomes little more than a
> suggestion.  Our QE is already asking, for example, if they should use
> mlx5-vfio-pci for all mlx5 compatible devices.
>=20
> I wonder if all vfio-pci variant drivers that specify an id_table
> shouldn't include in their probe function:
>=20
> 	if (!pci_match_id(pdev, id)) {
> 		pci_info(pdev, "Incompatible device, disallowing
> driver_override\n");
> 		return -ENODEV;
> 	}
>=20

Ok, make sense. According to the late discuss, I will include it in
next version.

> (And yes, I see the irony that vfio introduced driver_override and
> we've created variant drivers that require driver_override and now we
> want to prevent driver_overrides)
>=20
> Jason, are you seeing any of this as well and do you have a better
> suggestion how we might address the issue?  Thanks,
>=20
> Alex


