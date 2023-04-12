Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11A666DEC8F
	for <lists+kvm@lfdr.de>; Wed, 12 Apr 2023 09:27:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229805AbjDLH1u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Apr 2023 03:27:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229651AbjDLH1r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Apr 2023 03:27:47 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2CF530CB;
        Wed, 12 Apr 2023 00:27:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681284466; x=1712820466;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=5Ort+cQrsDe6YMfCvANZQfBJ7eGaNPYCu2nfvQf6jWQ=;
  b=UZ99nfLlfv+vp+kz58H1hxC4cRmwtRhxaKgNhN6uzQFs4ZrHpR5dkU29
   5aPcoFdYRw37y4MCNTZjA9Sh4sHC1N7J/4XmF/M5kOeJOlifjnrkHBziQ
   kTU2TKs7p9W3zE2JamOugjLsEyyFhoBUGafSSeCR5QCjRO/QzA9yPvVVz
   HmbxMLLpkJ1W/aqQG5sKDNijdgLha5yp7CnH07xE6fmGobmiidQHcSlhl
   VmtBf6WRMYBhy+efij0hCsLHi+L3hpKGM4KaEa+zFZfPWydzNQ/zC6+3p
   J6sRspRecBzfoOZOmVV62q2PinljPnktF59ivqw8g+jZuaUxAnJrqMdRI
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10677"; a="345618356"
X-IronPort-AV: E=Sophos;i="5.98,338,1673942400"; 
   d="scan'208";a="345618356"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2023 00:27:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10677"; a="719266894"
X-IronPort-AV: E=Sophos;i="5.98,338,1673942400"; 
   d="scan'208";a="719266894"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga008.jf.intel.com with ESMTP; 12 Apr 2023 00:27:45 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 12 Apr 2023 00:27:45 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 12 Apr 2023 00:27:44 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 12 Apr 2023 00:27:44 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.169)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 12 Apr 2023 00:27:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KwWwX0Tk0ewYWjniRjEmVgFpDVsTvSAQkKOYp4qgZ5XVb7XcMOMpZhO9GYSfHY+nafkvPCYQqmp6SSG+V0wNZVdrB/n5vZx17UMwUpxvINal29aaS2ZYo7wyn/tNLn7O51tbQABey6ZVg3CDtHDJw7/Mgi/RhE9b3xa4ydUrZpyD2HzLDXuAB3kkr4gfIuDo8wkE9RGNIp6bfXf3mCE1rfChdQfqam4SwZnRdKO34Aevx7apJGZceTxvs767NvNVcHOwfhJJwc70vYkbUFwlWRcVxj/lYQ23PEuNuZOas8z32NjVhCXgh8dbZkTA4XNIMz7SUHHaOxBPjsWuNP+C2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/1LNyPjwwS4Yi5mGsR7YsfVYTfqGREoTVYEprzHdm6Y=;
 b=iI/VibfjfsVEcN4yihTE58JfxdSXkGGv+AMiO+90vij+URGZA9C+dnP5snH1fSNjRH/Ycx/MeyzLm+NpXs18UL1k0UZI/uaF8IMqK/lwYlBk/nXK6rEoOXHA5PLpp1Wx3mJEl1f0/O60INwUY+04cw+YOcQc+2bU5MD4Dpu8VCjxyGjau5jLvGk4SFflw2R16BvWZqhOCU1WuAsro5nmgjleISYnps6Q7IhNpaaz7vGXV9l7fjkM7Iy9XurDnoI4kAUIYHXIyv1OOGcIL1ymHEnMdA0zjJS22FHtZIKfleQVVIZnY/EKbNHAFv906zqwK4NdhlQ9C0EngPwNaWjwwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SA0PR11MB4672.namprd11.prod.outlook.com (2603:10b6:806:96::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.35; Wed, 12 Apr
 2023 07:27:43 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::73e9:b405:2cae:9174]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::73e9:b405:2cae:9174%8]) with mapi id 15.20.6277.036; Wed, 12 Apr 2023
 07:27:43 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "Xu, Terrence" <terrence.xu@intel.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "Jiang, Yanting" <yanting.jiang@intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
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
Subject: RE: [PATCH v3 12/12] vfio/pci: Report dev_id in
 VFIO_DEVICE_GET_PCI_HOT_RESET_INFO
Thread-Topic: [PATCH v3 12/12] vfio/pci: Report dev_id in
 VFIO_DEVICE_GET_PCI_HOT_RESET_INFO
