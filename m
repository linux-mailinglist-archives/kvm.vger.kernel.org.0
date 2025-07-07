Return-Path: <kvm+bounces-51703-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F3C2AFBC93
	for <lists+kvm@lfdr.de>; Mon,  7 Jul 2025 22:32:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8914516C1EB
	for <lists+kvm@lfdr.de>; Mon,  7 Jul 2025 20:32:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4351220F33;
	Mon,  7 Jul 2025 20:32:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DNfZe93S"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70AD712FF69;
	Mon,  7 Jul 2025 20:32:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751920355; cv=fail; b=HNQu4qLZLFKqOzd1LkQlzQKBCBO8ZMYc3VF1Bcwjlg4HaH6/vBxEXvt4Xknz4yUrhCLQLUddVMh90czX4yJQZsLu4Z+HeXkS4rZ3ilryShlEy2Qy3vE6RS/uddIXCLAtG5ij69YxDWOb/bdIlqpxS3dRyJivE8VojIhmxPoRkWs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751920355; c=relaxed/simple;
	bh=YmWymMTeyf3Mz999BORbgdvH+jjso0w9ebDyee3f6Hg=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=DdXnYukKYlvkIBRJYXuMtIDENnx8OLvIEntePduhWmOA0Eq5SIWh1ucxF8a9E8/jYwWWIWQydSSWCrCZPYyBxo0XJZWejnpBp4rlX7U0ttqdZKJdVQil/KO9OGVQ08VVV9KH6UtSHeq6TC0YfH/bib7dz+jGHoJzk93QbgcBdws=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DNfZe93S; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751920353; x=1783456353;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=YmWymMTeyf3Mz999BORbgdvH+jjso0w9ebDyee3f6Hg=;
  b=DNfZe93Sb0bN9izaNOEhdqPYbDj53nq4YufR0hlT9VqWMLbvR1s3r7Tw
   O0Ddq7zEveuG54ziERe5f3AQXL5AWwapM40TdkHZuhgZxXKY6jSt8VRwp
   HVNUyjc9wS1+NS+S5MnyNkFt645HiAOVbH6LPuU/IiCb41pnm00JN/sNp
   TL9qIxbAwhBZ8+P2resjx9kp5dxqSRakWFfAwWJzfiPnh1P4qMxmMDpQp
   0BT66/apndgKBaq7HGX23xOnynxv+EMiYVCDvzOz6s4AtdPSRSvRnjq5f
   fqDbN8tZj9ux30tQ3zUGjm/Pd+EY7bS/Z4zTmrirLMdwp53DKW/hTnGmU
   g==;
X-CSE-ConnectionGUID: j9/Q3vpXQnqYL8qxahS8jg==
X-CSE-MsgGUID: gA8OXFo1Qcuu/fk+UpYw2w==
X-IronPort-AV: E=McAfee;i="6800,10657,11487"; a="56763360"
X-IronPort-AV: E=Sophos;i="6.16,295,1744095600"; 
   d="scan'208";a="56763360"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2025 13:32:32 -0700
