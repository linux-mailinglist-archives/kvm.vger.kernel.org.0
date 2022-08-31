Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B74555A7954
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 10:47:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231289AbiHaIrz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Aug 2022 04:47:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229804AbiHaIry (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Aug 2022 04:47:54 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59636C6B71
        for <kvm@vger.kernel.org>; Wed, 31 Aug 2022 01:47:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661935671; x=1693471671;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=ucPergTqPg8O/hNVVu7exIysFu8ifxBbXtyDzTXEGVY=;
  b=kMUXOMHHFAX+n2OME6HbPvV9NmJ6N+wT+8ojRFBpuPqz9CT7l2t7/AvY
   SlIvdsYs8142LtnIwZniJhDZYqNNvbPis0uIuO8WgA91BxuEl3UH+DJx3
   QpKYcyOrDiZy5IhNwrPFooa9AR/PWYpi9L4AIOPAvI0yRtG7dSZIa80rt
   ctlznEGlxdDYjNw4Q6p9dgMfliknTMyznT9N/SabYcjyh8jE7HUjnnV2Q
   F/ZKhdEYZG5KsAPmrQLNVuyEnRCDbe6cFAf9Kx1jaDUIDtInORM4WP1uw
   Ppg19geQviN/32Jco/CupA58tE+LZM9tmZQISTpjrsJkU0bJkjLyyyDct
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10455"; a="321544107"
X-IronPort-AV: E=Sophos;i="5.93,277,1654585200"; 
   d="scan'208";a="321544107"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2022 01:47:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,277,1654585200"; 
   d="scan'208";a="857402283"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga006.fm.intel.com with ESMTP; 31 Aug 2022 01:47:48 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 31 Aug 2022 01:47:48 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 31 Aug 2022 01:47:48 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 31 Aug 2022 01:47:48 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 31 Aug 2022 01:47:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LTAQ14RgbYSszgbnx03qIibqyzDb2l6BeQtcF8SFLWhDpyYnh1SwRtyUQH2ACOm9R2BQUMv0bLpOhpjVBsgMZ/4bZiuJzwZ2k+e7XGe4t1Jg3ecXEY1ukqlgH201khWJeEpaYS5Y6VBL0uSMpSfTwYddoAAovkAVJiFBd50lR4OzAvZ9mo3LyOA3HioKMj/dCZgi+JE1ifxFmlPSLnWpYRNWXF2l3l3fHvqX7j8VnifNocTYMb/GfGCOheMFWAjYNr/QrWbsNDEq8KGCl1AU0KzTUsqn+KIfJ8ejEEkHmDX/L3EUWoUHK2s/nG8nlFGv8q8oW6oDLjotyr54k6Tl7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dYiZCKeSQ2l+ZY4fLJ5Jlv6p3l78A/bcKsF3zPNA4nI=;
 b=dum0FdGymMhGkzROsLWF9bbOXOuniemvwoW2z4k8qPG9p067vUM6OD2CesQkl7teF923bvs2BnDPiofy0UURLtg7WBa/kftZAUjnJ/tbNphEagozqholeKVygiGh/Rq+Wn7UWygl0s7R94G9MbcW3Unu+1Ljv7OnChuwZyYAhqOq04NYIIhKl2k4QWyjyl3ibbo8UByfRzn8qQ1JK884ad0S1T0jIqQ7ckzBzNiX0bMxk4hFeUhTrZH7g4OPmPq7VB+rBaWMBPHAGgbxqBG2aJMEE+Hdzl3GJEMDDJlUeqrEo91+2GD2SMpF0SNPMLQUUrXLwO+ui+n8MReFk6cClw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by CY8PR11MB6819.namprd11.prod.outlook.com (2603:10b6:930:61::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.21; Wed, 31 Aug
 2022 08:47:46 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::a435:3eff:aa83:73d7]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::a435:3eff:aa83:73d7%5]) with mapi id 15.20.5588.010; Wed, 31 Aug 2022
 08:47:46 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH 3/8] vfio: Split the container logic into
 vfio_container_attach_group()
Thread-Topic: [PATCH 3/8] vfio: Split the container logic into
 vfio_container_attach_group()
