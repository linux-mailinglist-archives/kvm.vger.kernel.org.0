Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA6366DAA57
	for <lists+kvm@lfdr.de>; Fri,  7 Apr 2023 10:44:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238501AbjDGIog (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Apr 2023 04:44:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240264AbjDGIoc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Apr 2023 04:44:32 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A27794EED;
        Fri,  7 Apr 2023 01:44:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680857070; x=1712393070;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=jej4iasYEX4SPnZZ1c/ZuGWPJX4PIVYpGVBuogUVkaA=;
  b=FGZaz08GoQtDnUlrdaCPShd88N9mRVHy4wJ5CaynqO38dqbKSQZFhwSq
   zMy0zXPcJdxZg5Pvo38kttKuo+/TEyMsCW5yY7r51N+ZsWIjiwnyNDlYM
   KpmbDKliwG09moQzKj86to3iKvMcZgrqTj3wn5p/oZ8aCiLRUH2ehJznP
   K9AXMEgI80lOiWJxcYMOlBnCs0KlNtHAI+q+vnGjkUwZ56T0t+97GJBnU
   bSPi2FD8AEPRik8D9k6n74UG3bScsrc9D8+ydqn0N+/qOcNGbAyGko5PQ
   Kebe4eckI8D6XwEOhC2Sly95EzaU6NVoNIbAZnrHBPFHCw7FFhFyZkeJc
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10672"; a="408079431"
X-IronPort-AV: E=Sophos;i="5.98,326,1673942400"; 
   d="scan'208";a="408079431"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2023 01:44:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10672"; a="717771631"
X-IronPort-AV: E=Sophos;i="5.98,326,1673942400"; 
   d="scan'208";a="717771631"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga008.jf.intel.com with ESMTP; 07 Apr 2023 01:44:29 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 7 Apr 2023 01:44:29 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 7 Apr 2023 01:44:28 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Fri, 7 Apr 2023 01:44:28 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.104)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Fri, 7 Apr 2023 01:44:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bFpyyVwDp3hsD5aj+k3Pg5aN1UoIlB9Ry8hvA5KOnwWj10wVGLgs/yILfMD5hrHsz3TabpXWwAUAGh8w1SGs7418BuiGQE+RQVmygimuus1/EthEEdaUb4PB5roFNHzVoT29I/L23h71ATZPftHHjqWNn+IWWXnXj8AnsmsW7vN97vFG9COZ9XLT0W5y9MUa8xkgNK329JdmGYnDOU7F8tE/tAj4LymEFqTKp6+JF1gwj0NE4/8WUvQWpqjwbd0Pk+xAkNBo74z06tRIscHOYKavoVtxlGim83a3va3SmpkoAeQEmiL4PYrvESYt4++GRu/E1+akrANLkLQRU0aZ8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sqDyD/veZXme2W84wpDW/D1xRpVh/i1SlKQBOTwrTMc=;
 b=fFmKIpBgq/66LQweWt1VYaeEp8o3XxBDmtx+YWwE118XQjm2ePOmvgjy7M7IOYJMHdFBUOs2FTONxH3HhCU5bTYDHiixJP/dTuFvOHynE6WVlarKBEHQQLLkxvzs2c+021c/ZtEPKp5h1WwP0eN9xkogR7hhJyF1tPS17Oq3n9ioZHl94d8Vb7yKhZofLGagcA2wgPBW7n3/iOSFQrotG1svjGcaed+RE9opyXNYyO4zseHKGhmQ2cuVXcAW1Whr4KzUzx5UVz3Ggx57kIS53kA+IlceIUiGbG80DMF1zioVEYST9zTDrJroAzujzH3w9eOaIP+GRBPtHpHWNKMx3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by CH3PR11MB7914.namprd11.prod.outlook.com (2603:10b6:610:12c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.33; Fri, 7 Apr
 2023 08:44:26 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::ca24:b399:b445:a3de]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::ca24:b399:b445:a3de%5]) with mapi id 15.20.6254.035; Fri, 7 Apr 2023
 08:44:26 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
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
        "Jiang, Yanting" <yanting.jiang@intel.com>
