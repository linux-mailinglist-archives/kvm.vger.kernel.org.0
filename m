Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BF4C6FD8F3
	for <lists+kvm@lfdr.de>; Wed, 10 May 2023 10:12:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236549AbjEJIME (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 May 2023 04:12:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236560AbjEJIL6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 May 2023 04:11:58 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BA0010EC;
        Wed, 10 May 2023 01:11:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683706313; x=1715242313;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ArkanvBJl/JXyDSdxS3oSY1IARkoCtQzE9a3OTK1/R8=;
  b=m8X5fC7EiEr24vi+DhLYR+c33LcaL/pwaPCYe5Mq1C/D5RDMapHhDh95
   CWKL/bJ5+YWv0vcTcdE6ZsEqhVNzlsJHSobwz5uxcRoGrTOMH1sguG9AY
   xwNXYZYnYQkNuZc6XlxrB7zIIv2crWyahfxZ+NP/9BKxxiOA5tXwofPGx
   d2xaK/3J+L5jpSnHf4KEvh9+ji6z39+vSH7SI/mmT55rHkzDvCAdlsCZ9
   yLCjyzKYmbYx5BZewEJpJAtR+xKydmDFQ9w8uD7mAyd65mxd/yTif9MqY
   kM4rd7XN748YqrRF9z+HKUttGgncTMpCxlg44gzfY+gID2eJIn7lS3DSw
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10705"; a="352344040"
X-IronPort-AV: E=Sophos;i="5.99,264,1677571200"; 
   d="scan'208";a="352344040"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2023 01:11:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10705"; a="768836839"
X-IronPort-AV: E=Sophos;i="5.99,264,1677571200"; 
   d="scan'208";a="768836839"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga004.fm.intel.com with ESMTP; 10 May 2023 01:11:31 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 10 May 2023 01:11:31 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 10 May 2023 01:11:31 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 10 May 2023 01:11:31 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.177)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 10 May 2023 01:11:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QXNOdrv/30xaU2/To+PhvVNnnJN6hzfItGodO37eVS6swPBrkPZUqibEBJJ7Pkjhawyw3azvxKGdV6aIC1Ck8MrD6Y+56Ag5MHe8u9VO6hH3sC9Mrk/TfdQ1+TLkQp4ZO/N3OQYLTeJzlO6CHfmNERDKBHzAsxAMbgx+vk+ev/448URfJkVflu6UBByWWizNr/cl9Kho3EimL6K9AjK8sXRDEn5SwQODQ4dBtKifRvX4uI3VyylfFojYZSQP4eSZ+cMRu4/VG9mDfEZruPWSAScqXaogZoza63JWSqRazNZPChE6ZcX5n3VBIJFkL1M5rhCgcK6gw7ryaht40KgCBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ArkanvBJl/JXyDSdxS3oSY1IARkoCtQzE9a3OTK1/R8=;
 b=oRjWO231hXlDFsu453EXFXQnTerZ3ME659FeNCw5Uvi+dmBHzkdsXxowzsxuouBojZ1lYkzb+T75KkWxZ46CPSrH2QXDnT3Vk+bSvkHTC8CjsXmK48nQHbPYyQXhAhLgU6+ThYGIAb8ZsQi8ASJuc5bILbgVgmTjTRia4+5UvLVogpz+Ilr2IIEypCMxlS5t3AkTaP2wbTTiIVpTUrX5tzsHlbwVVskCAOKu890KmSMuYiLuHTDIXETYouJde0qgwWiCA7nBvDgOmhJyn+5ukNHefjVwaVwM9jvXqtvNUOZMDORyKam1kuayx8thHD81+SOFXiC8fNwu6QpxKY2cmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DM4PR11MB7184.namprd11.prod.outlook.com (2603:10b6:8:110::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.33; Wed, 10 May
 2023 08:11:28 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::73e9:b405:2cae:9174]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::73e9:b405:2cae:9174%8]) with mapi id 15.20.6363.033; Wed, 10 May 2023
 08:11:28 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Nicolin Chen <nicolinc@nvidia.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "will@kernel.org" <will@kernel.org>
