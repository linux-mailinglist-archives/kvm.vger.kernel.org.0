Return-Path: <kvm+bounces-71386-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iLYXCb3Ml2mh8gIAu9opvQ
	(envelope-from <kvm+bounces-71386-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 20 Feb 2026 03:53:49 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 256491644F0
	for <lists+kvm@lfdr.de>; Fri, 20 Feb 2026 03:53:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2888A3027B4A
	for <lists+kvm@lfdr.de>; Fri, 20 Feb 2026 02:53:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05C272C08C8;
	Fri, 20 Feb 2026 02:53:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bT2c52O0"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A02F72BAF8;
	Fri, 20 Feb 2026 02:53:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771556015; cv=fail; b=WKEQ1thw0gpgI9NZcrCGAFxK5dlWs0ddw5RcI8GzsmO8MHkHukG869aHe/dJAyEHLAs9cuj9MBVPpkC3fusy3LBH1cdtBn2Yzmbaa0kwAe6Dw9Uzz8UOUo0MyZRp3T0qIHB9fQ3ji3ngMb5aAk7HlRdvK13YosDon4Y7MmvERSc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771556015; c=relaxed/simple;
	bh=WrXbSlSfXXpjtVD+4rsu4/vtS9d8dIHw5gOqkAg+h0c=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=pLe3blfutSW5C28VufZq/XOVgh7DHcG2ni8j7NXIc48kpARnX3GCBI0nF59HGm2BYHuRfmiKWDoun2eO1uI2WQDGr5Jyp4nu4c31KQ+/OHmsie/jOWMJlWYeWbNHcRxROrgV6ofRbdq4D5HhwijeywfQtoKSOS7FcxhO7/MTlhM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bT2c52O0; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1771556013; x=1803092013;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=WrXbSlSfXXpjtVD+4rsu4/vtS9d8dIHw5gOqkAg+h0c=;
  b=bT2c52O0zpcdSE2wtzM6gNHlhNFRmWwSh3pB1AQgQV6DPk+hiO6HOcXJ
   p2GNuOvayuRnwMWY0ENsud9W1kdCA96I8epoUIIgBS0PdTclG/Zw3Kw3X
   6jf8LryTP5IXuRMZh2AR9twBg/toMWDMQTlW3dEzh0uP2EeXOs5/8md9F
   ew3AEUNV38u7BruXZmoOMx7LxFbV7BiWmAwFF+xC7bhfat5TIJYc9gy6H
   LUCCmWAq5qg1H5OtDWnn5FYmwYcR69fynxxKpelty4hc9Wzf8fSr0juxj
   HwpYnma6Wa4oPn+S0sjJx1HImvWfq2nR3wxaLFqNtMfy1wVoprgnwqOBz
   Q==;
X-CSE-ConnectionGUID: L51ceK8DQiyKV4+SKfmdWg==
X-CSE-MsgGUID: 94OL5KUTQuasN0/uahrMLw==
X-IronPort-AV: E=McAfee;i="6800,10657,11706"; a="84108668"
X-IronPort-AV: E=Sophos;i="6.21,301,1763452800"; 
   d="scan'208";a="84108668"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2026 18:53:32 -0800
X-CSE-ConnectionGUID: DwWsBB6aRKyfkGfKZWCzRA==
X-CSE-MsgGUID: NIbFFXX4QxqCybXKsaqApg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,301,1763452800"; 
   d="scan'208";a="218870600"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2026 18:53:31 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Thu, 19 Feb 2026 18:53:30 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Thu, 19 Feb 2026 18:53:30 -0800
Received: from CH1PR05CU001.outbound.protection.outlook.com (52.101.193.68) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Thu, 19 Feb 2026 18:53:29 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dpHWHLVLiQkY07Vn9fHF75eckVCBNqgbf3rDFvPcvtpH0/CXmA9h3SLI+RPXKEnJNzhQtgIxubQVkRbRHGGXhxMdaR/GgDuAmCEHJF6atWcw1iDGhWijsTZvhSKi/UBBPPtA/R2V5EREgPAa/B384C7Ci9UjOY4lmkJrK7ZZqEVhYZpJ5V8PxKAqV0mkDibT4/SNeSda4TkNklKo2dBgtF5j9TFYyGBW88WCZMxpF5i/C9a7k0wKDqrTpO1vQzOomWJdZZK9sdJp6FQkxTC+YpsjGdTnZ7qsjjvXL7GwXK0h4Egg/ojS2Msh0vo4ZSivuhhSa2roPW8cYIXLNgk86A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mjctdFIIPmDXU739RGVZpncJY2rMu8QhubHpYWqBBaw=;
 b=KgATK/n72A65AFaGE7cC94CjmRENrCBNlWVDlkpzVK8MSXbi9YFt1+DOlOhfGUD04L3jTpo0F5RouF/zKi21xHWeTeN5mKo6HPNwAOhYh/dvNIiioJiC5oHRF0OptAklGRSuOWlMy+BaeiYkFlMFIImVouP08g9PwpRgB0IQawpTOrM/OOKQg/lbXfE3yVNGNTkgMY16/dMc8py9T2yFjcx9TdnemL9M2QvaH+8yPFK+FZS82CENIlEMEYq8ExfQcHqOfDK5Bx2s2msOZ20hMxT2NkHVlvWDAGkg62MDq6Swb4+LPC92ab6B7PL91/EbdYoZNVGv8sCq4UgPOeA6Yg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by CO1PR11MB5186.namprd11.prod.outlook.com (2603:10b6:303:9b::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.16; Fri, 20 Feb
 2026 02:53:26 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d%6]) with mapi id 15.20.9632.010; Fri, 20 Feb 2026
 02:53:26 +0000
Message-ID: <2ab556af-095b-422b-9396-f845c6fd0342@intel.com>
Date: Thu, 19 Feb 2026 18:53:22 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 13/19] x86/resctrl: Add PLZA state tracking and
 context switch handling
To: "Luck, Tony" <tony.luck@intel.com>, Ben Horgan <ben.horgan@arm.com>,
	"Moger, Babu" <Babu.Moger@amd.com>, "eranian@google.com" <eranian@google.com>
