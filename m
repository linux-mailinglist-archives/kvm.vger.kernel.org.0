Return-Path: <kvm+bounces-12946-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C013188F5C1
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 04:13:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EAFBD29E80A
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 03:13:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED3192D058;
	Thu, 28 Mar 2024 03:13:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RchPvWn5"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72B7A14011
	for <kvm@vger.kernel.org>; Thu, 28 Mar 2024 03:12:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711595581; cv=fail; b=a8eJc83COtVQDgXXwSaiJLbwLtYaaf7iplia+ad0ew647PowxIYZjKgbZ7A8oNtduEP5pY4yVULmkRCY64Cc6lLOVyQs831HzJeu64zW7ZnA3FdeQjdayWei7W2ZFGuyy9pUeMNpc8CSgXiSEACFB4LT4MiwD17cVgdToRiKmp8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711595581; c=relaxed/simple;
	bh=rZaZ7Z3KytXoJWZL9Cdgld9GVgoE6BN3cKVD7rGfUL0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=E5/Zl7yYAgkJ2POjs9otrcCZEbj+Qx/BY8okWjO5f4lfc5X+7E+oOb6z5FVBi6Q6H57AdIxHgBc4dHID6BMvR8dvi7Q0sK9Gk5O07IwhBEV3Y9dqUNGXFt4rJcVMNwpgSAIPdsB56UzKmYhr0Ya/a66IyRExJo3xv55t2GrxMgU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RchPvWn5; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711595579; x=1743131579;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=rZaZ7Z3KytXoJWZL9Cdgld9GVgoE6BN3cKVD7rGfUL0=;
  b=RchPvWn5BrR63dzc0h0EyUji1qZbWcTtBT1fa7Y0ZztrTkDEBqr0ZHYZ
   WrIEFYp06Kfa89mv/iDugW/i4svd4OASmmuweAuRSyjNRAJRyBlN3ylmr
   lcZOTyNNTbHXh3Bb45OB3lhOIHto7DGYrSCM6TFBnd7vKBCAYHer4OtMz
   oxK0SpAdywyZubxbWxAddCRlck4tsLy6XWSCVSoZ6M4NgN/koLlYxrSpI
   Uzbj++8pkNyX3P2LoPseJ1jHTZ3j61AxG4N8brwFbPbybl0HvsnGMt+BR
   zxUy4pXQbngR5vzpI9wgDrwKd32ZdIoTX1nxQQeCQFcWWrtza2anjCTGJ
   g==;
X-CSE-ConnectionGUID: Z1OVd5HzT2+TE3zx38b7uA==
X-CSE-MsgGUID: VdGGBGHhTtSBR+pSSskUlQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11026"; a="17878431"
X-IronPort-AV: E=Sophos;i="6.07,160,1708416000"; 
   d="scan'208";a="17878431"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2024 20:12:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,160,1708416000"; 
   d="scan'208";a="16900741"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 27 Mar 2024 20:12:58 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 27 Mar 2024 20:12:58 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 27 Mar 2024 20:12:57 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 27 Mar 2024 20:12:57 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 27 Mar 2024 20:12:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oJY8tXFNvDdX2X2RzFW1r8pF4wtP5K9V5KKvstpYwjSzkAZHMwDXWztmkt1kKTxOkEe9IUASytwC2VETUTIG+f2xN2XvH/ryo0HCHjYKa0v3Map+QZeUpFSwDjIUSXupc7JkxzJQwrvGcjLhazjCyQk7XZLIwPku6Qk9Xr5SjR4apo+OnsdIfhDpgyBiIiGrgg1QUWhgd5LUMMBzn1mYnk96BPah9m9cZDprwYjzz0EJAyP/QGCUI9uIwDihrls/jpas2Y5NMbPQ9liILHOKBr3boL6pycKGU+61q2TXL/EpaPX/fuZWqw8Rd7nxnRiZl22lU6+nkd6wRP1E8PRYpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lWzOHyPWVhxG6pyehzsd98IDl5sye6y6DpvjFcop1f0=;
 b=ScYb08z5nA7UFZGjMSxAADFiVFwEc3VpuB1kCE4wz1jQfLhoO6dGqgtLf4J/QTwJrutEjXRcSQIyIH7Ol0Wkcql46JRuZgY65wKLX1odnaSjyqpltAKFgAEOH1L7e+q+uIbKvopbj6ypXYIUM9/xSwy1zSoSIXwWym4M+Kti1Y7Jspqu5OYcIMxhP84Nb/2f6NZ5pbK3RCV+5kdxEzcWbHbp9cdIvB/wp7WuGFzeiSZUgN+YeiEvEwLH7Y1TacECRfUk564rRYesIwJ2L1xjUXXMx7SJaa0hpi4eUtDK8EUs8SjhEpIa3NfRBrhl5mT5caAxMnpmDIzVU9ESdN1HkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.31; Thu, 28 Mar
 2024 03:12:55 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6c9f:86e:4b8e:8234]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6c9f:86e:4b8e:8234%6]) with mapi id 15.20.7409.031; Thu, 28 Mar 2024
 03:12:55 +0000
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
Subject: RE: [PATCH 1/2] iommu: Pass domain to remove_dev_pasid() op
Thread-Topic: [PATCH 1/2] iommu: Pass domain to remove_dev_pasid() op
Thread-Index: AQHagEXy0UXl97zIn026R0I3yCt0lrFMeesA
Date: Thu, 28 Mar 2024 03:12:55 +0000
Message-ID: <BN9PR11MB527651B93FE5D2EA426678888C3B2@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240327125433.248946-1-yi.l.liu@intel.com>
 <20240327125433.248946-2-yi.l.liu@intel.com>
