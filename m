Return-Path: <kvm+bounces-48336-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B8E6AACCE1F
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 22:22:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 686693A4481
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 20:22:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D342223DEE;
	Tue,  3 Jun 2025 20:22:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="j3YqnNQR"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEEB3C2E0;
	Tue,  3 Jun 2025 20:22:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748982154; cv=fail; b=fIOcB8jwNb5udxPsR0YD19+G0RIome6OcEl3BfSkhr1KZqUHtjqv6f5yAlJbPfJyO30fDlYghSZ2H2P/peuLz0V07bqLG/fr/Rj0dy2eHeJ32Qh97b0738+PvfeCJzMlImxZb3durpG6DXC7pe0xGVNWH4ZuNtjurnSHBYPRhAM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748982154; c=relaxed/simple;
	bh=+Q+8XqWmzN2perMDQSCotAn5N0FZFJmRTLoOn4Y1+d8=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=qFV3OJl+VLEqgtNCB8EgfcqzI1WUBaKPRy2jBDriCGVs1jrG0+lb6UMzfgQtMmjbFkVCfTQN9FhMFWlvl6P9V65YXtrm1hf4zzxamrG934icsL/LVEecBuRhsjFZHdgtcGLVwC4W29s1V6QWod7Mpu+cDpiinbYbdSy/i0p5FaQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=j3YqnNQR; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1748982153; x=1780518153;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=+Q+8XqWmzN2perMDQSCotAn5N0FZFJmRTLoOn4Y1+d8=;
  b=j3YqnNQRAxAQkvq9bxWEx4eef6ln0iikqG9wyPBS9WJmU0rccKA3yGaP
   pSq+ppPAQ/+KnZRyqa/eZQXBN7UbjELZfNWgKKQZbBv8T3SKsLkluWg6o
   vegFmKy96EWjexHjVJO8LnweZHiVe+0y7foq9dNHttBLpcehefAO72mRj
   0rGUgE1kzDBkpTQtPIyCj80DoWEroxzQtl3kpOXeFA0zy5ii/mlteBElc
   vNQLK6PfMEEQyuUsEFwjkM7F2z6pRL5bmKWB8ubSvxeRxwAXL1oDs5Ti4
   iu4KDIuXPy00e9wp93FIkYvTtBqTqJGo85SujjGnP/ZuT0/+Q8h5SNqei
   w==;
X-CSE-ConnectionGUID: AzY0io82RrOjhcQkzuYZ0w==
X-CSE-MsgGUID: cQUqCVblRmi+2ochJjiJCA==
X-IronPort-AV: E=McAfee;i="6700,10204,11453"; a="51039937"
X-IronPort-AV: E=Sophos;i="6.16,207,1744095600"; 
   d="scan'208";a="51039937"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2025 13:22:32 -0700
