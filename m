Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B273B7192FC
	for <lists+kvm@lfdr.de>; Thu,  1 Jun 2023 08:06:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231219AbjFAGG0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Jun 2023 02:06:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbjFAGGY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Jun 2023 02:06:24 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B3259F;
        Wed, 31 May 2023 23:06:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685599582; x=1717135582;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=+YgtdR2rcJRIkb2eWSggxC2lXyPs1zH90KzhgSRseaU=;
  b=IxKOMHFSWeAuYw0hFC8GC+40mXC51zPJb8NBBy9vAa5tXgiX2lunO0tv
   z+UZvnYENaLkKrtkbNq8eswWwI5GKV+vXykr7HfyIX9OLCSAeNRiGAVhc
   r6OCCvekpXlyUtZVZlckG/S3N4sOPvb5AiPM0K2TrnYwDXVlF2q6agKCA
   tsVkEB64bSP6FTntEeKW4bV1aFRJocd+R/4DxsL7MPINdNAWuT0lrtozL
   PNtwymw7YAd4PJwdg2jowh00IhyOWaGarIzTmMHjRfY+IC7vvDlJhAoqD
   JB0pe3zmbMpsAa53P8HJmQ0Pnwv+rdR5Geu5keVZ+IXSUPgqOiinohkTM
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10727"; a="418964369"
X-IronPort-AV: E=Sophos;i="6.00,209,1681196400"; 
   d="scan'208";a="418964369"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2023 23:06:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10727"; a="736953256"
X-IronPort-AV: E=Sophos;i="6.00,209,1681196400"; 
   d="scan'208";a="736953256"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga008.jf.intel.com with ESMTP; 31 May 2023 23:06:21 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 31 May 2023 23:06:20 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 31 May 2023 23:06:20 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 31 May 2023 23:06:20 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 31 May 2023 23:06:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cFXTMcpqADw0iS3nGozMHf9BXOrAa7QHtZrToVkGvjibySpg5vOspmsFtzYF/PXXXxmek4CucMoeK7CEoxeq2K9jmPlQ5EjlIen3quEkYBLy21l2SdPKrzIPLFHGoxN+dujmE0SUxLXIezT+Fl3uSyv7dR/XmAz657GiCcyNYJat5MmavU6uc0Np/E6+Ap5mF/zqmuDyr5Gu0Dr/Zi2y0vistm3kkLErHqkuuXQ0VlFI+zxMWIy68Vq/hwfPZHBbRrNnc4YYgqy5WPrKOWJkI8hWZM1KnTvAcmzNCUivzzO0PfUUzJ2CecyEwLGe/IjJ9QILb9oYpNZdAOplu/z4fw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PrNUFJM3kgT97lTdU08L5d+Nr6e4bwcSzEsq20eNl+A=;
 b=eTT+s+cRaocQE1k2MqoG+7QpInVUQaSoGlGcDfVBtBjYb1mYEPBJXqe7PLAJpcHSZOBFxhaeRy42aL1mbZAL+yQbGF0BB2+txpMaZp1cRtZtS2tjdKiYHCP+A0G3C62gUCMJmlIdhfLaCuObzjJowthyY0++PUpMsw3Qh+K9EbqM+2Tnqh31H+mPDtvEOMSuUagRLz+4BpVX8Zx/yR+MFyJU5hQKykiZbQN1aWx2e+0SFIeuvm7JbfNBsaG5MYVZGtPL4n9J479phBfcNC7mqsKqs3wUUJbQLaTPI9OGvgbpbsIQM7UqlNFT6M5QDR2gXMnoIl7LgrroPVzGFgg2AQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by SA1PR11MB7112.namprd11.prod.outlook.com (2603:10b6:806:2b7::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.24; Thu, 1 Jun
 2023 06:06:17 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::5b44:8f52:dbeb:18e5]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::5b44:8f52:dbeb:18e5%3]) with mapi id 15.20.6433.024; Thu, 1 Jun 2023
 06:06:17 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Baolu Lu <baolu.lu@linux.intel.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
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
Subject: RE: [PATCH v6 09/10] vfio/pci: Extend
 VFIO_DEVICE_GET_PCI_HOT_RESET_INFO for vfio device cdev
Thread-Topic: [PATCH v6 09/10] vfio/pci: Extend
 VFIO_DEVICE_GET_PCI_HOT_RESET_INFO for vfio device cdev
Thread-Index: AQHZjKSwmm8rv7BAt0eU9VbGFQ2Xy69p2kCAgAEPLxCAAOoUgIAI93QAgAC4QMA=
Date:   Thu, 1 Jun 2023 06:06:17 +0000
Message-ID: <DS0PR11MB7529B223BD86210A21D142B2C3499@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230522115751.326947-1-yi.l.liu@intel.com>
 <20230522115751.326947-10-yi.l.liu@intel.com>
 <20230524135603.33ee3d91.alex.williamson@redhat.com>
 <DS0PR11MB752935203F87D69D4468B890C3469@DS0PR11MB7529.namprd11.prod.outlook.com>
 <355a9f1e-64e6-d785-5a22-027b708b4935@linux.intel.com>
 <ZHeZPPo/MWXV1L9Q@nvidia.com>
