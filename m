Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6804A6A5956
	for <lists+kvm@lfdr.de>; Tue, 28 Feb 2023 13:46:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229944AbjB1Mp7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Feb 2023 07:45:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbjB1Mp5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Feb 2023 07:45:57 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10CBA301B0;
        Tue, 28 Feb 2023 04:45:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677588352; x=1709124352;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=tyUJO/NDsCP0LE1S+V4SH+9Z+NbMWQzFHxP2KGMgkM0=;
  b=gMvgSy+ffLrCryjUUcLfP0vp+/ux107l2oI878AMjSi4gfjGvYOXHyKi
   ioBeFqAmPXC60Z/DhTm/UGdyr/bAPqAM06YwgZvv3vHng1x+3XoHyLUo8
   cYtkJ4ddh4c0sjwTPWeXmhK+bo2dE+DMr3s6wL4Ij5k0K0If7vRn9rd2v
   IdHQHOBXRzaDw6ICex16Z8UXe2N/mYbp2C5T8lnIZUQ1ZPC7MOF1umvHG
   lINiAa7tue8nHi0Fxp5P+IupEV4XkEMoAHy5peVSKUxzAdHR7Hoct6GbF
   OWQtBes0HsyegBUIy6ZIVvTG/3+uFWWepUgPf6zlwZi2DRHQ0KI7sja+s
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10634"; a="317925011"
X-IronPort-AV: E=Sophos;i="5.98,221,1673942400"; 
   d="scan'208";a="317925011"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2023 04:45:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10634"; a="848239605"
X-IronPort-AV: E=Sophos;i="5.98,221,1673942400"; 
   d="scan'208";a="848239605"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga005.jf.intel.com with ESMTP; 28 Feb 2023 04:45:50 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 28 Feb 2023 04:45:50 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 28 Feb 2023 04:45:50 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Tue, 28 Feb 2023 04:45:50 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.107)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 28 Feb 2023 04:45:49 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RyIJBoZYZdKvZWbemwu6wmo6uyPLH8NgmjPTnH7++r56U/NnwWQwqsNpjrHJa+7E91Qdnq5MZcnrEvjoC2t2EHTU1Abii2Czx3VARKe5TpFh2uOJD5ljgZYMX8t5nGe4dz4ArXH4h6yXdOFT0Cwgz8jP3msPcvds3mBAJi/qU4U35u9cHV3+ukXgd0gZbhFSkrQFdsCPYhsjjKa339XoAq1c0Uf9SHINs1qhccCFsuvCCMT42ggaA2KjirOiH+gsRaDOuZrE7savCI+9BFFhd1GKd2eCWEtzfIBjrmtZyxj8v0+Fx3wgDbkHACc1z0H7YvOqGA+Ytb6DSML1KAUqqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tyUJO/NDsCP0LE1S+V4SH+9Z+NbMWQzFHxP2KGMgkM0=;
 b=XFspf3jx7L3lM/8Th3EN6Oct9cTOldMvAPGuh1bOw5O8wqRVp25YMUkLf9LM59OVJguVqwM7uesQMu08SfdytyaXV9dogPAT/Ho7gvdKuFZYBgJa+SpY+wJ29woVQqPLV/kb/Bl0DTGQnpVMnl8DFeuxGgwZZATNZbaRwEknAGWdaetFl/rv2vRPLjCTA5+kmYWTMewag4Qrq9srAQIO7OvGNlFuoHNlV3qa8Lgsipj7jcCcJ9Ek337n/dt3DAVh0IWCXLNkBf0A96mGZVGw/VMvkfeeyEatTcBXaeH3JZfgIg6itbEvnynYkKEF/Q8skcMPXx3FqjB+zEEahF8Y8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by DM4PR11MB6360.namprd11.prod.outlook.com (2603:10b6:8:bd::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.30; Tue, 28 Feb
 2023 12:45:48 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f%8]) with mapi id 15.20.6134.030; Tue, 28 Feb 2023
 12:45:47 +0000
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
Subject: RE: [PATCH v5 10/19] vfio: Add infrastructure for bind_iommufd from
 userspace
Thread-Topic: [PATCH v5 10/19] vfio: Add infrastructure for bind_iommufd from
 userspace
