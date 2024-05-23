Return-Path: <kvm+bounces-18025-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5ECCA8CCFFA
	for <lists+kvm@lfdr.de>; Thu, 23 May 2024 12:08:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A15B5B21868
	for <lists+kvm@lfdr.de>; Thu, 23 May 2024 10:08:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6AE713DDB8;
	Thu, 23 May 2024 10:07:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EkV0TZuJ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA0EF13CABA;
	Thu, 23 May 2024 10:07:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716458874; cv=fail; b=LQWhWmb8KJqzh6c7qUzPub/+q4i69fjqMtrZslw0KBd2uE0jWimkf5kM2X1TfzI71ZPWjx4nRXwCdGt0FER+pBWOzdpLGrjPeSrc/Hw/7yicZiZ7hKt7N5x1N5KXGldSwl1o+Zp2VokzjkpVPgtWJLWE2yxRRv9LPJmuTkl0h9o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716458874; c=relaxed/simple;
	bh=7rtsfnqsSyEfnytA5wfIC09fe6P2NhltNXDCUJMtv48=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=FNMeQOrTVRu5/7S8k4CS+7kFHRFhgEtTi1zSbXwT1Tqa3lZ0gac7s9tzEmpsuH1QpR2s62t4yaMHyhQ0L4Ay42PKfy2On5lBebrjY8L8yqgK9efyfmlxlcbEnkJYH6AC6xJGNe2PdS1RABIUt8TWnTk/s1B+WEaZ4hEccKg5CF8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EkV0TZuJ; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716458873; x=1747994873;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=7rtsfnqsSyEfnytA5wfIC09fe6P2NhltNXDCUJMtv48=;
  b=EkV0TZuJFBR7HAWn4ZOf5RH9H1Hkl/QO/qVt9dc0fwTxAe591G5jJYFf
   AhkWJE0q77jvUFki8vti4171TCMT594HZKK9nJkDTSoXWffHZ3CDRInlB
   sELnuKN5jSjYxO1z0LS94eGIi9EO4JjizD0rATKgfnF1JNwijoCuLSiMN
   fnMAdYs58r9fQxEs5z+M2auYQxF+d6digyc3ZsLgBnKOD17uGH+xDikBz
   mx/sTiFAtSoc77SP7/a/dL25COFXawSCM1+UXDJBahRAeKMZGuAKAWWZs
   NMkRpunYwa4SnScQlnFkLP4DNANDTNVxV85NKJkaJtqkbxhAe8Q+fJWEX
   Q==;
X-CSE-ConnectionGUID: ryis0BdLTa+nSK9NNSfLUg==
X-CSE-MsgGUID: SJxSMREqREOCw6iBZTc4Lw==
X-IronPort-AV: E=McAfee;i="6600,9927,11080"; a="12540163"
X-IronPort-AV: E=Sophos;i="6.08,182,1712646000"; 
   d="scan'208";a="12540163"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2024 03:07:52 -0700
X-CSE-ConnectionGUID: lqicGiSATrqIW9xSewl5ew==
X-CSE-MsgGUID: pFrQRVZ5QH6UP6nTX/ll0Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,182,1712646000"; 
   d="scan'208";a="38395624"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 23 May 2024 03:07:52 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 23 May 2024 03:07:51 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 23 May 2024 03:07:51 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 23 May 2024 03:07:51 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.40) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 23 May 2024 03:07:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RL1IK/wDHhHCtoM6SsOYgm541WbAZmxGyNTQWo7APYErmjTKleBz3d3m0k86CLrbeLGEdkt66OhsrD1K/jQEv56JAO+uyrcwvC+wJuuUKSYvz2fS86RyG3Y1zWQe6PDguc1iwVTAzEAwpClbLZGi+YIY0+Z4NuEbNfjjQuGTLlaC5aMb71aZN4V7tSAzwzHzh17cq6ZCTmsmcRpSenygQmniuBe7dAwRrW4AP8GUw5rQZgEM/Ccw54tEARwind2QsSUjhKm/sAPOwn9ZgweoiawRsBPNJKrpUCNE1D88ffnPjqPS0HtHcpXRE908NKy0BkL+6A7I8xly+XVA6b1YYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7rtsfnqsSyEfnytA5wfIC09fe6P2NhltNXDCUJMtv48=;
 b=lUw00qD7AjdJxebElRzfBTeS6qrAQ1FReLyvqYpOM/XbhID6hSIHCSpuZsY69oCp2ScqbMxrLf2kKkIGh94J+ujsA9KUZHb1CYjThGO8kA85jkRjJvV8PhYA/qlQW7C38GuZpPdbB67HLwGnZN/e40T8TM5v2wO/bd8Ya7X1HPMHyNd7gKcu4ZQc5vEgCgVQkKJdXLtXz2uAjB70yNx247eAkB+JCpYubbwjPPvATTkYmmY8suBXWluzDoFBJRVhTyRqHDByM1v6huZSX/OLvY59AaUUo2W5jzxZTrGJ4sOtUCFb78EQtYFQnd5/zZi/Yr4QVHfYHkk/e9G0jnsGng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by SN7PR11MB6776.namprd11.prod.outlook.com (2603:10b6:806:263::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.22; Thu, 23 May
 2024 10:07:49 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::36c3:f638:9d28:2cd4]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::36c3:f638:9d28:2cd4%7]) with mapi id 15.20.7611.016; Thu, 23 May 2024
 10:07:49 +0000
