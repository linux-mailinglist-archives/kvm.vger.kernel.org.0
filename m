Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBF55413FFD
	for <lists+kvm@lfdr.de>; Wed, 22 Sep 2021 05:25:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231169AbhIVD0l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Sep 2021 23:26:41 -0400
Received: from mga06.intel.com ([134.134.136.31]:58462 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230054AbhIVD0k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Sep 2021 23:26:40 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10114"; a="284520207"
X-IronPort-AV: E=Sophos;i="5.85,312,1624345200"; 
   d="scan'208";a="284520207"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2021 20:25:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,312,1624345200"; 
   d="scan'208";a="613238953"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga001.fm.intel.com with ESMTP; 21 Sep 2021 20:25:10 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Tue, 21 Sep 2021 20:25:10 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Tue, 21 Sep 2021 20:25:10 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.47) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Tue, 21 Sep 2021 20:25:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KHCt8Tzz388CrvAi3E+JEHFbp1E75327oa20h8vp0tWQg0T+xkX367RQ1KSxbwP+Ae+GOk/c3CgqpG7loj63LU/DcmBKWaRMDheFoJpshS1CkHJ9miulsZQyM1SLFb35FnnCJmI/fNAq22Bz8bN5ziaCD9mYUoqPVV8oHCT0E6yCij1NVeWJa+/PuNycwSCtj4+3FpjLTgDcbMnqW6Sk6ZVqKnFqzQbRCMcFfPCn+rqxnGTuge6MH8hXjzwLH4QXBXIy7/oUczXVrBwN1Fit2WP2KRhVMflfC5bbZWUjd4alG7e8wEecqFgsYN2XDbW0WVR17nEiGPl6ncWEQdYxZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=gA/DEgPA7rKfUYxi5WuNvZbkHPZ5/F1vBvwjPCbzZCY=;
 b=WCja+LwSh7dkJabNOTVO9U6VkMvTEi8qz5AspettEKlmVg1q5PODPcxga8Nge/4sV5dRfvkkyq4tfGq2xSCoVhKLfVn6LyQhXeGIlSnRq4E54xMztMaUOPgmYUeoluwrUoEVYfTGdkzYyQXZV3VIgKaJcN4CjqFe/H66Je2tQy1tlMm7MhTgMxUwC298znQTqoZRKVyZ30eBGYzrF42ZMAmE6z9fLUQ2RJn4H7zxy5B0rVUovpA3V5b6RLxKu9Hn2YAPmhPS4Si7Oy8hpiNjZAA5b7YuSbVMkXjsmPe/n87FSjLC0PYZfXcsKtY56eYjSmOG2vcMiTl8N4Bd1QgrSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gA/DEgPA7rKfUYxi5WuNvZbkHPZ5/F1vBvwjPCbzZCY=;
 b=K9QMhVtWRlyA9MzH30fsqe96xxn8XvcRX1SCknFVBcaJEZx0/OwCpv+PsJ0Ej72gA1SknDsDCbhxdEvOHi6HIHPyylTHxO+R5xl7WPuzdoWjMCXaLBaw0vrq2Y09c0/U02tAXIv9YkCvc9XM7wJpKiM+1x7osqt/RxuDAz+TLdg=
