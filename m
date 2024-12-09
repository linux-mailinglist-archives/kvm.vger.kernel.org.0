Return-Path: <kvm+bounces-33302-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3EA229E94AD
	for <lists+kvm@lfdr.de>; Mon,  9 Dec 2024 13:45:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7D79F1641D3
	for <lists+kvm@lfdr.de>; Mon,  9 Dec 2024 12:45:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03C14228C96;
	Mon,  9 Dec 2024 12:45:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HnF3Nc2p"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ABFE218592;
	Mon,  9 Dec 2024 12:45:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733748323; cv=fail; b=gFi+MJ8XyC9fxaPgE2n3RLxyJ3InZ/e+7kCHC5iwHasTfLg7NvFbnHydNrg+dn1pSGqUick/A18DjgnOESGUm78HdbJ+pHq5Dap6robZluKPVnnf1xh88AI4zm4430uydzkWvqO8G8oL/CYXMn592abFA0qSNw7hlObc7Zek/Vk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733748323; c=relaxed/simple;
	bh=aWcr/Zb+JsSHLTcTVNw1zen60VtD8YFrXCstoQSc3Ws=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=EdSOip7tRW4dHL6YwQIDPMZJ56kAZedfowPmj3FiPQGy+DCy1rx/B+sDqAcnIRPJz9u44eJqMfHsuuX6XMiJHfdt+742L3TrlUXhP7O5OVZMIA32uJrPAG2StHcyie8v/39Ql8dGDD+4QENRSMPoMI55Lle45rhFRHEIUbU7Iq4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HnF3Nc2p; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733748321; x=1765284321;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=aWcr/Zb+JsSHLTcTVNw1zen60VtD8YFrXCstoQSc3Ws=;
  b=HnF3Nc2p/xwnAtYQlxgpp7UnbU6RmRfgG9LqYIoPhxwH9z3XJcYgcaFi
   eEtUXvmE+BTIjxlvGhvfzFKdDBH1S6YsHZ13nyJUVIin/K/G//Uyp2JUi
   UONw43XZxcbeEI7gDamBvzonOCPKOPCh0gr3Ol2weTlk4iuU7LVvBBut5
   onGHFFXeeAvX2J9NPnjrJc6zawBCpsb0IyqAeHPwkafpqsaYlc/CesP8K
   kF8L3zVHSUVox3Pybxrnit2x93xxjCI7MfaZ9eyTFBU6mh3rzWh3FvLqf
   35Mj+7Eq3jqjcsopdoRp1YkL2hlmABjnxrOVDCAB9kMzwZ+M59OiVE3KY
   w==;
X-CSE-ConnectionGUID: oUQ2x051QnSmJNVn+asXCg==
X-CSE-MsgGUID: +fO1egM1RPiB7TDNsk2Qqg==
X-IronPort-AV: E=McAfee;i="6700,10204,11281"; a="44509991"
X-IronPort-AV: E=Sophos;i="6.12,219,1728975600"; 
   d="scan'208";a="44509991"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2024 04:45:19 -0800
