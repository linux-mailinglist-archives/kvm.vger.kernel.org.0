Return-Path: <kvm+bounces-23585-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E48C94B316
	for <lists+kvm@lfdr.de>; Thu,  8 Aug 2024 00:33:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0F0D91F2314D
	for <lists+kvm@lfdr.de>; Wed,  7 Aug 2024 22:33:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 986E91552E0;
	Wed,  7 Aug 2024 22:33:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KAw0jKiL"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE088364A0;
	Wed,  7 Aug 2024 22:32:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723069981; cv=fail; b=qRPnmTnjYu9fL0JS2+lhnMGfVb+cf3GQtcCwdJId/fs16k0jMYX87noXjaha0KDhSdI444izR65W12UaB4KzYnxvRTtFLmIQdT/6yXfzQqs7kwPzPk9yjfST8fRcEpPovb5r24RCK5G1yG8tt6N/vWkeLIETa4kEVni0BQWZWsk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723069981; c=relaxed/simple;
	bh=Pw5FnqTYEW+Y0HQY4Fk3O6J44lUnq/WoUjnmbSpJe6c=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=kIsacxs8aOa/SIz6H0WbBmFC4LRDfzlOrnm//nj908a+Wjz4fMWVvThIOdLeBUPLsTfh81qVB3gBHdrW9ZM1EsuC3gjXSIClXDTWkYb7PhEfLA8lCyWgugAReCoktz/N15IltgaRTs7xnFdH96E8meZPYIFJcK+W2e88IWDN8fY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KAw0jKiL; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723069980; x=1754605980;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Pw5FnqTYEW+Y0HQY4Fk3O6J44lUnq/WoUjnmbSpJe6c=;
  b=KAw0jKiLuLA/EqUvSZvYfsBwwqqWhj0nbeEDqtAQZ+CSD9lYIfVTE3Tn
   2AnCj9SDuNGkwx3HTLRLxRkT1neUBruKJKUdLE00pdhhLFUiyuhFKsvwj
   t7ocUMElT4ewr0/Z48o4bjc5/kwq4AtmqoW/dV0VodzXyxGoCIUVEgYXQ
   25Uj653TCauBwQVvjPIzSXLHqIDKb0hfa/GDZ9qBZzOxG16Rqv6cuN4HY
   J8YFhKtbZ3scCCqB+pvr4fNuRUth2RaQrtwFHj91nHDCAstIFMlDk8434
   B85gvgvrpGO8GMB8Csw38Qahdy5WoYkfpQcFad16xj0+9NyVyv4UTDQC9
   Q==;
X-CSE-ConnectionGUID: h+g9PrVwRcKxktWxDmhyRw==
X-CSE-MsgGUID: cyo8YCFNQpK/ckSnpATryA==
X-IronPort-AV: E=McAfee;i="6700,10204,11157"; a="21330206"
X-IronPort-AV: E=Sophos;i="6.09,271,1716274800"; 
   d="scan'208";a="21330206"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2024 15:32:59 -0700
X-CSE-ConnectionGUID: EsG5YQw7SmOcI3g/doKQqQ==
X-CSE-MsgGUID: 2JLNcimwTQesNQCjqTpTmA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,271,1716274800"; 
   d="scan'208";a="56966991"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa009.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 07 Aug 2024 15:32:59 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 7 Aug 2024 15:32:58 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 7 Aug 2024 15:32:58 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.47) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 7 Aug 2024 15:32:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ekj4ElmoqYVlB3mEeA9aP4TYJHwJRMSj74Qj82zKPHb2BBovFaCALCQs+UGs4vqeLANDh+STEtl0HqMKuwvMzGTlJLGyHUa35jZGdKHR5qdc7iL690sotYcWv8HSK751AOHcmTGthArFNjTFAgEzKlLNqPdI43JuCH3qIbcuqPOpufbG4Z2se0vSNoZvBT7JMyLISYoR4JB+wpt1nY6DR7qMwUOldiI3odjxVkHpxahonyujr0WUnsLJLG8rh4VRZWeTW3SUcGHlOUJ2RINAXjqzNls3eJj6E9xRqy4jp1VcafKgD75MSxmR/qNlu8OSISx507zKIU3kQKRN1AXjAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PlcVuXgqRveslBtflwEGc3Ww99KULbOquglkofy9zuI=;
 b=ujs2PFurpYjQHG+aMfU3RrsmBeuV8JlupDawbpKSxB6w8H/w1LN6RzomDtJN1luKrulL7Lhw3vsdorwcUXGb4g50xGza1Cyjp9ZnGKBa9HWXPx8YOzrzG/3YKS08RfajQYDvIuFZxQoUWgNOoptA8LrHgnPCl8Vta+sh/siaEPTw4nX1JFRFDgt5Q2QLkDPW5EEeK3Uum946AvbqqEdEATYoDHbdXN1FfD9HAz9DjtoOv0U6HrbBEjOmn2BZWTdUSBe2KB8v13/X7LjU2N1mjkJqfF2uf49+HdESxyueHvPmnWXb9lrTQFmP5AHJTM8OlQIheMZy1Dv8+X9KUXw6bA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by MW4PR11MB6811.namprd11.prod.outlook.com (2603:10b6:303:208::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.21; Wed, 7 Aug
 2024 22:32:56 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%7]) with mapi id 15.20.7828.023; Wed, 7 Aug 2024
 22:32:56 +0000
