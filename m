Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF62D788147
	for <lists+kvm@lfdr.de>; Fri, 25 Aug 2023 09:53:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243249AbjHYHwl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Aug 2023 03:52:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240477AbjHYHwe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Aug 2023 03:52:34 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE0EB1FDA;
        Fri, 25 Aug 2023 00:52:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692949952; x=1724485952;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=4cir7HE57jxFb+wnKUfK2am+FraYmZGC2O14WAtHi2o=;
  b=cD2DpVYEr4AzOojccoVW3mgenzloCltCie8TkgiI3UMoqzh3XhYgZm/l
   K6yxRjEjS2j89qR6Y/Vua3aJigyHcQOv7NvpDdiijie+qAYCFQ9iQcCRA
   8cI8fZsfb4LcJH7Y9jN17qUaLG9yJUGwkyuuJkY72VIQSCGzEeNCc7xHx
   fEv7YL2KyDZ2rsoTcaEcKSg0EC7txTxAQv3t8PYo2GJO5zs37XbMfIV7x
   Or6uJd2GUug2gOiksBeUdJcs5wP8ChFFvLvvWXGBqqHHn7yq2qwk2/LNc
   lzkmUcBIyg5XBzf98Sz/GdnSIcuMW4Tv1ggxIZQTsxt4le9DnEg2DSXGM
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10812"; a="364854831"
X-IronPort-AV: E=Sophos;i="6.02,195,1688454000"; 
   d="scan'208";a="364854831"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2023 00:52:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.01,202,1684825200"; 
   d="scan'208";a="881100980"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga001.fm.intel.com with ESMTP; 25 Aug 2023 00:52:36 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Fri, 25 Aug 2023 00:52:30 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Fri, 25 Aug 2023 00:52:30 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Fri, 25 Aug 2023 00:52:29 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Fri, 25 Aug 2023 00:52:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WQv7fVP2X3Z+DRGMZlPoYkRosBwllBFhxfzQX52QS3YIRv6GbegW44dHeBO9Z0OJf8WX0pbndPZmtR8ZVfm93Z7JuW9HWQtPnjsS28PZ1wiSNtwh+tcFhrDUwzI2/UixoqdcvgRF8h9M3xmZQVYCuSFXt0vkR5/lFY1SwKXqW0lxPzLwBsW38okqgG0AOkfOafsB+OCxF50SNGlB3Ef2vvR1daBi0k4PXFdy/7U3AV/1NTOWu+Da+efjBdv+c21SaxvaPwd+9aID2WQLQv4mTISk6IEsHrCUGk4eM8FIV8TncjsjBuXoq5kggXZQDzlCMp+fOC0hGYMiI7w6ZW3OcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4cir7HE57jxFb+wnKUfK2am+FraYmZGC2O14WAtHi2o=;
 b=f1g36jee0cczYVGbBjyXFsbAZ+XyPT+axXxgdT+IFg7DtZAtwtjlhDcMefKlgnX2rdGZuoVIQJ6PxTBPlLfKyToJr3NPRkmDdQAAgKEea7t2tlUy4f/t6q4UJlT6nrsp0IC5Cuq4witgbTmKBXdTzNfsFo/H544j0m9IUyy2hRD/vcnUkrJeoW9joT9krlPgixAXI85Ur4J7fzUQIPaB+cs++WnbLJhVyjPSmjFIHbblInhOXfvwzXdDgIeJFEN/AU/oRA/SFkMtPW5IzUu7kisu0AqlpEJlc0yXyZimWnXWg1UvLiod7wXxSi0auHmT3TcsV7UWgVwPijYmA25ZhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by LV8PR11MB8700.namprd11.prod.outlook.com (2603:10b6:408:201::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6699.27; Fri, 25 Aug
 2023 07:52:22 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::dcf3:7bac:d274:7bed]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::dcf3:7bac:d274:7bed%4]) with mapi id 15.20.6699.028; Fri, 25 Aug 2023
 07:52:22 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Will Deacon" <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        "Jason Gunthorpe" <jgg@ziepe.ca>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Nicolin Chen <nicolinc@nvidia.com>
