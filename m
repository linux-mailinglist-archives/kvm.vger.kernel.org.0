Return-Path: <kvm+bounces-33838-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 45F7B9F2BBE
	for <lists+kvm@lfdr.de>; Mon, 16 Dec 2024 09:27:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4DC847A1F20
	for <lists+kvm@lfdr.de>; Mon, 16 Dec 2024 08:26:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1EDAE1FFC44;
	Mon, 16 Dec 2024 08:26:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ciuqMwav"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E4BF1F7541
	for <kvm@vger.kernel.org>; Mon, 16 Dec 2024 08:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734337609; cv=fail; b=CYpHoOysbH95TZVe70EGXGXsWNMddiRdbpTq3sPd/I+AQyYwd8JVSUnZhfvvIjN9XgIai85GpnyTOf/jfFeMOLQdShot1axgRTdOaPQjw2wna06jQLnbu5s9v76j+DrkwjkX3dHtd2lO12Q3Ky34V2RU+Hqgt57yqvwD4sShQks=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734337609; c=relaxed/simple;
	bh=M/hvmgN3EjH9s8u9ZsKuJVaSnpY4nrW+07wrPc6yA/M=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=T0QuPAvKLCyW1oRrCgwRAwRE4kICUjyYwd2M7ADMe2hpZCZPmoDMFiJnQlyeuiZdwrhzf9Et24i2RODrJm2PkmEh39asB2kmJSHPFh0T8bydUAIghh5EfJUqh85EWJGzpbl6UrKgbz2/jJtOMoCZgIhBEboAbqZt7KmVR3UOvz0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ciuqMwav; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1734337607; x=1765873607;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=M/hvmgN3EjH9s8u9ZsKuJVaSnpY4nrW+07wrPc6yA/M=;
  b=ciuqMwavUMCpAbFBJgmh2+MU1CYN94F4upfYZOpWJDQKuGasDDQq6sLh
   d1rTwL/iBrMUFPNDDPxTe3/5i+iZkNUyf6rpFKYSWMPnRIf826e6dv6pZ
   DdPtl2zYL/O5vWnrNsHExX/WijZNNX3BvdMg+XfALcNpr0PKa68bkfXV9
   hnvUv3mPKpPqDnGmHfXvnP2fNIpOk1PucFIAY4VvYy6rLVbK8Lr7yNADj
   +IqM71hiEUTsHyRWu5cvb6YAB9VBDqNkWHZvuQH2vQe7aHQo1srIH6BLH
   BE5EkUmye7JJAMAo96PI1xIBReBLp0HMji/QhQw2aYk+jRQqA3CTCA7Bn
   Q==;
X-CSE-ConnectionGUID: EvjFlJ6ET5WARKTZ8rlDvw==
X-CSE-MsgGUID: WY+xkjhcS9aeEZsBq3nY1w==
X-IronPort-AV: E=McAfee;i="6700,10204,11287"; a="57196472"
X-IronPort-AV: E=Sophos;i="6.12,238,1728975600"; 
   d="scan'208";a="57196472"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2024 00:26:39 -0800
X-CSE-ConnectionGUID: GCUodrX+Tb2Vhr4DTl5Snw==
X-CSE-MsgGUID: 3D+V46npSXO6ewZ2KLOoYw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,238,1728975600"; 
   d="scan'208";a="97036117"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa009.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 16 Dec 2024 00:26:40 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Mon, 16 Dec 2024 00:26:39 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Mon, 16 Dec 2024 00:26:39 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.47) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 16 Dec 2024 00:26:36 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nb1FnsLBeKAaWKswwOjVBpfbUBAib7FZWFe+nAhRAhT3H+SXgabFoRuCKf0JpRc1sVPS5i7LNyOS/TCZMwOgJo/ZzUFEvC/B8PENxs57WQk24SYl/VDthQbmV3wA8GGApdCSZA1SFCURckOA3Al8WaUw1IB4Y+I+3mXDqKMahVJe+RgjcbjmwpJZfF6WYqaj0IncZudH7JZKkr2bodLb9CUi33MviJ626yLwNGcK47WA+BpJt9XKkTumvJicZZi6v4R+ZeExelFDvBJApkMTSrY64ePQ3eWlTyohNdfnnYtGCF1Qo+05xrr/l5ZveOXNgQSXD1UmszZg1gRlGKnY+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M/hvmgN3EjH9s8u9ZsKuJVaSnpY4nrW+07wrPc6yA/M=;
 b=YtlmJPA85q5/OA0g+C7CZ8WxJ+BFUR1JIdvmCRkaIhySGUnHqXqdGd9uh1AhgeGNXXp6QsmsoYo8VGTIpy0JZFPSqHlXaTuIWbSX8laKJ7fM3I71fStzWm+Od5QFTZyRLhXd0ZBqU9PqxEqhaQ2uLovVSK8RDfCbc40OnJIXVFwse5KhOm63nzrF/tZ64XtI/QFoSit+0pewHp/0pD/UbMx7WzOCZ/rZqcZ4PGdRtL55xhlohgoTV8r7rQ6wBtoWn5jcGjq1UIGVlIyD5YMRo9vrsM7gg/RaZ274hWfsmExnD1gE2woBg5HQMkeMbrhK22WzAXVhguSYZXjv+aghLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DS7PR11MB7905.namprd11.prod.outlook.com (2603:10b6:8:ed::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8251.18; Mon, 16 Dec
 2024 08:26:21 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%5]) with mapi id 15.20.8251.015; Mon, 16 Dec 2024
 08:26:21 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: "Liu, Yi L" <yi.l.liu@intel.com>, Jason Gunthorpe <jgg@nvidia.com>
