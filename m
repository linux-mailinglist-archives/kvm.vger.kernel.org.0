Return-Path: <kvm+bounces-57968-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B3BEAB82F22
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 07:08:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 480417A1509
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 05:06:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F83E2749EA;
	Thu, 18 Sep 2025 05:08:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Fj6ou2M0"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07AA5242D8C;
	Thu, 18 Sep 2025 05:08:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758172107; cv=fail; b=iPDBjf5cDLn58JumvDIyuLH1gZu+TrYbOJIjnISGegFDJbGrVVOb3T249BL+BXE+wnRReG1V/ChFjAkQLn+mQARBaaoxEPqayMZwC658FiHM89PrDj4c5P18Y/UBB+jpd/i9OGRREUFoEVBhCu33Vn1ERUgkDgFZr85beBMVRUI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758172107; c=relaxed/simple;
	bh=eNhzCU69yVQbYE0lygP1tVG+d5myERnOdSaHASIXy9w=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=hXjlOcx8KvGYB56TKNeXSdSpebVK8UY2oTe0XiPQUy8u2KbzMnDOXCB6SAcrvlXg5Y70VLd+QbHrQQarYPHgX12c9aJLGR3QVygGllFQQzzlTMtQiYqmY8vNBx75xFwoFq6FmAkMP9oyJSjoFVnjliaFO4P0XlBJ4dRPwZ3hNuQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Fj6ou2M0; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758172106; x=1789708106;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=eNhzCU69yVQbYE0lygP1tVG+d5myERnOdSaHASIXy9w=;
  b=Fj6ou2M01Esewj9Xl5VO273S09A/1k8kt9KxIiVVX5t+PMiGem3lrB4T
   V0HNdh6tax5GWPxnzVjzIYvF/A4y4QeJNUq+OItOkuzRF4nGLRaTSN9j8
   EfEfKO7L1hZLtDKzSBKk88kwpn8IIubMvJ+lLqmlDunh6p8NRLTzHIISz
   7KAdMxmpUEjLloYpgsAjku30MGbhGh2li6NqIEXEpLXAdgEUhq1a9DP5X
   AqUUrasDefMRc90hsYJTmRYuB0ElQnyCczo3w7OQOPr7j8GRG+nblGN1V
   2kdLpcm424518DLJ6Dt9GOFxFMZCu9ZQunzraP1CJqfbpr+K7yFLjQ0HE
   w==;
X-CSE-ConnectionGUID: M7gETjeVScy4t6m5lBO8tA==
X-CSE-MsgGUID: LFxPbfpUTZyjbqK5uXyOXg==
X-IronPort-AV: E=McAfee;i="6800,10657,11556"; a="64123528"
X-IronPort-AV: E=Sophos;i="6.18,274,1751266800"; 
   d="scan'208";a="64123528"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2025 22:08:25 -0700
X-CSE-ConnectionGUID: Ec7iOcAfT1K2GZ8r0kzVyA==
X-CSE-MsgGUID: UJWyglCdR+GVzdyjUqF1tg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,274,1751266800"; 
   d="scan'208";a="206371302"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2025 22:08:23 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 17 Sep 2025 22:08:23 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Wed, 17 Sep 2025 22:08:23 -0700
Received: from MW6PR02CU001.outbound.protection.outlook.com (52.101.48.8) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 17 Sep 2025 22:08:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KD3CdKcV9KwhxcrEa7YIb3NL8yHZiodKE9w4WUH43CymBjxodnupEJ+PLS0Yclc8YQPZ1Z52TfGxlMwzDG5ZFU+jF2kEmSvbBhv1R88rb3qs0/SFXPe/Y2Hfe2VIIJ6AUGJCZ4K4UBlWIh3lwoeeAWFcP9/eLB9K677xxCr7G3/pnNEOI0PC0ARcmZwUxiA2Iiw4AoG0qKBipWy6Rabjwv9Y3n0k8ZGkrW5mWfZzKusYLT8JUN7f/IlOTBS5rQjlqLsaAO92mUhIwd2y9V5UoB4bD9Dlh4i9jpZUCe80aFa7aHWCo/f82L6b6M/WonpVEJ1zocOV0WK3LVioZvNJKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kDprPYrZGdFi/TcUBlxHWrnSvmdVKbYkzkWXNrB4RZk=;
 b=tH6mEx+bjH+kSFSzmwdBCC/n6YCJxppXm8GSFlZnbXFZmNLZdZqQeDgENZubsWvMCvRZhhkB/w6rtHOdafq4LVCr2C86OqW1+Lhtp5Hs0bR8urP5M3ei9ZMfoPoAdG7c8742Z6YPJtnAn4Y//+/kgGq2ddcWg2sxdQK4rmRxX4jzqO9CGRqTMJHs7lQ3/mXpHfi0zxgBsG6YAwNNftj/GyrL//QYp/le0SWsvmpiK3aHi8nPnHHIqM6Mp8AkJ2mkenpbRxvGJ2t0mJXW6olbPKr1pyb/7CP2wYQq4ejgvA7muedPApCtGDr1LJ3cpg8632CmLXQb0CJi95oH1fW4yA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SA0PR11MB4703.namprd11.prod.outlook.com (2603:10b6:806:9f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.23; Thu, 18 Sep
 2025 05:08:21 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%4]) with mapi id 15.20.9137.012; Thu, 18 Sep 2025
 05:08:21 +0000
