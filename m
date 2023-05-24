Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCE7070F066
	for <lists+kvm@lfdr.de>; Wed, 24 May 2023 10:15:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240113AbjEXIPM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 May 2023 04:15:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229881AbjEXIPK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 May 2023 04:15:10 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6ED512B;
        Wed, 24 May 2023 01:15:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684916108; x=1716452108;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=W8mxOm8XvTrJsj8HFlgEnTDlBwO9PaMuRBXOyz9ki+I=;
  b=cyHx0GwLcQJWyrDLE+3mgeeCuQfC3PjgfDF6W1XshFcBCr1Kh/6LU4Mi
   jb5P6ES1jgUxPjDCw9mbyuYSrFHUBb4+vCMwX8e/NQFUp4f7TWWDNAQmw
   OsJMnq+JxWgOxBqH0xsxkc8gScLRPwmwcksE9ZumXmAgxoSp3u9fvB2PT
   ZmpZkRJnqbbq9Q3fwHz26t40ifrnDweY2FrkLPSPdSTDsaJc1yslwY5RC
   ikpYw3kYkYdzQ2reOrazC084MR1LosNJy/9u+eLWM432eKJsUuxu2nkmh
   fRRlViClFrdAJi3ygwKFrN9JsIWfw9Tv5rt5Ne5H3ZBrlcA0QKPJYjSM+
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10719"; a="353516645"
X-IronPort-AV: E=Sophos;i="6.00,188,1681196400"; 
   d="scan'208";a="353516645"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 May 2023 01:15:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10719"; a="698426848"
X-IronPort-AV: E=Sophos;i="6.00,188,1681196400"; 
   d="scan'208";a="698426848"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga007.jf.intel.com with ESMTP; 24 May 2023 01:15:01 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 24 May 2023 01:15:00 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 24 May 2023 01:15:00 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 24 May 2023 01:15:00 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.171)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 24 May 2023 01:15:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VC6jPOuLyJB9xvNnqgAK6k311QObKQlnQoVkEd3Rzd5SkxqL8XCzwjIX/F4UMNsUcla3/irPH0N0zeyoMQrAo4ysqXQ6Csw62bziLgkkEr5v+Kmeb6j544Kixfy7y+02fEPj5XKZ9/GryFn/wRS97XQ0FwqmRI5DNsNporYnixOhCnxSGx1VcFugId3UAf73GDSvszCaliiH9aYkL9WpmcnsaKhIwhyt4HboY1AJRl2L+Z+dJpCvetnP81gLzugiMHDtO5jyfNINbwRL+sZXGc64mOoe04PUwGw/woBaGXseTvu7ZQZX3WY+oyqSmNKtmi7CIrTlvr0dpBq7V2KvyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c8sJO6S5FVXfc5oQ904djBHa10LhT+pFnh/CAD/bteY=;
 b=eqTHXg8tehcfCIoXhZtcly3moQdo7QjsQTT0TtOVknabLojiTEfSbPikPOwCF6R5B4F8SJ8T0LE+eXDZGCvTBg+1BLVrUmGyYiMMJgFb7JKYMZAf6W7ZDEk7QVkaQf4id/SByWP27EXMJ77N492DxJy7RliUNPD1i/5/HLyL2MZiR0WTOaMjYjj6KBhDr6LVQ2ae9talHOo4b1dQlWwy1gbDmP9gxHa+dxR/vQzcgoT/AqGu38bq/+kv7I168EY2mxl2br+8Xu56iaCfZYDmZvbBUaWUobGEWhN9YKxqa/xn9V2DnLtEi7JwacNJcOQyCkUBlxKVUhBYGREOy90W4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by SN7PR11MB6922.namprd11.prod.outlook.com (2603:10b6:806:2a9::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.27; Wed, 24 May
 2023 08:14:58 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::5b44:8f52:dbeb:18e5]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::5b44:8f52:dbeb:18e5%3]) with mapi id 15.20.6411.028; Wed, 24 May 2023
 08:14:58 +0000
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
Subject: RE: [PATCH v11 21/23] vfio: Determine noiommu device in
 __vfio_register_dev()
