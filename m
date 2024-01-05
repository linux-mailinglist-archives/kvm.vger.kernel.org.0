Return-Path: <kvm+bounces-5706-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D2EF824F96
	for <lists+kvm@lfdr.de>; Fri,  5 Jan 2024 09:17:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7F05F286A9C
	for <lists+kvm@lfdr.de>; Fri,  5 Jan 2024 08:17:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34DFD20DCF;
	Fri,  5 Jan 2024 08:17:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nksiWy5a"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0861E20B1B;
	Fri,  5 Jan 2024 08:17:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1704442630; x=1735978630;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=rSVm++J3Zquk/fkfuhk6+M2lNsVeJUI3lIYr6HUvvlY=;
  b=nksiWy5aLXTjWdubluJCHlDLCwgZKAHwRFlRRhdMRnv9tSBACEAeDU9r
   vGxcSggJ/PMFW4AA8I82Z2v4G9l//mO7pcqZHJPYA0qG8WtSDuRR8Fjc6
   8aI/axOueVTPrbyjivPv5INRO8uSPv5TAu1vpTzdYS7YdV0RpteZvxmcT
   /QRvptZonkJIIrI82YjJXCpIrd0eXC7H+OVJpAPBCDXgkuiHi3cGfoFqN
   KLquuiY03MBRct2riATjhexZlNiZ8sIT4sGOh4MhLvWfGfBS+3N2Oqfop
   BDfGelQ8+2YcwjgB1zddjUu9nA39uNN0GoCywBImEfYng7jn9kdmno/D7
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10943"; a="483631359"
X-IronPort-AV: E=Sophos;i="6.04,333,1695711600"; 
   d="scan'208";a="483631359"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2024 00:17:08 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10943"; a="924172394"
X-IronPort-AV: E=Sophos;i="6.04,333,1695711600"; 
   d="scan'208";a="924172394"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 05 Jan 2024 00:17:08 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 5 Jan 2024 00:17:07 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Fri, 5 Jan 2024 00:17:07 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Fri, 5 Jan 2024 00:17:07 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KRNwx+6jB/Tf6hdLIYcXT8zOA0k/P8Rfwkl8qpOABO9UoBFNXaRRYv0C32Np3K8vwBuSi2MsNr1C5X5SmPebXTpXm1tEFRqP8kRJH57YU4Z7JfjalqcHgMl5IhVHw/vQMtPbJ7Z6N5UK17+2I8p/tJcdH8u0vFv42ICy/cH0fr4SZqfLV3c4mx0sIq8601s1eS3nAUHihBUk+V91zG4Aw/FwZu+9LRm/wqf+bnnyZz+NW8RiLxNA1Q41tNpMdTIn6+OoP6hnNiQll+w9FFssIARFILSTk0kFBEfrrl6s5M7qcUExhaW7R0AYOzG8GEObpzeGSNGWWg+ebCq55X7PSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SP+nJoXOGgtN/Hy2twkK92MoLRWiU3/JkK9rDNox+mI=;
 b=X4tDwdChr64ux88E9TmVk1uqz82q6iu9DtKhnMqm+JGAOA/rcx8Up/fhVHzm6hoRD3pEp3fKj6EL5PkpJAKhCvW9X1VgI3/3Wv0lTAy5TXWES8A9lq1Sr9835rKPb88+MOIB3ruBlm8YPN8Jwe7FT82ZfxadOskAmlzmJC7O2i2fcrs7AWKCVzqP+ZthKkw36GRf4mo4a7tcHB0oOJ2yaqQ2CNJTmE2JTb/HhszbGcsXyuvKcRbsE0qLmdndBx7qKokuY8xCmlCls850izfPyWlectuDLlDAhy/3wCvwDKWJ4RmoS+qBGllCRcCTm6AGPAi0eFUkOJOIW3aVploi2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by DM6PR11MB4643.namprd11.prod.outlook.com (2603:10b6:5:2a6::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7159.14; Fri, 5 Jan
 2024 08:17:05 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::819:818b:9159:3af1]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::819:818b:9159:3af1%3]) with mapi id 15.20.7159.015; Fri, 5 Jan 2024
 08:17:05 +0000
