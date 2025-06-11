Return-Path: <kvm+bounces-49122-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2FFAAAD6170
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 23:35:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DB13C1E1638
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 21:35:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0A2B24502E;
	Wed, 11 Jun 2025 21:35:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LW4x+Wwq"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E897C380;
	Wed, 11 Jun 2025 21:34:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749677700; cv=fail; b=GOwdTpyzm9rvb6ywP4DWmXdC0SRabNo2WwQ2fX+MXPyoVnfGIJfiw6IvQHawg6QehmBWst74nTyGUkDIa/M/lNMheKJj4JWdJvJoTtAtRFgeRGkOu4qUTS2qf1up+Di0mzZ9QTaE/DD7xCqawD3UZ2efQiXcrrTL4nS9qXVd4Rs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749677700; c=relaxed/simple;
	bh=IN8/D3FC4wDSed760Z3hCjErOQ/PxYA2NEe8Wh3pICY=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=SCe+7Xq3yKW1JhgU7DYMlOb5BP+WCVtjNXSimmbCrsEScXoBLFTQ5HDGNR/E6IkKj93WwETApAPRxQfCBHyKyelC0GtGoz79Ia/JE0uvLMz6jlxG74Bds3ndslOtHOdFGhCClOhfgH/YlCa4ZaoEZJHwxFH9XE7QOnt431DULL8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LW4x+Wwq; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749677699; x=1781213699;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=IN8/D3FC4wDSed760Z3hCjErOQ/PxYA2NEe8Wh3pICY=;
  b=LW4x+WwqUPq3IbJ4i9z0Q8pDpnEo18bdsQcKabnc5cVy6qCEoRXm8TmU
   dPm/sh0AFpwq2wBMnXL9Em8lchBODm/n7bgimH+YUYNLlGY0Y9nVULnK4
   hxDCfGUx4y6dNP82eBihNOS8xbcmUWK+ojLgoQ3O3bewzGL/k99g62p1b
   LMqhu0T2BF7n6jHRAYkBi+QiRJn7DWCkZNq05ocCEdylBz3JgxEm7DLvd
   VAffiJDMcGPVsFIr2os+wfOXxsCNXX7J6qGCZQyzh/Qr8TI6qUq+1g7MJ
   I5qtEGNYlp4zcL2kbWL3jNUh4BPlupBW9Ru9LJhireCq6UsqHex9/fBS5
   Q==;
X-CSE-ConnectionGUID: RYFlG26GTMG0QPCQANxABg==
X-CSE-MsgGUID: 4URszZ7JRryN31P8CME+3w==
X-IronPort-AV: E=McAfee;i="6800,10657,11461"; a="50943045"
X-IronPort-AV: E=Sophos;i="6.16,229,1744095600"; 
   d="scan'208";a="50943045"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2025 14:34:58 -0700
