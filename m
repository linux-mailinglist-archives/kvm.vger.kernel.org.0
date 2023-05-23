Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF1C770D0E0
	for <lists+kvm@lfdr.de>; Tue, 23 May 2023 04:13:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232633AbjEWCNO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 May 2023 22:13:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbjEWCNL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 May 2023 22:13:11 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A114CA;
        Mon, 22 May 2023 19:13:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684807989; x=1716343989;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Y0MahA8UpYD2fJFI1cqqlFMQR1W/MMj6yNVzgEiRCe8=;
  b=bCLfA+Sjjb4ff0AYPDHmWte3R0WNSI648zsYh4Y8g3YBVFxLndJ8a+/v
   hjcbo1bHj6XGQNmzhJqVpNEPc71PehTv2Zfmi4E4jQ+NgCGVKhQzKaX8G
   2T9GdICtrxGLCzGQF76CLJ8Rm8lQMonOm47TEGJbn0RlgH+2C+t/esneV
   RpmziA9/B8XuGIh+ASrDgqjlVzGag7VrC3KQlIs7xDufdLVOoLzpR6By4
   GSpkHiFOIIB43+8zViUSh8B1AyjJCNwrlZI2cL9VQLc4aizkWe3xnKRSj
   3+kS8upQcZ3Ue0+0+EDcHBE2uioZ+Zrlt2TNwAb0cPqqiHxBX8eHtBl58
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10718"; a="439455436"
X-IronPort-AV: E=Sophos;i="6.00,185,1681196400"; 
   d="scan'208";a="439455436"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2023 19:13:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10718"; a="706780110"
X-IronPort-AV: E=Sophos;i="6.00,185,1681196400"; 
   d="scan'208";a="706780110"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga007.fm.intel.com with ESMTP; 22 May 2023 19:13:08 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 22 May 2023 19:13:08 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 22 May 2023 19:13:08 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 22 May 2023 19:13:08 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.42) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 22 May 2023 19:13:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TS9YBaEo3NBFzksoQM/YsLOe6Ux9bZcvtm84RsuFHzoP7K+jKfn0M6NUuuLeGoInPPXqC6NlzZ0UEBZ87bqxO/ta99UAvi4FrnT+WdmK6luugC0M0PkdPsTK/ARSTBbmBnn3ujm+DXB7/Xp2XUJ/CyZMSwoHimizdRZ7v3wMnBhp/QPiGVINc5j/JVGZ9K6PSurus7AnmqZg92eDAQYniZWlJkZarO0hQpbYgSNSR1rifq7TEBI01jhaGARvWqVJ14jkhct7kfUvC6TNr8zImlVe9AtswPOLQYk+E0Ued8pKSibY0h6CnBi6Y2lToNeHiQ2YFqHwL650W9O1AW0rZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R/Mxhpran92ASSoz1FEt5OKoHRVjATf2424R5SmkZQU=;
 b=HVBqsKZpIUN3YdKLoqB+JTSmn0Y340lcREtcENYp9PSp60xiLtvJO5+adbOwKHrzNKmxrxCGlqTtUExK9kwtx5FBI3dih04sXrTYGgvNAIBfdeMOCHlO/6qB7BllGLfmrc/LVFmUzrt496uBjH/LjRDiiAoADWRNbKzAz0850HhomQh9K9UQoseVERhYTsjZZxhK3Ye9ejbgzPPQYx9BB94qTKmloI3JV0pww83ukNsHupkBhX05Vu4iPz3MwhLcAwy1M457LA2Pc/IaMfd0Ruz5+9qZgtkXyvKVof7KWqZ6bHCztaar3FMsNomFOq9lroBArXTLcXFXfADRfUj/zQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by IA1PR11MB7871.namprd11.prod.outlook.com (2603:10b6:208:3f5::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Tue, 23 May
 2023 02:13:04 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::5b44:8f52:dbeb:18e5]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::5b44:8f52:dbeb:18e5%3]) with mapi id 15.20.6411.028; Tue, 23 May 2023
 02:13:04 +0000
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
Thread-Index: AQHZhZ7jRzQlMHxxuUqS1TLfTxm1l69m+EiAgAAswHA=
Date:   Tue, 23 May 2023 02:13:03 +0000
Message-ID: <DS0PR11MB752991A93B0B4603E7F501B5C3409@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230513132827.39066-1-yi.l.liu@intel.com>
        <20230513132827.39066-22-yi.l.liu@intel.com>
 <20230522170429.2d5ca274.alex.williamson@redhat.com>
