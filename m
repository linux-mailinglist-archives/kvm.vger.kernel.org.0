Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 383C06C6488
	for <lists+kvm@lfdr.de>; Thu, 23 Mar 2023 11:14:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231278AbjCWKOm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Mar 2023 06:14:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231277AbjCWKOh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Mar 2023 06:14:37 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FDAE19F2B;
        Thu, 23 Mar 2023 03:14:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679566474; x=1711102474;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=JVdDo3p1OAW/O8TVGUey2qhgIy9Prrct6seA5yZ6v9g=;
  b=daK1TqXDKFtcYLVJD2hqT6MElyc1k/IksDqF80eD+PMTf7CZQE8CbgO1
   xtAHerwc7Muw++HVStymGe3e4/+PpJzzfF4D/YgrGIqfeEuxQfTcOcjpt
   LrhND0SCoMGOx4a9ouUHZ4aPDCoSCn1C4VWcZxCu7jHl8Q/7dSIJIMPv0
   GkR8Jp6mcegqbrMvi5Bbu1NkLEc+cWxXK6nO9sA/XM/uVqhTYylt7yfqF
   DVOjVJOVA/DwgQ4o5IC3n1KHN1WG4B4QlAgTnUWS2wlYbAjSmEoHXfr3S
   BN93FPQjzZdnQOPbmm0RWQCqQ5WVHYdtp0eyeG4TJK6oMFkFUaeRZG69g
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10657"; a="336953102"
X-IronPort-AV: E=Sophos;i="5.98,283,1673942400"; 
   d="scan'208";a="336953102"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2023 03:14:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10657"; a="746665118"
X-IronPort-AV: E=Sophos;i="5.98,283,1673942400"; 
   d="scan'208";a="746665118"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga008.fm.intel.com with ESMTP; 23 Mar 2023 03:14:34 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 23 Mar 2023 03:14:33 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 23 Mar 2023 03:14:33 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 23 Mar 2023 03:14:33 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.45) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Thu, 23 Mar 2023 03:14:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ClLFcHou6ANEI6iqmCz1sJzC135Sl4/JtYmw0B79VIaO2s3bSy/Jj9M8qANQhk8gPaUw1LY0sU5BSp2Dk95o7EI2XpNR6L0ite/tGTlVI2ZttRmm18L2/I9zgPfph89YAL+aDNI6tzsLnOLIS1DJJ+GlZ/9KnbuUbINpzd+o9SJFZSngZXkUcVwoU8epmFA1V9YcyT/KBC1irc+tvxSDtDHul/XghI+QvEJvv1FsPRy/oUgrJGQ2jYH7IXwabe03RUKzAcjhBxpqiPLPWzSOCA+AFNLJPOMEExQLxcxIkpgWKgP6UZwrE+ekxs+qhyWNFPrpFKOYygd0c1S6QYXyhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LFQMTY4HkBeaPyK4ZkrXxXXcdGHVjUiwPYa/LsrdK/0=;
 b=gOz8GdUYmweG/iHoNU4ZLAqqhOV7tV/Pzn+ak5i2R6GPP6A9xiWkXt6D41j6Jyxgd22ed75CQFqUD5LxaTxrvnYZxMEo+9Vxj1Pq76JP7SiUksD8RFV/pz09obrcf20DvGJW5LeyFqBtIAko100B6rUEtajiP/vnjCw2AWiunrUOs1Qg9BsDpUAgvVa2MmRoiyTySRR/k9BVq+K9LOS1ZUbHzwCtlcRLnfRDW6IgMVw7yuLkFj+Ph5niiYwwEJaWdmsMW6o5t8HFYQvobslijuQQ3Xn3A0YF6mqzNt6rFOYD34tRrnRfgAK/O19YGohRzGr05315RAOTC7wclX6yew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by IA1PR11MB6147.namprd11.prod.outlook.com (2603:10b6:208:3ed::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.38; Thu, 23 Mar
 2023 10:14:31 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f%8]) with mapi id 15.20.6178.037; Thu, 23 Mar 2023
 10:14:31 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "Xu, Terrence" <terrence.xu@intel.com>
Subject: RE: [PATCH 6/7] vfio: Accpet device file from vfio PCI hot reset path
Thread-Topic: [PATCH 6/7] vfio: Accpet device file from vfio PCI hot reset
 path
Thread-Index: AQHZW19JEMmjcrKSV0yRXuf6Ou6fcK8IJvKA
Date:   Thu, 23 Mar 2023 10:14:31 +0000
Message-ID: <DS0PR11MB7529BEB87EC6941C19D56660C3879@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230316124156.12064-1-yi.l.liu@intel.com>
 <20230316124156.12064-7-yi.l.liu@intel.com> <ZBiu9+mVurbW0x5k@nvidia.com>