Thread-Index: AQHZZKiCXow33Wzeq0K314B/OZqu968cqG8AgAAdbYCAACdegIAAAyuAgAAEPICAAAjLgIAAGeKAgAAG7oCAAAf9gIAAO30AgACyrQCAAIPEgIAHkI0AgAApuICAABWEgIAAGNKAgAA3aoCAACJEAIAAeYpw
Date:   Wed, 12 Apr 2023 07:27:43 +0000
Message-ID: <BN9PR11MB52761A24E435E9EF910766E28C9B9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <ZC3KJUxJa0O0M+9O@nvidia.com>
 <20230405134945.29e967be.alex.williamson@redhat.com>
 <ZC4CwH2ouTfZ9DNN@nvidia.com>
 <DS0PR11MB75292DA91ED15AE94A85EB3DC3919@DS0PR11MB7529.namprd11.prod.outlook.com>
 <20230406115347.7af28448.alex.williamson@redhat.com>
 <ZDVfqpOCnImKr//m@nvidia.com>
 <20230411095417.240bac39.alex.williamson@redhat.com>
 <20230411111117.0766ad52.alex.williamson@redhat.com>
 <ZDWph7g0hcbJHU1B@nvidia.com>
 <20230411155827.3489400a.alex.williamson@redhat.com>
 <ZDX0wtcvZuS4uxmG@nvidia.com>