In-Reply-To: <20230522170429.2d5ca274.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|IA1PR11MB7871:EE_
x-ms-office365-filtering-correlation-id: aeea0477-c3c0-4d65-3687-08db5b333d73
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TLKFYUykOlNIKuel4qbEGXbfqj9HzLwEWfNM/Q/64zQFH5xneYyWSYczP5q0aEdQmshNNrrkwMt24K/sMJGTVBe/823WwfBA5X/7gcYe/KShVYGVIgGP1p3Shpq/GOOOAc8Gwn4Hb9qb6Ul+ZjE+zyuxMSWwKAMyYG3mgNr7K4auy5YDJMWr4SjOOHDqVDu7HGGe4o+UgG3JeGvMLP5qH+kai/jxUn0XIv7gBa8ZvTVMCUx5TjJJMPecEEKYwVI+9zSINxcxo/7ehIX17jWlYfly8Lj1VsCLB1ZqLrAaPTt+JbB5AD/1eZyu6mYX7I+DjUnwUVsK+GobPaMvu4nagyP0/hY//02RN3+9YJLIyhUmJGC+/2n+ZVrDDl1GldxtnrmfBi0ASTL34S54xgW24v2/iZV7L4B3zL5MagH16Ry2LId2/d3KCZDl3zqv4WpR78x7o/Xy8f/eN77jNXxImOBMOGkcaeZuLFJVEhlp8+bNU2mlBJ6mib8QyDdvP93hag5sggSbuoNJMXMgEUdojgKfWYD3MX1hV4wytjrqgnXuhvl6XQxHLHB/MI5wzd8AYr/OYlVPuflX22RJUIOLKdFk8JqDVaGFrAXL0yBandIs+zxUP2kGClKc1lLlDxWLnHYT63tunbpdCk+akkjvIQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(39860400002)(346002)(136003)(366004)(376002)(451199021)(9686003)(6506007)(26005)(186003)(83380400001)(7696005)(2906002)(71200400001)(5660300002)(316002)(55016003)(54906003)(478600001)(33656002)(66946007)(66446008)(66476007)(64756008)(52536014)(86362001)(6916009)(38100700002)(4326008)(66556008)(8936002)(41300700001)(38070700005)(8676002)(76116006)(82960400001)(122000001)(7416002)(13296009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?IhQ2p/cm5DWtP8h2/Kf4KP/xeuFRTqj0oOWgo1khopoFuEilg1cLpRk3ExFs?=
 =?us-ascii?Q?Ciw9hFOmMlP9ezR+ksMsWoDh3NZF96wviHEApPj7bGyuONk5h+R69uNP09Yj?=
 =?us-ascii?Q?OXndIEkmgfb7ApFjEB+xZZ+bJBxRw2l14UX75NHiIr9E4pIc13LqLmdG7ObE?=
 =?us-ascii?Q?GQEaYMGcYnIoW5N7gW81tso6r45LF+BabogqGZfwSjHqyEGn6YQ8FkA3ntT9?=
 =?us-ascii?Q?j+b2Wasi7Gh2TtRU/RqwQ7K/DB23W0fqD5hUKDOwT1KGWrHfoE3Cv5VD+xy8?=
 =?us-ascii?Q?jVo+ZSfl9vR3QFzdnxjjlZly5mycypp/wHIfgcjgFfSuJIct/EhWMyFyc4/I?=
 =?us-ascii?Q?eI+WY3TmLVYB3PntVEUPHdLcDNzLkvK/SyKYRkQVgHrwBQDZfgYajfWlbqhQ?=
 =?us-ascii?Q?vEM+FilcYzBaCh7L+BT2GKOcfmFVfkuw58lJvFKN+kMOxcnei8AwfXwooIUC?=
 =?us-ascii?Q?sWrEbCyusZqqsJna+Dmo7EXtyKE9IPEKDFVXS29n6/TvlrDaj4lGDZfvYHDf?=
 =?us-ascii?Q?e+ZWK/wBSsgH9mLmTJ2Bd2gnIIhGQbeu30KjPxMv4ud6CLno6zKAcYHDsuEB?=
 =?us-ascii?Q?IRnO69hkYwSHTuaSiT6Cl8NxPjRC5KNPjCY8rimuU8cQmaq+k4NC5ILDNeKQ?=
 =?us-ascii?Q?SbmJIyZy3R9bzBG4gRCBuYNzHan71A34kWtVLbq9fCLl0BfYFMyXjCYKfxKC?=
 =?us-ascii?Q?6dSZsKtTgJqKc6x0+r0+x+/zmX2VylEtjS5TCgaR2ZaCktUN21tka2DYYTk2?=
 =?us-ascii?Q?moFq9NHYGVZ7y3fk8m9gPEQ8e7YfCvzZzh0PLIG2lsjPld9oxxN+53hwyJ0w?=
 =?us-ascii?Q?HqPFtEybmW9CUERQvVAx7M2MMDR5nBLTZPAuLvSx1vROT2BiWAREEWgJ90la?=
 =?us-ascii?Q?5d47G4SYYxL7nZnHRYm2X2x5AI5i4PWt028W128vDOcjSqX8d4vt8scCu38c?=
 =?us-ascii?Q?RRXbbRqQiALxEidjFGGkNQIBehGNUexOL5pa0t+WabEycIa7KyhE7vvLZ//j?=
 =?us-ascii?Q?vrrHown6DS6sNYA5hOqMxBRWwfvjoW+CiXMR9zM5KVnew3kL8k/gDjGlucPv?=
 =?us-ascii?Q?C3F94xwZyKV5X4Qt9jrSZCT8V4wmW1cd0uGjRT+Q5tUcSq2pacWTBzi17XNg?=
 =?us-ascii?Q?NIZeS6Gy1/ga6/edMZA7DpBDMIDqCBS2M6c7TVpdsYs5Vg8kn+paBkxDOfo9?=
 =?us-ascii?Q?sNIXJLgTkrd5RKn5i7KMjM9pF6JjZ70HZf5X9cqHZAMTZO5mes+hzzr941Fz?=
 =?us-ascii?Q?Tm7YunfSbxVxZqp6hn67hcC+E9vSZoiJry8RY/xVS4K4mXih+y++HMM2uRGN?=
 =?us-ascii?Q?g4bS6jES17eRelo/Pt3YxMVRK1ECCero0uNKvKfZR7VGSA0QrLIW7XTyTP3T?=
 =?us-ascii?Q?RpEr5jFEnUOU5VfwxuSt5NUgmXR9O2/H/GPoEHDWn8aD4aI/GCZssISsuDar?=
 =?us-ascii?Q?qUiVYhNO91oyQYLuMPQzGfDrL4xPI8a0rHUkSi17zZtfQOlZHtYd65OXoqWb?=
 =?us-ascii?Q?0aeOlcJ51ttJHpc+UBaKtE1p1qgYm5XaVPG5PRP5gTkjNYAbWH+U5FoHqszN?=
 =?us-ascii?Q?PjVVzXJ9TRo0q3AZTHoM9OYDgDJOPWNKevBSikN1?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aeea0477-c3c0-4d65-3687-08db5b333d73
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 May 2023 02:13:03.5102
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ACm7PBCst9RyuyuU8C0CevcsCiP0Z35vtQb/BueeDv/XKu8Cn1nwJnwDxjaLs6g8QtcLvdBie1pF82nJ0HmqxQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7871
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Tuesday, May 23, 2023 7:04 AM
>=20
> On Sat, 13 May 2023 06:28:25 -0700
> Yi Liu <yi.l.liu@intel.com> wrote:
>=20
> > This is to make the cdev path and group path consistent for the noiommu
> > devices registration. If vfio_noiommu is disabled, such registration
> > should fail. However, this check is vfio_device_set_group() which is pa=
rt
> > of the vfio_group code. If the vfio_group code is compiled out, noiommu
> > devices would be registered even vfio_noiommu is disabled.
> >
> > This adds vfio_device_set_noiommu() which can fail and calls it in the
> > device registration. For now, it never fails as long as
> > vfio_device_set_group() is successful. But when the vfio_group code is
> > compiled out, vfio_device_set_noiommu() would fail the noiommu devices
> > when vfio_noiommu is disabled.
>=20
> I'm lost.  After the next patch we end up with the following when
> CONFIG_VFIO_GROUP is set:
>=20
> static inline int vfio_device_set_noiommu(struct vfio_device *device)
> {
>         device->noiommu =3D IS_ENABLED(CONFIG_VFIO_NOIOMMU) &&
>                           device->group->type =3D=3D VFIO_NO_IOMMU;
>         return 0;
> }
>=20
> I think this is relying on the fact that vfio_device_set_group() which
> is called immediately prior to this function would have performed the
> testing for noiommu and failed prior to this function being called and
> therefore there is no error return here.

