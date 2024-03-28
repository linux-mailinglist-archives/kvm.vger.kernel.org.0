Return-Path: <kvm+bounces-12948-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E9C288F5C5
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 04:15:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A20521F2B15D
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 03:15:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A5002D622;
	Thu, 28 Mar 2024 03:15:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WoyquWb9"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E187717984
	for <kvm@vger.kernel.org>; Thu, 28 Mar 2024 03:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711595725; cv=fail; b=Ja4+gjq1bddnSxooW6IIerFSy5iTVoOu+wcGmH2344Ojw/cpwhmYzJD++Hgg4ZC8B6/8AgrNVKfIbV58lHyIQ3QmVV34NLw4Fc8BWlzO+K/J/pV3lz2FrfAcmYw1c/CSCy4wRSOiICbVYWfS97jbSHGRWHWFJ46lOGKUM00+Kqo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711595725; c=relaxed/simple;
	bh=to5Ieszks1fIQYUPLG04/OZSV76RNVhGe+/D3xmtydQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=S+JwAK69693OZmN87bweg06G90K+jIMFgaN5mcKBPd2PvHAmYqG6vj+3bZI32h5c+Q37qt14w0PTLOt/QTN547XNSy2or9RGjL2HcBuZmpXwpGAiJAM4f40TvoHkDpzent6PsIIamkq8u4lGLlDeLQklzYlnwPLmaGr0OqLnOeg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WoyquWb9; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711595724; x=1743131724;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=to5Ieszks1fIQYUPLG04/OZSV76RNVhGe+/D3xmtydQ=;
  b=WoyquWb9Rba9s0JwPProdnH63uj1drQlgChhIDv5yyl2UmmpqOMnrcoe
   JKu+kuxebaeVC0TQuFGRaQf/dHi6x7PM9c2rChe0vzKNiyaS2BLBVOnRv
   Wgi8ypx+i1wSQYv9zDofywHk7vKL2vjKhPoYwF75lGDWiK2zwykPD9FTP
   +Tyiprgg5fgH2zY9uCqKbe8lgHm6oAu7hHMoKO3W/wi3lmeFcGyfLRvMZ
   vsnWL6BU662k7Dj+jg2Dt0CB45DWP4uui+kfcTLLG2aHiU+kzKpCCaiST
   V9aiXpG1sziTkw1Yj20iOMpN2oYGLcQ32lMqIM7wf4Am+YGw5WZiaLtjT
   g==;
X-CSE-ConnectionGUID: +6Hv9nZjSTaeMgj8Vl08mA==
X-CSE-MsgGUID: RPj28UWoQzuctvWQDjIRFw==
X-IronPort-AV: E=McAfee;i="6600,9927,11026"; a="24222969"
X-IronPort-AV: E=Sophos;i="6.07,160,1708416000"; 
   d="scan'208";a="24222969"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2024 20:15:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,160,1708416000"; 
   d="scan'208";a="17126045"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa008.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 27 Mar 2024 20:15:23 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 27 Mar 2024 20:15:22 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 27 Mar 2024 20:15:22 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 27 Mar 2024 20:15:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TG3wfvHNWwXRY2xMjkGpc954kB8xPX89UCd8HXF6Sd6HsHiRrOddtmDT9AznZkCDy5qpEXGhTBsiHYbVtIamgS32I+/yuRWP9n0LvIVHkUHqnLeROuVEXoWT8aMZSJQbIVyKVxIE9BHFQWhcK7n45DfhNyzSCzPMmzmUJDDRPZFsQiihcFdVCkI5G7JWRFa2wOHsGwxV5KxDYQN0RH/H3KGC/Lx8t4yFX9pfZBRRHj8oBbW5uDCCRY08GOzV3vpiodWh+HfIMQCLGbkIj3PAxcUCGmbO+qIzN8Xi5opLgcj1K3x3oN4lsb7HucbtO0UVMOwCbJD3EFtXZGW++mnMsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rtLShoaUgE5ksWh6CmvW+YLwyISD2TCk+2SRc4EF2NM=;
 b=PlP/76XPIBYrzmK6YMTBaQMS3da04MoWzsL22H6IuSkzsP4qDng09htZaAZ7SV7DCGEL2IM50EHXsaeINgtYRMVC2wb7HnTyJ1W0RwKKRAk50HgDl5UaEYXjdSNHVie4kXeH5cyUc4mJKpPNBachxpS0+AwckI70/8U7OLWzo7L5klslRhGNFWY8AdXtCEHSBWvPzN6qlqL1UteEIy6og86SBZvpIscEv144+satoihbr/d6JHJ05H3AvLQi1Ntb61s0Vb7tzUOOH4Rsr47Zz/cU65h1BMLb7RtWewJF6/Az9SFmv0yMOlPJsvAQmxy7KeaX4qxovz8gzHTspqgC+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.31; Thu, 28 Mar
 2024 03:15:16 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6c9f:86e:4b8e:8234]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6c9f:86e:4b8e:8234%6]) with mapi id 15.20.7409.031; Thu, 28 Mar 2024
 03:15:16 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: "Liu, Yi L" <yi.l.liu@intel.com>, "joro@8bytes.org" <joro@8bytes.org>,
	"jgg@nvidia.com" <jgg@nvidia.com>, "baolu.lu@linux.intel.com"
	<baolu.lu@linux.intel.com>
