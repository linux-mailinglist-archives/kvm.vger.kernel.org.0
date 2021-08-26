Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5D353F80DF
	for <lists+kvm@lfdr.de>; Thu, 26 Aug 2021 05:14:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229922AbhHZDPa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Aug 2021 23:15:30 -0400
Received: from mga09.intel.com ([134.134.136.24]:27307 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229533AbhHZDP3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Aug 2021 23:15:29 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10087"; a="217658944"
X-IronPort-AV: E=Sophos;i="5.84,352,1620716400"; 
   d="scan'208";a="217658944"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2021 20:14:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,352,1620716400"; 
   d="scan'208";a="537155147"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by fmsmga002.fm.intel.com with ESMTP; 25 Aug 2021 20:14:42 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Wed, 25 Aug 2021 20:14:41 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10 via Frontend Transport; Wed, 25 Aug 2021 20:14:41 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.108)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Wed, 25 Aug 2021 20:14:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GnmEABtNAU0lSSqKaoWM2ENsFMXp5s/c1QNB9n1xDRDEUFFM3KSRh/GWSa9AlfmhfgtmASg44qg3DIxDPACrmGjKghMWxSCqy1dwndAgRQjxjUDVIoYSB/cKUqhKm5kqI6FcAQisW2PxtRh0dvGTaH0I2PyxpHuPyZa6Ktb3wMZax74ucly9jE2E+pr4xcmWvDYwYc2tTLf0Pq7vJ4SMoJs+i3UvwuGi9Ucot8rBGAZVJ8Nc2co7coBwiS7gU635CutXhzCR6urxkT/1ruUH3+n13qUubBz1ivNdb0h8y1uNCLRfif7/5TcGG5fek6HyH7bnZYJAgtzUNVJcrky59Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=29RcurZrHKruA4HWb1gprakbbfS6QMF1xdj8/xZz4Zw=;
 b=C8kl2AiibGRJ2W8v/WpJPy3MxojtE6srqq+3yWvoUDX4cyubVTyZ3gemDUCZJcLbYm47BRb9hgkudgWtOm6jaGi716rJkrgqkmhL2/QAkOwuese6fVOlXc3DDeliYaPSVzeWCcNy5Xt/30Q1dLqAMdmIyEhljt1i8jsPOCtnML6bry6E+qjFEKq/atQQgFZB7jo/fjmSydawiRd3W0tFHK6nJSmVd6PfkCndBcdIZT77DQ3/QYWFwYZZ4xzAUoKcR1/Ed3HpsincwLn21oCc6EuhY8ahF/GqqnHxt+sTNWs7o7zB+YHkbKKsFE+nU3OrYHO+8bNQpfAFFa6ffghOkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=29RcurZrHKruA4HWb1gprakbbfS6QMF1xdj8/xZz4Zw=;
 b=aOqjY2ikhhtX3toAQ4ji182nIWz5aYLGmfq/kcvhICGI8kqznpc/7NFzWZ8wrp7QBSBbhWGm3F0eSlP/G/A9LWmnilWfyl7LtUTbiBozd6FDoQ0sPMgPPR/feYRERXCUnmiBF0718zkqRHxSQyTIpX6lwUDq2l2NbkD0NgzoJXM=
Received: from BN9PR11MB5433.namprd11.prod.outlook.com (2603:10b6:408:11e::13)
 by BN6PR11MB1267.namprd11.prod.outlook.com (2603:10b6:404:3d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.22; Thu, 26 Aug
 2021 03:14:39 +0000
Received: from BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::1508:e154:a267:2cce]) by BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::1508:e154:a267:2cce%5]) with mapi id 15.20.4436.024; Thu, 26 Aug 2021
 03:14:39 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Christoph Hellwig <hch@lst.de>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: RE: [PATCH 09/14] vfio: move the vfio_iommu_driver_ops interface out
 of <linux/vfio.h>
Thread-Topic: [PATCH 09/14] vfio: move the vfio_iommu_driver_ops interface out
 of <linux/vfio.h>
Thread-Index: AQHXmc8x3wPcxIDZj0SjVATsxK8KWquFHVFw
Date:   Thu, 26 Aug 2021 03:14:39 +0000
Message-ID: <BN9PR11MB543390C93192D299827E90128CC79@BN9PR11MB5433.namprd11.prod.outlook.com>
References: <20210825161916.50393-1-hch@lst.de>
 <20210825161916.50393-10-hch@lst.de>
