Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A50B33CEED
	for <lists+kvm@lfdr.de>; Tue, 16 Mar 2021 08:55:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233227AbhCPHzW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Mar 2021 03:55:22 -0400
Received: from mga12.intel.com ([192.55.52.136]:30479 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233298AbhCPHzQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Mar 2021 03:55:16 -0400
IronPort-SDR: 7bPvs/b0zMe26PM9tEvlykv8BrM+yJ4qOOH0GXUgFMS+7RxHhsOkNg/bKxSWUEH+KYDKgYiyed
 OFZNn38hzUBg==
X-IronPort-AV: E=McAfee;i="6000,8403,9924"; a="168490948"
X-IronPort-AV: E=Sophos;i="5.81,251,1610438400"; 
   d="scan'208";a="168490948"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2021 00:55:15 -0700
IronPort-SDR: T1Hd8uBTfGoRHSpNg72tvtMDRFEpw9z2dGmmT7uNnQLJoZDPkfEYw8oovnqbB4lpGw5heAAnWl
 TSoxrlFGuELw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,251,1610438400"; 
   d="scan'208";a="590573797"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by orsmga005.jf.intel.com with ESMTP; 16 Mar 2021 00:55:14 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 16 Mar 2021 00:55:14 -0700
Received: from fmsmsx604.amr.corp.intel.com (10.18.126.84) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 16 Mar 2021 00:55:13 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Tue, 16 Mar 2021 00:55:13 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.42) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2106.2; Tue, 16 Mar 2021 00:55:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SBZHhD8f2yxSNN0U6mC7Qg26vdNQvJuQI9KdSBQ3pKCt2LFY5ITIQpVydjbS5k58uzchVEkoyE9bMIxo2/A54ybULPRO5V7GoBXub49Gfqz/sAvxQ87JC+W8joQzCzOaTNa/V/zEJiOpvEDCJYOrZUDk9QVcjgoRl+rSm760893RgvdKq5I6eu5BSJI2hnZRL3N5HdaXOAJjR79cp4QmQSsb7skUQaiQskLlsp3bdsa+nQ66Y9B7NHyzKSAkECBA2qacDibfJE1yWtkoC0Xxq/2h55EXiOlkvLBWcJPKaVxMpTEws9lsaHJYK+xcJRXRFBI8vtWI2muO9HykrLtv6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ujM3JGo9VEYP1TYy4/v79Ro+l+efsJby9uH6/b8Usvc=;
 b=ahkdDNXj4BN8k4lpNTOkmAvs/xKV7S1xR4iPTQo8DrTGWLsOVchKwrcTzZwkpmPVFdi52JgqX+5XopXo/wqSTrnIc93LsVq1fqhiWopBVBCIyr9Kw5C+IdUqE1RfBvQahPw0TQKVhaOJDhwGOeGqQ1vJVQJwseD7TnrTGwC0xzqR8+lSbYp1IRytAm0adxKckVVXI2+ckf5PuHk+HjjqbJ+8TdoIYG7v1oSJxob0siv/4t2UcRo37+K9INbuONJ7D0YkL7uG5D68dbTMiBJmaHEqsTc6UHwSVlrH0nhKbhYZEGgeyoTCAkRm4Q7rkhoNKQBOoCQs/KZxViDXutjsQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ujM3JGo9VEYP1TYy4/v79Ro+l+efsJby9uH6/b8Usvc=;
 b=c0fw9QqNc6TTJG1FfCJ7ZpwtgYOQSXoTLNIiwSKirTdBTstQrROCgUHt9YAugSVXADur48Vh+vTJ7GWS4i0ZUaxzjDGm2nGUtbRjdQzmp0MQOpnHsrITHOEowVmdUmRxSVKzsdos4SoD0iWIcSTZr1itsA8uiE/6VwIcMJZoBFc=
Received: from MWHPR11MB1886.namprd11.prod.outlook.com (2603:10b6:300:110::9)
 by CO1PR11MB5154.namprd11.prod.outlook.com (2603:10b6:303:95::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.31; Tue, 16 Mar
 2021 07:55:12 +0000
Received: from MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::75b0:a8e9:60cb:7a29]) by MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::75b0:a8e9:60cb:7a29%9]) with mapi id 15.20.3933.032; Tue, 16 Mar 2021
 07:55:11 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "Jonathan Corbet" <corbet@lwn.net>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