CC: "Moger, Babu" <bmoger@amd.com>, Drew Fustini <fustini@kernel.org>,
	"corbet@lwn.net" <corbet@lwn.net>, "Dave.Martin@arm.com"
	<Dave.Martin@arm.com>, "james.morse@arm.com" <james.morse@arm.com>,
	"tglx@kernel.org" <tglx@kernel.org>, "mingo@redhat.com" <mingo@redhat.com>,
	"bp@alien8.de" <bp@alien8.de>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"hpa@zytor.com" <hpa@zytor.com>, "peterz@infradead.org"
	<peterz@infradead.org>, "juri.lelli@redhat.com" <juri.lelli@redhat.com>,
	"vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
	"dietmar.eggemann@arm.com" <dietmar.eggemann@arm.com>, "rostedt@goodmis.org"
	<rostedt@goodmis.org>, "bsegall@google.com" <bsegall@google.com>,
	"mgorman@suse.de" <mgorman@suse.de>, "vschneid@redhat.com"
	<vschneid@redhat.com>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "pawan.kumar.gupta@linux.intel.com"
	<pawan.kumar.gupta@linux.intel.com>, "pmladek@suse.com" <pmladek@suse.com>,
	"feng.tang@linux.alibaba.com" <feng.tang@linux.alibaba.com>,
	"kees@kernel.org" <kees@kernel.org>, "arnd@arndb.de" <arnd@arndb.de>,
	"fvdl@google.com" <fvdl@google.com>, "lirongqing@baidu.com"
	<lirongqing@baidu.com>, "bhelgaas@google.com" <bhelgaas@google.com>,
	"seanjc@google.com" <seanjc@google.com>, "xin@zytor.com" <xin@zytor.com>,
	"Shukla, Manali" <Manali.Shukla@amd.com>, "dapeng1.mi@linux.intel.com"
	<dapeng1.mi@linux.intel.com>, "chang.seok.bae@intel.com"
	<chang.seok.bae@intel.com>, "Limonciello, Mario" <Mario.Limonciello@amd.com>,
	"naveen@kernel.org" <naveen@kernel.org>, "elena.reshetova@intel.com"
	<elena.reshetova@intel.com>, "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "peternewman@google.com"
	<peternewman@google.com>, "Shenoy, Gautham Ranjal" <gautham.shenoy@amd.com>
References: <aYyxAPdTFejzsE42@e134344.arm.com>
 <679dcd01-05e5-476a-91dd-6d1d08637b3e@intel.com>
 <aY3bvKeOcZ9yG686@e134344.arm.com>
 <2b2d0168-307a-40c3-98fa-54902482e861@intel.com>
 <aZM1OY7FALkPWmh6@e134344.arm.com>
 <d704ea1f-ed9f-4814-8fce-81db40b1ee3c@intel.com>
 <aZThTzdxVcBkLD7P@agluck-desk3>
 <2416004a-5626-491d-819c-c470abbe0dd0@intel.com>
 <aZTxJTWzfQGRqg-R@agluck-desk3>
 <65c279fd-0e89-4a6a-b217-3184bd570e23@intel.com>
 <aZXsihgl0B-o1DI6@agluck-desk3>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <aZXsihgl0B-o1DI6@agluck-desk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0182.namprd04.prod.outlook.com
 (2603:10b6:303:86::7) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|CO1PR11MB5186:EE_
