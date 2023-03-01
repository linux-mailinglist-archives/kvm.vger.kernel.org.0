Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81AE46A69B5
	for <lists+kvm@lfdr.de>; Wed,  1 Mar 2023 10:22:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229841AbjCAJWU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Mar 2023 04:22:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229768AbjCAJWR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Mar 2023 04:22:17 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 047F33B0EC;
        Wed,  1 Mar 2023 01:22:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677662535; x=1709198535;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Jvb3slMFhBtyxl/EuoQC0ZQryjRUM4ErECjZshTM0vw=;
  b=DDu2rBHwp7dBu+u/sXWMen1Nft3MGczDuVMwP0+kCQ5tnfuaow57KoYF
   tm9MFjVxifygRcYig9pk5IG7vpC0kh9OIZqjZ31x1H5jaUQ6CTGo8c6wE
   0dXiuRzGXvicgopf5eqnYC6VYf3EGrVyWHNWWlGvEKrpKVUuUQoG3Z3EF
   95u8o6O0v28FzqyfYHMn0E1NLQTVQOHb1xSWLbQ0MzstP8kStdsBvB3Dx
   onZc6CsWBDxBGfcl4x09BKUX754Waw7sqomRp3TqWMbiUwWTlD8rrsz3F
   f4239PkCvcInvhqo3dxGeWWoPtSiVUnp7Tha94vQtHMkZ8kmRHq7uUbu5
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10635"; a="314784767"
X-IronPort-AV: E=Sophos;i="5.98,224,1673942400"; 
   d="scan'208";a="314784767"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2023 01:22:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10635"; a="676691011"
X-IronPort-AV: E=Sophos;i="5.98,224,1673942400"; 
   d="scan'208";a="676691011"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga007.fm.intel.com with ESMTP; 01 Mar 2023 01:22:14 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 1 Mar 2023 01:22:14 -0800
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 1 Mar 2023 01:22:13 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Wed, 1 Mar 2023 01:22:13 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.175)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 1 Mar 2023 01:22:13 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YV0M/4pnfZdVBW94a/Uvo6j/0sYxltZzzgojQny47V/TmJVH8IGcYh6SPl1CCqAKWA5Hug+edawAmDzEIZhhAQ9H7DPeY/l7G8INpTvLNvEbIh5NnOdrsuPCf26jF+03qUtLUZnki8abe9VahG3XktsciUnLXr+ySkp67oIDeLPGeA9x60Bxynq8vk469LeMYUUYUsbHibIq2DWmSyIo2aJHQ5peQNUV2UMQJrGEbYLllDF7chfCfkxw8/KYuJgZhD1mBIWRGpeBzJzrYqjmhmu+wr48BcWLUkgqsnDXBTe0Vrsbj7DRfTvrxtHaRoRWixM5RU5y7zsKRpOXSQZ2OA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FId6KugbgoVjmAkyLHc5kEGXhJlmGKzb2mKy6scXIfY=;
 b=dgCNRQydc+MRnpTibFfgu//u/ZGhBZOHynSlfxgDesthOQdUEuaQmOrsW/9e6nyi1hOyT7XclSyXNu1iUmszV9oIuij/xFCKqi5C/V2re+aXeGshp3+3nkughDA3GfqU/MkzpNBz6ZEwi5GcVGxVKyrIq8yetySxjZ0qOzUEVNRSBD3LaNaggZumhe4QFQGqTVdSHVoP/db0b8hdX259Mqe40UzBRGMQtOeLPr/bfs5C1bGU1DCXTTQlUwARE6TQcynixjfXNCwUBbA0zfnqFhByGEqMrPoiff4ZFYL3pByCMKWhfmNEqc21JyM7B3aHu/+8MFADDDuMw6WGjEmyxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by SA2PR11MB5148.namprd11.prod.outlook.com (2603:10b6:806:11e::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.18; Wed, 1 Mar
 2023 09:22:12 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f%8]) with mapi id 15.20.6134.030; Wed, 1 Mar 2023
 09:22:12 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>
CC:     "joro@8bytes.org" <joro@8bytes.org>,
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
Subject: RE: [PATCH v5 07/19] vfio: Block device access via device fd until
 device is opened
Thread-Topic: [PATCH v5 07/19] vfio: Block device access via device fd until
 device is opened
