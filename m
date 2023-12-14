Return-Path: <kvm+bounces-4432-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 24765812726
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 06:52:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A3643B20E36
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 05:52:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA7678836;
	Thu, 14 Dec 2023 05:52:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="d4FL69sW"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FD78BD
	for <kvm@vger.kernel.org>; Wed, 13 Dec 2023 21:52:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1702533145; x=1734069145;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=EgTf9gEDy6NnQ0lLIZiTnP8wYrpf4NDfEHg6s61/psY=;
  b=d4FL69sWsv1yXdndnqKvJyI5OGRKH05n3tj5Z/mNleQGqjP2mRre2Lbr
   VvCBYwtJ0Tojs+04fNbrQvkwG3jD/9EMbg7DbjZ5rV5brb0r+htgjxm0o
   e14au0bXycSGloNqB9LrtT81OQs/4EqDjjHcwYpU5DTAi7y+vV/k8agXJ
   SiauzbnKizmoYvK79Y35LhiNR9v/nmNpxIBL9A2W8RjInaUx3UTgT+B8s
   tE0my1AvCiny8gIGTWF6O81ocnN9xJ840IxpYvqble8pcQF+Ej6XxRymn
   2+gJ8cOF0fh94/niZY/wxvCn193ls/2Gu/C0T9HW3ae7n4hVe3cpoDSJ8
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10923"; a="2226339"
X-IronPort-AV: E=Sophos;i="6.04,274,1695711600"; 
   d="scan'208";a="2226339"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2023 21:52:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10923"; a="750398668"
X-IronPort-AV: E=Sophos;i="6.04,274,1695711600"; 
   d="scan'208";a="750398668"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga006.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 13 Dec 2023 21:52:24 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 13 Dec 2023 21:52:23 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 13 Dec 2023 21:52:23 -0800
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.40) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 13 Dec 2023 21:52:22 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gSZhWJIIAjqsl3PZp63e8FRYtyroI4wIWOiCfKdQWHePF+PGsKsZrhSB+yzcqUyc2lr2n821XSbyHjjRsy1VLysDldtJKFykxSWib0qg1hjEocvuCCbd0SPrVP/h/jg9hGmbWJGVhekPhFCn1DK0A2ShXqk3dc2+xvKM4fARuXIejii3DcxCvM2gfdfLc9HYZ0e0ZCd88Yi7M9+klh8HtCr4A3ITSQw0nSvd+6KJwHxlsK4ss1aqOrROtjMxiGxFKVZePdhJCXyKETF+RNqlWylI4Lky88qL9ocqQmXLlI0AFZbx/oRdyV4GuTTtm3oLmFotgLmUGbk0qjp4rbn4Ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XMJD4eghlyEHnkSUA+k4DNJLQCTz5jZo4yPL+JIItoE=;
 b=fG4iErVPUvm1bwn2vQ3QYxBgJbG564VMtrTRQbTJn8MHvF74dAKYeNIJ4+riO1p5rofSbxlCyyPal7KFY5lKYbDzx9q0KGNwVEtpPMMarcTfke1CiL7Naum6mPTfco6jVRIgMQrn5F0NnRvUJBy0ubjIiOka3FJHceQcacsPR0GIgWjQxU6AhqCnr+IovzOsjcJEQENuHS6hmPrX3gZKQI9QTWrRoHuycin/vNAwRLa0etQub1qUQaUdSsjmR9QdYNE5mtlmAxiQoFzZ8Z4Ouv/PHlhSiIZnaG5Cxzttkkb/6Y9fsP8kFJ9XGoeHK7Pf5jDpiRkSsg+vC5cVQBSzyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by CH0PR11MB5428.namprd11.prod.outlook.com (2603:10b6:610:d3::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.28; Thu, 14 Dec
 2023 05:52:15 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::e7a4:a757:2f2e:f96a]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::e7a4:a757:2f2e:f96a%3]) with mapi id 15.20.7091.028; Thu, 14 Dec 2023
 05:52:15 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Alex Williamson <alex.williamson@redhat.com>, Yishai Hadas
	<yishaih@nvidia.com>
CC: "jgg@nvidia.com" <jgg@nvidia.com>, "mst@redhat.com" <mst@redhat.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"virtualization@lists.linux-foundation.org"
	<virtualization@lists.linux-foundation.org>, "parav@nvidia.com"
	<parav@nvidia.com>, "feliu@nvidia.com" <feliu@nvidia.com>, "jiri@nvidia.com"
	<jiri@nvidia.com>, "joao.m.martins@oracle.com" <joao.m.martins@oracle.com>,
	"si-wei.liu@oracle.com" <si-wei.liu@oracle.com>, "leonro@nvidia.com"
	<leonro@nvidia.com>, "maorg@nvidia.com" <maorg@nvidia.com>,
	"jasowang@redhat.com" <jasowang@redhat.com>
Subject: RE: [PATCH V7 vfio 9/9] vfio/virtio: Introduce a vfio driver over
 virtio devices
