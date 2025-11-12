Return-Path: <kvm+bounces-62835-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id DB5B8C50A85
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 06:59:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id BE9874E2597
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 05:59:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBC702DC349;
	Wed, 12 Nov 2025 05:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="f9zFwtCB"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5373A15D1;
	Wed, 12 Nov 2025 05:59:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762927179; cv=fail; b=ByRwn8n1LnXyfMqegteyQyGYSwHFvOyflcSZztOkPT5m/g20ei4tWL26wtGc2zZZGTwtF7lLTGbu46LlWTMY/9fGxaYcy5Auj5ELw++3VZd9w6VhUep8aBi7QtBLo/FJi/v7MM5OGDGIlGT428qZdk3P/WWvfEZpZfczSESYcXA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762927179; c=relaxed/simple;
	bh=lj7SFBjR1jLml5y6B92RLF4A+wSuWn/uFA/owJIFpdM=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ZZgAF59e8auWAg8HBIHE8OYChbCudtWYLfM+91CyLRjagRXoEnc0XpkWOmIfFXxKBnWVhhap/We4BsmPDDZ43Ixq3IXsjXzpVL28zo8TfQyz5ZDlodPvHSJF8MjGawKvM4xC6DPqisw+1j66tc/UxXWPbfVA56oTiNqj87Lw89Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=f9zFwtCB; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762927178; x=1794463178;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=lj7SFBjR1jLml5y6B92RLF4A+wSuWn/uFA/owJIFpdM=;
  b=f9zFwtCBu7hWO7g9d4n8Pg5ZFyV3den9FNaJa7WkdwEM/r3g0Y722pGY
   IvVO4Q2QzsgGrAEvraA/qbPSv7xJ7TjApFM/qGGb+ep3QWbPZuMro6cti
   oq6EOYPwssqEbDXjCli27BBjQdJ3pW+MH+QwVZUoHJeE7DLEs6yjZsW85
   6ucMHstwNmnm8Og18U7/HOPxJAWEzOwsTaCAPAWUYbeve7FarpFP1wMEK
   U7XxPuHMSp77YHibFMJnWzi5mHd0Hz/WRiKcaBDarCZqm9syiXBbrTSgM
   1slUJzcZUBj1DaMiVAiDq7YtAynC8wlvainPEC0M5e2U8efjrM7LcYZmx
   g==;
X-CSE-ConnectionGUID: hC2N0oa1Qs+VuarfckG93w==
X-CSE-MsgGUID: tA09xJO9TUmweZAhvBWs4Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11610"; a="68846804"
X-IronPort-AV: E=Sophos;i="6.19,298,1754982000"; 
   d="scan'208";a="68846804"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2025 21:59:36 -0800
X-CSE-ConnectionGUID: xrqoI9GKSEKOwI0DXAsuog==
X-CSE-MsgGUID: kt+fAINQSkKdFiP37FCrBg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,298,1754982000"; 
   d="scan'208";a="212526595"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2025 21:59:36 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 11 Nov 2025 21:59:35 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Tue, 11 Nov 2025 21:59:35 -0800
Received: from SN4PR2101CU001.outbound.protection.outlook.com (40.93.195.30)
 by edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 11 Nov 2025 21:59:35 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AUCTU85pQQz9rP99A13AnEyny17ZFUSo2f87Q9aqpe0mkYGWaBX3MjYfIDr40hiMFs+/MOaMVMRMPcvOroExvosRdOG6+7m1RuABeIB1H2b6Jrlez279rD8VgQy6G0BKVX0GHc9oB5iqjkm0c1HixFXPemBxid0VXlH3/lwDi5EAGqfPw+9n9yqI00piTA3vlI2sZ+W+EVJewk28INoDyNcjbuGUYilkto0xtcevBBBq9Uuo1i3Yy9FDr+I9kMaR657zlDHUUqL7cNsmLpGLs00y19vE9g6R+TCYDeZVsToarmphE5WY9mbPhsHwZc1fCjK08DRQWJzxtrxzUx4eeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lj7SFBjR1jLml5y6B92RLF4A+wSuWn/uFA/owJIFpdM=;
 b=tc2EKvxT7aK1OpRf0+JPgeeT+ng+B+7oS54qt5VBqiccA0AsqN6fJn+IdoTl5e2QU4dwCc1/UpFrpbcJG/tvP2wK1CdgGpNXwOM0df74CN2xGckOiqndMtwxBltPZ9Gs54itD8Zhq6uJEs3fFg4iMK76ib9X3WbGuvD19EUKXPudqnT/pMY0w7aQEEtuhbEQ89VBuoDgOpnJKvH0c/emv8He675LpzvbUG+ifWcPwq9KRc+vret+42aM/zuR9MCncEcB5qek9t4Clbf8vplr55Tz/WC108Mh4pUBF/qb0QgpxFTt4LLNErirIvjyjQW/JJqCFxJZejG+uloDQKRTYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by CY5PR11MB6258.namprd11.prod.outlook.com (2603:10b6:930:25::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.15; Wed, 12 Nov
 2025 05:59:33 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%4]) with mapi id 15.20.9320.013; Wed, 12 Nov 2025
 05:59:33 +0000