CC:     "Raj, Ashok" <ashok.raj@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        "Christoph Hellwig" <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>
Subject: RE: [PATCH v2 03/14] vfio: Split creation of a vfio_device into init
 and register ops
Thread-Topic: [PATCH v2 03/14] vfio: Split creation of a vfio_device into init
 and register ops
Thread-Index: AQHXF6PxoJBvqnz7JkaCSbwgmarIu6qGQCyA
Date:   Tue, 16 Mar 2021 07:55:11 +0000
Message-ID: <MWHPR11MB188641760EE646AF47CABB6B8C6B9@MWHPR11MB1886.namprd11.prod.outlook.com>
References: <0-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
 <3-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
In-Reply-To: <3-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.147.218]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 38d0419b-def2-4741-6ced-08d8e850d3aa
x-ms-traffictypediagnostic: CO1PR11MB5154:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CO1PR11MB5154E73A1C73B1D28A0A7C128C6B9@CO1PR11MB5154.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SdmTvYKB2ZixIIsvT8IYoAmpVfEGQuASdCkNfRKh2V1y4X1/qvW3c/RwB1mtdetCzK0WdKEkSO82eRJzTNTniIbryloQdYWg3jOgan2NK3tOdi7Ym4p4rzMbvLGfIJUCsi+H3HXFRzx023ytOaHQOwt0pPXkbI5Dv2iF+4neqfyV8Na5wJ1hpn7Ah0DZMjOEvGqJuRSanad0Ho1hnkJirYDMHuGaYuyRzpSSlG87FNH7JK2ohai65z7Vt+LRIWq4xJbSKq9SJllM/q3YngsRr62fXvOg44UQXL+rJ1bUyFhyV/FWtmbo5zdw77X6R8280ta4CiU8pexolnW7aGsg3xQ0qyYO0DvlN3PuTMMsCew9rwrHfgz5xqwlpCMDQ01SNyxc48ROk/Q+BOQS2my1Awu+DrO+11ceQQrPm8JImieyzRd8oFRHXmbrzS/hOoFIF+wHDO8LkNGIxm6sL5QeSZzJRbqhoC88Vo9NIARP6ZRZX5QuXyIdX34Dhk7c1hIx8z3UneSC7fe3U0F9xA3aMN/+RPpQ0izAoG4qb/Vdg2lZf5ZwoJJUgkFPy7jOTyeS
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1886.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(366004)(396003)(346002)(376002)(6506007)(5660300002)(2906002)(26005)(186003)(64756008)(30864003)(7696005)(54906003)(7416002)(71200400001)(66446008)(55016002)(76116006)(4326008)(83380400001)(9686003)(86362001)(478600001)(110136005)(66476007)(66556008)(8676002)(52536014)(66946007)(33656002)(8936002)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?rGPdct6TdZgDziVXgCeVaIB6GJT6gDqwW4AdwAm4D6DR3t5zK3j7n7dCPmpQ?=
 =?us-ascii?Q?qoHrHhkmw+b0pkj9/WJYi+eyroYVl5nkG8O6BYKm/OdVkZHM7YnyBGXmvusT?=
 =?us-ascii?Q?iZtBek53yf6jkFVpthIFwHCVjj6+1PlhTfTzsOvANnXbieJXt1Kmvk5dsU07?=
 =?us-ascii?Q?CAt3cOE0aStBrjGS5DDgnLQAdqDa/aeoFAe9v1J1nLDAcqblOwJ9uxjQ1XVI?=
 =?us-ascii?Q?hz+q+qzYIZ+r4Web1fR/llCB4igUGf1z9dAzS0h6GsgqKk6AMgoX+mOjdayv?=
 =?us-ascii?Q?r3ndFHuqS4m2kDOYP6CMn+mD3Q3QIkQ7wSlvpZ7R5HMyBN7UmF3ifW0tWZJa?=
 =?us-ascii?Q?gTJD3dSwn9jU/OsHMKYdEFhnqzkj6f73sEkNhW+DrIZpIXmMMHe/PEYGzr6s?=
 =?us-ascii?Q?gbwOK76UHpQPX+oMqzfkPdYep4A5KlzWi2MepxJJr0AmXupIuJGcz1qeiLey?=
 =?us-ascii?Q?YoAfzDMNMFWQdbtqK8bXVpko6oF5wxgBTmnYpGGsSXbT6VkZA5tRs1930QcP?=
 =?us-ascii?Q?LdM4sKf09ewvihsNZ0g1Vmq6c4fiGeU1a2RPUy352zj3lDKR72ValKeVVBdT?=
 =?us-ascii?Q?Tb8sTd6jfMa3PDGfyfxpyL54mVOkht6Ql2yKDHWfnITYSJ97YHZOHQfJ5BmV?=
 =?us-ascii?Q?31TJrjmUeVIc4sUYoj6QhqWJKk/90VuUgyMJsHLM724vCdXTC9meEOTD6iDL?=
 =?us-ascii?Q?qNrMZO838vDR7BCvyuGh+QegAaDQNUBVFDdLQxNIHU6BLLINk41aMRq6iPo3?=
 =?us-ascii?Q?av+L1qX94Mu3N9XuqLtJTwue+RVXcljwnN02yHGSKmw4o3O5d85ljYxdzigM?=
 =?us-ascii?Q?/qHGjZEeRhfVnA0lm3RfU534YP8G3e1UKXqpcb4jTlGRRaCdBE1TAoPYEwtV?=
 =?us-ascii?Q?lrTHy9Tu+dioBSEgVAa7zYV0bkVf8l27ZH9SJU8GMr80+FTQ5rC6QlxTeWI+?=
 =?us-ascii?Q?+p6Wcs/v6szp1xxCVwdOegfTPa5Wc349YjYLAdueqomXxFmO8Kmz+9EMa/Ts?=
 =?us-ascii?Q?YP0v8VmJaTQnoV9uzMAdHDYtNC3T0halCy/Mj3kJd09HmBgXD7qXfakyuryI?=
 =?us-ascii?Q?om4TU4hNM2ZepkgGfy4Tru6YW2w8sbH0jq97ykTzXZIshFcdupgb51LQitoX?=
 =?us-ascii?Q?1AVRzf+KSN5Ep4BVukCxwLKd75dQ+w1NnqwMkU2ntcyQKGFZi5o0ie5xfktP?=
 =?us-ascii?Q?4vE3oOhzrjKtlewuR/2zSA89WFsPgvbebvUcdnJ6VUtYL5LPa8qbuGNXw0Be?=
 =?us-ascii?Q?0azts6zYqeprRu0DTkgScqgYd2IDIM3WHU+txiqyQT9CxXYC52c+U3akt8mW?=
 =?us-ascii?Q?IphHYRxO0/mBHhDep0NVwii6?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1886.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 38d0419b-def2-4741-6ced-08d8e850d3aa
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Mar 2021 07:55:11.7935
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mpafgkokll3DWKAaFvvJESOqQY/uvTX+vmDNfw6E6MHi3NglbEIrR2cZ0s9HDqAkfhDjeRjN6H41NKy42t1ojQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5154
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Saturday, March 13, 2021 8:56 AM
>=20
> This makes the struct vfio_pci_device part of the public interface so it
> can be used with container_of and so forth, as is typical for a Linux
> subystem.
>=20
> This is the first step to bring some type-safety to the vfio interface by
> allowing the replacement of 'void *' and 'struct device *' inputs with a
> simple and clear 'struct vfio_pci_device *'
>=20
> For now the self-allocating vfio_add_group_dev() interface is kept so eac=
h
> user can be updated as a separate patch.
>=20
> The expected usage pattern is
>=20
>   driver core probe() function:
>      my_device =3D kzalloc(sizeof(*mydevice));
>      vfio_init_group_dev(&my_device->vdev, dev, ops, mydevice);
>      /* other driver specific prep */
>      vfio_register_group_dev(&my_device->vdev);
>      dev_set_drvdata(my_device);

