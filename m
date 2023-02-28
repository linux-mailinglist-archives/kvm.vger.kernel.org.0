Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79EE56A51AD
	for <lists+kvm@lfdr.de>; Tue, 28 Feb 2023 04:11:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230001AbjB1DLu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 22:11:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229691AbjB1DLs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 22:11:48 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E10282006F;
        Mon, 27 Feb 2023 19:11:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677553898; x=1709089898;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=gMrLxFa7OIkkmxmYpF4H7a7wcb/yW0rhoQLrALlzqBc=;
  b=LaeGA3HoB9j9XGn+HNLw3o6f625rhZuzksOIHXmU2h34uN6d44cFM588
   Ovyml0LgOfwiqcqV8QghX9NbqB6nFIoNgQUyH6/mCBlvSEBqtvBQQiAop
   kxl99ZtnaVDMelLvhp+iM2xaCvdKiLgfZnWBZdOlZr9acVVuQMwFeExjT
   efMUanJ2P48AxcYePqFn3RmG09YpAuzyDl9hPq4HmZlDeZl67hgpmiZwA
   BPwbBZ6CUHJJMLbtf+VhwwxObzpx2i4Iv6nMyFrWFZEaXSedLodq3yZcg
   HGrEhT9Vn4fE/opc4dXBfz0lHT9YsTvAOGTHrhTiOaULSfyeld4JjSfEm
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10634"; a="331510406"
X-IronPort-AV: E=Sophos;i="5.98,220,1673942400"; 
   d="scan'208";a="331510406"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2023 19:11:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10634"; a="1003071741"
X-IronPort-AV: E=Sophos;i="5.98,220,1673942400"; 
   d="scan'208";a="1003071741"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga005.fm.intel.com with ESMTP; 27 Feb 2023 19:11:37 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 27 Feb 2023 19:11:37 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 27 Feb 2023 19:11:37 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 27 Feb 2023 19:11:37 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.103)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 27 Feb 2023 19:11:36 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nzclE0EsON8Ynxi2pvHdZrBzf0X8grxwiLe7WN45J+pG6xLZWP6aOnxVcXiamXXw3DB8QlFouoB9NiyLAYnGb1H9rZFEXyBd26rRBePeAlCqxVwHJbu3a0X/Ea1aV7Y/mzs2T1kowStRskiUAo9PFtL0+cjYFfG7NVY3SW8+nSSZEE62gESlRkjS4uDU7rBXZqEACVrau3Sg/pSTxiZwjKsxRQYeLuWVh1RxrINvP4wqDBulaIs1vkfenajFgI9ZKCgVyIzaM9hYTeX2s2CaRUpG8jAJvJpPmBjl/erv0yCK7x/iKdPGAzsG3KWQU0jXiQq8/TwajPANRfo7aRo4lQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AGidM3auVEHqZ7biEOBJOk6wpmyLnMWOQ8GtNE/E5oc=;
 b=PCVd20pwMIW9lMhhkIHWMRH0XR+LJ8NzAKra5Rv8WE0HzHdmZTdq5IwMhkg+X+qB3L936u/hcPuvCebt6AfJPC/scRBzowp024D7yGONcC5+pNyZ8gUHBX4xV1p6bJTIp3urrylS0BrOn2p55KczlxuhAwCeJq9ewGo1ml+9Yo/5R5S/s4ZHQbRGjzfkmUvU0mPzpJeKXYOamI3bSUZbyLkg+Mr3Z9u+xsIPy2XdZoY2iiMWau1gjzP8kBylCnfayGFruwH6cBfPDm6VlFHma/rK6J/ebD5g6hc9aamCyAbJuexCjihKTiMBwUzwQFei0R5QawoAxQWDnx2ieJTZIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by IA1PR11MB6322.namprd11.prod.outlook.com (2603:10b6:208:38a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.27; Tue, 28 Feb
 2023 03:11:35 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f%9]) with mapi id 15.20.6134.029; Tue, 28 Feb 2023
 03:11:35 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
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
        "Xu, Terrence" <terrence.xu@intel.com>
Subject: RE: [PATCH v5 14/19] vfio: Make vfio_device_open() single open for
 device cdev path
Thread-Topic: [PATCH v5 14/19] vfio: Make vfio_device_open() single open for
 device cdev path
