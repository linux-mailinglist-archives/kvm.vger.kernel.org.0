Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49D826F11C3
	for <lists+kvm@lfdr.de>; Fri, 28 Apr 2023 08:29:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345317AbjD1G30 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Apr 2023 02:29:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345285AbjD1G3Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Apr 2023 02:29:24 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2A7040E5;
        Thu, 27 Apr 2023 23:29:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682663363; x=1714199363;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Sl6mxpl+rcdE+WqBX+uDw8djsfYpI8m1HFxITujqPcE=;
  b=ZuWvQA2744qms60DA7U7pDO/nZHUfh7VuLZ4NdC5SOvXwT1LQLBcNaaQ
   tsgC7TS3b+G2JERR3gdvl8C4lHltmXKbCM/1y3xhVwtM6WlKAC8VQ2QHM
   8jKhKIj8DF1GGgWUzlDVBaJywKWsoY5499CFXyKdBFx/J7K5d0SqT8toy
   sJLs8w3+FHXkUXlPtSH5R/aNrFDjDfjpDhIkk5AkdS8AJ6Y7pL2BUGT5b
   sdZWRevy5zBa+/u5iJYGokKMudY13PzYgNUrqTPriKYmBAznQe7ufP9OH
   VqWyM7GGUcPt99C0BMlQVuZUEkjNzBXhymNVxLc6lNhKN07wFWaxsgnzP
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10693"; a="350572693"
X-IronPort-AV: E=Sophos;i="5.99,233,1677571200"; 
   d="scan'208";a="350572693"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2023 23:29:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10693"; a="1024467527"
X-IronPort-AV: E=Sophos;i="5.99,233,1677571200"; 
   d="scan'208";a="1024467527"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga005.fm.intel.com with ESMTP; 27 Apr 2023 23:29:21 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 27 Apr 2023 23:29:21 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 27 Apr 2023 23:29:20 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 27 Apr 2023 23:29:20 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.175)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 27 Apr 2023 23:29:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H0HFnFmvEv6ZFaMi97l8io4/iUzAa2dn7UKD4QqHTSd9cONnp4qU449qH2iOzAK9tnaavcG1zqCMFUkqHKlOIF8VBR9st+IZI8h5CUBo6IuRaD7G2hcaO7W175GTYBR2XFGaZb0NHBYtIV/rQVA/pornu3QvFbNfyyxPDsPfC/gqAP3JuduKB6SJ9CXdA61nfSmWrB7xCQ668s51M3k/dkNf8GccwnB8IE9t74RhhPHSBAQw9qawiFuIqgS0NzoB11JOgVK+rDBgAEZHdQ5qIObCVcrT7EZ5rrESmgMWSLCpMmg9LCnlOrPjUH7vng+69BqUIe3BQrAwerdyHFj6/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Sl6mxpl+rcdE+WqBX+uDw8djsfYpI8m1HFxITujqPcE=;
 b=HcbZnZ4GfRYZee9KRdtpfoWhkj/9RnoKwfRZVGDHpOxKaAVCKSzQ5DvQX+OSzdmd4Xd6XEyKFHkV3/FIPw1rbfKCw8dcEsQdKWQ5VScECqD+zH3qSnNwjubNjW2iUDZMbYBJsbUWm3GFq3f8qkFjw/rL0lxZ3Zu4vDmUK4Pq9tl21CKt2ttJpnkof8vSP8+GJi49+3co3CkIwqSvTpTOG/AakgikjLCYILOIgaqM/0Drfl4eoVW+5iUemmRv3se8ark7BzYffZ/ZeFB+N5qSI6iblE3VLkXjufCdDZcS8fHAFpvOhzJN/F/I4qMetKhP5diUs6iExbrm4aY6v4yudA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SJ0PR11MB5581.namprd11.prod.outlook.com (2603:10b6:a03:305::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.23; Fri, 28 Apr
 2023 06:29:14 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::73e9:b405:2cae:9174]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::73e9:b405:2cae:9174%6]) with mapi id 15.20.6340.022; Fri, 28 Apr 2023
 06:29:14 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Chatre, Reinette" <reinette.chatre@intel.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>
