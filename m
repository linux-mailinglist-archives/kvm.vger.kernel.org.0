Return-Path: <kvm+bounces-35454-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8BCE5A11402
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 23:24:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9BE851636F2
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 22:24:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06343212B0B;
	Tue, 14 Jan 2025 22:24:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="V3xGYiKM"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1850E4644E;
	Tue, 14 Jan 2025 22:24:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736893480; cv=fail; b=LSLuHudgrczZLExBfkQMpu+1rGDluSMxdJ/56UIFkm+jLNAic5mCxrdZbdieMJsZR0YWWXft7cf0qn4VLm5+PXGNVGrR7yjiloFmhfTqEudSMRbDkPRk322qle94aC9V12pm1kvD8tzOZZpKwFa4u6hCK58sw5JXNZMMUnJMsjo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736893480; c=relaxed/simple;
	bh=w1sJ/6Cpe+QHLTwEgNIIOIZh+iq9qz13MWmNpTp9V/I=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=aS6MJ+PoDsJlHpcCOCX+WF08txiOb5++DyKmld+4MDo26oHMECZWQi1OAmkqAh+Rp9xgK9DdKK5vdNiDutbQD86sepe43qjr+8borcPwDtfhylkK3+C1/kZuMDT/wlBAF1D9XHgW0JeYZqt59n1v2oBMaA2N1dzetYZVWLmTq6E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=V3xGYiKM; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736893478; x=1768429478;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=w1sJ/6Cpe+QHLTwEgNIIOIZh+iq9qz13MWmNpTp9V/I=;
  b=V3xGYiKMSlD2CIq67e53mZ8DtqYnKPABwuwj0jMbQlkIWIxGtyTtf09/
   fufkRPbp3BhBKLOZ79VsZMgdEPk25aIgJOYgZZtAbLIBaaRNdraZ7MTZ2
   MH9KBKszwqFc+vFXAsQmm73Hw0n6xsntVCo8rccAqO9v6HmUGbTMaVUzB
   P/LH7ALBiLFs8sysB2q1eE/uojo0eOUQU8mZzKHLZMA7qku89ZDr/bvF4
   OwVI2sZzTiykCuoL/hqJ7Wr+r1JBUOVX3yALmJC5/tHsFV4EV586BfySP
   /4EVk8S4kcUjJPVECyZxQfYajsB0bcCPmYqEsNhqxaxuQbZtL/SU+/VU6
   w==;
X-CSE-ConnectionGUID: 3yBCsmz7TyuSO4Al+N+GSg==
X-CSE-MsgGUID: 1hiaUHo1QVWSdXbfh46Czg==
X-IronPort-AV: E=McAfee;i="6700,10204,11315"; a="37236983"
X-IronPort-AV: E=Sophos;i="6.12,315,1728975600"; 
   d="scan'208";a="37236983"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2025 14:24:37 -0800
X-CSE-ConnectionGUID: fMZxRdXGT9GoLgfOLlrEwg==
X-CSE-MsgGUID: l+zPHccFTMWYPP/ecJAPQQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,315,1728975600"; 
   d="scan'208";a="109912222"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 14 Jan 2025 14:24:38 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Tue, 14 Jan 2025 14:24:37 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Tue, 14 Jan 2025 14:24:37 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.47) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 14 Jan 2025 14:24:36 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zLrohGk2TMXE+FIRAlRZtwqyK2qKeWndZkh4RQ5mh6nk/4W6WNrCXLAjfDDkrbPGJkJOM+paLvh/2AF46FoLA/DJfIgiBGCUjiaasCdU6nJsvswXFUn94FdX+2ltha46R/6wo3nsfl1bdUu56SDY2/IxWcp/AoE+jcno2z/5fPilbqTFsutKmuxLHE4Vt8xeVJxrbqjQcoXPkJZCJBQRraCsxJOE/W0nWdI+0GjkVaSOGKzhswjOB34ORDALMig17r7CH9uPlmh3DM8X7jBi8Lqih1XNWtIR7YIgKWtVr8JyUkLf06RJjPfAhEmNsnqlPo+nW8hvo34+8lBIPJPIjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w1sJ/6Cpe+QHLTwEgNIIOIZh+iq9qz13MWmNpTp9V/I=;
 b=lJYbtAd8gWkK5yCE3+cFLk0g+IC02SotBuwJOmepQQILljGUmHCYTidRh+Fh4sn59J8tDaYkVZm8mT71WXe09xQp0GKnLD3PNBc68858ks/85mNmpsshv592YxiMdRqFg2aDRtdT+ggFQ9VGtSp4nr+rOioA9lW8iEvXc13rxGHSglagce94CHmO14WdMrUmWmxTIUMh1ihlpDObUrDyfqYwDcmYvnq6aJM6yw+qgdUq+XWcrxcaiYjaC8j2/M9/Ue9lVYRhWYAB+y8gtyMpOrW1tUXutHdFL5wfw9OZzooTfgmDw6YpJNFm5zYdGBgecMNmDspnXJnsjVsYujyTUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by CH3PR11MB7674.namprd11.prod.outlook.com (2603:10b6:610:12b::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8335.18; Tue, 14 Jan
 2025 22:24:34 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%6]) with mapi id 15.20.8335.017; Tue, 14 Jan 2025
 22:24:34 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>
