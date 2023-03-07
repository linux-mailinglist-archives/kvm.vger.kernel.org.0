Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 948AA6AD781
	for <lists+kvm@lfdr.de>; Tue,  7 Mar 2023 07:39:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230232AbjCGGjX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Mar 2023 01:39:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229872AbjCGGjV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Mar 2023 01:39:21 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F22995B5D5;
        Mon,  6 Mar 2023 22:39:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678171152; x=1709707152;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=WCUBKeBHvNn6dUJ2K0VCWFiJm42SfqUZ4OqWlv2sxP0=;
  b=jy+e31shRIKpYUoRkQCSZJOyt4foWupzGNx72U2u2k3R/1N6RakLfqcM
   3R0aUuHmHCeqG/hEQUpCVMYIKBTJBJ8QBRackLKeqQtu+A1nxsPdnGB1y
   VbGJrNGJxhapTukQ2Vpv+oJNqr6QXLtlkAHYS1owWaRa5i0P4bQYBFR+L
   EAnkKB076/bHostLmHWL5zXqX+mgdu7dNxfEfS+wNiyq8RkP/iNldjuGu
   CvhuGmf1P3BhwBi4R/7KA5CyBF6VXs/LjpLeccxGzeoabnnPKnS5QVw51
   YuYIFAWS99de9D5nwKfwf1MfTO11xNOqN9DBFiqv8mjOx8j8QPHZN2Cz1
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10641"; a="400595641"
X-IronPort-AV: E=Sophos;i="5.98,240,1673942400"; 
   d="scan'208";a="400595641"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2023 22:39:02 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10641"; a="706699570"
X-IronPort-AV: E=Sophos;i="5.98,240,1673942400"; 
   d="scan'208";a="706699570"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga008.jf.intel.com with ESMTP; 06 Mar 2023 22:39:02 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 6 Mar 2023 22:39:01 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 6 Mar 2023 22:39:01 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Mon, 6 Mar 2023 22:39:01 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.171)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Mon, 6 Mar 2023 22:39:01 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Sgry/twck6hu1BaWmldvhssrv7Ve4UvGOl5J7fz/BqQjB1xQ66ylkm6wrfPr2fc0dx5SvAoZXdapTfNj4TGOmNveGQR+t7PAzhrpvOVgTKyGgbQNS+ZfpO1+ttpCiDSeFT2FkDDEBnKDJf7mA6s7OQix/Vbw/24rr9oIB4Cr5zkNm8pzRw2g7hQqI42tmc0NDYXxb6jpZanBwC3d11oNMcq6ScrjHwyk5+3GNJBfK6bUX4od8lMypCrhnRP6ZGZWBDxBkswaH/o3DT6gDt6hOkqNp3EfgeD8vdY/F4qEsLPKy9plfJz2Dc59U5h6UH/QXD2gf88hSc1hGOXm0o8yHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=swbA77Wfm5XGWBiqhEt7FhYAIWAEY9UAwFxHFbLWHC0=;
 b=Z3sEHJtl/maHUH+Xxk+S9zX/amCfyFxzrsau8F3V2ASBtu9oK2hZE18Uh/EMUkC73D4/1orK1VGRsh8O7ulnUUtYz4YpBfndggHd1c0Hf3nBXOhiMoQGkCHIePNMsQKC9zVWIlY4LBUByfH2H0xzpMlDRj0+wOv8MNx283RNQrLNS2U11r+GlTxvUPOw5Ub3dD5mBOMNd9NwMYzdj02I9OCRsrxMz8RcqAMJuz8zT1Zotg1ejBlATOMYo3Y+hGFZNoIbeMYOjbpMc9EcDZC2fgCFSh2d4HtvR9fWItzzZBayulqsyofwQttDQcd6QKpEvvFpt3oVD8skKQcu6O46qw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SJ0PR11MB5054.namprd11.prod.outlook.com (2603:10b6:a03:2d3::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.29; Tue, 7 Mar
 2023 06:38:59 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1aac:b695:f7c5:bcac]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1aac:b695:f7c5:bcac%9]) with mapi id 15.20.6156.028; Tue, 7 Mar 2023
 06:38:59 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>, Jason Gunthorpe <jgg@nvidia.com>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
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
Subject: RE: [PATCH v5 16/19] vfio: Add VFIO_DEVICE_BIND_IOMMUFD
Thread-Topic: [PATCH v5 16/19] vfio: Add VFIO_DEVICE_BIND_IOMMUFD
Thread-Index: AQHZSpxPC+MDBUMQo0WSWqpmOLb9+K7lqIaAgACN44CAAm82AIAGQfhg
Date:   Tue, 7 Mar 2023 06:38:59 +0000
Message-ID: <BN9PR11MB52760241BBD8D6D670BD17D98CB79@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230227111135.61728-1-yi.l.liu@intel.com>
 <20230227111135.61728-17-yi.l.liu@intel.com>
 <DS0PR11MB752959193D5CBA2A677B1F18C3AD9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <Y/+Pkbtr8KQmUjVp@nvidia.com>
 <DS0PR11MB7529E16DC2B558E8476D835FC3B39@DS0PR11MB7529.namprd11.prod.outlook.com>