X-CSE-ConnectionGUID: VfAln0LrRu2Thmn6nzH/Ig==
X-CSE-MsgGUID: eeLlSyueTA+FdCUyjPF6zg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,207,1744095600"; 
   d="scan'208";a="145938825"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2025 13:22:32 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 3 Jun 2025 13:22:30 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 3 Jun 2025 13:22:30 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (40.107.94.52) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Tue, 3 Jun 2025 13:22:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=x+UbGQ04hj+f8k+tV3rFbRyvsMf4CWTQVsopkhfwMbZIE1/ASNahGIY7skPB3nfanT1KBh1CguwCuoKuG+rxn3ZBUX2/7GOu0HyTRLnAl3OzR9ef155tAVjSow4qaP/6Ocf3FM83+hoUda/LzalfXfF/qR6d5345r5yBR/crf1MbzEGapGcvTZwWpHqUeRlkCeXYuWnnQrFTp0HwOyrxebRI8kHS+IbmqsfgQBSCMWRZLV/+F4QOt1y4na3s/PXrV4ol0QQ3DQgWGlBeekCgifwaHrMKxWjX0fC6k4Zr+louPtNo6UHIHw0EKkaub49x4TBW/V8974V4VG+e2tl3jA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OKai9dYlclEcz8iT/4M2OA8MVqP4pWAgOLaACiy8zKw=;
 b=YDuG+qY0IsQzfMaM6HeBYywUwqqRLhKtdbZzS9diS8ai6lic8amo6rg5sk4DArBWsq6ac40pFi0dAwLWt2hoI9FASTh7RH2RMQo2Ar4zsUDtaWU+u7I0+qWOouQFrMqujUV89tArJOSrm8xWH+JFW104VjJY0gJ71pl4s48nLKBwm6WaAvYs0Dq3k8dXZfVGyk1H4YASqpJvmZe/790WMQGJUIC4bgBfB14SeHFRPJxgKW6JqmnXXzqky8x2Somk3KgdwNblzozGbVeQK5+hZdRTHZwwrBw4nQ+WXErZf/qwIkPaga0jAClg21lvHMLt9/eKcP+pneNy4PEMMG9okg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BYAPR11MB3320.namprd11.prod.outlook.com (2603:10b6:a03:18::25)
 by PH7PR11MB8011.namprd11.prod.outlook.com (2603:10b6:510:24a::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.34; Tue, 3 Jun
 2025 20:22:28 +0000
Received: from BYAPR11MB3320.namprd11.prod.outlook.com
 ([fe80::e8c4:59e3:f1d5:af3b]) by BYAPR11MB3320.namprd11.prod.outlook.com
 ([fe80::e8c4:59e3:f1d5:af3b%4]) with mapi id 15.20.8792.034; Tue, 3 Jun 2025
 20:22:28 +0000
Message-ID: <67683e00-48fa-4aa8-91ff-8726a5374675@intel.com>
Date: Tue, 3 Jun 2025 13:22:26 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 4/9] x86/nmi: Assign and register NMI-source vectors
Content-Language: en-US
To: Dave Hansen <dave.hansen@intel.com>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: Xin Li <xin@zytor.com>, "H . Peter Anvin" <hpa@zytor.com>, Andy Lutomirski
	<luto@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar
	<mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
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
 <e978e1fb-d88e-4789-bd33-367281dfa0ad@intel.com>
From: Sohil Mehta <sohil.mehta@intel.com>
In-Reply-To: <e978e1fb-d88e-4789-bd33-367281dfa0ad@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0169.namprd03.prod.outlook.com
 (2603:10b6:a03:338::24) To BYAPR11MB3320.namprd11.prod.outlook.com
 (2603:10b6:a03:18::25)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR11MB3320:EE_|PH7PR11MB8011:EE_