X-MS-Office365-Filtering-Correlation-Id: 20bcc481-c4ac-45b8-504b-08de702b382e
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014|18082099003|13003099007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?OVBTRzVEakhNUHRacXFTdXFNWnFtTjF3anpITmVQNFF5SVNXUVl6bzd2cU1P?=
 =?utf-8?B?cTNWVnVoNUx6bERJQTZUb2RMeGRWY2N3SENadzFqMTJRcThkMStGa0FHU1Iv?=
 =?utf-8?B?QmY5NmlHNzZGSEFndEJnam5ZUkQrTzg1Q3g2WDZJbHJSeUI4bVIxSHVTOUxa?=
 =?utf-8?B?c2xvcTNLbVZuRXpWNkhBOGtzZEhwUmJwRmtscUE5MWlSbXVBNnhrYWZYN1RM?=
 =?utf-8?B?d3ozMmpGMms0Q0xwYkxUUEtxQk14UklQL1FsbHRzdjdBcTg0SWwrcnkyU2hi?=
 =?utf-8?B?eEIrbXE5d3YwaHExSFNIclVrWlplRk1ENzcyQmlUbWV0M1VtVlM2N0dKRnZS?=
 =?utf-8?B?WFJSWmVic1hTeWUwaGNpRDlObTZlSVJRWGdvY2lxakM4MHhMY1VRZFBGcmdu?=
 =?utf-8?B?OG1lS0lVMnFZRFAwQStxL2VhYU9WaW1iK3l5Y3c0VlZTTis3ZjRWd01ZMGpI?=
 =?utf-8?B?bkgrQTVnV2NINWpnLzFCZzk1R1B6VGVGSUw4NEdiOFdKdkVYbUFxMEYvek9i?=
 =?utf-8?B?bi9IdHdDZmNiRGNycUVUaHZlMk10eXdFUTUvaUpEalRabjNMNnpEemhDVzh1?=
 =?utf-8?B?TVdBYVA1S01sczdRVTA4ZlVZVzZDUU1MR0NXNjdSdUJqUUJKb1VoVzI5OUpz?=
 =?utf-8?B?a0syVURTT3lSZzJSdmJUREpISmZrZ2ZCS2x3NHBWNXJNMU5ZU09ZWUNmZGFK?=
 =?utf-8?B?SUFOTndzZytYbXIxRUZIWDlHMjRkWVUrQVRmOVQ3ZDRqeDg4WVhmVUlwUzFi?=
 =?utf-8?B?Zzc4aGs4TysxVTFVdzRQTzhDbGMySllEVmdsQUV4NU9ZckN3RWE4UWkwcWN1?=
 =?utf-8?B?WDhIL0x1aGJOb3NUSXVaZEszcUF3TWdEakc2YnM4R1ZydlVua1lTaDI4RHBj?=
 =?utf-8?B?YW16SVRuVld5Um1KTDIzSzFDYkU1T0tWa0VCMHNpVDh2dldqazZ0M3o2YjRm?=
 =?utf-8?B?VlB6UDBkQlBCQWNwVmNtcEtTeHRORXpkTUZzYUVCQXhWTDRQRHAwa1gvOS8x?=
 =?utf-8?B?QURuZVZ5RnUxYmQ0eWVTWm9VTW1yNTlzZktJUWVQOVY0cmpnMWpQM1pCMHFx?=
 =?utf-8?B?QUlYMlcvbUlqbHNVRHExamptOGY5cEV3N05hck5uVjRwWGllUVlnN1g4NXlI?=
 =?utf-8?B?TTdFZndrYjJkMHlvQzJSL2JjelhWZUU3b2NNNlplNStjbXJEOG56b0FHK3A0?=
 =?utf-8?B?WE9vVXVzNFZjMFFVUWgyLzREZUZWd2tFb0JZVmErRjNnUE5XVWIxY2ZtL1Zi?=
 =?utf-8?B?RlVaOURNVXJmYSt4bGtCYzE3Nm0wRHIzdjJsdVVkdmozanhUV05WQUtEVEFB?=
 =?utf-8?B?WE9LTlJrN2wvYXJ5ZGtTU0xUNjdJUWtuYjVrMXRVckRtOWcwWkgyUEYvdEEy?=
 =?utf-8?B?Z1g4blQ2eGU3eXcrVUV3R2JQVllPLzg0Q1YzSG83TWNCQ0tYMmJwdGFPa3Nw?=
 =?utf-8?B?UmFWZTFpN0FLWmpmMFN0VFVlUlRKUGpzK3o1QkxPTUYzUzFZREMrajdqK0ha?=
 =?utf-8?B?YWMydklsV2toWnhyT0MxVWVyTHJiU3pTTVJCdVVKWjJmaklxRTM2RlpOMVlJ?=
 =?utf-8?B?Mng0VU9GeG9oMkI4M0dqUlExUkNwSTBCV3dlM0VGVzVxZTVSbzRtdHVSTmpD?=
 =?utf-8?B?emxFZ1BQMkN6T1YwODc1Vmk4NVVQL0orT2wwWG5SSVVGdElrcERIZjdZVmxm?=
 =?utf-8?B?aitrTDRERFk1UHB1TmZJUGlac1hCZzIyanRxYU1mVXZTMGdDTm5ZcC9jSmxD?=
 =?utf-8?B?MEhuQTM3OThrQ2dJNGJuV05yNzVGK293Q0l6VkUyaVJxT0FzdU9hMUtkWmpv?=
 =?utf-8?B?amYyUXBMSDVCVnJUVUpINFROdGRQMHVKZnY1RlNydnpqcVdvMkxqeThMUWZp?=
 =?utf-8?B?cHNjUzE5aHZVNmw4bndqNWcvRXk3cDJhTHZDNnZZN1dPTkgzOFM2anEzRWZo?=
 =?utf-8?B?dWRmYVZNUkdURERpZnR0ZGxzQUxJMTJWNkpLM25zV1dGTW5VUXJjelFSVlB2?=
 =?utf-8?B?WVF0OXV5QWNURUhqRTRyeVAyU3VXTThIOGlyUHEwOTZKQ0tkWS9US2QxQ3pQ?=
 =?utf-8?B?QzdJMWxwOXBjMWJDemx0RW5hdUdqbzhQdWplTllzNG9ZLys1alE3bEY2anNn?=
 =?utf-8?Q?B0K8hEQQl8ZkATNR97MVpTae7?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(18082099003)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?K09yR29VSW1mbzBNTjBNSUtkZTc2a1hWeFAxOC9EL2ZDd2wzb3FGekp4aWZh?=
 =?utf-8?B?Q3JUeWZ4Skc0VitDYVVOVThZdGFzRHpRNXc0blhoa3FHdU5NYTB3VnpDS2ta?=
 =?utf-8?B?dkt6QVRRalBwTkJCVXZFTTl6cWpWNGRsWUFnaGZEVGhMcmFIOUFGYjJkY1lQ?=
 =?utf-8?B?N3M2dzJGN1RRaFkzeXhVaDNWTGpUaFQ4QUR3R2FrdXEyRGQ1Qzgvd0JCUFFX?=
 =?utf-8?B?Y3VDUjBVTys1ZUMxSi8wWVhzcXNkVXhnNW1vOXkvN0twRWE4SmtDSWFPUnZF?=
 =?utf-8?B?dEdrbFlMelF4SXBxWmtBZ3cvSU5pY3h1SDN2NUV4RDVMbC8vbklrdXJwaFNE?=
 =?utf-8?B?OWUxUlgrVWpTMHhhNTVTR3JYVTdWTmFBUENXM0FzSmZjWDZTRFJqemxSYzFC?=
 =?utf-8?B?R2s2UU9MMlpiMFVvRDRtcG95WFBMSHBrMEFkTDlYVWVLN3JidEdKRXpTZHVI?=
 =?utf-8?B?cFcwSWYybXpPMnV5eG9IRGowTGl6Uzd0UFR4VTh2QjNjRDVyaC80d2xjdEQ0?=
 =?utf-8?B?K01LaktWend3TklqcGViTEoxT0dEc2lLOTBEZURVOTlvRXl4U3FQNldFNjJY?=
 =?utf-8?B?Q2F4dWgvRTdyOEFuWEhDTFoxUitrb2IxSjREQ0JMUFl0T0tBcENKTFZjOXU5?=
 =?utf-8?B?UVdySFc0Z0luZTlvUWVCbGEyZ3BJcDFuNlJ5RjVrZ2k1K3RpTDdhNWdhZUQ0?=
 =?utf-8?B?L2FrY3NjQkRxUjBJZDRHV0lPcnBsVWNXT0lIOGl3dXRQVzArQUVsZUN2cXZC?=
 =?utf-8?B?bzZUQWhWcEpIbVAyZWtOTEhteUlRR2RvSnFlUUtLZjNGOWw1b0tCWVpjZkVL?=
 =?utf-8?B?OHBRSURjREk0bVJOMTMrVzFQc29lcUJkRlNPeVlkWmxSRWYvd3J5NWZHT1VI?=
 =?utf-8?B?TjMzcmZ6Qmk3L0N5MC9HenMybDV4eDVLOWE2TzdFUFRjaGVyWWM2S1pLTzdI?=
 =?utf-8?B?N205ZldIeUxFOW03YzBEaloxcWRjSlFkdlA1WHJoMWRSeVcyUEY3OWRZejJO?=
 =?utf-8?B?cDV2cFpaTnFEOEhlVmxQaXpySGdVVVBEb1p2R3p4TmFDS1lRSXpUMnFJYzdD?=
 =?utf-8?B?S0tUQ0lCUExWa21ybWtZK1hmRVhZUHZTeVFBM1k2Q2RkTFJhdnJVNXZGS3dh?=
 =?utf-8?B?U0gzc25VV0xPQk91OGpJRnk4K0JoQzlkL0g5d0ZMOU81SFdEbUdlYnJrYiti?=
 =?utf-8?B?d3E2UVFmajFCZmtkZ2pVd2RFSG1Vc1k2RTdHZUlRc0cvNktldlpFMVV4QXB3?=
 =?utf-8?B?eTBmMTRwVUdySHRjeWRCZFh1SlppcHVIVUlSTXRCa0ttbG1nMnZMc2FieVVj?=
 =?utf-8?B?REQ0R1R1OCtqWko2QzhMbSs3NFBCeStpTHBLSVpRcG55R0krSUZIcFNWb2V1?=
 =?utf-8?B?Rlh5K1ZGdllVUXk5SkFKbWpidkdCOCsrQ1UzcEQzbzQ5dzU4cS9FSEJEMEJV?=
 =?utf-8?B?dzhVa0Y0ZHcvQ0d3VUpveHozTFZkenhNZ0NhdGkzaDBnRVpUeUxCS2JGL09W?=
 =?utf-8?B?L3dZVWRBdnRuWVU5Rm9UNkJDNi9GWUpHOUpZbXhDbWFkQjN5TU9zZGdER2sz?=
 =?utf-8?B?ZlVwV3BQMHd1c0p0dERHUVc3bEJ3anFkWUYwRGNnV3FieU1VUkFsS0taaXMx?=
 =?utf-8?B?OXR1dlp4aDZQOG1lQ1ZIY1VKd0tRUjZnM1ZvbUtkK0hRK3FZSTFabUEzV0xU?=
 =?utf-8?B?ZW5UbXpLOHRtZE1yS0NKUVZONlE3Q3E3YW90cC9RbHVQNnYyTCszNkNOTEhV?=
 =?utf-8?B?d0p6RnBtaFl1MUVBcG5oYVphaktXNysyazhpeGY4bDY5L0tVZnhWT2hyY0NB?=
 =?utf-8?B?TVg2NjlQRGRZa2VkaEFaZExvaHJhcUtRbXA3emI4M0dZeUtQUExHNzdRaUFY?=
 =?utf-8?B?TzhPV2JuOHFyQWFQVWRtdVI4UHE2cGt5OEJsM0s3bzVEOTYvL3NDNU5OZzFP?=
 =?utf-8?B?OHNldjZpUU1iZEJTMDZaSUtLeXVFcHRYR2lKNEZmTFROV0xJaUdCNTZOWkR0?=
 =?utf-8?B?UW43TndtTDRscnJiOTR4eDJRUWRTUFpiZ3VaOUdDcnFCb2lvc3V3bkU1Y3RI?=
 =?utf-8?B?aGFicVFqK0lBVnlXTU9GOXNDSi9JZ1FBUlhmbm5IZW5SYm9uRitENnZZSjl3?=
 =?utf-8?B?M0VxMjY1YWE5aHhQSUZzcjJkK3B4SVNnMk5qNkplZkoyTkxlSGxBdDNua3Nx?=
 =?utf-8?B?cHlMTTFkWTFJMzJhTGlrcWpFbHNZSWNXZ3d3ZWhPRHBhWHFmYjB5anU2UTZo?=
 =?utf-8?B?QWY2bTBGTVdyMjBvNk9MYmpsMWMvWlprcmNsTVJIZ1hVRXpoSHduSitXQ0k3?=
 =?utf-8?B?a1dRZytOcUdkYkRrMm56RWpMa2RlTXB5Nmo2ampING56ZHFybThDL1QzbzdG?=
 =?utf-8?Q?Fss6hu6YbtkthtUw=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 20bcc481-c4ac-45b8-504b-08de702b382e
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2026 02:53:26.3130
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: n1nz+NAWOKmSxDdD5VtQe1tpH39EUfW2fWwyjKwbXElwsuoM5E8SZhaVIPomdimZrUIqC58MGvf8vVJoqNUD0AdqoT1+N29mXZRwciIBoHo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5186
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
	TAGGED_FROM(0.00)[bounces-71386-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,intel.com:mid,intel.com:dkim];
	MIME_TRACE(0.00)[0:+];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[46];
	DKIM_TRACE(0.00)[intel.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[reinette.chatre@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: 256491644F0
X-Rspamd-Action: no action

Hi Tony, Ben, Babu, and Stephane,

On 2/18/26 8:44 AM, Luck, Tony wrote:
> On Tue, Feb 17, 2026 at 03:55:44PM -0800, Reinette Chatre wrote:
>> Hi Tony,
>>
>> On 2/17/26 2:52 PM, Luck, Tony wrote:
>>> On Tue, Feb 17, 2026 at 02:37:49PM -0800, Reinette Chatre wrote:
>>>> Hi Tony,
>>>>
>>>> On 2/17/26 1:44 PM, Luck, Tony wrote:
>>>>>>>>> I'm not sure if this would happen in the real world or not.
>>>>>>>>
>>>>>>>> Ack. I would like to echo Tony's request for feedback from resctrl users
>>>>>>>>  https://lore.kernel.org/lkml/aYzcpuG0PfUaTdqt@agluck-desk3/
>>>>>>>
>>>>>>> Indeed. This is all getting a bit complicated.
>>>>>>>
>>>>>>
>>>>>> ack
>>>>>
>>>>> We have several proposals so far:
>>>>>
>>>>> 1) Ben's suggestion to use the default group (either with a Babu-style
>>>>> "plza" file just in that group, or a configuration file under "info/").
>>>>>
>>>>> This is easily the simplest for implementation, but has no flexibility.
>>>>> Also requires users to move all the non-critical workloads out to other
>>>>> CTRL_MON groups. Doesn't steal a CLOSID/RMID.
>>>>>
>>>>> 2) My thoughts are for a separate group that is only used to configure
>>>>> the schemata. This does allocate a dedicated CLOSID/RMID pair. Those
>>>>> are used for all tasks when in kernel mode.
>>>>>
>>>>> No context switch overhead. Has some flexibility.
>>>>>
>>>>> 3) Babu's RFC patch. Designates an existing CTRL_MON group as the one
>>>>> that defines kernel CLOSID/RMID. Tasks and CPUs can be assigned to this
>>>>> group in addition to belonging to another group than defines schemata
>>>>> resources when running in non-kernel mode.
>>>>> Tasks aren't required to be in the kernel group, in which case they
>>>>> keep the same CLOSID in both user and kernel mode. When used in this
>>>>> way there will be context switch overhead when changing between tasks
>>>>> with different kernel CLOSID/RMID.
>>>>>
>>>>> 4) Even more complex scenarios with more than one user configurable
>>>>> kernel group to give more options on resources available in the kernel.
>>>>>
>>>>>
>>>>> I had a quick pass as coding my option "2". My UI to designate the
>>>>> group to use for kernel mode is to reserve the name "kernel_group"
>>>>> when making CTRL_MON groups. Some tweaks to avoid creating the
>>>>> "tasks", "cpus", and "cpus_list" files (which might be done more
>>>>> elegantly), and "mon_groups" directory in this group.
>>>>
>>>> Should the decision of whether context switch overhead is acceptable
>>>> not be left up to the user? 
>>>
>>> When someone comes up with a convincing use case to support one set of
>>> kernel resources when interrupting task A, and a different set of
>>> resources when interrupting task B, we should certainly listen.
>>
>> Absolutely. Someone can come up with such use case at any time tough. This
>> could be, and as has happened with some other resctrl interfaces, likely will be
>> after this feature has been supported for a few kernel versions. What timeline
>> should we give which users to share their use cases with us? Even if we do hear
>> from some users will that guarantee that no such use case will arise in the
>> future? Such predictions of usage are difficult for me and I thus find it simpler
>> to think of flexible ways to enable the features that we know the hardware supports.
>>
>> This does not mean that a full featured solution needs to be implemented from day 1.
>> If folks believe there are "no valid use cases" today resctrl still needs to prepare for
>> how it can grow to support full hardware capability and hardware designs in the
>> future.
>>
>> Also, please also consider not just resources for kernel work but also monitoring for
>> kernel work. I do think, for example, a reasonable use case may be to determine
>> how much memory bandwidth the kernel uses on behalf of certain tasks.
>>  
>>>> I assume that, just like what is currently done for x86's MSR_IA32_PQR_ASSOC,
>>>> the needed registers will only be updated if there is a new CLOSID/RMID needed
>>>> for kernel space.
>>>
>>> Babu's RFC does this.
>>
>> Right.
>>
>>>
>>>>                   Are you suggesting that just this checking itself is too
>>>> expensive to justify giving user space more flexibility by fully enabling what
>>>> the hardware supports? If resctrl does draw such a line to not enable what
>>>> hardware supports it should be well justified.
>>>
>>> The check is likley light weight (as long as the variables to be
>>> compared reside in the same cache lines as the exisitng CLOSID
>>> and RMID checks). So if there is a use case for different resources
>>> when in kernel mode, then taking this path will be fine.
>>
>> Why limit this to knowing about a use case? As I understand this feature can be
>> supported in a flexible way without introducing additional context switch overhead
>> if the user prefers to use just one allocation for all kernel work. By being
>> configurable and allowing resctrl to support more use cases in the future resctrl
>> does not paint itself into a corner. This allows resctrl to grow support so that
>> the user can use all capabilities of the hardware with understanding that it will
>> increase context switch time.
>>
>> Reinette
> 
> How about this idea for extensibility.
> 
> Rename Babu's "plza" file to "plza_mode". Instead of just being an
> on/off switch, it may accept multiple possible requests.
> 
> Humorous version:
> 
> # echo "babu" > plza_mode
> 
> This results in behavior of Babu's RFC. The CLOSID and RMID assigned to
> the CTRL_MON group are used when in kernel mode, but only for tasks that
> have their task-id written to the "tasks" file or for tasks in the
> default group in the "cpus" or "cpus_list" files are used to assign
> CPUs to this group.
> 
> # echo "tony" > plza_mode
> 
> All tasks run with the CLOSID/RMID for this group. The "tasks", "cpus" and
> "cpus_list" files and the "mon_groups" directory are removed.
> 
> # echo "ben" > plza_mode"
> 
> Only usable in the top-level default CTRL_MON directory. CLOSID=0/RMID=0
> are used for all tasks in kernel mode.
> 
> # echo "stephane" > plza_mode
> 
> The RMID for this group is freed. All tasks run in kernel mode with the
> CLOSID for this group, but use same RMID for both user and kernel.
> In addition to files removed in "tony" mode, the mon_data directory is
> removed.
> 
> # echo "some-future-name" > plza_mode
> 
> Somebody has a new use case. Resctrl can be extended by allowing some
> new mode.
> 
> 
> Likely real implementation:
> 
> Sub-components of each of the ideas above are encoded as a bitmask that
> is written to plza_mode. There is a file in the info/ directory listing
> which bits are supported on the current system (e.g. the "keep the same
> RMID" mode may be impractical on ARM, so it would not be listed as an
> option.)

