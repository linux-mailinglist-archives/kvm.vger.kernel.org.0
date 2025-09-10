Return-Path: <kvm+bounces-57173-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CDDEFB50D79
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 07:38:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7A4C97B8901
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 05:36:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75A402BE658;
	Wed, 10 Sep 2025 05:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eRrZrRWB"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C9C82248BD;
	Wed, 10 Sep 2025 05:38:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757482691; cv=fail; b=p5bjjwzxrpu12xEhToADjcrld3/SoPTwFVWWFFlRY6HQMZzsh6/pnadP7gm7rv+JZhb245JVpPqrSxfgNW1IhQUMwqgnYU5U793ZDnqvEK4atcbIBBDEqkc2stN9Yb+1qRr8Yn8JiQ5aDmxFTEik6uFTGcZuxJQ98movjRi26Pg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757482691; c=relaxed/simple;
	bh=TXKForvMzB+e4X6UaZpJ2NbPD0p8tQB8fMhCw67zsXc=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=di4devGENvwFiuDJPlH5ZqNxI22J21xrFi9qM94b+FoIZoC1A4T3G/pueN2ofIMHGZDZUrxqT+1G2Ef2m5ETZEefRHR0BsENSo54X84mnM3tEgw1l0mtJD65Y/hHkeGK9A3L3t4MrEvf1o570ONXGBjdBbO7bXiDXAZUU1aX1t0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eRrZrRWB; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757482690; x=1789018690;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=TXKForvMzB+e4X6UaZpJ2NbPD0p8tQB8fMhCw67zsXc=;
  b=eRrZrRWBUHXfDCxIvDCCVlkG4EW4vkkI7bjwsS2d8jDr1sJPMWDnFSPg
   3vpq3MIDwRjBw4hI5BEPm5idJoq2iiD8fSjOd5bVzAit13iSb2VF7d2cq
   I7p5WvNtS83dz0AL1CcAIvxOh/Py2vC+o7KWK5w/Iu8YWCHknEPR39n7h
   h60ZysTT7djwR+dKxZMPUgRD6jz7+jwroF+ZBxdQBREcxyG9cFqf7BHxJ
   UjNqRE1HSdXTccp1vB033J1CMyiQPjX/a04R1//tjU6enlHrA58k3yUEj
   jfujeLyhdMPLE8RoNwI1mFjjqv4XN54/FuESS6B/TBo3ey68vnrOQX/LG
   A==;
X-CSE-ConnectionGUID: tDubKG+mTOilB2HD38pG7w==
X-CSE-MsgGUID: OKfzdcAiR5atdOZ0IO58kA==
X-IronPort-AV: E=McAfee;i="6800,10657,11548"; a="58822356"
X-IronPort-AV: E=Sophos;i="6.18,253,1751266800"; 
   d="scan'208";a="58822356"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2025 22:38:09 -0700
X-CSE-ConnectionGUID: 5WwpGgpNQ0GmztHZyYX1KA==
X-CSE-MsgGUID: EEne2H7HSsixhz+c7t3Etg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,253,1751266800"; 
   d="scan'208";a="177341178"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2025 22:38:09 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 9 Sep 2025 22:38:07 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Tue, 9 Sep 2025 22:38:07 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (40.107.92.66) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 9 Sep 2025 22:38:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GZHKG9sghXveJChHWGO5mgRi/K1WDv8UmEowI6+dRxP05ZTgy9H8z795X2Xf7cyYqDUAYP3yYtT8at5SFXEBLPi5ADBOsSPmp3KA6112C8Eetpu4JEoHRLO7hCTfI6A7xXuyhZyv12E9TNRRPIn5Geh/1Wr1oBEb4kIoXxRckN56SUNMz32SNJqU2cnfBUxni5DA0O509jrY+9fMK3hUSe3CDC1RLwUBLcksIdt8b38GpUnrBb7e1gR8MtpYvjh8vMSXVSnceTnWnvgqz2jFYlV6PdBN+35NfCgtMo06OVA+4Mz4TZ8GQfP0rXBZAJYXG2j/PTubjmdoP7Et6E/yNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hpwPm/QCjmpw+rUZiQFLGvSBj9gq+Y7UgRJr38myaNc=;
 b=vTiv5d0cmT2+eikrl+wRfZt1k8uDO1cAgWOlJL45dD/gvgUoOALoREZxjLcn25oHTFPM0g1SI1/8hH4+/znQF8rTZX5Kv8d/NsjZh/xMs7fVGJgIJCtnB6T+VAtYcIEitTOEnfVVK8ZDqYP1T5Ft987F7Bcqq4LYggnTlvg/TEcijgYB8CWSoMgTyTaR3Z6Vb/RpZRHHUCD3FaueoqlfTdwxpsDuZAD+SGKx1xoNypbx2SeKqRJRlwTE0nfWl5+1rGQ45WRcO+pzbaAfhHCUZB19/Fi0CW/E8lxN+aba1eo+h0zLG1Y+r4deGasaYqW8bxrw8M8sn4vh1KAXQNye2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from IA1PR11MB7198.namprd11.prod.outlook.com (2603:10b6:208:419::15)
 by IA1PR11MB8222.namprd11.prod.outlook.com (2603:10b6:208:44e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Wed, 10 Sep
 2025 05:38:05 +0000
Received: from IA1PR11MB7198.namprd11.prod.outlook.com
 ([fe80::eeac:69b0:1990:4905]) by IA1PR11MB7198.namprd11.prod.outlook.com
 ([fe80::eeac:69b0:1990:4905%5]) with mapi id 15.20.9094.021; Wed, 10 Sep 2025
 05:38:05 +0000
Message-ID: <4f76756a-d1f3-4a39-8de7-5a77d94c55da@intel.com>
Date: Wed, 10 Sep 2025 08:37:58 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v1 1/5] x86/boot: Shift VMXON from KVM init to CPU
 startup phase
