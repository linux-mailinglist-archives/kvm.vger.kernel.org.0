Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B44346A59ED
	for <lists+kvm@lfdr.de>; Tue, 28 Feb 2023 14:23:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229471AbjB1NW7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Feb 2023 08:22:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230381AbjB1NW4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Feb 2023 08:22:56 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 309D826B3;
        Tue, 28 Feb 2023 05:22:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677590575; x=1709126575;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=DwF8YI9c1xA2TUw+85yuPodfDM9Qm6FIEz4rAiQQZ08=;
  b=jMR8/VrkV9uQuOaVJgZSX7rxwgo3aSgiCdV3aID16yN96pSPD5EI4Kw1
   yINxhsC+sFs2y9wX2VS2s4FX3UHgxEHcTiJwCIGfDbNSKu+dQP4ZFJ6sB
   CAemSxnMTRmNLKJqNXTm5mNGIdocK1vhfDNYnvaBir3e31tOrGNj0zs+5
   CaPczyy1AKl0Of1IOWylGQW16zVj23inMW0/C0m/4fD1Rn5YYSh+5zNW5
   rWYJDhL3g5dY5/TGXpgN/5Abq7QRQIlUFjwZwe06aG5P4FDu0+tRjzaIz
   s9gRPZwiHS0IxKfMD9tEf7xlWhTsgx2LwHG2mDehG/Lf7szlL57EUmwAX
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10634"; a="332859074"
X-IronPort-AV: E=Sophos;i="5.98,221,1673942400"; 
   d="scan'208";a="332859074"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2023 05:22:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10634"; a="704420423"
X-IronPort-AV: E=Sophos;i="5.98,221,1673942400"; 
   d="scan'208";a="704420423"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga008.jf.intel.com with ESMTP; 28 Feb 2023 05:22:53 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 28 Feb 2023 05:22:53 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 28 Feb 2023 05:22:52 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Tue, 28 Feb 2023 05:22:52 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.47) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 28 Feb 2023 05:22:52 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VMTz7dnVHpcVkqEjA64Nkob75/P3EqrlVa/gFLQMgKHOoHHOv3CZ0URZFNZYntQ33J0zx6l41NMAPDdTwZ3uwQg+//M4H605S3sRWdCoXQlJvTIrJuYCq4qvyah6ERl+6PhAQZQ+/F7P2+7h0jpbgfdGwN2EBYYOuoxKUpY1gGVqKaozOP00ZkiP0IBWrzrWzU8diyIlfw2ELFc+ylRYy331t6srXLen9N4hnbgarcb+8Qb21giHpWaLV0qt9iCdA2rgiOiGCgHiEkGOVyi3Zn7x/QJ1CH7XyO5Om+yTjH1KUd8FDwrNGKk59MX3P1KAom05J79sxTGrQtE7yf0yPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IjUtRgqxcQVAUl6zb4i7Ftbk+SszjdH951DyVaXgUuY=;
 b=mFB7Zgh9HPgxt4Mf8PqPM2/iphoRMUy9vMwu9KmZi1bedNsYVhjMaN3nrCd2J2HyNcgbLwU3H6npd8wY1EgRgS/My7tJLyHShUBzQUFka5rcb7UoZFssS/A8vl1pcm4UkJKqbkOmoXK6+qfkdQRea6CtBykAOdjlLcetQk4OT933KDLygXErxMhO57KLeGblS/WXQ1cIwiBVXxovvZOiwml1a6hbZW0lzT9r/Ru2jHyZPp0yk5tBGJH/NkD/I9ehHp0jIKDRpCouTDWZH1lFJt9OjGbCkfOS0kJIXBwVQ+RoMkxKmEcKUJvDZ33l/sT1NtacEyGMaa1K9mNHg97ziA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by PH8PR11MB6708.namprd11.prod.outlook.com (2603:10b6:510:1c7::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.30; Tue, 28 Feb
 2023 13:22:51 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f%8]) with mapi id 15.20.6134.030; Tue, 28 Feb 2023
 13:22:51 +0000
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
Subject: RE: [PATCH v5 17/19] vfio: Add VFIO_DEVICE_AT[DE]TACH_IOMMUFD_PT
Thread-Topic: [PATCH v5 17/19] vfio: Add VFIO_DEVICE_AT[DE]TACH_IOMMUFD_PT
Thread-Index: AQHZSpxNXWm9KiWJ2Ee0gC65QSF3Ja7jIF2AgACHHYCAAKSqAIAAATZAgAAE3oCAAAG0UA==
Date:   Tue, 28 Feb 2023 13:22:50 +0000
Message-ID: <DS0PR11MB7529B6647B5F4B7691FFFBEBC3AC9@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230227111135.61728-1-yi.l.liu@intel.com>
 <20230227111135.61728-18-yi.l.liu@intel.com> <Y/z400uzn7Nk0CXe@nvidia.com>
 <DS0PR11MB75293EF02CB0F0A54A22D943C3AC9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <Y/30TEk3t7q/D0Ho@nvidia.com>
 <DS0PR11MB752931AD2B92DE9A1A574375C3AC9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <Y/35ZTi69p9cCuPn@nvidia.com>
