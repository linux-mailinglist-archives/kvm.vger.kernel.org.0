Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0BA86D2F47
	for <lists+kvm@lfdr.de>; Sat,  1 Apr 2023 11:15:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229745AbjDAJPo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 1 Apr 2023 05:15:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbjDAJPm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 1 Apr 2023 05:15:42 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A21D4695;
        Sat,  1 Apr 2023 02:15:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680340541; x=1711876541;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=LQA09Ea00vL9oGeUQiYncABZWlGa/CakVdxv1yNf6Z0=;
  b=nBRTXv/3/pZGtAmrU59nQuMrW+vBStHpNqu4zWWn19MMgbbEKSXlwO+I
   CEv5mvK4RPCVMrh6F8PQpNXjtv701u4qUmOwty2pwLL/IpEFUxjYQMJGT
   ytc1RlXX0bTfJRePV7zoURU9QjnwjM4tE7tZkYoxhwEcQvxMQHQVgwuAi
   Ss9dw5kJjHTYGHzn9q9gspNEv6eGT5DXNivJOzBmsKc/LZMW/P2S7oaNM
   89p8k/iqvxssJClmzZMLFdalnxdj64ttAY8KeQxbxadexGYrHALDkrb0I
   wbuxEzzpk4LxKhkxmAkVmpeVk6B4P04AD/ZMrevfirliHoJCI9K1BbRTl
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10666"; a="322023249"
X-IronPort-AV: E=Sophos;i="5.98,310,1673942400"; 
   d="scan'208";a="322023249"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2023 02:15:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10666"; a="809299618"
