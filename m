Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A92A34F908F
	for <lists+kvm@lfdr.de>; Fri,  8 Apr 2022 10:17:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231411AbiDHITB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Apr 2022 04:19:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231458AbiDHIS6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Apr 2022 04:18:58 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA15165808
        for <kvm@vger.kernel.org>; Fri,  8 Apr 2022 01:16:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649405815; x=1680941815;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=pFVw9eSdKQ6y/DPSMRhlVlTS6eagHReynvHg+HGI9x0=;
  b=HEmVnqB7/ke9B90kl0py6XYoe1irAKUDPpTDmEKoaqa7ap2x0gfY3anh
   NaiimhXkqcsDDJaLX6JQM16sQYD0e/JEVYTvAZvK/gq/dzo/s/IWzmaSt
   E/xV/fGsOKhpRQ2ZBnpMmJ6vV4oxar9bZwqHxYPPpFSBBFoATEAHnEIsK
   1pGTCVWE5U1E1esR54divZQ8taSjXc7Uy/bUiZ+GNyHkoz/+YUJMeX3Jm
   nvkpIx5ANGWutk+saY+hTAayl7zDP56b0kmaI+fH/zMjBmmU+I7MCTX0A
   AqW6MyA+Xfu0BDNqUzM4sjowKBgMdqwFqkt26vrYCLP2kwDS5arvlFZik
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10310"; a="261535708"
X-IronPort-AV: E=Sophos;i="5.90,244,1643702400"; 
   d="scan'208";a="261535708"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2022 01:16:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,244,1643702400"; 
   d="scan'208";a="621557040"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga004.fm.intel.com with ESMTP; 08 Apr 2022 01:16:55 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Fri, 8 Apr 2022 01:16:54 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Fri, 8 Apr 2022 01:16:54 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Fri, 8 Apr 2022 01:16:54 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.46) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Fri, 8 Apr 2022 01:16:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rlbny84CLP6eWSomPswqhaykjLB7XKN7r6JxkAEvopmvS9VZCCggTYQz+AOPfE8e5J87e88ZGNWpiinUF42wvwJaAlaqpIdtzlTTncrae75T79fDDTQi83QyoCaxMy5aC9cbLt7wItGwIbYe1BICtFFQPOcWJbGkXdpuPuPkRRIhD19VNPAizLPdkgF58QAyWfkiSySvVwERb47pCJV5QGReiHnNvhUROAamdk7JGryuFPdqiSkv1h8Kcb7meB+Ml3uYihCeAdZaGKckGQB6K2J2DYZA8YGBLd8ByUPehHt2+NeN8ZDfZvaBe+fnxo/Ei30ZexiFHimkNqPSacDGPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pFVw9eSdKQ6y/DPSMRhlVlTS6eagHReynvHg+HGI9x0=;
 b=Y/Gqf8cGFmeQP6+7S7wzy9TO25hQ3FGZstX7O3hath8cl68lqtNykhp4YWGa1cf9SBQ+FeMcbPehn8K5B//BphEULMG2N3fQhGhq8OxYb1yJ7G2j2IV8mA+eCGPExyi2+TQ4SXEMizGdhugLXPLiNXOf3fyXvwRVtj/SKaoPbiwbwtVUKyLggbGA04jnaCY+exHnNA0dAVLC2xv80EuU5fEXNPUTOz7NdSCHNwLAE59/HT0Skyf22ftdBPcpQEZes3mb6OV9gDMKC339kvh1oLBH7KrZEk29EatxCAaXp7SZ4GsxsGJ8leuzbVHnP8JF9lEueGOSl/xXKjAOV5NEVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BL1PR11MB6004.namprd11.prod.outlook.com (2603:10b6:208:390::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.22; Fri, 8 Apr
 2022 08:16:52 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::c4ea:a404:b70b:e54e]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::c4ea:a404:b70b:e54e%9]) with mapi id 15.20.5144.026; Fri, 8 Apr 2022
 08:16:52 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        "Cornelia Huck" <cohuck@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "Joerg Roedel" <joro@8bytes.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>
CC:     Christoph Hellwig <hch@lst.de>, Robin Murphy <robin.murphy@arm.com>
Subject: RE: [PATCH v2 2/4] vfio: Move the Intel no-snoop control off of
 IOMMU_CACHE
Thread-Topic: [PATCH v2 2/4] vfio: Move the Intel no-snoop control off of
 IOMMU_CACHE
Thread-Index: AQHYSpODjq97KCkZqE+HgacEjq1/gKzlqx6g
Date:   Fri, 8 Apr 2022 08:16:52 +0000
Message-ID: <BN9PR11MB5276796235136C1E6C50A5AF8CE99@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v2-f090ae795824+6ad-intel_no_snoop_jgg@nvidia.com>
 <2-v2-f090ae795824+6ad-intel_no_snoop_jgg@nvidia.com>
