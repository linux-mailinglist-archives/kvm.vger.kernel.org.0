Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 213EA6CB5FB
	for <lists+kvm@lfdr.de>; Tue, 28 Mar 2023 07:23:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230339AbjC1FXl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Mar 2023 01:23:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229645AbjC1FXj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Mar 2023 01:23:39 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB0FBA3;
        Mon, 27 Mar 2023 22:23:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679981018; x=1711517018;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=T64iYxfE1l6TBf1O8+C4s9+LD/YNEQiYFPTBIF5++kc=;
  b=dNYGLeoM75VUTpsewlSLaIiM1iDrrt8TYWfrSKOEvqiZpjsIpseSdbll
   FzIcBhKWFpYpWxhMY5b/kCvFQrsUh0eSzizs6xcthunhc3QGOBSa7qGPJ
   HR6wQu2hgg++pjH6HATRGk4Yb3fsdksGrfJELOOBxLzNoKvr6no+oXvzE
   0iGICp4YlY9da5y8ze6Y00wzv24dxzJym2lMdg1cVPKut5CCJ0HyOn8aB
   ybr3kRXjX4V6YjCHSkgM3kJKWHBKdCSI9pvy0ivS6YEd9gsBK9jFOcBZa
   VNgPVygBT1coNUXi1RmUt1z1E5UIlQmF3QmvqaRA/0vlL/T2Sz5HKM0+l
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10662"; a="340499501"
X-IronPort-AV: E=Sophos;i="5.98,296,1673942400"; 
   d="scan'208";a="340499501"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2023 22:23:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10662"; a="794644743"
X-IronPort-AV: E=Sophos;i="5.98,296,1673942400"; 
   d="scan'208";a="794644743"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga002.fm.intel.com with ESMTP; 27 Mar 2023 22:23:38 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 27 Mar 2023 22:23:37 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 27 Mar 2023 22:23:37 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Mon, 27 Mar 2023 22:23:37 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.41) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Mon, 27 Mar 2023 22:23:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KXxJHvK0D26d8HjeQEATDIENZgk20UisQ+2WfEb2UDpxzejME6GcTd0A93O1D1HYoCLPL0KOjT1y6gROCLpJ4Y0gOABDMgyFJMqGoqhFFBVxDQ+6PpPqRbtih9uz8svkjBinXZrr7Nx3Du6BY/WHTNeD30DgJBiG5NpHlp7dlwE/nWhglzqozR+/VHw7YofH/FgwgjRbm3JPe76Leo+rnESblzb1gVBJxjWPCjbaz5jd/3FBWBMUuMuka1b+yMSM0hKwe55gunjNQ8gUuLCKc++7CHUXHEaEb8iNCHy4xwB1HjgCTM3sJP2021BGiJJf28p8W7Ww3YYtyJ4nzcCKrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T64iYxfE1l6TBf1O8+C4s9+LD/YNEQiYFPTBIF5++kc=;
 b=Wx4B/8s/24H4Bm8S3bqUCYj2Pc+r2pTPOTxOmVbBqTt0J5wp5Mag2Oghm3mr/zewc1ZWglRs3u21ATShMcE7PO5OBV2+7kuyowV93ILD3ADBpLF6zUMcD+We4VNdDGYPHOce7P+xgJrkptwFZ1YHq7OiPkIrWCj4M/C0lbqfan5MhaOfcaKLyKFhHKlOoedaX2mf/Wovbdk7tglHkP3nTf6+ATT8ipBG39QwkVbI88gC2HNqeIxEAhb5WM51vqQb7eZbjD3Y6a2ab4pP1J/Vi5/4WqLkNcB44Ol5K/3u2/stDilwdKjBrXYnfCeK3YSWE6h90Fxr/wOv5WGuM8d5ww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SJ0PR11MB4782.namprd11.prod.outlook.com (2603:10b6:a03:2df::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.29; Tue, 28 Mar
 2023 05:23:35 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::73e9:b405:2cae:9174]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::73e9:b405:2cae:9174%8]) with mapi id 15.20.6222.032; Tue, 28 Mar 2023
 05:23:35 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>
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
        "Jiang, Yanting" <yanting.jiang@intel.com>