X-MS-Office365-Filtering-Correlation-Id: a9895e9d-289a-4111-c986-08dda2dc5c12
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?cUVmT2IyN1lpbHJPVVhIdk9QU3p1VnlNZ3BCZGwzWW55VlphM2tJS204YThE?=
 =?utf-8?B?TjFQRkgwQU83UWVQaUZPTjVRTkNJVVplUG5vUmFsN0tmcEpuN2p2S2lCbEhl?=
 =?utf-8?B?ejBXSm42Z0V1YmZHU0Q3SlRuNzI5NXpMSWRQUjFXVmw0ZDNiZXJObGZ1cmJx?=
 =?utf-8?B?eDZhTmtWcGE3WWNMVG9RR0NpOVRsNjgrMjFsQ1ZRVDZYY3MzR3o3ZktrckZN?=
 =?utf-8?B?eG4wU2FNSzQyWE52bTg0eGNhUmRGMlNjN0N6dlZpa2JLcE5XbU15M205RUJt?=
 =?utf-8?B?TTVXNGphV0ZMZVdQNkg3MnRsbXVGRDhHNFZ3RVdFSzVpT2UxV3VnN3pucVp0?=
 =?utf-8?B?U1RZMmNsRng5cThYclZqM0VXM0RnYi84ZVo3Z21nOVN3L3Z2NGN1Ymo5TEJ4?=
 =?utf-8?B?am9hSzU1SEFhQ2lKVE0rekVYZDAvOGJZSmVlQTVEdVRqUUROT3IrZGJqZWRS?=
 =?utf-8?B?RkhkWlRpVW1iTE5pbERVdy84MEMxRnJzZThrZlNXZy9RWGRFRVlPYXJHZlNj?=
 =?utf-8?B?U3NnNnBtU3MzN3RvS2ZSTk9zM0JJYVlPT3VPbGo5Vkt0SjlEbDVVZ3JuVzVi?=
 =?utf-8?B?bFdqSHJjWk1ocVdzbFMwUm9FUkl1aXhMRGJaajh4dEI5cVppalFRaFZxbVk1?=
 =?utf-8?B?TXBVREE5SVd1RFdGRG8vcWdrWVd0WkJJZzhBTitZNEpuUitOb2xpR0VadWFD?=
 =?utf-8?B?Y2d2N3RVaGdMcHNwWVlSQmJNSjlyVU1GSHllOUVrdFdUMWJRZ1ZIbFhla1Ar?=
 =?utf-8?B?dDhPaHVTQ1lVT1ZTVEttbFZZQ0xPYVBPN2d6TG40aG1Kai9XTC9lK0lDaW53?=
 =?utf-8?B?Qk1kdldoaGp1c2xabU9la0FmNUI3QVRXMEtYbmhYa0YyT284WkU4U0JudGYv?=
 =?utf-8?B?MFhzYm1jUmgzcmduaFVSbFV1Sjd2RU5FVE9sOEhERm9CK2lnZmZXQU0vVWpR?=
 =?utf-8?B?a1cxcGlXQ2RtRDNZSk15UlR2QVgxMnQxTTk1aEpwakpYNFQwQWhwVkY1OWNF?=
 =?utf-8?B?VkpJNmRyVXV4Y2piK0szV28wVStweUlqY25MZVNNOUVHdG8rRXJJcFdrSGNI?=
 =?utf-8?B?djY4c21uQVA0Z2JXUEtrV2VrZTFPZE90WWI0UW9aMDRWUkFZU2xQem9LL2Zi?=
 =?utf-8?B?U0RXSWE1RDA0UitGOXZrT3VtZzdQa3FhQkk3R0g1dWdsNnIzTmZvalJNcFFK?=
 =?utf-8?B?NkE5b1MrVk56WGhwT0ZYYzlXV2VzbE16T08xVzZFa2dUemluTFBJcDNGU0RI?=
 =?utf-8?B?MXVFSmV4bUlieGtodUo1NjA3T2tKRnh1ZDh0Y0FsRjJ6SHVJdFZ1eTllUlln?=
 =?utf-8?B?TUxqeWxrYUE1OHlzY3JZZkhaOW5ZQ0x6NTFXVzJwbml4TnNKbUgzeHcwRk1Z?=
 =?utf-8?B?cnZqMG03ck4xbHVHNk1hUzAxZnliSE5aUEtLTlZ6RW9IdStHNXhveGRCVkdR?=
 =?utf-8?B?OWY4YkVSWUs3N1JUY2htZ1JmMEpmNG5OM1F0L2duclJSaGZEdmdGd0JZZEx0?=
 =?utf-8?B?Mzk1djZRUVBLSHJ3VzNlTndUWTI2NWlOM3NyYUxjQ29UdWlRdlRreGQreU01?=
 =?utf-8?B?cDVCL254OUpQRkpqZU5EYWRMK215ZTRrZkVhK3ZoZlBKcHQ5WGozNDBKMHZZ?=
 =?utf-8?B?S0pPeGtXV1c5L1A0MXpGT2hsVHBrQW93UzZYNFh0OEt0VGVEUnpyTGR0TE1Z?=
 =?utf-8?B?eTJORUlRT3VDbnpUU2xmeTBZeDAwRkJFbnd4WGxTdS95UDN0M25CMytRTDRr?=
 =?utf-8?B?VEFuQTduUm9tRCswbWkxenZveFdlRmEvU2pxRTdQbDFrTWRNanNUaGhGUUo4?=
 =?utf-8?B?aEhmMXYreDI5V0puTGRNcHdjRHlUUW1oM09jZFZKMnBQcDdxdWFPQ05IMUky?=
 =?utf-8?B?S3pxTXFZWjVyMndUMVkzaTZiOGxyNjArazZBZEplS05LY1pNMWRCY3NEcFlm?=
 =?utf-8?Q?+h8MvrPJbuE=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3320.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UWhQdjU4UzRZaUhLTGlHRnEvWUdxaENTZnJJVWo4ZHMreGptY0VtTWhDU1hj?=
 =?utf-8?B?ZUd3TzlKSXcyTDgydXROWnVSempIdVBvdlZtRXhkemM0VVFWcjBMaVNwRjFG?=
 =?utf-8?B?akZYOFhUbHIyaHJ4RmUrR3BwK2dNa2d4ZDM3d2FjYWRtSUY2RVJlcWdTYzRv?=
 =?utf-8?B?aEpJR1lUNXRnY1BGYmFrV3BXVCttZE5ITnRQcUVIMVFrOElDV1JOMUdwK1ln?=
 =?utf-8?B?MzBBTW1IdW1oQ0RWUk8vblRvWXUzYzZXMkZFM2FOR05pc2FVU1RDOXBmOCtC?=
 =?utf-8?B?cWlHWWU4N1FDbE9JT0xiZTVLVjY2UDhCc29SN3hndUJJVXVRc1ZKMnM3UUZu?=
 =?utf-8?B?TmFSU2pYMVhHaGlwMUVjMnJlM0wyMVBCVDBrcEY0U1kyNThkWVlkLzRicDdw?=
 =?utf-8?B?VVB0dkRjVkFMRjZWcVBZMklnV29zQ0pQWWNNWmhZZ1pXQWtBSTJCRzVIaVh4?=
 =?utf-8?B?M3dhK085VHcwazU3RC8zM0RIdjV3NTM3OTVYeU9jeHptYzZyYU5ITDVJREtr?=
 =?utf-8?B?eVJhNDFQQlMyVWJqeitKd2QxVVFEQWxaZXMrdEk1ZmZLZGtyV3VKaUFoSDU5?=
 =?utf-8?B?UmxmU3NSSHZ2SlZIakFYVkZRMFRONlY2U0lZR3lNd2dHWFg0NHh6a2FsdWNV?=
 =?utf-8?B?SmpOc1FDYTM2OUZtd0dyMkwrTXljUzBTYlNqSytyZHN5aFZDV1c1aWJpTExI?=
 =?utf-8?B?NDdGZUV6b3hIRnVCUzFvSDUxUy9BeU5ReUJ5SjVBMXRyUVJYcTRQcGY1dHJ4?=
 =?utf-8?B?Vk0vbG1mY1Yxd0Y0UU03N0VsVi9BNlFRUlBOYWZuRGdaeVdRTVlzS3JkVTYz?=
 =?utf-8?B?UVBSNlFjb3lRdUtTOE40c0tKb2NBUXN0bS9UT01IaGFwOFpvQ2RFVEQvMVBO?=
 =?utf-8?B?ZFVjV3FPb3pvcUpHL1UzZDVZRVNQenV5RDZ0MHAxWVhpTUV6cmJHczhISzRv?=
 =?utf-8?B?VW5tNnJQa0o1bTZKWXZJbXFGZ05pWmZDQnNvOHRWb0Q4NmVWTkRqd2xLRjhm?=
 =?utf-8?B?Q0djSHN1bjhibzlYSDNGcjROMVhLeVJCUmh3ZnpWK1krc0lzM0htSEMwamIr?=
 =?utf-8?B?Z013RGo3bkIzVUZSTThkODVSMTQrbk5JQkVrS1dkbFdQRFNJNDMzajVTMkJY?=
 =?utf-8?B?QVFTUUpNdk4wcWVyRmZaL1NveW9TK1FxZnVZZzRMYzZVUUdwc2ZSdFQvaUpQ?=
 =?utf-8?B?UTkveWFESXo0cGNkdVZLQjJUODNkM0EvV2RXMVJVNXpKK05NRUY1emZ2T2JC?=
 =?utf-8?B?VzVTR01aUTRMaTVvZ0Yra2tBd2t0QU1uT245cHJjbFZxbGpBWkFIQ2pYMGtB?=
 =?utf-8?B?Rm5ta2p6aUl1UHc2ZmNWQ1JvWjByenNjOVl2Umo3d3g3d2RQRXp0aDJvOEJJ?=
 =?utf-8?B?Q0dMdjZwTmZQYlM4ODUwVHUvQ1BFTFBJZUIyY3YwTWpOKzd5NE5SeXE0dGRp?=
 =?utf-8?B?SENaMXJzME8xSWUxeGt3OTZndDUrUnBSSHRUekN5dUhHRHhEQ1BOY09VdXhj?=
 =?utf-8?B?VWwvVGpIMTd2WHh5Q0dpVWI5elYzbVZHY0p3cW5CVjlmZG9SUHpMcEtLekwx?=
 =?utf-8?B?aDh4bTFYQ1hJUTJOSUtpTFZGazdGTDhwZkk1NXBuNERIZ1lmb0lmZTZwSUp0?=
 =?utf-8?B?cWt3SldTNUV2NFZJSWhPSGFmaFRmNmEvUC9nRGo5Mi9ocSszRVMwTW1PR2Vv?=
 =?utf-8?B?dFVNY2lKQldWVEFXYlgvZktEYXJqZzhKUktqL1NvL05DK3lGNUlXZHRxR01l?=
 =?utf-8?B?Wnh2Tlk3bThIYk8weXUwN0tNcWVKdHduN2hKUFpoaTlJRk92VnVLNjlnUkZV?=
 =?utf-8?B?ZUhKRllNeitERU81bFBucnZFSFdQdVJkdmxQU1pnaDV1ZjE3RWVvMEl0dVov?=
 =?utf-8?B?VnRTZ0grU3RUdTQzTjN3OGI5MWdUM1hiMlpydVFyRFZKOCtSeTdGS2NZMU5a?=
 =?utf-8?B?YUpWNmUxT25aM0J5UHRJdmdNL2JxN3Q4L0NjaW1qNlpvQmtBTVlQMmxQN0k0?=
 =?utf-8?B?SlE5RVk4V1dObGk5cm1CVmxyRzBVQkhaZytEeDRpU0FFM1VUWTdnV2FMbjFS?=
 =?utf-8?B?QjNaWXJsb2FUd2dFTlMrL29hTnJ4eHdsVXp4UDkrOU83WDAxUjVSdHNkeGZa?=
 =?utf-8?Q?B2vXysiSTGbS0Ujr+BjM8x1UB?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a9895e9d-289a-4111-c986-08dda2dc5c12
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3320.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2025 20:22:28.2163
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C1HcvQubsFR+mdj9ORojvRRwmUDhVe4PWYt4RdZG39f/BBV2qiJdvdnzkM1EV4sZJo//DzexfeRI2yZZ9Eppig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB8011
X-OriginatorOrg: intel.com

