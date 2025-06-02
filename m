Return-Path: <kvm+bounces-48213-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E8159ACBC6A
	for <lists+kvm@lfdr.de>; Mon,  2 Jun 2025 22:45:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3BCC73A59AD
	for <lists+kvm@lfdr.de>; Mon,  2 Jun 2025 20:44:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7ED66227EA7;
	Mon,  2 Jun 2025 20:45:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gswNcyA9"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8168717A30A;
	Mon,  2 Jun 2025 20:45:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748897111; cv=fail; b=P4ibtkrd7Aazk6OZ2SV4NQmxEciJ0d/qBNDcg81QwziUh3FdUNxZVmRStsgmeTznHTi1cbuHOY1mmQi2n3lWuXMi63PGAv9cRFiZDosc50xop4ZGehA2nNHbIBo54I0+RFlSj+DEakPlJ3P2MPFgccSKIq69bNFceJOyD6UUrf4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748897111; c=relaxed/simple;
	bh=StH6vIUj2kaa5piES7a263Pc6nXu/O30+t+RC0XzTsw=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=fhqtpS+qJn15Q7Kk+S3WZSi9IxVawfZTnflUPcYooDmWmK7qItnnbtVi0OKfWXTMySXlODN36GeMPKzeIkF+f57U3ZXHxD/uHkg23EhE/H9lfPMVsvDa3IEEKhWSfO8Iii0Nui27QYTV1HPtEfsB9SvKk2its4xd/CcVhte8zLQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gswNcyA9; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1748897110; x=1780433110;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=StH6vIUj2kaa5piES7a263Pc6nXu/O30+t+RC0XzTsw=;
  b=gswNcyA9EGUAjdX3S89JbfaMwGdi4IUJ8f8/GQWB3oh/aaLN/0P8Ok/l
   J0xTgkeKQOD+z+wQJpWQhyh9qN/Er8psKBWrqSABPAnK+jyiPOSmsTk0j
   gKtQZNHLuMhw37Z1Qn8EhwSdbGOvlgxlaSH7a+TUUDdJRYPFtkShnFXJ1
   ocCLxQNStmS1sA71SEkSnsqMrPNFWKOsaRnGdlmZGjpCpyNRf+D9RF/OI
   /lh8LgTmTt6P5kC0YQheBk83JC99x9/givZZC8+4xx99P7IDeRj2bnpi+
   O1TbzH1vbaEG0hefl+3rk4tjLpo9YhHr5zZLrKAiEhfqnwCc5EB5RyVv5
   A==;
X-CSE-ConnectionGUID: 4nKsb7pVQAOT5z00A5ub+Q==
X-CSE-MsgGUID: 4FzzMjr+Sqy2Gk0CgwHe9w==
X-IronPort-AV: E=McAfee;i="6700,10204,11451"; a="50040568"
X-IronPort-AV: E=Sophos;i="6.16,204,1744095600"; 
   d="scan'208";a="50040568"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2025 13:45:09 -0700
