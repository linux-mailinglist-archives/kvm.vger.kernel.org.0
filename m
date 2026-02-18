Return-Path: <kvm+bounces-71256-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MKC5G5nslWkXWgIAu9opvQ
	(envelope-from <kvm+bounces-71256-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 17:45:13 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D1707157D7E
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 17:45:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 1BD06300D9C3
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 16:45:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 342F2344DBC;
	Wed, 18 Feb 2026 16:45:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="U6NCDpQb"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFDD6344040;
	Wed, 18 Feb 2026 16:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771433108; cv=fail; b=MCVTMv6v/bxeJW5sMBFNREh66ACDC6bOLPfp+FGB4L4HkGWT8wrz06RquCTGK5/WuYKFSdI7mQetDNOpTaDPPA104kpuR4A+egsDlT/jqb4cSQefwSTITRtu6NjF4O+CmyJW5daPGUNSFzzQyka5+qD6GSrGxAx/viEvomWF9ak=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771433108; c=relaxed/simple;
	bh=gIanLP0XJ2GgoQwxgrvCZt0nOtyEqBBgyzaPLWPhc10=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=skEhmDQbbulnYWSlwpTidWKgBxIQDSGb/NkY3rct68ARxmtozsBuTIOdx56Zui3sriVQHOxiKqcg7s3gpPf+7dLxZwWw9ov+Gl3bqMApjCwYO8lyXiVnFPZyqrjyw8gCQYe50aoR9SA/lIAj4UEz9Ctepr4/JWYnsefRAg+wnBw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=U6NCDpQb; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1771433106; x=1802969106;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=gIanLP0XJ2GgoQwxgrvCZt0nOtyEqBBgyzaPLWPhc10=;
  b=U6NCDpQb58y6S6HBoo7ChEVs6LuZaJ4UzB7AEUDem+GTD4W+vzsQba96
   ht0xc4qhaaEq3VD6qABl42BdGDAwHlzWht7yhVCA8KHQ4fqGf8VxGK+mT
   eAdrq4a98ij2b2hFeByI1inWb10LJQHZV6akrVGMAXchp42wqRE/i7GFv
   Rj5NJViABWxFPbQbBy0PzREE7m4IdE+GvQd541zkrcd53HscgmnOdQopy
   SlFHMwovR01ChUKQ7QNPDl/hFN30K11jbHH5wMJU8eMBn50R/U91uMiCs
   TTBZK/0kvYpRJlB7tOBtSLIqdIxTbN5uKQMiumfvbpuNhp+PRsqApGJXZ
   w==;
X-CSE-ConnectionGUID: fK3cETgaQM+RmfvpWKJSag==
X-CSE-MsgGUID: 21i0tM/cTSqiuWU+Hi+lbA==
X-IronPort-AV: E=McAfee;i="6800,10657,11705"; a="72602244"
X-IronPort-AV: E=Sophos;i="6.21,298,1763452800"; 
   d="scan'208";a="72602244"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2026 08:45:05 -0800
X-CSE-ConnectionGUID: LdXn4k+WT3yydB5k4KYRMw==
X-CSE-MsgGUID: UH2veI3yRuWywVVytS+KCQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,298,1763452800"; 
   d="scan'208";a="213007411"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2026 08:45:05 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Wed, 18 Feb 2026 08:45:04 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Wed, 18 Feb 2026 08:45:04 -0800
Received: from BYAPR05CU005.outbound.protection.outlook.com (52.101.85.61) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Wed, 18 Feb 2026 08:45:04 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pIT29/Kdjjxdc4YLtLCMbj3d4omm2I/pqg23HRfThMQYveh7WlbcbFNXsCSAMplptUW3iL+8irdpqSIWFEJEYHdJRN0ylf9tbBKwi8E/ZcxVy68JqyL8FvUfyDObCTxYDlnnqYcrCeUOtCkmhn3Fj6Mivckh5xSXLQK8nCkUSQO8qMg8xQpB+qeiMkWa49NoTlzCEdhgpMumHv6IOKtcuZdg94iI5xzhE1ZeXrPL39lWQpO8KbegGZIEsVK+YWGypI75noA7Jy3KUxHPHQjUeyA307ZP5WG0rH9bkc36EnhEuSxGM/O5d1kRFwlBWVcl2TWOcy7Xqa5cfQ2A4oMong==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/HTXaeqDO6+aRYBexYzqRGUbtOntYFCCOUjCFaD0i1w=;
 b=a9M3EwlUvvfwKtfqhZ+xt1yjDpaQ6lMdHdgVKjG0ikqhVWkX9VHDxcMupFzVWRX6P6UL6SSGgX5SNHjG4tXvumVbyKKPaDCe7B9bsYLckwJRqtMRxe81mDXiLMPvMZPcgTWjXKep7QmbYG/l7SWLVpryezAmYALBypFFI1MBiZup7jwvMajD/niF/NTEgh7pUeLuRHISKrny8BgqzQRoO2RlakCibzgBKTTGv5vJzuBOB4LpX9ajqS/9Bxp7QqiCeY8/ZrQ/BjBfJfnuyPC1PDPMPXVQRwzBwNZUuFEopC9TzilAZ+RJi3NBYrV+qEbL+ce1AKAmwei19FZyndRASg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by CYYPR11MB8305.namprd11.prod.outlook.com (2603:10b6:930:c1::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.13; Wed, 18 Feb
 2026 16:45:01 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%3]) with mapi id 15.20.9632.010; Wed, 18 Feb 2026
 16:45:01 +0000
