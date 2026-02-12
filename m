Return-Path: <kvm+bounces-70900-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uLk6ME9OjWmn0wAAu9opvQ
	(envelope-from <kvm+bounces-70900-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 04:51:43 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id ECAF612A3CD
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 04:51:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 21F70300E18C
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 03:51:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9026B22127E;
	Thu, 12 Feb 2026 03:51:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nNj2huMU"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30FBE150997;
	Thu, 12 Feb 2026 03:51:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770868291; cv=fail; b=E/wztFB+Z+6/U898dnwE8iUtqm12BpxlN8VM3C16ZISUCtj3xy+PhKaKRVC6B8B7vit3LOGerPCxCFrljb4Ou30Yt191QjzdUGhE3F++WZxA58HEEH0GoPStoJm5A31l3jBYtmMLQuIDa34QmuZRf9yxe0o0cq2GAAGnBQxaayU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770868291; c=relaxed/simple;
	bh=PGJMJQ1uoM3Of7WAUr9TPF9fGu3G1Uk1uQDkhW5dzyQ=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=b60BIYnZuSbyCgyY1rcTgqyS7bxGnQ/lPMkb727aqpEfpE5Sk1DP343mncaxijUFAg5Bx3nn/Y/higIhjMKq7uStDkmsV2wrMkH+AB/b3lQCtZWQgYRnfoW7s70KKV6wlrTrKVjJSK2MxAL17rd0jUXx64HK2AIYxOFeQh+xO9Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nNj2huMU; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770868290; x=1802404290;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=PGJMJQ1uoM3Of7WAUr9TPF9fGu3G1Uk1uQDkhW5dzyQ=;
  b=nNj2huMUVm5Xa5DTmxq7X53Q0bd4v3Vqwspcmq3LHf6ibg38gIgBYBYe
   G6OaxqTlG/13J7QiXmY8yluYqcoyEc0FMFJcRp2k300Y1kjr4CCqjDSST
   dqxkbfT1r7gvq6b3Bnd5EkPDF+jYgLxMCMTN+7moXYMx4FpyCLL/DUdUZ
   /UhwDAMz8TBZbIIj7tkFZ095nZcPLdJRYS+hkAyvb36nyp8vqRW6045VR
   tpxIZGdWFmZKz8BmgDYsyFKuA/SDNAUJnG/kBCScyKIQ3QCagn+hzsftm
   93RvgpMqrd2xPLTU49H5HvI+80XtxP60VEO+2JNWjDtQsey9y/3I6M+le
   A==;
X-CSE-ConnectionGUID: GP5H/IiAT1e3d4bVhYzSJQ==
X-CSE-MsgGUID: 3tZfbcEwROu3Ss0W3kIszQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11698"; a="71936201"
X-IronPort-AV: E=Sophos;i="6.21,286,1763452800"; 
   d="scan'208";a="71936201"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Feb 2026 19:51:29 -0800
X-CSE-ConnectionGUID: 6hHPwBDNQZyQHlJK6Icxaw==
X-CSE-MsgGUID: AtQT/SCoQhqaK8miUvcOfw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,286,1763452800"; 
   d="scan'208";a="250127992"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Feb 2026 19:51:29 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Wed, 11 Feb 2026 19:51:28 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Wed, 11 Feb 2026 19:51:28 -0800
Received: from CO1PR03CU002.outbound.protection.outlook.com (52.101.46.27) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Wed, 11 Feb 2026 19:51:28 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gcAJFAugqyA3WFsY50Dwznbx94UqaZnuZVq8FjNuMyH9X/184RgO0MHSHUWT768vkI0GxfyJ9OcaKEXhT0DZJpYPeM+z0K+3wPy/VQtVo3YKT/QYCDaSXEu483MsfVUmVFPrsuZgGrLPrTJAryS8F5getJ3q4zeEW6py/12v/KjE3Gr7AQJyHC0WlA88rYHju5eJZDjByU0qMTsOJDkU/gt7gYViM7QK0Xqx1rSh7i7XuGsnLK826S16zhcQwWIvngjG8jH2ybANCMGGFdMqriwgVg+T/QzMQfMCaIGHyt1fvFPmNpg/qQoxSIxAxVBOlPmg5pia7MKrMs4oOBFn2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/Y7g1B5UBssD0HJx82s0sv7KCXOuiqPSvJUTp5aXdeg=;
 b=EwSljMmYJ9rS2h7MWcRiLyQjIgPahutHv4y4YPv4LcT5i8XzarOQdEQlYRTuRBijWMJeD2EKvE1bb2iWJsATIXXsEW4BxrE6c2zt/hPuKgoscwBetJUcBFJuHVVs4F7vKv9ve89g5L3dP9legjNKumxon+X+5zq2vn5QUf9R/F6D0dfWdsAp/6hag2Qw2RbYJ495oJ+RPmP5bcdFmbuGVZOR6IVqrl5Oqy+bkMvgLUVnQyhRlrdTtiSoovhfNh53rw+NkmYdu25uoBhFdqjkiHvjCFvYyuQtqebCZJUg/zFafs85AX4sugaj0V0kVUnmQzCzlGOhG6TED3Nqmc+Y3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by BL3PR11MB6339.namprd11.prod.outlook.com (2603:10b6:208:3b3::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.11; Thu, 12 Feb
 2026 03:51:24 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d%6]) with mapi id 15.20.9587.017; Thu, 12 Feb 2026
 03:51:24 +0000
