Return-Path: <kvm+bounces-70775-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IBcpE1Jzi2nFUQAAu9opvQ
	(envelope-from <kvm+bounces-70775-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 19:05:06 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id CBC3111E35F
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 19:05:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id DAF0330151E2
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 18:05:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4FFD338B7C0;
	Tue, 10 Feb 2026 18:05:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EZGiJ/+/"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DB37F4FA;
	Tue, 10 Feb 2026 18:04:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770746699; cv=fail; b=sx8k1dFNzDmyfwTSon8hNdA6ahVJ1uTMPIwD0z5MgQ1XsKcBh1e8GtHOPuu2lVdhKs8OB1kmrqFvBkV92gWR8fLzyRDlb4OafzrSpHJiqy94akXLrkjCWlbv4GcJ7Alb42vML6TrLPeXp+Z4Txspln9Yy/5lBCihcxO/Q7bfE4k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770746699; c=relaxed/simple;
	bh=bZfD9Nsr7Uxz5XzODiSzGqc20eCnlcX3rbcVDz0M62w=;
	h=Message-ID:Date:Subject:From:To:CC:References:In-Reply-To:
	 Content-Type:MIME-Version; b=kcb1YRlV6KFKKahoCJQpfhUlqvLpfsGMxUYY6ZItGkdDyQOTK1smWghkxgWCJ8CCcPx3ZcQuabCmzYleaTqt8TTXPFEfTmGlC7+gT71SSjKhJs0Ev62sR//1tqpuskmXxUztLHXoZsfZKy0kA9LiI9eOw8Ztw2JN0YBKyZ861NI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EZGiJ/+/; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770746698; x=1802282698;
  h=message-id:date:subject:from:to:cc:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=bZfD9Nsr7Uxz5XzODiSzGqc20eCnlcX3rbcVDz0M62w=;
  b=EZGiJ/+/ma43KhdGULTqsTndEJxfKeuOHSL3GBwxto07haZc1T2F3GGm
   cC5N1MnKx8s0+omuLnMlBGLh5siRZjo3mIho6tbB+GGnYq+sRoEbGkvVS
   q1j1bSp+qQNJHIF4neJHSO5L3N8hCyl7skyv+qCse2/kjaG401nHBzATY
   5+21M1Hc6KYhKjJraXxHHV4OXyvk0zrTVfNUJuAFX67V9jsEJhDM7XWQX
   pOnwEvtOS1m4B2R5agJxptgJUqyAKS1YkOm7TsLAkV7F6yeh0lZXZL0Bs
   5HjVAKryx7722ZgZ08x71HkY/6irzUapKIzgrtLIf1vKSJUxJpNiUtUjE
   g==;
X-CSE-ConnectionGUID: eTCosNWeQqqfS3XAgxkrHw==
X-CSE-MsgGUID: DP90FCRjTRaiz4DKpmcPUw==
X-IronPort-AV: E=McAfee;i="6800,10657,11697"; a="82205623"
X-IronPort-AV: E=Sophos;i="6.21,283,1763452800"; 
   d="scan'208";a="82205623"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2026 10:04:58 -0800
X-CSE-ConnectionGUID: T1mZZqUqT0qQXJljpn/dIQ==
X-CSE-MsgGUID: IQeGg5+hTICdArufVJwBpw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,283,1763452800"; 
   d="scan'208";a="249633836"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2026 10:04:57 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 10 Feb 2026 10:04:57 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Tue, 10 Feb 2026 10:04:57 -0800
Received: from BYAPR05CU005.outbound.protection.outlook.com (52.101.85.57) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 10 Feb 2026 10:04:56 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=m3pqTMKsG17FPDLuAsQqY/20CG/s99//4yJGyDmDHqnJpjyxTj+CgI/9uPFluNgV927DQT2SpuVfmTT+0vOYxUVfLneVpkHjaHMZhxxj6EiNzzZpUFmrR7s0g94k41m4eNQl5G8WvsnhlP5RZExLmSRf1AJBu+HswGVgAJ7vMRc8kdfyZydezTEblUGoy+X9MHKJjdQdQgqHmyUWBYY6pzPxsQ8E1GL4aFZDKVcKC8PspbgWiNowp+Woag5lBIOMBBL4r+XeXZSa2rdYqViPtumcz7ketRNlxB4IohxS9DHMbNJtVriG5H9JuRdYF/luDzw3IPd/6yHytOIwnHs19w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=exM0rtcHyAOcONtz1F2xnA0BcRUKwyjP1PeRjYKgmfs=;
 b=R/7PWxDbsII5lBAhef6LqR/OjxIRXGV+Aw9LZlKJcTwlr+Iznv83YSjgGbD8K/4WimJ3wYHOyIWdgbueo+ugFZvSLh7Op45LW/lWR6gJRwhQ4g6DxucwmiQx5m4CRWtRwPL0brZPKfFpxSuyaKyqqPmrx/v6MzzStmYm1VgoEqt19mgCs/6qOj7cKVF3BC0V+n3vY8uUlfRcm8TgOPFVdTj3toMouGiw0ieDsA2TQQDm1HUL3kq8cEneeq4jUmpt6ALPe0ZpsoyJgVHuQ1QK4qWsd2WMZ1tDu0K90OA8qTzMmVPTRnt2JZwmO5lyDbZgnS0f+8hUqtK7UYo6KJDMEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by IA4PR11MB8990.namprd11.prod.outlook.com (2603:10b6:208:56b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.8; Tue, 10 Feb
 2026 18:04:53 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d%6]) with mapi id 15.20.9587.017; Tue, 10 Feb 2026
 18:04:53 +0000