Date: Wed, 18 Feb 2026 08:44:58 -0800
From: "Luck, Tony" <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
CC: Ben Horgan <ben.horgan@arm.com>, "Moger, Babu" <bmoger@amd.com>, "Moger,
 Babu" <Babu.Moger@amd.com>, Drew Fustini <fustini@kernel.org>,
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
	<peternewman@google.com>, "eranian@google.com" <eranian@google.com>, "Shenoy,
 Gautham Ranjal" <gautham.shenoy@amd.com>
Subject: Re: [RFC PATCH 13/19] x86/resctrl: Add PLZA state tracking and
 context switch handling
Message-ID: <aZXsihgl0B-o1DI6@agluck-desk3>
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
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <65c279fd-0e89-4a6a-b217-3184bd570e23@intel.com>
X-ClientProxiedBy: SJ0PR13CA0037.namprd13.prod.outlook.com
 (2603:10b6:a03:2c2::12) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|CYYPR11MB8305:EE_
X-MS-Office365-Filtering-Correlation-Id: d81c0bf1-a3b0-40e5-487e-08de6f0d0ef6
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?BBVNf24r5N1avsXhGiAugBTfkAf1gL2C7t4vqQ9SgfcWRSKDnwPgf9LDyQQs?=
 =?us-ascii?Q?nW3vJeZ+4uRX7BwnrMNXITTvqmsWEgvvjvOTOZL07PwCuVbEaBBGsGFRP/Mt?=
 =?us-ascii?Q?vrVcNVwt0NArnxyiCZo8b2SK3sdTF4moxLzyiaVBbHrqW87WdGvVeOjQvD0h?=
 =?us-ascii?Q?+E5hctYlJdUq0qEgwTvhoHVFCJifJO+k8bEkpekzak+v7AB3q7P9bp60t3I1?=
 =?us-ascii?Q?TNibKBGjYeDGv3QnGGjGh2Ogy/IdJ1UwyHKUH2dfByEXelGBiFJb3THhpa6z?=
 =?us-ascii?Q?K92H6GldHXAmzIpNeEj5S73q5O4BfjLbp36yDD82GM4njURsfQ0A0BTUPqBx?=
 =?us-ascii?Q?qQxVCJqflC2d5NCev6NDaugE+bxMS1zAIRJ9N6ljC9pecREVYyzFf0fmGZ2H?=
 =?us-ascii?Q?uBYraW6H1RmL7bTpnC2Ncbn4R0BV5mQwLNlY+FKxrM5zfIRBZ9+v3+Cxro+O?=
 =?us-ascii?Q?zyrS2a73n0BebeTTwRLtBfJv0X1Q/K9hj/36Thl+PUbBgGsxYzvXmYwTW5h8?=
 =?us-ascii?Q?Ev7ZsfAy5KzJ4CWFtrtTa91J82MVjTeGO0GdVeca5Grrv0W+Dj17I77/u5JJ?=
 =?us-ascii?Q?y2ix3aZFQGWHjxz99xNZsBe00Uo5FyiEAyyPh8x04H01CmsmPWPHwzz1dDbk?=
 =?us-ascii?Q?sFQ521pDkCf3CiK4gbGLUhy1S1lTPt/txBQGUmbEoxB+bxgsYD03r83RrOgE?=
 =?us-ascii?Q?JgqBb4mwu4l4TbxhJS7c07kQdBE+C3d4df1jKQKYHCPCrsEJvm3v8un9mdO6?=
 =?us-ascii?Q?fGgK9lb9K/JNz7f76z4oitqv7+z/n8hpx7khmHoLy+dvG/+PkwaKQqR6XVya?=
 =?us-ascii?Q?TtkpvphXVVpecr3Hg6wxcsh+31YHHX2ubeMHflxzIWudQO5/eOPgxPdNvO4+?=
 =?us-ascii?Q?I7n691dA9b4pPiM9WyzY/izUw1u8SFJnEp0T91bEcUlI1YqG7iFFQrqkhhZw?=
 =?us-ascii?Q?IHGL7oWaoVa6ow+unEJB9SxD6R3olJk29tphPBf/HTz5M9/8E/ge8pdz2YfD?=
 =?us-ascii?Q?CC8Vezfq+oMpMTR8Y7Cwbd4gsw1G4BTE7cbQv7gQpop/6EURGO5fQolhxD2M?=
 =?us-ascii?Q?ReB0Wp+ReT8+x3lO250ug/VNB59YmzS+4FSuot1c3mD7ZIVDbAtP29HKHrrD?=
 =?us-ascii?Q?H+dPuAMuT+k+m73Nf2/HQBbBzav6pHS4XnCF6jot/V/PJdOvemPx9lXsM8Aq?=
 =?us-ascii?Q?zkxiHlTvcn7tsVSsAj5NAUg2PZmbFYV02hQ1xw+UnM2xRzCHBHoA9eBWb8R+?=
 =?us-ascii?Q?shotktEBmo/hI3yApu5cT6PtxqZ9IMRqRoQddbWzeatJ1IlAHMgLbIkKrTlq?=
 =?us-ascii?Q?uCg5Bf0EKS8wn7v4mLyQp/B34fPtwW0mtRwSVqHwARM0yiDXa1oW76au0zcs?=
 =?us-ascii?Q?JpCXpeRZDjIvnoKplkUB/4m1HsWkP0wPz6wp7MEOOpAnY/xU9vAFiMnh+YUi?=
 =?us-ascii?Q?Pnt1DDGjWIAT6fu1XdSQwshUJwjeRdyPftfNPk0vkx0kLU7buXmHPE1ZKGru?=
 =?us-ascii?Q?93DLMc44eWo6IdTfkRK9MAzMyX5bHgF9Y1fZCd2h3kIKRm3caLI89/IKIzrI?=
 =?us-ascii?Q?HD9yU1BVUNMBO/V6UsU=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?iqwHL5d5w/0JCRK3oIwwtaLPnkuKHl1A6h6wYky397MlS4RY4TjNQ43NYp5B?=
 =?us-ascii?Q?NROGfwDIXS+ZMIg1EqTtvnHrI5pkzQRVgRiSy3hdMfJq8qZpgFiXZa3BYUU3?=
 =?us-ascii?Q?qa9SVmEawohwgniI3mQ/onmXiXsBZkaszaWAxLUzF1N0sTbd+HWnC6Pgwn2j?=
 =?us-ascii?Q?ZJ4oekheo/FTOX++Qm/W3YXb/Lk1V65B+3qbqLp2vkG7G/xd/SgNPR8/qxdZ?=
 =?us-ascii?Q?WsLzVzXk2MldLjahCiC/+fwHo8QpWKS8g2aeSf+ILJ6ZIkTRkj/hptuOWCt0?=
 =?us-ascii?Q?QhWklYehWpF2xk4E4UBiNsngOtJdECgAyFHuHBoMs6+WAeRotNeU7UolqleC?=
 =?us-ascii?Q?OT1h8dOdeh32NFONs5DhzA1LU8sIGT0fUGXCO+gP/C0U3ZAOytlfTpFQVIJe?=
 =?us-ascii?Q?UYTpaGjlatDpVFw+br/31VUaPmMZrxcyQvkS3m4lTDWk3JPTnsn/qg7wksjC?=
 =?us-ascii?Q?LGXwByTgN04CpPWKrHMEd0bW1T2VDFSKeQC2u032BuofSgi1KaERqc40GGt4?=
 =?us-ascii?Q?bCDV4LYIEVgW0mzRnGOgbq/jzztpvCY3J6mulluE8s5DeNRTHMnZIKvhf3uy?=
 =?us-ascii?Q?yt8lXr5ufly1gbVmEYkym98QWXH+HacJPcHtCc8ZxTeeEb6chCiWUVzkWyAx?=
 =?us-ascii?Q?Sez+nRD/rPAyNQB10e7orU6ElwBE0YNGtpRKHU2opJOVPnYQ85Wgfg3PDosO?=
 =?us-ascii?Q?BKTszcD6Wq8QYi4LUOKJHriG7d7AdlaAZuwKdiISvXMiPouiaSO/AwQqUPa1?=
 =?us-ascii?Q?8FOqTSNijUjdS8C2P4kpOBhqysf+JkAP5+g8NtBezwdYc7DVk193+qTRplux?=
 =?us-ascii?Q?WzGlk1Fb2x26Dw2TZ8UKcVXYFxHZWXWDG971mZ3xppB2rDJFxKMK0CGn1yjD?=
 =?us-ascii?Q?YLdTlHH6KnpvNbR2Kz2MxpOyqiHCnylj0FgcKKAyYxW3SxB+hrB0qi4/DNYC?=
 =?us-ascii?Q?TtxxV9nWqh64zvGcoNsZ9ZBYIavYHABZOr5xv2r4LDMxiaz9YJk+a3BmnlgC?=
 =?us-ascii?Q?RUJ0au8oTFuFKKl107G1UoBThjszMHbqpLVeZ46LockaB1wHgrvcXmLc9ztT?=
 =?us-ascii?Q?BM6O32SFEnWB6OciGooMy+7RBnaEVLBzWMKQewazQG9mZ/TtCCyUwNbcWBUf?=
 =?us-ascii?Q?4fauLiLLNyJ+Ftlk99hgcglByPvE9/SdtCNHDPAnmLYAoXSP3D07z+guTpn+?=
 =?us-ascii?Q?ZjTiwOiv4OM5r0NBNc+p/StnY8w9f14fUBCCOztEPAHMQeV9i6uPVM3diVhp?=
 =?us-ascii?Q?EVSEB2coWZtqwbDCWi0UR/jgX0OirxaCCloNC/k3a4WGICxn1RB/U3itSXNd?=
 =?us-ascii?Q?yTMax+bvv47CLYo/XYWc2MdTOjZ1+HXLGwB/qPIgQ7KfiCJCo9kOZHe00lVU?=
 =?us-ascii?Q?PrGsI566wgVHjwEGpaB5Eix8LEAjmhOegnL55145bJ4PMshGywz/VaTywJqH?=
 =?us-ascii?Q?+yV1j8SCi+Cz6QSezGUQVePKJWpwBKbHrxUUG67bRJbPMVO98C1iVkbGFJ7z?=
 =?us-ascii?Q?Ba4b0TjDKgDFeswP+SU7KGgDbYQJlRF2XyClMonwl6S8ICf5W2BiNJiHrZVI?=
 =?us-ascii?Q?r71O3AeKDt2bSA0RTeAHyAfPFW0jmJnjCMHJ+87L+O1LvA5phQkbxjMtsDdI?=
 =?us-ascii?Q?VmiSGUqjeCOZw0fqvDqM64mIV3d32syWZMezKajN66Jf8LmN+6/tIyAxD3u0?=
 =?us-ascii?Q?8KhDnUAri/H9WIGTzbEcMyq6Pyc9vnIqScqPt0k1TtZ+7eU/mpNg277CXRNV?=
 =?us-ascii?Q?ZGxiirtQzw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d81c0bf1-a3b0-40e5-487e-08de6f0d0ef6
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2026 16:45:01.1672
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: R/2jpjLhq1FtZjeIEaI203NufnaP196e49wbtgHyLpuiOXgXtFUyoM+XeZrO46GnHpN2lO00EkZcwHCE020MrA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR11MB8305
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.34 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71256-lists,kvm=lfdr.de];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[46];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:dkim,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[tony.luck@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: D1707157D7E
X-Rspamd-Action: no action

On Tue, Feb 17, 2026 at 03:55:44PM -0800, Reinette Chatre wrote:
> Hi Tony,
> 
> On 2/17/26 2:52 PM, Luck, Tony wrote:
> > On Tue, Feb 17, 2026 at 02:37:49PM -0800, Reinette Chatre wrote:
> >> Hi Tony,
> >>
> >> On 2/17/26 1:44 PM, Luck, Tony wrote:
> >>>>>>> I'm not sure if this would happen in the real world or not.
> >>>>>>
> >>>>>> Ack. I would like to echo Tony's request for feedback from resctrl users
> >>>>>>  https://lore.kernel.org/lkml/aYzcpuG0PfUaTdqt@agluck-desk3/
> >>>>>
> >>>>> Indeed. This is all getting a bit complicated.
> >>>>>
> >>>>
> >>>> ack
> >>>
> >>> We have several proposals so far:
> >>>
> >>> 1) Ben's suggestion to use the default group (either with a Babu-style
> >>> "plza" file just in that group, or a configuration file under "info/").
> >>>
> >>> This is easily the simplest for implementation, but has no flexibility.
> >>> Also requires users to move all the non-critical workloads out to other
> >>> CTRL_MON groups. Doesn't steal a CLOSID/RMID.
> >>>
> >>> 2) My thoughts are for a separate group that is only used to configure
> >>> the schemata. This does allocate a dedicated CLOSID/RMID pair. Those
> >>> are used for all tasks when in kernel mode.
> >>>
> >>> No context switch overhead. Has some flexibility.
> >>>
> >>> 3) Babu's RFC patch. Designates an existing CTRL_MON group as the one
> >>> that defines kernel CLOSID/RMID. Tasks and CPUs can be assigned to this
> >>> group in addition to belonging to another group than defines schemata
> >>> resources when running in non-kernel mode.
> >>> Tasks aren't required to be in the kernel group, in which case they
> >>> keep the same CLOSID in both user and kernel mode. When used in this
> >>> way there will be context switch overhead when changing between tasks
> >>> with different kernel CLOSID/RMID.
> >>>
> >>> 4) Even more complex scenarios with more than one user configurable
> >>> kernel group to give more options on resources available in the kernel.
> >>>
> >>>
> >>> I had a quick pass as coding my option "2". My UI to designate the
> >>> group to use for kernel mode is to reserve the name "kernel_group"
> >>> when making CTRL_MON groups. Some tweaks to avoid creating the
> >>> "tasks", "cpus", and "cpus_list" files (which might be done more
> >>> elegantly), and "mon_groups" directory in this group.
> >>
> >> Should the decision of whether context switch overhead is acceptable
> >> not be left up to the user? 
> > 
> > When someone comes up with a convincing use case to support one set of
> > kernel resources when interrupting task A, and a different set of
> > resources when interrupting task B, we should certainly listen.
> 
> Absolutely. Someone can come up with such use case at any time tough. This
> could be, and as has happened with some other resctrl interfaces, likely will be
> after this feature has been supported for a few kernel versions. What timeline
> should we give which users to share their use cases with us? Even if we do hear
> from some users will that guarantee that no such use case will arise in the
> future? Such predictions of usage are difficult for me and I thus find it simpler
> to think of flexible ways to enable the features that we know the hardware supports.
> 
> This does not mean that a full featured solution needs to be implemented from day 1.
> If folks believe there are "no valid use cases" today resctrl still needs to prepare for
> how it can grow to support full hardware capability and hardware designs in the
> future.
> 
> Also, please also consider not just resources for kernel work but also monitoring for
> kernel work. I do think, for example, a reasonable use case may be to determine
> how much memory bandwidth the kernel uses on behalf of certain tasks.
>  
> >> I assume that, just like what is currently done for x86's MSR_IA32_PQR_ASSOC,
> >> the needed registers will only be updated if there is a new CLOSID/RMID needed
> >> for kernel space.
> > 
> > Babu's RFC does this.
> 
> Right.
> 
> > 
> >>                   Are you suggesting that just this checking itself is too
> >> expensive to justify giving user space more flexibility by fully enabling what
> >> the hardware supports? If resctrl does draw such a line to not enable what
> >> hardware supports it should be well justified.
> > 
> > The check is likley light weight (as long as the variables to be
> > compared reside in the same cache lines as the exisitng CLOSID
> > and RMID checks). So if there is a use case for different resources
> > when in kernel mode, then taking this path will be fine.
> 
> Why limit this to knowing about a use case? As I understand this feature can be
> supported in a flexible way without introducing additional context switch overhead
> if the user prefers to use just one allocation for all kernel work. By being
> configurable and allowing resctrl to support more use cases in the future resctrl
> does not paint itself into a corner. This allows resctrl to grow support so that
> the user can use all capabilities of the hardware with understanding that it will
> increase context switch time.
> 
> Reinette

