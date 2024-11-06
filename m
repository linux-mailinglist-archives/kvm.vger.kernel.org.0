Return-Path: <kvm+bounces-30905-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 2ED059BE382
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 11:06:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 95686B20E8F
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 10:06:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF5F51DC730;
	Wed,  6 Nov 2024 10:05:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="m6S2swlZ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BF951DD88F
	for <kvm@vger.kernel.org>; Wed,  6 Nov 2024 10:05:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730887556; cv=fail; b=sdXlGKiGLPnF18zsNwqB3fzol95Nzc+TirlwOF7AtGgDb6DMZTITsyqvfK781e54UmBUe4tAMyqXg6b6m5cpdxZBFicjn0ndqWu7lVxSFB1dHeAD2YUkaGi2P+bemkWW7NJQwIEELVuBxUlUYByxQUVzRugOVLvyXhC4fnwz7+k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730887556; c=relaxed/simple;
	bh=3nMyQ8/PqlHOAxHhkxK6xJ5bZNKceGy5gg3XKWXBpGs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=GEvbeuRvxPa/TKMiN8rG+ooqKwtii1eHcUiBOCQ9C6ZbRrPuiLo6QH2qZHysHuLz+59tl3vscyQD78qAQl9f7OfJrfv7IL+RD0UpjUcncUmuEpET9t4ykIh3WTq6rc7nfBpgTH3QvBbQ8pbPEnZK9ohFHBmyqNHqPePRst7BDPI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=m6S2swlZ; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730887555; x=1762423555;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=3nMyQ8/PqlHOAxHhkxK6xJ5bZNKceGy5gg3XKWXBpGs=;
  b=m6S2swlZsXe+Z2P0lVXv2LAjJKskDAFCdYaKTvum6eU/zuDWdXdorIdc
   KwiSsdXTfwUFD9eGSWAQIT7Y0rmP2P+E9eyDLZG60d4Sp+7phC0KoBVu2
   lJf9MEwTFtFj41bb6s5UHIaT0xt0reTKIf0VoQMtcvIyGDHRZPjGDAJHP
   zX0D5l3qEfKOlOiukbO0iVguvC4P5IyNLnuU/RYa1VL2H1q9U8xljjbim
   zeTwajAfpw8F5W6ccXe1EQbGsmPK0epOGVY5yIN/PzMVhi4VNYGkVTRO4
   DOqiG0ohZ/6Yo2fF60LvgXZ3vPj9OZNRQx7BYHGjeR2x9p59Nel3LhVi1
   w==;
