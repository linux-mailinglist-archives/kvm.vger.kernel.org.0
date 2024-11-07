Return-Path: <kvm+bounces-31074-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 69EDE9C0138
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 10:35:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8CD491C2114C
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 09:35:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 015041E0DED;
	Thu,  7 Nov 2024 09:35:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UNWerXWB"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1D5E1E04A6
	for <kvm@vger.kernel.org>; Thu,  7 Nov 2024 09:35:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730972140; cv=fail; b=sCSp/EbSCCI7L3ZfC/5O8t2JXDO4HIXf+JsNoqz2hvwXKnHvc3WQDbtam+8LjCrVMyM2hiWx0yboCWRciz9Md/8ltGDWrQCqMY+MT9UfhoiMMHII4LekhugKegaZj1cgIHArf/vPx+FoboQwN7Wzyk4pCEpDQh0AbodO8yQawSY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730972140; c=relaxed/simple;
	bh=CrskKlp5PukUPq+n6vmAgOTsWUetGs8FDTNXTrnhao4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=BpBmlW4iM/OZMGc6QDAG+eUwBSq8eJtupQGfmy8DShZRzIGxEd7pzbVDpDOWkuEO6AEkndB3vxo7unxeHIP2jBCDLmHE+4K6uKMcSsGnuK4UvuFxv/T0m9SFMJjOJlaIaKg3MJhWaUC2GeEwzd1X+fEtJp5Cu9GH5m/DnWnE/eM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UNWerXWB; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730972139; x=1762508139;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=CrskKlp5PukUPq+n6vmAgOTsWUetGs8FDTNXTrnhao4=;
  b=UNWerXWBWcJ3UYrWXM0OeDiAhKYqP87P0Kf5t94WjC0OSTroj/33h4rQ
   uZSOobzyby4HdkfUmagHDeC5Rg5TpU+aQq6A2yT1euc/HbG8GEmALEl2m
   kVtuATIryQEA33jkav6FL6DRNsRyKxhRJNneMDwCQcuVCA+XFvgu5+QWa
   t/VPTKwuWrKX/lGkeDPpB3sOGS4zQqNixz0AyPtLe/v8SUqPgnCyAV57z
   ubGAUmktmW7XnIDKjx/G3/1uu9TJOCbYpnx7gGIFYXVoFFpgyCJ6K6Mjb
   M9sl3lTGefm8SnyLSbnpXykgNTgJGVJvcDRxxj/AR8Gn8Xa6dB/mdMGJs
   g==;
X-CSE-ConnectionGUID: 5vnxO/xaT6W1SjWoRddchw==
X-CSE-MsgGUID: Qs0TnmtuQHSX86TkSHz4qQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="34502039"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="34502039"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2024 01:35:39 -0800
X-CSE-ConnectionGUID: uJEQ8qsfSbKkHKcoTGSGug==
X-CSE-MsgGUID: /3mUzpUtSiyt1JhOL51Z7Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,265,1725346800"; 
   d="scan'208";a="85128651"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa008.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 07 Nov 2024 01:35:38 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 7 Nov 2024 01:35:37 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 7 Nov 2024 01:35:37 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.48) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 7 Nov 2024 01:35:37 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XOGmvDEL/377ZvXHtCQcRAgjhAFk3ADcYkbvj4Xc/J4MVxSkD4vsZTdez3LDdk1nY/CcRfQrrXhA8mM8N2JTQaoZP0Ri/eESoULr/umra6i0ivGlP//kvhp02gd1yug6Gnqb2HNHXUR2J9gZzcuCw73QddhXYD5OLl45z8qS64nwDVaO9uKwaUdsGzE4ieKshycdi5cMkDnb3ULhH4NGzHFvVdji0D9c29azMGqpYMHHCC9OgfhRf1d2/nb07vSDJ5WElug1IOp9clztKZFugieQgqA9N02LVeSg1AxEQt+Uu6hVC4oX+YuBFj9bbigHX1b37iWZC5sMZb2sFrcI+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5HNE01SWRXYD1DgPIUctRMg1ghPAMhGBZBR/vJJdG7w=;
 b=iKhEV0qHYUuhQne+p3RU11W0+il99hOreEeJTB1JBHNvy2lo7NJtbQCco4GZxd948DF4MAPKrnN1xcFNAcYN3grWXMmFfzE6sYZmpb+uKutyvBzLZrd67CWgNcQf8PHtNX4EPKu8OJDIdMeOmhuYO5BdLDVeUVIBcabzYwUSnKHgJpg/lzV0IorlX1ecT2tSzq3fZkbs2Cc3T3zFzLsmbMy/y8zVI6U4cVfOxZSg6HvT1gycx88cYG3HUOtyDjf5o1K05tRNOxMjbw448Ja771/b64LbUyvP3thv7roK+ucVsvb8XzQXwQqR8WVtJzRiELew1YdKFf7ZifAq0IOp9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SJ0PR11MB4846.namprd11.prod.outlook.com (2603:10b6:a03:2d8::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.20; Thu, 7 Nov
 2024 09:35:35 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%5]) with mapi id 15.20.8137.018; Thu, 7 Nov 2024
 09:35:34 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: "Liu, Yi L" <yi.l.liu@intel.com>, "joro@8bytes.org" <joro@8bytes.org>,
	"jgg@nvidia.com" <jgg@nvidia.com>, "baolu.lu@linux.intel.com"
	<baolu.lu@linux.intel.com>
