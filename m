Return-Path: <kvm+bounces-45763-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 45AA2AAEE08
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 23:49:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5AE7D173991
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 21:49:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7649928B7D4;
	Wed,  7 May 2025 21:49:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KucRQK/P"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F6A31D63C6;
	Wed,  7 May 2025 21:49:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746654559; cv=fail; b=sNN6SU5ObM7/MbYuDL1z4/Pd/ITMTzToA0VtVmTdN9qDONTq3RwUUH53bR6rZruDrJ90+2mxfrzAv3ibCQaAObo6HMTlPtSOvdDqkG71rwGkcmrvY7r74K00xQqqEk8VJzLQW9vS5Q9KtGrX3xwkuSSCfWRjaac9bOKyX429XUs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746654559; c=relaxed/simple;
	bh=iltY32XystF+n8BF+RG2nojiZ3HoWGEmqXDQ5MUQ2JY=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=XZOxstx+aTN0gBzNZIPEeRfHwZeddJ4Y0bLsbuepbUKJ2X7hqYGgpHLgcAehc7L1qkw82Omhhtw17x1WB0EMOLBh/J9lFIAWnRH6vJQayaM811l2v+wl0AfONUVPB9/PlVFNMBMl5GfhLwnwhykBmOhd5MRgH+rtkM8//oSTYMc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KucRQK/P; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746654558; x=1778190558;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=iltY32XystF+n8BF+RG2nojiZ3HoWGEmqXDQ5MUQ2JY=;
  b=KucRQK/PN5zbRzt9bjFQ5qU2j7CNHq9NI9VNvnM2roMaf43/yCvbJxcI
   wfiLv7wq/ZxHkTSctbjADoJccsdzVvLVOnYgmayx/9d+w/ARxn/U+gl/g
   ocXOQxFqAWGfHcuS2iYu5mK8TgD7cTR7x9xFHtL8eNx4a5z9ceK0i7+/Q
   ydL5NERoXMMpp4uyzd5oJ4oGh4nTua1NQc6+UGGUNssd174i9mA1aJkbv
   kR0LncnWarZUJTFS9GQLvtkY8Wn0haN61KFEIBacJ6iiJRcX367kLG1Il
   lVpVNyu88M9A82+pN1j08p3qlT0rc+KyyUQ4TFrqflb2TacgqgSH+oJqp
   Q==;
X-CSE-ConnectionGUID: f8Q7vAWDQoWKMk5Kckgw6A==
X-CSE-MsgGUID: UNhUdltERpeYSLS9ttl4rQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11426"; a="48573314"
X-IronPort-AV: E=Sophos;i="6.15,270,1739865600"; 
   d="scan'208";a="48573314"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2025 14:49:17 -0700
X-CSE-ConnectionGUID: y6KQWUi4SkinqDhdomqQ+g==
X-CSE-MsgGUID: 54h7Hp/gTZaS+lDFncZeBg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,270,1739865600"; 
   d="scan'208";a="136054217"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2025 14:49:15 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Wed, 7 May 2025 14:49:15 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Wed, 7 May 2025 14:49:15 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.46) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Wed, 7 May 2025 14:49:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FUaAHwuIWOap/+sUOIzvd1HUR9LKpSZKFBNJE3F50qZ+KIHHjvM3KMo3tcn5f+qt8UbT+4Ax2agqPCBifPunSearfAmTjrzfYJU1rzypeYNQDd68OMkp6wfJe517gt/1HvjRx/lEwz58em3oxhvC7LjBwsWUm2tVOczGCZQxLq+3CYRWWJThiVvgOaO2uBPz0mNL5X5Pvafb/LPyemoQRxZ8VhGGoYgmHwIfuTQ8JFX+RBEe0DuQA0BBfRd0d+nHvKp3Rdct8nLcLk02J6jas2TgHutUX6o7pcFR5W4ZUehU4XRPCv6LNWJfJi0zO6g+ZMRlItNWBpoYbALB6lfz7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s7Ld7gicPRg1GwYQ9W883Xfq+FoWdZwFTIz9MDr0Yls=;
 b=pIrkN01KQyCmdzwAiY+0PmZ27+DqnRtZxGlVw5ucDqOZbLQhwMAWOXJO0H2+02Q0UiD4/qMpuMbSVe4H/fbcoCV17I06e5pGOuCCzgKvlc/Z//UikqEgEP7AOgLNttlm3AjiTtJKVRnbz65VyNQqPGfcBfOvf5LIh9eOCc4ls8lPjzCHbXvHuqH4lTHc9W6fHWV3+G4pvhvD3kuhTWJ0gmETjdlb9joVm8TCBgQIZG2NJOc3daqKIHrhwqv6P2c7lPOlJd5gJuQvFb7lCp4NPGESWQpe+ICl+JqdPvW1ICq8kt8Whfv/0VQcGuCr18DczEpRmQpwu/MiKp3nZifBlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BYAPR11MB3320.namprd11.prod.outlook.com (2603:10b6:a03:18::25)
 by DM3PPFD3EB37DFC.namprd11.prod.outlook.com (2603:10b6:f:fc00::f52) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.34; Wed, 7 May
 2025 21:48:36 +0000
