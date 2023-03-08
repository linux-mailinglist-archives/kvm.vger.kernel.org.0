Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C37B36B0027
	for <lists+kvm@lfdr.de>; Wed,  8 Mar 2023 08:47:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229708AbjCHHrj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Mar 2023 02:47:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229659AbjCHHrf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Mar 2023 02:47:35 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 191A49AA09;
        Tue,  7 Mar 2023 23:47:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678261652; x=1709797652;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=JgTYyfUY8yh6RNZJEyReN2Emc7y+DY0O8SGtY0jabGY=;
  b=lwxvXtggy/tvY+uKtCgJ80mqUUB41UWdtFDKNW3l6e4Drvfd1OIgj417
   13qgOIniTkkMU2+5mqFDPUNvKzz+1csRSzz+qX0eS0NpaCmAB1jbvwirq
   oCwKJ5oveSjPuXJqexo8vGDVbg3Ti7cdU8flnfh2qCW5pdbUj5zX+Wp5E
   xGY9tKw1lTs92TOZxPhOcEYep4RUY5svS4FDkrDYvXeqP4mMMpIk4sjfR
   k1ahszwmqigVy59W/tIVecypDYIvfjUtKV5AnpfZW1YotYaaq5Yai1Fbn
   WDrS/i9qsqYscHZ4Se1Mg8/P0kz/F8gpJNHx/+A/nfV459/LIEUHu8As/
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10642"; a="333563383"
X-IronPort-AV: E=Sophos;i="5.98,243,1673942400"; 
   d="scan'208";a="333563383"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2023 23:47:31 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10642"; a="922683634"
X-IronPort-AV: E=Sophos;i="5.98,243,1673942400"; 
   d="scan'208";a="922683634"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga006.fm.intel.com with ESMTP; 07 Mar 2023 23:47:31 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 7 Mar 2023 23:47:31 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 7 Mar 2023 23:47:30 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Tue, 7 Mar 2023 23:47:30 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.173)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Tue, 7 Mar 2023 23:47:30 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a5V75zeCeAStcIYv99STsuC0kLknW0Yvl2RMq2p0+J0qVaUzPo6fhHvMNWusIoLDMcvvRWPh9ig1GX3xjfYoU5HTe2OUGohIxIm9kTKY8w7XxxYgL5tjPJDHsty1bmrHA/sIuWGjqCes02yuaACVRe3yiFV5MCCrtwg8c1NtCQAuqa7HohPI5F/e93FUM8/T6J46XF3aMSVGpA6rKU1v/wsPnRQEwSQoJ4miblwsliZASQdSKQ8MHuILHMVZL5kAhJyaQz6v1wdUgPlzxUp7uQVhe5LdnidgwMkfNByozKI38QDjPKTyxNcFftfdlEEMOXQmJ2eym4Jnz0Lwh9S3gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YXg/GpKyUp5nV05RH34z0zlCqYnfPzpsfBo5/oaUBfI=;
 b=BfMkwF6c/VTZtx2MJgTiyQP6f3U2/3hN98ur8sd1Ane11uv3re5ppnrAswPppI5Lfg+UurTewg0bBtW7cK15QIwQw9CODgHET+N+5Oev9qbHB2VH4b3qUUDnSFZU+ABduYsL73LgRcV5aHxJq6LjFOIhd5/lnNAvnO8jluuq3PwNygmp5LFQALKGtvzIXxZonMiewzvN91gaonMYz4UScKg7DXjMgjp+5tAlYXDr7IHlOLP6k4ivzUkfI0aubjRnHJUu2Rdtmj4h5fXaURXuakSSoWpYGOqy9TLPvN4rQcajIjJ7ey+43vUixEVFY+yiEQDiWUqKdCXCb5PTTAVHJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by SJ0PR11MB4877.namprd11.prod.outlook.com (2603:10b6:a03:2d9::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.17; Wed, 8 Mar
 2023 07:47:24 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f%8]) with mapi id 15.20.6156.029; Wed, 8 Mar 2023
 07:47:23 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
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
Subject: RE: [PATCH v5 09/19] vfio/pci: Allow passing zero-length fd array in
 VFIO_DEVICE_PCI_HOT_RESET
