Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0F6F67FD76
	for <lists+kvm@lfdr.de>; Sun, 29 Jan 2023 08:54:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231502AbjA2HyZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 29 Jan 2023 02:54:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjA2HyX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 29 Jan 2023 02:54:23 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69D2613D45;
        Sat, 28 Jan 2023 23:54:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674978862; x=1706514862;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=4/fkcOS1HUG83yA4dSpdbe/xoypshhSLLEAGJKEuXqc=;
  b=Zb6GwGIqAL+SbZe7G7y+Lu8DIMJyLoYsIyhmZNtk3gA3duAnc9SgMLo7
   697X3Ykbi43CW/al09oX4QY6NL0AMbISK4XPL4zfH/ONybwEujnMWGhC0
   ECUYbAM6NruFt4YIjNTjZGibjXI7kqEkGSMLBbIQvgfgZhNVoyL7Tw9y7
   ftZBjzDZXGJpm0GKyXeiGMC2l5ezpm1bkQxLoqLaA14mndTS1vsQGrfIy
   uIhyln2aBBrO3dYn3rBPDVp6pZOyLJBJEzlqhrzicjWVA+xQyIigkabiX
   CFCyIWhRKdVq5klWpQ+Sewt6pWuHjtyG8UvaSKVeAhm6XqdMTQwxMcyYe
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10604"; a="315329931"
X-IronPort-AV: E=Sophos;i="5.97,254,1669104000"; 
   d="scan'208";a="315329931"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2023 23:54:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10604"; a="665724081"
X-IronPort-AV: E=Sophos;i="5.97,254,1669104000"; 
   d="scan'208";a="665724081"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga007.fm.intel.com with ESMTP; 28 Jan 2023 23:54:20 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Sat, 28 Jan 2023 23:54:20 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Sat, 28 Jan 2023 23:54:19 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Sat, 28 Jan 2023 23:54:19 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.170)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Sat, 28 Jan 2023 23:54:19 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kirtZRtqdJKmE/bVOIiiNLj2C+WiTldvBBoKeUPahcn9qpSsa33OSguCfDxz/0PHCyLtxcHDJTIOYKbFaT8EV2Gun3w66m0ac6Z853639wZPxlMDDzHZbrYI/B4LJLUt1AkhCRQCFWT7Q0XKk6B27NDzX6o/FpApH59lCX5aix3GU2jRutXyXQBFx+8TItbRPUiqvSPt5gWPtXYOhVajBBTp7eHyUIlTeZ+Lf5qza4lWJgK+fxswqtDrlGXb0npDIA3THvgX5Jhaa7L5sfSTCtLuTrghO8awvJHo+aVSiwAlEv4xIxhRoQmx2SYVEjjqPz64/JaCe7pGKeklb/16kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=twji0Ccuz+Uj1s8PHghBs8z/OzuBT2G/Msd+5MIBHgo=;
 b=l4rBGEdIkeCnSrxrzuemrKwIGZDLk4mH2sHEzzMb1IQ4trxAEMLx3HVt55n9YJ9HBnikU46pTiV7dEybGxqXyaJsQsc5d2FHvZklk4u+ADEwUF8hiPr5oTDcjOC+9RG7GJkNbyHnK6ZOa24dKyuUHybW5JI+ljMitNYun+Z3hyX8dPZNkaAoMDlDGZbMZpOTXJTCPkPMGHIULgkMQkSVKT0ZjTuiihBJF74wPAdrR2+YKi72Jilx+sgD7jSyebi6sSggBax0bxs6pJ4BrXcmdIRG7vVWcxkahWZiEmG9Impf6UYBMJpA+4LJasp2c/U+wveFUw5OCui92EhhwLknTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5271.namprd11.prod.outlook.com (2603:10b6:208:31a::21)
 by CH0PR11MB5377.namprd11.prod.outlook.com (2603:10b6:610:b8::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.33; Sun, 29 Jan
 2023 07:54:18 +0000
Received: from BL1PR11MB5271.namprd11.prod.outlook.com
 ([fe80::2caf:11b5:858d:2978]) by BL1PR11MB5271.namprd11.prod.outlook.com
 ([fe80::2caf:11b5:858d:2978%9]) with mapi id 15.20.6043.033; Sun, 29 Jan 2023
 07:54:18 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Nicolin Chen <nicolinc@nvidia.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "will@kernel.org" <will@kernel.org>,
        "agross@kernel.org" <agross@kernel.org>,
        "andersson@kernel.org" <andersson@kernel.org>,
        "konrad.dybcio@linaro.org" <konrad.dybcio@linaro.org>,
        "yong.wu@mediatek.com" <yong.wu@mediatek.com>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>
CC:     "vdumpa@nvidia.com" <vdumpa@nvidia.com>,
        "jonathanh@nvidia.com" <jonathanh@nvidia.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH 1/4] iommu: Add a broken_unmanaged_domain flag in
 iommu_ops
Thread-Topic: [PATCH 1/4] iommu: Add a broken_unmanaged_domain flag in
 iommu_ops
