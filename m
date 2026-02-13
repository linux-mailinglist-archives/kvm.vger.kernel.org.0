Return-Path: <kvm+bounces-71025-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kDu5DBJrjmnuCAEAu9opvQ
	(envelope-from <kvm+bounces-71025-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 13 Feb 2026 01:06:42 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 804BB131DFF
	for <lists+kvm@lfdr.de>; Fri, 13 Feb 2026 01:06:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6CFB93026C0A
	for <lists+kvm@lfdr.de>; Fri, 13 Feb 2026 00:06:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD0E83EBF29;
	Fri, 13 Feb 2026 00:06:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ahVdv9pw"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B32D638D;
	Fri, 13 Feb 2026 00:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770941186; cv=fail; b=ZK/jsAjPQEf9lnsDAHZN0TNF9jkr5ONlakpAfTY0O/xueXqC7eb3hQIIb+Bdysxi6v4hTS02rD6Xdre/RfjPSYYjILn4J5GDXFPsAxZXWMBFva+FQiNlYphDBLqAQg7aEi0r58yvVdVNVDHkLfJ76COYcPe1jbPT7WJs57JoQLs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770941186; c=relaxed/simple;
	bh=lftIc6UNsonhG6AoOVdXy2hylJSmOWWhX9/WhfETO3k=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=P2ugDK2DoCyI8m7hOhbT3gI0kGsXYjiSuxkcZA/xPDIBw4HxzApwmo99CnMqkFfU6ZvxzyxzBMmnnz+FOcsD8yqlIqjHocDtUjzqE5mbmc8HZha0bLoJ6c0xtR/sa2oy3NF+vTp836l+RBs8xBpyNhhU/4YPZQgOlJCQ39I9qiU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ahVdv9pw; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770941183; x=1802477183;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=lftIc6UNsonhG6AoOVdXy2hylJSmOWWhX9/WhfETO3k=;
  b=ahVdv9pwXVyDoN+Ptiwe97pG6BqE9RSweV4uWU5TwSS1Z0yMpjA1aV2s
   K2P3qcCSnoE0ZexEIB11VTTwMZLEG64E8ZKVmA1CVb6OD6anGSvjEryyn
   siBFVF1usDVZ8PHyURyLjIXX6iLFF0xtjJp5NZTgAq3/+EtjKgs4yRvxU
   MO1x60v8RzTFmjrPosEA7BKNdBqqK74nuEimA/4ZEDjf3kYMNcCORCKjw
   BTRoGhwMI2VoaO1TxQw/A+rc7viLDbMxrmExeOu/P7iGvpg+5LL7nZTkt
   x7iHDgfAN9W7ZLYzZ4ezEmyVw/e7+v6fY9wkH3pqLazzhAKY228MEFR1N
   Q==;
X-CSE-ConnectionGUID: Lbwc6yHVQ9mE8ihCy2NrZw==
X-CSE-MsgGUID: XxOsEwjVR26Y6UJWmdO+cQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11699"; a="75753003"
X-IronPort-AV: E=Sophos;i="6.21,287,1763452800"; 
   d="scan'208";a="75753003"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2026 16:06:22 -0800
X-CSE-ConnectionGUID: Pa/agYe2QliOx/4FzebB5g==
X-CSE-MsgGUID: PlxiBXcvQcilEUGbLR6AmQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,287,1763452800"; 
   d="scan'208";a="212862291"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2026 16:06:22 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Thu, 12 Feb 2026 16:06:22 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Thu, 12 Feb 2026 16:06:22 -0800
Received: from SN4PR2101CU001.outbound.protection.outlook.com (40.93.195.29)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Thu, 12 Feb 2026 16:06:21 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kxp5hc/+8/mfH6Dsjyym8+agcl9q4LVA4XslRzNQr2vIHLVJE4c5/5/F0Q4Lj7EqL++wyD2mRY7HzUQTLeR7iGTHmaD2m2ub3WRFrvNdZXrYsgBdSTDQn4R4sCPBFf1nNbMNgGGsQhgH+Yxs7lqkkICoesaqssH5WUPNZ9bmdAL6ZsFZG5MBtdh5h3Qx8H6992uO+1ymjNIYVRJThmt0m4Pva2ch9WBb4fmlMDTVDlrfwdE3oghHmYL6jDAtEwIPStepKEXvs0cmpaBTCWlBcRC6iT6Ved8pLYeWI7cX9Smbh/+M0HQDONobWzum+rdlERoQkgcua64WmTXH6TqAfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X6ISWIIhgFmKAOnA8Igy5yBv3EwBd06i8TJS/15H6K0=;
 b=JUasXatNZ9ix6LsTK0BXR/u/7OeC39gpSCUHZ2Jq7H2VXeRD+vwYr9C7aej6c4qqHC7D3rtk71/umovbzlUKlm+HttuqP3gDHg6i5QCY0KNK9IYdH5/wdtH3ZQKRB6OoZZAwzNV99LEfTphnioMm4piqq9BcH5cYX+dwyQ2l6OCRjEWx9lRKInAAH+KjqZHHfr2AZz0wFQMDXADKvqLO8/YyULm8yhUPoctzswH4foI3ka0RQuws9/f4I4Upl2BRfk9vF9xz5yUEOG7ClGHIyg4/X0OkIVKOnNT2xwPa6zaSrSskIbFpt4H/LP+Z6t3epDOudzsYVoboYkDU1JsZhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SA1PR11MB5780.namprd11.prod.outlook.com (2603:10b6:806:233::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.11; Fri, 13 Feb
 2026 00:06:17 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d%6]) with mapi id 15.20.9587.017; Fri, 13 Feb 2026
 00:06:17 +0000
