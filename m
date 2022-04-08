Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D75FE4F90C1
	for <lists+kvm@lfdr.de>; Fri,  8 Apr 2022 10:28:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231747AbiDHI37 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Apr 2022 04:29:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230126AbiDHI34 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Apr 2022 04:29:56 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BD05283F62
        for <kvm@vger.kernel.org>; Fri,  8 Apr 2022 01:27:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649406473; x=1680942473;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=uibrfNtHdvs4Z1xzgAOJmXXk36yG5KvuQNFqMscgQvo=;
  b=B7EXq1YT31Rp12/LL0zJKr3NEIWYvCQ6eQOHU+KwFt41Qp0cc1EGWFu2
   57D7rvg6gC3g1SgOFUWHcyNEqzNnusyUourUi10K1rVO0c+nxmrlnOcKZ
   4kPxUakakimsrhpD0O/wzlDd3eyANbckb+pRnyYoNILfTXb7AGCgyy6pG
   JG2THkypGfm+5Gh8qZNqxZ4lEfagAwXtdZEdjvASDNdqzSCohiAhRALTc
   tN10lakek0pzeyDJ29cr/vNOflC3enfF/yCndSvKvR47YV5x6jVFzkFhK
   aYDUXulwuWSw7/Qecz19M+bXwZ3cQdFKiZSc3qSuLBZHYO8ZIYTO8b36q
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10310"; a="261537537"
X-IronPort-AV: E=Sophos;i="5.90,244,1643702400"; 
   d="scan'208";a="261537537"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2022 01:27:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,244,1643702400"; 
   d="scan'208";a="589148379"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga001.jf.intel.com with ESMTP; 08 Apr 2022 01:27:52 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Fri, 8 Apr 2022 01:27:52 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Fri, 8 Apr 2022 01:27:51 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Fri, 8 Apr 2022 01:27:51 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.108)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Fri, 8 Apr 2022 01:27:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mle9d1SA+ihPzgU8pvRD//ZUlhAyZoE7y7B2RA+MkBAH5Bgy89YJulVRX3MjwRNswRuEFYYPY3oB7Z5pW6caKu5ygr0jsM1F5tp3Pgz7TG9XkAdlzFp/a1m+3J9nyNKXICzqNSODbNIKcWcVSfUTUmfUwm+iH365L8ysyo2id6MqLI10sFAXIzaLi1jfzsgk5oFuou3rBEhIW9tXE3jcWSY094XlLFek6+nDHbBbuVZE8VnhEMFFcZvJRX2ccoYlRPOlDXHFDlnftrgAUWZwUcG3xUj4xNeakdQcPNHvlbOd5tBiAEE7vR8DGYc0VJ5GOQGURMkNmHM0r9BN4j4CNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aK9uraLcSlFkXAGCDddzNf6txwhEilHLvvwQJQV1AGQ=;
 b=T2Y9iLWy8VERNa+d57g8tlmnzDobw7S1V8/GABrmFNC2u0SwaIwcq2RXHhYHLTD2Jy1f5mvp5UD385bWf06B38Vj9dFWIDfJksyWyp3PtHUmNNEiegyqi4rEH3GQrJzooTLDqpBipiXtpi7oVSV8ocfyTvXb0TCWS8OdOjOals7gQyPidoZu+pek2tlYU2NXUOWrSKcI0HF+kRCQGyQzRx1SZ41ZyDEPAy3fNara8h48BIE1l3f/DA2soU9Bx9z3Si894lLFI72oxtm9ArYi+oBo0Q0+ruhcaKpPSTb89CVJ+0tl5YN7ueHLcr2oakhP+bta1MMnFFwXN3ePQG4uAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BY5PR11MB3973.namprd11.prod.outlook.com (2603:10b6:a03:185::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.22; Fri, 8 Apr
 2022 08:27:50 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::c4ea:a404:b70b:e54e]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::c4ea:a404:b70b:e54e%9]) with mapi id 15.20.5144.026; Fri, 8 Apr 2022
 08:27:50 +0000
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
Subject: RE: [PATCH v2 1/4] iommu: Introduce the domain op
 enforce_cache_coherency()
Thread-Topic: [PATCH v2 1/4] iommu: Introduce the domain op
 enforce_cache_coherency()