Message-ID: <19fa188a-bd1d-43e6-bed0-1ca35cbf34ac@intel.com>
Date: Wed, 17 Sep 2025 22:08:18 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 01/10] x86/cpufeatures: Add support for L3 Smart Data
 Cache Injection Allocation Enforcement
To: Babu Moger <babu.moger@amd.com>, <corbet@lwn.net>, <tony.luck@intel.com>,
	<Dave.Martin@arm.com>, <james.morse@arm.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>
CC: <x86@kernel.org>, <hpa@zytor.com>, <kas@kernel.org>,
	<rick.p.edgecombe@intel.com>, <akpm@linux-foundation.org>,
	<paulmck@kernel.org>, <pmladek@suse.com>,
	<pawan.kumar.gupta@linux.intel.com>, <rostedt@goodmis.org>,
	<kees@kernel.org>, <arnd@arndb.de>, <fvdl@google.com>, <seanjc@google.com>,
	<thomas.lendacky@amd.com>, <manali.shukla@amd.com>, <perry.yuan@amd.com>,
	<sohil.mehta@intel.com>, <xin@zytor.com>, <peterz@infradead.org>,
	<mario.limonciello@amd.com>, <gautham.shenoy@amd.com>, <nikunj@amd.com>,
	<dapeng1.mi@linux.intel.com>, <ak@linux.intel.com>,
	<chang.seok.bae@intel.com>, <ebiggers@google.com>,
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-coco@lists.linux.dev>, <kvm@vger.kernel.org>
References: <cover.1756851697.git.babu.moger@amd.com>
 <b799fb844e3d2add2143f6f9af6735368b546b3a.1756851697.git.babu.moger@amd.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <b799fb844e3d2add2143f6f9af6735368b546b3a.1756851697.git.babu.moger@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0104.namprd05.prod.outlook.com
 (2603:10b6:a03:334::19) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SA0PR11MB4703:EE_
