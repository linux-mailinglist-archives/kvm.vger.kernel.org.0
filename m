Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 545C472D90C
	for <lists+kvm@lfdr.de>; Tue, 13 Jun 2023 07:24:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238333AbjFMFY0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jun 2023 01:24:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233136AbjFMFYZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jun 2023 01:24:25 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B04AE78;
        Mon, 12 Jun 2023 22:24:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686633863; x=1718169863;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=sPUl/EUvrzIoIHrv8HTivzb42eW5BZu8C87v3SvklGk=;
  b=BznKb6MIzvzJEyBee+km4wWbH6+bSQgouqQ5MUwNQfFOjevFPx/i8ulb
   4b03XdzW+CKgympGbNxe5m6L20L0ItDPtEXF6qMDm38MCvDDSrJI+8R7N
   osEPIpdy6h3LPg9bEHBRR4NT05zzxRdz3gp5jhqJV04db847KSlDTIM3m
   APZFjuV41H1rBG9vW8aHFgyHuMxb5eCYIiEIH7vnHSjP+OkugT+6VzDNU
   EQEx/AWZmQ1uzoQyqlYlJx8x2qcEpkqI3SQFZDCLFr+TYzcEKeQNmEyI1
   R3H2/8czXgQUcwAqlKq1WCHI2nGh6sIxKYVBHdP7gv9HJ8BLy5EI5Lnh4
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10739"; a="342923342"
X-IronPort-AV: E=Sophos;i="6.00,238,1681196400"; 
   d="scan'208";a="342923342"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2023 22:24:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10739"; a="714650183"
X-IronPort-AV: E=Sophos;i="6.00,238,1681196400"; 
   d="scan'208";a="714650183"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga007.fm.intel.com with ESMTP; 12 Jun 2023 22:24:22 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 12 Jun 2023 22:24:21 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 12 Jun 2023 22:24:21 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 12 Jun 2023 22:24:21 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 12 Jun 2023 22:24:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nOa+0XPHPLNciM9EvvxDZD8qBTX5QWwRDVG/87NvX2SXyntsfk4Njr50CgQ4oaO5c3AqFpEfLW9WmpS7puN7sH9iBq4m96mWJf6QDuItCUJABu5UYoawSOEuT0g5beLX6WfPcKr72R6D6fh/164TiPw4GgvU7dldQ7rGnnUGMNOqq4+TtyePXCIVDss1z1PK8bhJIFR0BHabCYCUiSA6/xVV8oPufIEHcnRtgfgz2/2qDLqEsvv1z9tXqeinXtXn5pWL4cwEO1FuGvRxKf8sArxuyDnKXC4hBZGvYjt/cKVUstinqJPbnCBFut1CR6rN5r+DV1lxrUtH3ZGWbytpXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F7yzXG6Dcs6lhIOs8K0HnUeqT7/TaEMnZDTGfdmenQ4=;
 b=dwzpLg6H4oJFqOGl4r+HqXcpQ5oSFoJ2Z3nnnFYgd34WUFYxanrH+kpOu5d6zQue92pAwI2t7ZvoiaIT6Ou73woSqCVezWQ5S2XkhXJQPdmELQDahB1Ugayy7YxRNf2WiViU5ka2Ss0x7s7jAzC9nYaNaDful1Kky6wk2PUD8rzKyQkGKtyCqOiyz5oVlrgnPxqgDCNuuaTcTlDVk7Ws2HfpuMlPEerbqib+EDhXyS7QlFzEqgmyrT/V5uT0IGs6CuN6HZSmJ5pcTqd7nNq1Gb3K3ZRgFSiy6QUbAX/HZcPXrmZzJvlREcvJtb+ma8qEgMkaob4HAPeMjfpYb9vVDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by MW4PR11MB7006.namprd11.prod.outlook.com (2603:10b6:303:22f::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.41; Tue, 13 Jun
 2023 05:24:17 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::5b44:8f52:dbeb:18e5]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::5b44:8f52:dbeb:18e5%3]) with mapi id 15.20.6455.045; Tue, 13 Jun 2023
 05:24:16 +0000
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
Subject: RE: [PATCH v12 06/24] vfio: Pass struct vfio_device_file * to
 vfio_device_open/close()
