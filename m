Return-Path: <kvm+bounces-51704-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 77A04AFBC98
	for <lists+kvm@lfdr.de>; Mon,  7 Jul 2025 22:33:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AEA5D3BF6BE
	for <lists+kvm@lfdr.de>; Mon,  7 Jul 2025 20:33:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2EF6B221554;
	Mon,  7 Jul 2025 20:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lRQ9Wapz"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D768D12FF69;
	Mon,  7 Jul 2025 20:33:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751920406; cv=fail; b=C+vFFCQaIDa1Bwbh5lnFeuDzEbVt2ePtRRN1fPdR8ETvIq5WZlfeFZDKyUcqfJBMv0ZDh7zUovYBhryY/WlFpaK2pB1AaB1Dmg3rtblCQdJYjbNUTOmieR2Yu7GY/zUEc05YaDIwKop/FwGBuyYQzx0pZuCVjGlAd+vtWT9O7RQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751920406; c=relaxed/simple;
	bh=VCt1+S7H/EMGoCeJnYLyOi5LibUNWx4ZgdijGxgafTc=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=q9x/YKpDC0uZhXaswLrqpCPvWRZ1ty0gB3wZCStXQ6nIA3CHuDM+aAmDnA88k56NysNFrQbswABwm9QfZsTEmMYPbgsj8uLks+Y8LeMKng+wM6lHktgySaIJCmhyGDc3IiXhACfYKIhROlUrJE5Eglj7AvsxFCd+032HIRTCWWU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lRQ9Wapz; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751920405; x=1783456405;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=VCt1+S7H/EMGoCeJnYLyOi5LibUNWx4ZgdijGxgafTc=;
  b=lRQ9Wapz2uCtr975sRsm8l2PNv27SBDRNO6cOeuXCur/SC6JD0CKeGbg
   xd9jYYsW6RuAQa/ssnGWckviU24HONYQpsJixMdqBIHtYERH2psv0ktxw
   Mog0rFjrx6POtWZdwROrQhJqxRlZFP0qtyKikzhbKk2/xQdHgkgWygUq4
   5rlQwRk8fe46fsdLok9p9RVn1vGoVe5WiJVdT71H4RP22jMT6TSpPWRZc
   2pMHJDdc0h2IPfHLIsetMtOuUEk7hmjHuDdZFHlg6RFEe9z2gtM1BE+a0
   jU5EhbxJ8w/aUUNr7bdvrH2vzDXbc17NOJAdRvU/E8SlM1nGnldhdZ2r4
   Q==;
X-CSE-ConnectionGUID: czteHvLrQkmpc5SGBPsYQg==
X-CSE-MsgGUID: Bv707XxgR+eZE0tR5kugGw==
X-IronPort-AV: E=McAfee;i="6800,10657,11487"; a="76700880"
X-IronPort-AV: E=Sophos;i="6.16,295,1744095600"; 
   d="scan'208";a="76700880"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2025 13:33:25 -0700