CC: "Huang, Kai" <kai.huang@intel.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>, "Lindgren,
 Tony" <tony.lindgren@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "dmatlack@google.com" <dmatlack@google.com>,
	"Hunter, Adrian" <adrian.hunter@intel.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>
Subject: Re: [PATCH 1/7] KVM: TDX: Return -EBUSY when tdh_mem_page_add()
 encounters TDX_OPERAND_BUSY
Thread-Topic: [PATCH 1/7] KVM: TDX: Return -EBUSY when tdh_mem_page_add()
 encounters TDX_OPERAND_BUSY
Thread-Index: AQHbZWCEcbjI0YDf906fkCsNxskz07MW22qA
Date: Tue, 14 Jan 2025 22:24:34 +0000
Message-ID: <9b34f2a0ce2b530efbb12c03f1b40ccf33b318dc.camel@intel.com>
References: <20250113020925.18789-1-yan.y.zhao@intel.com>
	 <20250113021050.18828-1-yan.y.zhao@intel.com>
In-Reply-To: <20250113021050.18828-1-yan.y.zhao@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|CH3PR11MB7674:EE_
x-ms-office365-filtering-correlation-id: 5301c075-99ea-4ca6-5b7f-08dd34ea3965
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?YlhEdlFVL2ovVzhucHNWZElPYk43ZVNPeHhlaVpFc2t6cjdiVkJwNktlQ2tr?=
 =?utf-8?B?TlUyN2ZGTFl1Y1dqS2t5Y0w2cGJLODI4eUpLWllIT2NpY1pINm1wa1ZDWGFq?=
 =?utf-8?B?SWhMb0tUZUFuZzBmTVc0dmVBUmhVdXpvaXdrMWVpb0FOa21YT2w2YmRBWXZu?=
 =?utf-8?B?a3VYSDVHUkIvQzNqSmIxenMyaVhsc2RWc2srWHVXYjhUVTNra2tSazJYS0tQ?=
 =?utf-8?B?MFB6MlNkMjZ1QTJWYXI2eHREamJLcTN3WSszV0tCbjZZUmdxeGwySHZiNE5s?=
 =?utf-8?B?MlFZZWJwWnlQaWlucGxZbldsOUVNc2lVTTRuQTZrWW1BbGR0K1FkcXBoTjRF?=
 =?utf-8?B?RkNFVTEwTjMvb2trVjR2SVlMaFhsQTc1d01Ldkc5NDRMRzZhdmhIVWdlZEEx?=
 =?utf-8?B?czFoMDVQVSthZVpscXNLdkpKWmRiTVM0VkNJQUlGVHZtV2RCZlhVYjY2MWds?=
 =?utf-8?B?bVRscE8xdGh1VkJ6YXJWb2JWVzRwampuQWd0bUZVdVpaelh5dDJ5YTc5ZWUx?=
 =?utf-8?B?QVM4aW50b1doTU1QMnpyZDVHZFd1N1A0dTdjWVFkdm9OSk04c3c2OGNhR0R5?=
 =?utf-8?B?ZGdXU0dPWGwyTFVIeWxKMWwrd1JxRUVCckVzZ2pFRExOVmxWOS9xc2ZNMzBu?=
 =?utf-8?B?dkJiRE1Ka1RyNnh6K3phNGMrTHVJN09pVU9NL3B0WVNGUGxIZFpjK1pmVWE5?=
 =?utf-8?B?NWgzejRiOHdackgwNHJGTUdjSG04NDlDZElFWVhYLzFEL09mVmFGY2VhVnRK?=
 =?utf-8?B?T0lpeTJhNjd3dEtzb2NlOWQzYjdrcW5HbjhXaEw5TnVPSVk3UGFITXpMZTB1?=
 =?utf-8?B?MGRCQmVRYUxNWUovQzZCQUsxVUIxTUNSS0p2bkhkOFo0UnREUXRwSURRRGFI?=
 =?utf-8?B?OS9DVkp3YmtkRkkxeTNwS0dlalBQWXM3a0ZoSGNzNkw4ZmdqeDR0V0xQSWk0?=
 =?utf-8?B?VHozQVhkOGtpalNDRTA1ditvdmNFNHVzVjlzMlFHNXl5enNjMlpJMWdvV0Yr?=
 =?utf-8?B?bzcwWGt2RFlVbDJFb1lkS25tS3VKUTEyeTFWZHZScTRHQlVjMnpvRkVhNG83?=
 =?utf-8?B?RnVTN1QwQVRzREtqWTZJSXdBbExqK2pTT3dwNzU0YkFFQlF1ZXo2QjlpQTIw?=
 =?utf-8?B?a0JyMXdVdVVSR3djSWtBUUwvS01BQkhZWWJqZTZGdnBmUjhsSWJBK1F0eVM3?=
 =?utf-8?B?TXV4Q1JYM3M1YXN0Zlp5WnJ0d0I1enlPakwrN21BM0o1eWFkdmVQUkMwaTMx?=
 =?utf-8?B?aGRwenQ4blB0aFlKSXJkeW9LZ3Q1Ukt3d0tsWGtyMWpUaUhXS3dncmtQMzJw?=
 =?utf-8?B?TEdwODZIS3I0czlZUUNkSkc3Nk9OOHVGaEdZWis3cmEvMENWMkpwblR4VDcx?=
 =?utf-8?B?MjhZYkszSlNPUjZNVWVsOVpxSU5CMFFLUlBzZTBTWW5NK2xKMTh2b2NJeXUz?=
 =?utf-8?B?VkZwVTNpTEFIWjQwbFBEWDJ0TmVIV2JRbWN4K203UnUwUzNnS2tWemgxb1NO?=
 =?utf-8?B?WmwrczFyM2lBNE5wR2hiSlcrc0YyaGZJd3UzeGp6SXc1a2pNWC9tSlp2RWxh?=
 =?utf-8?B?RUhSTGZTMlNLSVNXNmc1UjAwWllDYUZ5cGNmNkJWTzJIL005NnFtN2dmM3Yw?=
 =?utf-8?B?ZnduL2F4d3ZoT01mKzZFRUpNYk9zeU1lQlRoeTl6LzZGME5uTUJqSGNiR2pj?=
 =?utf-8?B?OXhIT3h5aWFzb29rVmV1R211MU5mS3JJc2pBckM2SDlhTUxwMXlFelJTbGpX?=
 =?utf-8?B?NTc0ZnZWOHNOWGN3aUhZRC93QzR0VllDc2pIMDd3bERSMElJNEs2QkxuNU5Z?=
 =?utf-8?B?LzQvYUpuaWNwOHBBR0REK2l0Lys2UlNXY0k0RkJibVVhbktLcVdwNlhtNk1q?=
 =?utf-8?B?YkRNdTBISmhjLzc2NURSUEM0amNLTFZRaU92QXR0R2c0Z2JrbEZna3hRRzJF?=
 =?utf-8?Q?6ebP42ATRGkAExywg/mlRB4oUV6Mg/pp?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bTlHVDNmeDJLTkZrSFE2RFJIQjFKTUJqYVRkelBRdXBJYW5ZVXJVYkNiOGs4?=
 =?utf-8?B?VHIyYUU1VHNNNldFQ2dKaUt4aDRzVDNkZUM5WFhqNHd4R2k2Ym9yVm5rNjAz?=
 =?utf-8?B?UVl6aGRqTmpVdytvek5KOVZUNXlLOFJoYk1aNU5wY2d0SElHM1Q3Qzg4MENT?=
 =?utf-8?B?cFIrZHkzS1hjZ2hQWGJvVG9mTlFJMUlKV0lSY2hQM05aYVV3QVN5L0lKQmFs?=
 =?utf-8?B?YVhEWldpUUt2c05XR3c5Z3RWS05ybWwzUHk2MmM3alVrNGd5TEQ3NzV1c2Iv?=
 =?utf-8?B?SGZ6MU1zZG9hNy9oUzJmS3dpTkh5VWdSclZRTlpaSnZEOC9MeVRQVHBVSkZB?=
 =?utf-8?B?dG5NMnB2bXNmSVY2c0IvcHUxRmV6SGtTeEd2QlNBWFlxMEVyTy9Xek10UU02?=
 =?utf-8?B?RkNsZ3o0eVE1anZoSGUzUzlWVHRxdFZDdm1FeEk3LzFBSThBcjdGUWFlS3ow?=
 =?utf-8?B?RWtoUm50MTFYeE92bGpBNUxIWFRrRkhMU2dKVE5yWDA4MGNEUnJkOUd6UllL?=
 =?utf-8?B?ZVVqZ2RUQTkyNFNkU29SUmNwU3NsUG1xZ0FhdXRiTnlOWHBwVWFSUVBPUjVO?=
 =?utf-8?B?TWlmSFJCejhpQ0x0ZC9FWUR5RFFXTllnRmpiMVdmUnNWeE9iZWJaSnpGNTJR?=
 =?utf-8?B?bWh5N3hodnB5Nk5Pb2hNNGdEYk9tWDUzM01HdzRLQXljTVFKRVhqKy9OU3pm?=
 =?utf-8?B?UzQ5TFlGWGcxK0ZOZXZnYVA0Z0FuTFdXdEpaaWdrNjF5N3p4ZjZpL1M0N2JM?=
 =?utf-8?B?bzRBU3dzVks3RjVULzNaTzVvTTdBdmRLMkJ3RFAxbWEvalo0c1JZampXRHZF?=
 =?utf-8?B?MVU0djgzQ0p3aDhqL3NlVktSOTl5NWZmTkM1N081MkhVUXJwZXMycXI1eXZC?=
 =?utf-8?B?U1REdzBBY0wzaXkyaS81ZlBNZXJaamVWOGp3b0t6ZFp3RWp0TjBhUTIybk1V?=
 =?utf-8?B?V2lQZFdFcWpNNzFvSDJBYitJYldWN1d0Q3lTb2x3aWk3Ly9zWGhtSVFkMHU3?=
 =?utf-8?B?and0WXllZ2JvVkRnTmtselR0eVZFZ1J2bnlKcFhLYzhaLzB4SzlWRVk4SVBM?=
 =?utf-8?B?MlpYZ2JTV3R4bnlpd3I3Ti9SWHlQNHR6ZEdOd3lJa2tSN1M3cnRDQXowdldS?=
 =?utf-8?B?YThGRFQ5RmI2dVdiRWFxdVRVanVTRGJKS2k1bGdjN2V6MUxiWXM2eWREZUxs?=
 =?utf-8?B?Rzg3MUdxNFpTWTA4T3ZocE9aaUMrR2VVY3JRR0xHVjlLcExWbEdxc3N6L2NO?=
 =?utf-8?B?YXFtdTlPWCtIaDlONmRrci9uRzZUUjhxalpEaVhiMEEvOWN4emZuakJCU0Jj?=
 =?utf-8?B?N1E1M1E5aVBhWnc1UXJEeGFTSUo0eEptNWpQczBSdHdpVkNNQkdhaUJQS1U5?=
 =?utf-8?B?MGh5cmtqUFdQQUZsdTQ2b3JGenFzWWhwRmNGYXRxcVhzZjk1UmJyU3RrVmE5?=
 =?utf-8?B?Q3BmUWU0L0JkOVI0TzRnU3VNdHJ5NFpNOHhyU2ZkQ2VhWFo4eVlRcXMxdkNa?=
 =?utf-8?B?bmc5bm94Vmt0dGY3dmtEZmpWVmhCRk1HaXFaSWU5OUxSOEpzdmgvSDhNOTJy?=
 =?utf-8?B?RlFVUXVjaG5vUlNVZDNHUmtLenROVFRrUG1hMGwzRUp2bklIUzVmNlFzdm9v?=
 =?utf-8?B?V2YvRlBNaEZpeEMxRHk3clBoSVJpZkl5VktidUxVNWlwTEREMUxpVDB0NEJu?=
 =?utf-8?B?ZFNoNytWYk50L3pMZm45Sm1EUUNZMVlwSFNVb3ZNK2F3UHJhT1dYRE4vSFBL?=
 =?utf-8?B?QkFQQ1VtZHlEaWQ4aEl3dW9ocUpZZXVNeTlXOFdPd2ZZbW1JRVRJdHlrd0Q4?=
 =?utf-8?B?U1lqcHVGbzhTYUczTXp2dTV5aG55WkEzSnBJYTUzN3FIanFpQWpGNHRWbkVP?=
 =?utf-8?B?OTJrdzNFMVk3U1pPT3BtN1kzUUttb2FkTGgyZVJHOEVjdXluZDF0amtZa3B3?=
 =?utf-8?B?Z3YydjZ2aTdKMVpjelpKNGJoVG56WGpiODBOWkZUdHJpZ1ZsNHpUSlBzNlBL?=
 =?utf-8?B?WllmWmN6MzNvcFNjMTBMUnA2ZThsNzk1ZVZDVStjSDhBVlVmYit2VWFxTTBH?=
 =?utf-8?B?ODBDSnp0ekRBRjJQa0R6Zll3TkZvbVdEbUpTL2c1cmdkYXZMbHhTZjM1MXpJ?=
 =?utf-8?B?cVozenBVTm5hT2hSdGMvaTdMRWtlV0pVUDBoTEVrTHg0Z2I1aWppRy9FbFBG?=
 =?utf-8?B?Mnc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <242E0E842C1D9D408439D13BBD0BA91D@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5301c075-99ea-4ca6-5b7f-08dd34ea3965
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jan 2025 22:24:34.5972
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nJHfVRwK0HOT0KhQp6EmS0Dpo5nLYuKThdF+hTMx6/M8wFGX4ALk1EIpspfjfY3fXHMrIzvMz1OH+OwJsMnE9UZYeY9EMTkyItiekoBr8lg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7674
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI1LTAxLTEzIGF0IDEwOjEwICswODAwLCBZYW4gWmhhbyB3cm90ZToNCj4gZGlm
ZiAtLWdpdCBhL2FyY2gveDg2L2t2bS92bXgvdGR4LmMgYi9hcmNoL3g4Ni9rdm0vdm14L3RkeC5j
DQo+IGluZGV4IGQwZGMzMjAwZmEzNy4uMWNmM2VmMGZhZmY3IDEwMDY0NA0KPiAtLS0gYS9hcmNo
L3g4Ni9rdm0vdm14L3RkeC5jDQo+ICsrKyBiL2FyY2gveDg2L2t2bS92bXgvdGR4LmMNCj4gQEAg
LTMwMjQsMTMgKzMwMjQsMTEgQEAgc3RhdGljIGludCB0ZHhfZ21lbV9wb3N0X3BvcHVsYXRlKHN0
cnVjdCBrdm0gKmt2bSwgZ2ZuX3QgZ2ZuLCBrdm1fcGZuX3QgcGZuLA0KPiDCoAl9DQo+IMKgDQo+
IMKgCXJldCA9IDA7DQo+IC0JZG8gew0KPiAtCQllcnIgPSB0ZGhfbWVtX3BhZ2VfYWRkKGt2bV90
ZHgtPnRkcl9wYSwgZ3BhLCBwZm5fdG9faHBhKHBmbiksDQo+IC0JCQkJwqDCoMKgwqDCoMKgIHBm
bl90b19ocGEocGFnZV90b19wZm4ocGFnZSkpLA0KPiAtCQkJCcKgwqDCoMKgwqDCoCAmZW50cnks
ICZsZXZlbF9zdGF0ZSk7DQo+IC0JfSB3aGlsZSAoZXJyID09IFREWF9FUlJPUl9TRVBUX0JVU1kp
Ow0KPiArCWVyciA9IHRkaF9tZW1fcGFnZV9hZGQoa3ZtX3RkeC0+dGRyX3BhLCBncGEsIHBmbl90
b19ocGEocGZuKSwNCj4gKwkJCcKgwqDCoMKgwqDCoCBwZm5fdG9faHBhKHBhZ2VfdG9fcGZuKHBh
Z2UpKSwNCj4gKwkJCcKgwqDCoMKgwqDCoCAmZW50cnksICZsZXZlbF9zdGF0ZSk7DQo+IMKgCWlm
IChlcnIpIHsNCj4gLQkJcmV0ID0gLUVJTzsNCj4gKwkJcmV0ID0gdW5saWtlbHkoZXJyICYgVERY
X09QRVJBTkRfQlVTWSkgPyAtRUJVU1kgOiAtRUlPOw0KPiDCoAkJZ290byBvdXQ7DQo+IMKgCX0N
Cg0KU2hvdWxkIHdlIGp1c3Qgc3F1YXNoIHRoaXMgaW50byAiS1ZNOiBURFg6IEFkZCBhbiBpb2N0
bCB0byBjcmVhdGUgaW5pdGlhbCBndWVzdA0KbWVtb3J5Ij8gSSBndWVzcyB3ZSBnZXQgYSBsaXR0
bGUgbW9yZSBzcGVjaWZpYyBsb2cgaGlzdG9yeSBvbiB0aGlzIGNvcm5lciBhcyBhDQpzZXBhcmF0
ZSBwYXRjaCwgYnV0IHNlZW1zIHN0cmFuZ2UgdG8gYWRkIGFuZCByZW1vdmUgYSBsb29wIGJlZm9y
ZSBpdCBldmVuIGNhbg0KZ2V0IGV4ZXJjaXNlZC4NCg==