Yes.

>=20
> Note also here that I think CONFIG_VFIO_NOIOMMU was only being tested
> here previously so that a smart enough compiler would optimize out the
> entire function, we can never set a VFIO_NO_IOMMU type when
> !CONFIG_VFIO_NOIOMMU.

You are right. VFIO_NO_IOMMU type is only set when vfio_noiommu=3D=3Dtrue.

> That's no longer the case if the function is
> refactored like this.
>=20
> When !CONFIG_VFIO_GROUP:
>=20
> static inline int vfio_device_set_noiommu(struct vfio_device *device)
> {
>         struct iommu_group *iommu_group;
>=20
>         iommu_group =3D iommu_group_get(device->dev);
>         if (!iommu_group) {
>                 if (!IS_ENABLED(CONFIG_VFIO_NOIOMMU) || !vfio_noiommu)
>                         return -EINVAL;
>                 device->noiommu =3D true;
>         } else {
>                 iommu_group_put(iommu_group);
>                 device->noiommu =3D false;
>         }
>=20
>         return 0;
> }
>=20
> Here again, the NOIOMMU config option is irrelevant, vfio_noiommu can
> only be true if the config option is enabled.  Therefore if there's no
> IOMMU group and the module option to enable noiommu is not set, return
> an error.

Yes. I think I missed the part that the vfio_noiommu option can only be
true when CONFIG_VFIO_NOIOMMU is enabled. That's why the check
is "IS_ENABLED(CONFIG_VFIO_NOIOMMU) && device->group->type =3D=3D VFIO_NO_I=
OMMU;".
This appears that the two conditions are orthogonal.

