Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 368956BDF4A
	for <lists+kvm@lfdr.de>; Fri, 17 Mar 2023 04:08:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230028AbjCQDIZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Mar 2023 23:08:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229808AbjCQDHr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Mar 2023 23:07:47 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E75CE19F3E;
        Thu, 16 Mar 2023 20:06:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679022405; x=1710558405;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=hDmRJQOzUF2W8q97PRdDMomTqmwjpDb0NI0N5L6f9JM=;
  b=Gwh1rX8eeKgQK6fFsntgLb5Fcw7UZI9Coop5kvBwzjiqKTI0R8OMeeYd
   OijYklnhvD/tgox+MGJSjIJeLRFVxdr2aLXn8v+Id4JFJ4tDp3p+bTHAU
   O1JNWBYMCfn2QcE2nRuBnJh01MG1K+MgGEYNAES+AYZbsDWLqxZR45jjI
   0fgWpQYlZ27amxB6t2g3+wk9wDCRx9BS4FlQTJYH7Jp5AkWVMHh9Wumwt
   As5+wVs0JxCBRS4L/ZUUEOYKQWeCExcdmcihAvFurYBktmpCigtHW1c1A
   PnuyicWM2UScQKHkn4a2plsFVWf2R6tsKGme0XSdhCW7HATcpyu4hXqo8
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="317825455"
X-IronPort-AV: E=Sophos;i="5.98,267,1673942400"; 
   d="scan'208";a="317825455"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2023 20:06:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="744401412"
X-IronPort-AV: E=Sophos;i="5.98,267,1673942400"; 
   d="scan'208";a="744401412"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga008.fm.intel.com with ESMTP; 16 Mar 2023 20:06:43 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 16 Mar 2023 20:06:42 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 16 Mar 2023 20:06:42 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 16 Mar 2023 20:06:42 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Thu, 16 Mar 2023 20:06:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NXbVqMIkKJbXPq1k8feevniESKkRoFN2VQ4FqjorQQWBmQqON8InjZ7bA7eNjo00/2H7W+cCJNI+gin98E7a0zQxkhU4II5uFNw7mbeoOUz/Gw0PQ5F4LCalb9ObImRQAVoOfh1oXN1wC8onYgOhJIcyijFR0fJXKZu1aweVRwa8ksS0BLkM0/jtsvo/Iv16cFS8Zzrid3bjvaL2DCQtI+bgVcfWSAv5ArOoQp4CA2CAZ1iUgKWvsXn+EPNxxtkuG4HAFFs7yy4gGfYTTia75+Zj9i3gwqc+cbyDrHfOLKXVejkRbrTFA7P3VaNco3QWxaiPisTnQc5mVj/AOV6crA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ayK6DJNABC5KZRpGvXl6+AybkN4D8vO4QqnzaytiYBA=;
 b=dtYOl6BUB1RvT7e6PdqhU7vVMMMtzmZC2qPOcujjv8C78+KO2KY4V5x0MSnfiH5uzoKxuvCKv/c8P68j5Nzg9iXg4iVcA+X6obk+ctxF0lH0boXZr1uFMACL9wwky0OwNeE3thiYvpN3iRXj1HtoSPiTmMl+e5azfG1RTSwV02yRUf6xCePnTqxwegPQgVhwAdEvrlTutmTZB1V0Bzvil3sdWDEt0BodDuqc5rPqwcEuDv4S/7YmsqCySqLvIamkLIjjqW23Z2TYipe6tY1upDHV+UQtl7KaIjsTrO4Kioxk+8+CDEMP29uFsTE7+6w4SkbYxxk85gtaZYPX9+Ke2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by MN2PR11MB4744.namprd11.prod.outlook.com (2603:10b6:208:263::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Fri, 17 Mar
 2023 03:06:35 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f%8]) with mapi id 15.20.6178.031; Fri, 17 Mar 2023
 03:06:35 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>,
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
Subject: RE: [PATCH v7 15/22] vfio-iommufd: Add detach_ioas support for
 physical VFIO devices
Thread-Topic: [PATCH v7 15/22] vfio-iommufd: Add detach_ioas support for
 physical VFIO devices
