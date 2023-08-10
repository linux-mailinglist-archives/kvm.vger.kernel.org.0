Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77CF2776E2F
	for <lists+kvm@lfdr.de>; Thu, 10 Aug 2023 04:47:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231140AbjHJCrV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Aug 2023 22:47:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231319AbjHJCrU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Aug 2023 22:47:20 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABCA21FD2;
        Wed,  9 Aug 2023 19:47:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691635639; x=1723171639;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=/WnrbMW80utT+lbY0w0287V8eDkHm+h8ytzuoecJbic=;
  b=OV0QFC/w+GwXF5pHZrSys9kX2okzycbSF2qtZAqawGDZv4wZ6NPn3lf/
   U4B9S2g+YbCZVGJrh6/x5Pl6Em0BR666TG2XKghJ9CqMosNe7eg76pbfs
   ZlKCbcSm7VOV+8+gtQVDvronMmGDeU1wI9e6dU6NWeUMGd4b5krNzja20
   1SKU3eNxtKo4e/M+cjrsKWPhSoil7IlpVW4NnRDNge9mY8RdPHn0aXEvF
   q8y5+1bEnxrtRsBF3IWKXvy8IKTcULid6T+eegOdREVCWL6z8Y49h/v4Y
   noCthsOVacUdD7xopyxlGpT1pC7f4p7J6SXyNhWTByv/BJczUsfG+1v1Q
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10797"; a="350861782"
X-IronPort-AV: E=Sophos;i="6.01,160,1684825200"; 
   d="scan'208";a="350861782"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Aug 2023 19:47:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10797"; a="735233033"
X-IronPort-AV: E=Sophos;i="6.01,160,1684825200"; 
   d="scan'208";a="735233033"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga007.fm.intel.com with ESMTP; 09 Aug 2023 19:47:18 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 9 Aug 2023 19:47:18 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 9 Aug 2023 19:47:18 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Wed, 9 Aug 2023 19:47:18 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.42) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Wed, 9 Aug 2023 19:47:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m3p2dhnkANYA2LVECiBaFn1xyuX/KM0eiQGtgOGYTzOSbnzotsj836kyzHb3fEkbfYOYKM9oFavc/zWbBBSHjci5pkVfG2lc7OkZ+pgYz/QegxKyLlgqFmM0OtG1fSkVS/6Qh6C8p2FbB0S2hv07IHfXFnvLG5PlHhevvWLLbpXo+rLoiTG2v0UZ445auT/uki7hAiWvrxpqezZ6eyWznuDdHgTiEk3Xh745wJbk1p+g1JsZTSMC9pAgu96xL3+dNK3i1oL3jKWf5A8LNpbOhtWRYtKsbojZtsjnTjLtM/gi5hxdFhZqxlXMzr2qdqSyTfTmDSgS0MAv/Nak09PpQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MLI/bMKMB6w2pN/9vjyWLrGPBI7qQLWRXhFdJQ6TrWE=;
 b=N0pX4jYYHCXdeSkzMfnRq5AbxEGvgytDOK4BuRRlQlrG7wEu0oZ4eODm3zgkNIAq7CAPTpXAR3lyi41dW6BihGqGeKmPSDfLbXWr0ZHGrPiA2z6yp5HP4JK8My0gGvhy9wWT75tKxEli+EsibjQRzCy6gsLRz+mTEMjPqsVQ6kQA0EZqVmZ83v3SlaX7aYx/VQxMPDIORSoC2sn8tjdqghG29o6J7B3AJAYsCYw9RGQglyl3xcZwJmA+DFI8BHhXSbZNZ/+8+Q9LIIILoi9uKPEe04ejImvdFX4g82Q7zpvOiIX2P8bb6hcIy36yGvPwW0VuWmKsBANy8qSvo89g8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by PH7PR11MB7594.namprd11.prod.outlook.com (2603:10b6:510:268::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6652.30; Thu, 10 Aug
 2023 02:47:15 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::dcf3:7bac:d274:7bed]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::dcf3:7bac:d274:7bed%4]) with mapi id 15.20.6652.029; Thu, 10 Aug 2023
 02:47:15 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     Brett Creeley <bcreeley@amd.com>,
        Brett Creeley <brett.creeley@amd.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "horms@kernel.org" <horms@kernel.org>,
        "shannon.nelson@amd.com" <shannon.nelson@amd.com>
Subject: RE: [PATCH v14 vfio 6/8] vfio/pds: Add support for dirty page
 tracking
