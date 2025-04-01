Return-Path: <kvm+bounces-42390-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B66DA7814C
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 19:17:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A7E9F188B6BE
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 17:18:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 273FC20E6F9;
	Tue,  1 Apr 2025 17:17:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AT64Ds4l"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9E8A79FE;
	Tue,  1 Apr 2025 17:17:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743527865; cv=fail; b=j6SZgdch58cWlREr2dRDsBml1w4PqXyRKuOGKR5aTtGlvO0BotwNf9FTklyy5+oxsMKiCjhN6GfWKLAJwB3j7V4GJQ+KyTscY4drfGPK51YZ5kQVN/AsHfJFIRToI8f0a/ASr5Rn35+rFvt81zDLYzi+ZcQ90n9INrQPQxnxhQc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743527865; c=relaxed/simple;
	bh=x0LuyMKOlQHhL2dabQpCqXt3hZbr/lSObkfBeSfvohg=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=nvW6NMk83fVlAtGeOv/gGut5F+gMm5c6B9PcR2AA/43YJ5mpTUm7m/oCX6totImP+f+kQxZ5e6C1LIBCpXKi7ef1AxrKFM3UGOyjNVmGTbved8wgFwAxtlCo5fQ202ROSIEF59kicHSBcmaXC0G3JnOUuEr4wYqJb/orMbJTqA0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AT64Ds4l; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1743527864; x=1775063864;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=x0LuyMKOlQHhL2dabQpCqXt3hZbr/lSObkfBeSfvohg=;
  b=AT64Ds4lOSqxDltgKMMyFfCmXxlNpB1G5OPlpiHiVYPBbH+zgwyu561K
   ZNWwqckcB+CL3i6fbtNEsQ/TQbI2iG0F9PWeTB5AXx6EpKU3rkWagQz6E
   DrbLQ1I+C/Z+I3IgaO347iJTD+RFToiFNl0DemBIyyUKcTFgaRiqbKSv8
   rtYqqOOJPdWhz0tsEmDss9sjg/bmJ4uUVyWL3Nv1ZZ5jN4GqsvuWg6M2+
   8/JmlcJPQXAIQr4AesFHqzO9pWugd9W7AiPUSLbpJoI9cZKcuR18d1hL0
   M2Wb2PNqjcNELrE5AfKlkuxhdMaUeZyx0/UgtlbsfFLRZL64wiiRbji1y
   w==;
X-CSE-ConnectionGUID: 6xFlMm0xRiSsT3wuYbZJGg==
X-CSE-MsgGUID: /7I1sZ0JROiwjHNYVooVXQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11391"; a="55523889"
X-IronPort-AV: E=Sophos;i="6.14,293,1736841600"; 
   d="scan'208";a="55523889"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2025 10:17:43 -0700
