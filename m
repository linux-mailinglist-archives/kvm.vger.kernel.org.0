Return-Path: <kvm+bounces-43682-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 22912A93F37
	for <lists+kvm@lfdr.de>; Fri, 18 Apr 2025 22:52:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 60E307B1A78
	for <lists+kvm@lfdr.de>; Fri, 18 Apr 2025 20:51:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E34B924888E;
	Fri, 18 Apr 2025 20:51:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WeSGHx+B"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F9E115442A;
	Fri, 18 Apr 2025 20:51:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745009498; cv=fail; b=rXMlhjFEiKeqyrs4XQnF26nH2K+NUVHlLAGVTUfXk/Eh6ng5eDU1SrwqoHolEIS5MaF4oaNnvPjba1Qyh+ntnbjfxJgnTJpihV4ViT6X2KioEBvusgIYIg14oscQyt+73do6wWat4uhi+ug3vlhZYDhpbzoZE+pMcggZjoyMjVw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745009498; c=relaxed/simple;
	bh=5O18l7xc5h7VvncTMkD3fvDd4M51uOz8hid9D6BPGWM=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=PNbfXPyzvBnP9NBN2B7MUM4EzMvQoVj/WxVyyOw4IQcrEmkBEq5hiZizON5YCNhfbDQ/CNwwDt7SblAgkNj+CcrvvbZF7IUdQoCiyZcMh62zRkcgfJggMwKQX5JJ6EBS1pmuxe6SXkcOGbU0OnF4YqRIht5bO0LN0grsuSsFzl0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WeSGHx+B; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745009496; x=1776545496;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=5O18l7xc5h7VvncTMkD3fvDd4M51uOz8hid9D6BPGWM=;
  b=WeSGHx+B22lH57aZC7wWJQhc1mdzDDuFIR0pNIfm23fQXYc3PYTM/MTI
   d85QieBWkL9xVxbOhRbnBk+wTNdMsMVXo6MucFjJmEMkpLmfYJE+PFNRa
   o2sYKWCOMzSnZE/IOCFTrpefaBevEJbpWCrJYnYWvvZgEezKmTZrJH/kA
   k5PhPBsFvHSY7US9AI5TY6UEWzbNyAkXV+gCA2rUAvUYskasTVI11qFP0
   eJLP/03lw5TQKhgIb8rlG0GTUVNBE2xpTKMqsXE5bOpG6GQ4ZN9buQitA
   gmhgAc7ppJHNGVOBxbUX3nEp22n4hXDthvem73g4r+gZ2jjh4eFC7rhrg
   A==;
X-CSE-ConnectionGUID: YnB2GhAfSUC0ZgfIZVxMoQ==
X-CSE-MsgGUID: wJSQRR+xQFagLSTZHx87Rw==
X-IronPort-AV: E=McAfee;i="6700,10204,11407"; a="46814611"
X-IronPort-AV: E=Sophos;i="6.15,222,1739865600"; 
   d="scan'208";a="46814611"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2025 13:51:36 -0700
