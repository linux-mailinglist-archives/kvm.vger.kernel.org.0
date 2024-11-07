Return-Path: <kvm+bounces-31057-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4114D9BFD50
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 05:16:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 00613283696
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 04:16:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0800318F2C3;
	Thu,  7 Nov 2024 04:16:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VhA6O2z+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E62C23BB
	for <kvm@vger.kernel.org>; Thu,  7 Nov 2024 04:16:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730952995; cv=fail; b=AHSL2uHAgn2M76d2ldIYYs3haXBck8WpsQGwhG1Hck4MHBr7sybCpaI7jDJ6KVXBgjBrElLLrRLxxrVJHvs+dLUESfApspMVAdgP5bFQER6C4QkW2rjx/+oHsEOV5fJR+4y2n9lFf1VJTUPEFKOAAhonbVG5wqVvDobmxaYqyVQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730952995; c=relaxed/simple;
	bh=YUTA33ysBgu8dazjhskbp6fw+mOIgt1y0fmrJ1B2aac=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=VzU6SyMTVRFbVxL7MWm7y9+J0YH97QRuqyXVb991OPbX7UY9IkmrZZiw2j5ggz6bh7bYBtR9aSz/16a9AUhQXEPysJqYY4zoVgcn/hYQSwl4vCW2yD2kYuCDK91TGGIHvcBk5hGhYb1O9bQXxXJyMw6/SynY+aft072YVHCqiBk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VhA6O2z+; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730952993; x=1762488993;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=YUTA33ysBgu8dazjhskbp6fw+mOIgt1y0fmrJ1B2aac=;
  b=VhA6O2z+D3DI6qAWg/3uzgsqJT3wZ5w0I02va9wvv9sUcjgKEKiKVxHc
   NBhm9ZX7Q3BTwUCx3ucnsCzriPlrCpqwy+A1NoKD7ZGNZAECIoUymEU9v
   u4RKBT/XC4ox3IHuDgNWJfifu9+R1cT1f9ans6+wa5wIV6z+KjEiDyzAb
   06nIXlWzjEMPnaJZgg5lRIBzrYTGWxCAV+S1wEUo3j55NWfWzMEbQ7ZPr
   4B/zzEfyj+PggjGJ7z8VzfnGq7t6c943ZGaMZLd5uc72tFLF8/EzW99L1
   iDsRtmZ3duoq9L5lD6wRBX0MzjvOJhvQqPAA4N4MreYtX4VKEZjlff8HD
   Q==;
X-CSE-ConnectionGUID: WcPI46SARRaLme1YMXYLzA==
X-CSE-MsgGUID: lnuD/SIrTb6wIW/xeTeWcQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11248"; a="18402889"
X-IronPort-AV: E=Sophos;i="6.11,264,1725346800"; 
   d="scan'208";a="18402889"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2024 20:16:33 -0800
X-CSE-ConnectionGUID: dU9W7T8/Tn6ZMACXJqojSQ==
X-CSE-MsgGUID: maDIAWsTQqSPwzk4K5KQLA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,264,1725346800"; 
   d="scan'208";a="115734510"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Nov 2024 20:16:32 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 6 Nov 2024 20:16:32 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 6 Nov 2024 20:16:32 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.173)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 6 Nov 2024 20:16:31 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AFfrLbfgywEkZ6N1P80Ep2ZsDvYCZUuRcHqPX254y3OG9cfGljOKo1mynS7p85rhaeWYVj+f48iun6z4BQk9aRmaBPE5gQfHjKJFds7BsxeeUSBsuBpBq1H1rC5uFnMqywL7QlCi+vl9B97iYO3uIlZd90C0BuQOgSl/r4htSsRtxNA5EwvzsKp82d1VPX4qJsWkwE+M84NgwjnRwm69IziEHNge65QX/DgpgkhRYurRwxg+tCzrJ1BMaUX17bDuJaq5seB1U0HgMgZSeQNG7gUtx5SiKu8FelAR8m2fDkFggsoGAWRw2eUdxNSKgiVyrtg/N70LU/LAq+ItaWXzfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p/Y8m81bPTzHxQPRqmWuFt7z5+cyeBZUVNLxckJ736s=;
 b=ah5odhijm6TtbJCgWm45TPME3WJBkeT7sDH9Fth1EabvnPgJpJ9LmdwQSjAVXcD5U0Yxqn3uOihdFC0DjQfKdwTKw+7l04/DzH59o+xclGfb9Ug2yAiPw9+BGXtDcZld5fPW27Bc/UuO7v4xh1bfyB13UwZJE39D8eAjffQ8fiZmKcLmNUldq9wH02jwWPTQp+i48h+7+HT58PWHP22+FjqYG2mAxteY0k+MrHmxL9KotEOECXcZKYhDjT86iuYvwhOO4MibutABSIgc3GyVPSzbVOHBV3gnlHecAyRS5H1Cf/JNiK01f81Fnww6CSf9diSuhFFMfIfjVR5o53WP0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by SN7PR11MB6924.namprd11.prod.outlook.com (2603:10b6:806:2ab::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.30; Thu, 7 Nov
 2024 04:16:29 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a%4]) with mapi id 15.20.8137.018; Thu, 7 Nov 2024
 04:16:29 +0000
