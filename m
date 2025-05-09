Return-Path: <kvm+bounces-45998-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CC85AAB0739
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 02:45:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8858B98592B
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 00:45:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 672133FBB3;
	Fri,  9 May 2025 00:45:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Vxef+oFq"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7156FB640;
	Fri,  9 May 2025 00:45:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746751518; cv=fail; b=OBbnpjzMB/WP0vUAS66cbY2dReN5EhJaeXlMdqpFhUuBn32IFNFdfkBV+PtGiuJRX6Bv7i8vrMlmldw7z10dmVbmbz/Ykm8ss+rQWObrLiS2dtZzHKkqBNhegdN3Woin6eN3qz2JQ1LEigckUsNOUl2LbwkVORrgbCCVucU4eg0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746751518; c=relaxed/simple;
	bh=kiSWZY36fjfX+BfgQVj3nqbn3iiM7g+3Xps5ljKthpY=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=NftsVHUwMyqHAyTu2MZ0Ubs/mGWaonlWbLW4loluqEFiFbhSVuphowi9YaBX8rOaMVvS6c6jx6hqyxdohyoF12LygM9FjUoedWM2cf3HqNWSeuPKldzB8OV0ULRgOUuR2xuiEHRKBK/Xpm8mfLVefpFwsopvr/8JB8ySZyq5/Is=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Vxef+oFq; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746751517; x=1778287517;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=kiSWZY36fjfX+BfgQVj3nqbn3iiM7g+3Xps5ljKthpY=;
  b=Vxef+oFq7Dy6L18/x9fqEDu4kUCK4p2nQX5SmM0Z3Vq6rFaDy1srGMh1
   2Ssu5PmFqW0/01FGzDUDQ9935au/erz23GkOijQwyYkVn8wkVYmWyf4h3
   X+tWSyFHpfZySYq1hr2T7u0/jAFqRWXToSWt5aGdC/jYIGgenRf5vIRld
   K81SR36QGNz0IBhfTbvBLrOWysCdYjlq8Rrs7bRnMrd60DWY9+XWWDoFT
   dTjjF28/wLLEOI1JYCQs4x8XkFTVbxIo3PJiKD9gDBAUC7GUUQ4eUVGqU
   ALpm1fyCTN+4wM4PaEWLnvDyZDN7Dkxj50lAHM7hSOmKuPYzxTsfSk5Xk
   w==;
X-CSE-ConnectionGUID: kHVLya6HRdGDvTZ55Bhv8A==
X-CSE-MsgGUID: lAuJRKI+QvqSrAG18LPVjg==
X-IronPort-AV: E=McAfee;i="6700,10204,11427"; a="48675357"
X-IronPort-AV: E=Sophos;i="6.15,273,1739865600"; 
   d="scan'208";a="48675357"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2025 17:45:15 -0700
X-CSE-ConnectionGUID: tFOkje/kR3WRUURGOKcZ8g==
X-CSE-MsgGUID: i1zQrcgVQOioX7zxq+Mgmw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,273,1739865600"; 
   d="scan'208";a="173632794"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2025 17:45:15 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Thu, 8 May 2025 17:45:14 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Thu, 8 May 2025 17:45:14 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.170)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 8 May 2025 17:45:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FLi6bdKdmYx4iIwYeucYhlpsusaCGUICI0dYbRGmzzpx3B0ullJ7Gq04a7Rg24w6PM4JPytWB8yAPJ4JIYuWzez+AWqaiqaOqhEU4eqK8xX85IECgnqCiRa+TF9mx9TYDG9kv5GPklppaa0r10xWE6qON4v6Ke8ZXGB3BCajRRmWv9kUuUP2QDpqRhZCOzBG6b0PxeEWjXwMRq7QT9m5M9x5YZtVtSBF9vGy5vDvj0ykuUVol9ssyoBzYDjuSorQ4QtVoWwAzWG3DcJpyFrlj61IBv8naSJC59uQQOY7CQ+ljrfQPuEPbU8VAKEJyMRMfnfY02w0ep9ksO0tM+AHgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=me4XZ7VVDd6gw5tiAQoXn5kZbgMGZtRk+THQoybeX3s=;
 b=J8kidMyc/dZtQAWJ0yf/TeSzad/9eOLG4QsOCBOP6b+fIdUuHVp6Fa8dKMK3OFbYtBsAemrQPejCNLyEeu84CjYP5Nkq8WEMwwiVnFRQPn2/ChQxsnsWC7zWn+yyjSSkPqf3zyV2tItKFGbW6cjbPbyRkfP3gI/rWdmkp0+uROEQ7/rUZ2dZ09PpBxjUm9f+rcOwrsHBRfkZatO4MMyjst0s+SStdMawEklk/EqWSPiAdhU/p/ssUYytUrKqxzJO5EXPmVkSMQvdFcwXrabsLnsxAW1ls2U/tgJqlZbCUjV/EqZ3p1dD9VaGVQ/haPCnEmlEHGGKG23NqKQG1+Dtpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BYAPR11MB3320.namprd11.prod.outlook.com (2603:10b6:a03:18::25)
 by SA1PR11MB6894.namprd11.prod.outlook.com (2603:10b6:806:2b1::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.23; Fri, 9 May
 2025 00:45:06 +0000
Received: from BYAPR11MB3320.namprd11.prod.outlook.com
 ([fe80::e8c4:59e3:f1d5:af3b]) by BYAPR11MB3320.namprd11.prod.outlook.com
 ([fe80::e8c4:59e3:f1d5:af3b%7]) with mapi id 15.20.8699.019; Fri, 9 May 2025
 00:45:06 +0000
Message-ID: <ad44acdb-3e4b-4160-b722-d923e26fd029@intel.com>
Date: Thu, 8 May 2025 17:45:03 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 5/9] x86/nmi: Add support to handle NMIs with source
 information