On 6/3/2025 10:23 AM, Dave Hansen wrote:
> On 5/13/25 13:37, Sohil Mehta wrote:
> ...
>> + * Vector 2 is reserved for external NMIs related to the Local APIC -
>> + * LINT1. Some third-party chipsets may send NMI messages with a
>> + * hardcoded vector of 2, which would result in bit 2 being set in the
>> + * NMI-source bitmap.
> 
> This doesn't actually say what problem this causes. Is this better?
> 
> 	Third-party chipsets send NMI messages with a fixed vector of 2.
> 	Using vector 2 for some other purpose would cause confusion
> 	between those Local APIC messages and the other purpose. Avoid
> 	using it.
> 

Yes, that is better. Though, the behavior of these external NMIs isn't
expected to consistent across all third-parties.

Third-party chipsets may send NMI messages with a fixed vector of 2.
Using vector 2 for some other purpose would cause confusion between
those external NMI messages and the other purpose. Avoid using it.


>> + * The vectors are in no particular priority order. Add new vector
>> + * assignments sequentially in the list below.
>> + */
>> +#define NMIS_VECTOR_NONE	0	/* Reserved - Set for all unidentified sources */
>> +#define NMIS_VECTOR_TEST	1	/* NMI selftest */
>> +#define NMIS_VECTOR_EXTERNAL	2	/* Reserved - Match External NMI vector 2 */
>> +#define NMIS_VECTOR_SMP_STOP	3	/* Panic stop CPU */
>> +#define NMIS_VECTOR_BT		4	/* CPU backtrace */
>> +#define NMIS_VECTOR_KGDB	5	/* Kernel debugger */
>> +#define NMIS_VECTOR_MCE		6	/* MCE injection */
>> +#define NMIS_VECTOR_PMI		7	/* PerfMon counters */
>> +
>> +#define NMIS_VECTORS_MAX	16	/* Maximum number of NMI-source vectors */
> 
> Would an enum fit here?
> 

