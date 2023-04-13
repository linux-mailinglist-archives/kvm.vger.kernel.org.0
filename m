Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D52256E08DE
	for <lists+kvm@lfdr.de>; Thu, 13 Apr 2023 10:26:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230033AbjDMI0D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Apr 2023 04:26:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbjDMI0C (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Apr 2023 04:26:02 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 495F498;
        Thu, 13 Apr 2023 01:26:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681374361; x=1712910361;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=PauSMVYbsyXWhzbkA/BA5mc/xzHwFPDpGoS234JXYDs=;
  b=lEV8muKYc4dZycUq3XS0CKDwfSEg0s6qDlmmMgTMNz3/Mtu+KICBu/w5
   cl1RyB3sqR9RG+XdJs/nizhUSpxpFMMe7eLVM/rUX6EZ8NrIGa8BDK96P
   A8NbBMQTp5hAgKjfXq1dF/hx5gIU52vbjuVxuG67utDbNCOyUOq/W8eCn
   oCaltnCcOziFFsr0BoF7V0VSCM+eJqtMbrJDn1Oxn+lw0EZpK1saJsAnq
   Yt778osSWK+SFjidT40zZaiPZn8G3dg4T9PnbhsoEE1S2968/evmHFi5v
   ghfvi0GC1eOuHI8ZuNK2Kxt4PVje+AP0sbcUwzuV7TWXQrASP6oGUB6vH
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10678"; a="406960871"
X-IronPort-AV: E=Sophos;i="5.98,341,1673942400"; 
   d="scan'208";a="406960871"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2023 01:26:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10678"; a="639586830"
X-IronPort-AV: E=Sophos;i="5.98,341,1673942400"; 
   d="scan'208";a="639586830"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga003.jf.intel.com with ESMTP; 13 Apr 2023 01:26:00 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 13 Apr 2023 01:26:00 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 13 Apr 2023 01:25:59 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 13 Apr 2023 01:25:59 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.46) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 13 Apr 2023 01:25:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aTbubNQq6/o86W+9g0wqfcXrcAJZNlyG+LYO3zOatSiiJ8mTiYeKbTT/Qyya4pl21ZqDp5kpdan5NeZp4KRonq1KkXvsHHz1R1EBBWNdUO1IJbHS11oGyTFruqPiJXepwNhjny4QSmDJ60JVKkMyNZP2kNM9Rcfec2M3999ZbS7srtmDrDoC5OLApMDJTBU82Wg98FEccd5NxcqHo9dc5Ugcgrqa3AufZgH2tj261zPDEN8+Vz91ib74vqsGoiJ2R2jFo4tJ95LuGkf1TOmGm5x7u42EyyxVrx84gtqNhKOdzYYjDxEo8b/qSOp2HTcMUVWb0WSRjydGFuKs3KDPiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WaFhWg9/PkCMcNvjdbW9FAUniotgridqqYcF7EigjDE=;
 b=apWcvz/OsRQPVlL6KfdHe0I6hxZVPVLF9jDzr7fhMUYjO8aEfuFty9lV99v3cuy6Ucbu89k5/9qAHVcVh4Exodpe+O+yRzJF3aZ+Nli1dAMMzDVM07Kh41MAfx/vThQSwxe659/l8zMXLLaBrOL08zYXGE8/1fdCo/bAGUhRNGEGUydsIMWhF8By6naMDiEZianfbNBZ32cuOwOSXb+DBUSRi1F2ymGjudqd6pDtrGsQ3VZc8gQ5iptrURz7J5vH62abqqHYNCLG8bfp3YZLLeh/+XRndG7qiPs+vSpAo9Utj0UkVkbDq/Gb9IV5oYFCRrdCwXyInfIw9692Hsw5Kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by PH8PR11MB6950.namprd11.prod.outlook.com (2603:10b6:510:226::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.36; Thu, 13 Apr
 2023 08:25:52 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::73e9:b405:2cae:9174]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::73e9:b405:2cae:9174%7]) with mapi id 15.20.6298.030; Thu, 13 Apr 2023
 08:25:52 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
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
        "Jiang, Yanting" <yanting.jiang@intel.com>,
        "Duan, Zhenzhong" <zhenzhong.duan@intel.com>
Subject: RE: [PATCH v3 12/12] vfio/pci: Report dev_id in
 VFIO_DEVICE_GET_PCI_HOT_RESET_INFO
Thread-Topic: [PATCH v3 12/12] vfio/pci: Report dev_id in
 VFIO_DEVICE_GET_PCI_HOT_RESET_INFO
