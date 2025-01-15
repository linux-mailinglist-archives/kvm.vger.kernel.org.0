Return-Path: <kvm+bounces-35483-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B7C30A115FF
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 01:18:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 60FF53A816B
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 00:18:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3228AFBF6;
	Wed, 15 Jan 2025 00:18:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FD9cpGRb"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1BBCAD24
	for <kvm@vger.kernel.org>; Wed, 15 Jan 2025 00:18:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736900284; cv=fail; b=j3lxGaS8EgLPzBdJxw3SxP6mx41CpuigKf25k0RBgRecHed91uWHPG8+dA15xlYjAg2yUNAeuz/xqfiZdNONrZZeyLfkePWxRJLFf7bFC3sFRqxoXBJB32M7ZAWdLUwvqAqZe5U1nBjDktAXWfTOoBD759kQrzNQPl/Rvx7NqJk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736900284; c=relaxed/simple;
	bh=EU+kC7aLfDodgSgDTeyqW3iPFpgLpOHOs7cQ5kzVmes=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=RQqGE328H/MIzqy0dr9LNIYTPe8wwGsBqXRAcarOLv78bZCumOFUvzMPJ8C+WvSboCuD6DZFmI1gWRZtiMZNK+SWXAfen0WMUb430IjlAS8eSH/LekKHqt4g29yuZ5CxnH1KUYiyPWw5jq4tT7Xg7ch1na66UTKvxM4oYUNTTyc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FD9cpGRb; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736900282; x=1768436282;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=EU+kC7aLfDodgSgDTeyqW3iPFpgLpOHOs7cQ5kzVmes=;
  b=FD9cpGRbMjbPPxslFCcOmtLbxTCxq+Q53pr8vby+iORTyazU1uPj9R6T
   MDeWAfM5jXC+ZqdOUSkIFxi0ShA/BRaBOeJqYn110ttyWpwFDan2I/9FC
   1uMDLNXGE8oWRKA8xQFqJ8pgc3NwwEPn/GUqM3VC9cAo0j/islsaj4T8h
   DUoFiZ6IE+YyDh3wFivesOAIJqm/OIAKESQKp9CKE5wSRMpnMemKEe78k
   V+ZR5pPO0cSVj5/Q2PiThpchiYLZKGJJc2oc3M/2Yb521q906QUfoF2+b
   5XgHlxVS+jI+SdmxWS1f+v5s9kuH023hvEh/EAFDGwgL2Y5VdCfueJ9UN
   w==;
X-CSE-ConnectionGUID: nKpwvzNsSuK87Q641Tr3NQ==
X-CSE-MsgGUID: V7C+EyyvQOWrPIb8kxcCbA==
X-IronPort-AV: E=McAfee;i="6700,10204,11315"; a="37245764"
X-IronPort-AV: E=Sophos;i="6.12,315,1728975600"; 
   d="scan'208";a="37245764"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2025 16:17:48 -0800
