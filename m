Return-Path: <kvm+bounces-14942-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E1C7C8A7E8B
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 10:44:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4C0151F22597
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 08:44:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18F7012AAF7;
	Wed, 17 Apr 2024 08:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JxqjjCs0"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C8E6127B57
	for <kvm@vger.kernel.org>; Wed, 17 Apr 2024 08:44:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713343459; cv=fail; b=awQqcIdXvB4/oq25SKxp+MSoMSqmi2Yp4sfVwZvTijwdyy4nT4M/tXxjRilcZuPI1wQZiGbdL2ninf8LBavzrosgWsOfcILH9wt/37IL24XklgBYoRVjAcU9M7eEn7zKCw/0yB/0HvXXdEf1r49tnidtFg2ssDk2xB3gQBwBlYQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713343459; c=relaxed/simple;
	bh=nkDUoFg1hwJ/2pJvUOi9UQOF4ADkBJLJGYQoStSON2Y=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=fHHuEvhFQQo4iw7Q2TFAXUZYV5DCdgBdK4wMxvSHQ9fH8oRwsDg50Br/5poXssjyEQJiCVHlhJtOp99J8Za/cnvHV1ydGmvKt+Stigq1AXbcJeIUuOdIUkErybVr3BOuZbfZJZb5IgHnYp00eOZgM1c8ZSmnk4NYlciB+iDNrwM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JxqjjCs0; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713343456; x=1744879456;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=nkDUoFg1hwJ/2pJvUOi9UQOF4ADkBJLJGYQoStSON2Y=;
  b=JxqjjCs0Cyhkq0hhInTdegmIHn9VEWOFjoHgESrZifrLWlxDKkNdXO3G
   niMFIi9OdnguaOsT2DvxscM76X2pZCUlbOAvtTUWU7b6fBsWJWjjR8MD2
   lST1o22xE9iODizxHtXK1JYLF1iMj28OSYmJuIUDSo3mrygdHs2vlURQF
   a+PxLXpLf/4ZBq3QpkvSrNH8NAtIAUMrWEEgLZwGfjVx7PXjLln+LHUlV
   mZnPxP/3TZzdQW7oqSVawS6Bd99LzvacyXSf0+2rCgmmaFcibEPbHzsoK
   +3zNgfSlNnU0EphsnGmi64jyjXbH+eOCxK088xP8fSbO7YxR4KeBXBLlU
   A==;
X-CSE-ConnectionGUID: yhIHmOJDRBagxSh4umecgA==
X-CSE-MsgGUID: q8O+yuAhRqeBI/ThSHudZw==
X-IronPort-AV: E=McAfee;i="6600,9927,11046"; a="9042669"
X-IronPort-AV: E=Sophos;i="6.07,208,1708416000"; 
   d="scan'208";a="9042669"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2024 01:44:15 -0700