Message-ID: <a0e1a41f-e3f2-48f0-87f6-f065b5e5c0e5@intel.com>
Date: Thu, 23 May 2024 18:07:40 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 24/27] KVM: x86: Enable CET virtualization for VMX and
 advertise to userspace
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "Hansen, Dave"
	<dave.hansen@intel.com>
CC: "Gao, Chao" <chao.gao@intel.com>, "seanjc@google.com" <seanjc@google.com>,
	"x86@kernel.org" <x86@kernel.org>, "peterz@infradead.org"
	<peterz@infradead.org>, "john.allen@amd.com" <john.allen@amd.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"mlevitsk@redhat.com" <mlevitsk@redhat.com>
References: <20240219074733.122080-1-weijiang.yang@intel.com>
 <20240219074733.122080-25-weijiang.yang@intel.com>
 <ZjLNEPwXwPFJ5HJ3@google.com>
 <39b95ac6-f163-4461-93f3-eaa653ab1355@intel.com>
 <ZkYauRJBhaw9P1A_@google.com> <87r0e0ke8w.ffs@tglx>
 <ZkdpKiSyOwB3NwRD@google.com>
 <a170e420-efc3-47f9-b825-43229c999c0d@intel.com>
 <ZkuD1uglu5WFSoxR@google.com>
 <df5fa770-1f9b-4fa7-a20f-57f51b0d345b@intel.com>
 <12ccd0d3-e9a8-47b6-9564-7146d0a79f3a@intel.com>
 <40fd07cbd39c8c8911b2e46f2314f7dbf20d4a9a.camel@intel.com>
Content-Language: en-US
From: "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <40fd07cbd39c8c8911b2e46f2314f7dbf20d4a9a.camel@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2PR02CA0008.apcprd02.prod.outlook.com
 (2603:1096:3:17::20) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|SN7PR11MB6776:EE_
