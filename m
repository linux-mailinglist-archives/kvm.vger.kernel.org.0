Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B9FC72F439
	for <lists+kvm@lfdr.de>; Wed, 14 Jun 2023 07:42:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234385AbjFNFml (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Jun 2023 01:42:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233153AbjFNFmj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Jun 2023 01:42:39 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56C0D19B2;
        Tue, 13 Jun 2023 22:42:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686721358; x=1718257358;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Gzb+E6nJ6rM78+fRO3hQkBenuFx5iyPJm61rTN1saC4=;
  b=DstZfjJRXFhbNJgu6SGJ4xdVK266eeyokYwDc/GKJPCJTv7/e3uE9fpK
   oWE3B8zpoIdj3j8g164NXfGp8sia3Gnv87NKS/AgGxHwj76Xnxb73TDCY
   Wy3CTEHUjoS5kuHBkw5T06w2rPcWiCTbCgXABSiscPxaBdj0R/e49+H1k
   hSVfw4UpkG6IfQ3dtC1iguaAzfBUFNDMsZHIs8fv7MgF+XTwYPoRRMRoZ
   SsaIvQwBIZc5KijOMCAL2xNnSDdv2jqIL59xLs/Jk5tjC9So6dxPgAcmR
   BO0BKFM+hTSR2VzfjAKMkd4YKaiLppK5FYH23lUxAOU/mjOJQKEry5/rl
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10740"; a="361899350"
X-IronPort-AV: E=Sophos;i="6.00,241,1681196400"; 
   d="scan'208";a="361899350"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2023 22:42:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10740"; a="706077571"
X-IronPort-AV: E=Sophos;i="6.00,241,1681196400"; 
   d="scan'208";a="706077571"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga007.jf.intel.com with ESMTP; 13 Jun 2023 22:42:31 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 13 Jun 2023 22:42:31 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 13 Jun 2023 22:42:30 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 13 Jun 2023 22:42:30 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.169)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 13 Jun 2023 22:42:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T9M8d+unsEqyJrx6TWUtHULF3x2Q7Fe9/2qaRVVuUgKbaEhkvS9QVbolaCwGqgGkfjq0/X3EFvJmKsycSurCV23buEurNPLUnh11mi+Vt4lDBCF+3HD7sOFeBZthLLpXqm3pWzMEB8y0R+twSZRhAAjaevh7SoL7czaRvlARtAlckZsrtg8lhYHfqsgC1MRgRIydi4fqGyJFya/YkpBhOYD2c320LXbQgMrawFgdeeor9PS00y5Bu/fIoAQ53zgB8lkOAL2+XUUEeYCKhQgVlI5H12JK0lszKQ40FEFbNHYfrNn54QAXMRyBOxi83HiJpLLRMrLl4u/XfCgWFipGyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a81QFCokkuBiNYn8/JCdyNjUu4UZSpkKNUjpbiKLa3M=;
 b=eGE+zsQUXr2/cHJbuj0jzh5pKSZk3teNscZsFjqiPGgvqXNDG5+GR4saPATZytyZDjQH7VJhRXm2MvEtYAeusfbldbIUPqSYQKwhVcxfYiezcRrYpCC9m41vC5x7+bNPBrfMcuX6GBmDIGPxiUWOU1GLSk7HhosmNzMJz3fGG6F5Zwo4rkU7HgIOGfh69CJUV3cHo/BkdQeodxhNTh8oyd31ko83Ib+YW6oIiT1Aa/SCveSPOVww5BC6nEWtUiWCZiOzAjtSYulYUP/VpgEaymBBOVkfFgMhx/1T+cd1FPwZ4tQVJ7GtFHujvzA7YAw2E0UHcfSI16NtA3T4CHjNmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DM4PR11MB6405.namprd11.prod.outlook.com (2603:10b6:8:b5::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.37; Wed, 14 Jun
 2023 05:42:28 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::4f05:6b0b:dbc8:abbb]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::4f05:6b0b:dbc8:abbb%7]) with mapi id 15.20.6477.037; Wed, 14 Jun 2023
 05:42:27 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
CC:     "joro@8bytes.org" <joro@8bytes.org>,
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
Subject: RE: [PATCH v12 21/24] vfio: Determine noiommu device in
 __vfio_register_dev()
Thread-Topic: [PATCH v12 21/24] vfio: Determine noiommu device in
 __vfio_register_dev()
