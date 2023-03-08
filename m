Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC82B6B0065
	for <lists+kvm@lfdr.de>; Wed,  8 Mar 2023 09:00:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229960AbjCHIAp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Mar 2023 03:00:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229844AbjCHIAk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Mar 2023 03:00:40 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A92A8A17C4;
        Wed,  8 Mar 2023 00:00:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678262438; x=1709798438;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=EYlSgWRRLSTDjIiA1K2dIJiJIXB/wzI0tDXBvWnSBO4=;
  b=W+Qm7/lx0RMSNBcLEFGAofSvCNvTbZSiGwmYd3E4fEE6eCZLHjtXDCbu
   /8usXNPHJvTqjSMhETRvMeWyI+Z91B1aTGsYhFX9+t3sGH3p3cDYfNPHD
   1uIBnqk4pVp+NS77OeBIhooi7TpVBJSEuVldakfzowTgvbn+GJ532q68m
   myezKkKoLnQo7GQVt2ra+JwIheKiTvigMEgH+UkMgbMyhmPAlo448hMv5
   NLzqevNhxyoJFPYbP926SHx09zBHm0o2I5LU40w8JdX4vO6lQITAP/le6
   dZjXTl4hLmB0R6liAXaAQeFp+x80gHO7FXgvIhXJswTtBUM/4FmUnrcRY
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10642"; a="319924288"
X-IronPort-AV: E=Sophos;i="5.98,243,1673942400"; 
   d="scan'208";a="319924288"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2023 00:00:34 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10642"; a="707094580"
X-IronPort-AV: E=Sophos;i="5.98,243,1673942400"; 
   d="scan'208";a="707094580"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga008.jf.intel.com with ESMTP; 08 Mar 2023 00:00:34 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 8 Mar 2023 00:00:33 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 8 Mar 2023 00:00:33 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Wed, 8 Mar 2023 00:00:33 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.175)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Wed, 8 Mar 2023 00:00:32 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=flF2x+3J0Izbwl6PPz4C8+PzJw+629WQhy5sAWKT+aUF3MLUPiowkttSuOEj5adOU5kNM3Iq0t5izavuRbKiQf7XqjTHrQ53vdLvBpgdUeG3et/JYZQqOzLMGJNe3T+CQiN85OL/+pjX1hKs52WamK4t3zygpC6Bdl/h6nttpKUx8yITDmkwbof9uySXOkZOvNWad4giy4eimNQy6N8LVHvBAN73F9LLBT9FHhiN/VgIdNbY60XZUdlu4M55jCPcvq9NAzeNVl4bzXxyIR6thLYBQRIIyzioe5Yxj9g7ADfqk8EPSpYDS0CUc0oTTVbV4N0Ai8gX9uYk2aSVv98XJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O5uarR8WTJ+rLJvJy4zEmyFiTkEfq0xeGZdg0Ma+BNA=;
 b=dAdKUZGI6hfLOCwrXd0qTNQSCgECqgH3mu+zxEayofdVFbrPpPVSJBycpIpEk0nY8ooneDn+0NAQse6fNImJQ29WBzE6lhr9AT0YnAfCxY/s7U+PRzUI5ivfqVqbb008XGVjTbb0iWs9VRQhmkTTZkktZi6N7kvLOQu8zgeRNs8D7yJ3guO50VfGaT2rmFgZMhEs41ud2BKcFdIv6HO4ObjS1FpdgGCZc/ZinxhuVdPflfk8QKUyr+ilVhPKV29wX90tQ7HkO8XB8CyjyZEArggD/twlgV7ZzYpfXy59SxmxZJBzAegeB91auvwDA2VnJahb1et7QwyQcjIC2xLg4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by SA1PR11MB8351.namprd11.prod.outlook.com (2603:10b6:806:384::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.17; Wed, 8 Mar
 2023 08:00:30 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f%8]) with mapi id 15.20.6156.029; Wed, 8 Mar 2023
 08:00:30 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
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
Subject: RE: [PATCH v5 09/19] vfio/pci: Allow passing zero-length fd array in
 VFIO_DEVICE_PCI_HOT_RESET
Thread-Topic: [PATCH v5 09/19] vfio/pci: Allow passing zero-length fd array in
 VFIO_DEVICE_PCI_HOT_RESET