In-Reply-To: <20240327125433.248946-2-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|DS0PR11MB7529:EE_
x-ms-office365-filtering-correlation-id: 803a92b8-9f07-4d86-fd39-08dc4ed4f698
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nfw7kd/7WXjvw/vmGirYYuyTnlrlh5+yeT8+2hhEjKA1pAaTCAf6wmKXkJXgFF2jQzEIY7gNwkUkVf0JZVVh/U98zCh3SOzj7X58M8PVauR5Mm+uDpnMy2k7iSWkFdT+es9f489F7BkUJd5zH//Dpef5c2MYyqDlnfAF6DoUKtfU45kFQyBN4rqkbEozcHDnTEjFf8AhbEDWDbyiLSLaBZj4PeXeBN/X2cfqfDHu27xbsS81/YqY3524CncgmTesHcFOmQ7+Yrtytq/7YetrVD0n+V1wV3Dq4mtHa+JpPnYMOnHvPqOYWP2ROBIalNBxltScQvd/TOa46ggNfCOdhRnDxqqb8GWR63Eg80X6Z0KyX0wRo4NFHxK95c7urx9OlO0RpqOxFpU2LcqlxivjRmMUOL7Yp9eQNan701apnY6zwqASv4boFCRlkZqMIqLlf1oj+eKMDfaRp5So7cJgm6GWY6Au8QX2nAeCXKm+okjt43lTrKEGz7A9iaLZwPdLWOwXp3eigwqasL7gdTLdN8S2IEB6ODCsl1UGIGX6ss5sGCLJz1ixlFrjlWvq0EgqhGHFmFFODoIZV0mqNOhzPDLMUaBW2kXPhxVXIkp8pjE/EWXeH6xmIPtPj/MuEmHxXJPE5RTbY7XED3fVy98voJChqujvTT2CMkv//KRLAzMTk00rbnzenO1J9BIBeZKp20ig4lNUQMFP5OHf4QLGEgOCkgR8jfh7CmpGVnrMyl4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(7416005)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?KdwHDoIMutqbs6oH3+1oE/78g5GDcbwYRmX2syltpwFK8BLTV7KazC9pueD6?=
 =?us-ascii?Q?rL7w1iLk06LiJp/EBMp2FiCWBXjdGf5+yelDgSDreDTlDkz+wXih6s1uapAQ?=
 =?us-ascii?Q?LVMUSsr7LpqY5mCohdCEoLnqBOOm61r45cpZWghmDUOno6+474gHcLoCdEh/?=
 =?us-ascii?Q?UUQ9Ey6j0CiET7KMgRc8EzfjM9yKvQWFDGhth5VtnISEBe39Jkasa9NEd65i?=
 =?us-ascii?Q?BYw62yQYJwreDW8YFRWZh9vRVeYFJv+t6Zs6/BgCgtaMcB9aT9jYx4jEXpRq?=
 =?us-ascii?Q?AylH4HI951v6jsUfDRmOXeQSQhZan5zH/ovsTgwPRw/wufzAhld7SVkNLmom?=
 =?us-ascii?Q?p0e2FeUd0FcPtAEgJ11hhM6a+Y3ZOQKMPrtXUtBYg+aj4VztTowu8xKdojJ4?=
 =?us-ascii?Q?t+Zfi2YycCXr7LPEWaWKMl20SOCeA4G5jbsSzTwTM5mVUdzopaxBXfmqK09Q?=
 =?us-ascii?Q?tXaiz1KLSUT1DVCGZ9qSG3aZbh0MyikVnJNEYml4vXwfGq3y4EupWkbCk1Sv?=
 =?us-ascii?Q?nKLjMmIT7L3Nqpa9qxcKUNw9rJ9PbrIOqeSijZzWQW1PIQNnjHhPY3DGUDds?=
 =?us-ascii?Q?V3HjxtFkn1ivPJee4ZKjM6cc45v+SxMOdtUBbM1BMHW/NIfjqSh7i7dB3Mch?=
 =?us-ascii?Q?DcVF6xwomwNS4DkrloFij7kb0YdP5z6PyEcx2MQQh7Lftellk0wbEaSlOZCp?=
 =?us-ascii?Q?Wp2OJDc1lPP9bh/YMIJlqRH1vC7wTOpOO+T5LF0demo5vENuOHPDrCx4RMjU?=
 =?us-ascii?Q?KncodQbezBIHEk0njL3hxQ4tFaCRSyuMa3tfquPw2yky6+ru7UCNP7srNxCt?=
 =?us-ascii?Q?L33+jphC5iQ+sJ6zFzAp83Z8VRba2y73FkxNe2YCteBZ0yaHiC3t8++eFO52?=
 =?us-ascii?Q?OP85KbSXYIuStZw6yb9xL+i3bXpCQ4/HYeFUGWcCpRWRK3NDEUKiZ6I1fP9W?=
 =?us-ascii?Q?tqtt74BFarfqnE52NuXRyAnFbqDi568yMfVRhhvvb39oTCge7oZ/VUjtOMDk?=
 =?us-ascii?Q?YpaK1spaM0VQfe0DZFEH16OloArcsan0buvuaXeRJudpQ3+AQ8d6RAhgbqod?=
 =?us-ascii?Q?oRFEVcN0RZkXA3BFNa2sxGsKTM1v/741CqCOlv7sRRQRgkLjtK/K2UHyZgHN?=
 =?us-ascii?Q?YQP0qt/THYe6slbkvvcsernQRk/dD07JbWojrD3y6jd2lj7WMvtilqcSM05G?=
 =?us-ascii?Q?PXfaM/WuucgM8nX4lv75/1yApyKeqM31pP4/1UdYKmD55gWdy4BwfxNSykGZ?=
 =?us-ascii?Q?4753Q/7F88sbiiiVTY9NimegqIKRB3CTqGokey/Xe96CTtzKgoxSM3eqHo7Y?=
 =?us-ascii?Q?bg1SlY+zpx471/NMrdjZXJBH86M5HDsJxt46M9dBN95e1asoE9GMpRLPi76e?=
 =?us-ascii?Q?2P18lOcAISXPAyRkKquZMmH78KoJNd4NUJyp9BMwEcAV11bsTCXGc1EJzfrS?=
 =?us-ascii?Q?YLrpLydsVoF+M7wGrpfj6cac5f69zXDoDU1vaEL4ExW0BF4oksy3GSdV6y2u?=
 =?us-ascii?Q?fA7YCdvct65Cmrc5MCREbuBfWxj/2/BLVDeMBUOpOBIAaLIbZ/bf8HmhDmvN?=
 =?us-ascii?Q?Mj2R9P8YQZ6ue5QdqUEnUp2YJfqqBx3BnYdpZJ53?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 803a92b8-9f07-4d86-fd39-08dc4ed4f698
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Mar 2024 03:12:55.6702
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4dUGAbaCBLTJpyWEPMy00PahR6oHn2SzchOuQ1kfGwNBsvd8G09ya1wMmzKFxwBWM2Wt3yAAZ6Y7DjboUJ3O7A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7529
X-OriginatorOrg: intel.com

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Wednesday, March 27, 2024 8:55 PM
>=20
> @@ -3375,7 +3376,7 @@ int iommu_attach_device_pasid(struct
> iommu_domain *domain,
>=20
>  	ret =3D __iommu_set_group_pasid(domain, group, pasid);
>  	if (ret) {
> -		__iommu_remove_group_pasid(group, pasid);
> +		__iommu_remove_group_pasid(group, pasid, domain);
>  		xa_erase(&group->pasid_array, pasid);

I didn't get why this patch alone fixes anything. You are passing the
new domain which is same as original code which gets it from
xarray.

so it is at most a non-functional refactoring with the next patch
doing real fix?