Thread-Index: AQHZMoqzsVwORV4fDkqb25GPYvi+2K61B+1Q
Date:   Sun, 29 Jan 2023 07:54:17 +0000
Message-ID: <BL1PR11MB5271DFD1D9D60E0021D8BCE18CD29@BL1PR11MB5271.namprd11.prod.outlook.com>
References: <cover.1674849118.git.nicolinc@nvidia.com>
 <0875479d24a53670e17db8a11945664a6bb4a25b.1674849118.git.nicolinc@nvidia.com>
In-Reply-To: <0875479d24a53670e17db8a11945664a6bb4a25b.1674849118.git.nicolinc@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5271:EE_|CH0PR11MB5377:EE_
x-ms-office365-filtering-correlation-id: 8ed51b07-17a7-4d91-09b0-08db01ce061f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xCe2ceuO/4qfdPDUUecTeFNgmShAkiNqIUdrTTiEcQUtpSRRHgJ9bfCOHj119tck3S6e0XcR5qOdsnNF920PWQP6uCzmzmvEPUL2Z69xar8AmOOyRll+DMOV4iKdTh8zgmcpLfZ1GTwjnPrtrQNUe8rIWfI7Bs4abo4LEuSzMuE09HD6XfQwApBBTlgkjphuuxr7W3gu/3Ge2muOuySvNKFdXoujvkTn3Srxzwwtf/hG/cdVEsPX6LqUgWNRqVpxAfwmX6HBlH8fGkTT6gJ1JyUXKCM8PFdXONcX9jZxubaroB1RSkuAO/2nM3KIvBGyUi+KJVp9Uct0U3yViQ0P18wGzv66sp6K0iVZjYfFagqyPyKn+K9F1l5LXtrPAZFRdzvJADNzy6l4lRM/jWpEuBi1iB0gomLsbhCf2jaU6SJIehcQP98ng3Mxh5twEFuk8gT0N+fXBC8LwW/7EgSr5roTFLRJroE0yiq1OtUk3GAIhVM+3s5RS6A5eJ/EQXXTwnf2awmFOVD9ypFtFQVbSsBSkm5ArPFNieYmT7U6pp7tWhhnm02hoKoK3cnbs4TS6yyBMLUx2v2yjsQNYkr20dHg+jNS8E7NtwItdAQjOUbRhuT8/wuVC4BKjVcehrWQA6f3Z7ZTJ6b4Mq4ith9slOjwqL2mRSe7u1ndQhMkqRk1bu4gDsW+5//NxDbODE9EqOg6bDu+k+QdKRG/P5KvQ5r6R/CDNqNKMm/7xYPFZ7M=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5271.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(346002)(376002)(366004)(396003)(136003)(451199018)(2906002)(5660300002)(7416002)(55016003)(82960400001)(186003)(122000001)(38100700002)(26005)(9686003)(52536014)(8676002)(86362001)(4326008)(66946007)(76116006)(110136005)(54906003)(316002)(66476007)(66556008)(66446008)(8936002)(41300700001)(33656002)(64756008)(921005)(6506007)(38070700005)(71200400001)(7696005)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?K6FLrZ8GWrsbhFI9wmxkoLgOIh5eKhvKxF3ZYDaOIPRZ9co4M8y5xDEwWW1N?=
 =?us-ascii?Q?arEoGRCQIGV5v9y6K9WTMRj9PVnKc4NH/zNy4rn4QXTf1iaLtt+jX3C3ekx2?=
 =?us-ascii?Q?J7+ic4hWWk9DOMstfUyGIhUEfJ+kelgs/ts9iMmDLubrsHnPflV+HDRt4jt9?=
 =?us-ascii?Q?rnqCR3KrB5rzz4sJ7gPzmLQCgtrB+PZ+xszfB4ZCJDwDJWY9R4t+45K4LT+v?=
 =?us-ascii?Q?nTpy69idI4rgca90qhNZRX6AW1x/hGfJXiGxqJd/0hNIypR9d+ThyR9ExBZJ?=
 =?us-ascii?Q?UWXloJdDQK61EIcY4/0FvPMGMiXetw3bT+zyTyXIIWtqpNSK4U7UJCgnn9oR?=
 =?us-ascii?Q?mu6nxTTxBzhzREEu3jQ8Nmhn7ZExCU+OT8n91OrfDBQOmLNAe0gt9sskinoi?=
 =?us-ascii?Q?uPr7pWsmDOMPWpB9ppfygjQUAFl2bGBdzgoXDfb3UYUJLdw17gz6W3p+Tt9B?=
 =?us-ascii?Q?BeoMLoFiM/n+U/4Hv76juJVRZxTTSAkBfia9Vm+Ze0Kojc96WCSRU4qmfXsK?=
 =?us-ascii?Q?cQjFRDj0gBHAfk9sF1yhYTOLXdi7HUw2e3+FKC8LvPxDnGFAhpzjpuPi3JaU?=
 =?us-ascii?Q?JV0Z0Z8Euq0Ep/0u0wV7dszkKyKcKh/m3xXjl5Ymp4l5ZcLdRRhWz/s/Kbhk?=
 =?us-ascii?Q?uIeLgA0QFbG3UeMV6LME4NCjNbzLQPIfybi+44GxdRMebgZbw2QkOEA9V93E?=
 =?us-ascii?Q?AJa0n/llausGCtCCHKx9Bx6hkJD6YoHsspL3dvwgKMJtam95hpH+4gWdO8l0?=
 =?us-ascii?Q?9GbPO03/LXCwtNFCO1wOd4KgWac+lHmsuLwqSY2ap33vnp4J/cK9mB7H3K+3?=
 =?us-ascii?Q?x96jQHn3i2IffuKZDNW1Aoumk3h3LJ5oM4Uwm9S81+2WfHhLDxJ8OQHoAuw6?=
 =?us-ascii?Q?W3C+ImICd7UO9Ai7p56oVSUrI1iKAQvT92jDrEk3WcXpBdvwPfgprL/ZhtmR?=
 =?us-ascii?Q?kvDOjmF6Eco6mglWDyGUCOmStl0Kgi2OVtyx8u2NfvNwpGW/eKF7zbSwAcHF?=
 =?us-ascii?Q?UJFEGXd7SFN8lGF6s1H/fuBp3mLHREm52ydaX45uOgoBuJA3CjEG8Xw7Upom?=
 =?us-ascii?Q?ar9UEitsMzSLoWyZWbQB3XQE0xjb+0+GsMpMZZN6RIgJJU2Ss3HVndrQNNTh?=
 =?us-ascii?Q?orvUIyLt3E4KoR2huT6J/EZ/pa79Ib61rkXVeag1v4uj8gkGbQJx81dtoAj4?=
 =?us-ascii?Q?3szwatq97AbQ7FLNi4xR9oV/VZXVdlqknzb/RskME8zgPeFXrNrO8Xvz+fIP?=
 =?us-ascii?Q?cshhMZbk3KkhDNHdf4O61WL/QPTE/7rVSFvxN5tRYqCsdglNm1DXrTzQ8Q60?=
 =?us-ascii?Q?zZ6q4AD89FJ/bZ3bKrPQhGKEinC5Gq2fb08ykCsMM3XSejRI4Hjaw7B2DTEw?=
 =?us-ascii?Q?p5Quh+fYX+jXWgdqAitxmnwV60f2hDBQIH7yWi1iCOrIBDNaXxavz2SQ+wFI?=
 =?us-ascii?Q?6NcVQQsuuMZoXXys0K4QppBvTtBz3lluuLue9Enob3unwQfm/xXQcpeuI+VF?=
 =?us-ascii?Q?OkGLIIrenKA9c0bNrCZ9oYHbjpA31l2eJ4tlXGzJvdajuqDQqVmrhRFSLJsM?=
 =?us-ascii?Q?qTOsXjU8n67yYMM7DT62vtPuZg/SGwfN94VdOxpG?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5271.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ed51b07-17a7-4d91-09b0-08db01ce061f
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jan 2023 07:54:18.0020
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FFwc4QDwyNEtRuydPwp9PJIYmIpOJ0IOHoWldRrRHc6WzoZMO0I/RcgaeqC1pW3SZFgu8CojhPufY4ytBmdP9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5377
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

