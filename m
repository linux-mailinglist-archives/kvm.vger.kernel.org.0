Return-Path: <kvm+bounces-52077-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 24F1DB01041
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 02:34:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 187631C8197C
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 00:34:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75B2412B73;
	Fri, 11 Jul 2025 00:33:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="N21pXti+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCCA4DF42;
	Fri, 11 Jul 2025 00:33:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752194033; cv=fail; b=b7Xlj/3uZDENMjwI3aD0SADYleH8AR3vchr4ImIR/JhfNQB5LnpjxKcQSywT3hW5DDKSLnffIQ0hv3NcYYle1FU1GFS64oatSfAH1EHi/Lh5wsOfr9PXVuoAhefew5Qpfy76e8z5t3l2ztZAEReRKaLbuc5ibyhu1+mgBcWXaUA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752194033; c=relaxed/simple;
	bh=tCLwpf5SEsgDAVzMFRQawQQ26nG9Vo/7hLcpbsuk4dM=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=q2sjWyrYW1L9maBGWDxHMYpxyQwypfHMSfoA4SeyVP/kXwhmi4ZnobRr4YctCNUMDtX7UNV1nd0C4uHOBd55GBZp16aWjLsv4vDJBn5/MW0K7ua4gfa6YB15TrXv+lqx1qL6cqa/G6OLrm1ml8QyLJaJFuRdwQ1DaTAQURnCiMM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=N21pXti+; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752194032; x=1783730032;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=tCLwpf5SEsgDAVzMFRQawQQ26nG9Vo/7hLcpbsuk4dM=;
  b=N21pXti+1OWplN62QchZw4gQMYPJz6GuLwuKX3RMfVHnVeSOR76Reuc2
   dxu4ZxOUKIfScpVHqVOYIEGsDI7OIU0QHynCo6wkWPF9iAHqtANdZ5cH3
   SYpYSPSgRkqj3CeprMO6OMSo/pQMrfIAMYRE4V7Eo8WX9rwrv+c7+Ei8T
   5TNfOKdHy4sARyjeuJsni7Me8m013rY9EtprHIp5uix7rhzCOaN02/hV7
   s5AacMLsueuXJkqwr/PJwuBcqJ4SDzFekgvAdlMD5TI3OGm+bSJ5YDxzt
   dLQHIHWErdRRPdpWDDgwagP49TVZg7Vl6VfPKl755zrViKrT7OraJAnIF
   Q==;
X-CSE-ConnectionGUID: Q5y4v+AZQJuDOWmfXdYQaw==
X-CSE-MsgGUID: hhBGsFc0Q0O9cEwYuV2M8A==
X-IronPort-AV: E=McAfee;i="6800,10657,11490"; a="71937099"
X-IronPort-AV: E=Sophos;i="6.16,302,1744095600"; 
   d="scan'208";a="71937099"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2025 17:33:32 -0700