Thread-Index: AQHZSpxNz0d7VXviIEytrFhyB5GUvK7m/3jggABFoQCAACyCAIAAGw8ggAETHYCAAKz6AIAEeeOAgADd5oCAAKkfAIAACTyQgAEyYgCAAATW0IAAAz8AgAAAarA=
Date:   Wed, 8 Mar 2023 08:00:30 +0000
Message-ID: <DS0PR11MB75291E848C663CEF67B1781EC3B49@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230227111135.61728-1-yi.l.liu@intel.com>
 <20230227111135.61728-10-yi.l.liu@intel.com>
 <DS0PR11MB75295B4B2578765C8B08AC7EC3B29@DS0PR11MB7529.namprd11.prod.outlook.com>
 <BN9PR11MB527688810514A262471E4BB78CB29@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZACX+Np/IY7ygqL5@nvidia.com>
 <DS0PR11MB7529531834C0A9F1D294A5CCC3B29@DS0PR11MB7529.namprd11.prod.outlook.com>
 <BN9PR11MB5276B825071A4819479079A68CB39@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20230303095542.2bfce5c2.alex.williamson@redhat.com>
 <ZAXny4NDDq42NUxE@nvidia.com>
 <BN9PR11MB52760ABC93BCE7FB53A131038CB79@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZAcvzvhkt9QhCmdi@nvidia.com>
 <DS0PR11MB7529A864CB1C149CF8B19E78C3B79@DS0PR11MB7529.namprd11.prod.outlook.com>
 <BN9PR11MB527616204417D92A1BEB5FDA8CB49@BN9PR11MB5276.namprd11.prod.outlook.com>
 <DS0PR11MB75298BD3EB872C938F86C96AC3B49@DS0PR11MB7529.namprd11.prod.outlook.com>
 <BN9PR11MB527659E9DF1849873ED089DE8CB49@BN9PR11MB5276.namprd11.prod.outlook.com>
