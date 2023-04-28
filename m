Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B13CD6F143F
	for <lists+kvm@lfdr.de>; Fri, 28 Apr 2023 11:33:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345616AbjD1Jdn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Apr 2023 05:33:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230053AbjD1Jdm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Apr 2023 05:33:42 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3474140DB;
        Fri, 28 Apr 2023 02:33:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682674420; x=1714210420;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=KQTdUJAY6LXd1F6KKtiR9Qor66UqRPUxQL5dHgX+2+Y=;
  b=ciewnbI1Y6vhE5rGUn8mFVNN0KjGZ/LNkcPn0DhxAsKsuSUs0YO2BMl3
   6Qof1vdo5Vj/1YmTphSc1e0e5iEfvsaERP8/Kx0M4X0yArIa3a06JgujY
   p5QL00DVh8rrv+wCCA0FMhgzUGMDWUuEV7GiY5j2Ot47RgHo0gGlEf6OU
   fTQyXmtTmulE3bveyakV+ZDye2HBPqBlCUncdBWTFYqyKWGsFzxzze6ey
   r03VQ5lg0iWXkLPAd/unT8/9Z24du/m5lt49xZYEzHuuh+p5yNmnyNAJR
   GwD5yhwjWBQfnO1luuOmCpkqYm3cYeLYVJ2oAY+/d8pfds6q2pxHQTTbt
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10693"; a="332009110"
X-IronPort-AV: E=Sophos;i="5.99,234,1677571200"; 
   d="scan'208";a="332009110"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2023 02:29:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10693"; a="727466702"