I had experimented using an enum, but I avoided that approach because
the source bitmap would also be visible to users/developers. For
example, patch 9 includes it in the "unknown NMI" print. I am planning
to add it to trace_nmi_handler() as well.

With an enum, it's harder to figure out the exact sources when let's say
the source bitmap is printed as 0x0090.

enum nmi_source_vector {
    NMIS_VECTOR_NONE,
    NMIS_VECTOR_TEST,
    NMIS_VECTOR_EXTERNAL,
    NMIS_VECTOR_SMP_STOP,
    NMIS_VECTOR_BT,
    NMIS_VECTOR_KGDB,
    NMIS_VECTOR_MCE,
    NMIS_VECTOR_PMI,
    ...,
    NMIS_VECTOR_COUNT
};

Users would have to convert the enum back to numbers to make sense of
the bitmap. It isn't bad but feels inconvenient.

> You could also add a:
> 
> 	NMIS_VECTOR_COUNT
> 
> as the last entry and then just:
> 
> 	BUILD_BUG_ON(NMIS_VECTOR_COUNT >= 16);
> 
> somewhere.
> 
> I guess it's a little annoying that you need NMIS_VECTOR_EXTERNAL to
> have a fixed value of 2, but I do like way the enum makes the type explicit.
> 

Yeah, fixing the external vector makes the enum annoying to use.