X-CSE-ConnectionGUID: gr1RlaHRQyqMhvbybFPMXA==
X-CSE-MsgGUID: WMHGEycLREubACXzBtSh6Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,302,1744095600"; 
   d="scan'208";a="187217011"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2025 17:33:30 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 10 Jul 2025 17:33:29 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Thu, 10 Jul 2025 17:33:29 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (40.107.94.82) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 10 Jul 2025 17:33:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Bm6fa7Xo+PfsKxEmTFOSg0msmr306wBatBllR3V8hw9q3sjXkhmULyOsuwOlcIISXnbojhZ6pUO5xXGGP/vByFh+TH1hgyKsBTnhHUHoSoV3kSJ6KAm2S2tie5UYbe64nq+Gn67UdBJnVwmYXVG2lfCZXYSxrQ9NZhO3JNcsGzIkoirt75+wpH7zK5NR93ZXfl0nnC4tDU5mFDVReiNbJl0v7JQDVJU077StIPLF6P1phuNCOyN5tlIAW4y3h+luS2EnZDMRmq3/hXrd7HizXtB8H4U/rTyfR3Gmvh5dgCq/kmeYfK1EnMpso2fXgApDIWiD6CLIH0tAwjF5updVXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Nq4Lq/5SnerArPBl+wTkmd7pNTMSr72lF2+UhTCV8L0=;
 b=RF9PNrggPvRTw/WKKfSXM3BiUFFe/cJmizwt4SDXSURwOvZrmUCZ7B+9U6dydzLWJUnBFcMpgsOanJcZQM6v7ROVAzGAryD52Sxd6LhSczhLcHuOcfwY/u1POAu+Vs+37ixnBAdZQVnYY1lgwWGMOXsDhwQKnjSec4sZIDCljFmxqSdyKm1ZLrp6d3lgpQzrUXe3dwDU41jGX92rBs/y/lEKNLGGo9tSl6lVFqiYmFLUb4TpN3QaFZK70iZGDZZrLoGUThywuVPdQUpAYIwr8kVygqLoys1fWIuSbzODAp5KpI/spYkNDMOmLRRL9SPx/8nt6ZTzvMIPnY1XY8Z1bA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BYAPR11MB3320.namprd11.prod.outlook.com (2603:10b6:a03:18::25)
 by SA0PR11MB4525.namprd11.prod.outlook.com (2603:10b6:806:9d::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.27; Fri, 11 Jul
 2025 00:32:55 +0000
Received: from BYAPR11MB3320.namprd11.prod.outlook.com
 ([fe80::e8c4:59e3:f1d5:af3b]) by BYAPR11MB3320.namprd11.prod.outlook.com
 ([fe80::e8c4:59e3:f1d5:af3b%7]) with mapi id 15.20.8901.024; Fri, 11 Jul 2025
 00:32:55 +0000
Message-ID: <a2d0c1ac-eac1-4972-b110-1611d1733d7e@intel.com>
Date: Thu, 10 Jul 2025 17:32:53 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 05/10] x86/nmi: Assign and register NMI-source vectors
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
 <20250612214849.3950094-6-sohil.mehta@intel.com>
 <CY8PR11MB71349E0943913F8AE944B3EF894FA@CY8PR11MB7134.namprd11.prod.outlook.com>
 <9dd8771d-ce4f-4bfb-8fbd-571f3e188514@intel.com>
 <CY8PR11MB71344115BD680973922C3670894EA@CY8PR11MB7134.namprd11.prod.outlook.com>
From: Sohil Mehta <sohil.mehta@intel.com>
In-Reply-To: <CY8PR11MB71344115BD680973922C3670894EA@CY8PR11MB7134.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY1P220CA0008.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:59d::16) To BYAPR11MB3320.namprd11.prod.outlook.com
 (2603:10b6:a03:18::25)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR11MB3320:EE_|SA0PR11MB4525:EE_