> From: Nicolin Chen <nicolinc@nvidia.com>
> Sent: Saturday, January 28, 2023 4:04 AM
>=20
> Both IOMMU_DOMAIN_UNMANAGED and IOMMU_DOMAIN_DMA require
> the support
> of __IOMMU_DOMAIN_PAGING capability, i.e. iommu_map/unmap.
> However,
> some older iommu drivers do not fully support that, and these drivers
> also do not advertise support for dma-iommu.c via IOMMU_DOMAIN_DMA,
> or use arm_iommu_create_mapping(), so largely their implementations
> of IOMMU_DOMAIN_UNMANAGED are untested. This means that a user like
> vfio/iommufd does not likely work with them.
>=20
> Several of them have obvious problems:
>   * fsl_pamu_domain.c
>     Without map/unmap ops in the default_domain_ops, it isn't an
>     unmanaged domain at all.
>   * mtk_iommu_v1.c
>     With a fixed 4M "pagetable", it can only map exactly 4G of
>     memory, but doesn't set the aperture.
>   * tegra-gart.c
>     Its notion of attach/detach and groups has to be a complete lie to
>     get around all the other API expectations.
>=20
> Some others might work but have never been tested with vfio/iommufd:
>   * msm_iommu.c
>   * omap-iommu.c
>   * tegra-smmu.c
>=20

Do we have a link where all drivers tested with vfio/iommufd have been
listed?

In a quick glance at least exynos-iommu.c and apple-dart.c both support
UNMANAGED with map/unmap ops. They are not mentioned in above
list but I doubt they are tested for vfio/iommufd.