X-IronPort-AV: E=Sophos;i="5.99,234,1677571200"; 
   d="scan'208";a="727466702"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga001.jf.intel.com with ESMTP; 28 Apr 2023 02:29:42 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 28 Apr 2023 02:29:41 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 28 Apr 2023 02:29:41 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Fri, 28 Apr 2023 02:29:41 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.174)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Fri, 28 Apr 2023 02:29:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oMGwJB5fYbJlBsInC2BLr+SwGnDdvZWvXrjvHgdggjkLSefXipR5/ravqhDKlKQLlfMEEE0cHmwO0MjCj10zlSdqpy7Ytzij04S639KgtMJpgXipTrYdcW5bt62F1nM53QN+19Sgms0OtjsGCt6J8F/r3aGKPD1nGx1N7r/Tj7rcLBKYxruy2/HDppJUnP2q21hScDxGMKIOeG59olzthild+dGtwwNugziqiMz3gmwfaAE3iXBT/mFQOizVmxNg2OhObAX6vhfJ7LxFZy1yNs2G48nSNmyTr8Q3OI0XKrN+j1NCXqDVXnKMG0AiXjaQYSE5Cryu62TDr6T6Tx793w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KQTdUJAY6LXd1F6KKtiR9Qor66UqRPUxQL5dHgX+2+Y=;
 b=fZmnNMvev+1E3RX1SwbHUVgxkKFlJZPyZpr0H4zTTbQttaz4Gz/eIQwCRDSGr4g7jgAwjlEjPZF3oxFALt54J2BEJpnOi5C74/8jxiC6MD/iIwF4THW182KR5Pyjm0Bvvj0Okngywa8bY1rjI2KWPEzcDBMbLu0Xm6hzRJf0I4Hfay83EQw9fN/h7+2OAmtREOcuAH+5gGABJMRwuY4ZsHeZKX9YAZYRw9eZVIZBjpshl0Vm6Bf2W+vuEi6letODQwxNSe0XZHmqBEW2vByb6+98O1YX/mPWc1DtdHo/Vq1y391eDHzUgKFQhjkao203HXzK37MlSWeEyLEg3/GfdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB6763.namprd11.prod.outlook.com (2603:10b6:303:20b::7)
 by CO1PR11MB4881.namprd11.prod.outlook.com (2603:10b6:303:91::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.21; Fri, 28 Apr
 2023 09:29:40 +0000
Received: from MW4PR11MB6763.namprd11.prod.outlook.com
 ([fe80::ea27:a8a0:3e6:db89]) by MW4PR11MB6763.namprd11.prod.outlook.com
 ([fe80::ea27:a8a0:3e6:db89%7]) with mapi id 15.20.6340.022; Fri, 28 Apr 2023
 09:29:40 +0000
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
        "Xu, Terrence" <terrence.xu@intel.com>,
        "Duan, Zhenzhong" <zhenzhong.duan@intel.com>
Subject: RE: [PATCH v10 00/22] Add vfio_device cdev for iommufd support
Thread-Topic: [PATCH v10 00/22] Add vfio_device cdev for iommufd support
Thread-Index: AQHZeFBRt22apuS4K0ub6JTy9+/DAa9AdxPg
Date:   Fri, 28 Apr 2023 09:29:40 +0000
Message-ID: <MW4PR11MB67633DB179D9DD03E0C3F680E86B9@MW4PR11MB6763.namprd11.prod.outlook.com>
References: <20230426150321.454465-1-yi.l.liu@intel.com>
In-Reply-To: <20230426150321.454465-1-yi.l.liu@intel.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB6763:EE_|CO1PR11MB4881:EE_
x-ms-office365-filtering-correlation-id: c3a495e7-65c4-43f0-8cf1-08db47cb1796
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XxrmxKBaI5qMJpPZXlUv5Hvq4QaznMuqUYdtVyehg8an4pcWB3z0VKRkI+0gV+A+0NlLUgmUb5ogiqWT5bpJb9ko7P80pKYSKHVQxyZgSBt2VId/jHrA+UTPYn0nk65KHSK53J3QaxSqF0Ds+9OBwOEYbzjc5IBh35sGgJ7goSf6DG5xuOHa2vWrY6Lg+fSu6w4cXOuWiT8m7WYRgZWSCeOAcwx9vhMLRixRYqpr/wP2A0kgIB9tL/44Sk4P+fHyu0A61Es4DRJ2bBhFqOltFM8PvT0JMlcjpzqbt2SCwo9Wvi3TN3VrA/ZNhqa43TKj/knRDLquLli/hCrSGXM29I6XUVcHy+TVCALJNsHNSffm7plFxBqrQLGiEk9sNmOC+HbrG+21uJ/ure3HLZXu/UYP7bXaqWRPoIrE6ysDXZin8PMnWspyyk4TpYd/4VwbnpCxSUMqE6mFX9QvJwsoKJ53PwgIJhP87lvbqQ9m1qS7Yd1nZ19rVeDmiQ0RDl9qNmod2M2a7uhDKv564+eUoyHkLgYPZa4YZuPR1V1WSwcayOrr37mthKoX1aaV2qE2DQS0gtQSe5Pcs4q03ROEhEsXcxpzCi7FKKpsSrakbTA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB6763.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(136003)(346002)(376002)(396003)(39860400002)(451199021)(66446008)(66556008)(316002)(76116006)(66476007)(6636002)(4326008)(110136005)(66946007)(54906003)(7416002)(5660300002)(82960400001)(52536014)(55016003)(41300700001)(8936002)(64756008)(8676002)(38070700005)(2906002)(38100700002)(122000001)(186003)(966005)(26005)(6506007)(9686003)(83380400001)(33656002)(86362001)(478600001)(71200400001)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?iHcV9zXz/EESUKxlzTi9Ju5DFNTr/DQmveP18oMGj+ZgyWLWYWPqC3OiQpo9?=
 =?us-ascii?Q?bxd43XDMy/PSwkrWTETbkn0eP8gENCV4SrPx0wWNQcRl5SJXnS3uS7OY69lj?=
 =?us-ascii?Q?/Wibqst8m7j/A2GUyedY3+tp1lFkj6ZTAPDbJuRs6CBmvpIyZYHuJ+3XvcoZ?=
 =?us-ascii?Q?EwS5g52PsZ/RUVE7xWgkAl/VWE45gZaSL+hZpWFbo5iEzJkrMTRgUol8eh6U?=
 =?us-ascii?Q?exDhx+TF0/PCKE24bEOp51Khd1HHQzxqdu8ovZzuVlJ7EeYmX0mlYaEC9Sya?=
 =?us-ascii?Q?Cvtjl8lU/t6UfhBUs2pWLZJT4NF76DCSebEfriQSX74zuFWZLtgrvNBgCdv/?=
 =?us-ascii?Q?18nNFwZoLHxBHyWPuWzy34O0hW9LZ7sWTBCGZQSFLjTvR0QUZ1GirUKJxc9g?=
 =?us-ascii?Q?eJ/d4fZN6luld33CchjDwI3uhLgRGyHL10YfU8s1qmGeDQuwpGrmZKKDhbNC?=
 =?us-ascii?Q?4cjBVua/u4xFqygpfs/luDv602V4VsXohJ14h7T/woeR82oKDRdSYPL5JCGN?=
 =?us-ascii?Q?7Ccv4v4z8o0IXn5XWhCv/u4bAJDPtVw166km2MObWyqJmYqmAelSZkeSFwPZ?=
 =?us-ascii?Q?VThverGKXkK8wlEMUroJf+X6YKVB1/MlOobeznbpORP4PVMw963LQGeKgIOU?=
 =?us-ascii?Q?M0iv8t051semyKqKy+THZ9ufIQpo2SZ9dWcmRbPzAJtfdJzs6V4CqeafbItL?=
 =?us-ascii?Q?sNpmomPyG5T81Kw9ZzywZt+hYKxr62FGK/hz6K5H9DRg1XvThQZloImT1+tu?=
 =?us-ascii?Q?44tK7DY1zTTjisQfgibZ8XhUMbAHvDX8i2YcLEUvRDhmqEeiSKk/lstUej4p?=
 =?us-ascii?Q?ERq2p1bhaH9n6YW/+glUW/MU1IEBo/sGOI1ammrZvfQlIwSsz76uyEwJMcjc?=
 =?us-ascii?Q?NyiF9sVgx6a2ybXXDKTS8SN9q9gr+IEcNLblc4VNiWRCixqrfs14ywn/Vs+z?=
 =?us-ascii?Q?Ut9Htq0Cu/msBYjpoTiB0a4LxBfLI73BuqsUGYlRVbhSPpQFm3dAnZr77xLq?=
 =?us-ascii?Q?y0SOCidWQJuFYIq4rubh8xLIYq6kTOiK7Bic/XUvHK36c0yflWX/oaG/NIge?=
 =?us-ascii?Q?am4FZTM88XAGNauGlT79sHIrDoos4czZKTVpPlO+2to2oYN6GYygCqE+dPN0?=
 =?us-ascii?Q?IauIO1IvTMQvdIUYJ99/1YEUnAZ0m+ggFfiU4WKgwMmuP5yWiJVkmqnA9xnk?=
 =?us-ascii?Q?nIhAJsVzzO8tGDF6wgUgsYWvkeqxvaMsSqNIkxcdYPHjZ5vxyL7ovVdQdkma?=
 =?us-ascii?Q?9sPqw2h/I5miCbEw/pTP9OkZsPLBrtJZcPZxPGSGX1LoB6s+2hdyCAYbzxY5?=
 =?us-ascii?Q?EFUqST7+6T//3vZQkiP4OZFsnJUe4SpV2GSYcLub9smWAdHlT2bbdvKOGEBa?=
 =?us-ascii?Q?h6QuQujgLcCKcSzvD1RUmDUsInnG//X7VYqsdXu97lOLyzEFmKTIimnd4wrX?=
 =?us-ascii?Q?ZOYm83rlDXcynyBwMwEGl9C8cm0hf6lNA5dmGINqSpazkw/g7n5Ni4tkkL38?=
 =?us-ascii?Q?4gWNEFwYaOjJhhTHQ8ylFxeP5ep7AYVqMeHvP9c9KkS8AwDSMLNqshfYypma?=
 =?us-ascii?Q?hNiNsLXK+G8uOOt0o5vIl1rTU5xmrID7OUlagHaH?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB6763.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3a495e7-65c4-43f0-8cf1-08db47cb1796
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Apr 2023 09:29:40.2413
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dgU2uSyHldWnFXb3L5tOS4XQzXF3R4xDoiJEwVvFNoA1syYg8wKPyzzGMf2W58f+4NhK30+gnR6h2SlpZQK71w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4881
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> Subject: [PATCH v10 00/22] Add vfio_device cdev for iommufd support
>=20
> Existing VFIO provides group-centric user APIs for userspace. Userspace o=
pens
> the /dev/vfio/$group_id first before getting device fd and hence getting =
access
> to device. This is not the desired model for iommufd. Per the conclusion =
of
> community discussion[1], iommufd provides device-centric kAPIs and requir=
es its
> consumer (like VFIO) to be device-centric user APIs. Such user APIs are u=
sed to
> associate device with iommufd and also the I/O address spaces managed by =
the
> iommufd.
>=20
> This series first introduces a per device file structure to be prepared f=
or further
> enhancement and refactors the kvm-vfio code to be prepared for accepting
> device file from userspace. After this, adds a mechanism for blocking dev=
ice
> access before iommufd bind. Then refactors the vfio to be able to handle =
cdev
> path (e.g. iommufd binding, no-iommufd, [de]attach ioas).
> This refactor includes making the device_open exclusive between the group=
 and
> the cdev path, only allow single device open in cdev path; vfio-iommufd c=
ode is
> also refactored to support cdev. e.g. split the vfio_iommufd_bind() into =
two
> steps. Eventually, adds the cdev support for vfio device and the new ioct=
ls, then
> makes group infrastructure optional as it is not needed when vfio device =
cdev is
> compiled.
>=20
> This series is based on some preparation works done to vfio emulated devi=
ces[2]
> and vfio pci hot reset enhancements[3].
>=20
> This series is a prerequisite for iommu nesting for vfio device[4] [5].
>=20
> The complete code can be found in below branch, simple tests done to the
> legacy group path and the cdev path. Draft QEMU branch can be found at[6]
> However, the noiommu mode test is only done with some hacks in kernel and
> qemu to check if qemu can boot with noiommu devices.
>=20
> https://github.com/yiliu1765/iommufd/tree/vfio_device_cdev_v10
> (config CONFIG_IOMMUFD=3Dy CONFIG_VFIO_DEVICE_CDEV=3Dy)
>=20
> base-commit: c3822365940319ad86487cc1daf6f1a4c271191e
> (based on Alex's next branch and merged the vfio_mdev_ops branch from
> Jason's repo)
>=20

Tested NIC passthrough on Intel platform.
Result looks good hence,
Tested-by: Yanting Jiang <yanting.jiang@intel.com>

Thanks,
Yanting