Thread-Index: AQHZZKiCXow33Wzeq0K314B/OZqu968cqG8AgAAdbYCAACdegIAAAyuAgAAEPICAAAjLgIAAGeKAgAAG7oCAAAf9gIAAO30AgACyrQCAAIPEgIAHkI0AgAApuICAABWEgIAAGNKAgAA3aoCAACJEAIABGhiAgAA2uYCAAMsIYA==
Date:   Thu, 13 Apr 2023 08:25:52 +0000
Message-ID: <BN9PR11MB5276782DA56670C8209470828C989@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <ZC4CwH2ouTfZ9DNN@nvidia.com>
 <DS0PR11MB75292DA91ED15AE94A85EB3DC3919@DS0PR11MB7529.namprd11.prod.outlook.com>
 <20230406115347.7af28448.alex.williamson@redhat.com>
 <ZDVfqpOCnImKr//m@nvidia.com>
 <20230411095417.240bac39.alex.williamson@redhat.com>
 <20230411111117.0766ad52.alex.williamson@redhat.com>
 <ZDWph7g0hcbJHU1B@nvidia.com>
 <20230411155827.3489400a.alex.williamson@redhat.com>
 <ZDX0wtcvZuS4uxmG@nvidia.com>
 <20230412105045.79adc83d.alex.williamson@redhat.com>
 <ZDcPTTPlni/Mi6p3@nvidia.com>
