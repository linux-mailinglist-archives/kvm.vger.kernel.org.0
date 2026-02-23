Return-Path: <kvm+bounces-71500-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6H+/N4mGnGm7IwQAu9opvQ
	(envelope-from <kvm+bounces-71500-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 17:55:37 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 4207817A31E
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 17:55:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4923632C1A9D
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 16:40:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06C2131D372;
	Mon, 23 Feb 2026 16:39:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="e85j/BX7"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFB8531A045;
	Mon, 23 Feb 2026 16:39:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771864749; cv=fail; b=ZHrtbnvmloVC64FHajc+SvSo+yKCEWprnZ1tv5QV+sUhMMQAa3zRQYEFwa/XU5meGbewlCgWVtoMVT8LKM4m9sJmy8VHMSS/7ht77wkIAOnXvz+eftq2dIvJ/JBaE6eGPrL5xbCrP496nPLYi5hUq+URJrxumUoHvw8jR7kmT1o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771864749; c=relaxed/simple;
	bh=J6V0gG6Xgpr468Oq0uQFpgBedrn0FranF3Ue76QUeVc=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=I18nUtBOwpqnlxrNWfZut1k4WWPwYZ1HvSqRPrFAnvCJfqkfdPe2aqPRHYWTR/wKwV6u6RjVPQh1zjyP/sTWgVlzC/5wf3gD7xLeEueyesx2qlMGulScuQX1x6U3rBWc5kJH0SocBiPOacKP5FnNbsauah8bQ0lSe2hexXYO2a8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=e85j/BX7; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1771864748; x=1803400748;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=J6V0gG6Xgpr468Oq0uQFpgBedrn0FranF3Ue76QUeVc=;
  b=e85j/BX7CaSKizQr8CseS1w+1ffVwaXbhLpzEqIEhYNJeGLeHRUs//6c
   tQNNNP/7Zl8/nYGJ/zBmcTUuMtPMztBC1Uc0luqjlRZcaa0yMxcR4epqH
   8jQb5bWFhYtUnWZkKE7emMTQmzF3gDczpJgx7lhSGzPFYHoFBT+cEG5p5
   cD9IMRufaL8Frz+kGMYKMo5IkxBU/g0gS2bQ1NvarXjWo+/WvHq7XWQgT
   5i+QzsHM5yu8w5Qbih7oRnGlJQDWS8XBCujl+b9m1vADuE0g05SE0SRNn
   WoQSAXc6tG0+sKG7GjW488cKAEBbKBO+1PPqMY6Bj3zLlUehxbpKkOFwL
   w==;
X-CSE-ConnectionGUID: BiQ1wC9NQ8++keQNg+wK1w==
X-CSE-MsgGUID: oT4bBnkBQZSF4gUqxQXI2g==
X-IronPort-AV: E=McAfee;i="6800,10657,11710"; a="75473645"
X-IronPort-AV: E=Sophos;i="6.21,307,1763452800"; 
   d="scan'208";a="75473645"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2026 08:39:07 -0800
X-CSE-ConnectionGUID: jNu6ZtbPR+G0a56cQeq1xA==
X-CSE-MsgGUID: Pq8KiaH2QOSkCONNGtB5zQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,307,1763452800"; 
   d="scan'208";a="213952427"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2026 08:39:06 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Mon, 23 Feb 2026 08:39:05 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Mon, 23 Feb 2026 08:39:05 -0800
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.59) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Mon, 23 Feb 2026 08:39:05 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UpdUmdCZ/jk2kvGqiVDIGOzbzUIsvDQCjicY4Mg4GsRHTqucDMkL4xCYsG37CshOXPeLW0bJRAhlIp6KIIaoZhXSNNyr8HrV683Flsp7Vcipz+5l4yHhKPaqQCimRNJpMydUP07QShl68BtKHka+lTrzzzK79/6vrNcc5lr5LYpGoq0HNBqgrmeIYebYCcJbsnxqXr7ZJk+71/OZufouiRrfhZW4ZDgPUa1nNAjee9I8rvUhN157UgkUkPLVI9+tT9caHqzj3B5/JCeEMNFYlcU7kJr4y+ozeYidFrFAFOsVS7qmuSYLHRxWRt/eVTYtRsbTAPVC4xeDJCn68/TTww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9hf8AHeAf2t/3WB+zXCqLDy1RqOr7OoJaQpJ+K8WPdo=;
 b=Q9lOWoDQERFCvhzqPqr7xb/U+bw82gO9uKQJkIRbPwNEBuSdFYPpTQD7TNXQoSdHI78tMHxPpIJQOqhZ/0er0sXSzJfV+bSLTVbIVMFxTkfx0NmMRrdB8TurXhwEpcgWbKM1Sc1FtDoGYo3myKZynS0LC4PjmENvFVMlL8zOIM+npdNoU4rO+GrrWQKsCpP4yIRfuw7sIrcZBbtRwXkh5QWzFJV/mFdFwVT1z8y7nEqy3pWpOnL67Bi/AxMSxlC63JkIVVpY7OspojQ6tg0vKdFu5tZxjIrRnQp9Eo/y06xPOJ0jl/eNsoe5Q03aVewhGmPSXTR4ecui3YFYSHcEZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by CY5PR11MB6342.namprd11.prod.outlook.com (2603:10b6:930:3d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.20; Mon, 23 Feb
 2026 16:39:02 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d%6]) with mapi id 15.20.9632.017; Mon, 23 Feb 2026
 16:39:02 +0000