Message-ID: <82a9f0c4-7e6d-477a-bc6e-6dcb046b25fd@intel.com>
Date: Fri, 5 Jan 2024 16:16:53 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 06/26] x86/fpu/xstate: Create guest fpstate with guest
 specific config
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
CC: "Hansen, Dave" <dave.hansen@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "seanjc@google.com" <seanjc@google.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "john.allen@amd.com" <john.allen@amd.com>,
	"peterz@infradead.org" <peterz@infradead.org>, "Gao, Chao"
	<chao.gao@intel.com>, "mlevitsk@redhat.com" <mlevitsk@redhat.com>
References: <20231221140239.4349-1-weijiang.yang@intel.com>
 <20231221140239.4349-7-weijiang.yang@intel.com>
 <055eee55f2ed04a822d99e1824d08a70aed942f5.camel@intel.com>
Content-Language: en-US
From: "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <055eee55f2ed04a822d99e1824d08a70aed942f5.camel@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2PR04CA0159.apcprd04.prod.outlook.com (2603:1096:4::21)
 To PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|DM6PR11MB4643:EE_
X-MS-Office365-Filtering-Correlation-Id: 2283fb88-62aa-461c-d4d7-08dc0dc6b330
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SEQ2RXeIRj86I7QTKcpqY4BRA4+uEib7Wa4AEWykHIyHQbYnRSlWdy+V7D/yjMW9JuvGoNR8t2G4pJD8A+g3qdZf0/InQdtz8FzGHH6bfC+osUs7ZigYurVwdBjwAbWCu5P7Pq+obQS9GmrV9naRE5mLfmg1XnA/iP8JUYVuXrOiKQRDTIV5EqwQJI3pLrwIkHWwHZKKCD4aIgRrwy8qjNbi4Mm6LgeL2QE26VFprlNNn47st/ZayhxxOdAzFc/t9wp5vtqK/CYGahftBryQWvdAuQ3bLhuSRCCox6IFtPKf1vHOm5gxhp/GkK8XaLXKKb6V2jdZ/PLessBoFeTX/Wm0u7zX8NCV3hc87a5Mmgyw6Fud24XkYcAWbEluJQTiwRsPjGcQK2NW9jo2AZasKmoeIJ7HYiHI+wtCdqX3qD6qpVfUqF/rVFSbTldATRBwFrEHUTMwQfCCL6PBbfIw7aVqwBOb0yFjfKLZGmWCIbCV9IQF7z7otUTGAGPrvehDqE6wlHuzdwbN8VcP2fyLnUgi3ozM/TaSTYgt9srWk4aGVKMIA4am6a9dSJXvxqb7KOt12xzIRO8nq86TpN/n7m4Cxh764TqYC2ocQlnKfeJpprsiQ9AST/r9zhg+Ex6TvhUkQFHZUBMsfGb01TJBXA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(346002)(376002)(39860400002)(366004)(136003)(230922051799003)(186009)(1800799012)(64100799003)(451199024)(4326008)(31686004)(6862004)(5660300002)(4001150100001)(2906002)(8676002)(8936002)(316002)(54906003)(37006003)(66946007)(6636002)(66476007)(66556008)(6486002)(41300700001)(6506007)(478600001)(6512007)(6666004)(53546011)(2616005)(36756003)(26005)(82960400001)(86362001)(31696002)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?S1VPTGZqeW5KZnhuK09CR2pjZXl6VzRuMmNURnlDVzdRQWlNY01MOTFKZnp5?=
 =?utf-8?B?VmovYU1oU2xVZzJiRGVNT3FCdzduZjE1RFpLeVE4R0VCTlA3YXNEOWF3Tzls?=
 =?utf-8?B?dWVZN0R1b1pCWGxVRml6S3JlZG42RHE5V0dIODdRbDVCdXhyNHlsRTRhdmlY?=
 =?utf-8?B?ZFFhNFNYbWNGOHNIa3dHc05hS3pLSm5GOUlIQTJvV3N6WmNIOHprcVRXazZv?=
 =?utf-8?B?MWgwdnFoZXR4cDJuRnNlUldMWmQ4UUZMcmlKVlQ0TStRT2txWmViYVhOcnJK?=
 =?utf-8?B?bHQ0dm80aHZsSi94b0w2RDFBVm5wWlJOVWprbEkxK0dHcXlRdVNISFU4TkNT?=
 =?utf-8?B?ODFaWkc3SUFGcGtoNjhSWWsvNUxYWjYwMGFkVlFYeGhpQjBzWElpV1g0enMv?=
 =?utf-8?B?SzZuclYyQ3ZhWUloSVpWNU1iUDhTUXdobXNzNlFuUjBSbGd0ZEd2UE82c0FL?=
 =?utf-8?B?cHFac3JremgyMG9JeVVUM0dEcTlBU0dBakEwR0lsR2QzTHExRUhCcThVMUxp?=
 =?utf-8?B?bk9JSCtpYm9KRXpRQVBzL1Y4Q2JBNWFGVlF4ckROUk5SaEVWVkQ2dHZPN1hu?=
 =?utf-8?B?Qk1DVS93QWFSdXlXdUFEcHBwUUxvVjBKV2IycTVNU2FyYkdmYi9hM2JMOUpX?=
 =?utf-8?B?UFJBZlpoWU50NWJLR29nRDJyWHBodkNGd1hLSUFhVGpoVVpieklXYjJENEQ3?=
 =?utf-8?B?ZlVtazlneVlueEdaWmtYMHhEM0ZGejBWYlB6VFBsM005WmhZRUJhOXE2cU9H?=
 =?utf-8?B?Qy9UVmpjclZCVy93UmpLTysrWUcrRTlBMnFLeDBYQ0FmZ2xic3ZhK2JGRTk1?=
 =?utf-8?B?WHRuVVdnY0pxMGR0UlpTMjhCU1g3UXUyV0tON0s5aXllZWRqTnEzNXorbkNB?=
 =?utf-8?B?OUY3V3NXc3ZIMFBWM1NMTERQbGVFei9TMmF1Y25ZcDMzT0VDa25yNDVtdldL?=
 =?utf-8?B?NjlpOWRzdlBuakpSV3NVN1djZENnV21ZSW5MM2VqQkRjcEk2bHBRNHZ5ck9u?=
 =?utf-8?B?c1RMRmpPMjFtQVVRazZpeFJtN1B1QlQrbHN3ZVVBdWRQTWJvWTJTV3FHRTh3?=
 =?utf-8?B?a0hsZS8zdUJrcFNXa0Q5N3pJNnl2RGc3MFJZRGpzekhFZVZpaENSdEVZVXIz?=
 =?utf-8?B?Rk1pUG93akZXZkoxSEhKVGNScjUrZ2xhbFJJN0J5WU9tM3dZZFBoZXBDS295?=
 =?utf-8?B?byswSmEyYmQ3NXFnV1RTOTk1cTFSMVRPOG8vWEhFZ2huNklISS9ZZm0wVEZl?=
 =?utf-8?B?NGo2bDF6UUJKdlZyd2xzRllsZUhFWEsrYVg2R1JMS3I4U25xQXRDYXFVM2Vl?=
 =?utf-8?B?bnBDbzdDQVR6dXRXU2crazZTVVQyNGE1cWdqVDgrbEUzTUM2MnpubVVXWGtk?=
 =?utf-8?B?bUVRWmlCd3hiczAzR3VUbkl2QUVNRHVsUndPTU0vMFFQTFdlakM3bExNV1Ev?=
 =?utf-8?B?VEM1alBCcVZEK01MeC9mM1k5YzAwVTN6ajdsRnVsU1gySnNtWU1zcStWd203?=
 =?utf-8?B?b3lvMVg3end4UW9JVHRIUHlLOVBvSlF0RGNqQk5TakRmdjhhU29HaDM5UUNz?=
 =?utf-8?B?U3Nka2g3eW5TaytsTS9Rdy9acnZZTWRsYlk3MnNsUWZaajRKQmd0bDg2MTBr?=
 =?utf-8?B?VHVuZFhyM0d6d1l2SDhyWWgwb3ZwRVlGdXhhMXdNYzdwaUE2b1pFODNjWmkv?=
 =?utf-8?B?S1psNDhwT3prMXkzc3pXUzZZdThXSkZ4Qmc0NG5YdlJDdTZhZndXY0FSWG96?=
 =?utf-8?B?eGM4UjdXd2s5WTNPNEhsUlBhT1R6dUEwVkg3VjA4RlVCZHlGQk5xUmpWTDVm?=
 =?utf-8?B?dHBGOWVuTTNYTXhjR1pFbEJTOWZpUVJjTG16ZkUrcnV3YVlTZFY3a1U3SGps?=
 =?utf-8?B?M3ZWb1NCZEo2cGRwQ3RMdHFjY0JSRXpJd0RUWEZrYmQ3UHI3eStoZHI4cjJJ?=
 =?utf-8?B?MmRsSllWTGc0d0lPa0ZkaUJSeWI4WDBOVldrSy8xbWNxVndUQStVcWd0TnJ0?=
 =?utf-8?B?K0t3bkNDempkUmtkMWJqR2xZMFpXWXBrVitkQnY5OGlvVmxrL2NlclRCSnRI?=
 =?utf-8?B?VUtVY1F4dVhtcEpwODJIZ1c4RHhmb01Rb1lmZVA5WlMyN2wxYzZuOTlFUkRu?=
 =?utf-8?B?RGlvRklLNHRyV2JGVkJ2SklQcmtGVEY1aDd5TWxHU2ZENTlIRU4zRDJncng3?=
 =?utf-8?B?N1E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2283fb88-62aa-461c-d4d7-08dc0dc6b330
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2024 08:17:05.1101
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jVRZKklwvq3hU2QNWRh+4/tUdCyrHr4jdIVB/AsaXRpEQ5Xs3kVyyroQ2vzI6mz1NCgZ5wpPDmQGmEYkrtLbNw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4643
X-OriginatorOrg: intel.com

