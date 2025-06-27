Return-Path: <kvm+bounces-50954-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 65BFCAEB080
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 09:50:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3E30016AC6F
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 07:50:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19D962264C9;
	Fri, 27 Jun 2025 07:50:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Q6dRjKum"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A088225388;
	Fri, 27 Jun 2025 07:50:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751010605; cv=fail; b=Oth1KtWDr/3QBVmD/y9D/YjjJrrpLG3ycLh/THyszCRUyWwoI4klcfKJMkUvXslwzKngazBaGdK61/KHrVBc22Ya4H3QSxU0LN8XWKgtDzEW5Gmr1Bh/sB0JarXDBP4dWsnAdOz3GxJ6F+q3WOtbTzStpTKNbiS+b4PRhcNI3DU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751010605; c=relaxed/simple;
	bh=rJ6aBmi1sBOrCQ7GnMI2h+PryjgGyxuZoosaol5SQ7s=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=BgyM4elNiSbgBvsBM5wtqP+N469DJAkDwH8NGD8naNNLF1BKiOogyF1h40al9QAiFkU8N/kXEMmSqBL4LU93/MvIy7Livj9PdTBtrutg3mdr9OGggEF4BXdvPiRf948jJYODL3jGwhiJ3ArhxKvV/lw79LgguSZecnnGvv1SGv4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Q6dRjKum; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751010603; x=1782546603;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=rJ6aBmi1sBOrCQ7GnMI2h+PryjgGyxuZoosaol5SQ7s=;
  b=Q6dRjKumpb+Y/kicYymsgz/4MBeS7ZkSZOrhDefb57K3R3EduHekrSfl
   dD0Yna75+YIt3oM5b28MGozRV3/2YhnG8tcJas17Z1wOrpIrZnsKXZ9Rb
   03aSdpj7RDuRc4l/WJOCtRe0OCacncvSOOxFYrYdLgyaMSryRSmAdddx8
   QwgaEFspzc2GthbUPLhsZBjWHizfqMnSXix+oY3DGkhhGKnivv+7l+RTG
   oa617Df+t0iT7xc2rX+ZvR49zq/Qkxoyb7LXU0jEg3MUg94msxpt8Nax8
   seNDsenpHLPz6AaAs9i7iMIc3UGKxR9i94GWTqyiW1dA1ahOKv6Ml2wLp
   A==;
X-CSE-ConnectionGUID: 9/8Fi3oNTtKgnbPYPvzO+g==
X-CSE-MsgGUID: jjrRGtqnSjGH7Pp3zNmZnA==
X-IronPort-AV: E=McAfee;i="6800,10657,11476"; a="63577324"
X-IronPort-AV: E=Sophos;i="6.16,269,1744095600"; 
   d="scan'208";a="63577324"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2025 00:50:03 -0700
