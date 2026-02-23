Return-Path: <kvm+bounces-71506-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CAPIDpKKnGmLJQQAu9opvQ
	(envelope-from <kvm+bounces-71506-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 18:12:50 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A17DB17A79F
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 18:12:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 896BC302866D
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 17:12:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09466325705;
	Mon, 23 Feb 2026 17:12:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NZY8M90N"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50C5B328B69;
	Mon, 23 Feb 2026 17:12:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771866762; cv=fail; b=Zgsh/FDIW+E9iPMHxlWqu4OS/4SkHEhyF0/PBbz4wqBX6x2DUZs0FHiEk/jFxhTCocdnNFmGESHvqB2lEyeMWssAmYbj+lKTrJ7i8S0IYW4GngkYP5xkU6NRCtjavPEQcDXCSeHOnd9CRzKIk0OIut2jEr8TJF/TJR5vwn/l/3U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771866762; c=relaxed/simple;
	bh=RVeLUlZ06/fHqjiOTcAKmWmbz7Xak87qs+qO1A0t0G0=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=U6zira2UkOCxSWIgq+F0NuwaKVgQ4kMQQGmbcISscXWC4flgTJv8qhr/fGhhvIclBNHktHLdbQRSXbl+Zxw/wz8AGzt5Pt9IDtcuhumObsdPP4aJg+G3RtMTRyMfwSoIRCbSeuRavIucbEFVrfHUn+s0G0ukpqF8V01GN5U2n6o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NZY8M90N; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1771866760; x=1803402760;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=RVeLUlZ06/fHqjiOTcAKmWmbz7Xak87qs+qO1A0t0G0=;
  b=NZY8M90NKgZtdd2NxsTLep9rDOHSIL8CTYGSl0Rjjyw4prP7JBIotCAi
   JM9AdH/acRLOPeBsk6OWD8BMyA+/dIh7lkZdIj61SycgWSaXQyVUfJsTh
   RnWWjHt1xESSSkPacH42ROx3pGcQnLnrN0TiBSJ0wbUSaDaFbYzmJ5blx
   fzjtIzlNs0PMH10Px1s38lCAiFP4Yz5bi7zHCCxvdZNf1+ejj1RX1zv4z
   4mspq1gwJ8oxXNE9V6Y0Hadvc6N3YOffvLXPjKsl8W/Exik8q3zlxZ91b
   7zIS0GF1rdg8Xgprj2wRNXX9OnK7BW0B8om5NJx0kUZNBrLXE7BiJXVeT
   Q==;
X-CSE-ConnectionGUID: fgSsTstcSy6upoRTkQMesA==
X-CSE-MsgGUID: +PMcDOWhT8SqajP51K0w0g==
X-IronPort-AV: E=McAfee;i="6800,10657,11710"; a="76733059"
X-IronPort-AV: E=Sophos;i="6.21,307,1763452800"; 
   d="scan'208";a="76733059"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2026 09:12:39 -0800
X-CSE-ConnectionGUID: qK2wzIXVT2irC8PGYnJfyw==
X-CSE-MsgGUID: VFqFFDiyQJ+q1oCptLKIVw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,307,1763452800"; 
   d="scan'208";a="219163637"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2026 09:12:39 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Mon, 23 Feb 2026 09:12:38 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Mon, 23 Feb 2026 09:12:38 -0800
Received: from CH1PR05CU001.outbound.protection.outlook.com (52.101.193.47) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Mon, 23 Feb 2026 09:12:38 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YC7+S3fP4a+yFJcKpnUCpnZC3Zu/OdKTSMMwSqdSTxWPWB32gy1euj1dT3++93qyZkZ7dcJilu7aK7Rb3+NrkMBuyaR0J1rWf5O3a+ZW2wPi3xntVQJP59i1yaUp5c3HqmK7D6F2Kcq3cHCALRrLSvp0TSBdz7GfTCR37iXXZWSAEIWj0sPHhneobB3k6ygLKzkjbk7Zjvga7XLyU0aQgDjCabSTzXLnCBS6sk1EJ04K1UFlK9JuErRvSYm75Eu4y0nuMddeZ/z/H+JRxKdMME/Cj1lsn07kVWFTLxyOBG0GAhlUsGrbAH0dJMf4MAodrc874GauJ4s7nyE+GJZwQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vd8JCM2f1W5YIXVuDxNyP5lMputZ85ZjzeGsbxMZb9M=;
 b=BdzSCvhXJ/Ty+Zk29+6FEad2WcD8fO7JG6Ne7qDKzARXJjolggteIAsR6G82cwdEBxzqQs50yorSvicZaNuEZs3br4XobeoTfzVYRiAoJP+eujAhDxPnVAertZkUBGAghk5X/oEfN5Zvdatl+doxmGVFeTB3/EKbV7wowPGL9IxRr/XsW46q9Y2UCQO18tPrXiq/L9ekYJPaCz3QD4vh+eOdSGxBapOwUiZxloXdiu/1WOe55Kss+BGVaEL0xelBSaONdzHe3tUxUMwgOBOfF4RVw8bjRaGmr+KBfrx2RWm6bHJ1E6/WNBqJnuSYLlvEsMAO7/cBvNhqcIiSTXhrVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by DM4PR11MB7399.namprd11.prod.outlook.com (2603:10b6:8:101::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.21; Mon, 23 Feb
 2026 17:12:35 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d%6]) with mapi id 15.20.9632.017; Mon, 23 Feb 2026
 17:12:35 +0000