I like the idea of a global file that indicates what is supported on the
system. I find this to match Ben's proposal of a "kernel_mode" file in
info/ that looks to be a good foundation to build on. Ben also reiterated support
for this in
https://lore.kernel.org/lkml/feaa16a5-765c-4c24-9e0b-c1f4ef87a66f@arm.com/

As I mentioned in https://lore.kernel.org/lkml/5c19536b-aca0-42ce-a9d5-211fbbdbb485@intel.com/
the suggestions surrounding the per-resource group "plza_mode" file
are unexpected since they ignore earlier comments about impact on user space.
Specifically, this proposal does not address:
https://lore.kernel.org/lkml/aY3bvKeOcZ9yG686@e134344.arm.com/
https://lore.kernel.org/lkml/c779ce82-4d8a-4943-b7ec-643e5a345d6c@arm.com/

Below I aim to summarize the discussions as they relate to constraints and
requirements. I intended to capture all that has been mentioned in these
discussions so far so if I did miss something it was not intentional and
please point this out to help make this summary complete.

I hope by starting with this we can start with at least agreeing what
resctrl needs to support and how user space could interact with resctrl
to meet requirements.

After the summary of what resctrl needs to support I aim to combine
capabilities from the various proposals to meet the constraints and
requirements as I understand them so far. This aims to build on all that
has been shared until now.