Message-ID: <1f703c24-a4a9-416e-ae43-21d03f35f0be@intel.com>
Date: Tue, 10 Feb 2026 10:04:48 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 13/19] x86/resctrl: Add PLZA state tracking and
 context switch handling
From: Reinette Chatre <reinette.chatre@intel.com>
To: "Moger, Babu" <bmoger@amd.com>, "Moger, Babu" <Babu.Moger@amd.com>, "Luck,
 Tony" <tony.luck@intel.com>, Ben Horgan <ben.horgan@arm.com>, Drew Fustini
	<fustini@kernel.org>
CC: "corbet@lwn.net" <corbet@lwn.net>, "Dave.Martin@arm.com"
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
References: <cover.1769029977.git.babu.moger@amd.com>
 <17c9c0c252dcfe707dffe5986e7c98cd121f7cef.1769029977.git.babu.moger@amd.com>
 <aXk8hRtv6ATEjW8A@agluck-desk3>
 <5ec19557-6a62-4158-af82-c70bac75226f@amd.com>
 <aXpDdUQHCnQyhcL3@agluck-desk3>
 <IA0PPF9A76BB3A655A28E9695C8AD1CC59F9591A@IA0PPF9A76BB3A6.namprd12.prod.outlook.com>
 <bbe80a9a-70f0-4cd1-bd6a-4a45212aa80b@amd.com>
 <7a4ea07d-88e6-4f0f-a3ce-4fd97388cec4@intel.com>
Content-Language: en-US
In-Reply-To: <7a4ea07d-88e6-4f0f-a3ce-4fd97388cec4@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0256.namprd04.prod.outlook.com
 (2603:10b6:303:88::21) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|IA4PR11MB8990:EE_