Thread-Topic: [PATCH v14 vfio 6/8] vfio/pds: Add support for dirty page
 tracking
Thread-Index: AQHZyXH315oZeaJfAkWWY6/5iKI7jq/g/BYAgAEh2wCAAB5AAIAACU2AgACQSWA=
Date:   Thu, 10 Aug 2023 02:47:15 +0000
Message-ID: <BN9PR11MB5276F32CC5791B3D91C62A468C13A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230807205755.29579-1-brett.creeley@amd.com>
 <20230807205755.29579-7-brett.creeley@amd.com>
 <20230808162718.2151e175.alex.williamson@redhat.com>
 <01a8ee12-7a95-7245-3a00-2745aa846fca@amd.com>
 <20230809113300.2c4b0888.alex.williamson@redhat.com>
 <ZNPVmaolrI0XJG7Q@nvidia.com>
In-Reply-To: <ZNPVmaolrI0XJG7Q@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|PH7PR11MB7594:EE_
x-ms-office365-filtering-correlation-id: 4547c3cd-07d4-4c28-df9f-08db994c1b1b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: S0DVigtAV+bWwwP/N6B6p3aFkGPQgZFOjG21g48drtVMCgw7Sdkm/03tPwbQLUArUUio0zZhOxGnfsAmJXHFCz/QIwxWrAWanitNwkAlvgQ4XGfV/HD9fRUc0rcycBS13Vf3G/CG/x0LWCzoDCZ6/3mP9m+/eD7ojHUl/LsFrs2DY3UIawCYjE/oUZ8lq8dTMxkzaWVeM2O7pT0zBDifE2iBgRwOvh8vZF5ysqvEuGLsfEpR290tlmyCR+kSLFeu2970d+3bcVpiXaaaQD20rs/NoivJ+ra8BWlpt1nkcG38c+FiR40ZcT9H0rzSXntEu4PN5OOgkUN0nhGiWO9sJnLeIaIXNRFx6OmdvH2FpVRv1T43LigFsZE0eOcinFPm9hJt49K1eg4YXN72CEk8OPEIsECkefkfzsqLzgaKo5dWGQ9d5fQ+KCLCDYro3NiG4C8TIJs+BGGXEwED5LmJz/xGdI4pzvs5StRAOl2OLI9KsrpB89KSgVS9u5+7AE5PPU3VKzHyR5plLJM9q+qRGezBNhjbME5skEyTkQ+5DxRKYZfCIX9/pNef93By42UhRV3nRCPVd2wEDxf1KrALtJQCUYh+RWYyryJLo7Tu952HbAV/9FB6nZMLHo8hFubizLpeOKd5DnqhCeEWlnSWPQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(346002)(396003)(366004)(376002)(39860400002)(451199021)(1800799006)(186006)(71200400001)(26005)(6506007)(8936002)(8676002)(82960400001)(316002)(55016003)(86362001)(122000001)(478600001)(41300700001)(38070700005)(5660300002)(52536014)(7696005)(66556008)(7416002)(66476007)(66446008)(64756008)(4744005)(76116006)(66946007)(9686003)(33656002)(4326008)(2906002)(54906003)(110136005)(38100700002)(14143004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?i3tLETUyt/wZK6TEwIlyEPT1pxGxGSiqIQjY8FbCNbu4VbkLEh3LJBSf1r7i?=
 =?us-ascii?Q?dltuj3y1OAIggpwq/SNA9kCLSxn2zgJe3hBDTfqHGcnj5XmQ0w6gurgvtboH?=
 =?us-ascii?Q?qXWS3GIV2mIZVkrrg77aKAHjreDG+SZh0p6gEvLAyWweISyJHeVhRjkzTd6o?=
 =?us-ascii?Q?szOYKbtK0jA1HwY8wBzBf+tacMGjcez5eQT6qcQ6jD6OR6xCW36Wx14YkHgs?=
 =?us-ascii?Q?eU7qf+Bli+iDpsrD09KLTTgcOPzYqXlHStzYDSt7/z58JK3izM6AdFAXsUCL?=
 =?us-ascii?Q?h9X5Xc+xWcQW3JAw0TER9N/3wJgP42GtyVKmojL/ISzs60rqKYvUm6s60z+Q?=
 =?us-ascii?Q?w9kKFoOyoB/pgUvJCQ0pCR7f1hqyiIIPfOtI+DQ38Xbe/2tXzg4hShBvjWpX?=
 =?us-ascii?Q?jCM8EqjtIstlj6FIK3voTiSQ3K5g7UBC8Jwha1f8HCX0YErVmhPr29z+vwxv?=
 =?us-ascii?Q?NK5vV1Tia6FCK2l16UDkLUg6yN+oSk25yiLqOt6omYSM5RJt6m59MffZD58F?=
 =?us-ascii?Q?9R9PVj7K496LoPumEDCWsWsxRYY886mbvABc1UikX+Wm2MtvEuWJEESxxQvY?=
 =?us-ascii?Q?XllDYOAAKmbD7BBrU+0xk+2Ji5e/rb4lcfm060/YImS4EiyadQFcFX8e8Y4H?=
 =?us-ascii?Q?LfEVQFsQW6LYFw/8A3G910l9YOTmMw11ks6G4kXj9GiMsnYc6f7EaAP2jR/E?=
 =?us-ascii?Q?jQB39WsLHEzUGdwTUCGxjv8Vf6ABdnw1A9qG5OWUh+3U1ntme7h2y2N06S5a?=
 =?us-ascii?Q?1F1q9iVPYM0VovOji1IkM8eXcvKDFVLyDZojxdjkmchnqZCT9OZw1A81dijd?=
 =?us-ascii?Q?37I8cZxMN9fiFh7WIhO9sLfvx29YgZBWS+3H+2er+4/RqObE41F/TDgA6Xmp?=
 =?us-ascii?Q?NVtk4Ra8oIUmw7AIUc5UPWN0JOyFr/m2QEAqYD9ptmMZfLcZVqd/qp/II+vI?=
 =?us-ascii?Q?ekabyNa6wJHHGWuoXWLIspVscpy+SZcRqIrJHl2RtZxziFhuefpHu/rniAnQ?=
 =?us-ascii?Q?TbORe4iuPreMj2F5qTa1pKysKcbHlTavKrjfZGIvqLxNwnrVwe8pD6SqzpVr?=
 =?us-ascii?Q?7gx3yjtYb4AMpTDGQqDKtJDcWER7eHGqWbsm00T7H+kAMZhbPSKzfjz0rUwd?=
 =?us-ascii?Q?Hrp1H0DBKOyTa1WOf1Quk9Z4ROPhrCzjfFYC+Y62v2HyuO39F4hx4lVHYWtD?=
 =?us-ascii?Q?AH81Xq8BS/CacoE2Nwde+DZ4xAErLlCqyt9ZBy1awwt24OswxwSlmr3WJ88J?=
 =?us-ascii?Q?KuCFV5mOEvQBMwHEPW7Jd+J3TaRBsRbtvDp6Vh6zikTkSi2AucbYgsQZr8AI?=
 =?us-ascii?Q?EHbGxJ3PvBgYL4ucmxKaMo3FOv/Wy6XyAeCxuA+6Qd+hVhMr06J52ekaWeAn?=
 =?us-ascii?Q?feZe7neVC1fn6i6xN/DwaQ6ZFy3JqxrFN1pkQDt8mX6cZFHlobUXMsYopL4l?=
 =?us-ascii?Q?Qw2xDKFxuWLIeNLRpiBYKeckgkTRIfSPam3NAosmhfGYWMf/PEyxG87CnoX/?=
 =?us-ascii?Q?Ik5AHd4Fa0pQGf5EaEp82XUjYvHMRroGkLNY200fiMrxriKnMW/ocSEttnmD?=
 =?us-ascii?Q?7Xu5A8y9szGUCs49vcO+unIVHOhW4ia4MpBGFuq/?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4547c3cd-07d4-4c28-df9f-08db994c1b1b
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Aug 2023 02:47:15.3855
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MnIJlCfH3R3z5tMTye85f9DI4yGIvg1wjHGqSBLxIDEQ0DBo7TAQm/W5megoo4I71INxgxT9GvU5icXsomY1Tw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7594
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
> Sent: Thursday, August 10, 2023 2:06 AM
>=20
> On Wed, Aug 09, 2023 at 11:33:00AM -0600, Alex Williamson wrote:
>=20
> > Shameer, Kevin, Jason, Yishai, I'm hoping one or more of you can
> > approve this series as well.  Thanks,
>=20
> I've looked at it a few times now, I think it is OK, aside from the
> nvme issue.
>=20

My only concern is the duplication of backing storage management
of the migration file which I didn't take time to review.

If all others are fine to leave it as is then I will not insist.