Any comments are appreciated.

Summary of considerations surrounding CLOSID/RMID (PARTID/PMG) assignment for kernel work
=========================================================================================

- PLZA currently only supports global assignment (only PLZA_EN of
  MSR_IA32_PQR_PLZA_ASSOC may differ on logical processors). Even so, current
  speculation is that RMID_EN=0 implies that user space RMID is used to monitor
  kernel work that could appear to user as "kernel mode" supporting multiple RMIDs.
  https://lore.kernel.org/lkml/abb049fa-3a3d-4601-9ae3-61eeb7fd8fcf@amd.com/

- MPAM can set unique PARTID and PMG on every logical processor.
  https://lore.kernel.org/lkml/fd7e0779-7e29-461d-adb6-0568a81ec59e@arm.com/

- While current PLZA only supports global assignment it may in future generations
  not require MSR_IA32_PQR_PLZA_ASSOC to be same on logical processors. resctrl
  thus needs to be flexible here.
  https://lore.kernel.org/lkml/fa45088b-1aea-468e-8253-3238e91f76c7@amd.com/

- No equivalent feature on RISC-V.
  https://lore.kernel.org/lkml/aYvP98xGoKPrDBCE@gen8/

- Impact on context switch delay is a concern and unnecessary context switch delay should
  be avoided.
  https://lore.kernel.org/lkml/aZThTzdxVcBkLD7P@agluck-desk3/
  https://lore.kernel.org/lkml/CABPqkBSq=cgn-am4qorA_VN0vsbpbfDePSi7gubicpROB1=djw@mail.gmail.com/

