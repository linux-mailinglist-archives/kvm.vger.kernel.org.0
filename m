Return-Path: <kvm+bounces-14944-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F2D8E8A7F0A
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 11:03:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A47F1B21289
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 09:03:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3BE2212BF1A;
	Wed, 17 Apr 2024 09:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="G+hTjWGv"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D75912A174
	for <kvm@vger.kernel.org>; Wed, 17 Apr 2024 09:03:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713344622; cv=fail; b=f9YfvyZMsO6ga6040RGmuvia3Gnan3kt3WgVBGGz4lI/HuvM/TaC7bAGKu5J5WLGFqK69pT6XJm5CdxhrP0RFhxDb24/LHuPhbvh2Gp3Le61geL7L54LxQP1y8ucxvt9jgA8Xyy5rdfcsSinwp7y2XyX89ZJWoFrWxRhRwtyWvA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713344622; c=relaxed/simple;
	bh=HkqgMLp6dbe6oQRk33IQtzktfmNKpYOfIlt0N7IyKaE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=VjJ6tALFnp/8RlKYcR356y4GNerPXxo0H8J0eOcCQOGfzdhUSvD1LrTCy4p9cAOsb1wmjsCtqELjrUkMOu0iuErMatk42TUXk3vSeH2G/4uCMEabvpM2p99TdOB9ZBmCnPivPkM1sFrxN99OSuX7Wp+qUNbrxGTydZpcaUp929c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=G+hTjWGv; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713344618; x=1744880618;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=HkqgMLp6dbe6oQRk33IQtzktfmNKpYOfIlt0N7IyKaE=;
  b=G+hTjWGvQrfBR1G/zL46vNbPLgFfn88hF30pUTcSOYzJ9CBLdEHudWZx
   fzrW7lR1nPaV816pcX3RlS1FBZp8F33uTWYgTEW027acnoNRpu8L1ckaQ
   jy9sLsaT/6dmJnkqQhbtHKXCdgkigWzX75t+1s7355kLiXYFXDXItiHv7
   Hc1aqzyR0LGbZpvdlQ1yUhHgBfJLFZSjdmrpEku248FkA7yjAdkqOHVmp
   +KRc5KVEYndTAJQRU2ZFYEKMosorDAniL9CZuWYJPiU/7R4jaJUQg8X70
   26RThqEHxb2p2bn/YPBeI41eHfLvnrTKpROvUVKlvpmQ/nzCuPVtuawJj
   A==;
X-CSE-ConnectionGUID: Dc5zgM3GQR+QarC95nK1lQ==
X-CSE-MsgGUID: +CgkKcd/QeGaDlM8b/x95Q==
X-IronPort-AV: E=McAfee;i="6600,9927,11046"; a="8685506"
X-IronPort-AV: E=Sophos;i="6.07,208,1708416000"; 
   d="scan'208";a="8685506"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2024 02:03:33 -0700
X-CSE-ConnectionGUID: qreWGnSpSy6SeMOgEFd+qQ==
X-CSE-MsgGUID: Pfslp96OTS+4vSRfAHbwgQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,208,1708416000"; 
   d="scan'208";a="22623284"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa008.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 17 Apr 2024 02:03:31 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 17 Apr 2024 02:03:31 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 17 Apr 2024 02:03:31 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 17 Apr 2024 02:03:31 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.101)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 17 Apr 2024 02:03:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dqahark56JV+L04+qwDGaw7DY2KQsIEeJ3jFL77JlGlHGCKN2f/w/LmUJilwjqCOjAJW73VyUK+ebrAVWq04d/zBqHCWnY0et0zetzsw48yMyLfD7MJHeZF5EAQIiu7YnzFyyeSIw1lpwirS2BXOu33TMLUZy+LrqSMVCnGt9M+5oDX5yPL+hbhZr5rkhPGDwJVugdv9iw/J/jNnRSAtMYXh/BTWG4cYEtvXvQlytbENahFdY2RNZ9FTco0Y/G/XxK/YIB6J9nliSHbmTHfy6Lu2ycvS2n8fE5lxcsKFtyrJ04ENqGlTUDeLBqHry/CnC7UOxtUDvXtmwWm+2yLQUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HkqgMLp6dbe6oQRk33IQtzktfmNKpYOfIlt0N7IyKaE=;
 b=J6ZagFmDwdGkrm5BmfkwPkEWVfmcbBhFew8FbY1K07aOPk867btLmR5kxzM4euVvIaE2bXtJxfC/xI7EVxeh2E5WVVd/F7YWwccyxw2To5qn1D5iXxWm4FKVcnFcyxsQVBvDsiq7lGClJ4TaZm10xsowGky1KodhZCOpVeGs3jCSI0Dm/Qc7LdpwtLuDlHHdc/OLDEweqMDtwZKHwB+lMyPb48j2eNc+gR0AZygIV+gni0Wo3BIrODANJSSxe4JtDLU5XQi4tThxWYFXNzt7G0arfXjSrnu6O23LtT1yAKU8IS6BMAhZctQ6QQxCFYa1kQ/k0Rs6qbytXZPBZIRCaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DM4PR11MB6215.namprd11.prod.outlook.com (2603:10b6:8:a9::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.39; Wed, 17 Apr
 2024 09:03:29 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6c9f:86e:4b8e:8234]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6c9f:86e:4b8e:8234%6]) with mapi id 15.20.7472.027; Wed, 17 Apr 2024
 09:03:29 +0000
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
Subject: RE: [PATCH v2 10/12] iommu/vt-d: Return if no dev_pasid is found in
 domain
