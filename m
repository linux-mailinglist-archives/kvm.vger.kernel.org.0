Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AE726F11F7
	for <lists+kvm@lfdr.de>; Fri, 28 Apr 2023 08:50:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345270AbjD1Gu3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Apr 2023 02:50:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345400AbjD1GuZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Apr 2023 02:50:25 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABE3630E8;
        Thu, 27 Apr 2023 23:50:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682664617; x=1714200617;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Z0A4Ledeefyu8ca4GLFiCJtOAehscfKgTCnokAWn6HA=;
  b=OTHxSbaQp1jIwVSX18IqC3IDUd8v9b2jOc423Rzr8rOqT2s4m6YxRDKJ
   KyZJ1SHn04agKrjKxO5nd/ChCROQs/wRW20hskyzesNqLJkIdkaPx6Xed
   crNDDmbGKfuUhgBHOW0fjsc5lLI9+NCgVwW+3Tz7/ybyNNLevlP0aYZA8
   igG26C6sptCD0smo+M8HOD3aK+mFzLdgFK3F5nOQlaXSLR6LMatbDJ5xv
   2Jo5TXiJ9XI2YTLQ7dzdrXh2ao3+5otn1zE1iMs/1bsI2MlsBDggplUqX
   jfhYJmF+mt0Cizy7fH4F0HncVYMElyot9UHlcakMCC8Fft+6Zd3igW0A6
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10693"; a="346430724"
X-IronPort-AV: E=Sophos;i="5.99,233,1677571200"; 
   d="scan'208";a="346430724"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2023 23:50:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10693"; a="818894187"
X-IronPort-AV: E=Sophos;i="5.99,233,1677571200"; 
   d="scan'208";a="818894187"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga004.jf.intel.com with ESMTP; 27 Apr 2023 23:50:17 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 27 Apr 2023 23:50:16 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 27 Apr 2023 23:50:16 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 27 Apr 2023 23:50:16 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.174)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 27 Apr 2023 23:50:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YKWipDdBnxG2hmfjZTkgUVKWH1vd5cZUfmQ+mHZWe1Zbr/aXCtQ0WrY1nCEqkLUpBhecMS1zO6Dva9DUyC5F8DYR1LvWZRL8KKcbm2p6/Jo9dYq37taBqVrf8b6cFXVqjIn8TFPfZOv5eYjEX1o/AbIJLAy5GsWyDiUtaEA4ORP2WBbg6gokzIZSxpl3KOgAFQqL6VtDq5c/c9sdphOFDPGscugR9IEZ1akIVl1PG1DX5I/NwpfMlIYuugiwv4dFvShnyGumbRjUtf/f9tVNqkuE1pUr7VNxlKBL1I06T9TROHBo9qiDBFjvT7gaG1RHzZi2DEigPzLMbIveYn2zaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z0A4Ledeefyu8ca4GLFiCJtOAehscfKgTCnokAWn6HA=;
 b=g3uCbS91HnpyXeD7Jw2dJ7yOwaLnq1nEr3G3tbrPFJ9JgaZpkWm8RHyMniz50PiiFseweGLzpdxuLKtSCBmJiKNOo2E/azkHZWvHiLRNYGJvS8CDPoYpH7alswXWqn1IZ1N9WefzyGGYvhXzLOXQOpv5yAkwQ/CCybzZEPtnXofzjtImcdCRFZWXyOsLtIVOUkGFkK+BMft1MWjnVOXT2zL8B/t9LHF4QylbpzqKQXB5KU70aueFqmkwCntArYSGfiR19sCmQwg8jvbIYukAK8YJGT+mmkvBoMDSaa0n+0D7AISWpFiAJolso/UfnrgwEPOKAkjfUQVBBKiem3aSJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BY1PR11MB8126.namprd11.prod.outlook.com (2603:10b6:a03:52e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.21; Fri, 28 Apr
 2023 06:50:14 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::73e9:b405:2cae:9174]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::73e9:b405:2cae:9174%6]) with mapi id 15.20.6340.022; Fri, 28 Apr 2023
 06:50:14 +0000
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
Subject: RE: [PATCH V4 11/11] vfio/pci: Clear VFIO_IRQ_INFO_NORESIZE for MSI-X
Thread-Topic: [PATCH V4 11/11] vfio/pci: Clear VFIO_IRQ_INFO_NORESIZE for
 MSI-X