X-CSE-ConnectionGUID: /8Bq1JRtRg+Z6b8sNb2QqQ==
X-CSE-MsgGUID: 9/qGm5+RS5Kik+bydRuvow==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,208,1708416000"; 
   d="scan'208";a="27199576"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa004.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 17 Apr 2024 01:44:15 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 17 Apr 2024 01:44:14 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 17 Apr 2024 01:44:14 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 17 Apr 2024 01:44:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AyET4WDJ63fRgh2VndL2D8YbZtHZpTbvgh+rn1GtDL8dZAd/fa3FlKWKMgP6E5YL6sgoLemi5Rs1zmCaRbfReQ7HuY3TXjlTeDCPUobOyyg5TBSKBTwbBXQQyTSVzqdgQ78gaxaKLZMKafh9ddXPIQHEeCEAth/de+SPZ9KqUkozQvaRl4bHL9EfoCO7tD/rLTn37S24+rdj4NgtGZEdNoTXVRImwYVxr1o3sCfP4EI8vQziCgjS/5boUAXTG3KYy+TOSlgwVwdFVRxl1pWujaw+6+qctqwXYCz6Rus7LPW1XC4kfdIwhyTZk7/zZvdx9PdmXdo5Zj2FS8CfhNYg6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6qqGWZx+nG/EkZJEABPcZ2ZMjtWkb9leQ+ZGgYGF7Ds=;
 b=eT+gmx23hZX71VWQvxfMFIJtKL432YU4VF+T/P5OJ1+gPPkNgVA+3U/n89USsW4k8hbl3Fz7eHpwgEKV/VK2uYti01Y3mRWpJQdATCtj8rlx3XqtoGpyh2PbNo2M7tPks9JGE/k/BERMWi0W2RrMffSr8YVuDcMGK0UaWxPf9qExyz22GgpzfQ073DYa6o0jhIjSaL2cfBlkQj7mfEi6N3qkgjjF1ZYhgeEoymw/miAM707gjZIUzORPzw73TGhxuzb7SeFMKMG7QjJXU32cAxZJUYxJswUantX/lzHIdxjxhc8dC9bTO/Skgb71dYYGOHupFBjw9hfKfrTrYM6U+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SN7PR11MB7640.namprd11.prod.outlook.com (2603:10b6:806:341::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.28; Wed, 17 Apr
 2024 08:44:12 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6c9f:86e:4b8e:8234]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6c9f:86e:4b8e:8234%6]) with mapi id 15.20.7472.027; Wed, 17 Apr 2024
 08:44:11 +0000
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
Subject: RE: [PATCH v2 02/12] iommu: Introduce a replace API for device pasid
Thread-Topic: [PATCH v2 02/12] iommu: Introduce a replace API for device pasid
Thread-Index: AQHajLGe8MAFYy5tuku4PxjcbkG1+LFsKHTA
Date: Wed, 17 Apr 2024 08:44:11 +0000
Message-ID: <BN9PR11MB52761DF58AE1C9AAD4C3A46E8C0F2@BN9PR11MB5276.namprd11.prod.outlook.com>
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
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SN7PR11MB7640:EE_
x-ms-office365-filtering-correlation-id: 8b106520-049f-4c47-7445-08dc5eba8dfd
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YnpZJl7u/emU3JgvKA6fvr1HYGykNx963zwBGwlT9pf/S5hKBv2XaKlmi+P94VVW38ZclkNGPJPze4qR0a+K8a2IRWEP/TkAhmEC5lOF/ljkeDF6zlR5GFWNNH3gKjvXS14kgsr3fMbOWfLRzZAJoxH0CUm7TSoIHBVqTSEokmN20bDPz1VeDU0aW+Y53PagxwLITR8bZcOSDypzNSgB/xNSshNkIBw5Ti2M1MqI1TF3Rdrf9+6ghVOsa4M5bk4zdzZ7VangRjlaiuanNr7Cm7fYe1U9IgTSZSAIbzTHL3LlZ6GULKZKRVAd4QLyGw6cIJQbscQVVaIMlvGBY164cxSlRqWgP2NqYY7Zha9L/71gXjXksYDfaadgsZpi4sZVF9y+k3/ncMG3Sl38KoOkmYbwbKGeeG9tDTCsnK54XbTumsYZcQqERb49DHubJjGKiwMPkwtQthYRZYsEfICSmoEHfz01lUnVGpMYdiR3gwg+TpJy8EiKV97saAS3UUyuW6Cd0zoHdkswdT/sZNwUq2tiiyKgZdgMvgVkBV7gI7O5HkQd0h3kyggggiA+JEb1+dNJq5szZ8TNF5peGLIH4Ydc/Z8sQabp4WK8gJBDFi/c4OyqIfBlo+1j3Zq+jOai0Zr2q9Jv3GNsIMEvVAC8vR0hQ51EGdDNXWgeobhJDmIIlqjwERFxrFdPuLUQw391eirgSE3IgtNzrqcPc53Trf1hoXzArn/t21Hjvq76gHU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(7416005)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?tHbbSfdi8reZBk7GnRi2TZz6GajlQ+ziIo1hnfXPS8eLA5+VFczbyOKhBFLw?=
 =?us-ascii?Q?dgOKH/emoNvSHE/x+fXtXrPMj7/HtWMkGL4azkuSMB/b0pc6iCjNYDmAdwaW?=
 =?us-ascii?Q?/8i/COivonKwIvXJUwn+Em2qS2tFV5wnGeUz0jeJ9pKXQwdY3tIR1Z2kuT9z?=
 =?us-ascii?Q?Ne8hgBlNi8uJgT92+v1hrR5bEkB8unoIWKzemuJk10tQ3J3slfb8c8TbhFAt?=
 =?us-ascii?Q?2mhZ2WD4asJSGb6BCnYbIg1Hm9MCyPPW0TdB70WOBEmVxnIpKBJJJaHfsIQu?=
 =?us-ascii?Q?DceQV5p5WWjg4l4rRXTn+7U7EayERFQSnkc2OabPbCV8HOtOgddmi642vJfp?=
 =?us-ascii?Q?8uNfYAZ+oaxYNA7CsewV1SNSo9CglYXXEI0zgxnl9T5+KwhUFrev/ntfnCzX?=
 =?us-ascii?Q?4JuIHJG3FX7MpMRry+3s51o9UrBmCm+lc6x4hJs3L9Gd5A87Q1V3CEMQPh0D?=
 =?us-ascii?Q?gwhLeVkhep4NysKjRhIX7Vkn6w+S+o3GhdcwB+tbMS0XAngdgj9xoIKd/cfo?=
 =?us-ascii?Q?0s6JkB1+i4KfFN9bNT3HNq6RPc5K+HRwWU5W0Mz8Zb2/8LZ9YYmGqOD5nOdM?=
 =?us-ascii?Q?h6zsXTwaHsUVh/la0znYt3djaV+FCh/YvVvfZfjWvkKRhb+YdJnUmoFwZkli?=
 =?us-ascii?Q?D74tWeCWlblL8w2lm64SQSnOSpG0hW0C/3LGbJ5w9Y0n7u8sAys8YbnCIcyQ?=
 =?us-ascii?Q?PhSvdaeWAOITxuYIupb0O7sbEz8QLpwUpIaobjrebzfly4FYe92zwlZbkBnZ?=
 =?us-ascii?Q?NBsO9D1lVyYttDcLhh68hqRsYhNu5gxaCgUzd2JQtjbnB1Msg8BiX2p/0CLo?=
 =?us-ascii?Q?fw6QH7Q+wiz3ya9+BMJkMqyPfl8ds06TVErQjtsFtOHLdZ5A6Y5SGNQMrPO6?=
 =?us-ascii?Q?yLplrRRwL0ZqrUjId1jku/mTVw/Im4aGKuAwIxmdixo/kNLd4bSzCO6REnL5?=
 =?us-ascii?Q?35vBY07eKkjMxnTMKZV7wl/h7VszTb3x7Agd8t83D5ZoMcU81fmYnZy30IXX?=
 =?us-ascii?Q?95EmfPbfsepmfHkX1ObW/W2gLm5L68vLnziDNkhvSqPUC+tJFGvnP9qud3hH?=
 =?us-ascii?Q?ApL/BmsxEUjtLAf3lb4XebvNp9vWKjTbINTyivm/+E5pyTC47+251srzwuQU?=
 =?us-ascii?Q?7fziMl9yaXX8Drad9cO+WpWVp4pipVxINkPC23PxTtdAZBo6YgrpqruzopYA?=
 =?us-ascii?Q?cXPova2KXtBG2jObIwDX1q1k9CcGM48vAqxYN1focSl2lVRvqTo3MrQC8mdu?=
 =?us-ascii?Q?ssJSWMF+IRoSzYe38CpM5s6pHHYB8gyUonFc7NSuY2VAO/do8xF0wnzby2Jl?=
 =?us-ascii?Q?vRFVXkC17ZnoU1kTi2i6LNWXWgymByuhK27T46PXBLoxQQR/dEb2aXp4UzT5?=
 =?us-ascii?Q?HHJAeiqTtf69k+7s8DeQosZy1QwEu7swpyPUrFb2ITBLPkmePDO/6DFbmnmu?=
 =?us-ascii?Q?eZzUF8AMySIol5SmwXMzXCHBrgkPRDlPiZQ0zr17RA80UncCvcNRHndyoSnq?=
 =?us-ascii?Q?x6SkWOhitIe7Zya32la4echQ+MLWBMmbbcb7sSNGWfY1Ou4BfwUFCXSrh79J?=
 =?us-ascii?Q?kD654AmfJTZwkcF6adsmLTvcCI63gW2LeQTgklNG?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b106520-049f-4c47-7445-08dc5eba8dfd
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Apr 2024 08:44:11.8741
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Qv9NVWDB17qZE+VWGWI37rfVjugh/9ngghExMx7Bw1+lDQqjZ7Mv+BGtGqSFR329DfQ/psbU7W9IxvuSaADPbQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7640
X-OriginatorOrg: intel.com

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Friday, April 12, 2024 4:15 PM
>
> @@ -3332,11 +3333,34 @@ static int __iommu_set_group_pasid(struct
> iommu_domain *domain,
>  err_revert:
>  	last_gdev =3D device;
>  	for_each_group_device(group, device) {
> -		const struct iommu_ops *ops =3D dev_iommu_ops(device-
> >dev);
> +		/*
> +		 * If no old domain, just undo all the devices/pasid that
> +		 * have attached to the new domain.
> +		 */
> +		if (!old) {
> +			const struct iommu_ops *ops =3D
> +						dev_iommu_ops(device-
> >dev);
> +
> +			if (device =3D=3D last_gdev)
> +				break;
> +			ops =3D dev_iommu_ops(device->dev);

'ops' is already assigned

> +			ops->remove_dev_pasid(device->dev, pasid, domain);
> +			continue;
> +		}
>=20
> -		if (device =3D=3D last_gdev)
> +		/*
> +		 * Rollback the devices/pasid that have attached to the new
> +		 * domain. And it is a driver bug to fail attaching with a
> +		 * previously good domain.
> +		 */
> +		if (device =3D=3D last_gdev) {
> +			WARN_ON(old->ops->set_dev_pasid(old, device-
> >dev,
> +							pasid, NULL));

do we have a clear definition that @set_dev_pasid callback should
leave the device detached (as 'NULL' indicates) or we just don't=20
care the currently-attached domain at this point?

>=20
> +/**
> + * iommu_replace_device_pasid - replace the domain that a pasid is
> attached to
> + * @domain: new IOMMU domain to replace with
> + * @dev: the physical device
> + * @pasid: pasid that will be attached to the new domain
> + *
> + * This API allows the pasid to switch domains. Return 0 on success, or =
an
> + * error. The pasid will roll back to use the old domain if failure. The
> + * caller could call iommu_detach_device_pasid() before free the old
> domain
> + * in order to avoid use-after-free case.

I didn't get what the last sentence tries to convey. Do you mean that
the old domain cannot be freed even after the replace operation has
been completed successfully? why does it require a detach before
the free?

> + */
> +int iommu_replace_device_pasid(struct iommu_domain *domain,
> +			       struct device *dev, ioasid_t pasid)
> +{
> +	/* Caller must be a probed driver on dev */
> +	struct iommu_group *group =3D dev->iommu_group;
> +	void *curr;
> +	int ret;
> +
> +	if (!domain)
> +		return -EINVAL;

this check can be skipped. Accessing a null pointer will hit
a call trace already.

> +
> +	if (!domain->ops->set_dev_pasid)
> +		return -EOPNOTSUPP;
> +
> +	if (!group)
> +		return -ENODEV;
> +
> +	if (!dev_has_iommu(dev) || dev_iommu_ops(dev) !=3D domain-
> >owner)
> +		return -EINVAL;

and check it's not IOMMU_NO_PASID

> +
> +	mutex_lock(&group->mutex);
> +	curr =3D xa_store(&group->pasid_array, pasid, domain, GFP_KERNEL);
> +	if (!curr) {
> +		xa_erase(&group->pasid_array, pasid);
> +		ret =3D -EINVAL;
> +		goto out_unlock;
> +	}
> +
> +	ret =3D xa_err(curr);
> +	if (ret)
> +		goto out_unlock;
> +
> +	if (curr =3D=3D domain)
> +		goto out_unlock;

emmm then 'ret' is used uninitialized here.

> +
> +	ret =3D __iommu_set_group_pasid(domain, group, pasid, curr);
> +	if (ret)
> +		WARN_ON(xa_err(xa_store(&group->pasid_array, pasid,
> +					curr, GFP_KERNEL)));

split the line. WARN_ON() as long as the return value doesn't match=20
'domain'.

> +out_unlock:
> +	mutex_unlock(&group->mutex);
> +	return ret;
> +}
> +EXPORT_SYMBOL_NS_GPL(iommu_replace_device_pasid,
> IOMMUFD_INTERNAL);
> +
>  /*
>   * iommu_detach_device_pasid() - Detach the domain from pasid of device
>   * @domain: the iommu domain.
> --
> 2.34.1