CC:     "tglx@linutronix.de" <tglx@linutronix.de>,
        "darwi@linutronix.de" <darwi@linutronix.de>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Liu, Jing2" <jing2.liu@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Yu, Fenghua" <fenghua.yu@intel.com>,
        "tom.zanussi@linux.intel.com" <tom.zanussi@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH V4 02/11] vfio/pci: Remove negative check on unsigned
 vector
Thread-Topic: [PATCH V4 02/11] vfio/pci: Remove negative check on unsigned
 vector
Thread-Index: AQHZeS7KcXyJMam5/02OfvR6IA/q+K9AQwAw
Date:   Fri, 28 Apr 2023 06:29:13 +0000
Message-ID: <BN9PR11MB5276DC8D4CE6751954C9501E8C6B9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <cover.1682615447.git.reinette.chatre@intel.com>
 <5add301d11d4a566c29c487a78b4227ae383f11d.1682615447.git.reinette.chatre@intel.com>
In-Reply-To: <5add301d11d4a566c29c487a78b4227ae383f11d.1682615447.git.reinette.chatre@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SJ0PR11MB5581:EE_
x-ms-office365-filtering-correlation-id: a63e1051-7e8a-4db9-a1d2-08db47b1e299
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2iLhYXbrhMrW0nWEhj8j4n9/pEfb7Qkj2XselEAjMFZ1Euaz5rMCYcu53c4y+mYiW5+NSFZDVjZL92k0GHY7w5lLFH5jd+vZ2Hh6lBDNmVeGM6ekn7i1fwuX9SCB/B5PWA098878rG7Ta2pxvDHPbuyM+IsD06N8R24cHNlKcXW4mWHgqFNVDMN27YWOK2g66+fU5MOxkIbGK1/6dUNj/VyMHcTeMTEwyeZlatsYK/Xol0wQPJAIZc2aCfSMaiaMcJLmDruBTGMcOy4bTaIcG1baN+1xSmacK9A4Y2108BvofVHmP8U+VARvUC5pcQmKUXDYoNxbg7VTijGPoRoNzFpHEnEHTzJZ5ozhYcDMudPSda9gSXKsKYDCydnCPbQByuJ/H7b5NiFhiGCVcLDHHj1JFRwecy1X5WLS/fkuhMpf+AIWrIXjjiaHc4y6OqgxeaEpYx4tE+W2aHNcmnPn6e/Ko6PPXElvH3QlfqlvZ32Z513DtQ4J9nqgn1P4UvX6h76QL51yxEtsaoiJOajqIFapBduhaEYESZJYaIqP4lWaksF9Hgz8c8COziBs12JUZgE6Bd5JmVod6ua12RULUOWCEFnrjtJIGAqSaeZmHoCkXHCgtZzbJzW3PGv/h1JM
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(39860400002)(136003)(396003)(346002)(376002)(451199021)(76116006)(66446008)(66946007)(66556008)(66476007)(38070700005)(8936002)(8676002)(316002)(38100700002)(64756008)(41300700001)(33656002)(186003)(4326008)(2906002)(4744005)(110136005)(54906003)(5660300002)(82960400001)(122000001)(83380400001)(52536014)(478600001)(86362001)(7696005)(55016003)(71200400001)(6506007)(9686003)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?BTM4jKWZxu8GM7+ytFgh7JoSE2SXn2V9lZt7CldGP6TpMXbw1/iBhO5OGcL4?=
 =?us-ascii?Q?mWSstcx+YoYN/kAbqA7Zc/fb/VfuBas5qdOQn1EPHUq4arK/kO0xeN7LxX+H?=
 =?us-ascii?Q?iMaQd8Hzycbb61pVnEVKzqEe/zGctpwIBLD409muG7FUii+eqqq+y71nA4Fl?=
 =?us-ascii?Q?WFnoT6IiowsQ1rwggY+M9lZ/HA1UKXG7uJIL+5OFDH87b6jCRI7KOMdFn+UV?=
 =?us-ascii?Q?detuMyUnEoIJFCSvTlfrPddTq9h8Z5bTN4n/w5V9q9pxKXMYK8LCstNINF/h?=
 =?us-ascii?Q?10WeUcxegMReqqVL+2ezYxSBy5EQuQxNMIEVeDvbFGQ/nN5MazLj0RLtseld?=
 =?us-ascii?Q?lGU0c/Nvqp9gDIBE1mlu/stY8tiwmBXxs8SEq75o7haN0ha1YMg//I6SZjvy?=
 =?us-ascii?Q?W9AHf/2EcHinhKZahq7XlJjfTjdVP0n1TIQTvHI/U5fGkjCoFwavJeL1wGaB?=
 =?us-ascii?Q?QpRYsenPwSFPlIG03yuwQK8Am3rqlRtsg6GSWiFRKamGnQG8UnOCVt+Kpzrw?=
 =?us-ascii?Q?kN75iYnjW/lU2kkpLUJM+5ZTV6LRErCrRe9jB+LCBkcHQAFj8hR1pgQfkJaX?=
 =?us-ascii?Q?8WDJ5iZxKJooKtkTtxmUUjgNkzBe+XoV96DhK4UsTcxFFh8jVhm+aM13T5MC?=
 =?us-ascii?Q?6coadXpnuA6rJRoRhH90QFRntVjwJTh82Y1EbzjMa2HcjQdoOb7KI5wUIgSL?=
 =?us-ascii?Q?rB1aJmx7CfyEWZoqoh+AnVwe3+UweRLjocLqKHgcDMeZkhmVug67D/v3E/lD?=
 =?us-ascii?Q?6CTKBnfYShOSzGVxGLTrCjbRmQ7uwdN7CRZ11kMvjWBQPF1tPfxQcsPM6ke/?=
 =?us-ascii?Q?2cB0HrgllqwSeQVlhf+2bxzGqWDolfyuploR3mwbE3UllPjaQNzPEvTC+sXO?=
 =?us-ascii?Q?Q27K1jcFBH1sWpAdCrhV5KFgda2tWOlu9/jlIlGNYKED8lUmcaOmDgoDQOl+?=
 =?us-ascii?Q?z5YNZRGWqSgqLhQZ6QNQH32Pw/6bHZ8npUBMXVncCf/U1OLbZpCYadrxDOyl?=
 =?us-ascii?Q?kdJe8ucI33Fi/cO5o4uMt1uXrMx5mlwbcIDfs0KltpPaq1W35vi8GGkT0v56?=
 =?us-ascii?Q?/lo4ntVezthgRxzGywUvW1hNyAO8JktiBbnJi4D7kdh75MEUPyymdFdcRO9L?=
 =?us-ascii?Q?ERBN3Bp7lwiw7tuAnYL2jXs+HirCCZPkWzvb6eKFakgZChQjP4hQlPQB88Pc?=
 =?us-ascii?Q?Z5o+IsWdxTHsabn790sSrMDLB3UKRrxyhO2NHtPPGuChhAWh/qJDCnLS9nIG?=
 =?us-ascii?Q?Aegf2hV1BJku40uk5zjGq05/lfTaVUe7b/7KRSa6Prz42GXv1VjxyTewIWaD?=
 =?us-ascii?Q?QvzTP+rViL1VQB2kotl2soZywM55ldoARpyNJjA8WY3Gij1wMSI0h8YSgMSm?=
 =?us-ascii?Q?flIkGY2Y/3nKZF4Y8JqOWnZwpFxNAjbhC0SbxTc7EjHtKdzfHhbC9f3eu/Bn?=
 =?us-ascii?Q?n2DYJfxgqEUYXjy49e2gTGjz9jRoCt7ZGyS62oogLsOwPboZz3PUy4u3cjhS?=
 =?us-ascii?Q?qvLulJCBi1GkeeZrxI0lrOXkR5t7TAaHP6eD1deJ+BZ+jseC7MPqXYJZXVzi?=
 =?us-ascii?Q?+OkjhHQRiO36oxJlQgE68v7p52aiQcsLq24PKIYa?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a63e1051-7e8a-4db9-a1d2-08db47b1e299
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Apr 2023 06:29:13.9322
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dbk8Fs7ypvvkor3S8FYDHx6SszJLKZVNSDaKI8lzyZkLK6sfkHNKKQJmyRiFgUsnj2l1UsJKiBBbak68VKWZdw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5581
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Chatre, Reinette <reinette.chatre@intel.com>
> Sent: Friday, April 28, 2023 1:36 AM
>=20
> User space provides the vector as an unsigned int that is checked
> early for validity (vfio_set_irqs_validate_and_prepare()).
>=20
> A later negative check of the provided vector is not necessary.
>=20
> Remove the negative check and ensure the type used
> for the vector is consistent as an unsigned int.
>=20
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
