Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B6546C277C
	for <lists+kvm@lfdr.de>; Tue, 21 Mar 2023 02:32:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230159AbjCUBc2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Mar 2023 21:32:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229755AbjCUBc0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Mar 2023 21:32:26 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6517DAD1C;
        Mon, 20 Mar 2023 18:32:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679362345; x=1710898345;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=1MtQPSBb+/a72wMbqLhgninFtZWuhNY3FIaxZPS3Aqw=;
  b=O+XQP2g6q/+Q/mAJ7VWCSQefpr3yzspYBFuUGJoJo3+Wid+vZABxdjGZ
   4VQ7HIK3VVYddHbfepVgNT3edu63+iU0yaSlBF6l5AjPI13w+lbMhMw5x
   QWqOdM5FXhsqPKzlrSw6ekD44zFzMWr5dS7aM9BsGy5y8X9newWdT3CZN
   sf13bi2awMYPgN3uAQdo0U1RGuuxn5gxf1ZBhTNCoUECy5xQQ7SLUo/aE
   +vH4X0A5LHvP7+S7cjaMOXeLYf8CA4Owfcu4ZGImnFhY5A8jqE8YGtn0d
   SoXDW8azdmMLj0gaP2rLrdFB2fVEGLgnG4t4StpAYojYzCdLEayOMrlZ6
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10655"; a="340367610"
X-IronPort-AV: E=Sophos;i="5.98,277,1673942400"; 
   d="scan'208";a="340367610"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2023 18:32:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10655"; a="631360641"
X-IronPort-AV: E=Sophos;i="5.98,277,1673942400"; 
   d="scan'208";a="631360641"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga003.jf.intel.com with ESMTP; 20 Mar 2023 18:32:11 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 20 Mar 2023 18:30:37 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 20 Mar 2023 18:30:36 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Mon, 20 Mar 2023 18:30:36 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Mon, 20 Mar 2023 18:30:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KrF/rhiQ6IO7ktQFG7U9kfICK2/rFyp3V2cQL0UyDcI434VucoJCCmdRizx/7vmXzQx0NovXuDdqLG6cfACKap0ayLIE7WdQCdJk1vM5FBDNJO0hbRGS/H2H8sIMaxt6wmtoy6J0GeZ39xZq4PCZrvBsgz4LZ4D0YXh8H6wu978ZHUdF4lbJ9Z2LVNzU7K0LmoVfkvVJBw/WV55b757dnRHQ6RaMjeRtd646GVR76fzOtMO+gAnSq/gHRrdkAkOlocQPpj8EB2qUytweXORjr342Ay3wIViXxv7L7H37NkZkeWPV11JYyeX9e4DVu9hGJ06qtEtmP3uCtrUbYGr3AA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0XLeDcFhTWvixx4R258SpTH5IRAXH3ylMlSIJPb/UfU=;
 b=mgbxY9345VSDJNEKq5lKKUie6kDY8F7OZA7KdyVVZIfQ06g6nlPz71Vh4VJ92C3ny+Fz//dCxkAWQImuPC8pJTd1VIjvCGNrvDYQtapY21UIwvc7kH4kj8xOf97hfFe+I6Ls4jUUmayqgBavn6avgrAv3yWhEGmSEIQAonJISPRinxFwn7lj5zl2yb/NcLihAtsgXYp+lgoWq4KOGpsVap4ZjfWAEpHJVv5MDMs+3Xhn+Bui6I5CT27xARAS2vYlTgELZJt20oBnK537II1UKXxRsgJqqWL0ac94+oxB1HLUpHxImAPdAoxhfkJAVlBt501i655USMGZRRxU5ofPrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by CO1PR11MB4852.namprd11.prod.outlook.com (2603:10b6:303:9f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Tue, 21 Mar
 2023 01:30:34 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1aac:b695:f7c5:bcac]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1aac:b695:f7c5:bcac%9]) with mapi id 15.20.6178.037; Tue, 21 Mar 2023
 01:30:34 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>, "Liu, Yi L" <yi.l.liu@intel.com>
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
Subject: RE: [PATCH v6 21/24] vfio: Add VFIO_DEVICE_BIND_IOMMUFD
Thread-Topic: [PATCH v6 21/24] vfio: Add VFIO_DEVICE_BIND_IOMMUFD
Thread-Index: AQHZUcIPMa9EffDOZkWyiNA29dWGmq7zuaqggAAQh4CAAAHT8IAHgPWAgAh60oCAAAYegIAALgEAgACJAWA=
Date:   Tue, 21 Mar 2023 01:30:34 +0000
Message-ID: <BN9PR11MB527605E6609222431DFB8AA58C819@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230308132903.465159-1-yi.l.liu@intel.com>
 <20230308132903.465159-22-yi.l.liu@intel.com>
 <BN9PR11MB527665CA5753E413CB4291AE8CBA9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <DS0PR11MB7529B3BFD999C9720836F049C3BA9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <BN9PR11MB5276684B2C0CD076FA3CD0938CBA9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <DS0PR11MB752922A0C9058583F677369EC3BF9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <ZBhpNyrBr9nm5Ae+@nvidia.com>
 <9875e60c-68a7-b360-9d52-66d4915808a0@intel.com>
 <ZBiU8KoSmiM+JkAw@nvidia.com>