Subject: RE: [PATCH v9 25/25] docs: vfio: Add vfio device cdev description
Thread-Topic: [PATCH v9 25/25] docs: vfio: Add vfio device cdev description
Thread-Index: AQHZZK1I22lo3oshSECHFVLEjZkUbK8cwGyAgAACgeCAADNoAIACmRZQ
Date:   Fri, 7 Apr 2023 08:44:25 +0000
Message-ID: <DS0PR11MB7529E5123CD4A49B86D73A25C3969@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230401151833.124749-1-yi.l.liu@intel.com>
        <20230401151833.124749-26-yi.l.liu@intel.com>
        <cc500fe5-1fdf-1b71-a5b4-f9f917b1abf2@redhat.com>
        <DS0PR11MB752960F2A336E30ACA9E9ECEC3909@DS0PR11MB7529.namprd11.prod.outlook.com>
 <20230405105828.6d170cec.alex.williamson@redhat.com>
In-Reply-To: <20230405105828.6d170cec.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|CH3PR11MB7914:EE_
x-ms-office365-filtering-correlation-id: 54e9620f-7eff-4c0d-1f4e-08db37444b0e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FNgiUZLIHjDbM06K/XNlv2eST4qbM0VQ9w451DCFmbkltClQGKnQKRXpPU8jKKKvgMZZpnZeY+Vh/LaI+Q/2S3UObKLANP1WU6oxLJjCQkvVjbzNdpq1COGwnqmM1hKY5gSx/gPjYPT0ANX7JckUgdA6flOPZPxRdBeLSysbMcjrqsTDRiGcd6CXuaXgDmVp9SYKuNqM2C31gcEgZMIzNMInNImlJVWzdsktErl+hK2JgML612HgVUWU5SCOcjFxA3kK6CqvXsUyHwRfhjJ5tAyd1vWHfLX1pegq2c4d6yiRVScKn+bofs/MHjOXjiuD7tOqs33qOULm2Dmlm7+ItbtoYnR0t2P8A+oGe1JfIVAiv2xMhar4j/mjplLkr/o9LsKCq7qSdfpB6PMfqGvGWLeHqU0JIaJVxqB9MHrwpOa7mXYzLCwCmkMo3F0F9mfB7+z3dhFGXc0hcwNc9BBZfvrAkyzyJt+8/Y+dS62Xuc3OnV7ZwrLjpodzm1eZ/l3QbngXcupGwShtIJg4rGEvip5Gp68465HuoYVVQDz9oXTT/HyqPoXVbAE7fbvUdhKp4eT9Y8hy/b1630N4zhOy38aNlmk+y/24b7Cj9k32OlrGYHEVsGbW7LJqTTHoRg+W
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(396003)(136003)(366004)(39860400002)(376002)(451199021)(82960400001)(122000001)(38100700002)(86362001)(33656002)(38070700005)(71200400001)(7696005)(52536014)(8936002)(478600001)(316002)(7416002)(5660300002)(6506007)(55016003)(9686003)(2906002)(26005)(53546011)(186003)(66446008)(6916009)(66476007)(64756008)(76116006)(66946007)(8676002)(66556008)(54906003)(41300700001)(4326008)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?KgrCRBgy0+lvFpl32pxfyvcuNZ6lqJ/RcbrVC9EzM0GOvnE7xFP9mhEB6p3O?=
 =?us-ascii?Q?EKyhLSdkRivZUpLJC9AYrkj+LeT3tuAQ76h+h9Ei5f7U4doRSQK/wPMUuBsq?=
 =?us-ascii?Q?Ptw0z3Nr9FsY+y1NVgEe/NauWnnHTE97b3CRzC1HaCmNL48KEb0n0CrsrE5r?=
 =?us-ascii?Q?qRcvZtONSlp4tT9YfwJrtfqW1XclSZNLTIElzkiDAHKNDvDfa0xte3EZe4e3?=
 =?us-ascii?Q?MTPrNR0C7wZPxHdTbemswpWqyEDBxTRsf03HoxRgwDdVrVn6UPnEXihQqjue?=
 =?us-ascii?Q?pnoBODxYIFoqeFhiq8u7SbmUkAcziRcqbcn1u+gIwYGNhkJHkgHZREz+0AX1?=
 =?us-ascii?Q?pmu4IcJ1FbThisTGsrgCh+pkKeCBnZOxYne3kiPtCc8TDiHph3vcf454Vxc/?=
 =?us-ascii?Q?uTuX22usk9JHjhN07TcqldRf7mGAuJIAIhOCkXcqsG5LQNq/VO2lr1EqIRwN?=
 =?us-ascii?Q?sEbFxNzC0rvN2CEAJel6MndU0ZffqETYR1vd1D+OFaCTPTao9rfv1RMMWJA5?=
 =?us-ascii?Q?5rB3oHpNk3Iq7OQNC+Ajto0gMhyn1iyhyuocCS7Vo2D5tOTgSO7HS8ARaei4?=
 =?us-ascii?Q?+NPaAPIrEUXVSmLXBKqWZCmrjolXVfG7H+wNf8XapbUlpF8DKMZ557u0Gc7H?=
 =?us-ascii?Q?/8v/o3nVH1dwAdAueXeQwPi3GAsKdJu04NU+4vUByJbufwWlIBHoRgBQo6dr?=
 =?us-ascii?Q?qu8ASHX+ADqsBOZLHX//H7Wcr8dxNEL3OZ0DW7mzPxXiXb1TA8C8n0Xov5up?=
 =?us-ascii?Q?W/ALW3ntxrP6w7Hl8ScJLiqkV1GPDmBTIs9KEc8FE5N4Aqzld37q7o1zagZv?=
 =?us-ascii?Q?tdMa0zNnI5D0zE70FTwbPKmIViAZQcki2RLilvseQBBHutVzQ+vcikntKueP?=
 =?us-ascii?Q?MU47YoGlXGW3R5wVvh8CKdyy4UEcTDmS1tqITTFadiG68dbs7kMtIrQ5ptZz?=
 =?us-ascii?Q?nqvfdMx2a9HiscbyGvLhwR79d5ffASvYEAa4qAGJ35m0KU+xjo+3OIhyXrYN?=
 =?us-ascii?Q?et4hCvIN3QGtMSTPFXdl0vlq6Xo+kjd/+IBr9LLCX9HZGGb5YZNCGe42QW2G?=
 =?us-ascii?Q?6wd+sUqJ+rGZQ5YXVpi4mSOa6vEhm/LSiwGIinzj7jRIOGjfxoe0Z2+inPHW?=
 =?us-ascii?Q?RZWqdSpNy28zom9tNg7Kx07C6hC3wSWmGj6m1woJjfLod+8JN1+usptW1gR9?=
 =?us-ascii?Q?EryZ91Ws/RGT8T6MizzNjFY/aoceJUEEUjvLsYn4FMM0tOVOgPSXyu3IOSsI?=
 =?us-ascii?Q?41eZ6SO/ykNtCgA1O0pZr9t3nmFsz4LjJc2L1tNmN9o0RtNr1lPPrldznmxg?=
 =?us-ascii?Q?fD4T5dkqoXHeTBe/helbjGqYm6m/cXUeDCW6xubgTmDHuXr3kI1cgZjd3FTH?=
 =?us-ascii?Q?9wya24+MBZEL+XNAJ46QzXFpLhspCnibBTzvJQtehATeeTCIv3R4XHdEgw0y?=
 =?us-ascii?Q?MqNYbJm2Jdqgu/TvawOJY2dwrBl7+/UsBr/K1JU1OlHBLSBmZRVz6cy+/qTC?=
 =?us-ascii?Q?4DCHohGR0XKoThEO2SRpQHyUDk8+HRacRhLRAp/AvIkJqI/2/vTJ02H9bcH/?=
 =?us-ascii?Q?hLw8wbl9AzYGnsMYxRA=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 54e9620f-7eff-4c0d-1f4e-08db37444b0e
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Apr 2023 08:44:25.9490
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UslS8tFSAeCaxsndtcukrNMXk1VYnZswwgmoTowVVvUNG5aNs8QjEkmSYNF8OckIOJxAO9JMAXoOn2ELcLPjGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7914
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Thursday, April 6, 2023 12:58 AM
>=20
> On Wed, 5 Apr 2023 14:00:00 +0000
> "Liu, Yi L" <yi.l.liu@intel.com> wrote:
>=20
> > Hi Eric,
> >
> > > From: Eric Auger <eric.auger@redhat.com>
> > > Sent: Wednesday, April 5, 2023 9:46 PM
> > >
> > > Hi Yi,
> > >
> > > On 4/1/23 17:18, Yi Liu wrote:
> > > > This gives notes for userspace applications on device cdev usage.
> > > >
> > > > Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> > > > Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> > > > ---
> > > >  Documentation/driver-api/vfio.rst | 132 ++++++++++++++++++++++++++=
++++
> > > >  1 file changed, 132 insertions(+)
> > > >
> > > > diff --git a/Documentation/driver-api/vfio.rst b/Documentation/driv=
er-
> api/vfio.rst
> > > > index 363e12c90b87..4f21be7bda8a 100644
> > > > --- a/Documentation/driver-api/vfio.rst
> > > > +++ b/Documentation/driver-api/vfio.rst
> > > > @@ -239,6 +239,130 @@ group and can access them as follows::
> > > >  	/* Gratuitous device reset and go... */
> > > >  	ioctl(device, VFIO_DEVICE_RESET);
> > > >
> > > > +IOMMUFD and vfio_iommu_type1
> > > > +----------------------------
> > > > +
> > > > +IOMMUFD is the new user API to manage I/O page tables from userspa=
ce.
> > > > +It intends to be the portal of delivering advanced userspace DMA
> > > > +features (nested translation [5], PASID [6], etc.) while also prov=
iding
> > > > +a backwards compatibility interface for existing VFIO_TYPE1v2_IOMM=
U use
> > > > +cases.  Eventually the vfio_iommu_type1 driver, as well as the leg=
acy
> > > > +vfio container and group model is intended to be deprecated.
> > > > +
> > > > +The IOMMUFD backwards compatibility interface can be enabled two w=
ays.
> > > > +In the first method, the kernel can be configured with
> > > > +CONFIG_IOMMUFD_VFIO_CONTAINER, in which case the IOMMUFD subsystem
> > > > +transparently provides the entire infrastructure for the VFIO
> > > > +container and IOMMU backend interfaces.  The compatibility mode ca=
n
> > > > +also be accessed if the VFIO container interface, ie. /dev/vfio/vf=
io is
> > > > +simply symlink'd to /dev/iommu.  Note that at the time of writing,=
 the