Message-ID: <179f9713-29d1-40db-8cfc-7a7596f73859@intel.com>
Date: Thu, 8 Aug 2024 10:32:37 +1200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 08/10] x86/virt/tdx: Print TDX module basic information
To: Dan Williams <dan.j.williams@intel.com>, "Hansen, Dave"
	<dave.hansen@intel.com>, "seanjc@google.com" <seanjc@google.com>,
	"bp@alien8.de" <bp@alien8.de>, "peterz@infradead.org" <peterz@infradead.org>,
	"hpa@zytor.com" <hpa@zytor.com>, "mingo@redhat.com" <mingo@redhat.com>,
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>
CC: "Gao, Chao" <chao.gao@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "x86@kernel.org" <x86@kernel.org>, "Yamahata,
 Isaku" <isaku.yamahata@intel.com>
References: <cover.1721186590.git.kai.huang@intel.com>
 <1e71406eec47ae7f6a47f8be3beab18c766ff5a7.1721186590.git.kai.huang@intel.com>
 <66b1a44236bf8_4fc72945a@dwillia2-xfh.jf.intel.com.notmuch>
 <ccf6974cb0c0b30cd019abf195276c2e1dff49a2.camel@intel.com>
 <66b3ed82a47c9_4fc72943f@dwillia2-xfh.jf.intel.com.notmuch>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <66b3ed82a47c9_4fc72943f@dwillia2-xfh.jf.intel.com.notmuch>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0037.namprd05.prod.outlook.com
 (2603:10b6:a03:33f::12) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|MW4PR11MB6811:EE_