X-CSE-ConnectionGUID: cAsf1w3eSCWhVRMySfCluQ==
X-CSE-MsgGUID: 9xoxruwkSL6wanR0KTe60w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,269,1744095600"; 
   d="scan'208";a="152478823"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2025 00:50:03 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 27 Jun 2025 00:50:02 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Fri, 27 Jun 2025 00:50:02 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (40.107.96.42) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 27 Jun 2025 00:50:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=q4EBBGs7QwlsS+sc/b2UmfxeMFgFK/jnZXL4PBM9yPd4g1zN7gLgvzO/gAEV22dylSo+1hhjOKErwFoTtAg5nstqRy/wTBsQPLkxfwUYxllXTbStFYhLi2Wp98juzyD4OIHnIZguttme88dJSLXdEjWBeYd6wteIYhc/Qvd0+wn6ipcX8/bEc8KAHlBCY3UZM4PqCKCNqiLkE1K7Vtq9flQ1A4VQwt66fu5bRzUblekiuASwNZ6vjbXPLFGs9LSZJOdBMhE2G1JS7weMWwQ7glSEc46HUWfHP2+DdcUSxgzbbsKTXnv3zCOAnoRKlwXYt0vaXc2VLAPpQdieIRdpcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=My4rSxiTipWqwIbDBpP9plMwL37UQLNFzl9a7v9TXq0=;
 b=dRy35v+XSU3gkvat1CoCp2cWGuen3NmWpazAr60js5S0wLom0Ktb7HKGLgpgAe+bYV7g+Qqg+YRq3JSEgYBrqjMsTzG8BQzm9tbl3pZ2QrKrrcMWYO/3K5W4FMGEKMWW1C/05jWnKmW5GppBIiSfQ9Jf7D7mlE+V4D110KmIVqUf1ixnsq7s378gQ3ORnJ9l7MVZuBsLEXyaVy1Czh3m+aDnCyZ+2DOUt8bbanIqwVnx9tncd9HYdxVJTlnNaxskp0PSKMa7grqOxf2FRdILkdX0jVzlF2VOIyVjVU0KP8WxlsVneRQaVuywVKAP1jEaICIGzsLcjwPSaRpoKi+7jA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BN7PR11MB2708.namprd11.prod.outlook.com (2603:10b6:406:a9::11)
 by IA4PR11MB9231.namprd11.prod.outlook.com (2603:10b6:208:560::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.26; Fri, 27 Jun
 2025 07:49:40 +0000
Received: from BN7PR11MB2708.namprd11.prod.outlook.com
 ([fe80::6790:e12f:b391:837d]) by BN7PR11MB2708.namprd11.prod.outlook.com
 ([fe80::6790:e12f:b391:837d%5]) with mapi id 15.20.8857.026; Fri, 27 Jun 2025
 07:49:40 +0000
Message-ID: <dba2841f-0725-4b58-b633-650201c053b4@intel.com>
Date: Fri, 27 Jun 2025 10:49:34 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv2 04/12] x86/virt/tdx: Add tdx_alloc/free_page() helpers
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <dave.hansen@linux.intel.com>
CC: <rick.p.edgecombe@intel.com>, <isaku.yamahata@intel.com>,
	<kai.huang@intel.com>, <yan.y.zhao@intel.com>, <chao.gao@intel.com>,
	<tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<kvm@vger.kernel.org>, <x86@kernel.org>, <linux-coco@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>
References: <20250609191340.2051741-1-kirill.shutemov@linux.intel.com>
 <20250609191340.2051741-5-kirill.shutemov@linux.intel.com>
Content-Language: en-US
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: c/o Alberga Business Park,
 6 krs, Bertel Jungin Aukio 5, 02600 Espoo, Business Identity Code: 0357606 -
 4, Domiciled in Helsinki
In-Reply-To: <20250609191340.2051741-5-kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DU7P190CA0003.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:10:550::16) To BN7PR11MB2708.namprd11.prod.outlook.com
 (2603:10b6:406:a9::11)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN7PR11MB2708:EE_|IA4PR11MB9231:EE_