Thread-Index: AQHZlUw4/rlFbB33G0OF+kxLW4i2ha+H07wAgAB4fACAAI09gIAAA9uAgAAEUQCAAAOrgIAAAzGAgAAiIoCAAAWUgIAAK4AAgAB5BgCAACPuwA==
Date:   Wed, 14 Jun 2023 05:42:27 +0000
Message-ID: <BN9PR11MB52761B4E9C401A46FA5B4F2E8C5AA@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230602121653.80017-1-yi.l.liu@intel.com>
        <20230602121653.80017-22-yi.l.liu@intel.com>
        <20230612164228.65b500e0.alex.williamson@redhat.com>
        <DS0PR11MB7529AE3701E154BF4C092E57C355A@DS0PR11MB7529.namprd11.prod.outlook.com>
        <20230613081913.279dea9e.alex.williamson@redhat.com>
        <DS0PR11MB7529EB2903151B3399F636F5C355A@DS0PR11MB7529.namprd11.prod.outlook.com>
        <20230613084828.7af51055.alex.williamson@redhat.com>
        <DS0PR11MB7529E84BCB100DE620FD2468C355A@DS0PR11MB7529.namprd11.prod.outlook.com>
        <20230613091301.56986440.alex.williamson@redhat.com>
        <20230613111511.425bdeae.alex.williamson@redhat.com>
        <ZIiozfqet185iLIs@nvidia.com>
 <20230613141050.29e7a22b.alex.williamson@redhat.com>
 <DS0PR11MB7529F2D5EF95E9E1D63C9264C35AA@DS0PR11MB7529.namprd11.prod.outlook.com>
