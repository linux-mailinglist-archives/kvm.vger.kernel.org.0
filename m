Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED72451B952
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 09:40:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345545AbiEEHo0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 May 2022 03:44:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345513AbiEEHoU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 May 2022 03:44:20 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E67918E0E
        for <kvm@vger.kernel.org>; Thu,  5 May 2022 00:40:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651736442; x=1683272442;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=qPGnYjfEvNyyjLdYiAUpfXUo8vhhoic6xT4RB1MDpCk=;
  b=Kakp6ay99n/cFCUoLEPlrRgW6UN0YfT87HoWsLnSeuqzHmBHj+3+56qe
   UWA0Scj3YAfuQRBqUWZ/GScmOuC4wpKR0KNJb7ABKWfh4fF9bJu/uq2GP
   +EcMHeUDvaqY97sCVzZeZdX0pfjBCSDx8yA+XtWhpsqZfGmkYTzW+MWBd
   Z9f8dbedur7QoSYsPJ2S+EbCw89tqnMKtg3+efz2+yP0kqqvuJM6nCz0O
   8+UAvhRKDtaDpbkrFEwX5ZNB6x/rh8PZBTOu/kT7pCXQOfT30dPDrit6z
   B1SZEuTDHWKEjbnI4rUkYYIgcnhoIW+ngPa/j1GuALDPdG0ecd8dZzGkS
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10337"; a="265626488"
X-IronPort-AV: E=Sophos;i="5.91,200,1647327600"; 
   d="scan'208";a="265626488"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2022 00:40:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,200,1647327600"; 
   d="scan'208";a="549241478"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga002.jf.intel.com with ESMTP; 05 May 2022 00:40:41 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 5 May 2022 00:40:40 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 5 May 2022 00:40:40 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Thu, 5 May 2022 00:40:40 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.170)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Thu, 5 May 2022 00:40:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J9lpF4yE0NptXdQiVm9SPLM/xyYYpl0m2aZcxFDWd8gDG1LgxwCVqC14+tSuib3qMn+Sl6Lf/YEZRsXeSeZ8XCmFvTPv5yCHKkDQc7Dfi+0+bG4xbA/1Uy7LDCFEmOhzp4OWI8BtNQDSnTizieoV7kVGiwXg7bXZ7AlDiwYj7fGlRipQYqpGmJ7I+FlFXLniIdLONDZe2qJ7mzACwqLKisPnDdRasXAXPCFmYzivFS8qQkEGGZJyE0+MoFQZmPLaUweElQZdpnywXSfGNq02Uc7NvxdbPtTVooCAsoKzIdz6CF4QONgu0zTIZbGcKVICW0vVTg/GhUnuM6kxGCzlow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wlYgMjEAtXUSlssK0l0RwGQo1RQvIu6h+xlKfRcgiU8=;
 b=Lgo0vNvxbLraXYoB5eE+OuJvy+ydml6/w2e2dq2sBx1SWG7GaU6UrLFIDu1W5aiQ+eqTcv9PK8pb5MeBg3LB1b+5BI3u5+PC/LDswScxX+PE/de63qSjfkqa8VN1qdKfzi9UA3HQs+Q+dmzbmjc4+hZaSlbwCsZ9VOO1+vI9Pek8BnBO2Co+CIDu90zQ3/nsVjMsc6WUie30REYOxDzLL1giKbwUhQTmhfzowptXIgbscTKp6mcSCVl/b/MscNjt6btMCiUrHfk6dpJOJGWZ56Pu7UtpOM3DF4CtXqn/V/BSdFbfgZ8F+aGezPG1DGj+m/au3W7HdSGJunIYLSXUmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BY5PR11MB3880.namprd11.prod.outlook.com (2603:10b6:a03:184::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.13; Thu, 5 May
 2022 07:40:37 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::24dd:37c2:3778:1adb]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::24dd:37c2:3778:1adb%2]) with mapi id 15.20.5206.027; Thu, 5 May 2022
 07:40:37 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        "Martins, Joao" <joao.m.martins@oracle.com>
CC:     Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>
Subject: RE: [PATCH RFC 00/19] IOMMUFD Dirty Tracking
Thread-Topic: [PATCH RFC 00/19] IOMMUFD Dirty Tracking
Thread-Index: AQHYW0R/S6mfDid5yEe6M+QKFrUDn60GOWsggAB3owCAACSFgIAI+m3A
Date:   Thu, 5 May 2022 07:40:37 +0000
Message-ID: <BN9PR11MB5276DFBF612789265199200C8CC29@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20220428210933.3583-1-joao.m.martins@oracle.com>
 <BN9PR11MB5276F104A27ACD5F20BABC7F8CFC9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <f5d1a20c-df6e-36b9-c336-dc0d06af67f3@oracle.com>
 <20220429123841.GV8364@nvidia.com>