X-CSE-ConnectionGUID: yuBOw08sT36ocsSf9aUxYw==
X-CSE-MsgGUID: +v72qb9VTi6bEn9uIhS3sQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="30529677"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="30529677"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2024 02:05:54 -0800
X-CSE-ConnectionGUID: ozD04dh4RDmi2t91r8owjA==
X-CSE-MsgGUID: u7Dw/eS4TJq7Vwo3o6fwEw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,262,1725346800"; 
   d="scan'208";a="84807672"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa010.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Nov 2024 02:05:53 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 6 Nov 2024 02:05:53 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 6 Nov 2024 02:05:53 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.41) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 6 Nov 2024 02:05:53 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=C3pCO+/2H0jaGONl+JwVippGYoImXioF3r07Kn8RK1SOhuDAC4UkrjqIbJQcTEgyIRTqTfwSdNDsdyFytRtN9K86trrSsI/XN3XialGIKQ7Uxtw1YoghyTnkB78yAdECqFwIvG4IO3RgnD5O9uSbhcnJxoZOrEGEn2Zhg443L0oAe776Y9+all/3bDfcMSEgC82cZ1YVvI4fmncyJtJcP4vFMexNvMcuGWrGSgMurAt47u5a9Zne/WHUElzWiEfgY64liyK1BeH3L1+HgdalDi6NGO+XqaSOptYQvbd0nYuRNDlV5tQj7feFwtFidl+lTnYUgdZWNiFQfaWrHXyjRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3nMyQ8/PqlHOAxHhkxK6xJ5bZNKceGy5gg3XKWXBpGs=;
 b=XydgundWuoVPnP+OjrpYDlsQOK20vZI3AxoPLwA3b+p0tHDEUgv9UnhGEKzIQ3OICAZHTpmHiG+jlISRrdw7tC+giagIrOHH+baX1RlCOC41Y/Nf60n5HzTo4jgmoKqHvmEeO4oVwlKS+JxO3J2xyWTO+5QxkGtWp6yJxSMmJplI1pVBX0y6ORIoW7RhwP10zGmbigVbY2heFVsIhhhrFSULheoajYca/7b2syTH2fXCoBUslphoaJ0maXbGr4nRgCoIk9ZsozIS17uantxJf9h85pZ7wwWz7IdgPpOJ/raH8Lm6uka5YIHfzZA+DJqOWIa69RbvOjxUGLmLu8iQDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by CH3PR11MB7868.namprd11.prod.outlook.com (2603:10b6:610:12e::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.19; Wed, 6 Nov
 2024 10:05:50 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%5]) with mapi id 15.20.8137.018; Wed, 6 Nov 2024
 10:05:43 +0000
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
Subject: RE: [PATCH v4 04/13] iommu/vt-d: Add pasid replace helpers
Thread-Topic: [PATCH v4 04/13] iommu/vt-d: Add pasid replace helpers
Thread-Index: AQHbLrwadjuhsNo8NEGmUJt6qlMg6LKp2axQgAAmLICAAASugIAAA94AgAAAOEA=
Date: Wed, 6 Nov 2024 10:05:43 +0000
Message-ID: <BN9PR11MB52769251CB1CE4FFCF4E1DE68C532@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20241104131842.13303-1-yi.l.liu@intel.com>
 <20241104131842.13303-5-yi.l.liu@intel.com>
 <BN9PR11MB5276B9F6A5D42D30579E05E28C532@BN9PR11MB5276.namprd11.prod.outlook.com>
 <d218eb1c-ca02-4975-bd6a-310a81b3d88c@intel.com>
 <BN9PR11MB52766A4A2C15C9C58F9513128C532@BN9PR11MB5276.namprd11.prod.outlook.com>
 <30114c7f-de39-4023-819f-134ee3b74467@intel.com>