Thread-Index: AQHYSpOEGT6KYihBE0KVKKuEEItfF6zlp8VwgAAHt1A=
Date:   Fri, 8 Apr 2022 08:27:50 +0000
Message-ID: <BN9PR11MB527686E0ECB554FFF37F401F8CE99@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v2-f090ae795824+6ad-intel_no_snoop_jgg@nvidia.com>
 <1-v2-f090ae795824+6ad-intel_no_snoop_jgg@nvidia.com> 
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 015577e0-e9cb-4a04-f37c-08da1939ab1e
x-ms-traffictypediagnostic: BY5PR11MB3973:EE_
x-microsoft-antispam-prvs: <BY5PR11MB397339D9A1FEE1F791DAE19A8CE99@BY5PR11MB3973.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dlaG+RnVT65Si093uDAfG91DthuSvrAX6D/glIHminAeyDG3OZzZJsazrINHyv5Wv9/6ILIaZ/U50oT4poiw9PzjESgUSlo7O/fQwWu+5EWhxJttdebmaz7k+mEKgkxd6ts2oAzwWbqlSIdwWdOQxSK9hQGTB4tqMTOoHSPmf/5snSuaoQktCsRIJDcIEgatj4h5Bv2MPWkVmGGgxaQYZEvqKz18dctOQ5ihZAb8GblXnjbgYSXGIHuxmOwO1oLHukOk7yS9aHE+/56lRuqEvz7CVOAHwyoij8aqU/aCixNJkt/YtXnlkabFg2RN5KJIXRn674gulHjlgQZMWU5tAzoglLfqxL1pQKrtrLF0pY0y5qdQnPz0prNa87manFS4BhMfLB0LIjyeB54LLqRFs8DZu5jSplKAgGHowYcNVOds9Y7fLLJGsoIBJM9lE8u2th01oXeyVfVguwms8xFKcsdIy6qqb1+7wikWohmlf1c/OifjVDohzP6wBSdX5Ih1MpJHv5B2rRPa6Gx4X6F6UXqeMZ7l4XaLoBPPrdqh7DnVxsGQM+BFrhe++xZeskcp8o/94u6lTfxIPS1cHBQsu0X2kzwGP2OkhZXcVoa1gtL4msvqQhdDtq99FILLBDDYAXP0bePRaokXoShRZVpvndUDetFca247vdYJB4AYS9+ezI9WPZw41P5OHS3GXlLmSd5KnNYWOEwjiKunFafm9WoUYSR80Kx8u23ug9o0WBw=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(186003)(83380400001)(66556008)(66946007)(110136005)(26005)(82960400001)(8936002)(38070700005)(508600001)(6506007)(2906002)(7696005)(122000001)(33656002)(86362001)(55016003)(9686003)(7416002)(54906003)(71200400001)(5660300002)(316002)(76116006)(64756008)(921005)(52536014)(4326008)(8676002)(38100700002)(66476007)(66446008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?jYK8q+gpu5Tv0rZ0+fnvAWpnfyrSTfMZ4bmwFpAeVVQno1HyyFTIcBd0M17S?=
 =?us-ascii?Q?Ciq6kg2NuSt9Ti2S6DVeJ9ZN5RqzyrSPjxTykTyHJoh11itnPZnU203sMf9h?=
 =?us-ascii?Q?ngjzRosNuy81JxrKLzL/SM5feb8jyI4NESX2CcPktCnS5uJ9Yy5hrOeuhYAm?=
 =?us-ascii?Q?ZALZLTWsNRawoH8iA0lWn29pzxXxqkfPJI/oyvy3iijLdP6i9IJyDRvIchtT?=
 =?us-ascii?Q?UDQR+E0k6oPZVf/lTK7HtlZUBc/Dg69AjHANvr+utMaUGcS3SGyNXREiSe5I?=
 =?us-ascii?Q?Xr3JkTyc91TJU2PEI6ulrvfgF2KnCyUieMAxt6D/dE4ecyp0VW566yjV3f0B?=
 =?us-ascii?Q?73q7/Sp0pj1bEEC8XUrMVN/VKqktq45LiYev4K4uy7Ia8Q5ZZxJTkYfzLE2n?=
 =?us-ascii?Q?jybZ2zdakYd/ELI3boSqeytJcd6tgDIaB8p0tLIe2P1U4IfNmuszdcx+2ZSh?=
 =?us-ascii?Q?b4o+zPh7GgKm5pQTkBQ4Po7FHJWQwrlwTGZ3JL3tOoqPesorvu2yekos4Xc9?=
 =?us-ascii?Q?LOegT030mj/k6sbX5dJCYEKBrcx7l8XQ3RR25YRQommA++gkvJwyWamPnxlt?=
 =?us-ascii?Q?NExjz9tx8E6Q/8cvfv7d5dUG5wDayHisR7zDY781W+RAnN1LHP5kcavY0HZT?=
 =?us-ascii?Q?Tb+LdscLrVUlQaWVr3KVngzDW4h3sMfC9dFCe0gZdeeL/6Nq5+grdKNuFnHr?=
 =?us-ascii?Q?61ppxhTMjD4xgZweq8IgVG7myJk4H6IAsAymM2WUT8tKZ8zkmkKzjOIG4eEx?=
 =?us-ascii?Q?NMJ6xlCYbtx/retj6mP7BQUKIXvmwQ8c1LiyhM/Scr2EheJqswuhCcXyaYl0?=
 =?us-ascii?Q?nMrh9tUWGmzhSaWisN84uAtgefGUQAgkzP+C1GRTJIONxc0m4et3+/eX82Vp?=
 =?us-ascii?Q?PjFY52O4a9by9P0fZZWAFLupQ7P8UWZIxoWICvBWmRVtNm7g3ZCf6xae1S+G?=
 =?us-ascii?Q?/5tCp/7DMLYytwyGJo3HElxhDP8epAaTv3JkxcFlXfI5Bn8BRtnGFXlDp3fD?=
 =?us-ascii?Q?i7u/fbz7d2BRmQq4G11agOIfnUyp18lIUkv/ExqttXaLgYg4FMZXm3d1PL35?=
 =?us-ascii?Q?yF98eGOxWpMa9/CslR9bXsTlZ1e/dhah0tMjPxRmz0LPZ+wECfpH68p8PZxm?=
 =?us-ascii?Q?OnaRtJAoAp4fMyswoLOCzJfrvzThIeiBWQ4xd6d9LUs+Dc25KjztZYJ2Q0xR?=
 =?us-ascii?Q?Sodbp9Qkh0VcXcdVxWt8IFcWXKB0YIeW6N3hdvHYLb9Fw0etAxEKcMMEbBx4?=
 =?us-ascii?Q?oczyBkWgw9xyiT6JRx72VPVc165fFne+9KgNvNp4FU3bj+WsqItzExd8T7IC?=
 =?us-ascii?Q?qJxgBW4Ix7Kj+dv3dZz9ULQECX3b4QyodoFsblNDPurWJGTTh7H80EBxLhmD?=
 =?us-ascii?Q?kO0sCa1Cb8ukuePM2EaHhAHPSgTvR2ffPKrTWzruOS/UjvVTE+eKefzOTn8s?=
 =?us-ascii?Q?9ORzSrPm2fb5+rCXBBxK/5zrYF7OL1eyJGOoubtj3W5YwrmQXgLtZmhL/s7E?=
 =?us-ascii?Q?PVCTA40mMn7uZnpiKDVN2fzCzOY4dl7s296ayQKq6niGFgIEuaTvSiBNA/17?=
 =?us-ascii?Q?WvbJHH7yo2WLVo2pRIm412lVk77kvw/PNm7J02OpEuKirAREtcrvIPqJCUc6?=
 =?us-ascii?Q?wpubwd7LElrduillLWdB/wgI01ksfECIY+nSJOASRtK7vntC2HrcCCfn8+Pv?=
 =?us-ascii?Q?djCGDc14Dyr3cmYEOaTtm9HUzhMhuzin+IUNR+Es16Me1aJJWeVbMVTAe742?=
 =?us-ascii?Q?SGGAzleCDw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 015577e0-e9cb-4a04-f37c-08da1939ab1e
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Apr 2022 08:27:50.0171
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: phvUVelZtweyl8R5VT6ynf6UtYh0M/QznC9t/Ej61uBUGJQs+O+nGIuINH3CgxCJ3kFsYSBII67KreNBZhgCoA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR11MB3973
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

> From: Tian, Kevin
> Sent: Friday, April 8, 2022 4:06 PM
>=20
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Thursday, April 7, 2022 11:24 PM
> >
> > This new mechanism will replace using IOMMU_CAP_CACHE_COHERENCY
> > and
> > IOMMU_CACHE to control the no-snoop blocking behavior of the IOMMU.
> >
> > Currently only Intel and AMD IOMMUs are known to support this
> > feature. They both implement it as an IOPTE bit, that when set, will ca=
use
> > PCIe TLPs to that IOVA with the no-snoop bit set to be treated as thoug=
h
> > the no-snoop bit was clear.
> >
> > The new API is triggered by calling enforce_cache_coherency() before
> > mapping any IOVA to the domain which globally switches on no-snoop
> > blocking. This allows other implementations that might block no-snoop
> > globally and outside the IOPTE - AMD also documents such a HW capabilit=
y.
> >
> > Leave AMD out of sync with Intel and have it block no-snoop even for
> > in-kernel users. This can be trivially resolved in a follow up patch.
> >
> > Only VFIO will call this new API.
>=20
> I still didn't see the point of mandating a caller for a new API (and as
> you pointed out iommufd will call it too).
>=20
> [...]
> > diff --git a/include/linux/intel-iommu.h b/include/linux/intel-iommu.h
> > index 2f9891cb3d0014..1f930c0c225d94 100644
> > --- a/include/linux/intel-iommu.h
> > +++ b/include/linux/intel-iommu.h
> > @@ -540,6 +540,7 @@ struct dmar_domain {
> >  	u8 has_iotlb_device: 1;
> >  	u8 iommu_coherency: 1;		/* indicate coherency of
> > iommu access */
> >  	u8 iommu_snooping: 1;		/* indicate snooping control
> > feature */
> > +	u8 enforce_no_snoop : 1;        /* Create IOPTEs with snoop control *=
/
>=20
> it reads like no_snoop is the result of the enforcement... Probably
> force_snooping better matches the intention here.
>=20

Above are just nits. Here is:

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
