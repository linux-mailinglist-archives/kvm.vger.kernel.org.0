Return-Path: <kvm+bounces-56948-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DD94FB46916
	for <lists+kvm@lfdr.de>; Sat,  6 Sep 2025 06:49:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9BE521CC67A1
	for <lists+kvm@lfdr.de>; Sat,  6 Sep 2025 04:50:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 224AD27991C;
	Sat,  6 Sep 2025 04:49:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="afVOQp0p"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94EF92797A3;
	Sat,  6 Sep 2025 04:49:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757134175; cv=fail; b=MQJNGtEfSJ/zWwAjpyZjDNoEVjGxSBO1akKb4AEeUoK0yH6+PZU0zXzZvO0TQsFNm0N/wcJBRthb9aABgg0Lem5/P6CWujoYFxezKkiKA0fZjUH0FTlG2ocYiPxqvmZuCZKo2dU8h64FWGbg5qTiJvMt2fkt8WwfEwf/CnXYozg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757134175; c=relaxed/simple;
	bh=ohlKhUxjZFesHIeJaTVC4ztRgT9UAaFoDLmhUvdhlVE=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=rLf/0eDjfQkmfefIuas9pwE1taFrAeoevfW0EROXlvOHKdwhgfahIPIYL5FDJRX6DP5VSCHRSYPi39TrGs8SWaAZU0PgZfBymtoPFbMIv4CtyFX2FEriQWCyrzb6a8dzxVopQpegBkMwYcW1oWpRead/z1p3MnjHs5woO6TrCno=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=afVOQp0p; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757134173; x=1788670173;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ohlKhUxjZFesHIeJaTVC4ztRgT9UAaFoDLmhUvdhlVE=;
  b=afVOQp0poimGdMI6Pb9JSExBtttvrRPt7FO9qC96zuPM+2wUR/kYwbgN
   fiqc+g+EklWw5al+/IMME8ADemblaE2P6WQWBoPqgUSsq+JJUd6MTClsS
   oyczvSMxHj+bxHB7QYmbG2zFrqf8OdsDgO9+lRuTnNk6l9RJi9re+lOA2
   f7bgiMPoifRkDdXwcetk+WSTMI03M44Ra5iDfu9ck11219gk6/YBdo4qU
   OiBZZLvJibEwaT2OC9u82IbV7lsTtz5m2GxqfjLDXJkPMQyUm1dUVLYTo
   xbJZmAIRs+NlYX9Ok8WMgQN71WdJzA9iCymASRNG/Ioj8f8ktWDKOTkw/
   g==;
X-CSE-ConnectionGUID: rnEHIAnuS6uP/PfmBf/x7w==
X-CSE-MsgGUID: 7/PBb7QxRVCetQv66MatMA==
X-IronPort-AV: E=McAfee;i="6800,10657,11544"; a="47050362"
X-IronPort-AV: E=Sophos;i="6.18,243,1751266800"; 
   d="scan'208";a="47050362"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Sep 2025 21:49:32 -0700
