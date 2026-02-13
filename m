Return-Path: <kvm+bounces-71064-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uCyKMa9Oj2nnPgEAu9opvQ
	(envelope-from <kvm+bounces-71064-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 13 Feb 2026 17:17:51 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 246E4137E1D
	for <lists+kvm@lfdr.de>; Fri, 13 Feb 2026 17:17:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 99A4F30530B6
	for <lists+kvm@lfdr.de>; Fri, 13 Feb 2026 16:17:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3F111CAA78;
	Fri, 13 Feb 2026 16:17:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mHarB2HC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4994724677A;
	Fri, 13 Feb 2026 16:17:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770999456; cv=fail; b=qS+Tvm5sE9R7aBpfVTfoo1CtJhi3EAa9PVDGHyQlui5uUtbhqtErxxvlXwqkOfPLPv7rYQ0PU78F4B49FCmIvl6Zp+YgoK4gV7v5r6H/mlOqnDumSB3LmFBc4quin9WgmjS/oet0c7tM3IwLTyqqJ69vsaoKWZrv/eq8/UjE7ME=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770999456; c=relaxed/simple;
	bh=CJk6+4cIb+kfHKZyz68qzXh1t5SL6loQJWWxC5DGdUg=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=kZrOfBidQy1hsjOWYl4slMvsKAA62OCb8XkzEibinvmnjfn4SKmjOfwhzZftvuspAT33GK5ZumRsPOrY0cWNjLB4hHLKm8y+2ZDfatjG7g1utOFFMjiql9ZFlbPmmEHGEjqVBOdzf8BvGJhFQ+YQRUCQbzYnkzQKY2EwzAGXN6k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mHarB2HC; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770999454; x=1802535454;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=CJk6+4cIb+kfHKZyz68qzXh1t5SL6loQJWWxC5DGdUg=;
  b=mHarB2HCWobqF8JbHC8S5IcRiomn0r/12t7drxwB2UjA8zOOw5aL2cuf
   7v4tPAKZly4+xNXAhYHSOJQnzIzivjkSDbajpRSYm1PdzHE3SifjzVJ6P
   xkPvU1v4Rrj/fpzPoQ7thXvp28LZtX6C7dk+AslMKZyckvHJaoMV81Y6f
   QFto3uNwQ2OXjOHGyx8DRH1JupIf9SXPoewbR85vd2EutDtKeIJVTRbNu
   U7r5f0OPkXVvHun9iBE5cOXuGBiLlT+/yAqbY/fQT4C9HsCweAGtHO4Wl
   mXzXD8i/ODnDgoZ2jMmoLEolbOWnGWm1pXCpBxqVSjF74z19wpQmxq5s9
   w==;
X-CSE-ConnectionGUID: cnmDW0k0SD691Ne5NaSA8g==
X-CSE-MsgGUID: 46VuG1ylR6y1A8A6Mox2Pg==
X-IronPort-AV: E=McAfee;i="6800,10657,11700"; a="72227069"
X-IronPort-AV: E=Sophos;i="6.21,288,1763452800"; 
   d="scan'208";a="72227069"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2026 08:17:33 -0800
X-CSE-ConnectionGUID: jdFX8gttT1++nbi0KwhxBQ==
X-CSE-MsgGUID: wMtK6e9tRByfQ5kGDvT7/g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,288,1763452800"; 
   d="scan'208";a="217497082"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2026 08:17:32 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Fri, 13 Feb 2026 08:17:30 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Fri, 13 Feb 2026 08:17:30 -0800
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.8) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Fri, 13 Feb 2026 08:17:30 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TAHDyDvJwRy7hzuqbLWobfc95mNLwbA5Py97hxFO3gLkNTx/UlPpxqySgGA89IB0/ppYoDXpsGqTMqnHuAacsTvcbid70FNQOGviZIjKu7JUbr2tNayyUkMtopvrb0Jrcj/wap9FTUuFLhMTbT36o36uH9S72U/BFa3cbdJB4pw1s3qLvBTEZDUgdRXzb3vjTFZekzPdPvUSvp6hPc8PFDd6Z9mNh0CRsLzNQaPxupc3ZGdP8fF17atgncVNfhUbhzVvObPsWqBeij4JL7+DaIZ8eftUUbVzbzCW3oL5mNGHlgWO1Z3PQ9ez+PDfHMLV89X18tObvyRs1nOg9IRb0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I0SLhojKPQcqSL+sWeIYmt4SL7XHsWTSWDMPZmqlc3U=;
 b=UjarLt/s8Gr0j8LjqQ0XT6QyoO3rtoJ9wz5I5r0D6po2R0/t7Ewn3/KVwmbRQLd/2ASlz6GmtvV0mH02BStjUG45mByPXh7bM1WVH0DFsP8jiEGcTl1BD76Qovg4Xf6dGs0upkQDdvQc+p69IGCRVQM2meWP23/60MiL39iE9nj0v33HuOXIBmGYGIQTVPrSqHA8RA1bQJ8h/16RKxiaqmOUmByybZXE3lgwI1v6hjGvZw7u8CLGND9/ynF0SjAxgzO0R3uookRPWC39iswSYglPv3NZRLe0IS/QdtxODRf3VtF+8AqOYR8BMGkcbVrd87lOt/TRarV97aweO/BfFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by DM3PPF9D56E7727.namprd11.prod.outlook.com (2603:10b6:f:fc00::f3f) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.13; Fri, 13 Feb
 2026 16:17:26 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d%6]) with mapi id 15.20.9611.008; Fri, 13 Feb 2026
 16:17:26 +0000