In-Reply-To: <DS0PR11MB7529F2D5EF95E9E1D63C9264C35AA@DS0PR11MB7529.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|DM4PR11MB6405:EE_
x-ms-office365-filtering-correlation-id: 35bf2950-7691-4067-42c3-08db6c9a233e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8vXyhhVGV+4PusyVNG/zZpy7fr7AuNW70ghtwhk2tCz5d4XxP99zk3jWu4f/Gtr7qSOngqQCTGrEU8EyZYnxxoZfxkqkvnrQFars0sZbhxw+ePxKLK/okMgR6mojJ4oxD0t0x+9d7WMBzUiPGB4Zphqzs26KcvIaAPtOuhsgAgZiG3uBWWRHlWA2PVsGrV2ypt03bHw0wmUfWDWI5mEz1zSjn+ueIUvJ7Bf/YKWiihLTnwColg6QO2Gvp+7pDSfI11inSXnUt8xor3IfEmNmeCbP2pQkguQXSEALy0KztCYMmqZ/1DbsfbiKWCwY9pS6yAgwpS6YKqD6ru6qL+Z2dqUrwKyU4tnf8/tgKNKvhwxv9ppAy0DivwcF/TrScLZpBZ4GUi6UjIJ/UmbRkaJf29uT1SRd91uAGiUqemI+Upyi0gYTwB/DlCFP/fxpqYezxldFwUVt+2c5jd+X+JV9dZQ2tPdTwcRQ0BiweGCe0PRnZ2txWOz7f7ClX8jzw/gXFQVmJ6jfEDcYHZs/szBbDgOesTY5H0W8zZxOIbljRJbBL6GCGsN8WkKpAMT0TpPx3QmqfXj6upo5WSE5fqroZELqNwxw0agnMbNb791rArXQzFJu/VfutMYhjipP8GYE
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(396003)(376002)(39860400002)(366004)(136003)(451199021)(7696005)(8936002)(9686003)(26005)(8676002)(41300700001)(82960400001)(478600001)(38100700002)(71200400001)(66946007)(66476007)(86362001)(4326008)(76116006)(66556008)(64756008)(66446008)(316002)(122000001)(38070700005)(33656002)(110136005)(54906003)(6506007)(55016003)(5660300002)(83380400001)(52536014)(186003)(7416002)(2906002)(66899021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?BFlOUb1lvJnYcn63/tBv4bcDipETeFf798fojnL0kwHc0web1gRqOx2y11yD?=
 =?us-ascii?Q?CGd1i7+U7/W3qRq229FLqrEuDsCbt0TsBBDTsbg/gYr9XW+N4chuTcQJ04iY?=
 =?us-ascii?Q?vzt4flttKWTo3JvoG+DSOKtHdIVAwf5PJtKi5qhmAvIeTCB/iBb0ZaKon4eK?=
 =?us-ascii?Q?8LeQWC+4/WIV/b5AmxpH2FcFO9McJJh1vD0QEI3MboL/Z/J7uux/6O9InXy3?=
 =?us-ascii?Q?C7LDUXwir0dyiFhPJuH0lWAJukvu+QhpLHSwjgg4nsATXe1h5dfuIbQ/Pggn?=
 =?us-ascii?Q?yyMPsiaI0CNsWlTNMfrkTBMvDyxUCNjpAt3mnwa71KvmJtHNCH4Faw2s+jWb?=
 =?us-ascii?Q?+eZtjDh/UD2CcHPprZy6GMxtVQRynUaAn2AuL2Ds2MscNr1PYOGGHa1qnG7R?=
 =?us-ascii?Q?kaOmvhlbZ4ceshJVs8GIyyptPOCRxe/bwh3vHiDThcfNnIbqa59qO7llS+bF?=
 =?us-ascii?Q?Lh4INERfVISW0ji8ZR6KT10rLpVGciQDIzHj/RkOfOVbYNErqGQL341g0y9e?=
 =?us-ascii?Q?eVsfiOTb9jWpgXXiNlnigaLfiJIFXPCPX2LebyvSsYY1azDrTyngNxEUEk2r?=
 =?us-ascii?Q?/7HUpNXn/4bFozXuz7M3DwGkVqzROyUeRt0/tm+njsnG+gkZgYfgozYgzmGp?=
 =?us-ascii?Q?/khnZyScVabqHxJunqND3YA+FcHeMX0HqACxMDjQa9WzTNkhmJou7cBjfOWe?=
 =?us-ascii?Q?L7wlsBP0QMn4tWwvLis/taKRCLRoYbmuOniWivJFCnFtpalXq6lyQTwIKYMk?=
 =?us-ascii?Q?vZX/biDtawWIR3BbSIEvr3XblDuwzhYwr5QPPBjwQiM3F2O2W4t1a8/Fw46F?=
 =?us-ascii?Q?XxIDBElVkTcwQ7w/+rJ278vs7pCNUY+6lc1arXWl9AFc8SWfAp1rhvhi5vcn?=
 =?us-ascii?Q?1rr8SOshEMUe4yuitWLitSqpldxV6cqzdlHTfhzImlsI3zOPXnWcjRgvTxcF?=
 =?us-ascii?Q?2apo+e/OvHVrEvpC6JuaDpn9Y+8da0M6aDCY+/FTwguIXXyQhOqSKTEIrUfd?=
 =?us-ascii?Q?tddYry48my4/07OAb+FhDMHF5vkt/ycW3B7iCh8sMuJNumk3F+WaFWa83dBc?=
 =?us-ascii?Q?V5al85CTU1ylhlExiX5mLzWJ/uaoQgpNJztr5cXYg0qcmNaIjz3mdGA2c1SH?=
 =?us-ascii?Q?BqYkNZTMsCRI873oSWsoxzllqNjk0MtXVLZX+cyOZpRZy1gOVmyAuR8y8RHt?=
 =?us-ascii?Q?B0AwmZ5EIJdBaBbaHIOMPiYTb3F2OLjS9OIBYxXyZ+NYIFLGDvg0BqtjtTaN?=
 =?us-ascii?Q?9WJFJVRMUfeCPjPQA9KNlCV62xUGKof6gqaahWM9hhg4jpwYdc7HULVi6Slu?=
 =?us-ascii?Q?jc9cwsTLjbzsB7QVVAYfxW7SRAdLIh1e6vvQZ60sKpaTdJCK9s/ZO9q7ZgNz?=
 =?us-ascii?Q?TQrP5qEjujfml0WDxZ9rmqlVb3HzN+KXEXK7KRwjnT3eviLmjldbsDlr8hRN?=
 =?us-ascii?Q?8DE4aKydTJQ8HAA0YZ3SpqWkAScLDiQr08WQT609pLgjekdTb1NN45F6PsOt?=
 =?us-ascii?Q?o84AdmxcuRuK6tCgnIISqjK1fDzb75ZO2MYHAZ46NOR3i77C4O5kYuqZHVkk?=
 =?us-ascii?Q?watOdnrekVPNGMhr2Uzibi5AxAMX091ibzuoJ91q?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35bf2950-7691-4067-42c3-08db6c9a233e
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jun 2023 05:42:27.4860
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: arYwoKdoe5arvql4vshFpvRqmSZ9fCBYZFD0kvSHReLUouccy+wn4mdcs5psfWodHf5N1A6JOUeBt3tIpAhMrQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6405
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Wednesday, June 14, 2023 11:24 AM
>=20
> > From: Alex Williamson <alex.williamson@redhat.com>
> > Sent: Wednesday, June 14, 2023 4:11 AM
> >
> > On Tue, 13 Jun 2023 14:35:09 -0300
> > Jason Gunthorpe <jgg@nvidia.com> wrote:
> >
> > > On Tue, Jun 13, 2023 at 11:15:11AM -0600, Alex Williamson wrote:
> > > > [Sorry for breaking threading, replying to my own message id with r=
eply
> > > >  content from Yi since the Cc list got broken]
> > >
> > > Yikes it is really busted, I think I fixed it?
> > >
> > > > If we renamed your function above to vfio_device_has_iommu_group(),
> > > > couldn't we just wrap device_add like below instead to not have cde=
v
> > > > setup for a noiommu device, generate an error for a physical device
> w/o
> > > > IOMMU backing, and otherwise setup the cdev device?
> > > >
> > > > static inline int vfio_device_add(struct vfio_device *device, enum
> vfio_group_type
> > type)
> > > > {
> > > > #if IS_ENABLED(CONFIG_VFIO_GROUP)
> > > > 	if (device->group->type =3D=3D VFIO_NO_IOMMU)
> > > > 		return device_add(&device->device);
> > >
> > > vfio_device_is_noiommu() embeds the IS_ENABLED
> >
> > But patch 23/ makes the definition of struct vfio_group conditional on
> > CONFIG_VFIO_GROUP, so while CONFIG_VFIO_NOIOMMU depends on
> > CONFIG_VFIO_GROUP and the result could be determined, I think the
> > compiler is still unhappy about the undefined reference.  We'd need a
> > !CONFIG_VFIO_GROUP stub for the function.
> >
> > > > #else
> > > > 	if (type =3D=3D VFIO_IOMMU && !vfio_device_has_iommu_group(device)=
)
> > > > 		return -EINVAL;
> > > > #endif
> > >
> > > The require test is this from the group code:
> > >
> > >  	if (!device_iommu_capable(dev, IOMMU_CAP_CACHE_COHERENCY))
> {
> > >
> > > We could lift it out of the group code and call it from vfio_main.c l=
ike:
> > >
> > > if (type =3D=3D VFIO_IOMMU && !vfio_device_is_noiommu(vdev)
> > && !device_iommu_capable(dev,
> > >      IOMMU_CAP_CACHE_COHERENCY))
> > >    FAIL
> >
> > Ack.  Thanks,
>=20
> So, what I got is:
>=20
> 1) Add bellow check in __vfio_register_dev() to fail the physical devices=
 that
>     don't have IOMMU protection.
>=20
> 	/*
> 	  * noiommu device is a special type supported by the group interface.
> 	  * Such type represents the physical devices  that are not iommu
> backed.
> 	  */
> 	if (type =3D=3D VFIO_IOMMU && !vfio_device_is_noiommu(device)) &&
> 	    !vfio_device_has_iommu_group(device))
> 		return -EINVAL; //or maybe -EOPNOTSUPP?
>=20
> Nit: require a vfio_device_is_noiommu() stub which returns false for
> the VFIO_GROUP unset case.

device_iommu_capable(dev, IOMMU_CAP_CACHE_COHERENCY) is valid
only for cases with iommu groups. So that check already  covers the
group verification indirectly.

With that I think Jason's suggestion is to lift that test into main.c:

int vfio_register_group_dev(struct vfio_device *device)
{
	/*
	 * VFIO always sets IOMMU_CACHE because we offer no way for userspace to
	 * restore cache coherency. It has to be checked here because it is only
	 * valid for cases where we are using iommu groups.
	 */
	if (type =3D=3D VFIO_IOMMU && !vfio_device_is_noiommu(device) &&
	    !device_iommu_capable(dev, IOMMU_CAP_CACHE_COHERENCY))
		return ERR_PTR(-EINVAL);

	return __vfio_register_dev(device, VFIO_IOMMU);
}

>=20
> 2) Have below functions to add device
>=20
> #if IS_ENABLED(CONFIG_VFIO_DEVICE_CDEV)
> static inline int vfio_device_add(struct vfio_device *device)
> {
> 	if (vfio_device_is_noiommu(device))
> 		return device_add(&device->device);
> 	vfio_init_device_cdev(device);
> 	return cdev_device_add(&device->cdev, &device->device);
> }
>=20
> static inline void vfio_device_del(struct vfio_device *device)
> {
> 	if (vfio_device_is_noiommu(device))
> 		return device_del(&device->device);
> 	cdev_device_del(&device->cdev, &device->device);
> }

Correct
