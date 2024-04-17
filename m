Return-Path: <kvm+bounces-14945-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 280B48A7F7B
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 11:20:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D5164283470
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 09:20:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C8C412E1F0;
	Wed, 17 Apr 2024 09:19:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ru/RsmLz"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C67F012C470
	for <kvm@vger.kernel.org>; Wed, 17 Apr 2024 09:19:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713345596; cv=fail; b=NcTpCXn0xN/aG8XjrcBMAV6ZboLqjr9WUxfPuDRQ6Wdxq3vgvDeD5LtldE6FtNkQqe4gR3ERUNJReyyR2UDDQXJ+xfqbkbRzyYQal2i544X/8qb5vkkYgB4hDvcou/TIK1Xo2qa4lMKzAAXIp1x/IxEjZf+5gz2Fm5qhtcJd+lI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713345596; c=relaxed/simple;
	bh=By+bzKSCxzmx8YPdWeHhc333vGVqH6DMCcBtZES92VI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=D1VVk86P+GQl6KhooX4X/7cFKmGcrsxkQ8eDWY4jLE+iGtqrNdsxxJgJ6qLBvyoTywnRHm81Xmlmd+0uv/cgHk+eClf1kDzMcONAJMKS7aPcZFERe3MF3+Yj2RjP79ErLyjhfyTw2k6eqS5TXr9MFgvh+BEN0vpKCYNHg0lACyY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ru/RsmLz; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713345595; x=1744881595;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=By+bzKSCxzmx8YPdWeHhc333vGVqH6DMCcBtZES92VI=;
  b=Ru/RsmLz4U+PJQDa2oUE265OqA+ZKMSVti+a4+hZpRd9B4EXO2I27qgz
   7PgBpoxu3FyDDHXoFI2NLo9xkA5V12pgw8eSTlR5nBxzwSzcPLcyebXym
   E2QP4lCQXT33FEOWAaLutBaVGNeT2V4DGiBxKgoPB+6oxJzjthL5SLnOj
   f3c8OBcgwdy66wWbT05zq/c7RO2wLuNwYOZ6fyVOVhA5tHwqMVcKcKG9I
   rk+fwQ7Vzg/KHh3dkoI2EHv6CK9wGzARMeLm8IskymvBNX+R1zYtKBbBI
   GR7ynMOgMGFgHvSSEksbp22tqWsMSpHmSoSVtFz6EZPmi01bESyI6VTnI
   g==;
X-CSE-ConnectionGUID: YrDW0AaBSHeN52n0OsfX/A==
X-CSE-MsgGUID: c4u267ioQCCqeedeg4LjSw==
X-IronPort-AV: E=McAfee;i="6600,9927,11046"; a="12610117"
X-IronPort-AV: E=Sophos;i="6.07,208,1708416000"; 
   d="scan'208";a="12610117"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2024 02:19:54 -0700
X-CSE-ConnectionGUID: Vv8d1z43SOWnlCzkOlgGMQ==
X-CSE-MsgGUID: epvHMME7QMuCfW7E4BT9rw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,208,1708416000"; 
   d="scan'208";a="23162747"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa008.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 17 Apr 2024 02:19:54 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 17 Apr 2024 02:19:53 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 17 Apr 2024 02:19:53 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 17 Apr 2024 02:19:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hT1qpLuqgC0yJyDgD5/B77JbibjrIk77ubuT7Rv/QGfRLlym2j9/B8lim9cUEC8BDLMZ0bbRK2SJwngKnxWWDhImjbGjL44M5u5tY8+8Ozqs9Jn9HLVcm9Y9X6BXZ52DCx0TYUJbci1aJfzekFge209yk531GG+XSecSG4F3W3abUljkezOFCQVxwD18k0F5/iAUVEXTfxz5G0M2CwNfu9BNF1z//LaiLp0FOQnVXKUI/3qosceLhtpVUmcY0knMTy7lpWHTorQvvasBb/+wH2sbEjv1KNpm8zKL0tN+U+VNmkqcLy83BaQEVOwju7zm/1YRu4/2aDK0ws7WDv3Jaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gNE7PoctaQhGpC2egn7D4d0Jzy2OT4NmPIFCBeWFDGg=;
 b=RZrJjSj9RhC7XJ2a3zKEjqHt2BSnuadOW5DtXYG7janTaYlFwrw7ytgsX0rXJcfwak2uqJIrpmk9BlxBRSaiIGWPdCQm9USMIwcUjvMY4Vuy+0FqflgLNDb/MHFlw9vij2Giv/pO9TMJGoHBUDiMaduWLbtf4T7zhzaIpS46MsU++GpsR8EAfCLTXGkjTEmuK9ex/95TfkZ0xduGtXvfv2lxjx2ypl2eFbc3DUI1w63wDK6anHcNhpW3oMCsjzYxsFPU25GTJQqhr5cIFT3SjM1E9921jWE5+D1DbFZ3GT1X9LpQhQrVpBoaw7QR0QRSUHoIq+UlOhE5Fgt2Ot2YqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BL1PR11MB5956.namprd11.prod.outlook.com (2603:10b6:208:387::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.27; Wed, 17 Apr
 2024 09:19:50 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6c9f:86e:4b8e:8234]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6c9f:86e:4b8e:8234%6]) with mapi id 15.20.7472.027; Wed, 17 Apr 2024
 09:19:50 +0000
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
Subject: RE: [PATCH v2 11/12] iommu/vt-d: Make intel_iommu_set_dev_pasid() to
 handle domain replacement