- There is no requirement that a CLOSID/PARTID should be dedicated to kernel work.
  Specifically, same CLOSID/PARTID can be used for user space and kernel work.
  Also directly requested to not make kernel work CLOSID/PARTID exclusive:
  https://lore.kernel.org/lkml/c8268b2a-50d7-44b4-ac3f-5ce6624599b1@arm.com/

- Only use case presented so far is related to memory bandwidth allocation where
  all kernel work is done unthrottled or equivalent to highest priority tasks while
  monitoring remains associated to task self.
  https://lore.kernel.org/lkml/CABPqkBSq=cgn-am4qorA_VN0vsbpbfDePSi7gubicpROB1=djw@mail.gmail.com/
  PLZA can support this with its global allocation (assuming RMID_EN=0 associates user
  RMID with kernel work) To support this use case MPAM would need to be able to
  change both PARTID and PMG:
  https://lore.kernel.org/lkml/845587f3-4c27-46d9-83f8-6b38ccc54183@arm.com/

- Motivation of this work is to run kernel work with more/all/unthrottled
  resources to avoid priority inversions. We need to be careful with such
  generalization since not all resource allocations are alike yet a CLOSID/PARTID
  assignment applies to all resources. For example, user may designate a cache
  portion for high priority user space work and then needs to choose which cache
  portions the kernel may allocate into.
  https://lore.kernel.org/lkml/6293c484-ee54-46a2-b11c-e1e3c736e578@arm.com/
  - If all kernel work is done using the same allocation/CLOSID/PARTID then user
    needs to decide whether the kernel work's cache allocation overlaps the high
    priority tasks or not. To avoid evicting high priority task work it may be
    simplest for kernel allocation to not overlap high priority work but kernel work
    done on behalf of high priority work would then risk eviction by low priority
    work.
  - When considering cache allocation it seems more flexible to have high priority
    work keep its cache allocation when entering the kernel? This implies more than
    one CLOSID/PARTID may need to be used for kernel work.


TBD
===
- What is impact of different controls (for example the upcoming MAX) when tasks are
  spread across multiple control groups?
  https://lore.kernel.org/lkml/aY3bvKeOcZ9yG686@e134344.arm.com/

How can MPAM support the "monitor kernel work with user space work" use case?
=============================================================================
This considers how MPAM could support the use case presented in:
https://lore.kernel.org/lkml/CABPqkBSq=cgn-am4qorA_VN0vsbpbfDePSi7gubicpROB1=djw@mail.gmail.com/

To support this use case in MPAM the control group that dictates the allocations
used in kernel work has to have monitor group(s) where this usage is tracked and user
space would need to sum the kernel and user space usage. The number of PMG may vary
and resctrl cannot assume that the kernel control group would have sufficient monitor
groups to map 1:1 with user space control and monitor groups. Mapping user space
control and monitor groups to kernel monitor groups thus seems best to be done by
user space.

Some examples:
Consider allocation and monitoring setup for user space work:
	/sys/fs/resctrl <= User space default allocations
	/sys/fs/resctrl/g1 <= User space allocations g1
	/sys/fs/resctrl/g1/mon_groups/g1m1 <= User space monitoring group g1m1
	/sys/fs/resctrl/g1/mon_groups/g1m2 <= User space monitoring group g1m2
	/sys/fs/resctrl/g2 <= User space allocations g2
	/sys/fs/resctrl/g2/mon_groups/g2m1 <= User space monitoring group g2m1
	/sys/fs/resctrl/g2/mon_groups/g2m2 <= User space monitoring group g2m2

