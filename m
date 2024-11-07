Return-Path: <kvm+bounces-31060-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 790879BFDCA
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 06:47:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 36074281FBF
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 05:47:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5761B13A26F;
	Thu,  7 Nov 2024 05:46:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WKZtsquz"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7071C6FBF
	for <kvm@vger.kernel.org>; Thu,  7 Nov 2024 05:46:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730958415; cv=fail; b=nn2FVLZSpttEAREoLDQcBTCr9xGTn1To9QEzLL8ZDlqcm38M4Ef3Kx4uMFPPGu8VcI9obmSrZ+qohL6lrYoqjMUvZn15AtJLWBMAbP8D2/I1NzZWdqmkMf0MTUw7ozpm29SFTKlyDoehSObwO8YN766MQ+rvXLuYzZs+c4FSSqA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730958415; c=relaxed/simple;
	bh=tYsLeb70B6Drp+huK5Tkte4pkPmG0VA1PwbLAsrcVZE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=EN1aujS10/DujRY3PNkzAI7JlCefZLKyyemJtpa0LQVP8lrYeLPrQTJ6YNWoaq9E7CXbT1/TfP0q7cphYIgjrHWaPRTM9jzBHs3IFzY3HILsCEfGZdOqPgEZdsIv6ROPkT65gCBj+YjYQ62vRDbh/9e382kHdf1MxUwDlRoPs2s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WKZtsquz; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730958413; x=1762494413;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=tYsLeb70B6Drp+huK5Tkte4pkPmG0VA1PwbLAsrcVZE=;
  b=WKZtsquzxtShe3RQkfWTXF0LrKxxXDqjUNUSNgzrv4EgNMCbsCcA3d7i
   +++i6AUCcv2DkntAyKnzYgVbkv0SSe3zpRbrzRlQiUrn4tM3/kBAeX/ZD
   imAkXDNrTVkQMlfkdAMXFyQZ2Fdr4RmjdD4juxrEHBY5ZTiw1BBz2OKZj
   GDbDH0oSR0d99jEKLDvp2497b3v2j6/Z0xxDGX2YV3tzjV6rHaMWpySK6
   h6QdKn+08i4y5URxh1ZC7kr9OWY6Ndbl3vlXZlZtRU6/pgYtQEdxKmO76
   hkJUTZsI4XF88H1RZHC+Rh41/jjZU5pEYNs39zXP5+pGN3QWgPgaVPOGL
   Q==;
X-CSE-ConnectionGUID: 7USrfJO+T6WaArRM11ukOw==
X-CSE-MsgGUID: /JIk5ukiSoaXA7esLhcDXQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11248"; a="30887489"
X-IronPort-AV: E=Sophos;i="6.11,265,1725346800"; 
   d="scan'208";a="30887489"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2024 21:46:53 -0800
X-CSE-ConnectionGUID: aQEMQlElSkmapQe9qRoThw==
X-CSE-MsgGUID: sMNcCkUUSFyTVSHHxctMiQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,265,1725346800"; 
   d="scan'208";a="85050305"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa006.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Nov 2024 21:46:52 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 6 Nov 2024 21:46:52 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 6 Nov 2024 21:46:52 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.46) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 6 Nov 2024 21:46:52 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vOxgk+Q08GBdz38RmhepnA+QshH5967Ue6E9VfG6ccv5HsvnebPe6GR0+97u5M7Bfsp9eGmMIor+RgBj5MZ0XNxAYOj3rITbq4lkdjUzRvZBU28ZLA16MA4yFhVL54QCZfdOPIvv4dZr6gyWOxM5jozHRGtE+UFcSg6L7pfI8JXWFXPxaXDH7+Rk5dKSMQazhV3beN55ZhKh+pKwMBE4+BefP8idwNgWyzkkRMbd7eEc3taXNZW+M2eFA31SXeaQLSI6uh8eXL2vABWLR6tvSrYayqj7UigcRpkGrlRLBrRyoXVFlpIuauEEgmLywYTgmWxDi2W1E9Q6+Ddx56LkDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tYsLeb70B6Drp+huK5Tkte4pkPmG0VA1PwbLAsrcVZE=;
 b=dlxnBWK2yZvRwDlDYCRmxHafgFG6vXDrufbbbKhdAosAlL8eZnEIZyB5b7BtETtV4zjuF5/LAX8gcdnC9MJwceB8vRVdEWrkzns0NaT9Zaipan+jhNi39almVDqdK+49+bqjZv6Ib/+ifKdSt9PVMGblMACKjJC0Q7MFLNed89iesTKbzcI/f4cbpVF5ihJVlZkOvSI8qfCnE4TCTyz1++2fcWA7HXqcqLxUNgDVwH0Alx/4rh797WxwJ0RNwUhMGVMzjGiTfjHzoHipzGylisgV9JK2CbQg+eaIweAYc7lFPFYaYENCF9rejKicPyluzd4z8l/hQkDsfQDcnZzkYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by PH0PR11MB7660.namprd11.prod.outlook.com (2603:10b6:510:26f::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.19; Thu, 7 Nov
 2024 05:46:49 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%5]) with mapi id 15.20.8137.018; Thu, 7 Nov 2024
 05:46:49 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: "Liu, Yi L" <yi.l.liu@intel.com>, Baolu Lu <baolu.lu@linux.intel.com>,
	"joro@8bytes.org" <joro@8bytes.org>, "jgg@nvidia.com" <jgg@nvidia.com>