X-CSE-ConnectionGUID: 7d1JGCZFSJCEPAplIBCVsw==
X-CSE-MsgGUID: 8cZajdqHSc2+GXIBNE0sXw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,219,1728975600"; 
   d="scan'208";a="99518385"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 09 Dec 2024 04:45:20 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 9 Dec 2024 04:45:18 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 9 Dec 2024 04:45:18 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.174)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 9 Dec 2024 04:45:18 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OeaMAA4c+BkJrxFEHN5aEijiRUKqIBW45W3v1XtqaoNOOq9uB7AWuEiAauzoHjx0kJtSbA/F4EXiYqg0W30trKJRr9bPCIIfrqGFzOf8q2gXFIXqkqA/hgL6kG4LEzGOtkdFhNZuVpqbbyPc1fMXMXRNWlItQMFY3YjyOUQoyFc1wGKZE8KMq76zeAcrCfHfUHurs+qjJ2/sG1jaYJIRBOL2ONqK3viDGhHkPKKIwDQH3khBTp/IFGWwSWRjIHHOOS98eBqWgq3g58qqxKAbOZ2UE1l9PpDGMPOuniTM5OsKavS+odhtcb84W1BOcoq011nf+UcfOVWzsBaNutxU9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P7iQeEdDSdIEPWwhEwEWf+gc7WHvh7WFlqNqBCmY1yc=;
 b=IGf23olHsYQ1n8R3NABU0SEWcmeGycSyyPb3tnduyMBbPWMNDeybuaTuZVUfXzAmAlhD8FIqFsjavc63UDqbOcVA1rMGHqHWCjSR3kMUNfawr6ZdaXVG5R6ZuInhfFziBNviJjzaR+XeOSjQBKIoITZoUFqBtSaKzFwLS1BKjAV5202fN70RB7Sy+F9F1Vuy4z5rkDpul1kMDgeXzl3+I82mGkiDpLhSN6hJcdXy7Ddye4tQ9MQX3o4bAbdt+xSEGrK54t/PGueD64Ls+eLnTKYTfmk+Y5qucsId1qRBa2KUdyicltR5up2kjOsniJDuUrzz+7vN4nl7BlJBRtCq8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by SN7PR11MB8027.namprd11.prod.outlook.com (2603:10b6:806:2de::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8230.10; Mon, 9 Dec
 2024 12:45:16 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%2]) with mapi id 15.20.8230.016; Mon, 9 Dec 2024
 12:45:15 +0000
Date: Mon, 9 Dec 2024 20:45:04 +0800
From: Chao Gao <chao.gao@intel.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
CC: <pbonzini@redhat.com>, <seanjc@google.com>, <kvm@vger.kernel.org>,
	<rick.p.edgecombe@intel.com>, <kai.huang@intel.com>,
	<adrian.hunter@intel.com>, <reinette.chatre@intel.com>,
	<xiaoyao.li@intel.com>, <tony.lindgren@linux.intel.com>,
	<isaku.yamahata@intel.com>, <yan.y.zhao@intel.com>, <michael.roth@amd.com>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/7] KVM: TDX: Handle TDG.VP.VMCALL<MapGPA>
Message-ID: <Z1bmUCEdoZ87wIMn@intel.com>
References: <20241201035358.2193078-1-binbin.wu@linux.intel.com>
 <20241201035358.2193078-5-binbin.wu@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20241201035358.2193078-5-binbin.wu@linux.intel.com>
X-ClientProxiedBy: SG2PR04CA0166.apcprd04.prod.outlook.com (2603:1096:4::28)
 To CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|SN7PR11MB8027:EE_