Received: from BYAPR11MB3320.namprd11.prod.outlook.com
 ([fe80::e8c4:59e3:f1d5:af3b]) by BYAPR11MB3320.namprd11.prod.outlook.com
 ([fe80::e8c4:59e3:f1d5:af3b%7]) with mapi id 15.20.8699.019; Wed, 7 May 2025
 21:48:36 +0000
Message-ID: <55527575-e3b8-4cf6-b09c-b81437e0c892@intel.com>
Date: Wed, 7 May 2025 14:48:34 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 5/9] x86/nmi: Add support to handle NMIs with source
 information
Content-Language: en-US
To: Peter Zijlstra <peterz@infradead.org>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>, Xin Li <xin@zytor.com>,
	"H . Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, "Thomas
 Gleixner" <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "Borislav
 Petkov" <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, "Sean
 Christopherson" <seanjc@google.com>, Arnaldo Carvalho de Melo
	<acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, Mark Rutland
	<mark.rutland@arm.com>, Alexander Shishkin
	<alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@kernel.org>, "Ian
 Rogers" <irogers@google.com>, Adrian Hunter <adrian.hunter@intel.com>, "Kan
 Liang" <kan.liang@linux.intel.com>, Tony Luck <tony.luck@intel.com>, "Paolo
 Bonzini" <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>,
	"Rafael J . Wysocki" <rafael@kernel.org>, Daniel Lezcano
	<daniel.lezcano@linaro.org>, Zhang Rui <rui.zhang@intel.com>, Lukasz Luba
	<lukasz.luba@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
	<mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Brian Gerst <brgerst@gmail.com>, Andrew Cooper <andrew.cooper3@citrix.com>,
	"Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Jacob Pan
	<jacob.pan@linux.microsoft.com>, Andi Kleen <ak@linux.intel.com>, Kai Huang
	<kai.huang@intel.com>, Nikolay Borisov <nik.borisov@suse.com>,
	<linux-perf-users@vger.kernel.org>, <linux-edac@vger.kernel.org>,
	<kvm@vger.kernel.org>, <linux-pm@vger.kernel.org>,
	<linux-trace-kernel@vger.kernel.org>
References: <20250507012145.2998143-1-sohil.mehta@intel.com>
 <20250507012145.2998143-6-sohil.mehta@intel.com>
 <20250507091442.GB4439@noisy.programming.kicks-ass.net>
From: Sohil Mehta <sohil.mehta@intel.com>
In-Reply-To: <20250507091442.GB4439@noisy.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0228.namprd13.prod.outlook.com
 (2603:10b6:a03:2c1::23) To BYAPR11MB3320.namprd11.prod.outlook.com
 (2603:10b6:a03:18::25)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR11MB3320:EE_|DM3PPFD3EB37DFC:EE_
