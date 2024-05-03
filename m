Return-Path: <kvm+bounces-16469-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 86BEC8BA4D4
	for <lists+kvm@lfdr.de>; Fri,  3 May 2024 03:14:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A8AE6B22C6E
	for <lists+kvm@lfdr.de>; Fri,  3 May 2024 01:14:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71BFBDDC0;
	Fri,  3 May 2024 01:14:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ewt/ainO"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD9FABE6C;
	Fri,  3 May 2024 01:14:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714698880; cv=fail; b=goc5AbvFOajbrcsIjajfquBEUTcENl1smFpLET/PyiqvcQAu2tqEfrIBFnBho12ymNOs7vEhJKaSCfRavLe23QDNA8VExQ+hAeoijNBQNZb47/PCSdt2cn0N+fWwzDRaYnt626Og77C4jmWbuJE5jpySrV3QOv65M1ltZpWVIEs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714698880; c=relaxed/simple;
	bh=K6G1Vqio5gJJhVkoTD3I/wXwpJOWwMTsQO8l9ozrVHQ=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=sCWrzg4zmIJ+a2+VrYT/eE+QiEkadwv62o0jjHMtcN2AiwAONNbnwLSNtBaYgFVbYhoCwsZsL2+yVRdlY3VbgOCnu5d/E2q27SGY/ASrTui41zbgHdbmpVFtDaIe7X7cGQ7pxKchB3DR/VgVIh7kJbcImMZIipzJc3rvAtweKlM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ewt/ainO; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714698879; x=1746234879;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=K6G1Vqio5gJJhVkoTD3I/wXwpJOWwMTsQO8l9ozrVHQ=;
  b=ewt/ainOvcB9BN9goTudup5zrDRnXFF0ZDwatRAYsFmnPno0uAmZdGGb
   XdFXJ3CwwrDxBG9wNmal2Ydi28TTjV0bnSsZOiJUI7GxVYxSwUX623KZb
   0uekjPfzwEFHRIBaUvaZjwvVKtKZtNeBDbUTYBFCJZNJOLiVw9k1JrGT0
   cEP9Bvdgpz90C9h9VOyVrWU/pFjEcdH3E6aDlfdjRzmhzniSdhevAElAC
   9S0VWqk9cA+xWSRQdcbpBkEJ19GjX4tZAY8dkEETvD4crdgl17dIVgA6v
   of1xJPQt+YPyoOWZn5dOxWugfR6YPU3lvxADJxICIYED/puAn1PiHjg3R
   A==;
X-CSE-ConnectionGUID: SN8nG9x3TSmkvVpVbP4l4g==
X-CSE-MsgGUID: n7QG1RRISAqr88UWeqNFHg==
X-IronPort-AV: E=McAfee;i="6600,9927,11062"; a="21189202"
X-IronPort-AV: E=Sophos;i="6.07,247,1708416000"; 
   d="scan'208";a="21189202"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 May 2024 18:14:38 -0700