CC: "joro@8bytes.org" <joro@8bytes.org>, "baolu.lu@linux.intel.com"
	<baolu.lu@linux.intel.com>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, "eric.auger@redhat.com"
	<eric.auger@redhat.com>, "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "chao.p.peng@linux.intel.com"
	<chao.p.peng@linux.intel.com>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
	"vasant.hegde@amd.com" <vasant.hegde@amd.com>
Subject: RE: [PATCH v5 08/12] iommufd: Enforce pasid compatible domain for
 PASID-capable device
Thread-Topic: [PATCH v5 08/12] iommufd: Enforce pasid compatible domain for
 PASID-capable device
Thread-Index: AQHbLr0MyG3oX7KdYkCnpIbZw3bHE7LZC5CAgACnwQCAARp4AIADagUAgADOLICAAe0wYIABN4YAgAAqgnCAABfyAIABQn8AgABRs4CAAAYGcIAAU5KAgAFV6gCAAxWxAA==
Date: Mon, 16 Dec 2024 08:26:20 +0000
Message-ID: <BN9PR11MB52764D0A5AD30E7ECC7F95E18C3B2@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0f93cdeb-2317-4a8f-be22-d90811cb243b@intel.com>
 <20241209145718.GC2347147@nvidia.com>
 <9a3b3ae5-10d2-4ad6-9e3b-403e526a7f17@intel.com>
 <BN9PR11MB5276563840B2D015C0F1104B8C3E2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <a9e7c4cd-b93f-4bc9-8389-8e5e8f3ba8af@intel.com>
 <BN9PR11MB52762E5F7077BF8107BDE07C8C3F2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <98229361-52a8-43ef-a803-90a3c7b945a7@intel.com>
 <BN9PR11MB5276E01F29F76F38BE4909828C382@BN9PR11MB5276.namprd11.prod.outlook.com>
 <c91ea47c-ca71-4b37-b66c-821c92e3d191@intel.com>
 <BN9PR11MB5276655399B4523F4CEEA63D8C382@BN9PR11MB5276.namprd11.prod.outlook.com>
 <Z1wrQ+kgV53BsodW@nvidia.com>
 <46b7fc65-491f-4965-9d9b-d77901e41dfc@intel.com>