Content-Language: en-US
To: Peter Zijlstra <peterz@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>, Xin Li <xin@zytor.com>,
	Andy Lutomirski <luto@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
	"Ingo Molnar" <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, Sean Christopherson <seanjc@google.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim
	<namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>, "Alexander
 Shishkin" <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@kernel.org>,
	Ian Rogers <irogers@google.com>, Adrian Hunter <adrian.hunter@intel.com>,
	"Kan Liang" <kan.liang@linux.intel.com>, Tony Luck <tony.luck@intel.com>,
	"Paolo Bonzini" <pbonzini@redhat.com>, Vitaly Kuznetsov
	<vkuznets@redhat.com>, "Rafael J . Wysocki" <rafael@kernel.org>, Daniel
 Lezcano <daniel.lezcano@linaro.org>, Zhang Rui <rui.zhang@intel.com>, Lukasz
 Luba <lukasz.luba@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Masami
 Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers
	<mathieu.desnoyers@efficios.com>, Brian Gerst <brgerst@gmail.com>, Andrew
 Cooper <andrew.cooper3@citrix.com>, "Kirill A . Shutemov"
	<kirill.shutemov@linux.intel.com>, Jacob Pan <jacob.pan@linux.microsoft.com>,
	Andi Kleen <ak@linux.intel.com>, Kai Huang <kai.huang@intel.com>, Nikolay
 Borisov <nik.borisov@suse.com>, <linux-perf-users@vger.kernel.org>,
	<linux-edac@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-pm@vger.kernel.org>, <linux-trace-kernel@vger.kernel.org>
References: <20250507012145.2998143-1-sohil.mehta@intel.com>
 <20250507012145.2998143-6-sohil.mehta@intel.com>
 <20250507091442.GB4439@noisy.programming.kicks-ass.net>
 <55527575-e3b8-4cf6-b09c-b81437e0c892@intel.com>
 <20250508121544.GH4439@noisy.programming.kicks-ass.net>
 <D368D488-6D4E-4590-8E98-A7D7CD5E7F20@zytor.com>
 <20250508204906.GJ4439@noisy.programming.kicks-ass.net>
From: Sohil Mehta <sohil.mehta@intel.com>
In-Reply-To: <20250508204906.GJ4439@noisy.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0013.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::18) To BYAPR11MB3320.namprd11.prod.outlook.com
 (2603:10b6:a03:18::25)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR11MB3320:EE_|SA1PR11MB6894:EE_