In-Reply-To: <20220429123841.GV8364@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ee7b58fb-d2b9-467d-c6f3-08da2e6a8be3
x-ms-traffictypediagnostic: BY5PR11MB3880:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <BY5PR11MB3880102445D098BEDB23385A8CC29@BY5PR11MB3880.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vftNXXZKML6l3VR158uhvN4ftARXbReBFqQ4UMCSOC1wRAjyLjLom5T5wniAWh9jfq6jAd27juws6GockUMZhW3P3bQ6sncvVb+iAn43LTKYGKyFYfbBOCBWsJXAOSulUByt+b5/Bg22aCtEpUno+EhWG4v35+J08fIR0/b/zwTKmhhHPt2+a/vCf1e7uar0+UyzVYIkD5BF0tIlE3GvMtmD9B80m+khjJV45k1BadNG3Li0hK2aDHQP7WsO/D1uMtBJiypQSYCes6jQqhikrytPQetBKVVHPOCJD98x452J45CAczJkR9OL8qDj+4PEYsZHdDCOvEUjGI5OvfEc/Awq70LhucF8qKabfKSSI0OrUw/X0L3T8aEWuLA/BQhbgUS9ZzFGN+Ud4makMVztJ9bUj8uwJZDJjOCaiZgevSQXhgSN5qIKtwGW/chKfOlschMW3nVq3GENwsTapO7dzFr/BGI9qwnfacuEH6MksiaSz2h+Sn9Y1PMhDrTcAxhPORSIiNLhEwEE9v67c3wXEoGnFdXZviFRVDFRKsB8qbE+Ce1t1qL4n5ogEdrFub3aKImo4NdmjGf1NLThuDuB0wJT6rTLrskR/9cPqIizb5YN/XnqUwilEnwhxp16B/zWnIGgQLsnO7ypU3/k5ii78J3FGvzPk4zUh0fX96TsQ6nt7QcLzXndupuZrckx70MhsaeRGbWqz0tASefhw6yWRTMTzD/GW0WCEhW0euUJyuM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(71200400001)(508600001)(86362001)(9686003)(26005)(6506007)(122000001)(38070700005)(82960400001)(38100700002)(66556008)(66946007)(7696005)(186003)(7416002)(33656002)(2906002)(55016003)(66476007)(316002)(5660300002)(76116006)(8936002)(54906003)(110136005)(4326008)(83380400001)(52536014)(66446008)(64756008)(8676002)(14143004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?/XxaBxoariEd5e5tWm6lRmEJq0Y9zP6kKl+osdFvXYBniikp2VKx6bzBvUlH?=
 =?us-ascii?Q?dmY63K1vjHI7ldtu4LtaqfcM4dAJQIOZydclCx76SMpqPe03pMoyyRCkMl7R?=
 =?us-ascii?Q?j1+tky6Tc7VQw9SOegvZ/RnCJxLMS7oqRliPdBE5hBm/u+riBbX8dm/Pd7HL?=
 =?us-ascii?Q?J8KFMrg9CVZbzAcLhLn7uvU4LzvyiqttYBO9qGQbgZT3P7ArsEA/KyDr7/cZ?=
 =?us-ascii?Q?21X248hLglPdWyRDauFvd+oE20V3h9MRNSVD3Ojg7pvFTMatGcBz5HE/ePHV?=
 =?us-ascii?Q?rHStSLCEeQ1AdfVc8VSdcR2iBNfvDv6eCcxYVKrfaPNL9NheHVnAAZlAnSZ0?=
 =?us-ascii?Q?94j9RsGi9U5kF9IhTfBhpHcbtP4vENlUCkKZr77TVTUkaeEDbqy4kowGt7jh?=
 =?us-ascii?Q?JNWBDeRnnLDtuXqM3oMSqVL3tjJqh4tw4K1APuphzQ+EUZP9ecgHuyhCTT4m?=
 =?us-ascii?Q?3yCvCO6y3XmgNfS/rDrez9S6grmP65RgTRIRzxxOrDX+vSNDq1GJ3VLLma5w?=
 =?us-ascii?Q?lHHQGfuefMZhahLUSmxNLOQFmLKULX10sl/Pe+9RY6CkRc+NcASJQDDzjH2E?=
 =?us-ascii?Q?OXL1Qyu5CDLcuN/K/SfdJE28eh1Cu4C3uzXh6dZnQG9N/Vsi997O3U19Cdsn?=
 =?us-ascii?Q?U+IhIJr2OIb4hq/DjPf/FFp1HfyTpkrhjaqP/J4B28qzQ+5s8fBOAyvW/gF1?=
 =?us-ascii?Q?gSt6EMTgep+/CjyV3T1pRwMJXNUI6hp1lc+Y3KbEEwRNr43Atyj/cwrCpCxk?=
 =?us-ascii?Q?9oRZyHpC2fgNru338JgAL2ONxwEUZCc8vgTs2T7OMbJmM2iV06MeBp72/o9k?=
 =?us-ascii?Q?Km5xJaLwV7L7JuthEo9n5KxOzzOtlTspJVjOESWRfd76CdvqLVl7CejeRuhE?=
 =?us-ascii?Q?4BLZS/Abfi+mmKqHgWi4RifpbwEwg/a9ulvM4xK7RJABBMzQd7b54ClBnmLJ?=
 =?us-ascii?Q?0BXhuhdnZlxiTVEbDVfbGSo6UCtd/a93Zzw/v+xM9n3DQ2ZXRdzAFzMB52ni?=
 =?us-ascii?Q?XnSenZflzBlQFvES866GyNR82+ycJk9M6tGscFjLKZEmQgNWZG/6KIjdtb0u?=
 =?us-ascii?Q?F2ECKVVL0zi9ueDIKzaPqzofIoy3btoQuUzK/7IbPPvpOA0DuOaJzrj9X36i?=
 =?us-ascii?Q?CPVtQQQNp6gW1PrvWTi3HZBf8gNQOiNrc9UX+5Vol7i8wxutkKNmprxN7QYq?=
 =?us-ascii?Q?CDWvs7EyD57XilOm16bpub9dSyNj2deoY5QcitIzvkveYa/c9zBh1/rLvcDS?=
 =?us-ascii?Q?an42W+Xc8btL3yFW31gjrT6xH5GWpKKqiC9axQ1zhrte1r8c2FzY3/AwA0eR?=
 =?us-ascii?Q?yLExXyp5ihm6N144uRaeiPTqnscPzG8BoOZtYIZ6Ew5nMxAR00Wmf+6NLZji?=
 =?us-ascii?Q?M8h/YlhC+VeePgfq6x+R9tF1JZhd4MhTf+0zl9txRI+sngBs3HvHNE+dpiYH?=
 =?us-ascii?Q?OkoxijX7xkElepKHfib/4ydk8OQEHVToX3BxnKdeLifWRaIx+Q/gbRqQns27?=
 =?us-ascii?Q?4ZY0Yb1a7vQCOGXH1sEPzF55h/2C+b756CLvJpwi8jMF7RFFiO+DzxlmmMea?=
 =?us-ascii?Q?qhJW7XEocRoKtuMTU1h5dUQNDW+NutaK5cM6hO039NKso3tMJFjnk6iuRqqF?=
 =?us-ascii?Q?3y3azVcSl4NKCsrXpxzse1m3duWe6IrOXC2J7idbnhKfw8gIKQRhMOjrRTq/?=
 =?us-ascii?Q?VZ4Es/id920+TBhogQFMofoa00DvkyNUtmUUfrEfOlt7tHR/Y4cJIpzu/Get?=
 =?us-ascii?Q?J5zXi7jhNA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee7b58fb-d2b9-467d-c6f3-08da2e6a8be3
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 May 2022 07:40:37.4562
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oIRPi7cZBbkx/5Xxq+Zo8ZM843FeK5Z35KtsZHdt7Ke19lY/GFMIPDPRixm4eCfpt7KMi1/+k0RrRpnQu+LRWA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR11MB3880
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Friday, April 29, 2022 8:39 PM
>=20
> > >> * There's no capabilities API in IOMMUFD, and in this RFC each vendo=
r
> tracks
> > >
> > > there was discussion adding device capability uAPI somewhere.
> > >
> > ack let me know if there was snippets to the conversation as I seem to =
have
> missed that.
>=20
> It was just discssion pending something we actually needed to report.
>=20
> Would be a very simple ioctl taking in the device ID and fulling a
> struct of stuff.
>=20
> > > probably this can be reported as a device cap as supporting of dirty =
bit is
> > > an immutable property of the iommu serving that device.
>=20
> It is an easier fit to read it out of the iommu_domain after device
> attach though - since we don't need to build new kernel infrastructure
> to query it from a device.
>=20
> > > Userspace can
> > > enable dirty tracking on a hwpt if all attached devices claim the sup=
port
> > > and kernel will does the same verification.
> >
> > Sorry to be dense but this is not up to 'devices' given they take no
> > part in the tracking?  I guess by 'devices' you mean the software
> > idea of it i.e. the iommu context created for attaching a said
> > physical device, not the physical device itself.
>=20
> Indeed, an hwpt represents an iommu_domain and if the iommu_domain
> has
> dirty tracking ops set then that is an inherent propery of the domain
> and does not suddenly go away when a new device is attached.
>=20

In concept this is an iommu property instead of a domain property.
The two can draw an equation only if the iommu driver registers
dirty tracking ops only when all IOMMUs in the platform support
the capability, i.e. sort of managing this iommu property in a global
way.

But the global way sort of conflicts with the on-going direction making
iommu capability truly per-iommu (though I'm not sure whether
heterogeneity would exist for dirty tracking). Following that trend
a domain property is not inherent as it is meaningless if no device is
attached at all.

From this angle IMHO it's more reasonable to report this IOMMU
property to userspace via a device capability. If all devices attached
to a hwpt claim IOMMU dirty tracking capability, the user can call
set_dirty_tracking() on the hwpt object. Once dirty tracking is
enabled on a hwpt, further attaching a device which doesn't claim
this capability is simply rejected.

Thanks
Kevin