X-MS-Office365-Filtering-Correlation-Id: 0e5fb433-f27b-480c-aee1-08ddc0127a49
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?eHFLTy8zS1RuVW92MHFUSkR4L2ZKU2RJZ3N5NnhZbzlFSE4rMjZyQTRkUWY5?=
 =?utf-8?B?V2UvRXlHdlJuNkFjZDJJQ2xVbjFhK0J3ekNoM0VBd3dUNVJGRUo1and4eWYy?=
 =?utf-8?B?MlFjV0s5bEdzOWhOdXhkU3I5ZkN0U2NwUFltdGJmUHp1aDRlR1ZjQTJiSE4x?=
 =?utf-8?B?UTV1TysrZnpuZnJIQzlOMldzdDJTYk9TZ2ZuVi8vSzdaZHRsZitIbUhNUkhQ?=
 =?utf-8?B?MVhMYmRRRG9IUDNQaURJeHZJSlVIbVRTNlhIWm9MMTVpcUZPUlluMGZDRHIr?=
 =?utf-8?B?N3N3SzNPa3B1K2luN20wT3BZMU5FWXNCd1hZWmFTdmpFWHJvQ2p5UXMvRnMr?=
 =?utf-8?B?OTBVMFByYVMzRHZUenJUTDZSYUY4ZFVzY3UyNDJ2U2R4azZwcmxvc3lieW5N?=
 =?utf-8?B?bHZZL1FjOWxkS2I1V2Q0T1drOXdzL3R5OUZnZUU5R3p5QWkzRStZV1huZ2pM?=
 =?utf-8?B?d1lLZWRjek0wNlNPb1ZZeEFiOFhCWFl0QzZXNVhacGZZRlpnRncvZHZDbDlt?=
 =?utf-8?B?Y093NWpuNktkYmRFM0NndlNtcHN4MlhoeDcvcDYvQkFXUEVTeDZaRHpzNGpn?=
 =?utf-8?B?bVZ6Zy9pRi9WQ2I0bkpQckdBTk5pNFdlbjM2SXp2Mk1RRkptakE1Wm9tMmZF?=
 =?utf-8?B?MTUxUVlPR0QzZ3JycVVWa0I5dFJOK1BUYlZoeHVhaFVWSlFhRTJTRVNYT0Er?=
 =?utf-8?B?cmRVLzBvaUh4QlE3czRpa2dVT2pMRllGMzFINHZ5MiswR2pDelZxVVI4MWJk?=
 =?utf-8?B?UmpaTGRiYk5JQkczeFlXKzZlam5qRnNQSWFqKzEvV0Fkc2RGUnVNdCtuTzVK?=
 =?utf-8?B?Y2JqTUhNZ05qUzdhZ3hHTkVjb2l0Myt0WmNJU2d4MmExeXEzYzhTTitFTVZR?=
 =?utf-8?B?RDUyc2JoakhSbk5uajZ3Rlhlb3VteEpiR1Btc0c1MlRWWDFMcFowbTROVTVK?=
 =?utf-8?B?VSt0NjJBUmZlT3IxU0xHR2dYSmY4MjlDdEYzRUdlZU1lM0ZSbUdlNzd1NDRW?=
 =?utf-8?B?UnNXbnhLR0wwYXgxYXpJb2JieHU2MlJsZnRyQkF5VEpCZjlTTThPSE44Q3N0?=
 =?utf-8?B?cEhwNTR5dDZiQ3ZaTENXeGg4dnhmU2FqbDkvazZMZE1PSDVwQ20wMHpjamRK?=
 =?utf-8?B?bldyeEhnMnI3ai9QZnFmTTNDelg0djFGbHdONjRGbUZMb3Jod2QrQ3EvWHlx?=
 =?utf-8?B?UXBkMTBoajFKRUdkdnZTM2t4VktXL0kyNDltL1BwRi9vZ1ZNMkZxellsUUhu?=
 =?utf-8?B?b3pUZnRlL0pGdlJtN09TN1U3bFpyOFFtRmNoUmdHMlR0dzg1VnhTbjVCSXlw?=
 =?utf-8?B?dzE3emRIT2ZkdjYyUk0vVlE2aC9EeFFLKzFwbFViOXZOYnNENzlBUm5nbGZy?=
 =?utf-8?B?YkQzVDVBbGpnTThFT2VKNlpsTXcvS255c0xtUUliVjBRekdsWmtlT3BYUDNW?=
 =?utf-8?B?NlB4bnNMY0d6WGVhdlYzUlh4WjVSc1NXdDVBakVuRjZsNmF2SDQveWcxM1dv?=
 =?utf-8?B?ajV4UTcxSml2MVlqRDdiOUhXNUdNVGcxNjFCVkFQT1Q4Q1o2aUtGdTR0b21M?=
 =?utf-8?B?UmJSOWtVSGM2ZWZDZVUxMUZQZ0RHSVplbUorSGZMK1pRWGdMWWFnZEdiTTdz?=
 =?utf-8?B?N3RQMlRtZWtGT2IvVGJPUENkQjYzY1VHdVQ4VzArK0RjS2FwMVJMeWNpUUdC?=
 =?utf-8?B?cWNWdWVrNi9DUERrRkJHdHJkeFhtdDVOakJlb2J6RjJNeHVYVDNjR04zNHhr?=
 =?utf-8?B?WjJiVVkwWTJnWVY3RVF6RWFhb1l5UFQ1M0RYSThuUzE2U2VvVHFQOWUxMXAw?=
 =?utf-8?B?Z3JMYlYxRTR6MmtWWHZ0VlBEQUZnazhpMDljemJ6OWRjblNvZXllczk1U2xk?=
 =?utf-8?B?TEdpNTNsUUxKak9FbGtoSG15Wi9GaURHSFdCWEJJb2pVVHhLSUsxV0wzZC9P?=
 =?utf-8?Q?ZRYrOqe2QVU=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3320.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UGJneTVzVCthY0ZvbmRuRG9UYTNGN2lSVUZ1WCtUV1Z0TkpYdjFKSWU0bVpt?=
 =?utf-8?B?YnFyNWw4VFpseVF5WkVZb01YVGlUSmg3NWxzUFBlbkpiOEVDUVVMSlVZRUtp?=
 =?utf-8?B?MUw2LzJzUTJMTUhPMUMwdnIva21KRXFPb2haTWhSdnovbSt4bzl4dm5EazZT?=
 =?utf-8?B?c1lkVnFQT1phRGpJdDZTdzdaT2gvWXB5UHFsck5CN1MzNkFCc3Y2cE5PdFYz?=
 =?utf-8?B?UGNPTDBGUENXZE1ZaEI5QzhRWklCTzZIdVFXdzUvU3VWSS9nbTRhZno1SmY2?=
 =?utf-8?B?bG1pL2J1dnJhWVNqdFp3TFNKdW96THhzd1BXdzFJRlpERmhJWUVvbGxaZTJD?=
 =?utf-8?B?d0Q4eEwxZlV3U3ArV1BwVkJETzBneU5nbDVCcCtXT2pPQlY1NE0xQlVSNUwy?=
 =?utf-8?B?Y29kdmpYbUYwaUNMM1QvdDdYS0Y3Z0FtUFJJemM4c2JrMWx6eGwzUGhIY0tO?=
 =?utf-8?B?UEhoQXN4dlA3KzIvNGpOOEZJTlJiQzV5andoM0hVNWRxNDlLMy8wSmFKZHdz?=
 =?utf-8?B?SU9pUjdHVGxCcmRZNGh0aU9INlpya2xpcjlRcHBRUFI1dG5RNUF2LzAzdGYx?=
 =?utf-8?B?VVhuaUlVdWNhK01lcGFNTUdockRMN3ZldFdzNlQwNHJSTmtLeUhWQW0zWFJj?=
 =?utf-8?B?bFk5VDgyN1NGQ2h5U0JxWFZKQ2FJaUNRd0VST1BONk1KeWlab0N1aGh6MVp0?=
 =?utf-8?B?ZVc4RmRtdWhVUGQ5RzFWV0svWHFHOGo4RGJVN0dwQ1d4emw4N0lOZVFqY2p5?=
 =?utf-8?B?bENoUll4M0hxWGlGTnRRcWlwbGpEemN4Q3l0RjJ3KzI0RE9ZZXVXMXc3bjdl?=
 =?utf-8?B?VXlvTktvY2dBc3pCZzkxQUJEQ0c2ZmZudUpLbVRXRHM1RWI0THN4Z0w4bGJJ?=
 =?utf-8?B?RUY0VmluSDJJNElNZFQwZ2VFelI3dDVUNGFTN045YU5qYkZVZVVWTW1ocUU2?=
 =?utf-8?B?RUlGbHlKZUcyd01FbWdMaEdHTHJGZ09wNFA3RW5Obm45VVgvOTJxWkpSQXBO?=
 =?utf-8?B?dElKUGpyRlY5QXl6ZmhxTGwrWGQ4RnRnbXRpc2NKaTB4RitGQ3ZEWG1mendq?=
 =?utf-8?B?SVpqQnY3dzhleE9zNmF1d3BSV3hmK09Nd3lYWUxjSGNoSmFFVVQ4QmlIdUtU?=
 =?utf-8?B?dUxxbHdVbWEzd29SdGdHNEdWWDRoRDE1RGhneSttT2huU2RDV0RUdDU5QWdm?=
 =?utf-8?B?dG8yZGJBdjhNL3dXbis4bncrd081ZnUrQ2N3RXdTalF6MU9hQ2c4cS9MbCtV?=
 =?utf-8?B?UkFoZUc1RFJvY2pJS3V3cUl2ZEhsUWk2TVdja0FKY1NsMFJvWVhHSG9HR0Zx?=
 =?utf-8?B?T0tRR3N3UWhEMUtJSHlrUDMzWVlqeDRXaFNnSVFrVUNyMjhkZU1ZR0IzdEht?=
 =?utf-8?B?cFJpMzFLYWNGc1kyZ1BIYmdhUGhDY2hFYVFxYTBWeEhwcFhyQVZZcmhMOUJo?=
 =?utf-8?B?YjU2b0EyeUdpcnk5eFE4R2FMQXRuTFlHRk9OaFRxUzl6Umh6YWZjaG1ZenlJ?=
 =?utf-8?B?R1lHbnVDMDE1dFl1Z1orSXhKemJxYnNEWXpHRFdLcUczNFVNc244elNBT3JC?=
 =?utf-8?B?VUFYYzZiS0E2d0U2OUJXMkNtTzJUbFhjalFzc1U4bVRNVjVEckVWMlhMUHZX?=
 =?utf-8?B?VEd0a1B5bW1jYzJOU0RKVU5HYS81alozN21PMERzK3EyNjlZMkVLYXN0UWtj?=
 =?utf-8?B?dk1HSE4vaUlPQ1hwWE85d0x6L0h0aGh1WWVXMlpFN2dCNnprQWJvTVNBc1lm?=
 =?utf-8?B?cDkrV0ZIV3g5NVlGemZBamxTaXFRbkt0dlk4TGxnem1xWlA2SkdkckJqN0Jv?=
 =?utf-8?B?OTJRcForeDhCWVJwR1Z4YmtUaFNGZjZLUDdIQXdFNk51QVltRkdrdE13c1cw?=
 =?utf-8?B?aGg0bys2YXdMZk9WcU1UcjI1YXAxUFdBSFRWSENnNUV0Rmhvb1JHQVBtNnRH?=
 =?utf-8?B?YlZoV3V2aXB2R3JwVFpmeU5yb0tuY0lXcExMK2wxalExYVpWZzFnUk9UZWt0?=
 =?utf-8?B?Z1VjUENSMlFhaEZ4bHdxL0xLVktEMHdjNFNGWXVpbCtGVWR3Zk40SWVrSUdE?=
 =?utf-8?B?c0Y2OGZHS0Qrenk3Q3k2UlhXam9pK1gza3RzRzRiYmJtaFd0VWlkS2lWT1I1?=
 =?utf-8?Q?KyexddWNvTSXSYc5NARwUi95w?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e5fb433-f27b-480c-aee1-08ddc0127a49
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3320.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2025 00:32:55.2171
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zP7EKVdEK/oBcKfLRKKKTmCWHEsokNk3Itpmiq0THnNxkkAhSJVdMIKL//r+uNbTE79WfrjnRPTm3ycDI/tBiw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4525
X-OriginatorOrg: intel.com

On 7/8/2025 12:30 AM, Zhuo, Qiuxu wrote:
>> From: Mehta, Sohil <sohil.mehta@intel.com>
>>
>> We have warnings that should flag any time multiple handlers are registered
>> for SERR or IO_CHK:
>>
>> 	/*
>> 	 * Indicate if there are multiple registrations on the
>> 	 * internal NMI handler call chains (SERR and IO_CHECK).
>> 	 */
>> 	WARN_ON_ONCE(type == NMI_SERR && !list_empty(&desc->head));
>> 	WARN_ON_ONCE(type == NMI_IO_CHECK && !list_empty(&desc-
>>> head));
>>
> 
> The warning doesn't imply that it must be a single NMI handler. 
> Otherwise, why not use a single NMI callback pointer per platform NMI 
> type for registration in the current NMI code? 
> 

You are right, the warning doesn't prevent multiple handlers from being
registered. But, it is also impractical that someone ignores a kernel
warning in production.

> I just don't want your comments or commit messages to 
> mismatch the current code as it stands.
> 

Having precise comments is definitely better. I will reword the comment
to say why NMI-source reporting isn't needed in practice for platform NMIs.