>=20
> It's really quite ugly that in one mode we rely on this function to
> generate the error and in the other mode it happens prior to getting
> here.
>=20
> The above could be simplified to something like:
>=20
> 	iommu_group =3D iommu_group_get(device->dev);
> 	if (!iommu_group && !vfio_iommu)
> 		return -EINVAL;
>=20
> 	device->noiommu =3D !iommu_group;
> 	iommu_group_put(iommu_group); /* Accepts NULL */
> 	return 0;
>=20
> Which would actually work regardless of CONFIG_VFIO_GROUP, where maybe
> this could then be moved before vfio_device_set_group() and become the
> de facto exit point for invalid noiommu configurations and maybe we
> could remove the test from the group code (with a comment to note that
> it's been tested prior)?  Thanks,

Yes, this looks much clearer. I think this new logic must be called before
vfio_device_set_group(). Otherwise,  iommu_group_get () may return
the faked groups. Then it would need to work differently per CONFIG_VFIO_GR=
OUP
configuration.

Regards,
Yi Liu
>=20
> > As noiommu devices is checked and there are multiple places which needs
> > to test noiommu devices, this also adds a flag to mark noiommu devices.
> > Hence the callers of vfio_device_is_noiommu() can be converted to test
> > vfio_device->noiommu.
> >
> > Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> > Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> > Tested-by: Yanting Jiang <yanting.jiang@intel.com>
> > Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> > ---
> >  drivers/vfio/device_cdev.c |  4 ++--
> >  drivers/vfio/group.c       |  2 +-
> >  drivers/vfio/iommufd.c     | 10 +++++-----
> >  drivers/vfio/vfio.h        |  7 ++++---
> >  drivers/vfio/vfio_main.c   |  6 +++++-
> >  include/linux/vfio.h       |  1 +
> >  6 files changed, 18 insertions(+), 12 deletions(-)
> >
> > diff --git a/drivers/vfio/device_cdev.c b/drivers/vfio/device_cdev.c
> > index 3f14edb80a93..6d7f50ee535d 100644
> > --- a/drivers/vfio/device_cdev.c
> > +++ b/drivers/vfio/device_cdev.c
> > @@ -111,7 +111,7 @@ long vfio_device_ioctl_bind_iommufd(struct vfio_dev=
ice_file
> *df,
> >  	if (df->group)
> >  		return -EINVAL;
> >
> > -	if (vfio_device_is_noiommu(device) && !capable(CAP_SYS_RAWIO))
> > +	if (device->noiommu && !capable(CAP_SYS_RAWIO))
> >  		return -EPERM;
> >
> >  	ret =3D vfio_device_block_group(device);
> > @@ -157,7 +157,7 @@ long vfio_device_ioctl_bind_iommufd(struct vfio_dev=
ice_file
> *df,
> >  	device->cdev_opened =3D true;
> >  	mutex_unlock(&device->dev_set->lock);
> >
> > -	if (vfio_device_is_noiommu(device))
> > +	if (device->noiommu)
> >  		dev_warn(device->dev, "noiommu device is bound to iommufd by user
> "
> >  			 "(%s:%d)\n", current->comm, task_pid_nr(current));
> >  	return 0;
> > diff --git a/drivers/vfio/group.c b/drivers/vfio/group.c
> > index 7aacbd9d08c9..bf4335bce892 100644
> > --- a/drivers/vfio/group.c
> > +++ b/drivers/vfio/group.c
> > @@ -192,7 +192,7 @@ static int vfio_device_group_open(struct vfio_devic=
e_file *df)
> >  		vfio_device_group_get_kvm_safe(device);
> >
> >  	df->iommufd =3D device->group->iommufd;
> > -	if (df->iommufd && vfio_device_is_noiommu(device) && device->open_cou=
nt
> =3D=3D 0) {
> > +	if (df->iommufd && device->noiommu && device->open_count =3D=3D 0) {
> >  		ret =3D vfio_iommufd_compat_probe_noiommu(device,
> >  							df->iommufd);
> >  		if (ret)
> > diff --git a/drivers/vfio/iommufd.c b/drivers/vfio/iommufd.c
> > index 799ea322a7d4..dfe706f1e952 100644
> > --- a/drivers/vfio/iommufd.c
> > +++ b/drivers/vfio/iommufd.c
> > @@ -71,7 +71,7 @@ int vfio_iommufd_bind(struct vfio_device_file *df)
> >
> >  	lockdep_assert_held(&vdev->dev_set->lock);
> >
> > -	if (vfio_device_is_noiommu(vdev))
> > +	if (vdev->noiommu)
> >  		return vfio_iommufd_noiommu_bind(vdev, ictx, &df->devid);
> >
> >  	return vdev->ops->bind_iommufd(vdev, ictx, &df->devid);
> > @@ -86,7 +86,7 @@ int vfio_iommufd_compat_attach_ioas(struct vfio_devic=
e *vdev,
> >  	lockdep_assert_held(&vdev->dev_set->lock);
> >
> >  	/* compat noiommu does not need to do ioas attach */
> > -	if (vfio_device_is_noiommu(vdev))
> > +	if (vdev->noiommu)
> >  		return 0;
> >
> >  	ret =3D iommufd_vfio_compat_ioas_get_id(ictx, &ioas_id);
> > @@ -103,7 +103,7 @@ void vfio_iommufd_unbind(struct vfio_device_file *d=
f)
> >
> >  	lockdep_assert_held(&vdev->dev_set->lock);
> >
> > -	if (vfio_device_is_noiommu(vdev)) {
> > +	if (vdev->noiommu) {
> >  		vfio_iommufd_noiommu_unbind(vdev);
> >  		return;
> >  	}
> > @@ -116,7 +116,7 @@ int vfio_iommufd_attach(struct vfio_device *vdev, u=
32 *pt_id)
> >  {
> >  	lockdep_assert_held(&vdev->dev_set->lock);
> >
> > -	if (vfio_device_is_noiommu(vdev))
> > +	if (vdev->noiommu)
> >  		return 0;
> >
> >  	return vdev->ops->attach_ioas(vdev, pt_id);
> > @@ -126,7 +126,7 @@ void vfio_iommufd_detach(struct vfio_device *vdev)
> >  {
> >  	lockdep_assert_held(&vdev->dev_set->lock);
> >
> > -	if (!vfio_device_is_noiommu(vdev))
> > +	if (!vdev->noiommu)
> >  		vdev->ops->detach_ioas(vdev);
> >  }
> >
> > diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
> > index 50553f67600f..c8579d63b2b9 100644
> > --- a/drivers/vfio/vfio.h
> > +++ b/drivers/vfio/vfio.h
> > @@ -106,10 +106,11 @@ bool vfio_device_has_container(struct vfio_device=
 *device);
> >  int __init vfio_group_init(void);
> >  void vfio_group_cleanup(void);
> >
> > -static inline bool vfio_device_is_noiommu(struct vfio_device *vdev)
> > +static inline int vfio_device_set_noiommu(struct vfio_device *device)
> >  {
> > -	return IS_ENABLED(CONFIG_VFIO_NOIOMMU) &&
> > -	       vdev->group->type =3D=3D VFIO_NO_IOMMU;
> > +	device->noiommu =3D IS_ENABLED(CONFIG_VFIO_NOIOMMU) &&
> > +			  device->group->type =3D=3D VFIO_NO_IOMMU;
> > +	return 0;
> >  }
> >
> >  #if IS_ENABLED(CONFIG_VFIO_CONTAINER)
> > diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> > index 8c3f26b4929b..8979f320d620 100644
> > --- a/drivers/vfio/vfio_main.c
> > +++ b/drivers/vfio/vfio_main.c
> > @@ -289,8 +289,12 @@ static int __vfio_register_dev(struct vfio_device =
*device,
> >  	if (ret)
> >  		return ret;
> >
> > +	ret =3D vfio_device_set_noiommu(device);
> > +	if (ret)
> > +		goto err_out;
> > +
> >  	ret =3D dev_set_name(&device->device, "%svfio%d",
> > -			   vfio_device_is_noiommu(device) ? "noiommu-" : "", device-
> >index);
> > +			   device->noiommu ? "noiommu-" : "", device->index);
> >  	if (ret)
> >  		goto err_out;
> >
> > diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> > index cf9d082a623c..fa13889e763f 100644
> > --- a/include/linux/vfio.h
> > +++ b/include/linux/vfio.h
> > @@ -68,6 +68,7 @@ struct vfio_device {
> >  	bool iommufd_attached;
> >  #endif
> >  	bool cdev_opened:1;
> > +	bool noiommu:1;
> >  };
> >
> >  /**

