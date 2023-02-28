Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D79C26A5221
	for <lists+kvm@lfdr.de>; Tue, 28 Feb 2023 04:59:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230048AbjB1D7x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 22:59:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229888AbjB1D7v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 22:59:51 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB23F9EE9;
        Mon, 27 Feb 2023 19:59:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677556791; x=1709092791;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=0ZPMGhrmu7+rUtGxO/UpuxelIfsNtxQsBYuGPDCJfaw=;
  b=ipUdUZeaG46yV/L9mrFUkJnaAJFF9MeBnQYEY8RITNivLwE4toqh0bms
   t4/hCSVRVKXO7QNzIUSI0Xubvv86NgLZBCjLfUx8pnjPk5XqGf287Zw8x
   o6ah5j3AH4sLqSUvNU5u5SU9G6OE4JNj+rxbq0pjp+kVMGYCP0kdsVI4I
   HbK2Cra2x416mhjE9qU1JkNFxMVFRVt79kHK7b3h3MlYVZdfPBFh4wgFs
   KZo37GRFrfXfbnq67NIDXgGvTRIMRUbtMWKG3Ljkz4WLPi7LrGHqPwYu4
   JQm23HXoQUF2quvNSotrdU8SoV1BuVHmzDTuWwLLKBvyFXTpZitq8I/Pt
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10634"; a="398817373"
X-IronPort-AV: E=Sophos;i="5.98,220,1673942400"; 
   d="scan'208";a="398817373"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2023 19:59:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10634"; a="676154846"
X-IronPort-AV: E=Sophos;i="5.98,220,1673942400"; 
   d="scan'208";a="676154846"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga007.fm.intel.com with ESMTP; 27 Feb 2023 19:59:49 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 27 Feb 2023 19:59:49 -0800
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 27 Feb 2023 19:59:48 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 27 Feb 2023 19:59:48 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.46) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 27 Feb 2023 19:59:48 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lYgsTldatoIzeX/c3Dujxe+isrvVBXa9LztRe0B/MbYWScPlGhN6Vv/C++VD0RV1B5rgy6U4gUKOductG3FsY8p7ujdcnGPEazouuNka3X4F6jyjn0Jw2aTn7uU/m35SI55g/CckeU7ZFUQf+vWeb4Z7Li7mj0vwJwbf1Wx1GaDzQIfa6p2WHx6EedJt/85S4rs/nA4N/NoUC4hJ11JKyjwvIor6+25OQj0q4rCVveGBLz9q+L1HnERleaocoUqjuDxDlIM09YvX0P7994hIHlYhMritpCXpezNVLj8/vZqmHwzTDyT7b2QoiQG6f1BlMepudk5CUNh6tGUS3ut/nw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oE5yiYXcFwB5KzoPULr94TjPJqzaNdU1hzXNQ/o0IW4=;
 b=oVRMuq5UhjlLjfmSGaYziKkfQ2l7EphzGufdFWD7ONADDMh0HiHcLegNvS6AMhP0vv4YfH8NBfuxPzIMSsPCRPVGlF1Xq6EPP2iIgKP7WLmXhNWXoZB6rajFSmZNePnPGEMVxXskaD+YSVfkHqlR7TRdIsgTS9ZGfvYcDBXMh2/ZkvNkunAuwofQYyARwl5euqu5/lwPzhTYcyNwvELZAhtYztI3yhznXfsvJvk6zzDNu5K7RVuL3b0XyCm2w8Kqp5Uq2cMj3igMksVqmtZ14/YCA7UaMyQ8NefB2QPtjM5lq/vrpYqP/vPx5QbT9ncpmJpeDGS+3QxKxKwmqiN3Rg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by PH0PR11MB7495.namprd11.prod.outlook.com (2603:10b6:510:289::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.29; Tue, 28 Feb
 2023 03:59:42 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f%9]) with mapi id 15.20.6134.029; Tue, 28 Feb 2023
 03:59:42 +0000
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
Subject: RE: [PATCH v5 15/19] vfio: Add cdev for vfio_device
Thread-Topic: [PATCH v5 15/19] vfio: Add cdev for vfio_device
Thread-Index: AQHZSpxLneNk2Ja5KUyUQHIMf7QuLK7jJ98AgACTd2A=
Date:   Tue, 28 Feb 2023 03:59:41 +0000
Message-ID: <DS0PR11MB75295DE919CC4FBAAAE1CE45C3AC9@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230227111135.61728-1-yi.l.liu@intel.com>
 <20230227111135.61728-16-yi.l.liu@intel.com> <Y/z/ICcG9OIBo+Fi@nvidia.com>