CC:     "Liu, Yi L" <yi.l.liu@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Jason Gunthorpe" <jgg@nvidia.com>
Subject: RE: [PATCH v4 01/10] iommu: Move iommu fault data to linux/iommu.h
Thread-Topic: [PATCH v4 01/10] iommu: Move iommu fault data to linux/iommu.h
Thread-Index: AQHZ1vyOLHyP2iq9Qka0gpv/BXDYxK/6o9Rg
Date:   Fri, 25 Aug 2023 07:52:22 +0000
Message-ID: <BN9PR11MB5276971FCB36A3ECBCD48A8B8CE3A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230825023026.132919-1-baolu.lu@linux.intel.com>
 <20230825023026.132919-2-baolu.lu@linux.intel.com>
In-Reply-To: <20230825023026.132919-2-baolu.lu@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|LV8PR11MB8700:EE_
x-ms-office365-filtering-correlation-id: 1f4a7f4b-09bc-4ae4-2ab4-08dba5403707
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5ITonka1ES+QeTqrIkp1FPlekvd1CF3Mqdd2SanD7IBE61XSKe6bxocsXWvpNE2H2rb3CAZyVUkiyMGiMB+VROF2x4UmKF6cunGndFPZCBoaGAwfxiQTr+dE7VtPf+yryboWFhAh1SEaPEo1eFRbX+dy8+zQlkpp8oYbBGk5Cyoge4X6eR3GA8gPOkm8EsOo1C/3u8KP+CeZwC4TD58cNhKbIOXWwS2+EHLThEyy7+B1S+SjyqU9kowQba7xGJrg59s48aGAKoNvPR5yC8SKAEsucICuW/RM68Eo6JA6syKOIXNfjrSESPnwhax/TYmyQYuvP/cbGO+McE3A8BHnB7R/CeGtYNjZNPloD1QIUjXf9CYavP9xi6qgfonzJorDB+u+keHy0LK3CNo9JAN07iC9IJ9n7qNMPYXB2t42yoo41AN6bydG6uEQrbDGWZwATc7G0az6M2twDL1nigJfW+oI8cYDbNCDb0UlbfpA1d7FJuVtM9Zu21BdP29JmHdt1ritQVIa7FE9Makq/qPDvgbta15RpDI/L/CbY6z68W+4qqUUAeiZ7JKmVQQyX48EDnVL/nUOyaMVWm4wu5iMCg3M2H1Q++GTvqqZYeYWiAvE/ieJJQM1GZp6TxC0yl+x
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(39860400002)(366004)(396003)(136003)(346002)(186009)(451199024)(1800799009)(66946007)(83380400001)(9686003)(41300700001)(7416002)(66556008)(4744005)(66446008)(66476007)(54906003)(316002)(76116006)(2906002)(5660300002)(4326008)(52536014)(8936002)(8676002)(110136005)(478600001)(6506007)(71200400001)(7696005)(55016003)(26005)(64756008)(82960400001)(33656002)(122000001)(86362001)(38070700005)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?oY+zOQT18vlPSS4pf6D7i1QNKmB8GAF1RdoO8BP14hZTAGrAeEGcU7NEOUiA?=
 =?us-ascii?Q?v7Na8YCfL9kDC4IGDFSanNBRQ59OGCMAcsJRuWuF+8to3FKrEFFsx1L+yhE5?=
 =?us-ascii?Q?5a35Nu3UqQ30Q1clNm/6lVljzQXb1TR8laW6eJtGWgARL+7lkaS2FSFQLQY6?=
 =?us-ascii?Q?O5CtoJxGUXmAWL2wIKcswZrYKdnnBPlGfHq6UdYsaZojdaxKG6BDS8m0W0Jv?=
 =?us-ascii?Q?Nml0dDEHBpjDkMQBcplzwF8tyWWaqMltIJjw4XMx3vJmp9H4eIHdQQuzRv03?=
 =?us-ascii?Q?n6DaKwBjoTK+ILBVCaMqlP5GUmLEOzmmgRnN2AiUJ3VMapeOITQ9w24Zc14I?=
 =?us-ascii?Q?5h/7P1CNYJpLY7lFYJcOm2mdJJ3lgT8kRP4PbuEb2IejotxrNzA4YwYFYave?=
 =?us-ascii?Q?/oMwXmhjxMSwMRI8cg1Y3XXpxDX6nfokXtgEBdF9sA9tFTl0RmokGAXFz2gn?=
 =?us-ascii?Q?ByrZakhVAA3la7RHDryqMG4D3fqHly+oBhsFCKVu/HllB/COROcDeDDuLXHv?=
 =?us-ascii?Q?yVz6HYMrQi0MZVlwn4xpEKCevsjFHgLqiDuJ9aXHl1QUu3Vo169OoA5P3OqI?=
 =?us-ascii?Q?SrioMcygDe1wg1lKl9ueP180nL/pZQC0c6j1xn8Ng41+sv36C/bDfSQczWyI?=
 =?us-ascii?Q?L20KLRfkhq5k8dXvZHZvUCLFsSTMck2yL+hLOve3rDb9vv3JKS9PYrh8bPAO?=
 =?us-ascii?Q?lvkYXVoF1TtpuzBzdkgtQ/NoiF+vHVn4KqL4gy1YhazklIHo9/UOpnPmJhzx?=
 =?us-ascii?Q?cZ3O7H4gOI/WYpn438+8EiUVhiZNb4LOqaVsp2Wv5jMEu02GxEbqhPQNkXJH?=
 =?us-ascii?Q?/KhKOVsFbay1FvQDmaVXI42OrfoDy+FYlxICGJBL82cF+QR/B2X5QOD0c6I3?=
 =?us-ascii?Q?+vD/bzanJlkbRB1G2PU3T0dGDVDDjGb/S532Xs0cwo+J1UwzR/T2ir0TYaKu?=
 =?us-ascii?Q?AbzjUZWJzk2tU2SzRFCJmGaeRJTSoTbe/hlE936NAi3SREZGWBm0qjoj7zif?=
 =?us-ascii?Q?5URjXCU2uYbukUbzA6PIVVpkt3ZCD1oYlzKNZT3X4o2LtgmjAqL9TMKOOKR7?=
 =?us-ascii?Q?qRT4YYcH99ysUyQxco011KWlRgrLa2Gn/IFsRgcy4WToufTrHEqyJteJ7frd?=
 =?us-ascii?Q?MlBXScpWcFo7/msGqqb4tMn81W3ft15Sb6YTeZjkGbZrSBmZqx3cbw06IgEe?=
 =?us-ascii?Q?JU2AUS6e/7lLdBnnYJAqkF53nVm4pgrd2jS+P3cGVp/1q2j/XcbCFg13rMn9?=
 =?us-ascii?Q?6JMG+a1akLUxcW0z/uBOFhkB5pwCtEN/8SlPAf/Y42DICWYB4L7Z98m1zvQC?=
 =?us-ascii?Q?YiiUKXNGtJxAa338t3kMG1/9397AL/NhUiGici/sgkwpz4Db5fxt2NyceLyk?=
 =?us-ascii?Q?+94T6DXexN8h2iaHwjZQe6mb2wYjsb+jmBuEkC7K1f8w6s7op+wFdl0YUApJ?=
 =?us-ascii?Q?jBbtBfkx/HRijsj1XR4CabjtN76ZJ29uJUxvT32qN2hn/dgvzafT/B4JA87e?=
 =?us-ascii?Q?Vuwk1TNvRr89J2nf1xHKgzWpFpBd96qfLEVAx+Zgb+7PWNd/Z262ckXqEO/5?=
 =?us-ascii?Q?5SNC2TyxaQcIL56CkUAXte8Dwcb6cJVbHv0uiEId?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f4a7f4b-09bc-4ae4-2ab4-08dba5403707
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Aug 2023 07:52:22.2378
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0ITe9lXebW83zUOHN6G74H0VDTiQFrmclWK7VFUzmjGQpcqMZWI9ez/JyUiAgtqx2WgrqVeT9nvw3Z7Ngece1g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR11MB8700
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

> From: Lu Baolu <baolu.lu@linux.intel.com>
> Sent: Friday, August 25, 2023 10:30 AM
>=20
> The iommu fault data is currently defined in uapi/linux/iommu.h, but is
> only used inside the iommu subsystem. Move it to linux/iommu.h, where it
> will be more accessible to kernel drivers.
>=20
> With this done, uapi/linux/iommu.h becomes empty and can be removed
> from
> the tree.
>=20
> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
