Return-Path: <kvm+bounces-14712-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A43238A6141
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 05:02:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5BB1E2831DE
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 03:02:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DFD22156E4;
	Tue, 16 Apr 2024 03:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZAai8Zfc"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8464E21342
	for <kvm@vger.kernel.org>; Tue, 16 Apr 2024 03:01:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713236519; cv=fail; b=uBRQgYvYJ/rbPgosIxmm9D4RnNxJPD/R2xK3QHX8YqGmbE1/Dk9EGP42gzJDGXNToSVtA5E8kInTKB71VN5ylEK8wt+jjhlF5w6oZqRta+xxJOaKaIV4QwTCXV+spukfWGL7KqyrO0L9s4/NV9S1V690B6xXq0WFxG3zIDnJTHU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713236519; c=relaxed/simple;
	bh=B49CY9HTrsK21LGb1aCJB5lHqIGFmUyzZPoAp7EbYLw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=EsmNzql7KKqJPof0muVEqg0du+W+7j4YdxlN+x5rX8ELsQbarfOwPERRzsF3Hnn6s0KmBj1VtjGi4xD+iQpitXQbzbsvGntoEAq1A4fW6g/Zr6HObTTgIaP96KOP7hFlOZzZ3sK4yHhSCd+CUOBIi1Z82q1iATs8OdMri+pgqIE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZAai8Zfc; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713236518; x=1744772518;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=B49CY9HTrsK21LGb1aCJB5lHqIGFmUyzZPoAp7EbYLw=;
  b=ZAai8ZfcCuquu2xulbIh8tmfrPy+vzU0k+oxnunAnWdWoQpAi+XWmRjM
   mKnFxcB/+gRGyZ4VZYOK48p1H+XOizsMrMWlp7KZBZzVsg6qx1dpin/pa
   r+OgMvtA9pGSmZ6OmJEeRBV/wZnlPSJzpckUHiHnEldOMuzeqfI23+afT
   CqrlqRCr+8nUynltTlil/cP6CMHEuta7WZ7DSbHeOaQDJNf0HWr2g3FWl
   inGZSe4J3tWUumRZYUvv5eAeH49C9aQskIN7AsMS7D31dJNQbmLpyP3kc
   pm+yRXNXkLeEANKiPEv+T4bcJYBvi0THE6vfLtZO9lIy1L/DztIHydWs6
   w==;
X-CSE-ConnectionGUID: 6lWQaAW9QZCWehxG7ogDHA==
X-CSE-MsgGUID: zjGLSfl+QUyg5bY1IJ6/nw==
X-IronPort-AV: E=McAfee;i="6600,9927,11045"; a="8514704"
X-IronPort-AV: E=Sophos;i="6.07,204,1708416000"; 
   d="scan'208";a="8514704"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2024 20:01:57 -0700
