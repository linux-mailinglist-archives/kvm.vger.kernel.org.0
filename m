Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FCAD728C28
	for <lists+kvm@lfdr.de>; Fri,  9 Jun 2023 02:04:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237612AbjFIAEe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Jun 2023 20:04:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229609AbjFIAEc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Jun 2023 20:04:32 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4697D30E7;
        Thu,  8 Jun 2023 17:04:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686269061; x=1717805061;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=SoVYo5AoDnEQQtb/ZuKc26CL8ZnI4oBgLb/bRaoIh6E=;
  b=RmaPpxzbeZaZCwHMqvPQ4k7jdmqNYuKrZ5CYpNvV+hZPGn8n14Q7CadZ
   Ng6Lp/cZNXze97uBeHbgKKPvYIy0HTX7XlTI+WrYqf9z51fftBaL6uE3B
   MZ6777gFfUmstZKQNNxtcmzzyNO02ohpWZr/98JZDud9kaAlOgciDMy5l
   gRdqURkY5Ky6m1uvI53Y4ufbJ3nQgy59f4YskBB3W2hlHzQDWQqjVIaxZ
   ANtwxmLaxM1EZa+1CYzhRm+bNHUEDioyWQNTChTLoWuw0yStt1xeHXAid
   VWKAu7wJEnkMrP0cOd7kIaWei/Ayu8eznpZf5SP1CU+HVrg7IFZqx8UlP
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10735"; a="337103146"
X-IronPort-AV: E=Sophos;i="6.00,228,1681196400"; 
   d="scan'208";a="337103146"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2023 17:04:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10735"; a="743288273"
X-IronPort-AV: E=Sophos;i="6.00,228,1681196400"; 
   d="scan'208";a="743288273"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga001.jf.intel.com with ESMTP; 08 Jun 2023 17:04:20 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 8 Jun 2023 17:04:19 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 8 Jun 2023 17:04:19 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 8 Jun 2023 17:04:19 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.105)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 8 Jun 2023 17:04:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GPqMBV8E2Z4+eBqViJFQAllhZaMrZNe7FmGPds2u/22MprNLl4xs8tmftRFkM/bSWW6OcH/xDs6WHmqf9EcGr7loHjicP1yd5eLELSW8OMW8o+6ivYp8TqIFNC69KxdoyMNFYdIJRIwzPoz6IFmTvHt15gyB0j4c2S/GNeEmMlNq7QwSuZ7lrbM/lfM+nRzkpuW2jIC025iu9tNQsjFsnjXRzR28zKMw2sJKfeUkagoj0ktgJrGapoEp4XlRenub7A7p8tBwSEg9HhFO1lDJ81IfjpR/bSlAmipkyylqQtpr6sDrOyVsRo0ya+PiUbs5XXO10dfGeVvYLmRLq1Nbpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y5nWqKTMv3Dj734t14R8UZ/OZdBl7P8lOb8Wn3Q79Jo=;
 b=fD4mwqIua+2Ww2Akb9purp94/5+TpR3fgY2WHUgXeyqnmlkcXZUm6FvnrwyV8oR0CVB3lwiD4/o9nPeXCfo9mvg55/zzDeuJaQdvaQ7ZIksepo8LilgeqKgTlCJbYnmD4pgItenN5iTgAGpLIOoaFwfzjWMAYcwjdTdzY89TS4IKixy49TQb3Qc+pSRbC6xRv3ELzj2/dhIt2Ad1S1Jq1988C9I1Dxgyd0utEJ+f5fURcxABYvG7siDBf+vOmz288rbFLr3Y43dajyX3NDa1DA0N2pXsiqoze2XotfbBW7jOAyQZTph04UYIJDtJc254Lsug6ICIm5v+a1nM5HNAaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by PH0PR11MB5830.namprd11.prod.outlook.com (2603:10b6:510:129::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.24; Fri, 9 Jun
 2023 00:04:18 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::5b44:8f52:dbeb:18e5]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::5b44:8f52:dbeb:18e5%3]) with mapi id 15.20.6455.030; Fri, 9 Jun 2023
 00:04:18 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     "jgg@nvidia.com" <jgg@nvidia.com>,
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
        "Xu, Terrence" <terrence.xu@intel.com>,
        "Jiang, Yanting" <yanting.jiang@intel.com>,
        "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
        "clegoate@redhat.com" <clegoate@redhat.com>