In-Reply-To: <30114c7f-de39-4023-819f-134ee3b74467@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|CH3PR11MB7868:EE_
x-ms-office365-filtering-correlation-id: ff9df1e3-9680-4660-eab2-08dcfe4a93b4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?YXJYc0lmZjJqL1lhaWNnT09ReStacHIvdmtnTXhmM1pKTk1ONWxuditpanho?=
 =?utf-8?B?UEcwUmU3a0dkemxJY0c3T2h4T3JhVzFmQ3JvUk94a1ZYbzdNTVVENFhZSXhR?=
 =?utf-8?B?NlVSQ3J0TjZYRU1NVUlUTUV0RTRHVjZia1ljMllkUGFDZXBDOThEWFhwWDZu?=
 =?utf-8?B?WTV6MlJ2MmRWQmZuREhqVmZRUUhxcVdjYTVycHF4RGFyVDM3TGhLOW5NY2pN?=
 =?utf-8?B?ZGsvNjNaVEJrdkUrak1JWVVJV3B6N2V0UWR1cS90emRCU1p6NTZyYzRKV1RR?=
 =?utf-8?B?RVVEWEZIV2RXYk1aVWdmSUNtRVJFVkszdUl1Q0xFci9TRm13STlOZllTWjA5?=
 =?utf-8?B?cjlEYTFncjZjTk1mMXJkWE0wSFNhOENJK2Z3dmxEUXVEcFVsa3NkMnRHWEZx?=
 =?utf-8?B?dXJtTlRvdXowOW80V2VidWYwWEZQRDJNWnRUOHB5eU5LQ3p2Z2dkV3JSRm9i?=
 =?utf-8?B?bjFJMlI0eWgxT2pud3dvN3hKa3ZSZzNMQjZoYmNlZmpiRnVYY0dCTDRhQllH?=
 =?utf-8?B?OHdncWF5emFUbWI1a0N2QkZTdW44eE80VGU4SzNBY3o5Z1RlV0pCbVdKMURG?=
 =?utf-8?B?K3AyaFJRZHVhdExQVVlMQkF5RTlRUVBBaDRQNHpaMmxrSCtDTWdCNVdraUtr?=
 =?utf-8?B?Y1dSclQ2eDNjdk9tRlg3RzBuam40SytpLzYyc1ZwdG9OaW1CVklPNXFKMm9z?=
 =?utf-8?B?Rm9yRkl5bkZTL1lTeUQvb2luaTVKWTZMZ01xUmlhZjFpNTdMcWxLOTVBRWV0?=
 =?utf-8?B?NEdHM0tabUU5MnJuYXRubWRXelBFZ1ZhM0FnRXZmdkdLaytSSTR2SW50ajVl?=
 =?utf-8?B?bFRCQno0WklSWE4wVkRpYjd0WDNneEV2amx2a25XTEVjVmtIQ2FLbldLcitX?=
 =?utf-8?B?ZTlNbVFoS0U2TnEyYjVTSVM5SGN2RDR3ckpEdE92dG1pWElLblIyQTYwWXVO?=
 =?utf-8?B?MHFwcDNCWnBaOVRKWEhTd0FVQzBDM2ZaRisybkQyTlg1Vm1LSCtKWEpkY2w4?=
 =?utf-8?B?MGZ3MEhnMFdTZU5CYUdNT0xYNmh0UnRWM2NxNTBMV3djSTM5T1V2SkswZ2d0?=
 =?utf-8?B?OHR5aG5EWmpsbDNvVC9GMFZsVkxCa3hlei90UG5HRjU5enBrSHFWR290b1dH?=
 =?utf-8?B?ZXF6d3lmclFxaTErZ3BwWWdpYjllOW0xczR2ZVBNV1BNdHNsOWxlL1VFeU10?=
 =?utf-8?B?UElqL3RnUEdlcHZBMnNmYkJFOFA4QURNTlpCYkZ5SEpOclNWNXp2NGtvVDhG?=
 =?utf-8?B?VCtzeXp0bFRqR0kyNXp6TDNLbGp0UDFpQzhBV1RmNlJDcjM2T3J3R0dhaExw?=
 =?utf-8?B?TmhZdW94a2dqUzNVSXg2eVRrZC85dzVIekxhbC9GaGZEZmJWbDl6UWpHNnN1?=
 =?utf-8?B?cGNTOThEenhTZUl4Uko0V09NRHptVVB5QnBRd0poYVo0SlVMejNXMTVCRXZR?=
 =?utf-8?B?ZmtIVkZhZUZ1T09zeTZ3OWpyQWxKMzU5MndBcFd6QkVoMXdBVEh0Q0pJQm5r?=
 =?utf-8?B?VHZ0NksvT0hVNkpkQmR0c0ZnYVlqSitoa2tQZUVUTjZnaE9mZHl6ZTUyM0do?=
 =?utf-8?B?WFZLamlITHJPTU13NTg3QnJmZlNORjdSYUJPa1FrNlQ5MGdYb01TY0ZDUUx0?=
 =?utf-8?B?UVlqNEJ5UTJtNEp1NGVLRm1tTnErQjByTXJQQm9jTk1mdTdQMVh1S0s0VDBQ?=
 =?utf-8?B?TFp5akwxSVNaK2hTRmNOZjFUY1FVQlE4THFNWU54NW1IOVJHZFA5eTJjTkEy?=
 =?utf-8?B?SWdSZ3R3aEdWOWIva2JUQ3AvQzVoRnRrQmhvRGtJaStocW4xK1J2VUJwSXo1?=
 =?utf-8?Q?Zz7LRtzcznTjq6lv0E/EmgiIBxgZIPhUfVauA=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dUdqSFJQejVObURUdHdoUWI5bnJ3V0szSGRzOHhhN1FEdU5sZzU3bGJVVzlz?=
 =?utf-8?B?dm5NQk8wNGx5d1YzQnlhblBiTVJ2U1VKQ1hmQjFhQThkaVhHVG9mTjRVZmpM?=
 =?utf-8?B?U2x6WEZ5Y0FtTzBzOUpybDBlcVJLUnhXQjJhR21RK1V1aHRtbENKaGZFcEsv?=
 =?utf-8?B?YzFqTTZ0SVlTb2UvVm9WUmtXdW9SVzhmWUo5dWQvZ2l4Nm42WUVOU2M5VlhU?=
 =?utf-8?B?VXVYclZPRzdOdjBCWURsRWNuMVhOL2RrWkVxSm5IRjE3UUtSbEFtdGZmSkl5?=
 =?utf-8?B?QTdOcVFqMHFyZTlhVmVVS0JIWlh3amcrWEhReGZwN0Y2bXFkcU43QnhiazNN?=
 =?utf-8?B?ZzhmSnU0VjAzeURJQzgyR1BBUGlzYzNzWDk0bWpHSVhzYW44YnRaNzJuQ1dI?=
 =?utf-8?B?YkE0dVBkY3pka3VINHpRZTY4RkhQalo0dG5JYlBBbTB3L25Lb0RveWo3Lzlv?=
 =?utf-8?B?QmphRnFhWWs4ZG5XZmQzMExod3hBWVlLUXU1Vmc1cVdsOEFQZVI5Vk5GanN4?=
 =?utf-8?B?aU41bUpoTVhuUDBuUkVnejdVWnlHY2drMTF4b1VWMUVHSTFxNUE1T3ZQczc1?=
 =?utf-8?B?SklDZEV1eGRsVXMzWGM1SGlCUGpqVXVxNVM1a1ZwZlZtNTFjOGdSVWlmV1VQ?=
 =?utf-8?B?UkxmVzlFRDU1ZXV0NmFzcW84U3R6SUdZc2VDNEtVbGFFQkQvLytEdDBGNjJZ?=
 =?utf-8?B?UDZ0Wng3SVJTbmJPckdkMGU0ejBkSWhjTmkvOVpYbDFFTEQyRmFtcWF4SVNR?=
 =?utf-8?B?eWJGak9CcS8vd0wxbHhaT2VyYVBMMXNqNXdNL0FTZHRmYUtVQkk3cWVKckJZ?=
 =?utf-8?B?TmVrQVdDLzZ5dkIyZlNEVkZ1ODl5bm9xbUhSUDF1SStqdVh6ZURPQWI2TDgx?=
 =?utf-8?B?NTQxVUp4ZVpRS0s5bXVERXEybTVwbkdUZXpMbkF3anQyVkZhRVBTREx2ajBa?=
 =?utf-8?B?eW5WTjNFOXVTclhxZ1Vqb0JvUTJZUWZPTW1sSlRDY3FyMnhaRFQxTFpHZ1hz?=
 =?utf-8?B?dmtlMkNmZyszdGhpSGdVVFd0UTZ2Wnc1R0FkT2hEZHh2Y1JGSktNdTRhR0Uz?=
 =?utf-8?B?Uk04RmFTaFpGTzdOd0IramZqODA2R3ZmZHJkQm05WlphREF4YTZWSFN4YTBh?=
 =?utf-8?B?MFNqd05PNkNLalI3R1dkeGdCWGg3YThlQlorUGJBNmRmeUNQK203ZXVINVdw?=
 =?utf-8?B?bU5DVEhlc1AzNnQxMHk1WWduR0lFMElWQUVKcHJ2NzJPWWNsS2V5VERNVzBC?=
 =?utf-8?B?eXZISnJncWg1bnAzQzJiekxISnVvc2dxcG5QVWNmWVI4bmV1Y1F1akR4QzlN?=
 =?utf-8?B?U2xuNS9TTDRlQ3oyZVBhdWh6RURKS3RsK0ZRb21KaDYrZ005NTkyYVV3clox?=
 =?utf-8?B?NU1wdisvTG5FUTVBd3RJTHB6TnR0NTNoTFVablpuRGVidEZOSytBdmlNNFAw?=
 =?utf-8?B?ZXE3WlJ1dUlZQUxPNVV4YUwzbDVydS9YYTdMZ3BYdDloSTNWZTJKVXBOS0FR?=
 =?utf-8?B?ZnEvWmhBSGt0cVkrWmdySnY3cTRLT2pFUkJmdmhYY0wycFpvREl2WU9QVGZ6?=
 =?utf-8?B?c1dBenIwZnRNcHJXWDFiOGZBajBnZXNEeVpOajV3amlSbHRuV0pSNGNnTW5l?=
 =?utf-8?B?d3dYUUZWOFZDUFBhVWZZeFA4SG5UYUYvRG52bkVuL252bzhrN1ZLcmFkUk1P?=
 =?utf-8?B?RFAxMit6SHV6SGwxMHNiQU53UnlCMkdYbUs5R3BtajVJd2tlMEM2QjRaTS9K?=
 =?utf-8?B?Z1NoRVpJWU0reW5oY2FpdUNsVlBFb3JTeE1IL1lKWGtaSHN0RzJ6WlBhUzN3?=
 =?utf-8?B?UHQ2U2Y2b3NmcWVoRG5hQkJoaDhvNmhZcjVDZjczbC9Mek41RnlHZHFFeTR4?=
 =?utf-8?B?dVUzNE4wYWpHLzlFVE9semYrWERtVzl6NHJmUmZ4M2dSeWlWYmwzcEk3V3FD?=
 =?utf-8?B?VEI2aHlJK2NPS0tVL0MwSXN0cncyVWRUUFFxdE8vUldmc3RjS2dyZFgrbE1F?=
 =?utf-8?B?QzdPQUxPamZwaUtXcFdyV2tNaFJCYjUxVzZjZWlCaEk2TXdSWWp2WWhoaFdU?=
 =?utf-8?B?bkNqaXppRG5UdHVJbXRYQTVUam5sZllRQ1ltcDQ5VTMyUGFONlZHT1dVekNr?=
 =?utf-8?Q?TWycuvGNaxC258eumj+6xK/Ap?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: ff9df1e3-9680-4660-eab2-08dcfe4a93b4
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Nov 2024 10:05:43.8328
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ku6m7M0HipHHxQP44/U6Px9MglZeMT7uRk3JScPcC02EvLqf2iIoQUuozy6HHKgIfVQ6xQ+PrlnMf3TjDuSEPw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7868
X-OriginatorOrg: intel.com