Thread-Index: AQHZWAax+CvdKTBrfkWcFH8kNPg/Iq7+PDSAgAAOPnA=
Date:   Fri, 17 Mar 2023 03:06:34 +0000
Message-ID: <DS0PR11MB75291C8343E91ACF2401AB3CC3BD9@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230316125534.17216-1-yi.l.liu@intel.com>
 <20230316125534.17216-16-yi.l.liu@intel.com>
 <BN9PR11MB5276399B61F4E2E260BFFEBA8CBD9@BN9PR11MB5276.namprd11.prod.outlook.com>
In-Reply-To: <BN9PR11MB5276399B61F4E2E260BFFEBA8CBD9@BN9PR11MB5276.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|MN2PR11MB4744:EE_
x-ms-office365-filtering-correlation-id: 4544c01d-b6fe-484d-5a77-08db26949d8b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: a6TSzrtbAoL7jtLQByBMG1op0uJs6/43qS0tBDaPIbUt8TKCL6VYJd4Ghc2f3gexUrem/GqF4TLgFakjUkTQWwZsjohsU9UhFS+688Fc7pzcplWSog/+L7XVepHXgSbMFMrJm0f0PzXaf+RWHFswRe3hnkH2KvfxsFGAvLouiXw2bAM1hGuG8cOuYAmjsrpQQ+BuaHGkNSRaMGJEHrMVBClHrJ3zXjySL7MGCKKW7aqpI9/Kt2pOH1kD9g4YQmElh5FRU4lv8cBHJfJQohs0UIUDtSAXHWGFF/Ya9dfK19JjR+kXPNg/GqQj1n0u4ZcMOg3fcDsRM/bOcdjg+x5+kuNJOKW+FAm94/Q1l5Yw19gVTXmaCnv5jGTv/skdPALHaMu7y+3i3KPNT2Gu8c0wMJ/QxukwMCLOQ55Srq/12giSO+8btS7douDYhiGsD0iCYuf7Gwf3kRwP1n94qiV4F9oCxCouefyZI72k+9SCddtRmAP4nbVREJs8Gma5vyMH+BiPQpw0FkWkyfaiEZCskFgbVDT3L6/3B0DiS/iWKrkFqQAvIssWQUw71G8QtYr9VQsAOtjZhCqKkFYFSdzKdeYV5lTlddkzWIohzGENWnnSVUhxVmO81qn3Z8czl1rmiuAqjQY2xWWxxVp0are5HFafUPUtNJpN4plEy8d/B+dnFvVrH1zIzFBa7jq77pVynKNUtRIOMxnET440mYmTpw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(346002)(136003)(39860400002)(396003)(366004)(451199018)(8936002)(4326008)(9686003)(5660300002)(26005)(186003)(52536014)(7416002)(6506007)(41300700001)(86362001)(33656002)(316002)(4744005)(66556008)(2906002)(8676002)(83380400001)(66476007)(110136005)(66946007)(38070700005)(66446008)(38100700002)(71200400001)(55016003)(478600001)(54906003)(64756008)(76116006)(7696005)(122000001)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?yL2iqZ6SrN/hBkxzhiNrzMYa6u0oyfP5LWUYeSpf0tbsCwj6vJ28Sh0sKBsb?=
 =?us-ascii?Q?spPgaSic6MkVB3qGodIEs8xZHzIlUDbRmCvHryx6mFoFr+ban8IB8oUOSnrI?=
 =?us-ascii?Q?oBQfvHJ32K3pIf+/n9IcA2cCbuuU7u2X/EUH9Y3ZqBwAyzEImnsyOfNoeKId?=
 =?us-ascii?Q?xnpL/+sJKqOfgl3hn/iQcwoLG0nTYcQokDDoEbtIPT4vOx6AXNKsoOLQLbn9?=
 =?us-ascii?Q?RPbpqftIt7EEWkLrCHgj3BCbaQv1NtaNUT25MBSqT8FpWDoe/mBzYn0paRf/?=
 =?us-ascii?Q?KPZI9C+hZo/IPJz1E3GwBFp5zQFSSXYG3SK/5VuRmR7PgsOlSGTAI/yXBfHs?=
 =?us-ascii?Q?TTFn7+J0GIWermX7FKTW2H/3bgEfj5qdK02WH47gUDwHdfLfDRxD4vNTYsIr?=
 =?us-ascii?Q?HNRUiJq197aZfNeDp1S+m7qV/WM6oefIPSAp30y9mL4lVfWzkXr6RvFTjkW+?=
 =?us-ascii?Q?il4pdWN+vJQBx1Xihgod4HfXPE05VyPewPQV4Q4Hc/lXbj9tQRuNCdet3H8k?=
 =?us-ascii?Q?3p5dY8UNH5pzTaN8x9IcMxdWekBLCGuaf/Nh5pDEh3rLrruL2Bf+1j9/yeGZ?=
 =?us-ascii?Q?6juZbQPZWLZ798rRQN6oTx2OcHf0IZhiXW2sH7ClGcSD5Sg1lN8sRSlwnY72?=
 =?us-ascii?Q?tkVoi6TB38VRfbJ0jumqOSJahnkzqOuHYuHd1h3VTAYptVgVnPqa6xZU3mJ8?=
 =?us-ascii?Q?jdm3JSrUewtDbyRWlA7nhT8mzH7OuSj7h7loUFfhF9GQgayhnpnmqEb3Ixxu?=
 =?us-ascii?Q?+h1hLTBjx/v9ftl2SPELSKE2eln1nCBL/C27OeUMgyRmJHBJnefugCPgCFBU?=
 =?us-ascii?Q?sItYYfo8uScm22m4B5OKJJSGltlwcyDW4wD4IxBvPleOkjXvtOPj3eVdJzim?=
 =?us-ascii?Q?cvm9FKcwaY36O67ovX6nrhe/jAQHmjO5ui5kO5zDH8UoY0W8FvYX5AOtqKs8?=
 =?us-ascii?Q?TLW2RI6t9NnPP/WmPo3w40YHwKQWzhXqepFemHi9/TrOG9DQdl1Ud8V+oRLd?=
 =?us-ascii?Q?V12J/pLUWsmuOInarFrm0/9StNoFdnTvwsS9yFJy70WGMfIF519/O27eakmB?=
 =?us-ascii?Q?C3QaP6jeS8WR2qvfwYdHW2Fha5JV9E7q9B1xjUX8WF53FrD+J0pgxg27/soT?=
 =?us-ascii?Q?m1dLgTePEELOwF+E6hqUugdFbphJQuaFRPd4yLOfduWFBBfa2FXva3/uVim7?=
 =?us-ascii?Q?bK32bbIfDUWrBM26LPizjKQlgpulLfq0D+GLdM1ptMWdS6Se+xplIWDKb5g3?=
 =?us-ascii?Q?UqGosQXw+TkQfFgSc+uVTIIvEfbQHSyoFk/5aFXP3LKTz/q1ziWqN1yOyBvm?=
 =?us-ascii?Q?RSI9eFUSaa2Hbn+pMKn5RoAtTPHasEptkW4wXxnS4zWdhdYTCLyjSBDRN3Ql?=
 =?us-ascii?Q?K7acY8sHm0B1C0gTYOw0taDw7vBRckgp001bXiaddSjr3Mt+4Me0b+75Uksk?=
 =?us-ascii?Q?AnzTQbGeVf+s1kRgR4q9mzg2XLaCD4pyOMzTDlgmlZwAKdJBkDmejn/Cao2i?=
 =?us-ascii?Q?HYU40il1mb9itJTUWHX9k3KlihVckxNXwWdg8AdHYycJ9Ro9ldrWDOWy5tli?=
 =?us-ascii?Q?k0kyY3zyOJ/7g1BiDLcQFPsaytjw5Bznvq/8GXb3?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4544c01d-b6fe-484d-5a77-08db26949d8b
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Mar 2023 03:06:34.2916
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jmy0hCU33nTOJDb4ylYkJZRoe9uft8rImBlbiKWAjbPuRp7UOm06Gp4icj+eXsjJtk8VP6TEY0KfG35HbY6p7A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4744
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Tian, Kevin <kevin.tian@intel.com>
> Sent: Friday, March 17, 2023 10:14 AM
>=20
> > From: Liu, Yi L <yi.l.liu@intel.com>
> > Sent: Thursday, March 16, 2023 8:55 PM
> >
> > +void vfio_iommufd_physical_detach_ioas(struct vfio_device *vdev)
> > +{
> > +	lockdep_assert_held(&vdev->dev_set->lock);
> > +
> > +	if (WARN_ON(!vdev->iommufd_device) || !vdev->iommufd_attached)
> > +		return;
> > +
>=20
> the 2nd check shouldn't be a WARN_ON. It's user-triggerable.

Yes. it has already been removed in this version.:)
