Return-Path: <kvm+bounces-34891-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E8334A07053
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 09:50:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DDA41163855
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 08:50:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54D63215184;
	Thu,  9 Jan 2025 08:49:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Y+pufx7W"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED2461EBA19
	for <kvm@vger.kernel.org>; Thu,  9 Jan 2025 08:49:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736412595; cv=fail; b=XYMxlqdw+JJPQR/2Uh04yrDhP4pj3BKH3Qb6UOyxp5XS8hyu77rTaD/6dFqJ1kTbyRuKDtxGBXpjd8Ab5DVZ6HU3f4iulpWrEzVeb1H3piUQTz5oF/xrgN/GEyqJVmGf7YMuldcS5GzFuXHTYyfSaKWeLqP/jjVhHPS5uXLYIbU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736412595; c=relaxed/simple;
	bh=K2aNmBHJZ10FGDr4/0di6J7ptDzliUtnHXb1KUzsABI=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=E7a+1qAwvFOU587Mi3vRtfVdwTRY7lKmr+kYhQX4OtXhuhlh9Z/YsUd5Iigpj+yKTiNhRtilXxdaJexdCilL/2u0hw9cuXK/Hl33vOLjWq9G8wciprn+/4D8nUc8+dea9KBTDA/vVH+Y5vdXIrMwmX+yHUeAX2L5J02LNhgPXAo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Y+pufx7W; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736412593; x=1767948593;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=K2aNmBHJZ10FGDr4/0di6J7ptDzliUtnHXb1KUzsABI=;
  b=Y+pufx7WOegoJSJ1mNrPs2Rzj77NJRTWfYyGDY0HzVBKJeHDrfznZv6u
   f+tsKnUcFMXtvAj8Kv6N4L2aeBzxJ50gEkAV3JPm+5DJHOBQBxKa0Ulnv
   FG2Ce/6i5JlwZgfBZYXGC1LD7oUvXj9cD6bUADhLftP5lOAQdsLTRwgyL
   DAP9JdeLPLGEeKhaXjExKyizH1TVSCzodrFDK8yNiWxW3oCz26D5PPott
   VM8xg3khQ/RzyYj0M6GJ6RdBYWjp8fpB4X5kDVwJLLpg4ImwVwMf2QCHO
   LmiP5acvZ4hYVl10Uh43AK0+AD8kt2CNGfTwP5ad6IO9+CDJiol2JD3/6
   g==;
X-CSE-ConnectionGUID: bdoYPn9tR/Kdh5i2JiaV6w==
X-CSE-MsgGUID: kHTZzSGnQ8Gn1VuMfB6xMw==
X-IronPort-AV: E=McAfee;i="6700,10204,11309"; a="36824329"
X-IronPort-AV: E=Sophos;i="6.12,300,1728975600"; 
   d="scan'208";a="36824329"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2025 00:49:53 -0800
