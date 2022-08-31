Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F10A55A7939
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 10:43:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229800AbiHaInJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Aug 2022 04:43:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229884AbiHaIms (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Aug 2022 04:42:48 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 699E2C876F
        for <kvm@vger.kernel.org>; Wed, 31 Aug 2022 01:42:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661935342; x=1693471342;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=h0xGs0CMOmN6wXFRirMTaRNm5i4JoTUdfBMsZMT7qEI=;
  b=JbuvkC1uRXjS5pStitNOun2tSdKo5adD2KM+s1nUg910M0XfDYpB7+68
   0fzck8dzDjWMEm/9sxHC2w/baLohxw5HWsTquegQ3ZJ6nq/10kdIUTlSR
   YC9UxxioL+9WKoaIqPMljtEfx7Yq9e2bPkYrCu6taasjSICtGKDpeYoWD
   eaFS5/XiB3SnkFHR1ZqEr0tA8Fde3DQcNVvkWrEOSKwvK1gdjCO6udgXS
   iqiLTM19lUjr39kONqzMlZ295jlHxUrTIDKm/k2ScgF/RXzDCZp5xIlhr
   3+boJFfGfvggjm4IbHL4oJ6EmAVSxm+7PNwORVjRh75981oR+qt9JfMnu
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10455"; a="381700896"
X-IronPort-AV: E=Sophos;i="5.93,277,1654585200"; 
   d="scan'208";a="381700896"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2022 01:42:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,277,1654585200"; 
   d="scan'208";a="645162344"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga001.jf.intel.com with ESMTP; 31 Aug 2022 01:42:20 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 31 Aug 2022 01:42:20 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 31 Aug 2022 01:42:19 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 31 Aug 2022 01:42:19 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.173)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 31 Aug 2022 01:42:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fiLjsK02fEWrtphCfuAN0A8CrCBLGqPA97farNG3AwPnc6Q7LpekYj7gj9YwUsPc/Vk18CPDW81K1p/bMS/dEmN+UXGB3WAIX6/B16c8726N0+S2wn0+J/ijTinvyrvlu8fy4e8xcGci4Neh17N132LoHP3FUf1++pOyBnvaFmo1/yYHNhHk34Sf/DzMt7TusghBnwIqEM2M/IeQsKISdM2qB8dXXN2P0PMOBDIGK4r9/+oCCqq0CYOVTDotzQ2GgWvHm8viLsjI0obdFjEEybqu5AOxr7CTZDpqv2GkK9nIdR5dXCqLQx8Of4DLKKICMJmg9gjCv7wSJGpB3DuBAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k1HxDOzyl5AQFV2F3tIIJ/CkrUAJYgBJiOnW8ruJj20=;
 b=gt54SUqqu4KNZ90jFqtUIHB7O+LB4nHkSSc4B5ya+Zju0cCvfL4R+HbsTHH8JpfUyEGRq+t/nD3yGHtxFI0u8xfzeAsvmKBzZteHzZYw8paRol1HssAizrjXcPm0CNsL5Gq0dol82sj60QdoUhmvHJBL/l7WTymJ9YQtsvh0EemZ5rLiY3eB7Fq+ayUc3C/omnGXsRgmaWV29jxEOeEFKruLr9Y0diE4JzKxIgcPkhM0Xs9/xJx54dAO9SHbeESbzRbv5LGA0y6T/70plFK7BvyNW0It/KB/ZsOUpvvKqB8cyUzDZ/GBX6Rhuh7cNt7Mk3cs1Uh95icQdw8pR8szZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by CY5PR11MB6535.namprd11.prod.outlook.com (2603:10b6:930:41::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10; Wed, 31 Aug
 2022 08:42:17 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::a435:3eff:aa83:73d7]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::a435:3eff:aa83:73d7%5]) with mapi id 15.20.5588.010; Wed, 31 Aug 2022
 08:42:17 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH 1/8] vfio: Add header guards and includes to
 drivers/vfio/vfio.h
Thread-Topic: [PATCH 1/8] vfio: Add header guards and includes to
 drivers/vfio/vfio.h
Thread-Index: AQHYvNVT+rknUb6o5km5WYKV48pee63IsCpA
Date:   Wed, 31 Aug 2022 08:42:17 +0000
Message-ID: <BN9PR11MB52764F22F96E12177D50C8068C789@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v1-a805b607f1fb+17b-vfio_container_split_jgg@nvidia.com>
 <1-v1-a805b607f1fb+17b-vfio_container_split_jgg@nvidia.com>