X-CSE-ConnectionGUID: RfUNSwSiRliTVe/3l50hOg==
X-CSE-MsgGUID: KTfL3luMQUC3dgFoczj3Bg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,247,1708416000"; 
   d="scan'208";a="27897721"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa008.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 02 May 2024 18:14:37 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 2 May 2024 18:14:37 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 2 May 2024 18:14:36 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 2 May 2024 18:14:36 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.172)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 2 May 2024 18:14:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SG6cSiGJ+bac0lvN5cLfZu6lesZfEfMv6xMTf8xgPBvm866BS4wTib4k9WiKhnhzZLJjOWaqGMJuAjkZkxb7DbVgZY5Ps/s9SJ2iM+Iy+uL/+yNDeCNqA37dV5slIpf7eZpJtUEiKUgd6IEJaOaN28To4O70FonqFDkvsFIopirRkfNb9ayosvUa5Y7S1jGtqqNtPg/rITGu7fq92rHgyWPATKsJKE38bqvPMQ5KgLA0fbnIDvQkuuoqzEfifKP8A87Llt7fAXYLRwAZngyrOTT0Wa8nad5EAA3Gu0MZBmad5LlrA9lYr8bk7fS/QNZsiS/iIzUnhaKwaYTXjuraBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6oNC17wQcmMVr5bcTtv+a+ibpefQvW5IppfCjRiGnFY=;
 b=HRMvz6XmJ5KgJBe9z7X2mz7Am1NqDOImh8yYhvS2JDihKDdWwtIpgqXmcOtMp+cchYQLkpvfjnodsBU8ntijcXo6TTUyhRJLcH1ZqAOF3z98dIniDJuiJLjgU49jDk+TWpngfPk3amBYpJKaPD/IFIIoBIiWdiL3p3xqyjABxCOop6y6/KuPJGT4auVVAyVjGvgMTGmlnT97Q/fr+Glcx7979gz3m7R3jK+x4+uj05NvR5f19/1taLZUWlNqzxBy4tPluCLx7KYqMTLOAci3cDnSE4yaLHquqxGYFytV8IGiJS3z+b/r2TMgAGFycKEiP1PGP400W78pqfNR5L1Z5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH7PR11MB7430.namprd11.prod.outlook.com (2603:10b6:510:274::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.29; Fri, 3 May
 2024 01:14:33 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.7544.029; Fri, 3 May 2024
 01:14:33 +0000
Message-ID: <45eb11ba-8868-4a92-9d02-a33f4279d705@intel.com>
Date: Fri, 3 May 2024 13:14:22 +1200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/5] x86/virt/tdx: Support global metadata read for all
 element sizes
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
 <17f1c66ae6360b14f175c45aa486f4bdcf6e0a20.1709288433.git.kai.huang@intel.com>
 <c4f63ccb75dea5f8d62ec0fef928c08e5d4d632e.camel@intel.com>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <c4f63ccb75dea5f8d62ec0fef928c08e5d4d632e.camel@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MW4PR03CA0224.namprd03.prod.outlook.com
 (2603:10b6:303:b9::19) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|PH7PR11MB7430:EE_