Message-ID: <37bc4dc5-c908-42cd-83c5-a0476fc9ec82@intel.com>
Date: Mon, 23 Feb 2026 09:12:30 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 13/19] x86/resctrl: Add PLZA state tracking and
 context switch handling
To: "Moger, Babu" <bmoger@amd.com>, "Luck, Tony" <tony.luck@intel.com>, "Ben
 Horgan" <ben.horgan@arm.com>, "Moger, Babu" <Babu.Moger@amd.com>,
	"eranian@google.com" <eranian@google.com>
CC: Drew Fustini <fustini@kernel.org>, "corbet@lwn.net" <corbet@lwn.net>,
	"Dave.Martin@arm.com" <Dave.Martin@arm.com>, "james.morse@arm.com"
	<james.morse@arm.com>, "tglx@kernel.org" <tglx@kernel.org>,
	"mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "x86@kernel.org"
	<x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>, "peterz@infradead.org"
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
 <2ab556af-095b-422b-9396-f845c6fd0342@intel.com>
 <427e1550-94b1-4c58-828f-1f79e5c16847@amd.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <427e1550-94b1-4c58-828f-1f79e5c16847@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MW4PR03CA0005.namprd03.prod.outlook.com
 (2603:10b6:303:8f::10) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|DM4PR11MB7399:EE_