CC: "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"robin.murphy@arm.com" <robin.murphy@arm.com>, "eric.auger@redhat.com"
	<eric.auger@redhat.com>, "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "chao.p.peng@linux.intel.com"
	<chao.p.peng@linux.intel.com>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, "Duan, Zhenzhong" <zhenzhong.duan@intel.com>, "Pan,
 Jacob jun" <jacob.jun.pan@intel.com>
Subject: RE: [PATCH 2/2] iommu: Undo pasid attachment only for the devices
 that have succeeded
Thread-Topic: [PATCH 2/2] iommu: Undo pasid attachment only for the devices
 that have succeeded
Thread-Index: AQHagEXy3aCO/KVwh02+GYB0K+NzZ7FMe16A
Date: Thu, 28 Mar 2024 03:15:16 +0000
Message-ID: <BN9PR11MB5276AB09D5A9E183C3492AD18C3B2@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240327125433.248946-1-yi.l.liu@intel.com>
 <20240327125433.248946-3-yi.l.liu@intel.com>
In-Reply-To: <20240327125433.248946-3-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|DS0PR11MB7529:EE_
x-ms-office365-filtering-correlation-id: 4302e6a9-a2df-411f-bd9d-08dc4ed54aae
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZMJ3qVHh1Ag4cFLbuBwMPykZsWY+THcxRh2qHbAGG8LoUHbh1kiJWXxnuOdjbKQ0fE51WwztcUKMvK7kd0niAH/gxI/iPLGo/J32eGiE9Ylyx825rkUVv3PVNxwEfaHuhZN2jk9PA+UTxZTbScVc9VQod0L8KwiFjiX3+Mu0O7P2AZl+cCtlBBh350UM3MBrHjHs4e2pcNM7XB2uTsqy7zfOV0afFkENfgcA4A+ZI91MHKzYXFHajwpQt29jfbqz/k3yqiPn7jX3ivayS89EPJmyzqpHZ41/Zifo60I8AlBrKkVIKJPRC26cSQJx63ZZcGMfBEzi7huR6QI866Lvw5AvqBONcbulywugSatH/U5axXUR2TU63OcQ9FibncQHYNIpzFhu6dQmCXGID/MnPXxYedaDbKYaMXRZBgPQKc6NoekuqOHFx1yHSDoyIJkpbRDEoBMF7nH0+upyuB4DVNIXDx7hKYhu18e/nLHX8f1CGfTxRLr0nbvD+8YxuA7/DWqpGWe/mKK3gU2nIUSQzFtTvFONUtfGyeKZTLBTA47/DtE3p6loXuv5lp0/tavKblqUfXs9Kfk1zCXq5tgy+HaIGc8l63UC96OBAfQ8+g7RQTNqjpt8yKFpDPoZGOmBq45jo9jINlFenvtByG6l8JfwdG5PmlYVfxXy1EGwFx5hbG1Fc4dMpYK5G1V7Zzyh+QpSSgbfsXLfcgUKW6sZx7TsxwDV9+ZYNLcuWWOtoj4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(7416005)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?h82KZNmV7Ia3daqjrZWeYTA0FgEPH3RD7whDzI3Buj1Kto8+nheLcrhpzRlL?=
 =?us-ascii?Q?GVpy93udS91+Gd0KIEu/HKM6+2stqIlhAzWFMgSu96wZGq/RZGU66bVK9dY5?=
 =?us-ascii?Q?5W7aQYVLoCn20jqNq2ebipm9/G3bES7vdOpSgIuNFtord4JI6uhVlyCoeMvK?=
 =?us-ascii?Q?B0tlUS8Sn8drIP42IHH7xUWv31ekUh/OjSg0KCVGPBFpofvBriBCUv6TPC3R?=
 =?us-ascii?Q?XnMLXkbFxTPNvIetzhWGIQ/rDk3QTrPcm4ujx/yyRH7u3TAUbglhpXWdNUvO?=
 =?us-ascii?Q?L/oJkkLpWK0yMKmxtQOmLopqGcOWEcSQRRqjEwBkv5+BPN4l207kaDaa4RVM?=
 =?us-ascii?Q?LMNg88XvuLCK8y3R9xrGKnbDV3vV7M3a5Jy3vqeIRoZG8hIX6bf9T53dDzcV?=
 =?us-ascii?Q?okwCUUgXrittx/j/RIJRgA7OrWnLxhd0sE6NeOQeJ2vgCKNj9Dqv6KGPkBzD?=
 =?us-ascii?Q?iJWzI/lQ3YKI9e1FPPNlJ5JMh803MQCXMkwaK8TnKpyNG935633/KlUCyrzi?=
 =?us-ascii?Q?38v4uwRnUp9o1PP78pUwgwxQVbLor/gMw4+3pjTpJna33PmWfLmsbGUgoZgV?=
 =?us-ascii?Q?nkIaYRTMue0QMFQxiEFAUmhTMnYYn8FlRGKYQNyumn1rwbmtQTbfUehYxa1O?=
 =?us-ascii?Q?dGEjJB1zEYELHUgwGIUU4FLd4hTVpoHmPZJmPvaGNjFrjUFtJIrAQOyOSSs4?=
 =?us-ascii?Q?UZCJlIwzdElipHpJHivL3MvfVffp4p6+nnqCx9mhXg1MtwXDg5R6m2aqlRMB?=
 =?us-ascii?Q?IuA4WwnsD7NJOGdrvIQ2gKD4YCVrgp+bJ3pvawXTtH9+beTLPcxa16x6lIID?=
 =?us-ascii?Q?ZUe6mtWAnoYC/n/UU/b8+DjyM9bWUjBrAJhwfNOH7Zny6pXgWBmFX/isOCK9?=
 =?us-ascii?Q?ZjHFboh7NMJrRtENXqgr5xjCcSM/58jeerayNv5TB1ZdXXrrq5e6ccr8KtrO?=
 =?us-ascii?Q?RmNXJUc6hifR29cxOhPL6MiHih1WGVGzsS0S5HF70DVVZYGw24/lCVUCGvwB?=
 =?us-ascii?Q?jGbhhsH7K+7Y2ACEb8cXpkkorhnlkkmWfhcJpfQInCRZjql90tMcsGDGsZWm?=
 =?us-ascii?Q?hFQ6Zaf2VqQVGiv0M3anWANUsBdavfD3Kp0/FJiqN5d1n8p2UYYPhE6THPIS?=
 =?us-ascii?Q?HBT7s47JAEMmC0w5l/BMebbIAzRwRs9W9iO0vkniP3vgDPIHmeZSmn/S7Z1Q?=
 =?us-ascii?Q?yu7RRzPzI5nFRyA3shpjV3Q6Yt1JLTstEz+NZBVIsuMeMQ8wumAqDKgcXCZ4?=
 =?us-ascii?Q?uFqw3FEZ4omg1ncST29RZLVeX82EPA7L0RQ9B+alej/95EtRxm3vfpbBBOJS?=
 =?us-ascii?Q?YikS099H3DRdh5IJhQ++X0vU/ZPuxvyFo9kIxXFLfaHgbvvrje8Tv36cod1V?=
 =?us-ascii?Q?fXnPHSZet6nZnm8ehYsHvZ3lWp160gVB0CZQ/dVlANFwd+7LPtXYOeyzuXrD?=
 =?us-ascii?Q?GzcN78noCsa96bpp8SiL8TGVnjW/NYDnPB0rcnElaN/ADygHOnHYHM4uwYkD?=
 =?us-ascii?Q?CfFnFaCeDKNFZn5A7dW6gqtljSNUdtmVMnsNOyj++/I1bP+a+Oe4RWw0aYUz?=
 =?us-ascii?Q?2qHHCcj1Aalu9hUTZb5A7xiSDXNsXgTVlMbH8vx5?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4302e6a9-a2df-411f-bd9d-08dc4ed54aae
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Mar 2024 03:15:16.7206
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: m6eheSQ0Cx/gRXUgmvh+5diLn6Iau6aBCUwcKsjGCTt8Mpe7SAS+6PdnTbSnZ8APE+oFaIg7iHvt0OAYfL7kHw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7529
X-OriginatorOrg: intel.com

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Wednesday, March 27, 2024 8:55 PM
> +
> +err_revert:
> +	last_gdev =3D device;
> +	for_each_group_device(group, device) {
> +		if (device =3D=3D last_gdev)
> +			break;
> +		dev_iommu_ops(device->dev)->remove_dev_pasid(device-
> >dev,
> +							     pasid, domain);
> +	}

break the long line into:
	ops =3D dev_iommu_ops(device->dev);
	ops->remove_dev_pasid();

otherwise it looks good to me:

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

