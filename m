Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A390F6967C0
	for <lists+kvm@lfdr.de>; Tue, 14 Feb 2023 16:15:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233089AbjBNPPl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Feb 2023 10:15:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229622AbjBNPPk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Feb 2023 10:15:40 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 563971A4A4;
        Tue, 14 Feb 2023 07:15:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676387736; x=1707923736;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=gnTuFATXiqPdcRBXBeQsLqb3iuI0IqnAHk51ATsxayA=;
  b=OZ1S5xjoOptqHotjBc34utqKselAJLp9DJ87NiIV7eeWT3oul3UBmzaV
   TnULe8FIpq//S5nPEPrmPV62QmtKFRZSX6Bj+TFk6P1xojusAlKYNP1v4
   +ajmwPou8E5/6Qqi+9YG/JrypsSfwy90yCWqg/6lYzRv1mcjKD+ZrVAdL
   Zw3Gq3YHtnGYh8BOm+Z9PIO9CQIkYqpwE24BJJiIM8Q3ZjkxOMorFbkMS
   n6aYWnpuK34KUDgNLxM/rbSDUYV1e7pJJvOOCwv5Cw46DXepS7dhO2ur3
   YsRK6/aaQXWRnsX1hKDtLtgwOqs2Vgh+rvkWCG57PCtcYorpbBGfGVdK2
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="393584224"
X-IronPort-AV: E=Sophos;i="5.97,296,1669104000"; 
   d="scan'208";a="393584224"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2023 07:15:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="619088824"
X-IronPort-AV: E=Sophos;i="5.97,296,1669104000"; 
   d="scan'208";a="619088824"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga003.jf.intel.com with ESMTP; 14 Feb 2023 07:15:35 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 14 Feb 2023 07:15:35 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 14 Feb 2023 07:15:34 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 14 Feb 2023 07:15:34 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.176)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 14 Feb 2023 07:15:31 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Alf5IobTUycmb7i/sUGyLdiY9orsNie7gYz9w+BpmhDpamRPNHEOsqkxLksB0uX8/oON5D5T218udB/H4lKgb5zns7wnmYOnOp6tXzxvdkb8QlpyzER3/jwQeKbt5UkHeY1m/+G9gG8FyOLoAeuY6s8/fl83H3zTRnI/Rgo/c6l30YVlhH+gPw5nc0DE8ubr+/H66MEjzSNCuRTsGGyjKyggpTjW2jdhyqyfXtKQi6FoX725HFyppwWDX3SNLinXBAL3VICqgFe8ca+hFesIz1QEPtFwW/TO+FdJWe8igfWQCuCjdH9qv394w5TRPz8EgRC0zACgQX/G2N8L4531DA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=09xhrlD5YEPYFCFFyKjiJPErt0abvFXw13x5aqeyFt4=;
 b=Ey/VyZaE22NTgQj3Oq0fIFTJtgLWrGiul6/JXAFIQvQKiKI38KG/bEtR/DPaNsmNbLs5vNhpP3ShTGNQHZSH+LMdavLAgoZC0PSy0gm+fRAK8wUP/GTZJUUCoOVmIEL22/Aj6unWc192Nu2daRuAfRN+Qu8xNetyF1yQ8u5BVxqNEW4t7EnlO1WcLMLDAnBZ/5qmR5kJT99+sDsJBpyfGqZStvRBFRhMLXS0UvOQIGsFZ23/GjrP+hQ722PQLhWz16WVISjXpYPdFcuXTU0sNs6ZeJbvGypW84a/79LXR21Rk7T9DjIZ/WWJC2K5bFG3X2DX/Az/tgBaufWq00MMXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by SJ1PR11MB6228.namprd11.prod.outlook.com (2603:10b6:a03:459::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24; Tue, 14 Feb
 2023 15:15:29 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e1fa:abbe:2009:b0a3]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e1fa:abbe:2009:b0a3%3]) with mapi id 15.20.6086.024; Tue, 14 Feb 2023
 15:15:29 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     "joro@8bytes.org" <joro@8bytes.org>,
        "Tian, Kevin" <kevin.tian@intel.com>,
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
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>
Subject: RE: [PATCH v3 00/15] Add vfio_device cdev for iommufd support
Thread-Topic: [PATCH v3 00/15] Add vfio_device cdev for iommufd support
Thread-Index: AQHZP73MTR3br74MlEe91B7qYhP/Qq7NSHqAgAA774CAAQoc0A==
Date:   Tue, 14 Feb 2023 15:15:28 +0000
Message-ID: <DS0PR11MB7529F0B20A73690C5650778BC3A29@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230213151348.56451-1-yi.l.liu@intel.com>
 <20230213124719.126eb828.alex.williamson@redhat.com>
 <Y+rGDeEMTB8FxjAH@nvidia.com>