Date: Wed, 12 Nov 2025 13:59:21 +0800
From: Chao Gao <chao.gao@intel.com>
To: "Xin Li (Intel)" <xin@zytor.com>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<corbet@lwn.net>, <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<luto@kernel.org>, <peterz@infradead.org>, <andrew.cooper3@citrix.com>,
	<hch@infradead.org>, <sohil.mehta@intel.com>
Subject: Re: [PATCH v9 09/22] KVM: VMX: Save/restore guest FRED RSP0
Message-ID: <aRQiOVfJg2PwyEdk@intel.com>
References: <20251026201911.505204-1-xin@zytor.com>
 <20251026201911.505204-10-xin@zytor.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20251026201911.505204-10-xin@zytor.com>
X-ClientProxiedBy: SG2PR02CA0018.apcprd02.prod.outlook.com
 (2603:1096:3:17::30) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|CY5PR11MB6258:EE_
X-MS-Office365-Filtering-Correlation-Id: a0302078-0368-4c15-6199-08de21b0a6db
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?RgsEOQL6xylhUgY0uv8QvqK9/f/3O3P87VxFC10hgKMaVI5a6L5JLOlpbD+s?=
 =?us-ascii?Q?486aRErD7YnlEh9gBrgMVm0p9VmOGfPcJkY9agqdLziUjKpC4UM6kYmDkqWM?=
 =?us-ascii?Q?Ip27TJ4br9GembZCAl7/bXJZuoI0W2K1qbs9HGl0VKjkKocSKgS4tMUIzFtA?=
 =?us-ascii?Q?/4llQMRPZfbkOPubdOvKCuPxTLc4446yFhr651gShzeKCpNQqr7QCeYsfjvy?=
 =?us-ascii?Q?P+zxC5Sl6zYtYHTWTr7zUJL4CNS2Vk0jpgeagg/dgnocPoigJHMW9J1HibvL?=
 =?us-ascii?Q?dzYBVOe5h8+zTdJxg0N6G1Rag/HgM8u9PRZTOwtWoGSGUs7PiTzJcKkxMas7?=
 =?us-ascii?Q?7REAMRBSCBnfrW7Fp4bAYNR4SoooCb/jdpaMSZnxlJYlLioKWZy5Cpa41KiB?=
 =?us-ascii?Q?h6kXMishq4HWxSDUeGZl625k7XDzYxJv7X5TvogW+PKZe8QREfDpPeHs2IvI?=
 =?us-ascii?Q?AZQrhgEgpbxBjw036gOcdR/3L8igMfBH9G1yTGOIGC+VN6jLTAP269U3dVL6?=
 =?us-ascii?Q?21ImBSrO/W0K33fqNzr3iPuOuPEbRRK61T2mRRSH9YAnQ0CPpbvfZ90zJYlJ?=
 =?us-ascii?Q?enOIOPMwwD0o56uusJBwA2k238JG4kDagZkBjshk/yWYJA85abLAM+hmBdc4?=
 =?us-ascii?Q?L/jKjeRDgJVE/VO6oTVsIARM6S04ivzjrZ2O8uFPUqbOKVTtQEE6oZokXT6k?=
 =?us-ascii?Q?4eCVfzj/O7NGx2/PodNZUGOdRz7juiPqfqe421cCmtwztGb2393fd9FygP2W?=
 =?us-ascii?Q?oQpPNVsJTAMIniNZf+qPwKMQM3UD+AkF8Rppq+zh5Y/6D/7Xc+JohyJBhOCt?=
 =?us-ascii?Q?bvOHyUooW8nMiauxW6GGtbsk0QFSsFqXj8ZeNvdOBB2BraVCWRYgPkAPLCRk?=
 =?us-ascii?Q?AHCkWV8LMBX9kkazg91GdC9USidvxGHJ9pnu6PzD1RtBLKnxBSyv0YGx6sxu?=
 =?us-ascii?Q?4b0f+ML+hkt1ZLT6ThqODOmvakzplp0l/TuShQN6QBQAbz2z3bCSdAXQBRPI?=
 =?us-ascii?Q?H0yho12D2K6RHRbt8D8oU6LJOqf3kHfHzNzzqijP1Y5dq0FKu3kK0Eez0oXH?=
 =?us-ascii?Q?Nls7cBfRcBptdOSQfTHyVd3+DmhjrQQqhpBOMOc/07CobrhibvmtT+nxjub7?=
 =?us-ascii?Q?ZZpHsaTJlyM3Uzj5/8/7BotqQxetMMzwiYK/v3D6roziCAeB4mbYpeOSFOhN?=
 =?us-ascii?Q?Vz1FYJsMTB/mkG60V2FlMIDE/MEptjJjvBZ4w3ATXF8Cfk9JeiBxzr3SBcmR?=
 =?us-ascii?Q?DEkcAoY7ZSuV6e92uDLOR/sspn27R3rUvUBu/NtxIPfox3BvmT+tPUaClNjc?=
 =?us-ascii?Q?LnkxdKE6qEVEDAhYsrMrJi41Ps2cI02aiHD/rNzg4tauDZey6ZcIR+KPlLkk?=
 =?us-ascii?Q?H5ok0AeoWvOvqVeuqsitbrZWh4zvFj0h4tRMDI+xFUT8WaqNYaDhgONs/FGQ?=
 =?us-ascii?Q?5myDLGyUOhpzAOQ+687YBGC3+2xRTl7B?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?n9Ynn9zS+D1ldeyTemaAFFpNl4zOCHp/TsdjjhSZqG9vbaeAwsqpdlo7KC+0?=
 =?us-ascii?Q?ajRejR3M6Y5C92+tUcRiObZa4VbJcqL7ZTGOoslvKVojBx9mXHBbpwQmfNif?=
 =?us-ascii?Q?O6YIB77ipvGfT2PNSKXGn8cKyDTCGyeI4Z72auMSQsFzEFFZdEMaQcaJIUR7?=
 =?us-ascii?Q?e+9BdvwJDMCB8oN6/QxpwBifc2NrlbupNHHPY4DtqTV5kf52qFIHNX8jze8I?=
 =?us-ascii?Q?oUtCKvTzjMIuODo6UNL58Q7WFay3Q4VERdl8V9yyEIC0dddZK3fSFeNjpLaP?=
 =?us-ascii?Q?qTxBaht1BNsaHbNkaUYLJ8AIvkHfHVMl7xhXLcKlvfAdklnIkiZhqtWU0dBW?=
 =?us-ascii?Q?xHch+WgEqbkZAR5qTIDbGSL0H8CfBFe/Q0DTncjTGkmc0aXb24ZvyJBfpLqd?=
 =?us-ascii?Q?QrwQ0izXr+HPZ+srXgYBqejhZ6+ZRheR0052gF2VRMipi7EbHjR9DlXBVX3a?=
 =?us-ascii?Q?rmb78gCX8qWhdYrcGqDVdkWkPWJ9tq72ByI+vDRwO+CglNwsQ+khUfvKhEjy?=
 =?us-ascii?Q?U/4Uivw5nseBHMCQmN5Ohn86SlHtAX0XTxpap1aENYsZgm2OzDgfXuf7AiNn?=
 =?us-ascii?Q?1sVluJI2qhnePeYYKfMQWxyv4Al1h6wnR/3pFJeyfrNqBP2PLdfwdtavC9eX?=
 =?us-ascii?Q?7cu16HBvtRUWM9WONj2rDbBhAbw907ONvaP97uRwwOCjLNDI2DiAW2vBXaDR?=
 =?us-ascii?Q?rRh4+9zElD7iTyLwNmRufYKzfQAjSo0Rn66KpZnOiwMinIqwWVa6MDKIGxQK?=
 =?us-ascii?Q?365NugX+mwfUrxOYGJ6EMZh7VizlUO3poQuOI1g6NpbymBf80c5j3z8gnBnK?=
 =?us-ascii?Q?5h7l2lfehJ5iBoik4haWo21wxfJD5elKKRT40BV/JcNO+ffMsJiBDW1SSx50?=
 =?us-ascii?Q?sSsD0Fi0OrEPwCINqALemA39ssfFRxaaaWzyUTli6BT5e7l+WLOeCH2Zla7u?=
 =?us-ascii?Q?MNmR2SzAMGN26g3Jllc35j4gLmJVvgLPTtwmhOH+1CHSqJ3d8E5H0IhDBR1X?=
 =?us-ascii?Q?SRkF0g/7kTrH/eZ0DGwDTD4k3OPYG7bDU7oS6lMRcu9NRHzINaTrQ81p7h29?=
 =?us-ascii?Q?k+R0LtRtLISP2IylhCXCk2bQzKX8DoPhYiSxOA+gbxZe4yxacXZ+bcjB8VBO?=
 =?us-ascii?Q?h4R4B9F6oc9emVABPN8FkRAWAf9FCfJWio3nBfjwZG+atAvkSGmhm/J8tC0S?=
 =?us-ascii?Q?LFE/56H5og6giBzlnSpfvCdWjq6wZCbRH9lQUjXuZQyOGbgF2zONE37Jq0XR?=
 =?us-ascii?Q?j3a2dlwfM6EOzBtU4theTyIMjSW5ATaBeK/K5NeqTxKS0fcWEhMbMWLoPywe?=
 =?us-ascii?Q?KJyfTLBUSZAe2R0UfTvCLqRG7EL3EB102O/AsFj5qY2XGjbnBjGQWZ3QNYSg?=
 =?us-ascii?Q?pq7gqQx9IIGavNKoSjg8WHbVO2dZqZxD1I4pypbOQ9HEALudsJJ4Iw3dytYv?=
 =?us-ascii?Q?36F0PwdvQ2dauM9gNDTGD+PJyDnJY3sdBQdgKAOMUJG4JIZniBPpjL83obTq?=
 =?us-ascii?Q?Rr1JVAoZQdLOLKpprhoprtCjns+1b576UZ3/XMAzlGNI4fkUoqBtbP5LIVzH?=
 =?us-ascii?Q?+uT2eIjYU6y5yU3RR4+S9MgTcjZEuFdtEeil69HQ?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a0302078-0368-4c15-6199-08de21b0a6db
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2025 05:59:33.2941
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7cFM0uBKRp/GcrOIMqCBCW2+FU7Fkde9L7HtJCkvd46Q3QF9E0Padbg4C21DmUnwWLOA06MeiThxjrSFTFKxRQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6258
X-OriginatorOrg: intel.com

On Sun, Oct 26, 2025 at 01:18:57PM -0700, Xin Li (Intel) wrote:
>From: Xin Li <xin3.li@intel.com>
>
>Save guest FRED RSP0 in vmx_prepare_switch_to_host() and restore it
>in vmx_prepare_switch_to_guest() because MSR_IA32_FRED_RSP0 is passed
>through to the guest, thus is volatile/unknown.
>
>Note, host FRED RSP0 is restored in arch_exit_to_user_mode_prepare(),
>regardless of whether it is modified in KVM.
>
>Signed-off-by: Xin Li <xin3.li@intel.com>
>Signed-off-by: Xin Li (Intel) <xin@zytor.com>
>Tested-by: Shan Kang <shan.kang@intel.com>
>Tested-by: Xuelian Guo <xuelian.guo@intel.com>

Reviewed-by: Chao Gao <chao.gao@intel.com>

