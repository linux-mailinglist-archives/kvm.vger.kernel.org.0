Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D2876D15E8
	for <lists+kvm@lfdr.de>; Fri, 31 Mar 2023 05:14:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229813AbjCaDOc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Mar 2023 23:14:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229727AbjCaDOb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Mar 2023 23:14:31 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D287312853;
        Thu, 30 Mar 2023 20:14:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680232470; x=1711768470;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=muI7/X6wHK7N9QJLNE3mc/YPBFmC8F/n6FNUy9A1WAM=;
  b=haO6fI4GULrNVz4vWjukzTXvscFSmQjNDICcuTKv8Hx2mSgjjfQozyIY
   d9YfvWbc+4aTv0CL0PFJfM/XsZiKbNTdN/wbsYFozJYyJgJ/BPfRFh3F6
   umzpOyREOKjD7Ws0R6VTT17BiNAcZxQDYXgLdsHTHUFW1XrvDF4x2ADIc
   UsdEsmiCkBQjpU40nKeMRbMWL2enOMBOQ7jO7lbAPEufinNRZBPRwk63R
   5aPleHf9AT0aGa+AJ05+u804hKkWNrKGCBWkQf6Hw6OWxjx4f2n4bezoi
   N93gZCctMS9Zq6EiG/QA0ZnXgFequQUCgmbyTlJRw5R52liR+dlr2Csj5
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10665"; a="404044966"
X-IronPort-AV: E=Sophos;i="5.98,306,1673942400"; 
   d="scan'208";a="404044966"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2023 20:14:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10665"; a="715259013"