> > > > +compatibility mode is not entirely feature complete relative to
> > > > +VFIO_TYPE1v2_IOMMU (ex. DMA mapping MMIO) and does not attempt to
> > > > +provide compatibility to the VFIO_SPAPR_TCE_IOMMU interface.  Ther=
efore
> > > > +it is not generally advisable at this time to switch from native V=
FIO
> > > > +implementations to the IOMMUFD compatibility interfaces.
> > > > +
> > > > +Long term, VFIO users should migrate to device access through the =
cdev
> > > > +interface described below, and native access through the IOMMUFD
> > > > +provided interfaces.
> > > > +
> > > > +VFIO Device cdev
> > > > +----------------
> > > > +
> > > > +Traditionally user acquires a device fd via VFIO_GROUP_GET_DEVICE_=
FD
> > > > +in a VFIO group.
> > > > +
> > > > +With CONFIG_VFIO_DEVICE_CDEV=3Dy the user can now acquire a device=
 fd
> > > > +by directly opening a character device /dev/vfio/devices/vfioX whe=
re
> > > > +"X" is the number allocated uniquely by VFIO for registered device=
s.
> > > > +For noiommu devices, the character device would be named with "noi=
ommu-"
> > > > +prefix. e.g. /dev/vfio/devices/noiommu-vfioX.
> > > > +
> > > > +The cdev only works with IOMMUFD.  Both VFIO drivers and applicati=
ons
> > > > +must adapt to the new cdev security model which requires using
> > > > +VFIO_DEVICE_BIND_IOMMUFD to claim DMA ownership before starting to
> > > > +actually use the device.  Once BIND succeeds then a VFIO device ca=
n
> > > > +be fully accessed by the user.
> > > > +
> > > > +VFIO device cdev doesn't rely on VFIO group/container/iommu driver=
s.
> > > > +Hence those modules can be fully compiled out in an environment
> > > > +where no legacy VFIO application exists.
> > > > +
> > > > +So far SPAPR does not support IOMMUFD yet.  So it cannot support d=
evice
> > > > +cdev neither.
> > > > +
> > > > +Device cdev Example
> > > > +-------------------
> > > > +
> > > > +Assume user wants to access PCI device 0000:6a:01.0::
> > > > +
> > > > +	$ ls /sys/bus/pci/devices/0000:6a:01.0/vfio-dev/
> > > > +	vfio0
> > > > +
> > > > +This device is therefore represented as vfio0.  The user can verif=
y
> > > > +its existence::
> > > > +
> > > > +	$ ls -l /dev/vfio/devices/vfio0
> > > > +	crw------- 1 root root 511, 0 Feb 16 01:22 /dev/vfio/devices/vfio=
0
> > > > +	$ cat /sys/bus/pci/devices/0000:6a:01.0/vfio-dev/vfio0/dev
> > > you mentionned in the pci hot reset series that the BDF couldn't be u=
sed
> > > if cdev is being used. According to the above, it could, no?
> >
> > It should be the device passing case, otherwise, BDF can be used. But
> > from kernel p.o.v., it has no idea how user gets the device fd, so it n=
eeds
> > to assume user may not have BDF knowledge.
> >
> > > > +	511:0
> > > > +	$ ls -l /dev/char/511\:0
> > > > +	lrwxrwxrwx 1 root root 21 Feb 16 01:22 /dev/char/511:0 -
> > > > ../vfio/devices/vfio0
> > > > +
> > > > +Then provide the user with access to the device if unprivileged
> > > > +operation is desired::
> > > > +
> > > > +	$ chown user:user /dev/vfio/devices/vfio0
> > > > +
> > > > +Finally the user could get cdev fd by::
> > > > +
> > > > +	cdev_fd =3D open("/dev/vfio/devices/vfio0", O_RDWR);
> > > > +
> > > > +An opened cdev_fd doesn't give the user any permission of accessin=
g
> > > > +the device except binding the cdev_fd to an iommufd.  After that p=
oint
> > > > +then the device is fully accessible including attaching it to an
> > > > +IOMMUFD IOAS/HWPT to enable userspace DMA::
> > > > +
> > > > +	struct vfio_device_bind_iommufd bind =3D {
> > > > +		.argsz =3D sizeof(bind),
> > > > +		.flags =3D 0,
> > > > +	};
> > > > +	struct iommu_ioas_alloc alloc_data  =3D {
> > > > +		.size =3D sizeof(alloc_data),
> > > > +		.flags =3D 0,
> > > > +	};
> > > > +	struct vfio_device_attach_iommufd_pt attach_data =3D {
> > > > +		.argsz =3D sizeof(attach_data),
> > > > +		.flags =3D 0,
> > > > +	};
> > > > +	struct iommu_ioas_map map =3D {
> > > > +		.size =3D sizeof(map),
> > > > +		.flags =3D IOMMU_IOAS_MAP_READABLE |
> > > > +			 IOMMU_IOAS_MAP_WRITEABLE |
> > > > +			 IOMMU_IOAS_MAP_FIXED_IOVA,
> > > > +		.__reserved =3D 0,
> > > > +	};
> > > > +
> > > > +	iommufd =3D open("/dev/iommu", O_RDWR);
> > > > +
> > > > +	bind.iommufd =3D iommufd; // negative value means vfio-noiommu mo=
de
> > > > +	ioctl(cdev_fd, VFIO_DEVICE_BIND_IOMMUFD, &bind);
> > > > +
> > > > +	ioctl(iommufd, IOMMU_IOAS_ALLOC, &alloc_data);
> > > > +	attach_data.pt_id =3D alloc_data.out_ioas_id;
> > > > +	ioctl(cdev_fd, VFIO_DEVICE_ATTACH_IOMMUFD_PT, &attach_data);
> > > > +
> > > > +	/* Allocate some space and setup a DMA mapping */
> > > > +	map.user_va =3D (int64_t)mmap(0, 1024 * 1024, PROT_READ | PROT_WR=
ITE,
> > > > +				    MAP_PRIVATE | MAP_ANONYMOUS, 0, 0);
> > > > +	map.iova =3D 0; /* 1MB starting at 0x0 from device view */
> > > > +	map.length =3D 1024 * 1024;
> > > > +	map.ioas_id =3D alloc_data.out_ioas_id;;
> > > > +
> > > > +	ioctl(iommufd, IOMMU_IOAS_MAP, &map);
> > > > +
> > > > +	/* Other device operations as stated in "VFIO Usage Example" */
> > > dev_id is not mentioned anywhere whereas it is used in the reset get
> > > info. Worth to be mentioned?
> >
> > a good point. but it is just for PCI devices, not sure if it is good to
> > mention it here. or the kdoc in the HOT_RESET_INFO ioctl is already
> > enough. Alex, how about your taste?.
>=20
> dev-id is just for PCI devices??  Maybe it's only a vfio-pci ioctl
> that's requiring it for input, but it's not a bus specific feature.
> There should be a description of how an iommufd property of the device
> maps to this subsystem.  Thanks,

oh, yes, dev-id is generic. I was hesitated to talk about the dev-id usage
in HOT_RESET_INFO. Anyway, it seems like we are going to drop the change to
HOT_RESET_INFO. Is it still necessary to add some description for dev-id or
the description in BIND_IOMMUFD is enough?

 * @out_devid:   the device id generated by this bind. This field is valid
 *              as long as the input @iommufd is valid. Otherwise, it is
 *              meaningless. devid is a handle for this device and can be
 *              used in IOMMUFD commands.

Regards,
Yi Liu
