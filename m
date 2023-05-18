Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E387C708150
	for <lists+kvm@lfdr.de>; Thu, 18 May 2023 14:31:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231175AbjERMbW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 May 2023 08:31:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230149AbjERMbU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 May 2023 08:31:20 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E3EB10CF;
        Thu, 18 May 2023 05:31:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684413076; x=1715949076;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=+C8cy6Hfhaq8QGmGPh6dDXs7BtMBBf0d0svsQyRGCB4=;
  b=HvBX43c+z9nJ3QvDybEVn8Z0LOha9BrqQnrA4bzBWn42bK/nA5LWTg1k
   SF1go8mgpECVh9Me65yBtJ/iJfhj1kFxzU55DZUx5GdiQFx/+mzzFUchD
   pYvB6roh6Dx80/+vXSo3X/jUkdsed2NYiLOsSss1Bb9U2IQUfgEqlS8wb
   o8pGNkXzeX/golBsgHgsxJN5n4rrHLfT4Y+zMw9RHFGbKLtVEVF/t83UO
   7cChD/Mv5QKEc8vcGTLo0S+T6NotT2ns9yKXQuHSG4XbBf0ZTpi+D/Lmr
   Xw4JmFNOfKaNrl7/kjbWoEFivf4/pb+sCUPKAbBB/v9z9kxkLggyBYxSo
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10713"; a="352066921"
X-IronPort-AV: E=Sophos;i="5.99,285,1677571200"; 
   d="scan'208";a="352066921"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2023 05:31:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10713"; a="814306347"
X-IronPort-AV: E=Sophos;i="5.99,285,1677571200"; 
   d="scan'208";a="814306347"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga002.fm.intel.com with ESMTP; 18 May 2023 05:31:14 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 18 May 2023 05:31:14 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 18 May 2023 05:31:14 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 18 May 2023 05:31:14 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.46) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 18 May 2023 05:31:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HDOSFSFeoFGD5LOUyW/Dz1npojnq1OxJN1lEyRfPUrFYod0O97A4GK9oASEMkcjunutES07NGjE5So+7x1FvCaCbvAN3qp4kkSws0TekttnPbdq73kAKICMXxWSPg0hMH2PnN38Dom16sh5CHtrGaob/yWuC2y3ZeRvhXmSp1mREN2OUN13pFkYSZiQziR+rmOefs6kzSAqYdPtMtyCPtI+PgRktoY9icsBalW60OOuUykfwJ2noUWGn4Eb4KGNMePLQcMlQAjSZ9ByetZwh2dnnmZDU5gdNlH7BBGcdEuEtmU1fRpC6whgwqQJi5rEX3AjGmLrSEAI75fsTUsaCiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BYmcxkgCZv9tbBO7aq7phUbnZihrgaUl1mW7ozgGz/c=;
 b=Zc5M54dq0dPQ0Pj+bsNjztPzRSuggkjWhTAz4UpVOhryk/7NV8Nhxvg041tFuHNtW8mt1btHuS5z0XASpi7Gk/fC2iD8aWrWbxQ4X6A9JmRWPdtQFCY8TyZRKcP+5WpEltIYQ7F3WokOemLNE4mHbi68pkCmVl9ki77tPXxRz1REmELZbt0aumFS31D7cgb4Xwp1UBMTaFOn0v+LEelnMF1whd+rMBpVtkw2vPiQURewAzg9v+tx4JMzbYzihc3sPPGNH7eyjybMHjjhOvAM5yigJxLpytgR/WemRQTLhxwROIdxk79kIDm9OP7ERfafEyVjDwhz5DOFOcxWPfQyeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by DS7PR11MB7932.namprd11.prod.outlook.com (2603:10b6:8:e5::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6411.19; Thu, 18 May 2023 12:31:07 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::5b44:8f52:dbeb:18e5]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::5b44:8f52:dbeb:18e5%3]) with mapi id 15.20.6411.017; Thu, 18 May 2023
 12:31:07 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     "jgg@nvidia.com" <jgg@nvidia.com>,
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
        "Xu, Terrence" <terrence.xu@intel.com>,
        "Jiang, Yanting" <yanting.jiang@intel.com>,
        "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
        "clegoate@redhat.com" <clegoate@redhat.com>