CC: "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"eric.auger@redhat.com" <eric.auger@redhat.com>, "nicolinc@nvidia.com"
	<nicolinc@nvidia.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>, "Duan, Zhenzhong"
	<zhenzhong.duan@intel.com>, "vasant.hegde@amd.com" <vasant.hegde@amd.com>,
	"willy@infradead.org" <willy@infradead.org>
Subject: RE: [PATCH v5 04/13] iommu/vt-d: Add pasid replace helpers
Thread-Topic: [PATCH v5 04/13] iommu/vt-d: Add pasid replace helpers
Thread-Index: AQHbMGMK20FHFuN6DUSOsFkGv/rZc7KrH1aAgAAY0ICAABYKMA==
Date: Thu, 7 Nov 2024 05:46:48 +0000
Message-ID: <BN9PR11MB5276EEA35FBEB68E4172F1958C5C2@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20241106154606.9564-1-yi.l.liu@intel.com>
 <20241106154606.9564-5-yi.l.liu@intel.com>
 <268b3ac1-2ccf-4489-9358-889f01216b59@linux.intel.com>
 <8de3aafe-af94-493f-ab62-ef3e086c54da@intel.com>
In-Reply-To: <8de3aafe-af94-493f-ab62-ef3e086c54da@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|PH0PR11MB7660:EE_
x-ms-office365-filtering-correlation-id: 67a125fa-3573-4e86-2f97-08dcfeef92a4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?NTlSZ0hHVVBCS2F5a0tTVzJDZ3VsVFJ3bHpJalNneW5oNCt3S2hYMWlNc1gz?=
 =?utf-8?B?WkY1QXlTejNNZEVsVWJMWlBxb2hOYU45ZU55Qi9BL0RUTGJEZnBCYnpzMkF6?=
 =?utf-8?B?MDVlMk1ZWEhBTUtVOTdRRGordC9BMzUyU29JY0V0bDBhbkpTZW5rejg2ZjZF?=
 =?utf-8?B?QkZmdW8xOFRZdU4rWHNiMHFmNnUwbXJJVUJwcjRpak13dGR4WmJEQm9GWjZs?=
 =?utf-8?B?R3NrVUZLWGpJa3lxNEFGVlVlVlNFeVQzZHF2SWl3aElOeVZUVmp1dXBTWXN1?=
 =?utf-8?B?bDgrMW0yZE9RODVYQW12VGMyYnRYaStuQXdhOWtvVURBYkJHY2hsbmYzM0VW?=
 =?utf-8?B?MmhsMmpkQlBVRDd6NllERWhmeG4rclFmZTB2R2lPWDRvT0tXZGF4dnZkNEcr?=
 =?utf-8?B?Q3ozWXhWNUlWb0JxenpnazBzMHNOcHRYby95OE5TN05aUWJKS0JTT1g3QkI4?=
 =?utf-8?B?Y0c2Q205QTJiNUl0aXAzbEVsbEJveW1BYVpzU2xkczZXVUpsd29QMXJqNGRt?=
 =?utf-8?B?TXM2QjMrUkg3Vmt0bjUwNzg1NVBxdktjZWtqdERLT1kxcmMyMmZRT2lvbGw1?=
 =?utf-8?B?aUk3Sm9WblZKRnlVMDFmaFYzR3hkbHlOQVg5VHZBLzRpNzNMdnFoZElGWGtu?=
 =?utf-8?B?alZTZ0U1NHNQalN4RkpPRUErOWcrV2NGM0Z6cDBLMm5FdDd2Yk5mK05ITS95?=
 =?utf-8?B?eHhOMEpXNEM5VW5IenJyRjQ1WFdxSjRRdDlzdTlWUUJHSUFQa2V4MVliWnFJ?=
 =?utf-8?B?YjhhLytvM0czeldCUUpYZHN4TVNZcW9vRGdlRTNURDhIOWpNb05hcjAzbDVL?=
 =?utf-8?B?UzRzakxYVEVHS0dyUzcyYkYvVXhENHV3Q092azhJSzFTUXRvclpWUnVLZTJ4?=
 =?utf-8?B?SUtRK1I5WXVWSlZyaW5FL0syeVNNQUE5c2VyS21DejZYVjUzd2pLbUtKRGRk?=
 =?utf-8?B?c2x2bmphcU1HcXFpQklOakFRTXpoMjk3WXFndGxJb2hDRThYVmI4M3c2b1BM?=
 =?utf-8?B?ak5RTzdhbjdQcU9qVWtycS9MQWxsdHBEZnhqandnaTZLQ0twdlZ4SFJoc05S?=
 =?utf-8?B?MVZmNXhLS3lQMms2QjBIc1ozc0l3NWVMSWRwUlA2SDVVK3VHeEdtemd2N3d0?=
 =?utf-8?B?eldacU44K05qV1J1YVVLOS9HenBBbmtLTkloRWpkblVLSWoxS1hDNzNiM1pL?=
 =?utf-8?B?UUFUd2FNbFdTV2lYSHZHNERqNXZHcXF2dm1tQjRwYjZUak9OdFBJM3hGTU1X?=
 =?utf-8?B?eHNRK3dYZTVlOG4zZW4rV0xzamZCQUlwTkYwYTlsaXRtaThJZmticXo1ZTlY?=
 =?utf-8?B?bWVTdXlmbUdJK1VxSDJsd3dub2RUQWNLWC9LT1haRDE5Y1Q0TExORTBmb1Jq?=
 =?utf-8?B?TitLVi9hKzNwSTVGN3BuOXU1L1ZSYzc1bzNkam01NmlkeWlWWStPWWpqMDlU?=
 =?utf-8?B?QkkyUmNMdjk2UVRFVWRoQ3lnSm1RbFF5Zm5uV3NkSENabThOOTdDNW41K2dW?=
 =?utf-8?B?Q2oycVV5Y2F2T0tEYlgwVDgvYm91Z0QwZENMY3JBQXo1cGpLN0wyRU5wWE1H?=
 =?utf-8?B?UEg4ZExSYnRzd2NvT3hYeWhuUmJHU1BzWW91V1UvUWk1bStlRFNidzBRWThQ?=
 =?utf-8?B?Um9xbHJwc1VhQWsvMHdBYnJZN0xvcEJWR1pIMVJPS3Y0NFoyV3l0ZTdadUJ0?=
 =?utf-8?B?MFY3OEhrYndIRE1SQ09WRGxXSW1nY3FkSE5zMVN3ZGdsQVFFQ3dhY1l3RTF3?=
 =?utf-8?B?SVUzOXNyaEpYV2ZoM2FGaWEvNGFaMENxMHEvSTE2WkhWZFJMdnVJZ01xNlJI?=
 =?utf-8?Q?iVs2avEEeFHGegg8N4ljnnsR4x8ovVgoAM9fY=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bW9MY3JqeG1mQUlmNEpieWxnSElkNFFIK1J2Ym5qUUJrTHF0QUQ1RGltY3FD?=
 =?utf-8?B?Q2l4V29GNUJieDZuRy9DMFh0MXhQS2JiL0NESjJGS1h6OVFvTHlyeTNZeVY5?=
 =?utf-8?B?WHVrMkhkUmVMY1ZvNGpEUkFWUnU1SkIvOGlXdSsrdVdheW5uVDkyMk5KcHc3?=
 =?utf-8?B?UFJRQUNseWpoUDJwZW9GZk1qUjN0QjhDSkg5MG0wdFVIcVBNOVNNSXRHZXYz?=
 =?utf-8?B?VHNWMlozYXhiYSs0MUQ5OXlwYnFlNWVqTkE0TFo2T0lwa0pPaTd6T1RFa3Mx?=
 =?utf-8?B?enFkNVJwV3JTblBkVUVKR3BNSlFQZzc0WGJoQ0d3NW9nVGkzUnE5b0ZqZldR?=
 =?utf-8?B?UldOaVJSZ0lQVzNXclNUSEthM0tDRlk1QkFqcTJFeWdFQkRCUWN0anZGeUM2?=
 =?utf-8?B?M09OQzY0VWpBelZFU1ZPdTQ2M1JaZW9YblFvVXdSZWk4ZDhaZHUraWd5NFFo?=
 =?utf-8?B?WlhhdHFxelBRVlc5REV1NlFLT1crSjVJcTJZQURpdXpUeXN3eGZ5ZDVRS0oz?=
 =?utf-8?B?RWo4YTZ1OFFNWmxKZkw2bE5VcGI4ei9XNTd2dkt3RThVMHlQc3pkTWRBNEQ3?=
 =?utf-8?B?ZnhMV1UreFVJVlFCbDc3enovRXVlOEhSa1hVYmpLT1BPUzVsazZUdmZjUXhR?=
 =?utf-8?B?VnlyVEt1ai9LQitJRjBFWGpJNGk5a1NRU0lqNERRYlYwQ1dZQTc0dU1FUWxJ?=
 =?utf-8?B?MFQ2bVJCYW5YUGl5ZE01TjQ5S2RTaDZjMWlIbU1LNkhRZ2Jjb0t3TUxTYTg3?=
 =?utf-8?B?UkxQd0JnYTRUc1B6R2xCRFZtaWdBdytaK3dkc2Y0Q1JPdUY2TnRMSWM1aS9N?=
 =?utf-8?B?NXJtMEh4dUVPaUU3ck4yME44YjA4MFJEcjJIVjBwcEpZTm9DY3FLaXk5am1a?=
 =?utf-8?B?cjlpUmYzbzNrRHpvMkFHcmFGdEkyR01ZblJER1k5UXpuZHl0RklFWk5WeUh0?=
 =?utf-8?B?TFlCNTFXSlpKU0tPZ0FBUWh3bjI0UnlWSE1OVG8wOUtZeUluejkvRHNOQ3VH?=
 =?utf-8?B?aUFSNDdGaHp1bjZUcWhhMFRhL01CdWMyL2U0QlVJZGQvc1ZzMDFzL0tmZ1BR?=
 =?utf-8?B?a2ZIYS80b2tiRkY2MVFQMjc0SGhsN1pzZTdiaDJpNGtrVVptWlZBaHYycVNG?=
 =?utf-8?B?bWhHOXdwL05KbXJEQW9OUDNXSW1lQ1VVQ1BIdDVJYU9XOEtRVXUwWGU3NVk2?=
 =?utf-8?B?UmR3NCtYcWJSYVpFREdZVlJwaldIT2tHUURHTGpEOGJLYTB0RE9RKyt4RkNZ?=
 =?utf-8?B?cXJrVWJydVR3NHVZMkVXWUxsQVhoSHpMYzdTRHRndEhPZFpjRTNyUmgzWmdJ?=
 =?utf-8?B?SnZmMFM2eFFsQ1dLNnZOeFRaVGE5QXRpTENnMy9BaVo0SW5kaVBrYlQvbWFO?=
 =?utf-8?B?RmhSV2U3T3MxREk1amFmNzFpQ3RGQUtsL0tiU0c2ZFhKV1pHU3IzWUEwWkhF?=
 =?utf-8?B?YmMwWjl5UmtiR29EODNIL3ZFb2ZPc1phV1pZc0xDV0p0ZkdKa09Dd2hPcDZG?=
 =?utf-8?B?cktNNXkwdGZXTFlCT0tqZ2NKRzU1WGg0MSttWHd0cTZWZ1U0SnpxaEhxRFJK?=
 =?utf-8?B?VUJQdmlnNGhDZDR6ZCtzOHlWVHhScW5LZy9ldG1hT1BCR0xRWTJMZ0x0Z0pT?=
 =?utf-8?B?NWREQ0gyM2V1ZDJ3RlB2QmZ0VDY0RU1COVpoZXNneWZCS2h6REJxNXlBakZ1?=
 =?utf-8?B?K2JpeWt1R1RKYkUvUEFkeWw0M3d6ZjFHaUxRa0R1bTcxTG5IY3JNZHlxYWpy?=
 =?utf-8?B?NHM0clBVM2dqOHpKOHliVytxREhhTXZ5Z052R0dFWnhyMWttMTdSS0dvSzFH?=
 =?utf-8?B?UW5UK3Z3QjVUelQ3V2ZTTHYwV0JjOHVGQ2pVa2pYQU05WklXK09RK3BWQTdj?=
 =?utf-8?B?UUR4T2ZHT0JueFhFTEx1eWNuSk13T1lWTWVIaHVFMG5RaHM0V3RZWU5yL0pN?=
 =?utf-8?B?b3ZlZkszbkVoc1htWnlERlJBbmk5VnBGcFBXb2pjWnNwYWdzSGpIcm1ucW5D?=
 =?utf-8?B?b1F1czlxKzRPQWpTVlBXMVQvY1EycXh0S1V6VnFJOG1Oa09iei9hREpzVzRL?=
 =?utf-8?B?ME0zdm90VzRENVI5dTBCZ0hKc2lWOExvTXNvTytnQXFlT3BtSmNpbXN4blY4?=
 =?utf-8?Q?xVgSMU0kr3zqQ56sizBb9PZCa?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 67a125fa-3573-4e86-2f97-08dcfeef92a4
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Nov 2024 05:46:49.0370
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UGOaDC0E4PAh+rf6BVGcLpakHEMgjLFcEn0BiVeVgwBxhXdnOrka3h+wusLf5IWkCVvRciJpNc4sqTdQC0k6MQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB7660
X-OriginatorOrg: intel.com