Message-ID: <8de3aafe-af94-493f-ab62-ef3e086c54da@intel.com>
Date: Thu, 7 Nov 2024 12:21:05 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 04/13] iommu/vt-d: Add pasid replace helpers
To: Baolu Lu <baolu.lu@linux.intel.com>, <joro@8bytes.org>, <jgg@nvidia.com>,
	<kevin.tian@intel.com>
CC: <alex.williamson@redhat.com>, <eric.auger@redhat.com>,
	<nicolinc@nvidia.com>, <kvm@vger.kernel.org>, <chao.p.peng@linux.intel.com>,
	<iommu@lists.linux.dev>, <zhenzhong.duan@intel.com>, <vasant.hegde@amd.com>,
	<willy@infradead.org>
References: <20241106154606.9564-1-yi.l.liu@intel.com>
 <20241106154606.9564-5-yi.l.liu@intel.com>
 <268b3ac1-2ccf-4489-9358-889f01216b59@linux.intel.com>
Content-Language: en-US
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <268b3ac1-2ccf-4489-9358-889f01216b59@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI2PR02CA0017.apcprd02.prod.outlook.com
 (2603:1096:4:194::17) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|SN7PR11MB6924:EE_
X-MS-Office365-Filtering-Correlation-Id: 2f263f58-7efd-4d87-66d4-08dcfee2f41c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?VnVSeWUzMjJNSzk2TVdKejJ2aVBrZFMyUGJCOWZFdVlxdlJyeDJqS3UyckdQ?=
 =?utf-8?B?VkJKNEFEQmxoZDNtYm9RZ2xFRmFKMkl4Y3Z0YjdDd05iRlgrMGhIK1lXbjlL?=
 =?utf-8?B?emRxNUE4WCs0UElqUEVQeExzVEhaRmtiakRVcUw4MVhFNFBoT04rbjlRdDFE?=
 =?utf-8?B?cTlkUExHVjVzeXZDemV2SmgxRlV3MXI1bnpaTWNCMVBkRkprQjVwYkIyTHJH?=
 =?utf-8?B?Q2Mxd3Z6eDYxck1TbG9Nc0U0WG5TTVQxWnMxSnhNNkxqVjhOQUllL2tIRFNr?=
 =?utf-8?B?TnIxMXdmLzk4RjdsMytDQXMyS1NkZy9pM0RDNi9FS1lLUXN1bWF4MUtxODhn?=
 =?utf-8?B?WHphaTJpOTE3Z09PVCtRV010MU5aYTM3WVBpSHBTM2pqY3hBN2w5U09ZR0dR?=
 =?utf-8?B?anp2WWorcjIwdUo0Q1ljRUNpSkJBQVlzWUJFZnhONERxbXZLci9OR1UrY3JL?=
 =?utf-8?B?K1RleUdrQzIwcFplZlUxd3RTbTJvRTZMVDNoNmd0VU9WM1RJS1o0WE9VTDlx?=
 =?utf-8?B?SDBadUkzZDBPQUxkVXRDT2VtTTFlQUtHalZjY2NiNVhsWXhkU3g5K2tCdlJi?=
 =?utf-8?B?SFlxWVNRYlYvdWNrYkV6WXJTMC8yQ2wvSXpaV2dOZG03Y2NxQTJjd1lPTC9H?=
 =?utf-8?B?eGU3VDhCZS9PVGI5WS9zRklWM1h0RFREN2ZQK3l4WXEzSlJGdUFKMFFPamZF?=
 =?utf-8?B?a2R1b29QekJFWGVhZGduUU1PbGtKc2phbU5PN0FQaFhPalU0RkNIODVOSDBt?=
 =?utf-8?B?bldSdWowVlpMMkp0ekxQYXQ4Um5QSjRYOE1HNHNUb0FRV2tKZERuaXFWZHp3?=
 =?utf-8?B?R3d6UHZDZnFRWVBkRFZhYytacklUWmxhQU15bldGM2ZCejhOdzNvYmxTZHpP?=
 =?utf-8?B?RXJWWTZiUlVtaTVsQ0FkaUhRazIzMDZxZTFJNm1mODVGZHlrN2RwSlBaQ1lq?=
 =?utf-8?B?NXlhblhldnA0SWNxMUpzY3ZzdUZsY1k4UjJ0V0FxY3dVSG5sSHc5aDFFaUlX?=
 =?utf-8?B?N3l6eVkyWVY4T0V2czQ5SzYyYmdZNHptMmtWMWw4SHQ3VzVMSXVuUEtjamox?=
 =?utf-8?B?cVViVEJmNStlVWs0c0pJaTdRczY2RnRkNEx2Z1dyTEVEMDY0MDBVWEo0RDlx?=
 =?utf-8?B?amR4MmNpSXNKczI4TUJBL0dEYjFXUVViM0xTdUZWeFVxZ3d1MWhKWWZrVWpV?=
 =?utf-8?B?Q241QmdvUjVEaU5tZ3BYL2FldzQ2M3E5TGh6UlVhcnB6SHI0Rk1WMHR4dk0v?=
 =?utf-8?B?bGlaT1JqZExtN3VHSGpmcytMS2JHMnNnRUk0YWZKczY2YlNhT1lqU3NjZlZR?=
 =?utf-8?B?ZEw0ZVNOR0RPdjltUHRtdWVlbU84N1JDNjN2aEZSMWR0ZXdkMmtrVTk5S0w0?=
 =?utf-8?B?N1owdmxXaEYzTjNWNkZDbDhJYjd1VGl3aTh5c2JjK1pXYlVXVzloOVN5Q3FI?=
 =?utf-8?B?SU5GZnZ2Q0tiZjBxSjBYK3VFcW5iWnA0blJTMmJhWFdaUENNZnJKNS9CcEZh?=
 =?utf-8?B?ekcrOHh4MTJsMDNwL0xKOVBjc0dERm9FaXVHcXBYMEc0VjR2RTJ2VjJmS3p5?=
 =?utf-8?B?N21JR0ZtYWZpejJmOVd2OXZYMlVjb0ZwUUhGenB3ZHp0RWwySzhzbTlvWVdN?=
 =?utf-8?B?b0RGUzdCT2tkeVRqWnJ1bktjUmhrclBCNllkN0daMjBpcUZ5ZlJ6TjhKcHcr?=
 =?utf-8?B?dU1EQlQzVTZtZTgxVGd6dkVGWHlHcDlwME9CM2JYVmFGckF0a2daMEJNTVZs?=
 =?utf-8?Q?MY3QvdHxxWtYaqmJj0=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?M21oMFRCR0krdzFwaFhyV3RzTjdaS2F6YmRyTHdWRmE1UmFUTGMyK0lMWGYr?=
 =?utf-8?B?SDV3MmpCU2VTQjE4NzJ4SWRITmtyRkNLMnIwNlQ0QUlSK3RZWnhQREhDaTd1?=
 =?utf-8?B?cjF3RmlscXBlZFI1dTBwejEzZCtCcGVybkFYSlpQcFNJVGo2eStqMVM1V1JI?=
 =?utf-8?B?dFJSWVA3ZEdpRm95djVpamJUVVA0Nk1mK2R3VFEzMzBHY3pvUmgxdVUyZlM3?=
 =?utf-8?B?ZHoxKzNMbE9qMHVVaGV4UGZDRHFVVXVncGs3ZTgxY0liU2dqdU1WMlRuKzkv?=
 =?utf-8?B?UlMrUVVPVFU4blIyNWxPRThHSzkwa2xha1RQTlQvcGp4cUNUSldJcldyYXNn?=
 =?utf-8?B?VnJKUUY0YUJEeldlM1J5WGgzbThVcXl4UEFyY2lSVnRUbHJBTXRVdzZRcnAy?=
 =?utf-8?B?bHYwdDFLdzFwSHEyektsU2NGWGwzK0cvSFM1a3VhTC9QQUlQdUwzS2cwM1ZD?=
 =?utf-8?B?bkl3MFJHVVB0M25KT2o5YWc1bHljZE5oQko0VWoxOW03eDRmNnFyMVpoU0Jj?=
 =?utf-8?B?ZUwxcGZIZjgxYkMwQVY3TWpBVzlod2oreFpMT3RwTFNPMm1xcHlzTElua25O?=
 =?utf-8?B?WDBYM1BGTDZyTEIwdVQyMkxNVzZMQzFKTHk4aWVoTGlKNnNXUDJXVnY3MHZo?=
 =?utf-8?B?QWJsa05WMWI2RWdvTVlQWGZLQXVBYzE0aGRyM1VVM1hZSHVlM2FxYzVPZ2J6?=
 =?utf-8?B?YmpOWS9oRzR5L0YxNWVma3kxQ213NWZwM3Y1eUsvcCswVzhXMDZQZ3puSzNp?=
 =?utf-8?B?NTd5N0FmWEdhSS8wWm9kTVpJdU1GaEhmRWFuVktMUkpHZ0RMMmhLdFNlOWtx?=
 =?utf-8?B?UEVjSVNOcHVmWlZkVWdZWHV0eU5QOGdrR2dpTkpXNmlCcXNmdm8yS2l6Y2Js?=
 =?utf-8?B?djBzNHhMMzRMTFUwNUN4TWErcDE1Nk5qL1U0Q29CUzZ2NlRKelQ3bGh0WHFI?=
 =?utf-8?B?WkR5QjFWaFFHdXlYaUdDUWQyRDdrc3FmdG9QSzBVWTFQbE4yNllSbUdvaEJP?=
 =?utf-8?B?aDJzVUx5bmh5eDNXejdVMGJZK2hBWGliYm5taEgvNHJrT0tnQXhmU210UWdV?=
 =?utf-8?B?UG9idWljOVNqaWs5WkJYdEoycTZ0SHJqUkRncXFWNHNSQ05GK2h6Z0NJNTBY?=
 =?utf-8?B?amhNa0JXNlgwNmt5dTlRK25HRVRMblkzbXhjcDBCei9UT0o4YWxkclZiUzda?=
 =?utf-8?B?dzFTMWU3VlMwcCs1a2JhVHBHSFh5TktzV0xzQitUaXRrb0xpRWsySmVIUmpk?=
 =?utf-8?B?UzNJdXltWkY0YTZJZmlMSy9TTlo4V3BSaXFpdUJZL0RmeWJmVWtIOTdpaTFQ?=
 =?utf-8?B?RU5IWnFSMHJjaXd5MkgvcDVkWkhvOFljcU1leERTTWNRclpSNmErRVRQbC9M?=
 =?utf-8?B?aDNWZjhRVnpMS0hGSHFwRG1TbEplbzZuandPV3NZTjMxRm5NUkx4UjhOSjFr?=
 =?utf-8?B?T2EwaVJMSGNMbWhEdExZdkNWN2RsSnBoMFdTeTIzRUxtYXNldjE0bVkvRTZU?=
 =?utf-8?B?K3o4d2o1ZElmZXFjeWtSK0t3WUxLVFNNSDJhN0syZnJQK3VVY0x3Qy9tb2x0?=
 =?utf-8?B?cjh0TS9wOVY1eEl3b2pnclZ2OWJ5bnRaTko2ZUxsMm05ekM3SzZCUG04OEJv?=
 =?utf-8?B?c28ycGNtdWswdVZJNW9VY1BpR2JpdzU0VGNGRytPd0FrWXkvSHo1T0w3RlF5?=
 =?utf-8?B?d3NHRE5oTHV2Y2ZQZjllRkZCMXg2eVBNdUdUUWpCUUZoMlJMOVhuRW1BVmI2?=
 =?utf-8?B?MFdITjd2WjdmN2FJdHh3L0VxUjZrL3pGMTJCSmdPR1hDMjRVb3U5YmR2OXZ4?=
 =?utf-8?B?RGJhdWlCcTJlK3lGYXV2WHR0UHhUblpqZlU4Z01xbHVNUWpZaGl3VG5QWlVL?=
 =?utf-8?B?OUp3djVicVlqRHNsUkJmdWdyWGFDZ2o2SlZJajVBZ0c2ekc0bFY2S1BNUGEr?=
 =?utf-8?B?d214ZFloNzR2UGFEUC9BVUh0S052K1BhaFoyYmR4b2pmbXkvYjUzVDEwZWtT?=
 =?utf-8?B?OHc5ZlAzYm1UNzZMSmxMTXc2UExISzNxSUExaW1pVkVJRmJhMUZSUVVNYmJV?=
 =?utf-8?B?WkRZTENlWDhqU2dhT3hHRjhXcXI5SmZ5MTJmT2dzYkF5VjRVNDNOWkw1VDN5?=
 =?utf-8?Q?g3MgRw6RPU9mTcWGsel8XAANe?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f263f58-7efd-4d87-66d4-08dcfee2f41c
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2024 04:16:29.4738
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tCZIwKVbbL/rq4/ltfpJjLFDFGk6Cc78JHhqjWwEiKQLLk1CdDM1qMySfgYFINjML+gP4h/JKHNCr2Iou1dLGw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6924
X-OriginatorOrg: intel.com

