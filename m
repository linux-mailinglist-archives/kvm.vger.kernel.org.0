Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25AD26C3538
	for <lists+kvm@lfdr.de>; Tue, 21 Mar 2023 16:11:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231161AbjCUPLi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Mar 2023 11:11:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231588AbjCUPLd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Mar 2023 11:11:33 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CBC54200;
        Tue, 21 Mar 2023 08:11:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679411480; x=1710947480;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=8Mr0E/A0V14vIqkGownDIzP1BJl8G0qBWHJNsHvOR2k=;
  b=Wj3Ua5YpmNYbKBtmEoUTyEx46L+zcw5U/fHxpYGjSGK42Je66kpYpSWa
   c86vv+zcJ7bTW5/iq0IBLbM448MnQEN/bauGUAZXLUflVlZldXgnQIX8G
   xCwmrktJIqYPKyn3lMrZyNFL/dU2lTijZAAWUMWp4tz5lOQL8TRjfDeGF
   cMvXD29nJGkEZCMY0xEm62GrX5sgr2yku+oBewMJr0rXRV2Go3mNRGJ5o
   vrr6KkQz2BGVThxBlWlpDKC75z1OiKWdclz0PELIWXgRf25W83/nY3Bk3
   KtQMrnxFBt6cq1wkuxVLiTTN0n0keBqhwZgoU4ZYY+FGfsANzbTE1fDfw
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10656"; a="337688022"
X-IronPort-AV: E=Sophos;i="5.98,279,1673942400"; 
   d="scan'208";a="337688022"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2023 08:11:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10656"; a="855730640"
X-IronPort-AV: E=Sophos;i="5.98,279,1673942400"; 
   d="scan'208";a="855730640"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga005.jf.intel.com with ESMTP; 21 Mar 2023 08:11:19 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 21 Mar 2023 08:11:19 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 21 Mar 2023 08:11:18 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Tue, 21 Mar 2023 08:11:18 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.109)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Tue, 21 Mar 2023 08:10:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B85gCn+kgunL9KRom1CURX9B5bYZ5vRh2zS7yvXV0dcRZcBaxsjjYmrIXKMpRNS8QHYeSfEvGgTwn0M+17AyFbhiB+I9eCT+BmlDo25nTpvZUQBqyarhh4iwthWWFHD0wbmtHPBUQjW+7HcJ1Nl0atuFbR49LJsIfF35g5oiJOezO5jq+V5u/2peykcXuPhaYkO6Tr0dNHAm65+g/7FJzUAH6JjBF8yIMUZAEfKfR77XEuW4YObJhvlE20h0uEDRLh5iOAlWXt/GvSuI+3Go4rlIEYgnXXigZIl384TOTznL+hc8kUL4jlvvjHAMgmI2Aq+/qxRZztrgPAnf079r+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8Mr0E/A0V14vIqkGownDIzP1BJl8G0qBWHJNsHvOR2k=;
 b=DVV/Xb5zxpJOQphFQnkK6Ku5Z/AsthVbWVWEuXp6tvNP5gc2UPuDsIk1GycsA1GtwlNGLLU/bbq+yIdyEJB/1cXqVp6aLk8AI13+dYBB0pNzXLVi9gVgxFpTwtkFa8wy0XmNb4FKSkIUa7cNPbUfjDMt2cC3u3KEgKQz5UkQMvh/58bjkbryBPUvsp+rpnjV93iCLvQwtAKKvzgFn+MFaN4kZyHiYNhGptsq21p1ilP1oZORavo9vAvXxqTSVK1MR2Secfw+MfU8mC4CY+Fh57BUWjxfeGFTQ56Sy2y9LnoEbZvnJeDmu35I4Z10jez0Zw4w8c4vA/blcCfCWNgZHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by PH8PR11MB7120.namprd11.prod.outlook.com (2603:10b6:510:214::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Tue, 21 Mar
 2023 15:10:51 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f%8]) with mapi id 15.20.6178.037; Tue, 21 Mar 2023
 15:10:50 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     "Tian, Kevin" <kevin.tian@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
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
Thread-Index: AQHZUcIP+SZa7TzGK02S6HlHFxIIra7zumiAgAAAm6CAABGNAIAHfd5ggAh9XYCAAAYegIAALgEAgACKCACAALARAIAAKW1AgAADXQCAAACcEIAABCWAgAAAUjA=
Date:   Tue, 21 Mar 2023 15:10:50 +0000
Message-ID: <DS0PR11MB75292A7271BFF456B275B4DAC3819@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <BN9PR11MB5276684B2C0CD076FA3CD0938CBA9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <DS0PR11MB752922A0C9058583F677369EC3BF9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <ZBhpNyrBr9nm5Ae+@nvidia.com>
 <9875e60c-68a7-b360-9d52-66d4915808a0@intel.com>
 <ZBiU8KoSmiM+JkAw@nvidia.com>
 <BN9PR11MB527605E6609222431DFB8AA58C819@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZBmcbMuE4lyDIpT6@nvidia.com>
 <DS0PR11MB7529569D40415AA283E1EA55C3819@DS0PR11MB7529.namprd11.prod.outlook.com>
 <ZBnB/mOIvzYEPdsj@nvidia.com>
 <DS0PR11MB752959B246705258EEC4109AC3819@DS0PR11MB7529.namprd11.prod.outlook.com>
 <ZBnF+6mestV2tCiQ@nvidia.com>