Thread-Topic: [PATCH v2 11/12] iommu/vt-d: Make intel_iommu_set_dev_pasid() to
 handle domain replacement
Thread-Index: AQHajLGkqfFtKZLHKEe3ef0Gz8y/67FsNG2w
Date: Wed, 17 Apr 2024 09:19:50 +0000
Message-ID: <BN9PR11MB52768C98314A95AFCD2FA6478C0F2@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240412081516.31168-1-yi.l.liu@intel.com>
 <20240412081516.31168-12-yi.l.liu@intel.com>
In-Reply-To: <20240412081516.31168-12-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|BL1PR11MB5956:EE_
x-ms-office365-filtering-correlation-id: f4dcf8cf-82e6-4779-3a9d-08dc5ebf8880
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RY4yhKgdGzJh6UNUKG+miakjmxWTtVY3p+iiNcsGXdan96SXk5NeY/H6P7FyAy8zPTefr41L9r6tUhtOSgXj+PMyj8CDo2qvRyVXI3JpoUrx60f2TNmS1f0Wp8zr23Gfq67CFsM2uXGxR9dndXq3JXgc0gYYNPgcRZUD3TMl+iAFqyACDUypwjk4TtzwzQ5OhJi37KFN4/JGFehHNvMWgrHJBw0rzKmQ3WICUURnXKPC1pCO+xfpy1qTdwooL+vgDE+Uwvg3fAowjH2ADui+miObXD1ecNvMpds1xjvjeNR6Uv/JEWQf85N2Npzj8OfyWC+i0w17oe4DFkZuOic/p4qdDN7z+/oOrhd/QqnVFeVHoizbWZJKbCy418WZ/IIs95beWBOPTHORDwRzZ9HZBMDJzAy1oB7CBGv0HvehUnZUoMthrSoQ5dlrljA5cLZbBpOPNvU1nM6Kcvr/BOn6PhMSAgmXN5eLBqnP2VYZlns55BY+zWLlKtfBH5owB1cunq4HD6osXOPs4qsRvIV/KJ4OjGld1XQleD2F4oTPPaQNQBH8tJjnokgy7wQW586x78bhQwul8S1AxRZs7oMyxC+ez/tIeprlPeegnmM2/RpJ2a4e0UbF9tYEX7MxWjXJOHm3egka1pAi5QUhHzVA6o3CEIpQsI4/wibrHrPABgxAbp6/Ac7PG6rcLhIGTVw6L2lNy2ziS/EVA4saDMdLNtXP5JjCDMLo9l7/RPDstXQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(7416005)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?aznz/k5h2Q/eFzQUp5Sf/Gc3U6attQZRvwa+ljBI3Uqtl6nEng37AEXwHSVs?=
 =?us-ascii?Q?8R3fR8ERXrOzLyF7WiFM8fdda/NNfhoUGkDmtL3pKjo2kh9BvYy9Nb+/xqVT?=
 =?us-ascii?Q?NEROrKZIVSraURryVExSQZycqD1ydeo/MpfpmhtNKefOYg80ZrZ3NiMMk/DS?=
 =?us-ascii?Q?nnqnv2Ki02JjvjHHD2YovzWe93JYKsdNbCoYF0q9onDM51KmkEwZnnMNGCsU?=
 =?us-ascii?Q?t6QGfcfZdXtrNdAMHxmLTzj4Wpa6NN65xGC17rj2m3ycNaQ+sLMATbJqNg9b?=
 =?us-ascii?Q?SS/wz/oQF9ZVVnnrGXBlJyK7iaN9aJsgUPo6JQ8z2PYYgmuf4uB5ml7Rthvs?=
 =?us-ascii?Q?x5RMoQgIWNglk8ukzpTU4AHqJ8XpoaiEEAZ1+AH3dmVyc6Cw0RDavhPMPdeq?=
 =?us-ascii?Q?Q15gG+jHEUp9bI0EmIwN46/Y8Xff/7yxX1x1AuoCr/hgq2zevdiVI3nlbE+1?=
 =?us-ascii?Q?/r4Ka9260ODLO+mYdXlWmaJqH2NSj6R+d41CTC1xshWj9b658r1YjG+SzDRK?=
 =?us-ascii?Q?cQOvrDT1xlBQfGi8M4OHGcTTeAYqhFtLa+Sg+iobrO6RS0JhLM+iNBBjbHv9?=
 =?us-ascii?Q?cZoQKXhfnlDN0v//tKfj1aRleTRcgZ9082K8dyNrmGbiZbdNsShfp8IzspSl?=
 =?us-ascii?Q?ucqBRXasIfQwK8ApkeDYoKC2/eRVcm6qdkvHy7I/144Ap6OGZiXNwmf4BIQC?=
 =?us-ascii?Q?DGvyCOtWB/qHV9dY2LZxXMCCGHVfdTRbL7U5U/Eg2N/3EjM96slljQUTLGlq?=
 =?us-ascii?Q?SJ+IpCpQfq7m7INlWzT93a82oeP5A83owwbHip2Dkf2F3nl6sjKZGyQ4juvL?=
 =?us-ascii?Q?RQtn0BrJhZhS43RP+1eC9UIMI0yest+7rS4eWvN6Q/62o33fvaI1yaijnkvK?=
 =?us-ascii?Q?ex2+i/2PyuMyFpDrMkT5wg9uCHs8S3AgBfgb2NAT2NVPBmpf6NCTRwuSXTGp?=
 =?us-ascii?Q?iGrWiLBpNK08e51LqFPRZ66L+NpE/hzgYhuc+GlXC4GCbcuFLos4+R2rfMPW?=
 =?us-ascii?Q?EkJS8w3tfjxheL4GZ9glcTBl6hdfpO3fFbK39Sm/c7q62TQdk7qZJ2XHBMMm?=
 =?us-ascii?Q?eLgxgke/f34Xd3RZs6bsh570iEbDOuum62QOWiw2g71dy1GoLkNxVFeLL1PL?=
 =?us-ascii?Q?lp7I0pS0IQfaG+CTxztG3dZJ+lxapKgRHuuk2z+c7ZA3Y4D5OBGzFeW2cdv2?=
 =?us-ascii?Q?8710/w4ZqBpVbx1JyaqKSjpZnEFoZ3W0ysfjxwNdtS5XSFUpyZ3neOAkFKHv?=
 =?us-ascii?Q?JZMvyO7ym12nppig3DBxojPXJTeCm2fYRcM53WXRWnV7lejkbJi4JoKL/HFz?=
 =?us-ascii?Q?CHHFRJ4mMLdjKwwF4xH0sGOaX0wHv36FGcLNWyAuIYk/dARwLRpBsDiNDOjQ?=
 =?us-ascii?Q?sRUQzIr5iToei7ptpZQnMQx2VEytDfzI0Jm/hgOWjCgCkUdGVUYyCiZMTNQU?=
 =?us-ascii?Q?tEF18pxmdR3LxAsKDMS1wbW0IAB1ftegMjIEALxcblAPT9LuzNtNlqwR5gGY?=
 =?us-ascii?Q?llnw4ecJOKN/yFE3fAuJWQ4jk3/VkGCt4nv98B7IWcRdcepnBA3IANXan59N?=
 =?us-ascii?Q?tlr1kw2jXjR3jqORTaa+5S2AFZJfkDypjz2IiyNv?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: f4dcf8cf-82e6-4779-3a9d-08dc5ebf8880
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Apr 2024 09:19:50.1147
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: h3oZtprlWEqVzRmX3UNNzetooifktokCI/p7tTmQWMPKiD8SXV87W42eDDANGiKPRjCBEXNiS5AL6+fKuQjcsQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5956
X-OriginatorOrg: intel.com

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Friday, April 12, 2024 4:15 PM
>
> @@ -4646,6 +4646,10 @@ static int intel_iommu_set_dev_pasid(struct
> iommu_domain *domain,
>  	if (context_copied(iommu, info->bus, info->devfn))
>  		return -EBUSY;
>=20
> +	/* Block old translation */
> +	if (old)
> +		intel_iommu_remove_dev_pasid(dev, pasid, old);
> +

let's talk about one scenario.

pasid#100 is currently attached to domain#1

the user requests to replace pasid#100 to domain#2, which enables
dirty tracking.

this function will return error before blocking the old translation:

	if (domain->dirty_ops)
		return -EINVAL;

pasid#100 is still attached to domain#1.

then the error unwinding in iommu core tries to attach pasid#100
back to domain#1:

		/*
		 * Rollback the devices/pasid that have attached to the new
		 * domain. And it is a driver bug to fail attaching with a
		 * previously good domain.
		 */
		if (device =3D=3D last_gdev) {
			WARN_ON(old->ops->set_dev_pasid(old, device->dev,
							pasid, NULL));
 			break;
		}

but intel iommu driver doesn't expect duplicated attaches e.g.
domain_attach_iommu() will increase the refcnt of the existing
DID but later the user will only call detach once.

do we want to force iommu driver to block translation upon=20
any error in @set_dev_pasid (then rely on the core to recover
it correctly) or tolerate duplicated attaches?

Thanks
Kevin