X-CSE-ConnectionGUID: uLInowWnTtGpCzq1/OulDQ==
X-CSE-MsgGUID: FNGc32rXTMyPjRKilngn1Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,293,1736841600"; 
   d="scan'208";a="126205997"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa009.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 01 Apr 2025 10:17:43 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Tue, 1 Apr 2025 10:17:42 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Tue, 1 Apr 2025 10:17:42 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.40) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 1 Apr 2025 10:17:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LRjPVE+KrLGmetFo25WQg2NQjR5omwTQ1UbuTuu/ZH5Xvr7tIZfQAIM1nwADAcWhNyJ4ZDkqVe1FRydSmrPaKN1PXBS9ggOaqGsk9lrJuCv6OSqwEqTLYPtcI2cPI5fMoIasX2Gl/EXI6C+Ok3m7w05+vC8HLotYp468uit+qBPOXrmGmPRoY4Vvss8iULefEsnAEG+qAtQHlGrrc20td5t/PHAXoAzPqO4f2Nrdk//zYDRDEUVKQUArYEpOZ3s8ExE6fx9l7gATKfDZ/gaGdf+pDRa+bdRlno+k3n8nWM0Zr966rmdMdRSAu6nibopUSbIfwiTzh9fuAtu1C+EV2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WWyWrw5rjz01KGEb/cqVDM/43YmPNTtnUKRxmQh0pr4=;
 b=k4sihP8bnQg8kVcPJRGcQE2pc3+R/mQPIhJ21KGXMCOrXD21ezUybTPnf7DxmfK3Ygn0Sv42axLbEys/skx16ywnE4P7CkmTMP4ZuWvSs2y9tEtYbybZ8W1SYD6qEle7//yLr/FCXiZJv7AdABO6WDwvjRkH0Z9qg4m8DEIgDn40q7yw9WY5Dmc0k7ZgdGPXx5hfnp0MT+iIxgab025YEXjy+ZuLvA/hjaNeVglEMVr/md2TYjNFWXzKJRt6swkKJST/Vgg9N7l6vY8+9V1hTFFgzo0GXZUknNNj40nea+/EwRF+yH2LvNoD+0lBQA7Ao4SxQJHDU/bVcLW2wbX7nA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7925.namprd11.prod.outlook.com (2603:10b6:8:f8::18) by
 PH8PR11MB6926.namprd11.prod.outlook.com (2603:10b6:510:226::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.44; Tue, 1 Apr
 2025 17:17:12 +0000
Received: from DS0PR11MB7925.namprd11.prod.outlook.com
 ([fe80::b1ef:c95b:554d:19c9]) by DS0PR11MB7925.namprd11.prod.outlook.com
 ([fe80::b1ef:c95b:554d:19c9%6]) with mapi id 15.20.8534.043; Tue, 1 Apr 2025
 17:17:12 +0000
Message-ID: <ec953e80-a39e-4d42-b75e-6f995289a669@intel.com>
Date: Tue, 1 Apr 2025 10:17:08 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 8/8] x86/fpu/xstate: Warn if guest-only supervisor
 states are detected in normal fpstate
To: Chao Gao <chao.gao@intel.com>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, <tglx@linutronix.de>,
	<dave.hansen@intel.com>, <seanjc@google.com>, <pbonzini@redhat.com>
CC: <peterz@infradead.org>, <rick.p.edgecombe@intel.com>,
	<weijiang.yang@intel.com>, <john.allen@amd.com>, <bp@alien8.de>,
	<xin3.li@intel.com>, Ingo Molnar <mingo@redhat.com>, Dave Hansen
	<dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, "Aruna
 Ramakrishna" <aruna.ramakrishna@oracle.com>, Mitchell Levy
	<levymitchell0@gmail.com>, Adamos Ttofari <attofari@amazon.de>, Uros Bizjak
	<ubizjak@gmail.com>
References: <20250318153316.1970147-1-chao.gao@intel.com>
 <20250318153316.1970147-9-chao.gao@intel.com>