X-MS-Office365-Filtering-Correlation-Id: c623c725-46b2-4964-0411-08dd184f544c
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?I4AakZlnjVYxIfhFdSJDO0HsvRhVMxezB7OwyPI0Bhkx2cMgq+mOF2t45NV1?=
 =?us-ascii?Q?dCPWUUq/8t8wnlIMpexJ4jfSu3Umz7vWm9gnNCbwBzQ4SiAmUDI6B+1gKDV1?=
 =?us-ascii?Q?Q8kUwuO8kjEPhpqebVT6HoXQvsfRFTVmbDpx9yJ0RGnrYY0fYjsWxJZdNfVG?=
 =?us-ascii?Q?MG4L+26bC5Km01wsrnl/oUuSFatghyv4FwAwUPpX3aTij/CSYoDM+LPlFsWg?=
 =?us-ascii?Q?cmH3YuuFPnBD0HQ0us3xESjsphxggQV2oybf+FROOyEqjEOJYqlaU1niTZQO?=
 =?us-ascii?Q?RK3xtJV+4VnEkddsiFTdI3AclIKKkkkSodX4Z4PaTKmSIqLy7BAGoBlCdHbO?=
 =?us-ascii?Q?n5MEZvbLHwDeMz3NyqnxWaBrtXl2HQZ4qcOL2DAauU7mj5/CWCb1t4Jt7Tc9?=
 =?us-ascii?Q?+9zAM+AMqxAbkUdp0SDq1uRPqWtduYQA3oCJqBpRSjTVZdHQ3aoaes+aEUf/?=
 =?us-ascii?Q?S+2mSVi262qWpJYQlYX4XeTBPUP9rol48g8ZRhdzJmsbMNRRi51TYwhHuEM9?=
 =?us-ascii?Q?xDpSio8Q5m7TooINEebLcJ7FMt9QednwvxyIDU95yijsNi+mRvT+UB7tTHN8?=
 =?us-ascii?Q?JzsS3gmpZV2ylsOyZWGi60XEFqAQ29f9SU2F4lGlWXPnUuIvRw5EqtA30UbS?=
 =?us-ascii?Q?mBaZRWqep+h+hhEURrsvwUX+OymE1LmNCIHyjXWX2Sd1MMYilCLBLEN6T8fc?=
 =?us-ascii?Q?zzWxXbAc6/LaSyLuXnJV5ltN3lkZkKgBnAyjSQPWFuqaYc77/ErIe9bKxE8n?=
 =?us-ascii?Q?IBGpN8nNdIVm0roe9lD+oA063Y77bOB3sidIt98N+LAVjSYJg6LpVumQmVbM?=
 =?us-ascii?Q?nDf+8xiX31+N7XEyZVFqReEw6cco6dWuX7TU0FMdeiVDMYyR+SUI0wILsnSd?=
 =?us-ascii?Q?iz/SJCZ9KcC/hb43kI+bO8Cw9iNZ0DpAN31UtvtXX9ZQepvCRu/25kgV2UBm?=
 =?us-ascii?Q?XF4DpZHAkqWfLfRRdnHs+tjY8ok2gAuWRxCA97IUKlUlG0wbpqJs+XQxHT4D?=
 =?us-ascii?Q?mnKeNT0zgzuWc/UeH395xaO+kBGfKYxodq/4PrO5Bkg78kMDZdGQbnP8Xphp?=
 =?us-ascii?Q?pRBKhQb2AjimmonPOR5SC7lH8f1SFsbVvYwXtzR8eMC3fjBST0ZQM2k6BIL2?=
 =?us-ascii?Q?SjyI+li1LxZl2Izbzq+dGJxOouVP90GSPVbYzEpMECMlGXzfC3nHqDkMbNnM?=
 =?us-ascii?Q?mt5OJa1k4LXMQ9CW63MeZ7EHvDGUFzxgBbhiqoIEzIACupYry/JIfrRWgiO8?=
 =?us-ascii?Q?FxVzoG9Zz3phZJR3i0D7UFsMHhQu9YVn93iI1gI8SAb7TCI1q81mbwaNjyLA?=
 =?us-ascii?Q?RKh44aMQfLEWG4EIp32dJaz5vTVX1B3ldAhWlVDziwbBlw=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qSKgaebLSfo3seK0QfFYeRY9kv6lqkLnvMiPRwp1hq2WLPfsVayzJlhvL/DT?=
 =?us-ascii?Q?zI/jsPsgA4T4no2vNvsW5MhuYr5PnnFL31E3SRuUJ7JajUCdzRsuQ4DqlI6L?=
 =?us-ascii?Q?Pwu5skhia9jZekjtZ53Eb56kwDC+BKaNhV+rZV188MQziBCI9312PpJUpq3f?=
 =?us-ascii?Q?l1Xiac/Flmx6vETeusRWrYjYVJSP/EuFzoXyH6IP7mgedBwEpYY6b/Ka4Rms?=
 =?us-ascii?Q?xYpXCaSPYasYgHVO7+pJJ+beVF+khOSaGALm6PUeSLndX66t35UZSVZkTFjD?=
 =?us-ascii?Q?noAtgE97ZM58FZXbGs7VP1VohZ9erILoZQl/hP7YB4QPLFIk1//+bP9oCLLy?=
 =?us-ascii?Q?TYfQJG2dD4uhe+uoU5lYrWJOk4+/ij2NFG4vo+vdbsCQgIVAiGtY0v//1UYM?=
 =?us-ascii?Q?QaM5mUURTeYyFQhJ/+Fw7iSh2LdiG6Y+va8HQwInKJkBPEYhU8Gpk9J+cob0?=
 =?us-ascii?Q?s8+XGxrVjAzZUQPFFrhUbD2k4/x0fRCh1Rl51YOWHYrRA2eXg8tIlN8YRSG1?=
 =?us-ascii?Q?k5D5JuBD9tuZnwVyO1mbpibEna0NnUk1lJoyL3BWNqCQD0mBs2ES1fMnLVrh?=
 =?us-ascii?Q?BNZUWyHC6F+tfxflRz2iiumanZk7IrWgGdRV55XJv7Iu9tNM+5KbsMUdp8Vx?=
 =?us-ascii?Q?sqNXzMQveRpuMXlcS8DHCYZjRxu+s6M0fs2+Yq4ordNv2BJOipM0vPB9OvDw?=
 =?us-ascii?Q?SAXPMbID1Twl2TSgujMN8a1upqGbkJhGi5R0qKz8293N0aNmQIuolQtIlGJY?=
 =?us-ascii?Q?7xBcWFrdmdxB9kwWYgy3EjzfyaKyrir+gy1xWTphpgxL85HJaCRaFTGYvc71?=
 =?us-ascii?Q?63JOUFMUEKwLyq5dqWi3ge32LGV+WWh5yu0vAIYBQKBzqdNzu1OPVDxh41mw?=
 =?us-ascii?Q?CoF5sCsF17fL+Gw8hGhzAEAj8tOI9/u7NUy6RnZYkvKLgBWAnU/+gEa5ow+9?=
 =?us-ascii?Q?bxFzWO/RA/wJMxb0LmAXkkL7xP3b1g3L/6ZaMQ3B2PuqBqBLmrNuK8zwKozb?=
 =?us-ascii?Q?Axq1fhVTMP4yoLfLJLfOTWLoMprlaqODJpL3bf8Kvg7CIncveHzspSsMGeNC?=
 =?us-ascii?Q?ocSaBY+JlBo6Ex61ZLsLVfFpp/vvDJLQHNK3U5iI7N+QxrKsd8OxnY/zuYHm?=
 =?us-ascii?Q?jFjMwrv6pFicADlcTwWk5oTDL7jvSxyh1wHb8CsaRFru8LcW90JjFVVoE8wg?=
 =?us-ascii?Q?dOBxeVmJCv2/Mf+UwlNIljLkSdr5MVVmhmmkUtDLI620aQIijEO61TSLltl5?=
 =?us-ascii?Q?Ku45RtxIagL1vH9hVzjr6EoLnoWPQO31//4pxc4lP3m1gViMvYbBSIfVIkkA?=
 =?us-ascii?Q?GWYkMUqd/Ec4IibejJelZNi/1+Q4OvQ8J1ba06xdHWY0TqIB+jvkNs3sHcMc?=
 =?us-ascii?Q?pb/bge6LTxwQoJ9YMsd8CES8g/d41HjsZtMnh1Pi1Hm+ShIq3gWu5rAYz+ta?=
 =?us-ascii?Q?0fZH0N+qdOpqmvOLqqTMh2UZqxUSbInF+bCkhpjKHCKwkl1joCwjdZe6IBtb?=
 =?us-ascii?Q?WKY1qfgKlOSFLJFs4CFEroTrYyd7kSHEyqWilM6My++L16ss/rtuRXzyUCpc?=
 =?us-ascii?Q?YlOnHw4XOF6fLL+qN0E7qMPYEES4t0TU3p3+AvgY?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c623c725-46b2-4964-0411-08dd184f544c
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2024 12:45:15.5932
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 20XctPtSbGcR+O0758DsrBwxRxQhA5V6RD2L/PE66vLt6y+5DEyZoxJFIxof1MfMURXEVmT+0twhssG/xv0MBA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB8027
X-OriginatorOrg: intel.com

