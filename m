Return-Path: <kvm+bounces-40563-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B57C6A58B9F
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 06:21:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 78CF63ABF8A
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 05:21:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A77311C5D6A;
	Mon, 10 Mar 2025 05:21:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ObueqMoV"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC68414F9E2;
	Mon, 10 Mar 2025 05:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741584070; cv=fail; b=pQAaDtCI3SIPpUPHnELyw8XdIhde6s32kEqAp1Br8qavgzW0O6Q/TfqC10CuV9xR3g2vBbGQaSMD3rtl/Eycm/00a9oDKsFMUJr1mYr1c6vHkir/dCGjl46coTWjAECMc5r11/v6o4BrKfCtCPlCoGFc1Cg1GknMqQZDnjKXpiM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741584070; c=relaxed/simple;
	bh=CE4zcsyuSW/3lbojDnh482XC6XKNCLjfj9PUdEWOrmw=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=JpD/d+UM5D+HpK/xJtbrnRxiV86JnTuZWuzwFGD/1vZB1YkrGFIEvKIhb64mbM+eX4TbfCJ6s7mj9BrJOuWFhciPzFML5YE2OJed4klC5lrK796bsnt1eivcjOzfqDegcsSxn1zrWE98z4lUylbsFXO9EONHf2RvNVcD9GSiDrY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ObueqMoV; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741584068; x=1773120068;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=CE4zcsyuSW/3lbojDnh482XC6XKNCLjfj9PUdEWOrmw=;
  b=ObueqMoV3l7zCVTJedmpKqQ/J5oBHgwbz7N4UTSEh3hptSLG/K4ph8XJ
   rji8PCNDEIeH25m5ov+uEsJ2wcKS83DcHVlccB10ZUCB4vRIABmvphO+P
   cnCpvRlnNjfFsVd7dA20AmTcH9c2jiju6izSEuEuP19sKN8GohIcDzP3g
   gPpPQrcup80mTe5qO6gFMO4SJ1XL7x57Hk9uppLgT1zxSTnWhadL57BMO
   PENBTir8nC0IwGEXUJRdWgFRuJV0PuG0uimd50wpgY/s5wgfAkVEBq0NS
   /B1e8aB89rYYWkVNTdZ+Q9MgplWypWiJGxj3NeMZabpLE6i1zQQheLedT
   g==;
X-CSE-ConnectionGUID: 1py3V+VKTE29QWR2PHo2+Q==
X-CSE-MsgGUID: fuqrdv/MRL2XF6tFv4KeqA==
X-IronPort-AV: E=McAfee;i="6700,10204,11368"; a="46210108"
X-IronPort-AV: E=Sophos;i="6.14,235,1736841600"; 
   d="scan'208";a="46210108"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2025 22:21:08 -0700