X-CSE-ConnectionGUID: +sn37uMTRjyUN2vtgSUNjg==
X-CSE-MsgGUID: cRIL1joORjeO92yFAZ/g4A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,229,1744095600"; 
   d="scan'208";a="148228457"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2025 14:34:57 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 11 Jun 2025 14:34:56 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 11 Jun 2025 14:34:56 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (40.107.237.88)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 11 Jun 2025 14:34:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QDzjnS4/Ue+RovSv9xWceWMXIJBvSGrB3CC+e/yIYL7ZpoYKeF6/sJSYis3BsC3DBCXVS70HLkER7b9GpvlJSPGcRoykRVSbMtCh6DH+tBmxSXzdbH4ulUrOJk21IgJX8T4AMxH/7EXbYqt6EjGuxtJzaLrQRP+7fA15brxEMzFVWtAziCVZI+DUQWmYxJJeaby6R7/4CkZP/6GXJLZhC2rAhC+DkezzpgxJhu8YESG3G2gPdbnIMd5/jbv1woCRhvMrB3IZw6pYs3IuNqUoOZszIXyaj8LzbL1ungToWDbIdo3LP3Z18ZE7L8rIiohUus5T6asTkFHwRq4UYz6v+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BIFULUN7XMnE/tEQRH7eMNNaXMvAkQsCn2sLnacbMqs=;
 b=C7pC2447HJhZQv+rIGQ9MMtu8CRMO5oscMr0j8Kwg1eDN5pOJfJ00fVgT8sdAtichGlFB/HWrmM56PyIRAIW+cwnaaTZ7JmzZeZTxJZUDx7yfZ62qpPE84GzIktWM9+fSdXLn+2h7cM5R02IB6jf48RTizvA9ph0W2xsC2PYORsEBHrrNXvc1h8EvS7ZcB8u3ne1vkuiDJ3QQbfxX4gHVTPn36PCvs6jDOz8j4JMCGIf0iJ8rxjDdrMOF/gpQIiUVylzIkjYguCdR/wAeANfyzuprNGa7vvWyFlSP4hJd7S/wQ4g602VuROG5QShzeEkWiKdet9O266J0lYSdjePOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BYAPR11MB3320.namprd11.prod.outlook.com (2603:10b6:a03:18::25)
 by MW4PR11MB7056.namprd11.prod.outlook.com (2603:10b6:303:21a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.31; Wed, 11 Jun
 2025 21:34:53 +0000
Received: from BYAPR11MB3320.namprd11.prod.outlook.com
 ([fe80::e8c4:59e3:f1d5:af3b]) by BYAPR11MB3320.namprd11.prod.outlook.com
 ([fe80::e8c4:59e3:f1d5:af3b%4]) with mapi id 15.20.8813.024; Wed, 11 Jun 2025
 21:34:53 +0000
Message-ID: <707b643e-a740-49a4-a549-7d63c5f4da76@intel.com>
Date: Wed, 11 Jun 2025 14:34:51 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 4/9] x86/nmi: Assign and register NMI-source vectors
Content-Language: en-US
To: "H. Peter Anvin" <hpa@zytor.com>, Xin Li <xin@zytor.com>,
	<x86@kernel.org>, <linux-kernel@vger.kernel.org>
CC: Andy Lutomirski <luto@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>, "Sean
 Christopherson" <seanjc@google.com>, Adrian Hunter <adrian.hunter@intel.com>,
	Kan Liang <kan.liang@linux.intel.com>, Tony Luck <tony.luck@intel.com>,
	"Zhang Rui" <rui.zhang@intel.com>, Steven Rostedt <rostedt@goodmis.org>,
	"Andrew Cooper" <andrew.cooper3@citrix.com>, "Kirill A . Shutemov"
	<kirill.shutemov@linux.intel.com>, Jacob Pan <jacob.pan@linux.microsoft.com>,
	Andi Kleen <ak@linux.intel.com>, Kai Huang <kai.huang@intel.com>, "Sandipan
 Das" <sandipan.das@amd.com>, <linux-perf-users@vger.kernel.org>,
	<linux-edac@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-pm@vger.kernel.org>, <linux-trace-kernel@vger.kernel.org>
References: <20250513203803.2636561-1-sohil.mehta@intel.com>
 <20250513203803.2636561-5-sohil.mehta@intel.com>
 <9950dc5a-05ab-4a7c-a4e8-34012ef98549@zytor.com>
 <FEE77392-D778-4412-B4B7-583EF58955EB@zytor.com>
From: Sohil Mehta <sohil.mehta@intel.com>
In-Reply-To: <FEE77392-D778-4412-B4B7-583EF58955EB@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0164.namprd03.prod.outlook.com
 (2603:10b6:a03:338::19) To BYAPR11MB3320.namprd11.prod.outlook.com
 (2603:10b6:a03:18::25)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR11MB3320:EE_|MW4PR11MB7056:EE_
