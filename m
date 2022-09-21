Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7D5E5BF89D
	for <lists+kvm@lfdr.de>; Wed, 21 Sep 2022 10:07:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229932AbiIUIHs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Sep 2022 04:07:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229761AbiIUIHq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Sep 2022 04:07:46 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E8C77859C
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 01:07:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663747665; x=1695283665;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=lWb9aU1YsSbfSz5A7LqG/vbPs6/y3IH504LHPegNfRA=;
  b=m07gEKcCoWvby/mCUou73UAMpiepfI117bzuHh7aejQ9Qa7T6/8s5t0p
   1EpjVIs/zygbI3cxhJA84nrE/r38xV5ejs/KDV4q/4fZyPfwvBZGJqlre
   PBw90nKfjGf89UYGVlSWc2+XHAHUt4np3fvxHhs1dRFKsJeqPpoBJBNxr
   QEOdc26C+p27nmf0w2rhXmN+BC62CYhADCxezxfVq5Wt1YPBgW3X7L/6p
   U1dvuVNBeMR3llxDdS2xkXOhyhJfAW5qs1xa7LMAi2AduZoes/StDCo8Y
   rgDlG10Gp55078hEEVzK+VjANXTjD3veca2VN8vtVy6lOVMnwSn/S7q2h
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10476"; a="300771590"
X-IronPort-AV: E=Sophos;i="5.93,332,1654585200"; 
   d="scan'208";a="300771590"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2022 01:07:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,332,1654585200"; 
   d="scan'208";a="570435585"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga003.jf.intel.com with ESMTP; 21 Sep 2022 01:07:45 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 21 Sep 2022 01:07:44 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 21 Sep 2022 01:07:44 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 21 Sep 2022 01:07:44 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.101)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 21 Sep 2022 01:07:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bvCVVpy5/IMBNNhebObWGZsJpTzlULqgihyakVDVCcoasX3JRcXL2r9gnaKyxgkFZME/6P6byLGCTN+SM8IfGn85xpF+skwOv2KIBR8YsHQpkzyr/la6skdC9Jdk6DnRlWaedWYPU75kYRaLrXpRnpPJy/50w4YE89ZIcrGokTVd5rbfHyb4j0JN1pEi3KJQS51ZzoAnlTS7JyqIXZPDi8AtGRooVYwgmW8k6iCoNHQj/uHo5fvms/2tI03Ii0WG6iBk0KxoJK6hUl+QtYiXUVTuUsgI6tSa862z9t/RmIld5gh8QJnc9cGNbV0MSqBLI0qOWvxMdndYlDI0M6CMcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RQ3XWZAOWvphHOINcGIfMswqUsqy0I1smDa2rZrfTz8=;
 b=Jg7NQKQsgyCqzf0Sr5p5e979DId8VcHqhRRIdgN07WDQzeB1LMuUZRFaUdCBp5Hc58F8bztQ2HKS6SS86zSa48vAWIy2rf+LlJI3H5GJTy85FC7qUToupFZ4o/ldEDnPEQdZlf89Hf65U+XQpwyYQjXp7Rt6ZNFirEUNSxUn1xroQNORZhpO8sWP6sA4QqVrJL6OTlgjzyeTK5cZRVX8KraakyxuzvmuXIfUgeJpwzeRirohYygjuaAdJATmrUIlJWu/b0hFb87gYhcHTh9M0aDdSql+JC2j+rOONdeE/8CoKRSQCBTA+tz4bt3/KW4qzaPNCqOLs0luwwGepXTXbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SJ0PR11MB4973.namprd11.prod.outlook.com (2603:10b6:a03:2de::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.21; Wed, 21 Sep
 2022 08:07:42 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::a435:3eff:aa83:73d7]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::a435:3eff:aa83:73d7%6]) with mapi id 15.20.5654.016; Wed, 21 Sep 2022
 08:07:42 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH v2 0/8] vfio: Split the container code into a clean layer
 and dedicated file
Thread-Topic: [PATCH v2 0/8] vfio: Split the container code into a clean layer
 and dedicated file