PiBGcm9tOiBMaXUsIFlpIEwgPHlpLmwubGl1QGludGVsLmNvbT4NCj4gU2VudDogVGh1cnNkYXks
IE5vdmVtYmVyIDcsIDIwMjQgMTI6MjEgUE0NCj4gDQo+IE9uIDIwMjQvMTEvNyAxMDo1MiwgQmFv
bHUgTHUgd3JvdGU6DQo+ID4gT24gMTEvNi8yNCAyMzo0NSwgWWkgTGl1IHdyb3RlOg0KPiA+PiAr
aW50IGludGVsX3Bhc2lkX3JlcGxhY2VfZmlyc3RfbGV2ZWwoc3RydWN0IGludGVsX2lvbW11ICpp
b21tdSwNCj4gPj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHN0cnVj
dCBkZXZpY2UgKmRldiwgcGdkX3QgKnBnZCwNCj4gPj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgIHUzMiBwYXNpZCwgdTE2IGRpZCwgdTE2IG9sZF9kaWQsDQo+ID4+ICvC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBpbnQgZmxhZ3MpDQo+ID4+ICt7
DQo+ID4+ICvCoMKgwqAgc3RydWN0IHBhc2lkX2VudHJ5ICpwdGU7DQo+ID4+ICsNCj4gPj4gK8Kg
wqDCoCBpZiAoIWVjYXBfZmx0cyhpb21tdS0+ZWNhcCkpIHsNCj4gPj4gK8KgwqDCoMKgwqDCoMKg
IHByX2VycigiTm8gZmlyc3QgbGV2ZWwgdHJhbnNsYXRpb24gc3VwcG9ydCBvbiAlc1xuIiwNCj4g
Pj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgaW9tbXUtPm5hbWUpOw0KPiA+PiArwqDC
oMKgwqDCoMKgwqAgcmV0dXJuIC1FSU5WQUw7DQo+ID4+ICvCoMKgwqAgfQ0KPiA+PiArDQo+ID4+
ICvCoMKgwqAgaWYgKChmbGFncyAmIFBBU0lEX0ZMQUdfRkw1TFApICYmICFjYXBfZmw1bHBfc3Vw
cG9ydChpb21tdS0+Y2FwKSkgew0KPiA+PiArwqDCoMKgwqDCoMKgwqAgcHJfZXJyKCJObyA1LWxl
dmVsIHBhZ2luZyBzdXBwb3J0IGZvciBmaXJzdC1sZXZlbCBvbiAlc1xuIiwNCj4gPj4gK8KgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgaW9tbXUtPm5hbWUpOw0KPiA+PiArwqDCoMKgwqDCoMKg
wqAgcmV0dXJuIC1FSU5WQUw7DQo+ID4+ICvCoMKgwqAgfQ0KPiA+PiArDQo+ID4+ICvCoMKgwqAg
c3Bpbl9sb2NrKCZpb21tdS0+bG9jayk7DQo+ID4+ICvCoMKgwqAgcHRlID0gaW50ZWxfcGFzaWRf
Z2V0X2VudHJ5KGRldiwgcGFzaWQpOw0KPiA+PiArwqDCoMKgIGlmICghcHRlKSB7DQo+ID4+ICvC
oMKgwqDCoMKgwqDCoCBzcGluX3VubG9jaygmaW9tbXUtPmxvY2spOw0KPiA+PiArwqDCoMKgwqDC
oMKgwqAgcmV0dXJuIC1FTk9ERVY7DQo+ID4+ICvCoMKgwqAgfQ0KPiA+PiArDQo+ID4+ICvCoMKg
wqAgaWYgKCFwYXNpZF9wdGVfaXNfcHJlc2VudChwdGUpKSB7DQo+ID4+ICvCoMKgwqDCoMKgwqDC
oCBzcGluX3VubG9jaygmaW9tbXUtPmxvY2spOw0KPiA+PiArwqDCoMKgwqDCoMKgwqAgcmV0dXJu
IC1FSU5WQUw7DQo+ID4+ICvCoMKgwqAgfQ0KPiA+PiArDQo+ID4+ICvCoMKgwqAgV0FSTl9PTihv
bGRfZGlkICE9IHBhc2lkX2dldF9kb21haW5faWQocHRlKSk7DQo+ID4+ICsNCj4gPj4gK8KgwqDC
oCBwYXNpZF9wdGVfY29uZmlnX2ZpcnN0X2xldmVsKGlvbW11LCBwdGUsIHBnZCwgZGlkLCBmbGFn
cyk7DQo+ID4+ICvCoMKgwqAgc3Bpbl91bmxvY2soJmlvbW11LT5sb2NrKTsNCj4gPj4gKw0KPiA+
PiArwqDCoMKgIGludGVsX3Bhc2lkX2ZsdXNoX3ByZXNlbnQoaW9tbXUsIGRldiwgcGFzaWQsIG9s
ZF9kaWQsIHB0ZSk7DQo+ID4+ICvCoMKgwqAgaW50ZWxfaW9tbXVfZHJhaW5fcGFzaWRfcHJxKGRl
diwgcGFzaWQpOw0KPiA+PiArDQo+ID4+ICvCoMKgwqAgcmV0dXJuIDA7DQo+ID4+ICt9DQo+ID4N
Cj4gPiBwYXNpZF9wdGVfY29uZmlnX2ZpcnN0X2xldmVsKCkgY2F1c2VzIHRoZSBwYXNpZCBlbnRy
eSB0byB0cmFuc2l0aW9uIGZyb20NCj4gPiBwcmVzZW50IHRvIG5vbi1wcmVzZW50IGFuZCB0aGVu
IHRvIHByZXNlbnQuIEluIHRoaXMgY2FzZSwgY2FsbGluZw0KPiA+IGludGVsX3Bhc2lkX2ZsdXNo
X3ByZXNlbnQoKSBpcyBub3QgYWNjdXJhdGUsIGFzIGl0IGlzIG9ubHkgaW50ZW5kZWQgZm9yDQo+
ID4gcGFzaWQgZW50cmllcyB0cmFuc2l0aW9uaW5nIGZyb20gcHJlc2VudCB0byBwcmVzZW50LCBh
Y2NvcmRpbmcgdG8gdGhlDQo+ID4gc3BlY2lmaWNhdGlvbi4NCj4gPg0KPiA+IEl0J3MgcmVjb21t
ZW5kZWQgdG8gbW92ZSBwYXNpZF9jbGVhcl9lbnRyeShwdGUpIGFuZA0KPiA+IHBhc2lkX3NldF9w
cmVzZW50KHB0ZSkgb3V0IHRvIHRoZSBjYWxsZXIsIHNvIC4uLg0KPiA+DQo+ID4gRm9yIHNldHVw
IGNhc2UgKHBhc2lkIGZyb20gbm9uLXByZXNlbnQgdG8gcHJlc2VudCk6DQo+ID4NCj4gPiAtIHBh
c2lkX2NsZWFyX2VudHJ5KHB0ZSkNCj4gPiAtIHBhc2lkX3B0ZV9jb25maWdfZmlyc3RfbGV2ZWwo
cHRlKQ0KPiA+IC0gcGFzaWRfc2V0X3ByZXNlbnQocHRlKQ0KPiA+IC0gY2FjaGUgaW52YWxpZGF0
aW9ucw0KPiA+DQo+ID4gRm9yIHJlcGxhY2UgY2FzZSAocGFzaWQgZnJvbSBwcmVzZW50IHRvIHBy
ZXNlbnQpDQo+ID4NCj4gPiAtIHBhc2lkX3B0ZV9jb25maWdfZmlyc3RfbGV2ZWwocHRlKQ0KPiA+
IC0gY2FjaGUgaW52YWxpZGF0aW9ucw0KPiA+DQo+ID4gVGhlIHNhbWUgYXBwbGllcyB0byBvdGhl
ciB0eXBlcyBvZiBzZXR1cCBhbmQgcmVwbGFjZS4NCj4gDQo+IGhtbW0uIEhlcmUgaXMgdGhlIHJl
YXNvbiBJIGRpZCBpdCBpbiB0aGUgd2F5IG9mIHRoaXMgcGF0Y2g6DQo+IDEpIHBhc2lkX2NsZWFy
X2VudHJ5KCkgY2FuIGNsZWFyIGFsbCB0aGUgZmllbGRzIHRoYXQgYXJlIG5vdCBzdXBwb3NlZCB0
bw0KPiAgICAgYmUgdXNlZCBieSB0aGUgbmV3IGRvbWFpbi4gRm9yIGV4YW1wbGUsIGNvbnZlcnRp
bmcgYSBuZXN0ZWQgZG9tYWluIHRvDQo+IFNTDQo+ICAgICBvbmx5IGRvbWFpbiwgaWYgbm8gcGFz
aWRfY2xlYXJfZW50cnkoKSB0aGVuIHRoZSBGU1BUUiB3b3VsZCBiZSB0aGVyZS4NCj4gICAgIEFs
dGhvdWdoIHNwZWMgc2VlbXMgbm90IGVuZm9yY2UgaXQsIGl0IG1pZ2h0IGJlIGdvb2QgdG8gY2xl
YXIgaXQuDQo+IDIpIFdlIGRvbid0IHN1cHBvcnQgYXRvbWljIHJlcGxhY2UgeWV0LCBzbyB0aGUg
d2hvbGUgcGFzaWQgZW50cnkgdHJhbnNpdGlvbg0KPiAgICAgaXMgbm90IGRvbmUgaW4gb25lIHNo
b3QsIHNvIGl0IGxvb2tzIHRvIGJlIG9rIHRvIGRvIHRoaXMgc3RlcHBpbmcNCj4gICAgIHRyYW5z
aXRpb24uDQo+IDMpIEl0IHNlZW1zIHRvIGJlIGV2ZW4gd29yc2UgaWYga2VlcCB0aGUgUHJlc2Vu
dCBiaXQgZHVyaW5nIHRoZSB0cmFuc2l0aW9uLg0KPiAgICAgVGhlIHBhc2lkIGVudHJ5IG1pZ2h0
IGJlIGJyb2tlbiB3aGlsZSB0aGUgUHJlc2VudCBiaXQgaW5kaWNhdGVzIHRoaXMgaXMNCj4gICAg
IGEgdmFsaWQgcGFzaWQgZW50cnkuIFNheSBpZiB0aGVyZSBpcyBpbi1mbGlnaHQgRE1BLCB0aGUg
cmVzdWx0IG1heSBiZQ0KPiAgICAgdW5wcmVkaWN0YWJsZS4NCj4gDQo+IEJhc2VkIG9uIHRoZSBh
Ym92ZSwgSSBjaG9zZSB0aGUgY3VycmVudCB3YXkuIEJ1dCBJIGFkbWl0IGlmIHdlIGFyZSBnb2lu
ZyB0bw0KPiBzdXBwb3J0IGF0b21pYyByZXBsYWNlLCB0aGVuIHdlIHNob3VsZCByZWZhY3RvciBh
IGJpdC4gSSBiZWxpZXZlIGF0IHRoYXQNCj4gdGltZSB3ZSBuZWVkIHRvIGNvbnN0cnVjdCB0aGUg
bmV3IHBhc2lkIGVudHJ5IGZpcnN0IGFuZCB0cnkgdG8gZXhjaGFuZ2UgaXQNCj4gdG8gdGhlIHBh
c2lkIHRhYmxlLiBJIGNhbiBzZWUgc29tZSB0cmFuc2l0aW9uIGNhbiBiZSBkb25lIGluIHRoYXQg
d2F5IGFzIHdlDQo+IGNhbiBkbyBhdG9taWMgZXhjaGFuZ2Ugd2l0aCAxMjhiaXRzLiB0aG91Z2h0
cz8gOikNCj4gDQoNCnllcyAxMjhiaXQgY21weGNoZyBpcyBuZWNlc3NhcnkgdG8gc3VwcG9ydCBh
dG9taWMgcmVwbGFjZW1lbnQuDQoNCkFjdHVhbGx5IHZ0LWQgc3BlYyBjbGVhcmx5IHNheXMgc28g
ZS5nLiBTU1BUUFRSL0RJRCBtdXN0IGJlIHVwZGF0ZWQNCnRvZ2V0aGVyIGluIGEgcHJlc2VudCBl
bnRyeSB0byBub3QgYnJlYWsgaW4tZmxpZ2h0IERNQS4NCg0KYnV0Li4uIHlvdXIgY3VycmVudCB3
YXkgKGNsZWFyIGVudHJ5IHRoZW4gdXBkYXRlIGl0KSBhbHNvIGJyZWFrIGluLWZsaWdodA0KRE1B
LiBTbyBsZXQncyBhZG1pdCB0aGF0IGFzIHRoZSAxc3Qgc3RlcCBpdCdzIG5vdCBhaW1lZCB0byBz
dXBwb3J0DQphdG9taWMgcmVwbGFjZW1lbnQuIFdpdGggdGhhdCBCYW9sdSdzIHN1Z2dlc3Rpb24g
bWFrZXMgbW9yZSBzZW5zZQ0KdG93YXJkIGZ1dHVyZSBleHRlbnNpb24gd2l0aCBsZXNzIHJlZmFj
dG9yaW5nIHJlcXVpcmVkIChvdGhlcndpc2UgDQp5b3Ugc2hvdWxkIG5vdCB1c2UgaW50ZWxfcGFz
aWRfZmx1c2hfcHJlc2VudCgpIHRoZW4gdGhlIGVhcmxpZXINCnJlZmFjdG9yaW5nIGZvciB0aGF0
IGhlbHBlciBpcyBhbHNvIG1lYW5pbmdsZXNzKS4NCg==