X-MS-Office365-Filtering-Correlation-Id: 03ab703d-c280-4fc8-f467-08dcb730e21c
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?THNyNDZ0bHU3SlQ5akxIYlpwM0tsTkpFRjU4ajI3U0w2WFR6dVhBUWVuWC9P?=
 =?utf-8?B?VG9Rc1V2ZCtvcFprK0tOOEtRdmVmcVpXS1pUbkdpY3RXRFhZMnlRYTdxL05x?=
 =?utf-8?B?TzBQWmNGb3ZTd2FjOUQyNzg2VS9IWVZXTXc0YnI5cXZlVVVrRWxteXh4RHZv?=
 =?utf-8?B?L2Qyd1hqTnk1K0tRZGJ5UDFESDdmU3FkYWVUWkhtbk05VVRjUDg2Qm5STUtI?=
 =?utf-8?B?aGdUVXIrRXF4cGFsU0IyQzhEWnhPWjg1dCtiT2NSV3lLYjl5ckhibXd6bHRu?=
 =?utf-8?B?Ym5mTnVhbXBPakthWDNWWkdCRVoyczFHdXVMd05mVWc5TjIxYnJoUkFXeGZa?=
 =?utf-8?B?VTJ2aDdQYzFnQzhOamRVV25vVVIxK2syNmxhblVxNGp0T2Y2ZDY2N0FyWHZm?=
 =?utf-8?B?L2FFdFFUYWJTaGh3UXVCbWhENExoeGg1YUFWa2VpM0x0WHdBYnJsUlVZWTNE?=
 =?utf-8?B?MXJUMDNCakV5QmwycmpxUUtVcXRiNzhvV3hNeTJBcHpsUGVCYlpVOS9ydlR2?=
 =?utf-8?B?WHhxUzRScWlxRklGd2IzWk0zcks2UGZmOUoxeTdJeEhiaHU4UHpZNGI0bWhJ?=
 =?utf-8?B?enR3Z0JTSEJEbWQ2UVRjR2tZY09aa0cxcVgxZjVEdkNHenhadDRwVzhacnp6?=
 =?utf-8?B?Y1gvbFFWMHJaNGN5cUtwMXgyWGtFUUFscU51TzEwZjJtbStKM1lvUmhDNmNL?=
 =?utf-8?B?OURBalh3dzZLTlo2b3N2UmJMWWx5NHUvamFiVHhyVjFKT3k5ZUl5NTRVZmFs?=
 =?utf-8?B?bXgrUks2QTdBbU02LzBZTEcyaE9CVEdGVzdIWjR6aUVmVXVVbFRseFRKWjB2?=
 =?utf-8?B?alVWeFk3UnY1dXBnR3Rmak11d1EzMlZxZEpIekVNalpTVlpvSTJsT2NlMzVQ?=
 =?utf-8?B?TFlOS0wvN1MxSmVjMUNtMnV6eGVBZC9LSEduMVVDMlE5RDRYL1lKNjI0Y3lE?=
 =?utf-8?B?MXUwQWxnekFSWk1vNFRnVit1SG5QTDduUG9TTWhhUnpsQ3pMVFNvYS9VSCtB?=
 =?utf-8?B?SXVzZk9hZDZXMkVINDA4Rk9QcVlSU2ZiQXFhTjNCNnN3Wnl2VDNoc21saGN6?=
 =?utf-8?B?VitOMzZ2WHFzdjZOZG1wVlBXUVI4NXBvNzkrVzZPc1JoWlZPendlNUdzZTFl?=
 =?utf-8?B?NDhsQmpXU3hTNHJ1Y0hXVjBHT2M4VnZoWVZWbXNsWVhBWDUrVk5NQmFIeWlj?=
 =?utf-8?B?aG9FakR3NUYzaStsOWJYSC9sNFd2M0xOK0hCQlNqY0ZZd1kwaEI2ZVQ3ZHVo?=
 =?utf-8?B?cjBDUTFiV3ZwRjg0YXhTWE80MVNwQlhIbllIVG9rMkRTMFozWUYvSDlqaWtU?=
 =?utf-8?B?ejV1eVc5YVFxK2cwUSt2VlpkK3hKblErSENtREpoVTArSUp3U0dia3BYYVBH?=
 =?utf-8?B?T08xUFN1L2JuaDZpZ242L3JnWUdYd3RPZVBxQ2Y4MFY0WnVFNE1jV1ErRzlG?=
 =?utf-8?B?RXBjaUF5dDZqbkZVSnpLQmJkNXlUWUlsM2NTNlQwOEV2K1lRMVRSYzcxNkRK?=
 =?utf-8?B?dDBPdnlTU1d6TzhjNE9PMVYxU2c1RUhwRHhHbURVTXArL3pjK3NhMnRkRkQy?=
 =?utf-8?B?b1EwalVBakdYRkJhQjNBMXVNbFNpYm91OUNQQjVVRk5mWW5GQTNlTjVKalc2?=
 =?utf-8?B?eXhHamRkbzZIaDVoQjdRdDU5ZzJXZ2VKQnMwZ2lCcVNPLzJXUjFjeTluY3U4?=
 =?utf-8?B?TkxaK1ZoU3BrTS9mSlpPMDhHOVdyUlVIQ0hYZllkczh5UWVVTEJMc05UeW83?=
 =?utf-8?B?S3N6Rmk2MVY3M2NsSncrK2RqYlAzT1JUU21QQmtyQmJjMy9IWG00Mm96citP?=
 =?utf-8?B?VW1DSEZPN01jNk90TUwwUT09?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bGluUHdsVGpVaSs1aEdQMWs2djhuZ1JnNHNsWWdSSXdvMkt6RkNSMzFaeVBC?=
 =?utf-8?B?OWFCYkE3SEdpM1YzcDlKRERqMTdxc2d1dkIwaWZyeXRaV3VpZCtYSHZuNnk1?=
 =?utf-8?B?MGcwWG83UTNKaGU0TSthdmxwRkd4eTRjNGFtc0cxcGpIQkgyalVmdlJmVGRT?=
 =?utf-8?B?bk04dTBaOXhaMkZVc2lPbkU5RkpXd3VNVE5FR1FyR1FuMkE1SWg3N1lhRXAx?=
 =?utf-8?B?Qk94dm1WN1JFS3N4aVpWbzU0Wk9KTXRtVi96YVpqV1REL1BsWDY5SGlPR0FO?=
 =?utf-8?B?eThPQWYxNHVmMkNERHAzYjFWbTlxRlo5MTRHTWhKT2VQbUJ0R3l0WmFHdXF5?=
 =?utf-8?B?STlMT3NtL3N1ZkVjNG1jU090K1BIWGNxZ2tKUzhLTkhka0IwN1ZwcjVweUF4?=
 =?utf-8?B?aWh0UXEwRFlMWE9haVVrUXRua1QxZ3hSUkpaM2NVWFVUT0huK3VCM1IzZ0Yv?=
 =?utf-8?B?QUNMaHZnWlc3aWZBR3RSWkR1U3ZITTd0WDczN3VtWDRhUFh1YUNpbEc4dTBF?=
 =?utf-8?B?eGRad0ZzdFN5MEk0VWZsbFR0Y1NHTnFsNkJhdkpoNEJBTG1kOHk0dlR2ZGhI?=
 =?utf-8?B?RjZQelRITHlMWDMrSjE2REZEVFUyU3hQREdRYlJWbk5KdnlBL0VqTENFWlgx?=
 =?utf-8?B?YWZxeGVHclhhbXVneEJPdHF3ZTNTWDBxMngxSGlUaTdZMkFobU5NdHBKLzBK?=
 =?utf-8?B?RzVxaHh2U1FycC9uclRvL2tFRTNHM3FVVkpYRk5maW9oMXdFTVBRb3E4eDc0?=
 =?utf-8?B?dWJaZUJtcTJ3ZGZiQm5lTzNwTkU5Y1FiemZGK1dWcTMraTJ6UHFKckVoMU4w?=
 =?utf-8?B?enk0VC9iZ09tcDNjVm51K1hWKzBURlNjNW53M2FsVzVONVVkU1BYUHFkRWdS?=
 =?utf-8?B?bmpvZDcrRHRydGx3dWZZSDZMcUR4MTdWaktiNVhkb3FxR1V1dThqbzQ4aW1X?=
 =?utf-8?B?UjlQQTRXYlFLVWpnR0puNG1NZjRsck1EU1ZwNlZjdEwwbEhURHp1SVNZU2px?=
 =?utf-8?B?RStnaXRXQ0tqbnRaeitDVjZvMStKUG1PaC9ORSsrcm9rKzdSZHhQcGVjdGFa?=
 =?utf-8?B?a3c2ckRwMGljS256RXlpck5obmg4anBJTkxBeGZsL2ZIT2dkaUpXSTFoZWlB?=
 =?utf-8?B?K2VhTGZWUmNHeXIrRitMUkM2eG9pVUdOeW43dWlBN2gwVzM3elhTNTg5OEo2?=
 =?utf-8?B?TDBpRmk5NkQ0bU9LS1lFQkk3Vm1nbisxU3pyYkxpRXZaWUxmNXBqR0pwdldn?=
 =?utf-8?B?MHowK2ltU0lrYXZMcTlmNEQ4Z0duekxSZC9YV3VQcEVBaS9Vd2hEc2YreXI2?=
 =?utf-8?B?WnNVa2xXOUdBWFNqTnA5OE8wb3o0VGdxWkFUVWlXR2puL0tEMGFXNG52bC9w?=
 =?utf-8?B?b1pnTkVwSWdOZ3FJVVUyVnFvUG00UkhwekxqN05yaU1ScG9Ha0YrVWRwRXVI?=
 =?utf-8?B?WW9vajFIWm5qellYcU54SDJOQTZtSHErQmdsSVRDeEZ0L0VLL2p4VG1mcGN2?=
 =?utf-8?B?MUIwdStzYnIxMithQThiQXdBeDNXMzlWT3Jkd0NidmRxQjZWdWwvRTdzSW1x?=
 =?utf-8?B?Q3dSaGszSmRybE02SGIyZll3RXVZR1pmQWd4NXhvM0g5TUNEc2VXZFQwZGUx?=
 =?utf-8?B?VWhkYVdKM0ZlQ051eThyeEhabHpLSzc2VkVGMjdiNjgvZFFCQkNzbzgzbjl6?=
 =?utf-8?B?SFlRM0dMOEVMejZJREZLejZDSFVWcnY0SDZ2TklKMlF5Z2NGNUFVR2pFV2lo?=
 =?utf-8?B?L0dmcFFnZC9ib3lwaFlGVHp4TENjTWVGdVN3RGJaaCthQ0pBVWtuemNqbHkr?=
 =?utf-8?B?Z3VWOWpFMWp2cDM1SitoRGd6NS81RDRIU0xPc3JwdTAxeFlEZzhRTU5pamp5?=
 =?utf-8?B?V3BjQ1IwdFVyVFF6WEk0RGJUdkVBaUVZTXBKN00xY3FpVFF2a3R4TFVCREo3?=
 =?utf-8?B?NG5wNkl0S2dmNnAyRjcxSXl4dzJZd2l4WGZ0ZnBYbUt6anFDalVZcGVWbGVP?=
 =?utf-8?B?TzEyMU9Ma0VqbHZBWXZrVzJYY05ydlpCSVhON2YvVkxBL2gvVE5UYW5WZ0Uw?=
 =?utf-8?B?U2pPakNTVUlWRzdlKzl4dlZRcVdFL2docW1Tc011M09ZSFBmYVF2OVNLSUha?=
 =?utf-8?Q?HdlRrLIoo1urqtkJIsNnCCBnN?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 03ab703d-c280-4fc8-f467-08dcb730e21c
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2024 22:32:56.1330
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aWwjaaqpqgZAbFTsb+soMwa6FJ5FXU157EFkCtN+CYjTF0ojgH/JPvZ5XEGrrK8d2b/fhnjRyXy1rMfgLFunYQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6811
X-OriginatorOrg: intel.com