Content-Language: en-US
From: "Chang S. Bae" <chang.seok.bae@intel.com>
In-Reply-To: <20250318153316.1970147-9-chao.gao@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0069.namprd05.prod.outlook.com
 (2603:10b6:a03:332::14) To DS0PR11MB7925.namprd11.prod.outlook.com
 (2603:10b6:8:f8::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7925:EE_|PH8PR11MB6926:EE_
X-MS-Office365-Filtering-Correlation-Id: f746e32e-b875-433a-82ca-08dd71410a99
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?UFhZa0xOdWxCK1JXcXRFd3ZpcS9JQjlGcVFGUWFxZUtCVzdMR2lhaHRFSndV?=
 =?utf-8?B?Smg0cFcyTkVMREVRVmlVZWhKMU1zNFBCMlBvTXhydUhHMFhJbVM4cHlCRGhs?=
 =?utf-8?B?MUxTU1BsRTVscW5WeC94RTJzRUhyd01LSytJZ01kSzFWeVM3eWh2SGRqRjZ4?=
 =?utf-8?B?TStEaHJxTUQ5dzBvZ09Zcml1UzRjZGpwcnVPMHZyYXd5aFdxbzViMTMyWTd3?=
 =?utf-8?B?R2ZYblBzRjhOOFZTVERMckVpcStIbHppR3M0UUVTaXNuS0R4ZzZXZW5mSVd3?=
 =?utf-8?B?d0VlQmNDZHh2c3VSOU40TW4yNGZvZjhxS2RJWkYzTVlVeFJiaUJyQnZKV1Nl?=
 =?utf-8?B?SXF3WXBSRytFSnl3VkpOUU0zL1dyQTk0dU1iZkl6ZGxMUEYybFVRakpzaGIr?=
 =?utf-8?B?b3U2dmU4VW12WDUvZG9zZGxRZXlieHc3NTV2M25BQ0xTZXBUYk1PR2pKVlQx?=
 =?utf-8?B?Qzc1VFV1dGFyTE01Q3k5aGVkOUZ1STVQLzM4NVNwQVByUXBHa0xPbExuTGpi?=
 =?utf-8?B?b1I1ZUlZWHJXVjZ5M3ZuZWlwWkNQVGhLUm1zSzMvMDZGQWhkUlQzVjZhLzR5?=
 =?utf-8?B?U1VZdU5tU1AvVmVtVHZmSk1PVkg5MWlSK3VuS0xwYU8zdlE0ay9TUXZOZktj?=
 =?utf-8?B?RVY0SFJLU0xPTG0wYVA3blV1SlptbmpUWXpDVU5INXFwMFNQUGZGUWxLb05u?=
 =?utf-8?B?SnJqZVVGeVVHVlh5blR0RVFkYmxTVHlaOFU2amNRa1pnb0lHOGdzVTJBZGlL?=
 =?utf-8?B?NU9rMjAyV0hsYVlXcUhxWUh4Sm44MmJVSlhsRlV4NVV0T0cvY0lrWTZUOXRw?=
 =?utf-8?B?eTBtWU5IRUFUbWJsU0RneGptR3ZONjJYZXNyYnpNRzd4MmJYdTN1ZzI2ZWhK?=
 =?utf-8?B?Z2ZEampORnhtQUNiYmUwM3BialMwU0dUWHBOcktDTVpsaW1xQ1NaUDIyWXpV?=
 =?utf-8?B?dnU0YUFaaVNsTkg1bEpTSlVRanBlRjQzN2ZINFFUWFZkWlFzV2tVY0c0WWxR?=
 =?utf-8?B?eVpHQ1ZaeTBWSld4K1ViVUJlUGZCT1luOFRXb0YxRWREVjA1dVFBa1Y5SGhm?=
 =?utf-8?B?T2hNQ0x2NjUydzRBMXh3alh3eDErbzh5VGx1WXVvbEZmQWFic2R3Z0pPVkgv?=
 =?utf-8?B?aERVdkE1MTJubW1kd2U0c253REI0VkRzK2RlcFp3c1ZHdzhoMFFSMUtJbHY3?=
 =?utf-8?B?K0R6M1VPTW5YdEhOcGdNTlNMSkdXN0Z4RlZHclhPMER2SE9OdG5xZmszcTdU?=
 =?utf-8?B?cmtnY0hHNWs2aGRGL3RuTFBMZDF3eHVVRUIwRXJ2WTlJSjJpTXdxS053bGRq?=
 =?utf-8?B?U3U2NjlQaXduYlRzWWtlWU1xM1FUZWZDRDNBMERXdXlMbnpyZHJ3NFo2UlNR?=
 =?utf-8?B?QUpzcUdxdmlBSDF1SzVoVnF4S0NFaWZtWlFZY0ViUGNsU2V0TmQ1VGZNMWZa?=
 =?utf-8?B?ZnJ5RHRDSFhjZUVxbHQ5TzNNOXpWUUR5M0pESzZqa1FyNERrTkErTU9vVzRP?=
 =?utf-8?B?UnNXN3pvcEJoTjVVd25ydk04dDBMMlBhYWlabWxPcVBIcG1rNTZvWVBiTThm?=
 =?utf-8?B?Ykppc3Zhc0hpNk1ScjIzSUpyaW1jSTBvVkpTWWNLZGRiR25QS0VkaFpCbkx3?=
 =?utf-8?B?SzU4WjJUR0VIRTJ1eUJOcW9idExNU1FhTGgyWDByM1pMUEw1NFRvS045YXFq?=
 =?utf-8?B?bmkrWURwRlprQ1BEblJNTE5kdkhWVzJYcUVtdENES2FHM0lJRnl6M0xnbkFX?=
 =?utf-8?B?dktRTTkzLzZldkpualRqRUpFR3VYTkFVeEowU1BSdGdhUkhsLzVqNnJad2p5?=
 =?utf-8?B?N2ZwVUhyZENWRkZKWDhyb1JpRVZOMzl6V3lwL0hXM3BBM1hxQTAvVWw5MVl6?=
 =?utf-8?Q?5rxiPzj5v0Lda?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7925.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bmk1YXFtaDZJSFRRNU9MQ1dPNzIxK0E3Yk1USXpRd0t0SmkrY1ZQYUsyTWto?=
 =?utf-8?B?R1hheDFXYnZ2VWUzS1pjdVFoaWdPd1JOTE9mMnNrbVovRlZrZDFTd1FOUUtR?=
 =?utf-8?B?TkpROHdLb1JJR29OVU5rMlhkVWJ1RHNGWmVyU3VYczhKVHJVaHhOV2NaZ0pN?=
 =?utf-8?B?OWhMRnJaZTNJLy9veXZES09jc0lzcnIyTSs1LzJtUjZhWE1IT3hYK0I3Ukpz?=
 =?utf-8?B?c25vdjFFL1J5S0VtL01TQWppbDFvUmo4UHZnRElCUUNrVXpGOWxBZWY0cERa?=
 =?utf-8?B?UStIc2F0V2pwSElOVlF3ZSs1S2ZsNDJoRklPcVRRWXBUWld4dUQ2cW4zL1A1?=
 =?utf-8?B?MmZMd3FON1NCYlAzRjJnWWhoRFJHOFRmK3pxWmNPZFBSNnlDeGptUS9PZU9l?=
 =?utf-8?B?VUtxdUt4bXBFVXMyS1pnZm04UkRHZWNoaXhxcW50cHZnRUY0U3VWS1p1Nm15?=
 =?utf-8?B?ZlFVL1dtdFhBQ3R3RXc2UjN5bmlZQkU1NUVzaytrSHpqc0s4SCtDdXo1S2Rm?=
 =?utf-8?B?RGUvRmY3UndPTUNMZHFPcnRYZFA3dW56N3FiVTR3QW5QSDVzTU5qcjd6aHNR?=
 =?utf-8?B?RDM3UzdqQjdDdVZEZXMzQ040enFySjI1UzNVOUtOajMyQWtVdjlRWEJiTlhi?=
 =?utf-8?B?YXE2RVM2SnNvbHIyT0IvNDg0K05BM1RhRlNZcUQ1bHRXL1RKTkRuNWE1OS9F?=
 =?utf-8?B?Uk93MDhJZ3dobXdmTWphZTdmSGxqQklLS1JMRHRmQkxRMjVidUIvRDFONE9P?=
 =?utf-8?B?bTlNYzZLcFFWUkFvLy9oMHFzUXNXTVZzYkF6OU5PMEZ4Ry8wQklNWHdkcmJ4?=
 =?utf-8?B?bE1keklDOHBRM1RWRmNhaEk3K1pEMHhWZE5qaEtReitsM2x6aWRtUy9xTXhk?=
 =?utf-8?B?UU5xYlJGdjhZUGY0TDJXYWVZWHZ1VGJHRWJqOWpJaVl0eW91WkoyTWc2aFBV?=
 =?utf-8?B?SDR4Z2VsNTZvMEZSb3kycEs5bUhpSTVNTmtDalVON0hDSnFrL0dkTnQ0ZGNV?=
 =?utf-8?B?ZmVGR08rTFoyTjc1Nm14MHlNZno5bm5HZ1E2UWVzU0NxOWFZaHlMT0thVlMy?=
 =?utf-8?B?NWpzYmIwdjJNV0dlU0hTM3BNYjk1UTFZdmNBTFhiWGRzeENwQUFBeUlySmtW?=
 =?utf-8?B?ZWZkckNuR2dDNDRTUGFUM3dsc1c0dCtqTndDTmFDOHpRMTRxWXR6eGEvTldL?=
 =?utf-8?B?WFU2K2VpcTlaL1FkYlgwWHNMamdTazliZWNxeHpHNk5pQlpubWpkTmdLZCtR?=
 =?utf-8?B?cCt3ZlpaT3RBZWJvNWdiZnVlR2x4YXFzR3g3YkJBbHlzY3Y5dlBHRm9LVkdY?=
 =?utf-8?B?MGJ3aVZ4bEw1YTdNNXRjVGdCSHAzUThXRVdNb1NiWnFUek1aVVRyZFAzdlBH?=
 =?utf-8?B?SE1yRS9SeWYrMWtNMWN6NHhHd0xYSHd0NUY5QnE1UjZ2a2xzNTA0cGdVZ3ZP?=
 =?utf-8?B?ZXExKzNuOWdMaGVXNVp1Um95SlJkN3FSV0NyZnJUeGk3TDgxak84VjB3U1pS?=
 =?utf-8?B?dVNOYUphaW1halpnMFR5Q3IyMkFmYWtCMGE2b3FXKzlpQ0xOY1E1cnNIYjdE?=
 =?utf-8?B?ckxTY2ZmenJqVlh2aFphVDlvS1RQdmsrcmtSR0pqcFJpaFludEFNV1dVOHA0?=
 =?utf-8?B?ckw0Ly9wY1M0aW1LU3Z3RStoMTR4bll3cTZQOGMrczNGNVpraERLQThwSGF3?=
 =?utf-8?B?K296d1B0V05md2d0Q1VIRTh0aFUvU2VEVXFnaEd0M3BDc3pJVmZuTEJGQ1U5?=
 =?utf-8?B?OVY5L3cyWTY4ZHlDaEg1ZmZ3M2ZSTW9pVXlIK0tMSEhQK2dBRnl0aEM0WVN2?=
 =?utf-8?B?clZnWVFHd0FTSUNCMU5WWUZJOVFUSm9NYVMxY0FhU2VpVGl6STFaRmJka05r?=
 =?utf-8?B?YjFZdUtyMW9Cd0dtc1FTbEdwTmdmYjdCSmo0UC93SU1xV2w2YS9ZQnFKcGZs?=
 =?utf-8?B?QVprY0Y2OWZwTXQrRjBiTWk1UnkzQnh3REVuNSsyMEFabVhvWXFmM1NqdlQ2?=
 =?utf-8?B?c1RnWHlQVzhJQXJRMjU0NC94OVJKalRhb0JIcjQzRGFnNkhJNitBelVlcmJU?=
 =?utf-8?B?VHU3OEpPL09NUU9FbFBncnRwOVN3dDN3TzFCR2JVSVhMTXhRWlRwRVR4bUtv?=
 =?utf-8?B?TmNFTWp1ejhyY3hudUM4UG9hZFk3VWdqZlFuMUVkak1rTFpmVGNYdjF5U2M2?=
 =?utf-8?B?eEE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f746e32e-b875-433a-82ca-08dd71410a99
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7925.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2025 17:17:12.2679
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xfGkR5LqCQpOT9LSnF5eGpnixKAAQ+H3SXwf2qfSSBi+zNoWtuJxNyMkoSnIe7NCmJBEUTvHbaJ1t0UjmlGVAW74ECl25FhixnYtC7c9qVA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6926
X-OriginatorOrg: intel.com

On 3/18/2025 8:31 AM, Chao Gao wrote:
>   
> +	WARN_ON_FPU(!fpstate->is_guest && (mask & XFEATURE_MASK_SUPERVISOR_GUEST));

Did you check xfeatures_mask_supervisor()? I think you might want to 
introduce a similar wrapper to reference the enabled features 
(max_features) here.

Also, have you audited other code paths to ensure that no additional 
guard like this is needed? Can you summarize your audit process?

Thanks,
Chang