Thread-Index: AQHYzVMYoiPFNtBX1UGxTtdoLJ59/63ph1lQ
Date:   Wed, 21 Sep 2022 08:07:42 +0000
Message-ID: <BN9PR11MB527613A28174EBE5450B4A218C4F9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v2-d7744ee9cf4f+33d-vfio_container_split_jgg@nvidia.com>
In-Reply-To: <0-v2-d7744ee9cf4f+33d-vfio_container_split_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SJ0PR11MB4973:EE_
x-ms-office365-filtering-correlation-id: adec362d-3e7d-49c7-37bf-08da9ba85bb0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: crDm+tadGAimS57Vq8DCmEbpiezu4Gvk3qo96lVw2y+fMWRafW7x5nKV9vQGQdjuACFdKdkHWbiclRRwsseDMrTq/w6UhkYfYS7p5NPrrDHX/rv6Jvma2V6Z9ggIvV1PkBwSGt0pMFwZVX2HbO6a0MFCgsxxF5p3BfqyhMcXdlt7D9T24Dv/R4hIWlRDwlMx7RVVcMpTqUGhEtU3YjYAFaMFUipP8o23qaj63oNPnH6G0Sv/nbcKvWbuYMNPlFQZbfTy3q/2Q37ExL9Vg9Tq3VGQKE1i7Y2/B/85aL4HQ8X+JcqimXpC6uilUe8EsylFN3G21Gu4ljD3+vYAleYrJL3+z8un7JFdI1ZJvvraRC8wBVoN+8da3yOjhoo2H+Srmqbm4tusM6lLP+p/cKh6SwfZfSPMAH4suWO2CLDmzT5yY6UPPCBhihZtu92sW/8o/Nw9ovhiQ5SoXciiVTXdPqvwvqsOXkWIrmCY/HlEwqHkz1whrb5q5I50WwcAlRGhC8vGzU7whM928SGdTmKMMUoH03n0s2Uc295aICR9MgTYdab3keinjn6J5pyj233NqTPW8TALSfzjG7jWqx0LTwcpr384nT6DERBomFKAVqBSmNzTS3H3MgO4dp18HxCQSszIzr2nLLnLANtHEI6nweBbFuaaZBZDVayvRNdebufKAMMGQ+iBZNUv8PlCRA7nDJrY2ggDHqp4wONZvxxvJEmtve9vUVhOq6Q/V83Vnx2YO0nijFShj2zZI183tdsVqUe60UFMcvxXkl2Vi7Px1/91kW38tC+juj8zCEAatOY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(396003)(366004)(376002)(136003)(39860400002)(451199015)(33656002)(8676002)(2906002)(38100700002)(7696005)(9686003)(41300700001)(64756008)(66556008)(66446008)(86362001)(76116006)(6506007)(66946007)(26005)(82960400001)(66476007)(966005)(55016003)(5660300002)(316002)(52536014)(71200400001)(110136005)(83380400001)(8936002)(38070700005)(4744005)(122000001)(186003)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?NvetvcfadXLelOGOrIKLKiZ2XJrcZ9e+RSISj3I4vZDDcGSIE4qPBgu2+JQQ?=
 =?us-ascii?Q?ClA4DZTKwipNO29owCXoR7Tk58jUoY6konjyZIVIJUs3AxnhNtUz8Zt4H6Cv?=
 =?us-ascii?Q?V6kfTt0PmNv3rcSlHs/HmK8TueiSbExCQj8W8tvXVl+t3kE5DDMUUqJdDdJF?=
 =?us-ascii?Q?p5Zz/iuNggUE2kb9dmYOFlHdSJEFfXPte+lGFaNXKwix4lAbJbHstRCix6Jk?=
 =?us-ascii?Q?Vn93ilAajyfED59a4Q7ISRPdNecp7/fREMg2yy/6SFxBs+YdeLR2x/Wvbm8p?=
 =?us-ascii?Q?1M7wwAPTpelqIzBy5XiP5qXQTdwcnSDm5ugjx9su0ukfMf6hIiPdF8bSwqXM?=
 =?us-ascii?Q?1/XBSDhfhc2E+CAklZiRb/QZLL5mDNxPY3Gx8E/kK8e5L+usQHcuBuw8Iwde?=
 =?us-ascii?Q?3tbPfJtRyVSQVg+CQaAhWTqtATa1rkilXVHcWqAx7GG8XESXI3chJlBIkG5z?=
 =?us-ascii?Q?t1mQe/tnJWyCZ3MG+Uvnhgr7zAaYoMv8G8DGZSfZ+ZkEFzgS7N/KVqoTY6qI?=
 =?us-ascii?Q?85T19L3A2Dz01b4NN9bgLSldO6kwyziGbiR2AVPwZHFaCY+0KCZ0SYE84RY7?=
 =?us-ascii?Q?U6QFPsPqBQLxDCdqPCcjurXpjUgL87xFI0daPzga/HDtA926xkIfkmTXTaxc?=
 =?us-ascii?Q?Xg7+dqB4Tg1UzHFLye27djMvcIN+T8CmU+VutD8SBJ1CmUU+VbEQ7HkkDwaG?=
 =?us-ascii?Q?92zjhqhxsrDqKyAVjxFO8Rlme2ontnC3puwQyblXgp7ple6TKkBl+573axJs?=
 =?us-ascii?Q?LATDFnV19/IdNRsSrmNNlwzlrcCZNo4z+nnfwUxHKZU8FhBhJNji9ksHK+xH?=
 =?us-ascii?Q?+QtbyQRE6VQRPhRnd9/5VtKgMxJK8Qzm3C5qTDpKdEUm+N+D/snBaZ31YSMP?=
 =?us-ascii?Q?CM2u8uz4x+LjsL9uIBdtQTdSRUfnU0/OrEcRT1z+GFfqibv0MfkWRmXnYxcE?=
 =?us-ascii?Q?hFA0UXYS9u76lqgoTVnhbECIuaWndyqt6rg+w5cRtHrd3lBLv4QKiUDTGdyG?=
 =?us-ascii?Q?oxwq3P4su4BivfO7OK957x/Pw+u4gUniyj+iGlxgXXstUy+ABSXQLKTp4sQd?=
 =?us-ascii?Q?yWfZQbgHrJCRuI7VReimm6lUCbU7alswFXfb04sGJc8cRQVcqr4vnQEGPAo7?=
 =?us-ascii?Q?zboKuXUcWRB5JPmbfRM28O5PU2dZwE7gpZkByGXiPalds9E3f+ZKG48NjG+M?=
 =?us-ascii?Q?xbu7ptRPKLx9XXBhq2/pUI00UDpG5pW93Ix9OjvF+FCErJALyiL/iC4cuAJ1?=
 =?us-ascii?Q?BgGtlzwXrj4PsTUAsY0Yvnj1f4WA6kwCOtG7gWUIKitov8w/o1Ha0VDE1P1s?=
 =?us-ascii?Q?GzePgSkPwcEbANpOyHq4IzZAplO5L/iidGnji3f6WQZt5V+3D83dOwBouVER?=
 =?us-ascii?Q?+9TZYqikaLL9wh6FAVGCb+cOaSBPm3sa4Jkvdo3hdd+buKBlinIkpredL+yU?=
 =?us-ascii?Q?eQfvGBU0kYV/WgC3rQDFXq+q6+8+Uf64dQZTCvZrfi0/zKyxCpZI47gHrUJu?=
 =?us-ascii?Q?DYSUYnKTmGyJCjSV5NL3xZcLDMyMxlAV3ebF8f/mPn4vlZFygE9anI/+Ty80?=
 =?us-ascii?Q?mZRRatS0XTJSc819qQX+Yr0QEx+1njrQYkA2cEeW?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: adec362d-3e7d-49c7-37bf-08da9ba85bb0
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Sep 2022 08:07:42.0807
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: awUsBsV6zdwOawEbo78vp30PZdjbyPrn/dorABg65No4TQxY+mg6E1N7VGFP4IvQaDdHW5pcdJDF6hQKNgSZRA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4973
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Wednesday, September 21, 2022 8:42 AM
>  drivers/vfio/Makefile    |   1 +
>  drivers/vfio/container.c | 680 +++++++++++++++++++++++++++++++++++++
>  drivers/vfio/vfio.h      |  56 ++++
>  drivers/vfio/vfio_main.c | 708 ++-------------------------------------
>  4 files changed, 765 insertions(+), 680 deletions(-)
>  create mode 100644 drivers/vfio/container.c
>=20
>=20
> base-commit: 245898eb9275ce31942cff95d0bdc7412ad3d589

it's not the latest vfio/next:

commit f39856aacb078c1c93acef011a37121b17d54fe0 (vfio/next)
Author: Yishai Hadas <yishaih@nvidia.com>
Date:   Thu Sep 8 21:34:48 2022 +0300

    vfio/mlx5: Set the driver DMA logging callbacks
   =20
    Now that everything is ready set the driver DMA logging callbacks if
    supported by the device.
   =20
    Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
    Link: https://lore.kernel.org/r/20220908183448.195262-11-yishaih@nvidia=
.com
    Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