Message-ID: <557a3a1e-4917-4c8c-add6-13b9db39eecb@intel.com>
Date: Thu, 12 Feb 2026 16:05:41 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 01/19] x86,fs/resctrl: Add support for Global
 Bandwidth Enforcement (GLBE)
To: Babu Moger <babu.moger@amd.com>, "Moger, Babu" <bmoger@amd.com>,
	<corbet@lwn.net>, <tony.luck@intel.com>, <Dave.Martin@arm.com>,
	<james.morse@arm.com>, <tglx@kernel.org>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>
CC: <x86@kernel.org>, <hpa@zytor.com>, <peterz@infradead.org>,
	<juri.lelli@redhat.com>, <vincent.guittot@linaro.org>,
	<dietmar.eggemann@arm.com>, <rostedt@goodmis.org>, <bsegall@google.com>,
	<mgorman@suse.de>, <vschneid@redhat.com>, <akpm@linux-foundation.org>,
	<pawan.kumar.gupta@linux.intel.com>, <pmladek@suse.com>,
	<feng.tang@linux.alibaba.com>, <kees@kernel.org>, <arnd@arndb.de>,
	<fvdl@google.com>, <lirongqing@baidu.com>, <bhelgaas@google.com>,
	<seanjc@google.com>, <xin@zytor.com>, <manali.shukla@amd.com>,
	<dapeng1.mi@linux.intel.com>, <chang.seok.bae@intel.com>,
	<mario.limonciello@amd.com>, <naveen@kernel.org>,
	<elena.reshetova@intel.com>, <thomas.lendacky@amd.com>,
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>, <peternewman@google.com>, <eranian@google.com>,
	<gautham.shenoy@amd.com>
References: <cover.1769029977.git.babu.moger@amd.com>
 <aba70a013c12383d53104de0b19cfbf87690c0c3.1769029977.git.babu.moger@amd.com>
 <eb4b7b12-7674-4a1e-925d-2cec8c3f43d2@intel.com>
 <f0f2e3eb-0fdb-4498-9eb8-73111b1c5a84@amd.com>
 <9b02dfc6-b97c-4695-b765-8cb34a617efb@intel.com>
 <3a7c17c0-bb51-4aad-a705-d8d1853ea68a@amd.com>
 <06a237bd-c370-4d3f-99de-124e8c50e711@intel.com>
 <91d50431-41f3-49d7-a9e6-a3bee2de5162@amd.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <91d50431-41f3-49d7-a9e6-a3bee2de5162@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MW3PR05CA0009.namprd05.prod.outlook.com
 (2603:10b6:303:2b::14) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SA1PR11MB5780:EE_