Message-ID: <06a237bd-c370-4d3f-99de-124e8c50e711@intel.com>
Date: Wed, 11 Feb 2026 19:51:17 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 01/19] x86,fs/resctrl: Add support for Global
 Bandwidth Enforcement (GLBE)
To: Babu Moger <babu.moger@amd.com>, "Moger, Babu" <bmoger@amd.com>,
	<corbet@lwn.net>, <tony.luck@intel.com>, <Dave.Martin@arm.com>,
	<james.morse@arm.com>, <tglx@kernel.org>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>
CC: <x86@kernel.org>, <hpa@zytor.com>, <peterz@infradead.org>,
	<juri.lelli@redhat.com>, <vincent.guittot@linaro.org>,
	<dietmar.eggemann@arm.com>, <rostedt@goodmis.org>, <bsegall@google.com>,
	<mgorman@suse.de>, <vschneid@redhat.com>, <akpm@linux-foundation.org>,
	<pawan.kumar.gupta@linux.intel.com>, <pmladek@suse.com>,
	<feng.tang@linux.alibaba.com>, <kees@kernel.org>, <arnd@arndb.de>,
	<fvdl@google.com>, <lirongqing@baidu.com>, <bhelgaas@google.com>,
	<seanjc@google.com>, <xin@zytor.com>, <manali.shukla@amd.com>,
	<dapeng1.mi@linux.intel.com>, <chang.seok.bae@intel.com>,
	<mario.limonciello@amd.com>, <naveen@kernel.org>,
	<elena.reshetova@intel.com>, <thomas.lendacky@amd.com>,
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>, <peternewman@google.com>, <eranian@google.com>,
	<gautham.shenoy@amd.com>
References: <cover.1769029977.git.babu.moger@amd.com>
 <aba70a013c12383d53104de0b19cfbf87690c0c3.1769029977.git.babu.moger@amd.com>
 <eb4b7b12-7674-4a1e-925d-2cec8c3f43d2@intel.com>
 <f0f2e3eb-0fdb-4498-9eb8-73111b1c5a84@amd.com>
 <9b02dfc6-b97c-4695-b765-8cb34a617efb@intel.com>
 <3a7c17c0-bb51-4aad-a705-d8d1853ea68a@amd.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <3a7c17c0-bb51-4aad-a705-d8d1853ea68a@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MW4PR03CA0332.namprd03.prod.outlook.com
 (2603:10b6:303:dc::7) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|BL3PR11MB6339:EE_