In-Reply-To: <46b7fc65-491f-4965-9d9b-d77901e41dfc@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|DS7PR11MB7905:EE_
x-ms-office365-filtering-correlation-id: 76d9ccd3-a78c-48a9-b529-08dd1dab5217
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?YmlDRHNmQ0ZOb0F6T0swOXo0UHJwaVcwODIzZG44Qi80SEM3aHM3UVpMTVlh?=
 =?utf-8?B?Y01PZVkyYUZrbDlZNHIzblN5NDNhTzIydFhaUlltVjRUaStPMXk5UkZDQXBR?=
 =?utf-8?B?RGZtd0RaT3BORk9NZGUyNHlHSEVGMXlpMW9SMThUMHU0WE1XSzZMbkRmb3Iw?=
 =?utf-8?B?Z1RsS3NnUkczenJZNmFVUnZnekpFS0hzL3hQQmxHUXlPUElRU1pCS3BCeGwy?=
 =?utf-8?B?a3M4Y3BuMm5EcWk3S1FrYWpabmxVZCtEUmx0VHcyTGhDallBSTh1NXpqa0FJ?=
 =?utf-8?B?eWlSU24yUmtrNUg5OUVqNEsxL3dBRVVFTGVUa0RFY3hYY0pjMWI2eWc1UkQ0?=
 =?utf-8?B?T0k1UStWQnlzcGpLRjJFSXliNFRwV2tnTkl3M1ltUUs1K29HalZUbC9GODU3?=
 =?utf-8?B?SVFPcFlaQWgxOE1Kd0daYjJIb2t2ZSt4WG1PR25ieFhxM3oyS2xZTFpEWjYw?=
 =?utf-8?B?M1d2ZW5VQ0VqWExhSUpDVjlkOGZ4TENsYlo1dUdOa1JoVm1zWkhPWFhheUsr?=
 =?utf-8?B?TzlKeDVoWVRxTXhnTlhRWElLdjF1RGxoRDdzQ21mUXVYNUhnTHliWEhwM2Zz?=
 =?utf-8?B?eWlsQUVqcDFqNUMzRVVWV3FyWE1hNVoxNmh2bkg1VG9IZWt6cklJRklPRkVv?=
 =?utf-8?B?YTlCall0SUJkN3ZjajR3ZDZHNU1hcXFsWHNGWDd3alU3Smx4RU8wWk9LaU1a?=
 =?utf-8?B?V3VKTU5WcDlTNVNiY0pIcVpIbG9teEowOHh5ZU1jb3JoaDhpR2lJU0RxMTl0?=
 =?utf-8?B?QkRZVkt6cUMzT3lublg0OU5WTm40cU9wbFlzRGcwV3BmSFY0bWdqMFErdHpO?=
 =?utf-8?B?ZDRleHJoeTIzTFgwbWUzL1JNSTZqT29aNUxiS3dyUnNQczFINFlld21HTllr?=
 =?utf-8?B?UCsvMUtTRFlIZHB2ZjM1SkdyYUw3WGlFWUJJYVE3U3ExWDdoLzRxL0xqaVNX?=
 =?utf-8?B?SDVWUXRnd3B4RFoxMWkxVzdhNy95c3RqMEc1NTVmU3BMSGVrSzBIZTBYWjV5?=
 =?utf-8?B?WXZUOTJtdGxtQjM4S0Evc3pKdms3eEdueHpsd043N08yL0p2NmFwcmVib09B?=
 =?utf-8?B?V2I1YWhTc2gveTRFdDAwZmZlVkZ5b2RhWUkvcURrZW1sQW1JeTJaYTRhSmV1?=
 =?utf-8?B?aFVpbWRDdGdOaEtpWWlLMHRhRTlxbnYrMmpIM1dOMGxoSnVteDN4UnhnMmoy?=
 =?utf-8?B?MHVZbnVhcktVT08zUEVKWk9kMUZTMjM4RSt4SWVsamxOcEFUV2dra0YzN3M3?=
 =?utf-8?B?MUtQNXNjK01UTDV0b3pJMjQ5V1FrZXBsaVJrK1ZXcWtJV0k0ejgzMTA4UEpn?=
 =?utf-8?B?OUNCRDRIRzM5dzRITWJKY1VtbVNkcS8zK09vN1lkM2xpYmR1WFpWRVZjMmht?=
 =?utf-8?B?YlZLWHI5SDRlQjFqTzVFL1N3ZEN6TFloNTZvSC9tRDFpS1dyYzEvVXdDZHRB?=
 =?utf-8?B?b0J1QVpFblRib3hjYzZ1ajNGUmNuMnEvaWxlamhlQUlEeEovNGJMTGhBcUpz?=
 =?utf-8?B?RkFNNWNid0Q2VXJkR2dTT0lOUlZuODlPVHNOU0hlQnV3VUtxSXZvck1oQ2VP?=
 =?utf-8?B?V1lkUXlaZ3loU1o4MWtpZ3BHYWdhdzhEVFQ2aFZZeWU1QVJqSGg3MXFxUU5T?=
 =?utf-8?B?ZStSazVUMk12cmhKQm0xSXEyaW5UVElyZU4xSjBLYjBmT2w2OTd4WU8rY2Zm?=
 =?utf-8?B?WEdISEF5M25QUUZWQkJ4MlZNM2VFQ0tHSVk3bWs1dEM3RFRmUHkzMmlkdjFv?=
 =?utf-8?B?UUlxNEhjaCtqeTBDN3YyM0RzNFNLaElndkRaMkxZaSs3VXVPb3o3NHR4aVBt?=
 =?utf-8?B?am54SWtmY2FwbWpVcTdGdWVZaFlaU1Vqdm8wZnlaNzFiUDAyTkZhRGZtOE5O?=
 =?utf-8?B?RjROd3U0WTdlSmtXa1g5bTRLRXFHM2phL0RWc1IzYVB6cHBwcDlNaVJYZjYz?=
 =?utf-8?Q?V4E3wX9HtjMSJqb9d7K7vaCQBkStxdbG?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cmN6ZHVHQ3AxcHJnUHZUU1hXRFo2N3g1TEQ0c0M5U0xFakZjd3dYK3dEd3dV?=
 =?utf-8?B?ZWJuWFVPT2VjM3lKdFNtWVhkaXlGVjJPOTJvQllXR01XM2R1UG1LUGluZFk1?=
 =?utf-8?B?RDBIeDRUZGExajRuSWFvMjRHYzRwaDA3dkpBdE54M0o3WjFSanRMcSs4azZ2?=
 =?utf-8?B?RGZpVkN1WktRbVVBWE9NVnZSWGY3L1NLN1d1MzRjQVVPSGM5M3licG4vUWNn?=
 =?utf-8?B?ejdXSVRTWE94MUszc3hMNzRzem9laEVoRmRUOGNRM2d1Z05lbHJoQ01LSFM4?=
 =?utf-8?B?VWhKQkMwYlhTUmNIWkFQdnlhYkFGMC9MRHlaeTBHS2JnTUJ0b3l6QldEcVd4?=
 =?utf-8?B?Sk5aOCt4NGRTNXNPZUR5SjdVTFVyM256dXJDUEMzUkJxanRCVWJOcEUyc1NR?=
 =?utf-8?B?eS83aUFHVCswS1lwajB0bFJCM2RBaWtXanIwRXJSY0JiOWlBVWF4U3A4cDQv?=
 =?utf-8?B?c21Ia0JlMEhONU9qZkgzNnp2RFJaamR1UzdBbkdPVGZ2MllRSk4yTUxJTHFQ?=
 =?utf-8?B?SzJsNlcrZzNFTFFRb1hNemphMUx1NnV4WC95RjRBK2Fxa3FUM2dtZkloQWZP?=
 =?utf-8?B?a0xobU5BZXNXYVM5TUdGQlY3Tk9lREFiRWd5Y1FFQWtXcmpMZmFTSEQ1bnJD?=
 =?utf-8?B?V2tQSU1SRWhSQURiSkF1MkU4VkExMklBM2x4ZjQ1MEdtOWxaV2YyRUFmcXlv?=
 =?utf-8?B?UHBGWDhFWGI0ZW4rVE45T2cwcmdHTjdpbS9aWmZlUDQrbUJpQUVwQU5WMGc4?=
 =?utf-8?B?eHNsWCtBNVJjalczZGpTTzFlK01laUcwOERpeDM2eEIrbTJVNld6aG1GUllo?=
 =?utf-8?B?alZuYUdxMDZvRHNVYk8rdkxNS0RvOUtTaTRGWGw1UDBHdlpxa2hYQ0FBUlVY?=
 =?utf-8?B?TkZaU2czYzBQZVVZSEhqYXRaT2R6V0VHQnFYeGNoeWNKV3BtUEFEcysvTkpY?=
 =?utf-8?B?TC9OMTZhUDRYWXV5aDVhbFRJZlU2bFppY3Q4WktZV1dFejdJMitOK2ZMT1VV?=
 =?utf-8?B?N0s4eGVsbW9rQmo1TFVkV0JKRWlBeG50WHM0K3ppS1k4dXIzVUoxcUZtSko1?=
 =?utf-8?B?RWJtajMzenFuN2J0QW9nMFg3RUN0SHhYVUJaVE9GSUU0OEVrWURFWEFZcUt1?=
 =?utf-8?B?SlRNOXpnOEZJdzY1QlJGRG5PUG1hVVVOWkU0TkZzVmFqeXpTd0kxZlRWRjVU?=
 =?utf-8?B?eTRsZW13NDJ4enYrSWRLVEdsMExJRll6SjZEci9wa1NjWldLUFVEL01YZTYz?=
 =?utf-8?B?UTRPbCsxT0NrVFAxNG5NSTZrUkJacXI3MWk1b1RmcE54dDNVanpld0pSckVi?=
 =?utf-8?B?RGVodDlpcmxocjIrb1E2TUU5R0tBbm03cS9XUURCYUpoeExIbEV2KzBEVTVE?=
 =?utf-8?B?b0VveTZsTWNQZndyeDZwOGVQNFVCa0p0Z1ZSb3pUSS9iWkc0djRzQllIeTh6?=
 =?utf-8?B?bmtWMVBGSFBYbWNpN21ONThUK2tKSHZ6azR1eVRWWWFmbEhTY3Exek40alo2?=
 =?utf-8?B?NUQ1andINWNISndwVWZZc1hoSEZkaEVLdTR6QlBZTDBidGtqaGRZeXZlaEVQ?=
 =?utf-8?B?ckZLdjd5ditDQTB3ZCtUakt1TUlKQjRmQytoZmRpa2xYMHBreTdqSVFtZE5E?=
 =?utf-8?B?dVVXTU5waGlob0NMTkIwNWFJQjltV1FWSXBaR0M5YUV4aDdQdnJ1MHkvUWFm?=
 =?utf-8?B?REtYNnJxSFpmcWp3a0JUMml0UEdjYWxVQkVSVDZlSmM1Rkkydkd3b3Q0OFRh?=
 =?utf-8?B?Tkd3aU9tWWFiWVFNb0prNGZodDBmazJRLzF3Uk1EWDF0VjVTSnZtQk91QTdr?=
 =?utf-8?B?Tmc0M3kxV01vcDVmTjNSTk8wSlhVOWI2OXhXR0QyK2s3a2dSOTJGZHhzdSt1?=
 =?utf-8?B?aklrZmk3bVBlVUd5d3cxbTBvSUtlMTJqQjlKWDc2YlJISXRNcmNLeTlMRGdL?=
 =?utf-8?B?bC9LbW8vSnNxTTRJNFltZHFWQ3JJSExBZk1tWFhpaUViT3BlQmFNNFVyTlFR?=
 =?utf-8?B?dGlGQzNMSnZkQmVsTTFEZUpjVFdVbVIvUXNIbzQ0cnJrNFdrRnhWdjZUSFpB?=
 =?utf-8?B?TThRK1NnWjVrOTlrNXlMb3RtMzZwTUVqYThUWmtjdk53QU5SRnhvZ2V0c1pa?=
 =?utf-8?Q?nK8Ex1tpilzO6yZEjheQ7fjOU?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 76d9ccd3-a78c-48a9-b529-08dd1dab5217
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Dec 2024 08:26:21.0095
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 38pdZBJ2znH5X9EvXoVetbHas+QyVgXVQSImIVKZedgPlI92r2w7/Hkeb4M4aofYt9Sy2kRa3qdxccT+fqfxbQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB7905
X-OriginatorOrg: intel.com

