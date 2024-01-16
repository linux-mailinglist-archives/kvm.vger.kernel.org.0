Return-Path: <kvm+bounces-6333-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B279582EEB7
	for <lists+kvm@lfdr.de>; Tue, 16 Jan 2024 13:09:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B9BC51C226FE
	for <lists+kvm@lfdr.de>; Tue, 16 Jan 2024 12:09:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42B611B97D;
	Tue, 16 Jan 2024 12:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jaF/H5ix"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BA211B967;
	Tue, 16 Jan 2024 12:09:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705406947; x=1736942947;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=3EPGZJBqFbUUVaM3PutLrAgZq4NxnzmblZBX3f8bkeU=;
  b=jaF/H5ix1/9dnjSp6pT4bnlHXLMoTH7gm2PT8BuanKsECHj3TtD+aUpU
   B0nfXp5u0WWpYMHaxRzbFjGmy5uevAL+yNlS8mQRLJg10m9Osx8/kwzJE
   fo8RE3Zb3EnLBpw0jSRfBGQub8JFRzeIlGLwUzhlfdZ9Dp1VJoCnOovcy
   9LGPv+xXrlNYfDRgDA3nCSFZNOVyVRqKK3O1l1iaYw0x/PhGnwKtZrL/a
   H6PCHvihPO0t+dFK1iF5m4NxjEL4u5Cnah0QjsEofFGKowHMON3/IbpoK
   UMwHBH4yAPjG5DZNJcH5QgsHYtukoKVt72shPsGB6nC17zfnxx+Sqi88C
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10954"; a="6593173"
X-IronPort-AV: E=Sophos;i="6.05,199,1701158400"; 
   d="scan'208";a="6593173"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2024 04:09:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10954"; a="760159670"
X-IronPort-AV: E=Sophos;i="6.05,199,1701158400"; 
   d="scan'208";a="760159670"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga006.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 16 Jan 2024 04:08:58 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 16 Jan 2024 04:08:57 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 16 Jan 2024 04:08:56 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 16 Jan 2024 04:08:56 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 16 Jan 2024 04:08:56 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=btBVAn8v4yNK0mzafeXlG4yoFGA5zpu+2B9xFfuFO7BOgfh/cC+YvCz40K96S14sQUAA33W7Fz5aSwDBM+rJQu3UuHOU5acSmXNB6HsYLO1eQsapepmlK79yGmi2FU3UPItCHHgnTrTp/tYVVxDit+Umild41XsiuX88cqIrOW84zhP3fNgvugA8UCJpzaSs/LknYLVgYCEygEcDak+sAm0mCUHVDzyv4MH6zHpJXsOpmoVDsBBTjSVXvpJn8lDVeUfCO36ruALetX6szyPTmNVcw18CljHSNHPoqR0YKQCXQM52c7QKE8eMAe+TxKklv9P1jH1vJUz1XvFP4fdEkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y2sTp5Onw2IGVnlg0kUsS2ZlWCK6NHOazeX3kgpMdOo=;
 b=CVSUfTp2t0mh6rscJVAA+RWvnZzvmwoF7zoMdK6hOU+HU4IAszVIycbT6UJc/MvNMvvuStYsGXmfxMgke67XFUJWu5woaa94p4Unc8xG5ePzpSJocLa2chZkTtyec53tFNC1it84JZ81RPMLL8qgRL3d0dkgiS6kqImSE0SdPwSOg9w8xyHeaRDh5moxDaPpWbPtechq2YeYL/JRnbpSLvjPbQDXVvTA34Sundj5dQJ4GCZDJKgq1cw5J4qbeUd+L7fWXM+WudyLNChzK/qtIHAxmOflYhoSTx2SQjq6ITHoo7fQ/xKciZaLUjO9qHQftHGSLTEX4V/OoDC3WvOKtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB6373.namprd11.prod.outlook.com (2603:10b6:8:cb::20) by
 DM4PR11MB5248.namprd11.prod.outlook.com (2603:10b6:5:38b::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7181.30; Tue, 16 Jan 2024 12:08:53 +0000
Received: from DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::9ce6:c8d3:248e:448a]) by DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::9ce6:c8d3:248e:448a%5]) with mapi id 15.20.7181.019; Tue, 16 Jan 2024
 12:08:53 +0000
From: "Wang, Wei W" <wei.w.wang@intel.com>
To: Alex Williamson <alex.williamson@redhat.com>
CC: Kunwu Chan <chentao@kylinos.cn>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2] vfio: Use WARN_ON for low-probability allocation
 failure issue in vfio_pci_bus_notifier
Thread-Topic: [PATCH v2] vfio: Use WARN_ON for low-probability allocation
 failure issue in vfio_pci_bus_notifier
Thread-Index: AQHaR3z9FIdL+jn8c0+6wUQa6PWyULDa+5EggAAVQYCAAO+DsA==
Date: Tue, 16 Jan 2024 12:08:53 +0000
Message-ID: <DS0PR11MB6373DB70ED49E18C3232973FDC732@DS0PR11MB6373.namprd11.prod.outlook.com>
References: <20240115063434.20278-1-chentao@kylinos.cn>
	<DS0PR11MB6373BAF9CFEC4D67DEAAB1F7DC6C2@DS0PR11MB6373.namprd11.prod.outlook.com>
 <20240115092841.19dc32f6.alex.williamson@redhat.com>