X-CSE-ConnectionGUID: pyzpVezQSPemXZYqsLz2jw==
X-CSE-MsgGUID: ijtofnCXSu+nEnb1a4rFuQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="108401006"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 09 Jan 2025 00:49:52 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Thu, 9 Jan 2025 00:49:51 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Thu, 9 Jan 2025 00:49:51 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.41) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 9 Jan 2025 00:49:51 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xPKNod60MfG6SLJ0cuWyzlNpXw85EmtTsXT8+AJiaL7IuwRMZEEvpjKi0uNxPnLc91bvD7DZGjsHrBlJBZnvKwb1wTloLJU/XgAbud0aXib+ysWZl6bj5Xr/TBDDhqoocHW2ptLt675bbD4/W70JpqR9jHQRlDuuS0s5NbET+uWHNpHDm9lU5y4Z4v7N1EHdxq8I2M8M7EDezZ/SCALdn0V0AWrpEQqOYHV1wTFUOCMgLCZrbNkb7JiaKx4Br5stBo6071MGVnQGsSaCGmtz8KGxwjKBmmdRk9BOU2I9LlwpvW11ZRHeoeGmKFz/Y7S3Bgs4bthBIEWNlda5OpcnDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VKxBpkiZc7iaFnDVkabNYssudaAqqO/Auu9BVugMUAg=;
 b=Fcy0z59gh2g/ZM50IsPDZ92GPjbAuhhBJT6p81yuZqjTBYmFrOBVLE+R68CeT+/WIbJqzZ40DrchyYMtT1BwhBSxPh7HO+Q0y0l2DAbg5Kyr8pvIJlqc8YqAW80gwhFccAaynPgcnKTO8AIDL/30rnPJNCOH4nh1u7eRrBtBVKQjcyj3CGmaX4uyPydA5mtzFNdGJTVGBQWCtwTw2wmDVDARrYlfSBAJnBB2DycU0KOnxOAiase2H1rWBwP6Oeo9KzU5p094wa6ygHrc2+8VPl1qmC/gBuzJNlJxhzf3gFW1IgQjcyrLwyLbLOhFf2Ir6Q4vuk0SXXPxEypreFeSwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CYXPR11MB8729.namprd11.prod.outlook.com (2603:10b6:930:dc::17)
 by DM4PR11MB6167.namprd11.prod.outlook.com (2603:10b6:8:ac::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8335.10; Thu, 9 Jan
 2025 08:49:44 +0000
Received: from CYXPR11MB8729.namprd11.prod.outlook.com
 ([fe80::680a:a5bc:126d:fdfb]) by CYXPR11MB8729.namprd11.prod.outlook.com
 ([fe80::680a:a5bc:126d:fdfb%7]) with mapi id 15.20.8335.011; Thu, 9 Jan 2025
 08:49:44 +0000
Message-ID: <57a3869d-f3d1-4125-aaa5-e529fb659421@intel.com>
Date: Thu, 9 Jan 2025 16:49:36 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/7] Enable shared device assignment
To: Alexey Kardashevskiy <aik@amd.com>, David Hildenbrand <david@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
	=?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>, Michael Roth
	<michael.roth@amd.com>
CC: <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>, Williams Dan J
	<dan.j.williams@intel.com>, Peng Chao P <chao.p.peng@intel.com>, Gao Chao
	<chao.gao@intel.com>, Xu Yilun <yilun.xu@intel.com>
References: <20241213070852.106092-1-chenyi.qiang@intel.com>
 <2737cca7-ef2d-4e73-8b5a-67698c835e77@amd.com>
 <8457e035-40b0-4268-866e-baa737b6be27@intel.com>
 <6ac5ddea-42d8-40f2-beec-be490f6f289c@amd.com>
 <8f953ffc-6408-4546-a439-d11354b26665@intel.com>
 <d4b57eb8-03f1-40f3-bc7a-23b24294e3d7@amd.com>