Thread-Topic: [PATCH v12 06/24] vfio: Pass struct vfio_device_file * to
 vfio_device_open/close()
Thread-Index: AQHZlUwp0chi7m72h0+UXHT/2CK0w6+HxaqAgAB77IA=
Date:   Tue, 13 Jun 2023 05:24:16 +0000
Message-ID: <DS0PR11MB7529AFF981AB916349B980C8C355A@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230602121653.80017-1-yi.l.liu@intel.com>
 <20230602121653.80017-7-yi.l.liu@intel.com> <20230612155207.51d8cf1d@omen>
In-Reply-To: <20230612155207.51d8cf1d@omen>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|MW4PR11MB7006:EE_
x-ms-office365-filtering-correlation-id: 3bbc6afa-1cb3-4b63-85e3-08db6bce6e87
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: talSnhHWdEsmz4WXM5L+H01nowreOzZlbIgbQ0+9A8mna3lQJKLm+NJBg63H+nd/museChLPWxEzmueCLa2ZkGFiwU7jzoGTPO3xzKTVzd9BZqOmChtKlu5FlwUVKTzOcmUW0f2YwokOw+h4SHuJmlaQ+NqIo7AaLE7YC2MN/JqeTzT4T2/RbocfA5HEA9kk1IoM6cqdvby1x0mqDur1jKEKgV5VGZgAZJ8a4valhRj0uEz6yHmjZYxU9iKH0HwGxBcoY0Fn2i3U/ObGEPhDhkbzRZ7CCyyYUrQcwQ5+B2RFmWJ9GxOQ72tDQqEH5I++SxjrG/vKcrFVHT4xrrbrL6q+NOPIlzZNMMYOSSko3QTocMG/3XAg7qnWa/QkAjK5QwrTlindYXAw2Dt5HvhoowpdAAj36U1lg7aOHuEGBj93GD1zXWLadfKy3MchMOksCocBcwSMuL2jjSXccrNve9ordUyLEaxjZoKI+j/odDhqIvdfHnrUqeHfk04tTP4H2djvOkkzvt86SaH3N4MJZYNaxWhFtHYBZSgz5qTV6IiftEqZei9m58R94SBOHs6ktvHPW6hjWAicJhCJp3WEJw3HeyKeXpuX47ch/tVjWP+OwgJvS9S51PKcJZnBo9OM
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(376002)(39860400002)(346002)(366004)(136003)(451199021)(26005)(186003)(6506007)(9686003)(83380400001)(7416002)(7696005)(71200400001)(2906002)(8936002)(8676002)(316002)(54906003)(82960400001)(478600001)(33656002)(55016003)(64756008)(66476007)(38100700002)(5660300002)(38070700005)(122000001)(41300700001)(6916009)(86362001)(4326008)(66446008)(66556008)(52536014)(76116006)(66946007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?3Yd/HrIoFfDakWtqiuLaalFLI0GcPMcyl4V0WYFDlKujql3fp6lCYkGvtg+g?=
 =?us-ascii?Q?U/hMHpf9h22SZlo5SBe4VY4d15DL9LQQRz9H9iue8Ja8XAyRhFm3p/zenfoo?=
 =?us-ascii?Q?YhkgiwpJpStses2Anfr8ELaNc6sZLmuhoMnoQDHwv4B187QcHUyGi+tNJx57?=
 =?us-ascii?Q?cljzSgBDiKvdu32c9uoUicl3tcXT/qIHHs5ijTtgcsYoAovRdrxP8LMz+LO5?=
 =?us-ascii?Q?/x7mP46gsqhbGfphhDON5HjuVRIXhyW1joRPLwOMjjp6X9RUw2pn7VhpjwKA?=
 =?us-ascii?Q?RCWCTylHFG2brr7UoNeHpl7lX48trU679DBNXbpiH1OQnLv20UZ+nfjC7NVH?=
 =?us-ascii?Q?F7a/GtZ4NGilVCaKJQ3Vi3mqYn3szLoYk7DV6SJbrGVZFfmY7BQ3J32JFLvQ?=
 =?us-ascii?Q?KmgBFGCTEa0Tx3pVBKpT3z5w+6beJb58XUd/rA8f6N+SrBg+M0qwFrLFnd67?=
 =?us-ascii?Q?XifvBolDWo6i3CyXE8DFe+ar7tIf0RubWyLOwqUN9X9T/WWlNWRbB0kYaXo0?=
 =?us-ascii?Q?oPQ4pasXNi45eURdSDPhVefMNHFv6a+r+i0a1me0Ya3LbzjZT80G/dzKurvM?=
 =?us-ascii?Q?8fVYGQ/NvIswLyKX11hofqeP39bBO1CO3fFE9R1W+pHMV/PSrAWCXZvLJND7?=
 =?us-ascii?Q?YZqvDBcEAoHBGYLat+hU0CkHoN1Ks7w/b9bi0WKtN5eycQF//tEfRCvWjgA6?=
 =?us-ascii?Q?CK/ZQrr7aXHCApC4VX3WKs/eEFaOEJWI0qjjSIscmSIUJY/FbxP3mZfrK6pD?=
 =?us-ascii?Q?rSJ1NIvaQIR7FT/JqS9NO49F1q9n279ejengBmNJFcvwugQ0ykLbQvaIB95p?=
 =?us-ascii?Q?abJBbL+KcZFFbUQWe2oSJONcLjqm/uoNBR3svqk9twuZqsVfDcHigjYCKb/C?=
 =?us-ascii?Q?Blz/HnOEHZzdvlve/CaF64v5tpjtJp0Kwp+hw7kcJ6LP6A5cnstyd5GRkCdy?=
 =?us-ascii?Q?JjqYTFjJMqdaH269QqYnVOIW6aibQrOdY9xInreEDEZtRuHTy3odsArLWBGq?=
 =?us-ascii?Q?We+K6U4+ugWFdTdM0nrom6bbmWZtYZQMfEr24sLGw8rsraAPbOtKfIQlXzJo?=
 =?us-ascii?Q?9UbrCAk9YrpsjycjO4UN2+K7CuJMe49nRkTkzAKyzJYiiKNIBVb4gESMPvi1?=
 =?us-ascii?Q?q0tY8P7y4A0bna4Nz0E8YgpEufTyYvhJ8dnTJjW8uGCvqOUqZ8Lh23nKrS9/?=
 =?us-ascii?Q?QQAwGm8ZgoTwfOIhHJrqFx/nNI3F0zeMyJDxGG/ni7fpQ6VQ4LXvZ5xc5h2F?=
 =?us-ascii?Q?PxdfNdwXzE/lXZ5zj3tCq/yQaf1N0rao/0Enz7I0GGISa06fi0v7pzdQuH/h?=
 =?us-ascii?Q?QDgOK8YZ75+AyEgPxbdcRDUw7Wov1VQPF2OBWb16LZdJmK7gDfwa3J0ei0G7?=
 =?us-ascii?Q?oVvmLLmpiXUyK8CV4RVKYaSZ1CvAbD6ooLZ+T2e96Bg8CQpgd2JqQJjdw2wL?=
 =?us-ascii?Q?O5pVUsC+jXF6E+ZAjnrrKjeZmeDnVzQrzReA2OsqnhMGlCvnqh57YB86+PtF?=
 =?us-ascii?Q?Hw2t07tbCGYwGmGomxeTSKbBIZgxui/DnL5JCFoNGhEZeN0Ik+idxVWtPICb?=
 =?us-ascii?Q?TXwxQfkJA58L4Sonlik8gAOU97nxX4RWxeiZCzzt?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3bbc6afa-1cb3-4b63-85e3-08db6bce6e87
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jun 2023 05:24:16.4517
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hxu2So/jupc0azcRxXsizkfSuaoYm3D1IIa301abUJuAFZmMpVZ4Dy1z8XqAhsWfCr2xbCFMAIXG6gYKlJJ4Ow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB7006
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Tuesday, June 13, 2023 5:52 AM
>=20
> On Fri,  2 Jun 2023 05:16:35 -0700
> Yi Liu <yi.l.liu@intel.com> wrote:
>=20
> > This avoids passing too much parameters in multiple functions. Per the
> > input parameter change, rename the function to be vfio_df_open/close().
> >
> > Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> > Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> > Reviewed-by: Eric Auger <eric.auger@redhat.com>
> > Tested-by: Terrence Xu <terrence.xu@intel.com>
> > Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> > Tested-by: Matthew Rosato <mjrosato@linux.ibm.com>
> > Tested-by: Yanting Jiang <yanting.jiang@intel.com>
> > Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> > Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> > ---
> >  drivers/vfio/group.c     | 20 ++++++++++++++------
> >  drivers/vfio/vfio.h      |  8 ++++----
> >  drivers/vfio/vfio_main.c | 25 +++++++++++++++----------
> >  3 files changed, 33 insertions(+), 20 deletions(-)
> >
> > diff --git a/drivers/vfio/group.c b/drivers/vfio/group.c
> > index b56e19d2a02d..caf53716ddb2 100644
> > --- a/drivers/vfio/group.c
> > +++ b/drivers/vfio/group.c
> > @@ -169,8 +169,9 @@ static void vfio_device_group_get_kvm_safe(struct v=
fio_device
> *device)
> >  	spin_unlock(&device->group->kvm_ref_lock);
> >  }
> >
> > -static int vfio_device_group_open(struct vfio_device *device)
> > +static int vfio_df_group_open(struct vfio_device_file *df)
> >  {
> > +	struct vfio_device *device =3D df->device;
> >  	int ret;
> >
> >  	mutex_lock(&device->group->group_lock);
> > @@ -190,7 +191,11 @@ static int vfio_device_group_open(struct vfio_devi=
ce *device)
> >  	if (device->open_count =3D=3D 0)
> >  		vfio_device_group_get_kvm_safe(device);
> >
> > -	ret =3D vfio_device_open(device, device->group->iommufd);
> > +	df->iommufd =3D device->group->iommufd;
> > +
> > +	ret =3D vfio_df_open(df);
> > +	if (ret)
> > +		df->iommufd =3D NULL;
> >
> >  	if (device->open_count =3D=3D 0)
> >  		vfio_device_put_kvm(device);
> > @@ -202,12 +207,15 @@ static int vfio_device_group_open(struct vfio_dev=
ice
> *device)
> >  	return ret;
> >  }
> >
> > -void vfio_device_group_close(struct vfio_device *device)
> > +void vfio_df_group_close(struct vfio_device_file *df)
> >  {
> > +	struct vfio_device *device =3D df->device;
> > +
> >  	mutex_lock(&device->group->group_lock);
> >  	mutex_lock(&device->dev_set->lock);
> >
> > -	vfio_device_close(device, device->group->iommufd);
> > +	vfio_df_close(df);
> > +	df->iommufd =3D NULL;
> >
> >  	if (device->open_count =3D=3D 0)
> >  		vfio_device_put_kvm(device);
> > @@ -228,7 +236,7 @@ static struct file *vfio_device_open_file(struct vf=
io_device
> *device)
> >  		goto err_out;
> >  	}
> >
> > -	ret =3D vfio_device_group_open(device);
> > +	ret =3D vfio_df_group_open(df);
> >  	if (ret)
> >  		goto err_free;
> >
> > @@ -260,7 +268,7 @@ static struct file *vfio_device_open_file(struct vf=
io_device
> *device)
> >  	return filep;
> >
> >  err_close_device:
> > -	vfio_device_group_close(device);
> > +	vfio_df_group_close(df);
> >  err_free:
> >  	kfree(df);
> >  err_out:
> > diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
> > index 69e1a0692b06..f9eb52eb9ed7 100644
> > --- a/drivers/vfio/vfio.h
> > +++ b/drivers/vfio/vfio.h
> > @@ -20,13 +20,13 @@ struct vfio_device_file {
> >  	struct vfio_device *device;
> >  	spinlock_t kvm_ref_lock; /* protect kvm field */
> >  	struct kvm *kvm;
> > +	struct iommufd_ctx *iommufd; /* protected by struct vfio_device_set::=
lock */
> >  };
> >
> >  void vfio_device_put_registration(struct vfio_device *device);
> >  bool vfio_device_try_get_registration(struct vfio_device *device);
> > -int vfio_device_open(struct vfio_device *device, struct iommufd_ctx *i=
ommufd);
> > -void vfio_device_close(struct vfio_device *device,
> > -		       struct iommufd_ctx *iommufd);
> > +int vfio_df_open(struct vfio_device_file *df);
> > +void vfio_df_close(struct vfio_device_file *df);
> >  struct vfio_device_file *
> >  vfio_allocate_device_file(struct vfio_device *device);
> >
> > @@ -91,7 +91,7 @@ void vfio_device_group_register(struct vfio_device *d=
evice);
> >  void vfio_device_group_unregister(struct vfio_device *device);
> >  int vfio_device_group_use_iommu(struct vfio_device *device);
> >  void vfio_device_group_unuse_iommu(struct vfio_device *device);
> > -void vfio_device_group_close(struct vfio_device *device);
> > +void vfio_df_group_close(struct vfio_device_file *df);
> >  struct vfio_group *vfio_group_from_file(struct file *file);
> >  bool vfio_group_enforced_coherent(struct vfio_group *group);
> >  void vfio_group_set_kvm(struct vfio_group *group, struct kvm *kvm);
> > diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> > index 8ef9210ad2aa..a3c5817fc545 100644
> > --- a/drivers/vfio/vfio_main.c
> > +++ b/drivers/vfio/vfio_main.c
> > @@ -434,9 +434,10 @@ vfio_allocate_device_file(struct vfio_device *devi=
ce)
> >  	return df;
> >  }
> >
> > -static int vfio_device_first_open(struct vfio_device *device,
> > -				  struct iommufd_ctx *iommufd)
> > +static int vfio_device_first_open(struct vfio_device_file *df)
> >  {
> > +	struct vfio_device *device =3D df->device;
> > +	struct iommufd_ctx *iommufd =3D df->iommufd;
> >  	int ret;
> >
> >  	lockdep_assert_held(&device->dev_set->lock);
> > @@ -468,9 +469,11 @@ static int vfio_device_first_open(struct vfio_devi=
ce *device,
> >  	return ret;
> >  }
> >
> > -static void vfio_device_last_close(struct vfio_device *device,
> > -				   struct iommufd_ctx *iommufd)
> > +static void vfio_device_last_close(struct vfio_device_file *df)
>=20
> Shouldn't these now be vfio_df_... functions too?  Thanks,

Yes. vfio_device_first_open() and vfio_device_last_close() should be
named like vfio_df...()

Regards,
Yi Liu

>=20
> >  {
> > +	struct vfio_device *device =3D df->device;
> > +	struct iommufd_ctx *iommufd =3D df->iommufd;
> > +
> >  	lockdep_assert_held(&device->dev_set->lock);
> >
> >  	if (device->ops->close_device)
> > @@ -482,15 +485,16 @@ static void vfio_device_last_close(struct vfio_de=
vice *device,
> >  	module_put(device->dev->driver->owner);
> >  }
> >
> > -int vfio_device_open(struct vfio_device *device, struct iommufd_ctx *i=
ommufd)
> > +int vfio_df_open(struct vfio_device_file *df)
> >  {
> > +	struct vfio_device *device =3D df->device;
> >  	int ret =3D 0;
> >
> >  	lockdep_assert_held(&device->dev_set->lock);
> >
> >  	device->open_count++;
> >  	if (device->open_count =3D=3D 1) {
> > -		ret =3D vfio_device_first_open(device, iommufd);
> > +		ret =3D vfio_device_first_open(df);
> >  		if (ret)
> >  			device->open_count--;
> >  	}
> > @@ -498,14 +502,15 @@ int vfio_device_open(struct vfio_device *device, =
struct
> iommufd_ctx *iommufd)
> >  	return ret;
> >  }
> >
> > -void vfio_device_close(struct vfio_device *device,
> > -		       struct iommufd_ctx *iommufd)
> > +void vfio_df_close(struct vfio_device_file *df)
> >  {
> > +	struct vfio_device *device =3D df->device;
> > +
> >  	lockdep_assert_held(&device->dev_set->lock);
> >
> >  	vfio_assert_device_open(device);
> >  	if (device->open_count =3D=3D 1)
> > -		vfio_device_last_close(device, iommufd);
> > +		vfio_device_last_close(df);
> >  	device->open_count--;
> >  }
> >
> > @@ -550,7 +555,7 @@ static int vfio_device_fops_release(struct inode *i=
node, struct
> file *filep)
> >  	struct vfio_device_file *df =3D filep->private_data;
> >  	struct vfio_device *device =3D df->device;
> >
> > -	vfio_device_group_close(device);
> > +	vfio_df_group_close(df);
> >
> >  	vfio_device_put_registration(device);
> >