X-CSE-ConnectionGUID: xpxO9N0JRsulvJL8bEE4OQ==
X-CSE-MsgGUID: itHBM+DxSIqTRRqFpE/VWw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,204,1708416000"; 
   d="scan'208";a="22011421"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa010.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 15 Apr 2024 20:01:57 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 15 Apr 2024 20:01:56 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 15 Apr 2024 20:01:55 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 15 Apr 2024 20:01:55 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.173)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 15 Apr 2024 20:01:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dqdi2C2Q38lS5r6mIEL2s8msqHUyGQmpRwaO0A2hd0JvSYl6VlW+OPKq33zoldT3TZw8M0o7OUiBrCHSI8CyDvcx4Yov9+bC+5KZF65HrLkHHxVnc01ygZxRpvRa60dpd+4dW6FVmKcDq7YmjwKlDyOkQPOS7pG28NvVKexL0m6KttQ4KfkyBu95Zj1jK/nbt36opxdmRfgZPY7HYpH3gkA5ltH9Yt/MIsGADTHALmX5x16fplN5HUMsiBSbRKeXxPPjx1EraFTaIuZsgM0UbMw+Wf1CQ3bsxsMbnI7yDRAwRV86CqoRF0BOigRSiefatGlLLMVdUqXGUgr+v9Z7Vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Cw935YVg3kmyqjQ7w2eKnD/UcyFDKB9CwCil26TReHg=;
 b=lq31sXrhsn1VYUhyckHxNZij0h/5el/0asFFtgEwYyi3NcGrPxUfIb3B4IzIfzlf2w9/sO2XMhEfCg61swcY4D3/iS89D938jUS5cjXEBGGBkHKa7tzd2FJP3AmU5urqY6ttZ2R+sC+7juPHf14VMIUEL7Q6dpDkvRb4SeBgWINJ+vJbumZBd6917Cfe3cuNP8zIwSJTJWamO1zjL4BOxYd8zS9jApZ4yWwYonICfl3NIKfYCzkVkVY5LGO8Urd/ygIAS7n5OYwUTbOnQB1u5zPbKlG8PfIlINmn91zoCVVY+4XkECgOr9n/9ltbXagHL5JX/WLAOlJhkOvCL54UyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ0PR11MB6744.namprd11.prod.outlook.com (2603:10b6:a03:47d::10)
 by MW3PR11MB4684.namprd11.prod.outlook.com (2603:10b6:303:5d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.31; Tue, 16 Apr
 2024 03:01:53 +0000
Received: from SJ0PR11MB6744.namprd11.prod.outlook.com
 ([fe80::e4a3:76ce:879:9129]) by SJ0PR11MB6744.namprd11.prod.outlook.com
 ([fe80::e4a3:76ce:879:9129%7]) with mapi id 15.20.7472.025; Tue, 16 Apr 2024
 03:01:53 +0000
From: "Duan, Zhenzhong" <zhenzhong.duan@intel.com>
To: "Liu, Yi L" <yi.l.liu@intel.com>, "joro@8bytes.org" <joro@8bytes.org>,
	"jgg@nvidia.com" <jgg@nvidia.com>, "Tian, Kevin" <kevin.tian@intel.com>,
	"baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>
CC: "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"robin.murphy@arm.com" <robin.murphy@arm.com>, "eric.auger@redhat.com"
	<eric.auger@redhat.com>, "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "chao.p.peng@linux.intel.com"
	<chao.p.peng@linux.intel.com>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, "Pan, Jacob jun" <jacob.jun.pan@intel.com>
Subject: RE: [PATCH v2 02/12] iommu: Introduce a replace API for device pasid
Thread-Topic: [PATCH v2 02/12] iommu: Introduce a replace API for device pasid
Thread-Index: AQHajLGe23RdtTHUVE2u86ROjcLqW7FqOmRA
Date: Tue, 16 Apr 2024 03:01:53 +0000
Message-ID: <SJ0PR11MB6744EE4A01AE1FA71DDDB1C792082@SJ0PR11MB6744.namprd11.prod.outlook.com>
References: <20240412081516.31168-1-yi.l.liu@intel.com>
 <20240412081516.31168-3-yi.l.liu@intel.com>
In-Reply-To: <20240412081516.31168-3-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR11MB6744:EE_|MW3PR11MB4684:EE_
x-ms-office365-filtering-correlation-id: 1d383c82-61f8-450e-43a7-08dc5dc191b4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: aaDPV6TuqV08yjDKMEkj5LgxjsyZ7915Kp36zlUrABbqt4NBs5t96CH76A+yxTpyCM5vfUY70QAXL79/pG6pRzUXigQBbLftFfHNh2X4zYO3luLWDZs9Nk35sYsJ127iSXb8Ai2iJzBd2NRALl6qhhm10Q+dppL0iDB1ANGWLC3T398z6qgwO2H/6hFbXxjLoMRX+UgSsiyU9y4d14WysU9Un2m8sAC7ZJNIbpYrxbo0Gpe8Xd4AKNfOI3p7QCXuM7lOgluqyE1G5SDUAGhsG3h4EVIV7h9KToAGqGEsMbBqexBgfSZoKhhLKYdeM1DImA0YgJabR3LbXn6s6bKBwjlP76pxCHLuwkc1cck6BvF6qujuH/U/QtUNZhg4GVjxxiVpbUb6ERJxLpxH3f7nQZGGAxez1Adnj21OgfWJkxMtwCvYtGgDLKsvm9DZ3j0mTHjwX51Kz1AlAa88L9vqf8Zy8Ssyrq052MmQ7bkTju9XVo0tq4hegD9mDRh/qrCga4Wofo/xSUrRiDXuFElF38AzMGpkq4BJxJ2b+ZALRcxZVvH5LCMWFJlxTE3CDgccFvUPgQKFt2KG/oiwuIV/mzUM5Fgvo2JjeKHTzARnpriJAJDemrg9M33/oXpk0+6itSoguVdt0fC210c/XP0z6b9/IHiXXTxdE54qObBr7U2Y70VyQq+VrqsqzWd0mS2hIXKQx66uGMadunlqOux8ecgEbDYKbvmh7QEsW/kPksk=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB6744.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(7416005)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?H2OLvdTM9dCNaXxU3bvRrhZo1WXyuuPtBv7BD3LLo6D22HR6e05MaJpMT7Y/?=
 =?us-ascii?Q?wGaorazLBYKZeQbwj69YyzKzbpiJmSzC9Dfpps87whtTqzft9Xx7yj2/uxim?=
 =?us-ascii?Q?XWgCvuV4tgS1b+x5KlPBXxdvPfcwITr2/He31nG+2kC5B11h3hzBFsUvgfGb?=
 =?us-ascii?Q?ZYchXTH8mVulv6nSZgk/odXEIOnfRxF7iWkevYUE+F+r4T2PAes/gJGdMADh?=
 =?us-ascii?Q?+XBNQBl808v8TuOvEj/BR2r55E1En0pcPmcSolP/jogRDn/oLb4ZCfSIZQxF?=
 =?us-ascii?Q?bTwgLMRo9x0cSLFdKluq/kCQxAmjCB/qCuFd/grKZdv/QiBOgTx/FNhVhTyr?=
 =?us-ascii?Q?FibsFUeoucpMNfFWy8u2RSxJ0F/PetQy/CleqPC+kfM5gQ4L6tKoNHxOtuV6?=
 =?us-ascii?Q?e+jg/70xzpY1vPaiuUFAI4TVIk+eQE793DDVbTaEkNZMwpahYBNW6eY4QU1/?=
 =?us-ascii?Q?XIHjd2ngjkVxYpawCEeOtisx/8EQewqzkUnSmL8/7zX6XT8ZqFnm4w5HNvxb?=
 =?us-ascii?Q?KXfMRfg5O3h6JZrjS62IXxO+6coTPJQIpOAVmZO16ISUD91NT+bteYRxe5k4?=
 =?us-ascii?Q?ffJX53j2DciwNSTT/0WJYfGdNf15xWw3pf+f90Mna7aNU2dfvs2q+T2PjZ4r?=
 =?us-ascii?Q?gv19EoPZua1piFHjph2G1+Oo4U0Wh1uWS28cqfwxKVhb+pzrroqsmJVxBBeh?=
 =?us-ascii?Q?+qKzEYRAeQo8Ygb0G4voNMvCIZ2NAvgUQCEbv4pqCo0weJQMT8PvJUp2Gfd1?=
 =?us-ascii?Q?PgjEIrPxbPYNjp70x+71bBqGUfFsLlY93tfzKmcdQdSi5w/X3jIYwCN6X2ww?=
 =?us-ascii?Q?Km4e6nYib3JKz+2UdT2eDDU64wPz3RTVnaJBEPPn9uDT1f9I+ofnmW9wkqAJ?=
 =?us-ascii?Q?E+hBZHON5CqsIV4Pz6q7zhSw3kzxiP1VZQFPJLJlyevSZCjx4AKGQRvSk1lE?=
 =?us-ascii?Q?2D8hM2fOshCkblD/lU9hvpYDA5KP0HMcb8qXV1651ZWSUaVMdmZ7jB+xxSl+?=
 =?us-ascii?Q?K9xRAdBD0csGBAX7nfcC+mvfp4b0ocNViS+fiMCnVfCdUuZGPefpeBusSo55?=
 =?us-ascii?Q?7qpWyqpdZsqHbSFrP5o5ABU7Asbz3fjjJubIfNfxdrTiFr3J826Ifd9AqrXJ?=
 =?us-ascii?Q?KtmX/ruOcAxDu8aFhvBMT2kEsSU5fxMbdh1ysF66J5MFTaCCrR/Wi6+/QdBG?=
 =?us-ascii?Q?7CDtg4DZsLXm5rCA6Dn3NsuMMWAFq/Tle74WktFZrIFzs+fK9PQBXrhqHa79?=
 =?us-ascii?Q?/NQyNLxDlH0h8FB/prUaFr8jHqy7YkCq8bx4x4vx1zU8yd1x4VVuhVUTptEM?=
 =?us-ascii?Q?XMKJTWPoTRNCQj/qDoNsxMxF0b4W5JrHWwpeucKcfPA7qgGRnOrfDc3YEYnI?=
 =?us-ascii?Q?u9FjBgX8L+xLWPnLEbPrNDVXK9cdpMrkbNm+OfRABlqj37sG2PPv61eVzAbW?=
 =?us-ascii?Q?jnotoEYEGB435sVl5yngB2YbqFfDux8DtRFtlz+oAYdwjCwRT/R3MbjcLVQv?=
 =?us-ascii?Q?9ChwIh/SpCVjQy9x1KVybGnS1z1rIGrlNYfSbOLG4MQAum30CycIIICzM05d?=
 =?us-ascii?Q?5AzqUlHJrxp867eCqBmQpUpKA9HSMvoHC8rhIiNb?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB6744.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d383c82-61f8-450e-43a7-08dc5dc191b4
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Apr 2024 03:01:53.4110
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wn78gtcZeC3VL54MkewyTOcxuf4Ktr/1TYlO/qHS46b7mLVKMmJY09dJYgbJPml2xklYM9SJL6JgWakU6X1Ito5zjwP5QF6/4uGqBhEINgI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4684
X-OriginatorOrg: intel.com



>-----Original Message-----
>From: Liu, Yi L <yi.l.liu@intel.com>
>Subject: [PATCH v2 02/12] iommu: Introduce a replace API for device pasid
>
>Provide a high-level API to allow replacements of one domain with
>another for specific pasid of a device. This is similar to
>iommu_group_replace_domain() and it is expected to be used only by
>IOMMUFD.
>
>Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
>Signed-off-by: Yi Liu <yi.l.liu@intel.com>
>---
> drivers/iommu/iommu-priv.h |  3 ++
> drivers/iommu/iommu.c      | 92
>+++++++++++++++++++++++++++++++++++---
> 2 files changed, 89 insertions(+), 6 deletions(-)
>
>diff --git a/drivers/iommu/iommu-priv.h b/drivers/iommu/iommu-priv.h
>index 5f731d994803..0949c02cee93 100644
>--- a/drivers/iommu/iommu-priv.h
>+++ b/drivers/iommu/iommu-priv.h
>@@ -20,6 +20,9 @@ static inline const struct iommu_ops
>*dev_iommu_ops(struct device *dev)
> int iommu_group_replace_domain(struct iommu_group *group,
> 			       struct iommu_domain *new_domain);
>
>+int iommu_replace_device_pasid(struct iommu_domain *domain,
>+			       struct device *dev, ioasid_t pasid);
>+
> int iommu_device_register_bus(struct iommu_device *iommu,
> 			      const struct iommu_ops *ops,
> 			      const struct bus_type *bus,
>diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
>index 701b02a118db..343683e646e0 100644
>--- a/drivers/iommu/iommu.c
>+++ b/drivers/iommu/iommu.c
>@@ -3315,14 +3315,15 @@ bool
>iommu_group_dma_owner_claimed(struct iommu_group *group)
> EXPORT_SYMBOL_GPL(iommu_group_dma_owner_claimed);
>
> static int __iommu_set_group_pasid(struct iommu_domain *domain,
>-				   struct iommu_group *group, ioasid_t pasid)
>+				   struct iommu_group *group, ioasid_t pasid,
>+				   struct iommu_domain *old)
> {
> 	struct group_device *device, *last_gdev;
> 	int ret;
>
> 	for_each_group_device(group, device) {
> 		ret =3D domain->ops->set_dev_pasid(domain, device->dev,
>-						 pasid, NULL);
>+						 pasid, old);
> 		if (ret)
> 			goto err_revert;
> 	}
>@@ -3332,11 +3333,34 @@ static int __iommu_set_group_pasid(struct
>iommu_domain *domain,
> err_revert:
> 	last_gdev =3D device;
> 	for_each_group_device(group, device) {
>-		const struct iommu_ops *ops =3D dev_iommu_ops(device-
>>dev);
>+		/*
>+		 * If no old domain, just undo all the devices/pasid that
>+		 * have attached to the new domain.
>+		 */
>+		if (!old) {
>+			const struct iommu_ops *ops =3D
>+						dev_iommu_ops(device->dev);
>+
>+			if (device =3D=3D last_gdev)

Maybe this check can be moved to beginning of the for loop,

>+				break;
>+			ops =3D dev_iommu_ops(device->dev);
>+			ops->remove_dev_pasid(device->dev, pasid, domain);
>+			continue;
>+		}
>
>-		if (device =3D=3D last_gdev)
>+		/*
>+		 * Rollback the devices/pasid that have attached to the new
>+		 * domain. And it is a driver bug to fail attaching with a
>+		 * previously good domain.
>+		 */
>+		if (device =3D=3D last_gdev) {

then this check can be removed.

>+			WARN_ON(old->ops->set_dev_pasid(old, device-
>>dev,
>+							pasid, NULL));

Is this call necessary? last_gdev is the first device failed.

Thanks
Zhenzhong

> 			break;
>-		ops->remove_dev_pasid(device->dev, pasid, domain);
>+		}
>+
>+		WARN_ON(old->ops->set_dev_pasid(old, device->dev,
>+						pasid, domain));
> 	}
> 	return ret;
> }
>@@ -3395,7 +3419,7 @@ int iommu_attach_device_pasid(struct
>iommu_domain *domain,
> 		goto out_unlock;
> 	}
>
>-	ret =3D __iommu_set_group_pasid(domain, group, pasid);
>+	ret =3D __iommu_set_group_pasid(domain, group, pasid, NULL);
> 	if (ret)
> 		xa_erase(&group->pasid_array, pasid);
> out_unlock:
>@@ -3404,6 +3428,62 @@ int iommu_attach_device_pasid(struct
>iommu_domain *domain,
> }
> EXPORT_SYMBOL_GPL(iommu_attach_device_pasid);
>
>+/**
>+ * iommu_replace_device_pasid - replace the domain that a pasid is
>attached to
>+ * @domain: new IOMMU domain to replace with
>+ * @dev: the physical device
>+ * @pasid: pasid that will be attached to the new domain
>+ *
>+ * This API allows the pasid to switch domains. Return 0 on success, or a=
n
>+ * error. The pasid will roll back to use the old domain if failure. The
>+ * caller could call iommu_detach_device_pasid() before free the old
>domain
>+ * in order to avoid use-after-free case.
>+ */
>+int iommu_replace_device_pasid(struct iommu_domain *domain,
>+			       struct device *dev, ioasid_t pasid)
>+{
>+	/* Caller must be a probed driver on dev */
>+	struct iommu_group *group =3D dev->iommu_group;
>+	void *curr;
>+	int ret;
>+
>+	if (!domain)
>+		return -EINVAL;
>+
>+	if (!domain->ops->set_dev_pasid)
>+		return -EOPNOTSUPP;
>+
>+	if (!group)
>+		return -ENODEV;
>+
>+	if (!dev_has_iommu(dev) || dev_iommu_ops(dev) !=3D domain-
>>owner)
>+		return -EINVAL;
>+
>+	mutex_lock(&group->mutex);
>+	curr =3D xa_store(&group->pasid_array, pasid, domain, GFP_KERNEL);
>+	if (!curr) {
>+		xa_erase(&group->pasid_array, pasid);
>+		ret =3D -EINVAL;
>+		goto out_unlock;
>+	}
>+
>+	ret =3D xa_err(curr);
>+	if (ret)
>+		goto out_unlock;
>+
>+	if (curr =3D=3D domain)
>+		goto out_unlock;
>+
>+	ret =3D __iommu_set_group_pasid(domain, group, pasid, curr);
>+	if (ret)
>+		WARN_ON(xa_err(xa_store(&group->pasid_array, pasid,
>+					curr, GFP_KERNEL)));
>+out_unlock:
>+	mutex_unlock(&group->mutex);
>+	return ret;
>+}
>+EXPORT_SYMBOL_NS_GPL(iommu_replace_device_pasid,
>IOMMUFD_INTERNAL);
>+
> /*
>  * iommu_detach_device_pasid() - Detach the domain from pasid of device
>  * @domain: the iommu domain.
>--
>2.34.1