Thread-Index: AQHZSpxLzIf6/b1XXkagijJzcXNiyK7jI/gAgACJkpA=
Date:   Tue, 28 Feb 2023 03:11:34 +0000
Message-ID: <DS0PR11MB7529F1D9FE0F751E45363606C3AC9@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230227111135.61728-1-yi.l.liu@intel.com>
 <20230227111135.61728-15-yi.l.liu@intel.com> <Y/z72jEID0QHgaLl@nvidia.com>
In-Reply-To: <Y/z72jEID0QHgaLl@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|IA1PR11MB6322:EE_
x-ms-office365-filtering-correlation-id: 57fa05e2-2b80-4fa6-272b-08db19397f6f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ax0lWQeaO0AxE5iAPssfmJ9dMum8PgTdO2AhM8esVK5WQMaPGFMqPFFZ3EW9Dc2aJk99RzJu615sKeINCW7Fw3Agvzsy93OHhmJs5OJNMgW7EXuRptfgY93mt7qm700ZoSj4ailXFtzgmzyA5EyLD+bUAdt3HZzyEnAUb/tx4NPHSlV1NUNoSyWWMW4JelhgEvkkGrZu1NocIi+OqvzNB6DV4WlTfvVFXm4jjSMuWp4BXYgPPQQISyB7Oed4O6tPJkabnuMyHwGTRluB9mNNE6WaPFy9Xuskpufv/Aj16Xg0jSRa67mMYwZAiP+emowv7V+eHX0gXZ70d+AC/ugxYbaJ9C77lkVLeaI/LDgoS8MWQ6opZhZBNVwBMoqyn1q1Upo18RqfzOKrEvuIw6fr05azz9qN+mDotpIeOCbFOYNQYda/5CDqvx1/LHns/JPL17aNKLfiiA6s7x5YUrgOkdTAQsN9toT/+Vu+2wIg8znP6EG/KUZ6J3Ps32oIJ/T0pco/6vH77HeYrFcf7e9hVoS+4BvF/+KYSB6VY9H8m9DphE6LmQompJNjFFhqbA+H0GOz8rdjz7tLYSbIAiOgge/2QhZgst/FpbyEG8r/uo9q3jZupqSfqUcscBhNZ/K/Ia8W5duw4fsjEEt8VXHwkEizLyoYGd5AcjjWU5buLdSVhSLhndxe+5Q9E+lkjhf3jJAjADhnPZ3e8AlgOPOFFg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(366004)(39860400002)(396003)(346002)(376002)(451199018)(6916009)(8936002)(5660300002)(4744005)(52536014)(7416002)(2906002)(66476007)(4326008)(64756008)(8676002)(76116006)(66946007)(66556008)(66446008)(71200400001)(478600001)(54906003)(316002)(7696005)(41300700001)(6506007)(9686003)(26005)(186003)(33656002)(82960400001)(38100700002)(38070700005)(83380400001)(86362001)(55016003)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?gEvfjkFp1xwaCv+5uYdOVl9heUSbvh40O6svfiY/YEpi5kpRtcFP73ZOAOd5?=
 =?us-ascii?Q?aLvgdtf4MJ725w2pgTBYadKonJEdfCr1VBYERvxW/g+JKK3D7ZAYfPmlIbmt?=
 =?us-ascii?Q?/RK0EdKxIduLFvmbAQzDZ4YgaZSNKnrUftjFMP87ONbcx3UYjQueu+o9W7Qp?=
 =?us-ascii?Q?8E1Gt30JLjOBviJkObeBpwxhfOtiJBdBL6DkibmhMncgi60EHjd4IaFsu2hR?=
 =?us-ascii?Q?rUwsn2kskcuHu0xxvIqnFOsTVyQT8Aa3yLw9l2bnDxDRzBNQUewGymj85/IW?=
 =?us-ascii?Q?TNtymjR9czIlPWMOOPsxnqopxck3ST6HToNM+PIFDzDYxTqbyXVUPuYW+rau?=
 =?us-ascii?Q?Pj41Fw/tG/y99tUz5+YfI0l2x/sPMypx6tPV1RL7eCGXaHEnZbqPFVRzt1nE?=
 =?us-ascii?Q?Ziw8BVTMXqhz5i0cwFmOxnwP+2JdJhHwBTT1bxiQkgAxLCQ4l+Kpks+cZnu4?=
 =?us-ascii?Q?EXEF57mtkUmPDbVm/1lm/hI23uPX2Mp2bjk4OEf6T8H2VrKXcDkC1MxbPmka?=
 =?us-ascii?Q?SzjdYRXcNCVhIrOqBVUG2d9S55uFKAo4ATAHWHYdCta0wj9UZlRe6myQblA0?=
 =?us-ascii?Q?E+Dn3lyo+6FBpSWpaZC3VeVkRLd2ml2mpS+AyemcGoUCiseRc4t2GlqqgZSx?=
 =?us-ascii?Q?6sqWdHP2bQPzlrUhLXmq6nMCn47UlwtCZciYUbrls8MXADoEWk0pRDlRvNqv?=
 =?us-ascii?Q?yuEoaARi0ohaDMUKy2WRNDF4nTqbq+KEc6xK6UZdUodTgbJUKtZ546QCR6i1?=
 =?us-ascii?Q?Wy5pLIO4hXXYrvopfkTLGnMqtvn/OC1G2ESqCAkggRHPmBCGOL5Vy9q1igNJ?=
 =?us-ascii?Q?Qs39ooYLlij4aV/R8L+uM4Bi7VXCRsxm+b3aWMFzTIwWepsySFBpIlcnM9K6?=
 =?us-ascii?Q?S3xQH8w2yj49JM6NV9bsFvLinlMMQOJyVwSzt2VdA7rtQtRmIgMjwaZvxqjX?=
 =?us-ascii?Q?CAGMSNhuc8Q7x7uYV09qPaLWvlZFILfWyTdQJ84Sblt9nhlczUwUUIbh+JZf?=
 =?us-ascii?Q?7HSCPMA4PMvO9EccsEd/VVplrt8l7ZN3ezR7tQpulRK5GiN35w57ofFQwXfu?=
 =?us-ascii?Q?+evXL14FFfmp0/Jr8oOUXKY3VxzxOZRLH/lIBctvx0uUH7b9kS8fRR1iiFzD?=
 =?us-ascii?Q?YYI421iesveAFVxud+2MvvxKhVkuhIeC3Dytb1Z/MIi0wZduSzqSZLvjQhKh?=
 =?us-ascii?Q?52UIdIv5ZhsYiWwDr1Azkl8b0H79+6xpYAc/Xv60+7I1mVm2t0kpEXWO+rAH?=
 =?us-ascii?Q?jzG3YbHVIjW3jP/5513NOpBeC4TtjSThzkHT9ub8fGKH2TE+2nmMm8GegFuM?=
 =?us-ascii?Q?9x7OsTNKh7nowpPLn3bFMOfuLhZ0SyYaX8HaB4d3Z9PfI+uF03Uh5DTTWXmw?=
 =?us-ascii?Q?fv+9+j4wdjAVtzvX1w0l+9eAukDtcBDHhBRgMqm1JLfc5P9HV4lmkqN/CjCA?=
 =?us-ascii?Q?s0Yu/g5gPYGgp9Xh7DNerJTq24Zgs4TNHl7F3MsD+HebEXf6DvddaYIbk+YS?=
 =?us-ascii?Q?1AhVZpmybqBn1gj0UmAPtZie29sVm94Awsp20jX09Ll7kltqAk5mkhuFM4Hu?=
 =?us-ascii?Q?tTrdDhegFy6X1APo7XXsrVboh0kR1AHxbnPJhzVi?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 57fa05e2-2b80-4fa6-272b-08db19397f6f
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Feb 2023 03:11:34.4565
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6A7+gloZcNThU6s8oqTpbyOkGdsyahsLm/X+EGt8NFi9grmYoeQLaluS5ILRv/aEynWNi4zCPouOJYShJNEw+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6322
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
> Sent: Tuesday, February 28, 2023 2:52 AM
>=20
> On Mon, Feb 27, 2023 at 03:11:30AM -0800, Yi Liu wrote:
> > @@ -535,7 +542,8 @@ static int vfio_device_fops_release(struct inode
> *inode, struct file *filep)
> >  	struct vfio_device_file *df =3D filep->private_data;
> >  	struct vfio_device *device =3D df->device;
> >
> > -	vfio_device_group_close(df);
> > +	if (!df->is_cdev_device)
> > +		vfio_device_group_close(df);
>=20
> This hunk should go in another patch

Patch 15 or 16? Which one is your preference? To me, I guess patch
15 is better since the user may open cdev fds after it. But its release
op should not call vfio_device_group_close();

Regards,
Yi Liu