How about this idea for extensibility.

Rename Babu's "plza" file to "plza_mode". Instead of just being an
on/off switch, it may accept multiple possible requests.

Humorous version:

# echo "babu" > plza_mode

This results in behavior of Babu's RFC. The CLOSID and RMID assigned to
the CTRL_MON group are used when in kernel mode, but only for tasks that
have their task-id written to the "tasks" file or for tasks in the
default group in the "cpus" or "cpus_list" files are used to assign
CPUs to this group.

# echo "tony" > plza_mode

All tasks run with the CLOSID/RMID for this group. The "tasks", "cpus" and
"cpus_list" files and the "mon_groups" directory are removed.

# echo "ben" > plza_mode"

Only usable in the top-level default CTRL_MON directory. CLOSID=0/RMID=0
are used for all tasks in kernel mode.

# echo "stephane" > plza_mode

The RMID for this group is freed. All tasks run in kernel mode with the
CLOSID for this group, but use same RMID for both user and kernel.
In addition to files removed in "tony" mode, the mon_data directory is
removed.

# echo "some-future-name" > plza_mode

Somebody has a new use case. Resctrl can be extended by allowing some
new mode.


Likely real implementation:

Sub-components of each of the ideas above are encoded as a bitmask that
is written to plza_mode. There is a file in the info/ directory listing
which bits are supported on the current system (e.g. the "keep the same
RMID" mode may be impractical on ARM, so it would not be listed as an
option.)

-Tony