In-Reply-To: <20240115092841.19dc32f6.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB6373:EE_|DM4PR11MB5248:EE_
x-ms-office365-filtering-correlation-id: b8974b54-a1d6-4752-aed3-08dc168be859
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vohzcbhtqOcD2a8WvhIHMFKMc5/fBcuAgOZikG0Y4d55KCPjbrb6WGneVmT90pdHkmnAOeMy+X/OJflnvGUK+f66O5vnm2TnhUYzUoIkmJ3P5rpcMO3V7y6/dBojnMBWxzAX+XAj6bqIeDkZgnYBkjuztUMUAUrxRlsaPEEoHwEXGA5wFs7Yd/sri8YBVXvnB21QgLy1L2YLnDaheK6IrqXeAp+0NtlC4TB0G9EkOLa3m7vGXqHY1U/7MmjFGSeCrHRdbWXJhoYx98R8p5vEaOZfdmo7tRADYp7/unc/zqHlkQ6MJp+na/+yzC/klsQPF1XU64zT8yfJnkx3y2yrhAL9l1/QW0yORb3izKQjKASx7CQiGdxYPk95I4NfFBmf3/FF8z/Z79pm1AKzCFd9r7B419rG11vi3gKiwS9n/7oK6hhw+lGXE6EQCFq9Ko7HctcTqXo8gCwOCDohMpOjI2qsQaqCDIx4i662G8HDvn7K1rkMwCaKqVwK+g0K6PsJMy73I72L5r0SGmume0KBgG2FNamlL0VvWfxdyFKD8k1x6SbP15VjBwQmQMCCnycXlb0/Ys11xcG821jN9H29Ywltligvo/26MoslmIZxopx+2vj/4OYkDB9J+vGo/93v
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB6373.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(39860400002)(376002)(346002)(396003)(366004)(230922051799003)(451199024)(186009)(1800799012)(64100799003)(4326008)(52536014)(2906002)(5660300002)(478600001)(33656002)(86362001)(71200400001)(82960400001)(38070700009)(38100700002)(53546011)(9686003)(83380400001)(26005)(122000001)(41300700001)(6506007)(7696005)(54906003)(316002)(66946007)(64756008)(6916009)(66556008)(66446008)(66476007)(8676002)(8936002)(76116006)(55016003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?o1FbM3JfyBq3itKJ5C/DmZSkWjB9IxaICbky2N8S4TtAyg1WcYxZpdzMkJCx?=
 =?us-ascii?Q?peYfdY4k6IRAw4NRjkeAX8RzTmIJoYWT0RbBqwZHGGuzd9ge2zi5O1XBP0tW?=
 =?us-ascii?Q?GIk14KTx1olUi7eeHEjCcuXpGAZ3cp/93amCmEWVerm99ZL7UrQV/basAKg2?=
 =?us-ascii?Q?bYu8Ra/faaCJqSN04R7T/Rdpr8ZeTuq59E7DVTons1uj1EbMqVhX6oH7mu40?=
 =?us-ascii?Q?1MHXiJF2jstD2LLMfwIKoRe+9MqfOumHVIzI7D3sgz0p1E53BUWic9I0f3zM?=
 =?us-ascii?Q?lVLf2G5/D8N2rRBgpQYNNSqMxTS8EqgoRzwCWEKnLc8g5XUgwbgD6vYxcPAa?=
 =?us-ascii?Q?ydCtvBdVI3/WYYHBuWrUDjEOLDVNNY5OnK7Zff5+DdM2DMZb0mHkOnBGLdUE?=
 =?us-ascii?Q?C+LQAj6HFOLYbYSvprLXPMKf/qJHkfmTytYFBdmI1HJhJ8QS8IITwUnK1rnl?=
 =?us-ascii?Q?ZB9yLWZpVEauUT+KX8Qs4kWiJjhh3p/YE2a/DGoHa+N/VsAUmor8G4MMR0xS?=
 =?us-ascii?Q?pu+dc0Z6G+Bomn/QnH73DfI9LMDzZ55yy2sN6w94+IF7D5/A7t/56JyOjc8c?=
 =?us-ascii?Q?m63Pm6kD8uaKBGIPoT+EcK/MlMo7hEB7V09jfJekpnWHqrGXbLYyj10RP3lI?=
 =?us-ascii?Q?m6yiv91yDhZsVPN4EV2jx0b+2Hl2ygHtfGNAPCoPW8hVzMg+aKHxo+fkufd4?=
 =?us-ascii?Q?DzEgUw5AW3CFOrQy3fTFs9grl3fGfaVZmA6hYI7IfDOznicWUvHW0bBESPrM?=
 =?us-ascii?Q?y6DpXFjeyxMYSkKlHS/+BWAh9+jnoo1FEiDldT4IlFG6w/PBMKLwiZ1luZ/U?=
 =?us-ascii?Q?ZwHgbPK4UJ82thl6SeDnmmWGjntde17dapGaN242M29YpEiOzaojMUoAIFL5?=
 =?us-ascii?Q?nr+fYGB8s86oVZfsQvu5AzURDEU1b3aPt1KETe/kGKstMeajsoXoThS5b4Ch?=
 =?us-ascii?Q?+uRYxOJSm5iqe0j3Du4/9vp0DWgSLkgLxlnXSZJXCLMe2wxFpP+GUJp/1HB3?=
 =?us-ascii?Q?/NMt3apOM/Zoff5mrw4B8TlcibMgG6FNoTuBNQJvW/gEbZrX12eevnx7n+PG?=
 =?us-ascii?Q?0oFuADCqKcZXERSoACJXO2VkcKx5zUFwD9Tk2YGxVOoMJ6gQ7Msg1AxcRppM?=
 =?us-ascii?Q?o4jRwnbv2dG6X7OQfJ/7iX8IDoLvKSC/5i6cUAtrQp/CIdzw4t3Pssn6ARIq?=
 =?us-ascii?Q?6AWhu+BF/wMOWk0P9tGXYbDkQuYmmUetgS56fYoysXjZdBSMoiWSQHn2wryw?=
 =?us-ascii?Q?3fnxQywkGu0FY2Z1+eyLtERsf+P5RsxXvdmt6/cUU6o2qEzudkHiSoRweby0?=
 =?us-ascii?Q?Pb/+L0LszPwTP1/bIIBqhgXkHbRewXRlzAhyIwX0Fi/Jri10DfzS1zH0w14z?=
 =?us-ascii?Q?n4sez6gdVa4dEIyqCYi6va8irV1JLDEqH3FqWX/M9U5Ps/58jkZ2fV2ayQOC?=
 =?us-ascii?Q?+Tj9vf7t52ySh1C08VfV93JY6QqjP7luAnRIGG4/LyMzIROn1Opv9Pw+W+Gu?=
 =?us-ascii?Q?iSekv9Yo3jU4fpmHWobw4yYWQsx6OYOq2BDNSYbroHFqrqwbfjBg6r0boQCf?=
 =?us-ascii?Q?qrWo7WsdBO+ZNegZes16c34HFFQ513YJtx5Lim5f?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB6373.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b8974b54-a1d6-4752-aed3-08dc168be859
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jan 2024 12:08:53.3724
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1UHFQ7YlxpnhcCUsMkdVRJdY5E0ujtJGGUgaDbcVW5QQW4R0u/apIFauDA0unJNwyOZUdCccfLf+a4nBixN56w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5248
X-OriginatorOrg: intel.com

On Tuesday, January 16, 2024 12:29 AM, Alex Williamson wrote:
> > On Monday, January 15, 2024 2:35 PM, Kunwu Chan wrote:
> > > kasprintf() returns a pointer to dynamically allocated memory which
> > > can be NULL upon failure.
> > >
> > > This is a blocking notifier callback, so errno isn't a proper return
> > > value. Use WARN_ON to small allocation failures.
> > >
> > > Signed-off-by: Kunwu Chan <chentao@kylinos.cn>
> > > ---
> > > v2: Use WARN_ON instead of return errno
> > > ---
> > >  drivers/vfio/pci/vfio_pci_core.c | 1 +
> > >  1 file changed, 1 insertion(+)
> > >
> > > diff --git a/drivers/vfio/pci/vfio_pci_core.c
> > > b/drivers/vfio/pci/vfio_pci_core.c
> > > index 1cbc990d42e0..61aa19666050 100644
> > > --- a/drivers/vfio/pci/vfio_pci_core.c
> > > +++ b/drivers/vfio/pci/vfio_pci_core.c
> > > @@ -2047,6 +2047,7 @@ static int vfio_pci_bus_notifier(struct
> > > notifier_block *nb,
> > >  			 pci_name(pdev));
> > >  		pdev->driver_override =3D kasprintf(GFP_KERNEL, "%s",
> > >  						  vdev->vdev.ops->name);
> > > +		WARN_ON(!pdev->driver_override);
> >
> > Saw Alex's comments on v1. Curious why not return "NOTIFY_BAD" on
> > errors though less likely? Similar examples could be found in
> kvm_pm_notifier_call, kasan_mem_notifier etc.
>=20
> If the statement is that there are notifier call chains that return NOTIF=
Y_BAD, I
> would absolutely agree, but the return value needs to be examined from th=
e
> context of the caller.  BUS_NOTIFY_ADD_DEVICE is notified via bus_notify(=
) in
> device_add().  What does it accomplish to return NOTIFY_BAD in a chain th=
at
> ignores the return value?  At best we're preventing callbacks further dow=
n the
> chain from being called.
> That doesn't seem obviously beneficial either.

OK, thanks for the clarification. My curiosity came from the statement "Thi=
s is a
blocking notifier callback, so errno isn't a proper return value". Probably=
 the
commit log needs some rewording.