X-MS-Office365-Filtering-Correlation-Id: e6ba0c87-15e3-402d-2fbd-08de72febca5
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016|13003099007|18082099003;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?QTA2UGFhbGFmQ1RaczBtVkFvNllOa01DUmFhQ1kvcWUybGxSTE5LZWliUllP?=
 =?utf-8?B?TkpFQWowUUVlMTNmaWgxWnZtNW1Ma2lxT3IwM3JYZk04NlFWZjk1akdFanRH?=
 =?utf-8?B?bExSeCs1eXBwbUZtS1NQbTlRYnRHL2g1d1JOOGhWV1dDdVQyTGl6ajhFcFgv?=
 =?utf-8?B?WGJ5MzZrcWVyOHMxMExOdUxBN2VHNzZxWFlZYTZpV0VWTUN4SHVYUFJEaXJ6?=
 =?utf-8?B?MW9WNEhvTFNYc1kzUldTTkU1dVhxTXpuL1AxOU0vMklWRklWME5kMUdjeEVl?=
 =?utf-8?B?MTZCRlJ0T1I3aUJRVEtybk1GejlRMDhTQ2R5TFQvaFJvSHovcGFJa2ZYd2xV?=
 =?utf-8?B?Ym43YjJ5eG1PQ3BwcnNQcTArbEFOWGU1M0xFOFQzdndRVEF2djl3QjR6YmVl?=
 =?utf-8?B?U1Awam9CbU9FeTZNeTNnNnlvTzhtbk04YzhKKzluZVlQRFV4QzZ2RC9aQjhs?=
 =?utf-8?B?V1d6dm9iYWNPY1hqM1VCRFJpQ1BiaGdlTWpwa1RDZ0RqUUlwbkNCSm9TNzhL?=
 =?utf-8?B?ck45ODRDWGllR3YxditDeFIrejRydE5uVVVLTUlPRHV6bmYvdVpuVHpUSnRM?=
 =?utf-8?B?ZHJQQU1mcW1aOXg5ZStHeFBNMlNBUXpRd2tpTlY4bWgyeERoNE96OWtKNXpi?=
 =?utf-8?B?TmJrc2lFSjBWN1hueUJkWHFaMDJ1WTFxem0yV0wwYVlTVi9xeGVJcWoyTUIz?=
 =?utf-8?B?aVdKQ1VUL3UzSG9XUlBzOXlWdnNhYVZFemdqeUpvRm14QkZOVVlORm5hTE5Y?=
 =?utf-8?B?VDRtemFSY1JYejd3TmNUd0V5dlQ4UUM0Z2Vybno0MUtjV2p0RXc0cnZhaUxB?=
 =?utf-8?B?RHpoQVFYeDhBVzBYWXh6TWlJVXN5R1hGM2ZUd09hUXVJNTZGMVY1U0pJWXZp?=
 =?utf-8?B?SEl3ZXVrYWlZQWE2d2VCR0t2bDl4dXRhK0tUcm1sbnZwQldabVFLWTdOZ2VK?=
 =?utf-8?B?ZjVHZE9YOCtpeVJzVWk4cHBEYVlnRml3aHlTSmlsemRDemtXQU9meFExUGti?=
 =?utf-8?B?dWwwSDFFK3dyc25GWkgwSDBNQjZoZFZrM0lmclc5Rm9jd2hJL3NmaS9rOFpi?=
 =?utf-8?B?bW45L3RTem1YRVIxaEQwc2pkeFFleVhERU5wRk9NRUQ0ZUVlcHJWMmpyZ3Zh?=
 =?utf-8?B?dWVLOTNaSWRldG5EM1BvVDZBUUVEWG1pdk93WDFZbVNna1RPTnhkMHE4M3N6?=
 =?utf-8?B?VVIyOUQzcGZVMzRhelMyd2UwN083TDhqQUJGYWF2TDI0OGdrUkVKakVhWlpF?=
 =?utf-8?B?eC91bjZoZkdmZ1dENFFRdlRlcXEzV1VUYktVWkZRdXBoTzdGK2VmaGhwSDVR?=
 =?utf-8?B?Sk5iRXdWZlFGSy85aWNqaDRNNU1kbDRtZW0weVVmNGdvdENzU2c4MGlUamVW?=
 =?utf-8?B?SStyWjNVdE9RY016K3lFdVgyeFdFQ2R1UjU0NjhGaHNjbHU2bGUxQkJxNWE4?=
 =?utf-8?B?bWFJR01zYkRnajVKMHJBN3RGQ3RvVGlUYzJWLzRnQlJabkxOc2Z5OFMrRkNP?=
 =?utf-8?B?ejhPaWRiQVdFMVVjZ3luRVdxQ0Jsa2RZZERCRHNlWFllY2Y3UDFjOWJYUTRU?=
 =?utf-8?B?bVFab1pCaE4rcGlCV21IOHFmVHhKZVN4WWpJVHBEeStPRTdERU1EOGdlcTNT?=
 =?utf-8?B?SlhRcHREWmkwNUI5alBOV290WTFrZHlNd2pmU2xpYitDN3p6NmluRU9iYzJC?=
 =?utf-8?B?aVFucEJUN2xxcGZQSk5tSjRkblBXYkJ0NmE1ZmRGRGZSZjFpUE5DYmtRbC9G?=
 =?utf-8?B?dDFQSjZVNnphVmhxSEhRblY4Y3E4VmNLdXBkaktzYUlwalFYUW90Slp2dGo2?=
 =?utf-8?B?eWtwZHIwWFovOU1PK0xEcXkrSjArRW1YMmpjdGhnUTFDMmdmbVhpYmtxbkhF?=
 =?utf-8?B?MDhsdFFCS1ZFOVZXcFUxUzJCbnFoNVF1TzBKNkd1YUgrZ2xNTC9lUlQybWg5?=
 =?utf-8?B?VUVZRVZ0MzdicG1rYzJFbFlRQWN6UVRyYVhpaUJYamJxQk5ubk0yZnEwWnV3?=
 =?utf-8?B?K0dINlRoTTF3cDF4UTJESTJtUGUwN2ZVckRaUCs2Slp2Z1RYQnRHV0ZadnZo?=
 =?utf-8?B?cklwYVBLbDRqdlQ0QllCaFVqZUlNdkNSbG9tRUIvQTNMZ05ZR0N4dXd6anNp?=
 =?utf-8?Q?JeA5piaSSXtLAqvgzm2wDEdg1?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(13003099007)(18082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NTE1U3djaTJtMG1lMjB0dk1GalVnRGVjdVpzOEl0UlJGczBkUjBzZzVQRDJJ?=
 =?utf-8?B?UmkwcmphenM4YXJXTnFpNjVHaHA1MnVXZHhzTVYrS3pZTFRGbU1ESkNVQmVy?=
 =?utf-8?B?VGhqYVREaDFBMTFxY1lFQ0ZXOFd0QXRJWE1DcmJ6NkczZDN3RjZTY3J4bzZJ?=
 =?utf-8?B?VmJJUUVYOU9tRVVSNTZtQTRUVFJ2UW1EWXNPTXhJY2hsdjd4WmVCTzdST1ha?=
 =?utf-8?B?VThITEVVMW9TSmRldTFJY0w4WnE1S2lMd3gzRzJDSFRmOHlSZGpBNXZkNVM3?=
 =?utf-8?B?OXozTEhLTWJZVGExUEhDYTJDSjFIQVdFNXNuYmJqaGFkZWRzb2dCQmdpQmRO?=
 =?utf-8?B?NkpYUHRiK29pQkdtcWN1dDhBNWd2aG1iY2JDYWNuTFFmSmZ5UFRUemhkRHRq?=
 =?utf-8?B?YXB5WjJSRysxV0lkTGNyQXIwZ09YU21jUjJvajU3cFlFUDBJZm45Z0RvV2ZU?=
 =?utf-8?B?dUhtZ1paaUFuNzFLRHduYVFhYnZEaDE4bi92dWtUUXpaTjg5ZUtNY1Y2ajJV?=
 =?utf-8?B?RVVudytLVnlIcitCb2ZEUUQveHVQa2hQc0RKRVpSNVFLbnYyWWJ3T1Rjd3lu?=
 =?utf-8?B?UHdlT0FIbDNOandCNXNneUsraFpHMVg5RlFxbHlrZ0lLdG13b0JxZldYY1lD?=
 =?utf-8?B?OUNjNnhOSkNXbTJIMm9ZMlkwUjRLWEsyYWppaUNSbkxTaCtMREpaaUs0SkdG?=
 =?utf-8?B?Wks2WlRzaTVnR2hyOWFoU3V3U25DL094Rk1rRTBmRGY2WVlLWnJIcjdtOHd1?=
 =?utf-8?B?QU0zWWF5NnhUSmZCVDBoSGd6TW8yRHpkN1VLVGY5cTFzcEN3UjdWKzdTdUcv?=
 =?utf-8?B?UVFSUXdPUVJjRmlUdXhUZU1ieFdWeWNSZTBjbTQzaTcvTEFCaTVLN1VqbStL?=
 =?utf-8?B?Vkl6VnNPNnlUcW1jUHR5MVpCV2s2d3lnT1JTbFZ6VUlDeWZmc01PcDg2YVV5?=
 =?utf-8?B?KzBBbCtaSnhWQngvSUJTVWVQUnRVZGc4Z1BEWHYwRDFwdUtOTTZwejdXUnc3?=
 =?utf-8?B?TWJVYmcrcm9uOEN3ajZTZzNEZTRLR1dBaHloRWZyai80M1FHdk5qMVlJNG5B?=
 =?utf-8?B?SkEyR3JBVEt1NzJlVWJuTDBPZXlva1dhY2Uzc0dhS3VMdXJKR0pPM0NVTnJp?=
 =?utf-8?B?Yzd6NlJCWDlXRXM1Zk96VTEvMUswZEJSVzU0eVZ0UktGVy9yZmRQSFYyeGpC?=
 =?utf-8?B?RHdhREdUcmlnKzZVaWNXcWFpNktmYTdFSHptOTZsS1NORkV3Zk4wSVFqdmF0?=
 =?utf-8?B?U3A0eG1TNWJIdklmRVNtTnlhVDRiZ3dpa1VPRU9saEYxT1IvMVp4OGJTYXUy?=
 =?utf-8?B?UnE4VzgwWmFqZHZVNTRyUDh6WjI1aE9NNXpRcGlqWWl1SEN5YnZLZm1BdnpY?=
 =?utf-8?B?Ykk0SDg3dUw5UFpVZ0dzbEY3VjJMWC9lSlBYTEdKeG5OZEZGNVFCMWw0ODc0?=
 =?utf-8?B?ZkUxbjV3M3pYUGFNUEZVYTRrVHZJQ3Z4TkxyelFveHdsMDlhb001aDE5SHRm?=
 =?utf-8?B?dGltVTVQNlhrVDZOV0VvNU1uODR5WE01NVNURGRFOUptb1UzOVhTbXVVek1h?=
 =?utf-8?B?OFg5WVpQMHJNejRlakxmcjRyNFZFMjZxN1VWbnp3L3RqbW5yenNGZjlwd2VX?=
 =?utf-8?B?dXlkczN1Yk84dXE5eHlPMWxJR1RzeVc4ZVhuVXNhdXBDaHEybFc2KzlRSUdT?=
 =?utf-8?B?OWdoWnl6MDRBRXc3eCtBUThPVjF0ZStFVGNPZzBlMDIwcmUzV04wbTFjd0Y1?=
 =?utf-8?B?a1dXV3FWbU1DYlRhbGVmb0RmNHQwRkZSNWdTNm1TbUxJK29tVG1PRVV4ZjBP?=
 =?utf-8?B?MjJ1bktnWndxVWV5MzhwUjhhSjNTOU0zbWtDTTd2WERuV0JCazJaMHBnMTlr?=
 =?utf-8?B?ZkIwQjd5NUlPVTdaNnpNeUVrUEZSMVQ0YTBBMC8zNk00MXlmaWdEUGtCMXU2?=
 =?utf-8?B?REN3QTVzV1BGTVRnazBQdnY4ZnVtaW9wU2Z0eExSTllVMm5DVFVaZXNwMDJ5?=
 =?utf-8?B?NW5tVDRwckEyTWJkeDNDQnBoaCt4Uk80ZVFEdU9pWlppd0xMYmUyZmpmeFBh?=
 =?utf-8?B?dDBTVGVST0cwOWxkYWdtRUNOeVRUVlFFL3VTRXBPalhDMi9DdTVnREFsUlJT?=
 =?utf-8?B?YjRwWjJuaDJKM01qWVlpVWlmdk40dkJSMDd2ai9KeVJoYjcyUkprTjRjR01r?=
 =?utf-8?B?VnF4RWQybXdQbEplMmY2MmpjUXdLLy91dHZkY0tkak1NVFZTa2xkY290Yy83?=
 =?utf-8?B?QzRnRk1CVWxQWmpoWjQwLzl0YnBqb01LSGcvRlJ5UXJYMTN5T3FkUkpva1Np?=
 =?utf-8?B?VU5KWlBWMWZxZFBNZWluS01hUVhpemRYbVltemxIeW9ZN2JFTlEwTks4aDh3?=
 =?utf-8?Q?6/VTN3hstr9gwxuE=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e6ba0c87-15e3-402d-2fbd-08de72febca5
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2026 17:12:34.9216
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /9qF/6sahq5y+faiNtGspbdV2+cIQRU4YuDl0pD2YpLaDsl+jqSJNh7vc0F4DhsrWPtIGKj3uhtgxrwZedeRr+7hzge3KI4fQr1zaqlkBfk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB7399
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71506-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,intel.com:mid,intel.com:dkim];
	MIME_TRACE(0.00)[0:+];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[46];
	DKIM_TRACE(0.00)[intel.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
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
X-Rspamd-Queue-Id: A17DB17A79F
X-Rspamd-Action: no action

Hi Babu,

On 2/20/26 2:44 PM, Moger, Babu wrote:
> On 2/19/2026 8:53 PM, Reinette Chatre wrote:

>> Summary of considerations surrounding CLOSID/RMID (PARTID/PMG) assignment for kernel work
>> =========================================================================================
>>
>> - PLZA currently only supports global assignment (only PLZA_EN of
>>    MSR_IA32_PQR_PLZA_ASSOC may differ on logical processors). Even so, current
>>    speculation is that RMID_EN=0 implies that user space RMID is used to monitor
>>    kernel work that could appear to user as "kernel mode" supporting multiple RMIDs.
>>    https://lore.kernel.org/lkml/abb049fa-3a3d-4601-9ae3-61eeb7fd8fcf@amd.com/
> 
> Yes. RMID_EN=0 means dont use separate RMID for plza.

Thank you very much for confirming. 

...

>> How can resctrl support the requirements?
>> =========================================
>>
>> New global resctrl fs files
>> ===========================
>> info/kernel_mode (always visible)
>> info/kernel_mode_assignment (visibility and content depends on active setting in info/kernel_mode)
> 
> Probably good idea to drop "assign" for this work. We already have mbm_assign mode and related work.

hmmm ... I think "assign" is generic enough of a word that
it cannot be claimed by a single feature. 


> info/kernel_mode_assoc or info/kernel_mode_association? Or We can wait later to rename appropriately.

yes, naming can be settled later.

> 
>>
>> info/kernel_mode
>> ================
>> - Displays the currently active as well as possible features available to user
>>    space.
>> - Single place where user can query "kernel mode" behavior and capabilities of the
>>    system.
>> - Some possible values:
>>    - inherit_ctrl_and_mon <=== previously named "match_user", just renamed for consistency with other names
>>       When active, kernel and user space use the same CLOSID/RMID. The current status
>>       quo for x86.
>>    - global_assign_ctrl_inherit_mon
>>       When active, CLOSID/control group can be assigned for *all* (hence, "global")
>>       kernel work while all kernel work uses same RMID as user space.
>>       Can only be supported on architecture where CLOSID and RMID are independent.
>>       An arch may support this in hardware (RMID_EN=0?) or this can be done by resctrl during
>>       context switch if the RMID is independent and the context switches cost is
>>       considered "reasonable".
>>       This supports use case https://lore.kernel.org/lkml/CABPqkBSq=cgn-am4qorA_VN0vsbpbfDePSi7gubicpROB1=djw@mail.gmail.com/
>>       for PLZA.
>>    - global_assign_ctrl_assign_mon
>>       When active the same resource group (CLOSID and RMID) can be assigned to
>>       *all* kernel work. This could be any group, including the default group.
>>       There may not be a use case for this but it could be useful as an intemediate
>>       step of the mode that follow (more later).
>>    - per_group_assign_ctrl_assign_mon
>>       When active every resource group can be associated with another (or the same)
>>       resource group. This association maps the resource group for user space work
>>       to resource group for kernel work. This is similar to the "kernel_group" idea
>>       presented in:
>>       https://lore.kernel.org/lkml/aYyxAPdTFejzsE42@e134344.arm.com/
>>       This addresses use case https://lore.kernel.org/lkml/CABPqkBSq=cgn-am4qorA_VN0vsbpbfDePSi7gubicpROB1=djw@mail.gmail.com/
>>       for MPAM.
> 
> All these new names and related information will go in global structure.
> 
> Something like this..
> 
> Struct kern_mode {
>        enum assoc_mode;
>        struct rdtgroup *k_rdtgrp;
>        ...
> };
> 
> Not sure what other information will be required here. Will know once I stared working on it.
> 
> This structure will be updated based on user echo's in "kernel_mode" and "kernel_mode_assignment".

This looks to be a good start. I think keeping the rdtgroup association is good since
it helps to easily display the name to user space while also providing access to the CLOSID
and RMID that is assigned to the tasks.
By placing them in their own structure instead of just globals it does make it easier to
build on when some modes have different requirements wrt rdtgroup management.
You may encounter that certain arrangements work better to support interactions with the
task structure that are not clear at this time.


> 
> 
>> - Additional values can be added as new requirements arise, for example "per_task"
>>    assignment. Connecting visibility of info/kernel_mode_assignment to mode in
>>    info/kernel_mode enables resctrl to later support additional modes that may require
>>    different configuration files, potentially per-resource group like the "tasks_kernel"
>>    (or perhaps rather "kernel_mode_tasks" to have consistent prefix for this feature)
>>    and "cpus_kernel" ("kernel_mode_cpus"?) discussed in these threads.
> 
> So, per resource group file "kernel_mode_tasks" and "kernel_mode_cpus" are not required right now. Correct?

Correct. The way I see it the baseline implementation to support PLZA should be 
straightforward. We'll probably spend a bit extra time on the supporting documentation
to pave the way for possible additions.

>>    User can view active and supported modes:
>>
>>     # cat info/kernel_mode
>>     [inherit_ctrl_and_mon]
>>     global_assign_ctrl_inherit_mon
>>     global_assign_ctrl_assign_mon
>>
>> User can switch modes:
>>     # echo global_assign_ctrl_inherit_mon > kernel_mode
>>     # cat kernel_mode
>>     inherit_ctrl_and_mon
>>     [global_assign_ctrl_inherit_mon]
>>     global_assign_ctrl_assign_mon
>>
>>
>> info/kernel_mode_assignment
>> ===========================
>> - Visibility depends on active mode in info/kernel_mode.
>> - Content depends on active mode in info/kernel_mode
>> - Syntax to identify resource groups can use the syntax created as part of earlier ABMC work
>>    that supports default group https://lore.kernel.org/lkml/cover.1737577229.git.babu.moger@amd.com/
>> - Default CTRL_MON group and if relevant, the default MON group, can be the default
>>    assignment when user just changes the kernel_mode without setting the assignment.
>>
>> info/kernel_mode_assignment when mode is global_assign_ctrl_inherit_mon
>> -----------------------------------------------------------------------
>> - info/kernel_mode_assignment contains single value that is the name of the control group
>>    used for all kernel work.
>> - CLOSID/PARTID used for kernel work is determined from the control group assigned
>> - default value is default CTRL_MON group
>> - no monitor group assignment, kernel work inherits user space RMID
>> - syntax is
>>      <CTRL_MON group> with "/" meaning default.
>>
>> info/kernel_mode_assignment when mode is global_assign_ctrl_assign_mon
>> -----------------------------------------------------------------------
>> - info/kernel_mode_assignment contains single value that is the name of the resource group
>>    used for all kernel work.
>> - Combined CLOSID/RMID or combined PARTID/PMG is set globally to be associated with all
>>    kernel work.
>> - default value is default CTRL_MON group
>> - syntax is
>>      <CTRL_MON group>/MON group>/ with "//" meaning default control and default monitoring group.
>>
>> info/kernel_mode_assignment when mode is per_group_assign_ctrl_assign_mon
>> -------------------------------------------------------------------------
>> - this presents the information proposed in https://lore.kernel.org/lkml/aYyxAPdTFejzsE42@e134344.arm.com/
>>    within a single file for convenience and potential optimization when user space needs to make changes.
>>    Interface proposed in https://lore.kernel.org/lkml/aYyxAPdTFejzsE42@e134344.arm.com/ is also an option
>>    and as an alternative a per-resource group "kernel_group" can be made visible when user space enables
>>    this mode.
>> - info/kernel_mode_assignment contains a mapping of every resource group to another resource group:
>>    <resource group for user space work>:<resource group for kernel work>
>> - all resource groups must be present in first field of this file
>> - Even though this is a "per group" setting expectation is that this will set the
>>    kernel work CLOSID/RMID for every task. This implies that writing to this file would need
>>    to access the tasklist_lock that, when taking for too long, may impact other parts of system.
>>    See https://lore.kernel.org/lkml/CALPaoCh0SbG1+VbbgcxjubE7Cc2Pb6QqhG3NH6X=WwsNfqNjtA@mail.gmail.com/
> 
> This mode is currently not supported in AMD PLZA implementation. But we have to keep the options open for future enhancement for MPAM. I am still learning on MPM requirement.
> 
>>
>> Scenarios supported
>> ===================
>>
>> Default
>> -------
>> For x86 I understand kernel work and user work to be done with same CLOSID/RMID which
>> implies that info/kernel_mode can always be visible and at least display:
>>     # cat info/kernel_mode
>>     [inherit_ctrl_and_mon]
>>
>> info/kernel_mode_assignment is not visible in this mode.
>>
>> I understand MPAM may have different defaults here so would like to understand better.
>>
>> Dedicated global allocations for kernel work, monitoring same for user space and kernel (PLZA)
>> ----------------------------------------------------------------------------------------------
>> Possible scenario with PLZA, not MPAM (see later):
>> 1. Create group(s) to manage allocations associated with user space work
>>     and assign tasks/CPUs to these groups.
>> 2. Create group to manage allocations associated with all kernel work.
>>     - For example,
>>     # mkdir /sys/fs/resctrl/unthrottled
>>     - No constraints from resctrl fs on interactions with files in this group. From resctrl
>>       fs perspective it is not "dedicated" to kernel work but just another resource group.
> 
> That is correct. We dont need to handle the group special for kernel_mode while creating the group. However, there will some handling required when kernel_mode group is deleted. We need to move the tasks/cpus back to default group and update the global kernel_mode structure.

Good point, yes.


...

>> Dedicated global allocations for kernel work, monitoring same for user space and kernel (MPAM)
>> ----------------------------------------------------------------------------------------------
>> 1. User space creates resource and monitoring groups for user tasks:
>>       /sys/fs/resctrl <= User space default allocations
>>     /sys/fs/resctrl/g1 <= User space allocations g1
>>     /sys/fs/resctrl/g1/mon_groups/g1m1 <= User space monitoring group g1m1
>>     /sys/fs/resctrl/g1/mon_groups/g1m2 <= User space monitoring group g1m2
>>     /sys/fs/resctrl/g2 <= User space allocations g2
>>     /sys/fs/resctrl/g2/mon_groups/g2m1 <= User space monitoring group g2m1
>>     /sys/fs/resctrl/g2/mon_groups/g2m2 <= User space monitoring group g2m2
>>
>> 2. User space creates resource and monitoring groups for kernel work (system has two PMG):
>>     /sys/fs/resctrl/kernel <= Kernel space allocations
>>     /sys/fs/resctrl/kernel/mon_data               <= Kernel space monitoring for all of default and g1
>>     /sys/fs/resctrl/kernel/mon_groups/kernel_g2   <= Kernel space monitoring for all of g2
>> 3. Set kernel mode to per_group_assign_ctrl_assign_mon:
>>     # echo per_group_assign_ctrl_assign_mon > info/kernel_mode
>>     - info/kernel_mode_assignment becomes visible and contains
>>     # cat info/kernel_mode_assignment
>>     //://
>>     g1//://
>>     g1/g1m1/://
>>     g1/g1m2/://
>>     g2//://
>>     g2/g2m1/://
>>     g2/g2m2/://
>>     - An optimization here may be to have the change to per_group_assign_ctrl_assign_mon mode be implemented
>>       similar to the change to global_assign_ctrl_assign_mon that initializes a global default. This can
>>       avoid keeping tasklist_lock for a long time to set all tasks' kernel CLOSID/RMID to default just for
>>       user space to likely change it.
>> 4. Set groups to be used for kernel work:
>>     # echo '//:kernel//\ng1//:kernel//\ng1/g1m1/:kernel//\ng1/g1m2/:kernel//\ng2//:kernel/kernel_g2/\ng2/g2m1/:kernel/kernel_g2/\ng2/g2m2/:kernel/kernel_g2/\n' > info/kernel_mode_assignment
>>
> 
> Currently, this is not supported in AMD's PLZA implimentation. But we need to keep this option open for MPAM.

Right. I expect PLZA to at least support "global_assign_ctrl_inherit_mon" mode
since that is the one we know somebody is waiting for. I am not actually sure about
"global_assign_ctrl_assign_mon" for PLZA. It is the variant intended to be implemented
by this RFC submission and does not seem difficult to implement but I have not really heard
any requests around it. Please do correct me if I missed anything here.

> 
>> The interfaces proposed aim to maintain compatibility with existing user space tools while
>> adding support for all requirements expressed thus far in an efficient way. For an existing
>> user space tool there is no change in meaning of any existing file and no existing known
>> resource group files are made to disappear. There is a global configuration that lets user space
>> manage allocations without needing to check and configure each control group, even per-resource
>> group allocations can be managed from user space with a single read/write to support
>> making changes in most efficient way.
>>
>> What do you think?
>>
> 
> I will start planning this work. Feel free to add more details.
> I Will have more questions as I start working on it.
> 
> I will separate GMBA work from this work.
> 
> Will send both series separately.
> 
> Thanks for details and summary.
> 

Thank you very much.

Reinette