To: "Xin Li (Intel)" <xin@zytor.com>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>, <linux-pm@vger.kernel.org>, "Shishkin, Alexander"
	<alexander.shishkin@intel.com>
CC: <seanjc@google.com>, <pbonzini@redhat.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <rafael@kernel.org>, <pavel@kernel.org>,
	<brgerst@gmail.com>, <david.kaplan@amd.com>, <peterz@infradead.org>,
	<andrew.cooper3@citrix.com>, <kprateek.nayak@amd.com>,
	<arjan@linux.intel.com>, <chao.gao@intel.com>, <rick.p.edgecombe@intel.com>,
	<dan.j.williams@intel.com>, "Kleen, Andi" <andi.kleen@intel.com>
References: <20250909182828.1542362-1-xin@zytor.com>
 <20250909182828.1542362-2-xin@zytor.com>
Content-Language: en-US
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: c/o Alberga Business Park,
 6 krs, Bertel Jungin Aukio 5, 02600 Espoo, Business Identity Code: 0357606 -
 4, Domiciled in Helsinki
In-Reply-To: <20250909182828.1542362-2-xin@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DUZPR01CA0338.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4b8::8) To IA1PR11MB7198.namprd11.prod.outlook.com
 (2603:10b6:208:419::15)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR11MB7198:EE_|IA1PR11MB8222:EE_