X-MS-Office365-Filtering-Correlation-Id: 510a4911-12cd-47e2-214a-08dc7b10334a
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|1800799015|366007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?NTRJUjBCU3ZubzFmZWZBcTdGTnFTY2xNTUI5bUVWdDZHUjV3clJ0eDJvU2NI?=
 =?utf-8?B?UWQweHNVVklQaVR5b2w3VlY2YVQwQkZUK2RlL2xiQlppVVg0bkJYK0t2c1px?=
 =?utf-8?B?SnZEenVUS3pmNG5hYTRJOFBqWXR2a1lFZ1B6aGlnTUlZSU5YeU1EOXljRGlM?=
 =?utf-8?B?OWU1OWVsaGx4NnQvWkNCVDVVTlI0QXQwOTdsRHFpVkpRM2M2WlI1NS9qeGYv?=
 =?utf-8?B?WmdJL2wxajdRZVRRZms3OGYyWmVnMEgzajBMTnRQYnNoZWNPWnUwYVZvbjJ2?=
 =?utf-8?B?Vi9qeCsvMkhUYyt3VTdwL1dOTnBoVk53cDVDK0R0V1hsQXNQTkROeVJkdkdO?=
 =?utf-8?B?Yk9VTXFid2tUaTQycjFVaUV4QmQvRlpzQjhYYW0yOUN3ck82YWY4a21LM24w?=
 =?utf-8?B?V3JxM2RnVENXZm1jOGdwWVJWeVJJN0tVVWxPalp4cXdTTjBFOUp0VGVaNVkz?=
 =?utf-8?B?YmpscmZRQ3pXV0JhL3RSUW1hVWJpL2N0c2lJYTRSVE5ITGpHRXNoZTRwMG5D?=
 =?utf-8?B?OXhDMEJOUms3bjJYTHZ0bVY5NE4yWlNQMkRHbGNTTmc5Q2UyWFBLdWhyWGlG?=
 =?utf-8?B?R2JrNG1ST2tzWFF5QmhucVNVSU84RFBlU1B1V3haeUFlUlEyWjQyOXNzd242?=
 =?utf-8?B?UEd3VUk3S09XQi92ekVic0g1RGhEbmI0MFRoL0ltSFVlUGhvL1FzK0pLVE4w?=
 =?utf-8?B?ZVFJMGZwUXV4MTE0eTRlMWNSWERhZjU2dmZBRjhQRFpMTmw5ZTVtYWE4WGNZ?=
 =?utf-8?B?Y3h6dC93UEZ3Ym9iRnRocWFhZXFpQU4za2QvekJkMnE2RDdETnBsUzZkUkpI?=
 =?utf-8?B?L01VY1VrZ1VXZzRnTjkzck5pZ2xWd1REcVNPaU5ZeG9zVTczWkdyQ3g2WjZx?=
 =?utf-8?B?bldXM0RSRVdsbEx5TWtJNG5sclVKMzdrVmx0M0RCM0JMVnU3Y0wzOFk5b1NQ?=
 =?utf-8?B?R25FNTEyN3BoYXlCa2xqQ2FqWExxUEg5eEhBRG9XTkwxRG9jVW5XeDB4K2c5?=
 =?utf-8?B?TW5tNXhKdGh0Q0FvQ0pVV0hOVUFJbVhFVzdSdlZHYUpIcnRhYzJ3WldYeXht?=
 =?utf-8?B?UmtRNndrMkJxN2xvRVY0cVRsV3RYMFBENEdFd2RRTU1FWWZIWXBTRlArdGJU?=
 =?utf-8?B?STEwSy82eE9SZWtjcVhDcFhVaDBIWFovcVJHRnB6eFRZbnNoQnpGOGNOWkNB?=
 =?utf-8?B?U3paeXNUb0trdklwLzdNMTc1VUZ0dTdLT045Rk1JMUFZVHdEQi81VTFmWmJr?=
 =?utf-8?B?aHVUQU5tQi9GYWFGUGpuRkU0ZzlzaTdGNURKQVBSZEZmaHBrWFNDTFZHQkE2?=
 =?utf-8?B?RkRMN3ByLytvM0FNQUdGUE1JS3JnTy9idlRTSGEwcXlPOS9iWk9Da0NtRE5U?=
 =?utf-8?B?S2MvWFJrQWR6WnNQQXAyODJRc2dqd2xCU0dnSmZ1SHBGWmd3STRLZ3ZnTVFX?=
 =?utf-8?B?QWlGdisxQ3NEZ0premFyWWFZcVQ1VHhSSmJRWWJoaG9lckNmQXR1MEFqUVE1?=
 =?utf-8?B?REwrKzU4eEFLMWZjelEzbHo2U0duc0FGVG9PVGxKcTRiWHZ5WTZrQjFQUGJa?=
 =?utf-8?B?N3V0VXdWbjZmUEw3V3JlbzRCSy9lNjNTMnhtak9qemRxT3RRQnF3L3o1SHRS?=
 =?utf-8?B?OXFtQnJHQzJGTE1rVC8zcmF0aGR3VUFnbmRDcHpoWTBuVDZ3WlhidXVLcVdo?=
 =?utf-8?B?ZjdBaElMUzZScko5eWYvMUcwSm14V1lWcHdzRUQxTUthdkRjUkZPdUlRPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cUIyQWNuRlJhOENPQTc4UU4zM2d2cElHdi9zNW5YQ2hSRHN4bG1FbFlKV2lG?=
 =?utf-8?B?S3hsWkhhZldrc281ZjRoNC82U3dMQitwRGxla3Bud1Q1L21hV0lXYlJZM0k0?=
 =?utf-8?B?MzNYRytESzYzVnJBMUMxajlhZ3NrRFNubFd3MXVuZnRvbFZ6TTlUNWpjRXdF?=
 =?utf-8?B?cUExQ0xiZGhsUW5mbzJ4Z2lVUzZtZUkyV1gwaWIyS09kU2RTUk5UNkRyYlBE?=
 =?utf-8?B?SU0xWUxlSm1sd1BST0ptQ3ZWRlBkUG1LbHJjc2JZdXlkQTNNdmtjWmd4VVFo?=
 =?utf-8?B?MjhWMmxZUldjL3ZlZEZCeWJoM1lCOEpzSWFBU2NVeHIrOCs5YlFqVW5QOXB6?=
 =?utf-8?B?WlVybFFrZFVTTnFnanJJWjdLUWhCNHpXWDhGUGU3cXFzRy9XaTVHZ1lGN3dD?=
 =?utf-8?B?Y1AyZGxUL2FUdU40VzFYTlRTTk85SWg5Wkk2MEp6eVJOeWcvcE1OUVVJL0hL?=
 =?utf-8?B?TmlFc1NoN2hpTmFNekIrSVhTbnpGSDg4V25YaXdGa09MY0R5UzQydkJYSkRT?=
 =?utf-8?B?d2Jha21Yd3NuQktBVTdySVhHWkRrWlUvK0Zmc0dqQmJNME9BZjduQXBFdHlR?=
 =?utf-8?B?OW5mOXNvWHJpNjN4SVY3Z2dtdjZralB0UTM4Nit5WmY0bW8zWjFFZWhNRGZi?=
 =?utf-8?B?aSsyQ3VuTVhhREFXY1pSeHkwWDROeGxRaU9OVnVqVXF0TzJFRzZBRzMzWHkw?=
 =?utf-8?B?RFJiaHFGK29aek1Ud1g2VnBYQ256M2xBMjNhaWczQzhBVGVjSGZPeC9hWFFl?=
 =?utf-8?B?eHhENFp1M2FHUHJNbTBob2ZiNUZ2dFlCL2IzRUJ2bDJta3lMMUFHY1FERk80?=
 =?utf-8?B?TlY0Uld3d0hscXgvazVGMUdTVU5ub1ZmZEVaRzFFWXVaME5tZGxlUThtTkdz?=
 =?utf-8?B?My9hR2RDTTV5K3N3U0luNVBldm5Jb2xUZ1ptWXNnZ1R2Y1MyZ0NTb1FzaGE2?=
 =?utf-8?B?eG1WTStTMFFHd2lOU0F0ZVF6T3k3bjlMN1gwMFhMazQwZUp1UnlkM3lRVW9B?=
 =?utf-8?B?Ym1EU25JWXIyVGVLaUoxTUtJNG5TOVBGYUFjUTFWK00waXFKYUZ1b3lQYzRz?=
 =?utf-8?B?VzVaMitBcUNGSnV4ZEpSS28wMXVuanVmdGdlM2doNHdjU0NaTHI2WDhJYW9x?=
 =?utf-8?B?aDJvT2ZuWHVQNVJQZThTVFJrTUYvaHpJSUtOZmZKekRvckN2aHRlTlVZVm5p?=
 =?utf-8?B?ai96MjMwbVZRVGVCbTJmdkZHdHBvQkJzNmhBcGp4Zy8ycjcyT05Sb2JRRnZp?=
 =?utf-8?B?OVRPTlZOajI2aytqRjVGT05JNm8xVFhPd3NDSW5jVFFGT2NZSkRVOWRFMzU3?=
 =?utf-8?B?YVl0a1o0cm1EdUFENFUxa1pGUDhJa2k0bmRBZTlseXVRVGdTTi9WSHRzWEE2?=
 =?utf-8?B?a2pSdjNzZVVFUytvSjFLcW9XdkRrNHZvZ0hDVlg0eTNvdWpRdXYwaHdBVVZh?=
 =?utf-8?B?QXJVN1hSWUF3aGlsZnlPQkpUWkdrV2hQRjZaWDN3R3VLNFZoTEI0OTBUc1Ri?=
 =?utf-8?B?Q0h3Rkx6WEt2bmllWVAwVXRLWms4ZUxyR2NKc0NDM1Y1S0ZXd21vL3pVRFF2?=
 =?utf-8?B?YlB0S2l5VjQ4dzk3ZGtxdmQ4V3FNQkt6K3F3RGlzWnMxSWZLTkNCeGNHbVJ4?=
 =?utf-8?B?RzVIN3Y4RVYyUUtlekpWV3hoc1hCR1d4eGlMQzIrcytTeTBKZ0svUEludDRT?=
 =?utf-8?B?cDA1SzhBM08yOEpwb0RTMmpvQWdMTHpBRmhuMURoK0hBVFJESC9udGRRcTBq?=
 =?utf-8?B?S0xsM3lCMHZlZFNWaERVc1VFMW1adjhoRzRWNU40cEpnUjhvUEl2VGZKa0JR?=
 =?utf-8?B?bWE2alAxeHc4dWpicHZGdlJ2dzRuQy83eERoL1JkYTEvNk9LVDVXMXZ5eElt?=
 =?utf-8?B?M0NlMGd0dVVWSmlaVG9SYVpSekRVcHptL0tGdFRHK0d1bCtMNkE4eUROOTR5?=
 =?utf-8?B?NE10TXZCVjZvREhIWHBEVEVNaDdxY0hWWEVoSEVhU1FKMnorL2E3TzdTOG5z?=
 =?utf-8?B?U05mVUY4N0hxTGxSVjJrNXptMXNBTnBjMkk2NjZPd21QWFBxNS8xUFVRWUV0?=
 =?utf-8?B?Tm9odWZSWC9JMzJIdlQ5SStEWjBBMTJHSXlYSDAvdndGSHpWTi9YaTdjcEgw?=
 =?utf-8?B?bkRCdmszN3pUSXFnY0Vpb0g1MCtUZjZFSFIwckFPbmoyMXh2Vm4yV1A1VnRv?=
 =?utf-8?B?SFE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 510a4911-12cd-47e2-214a-08dc7b10334a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2024 10:07:49.3712
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f0JvHYTtwT2XuJHmFhv1pOgXTVjtxLy/RPyZxP2UImtTb/X9VZ6VFDuHLT3E/2zC1/qgNN5VzNjkJJnTb/e4Mw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6776
X-OriginatorOrg: intel.com