Thread-Index: AQHZSpxM3A4y7mru9kmMr5b+52ASBa7lqM3A
Date:   Wed, 1 Mar 2023 09:22:12 +0000
Message-ID: <DS0PR11MB752939E08453213F8E296452C3AD9@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230227111135.61728-1-yi.l.liu@intel.com>
 <20230227111135.61728-8-yi.l.liu@intel.com>
In-Reply-To: <20230227111135.61728-8-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|SA2PR11MB5148:EE_
x-ms-office365-filtering-correlation-id: ae4a0c7d-6495-4e03-707f-08db1a367075
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: q8m24N3Nk+6aimAyS7gbrHTiauYvwxD8hsb1X2z9VWRF87psWSXwVorfooLQ6VA9Y1cIXkjp29pu1b36gFxtNr0ZCuFVceezMUvD0iRdmnHoOkl96WLrkBC7JLlg2WZYpkqtiB6UahTyTFZUhKbU8i/NZjBpc5ecA5k0roAnnXYpTmN+8r1ioWT2jqzmsf8mfUu5ZvdVMUkwIRowSY+a9fYpQNOzx9k1qXuSEDUFdJMm7vHLMf1mhNoYkjDapEVY2NbZapcmWZWQ2hDzGfSeEGZOtMCls1DsSnOBI7/dXQn217OstTlMNsZq1bRQUClwrTxrUgy5o+G7jfSaIPFBMQCrr3jMTDSv33p7Cw0lMGypCoLZMJgJKFiwvG9y6LnC030/qmTPXH4Xfv9QUvYxfq5OWNpHhYP+x9oMYuiAjj2XArnAhv3DEwz4qyfr69TW3l2XgjPoe58j8IEbwRCz07hwCpVCSgSdqYA3M+U1AXKMNUJGcoDg1wzib6jZymoazUPUQXnCAqZK9BofAKGfFE+OGCq9STZQBZt1W/iXN79TFJ4gkkfJ21GtA3dZP39c0AL1Dgc6AE1w+I+C22RvkhAa9E1wwXTfycTOtJGXIQDscR+FPpu+9bw81Ehc1bTBxiv72qdCL+HY5uSk2PUMYQDjCvDfF26wICU4MKXTCu9gmAzmGdyWBOKyshy2n+6RU24LLet6Ksikga1Mlv7Cfg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(136003)(366004)(39860400002)(376002)(396003)(451199018)(71200400001)(122000001)(82960400001)(55016003)(66946007)(76116006)(33656002)(6506007)(7696005)(41300700001)(8936002)(52536014)(38070700005)(38100700002)(316002)(478600001)(110136005)(4326008)(8676002)(64756008)(66446008)(66476007)(66556008)(54906003)(6636002)(83380400001)(26005)(186003)(9686003)(86362001)(5660300002)(2906002)(7416002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?GG4QFFTQUdeA6oKtogGLMC4ttwEikDrkayYp+41efE7zd2ZOPjGX1zmBUvZg?=
 =?us-ascii?Q?+OgnZ8RLhwfeU/qPBBTf2wWpue+XCw4BY4+FNQsr5b/l/N6E2FGSN2YWf5HO?=
 =?us-ascii?Q?FBga/qxHu+DDikRHIC2H2VmasiijKlFagsfQCUfz2XIz54Eohgd7uHbRuifx?=
 =?us-ascii?Q?O8aZXJ9/DXvex3WxexL2NNslH+kr0Kvs0J9OltywBRwRzVB3Lmj/yobvS7wC?=
 =?us-ascii?Q?X41xCSHVOtnXO2d6IYCz77DOpdlgTad0gwMzDV7KvypmYHlV2CeARwHpyTDF?=
 =?us-ascii?Q?rjSqEA6WOcR0+pno+M0pxGXnVElDdgfzaInMP9Wqlar2S2yfUdV69zC4P3Yg?=
 =?us-ascii?Q?fMrj4/ic2xKqn0S6vjfMQnpZU4pf10GVYpCwvcu59uWBXewQ52Pjl5HVV8it?=
 =?us-ascii?Q?BqcAAdvfplKQWlXFRzo+Zbm7NaKMBpmS/auB/9MmO7hdH0fL1cFEIzaKRPm8?=
 =?us-ascii?Q?AI1Dp5aQbMklrz2HEAv+pp629dD+IAmQsTvpUYJMADEx1/fHNaYguAN5ocf9?=
 =?us-ascii?Q?Q884h9fA9Krn40joomE39NyCxmML5COYiM6NOwnn7jr7JaBh8KW1oO9eV+Ld?=
 =?us-ascii?Q?+LPiLmjIHwTCr56LaxhBz+tU5yGT8OQA4Zmbdd5T5zxD1v1CzvXRIqPcmvaW?=
 =?us-ascii?Q?f7z84tU4tJQqMnAbzaZPaK385hnKHC50eT32DLQJ3jWC0ouzR0Yux/qzUdJI?=
 =?us-ascii?Q?83N4K9F2/yV1e45SAnC+plUAhc1c+qr6K7PHIwBXMT9DGNMWrZXZp5xqjSy7?=
 =?us-ascii?Q?+7G/amWKP+asFvbMRQtZzPGGM10QHrrh/vQZE7XVhbVUg1i5J0uI9gR9v1mK?=
 =?us-ascii?Q?4u/fZ2w8phWTiZDfls9cYVR52H7cX3AHLNznltnnFXNDsBdkf78Z6TPCXEX9?=
 =?us-ascii?Q?JYhOd6jV6DV+PW5ZbLnXnpK9neKhapdXiHeMMFRaZvYADvFCTcmlF77lYPKJ?=
 =?us-ascii?Q?hUm07kdUtbtO+rnZn5PXxPiAC7YJZc0GXRKz3hXxCncyA5ygxFKD8W3k38dM?=
 =?us-ascii?Q?JJAg2uro9n6kBSnCnOM30JfiJ2d+YctZ8gHG/iyi4/0W9BstiMHPdF11FzkW?=
 =?us-ascii?Q?gr2FLag22/FPq0/qkkIeflNbhkTPoDDYODFs7ERAVJ+WChC8ukgv5oKSBXor?=
 =?us-ascii?Q?kyWLplupfHnZmZBwGT37OLF7bOfMVfeYvLedPL8u2ecRu7x4ovYHpr5TvyZf?=
 =?us-ascii?Q?BZLHDg5VfBnEtwblmODQDmgCEy09B6IqQ/BgT4bG2UMNLSOEp58vOnugc57Q?=
 =?us-ascii?Q?64j/ZRX8uL9Oz4colr7laon62TceS8oVaVltG08KJzxs3+mtn2X+SKINvzFx?=
 =?us-ascii?Q?eTR34k4xGjvBfhBAYtUps8emzSxK5htD+DSooRxoCtKkNd0I4l80hV4rXMKT?=
 =?us-ascii?Q?8RqFtJfLJXEtZMmTpbW/5wRL4AvirIdjkMgh0fuGyy+bhDI5ThYonmmcj2KA?=
 =?us-ascii?Q?S8hi3ficP5jX5P41FvGe5uQe5SVv9gki+85LSWaNwaGcPH5hCFDBN8l0YmzC?=
 =?us-ascii?Q?cIhQfl+lHAF3hXLoV7VxAwAfXmm8scyjJbM581plApQ2FT7napmNDMdm0GHn?=
 =?us-ascii?Q?VLm9h+AO15IwvKsKg9zu8m15zYCaVu7pD3UEQUPL?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae4a0c7d-6495-4e03-707f-08db1a367075
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Mar 2023 09:22:12.0201
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MURZKAMNk3Hx4ZXr5PKaM7C41N1QZwoi1akNgD+EK+Opd7yoqcchy2Y3A0rzCKrx1KqBp6zM4b2o1LPF/uQgag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5148
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Monday, February 27, 2023 7:11 PM
>=20
> Allow the vfio_device file to be in a state where the device FD is
> opened but the device cannot be used by userspace (i.e. its .open_device(=
)
> hasn't been called). This inbetween state is not used when the device
> FD is spawned from the group FD, however when we create the device FD
> directly by opening a cdev it will be opened in the blocked state.
>=20
> The reason for the inbetween state is that userspace only gets a FD but
> doesn't gain access permission until binding the FD to an iommufd. So in
> the blocked state, only the bind operation is allowed. Completing bind
> will allow user to further access the device.
>=20
> This is implemented by adding a flag in struct vfio_device_file to mark
> the blocked state and using a simple smp_load_acquire() to obtain the
> flag value and serialize all the device setup with the thread accessing
> this device.
>=20
> Following this lockless scheme, it can safely handle the device FD
> unbound->bound but it cannot handle bound->unbound. To allow this we'd
> need to add a lock on all the vfio ioctls which seems costly. So once
> device FD is bound, it remains bound until the FD is closed.
>=20
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> ---
>  drivers/vfio/group.c     |  6 ++++++
>  drivers/vfio/vfio.h      |  1 +
>  drivers/vfio/vfio_main.c | 16 ++++++++++++++++
>  3 files changed, 23 insertions(+)
>=20
> diff --git a/drivers/vfio/group.c b/drivers/vfio/group.c
> index 960b1bcb606b..d8771d585cb1 100644
> --- a/drivers/vfio/group.c
> +++ b/drivers/vfio/group.c
> @@ -197,6 +197,12 @@ static int vfio_device_group_open(struct
> vfio_device_file *df)
>  	if (device->open_count =3D=3D 0)
>  		vfio_device_put_kvm(device);
>=20
> +	/*
> +	 * Paired with smp_load_acquire() in vfio_device_fops::ioctl/
> +	 * read/write/mmap
> +	 */
> +	smp_store_release(&df->access_granted, true);
> +

A bug. If ret is false, it should not set df->access_granted. Would
be fixed in the  next version.

Regards,
Yi Liu
>  	mutex_unlock(&device->dev_set->lock);
>=20
>  out_unlock:
> diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
> index 7c1ea870d8f3..2e3cb284711d 100644
> --- a/drivers/vfio/vfio.h
> +++ b/drivers/vfio/vfio.h
> @@ -18,6 +18,7 @@ struct vfio_container;
>=20
>  struct vfio_device_file {
>  	struct vfio_device *device;
> +	bool access_granted;
>  	spinlock_t kvm_ref_lock; /* protect kvm field */
>  	struct kvm *kvm;
>  	struct iommufd_ctx *iommufd; /* protected by struct
> vfio_device_set::lock */
> diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> index 609700748082..d16ac573e290 100644
> --- a/drivers/vfio/vfio_main.c
> +++ b/drivers/vfio/vfio_main.c
> @@ -1106,6 +1106,10 @@ static long vfio_device_fops_unl_ioctl(struct file
> *filep,
>  	struct vfio_device *device =3D df->device;
>  	int ret;
>=20
> +	/* Paired with smp_store_release() in vfio_device_group_open()
> */
> +	if (!smp_load_acquire(&df->access_granted))
> +		return -EINVAL;
> +
>  	ret =3D vfio_device_pm_runtime_get(device);
>  	if (ret)
>  		return ret;
> @@ -1133,6 +1137,10 @@ static ssize_t vfio_device_fops_read(struct file
> *filep, char __user *buf,
>  	struct vfio_device_file *df =3D filep->private_data;
>  	struct vfio_device *device =3D df->device;
>=20
> +	/* Paired with smp_store_release() in vfio_device_group_open()
> */
> +	if (!smp_load_acquire(&df->access_granted))
> +		return -EINVAL;
> +
>  	if (unlikely(!device->ops->read))
>  		return -EINVAL;
>=20
> @@ -1146,6 +1154,10 @@ static ssize_t vfio_device_fops_write(struct file
> *filep,
>  	struct vfio_device_file *df =3D filep->private_data;
>  	struct vfio_device *device =3D df->device;
>=20
> +	/* Paired with smp_store_release() in vfio_device_group_open()
> */
> +	if (!smp_load_acquire(&df->access_granted))
> +		return -EINVAL;
> +
>  	if (unlikely(!device->ops->write))
>  		return -EINVAL;
>=20
> @@ -1157,6 +1169,10 @@ static int vfio_device_fops_mmap(struct file
> *filep, struct vm_area_struct *vma)
>  	struct vfio_device_file *df =3D filep->private_data;
>  	struct vfio_device *device =3D df->device;
>=20
> +	/* Paired with smp_store_release() in vfio_device_group_open()
> */
> +	if (!smp_load_acquire(&df->access_granted))
> +		return -EINVAL;
> +
>  	if (unlikely(!device->ops->mmap))
>  		return -EINVAL;
>=20
> --
> 2.34.1