Thread-Topic: [PATCH v5 09/19] vfio/pci: Allow passing zero-length fd array in
 VFIO_DEVICE_PCI_HOT_RESET
Thread-Index: AQHZSpxNz0d7VXviIEytrFhyB5GUvK7m/3jggABFoQCAACyCAIAAGw8ggAETHYCAAKz6AIAEeeOAgADd5oCAAKkfAIAACTyQgAEyYgCAAATW0A==
Date:   Wed, 8 Mar 2023 07:47:23 +0000
Message-ID: <DS0PR11MB75298BD3EB872C938F86C96AC3B49@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230227111135.61728-1-yi.l.liu@intel.com>
 <20230227111135.61728-10-yi.l.liu@intel.com>
 <DS0PR11MB75295B4B2578765C8B08AC7EC3B29@DS0PR11MB7529.namprd11.prod.outlook.com>
 <BN9PR11MB527688810514A262471E4BB78CB29@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZACX+Np/IY7ygqL5@nvidia.com>
 <DS0PR11MB7529531834C0A9F1D294A5CCC3B29@DS0PR11MB7529.namprd11.prod.outlook.com>
 <BN9PR11MB5276B825071A4819479079A68CB39@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20230303095542.2bfce5c2.alex.williamson@redhat.com>
 <ZAXny4NDDq42NUxE@nvidia.com>
 <BN9PR11MB52760ABC93BCE7FB53A131038CB79@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZAcvzvhkt9QhCmdi@nvidia.com>
 <DS0PR11MB7529A864CB1C149CF8B19E78C3B79@DS0PR11MB7529.namprd11.prod.outlook.com>
 <BN9PR11MB527616204417D92A1BEB5FDA8CB49@BN9PR11MB5276.namprd11.prod.outlook.com>