We could probably define an enum in this unusual way to keep the table
consistent and help users quickly refer bit offsets. But I am not sure
if this is any better than the current macros.

enum nmi_source_vector {
    NMIS_VECTOR_NONE        = 0,
    NMIS_VECTOR_TEST        = 1,
    NMIS_VECTOR_EXTERNAL    = 2,
    NMIS_VECTOR_SMP_STOP    = 3,
    NMIS_VECTOR_BT          = 4,
    NMIS_VECTOR_KGDB        = 5,
    NMIS_VECTOR_MCE         = 6,
    NMIS_VECTOR_PMI         = 7
};

Any suggestions?

> 
>>  static int __init register_nmi_cpu_backtrace_handler(void)
>>  {
>> -	register_nmi_handler(NMI_LOCAL, nmi_cpu_backtrace_handler, 0, "arch_bt", 0);
>> +	register_nmi_handler(NMI_LOCAL, nmi_cpu_backtrace_handler, 0, "arch_bt", NMIS_VECTOR_BT);
>>  	return 0;
>>  }
> 
> ... Oh you replaced _most_ of the random 0's in this patch. That helps
> for sure.

There are still quite a few places left with an extra 0 at the end.
Explicitly using NMIS_VECTOR_NONE for them should be useful.


> ret = register_nmi_handler(NMI_LOCAL, perf_ibs_nmi_handler, 0, "perf_ibs", 0);
> register_nmi_handler(NMI_UNKNOWN, hv_nmi_unknown, NMI_FLAG_FIRST, "hv_nmi_unknown", 0);
> retval = register_nmi_handler(NMI_UNKNOWN, kgdb_nmi_handler, 0, "kgdb", 0);
> if (register_nmi_handler(NMI_UNKNOWN, uv_handle_nmi, 0, "uv", 0))
> if (register_nmi_handler(NMI_LOCAL, uv_handle_nmi_ping, 0, "uvping", 0))
> register_nmi_handler(NMI_LOCAL, ghes_notify_nmi, 0, "ghes", 0);
> rv = register_nmi_handler(NMI_UNKNOWN, ipmi_nmi, 0, "ipmi", 0);
> rc = register_nmi_handler(NMI_SERR, ecclog_nmi_handler, 0, IGEN6_NMI_NAME, 0);
> retval = register_nmi_handler(NMI_UNKNOWN, hpwdt_pretimeout, 0, "hpwdt", 0);
> retval = register_nmi_handler(NMI_SERR, hpwdt_pretimeout, 0, "hpwdt", 0);
> retval = register_nmi_handler(NMI_IO_CHECK, hpwdt_pretimeout, 0, "hpwdt", 0);