On 1/5/2024 6:47 AM, Edgecombe, Rick P wrote:
> On Thu, 2023-12-21 at 09:02 -0500, Yang Weijiang wrote:
>> +static struct fpstate *__fpu_alloc_init_guest_fpstate(struct
>> fpu_guest *gfpu)
>>   {
>> +       bool compacted = cpu_feature_enabled(X86_FEATURE_XCOMPACTED);
>> +       unsigned int gfpstate_size, size;
>>          struct fpstate *fpstate;
>> -       unsigned int size;
>>   
>> -       size = fpu_user_cfg.default_size + ALIGN(offsetof(struct
>> fpstate, regs), 64);
>> +       /*
>> +        * fpu_guest_cfg.default_size is initialized to hold all
>> enabled
>> +        * xfeatures except the user dynamic xfeatures. If the user
>> dynamic
>> +        * xfeatures are enabled, the guest fpstate will be re-
>> allocated to
>> +        * hold all guest enabled xfeatures, so omit user dynamic
>> xfeatures
>> +        * here.
>> +        */
>> +       size = fpu_guest_cfg.default_size +
>> +              ALIGN(offsetof(struct fpstate, regs), 64);
>> +
>>          fpstate = vzalloc(size);
>>          if (!fpstate)
>> -               return false;
>> +               return NULL;
>> +       /*
>> +        * Initialize sizes and feature masks, use fpu_user_cfg.*
>> +        * for user_* settings for compatibility of exiting uAPIs.
>> +        */
>> +       fpstate->size           = gfpstate_size;
> gfpstate_size is used uninitialized.

Ah, this is another unused variable after introduce fpu_guest_cfg.*, should be replaced by
fpu_guest_cfg.default_size. Thanks for caching it!