X-MS-Office365-Filtering-Correlation-Id: 0a2a030f-da51-42f7-fd75-08ddf02c370c
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?SldlekZMOEhDZkl4dDFZS3hrK2hCVjgrVWw2VG5NeXgwc3pGVFpJM2RhbDJ1?=
 =?utf-8?B?REpEWlAybzc2ZUkyMlRud2dKU05nR1VTM2dKYnd2MG5yNEtmNnpKanY5bFlJ?=
 =?utf-8?B?Y2swWmZiZ3BHUk9WS21kUU40SFBTN2Z6S1B3eklhNzZHTmhJZkhja3dtQ1Zz?=
 =?utf-8?B?VUdvK0JtbjR3K0JzM1VqRXlTMW1zWm5LNm13QUIySGttb1hHQlZ1L3lvYkNl?=
 =?utf-8?B?a3BtbGtWVW9PR1FBeGFUMnJJYjZiRWs2TmtHcm9YVTFYYlozS1JUdGRBNjFJ?=
 =?utf-8?B?eVFsNnlPNmZ1OWxyZW5Mb2lORThGOG5wT2o5bWlOS2c0THc2TEpSTXB6K3Mx?=
 =?utf-8?B?Y3gvZnFTU3J6VHVzcnFDR1hQdWZ2SVhtUGFxeGxnbmRMWjBFM21pS2JHbzZ0?=
 =?utf-8?B?Wk1ra3FrdXpaOWx2QWdLcG8xOW1iQ0RmTUZLc2MxWnZOWUo1cjFPMDZqa05a?=
 =?utf-8?B?eUR2VVQvbEQvVHpaQ0JPUkx0azV5ZEFyMldSVnZmdE9jMzl5VXM2NVd3NkZi?=
 =?utf-8?B?a09MVlg0Rkc0UER3RjZSNkpaYVNObjhlSkNKMWtHbGplSjJxQklFSDZ1aDNQ?=
 =?utf-8?B?TnFGbVJld2FZRk1zS3JuT0tWcW0zS0hKeitUdjJQR0g2cjZXSHV2N1k0Sm15?=
 =?utf-8?B?emc0dWZIaEFCcVpqK1RESGdZMnZ2RUZDWnJvMnpxL2hobDRCeWtHWHlVTnlr?=
 =?utf-8?B?OHU3MFFmUERFQXhld1BFVjZlZm5hUkw5bTRhOElUaUJZYUNsRGttWStiRWYz?=
 =?utf-8?B?NmE3QWFsb3dxU0l4emxkUjBMK1RMNERPTnRqVVp3eUNGdmROaWhmc3RvUGo5?=
 =?utf-8?B?d1YvRWhmTndPa3E4Z1UwWmw5QS9walBRejd1MkNVTWxrR01KK3N1ZHpKSjRU?=
 =?utf-8?B?Ui83RlF2UVROOHR0UlVVY2Nlc3l5VlliZU5PRlRhMWk1YnJuemVhMmJZbUlO?=
 =?utf-8?B?TFFJcDQzN2NvV09qdWZ0aEdZRDY0NHFjWWNPMEFHWTFENWdHR0RBZnphejVt?=
 =?utf-8?B?SGxNSzFnL3N1bFZHZmVaYnhYZDRtVmRiUjR1Y0IrVHNSVXB1WitkMEVPT2hm?=
 =?utf-8?B?dldGR1g5NVZlVVpQeGJUN21qYWx0SXVuUTlZQzRPMGR6Z2NnUVhpWmRRYlNE?=
 =?utf-8?B?UWhBdU9iSkJUVTd1KzZhcWkyQWU3Wm9yeVJjMmRyaXRPMmNoZGlnRnROOGc5?=
 =?utf-8?B?WjFRZ1QwcFJrNGg4SnQrV1F2NzJDOEdDdmEyUnU5UFBBRm1kVDdUMHdkeUpB?=
 =?utf-8?B?dWEvUVdWUHNwOFJCY0ZIbFNWbGJvcDBrQm9iNmpWaTRzbTIzRG9ZYUhVbUR3?=
 =?utf-8?B?Wk8zMzVRcDJoYnYxWHN1T1A0U2FsQ1REbUZQVEJKdkk1bzlDRkdFMkwrSS9M?=
 =?utf-8?B?OVVBeDNLZm1EMnVXRCtqODZkeHowTkZFWi9icmJoYWQ3NkJDNW5ZYjUwM2I5?=
 =?utf-8?B?OHdQbThTOVRYV1AzQWVWL0l3blhDNmczeUhZcUU5UmlBQXowUlBhWEVYU1ox?=
 =?utf-8?B?ajNFWUhSSXRndnNKejNJVnplbEtjRXdFWW5kOWpTR1ZsRjhrZExiK0tYOXZu?=
 =?utf-8?B?c1p4RTZUNHozTHk2eVRHYllmS3hzdmZRRGtpWG9MNm9lMFRwUW5tVklkYjgx?=
 =?utf-8?B?Rm5CMHV0Wnp5V2hacXNtVHNvWEpkZnR5alRkK1VacHRDc0xveE1IUzQydUI0?=
 =?utf-8?B?dFR0ZnVpLzM2UnU0c1ZqZkdYRVA1d2xwQmhXY1hLM05Yb1MyejhQdVNxeXB4?=
 =?utf-8?B?dzVpdERkZ3d1M2d3V1hIMTRhM0RFaytyenlMNExvbmgwbU9ienp6Q0lKZ1p1?=
 =?utf-8?B?UmtTUmVRZWlTOEtBbDFJcno0NjR3anRJN0ZKeW5ROGc4d0plQjhNZis4ZThz?=
 =?utf-8?B?SUJkVC9KV0tyLzlVbDh4bHVvN1BiNlZScnlUS0NDRmozMURmUGgrUTdEQ1o5?=
 =?utf-8?Q?1u+LIFcIR60=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR11MB7198.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cXJ4Z001OUJrOXN6clJsK2psWS9xSm9ibHFud01IRU5WaTdvMXd2QmhyVUI3?=
 =?utf-8?B?MGp4S25aNEdkNVREZTczS3JFbkhVZ3EvN0NDSDZvWEVmUWVSK1BYNGJZUXR5?=
 =?utf-8?B?eE1Ib1IvdmxWdENyT21pcy9rbDNYVWNNcXBITUg2bFVUb0J4V1NTMlM1WG1U?=
 =?utf-8?B?VXg2bGFWbWQvWXNONkY3UzhCb2ZmbEVRQ3VxeVNxY1JZbUlNMzNDN1FjZGFT?=
 =?utf-8?B?c0VnR2psbUpFWERhWFpPMjlMNHp0U2w1ejNaL3ljb05SaGRLWTg0R3Z6d3Z3?=
 =?utf-8?B?S1NjTDdraytydW1uNzVyQ3RkSDBHb25vL2NpYk1yNnlLZjZua09kbGtkVjM4?=
 =?utf-8?B?ZUl2bUM4eUJnb3U3M3dJNUFIbys5TWJpRGFmQkdXNUd6NkdHODVXVEF0bzRO?=
 =?utf-8?B?S1RjOWNycm5MMCtHMW5LRlc1TDYwZDByOUIwdm9tRjhqNzg0eWZlNEVkTjRG?=
 =?utf-8?B?eXVzazZnWHNNaDFueFJGS3FpVnJTWUdod2lEZ3pmNUg4WUNCb2lVTDJFdEVs?=
 =?utf-8?B?eXBHejRpc21TRDh1Um1OUzRPQ1JoaDlhaTJuZEJnbTBxYldzNTVCeXNLdVpz?=
 =?utf-8?B?VWdadzdYUnhUR0NUMEJPNUxMTGxZTmNqeG9LMjI2VHFIM0NkNXMwMm0vd2Jm?=
 =?utf-8?B?N0lodGRuQmpyMzJMYXdzNWpnRVl3YjR0LzlnU2lNN2dGZVd2MVVJa1BqdkdL?=
 =?utf-8?B?MGljd3FPVnFLMExnMWdWY0oxaFpMdzAyWFNKNlBXSjlsUmo5QWYwc09seXZI?=
 =?utf-8?B?emVPTCs3cXNnS0ptWGRpMW84Q2tYM3p6VEM2TDU4dGdhRXNaT25yVDlnWU1l?=
 =?utf-8?B?RmVZbFFLd2UxNmJmellZWDYyUU40dVZtRkRsaXAwSEpnaFNndHNjalBENFgw?=
 =?utf-8?B?WGVJSGhoQTkyelV5c3NCSXAyajEwTnpBcVJsVVNLWXVuTHo1Ujk1ZjBZeWJO?=
 =?utf-8?B?Nm5Sb2dpTVhCNmdQZkk3YmJrTXNCR1kyL1l1SE5zSkRobkpLYW5oSmRSOUtH?=
 =?utf-8?B?NnJvUTE4ZGVHZGRRQzdPeWFhVFpHS1Y1ZGR3blRmYTNnUE45WlIyNDdkVkpu?=
 =?utf-8?B?bjdSTHc1UUVRZytFNkZESU5vSVJGbHNrUm5FbnQ5ZmFYeG02MUVseitGVWZl?=
 =?utf-8?B?Z0ZQNkUzLzFCWkRjVFdWMXJET0x1R0IyTnl5Q1RoeW5VMUJoanZ3SWdoYjIz?=
 =?utf-8?B?d0tUYnBsY1FXSXVIeThuVmJTbVFremJRVHdjTFFzYS96bDVHR1B3azc3dWh3?=
 =?utf-8?B?d2VLdmd3aVFCZlE1bXlzSjNuZHRmNElBL3pRdTh6cVE1TGdJUWFJMzVubi9J?=
 =?utf-8?B?UUtDOW9MaUJLdHRsSGdCMnViNk10MFcrb0Jad2tpb1NIOCtITXM5VHZTUFpZ?=
 =?utf-8?B?RTBlbjBQVlBudVh0anpHZUVzRTIrbzBxaXpVQ01uelFyeTk1ek9OWFEyaUc1?=
 =?utf-8?B?U0tWUlJmMFRaM3RhK294eXZBNEFXa1l4MEZaMmF2eTZJVEpUU1NZVmJ2TkV0?=
 =?utf-8?B?TGRpVmp2UDZOaEs2RXU5RlRBNUVIMHRTQ0hQenlhYmllOThvUHh3N0RrU3h5?=
 =?utf-8?B?ZE94aGkvcXVKTU9PNDl2dko5T0c2UHlyaG9MYlM2b0lHK0lIN1l5WDJHa0tE?=
 =?utf-8?B?QmdocWJaQVpKVGx1V25oWnpyZ1RsT3I4NEQ3Q2s3cG1QQVF0S1NBbjNFckdG?=
 =?utf-8?B?L2dGT2owOFd5UFNVTjlvaDN6dVQwWkJUdGFvRUpiaEMxTXpxVm5DanNkS3dO?=
 =?utf-8?B?M1Jldi9wUXJlblI1U0g1V0t0Rm9mZmdWeFJ4MjM3RXlHenlLUnZ6eTZnaEln?=
 =?utf-8?B?ZGlXWitpSm4zN2Z5aXJmQmllNWJMN1daQkM5cWx5czdpeGZqSlZlbEhIWU5z?=
 =?utf-8?B?OENra0lsalZ4Z3RvNG1TeTBWbUNKUXdRZmw1RWxja2VjL0NlOTRGZGlZQmw3?=
 =?utf-8?B?VWhjdTJBZEhkd0QvaGsvSXpkZkFKeTY0dGlLQ3hnbEpJQ285MGhVKysyZjBZ?=
 =?utf-8?B?TU1WYmxISWJjZEJ2bGZtb2VMZ0JxdGk0OUJJcUc1VDB0UTNCbHZ4dWNPSHph?=
 =?utf-8?B?bE1oZ0MydEdTdFVidjlOdmlYYXdtdnloU2dVaW9UN2g4UGw0R2lmTUQwdzBP?=
 =?utf-8?B?RDJDc2g1OEh6T1hiTnNuTHRqZzN2UHpOd0FGMURZaEVaSW1DRk13dEcvanhB?=
 =?utf-8?B?WGc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a2a030f-da51-42f7-fd75-08ddf02c370c