On 2024/11/7 10:52, Baolu Lu wrote:
> On 11/6/24 23:45, Yi Liu wrote:
>> +int intel_pasid_replace_first_level(struct intel_iommu *iommu,
>> +                    struct device *dev, pgd_t *pgd,
>> +                    u32 pasid, u16 did, u16 old_did,
>> +                    int flags)
>> +{
>> +    struct pasid_entry *pte;
>> +
>> +    if (!ecap_flts(iommu->ecap)) {
>> +        pr_err("No first level translation support on %s\n",
>> +               iommu->name);
>> +        return -EINVAL;
>> +    }
>> +
>> +    if ((flags & PASID_FLAG_FL5LP) && !cap_fl5lp_support(iommu->cap)) {
>> +        pr_err("No 5-level paging support for first-level on %s\n",
>> +               iommu->name);
>> +        return -EINVAL;
>> +    }
>> +
>> +    spin_lock(&iommu->lock);
>> +    pte = intel_pasid_get_entry(dev, pasid);
>> +    if (!pte) {
>> +        spin_unlock(&iommu->lock);
>> +        return -ENODEV;
>> +    }
>> +
>> +    if (!pasid_pte_is_present(pte)) {
>> +        spin_unlock(&iommu->lock);
>> +        return -EINVAL;
>> +    }
>> +
>> +    WARN_ON(old_did != pasid_get_domain_id(pte));
>> +
>> +    pasid_pte_config_first_level(iommu, pte, pgd, did, flags);
>> +    spin_unlock(&iommu->lock);
>> +
>> +    intel_pasid_flush_present(iommu, dev, pasid, old_did, pte);
>> +    intel_iommu_drain_pasid_prq(dev, pasid);
>> +
>> +    return 0;
>> +}
> 
> pasid_pte_config_first_level() causes the pasid entry to transition from
> present to non-present and then to present. In this case, calling
> intel_pasid_flush_present() is not accurate, as it is only intended for
> pasid entries transitioning from present to present, according to the
> specification.
> 
> It's recommended to move pasid_clear_entry(pte) and
> pasid_set_present(pte) out to the caller, so ...
> 
> For setup case (pasid from non-present to present):
> 
> - pasid_clear_entry(pte)
> - pasid_pte_config_first_level(pte)
> - pasid_set_present(pte)
> - cache invalidations
> 
> For replace case (pasid from present to present)
> 
> - pasid_pte_config_first_level(pte)
> - cache invalidations
> 
> The same applies to other types of setup and replace.

hmmm. Here is the reason I did it in the way of this patch:
1) pasid_clear_entry() can clear all the fields that are not supposed to
    be used by the new domain. For example, converting a nested domain to SS
    only domain, if no pasid_clear_entry() then the FSPTR would be there.
    Although spec seems not enforce it, it might be good to clear it.
2) We don't support atomic replace yet, so the whole pasid entry transition
    is not done in one shot, so it looks to be ok to do this stepping
    transition.
3) It seems to be even worse if keep the Present bit during the transition.
    The pasid entry might be broken while the Present bit indicates this is
    a valid pasid entry. Say if there is in-flight DMA, the result may be
    unpredictable.

Based on the above, I chose the current way. But I admit if we are going to
support atomic replace, then we should refactor a bit. I believe at that
time we need to construct the new pasid entry first and try to exchange it
to the pasid table. I can see some transition can be done in that way as we
can do atomic exchange with 128bits. thoughts? :)

-- 
Regards,
Yi Liu