Thread-Index: AQHZSpxK4wL3BAz2vkuMw78Q2DEYMa7jHbWAgACHOBCAAERLMIAAYp0AgAADn8A=
Date:   Tue, 28 Feb 2023 12:45:47 +0000
Message-ID: <DS0PR11MB75293900EA1FAD0EFD13EA2AC3AC9@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230227111135.61728-1-yi.l.liu@intel.com>
 <20230227111135.61728-11-yi.l.liu@intel.com> <Y/z2mY97uPsCs6Ix@nvidia.com>
 <DS0PR11MB75292E7DCC6FFEBF5B5DF66AC3AC9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <DS0PR11MB75298144318DBA9690DC756FC3AC9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <Y/30CgUSbkpFN20b@nvidia.com>
In-Reply-To: <Y/30CgUSbkpFN20b@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|DM4PR11MB6360:EE_
x-ms-office365-filtering-correlation-id: 0c41aa94-cd7b-49a3-fb59-08db1989b6d1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gKUmqQthMnu8q+IgSWQglK49TR1ehrPHZlVZeAUdz7+3ur27zVbOpQhNnc8x7lHPEQpZLpfdDtTUM5XRhbpLkO9+uKOC9jDQssqi23yhxqNcMqXqqm3YFlZ1JKoROqltxki8hgW+sE9yCcp9MRbKCJYI4rsDO/BhUz6rnzaST0ebICYzO9qa+Io7R7rhhfXmuJDWjEzyFqsLXYv3zUq3Wa9dSTbv5ftsEcxU5Z7gAct9NkVUsNUk9Tv/d7et2TDX+bs5SllCWgwkwmPQUXMmMd9eBQAb2jlXHq8tgQmX73Gp2CKFdQ+7KfaBcyCxxxsiA9rIHKLo9UMzEkdTvItPij6yKgvF6TKAh+T5gZUP9MgPmPo/VVbpciZO2Yb8/ZXFRgunLYEoNtY/Eo4WslUY7fRKu8jG6lJHZpvoIj/YVwZs/cX9J90mRTnmLiOtaGrkWFicSzIU8gkGtGpwA6WYwhlWuLZvV+jXRehYDcLwYkuiqr6FiJpPF7fMqQnHSlq8zRXQRJfkK0JTdr5hsn+JOGsSWKlyypINGhgVFNt1VKqiCGSI2iVLW90W6CIdOKU+2SSizdKmwJQiiqiKxGcZTObm7jTMitV1RZwIMtQEGyv9wuxc5eeyNQdlhlJXUQdNVye0xlqkV3/zOrUc/RhipSP1drFQOmNluAfdtjNQTb0RwTmhZ5FLGlamFRxwkj6QurMB3khyBVTmqT5gEV9ncA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(366004)(346002)(396003)(39860400002)(376002)(451199018)(82960400001)(38070700005)(71200400001)(9686003)(26005)(186003)(55016003)(6506007)(122000001)(38100700002)(86362001)(33656002)(4744005)(2906002)(8936002)(7416002)(41300700001)(316002)(4326008)(6916009)(7696005)(66446008)(66476007)(64756008)(76116006)(5660300002)(52536014)(8676002)(66946007)(66556008)(54906003)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?3VLb12EYU5GrG0DEfwGxzN8Q9AP/P+jzuwo7hhoclCueodgsdFR2zsZYcDcl?=
 =?us-ascii?Q?rq+gEeQM6ATE4QPbh3YgKAdLDkuq6saA8SSSoY6i2OMFB2nBdFRi6tW39kRj?=
 =?us-ascii?Q?oT93WWfJcGE306tYjhOx58FBee2yZ5zPVlFdTftkFCnp0+hU9BNQf7VUXhrH?=
 =?us-ascii?Q?/TyB+Wp0bktJq2HtlWHYhj3G/4vf8xgRZkTwYEc6L20BkEtFrGmH4RSEO4nd?=
 =?us-ascii?Q?dkujZkxlVXn0+pIDAPWql2UWrHSsN00YVsEIipiBCoSDiHFMEWcU6wCKjVMD?=
 =?us-ascii?Q?so4UbFQsOvd+08RT3EGBX7OsVeprwz8ous/4BuZCpwCDyJ6PwdEIQWJAQkc0?=
 =?us-ascii?Q?dLcCE4LCeZInWQ5WkNJaWWTq6PsIiHURGIdUaJE24vBAS+OxRN0rg1hr6Hd8?=
 =?us-ascii?Q?EZv8q84zU2hzppAHWW/lb3F4D3DJn+x+UL2wDKGiKAwynNeVoPGUzqZ0Wvtt?=
 =?us-ascii?Q?Q8s0NYXkvqPXPwUQFpMaQ6FA06o4HyJY5NLvUlp/uEuoBJKJBCszstVJpX4+?=
 =?us-ascii?Q?w/k7p5f8L5sqy4kpdZztVeWaEBe1Bp8AlyI8hR97RETv86tQB4yJJDu0D/b4?=
 =?us-ascii?Q?uxzghQVuHhm15Y9P+V/skO6JU01X58r6hEf1N1hCk7qSnmQlUvhp4So6ixE+?=
 =?us-ascii?Q?YqMM2q+cUzMX5n0SChxkbksIoUMKgQMVgRjM2zb+ZtY/CG+K1PFnol2FUZLu?=
 =?us-ascii?Q?toEYAZ52eND5cnllqZ2oPOd+SOGYtJ3tZQi6KqtZoDmdGacB3kD/zsQG0R1k?=
 =?us-ascii?Q?bMTiysdTkCMDhagkJqy/HKswpz5vkHeQB/dY4DztDMkI0eCP7tuRzyj/iAoh?=
 =?us-ascii?Q?MiromQ91jaf4jryJd8LFXhJ1RAFqSJVhjvp0aGTk7vbiBStvDN2FdUUc0Xm+?=
 =?us-ascii?Q?xNRiMWm6QweyVVwImPx4qYW2CNcnPSPgvsJb7G5TOH0SItS5cf3x5Q2vdTwH?=
 =?us-ascii?Q?e9xFQWdEd6BJ2vBx01OchnaZfWjy/EJSkDRuXg1bl/whu+Mek294UaHCq8rP?=
 =?us-ascii?Q?Aq9M3syPO6cpyBYB5/vaPAet7/z7sw6PQaHlioq4ys1yCaijSLkTHgLqOf40?=
 =?us-ascii?Q?oO0jTdpLTPSWUit82arEn8dIk5f5qkZgglkOJsD/SnmIfpz9ej/lKI92VQVz?=
 =?us-ascii?Q?GA6AUIPZVjjoxkD0bgFJVNGyfW4jWo9x3B4djocu6SVlsXuzu8TD1u+mgu30?=
 =?us-ascii?Q?RqNj/fju2SQKL42XeEvjKWIGah/Hh8vlsjIzksoMtjOdJavyHcSALGRgoW0q?=
 =?us-ascii?Q?8r0EFq30DKnmsJ5pEVurlfHr8JzbjxK6+nl8eOjWa2QTvY4D09btX6o2NAu8?=
 =?us-ascii?Q?9J4PjMqZerHxP0hG+6kYBcLWZVZB4pkcSPmbrVzLvQqcRmQWAaPmoKKgoGXM?=
 =?us-ascii?Q?cVrkH4pCMG1ppgyCFX14KbMRhPmz7htXNGo38pqi9iPAJZYmS4S+MSBN1zq8?=
 =?us-ascii?Q?hbNluJgIQ5bnaOAgKAtChUWkwP107aXpC5VdAW+geTyJtQISXswYw1pYddhp?=
 =?us-ascii?Q?8XaLfRp1fOedTR7os0F5ZjUfrxVVpGqlnkLrCGSNscPoN1+uSqpdn+gVHaWM?=
 =?us-ascii?Q?lDjFI6aN5a8OCSfQ2j/PCR9dd53S7vsuuc4InhJ+?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c41aa94-cd7b-49a3-fb59-08db1989b6d1
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Feb 2023 12:45:47.1017
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: O8HaB2FitaDHAui4lS9ODh6npFUnbpst+RQmVY1IlG948SXWXwkvmY6E0fRP51BSSe2OFb4Xy/frUvvLvII9jg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6360
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Tuesday, February 28, 2023 8:31 PM
>=20
> On Tue, Feb 28, 2023 at 06:58:38AM +0000, Liu, Yi L wrote:
>=20
> > Seems like pt_id is no more needed in the vfio_iommufd_bind()
> > since it can get compat_ioas_id in the function itself. Cdev path
> > never passes a pt_id to vfio_iommufd_bind() as its attach is done
> > by separate ATTACH ioctl. Can we use the dev_id pointer to indicate
> > if it needs to get the compat ioas and attach it?
>=20
> In this case you need to split the group code to also use the two step
> attach and then the attach will take in the null pt_id.

This seems to be the current way in this patch. Right? Group code passes
a pt_id pointer to vfio_iommufd_bind(). While the cdev path just passes
in a null pt_id pointer. Its attach is done later when user gives pt_id.

Regards,
Yi Liu