X-CSE-ConnectionGUID: PfZmYASkR46PJGTtB/XlFQ==
X-CSE-MsgGUID: j8cpLayHS2KqZyRHNNUbuQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,315,1728975600"; 
   d="scan'208";a="135804757"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 14 Jan 2025 16:17:48 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Tue, 14 Jan 2025 16:17:48 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Tue, 14 Jan 2025 16:17:48 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.175)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 14 Jan 2025 16:17:47 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aGH9HyB83jwiPiQTQBF0Fk9KnyR/p7aq/cVVmaQw9GpVgnVSB8Te4qJrZ4QMlK0rFq2GD9FsXgk969VknRR4Zt3YnPXfi+cgfxGmPtw0466EWTWgPCXDSO9QLqUYvqDGh8aVSIsBKqij+lOoS9hWDYEioFSSgYGx0yK/sBJAmJi8w80AOJ/5OA4/WTR0x/IqEZ1xYPIO+GXbgX859Im3WSYvCyu4+FTy+u4F1rS94KzgceOWwKPhFGUsfCgukEz+Mgnu+V93kAWCZVz5xg3LwpRATitRzAfJDHSsObhsIqGNuTvCK/teEqWX7xvylQ8xdT+hkZ6yrhPJaiz9QokgmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iVAADT438ZxFo4WBvuRYtZArxRBHteRLV6ZpMwkBPAc=;
 b=Ew0r+ciCy7ORfRG7JryW3wS0KewGyhZ+wTkpjz870jGsdBSj2TAxSM7u9Djc+fbxybHolSfDsuglXsu1fAY5w9bi5BQsSlbI76BC9kPoySlNYG44aDIPi479WDJzjkeNF4VeF47TK0IticCNZkegnKs9j7M7rodRf6XC5nczczKrDCMnx0c/d7EZx2AjecwgwoSWY112oRe+JdkfHyqSgMPQnBXj3zgbSK8i+yu1SuZPAPVdFHzp4vTRerLGTsxgoUzAlIcIV9YGDs3+qMqzG6aLLVrbWEikvY3h/1ojP4435Cx3sheFZ5A2Ch6Fs5+D4MYmEcTDMNgRzN2YMVHpyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by SJ1PR11MB6129.namprd11.prod.outlook.com (2603:10b6:a03:488::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8335.18; Wed, 15 Jan
 2025 00:17:44 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a%4]) with mapi id 15.20.8335.011; Wed, 15 Jan 2025
 00:17:43 +0000
Message-ID: <3428d2b7-8f91-43ed-8c8a-08358850cc66@intel.com>
Date: Wed, 15 Jan 2025 08:22:59 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 0/5] vfio-pci support pasid attach/detach
To: Jason Gunthorpe <jgg@ziepe.ca>
CC: <alex.williamson@redhat.com>, <kevin.tian@intel.com>,
	<eric.auger@redhat.com>, <nicolinc@nvidia.com>, <kvm@vger.kernel.org>,
	<chao.p.peng@linux.intel.com>, <zhenzhong.duan@intel.com>,
	<willy@infradead.org>, <zhangfei.gao@linaro.org>, <vasant.hegde@amd.com>
References: <20241219133534.16422-1-yi.l.liu@intel.com>
 <20250114140047.GK26854@ziepe.ca>
Content-Language: en-US
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <20250114140047.GK26854@ziepe.ca>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR02CA0126.apcprd02.prod.outlook.com
 (2603:1096:4:188::11) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|SJ1PR11MB6129:EE_