Thread-Topic: [PATCH v11 21/23] vfio: Determine noiommu device in
 __vfio_register_dev()
Thread-Index: AQHZhZ7jRzQlMHxxuUqS1TLfTxm1l69m+EiAgAAswHCAAf0VsA==
Date:   Wed, 24 May 2023 08:14:57 +0000
Message-ID: <DS0PR11MB752907D211E3703145503A12C3419@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230513132827.39066-1-yi.l.liu@intel.com>
        <20230513132827.39066-22-yi.l.liu@intel.com>
 <20230522170429.2d5ca274.alex.williamson@redhat.com>
 <DS0PR11MB752991A93B0B4603E7F501B5C3409@DS0PR11MB7529.namprd11.prod.outlook.com>
In-Reply-To: <DS0PR11MB752991A93B0B4603E7F501B5C3409@DS0PR11MB7529.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|SN7PR11MB6922:EE_
x-ms-office365-filtering-correlation-id: fd23c9e6-7604-4e23-0e5f-08db5c2ef667
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /o5Ycpv3sA324LZhqRSytbm9Vvhv2BtNUlQ/Rlhjgp3/V3IO7qQQdF25UCJMJLu8ZAb8apieL4NU6KU8/xitYYtSNQ9AXK+RqypG6pRZ/QCF4qP/2JlTRX0Scn4CjYUNgq85PyLHSVkQYz+BDvbQPt9RFSwlKKU3YKOv3ZLidyJIAqz7ZcpiaCBtUjWNxBNGNVSOisOglfSBITb87lrFWsLtlar0+w7kT4kHs5GNxan5pdEtkjAE/q2iE8Z/ufspFqxDzYfB2I/GLizBbMKmXTPHc734moAyFMcbiHcQHUmlr6zvH5BgVu4bYpc1F5pvDT5EYcaffMn4bb7rqOuPZIbvWxdFrQ5lgTiUZSYYEHM2IfsywuU916vnEU8jaLMHJMFWZsy6YapxT8S9F4MjvkzPYijqV5IGQl3QGDAR+M0fCphrL0P8aWcBrhia1UT2am3YEc8xf3TA3ToOTtilzNECkjlmDkoJyOKDYAlTtRg0inrLFXSPfx23GqjjN/QHRGNoqs1jByv/dxYrf06K0hIrP/k6FtsVrMt7RL4ZFWEZvR3F2vwT/96n7J6T/QFeSOUC7rTQcAygXi8vpHGklpwCUnDaK1oWsMEaQc+yW645WP5Iob4Xf7Q3zUNvtFKOi/sHDc+pC1fWKUcgMxnP+A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(376002)(396003)(366004)(136003)(346002)(451199021)(54906003)(38070700005)(83380400001)(478600001)(86362001)(76116006)(33656002)(186003)(66946007)(66556008)(64756008)(66476007)(66446008)(2906002)(6916009)(316002)(26005)(71200400001)(82960400001)(53546011)(6506007)(9686003)(7696005)(4326008)(41300700001)(7416002)(52536014)(8936002)(5660300002)(8676002)(38100700002)(55016003)(122000001)(13296009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Cbu/AyQi46TachoVTEZwWL+RK8bT67MJ8M/N8wVSAFnJGFhQ4umv1fyFLy4u?=
 =?us-ascii?Q?HZCmO4E/E6nCFSabBZkHfJFssNYoN5HzPoCgoQUCWYW7KpAePriiNP9uvxXI?=
 =?us-ascii?Q?1mt3mDrNbzbRARGZX5P2HNUEwvbIHQCAEYZE1I8z0Pw9yTrIMqtArHT9l+jS?=
 =?us-ascii?Q?Xb3VkpqRKXG4x573VVpcyEhHMqw3VUAa0oPpPOZuglbF7EVJ2PnDP8/uW7Vl?=
 =?us-ascii?Q?p1nHolwrXhkFbGOgySdCrd7+pgdHH4qdU9SfJ7IIwwa5F7+YCfjlaMdsc2N7?=
 =?us-ascii?Q?EsOSO0b80feywkt3++Vdf0ErlUt2OMgIOGXtqFjBwwzmF89Z0rSHaUR/28N5?=
 =?us-ascii?Q?KJJyuLjY131oUINNMMDBHNQq+Q9rZvKbtakpCnV4A94o0yEdK/ntPKpgVXi6?=
 =?us-ascii?Q?ec0Yz8IBdSi0gwU2o01x/AQ7/RfUq3JyhRYusyUV/Ev1/nCktmHZbEJJEIF3?=
 =?us-ascii?Q?vZ3CY5zlfmxkbILgGWFnmrm9SplzMU730fbT9HVt+OkCwtyo20bRjQlAr+Ok?=
 =?us-ascii?Q?X4cjKP3O+MtF0wrhUAyqxPVxhuSFih79VjcmOF0uAMkH88dWzmgOSWq8BE0O?=
 =?us-ascii?Q?Kv2aB9ZxnliPoiSiGaKWksxUji9dE7kMJWXUOssWCqQqhAQmp6X/Y4jLQdzC?=
 =?us-ascii?Q?xD5Wme6fG7BR5vxwL5iNmmTWVdPW13pKFx0AvC9ZxX2gSnaOTHuqmihGVKCf?=
 =?us-ascii?Q?S8iiJ1i0YF4aB606SojogG895fv0vwY92mGBAJk4mu8gMsG+gA8LB1CaG+Z5?=
 =?us-ascii?Q?novySvDsRNS/kBGSL8GgRxKYIIh0XbsoGE0SJun26JCDSktQKg9UATjiTku9?=
 =?us-ascii?Q?L82Qgqg5/Mr3YOvd+PBAMpUDaXITORd+60kXICFUT9WSLvlwlfkFoW9UGJsN?=
 =?us-ascii?Q?YgDZRGo4iMAQYOKYC3rVHYEhqJLOTt6prnCbCzzROb5FehVg+b2wwtKsxSlY?=
 =?us-ascii?Q?pVmvWgxphaVQopPYM1qySASFUUexlXdm7ySUuCPSC20Bcxh5qk26/qIxU9wv?=
 =?us-ascii?Q?6SE/Ck+JouSa4gzYYnM6xCc5CYXxkpTKV8DoTW9vi35mLNAPsP1tSsCR3BAo?=
 =?us-ascii?Q?cAtG59HsEmntg4HT/aEnf9i0jKFxhnCHaC1IV/ti3MBVGLXwjQtB3jSB3RTa?=
 =?us-ascii?Q?nsEzAjuq0wSVQbPRlEeZNb3kp072RsKiknYLt37aP8BOLswKRhI/J9DFoCZJ?=
 =?us-ascii?Q?ZVMxVda/j2x8DGwgJWgmhDzGh+476olRmj8pu/qKpCNLaGB/LeE4sX4NsCLI?=
 =?us-ascii?Q?Y5SAuUlJ0FqNVf+340UP/CgLDPCAwfKYywjtjJtrUAPbtXcmXlrlOgVIYlOV?=
 =?us-ascii?Q?mtjP92HOuCCj81XDkk49jJ1zGz030Gi/VKSR7iAODQQuqniNAU8KuSuyoFCS?=
 =?us-ascii?Q?SZQ5EfTVgyNc9KYomA2GSh4uWQt6K7rTfu0tMC3Sf0F0q+XkX3LfYgKOcTDZ?=
 =?us-ascii?Q?ORA6UYW+pRfNHg/k/zpVXCDuQ4Dj0MNYghE/d617c8hWXa1Kj6GZQVX4HVZA?=
 =?us-ascii?Q?lKYS9sqrIwX0H8ulfKeFfYWjZXuGteXrAhkz7iAy5ZlJozZrhpYwPTExBzn0?=
 =?us-ascii?Q?paET5Lq9GgpUs9+NNkFWYSpl/IwapEWgRlcjlfch?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd23c9e6-7604-4e23-0e5f-08db5c2ef667
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 May 2023 08:14:57.4919
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9LCT1BzjnNzoMiqMm1i2UbM77ByT+6dKeZM33pT6gkdvZib6XAxLJSllCjeA5+6BxARUd6KKQVDsGhV6O3DibA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6922
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alex,

I've two new patches to address the comment in this patch. If
it makes sense then I'll put them in cdev v12.

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Tuesday, May 23, 2023 10:13 AM
>
> > From: Alex Williamson <alex.williamson@redhat.com>
> > Sent: Tuesday, May 23, 2023 7:04 AM
> >
> > On Sat, 13 May 2023 06:28:25 -0700
> > Yi Liu <yi.l.liu@intel.com> wrote:
> >
> > > This is to make the cdev path and group path consistent for the noiom=
mu
> > > devices registration. If vfio_noiommu is disabled, such registration
> > > should fail. However, this check is vfio_device_set_group() which is =
part
> > > of the vfio_group code. If the vfio_group code is compiled out, noiom=
mu
> > > devices would be registered even vfio_noiommu is disabled.
> > >
> > > This adds vfio_device_set_noiommu() which can fail and calls it in th=
e
> > > device registration. For now, it never fails as long as
> > > vfio_device_set_group() is successful. But when the vfio_group code i=
s
> > > compiled out, vfio_device_set_noiommu() would fail the noiommu device=
s
> > > when vfio_noiommu is disabled.
> >
> > I'm lost.  After the next patch we end up with the following when
> > CONFIG_VFIO_GROUP is set:
> >
> > static inline int vfio_device_set_noiommu(struct vfio_device *device)
> > {
> >         device->noiommu =3D IS_ENABLED(CONFIG_VFIO_NOIOMMU) &&
> >                           device->group->type =3D=3D VFIO_NO_IOMMU;
> >         return 0;
> > }
> >
> > I think this is relying on the fact that vfio_device_set_group() which
> > is called immediately prior to this function would have performed the
> > testing for noiommu and failed prior to this function being called and
> > therefore there is no error return here.
>=20
> Yes.

Remove the IS_ENABLED(CONFIG_VFIO_NOIOMMU) check:

From 3e93d33dc426350389a89130557a212cf370fee6 Mon Sep 17 00:00:00 2001
From: Yi Liu <yi.l.liu@intel.com>
Date: Tue, 23 May 2023 20:48:08 -0700
Subject: [PATCH 19/23] vfio: Only check group->type for noiommu test

group->type can be VFIO_NO_IOMMU only when vfio_noiommu option is true.
And vfio_noiommu option can only be true if CONFIG_VFIO_NOIOMMU is enabled.
So checking group->type is enough when testing noiommu.

Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/vfio/group.c | 3 +--
 drivers/vfio/vfio.h  | 3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/vfio/group.c b/drivers/vfio/group.c
index c930406cc261..3b56959fcdbb 100644
--- a/drivers/vfio/group.c
+++ b/drivers/vfio/group.c
@@ -133,8 +133,7 @@ static int vfio_group_ioctl_set_container(struct vfio_g=
roup *group,
=20
 	iommufd =3D iommufd_ctx_from_file(f.file);
 	if (!IS_ERR(iommufd)) {
-		if (IS_ENABLED(CONFIG_VFIO_NOIOMMU) &&
-		    group->type =3D=3D VFIO_NO_IOMMU)
+		if (group->type =3D=3D VFIO_NO_IOMMU)
 			ret =3D iommufd_vfio_compat_set_no_iommu(iommufd);
 		else
 			ret =3D iommufd_vfio_compat_ioas_create(iommufd);
diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
index 0f66d0934e91..104c2ee93833 100644
--- a/drivers/vfio/vfio.h
+++ b/drivers/vfio/vfio.h
@@ -108,8 +108,7 @@ void vfio_group_cleanup(void);
=20
 static inline bool vfio_device_is_noiommu(struct vfio_device *vdev)
 {
-	return IS_ENABLED(CONFIG_VFIO_NOIOMMU) &&
-	       vdev->group->type =3D=3D VFIO_NO_IOMMU;
+	return vdev->group->type =3D=3D VFIO_NO_IOMMU;
 }
=20
 #if IS_ENABLED(CONFIG_VFIO_CONTAINER)
--=20
2.34.1

> >
> > Note also here that I think CONFIG_VFIO_NOIOMMU was only being tested
> > here previously so that a smart enough compiler would optimize out the
> > entire function, we can never set a VFIO_NO_IOMMU type when
> > !CONFIG_VFIO_NOIOMMU.
>=20
> You are right. VFIO_NO_IOMMU type is only set when vfio_noiommu=3D=3Dtrue=
.
>=20
> > That's no longer the case if the function is
> > refactored like this.
> >
> > When !CONFIG_VFIO_GROUP:
> >
> > static inline int vfio_device_set_noiommu(struct vfio_device *device)
> > {
> >         struct iommu_group *iommu_group;
> >
> >         iommu_group =3D iommu_group_get(device->dev);
> >         if (!iommu_group) {
> >                 if (!IS_ENABLED(CONFIG_VFIO_NOIOMMU) || !vfio_noiommu)
> >                         return -EINVAL;
> >                 device->noiommu =3D true;
> >         } else {
> >                 iommu_group_put(iommu_group);
> >                 device->noiommu =3D false;
> >         }
> >
> >         return 0;
> > }
> >
> > Here again, the NOIOMMU config option is irrelevant, vfio_noiommu can
> > only be true if the config option is enabled.  Therefore if there's no
> > IOMMU group and the module option to enable noiommu is not set, return
> > an error.
>=20
> Yes. I think I missed the part that the vfio_noiommu option can only be
> true when CONFIG_VFIO_NOIOMMU is enabled. That's why the check
> is "IS_ENABLED(CONFIG_VFIO_NOIOMMU) && device->group->type =3D=3D
> VFIO_NO_IOMMU;".
> This appears that the two conditions are orthogonal.
>=20
> >
> > It's really quite ugly that in one mode we rely on this function to
> > generate the error and in the other mode it happens prior to getting
> > here.
> >
> > The above could be simplified to something like:
> >
> > 	iommu_group =3D iommu_group_get(device->dev);
> > 	if (!iommu_group && !vfio_iommu)
> > 		return -EINVAL;
> >
> > 	device->noiommu =3D !iommu_group;
> > 	iommu_group_put(iommu_group); /* Accepts NULL */
> > 	return 0;
> >
> > Which would actually work regardless of CONFIG_VFIO_GROUP, where maybe
> > this could then be moved before vfio_device_set_group() and become the
> > de facto exit point for invalid noiommu configurations and maybe we
> > could remove the test from the group code (with a comment to note that
> > it's been tested prior)?  Thanks,
>=20
> Yes, this looks much clearer. I think this new logic must be called befor=
e
> vfio_device_set_group(). Otherwise,  iommu_group_get () may return
> the faked groups. Then it would need to work differently per CONFIG_VFIO_=
GROUP
> configuration.

Below patch adopts your suggestion on noiommu determination.
It also moves the noiommu taint in vfio_device_set_noiommu().

From 757a168acca7e94beec4448fba4600155569d823 Mon Sep 17 00:00:00 2001
From: Yi Liu <yi.l.liu@intel.com>
Date: Tue, 9 May 2023 01:55:28 -0700
Subject: [PATCH 20/23] vfio: Determine noiommu device in __vfio_register_de=
v()

This moves the noiommu device determination and noiommu taint out of
vfio_group_find_or_alloc().

This is also helpful for compiling out vfio_group infrastructure when
vfio device cdev is added as noiommu determination is common between
the cdev path and group path.

Suggested-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/vfio/group.c     | 18 +++---------------
 drivers/vfio/vfio_main.c | 25 +++++++++++++++++++++++++
 include/linux/vfio.h     |  1 +
 3 files changed, 29 insertions(+), 15 deletions(-)

diff --git a/drivers/vfio/group.c b/drivers/vfio/group.c
index 3b56959fcdbb..9ee6e70531d3 100644
--- a/drivers/vfio/group.c
+++ b/drivers/vfio/group.c
@@ -670,21 +670,6 @@ static struct vfio_group *vfio_group_find_or_alloc(str=
uct device *dev)
 	struct vfio_group *group;
=20
 	iommu_group =3D iommu_group_get(dev);
-	if (!iommu_group && vfio_noiommu) {
-		/*
-		 * With noiommu enabled, create an IOMMU group for devices that
-		 * don't already have one, implying no IOMMU hardware/driver
-		 * exists.  Taint the kernel because we're about to give a DMA
-		 * capable device to a user without IOMMU protection.
-		 */
-		group =3D vfio_noiommu_group_alloc(dev, VFIO_NO_IOMMU);
-		if (!IS_ERR(group)) {
-			add_taint(TAINT_USER, LOCKDEP_STILL_OK);
-			dev_warn(dev, "Adding kernel taint for vfio-noiommu group on device\n")=
;
-		}
-		return group;
-	}
-
 	if (!iommu_group)
 		return ERR_PTR(-EINVAL);
=20
@@ -720,6 +705,9 @@ int vfio_device_set_group(struct vfio_device *device,
 {
 	struct vfio_group *group;
=20
+	if (device->noiommu)
+		type =3D VFIO_NO_IOMMU;
+
 	if (type =3D=3D VFIO_IOMMU)
 		group =3D vfio_group_find_or_alloc(device->dev);
 	else
diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 20f463088e71..da46e2e74642 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -266,6 +266,18 @@ static int vfio_init_device(struct vfio_device *device=
, struct device *dev,
 	return ret;
 }
=20
+static int vfio_device_set_noiommu(struct vfio_device *device)
+{
+	struct iommu_group *iommu_group =3D iommu_group_get(device->dev);
+
+	if (!iommu_group && !vfio_noiommu)
+		return -EINVAL;
+
+	device->noiommu =3D !iommu_group;
+	iommu_group_put(iommu_group); /* Accepts NULL */
+	return 0;
+}
+
 static int __vfio_register_dev(struct vfio_device *device,
 			       enum vfio_group_type type)
 {
@@ -285,6 +297,10 @@ static int __vfio_register_dev(struct vfio_device *dev=
ice,
 	if (!device->dev_set)
 		vfio_assign_device_set(device, device);
=20
+	ret =3D vfio_device_set_noiommu(device);
+	if (ret)
+		return ret;
+
 	ret =3D vfio_device_set_group(device, type);
 	if (ret)
 		return ret;
@@ -303,6 +319,15 @@ static int __vfio_register_dev(struct vfio_device *dev=
ice,
=20
 	vfio_device_group_register(device);
=20
+	if (device->noiommu) {
+		/*
+		 * noiommu deivces have no IOMMU hardware/driver.  Taint the
+		 * kernel because we're about to give a DMA capable device to
+		 * a user without IOMMU protection.
+		 */
+		add_taint(TAINT_USER, LOCKDEP_STILL_OK);
+		dev_warn(device->dev, "Adding kernel taint for vfio-noiommu on device\n"=
);
+	}
 	return 0;
 err_out:
 	vfio_device_remove_group(device);
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index e80a8ac86e46..183e620009e7 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -67,6 +67,7 @@ struct vfio_device {
 	bool iommufd_attached;
 #endif
 	bool cdev_opened:1;
+	bool noiommu:1;
 };
=20
 /**
--=20
2.34.1