X-MS-Office365-Filtering-Correlation-Id: bd6e63b9-0281-4a4d-7c3a-08dda92fcd2c
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|366016|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?WStWLzBQMzN3eEUzTkxwUHEzN3l4R3liNDN0ckk5NEpnS203OUtQaWNwT2Vn?=
 =?utf-8?B?Sm1ZNmI1allKcGh1QURzM2llSGYxYWhrSURFY1RxV2NwYVpRYkVwUnNOL3JF?=
 =?utf-8?B?RXNjcFluZDNNSnVUYmZ4V3JUd0Z6ZThNQkdPWEttZHpiNTAwejhVdDVuZ1Ba?=
 =?utf-8?B?K3FZVG9hamNEVjgrMnYwbStOd3F5VVdmei92bGhMY3BqL0k1UUQrUElwV0NY?=
 =?utf-8?B?Z3JUMkUvZjNTNjRyVy9kTnIva2RnU1pJellpbURxWXdiVXNwUTYvaDFidHh4?=
 =?utf-8?B?Lzc5Q0ZoQ2hvVC9QMDV3M2FoWU5vTmo2N0thVHVaQ3JIUmhTY1ZkQmRYb21w?=
 =?utf-8?B?bEo3c0NXMnFhRC9xcDdOT2N1bDB0WDErRUpKVGJKeGk3R3BudU1NdnhvQjEr?=
 =?utf-8?B?QzZIc2VNYVQ5RHVaWlQxVm5XUnc3N1V1aGdSdDFLbjgvWnVlcTAwTjd6MkNh?=
 =?utf-8?B?WWhGV29laXh3anVWaXg4UzRiMnpmMkswczZkanRFYnF4MUdOVDRRUGF5dHdX?=
 =?utf-8?B?WEJON255RnM5dW9Lc0lzRmsvMlZ4bDVRYmt6U3Z0Nk9xSjJWbXl3OWVVUlF0?=
 =?utf-8?B?azFEbDJhelptSWdla0txZzRmNUlqZXlxbGNLdEtONFdrS2hGOWxobFE5TnB5?=
 =?utf-8?B?VzdyYmsyVEtoS1BFT1hIOUpWMnRMVVdxbEdycWtUU05LTHYwL0p6YUt4MEFD?=
 =?utf-8?B?MTljN3VHdGVYUTlON3prNXpIS0M0T3hjVWpQWm4vTUxDRy8zaTl3dzlHdVNZ?=
 =?utf-8?B?aklXRTJRSDRTczVuanhuMXdFUUYwU0lRRldkb2U1dkFVNThpaTM0SnBwcy9E?=
 =?utf-8?B?L3c1ODdyK09pei9HV2VUeEpweldpaDhxd3Jjeno5RWxUS254dnlvVGkrYUZp?=
 =?utf-8?B?YXJkWGxlWFUyS3FFb2Z6YU9EaElZSlMzSDZaQWNEK2dzZzIxWTgwRExnRlY0?=
 =?utf-8?B?ZCsvN2NWRS9KU3cyTXpQckFmWDg1L0RhTW1IYzJtdm5yQkUzWTZqZG9VR0tp?=
 =?utf-8?B?WmhzQmdmREhjcWdtOXBuWkE4akFOQWY3ZHg3NWZBZG1LZWRVUVlvcCttaVVR?=
 =?utf-8?B?NnhDaGVQYXBVM2xXK2FacVVPSnNEZ29hUEFFYWc3ZDFUZjNPd2pidklFc3l5?=
 =?utf-8?B?V1lIMnR0bEhmdmI1dEczcVkzR0IwcWNuVE5tci9ielVPL3Y0R2VTK3VER1RD?=
 =?utf-8?B?T1ZYcjB2bkVaNGIzbll4NzBZVS80Q3lTQ3BFZjllKzJ5eUJhU0NIdnY0ZG9E?=
 =?utf-8?B?VHF4OGhHZWFoVndxQ3l3S2lwZC9TeTg0TGVoWUhUTjRobzN6VVhTRHc4OG54?=
 =?utf-8?B?UjluSmtNNGJ5dFFUOFJKeTZ1Rlo5MGxCQ0xLNktCWUtQc2tRcE0xUGVFblRw?=
 =?utf-8?B?NjdLTjErTFFRc2lKdW5jaDV3WkVIQThRM0d0RXBieFk2c0FUWWxNd09Pbnp0?=
 =?utf-8?B?TlYwTGtKczNHVENLNFd3andQWmtUcm9sQktQSWUvTXA5dExKRUlRYkpzbC9N?=
 =?utf-8?B?bFcyS3BwQTdIYlMzNnNuVzBSK3A2bFE0Q2dNZS9ZMFFOUjlRaHAxZFJGeDRS?=
 =?utf-8?B?aXJiK0h4WFZVTkc1am0wYlY4bGtRM0JjMTZwMnNvc2tobmVta09BZFBqQ3NV?=
 =?utf-8?B?WFhvWFh5c3lobWZKZGhhRnJVZ2pEUWRXRFptUkZHcVpQTXByckNZREE3YklT?=
 =?utf-8?B?UG1QRlBCUXNZOEhDemRIbUp6eFcyc3JuQS9DZ0JVREZ1REdTdnM3Q28yNTFR?=
 =?utf-8?B?bGN6QjZLck9nL3ZPVkppaENRNkpKSEd3T2NtUk11M2Vzcjh0ellmUHIzdTly?=
 =?utf-8?B?V3pQZEFFcnZwb0NiR2RYYlVBYVBKR2pVdXpmRElGTVZ0SXFTUUEvNVVFV2FZ?=
 =?utf-8?B?MmduTUtkSGVoMUx4ajJQS1A3Q1kvUC9ZaGQ4cUNCUWlSWm1UQW1DeVRVYklh?=
 =?utf-8?Q?MX4XvErP6N8=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3320.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WHorQXROV3JicG1QWjBUNEtSZWlXM2VHbDVrVXhpS0F5Y0c4MmUyU1B2U0M5?=
 =?utf-8?B?OGx1WHJMQ2ZKSEhkZ2JPQ3ZUeUZsQWRSYXp6YkF2R0R6end1MWo1V1hBQTEr?=
 =?utf-8?B?SzVsNVcvKzVxRDVQaGFpVFM0YnFEcU9qelA3YzNaSXV2d3ZpWDNwSUV6V3Ro?=
 =?utf-8?B?Z2ZLc0Z4Z0hwT09NTkRydVkzUmdoK2RuSmRPYXUrSG9rbG5HSlZTeEY4cTVx?=
 =?utf-8?B?Mi9kdWdPeU14QWxGSzFDWlJoSEkrcndZMEdpTGVBZUpzV2d3UWE3cEdUYkVt?=
 =?utf-8?B?dExXcWd0ckdXaDc4b1Mvak1xWENiekx5UWo0YUJrV1I5RHN2aE81VjlyWlRv?=
 =?utf-8?B?ZlViWFI3bURXckptYWhFRnBhc3k5VnczYUNaNHdGNnNYNldKVGVqTzM2RnNK?=
 =?utf-8?B?bzNpcnVuVmhLLzRLOExoVEY4K3JnVFBJb1ZPWGNyWkljWVEwOHdybzJqc0lK?=
 =?utf-8?B?RHlXcWZxU1VXbW02QWtVbkozT0k4eHhVU1d6MHVOUFd1THVsY1huc3NJQzhS?=
 =?utf-8?B?dlF5MTlHeHFEVk9yUEtCUlhRcDRNam1CZ0FVOUVFeGo4MGxxak4vOWxEYVNn?=
 =?utf-8?B?eWozM3pUN2tRZmdBY3RPbDZGS1N0UzIwQnF1RTJMUldkdFZTYUNVbmpDYVEw?=
 =?utf-8?B?T2h6UUwyZ2FUYzdSWmVmSU45M1FZamNoUFZOQVc0clR5RE95V1BZOHhieVFG?=
 =?utf-8?B?NytTRU1XaVVTaEx1dDN1QnBmWWc3cU5HWjR0SCtSM0g0dC9ZU0Rjb1B3cm4w?=
 =?utf-8?B?NVpxeThQOElubFJweXhTWDhYV2NZTUpkSnhuWGJPSkRMVG5sa0JkRVorZGRm?=
 =?utf-8?B?V0J6dXhSWXBqZ2dtZFhPbXBycVA1b0dlWFRGNUhoMkdpS2Rad3NrUTR6OVBD?=
 =?utf-8?B?c3o2eW9VSXVJelNRbnlNUzk2R2paM3pHL3E2NXFtTFZxckdZUWNYM0tEcnJW?=
 =?utf-8?B?QUU4TzRYS0lVMjRMNlZUeXRjajhkb1NzendSTk1nVys5TldzTzA2cjhnWmRq?=
 =?utf-8?B?cDJnSmd1Uks2eFo0K2VWUysyWSt4UmtYQnhiUmV4MDhtU3RDblpZdmNTNUEy?=
 =?utf-8?B?YkVqOUJITWxwaUFJKzVTL0lJdVB0YzBoVUN5dWkrOUQ0bHhBbWJhMGVWSDFK?=
 =?utf-8?B?eS9TLytBdVNMSkJQZ3djbmpqb01GdEdIVXgzbTRVb2o0eGUrZjYxNmE3aGdG?=
 =?utf-8?B?dEtsVGk1SEMxZDByL1F3QXpsdHprSmNyM2tqMWJJMWFYVllSSlNlUmJjTk1N?=
 =?utf-8?B?cG01L0dRV09FWTJseXBTcC9aTmVSY0pybnN5VFR2WHlvWWZFQjhKK0tuMHFx?=
 =?utf-8?B?dVhzek1QLytnSkJXWlZ6L3pUeERad3lEMjhUVkM4SURSRCswd3pVbDlZaHFv?=
 =?utf-8?B?QnZFeFhnNUpOem4veU96UmRzYzdnRkpvdTB6VGZHNVVrWkFwK1VqQk9HdWU4?=
 =?utf-8?B?amZtZVRlTFdUbmpzN0F1K3k3M0VDV0JubE9SdTN0bUI1b1FQbGNsNkp1TjhJ?=
 =?utf-8?B?VUh4WXRaSnZwVWxuVDMwKzZYUXducUVha0MvVGMwUFllYVlvbUFoQ1JLdWlo?=
 =?utf-8?B?cXFEc1NNV0NkcTZOTVBnM3JnZTQvYm1rb3lxYkFCVkFLQTh0R3FKWDhrbHll?=
 =?utf-8?B?RDNua0N2V2RuWmRybVpZZHU2eEo2QlBkaUZSU3dnZnlGMVhhd0tBRGIrZUYr?=
 =?utf-8?B?eXdLN0VBTUdId3A2ZklNditJMHZBMWhRcDlJZlNQNVFyWUpZdFdUWFJ6T09T?=
 =?utf-8?B?dng5VEJubkZ2aW00ZnRIOFBmOHBnUlo0dFduYnlST3J2OTU0TmxVQ1dwREpu?=
 =?utf-8?B?NGJZS2tyOXhLTWF0MnJ1R3ZySVpXa1NyVHpsR3dwakhlOUZXZExiQkhablQ0?=
 =?utf-8?B?Q2p0SFFjK1RTc3VaT043YnN3OWxlUFdMNTg3UjVWYnBiaVY4K2kxdjZ2aDBK?=
 =?utf-8?B?QzRaZ2NpU24rbnAxWDFJVGhyVlBma1dDaWJpOU5OeE5BN2s1RWZLUExKV0kr?=
 =?utf-8?B?S1FVeDcyU2JHUUdnMDFnZGtpb0REVk1LOW53andWV042ckZjZmlYYlNhUU5k?=
 =?utf-8?B?VG04M241RFV6MGFBMi9VTjZCQ1hVQnZLbTBOOXJ4eUZRRkpKTERuazFoa2Ix?=
 =?utf-8?Q?fX8L8QP8Ip4lQkW7F8cH5Hujk?=