X-CSE-ConnectionGUID: 9RV8VgBhTtOxbqWUlL0I9Q==
X-CSE-MsgGUID: E41Rt0AKQ++FLRbo2imNrA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,222,1739865600"; 
   d="scan'208";a="131741285"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2025 13:51:35 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Fri, 18 Apr 2025 13:51:34 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Fri, 18 Apr 2025 13:51:34 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.41) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Fri, 18 Apr 2025 13:51:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=L/eR7MwkIqTXp9XakImklSnET31aavVIGy9H0qsMKQCwOUhpEKoDQf5ZCg2ABO7TRZSqKfoeaCQ27UXKvKC5h5JqgJrlqPtMITNdCrsjTNkgyJiDULYCkEEuGT6rMmF8Zpyg8fwn/NQNZSgyd3wa4tnN0kY0fICHQkyio/gLI3xW/YDoRB/d4bFd+ZBGE9MInq0+f9L5pkBCk6Op6WTzrCIjAi/St5Rty8MZMchlKFud0EbXuSYY2SKznygEoL4vkyNSTWzCy6AKtVL69VJYCtpgmVg1GsQACEPkc4Y98PTWn9nEEj3lpTr6f1Zg13FH6QF+SjM9TVOHASeTd7Uczw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1TVceYRye+46BLwKKGk2d4OO7mslK/faMybcm52K4OI=;
 b=qR6y/wXdlqB6NwAtEzm6OQSEP8G7zr3h5KEz3aA3pYr2AFMhX+C1b5f1YLDGInSg01UOOdPjNxj9x/mlhkfjUUye9DhTryZbJTWkJ4MDLFsWXCX0lqMXy9WuiVu/ZO3JOgvRICK1FtnqbF0U4A75mFn4QpLB5l1UO+iQQYdka2fCvLhUjbgf20dgELggOaTBqZBehMWLQy/JQ2ct8HBBgaxs3fkhEjsqTMDJ1QpMKpp6E+hEBojKjSBX2uBHtLdTkoMlUEpEbt2hjNpjsBSjJrqtI5UI4Pkj5kXyERjvdx1LLf9iC6YxwDwrwTzm6QGf99JC17OXiqoJ1wE4XIuwjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7925.namprd11.prod.outlook.com (2603:10b6:8:f8::18) by
 MW3PR11MB4635.namprd11.prod.outlook.com (2603:10b6:303:2c::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8632.32; Fri, 18 Apr 2025 20:51:02 +0000
Received: from DS0PR11MB7925.namprd11.prod.outlook.com
 ([fe80::b1ef:c95b:554d:19c9]) by DS0PR11MB7925.namprd11.prod.outlook.com
 ([fe80::b1ef:c95b:554d:19c9%4]) with mapi id 15.20.8655.022; Fri, 18 Apr 2025
 20:51:02 +0000
Message-ID: <0f260941-0bbe-4dad-b622-a1a8ecc0a8e5@intel.com>
Date: Fri, 18 Apr 2025 13:50:59 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 1/7] x86/fpu/xstate: Always preserve non-user
 xfeatures/flags in __state_perm
To: Chao Gao <chao.gao@intel.com>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, <tglx@linutronix.de>,
	<dave.hansen@intel.com>, <seanjc@google.com>, <pbonzini@redhat.com>
CC: <peterz@infradead.org>, <rick.p.edgecombe@intel.com>,
	<weijiang.yang@intel.com>, <john.allen@amd.com>, <bp@alien8.de>,
	<xin3.li@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>, Ingo Molnar
	<mingo@redhat.com>, Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter
 Anvin" <hpa@zytor.com>, Samuel Holland <samuel.holland@sifive.com>, "Mitchell
 Levy" <levymitchell0@gmail.com>, Vignesh Balasubramanian <vigbalas@amd.com>,
	Aruna Ramakrishna <aruna.ramakrishna@oracle.com>
References: <20250410072605.2358393-1-chao.gao@intel.com>
 <20250410072605.2358393-2-chao.gao@intel.com>