X-MS-Office365-Filtering-Correlation-Id: fe20e843-dc43-4fcd-aa0a-08de69e9fe0e
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?MEZ5LzNlTENWcXBISkdzR0NyemxseHNsY2o0UEw4c1puV0NaQXVzSjZQTWMv?=
 =?utf-8?B?U2tRRHpZYjlJVk5hZUp0N0paUmo0aDNmUjdTS2RNNjZORkIzYUxsaThEampB?=
 =?utf-8?B?MUNoWUVnenVMU0hIRGZKSS9PTTNJSGpmSitLNnlZd0lmd3FiQkZMVTFQSmlT?=
 =?utf-8?B?cUpPaFluUEJyN2txNEFDT2RWdlVRSlBUYWxxbWRUZU5ueHJKT0hYMHFvQWVh?=
 =?utf-8?B?U2N6R0N2cDZ1Q2NiZE5UbWVPK3RrWThqMG9zMUtXNVEzZE5Uc25NZUJXSmNL?=
 =?utf-8?B?MjB4WWVuOFNzcFRYT3BYekFFQzRkQm5QV1U0SGNJTWxrUWwxTnYrZkJBbE1F?=
 =?utf-8?B?VlVPRVp1cHk5dDAvaWNNYWdya050RUpab3FYYkM1Nm5IcVVBaUFoSXFZMk0x?=
 =?utf-8?B?VC9McG5jLzRXL1BJUE5PNUp4R3hBSWYxaCs1M0VCeWV1eDVqQlhMYzB5cXBm?=
 =?utf-8?B?SzVZRlJUU0pQTndZMTE0cmFjOWU5aUowRFpXRm1mcHhaWEV5T1Y3cFErQzhK?=
 =?utf-8?B?STQvN1BZc2lHb1RMODkvbzRLWXBQNWFQM3RQcVJvVWxoakNCTW15Mkl6eUlK?=
 =?utf-8?B?K0Vrd05OTjFCN0pCUXdOdGhsdklNVnBnRFZWQ3E2RWI2MlJsVUhCZEU0bzY1?=
 =?utf-8?B?N2NrVStvR2V1T1AvbW1DUXJJVkVYT3lwaWxRSWk5WitVQjhGZHNIZ1E4L2Fr?=
 =?utf-8?B?dWlGTjJQcHFybmhBVWEvS3daWHpJVTNlbkRFYUxIRkdYaWsxQitUbnlMWXNw?=
 =?utf-8?B?b3hveXlVcnNGeklQUlNCQWFXZHpYN29EN2JWTzNBUDNLaTdWVlUycURadzcw?=
 =?utf-8?B?OTZVQzJCeTNkSEFqcFNNeGZnWVM1cmEzV25hNjJCQTkwc04ydVZkUXVGbmZC?=
 =?utf-8?B?L3hHRnpvbzZMOVhCUm1hcXkvSGFYamkyME1Ka3NGalgyVVk3RWdHUW15RjFJ?=
 =?utf-8?B?d09SMFgwRGg2eHVCREVMelJBeEhlMTNKNFM1RjNYaVVwRzdaZlQ3QkV5WFB2?=
 =?utf-8?B?cjRTanBTb29KcTc2aHNIYm9pVm80L0pLRmR0V3d4R0dJT254NlBqZHl3L1l3?=
 =?utf-8?B?R3locll6cUxRNzNPbkczSUw5Y2dhQ2lnNHZoWVJKd2JYd2hVWU5sRzQrWWg3?=
 =?utf-8?B?OW94ejBvaitCVTdtbE9RMllSdnA1TitHa2dUbnBwVzIzNmJSdWxESFNvNUN2?=
 =?utf-8?B?UjdPNDBpR0QyVkhwVkhXbUpTdEtRN21GZnVaVHlkdVFVQVlJdmdFVFNSVzJX?=
 =?utf-8?B?RlQ0Y3RMQ0dUY3lkTkUxRnA0U1A3WGMvMGxhT1JzK3F1K0p3N21JSkt1bXFx?=
 =?utf-8?B?bVZOZ3RXOURoODF1NWRqNjJLYmlKRlFNc2NtZGRjZCsvWG5CNHpGUjlpb0wy?=
 =?utf-8?B?ckhtMWRhNmJKTWhQSnorS1R3T1ByWFd2ZURXelRzRWVqeVhCT2Q2OTBEZFIw?=
 =?utf-8?B?OHJGOGVSNS9ydFI0RkR6OGhySDdYK0U4aWt0cjhqd1pjZ0tpbG9BYVpwR2lX?=
 =?utf-8?B?Y3E3Y2E1UWFqcnNlRGd5OWZzbC84NDRYVWQvcHRIY3FuQ2ZGaHU1MWFWZWpZ?=
 =?utf-8?B?Z1pqU0YwdWtRME9PbG1TRGdScXBBV1dreGUzUHBwRGpqMDEyZ2t4c0lzaE9s?=
 =?utf-8?B?ZTdERWFjZVdqRHhwRnRqdWNHRk5HcWZPYU54YTVzNUJCc2loUVZnRGFvTmVv?=
 =?utf-8?B?S0JsdmhUSW15RmdmZmx5ZnVmbE96NStMazRNRHZiUCtrci9wWlUyOG1UZHg2?=
 =?utf-8?B?Y2dZMEtuUXdseUlYYTVJTHYwNmtOMmdYTFdFaWQvQUFpR2dYSVBQMUNKNDVE?=
 =?utf-8?B?QnZJdEhvRktRRTNnY0JFWHZ5a0JyNTFFTjJGMWpwd1BkNFdjZFRvWWIzckht?=
 =?utf-8?B?KzF5WlEzREdFYWNsY1ZlcWlhdkFsZkdrZDNUMHhnUUYrcGM3MU5XVjFQOUhV?=
 =?utf-8?B?ZHpRL0EvZHRtY3hKY2VuZll6NGhXMStxZERvUEdzOFJ1ZEYxMmY2MFFjbGRZ?=
 =?utf-8?B?V3VQaHV6Z1ZnNmVTQUZsU3lRdHA5WTJ0LzNKbnczbkw0M09KY2cwWkNVNlUz?=
 =?utf-8?B?Y1lGSXB1OFNhNUlDWFdJN0lHWndWSVZTM3VYbktpaThoN285QitOanJZTTFj?=
 =?utf-8?Q?5FL2j4QhNa9Tep/uarNSs1KZR?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?K1hqY1dieWpkQ091UUlEVEhSNmhzaEdrbWpiTDhENkM4RHN2bVMxUVJiSG95?=
 =?utf-8?B?Y3hvVTBvMlZyZ1dLdDA2eGh3enRNeCtac3Yrb2ViRXV3RkpRcW1ZTzFHNFRL?=
 =?utf-8?B?a0t5RFNuSkZOS1FLcTl0RU1nZnVzVjkwcFpJSHdCeWZLMC95bHI3SDNoeVhY?=
 =?utf-8?B?QTlsbVI0eDlkUElzZU4xRWxpV1hLSGIxTVdNZ29NUCtBMnNwV0lwdFFrMkEx?=
 =?utf-8?B?UnU4bHJVMVZPWG91dXZTbEVkOFJXc1BUR2lhV3BRaGtxMmNhSURZMUhja2Yv?=
 =?utf-8?B?WkFJQTlSLzVoSzZ2MVR4QjRmL1JXbmM4NlhtaXhwY0tJZThLYkV3ZmlGOTNa?=
 =?utf-8?B?ZkdZWW9SdUtLbm1DMDF6b0FjQks5cUJjY2FGSUdjVkx0dTg1VWxIdEpmK2Ja?=
 =?utf-8?B?ZkQwekZRR2tSdVZWZm5QaUZqVFZrRlhidE10ZENnNkxpY0IxWE1aUVZLL1ZB?=
 =?utf-8?B?eUN5dWNEKzEra3RDd09hOVB5WFRUbmdIZTJKVWU0N0RpMExoeUdKSW02cXU2?=
 =?utf-8?B?L09MMjFaNDV3a0REaHpnOVBSZWFkT0Q4UHg1cWFUUjZLNUVsUWJkWlhoSXBU?=
 =?utf-8?B?WlFZTjIvUmhXYUx4eUdtMG52Smc0dFBIZUxiUW1YVHF4N3loSGRpcWkyNkZl?=
 =?utf-8?B?T3dBWFJRWlpCdVhONFRSYmF1RTBVeG50SG5DTlVhOEhCWHFZNXhWMWlmS0k1?=
 =?utf-8?B?QUlpQ2VpbzB5a0xoRy81eS9BOXQrSkthNHZhRW5MZk1WelpBNzdpekowS3hn?=
 =?utf-8?B?elB0M1VqUUJXZXd0Y0Q2SEZKZ2htd0FTczA0LzVYOTBGTDVoWU9ua0cxNVB4?=
 =?utf-8?B?WXljMEFDME9FMzNIanM5YjlhSXVxM3R2eFA1S2drb2lSWW42eFZNRHNyZjJY?=
 =?utf-8?B?TlFtZkRySWxsYWJJMXBLS3BXZk5TRm5qanVkbXlQcUkwLzd4dEpnUFJVcXQ0?=
 =?utf-8?B?WEpoTitQU0hST1o2azQxS2V6L2l4dDc2RFBNQzJITG1tMGZiU2dvekM5b2N0?=
 =?utf-8?B?aUlhaEN4NDhkbUYydXcrekoybmw2K21xSmlKVnh6UXZ2MWYzY3B2NzRMd0hp?=
 =?utf-8?B?VThuNndydmRqLzFBVjUvSzVsSHRSamtiS3Zoci9BcVZsQmtEakhCUTJMVy9x?=
 =?utf-8?B?SVFMc3dlU3lJZ3J5UXNDUDB4Rlg1UFp5VWdyK2hhakdoQXJCVExYNENHTGpO?=
 =?utf-8?B?dEczY0FhNFhPV21GOGVjZWY3TkJ5b1VLbGJmaDdxcjh6NEFwZ2QwQ0VKc2ZY?=
 =?utf-8?B?R3RSbjJLUFZSQTRtZityVWtONGVrWXhHVjRXN2FUVkJ4U2tFYjk1ZTFrZ2p6?=
 =?utf-8?B?VmRjV1NJSUZSY1pzOUI3bXA3WHFObkV6QU5HRFp6SmhYc0MvTDFBVVFqRndF?=
 =?utf-8?B?dHloMnd3dnIxMGJ6RUMva3NpaUkwRk5TZTFPRWNoQkE2MUVCU1E5YWsrYlBh?=
 =?utf-8?B?TjFvMklwNG5vNTFlcUNrZ3JLK2Y1MUFRelY0aU1hTnpxQ1RtUnNMdXJPNi9v?=
 =?utf-8?B?WXJES3ZLd2RBa1RtNUFpN1ZwU3RvWUZyTnFTVkU1QWpzcExuUEY5a0srVDFy?=
 =?utf-8?B?WUo2Y3JocFg0UHNUSUNQNlpYU1l5MXFGM1AzZ1p6YUx3cHBaN1JSbWNKbTNs?=
 =?utf-8?B?WjRyYWZSeFVFaHpMM1RqM2kwUWdzUHlIVlgrVlJyVDRSZkF4aGJINWczMWdF?=
 =?utf-8?B?cEtHMlgrN2FGTjZna2VlUDMyaFBpdUlaUGpjVUFyQ2V1UlNzRXJIMk81ajFz?=
 =?utf-8?B?M1UzeGM0YnRrUW9uNE15M2hoN1ZJSDNwL282alFpQVdoa0ZyaDZRUm1ENHBM?=
 =?utf-8?B?TjY3dTk5K0czVjFJR1VLcUszNFJtbmF5cFRYTDM4ZjR4RTdwZTEweWVYbVov?=
 =?utf-8?B?clI2MERPN1NGcWJlUTE1eFNKcTgvb29DME1BOVhlRGdhK0dpbkVHT1ZaN29i?=
 =?utf-8?B?eEt0UnZWR3RTUGtiZDBqU3dQL0dvNTBXTWUxdUpMWTJwbFIvTWdyc2Jha05j?=
 =?utf-8?B?U3lFSFNSdEN6b0xjSVVLNFo3Y09ZMHJiRkM5cWZCU3YxUFp0RFRWLzh0R0w0?=
 =?utf-8?B?TUtVRjRDSUI1T08vZElReTNwYS96M0NoazNGN3ZoeVlSdFltSE9pczZxMXhq?=
 =?utf-8?B?aU1WTVUwWFJFNWZFK3pSNHNRZlJRa3FING9WRVpTbW5tV1RrblY0cUo0eXpZ?=
 =?utf-8?B?Z3B5TVdCSTA0TGJEdWVMbERUUDZ2Ly9PZWRicU9GUDNrN3dZWlNPZmdtZFJz?=
 =?utf-8?B?OEFYZUhnOTE0dHIzd0J0MVE1UFl2VGVVMGJCU1lqejdMVlNYRGJGbnovT0dY?=
 =?utf-8?B?UXc3UEJWWVY4dEtFMDFmcUVDTEFRWEFIYU9waFR3QkhtcHBXak01QUMwbDRZ?=
 =?utf-8?Q?054k2OqwNZpzCquk=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fe20e843-dc43-4fcd-aa0a-08de69e9fe0e
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Feb 2026 03:51:24.5052
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cl2BjfTKZUUefBT1ZqD7GUIBYbvIX7A5MaZPuHnKQ1WEuB9pbT9zCDnJu6tJsOg2uewmPi5SJeNlV50reTlPh2tilKd8Ns2hXtpfsr27gvQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB6339
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[44];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	RCVD_COUNT_SEVEN(0.00)[10];
	MID_RHS_MATCH_FROM(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[reinette.chatre@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns];
	PRECEDENCE_BULK(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70900-lists,kvm=lfdr.de];
	DKIM_TRACE(0.00)[intel.com:+]
X-Rspamd-Queue-Id: ECAF612A3CD
X-Rspamd-Action: no action

Hi Babu,

On 2/11/26 1:18 PM, Babu Moger wrote:
> On 2/11/26 10:54, Reinette Chatre wrote:
>> On 2/10/26 5:07 PM, Moger, Babu wrote:
>>> On 2/9/2026 12:44 PM, Reinette Chatre wrote:
>>>> On 1/21/26 1:12 PM, Babu Moger wrote:
>>>>> On AMD systems, the existing MBA feature allows the user to set a bandwidth
>>>>> limit for each QOS domain. However, multiple QOS domains share system
>>>>> memory bandwidth as a resource. In order to ensure that system memory
>>>>> bandwidth is not over-utilized, user must statically partition the
>>>>> available system bandwidth between the active QOS domains. This typically
>>>> How do you define "active" QoS Domain?
>>> Some domains may not have any CPUs associated with that CLOSID. Active meant, I'm referring to domains that have CPUs assigned to the CLOSID.
>> To confirm, is this then specific to assigning CPUs to resource groups via
>> the cpus/cpus_list files? This refers to how a user needs to partition
>> available bandwidth so I am still trying to understand the message here since
>> users still need to do this even when CPUs are not assigned to resource
>> groups.
>>
> It is not specific to CPU assignment. It applies to task assignment also.
>  
> For example:  We have 4 domains;
> 
> # cat schemata
>   MB:0=8192;1=8192;2=8192;3=8192
> 
> If this group has the CPUs assigned to only first two domains. Then the group has only two active domains. Then we will only update the first two domains. The MB values in other domains does not matter.

I see, thank you. As I understand an "active QoS domain" is something only user
space can designate. It may be possible for resctrl to get a sense of which QoS domains
are "active" when only CPUs are assigned to a resource group but when it comes to task
assignment it is user space that controls where tasks belonging to a group can be
scheduled and thus which QoS domains are "active" or not. 

> 
> #echo "MB:0=8;1=8" > schemata
> 
> # cat schemata
>   MB:0=8;1=8;2=8192;3=8192
> 
> The combined bandwidth can go up to 16(8+8) units. Each unit is 1/8 GB.
> 
> With GMBA, we can set the combined limit higher level and total bandwidth will not exceed GMBA limit.

Thank you for the confirmation.

> 
>>>>> results in system memory being under-utilized since not all QOS domains are
>>>>> using their full bandwidth Allocation.
>>>>>
>>>>> AMD PQoS Global Bandwidth Enforcement(GLBE) provides a mechanism
>>>>> for software to specify bandwidth limits for groups of threads that span
>>>>> multiple QoS Domains. This collection of QOS domains is referred to as GLBE
>>>>> control domain. The GLBE ceiling sets a maximum limit on a memory bandwidth
>>>>> in GLBE control domain. Bandwidth is shared by all threads in a Class of
>>>>> Service(COS) across every QoS domain managed by the GLBE control domain.
>>>> How does this bandwidth allocation limit impact existing MBA? For example, if a
>>>> system has two domains (A and B) that user space separately sets MBA
>>>> allocations for while also placing both domains within a "GLBE control domain"
>>>> with a different allocation, does the individual MBA allocations still matter?
>>> Yes. Both ceilings are enforced at their respective levels.
>>> The MBA ceiling is applied at the QoS domain level.
>>> The GLBE ceiling is applied at the GLBE control  domain level.
>>> If the MBA ceiling exceeds the GLBE ceiling, the effective MBA limit will be capped by the GLBE ceiling.
>> It sounds as though MBA and GMBA/GLBE operates within the same parameters wrt
>> the limits but in examples in this series they have different limits. For example,
>> in the documentation patch [1] there is this:
>>
>>   # cat schemata
>>      GMB:0=2048;1=2048;2=2048;3=2048
>>      MB:0=4096;1=4096;2=4096;3=4096
>>      L3:0=ffff;1=ffff;2=ffff;3=ffff
>>
>> followed up with what it will look like in new generation [2]:
>>
>>     GMB:0=4096;1=4096;2=4096;3=4096
>>      MB:0=8192;1=8192;2=8192;3=8192
>>       L3:0=ffff;1=ffff;2=ffff;3=ffff
>>
>> In both examples the per-domain MB ceiling is higher than the global GMB ceiling. With
>> above showing defaults and you state "If the MBA ceiling exceeds the GLBE ceiling,
>> the effective MBA limit will be capped by the GLBE ceiling." - does this mean that
>> MB ceiling can never be higher than GMB ceiling as shown in the examples?
> 
> That is correct.  There is one more information here.   The MB unit is in 1/8 GB and GMB unit is 1GB.  I have added that in documentation in patch 4.

ah - right. I did not take the different units into account.

> 
> The GMB limit defaults to max value 4096 (bit 12 set) when the new group is created.  Meaning GMB limit does not apply by default.
> 
> When setting the limits, it should be set to same value in all the domains in GMB control domain.  Having different value in each domain results in unexpected behavior.
> 
>>
>> Another question, when setting aside possible differences between MB and GMB.
>>
>> I am trying to understand how user may expect to interact with these interfaces ...
>>
>> Consider the starting state example as below where the MB and GMB ceilings are the
>> same:
>>
>>    # cat schemata
>>    GMB:0=2048;1=2048;2=2048;3=2048
>>    MB:0=2048;1=2048;2=2048;3=2048
>>
>> Would something like below be accurate? Specifically, showing how the GMB limit impacts the
>> MB limit:
>>       # echo "GMB:0=8;2=8" > schemata
>>    # cat schemata
>>    GMB:0=8;1=2048;2=8;3=2048
>>    MB:0=8;1=2048;2=8;3=2048
> 
> Yes. That is correct.  It will cap the MB setting to  8.   Note that we are talking about unit differences to make it simple.

Thank you for confirming.

> 
> 
>> ... and then when user space resets GMB the MB can reset like ...
>>
>>    # echo "GMB:0=2048;2=2048" > schemata
>>    # cat schemata
>>    GMB:0=2048;1=2048;2=2048;3=2048
>>    MB:0=2048;1=2048;2=2048;3=2048
>>
>> if I understand correctly this will only apply if the MB limit was never set so
>> another scenario may be to keep a previous MB setting after a GMB change:
>>
>>    # cat schemata
>>    GMB:0=2048;1=2048;2=2048;3=2048
>>    MB:0=8;1=2048;2=8;3=2048
>>
>>    # echo "GMB:0=8;2=8" > schemata
>>    # cat schemata
>>    GMB:0=8;1=2048;2=8;3=2048
>>    MB:0=8;1=2048;2=8;3=2048
>>
>>    # echo "GMB:0=2048;2=2048" > schemata
>>    # cat schemata
>>    GMB:0=2048;1=2048;2=2048;3=2048
>>    MB:0=8;1=2048;2=8;3=2048
>>
>> What would be most intuitive way for user to interact with the interfaces?
> 
> I see that you are trying to display the effective behaviors above.

Indeed. My goal is to get an idea how user space may interact with the new interfaces and
what would be a reasonable expectation from resctrl be during these interactions.

> 
> Please keep in mind that MB and GMB units differ. I recommend showing only the values the user has explicitly configured, rather than the effective settings, as displaying both may cause confusion.

hmmm ... this may be subjective. Could you please elaborate how presenting the effective 
settings may cause confusion?

> 
> We also need to track the previous settings so we can revert to the earlier value when needed. The best approach is to document this behavior clearly.

Yes, this will require resctrl to maintain more state.

Documenting behavior is an option but I think we should first consider if there are things
resctrl can do to make the interface intuitive to use.

>>>>>  From the description it sounds as though there is a new "memory bandwidth
>>>> ceiling/limit" that seems to imply that MBA allocations are limited by
>>>> GMBA allocations while the proposed user interface present them as independent.
>>>>
>>>> If there is indeed some dependency here ... while MBA and GMBA CLOSID are
>>>> enumerated separately, under which scenario will GMBA and MBA support different
>>>> CLOSID? As I mentioned in [1] from user space perspective "memory bandwidth"
>>> I can see the following scenarios where MBA and GMBA can operate independently:
>>> 1. If the GMBA limit is set to ‘unlimited’, then MBA functions as an independent CLOS.
>>> 2. If the MBA limit is set to ‘unlimited’, then GMBA functions as an independent CLOS.
>>> I hope this clarifies your question.
>> No. When enumerating the features the number of CLOSID supported by each is
>> enumerated separately. That means GMBA and MBA may support different number of CLOSID.
>> My question is: "under which scenario will GMBA and MBA support different CLOSID?"
> No. There is not such scenario.
>>
>> Because of a possible difference in number of CLOSIDs it seems the feature supports possible
>> scenarios where some resource groups can support global AND per-domain limits while other
>> resource groups can just support global or just support per-domain limits. Is this correct?
> 
> System can support up to 16 CLOSIDs. All of them support all the features LLC, MB, GMB, SMBA.   Yes. We have separate enumeration for  each feature.  Are you suggesting to change it ?

It is not a concern to have different CLOSIDs between resources that are actually different,
for example, having LLC or MB support different number of CLOSIDs. Having the possibility to
allocate the *same* resource (memory bandwidth) with varying number of CLOSIDs does present a
challenge though. Would it be possible to have a snippet in the spec that explicitly states
that MB and GMB will always enumerate with the same number of CLOSIDs? 

Please see below where I will try to support this request more clearly and you can decide if
it is reasonable.
  
>>>> can be seen as a single "resource" that can be allocated differently based on
>>>> the various schemata associated with that resource. This currently has a
>>>> dependency on the various schemata supporting the same number of CLOSID which
>>>> may be something that we can reconsider?
>>> After reviewing the new proposal again, I’m still unsure how all the pieces will fit together. MBA and GMBA share the same scope and have inter-dependencies. Without the full implementation details, it’s difficult for me to provide meaningful feedback on new approach.
>> The new approach is not final so please provide feedback to help improve it so
>> that the features you are enabling can be supported well.
> 
> Yes, I am trying. I noticed that the proposal appears to affect how the schemata information is displayed(in info directory). It seems to introduce additional resource information. I don't see any harm in displaying it if it benefits certain architecture.

It benefits all architectures.

There are two parts to the current proposals.

Part 1: Generic schema description
I believe there is consensus on this approach. This is actually something that is long
overdue and something like this would have been a great to have with the initial AMD
enabling. With the generic schema description forming part of resctrl the user can learn
from resctrl how to interact with the schemata file instead of relying on external information
and documentation.

For example, on an Intel system that uses percentage based proportional allocation for memory
bandwidth the new resctrl files will display:
info/MB/resource_schemata/MB/type:scalar linear
info/MB/resource_schemata/MB/unit:all
info/MB/resource_schemata/MB/scale:1
info/MB/resource_schemata/MB/resolution:100
info/MB/resource_schemata/MB/tolerance:0
info/MB/resource_schemata/MB/max:100
info/MB/resource_schemata/MB/min:10


On an AMD system that uses absolute allocation with 1/8 GBps steps the files will display:
info/MB/resource_schemata/MB/type:scalar linear
info/MB/resource_schemata/MB/unit:GBps
info/MB/resource_schemata/MB/scale:1
info/MB/resource_schemata/MB/resolution:8
info/MB/resource_schemata/MB/tolerance:0
info/MB/resource_schemata/MB/max:2048
info/MB/resource_schemata/MB/min:1

Having such interface will be helpful today. Users do not need to first figure out
whether they are on an AMD or Intel system, and then read the docs to learn the AMD units,
before interacting with resctrl. resctrl will be the generic interface it intends to be.

Part 2: Supporting multiple controls for a single resource
This is a new feature on which there also appears to be consensus that is needed by MPAM and
Intel RDT where it is possible to use different controls for the same resource. For example,
there can be a minimum and maximum control associated with the memory bandwidth resource.

For example, 
info/
 └─ MB/
     └─ resource_schemata/
         ├─ MB/
         ├─ MB_MIN/
         ├─ MB_MAX/
         ┆


Here is where the big question comes in for GLBE - is this actually a new resource
for which resctrl needs to add interfaces to manage its allocation, or is it instead 
an additional control associated with the existing memory bandwith resource?

For me things are actually pointing to GLBE not being a new resource but instead being
a new control for the existing memory bandwidth resource.

I understand that for a PoC it is simplest to add support for GLBE as a new resource as is
done in this series but when considering it as an actual unique resource does not seem
appropriate since resctrl already has a "memory bandwidth" resource. User space expects
to find all the resources that it can allocate in info/ - I do not think it is correct
to have two separate directories/resources for memory bandwidth here.

What if, instead, it looks something like:

info/
└── MB/
    └── resource_schemata/
        ├── GMB/
        │   ├── max:4096
        │   ├── min:1
        │   ├── resolution:1
        │   ├── scale:1
        │   ├── tolerance:0
        │   ├── type:scalar linear
        │   └── unit:GBps
        └── MB/
            ├── max:8192
            ├── min:1
            ├── resolution:8
            ├── scale:1
            ├── tolerance:0
            ├── type:scalar linear
            └── unit:GBps

With an interface like above GMB is just another control/schema used to allocate the
existing memory bandwidth resource. With the planned files it is possible to express the
different maximums and units used by the MB and GMB schema. Users no longer need to
dig for the unit information in the docs, it is available in the interface.

Doing something like this does depend on GLBE supporting the same number of CLOSIDs
as MB, which seems to be how this will be implemented. If there is indeed a confirmation
of this from AMD architecture then we can do something like this in resctrl.

There is a "part 3" to the proposals that attempts to address the new requirement where
some of the controls allocate at a different scope while also requiring monitoring at
that new scope. After learning more about GLBE this does not seem relevant to GLBE but is
something to return to for the "MPAM CPU-less" work. We could already prepare for this
by adding the new "scope" schema property though. 


Reinette

> 
> Thanks
> 
> Babu
> 
> 
>>
>> Reinette
>>
>> [1] https://lore.kernel.org/lkml/d58f70592a4ce89e744e7378e49d5a36be3fd05e.1769029977.git.babu.moger@amd.com/
>> [2] https://lore.kernel.org/lkml/e0c79c53-489d-47bf-89b9-f1bb709316c6@amd.com/
>>