X-CSE-ConnectionGUID: 0uV/iAa5QoCPAJcyuD2DWA==
X-CSE-MsgGUID: taGqcFqNQ6i9K61WuwctxA==
X-ExtLoop1: 1
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Sep 2025 21:49:33 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 5 Sep 2025 21:49:32 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Fri, 5 Sep 2025 21:49:32 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (40.107.220.48)
 by edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 5 Sep 2025 21:49:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fTI4TZoE0RFuaWCWKD+JozX3fWO6LCxXEhGM9JYPe+NNg2CTW1owdypf5BP7mmqmOlDiyDcAO2P0BbIxnBVKlleN/gvmr+o9R9N5k4igyi0Mm+xGQbG1P1wOFY7r3EtQlcHYNhp3ZRpNK7l7G+aMP+3S93XgcbvDtoAmFjvB5JyHdvydj7flc+Mpg5+AwGV1VlMqKEfAvTQl6Ukgl6W+RU15d79/RvRXihdX+kKZgWb1OJh7DJ4J4oa1i9RQaJp+68mfTXz1R/ALGIIqmRldVtiY2m49oUrNSwKBIZEtjgng3/iBn0yrZyoFuXMfa6Z1YeZfDzxwC+cEnJ6fQKxlPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VNET2nU25IBczVcLCHulRFCV8kgbjezduOW+gn0xMG4=;
 b=ZOz2FbZX7v1SmVdRzD5Lmu5AOWACHixRvjAINgtEXN5C+07ddiIC655duF/Q+ZnxgDIWWyM4wCpk0a7WpLEWUZn/G7ziu6ounmPdLpE67ZFEkZXsmmjtfLcMct5YQHi3X8dCaaiA017i+1PhYKQVqu1j+xY2TKcefpszcWRHtpQpUku5mXSpoJJ8l3yf7mjb6lF5O8QaJncTtGTdYgal2eevvON9tsr73x3RQFQLEXD3oZsDL90I/Kqz8dXMojS+QBrwX5zJABkZ6zYuaOq9IoSOXZTTegxbAQaZADLxkId3U8htAC5YTU+6eUfzn6ckyA1RQwh193Vtzqslu1v3Pw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by DS4PPF46B98A11D.namprd11.prod.outlook.com (2603:10b6:f:fc02::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.27; Sat, 6 Sep
 2025 04:49:29 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%4]) with mapi id 15.20.9094.016; Sat, 6 Sep 2025
 04:49:29 +0000
Message-ID: <fb2d5df6-543f-43da-a86a-05ecf75be46d@intel.com>
Date: Fri, 5 Sep 2025 21:49:25 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v18 05/33] x86/cpufeatures: Add support for Assignable
 Bandwidth Monitoring Counters (ABMC)
To: Babu Moger <babu.moger@amd.com>, <corbet@lwn.net>, <tony.luck@intel.com>,
	<Dave.Martin@arm.com>, <james.morse@arm.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>
CC: <x86@kernel.org>, <hpa@zytor.com>, <kas@kernel.org>,
	<rick.p.edgecombe@intel.com>, <akpm@linux-foundation.org>,
	<paulmck@kernel.org>, <frederic@kernel.org>, <pmladek@suse.com>,
	<rostedt@goodmis.org>, <kees@kernel.org>, <arnd@arndb.de>, <fvdl@google.com>,
	<seanjc@google.com>, <thomas.lendacky@amd.com>,
	<pawan.kumar.gupta@linux.intel.com>, <perry.yuan@amd.com>,
	<manali.shukla@amd.com>, <sohil.mehta@intel.com>, <xin@zytor.com>,
	<Neeraj.Upadhyay@amd.com>, <peterz@infradead.org>, <tiala@microsoft.com>,
	<mario.limonciello@amd.com>, <dapeng1.mi@linux.intel.com>,
	<michael.roth@amd.com>, <chang.seok.bae@intel.com>,
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-coco@lists.linux.dev>, <kvm@vger.kernel.org>,
	<peternewman@google.com>, <eranian@google.com>, <gautham.shenoy@amd.com>
References: <cover.1757108044.git.babu.moger@amd.com>
 <08c0ad5eb21ab2b9a4378f43e59a095572e468d0.1757108044.git.babu.moger@amd.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <08c0ad5eb21ab2b9a4378f43e59a095572e468d0.1757108044.git.babu.moger@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW2PR2101CA0017.namprd21.prod.outlook.com
 (2603:10b6:302:1::30) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|DS4PPF46B98A11D:EE_