Having a single control group for kernel work and a system that supports
7 PMG per PARTID makes it possible to have a monitoring group for each user space
monitoring group:
(will go more into how such assignments can be made later)

	/sys/fs/resctrl/kernel <= Kernel space allocations 
	/sys/fs/resctrl/kernel/mon_data               <= Kernel space monitoring default group
	/sys/fs/resctrl/kernel/mon_groups/kernel_g1   <= Kernel space monitoring group g1
	/sys/fs/resctrl/kernel/mon_groups/kernel_g1m1 <= Kernel space monitoring group g1m1
	/sys/fs/resctrl/kernel/mon_groups/kernel_g1m2 <= Kernel space monitoring group g1m2
	/sys/fs/resctrl/kernel/mon_groups/kernel_g2   <= Kernel space monitoring group g2
	/sys/fs/resctrl/kernel/mon_groups/kernel_g2m1 <= Kernel space monitoring group g2m1
	/sys/fs/resctrl/kernel/mon_groups/kernel_g2m2 <= Kernel space monitoring group g2m2

With a configuration as above user space can sum the monitoring events of the user space
groups and associated kernel space groups to obtain counts of all work done on behalf of
associated tasks.

It may not be possible to have such 1:1 relationship and user space would have to
arrange groups to match its usage. For example if system only supports two PMG per PARTID
then user space may find it best to track monitoring as below:
	/sys/fs/resctrl/kernel <= Kernel space allocations 
	/sys/fs/resctrl/kernel/mon_data               <= Kernel space monitoring for all of default and g1
	/sys/fs/resctrl/kernel/mon_groups/kernel_g2   <= Kernel space monitoring for all of g2


Requirements
============
Based on understanding of what PLZA and MPAM is (and could be) capable of while considering the
use case presented thus far it seems that resctrl has to:
- support global assignment of resource group for kernel work
- support per-resource group assignment for kernel work

How can resctrl support the requirements?
=========================================

New global resctrl fs files
===========================
info/kernel_mode (always visible)
info/kernel_mode_assignment (visibility and content depends on active setting in info/kernel_mode)

info/kernel_mode
================
- Displays the currently active as well as possible features available to user
  space.
- Single place where user can query "kernel mode" behavior and capabilities of the
  system.
- Some possible values:
  - inherit_ctrl_and_mon <=== previously named "match_user", just renamed for consistency with other names
     When active, kernel and user space use the same CLOSID/RMID. The current status
     quo for x86.
  - global_assign_ctrl_inherit_mon
     When active, CLOSID/control group can be assigned for *all* (hence, "global")
     kernel work while all kernel work uses same RMID as user space.
     Can only be supported on architecture where CLOSID and RMID are independent.
     An arch may support this in hardware (RMID_EN=0?) or this can be done by resctrl during
     context switch if the RMID is independent and the context switches cost is
     considered "reasonable". 
     This supports use case https://lore.kernel.org/lkml/CABPqkBSq=cgn-am4qorA_VN0vsbpbfDePSi7gubicpROB1=djw@mail.gmail.com/
     for PLZA.
  - global_assign_ctrl_assign_mon
     When active the same resource group (CLOSID and RMID) can be assigned to
     *all* kernel work. This could be any group, including the default group.
     There may not be a use case for this but it could be useful as an intemediate
     step of the mode that follow (more later).
  - per_group_assign_ctrl_assign_mon
     When active every resource group can be associated with another (or the same)
     resource group. This association maps the resource group for user space work
     to resource group for kernel work. This is similar to the "kernel_group" idea
     presented in:
     https://lore.kernel.org/lkml/aYyxAPdTFejzsE42@e134344.arm.com/
     This addresses use case https://lore.kernel.org/lkml/CABPqkBSq=cgn-am4qorA_VN0vsbpbfDePSi7gubicpROB1=djw@mail.gmail.com/
     for MPAM.
- Additional values can be added as new requirements arise, for example "per_task"
  assignment. Connecting visibility of info/kernel_mode_assignment to mode in
  info/kernel_mode enables resctrl to later support additional modes that may require
  different configuration files, potentially per-resource group like the "tasks_kernel"
  (or perhaps rather "kernel_mode_tasks" to have consistent prefix for this feature)
  and "cpus_kernel" ("kernel_mode_cpus"?) discussed in these threads.
  
User can view active and supported modes:

	# cat info/kernel_mode
	[inherit_ctrl_and_mon]
	global_assign_ctrl_inherit_mon
	global_assign_ctrl_assign_mon

User can switch modes:
	# echo global_assign_ctrl_inherit_mon > kernel_mode
	# cat kernel_mode
	inherit_ctrl_and_mon
	[global_assign_ctrl_inherit_mon]
	global_assign_ctrl_assign_mon


info/kernel_mode_assignment
===========================
- Visibility depends on active mode in info/kernel_mode.
- Content depends on active mode in info/kernel_mode
- Syntax to identify resource groups can use the syntax created as part of earlier ABMC work
  that supports default group https://lore.kernel.org/lkml/cover.1737577229.git.babu.moger@amd.com/
- Default CTRL_MON group and if relevant, the default MON group, can be the default
  assignment when user just changes the kernel_mode without setting the assignment.

info/kernel_mode_assignment when mode is global_assign_ctrl_inherit_mon
-----------------------------------------------------------------------
- info/kernel_mode_assignment contains single value that is the name of the control group
  used for all kernel work.
- CLOSID/PARTID used for kernel work is determined from the control group assigned
- default value is default CTRL_MON group
- no monitor group assignment, kernel work inherits user space RMID
- syntax is
    <CTRL_MON group> with "/" meaning default.

info/kernel_mode_assignment when mode is global_assign_ctrl_assign_mon
-----------------------------------------------------------------------
- info/kernel_mode_assignment contains single value that is the name of the resource group
  used for all kernel work.
- Combined CLOSID/RMID or combined PARTID/PMG is set globally to be associated with all
  kernel work.
- default value is default CTRL_MON group
- syntax is
    <CTRL_MON group>/MON group>/ with "//" meaning default control and default monitoring group.

info/kernel_mode_assignment when mode is per_group_assign_ctrl_assign_mon
-------------------------------------------------------------------------
- this presents the information proposed in https://lore.kernel.org/lkml/aYyxAPdTFejzsE42@e134344.arm.com/
  within a single file for convenience and potential optimization when user space needs to make changes.
  Interface proposed in https://lore.kernel.org/lkml/aYyxAPdTFejzsE42@e134344.arm.com/ is also an option
  and as an alternative a per-resource group "kernel_group" can be made visible when user space enables
  this mode.