X-MS-Office365-Filtering-Correlation-Id: 49aa2644-a81d-4080-42e5-08ddb54f2bdb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?bDB4eGFxbmdaRk1lVzdjK3EyTzVRLzRTRVp6bjNpczRBZHlrSVRlRDNOdlM1?=
 =?utf-8?B?T1NkV2hBdG9ndHNOcXZiUTIrTjY0dG5VeFdzMGhRSElKSW5DZ3dhbHB0dXI4?=
 =?utf-8?B?OE5uWVlscXIxVlB1SnYzU0hvOXJSUzMrSUdKckxXQm9rNXJNWmI2MkJpenll?=
 =?utf-8?B?TllCQTVmZUY0OWNxUTRUSnZ2ZWEzdE9pSG5GazlTNmFTSGhlNkpTWlNCejFP?=
 =?utf-8?B?VmwxeksvNWlPbUNqVzI4WmJnOHJVYS8vaGI1V3FuSUkzYVRsbXJScnUvdlhw?=
 =?utf-8?B?WElqaCt2dUowZ21qNk45UlVBenNHMjVvdGY3MFlINFRPWjRXc29EdzRIQTc4?=
 =?utf-8?B?aFl0eVYvNnQzVnJkRlVWQ290ZmFKTWw5aERZQXpvWFlpeExHVDl4c216RkM1?=
 =?utf-8?B?dDVmZUVSeU9NV09WV09SaGRNWHJCVGlQWlVyQ3p3Q1d6aGFWWVdDeE52bjZh?=
 =?utf-8?B?Q3VKdjc0MVZQWnZqbCtkUTh3M0FtbTVuTklLMHJ0TU1pMWtiN3RzS3FyTzNS?=
 =?utf-8?B?MTZXZWxqOENYYVhoUEFVMjZFdGlxVllMVzhiWDUvbENQNzF6REhBRGgxaE5M?=
 =?utf-8?B?Q1BCdlNHNXVsRjAwa043d3ZtdzZZb2pBQWlFN1RtdUJJQzBXL3JZWUIrU2Fk?=
 =?utf-8?B?SWpVRGs0VG5YNWFFbTVCYjRZYmNCTjRVWlI1VDc5clM1RlAzdVNQVFkvK1dn?=
 =?utf-8?B?VVlyYXVKTHB2Wm5wVnorL29SWThjWHh5TFN3RkhWRUJQU1ZzaGI4aEhiNzV0?=
 =?utf-8?B?dndYd0dmY3R1Y01yNGo3MitNWUtuTCsxWkx6aHM2YzUwemw5U05NY0xBYVQz?=
 =?utf-8?B?SXdsYzVjdGxlYTRTKzN0bVBPQWN5RU1SaC9xVzM0VldmaWlrM0w5ekJyZXRT?=
 =?utf-8?B?Y2daRy9XL1RibG5VcmU2WHg4SWlHeE1yODB4YVd6cEEyM2hrSmVyaWJXcUNS?=
 =?utf-8?B?cnhWYTc0TXJuendESU1yZXZLaW9jTnNTQmFCVkxJNnMrbGlWeGFkK1FMQWl4?=
 =?utf-8?B?WkxUOEtwRERtQlZJQTg0QXkxWmYyVk1aam9vUmlvbVhIakx5eFZLeUJtdVFw?=
 =?utf-8?B?RTRzWXZRV1lmaDZNMG0xRGhPQkFMUTl6NWY0WlFLejIwQlBtSjdzMkcyVlJB?=
 =?utf-8?B?TWg3QXFoNnFmbmJsL1NUeWFHRWNPWm9FbWM0NThxSkY0L2NpZktpd2RScDdo?=
 =?utf-8?B?Y3dFMHhkZitYKzBGNUhIQjU3UWlOVHJ2Y09IR0lIdjdMQkVQeWx4eWJTWm91?=
 =?utf-8?B?eDRaZ3RENFlIYVlEK0J3Z294WVcrOCtIL25mVWVYWXh2MUtIdVkzTjJ1Q3VI?=
 =?utf-8?B?VDl5UGJ5ZVB3SlNEcTRjMjBmd3ZBM0ppL3JLaWRSM3hWMTBIWWduVFZnd1Rh?=
 =?utf-8?B?Zkt6SDFCWkJRdjFhTnFMT2hpcVkzKzFCc3N2a0hJTjg5UG1mY2Q4REJ1V01j?=
 =?utf-8?B?YS9vUDVQVmp4SjgxRTI1UGJ5TW1rNUw5TStnMkdaeitQdWh0SDB3YjlKY1RL?=
 =?utf-8?B?YlVvbEMxK1dOQ24vUTRhVG9xdXVacm1YU2ZiZitZZEdUYnpWRlBMVjdTUUh0?=
 =?utf-8?B?a2hLSTVUb2JLYWpYcWY2bW5Tck5JU01aRnJKSlp6WUZEWlBiUzFYd2lYY2Jh?=
 =?utf-8?B?aXVWNUlLbzhnblp5VGx5UkVXWXoyZC9rbWdHSEJlOUJCYWk5cEdsN2dsaHY2?=
 =?utf-8?B?eTFYTjhPM1laSEUxL1JCcU5Md2NVeEhITE1jUHhyM1ZKVzJlMUMxazdmTmp0?=
 =?utf-8?B?UWMrRWxLUVl6dVlPS2FiaXV6UElLb1NjclN4YllMVlpYeEVucmNLc212aVVU?=
 =?utf-8?B?RlJ3UldvQ05ZRkVGSmZQSVJyeDRocnVzcUlNWWtlTjFZOHBpVzZhT3dMSERn?=
 =?utf-8?B?cDdDQ3EyMG1FczhIQWU3Z1U0dVBHc3QxcTFRZnFRcmxhSVVKOEUrNFBCcnQ4?=
 =?utf-8?Q?Wt8zvhTTAfQ=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN7PR11MB2708.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZENCRXlManVIU0NjSWF4ei90UzN5Tjd4L0cvU3ViS21wY1RaVktxT3ZuT2dS?=
 =?utf-8?B?UmxsREJOeWR6NzBzK0I5d3JZSDFVamhVVGVRTHpLazc5MjRjSFFDanNUT2hI?=
 =?utf-8?B?eGR4ZW5xWUxmVWlISTQ5MU9PbHQ1T0RFYmtObjNVZFZtVlZtZGdlQVk4eklQ?=
 =?utf-8?B?cXVVVHFVa3lmblVoaXMrM0ZpUTBwSkxuOGdMazk3dkFTMTRJZzc0Q1pKeG5k?=
 =?utf-8?B?NTZNR0l6SEdRYXBKeUt3MTFRL2VRdW1mSWlCVysyb2J1N1MzUTdXNnNrWStl?=
 =?utf-8?B?Y1FBbUFDTG1sczR1VXRQOEU4Z0VJNkZjVDE3ejIrMWoxL3grUEwzNWM2Mnll?=
 =?utf-8?B?TTBDeis2cGV2M2k4TS9BbG93SnVveVVrSENHZVQ5NlU4RWhUTDBpMWRXZThT?=
 =?utf-8?B?RDBaY2tYYUpVT2tYdGFDbldENXc4anM3bDM2aGtYOXBaWFhxV0x1L3M2WjQ4?=
 =?utf-8?B?TjhqS2pUZGMzTUJ5ZUFxQXZQbzBJQ2ZUekc5cjRSTkZuVWN0THBCd25JOTdl?=
 =?utf-8?B?b3VTZ0E1NlNYY2RsZER6WDQzekt4YjVpWXBPRS9YSWlCL0txalF4Z0p0WWE4?=
 =?utf-8?B?aXdjYS9OTkdQQW1MSCt2QkVWNGpxa1RMVVJZM200ZUFhclkvWEl6U0t0cFpV?=
 =?utf-8?B?RnhYWHZWaG1tMk5oWWdoV2pWS05zZEh6YlZWUmd4b21CRW5uLzFRcVVGTjUw?=
 =?utf-8?B?ZUwzeXY5RHBGL2VsVHdjWU9tcEc1ZG5sMHJDcW1mcmJLZnZIWjZFRUo3NHUr?=
 =?utf-8?B?QjNYWTRucE51UFYydFdob0tPQUNJUkhRS1hPMU1Fd2NTeUd6QVNyK3JRSVJL?=
 =?utf-8?B?QnF1SjEvMHVpZ0oyWEFxdmFJZTlFUmtUS0IxWUJmcHNiTGVFZTRveWswRFVl?=
 =?utf-8?B?MDhPTndPR0NDSVZIQmdSV1dDVXl5ZUtvVGNwdkNkTzZGUWNkK2F4b2FNU3ZV?=
 =?utf-8?B?c3NZM0hZUnBic2dueTN6TFI4UGZrZnUwb1FKQjU5Q01ieVZTNXVRUjJMUE9Y?=
 =?utf-8?B?Q0ZTeHRKOXhjZnpXUy9ZelY3eUNwQ3lZZzIxZkpaZ3dOM05STlZ0Tmt5WnZB?=
 =?utf-8?B?Z3RCZVg0cTNuSWNERC9HR1c3Z3ZLSWw0blVwTzAvN1lwV1ZRN1QvT0paR2J4?=
 =?utf-8?B?MjRUb3BUVzlFdCtYZXd2b1dnUHJ2cEUydmsxeVEvMHlqS2NxT1dGRUkrYjBp?=
 =?utf-8?B?cFJxeWN6R3hlRFZNYnlmTE0zdFVGMjdqUEd4bS9wOGJ2ZlU4T2xIYTM4cHNN?=
 =?utf-8?B?MEdDbWtBMVMwWHZuVzl5OUN4dUZUNXhYQmpkUW5RMnhMWXhvSTAySnhSbTkv?=
 =?utf-8?B?RGtwdUV0M0pacHJodTJPdXMrTGMzazA4UnZ3dVhzTUd6SkRmWEhRV3pjWmV3?=
 =?utf-8?B?MmpqalgweUhwYjE0N0pUaGxhZ1VhL0wvVVhWWFA4cjI2anZGZDVhMUpRWjkw?=
 =?utf-8?B?SjR3OUpBdm5KVXNJQUo2QXFtN1BRRnhIbWhTeFlocTN6R3B0Nk9Ma05zZWdq?=
 =?utf-8?B?K1ViK1M3V3pZVkRvM0tpOWRCazlZcTBQSXFWcUZURllTZmtwRXNMMEduZEdR?=
 =?utf-8?B?eCtKMkRGY3ZTMElXWXgxU0g5OFNTb3ZrekFEajdPcFp0MzAvUThQKzJaUU9h?=
 =?utf-8?B?L0RFd3drUHdWbXArNFVIeWFna2VmejU1MkVCdTN3UGlvaUdLRXc0THFSN0sx?=
 =?utf-8?B?aUhDdXcwZHhtbFppdUxDVVFqZEtKS3J0eG9nUjlaamZQNVUvWURGYnYrdlc1?=
 =?utf-8?B?Z2VIZ0M1Mm8rYmFXODJpdm8rRThMR3IvczNHZWsyaWdPTUliaS9CbkF5NG1q?=
 =?utf-8?B?OXpka1Exd09hSGRmdlpMY21CdUpMU2RVWXR6RGxRVlFUQTZPRC9UUEdPakJX?=
 =?utf-8?B?akppbmRRYWVLU0JzNGs2MDZ6ZnZxbEhDNXdIK3JhYjJKSTZmVU1WalVNMzNL?=
 =?utf-8?B?SHhpY0ZXSHpVTEZPWFFZNjNWV3p2TDFmVzZFTUpWei9WbnV6WmgrWjNyRzJU?=
 =?utf-8?B?U3FNeHZjWG1FTWQ5SHpkSXp3SXprdnVuQ3BZcUpCSmw5eEpPWUlNa2dMcldL?=
 =?utf-8?B?ZWVtNTZKc3JrZ2Jvd0dJbEJkSUFxcGl0bGp5VnJQSFdDSDNwaFpEbnRSbHl6?=
 =?utf-8?B?engxV0FtVjlzd2tvVi9Ebk5lMmdMYnRLWVhOZFJRTStweTg5Tko5MkNsTkhj?=
 =?utf-8?B?R3c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 49aa2644-a81d-4080-42e5-08ddb54f2bdb