>+/*
>+ * Split into chunks and check interrupt pending between chunks.  This allows
>+ * for timely injection of interrupts to prevent issues with guest lockup
>+ * detection.

Would it cause any problems if an (intra-host or inter-host) migration happens
between chunks?

My understanding is that KVM would lose track of the progress if
map_gpa_next/end are not migrated. I'm not sure if KVM should expose the
state or prevent migration in the middle. Or, we can let the userspace VMM
cut the range into chunks, making it the userspace VMM's responsibility to
ensure necessary state is migrated.

I am not asking to fix this issue right now. I just want to ensure this issue
can be solved in a clean way when we start to support migration.

>+ */
>+#define TDX_MAP_GPA_MAX_LEN (2 * 1024 * 1024)
>+static void __tdx_map_gpa(struct vcpu_tdx * tdx);
>+
>+static int tdx_complete_vmcall_map_gpa(struct kvm_vcpu *vcpu)
>+{
>+	struct vcpu_tdx * tdx = to_tdx(vcpu);
>+
>+	if(vcpu->run->hypercall.ret) {
>+		tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_INVALID_OPERAND);
>+		kvm_r11_write(vcpu, tdx->map_gpa_next);

s/kvm_r11_write/tdvmcall_set_return_val

please fix other call sites in this patch.

>+		return 1;
>+	}
>+
>+	tdx->map_gpa_next += TDX_MAP_GPA_MAX_LEN;
>+	if (tdx->map_gpa_next >= tdx->map_gpa_end) {
>+		tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_SUCCESS);
>+		return 1;
>+	}
>+
>+	/*
>+	 * Stop processing the remaining part if there is pending interrupt.
>+	 * Skip checking pending virtual interrupt (reflected by
>+	 * TDX_VCPU_STATE_DETAILS_INTR_PENDING bit) to save a seamcall because
>+	 * if guest disabled interrupt, it's OK not returning back to guest
>+	 * due to non-NMI interrupt. Also it's rare to TDVMCALL_MAP_GPA
>+	 * immediately after STI or MOV/POP SS.
>+	 */
>+	if (pi_has_pending_interrupt(vcpu) ||
>+	    kvm_test_request(KVM_REQ_NMI, vcpu) || vcpu->arch.nmi_pending) {
>+		tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_RETRY);
>+		kvm_r11_write(vcpu, tdx->map_gpa_next);
>+		return 1;
>+	}
>+
>+	__tdx_map_gpa(tdx);
>+	/* Forward request to userspace. */
>+	return 0;
>+}
>+
>+static void __tdx_map_gpa(struct vcpu_tdx * tdx)
>+{
>+	u64 gpa = tdx->map_gpa_next;
>+	u64 size = tdx->map_gpa_end - tdx->map_gpa_next;
>+
>+	if(size > TDX_MAP_GPA_MAX_LEN)
>+		size = TDX_MAP_GPA_MAX_LEN;
>+
>+	tdx->vcpu.run->exit_reason       = KVM_EXIT_HYPERCALL;
>+	tdx->vcpu.run->hypercall.nr      = KVM_HC_MAP_GPA_RANGE;
>+	tdx->vcpu.run->hypercall.args[0] = gpa & ~gfn_to_gpa(kvm_gfn_direct_bits(tdx->vcpu.kvm));
>+	tdx->vcpu.run->hypercall.args[1] = size / PAGE_SIZE;
>+	tdx->vcpu.run->hypercall.args[2] = vt_is_tdx_private_gpa(tdx->vcpu.kvm, gpa) ?
>+					   KVM_MAP_GPA_RANGE_ENCRYPTED :
>+					   KVM_MAP_GPA_RANGE_DECRYPTED;
>+	tdx->vcpu.run->hypercall.flags   = KVM_EXIT_HYPERCALL_LONG_MODE;
>+
>+	tdx->vcpu.arch.complete_userspace_io = tdx_complete_vmcall_map_gpa;
>+}
>+
>+static int tdx_map_gpa(struct kvm_vcpu *vcpu)
>+{
>+	struct vcpu_tdx * tdx = to_tdx(vcpu);
>+	u64 gpa = tdvmcall_a0_read(vcpu);
>+	u64 size = tdvmcall_a1_read(vcpu);
>+	u64 ret;
>+
>+	/*
>+	 * Converting TDVMCALL_MAP_GPA to KVM_HC_MAP_GPA_RANGE requires
>+	 * userspace to enable KVM_CAP_EXIT_HYPERCALL with KVM_HC_MAP_GPA_RANGE
>+	 * bit set.  If not, the error code is not defined in GHCI for TDX, use
>+	 * TDVMCALL_STATUS_INVALID_OPERAND for this case.
>+	 */
>+	if (!user_exit_on_hypercall(vcpu->kvm, KVM_HC_MAP_GPA_RANGE)) {
>+		ret = TDVMCALL_STATUS_INVALID_OPERAND;
>+		goto error;
>+	}
>+
>+	if (gpa + size <= gpa || !kvm_vcpu_is_legal_gpa(vcpu, gpa) ||
>+	    !kvm_vcpu_is_legal_gpa(vcpu, gpa + size -1) ||
>+	    (vt_is_tdx_private_gpa(vcpu->kvm, gpa) !=
>+	     vt_is_tdx_private_gpa(vcpu->kvm, gpa + size -1))) {
>+		ret = TDVMCALL_STATUS_INVALID_OPERAND;
>+		goto error;
>+	}
>+
>+	if (!PAGE_ALIGNED(gpa) || !PAGE_ALIGNED(size)) {
>+		ret = TDVMCALL_STATUS_ALIGN_ERROR;
>+		goto error;
>+	}
>+
>+	tdx->map_gpa_end = gpa + size;
>+	tdx->map_gpa_next = gpa;
>+
>+	__tdx_map_gpa(tdx);
>+	/* Forward request to userspace. */
>+	return 0;
>+
>+error:
>+	tdvmcall_set_return_code(vcpu, ret);
>+	kvm_r11_write(vcpu, gpa);
>+	return 1;
>+}
>+
> static int handle_tdvmcall(struct kvm_vcpu *vcpu)
> {
> 	if (tdvmcall_exit_type(vcpu))
> 		return tdx_emulate_vmcall(vcpu);
> 
> 	switch (tdvmcall_leaf(vcpu)) {
>+	case TDVMCALL_MAP_GPA:
>+		return tdx_map_gpa(vcpu);
> 	default:
> 		break;
> 	}
>diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
>index 1abc94b046a0..bfae70887695 100644
>--- a/arch/x86/kvm/vmx/tdx.h
>+++ b/arch/x86/kvm/vmx/tdx.h
>@@ -71,6 +71,9 @@ struct vcpu_tdx {
> 
> 	enum tdx_prepare_switch_state prep_switch_state;
> 	u64 msr_host_kernel_gs_base;
>+
>+	u64 map_gpa_next;
>+	u64 map_gpa_end;
> };
> 
> void tdh_vp_rd_failed(struct vcpu_tdx *tdx, char *uclass, u32 field, u64 err);
>-- 
>2.46.0
>

