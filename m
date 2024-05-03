Return-Path: <kvm+bounces-16472-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 52E598BA53E
	for <lists+kvm@lfdr.de>; Fri,  3 May 2024 04:18:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 09F9A283CB3
	for <lists+kvm@lfdr.de>; Fri,  3 May 2024 02:18:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7CA7168C7;
	Fri,  3 May 2024 02:18:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PJ8Gac1b"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E665F4E2;
	Fri,  3 May 2024 02:18:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714702706; cv=fail; b=CocjdusxFsARo7imH2gngOrm/Ow0dwSlEUuHHbksv6RB7f5Y2lmpLtVjXSyGWHWgL9mo3RJDmQjli7boI7OeHk4/LnkEQqP7A7/wX4BUtSi24SfadZgEsV5Brbi/TsVx4YTHsdt5/zroz488xhP9e8dyWeMJpbfE46TV7MiIAI8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714702706; c=relaxed/simple;
	bh=yZ+5HeuH/lDJlnZBoZdC4iUOZ83yvbCaTozqgmZ5uZk=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=GCJiKKwrZJSoOXawF+USlpnoyqlohPPZ9QZMJ4KrQBljP83S0d2l0gT0aG0PfGbOyPhUMBK90xJjwYNfFtnTld13QTj2R/c2vzncO/NmUf1sSKJQmsp9uAODzjcRAuw8iN0drRZ15k876R18BELYAr2RIjjWN0IFBddnxw8bEHk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PJ8Gac1b; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714702705; x=1746238705;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=yZ+5HeuH/lDJlnZBoZdC4iUOZ83yvbCaTozqgmZ5uZk=;
  b=PJ8Gac1bh6mi3IY3ytt2mg9KcYVw1SQ9QvvNSYve0CWHFWckxFYCkqJE
   xoBAkkSLQCc86ouCjzk5yhRNyGCisx6TdtTly8/BiCz+62+3YrktaA+n8
   RqZ8bI2LJpN6HuGaJS4oRA/hPsg4wDXwlilvPVxJCoGpePBi6C5fOdwrb
   IFR/VIrgEseD891Tl6qHtZGRH5eB6MNtsajjiES9ULnM/Ao7Am4Qo+JDj
   zi08ZQVuLc4VqHyNhjxt+KSEe6TxIM6jgJiHqL+5x21uOgY4I1BqJJMTp
   zTOaL46vmr0KcYO/cgOqlEHPwklroiK/hUBScbPsXdndY9CgNoRLvcA3u
   w==;
X-CSE-ConnectionGUID: TYj4lfJORxW+IY3bZMg/kQ==
X-CSE-MsgGUID: Xd69WLCSQNu1ZeqD1FDeyA==
X-IronPort-AV: E=McAfee;i="6600,9927,11062"; a="14319457"
X-IronPort-AV: E=Sophos;i="6.07,247,1708416000"; 
   d="scan'208";a="14319457"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 May 2024 19:18:24 -0700