In-Reply-To: <Y/z/ICcG9OIBo+Fi@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|PH0PR11MB7495:EE_
x-ms-office365-filtering-correlation-id: 6806a1c4-bf5b-4af7-2906-08db1940388b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: q6A99nmjNAV9XKCbgA7dJ+hBqr9pJyBqgasg+Je+TFoXCBNY2q+tMmagjczUQTDMsvpWTR7sKbz1GUWuczlOQ0A1yd5omLzAF8FMmaubbbKg+mT/I2M+OltN6ZI2ARzht2/c9BSde3+8MTOKjPNbeus16HeiYMdksKxZJmTDvXDp8N7OkwuVaHyWlSOn0BbRDf8uRNWbQphSXACvsO/2vcPWmgiKl0n6Kha5yulTbt4N5NHdxDWKRoTjODwBTJNvk7SXSVq5Gv+4KVJQs9tph9S6qOaOka0x+zvn0YbpOskMVGKLzaIm9koe0LvHuacN9eHqcl4XnrKqpQ+1fgUtkTn5lp9/+4+XAiqnoGmft+PJgCk5gqZrtWZFP4Da+rarV+EBvhG6wZwR72pozlNA/Y/cJcwZANQqcNA2zYNAG9RmfUX3M0Cf2oykcJHmAC0G5C9R8VSQYc3suO7RGQMbvh3ySY5Lri2YWVkbF9nkxVGOe9WISf9NVByX5Nrhkws3R0abgdnHCAY/zK9Pk3eyGEd8qSLSZm65eGJMf466G1O4i2WmpAEV/vKExSNNDTRsqVb+E5IEjfIuH+MAKs9IyDJhiBjCp3olqUQPIzMnKa+mmVLAvhUQP7H5C0ZHi36tccOBBS/wFldZIwOhUmceBtKM3FMxAQXvMWe1qQp/93yD2hVmxRgn252iz9Z3s10T8nyd6Rj3swrsXwjriqGBDA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(39860400002)(366004)(346002)(396003)(376002)(451199018)(186003)(9686003)(7416002)(82960400001)(38100700002)(52536014)(122000001)(316002)(38070700005)(4326008)(66446008)(66556008)(8676002)(6916009)(41300700001)(2906002)(5660300002)(66946007)(76116006)(71200400001)(7696005)(66476007)(55016003)(478600001)(64756008)(6506007)(8936002)(26005)(33656002)(54906003)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?wuHOTJUHAtKr/XYAK/R8Gbvbwqlq5J1aZCzfg8k6SuDbgGx65crs+9Bu1HRd?=
 =?us-ascii?Q?tjl3QSagibRIxL62qtemhVsCB1zTdDHBcA6zlQJT2zMAURsl8L6u+tg+sKjI?=
 =?us-ascii?Q?TbbDSdkOL5iG73HFV3CQ2eDCh4+e70HwE1ma5FIjtvzcH0AwbwYyCWl/0YKT?=
 =?us-ascii?Q?yfhC7hM4P9C68KRPB6J21Dws52Iu/lD67k3HFfMrrB9azpEbZ3jY1yZH5zTP?=
 =?us-ascii?Q?i0auQixmdzn3edVjJI659dScEGW5rgXnp21VdCmadZGJu9dfOtct1EqU6gB+?=
 =?us-ascii?Q?g6vlun73tFt6KUXHRrkGZCXP1gszSsB4SaQxRsp3ro8+TkFt5aeSYZ0ZPl/e?=
 =?us-ascii?Q?vHbzN56A8tC5TXZFn/lPHJyseslDsr6NiZak6uyQajgAmNEpjfe4/8gIKtsa?=
 =?us-ascii?Q?r+09MC+rz7dHgv8ZS+IsU61minq/v2nY9Z0xIt5XA3Q6U9Mh/LAZr4fcZlWz?=
 =?us-ascii?Q?0Zw1XE9fs6Ev7vxmAV0hiqzsFbfXJ708q649rTgMgSPH4bl4wZqnisroIcX8?=
 =?us-ascii?Q?6iAm4wfH+i5n2Uqa86FcnoVeH8+Lyw4q81vSv03TqHeV1ZWpqzTKh3f17sjh?=
 =?us-ascii?Q?uF6Q41OVrv88ygTrrWN75gyBcLNiX9n0A6jjXicjhR+JSznhoZCa5g5kLKj7?=
 =?us-ascii?Q?cB7SFXwKo0vePSX3/3bUPJQL2vom8xjXb10HMbYxFO0TYp6KoezN7+UGNbSQ?=
 =?us-ascii?Q?bPucJR0XGyfbdPpJEB6lZ4I44uuRfb6Mw2SViIA0wWvBJ3T12zy6Qz6M8AbD?=
 =?us-ascii?Q?P1amgDxA5MGsS0qphHrVXtCI9xhzq8pp0YCKh0TAZMbb0MtUAKSKSg386P6m?=
 =?us-ascii?Q?KP9Jerb2nHdVgbYPX2r0UMldyoPZ1bmdc1IKWc3MCg4cFDsRCqbcDfbwMO6x?=
 =?us-ascii?Q?zAhMbTfeg/ZqdmNMYI5jKszRh58LV1rg6vMvWnvkv1pYs/O951qkYQ/uEQIv?=
 =?us-ascii?Q?xqH4cwf/Z1E+oH643vdOt3K4tAi/lm92mKv7Xwe4IKZRK7O75PmkfT8nwsnt?=
 =?us-ascii?Q?gUd/boXw0lDmmfmMp5o8p1/nkhCHDB68fHeZrxCq/cz+SJjJp3RqlD7OxAjb?=
 =?us-ascii?Q?yGXj/HdSI98RmeCpr+P/q/hoKTf8MHCh3aaSY6qwjBfA9yNwVo6wsLbQT1bK?=
 =?us-ascii?Q?nE3hcJmbY67m1LEVov1nEENN4+QbS5JnDD8zdbvuug6hzqr627OFGcC2nPvn?=
 =?us-ascii?Q?tyIw1oiF3ZVgpJVaIovh1GZ63tJTHRn4LpnLiUi8Sm1Q5a+k2M0NMvwn8JIn?=
 =?us-ascii?Q?Q8hbsF9//MR2tbq+JifUv2eV7p/EZZaZTb4I/S2E8Evk9nwCO0GORokdeu3q?=
 =?us-ascii?Q?2h1OHBJ7R+se79g4RXhZA83ReASc4DyATE3m7q2aduOXBnQhZ5fUYH4Cqs/x?=
 =?us-ascii?Q?wCasim5wAQIkXsTzIsYAh4oEsqeSIEFH+DokROpv+xFvIIm75O+d436UqL7L?=
 =?us-ascii?Q?qovWL3M5ctlGqMom6K96MSTMSxIPg9bKUKJx1sQw0pIh0/FTcxyWp9GthpFk?=
 =?us-ascii?Q?s+J6Yg0//kPgDn8J1CQJvEZLA/MkOSEY66vZT/Ng7FYnLBOdx0CPVrr16EhK?=
 =?us-ascii?Q?RRlKN1K3cPs+6Yti26FCr8YIfK8mldDL0Li0+m8q?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6806a1c4-bf5b-4af7-2906-08db1940388b
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Feb 2023 03:59:41.9990
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +KH20DngTUG+ZsgHuK5Bn5AoBCngThvjaxHkAB9kTCZjkEDmbkQXDSqitE8k98QRp0mdhb0HP2BPStaFPEMyQA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB7495
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Tuesday, February 28, 2023 3:06 AM
>=20
> On Mon, Feb 27, 2023 at 03:11:31AM -0800, Yi Liu wrote:
> > @@ -309,6 +310,13 @@ void vfio_unregister_group_dev(struct
> vfio_device *device)
> >  	bool interrupted =3D false;
> >  	long rc;
> >
> > +	/*
> > +	 * Balances vfio_device_add in register path. Putting it as the
> > +	 * first operation in unregister to prevent registration refcount
> > +	 * from incrementing per cdev open.
> > +	 */
> > +	vfio_device_del(device);
> > +
> >  	vfio_device_put_registration(device);
> >  	rc =3D try_wait_for_completion(&device->comp);
> >  	while (rc <=3D 0) {
> > @@ -334,9 +342,6 @@ void vfio_unregister_group_dev(struct vfio_device
> *device)
> >
> >  	vfio_device_group_unregister(device);
> >
> > -	/* Balances device_add in register path */
> > -	device_del(&device->device);
> > -
> >  	/* Balances vfio_device_set_group in register path */
> >  	vfio_device_remove_group(device);
>=20
> The same rational applies to vfio_device_group_unregister too, so it
> should be moved up as well.

You are right. User may get new registration refcount in below path
which can be in parallel with this vfio_unregister_group_dev() path.
Let me move it and refine the comment as well.

ioctl(group_fd, VFIO_GROUP_GET_DEVICE_FD, )
  vfio_group_ioctl_get_device_fd()
    -> vfio_device_get_from_name()
      -> vfio_device_try_get_registration() -- refcount++

Thanks,
Yi Liu