X-MS-Exchange-CrossTenant-Network-Message-Id: bd6e63b9-0281-4a4d-7c3a-08dda92fcd2c
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3320.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2025 21:34:52.9174
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eJ6UrX2ZaOskRXBeTrfhcC9NuSF4AXGnLn0IeSmUHvfJ+dV/ZDqOsWmeM9u47VvQMOV4NFl3QXvvOeKF/5VjqQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB7056
X-OriginatorOrg: intel.com

On 6/4/2025 8:28 AM, H. Peter Anvin wrote:
> 
> The architectural maximum* is 63 sources (plus the error bit), 
> although the current version only supports 1-15. If extended to be 
> wider, we would presumably add a new cpuid bit.
> 
> However, we should make sure there is nothing in the implementation 
> that limits us to 16 or 32 bits; when manipulating the bitmask we 
> should use a 64 bit type.
> 

There isn't anything in the implementation that would limit it to less
than 64 bits. However, (as suggested by Dave), I am planning to include:

	BUILD_BUG_ON(NMIS_VECTORS_MAX > 16);

If someone hits this compile issue while adding new vectors, it would
help them realize the limitations of the existing hardware.

We can recommend vector aliasing at that point or if there is hardware
in the pipeline that extends this beyond 16, we can simply get rid of
the BUILD_BUG_ON() along with the patches that add the new vectors.

> -hpa
> 
> * If we were to use the additional error reporting fields in the 
> FRED frame at some future point it could be extended as far as 207, 
> but since we at this point don't have anyone clamouring for more 
> than 15 this seems like a very remote possibility.