X-MS-Office365-Filtering-Correlation-Id: ccfb4990-8303-4861-f833-08ddf671634c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?WVBEcnoydVlJL2tpVEZzWG53OGw1VnNqT01wcko0VVg0V2tKSk84SUlzTHdT?=
 =?utf-8?B?VkZySlgrbHVyOGN4cG9IcFg5bUxUdE84WmdNNlBwcVBLNi9uSXMyaGhhaHlV?=
 =?utf-8?B?M2ZNYkpyZlpsTVQzZTQwWXlDeVNkZ2xmNFkyTGNQRm5DMGxYR2FPUk5XWSsx?=
 =?utf-8?B?dnJGK1ZUd1VHb3pxYm4wTWROWkxqQ2E1L3ZJUG1ua0QxMVU4dFdLYitjbHoz?=
 =?utf-8?B?c2h3ekFHenM1RHlEeUR5Y3NVWVhXNkVreTlxSjBOVVM1bFBrWVBWVTlzVC94?=
 =?utf-8?B?Q1RVZXRNcWtXVVN6M3V3TlE0L09wck0vSWdlazB1Vkh6eUE2WmZkbG5hVS85?=
 =?utf-8?B?VjN3VnhLQ0ZCNFJOVXUvbXdwMlVmSFFRTTZWTjZnbE9hR1BMMDJTS0xVQ3RW?=
 =?utf-8?B?bDRuSk56QWlXSEI3cjVWZ0k3Q1llcnB5WnRtUjZvZWVJU1ZuQUNVZlR4VDJz?=
 =?utf-8?B?eGhYOFp4cUFpd1dnQmRFUjVBaU5VYjlwTUhlejJRUnNpZFlaK0xkcEMxbjI2?=
 =?utf-8?B?SHNya0lEZ3pKK1ZqdmVNYStEOVhKVVQvdklUKy9ha0dYdisyRURtM1pPVmRE?=
 =?utf-8?B?blUzZ0pqOHBnYVpwYkVaV0o0bHk2RUt1UEtlWmFRRnAxS2d0NUcyOFJlZUt2?=
 =?utf-8?B?ZG8xRWFpMVZpbjV1cTZrKzZwNHl3cmNsV0NpVVU3ajAyOTRSR29XdGdKWmdj?=
 =?utf-8?B?Y1dGVFVONlNmcGtFdHVTSUxoK3lHcVVBZXRBWURzZTFtc3p0bURMWmowVHo3?=
 =?utf-8?B?WDUzSHhORkJ1eG1vWTF0RWRTaHluMWFQcFkvVTIzOUs4K2JRYXFUeXNzbENL?=
 =?utf-8?B?K0x3LzE1UnZQRmp3Ky9pZDNwbFRZajJnQkU3MlZaeVA3MHdvUGd1ajNaNGlV?=
 =?utf-8?B?WitGTnozK0J3Uk01WlF4S1FIWWFmek1rL2kySU93d0w5bkhsblJXY3VPN296?=
 =?utf-8?B?Sm1waTJKWGIvSU8zMFVvN2UzejBzeWlXbkJKMnVESXpseUhIUUVaWkRqM054?=
 =?utf-8?B?L0tQcUNUVi9kUWxvUDFqWjhyZm1yRndid2dPWlpnYzgySXhZbXk3NS9YTzFx?=
 =?utf-8?B?TUFNT3VqQzlUbVhaYnY1MUVMbWNlbHpNN2xTMHVBbFl4ZW0wUnl6LzhqOUx5?=
 =?utf-8?B?SGREQ09weFVjYXZvS1FyT1cxUFlrRmYwZi9KbFZNSTQzUkYyZ1RJcUxFTGlD?=
 =?utf-8?B?YTYreE4wc05oQmZtU0ppOEY3dDdwc1VlU0hQRTNUYTliVERMSVNYQmZlcWt6?=
 =?utf-8?B?c3RNKzVjWStJcWx1ajZEaEMvaVZocXorcDlzNDBzcEd1Ti9GMzlrSUZPQVpq?=
 =?utf-8?B?WVFIQkFwN0FINHBqUW5HV1hpVXRrZnlOSVkrdkZyUDdXSGNiSUE1VVdtUDNv?=
 =?utf-8?B?Um0yTVZZb0d5TVdPZUplNWl1MnhHZHQ2c0pnSGptYUNGdXU3M1BvOW9FTTA0?=
 =?utf-8?B?UDFMVnFNUHFzcWhiNk1wdkRXL1lPUWFGaUxrdTdxSWptbWNOeEg2MHlPaXNx?=
 =?utf-8?B?K3BMcVJ3amNCRC9HOGJybytBOFpFUW9sLys4ek1vS0JnaWxtV0hmU2FucUxj?=
 =?utf-8?B?NUwwbVVVUllUbnZaNk9xK3dLUEVOV25ISDBBZmZBSHY1Q1M4L2NvTjlRMDFU?=
 =?utf-8?B?VkRZbi81SWZhRFV6SDBjU0dGaGR3RktxaGRkdllhQ3VFVkp1c2xyQTBxbVlF?=
 =?utf-8?B?cHRhN2Z2ZWFkR09CRGdXeEZqQmpXU25mV3BjRnZtNmJhVHNmdXZPQXhUeVFK?=
 =?utf-8?B?OVc3ZUM3ZnhWS1VzU3FzMmpTTmN3T2ZCK1NxNDRzVnU5QWxDRk8xbVA4NWhS?=
 =?utf-8?Q?js7ckBq9L9eGtKHqVO6YtZsAQkmV92QNeuvXQ=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eGd1SU1DRnFtaTQxYXcxNnVIeHYxaHFYY1kya2dCZGFpQTM3Y09hcTdMYnVS?=
 =?utf-8?B?ZGphb1l5WU04WWtyU0ZOUWl2RUxiUFhLT3k1a21DVGtNRXZNbTQxYlZlMzND?=
 =?utf-8?B?cHhoSHRRZFFtMkJ1NEsrazVaeTdUV2dMTURYeUdPSjdVZ1lGWWdVV2wzWFpB?=
 =?utf-8?B?T1NJdDh5K3JCM2owRmVLYVZQRndwWi9mVk5jSHdTdnRKVmVCZjd0U1hVUXFq?=
 =?utf-8?B?TFVqZHVFdE1PYkNkdlJKclpkSFlIZHFiYWxQOTRwK25qTWdwS2lpYUowWW0v?=
 =?utf-8?B?NUljSzFhaVpSUVBINmRhbldBbCtLTm9sazk4SGQyV1dKZE44aG1wLzhGVEVI?=
 =?utf-8?B?WTdTczZRQXkxYlFWajRLWnYvZkpKaWFONjY3UGx1ZUxRSktoNS82SzBXRVhQ?=
 =?utf-8?B?YTAvcmIwekhGQWdMTExHUm8yWEs4Y2Y4M2FzNVRiZ3ZNTmZyWE9ycVpySW9X?=
 =?utf-8?B?NHdkQml4S0o0YzJZbFhobmNiSHdhWk5KbHBUeisxbEcydHMrcDlrbUxvTS9j?=
 =?utf-8?B?WW1SSWx3c0pFNGJ6ZzZmVk9zT1NLY3puQ3Y5NTVIcCthVUk5eFppUDBQcGlQ?=
 =?utf-8?B?RFBudm9rZTR0N0hhRDRzRW1JN2dUU2JEcXNJS3lvbHByZzVNY3MraDRpRlB1?=
 =?utf-8?B?bmpnWHhPSkI5aHZmSTNOZURvNG9lTjJiMXo0ODJheFpLTFVCc251YzVobzdZ?=
 =?utf-8?B?eURUWk9jUmNWNnR0TjY1Zk4vNXR2QVBtODBCaTlWOHJiSm1qQXZ2eDgzM3h6?=
 =?utf-8?B?ZmZxVGtFU0tzcFdqQzc5OXgyUmRNVHJ4RUJTT2JQZzZiR0pnaHhWK2NPOUNM?=
 =?utf-8?B?K1V5NXo4b0hWRlhUMHdoQlFzUURhS3VrWThuRFcrSDl4TlBXNWxVUW9uM2Vi?=
 =?utf-8?B?MnVOL1FDLzRyWjl1TWNaTjNIUFRLUXoveEJEdEp2SVNKNytGWWtzODBJR1N1?=
 =?utf-8?B?QUgxMW9ab25mdFlwbFBQSXd6TkZDR1VCa0pjNE9NVTh1TitBbWZLQUsxSDZE?=
 =?utf-8?B?MG0va0Q1dGNMNWxYT0F5Q3l2cXRHSzNoS1pyRmoxZHk1bjV3NDRObWhtYkZl?=
 =?utf-8?B?allxYjhRbHBYcll5Yy9UTkxnVXVmZS9LQXlSVHU3YVFKa002Vm4yaWhQbXdE?=
 =?utf-8?B?VWpOc0dzQzBtVzZyQWE0emw2SXJyMjJxSHNMTzVkcDZCR1NVay8yNGY2dm1M?=
 =?utf-8?B?Z1ZvM1pTYU1hVXlqbXZXcGxwMzdhM0hYTjJ0RGR5TXhrYmhCM2c5N3BCQU56?=
 =?utf-8?B?KzVxckRaa25lM2lXSC9ZN1VYOEVpaDlDU0VPWTJlV0g2WWpjS2VXMDE2MnM4?=
 =?utf-8?B?dDZkbUxoQTUrYkdWQ0E4d0hUeWZaaWx2dUNoTThaOThIdjVaQ3FtdU5tOVRM?=
 =?utf-8?B?RTJyUTJpVE0vNkxSVk96Zkw1YnZ2cHlWdm5oUFgrbkdOM3pjNUlBQXF5bGZs?=
 =?utf-8?B?NHJZVFIwbHVIM1gwU2xHQk5aUy9xa2xLSFNPWDV3SkRBa25WVXV5TmpxWStW?=
 =?utf-8?B?ayt3aEFPUFVSNEFYTHhvK2ovMDI2YW43N3Nid0t5LzZIZU5uYlpGZTVPTzJ2?=
 =?utf-8?B?Z3AyL3JVNmY0VlJKNzIwZVlnMFV3dFRBQjdINUp1VUwvbVp4cnVzbUhnY0l1?=
 =?utf-8?B?VFVyVm9XRER3cGc5RUlRcTIwRHhzZDZDSUV5Y2dqTGM4QmhlWDF3VWFsdEkx?=
 =?utf-8?B?L2N4WWtnTWtVdmFFd0VyYlIvWnJ1MkV0N21BSjhJWlVQaXVDOGdqMVFHK1Vs?=
 =?utf-8?B?QlpVRFV6VjluQVJGa1BDZVVqRTVMeEVTVFF6WlVHcWFFdnBabHNIL01Mbng2?=
 =?utf-8?B?SHN6UGpndlN4R0ZVOU9adE0zNmRTOXdYQWNNRTBjcHBKNWlFcU94NmRFbFZD?=
 =?utf-8?B?Q21XRVZNRVM1VHY2Zmh2U01YL1VNUXI4TGtxOHQ1bjd2QUNjSzQyUU1jZ2pm?=
 =?utf-8?B?akZnZmdMMVVGU1U2cDFxVXZqVG1nWjBPU0tFR1gzOGVKNXpyNlJPaURlMnZy?=
 =?utf-8?B?dE9oUU1TS2dkM3NKZUh0eXpUZEFGU0QySlc2RnljUHhRY05UTnlNNi8xTnVq?=
 =?utf-8?B?Nk1kR1R3K1lzR3AzdTFsSkZUQldhMEJvT0Q0T1ExYWxsVHNrMzBKQnpFVE9Y?=
 =?utf-8?B?b3FzK2hESWUzL1RXUHp0aTc4TTFyYTBzTGNPWVhkR0FFakVMVjFva2QxaWhX?=
 =?utf-8?B?dWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ccfb4990-8303-4861-f833-08ddf671634c
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Sep 2025 05:08:21.5881
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4wAGV/lsSlPdsGJX5x8By2Gl+5xvKR8creh3HErJE5sjcFhl2gKHT8wjqUE+MrvUiEdV8J2RWu75ljVOgw3XD2pC6Grxdr7VHSHxAo8LJFc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4703
X-OriginatorOrg: intel.com