X-CSE-ConnectionGUID: zhJyz6ZxRsKksRvjkxanYA==
X-CSE-MsgGUID: /txzeiD+SBm/8jwvzO4gjQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,235,1736841600"; 
   d="scan'208";a="119603297"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa009.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 09 Mar 2025 22:21:08 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Sun, 9 Mar 2025 22:21:07 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Sun, 9 Mar 2025 22:21:07 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.173)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Sun, 9 Mar 2025 22:21:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WMHtyQQAV3cpwFbH1Y4db231xAUussn1Rkq9rwh5VQopMmDRKV0Xxm+G+leTH+J2k3ve8GDhUofwXk5rx5SN7lP/P9U6LJBpNwjkq3cqEJtXoSs85Yw6VrPCOywJiAFE88R6srJX3uUdMoF3rMRpUWyGl9p7TNC3P2055n/3UlMZ5moMe1QDtgqzGmCZCWOjvozjBrXnv66hQHGvkZ7hP5KS/ATPB5WcgUDK1iGQrC0xC/5RrnttDEQlqszvxQenmmbSA1Xw1LvdPRyQmvku9bMBBUpDOSS6KEX15dne7al+9P8se0GjImis8Uw+rTZToNlPH84dj8Iqs8Sp4r4l2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HgB6opzHB68zLfRSFu1vvbg4hILzWFkjKsYEjM5cPdg=;
 b=W2HgL1ixAHI++vC16U8yTuDLFalFNYUXG7epqr9CMVlpXnSzD+VJb/sY/bP8ry9Ii+bPH6V9TqYGO9OkO2eAs8HNuQtJqkj5dLVLotZRSXnT90noW4WJHlwXIjJ7Jbx98Ob4OyaGdWyvFsxBZFJtzgwSGSoNHr1r3QZ/5EmsrEpXqkjzffx3mF6TYEXmtyfSVwPzowDI0qqnBTvYbfw1faCLOvxrmEy7Si8dScR1dkIQzfoXdzTdRiEJz+WbRmF0iTODZsLAq6aZaOAyQI05TGGUu1yzfmwCX8d2vSWDT/7KTP0ogEcUxZDplBHBSEfe9ou5hMDI7ji85wE8of9SPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7925.namprd11.prod.outlook.com (2603:10b6:8:f8::18) by
 IA1PR11MB6220.namprd11.prod.outlook.com (2603:10b6:208:3e8::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.26; Mon, 10 Mar
 2025 05:20:49 +0000
Received: from DS0PR11MB7925.namprd11.prod.outlook.com
 ([fe80::b1ef:c95b:554d:19c9]) by DS0PR11MB7925.namprd11.prod.outlook.com
 ([fe80::b1ef:c95b:554d:19c9%6]) with mapi id 15.20.8511.025; Mon, 10 Mar 2025
 05:20:49 +0000
Message-ID: <7bee70fd-b2b9-4466-a694-4bf3486b19c7@intel.com>
Date: Sun, 9 Mar 2025 22:20:47 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 09/10] x86/fpu/xstate: Introduce
 XFEATURE_MASK_KERNEL_DYNAMIC xfeature set
To: Chao Gao <chao.gao@intel.com>
CC: <tglx@linutronix.de>, <dave.hansen@intel.com>, <x86@kernel.org>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>, <peterz@infradead.org>, <rick.p.edgecombe@intel.com>,
	<weijiang.yang@intel.com>, <john.allen@amd.com>, <bp@alien8.de>
References: <20250307164123.1613414-1-chao.gao@intel.com>
 <20250307164123.1613414-10-chao.gao@intel.com>
 <e15d1074-d5ec-431d-86e5-a58bc6297df8@intel.com> <Z85hPxSAYAAmv16p@intel.com>
