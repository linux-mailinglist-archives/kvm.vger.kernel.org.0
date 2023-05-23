Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C06570D09F
	for <lists+kvm@lfdr.de>; Tue, 23 May 2023 03:41:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230284AbjEWBlt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 May 2023 21:41:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbjEWBlr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 May 2023 21:41:47 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC7F790;
        Mon, 22 May 2023 18:41:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684806105; x=1716342105;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=KMDccTNjmzVy8AMX+3k9ZjVsnRxvHfXaftPjtNrXQVw=;
  b=EClMSExlR0UixzYfVhJbSf4pQZ8GXy5QPeHGuCtJI/SjmXBzVIk5x0or
   AN7gZtTz+HBsSDUrCi7wev2/iwum492d6UGt9xrZ9vD6spoyNLW1vrXkX
   N9E4eEqzOPDc5t1pjQYNuemeel9Z/HuFgG69m1AB0zI6rTBbfpQDt3EKZ
   euA5/O1I1JSFxGBReibBHGk5wodB31vK0QIafwRue6fkToH9HmlCwtLxT
   rCfwnzeEyVKGEbFO5CpEyPhgbDz1A71CCatp1QXStmMIvHU3FVtpPaVxN
   /pTioMW2X4uiSNjMpzv4lcQB0UI7rdfCfxYLwv0yTdYTSEmonxz3B8ZDI
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10718"; a="342551830"
X-IronPort-AV: E=Sophos;i="6.00,184,1681196400"; 
   d="scan'208";a="342551830"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2023 18:41:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10718"; a="703757930"
X-IronPort-AV: E=Sophos;i="6.00,184,1681196400"; 
   d="scan'208";a="703757930"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga002.jf.intel.com with ESMTP; 22 May 2023 18:41:43 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 22 May 2023 18:41:44 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 22 May 2023 18:41:43 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 22 May 2023 18:41:43 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.176)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 22 May 2023 18:41:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DAgNPZ+OrPc5uUXQz4Jk/E69frxsYtr1tYoHKp418gUtZl2BB35nbxXUec+oXjC/9GOZKe4m/UB7vWpqiRaKHTmTO5AYwXIHmGkplgk/zWISlY4tyYCRb3nKNTg9NehooCN35wRH6ZN5p60qXVtxo9/H5lrNGaKsktnmWzA8njiyxhpPDs9v2whlrQzgf62/lCcfzRO8iQAezGA7mYCcRqvH9PA/g0glPcb3SjV3t+leHvWvy36G9u0SiBzH9f5cvrqRcgUus3yfCvBmV/nU1FKK/nbJJ0NnEvzt4udNdEV975Dg2g1M7CdqkUjrqzJwMB1KEQJom4kDTG5ihbevAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OiBcjYZg89Hqao2K7KJ4FMW/26D65xPVk87JwXnJ5GE=;
 b=DV0acjBaIYsqefBRml/du2G2pJyXpFIZaPvo5u/yHbmBPawWb5hmmONSeaa4K26Cf0x1FSKEQRBvM5pXdvwMpcJ0jjxwQEJLs3eAO1s/FnZnO83Tap4mhXZJbuXiFvphbTGcMcCVerZIfgXo9HIDeCZi5o1ovwTlYFVsR6N0I9Om6xjbelDSnPu3qvhb6OYapdHtFNWzKpXSWhlW7QatTtfrsL8gUcRnotmKzbsPA9virVSUpivJnWNXS2jXSsbOL7icws/73TjYrqHj9uR43y33WQ2HSP7PP9vKQrIjUNbRyDAgYVSebJ81nfhR5DqAFLe5qhNDc7czrmDdcQuGwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by SA3PR11MB7978.namprd11.prod.outlook.com (2603:10b6:806:2fa::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.21; Tue, 23 May
 2023 01:41:36 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::5b44:8f52:dbeb:18e5]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::5b44:8f52:dbeb:18e5%3]) with mapi id 15.20.6411.028; Tue, 23 May 2023
 01:41:36 +0000
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
Subject: RE: [PATCH v11 19/23] vfio: Add VFIO_DEVICE_BIND_IOMMUFD
Thread-Topic: [PATCH v11 19/23] vfio: Add VFIO_DEVICE_BIND_IOMMUFD
Thread-Index: AQHZhZ7k65TFikm5KUKI3FkaFFDbUK9m5qgAgAA8RCA=
Date:   Tue, 23 May 2023 01:41:36 +0000
Message-ID: <DS0PR11MB752935BF70AC95B564685DC0C3409@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230513132827.39066-1-yi.l.liu@intel.com>
        <20230513132827.39066-20-yi.l.liu@intel.com>
 <20230522160124.768430b4.alex.williamson@redhat.com>