X-CSE-ConnectionGUID: rq6RG3ztTjeqJKNeAo1pXg==
X-CSE-MsgGUID: WF0Om5HFRvCdCto1ZG3hlQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,295,1744095600"; 
   d="scan'208";a="156045350"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2025 13:32:32 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 7 Jul 2025 13:32:31 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Mon, 7 Jul 2025 13:32:31 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (40.107.220.47)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 7 Jul 2025 13:32:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=f64TiGUXWQMOC8e0CZwD10FKqL4NuWwq361JAiIszL9UsTbfzB7AXQgm3PLfPCcsyjDgjeLPrq+aJnMbpkf2SuWj2zvOg1bVxxIObdSKsvSS9mafjzWL/cpa5EceIfwksLD5tWSiroH3hmqk0tuCg+GX3yuz5fFTZmed2O7+aEqi19MMXH4W+iR4Tnzf36ehEZeyW4AFKZE8rbc5YeReVZuKLRvUN43zAD/Lv3IrQV987IWqSYCf61qTrvk2fJbmv8+lUV9Ivs4S1MfLZdsOafJvz6gZe/tcRGfBcHm0jDdoY09WAVCofCNEhHHw8pFNRG9Mira3n2ALrjhYbJaEWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Gk5IImT0vPiWe2LrQ3tXAODuMMYAitYt7pj1EDmT1LQ=;
 b=mRv9EstEfpPEjaprgYcGNlHTq4qV3VmBiRcdGL7PdO+ZMZGK+Z9sOfeLbNCA5CGk6i6UMkHJ2/7KTRJGxQ9ojuoPmzBTC196DRqAMbRP8YuZtxjhYnVJlS/N2h2bD4I06sxT7xW45LjRm61UJEPTYF4Y3GBm2NdxTTcJWapycKl6fYogo1FvVKEZhlBgXkRDhpfgsvaEkOMruelXfaKqyabCsC0MwHOm/M9mGDLNAaWC9h8oqTYUkbOnzD9Nt1qIbV+1GCONjaH20m/dVZIzX5o51TZFoSSva3EBeITEfTN3l187qqleM/9xmYf/PCivZjcaICcRAsfEButWa95BTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BYAPR11MB3320.namprd11.prod.outlook.com (2603:10b6:a03:18::25)
 by CO1PR11MB5058.namprd11.prod.outlook.com (2603:10b6:303:99::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.26; Mon, 7 Jul
 2025 20:32:28 +0000
Received: from BYAPR11MB3320.namprd11.prod.outlook.com
 ([fe80::e8c4:59e3:f1d5:af3b]) by BYAPR11MB3320.namprd11.prod.outlook.com
 ([fe80::e8c4:59e3:f1d5:af3b%7]) with mapi id 15.20.8901.024; Mon, 7 Jul 2025
 20:32:28 +0000
Message-ID: <a9ed726f-a44b-4497-be21-d5a10febc21b@intel.com>
Date: Mon, 7 Jul 2025 13:32:26 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 06/10] x86/nmi: Add support to handle NMIs with source
 information
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
 <20250612214849.3950094-7-sohil.mehta@intel.com>
 <CY8PR11MB7134EC0ACDE4772F2CB8A87A894FA@CY8PR11MB7134.namprd11.prod.outlook.com>
From: Sohil Mehta <sohil.mehta@intel.com>
In-Reply-To: <CY8PR11MB7134EC0ACDE4772F2CB8A87A894FA@CY8PR11MB7134.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0015.namprd05.prod.outlook.com
 (2603:10b6:a03:33b::20) To BYAPR11MB3320.namprd11.prod.outlook.com
 (2603:10b6:a03:18::25)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR11MB3320:EE_|CO1PR11MB5058:EE_