X-MS-Exchange-CrossTenant-AuthSource: BN7PR11MB2708.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jun 2025 07:49:40.3790
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WNhjKKbAXBcrBn2oGkEmuKptrDOq77cKuu4IF6ZBnEPhCLvVObbvdS3LRjdLci0hl1veAEb1nhsk4Mkh9yORBg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR11MB9231
X-OriginatorOrg: intel.com

On 09/06/2025 22:13, Kirill A. Shutemov wrote:
> +static void tdx_pamt_put(struct page *page, enum pg_level level)
> +{
> +	unsigned long hpa = page_to_phys(page);
> +	atomic_t *pamt_refcount;
> +	LIST_HEAD(pamt_pages);
> +	u64 err;
> +
> +	if (!tdx_supports_dynamic_pamt(&tdx_sysinfo))
> +		return;
> +
> +	if (level != PG_LEVEL_4K)
> +		return;
> +
> +	hpa = ALIGN_DOWN(hpa, PMD_SIZE);
> +
> +	pamt_refcount = tdx_get_pamt_refcount(hpa);
> +	if (!atomic_dec_and_test(pamt_refcount))
> +		return;
> +
> +	scoped_guard(spinlock, &pamt_lock) {
> +		/* Lost race against tdx_pamt_add()? */
> +		if (atomic_read(pamt_refcount) != 0)
> +			return;
> +
> +		err = tdh_phymem_pamt_remove(hpa | TDX_PS_2M, &pamt_pages);
> +
> +		if (err) {
> +			atomic_inc(pamt_refcount);
> +			pr_err("TDH_PHYMEM_PAMT_REMOVE failed: %#llx\n", err);
> +			return;
> +		}
> +	}
> +

Won't any pages that have been used need to be cleared
before being freed.

> +	tdx_free_pamt_pages(&pamt_pages);
> +}