In-Reply-To: <ZBiU8KoSmiM+JkAw@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|CO1PR11MB4852:EE_
x-ms-office365-filtering-correlation-id: 412ae1e4-e664-417c-57d1-08db29abdde7
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vfJrPVHz6rbxOHLv1yyIGpiVf+bZLY1F4y4jP5jSeoHCg7ltdH7lGRHUAJQMq8WvK3xSm1q8XV9GZ+l8hyFTqA6yulzjrWnA7xz1PoMQIk5Z3e3mTaPPWqDHYeLOZlnSIhvOPhPWQvztnEadBfSSCbKae0MQaibQYxtBFSb2JCVCgouyk09u+Mv0nz5VXPb+KxhylK2K7pkzu5nVXqJu49L/9bOTBh2atuSNyudrsWMmHLcBnlHPCcs1LhmyVp1OB5wT8mGpopCbLsywlL95LJfjwerZrcc49FY3ScA++P152Xn0LtkbaSsua3VnF8UXu0/FFoJnJHKrcpGPY3FkvXBk4H05CmddFQLcgR++sKfXYQ2U4ki4/BeecMRjsoN1MpvqTsmG/kvzjnPKHV1LnJUk7EcL+V4qDME2fFe3rNRX6PgYwqKe+4NRs5Gd4HAEhVPqXmq0pHOW/TqqTjP+6ZfJDvLIhzz7a28tPi2Zws8Li39/ymNsXwmsjXd5v8ItGFOSoi6bd4FAxqNY/OK4r7LQLafFLpC9gEbj3c5GX61r4jTHbvYGWuLqiz47JDRCBstRdL3pjlbDWIi0f5x9LjOYpjZBzhqMrGYxt4CZPbSoas/cosSVrg+dicNOr/ZRMsCwC/1eactuqm7KExrGeSD8E2cM+y6ThtyqxDJtR8DFo/HhWQ3H+dHjItjLFgs46/CGsUP+KkOX7P1Q/FtoXQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(396003)(136003)(39860400002)(346002)(366004)(451199018)(38100700002)(122000001)(71200400001)(7696005)(54906003)(110136005)(33656002)(6636002)(55016003)(8936002)(316002)(8676002)(41300700001)(66946007)(52536014)(7416002)(66476007)(66556008)(5660300002)(64756008)(4326008)(66446008)(76116006)(2906002)(478600001)(83380400001)(86362001)(82960400001)(53546011)(38070700005)(186003)(9686003)(26005)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?4+92R1d8NKqK8elkO0MKL/MXud46MEzLIRHRMyOF+nRI1SjPwWPMa08t0Yhw?=
 =?us-ascii?Q?dZbD6gRRwjqmvPgbtjVy89O/0sh6w/4WsQ8y+Ev8cnVG2Ob4QwBT+fJuqUlf?=
 =?us-ascii?Q?lF0DqwMRUD11z2dZ/yjpBkjrM1kGJSvH6DmVqr1mtJDpOVh2pxvhbOIhP0Lv?=
 =?us-ascii?Q?MWzd3zbRtQVK4PqAW5VvPZLmkkyFLuP9+A8DfZFB5vFFqkBGBw042APN90Ey?=
 =?us-ascii?Q?XtO2b1K7Ix0q8P1Iwnn7fj2rI8NbuwyQQzACEKlatuKYC80CNc8aBZLpC/JX?=
 =?us-ascii?Q?EO+MNLVwAYzJ5AEDxlinCHJV8UsKjViXULEdlQVSdK/HbnhqsRN3RU04iABX?=
 =?us-ascii?Q?lMzlyc5Se5jcIbR1Wr7GiQtPDRq6fWmwcDMA5UzjHIkXgfLfALeaduWNw5PY?=
 =?us-ascii?Q?+MMdl6+a42wdqjd/TcDwfwMsjDMVTcqbfPDhyo8KbSDbjZV2a4ZIilwUDijz?=
 =?us-ascii?Q?5sH8AVIj9oQHVQXvY+JvekOhlHpcMMnN4jyFrB8fzPfwcd4cWfMVDVDPydyz?=
 =?us-ascii?Q?XVOb9BNPbTP+wzqYBibA8rgcrh27vHdF/zadG4tLmiLV/Lknth3Edj+IL2kU?=
 =?us-ascii?Q?8MD8LdmZqfssPSt2RRSqU6VnlCiOmNhjwh0lZcdHS89ZtBLS5NX/LiyHDLwL?=
 =?us-ascii?Q?HkEOi8T1+7AtWf33et0kt3jo2nwrHHGnmN6lKZvxXb/jRYwWe70AFCluPWvM?=
 =?us-ascii?Q?w3YxmIja1E72PNnyR2vFRKQl9N5IvnwNY+ilBRqInehqaJWp2L7vcCSMEOc7?=
 =?us-ascii?Q?xWTATYju/QCHXLpIvBelKUhDG8Axt0OyRnFmTsXuH0W3thEf68VARw1NpxNk?=
 =?us-ascii?Q?Mp0ymvCcGLJM8LtY1IYOEb1IcpFE9Co6tCC6Zb4P5JhRy62fbotzYSSQ1674?=
 =?us-ascii?Q?AIRMdSAgvP79qTCrR+tpr8EQ5Wr9uT7qtFfehbRjedz8ynPkXIn8NokUfaBL?=
 =?us-ascii?Q?LWWkiwgxKJHzBMDUOMJ8bVIpEW2oINpCFPxyD9jMtbXaEVSSlMx4UQyNPVvS?=
 =?us-ascii?Q?IlFZs4hEqu8JvdJlzBA89arECYHJHtETsQ1PafFdXTD6ZZVgKVPXFyaEqLAx?=
 =?us-ascii?Q?1Bsxy4+3fLyA6Lh+pcDCMwNZQMmg6PhRWpsFQGfeS/KGlMhRqGaq9fW4eSED?=
 =?us-ascii?Q?A6wB4cHkfhgfFwdQ/YrcqtOaGRkxxpanLGWeBT2tew6Lch+cC2+2xRD3+o5I?=
 =?us-ascii?Q?RquaRBlwrWzj2k2Q2ad4zWJQPOpYfUSBXg4EXRhuouYAoYwf7EWZVPdt7uU1?=
 =?us-ascii?Q?XgCslC98ZIRoQQkSO0qVoMAd5xMj/Abnf+aPiRUTmxNxdp/Yt8O3Zf2b81zP?=
 =?us-ascii?Q?TNyh7orlIsFZgfK9EEFBeSnXDtUP0CIA+gBZYpPNhQ7ge/iIzzuFeFkyhhLA?=
 =?us-ascii?Q?cwRCxrbnTGxK9h/YmRO3p5bkmNJekp0hjY3ZRqvHaBqysTxCe6jQOQrk7jEm?=
 =?us-ascii?Q?nHwaQNUzCrqji1TGi+6H6moDZAtVzTUZe6mKd7t3+X4U1lXb4kXUCWEnHJhr?=
 =?us-ascii?Q?OWyLaOM/fJtDwtAajHzGXXKH9JAjNYrHIto849iOYBw0dP0N6IAaycuomQDi?=
 =?us-ascii?Q?3KMaWfYaybKSGE/hAqnwTC9VPuZQLRpBg+Q6j2P4?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 412ae1e4-e664-417c-57d1-08db29abdde7
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Mar 2023 01:30:34.1505
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mw5fA7aMEJdCivqtiHuCij8mdYa2A+r+ObHEo6uYARcTmN0KP1HKBHf7VlFpdJUBBziRuz1WCvE64X2jfHc6qQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4852
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Tuesday, March 21, 2023 1:17 AM
>=20
> On Mon, Mar 20, 2023 at 10:31:53PM +0800, Yi Liu wrote:
> > On 2023/3/20 22:09, Jason Gunthorpe wrote:
> > > On Wed, Mar 15, 2023 at 04:40:19AM +0000, Liu, Yi L wrote:
> > >
> > > > # if IS_ENABLED(CONFIG_VFIO_GROUP)
> > > > static inline bool vfio_device_is_noiommu(struct vfio_device *vdev)
> > > > {
> > > >          return IS_ENABLED(CONFIG_VFIO_NOIOMMU) &&
> > > >                 vdev->group->type =3D=3D VFIO_NO_IOMMU;
> > > > }
> > > > #else
> > > > static inline bool vfio_device_is_noiommu(struct vfio_device *vdev)
> > > > {
> > > >          struct iommu_group *iommu_group;
> > > >
> > > >          if (!IS_ENABLED(CONFIG_VFIO_NOIOMMU) || !vfio_noiommu)
> > > >                  return -EINVAL;
> > > >
> > > >          iommu_group =3D iommu_group_get(vdev->dev);
> > > >          if (iommu_group)
> > > >                  iommu_group_put(iommu_group);
> > > >
> > > >          return !iommu_group;
> > >
> > > If we don't have VFIO_GROUP then no-iommu is signaled by a NULL
> > > iommu_ctx pointer in the vdev, don't mess with groups
> >
> > yes, NULL iommufd_ctx pointer would be set in vdev and passed to the
> > vfio_device_open(). But here, we want to use this helper to check if
> > user can use noiommu mode. This is before calling vfio_device_open().
> > e.g. if the device is protected by iommu, then user cannot use noiommu
> > mode on it.
>=20
> Why not allow it?
>=20
> If the admin has enabled this mode we may as well let it be used.
>=20
> You explicitly ask for no-iommu mode by passing -1 for the iommufd
> parameter. If the module parameter says it is allowed then that is all
> you need.
>=20

IMHO we should disallow noiommu on a device which already has
a iommu group. This is how noiommu works with vfio group. I don't
think it's a good idea to further relax it in cdev.