PiBGcm9tOiBMaXUsIFlpIEwgPHlpLmwubGl1QGludGVsLmNvbT4NCj4gU2VudDogV2VkbmVzZGF5
LCBOb3ZlbWJlciA2LCAyMDI0IDY6MDIgUE0NCj4gDQo+IE9uIDIwMjQvMTEvNiAxNzo1MSwgVGlh
biwgS2V2aW4gd3JvdGU6DQo+ID4+IEZyb206IExpdSwgWWkgTCA8eWkubC5saXVAaW50ZWwuY29t
Pg0KPiA+PiBTZW50OiBXZWRuZXNkYXksIE5vdmVtYmVyIDYsIDIwMjQgNTozMSBQTQ0KPiA+Pg0K
PiA+PiBPbiAyMDI0LzExLzYgMTU6MzEsIFRpYW4sIEtldmluIHdyb3RlOg0KPiA+Pj4+IEZyb206
IExpdSwgWWkgTCA8eWkubC5saXVAaW50ZWwuY29tPg0KPiA+Pj4+IFNlbnQ6IE1vbmRheSwgTm92
ZW1iZXIgNCwgMjAyNCA5OjE5IFBNDQo+ID4+Pj4NCj4gPj4+PiArDQo+ID4+Pj4gKwlzcGluX2xv
Y2soJmlvbW11LT5sb2NrKTsNCj4gPj4+PiArCXB0ZSA9IGludGVsX3Bhc2lkX2dldF9lbnRyeShk
ZXYsIHBhc2lkKTsNCj4gPj4+PiArCWlmICghcHRlKSB7DQo+ID4+Pj4gKwkJc3Bpbl91bmxvY2so
JmlvbW11LT5sb2NrKTsNCj4gPj4+PiArCQlyZXR1cm4gLUVOT0RFVjsNCj4gPj4+PiArCX0NCj4g
Pj4+PiArDQo+ID4+Pj4gKwlpZiAoIXBhc2lkX3B0ZV9pc19wcmVzZW50KHB0ZSkpIHsNCj4gPj4+
PiArCQlzcGluX3VubG9jaygmaW9tbXUtPmxvY2spOw0KPiA+Pj4+ICsJCXJldHVybiAtRUlOVkFM
Ow0KPiA+Pj4+ICsJfQ0KPiA+Pj4+ICsNCj4gPj4+PiArCW9sZF9kaWQgPSBwYXNpZF9nZXRfZG9t
YWluX2lkKHB0ZSk7DQo+ID4+Pg0KPiA+Pj4gcHJvYmFibHkgc2hvdWxkIHBhc3MgdGhlIG9sZCBk
b21haW4gaW4gYW5kIGNoZWNrIHdoZXRoZXIgdGhlDQo+ID4+PiBkb21haW4tPmRpZCBpcyBzYW1l
IGFzIHRoZSBvbmUgaW4gdGhlIHBhc2lkIGVudHJ5IGFuZCB3YXJuIG90aGVyd2lzZS4NCj4gPj4N
Cj4gPj4gdGhpcyB3b3VsZCBiZSBhIHN3IGJ1Zy4gOikgRG8gd2UgcmVhbGx5IHdhbnQgdG8gY2F0
Y2ggZXZlcnkgYnVnIGJ5IHdhcm4/IDopDQo+ID4+DQo+ID4NCj4gPiB0aGlzIG9uZSBzaG91bGQg
bm90IGhhcHBlbi4gSWYgaXQgZG9lcywgc29tZXRoaW5nIHNldmVyZSBqdW1wcyBvdXQuLi4NCj4g
DQo+IHllcy4gdGhhdCdzIHdoeSBJIGRvdWJ0IGlmIGl0J3MgdmFsdWFibGUgdG8gZG8gaXQuIEl0
IHNob3VsZCBiZSBhIHZpdGFsDQo+IGJ1ZyB0aGF0IGJyaW5nIHVzIHRoaXMgd2Fybi4gb3IgaW5z
dGVhZCBvZiBwYXNzaW5nIGlkIG9sZCBkb21haW4sIGhvdw0KPiBhYm91dCBqdXN0IG9sZF9kaWQ/
IFdlIHVzZSB0aGUgcGFzc2VkIGluIGRpZCBpbnN0ZWFkIG9mIHVzaW5nIHRoZSBkaWQNCj4gZnJv
bSBwdGUuDQo+IA0KDQpNeSBwZXJzb25hbCBmZWVsaW5nIC0gaXQncyB3b3J0aCBhcyBzdWNoIHJh
cmUgYnVnIG9uY2UgaGFwcGVuaW5nIA0Kd291bGQgYmUgdmVyeSBkaWZmaWN1bHQgdG8gZGVidWcu
IHRoZSB3YXJuaW5nIHByb3ZpZGVzIHVzZWZ1bCBoaW50Lg0KDQpwYXNzaW5nIGRpZCBpcyBPSy4N
Cg==