Message-ID: <280af0e2-9cfb-4e08-a058-5b4975dd1d16@intel.com>
Date: Fri, 13 Feb 2026 08:17:22 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 01/19] x86,fs/resctrl: Add support for Global
 Bandwidth Enforcement (GLBE)
To: "Moger, Babu" <bmoger@amd.com>, Babu Moger <babu.moger@amd.com>,
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
 <06a237bd-c370-4d3f-99de-124e8c50e711@intel.com>
 <91d50431-41f3-49d7-a9e6-a3bee2de5162@amd.com>
 <557a3a1e-4917-4c8c-add6-13b9db39eecb@intel.com>
 <f72a62af-e646-40ae-aa16-11c7d98ecf03@amd.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <f72a62af-e646-40ae-aa16-11c7d98ecf03@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MW4PR03CA0259.namprd03.prod.outlook.com
 (2603:10b6:303:b4::24) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|DM3PPF9D56E7727:EE_
X-MS-Office365-Filtering-Correlation-Id: 25fbfc6e-0150-42c2-ebcb-08de6b1b605c
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?TkIyakRTK05HMGFhOFdMcVN4VTJkNlFYcmNhWDFrSHNNSW5EVWNnakk4TmtW?=
 =?utf-8?B?NVA5UGhqZUZLcFVTZnhJY3RKS0hsbW9OMzhiL3ErUGZsbTJlNXMzQ2pKOHVx?=
 =?utf-8?B?WFlwdU5QcUNESXRiYWNjUmhlZzJ6bXgxYU1nU0dSYTk0c3NKNWUrTUZYUnNG?=
 =?utf-8?B?NWlMY3NrOXlJVFlQRWVJOTcxL3ZPRUtxNmJiWFJGL21EWVpjNmdCZ1ZDckI3?=
 =?utf-8?B?ZlVSdm52dDZzNzdEOFRDdXdXdkV6eFM3bVJEYjJlTkFMdWRDVUVHaU51cXVQ?=
 =?utf-8?B?b3NkbXRGcDBFTkVrbzFPM0xDWTVTUktRbU80NGhjdHNMUWc0Ri95Vm1QYjE3?=
 =?utf-8?B?YnFyREhTZnhySFVUaERtQldRUW1idCt2dkZxcnlVZGQrNmlkeGhDaC90UzZk?=
 =?utf-8?B?dU5Rc3RzZ3hiRWNSL1JKT2NOd0FNc1ZJZFgxSHFvbzJqN1JHNUs4NHBhVUVV?=
 =?utf-8?B?UHZqYnE1RVI4OVYzMFR6UTdPc3l4SG1pZEZuTE1rN3BUZmxGYmY1OGJHaTdX?=
 =?utf-8?B?YVN1b3gycG50VkllakgwT3prWDJRVHdSSDZlaEVuc1I3TElCcUlnVzhBeTlC?=
 =?utf-8?B?U1FwdnNuRjZtWTVweThDYW9xcmpCallJSVYycVZOa1JMc2Qya1FYTk5PNlB1?=
 =?utf-8?B?L29wZmtnQzBhTzZKYVZ1NnAya2Rhb0s1VUdnRVR5ZEdPdGNuVkFKbkNVdStX?=
 =?utf-8?B?TWZZcktVT3dGMFNobTYxZlNsMnFLcUpIcHFSKzJGaktSaXFGOUtwbVlaT2kv?=
 =?utf-8?B?QTROMjN4UEtobVhOWUdEcFFEM1Jpb2VOZStEbGIwV3Z3TEE0a3ZXWTVtUGNm?=
 =?utf-8?B?NS9zSWRiTHRPMllGYXVHMU5aVWlTMlB1K0xNSG5Mc3V5VWpLU1JINHhpODhs?=
 =?utf-8?B?NWtOVUpLZ3YxdDFhMEJWOUM4cjVWRjhNckQ5SG1jY0pVLzZlZ2I2TGFKMDBt?=
 =?utf-8?B?OHFUYW10VXRyTytSL2hxQVpVUFhJUWMwM0x5L2pNb2M1a1BuRmh6bFZXVER1?=
 =?utf-8?B?bVhHL2EwWXQ5cm9tV0JBY0FzQ2JGbXM4NkdMbTVSTXV6S0ZGQW9keVR5MklP?=
 =?utf-8?B?MjhVWXRHdGo2Q01BaUswdU85WmFKRC9QSGRnNDAxOFpOQTNyYi82RGxpUGxp?=
 =?utf-8?B?S0tsOE9KWXhwc3FraFNqMG5JeFN0VWtkUUNrcVEraHNTWHEzbzc0RTlDNFRS?=
 =?utf-8?B?OStkTHJpUUJvNi8wQ25LbGFWT29oRkd1Qy9EbHBQZzQydWsybmJ0cW1zL2Nw?=
 =?utf-8?B?aUtPdW15WnRWVFgyQTVyTHJCcWtFM2RVVUk0eWpFODdKY3QydmhhTG1ac3Ru?=
 =?utf-8?B?a01aOXFiT1RsR1I1eE92b3VhWDdta0pxTjRLWkNhNVo4SHZLQW14N2xVcXNP?=
 =?utf-8?B?OHIvd0g1T2h3anB4MGpBYWF5MHZXSTVkQ3JjdDJMQmpUYTZXSzIyVmVwcjFB?=
 =?utf-8?B?Z1E0Y0RIYSs5N2laTDcvUDdZTmRKRGJXN080K05yNmxwN09rWXczbVJTekN5?=
 =?utf-8?B?QUtCMWNkVWtaTTBZU256QTZXL3ZCWTJYRjJHOGxxS0VGWFY3a2paZEJzVzRm?=
 =?utf-8?B?SlRVWEJzOThsSVgyKzk0Z1hzM3IxOHRNV0UxZ0ErZDQvRll1a2gwc1g1NkhZ?=
 =?utf-8?B?Y04wVXNudHBwVmRTQ0pibGpBcGtVcjgyTEVYVndmU3ZBbmJNTjB1Ym8vTXVz?=
 =?utf-8?B?NjZmWkgzVEowbVZXcSsrN09OY1lMVzlRODhldjBSTkh1Z2VHWXVkNGVYWVpW?=
 =?utf-8?B?clJhd0F5UnY3TVdCdThBc1Bna0NMVDFBUWNzTFFkc3N1eG5yaFIwdlFBeVF4?=
 =?utf-8?B?djZxa1hCVi9vQWlIeTJmVi9PbzFBS0FFVnBjN25QUVJQenRzQVhad1grS0cy?=
 =?utf-8?B?em8wbXdhOGtaRVphcUpZcVBkd3FUZmFFMFFWOUtKTmlkZXg1ZHdjdGhKQm9x?=
 =?utf-8?B?dHBocDBlZWoyWDFFWEpNZFF3UzU4RC9zMC9aRzZJbk1JbDkyaG4xSlkvRFJk?=
 =?utf-8?B?R0c4bWtjV1NkaGNScEliRjB5aDdHWVREb1FUVnh6Y1Z5bDFxMlNScEMwRTdQ?=
 =?utf-8?B?c3Z2dkdJY2ZJSEYzeS9HZFkrbStkSWpqbVM1UEhsTGdVK0s5ZHQ1SFFlZzlX?=
 =?utf-8?B?eXpLRGIxTG05SC9NTmYxS016VHhpZW5OdnhuV2ZnVWp5QjV6YVE2OVRvc0Vz?=
 =?utf-8?B?Mnc9PQ==?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZktlLzdXTi81cFh6cW5aUzNmbEpwVytIbXl6UHl3VDRMdFdqeHlQTkhlRTR4?=
 =?utf-8?B?MlNLZ0p3OHE4MlJMOGlJUGFHTk85UXFBamZvZVJ2UzBnV2dtN2FaYUdERDhQ?=
 =?utf-8?B?NGN4NzNwUkg1bmFTRjVMS2lEczN1YTBHQmZEc3ExdXF4WEN3OXBYcHN2TnB0?=
 =?utf-8?B?dnZsV2I0elNHY3FUMVFKV0haSFdkaUxTeHRtdmFXWHFDVjkvdFg4R08wOEY0?=
 =?utf-8?B?NkZsZ2Q2VnBGYW15b2JVb3AvSU1GNkFWNlhOUk96VHUreFJIQnRWMDV4VjlE?=
 =?utf-8?B?UUttZVc3YW1pUFBkV0JmRDB2K2Y3WnBLa2ZzN2VuMmV3MmxHdDNRaUp2SWYy?=
 =?utf-8?B?UW1QYlplSFdDd0lWYWJJRVlCL1J1OG1xWFZ5YzhjaHdnVnV4TGdpdkN6NXhs?=
 =?utf-8?B?VEY4c0tUNXBGanRibVRZNzAwTzhJUGNld2Z5UjZzL2pwRi82Qkk4aHR0dUhR?=
 =?utf-8?B?ZHRKaDFwWklhT0pDSHAxVzJMd0hxdzA4eVVKT2ZHMUUzQm1zUmEwcW1hQUVp?=
 =?utf-8?B?eU9lZzgrVFJ5U0RReTliNnFFZDgvTjZmNG9rTXJuYi93dnBxc05uOXpEUGZI?=
 =?utf-8?B?eEhUWm1zOThDQmtwNUZaZnVPcDhFRkllM2pMRnh4TTh6dm5kVHZOT1dQQWlU?=
 =?utf-8?B?RlV4VUFLZEpvcFNXdkFXeHdVOXBzOXZPYUpralk3SnJmR2dWTVVtMC9LNEV6?=
 =?utf-8?B?WVJYVTRpSWJ2ektVUnZZSDdhM3pVNnVpZmVMUFY5ZkY1K3J4cm80aUROVDhI?=
 =?utf-8?B?RUtRWnVwRVRmODRFTWo1eVo4WUlZSzZBemo5TDZXLzRyY2NzZDVsM3NQdm5X?=
 =?utf-8?B?K3J6TVh1a290VkpJSzlGRnQ4d1pEVnI1TDJRR2pYdVRIZmd0UHJLWldJZVhk?=
 =?utf-8?B?MTdRVnR1S1R3b2pqKzEvV0NORG41YUdqUXVLajc4bWxSb0pZSzBwTFpKd1ZS?=
 =?utf-8?B?SWJyMmJFcTNScFBOMkpsNTlCejg3YmgzWUIxQXVXV1dxaDhzZTUvQjVaTDN0?=
 =?utf-8?B?b3N5QkQ5cTVxQ3ZnZHNFdm1KSXE3M2dzUk9NWDYzVEx5bm9EUXRGYWVDNGRh?=
 =?utf-8?B?SGliaUwyYzRkd1JmbDVpdzk2OUE0VFc2NDl5aE50QlVpNnB3UW9uZ3BkZDI2?=
 =?utf-8?B?QWJMdkJpQ3VLZkNyd3pPYkROU3Y3cVBPT2IzMG1hb0I3Qi92ZEtFcHo3a2lY?=
 =?utf-8?B?VHVCQkdCczlCVjNDbEpxVmZXVElqOHl1azZqdGEwQU5qRzR6R2hZZ1hsVno5?=
 =?utf-8?B?RGRzMVRoN2RzQ00wdkdvUWs2ekUxU2hKWFlkK2hqUTJHZTIvNlBzTTc5dmg0?=
 =?utf-8?B?ZEZ5OXBBOVg5UUNhNGJSNG80V0xodE9oenNoeUpYMUVmbllMNzZVZm1JbmZy?=
 =?utf-8?B?Q2ZsZzFRT0dDbFg0QWRuNFpZcW5ONDJZRk04THJXYk1kVzl2ZWRTOUNHeDg0?=
 =?utf-8?B?aEt1RDZLWk5xdGlhcE9GdnpuZ2xLeVNNVVNPd1hzd2xWVzQ5RmwzaTdzWHFS?=
 =?utf-8?B?azZwR21uKzlYbENyVWVLSFFtMFhlbytFUVprdE82TzVWUUhHYlZsZ3hnMUpY?=
 =?utf-8?B?MnBtczVlU25XcDJxVE85WGx1c09mYTVOV0k0R0Q5MnNIOHU2MllJWGxBbmlH?=
 =?utf-8?B?OENVYVJTSzhHU3JHRUdoSzkyV295WjkvMnp5cURFMHp4cU9EL0kxV25hZTNt?=
 =?utf-8?B?UlVGZkJZOFpYay9ZYWlQc0pPTC9sUHZHck9abyt3dEhqcjhhWnhKYTgxSGJz?=
 =?utf-8?B?TXo0T0UrMExkUkZGdFpqeCtJbmtmOTlvR09Xbjk4VHY0VFN3dStybWpEUk90?=
 =?utf-8?B?TDRBR3FFckN4N2pTMGwvSzhQUHUyYnh0RnpWb2U1ZXdjYTBuckoxMFVSVHlH?=
 =?utf-8?B?djJIeTY5NUhVSG5kVU9mRkxnRWlKKytncWo5UE9nVmp6QStsSERhVVBwYTRx?=
 =?utf-8?B?STlwTW5yU05TRERvMWVGS2pFUUVCcFlXTWwzencyVEFrckZ3UFA1SjI0WWN0?=
 =?utf-8?B?S0cza2xPa0ZnNE5YS1Z0cHFvcjFVa2FOV1NBclNPeDA4ZGxuK1RKWllCVXZK?=
 =?utf-8?B?bDFvSTJWbmZ1ZHdiM2Z5d3YrVS9uYmxiSFRDRURlTGRhd2s1RXhVNmJwaCtF?=
 =?utf-8?B?K0U5T2g0OTlqUDZrd0J3VFpteWtxRlg3OXYzT243Y2JMNUhNd2FqWFJKSXZh?=
 =?utf-8?B?d3NqNXJoTzdIK1lGVGFjRXljMXp4eVJ2Mnp1N1pDZVh0SjNOVFpnSTVuSHlF?=
 =?utf-8?B?VS9XUnpmMXNlQ2ZnbnFpbnIwaG4vam9RQ2FaZmFnRHpGYWRNRFhySi9OelZQ?=
 =?utf-8?B?TXRxQ2tOaGMzaWdJbGNOamcxYUM5UHRxYjRMTExGUklRMGpPRDQwclAwYzJ1?=
 =?utf-8?Q?dpsDmSt1oTbBMdaQ=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 25fbfc6e-0150-42c2-ebcb-08de6b1b605c
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2026 16:17:25.9244
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s5XZIug6j527mpYji56M0pGOgcaPy4AYo/tHtEAVZqnn+xwCCqmqWvNWU/K4HYAIZKhMJANWwaAqIxaitMzH7ea67BhM08Iv8n9Trk7OglI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPF9D56E7727
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[44];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_COUNT_SEVEN(0.00)[10];
	MID_RHS_MATCH_FROM(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[reinette.chatre@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,intel.com:mid,intel.com:dkim];
	PRECEDENCE_BULK(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71064-lists,kvm=lfdr.de];
	DKIM_TRACE(0.00)[intel.com:+]
X-Rspamd-Queue-Id: 246E4137E1D
X-Rspamd-Action: no action

Hi Babu,

On 2/12/26 5:51 PM, Moger, Babu wrote:
> On 2/12/2026 6:05 PM, Reinette Chatre wrote:
>> On 2/12/26 11:09 AM, Babu Moger wrote:
>>> On 2/11/26 21:51, Reinette Chatre wrote:
>>>> On 2/11/26 1:18 PM, Babu Moger wrote:
>>>>> On 2/11/26 10:54, Reinette Chatre wrote:
>>>>>> On 2/10/26 5:07 PM, Moger, Babu wrote:
>>>>>>> On 2/9/2026 12:44 PM, Reinette Chatre wrote:
>>>>>>>> On 1/21/26 1:12 PM, Babu Moger wrote:
>>
>> ...
>>
>>>>>> Another question, when setting aside possible differences between MB and GMB.
>>>>>>
>>>>>> I am trying to understand how user may expect to interact with these interfaces ...
>>>>>>
>>>>>> Consider the starting state example as below where the MB and GMB ceilings are the
>>>>>> same:
>>>>>>
>>>>>>      # cat schemata
>>>>>>      GMB:0=2048;1=2048;2=2048;3=2048
>>>>>>      MB:0=2048;1=2048;2=2048;3=2048
>>>>>>
>>>>>> Would something like below be accurate? Specifically, showing how the GMB limit impacts the
>>>>>> MB limit:
>>>>>>         # echo"GMB:0=8;2=8" > schemata
>>>>>>      # cat schemata
>>>>>>      GMB:0=8;1=2048;2=8;3=2048
>>>>>>      MB:0=8;1=2048;2=8;3=2048
>>>>> Yes. That is correct.  It will cap the MB setting to  8.   Note that we are talking about unit differences to make it simple.
>>>> Thank you for confirming.
>>>>
>>>>>> ... and then when user space resets GMB the MB can reset like ...
>>>>>>
>>>>>>      # echo"GMB:0=2048;2=2048" > schemata
>>>>>>      # cat schemata
>>>>>>      GMB:0=2048;1=2048;2=2048;3=2048
>>>>>>      MB:0=2048;1=2048;2=2048;3=2048
>>>>>>
>>>>>> if I understand correctly this will only apply if the MB limit was never set so
>>>>>> another scenario may be to keep a previous MB setting after a GMB change:
>>>>>>
>>>>>>      # cat schemata
>>>>>>      GMB:0=2048;1=2048;2=2048;3=2048
>>>>>>      MB:0=8;1=2048;2=8;3=2048
>>>>>>
>>>>>>      # echo"GMB:0=8;2=8" > schemata
>>>>>>      # cat schemata
>>>>>>      GMB:0=8;1=2048;2=8;3=2048
>>>>>>      MB:0=8;1=2048;2=8;3=2048
>>>>>>
>>>>>>      # echo"GMB:0=2048;2=2048" > schemata
>>>>>>      # cat schemata
>>>>>>      GMB:0=2048;1=2048;2=2048;3=2048
>>>>>>      MB:0=8;1=2048;2=8;3=2048
>>>>>>
>>>>>> What would be most intuitive way for user to interact with the interfaces?
>>>>> I see that you are trying to display the effective behaviors above.
>>>> Indeed. My goal is to get an idea how user space may interact with the new interfaces and
>>>> what would be a reasonable expectation from resctrl be during these interactions.
>>>>
>>>>> Please keep in mind that MB and GMB units differ. I recommend showing only the values the user has explicitly configured, rather than the effective settings, as displaying both may cause confusion.
>>>> hmmm ... this may be subjective. Could you please elaborate how presenting the effective
>>>> settings may cause confusion?
>>>
>>> I mean in many cases, we cannot determine the effective settings correctly. It depends on benchmarks or applications running on the system.
>>>
>>> Even with MB (without GMB support), even though we set the limit to 10GB, it may not use the whole 10GB.  Memory is shared resource. So, the effective bandwidth usage depends on other applications running on the system.
>>
>> Sounds like we interpret "effective limits" differently. To me the limits(*) are deterministic.
>> If I understand correctly, if the GMB limit for domains A and B is set to x GB then that places
>> an x GB limit on MB for domains A and B also. Displaying any MB limit in the schemata that is
>> larger than x GB for domain A or domain B would be inaccurate, no?
> 
> Yea. But, I was thinking not to mess with values written at registers.

This is not about what is written to the registers but how the combined values
written to registers control system behavior and how to accurately reflect the
resulting system behavior to user space.

>> When considering your example where the MB limit is 10GB.
>>
>> Consider an example where there are two domains in this example with a configuration like below.
>> (I am using a different syntax from schemata file that will hopefully make it easier to exchange
>> ideas when not having to interpret the different GMB and MB units):
>>
>>     MB:0=10GB;1=10GB
>>
>> If user space can create a GMB domain that limits shared bandwidth to 10GB that can be displayed
>> as below and will be accurate:
>>
>>     MB:0=10GB;1=10GB
>>     GMB:0=10GB;1=10GB
>>
>> If user space then reduces the combined bandwidth to 2GB then the MB limit is wrong since it
>> is actually capped by the GMB limit:
>>
>>     MB:0=10GB;1=10GB <==== Does reflect possible per-domain memory bandwidth which is now capped by GMB
>>     GMB:0=2GB;1=2GB
>>
>> Would something like below not be more accurate that reflects that the maximum average bandwidth
>> each domain could achieve is 2GB?
>>
>>     MB:0=2GB;1=2GB <==== Reflects accurate possible per-domain memory bandwidth
>>     GMB:0=2GB;1=2GB
> 
> That is reasonable. Will check how we can accommodate that.

Right, this is not about the values in the L3BE registers but instead how those values
are impacted by GLBE registers and how to most accurately present the resulting system
configuration to user space. Thank you for considering.

> 
>>
>> (*) As a side-note we may have to start being careful with how we use "limits" because of the planned
>> introduction of a "MAX" as a bandwidth control that is an actual limit as opposed to the
>> current control that is approximate.
>>  
>>>>> We also need to track the previous settings so we can revert to the earlier value when needed. The best approach is to document this behavior clearly.
>>>> Yes, this will require resctrl to maintain more state.
>>>>
>>>> Documenting behavior is an option but I think we should first consider if there are things
>>>> resctrl can do to make the interface intuitive to use.
>>>>
>>>>>>>>>    From the description it sounds as though there is a new "memory bandwidth
>>>>>>>> ceiling/limit" that seems to imply that MBA allocations are limited by
>>>>>>>> GMBA allocations while the proposed user interface present them as independent.
>>>>>>>>
>>>>>>>> If there is indeed some dependency here ... while MBA and GMBA CLOSID are
>>>>>>>> enumerated separately, under which scenario will GMBA and MBA support different
>>>>>>>> CLOSID? As I mentioned in [1] from user space perspective "memory bandwidth"
>>>>>>> I can see the following scenarios where MBA and GMBA can operate independently:
>>>>>>> 1. If the GMBA limit is set to ‘unlimited’, then MBA functions as an independent CLOS.
>>>>>>> 2. If the MBA limit is set to ‘unlimited’, then GMBA functions as an independent CLOS.
>>>>>>> I hope this clarifies your question.
>>>>>> No. When enumerating the features the number of CLOSID supported by each is
>>>>>> enumerated separately. That means GMBA and MBA may support different number of CLOSID.
>>>>>> My question is: "under which scenario will GMBA and MBA support different CLOSID?"
>>>>> No. There is not such scenario.
>>>>>> Because of a possible difference in number of CLOSIDs it seems the feature supports possible
>>>>>> scenarios where some resource groups can support global AND per-domain limits while other
>>>>>> resource groups can just support global or just support per-domain limits. Is this correct?
>>>>> System can support up to 16 CLOSIDs. All of them support all the features LLC, MB, GMB, SMBA.   Yes. We have separate enumeration for  each feature.  Are you suggesting to change it ?
>>>> It is not a concern to have different CLOSIDs between resources that are actually different,
>>>> for example, having LLC or MB support different number of CLOSIDs. Having the possibility to
>>>> allocate the *same* resource (memory bandwidth) with varying number of CLOSIDs does present a
>>>> challenge though. Would it be possible to have a snippet in the spec that explicitly states
>>>> that MB and GMB will always enumerate with the same number of CLOSIDs?
>>>
>>> I have confirmed that is the case always.  All current and planned implementations, MB and GMB will have the same number of CLOSIDs.
>>
>> Thank you very much for confirming. Is this something the architects would be willing to
>> commit to with a snippet in the PQoS spec?
> 
> I checked on that. Here is the response.
> 
> "I do not plan to add a statement like that to the spec.  The CPUID enumeration allows for them to have different number of CLOS's supported for each.  However, it is true that for all current and planned implementations, MB and GMB will have the same number of CLOS."

Thank you for asking. At this time the definition of a resource's "num_closids" is:

	"num_closids":                                                                  
		The number of CLOSIDs which are valid for this                  
		resource. The kernel uses the smallest number of                
		CLOSIDs of all enabled resources as limit.  

Without commitment from architecture we could expand definition of "num_closids" when
adding multiple controls to indicate that it is the smallest number of CLOSIDs supported
by all controls.

>>>> Please see below where I will try to support this request more clearly and you can decide if
>>>> it is reasonable.
>>>>   
>>>>>>>> can be seen as a single "resource" that can be allocated differently based on
>>>>>>>> the various schemata associated with that resource. This currently has a
>>>>>>>> dependency on the various schemata supporting the same number of CLOSID which
>>>>>>>> may be something that we can reconsider?
>>>>>>> After reviewing the new proposal again, I’m still unsure how all the pieces will fit together. MBA and GMBA share the same scope and have inter-dependencies. Without the full implementation details, it’s difficult for me to provide meaningful feedback on new approach.
>>>>>> The new approach is not final so please provide feedback to help improve it so
>>>>>> that the features you are enabling can be supported well.
>>>>> Yes, I am trying. I noticed that the proposal appears to affect how the schemata information is displayed(in info directory). It seems to introduce additional resource information. I don't see any harm in displaying it if it benefits certain architecture.
>>>> It benefits all architectures.
>>>>
>>>> There are two parts to the current proposals.
>>>>
>>>> Part 1: Generic schema description
>>>> I believe there is consensus on this approach. This is actually something that is long
>>>> overdue and something like this would have been a great to have with the initial AMD
>>>> enabling. With the generic schema description forming part of resctrl the user can learn
>>>> from resctrl how to interact with the schemata file instead of relying on external information
>>>> and documentation.
>>>
>>> ok.
>>>
>>>> For example, on an Intel system that uses percentage based proportional allocation for memory
>>>> bandwidth the new resctrl files will display:
>>>> info/MB/resource_schemata/MB/type:scalar linear
>>>> info/MB/resource_schemata/MB/unit:all
>>>> info/MB/resource_schemata/MB/scale:1
>>>> info/MB/resource_schemata/MB/resolution:100
>>>> info/MB/resource_schemata/MB/tolerance:0
>>>> info/MB/resource_schemata/MB/max:100
>>>> info/MB/resource_schemata/MB/min:10
>>>>
>>>>
>>>> On an AMD system that uses absolute allocation with 1/8 GBps steps the files will display:
>>>> info/MB/resource_schemata/MB/type:scalar linear
>>>> info/MB/resource_schemata/MB/unit:GBps
>>>> info/MB/resource_schemata/MB/scale:1
>>>> info/MB/resource_schemata/MB/resolution:8
>>>> info/MB/resource_schemata/MB/tolerance:0
>>>> info/MB/resource_schemata/MB/max:2048
>>>> info/MB/resource_schemata/MB/min:1
>>>>
>>>> Having such interface will be helpful today. Users do not need to first figure out
>>>> whether they are on an AMD or Intel system, and then read the docs to learn the AMD units,
>>>> before interacting with resctrl. resctrl will be the generic interface it intends to be.
>>>
>>> Yes. That is a good point.
>>>
>>>> Part 2: Supporting multiple controls for a single resource
>>>> This is a new feature on which there also appears to be consensus that is needed by MPAM and
>>>> Intel RDT where it is possible to use different controls for the same resource. For example,
>>>> there can be a minimum and maximum control associated with the memory bandwidth resource.
>>>>
>>>> For example,
>>>> info/
>>>>    └─ MB/
>>>>        └─ resource_schemata/
>>>>            ├─ MB/
>>>>            ├─ MB_MIN/
>>>>            ├─ MB_MAX/
>>>>            ┆
>>>>
>>>>
>>>> Here is where the big question comes in for GLBE - is this actually a new resource
>>>> for which resctrl needs to add interfaces to manage its allocation, or is it instead
>>>> an additional control associated with the existing memory bandwith resource?
>>>
>>> It is not a new resource. It is new control mechanism to address limitation with memory bandwidth resource.
>>>
>>> So, it is a new control for the existing memory bandwidth resource.
>>
>> Thank you for confirming.
>>
>>>
>>>> For me things are actually pointing to GLBE not being a new resource but instead being
>>>> a new control for the existing memory bandwidth resource.
>>>>
>>>> I understand that for a PoC it is simplest to add support for GLBE as a new resource as is
>>>> done in this series but when considering it as an actual unique resource does not seem
>>>> appropriate since resctrl already has a "memory bandwidth" resource. User space expects
>>>> to find all the resources that it can allocate in info/ - I do not think it is correct
>>>> to have two separate directories/resources for memory bandwidth here.
>>>>
>>>> What if, instead, it looks something like:
>>>>
>>>> info/
>>>> └── MB/
>>>>       └── resource_schemata/
>>>>           ├── GMB/
>>>>           │   ├──max:4096
>>>>           │   ├──min:1
>>>>           │   ├──resolution:1
>>>>           │   ├──scale:1
>>>>           │   ├──tolerance:0
>>>>           │   ├──type:scalar linear
>>>>           │   └──unit:GBps
>>>>           └── MB/
>>>>               ├──max:8192
>>>>               ├──min:1
>>>>               ├──resolution:8
>>>>               ├──scale:1
>>>>               ├──tolerance:0
>>>>               ├──type:scalar linear
>>>>               └──unit:GBps
>>>
>>> Yes. It definitely looks very clean.
>>>
>>>> With an interface like above GMB is just another control/schema used to allocate the
>>>> existing memory bandwidth resource. With the planned files it is possible to express the
>>>> different maximums and units used by the MB and GMB schema. Users no longer need to
>>>> dig for the unit information in the docs, it is available in the interface.
>>>
>>>
>>> Yes. That is reasonable.
>>>
>>> Is the plan to just update the resource information in /sys/fs/resctrl/info/<resource_name>  ?
>>
>> I do not see any resource information that needs to change. As you confirmed,
>> MB and GMB have the same number of CLOSIDs and looking at the rest of the
>> enumeration done in patch #2 all other properties exposed in top level of
>> /sys/fs/resctrl/info/MB is the same for MB and GMB. Specifically,
>> thread_throttle_mode, delay_linear, min_bandwidth, and bandwidth_gran have
>> the same values for MB and GMB. All other content in
>> /sys/fs/resctrl/info/MB would be new as part of the new "resource_schemata"
>> sub-directory.
>>
>> Even so, I believe we could expect that a user using any new schemata file entry
>> introduced after the "resource_schemata" directory is introduced is aware of how
>> the properties are exposed and will not use the top level files in /sys/fs/resctrl/info/MB
>> (for example min_bandwidth and bandwidth_gran) to understand how to interact with
>> the new schema.
>>
>>
>>>
>>> Also, will the display of /sys/fs/resctrl/schemata change ?
>>
>> There are no plans to change any of the existing schemata file entries.
>>
>>>
>>> Current display:
>>
>> When viewing "current" as what this series does in schemata file ...
>>
>>>
>>>   GMB:0=4096;1=4096;2=4096;3=4096
>>>    MB:0=8192;1=8192;2=8192;3=8192
>>
>> yes, the schemata file should look like this on boot when all is done. All other
>> user facing changes are to the info/ directory where user space learns about
>> the new control for the resource and how to interact with the control.
>>
>>>> Doing something like this does depend on GLBE supporting the same number of CLOSIDs
>>>> as MB, which seems to be how this will be implemented. If there is indeed a confirmation
>>>> of this from AMD architecture then we can do something like this in resctrl.
>>>
>>> I don't see this being an issue. I will get consensus on it.
>>>
>>> I am wondering about the time frame and who is leading this change. Not sure if that is been discussed already.
>>> I can definitely help.
>>
>> A couple of features depend on the new schema descriptions as well as support for multiple
>> controls: min/max bandwidth controls on the MPAM side, region aware MBA and MBM on the Intel
>> side, and GLBE on the AMD side. I am hoping that the folks working on these features can
>> collaborate on the needed foundation. Since there are no patches for this yet I cannot say
>> if there is a leader for this work yet, at this time this role appears to be available if you
>> would like to see this moving forward in order to meet your goals.
> 
> 
> I joined this feature effort a bit later, so I may not yet have full context on the MPAM and region‑aware requirements. I’m happy to provide all the necessary information for GMB and MB from the AMD side, and I’m also available to help with reviews and testing.

I understand there is a lot involved. With so many folks dependent on this work I anticipate
that any effort will get support from the various content experts. Your knowledge of resctrl
fs will be valuable in this effort.

Reinette