X-CSE-ConnectionGUID: iwWq3R3XSEmR2jKoE9GGOw==
X-CSE-MsgGUID: p/VB0ZcHRWCzGgyucxjOmQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,295,1744095600"; 
   d="scan'208";a="155045928"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2025 13:33:24 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 7 Jul 2025 13:33:23 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Mon, 7 Jul 2025 13:33:23 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (40.107.102.56)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 7 Jul 2025 13:33:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KeHqWVdwZZW//vmkIxdAGTIE/IzqrfsNWtBHwnQJTnPYcPXmlSdJbkYyJ8lxK5+70Quyb3pqLULe0C4IiVkGaZhbmTC4ehZ05QLXHmYMSL0pG9RrehKavBWpIM1kC/j0ma4L7oCtfx8AjgE4o3ydIuS7/Xero4CGXkwqrR0ZyJSqZJOQK0wlRhbRgOWdFFLFNavob7UBZaIxhAMQNmagTtgQdpzwu6x0ljTPcYtB/GQk7xxsABRcu0mw/4PTO32XrI5NyBRwTepfCzBlqe+fVkcTdfb/O9UssgQi+zPxKkS6znsy9kvj/NOvUZIUTqxHjkVaCTMkoaVMcmmkNb7N+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y/r3yUegZRBFQZlsN4XMRiZatJpk9d2e0dzZFWQgYVA=;
 b=nSEweLMZTfWUhH9ozJpc3ZCH6NhsI2yDZfExGCnUWPdF6zpSnFL33Kdf0prZi832ThLvAWRRPVRcMeu0PR/+qKWniMfpHYVF0o6IIFB+cKYxvki7992k5YprBYQ5wMRfOnE1NUwBI2b6uoGXU9JBdVFtboMqQCf4krWjH1pyoYHyRVN2OJEFBV+L9dzwSe6M5VfUWQqibDNeQkfFG2oS8v4qB3+567jcg6m0/lltosqf8e0bNhSGtvUepBl0AgnqKV043yni9BVb1nMLqhUX8CFZfngJr9IInfUnJxwDz202FApNZoX3xhc1U9qIs7988TZim+mm6nbtIkuROuDiWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BYAPR11MB3320.namprd11.prod.outlook.com (2603:10b6:a03:18::25)
 by CO1PR11MB5058.namprd11.prod.outlook.com (2603:10b6:303:99::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.26; Mon, 7 Jul
 2025 20:33:21 +0000
Received: from BYAPR11MB3320.namprd11.prod.outlook.com
 ([fe80::e8c4:59e3:f1d5:af3b]) by BYAPR11MB3320.namprd11.prod.outlook.com
 ([fe80::e8c4:59e3:f1d5:af3b%7]) with mapi id 15.20.8901.024; Mon, 7 Jul 2025
 20:33:21 +0000
Message-ID: <ff11fc78-91ed-47ab-8c29-9ca45d163808@intel.com>
Date: Mon, 7 Jul 2025 13:33:19 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 00/10] x86: Add support for NMI-source reporting with
 FRED
Content-Language: en-US
To: "Zhuo, Qiuxu" <qiuxu.zhuo@intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Xin Li <xin@zytor.com>, "H . Peter Anvin" <hpa@zytor.com>, Andy Lutomirski
	<luto@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar
	<mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>, "Sean
 Christopherson" <seanjc@google.com>, "Hunter, Adrian"
	<adrian.hunter@intel.com>, Kan Liang <kan.liang@linux.intel.com>, "Luck,
 Tony" <tony.luck@intel.com>, "Zhang, Rui" <rui.zhang@intel.com>, "Steven
 Rostedt" <rostedt@goodmis.org>, "andrew.cooper3@citrix.com"
	<andrew.cooper3@citrix.com>, "Kirill A . Shutemov"
	<kirill.shutemov@linux.intel.com>, Jacob Pan <jacob.pan@linux.microsoft.com>,
	Andi Kleen <ak@linux.intel.com>, "Huang, Kai" <kai.huang@intel.com>,
	"Sandipan Das" <sandipan.das@amd.com>, "linux-perf-users@vger.kernel.org"
	<linux-perf-users@vger.kernel.org>, "linux-edac@vger.kernel.org"
	<linux-edac@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
	"linux-trace-kernel@vger.kernel.org" <linux-trace-kernel@vger.kernel.org>
References: <20250612214849.3950094-1-sohil.mehta@intel.com>
 <CY8PR11MB71342AE041733CA1E299901F894FA@CY8PR11MB7134.namprd11.prod.outlook.com>
From: Sohil Mehta <sohil.mehta@intel.com>
In-Reply-To: <CY8PR11MB71342AE041733CA1E299901F894FA@CY8PR11MB7134.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0020.namprd05.prod.outlook.com
 (2603:10b6:a03:33b::25) To BYAPR11MB3320.namprd11.prod.outlook.com
 (2603:10b6:a03:18::25)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR11MB3320:EE_|CO1PR11MB5058:EE_