dev_set_drvdata(dev, my_device);

>=20
>   driver core remove() function:
>      my_device =3D dev_get_drvdata(dev);
>      vfio_unregister_group_dev(&my_device->vdev);
>      /* other driver specific tear down */
>      kfree(my_device);
>=20
> Allowing the driver to be able to use the drvdata and vifo_device to go
> to/from its own data.
>=20
> The pattern also makes it clear that vfio_register_group_dev() must be
> last in the sequence, as once it is called the core code can immediately
> start calling ops. The init/register gap is provided to allow for the
> driver to do setup before ops can be called and thus avoid races.
>=20
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Liu Yi L <yi.l.liu@intel.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  Documentation/driver-api/vfio.rst |  31 ++++----
>  drivers/vfio/vfio.c               | 123 ++++++++++++++++--------------
>  include/linux/vfio.h              |  16 ++++
>  3 files changed, 98 insertions(+), 72 deletions(-)
>=20
> diff --git a/Documentation/driver-api/vfio.rst b/Documentation/driver-
> api/vfio.rst
> index f1a4d3c3ba0bb1..d3a02300913a7f 100644
> --- a/Documentation/driver-api/vfio.rst
> +++ b/Documentation/driver-api/vfio.rst
> @@ -249,18 +249,23 @@ VFIO bus driver API
>=20
>  VFIO bus drivers, such as vfio-pci make use of only a few interfaces
>  into VFIO core.  When devices are bound and unbound to the driver,
> -the driver should call vfio_add_group_dev() and vfio_del_group_dev()
> -respectively::
> -
> -	extern int vfio_add_group_dev(struct device *dev,
> -				      const struct vfio_device_ops *ops,
> -				      void *device_data);
> -
> -	extern void *vfio_del_group_dev(struct device *dev);
> -
> -vfio_add_group_dev() indicates to the core to begin tracking the
> -iommu_group of the specified dev and register the dev as owned by
> -a VFIO bus driver.  The driver provides an ops structure for callbacks
> +the driver should call vfio_register_group_dev() and
> +vfio_unregister_group_dev() respectively::
> +
> +	void vfio_init_group_dev(struct vfio_device *device,
> +				struct device *dev,
> +				const struct vfio_device_ops *ops,
> +				void *device_data);
> +	int vfio_register_group_dev(struct vfio_device *device);
> +	void vfio_unregister_group_dev(struct vfio_device *device);
> +
> +The driver should embed the vfio_device in its own structure and call
> +vfio_init_group_dev() to pre-configure it before going to registration.
> +vfio_register_group_dev() indicates to the core to begin tracking the
> +iommu_group of the specified dev and register the dev as owned by a VFIO
> bus
> +driver. Once vfio_register_group_dev() returns it is possible for usersp=
ace
> to
> +start accessing the driver, thus the driver should ensure it is complete=
ly
> +ready before calling it. The driver provides an ops structure for callba=
cks
>  similar to a file operations structure::
>=20
>  	struct vfio_device_ops {
> @@ -276,7 +281,7 @@ similar to a file operations structure::
>  	};
>=20
>  Each function is passed the device_data that was originally registered
> -in the vfio_add_group_dev() call above.  This allows the bus driver
> +in the vfio_register_group_dev() call above.  This allows the bus driver
>  an easy place to store its opaque, private data.  The open/release
>  callbacks are issued when a new file descriptor is created for a
>  device (via VFIO_GROUP_GET_DEVICE_FD).  The ioctl interface provides
> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> index 32660e8a69ae20..cfa06ae3b9018b 100644
> --- a/drivers/vfio/vfio.c
> +++ b/drivers/vfio/vfio.c
> @@ -89,16 +89,6 @@ struct vfio_group {
>  	struct blocking_notifier_head	notifier;
>  };
>=20
> -struct vfio_device {
> -	refcount_t			refcount;
> -	struct completion		comp;
> -	struct device			*dev;
> -	const struct vfio_device_ops	*ops;
> -	struct vfio_group		*group;
> -	struct list_head		group_next;
> -	void				*device_data;
> -};
> -
>  #ifdef CONFIG_VFIO_NOIOMMU
>  static bool noiommu __read_mostly;
>  module_param_named(enable_unsafe_noiommu_mode,
> @@ -532,35 +522,6 @@ static struct vfio_group
> *vfio_group_get_from_dev(struct device *dev)
>  /**
>   * Device objects - create, release, get, put, search
>   */
> -static
> -struct vfio_device *vfio_group_create_device(struct vfio_group *group,
> -					     struct device *dev,
> -					     const struct vfio_device_ops *ops,
> -					     void *device_data)
> -{
> -	struct vfio_device *device;
> -
> -	device =3D kzalloc(sizeof(*device), GFP_KERNEL);
> -	if (!device)
> -		return ERR_PTR(-ENOMEM);
> -
> -	refcount_set(&device->refcount, 1);
> -	init_completion(&device->comp);
> -	device->dev =3D dev;
> -	/* Our reference on group is moved to the device */
> -	device->group =3D group;
> -	device->ops =3D ops;
> -	device->device_data =3D device_data;
> -	dev_set_drvdata(dev, device);
> -
> -	mutex_lock(&group->device_lock);
> -	list_add(&device->group_next, &group->device_list);
> -	group->dev_counter++;
> -	mutex_unlock(&group->device_lock);
> -
> -	return device;
> -}
> -
>  /* Device reference always implies a group reference */
>  void vfio_device_put(struct vfio_device *device)
>  {
> @@ -779,14 +740,23 @@ static int vfio_iommu_group_notifier(struct
> notifier_block *nb,
>  /**
>   * VFIO driver API
>   */
> -int vfio_add_group_dev(struct device *dev,
> -		       const struct vfio_device_ops *ops, void *device_data)
> +void vfio_init_group_dev(struct vfio_device *device, struct device *dev,
> +			 const struct vfio_device_ops *ops, void *device_data)
> +{
> +	init_completion(&device->comp);
> +	device->dev =3D dev;
> +	device->ops =3D ops;
> +	device->device_data =3D device_data;
> +}
> +EXPORT_SYMBOL_GPL(vfio_init_group_dev);
> +
> +int vfio_register_group_dev(struct vfio_device *device)
>  {
> +	struct vfio_device *existing_device;
>  	struct iommu_group *iommu_group;
>  	struct vfio_group *group;
> -	struct vfio_device *device;
>=20
> -	iommu_group =3D iommu_group_get(dev);
> +	iommu_group =3D iommu_group_get(device->dev);
>  	if (!iommu_group)
>  		return -EINVAL;
>=20
> @@ -805,21 +775,50 @@ int vfio_add_group_dev(struct device *dev,
>  		iommu_group_put(iommu_group);
>  	}
>=20
> -	device =3D vfio_group_get_device(group, dev);
> -	if (device) {
> -		dev_WARN(dev, "Device already exists on group %d\n",
> +	existing_device =3D vfio_group_get_device(group, device->dev);
> +	if (existing_device) {
> +		dev_WARN(device->dev, "Device already exists on
> group %d\n",
>  			 iommu_group_id(iommu_group));
> -		vfio_device_put(device);
> +		vfio_device_put(existing_device);
>  		vfio_group_put(group);
>  		return -EBUSY;
>  	}
>=20
> -	device =3D vfio_group_create_device(group, dev, ops, device_data);
> -	if (IS_ERR(device)) {
> -		vfio_group_put(group);
> -		return PTR_ERR(device);
> -	}
> +	/* Our reference on group is moved to the device */
> +	device->group =3D group;
> +
> +	/* Refcounting can't start until the driver calls register */
> +	refcount_set(&device->refcount, 1);
> +
> +	mutex_lock(&group->device_lock);
> +	list_add(&device->group_next, &group->device_list);
> +	group->dev_counter++;
> +	mutex_unlock(&group->device_lock);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(vfio_register_group_dev);
> +
> +int vfio_add_group_dev(struct device *dev, const struct vfio_device_ops
> *ops,
> +		       void *device_data)
> +{
> +	struct vfio_device *device;
> +	int ret;
> +
> +	device =3D kzalloc(sizeof(*device), GFP_KERNEL);
> +	if (!device)
> +		return -ENOMEM;
> +
> +	vfio_init_group_dev(device, dev, ops, device_data);
> +	ret =3D vfio_register_group_dev(device);
> +	if (ret)
> +		goto err_kfree;
> +	dev_set_drvdata(dev, device);
>  	return 0;
> +
> +err_kfree:
> +	kfree(device);
> +	return ret;
>  }
>  EXPORT_SYMBOL_GPL(vfio_add_group_dev);
>=20
> @@ -887,11 +886,9 @@ EXPORT_SYMBOL_GPL(vfio_device_data);
>  /*
>   * Decrement the device reference count and wait for the device to be
>   * removed.  Open file descriptors for the device... */
> -void *vfio_del_group_dev(struct device *dev)
> +void vfio_unregister_group_dev(struct vfio_device *device)
>  {
> -	struct vfio_device *device =3D dev_get_drvdata(dev);
>  	struct vfio_group *group =3D device->group;
> -	void *device_data =3D device->device_data;
>  	struct vfio_unbound_dev *unbound;
>  	unsigned int i =3D 0;
>  	bool interrupted =3D false;
> @@ -908,7 +905,7 @@ void *vfio_del_group_dev(struct device *dev)
>  	 */
>  	unbound =3D kzalloc(sizeof(*unbound), GFP_KERNEL);
>  	if (unbound) {
> -		unbound->dev =3D dev;
> +		unbound->dev =3D device->dev;
>  		mutex_lock(&group->unbound_lock);
>  		list_add(&unbound->unbound_next, &group->unbound_list);
>  		mutex_unlock(&group->unbound_lock);
> @@ -919,7 +916,7 @@ void *vfio_del_group_dev(struct device *dev)
>  	rc =3D try_wait_for_completion(&device->comp);
>  	while (rc <=3D 0) {
>  		if (device->ops->request)
> -			device->ops->request(device_data, i++);
> +			device->ops->request(device->device_data, i++);
>=20
>  		if (interrupted) {
>  			rc =3D wait_for_completion_timeout(&device->comp,
> @@ -929,7 +926,7 @@ void *vfio_del_group_dev(struct device *dev)
>  				&device->comp, HZ * 10);
>  			if (rc < 0) {
>  				interrupted =3D true;
> -				dev_warn(dev,
> +				dev_warn(device->dev,
>  					 "Device is currently in use, task"
>  					 " \"%s\" (%d) "
>  					 "blocked until device is released",
> @@ -962,9 +959,17 @@ void *vfio_del_group_dev(struct device *dev)
>=20
>  	/* Matches the get in vfio_group_create_device() */
>  	vfio_group_put(group);
> +}
> +EXPORT_SYMBOL_GPL(vfio_unregister_group_dev);
> +
> +void *vfio_del_group_dev(struct device *dev)
> +{
> +	struct vfio_device *device =3D dev_get_drvdata(dev);
> +	void *device_data =3D device->device_data;
> +
> +	vfio_unregister_group_dev(device);
>  	dev_set_drvdata(dev, NULL);

Move to vfio_unregister_group_dev? In the cover letter you mentioned
that drvdata is managed by the driver but removed from the core. Looks
it's also the rule obeyed by the following patches.

Thanks
Kevin

>  	kfree(device);
> -
>  	return device_data;
>  }
>  EXPORT_SYMBOL_GPL(vfio_del_group_dev);
> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> index b7e18bde5aa8b3..ad8b579d67d34a 100644
> --- a/include/linux/vfio.h
> +++ b/include/linux/vfio.h
> @@ -15,6 +15,18 @@
>  #include <linux/poll.h>
>  #include <uapi/linux/vfio.h>
>=20
> +struct vfio_device {
> +	struct device *dev;
> +	const struct vfio_device_ops *ops;
> +	struct vfio_group *group;
> +
> +	/* Members below here are private, not for driver use */
> +	refcount_t refcount;
> +	struct completion comp;
> +	struct list_head group_next;
> +	void *device_data;
> +};
> +
>  /**
>   * struct vfio_device_ops - VFIO bus driver device callbacks
>   *
> @@ -48,11 +60,15 @@ struct vfio_device_ops {
>  extern struct iommu_group *vfio_iommu_group_get(struct device *dev);
>  extern void vfio_iommu_group_put(struct iommu_group *group, struct
> device *dev);
>=20
> +void vfio_init_group_dev(struct vfio_device *device, struct device *dev,
> +			 const struct vfio_device_ops *ops, void
> *device_data);
> +int vfio_register_group_dev(struct vfio_device *device);
>  extern int vfio_add_group_dev(struct device *dev,
>  			      const struct vfio_device_ops *ops,
>  			      void *device_data);
>=20
>  extern void *vfio_del_group_dev(struct device *dev);
> +void vfio_unregister_group_dev(struct vfio_device *device);
>  extern struct vfio_device *vfio_device_get_from_dev(struct device *dev);
>  extern void vfio_device_put(struct vfio_device *device);
>  extern void *vfio_device_data(struct vfio_device *device);
> --
> 2.30.2