X-CSE-ConnectionGUID: fYh1IhNQSMys/5eWnKRKDQ==
X-CSE-MsgGUID: qScpYzdcSkOD+TvHQAHCkA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,247,1708416000"; 
   d="scan'208";a="58206458"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 02 May 2024 19:18:23 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 2 May 2024 19:18:23 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 2 May 2024 19:18:13 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 2 May 2024 19:18:13 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.101)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 2 May 2024 19:17:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ImajgEBYLMGw5lLq/uhaL8JAHRCeElbcaGufDGVeEfnqkBebURtE3V7MAiZcE+Ye413ZFYonUhl+1oh5Uk66piE8s1wbTTMBXMx+rruQiXtYUbXePfidxZSEHd5myfgAXZAvANBkO/HkD6eImJj3z6MhMw+TyfLJn0RI66LucWcSVsW08re3nJzN1BFqeSUmvFgJuT1OUL4zwYEXYuFv5oJAf1dBRRuS/K5RQjZLrOO3u2JEHKGBH4Q6lDmraekxcqpzlTwCtEERx8/Ccbzqx6AyWbO4oyS9UGgbAltA0HlkuGzBYHXd1ei42iCN7Cv4IroliPMGs8G2ikhdNU4qwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=++ZRzR/8aYFcTjtME+dMT/U2D8l7DHn17zjLRIHz0sc=;
 b=aGCJvS9ZOOWvopnU36aPgSbCsF47kRsPj2JY4yZGOOzhjx1U3T15/7gmTE1er+jsYANzAG4FGdo63046Ss328YTbhp/zVrT7jtJtUYIfM871p5/hDHQ8HEVlTxyPvwnaoOZKye6UHlGpS+gcw2JA1vr2LR5QhA7GJJRSxi63Yy6efnBozprQqEaPDxcUacrhq+3slZXyAFsGLeC3kpo/OFboZyT4hT7MiVdVq5Kvmtgpfz1YiJX/Jf5mOZx5Jw2wSkRM3pWXcOaxXb2/CmzGAjjg7QzF8m10Xf3m+sJ5f9WmUqzOiNj712oRwusc5nJPtIutM1/j7adIIBD/alFCdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SJ1PR11MB6179.namprd11.prod.outlook.com (2603:10b6:a03:45a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.31; Fri, 3 May
 2024 02:17:36 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.7544.029; Fri, 3 May 2024
 02:17:36 +0000
Message-ID: <330c909a-4b96-4960-9cad-fd10e86c67b8@intel.com>
Date: Fri, 3 May 2024 14:17:26 +1200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/5] x86/virt/tdx: Export global metadata read
 infrastructure
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
CC: "Hansen, Dave" <dave.hansen@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org"
	<x86@kernel.org>, "peterz@infradead.org" <peterz@infradead.org>,
	"hpa@zytor.com" <hpa@zytor.com>, "mingo@redhat.com" <mingo@redhat.com>,
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "jgross@suse.com" <jgross@suse.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>
References: <cover.1709288433.git.kai.huang@intel.com>
 <ec9fc9f1d45348ddfc73362ddfb310cc5f129646.1709288433.git.kai.huang@intel.com>
 <affad906c557f251ab189770f5a45cd2087aca19.camel@intel.com>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <affad906c557f251ab189770f5a45cd2087aca19.camel@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MW4PR04CA0099.namprd04.prod.outlook.com
 (2603:10b6:303:83::14) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|SJ1PR11MB6179:EE_