CC: "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"eric.auger@redhat.com" <eric.auger@redhat.com>, "nicolinc@nvidia.com"
	<nicolinc@nvidia.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>, "Duan, Zhenzhong"
	<zhenzhong.duan@intel.com>, "vasant.hegde@amd.com" <vasant.hegde@amd.com>,
	"will@kernel.org" <will@kernel.org>
Subject: RE: [PATCH v3 3/7] iommu: Detaching pasid by attaching to the
 blocked_domain
Thread-Topic: [PATCH v3 3/7] iommu: Detaching pasid by attaching to the
 blocked_domain
Thread-Index: AQHbLrxlPytPAHCtc0Ckos8F66lR3bKrkxCQ
Date: Thu, 7 Nov 2024 09:35:34 +0000
Message-ID: <BN9PR11MB527612ED148A938C7C490CC78C5C2@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20241104132033.14027-1-yi.l.liu@intel.com>
 <20241104132033.14027-4-yi.l.liu@intel.com>
In-Reply-To: <20241104132033.14027-4-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SJ0PR11MB4846:EE_
x-ms-office365-filtering-correlation-id: 5499a502-6318-4132-0de1-08dcff0f87e2
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?/vyKEYhQDrEfbHl9zobyJfMQV4DfRaoPSAqcY4eqg8bbjKWP25ns4CJThLq0?=
 =?us-ascii?Q?F9s/+JxTcZCJ3C32n0dRfPmCRgeCld0PNWYGRNLQPaznpmgiQbTV2J8QrK/t?=
 =?us-ascii?Q?HV6PffB/zRGrVI9uBpA5s76HJTbM0IoiPV+Au7E497dNeGsVSjszaoSsD7eN?=
 =?us-ascii?Q?c9+mtakQM+LrBsCkZQhx+jG03WkCqued6kcVQGqd+U1OUQPXhQSLB5TxUUjZ?=
 =?us-ascii?Q?SngV0TSQtBR58qg/hSwhURLIkljWseXApsFRcmbADAvkvvwt+H4OGN4WubT/?=
 =?us-ascii?Q?26qybH+81CcAUFlD5XF6+MDwNo9r+8h3dAVnQIxPV7xvet13Igz1LYYEyLOF?=
 =?us-ascii?Q?1hSOaqWwpuu4ht7zoD0Ok7MJZStXZQl07wiW63BYOvTlYxToRJQYuWVYw2ff?=
 =?us-ascii?Q?XHPrKOUAy/oMVQiuLaJrHBGj/uFP4dzGPgF31SOVvgquBpLkqthvoFPem3sZ?=
 =?us-ascii?Q?kVAmtaChPNADZtnuDuMjRQF9sQSxdWjDlXZc6Vxl3Kt5X3Laei7O420+2kJ1?=
 =?us-ascii?Q?EDIVMnpMi0Q7AEpRVDNtbprX4RDtn2t1Vz3+M4jojl7VRyzpKMQJnJdvndzM?=
 =?us-ascii?Q?9G151c9+/hA8ljFUGEh0r7zSIHJ3Q0A3d/P7Wfy9YlrnGPr7Vo9SvPF9WfKH?=
 =?us-ascii?Q?jb5uOtQMwy2OgGSgaUfWbYKB0gc195dQVRuzhvK2ePdPrepOcjr6cvEVGiyl?=
 =?us-ascii?Q?bzXiyJJT/78syjcaQgOPAKYyeqF6L3Rmi1K4GbZSNZnvNru+5tUTvQiOVlPu?=
 =?us-ascii?Q?vxLoq8MSFMUpBduXxqolGtFKLuGIpZ7h6ByHGT2yStJKmfRpoU2dMn9a1YFx?=
 =?us-ascii?Q?skJ3NAqaRyMLqehlAhaD8oPDhDGmtDvTkCZ2JWrhnaRXLMjyR4DUe1mw6C8h?=
 =?us-ascii?Q?Flk5EKSb+NSMhyOlN4BfXtVVkVSpYltnHeCU8MX4bv65QZGLJzgTk2TDhBJS?=
 =?us-ascii?Q?QyYwWc6+AkDN4jcN2zKnsvwI7jDkCRwaRd7rOZQ4TA7qecPIq1qZQluMVgI0?=
 =?us-ascii?Q?Syv+gdt5HlEJSyuGZXk7LqfvPg4wFN7CKz6LDSiWSuk2+cdNBUp+2khSybLk?=
 =?us-ascii?Q?urHZpuaLnmytfERpLix3Lkb1gRkLTjDluXDcpii+cS1WJbHqx4FtUGNC2Vyu?=
 =?us-ascii?Q?7g18VnmErVIJuQnhRHqdZJiJWdq5PytJswIOzSv/GEFibAW0JnvAJW9WcVXd?=
 =?us-ascii?Q?wLNqmDvYfDM6RtxR18EvH/TgijhZWVkgcmFcwRpdnRHwqCdM/gg8ZeKh0fA5?=
 =?us-ascii?Q?gXHuUabszhHHxXXQAkQ8w33IojVX0/v/5Nan4ShvwLV6fTS+WfiZ/3fFZHeK?=
 =?us-ascii?Q?3nn6drPC3vT4DKa3KObasV6HC0tMWMz7WlvcEjmToSBQlKHU+AWEi7P7SFrV?=
 =?us-ascii?Q?BjdSdwg=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?f0GFBRx5UvJBZrk5MUeV0vdrjtKPjgLcA2s9HhLZCD5xKXTUD73Z3mo07B7Z?=
 =?us-ascii?Q?PO6z/y63EkOUUjBmlz1JHzUvmsRS0dQpEh+WLPjrQyuwbO4sX0NJ6E5zDkVo?=
 =?us-ascii?Q?v9L+RJJ6iHj/vQUbjr1TRpTDyEHkV7iXbQ+M02gNp1z8lWySo0VTkZBaH9nW?=
 =?us-ascii?Q?SJWcO5hwboII1KwAuHr1Ih9OmmjIZZjivjOVEGHU7m0cmByX2HzDTGE+xFiw?=
 =?us-ascii?Q?rWFM7MwyqUoBinVfVWPQBQpqgVTma4X3EtI2qH4TF/j6Z3r6KZLJZdOslPof?=
 =?us-ascii?Q?Ti9nubmPaHBcHXLSZgTz+Rsisu4lzCeqwHtjO+Y0ucol03O5LgCumwlkXuvl?=
 =?us-ascii?Q?0gA69ZFQRrk3dHCa/F7LyqRQGx0fiTol6lved0/mfWcHSyIpPtqcv2sTUGDe?=
 =?us-ascii?Q?EUEY5gYiEa2fmY1NY4W+cN5rh/waEsu4i8UvBm2UloFpC8YPVgEuwZEwrTsa?=
 =?us-ascii?Q?dzSLXCl/3/bY52vz+SBZDNF5/+RzGWHDLZVaKCYAY4th9NrRY5H/mgW4qzde?=
 =?us-ascii?Q?THDeuwU2Y8wnKjB4ax8sM4e7pmR98PysFGrk338+5AI1o26yeLigM8JFMbmk?=
 =?us-ascii?Q?JrTqw7NQWA68yMUjEQE7K3tLRR6TSENZsHUHa4f02ZmNUVG4bQRmeydzqyvh?=
 =?us-ascii?Q?qeacKLaPhY5mhA8/2zqzna+l3cXVnFd+geE+lnP4XVC9GQ/c7tUMwF7Hy3pl?=
 =?us-ascii?Q?kG+4T78/nXRLSERSLsA+graZsrxkGU0BuaWLn0OrgaOgNEvXU19W/BYS4FnI?=
 =?us-ascii?Q?Gad3u4r5SiYHxJ2y2F0mQBURIw2rLTBjrseTWk64F+DZiTPmKOEoOTOXW29f?=
 =?us-ascii?Q?DPlq7dzsrFxOgn9NfJiafyjbmoUos/oMKVfw8Yt5HNeies+mI/4yh9So8wfh?=
 =?us-ascii?Q?yuU7husFZF8SqlYCr9IorSwqA8T1f/yEUrCcCDCHxlSVWofR/33+xaThADOu?=
 =?us-ascii?Q?7/pK0Ejny9KOiiyf1lThF/oYMPC4Ylv8blRQ6Z8iKUpX4K8aLZeeN3xcgnsv?=
 =?us-ascii?Q?qwUk4T1ZiV8S+/Q617r3IxzUuKJX7iV+eAlIGly5xwQX72N3+/dHT2kIcBVU?=
 =?us-ascii?Q?nqF6pcy35k+DcNzBH0ATO/j9223ootkYr6bvg6YNlMOlKn+ZwVlN81DvMrZs?=
 =?us-ascii?Q?/ApKb9TLmqcmCoArmc9+TxqEiwypVc1cK9Zi/O8xxgGTXvAAialms9C5wTHQ?=
 =?us-ascii?Q?tYVvEfVJrFe2VLDoZ3LYVLyu2PkzZx8vXYqZ8vGWjb8c6PUdRSVcJJubFn3F?=
 =?us-ascii?Q?fYuA64plKLY3knBjgD1Bz3lPf/G0aXwnKgr3W3H7EhYPcYnMUlWXlOpgRTKk?=
 =?us-ascii?Q?g+61qbtjsc8s4KITCGJ8Ytg8DUcGDvO/gSpA5b1v6diOw9XZUBs0hwcDIvgz?=
 =?us-ascii?Q?OkY9HfFkoLK2nySiQtsTvx3HGcmV2gah+f6CLG5JYnBWBceVpJtZvW5HFGbl?=
 =?us-ascii?Q?08eqt5b8yQZiQ185J2ZMMZ9khDoIMLrcFRNEa6BoMm/Dwpuzss4OlCzMogOE?=
 =?us-ascii?Q?TS8dzzfX5SGdEVk65ohp3Qp16j7CNDFDRf+juZv4VQYvbRwh4ck8GFbmM72+?=
 =?us-ascii?Q?D2RTIIT5QS2M4ccwbQg5Lp2JGHycZA5ehBkplfJs?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 5499a502-6318-4132-0de1-08dcff0f87e2
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Nov 2024 09:35:34.8993
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PSDKJCQ+2JRYZLI8c7aYBskDcKgpqYSgZ4uUuE5BeUkqz/TEqBbKsQcyUL18TTpqiBZt0XhEUmitLPkwn4QDtQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4846
X-OriginatorOrg: intel.com

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Monday, November 4, 2024 9:20 PM
>
> @@ -3404,8 +3404,18 @@ static void iommu_remove_dev_pasid(struct
> device *dev, ioasid_t pasid,
>  				   struct iommu_domain *domain)
>  {
>  	const struct iommu_ops *ops =3D dev_iommu_ops(dev);
> +	struct iommu_domain *blocked_domain =3D ops->blocked_domain;
> +	int ret =3D 1;
> +
> +	if (blocked_domain && blocked_domain->ops->set_dev_pasid) {
> +		ret =3D blocked_domain->ops->set_dev_pasid(blocked_domain,
> +							 dev, pasid, domain);
> +	} else if (ops->remove_dev_pasid) {
> +		ops->remove_dev_pasid(dev, pasid, domain);
> +		ret =3D 0;
> +	}
>=20

given ops->remove_dev_pasid is already checked at attach time
here could just call it w/o further check.

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