In-Reply-To: <2-v2-f090ae795824+6ad-intel_no_snoop_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.401.20
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1b953133-3460-4f51-823f-08da1938232c
x-ms-traffictypediagnostic: BL1PR11MB6004:EE_
x-microsoft-antispam-prvs: <BL1PR11MB6004F75960707A568265D6398CE99@BL1PR11MB6004.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WnM18rUpAGfMeBZ0GFJhhkSBQxa7ApSHvNgYNu5bWOoGXPiP5QcDLf2LXVrC57TJB4pHYYAy3Fk7m3WNc1A18ogMrfhjv7gbNw8Qj6ioYW2RZnVUhB+3aon1kqoOmpzDKfmMFstdT1okiCZqtGbrFdiuJEPOZIimOFN2108YncvHV77JPUmrdgMYkZUjQln7R/SJkq2Awdq1P+J/DS6FuZvfj9fdztFgdeWQqLDJ6UWPSr7NeL31FcrTjj5M+I8QOLtEGnOo+F10U4VObkvdz1cObzl9cmirR68VcW71IwRnoIIWjtJAPdw7VZnU3ukeY6RS/CKqa2HDre8IPrloiufCruMZ8RTXu4eEtShfCGM2FZxBKFvsUHNSx2mtV/qOFxlCeBEUKOJ1dzCFPZsA5u8d5VobtrDBVhpPgr6r5eHr3kAE3v2Qy8Vdx9PAiyUraVrRDTOtrqTug6CZ+NWnNAamacdYf9blp+vXVEk3NLtouAGUt+vHnB3oyur45PQwLHkyP4EgjTm232gO/fyx2OensJdgntcacYefx7f1m06sYxGyaRzN53031UoDiVY/gMjx4m9mJ07BbBY8WUGE+poZYyqxzqHOIrS3uqrxDgRqNOOSAsNlOrzyXjgQhoBegiWjdrkNUNrbd8z/ghuRaOBFKyhN4o3Msv2nggN87+bLTzE1WEyf8VE8hd/0zydYpx4KQ6Pzc+oz6GREeSTTJsIRG66vQgPXbxS5j5Gd3mg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66476007)(64756008)(66446008)(66556008)(66946007)(33656002)(86362001)(5660300002)(76116006)(122000001)(921005)(4326008)(8676002)(55016003)(82960400001)(508600001)(83380400001)(38100700002)(316002)(2906002)(71200400001)(110136005)(52536014)(54906003)(7696005)(9686003)(6506007)(38070700005)(26005)(186003)(8936002)(7416002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?rM8U1PbqF2SqNwJ73D5kx/WUvKSnNL7xGyfbjHoCtVWcq7Wuu3oCdlGfhFwD?=
 =?us-ascii?Q?LCygvB+3S1IhTiX68xNpXqpRtK4CEKDY45N2ZzNTDeZ3q0yPdNf/m5Ie8oO1?=
 =?us-ascii?Q?b9ItFhKN5Xno3n2RQDfpRD3xgQaPou6knDtfGkNq2y3t0sSTXR2Q8lgpIzY+?=
 =?us-ascii?Q?1Hz/2kkEDmddnp2CdoVwPqdwvr59NOd1lFmkL4kgfO8PARgOzmVfbC6BDUdN?=
 =?us-ascii?Q?uUreXdl7W3gKZ/6RzBg8W/bhu0mKK0VFGcAAsA0fVQWjjMb7OWhIt4WwL8M1?=
 =?us-ascii?Q?tC/Eeqxo2CfQxTbC9xG+NzQt0sJOevhQOONJJrouwQbGJENPgH0wrkU2i/x8?=
 =?us-ascii?Q?cg9w9j5A3DJP0WppXy/rhsCqNoeJKNGVhQqd/mBhyBDFrMfN6QXJ2Y8RMItA?=
 =?us-ascii?Q?CCdFbYjtLQNbTEghcGelm3E+CZsKdUo2CZcU2UnvL4M8sH2g7XmlHlEgQ0Zh?=
 =?us-ascii?Q?I+E7rviCzcPR1Qafo/0sYLq4GA5U4CMq5USmsm+YADFqDFme0LTr/C2lY6ZU?=
 =?us-ascii?Q?4uEekMHiO7SJrGwCbGxp9oSMIP0hfznvoXO4URyc6j/TMU4+n0U1r/KmM9oN?=
 =?us-ascii?Q?+Q0DC9OgjtBEUqRVMv+FcR64O/ddMF6lzEmD7OWXB1PvczHi2nRjwrW665rV?=
 =?us-ascii?Q?+FQllyu9To7lPbNg9QrK7AoQ994BNxe5eoiEraoqe7n9wFhRhzhFd5g7WmUp?=
 =?us-ascii?Q?d8V624e+ABo4CqLZIkl0Yse5QRFBoZ9nKX4sv+yeqopZykrXC1yJIQTfr9Zw?=
 =?us-ascii?Q?4urvcbAzhUcNVVdEpdDt+9gPQfqvSvo4uJL4MLfLTYT6Pm0c5bf+S2Q36DAs?=
 =?us-ascii?Q?TbqGv1kzqYXzcyFsucICDtMSXejv/8HJdmH9uWENG2EzCzz1A1T3Y6nvgZ7Q?=
 =?us-ascii?Q?QF19joPN57mfWVc6pAkF4zpnc2sG1Tkhr4VtdtbCKaQT/bEWbVWBJbimdTZ/?=
 =?us-ascii?Q?UoqiakxOrPVZnHvbX5qbl4eYyg7UrFT54kUedLrfMk45TnXXXnu+Y6tQ4yjo?=
 =?us-ascii?Q?XBd9ZQehfXj06ue6NMxKiZ7Io7aeug4+9iPMjHYnNVSc+IW3gwlyEAalcAvq?=
 =?us-ascii?Q?Xq3GLifqd2ekdvX06qfRUBIUYOrfBFvHaa6jMaLyvdXoU6jB7moujuC8/SGb?=
 =?us-ascii?Q?2BPAw6eCSfi5tXZcbqErmTwBi2saQcZnQzN1CFQ2l3hJqobc2N1agc6udeqP?=
 =?us-ascii?Q?id0xDsNdXPO3TjiyVLW0tTKTA0g9fAUdEgkPEUCzoOo1k9N+h2TWlaEQMn7C?=
 =?us-ascii?Q?htBn7QdS+HSCn10bIqAYukmVkZJM2VJ+f40CQTmFRvPnbDrZndO0VYCWQOp4?=
 =?us-ascii?Q?5pxEsl4Ayp1etx5NQfkm05nn643Z/4ih0IPSp+kEwYROEkgZ88X5Gsf/7RJH?=
 =?us-ascii?Q?byxojnAo9fwrNNNaWXV9C2G/YlIU2ZODTqqneEJRA3aYfVMSCbxdqRJO9GKg?=
 =?us-ascii?Q?opkGiy3cAZO5we+hFomeSwwbz9SYlip9155d3wuuJ5rJ6zszADGx+JStUCt0?=
 =?us-ascii?Q?feiU/9GcYLt3ruMmhUgy5UnAb+a8Ow+Mo9UABCBhU+rdbvRp79OhEILPT3th?=
 =?us-ascii?Q?lH0IGejQ2nGZ1d7IjLn41ktY/ju9P2YcsVEYBt6azOtRkrSIeBc8yAfJFi+f?=
 =?us-ascii?Q?kOCOlxiRK8e7UKK8a3y7ho2XlA6Su5D5FeNkisacLNfEcipwesA9lG6JpUjl?=
 =?us-ascii?Q?xgvZgWXAHINqCMK/HM7JOBashIGO0vCReyaSAf+l+Cz9pBokLUsqk9ELaoXx?=
 =?us-ascii?Q?Ah7UxuM+Wg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b953133-3460-4f51-823f-08da1938232c
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Apr 2022 08:16:52.4236
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IPmlbV/6CXHfHYLT1kmwbuAdJbF2XXJTH4Vtt2NWOfK/sVUzUmm9qCmMqirVfnqxGBkCrDk/XyPiX6hQVnDpzw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB6004
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Thursday, April 7, 2022 11:24 PM
>=20
> IOMMU_CACHE means "normal DMA to this iommu_domain's IOVA should
> be cache
> coherent" and is used by the DMA API. The definition allows for special
> non-coherent DMA to exist - ie processing of the no-snoop flag in PCIe
> TLPs - so long as this behavior is opt-in by the device driver.
>=20
> The flag is mainly used by the DMA API to synchronize the IOMMU setting
> with the expected cache behavior of the DMA master. eg based on
> dev_is_dma_coherent() in some case.
>=20
> For Intel IOMMU IOMMU_CACHE was redefined to mean 'force all DMA to
> be
> cache coherent' which has the practical effect of causing the IOMMU to
> ignore the no-snoop bit in a PCIe TLP.
>=20
> x86 platforms are always IOMMU_CACHE, so Intel should ignore this flag.
>=20
> Instead use the new domain op enforce_cache_coherency() which causes
> every
> IOPTE created in the domain to have the no-snoop blocking behavior.
>=20
> Reconfigure VFIO to always use IOMMU_CACHE and call
> enforce_cache_coherency() to operate the special Intel behavior.
>=20
> Remove the IOMMU_CACHE test from Intel IOMMU.
>=20
> Ultimately VFIO plumbs the result of enforce_cache_coherency() back into
> the x86 platform code through kvm_arch_register_noncoherent_dma()
> which
> controls if the WBINVD instruction is available in the guest. No other
> arch implements kvm_arch_register_noncoherent_dma().
>=20
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

btw as discussed in last version it is not necessarily to recalculate
snoop control globally with this new approach. Will follow up to
clean it up after this series is merged.