X-IronPort-AV: E=Sophos;i="5.98,306,1673942400"; 
   d="scan'208";a="715259013"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga008.jf.intel.com with ESMTP; 30 Mar 2023 20:14:26 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 30 Mar 2023 20:14:25 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 30 Mar 2023 20:14:25 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 30 Mar 2023 20:14:25 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Thu, 30 Mar 2023 20:14:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iOK40/E9IyEz8Tipe3IbhB9IQbg8iuJhnjg9+KdWuSG5WTM8F7SNOozJKfEPMmyAx/+6Qqi9ROaO452z/VHXoe9s1HRPncr6P/x7lInafN3Z7CfzNQ7cUgi5/ZwvoCbLesiog7IUQc3aMgeOFf+SLJ9wEKk7q/Jq3ItpHSVLH2QX0ma2jvZw7M1vfZ/cfRHgfTTDL27gOnHNvsa0VJ3SMHXqXW3JYn9Msn3JOTV7vmdeC+PmoUNSh7zzPtH7tkfJSrjiCgbfg6KfCpL7rOPBA3jysEPBB2CUa9SDywkHveRnF81cN12gGfLxKgVi4C/JRj92pni6Xo75BBZ0vb/evQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=muI7/X6wHK7N9QJLNE3mc/YPBFmC8F/n6FNUy9A1WAM=;
 b=G51EqP1RNNGVBzRHWZrHE8I79jDI6+uUjJfx61kB6MqzrMvj+Qc/4sGKl8OMaeTSN6NDK6rnFwZSZmxuFaHz7X8lklAJ8DF71iXs7YaMuHM/n0rSAIchWqnJUQ/rdBrR/smhQS+x4JODT0EHiFdAAjMQsFpH57G4WsaT65VHSCcQ10NrIUXUX/nbdpwb5bNH7iFFPov3I8ntywn7CR4dV0Zmvx8xVnWTBY1Za907oxfS1SNBFSx3i2R3vZwjTT1qMZ6VfEjd8r3hmmDveLHwGEaI9HaiygHyN8tFqtRoi/6tTGTfjpMFVWacHhZJT+CyA+U12AwH926euFc9yiSXEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB6763.namprd11.prod.outlook.com (2603:10b6:303:20b::7)
 by SN7PR11MB8110.namprd11.prod.outlook.com (2603:10b6:806:2e1::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.35; Fri, 31 Mar
 2023 03:14:23 +0000
Received: from MW4PR11MB6763.namprd11.prod.outlook.com
 ([fe80::c4e:6c7:e9f7:7222]) by MW4PR11MB6763.namprd11.prod.outlook.com
 ([fe80::c4e:6c7:e9f7:7222%7]) with mapi id 15.20.6222.035; Fri, 31 Mar 2023
 03:14:23 +0000
From:   "Jiang, Yanting" <yanting.jiang@intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>
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
        "Xu, Terrence" <terrence.xu@intel.com>
Subject: RE: [PATCH v2 00/10] Introduce new methods for verifying ownership in
 vfio PCI hot reset
Thread-Topic: [PATCH v2 00/10] Introduce new methods for verifying ownership
 in vfio PCI hot reset
Thread-Index: AQHZYI9oL669gEM9E0+QMvpJm73ZX68UPIhw
Date:   Fri, 31 Mar 2023 03:14:23 +0000
Message-ID: <MW4PR11MB6763D4F64127A5205D3B6567E88F9@MW4PR11MB6763.namprd11.prod.outlook.com>
References: <20230327093458.44939-1-yi.l.liu@intel.com>
In-Reply-To: <20230327093458.44939-1-yi.l.liu@intel.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB6763:EE_|SN7PR11MB8110:EE_
x-ms-office365-filtering-correlation-id: 917df6a5-514c-4cc1-264a-08db319606d9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 15pRUxhfFvtx6sAft8JwQ4wX76g/qoLZE6iTysBwTKIlIddkDjz9NGm6BcUv4kT8VWHTHea9mIMXZsWrGRCRknKg+BqMyhW+mWDZGCTWxm0xpyw7j3A/PNlKgZWmV56LOEuWXZJYjLjf+11Fae4sXN/PqlIXJBa9zLiUk1mQicgtuLSz57xGiaG5OKZbY+IB+sUk6TNJcJiSHKpviGpzQZQz1+bO8mC6ZpN8e/fOlsVqsZVMolFe0cid0jDhmvdW8dFnPu+zjKWjWU+1+pLI6i+G7N1Mc47zW1Eux828Yqkiml/4rEl8tDd00d8dXhV21rVdJp2boedVgcz4dT/7818efBOsMGLiaeBk9Z9E6j6cxaC9fdIsOiMfBLRu4Hm4d7eQUAdzYc7CouXTdddD36vuzv2xT4UaR0xYIoczY/DsNnmAm5S59dV8uBoF/CGvaP5bpQwbwdN+4V/VdCMwcIJ8lVa5tQI95KOg221e1moRQZhAQ1I/sXNpD0MjAREZkLRX1UryYq4fL9TSK1OmWxPEw6eHfrwCat9k8ABsSvxOQ/+mL8PdVkRPm8S0A9//26z0TjzDt3j6L4ioEuQmSBqALzL/44KeWfw9AiQTrwsnTIyPBuDFcUfoz/SC4m/q
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB6763.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(346002)(366004)(136003)(396003)(376002)(451199021)(15650500001)(2906002)(41300700001)(316002)(83380400001)(66556008)(66446008)(7416002)(110136005)(71200400001)(52536014)(8936002)(478600001)(4326008)(64756008)(8676002)(54906003)(66476007)(55016003)(33656002)(6636002)(7696005)(66946007)(76116006)(86362001)(82960400001)(186003)(5660300002)(6506007)(9686003)(122000001)(26005)(38070700005)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?6EZihpNR6ArsXnYrFIQF1nMpbYqz+UqOFJHEJfDbiHSLfetQddngnaP5c/m+?=
 =?us-ascii?Q?fjx37P8e4/Uy8yF3zmJw1piG91ekxltHhz/o1TntV+8KiSnzR4H2dgHR6H0U?=
 =?us-ascii?Q?quQlXwVqGycsR4F/stjJJPwM91MTvviBiEEobfZX4NYCZb3H/d0/x9GeU7A1?=
 =?us-ascii?Q?YzvFRK9OHUPZOIurpzGM91DjZna2HhRsT2wWbOUvVfqoU7quzo/6ocPtpWvT?=
 =?us-ascii?Q?x8httEFbswgZR6+J4MIqjVv6diuORqjXUsgC0vRWvadA6OlURTU+XPPhpa4i?=
 =?us-ascii?Q?4gEn1481zH7cGeNXQXQE1Wpb8j2PhwieB7ow2vgBSpwOBjwkWV3NySO/d+RB?=
 =?us-ascii?Q?q7LjPxtbZTSvHpsqUBmubM3M19rzUWsuDTmswhpuL9fsslEFQw98p4TGicBe?=
 =?us-ascii?Q?g6xs9OD1otB72Y9XZG8OdfdTF+AhCEVzilhkDHZGotDRuqrXqZExXSSkhc/V?=
 =?us-ascii?Q?MDt4IjWQRcVzJI6UfQPuC9harnAPgkQ5d9o9bDS9wBt0A1ywUrXdxnHhQJSX?=
 =?us-ascii?Q?66llG7Z3yr4klRjm4VSPP9NM859sxvF8q2ozKtC5RgvzueBse+KMgRQzyWU+?=
 =?us-ascii?Q?FrJfHswtDWMbTkVUNvIMkyYzRyIavPnmtjMBvY79ARc8oR7WXHQXe/Kze/DS?=
 =?us-ascii?Q?lkYs/NLCWJeG7MuKiJPvxtJ4dZWCE1V36KrmUw4xV7cQkVC3MHVjf8NUFyJS?=
 =?us-ascii?Q?+9e8sUhOfNnHcFzQXnMeKcLjsxKCChCCwFfL2qO1+4ba46azre6gu82jwU9P?=
 =?us-ascii?Q?VxDhNFiSIxw+IV/cwg9HKrQqMHx4SNy/P96Vobkny719tsQYSz/pVPJj6XQQ?=
 =?us-ascii?Q?n/gt7sdGepYwwfOFySR2cigWUXURqCkH01NTolEeywbAW89/e11Q+LMfgrtf?=
 =?us-ascii?Q?qkaJEvCnRKE3ZNbkkjONHzp6k+tWI5Shmsn2j3/0gfvCEgA/A+jMaQwNgiY/?=
 =?us-ascii?Q?B6ZbMXoZHD8ojnkVv2yXgC+RZYP0ZZuuZyfKLltT68NnkaNsqufWxnJu2BG/?=
 =?us-ascii?Q?h0xFH+uSEvfIAf9U+v8hl1iKKrB0KjpmTdGk2ZsxSWLXH7eKGlJb4XwxSPka?=
 =?us-ascii?Q?RVh4/Xr+c8pLFLa/X43KLg0LVilALYUoqMTuWE4qhc8vXX+y3rwwv1Fpm1Hz?=
 =?us-ascii?Q?yrs/QsGhjlTVJ3Xfx/yCB4QAb0zpZSAn2C52yuPSvWlAN0SfCj7hx1ZEGezy?=
 =?us-ascii?Q?APWqFVVBUpHTFOaKn/PEoKGkWYDXmyzwzK5CAEqzHWpbfI0j/VlLDHPy/DpB?=
 =?us-ascii?Q?1VtJ4uUpCCHk/EnhfEnHqvDt05Po19DujUl154qM7QXK+zCtwM/dvjsXLjI0?=
 =?us-ascii?Q?vEAgqNRmXbQ8v+4hcEUcPpv81Ma/DX/76Ty8LeGW7OeoyDgiz7rwxXhEXMRd?=
 =?us-ascii?Q?b0WW8f2PAjIyjD6tsM3TGNM0YOA4q3UadiruMU+nfZ/JZxopeDO39iNqenTT?=
 =?us-ascii?Q?1OIcOA9OTpsMrK09HDrzuWW3dJ9Phmqeqi/XFwPsfI6I8Q14MXQpyT+fClye?=
 =?us-ascii?Q?W0uIOGaNktJdJfu5UpmjUso5t/CzP1rSdNHeU8AoJj7pAfAlotOWfsNVMP6h?=
 =?us-ascii?Q?mZNl9KtChhdNdNhgbIERGSm1QHgexzZhLTb5fIGe?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB6763.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 917df6a5-514c-4cc1-264a-08db319606d9
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Mar 2023 03:14:23.2273
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Z3koj0Xasl6oRUciRyGiE+0JOpiNhmKcXGvhILQUQ5+5JZkDtj8uYjmr8f7p7TE8w6PCia9xXx/GoWe+JXZ7ow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB8110
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

>=20
> VFIO_DEVICE_PCI_HOT_RESET requires user to pass an array of group fds to
> prove that it owns all devices affected by resetting the calling device. =
This series
> introduces several extensions to allow the ownership check better aligned=
 with
> iommufd and coming vfio device cdev support.
>=20
> First, resetting an unopened device is always safe given nobody is using =
it. So
> relax the check to allow such devices not covered by group fd array. [1]
>=20
> When iommufd is used we can simply verify that all affected devices are b=
ound
> to a same iommufd then no need for the user to provide extra fd informati=
on.
> This is enabled by the user passing a zero-length fd array and moving for=
ward
> this should be the preferred way for hot reset. [2]
>=20
> However the iommufd method has difficulty working with noiommu devices
> since those devices don't have a valid iommufd, unless the noiommu device=
 is in
> a singleton dev_set hence no ownership check is required. [3]
>=20
> For noiommu backward compatibility a 3rd method is introduced by allowing=
 the
> user to pass an array of device fds to prove ownership. [4]
>=20
> As suggested by Jason [5], we have this series to introduce the above stu=
ffs to
> the vfio PCI hot reset. Per the dicussion in [6], this series also adds a=
 new _INFO
> ioctl to get hot reset scope for given device.
>=20
Tested NIC passthrough on Intel platform.
Result looks good hence,=20
Tested by: Jiang, Yanting <yanting.jiang@intel.com>

Thanks,
Yanting