In-Reply-To: <1-v1-a805b607f1fb+17b-vfio_container_split_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c0c536d7-d1e7-4a0d-1c76-08da8b2cb628
x-ms-traffictypediagnostic: CY5PR11MB6535:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: O7uSR1IiycXUyR3XSzuyxPxXOnGOkeSiErHEdH+crHuCAKcwaZy0FCiqUEOhPy2AJ524uPvvgUo899Vx4Sn4AcTtlHjivjVPYip4nQ330t2bRG57pgAWoiDeA7AbYtP6I+h1zvM+fMAcIWc1JEsq7MDL9hwFbw6DAPUwvKVFHVMDj0x4KodyjousizpTsvX7KFboe8UwhS2nt/o9Cw9TAHSRFsPakDaaTSb9xckMmTrXXcqM8M4A1NWesgGam3eoKXj3kKaYHmM3fCb1/cGC2cA7qTr5sw+hTHDlNGsbQymrWvMmIRTJEJuBzrUrzll+cTjWMMyaS/1tNUy+i8B3ar4Ua04je3fCCk+gbtyiCJ0CNZnJit0WAUmiJoz/rGKtVy5N5scuD8ItWGfH9XhsbkpX/iPA3BYluTAU4z/4EtsL5ykdiK2hh9pIiwxPP0UyfRGGqD0fJ/GQEx1n1yp5Nxg+0GJf3/tCARtFgUckEwxY/9oLeYxix3Tfhor/SWxDd9ckU27Q4lkIQSKtCCtFPkQIm014PevFlKO8waO1sXkxICHEYF9XnoKqGgP+7ic4VPT81PztSBv318Li68FVXKlhymLK6V4bwDS4TtGmDB1Nh0WAIgN6TgawFO8UpNgqCnHSyLdd5KEq0G4wRF5WcPRmaYIEmIlxGeXnDiwpF40fOYVkUqDtKWnC+07hgnBxu2RMreIdmscefz2nsDM/Ca68h3yk3lKoec/e2bOrwvWxYLx95hjesSxm9ogVQRiw
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(136003)(396003)(346002)(376002)(39860400002)(316002)(186003)(71200400001)(110136005)(41300700001)(52536014)(8936002)(76116006)(6506007)(7696005)(33656002)(9686003)(2906002)(26005)(5660300002)(55016003)(82960400001)(38070700005)(86362001)(64756008)(8676002)(66476007)(66446008)(66946007)(66556008)(478600001)(122000001)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?6AqFMopUh9xZKaTJKwTAkQJzeoP1KcIwXBelzYTA/VJPzX4EYnYdjGdfJbgN?=
 =?us-ascii?Q?xGpIhu0WxOLQGCz9squtfKx6SdMp4YL6xm42cZ9uJynYYATeBgwPtU2TSfcG?=
 =?us-ascii?Q?/xeezIfC0dyOLw1gAKAqzrC3wqxzFTPxynV0D3Pa6pQTyS2THYuvG3LdoCr9?=
 =?us-ascii?Q?EEt4VOdEd2Ckq5YeVkSJkHcokcluXQ+5IGBYGl86L30ySwpY+F1vnHuhArIu?=
 =?us-ascii?Q?wSBOv82tQMMsvRi8vZV1eaV+Xw/2Www0KCp44dB+kSm/5+NuW03UnSuAJmPh?=
 =?us-ascii?Q?eA+2q3QPWml044CFhlvmTL5KYKDjT701jwjdy/sW/szoj1KIxoozabwgcHB6?=
 =?us-ascii?Q?gEB2bCrSRt+qndXrYuzUnGs+6tpUPJvf78/VpxLJ484y3vv+MkCMrZ9FAcTY?=
 =?us-ascii?Q?lqNlHDLSNP6fF+o+qIOBmfRv5ViFwXjqrFNJCH54WQ9r+f03mHs1euAId4aQ?=
 =?us-ascii?Q?kunCeRC2TZ4pnSVcfq3d1qVmy55AvyJ9OFE6TK36tnlXpb1nrvLT/P9vVI3B?=
 =?us-ascii?Q?RbQuH/Qz+aX3MmLYif/u93NHN5aV4sI7yNrK2KDs/iz5hDyzi/ELwHHbwl/S?=
 =?us-ascii?Q?9ykEquDh93JvOJdfUTd1nr8Q4nXnlgVSOQmiMx/brB1juh2eydupEq04bcQt?=
 =?us-ascii?Q?Zm4Wu9YjcXS+mL7BhI+uzVb7pNRGqkzfDXc0/dRe8B2kxNJlAfc8fj8FAlyt?=
 =?us-ascii?Q?Vno5M64orWrOKWc6XviVayXoE6yKq6+Dw5XrmLAlbCZBEmK2baqNvDSQg50g?=
 =?us-ascii?Q?nKiv+OYs/Nj6i/z6ckhw3Y510+HdEaSBlL0niQZ2QCP7yWDSGZKBkAt0R74l?=
 =?us-ascii?Q?oIhTFDeuuC6mALrbzQd5SmAKRzUdtpb3q8cYD8T/4RsM/fFZdqdlSPoOu8AY?=
 =?us-ascii?Q?ce0YIS1nSWv8CZ8KFXthll/0Td0r+dI3KyzsEM/l5S6rSUcCnuDkkTu30LcP?=
 =?us-ascii?Q?APb6bJSCk44CHuBd3JDnzDHqWQCzz39oqKJsJJPAzQJhvEgqiqXJMGSvhXmB?=
 =?us-ascii?Q?GcipCRKZAv86v0dvioR/9QO+fCffBCd/EZVS7dgpVOi527tqHrAv/iSvkYGI?=
 =?us-ascii?Q?WCD9tvtJGw84HKSjxf7/U1fp30QZoSki/667ZGuVKK1llBAmRgASgD4IDujh?=
 =?us-ascii?Q?SsMHRQUJK+7kNqzavnBtIZS0pnOBLPSxs3e7+LoS+z3esg6GZXwCWujIM0rS?=
 =?us-ascii?Q?eD7FR4dwqNECAmZMu5DeaIgLUov1kXWjkzV73RmCxY9SlPfHRdeTGOz2pvvc?=
 =?us-ascii?Q?Upm8skHIKWRM9eiSus/RB/inuoFq4aEVob3MT7cZaeKH0MOKojGMmV6Zg/8F?=
 =?us-ascii?Q?ubw8Xty9B2RjCmc6cf57p/WjGQX6GNcT+SNY5Hr4GxmmnE/cbWuw3wWelvhL?=
 =?us-ascii?Q?gH6IzM4hg4EJrkIWSkWrnfvTkYLzA8BAhge7WG3uVpi8YMePMNwDGkb7OGa9?=
 =?us-ascii?Q?ET8Sjmq16IP68b62iMcSNOA6EpEJqi8dSZLzoimtZhSEob1VXV4r3rDcPwan?=
 =?us-ascii?Q?ghlRVBrw6HhByjBji0k2mdRfSRJ+Z4g3eDKQmwuCLx76vOOWIvdYxTrI78+3?=
 =?us-ascii?Q?BbP31D1WngF55libLsDZLk0D1eMyjBlhm354uD7N?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c0c536d7-d1e7-4a0d-1c76-08da8b2cb628
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Aug 2022 08:42:17.6625
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KoJ7a7Zl6pY/Bndo743/l0Als2uZxk/PQj5wEL9ctwH3PEsosJELixw7hzyYkbbdAn8Th457YWcu/EN9FN5NDQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6535
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

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Wednesday, August 31, 2022 9:02 AM
>=20
> As is normal for headers.
>=20
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/vfio/vfio.h | 10 ++++++++++
>  1 file changed, 10 insertions(+)
>=20
> diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
> index 503bea6c843d56..093784f1dea7a9 100644
> --- a/drivers/vfio/vfio.h
> +++ b/drivers/vfio/vfio.h
> @@ -3,6 +3,14 @@
>   * Copyright (C) 2012 Red Hat, Inc.  All rights reserved.
>   *     Author: Alex Williamson <alex.williamson@redhat.com>
>   */
> +#ifndef __VFIO_VFIO_H__
> +#define __VFIO_VFIO_H__
> +
> +#include <linux/device.h>
> +#include <linux/cdev.h>
> +#include <linux/module.h>

Curious what is the criteria for which header inclusions should be
placed here. If it is for everything required by the definitions in
this file then the list is not complete, e.g. <linux/iommu.h> is
obviously missing.

btw while they are moved here the inclusions in vfio_main.c are
not removed in patch8.

> +
> +struct iommu_group;
>=20
>  enum vfio_group_type {
>  	/*
> @@ -69,3 +77,5 @@ struct vfio_iommu_driver_ops {
>=20
>  int vfio_register_iommu_driver(const struct vfio_iommu_driver_ops *ops);
>  void vfio_unregister_iommu_driver(const struct vfio_iommu_driver_ops
> *ops);
> +
> +#endif
> --
> 2.37.2