In-Reply-To: <BN9PR11MB527659E9DF1849873ED089DE8CB49@BN9PR11MB5276.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|SA1PR11MB8351:EE_
x-ms-office365-filtering-correlation-id: f5d8def8-1ac8-4773-e330-08db1fab2fef
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 34ogmcQ++gp+NuL7g5MVKYVRWCjmLvli2gTtt+A+JgxP9mg1yPFwsOnCKI2Xa+hLt+MZFyclbKEqRdigi/U5sbjoizOQHR8Mwkl+Q+zNXY1NyTZqppeoeuvDKaie5tClikxQP0SqgRn52nlyH1ThtLhpp1sJOasQMQeQFBRJcxOFW8Vv5BsUjRp40BaU5qjvsXNXvD6sxrrU+ejZbOTe2NnOON0YQhLRc+aEwZXeqh0l7m95H7diQV+y2fAhJgDQNBhcKHg6FRwullR4VtbdgomTNmV4vg6lLkbxx8trv3g1LuZ9OqORQD9fAbsNxgjI86l3FxnMALbo5gek7Y8WQuva1MZiRvDrNxK/qMBzzU63ablrNpTN1OljoN5WXabhf8KyLz18C+ytbl7PwTFEweOjgmkhp+rIPh3dJoQZX+XVzFZrMDNuk1TBusqh+d/nTWcmQ7kCUUYnfPYmcL6wNuu2OH7VnZ5O5N28IUooeg1eLHAUBb7KRHv6+sU5PSNPm2crFzWlpuH85zWMR8UQ3KYK7u4/0ca/aXtbJdDMOHMP+tN1QPVaHKjUJcCzhifYGgIzvvhwEcRjO14o9VSTrfYu1O1OoujB9vAHmaszjXwVpMBuGeWxWCzfqfB64Wr0h0I0FMekFsOfOKwHgLvBTn4jI+kn18aMpLUrfjFE4r0tpFPVpkzfaW/yV2c3FJj9MZkfB2SXCedq5c6P3MHVcA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(396003)(39860400002)(366004)(376002)(136003)(451199018)(33656002)(316002)(4326008)(8676002)(66556008)(66476007)(66446008)(64756008)(76116006)(66946007)(55016003)(478600001)(54906003)(110136005)(83380400001)(7696005)(71200400001)(38070700005)(2906002)(9686003)(186003)(122000001)(38100700002)(82960400001)(26005)(6506007)(5660300002)(86362001)(41300700001)(7416002)(8936002)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?7g/PxxQQ1NwEV5DRHzqstNqDhqYZdf25J7T2EmfXiDoJkgeIGhGguP1MBB49?=
 =?us-ascii?Q?gDOASaY+0uVmYKYwzsV1JcX2JQ46pALKmGnPBCQcuC6UUYmWNTyKKwfH5WmS?=
 =?us-ascii?Q?DoEQGuL+QsSjawDZas+MzE/oIRNyn9BC4zHlEFSUGtGUOJCQwp8o3UyYqhPP?=
 =?us-ascii?Q?6sf7FoEXyO8dUTb7sw3MPOb6Y1krQWZhNhaa9S5qOVKi7IQpaOZyk+owXAl+?=
 =?us-ascii?Q?0I9z0Pl5YMdLGBjGj1Jyz7A+ZY2uGfcNOdDIj8R8v0JOqPArZJ6+i4ajve/K?=
 =?us-ascii?Q?qZby1lHkoKsViLTLd4kxygryQVta1diNTbO5DASHJ8ukMEEUf1PkfKu1YHkt?=
 =?us-ascii?Q?/nfPKuKT+MyiWxhFXLXhCj+dEVOkFUqJ2SCCvKpM7Veafvzrden7j3/DQEDt?=
 =?us-ascii?Q?bEka7Je2QKn4DaGFosKvx5lx0+ajq3dIjjKLHwHjwpHmZlXVmp5pklm16urX?=
 =?us-ascii?Q?tGAQvYktscEa8M9Z4y/TYi5VKbSb8rWzYNt8B/gUNSdQMTPdFEqFBQYx752e?=
 =?us-ascii?Q?PU2pWp+rNXK4YL7UcjiqCwMi0qHaN2WbtHcwsBeZnbpSdMXHURkjQ1UaEsNQ?=
 =?us-ascii?Q?QwxBwOPCbyASlAITwOCLN//iVVwPZijFwQeXUAQhp7XiYH3oa6RMIEv8D/8s?=
 =?us-ascii?Q?rHU8KGrkfas3VkObFFNroGma3OveCah+XEQorSYoYyvI+h0Bqjl0OU7dNxNa?=
 =?us-ascii?Q?bbxKt96wK9lX6pZyd8Ti6k53zFOjybW0Gb2jN5KBUqP7LKcN4IhBq2HWemIq?=
 =?us-ascii?Q?9Hi/djaowjkY/fZP/9iCsjkCyRlb/Uuje6fn93ixdmWx+AmmKnRjJqhKHIUE?=
 =?us-ascii?Q?tKKAQdAUnKzERvSPj9TkHQ+yJlHOsn9PsU4fWIoFE29X1ZpDdGZoz/sT0XtJ?=
 =?us-ascii?Q?OwjHXsXDpk0Wkc+DuFAF0AfCud6XupNQCuqx99Vv+SV3XeuYY0tDqIDJnpaf?=
 =?us-ascii?Q?Tfn76DaiO7RR1ZQFL8YQdnT6gVCDWv5ivTIAOC4TvODr+6DIOCjUicbgCOxj?=
 =?us-ascii?Q?2QW3/qNaCxcttwZheCxRVJEplSbmeWkNEX2Z1pln9kR8GxswQrpbytMg+c0o?=
 =?us-ascii?Q?qN7QAq9/Js9lXbdBcO1gSq3RpWfiGGm0nlD64cuJCeh6AKRDgvoqTYM7fefv?=
 =?us-ascii?Q?XeeQbjTZQruy+0LciV4gV9USjBVnS7crOqc75Q1vnh9i5RpRHJHe7JYSoOyw?=
 =?us-ascii?Q?8r622n/MVTv31CM9jlEhKQKNMMptq2Hw+FLjwHY/CaiDkViY5AI9jjkxZKJX?=
 =?us-ascii?Q?ocCBvSidTxbOmH8Q3w2y1X1rSuy+p+tITPdEt/3hIFHNTyvSWyQp9hObX1/S?=
 =?us-ascii?Q?suwymrxYwjxKaLm5a4wzsV2lcaM2msk31qmIuzZb4NMkh3pvejo48AbOJE2Y?=
 =?us-ascii?Q?m9RvKDnZJpLmnQbczYjMg6aQ3kA5b2go3qUuwXbLXQYjnLKR6aZ8K7YQZZVo?=
 =?us-ascii?Q?GNL0iJOCuk/8HUC4uuMyRq9p4348vO2ORiwhLl9PDNdCc6/HWhgPzHAdsv9a?=
 =?us-ascii?Q?Ng4OmH/SkwueuHl69vrZp3KOu9efjpEZsmJRo11x/VMAbz7UegxIBky8F84H?=
 =?us-ascii?Q?AHBV6IjUSHqiN63TuS18Ay34tI5jHbAkOLlT0Phh?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f5d8def8-1ac8-4773-e330-08db1fab2fef
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Mar 2023 08:00:30.6551
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wG98g0IgJm5CIDqh15ZLU91d2L+0TTFFhTUjg4VGorZI9MBlLerE1lh0thycebUH+Hzf5Zg6az66yT63F1gbWg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB8351
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Tian, Kevin <kevin.tian@intel.com>
> Sent: Wednesday, March 8, 2023 3:55 PM
>=20
> > From: Liu, Yi L <yi.l.liu@intel.com>
> > Sent: Wednesday, March 8, 2023 3:47 PM
> >
> > > From: Tian, Kevin <kevin.tian@intel.com>
> > > Sent: Wednesday, March 8, 2023 3:26 PM
> > >
> > > > From: Liu, Yi L <yi.l.liu@intel.com>
> > > > Sent: Tuesday, March 7, 2023 9:29 PM
> > > >
> > > > >
> > > > > I really prefer the 'use the iommufd option' still exist, it is s=
o
> > > > > much cleaner and easier for the actual users of this API. We've l=
ost
> > > > > the point by worrying about no iommu.
> > > >
> > > > Hmmm, so you are suggesting to have both the device fd approach
> > > > and the zero-length array approach, let user to select the best way
> > > > based on their wisdom. Is it? how about something like below in the
> > > > uapi header.
> > > >
> > > > /**
> > > >  * VFIO_DEVICE_PCI_HOT_RESET - _IOW(VFIO_TYPE, VFIO_BASE + 13,
> > > >  *                                  struct vfio_pci_hot_reset)
> > > >  *
> > > >  * Userspace requests hot reset for the devices it uses.  Due to th=
e
> > > >  * underlying topology, multiple devices may be affected in the res=
et.
> > > >  * The affected devices may have been opened by the user or by
> other
> > > >  * users or not opened yet.  Only when all the affected devices are
> > > >  * either opened by the current user or not opened by any user,
> should
> > > >  * the reset request be allowed.  Otherwise, this request is expect=
ed
> > > >  * to return error. group_fds array can accept either group fds or
> > > >  * device fds.  Users using iommufd (valid fd), could also passing =
a
> > > >  * zero-length group_fds array to indicate using the bound
> iommufd_ctx
> > > >  * for ownership check to the affected devices that are opened.
> > > >  *
> > > >  * Return: 0 on success, -errno on failure.
> > > >  */
> > > > struct vfio_pci_hot_reset {
> > > >         __u32   argsz;
> > > >         __u32   flags;
> > > >         __u32   count;
> > > >         __s32   group_fds[];
> > > > };
> > > >
> > >
> > >  * Userspace requests hot reset for the devices it uses.  Due to the
> > >  * underlying topology, multiple devices can be affected in the reset
> > >  * while some might be opened by another user. To avoid interference
> > >  * the calling user must ensure all affected devices, if opened, are
> > >  * owned by itself.
> > >  *
> > >  * The ownership can be proved in three ways:
> > >  *   - An array of group fds
> > >  *   - An array of device fds
> > >  *   - A zero-length array
> > >  *
> > Thanks.
> > >  * In the last case all affected devices which are opened by this use=
r
> must
> > >  * have been bound to a same iommufd_ctx.
> >
> > I think we only allow it when this iommufd_ctx is valid. Is it? To
> > user, it means device should be bound to a positive iommufd.
>=20
> I didn't get it. Do we have a iommufd_ctx created but marked as
> invalid?

I mean iommufd_ctx=3D=3DNULL. If a negative iommufd is provided,
then kernel side only has a NULL iommufd_ctx. If so, the ownership
check just fail if it uses iommufd_ctx for ownership proof.

>=20
> >
> > > and with this change let's rename 'group_fds'  to 'fds'
> >
> > Sure. It would be something like below:
> >
> > struct vfio_pci_hot_reset {
> > 	__u32   argsz;
> > 	__u32   flags;
> > 	_u32   count;
> > 	union {
> > 		__s32   group_fds[0];
> > 		__s32   fds[0];
> > 	};
> > };
> >
>=20
> why union? Just renaming should work. In the kernel we will first
> check whether it's group, whether it's device, then compare
> iommufd_ctx is zero length.

this is for old qemus. However, since it's just a rename perhaps
it is not needed. The layout is not changed. If qemu imports the
new header file, it needs to update the group_fds in its code as
well.

Regards,
Yi Liu