In-Reply-To: <BN9PR11MB527616204417D92A1BEB5FDA8CB49@BN9PR11MB5276.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|SJ0PR11MB4877:EE_
x-ms-office365-filtering-correlation-id: ccf0ba7f-3f19-488f-0a11-08db1fa95ac2
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: osARaOzJvVOu2puuEona+hkbtkzm0+MQPplJXgnMoaMklVheZ5JNvbVyiPAOvyKGU2t7cNpiu6lO221XfeS1lzPZGXjH2DabX23Qkb71JJK+5VQpnsSvuhKpCl8w5FBfXS9+JtL216qw4V6NbZmgrdXJU/+eFbIqXJr5XffqehfufuJ8OJRB5VWNzNUCA8wLOssPdusqYqHZN7St9I3f5W7mXWWYvqlUIMVpnJg63yrEQxpIqg88iFn18UppbMaqCuMADmaZ3CukMstfEcoX332cY44u3jgZ+u0ZiWenlsy4ZTJX8J/F+wJoigQBOKgGjj2VMvKipFrKCwZFyUf7QRQxkphLFu1FowzMrPgtLHdTT34yshPA7IEg1poznsgkVQkJ5pXhvGKVtG5g3bfXdxJA4+GhRdX7OUAVpz1Nug63N99qL09Va3BKH04IiPa/zLqW/Vc1dpjZVC5GQt1lG0m2c9mqL1lqRfs8vbA9VbsjUUVlpPwRLQ9Fn7d2ZTiPRJ2kQwReTpdaHroRA8N2oauvlqvpqmMMI2HJbJfyb7Iq8YQggwUwet89fvAOFog8mKr8eRP+E+C9OrdiTVi0o0mEVa4nvj6k2ono3Wz6vI22PdZ9Af5Tc2B/BRmmS/d1oiPed9cdmunowqo98aodZ+pY7mAKsqaB9fYmEfvZOupj/UHbK44lOZeM4n3F0aWqF0ZU4A8/Fn5dRe8UW3Xm/g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(366004)(376002)(39860400002)(136003)(346002)(451199018)(52536014)(8936002)(7416002)(5660300002)(26005)(6506007)(9686003)(38100700002)(82960400001)(122000001)(83380400001)(186003)(55016003)(54906003)(86362001)(316002)(41300700001)(110136005)(66476007)(66946007)(8676002)(76116006)(66556008)(33656002)(66446008)(64756008)(4326008)(71200400001)(7696005)(478600001)(38070700005)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?1gXv/E+Jz0vfs/fACHqtAMmaG8/kC61uRm8Of2q4evqVEXqVX9V5nmNnLVqF?=
 =?us-ascii?Q?tJCGtdNc+SOOVobAuJIg6/3XM89mgnBsQYbJAelDqCx9J3IPt1rEDdhQZ14/?=
 =?us-ascii?Q?KZ6TaE9G6AT5X7taxvIyl9S7CtChPFqw7AkjiOBSD5j+kCwA6/Ygp9OjUt10?=
 =?us-ascii?Q?vmrwZO7lXDTd26AnEKY6IZLOixOYhMUsHEwjwO3ZMs7eIhm1xHJ9JhMbHTDl?=
 =?us-ascii?Q?JHYmbQSAQ7dd2YWw3WWNxVExTt0r5nXwl0tG0AA5jOlx5CPmmu7fMCNkjKVc?=
 =?us-ascii?Q?1Eb6HgIjF0dBvjiUs9Ddl+RpfO3CCTsqizO8BD4VbpwM/F1oxVX8BSPKp3Vl?=
 =?us-ascii?Q?MwTwhwirH9gUDdgBQcyhfrDUEGwp6p8k2RZ/8Bu9XEeBHARr/eoGE9xEu5h0?=
 =?us-ascii?Q?5O+BGUMpCooGzvsy3wDUQW0yiE45FlWzLYhRU8vosVL7cSyCSRPVtGzaJ7v1?=
 =?us-ascii?Q?E0bQrByRFNrrMzJPAt9wgboN0QKSjVoQXi4GaFaJppffecklhy8Z2N9eJQNb?=
 =?us-ascii?Q?dWucy26wo1HrPLEulvtdx7R+VsxOOWVxvJGwvw/3He3c9Ui1saUz+VcNAIUt?=
 =?us-ascii?Q?mx/6JGZMGJQThEGw97ipTjYm+E+0cIsBKjdjlMEiOgt57CsK2xIgHMFTDYJf?=
 =?us-ascii?Q?1mTi9vrLkhSoBK1Qy36QpNaWjHH8lAwCobePZoIS8iCz+uRcJPqKjdExqFHS?=
 =?us-ascii?Q?icutzzerd1liYBuD5kJZ03r9dAbyGKM0e3yITAVqlRIrWJxsyxL2u0GrNlvi?=
 =?us-ascii?Q?Bus2osUZzVR2raDEVTWAt1B8P1gyR7makxozW7bvKjRaB+pDkeNW3XQlprTt?=
 =?us-ascii?Q?DQNK86HGMXu2n0TsXA3qyCHVG1SrSXYVctI6WZYdJBsPsLT+O4xh/JJuLJjM?=
 =?us-ascii?Q?coLlfGrwHGp5i827Z4ddOCX3gP4IYcQMugzkCE4ErJWar0GaUzXQnlz0mowh?=
 =?us-ascii?Q?50eZyMoygO8D97MgQMc5Ca1K+XLlJTEHIC5gNviJ8LyuFmpqu3Av7fMOunge?=
 =?us-ascii?Q?Xjrvwu4hVYJIdKLSBoi2oZ+QHOZokJCxahXKQNZ0mwFYLhdd6gke6XZdtOeq?=
 =?us-ascii?Q?2SLK/bavw5n/PR680qZudSoMR3OBUQx/gVRAC00WHskXZPxdTLgX6m6yxOKg?=
 =?us-ascii?Q?qK6cZnyon6JGmuvSXIl0pQUtjZdDIE2k1ofT/dQ7sUl+6ev9iqgLRSSx+Kg6?=
 =?us-ascii?Q?swLY2ocGUuejSdtzraAFPPiAzLiVU2MeJ1tX6V3/q6OltUrPyAodAAmw+O8t?=
 =?us-ascii?Q?aestpav6mkAVN+2uDeSTRTUr83DOHx70eUV7EupyRfYuhpHwf38NOj7nqSEL?=
 =?us-ascii?Q?RsPzcoRVtA1G2AfASwZvfo4Bc2kcIN5HhhUsi8c5FBBcM6mt5LtuuW7l2K60?=
 =?us-ascii?Q?/nqdy/T2yISl2LGfmFkO3QHcXyvFMXImK6/x81ASfTiXDMTW+RqzEAsuJI10?=
 =?us-ascii?Q?Fy3daueD+6lQPIajpJJN1SGqJTLJuWeVqHf6x7mIgphvVmY+8vUh6FMjKKab?=
 =?us-ascii?Q?qaasuoAX548hs9Gcep0enZCG3C1io1+PF1qSQm2GhN6YaLm4DJ/Y037TOlf8?=
 =?us-ascii?Q?KYAPPxg5Oo326CQuAtqBngCCJSp8l7vKaQKZFvIs?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ccf0ba7f-3f19-488f-0a11-08db1fa95ac2
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Mar 2023 07:47:23.5345
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VUvzox9ubnWpczekSbKHJvNXQeD+OnX5vur4kf+7coh+RfJGzx/raC1pckE8uabVW8U22vuUts+qQFU6p1l65g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4877
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Tian, Kevin <kevin.tian@intel.com>
> Sent: Wednesday, March 8, 2023 3:26 PM
>=20
> > From: Liu, Yi L <yi.l.liu@intel.com>
> > Sent: Tuesday, March 7, 2023 9:29 PM
> >
> > >
> > > I really prefer the 'use the iommufd option' still exist, it is so
> > > much cleaner and easier for the actual users of this API. We've lost
> > > the point by worrying about no iommu.
> >
> > Hmmm, so you are suggesting to have both the device fd approach
> > and the zero-length array approach, let user to select the best way
> > based on their wisdom. Is it? how about something like below in the
> > uapi header.
> >
> > /**
> >  * VFIO_DEVICE_PCI_HOT_RESET - _IOW(VFIO_TYPE, VFIO_BASE + 13,
> >  *                                  struct vfio_pci_hot_reset)
> >  *
> >  * Userspace requests hot reset for the devices it uses.  Due to the
> >  * underlying topology, multiple devices may be affected in the reset.
> >  * The affected devices may have been opened by the user or by other
> >  * users or not opened yet.  Only when all the affected devices are
> >  * either opened by the current user or not opened by any user, should
> >  * the reset request be allowed.  Otherwise, this request is expected
> >  * to return error. group_fds array can accept either group fds or
> >  * device fds.  Users using iommufd (valid fd), could also passing a
> >  * zero-length group_fds array to indicate using the bound iommufd_ctx
> >  * for ownership check to the affected devices that are opened.
> >  *
> >  * Return: 0 on success, -errno on failure.
> >  */
> > struct vfio_pci_hot_reset {
> >         __u32   argsz;
> >         __u32   flags;
> >         __u32   count;
> >         __s32   group_fds[];
> > };
> >
>=20
>  * Userspace requests hot reset for the devices it uses.  Due to the
>  * underlying topology, multiple devices can be affected in the reset
>  * while some might be opened by another user. To avoid interference
>  * the calling user must ensure all affected devices, if opened, are
>  * owned by itself.
>  *
>  * The ownership can be proved in three ways:
>  *   - An array of group fds
>  *   - An array of device fds
>  *   - A zero-length array
>  *
Thanks.
>  * In the last case all affected devices which are opened by this user mu=
st
>  * have been bound to a same iommufd_ctx.

I think we only allow it when this iommufd_ctx is valid. Is it? To
user, it means device should be bound to a positive iommufd.

> and with this change let's rename 'group_fds'  to 'fds'

Sure. It would be something like below:

struct vfio_pci_hot_reset {
	__u32   argsz;
	__u32   flags;
	_u32   count;
	union {
		__s32   group_fds[0];
		__s32   fds[0];
	};
};

Regards,
Yi Liu