X-MS-Office365-Filtering-Correlation-Id: 62ca33a0-588f-4213-5623-08ddbd9583c2
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?V0IzbWhiaGRkYzdzSXZ4L2l4Qm9oU2h0U2d3a2NoZkxVT0ZxalY0d3B2NnI2?=
 =?utf-8?B?V3YyOWRFVTZ6R0xmd0lCUDNRc0VNZU5NQXlxZmh0RmJvbjJsdDg0QW1lamhx?=
 =?utf-8?B?OGw5N3V6WThHSkIrU1BvRHdxZWVPRUd5ZkQzSXJia045bzFxWnVtVXFBbUI2?=
 =?utf-8?B?clhjS29HOGRQckt5bnZ5U1I0eE5lbXdaR24yOVRQQmE5M0hVZXF5MHQyenAz?=
 =?utf-8?B?SmpBc0tWNDdnT2hYV3I5Vy9MWG9qKzRya2J5aGNFOU1sTVRyZ241a01QTjda?=
 =?utf-8?B?WlNlelpVa2QwR0J4Ujk3Q0RrVmxMRFd2bWpJa2NPY0VHUG82UmFVUmIzT3di?=
 =?utf-8?B?a2NhYmNjMTZlckR6SklDSEJZeG1BalFQZE9la2VNMVVCVmFZdlM2RmdBeG55?=
 =?utf-8?B?YTMwZDlQTC9hclF3cXlGWjZVQkhoTzB5cE15QmJuQWJmTkNJUUJlQVhqenI4?=
 =?utf-8?B?ZmJMc2NIaVBqZmZ6ZXNmL2lzUEUzeisyTE1IT1lBcVh1WERLRzZ3Q3lyakpp?=
 =?utf-8?B?Q3dmSUg5N0pucVkraWdTcWdiVHBvYnpqSlNrODZTV1pyRDNrYmJjVEh2aWM3?=
 =?utf-8?B?cU1zRmdCMDAxNCs5MjhYYmVDWklJL2tNVHNHZzdzaDV0bUw5aUNGaUR4UEhn?=
 =?utf-8?B?eTJHZnNEejBlRi9aUHNjeE4rT2dtdGFIVDRZbkU3MkJLdHF0cDU0dVN4NTZT?=
 =?utf-8?B?eFpYTVhpS3U1bWYzdlFweHBUNVhNb1UyVXo4aHpYSU5ld3l0dGF3ZHE3b0VI?=
 =?utf-8?B?UmVhemlVMlpTVlBMd2tZcVRCcHVOZzc0dkpKZjFMenVWbWliT1o4S0pqUGcx?=
 =?utf-8?B?Ky9XUDdrZ0Q0dXBKNWtJZVR6SzM0akFobndZTzZiY04vNnIydFdUZ1h3bDNq?=
 =?utf-8?B?clJzLy82Ky9kM3hxOUU2VEtvcDFEd01IcTZXUndXMWxmK0g5UFo4RGVjRE9D?=
 =?utf-8?B?a2FGeWEyZ1dKLzRaNElzY0pzL0pic0FLSG1ZS0VtSDJZQ0k3UjBYbVhWNDFn?=
 =?utf-8?B?TVgwTkIyWXNkRGVHRytvaHBHOUxzSzV4ZFBkMGJqcitiSVBiTGZyYTd6NWdT?=
 =?utf-8?B?bUNmeW11NTJ1YnpJOG1hSUpWK1pOV3k1YlkvRmgyYm9uaXpVejh1UjdYcnYy?=
 =?utf-8?B?NnJnMXNqQkZqcmNOQlY2dVJVYWxOODV2VTRGNG14YUxmc0dwUXp6anVpaWdx?=
 =?utf-8?B?dGszT2pDWDA5UmovRUJPSnUvMkI3ZXorRFhwaCthM0t4akZUSlYwbzEvbjVJ?=
 =?utf-8?B?SUdBaitnbkRmeHpzMlk0TUJqQS9EaWtuOUpGQlgvRU1DS3ZxSTNnaHgzTjdu?=
 =?utf-8?B?NlB1Kzg3NlJIamt4TllacWorUHNRQnEzUUxGdUR1bXBPc3c5STNDRzE4WTBu?=
 =?utf-8?B?bm1NRWtTUyt0ZjJvQmZNM2FNZDZsdG1jQm8yZk5uOUxQSFFZZDhRaEZib1M3?=
 =?utf-8?B?TWhpTjFjOWFTUmJqQXI1MkN5bDU5OGI1SEY2b2tpOVRJQ3ZEMnFaOFl4UWx6?=
 =?utf-8?B?bTNBcjRyd0lUR1E0VTdEZkJUZDN4d2tWU2M0Q0FINmM3azNyV2c0UzBTYXRF?=
 =?utf-8?B?ZTNTL2hMZkdGMWwyaHJGNi8zUS9rczFXZTk1T3FTcGllRS8zbHJkT3F0WDU5?=
 =?utf-8?B?bFdJWE12YU5zS3FnOFN6MGljdC9Nci8vcVlsRXlpZWdWYUlpODNWVVJlZWhz?=
 =?utf-8?B?NjJrRXRaakdvTkxxUUZKYlFnUmlWQ2IwVWRaMGxwR3BnWHhvSHE4SHFoSWdj?=
 =?utf-8?B?N1JJdkxYM0ZTTEtCbnJCKzhURW42Z2lBUVVqSGp5akp1eW50VUdZdTM0YTY2?=
 =?utf-8?B?UkRPQy8xd3JtelFSY3NRRWFweGpDZzVFUTU2d0REMDBUbXU0ekdib0FmQ0lj?=
 =?utf-8?B?dWV4aTBrOGJlMUlzNnNxL0loZVBBMUdhKzNvOXl0RlZUMUF5Y1JUcW9MODZF?=
 =?utf-8?Q?gXiE5c8CGfw=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3320.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aGZCSEVDdHRVc2lXZ045bXoxRUdmcWtGZWlwQVVCQTRRWGx0anc2eUpqY0pF?=
 =?utf-8?B?RUZmRGV6RUhiZHRucGtmSWNYaFdmYmQ5TTNOcTNkd2RhNkJPeSs5UnhSaHVa?=
 =?utf-8?B?VDNhUlRUV3dnQzUyZ2ZqTzNjTk92cnA0YllCcnlEZWVGeE9vYUFjWlhjd0Rt?=
 =?utf-8?B?cnYvbUx4RHpHRVNWOEV6NkFHTmliOXg4cnZGRFIzL3lhT25EUFFuTEN0MjBn?=
 =?utf-8?B?SUlZbTdrd1JWOWpmQkMrUjBOZHlqbXJIRzR6cUw1aGNybU1PeVhzbm5Xbm9Y?=
 =?utf-8?B?MGJ4eldYazF3aERmcFhZK21hWGpMalBPUllRU3FOdk1haW5wQndPazVtelpD?=
 =?utf-8?B?Mzg1eForVXBEQlhPaUt6bzVnS1ptdlYyVjExV0dVTU5EYlhSZWxmK1kveUFJ?=
 =?utf-8?B?MExieVh5ak9NSDVmcWR5cURBUUVtMTlnNGxEM1ZJL0orZUUxVUxOdlQ3cnV6?=
 =?utf-8?B?NkJPQ0Q1d0xYRGNQeVo0d1Yrcy9Jbk1ldUhHaUlob1lJU2Vic0d2MC90V3Ja?=
 =?utf-8?B?N3RwWEhkZ0RBWEpIaXdmV0NBZVNRMlIxUWtqK1JjQm1XUm5WS2haclBxbEEy?=
 =?utf-8?B?Nmt3eURoQnhhVzFQK0FXY242VXkxZ2hiZ1VaejZ5c2FJaHZrcUZ1VTMrMXp3?=
 =?utf-8?B?cWRVZzNFV25LOXB5a0RHRlVobGJOS0svUFV1d1ZZdlg0SmFBWnQ4R3pTOHdS?=
 =?utf-8?B?Lyt1ampoblVpUmdBbDhuMlZySmxRcHlwcUJTUW9mbE1ISG4rSUxKU2l6TEUx?=
 =?utf-8?B?ZXBIUHJDdjN6ei9MZFptQU9Db1k5RTVYVGNuTThrYmZOSUZhbXgrTWpSTGN4?=
 =?utf-8?B?YmVBYmpiUW9uaXMzckRXTHZQenVxMUFPNWRnTUFyR3ZrWWpwTUpKWkFvQytZ?=
 =?utf-8?B?cTBPcUdBNXYreUhyL3F3VStDck9KdXdtN1ZlNlU1RVNlTWpMMHVxeUFmVkdm?=
 =?utf-8?B?MEZRUVFEVjZIL0xiNnJCZ2EwL1NwYS84VWtEZjBJZmpaaXMwdGUvR3BpTUQr?=
 =?utf-8?B?ZFhnR1BOMkN6ZUd3WVByOWdqV0JHcEtpeExTcUpLek9GWk5nS3l0VG1heDVM?=
 =?utf-8?B?OXAyRVpmR0JrMTlSR3htM1B3TldMTFB5Y3BwZWZucW5IQVEvUHhBOExZMS93?=
 =?utf-8?B?TG9wQ08yY1BvK1R1V2dlSDU4VEZBTFM3Z2lXZVVYc0RjV25WU3d6RzJXZFlS?=
 =?utf-8?B?MlZ3ZWlYcnRsSHNuakx0aXNSRTAwWUFWT3RuMEdrZHk0OTM0ZW02aXluN3Zh?=
 =?utf-8?B?S2FRTHRLWEw4dkRWLzFtd3JMM1RlVnJhblZ4R2ltQmRGaXIzVEpWMHp6Zk5D?=
 =?utf-8?B?QzBSRHo1c0tadXlnZll5YkIrbkNKT3ovMlRCNE5RUGVhSEVsb290V3k0MUNG?=
 =?utf-8?B?TDhsWnhhTXVGTndhUllqYllBb2tFbG12Y3VTbzlGRDFXZXNqK2RyWmYwL2dH?=
 =?utf-8?B?TzZ0aE1sV01tRFh3NTkwRVZpWWY1aXZSdjR5WnNQaWIrQVNOcndib1hIOE1k?=
 =?utf-8?B?Ry8rRHp1cGpaRU9jVkpGM0pKNlUyRHdSRktUbXJycElDTWFaVTJXWmYvdG9W?=
 =?utf-8?B?ZDhYN0I5Qml6L2lNbGQvWDVCZSttSUxmQm5vQXFGRytiWUxtcU5uV1FJN1ZV?=
 =?utf-8?B?aitra1c1aDFzeHVmQitOOWFxa01uU1g5VldOUTkyRWZxMzh0cGltWHIvVGdp?=
 =?utf-8?B?eHYzYmlsdW5XbStDMFJSUmQ1SHEwdERuRjd4V0ZXU2RkVnYyNXM0ellEWGxt?=
 =?utf-8?B?VzBrdVhQSzBKR0dlNUJtK3hYdnlGOGlNOHEwaWVYMFJUNkJFbk93bkdFR3VX?=
 =?utf-8?B?QTFOektCdE0rek5RbGVQQkNYdmQ0Y3kweEJ6WE5lZm15L1RKRVVuQXVhc0Ni?=
 =?utf-8?B?V2xqNjhQL3AvVHc3dVViNjNBV0Jkdm1DaWM4MzRGV3E4b3JxNDRLNEFZU3lm?=
 =?utf-8?B?c0lNV1dEQ25MZExkQStpWjZCbkcxTEtwaGFVdzFrVEFvSU9udi9laEMyUXI5?=
 =?utf-8?B?cUNsM2wybGkrNUFPQWVXZ21rejdLMWZVZlFaS0VhTVNYT0NXMzVwRjhsYnZu?=
 =?utf-8?B?QnJxSE1BU2tPSTFSdkhuZU9uYlRVd29UZEVMZnpuZE1MTXd6REJnWDhlZDZZ?=
 =?utf-8?Q?MBu42EsjimqHRPTl4E2YUE4h2?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 62ca33a0-588f-4213-5623-08ddbd9583c2
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3320.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2025 20:33:21.6098
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9ujDFt/+zvA8eY+yzROunGm7Lsd5J3fxpqEwvLRwR5Ry1O50dejGJLGUaya6wIEf1n3UVQWLjKvZEUwNfploHQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5058
X-OriginatorOrg: intel.com

On 7/7/2025 6:56 AM, Zhuo, Qiuxu wrote:
>> From: Sohil Mehta <sohil.mehta@intel.com>
>> [...]
>> Subject: [PATCH v7 00/10] x86: Add support for NMI-source reporting with
>> FRED
> 
> Aside from the comments for patches 5 & 6, the others LGTM.
> 
>      Reviewed-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>


Thank you! Appreciate the review.