In-Reply-To: <20210825161916.50393-10-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8c58431c-d613-49a9-bd25-08d9683fa431
x-ms-traffictypediagnostic: BN6PR11MB1267:
x-microsoft-antispam-prvs: <BN6PR11MB126738563B770AB53C533DBE8CC79@BN6PR11MB1267.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:655;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: z/gwitL50c/IeiZr9f5ljCqiWkE7sF904LG6Tx05G0LLCQ2w75yu9ZOUaxIcb4OQUcOq4ElqctRhrx1Dkfchi9cWoAgbNU/6UUFsVVigwliPRZjV7R00mN93RlyMnfYhgbkfMDsKt3Ivt7CxriesDMbpXG9kRDEVoUvb2vYo5CLciMwaCbnOM8QC5TV+lkv3PnJNS1is7pgyOBUqbbo+GFaV0BZxjPdNa/wFrtBAO+cS/tYAT6okGGzfkjAQlqHmo0Djd0dpXRj7Bob5dYCnXh0S+g4BD8xjSoeKbmnqDqvvuCWrHo7C1BP3HbkPThhUHAe6PmlC9AehDQQli2xCSWZDpsacNMYs9xc8VDnjTaOgiIfbpA0HkhBSCNjIXHz+hdlkX3Uxv1tedv9laPirH3o6E7vKXPmQYGpklpKnODW35P5fg/gv4pTHKoEu6g+5ukKB5HSLIem69N1AVAjurzRg3EO3e0YPn/6oUtXiPfSAV7O555IBhxroXslqpha2wMTmAGlDK6F5o39tV3/GfKARXsaoIaEC8fEelIAvAeFRC14HT1KAcPtUGDpS87P8ck1lafwJKZXb8BOiRC4FmjBz1lVdGynrBzKkXksjIlBUze3Y/dR3kR7yFAxe8j68mR73+v6h1A53ejActRCQS1phSFInkbzQNdmzN/ertGDdTMc1ZpDW2iXbKvl0VAASl8SHyfwme+Rj7IDu03dnGg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5433.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(366004)(346002)(136003)(376002)(76116006)(66476007)(66556008)(7696005)(38070700005)(186003)(66446008)(122000001)(8936002)(4326008)(64756008)(55016002)(66946007)(8676002)(316002)(9686003)(5660300002)(54906003)(26005)(110136005)(38100700002)(86362001)(33656002)(52536014)(71200400001)(478600001)(2906002)(6506007)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?L6yNykiG1YSw2kPAbbtYZ6tbBpUlhwTEBVj5fVtlKcJGnpNKzU2J2+ajcMUC?=
 =?us-ascii?Q?hV6aMgnfdQgLtA8EN0GX9j3buIBwYv16EIcyIOPEhiBOzrv/C/TQJkIWea2T?=
 =?us-ascii?Q?PlP3MCJuasKUrsX8qeQNE7EwXjBsdiFnS8mRaiwBLq+7C9y3xWRRcAjbl8Gk?=
 =?us-ascii?Q?aYdSNIJqZan1GVBM09ExzkDgqtAOBFcX3lHXvS4hTSAERG0uWV3geXvA69sJ?=
 =?us-ascii?Q?o9qPqPXeGMmtfNsNdlSuij0BBLBC97BWx6L/IVtoif1Xgrds3Z6RcJDIMzpb?=
 =?us-ascii?Q?z4bXltSftqyvGtNulPK2l36KRycrOL+B7t1ktYpEjCyHLtvQahNEZ7knKQmf?=
 =?us-ascii?Q?MX0g3Kqc2MfqdBDNe5K5IQxgncfL4CPNaGqh3aSjYFuqo/S6sBIJHTKlDWTe?=
 =?us-ascii?Q?9KJoAbUXnylFr5QBO7B4v1gtYh0q3EU8BbawuurJBIC9+clyob5KQXNbDdue?=
 =?us-ascii?Q?PpkNvjo9xMaWHrAYJR6KnaR01+mN4MhaKIotQVfg5HfmMAyO91CIh+fmmpx/?=
 =?us-ascii?Q?Vr8LzVX+6/n31D7U2sK9qIqYIgXe3iF62pkP86TNFrz+6EGRJQkjgeCrF1/+?=
 =?us-ascii?Q?lUCoc6W6eutcJZX2gjkRIiNHOp8SVozi7Afx8UQMw1TL3dHPg6IWyOo+Sqom?=
 =?us-ascii?Q?dnPtKNW8XxQaZT0nOAHXjW5JJ599qoCAkZ2/Utn8uZt6AzHwA7uVrz2vWIiV?=
 =?us-ascii?Q?JswCjU//+hpUxz5ofUceNLvF6wcngp9VKjwGXiD5kwqUx0ADV+9qXNUw7hTt?=
 =?us-ascii?Q?oP4Xu/WtATsq2opYA4P9qiavTYwtVRF6NRIG+rWwhFMrvWq7Pr+0vrtmLXvj?=
 =?us-ascii?Q?MrOrxn59RDZHLmbC0gpSoLubalow2DQcnOIarmLtOIyH6k8wGXFOLLRVaQ3v?=
 =?us-ascii?Q?lD7ih0bediumVOVrNpUwbGeZ9jfXygqBt72oYjKk5pnV5Pik8qpRFSvDwoUn?=
 =?us-ascii?Q?4CJ4od6UavklrZNmxcv2WpZokG0CfW3eArCs7Vkg79tRSCrzQNPkAL8a55d6?=
 =?us-ascii?Q?A4z942ABRzOSyL8olyKPniB0Dg8RvfyHw+DRne/vnT3YkBbQY2Fl/tLzFk/z?=
 =?us-ascii?Q?bVZyoFaXWqKxw41EO4iKi/wkM/ukblwliqKu4z6Him8BiobiG8mUuhCXvuE4?=
 =?us-ascii?Q?VgN/DxpGSm1XWZy1XdfyLozHtrMcSMszBjTEuJVKLgpoooQL6e8BPNBaYwUx?=
 =?us-ascii?Q?IL5H14XJRDa+TlhlmeKoOB2qypDidpP6skLAbGI0XMDalFe00y8/HuWiL0uX?=
 =?us-ascii?Q?EJtsd2bIsioMc6DIkCVIeRKutapI0RXCSatHXuK8oQaLDJX4ZoQY90GLJZ5S?=
 =?us-ascii?Q?wDKnlFf9rv4/TuxZLDnfojRZ?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5433.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c58431c-d613-49a9-bd25-08d9683fa431
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Aug 2021 03:14:39.5362
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GjxvxZzwHjna668Zmk8oUDVZkkgMV0Gh13jaKSzq6AOOXN7B1P+LI5/D1skQMfCXbspl+xHAqsFDowFqcB86Xg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB1267
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Christoph Hellwig <hch@lst.de>
> Sent: Thursday, August 26, 2021 12:19 AM
>=20
> Create a new private drivers/vfio/vfio.h header for the interface between
> the VFIO core and the iommu drivers.
>=20
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