CC:     "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>
Subject: RE: [PATCH v2 00/17] Add Nested Translation Support for SMMUv3
Thread-Topic: [PATCH v2 00/17] Add Nested Translation Support for SMMUv3
Thread-Index: AQHZgvBR+iZCoOJeVE+podSZNjH/ma9TJ1zQ
Date:   Wed, 10 May 2023 08:11:28 +0000
Message-ID: <BN9PR11MB5276A6619129034311C917FA8C779@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <cover.1683688960.git.nicolinc@nvidia.com>
In-Reply-To: <cover.1683688960.git.nicolinc@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|DM4PR11MB7184:EE_
x-ms-office365-filtering-correlation-id: 1c81e9ea-e1d3-44e1-95f4-08db512e27d4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jzw2/kbSTy/kmRzbg2reDeizF/BWNE/nIPBcHTHLRaU5n2Gh3w848oNZu9fSFCH94GS271daCtrBW6+Y/ftFJgmAnLi6n59jG+8kfxpQEbU86bmqPRKBdwXciUpMZeZP5hxKuT1BDXru6FOf0DVsi/JxFEW3uQzjDQ+K0mFU2SkkbLVs1BfbE5VmjyCJvRVeUPyhLkEEuOQ1Z1HdKOT4EgEp97TVikj0Gxp1G0c3W/KEfL3NuHI4OdmaloAEuBfUT0UNjQMIQo4EIag0V136+ZiVSdUFt3IJMW9TbYcwoCLZP0F9SL1l18LLWHKUQj1BoXrp4TdKM3L+0k6aCWI4dX8/3g9f9IDLfiOk7B2NavDy42Z1B2xwGzN+2mczztJO+xORjZlWLlQWq8dBu01pNS5wclUH4rANEl6Z5wmM/llYNML4K5me9+oTGzY/CWq5IS9s73wQDt18MxaLpErSz7PRDOCmwgo1Fn2edR6wIxbhLGaoSZ5Y/O+puRD32Ks9JajnUut805976CBeQNQTSFgBqkEwTCI56cwqpgrHS5++HkG93OOn2UyUrpnouLLu1co+8SVTzDHP6cc4o8ol5UX+Sjduf+t1gvWea1mRM8A=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(39860400002)(376002)(396003)(136003)(346002)(451199021)(66476007)(76116006)(64756008)(66556008)(186003)(66446008)(4326008)(66946007)(2906002)(33656002)(38070700005)(966005)(316002)(86362001)(7696005)(41300700001)(71200400001)(478600001)(54906003)(110136005)(5660300002)(7416002)(6506007)(26005)(52536014)(55016003)(38100700002)(8676002)(8936002)(122000001)(82960400001)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?r9eZ4yaUD4plm8QcOzRPqip+YQW9mSstiBNEMvJbmF6/gMqVr1E7ZQjxAZbe?=
 =?us-ascii?Q?NurJjkW039x0Ip+eMPdJVlpYRiRsrhtAD2ZVjz8XxlDMennMfrRoicWTU2D2?=
 =?us-ascii?Q?hZHj2aEiGyhn9JGzZg+04Eq91xQkp7VjRup2jo2JnB5hrkeqDFS2+/iMKqiq?=
 =?us-ascii?Q?OtcuIB+jjkcV88u4TaPXRBd0INI8da2T9GE6SpxQPiQIqPZhzbL2lkMbLzTH?=
 =?us-ascii?Q?zVa5la570CBUbb0p3vcRoAsyjiT9ltNCyIjjUzFFt9XU7onefkeiyylx8uf2?=
 =?us-ascii?Q?UcZaTyQICse5Lj0yE2FtA8TwMJ3gpk+jeZQaUYeX9pfi7YLckuohOTGR5724?=
 =?us-ascii?Q?0ISWuCh6AQULbJENmJQPO0L4k2udD0DezHrQkyFHCPjCSTUWRgIMHurn69gv?=
 =?us-ascii?Q?mwfEny5hy/10NA3cyf5UmqGqOn9nE14QAUEnDs1mG4D/bADx/ENtcxay51pW?=
 =?us-ascii?Q?PVabIsX+Lbt3U4bfK+A9yJunyHy/mUjz560FhsaeOMNnxvM0UMxL+2/IYKVi?=
 =?us-ascii?Q?37BSyavldAtCyKbtlzxZCrB3QNkn8DJgtjdf9bNfZfD/8veQ3Z6RgZcujdob?=
 =?us-ascii?Q?dEDwD2SiNkoouhXHMKNOfIY7X9FLP25Cb0FISEbxRRK2B9hqrqVMEgndK7qR?=
 =?us-ascii?Q?2H0tszgoKaa8SHLBkwqtWHGhh0C3v3+fyqFkHLkL/6hiK/kOBnLgSUsjKPA+?=
 =?us-ascii?Q?AlF33SMs0TM6JsEW5OwqIx7ofm/EombE1Ek5ppdubh+Ix1oBb7pi2XchfV6M?=
 =?us-ascii?Q?8Z0ISnJT3CFHNavnXcbilbMljJCL6KPIM5z/Ouq5yV1wh+d/oU9ZY+zuhDE+?=
 =?us-ascii?Q?Q+xq2DsO/WVxrJUyNFdZbdfI2opEs+RuPfS/gWi2F0nTmUbo5iPC9sroJz4n?=
 =?us-ascii?Q?+9zvVhBh/22zFWZGm+KlEFPh5vxLF6141ENUw8oMt7Zbz1cexjlLXE+gM+7Y?=
 =?us-ascii?Q?Tdjp/NCuNZT/2b3ViE3x5ExfUrdC8DCrUNo2cDV6j6AL5munDToc3UyrQ/sK?=
 =?us-ascii?Q?OGyGLqqP1QFtyaCmFi9fFEHfd1mmuDudTo2fg9UxCtWax3YVQ8ouC1mkxKIV?=
 =?us-ascii?Q?NLHsYAH2t/VxzkLWQF8EdXJmKHtYtQ8+PyriSZm63HdQ1Yo0yTBIWUAtfdCq?=
 =?us-ascii?Q?+WqHexKRMnw7R0vKwBvpRMCf7tUair7PKZBm71RiJTCRF47TsE1xo3Mc13KP?=
 =?us-ascii?Q?ChAgaxSBFV3h//tSFaetSjWnKFLwc74ES7I9+FovCqcT1+zAf8ZknQqQfvq+?=
 =?us-ascii?Q?Rmj9h22oW7g7RKZLaNtgrK8iZTSRxUkYN7v9VB3zwJ+M5dsxk9py8bTmMeSj?=
 =?us-ascii?Q?8z+adE9C484C5Ri0XLCBUhLmjHzsXoJHBziW93Ixy6cAQ+0JlIZTEgbI+dEy?=
 =?us-ascii?Q?+KNKH5dDvIO+pHhUK4suL+24WWB+Emkh+EuHOlOUPzkVpfcRd1ktfq38yXqp?=
 =?us-ascii?Q?Q/Y9EO2mdMxUN2VZCSnUTIVZhlqTuOqsxTt9EONVgLHf1TkQPSbJHvtxN/3p?=
 =?us-ascii?Q?VYxHfB7+EnF+QEGTK9ZFUkR/sjioxPQfpnuQiU5QL/+Znez5LvPsD6PKWd96?=
 =?us-ascii?Q?zPS09/eKt54aqovBhm4H03RS/wtdOR38t/JUjUG5?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c81e9ea-e1d3-44e1-95f4-08db512e27d4
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 May 2023 08:11:28.1431
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ro/k1OqTy+jHl13pedWq8bNqucdeAcN7msAoGpg9g4OSiHLz1DUSNsQ+qgI/OhjtjQFUdGT7ubqc5RRPqnB2Iw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB7184
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Nicolin Chen <nicolinc@nvidia.com>
> Sent: Wednesday, May 10, 2023 11:33 AM
>=20
> One unique requirement for SMMUv3 nested translation support is the MSI
> doorbell address translation, which is a 2-stage translation too. And,
> to working with the ITS driver, an msi_cookie needs to be setup on the
> kernel-managed domain, the stage-2 domain of the nesting setup. And the
> same msi_cookie will be fetched, via
> iommu_dma_get_msi_mapping_domain(),
> in the iommu core to allocate and creates IOVA mappings for MSI doorbell
> page(s). However, with the nesting design, the device is attached to a
> user-managed domain, the stage-1 domain. So both the setup and fetching
> of the msi_cookie would not work at the level of stage-2 domain. Thus,
> on both sides, the msi_cookie setup and fetching require a redirection
> of the domain pointer. It's easy to do so in iommufd core, but needs a
> new op in the iommu core and driver.
>=20

Looks the new preferred way is to map the physical ITS page to an IPA
provided by Qemu then let the guest allocate the cookie in S1 which
is then passed back by Qemu to the host kernel? [1]

[1] https://lore.kernel.org/linux-iommu/5ff0d72b-a7b8-c8a9-60e5-396e7a1ef36=
3@arm.com/