Content-Language: en-US
From: "Chang S. Bae" <chang.seok.bae@intel.com>
In-Reply-To: <20250410072605.2358393-2-chao.gao@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR06CA0020.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::33) To DS0PR11MB7925.namprd11.prod.outlook.com
 (2603:10b6:8:f8::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7925:EE_|MW3PR11MB4635:EE_
X-MS-Office365-Filtering-Correlation-Id: c633f4b0-be29-4679-55d2-08dd7ebabb01
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?ZktSNXNIR1hkMWdabGdQL29PSTc0am9WQk9sWEpHZTh3dFlzUU82bFpob0FD?=
 =?utf-8?B?TGttNE04ZEpHVXFKcEg5YVM0NlpZbyttZVl0bzdZMEcrZkZYaG8vR0pFalJq?=
 =?utf-8?B?RVNIWHY2VFRZVzJPVUZ1TjNIL1NhZnpPdjBFOW5LYmJjRnRmZ3RvbENmUm5u?=
 =?utf-8?B?enRkeHYwZ2FzWVRvY0J1a2grYmN4Z3FTKzJFdnhIMUJZTXA1cFMrODFKVVUy?=
 =?utf-8?B?MkJHcjFwczZXWUZoN0R6U3EwcUJzM0JiQ2ZSTWdod21VdWNMTXZvNFRLNHN1?=
 =?utf-8?B?VkNmS0lCeUpCVThpYndwc0M2bEdsaGx2dHh2cnRvdHdIUGNXSk1rU0wzMzcx?=
 =?utf-8?B?clAvcVptMTh4MEE3dEhpOFduWkpJWEcwTGdiS0o0cXJxTHYzMUZTNFdkNFFv?=
 =?utf-8?B?OTRjTm1VSFpuMFJXQnlzUW1RL3Fta1AyR1FORmVHQ1dhcEJUcnFKSVB3YnRm?=
 =?utf-8?B?M1Vud0g2eHBZK1YwQzkyUkdTU1NsQmNqUVB0LzV3MWxvTTR5ODQ3NFNhVUVQ?=
 =?utf-8?B?SFZCOGFzVElxU2NwQzh1SERPVVJvZmRTWU1jbUVDUnhmZWNhTlF3OVkrMHR0?=
 =?utf-8?B?K0wwUkQ2OWxWSHNmSjk1enpZc1BLT1FwMXVnaExSMWpNTFF0Wi9tOGduOFlu?=
 =?utf-8?B?cTFDQjc3ajQrVEZhVXB0bDlYZi9ZU3VOZGtUZTZydnpyc3ZIN2o0TFdMdjhY?=
 =?utf-8?B?eng4bEdSRDBqRmZwelIyOUU1S25WMFhiRlVVSWtHeXhaQlJUNWVweUFiRnZV?=
 =?utf-8?B?b2h1cVIvRHMzNmp4R1liNnpvWGQ4K2J0Y3crNm01cHM2czdOMlAzeGRub1Nv?=
 =?utf-8?B?STFKdDdKMzVaZ0NBcVJFQldCbWVsYUYrcmhMeHhaWXNpWGlaN213UEZTZzZa?=
 =?utf-8?B?QmVMK3RabVdRODFlb1lWYWZxSmZhWkxpcjdXYlM4bnZIZmFiS3o3ZUJ0UCtm?=
 =?utf-8?B?eXNIUnFnV0lYR2E0UkpIcTBQK2JrVkd4QktHZVRsMTZKRFp0VzR4NkdDZjlk?=
 =?utf-8?B?T3JoSEcyNVBYdmpVdWRkcjYzdXNCQmdMTWtpNVpJZmNqeWlsNFJzM2ttd3Zz?=
 =?utf-8?B?eUtMc3dZeUF1SlNYaENSRUs1cTBGa0dmajZZZUozQ0pPL0VpY0V2UW9lejRV?=
 =?utf-8?B?L3o5Vnh2bStBUjlhYllYT094TWw4TDJ1VWZkVXpTeGxqT3krRE1HYkNSTFpG?=
 =?utf-8?B?MEVvbm9MMEo1ZXdiNXhnM3N5aW1iMGlhKzUrQ1lqWFdWMFloWC9HWDliUU5Y?=
 =?utf-8?B?YnRlSThYakpvbm9zY0U0RkFyNUZ0RnRBYXhWWlc3R0E1eVo5U0xkaHFlMlFD?=
 =?utf-8?B?Qm1wekl1ZG9rVlo5dEhUeFVVVkEwT2JicjA2aFRPZmVSOWFrbmM5UXppRmVa?=
 =?utf-8?B?c2x6L0hhYUxWcHg1Vjk2blJiTFNrektwZ0ltaTV2eWx3a3Q2bW93VmJEWmxn?=
 =?utf-8?B?NUJXN3RsZDJBVFBQOGZJZ2lRTVp0MzRUbmRJQUZTQXloV1VEaVk3QWJPWFNv?=
 =?utf-8?B?ekh4M3hudEdQQ0FOYjJXbzVrb0dQaDJMTGVITWh1dkJzOWJaOU95bUhNK1Z0?=
 =?utf-8?B?bWlGazlzVk5iZVloL2djNEpZeVhtQWZrUXFjTENtVWJzTkE0bmcwdUhJa3pZ?=
 =?utf-8?B?UmZqT3RrUElJUjNYNWVlQlZQVTJGZXNHTm1rOC91M2UzWUJ5ZnFPTHQwdVNk?=
 =?utf-8?B?SXFNV2NxLzVHNmhoanJEd0pWOEhBTkZ2SFhwb29SbmFWc29iQVJHNmRhTStV?=
 =?utf-8?B?ODBhazJyYWUreGRFMWRDbUp2Y1U5T1ZYb1B1NHNaamdqSk1ybXVhYTRxdE1B?=
 =?utf-8?B?K2Vyak9FNmMwZ0ZZWmR1L2FNYWFtcDlFTkg4Rk1KNHdGNG0rY2NFcW5TdHgw?=
 =?utf-8?B?VjBxTFVrdEF3VWhaV0tiL3Q4SUN3VWVKYkxZK1FjR1VySk9vcGtpaGVmbC9t?=
 =?utf-8?Q?7FtZL/DHBgc=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7925.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SzVyUG5JZEhrTElpMmVleTBuMkdvZmllak5ISkc4VVJUTDFIMmdNTExjY3JZ?=
 =?utf-8?B?TW94WHdvYXZCTjl2RzhZOFpsdHlnSXo0cDUydTJFOXhWMFF0N1dwcG9icWRw?=
 =?utf-8?B?aTZvcFEzWjRHZ1E2RUNsQ29VUEZubU1kck9YR010dmd2RmtPZjlnQmlRYzZz?=
 =?utf-8?B?TUlMby8zU09MbnBaWDd2bDU1eXNIaXBQNGNBeGh5NUw4MVljVUtaMkZMQU9l?=
 =?utf-8?B?Qm1zb0s1bC9LbzlERHRjSlBBYkd3dC9JSXBSeFJsYVVTa0J6WDlRSStTcXRF?=
 =?utf-8?B?bzFnMUM2NHRNcUZWUHZxajZzRkhhWWNuUzQ0MEJFL0RJOHBsVzM5ZGFRY2xp?=
 =?utf-8?B?MmxQTENRdGl0VGNIdjF0ZjJWUDNwbTRHWDBUU2VyeXY0bkJlR2FPUWJob0Ew?=
 =?utf-8?B?RU1yNlNRT3g0dHVYdkRMOW5hRjZhWlk3WFFVcWp4c1VqbWlzUFdUdnQvcUtR?=
 =?utf-8?B?YWlzNzJsMmFBSUJpTkoxYjlQd1F0S09HMTEwR0VQb0REL0xHb053TUM2NWoz?=
 =?utf-8?B?VUJCSGMzNmZTdG9hdi9vY0VzRzQwMSs3MXZXSGpUWEV5Q3pxMnZuSDRoTGVi?=
 =?utf-8?B?dVJMUENBT3lDQzZDalZpcnM5LytlOHUxSzFOV0FTVkhPdUYwQkJvRTJKc29W?=
 =?utf-8?B?VHVTV1p2elZEbHNtSFNSWHpkeEErTWtMdk40R3lGcU9UVVV5bHMvb0VnSy96?=
 =?utf-8?B?cE1MUEY0bnhsUUJOcVVEcEtWNVo0RnN4NnNOVTBsTjhOTXVXZDlKSGZjaU5v?=
 =?utf-8?B?QytHbGZNTjFvVklkN211TWw2ZjRTVGVqUFA3NWNGOXVnTFQyRFVidy95RWVB?=
 =?utf-8?B?OTVHc1gxWENib2ppK0VyK0lEN3dLZUNpMFBNcXp1YnpvWnlJdTJBR3g0b0Y1?=
 =?utf-8?B?b1RNTEtkQW15QTB5dFZuWWgxN21IZ0liYmNUZEt6ZExOeTdBNFM2cFpIZEdB?=
 =?utf-8?B?Q3k2WlBsMnhrRWloSGNiZnNmbzA1SkNlSUduMDY5Z3FBTSt5L0tXTGJTUGhK?=
 =?utf-8?B?Qk91QWJnM2lxN0hPS25QbGlFQ3FDZ0I0VVJnek43WlhNanhYOTN0Um0wRWk4?=
 =?utf-8?B?ak1tcnZMVE0vQlQxYWo3L3VuQ3QvUkxEbzNuK0xGMlJWbE8ycGZXcXM4aWt0?=
 =?utf-8?B?cGE3REtBWVhtYVhldmxQZDNXYUdSTGk4YTBJOXpZSFE0V0ZKRG1ZTG1DZkV6?=
 =?utf-8?B?eWxxbVBGaUFOVnFyak5pMXRIT2FkVHpKQ2dhWHRkYktJazBpOGcvNUJDZXhw?=
 =?utf-8?B?TCtkQkptVzMxRkh5ODF5YWRGYlFHNHliaFBmYUlTaXpwUm9ET21nVFdjTWZC?=
 =?utf-8?B?RXgrdnlaY2RMWE96U2wyaGJOOE1LSlg1SDZNdXFQUnNuTXF5bjkrQ210MDhx?=
 =?utf-8?B?TjFhZzU0czJUQko3V2luSDdjdTNMeVZHRDE5d0NldFB2cWtJM21pMFo2Vzlh?=
 =?utf-8?B?UDlMUHUxMVpac1JGZjdSTHFvVk1QVlNieG5CWURwL05iMnVOMlZ0TVBIQkNr?=
 =?utf-8?B?TWlGT0pQUVBZR1FEdkkxOXJ5NDZLUDhST1l1cWErT25Ha3duK3FrWDJrVVZr?=
 =?utf-8?B?ZDZlQXh0RWFZdFg3aUJ2c1NmRjhKeWNUOCthbDRGUGM4T1l1OUcvanVITmts?=
 =?utf-8?B?TG9OVkpjOVQxU2pPY3F2dDdESDJBaXRyNXQxdDNYNWZZZDhrbkJMMzYvc0Zo?=
 =?utf-8?B?anJMb1hqUHRjcFlOd1Y5RGg2ZUp4WWhsd1ZwRTEvU1pHM3Zsc3Q5S0NVZVVS?=
 =?utf-8?B?SWgyOXI5aHdydFhjRUR3M3FiRzg1aGFicnpKZnBSMENvNjRNV21hRzNuNStm?=
 =?utf-8?B?SERyNS9Veis1bjkrTFRzbytlTVU3cVVRZTFXRHFGdlBjdHFwQmllVkhQeU5h?=
 =?utf-8?B?SlBEYXVaQXdMdThEZGVqd3J3aUp5MzZGaDdHN1M1UUN4QVVRZmJBOS9vZVZB?=
 =?utf-8?B?VlBJbEI3dTI0T0tPenhPREJBT3lIRGJoQVV2c1hwelAvRHFrc1JKN2RMZFVm?=
 =?utf-8?B?TEVPdGRVWEpQYTR1cFA5RFBhZ21BMWNYQlVnOThEc0Y3L2NnRVYxNEpHd3pB?=
 =?utf-8?B?M3pvYXBEaWlZTC9saWV4ZnUxTHVvWTJHdTNoRExIVDVYbXNUalNFR2V6eEM0?=
 =?utf-8?B?a3IwY0FIeWxvRVVhYzV5V0psWWhib1VkWTBPQm1DT1ptSW93NkJkb3lHSSta?=
 =?utf-8?B?U2c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c633f4b0-be29-4679-55d2-08dd7ebabb01
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7925.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2025 20:51:02.6002
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ldwGmqkaPL1uGGjR1YkshRVo6+TQ0eNoBYzdaYMhr87hBO7E+m50XF9yGfTVVEpmdB7DNjLJMqTlEfbfk/7xldMViyZET5/B4hsKaw3nWMU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4635
X-OriginatorOrg: intel.com

On 4/10/2025 12:24 AM, Chao Gao wrote:
> From: Sean Christopherson <seanjc@google.com>
> 
> When granting userspace or a KVM guest access to an xfeature, preserve the
> entity's existing supervisor and software-defined permissions as tracked
> by __state_perm, i.e. use __state_perm to track *all* permissions even
> though all supported supervisor xfeatures are granted to all FPUs and
> FPU_GUEST_PERM_LOCKED disallows changing permissions.
> 
> Effectively clobbering supervisor permissions results in inconsistent
> behavior, as xstate_get_group_perm() will report supervisor features for
> process that do NOT request access to dynamic user xfeatures, whereas any
> and all supervisor features will be absent from the set of permissions for
> any process that is granted access to one or more dynamic xfeatures (which
> right now means AMX).
> 
> The inconsistency isn't problematic because fpu_xstate_prctl() already
> strips out everything except user xfeatures:
> 
>          case ARCH_GET_XCOMP_PERM:
>                  /*
>                   * Lockless snapshot as it can also change right after the
>                   * dropping the lock.
>                   */
>                  permitted = xstate_get_host_group_perm();
>                  permitted &= XFEATURE_MASK_USER_SUPPORTED;
>                  return put_user(permitted, uptr);
> 
>          case ARCH_GET_XCOMP_GUEST_PERM:
>                  permitted = xstate_get_guest_group_perm();
>                  permitted &= XFEATURE_MASK_USER_SUPPORTED;
>                  return put_user(permitted, uptr);
> 
> and similarly KVM doesn't apply the __state_perm to supervisor states
> (kvm_get_filtered_xcr0() incorporates xstate_get_guest_group_perm()):
> 
>          case 0xd: {
>                  u64 permitted_xcr0 = kvm_get_filtered_xcr0();
>                  u64 permitted_xss = kvm_caps.supported_xss;
> 
> But if KVM in particular were to ever change, dropping supervisor
> permissions would result in subtle bugs in KVM's reporting of supported
> CPUID settings.  And the above behavior also means that having supervisor
> xfeatures in __state_perm is correctly handled by all users.
> 
> Dropping supervisor permissions also creates another landmine for KVM.  If
> more dynamic user xfeatures are ever added, requesting access to multiple
> xfeatures in separate ARCH_REQ_XCOMP_GUEST_PERM calls will result in the
> second invocation of __xstate_request_perm() computing the wrong ksize, as
> as the mask passed to xstate_calculate_size() would not contain *any*
> supervisor features.
> 
> Commit 781c64bfcb73 ("x86/fpu/xstate: Handle supervisor states in XSTATE
> permissions") fudged around the size issue for userspace FPUs, but for
> reasons unknown skipped guest FPUs.  Lack of a fix for KVM "works" only
> because KVM doesn't yet support virtualizing features that have supervisor
> xfeatures, i.e. as of today, KVM guest FPUs will never need the relevant
> xfeatures.
> 
> Simply extending the hack-a-fix for guests would temporarily solve the
> ksize issue, but wouldn't address the inconsistency issue and would leave
> another lurking pitfall for KVM.  KVM support for virtualizing CET will
> likely add CET_KERNEL as a guest-only xfeature, i.e. CET_KERNEL will not
> be set in xfeatures_mask_supervisor() and would again be dropped when
> granting access to dynamic xfeatures.
> 
> Note, the existing clobbering behavior is rather subtle.  The @permitted
> parameter to __xstate_request_perm() comes from:
> 
> 	permitted = xstate_get_group_perm(guest);
> 
> which is either fpu->guest_perm.__state_perm or fpu->perm.__state_perm,
> where __state_perm is initialized to:
> 
>          fpu->perm.__state_perm          = fpu_kernel_cfg.default_features;
> 
> and copied to the guest side of things:
> 
> 	/* Same defaults for guests */
> 	fpu->guest_perm = fpu->perm;
> 
> fpu_kernel_cfg.default_features contains everything except the dynamic
> xfeatures, i.e. everything except XFEATURE_MASK_XTILE_DATA:
> 
>          fpu_kernel_cfg.default_features = fpu_kernel_cfg.max_features;
>          fpu_kernel_cfg.default_features &= ~XFEATURE_MASK_USER_DYNAMIC;
> 
> When __xstate_request_perm() restricts the local "mask" variable to
> compute the user state size:
> 
> 	mask &= XFEATURE_MASK_USER_SUPPORTED;
> 	usize = xstate_calculate_size(mask, false);
> 
> it subtly overwrites the target __state_perm with "mask" containing only
> user xfeatures:
> 
> 	perm = guest ? &fpu->guest_perm : &fpu->perm;
> 	/* Pairs with the READ_ONCE() in xstate_get_group_perm() */
> 	WRITE_ONCE(perm->__state_perm, mask);
> 
> Cc: Maxim Levitsky <mlevitsk@redhat.com>
> Cc: Weijiang Yang <weijiang.yang@intel.com>
> Cc: Dave Hansen <dave.hansen@intel.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Chao Gao <chao.gao@intel.com>
> Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Cc: John Allen <john.allen@amd.com>
> Cc: kvm@vger.kernel.org
> Link: https://lore.kernel.org/all/ZTqgzZl-reO1m01I@google.com
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> Signed-off-by: Chao Gao <chao.gao@intel.com>
> Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
> Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Acked-by: Dave Hansen <dave.hansen@intel.com>

The code change looks reasonable to me.

While the changelog is a bit TL;DR, I understand and respect the intent 
to keep the full context, especially given the KVM maintainer's 
preference. So, feel free to add my tag:

     Reviewed-by: Chang S. Bae <chang.seok.bae@intel.com>

