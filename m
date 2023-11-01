Return-Path: <kvm+bounces-304-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F14007DE09B
	for <lists+kvm@lfdr.de>; Wed,  1 Nov 2023 12:59:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A882E2817DC
	for <lists+kvm@lfdr.de>; Wed,  1 Nov 2023 11:59:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53B03125A6;
	Wed,  1 Nov 2023 11:59:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ehHM5hrk"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9A1B11CA6
	for <kvm@vger.kernel.org>; Wed,  1 Nov 2023 11:58:57 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EEF8FD;
	Wed,  1 Nov 2023 04:58:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698839933; x=1730375933;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=+uZsrpGUhnqZToB5/k3c+fWPcL/OyKOYqpSA/rdf1pg=;
  b=ehHM5hrkBlHCYm62MnK/fHq8F4lr38hZHatEfyfvKcdfn5NremWaRXqf
   9ASsptiogn6ABdu0jgXlIjLL8V8K9b+OUOYK1KwcssoI3+eC4M7fX9WwV
   co3eP8D5dZxZ1cpLx0hEceYJo4GzZE+nBU46QKUBj7E0AtqDVSx/qUCrA
   67z81/vrd8mim9RpSyeGT92I3bvBGQX2WOc3uEK+XoTToBRhCVulEQYgQ
   bUUw0JQVj501k33VTfVsX8ZJ6GIOaOW3Dxhx4l8XUfxmlQD4j1U9PKhRy
   6AzwZBkydqD3cXSA0qOu8GIj2rXFDHUx+O42RDCNUtWdriToGmMVN4OTO
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10880"; a="388299301"
X-IronPort-AV: E=Sophos;i="6.03,268,1694761200"; 
   d="scan'208";a="388299301"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Nov 2023 04:58:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.03,268,1694761200"; 
   d="scan'208";a="9028287"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 01 Nov 2023 04:58:53 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Wed, 1 Nov 2023 04:58:52 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Wed, 1 Nov 2023 04:58:52 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Wed, 1 Nov 2023 04:58:52 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.169)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Wed, 1 Nov 2023 04:58:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iDf1qAd3YM8z+qHPabKVvSHB2Xllq6jyMSf+QCgUKVNxx7oud6BXWDELixjZdlknyeqx3fmELFkGpK7hq2GLjCwo5o47qYi5UPf49X/KzPbTufVsmqC4MBOOEeuQxipvQpz8hv3cwEwxg7Mgidtgm555tPD8jIRJB/c2oDk1I5tLG5DG/P7K2w3QKiyEDmr1ixPnuMDeaK7z34mqjluW0c26mWKqzVEh0KOz0LVO2YRRVj1me5LkUQuf02aC0oMJ28TfoILCUl5z10B5tQ7YTlh+ROkmQQaPv/VI2XBciR+m1uU8tIc7uWVOaG/4KBciVsKnrvurWtS3AxNDuwXckA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eWpSKShaRSAGHuuvTAYOdSPIQxDwKqOwssBUFSJZmyQ=;
 b=HrGVqozFbX1jOnAuFPKT7GZyAEGjC7zSCNlAY9ijwfg2aiAh5L9eTdMa8mLOTbRJTElWHr0X8DHhtwFGZl2PPBu0Mgkm45oFRZsCDcVUZ7Tj37JTHBhK0/k7SSXl1NAxay3nIClPIiO87/F3vWTawUnwDmAe0RKNU+8g8Of9wtiSg7nEKGn8AXkUpT7PXNrbuoHvITm0bJ/esVW5H/Zi5O2WZe+vGI042Z6FPgZk35Y+psS0vipmgWeFIJNKqPa/uvDmGNsapH3RiawpiLp7dFA4RoY+ZdBZaZcC4Kfep9FP3HFhmDRE0VzH2i5eJsSOwrE2cA1fu1JKi5jCwyJT3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW5PR11MB5881.namprd11.prod.outlook.com (2603:10b6:303:19d::14)
 by PH0PR11MB5190.namprd11.prod.outlook.com (2603:10b6:510:3c::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6954.19; Wed, 1 Nov
 2023 11:58:46 +0000
Received: from MW5PR11MB5881.namprd11.prod.outlook.com
 ([fe80::eab4:33c1:2b7f:39fe]) by MW5PR11MB5881.namprd11.prod.outlook.com
 ([fe80::eab4:33c1:2b7f:39fe%4]) with mapi id 15.20.6954.019; Wed, 1 Nov 2023
 11:58:46 +0000
From: "Zhang, Tina" <tina.zhang@intel.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
CC: "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, David Woodhouse
	<dwmw2@infradead.org>, Lu Baolu <baolu.lu@linux.intel.com>, Joerg Roedel
	<joro@8bytes.org>, "Tian, Kevin" <kevin.tian@intel.com>
Subject: RE: [RFC PATCH 06/12] iommu: Add mmu_notifier to sva domain
Thread-Topic: [RFC PATCH 06/12] iommu: Add mmu_notifier to sva domain
Thread-Index: AQHaAKkIdQu/O0P8jUGMFumNffjTC7BXvhCAgA2wTNA=
Date: Wed, 1 Nov 2023 11:58:46 +0000
Message-ID: <MW5PR11MB5881B1E856300751358F407F89A7A@MW5PR11MB5881.namprd11.prod.outlook.com>
References: <20231017032045.114868-1-tina.zhang@intel.com>
 <20231017032045.114868-8-tina.zhang@intel.com>
 <20231023183527.GM691768@ziepe.ca>
In-Reply-To: <20231023183527.GM691768@ziepe.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW5PR11MB5881:EE_|PH0PR11MB5190:EE_
x-ms-office365-filtering-correlation-id: abb9a7db-c98e-4ab3-7429-08dbdad1e74a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Y9HoCp0JzbGNev3P8Qjiv69zLsdWqoBZ3u2zhnG481Fsm7jJYeJWIRakOwXISEDMUxEPTHNMu99jy5gjaELGt/UGW2v81OM0TCYndV7AJIRppS7v5u0rS3lbaO4jnpqWN46RQ4p+j+Poty4oWtjD4N5EPbLEapcjBBI0bPSmHgllQuWoiQuQ0F/InAYur/LxWMi6Z96YUEMrZTiHAhQGu0iLEAu7NEuSbeEUZCLyOquXU/iSdoWEyPC5e2zo79Zw1fz0pmc1amnsqKpq6Y77iFDqaHMSuBpMsyBJKBXYxlYxfzOvtGf20HDJLf3C8hYi+jK8thIEsxhdq19aZGsvAFXn1yDm4j3fpt/LoXkBjjHdCI2l7SLxJ7dk+J1Q1CX2v0UqyelyL1dI8l1+lHgGvbpGkqn1SsYrRX03vsgBDEZRsOS0FP1WAQMjUy8FUQlqL7q9W/h77yMWwZssx1pR4IB60phiOifcNTlTUxWLFz5zCZ1FPU9yDPeaXhB/TEpG95uNNit2GnMTk+HBGhS/QqWkapkG252fqaEWStlydNJSJ9512uxg0aSJIZc9KM06q/eLxpQm6Cnmjf7ExvIP+pkPLJTJ8JI1tfgnztJtX9c=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW5PR11MB5881.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(376002)(39860400002)(346002)(136003)(366004)(230922051799003)(451199024)(64100799003)(1800799009)(186009)(2906002)(8936002)(8676002)(4326008)(52536014)(71200400001)(41300700001)(478600001)(966005)(6916009)(66476007)(66446008)(54906003)(5660300002)(64756008)(316002)(55016003)(66556008)(66946007)(76116006)(6506007)(7696005)(53546011)(9686003)(26005)(83380400001)(82960400001)(38070700009)(122000001)(33656002)(86362001)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Vvq+1X2k3gba683I4F1K/VbtJKOqwtFWo7kZ0y6QW6iL+AOD0q2Va8w0nW84?=
 =?us-ascii?Q?Q63jNuzRXxfBDHAjJTlyjgF7cC2S9+H0/tITalff3mJjqA0mpM89qkwRo39e?=
 =?us-ascii?Q?jYiS5N0hGedGRRIgZ8cZfJmGxFPe7Bk/jDKhqfDsQ6+0YvIdaukYXZWXB/oz?=
 =?us-ascii?Q?5UcObgt6wERuqwK5ME58W/SrkSYIzeuX0/Chx3mShxXsD9HCr7VKLbG+d/CY?=
 =?us-ascii?Q?pp/FCj78jDQAMLFtBBgHWUAfk1naOBRb5W34tKJ5Iz1yhpnDHkk/l6o+Rb8l?=
 =?us-ascii?Q?FQYEdFsWypm/FZyBFAoL9q5UOU9ulOEMGDQmzSs+dHfoo7oJbXM7aT9n8COJ?=
 =?us-ascii?Q?QsOkKLZ4hnlYY7EezK7F7s7R/N1bjS+Ytd9X5v1x0A7DEQ3TtQ2WYCfPPST3?=
 =?us-ascii?Q?K6ZleEuRwk0I19w2PjpTgcWsnit1DipYmFhAU62rd13GD/mqWZ5rLCYqJCbC?=
 =?us-ascii?Q?FKzCrFPGtn9L8/B4QbfVpo2GXI0Cp3i7GJDJl1RjidrJM3zBxwym0J2XZd6R?=
 =?us-ascii?Q?3qQASKcGjFFdOlYApTxtRuxxgio4TKq2Oh9vRErzUDxMygifUqkfhgaJk/an?=
 =?us-ascii?Q?CNTG8LA5KCsM4tu1F1RHIuouaaEWgS9+Vi77qmkdbKPIa3sQAVxsSJtxEWbs?=
 =?us-ascii?Q?xIeTmfko3z4wlfymhvEzB3QHLom8MemrsurJUXs88vq1MdOQEzWfWdnOmdz1?=
 =?us-ascii?Q?50L9OHK5LycK2rNx4OnhUY0CAWU8bQKQiKdMBfBY5r/VVAcUL3uyWdbEjHSS?=
 =?us-ascii?Q?SOCXTU85gvGNjubrMN+Jx9kxsyMF04nI3cwKwAXpYo6O5XIxwbNRwmZfx0+E?=
 =?us-ascii?Q?GbvLvBORbBniie5rNsFX4EpExceusXySREfiyWPDS7xOEMJRQN02byXP8ZGu?=
 =?us-ascii?Q?wvIdGM0Bjsm9bCCfHuRX5mHhV7RT+WyT405/fJ4cvCrknS1R3g2gti9y9JiY?=
 =?us-ascii?Q?50vI/Xl5HJLeYNo6Mj0ARhGTyfUh5qolXx5Hw8/xlt4y4fRU9WddGbQAj7m/?=
 =?us-ascii?Q?V2dD/dhaJqviCC53/MjTlvmn5tPKVzJvFuWY/dQtey8DlOF4NQqiCX+19EGI?=
 =?us-ascii?Q?+aHJ9EwntAMPruSe8sSRxMxJX1fAYZKOAFT0ocohvp4yib56D6OcMGvKMLvW?=
 =?us-ascii?Q?T68ebvJCtINTSUbOlO2waLqGoNEGRYc+dcKk5dmv4WXmvBvn4fxE4Pmhq8gX?=
 =?us-ascii?Q?eMIvK6ZEyR936vDV1XugIc3LRkyChE/dAz0ISJDro9+9ZSC2NIHCihEqIQwe?=
 =?us-ascii?Q?dKiZqbDYqyyGmxPub28nYDMIJwghQwQtWDIc1+qgdz0rC27DyJcMublAKTs9?=
 =?us-ascii?Q?aUHsLtgFDP2LQToAeEyUb8ZQYXVteh8cXNNe3Mk73F5E3KV2ziYZSBLRQEIM?=
 =?us-ascii?Q?TeweY5rkNleI2DRgQ/LKs0gVHbwxbmuBunq1II7ldUEaYQbdc/X7J1B/LSaK?=
 =?us-ascii?Q?6QmEVovTtjv9aR+vmUExtmVLaz/t6+GbLStqqk16bX3eyrJYPF9QI8X7vHDt?=
 =?us-ascii?Q?JaKkAPmU2RuDOvp6Huxx1thvQonmUsJcx0wNiAtAKVZirakSIg1amzEgg1UW?=
 =?us-ascii?Q?/ztb1vKSsFZYhBZHmR+D80NGEOB4Dkdlrkne4/1C?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW5PR11MB5881.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: abb9a7db-c98e-4ab3-7429-08dbdad1e74a
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Nov 2023 11:58:46.6005
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fhurY1nPBJ2W/tpQ4ve2seDN1fDuuU60pNO8qoqDW6I1wpRNPMfjnUi/Hfz+Csrer52+/72YXJxE/B/ob7xs8w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5190
X-OriginatorOrg: intel.com

Hi Jason,

> -----Original Message-----
> From: Jason Gunthorpe <jgg@ziepe.ca>
> Sent: Tuesday, October 24, 2023 2:35 AM
> To: Zhang, Tina <tina.zhang@intel.com>
> Cc: iommu@lists.linux.dev; linux-kernel@vger.kernel.org; kvm@vger.kernel.=
org;
> David Woodhouse <dwmw2@infradead.org>; Lu Baolu
> <baolu.lu@linux.intel.com>; Joerg Roedel <joro@8bytes.org>; Tian, Kevin
> <kevin.tian@intel.com>
> Subject: Re: [RFC PATCH 06/12] iommu: Add mmu_notifier to sva domain
>=20
>=20
> On Tue, Oct 17, 2023 at 11:20:39AM +0800, Tina Zhang wrote:
> > Devices attached to shared virtual addressing (SVA) domain are allowed
> > to use the same virtual addresses with processor, and this
> > functionality is called shared virtual memory. When shared virtual
> > memory is being used, it's the sva domain's responsibility to keep
> > device TLB cache and the CPU cache in sync. Hence add mmu_notifier to s=
va
> domain.
> >
> > Signed-off-by: Tina Zhang <tina.zhang@intel.com>
> > ---
> >  include/linux/iommu.h | 2 ++
> >  1 file changed, 2 insertions(+)
>=20
> You should look at how arm smmuv3 ended up after I went over it to make
> similar changes, I think you should take this patch
>=20
> https://lore.kernel.org/linux-iommu/20-v1-afbb86647bbd+5-
> smmuv3_newapi_p2_jgg@nvidia.com/
>=20
> into this series (maybe drop the arm part)
Good suggestion. The new domain_alloc_sva() callback allows drivers to full=
y initialize sva domain that is what we need. I'll take the domain_alloc_sv=
a() part as a patch and include it in this patch-set. Thanks.

>=20
> And copy the same basic structure for how the mmu notifier works.
>=20
> It would also be nice if alot of the 'if_sva' tests could be avoided, smm=
u didn't
> end up with those..
Agree. With the help of domain_alloc_sva() callback, I think most of the if=
_sva brought by this RFC version can be reduced, as we can reuse fields fro=
m dmar_domain (or add new ones if necessary) and initialize them in domain_=
alloc_sva().

Regards,
-Tina
>=20
> In the guts of the pasid handling sva shouldn't be special beyond a diffe=
rent
> source for the pgd.
>=20
> Jason