In-Reply-To: <ZDcPTTPlni/Mi6p3@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|PH8PR11MB6950:EE_
x-ms-office365-filtering-correlation-id: 8594db6a-fca9-4bea-55a7-08db3bf8b1f5
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: P82aol+dIXn9s49GZiWpxQnIsM5ro98qWVThiSe1eR/PD/jFhfT0M//TRmOZI8VH/ebyJYjbzHSCh9bhrdcHdZot4z6ZstbYUu01HQ1SxYMeGxNw4zLJUdleuF6lGNSg7bzqOFVrKn+e1Q+jo4SEwRm1QzaR6xO0vZyYbOrsN3u5pVywAQqA7yllpbhB/yx+cIbQO14LmBBpb8U2EwU3eC03vjEQ7yb/sLaBBdQRagxYsLBanbzVxBDYSJnMeUr3HuNnFKvdvH5v2cb0rCJyiRFrOtlz3pIUGCQgQwUE8TvBph+4XVI+6RNesWUgpzicIpSbY9frpgJ0+PmDURMt3expfFZ7a+VFIFWN7sTWa2K/tT94fXNHbPWVW5yhdVU9IhSHe10vMif7mS7LabWtTGW0le8buOuwXjSOG7EmO+NJ09aqUnUcujfOnPux04F6Fza6gzG2jpRwhtImZeChJemR1FEEz8WN0tXMwnWQJn/Aglsri6FmKgqMo4wlKAKe7SsAKIbC6IdiEBiuz4jDU0DO2mcPkIzWZinc938CmSIQWa4XOv/2IutFQx1wbcTF1SGm5obXftjHfwdD2A65rzhSjjUFQDZCn1mQIVVooiu8jJ3UZi/zxvw5nMtgGLnu
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(39860400002)(366004)(346002)(396003)(136003)(451199021)(478600001)(7696005)(71200400001)(83380400001)(55016003)(82960400001)(122000001)(33656002)(38070700005)(86362001)(38100700002)(2906002)(316002)(6506007)(9686003)(26005)(110136005)(186003)(66446008)(54906003)(5660300002)(64756008)(66946007)(66476007)(52536014)(8936002)(41300700001)(66556008)(7416002)(8676002)(4326008)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?aIwc2yuPc/qE0g2+19ityKh+ioeKJWGeACk7vkGjq6PwfVP/haIcfF0egK7l?=
 =?us-ascii?Q?NLs+BFe/Sh8o/WCipBKW+owCsllLhgjKCkTDQWXS9wU+LiVfngSRBBn5CF/3?=
 =?us-ascii?Q?yg6GQljFqMUqkao0BNqD13rG/XA1OqPtMURTRKkUSMGM3SkbtPRUSuwIMUvg?=
 =?us-ascii?Q?vlRI0ut/vwanUrSOIKxQtcEsgdxl51bjhm+oh0HpwwFFRBOsWKhrjECCgNFZ?=
 =?us-ascii?Q?WyFbymoFYAGkK9a0jREXlQD/l1bgcAfVVriRrM1kqnzklQFYSxoIqGtKaX0l?=
 =?us-ascii?Q?Zb/K475JV5OLdHzywe39ET0ECe4AFHRPJrVCgYSHWNB0OPScmYoJhW3dfe9A?=
 =?us-ascii?Q?SSJwJWA77TNKAFV1/EM3h96nxbWRPfk6M6Zb10V576Fo0dB4I/yPg67CPRFR?=
 =?us-ascii?Q?0Maj9UnU95eD05bH2Qw1Y4n0bbYNTQG7Zx7o+GbkDIH3VNhHgbKUvexeLWtw?=
 =?us-ascii?Q?CMhe+uH00FPABd7/a0gqe16oo9o4fYUsm6QK4uWBjKHGbYPzNaVz891b/GEF?=
 =?us-ascii?Q?uee6xkwirygeZnihitYaQsacCU45mSgZqRYfVtoK3M/TRxHP9xKegeMv579S?=
 =?us-ascii?Q?sQVTf6+NNrIa/hF4gPTXT0hNIQMnzsveS+Nj00wberHHzxvt3urGGIWZz0Dd?=
 =?us-ascii?Q?PT67TMHq+ytxAg/SdFDtBZ0B+0mfOUjGJ3mA2WFSER3gdrMq+KXA6nVsN1Fy?=
 =?us-ascii?Q?n4Vuapqw61MSnuT9rz24Iqdxv9NKoFBBF73AAEF+06VWiK5yr2k3FBQSJFPf?=
 =?us-ascii?Q?PwO/tnTigEaqmJwDtr1hRfgrUAtOzOFkecCKuGZiaZCGVOreZb4UQt8U3NV+?=
 =?us-ascii?Q?XB/gA5RLm+O9+yEzOTQohODRjcN5QYjOSSkaP7XIgnU9hewEYKM+Sh45xDCY?=
 =?us-ascii?Q?aQFlE9r+o2fGTYtYbJr/NDdJ0iUAtmBRpYwNbH2me4fyzG1J8YzWBCq0FUv/?=
 =?us-ascii?Q?VWyHQvCLlEfsXGhtyxiFUUoOEzVcOEuJf5VZzgCD/uAZ4StFae+cbVQetmXe?=
 =?us-ascii?Q?G0gtF1KWdFCIMi2cqeK2UtB7+Dd9fqgXOxCYBAjbUxj6ar+5X7IUH6I+lWRw?=
 =?us-ascii?Q?uBgBN3MuifcWNXaKc7A6UhvIpLQaTN5lceBfgAf/PSoUm8v9sJwN+W22RMcg?=
 =?us-ascii?Q?DjvKkaJf0zGtI7jSleQNQHz5YMU3AMsJ66KaVOtsHpWWFvXAE3qTjRfZ+1ng?=
 =?us-ascii?Q?de2Q169WhCbABY5GYvFNGAJHMciKV4VEtrCUI6sMgIJIx/1MQyKWoEt/qula?=
 =?us-ascii?Q?EAPkyyGMaapqWzgl5iVpdBXlT3K4JuLIrg4zrg8qLTJ5wNSj0Se3sAeLckOx?=
 =?us-ascii?Q?yjEuDn65GL9JbamxsvdHnisX+oylN8EKk75BxMdiu4sW88wc6a6hkesQldud?=
 =?us-ascii?Q?NVbZKDQRwSB3Iilawu73XmXYOE4xgogcRlaXi6EVCLPt6Crx+ANsb+RA/OKP?=
 =?us-ascii?Q?zw3+MdFrKIx2qE7lR7n/q4BzaSV1JciEU2Ap+uD4ztFyP6UiEKVyxpHoZLI3?=
 =?us-ascii?Q?QMzIujE5X6lPKrU7CNw6O5Fir+I90zIbGRn4gMiU46KgCQy5rNcOTFI/9avh?=
 =?us-ascii?Q?RS0TaHM0YmeJDfikpcWJmYqYeA4CY9ES7ByLtXSJ?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8594db6a-fca9-4bea-55a7-08db3bf8b1f5
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Apr 2023 08:25:52.6627
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: plYrbzIjP8NVGr2jpzHAss1zXnUW5JtrBOu6eDGv6KYbYWbzr5thpVo2kzvciGB/VPRrncHHC2yWJ1WMhme2Jg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6950
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

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Thursday, April 13, 2023 4:07 AM
>=20
>=20
> > in which case we need c) a way to
> > report the overall set of affected devices regardless of ownership in
> > support of 4), BDF?
>=20
> Yes, continue to use INFO unmodified.
>=20
> > Are we back to replacing group-ids with dev-ids in the INFO structure,
> > where an invalid dev-id either indicates an affected device with
> > implied ownership (ok) or a gap in ownership (bad) and a flag somewhere
> > is meant to indicate the overall disposition based on the availability
> > of reset?
>=20
> As you explore in the following this gets ugly. I prefer to keep INFO
> unchanged and add INFO2.
>=20

INFO needs a change when VFIO_GROUP is disabled. Now it assumes
a valid iommu group always exists:

vfio_pci_fill_devs()
{
	...
	iommu_group =3D iommu_group_get(&pdev->dev);
	if (!iommu_group)
		return -EPERM; /* Cannot reset non-isolated devices */
	...
}

Probably we need a special value e.g. -1 to represent noiommu case
given valid group ids are positive.

with that plus BDF cap, I'm curious what is the actual purpose of
INFO2 or why cannot requirement#3 reuse the information collected
via existing INFO?

For each opened device Qemu can find the related group id via
sysfs (if group exists) or an optional GROUP cap and use that id to
match the group id in INFO.

For noiommu it has a group id if VFIO_GROUP=3Dy then same case.

For noiommu if VFIO_GROUP=3Dn just do exact match based on BDF.

Either way the information returned by INFO is a superset of knowing
the reset scope between opened devices.=20

Thanks
Kevin