X-IronPort-AV: E=Sophos;i="5.98,310,1673942400"; 
   d="scan'208";a="809299618"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga004.jf.intel.com with ESMTP; 01 Apr 2023 02:15:40 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Sat, 1 Apr 2023 02:15:40 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Sat, 1 Apr 2023 02:15:39 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Sat, 1 Apr 2023 02:15:39 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.43) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Sat, 1 Apr 2023 02:15:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EDo9tADLfdBgK5XQnepPsA0ku3eYSn0flm5f/+Evn0JZcotIoGVj4pCmKPnkuQInhcSdsqvBSpp5e8IE+PeTftPjBtAaw9QdJHXBAh5B9E0V9ScltVs/mPvHoeoUOs8VYsV1iHE6w+cm6twWQ+nbVneSpXySbNeJFRC8Bf23MRkFo8G5OgOjAL1G9Uie9NIp5lWQNoGS7AVMCbCIZqZiduRv3U2nG41r6k4pITB3wY7Yl4Zjvzt6hxM/qJshR0va/4cQIKatHFB1GSL/cwuaws8q1+KSGRdiZo5TGLSt+MXRfeIsGK95Xmmu4uqAfvhelE6o4y0Waj28mHSurqJocg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/jcUfL+4ybovqZ9tJLz3T7uNfvH+KTwj6F1PH+OGXac=;
 b=IkHWQ7BjT7glvbe1J6470RUK94kk5py5XJabjG9vMIQ2rhM3x15wW852iaA4VTy7hdad5gQhJZQFXKhD0uCMPyXczrOZQLaMkXrK5xn+42bDdjC0L0lHfvfFc8+yDajtGkup+PgdgOaBWiOA37EA0CjIs3RAp56ZqvO9N69053EuSl1FnkHGOmy5QXgfxQ/TxmSLrZ+wAEO7L0UJUrnLGJHhNp4vgHQKpclWWkolesa/vP2lqueg/vxelphXCzNgIjKVsOOgkzWoGeFObEzJMTZR4oITEnYRCbirOP2U01SFy+JFSyVXtfwzba0vAqZ44XzMaip4bUHXr+w00qlcpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL3PR11MB6483.namprd11.prod.outlook.com (2603:10b6:208:3be::13)
 by DM4PR11MB5487.namprd11.prod.outlook.com (2603:10b6:5:39f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.26; Sat, 1 Apr
 2023 09:15:34 +0000
Received: from BL3PR11MB6483.namprd11.prod.outlook.com
 ([fe80::15a1:856b:dd83:f4cd]) by BL3PR11MB6483.namprd11.prod.outlook.com
 ([fe80::15a1:856b:dd83:f4cd%7]) with mapi id 15.20.6254.026; Sat, 1 Apr 2023
 09:15:34 +0000
From:   "Xu, Terrence" <terrence.xu@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "Jiang, Yanting" <yanting.jiang@intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>
Subject: RE: [PATCH v2 00/10] Introduce new methods for verifying ownership in
 vfio PCI hot reset
Thread-Topic: [PATCH v2 00/10] Introduce new methods for verifying ownership
 in vfio PCI hot reset
Thread-Index: AQHZYI9oWImAx545D0iJr2HHlwsM2K8VKfOAgAAHToCAAQEo0A==
Date:   Sat, 1 Apr 2023 09:15:33 +0000
Message-ID: <BL3PR11MB64830DBAD5C83E48809293B4F08C9@BL3PR11MB6483.namprd11.prod.outlook.com>
References: <20230327093458.44939-1-yi.l.liu@intel.com>
 <BL3PR11MB64830DC9AC0517B56667532DF08F9@BL3PR11MB6483.namprd11.prod.outlook.com>
 <20230331114949.3dfec232.alex.williamson@redhat.com>
In-Reply-To: <20230331114949.3dfec232.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL3PR11MB6483:EE_|DM4PR11MB5487:EE_
x-ms-office365-filtering-correlation-id: 9b73c29f-b738-46d4-a30e-08db3291a5fb
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: eHp2yd7N5swFlyQR3jZCD62MjOvrmMSbQsR5CrWcL9nXnlvmWkRjnE7RtV2IeHHYqqjezGbP25rYMN5u33Psl9u0Qh1ikAAMTuR+Yb7OwUqk3uZMKMoSiOGBnj+r6u+wDGe3IATkvJOfvjABMhzILVNnEpmYayTXHbzeKlhn9XD2xAEru/6vnamGMN33aenpzerNSm3pxJM49dOEMBbqm6lcDORr2hinFJA5Up+B8DgMFbqj4eNH38quv5FjTfvoq8BBS1XDLqjglaqYQc3kBwuBmDDllN8wWeocLpviE8OBwXn+ZX3gNO6kmY17rCLUnSPRUYtGlaG6imBzwWv0YZbacoOPQWGEFVR/alJs9n7/eWhlyp/6okCwNeaEeHJ+p2otRlqigS3PBTRUpK0kIGGxpoi7rJimLSR/i+LGUjKfXSnxJLR+piPYZYhsv4ozPeG1tYHnL4MM5BD4n5Q/x0YTKJ++buTHNOofsZOQH+w0C37k4vliMDe1Z/TaJlHsEAF58k9EqXreU9T2sIZO+QQI0uRULsYulnVQ6I4HPaJqEdx6ew2ODfH3pBv7t/GsB7ihEFEEPHQkQrfdxjyJPbxbn+SyMdc3VAyEf10AnG/Drs5dA3WK4t51CTKofeWi6PkLkKV2B+dxmnkQUKGufA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR11MB6483.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(346002)(366004)(39860400002)(396003)(376002)(451199021)(26005)(9686003)(6506007)(86362001)(76116006)(66556008)(66946007)(4326008)(66476007)(66446008)(64756008)(6916009)(8676002)(186003)(71200400001)(45080400002)(966005)(7696005)(316002)(54906003)(478600001)(55016003)(33656002)(15650500001)(8936002)(52536014)(38100700002)(122000001)(38070700005)(5660300002)(7416002)(2906002)(82960400001)(83380400001)(41300700001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ZbEly2KwDzjpysyIXRm50eocV4LtuQVNZM2XasiqGLZeYLWmOfS534TX6UMh?=
 =?us-ascii?Q?WMDygd2cIm0SmWY+JeiA6VZgPzCKl0ekfCFqshgxrdDy57lKz3JsyE1jQ+n7?=
 =?us-ascii?Q?IbZL+ZSlyWDA5r5Btr2oZjPQizvLKn87mdRQRCJqltCY9rvJt8rN5VhZvh/f?=
 =?us-ascii?Q?QsVd/sE0iv0h86iT+IcSXZx+pu7KltcVwlmSjNfhlROX/9FrmULjEY1TDlju?=
 =?us-ascii?Q?yywLuTorv1Pz6XR80X5HIRdjOGpDXNfYiCGggHNKK3khohiDyTc2WGJ0ln3u?=
 =?us-ascii?Q?ZLtPgEv7/slkSjE+1Gkr8YbHG6cUyboc4iWRy9qjrFZqiRHwkzdQLr5Uu1sR?=
 =?us-ascii?Q?tpNJgiR/8C3q1cFLJ8kdmH//rYn1lbw4fjQTXedB8vr9ei7u/0tRouNn+OcH?=
 =?us-ascii?Q?xley2jv5MbkF+oWT6jbQ64s+2JP5nP9RRrfQvo5lstD0QzmpsmFOHw1vredy?=
 =?us-ascii?Q?zKym1yYBHBSjzRT+qlXccuh8fD+YMJvFrJBRBeqYQosIItWFD5DTpvqBGbMy?=
 =?us-ascii?Q?a+CRkKfLZ2mk3DR+CCbH3He5DSTkOSYM+OA6/bHIeQWmIaYgKlbc5Ofivhf1?=
 =?us-ascii?Q?htPwhsQYPKfb6aUC2dUvzs05OHXlEfJGi4lWVvYBRpoxRJEKG4eFHGev8v0r?=
 =?us-ascii?Q?4MprTwvwPUienVFaJ2NCAtYHcCCJ8pRnqd1zM32Ti41J3M7TfpesB2DU4BP0?=
 =?us-ascii?Q?PNs+boaMuqzmGdHSp0ClfDF+dWH/T7nuhiVA9eYdvxUhTQ/OaHHlaZaA8OTx?=
 =?us-ascii?Q?pVE1lajX/cHCeBy2r7fVwJc8fDott0u97uZvIGekuhPhkAiEoVDbDg8nkE4T?=
 =?us-ascii?Q?Kvz058E2nv/b5trQKkrkNFG+M49EyCEhxnWDxskpQq77LoOXrFFWIZGpf+q9?=
 =?us-ascii?Q?vT7X4Af9AW60O4mLf6R5RkJaPkgHZxAMeATBXxq128hH2a+bgzdDCmjX9EHh?=
 =?us-ascii?Q?R4eaKealhCTaGxi83AGJBUACgwrwd6mUQYtTx8zAAvaQvrC0pEVue7eS6m8t?=
 =?us-ascii?Q?PdzwskmkdQ/x5eQj4+f6/HJ7MaEkMtcbABRrGiRKz0t/Tooinyt5HlU1Zc/M?=
 =?us-ascii?Q?zhBi+/zklUdwoeuHCwLYjw3iZTORAYW8Q0nlFMJtH4Fz2uPxqlUt6SA9QFQd?=
 =?us-ascii?Q?kc3jEb1xNtuadoLn6/8DZcomlMiovX8mePCBehrx2c/+B/3f+EOEgIQBnpI9?=
 =?us-ascii?Q?L7+ZnoXAu651aaVDz023xs1FQVLDzISMBklNZT5BH7eLQv6Kv+crMOYjK6Cc?=
 =?us-ascii?Q?yOG0745h8ynwqQWu4IjAlNj0OPJYIDcCmDGWSUDVSasaggn13SuG6KOvAuWo?=
 =?us-ascii?Q?scMOIhbvD773GGIDfTr91vKgS2eEN7MtYZMXWC0gG5Z2R3D2KZajRMMcj2KQ?=
 =?us-ascii?Q?8l9CFqleSAMx6lSxhYWwIvT7jo/g+AIrcxLuGUdk8mwNFxmqZ9i9XMJB+8nB?=
 =?us-ascii?Q?u0jjlwchZVjMXmUM+SBwp+YDF2H4jQDBKdJlTSykgKWlR4ARLWykNDgYYiH2?=
 =?us-ascii?Q?/HO++qAroQ9a8nsuw8n5I0T8RCGgUaZ762EL0BPh9CzLYgZ91LSejs0+hxxR?=
 =?us-ascii?Q?tgzqWF9IZScABkmTab2jHsBVA0nOSQ+yJE7K6ECa?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL3PR11MB6483.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b73c29f-b738-46d4-a30e-08db3291a5fb
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Apr 2023 09:15:33.9277
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +P5Vw7moFMIBKUA52SQUS6O1AJYF4ChrN+lW3SJgKfLhPgOgQNdpaBwM0z3OQxOy227w+ZT01rDRpA1seEGsEA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5487
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


> -----Original Message-----
> From: intel-gvt-dev <intel-gvt-dev-bounces@lists.freedesktop.org> On
> Behalf Of Alex Williamson
> Sent: Saturday, April 1, 2023 1:50 AM
>=20
> On Fri, 31 Mar 2023 17:27:27 +0000
> "Xu, Terrence" <terrence.xu@intel.com> wrote:
>=20
> > > -----Original Message-----
> > > From: Liu, Yi L <yi.l.liu@intel.com>
> > > Sent: Monday, March 27, 2023 5:35 PM
> > >
> > > VFIO_DEVICE_PCI_HOT_RESET requires user to pass an array of group
> > > fds to prove that it owns all devices affected by resetting the
> > > calling device. This series introduces several extensions to allow
> > > the ownership check better aligned with iommufd and coming vfio devic=
e
> cdev support.
> > >
> > > First, resetting an unopened device is always safe given nobody is
> > > using it. So relax the check to allow such devices not covered by
> > > group fd array. [1]
> > >
> > > When iommufd is used we can simply verify that all affected devices
> > > are bound to a same iommufd then no need for the user to provide
> > > extra fd information. This is enabled by the user passing a
> > > zero-length fd array and moving forward this should be the preferred
> > > way for hot reset. [2]
> > >
> > > However the iommufd method has difficulty working with noiommu
> > > devices since those devices don't have a valid iommufd, unless the
> > > noiommu device is in a singleton dev_set hence no ownership check is
> > > required. [3]
> > >
> > > For noiommu backward compatibility a 3rd method is introduced by
> > > allowing the user to pass an array of device fds to prove ownership.
> > > [4]
> > >
> > > As suggested by Jason [5], we have this series to introduce the
> > > above stuffs to the vfio PCI hot reset. Per the dicussion in [6],
> > > this series also adds a new _INFO ioctl to get hot reset scope for gi=
ven
> device.
> > >
> > > [1] https://lore.kernel.org/kvm/Y%2FdobS6gdSkxnPH7@nvidia.com/
> > > [2] https://lore.kernel.org/kvm/Y%2FZOOClu8nXy2toX@nvidia.com/#t
> > > [3] https://lore.kernel.org/kvm/ZACX+Np%2FIY7ygqL5@nvidia.com/
> > > [4]
> > >
> https://lore.kernel.org/kvm/DS0PR11MB7529BE88460582BD599DC1F7C3B19
> > > @DS0PR11MB7529.namprd11.prod.outlook.com/#t
> > > [5] https://lore.kernel.org/kvm/ZAcvzvhkt9QhCmdi@nvidia.com/
> > > [6] https://lore.kernel.org/kvm/ZBoYgNq60eDpV9Un@nvidia.com/
> > >
> > > Change log:
> > >
> > > v2:
> > >  - Split the patch 03 of v1 to be 03, 04 and 05 of v2 (Jaon)
> > >  - Add r-b from Kevin and Jason
> > >  - Add patch 10 to introduce a new _INFO ioctl for the usage of devic=
e
> > >    fd passing usage in cdev path (Jason, Alex)
> > >
> > > v1:
> > > https://lore.kernel.org/kvm/20230316124156.12064-1-yi.l.liu@intel.co
> > > m/
> > >
> > > Regards,
> > > 	Yi Liu
> > >
> > > Yi Liu (10):
> > >   vfio/pci: Update comment around group_fd get in
> > >     vfio_pci_ioctl_pci_hot_reset()
> > >   vfio/pci: Only check ownership of opened devices in hot reset
> > >   vfio/pci: Move the existing hot reset logic to be a helper
> > >   vfio-iommufd: Add helper to retrieve iommufd_ctx and devid for
> > >     vfio_device
> > >   vfio/pci: Allow passing zero-length fd array in
> > >     VFIO_DEVICE_PCI_HOT_RESET
> > >   vfio: Refine vfio file kAPIs for vfio PCI hot reset
> > >   vfio: Accpet device file from vfio PCI hot reset path
> > >   vfio/pci: Renaming for accepting device fd in hot reset path
> > >   vfio/pci: Accept device fd in VFIO_DEVICE_PCI_HOT_RESET ioctl
> > >   vfio/pci: Add VFIO_DEVICE_GET_PCI_HOT_RESET_GROUP_INFO
> > >
> > >  drivers/iommu/iommufd/device.c   |  12 ++
> > >  drivers/vfio/group.c             |  32 ++--
> > >  drivers/vfio/iommufd.c           |  16 ++
> > >  drivers/vfio/pci/vfio_pci_core.c | 244 ++++++++++++++++++++++++----
> ---
> > >  drivers/vfio/vfio.h              |   2 +
> > >  drivers/vfio/vfio_main.c         |  44 ++++++
> > >  include/linux/iommufd.h          |   3 +
> > >  include/linux/vfio.h             |  14 ++
> > >  include/uapi/linux/vfio.h        |  65 +++++++-
> > >  9 files changed, 364 insertions(+), 68 deletions(-)
> > >
> > > --
> > > 2.34.1
> >
> > Verified this series by "Intel GVT-g GPU device mediated passthrough".
> > Passed VFIO legacy mode / compat mode / cdev mode basic functionality
> and GPU force reset test.
> >
> > Tested-by: Terrence Xu <terrence.xu@intel.com>
>=20
> Seems like only this "GPU force reset test" is relevant to the new
> functionality of this series, GVT-g does not and has no reason to support=
 the
> HOT_RESET ioctls used here.  Can you provide more details of the force-re=
set
> test?  What userspace driver is being used?  Thanks,
>=20
> Alex
Hi Alex, about the "GPU force reset test", I used the "i915_hangman" test f=
rom intel-gpu-tools, it is for GPU force hang / reset.=20
It is an important regression test scenario for this patch series.=20
To test the HOT_RESET ioctls itself, need to wait the corresponding Qemu ch=
anges from Yi.