Subject: RE: [PATCH v7 8/9] vfio/pci: Extend
 VFIO_DEVICE_GET_PCI_HOT_RESET_INFO for vfio device cdev
Thread-Topic: [PATCH v7 8/9] vfio/pci: Extend
 VFIO_DEVICE_GET_PCI_HOT_RESET_INFO for vfio device cdev
Thread-Index: AQHZlUvxjWjQHBtl702niB2RsWbvNK+BhhWAgAAVpIA=
Date:   Fri, 9 Jun 2023 00:04:17 +0000
Message-ID: <DS0PR11MB75298B4285AC108EA260EE2DC351A@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230602121515.79374-1-yi.l.liu@intel.com>
        <20230602121515.79374-9-yi.l.liu@intel.com>
 <20230608162659.59b0522f.alex.williamson@redhat.com>
In-Reply-To: <20230608162659.59b0522f.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|PH0PR11MB5830:EE_
x-ms-office365-filtering-correlation-id: 97608cd0-cd16-4022-c31b-08db687d11ac
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dFunKF8o+n0lwYEkICaTD/YfrKmfqjQsPZ3Pd1WvXwCPyPyo6m0eN1cuvoq5fe++tH6Dr1k4uYTVO+HgqRGjjxOphJoOfnfuYZjKimNiAOCIbs+Z4jbaK0DhyI0LLrfpY3m/PtirThUnyqGPY6IuVKfzfpASNs5ZBAk1XE8kPW1WG1drccbapk4UfCrtvNcIrdwkMJkYWRin5wHIK/yDfWO8L86FfX0ihbHQ9an6ZDVl3ZdnBOy2ir3lR+gpiSzoclW41wMuv8hdDEv2eUcsNsNxOFI6Mn7ivhGJFaSwoYNcHGzOT6EbeBOnMgnoh9Zp+JwSJ0csKO8HPMYBBepOL6NHTsUte2bsyjxPH4FkJhz5ZLK3p5EGLiiXhjUPOKKuOMSVkQ3gLFslOyMiYP5+OCVM//Ad7/nzBs7Hsa3iE32QJqzPPNIRu2BVRdV/4GM1D+PNiCgOW0Sg7+YfIgHbb/G2qTSkTsiMHFuho15ph6Ik9O2attJ1QHXJ62TFO2hyws0gVBtQml8sVttB+b9G6C8fya7R+VTHkcNT7+dvmgPsiM588y6RrwxBbn0zpj1UF32gT2JmLaBtzPk1VvTG+sgwRHQoWG2VP5ixox5ZqXU9OYvQyBjs/85ltPIXPfTLMkLCc4Rg7yMhve4T2CgsmQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(39860400002)(396003)(376002)(136003)(366004)(451199021)(66556008)(55016003)(41300700001)(9686003)(66946007)(66476007)(8676002)(7416002)(4326008)(83380400001)(6916009)(64756008)(2906002)(316002)(7696005)(66446008)(186003)(54906003)(76116006)(478600001)(8936002)(5660300002)(6506007)(26005)(52536014)(122000001)(38100700002)(82960400001)(38070700005)(86362001)(33656002)(71200400001)(13296009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?hZleppyVDU95PsGtmDNCEva3hIizCl6gRrFIUPpWdrAqtl7vbj4r363yqw8/?=
 =?us-ascii?Q?OsD4KDaz3VDjuLjb1UJvoCM28+fCrg6eKR/iu9lRhdIhlWsjalhZnumLRYrX?=
 =?us-ascii?Q?bwCaJyD48ZJl/qw2cjA9LnxI30Pd0JhrNMyepEnKca+JBZmkGxweBOp0BYVk?=
 =?us-ascii?Q?SWzcN66EzsnAuRY0Z2cuhV5tCDVuOXJzJRMRXNfRuN2CNxQsXlZxhz/D2O3Q?=
 =?us-ascii?Q?AYYNX0S0mW+bOv5sRLM53cSRCKbc4S0u5qYcH6dzLAUqkY1zqlmuGA2WhquD?=
 =?us-ascii?Q?ccSfvDr4MOqeYrp4e32dd15Wk4IKs5sjjmqlG3kKq+uJs8yfTdjY21awf126?=
 =?us-ascii?Q?+ggxfJHPJX8q2RIdBnIRDebeZC3zw0Iwrj0zgSYeVOJFwYjiZw7iuAIBs/3x?=
 =?us-ascii?Q?Om2WpPT7iV17M1KaGZgxY/CG9u5qd+ykor+LEMGwGCtWKLfEEII+1crjtELW?=
 =?us-ascii?Q?HocAYosvAfUAiLuxZxxmMnLUqs32OLgtFdL6SwcWMtXS9UHvijsl97OXSEKF?=
 =?us-ascii?Q?gnvYxXeQelk05ogPahbbgXgmq8TNq+OWjhoQHuf8/KsOlCHEz2Om1a/KX5HB?=
 =?us-ascii?Q?899T9n+1hOu0NmFmVZysUnh+yGEppOQrRLojDQCUqRhf4Q+KwQ8aVD7cxw8i?=
 =?us-ascii?Q?IaRi4pjqsh/UbCXIIn7gP0aaEzz9HB79ViDnkoZE8009GGR/BdFkK2RWgNi1?=
 =?us-ascii?Q?RcnulYI8f/3eRduqKlKkSwhNXDViCoP1Kz9eYSoNLc/0/urzoJFx2AlmB0xU?=
 =?us-ascii?Q?g0LFlzpdO7z7vFpanGZlszgLbUS5gQmEdIDtWpOiKuVxbMXiG59QfX+vHPj+?=
 =?us-ascii?Q?34ns7ehTmuejBY8T5zWlEcyrAWrQtt7YLN+kSp8qeSr3VtcU3PTES27rV79U?=
 =?us-ascii?Q?Zbe4/Z+7uaSfCT4TT7xERc6Pdr5hU7g93LiqoEAdI1qYD1hMuEu+VTPURK8e?=
 =?us-ascii?Q?P6otq5cpwQfltlosh8Wry1HFvdU61Ge4BiZ0IyXFYRQ9NKE9jN6njqBOqz4+?=
 =?us-ascii?Q?38AOpNxtqAa2pOu6YlJvBVhNjk6xxyeN7ZOHUnkyWjyE80hnI+S7FJiXpYlm?=
 =?us-ascii?Q?p4A8KU+0m7QW+rGZpXtiTS68bIqa51frNCsFk7ND0JFYwvnAJXxfRNRSnoLy?=
 =?us-ascii?Q?hCdM00w76KA9llo87MjBK3EmWAwJMJ/VH34HuPGmvlHqX61xtCV+thnNJFEn?=
 =?us-ascii?Q?In1MF4QC7+7rdiE1JjGvV4uyuc726OQCR27ywfR9/tzu/B/R4Mw8Kr67n2cQ?=
 =?us-ascii?Q?WSFF/26aTDuBaHBq8geUBrtbNWf/5xwZLRcGhfnqzh6zWuVIKSU9XPu1sYtL?=
 =?us-ascii?Q?+MFuQxckWCzlfH7BkU4Srf9d/0BiY21EnW6Y6Dn5dICTv3ii9UhJ5/1hEbUk?=
 =?us-ascii?Q?YRzv6cyi7G7PThn3d+aI2lX4kO3OYW+b9K6LI3rhV8SNtCEogyvF8qBN0USc?=
 =?us-ascii?Q?JU/0vnAAGdiiRKdV7Kbkgt6cXiXcSAD2XiGYb4Odk2Mqb4v6FeYWCarlOMw7?=
 =?us-ascii?Q?yYJnlM5M/dgtOo4xAjdQqdnQk546P1mm882uFZOKyMT/YPs2RZCyP1RO1kmv?=
 =?us-ascii?Q?AzlRPOFLDfFh0KEGzQroU5w1ZvBJSqdKMHLlAnzL?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 97608cd0-cd16-4022-c31b-08db687d11ac
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jun 2023 00:04:17.9793
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lTDvPYBnRBcW1IkzsShhThq7RCbZqk/OXXEb8zOOPriGSkfEe1sDiZaBNpUk3DjFvYtoQcRjszO+WYMP0TBlXw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5830
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Friday, June 9, 2023 6:27 AM
>=20
> On Fri,  2 Jun 2023 05:15:14 -0700
> Yi Liu <yi.l.liu@intel.com> wrote:
>=20
> > This allows VFIO_DEVICE_GET_PCI_HOT_RESET_INFO ioctl use the iommufd_ct=
x
> > of the cdev device to check the ownership of the other affected devices=
.
> >
> > When VFIO_DEVICE_GET_PCI_HOT_RESET_INFO is called on an IOMMUFD managed
> > device, the new flag VFIO_PCI_HOT_RESET_FLAG_DEV_ID is reported to indi=
cate
> > the values returned are IOMMUFD devids rather than group IDs as used wh=
en
> > accessing vfio devices through the conventional vfio group interface.
> > Additionally the flag VFIO_PCI_HOT_RESET_FLAG_DEV_ID_OWNED will be repo=
rted
> > in this mode if all of the devices affected by the hot-reset are owned =
by
> > either virtue of being directly bound to the same iommufd context as th=
e
> > calling device, or implicitly owned via a shared IOMMU group.
> >
> > Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> > Suggested-by: Alex Williamson <alex.williamson@redhat.com>
> > Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> > ---
> >  drivers/vfio/iommufd.c           | 49 +++++++++++++++++++++++++++++++
> >  drivers/vfio/pci/vfio_pci_core.c | 47 +++++++++++++++++++++++++-----
> >  include/linux/vfio.h             | 16 ++++++++++
> >  include/uapi/linux/vfio.h        | 50 +++++++++++++++++++++++++++++++-
> >  4 files changed, 154 insertions(+), 8 deletions(-)
> >
> > diff --git a/drivers/vfio/iommufd.c b/drivers/vfio/iommufd.c
> > index 88b00c501015..a04f3a493437 100644
> > --- a/drivers/vfio/iommufd.c
> > +++ b/drivers/vfio/iommufd.c
> > @@ -66,6 +66,55 @@ void vfio_iommufd_unbind(struct vfio_device *vdev)
> >  		vdev->ops->unbind_iommufd(vdev);
> >  }
> >
> > +struct iommufd_ctx *vfio_iommufd_device_ictx(struct vfio_device *vdev)
> > +{
> > +	if (vdev->iommufd_device)
> > +		return iommufd_device_to_ictx(vdev->iommufd_device);
> > +	return NULL;
> > +}
> > +EXPORT_SYMBOL_GPL(vfio_iommufd_device_ictx);
> > +
> > +static int vfio_iommufd_device_id(struct vfio_device *vdev)
> > +{
> > +	if (vdev->iommufd_device)
> > +		return iommufd_device_to_id(vdev->iommufd_device);
> > +	return -EINVAL;
>=20
> If this is actually reachable, it allows us to return -EINVAL as a
> devid in the reset-info ioctl, which is not a defined value.  Should
> this return VFIO_PCI_DEVID_NOT_OWNED or do you want to catch the errno
> value in the caller?  Thanks,

This error can be reached if user invokes _INFO or HOT_RESET on an emulated
device or a physical device that has not been bound to iommufd. Both should
be considered as not-owned. So return VFIO_PCI_DEVID_NOT_OWNED makes
more sense.

Regards,
Yi Liu