X-MS-Exchange-CrossTenant-AuthSource: IA1PR11MB7198.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2025 05:38:05.2284
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YzS4BLS9fHMsIxPmpPmgXVNP2RM0I+a8GDtZJct8YIV0Yrt3IywhOHQAdMmlL5tE617KpAeV0imHoO9XQh8FRQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB8222
X-OriginatorOrg: intel.com

On 09/09/2025 21:28, Xin Li (Intel) wrote:
> +/*
> + * Executed during the CPU startup phase to execute VMXON to enable VMX. This
> + * ensures that KVM, often loaded as a kernel module, no longer needs to worry
> + * about whether or not VMXON has been executed on a CPU (e.g., CPU offline
> + * events or system reboots while KVM is loading).
> + *
> + * VMXON is not expected to fault, but fault handling is kept as a precaution
> + * against any unexpected code paths that might trigger it and can be removed
> + * later if unnecessary.
> + */
> +void cpu_enable_virtualization(void)
> +{
> +	u64 vmxon_pointer = __pa(this_cpu_ptr(&vmxon_vmcs));
> +	int cpu = raw_smp_processor_id();
> +	u64 basic_msr;
> +
> +	if (!is_vmx_supported())
> +		return;
> +
> +	if (cr4_read_shadow() & X86_CR4_VMXE) {
> +		pr_err("VMX already enabled on CPU%d\n", cpu);
> +		return;
> +	}
> +
> +	memset(this_cpu_ptr(&vmxon_vmcs), 0, PAGE_SIZE);
> +
> +	/*
> +	 * Even though not explicitly documented by TLFS, VMXArea passed as
> +	 * VMXON argument should still be marked with revision_id reported by
> +	 * physical CPU.
> +	 */
> +	rdmsrq(MSR_IA32_VMX_BASIC, basic_msr);
> +	this_cpu_ptr(&vmxon_vmcs)->hdr.revision_id = vmx_basic_vmcs_revision_id(basic_msr);
> +
> +	intel_pt_handle_vmx(1);

intel_pt_handle_vmx() depends on pt_pmu.vmx which is not initialized
until arch_initcall(pt_init), but it looks like cpu_enable_virtualization()
is called earlier than that.

Also note, intel_pt_handle_vmx() exists because Intel PT and
VMX operation are not allowed together if MSR_IA32_VMX_MISC[14] == 0.
That only affects BDW AFAIK.

And note, moving intel_pt_handle_vmx() back to vmx_enable_virtualization_cpu()
does not look right.  It seems to belong with VMXON, refer SDM:

APPENDIX A VMX CAPABILITY REPORTING FACILITY
A.6 MISCELLANEOUS DATA
If bit 14 is read as 1, Intel® Processor Trace (Intel PT) can be used in VMX operation. If the processor supports
Intel PT but does not allow it to be used in VMX operation, execution of VMXON clears IA32_RTIT_CTL.TraceEn
(see “VMXON—Enter VMX Operation” in Chapter 32); any attempt to write IA32_RTIT_CTL while in VMX
operation (including VMX root operation) causes a general-protection exception.