From: Chenyi Qiang <chenyi.qiang@intel.com>
Content-Language: en-US
In-Reply-To: <d4b57eb8-03f1-40f3-bc7a-23b24294e3d7@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2PR02CA0135.apcprd02.prod.outlook.com
 (2603:1096:4:188::23) To CYXPR11MB8729.namprd11.prod.outlook.com
 (2603:10b6:930:dc::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CYXPR11MB8729:EE_|DM4PR11MB6167:EE_
X-MS-Office365-Filtering-Correlation-Id: 6b6a1b7e-ba7e-4c95-e3db-08dd308a901b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?WGpLZVdqdm1CenpoZG5pU08raTNxeE53YTFxUTJiTmRMMll3ZHpuTVQ4Q2FB?=
 =?utf-8?B?a0dVZVNwYWhVZlFtRERqblF3Z2VuTlAybncvYU5rMkVNR0Z1aEZ0ZThhZVJX?=
 =?utf-8?B?cXAyRldTdmN6ZmdBa25kcjJOWnhlTDBxS25xUlh4ejlNb2NmYXN3OHBzWk5G?=
 =?utf-8?B?bFFoKysvTEpWS21VdXpVWEloQ0d2M0k3QkR2cDFBMzBQM2czZmVGanYrR2VM?=
 =?utf-8?B?K2gyb0gzaENaN0tCSGRsS1VRVG45aGJoTm9oMG1UWHF3NDd3dlA5K0hiaEMr?=
 =?utf-8?B?MDE4ZDVUMGIzZkNJUjR6U0V0aXprK1ZiZkF5TFkzcE9Yb1REMjhoemdndVIv?=
 =?utf-8?B?Vkg1Sk9jRlpUV3M0d0FCS3p0VVFwR3RmbGRZRmxOdTdzRjlKWGtWOXMyWmpt?=
 =?utf-8?B?Z0t0WkNoT0dwNTJJbFoydm5CZ2Z2eHk5ODdkQTh3cVBXanYyRjl0SFYxODR1?=
 =?utf-8?B?bE0yMGtVMWwyMnVkck92RTRQYlJCY1RQY294OXNjcWptaEFyMTZoU3pDUW1a?=
 =?utf-8?B?b2tLL3BhUUl3TlFoY0p0bjZrMU1hbHc3ZWdMWTNJTk1mdDJDU0kvRjNhS2Ns?=
 =?utf-8?B?bzNKWkJOK2dncEs3Y2dDSm52Sjgrb05nSFF5aEVKalVPc1B3ZjhWRVhkT09Y?=
 =?utf-8?B?dk8rZE5qNCtKSVYxRm0wMHhNOE5GWUo3TG16RGxDNW04V1pYNStIYjFpaFMv?=
 =?utf-8?B?NkhTZU5NdUxibjNMY3NNTkJRSGJEZW95dnFIL3BuMU9yRFkwSFk0M1NCT0lv?=
 =?utf-8?B?djF6ZktScUJTakpwdTRPb2luL0xrWnVIckFRb0xQRWRmNEZkeEhzNGFKNVlt?=
 =?utf-8?B?ZUlMQnlUbDI5bHNIZ2xQNG1UTUw5clZFWDJHVVhpSUVuaEljZFBFS0VFWita?=
 =?utf-8?B?VU5qNEVSeHYxeFRZOGRuSFZ0ZmkzaEZLN2VKemVWVitFeXdHRWwyOXIrMXlZ?=
 =?utf-8?B?UHFETjQ5Tk9yQ2NIN2p4cnlnT3NtaHF4QWkxUUMxN0dZWDBqaDF1MEZ3bHYy?=
 =?utf-8?B?SGhHUUtPSXVHQUdTSXYvMldmdUhiSGpIalFGWCtpa2NuV0YvZEpHd2tpdUdS?=
 =?utf-8?B?SXlUaXhTWVV2VHJzM2tZSFZQK2tOSWQyMU45TWNaZ3Z1emh0VzJyU2w5aVMy?=
 =?utf-8?B?RmZSczlILzhDWU1nbVhNbXIvcEhNSEp3UnB1aHpUT1g4QTRwbytlQ2Q5NFVI?=
 =?utf-8?B?RFRmL3lGWGpUOXNpdXA2K1M3MkNSZGptMDdsNFNsZ0lLeEU3OG1ZMWQwa1VE?=
 =?utf-8?B?M09iYXpQN0xrckZwazEramwzeWV5WjRyQXNPSnFkQ3BiNS9TQmdwVHZUY1J2?=
 =?utf-8?B?ZkJNam9yRmFqYm1VOWFxdXJyZy9PQmUxY29QK0lkQmtNWVRrZW5ZUFhQQVNv?=
 =?utf-8?B?Umo5b0l5NmVtL1JHdEUzWjI5YkhWaU55NlhOdnBqcTVOaGtuZmdrSE9BTGpM?=
 =?utf-8?B?TVhPYXhrZ2l1RmwydWJUWEltUnJqdVVyQTYvejhTUk0zYUdLd3VnMEd1Y3lQ?=
 =?utf-8?B?VVJjVW5ydzdJUmh4dGUreG8xeUJPZWdNTHo5WmVzNGIwYWQ1M2kvengzaGlB?=
 =?utf-8?B?Y2pEdnV4aW1iT0tHVHp1bWRUV011SkZ6c0s1R2J0ZHVDSCtNSTRFL1lSalN3?=
 =?utf-8?B?akhQcTJveXc4ZXV6bkNuSW1qWTU2Z3duQUMrbWdRa2hvcDJzbGVvTXQyajBP?=
 =?utf-8?B?SVVRRkR6VndYbEpxbGFVS3ZWN2hBYnN0dlR2bTRzU2g0cnNORHRoa2MvbVll?=
 =?utf-8?B?WjFoREJIYTlud1dTN0RQUGE3bUEwc0ZmeXdyUndlZXJXak9mYzQrLy9WdUJn?=
 =?utf-8?B?a0szS3B6L3c1bFVhUkordz09?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CYXPR11MB8729.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QkxiY2hiR2pIWkxBZ1l6N0R4ODJpMUluelZQU0JoUWRtRTFFL2NLR2h3aVlq?=
 =?utf-8?B?UVVFcjdBd0dDUHJrNGNFODlOL3pXMHc2VXJ1aWE0bCtZZ2dNQ0xrMkxYZ2tU?=
 =?utf-8?B?MHpXd3hpdHFZdDJrbk8vRnpRUHU2VnlONUhjblNGcHFGVEd2UDlUQWpGUHl4?=
 =?utf-8?B?UzRMTlZhWUtLSGV2bWRiUnhXZjZXYnp5V25ncWRaTGZZK3RnS0FOVjVsREJL?=
 =?utf-8?B?RURxRVNLdy9zVXZwa3dsT0wvaWVieklmblZPTUtWdGJXbTNEN2h0YnVJaWIv?=
 =?utf-8?B?eDNiWWdtRnZKdE1VNGYrV1h1cjNWMVJWNmZVdUppWVhTL1U4QTRWZm5lTEhL?=
 =?utf-8?B?c0gwVWprMjhwSjNjYTNHancwd3BmRDVkSUhnRlBNVmxrMFdEdllKQm5EU3ds?=
 =?utf-8?B?OGhhZzFZQXVZZzFyakFIbW0vWlNzSGt0Q2RUbndmY1U2VlhTbW00Wk91eDZH?=
 =?utf-8?B?Nk5NdFNIWHI2T3YvbkpRTWdBUFRXTlpFeVRmTkhjYzRFNlBSWS9laXA3N2Nw?=
 =?utf-8?B?c3dDazEyaEhRSHhCdXM2RHJxWWVQdDlKVWk4RytNVFBQc2xTalhPMTZzMEtT?=
 =?utf-8?B?Q3JEck0yRndOaEFQbUREc04raldYYjRqZ0NRN01QZUg0RDlQQXd1aG53OHJr?=
 =?utf-8?B?MFlUQ08yTitrZkRSVUdNNU9MeTV1cDlkL2tFa1hwUGljNTNLcmo5OUsyWWlo?=
 =?utf-8?B?TWlaQTVIWnV4Ujk4dm5SMHdycE81SS9oMGxubmpTMVJzTndCS0UrTDZxeUox?=
 =?utf-8?B?cXBHaytCQjJKM0JlaFRWQUw4WG8zWnBuQmM4RFgvbDJueWFXUHJJb3VualBy?=
 =?utf-8?B?SnRnMzIycUFBLytFYXp4K1JtTHdLUnluL3AwZUVWUExIMmE5UWl6YUZHTkdI?=
 =?utf-8?B?VnNtRVpXdThrZWdhd0llVUpLeVZ6T2hlUTF2bUV1U3doNDMyOW9lbVcvRVFD?=
 =?utf-8?B?TFZCcXNtNStDOUMwY0w4cFUyYmk5NXQ3ZG5JUWRjVGNKSER3ZnZSbGlGbGYw?=
 =?utf-8?B?aXNQVWtrbnl0bnNCQ080WUhoZkdJbkVkWTY5ak1FU2QwdEFPYVlFMEROQ3lL?=
 =?utf-8?B?U0hPK0FYVFJ1eHh2R0RWNHNKdjY5UmlJOWxIME92YmtxNCtaWFF4UHBjc0x6?=
 =?utf-8?B?WjNWcVJ5VWUyYmVRa1d4QUo1c3g0TUxpa2FBemtSZjVxc1RYdUhhN0IzTzlk?=
 =?utf-8?B?OWNteUhkeThOVjl0UFNBS0lwVmRhM1piN3VSRmw5djN1Y0pWV3dzWVlnZTlJ?=
 =?utf-8?B?RkFnZENRbEVtQXd5NzhucWt1WGFocDhRY1B2Vk85UktPWmxtWTFDalhhS1ND?=
 =?utf-8?B?UTJiS2NyRmVCZ3FGdXpvQWRMRTZSSWlZZ0plbzNFL1h6cWx5WkgvM3graWEy?=
 =?utf-8?B?R0lzY25USU9zV0dwcDUrNDB4SHdZVTNzeVNSYlNnU1dWZUdSOFd0N0p6S2tw?=
 =?utf-8?B?cHZZWGgwaVRYcjd2SCs3eEJ5RTZjRlFNN0xON2gzOW93NEZtQ0VycHFPNmhN?=
 =?utf-8?B?ZVFXcjE0Mm12eWpqV1JuL0gvSGRvUTRuU1RiL3JNQkhQMkppc0RtZUFnUGRr?=
 =?utf-8?B?VzE0MHFmblFta2ppdkdJaG9hdEE2NVJDLzlMRlpHWXhJQ2thN1AwTUdISDQx?=
 =?utf-8?B?UzRNcitsd0Z3VExLMFFjYXEvbEFsVEhtUGFmTHhXMC9PMWs1cFVNS2xoNFlS?=
 =?utf-8?B?QjVwUmhGS1dkMk9malVyaWR5R3BLaGRwOXdld09FQk1IeGRHQUVJa0RRanFX?=
 =?utf-8?B?UWxMRlJBeVdKTm1JN3RJVHRQd29PZ2szd1cyb0M3YlZCRG04OTc3Q3VVL3lM?=
 =?utf-8?B?Wmw3VmtpM1lGOStMTUtMTS85dzR5ZDBLWFRPS09tdVRsUTJydWdYcm53a1Aw?=
 =?utf-8?B?ak9FUjRXcGI3ZGk1MERCbGtnS3ZwdXJQWS94Q2x3Vk9ZazZCM3ZXNHhaaEEv?=
 =?utf-8?B?N0xBWGcxRTFHelk3cElmMHVmTDlFYUpWbVAwaVFXY1lianRydmpXR012Q2xT?=
 =?utf-8?B?RFYxVEo2WXp5L3BaQjZ0WHVLdmJWakVOWUkydDRTNUNITkRkL0R4aVZGcU9X?=
 =?utf-8?B?a0UxaTJ6cnB1VjBkdHZsN0czMTlBR0d0amU0YnlHN051WThQTnJnT1NacW5C?=
 =?utf-8?B?SGdJb1daQTNnWEM3SytRRm5OM1RZMVFsanV0TVZvREFxbWtSQ09KeGF6cDBy?=
 =?utf-8?B?MHc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b6a1b7e-ba7e-4c95-e3db-08dd308a901b
X-MS-Exchange-CrossTenant-AuthSource: CYXPR11MB8729.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2025 08:49:44.0439
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cupGXnthYaz30btqEnIMd4OsFtCwP+3tHzk7huzeq9RvWuGQHCyZWcB70PJMTgquZsgHiZRA6ISY8n1aHR4miQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6167
X-OriginatorOrg: intel.com



On 1/9/2025 4:18 PM, Alexey Kardashevskiy wrote:
> 
> 
> On 9/1/25 18:52, Chenyi Qiang wrote:
>>
>>
>> On 1/8/2025 7:38 PM, Alexey Kardashevskiy wrote:
>>>
>>>
>>> On 8/1/25 17:28, Chenyi Qiang wrote:
>>>> Thanks Alexey for your review!
>>>>
>>>> On 1/8/2025 12:47 PM, Alexey Kardashevskiy wrote:
>>>>> On 13/12/24 18:08, Chenyi Qiang wrote:
>>>>>> Commit 852f0048f3 ("RAMBlock: make guest_memfd require uncoordinated
>>>>>> discard") effectively disables device assignment when using
>>>>>> guest_memfd.
>>>>>> This poses a significant challenge as guest_memfd is essential for
>>>>>> confidential guests, thereby blocking device assignment to these VMs.
>>>>>> The initial rationale for disabling device assignment was due to
>>>>>> stale
>>>>>> IOMMU mappings (see Problem section) and the assumption that TEE I/O
>>>>>> (SEV-TIO, TDX Connect, COVE-IO, etc.) would solve the device-
>>>>>> assignment
>>>>>> problem for confidential guests [1]. However, this assumption has
>>>>>> proven
>>>>>> to be incorrect. TEE I/O relies on the ability to operate devices
>>>>>> against
>>>>>> "shared" or untrusted memory, which is crucial for device
>>>>>> initialization
>>>>>> and error recovery scenarios. As a result, the current implementation
>>>>>> does
>>>>>> not adequately support device assignment for confidential guests,
>>>>>> necessitating
>>>>>> a reevaluation of the approach to ensure compatibility and
>>>>>> functionality.
>>>>>>
>>>>>> This series enables shared device assignment by notifying VFIO of
>>>>>> page
>>>>>> conversions using an existing framework named RamDiscardListener.
>>>>>> Additionally, there is an ongoing patch set [2] that aims to add 1G
>>>>>> page
>>>>>> support for guest_memfd. This patch set introduces in-place page
>>>>>> conversion,
>>>>>> where private and shared memory share the same physical pages as the
>>>>>> backend.
>>>>>> This development may impact our solution.
>>>>>>
>>>>>> We presented our solution in the guest_memfd meeting to discuss its
>>>>>> compatibility with the new changes and potential future directions
>>>>>> (see [3]
>>>>>> for more details). The conclusion was that, although our solution may
>>>>>> not be
>>>>>> the most elegant (see the Limitation section), it is sufficient for
>>>>>> now and
>>>>>> can be easily adapted to future changes.
>>>>>>
>>>>>> We are re-posting the patch series with some cleanup and have removed
>>>>>> the RFC
>>>>>> label for the main enabling patches (1-6). The newly-added patch 7 is
>>>>>> still
>>>>>> marked as RFC as it tries to resolve some extension concerns
>>>>>> related to
>>>>>> RamDiscardManager for future usage.
>>>>>>
>>>>>> The overview of the patches:
>>>>>> - Patch 1: Export a helper to get intersection of a
>>>>>> MemoryRegionSection
>>>>>>      with a given range.
>>>>>> - Patch 2-6: Introduce a new object to manage the guest-memfd with
>>>>>>      RamDiscardManager, and notify the shared/private state change
>>>>>> during
>>>>>>      conversion.
>>>>>> - Patch 7: Try to resolve a semantics concern related to
>>>>>> RamDiscardManager
>>>>>>      i.e. RamDiscardManager is used to manage memory plug/unplug
>>>>>> state
>>>>>>      instead of shared/private state. It would affect future users of
>>>>>>      RamDiscardManger in confidential VMs. Attach it behind as a RFC
>>>>>> patch[4].
>>>>>>
>>>>>> Changes since last version:
>>>>>> - Add a patch to export some generic helper functions from virtio-mem
>>>>>> code.
>>>>>> - Change the bitmap in guest_memfd_manager from default shared to
>>>>>> default
>>>>>>      private. This keeps alignment with virtio-mem that 1-setting in
>>>>>> bitmap
>>>>>>      represents the populated state and may help to export more
>>>>>> generic
>>>>>> code
>>>>>>      if necessary.
>>>>>> - Add the helpers to initialize/uninitialize the guest_memfd_manager
>>>>>> instance
>>>>>>      to make it more clear.
>>>>>> - Add a patch to distinguish between the shared/private state change
>>>>>> and
>>>>>>      the memory plug/unplug state change in RamDiscardManager.
>>>>>> - RFC: https://lore.kernel.org/qemu-devel/20240725072118.358923-1-
>>>>>> chenyi.qiang@intel.com/
>>>>>>
>>>>>> ---
>>>>>>
>>>>>> Background
>>>>>> ==========
>>>>>> Confidential VMs have two classes of memory: shared and private
>>>>>> memory.
>>>>>> Shared memory is accessible from the host/VMM while private memory is
>>>>>> not. Confidential VMs can decide which memory is shared/private and
>>>>>> convert memory between shared/private at runtime.
>>>>>>
>>>>>> "guest_memfd" is a new kind of fd whose primary goal is to serve
>>>>>> guest
>>>>>> private memory. The key differences between guest_memfd and normal
>>>>>> memfd
>>>>>> are that guest_memfd is spawned by a KVM ioctl, bound to its owner
>>>>>> VM and
>>>>>> cannot be mapped, read or written by userspace.
>>>>>
>>>>> The "cannot be mapped" seems to be not true soon anymore (if not
>>>>> already).
>>>>>
>>>>> https://lore.kernel.org/all/20240801090117.3841080-1-
>>>>> tabba@google.com/T/
>>>>
>>>> Exactly, allowing guest_memfd to do mmap is the direction. I mentioned
>>>> it below with in-place page conversion. Maybe I would move it here to
>>>> make it more clear.
>>>>
>>>>>
>>>>>
>>>>>>
>>>>>> In QEMU's implementation, shared memory is allocated with normal
>>>>>> methods
>>>>>> (e.g. mmap or fallocate) while private memory is allocated from
>>>>>> guest_memfd. When a VM performs memory conversions, QEMU frees pages
>>>>>> via
>>>>>> madvise() or via PUNCH_HOLE on memfd or guest_memfd from one side and
>>>>>> allocates new pages from the other side.
>>>>>>
>>>>
>>>> [...]
>>>>
>>>>>>
>>>>>> One limitation (also discussed in the guest_memfd meeting) is that
>>>>>> VFIO
>>>>>> expects the DMA mapping for a specific IOVA to be mapped and unmapped
>>>>>> with
>>>>>> the same granularity. The guest may perform partial conversions,
>>>>>> such as
>>>>>> converting a small region within a larger region. To prevent such
>>>>>> invalid
>>>>>> cases, all operations are performed with 4K granularity. The possible
>>>>>> solutions we can think of are either to enable VFIO to support
>>>>>> partial
>>>>>> unmap
>>>
>>> btw the old VFIO does not split mappings but iommufd seems to be capable
>>> of it - there is iopt_area_split(). What happens if you try unmapping a
>>> smaller chunk that does not exactly match any mapped chunk? thanks,
>>
>> iopt_cut_iova() happens in iommufd vfio_compat.c, which is to make
>> iommufd be compatible with old VFIO_TYPE1. IIUC, it happens with
>> disable_large_page=true. That means the large IOPTE is also disabled in
>> IOMMU. So it can do the split easily. See the comment in
>> iommufd_vfio_set_iommu().
>>
>> iommufd VFIO compatible mode is a transition from legacy VFIO to
>> iommufd. For the normal iommufd, it requires the iova/length must be a
>> superset of a previously mapped range. If not match, will return error.
> 
> 
> This is all true but this also means that "The former requires complex
> changes in VFIO" is not entirely true - some code is already there. Thanks,

Hmm, my statement is a little confusing.  The bottleneck is that the
IOMMU driver doesn't support the large page split. So if we want to
enable large page and want to do partial unmap, it requires complex change.

> 
> 
> 


