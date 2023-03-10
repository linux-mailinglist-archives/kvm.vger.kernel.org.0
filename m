Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A26A36B39BC
	for <lists+kvm@lfdr.de>; Fri, 10 Mar 2023 10:11:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230107AbjCJJLW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Mar 2023 04:11:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230056AbjCJJK5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Mar 2023 04:10:57 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74674115B46;
        Fri, 10 Mar 2023 01:06:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678439171; x=1709975171;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=qPnO59KGRAIZaayOM0/la1z8GBm9+O2Ts6vyWeoY6yg=;
  b=nSc6XOPZrEF5aaiyrze8NMEmQ61naR64pVmBqpxmKmF45GkE1lk+Uctb
   3hwYdFsLHcTwwr7pEIlJlc+jy0oDQh2c1YGLgx39OacA5BxKMhFuhSxuP
   mtvH5/QSVBPfLLC8a4+uvOQ4YwErKSlEzO9kyEWEt1YCIkdctc0LLFoO3
   bCjElyYPA+XzW0lC2MiFJ51nigprfK2YTy9ByhfqgsQalh7V7ndCLbHA8
   jIHbuUQVfPdMdyJEMCQZpDM7MYTDuWH2yH8wgyj1fpjkN6zkxzgY5x5GO
   mvpMj3+MOGKveBGjLamSNztkVPmkINla5eg6HlXCIlxKPYRYz/Tp4rSwX
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10644"; a="317076490"
X-IronPort-AV: E=Sophos;i="5.98,249,1673942400"; 
   d="scan'208";a="317076490"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2023 01:03:45 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10644"; a="787945745"
X-IronPort-AV: E=Sophos;i="5.98,249,1673942400"; 
   d="scan'208";a="787945745"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga002.fm.intel.com with ESMTP; 10 Mar 2023 01:03:44 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 10 Mar 2023 01:03:43 -0800
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 10 Mar 2023 01:03:43 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Fri, 10 Mar 2023 01:03:43 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.177)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Fri, 10 Mar 2023 01:03:43 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KkhQLZxMNhpWpZ8+zoyGuKqfP7onrn/kQvaeWXkDjwhoSOgLj3HDz4lECvGS/YPfCmavfSakt47AK+rLXhbjHD0TEKSV+pqmIqkhMlotRutjS7wsYpa8af6TOoTPaat0uCZxdbMjHsiA/q0kWyQbcY33d8fNpF8lc1cCt4SgO6DCvOLNIWfNEKOznPKqS4ganmY5rFZWiFyK1m8NvxBAVuXMAjlmjD0IFNWbJQTILeVTLkoBb+BwZIg2ABGvx1AOWgIDPP9noP7KjwqrUTCQKNVk+ZoBDdhEVsMBsrc/OxoElO9N5ObPUyKNESciueZTeTZDRLNTX6ljlhxXCz0ySQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qPnO59KGRAIZaayOM0/la1z8GBm9+O2Ts6vyWeoY6yg=;
 b=c1eA/H84AcdiC4pLh1RTmEvNW5sHPiP21cA0xI6YpnWCuC73Cz00x7quvyWe/99nG+Db2tZbYSBx3wIzD36QNa6kRIny+yNH8T0t4I+HHYzWuYffAi7XIX0WgqYd3Mh5o320bYece2IGHFYAChDy4OFi9EEbneFk14Letq1Vhp2kfzLXaV2rczgJnFNIBl+CG05d7sGlXEFE7MCanI3jg1LlZ4+8fY/GsHTtTHdYf6y7/Ekc/Yt/HCgogb3s1q0Aw8cgs6tOvPiHmcf3WdLXWAg0J3bJLfu+Er1q0D+BU0IpCjf5Vp4nSS0sdrEx6b/4b+oaois6TY+hNo4QXjIYEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DM4PR11MB6480.namprd11.prod.outlook.com (2603:10b6:8:8d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.17; Fri, 10 Mar
 2023 09:03:42 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1aac:b695:f7c5:bcac]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1aac:b695:f7c5:bcac%8]) with mapi id 15.20.6178.020; Fri, 10 Mar 2023
 09:03:42 +0000
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
        "Xu, Terrence" <terrence.xu@intel.com>