X-MS-Office365-Filtering-Correlation-Id: efe8df48-2f98-4985-1f1c-08ddbd9563f6
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?QUtVdnNpZmd4UjB0cm9xNHpwUDZ0YW80ZzFHSnMyYlJEOXRRKzZ4U1NYeGxn?=
 =?utf-8?B?YVlGSnRWbjd4UHBmUldlQlo2aTJPOFo0UEcwQWJqMXl3cmJpQktVVkdqcXZL?=
 =?utf-8?B?QUhNOWlERTIvUnRMNFdiODZQNnBEdmhzKzJMRFljWjBCdDFkKzRRYjl2R1JR?=
 =?utf-8?B?MmZZWFhzT29MeThHSWpQSWd2bVBEckMyTEJ3ZExFdFd5Wm5meC9ZVWxMRGJL?=
 =?utf-8?B?L2kwc2l3M3Z2QldaTSt4TnY5ZUZjcVdFb1UrdytqN0VMTmc1TEVHVllUQ0sr?=
 =?utf-8?B?RHN1YWNQSkQ0emtRcGNjVkZ1RlEyc3lqRng1S0Q2TWRQaXBQajJ5dGJ3MDdn?=
 =?utf-8?B?a2ZZcFI3aWFHYmRncEFGVTl1dEFMU2VQTDZrRGdURHMwZHo2ODJ6a2QrUEcv?=
 =?utf-8?B?cjVveVdTOUFXYWFXcTBNRy9SWUkvaGV1b1lSNkVXekN4Z1lrRng1Y011TTJ5?=
 =?utf-8?B?KzlhbGJjS29teW5ocW54MElqUml6SkVjOXgwYXZXMi9NTW9XWFl2MjBnWFdV?=
 =?utf-8?B?UkZBZGR0QnI4V0xONzc4VWk3dDk1dDU3RHhmTzArU0FXWUczRnQ3Y2JlN2pC?=
 =?utf-8?B?K1k0eTJuUXo0d0JHUVYxWEhZU01oY2FVeFVQVEJjRWlVaFdaL0RGRTBqTkRy?=
 =?utf-8?B?dDJiWFlTYjJnMDlYejdCbldYT1dPbmxpYnNFWlVpRlR0eUNxbVdxVDR0eTZl?=
 =?utf-8?B?ZUFuS241TTE0Y204L29KSHU1TXI4VG5SUlFPQW9ETnhtTjNsKytQSDlNeG5T?=
 =?utf-8?B?U0trKzRCTWw5RjJkeWZJTm56OWxyZ2ozbGdWNyt5S3MzU29QK3dmS0Q0M0h2?=
 =?utf-8?B?RE9vR2dSZzF2NWF0dGM4T2pBSmlMWU16NFN2amVqeG9OUXB0ZkMzSGw2bnhv?=
 =?utf-8?B?VFhKWGdHcHYzbE1xZVRaZVFSYWo4REc0RUFNN2xLR0VPSE16VXNmeWo2SFg1?=
 =?utf-8?B?OG5WdVQ4eEpBdGJEOFV2K1Z2U3doUUM3cHJJenJKbDFVQVNUbjBPUXE5L3ZI?=
 =?utf-8?B?U3pKOXNrUk9STGYzZndtYlFUL21TVVVOMlpKYWZYd2N0M1RVL3oydHJxZi9L?=
 =?utf-8?B?S3lRek0vZUxHdHFubGVEc1FVSG44cTVleHZub3pMRndTUjNHQUZsOC9KczJm?=
 =?utf-8?B?UmlSNmkvRkE0c0dRUTB2QVI2emhKdWVwRW5tTHpoVldOc2dSMHhoYXVkVzk5?=
 =?utf-8?B?WFYrVk5nMTVMRHZneUxCeWNacE5GQmM4NXdHME1Qb3BNcGQxUWltbDRzc0ZM?=
 =?utf-8?B?M2tzR0lEMlQwbVExZWVTaGloZmZ3eUhRTTNVL3NrNGpVQmMvN3htRERTUUZW?=
 =?utf-8?B?NXEwck8raVdhTFdWV2hZSU1ycGlEc0JqeERvRVVaMERlOG9pVnBMWEdPSlY1?=
 =?utf-8?B?SmNISnRJdWpua0dpRU9FcGFFajdwKzVIdXl0UUxzY2hJalBjWTFlTVB3NURQ?=
 =?utf-8?B?T3F5WktMOHpqdVRoUW5PaHBNTWNyamR3Ynp1T0tJOUxOWUlEZkVsMlRVcmR4?=
 =?utf-8?B?eGtvMDNWRkdPWGlrQ3o2MktURTJIUDdJNmlFTFdNT1NaQmVzVS9KT084VFNy?=
 =?utf-8?B?c1UvZGttMUh5cmh4WWFrZEQzb2h3UUZzVEtoWEFwS2VvVHF4RlRwY2lZaWFY?=
 =?utf-8?B?M0lyMEtxOTBLNmw4Vk1OaEVvNERTVGk2aTdBUzREZWZYQ1dSbmdEVGZOeFlv?=
 =?utf-8?B?SXhNZnRwbWNjWDBSSVBSQUoyUnBEYjYrWkl2NXZiMUk2WWFGYkg4WURlRlFw?=
 =?utf-8?B?d0tCTmZVTkhhOU5UVVBZcUUybVh5QXgzNUgvbmNmZXhSL2pQUExCZDc3SmdQ?=
 =?utf-8?B?b1hyc0N3ZVB0cGlQdjMxRFcweXdsazBwTDNVV3hhRm1kY0lPaEU1a3RxQUp6?=
 =?utf-8?B?RkRGY3RjN0t2eVZpUmpJN0FJUGNlMlkxUWhWTnZheEx0dHJaRUswTS80RVB2?=
 =?utf-8?Q?E45Blcf5Ri4=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3320.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZGsvSnRVbVMxRlRSbkRGcG51STJVeW5IYXJoWDAxaGpxVm13YTRFakJ3VDZT?=
 =?utf-8?B?Z2thcTN2RUlRQy9nWXpHYjBRV2pDbEZSSlYwcDJFSnVUMXV2MWUySW9lRXdS?=
 =?utf-8?B?Q1pYa0Vzc1U1MWYvUWJjaW5jU0crN1F3dTA3aXlQMWJnMW0yYzBaU2N2VDJ1?=
 =?utf-8?B?bFVRTml0SWVsK2VjR2NTbjJZVlk4U09CNzFNVmM0Z1RPMUUzUzdZRHprMGd6?=
 =?utf-8?B?ZG5OcjIyNzJZVHN4ZWd3TkJ5T1llVGIveEdhU0twMWhNVGVUQ2NaYjJnK2FE?=
 =?utf-8?B?clVEYXN3YlgwVC9LYXdPQjdnajNUeVg5b3hwVlJKbE5SYlhyd3RSeEpER1M2?=
 =?utf-8?B?d0lMcXdtSHMyc01JeDhMUG8vbnRHVjdWUHVkR1NUSGdocXNwKzJ0TDRNMUdr?=
 =?utf-8?B?WkI1ZHN6d1l4T20rWTBBOWxJR3FCNUs4Z2Z2ai9UMWZSRjhpOGNTZVpuMjNB?=
 =?utf-8?B?UHdISmNVQTFKbkNHUVlOWGt0MzNsMmFjbStQNnFXQ3AvTG43c1BreTUxR01h?=
 =?utf-8?B?SC83V2RJdmNzdWZWVGQ2T1F5dXlBc3hkeWRSYlVYQUllUzZOSC9wYnBTRlJ0?=
 =?utf-8?B?bU5pSHJSeDBlUlZ5eXlrRExnVUZ1OXlvMG9KeFN5OVY5L2xsUFdnNEhhT0sv?=
 =?utf-8?B?MXIvVHlkT3VwNEVFS2d0ZjJZa09lZTF6RkxIa1dwcUloUlcxUEw2a2pjdjFV?=
 =?utf-8?B?OFhwQnNjcnRCVEI5WHFnbE5pWTU2Wkp5NnZvZlNwbmpPOVl2QUdxeE5CQmdP?=
 =?utf-8?B?MlkrWnhjcTNHakVqSVc0NFF2OUxEeVMvMk4zK3J3NHl2MU5iQ2ZnNkt4T1l0?=
 =?utf-8?B?NGhCaDU1SUpFc0ZBQmU5c1JVLzBRZTR2UE1WTG9rY0lwU05jV0RkQXRJK09s?=
 =?utf-8?B?enZKZ1hIa21icW9PS3cvVEtCSjBnODFORmcwK2haa2ZZY200c2VXZThzem5o?=
 =?utf-8?B?NVYyMmkyOW9FR1ZLWE9oemNEVUlJVW9Rb0FuUHB5ZmovYTYvSnRDdDArMmM1?=
 =?utf-8?B?UUxYUXBPYUd0TUErK2pEdFdNOXZ3L0pXN2kwVmxyZzlwUHRaamRoWnN1a2VO?=
 =?utf-8?B?VzBNamxxYU5SUEtHSWZSQXFWRlRuQTJlYUYyRWlQbGNBMzYrdkQ0bnhCOERI?=
 =?utf-8?B?RGVqdFVya09pTXpaQUpJR0pveGJFemd6Mm5mMTlqZEFoYzhlSmYrZDFmencz?=
 =?utf-8?B?dHFkblFwNjBmY3hjckpQc0w1U3E0bG1DTTQ5bk0wbWtoZkNqbjYyY0l3ekhr?=
 =?utf-8?B?SzdRa2Z1NWprMmhINjdGMG5SVkNjcXlvcFM2UXVJUG04ekZ5R2hDWnRQaEM3?=
 =?utf-8?B?cjRnZkY0QlBUbkhiakRZYlFMYTZlWWxxODUwenJBMjJUSEdNcXhONS9pd0dP?=
 =?utf-8?B?Y3hjRkU3VGpQbXRaWjgzU2JDaitLbDlPZDd2QlE0eVNvb3M3TWIvQWlxanlr?=
 =?utf-8?B?NFZrdE1TeUVkbjM3Sks1TjBuNzRYek1TaWVEUnFMWXg2Ti9LZ20za1lPQzQ1?=
 =?utf-8?B?T2NLN056VThZQ1BvRkdRN1dpUG1kNmdFT2tROWNSY1huTURhQTNoOXdOUkFR?=
 =?utf-8?B?cEE0eGpnK2loYjdnVzk1R1ZZeWJ1VVNBY2YxWnBjcnUyN29HK0JmOStUelpw?=
 =?utf-8?B?RWJUcWV0MXBva2VNRkthenBodks1cWROL2N6M1FPVUVtazllS21waWtFQmgz?=
 =?utf-8?B?TWVqWGZnbUs2VmxxL2VvZHhZYUxKWEp2SEEvenAxZUtKcVVCS2RvMFppYnZo?=
 =?utf-8?B?Qm1PUlRrMlhHWDFvRWZqdDM5SGQzdHBlT3ZGUjdOOHN4Y3p2TWttdHNWRDdD?=
 =?utf-8?B?SDdnZEdJSkxXd2piS2dFbmdQZERlbjNlaStsT21EbzdVUnRyOVA0YWxjaEk1?=
 =?utf-8?B?cGx6akNrN0ZuSk5vV3o3ZW0zenVvbDVKYm5pRHo0TnZCWkt0YVFZcW1rKzFo?=
 =?utf-8?B?K2JLZFdkM0JDSmh2clhmS3RYWVBDV25SelZDWEwxTFJMa1ArMUVRWEgySVAr?=
 =?utf-8?B?ZUhGWDlBbmxGZXB6dXk1VWxpU25XendUMDV0N2JabHNVcUpJUWNUUnZ2d0Jw?=
 =?utf-8?B?VXd5NjA2dkhGYTlqeTdHVWFpK1ZyUzNEMEFkTG5MREx5SElvNllNUEJPendO?=
 =?utf-8?Q?dAHvWblNx3thUg9UFnz2p0G+o?=