X-CSE-ConnectionGUID: CQhzbe2WR5iNLGsT7Miv9Q==
X-CSE-MsgGUID: IHYcZJ1oQ1ayNmvCb08FRA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,204,1744095600"; 
   d="scan'208";a="149645625"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2025 13:45:09 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 2 Jun 2025 13:45:07 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Mon, 2 Jun 2025 13:45:07 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (40.107.223.74)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Mon, 2 Jun 2025 13:45:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jcxX6RoTlYuV2eE0DG9477JQO+1NswBrFGO4wJaSVKL/YhqidOaGEBzRDMf0qsl4/uz94GD7CrX+dLWB0PmYfkgMvcVH2UoJYgHomYucoqpRj6LZi6DKqSk/XM+LL3/XnGVfeM++J1yjGXjiRWgAI3EciEibQ4lgTRUUq29Lj1RsNl+AdZWftOA5VFsL03vM8AIRQEgosyoawP5JIJ6/4xSJ+jnRCG7zlHkemTe/x906IxZk9I9V7WRndXC0vA1QK1xFZS86EJ2N1UuC6HUahmLxp1k3lQCQtuFTMX/SGtJl6AvYUTCJrAx2qZcnyHE8VakH0VbITdKnDWggFy/LUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LZcpKvIxlF7kdwDHrjV7wnGLB3wGYhoT1WFEJLDGiAo=;
 b=sV/ouCd2AwWD8Vlf2rzTot2Y11H/DKk3nFq/HuKw3UMoF1HL3Oe95XMjsZjZzrPWORbiNgS9FjkMPBclz6IELI7iQRiKHpx9krJvnl2n8vkW28VLBUxE0/DK09MR8xM2Gx11otLPrXjAeVWYGiSdIjmPTqMzLVwFH4JH1oqUZroMoaSzS266mFNjT7MKy3vwDh/irWiYA6TQKSsk+GcIhOXB9dHq7yw4qAB4wh5d7WbYC9RbZpIzDl8YvyfyteCcod4c2f+Rg/DMPV+DnS8Ejm3vOwqzZaMNUTznW8rJkMnY5dyVf+vPDX+YuRftltHKX/z0NkmOo1sv4z/t1yHshg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BYAPR11MB3320.namprd11.prod.outlook.com (2603:10b6:a03:18::25)
 by DS7PR11MB8828.namprd11.prod.outlook.com (2603:10b6:8:257::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.37; Mon, 2 Jun
 2025 20:45:04 +0000
Received: from BYAPR11MB3320.namprd11.prod.outlook.com
 ([fe80::e8c4:59e3:f1d5:af3b]) by BYAPR11MB3320.namprd11.prod.outlook.com
 ([fe80::e8c4:59e3:f1d5:af3b%4]) with mapi id 15.20.8769.025; Mon, 2 Jun 2025
 20:45:04 +0000
Message-ID: <e6cb58cd-bd0e-4453-adf1-126a4b830b96@intel.com>
Date: Mon, 2 Jun 2025 13:45:02 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 1/9] x86/fred, KVM: VMX: Pass event data to the FRED
 entry point from KVM
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>, Xin Li <xin@zytor.com>,
	"H . Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, "Thomas
 Gleixner" <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "Borislav
 Petkov" <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, "Peter
 Zijlstra" <peterz@infradead.org>, Adrian Hunter <adrian.hunter@intel.com>,
	"Kan Liang" <kan.liang@linux.intel.com>, Tony Luck <tony.luck@intel.com>,
	Zhang Rui <rui.zhang@intel.com>, Steven Rostedt <rostedt@goodmis.org>, Andrew
 Cooper <andrew.cooper3@citrix.com>, "Kirill A . Shutemov"
	<kirill.shutemov@linux.intel.com>, Jacob Pan <jacob.pan@linux.microsoft.com>,
	Andi Kleen <ak@linux.intel.com>, Kai Huang <kai.huang@intel.com>, "Sandipan
 Das" <sandipan.das@amd.com>, <linux-perf-users@vger.kernel.org>,
	<linux-edac@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-pm@vger.kernel.org>, <linux-trace-kernel@vger.kernel.org>
References: <20250513203803.2636561-1-sohil.mehta@intel.com>
 <20250513203803.2636561-2-sohil.mehta@intel.com>
 <aCSljsvI0A-HC_DT@google.com>
 <e12abcca-b7b4-404d-b379-8636e5b68813@intel.com>
 <aCaRvwnkXf07Mtue@google.com>
From: Sohil Mehta <sohil.mehta@intel.com>
In-Reply-To: <aCaRvwnkXf07Mtue@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR20CA0027.namprd20.prod.outlook.com
 (2603:10b6:a03:1f4::40) To BYAPR11MB3320.namprd11.prod.outlook.com
 (2603:10b6:a03:18::25)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR11MB3320:EE_|DS7PR11MB8828:EE_