>>>> +static void print_basic_sysinfo(struct tdx_sysinfo *sysinfo)
>>>> +{
>>>> +	struct tdx_sysinfo_module_version *modver = &sysinfo->module_version;
>>>> +	struct tdx_sysinfo_module_info *modinfo = &sysinfo->module_info;
>>>> +	bool debug = modinfo->sys_attributes & TDX_SYS_ATTR_DEBUG_MODULE;
>>>
>>> Why is this casually checking for debug modules, but doing nothing with
>>> that indication? Shouldn't the kernel have policy around whether it
>>> wants to interoperate with a debug module? I would expect that kernel
>>> operation with a debug module would need explicit opt-in consideration.
>>
>> For now the purpose is just to print whether module is debug or
>> production in the dmesg to let the user easily see, just like the module
>> version info.
>>
>> Currently Linux depends on the BIOS to load the TDX module.  For that we
>> need to put the module at /boot/efi/EFI/TDX/ and name it TDX-SEAM.so.  So
>> given a machine, it's hard for the user to know whether a module is debug
>> one (the user may be able to get such info from the BIOS log, but it is
>> not always available for the user).
>>
>> Yes I agree we should have a policy in the kernel to handle debug module,
>> but I don't see urgent need of it.  So I would prefer to leave it as
>> future work when needed.
> 
> Then lets leave printing it as future work as well. It has no value
> outside of folks that can get their hands on a platform and a
> module-build that enables debug and to my knowledge that capability is
> not openly available.
> 
> In the meantime I assume TDs will just need to be careful to check for
> this detail in their attestation report. It serves no real purpose to
> the VMM kernel.

Sure I'll remove.

It's basically for kernel developers and customers who are trying to 
integrating TDX to their environment to easily find some basic module 
info when something went wrong or they just want to check.

So if we don't print debug, then the 'sys_attributes' member is no 
longer needed, that means if we want to keep 'struct 
tdx_sysinfo_module_info' (or a better name in the next version) then it 
will only have one member, which is 'tdx_features0'.

In the long term, we might need to query other 'tdx_featuresN' fields 
since TDX module actually provides a metadata field 'NUM_TDX_FEATURES' 
to report how many fields like 'TDX_FEATURES0' the module has.  But I 
don't see that coming in any near future.

So perhaps we don't need to restrictly follow 1:1 between 'linux 
structure' <-> 'TDX class', and put the 'tdx_features0' together with 
TDX module version members and rename that one to 'struct 
tdx_sys_module_info'?

> 
> [..]
>>> This name feels too generic, perhaps 'tdx_sys_info_features' makes it
>>> clearer?
>>
>> I wanted to name the structure following the "Class" name in the JSON
>> file.  Both 'sys_attributes' and 'tdx_featueres0' are under class "Module
>> Info".
> 
> I am not sure how far we need to take fidelity to the naming choices
> that the TDX module makes. It would likely be sufficient to
> note the class name in a comment for the origin of the fields, i.e. the
> script has some mapping like:
> 
> { class name, field name } => { linux struct name, linux attribute name }
> 
> ...where they are mostly 1:1, but Linux has the option of picking more
> relevant names, especially since the class names are not directly
> reusable as Linux data type names.

Yes this seems better.

> 
>> I guess "attributes" are not necessarily features.
> 
> Sure, but given that attributes have no real value to the VMM kernel at
> this point and features do, then name the data structure by its primary
> use.

Sure.

> 
>>>> +	u32 sys_attributes;
>>>> +	u64 tdx_features0;
>>>> +};
>>>> +
>>>> +#define TDX_SYS_ATTR_DEBUG_MODULE	0x1
>>>> +
>>>> +/* Class "TDX Module Version" */
>>>> +struct tdx_sysinfo_module_version {
>>>> +	u16 major;
>>>> +	u16 minor;
>>>> +	u16 update;
>>>> +	u16 internal;
>>>> +	u16 build_num;
>>>> +	u32 build_date;
>>>> +};
>>>> +
>>>>   /* Class "TDMR Info" */
>>>>   struct tdx_sysinfo_tdmr_info {
>>>>   	u16 max_tdmrs;
>>>> @@ -134,7 +163,9 @@ struct tdx_sysinfo_tdmr_info {
>>>>   };
>>>>   
>>>>   struct tdx_sysinfo {
>>>> -	struct tdx_sysinfo_tdmr_info tdmr_info;
>>>> +	struct tdx_sysinfo_module_info		module_info;
>>>> +	struct tdx_sysinfo_module_version	module_version;
>>>> +	struct tdx_sysinfo_tdmr_info		tdmr_info;
>>>
>>> Compare that to:
>>>
>>>          struct tdx_sys_info {
>>>                  struct tdx_sys_info_features features;
>>>                  struct tdx_sys_info_version version;
>>>                  struct tdx_sys_info_tdmr tdmr;
>>>          };
>>>
>>> ...and tell me which oine is easier to read.
>>
>> I agree this is easier to read if we don't look at the JSON file.  On the
>> other hand, following JSON file's "Class" names IMHO we can more easily
>> find which class to look at for a given member.
>>
>> So I think they both have pros/cons, and I have no hard opinion on this.
> 
> Yeah, it is arbitrary. All I can offer is this quote from Ingo when I
> did the initial ACPI NFIT enabling and spilled all of its awkward
> terminology into the Linux implementation [1]:
> 
> "So why on earth is this whole concept and the naming itself
> ('drivers/block/nd/' stands for 'NFIT Defined', apparently) revolving
> around a specific 'firmware' mindset and revolving around specific,
> weirdly named, overly complicated looking firmware interfaces that come
> with their own new weird glossary??"
> 
> The TDX "Class" names are not completely unreasonable, but if they only
> get replicated as part of kdoc comments on the data structures I think
> that's ok.
> 
> [1]: http://lore.kernel.org/20150420070624.GB13876@gmail.com

Thanks for the info!

I agree we don't need exactly follow TDX "class" to name linux 
structures. We can add a comment to mention which structure/member 
corresponds to which class/member in TDX spec when needed.