X-MS-Exchange-CrossTenant-Network-Message-Id: efe8df48-2f98-4985-1f1c-08ddbd9563f6
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3320.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2025 20:32:28.2615
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6EFT89+t8ccwyvqObkcrE2L7sC+XYtYuN2oecSI/VFFq19Sjw1bFuZIXwbmjLq4F8XlW5/h/O650KL0Vn5LP5w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5058
X-OriginatorOrg: intel.com

On 7/7/2025 6:50 AM, Zhuo, Qiuxu wrote:

> Is it possible for the "source_bitmap" to have some non-NMIS_NO_SOURCE bit set 
> while the user registers their NMI handler with the NMIS_NO_SOURCE type? 
> 

IIUC, this is what you are asking:

Someone registers a handler without any source information.
For example, GHES does this.

register_nmi_handler(NMI_LOCAL, ghes_notify_nmi, 0, "ghes", NMIS_NO_SOURCE);

Now, when a GHES NMI shows up, can it have anything other than bit 0
(NMIS_NO_SOURCE) set in the source bitmap?

I believe the answer is no. Unless the GHES implementation or the
hardware has a bug, this should not happen. If this happens, it would
get logged as an unknown NMI in the kernel log.


> If so, we may need to allow the NMI handler with the NMIS_NO_SOURCE type to be 
> invoked unconditionally to ensure no NMIs are lost.
> 

If the kernel can't rely on the accuracy of the source_bitmap, then
NMI-source as a feature starts losing value.

Sohil