In-Reply-To: <ZBnF+6mestV2tCiQ@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|PH8PR11MB7120:EE_
x-ms-office365-filtering-correlation-id: c20e656d-9c77-462c-fccc-08db2a1e753a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5Qc3C7epSab8bcQv5DsTuoy8AV6T5fPspoiTFXHcq+TRo6UiPaq9Z52rvsmMslfMAJKAZCd9basK/kXeQxND+0m1kTScAezs14GOfMPCB6mWW8wckKV983iYpAVlHIBneA6rPXe8iAeQaGmbMfwt6p/NRkS2oVpOtIK4L3EJ5H/cvcFHilb5bwIPVSbfs6QhMfapOOdgmVxJtOniOM4SoBBOMW83eIl0DanahymjaTjuoZThkky9OdC+UYsi7NMcYmkwxPPEOocE3JBxcpa8PCNtc9JbMzGL1sGA8OS+weHRumHt7GOW+DFIJusxzACYpn6X1M+P48zSpP/EYJLpLTHS0Btiv832PiPYmwidwAzd9gJ2Hc7wr7WVLDZiSVmq1m6esYa/0UCjKmqKk+lwIY4zQtStWbvmG2wphVdMBUH+9XrVRozfiIjWEYl+ztf0Y+w/6g6kTIuWFzQqKxW9z/3ZU/EKBQ/8z9lSekVscRySRY5yrpP2VxceKgmJppNMYXnqHY3ovH2ibWgstaRytZBWMgGmvlah7RK/aY49uj+Csti0YI0KSgPdbr6Mmov7Ya/POldLx2lQOSGHbjQl6N2fWjIKQM1T1wWuGSZEuN0/AUmm6wR0bKi71pCJddB02v1tM/86Lt63F0gxXO5dp1lYNy/34fMVoc5X5sY5wCxEHQykiIG9RuMJgjCkOh027ereD+WlrKfAE/l2fPujzQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(136003)(346002)(39860400002)(366004)(396003)(451199018)(38070700005)(86362001)(33656002)(82960400001)(2906002)(38100700002)(122000001)(8676002)(41300700001)(6916009)(4326008)(5660300002)(7416002)(52536014)(66476007)(64756008)(55016003)(8936002)(9686003)(186003)(6506007)(66556008)(66446008)(26005)(316002)(66946007)(76116006)(71200400001)(7696005)(478600001)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?+hBoL8CCd5ar2gvgp5uH2RVI4m75rRF5vu47HQaX+xxw6FaQ4Q9sZ1WX2/2f?=
 =?us-ascii?Q?Ee8gPrcKEx1XCBY/44oCJZGCRQ7EYIemc6HF/HD2JpM4S6WbvVwtA84BN1/K?=
 =?us-ascii?Q?g6iPHIvgoYYS2LXf6Ytxzxpw5/fOK6Fq1pS70Slu5qu83cC8YZ3ImmAYRrkM?=
 =?us-ascii?Q?E9MuZSmh4np1Z1Hk9KMTj+eJ1Uj51PwLnxZX1wnUujUGyaUD3DrQ7LqNB0Ux?=
 =?us-ascii?Q?MgBV5U7mqzhkhG+UIsS+svJ4EGytO/no4KTffQjUBzMtVrDlprvVB1a/NlYR?=
 =?us-ascii?Q?wT5EMHI8MwOkj//e6+dBEM22NlYae5KoOCwMhOUKpZuy0p1ux+EE+V/avqJV?=
 =?us-ascii?Q?rb8zb77+Z74QUSNk3+j6tPemqvcvbtiq43LZ33QsZHklGRfn6IqQb0ax7vUv?=
 =?us-ascii?Q?6mfF7VynEfeLfAhez+65o7w/KR0HEnjY6K+paaP4FEXQkz7lN9J4WuQMJgKc?=
 =?us-ascii?Q?pkAHR3KZTDR7GsjKZ/Sbs46lRPUwjMRVr97/B6gQ8yVm2OlvQmg7N63DTUYJ?=
 =?us-ascii?Q?Uy3tSXNYmp5imEMpnJXhRlKwBNdpR6ZYqkocPXso/TnllULddFnhbTUvSZ43?=
 =?us-ascii?Q?CvImH60kuBrLU9sqI2V/1uaRJ4hjmEqnl5W5t/Kv5vqHYvqWKy4l0eHmmgGD?=
 =?us-ascii?Q?sN4ofdacVKxYN8h9UiilYfPFgzqRVlep3YAEG926J4u7ezDHOOxV4x9wXeh2?=
 =?us-ascii?Q?xZt3nIZNavDQ8rEfx4N+DR/xdINnU6e6pGzKsO5zqI7MYizRqqzK3e322Po2?=
 =?us-ascii?Q?iCBeqj0Dc00gLPTtHswagmAk8L2xAQx5s8dL0R6NfXOM2qqD/FqwbP72dcxq?=
 =?us-ascii?Q?22qSHtk8xlPPddOj8fCTE1Gf92EegyhbM78UiIc7EWcks+yEGvsOpg9vgzq+?=
 =?us-ascii?Q?Fc38xx1YbO0RGOocxu+4z7T9aexwG24Skl7D4UUr+QM5nbTeGVXqly/22KpX?=
 =?us-ascii?Q?5rTrNB2xj1spxEqWTXiOC/tQjPIIh62DSI4WBFtIjw/m73vjfpw3BXFbftWS?=
 =?us-ascii?Q?by3yLwaiagyUYIxJ0ckoMr9tu/wqDYHmuB7NCg8/wB7BoQBJAykDyaOptT73?=
 =?us-ascii?Q?LpSuYZkSv6Q3abrTIfbGJNzfQO+2n7Bm2uc9IzvGaICU+cl3lxdBzop438IG?=
 =?us-ascii?Q?TS8TMZJPliPLPGj/HBWyfYZFHKhs8NcfLGLcyr1lu+E5mjyY+06LF6WQ4v49?=
 =?us-ascii?Q?c0R3YXg+X36lz3cS6sTEUYkihQ45zahLBBPVRU3Y32w44NRRiROD8xKFtv6D?=
 =?us-ascii?Q?jphmiTLqD5wHyxf7JQXIteLYRT2a2Y95YttWyV6fbW00qpMBihABxYO59hN4?=
 =?us-ascii?Q?CCAM5+67SUbbaHAGpp3E3SuMqqzexcpWGSRaTQZ98aVxWvNocHKVQf+Qj8Oa?=
 =?us-ascii?Q?rjBhX3QTj3Fisd7LO7L2cGFIL7ASNV3CG6BwaGcNizKVSYWjNNh99qySpY6z?=
 =?us-ascii?Q?trvpd2bN8hYBM/ioPfLqdJJts+ZWk4HNjmij7fvfpmtD6BxM39pXaNkF0niK?=
 =?us-ascii?Q?RTisBAzRu/1DMW/FiUrGxpH1ngDIwh2PVwcAPO7Lxk33yTdZCaFxKKtIfixJ?=
 =?us-ascii?Q?K1QfEGjMdJuS1+SO5+1246Gl9956sr6wEdU+ZjbS?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c20e656d-9c77-462c-fccc-08db2a1e753a
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Mar 2023 15:10:50.6617
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: e30dDvn/DWalJoL1PSjyhYy7/rsaipYEv90GMaMdLB7278bLuhwWPSLr44u+OjZXcwzVmXObgZIKswdIC6XLqQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB7120
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
> Sent: Tuesday, March 21, 2023 10:58 PM
>=20
> On Tue, Mar 21, 2023 at 02:51:20PM +0000, Liu, Yi L wrote:
> > > But still, this check should be done at device creation time just lik=
e
> > > in group mode, not during each attach call.
> >
> > Seems like requiring a noiommu_capable flag in vfio_device. We
> > set this flag only when the vfio_group->type=3D=3DVFIO_NO_IOMMU
> > or no real iommu_group (for the case in which vfio group code is
> > compiled out). Perhaps the below check should be added as well.
> > Then in the time of bind, just check the noiommu_capable flag
> > and capable(CAP_SYS_RAWIO).
> >
> > if (!IS_ENABLED(CONFIG_VFIO_NOIOMMU) || !vfio_noiommu)
>=20
> Yes, and also only for physical devices

Sure. BTW. in the time of creation, there is no vfio group yet. So may
just check if the device has a real iommu_group. Another alternative
is to set this flag at the time of vfio_device registration. Physical
device driver and emulated device driver uses different register APIs.
Hence they can be distinguished easily.

Regards,
Yi Liu