X-MS-Office365-Filtering-Correlation-Id: d2fbe32f-7021-4426-e743-08dd8db0eb6c
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?YVFEcjJaMFNKREM1S1ZWWXMzeGpwd3hlN0V1d0M3R2tjYlNsRHBNQVIrNDVW?=
 =?utf-8?B?QXdZNmtGWmM5MjN2bXBOUUhETjRJQzlQVmd3RW56R1ZwamtWdEtwNmdrZFBn?=
 =?utf-8?B?NDdQY2hRR0svdmR4dmhUZHNUcUQ1eEVqZmNPcDJ3ZkV0ZS9XNVdYVFhIMUw1?=
 =?utf-8?B?R3hsMndwbDZ3RFRCNGZ5RFpKYTJKU2dkSFZnTXcxYWUzbHlBeWlxalhvb1BD?=
 =?utf-8?B?SC9UdUp0b0J6cjVlYjBWbExsK09pa1JLTXI3KzE5TzhiUXZkYUl2bk82Z3JL?=
 =?utf-8?B?MXFYMi9WcjRVYVRvcUJkbkJCdXo0K0JIalpxRGlZM2JFQm0yTEl0Wm16QThw?=
 =?utf-8?B?M1NDam1sSC8vdkh2dXVUcExwenpvL3hTNnpqYy90WHord1pKZ3FNR1BIMEFt?=
 =?utf-8?B?QVpIaG01TXJmYmZpSC9Bak1HY2JQeUgvTEtTeWs2Z0c2UU9PWnVvOXRSdkJM?=
 =?utf-8?B?UENzd3kwMzJYMnl6M3pPWkN5OGZHRk5tdHRPcXNrZnUwcWd6VzJINHF6WWhQ?=
 =?utf-8?B?UENSYnJaRlJsRkNjR1U5cnBkNmlLVGtIdnp1dEVyMmNja0d5QVNqUHljT1NY?=
 =?utf-8?B?R1Vxclhrb1BVa1AwZUxYaS9Pb3U1cWs0bnFYMFhWV0lzRWhadVlBQjZxdTVj?=
 =?utf-8?B?T0FZRmx6NUI5U3FFeTM3V0FSQmR3VFdrd3g4OFFhSkUxYnJGSjNRaGp0d3Rx?=
 =?utf-8?B?eG9venhDVXl0VG55amd1YWY3SEtqT3FvM0tVYitHVDlSN1hvbldQQk9IWlVX?=
 =?utf-8?B?SDdrZGFqcXhEaFZ5U2hhb0dROStWNmdMNnh0THVnVkREZFVqdmd6MjFVeldm?=
 =?utf-8?B?QXh1dHhJUlNqUjdlZDZncml5bUZ1ZCtPYXJqSnRFTVp4NG03TlJMME5zRFZV?=
 =?utf-8?B?dkhjM0FiRjZPdXh2d2RzTFdBTHBXbmZMZEUzeWdNRStYTHNqemQzLzFERGN1?=
 =?utf-8?B?dHNyOE9uNU4ycjVCWkZTbTBOSXUyTmo3ZGFCaEk5T0JZL2QzdjFVSVBXVjZj?=
 =?utf-8?B?bTU4c1BCUmdWanlFMWwrbWhLUEtXTCtjSTY2VWhkSEg3ZHcwc3pBWVFVVzk0?=
 =?utf-8?B?UEJsZjhSMnoxQmZZOGpWcno4K3ByQTA4Uk5UMm8wU1BrZWMrYVhVQUFwNTU3?=
 =?utf-8?B?MFVpRCtiTUdYUlA3R3BtZEtQbHI5S1k3Mmw0blJ6R2k5clVIUy8xNitwS0dx?=
 =?utf-8?B?ZmRDOU1kQkw5aGZrNnZXdkxvemZXa28xU21raGtIcHRheHo5OWVyclJBa0F3?=
 =?utf-8?B?OEtrQ1VKU3pISWhrODBoSmF4Wk9YcVpodlF6MVVwc1dxcDRPVjcwZXQvZFFD?=
 =?utf-8?B?dENUeVh0bTcyTGdsajhJU3U0MmdJVXBNM1JORzJ6Y3NubDZSaWViUU5ZUURW?=
 =?utf-8?B?TDlwK3d4a1pqYnFFYnlDU0Y0T1kvRjZKbzFhalhTUmlnNENUQW9rMHMxQ0tC?=
 =?utf-8?B?ckJoN0FGTmtnYzZ6Ym83SFFjVHhhZUpsSkUwQ2NhSmVqcGpOaE9ZSzlSMXVs?=
 =?utf-8?B?dDdoNXdCTUtQNTczYTVXUlo2UlNyQjhIZzZJZFptaFdjUUZCTHdvQ21wQXBR?=
 =?utf-8?B?QXFCR2MvK0hlSVJYbmFRcktEL0JvYkJNRmlUNFJXemRhYlY1NlpBa1ozcHAy?=
 =?utf-8?B?MEJnanh0Nk9pVDNUTzUyRjNTeVZ0d3p0WlJteFdlVHllM2QrQVQ0b25BcHEz?=
 =?utf-8?B?VXZxV0xMV2VSQmx1NVFMRmVXdEJaYUV1UlFLSHQvRWJNTHJkaUFzU05SYWdV?=
 =?utf-8?B?NFRkUVR6cFFkekh4bE1xNDJzZG5PcXhpL3JpcjBRb1ovUUE1STJFcmJQVDVh?=
 =?utf-8?B?bk5sOXFWbzE3UHFWMXREUFFNQjViQ2JFVW83WlE0VkxJSWE1OEp0WWlyeU9G?=
 =?utf-8?B?ZWtraCtLTW50MGFHQlpNNHpiWmlyN0VhZEd0QTRHdEZUTDJYNTZZY3BaQWMw?=
 =?utf-8?Q?KSMYGzu52ZY=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3320.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bUJQQVZQd1dPQ0ZOOVVyY3kwWkF5SFhnM2dZbGNPdmc5c2pURjYxYk5TQ1JN?=
 =?utf-8?B?VWRJWHBVVG5jZ3RIZ2ozVCtpTnExa2VSREI0dUNvYnQ0WnBRbVIxRDd6R2dU?=
 =?utf-8?B?eDVvNDQrNWtXM2JDanFwVlJUWUd4T3czMmllSkV1UDJIRGs3a2xVZm45UzFw?=
 =?utf-8?B?c1B4Z2FTN0VZS28vaGlWWi9XbzdCN2kvUDNIQ3p2QUpWWlFTaVR4SUNVOFpC?=
 =?utf-8?B?N3hQRGpielpwSnZBUzlHQUpKWngya2hwMGZ3b1ZJRkNJOGdKaHIvWkp4dkdp?=
 =?utf-8?B?UnJ1eXE3bWlQRjRlTEYvNEpTU2FjSzZqUDM4bEUzcVZBNjVPZkdpS0hYcHlG?=
 =?utf-8?B?RmJ3bmRVenEzek53M2RyemVWZzRwd0k1UzVCNjZWcFJ0NitWZUt6b1pqMGF3?=
 =?utf-8?B?VDhaUHIrZHdYT08xUXh4QmVURW1HZk0yRVFtSG5ScldTUVJJcThuRitGdVdN?=
 =?utf-8?B?MU1JUm1EWVJQT1RYaWJXd0lsZEJJVVhxclAvTjFQaFhRMXlqWkhPWFFNd3VH?=
 =?utf-8?B?YktxVC9QZEtiMldXa1lycFAySEkvTHZ1VlBYbk9hRzk3R3Z1eG9zRmY2TnNm?=
 =?utf-8?B?dVgzUDlZc1pxSVFqQ1VobS9SdDYrWDlaWHF4MWRseVZoclRKOUhCSHlxclNo?=
 =?utf-8?B?OEhJYVVYTndIL3ZINGJRUklsckd3dndqUFhlU09STXFEblFUUkJFZDgyd2hs?=
 =?utf-8?B?UTFHazRSSmtQaGVoZDBUbklmNmdGbHlibjBGT2ZKZ0NHQkFwMUhnWE5LWWF3?=
 =?utf-8?B?NkVaTkNIVjh5K0FsSnpGWSs3UHI0RGxBS2pLb1ZZZnBoMW1HL29QSUVvWGJt?=
 =?utf-8?B?NUo0d1l4YjdRUGQrUW9ZVDc4THJIRktzWVdBaUs5cFFSaXF6Z2g5bUhqcjRF?=
 =?utf-8?B?a29KVGtDR0dWZzU0UDFZSUw5Y1ptNTBLMk1KaEFJVFkwVnN2bkE0QXAzM2l3?=
 =?utf-8?B?OGVDV0F4dXAra3AySGxNL3pvU1RWSDM1QnU2UnY4T0NyNTBkL05nV2xqYmgx?=
 =?utf-8?B?OTVUUEFzTWZTY2ZQUnlEdmJxdHJINm1DUktnRzdMZkpqZG1QSmhYdk5BMFEv?=
 =?utf-8?B?Y1ZPblV1THpqU0UrTDFodmRqb2RmbEhabDZnUG1NS0xIUW5COGZzcW5HMjlG?=
 =?utf-8?B?alc3YmpVem5NaXA3cHVKM0NVdlQ2b2ROcjdITENiWFZGRlgrMndyTUN3bElp?=
 =?utf-8?B?NW1wVWhSN0x6WGc5L1JJa2JyYnFqdHRNMHlER0dIbEFLcDB1eFFXY3FHc3hZ?=
 =?utf-8?B?SVNVWGNJNTZHY0xUdHJrNWlhOE9YRk9UTVRGcWIxK0MwcjlrWFo4WTFuajNZ?=
 =?utf-8?B?eTlWdlNReksyMzJjYXVrNHVGa28yckRlWTFhOTZNTGlwaXc0c2JlMm5mSkx6?=
 =?utf-8?B?ZDI4VW53NDFMVVp3VVp0WlJkcklRbGtzK2xEeHRKVTV3UTdkSmhMSnVramVl?=
 =?utf-8?B?ZFlMSHNPaGJYME04S0VaNnc3amlCWnV6ZXZudHMxYVlvUWN1UnNSVTVoK2Zn?=
 =?utf-8?B?SVQrLzlPSEFXaTBteGZSTzh2OGUxSzd5TmlndjNZdnhnVGNQaDd2U0t3ZlV0?=
 =?utf-8?B?SEYvbk1NUFpNODlBMUp6dlBOVnhyZVJ1Y3JVSEFtelp5YjZabktFbXBSRU16?=
 =?utf-8?B?TmxiLzVuZ1VpeTdWQldGejFqeEpSdk8vY0h1bzYyejBuZTlDRU1KQ3VFZ3Zs?=
 =?utf-8?B?MXI5UGw5MFRIOVArQm05YWVlZXhmdnJWTVNETHg1bitueUdyZkVGdGdsL0Fr?=
 =?utf-8?B?TnVRSHJybkFpS0Q3OE4zdnFPRFk2SUwza1VLYWNRZzNsMndjc2lJZjJCMzZS?=
 =?utf-8?B?Wk9SWTEyM3VaYlQxbkc1T28wK3Z1ZzlyK2tFaVIwUEZKNW4vSGhpd2xvZU84?=
 =?utf-8?B?dFRYNUdGMVYvZ3lmS2dmVnZDaVNWa2UyUXpzSVNZc1VMZURnTkYveXEwQ1Qz?=
 =?utf-8?B?Mmx1bThqamdMSTZNRjdocFhSdmRvYjE4ZVZFelJwV3hTWWF0RmRSL1R3c1ZM?=
 =?utf-8?B?Y1I5ZnZJTmlWQmgwNGlpTzJ2TDZNQ0hQU2ZXdXNnNm5TY09jSHhIM0ovT3Rw?=
 =?utf-8?B?NEl6OFIzTDg1eDhzZkJsU1hTcnoxN3hkbWlQRTFRVTJQZTJ0dE4vTVFUYVd5?=
 =?utf-8?Q?Z/FKmgD0Otfx4tKjz7V4lO7h/?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d2fbe32f-7021-4426-e743-08dd8db0eb6c
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3320.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 May 2025 21:48:36.1435
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 98RCxDp8tvHeVMg7rMztYMmSK9tx0YfjUSkUR4nQ2A3t1kn0rEtHntRDZEJPGUiGIRQ/Q6uoU5EB0T8ZxMU8lQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPFD3EB37DFC
X-OriginatorOrg: intel.com