X-MS-Office365-Filtering-Correlation-Id: c695cd8c-daed-4b04-6933-08de68cee3e7
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?SS84QS9jRmwrYytMZU5EVmtXL0xNSnpiNEMyMHF1YlFvMDlwMUlQTW51TWJ2?=
 =?utf-8?B?OEJncWxUUDJtZy9jSXIyWTZPVHlZelJ5RXFMbDBDcVdONW9FVkprMmJMcjB4?=
 =?utf-8?B?UUwzYldxSlBiWGgzTm44Q2hJbi9lakp4cktmN1pxYTJnVU01bjBDUTZ2N09a?=
 =?utf-8?B?anl4aEpTdzg0cmNiL0FiTXJsaHhLTEE4WkFEYVJvQndab2h6dU5LZmM4b2xn?=
 =?utf-8?B?TnlFMS9VZklvS1lYNWJ6WkpSanNyd3dmSHBmMEZ6VnpJeGdhajNzS0ZlcENM?=
 =?utf-8?B?MzZ2WG5UMGdnUTVsaGNsOEQxWmNjQTFkQlg4ZEV0cHM2dWptZHlObmVQdCtN?=
 =?utf-8?B?K2RneFpyL0VNZG1XTG01QlJjVUp4UEpqeFYySWtSVDEreUlER3YyZVdZSEZ3?=
 =?utf-8?B?K2syMlpGcXZZNFRoeUQvNWtRM082TEdKS29GNzh0RGJBYTNjR1d0YklsdUFs?=
 =?utf-8?B?Y2ZPY2lxSzNmcklkNDBCdUNLU1lrdE9LeDlqeWtCcHJNS0ljemVGODI5M1pF?=
 =?utf-8?B?MExRSmFzZHB0RDRKR0Vkb0RCOHFvUnFEUVJwZGlUMXV3WVRXOG42NTJHWVIr?=
 =?utf-8?B?RHFkT2NTSW55S2V4SWE2N0o2Ui91cERqdDdBY3c3bWZqcWtBRmdtSzZ6My9S?=
 =?utf-8?B?eDRYZDk5L240aHV4eW9hbUs1M202ajJwNTJ2dkVPVFA4VEQrRkVGdHQyUmNr?=
 =?utf-8?B?MEliWE5oTmhzODBxWDZ5VCs4dFhJRWdPcXNpSlpvR1Y3TmFkZkRaR0VoRmFS?=
 =?utf-8?B?V2hJdVdseWhwdW5UZFVJZHA2TFhGanl6WmgxalB6OVFCc1cyMXkza21QUTY1?=
 =?utf-8?B?aEpUZUlreGJzd1hSNU9mWHc3YVNuWk14aDJGTi92REV0N0JhTVQraDdTYTZr?=
 =?utf-8?B?ZzBJYzNkSFNkY0h3ajdnMVJDSjRiaWRxdVB5N1VLT2ZQU1E2OTF6SDZYMW5x?=
 =?utf-8?B?ZkVwdmhNR1MyTFo5ZFZPSUlpNE05ZkNrU3RXWVczVTF4TmdtNlFpTmF4RGFX?=
 =?utf-8?B?YkgxVDQvNmhyQldjdkNHYjc2KzNCYnZJWURNNko3M2Q3Nm03WTE3Z09WYm1p?=
 =?utf-8?B?VGZtVWt5bUNZNWl6NzlRRVZUQ0dnY3RxOFY0ZnB1eU0xcWprT2xGU3plRzZ1?=
 =?utf-8?B?a0pNUWFwQzcyOTZBZ0RhbEZzQ3lUcG5Xd1JxQll3Yno5UnJ0TTV0dUFQV1V0?=
 =?utf-8?B?Sy91MmttUC95d2o4VGxCUXZNM2Eyb3dKSDBQQ3JtVFhlWEMrQkF1QkNCcndJ?=
 =?utf-8?B?R3FWbThyVmgybG5iVlhXRUVIbTl2WkNiYmpGZ0l5OEtWVGdWYU1iNXNkeUE2?=
 =?utf-8?B?aWpGc3RVSjd2TDV0ajBDU200WlV5WU9qYWMrRFNlWTJ6dXhxcW51bjFtYzNI?=
 =?utf-8?B?Vk51TlBPK3M3TmQ1TEVZS0tzMkNnNHByeHJsblZFaGF6RnZNWjRXd3kxdkVQ?=
 =?utf-8?B?SWZZR3VRUTFGTkxGaDl6QlREM0NkVFFmenVVNEVSTVQzN1F6QmRVSFdsdGZq?=
 =?utf-8?B?VzhFSUwyRW4wR3ZpTnFzS1dJNFExSXdWZDFnNGcyV1hhSk1mb29pVHVqWW9C?=
 =?utf-8?B?Q1JkMVVDd3NkSDRLd0QyUzRiMVduUmR0RENJOUs2NWNramFTZERIczlHNXpw?=
 =?utf-8?B?MjFiYWN5S3VQY3czd0ZuckY5djJJSWpCOHJtLzQwOWV1VlhCZnl1MzFmQ1BN?=
 =?utf-8?B?V0sxblAxUjlnUmdwOTJhdW5xaDFZVnJRQU1JOEc4YzhwVTdpRVdlQkJIOUk4?=
 =?utf-8?B?T1pySExjOTNET1FXeUVmWFRCd1NQbXB6ZGFmTkN5c2VNUWwwcGpodjd6RDE5?=
 =?utf-8?B?WWRUQzZPWFZTSGt4Rm9rMllDNzByMGw2STAvMWZVbWpEWjRIUzR2QnJPNGRv?=
 =?utf-8?B?Qzl3R216NnpNT096aWVkenRwME5NNXdIR2puemV3M002TnRRbVltVnhpU1gy?=
 =?utf-8?B?cWRPaGVpdmYvT2xrWlNuVXEzRDRlNzRHT3JDRzZscEtzaHFoWFhpak9ObWV6?=
 =?utf-8?B?eWlCb1pQZnhtd3kxYnE1WEUzRUF0dFVDVXoxdCtML3RobkZvaWtRU3RWS0Rm?=
 =?utf-8?B?UzhWTW80MllkNXZNY2ZDcXZ3aWhKWEM3U1dIdkhPZUU3SjhNcXVNMHFKcytW?=
 =?utf-8?Q?6FTg=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?d004SUpKbk5hU0Y0TDZSb2dIQ2xQMW4ydmgzWk5hSXZtOWcyQjFJYUl3S2hu?=
 =?utf-8?B?YkV5bnEwV0cvbTJ0Yk8rZkpmQ2FYdGkxcnQ5MjFrN3BNUGI2dzNLelpzM0No?=
 =?utf-8?B?VHhrcGgwcmQwZmpUN29EMnhMOHdYRXVUb09oRjRqQnFCMkFKMUppOFd1aDJl?=
 =?utf-8?B?Ny9OTEdQMW5KS2tLOWxVMllJbi8xWXQvaWdGZUtrQUhuc1lzTFczY01rSEpG?=
 =?utf-8?B?YUpiQVRGNmRjcktYbFJLczc3d0lIVDhGM3lOVEpENUQyQ3dTUUFFM0ZkSVBr?=
 =?utf-8?B?dERxNDhaSzRqVkhTeU51dVBZTllkWmNhdzBocDYrQjdDcSt6ZlZvejR0emIx?=
 =?utf-8?B?cXhaSkxrZDBxRVExVDdzTTVKaUlnZmpERk1vNUpXVkVCSWcxd2xIcjhacGgz?=
 =?utf-8?B?VU52RWVlcEFGWTQ0VE0xby9EZ3ErWmhTL2RvWkw1Q1hEemRhaFhmTXdtM09E?=
 =?utf-8?B?MCt2dy9wWUJyTUx5MUFRUGlrdHNOYTZNTFZhcVFuMWRCYzBtbDVhcW9BVEd0?=
 =?utf-8?B?ZGwrNWJyUEhLTlJzSzNFTkt2NFpHbkNNU3ExM09uOHBSWW4wVDFacWNTOGdt?=
 =?utf-8?B?ZGlmVVZFSjg5NVBLR25YZnBEYXhhTGtqak9Pd2p4dS9MTVZCOWovWEE0Kzl4?=
 =?utf-8?B?cGJOQkMrdi96bGM0R0oxaUR0YlZrbXNqdi9HdHdtZ3hadEhPNGJYeUJoV0ti?=
 =?utf-8?B?OW53MUNnVFE2MEVvTDZBbGNNZUdmb1p3VFlGQzEvRTFYNEdsR251aDJxU1U5?=
 =?utf-8?B?VEFjeEVFaEZzZi80M3h0aW16VnJiNWtKTEFiWWdZR0Q4Mm10K2x1eS8zb0dk?=
 =?utf-8?B?U2hZTzVkNlNYZHc0cjJIQnUzYWV6Qlo4L3dCb2Q1M1RkVWVRNEpzT29Oa3Vq?=
 =?utf-8?B?cFQwZ3RGOUhCM3JzYS90YzkwbW5DL3k4QmppanJ0bllQYlkxc2cyUlY2Nlp4?=
 =?utf-8?B?SVUwVmxiM0UzR0p6LzRoVUpEbjNNSE40MVNwVHpSM0ZKTktXTmdoUzJiS3Rj?=
 =?utf-8?B?TGtrUmFBTDk5WHR6c0V4Z3IxTlB5cE9rUTlCVHM5T1N0MFppeUhVYmtjMktj?=
 =?utf-8?B?RW5LVUhqcm13QWtXSFdxUG5RQkd3U3pMMjNhUlV5N0JiYTZuY2o5ZEx5VzJu?=
 =?utf-8?B?cDlEZkd2STY5a1pUa0NMQ21TbnlMSEJuWlNGdm91UUxNRzE1OVFhVHlKUTJR?=
 =?utf-8?B?anpueVE1a01ZSHpNdFlYZ29NbCtkbEJiYUFLc1h3SGNjZ3ZycGFrV3VVSkNs?=
 =?utf-8?B?WmllbW05UWpQTjYvb3RqR3VIMmJqcHEwNGloNWtnbjZpaVl3cTh1QVZNT1Zj?=
 =?utf-8?B?NTdlbFEybEhBOVNVV2pVNjRpUWtrVmNSTUJuUG5uQmFKOUx2ZFVUai90ZDBi?=
 =?utf-8?B?MWkxeHlkUDl4Q3A5dzZOSnR4dklQaWZDZUJOM2ltWmZCQzhJbDAreWV2bW9Z?=
 =?utf-8?B?MnNIV3RnVjdBWDdzeEYzb25BZXlna0FqSE9GNEdGODNCckl5YUQvKytHMUNu?=
 =?utf-8?B?SUNzUUJBRlVCa0ZsYXl4R0FQbkx4RVlPTFdKd3BHK01HNER1Z3NEaDJVTXVE?=
 =?utf-8?B?MVFELy9EMkpla2M3WDZJN3kwaGM3aC9Qd0QwSWlTSytpQzhwYmhHZldPaWlm?=
 =?utf-8?B?Y2Rzd0ZyeXFSb0plSkxuVXhTWXcvOGNvZkxobkJwMmtNODNHSlNyNVFUTERF?=
 =?utf-8?B?WlM4L0t2T2w0Ny9ldm1odzRaVWFFZXZkbUZiTlZvcEJ1aVdIcUFJQ21WM3hX?=
 =?utf-8?B?RGZOWmRIbDFreGMrRGM4M3owdE9zMHFHb3EwQkVTSUp1cUR0SFNXZlE1a0R6?=
 =?utf-8?B?elV3elA4QmN4SDNHWVgyN2t0UERiWUtjMkdqbVRIYmlNSjhiWmszbDN3Z1p2?=
 =?utf-8?B?Z0ZmQXJCUHVCazZvNVJUZ0tLQzFnbndWb05LUnhsQVRJOC9Zb05qSXhFeXRo?=
 =?utf-8?B?djRMZllpYk4zanl3enU3RUxrYnppbXFtYkxTUFZPRkNDTlk1VkdyYWUxL2pU?=
 =?utf-8?B?cnlSeXpwdnFUdURGSU1DQ2ZnOG5YRW1RNUQ3dHZ2M3JzQzNxYnUvcXV0YTRY?=
 =?utf-8?B?RTVWQjFxUkR0b1AyZVY5LzlsUnM3TjFuNlg0WElESjk1SFlFQVNDMDdOMEtM?=
 =?utf-8?B?THJqeUwrbFYvOTZFMSt5TEdNTXhmL2Z5dDVacG5PRHVjUVdDcUxoNWRmRm9R?=
 =?utf-8?B?TTJsWC9hZThCa1VJejBleE9hUlFoVzFKMFRHTVlFbS8zalFCeG12eFc5dXJp?=
 =?utf-8?B?SXRvalhPS3Z1UDBlUFh4ZlloWEJhMmhMT2dYd29PRkEwak5tNXhTRm9oZVp2?=
 =?utf-8?B?S1ZPZ1d6S280bnprbmxraVpkaHNkMkJmeGZQK3lGZ0ZSMzdkK08vNjhndDZW?=
 =?utf-8?Q?t02FbIulAaMrCFUc=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c695cd8c-daed-4b04-6933-08de68cee3e7
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2026 18:04:53.0748
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YYPYdB0o9wPGAueEJB39UYKmD+io79uA0Xrk6SDzaqxN5kfwp1kjOR8AtXI/sup1EQ9RAs/LxoO3UK9iAKO30q4uLxpHlf2BIASex5g618w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR11MB8990
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70775-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:mid,intel.com:dkim,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns];
	MIME_TRACE(0.00)[0:+];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[46];
	DKIM_TRACE(0.00)[intel.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[reinette.chatre@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: CBC3111E35F
X-Rspamd-Action: no action

+Ben and Drew

On 2/10/26 8:17 AM, Reinette Chatre wrote:
> Hi Babu,
> 
> On 1/28/26 9:44 AM, Moger, Babu wrote:
>>
>>
>> On 1/28/2026 11:41 AM, Moger, Babu wrote:
>>>> On Wed, Jan 28, 2026 at 10:01:39AM -0600, Moger, Babu wrote:
>>>>> On 1/27/2026 4:30 PM, Luck, Tony wrote:
>>>> Babu,
>>>>
>>>> I've read a bit more of the code now and I think I understand more.
>>>>
>>>> Some useful additions to your explanation.
>>>>
>>>> 1) Only one CTRL group can be marked as PLZA
>>>
>>> Yes. Correct.
> 
> Why limit it to one CTRL_MON group and why not support it for MON groups?
> 
> Limiting it to a single CTRL group seems restrictive in a few ways:
> 1) It requires that the "PLZA" group has a dedicated CLOSID. This reduces the
>    number of use cases that can be supported. Consider, for example, an existing
>    "high priority" resource group and a "low priority" resource group. The user may
>    just want to let the tasks in the "low priority" resource group run as "high priority"
>    when in CPL0. This of course may depend on what resources are allocated, for example
>    cache may need more care, but if, for example, user is only interested in memory
>    bandwidth allocation this seems a reasonable use case?
> 2) Similar to what Tony [1] mentioned this does not enable what the hardware is
>    capable of in terms of number of different control groups/CLOSID that can be
>    assigned to MSR_IA32_PQR_PLZA_ASSOC. Why limit PLZA to one CLOSID?
> 3) The feature seems to support RMID in MSR_IA32_PQR_PLZA_ASSOC similar to
>    MSR_IA32_PQR_ASSOC. With this, it should be possible for user space to, for
>    example, create a resource group that contains tasks of interest and create
>    a monitor group within it that monitors all tasks' bandwidth usage when in CPL0.
>    This will give user space better insight into system behavior and from what I can
>    tell is supported by the feature but not enabled?
> 
>>>
>>>> 2) It can't be the root/default group
>>>
>>> This is something I added to keep the default group in a un-disturbed,
> 
> Why was this needed?
> 
>>>
>>>> 3) It can't have sub monitor groups
> 
> Why not?
> 
>>>> 4) It can't be pseudo-locked
>>>
>>> Yes.
>>>
>>>>
>>>> Would a potential use case involve putting *all* tasks into the PLZA group? That
>>>> would avoid any additional context switch overhead as the PLZA MSR would never
>>>> need to change.
>>>
>>> Yes. That can be one use case.
>>>
>>>>
>>>> If that is the case, maybe for the PLZA group we should allow user to
>>>> do:
>>>>
>>>> # echo '*' > tasks
> 
> Dedicating a resource group to "PLZA" seems restrictive while also adding many
> complications since this designation makes resource group behave differently and
> thus the files need to get extra "treatments" to handle this "PLZA" designation.
> 
> I am wondering if it will not be simpler to introduce just one new file, for example
> "tasks_cpl0" in both CTRL_MON and MON groups. When user space writes a task ID to the
> file it "enables" PLZA for this task and that group's CLOSID and RMID is the associated
> task's "PLZA" CLOSID and RMID. This gives user space the flexibility to use the same
> resource group to manage user space and kernel space allocations while also supporting
> various monitoring use cases. This still supports the "dedicate a resource group to PLZA"
> use case where user space can create a new resource group with certain allocations but the
> "tasks" file will be empty and "tasks_cpl0" contains the tasks needing to run with
> the resource group's allocations when in CPL0.

It looks like MPAM has a few more capabilities here and the Arm levels are numbered differently
with EL0 meaning user space. We should thus aim to keep things as generic as possible. For example,
instead of CPL0 using something like "kernel" or ... ?

I have not read anything about the RISC-V side of this yet.

Reinette

> 
> Reinette
> 
> [1] https://lore.kernel.org/lkml/aXpgragcLS2L8ROe@agluck-desk3/