In-Reply-To: <20230522160124.768430b4.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|SA3PR11MB7978:EE_
x-ms-office365-filtering-correlation-id: 9348374a-0897-44a3-bb53-08db5b2ed87e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OV+eHGj5vqKnUGMXmn0z0+9crTxQ1i0Bg+hoftoDNThR0KXU95xr+b8O7RiIsNHHs7mfTnCWp35zIOi3IfR/w8tNzWg2jse4QkmIxNEpgmdDhj5nxxrV4Vk50n6stwIJc41EwCMHUABng7B1n6/DEmrP04qpYb6sNmE/GhPsKGJG4lpZwFCmO+BptxzSM9MEgYmp+UjrSkoOPEg4g/s7NX8+V14UOB836LkKWbt/W+O3BOBh9cdt0gja9Xosj64UOmwPXlKKX5RxIkLNfFUFe8YA0k0eWdzYJzbFIl9bOFkYq6OjnQPVg+3FDEhuTKKjZjd+tM0j2I5+vYpJdY14EOKgQM2LyAbvcnsUyyLh8/dSAKmW3YP9VZg4lQ563oRo8S5Hfaa7B5u3ARU30jDcC/ZKzCUeM5366j2mNK/FKiMCYtYDmFyg5QeeG58cfA+lLtnsAJqYqiPDaCxl4Y/Fgb3xj38ypunJ5WZpOg1CdGrtkN4rDTpH3zZRYepcyrNbws99DI8xG1j7V53JZj6fnSYZN6YKHKPRa00BRcT4wrRXW5wWmqiGjjVTAQjIawGqI4ds+6q5vU+hmUf+OhDkRBGCOotxjPIWvZBHEO4WzSFzfQi/K7oD+zQ603OJKYdP5X66Z7bvewW8QhCgKawgIQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(396003)(39860400002)(376002)(346002)(366004)(451199021)(66446008)(64756008)(6916009)(66556008)(4326008)(66946007)(66476007)(76116006)(478600001)(316002)(54906003)(38070700005)(33656002)(86362001)(83380400001)(26005)(9686003)(186003)(6506007)(52536014)(5660300002)(7416002)(71200400001)(8676002)(8936002)(2906002)(7696005)(55016003)(38100700002)(41300700001)(122000001)(82960400001)(13296009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?6H9Cl3MaCQqzHDNo144gUAvieaV6GZd5r3WUz8YVV0/Ps79oQfHbKX7fsTkM?=
 =?us-ascii?Q?wwyC8Vefb/sSMLveMfbMEWRkBcR0s/1wGG6rg7GDNI7jCXOEk2H/DhjQGCCf?=
 =?us-ascii?Q?tONEADZS9amUMyplngtF1nbrjKwKfMxlZF7v/hz1jNHN8GGx3vazs/6l2Oih?=
 =?us-ascii?Q?QINJfLZmBkV1anzuUvvR+4H5yQndy/fzBbnGLbLiKsyQ9BECksBGJ/a4yhMI?=
 =?us-ascii?Q?F6VRxxdM0AH9FdmsMmkctfx3/jzWRqW6ggN64jO5+Uz53QXN38T8wgXVxDwE?=
 =?us-ascii?Q?digOs7cQ8V7mZrzObJkdRnkd3MaZQ2XPNTH6A3Tih3QOHIQmkxtAGaoEnB5l?=
 =?us-ascii?Q?lk8Lbfw6FY5g9nX2SO70XBMnDk7CnONJg+ubd/yF21Tfkw1D1Qy4SlDQ1sbB?=
 =?us-ascii?Q?MRYVgUrXuT17kTFxd1ZA1uXdOiX++7RyigxQskQaeLchO6oS0tDFzKq1Dciz?=
 =?us-ascii?Q?242QISYCbxJlmeVDfHbqAptCFqv++QeuiOBhM5Q6giJn63/bcAiFOwzxe2Fz?=
 =?us-ascii?Q?ZNGXmtQ+vfYoEEbKJHPFCXkHZhR8oH5J1oeVlfcXP1ZNjOSHaw/uun0YMzIJ?=
 =?us-ascii?Q?PnrBOAlAOf25w1J66F7p5yDo07ZugyEIeAhyl9fkevu6Qx3UJydvQm9mFIFL?=
 =?us-ascii?Q?eiTplSju5Plz7mbmvZfQiaKbg6THZymQBg9HZbnWe3z4vdb4ky5YbL2WdlvQ?=
 =?us-ascii?Q?bp5G5Vae5UE8oA4LZOJDMpXYpExl49tSKkirxNLD0wOlg57XEUs+02nA/kR9?=
 =?us-ascii?Q?MHZz3FbYOWhFr7v2xKZ5Jp2i/oE6A6Axjf64P0O8fq1sl48NoKdh+Ar6EJzK?=
 =?us-ascii?Q?bCvbh744aPfZ9vGAFk3VQjyYJ7m3ijTrln7TirIBh2r40jaDqBXI/zyW30pW?=
 =?us-ascii?Q?pBegUl8Likss7SlY5nziy33A4dD7WhoZAAdxWCpxc9L3IPvLf3LQlUaCX9dW?=
 =?us-ascii?Q?2EEKRkqdNT0kyXgYDIhyXjz01rglTxt8IVmHSQ44r//s1Mfu8t1wHlKthO/w?=
 =?us-ascii?Q?P21EMSFbb9W4S+u/6juhckaXtvap2S8QdgzgwfoftEl/Qz+nwmeOFVzSd/uu?=
 =?us-ascii?Q?/hB+LVGpTmPmw4Vj3WdjI0hdZVL9Dm5UNWhYj8/jAyk8Vo7fAD3NkBHPT9ec?=
 =?us-ascii?Q?w+LhyUcDcS7izVITyv3fG9VrI633OZNw8mLvw9SPcX0ESVUahZtg4Q0wbF1+?=
 =?us-ascii?Q?xHMpiUQYu3jZfgZKlV8NOQ/h1m3Y3If4NDv6gWMqN9xn3cr4oQdNIbIaEWNC?=
 =?us-ascii?Q?0K1AAmpuVhYwcbAzx0Nfd/YDcm1UixKdtWlIofSLO3Thj0Gzls62YaWZIqJu?=
 =?us-ascii?Q?H1WPQS/wZDKPNUPf14oSUrr644Kh323JHMO5NyO4xoDeSMa5k/WVWBMqwr37?=
 =?us-ascii?Q?dOpCCSUHTxD2rSbSVY4ngpRpDi4y7MKbIYHzOYPGSYN2nNcU0skZ/qFEzGm0?=
 =?us-ascii?Q?ggQbrX5Cjrix+D1WJ/DePCAprMuUEzn9trHdD3MQPohfjGt0F7X2iIC/rBT7?=
 =?us-ascii?Q?rAiy9T5L3/qrI6gn7EG+iGHro41qUWqWFg8d3qOWGiBPzmmqBFQx96WQc4Dx?=
 =?us-ascii?Q?OPe80wDciVXb56MfczF3dtMj/CUlDsBlQNYFxidJ?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9348374a-0897-44a3-bb53-08db5b2ed87e
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 May 2023 01:41:36.1540
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KZDg6cWP3RSiFuu7m8aSy80nXTHv0TxwziKPbXByMxrZVfMGIwMcCumI8vWdyBJcsgZM8RMnhNNZBrV2uAT2Iw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB7978
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Tuesday, May 23, 2023 6:01 AM
>=20
> On Sat, 13 May 2023 06:28:23 -0700
> Yi Liu <yi.l.liu@intel.com> wrote:
>=20
> > This adds ioctl for userspace to bind device cdev fd to iommufd.
> >
> >     VFIO_DEVICE_BIND_IOMMUFD: bind device to an iommufd, hence gain DMA
> > 			      control provided by the iommufd. open_device
> > 			      op is called after bind_iommufd op.
> >
> > Tested-by: Yanting Jiang <yanting.jiang@intel.com>
> > Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> > Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> > ---
> >  drivers/vfio/device_cdev.c | 130 +++++++++++++++++++++++++++++++++++++
> >  drivers/vfio/vfio.h        |  13 ++++
> >  drivers/vfio/vfio_main.c   |   5 ++
> >  include/linux/vfio.h       |   3 +-
> >  include/uapi/linux/vfio.h  |  28 ++++++++
> >  5 files changed, 178 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/vfio/device_cdev.c b/drivers/vfio/device_cdev.c
> > index 1c640016a824..291cc678a18b 100644
> > --- a/drivers/vfio/device_cdev.c
> > +++ b/drivers/vfio/device_cdev.c
> > @@ -3,6 +3,7 @@
> >   * Copyright (c) 2023 Intel Corporation.
> >   */
> >  #include <linux/vfio.h>
> > +#include <linux/iommufd.h>
> >
> >  #include "vfio.h"
> >
> > @@ -44,6 +45,135 @@ int vfio_device_fops_cdev_open(struct inode *inode,=
 struct
> file *filep)
> >  	return ret;
> >  }
> >
> > +static void vfio_device_get_kvm_safe(struct vfio_device_file *df)
> > +{
> > +	spin_lock(&df->kvm_ref_lock);
> > +	if (df->kvm)
> > +		_vfio_device_get_kvm_safe(df->device, df->kvm);
> > +	spin_unlock(&df->kvm_ref_lock);
> > +}
> > +
> > +void vfio_device_cdev_close(struct vfio_device_file *df)
> > +{
> > +	struct vfio_device *device =3D df->device;
> > +
> > +	/*
> > +	 * In the time of close, there is no contention with another one
> > +	 * changing this flag.  So read df->access_granted without lock
> > +	 * and no smp_load_acquire() is ok.
> > +	 */
> > +	if (!df->access_granted)
> > +		return;
> > +
> > +	mutex_lock(&device->dev_set->lock);
> > +	vfio_device_close(df);
> > +	vfio_device_put_kvm(device);
> > +	iommufd_ctx_put(df->iommufd);
> > +	device->cdev_opened =3D false;
> > +	mutex_unlock(&device->dev_set->lock);
> > +	vfio_device_unblock_group(device);
> > +}
> > +
> > +static struct iommufd_ctx *vfio_get_iommufd_from_fd(int fd)
> > +{
> > +	struct iommufd_ctx *iommufd;
> > +	struct fd f;
> > +
> > +	f =3D fdget(fd);
> > +	if (!f.file)
> > +		return ERR_PTR(-EBADF);
> > +
> > +	iommufd =3D iommufd_ctx_from_file(f.file);
> > +
> > +	fdput(f);
> > +	return iommufd;
> > +}
> > +
> > +long vfio_device_ioctl_bind_iommufd(struct vfio_device_file *df,
> > +				    struct vfio_device_bind_iommufd __user *arg)
> > +{
> > +	struct vfio_device *device =3D df->device;
> > +	struct vfio_device_bind_iommufd bind;
> > +	unsigned long minsz;
> > +	int ret;
> > +
> > +	static_assert(__same_type(arg->out_devid, df->devid));
> > +
> > +	minsz =3D offsetofend(struct vfio_device_bind_iommufd, out_devid);
> > +
> > +	if (copy_from_user(&bind, arg, minsz))
> > +		return -EFAULT;
> > +
> > +	if (bind.argsz < minsz || bind.flags || bind.iommufd < 0)
> > +		return -EINVAL;
> > +
> > +	/* BIND_IOMMUFD only allowed for cdev fds */
> > +	if (df->group)
> > +		return -EINVAL;
> > +
> > +	if (vfio_device_is_noiommu(device) && !capable(CAP_SYS_RAWIO))
> > +		return -EPERM;
> > +
> > +	ret =3D vfio_device_block_group(device);
> > +	if (ret)
> > +		return ret;
> > +
> > +	mutex_lock(&device->dev_set->lock);
> > +	/* one device cannot be bound twice */
> > +	if (df->access_granted) {
> > +		ret =3D -EINVAL;
> > +		goto out_unlock;
> > +	}
> > +
> > +	df->iommufd =3D vfio_get_iommufd_from_fd(bind.iommufd);
> > +	if (IS_ERR(df->iommufd)) {
> > +		ret =3D PTR_ERR(df->iommufd);
> > +		df->iommufd =3D NULL;
> > +		goto out_unlock;
> > +	}
> > +
> > +	/*
> > +	 * Before the device open, get the KVM pointer currently
> > +	 * associated with the device file (if there is) and obtain
> > +	 * a reference.  This reference is held until device closed.
> > +	 * Save the pointer in the device for use by drivers.
> > +	 */
> > +	vfio_device_get_kvm_safe(df);
> > +
> > +	ret =3D vfio_device_open(df);
> > +	if (ret)
> > +		goto out_put_kvm;
> > +
> > +	ret =3D copy_to_user(&arg->out_devid, &df->devid,
> > +			   sizeof(df->devid)) ? -EFAULT : 0;
> > +	if (ret)
> > +		goto out_close_device;
> > +
> > +	/*
> > +	 * Paired with smp_load_acquire() in vfio_device_fops::ioctl/
> > +	 * read/write/mmap
> > +	 */
> > +	smp_store_release(&df->access_granted, true);
> > +	device->cdev_opened =3D true;
> > +	mutex_unlock(&device->dev_set->lock);
> > +
> > +	if (vfio_device_is_noiommu(device))
> > +		dev_warn(device->dev, "noiommu device is bound to iommufd by user
> "
> > +			 "(%s:%d)\n", current->comm, task_pid_nr(current));
>=20
> The noiommu kernel taint only happens in vfio_group_find_or_alloc(), so
> how does noiommu taint the kernel when !CONFIG_VFIO_GROUP?

Yeah, in the cdev path, no taint. I add this just in order to par with the =
below
message in the group path.

vfio_device_open_file()
{
	dev_warn(device->dev, "vfio-noiommu device opened by user "
		   "(%s:%d)\n", current->comm, task_pid_nr(current));
}

> > +	return 0;
> > +
> > +out_close_device:
> > +	vfio_device_close(df);
> > +out_put_kvm:
> > +	vfio_device_put_kvm(device);
> > +	iommufd_ctx_put(df->iommufd);
> > +	df->iommufd =3D NULL;
> > +out_unlock:
> > +	mutex_unlock(&device->dev_set->lock);
> > +	vfio_device_unblock_group(device);
> > +	return ret;
> > +}
> > +
> >  static char *vfio_device_devnode(const struct device *dev, umode_t *mo=
de)
> >  {
> >  	return kasprintf(GFP_KERNEL, "vfio/devices/%s", dev_name(dev));
> > diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
> > index 6861f8ebb64d..8b359a7794be 100644
> > --- a/drivers/vfio/vfio.h
> > +++ b/drivers/vfio/vfio.h
> > @@ -279,6 +279,9 @@ static inline void vfio_device_del(struct vfio_devi=
ce *device)
> >
> >  void vfio_init_device_cdev(struct vfio_device *device);
> >  int vfio_device_fops_cdev_open(struct inode *inode, struct file *filep=
);
> > +void vfio_device_cdev_close(struct vfio_device_file *df);
> > +long vfio_device_ioctl_bind_iommufd(struct vfio_device_file *df,
> > +				    struct vfio_device_bind_iommufd __user *arg);
> >  int vfio_cdev_init(struct class *device_class);
> >  void vfio_cdev_cleanup(void);
> >  #else
> > @@ -302,6 +305,16 @@ static inline int vfio_device_fops_cdev_open(struc=
t inode
> *inode,
> >  	return 0;
> >  }
> >
> > +static inline void vfio_device_cdev_close(struct vfio_device_file *df)
> > +{
> > +}
> > +
> > +static inline long vfio_device_ioctl_bind_iommufd(struct vfio_device_f=
ile *df,
> > +						  struct vfio_device_bind_iommufd
> __user *arg)
> > +{
> > +	return -EOPNOTSUPP;
> > +}
> > +
> >  static inline int vfio_cdev_init(struct class *device_class)
> >  {
> >  	return 0;
> > diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> > index c87cc7afe92c..c9fa39ac4b02 100644
> > --- a/drivers/vfio/vfio_main.c
> > +++ b/drivers/vfio/vfio_main.c
> > @@ -574,6 +574,8 @@ static int vfio_device_fops_release(struct inode *i=
node, struct
> file *filep)
> >
> >  	if (df->group)
> >  		vfio_device_group_close(df);
> > +	else
> > +		vfio_device_cdev_close(df);
> >
> >  	vfio_device_put_registration(device);
> >
> > @@ -1147,6 +1149,9 @@ static long vfio_device_fops_unl_ioctl(struct fil=
e *filep,
> >  	struct vfio_device *device =3D df->device;
> >  	int ret;
> >
> > +	if (cmd =3D=3D VFIO_DEVICE_BIND_IOMMUFD)
> > +		return vfio_device_ioctl_bind_iommufd(df, (void __user *)arg);
> > +
> >  	/* Paired with smp_store_release() following vfio_device_open() */
> >  	if (!smp_load_acquire(&df->access_granted))
> >  		return -EINVAL;
> > diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> > index 873275419f13..cf9d082a623c 100644
> > --- a/include/linux/vfio.h
> > +++ b/include/linux/vfio.h
> > @@ -67,6 +67,7 @@ struct vfio_device {
> >  	struct iommufd_device *iommufd_device;
> >  	bool iommufd_attached;
> >  #endif
> > +	bool cdev_opened:1;
> >  };
> >
> >  /**
> > @@ -169,7 +170,7 @@ vfio_iommufd_physical_devid(struct vfio_device *vde=
v)
> >
> >  static inline bool vfio_device_cdev_opened(struct vfio_device *device)
> >  {
> > -	return false;
> > +	return device->cdev_opened;
> >  }
> >
> >  /**
> > diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> > index 24858b650562..07c917de31e9 100644
> > --- a/include/uapi/linux/vfio.h
> > +++ b/include/uapi/linux/vfio.h
> > @@ -194,6 +194,34 @@ struct vfio_group_status {
> >
> >  /* --------------- IOCTLs for DEVICE file descriptors --------------- =
*/
> >
> > +/*
> > + * VFIO_DEVICE_BIND_IOMMUFD - _IOR(VFIO_TYPE, VFIO_BASE + 19,
> > + *				   struct vfio_device_bind_iommufd)
> > + *
> > + * Bind a vfio_device to the specified iommufd.
> > + *
> > + * User is restricted from accessing the device before the binding ope=
ration
> > + * is completed.
> > + *
> > + * Unbind is automatically conducted when device fd is closed.
> > + *
> > + * @argsz:	 User filled size of this data.
> > + * @flags:	 Must be 0.
> > + * @iommufd:	 iommufd to bind.
> > + * @out_devid:	 The device id generated by this bind. devid is a handl=
e for
> > + *		 this device/iommufd bond and can be used in IOMMUFD commands.
> > + *
> > + * Return: 0 on success, -errno on failure.
> > + */
> > +struct vfio_device_bind_iommufd {
> > +	__u32		argsz;
> > +	__u32		flags;
> > +	__s32		iommufd;
> > +	__u32		out_devid;
> > +};
> > +
> > +#define VFIO_DEVICE_BIND_IOMMUFD	_IO(VFIO_TYPE, VFIO_BASE + 19)
> > +
>=20
> Why is this preempting the first device ioctl below rather than being
> added in sequential order?  I'm also not sure what's at device ioctl 18
> that we started at 19.  VFIO_DEVICE_FEATURE is at 17.  Yes, they're
> hard to keep track of.  Thanks,

yes, 17 is the last occupied ioctl offset on device fd. Will correct
it.

Regards,
Yi Liu