Subject: RE: [PATCH v3 1/6] iommu/iommufd: Pass iommufd_ctx pointer in
 iommufd_get_ioas()
Thread-Topic: [PATCH v3 1/6] iommu/iommufd: Pass iommufd_ctx pointer in
 iommufd_get_ioas()
Thread-Index: AQHZYI9Dqq61Mn3F50SKb1aieMLREa8PqaSw
Date:   Tue, 28 Mar 2023 05:23:34 +0000
Message-ID: <BN9PR11MB52767A69A34B9343A4AD141F8C889@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230327093351.44505-1-yi.l.liu@intel.com>
 <20230327093351.44505-2-yi.l.liu@intel.com>
In-Reply-To: <20230327093351.44505-2-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SJ0PR11MB4782:EE_
x-ms-office365-filtering-correlation-id: a7eb9a53-d693-4ce8-5ad7-08db2f4c93fb
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mUDzJtbsSYvVXZIH8to2YPuUk35jhLPYI4jiJBHVcIq8sGsjks57uxjsouLbX4o4AjqynNCt7scT6DMkp5vrx+YJnsXWv+Wxiria05DaT/XA6mIWjUIv2GBjWGkCYd3EsBO2gvur6lQy5jpzkE0tJUzuOhlo0jddFQRD63pHjHGY/ylIUbI23JfQRRv4etWslL9y4aft8SWEECl1mVzYPL0QRHqtmMTWlxlOebORBz12JylyCDc4O3ahkTFk9cot+GP5pJbQhX8Prqx0lwLwWgnwQ5eN+ho1qZKFg3puFiYr7W3i65GugTfXmqxMOWPV8OkB4J2w2ldrQxNBrFAkNti5oQp6i3rcIPJhyZOJ5YS9GlVxy/trsJL/YpzI8KCIiphQekChkLa9f3b1Sess+xEgjU5KLBVnciaut7hniN/lWo7TYKnPbwjaR+0fHyd5O+QY4Z2t8XJ+sRRiteIMP6oVTzSJ1lhKKBNDZlwXTetRowJzW3pYfWucuqiz8Jx3SbmIGHMl0VFIg+omLiktunWSH92JoPa8wfkehChsWpoX93vbQgJdFYm84iHlfRbh3Dfsic4ZD7CN6eV1f1jvWUd00b5AmACly8MW0e95z7Hpy7ZEGPzuOMCanrAGLvtU
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(136003)(366004)(346002)(396003)(39860400002)(451199021)(8676002)(66946007)(66556008)(64756008)(2906002)(4326008)(66476007)(76116006)(54906003)(478600001)(71200400001)(7696005)(38070700005)(9686003)(316002)(186003)(26005)(110136005)(7416002)(55016003)(6506007)(66446008)(558084003)(86362001)(52536014)(41300700001)(8936002)(122000001)(82960400001)(38100700002)(33656002)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?M947G5xuCUDRBf9XumiS54KB39Fa81/nBV7RkvtuygvjtWt7p91fpLk7W8R6?=
 =?us-ascii?Q?UoZBaNRTV4JMVRHILO6MRibUxR4jcJ/Efyd69MQTF5DDzgrtsZ27icHSZhez?=
 =?us-ascii?Q?I/rUmS0v5JUZn8G2Kdx6Oix8z7bHRscnJ2rA5bxXQD+P5fPtCnaQBjpZs1C+?=
 =?us-ascii?Q?VWEj4Zt0JzmscAdur9EgrB7VwqhbjdY+xEgpyo4gEFYBX+6GLe+UAQ3h9hUu?=
 =?us-ascii?Q?wZi8XNjlzPdESb5YjlV+kaKNe0KMgp+VNpcuQ9KXiXX/Q8piGEJNCqSzlJSM?=
 =?us-ascii?Q?Jc2N+37ZWpskqK3YCXrrFSzKLgJNbs2GL+T+NBoX11BzUO8uulA17yijascy?=
 =?us-ascii?Q?R5DycbLJ85sG0HBgs7VSE20TSJh1VclGUhBDRGYvBwab/0I5qKDqvDATcKFX?=
 =?us-ascii?Q?nqmqDchCG7Xv5hEVZC//7sEOvLC6pA5SkusYoV5Dggz/sBzj1L4lqi2x4i0w?=
 =?us-ascii?Q?bZrP342g3QQP+amAKaMFmDT+MvfTshVK9OM4/Mx8w3gKnU8VM6CdYeZPfOW8?=
 =?us-ascii?Q?xi3Prg1ttrb2Nq83QtzOQLUlj/Ma+DyeR/rvDH6DDpOtANm66TeKf3Qd2SPk?=
 =?us-ascii?Q?5HSbc2lUvt1nIbYS+omEXkA/biZR86E01SdjHxVB1MBx5Zj+0NJTcaDQ+vCV?=
 =?us-ascii?Q?omBGA3etPeGUlzaN5suLNOCVCKlXPiCapdOUsxIdmihDo+L23195ineJrVE+?=
 =?us-ascii?Q?vjGWJC8df1fFqv+JBO5BUMNJZvCo1JgHulSjZk4s6wXiSGAnuKzCbtToEMq9?=
 =?us-ascii?Q?VCJWWhxYsCI080PSaS1AhgqgRVrwf4/VfMhwQZF3gCsAOgz1HZ08jnkJBeNx?=
 =?us-ascii?Q?IhArNP8s9ySKMrWFaGSwmmUkxttVy9P09bWdqy0H3dGXLTau446NqCT1v3H2?=
 =?us-ascii?Q?y+9UoBR0PeYeiJcOLl1cMmKdPPOgU2UxS1na//Vr+mK6vi+NdYt/b9RpOd4d?=
 =?us-ascii?Q?q4D9aBQp8LvOeBZ5EysBrkoMUwzxciY1Lz0WopcrqtSPQ6iVDy4ls0gQoIrl?=
 =?us-ascii?Q?E15Xd2oiHedsZVNrZuAoulKGZR096Ahm21zHjg8/yk+fhvlMIz6GEtShA/Nd?=
 =?us-ascii?Q?NjazM3GLh8yoavVfw4S/A3+T6QoBpukmsL9hzA9YpCgqSXF5dyajjvgSVsfo?=
 =?us-ascii?Q?NUtnnDwlW0H3lQTSVlwwuaHY/mJb5cX1Jt6xKBnRHHHVdMb7k9VxVvO2NgKd?=
 =?us-ascii?Q?y/YyNG5u6WZfVwX2X0iz4rFgxbMv3g55X9gIwjOxTuMiGPF2IpuXW4Pa7Y0V?=
 =?us-ascii?Q?19HGJB1mwW3nGX7c3R0GS2mqKQhRvGrQqCm/MHnAISeIJYUdmiXqx1PtBzNx?=
 =?us-ascii?Q?8xJQBHrT7raJNtHg8hQoZ7iUNvQ0lJrCkBdVHyAb2Fh/LzzCuqtwPvYrdPOO?=
 =?us-ascii?Q?XywaZQLaii1ZZQ8rm47TlWeQhk35EbDdRrs7legyjMCZgWY248qFlv79IVEa?=
 =?us-ascii?Q?PLJTaoqS1l7FG6sGDFFpB822ZrooROOo2Fx2fhtuL8AAIDElMnZLNJa+W2wO?=
 =?us-ascii?Q?mE9eH7U9hI4BI4TlnNjTKPitZR+Av+Zch8uou1Rx8kajAI5Vn1BlYfoI/hyq?=
 =?us-ascii?Q?Z4rBz6AM4WLyeFdLY5OeoxbPyBFtCGZWF9fiOfHQ?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a7eb9a53-d693-4ce8-5ad7-08db2f4c93fb
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Mar 2023 05:23:34.9802
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tAbc/0xp3p9jqRBDGV1xYKHKUwnpUDxcrxjKA0QHe5/6MxrWI371D+QcJkw2wNXfCjtQmi1btDO51vmEdaqLWw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4782
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Monday, March 27, 2023 5:34 PM
>=20
> no need to pass the iommufd_ucmd pointer.
>=20
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