In-Reply-To: <ZHeZPPo/MWXV1L9Q@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|SA1PR11MB7112:EE_
x-ms-office365-filtering-correlation-id: bf83b9a5-af3a-42e4-37a7-08db6266501e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BOAZWl4cU5ESnJSnA52w9tvM9scHtlYyqPTYcjH7qTK/AKmBoy1CJNSZ8sRWoJZFyeOGfGs4QHiyyMMBxtQ1J0l19AVduMXhQVuVlnNrJEeAbnsOoD2p6b6/VJm1YKL3Suoe7lXapentpcGd6z9gtC5ShoZ7sYDzzingHNyt96IaYO/ypEv3+6NLSTUdqi8EECUrTw0K0zSJERXiamwfuReoaZRQqOFx9dsCbhXKRwt+2zdZyxO7onTUMKsIz37Xvh1lcTHrIgq19APydUsShaPPDfiiAj+/VUbnSly6QtA232oJ6oQj3wgqgbeKhMiSD3xouSJri1u8wvjhcB4TXOZCF5Lh5r/6NkJc7IgnHeb5pGdF1yNa9b3gPfHE1xQKNQjkn+oX3QDpQZVlDnxTmCqEKODMX6g9JRrYqq8IM9XVLKnbrwNjZ9/PwCHbu6QuReFYqTkSDqGYpLX9fETLxZuPET1ndFwkfG0pYMrO5O6zAcl0YGnkMF83r6CzQd/CLrnrE7Bpz7lCfebD1URmCvVln7+VwRwM6uv6wAdST00h52L6wz+c6NGouGB6yFN5L1nIie7LYGDhMhPUg1pB4qJfCCrHdiXAzcOZXLI8Stv4mLuRon2oIBiOy7CEgzFr
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(376002)(39860400002)(366004)(346002)(396003)(451199021)(71200400001)(478600001)(26005)(33656002)(53546011)(6506007)(83380400001)(186003)(86362001)(9686003)(38070700005)(38100700002)(122000001)(82960400001)(55016003)(7696005)(316002)(41300700001)(4326008)(66446008)(66556008)(76116006)(64756008)(66946007)(66476007)(52536014)(8936002)(7416002)(5660300002)(8676002)(2906002)(110136005)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?mvEgRFwwmmTTBXrIP3pLi0G8AcpXFhchB0O9b7pY5hA9/xiPgCr+rGhLc4TX?=
 =?us-ascii?Q?E0Vw9Zu9Lxhx9n7fq9YOMahNlGfyNobG8xFUjmE4PW7aIxc48bXlKmKAGxOG?=
 =?us-ascii?Q?PNBBQX5hmV+AYYpmSAvbpYklUH98jF8GFqthQcq+UyTseN0AWtE6GX8n6yaL?=
 =?us-ascii?Q?chNasPL6jPqDclsYSEp3EfO4ufgpCpjNIA02uXCVvOn/OfcgGLrqxs5zFyJn?=
 =?us-ascii?Q?Oq+OYQOnYTRiyFe5T3MJCTltXueVl9uQWuYSz/mZuFfpN/lNDOb/tN4tyxuE?=
 =?us-ascii?Q?ZzcHGkE+qjb1J7U2b+6Q6i39E4/3Thc961kP8mux8rPw2FAa0PH098JrtJVQ?=
 =?us-ascii?Q?VztYYRCzyZwLQrAYwRoEWrcoaCXzO9CNhZmlyO38iuWrV3WUS+vCjxmxugQq?=
 =?us-ascii?Q?Pv5VuiEYFQXkmu5UQV9ecZCwoV8dJZFbIc+lGGjze5HAzEoHyeNXGDLDDzdi?=
 =?us-ascii?Q?O1rXGVIhC413RIyeyRloZFK7Q3VgeYqWJNn1G1s2QZNm2BJBs9D4VNybCIel?=
 =?us-ascii?Q?B9usbwnSwlCccPozm0A/sDZSXRnZ5EIEWQDgf0RJWz8BYqtIF+VvoZ3pKE/Z?=
 =?us-ascii?Q?DGDUWXGkByhd61zCbFjpiIyOP4gFyrjBiNrPzsyUu4/iWLCVpGVveTgSkVOb?=
 =?us-ascii?Q?f3XKOYeVrF0a+MOp3deBofcsfWRpQZzg+2A4B/ec80oYinuMaYoUeLafg2Iu?=
 =?us-ascii?Q?ll/IsmvMBdJB2osn3KeqjjC3gBxyf7XkDaQAOcaTrywo8kogYBUQvBIn9pdp?=
 =?us-ascii?Q?fQmuwRjttDShJwaxOPTU1/VC283fYMrNNQDjwAQGHSA8g/ho/FdlnCatueYX?=
 =?us-ascii?Q?P2vWc+sbL1eMinBmeDfFT/XLHEU+4m9MsB1PvUwNVE4SOSFQ3wlddpsq6gPq?=
 =?us-ascii?Q?7xrgBajdhvOZb9F3/rvnkpEGuF5B76++/KKzvwljC2sC0Bv/GmUL+iFsyjfF?=
 =?us-ascii?Q?7UkVoSjAmF4XKObqKGAabrLYqw+gTi3RHbYzO/LnU5YiH+pIS0G/Hp+B6ATr?=
 =?us-ascii?Q?hdh2xn7tCAejCdes4wI1usGt0LA2V0qdpcF48Uo9/lwScrpw7/C372B+XGnt?=
 =?us-ascii?Q?xbnJwjGYl5EhlBwd0g41oulMwy5QRWQSnXihzMweo/xqOfnqYKgT/LZgoxSL?=
 =?us-ascii?Q?AQIyYZqO4xVCIpxGJZw278lvwm1qpM1HSXRavIkboKZUCaEC+F4SF7Te06Ry?=
 =?us-ascii?Q?6QM1W8pnP6HBpHjoMRad8ChRjELC+ddaD9qetkdCt616A5qDQYcBGbj90A8Q?=
 =?us-ascii?Q?PLRLrDX0HXisWFeG2OCj5gSkLvRrtA+wUUKHmr1gVbyr4HDtEO52c2uRQiwX?=
 =?us-ascii?Q?HqROXJ78DYrWgn/SyLeTMFSFsExpR6VaHujPVHalsAHrdRaSw2vY9SHe6gUU?=
 =?us-ascii?Q?1GAail5KJyz7wxhFrYtDti6Ly3FmabQNe2qfjr5MUxh9j9oFeb0CSUiL7B0j?=
 =?us-ascii?Q?dveth0HME1haA32GwOJM9FoDo7Mqdg6Vavjwgf2KPgUbNTpaJULRfkVceDrj?=
 =?us-ascii?Q?nh3ibSQKvBkqQcXclZ8DPUoHHDUzJ3TcCDSTN/mPmzhyigS6gFqolq8h0e03?=
 =?us-ascii?Q?cnthDXzsRuvCOSmfUwmgolPWbifkgLN/CvVXujEK?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf83b9a5-af3a-42e4-37a7-08db6266501e
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Jun 2023 06:06:17.3381
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9ln4tBDE7+9X5M358WAIaHcUUmCImr/USo7ijE9x9wgfeQ3DIumT3dTcLW3UkfiqmOLEh0fhia7j3wrBJKPqMA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB7112
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Thursday, June 1, 2023 3:00 AM
>=20
> On Fri, May 26, 2023 at 10:04:27AM +0800, Baolu Lu wrote:
> > On 5/25/23 9:02 PM, Liu, Yi L wrote:
> > > >   It's possible that requirement
> > > > might be relaxed in the new DMA ownership model, but as it is right
> > > > now, the code enforces that requirement and any new discussion abou=
t
> > > > what makes hot-reset available should note both the ownership and
> > > > dev_set requirement.  Thanks,
> > > I think your point is that if an iommufd_ctx has acquired DMA ownerhi=
sp
> > > of an iommu_group, it means the device is owned. And it should not
> > > matter whether all the devices in the iommu_group is present in the
> > > dev_set. It is allowed that some devices are bound to pci-stub or
> > > pcieport driver. Is it?
> > >
> > > Actually I have a doubt on it. IIUC, the above requirement on dev_set
> > > is to ensure the reset to the devices are protected by the dev_set->l=
ock.
> > > So that either the reset issued by driver itself or a hot reset reque=
st
> > > from user, there is no race. But if a device is not in the dev_set, t=
hen
> > > hot reset request from user might race with the bound driver. DMA own=
ership
> > > only guarantees the drivers won't handle DMA via DMA API which would =
have
> > > conflict with DMA mappings from user. I'm not sure if it is able to
> > > guarantee reset is exclusive as well. I see pci-stub and pcieport dri=
ver
> > > are the only two drivers that set the driver_managed_dma flag besides=
 the
> > > vfio drivers. pci-stub may be fine. not sure about pcieport driver.
> >
> > commit c7d469849747 ("PCI: portdrv: Set driver_managed_dma") described
> > the criteria of adding driver_managed_dma to the pcieport driver.
> >
> > "
> > We achieve this by setting ".driver_managed_dma =3D true" in pci_driver
> > structure. It is safe because the portdrv driver meets below criteria:
> >
> > - This driver doesn't use DMA, as you can't find any related calls like
> >   pci_set_master() or any kernel DMA API (dma_map_*() and etc.).
> > - It doesn't use MMIO as you can't find ioremap() or similar calls. It'=
s
> >   tolerant to userspace possibly also touching the same MMIO registers
> >   via P2P DMA access.
> > "
> >
> > pci_rest_device() definitely shouldn't be done by the kernel drivers
> > that have driver_managed_dma set.
>=20
> Right
>=20
> The only time it is safe to reset is if you know there is no attached
> driver or you know VFIO is the attached driver and the caller owns the
> VFIO too.
>=20
> We haven't done a no attached driver test due to races.

Ok. @Alex, should we relax the above dev_set requirement now or should
be in a separate series?

Regards,
Yi Liu