X-MS-Office365-Filtering-Correlation-Id: 2c6f5e67-1932-494e-3291-08dc6b1732c7
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|7416005|1800799015|376005|366007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?M1lkbDQ1aFdtMjZnc2dLUWc1azd2OVlqM2c1UW5jQ1lRZUVmamJxTmJyQm0v?=
 =?utf-8?B?eU5yTU1hLzRTRWZtN3lrbFIzZUk4V0NkNm5FTlZ3ZHZDYXMraDUvc3cyYlJL?=
 =?utf-8?B?bDVEZzJtRnBYZkhOa2s3V1BXUDhicmNzUWFBMEo0WXNXdWczZTVsekVsdFVR?=
 =?utf-8?B?YzJkVmlTTG5KK1MvTVB5WWp5U2x6RkJyZk90WTF0SzgreGw5TlJFdEtIZWpq?=
 =?utf-8?B?N21RWXA1dFZDeHF2bk9hMDduZWFDYy9MQTR3eWZwSmh3cERLMnk0V2p3TGMw?=
 =?utf-8?B?UklJeE1uemd0cDdkbnY1RFhMNkhrL2Y2NEZBc1BCTkhhS0Q4cjg4VWtNQzZU?=
 =?utf-8?B?R1d3YVhOSGtaUTdSWDhPendjZ2RqL0RiTFdWdGh1OVVtRmJhL2Jwd3NSYWlj?=
 =?utf-8?B?RFIyNnM2ck5PcktOT1JRN2NaRXJMUWljNThiZStOWXlQNldGNnNhYnlmZWdv?=
 =?utf-8?B?aUJrL28weFVCMVBGd29NMTk1NUZMT1RiT1ZYenZXQXVLVWI2bjNEWGIxclln?=
 =?utf-8?B?YVlIaTErUFRvNXY2MHhudWc2L2svQmFEVmtmclZjR1JNdnIxYzhzVk1iZlZS?=
 =?utf-8?B?NWRPcStIQlVZcXJaa0tKUi9Ja1pGZkFVajd5YWEvR3RWanliRWVBd2I3Tzh1?=
 =?utf-8?B?MXhWK2ZySEJUQUVzaXA5bU1BMXduRFVZY1R0WVdNRlIyZENzT2tCTUVlMFJ6?=
 =?utf-8?B?WWlld2kyYVNIeWNBZFQzWmpVSmJrZDZmc3FVbytRcW1rcU1pNThoL1NRNlRn?=
 =?utf-8?B?QmdrUDNOYzJtaDREUlRycVRaM0Eva1Fmc1hzcHlWRSswZnFscDIybngzSldu?=
 =?utf-8?B?Q2RjSm1uVld5bXJZUzlYU0pkbGpEQ21Zb2RpUTdCZThQNi9yZGYvMk42bUp2?=
 =?utf-8?B?RnRTWWlLRE1vNXUxOXFnUXJlT0hVajlEeVUvako4WDMwSGNiLzNmRjNUZlBo?=
 =?utf-8?B?ZUpRbmN1OTgza2t0U1RXMEZjNG1iMFp5VERPTldzc3dPR2hXTWx6OHNBZUlV?=
 =?utf-8?B?dDh4SzhlVHpFaWphNTloMVB3Wm85YVZ5NUYzYmVxc213NnAzR0pqbFdCSUs0?=
 =?utf-8?B?cGFXQkJqcFRSbzdGbG5YdlFmS25sY0V6OFluby92QytlSDVXSW9EZ1lyVjU0?=
 =?utf-8?B?cmZzNHdxWGxJajB3cHB0SFNtTHYxT0JzN2daS2N4RjBHK2VmM1RWbWNuUFNN?=
 =?utf-8?B?OFlrVzF1ZGxDOThJUWFmMVBpblp2d3FWUWdqTmFLSHNTaFNsRGk4QXYyYlVm?=
 =?utf-8?B?M085NDRPaFN5SjZBZVZPdStSc1UrVm9QSlFHVTdNT2NjOUVxemsvK0tMVllk?=
 =?utf-8?B?V1g5Uno2cDNTZTFlMHpxTGhyVEZMV3kzWjdocE1hU3V1Y3czYWtsZHZDWlpS?=
 =?utf-8?B?NjJKQUMxNXRDZWM1TWMvNllKWEQ3VUI0TkxBNnpvNGJkcG9qNDgxRExxOWlG?=
 =?utf-8?B?ZXo2NVVrTk40N0JQcWlvT3VKdkJUSjdYL1VtbHdDSGxXZEYwVFY4ZW9KaUZX?=
 =?utf-8?B?eFovbzZnS1lyclNmNWs2S1JDYTlna280VEFkUGZEdSt3WUFGUTc3NmIwY0k5?=
 =?utf-8?B?S0NBcHdzZlBrbDRESmlqZWNIOXVWRXFiV1NjVkpCM1VyeUdvcXZ3SWVtbFQ4?=
 =?utf-8?B?L1ZWd2c0OUpVYXUwbHFuQ3pOR3o5c2NDKzNOd3ptb09ESjAxNTN3SnlVUGRJ?=
 =?utf-8?B?QTg4RURWbkZLYm1EdzlPMVhUd09Tb1ZlRUFiaU16QUZOMFZWSVdoVFhnPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(1800799015)(376005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Q2RWWURSSmhCeVNSK0R5NGV0RWNUWiswbmlqZlpIVWt1WmFiOXk2enZtMVBx?=
 =?utf-8?B?aExQcnV0eHNmUFNrVnBqVVViakczSTRCajgwS1kvSE01L1ZNSXQzNk9mVVZx?=
 =?utf-8?B?S0c0bXk5YUxtSzJDaWtXU2tRdktqYS9FVTN5OUZlRUhZaElEWitQL0F2dnFh?=
 =?utf-8?B?TUV1N21ZNlVwMzdtZlhjc2lHazk5ZWp3c0VNTWFvcWZEQjRQdDNoK291ZkRt?=
 =?utf-8?B?NWZUTEx5bHVhN1d5ZkFMVnkya3dZUlZ2aUhyaUFPbVVBVlpqdUNwdEdOaytk?=
 =?utf-8?B?Y0I5cmlmaXFOWWJvN0JSUi82dEU1Rm00YzJnbUx5OGU0UVVaSjhIcm9GQU9V?=
 =?utf-8?B?Q2hJenliZFpMY0RoblJJVjR3Vk9uMlBkcTNtWU96SWN6bzhaU09BdGRnVE9n?=
 =?utf-8?B?Mk1CSGloM1U2a0VIM1k3bmRsaml5WGVtczNaK0h4cGN1RUt3ZG1zT3pKangy?=
 =?utf-8?B?TWUwTzZ5Z0x5NE5iZ29YRnNGYUdsdVhEYkE0U0dMTDdUMXFQNE9IeWU3RERu?=
 =?utf-8?B?WVNjQUYvWTI5N1JFL1FJSThjU0VnZGEzOFM2czZaVFQ4bGpTNXJpZWJuTHR1?=
 =?utf-8?B?bG1Oall2bEQ2ZmhqcG5nK3hCdnJrbm9TM0ZUaXRIZVhkSS9oeEJmR0J6TDZ4?=
 =?utf-8?B?SlFSRFhKRWNXcTBEcTJJU3lyak5maUFuRWVJTGFocHcyTnRsRmRzcnRlbnYr?=
 =?utf-8?B?c0hjWDFiOGhKTThUakJHd09haHBPdVFScjVEVU5Qai8rU2RDT3pPdEE3Y3JR?=
 =?utf-8?B?NEdPVmFYY3Z5Z1M2WEREOW5sWmZ0UHpMeUJ0SFRRVjhtRTZ5dWowYmI3enVw?=
 =?utf-8?B?OEpGVjhHT0VNRlYrZlRXSWhSYWcvVElwQmJ1a003S2U1VGZEeHVyMDhZR3g0?=
 =?utf-8?B?ay9hS2gxbzJHbjUzUXl3QXBUMmdXRGh0dytYdHA2SENCN3UrZmhuLzZ5OFRm?=
 =?utf-8?B?L1JRMSt5YVZoemUzaEtzVXVSWjJQck8remcxYUVhekhRSExoQUUxWEdxb1A2?=
 =?utf-8?B?SnRhMFMzYXlSTlZkbkMzTXZFRVBzZVNEWVJHQVp4MzZoRUxhUFRSOHNuNDdV?=
 =?utf-8?B?UFpyQzZBTTNvOEVZOVYvQk1NTVJDTEcvamxIM0lSR1BuQXRWalVrY2VzVjVr?=
 =?utf-8?B?dzZSNFV2eDZXdXpGQytkRnYrN3RoMk9LbnhCcEljT0tONXY2K2I3OE5xS2VP?=
 =?utf-8?B?WExZQlNFMk5mMFY1MWxaMEpxWVV6azlmQjNCSXhQODJ0SkxxRUlWbzdYK0xR?=
 =?utf-8?B?SnFldjBKTzZ4c3c5K3V3L0hpczkrM3p3VS9SMm1XNTM5Wmt6N3l1enJYdno5?=
 =?utf-8?B?Z0hXZGpGRkw1aGY5VXNwVE1MZG9YNWJQY3lUaGFUN2RoZXQzekM1THkrNHMw?=
 =?utf-8?B?Q09mZ0pMQTJvL3FTMWg0TkU3SWw5dDV3d1VuWEtidnRQSjdtRFo0SENQQzJx?=
 =?utf-8?B?cWZ4cW9qaUNqeDQ0aGlmTGlOVWFxRGo5YXZYVXhodG1LYnM1eGl5Y3c0VFRY?=
 =?utf-8?B?UjM0Sk5HcGY3VGQ0K0FJUXAxNFU2UVJ5NGJOVFkwQkU5TkJYZ2l1cXl6SG1Y?=
 =?utf-8?B?Z1NJQzFVbVVlNUt2OVBFaUppYWM4MTBxVUxLbGdibVNRMGxGWDdJQ3lBUVRL?=
 =?utf-8?B?ZkhJK3JKMFhaSFVOUkZKcVRNem8vY1B0R0FPMGJiYWVoU2RQTEVFdmtYdis5?=
 =?utf-8?B?SVJPaEVCUVY0Z2FMYXlXem1LQ3JlZWVYcEUxZWp4aDYyOFZ6WDNDUHdST0tP?=
 =?utf-8?B?cmlGYnZadE5kZndhRjBuRHBGUlpyOXQzYmpMeVRPYnRVSTFMd1RZc25YL1hV?=
 =?utf-8?B?MEtWOGlSTGhocCtZL2lxWTBVSllRVTQ4L0VwbnljSnpKRmVzT3gwWEZFY1B3?=
 =?utf-8?B?K1RSaE80VzdEK2lxeGNqeW9sN2JrSUpBRTFCRlBaMEFGN2pqMFM1NFJsazhZ?=
 =?utf-8?B?QW1NMUp3blU2TDRmcDNkT0tWaldGYXQ4OGxSWGxxKzRWY3ZQdy9XZGR1b2No?=
 =?utf-8?B?UTJhQzdYcFRVdTkxMlQyaWJQNUV0NXRYK3UyQnpkeDV0QmJmSmgrUFpvS2NI?=
 =?utf-8?B?a3hoTmx3K0lyem90aUN3Mjl4YnNVSVZ1YlZ2ZkdXUUNJMTA0eHllU0RWYlpz?=
 =?utf-8?Q?ug3esT8c0qL4uC55AsUSWj8wX?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c6f5e67-1932-494e-3291-08dc6b1732c7
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 May 2024 02:17:36.1501
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4ug5lCEQmDkhXM1qga2HQAk1+RBA8b/E+a7ghwiv5dV2Y/BKoPLvCi5EJVcdsBP2xxqgAmx0vhXXHTV2txfFpQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR11MB6179
X-OriginatorOrg: intel.com



On 3/05/2024 12:21 pm, Edgecombe, Rick P wrote:
> On Sat, 2024-03-02 at 00:20 +1300, Kai Huang wrote:
>> KVM will need to read a bunch of non-TDMR related metadata to create and
>> run TDX guests.  Export the metadata read infrastructure for KVM to use.
>>
>> Specifically, export two helpers:
>>
>> 1) The helper which reads multiple metadata fields to a buffer of a
>>     structure based on the "field ID -> structure member" mapping table.
>>
>> 2) The low level helper which just reads a given field ID.
>>
> Could 2 be a static inline in a helper, and then only have one export?

I assume you were thinking about making 2) call the 1), so we don't need 
to export 2).

This is not feasible due to:

a). 1) must 'struct tdx_metadata_field_mapping' table as input, and for 
that we need to ues the TDX_SYSINFO_MAP() macro to define a structure 
for just one 'u64' and define a 'struct tdx_metadata_field_mapping' 
table which only has one element for that.

b). TDX_SYSINFO_MAP() macro actually doesn't support taking a metadata 
field "variable", but can only support using the name of the metadata field.

However we can try to make 1) as a wrapper of 2).  But this would 
require some change to the patch 4.

I'll reply separately to patch 4 and you can take a look whether that is 
better.