In-Reply-To: <Y/35ZTi69p9cCuPn@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|PH8PR11MB6708:EE_
x-ms-office365-filtering-correlation-id: f2b14037-003d-4582-61b8-08db198ee45d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MuW8fH2N0Xf9siTh5ilVoqYmkWLBUT0Kz9cmYs8AOrgqSIe8ux/WVDM4cfoAKOW7XbKfnRajox75YKGjZgs5/9G20WKnFQ7NfLVnRVvb6kdTFvFetjdCvB6bDT9EpvP1ff5cLNJj49HcldFwSHSTuR9nabbI/M+0DbcoMVq3+0ArsYmerXwO42qIb7ffPR6OCv03ngGixS8VvusWfGV4qhRegTPMV8QBr/8VTMWpbcUwXzmVdUNtajQkwH4Ls2XxJibO7Re+wOkpLz/MjANKFp/4FOqVN1PvYj/gwzn58fwx4P6kkw0NFUGK45XXzagyZ3/mKePYnGehc/n2HN7+3tt9fqADUPi0o1539xad385r6dPUVPo57/9Z5n29cuQTbKGqc6IOcCd2w8vEN2Gee8Xtkqq7yJmNuAy/EMDkdHSwoWuoXUtN8/TF9/McBXDE+r76YqtszuIb7u+3rQmjgjdPO8FKkwmug0+EzWEx7Muxe0QAS2sDYXUIyugg6KHi/PThqa9bM+qHLhNhYzx3TqPnEa3VcVWbmIDdUdqZEduty00noDv0eLPDKObXdIJ2en6j2i+ekcDQnfK9gE+djL13OEHMjDq9D2YmzDlc5azP33KUuBiV452C9VcGJt8TKSd8rNJAjwRTte2E96o82KIksRuCb9320HMtSZ/bYMm76fiYGlftxx/x6HNED8GibI4cUTuqbxLDT6xEfYYazA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(39860400002)(396003)(346002)(136003)(366004)(451199018)(82960400001)(38070700005)(38100700002)(122000001)(54906003)(33656002)(55016003)(7696005)(2906002)(9686003)(6506007)(478600001)(186003)(26005)(71200400001)(5660300002)(52536014)(316002)(86362001)(8936002)(7416002)(41300700001)(4326008)(6916009)(8676002)(66446008)(66476007)(66556008)(76116006)(64756008)(66946007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?UMOgT68GnCg3m77DzaDsX5XksVTOBeKrSlBtN1LsyqyGYSITNj0u4iJPfbd4?=
 =?us-ascii?Q?0QLQOmS0NSmaDgu7omSVIrcd2VXjBj8lExsarNBGTPgTkfbnDVgMnvbckNHL?=
 =?us-ascii?Q?ccqCEbny999Er4WMXf7vbrRF/sIW+2qqaAZpuTNZL/G1I7r5V7IKKpONJn2D?=
 =?us-ascii?Q?HReCcymY3pNx/RQ+i36wuRt0EAnOLlXzuRwBOM36lkL5ZElF3yvke8FGujlI?=
 =?us-ascii?Q?3n1cYCr6ZN4w2Gm4kFlcV5GNoMxnHtel08iDoAjY8n9+MxnQ1FwLeBnLK1vb?=
 =?us-ascii?Q?j6+GWsASAr7MrT+rOcZ9S2v2TBdwHkGlgl5wxZIv6Fl5cDaA9qDNQsBP5wbt?=
 =?us-ascii?Q?wbB7LnSbws3j1eto6cpeTb+1aNre0Sbj/W+p3FcEe735etlWli3k8GS7vWDw?=
 =?us-ascii?Q?z2XHsI9fmd9XKFmCBfNwz9hOGGwSEMO9ut99tIPgz0RKwqo5fZ4vJO1YVfnb?=
 =?us-ascii?Q?bn/Pw1p+gXxna0TB2fPq2vYmbrq1V3YLpyQezqOzXn89r7BnlBtbH9h9b8In?=
 =?us-ascii?Q?KM2eHsAZYHKRu14Lq+UvQsl/q5o3AUoShDAOyH8YOhitltPezteUL2ytWHfp?=
 =?us-ascii?Q?26XoPuC/gK8JjBnGb/H34u4y3L/ZtPXxLhGMEVpc551yDHfWQPzckxdzai9Q?=
 =?us-ascii?Q?GeA40/xh6ukDLSk2NgvJD/VHJbkxnEXrFd9KIueA9ViEBMf6MFGenBswgi/H?=
 =?us-ascii?Q?+0wvtGeyBXqB9J3m5ZocRQZE+oj0I/FjMZ+KHV6mIsmv+pgxUfvqRD8g+Omj?=
 =?us-ascii?Q?VUaFC6FvO1JdGu2iwBzWH3lcAcbzdpFA7rhjzSbPGXbfJED6pnYRRS/FbsDW?=
 =?us-ascii?Q?lkaox/WxaBw3/O4ezQdvO2VLFYnGAXPxGQ0pOQwKlzEdRKgwkw6OGGgYd5l0?=
 =?us-ascii?Q?ehxcPezH97Ef/RQEmj9g2sKGKWpqtE3WumhJyPyV5qAozWwXKrvFqds7S6JQ?=
 =?us-ascii?Q?QP/F+yzm39vS3AXQesT8AnwD878A7QPB4DzitrpTWwxEgKMJ7cwpSVapiwzg?=
 =?us-ascii?Q?oRU47ctrC9gZlXpT6LdhhiJd7PSC41r1J/LvQGDpqEEQpqmj4f0zU04OS6Oo?=
 =?us-ascii?Q?YVXsEGnkNFCBYaT9Yml+2tcMzw1jPVtyqlF25v7LfH8CzuIkjFHU1hBGjeMc?=
 =?us-ascii?Q?DSbOD4O2d5Yz8o17vMYq1paJokBKOIEp/ZZqOT5J7IKOZM7naTqEUovnDhJ7?=
 =?us-ascii?Q?kbhUngHHGNpe1FxHjsiUoXYJ62irYBcrTf3s05pCE8eN0hBcMRWIshSPdK5k?=
 =?us-ascii?Q?bnn3fdB9qzTOthrm/V4QHXnl2QX6IlW08DJ4HgRPMSAfk6uaqbVCvdGPYsB4?=
 =?us-ascii?Q?ViL2wtrAmK/LU5TjFOdW8f0JDTUtdiHgpeuOM9StRH3uPoOlNfF0pW9BztWZ?=
 =?us-ascii?Q?YIO6fQBJEtEnoAU7umSAV4lKglZo84URgKPCqfiwNVh8Du9mF+eqRJ76VBed?=
 =?us-ascii?Q?iry+/ZhAVdAtvNxUOCe59IFsJS+njr9F2c6+HHyzSKnuQIMcwCGcWkEHBY9m?=
 =?us-ascii?Q?xGgQCHkX+at0MUYLU2J2yMS2/tkUxc7IyYx0anRFyBi7hDjeHbFQxtLcgkwl?=
 =?us-ascii?Q?b3mLZXMgCkvNE6Br11xIh/Kx81lm27RqFQWyDyNn?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2b14037-003d-4582-61b8-08db198ee45d
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Feb 2023 13:22:51.0120
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zPMlD3Acrofxdyb8JGnFicwKmNcRHrgZ+IrvbD1H+4owDsrU0P/x+Pze+t40TxvougbS8VnB16yP3EEhp/KEMg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6708
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
> Sent: Tuesday, February 28, 2023 8:54 PM
>=20
> On Tue, Feb 28, 2023 at 12:42:31PM +0000, Liu, Yi L wrote:
> > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > Sent: Tuesday, February 28, 2023 8:32 PM
> > >
> > > On Tue, Feb 28, 2023 at 02:51:28AM +0000, Liu, Yi L wrote:
> > > > > This seems strange. no iommu mode should have a NULL dev-
> > > >iommufctx.
> > > > > Why do we have a df->noiommu at all?
> > > >
> > > > This is due to the vfio_device_first_open(). Detail as below commen=
t
> (part
> > > of
> > > > patch 0016).
> > > >
> > > > +	/*
> > > > +	 * For group/container path, iommufd pointer is NULL when comes
> > > > +	 * into this helper. Its noiommu support is handled by
> > > > +	 * vfio_device_group_use_iommu()
> > > > +	 *
> > > > +	 * For iommufd compat mode, iommufd pointer here is a valid value=
.
> > > > +	 * Its noiommu support is in vfio_iommufd_bind().
> > > > +	 *
> > > > +	 * For device cdev path, iommufd pointer here is a valid value fo=
r
> > > > +	 * normal cases, but it is NULL if it's noiommu. Check df->noiomm=
u
> > > > +	 * to differentiate cdev noiommu from the group/container path
> > > which
> > > > +	 * also passes NULL iommufd pointer in. If set then do nothing.
> > > > +	 */
> > >
> > > If the group is in iommufd mode then it should set this pointer too.
> >
> > Yes, but the key point is that both the group in legacy mode and the
> > cdev path sets iommufd=3D=3DNULL. And the handling for the two should
> > be different. So needs this extra info to differentiate them in
> > vfio_device_first_open().
>=20
> Don't encode that in the iommufd pointer, it is confusing.

Maybe I failed to make it clear. As the below code, When
iommufd=3D=3D!NULL, no need to differentiate whether it is
the group compat mode or the cdev path. But if iommufd=3D=3DNULL,
it may be the legacy group code or the cdev noiommu mode. So
df->noiommu is added. But I agree this noiommu flag is confusing.
May use the df->is_cdev_device flag as the purpose here is to
differentiate cdev path and group path.

	if (iommufd)
		ret =3D vfio_iommufd_bind(device, iommufd, dev_id);
	else if (!df->noiommu)
		ret =3D vfio_device_group_use_iommu(device);
	if (ret)
		goto err_module_put;


> A null iommufd pointer and a bound df flag is sufficient to see that
> it is compat mode.

Hope df->is_cdev_device suits your expectation.:-) The code will look
like below:

	if (iommufd) {
		ret =3D vfio_iommufd_bind(device, iommufd, dev_id);

		if (!ret && !df->is_cdev_device) {
			ret =3D vfio_iommufd_attach_compat(device); // new helper as in patch 10=
 discussed
			if (ret)
				vfio_iommufd_unbind(device);
		}
	} else if (!df->is_cdev_device) {
		ret =3D vfio_device_group_use_iommu(device);
	}
	if (ret)
		goto err_module_put;

Regards,
Yi Liu