Received: from PH0PR11MB5658.namprd11.prod.outlook.com (2603:10b6:510:e2::23)
 by PH0PR11MB5641.namprd11.prod.outlook.com (2603:10b6:510:d6::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13; Wed, 22 Sep
 2021 03:25:03 +0000
Received: from PH0PR11MB5658.namprd11.prod.outlook.com
 ([fe80::5009:9c8c:4cb4:e119]) by PH0PR11MB5658.namprd11.prod.outlook.com
 ([fe80::5009:9c8c:4cb4:e119%6]) with mapi id 15.20.4523.018; Wed, 22 Sep 2021
 03:25:03 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "hch@lst.de" <hch@lst.de>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "lkml@metux.net" <lkml@metux.net>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "lushenming@huawei.com" <lushenming@huawei.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "yi.l.liu@linux.intel.com" <yi.l.liu@linux.intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>
Subject: RE: [RFC 00/20] Introduce /dev/iommu for userspace I/O address space
 management
Thread-Topic: [RFC 00/20] Introduce /dev/iommu for userspace I/O address space
 management
Thread-Index: AQHXrSFkVs244O/dIkas8ZrIoCf5Fauug4UAgADkicA=
Date:   Wed, 22 Sep 2021 03:25:02 +0000
Message-ID: <PH0PR11MB565893BD99086EC51A8E8267C3A29@PH0PR11MB5658.namprd11.prod.outlook.com>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210921134508.GL327412@nvidia.com>
In-Reply-To: <20210921134508.GL327412@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.6.200.16
dlp-product: dlpe-windows
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1565b33e-c5f1-46f1-6250-08d97d7890f6
x-ms-traffictypediagnostic: PH0PR11MB5641:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR11MB56416E9445681A983BD0F81CC3A29@PH0PR11MB5641.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:663;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JU+tBZsUhPNWPzjYJEnpDZWGl+m0Umk32EDhez0yMD8Nnb77gvBoteChtA2Z+bkzJjp1SPyMZh/3co8SEKsU2okU0eo+yN1agw2pV+Evnk90VLKEm/kxtormAlEGZhql0o7sbYrlceFf/JrIhSpeZXkWaXQwSw64vmROweEsxwfS2FtpSL1oWk0Ls6QMXJK3rahg4+ZRuTStiyeT3Iy+T7D6WTVqNoxTNYLwFpLxiopfXE4RkVvPh+N+RZdE/zT6Of3LXd1eTlv5TiX8tbAwacpD7Ui/5QnlnMNBiGpv0Ga0r47gijOswEhoyLpFG5QVoCdEUNUIfq5JZpJO1fTBaj9w7Cg967txwBdQV4e6plBkbUODRA85QI1P/knFn8m97nmgMoQEwKrr8FptHZMw7Oxa7KhPS8YuYl22GvjGi8Xgc+MJ7sSQva2okJCL/EdL5R4tFoPMnSEhgwryeDldTj7Z+yhocSeN9UCmMFyEjVQmZLD7tKrbdHhv7I565VnHDsGO+UEPUWilPmI/EvvPhCzD9WJcBiDzkW2GwkyANoSTgh3aj9vq3ywM8mroXr3B7GEdlXRINJAd+hM1+QrItLFoMC6t8cHPnnLRJftnE4YmbV4Kh7ZnCkhOQO2ZRaEgBYb1ydgJ5XPbV79okNQ7V/d0mN83fqqogERDD74GEy74hfxb8hjMww/tSSH632YVgtdFc/ufo4CSB8+7vdmLaw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5658.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(38070700005)(33656002)(2906002)(8936002)(5660300002)(52536014)(316002)(508600001)(7416002)(54906003)(122000001)(66476007)(55016002)(7696005)(86362001)(66556008)(9686003)(66946007)(26005)(64756008)(38100700002)(6506007)(186003)(76116006)(66446008)(8676002)(4326008)(71200400001)(6916009)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?6irH3BN1PgmDbpYeGfF76KBthUk3FTT3O72e78i1yP8mCGQy0xOvjQW3sccL?=
 =?us-ascii?Q?l/OF1pLQPO/BVA0ixaktTL2KxeIbvOUgrVJQszr3CCZyqhlh9gEqThorxM+T?=
 =?us-ascii?Q?sdYYOaBYX4l6brGP/POnGJM6Q7TjXMAWLVgAXJ5l+QiY/1CwT53WbMGHUCyG?=
 =?us-ascii?Q?u9B+FT+3iW0xmfh3/MhMUJvTPqW5sMjB7Xdq3cU+74bDwExnW73leLVTXKK2?=
 =?us-ascii?Q?zdSY4/jf+KTfAPw8SLABqkr+obg6Y/qPP7kAgoYvlUJNftH8iVg5gyObBKdh?=
 =?us-ascii?Q?P0Z9WF51mblDYWrO8d0e6INbU3guZbHR9MjMLZSBN6/6PrA5YOXOCGOAYgwo?=
 =?us-ascii?Q?YETf8FSdNJmaPhP+THkudxnCjgICGk3v0xYyaq6FXDf53u8LCTnITfTC3tyz?=
 =?us-ascii?Q?N1aXKY5gH3h2UNNcCKIi+AKB1KhXPTGbtwXmKx7HrVpKbZ7joP3210gdE8At?=
 =?us-ascii?Q?acxEs1ERzE3X8ApOmB7kZeZjl24kkK0eva1bE58saxE6nIhmuw/utZqs/LYX?=
 =?us-ascii?Q?/f/UcZJRS0tResz27WpFZ+t8NXGG73avvrr3KFpRls/JOah3YLAPScVFa12K?=
 =?us-ascii?Q?feaXj2e0p8Ks+tyR6f/7WSoWeAigcrVDoq9msq/UlGwXsXJs0KkZ/yiLxB3N?=
 =?us-ascii?Q?jbZO39+U4NgwsrBB41C4v0tZ8Hx9eW1KGeoz+oTK46qtTXR2ux6D5/LvjbOK?=
 =?us-ascii?Q?HlbIitRSV3V+wg2cNksBu/YFhumATNocTRjn0qVTql2ng+OL+6KK/ZTmZcgJ?=
 =?us-ascii?Q?/5dG4p+QMFOas9o3yPoGXP64hSUrn/Zq30tMCaH8JpYs+LoP2mxOWnvGqigi?=
 =?us-ascii?Q?3d/5SMAhIEpkvIyqsW7JMf3iAFsl9sWYRP9nsWr3VnWzrumSqwKLjSJHs9J8?=
 =?us-ascii?Q?9eV19XITS8mdaGteUF2rFsOSRThUhxSXnzS8C7KlpK12JhGi+GItnVvU2gTy?=
 =?us-ascii?Q?fkPU8wLmEsQ7cYLcXvOQ1QGXUrf8Zy96k+g7wkZUeNzqL1yjC3min0kYeMXI?=
 =?us-ascii?Q?1oeEjhd4IS1HeKQ9nxEIYE1IXXjF0SApsvsbfJj+EMxNBY7MW4eb5sgVDSCy?=
 =?us-ascii?Q?O4eGjP4YvUoaMkR0A+bQj8ofdQFt3xmPNR4sXC/VCECq810Lcf/KXB5eoPQc?=
 =?us-ascii?Q?+FmcCtQyPlM5TOQJBfZ2Z7hXrTL0MT5Dhg9G6iyt4W7fGVw43SHBPd2jGNNe?=
 =?us-ascii?Q?l889JJSZXLDgsY6aEXA5D/SCwkmPLOspomXHJvpQ2Hj6OwuyMPb4cmin5SmM?=
 =?us-ascii?Q?Zy69fVwm0nU18MXRC5X7udb2n+JbXU86qTXgZ+kPmr5o1U042bqU90LwT/R4?=
 =?us-ascii?Q?MVOM/ujUsI4gMRgeztbw+g7l?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5658.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1565b33e-c5f1-46f1-6250-08d97d7890f6
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Sep 2021 03:25:02.9417
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bHrpvyGZ9ljtqdPok6/POthXX3ZyJn4gqQ9vPLTEonnrnPi+Q2HAiSIVfJI9EQ+NvFqyvCcGYP+xrdCkNWdRDg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5641
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Tuesday, September 21, 2021 9:45 PM
>=20
> On Sun, Sep 19, 2021 at 02:38:28PM +0800, Liu Yi L wrote:
> > Linux now includes multiple device-passthrough frameworks (e.g. VFIO
> and
> > vDPA) to manage secure device access from the userspace. One critical
> task
> > of those frameworks is to put the assigned device in a secure, IOMMU-
> > protected context so user-initiated DMAs are prevented from doing harm
> to
> > the rest of the system.
>=20
> Some bot will probably send this too, but it has compile warnings and
> needs to be rebased to 5.15-rc1

thanks Jason, will fix the warnings. yeah, I was using 5.14 in the test, wi=
ll
rebase to 5.15-rc# in next version.

Regards,
Yi Liu

> drivers/iommu/iommufd/iommufd.c:269:6: warning: variable 'ret' is used
> uninitialized whenever 'if' condition is false [-Wsometimes-uninitialized=
]
>         if (refcount_read(&ioas->refs) > 1) {
>             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> drivers/iommu/iommufd/iommufd.c:277:9: note: uninitialized use occurs
> here
>         return ret;
>                ^~~
> drivers/iommu/iommufd/iommufd.c:269:2: note: remove the 'if' if its
> condition is always true
>         if (refcount_read(&ioas->refs) > 1) {
>         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> drivers/iommu/iommufd/iommufd.c:253:17: note: initialize the variable 're=
t'
> to silence this warning
>         int ioasid, ret;
>                        ^
>                         =3D 0
> drivers/iommu/iommufd/iommufd.c:727:7: warning: variable 'ret' is used
> uninitialized whenever 'if' condition is true [-Wsometimes-uninitialized]
>                 if (idev->dev =3D=3D dev || idev->dev_cookie =3D=3D dev_c=
ookie) {
>                     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> drivers/iommu/iommufd/iommufd.c:767:17: note: uninitialized use occurs
> here
>         return ERR_PTR(ret);
>                        ^~~
> drivers/iommu/iommufd/iommufd.c:727:3: note: remove the 'if' if its
> condition is always false
>                 if (idev->dev =3D=3D dev || idev->dev_cookie =3D=3D dev_c=
ookie) {
>=20
> ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> drivers/iommu/iommufd/iommufd.c:727:7: warning: variable 'ret' is used
> uninitialized whenever '||' condition is true [-Wsometimes-uninitialized]
>                 if (idev->dev =3D=3D dev || idev->dev_cookie =3D=3D dev_c=
ookie) {
>                     ^~~~~~~~~~~~~~~~
> drivers/iommu/iommufd/iommufd.c:767:17: note: uninitialized use occurs
> here
>         return ERR_PTR(ret);
>                        ^~~
> drivers/iommu/iommufd/iommufd.c:727:7: note: remove the '||' if its
> condition is always false
>                 if (idev->dev =3D=3D dev || idev->dev_cookie =3D=3D dev_c=
ookie) {
>                     ^~~~~~~~~~~~~~~~~~~
> drivers/iommu/iommufd/iommufd.c:717:9: note: initialize the variable 'ret=
'
> to silence this warning
>         int ret;
>                ^
>                 =3D 0
>=20
> Jason