In-Reply-To: <Y+rGDeEMTB8FxjAH@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|SJ1PR11MB6228:EE_
x-ms-office365-filtering-correlation-id: fb615aaf-fc89-4bf2-7209-08db0e9e4ea7
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ubXEp0mhfnXBLHO/hyKdrFpt4LWu7VddX79XCEfCGn0Wi9leS1NYqQeQcuzK1zCiFPIoyZJCGpeuBHyKEBaKMQhRa28B2momM3+fTDjlugp0NpM5c6a4nk6BtZlFebr3r3MUzpOYw7Y41/W0GuRgajwqJ6ayjgecKkbR+EgP04CVC62U2lCC0Fc2/aC4EZxe0gL95AQOdZxK4X3OLkltP1Xl9ourOjU8wTj8gk3rCdi5rP/2rlCsw1k3SWmgh5KsdeoY97u+FbA2esjlZ6GqN/COoljsAzoSVbelHVmuW/ATjiGy8/BSRpgKnRKABhtSi/3clljI5M0RDQZAVOgSTkw4NFlUKcRUDn0hUNFpwytVp2TeDF0f4zWZNonG479VOta6DyQ+s97D9ritpQES2N1OJAeJ69r/WxYZcA+RFAzprEMgEowZVsQie4oLXesPRdt8g7661YLSAn+xjH1kk7KeMgWB9WhIrV55Eoq87dkqR2+MiHhixnDRO+LF9HxjoMLcLbO7LtJjX+rI2abtrZ/fIB4r5fKIufuN9OyFbpwbyp34qvRrdkBOxOyZhYPXE5B0oW5wMQ7tkb7iyf/+OYXFrVIZu3kIATUAWPuKEUq28qAWIr+8rJzE+BGvV1fbXg+FfuQZN+EniWIYtwOf43c9uXOLqVg9ILeWqOVHNrLMxI4pVJzDSI+Wfp2V1q8ZuxVMxAWXt7AbQWhwqlspww==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(396003)(136003)(346002)(376002)(39860400002)(451199018)(86362001)(38070700005)(66446008)(82960400001)(54906003)(66476007)(316002)(64756008)(76116006)(4326008)(66556008)(8676002)(966005)(33656002)(66946007)(478600001)(7696005)(110136005)(83380400001)(8936002)(52536014)(41300700001)(7416002)(4744005)(2906002)(5660300002)(71200400001)(122000001)(55016003)(26005)(186003)(9686003)(6506007)(38100700002)(13296009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?cgryQO85OYsXYptlrU73FqRtf0Z4QH/haLbF/SrNfuQhjwuZXu88mzoR7gDZ?=
 =?us-ascii?Q?+wu2rLorrC4N8mo67OWPLehzILbRsbm0APO5aojjluJeYTZB/oEM0i7wNi78?=
 =?us-ascii?Q?wnHvEiYGP60OwHtJfuFlHbPO/viB62S/w/0KVoQziMidlnIizAnch/G27uRP?=
 =?us-ascii?Q?/50OwNJbwC8KhM108gUqm4HhSfAxVoWnuQtdhbJbowJDBGSuUCERkvGY2r6x?=
 =?us-ascii?Q?nmI6OA70oAzO1t9F1V3AUYfo9Wg386notgn0xfnxboeOHsp4u8ggFKpx0mHl?=
 =?us-ascii?Q?Zqez7E17679fbQk0XLbpVg1ccw/x1Q20qvTbQWdRWH22X3OEzEkyofJHSUaS?=
 =?us-ascii?Q?x3LyMlxsxd6yxY/mSvo6p3R/p/XTjkKI++AOsBSFzuWiymtj7fkqXJgxs2SM?=
 =?us-ascii?Q?wtIORDsLj7XnJsGYuXCnpcNh0JVDa1gRqEeco7vQ91eZfM48iA4V9ohKF+34?=
 =?us-ascii?Q?PGUHDumsy6MkbCal/MNWU4UYOGWI8T3hN4uwTOPR+XqDu8r4xmN7KwxemgZh?=
 =?us-ascii?Q?IiyI/l5U4hkGNZoO+GrAxMzBb3UvfauwM2Ky7tYaORuponFkfVNmEizVQLMv?=
 =?us-ascii?Q?7MTN6k3RY9E+LqoLuwRQuOPiQYpa+o4aBZjr2++9/6IUvZNsr1M+VGyzf1kw?=
 =?us-ascii?Q?WlK3TMXe3igdEx9hVGbIZ0vxjNHfRM8tGB9CS9uSvu0k6IIFux9KeMs9vsSp?=
 =?us-ascii?Q?YDJz8UD9+Z1jh2g1zMIxnudlSEl847W7xZq/SQxxLcZfqZWt36w24e3UaPuM?=
 =?us-ascii?Q?KJ9MdVqsCnZ0KCT2wLwr7uzD7i/5jyEbM7GHUMFh+llvaRAmtcPs+dCRtF+I?=
 =?us-ascii?Q?Wt/kArqp9So26nUlH1XXUhJCcZXSkglQ9z2DbPVNjItZ6WwD+S6dPCEUBGq1?=
 =?us-ascii?Q?naWRKXgpaoYt8lJHAzP0p0O+5xLTjfTjATHXpmqG83eR5WN+3kxJATr536UV?=
 =?us-ascii?Q?GtrDWZpQaS2EO4P/anbgmy9KZC40Diz4BfKHSxnLE6f+LhxYA+ZFFM7KwMUX?=
 =?us-ascii?Q?HEl/hxs14CuoOFrF7D9yvdSi0ensgGZyDiZxz6tDWjrxVs6sZTt1luh0veNK?=
 =?us-ascii?Q?zIrOzkQ7P20U+b2d6YGQIhGGpZqpN0xxKQEWaR8Cs1sKNN1U0y77fpqhFAYO?=
 =?us-ascii?Q?EZULbrl7HJzAmX2/NS0bVNyNw9/q1KfyXRjp3t+0u2wXBgvVyEK/GKh7t94M?=
 =?us-ascii?Q?FLxADVriiOCAk7qm7CCmzAe+3QwXD5GCejQv0/UrWu+3gRdCAjA870cWUloR?=
 =?us-ascii?Q?8Euv0YbsRxrTr7dHqHNhYyTA+da2BIKYNb1oZpPk6J/k+RNbEDDVl0Wq+d1f?=
 =?us-ascii?Q?pO2bBFo4dxOFRvkl2ttIcnRCZzYVtkb8u9i2ueoLl2BuJ+l/AkdkESWMlLO2?=
 =?us-ascii?Q?mV1mcu+avGP7LPeQQo1TdLP4msRkGIzQUgjx0DAHwmRicKUmuJZ4FaIGzdh2?=
 =?us-ascii?Q?e1WX8wT1ho0krXCyW3kFw0q3EYS2TROKYybAvWW2E6vDiREJe0r47I+7saFH?=
 =?us-ascii?Q?je8dTMot27lJh+DE4OJJflcjUzgq+L6VSkT7p6qrMGkbbJIFXYfwi50gCWNy?=
 =?us-ascii?Q?KkfCpg3Iyl0nWtd/mIkeuTk6WU1GJzhbgfMMguZ8?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb615aaf-fc89-4bf2-7209-08db0e9e4ea7
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Feb 2023 15:15:28.9650
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GE6kT6Ba7480TuJqoamRml3GG3r9tovjvLv6VZbTxDLQRfk7APY7/oorvxDmStEvfqtzr1dOH7c0lkMASNymoQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR11MB6228
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
> Sent: Tuesday, February 14, 2023 7:22 AM
>=20
> On Mon, Feb 13, 2023 at 12:47:19PM -0700, Alex Williamson wrote:
>=20
> > I think it's too late for v6.3 already, but given this needs at least
> > one more spin, let's set expectations of this being v6.4 material.  Tha=
nks,
>=20
> Please let's continue to try to get this finished during the merge
> window, all the other series depend on it. We can manage it with a
> shared branch again..
>=20

Sure. I've updated the below branch to address Kevin's latest remarks.
Fixed the compiling failure reported by Alex as well.

https://github.com/yiliu1765/iommufd/commits/vfio_device_cdev_v3

Regards,
Yi Liu