Thread-Index: AQHZeS7MBSktouZ2xEq5hzyOGt0sa69ASPQA
Date:   Fri, 28 Apr 2023 06:50:14 +0000
Message-ID: <BN9PR11MB52767DBE26C5817810FEFEBC8C6B9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <cover.1682615447.git.reinette.chatre@intel.com>
 <2370aaabd9c006747233df6678eed1b51ccca426.1682615447.git.reinette.chatre@intel.com>
In-Reply-To: <2370aaabd9c006747233df6678eed1b51ccca426.1682615447.git.reinette.chatre@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|BY1PR11MB8126:EE_
x-ms-office365-filtering-correlation-id: b2a88b90-119c-4855-0a43-08db47b4d203
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: i79ZUBAZ+Wpzz/fd77GP0NEI0oF8Y3inXaDOYPHMObQM/BB4roAXgcWnL3TPs1aXYnKkTil7LOGjYqfmFPA+pdLxotytm4WOiHxwzZhUPDRkgtIRlsrsrFrgcwd+xNkyvdISrjt941txvVd/2ffQbpzSdoLPYuX8NyrNjm44Dz5nI2qxex4exFMZIfYDC7BUuR+xxQZnEjYCSmhHyXmwWNTwOQYeWh8lVXppJE9Qs+jFPAK/30A7rmvgfZsiQeduOMuEQKNpYG9DjX+N5tN09+nJcsQBbQAQK15nQwRBM1NtRhPifbIj8JDhaJ+7sRhWnKswaU905rc+AjKFvoyoTq22Yw4CvMS0vAv2P0xfkqTqs+/1mzspJoRB1/lTBRFA3WqvUaC6sTltG7E4H9b96vQOzPr6xgEy8ziXCUzbWRJVl9OZQOgZkq4dIAZl2Ygw5MLOBD7byiBgno8SUnAX/D0Me3WqB/kIiALIWOQwmXSa9EwaBUaXedw19rTt2nez72/C7vWOmML+9RFrkAcKqP5oKdUSiWFUJJqOGth9y4pObMEsPQFVTIE4WpN40FaBrcXB1aohgSNkS8+zxAHNkedjMpNnG1oa9SNC2v5B7e2khqm5XwmuFlk9rtTGqMx9
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(346002)(39860400002)(366004)(396003)(376002)(451199021)(66446008)(66556008)(316002)(66476007)(4326008)(110136005)(76116006)(66946007)(54906003)(55016003)(5660300002)(82960400001)(52536014)(41300700001)(8936002)(64756008)(8676002)(38070700005)(2906002)(38100700002)(122000001)(186003)(26005)(6506007)(9686003)(33656002)(558084003)(86362001)(478600001)(7696005)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Bj0960jFB79lUgZQ/CT+YRPggWmPEVUtozOcl7roh8ikLQvGjyPmckvRguA+?=
 =?us-ascii?Q?fQvtrsPrXcD5GfTunhGH1BvH5MnJ4RKOJFGT5DHlWsEWsYHxG1Z3Q7Co/149?=
 =?us-ascii?Q?OFLUuOKBvQpGC+hawCw9rGDLHzkP2JcH/rD7v/pYmq7XkOxCTJC2Lfz7SlvA?=
 =?us-ascii?Q?eYZUvTE7jwHPhxhq2DsE0O1qAxMeDuoM6fpRYYDOF5asFE7j9oXPmOdKSEhi?=
 =?us-ascii?Q?ne1QPNto+drS6GxoAr8kQPs9I02Zg46qsaZFcojCzq6A6klHXjKV6zpodZ92?=
 =?us-ascii?Q?pajBAfDdiLFsFfMxW4t/AlipcAF7vG0RXYmNqD4ap9LBRGAoo6QPoBLmPacv?=
 =?us-ascii?Q?Mpegt6xkbEgB8a3ZGybnVRykabfOG4CKqWSy2qHXfAeKCpVrPdEu3QblySi6?=
 =?us-ascii?Q?az2uigPbIZqoJWeQ2sE2N0KGPa+bdEJgjWgSSYqvZvWgiB/cVrhKoU5+s5nX?=
 =?us-ascii?Q?kN7hU1VX1pV5PQDmQ8Swghhm913nZ+jikhsQbSPUTXZNM9ATlXqZyb+9BIoq?=
 =?us-ascii?Q?JtaJy1rLx1OkjlrC2ngUmX67JcAevvY6ZJne2SZD2/RcjJJJNriNFFsv2FIa?=
 =?us-ascii?Q?LURT4gvV2SVy4xvVaNRDTJ8EJXb0PHjS9w20gIjY5XSaSXv07ZkMXrvD9bOM?=
 =?us-ascii?Q?v/Qw+nSeTk8tHaVCtHTWJW3Z0uXtrKj2AT0zIqHtqM81eb2PHiRTJyweKTZV?=
 =?us-ascii?Q?NDLkpJknFjBQfKtmzSLa2ht0ZVFHC3Mt+zMHptqUUgsU5iYEYD38gdZei4e3?=
 =?us-ascii?Q?bPOZip9wfEyUbrskK6kkThGM+560gWJW/iuNQRYsrPDngVEzfXLzZMa0Dv5i?=
 =?us-ascii?Q?m4q8bomDUWSAMaBZ8yAsb8kXFT8BTAoK7R0e15zJYDbYkxvZTNQO1gQVxO/9?=
 =?us-ascii?Q?L8sqkSG8UUvqjakhOYqaTCWx9/77c0k++cwZcnpSOgQtLjAgOJxVy9bg7oOA?=
 =?us-ascii?Q?712awQL+3nFBttQHF94hqaI16sp0/siIdFg17m+aB3KPkWMziBl1MlymEQF+?=
 =?us-ascii?Q?O8mmsnVUpwe3ZgQ4D7jVYH+V+ClXWusKyglUFwzlGLXiMiUe2jVPHM5qu3qI?=
 =?us-ascii?Q?TbM0FRX+omhT/l3wpCtRRzG0VXegOZOi7RA3H/3qraSxTrqh+10A7T8U2mWw?=
 =?us-ascii?Q?k7ig8xJwoK2LyQ2wdUaR8hIjIM3CBnnLH3ptnwp8MJNmn6c7r+0wJfx/VoLV?=
 =?us-ascii?Q?bljqTSBZBR+0Q06OlNcdNXIT4O9Sg8Rz5ftodtZOgfzmKijPw5A9LdaTqpzn?=
 =?us-ascii?Q?RYQaEwW75dinQsyobRv0rHxe+Y4zES5jTfvgp7AC7Hju8MZvWqvKrAemiFh5?=
 =?us-ascii?Q?APuo8N1K8DEr3v4JS1IvVBBtxza/o3KYyBuot8a+he8EVnWipOj9aE5xPzVh?=
 =?us-ascii?Q?1YDBq7XOo1Wmq7emTpo2AG9e9KXNfXHuvseOM4OTKGo9jlylqjV6j5JX3XsO?=
 =?us-ascii?Q?R8e7nvFK70h3RmCXczBPNNoKHMyhA0kTB/Tu0BF+UYeFvZjTfBT8PJqjIWiQ?=
 =?us-ascii?Q?HIh5Lj4JzWk/Y5CqvJADxbKznDNipxK3fPqYj3X0SuZ+/xIrwNIuh2y9z/Aw?=
 =?us-ascii?Q?kIFXT2AIiVJTQVjTehUUd64JVUpUnU/2nEn0li0D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b2a88b90-119c-4855-0a43-08db47b4d203
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Apr 2023 06:50:14.5599
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: q8fidbd/sJ/ibHz/5zJ4auxlLvuqvPAyVjX96fRneSEUFcKa3DvAfcS+wfIm5XlC3ls2/WBWXxy4IJND1zPn7g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR11MB8126
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
> Dynamic MSI-X is supported. Clear VFIO_IRQ_INFO_NORESIZE
> to provide guidance to user space.
>=20
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
