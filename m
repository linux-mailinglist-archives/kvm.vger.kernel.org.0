Return-Path: <kvm+bounces-13044-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2202589118F
	for <lists+kvm@lfdr.de>; Fri, 29 Mar 2024 03:15:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 445FB1C2AD04
	for <lists+kvm@lfdr.de>; Fri, 29 Mar 2024 02:15:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A46D938FA1;
	Fri, 29 Mar 2024 02:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XDvPNXV+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B2D538DF1
	for <kvm@vger.kernel.org>; Fri, 29 Mar 2024 02:12:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711678350; cv=fail; b=MEIhfYl7cc169ZIhJMxKrqNwEXWsV3mePz9ra9F6RwnBVQJOnXoxy7K67+Zhi7kI6uOwOh2xZObrl9ODmZgJUyZtgamm2edaQphfT7R+0eQTaAy1tSI2CPkhmH7RrK5WJvawthLw1x0Ak8a/uEDm0Z56LuhhMIEo+bL54HObkWs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711678350; c=relaxed/simple;
	bh=j7thxr6ordAu6QxVyWwxXUWHuzPku+sVHb1FBgWql7s=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=faOrkY46FTjaQssQQCoEQp/M0IJBwP+FYpVCV6zBAUIxrXUNa7sBSTcER1jjpjKydA5H11EMcj/xL7EsY13e6uG9/nqlCWlivg2Crm5ubeTj3cE0IacK7DLRomsDJcTqwePK82rkr75IzKwcue4mG/wFBX01ejT408sNaCohgs8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XDvPNXV+; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711678350; x=1743214350;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=j7thxr6ordAu6QxVyWwxXUWHuzPku+sVHb1FBgWql7s=;
  b=XDvPNXV+MuYp5KK6g8X+7bjogUh8VftVJBVpm/NDdpT5sM6EU8sx7h5h
   Yg0xZfsP5+v0vpoTeaLHCWem15i3ztPqe/1UgpZLaTOhj6rrqER/v6nDe
   gIni4BNQu3dk9nFcT44k+VcN09Wkz3Z2liMS62U2pAHEZI6TmTiL8fEE9
   PgKaoJkFD1XKZxEhUPAiA1Zwz1CS80isTuiluRmUSs45Wbr0F662CJqjH
   pLn2AZb1njRuSYZXAL+0hhpl1zePX3DN/fB0992Aktdr1H7OzuBOnLSQ9
   o7/j4huT0yVxXE1ITDs3CQ34rmpnONYOBteg+ou8Wk4eREBJvIL5E4tI7
   w==;