Content-Language: en-US
From: "Chang S. Bae" <chang.seok.bae@intel.com>
In-Reply-To: <Z85hPxSAYAAmv16p@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0284.namprd03.prod.outlook.com
 (2603:10b6:a03:39e::19) To DS0PR11MB7925.namprd11.prod.outlook.com
 (2603:10b6:8:f8::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7925:EE_|IA1PR11MB6220:EE_
X-MS-Office365-Filtering-Correlation-Id: ef4a8944-c174-400f-977d-08dd5f9351e7
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?bmdTdmw4WStKVTJ3U0d0bWtwemFVcW1RRkcxclZNalQzVGtPamR4REh3b3FD?=
 =?utf-8?B?MDc1SVhmdm02MWFrUWhEMWlaemZQeTBPaWdsMU1HOWF5dU5SaWxhUHovMjFJ?=
 =?utf-8?B?bWpUVW1WWFhqNWUwTGhFT0RJVUxYQzlacHpnMnAxN0R3am94TS9xZ2VUZy9n?=
 =?utf-8?B?emVGTWVXemFyRTMyL2c5NEYyRjRXYWdvTDlZU1VBYzZPS3lMeXF5b29Hajhk?=
 =?utf-8?B?NzR3K3FpSi9TSGFGV3NYWmlVak1PSmpQME41R1dBbkZjM0VjaW9lZE1JYklP?=
 =?utf-8?B?WG5mQjgzMnhmWkxKazAydWlTMk52eXh0M2FwZG1GdVBoaXpVb2NpbFgxTDk4?=
 =?utf-8?B?MmFUUmNZMUdNQ3lBSjBOWDUxTDlNRG0wdS9uMWRab3k3ODhJT3RUdktBSXNU?=
 =?utf-8?B?cDIyOWxiWFFETEU4T2Jna2VsbmJYQUU3ZWg4YzdLcUwxV3Blc1dsRFZzVGI3?=
 =?utf-8?B?SnBUellXYmhnc24zZ1BkZ2cxQkdhdlFleXphcmZUa0hkdTlCZjJDSGQrVFF0?=
 =?utf-8?B?aERNd3dnYUJab2Z3akYzV0pqdnJCVGhkMWF3Z3FGT05nOTI3WEJZc042V0cx?=
 =?utf-8?B?YUx5UnRoaitCYWp3V2ZHQlAyQ2hDUG9DMlk3QVB3NmJHenpkM2gyelVScFdt?=
 =?utf-8?B?a2pEdFZUUExQRTdDaFZ5TGNtTWtKY0lWL1gzeVJ3MzR2RnJ3RnJQMnpyQXJP?=
 =?utf-8?B?SEdWLytlRU5TVFc4dm8rNlIyelNIQzNjbUJsVHJVcGRNdklEOHJBK045Z2d6?=
 =?utf-8?B?ekYzWlpmbU1ma1A1Q0w5Y2FES0NRbTdjWmZqbWMyUTB2bEc5Zm1JaldrQk9u?=
 =?utf-8?B?VU5KUE56RERTV0VlMU9RQjRtekNJcWF0NHNPUFY1QzdpTjZaSlhNU0Q0R3NK?=
 =?utf-8?B?UnhVWTczT0tXUDExNEhYNjBTdmdVa1pRblNOME1mR1U0NFlseWhZM2RDOSti?=
 =?utf-8?B?cXlJLzNmZ3VVN2ZIMGh4OWppRHNRWExPNzdFYmx5bkNrbGJzcmVYcUNSYlBH?=
 =?utf-8?B?STVSNTI0VWt0enlZSGxoRlJQRDVvQzdCeWlrQXpPSTlxUm1Zd0JLaDRvR0Vu?=
 =?utf-8?B?VnlrZ1gwT2tlT2NJdnlBamVxQm1pZFpoekIzckVqNXh4VjJlQ0cwSFV3RTl0?=
 =?utf-8?B?cG9XWUM4MEdqNllwbzRZMFJVQXJjQVBSb0p6Z1Bscm5KOXE4QkxtY0VYWVVt?=
 =?utf-8?B?SXJvbDVRZHlQMWdZQmttRnZBL1VnUXRsck92emVNOVloeHc1R1FXekh1UnZM?=
 =?utf-8?B?aGU0ajk3V0R4TmI2VEVJZWlnZkVtM0ducUV5Y1FUaXAwQW9MeC9OOVlUKy8x?=
 =?utf-8?B?aXppOUNjWkwrVU5OS2hLY3JjL3Rxc0NPRDk0bVZKS0hXN1Y4TWlvanpmUDdH?=
 =?utf-8?B?WlliNEh5SVhmbjZ0Vnpwakp0NVJyNWlkMVR2RGxnZEcvQ3FYcXZGd2VhTzNl?=
 =?utf-8?B?T3EzejA4YzViMGZmVEtFU0hORUNUMGFwQ2d4Nlp3azlkTmozZW5lUnMvTlJx?=
 =?utf-8?B?eFd0aVIvbTlDRCtqSCtKRHBpeHhmaDlvQnFtQ1V5TUpNQUc0M3NQN3k2clBv?=
 =?utf-8?B?dkJmRTJaQldLRktRaDhYVVNNNTdoRXBjSWM0SnN4M09WNm41eXRtS1QwWnFl?=
 =?utf-8?B?NXA1V2pyaExYQkEzNXdwWTRFNmRVRGswaS9hMHU5T1ZzMVlMeTF5a2RhQnBM?=
 =?utf-8?B?Vm95Q2ZsUzBKV3lQSXFaSnIrWTdnSC90RnRTb1loVjk3d0xTekc2ZUtjVys3?=
 =?utf-8?B?amZLUFF6Tm5jQjFTNEk3Ry9EUCt4S0hXOEdkM2RUa2VDVDFOSVErMHJrY1E4?=
 =?utf-8?B?TERFYmNhTnIwUmZGdEh3SjlhK0o5VTVLNlBpVFA3T01vQjYxNlZoRGpsa3Bo?=
 =?utf-8?Q?hNG4uj9kmXtlT?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7925.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?T1ZUZDk2TDNBVHlWNEMrNjRjSTdwejU4MnlOamZHQzdwWXYrUW5hQnE2Mmhu?=
 =?utf-8?B?QitwWW8yY2xlTHV2Nk5OUHVmWXVnOGw3QW10aTZpTmxzRUVoWFJnRGJ0b1Fx?=
 =?utf-8?B?Y0MveVZmM2xxRm1XQ0VHYTNoUmNlOU1GTnpWaitDcFI4RnFpOHNTbDdBVU4x?=
 =?utf-8?B?U3BoMHVLZnJGTERWRk8yNUpBd2NhNXJZZ2lLNm5uUVYvUUllZkdaVVNPUTlU?=
 =?utf-8?B?Qzc1ZkxCSml3K2R5aWdNSWRuWEhuYlFtSlBKNG82QytITDZBb0lkM0hCMjlU?=
 =?utf-8?B?azlXdG9tQlBDbElDUXIvWWZXbnhhckpaR0s0eHRjU0VHblJSSVE1K1pHRm9N?=
 =?utf-8?B?bG9wSm44Ym9HbzdtRURVV1VTRGxETDhhaS9DOGtGaEpIYWw1STZXY2hhOWRN?=
 =?utf-8?B?RnNEWExCaFpIdytaUnd5MHJrZHI5cjFXdXErbjdCNERQN1hmVmtnMHpqYmoz?=
 =?utf-8?B?U0EvWG14Zy9pclJoKzhFdkNDT2oxbWI0K3Y1VzhVTnRsUm5pWE5XQ0JEbU9L?=
 =?utf-8?B?YmRjYmFhV1BzOWdMUVZ5Y2g5OXVkUSt2SDNrKzNCK3ByOUk2R0JxaS8wNVJp?=
 =?utf-8?B?ZWVLa2JPbldVWWRqdXBIcUhvSG9KTC9Pd3h3aWdvRlU2MTNWSWpYbHZpRUNQ?=
 =?utf-8?B?aUxyanA5T2ZORDcvcXhvQ0ZwKzZlSW5lM3FQTWhqeU5kZm1EK3BQWkNXbnZZ?=
 =?utf-8?B?MnRhZzdoRlpYUHA2L3krbTBLTFR3VnFNSDJsd25zbDBUVWdTbWNaNVNlT25n?=
 =?utf-8?B?djNGUXdxUDNHeFF4bWkwK3NqbktIVDFNVkhwcVRXU0ZXeFdFTVJhWEx1Y3lV?=
 =?utf-8?B?WmRhK1hJNis3RUxJRmNRaHplb0RJTVRLT2VaOEpJbmprTHZpd2JiWnRmK3Z5?=
 =?utf-8?B?L3dlQzNveDArTUgvL0JJbUVlZUR1Z0RSR0ZzN1F4N3paMURGbEdYajNFSGIy?=
 =?utf-8?B?d0hxdGpScms2V2krN1J6YW9taEpaVU9Qa3VmYXhnSFQ5N2U3dVAvSTJyNDgw?=
 =?utf-8?B?RWZJcllNd3ZidU93ZFJRZkdSWU4wMXpKL01DZ2NnMm1Fd2lRV3hGQTJFQ3JF?=
 =?utf-8?B?MnZhOVJpeUNqNUxjWk5wSGsxWlMxNGlCdXZ3Y3RxMVh2c29kK2NmMjZ3THAv?=
 =?utf-8?B?OFZQZUdKbXBvQ2d6NnN2dEFMNmF0eXVYZytldmNoTTZWMUNlV3VHSFM5UmJC?=
 =?utf-8?B?U3QzWlJlQ0RyTFBXOE5XY2lGYVFVYTZ1MHF6a1NOY3NXUm1EQ2dqWU1VT3BG?=
 =?utf-8?B?SWxndEoveU9Kd3l4cnlLMTB3NlBxc0lvM0ZvUk5SNEtSQitJczBrSllQYlBL?=
 =?utf-8?B?SHRIMFdXb2dYOERWY0pKQk1PekFycjRGRktUOUxMNkFkUVN6MmQ4Y1Nuc2x4?=
 =?utf-8?B?YkhVbW1uSURTdzloNUlTZTFUakZBRllJeVc1cUE2VTBsNTF3NFd6dURFVGZN?=
 =?utf-8?B?Ynp3dWxMcmZMYVptbXZweVBZT245MUU5SmZ4TzljN2M1WVBoci9oVDlZdm4z?=
 =?utf-8?B?NHdmN1g3d2F5SWZsanh2QmprUTlCSWE2OXg0WTNzZ1FoaEpEblZDRlNXd2xI?=
 =?utf-8?B?cWZBWUs5RDBXbnRJaWUwMWsxV1VvaEtXU2gvc3RFUDlodEhZKzZiMElkc0w5?=
 =?utf-8?B?ekU1N3JZcmpQV1VYTFNpUURlcmZqR3hrMkJOVXRicVlDMVBjVVZXQk5pem5U?=
 =?utf-8?B?UHdVN2M1VHF4WW9vdVptWXZPdUJjMjNxamxGRTRyYzZkbWkxUjNKUnY1REd4?=
 =?utf-8?B?U2JPNjdveXdleXZWTUJuVDVBTURoTmp5QUt4V0ZrM3VTQzZuTGpNSFluMjND?=
 =?utf-8?B?VDJDVk5IQXdvMDZJaC9vbTVPUkhkeG1RT2NzNGNZcHU1Unp6R0Y4ckpXcGhG?=
 =?utf-8?B?QndPMEVOU3IvbUtMeTVjNlJkWHVWM0RVa1pyakZ2ZXJDT1ZYTlIvQ3hJbEpO?=
 =?utf-8?B?U3hKNnpYcTR4eUdYREw4dVVNRWZuTk9oTHg2MUhacVVOZUgwR0ZGbGlpZTF2?=
 =?utf-8?B?WFdiY0k5UnZuQzRtRnptbHhWWWlFclVHQVNoTFlpZDRpbFBZUmxyNXV0MEFp?=
 =?utf-8?B?azZpbFNaZTJXdlpqbThXa1MzcjlSdS9QMXFrZEpQeE8vaUZiVzg3NzlFdlVL?=
 =?utf-8?B?VU9Db014MDJHcGRDbHdiRTNQekpIY0ZYM09zY3o5YzdVY0tQT1JtSnpQdHNI?=
 =?utf-8?B?OHc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ef4a8944-c174-400f-977d-08dd5f9351e7
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7925.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2025 05:20:49.7633
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BEimUPPG9IWvqD2RbipPy2+BgO8m7OCmxv3LNydtzw+bNOGqrEMudMs4KDGfvxcoaxf0LJdFFC4jw0dDzTpF/ZkVRxehh53x/3aiiyGuKVg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6220
X-OriginatorOrg: intel.com

On 3/9/2025 8:49 PM, Chao Gao wrote:
> 
> It was suggested by Sean [1].
...
 > [1]: https://lore.kernel.org/kvm/ZTf5wPKXuHBQk0AN@google.com/

But, you're defining a kernel "dynamic" feature while introducing a
"guest-only" xfeature concept. Both seem to be mixed together with this
patch. Why not call it as a guest-only feature? That's what Sean was
suggesting, no?

"I would much prefer to avoid the whole "dynamic" thing and instead make 
CET explicitly guest-only.  E.g. fpu_kernel_guest_only_xfeatures?  Or 
even better if it doesn't cause weirdness elsewhere, a dedicated 
fpu_guest_cfg.  For me at least, a fpu_guest_cfg would make it easier to 
understand what all is going on."

Thanks,
Chang