- info/kernel_mode_assignment contains a mapping of every resource group to another resource group:
  <resource group for user space work>:<resource group for kernel work>
- all resource groups must be present in first field of this file
- Even though this is a "per group" setting expectation is that this will set the
  kernel work CLOSID/RMID for every task. This implies that writing to this file would need
  to access the tasklist_lock that, when taking for too long, may impact other parts of system.
  See https://lore.kernel.org/lkml/CALPaoCh0SbG1+VbbgcxjubE7Cc2Pb6QqhG3NH6X=WwsNfqNjtA@mail.gmail.com/

Scenarios supported
===================

Default
-------
For x86 I understand kernel work and user work to be done with same CLOSID/RMID which
implies that info/kernel_mode can always be visible and at least display:
	# cat info/kernel_mode
	[inherit_ctrl_and_mon]

info/kernel_mode_assignment is not visible in this mode.

I understand MPAM may have different defaults here so would like to understand better.

Dedicated global allocations for kernel work, monitoring same for user space and kernel (PLZA)
----------------------------------------------------------------------------------------------
Possible scenario with PLZA, not MPAM (see later):
1. Create group(s) to manage allocations associated with user space work
   and assign tasks/CPUs to these groups.
2. Create group to manage allocations associated with all kernel work.
   - For example,
	# mkdir /sys/fs/resctrl/unthrottled
   - No constraints from resctrl fs on interactions with files in this group. From resctrl
     fs perspective it is not "dedicated" to kernel work but just another resource group.
     User space can still assign tasks/CPUs to this group that will result in this group
     to be used for both kernel and user space control and monitoring. If user space wants
     to dedicate a group to kernel work then they should not assign tasks/CPUs to it.
3. Set kernel mode to global_assign_ctrl_inherit_mon:
	# echo global_assign_ctrl_inherit_mon > info/kernel_mode
  - info/kernel_mode_assignment becomes visible and contains "/"  to indicate that default
    resource group is used for all kernel work
  - Sets the "global" CLOSID to be used for kernel work to 0, no setting of global RMID.
4. Set control group to be used for all kernel work:
	# echo unthrottled > info/kernel_mode_assignment
    - Sets the "global" CLOSID to be used for kernel work to CLOSID associated with
      CTRL_MON group named "unthrottled", no change to global RMID.


Dedicated global allocations and monitoring for kernel work
-----------------------------------------------------------
- Step 1 and 2 could be the same as above.
OR
2b. If there is an "unthrottled" control group that is used for both user space and kernel
    allocations a separate MON group can be used to track monitoring data for kernel work.
   - For example,
	# mkdir /sys/fs/resctrl/unthrottled <=== All high priority work, kernel and user space
	# mkdir /sys/fs/resctrl/unthrottled/mon_groups/kernel_unthrottled <= Just monitor kernel work

3. Set kernel mode to global_assign_ctrl_assign_mon:
	# echo global_assign_ctrl_assign_mon > info/kernel_mode
  - info/kernel_mode_assignment becomes visible and contains "//" - default CTRL_MON is
    used for all kernel work allocations and monitoring
  - Sets both the "global" CLOSID and RMID to be used for kernel work to 0.
4. Set control group to be used for all kernel work:
	# echo unthrottled/kernel_unthrottled > info/kernel_mode_assignment
    - Sets the "global" CLOSID to be used for kernel work to CLOSID associated with
      CTRL_MON group named "unthrottled" and RMID used for kernel work to RMID
      associated with child MON group within "unthrottled" group named "kernel_untrottled".

Dedicated global allocations for kernel work, monitoring same for user space and kernel (MPAM)
----------------------------------------------------------------------------------------------
1. User space creates resource and monitoring groups for user tasks:
 	/sys/fs/resctrl <= User space default allocations
	/sys/fs/resctrl/g1 <= User space allocations g1
	/sys/fs/resctrl/g1/mon_groups/g1m1 <= User space monitoring group g1m1
	/sys/fs/resctrl/g1/mon_groups/g1m2 <= User space monitoring group g1m2
	/sys/fs/resctrl/g2 <= User space allocations g2
	/sys/fs/resctrl/g2/mon_groups/g2m1 <= User space monitoring group g2m1
	/sys/fs/resctrl/g2/mon_groups/g2m2 <= User space monitoring group g2m2

2. User space creates resource and monitoring groups for kernel work (system has two PMG):
	/sys/fs/resctrl/kernel <= Kernel space allocations 
	/sys/fs/resctrl/kernel/mon_data               <= Kernel space monitoring for all of default and g1
	/sys/fs/resctrl/kernel/mon_groups/kernel_g2   <= Kernel space monitoring for all of g2
3. Set kernel mode to per_group_assign_ctrl_assign_mon:
	# echo per_group_assign_ctrl_assign_mon > info/kernel_mode
   - info/kernel_mode_assignment becomes visible and contains
	# cat info/kernel_mode_assignment
	//://
	g1//://
	g1/g1m1/://
	g1/g1m2/://
	g2//://
	g2/g2m1/://
	g2/g2m2/://
   - An optimization here may be to have the change to per_group_assign_ctrl_assign_mon mode be implemented
     similar to the change to global_assign_ctrl_assign_mon that initializes a global default. This can
     avoid keeping tasklist_lock for a long time to set all tasks' kernel CLOSID/RMID to default just for
     user space to likely change it.
4. Set groups to be used for kernel work:
	# echo '//:kernel//\ng1//:kernel//\ng1/g1m1/:kernel//\ng1/g1m2/:kernel//\ng2//:kernel/kernel_g2/\ng2/g2m1/:kernel/kernel_g2/\ng2/g2m2/:kernel/kernel_g2/\n' > info/kernel_mode_assignment

The interfaces proposed aim to maintain compatibility with existing user space tools while
adding support for all requirements expressed thus far in an efficient way. For an existing
user space tool there is no change in meaning of any existing file and no existing known
resource group files are made to disappear. There is a global configuration that lets user space
manage allocations without needing to check and configure each control group, even per-resource
group allocations can be managed from user space with a single read/write to support
making changes in most efficient way.

What do you think?

Reinette