Thread-Index: AQHYvNVTGCZl9uFUFEe2Z3BEhjBj2q3IsrsQ
Date:   Wed, 31 Aug 2022 08:47:46 +0000
Message-ID: <BN9PR11MB5276E01A558BFC2397D8AFCC8C789@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v1-a805b607f1fb+17b-vfio_container_split_jgg@nvidia.com>
 <3-v1-a805b607f1fb+17b-vfio_container_split_jgg@nvidia.com>
In-Reply-To: <3-v1-a805b607f1fb+17b-vfio_container_split_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 078ba3bd-2c86-4e60-a23d-08da8b2d7a25
x-ms-traffictypediagnostic: CY8PR11MB6819:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UX9B0cEttr6vFbi5LSu5O8tevwJitlhsdpfCoQViDj22CRlsMa3THUct67LR+LP80B1XCLUC8LvT3n1uoYODO6Q8bASgDLd71RTVskdY872vwCEcT7ZAA2etoaaoAbLSsGNvx8YzR4thI2594mH+t4K4chwCmsQcIsXriQfN18wEoHkHB3jaz7xCe9IGwccAV4GHvB+sbS4ho+2FXdaYPVL+BwJkP9KdkDPI9I9Ju2YK+fTKe2f3LMj7BacCDck6+0IWBb25fnCZiOql4zerwIn8eOY1jolCItSswaFZ9Uqt/tPzUrZsj0mhzadrFjJBvOA6QFjiVH9y4ZmDpE+4JrBdyZOQ/z0LFCBMMDnSUUiICzVB5C03IWCRrd3kukZzVZJ1aBbieYDRjnAJ+HV+ITqLPF/oeZXKN6yWYqr6Scm2KvyjolanlsB2ugHcwyDwOwJPdXfGPbuESlI0h4JWRqwgUDpMiUs1eyBhxWUg5tv7GN+XLSX81hG0qjA6beMEjZ8MNHNNlxD1+8JkH/JW3dgBE4T2KC3233R/+GEkYZHArDQV76Jh8VVkUjtgMVqu4TUbg2rnr9V87qjbLI3ano9m2ptkYYQo8i71GM2u/3qvDeHO3twbgp9MBqwwrm7OwDiuexImylCCbefFBxrNWbYwOcWsrhHN1BcEG8x2leuUyWzWOmdIbfP7QLivD5urgYiqZa0yE90CafeL5MkWhc6D0Cr40UtKcHrhd3YQZRVXQ4ISYtG6nB8KbIZR1O44UZEoG5LSp4XdpGBWu7orhQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(376002)(136003)(366004)(396003)(39860400002)(66446008)(66476007)(64756008)(2906002)(66946007)(66556008)(110136005)(76116006)(316002)(7696005)(8676002)(186003)(55016003)(9686003)(82960400001)(38070700005)(26005)(6506007)(52536014)(71200400001)(478600001)(38100700002)(83380400001)(122000001)(8936002)(86362001)(558084003)(41300700001)(5660300002)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?MznoX7xPqMJ+2AW4d+moMXGqb+giPFUIlNKJoVA6/xAbi8q3ITGkg0AmExfp?=
 =?us-ascii?Q?AO4qkxFjx8S3QiofEpMi3SfdiaJXO82QzIQ2YBj2QtEOKSt7licRqQYGq/3D?=
 =?us-ascii?Q?P/WSY6bTwZpKxrMivoeYEGLROVk4nlGB39vZu06Cq3XRjhY+95W2VyvAdjY3?=
 =?us-ascii?Q?eLfZbd3aT6U5UinEyiwqtfofBtDKXYxtixpo/mLOdhbdfH/v6G9KA2RvNbZy?=
 =?us-ascii?Q?4SW1zApCqT6sTG4fEopPmSBitAaiFqG0VKh3/iLvvyxYE4G5SbEC7o2jLSjT?=
 =?us-ascii?Q?c9XmAdIL2ZlEZHu5vdq0mVE1gGU6bm8QR2Wef3/lLrnAkAxcYQDKFCJChDUx?=
 =?us-ascii?Q?z2u2Qkor2WpngwA7uHhx+kZ1mSONbkG+FA4QdPTQTQbsBp+t3eBA/JLPimog?=
 =?us-ascii?Q?UM44cCOhl4q+w27H9qqSuYyoKREJDhV/cVwCnzR2epCrAlOiq0Vo2Hbc5lam?=
 =?us-ascii?Q?5TtzpY2/+WWDTgCD/JJ+VzskPxN4DOPMGTGoDeFWaYE/s+VuAJ34dU986053?=
 =?us-ascii?Q?pfIYU1p+jnsvvRPxuTErTj4e2pGORPBxga+qVIzC1YOvnyeT07Qch3HIVxqi?=
 =?us-ascii?Q?NhcaFer/nF7PwGN0Q+1UN1PH512CFVyt2xu+oEIxE/NxVa+nb7GB4EwQNBYv?=
 =?us-ascii?Q?9eGCAbxv5q6ygNK2+gxHPYrqWsjmt09jWJH86Gr0aMAZ3COr2jCl+xSU0Lln?=
 =?us-ascii?Q?3TIuG+adNPLZydRly0PsyPYtWJ0kgzQGBNKsHm/HcZNTel8zF0dpKZOnUy9L?=
 =?us-ascii?Q?niB1iyhWd2H/jBs2ORTCMBK/ljTskxJH+aZc++Ydw0KZzIPgMxmE5cb39lfG?=
 =?us-ascii?Q?9kRe/kzCp389EIMazTxvxLWWKjzIgtDXz5xyRpZAMXjcoTK9K+6RuRMHlORL?=
 =?us-ascii?Q?jl9ZJHORtD5B1CKYKksLHaflCBs8jiGVWj/WzztdBJ9/07DpAeqKWRAthNtj?=
 =?us-ascii?Q?BjpLiGarOSN57DwP35aQAM0CNl2eIgZWoaqjGhg3glDJugYvbFQTeIF7LsuB?=
 =?us-ascii?Q?2Koo601y+Mf6r61OpvxQcZU3spmvbvjDr4GRBLmRRXOSLtGRr7u0XQXAj6dZ?=
 =?us-ascii?Q?7EvNVqMSDWBksH9Bc7QLJjbf0lGKkS65V+59vrD+VYqHza5MidsQ4b8aXFhk?=
 =?us-ascii?Q?aYmHtSnauc6HDlDmvoRY1fC2lLDwnwULn2HtWFHG2zObl2MxyCcKvZzj/FRo?=
 =?us-ascii?Q?N32pcvEfDx1L4/qa4G6qSoIX54Oz4wXgT1kI/EX/De8B3RIqX2Q2XtLMojhD?=
 =?us-ascii?Q?a3evUuclkLBivTdCB3UQ06mRZEWvWHBiQLWpN1iIaBqMBr6yocw7Gwba3wHz?=
 =?us-ascii?Q?ulK90LRbfuktZq1eu/GtK6FVc9LW9uSAB7pC4b9jYppQrg9+Wuq6bHUXZrpu?=
 =?us-ascii?Q?2DTBh3a4jdM3JV4wr9o0IftDouGO8P+Z6TOTNCoThPvwlQGRi6yUe0EIMA7l?=
 =?us-ascii?Q?k8hhu/WHOTsCgTiRO+3mEz2u99XExmt+Z5bH2Y5p2Jo+MNMJdEdtjC+UyFK9?=
 =?us-ascii?Q?L7KcI2E/xHxsO/Anifi9YmigpUluxn897Vx7Yy2Ocb+FyM4/RB2fGmTS3iK1?=
 =?us-ascii?Q?twCene32gc1IiFZWjZFhkOT+z1Knj2DCDNOWLODI?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 078ba3bd-2c86-4e60-a23d-08da8b2d7a25
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Aug 2022 08:47:46.5109
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kMDu3D04sCY+9BMN9UWsXQx3iIx4yN7lXdnBPXdYpsJzawWz/5bIRAnupTwTENyDyIo5s9OlDIE+OqWVRkmnpA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB6819
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Wednesday, August 31, 2022 9:02 AM
>=20
> +static int vfio_container_attach_group(struct vfio_group *group,
> +				       struct vfio_container *container)

exchange the order of parameters.

Otherwise,

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