Thread-Topic: [PATCH v2 10/12] iommu/vt-d: Return if no dev_pasid is found in
 domain
Thread-Index: AQHajLGlHLJePcz/hEmJzgewyWrsMLFsMqaA
Date: Wed, 17 Apr 2024 09:03:29 +0000
Message-ID: <BN9PR11MB5276F533511EA5E9D0D9BF968C0F2@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240412081516.31168-1-yi.l.liu@intel.com>
 <20240412081516.31168-11-yi.l.liu@intel.com>
In-Reply-To: <20240412081516.31168-11-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|DM4PR11MB6215:EE_
x-ms-office365-filtering-correlation-id: 92e48664-8a71-4aba-e61c-08dc5ebd401b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6jws/2OspNEVAU5m2Uycyf7NCY1WxaKMzsiXJnTEop+U/PFfJT4uG7WfJ7ctYwvgO5tiQHSEfG2o+RiKD5I43krpfgC3ONDWeHqRnEawLWV8LJU1JGVePcxrTnb6knpRmD4E/LExw62Gc53OfX246nzvvfk75FdE92Chemf0aXX/gTmokij3elE3oiC+ZLzb/whF8EUcmuS2qece3dwvEnaJBH7kmSmOiwpeG5oBX78Cmld9x9wLW8wY43FtUakFr1ghoz/CixmF9t951KIa1P7/oFXxxjrR/p/j4pk5AXsMTQwmGJKRatjWACin8JgjRUNIRP/aSNuvynPgj8B+ToF2j2RRcNlKeDghw54gpBn/OJefHeMSNiO68TNJEEt7UVwjIcGB2//hrgx8EhsF5wJRXUnkeaekHmAQQlC3OOrpxubVj8bItBbj9R8rL8T5EYIiI/HGUew4XxNmjIkdjU0U99Oo96VuUjQYIfzeEHF90rfzeVfNJ+Mwbel9Eyy8V9Lz89biW3VXzdvWTPZSHclJ7EtsBms+iwWXFHlVIsapMMmozofil2ml1Dq6rZdVK/7At9DG2R6cVhLyE9mtR2izMWyOlCDoL3R4Q4NffBPgujVDljc3zUm/ECRF9EUXlRl8n16CRiAQlPoxxEozHlWxtUwD6pPlIk8pcYDzHT7OGGP9B0qIWH+OhGEaUSi/1EEA2aCrfSZ1KlvFUSaqivdg3ObZXZGKPSW6UaJoxcM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(7416005)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?0DvVg1/mI5CUmU04nel752+A+K105xkR1fwdX8nU+HUuE6iCku1ZIjMTlLap?=
 =?us-ascii?Q?sH/NYBzPgHmCjrSyfniFQVCYCGRFFPI72lusLkBFK8r1IaaIslHraEBuGpUs?=
 =?us-ascii?Q?KnKk7P7TevgZNYaxorvv++fTvNCGpK9VeGPInCy1PSISjasLsja6dSG3akQU?=
 =?us-ascii?Q?jzzOXNEec4Gr4lK1h63fiHoJS1F79JXJ7rgOcXDDtm23NVnEfZhWA5C5Raeh?=
 =?us-ascii?Q?feVHYkr8PW+Ka0wjedpOlGrcG4607g9B66teM5St6b1QZcYrp9/Bv3UnnbHS?=
 =?us-ascii?Q?sCVjmTxV4mQb71/tpKkz6VB38dUP1MY9DTSFlA3SDXrcc345Azx7tP8SgB4B?=
 =?us-ascii?Q?An6nom+SYvjgD+yUw9q7IIkuSI7N9mtbUz1Zr9vp+bA6b4WhrPqEzBouKoLv?=
 =?us-ascii?Q?Gm/shbkQmkbzAGzHeI90iUotWOh496iYSqLi7Oi8fofPAF2nv4YmeFvYIgBW?=
 =?us-ascii?Q?dNX7ACChTEAgePU8HLq2xPgC+mhJ4DLrVo3b5MfpjV1tSpy/w2eOfaw9Clrc?=
 =?us-ascii?Q?zHmMRKYT2i6biXKvlQgaJmGoltx5/89fAUNIdy2jvS8FPjCVVJuXg5970Mg2?=
 =?us-ascii?Q?crsYHoBKOxDkA67Zbh6ex4Ze1KHRNu+LhMe703+YO8ObR5QwWkhWKpxtGV60?=
 =?us-ascii?Q?imMz1dm9SFNtTUzfsYrm7qw94hz9pX8jFiRJivWxBv7JDCGcnbehPsHbXO8s?=
 =?us-ascii?Q?dHgFA0+CPkShPk1f8OUV8oYbU7GrKF6eDFZ8uU/3UpsV/nWj0sN4hqnX461I?=
 =?us-ascii?Q?QqaKJrn93YxLvsYHKmO80YlX5UCWKJg/pDycj9mOOA/EB/HkTkS5bURfdqBj?=
 =?us-ascii?Q?vw3K3JEVO5B7dnK02aGuoVM0tePmOeGnRadZZe+n/WPNzp98Rhz3sr7Eicge?=
 =?us-ascii?Q?XBApJQKXOGfSChpQ1wRh5yrF7zF96RRnAFn4i0nX0bRmEO07Af81cvBGbjn9?=
 =?us-ascii?Q?xoUEQOWqU/Q6BetdhcDeUVYyufIsTy58d6Yvq91obq7kvudkDuoUDSyKR8mu?=
 =?us-ascii?Q?KldYWkI0mk7Caqhfu3tObqlrIujpNtKkjaJJHTXVddUxAOugt4fQZhANWUuq?=
 =?us-ascii?Q?BDoJ6R/mMjbWtL4uL/tRTNia2W90G2ylLjkIFqc1d4aEPXMDrh8tWbFJLKiI?=
 =?us-ascii?Q?SPHzDriozEYBu87L4P3OK+qsF5vAGecBz4kMhyoHShrAvWseRc0Igc/7mj1R?=
 =?us-ascii?Q?1WNEnIonzgkMyEPKeFuly8TSlqPNOXMNSYvOLHpoc1/Fh96Wk15yC4kaxwwm?=
 =?us-ascii?Q?msym1kgOxIk+0hTE2ZC8oE344i6dNgaYHYO25Gbp6eTMCeV/Fsb093hUpO/Z?=
 =?us-ascii?Q?D6xpLjxE0JMOJS6Yiztpl755LXCxW3NEc+xK1R++ToTvmC4L2Yuip8e5EGDj?=
 =?us-ascii?Q?v4BkQyRS0gaBlDQEdTOB4jpIZk60IaivimiHXM7eAkVX+xT6KsdsM2Sr4oPs?=
 =?us-ascii?Q?a6LZAdt4TwSzhkieCgNowKcRqw/u2CsD+Ca4C6MqeKIXSuDG1tZ21V6yvn8c?=
 =?us-ascii?Q?lK/B2Gack1PN4FulrrcJ591UtUFVKotTQgC7SiVchNkBewBbP8z+WPYE+6fd?=
 =?us-ascii?Q?x082k481ujaHMTL3pmVmL7aKwUK6H2v9fIEfJI9z?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 92e48664-8a71-4aba-e61c-08dc5ebd401b
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Apr 2024 09:03:29.6599
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wdNCKiAipPGxrJf3RtiGL6ABULQirjKVunH+HI4q8rJyXv5G3U30uVYdrbs47/M1rfC9lJoF9Ejsk5FmJV7DDw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6215
X-OriginatorOrg: intel.com

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Friday, April 12, 2024 4:15 PM
>=20
> If no dev_pasid is found, it should be a problem of caller. So a WARN_ON
> is fine, but no need to go further as nothing to be cleanup and also it
> may hit unknown issue.
>=20
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>

with your discussions let's remove it from this series.

If there is anything to further cleanup it can be done alone.