In-Reply-To: <ZBiu9+mVurbW0x5k@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|IA1PR11MB6147:EE_
x-ms-office365-filtering-correlation-id: 3bc267e2-b6a7-4b73-c2a6-08db2b876490
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AahMQMfMK5kpLE+MwifVoex2zGJo1C0xt7kJxMxHZn3fAAPBlYyo2zS+5G2xFbK4TmthC2cCLZwoKATSPZCtUMByZ0lklKZxSxMxuw7+pZOiNBewGYXKn9LWxdwOvEoTSixKqI5t+b95pqqE4ROQ4ube8Ip973Sa4QVQrDfSZjrEkJ9QCLZcVyigjqNiwg+bPXLnB+DxkFXM6zqt0OOXG9XZ2Vt4Uvq/nbhbNS6zloKIXBXmyhHUMIcZWpL24f5dql7v/cqHWAca9RF2PIIpCEzAfFVNr0DTZs/hjhKicy99a6Vu0uFMdlL5kreXB+OrGiYE2+fWImLSSz7N4YT7IcMi4lAE6INq/1Xy6zrrGBu2UwN6Yf8X7LqXvbbvqL6CbhwGckt0Dd/yqP0iiW1JqcSoY4Sf9Kca3jozKyAEi610te1Dou+AWjIAIuH/cHCS3/RaQTgcS7peNI8aiHziQ3vG+rYZU02picp/WEVnyWorxXv+UR4WVvtEOBruZg0xwaKZMUhim0vJZh72Y5k4kBpldX5EY9lhUCt6dLkqG8WdmD+zt1rftMQlygUuj4m3h2JZpaX7IYPORbgTP0Ud9bCB2vNKgmz2/jZF7mn/VsFavKLbCrQnfyc8HrmUHn0MoG6Cf+bIaPlPrmdMNG3RiYUsnro53+siq14IQqie4L3RRTzrjbV8tj/38yAYT4zc
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(346002)(136003)(376002)(366004)(39860400002)(451199018)(55016003)(38100700002)(38070700005)(2906002)(83380400001)(478600001)(966005)(71200400001)(9686003)(186003)(7696005)(33656002)(86362001)(316002)(54906003)(66556008)(66476007)(66446008)(64756008)(8676002)(66946007)(4326008)(6916009)(76116006)(52536014)(8936002)(26005)(6506007)(122000001)(5660300002)(7416002)(41300700001)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?QyagcnCnQGQvN0VybUiO16fHsz1nd1LjLqxqa3XwalMkfP85Fq24XiAsz0l1?=
 =?us-ascii?Q?FneHfheG3wUJE+ZebcN0AmkhfjOy55Us+ECTM8BHa5JEjjtr4/e2uql11Gzx?=
 =?us-ascii?Q?8XJJvm2FWdZ0DA3hdjl16giPS8GVM0wJ8DvcIcJ6l/htXQN2EJ7/KaTeCsNt?=
 =?us-ascii?Q?vv4BwGln4PfhLpcCX82Bu39clH0n1fe35rsr9h7F6nncnCqBvN7ttVqHT/05?=
 =?us-ascii?Q?P0xwDMqca1ATWWbMbt1tqAcgnbYaiAtXmOkjoK/7L/DrYJecDDkwgjvvUddA?=
 =?us-ascii?Q?RpUkYa5Rz1iqOCmjzFCJxOv2hvyqrzGsCbvLO9KQhHN9F7jYriqrjwTZcwnz?=
 =?us-ascii?Q?h1m1zlHYF4ua5qPz6rOHw6qz33RvewfCCgdssXyiqea/Uxxh0NzcpFbWAO1/?=
 =?us-ascii?Q?83tQP1E91faSsyITw5uSZmtvtrRY6Q4aMJo3mWxK4y9+qGVVijr11zMiqtMh?=
 =?us-ascii?Q?onQBwNccb/YVL+k70Fb7/DfJyJ9/XdQe1GzLs1tqIbX7sNPDw/s7cZDvNVnc?=
 =?us-ascii?Q?m28oDeWTIsq62pGE9ddH+caHgUBQ6FafStjGCJCm5iO16p635hhDzc80QxHp?=
 =?us-ascii?Q?OrMkMRv1n9Gt8QJkb6ORsxt53IVI2CoAAxILQqUyiGiJDPC/6zejhC/8ZMQ1?=
 =?us-ascii?Q?PBjG/FTJ+rpXlzUS6/3opYbY70OxCwUZMa8kY59ru5XjKG/60aBc6e5F5Bwl?=
 =?us-ascii?Q?KkUykLG8uGsONp26i6fKtwoa72KMwkkcj9rMPD/DUOJZJA5NlEgFv3IaBOdl?=
 =?us-ascii?Q?rlyK/gU0xWHvOeJc1Qbiut3dgS9S4P1deJZaznCJh+CtCW4E/0w1znz9XbjP?=
 =?us-ascii?Q?C6BB1WAat2R3PcyzwKu22WMKP5EfXK6D5YZ7zTTTbeq02r6xbCQmKzMcEHID?=
 =?us-ascii?Q?G3tNMaHY4/Y+zF5b76zrGe9ib8sSpeBWWIsMI6VWBlGKdSCFBztA78Monjrv?=
 =?us-ascii?Q?FQS5Q3PX39N4wunTPAYaNbvPxC7Oacg+uctymix05IKEeM8fj+aykl+Hn50M?=
 =?us-ascii?Q?NYz2V4BeQXdTiFa+Y2XPpzAVJBOm67ylPbu/U041wqn/qDhb9jK+nprDOw/3?=
 =?us-ascii?Q?Ztl3f2m4f6KMNccYk6Qdyx38jYklTV+UfrDdgjqExainl3MpLI0phl9sTOo1?=
 =?us-ascii?Q?+DbsHjk5MPvrtTb2zAfDZxMk11/NEuCGET+uAydsbyKYhO4sMkczvvjZwrZ/?=
 =?us-ascii?Q?+8LKaORI4OJUMqN6cHp6iQOxYZ52JnqcZURVPYb4x03TuSyC34aov0GIzsRV?=
 =?us-ascii?Q?VbTj70B4V/VeZKviF4vmEkt7Ktv1sYyFKhtTGcIcykvNAuRUkJGIvQJP6yyl?=
 =?us-ascii?Q?hPIJpZUdkVftkJqj9TsD1p+Cc1WllbZBECXphnHCBusSu3rxPnlmyDQ9O6z8?=
 =?us-ascii?Q?pvZZH/qr5w37YO+ZM9emykDbRiLLQ1Ks3EJDM440FbufR09SCG+gx42AviYX?=
 =?us-ascii?Q?jtXhb9h8r/E/xAkb3NygFDL3Z4pktidhpw3EXxvBndlFt3/Kf4nvDdpyyeZe?=
 =?us-ascii?Q?j23i+paPb0STwzMP6B+47tbXijCokSvZlo4ldmooWtigB7iy2n7owdbokafp?=
 =?us-ascii?Q?LSX0qc8lgc5E1VkfpYwkoYESv9o42xnZivY2V2e3?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3bc267e2-b6a7-4b73-c2a6-08db2b876490
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Mar 2023 10:14:31.0376
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hmS8bdMbYOrejbT0xKf1dGG3uYNLznJzm0/2iuhbTkjwOB78+HRr0QbHzdkItIks0CPLCWderWorvKbEnPjTZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6147
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Tuesday, March 21, 2023 3:08 AM
>=20
> On Thu, Mar 16, 2023 at 05:41:55AM -0700, Yi Liu wrote:
> > This extends both vfio_file_is_valid() and vfio_file_has_dev() to accep=
t
> > device file from the vfio PCI hot reset.
> >
> > Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> > ---
> >  drivers/vfio/vfio_main.c | 23 +++++++++++++++++++----
> >  1 file changed, 19 insertions(+), 4 deletions(-)
> >
> > diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> > index fe7446805afd..ebbb6b91a498 100644
> > --- a/drivers/vfio/vfio_main.c
> > +++ b/drivers/vfio/vfio_main.c
> > @@ -1154,13 +1154,23 @@ const struct file_operations vfio_device_fops
> =3D {
> >  	.mmap		=3D vfio_device_fops_mmap,
> >  };
> >
> > +static struct vfio_device *vfio_device_from_file(struct file *file)
> > +{
> > +	struct vfio_device *device =3D file->private_data;
>=20
> Isn't this a df now?

Not yet. It is placed before the cdev series. So it is vfio_device here.

> > +	if (file->f_op !=3D &vfio_device_fops)
> > +		return NULL;
> > +	return device;
> > +}
>=20
> The device has to be bound to be a security proof.

I think it is because this helper is used by vfio_file_has_dev(). This
requires to be bound to security proof. For now, the device fd is
got via group. So as long s user can get it, it should have been bound.

In the later cdev series, the below helper is added to ensure
given device file has bound to security proof (a.k.a access_granted).

+static bool vfio_file_has_device_access(struct file *file,
+					struct vfio_device *device)
+{
+	struct vfio_device *vdev =3D vfio_device_from_file(file);
+	struct vfio_device_file *df;
+
+	if (!vdev || vdev !=3D device)
+		return false;
+
+	df =3D file->private_data;
+
+	return READ_ONCE(df->access_granted);
+}

https://lore.kernel.org/kvm/20230316125534.17216-9-yi.l.liu@intel.com/

Regards,
Yi Liu