X-MS-Office365-Filtering-Correlation-Id: 4c1e135b-6a1b-4b42-aee3-08dc6b0e6427
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|1800799015|7416005|366007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?eDhkY0NpMWYwVHQzNGtPbFJ4Z0xwWlNQaHM2WnFSSUp4aWtTZlQ1N1FLVkFJ?=
 =?utf-8?B?Um9sWDlNdFZQNmsxZFMrNytyNElEamJxMGR3aHBvN3BQUU1tdSs5STlXV3lC?=
 =?utf-8?B?bVRFSTVRVlFpNms4UHpwT0h0SEpQMDZzNURVTWhlZC9FdGtFNXVYaWZCa1dN?=
 =?utf-8?B?eUhxbGl1ZkczcnFzNFNiT1lGUi9WZ0EvV09HZmk1emhHRW9LS2dWeVNUNFRu?=
 =?utf-8?B?MjNyYUorOU5QNE1GWUhpYUtZV2IrbExDVDZpWWFyWmQ2TXhIYit2ZHIvMXVu?=
 =?utf-8?B?QlZwWU4wUGpUNnU5MnZuK3hrUWx2bGVBY0NPWjltaXhzaHp2cWZnamxVMGtY?=
 =?utf-8?B?d0xmVEY3UExVT3ZZdGZFNWJQckNTQ201WlFScWpyOGFPaEJRVFVzc3lxNVhX?=
 =?utf-8?B?amNEMjlBcUhuQTFWbGNSK0RVQjM5RDl0RTA0dGZtam42dUtUcXhkYm1BckxY?=
 =?utf-8?B?K3BZR0dHRkoxK0x0V2E2OWFSa0JuOFZ4bE9MSVNLLzVUTVBrUTZFdGkyMGo2?=
 =?utf-8?B?SldGNjR2cFA0djV3eEFNdFdia1Z6aWxERDAzWVNaSHI5aHBZOEFnY0tkeFlh?=
 =?utf-8?B?c2Z5K2xFVkNRRTFUVmc1R2xROW5pMXA4OFhCcGxZdFlxeWl2alhKSDBlb0pv?=
 =?utf-8?B?MWFycldQaEJaNHhTdGRXTis2aXlxWmlrQW9valphQUNRRncxTld2ajcxNzJL?=
 =?utf-8?B?bzhqSUFxWENCQkhxK2M1ekh5dnU4bG9jYk1WNkU2QWhzendmcmdwVXpMTUlU?=
 =?utf-8?B?SXF1S0hTMlJQbWVzR3lvTS9YV2R5K2JtUjlaeG1pY3hCVzJpTGdZSTlHREtD?=
 =?utf-8?B?OFlHd3FZdU1ZS1E3NVBBWVU4dEVnNks0bnhtUHhaWlkxbUNTeExXZnRNMENR?=
 =?utf-8?B?bEhCZHhCMTAxODlVTEtrYjlQVW1mRlY5cEJRbG81WWtQMW9UNC9JSHB1RG5p?=
 =?utf-8?B?bWZsYldsaXBoWUlhYk13OW14YWVDSmMxQUkvMFB3UGZnam9sdTJwMUtia0Nj?=
 =?utf-8?B?NW9ydE5WQzRjWGxSZHVXYjduc2hTRkh6T2EyNkFrOUVKNEd1a0s3b3lQT25Z?=
 =?utf-8?B?a1FuUnJDWDk0NzFXMFE1V0RsRkJzNG42MWEzNmhIZ0JpbmRDbzJ5bit1UlF0?=
 =?utf-8?B?NEJqSHg4alpMUzZ1SEpBa1BIeUs0N2JNc25HQTd5VEQzUUdoaFB0ZEdrRG5C?=
 =?utf-8?B?STN5TEoyMEVxODJEMUxFZWI1RHpUWGdHTFN6RFY0VmQ4ZC82VU9ISWJtWDg0?=
 =?utf-8?B?eVZkbUJ6cnhXM0haa3RHWmZJS3R2MmlCSDB5VmNPV3hpblpJSHFDam9JWnlm?=
 =?utf-8?B?QXJ4TUdoWDhOeUNaUmgwUUxzMXpZeDd2bTNwRVFnTmhrY1pwMnVKR3BPR0J6?=
 =?utf-8?B?YzBzcTcvVHpHR0xFdXFnQjdDWGsrSWFVQW5MbEhaY2RqcXBwQkN4L2VxYVRt?=
 =?utf-8?B?Q1lzTFErVXF4UUhmWEtxR0pGQm9XYytWYldvYTRPUG9WS2ZwUksvV1pRL2J5?=
 =?utf-8?B?My9jdmNwS1VnTzc2bi8rMURiTlhPejVySnNUeWNicWtWRVdxd1Npb0FUQTZP?=
 =?utf-8?B?OTR4dGJwREs1Z1lzK3l4UGU2UEJXRFlOcG8vZkZKWCt6RlpueUYxcndCWHpU?=
 =?utf-8?Q?IQj7tFKpyH9mvzUAuQChHogyLZbhHu6VnKLa8bnU39+A=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(7416005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aHlRQjNjQkJFajdRTXc3KzhCc2xST0s2dHJsMVZCWWpFMVY0YW1lRWNmMFEy?=
 =?utf-8?B?YkR3THFxYmQ5R0RDVGlHUVlJYU1VR0NBYVFHeHVIOCt6ZXBsTkVJN2Y1cVF5?=
 =?utf-8?B?N25vbThFRmtQcldQUDdpdUlzQ2w2TytKM29aaE0wZUJnMjVENDhZd3MrWUNH?=
 =?utf-8?B?alU2dFB3L2IrTTAyUmFvbndlKzdhby9mUmcyRW5hTFhRcmM1UEYxd1d6SlpB?=
 =?utf-8?B?UlpPblNTcnpNb1gybUFwNll5ZlNzYlNXTGNTdkV1Skt4RG5zd3VNK2JVR2I2?=
 =?utf-8?B?ejI2VnQxUE9YTFVkU0ZLbUo5VDR6UXp5Y3BTeTNVYjVZOTU5T0hjNGg0SlRI?=
 =?utf-8?B?ZXY1ZGlYL0ppeDVNLzRiWFB5OXRXSVhpUlpZWkhOSU55NkxpcmFMcDBKZDMx?=
 =?utf-8?B?Ky85cnF5QytTT25YRW04Y01VbGllV3JKWUdWQ3dEakl1cVcxMTU3SnNLNkU1?=
 =?utf-8?B?ZEIvRThaRm9RMi9yY2tBdDBMbFYvSWlIeTNsWksxYm1uKzlNYzlKQ2orY3hv?=
 =?utf-8?B?VVkwbE4yMHcwbEIxMFB0elFtRUwwRm02dXVhb0FZQ244dnVNSlZIRXMvOHN0?=
 =?utf-8?B?RDIzcGNLeFdMUTlxSTdPeDhOZ0FzaGVXc0NZM1VaUmlsZTgyRm5oMERGODlP?=
 =?utf-8?B?SlBJZExscjlTTktUSzArb2xZUlorNWJIMmdvVFJ6Zm1VbVZqMlBrc2x5Ky9x?=
 =?utf-8?B?U0xONUZLcnI4Y096cjdFM0ZYcXFRVGx1ZTJ2bnNwVHk5SnM0Z3pZNWJGRGh0?=
 =?utf-8?B?MzVoWTR5dXVuRWJDQWJCSmxzWlVRYkY5b05rN1NyNGF0RFZFdml2VW00cFkw?=
 =?utf-8?B?Q2MyTG9aUWs2UFBLRGZTT2Y2OWZjeE1hWlQ2azZVemtIZTN5eDNRK0NaM1JQ?=
 =?utf-8?B?ZG14MHMvcW4wT1VOUkZxRGNCZFd5Q0pNZllPVkpraWJvNU5CV0xjKzI5UWo3?=
 =?utf-8?B?aWxERTZmbmk5bmdVM09ONnRyUXZpTDZ2K3BwcWYzOGRJS0xheFc5U1U5cnUv?=
 =?utf-8?B?M1haQWJ5bGptalI0T3JjTFQ1Z2wrdmN0dXF5VktoRllVZzd0a1Zra0VaZ2xu?=
 =?utf-8?B?VkZUZXpqOXNGdUUyUHpqWHFaU0creWxlbG10Y29rcDlrUzYvejkxYnNGbGJU?=
 =?utf-8?B?S2lkUlFoZkJva3pwZmJZSjBxZWVjdE45U3JCVGc1UldCaWNIaTBjVHZIWnV5?=
 =?utf-8?B?YjVmOUFQeUJ3d2kwdHBxQWdwTURsb2dsL3QxYlE2ZGpNNk01dDliUjlyR0NC?=
 =?utf-8?B?RGhPOXV4VUZWOEtoK0xmbXJSVzNGc2tHNExKNHNmM2xvMTA2RkNKL1NKTW9s?=
 =?utf-8?B?dE9xTWNxY2U5TXFwamRuQjJ6bUNWQ2x3Q1NMYjAwS3Yzelc1aVBhU2VJUEI2?=
 =?utf-8?B?aitReTFTYWVZYmxGNWZZOGZET2R3S1FSd2FWeGRGZ09kanZDanhGcy9mTW82?=
 =?utf-8?B?VmtqcHcxK0NIRUN3ckpFNW9iWFJiN0JpZCt4SUgvOW0xTTdabGE1M0Z5VTVq?=
 =?utf-8?B?R29ZWitnZmtaUnFNNlBFVzdNUVhEK1FrcFc5aHJFSlJMZUMxdDJuellQNm1s?=
 =?utf-8?B?TUpJelNYaFgrd2RrNEptUW5Ka0FXS2ludmxCaHErQTVUVERrQWpyMWM1SVZp?=
 =?utf-8?B?V09wVFB6S2NUTng4TzRwV0dBTCtDR01qaWRkcTFPNGdaeGRjdS9EandSRjRr?=
 =?utf-8?B?Z1ZSVzJMUXJEclZKelFKUUJvYzExdUVOcHNvZURYeWl5bG9EKzhMSHBleVFQ?=
 =?utf-8?B?YWI5TTJMT1NGYmRWQis0K2N5UHNIRDVJRTJ4d2I4M1JTYXovblh6bjlzSDc3?=
 =?utf-8?B?Y2JmaXRpdFZtMkMvZjdUSFRWWFd2YjNFMkxwYmxkOGx2OE16TEY5MHp3QkRO?=
 =?utf-8?B?VEc2czJTRmpHYll4ZHhVRHVHT0ZZMHpZeTlQbXUzR2g4VjUwOGZhYWwwVER1?=
 =?utf-8?B?RHEvRkhnbklOZUdDOWdmSHdQNlVuc0xheDN6allqa3oxYVNqWmtMY1c3SldQ?=
 =?utf-8?B?V0VDSldNR1JCRmNGajd6cnBZNnVncUNMZGxSMURnVFpkUnFod3NNMVFYMXZq?=
 =?utf-8?B?Y3publZZK3RBWmgzOEYybkJkMm1pdFJpYTBBbDBUbEVvZzY1SU41WHZET2xY?=
 =?utf-8?Q?p31xcXRiO6tVU9rCWgGtgQbaj?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c1e135b-6a1b-4b42-aee3-08dc6b0e6427
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 May 2024 01:14:33.5411
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VN9eWcEL/tIOvIDSx9AQzFk9BcZ2KTy/VWzS9kqmag/LRz98wfv5Ye1Wp/0GsKNMMM7xLqP4E2IEKA2/JmGBYQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7430
X-OriginatorOrg: intel.com



On 3/05/2024 12:19 pm, Edgecombe, Rick P wrote:
> On Sat, 2024-03-02 at 00:20 +1300, Kai Huang wrote:
>> For now the kernel only reads TDMR related global metadata fields for
>> module initialization.  All these fields are 16-bits, and the kernel
>> only supports reading 16-bits fields.
>>
>> KVM will need to read a bunch of non-TDMR related metadata to create and
>> run TDX guests.  It's essential to provide a generic metadata read
>> infrastructure which supports reading all 8/16/32/64 bits element sizes.
>>
>> Extend the metadata read to support reading all these element sizes.
> 
> It makes it sound like KVM needs 8 bit fields. I think it only needs 16 and 64.
> (need to verify fully) But the code to support those can be smaller if it's
> generic to all sizes.
> 
> It might be worth mentioning which fields and why to make it generic. To make
> sure it doesn't come off as a premature implementation.

How about:

For now the kernel only reads TDMR related global metadata fields for
module initialization.  All these fields are 16-bits, and the kernel
only supports reading 16-bits fields.

KVM will need to read a bunch of non-TDMR related metadata to create and
run TDX guests, and KVM will at least need to additionally be able to 
read 64-bit metadata fields.

For example, the KVM will need to read the 64-bit ATTRIBUTES_FIXED{0|1} 
fields to determine whether a particular attribute is legal when 
creating a TDX guest.  Please see 'global_metadata.json in [1] for more 
information.

To resolve this once for all, extend the existing metadata reading code 
to provide a generic metadata read infrastructure which supports reading 
all 8/16/32/64 bits element sizes.

[1] https://cdrdv2.intel.com/v1/dl/getContent/795381