On 5/7/2025 2:14 AM, Peter Zijlstra wrote:
> On Tue, May 06, 2025 at 06:21:41PM -0700, Sohil Mehta wrote:
>>
>> diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c
>> index a1d672dcb6f0..183e3e717326 100644
>> --- a/arch/x86/kernel/nmi.c
>> +++ b/arch/x86/kernel/nmi.c
> 
>>  static int nmi_handle(unsigned int type, struct pt_regs *regs)
>>  {
>>  	struct nmi_desc *desc = nmi_to_desc(type);
>> +	unsigned long source_bitmap = 0;
> 
> 	unsigned long source = ~0UL;
> 

Thanks! This makes the logic even simpler by getting rid of
match_nmi_source(). A minor change described further down.

Also, do you prefer "source" over "source_bitmap"? I had it as such to
avoid confusion between source_vector and source_bitmap.

>>  	nmi_handler_t ehandler;
>>  	struct nmiaction *a;
>>  	int handled=0;
>> @@ -148,16 +164,40 @@ static int nmi_handle(unsigned int type, struct pt_regs *regs)
>>  
>>  	rcu_read_lock();
>>  
>> +	/*
>> +	 * Activate NMI source-based filtering only for Local NMIs.
>> +	 *
>> +	 * Platform NMI types (such as SERR and IOCHK) have only one
>> +	 * handler registered per type, so there is no need to
>> +	 * disambiguate between multiple handlers.
>> +	 *
>> +	 * Also, if a platform source ends up setting bit 2 in the
>> +	 * source bitmap, the local NMI handlers would be skipped since
>> +	 * none of them use this reserved vector.
>> +	 *
>> +	 * For Unknown NMIs, avoid using the source bitmap to ensure all
>> +	 * potential handlers have a chance to claim responsibility.
>> +	 */
>> +	if (cpu_feature_enabled(X86_FEATURE_NMI_SOURCE) && type == NMI_LOCAL)
>> +		source_bitmap = fred_event_data(regs);
> 
> 	if (cpu_feature_enabled(X86_FEATURE_NMI_SOURCE) && type == NMI_LOCAL) {
> 		source = fred_event_data(regs);
> 		if (source & BIT(0))
> 			source = ~0UL;
> 	}
> 

Looks good, except when fred_event_data() returns 0. I don't expect it
to happen in practice. But, maybe with new hardware and eventually
different hypervisors being involved, it is a possibility.

We can either call it a bug that an NMI happened without source
information. Or be extra nice and do this:

if (cpu_feature_enabled(X86_FEATURE_NMI_SOURCE) && type == NMI_LOCAL) {
	source = fred_event_data(regs);
	if (!source || (source & BIT(0)))
		source = ~0UL;
}

>>  	/*
>>  	 * NMIs are edge-triggered, which means if you have enough
>>  	 * of them concurrently, you can lose some because only one
>>  	 * can be latched at any given time.  Walk the whole list
>>  	 * to handle those situations.
>> +	 *
>> +	 * However, NMI-source reporting does not have this limitation.
>> +	 * When NMI-source information is available, only run the
>> +	 * handlers that match the reported vectors.
>>  	 */
>>  	list_for_each_entry_rcu(a, &desc->head, list) {
>>  		int thishandled;
>>  		u64 delta;
>>  
>> +		if (source_bitmap && !match_nmi_source(source_bitmap, a))
>> +			continue;
> 
> 		if (!(souce & BIT(a->source_vector)))
> 			continue;
> 
>>  		delta = sched_clock();
>>  		thishandled = a->handler(type, regs);
>>  		handled += thishandled;