X-MS-Office365-Filtering-Correlation-Id: 81fef6cf-e5cd-43d3-a724-08de6a93b58c
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?Nnh6amRkZDMzeUhTYzZCRSsrNWt2eUtBR1Z2c2pCbEN2QkdUNG1UZDZ1VmVQ?=
 =?utf-8?B?UjdxR2hIa0NyOUpEdno0N1ltWUFQYmZJWXJjODRNZVI0ZlVOK25rK3k2VE94?=
 =?utf-8?B?cEpXd1A4V2tOVDZna0tqTXREdUpjbzRWVVRPQ0JPQnlodlRITTcrSGxBWHls?=
 =?utf-8?B?eUlaTTY0M0dyMTY5NHNTMnZyRzdrMzJ2QjJWMmoyd3Z5VXRSWDc0QWNkL3NH?=
 =?utf-8?B?a3R1enhvWnFrSFZWeGFJSW9aOUlRMGhKQ2RZMlFQZGdGRzNqZVd1azJwTENG?=
 =?utf-8?B?TGd5TzJjL3hodEgwNXFnYzJhaEVyL2Y4cmliTS9zWVdpMklqKzNuTzMxMWh2?=
 =?utf-8?B?SEY5UmE1Qkp3ZWgvT2JERkd4RlZyU0EyaitiSDJEUklsb3hQVTdoOUdySlpZ?=
 =?utf-8?B?ZjZncnJOaUErUUpsTENlekI4eFI0djZwcWNKRmtySldyS012VXlVOGI5Mld0?=
 =?utf-8?B?YnRYRktOOCtvczhJRjFvU3hsdnF3ekE2L1JMWDM2aVBSNnMwaFBiclFLZ3Yr?=
 =?utf-8?B?cktFbStDdXl1aVlDcXJVNVk3VDRzTlpzSnpHRmsyREdPYlhjYUJLaiszL3dE?=
 =?utf-8?B?SHA4cHNvWUEzOURoaUNKNzhDaE9ySDVCQlU1cmlOeEE4Zm1IYm9Mc2psaGl3?=
 =?utf-8?B?TWl1ckN2U3pWSVl2bWRxK2E0aU5Wak9aK0prV3B5UlNtZk02T3NYSEJGdHB2?=
 =?utf-8?B?OUN4OTllU2hHcU5icXMvaDZKK3l5enhDTUJIaU5tZ1dYU0FqVUlHa3VvdEVK?=
 =?utf-8?B?RWZkcjVLT3BqbUpRTVNtcjgyNlA5ZUN2em9PNWQxMm5ZZnZXdFFPSFR0akVB?=
 =?utf-8?B?N3JTZkhTNlRVMVRycHdoeVVGNzhDeXRQTjErenRLVVVUQ0ZQckRCY3hLaTNT?=
 =?utf-8?B?aUYvT3hNSDl4T3l2b1grVm54NHNERU9YMHRRLzE4Sld6SXdRYTRRVVVZRDJF?=
 =?utf-8?B?S0RUTkl0VVhxZ3crUUsxcXFuQmhDNU9BbmJodWxRWFpleG1xSGtxa1h6NjRR?=
 =?utf-8?B?Qk9aMVdUK1BXN2pOdG5sY2dZTjJKUkUwWWRxQUdYTWxiQndLd1lVZ0t2SXZN?=
 =?utf-8?B?blVSNDM0UlRBV1B5S00wR3laa1JSS1l5Qno1WGltTFU3NmVXUDR0TVNMS2Rh?=
 =?utf-8?B?WkMyN3dGUmRwTnc0L2UranlvWUljRjdWM3V3RUYyNU1MUHhRV3RVbW1ka3dJ?=
 =?utf-8?B?d2NsVng2SGhZMXlPejc2bU4yRjArQ1Y0Y3h0NWt1c3BENlJHNXlPckJPRUxn?=
 =?utf-8?B?V2l4REU3cGJJQmZKR2Rtd01SSXR3Uk1sYVUzWVNTNXNWV3ArMmY2ejdQTFAr?=
 =?utf-8?B?NGlsOTYzRENldVlhajBCSk5NZFBvYXBRRnV1ZTE1aExHWkhWYm1nRTJYM1BZ?=
 =?utf-8?B?elJ0OWpBS3R1TENEV3VjVFdlUUVZdkRXT3R6TnRIUzZKQlcxNDUxRzNZNWRp?=
 =?utf-8?B?d3huWVk3RFpWdUdibk9ZaTNEeks4OUN1Nys2MWhWbmVQTmU2bjRZWU5KdDFa?=
 =?utf-8?B?M1J6dEpuSzlKYU5UOUk2MzVleEo5N0lPYjBhVURKOWZybVpNZHd0MFZuM1JZ?=
 =?utf-8?B?Q1ZBTEQwc0NoajhNVzYyNUkzYWtaVjVpbnVsK3lYRU1UZTZRTEhCek9oWWt2?=
 =?utf-8?B?ajN5YzhJUWR1OFJnbnp5djVoNnpXbmJJN1ZuRUNXV0phV00rUTBKYmMrTEJR?=
 =?utf-8?B?Znp2MWxUVE5mZlZRNldoRFFxZmhhYTRZMmY5dENIeVhWV1VlV3FkVUhkcExm?=
 =?utf-8?B?UXdsYzEzbVZublVsUjA1dTl2bmIwRzBxQXNrbGs3NzUrOGd0VTJqK1gwTkNi?=
 =?utf-8?B?Yi96bjFsUjl0a1IxdFB4QVhsLzNYNTlSSVVqSFFpY3Y0Rk41VzFLSVYvVTgz?=
 =?utf-8?B?b1ZOcmlITUpMbHovcm5DeEExVHArUDE5K0RoNzBqV2FLMmxKYTRLZ3pUY09L?=
 =?utf-8?B?Vy9xc3ZTZFhFamtDNGFKOHgrMWNRM3pZLytjVXd1T0FyQzRGQjhqOG9DdlhG?=
 =?utf-8?B?TTdPeXF3NE0xODF0elovRVFiVGhvY2dkb1dyM3JhU1hUWDd3a3VidFluVTBZ?=
 =?utf-8?B?YlRiQWRnNmM1aWhqdnM4c2E1OC9SMktCWDE0NEFkd3dyVTNkQm51QlN0OFdn?=
 =?utf-8?B?TFhadmgvd3pWUjRnZTEvblU5V1R6dWZLcDJab3JsSHhrSExidUg2MGdIR3dK?=
 =?utf-8?B?bUE9PQ==?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZHJwVGF2ekNVajUxMGV3ZGMrM2czUFpsNE5WRXIxZ2RDajVzWjRnaHV5cnFr?=
 =?utf-8?B?SzhSS0tVb2JXODU2bnZUNWhjZXBSOWdvUkVvVllmWW4rMDJkZy9GZnJLN1N1?=
 =?utf-8?B?SER3ZG1PcWJ5bEJvb3dneHU0dCtlbDNIR3dwZXNNLy94UGtDNldJdHdLT0hW?=
 =?utf-8?B?ZVg4QzV2TnNWcVRIV1A1VFRzZmZ3anpqc1g2V0hBSnl6VGhHSkZ2bU12NmxK?=
 =?utf-8?B?OCs4U2JwQkl2N3J4eWQ5TURFbG5MQVNidHJ5c0Ywd2lIb1dMN1dubHdYMHNP?=
 =?utf-8?B?RVhyV3hyaXcycWEvYlU5Yk5ITXpIWnhrdksrdURtSW42WkVaUmpIWm40SjFX?=
 =?utf-8?B?aW0rNEVKRUF1MXVLTVorc051MTREMHo1d3dJSU9CQ2xKZTJKWVNnY1plSkRV?=
 =?utf-8?B?cUNLL0pCcmNFNmdTdUh6YnZHK1JlNjlaUE1QbnN6ZkxOZ2JsVmxUZTJTVTJs?=
 =?utf-8?B?SFBpejNGZUZpanpOMFplLzhmMGpJcXRqSzNPd2h4VlY0a0VWa3VrTVBEMjh2?=
 =?utf-8?B?Ykp5Tlg3K3N1M2FLUm8vanVySUZqWGV2Sml1REc1WjlzQXF1ZnJKRVFzdnJy?=
 =?utf-8?B?YTE0a2g3OXNCa3NYeERFbHFDZ1R4YmJ3Z2tjT25jbWQwNE14R045b21HYnU2?=
 =?utf-8?B?c1N6Qmt2SEhvWGJGYnVESTk3MFBNbUNvT1lJQnJ1Z3lFUGprUlp3UDNnU3J5?=
 =?utf-8?B?S2pHOC95eVFuSVF0cGV4eFpKbDhzS2REVm9pRGtVWVgxOGcxaVIvWmdQdzFl?=
 =?utf-8?B?THZPTXZkUnN1cWdGeHhpUUJ4OGszVUNnVlVHVXhxS0MyRTVtcHpZUEFnQjN5?=
 =?utf-8?B?K1luTFFVdEJKeUtPeUNzNzQ0bjhvZm54RlZkcDBoS1hOMXZ3ZkpVd0VlRk5p?=
 =?utf-8?B?N0E5KzFDUEdVbHppNjAzK0RMNklNRThkOUo2dk9sZDY3ZTIvTHZ3cmhYTkF3?=
 =?utf-8?B?QVVITG1Dekt3Vk5tSDdqbGVGalluWENzbXZkYjgydWxEN3pTakoxeDBMM05y?=
 =?utf-8?B?czJWZjAwb09LekkzWS9qTW5sMWNjSDZVOFpLMFByalAvNStEVm1tQUZ0SkJP?=
 =?utf-8?B?RkxUWnljaVI0UnpNYUFETk14MHZmM2ZSWTdSZGdrZTdKeG1XYzV6aWRQcUZu?=
 =?utf-8?B?b0pkdEdNQVAxaVJYMHVFZk84OUgzVng0djBqQkp6Z29laHV3Q1BNL3VxZlFh?=
 =?utf-8?B?dkQwOVFDbjFCUzhXbk82S0NrK2d3UjBOWUpXeTNKSUlvQUVjTlloQ1c1RmRT?=
 =?utf-8?B?Vmp2WEphV3pSazNXMTJlTjhkSjd2SklpQUI5T1JlNnBKREE3ZDh4OVJTVnNa?=
 =?utf-8?B?OWtLNnBqOWZDbStZT3k5YnI5U3FZN2g4YUxzbm43UUo0MXV0WW9OV01KYUl2?=
 =?utf-8?B?bllIc2YySEVWeitwRmt3Z1BCY3hZajAzR2pOL2xVcCtOUkVYREl4WStZUHQ3?=
 =?utf-8?B?OFdOL2dyOEk0dE9MYzRHWi9CRWJjUFRwbXhsT2FvWjJweG5QRjR0YUpSa1RB?=
 =?utf-8?B?SnFSZUhvY3MrZ2RnTnk1N1FFMFlqOERHTThUNGdRaUhvV0xiYU94M0VGQnk0?=
 =?utf-8?B?UEZpdWkrcVBqclM3Wk5ZK3lwekUzYi9QcXA1a2JYc0ErcG9QYmlvTU9MZnhz?=
 =?utf-8?B?L0FBNXltUTRVTjhFVU5PZzc3VlBLakhlTFpISllCK3o2T01oTG5zMjNPd0FH?=
 =?utf-8?B?VDVOSTN4OEtIbWFFWGNPVEpsdUZ2YVdnUFZyTUVkUzN5akNpV1lFSFZUWGpV?=
 =?utf-8?B?bStQTCsrbXhIQ2dIUnBPYVpWUHRXZW93YlVrUC82VXozTWdGTWJiUFRsdlNu?=
 =?utf-8?B?TzlsZzloRkRoRjd1aTgxQnZITjc0UHp3Sm1JUFpqb0FQbFNzd2p0QURHclAy?=
 =?utf-8?B?ZE1nS2Q0RnFFQU1VZlJQZjMrOFZlYkpjVm9udHVWSUhHSmVMZFpBNnJNMzl4?=
 =?utf-8?B?S05FN0p2ZStFZVdBUTQrYVBYcURMbFlaYUhtSDc2ZzlWU2IrS2hKQkgvWHpj?=
 =?utf-8?B?OGIzSitvVllZL2VXWUdEMjdqRFc4N0xzZmdkZm1nNlpVWTRhbnQxYk1acE5w?=
 =?utf-8?B?ZXJnK2dVKzBDVlRoVTZFVEYwZ3gyaG5tRUhJWml1dDFzclhER1lkQmpweFhk?=
 =?utf-8?B?b0c4UlA1blQ2ZXljcHBwUmtXcFFUZmFHZUJUeHNXVXNnUllYVnVNWlZMVEFu?=
 =?utf-8?B?TEUwSk9Za2dEOXl0N3BUaHE1ZnpwUEpQWlN4cGZXNXpTR3lkcjlyTTRDTGlS?=
 =?utf-8?B?bjVNVjRNZGgxeUhPcURaT3BoSS8xKzFUVlZYbUpSeGxLazRPWnpGLzY2Rk1D?=
 =?utf-8?B?NloyNTlRSGJoYSs1bGZ2UzR4b2tPdUF0dTRaN1JFcGJOQXQzbG5kS1MxUU5Y?=
 =?utf-8?Q?Yl0fbXNQHhlaGI/w=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 81fef6cf-e5cd-43d3-a724-08de6a93b58c
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2026 00:06:17.3116
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fmWTdxRfLTZTpY+W4kmVDKmkggUyY8nFSGn4q0MFSDYVHImVfmSXyxUlJQ4hN3L/dwnAohCtf5LQH6l/a5BbUa6C/FeK+++4Hw2QbjgLQgs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB5780
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[44];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_COUNT_SEVEN(0.00)[10];
	MID_RHS_MATCH_FROM(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[reinette.chatre@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,intel.com:mid,intel.com:dkim];
	PRECEDENCE_BULK(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71025-lists,kvm=lfdr.de];
	DKIM_TRACE(0.00)[intel.com:+]
X-Rspamd-Queue-Id: 804BB131DFF
X-Rspamd-Action: no action

Hi Babu,

On 2/12/26 11:09 AM, Babu Moger wrote:
> Hi Reinette,
> 
> On 2/11/26 21:51, Reinette Chatre wrote:
>> Hi Babu,
>>
>> On 2/11/26 1:18 PM, Babu Moger wrote:
>>> On 2/11/26 10:54, Reinette Chatre wrote:
>>>> On 2/10/26 5:07 PM, Moger, Babu wrote:
>>>>> On 2/9/2026 12:44 PM, Reinette Chatre wrote:
>>>>>> On 1/21/26 1:12 PM, Babu Moger wrote:

...

>>>> Another question, when setting aside possible differences between MB and GMB.
>>>>
>>>> I am trying to understand how user may expect to interact with these interfaces ...
>>>>
>>>> Consider the starting state example as below where the MB and GMB ceilings are the
>>>> same:
>>>>
>>>>     # cat schemata
>>>>     GMB:0=2048;1=2048;2=2048;3=2048
>>>>     MB:0=2048;1=2048;2=2048;3=2048
>>>>
>>>> Would something like below be accurate? Specifically, showing how the GMB limit impacts the
>>>> MB limit:
>>>>        # echo"GMB:0=8;2=8" > schemata
>>>>     # cat schemata
>>>>     GMB:0=8;1=2048;2=8;3=2048
>>>>     MB:0=8;1=2048;2=8;3=2048
>>> Yes. That is correct.  It will cap the MB setting to  8.   Note that we are talking about unit differences to make it simple.
>> Thank you for confirming.
>>
>>>> ... and then when user space resets GMB the MB can reset like ...
>>>>
>>>>     # echo"GMB:0=2048;2=2048" > schemata
>>>>     # cat schemata
>>>>     GMB:0=2048;1=2048;2=2048;3=2048
>>>>     MB:0=2048;1=2048;2=2048;3=2048
>>>>
>>>> if I understand correctly this will only apply if the MB limit was never set so
>>>> another scenario may be to keep a previous MB setting after a GMB change:
>>>>
>>>>     # cat schemata
>>>>     GMB:0=2048;1=2048;2=2048;3=2048
>>>>     MB:0=8;1=2048;2=8;3=2048
>>>>
>>>>     # echo"GMB:0=8;2=8" > schemata
>>>>     # cat schemata
>>>>     GMB:0=8;1=2048;2=8;3=2048
>>>>     MB:0=8;1=2048;2=8;3=2048
>>>>
>>>>     # echo"GMB:0=2048;2=2048" > schemata
>>>>     # cat schemata
>>>>     GMB:0=2048;1=2048;2=2048;3=2048
>>>>     MB:0=8;1=2048;2=8;3=2048
>>>>
>>>> What would be most intuitive way for user to interact with the interfaces?
>>> I see that you are trying to display the effective behaviors above.
>> Indeed. My goal is to get an idea how user space may interact with the new interfaces and
>> what would be a reasonable expectation from resctrl be during these interactions.
>>
>>> Please keep in mind that MB and GMB units differ. I recommend showing only the values the user has explicitly configured, rather than the effective settings, as displaying both may cause confusion.
>> hmmm ... this may be subjective. Could you please elaborate how presenting the effective
>> settings may cause confusion?
> 
> I mean in many cases, we cannot determine the effective settings correctly. It depends on benchmarks or applications running on the system.
> 
> Even with MB (without GMB support), even though we set the limit to 10GB, it may not use the whole 10GB.  Memory is shared resource. So, the effective bandwidth usage depends on other applications running on the system.

Sounds like we interpret "effective limits" differently. To me the limits(*) are deterministic.
If I understand correctly, if the GMB limit for domains A and B is set to x GB then that places
an x GB limit on MB for domains A and B also. Displaying any MB limit in the schemata that is
larger than x GB for domain A or domain B would be inaccurate, no?

When considering your example where the MB limit is 10GB.

Consider an example where there are two domains in this example with a configuration like below.
(I am using a different syntax from schemata file that will hopefully make it easier to exchange
ideas when not having to interpret the different GMB and MB units):

	MB:0=10GB;1=10GB

If user space can create a GMB domain that limits shared bandwidth to 10GB that can be displayed
as below and will be accurate:

	MB:0=10GB;1=10GB
	GMB:0=10GB;1=10GB

If user space then reduces the combined bandwidth to 2GB then the MB limit is wrong since it
is actually capped by the GMB limit:

	MB:0=10GB;1=10GB <==== Does reflect possible per-domain memory bandwidth which is now capped by GMB
	GMB:0=2GB;1=2GB

Would something like below not be more accurate that reflects that the maximum average bandwidth
each domain could achieve is 2GB?

	MB:0=2GB;1=2GB <==== Reflects accurate possible per-domain memory bandwidth
	GMB:0=2GB;1=2GB

(*) As a side-note we may have to start being careful with how we use "limits" because of the planned
introduction of a "MAX" as a bandwidth control that is an actual limit as opposed to the
current control that is approximate.
 
>>> We also need to track the previous settings so we can revert to the earlier value when needed. The best approach is to document this behavior clearly.
>> Yes, this will require resctrl to maintain more state.
>>
>> Documenting behavior is an option but I think we should first consider if there are things
>> resctrl can do to make the interface intuitive to use.
>>
>>>>>>>   From the description it sounds as though there is a new "memory bandwidth
>>>>>> ceiling/limit" that seems to imply that MBA allocations are limited by
>>>>>> GMBA allocations while the proposed user interface present them as independent.
>>>>>>
>>>>>> If there is indeed some dependency here ... while MBA and GMBA CLOSID are
>>>>>> enumerated separately, under which scenario will GMBA and MBA support different
>>>>>> CLOSID? As I mentioned in [1] from user space perspective "memory bandwidth"
>>>>> I can see the following scenarios where MBA and GMBA can operate independently:
>>>>> 1. If the GMBA limit is set to ‘unlimited’, then MBA functions as an independent CLOS.
>>>>> 2. If the MBA limit is set to ‘unlimited’, then GMBA functions as an independent CLOS.
>>>>> I hope this clarifies your question.
>>>> No. When enumerating the features the number of CLOSID supported by each is
>>>> enumerated separately. That means GMBA and MBA may support different number of CLOSID.
>>>> My question is: "under which scenario will GMBA and MBA support different CLOSID?"
>>> No. There is not such scenario.
>>>> Because of a possible difference in number of CLOSIDs it seems the feature supports possible
>>>> scenarios where some resource groups can support global AND per-domain limits while other
>>>> resource groups can just support global or just support per-domain limits. Is this correct?
>>> System can support up to 16 CLOSIDs. All of them support all the features LLC, MB, GMB, SMBA.   Yes. We have separate enumeration for  each feature.  Are you suggesting to change it ?
>> It is not a concern to have different CLOSIDs between resources that are actually different,
>> for example, having LLC or MB support different number of CLOSIDs. Having the possibility to
>> allocate the *same* resource (memory bandwidth) with varying number of CLOSIDs does present a
>> challenge though. Would it be possible to have a snippet in the spec that explicitly states
>> that MB and GMB will always enumerate with the same number of CLOSIDs?
> 
> I have confirmed that is the case always.  All current and planned implementations, MB and GMB will have the same number of CLOSIDs.

Thank you very much for confirming. Is this something the architects would be willing to
commit to with a snippet in the PQoS spec?

>> Please see below where I will try to support this request more clearly and you can decide if
>> it is reasonable.
>>   
>>>>>> can be seen as a single "resource" that can be allocated differently based on
>>>>>> the various schemata associated with that resource. This currently has a
>>>>>> dependency on the various schemata supporting the same number of CLOSID which
>>>>>> may be something that we can reconsider?
>>>>> After reviewing the new proposal again, I’m still unsure how all the pieces will fit together. MBA and GMBA share the same scope and have inter-dependencies. Without the full implementation details, it’s difficult for me to provide meaningful feedback on new approach.
>>>> The new approach is not final so please provide feedback to help improve it so
>>>> that the features you are enabling can be supported well.
>>> Yes, I am trying. I noticed that the proposal appears to affect how the schemata information is displayed(in info directory). It seems to introduce additional resource information. I don't see any harm in displaying it if it benefits certain architecture.
>> It benefits all architectures.
>>
>> There are two parts to the current proposals.
>>
>> Part 1: Generic schema description
>> I believe there is consensus on this approach. This is actually something that is long
>> overdue and something like this would have been a great to have with the initial AMD
>> enabling. With the generic schema description forming part of resctrl the user can learn
>> from resctrl how to interact with the schemata file instead of relying on external information
>> and documentation.
> 
> ok.
> 
>> For example, on an Intel system that uses percentage based proportional allocation for memory
>> bandwidth the new resctrl files will display:
>> info/MB/resource_schemata/MB/type:scalar linear
>> info/MB/resource_schemata/MB/unit:all
>> info/MB/resource_schemata/MB/scale:1
>> info/MB/resource_schemata/MB/resolution:100
>> info/MB/resource_schemata/MB/tolerance:0
>> info/MB/resource_schemata/MB/max:100
>> info/MB/resource_schemata/MB/min:10
>>
>>
>> On an AMD system that uses absolute allocation with 1/8 GBps steps the files will display:
>> info/MB/resource_schemata/MB/type:scalar linear
>> info/MB/resource_schemata/MB/unit:GBps
>> info/MB/resource_schemata/MB/scale:1
>> info/MB/resource_schemata/MB/resolution:8
>> info/MB/resource_schemata/MB/tolerance:0
>> info/MB/resource_schemata/MB/max:2048
>> info/MB/resource_schemata/MB/min:1
>>
>> Having such interface will be helpful today. Users do not need to first figure out
>> whether they are on an AMD or Intel system, and then read the docs to learn the AMD units,
>> before interacting with resctrl. resctrl will be the generic interface it intends to be.
> 
> Yes. That is a good point.
> 
>> Part 2: Supporting multiple controls for a single resource
>> This is a new feature on which there also appears to be consensus that is needed by MPAM and
>> Intel RDT where it is possible to use different controls for the same resource. For example,
>> there can be a minimum and maximum control associated with the memory bandwidth resource.
>>
>> For example,
>> info/
>>   └─ MB/
>>       └─ resource_schemata/
>>           ├─ MB/
>>           ├─ MB_MIN/
>>           ├─ MB_MAX/
>>           ┆
>>
>>
>> Here is where the big question comes in for GLBE - is this actually a new resource
>> for which resctrl needs to add interfaces to manage its allocation, or is it instead
>> an additional control associated with the existing memory bandwith resource?
> 
> It is not a new resource. It is new control mechanism to address limitation with memory bandwidth resource.
> 
> So, it is a new control for the existing memory bandwidth resource.

Thank you for confirming.

> 
>> For me things are actually pointing to GLBE not being a new resource but instead being
>> a new control for the existing memory bandwidth resource.
>>
>> I understand that for a PoC it is simplest to add support for GLBE as a new resource as is
>> done in this series but when considering it as an actual unique resource does not seem
>> appropriate since resctrl already has a "memory bandwidth" resource. User space expects
>> to find all the resources that it can allocate in info/ - I do not think it is correct
>> to have two separate directories/resources for memory bandwidth here.
>>
>> What if, instead, it looks something like:
>>
>> info/
>> └── MB/
>>      └── resource_schemata/
>>          ├── GMB/
>>          │   ├──max:4096
>>          │   ├──min:1
>>          │   ├──resolution:1
>>          │   ├──scale:1
>>          │   ├──tolerance:0
>>          │   ├──type:scalar linear
>>          │   └──unit:GBps
>>          └── MB/
>>              ├──max:8192
>>              ├──min:1
>>              ├──resolution:8
>>              ├──scale:1
>>              ├──tolerance:0
>>              ├──type:scalar linear
>>              └──unit:GBps
> 
> Yes. It definitely looks very clean.
> 
>> With an interface like above GMB is just another control/schema used to allocate the
>> existing memory bandwidth resource. With the planned files it is possible to express the
>> different maximums and units used by the MB and GMB schema. Users no longer need to
>> dig for the unit information in the docs, it is available in the interface.
> 
> 
> Yes. That is reasonable.
> 
> Is the plan to just update the resource information in /sys/fs/resctrl/info/<resource_name>  ?

I do not see any resource information that needs to change. As you confirmed,
MB and GMB have the same number of CLOSIDs and looking at the rest of the
enumeration done in patch #2 all other properties exposed in top level of
/sys/fs/resctrl/info/MB is the same for MB and GMB. Specifically,
thread_throttle_mode, delay_linear, min_bandwidth, and bandwidth_gran have
the same values for MB and GMB. All other content in 
/sys/fs/resctrl/info/MB would be new as part of the new "resource_schemata"
sub-directory.

Even so, I believe we could expect that a user using any new schemata file entry
introduced after the "resource_schemata" directory is introduced is aware of how
the properties are exposed and will not use the top level files in /sys/fs/resctrl/info/MB
(for example min_bandwidth and bandwidth_gran) to understand how to interact with
the new schema.


> 
> Also, will the display of /sys/fs/resctrl/schemata change ?

There are no plans to change any of the existing schemata file entries.

> 
> Current display:

When viewing "current" as what this series does in schemata file ...

> 
>  GMB:0=4096;1=4096;2=4096;3=4096
>   MB:0=8192;1=8192;2=8192;3=8192

yes, the schemata file should look like this on boot when all is done. All other
user facing changes are to the info/ directory where user space learns about
the new control for the resource and how to interact with the control.

>> Doing something like this does depend on GLBE supporting the same number of CLOSIDs
>> as MB, which seems to be how this will be implemented. If there is indeed a confirmation
>> of this from AMD architecture then we can do something like this in resctrl.
> 
> I don't see this being an issue. I will get consensus on it.
> 
> I am wondering about the time frame and who is leading this change. Not sure if that is been discussed already.
> I can definitely help.

A couple of features depend on the new schema descriptions as well as support for multiple
controls: min/max bandwidth controls on the MPAM side, region aware MBA and MBM on the Intel
side, and GLBE on the AMD side. I am hoping that the folks working on these features can
collaborate on the needed foundation. Since there are no patches for this yet I cannot say
if there is a leader for this work yet, at this time this role appears to be available if you
would like to see this moving forward in order to meet your goals.

Reinette

> 
> Thanks
> 
> Babu
> 
> 