Thread-Topic: [PATCH V7 vfio 9/9] vfio/virtio: Introduce a vfio driver over
 virtio devices
Thread-Index: AQHaKPhWxx9HXujfsUi0tG4mXIDTXLCm0VsQgABbiACAAIWxAIAAnryg
Date: Thu, 14 Dec 2023 05:52:15 +0000
Message-ID: <BN9PR11MB52762A39B525CBEBB8E89B638C8CA@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20231207102820.74820-1-yishaih@nvidia.com>
	<20231207102820.74820-10-yishaih@nvidia.com>
	<BN9PR11MB5276C9276E78C66B0C5DA9088C8DA@BN9PR11MB5276.namprd11.prod.outlook.com>
	<fc4a3133-0233-4843-a4e4-ad86e5b91b3d@nvidia.com>
 <20231213132340.4f692bd0.alex.williamson@redhat.com>
In-Reply-To: <20231213132340.4f692bd0.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|CH0PR11MB5428:EE_
x-ms-office365-filtering-correlation-id: da10d798-fc2c-4862-49ad-08dbfc68d373
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Rp7SeMfQI1vX2wzR9YlN9VQAIEQBq2UcwRuVD/wn1mkwlpoFpqpMbQhPPlkW+g4kT3NCD1e3qta9sy1XmIGnMrCSAwwbZSg0vD0K82aENuYvmknxnfmkAoykECV2yadmLClxk8aqroIRhHe9tqLoeEDj1i53iyJe6Y1SkNvFPCPXmzZkTj99OM6NAmTvjqiejo8YmuvEToNaDVIiCEvrnxVCIhtORwrLKS7rEZgjkFmb2xZlrenS6hmGcJY8Q6+qinWGzBZ2IdoknDHmNJy7Dv5jJSuaE+QdgU3dUhn8eLsjKKG1e3X8srlKlLHUq0TjOnQYQOdcBqYiedjBqpMmUglk6BJNZpc6uS0JGZJmme60affot+Zh5PN+BC66e8IUFexhf65IFzM1aXuO1xVp743TFZmKwsQ5IS/GG+ZuWiwD+JPKsrmFc/hpWANxs4rVHv6BdsMKuPJVboOCu4VCPbaKNCimjEoSLdFOYio8Iq6Mf/fQBW0Iya1f0PofGCjkBo3v/o6NV9Zq5g9H9Jfa/0XlsXMYsarORBHyKnbzAIdv53hIwyG1kWu2pm4CyZQe1zRDqSRaRA3+nWpb13uveyKAnBG3+as4zOWZ/vleJHL5+PSIb9Fj+xQ2zPSmrvhj
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(346002)(376002)(136003)(366004)(396003)(230922051799003)(186009)(451199024)(1800799012)(64100799003)(52536014)(55016003)(478600001)(5660300002)(7416002)(71200400001)(2906002)(82960400001)(9686003)(7696005)(6506007)(26005)(86362001)(110136005)(54906003)(76116006)(66446008)(316002)(64756008)(33656002)(66556008)(66476007)(66946007)(4326008)(8676002)(8936002)(41300700001)(122000001)(83380400001)(38070700009)(38100700002)(53546011);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?NwVWvI0gE+A69ptqUzV26K+tzK8Pt20DFX39lNVXxewd/guatsR+2zGAYb6z?=
 =?us-ascii?Q?YsZqiYiCpbMev3CA5HFfRKge2WiNsdykX3batoR1gDB5P3OXJEoBPTCeMV1F?=
 =?us-ascii?Q?GdzPjKSnfLHGEgw1jXNx2sQi2UYtBpLN88YffiXdPzS1uLxGBwJcSDB7Alyd?=
 =?us-ascii?Q?Q363ykWWhlzDQdWpYuN9SNW2baLkXaAPhP7Jtgz0rBryWTgL1f3m/fRT9ilB?=
 =?us-ascii?Q?VKlx6Sz2UdFFj+WtUJuF2aVE6Jh130y8qTr6nIgHnbdzd77m5hdZe+Bby9XC?=
 =?us-ascii?Q?66EBWPXKJSjaFAfI7WslhwaUKpqvsJfexFwCxWKPpscY31QAx2/sLdp1yuQD?=
 =?us-ascii?Q?LO2L5YmQNfk2MQsTEvuphTEOMWZzuepsK4Bx8mTfuArLHL7ps4OhwnufBhpV?=
 =?us-ascii?Q?jry+twC4h4F9QK/nFjOCCh74HTDEZILMqdgcCzwfwRh7vhhjYAuIQza3XRgX?=
 =?us-ascii?Q?lqWbu9w2xwtq3p3IBv2NApnMiTerdkfEXBrwD8XN/ria5KSvd+tyMyxI0E0/?=
 =?us-ascii?Q?60IcB+Z4vY9QtW6TGo7bOOmXE4bjCTA15hrjE2H56omvGZHpY0wwK6cj7rTi?=
 =?us-ascii?Q?yrp5XlC+qHDeCO0kYtOxoRXyxq6HOCnX9ExpyEOv378jSP0IWfs4Yxrbqaoy?=
 =?us-ascii?Q?BLYHBPnBRV8cWaK/qI8qG0F7TkP0pnb+4+Vz/gpFF9cFqOxA7UWYHxxrBG7N?=
 =?us-ascii?Q?h9QQZmtcH9e0L2FEnHizL2+SYxNVn4RSTTgzj04khVB1ydX4dckSFobvIY7v?=
 =?us-ascii?Q?PeLnpPYnlzbRUzjTWRgdUqy6Z9oFAWoWvj0AnnXh6RH019q+JYA3l56g8wFT?=
 =?us-ascii?Q?h/rIYNIG1ANZJ6j68l5dBm5pfIu+Gaas3lcTR61EIhzw6FoN5oEEeDedEKGI?=
 =?us-ascii?Q?ZJXFvO+XYYk75sKLj8pAT9ZChlSFreSq9ykB+nkK3g4K1rEf4VtYYZZjzLMD?=
 =?us-ascii?Q?6cKbKfUdQSC6rihd0+BiKifgz7UIgeUvqAeorJikG/LAJESCi0bVWajh63FL?=
 =?us-ascii?Q?3Crmf3BqxvyWH4YhCZfxo17QmurmmrpP8jMqz8Avmk+1xRUb5OEZNB7aFXac?=
 =?us-ascii?Q?yYkIiKTrfh9BvoB0gFYPopJGB1ChxzbYydBPUc98R5ZnRaa36eeFxZWbdNTW?=
 =?us-ascii?Q?O2wrzKfAo2ti3UiWdCBoXBC0oM4RiuBIbW8BLZHCpRoQhbLzVtQkDqMptgV5?=
 =?us-ascii?Q?CoL25DsSijAmP32nRugNRaKqdvV+UXsNfi2rOK7bZP9Y6TlAO9QftBTdmh0w?=
 =?us-ascii?Q?gv8+BUPHz8nUNgDyXLln49Jb7MWFTDq0eydKW45O1HEOyvpQ0SaIkuAQxCDd?=
 =?us-ascii?Q?3mrfo9RHhNY+ekiR/9F36uXgch9qe+2Wkyyg68R3lpcK1vZaxETtQ+GkF9TE?=
 =?us-ascii?Q?7R6ImiVioKV4FllQv55mv7ZueKgCcpwzoqxB4DyJAB4gIkYU/m75lK99PUE0?=
 =?us-ascii?Q?nA9CMuWBdLAfrSBp+Efb4M9fRThW2yjv4bPDmBEWnRhRxUuJaZrzGDUulwcj?=
 =?us-ascii?Q?Dl1iO/RsmNanrcjpjFNEOeC7rDq1xKb7KJ3dNXEbrA2nmvM+05Md7V9G3F3X?=
 =?us-ascii?Q?grZOXh1aFdJhpASJoCWWUTKMy9+0lJR7PCjDH2C9?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: da10d798-fc2c-4862-49ad-08dbfc68d373
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Dec 2023 05:52:15.7127
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HC+/TEd51R2OIu4SN1joBweF+Bi0gFgms1Bl6T2EXhUCi4uUoMBYeiw9NuAl7iYuI18ksYKwyckDgW4ANLP2Yg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5428
X-OriginatorOrg: intel.com

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Thursday, December 14, 2023 4:24 AM
>=20
> On Wed, 13 Dec 2023 14:25:10 +0200
> Yishai Hadas <yishaih@nvidia.com> wrote:
>=20
> > On 13/12/2023 10:23, Tian, Kevin wrote:
>=20
> > >> +
> > >> +static int virtiovf_pci_probe(struct pci_dev *pdev,
> > >> +			      const struct pci_device_id *id)
> > >> +{
> > >> +	const struct vfio_device_ops *ops =3D &virtiovf_vfio_pci_ops;
> > >> +	struct virtiovf_pci_core_device *virtvdev;
> > >> +	int ret;
> > >> +
> > >> +	if (pdev->is_virtfn && virtio_pci_admin_has_legacy_io(pdev) &&
> > >> +	    !virtiovf_bar0_exists(pdev))
> > >> +		ops =3D &virtiovf_vfio_pci_tran_ops;
> > >
> > > I have a confusion here.
> > >
> > > why do we want to allow this driver binding to non-matching VF or
> > > even PF?
> >
> > The intention is to allow the binding of any virtio-net device (i.e. PF=
,
> > VF which is not transitional capable) to have a single driver over VFIO
> > for all virtio-net devices.
> >
> > This enables any user space application to bind and use any virtio-net
> > device without the need to care.
> >
> > In case the device is not transitional capable, it will simply use the
> > generic vfio functionality.
>=20
> The algorithm we've suggested for finding the most appropriate variant
> driver for the device doesn't include a step of moving on to another
> driver if the binding fails.  We lose determinism at that point.
> Therefore this driver needs to handle all devices matching the id table.
> The fact that virtio dictates various config space fields limits our
> ability to refine the match from the id table. Thanks,
>=20

OK, that makes sense.