Message-ID: <9ae7909a-dbb1-4d54-a47c-2ffdb4899b64@intel.com>
Date: Mon, 23 Feb 2026 08:38:57 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 13/19] x86/resctrl: Add PLZA state tracking and
 context switch handling
To: Ben Horgan <ben.horgan@arm.com>, "Luck, Tony" <tony.luck@intel.com>,
	"Moger, Babu" <Babu.Moger@amd.com>, "eranian@google.com" <eranian@google.com>
CC: "Moger, Babu" <bmoger@amd.com>, Drew Fustini <fustini@kernel.org>,
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
 <730c193e-bf31-47a8-8f46-3a4c19b96f77@arm.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <730c193e-bf31-47a8-8f46-3a4c19b96f77@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0215.namprd04.prod.outlook.com
 (2603:10b6:303:87::10) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|CY5PR11MB6342:EE_
X-MS-Office365-Filtering-Correlation-Id: 34c1c67e-f581-4bc3-6983-08de72fa0d20
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024|18082099003;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?cjluVjFDR1RlTGZSNVo4M2NCb2Y0UmRoMnJDcDBXRjVtYUszNHRPK0p5N3dU?=
 =?utf-8?B?WmNmZzVjNDFxWnpBd3ljS1p5b2FFT2FqbWNFR0tXdnZXbE03eUc4c1lCbW0r?=
 =?utf-8?B?NW43NURYRjc5NDg1L1NqUFA4Qzlpek5Gc3RaNVBHemU4VmpqSHFoY2FHNkJL?=
 =?utf-8?B?eFR2VXl4K0ZPbEI2aUMxVVp1ZmxmWWVHQ0xSbGlJR2QzNitDZTFnVWJVVjZD?=
 =?utf-8?B?MEh1blVIakVWYjRlZldMTTBLOFlOSmg3OWhMdS8zN0lUQW9JeFpFcWhRdXhU?=
 =?utf-8?B?ODVWVzlrRUFpNmxDdGZwaDBOTlpVNWVwbFVqd3JvQnFJZXorYmVpSXlXdm4r?=
 =?utf-8?B?VjhqOHFmekZMRzZ2eUNrclJHZEFvdklJeGJidHlJUDJBQ0xoMjNBcW80aVh5?=
 =?utf-8?B?aE1qcEpJZ2swdnNScSsxNzJUc0dzOGczUXpta1VIOTd3OTQ0SW1pN2o4bE9D?=
 =?utf-8?B?MGJsTFFmd2ZLSXZFWTg5K3p4blRDSUhnM1NYeUFUaVc5QmRFeUhLd3VQb0w1?=
 =?utf-8?B?U1BkYWRWNTFZL09wZXAzUEN3M3piS1hPQ2o5K1BrQXYzTXZmUnZscEpFTVcz?=
 =?utf-8?B?ZWVxbnVmK1RoeEdORXo1V29kaWhINGZXUFRjeFRNc2l0clNUUGNwcDNnSk9o?=
 =?utf-8?B?aGFHak9mQVUwbmRqeEtkZEJXV2d6SWhpVFJsWnI0K2F1bnh1MFF1dUNiSTBQ?=
 =?utf-8?B?N2VKeERNQVRiY2tIQ1hDV3JHZ1lVS1gxZlF3OGdIcUtSVjBpdHN5U0NvUTh6?=
 =?utf-8?B?OW1ORUx2NWJOckJ1WXNZejZxM01GTWo2dG0vZitsRmp2YmNFNm1veDV3NXU1?=
 =?utf-8?B?bS9GNHNIU0ZSOGliL1RGN0IzcmpjZTVuYWUvM2FDcWdIOHUyd0ovQnZTZ2sr?=
 =?utf-8?B?ZFc3aFRyWkdVdGZBVitDdGllT3Rpdzg0YkF5LzZXNkRHSHJ4S0Y1bnRNWFlD?=
 =?utf-8?B?bTNKYkoyQmpCRlhGRmF2MkFHVmhVcjErWU9vVlI4VHFOREV3VWJ3UWYvZTla?=
 =?utf-8?B?MXBKVm93djNCeVV1MkdZenZPeFlmLzBVdWpqbTU1U0NBak5PTjZtVEc0cTNN?=
 =?utf-8?B?QThKeWN4bXFGMmUveG1Gbi84a2J2ZkxkbjBMTnAyVHBPL3Y1M0RSd1g1Rldx?=
 =?utf-8?B?Q0MwSTcyT21Ob0phUEg1cXpMYS9Zd3NDMjFyaERKSDkydjEvUVczSzU0ZU1u?=
 =?utf-8?B?SjgyMkpySjR5Qk91NUpNSEdsT3FYZDVuVUppWkFMbWVGMURwRG44Q2dqcWFG?=
 =?utf-8?B?dVlGMkZXR0JLSWFWU2JhZnFpTzcxenhRTzBua1pWN0pJUnJ0SGc1YzUxUVlv?=
 =?utf-8?B?MGMzMnh6L3kyUk5pRlN1LzhOTXdKemYxTEM4YmRIdTJ0MWhSU2srS1pDR29i?=
 =?utf-8?B?OWhPOVA4NWhRUHBsb0pWLzRDVVJ4dGkwMHVIZThqQTVlU2UybTFVUy94b3RX?=
 =?utf-8?B?VVdHUXYrbXBkUi9PVlM5ZjVPS3pmZlUvTU9zK0ZONXo3WFRkTVUyMGc4OUdx?=
 =?utf-8?B?eFZJQ1JFRGdvMjhXTDluUTJrN3R0eFhQdm8reTIwcUxVQWFCbkJwM2ExbThJ?=
 =?utf-8?B?YnBBVGdWTkx5UEsrZXZCR29FYjQ0RUNhNGliNm56RVNlVDFwdTROYUNhOVZ5?=
 =?utf-8?B?VUZiTHpFL0VVblQyQnR1VTV6bXdLc1JBbEdhVXN1THV2ajdqRHVSZFhrSmhn?=
 =?utf-8?B?L05QdkRlbnhnWWZmWnRMNllmaEo1Wm5yWjRuV3hGR1RBaDdaVk9qY2lucS9N?=
 =?utf-8?B?clRnZlhsVmpZQkdzM1pTazA5bExiNkpOWGtCYXdVT2VIQUlxVXpBMXJmdURm?=
 =?utf-8?B?dGRYTG5WSEp1cHNSTlViczg1ZzFOWUhranFVVnRtTHYxNVByTXAxMXd3NXBt?=
 =?utf-8?B?ZDBuRHo2UVZPMENwNUhEbSs5Wk4zQmN2ZFVzYjFVYjVLc1Q4aXR3cDZDU2gv?=
 =?utf-8?B?V3RFYlRvQThBcG1YNEliK1p1aWhSbnJyYTA3WldwM1h3MXFaLzZVL2tiajYz?=
 =?utf-8?B?RGVCZEhCcU9HVS9teExIbjJDMHRPdUpFSkc0dEprNmVDRk1RSkJ4WkNVaHUr?=
 =?utf-8?B?OWVDMUVOUW5qeU96VTFCbGlEOEU3WnJzMC9RU0laNWx0THZWTnJWTUtTTktQ?=
 =?utf-8?Q?8oX3vaDch9+zPGufn0F1q5SEy?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(18082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Z1E0Y2dKdzdOQXBHRGl0RWR4eitMQ2dmSWJadE9TcnZEUk9Wa3BERDYvclRS?=
 =?utf-8?B?YTFRS0F3TFh6KzZ6d0ttbktEYVo3ZWRrVVVNaFJURTFTQ2lDVTVHT3g5cGhW?=
 =?utf-8?B?SDZGZy8wek5hRFFQSTJ5c0hvME9TTzRMN1pWcWJyb1Y2RVllU2xyMTFZSjVK?=
 =?utf-8?B?clExTzg1V1NGMGVWVm8yN01DZDZKZ3hDRStqWXF4eWhFZE9CR09CejNYWjBW?=
 =?utf-8?B?NElLbEdsVUttYVNXcXZWSG5YMVlOT0FhSGdPVk0vdGtoMC9uQktYQ0VHL2Ix?=
 =?utf-8?B?cXZkZjAreTl6TzBpNkJtZzZFWlJFVEJMT085VWREMmdkK0R0V3Z6dUlWVHVF?=
 =?utf-8?B?TklJdys2RXFnQnN0ZW16NGFFNjZFTWtHR3BjU01MT1FjdGUvVmp5RlBiME1q?=
 =?utf-8?B?RVJnMW0vRWkwTDVkcXVqTDhybWFDU1lYZVlGNmJLVDVRVXkwRXhsT3lMS243?=
 =?utf-8?B?ZjA4M0RXWUVLREg4TXRzeC9vRDQ2RmozSldVSXYveEs3eGdBVWFnK3hqQ3Zw?=
 =?utf-8?B?Q1BsQXVEbGpmWFJWTVhzVGRvZ3B4dnE5cHF1TG1mMmxFZ3FPQWFHKzZuZ080?=
 =?utf-8?B?VlBLSTUvUCtpTDkzRUIrMm1PUHZiS21sK2dkWE0rNWk5dlo0dEkvNXdzdSs1?=
 =?utf-8?B?RnVlTzBzVkJLMU10Zy9HWHRuanpFTmI4OTJTOTFTOWRoU2pRRHBNbFcvelk0?=
 =?utf-8?B?R3JnTEhqZEFXbS9PcTMxYzFrS0JxU2dSZDR6K0tSbjFPZU5vcjFaVjFrR1Fy?=
 =?utf-8?B?MDZhVUd1SVFlVFZkWUFYQzV0ZTFYUEpQOUlRZzB2OXcrWUlISjhiVUxUSHBk?=
 =?utf-8?B?N1I4RVl4VGIwcWFjUENzakZRcVhQRjBGSERKZmgrR0hQTWQ0RjJKUlNraXY0?=
 =?utf-8?B?aDlXUjRMMFhQc1hVUzY1STZmb2llVXIzN2xrRTR4eFZuWDlpUFhJM0VZK0xV?=
 =?utf-8?B?dVFZMXZYS1l6Y2VtTTdaSW5BUFhGTkNMOHlYSWJ0ci9nb3ZaZElVT2lZMll0?=
 =?utf-8?B?LzU3UEduU0R3VGRQc214NFk1SmtRMzBUZ3lQMEtacG9XNW96TThhUHBTb0VC?=
 =?utf-8?B?TkJPSWJkQWZnRk9mSkJQVDJDRUJmM1VHVEZiQjRicDI1WEZQQnp3NWtsZkxM?=
 =?utf-8?B?UjdkcENPQThNUWFKWWRGbmhEV3RqSXkveXdPOHcxcHFjMWRKZHFKZDNwQ0VO?=
 =?utf-8?B?aEJRR1RnaHhNWXA2SUNSRDhMVHE0KzBXZUplT1V4K05lS3NQNXFSbnpwUXpN?=
 =?utf-8?B?NjhKV3BsSGpxeklaN0FEdDQ0N0VlNjNLVVRUcms1QkRxNEwrL1RxN1J5Z2RD?=
 =?utf-8?B?NnhoZXdra2E3akx1UjNTQ0NIY0wyOXlpL09oeG5MM1ErTVRmbDh2MmZSdGYr?=
 =?utf-8?B?d0dtaUpaZ3htTUkrbmhXVjhNOGxyOEcyVG1UUlN1cGs0dlQ5OWxmbVlQYkFJ?=
 =?utf-8?B?UUNWSURVTHlvOUUxMnpBbEx4SGorbmtTSmROS3YrU0JiTy9DUmZrZXJmVFVP?=
 =?utf-8?B?NVRBbjArbVkyVWU1SVkxR1ZSWHViSktrQjBhbExlb1RpS01mRFc2RGN4WTd2?=
 =?utf-8?B?TFJtNjdTWFFjWXRQcGFDak9tdTdWSUgvSTdGTkFsTG9KVDhFNHZPSFprZGlO?=
 =?utf-8?B?QmhWRXg3ak85TWlSSXBMZWFRTzQzb3VsZURUaVhUWmxydUtHbXR2Y3lPcUZl?=
 =?utf-8?B?QjE5bzZlTE4yWjR6OU1zeVJCN295RU1RSW14WEVxUFBVT2RCNmkvdDFXbDVH?=
 =?utf-8?B?d0d1ZTNHWWZpWXhNdHB2N2VLaXVua3pXMktuUFFSMERwK0d0Z0MyUmc0NVJZ?=
 =?utf-8?B?dTYyZmNQS3dGT3NCRDgvREtHaTNpSXFrTWFCTFNDZEg3WXFGckdldVdJbDV4?=
 =?utf-8?B?RU9yTDZmRkVaWjFoSkFoK2NWOWxrU1k1MktFV1ZuQW5nYUZtSG95b3pRVVNG?=
 =?utf-8?B?MWViNHZoVlM2WVpCUUVsUW84YXNiam94OE9ER3Z5Y0VpenZYY2tyUTNIcGVS?=
 =?utf-8?B?Nlk3bWZncW02RXJIa3BLYmJLd2dsc2x6MklKb2dTdkVqRWxwWWh1OGMwTWxs?=
 =?utf-8?B?azJuc2R4RXRUVkVnNHg5ZmRwczRPc3pJNHh5ZlQzRis0UFoxNUxYV281VEto?=
 =?utf-8?B?SjBTRlUyY1dESWhrdXg0YjBiN3hrVEptRndXZXZpRmdwamV4eEJSR3NjdEgr?=
 =?utf-8?B?Y2RkdVNGTHY2VWlkdmp5MFJaZW9neWw2aTFrS3o3MHFSQjExUUNCWDl6c0NC?=
 =?utf-8?B?YjY3eXRCSlBpcUlVcTNmSE80a242c3I3RjdCYlhFUmY3bkxXaGdVbVpncXg2?=
 =?utf-8?B?aThlQ285Tm0ydCt3OWptRWdDVjdIQkFwTk9paTlUMVY0aTRTOStBdmZrcDY4?=
 =?utf-8?Q?EBOhMvat7SmjIEjU=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 34c1c67e-f581-4bc3-6983-08de72fa0d20
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2026 16:39:02.1999
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ls2jXLoxRqBTxgwS6yflTen45iKT/NlPYSLeGK4MsVJBDmQkTAcXH3ZcsfSDjSk7pvN1NpRlTgrKqUU1ndkNQkFGEFHyzDTxDUvNSQPJpWU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6342
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71500-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,intel.com:mid,intel.com:dkim];
	MIME_TRACE(0.00)[0:+];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[46];
	DKIM_TRACE(0.00)[intel.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
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
X-Rspamd-Queue-Id: 4207817A31E
X-Rspamd-Action: no action

Hi Ben,

On 2/23/26 2:08 AM, Ben Horgan wrote:
> On 2/20/26 02:53, Reinette Chatre wrote:

...

>> Dedicated global allocations for kernel work, monitoring same for user space and kernel (MPAM)
>> ----------------------------------------------------------------------------------------------
>> 1. User space creates resource and monitoring groups for user tasks:
>>  	/sys/fs/resctrl <= User space default allocations
>> 	/sys/fs/resctrl/g1 <= User space allocations g1
>> 	/sys/fs/resctrl/g1/mon_groups/g1m1 <= User space monitoring group g1m1
>> 	/sys/fs/resctrl/g1/mon_groups/g1m2 <= User space monitoring group g1m2
>> 	/sys/fs/resctrl/g2 <= User space allocations g2
>> 	/sys/fs/resctrl/g2/mon_groups/g2m1 <= User space monitoring group g2m1
>> 	/sys/fs/resctrl/g2/mon_groups/g2m2 <= User space monitoring group g2m2
>>
>> 2. User space creates resource and monitoring groups for kernel work (system has two PMG):
>> 	/sys/fs/resctrl/kernel <= Kernel space allocations 
>> 	/sys/fs/resctrl/kernel/mon_data               <= Kernel space monitoring for all of default and g1
>> 	/sys/fs/resctrl/kernel/mon_groups/kernel_g2   <= Kernel space monitoring for all of g2
>> 3. Set kernel mode to per_group_assign_ctrl_assign_mon:
>> 	# echo per_group_assign_ctrl_assign_mon > info/kernel_mode
>>    - info/kernel_mode_assignment becomes visible and contains
>> 	# cat info/kernel_mode_assignment
>> 	//://
>> 	g1//://
>> 	g1/g1m1/://
>> 	g1/g1m2/://
>> 	g2//://
>> 	g2/g2m1/://
>> 	g2/g2m2/://
>>    - An optimization here may be to have the change to per_group_assign_ctrl_assign_mon mode be implemented
>>      similar to the change to global_assign_ctrl_assign_mon that initializes a global default. This can
>>      avoid keeping tasklist_lock for a long time to set all tasks' kernel CLOSID/RMID to default just for
>>      user space to likely change it.
>> 4. Set groups to be used for kernel work:
>> 	# echo '//:kernel//\ng1//:kernel//\ng1/g1m1/:kernel//\ng1/g1m2/:kernel//\ng2//:kernel/kernel_g2/\ng2/g2m1/:kernel/kernel_g2/\ng2/g2m2/:kernel/kernel_g2/\n' > info/kernel_mode_assignment
> 
> Am I right in thinking that you want this in the info directory to avoid
> adding files to the CTRL_MON/MON groups?

I see this file as providing the same capability as you suggested in
https://lore.kernel.org/lkml/aYyxAPdTFejzsE42@e134344.arm.com/. The reason why I
presented this as a single file is not because I am trying to avoid adding
files to the CTRL_MON/MON groups but because I believe such interface enables
resctrl to have more flexibility and support more scenarios for optimization.

As you mentioned in your proposal the solution enables a single write to move
a task. As I thought through what resctrl needs to do on such write I saw a lot
of similarities with mongrp_reparent() that loops through all the tasks via
for_each_process_thread() while holding tasklist_lock. Issues with mongrp_reparent()
holding tasklist_lock for a long time are described in [1].

While the single file does not avoid taking tasklist_lock it does give the user the
ability to set kernel group for multiple user groups with a single write.  When user space
does so I believe it is possible for resctrl to have an optimization that takes tasklist_lock
just once and make changes to tasks belonging to all groups while looping through all tasks on
system just once. With files within the CTRL_MON/MON groups setting kernel group for
multiple user groups will require multiple writes from user space where each write requires
looping through tasks while holding tasklist_lock during each loop. From what I learned
from [1] something like this can be very disruptive to the rest of the system.

In summary, I see having this single file provide the same capability as the
on-file-per-CTRL_MON/MON group since user can choose to set kernel group for user
group one at a time but it also gives more flexibility to resctrl for optimization.

Nothing is set in stone here. There is still flexibility in this proposal to support
PARTID and PMG assignment with a single file in each CTRL_MON/MON group if we find that
it has the more benefits. resctrl can still expose a "per_group_assign_ctrl_assign_mon" mode
but instead of making  "info/kernel_mode_assignment" visible when it is enabled the control file
in CTRL_MON/MON groups are made visible ... even in this case resctrl could still add the single
file later if deemed necessary at that time.

Considering all this, do you think resctrl should rather start with a file in each
CTRL_MON/MON group?

Reinette

[1] https://lore.kernel.org/lkml/CALPaoCh0SbG1+VbbgcxjubE7Cc2Pb6QqhG3NH6X=WwsNfqNjtA@mail.gmail.com/ 