X-MS-Office365-Filtering-Correlation-Id: 75dea8f1-d771-4d10-d9ab-08dd8e92bdc5
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?bGZOODk3R1BxcktPbHJrNzNwYWZyRjVDNUpLbWkwZy94bDYydG9TcldoYVQ5?=
 =?utf-8?B?MjlUR2xDbGVVRGgzWloyb1N5VkFQUWFCZS9USk40SUh3REhXZ1RGT3RXYm45?=
 =?utf-8?B?RE8rZmhVZ3BWWTl6Vk15UnVyNUJ3aGlDVk5ZTER0VnZJcFBKY1NieDFoOXVW?=
 =?utf-8?B?c2ZxTENObE9OandNbERpV3Q3ZjZPaEx5a1RpdVQwR213eCsyYTRROVFQNWtK?=
 =?utf-8?B?MzFPejE4bWt5Z0NMOExkRk1hbjZFQnRvWktUTm0vMHZ6TitvcTdIam1jYlNu?=
 =?utf-8?B?UHNmdWZoM3d4bnJ4RDZWb0h5UHNxSjBtS05FUXdxeEVuenJPMk1yRWNjd3Rl?=
 =?utf-8?B?ZDk2dlQyYU04QkU4RVU0a1lxV3hyTDNHOHpSWFZpVG5BdVB6RFdVOVV6Wkhx?=
 =?utf-8?B?ZVlhVVNWaFVyNTRCM1BWc1ZVbklYeFlLYm1TOFRMVWhXQ2c0NkxneU0yYmRT?=
 =?utf-8?B?U09PUTFvWmhyR1lnZ2JjbDA1NStwY21Dck8wY0libCtKRWpvbXh3OE95Qm5J?=
 =?utf-8?B?Um9OdTlWc2p1S0lyOE5ZVTRaOFNmRVY0RmpMVFg2RjgzVjdWWDI5VVhzMU5V?=
 =?utf-8?B?YkVPMVhnbkxlSW92bWNYOFpleVpWNEZ2ZDY2MElwWm1pbkJqRWRpeG9HTUVl?=
 =?utf-8?B?Y0ROdFpidWVZSmJqTGt1S2M4STdlQmNTYzJVVHZWRE5OeC9PRVpERXphTFl5?=
 =?utf-8?B?VExGOC9yb210SjhMNmdpTm9xOVBlLzJPb3ZZK3lNNmlscndEblM3cmEzY0Jq?=
 =?utf-8?B?WmlRaXFJVWhQRUZhRXhhUW1ieFhoTFlZRlBhYSsvcnpjWHNXcG13SmZmUW5p?=
 =?utf-8?B?ZEEyOVZYazYwVEVoODhpcXVuQzQxT3dEQmkzc1k2V1g5ankrN29JVVEzb3ps?=
 =?utf-8?B?aXBYS3NRcC9sMm1aYmZlMDk1aU5Wb0wxL3dZZ1VWeGJybVFZNkxPU25vLzBL?=
 =?utf-8?B?V21KOXc2ekxLd2d1WDVPN3B1azdsbk16eEp0NU5wUk9aQVBrTmVSMXVCM0lq?=
 =?utf-8?B?NzVKbHhPQUNVTDFUcG1PZjFPVlVyUjBxY3gvTXhxVnU2RTZCOVZtRVFyanUv?=
 =?utf-8?B?dFIxb1FTSE8yaGZnQmVLUGVEU2s4L3dwZXlpUHF6dXFSb05XZ2l3cjZNTnBZ?=
 =?utf-8?B?alpZTnpaUVJZN0xQSnZjODFhUzNDdmNLS0x0d0F5bk5hZnVqcjN6NUx3V1ll?=
 =?utf-8?B?cFhqTEh6MHB2S2FLOFdDWEh1NVJvZHRJSlZ5NkRFa00zOE1Za1gzT1hOWnZW?=
 =?utf-8?B?OXgrOW9UcVlqbHBHdHRKV3QvRUlOWU52WEtvUWFON05LZXpoQXZGN1NXZ2tw?=
 =?utf-8?B?R2JHNVVVVmYyVlhsdVFDWkVmR1BuVTJlVUp4R2Z6a2VlMHByaHV6d1ZrREFE?=
 =?utf-8?B?YWRZTXZhMW5NU1ZkWWlUa213UUdaM09ZRFlrN1N0dnhCY0h1UkVqc3Q4Wnll?=
 =?utf-8?B?ZHdOWVY5eEpzSHdtOTk0bHRTMWV5WlYxWVJyVzFHUzY1OE5OdjRDQkloS3FQ?=
 =?utf-8?B?TE9XQkhCQjZCaWxQRlhLcDh4WTI1UjA1RUZqUkxqMmlxdUp1amdYT3lxRVNk?=
 =?utf-8?B?RjVzdk5qWXc1Q2Q5UXNTOUlURzN5czVzeU05YUI3RkMwQ0dCVHFkV1BYQnhM?=
 =?utf-8?B?WjFseFc2M1VEcFgyZ0RJZzljMzBUaUR6ODg1S2FxRDVVeGVudjhVMGRyUzY2?=
 =?utf-8?B?elF6ZXhHcFJ2TDJjNjg4M3B3MHAwQk94MlhVT09kaW50dldNQ1ZhNmsyMlpC?=
 =?utf-8?B?aXBaWERRcXRjRFUrRnBGYXQwdnlhbFQ1N3c0cHIrcytOdHVwKzBzZkluOU9x?=
 =?utf-8?B?R3FSUFdreUhaQUZtTHYxMi9veXI3WDRFM3FTYmg4alIrYUZRTHRTc2YwWVhZ?=
 =?utf-8?B?Rkx2cUFHbTRPcnJ6blY3a1c4SjNuTmpVTFRwR2E4VlY1eXdSbHZoNXF1cklQ?=
 =?utf-8?Q?VuB3luTprnA=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3320.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UlFaZE5ScXlkcnFwRlN6Zy8vLzRMWkFaREZZdWdkNWtLakVDOUZXejlldStF?=
 =?utf-8?B?VzdqTUxIdWR2aXQ3ZnRKeDgydTd4ZDR4SWRUUWt0TkhPbDBITk5rd29hVkF4?=
 =?utf-8?B?bWdLOUlxZm9wRDYyekpqbzBQaTJQSFRId0cycUVSdHBQWk9iQis1YXVnZTFa?=
 =?utf-8?B?em5yUmJKeTRtN3JLaGR3UWhvYUdOcVFVZUF0bG1yaElGVklRRDZoYk5lOEw4?=
 =?utf-8?B?eC91TXlibHIxeXYrQmVSeENiUTU4ZjdFQjFGUEVycUpaYWt3ODk5Tis1citL?=
 =?utf-8?B?QU1vR1E2UDl5RE41eDJJR3FFbCtBeGd4OGEvTi9hdHFaVTc3R3BPM251MFhG?=
 =?utf-8?B?Z0RnRFVHcW12aEpuSmYrT3Y0Tkp4V2xJOGlPMlZMcSt5SEhHb0NhY0NSZXlr?=
 =?utf-8?B?Vk4wY1pvdFNqVHQ2UUdyOVpwUUI5QWVKN2Q1VVlhSFBoaUpnaVZzSTFMc0E4?=
 =?utf-8?B?REtLemREemtZWTFiK1NqZmp4eFZvbzRsWDQ2MVRDTXpDdkxDeUtUWTBPcG1Q?=
 =?utf-8?B?RHJvdVNwb3hKNkVEcjc0REtqWXB1MmdDM0V2UDJudzllQVlwbTJKUWRBUGZF?=
 =?utf-8?B?VW9YT2NOdG5mNjBNYko1d1ZDZExMYmNUdC83UHJjYXZWaVlZNG1DNUhZVGYz?=
 =?utf-8?B?TDBhYUJHWFZKQnZEU2JDRVp2NzRXY1BOc0RhK20rMWIrOXBUd2FHY3l3TGs1?=
 =?utf-8?B?Y0NCSm03TDVtM2g5QTlCdkNvRC96MEV3SUhYTGlwMUZ6KzdYR3VEWkFDZGQ4?=
 =?utf-8?B?R1U2UTFIK3dhVGVGZkhCa0VHVUtXYlhqTDRTWXhKS2s1MXNkQ2I5Y0Z6RVc0?=
 =?utf-8?B?Q3NxV0xnbkQzallGektHYnBQRkViSXNQVXVKamI3cSswV3FjeHNHUC9ubUxk?=
 =?utf-8?B?cmRVeG5DdnVwL1ZIRXYrSzltK2JWT2RSUUYxZ09iZ0FBanlaek4xTFBHVXB2?=
 =?utf-8?B?UWxLcjVDS2tVQnVGMGNtdWVMb1hzc0dvLzlFVVVxZlVMUEFkTEJxTEUvZmJi?=
 =?utf-8?B?bzh4ZjI0TWREbzZNeHIwbjdkajgxR3BMejl5MklmQ2htUXhkclh5dWxJT0NG?=
 =?utf-8?B?bzY4WGZvUytLMDB6dGdDRTc1Z2ovUHgyblhZQXZ2R0N5bU1hRnEyWjB4Nnls?=
 =?utf-8?B?M0tYMm00Z21iZG5BZ2I4bWoyYUU3TTdRQWRkLzFVbzJBWUJNamdRS05Lb3Mv?=
 =?utf-8?B?Ky9MdEFEQWFDNjAxcTVidnRIRytQS1dqTzduY1h0V0ppdHhNRU9haS8vcUtI?=
 =?utf-8?B?VzVPSjhPdjFoZmlNL001dDRyWVVvSHR5MjYwK1RIZi9QUzNlYVA2bkNGRnVl?=
 =?utf-8?B?cDllb3dBMTZpcS9XWTZmaTl2VnpHcFRGWGhTbE5xMkVvNE5jK3NSWE5kTmU1?=
 =?utf-8?B?aHNiVzRQeFZ4R09seDBZRU5lZ3FRSGh2OC9xYkloQnZ4L0dKUUtYbWR5bWc4?=
 =?utf-8?B?c3BsWnhWbmZxY2NadWNlR1lEbGZEMmtTNU1BQ1BBa3g5ZEFOWUNOeXRzUEE5?=
 =?utf-8?B?NXpvVmxQeE5sbU1RUnl3eG94dk9FNHV4RUZ2VVJyWVNwMzJtL3hLZ002am55?=
 =?utf-8?B?RlZVMGtiU092K2tRbnVBaUMrM01CcXlleEJCUEZZT3QrTFVQajErdzJ3WFY2?=
 =?utf-8?B?ZEZMWVNtTDZRRDV0NW13eEZjMmVna3dLQnpMai9Fc2E4UCtuZTIvbVdpREF0?=
 =?utf-8?B?UXZCSzhuRHBuTGZyYk90SEw5S004dGJQVENELzMzY2t6bDBZZ0R3U3RjSnBO?=
 =?utf-8?B?MjYvYjE2M1dEc1Z0ZURNZ3l4c1VWOVRyUzNFb0xRM09oNTd5dGZIdEZZV2Qr?=
 =?utf-8?B?WDdKeU1RcGkzckpWOHJLejNQTm1QTjMyVzFtdHUwNytHU1pRdDFQaHR0QlJy?=
 =?utf-8?B?TE5SUHlSUEswSDVJMnR3ejJFZkd3b3dKZ1gzL1ErQVlZZ282R2p6TTBsY0NX?=
 =?utf-8?B?bDZZajYya2RNaUVuOTZtQmlXek5zQmgrb0Y4Yk9Bd2x3SEt3ZWxoRDRhSHU4?=
 =?utf-8?B?V0JUL3JNbXpvSVAzY2pqVzZ2dHJKUUIrM1A0TFl1R3VuYXYwdzZGYkFFWTBs?=
 =?utf-8?B?cEdoaWEwTkEzTEtVMFV3V2ZYUnF0bS9ydFNVZ1BlNzVWRVJ6alZ3aVV1TkdL?=
 =?utf-8?Q?SxblCYNjad2MQs0jIocTC05E0?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 75dea8f1-d771-4d10-d9ab-08dd8e92bdc5
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3320.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2025 00:45:06.1926
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dma+oQj0Rr+0h27YZQjivicjzqbOWGzCxpXreFZFe5D/F7TpQcDcBGBkrWx7DgiztbpMSwwJ/eU/iwrECGFteg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6894
X-OriginatorOrg: intel.com

On 5/8/2025 1:49 PM, Peter Zijlstra wrote:
> On Thu, May 08, 2025 at 01:23:04PM -0700, H. Peter Anvin wrote:
>> On May 8, 2025 5:15:44 AM PDT, Peter Zijlstra <peterz@infradead.org> wrote:
> 
>>>> Looks good, except when fred_event_data() returns 0. I don't expect it
>>>> to happen in practice. But, maybe with new hardware and eventually
>>>> different hypervisors being involved, it is a possibility.
>>>>
>>>> We can either call it a bug that an NMI happened without source
>>>> information. Or be extra nice and do this:
>>>>
>>>> if (cpu_feature_enabled(X86_FEATURE_NMI_SOURCE) && type == NMI_LOCAL) {
>>>> 	source = fred_event_data(regs);
>>>> 	if (!source || (source & BIT(0)))
>>>> 		source = ~0UL;
>>>> }
>>>
>>> Perhaps also WARN about the !source case?
>>
>> A 0 should be interpreted such that NMI source is not available, e.g.
>> due to a broken hypervisor or similar.
> 
> I'm reading that as an agreement for WARN-ing on 0. We should definitely
> WARN on broken hypervisors and similar.

Yup, will do.