In-Reply-To: <ZDX0wtcvZuS4uxmG@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SA0PR11MB4672:EE_
x-ms-office365-filtering-correlation-id: 892ddafc-ae8c-4c48-9607-08db3b27679c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JH19d1WdvZvVFLj7ZBe+dyrMaCjg+bD4+pPzHrrdqTKG9ujeRX1VCT+gCw/OO3BVVQ2c9yZObhe8VU9+dYaY7MA6zIfzjApLEW9awqynfD90OLvkJFlfdGunuxh1htYz6yHUiuXD6bkJVHN5FbS504A3DonrVs1LTx15JKUrwtBRA3H+cwoX7+dcfa/KLQWsCyN8j0rsbIMF3WjNC3CZ98je5QW03TsAoOS6dkjjshpYSnV/YqfEgoifppIpAIEsLUu2IAin9Sj8AlaYwtv077dPyXVp0SPh8u5O8pEPLxd+gXkToBxBFBuB+4GZsgI75Td7t2I0qL/9nI020bJz2CE3Tr+lA+GoPGNTSzmGyU7ENtPPXxhaiY3kHhDHGgvBT40kbDka+bY6VkPj5hYc+0X+ComIdAByNoJjLjWbrmPn29rhzYprTlxIJceDHd0mF2BW8dj9jBxK9fNceR6pmadVxsxpSZqHEpLzmBiPbXkMugXGjHIJvwZQ1WEg+7A5aaYr+dGSP+OGRh+VyB6Qao/3XYHXXDiniEh4uA6hyBfTKnPENPzPQ1n0aENztDTAKKFoNM/4xDK6okfzWZxMLEICfWMTaZLiokz+SGJqwZb7dEgI7oeUNC08OadxFgBE
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(136003)(396003)(346002)(366004)(39860400002)(451199021)(316002)(54906003)(478600001)(110136005)(33656002)(6506007)(55016003)(9686003)(26005)(71200400001)(186003)(7696005)(82960400001)(38100700002)(64756008)(66946007)(76116006)(4326008)(2906002)(66556008)(66476007)(66446008)(8936002)(8676002)(86362001)(7416002)(52536014)(41300700001)(5660300002)(38070700005)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?724XzX/KIJi77HNcW1YvDWI2D5mYDAq0xpCQFzP563/qXkFwk9+sk0InXISm?=
 =?us-ascii?Q?CK8dEblZMTKXFWeVVyT6WzCA68Jvm6Nqzhq4E11G5apLNd34prW4Pm+2tGu/?=
 =?us-ascii?Q?fPcCG15PARPnfd8k7SdHaPzwMovtPgcU7LPiBT2HuWetuJcKHFrq5DaLDeOe?=
 =?us-ascii?Q?hAbm0o061IUPQP+08VrjLSqlVB4Scw5R7Be5WlkoTy5HvxdYKB8WTtPuahAK?=
 =?us-ascii?Q?TGE+YRKYUwyqSEZnj6MixG3BAdeEVTFm7tcMoFtnH85BF7e9UcDDB8BwUOIB?=
 =?us-ascii?Q?8JJv+VZbdlgthOA3OKK80/G60aZX9HqrvEQLmg9XKc+RnoSymh2aL0wGprA+?=
 =?us-ascii?Q?ZWp4lhxJgZortfRVCoKEnJa0wLly8cDej7VKrBdLaidLnpA8iIYgeziZ9gyC?=
 =?us-ascii?Q?35lYI+1TeMMbszQd+lNuxT4ZKGCO6HrrWkCgpVSSpni8Y/skGKcIes3NDG+h?=
 =?us-ascii?Q?r8XPEOR0ySeeEZEDYaJTr5Uz50q/W1H94UoB67Sx20IOVeQCkRaUD9lPs/Lv?=
 =?us-ascii?Q?1Dvoe3/bp0tRWQxLwS6Q0FfSGyzOD6gEWcLK5MR1gQHOeOgCWR22EFu0FxI7?=
 =?us-ascii?Q?aP3OQmvGJo72hMzqCFXPjh4XWRjTcT2x2VRyHOKO+KVoQ3jPwtLvOnfZfC8v?=
 =?us-ascii?Q?oslzsD4Xyk+HGod1/Ij4qGcw0bPyw8kHPs3MwWGv/MBJ6+0g9nOsO0GRmwM1?=
 =?us-ascii?Q?8hC3juWRM6Wg4Cd9UNWHUQsGjluManPBqvxARX7DdK2jBeYNe+WnV/9zVwUB?=
 =?us-ascii?Q?cJvPdB7uAVtpNwnXehTmEEE2jOJKBk4msAWtMW1dwFxAi64VpAV2jVFJDrJE?=
 =?us-ascii?Q?HWDIhBXlb+jFr8MucCLWUj6ARgRsy/nIz37OZ9rpR+G+5+sBHOYvvWWcypF5?=
 =?us-ascii?Q?DDeTjHf5pVBqGjrDzPf+UagvxjZ6jkAffIB85+7MnRWZQVPn26Z7WpnZi4PK?=
 =?us-ascii?Q?G+azMviAt05mwY1LUobX5QlF+0YCziL8XZJUwOCdbIrkx2Y8+nUBDKGzhqkH?=
 =?us-ascii?Q?m4bLqXRdOOfezmSQuxkE+MWFCKH0gWxg16VpJU5Peo7qkXn18B5IkEVwI44k?=
 =?us-ascii?Q?48UukDnmkD1RXOkUFN7XlqoLR5/NwHbLIMQUFtNwbQJuxTL7KPUi5ltuWmHK?=
 =?us-ascii?Q?/jWt9yoVaFxn8RO1y0iERMD7ehsOkJ8OLEUggP3iDfLY2mwpD2C3/+e8soYj?=
 =?us-ascii?Q?lSBIPb5m+uawggSJLVrp8aTqz2DQZKxRp/qnkbJLWL/LPy7PDVEOI28T4GwS?=
 =?us-ascii?Q?aZetgH57fVTDVcTnx6zhbhywroiJ3x1nrzTAT/xoZcLHn35hG8teGirKohYD?=
 =?us-ascii?Q?vqbTSi7ld7vSdeGqMypfmJq/qw3BAcZoe1N1BIuNr0mcdNUc9rq+fV0N9vEO?=
 =?us-ascii?Q?xCrvLq6HKEx0hGytO6V3szqCjhujnwFDxqQUCsKsrDNyEyk/rlL5qZVPNIjp?=
 =?us-ascii?Q?qRSkIkGojYaZYPPWLF6ooio6p0ODzFBL3XQko2WAGkzo75i9Ay3vd6kuImIj?=
 =?us-ascii?Q?tWHw8QS2WJxs3cMkHnaMpt6fhiMOzvHoUuL6Cz0k9HUkVaj53ZJ6ZzyRae6H?=
 =?us-ascii?Q?1BEUODP+GSThNRknE1O8nYwWKlJVGWSHrBHo6OcF?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 892ddafc-ae8c-4c48-9607-08db3b27679c
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Apr 2023 07:27:43.1048
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +ReBVo7SiMGLnCDCsqj3j5DxrRfbgcYTJ/wA4oFJ1+C13XUoyDz8AOps+Cqm1O7g/1jcJvFfLZjkrPNB/w/ysA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4672
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe
> Sent: Wednesday, April 12, 2023 8:01 AM
>=20
> I see this problem as a few basic requirements from a qemu-like
> application:
>=20
>  1) Does the configuration I was given support reset right now?
>  2) Will the configuration I was given support reset for the duration
>     of my execution?
>  3) What groups of the devices I already have open does the reset
>     effect?
>  4) For debugging, report to the user the full list of devices in the
>     reset group, in a way that relates back to sysfs.
>  5) Away to trigger a reset on a group of devices
>=20
> #1/#2 is the API I suggested here. Ask the kernel if the current
> configuration works, and ask it to keep it working.
>=20
> #3 is either INFO and a CAP for BDF or INFO2 reporting dev_id
>=20
> #4 is either INFO and print the BDFs or INFO2 reporting the struct
> vfio_device IDR # (eg /sys/class/vfio/vfioXXX/).

mdev doesn't have BDF. Of course it doesn't support hot_reset either.

but it's presented to userspace as a pci device. Is it weird for a pci
device which doesn't provide a BDF cap?

from this point the vfio_device IDR# sounds more generic.

>=20
> #5 is adjusting the FD list in existing RESET ioctl. Remove the need
> for userspace to specify a minimal exact list of FDs means userspace
> doesn't need the information to figure out what that list actually
> is. Pass a 0 length list and use iommufdctx.
>=20
> None of these requirements suggests to me that qemu needs to know the
> group_id, or that it needs to have enough information to know how to
> fix an unavailable reset.
>=20