In-Reply-To: <DS0PR11MB7529E16DC2B558E8476D835FC3B39@DS0PR11MB7529.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SJ0PR11MB5054:EE_
x-ms-office365-filtering-correlation-id: 458ca5e4-fb62-4989-9ed9-08db1ed6a1f8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XKjfB9eeIODvr1c3d8ICCpcLh67MAy5HyHDvJEv7JfvqtxBKpYvnnk/ug7weJGgyCmycbSJJPLrn6FbckpF1kvwCs2oftzmZM1Y0xU1ueknS1c75rfdjT3CsdoNr9igEiSd7Pq/sItaNpA5gmp5sO4fwD6vnOyP/LcclLas+N+a/JVK/uiNNpCtWkR/jYC06x7Y3EBsmPtnMSG4YA5vyQrM53nvRMEw8qwQgCa5t95SBfrkKd3fB4AZj1LIidoXZ3mDBIimTVTgm3xAF4EAhfVUO7g3XEyrh/w9DVeiF3sbkE745ViQGi/MwiYZP9zP9K23GnAuncPiTNXcPwNODFa7ejqxjYMCArpK9XCLagrf7cx+XhEkbJfFdXop1A/j46OqQ+ElUQ0O0y1VuZVokqR6rG1GmIwcPMrSZ1WnddbqvymvX4yu1oiDz/nCUitdvHIpYXL9bc22CNtkvJ79rFlVw/OBn8d2pFg3kNgyQklwZTjKhOfx3EPK0J2mmTYAHxLHSUd101fYSk1d1cxH23t+trijuxpVxzJeXoqVzNcKAo4gMbxR7X3rk6Si8NEp2lrACZL15DJoMvIf6LyDjGW6ASgxiSS0t0wCuF1qNZ8MkQ71SvvjRy0b7W3OuwU4Xqt12EsveBwSmnccHb2uZjmgHQ8XsAYr0u+kGWV9stOT+Se652+RODnBHQkRfnW8vitCekiuvO4XJ+c1WHZmInQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(366004)(376002)(136003)(39860400002)(396003)(451199018)(5660300002)(186003)(9686003)(26005)(7416002)(4744005)(64756008)(71200400001)(66446008)(66476007)(66556008)(66946007)(8676002)(4326008)(76116006)(7696005)(478600001)(33656002)(54906003)(86362001)(110136005)(316002)(38070700005)(55016003)(6506007)(8936002)(41300700001)(122000001)(52536014)(38100700002)(82960400001)(83380400001)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?n+WX28+xLWpxbtQhGf4HXJQ1vbRj9cNjFu6iKlccBg4UeJ9JgRfXBvPWTxKn?=
 =?us-ascii?Q?PhxOgrfXg72hqy7HSet2GczDlrVpnDNhIPHRSN7RyzrHDTiBYeNr7VLXCkPQ?=
 =?us-ascii?Q?5Llb7Ckz+ecDuF6ZJdJPgQEdtTEgVd499EMZSQD1D4V+qoUqfT1uV4fufPI0?=
 =?us-ascii?Q?fztZP57FD8n2vzSKIHW428qHFSJ5O5bmR26ZT4SIOKltuGKjzGBk9tcKQeJr?=
 =?us-ascii?Q?Gdoc1/quUJ28v3PGUP2k310vpKlnarR578tzTfhxSLdcrjIn5bJF875xUHdu?=
 =?us-ascii?Q?+/GBCzuZgVBFelMRuz/aZ9JrlkmbI12XRVHNw/ToCTqUjayGPXjMBtbaNXuy?=
 =?us-ascii?Q?8h82uu8qnWZO2wBV7xWUUz6P09CBq7l0LRupLwPFdaA9H7sRcealeR9Obado?=
 =?us-ascii?Q?+ecNi+DugypUMHg3zS2X9agfveHh5r7ntM1JYjoxiMEd/szJhJZqdBaLCs93?=
 =?us-ascii?Q?QEIz5McE+ksPtdlRbdnkrt/UFoJ6HADP2guNprAw1BdZF5IMvAsCnSrJfQh9?=
 =?us-ascii?Q?F08LCrahxWx5ZybOWPG7pWJgMZ4N8TrJBe0M8l92kiCnb0z1mXKylJpbkPk6?=
 =?us-ascii?Q?AFVSO4IzSATjFNjOc9J7GrC18rVwxSuJDNPX23fC6WPEBaGQna7t6CHAFc/R?=
 =?us-ascii?Q?9K5IzXfPapQPZYeS5sXGVOlVeLRcmXXHn+rQESDA7/qJWMO9u7S5a9OCvwPm?=
 =?us-ascii?Q?UKcxraV65j4Q0RuWK7Hukn7xF2mFct5HvZvMLlCFs9SM/MJYkFytofBthBx9?=
 =?us-ascii?Q?ymGSC8H2sDVma6/mzYKo16WM0s1Cu0UX4HQdplOcEQ+56rZVhLzW76loKZrY?=
 =?us-ascii?Q?la3lQLZ1OmBIq5DevLBFonoPS62XqVxt5CaDS1puzautxueg/n7kUCFf5JqB?=
 =?us-ascii?Q?lfPdG1FnwhoMKSMfOjwKuo7ToITKnNPWx/5ItyMG7MjPOu3xyERfVgYWDDR2?=
 =?us-ascii?Q?jUwL54hEb5VTXx/9jB+wjNFHanh2/VWtsuF/u42d+jfLVWrawfpkSyeh7rix?=
 =?us-ascii?Q?cxPwGnXiH1KU3S9AOU8WM4+goDvygXN/qBH1igxfCKslezzY2XtR7NVQbFQ5?=
 =?us-ascii?Q?vh3hcInxdMrZhE0jXi6oIhqSxNRcZ+mr6N/jFEH2IpQSLQMvufTtg3oEm56G?=
 =?us-ascii?Q?XMEi1b4fAjV11UMUDcmidswpVsqtr0UzjOz7Bim5uY3ENdea3BW+p/qFjgGv?=
 =?us-ascii?Q?ewJD5B7aCJ4+BXVUQ6ZwQex+Mb2p3EckuB4osGpO8j5CIinGGxHd02i+v0kJ?=
 =?us-ascii?Q?AUBHdhHKAF2L7ZA1ZfzfjDiImCcBZHuIDhMw4VensbYM3jKiWpU3DoqWW8+g?=
 =?us-ascii?Q?cumZp+greYIaQf3bMFyYyLyFurm+pkt9iDOIDJy1ga10eT5KUJyJ6W+K+f62?=
 =?us-ascii?Q?SkKPQF3Iworhk08bwm3FjU1/U8xqcTBrPZCJzNCp8PaAzlQGrWERdWlwHcU5?=
 =?us-ascii?Q?NokeuqEPp/+qcJllCY0yGXccR5S6cwR5foPAw/AFUdvXgrIOe2MlxySpUS33?=
 =?us-ascii?Q?ZI160aymiePuBcDiHouL0h4obJp8LKqIAMbOQf+aKHA5rYcjKyFxToD8TtWm?=
 =?us-ascii?Q?3fu89HzcvEaB7Dgj+hsaBt9sTLQq5iOZW2B2XyGF?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 458ca5e4-fb62-4989-9ed9-08db1ed6a1f8
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Mar 2023 06:38:59.2005
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WPVKj55zz4HHuGYWJYXyXhISIXzo3eg7RrA0pTkfJBOhLesypz3ureUOTGSeEp11DGQPQUJTepEjeazxRUeQrA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5054
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Friday, March 3, 2023 2:58 PM
>=20
> > What should we return here anyhow if an access was created?
>=20
> iommufd_access->obj.id. should be fine. Is it?
>=20

Thinking more I'm not sure whether it's a good idea to fill the
dev_id field with an access object id and then later confuse
the user to get an -ENOENT error when trying to allocate a
hwpt with an access object id.

How can user differentiate it from the real error case where
invalid iommufd object is used?

It sounds clearer to return dev_id only when there is a true
device object being created by the bind_iommufd cmd. Then
the user can use it to decide whether  to further attempt
dev_id related cmds.