On 5/22/2024 11:06 PM, Edgecombe, Rick P wrote:
> On Wed, 2024-05-22 at 17:03 +0800, Yang, Weijiang wrote:
>> Side topic:  would it be reasonable to enforce IBT dependency on
>> XFEATURE_CET_USER when *user* IBT
>> enabling patches are landing in kernel? Then guest kernel can play with user
>> IBT alone if VMM
>> userspace just wants to enable IBT for guest. Or when SHSTK is disabled for
>> whatever reason.
> I think earlier there was a comment that CET would be less likely to need to be
> disabled for security reasons, so there would not be utility for a system wide
> disable (that affects KVM). I recently remembered we actually already had a
> reason come up.
>
> The EDK2 SMI handler uses shadow stack and had a bug around saving and restoring
> CET state. Using IBT in the kernel was causing systems to hang. The temporary
> fix was to disable IBT.
>
> So the point is, let's not try to find a narrow way to get away with enabling as
> much as technically possible in KVM.
>
> The simple obviously correct solution would be:
> XFEATURE_CET_USER + XFEATURE_CET_KERNEL + X86_FEATURE_IBT = KVM IBT support
> XFEATURE_CET_USER + XFEATURE_CET_KERNEL + X86_FEATURE_SHSTK = KVM SHSTK support

Yes, I can easily achieve it by removing the raw cpuid check for KVM IBT. Host side CET xstate
support check is already there in this patch.

>
> It should be correct both with and without that patch to enable
> XFEATURE_CET_USER for X86_FEATURE_IBT.

IMHO, given the fact user IBT hasn't been enabled in kernel, it's not too bad just discarding the patch.
I can highlight the issue somewhere in this series.

>
> Then the two missing changes to expand support would be:
> 1. Fixing that ibt=off disables X86_FEATURE_IBT. The fix is to move to bool as
> peterz suggested.
> 2. Making XFEATURE_CET_USER also depend on X86_FEATURE_IBT (the patch in this
> series)
>
> We should do those, but in a later small series. Does it seem reasonable? Can we
> just do the simple obvious solution above for now?

It makes sense for me, but I want to hear x86 and KVM maintainers' voice for it.

Thanks!