Subject: RE: [PATCH v5 07/10] vfio: Add helper to search vfio_device in a
 dev_set
Thread-Topic: [PATCH v5 07/10] vfio: Add helper to search vfio_device in a
 dev_set
Thread-Index: AQHZhZ3iVxGFUF3+1kCaFUQ5PqHH6K9e2+CAgAEgUFA=
Date:   Thu, 18 May 2023 12:31:07 +0000
Message-ID: <DS0PR11MB7529BAEF7080D2EA66912510C37F9@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230513132136.15021-1-yi.l.liu@intel.com>
        <20230513132136.15021-8-yi.l.liu@intel.com>
 <20230517131243.7028bf9c.alex.williamson@redhat.com>
In-Reply-To: <20230517131243.7028bf9c.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|DS7PR11MB7932:EE_
x-ms-office365-filtering-correlation-id: f1b37890-4d04-4709-fcaf-08db579bc0e9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 45CbA6zvqyHUUfAoCKIXb/dkvw6iXf0YOVUiJBVHrGrrmny4z1OnSPgbAk4JYdLzyr2mhrbd73qQ7K0AIWcrBoDV6zeOlaEN7HZDe/UoDTOG5iT8ry/8iQD8rNocK714gm53lHJ56VW3BKK2C4BUC679ZKz3hX0vz0dKfCQtmF5ihYi27UQqZPkE4rohtcHC/wBsTcrCXelpv9HLT5w1t8TbLC0bpMOjaIxwW4QKKskAF9yrqWauKIBQiKoZKK1PacApBbKUhZ10xDPwey1QqxjdbrEccxG+s4G8jsSeFCK4vUBiqoc3cx8Mz/KjYSxC8CRVzJnbbTQBlgAZZze2mUK/S9kH8Jllfckx/PdSy+vr1xYuHqVYej6lK73fHTj14xMmuGXyD7OMUuDzy+1j4+jaTDN8SBEYyoxl2qj4MDvV/Umefykklcgq3he8nn8AyF6IPHw0rdbhRR8+vlrjduKRqUjRLbApVw6kv6feMZgcArKvVlBrzKsFmkLIYsXA5dAUwiAgpa6R7iPQCMKxkqcR7KRPXJ00kjIH1MiA+m557KSB/z6HENBoMrLN+pU6UX1woAYGQj8qXr5LBCvD4rSbLzuIT9Xx7NYvz26I6AqUHFyou/Q0xN3OtBXW+9oToB5O6d0+yZs1V6QNztJloA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(396003)(136003)(366004)(346002)(376002)(451199021)(6506007)(26005)(9686003)(186003)(5660300002)(66476007)(83380400001)(52536014)(64756008)(66446008)(66556008)(66946007)(76116006)(4326008)(7416002)(316002)(41300700001)(8676002)(8936002)(6916009)(54906003)(71200400001)(7696005)(478600001)(2906002)(55016003)(33656002)(86362001)(82960400001)(38070700005)(38100700002)(122000001)(13296009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?d/1GOyo//eg1Skv6r6G+KIqWO0VJocWPW5dY5awbe51rSVv0OGcV60a4j9Y6?=
 =?us-ascii?Q?FiX6BWKnF08sUKygTgpQ7lvmZU+F2d1xg6K184hXW1IeTfMzLoRzZnTo9PMj?=
 =?us-ascii?Q?gj5a6K0yIABimsuaJFQBb/OaVeXohyq2m1pzP/wBc9ztHrauGavw71vwC8D5?=
 =?us-ascii?Q?eq54r+vnmPWfC4o5a/mLqnWKvqBvi9n3xsWge7Exvllr/73SAiyHDul3sSR6?=
 =?us-ascii?Q?nS0FfqEono+RsSymuaJnHvvw0TWEcZqZvFKymgEavgCTQk7FvNbBM9Kx9+sR?=
 =?us-ascii?Q?qtAwjdWc+1pHUhYWi5FWDS/Tgzke2IhpA9jVRlSFKG26NCHW+tR4JftfYb7N?=
 =?us-ascii?Q?5qnhvs/475Vgk1nE/H4M8mHY0yKyvpnKFJBAHfENV+B+si1v9/5nMG9BZF2B?=
 =?us-ascii?Q?Pp0or1UOy1duJ4hU4Pc0xZ9YinOtw94HIOvWknsnCK+6Hev6vbpum6zJh1GW?=
 =?us-ascii?Q?hFf3rc/Frn/fABVW7e/g6vgKODzxPQQtQpbSdH8SKYj53yD/BO3vh1oJ6DSI?=
 =?us-ascii?Q?dqUOjCb4Ax86zBQinIPIouAEB6yrzRTiB2gVLNFlI6jmBtkxrnE/etlUV1h7?=
 =?us-ascii?Q?zrQL8aFfAhf6dvd2Q3aNipj8doJaYYpgUi/GY6t0AVrHyMjy1vJHvf+qPWFb?=
 =?us-ascii?Q?4vceTg07EtCbgwPlVbWajF/s+zDANAqa9WumG24hNPam0W7JB6dcmee+M7mn?=
 =?us-ascii?Q?9PDBjqVniQwJsdzNtDInAL+r4NlnHx7dAIurm93EBlpRMiJOQRiSvjr7GTNX?=
 =?us-ascii?Q?rT607MY+ri8sSdtFoDNx3wDb2arjcd5SxfdvqHrnHDByWMcV+M/FlDyBWsUI?=
 =?us-ascii?Q?YVa1TZjvoYJiQV595B1WpFRe6tZ5H8JfAd802Y8qHKjgND+uaSFYpFh6f991?=
 =?us-ascii?Q?pw2Sy+afD1yHuZGped8pyKWMXeVdpj+aINoynkN0hFl4Q/MrOcZt345d/TfJ?=
 =?us-ascii?Q?lai8Se+pETTkXZEcvrrqLrJbp1Kn7jOuYoLlV1aAki2b7ZP4cN9rQ12hHEJl?=
 =?us-ascii?Q?O3CkgEKNemlnzYdSISUWS9M8HRC7t3GPBc+QsvwzPj7ynb29pR4EBVpDl3t/?=
 =?us-ascii?Q?Iff5EvwKHJg7t0puICeW99HpSipq1YElPLrNp5ljLas88rwJeywLsZ+N8P3k?=
 =?us-ascii?Q?sybvqQDDBNp4UONkw8ZIxErC/B9JxOcQdo8p3j2ULf3pgQbVz6bDQ13Ku0db?=
 =?us-ascii?Q?ZSrgphqx9NOUeoOAuV/AMknQpexpi4gvtgblm9+fc2tjbdoLEf/mhXtNcluk?=
 =?us-ascii?Q?gTTZ001OJcaPd3E4L60Dw6RqwnyNEqpGtpmOD1emdZD5yMBBLthTiYc1PDae?=
 =?us-ascii?Q?4zst3+T+WI43ajI8fOHFaPpJVEdHBGG+bUC5DHTxg/H+tgP2Ni6TuPA7cRh9?=
 =?us-ascii?Q?2Poh8BpHLVbQ89Xi4yNF5Z2iaEPI6Rz/hfkQApxubgnFwkGUmOVb/Ow1pd0F?=
 =?us-ascii?Q?MyLLps4rF4BvmsspWSZ6cW399YS4dBn2gWIQ2QYOuaZZtW1IxcbEGBdiBcno?=
 =?us-ascii?Q?L+v3H0kw5CbMGP9k6QV+B3LP6mjS2dtac5heEDJT4A+kHkTihxslrPeOXG9n?=
 =?us-ascii?Q?UybQBMRlJMVAoCTzofhh/4G9P4LBcWE9wKUigmWx?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f1b37890-4d04-4709-fcaf-08db579bc0e9
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 May 2023 12:31:07.1006
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JFHe56rcw66F9ABXBYnYtgIzh6YAgYOBbQa/gmF1KB8dk+pWk+6pegeunDPZUk6GvdX/mNTZ72U+9LbpU7GLqQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB7932
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Thursday, May 18, 2023 3:13 AM
>=20
> On Sat, 13 May 2023 06:21:33 -0700
> Yi Liu <yi.l.liu@intel.com> wrote:
>=20
> > There are drivers that need to search vfio_device within a given dev_se=
t.
> > e.g. vfio-pci. So add a helper.
> >
> > Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> > ---
> >  drivers/vfio/pci/vfio_pci_core.c |  8 +++-----
> >  drivers/vfio/vfio_main.c         | 15 +++++++++++++++
> >  include/linux/vfio.h             |  3 +++
> >  3 files changed, 21 insertions(+), 5 deletions(-)
> >
> > diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_p=
ci_core.c
> > index 39e7823088e7..4df2def35bdd 100644
> > --- a/drivers/vfio/pci/vfio_pci_core.c
> > +++ b/drivers/vfio/pci/vfio_pci_core.c
> > @@ -2335,12 +2335,10 @@ static bool vfio_dev_in_groups(struct
> vfio_pci_core_device *vdev,
> >  static int vfio_pci_is_device_in_set(struct pci_dev *pdev, void *data)
> >  {
> >  	struct vfio_device_set *dev_set =3D data;
> > -	struct vfio_device *cur;
> >
> > -	list_for_each_entry(cur, &dev_set->device_list, dev_set_list)
> > -		if (cur->dev =3D=3D &pdev->dev)
> > -			return 0;
> > -	return -EBUSY;
> > +	lockdep_assert_held(&dev_set->lock);
> > +
> > +	return vfio_find_device_in_devset(dev_set, &pdev->dev) ? 0 : -EBUSY;
>=20
> Maybe an opportunity to revisit why this returns -EBUSY rather than
> something reasonable like -ENODEV.  It looks like we picked up the
> -EBUSY in a882c16a2b7e where I think it was trying to preserve the
> return of vfio_pci_try_zap_and_vma_lock_cb() but the return value here
> is not even propagated so this looks like an chance to have it make
> sense again.  Thanks,

From the name of this function, yes, -ENODEV is better. is it
Ok to modify it to be -ENODEV in this patch or a separate one?

Regards,
Yi Liu

>=20
> >  }
> >
> >  /*
> > diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> > index f0ca33b2e1df..ab4f3a794f78 100644
> > --- a/drivers/vfio/vfio_main.c
> > +++ b/drivers/vfio/vfio_main.c
> > @@ -141,6 +141,21 @@ unsigned int vfio_device_set_open_count(struct
> vfio_device_set *dev_set)
> >  }
> >  EXPORT_SYMBOL_GPL(vfio_device_set_open_count);
> >
> > +struct vfio_device *
> > +vfio_find_device_in_devset(struct vfio_device_set *dev_set,
> > +			   struct device *dev)
> > +{
> > +	struct vfio_device *cur;
> > +
> > +	lockdep_assert_held(&dev_set->lock);
> > +
> > +	list_for_each_entry(cur, &dev_set->device_list, dev_set_list)
> > +		if (cur->dev =3D=3D dev)
> > +			return cur;
> > +	return NULL;
> > +}
> > +EXPORT_SYMBOL_GPL(vfio_find_device_in_devset);
> > +
> >  /*
> >   * Device objects - create, release, get, put, search
> >   */
> > diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> > index fcbe084b18c8..4c17395ed4d2 100644
> > --- a/include/linux/vfio.h
> > +++ b/include/linux/vfio.h
> > @@ -259,6 +259,9 @@ void vfio_unregister_group_dev(struct vfio_device *=
device);
> >
> >  int vfio_assign_device_set(struct vfio_device *device, void *set_id);
> >  unsigned int vfio_device_set_open_count(struct vfio_device_set *dev_se=
t);
> > +struct vfio_device *
> > +vfio_find_device_in_devset(struct vfio_device_set *dev_set,
> > +			   struct device *dev);
> >
> >  int vfio_mig_get_next_state(struct vfio_device *device,
> >  			    enum vfio_device_mig_state cur_fsm,