X-CSE-ConnectionGUID: UFsJpaSzT7S6PZG/GzY5Ng==
X-CSE-MsgGUID: nypiwF0lSniHJDjRTUVezw==
X-IronPort-AV: E=McAfee;i="6600,9927,11027"; a="6991134"
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="6991134"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 19:12:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="21300100"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 28 Mar 2024 19:12:28 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 28 Mar 2024 19:12:27 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 28 Mar 2024 19:12:27 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 28 Mar 2024 19:12:27 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 28 Mar 2024 19:12:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mvcwq0fCq0WP5bcf8q22QlTmtDBVO/kwZH1RlLCEJWurowPD6Zb3t52THasLT7sR0ygcT1Z/b5s2zNqVeo17v/ocw+axy/JgKCl3MvBCvf4D8qE3Y4Oj7hN1MQDtfMpEF2PoalYjlIhXAnxpZZZZ0LzCroqeTn56hVS3x4xVYNvTlwil2P/r6lt0zsis4lX8QKRhiBi/xN3ZNH/pR+UDBw/+gSrzbrGm3yyv3Wj30rWQK/M5Rxa6kEdZU9X249mNIddau87TubZ/772bD+869UuAo0fJbusnZRLwtVjoavj814sVSKrELQZ4bm9UIN68HcacoPXz+u4Ae7DPV+5E0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=783hB3ZHuSj37Gghubh9ex1x3cLBv3efLV2dpUvjtro=;
 b=ZnMjEJ18hlG1UPVZIbLa7VjBEoEXod69el6G9osKINrgfx9pug5KvCyajI4k4F7W6s3om9Bo2ARkx44KKL9gTk0DlpD3ZKjAZT2AQAgKNKUte/BS/n2If1TaRoaAAaoY6bnDBQEJJAJHg9RQ0EZOS2K1Od+IeXSs23J5jhlX+J8jjhnicVOYwe4xpOeANEhuBOprs2LD1hopm5Pklmqfe0IawXzx9m5582FdBdlpWPDfcA0uCe6JYoT4yw0BHsh9zMs47X0fRCOCWvLrKfRoEhDoFsKWpPh12HSetqZeUDBx+95ku9NLwv5wmR7gkc9CkZcG86ZR6oh12IEWo655Ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ0PR11MB6744.namprd11.prod.outlook.com (2603:10b6:a03:47d::10)
 by SJ0PR11MB6742.namprd11.prod.outlook.com (2603:10b6:a03:47b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.33; Fri, 29 Mar
 2024 02:12:25 +0000
Received: from SJ0PR11MB6744.namprd11.prod.outlook.com
 ([fe80::e4a3:76ce:879:9129]) by SJ0PR11MB6744.namprd11.prod.outlook.com
 ([fe80::e4a3:76ce:879:9129%7]) with mapi id 15.20.7409.031; Fri, 29 Mar 2024
 02:12:25 +0000
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
Subject: RE: [PATCH v2 0/2] Two enhancements to
 iommu_at[de]tach_device_pasid()
Thread-Topic: [PATCH v2 0/2] Two enhancements to
 iommu_at[de]tach_device_pasid()
Thread-Index: AQHagQuswU7tTG/G0USa/UYOZse2O7FN+kcA
Date: Fri, 29 Mar 2024 02:12:25 +0000
Message-ID: <SJ0PR11MB674441C2652047C02276FC25923A2@SJ0PR11MB6744.namprd11.prod.outlook.com>
References: <20240328122958.83332-1-yi.l.liu@intel.com>
In-Reply-To: <20240328122958.83332-1-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR11MB6744:EE_|SJ0PR11MB6742:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2yZ9XgpTnm0UlCTiLygxXHv/r7N80ZcfI0MW/Qaxn8o2irYwrGm75mYMWy3KojkthU7MY4X/Z7ecGkDGTWyWQdDnfixvvy69YERf4rp2buMM1ABEahhozGPNUAzDXVpYxicrDZVJiC7meZzkxxj9/ryBlbZk2pJ+gXDzXT7FbJ1VvxZRuJGMnsFSADKbWgUowZhhdQ420gx79yENqgVnghmGTYnEoh8zZuW81mFYzoIHuK1nzQQ5EuVJztRLHk9Ed73DwyjtASDjyR2LL+Acf2G6Pb+a2PtUitK4HrLSdTbfKsJkQsFhVyy4dCWR6bwEPSSff1+OB6NJj+u7rfdbRLT+9Y2Z7iAIn1qDpCXsMWO8w5cZkWamJFi56hxJQgQ2H/TlmWaTcRLy6SX46SJrGsUnyb7NgPlaFpJelQ4PDdKYFfO1dLluNBGFSvrAMQeq4qW4PtjH9fLqnVBKhslYMy+46EfU0emGSO7/oW+wp16Tf+aOet4fHIZLwkl1/nW9zboQlpGrrY2y8B27pXFzo9bn7SVnZ8rWJfNv4yepCB58ptJcru+si1rRyZk3gVbPcZ7B7f/qjh9EraUJH4LOETl7mqUCQ48p5y8EmUDWa2ieMsnTmuJgJ+4oI1/PE83J
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB6744.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(7416005)(1800799015)(376005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?7d1ATn4YLoKT0pr+etMtyMDuXhVqcesksasJiTfne8yNh6iWf6zllq6vES2H?=
 =?us-ascii?Q?1VYg2Ea2oEer0u6dZncpQnK6e35dRB7RtbU9IdI48iM1nYVZYP2ND4D+Wg+e?=
 =?us-ascii?Q?YfORIggXOA0+mniBmz8VQ/mXYU4Sh6Ckx5T0pFBG11tVOJISO3s5SF8dHWCs?=
 =?us-ascii?Q?iSzHQ3vdsU7cfZv60l2cJ2K31b+iVHI+xm3jlkaBuaDiB66MkDc1Fmt1J2X9?=
 =?us-ascii?Q?JSI7Vy1C0uq/wch9B1G4yGbiPiNlzVVyUiggBLiRTTNo0x0vUb+ghgzXwn0s?=
 =?us-ascii?Q?Rimc7h6hLDuys/4bQe7XyLwLXog6wXj9qkilkxHYeumCWC3Gj6iod2PzDXho?=
 =?us-ascii?Q?Fnrw3XKh58v9oRNK7ehm2HiHIQO5CtISnqLVGqEh5cJ7GnNxmj67QoKu9f3G?=
 =?us-ascii?Q?sr4L45ci5/+5tPk9HYggzFVCchPgSv6wyQHWLTYWkcD9Ga3C+e8050fa8Ivq?=
 =?us-ascii?Q?A2otZt2lodpy9RofeyKB23onTV0NYJNgHupV0n+taRtvujpvtwipMT4xgXN5?=
 =?us-ascii?Q?fjR67+7HSbEFZ9zSdryanpP5MypzfkFYRXx7cis0IDeiJYTz+pfY8LRnnnrZ?=
 =?us-ascii?Q?+vXumy9CAHYywnLF63wyuV4MZHsDte0xFpR3kDvNhGD5ivcbaCQu2D+WmBzR?=
 =?us-ascii?Q?nC5qtxtFp8sZbFdEhs+UjL0wktO1VB2IRGSDJtQUH86ViGlDNd/9uS5wc6fd?=
 =?us-ascii?Q?OTDM1+QVnM3r1WRGKcLQdQA4JErq/g03/0p575muQ54yJb3F2aUxFHhAXKUm?=
 =?us-ascii?Q?SUrMwBEHhpUiqH/ZtIaM6oNi7jGCBq4Sl5RAT2cnH1TW0NbrN93pCYWg6n2g?=
 =?us-ascii?Q?a+3FnFbuNg9aNE8lGS6QSCkMoaz9zb1Ivx0R80PdtVae2SxHH2UlKH6lJiY6?=
 =?us-ascii?Q?/brjNZt1bRaLoxXKWUWF3iZ8f/BjGJftnzi+qywXjc4cBrmsZXOGPX608klK?=
 =?us-ascii?Q?Nkcy+em2ZTdX34Fd4wViDxjl522TziiAkpDHFJzAHde2jK+MdpThG5uQkmtp?=
 =?us-ascii?Q?A885a5W15nH65YAllWujRHV9m7eR8Mfu9iInlp/MnI0gTMI7qJsXoAE3e6TI?=
 =?us-ascii?Q?k3jBGcdJto2c6zTGaigfGuWB6+GGhBoXGkuru3LgDiDCsTVOXzHtyRo9lvG4?=
 =?us-ascii?Q?zNOI+p4SP0PFmg8AAdCDVqP6iKa6jSvazu7D/tDmhNWDbec46YmeFMtU4seY?=
 =?us-ascii?Q?pVr8X8tDrccQKQAQEHu6SFYeTIJMngGzHlnlBTcfM/zYtJX9oEzeQWQ0KR3+?=
 =?us-ascii?Q?cp5ItTba9lh1OKEqHWRlZpufIi2eIsMxOq9S9HGyUIY0S39+22eDVjPZBlzC?=
 =?us-ascii?Q?XbUS6EIDgNWUqxQbWqTMRCzH+aFY6iUchfaTeV6K8DIREXzhBo9doUtomaP/?=
 =?us-ascii?Q?vZ7QIbT3hVUSVAfBfLklNZmrcdKx8gbM7bwRnIBWMYZD3DXXHtiMXwRlHcuA?=
 =?us-ascii?Q?MkH1K+UEUYTOeJlajNrvPb+HKfBAJNbpROTrjNFPddYkk6DrhYl4U7gK7pQs?=
 =?us-ascii?Q?H57S133UjQqpzN5Yt6q5NUWzYl157BgKIq79KEG/FcEArJWrez6TZof46OKh?=
 =?us-ascii?Q?YLKRzEL+MbeDe0DGDgHr5kCzeE6hVTz4STb7JrIx?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: e8f41a80-9100-4307-c2f7-08dc4f95ad1d
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Mar 2024 02:12:25.2641
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gBW7uvaBhAK3Vh5VkfTqq4IEmhLCRIEfnm7HIUxiBmDaaw0STbpc0+lkkxpElhg6MLhKizM4t3TDs7jdGRZgF60Hi/WoUurXuqFvXq6s8CY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB6742
X-OriginatorOrg: intel.com



>-----Original Message-----
>From: Liu, Yi L <yi.l.liu@intel.com>
>Subject: [PATCH v2 0/2] Two enhancements to
>iommu_at[de]tach_device_pasid()
>
>There are minor mistakes in the iommu set_dev_pasid() and
>remove_dev_pasid()
>paths. The set_dev_pasid() path updates the group->pasid_array first, and
>then call into remove_dev_pasid() in error handling when there are devices
>within the group that failed to set_dev_pasid.

Not related to this patch, just curious in which cases some of the devices
In same group failed to set_dev_pasid while others succeed?

Thanks
Zhenzhong

> The remove_dev_pasid()
>callbacks of the underlying iommu drivers get the domain for pasid from th=
e
>group->pasid_array. So the remove_dev_pasid() callback may get a wrong
>domain
>in the set_dev_pasid() path. [1] Even if the group is singleton, the exist=
ing
>code logic would have unnecessary warnings in the error handling of the
>set_dev_pasid() path. e.g. intel iommu driver.
>
>The above issue can be fixed by improving the error handling in the
>set_dev_pasid() path. Also, this reminds that it is not reliable for the
>underlying iommu driver callback to get the domain from group-
>>pasid_array.
>So, the second patch of this series passes the domain to remove_dev_pasid
>op.
>
>[1] https://lore.kernel.org/linux-
>iommu/20240320123803.GD159172@nvidia.com/
>
>Change log:
>
>v2:
> - Make clear that the patch 1/2 of v1 does not fix the problem (Kevin)
> - Swap the order of patch 1/2 and 2/2 of v1. In this new series, patch 1/=
2
>   fixes the real issue, patch 2/2 is to avoid potential issue in the futu=
re.
>
>v1: https://lore.kernel.org/linux-iommu/20240327125433.248946-1-
>yi.l.liu@intel.com/
>
>Regards,
>	Yi Liu
>
>Yi Liu (2):
>  iommu: Undo pasid attachment only for the devices that have succeeded
>  iommu: Pass domain to remove_dev_pasid() op
>
> drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c |  9 ++-----
> drivers/iommu/intel/iommu.c                 | 11 +++-----
> drivers/iommu/iommu.c                       | 28 ++++++++++++++-------
> include/linux/iommu.h                       |  3 ++-
> 4 files changed, 26 insertions(+), 25 deletions(-)
>
>--
>2.34.1