> ---
>  drivers/vfio/vfio.c                 |  1 +
>  drivers/vfio/vfio.h                 | 47 +++++++++++++++++++++++++++++
>  drivers/vfio/vfio_iommu_spapr_tce.c |  1 +
>  drivers/vfio/vfio_iommu_type1.c     |  1 +
>  include/linux/vfio.h                | 44 ---------------------------
>  5 files changed, 50 insertions(+), 44 deletions(-)
>  create mode 100644 drivers/vfio/vfio.h
>=20
> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> index 7b9629cbbf0e80..f73158fce8c446 100644
> --- a/drivers/vfio/vfio.c
> +++ b/drivers/vfio/vfio.c
> @@ -32,6 +32,7 @@
>  #include <linux/vfio.h>
>  #include <linux/wait.h>
>  #include <linux/sched/signal.h>
> +#include "vfio.h"
>=20
>  #define DRIVER_VERSION	"0.3"
>  #define DRIVER_AUTHOR	"Alex Williamson
> <alex.williamson@redhat.com>"
> diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
> new file mode 100644
> index 00000000000000..a78de649eb2f16
> --- /dev/null
> +++ b/drivers/vfio/vfio.h
> @@ -0,0 +1,47 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Copyright (C) 2012 Red Hat, Inc.  All rights reserved.
> + *     Author: Alex Williamson <alex.williamson@redhat.com>
> + */
> +
> +/* events for the backend driver notify callback */
> +enum vfio_iommu_notify_type {
> +	VFIO_IOMMU_CONTAINER_CLOSE =3D 0,
> +};
> +
> +/**
> + * struct vfio_iommu_driver_ops - VFIO IOMMU driver callbacks
> + */
> +struct vfio_iommu_driver_ops {
> +	char		*name;
> +	struct module	*owner;
> +	void		*(*open)(unsigned long arg);
> +	void		(*release)(void *iommu_data);
> +	long		(*ioctl)(void *iommu_data, unsigned int cmd,
> +				 unsigned long arg);
> +	int		(*attach_group)(void *iommu_data,
> +					struct iommu_group *group);
> +	void		(*detach_group)(void *iommu_data,
> +					struct iommu_group *group);
> +	int		(*pin_pages)(void *iommu_data,
> +				     struct iommu_group *group,
> +				     unsigned long *user_pfn,
> +				     int npage, int prot,
> +				     unsigned long *phys_pfn);
> +	int		(*unpin_pages)(void *iommu_data,
> +				       unsigned long *user_pfn, int npage);
> +	int		(*register_notifier)(void *iommu_data,
> +					     unsigned long *events,
> +					     struct notifier_block *nb);
> +	int		(*unregister_notifier)(void *iommu_data,
> +					       struct notifier_block *nb);
> +	int		(*dma_rw)(void *iommu_data, dma_addr_t
> user_iova,
> +				  void *data, size_t count, bool write);
> +	struct iommu_domain *(*group_iommu_domain)(void
> *iommu_data,
> +						   struct iommu_group
> *group);
> +	void		(*notify)(void *iommu_data,
> +				  enum vfio_iommu_notify_type event);
> +};
> +
> +int vfio_register_iommu_driver(const struct vfio_iommu_driver_ops *ops);
> +void vfio_unregister_iommu_driver(const struct vfio_iommu_driver_ops
> *ops);
> diff --git a/drivers/vfio/vfio_iommu_spapr_tce.c
> b/drivers/vfio/vfio_iommu_spapr_tce.c
> index fe888b5dcc0062..3efd09faeca4a8 100644
> --- a/drivers/vfio/vfio_iommu_spapr_tce.c
> +++ b/drivers/vfio/vfio_iommu_spapr_tce.c
> @@ -20,6 +20,7 @@
>  #include <linux/sched/mm.h>
>  #include <linux/sched/signal.h>
>  #include <linux/mm.h>
> +#include "vfio.h"
>=20
>  #include <asm/iommu.h>
>  #include <asm/tce.h>
> diff --git a/drivers/vfio/vfio_iommu_type1.c
> b/drivers/vfio/vfio_iommu_type1.c
> index 0b4f7c174c7a2b..92777797578e50 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -40,6 +40,7 @@
>  #include <linux/notifier.h>
>  #include <linux/dma-iommu.h>
>  #include <linux/irqdomain.h>
> +#include "vfio.h"
>=20
>  #define DRIVER_VERSION  "0.2"
>  #define DRIVER_AUTHOR   "Alex Williamson
> <alex.williamson@redhat.com>"
> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> index 7a57a0077f9637..76191d7abed185 100644
> --- a/include/linux/vfio.h
> +++ b/include/linux/vfio.h
> @@ -82,50 +82,6 @@ extern void vfio_device_put(struct vfio_device
> *device);
>=20
>  int vfio_assign_device_set(struct vfio_device *device, void *set_id);
>=20
> -/* events for the backend driver notify callback */
> -enum vfio_iommu_notify_type {
> -	VFIO_IOMMU_CONTAINER_CLOSE =3D 0,
> -};
> -
> -/**
> - * struct vfio_iommu_driver_ops - VFIO IOMMU driver callbacks
> - */
> -struct vfio_iommu_driver_ops {
> -	char		*name;
> -	struct module	*owner;
> -	void		*(*open)(unsigned long arg);
> -	void		(*release)(void *iommu_data);
> -	long		(*ioctl)(void *iommu_data, unsigned int cmd,
> -				 unsigned long arg);
> -	int		(*attach_group)(void *iommu_data,
> -					struct iommu_group *group);
> -	void		(*detach_group)(void *iommu_data,
> -					struct iommu_group *group);
> -	int		(*pin_pages)(void *iommu_data,
> -				     struct iommu_group *group,
> -				     unsigned long *user_pfn,
> -				     int npage, int prot,
> -				     unsigned long *phys_pfn);
> -	int		(*unpin_pages)(void *iommu_data,
> -				       unsigned long *user_pfn, int npage);
> -	int		(*register_notifier)(void *iommu_data,
> -					     unsigned long *events,
> -					     struct notifier_block *nb);
> -	int		(*unregister_notifier)(void *iommu_data,
> -					       struct notifier_block *nb);
> -	int		(*dma_rw)(void *iommu_data, dma_addr_t
> user_iova,
> -				  void *data, size_t count, bool write);
> -	struct iommu_domain *(*group_iommu_domain)(void
> *iommu_data,
> -						   struct iommu_group
> *group);
> -	void		(*notify)(void *iommu_data,
> -				  enum vfio_iommu_notify_type event);
> -};
> -
> -extern int vfio_register_iommu_driver(const struct vfio_iommu_driver_ops
> *ops);
> -
> -extern void vfio_unregister_iommu_driver(
> -				const struct vfio_iommu_driver_ops *ops);
> -
>  /*
>   * External user API
>   */
> --
> 2.30.2