X-MS-Office365-Filtering-Correlation-Id: 45623421-5867-444c-f4c2-08dda2165a28
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?eUFBWVFVbEhnRXBnbUFrOGhGTjJ2S2szNEZiVHJoQVg4aWhUM0FZQVJvK0ZT?=
 =?utf-8?B?dkVmOTNUSEIzVVlObWhZWlR6RnpDWnhkd2plcGc4UFk4Z0RGblo0U1lFTGN6?=
 =?utf-8?B?QkNEN2RhR2V0ZGZPbnpIWEFVL3FNR0swdDNwMmdSZ3o4b3Z1SVRONmNHaDVJ?=
 =?utf-8?B?MloxaDUyWEJqOFhaa0FsdENLTWd1Tk9LSkJKcTg5Rk9DZHJOa3lZejNTdkZ5?=
 =?utf-8?B?RnQ5cjdnZkJTM1poVHg0YzJ5QzFCTUZwTlhjWkpBU1Nidkc0cUwvbi9rOEow?=
 =?utf-8?B?L1M4aG5mYlFxN2I5WWxRajE0dUt3blEyeFdHVG0xcEE3YWNwdWhnaGo4MGVx?=
 =?utf-8?B?S3JuaVBmUUJTSnNrZWhreEorOUZoKzhMSTZlc0FXSVM1WFZGUFJsdHduZmow?=
 =?utf-8?B?Y1BmM3A5WHIyQnZiYXBpWU9wWHVvdGs1Z0Ixb3ZOK3hFeDVtWHptUytIaFhi?=
 =?utf-8?B?NU84UTErMmtBeDIxZTd4TEYrL1J4MXVTOWZpU3V2eUtHeWJwblkxc3did05L?=
 =?utf-8?B?SmVmRHBwRlR5bEFTVzZtZWptYWdUZ1Jpa1B0UlZYeFBzMkQzbVhNN21WbGdJ?=
 =?utf-8?B?MTJobDYwdCttU3hyMjBLUVBEbmcwRHkzS3kzeVNjTEIvK1FwbVorajN0VEpm?=
 =?utf-8?B?bUNKaVF4eVNTTC9Fb0ZqMUh4clFmamxmdUhHY3NySVllL0dmVVU5ZVFDWHJT?=
 =?utf-8?B?OHpJM1NRUEYyMUxKa09rNmZUL1l2QlhOaGxrWm9sMnZxQWVVejdXakg0MW5s?=
 =?utf-8?B?aFQxREdMRHYvdGlNRFM2R3Jmc1hBQjBwMXR5empBY2E5UlA1RUUwcUpUY25j?=
 =?utf-8?B?MWVxZHpaSEg1V2ZsRjVZeHdRZDE3OU5vWlRSVHp4U2laS3pxRXl6Z1RPZnRJ?=
 =?utf-8?B?VDR3ZDYrZ0FJMmJTeEtXUXgzYjJNNmxJT1FPcC9Ua0ZlcTQ2TExKdDVBaWdL?=
 =?utf-8?B?R2dmcGRnalQrNFM0d0ZXUzhkRzdFckZZV3k1UEFDakh3YzFpajRTZEs4SkJw?=
 =?utf-8?B?ZFlRa0pKcjZ3bHJ6ZEdoUk12NnUvWlZjK2xkS3VvUW11T0xnSG5mcUhUZnFr?=
 =?utf-8?B?N1d1MFh3MDBnbzJZWnpKbmlmbFAxbTlvSzhjS3QrRkppN3lRaG9rZHVWSnRl?=
 =?utf-8?B?TnpJbk5PeUhjRVgwRWw1RTB3QWU0eWFWQnJyWTN0V1prQk5hSDhKS3lpbUtJ?=
 =?utf-8?B?WjZFbWJxQ2Nna0N5VjlQYjVBcEc2MTZHbld4YkVYM1JmOHBTeG1MN0JOR1U1?=
 =?utf-8?B?bXQwd2Y1K2NtUmxlM0JJKzF4Wk5RSnFrcm05MmI3K29UcCtXTWxYRlpzb3l0?=
 =?utf-8?B?WVBhelNDM2ZRYmM2TE4yTTBucTd6RndpM1NsemxNWnVxZHZVMDk4bkJBa1pX?=
 =?utf-8?B?Unk2a2tvNnVueHBhM2d4SHF6UFpab3B4SXJQM1dzYU5MeXFKVm1QdXN2UVZN?=
 =?utf-8?B?QjFuK0xBdkpKd1RIRzdMeGFha00vcHRKenE0WGlRNDVmc05UL211cFdHcmlX?=
 =?utf-8?B?V3YyNTY4QVNJay9pc0tTenc4NTg1MW50b1RXV1lobS9TOTlmWk9rWU5xK01t?=
 =?utf-8?B?aGErbmlOQTAwVUd3WWN6Q1hGSlA0a2M5bWduaDQraDNCRitYNFg1TTBpRXlH?=
 =?utf-8?B?Rmd5NXlHbzFoRmtWRmpzeXlZSUJ4RllMbldrQnhZVlhFaDFBeVNlcjgzZnBu?=
 =?utf-8?B?QzRqa1lPTmIvUW5XL2FFNEdleFcxRHhzakNiTklPMmVobnFrOVlyeWcrbkZJ?=
 =?utf-8?B?enQyY2d6NjdpN2JPaEpuMWl4bkk2Y2c0YXN3T3lOUVh2TmJiVmIrL0F1M3Qr?=
 =?utf-8?B?azQ2bkI3MDhHczB1VWdNcUZWcFJCdE83a1hxUFVFRElFOUVEOWZpRSt1M3Fs?=
 =?utf-8?B?OTF6dFN3cWJMRVBhdkhGNXJUZEtvNzNxTEgyaUZWN1hFSGRmYnpQVW5OV0l3?=
 =?utf-8?Q?yuqUPlMa3Ns=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3320.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ei9QRVpITDNYSmNMZk9tNitRcXB0Y0UyM0VMdGlXdHhTemFleWhRRmFBZFp6?=
 =?utf-8?B?d01ydTA5ZFpiVFpDQlg5ekpXcW1GYTBIWmlyRGRUTm1YM0tiVTNJYkN0cVdt?=
 =?utf-8?B?ZDdPSWh3bHhGTmVlRUozaGVLeDNUQUk3aHlKaWxvT3hreVNpL3ZMaHBFNkRt?=
 =?utf-8?B?L1hpU0FpVGs5VjQ3S1R6dEUzd3VHOXhtdjVkNWI0aEVLMkQyeFVoYzRBS2Zz?=
 =?utf-8?B?ZVp2aGM2eGFvY2wrQVBaeUtUSEllN2pMakFHblZhNkc1OHFIKzUxKzN0cXo2?=
 =?utf-8?B?Y2gxZHFuZGdBS0xnU3dCYVNPdDRTa2JodW10bkxxT2xwWnJTYzQ2VEQ1aXJ6?=
 =?utf-8?B?cGIrMlozREVRYUxZTng4YVh4QUxTbjUwUHh6OFNGL0U0MVRwbzA0djBVWHpL?=
 =?utf-8?B?bUd5TTRQNDdSRExVT2RsTVBDcHZsUnlPaGhzVmNBME9nWnZMcG8vRDV5OUdx?=
 =?utf-8?B?dDQ5WEJzK29TRVh0L2dHZ1BVNTNCZW15VjNsVWFlajFMbHhRQmI4Q09OdUJZ?=
 =?utf-8?B?Smk4RnVVemJycW5UYUtHSzlXVXRYNERsbkhiaEJjMzI5MG5pNmRuV3BTNC91?=
 =?utf-8?B?akRpMkgzK3dNYnFRbHdjeVgrelFOTGlPbWdxcE5FK0U4dDZBcVI2U1N4VjhK?=
 =?utf-8?B?Ni8rTVg0SXVheVJKMFlvQ2VpYk1MNVdjY0Q5UzBEVkNEOGpiT3YxbHF1WHZK?=
 =?utf-8?B?dkt2MEpDcFhzNjNZV1d2dWp2cHdWWUlnS3JyNkF4aDlhMThSNHFPM09oVmRy?=
 =?utf-8?B?TkhqRlN2T3pIYkYzS2NFOEZWclFTVndhSVpVWGkvSzdLK0MyakNITVQ3ZGMv?=
 =?utf-8?B?ZnYvUnZoZWJnYzZrdG41M1Y1OXJ0Q1U3M1llM3VWOHpKMGlKQ20vUGRRbGRQ?=
 =?utf-8?B?UzQvL3grUUh0WTUraG0rNElFUzEvbXpKbVFDV3FPWVZvTU9MWUx0SW5zV0F2?=
 =?utf-8?B?ZFEyZzBIQVE2UVM4WFZFeDByMndFTURwZnJ4S1ZESzNWWnoxa0J1eEpTZTFK?=
 =?utf-8?B?OVFVSUhvN3Y5ekVjeHd3TElrRWZ1WFRFNjMvV3c5UXBnTFMxUXJlN1kzOFBE?=
 =?utf-8?B?SStEWnErU1lYMjA2OW1KbmJnWU9YY2I4K2ZwZmlvRHVKaHlTdVlWNytOT0wy?=
 =?utf-8?B?TkF4Z1FhaWp3NmMvdjZpZUdVZnhCYWlWdEtqbEc2WVljTE9rdHJtUDBQenFU?=
 =?utf-8?B?RVkzK2FEaFFOWUtWSjBDMVZLME9LMmhzWEFQUENQZzlDV05xQVJyeTE3ZHRp?=
 =?utf-8?B?dHJmM2JVVHQydjlkTmRMNEUzNWRwYm5Cc1RxclJBMVVmNlo3dkgrNFFVSzh2?=
 =?utf-8?B?cFI1SVpyTTV3K3hja2pFQi9jdlpMcS93NUk1YktKM2tod2w5TXVsRXViQXUw?=
 =?utf-8?B?cUpPelZFUE9TaGh1Rkl1WDBBNVBRMkw0M3NzdTYzRlpld3VqMTVYY0NMODg4?=
 =?utf-8?B?Um13UC9xeUFQdWpRcmdKVDV6VlJuTnFuYXBZNnQyZ3lKM1pFdWs4ajJ1b2pS?=
 =?utf-8?B?OGp0Y3VDMnhkQ25JTVh2b3BlTmFlc2ZaNW03Q0xuaG4xRDdUWlJJamI4UlBM?=
 =?utf-8?B?L2xJZ1Q5Y2lqcW42bHJoMlVSbDRrTmUrVHRkVkROTUF4b0tud054ZGwzOXlF?=
 =?utf-8?B?VUUwdjBFdmtZWVBwcW11Qnd1b3d6SjBKVk9JK2oySUc0ck5TNGp4bUFhS25Q?=
 =?utf-8?B?cVhJK1ZvelpOZktwL1ZQcjArMEZKaS9GbnE3S2l0L1RhL1ppQllQa0Jncll3?=
 =?utf-8?B?bms3QmtGcTJ2S0xuUXdCcEFkazNydjVxdHFRSEVneXBpUkZmTGk1d1dscm4r?=
 =?utf-8?B?NHVmOVRFd2syaGJCbHR0VnRpdVFabC9Oa24yVmhHaTQyUHlDeks4TWo2aWI5?=
 =?utf-8?B?WDJ1VU0yQzhFVVNybVU1alIzbTdZVW1jM2JTMmI2dXR4azYyR2EwSnlxWnRS?=
 =?utf-8?B?T2RObWVPY0E5RXdaWUQrR1JRVEdjZDc0VXEvaUJ4TE9SWk0vUzJIYlNqTmZm?=
 =?utf-8?B?RTR2bm1xMUx2OEIrVVNqRjNKdDlCV1hKOVpvSVVYL3BTQWxlNFhESndlWEZU?=
 =?utf-8?B?SUdMT0xhTWpyakRUdHB1RG82UkhQQUJYNTI3L0ZLajlCcFliaVUzaDN6S04x?=
 =?utf-8?Q?g1ol3RfSeDV+fpQxz6VmndPFa?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 45623421-5867-444c-f4c2-08dda2165a28
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3320.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2025 20:45:04.3797
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vnm8lcfQoqbtgfL6WPiBw53UbXXF+j2wiptuoodxUHLBDshIM4IbmgDvv42MaJE9ANp810zBA0z1+CtVEIfjFA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB8828
X-OriginatorOrg: intel.com

On 5/15/2025 6:15 PM, Sean Christopherson wrote:
> On Wed, May 14, 2025, Sohil Mehta wrote:
>> On 5/14/2025 7:15 AM, Sean Christopherson wrote:
>>> Compile tested only...
>>>
>>
>> No worries. I'll test it out. I am assuming you want this patch to go as
>> part of this series.
> 
> Yes please.  I can also post it separately, but that seems unnecessary.

The proposed pre-patch works fine. I'll include in the next revision
along with minor changes to patch 1.

Wondering if there is any feedback for the rest of the patches 2-9? They
haven't received any comments and stay unmodified even with the new
pre-patch.

Thanks,
Sohil