Subject: RE: [PATCH v6 23/24] vfio: Compile group optionally
Thread-Topic: [PATCH v6 23/24] vfio: Compile group optionally
Thread-Index: AQHZUcINZUzcr1R3UkaR/dRbMm2VpK7zutFQ
Date:   Fri, 10 Mar 2023 09:03:41 +0000
Message-ID: <BN9PR11MB5276B72327E40803EA3AE9708CBA9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230308132903.465159-1-yi.l.liu@intel.com>
 <20230308132903.465159-24-yi.l.liu@intel.com>
In-Reply-To: <20230308132903.465159-24-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|DM4PR11MB6480:EE_
x-ms-office365-filtering-correlation-id: 3f1fd9ff-7cc3-473b-d544-08db2146587a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 64mUQZRQIBNZ/VAzSW5jHPn2XXkqIcrnpwNLzprp0EpfITYgilQwwUQJRqFjD+N9EiCJsI2tbQDQBS50kDrVDMYxP3r5oMDCPZx2OtHgOmudEJ1J1dz0pZFk3jbukbpp7Xfp81/4DFT+pG0+4wexrqxFd9rLBprxm+CbUIA5T77MUiZI5bR5UoU3FmANp+bbWCtMu2lokDPGUaPz9db9GwjcCk6tLY7+LgzhzKAutlg+jDhL0u1wmpAJDueq3hxr5qCryJTdsWTSK0q+c0ULBEqtX+s2TzC4DjR0gCxG/8jpd15HC3LbFejqVOU8rNO8ZkKapRtGQBiNUl9+sYpzYNHBTB+ku9Hkk/grW5MOd0lbe6AEqFHX9FrzgUDtDnxG8NIHtrUvBuseoe9uOcL/moZQV3WZ3sRJqgC4hMtV/IhgWaEr1Sm7NukIGuisBAIsdx6q/7vxWwYruyBoJm6cF49zQKRpUnK9FrCAzmagQhQfEXIa3Y1Jc4oP0jll3IrU5fxBTOn6s1fyL1wmoSGMlm6+e8nA5Ew6V2YtsjtYKE8lL9z4E5WN1K8EYION+s9uGwxjtJLjlisLzhm7U11lsLhSdSvqySuyrJwEl0vZvUmtislUYnDGUZ6C57JVhRG3kHdRMDWSH9cIJRv8/oiqxe30MbM0UXHHGhN/DpY/YVF5WR144GWA2YDzCHW8PBT0Jw+mO1VJojeJbF6Fz8NPCQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(366004)(346002)(376002)(136003)(39860400002)(451199018)(558084003)(82960400001)(38070700005)(122000001)(38100700002)(86362001)(41300700001)(4326008)(66946007)(5660300002)(7416002)(2906002)(33656002)(7696005)(66556008)(76116006)(64756008)(8676002)(66446008)(66476007)(8936002)(71200400001)(52536014)(186003)(9686003)(6506007)(316002)(54906003)(55016003)(110136005)(26005)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?QNc+43YTKWeQpZ9XNidJ4+pdO9kstfYGTF8GkroGXOkTmBgRzKzgPEM7zGkI?=
 =?us-ascii?Q?n0O6a6OwK9fxvc8myJRZ5+qBY6EM0Bwl5JcNcfRtt5WtVHwB6S+z1R8pDVm6?=
 =?us-ascii?Q?wUrFyQ02Y/HbHGFG/tXFFMOe84Q6MGo/LWYT9oZ8CUmgEmsvqEniV5QfO5UN?=
 =?us-ascii?Q?OZJgIx7j8zaH3/0cy/LPHY/zxKZAT4TVHgxUzCiy4x7oHNq6zacYn36hoJ1U?=
 =?us-ascii?Q?G+6S/6GyC+tp6LqIXYwgU6+bc+alfXpyT2HMiy4yX6eEVUvIRvAZXmU4I0is?=
 =?us-ascii?Q?EiIv4j6zpCrRkfd5DeKkiNaFPYaehr8Q58YuyppWkl2i76EJdd4O6eNn8Slu?=
 =?us-ascii?Q?W8kcfyaYfLxc5Ix06EDXFKg9nZpH+Sm40TxJzwLEDokw/eXs74PZwqe2QW7b?=
 =?us-ascii?Q?yJmcyB1O3/S1xIlpAJnkwBS/+avhNQwW7YXLEy6e/eJoYrKavxwqBMqtn2LW?=
 =?us-ascii?Q?+d+iaAFgHyGt0FWBCarGyfTqxdNs5OcQ8vxjfiI7WpHU+hche2MBSmKI8uTN?=
 =?us-ascii?Q?kGJkJeUJ4Ifpq5APCKbO4u5C/pQdg6FfdMwBXj2/8W7JGAJ3uRNcKEmjf4uQ?=
 =?us-ascii?Q?kfFhNK1zVXuvEhkiSXA3km1UZEX3ZY96Hyu1+Sy98bk8bHR1mmB3SNUbdCla?=
 =?us-ascii?Q?5cq7iHnGSk4Y4cagNlBQ/YaQY869X3et6zAVjmgMMu6/Ef6HQpFoVbrp1TSF?=
 =?us-ascii?Q?7omYHqjWPsm2SJk+hEpqDVtGanxk7oy0N/klWE0hSlEkKf56iu2+oPWdBkJl?=
 =?us-ascii?Q?2Zon5AlrEm+3u1J3C31jq37QnU96vpT9WMrEbOToY48YI91HuPZgzw38VaFg?=
 =?us-ascii?Q?pcaEzRlhCKlKpxGJStLyvt/+e/GbY9mXH3rjWaZ/fP9q1khdPsQ3KCwsAbja?=
 =?us-ascii?Q?Uzh+YTLIBGt785zGqttY625xZQTayYaQHuWbucMdTBxeHRazK9Pwj/K9bHJK?=
 =?us-ascii?Q?8773sd/6p/qQNodjdII6e0OxkVjObeHTtVKqWcvHqhKwxOq2IZ0ouyZ354d7?=
 =?us-ascii?Q?IY+RND8J2F36mU7QiFqm/jXsg+PVn7oO4yI1IQVqa9cVrb2IBvTdjqYywrqN?=
 =?us-ascii?Q?kuvJIWh7SUAbbTK38eFHp3JEDyYHxZWoOf4b66oWqv/UTEodad/Sdl/mck+w?=
 =?us-ascii?Q?VQ15E3OAS453Eu26kO7sywGOdWlVsiv0HqbaC4QP+IyY1qQdejt/Mkjt1xUW?=
 =?us-ascii?Q?NMgdUUcSrHhP6fWpS3IZgzpHRfloo7RAolt5AzzlauR3TmvWurJtKa4Y7imI?=
 =?us-ascii?Q?5I/VWYcJ036h1btGGGa7OtX1x2Ef4dtOTo0hXHlcEBSieqmTqX6JFpJqkSAl?=
 =?us-ascii?Q?C2gHiiTPdtRRAGjMjb9IZtvMpsmMNQ2K81RLhYIW0nSOgm+1CQFWHSOt+Ufm?=
 =?us-ascii?Q?AVjomCta16Wh8ZcWSz4QEcJ4GxmnBsPPQWm2qr4+3GvyBulp/xezit9S5hRs?=
 =?us-ascii?Q?840q5tCu9r5rHDYElNFLhfMeZg4lG2qO3YOGeW2876qnl5TE95CVbTccUIsM?=
 =?us-ascii?Q?I1cg17A5U/qxBoL0lZPMXJTjO6JDzId8EE3pvyTPkCNpGOkjHKT7iEKfZL5f?=
 =?us-ascii?Q?m+nBrEZg5kaL0d/3IHr++1t5oeWAALqKV7j7BrA8?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f1fd9ff-7cc3-473b-d544-08db2146587a
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Mar 2023 09:03:41.8616
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jLSEjPNY0pdmm+WPn7NkN1K2j0U7+i57m/URYXbCpRobSNuNpgA4HHNnbIRX5ETmBArRORXjMKYNBCzwdeslqA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6480
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

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Wednesday, March 8, 2023 9:29 PM
>=20
> group code is not needed for vfio device cdev, so with vfio device cdev
> introduced, the group infrastructures can be compiled out if only cdev
> is needed.
>=20
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