Hi Babu,

(Just highlighting some changelog formatting that was needed for ABMC
changelogs.)

On 9/2/25 3:41 PM, Babu Moger wrote:
> Smart Data Cache Injection (SDCI) is a mechanism that enables direct
> insertion of data from I/O devices into the L3 cache. By directly caching
> data from I/O devices rather than first storing the I/O data in DRAM,
> SDCI reduces demands on DRAM bandwidth and reduces latency to the processor
> consuming the I/O data.
> 
> The SDCIAE (SDCI Allocation Enforcement) PQE feature allows system software
> to control the portion of the L3 cache used for SDCI.
> 
> When enabled, SDCIAE forces all SDCI lines to be placed into the L3 cache
> partitions identified by the highest-supported L3_MASK_n register, where n
> is the maximum supported CLOSID.
> 
> Add CPUID feature bit that can be used to configure SDCIAE.
> 
> The SDCIAE feature details are documented in APM [1] available from [2].
> [1] AMD64 Architecture Programmer's Manual Volume 2: System Programming
> Publication # 24593 Revision 3.41 section 19.4.7 L3 Smart Data Cache
> Injection Allocation Enforcement (SDCIAE)

Compare with how indentation of ABMC "x86,fs/resctrl: Implement resctrl_arch_config_cntr()
to assign a counter with ABMC" was changed during merge. 

  [1] AMD64 Architecture Programmer's Manual Volume 2: System Programming
      Publication # 24593 Revision 3.41 section 19.4.7 L3 Smart Data Cache
      Injection Allocation Enforcement (SDCIAE)

(also applies to patch #4)

> 
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=206537 # [2]

Please place "Link:" tag at end to reduce needed adjustments during
merge.

> Signed-off-by: Babu Moger <babu.moger@amd.com>
> Acked-by: Borislav Petkov (AMD) <bp@alien8.de>
> Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
> ---

Reinette