X-MS-Office365-Filtering-Correlation-Id: 6016837f-4ce3-4666-fede-08dded00c345
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?VEowWTFsaUR3MWNreXN0VDlwdWNpemZnMDNXdFgzMUhxOE5ISTRsQ0RwQlNt?=
 =?utf-8?B?TmJBVkJIR1F1dUtnZUpVQmZlNDNvUHdGWGVuT3NiUGNLdit3UTd4T21DM1lS?=
 =?utf-8?B?SCtucEowc0xhZWpKQXZVb2xTRWlsOEpMVS9jV3RMQkNDdlpyc21QSU9DUzl6?=
 =?utf-8?B?eU9uLzRUeFRqcnZyeGxiblJzcDh2NFlVMnNXamFjQWVmazdvZHNObERUeE04?=
 =?utf-8?B?ZkVsbWUwaDhEUk9jZllNbTlIa2tCMHA3V2xONU1MNS9jTjVqMGVwUlRrRG0x?=
 =?utf-8?B?c05Ca0I5a0FUODcyWjZJaVlzMHd5V2wrdzk3cGJ0SUJRRWhxcVJVMVg1SFlx?=
 =?utf-8?B?WTJsRzhlVnpDTHNkcWtabHlZSllMejVwR201L0FIVkZuV0R6VTFLdjBWYXZO?=
 =?utf-8?B?R2VvTWdlWDFpdVhuL21yRGQ5WjAyS0pSb2FhT0tDQ1RhdVcxSjl1WUtpRHFp?=
 =?utf-8?B?ZUJmNm1pRWllT3AwWUh1QWI0ZWl2dFo2cWQzUFUyY3dUejY0cFZkWUhFMm1F?=
 =?utf-8?B?T2JwMUZwS1hDQUhVdHF5QVZ3Zk9vN0VLc0w4RzVsT3A3UXUvcU1oWXBpRUJE?=
 =?utf-8?B?VFRPeHdzeC92UUtkQXdWUGJKOWdTRHdOZGhqc0N2L3kwNWY4eER6M2o4WG5K?=
 =?utf-8?B?YVN3a3Q3VFZYNXJzUGJjdWNEVGswTXJSTzZFOHM4SDRFZ2VRUnFLVWxoUngx?=
 =?utf-8?B?T0w2Tzd1b3hKczBxbUN2NkFEVGR4V1VwUGpmclFrRy9yR0htVkxjV21vZU1M?=
 =?utf-8?B?ckJTTWYzS1luUXBOeitVcUZjZE5yaEg2cTljN1hxSXZCL0FOTjlLTmpWTzVY?=
 =?utf-8?B?bEcwYWFnWE1mVWJUMXlpemJOOEJ6WVpaRTI4aEQvYXNPci8rVjh3MmJkNkxW?=
 =?utf-8?B?TlYrUm5lbjN6OFRwQkxFd2k1TDEzZi93OHBOczFGMHptM3pibGhySVNqUS9U?=
 =?utf-8?B?TUs2cnpmbFUzSTE2ck5wOEdQbURySTVNVWVQbFJPZ3E5anZ0eC91Z1dsMXBv?=
 =?utf-8?B?eHhiMnFZeExINlA2a3JrUlp4WnJnc3pMTDVkUEFCcllIMmU5dVE0T0ZlZkc0?=
 =?utf-8?B?VThSTUlVb1QyeGxzOEUyb01GTnBtZEJ6UE1DSmZaZVB3VGY1UnNJNDRHMFZ0?=
 =?utf-8?B?b3AwK0JlMUhPQUtvcVFDOWlkSW9ObG5hT1daL25GeDlXOEpwZU5YVVlVbkZX?=
 =?utf-8?B?Ykg4YXlhMTFqMDRzNVFzL0RlWjZ5Q29seDE4bllnTThDK3Jua3hLRzRwZGhX?=
 =?utf-8?B?NHk3U3FFQUpxSG0wTENyMDhHRWlKS1d1V0RSc1N1dWE2T0kyTHpZZ0tuMFlR?=
 =?utf-8?B?a1ZreU9WRldHTzIyRTFtdHZycEpxSWNNNFd2SytxbDZFaEZwZWQwc1kydjNH?=
 =?utf-8?B?MFRsNFEwUEkzOE1BYTFFTFI4bkcyOEhyTEswWG5qUTl3Y3NjUS9sTzhpVlNW?=
 =?utf-8?B?M2xHbDVGOW44WGR6c214VjNaVFYxRTQ5dzdNaXdZSUlVcFJlSE8xWnE0TlBN?=
 =?utf-8?B?c1FTL0IwQ2VzVThwN0pkaFRwdDBYeWhnK0Rtbi9vbys0NWRSUExJOVlQQVFh?=
 =?utf-8?B?L2VqYUVWS3R5L3V0aGJjZ0JveTZwN0Q3Zy9FNnRyQW9IcEdwZXR6ZGlmeEhm?=
 =?utf-8?B?eE5sWGpJbjd4UTFvY1lkdE8rL2ljYlBHaThDWlpIKzhmOVZNNXZyOU9VejEy?=
 =?utf-8?B?aC95OFR0UmVLd25lZ0RmZ3RJWkZKRjF6ZUdXUTlEQm1PdjVvWkdDNHlWbHRT?=
 =?utf-8?B?cUdjQkFDRGhrMXl5djhYR0VzTGhhdW5LVkhtU0hGRXJQR3R4MFp0L3hoU1gw?=
 =?utf-8?Q?DkYONY2xau/lALYYxvoh7zpLb8+50gq2f/BXc=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VWZpN0ZyYmN0UytIZHR6clNQYUlCS01HQTM5R1o4K0llQlZyaVN1NWFPbE5C?=
 =?utf-8?B?dVFiS29zT3kwUytFbFlGZlF1ZHhhM1lZVjlmdlhFWHQ3VmhzempldDN2NEF0?=
 =?utf-8?B?TFhIL3NjNDhTem43emxrUnhnYWtOdnFaTmR6c3A2MDdJN1VKR0Fham9weHFC?=
 =?utf-8?B?NHQrRXU3aWhTOW1iWXhBMzZuY254bzN3dDZxVDR4R0xCTHo2VWpHRGJjK3pn?=
 =?utf-8?B?YXJpWWp1aVgxS1dRTWZFV0ZxckIvU3lXdG1zbUFYN3lXVzl4akRFbUhqdStO?=
 =?utf-8?B?SzFQbVBKamFtQVJ5L1VrK1hjOVlhbWVzTStlMVBHNmRzK2pvTU1EdDVYclhu?=
 =?utf-8?B?MHREWnVKSGRPQ1VNcjUwMnVnM2VUOXcyaVdOR3lYU2U4VW1vTkZKRmxmU3dL?=
 =?utf-8?B?S3NzOXlVeGRjRmNRQldtTnk0dUJjS3Q0SnJTblgzS2RTZjg2Yk5UOVE1bjNn?=
 =?utf-8?B?UFRyejhiTmYrYTdoMUNKWEVsdjVWNVJ0TjhxNmlFYUUwV3hqMFBLaEVuQXhv?=
 =?utf-8?B?T0RJamFMSlFRV3hTYmR1Nlg5Ukk1Q1F3aTRPaXBRNWYydjR5Szl5VmdXVDYr?=
 =?utf-8?B?SjlCNEJ5YW5rL3RpVlNTeUtkUjZVdXdobXA2Z1FEb3ZvNkZiWU9GZVd0RWRp?=
 =?utf-8?B?SnZ6V3lhY2pUOVNvQ0hnakhlRTB2Wk5JL1J6OEJzUkZDbkZ5eVlYVEFGT0xv?=
 =?utf-8?B?OVVZdzhmYnF4aHFpbzZEclRDWWhmUDZCb1ExcEVLS0x0K0c0RTl3Y2g2M0xz?=
 =?utf-8?B?b00xc2dWUG1vVHNHQnY4a0VHWGY3aHE1NGZ0UlUxcGtheklZL0hmYVVDdzRt?=
 =?utf-8?B?VDUrRkh5eXgxVitxUURvSXZzZVNmSEZjdk9XcnZEc2tiZWE3Rm0wWW5PZ2Z3?=
 =?utf-8?B?R3QzUmZrVTVCdjZYRit4YjhUL2VqeTFRNTE3SG5QU1RaUnljSXZkelZibVJo?=
 =?utf-8?B?QkpSMTBVS0pDM0pqL0VYUVJNaWtNWmZFUHl1SlRrK0RGcEYwY2tmZmoxVDlM?=
 =?utf-8?B?UkZRM0JDOWZoSDJXNmlJbmRNTnlqRnd1SEZCaWJaTURrSGRXUng1clMrSGlM?=
 =?utf-8?B?elZFQis4ZVlBdWRCUndVZGZacE9wMDNhS2N6RHFYNzViRDNHUEV3a3pydTRB?=
 =?utf-8?B?WmRDb3N1aHNxSW9yb2RWOFVOclo1U016cVB0MzVnOXErczBHU1M0MGJiOG1B?=
 =?utf-8?B?NVhaVlhDSUFuM285NXUvT29QcWFRcWVFOW00UHRSL1JKVWlQM3I2YVVxWHh6?=
 =?utf-8?B?T2Vnc2JDeEVwVXZpZE1LVmhkWmZLczA2NGlUN2xoY2FyUEkxSnNUb1pscVdP?=
 =?utf-8?B?R0FEZEczQnhYSFFDZjNJMklmbCt6WHIxZUVrbWpYeml4RGd2NWdMNS9sZnNF?=
 =?utf-8?B?L2dqVy9aR3hudmcwYWs3d2gwMWU4cG1zbi9VbGxhcmI4aE52cjVNNVpaVFBY?=
 =?utf-8?B?RDQ4K0FCN09MUUhUM3FYcGJSZjlHUDk4ZGQ5dUdBb1Bjd1d5Sm1jczJ6SmE1?=
 =?utf-8?B?S0hKazA4dFJ1WWRnTUh3cWhkWTlJcGRFSWN4R3Jkd1ovZnQzajRPaEhibTJp?=
 =?utf-8?B?aUYrL3I3WEp6Um1iUCtKd2I2RjdxYWxuZDNVODVLeEVaSGNPaXgxM0hjdjEw?=
 =?utf-8?B?OWFrcDUxT2dCWHRQbHVDZ0dQOC9PZ3FMWTI3STFMTzc3TFBUNkN2WkIzNkw1?=
 =?utf-8?B?Q1pYNTN4RnV2NmlsVFVRQnJUaVBqOEdlYXZHcHJ1T0dyZ2p5WDhra05RemRn?=
 =?utf-8?B?d29jQnhCNFdFeDZEbkNURkl5WkgxTlA2THY4aFVYY2lGay8xQlRvbWY3Z2Fn?=
 =?utf-8?B?YlhLVU94RFVtUzlkZFZQZGJHN3N0cGs1MUNjUTBJUDNVN08zUlgyKzZ1clEr?=
 =?utf-8?B?RU8zK0dyVVY3aVQ3ejg0S2J5S0VkczNNMHpOR1c5ZVZXQVQxRy9CaHR1U3R0?=
 =?utf-8?B?UEZXYjZqWDhsNEVrS0o2RHFEQ1hMckg1Ni9Ca2h6T0Y2Q3g3L2lvNFhaOHBx?=
 =?utf-8?B?dFpHZmdxL0NrTHE0Q0NGZFFLTzlXL21DbiszU1EwMVBqNm5qeHloYXk3VU5r?=
 =?utf-8?B?YTJJeFJNaUZISnh3Nngzc0dEWTBpZHZLT2RCNzh6QldpT08zR1J3U1VQQ21j?=
 =?utf-8?B?RjZSUTVTcXUreURLc1B0RWEvT0Z0U3FWeTBMRmwraEJnMDkzcEVleWIxbWtN?=
 =?utf-8?B?SXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6016837f-4ce3-4666-fede-08dded00c345
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2025 04:49:29.0782
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0xtMmolP5qOiJYYFNdzrDFpc1kFRuAEmKUmtecPl6sqAhyK3/DhwKcyOfgJt5Hm2j2eUh8L4nzG5LDb3R+w5hNerQZxMgvwiWHHr18ugPBE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPF46B98A11D
X-OriginatorOrg: intel.com

Hi Babu,

On 9/5/25 2:34 PM, Babu Moger wrote:
> 
> The ABMC feature details are documented in APM [1] available from [2].
> [1] AMD64 Architecture Programmer's Manual Volume 2: System Programming
> Publication # 24593 Revision 3.41 section 19.3.3.3 Assignable Bandwidth
> Monitoring (ABMC).
> 
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=206537 # [2]
> Signed-off-by: Babu Moger <babu.moger@amd.com>
> Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
> ---

Apologies for not catching this earlier. I double checked to make sure
we get this right and I interpret Documentation/process/maintainer-tip.rst
to say that "Link:" should be the final tag.

Reinette