PiBGcm9tOiBMaXUsIFlpIEwgPHlpLmwubGl1QGludGVsLmNvbT4NCj4gU2VudDogU2F0dXJkYXks
IERlY2VtYmVyIDE0LCAyMDI0IDU6MDQgUE0NCj4gDQo+IE9uIDIwMjQvMTIvMTMgMjA6NDAsIEph
c29uIEd1bnRob3JwZSB3cm90ZToNCj4gPiBPbiBGcmksIERlYyAxMywgMjAyNCBhdCAwNzo1Mjo0
MEFNICswMDAwLCBUaWFuLCBLZXZpbiB3cm90ZToNCj4gPg0KPiA+PiBJJ20gbm90IHN1cmUgd2hl
cmUgdGhhdCByZXF1aXJlbWVudCBjb21lcyBmcm9tLiBEb2VzIEFNRCByZXF1aXJlIFJJRA0KPiA+
PiBhbmQgUEFTSUQgdG8gdXNlIHRoZSBzYW1lIGZvcm1hdCB3aGVuIG5lc3RpbmcgaXMgZGlzYWJs
ZWQ/IElmIHllcywgdGhhdCdzDQo+ID4+IHN0aWxsIGEgZHJpdmVyIGJ1cmRlbiB0byBoYW5kbGUs
IG5vdCBpb21tdWZkJ3MuLi4NCj4gPg0KPiA+IFllcywgQVJNIGFuZCBBTUQgcmVxdWlyZSB0aGlz
IHRvbw0KPiA+DQo+ID4gVGhlIHBvaW50IG9mIHRoZSBpb21tdWZkIGVuZm9yY2VtZW50IG9mIEFM
TE9DX1BBR0lORyBpcyB0byB0cnkgdG8NCj4gPiBkaXNjb3VyYWdlIGJhZCBhcHBzIC0gaWUgYXBw
cyB0aGF0IG9ubHkgd29yayBvbiBJbnRlbC4gV2UgY2FuIGNoZWNrDQo+ID4gdGhlIHJpZCBhdHRh
Y2ggdG9vIGlmIGl0IGlzIGVhc3kgdG8gZG8NCj4gDQo+IEkgaGF2ZSBhbiBlYXN5IHdheSB0byBl
bmZvcmNlIFJJRCBhdHRhY2guIEl0IGlzOg0KPiANCj4gSWYgdGhlIGRldmljZSBpcyBkZXZpY2Ug
Y2FwYWJsZSwgSSB3b3VsZCBlbmZvcmNlIGFsbCBkb21haW5zIGZvciB0aGlzDQo+IGRldmljZSAo
ZWl0aGVyIFJJRCBvciBQQVNJRCkgYmUgZmxhZ2dlZC4gVGhlIGRldmljZSBjYXBhYmxlIGluZm8g
aXMgc3RhdGljLA0KPiBzbyBubyBuZWVkIHRvIGFkZCBleHRyYSBsb2NrIGFjcm9zcyB0aGUgUklE
IGFuZCBQQVNJRCBhdHRhY2ggcGF0aHMgZm9yIHRoZQ0KPiBwYWdlIHRhYmxlIGZvcm1hdCBhbGln
bm1lbnQuIFRoaXMgaGFzIG9ubHkgb25lIGRyYXdiYWNrLiBJZiB1c2Vyc3BhY2UgaXMNCj4gbm90
IGdvaW5nIHRvIHVzZSBQQVNJRCwgaXQgc3RpbGwgbmVlZHMgdG8gYWxsb2NhdGVkIGRvbWFpbiB3
aXRoIHRoaXMgZmxhZy4NCj4gSSB0aGluayBBTUQgbWF5IG5lZWQgdG8gY29uZmlybSBpZiBpdCBp
cyBhY2NlcHRhYmxlLg0KDQpJdCdzIHNpbXBsZSBidXQgYnJlYWsgYXBwbGljYXRpb25zIHdoaWNo
IGFyZSBub3QgYXdhcmUgb2YgUEFTSUQuIElkZWFsbHkNCmlmIHRoZSBhcHAgaXMgbm90IGludGVy
ZXN0ZWQgaW4gUEFTSUQgaXQgaGFzIG5vIGJ1c2luZXNzIHRvIHF1ZXJ5IHRoZSBQQVNJRA0KY2Fw
IGFuZCB0aGVuIHNldCB0aGUgZmxhZyBhY2NvcmRpbmdseS4NCg0KPiANCj4gQEtldmluLCBJJ2Qg
bGlrZSB0byBlY2hvIHRoZSBwcmlvciBzdWdnZXN0aW9uIGZvciBuZXN0ZWQgZG9tYWluLiBJdCBs
b29rcw0KPiBoYXJkIHRvIGFwcGx5IHRoZSBwYXNpZCBlbmZvcmNlbWVudCBvbiBpdC4gU28gSSdk
IGxpa2UgdG8gbGltaXQgdGhlDQo+IEFMTE9DX1BBU0lEIGZsYWcgdG8gcGFnaW5nIGRvbWFpbnMu
IEFsc28sIEkgZG91YnQgaWYgdGhlIHVhcGkgbmVlZHMgdG8NCj4gbWFuZGF0ZSB0aGUgUklEIHBh
cnQgdG8gdXNlIHRoaXMgZmxhZy4gSXQgYXBwZWFycyB0byBtZSBpdCBjYW4gYmUgZG9uZQ0KPiBp
b21tdSBkcml2ZXJzLiBJZiBzbywgbm8gbmVlZCB0byBtYW5kYXRlIGl0IGluIHVhcGkuIFNvIEkn
bSBjb25zaWRlcmluZw0KPiB0byBkbyBiZWxvdyBjaGFuZ2VzIHRvIElPTU1VX0hXUFRfQUxMT0Nf
UEFTSUQuIFRoZSBuZXcgZGVmaW5pdGlvbg0KPiBkb2VzIG5vdA0KPiBtYW5kYXRlIHRoZSBSSUQg
cGFydCBvZiBkZXZpY2VzLCBhbmQgbGVhdmVzIGl0IHRvIHZlbmRvcnMuIEhlbmNlLCB0aGUNCj4g
aW9tbXVmZCBvbmx5IG5lZWRzIHRvIGVuc3VyZSB0aGUgcGFnaW5nIGRvbWFpbnMgdXNlZCBieSBQ
QVNJRCBzaG91bGQgYmUNCj4gZmxhZ2dlZC4gZS5nLiBJbnRlbCB3b24ndCBmYWlsIFBBU0lEIGF0
dGFjaCBldmVuIGl0cyBSSUQgaXMgdXNpbmcgYSBkb21haW4NCj4gdGhhdCBpcyBub3QgZmxhZ2dl
ZCAoZS5nLiBuZXN0ZWQgZG9tYWluLCB1bmRlciB0aGUgbmV3IGRlZmluaXRpb24sIG5lc3RlZA0K
PiBkb21haW4gZG9lcyBub3QgdXNlIHRoaXMgZmxhZykuIFdoaWxlLCBBTUQgd291bGQgZmFpbCBp
dCBpZiB0aGUgUklEIGRvbWFpbg0KPiBpcyBub3QgdXNpbmcgdGhpcyBmbGFnLiBUaGlzIGhhcyBv
bmUgbW9yZSBiZW5lZml0LCBpdCBsZWF2ZXMgdGhlDQo+IGZsZXhpYmlsaXR5IG9mIHVzaW5nIHBh
c2lkIG9yIG5vdCB0byB1c2VyLg0KPiANCj4gZGlmZiAtLWdpdCBhL2luY2x1ZGUvdWFwaS9saW51
eC9pb21tdWZkLmggYi9pbmNsdWRlL3VhcGkvbGludXgvaW9tbXVmZC5oDQo+IGluZGV4IDBlMjc1
NTdmYjg2Yi4uYTFhMTEwNDFkOTQxIDEwMDY0NA0KPiAtLS0gYS9pbmNsdWRlL3VhcGkvbGludXgv
aW9tbXVmZC5oDQo+ICsrKyBiL2luY2x1ZGUvdWFwaS9saW51eC9pb21tdWZkLmgNCj4gQEAgLTM4
NywxOSArMzg3LDIwIEBAIHN0cnVjdCBpb21tdV92ZmlvX2lvYXMgew0KPiAgICAqICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICBlbmZvcmNlZCBvbiBkZXZpY2UgYXR0YWNobWVudA0K
PiAgICAqIEBJT01NVV9IV1BUX0ZBVUxUX0lEX1ZBTElEOiBUaGUgZmF1bHRfaWQgZmllbGQgb2Yg
aHdwdCBhbGxvY2F0aW9uDQo+IGRhdGEgaXMNCj4gICAgKiAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgdmFsaWQuDQo+IC0gKiBASU9NTVVfSFdQVF9BTExPQ19QQVNJRDogUmVxdWVzdHMgYSBk
b21haW4gdGhhdCBjYW4gYmUgdXNlZA0KPiB3aXRoIFBBU0lELiBUaGUNCj4gLSAqICAgICAgICAg
ICAgICAgICAgICAgICAgICBkb21haW4gY2FuIGJlIGF0dGFjaGVkIHRvIGFueSBQQVNJRCBvbiB0
aGUgZGV2aWNlLg0KPiAtICogICAgICAgICAgICAgICAgICAgICAgICAgIEFueSBkb21haW4gYXR0
YWNoZWQgdG8gdGhlIG5vbi1QQVNJRCBwYXJ0IG9mIHRoZQ0KPiAtICogICAgICAgICAgICAgICAg
ICAgICAgICAgIGRldmljZSBtdXN0IGFsc28gYmUgZmxhZ2dlZCwgb3RoZXJ3aXNlIGF0dGFjaGlu
ZyBhDQo+IC0gKiAgICAgICAgICAgICAgICAgICAgICAgICAgUEFTSUQgd2lsbCBibG9ja2VkLg0K
PiAtICogICAgICAgICAgICAgICAgICAgICAgICAgIElmIElPTU1VIGRvZXMgbm90IHN1cHBvcnQg
UEFTSUQgaXQgd2lsbCByZXR1cm4NCj4gLSAqICAgICAgICAgICAgICAgICAgICAgICAgICBlcnJv
ciAoLUVPUE5PVFNVUFApLg0KPiArICogQElPTU1VX0hXUFRfQUxMT0NfUEFHSU5HX1BBU0lEOiBS
ZXF1ZXN0cyBhIHBhZ2luZyBkb21haW4gdGhhdA0KPiBjYW4gYmUgdXNlZA0KPiArICogICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICB3aXRoIFBBU0lELiBUaGUgZG9tYWluIGNhbiBiZSBh
dHRhY2hlZCB0bw0KPiArICogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBhbnkgUEFT
SUQgb24gdGhlIGRldmljZS4gVmVuZG9ycyBtYXkNCj4gcmVxdWlyZQ0KPiArICogICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICB0aGUgbm9uLVBBU0lEIHBhcnQgb2YgdGhlIGRldmljZSB1
c2UgdGhpcw0KPiArICogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBmbGFnIGFzIHdl
bGwuIElmIHllcywgYXR0YWNoaW5nIGEgUEFTSUQNCj4gd2lsbA0KPiArICogICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICBibG9ja2VkIGlmIG5vbi1QQVNJRCBwYXJ0IGlzIG5vdCB1c2lu
ZyBpdC4NCj4gKyAqICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgSWYgSU9NTVUgZG9l
cyBub3Qgc3VwcG9ydCBQQVNJRCBpdCB3aWxsDQo+ICsgKiAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgIHJldHVybiBlcnJvciAoLUVPUE5PVFNVUFApLg0KPiAgICAqLw0KPiAgIGVudW0g
aW9tbXVmZF9od3B0X2FsbG9jX2ZsYWdzIHsNCj4gICAJSU9NTVVfSFdQVF9BTExPQ19ORVNUX1BB
UkVOVCA9IDEgPDwgMCwNCj4gICAJSU9NTVVfSFdQVF9BTExPQ19ESVJUWV9UUkFDS0lORyA9IDEg
PDwgMSwNCj4gICAJSU9NTVVfSFdQVF9GQVVMVF9JRF9WQUxJRCA9IDEgPDwgMiwNCj4gLQlJT01N
VV9IV1BUX0FMTE9DX1BBU0lEID0gMSA8PCAzLA0KPiArCUlPTU1VX0hXUFRfQUxMT0NfUEFHSU5H
X1BBU0lEID0gMSA8PCAzLA0KPiAgIH07DQo+IA0KDQpJJ20gYWZyYWlkIHRoYXQgZG9pbmcgc28g
YWRkcyBtb3JlIGNvbmZ1c2lvbiBhcyBvbmUgY291bGQgZWFzaWx5DQphc2sgd2h5IHN1Y2ggZW5m
b3JjZW1lbnQgaXMgb25seSBhcHBsaWVkIHRvIHRoZSBwYWdpbmcgZG9tYWluLg0KDQpQbGVhc2Ug
bm90ZSB0aGUgZW5kIHJlc3VsdCBvZiBuZXN0aW5nIGRvbWFpbiBjYW4gc3RpbGwgbWVldCB0aGUN
CnJlc3RyaWN0aW9uLg0KDQpGb3IgQVJNL0FNRCB0aGUgbmVzdGluZyBkb21haW4gYXR0YWNoZWQg
dG8gUklEIGNhbm5vdCBzZXQNCkFMTE9DX1BBU0lEIHNvIGl0IGNhbm5vdCBiZSBhdHRhY2hlZCB0
byBQQVNJRCBsYXRlci4NCg0KRm9yIEludGVsIGEgbmVzdGluZyBkb21haW4gYXR0YWNoZWQgdG8g
UklEIGNhbiBoYXZlIHRoZSBmbGFnDQpzZXQgb3IgY2xlYXJlZC4gSWYgdGhlIGRvbWFpbiBpcyBp
bnRlbmRlZCB0byBiZSBhdHRhY2hlZCB0bw0KYSBQQVNJRCBsYXRlciwgdGhlbiBpdCBtdXN0IGhh
dmUgdGhlIEFMTE9DX1BBU0lEIHNldC4NCg0KU28gSSBkb24ndCBzZWUgYSBuZWVkIG9mIGV4ZW1w
dGluZyB0aGUgbmVzdGluZyBkb21haW4gaGVyZS4NCg0KYnR3IHdoYXQgYWJvdXQgcmVxdWlyaW5n
IHRvIGFjcXVpcmUgJmlkZXYtPmlncm91cC0+bG9jaw0KaW4gdGhlIHBhc2lkIHBhdGg/IEl0J3Mg
bm90IGEgcGVyZm9ybWFuY2UgY3JpdGljYWwgcGF0aCwgYW5kDQpieSBob2xkaW5nIHRoYXQgbG9j
ayBpbiBib3RoIFJJRC9QQVNJRCBhdHRhY2gsIHdlIGNhbiBjaGVjaw0KaWRldi0+cGFzaWRfaHdw
dHMgdG8gZGVjaWRlIHdoZXRoZXIgYSBkb21haW4gYXR0YWNoZWQgdG8NClJJRCBtdXN0IGhhdmUg
dGhlIGZsYWcgc2V0IGFuZCB2aWNlIHZlcnNhIHdoZW4gZG9pbmcgcGFzaWQNCmF0dGFjaCB3aGV0
aGVyIGlkZXYtPmlncm91cC0+aHdwdCBhbHJlYWR5IGhhcyB0aGUgZmxhZyBzZXQuDQo=