X-MS-Office365-Filtering-Correlation-Id: 887c624a-7196-4b1b-30e7-08dd34fa07e3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?Mlp1Nk1XWEJHRHFNRy9vTXNRb21kRWQ5K25CbzhxeTVPcVhOcHNiclVjZ0tu?=
 =?utf-8?B?aG1zUnVJVEFDZXpxdWtnY3FMclpLQVlDQ2Z0aG82bGdLU1BuNzJyT2dTWHBV?=
 =?utf-8?B?NEd5azdXMUFLbndLRWVEQnJTZTI2cUJoV0NaTUd4ZU9KcFRwNk44QUFwRURU?=
 =?utf-8?B?d25VN253WEl6ZGFYZTNFMjNYc1lObC95emJ4RTFWTFpSeHlwaVRHdm9Gd0Rm?=
 =?utf-8?B?V0VLSkdlcEtJN3U3ZHBacitaZC9obVpISGRwbUxKWUtDcjFCRVRPek1pT2o1?=
 =?utf-8?B?ZGtIT1JrK2tEVThLamw1NnVGbDZJK1h5MXZLZjRPSUlTUisrQzVVbkpTUUZt?=
 =?utf-8?B?WUJ3RER0R0FIQ25TbUpSZ0phVmRoemUzMklFK3lURTZEQzZXcXozSCtJbGhY?=
 =?utf-8?B?ZUdJR2twYndNUWdYRjQ4TExQWVhDaEVaR0ZwemJlbnEwUkVtSXdDYm96Y0Fh?=
 =?utf-8?B?emU2bEIzeGNnMnVNTWl6aHpBM1ozTis0T000dGd5amszSWpmWDdzUXk0VVFl?=
 =?utf-8?B?QThBUkR6ckFSdTZUZGkzVGZ1R2lUTWs0RytDZjJWemlKM211VGp5M2UwT0p4?=
 =?utf-8?B?ZHBUVFJXb0diS3cra1dlR21sRGR5UG96dU42WnM2ZkVMS3JoZDQ5OFJyNklV?=
 =?utf-8?B?VjRZK1F4OXI3T1JWV01HQ0RjWHZVbE9mU1M4dloxSGpJdERXclZ3Q0l6Ri9o?=
 =?utf-8?B?NkRRZUZCTitNQVh6Vk1QbE5MRGJwQzBRbXVUclFHYXdhcW02a21UMGRqWFMx?=
 =?utf-8?B?dlhtbVNuTFJuNlNtaVBEUU41SldxQWtuVGlJQ1NaQWp0YTRrSWdYUU9PWEY4?=
 =?utf-8?B?T21pMEp2Uk9acm5yQmVmYXBUZTkwSWsvSlI1bzRmdjgweHNCMzFaNC9oWlB1?=
 =?utf-8?B?TVNjdGlUM1IrcWthcXBpQkh0c25pTE5LUk8zL3owM0ZIWmlWN2hxRWE4VEpK?=
 =?utf-8?B?b1QzZW42a3NtODcwNWJ0Y1FSclVpeTdLbVlLSWxqTkpwUnNVejgvTXNLNjdQ?=
 =?utf-8?B?c3FPNFdwMWkyTHJkUENJSXJHM2tHWmdBdEZWeHBYZnRLcm5PLzlUeFFYMWpM?=
 =?utf-8?B?Wkw0cTBEL0h1N3hsQ2JLRmFUZFZxMEwvS0hVTTRtTzN5SWF3N1IwdjhaSWZm?=
 =?utf-8?B?amtVYlE0c2MrSjhDQlB0MXZ6bkRuVWFtK3lPK21Sc3M3WDd6c09BVHhBalBo?=
 =?utf-8?B?NUw3dUQzSVBCMkRKMmdMQVpuenhwNENtOXZzYlhBcjdDWkhlMzRXQnhGenVh?=
 =?utf-8?B?WGFPaGVMeDhHcHlhMFNKM2F3Y1Z3ZXlBSkVYVVZ0blhXWUxsWmdDdkZsZ0Ux?=
 =?utf-8?B?QzFZSURTVmNCakwvZUtIcTU5RTluMjcvZ2tsSnJZWS9LMHZjcWg3RGlocS9r?=
 =?utf-8?B?S2lLY3o2MmJRMUdnRmxGZjVrWmhyNWU5L0Q0WU1VNlhrMGpWazlqM3F2SUlW?=
 =?utf-8?B?TFNGUzdFbjJKMEhqejlsYWh1a0lIZFphZHYzcXVZYWhiUnRQMEhCSGtqMUVj?=
 =?utf-8?B?WVY1c3FiMFZ4VExsVmRNdXBMYVh6VzZubXZjWW10RDhxZTlIcy92QUZsVFlq?=
 =?utf-8?B?VFNNdUhKRTdvY2ZZcWRQbnA5OVpENGVpQzNiMVh4aGN1ZW1oc1gzS2J1bVV2?=
 =?utf-8?B?TllPK0pKdHNVWGpjWVBLQUZCMlVPeVJ0SFlsSWV4dnNFS084Tll3Y29nRnVr?=
 =?utf-8?B?WndPNUZGRTVZY014N0dheHZNUERYVFpDNGI0aVpsNXZ5MnpwQW5aRjdiODI4?=
 =?utf-8?B?SVREYTFUeGQzcnpZWUl1ZTh4NlJwODVRVWVYM2Y5czlxSWZFelBUMG9ONS9h?=
 =?utf-8?B?Wml5TFBFcFN3RlViR0xSaHI1MmI5Zy9qaVpteGhmd05RSDJ6R21qcXZRUW10?=
 =?utf-8?Q?l4I0RZQqTI0j1?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Vy9FWWVvRlJDKzNsUkdlc0EyYVNPdm02RDV3dzJocjVhTGV1YUo0MXhiSFNt?=
 =?utf-8?B?aURHaVBDbHprenp5ZnlMdDFpS0twMjMrcUEwNGFoZWYwZkl3QnVmYlVPUkdm?=
 =?utf-8?B?RkNyL1pLU3BNWm1tamhnWmRLV3lidDdOOXNreWMyTFJCZlFraGFzSUlNZkZM?=
 =?utf-8?B?U05sS3RCMzBsN2VnRTRHamh3YlYvWnBlb0tBTE9OelE1dVIyMlcra3pyWFlG?=
 =?utf-8?B?clFvaGJVbmp3ZUY2akgvcFNrQnRsNkhlSDZaVWlPSnJmMnpCc2djSGQwb3pT?=
 =?utf-8?B?WWtTUXBoTWxETFFPRE1haXF3UWlUV0NGakF3RFdEN04xUFBMYUlOUWt1L1VO?=
 =?utf-8?B?QjBUT0R6RWorZHUvQzJjcVdGZmE0T1I2VzBXK0NKSWd1UkJ2cHc0MWV1TDVV?=
 =?utf-8?B?dy8yeW4zVDNEWjQ5OUQ3Qk40eHUxOUZYcUZNYlNCdmRVTmdmVDNyNlk1TkRF?=
 =?utf-8?B?UGN1b1dPMkc0MjdELzlEZzRaQkRFajVOampGSWM1VE93Q25RZlgwSUFvVGFO?=
 =?utf-8?B?VG9ISHluYXBpQUJkL1R0OFd5MmRHL0JnRWYwRE5wR0s2SWFFa1dIeW9HUmxw?=
 =?utf-8?B?QXJlbUdJWWUrUFBnOHROUkZydGc5RGdzSGRGK2JDZkFKK1lLMHRaQnNGU2RR?=
 =?utf-8?B?dUJPcVk4Y1hLMTlZTGsrYm5wQW5YWmdXOTZyYlU4b1V6aEVnQ1c4YXErdXd4?=
 =?utf-8?B?amlXbnRZdkJYWEJwY0Y0eDVCSTdKK2tTOGg1bmV0d1FGaGhzcWM2MENOa1ho?=
 =?utf-8?B?MVNnWmN4UjAzSkpMcmgxTVpJWjFBR2l0ZlhrUkVXaVJJZzhkcDQ5RnVpMjJS?=
 =?utf-8?B?YVRBUGw3TXVpVjlIZzFRUk5MVjNOV2o1WmRnbUxBeWIyN1VSZ05Ra0l5RnVE?=
 =?utf-8?B?c0RlVGNxSDhsLzdWNVppMjR6M00wQlhlODBPTjltZkFOdWZPZWNpUU00bjBW?=
 =?utf-8?B?ZGpGQ2xQK2w2N3p5Z2F3WFJKeXNzWCtRWGd6YlUrNkJQbHVrdEVkMDdPV2Uy?=
 =?utf-8?B?MXR4ZWxOOEl0MloweWRZclJiMUQweGR4NllnR0llc2Q4eFcyc3BZd1VseHR0?=
 =?utf-8?B?czRlYm83dUpBelE4MXk2U01jTndUQXNoZ0RpY0R6Mmp6cFhrNUtBZGVBR2Vt?=
 =?utf-8?B?ZVdKeTlZSUFFdDJEVFJJSW1ueGhhajgyVUltTy8waTV5Q0dhQ1N6MEFxZnR0?=
 =?utf-8?B?Ti80NWtjeXFFZzgwR3Bvck54RlJqUVhhYksvR2l2emR6OVhranhGY09jbE5w?=
 =?utf-8?B?bTdzYmdBTWlFNXd4d0RJbVk4WnNzelJGWVdjOWVpWjBOMklZTTBUdWtQQVVD?=
 =?utf-8?B?RFdtVkdsQkdJNEUrSkFOZmtSTTN3SHJGcmhNRUxhZmRkUEQxYmZJOUhSWDBX?=
 =?utf-8?B?S0VsOTduUmlJdUd6YmJKeCtYajNVRE1IS3FobkU5alhaK0lFdDMwOUxGZmtp?=
 =?utf-8?B?WStoemowa3I3dHN0eWRENytaY3R0ZkttTUt3ZUFWMDNvdHloaUF5NlFtNlRQ?=
 =?utf-8?B?ODFjODJTYlVkV3FyV1RYRitEbUJFVHppMndKVzJaeVFrZE5wa2VBV2hSUElk?=
 =?utf-8?B?T0xQUmxQOC9rT0pGUDg5NjRHUjBtVUZvZ1NRbmFTdHpaVEdlNlh1SkJXczdF?=
 =?utf-8?B?NE1COXp4MGlvRVB3ZjNRSXhtc3h3aWJ1ckVwbkZjcW9PNnNXOUdoTDNpdHht?=
 =?utf-8?B?bHA4L2hTcmpjZldWa2ZTMUtjckNScVB0RlFGazRhMjIwMWhnNEt4bS94SkM3?=
 =?utf-8?B?bXQ5OHhuYmVYT2c5UFQ3U1VON3JNdlVoV1U1OWNqazhJMFFiVXBuVVdJeUxx?=
 =?utf-8?B?QlphWkw3L3FueitSMDNwdTBPeEJoaHRzdkVVaVBxNjdTNlU4cnFOK2VKa2Ny?=
 =?utf-8?B?ZGducDMyNnZHZlBqZi9TSGcrejA5WnlqaWsweitUSllFdFlPS1BhZmhuZlBr?=
 =?utf-8?B?ZUo2blRueG1yWFFiS0RZb21uTTR4dXVCaUhrVlo2a2xCcGNHU2Irbm5OcFk4?=
 =?utf-8?B?WXZyM2xVcVZWUWt4aXdjRFhWOWdHWkN2eHZ6MU1Jby9JVjNUUkdieStoTFhn?=
 =?utf-8?B?Vno3TXNlQm0yQ05JNkhqR2VndkRQQThzYTZTV2N1TVVXVk0rMEdCZzRHR1Jw?=
 =?utf-8?Q?9ywjihjHGthyI8iITAVvW7a4/?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 887c624a-7196-4b1b-30e7-08dd34fa07e3
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2025 00:17:43.8504
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ELGa+uUA7iDKglwg8kxdYd6pXA5UzEmXO0PMFsESc2LElz9LQjU8LqaJF/fn/CG6Jr/hoCN1Au14jmcY2obL4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR11MB6129
X-OriginatorOrg: intel.com

On 2025/1/14 22:00, Jason Gunthorpe wrote:
> On Thu, Dec 19, 2024 at 05:35:29AM -0800, Yi Liu wrote:
>> This adds the pasid attach/detach uAPIs for userspace to attach/detach
>> a PASID of a device to/from a given ioas/hwpt. Only vfio-pci driver is
>> enabled in this series. After this series, PASID-capable devices bound
>> with vfio-pci can report PASID capability to userspace and VM to enable
>> PASID usages like Shared Virtual Addressing (SVA).
> 
> It looks like all the dependencies are merged now, so we should be
> able to consider merging this and the matching iommufd series for the
> next cycle. Something like week of Feb 10 if things are OK with the
> series?

Hi Jason,

I think the major undone dependency is the iommufd pasid series. We might
need to wait for it before merging this. :)

[1] 
https://lore.kernel.org/linux-iommu/20241219132746.16193-1-yi.l.liu@intel.com/

-- 
Regards,
Yi Liu

