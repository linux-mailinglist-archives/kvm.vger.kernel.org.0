Return-Path: <kvm+bounces-5608-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F476823A94
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 03:17:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DA24A1C21122
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 02:17:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38A3A538A;
	Thu,  4 Jan 2024 02:17:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HOWuHY5d"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4F555221;
	Thu,  4 Jan 2024 02:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1704334633; x=1735870633;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=GM1UpXQeo07EOO2sr/Yb8+ikHbklPJuUgx84aJ2YhAU=;
  b=HOWuHY5dtMfZarmXGgmqCrEBLkHIx47sgxj2G/oYaf6vneuZv50KC+iR
   kOBTWOf/m2B0YBQYwLGje8taSgEebW11d5Jyu+4gbdw8Qon0pMiWVgEqF
   QsVNKOXgGGmSiKI2lyVjLCSpWkkAYPReSmMzD4Sfz852aQt8cUpEsDMul
   r1PZY7L0NVfhqOm8cqQsN35s1o731EU1Q79Hlvv/E3RhgVuVQhcKn4JWS
   nEbrAYXlJDD83uAHoOpTQVW48gDJh7j4wmPJslIQPkeW1HMUWFc7kH42C
   Y+4E9AKDyU+t1is5bpqO6W/YayuU64S7nfLli508gf7lJZRJ+lj0/NdJn
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10942"; a="483282793"
X-IronPort-AV: E=Sophos;i="6.04,329,1695711600"; 
   d="scan'208";a="483282793"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jan 2024 18:17:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10942"; a="773330096"
X-IronPort-AV: E=Sophos;i="6.04,329,1695711600"; 
   d="scan'208";a="773330096"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 03 Jan 2024 18:17:12 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 3 Jan 2024 18:17:11 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 3 Jan 2024 18:17:10 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 3 Jan 2024 18:17:10 -0800
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.169)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 3 Jan 2024 18:17:10 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jdisTvh+l3xxGKYqOqnMWS5Cq7+XyCPyBc+MGiXHflRnkgvStG4t4ZMbdoXi8si43YFJC0M6XvH0A2chF+Q3/m05F2/MWaOOTNpHhiql0CJXm5KoRonAmJkAOsrG3R6kOb8UxHMAO5Bh73n//LmSilhyo2UyztpJGZPlG+iJ0c9SecrVPCjfxbY3fmj3X/fwRli7DcpkZ+k5iQtSBffquDIqTE/VRQa90wmLFzhaS93Hrcpw+Yf33UeefhxHcbw996S/9BbR3NTld1Hjw5or4SOgzfEtTwDAhEiLXcGDSSsnZXQVQS6n+qgqmm+us+TRTxJKyw+3dYyCeEJkWujr9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YSxtHm/0pYrEgibVUCbuDBUSlZ7ayS7HeHQciUQxhr4=;
 b=UlnCufxkB6HRTrgtBwIACuMH2blutTrS+PwlhyKIyHQamcusEmPa2N/u6DetqhWI/oRKxNP7snJGPb+xpdnaePpaSxs8EO163ma8FMvM0eKzgkbW0QjfjJlv13VfL5p1Z+GfurBwQFs1nQjycEghg4v4vB6AZi1GYw3CNmmX5XMDhqFb3fKWAg/KpHpMoeZIPZeivDJHHZU5pYwYBLxbsaG88kWh5+spAFLk6Yenpa49RBDLAj0jIylFS3mOwNEw5PFvccbuQt///QgjnATZsEF4OSdUCHKUtDTcH2tnaIBvSQ/EK3PF3WNlbVCjCuLrSwRCBjAMafDs7DgOd8CLpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by SA3PR11MB7434.namprd11.prod.outlook.com (2603:10b6:806:306::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7135.25; Thu, 4 Jan
 2024 02:17:03 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::819:818b:9159:3af1]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::819:818b:9159:3af1%3]) with mapi id 15.20.7159.013; Thu, 4 Jan 2024
 02:17:03 +0000
Message-ID: <e90ac2af-dcc7-46b9-97e5-a5b5c58e5e42@intel.com>
Date: Thu, 4 Jan 2024 10:16:49 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 06/26] x86/fpu/xstate: Create guest fpstate with guest
 specific config
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
CC: "Hansen, Dave" <dave.hansen@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "seanjc@google.com" <seanjc@google.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "john.allen@amd.com"
	<john.allen@amd.com>, "peterz@infradead.org" <peterz@infradead.org>, "Gao,
 Chao" <chao.gao@intel.com>, "mlevitsk@redhat.com" <mlevitsk@redhat.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>
References: <20231221140239.4349-1-weijiang.yang@intel.com>
 <20231221140239.4349-7-weijiang.yang@intel.com>
 <bc19422761014edceffac971ec66d7a9a77f5ad1.camel@intel.com>
Content-Language: en-US
From: "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <bc19422761014edceffac971ec66d7a9a77f5ad1.camel@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2PR02CA0041.apcprd02.prod.outlook.com
 (2603:1096:3:18::29) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|SA3PR11MB7434:EE_
X-MS-Office365-Filtering-Correlation-Id: 94acdae1-a99c-43da-a313-08dc0ccb3dc5
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uH6aroL8VZE/K4H7K9bzPJq4yPYcj9idLBgsh+/q2l4kCDn1yqaeiVYFc6gZ0u3GiaxO+sQZkYBjzW/4ttoLgYs7UZdEgt9ew0B9ZmU7LCvZWJEUQ23kVvoUnUPs0luOcbYmIt+h2e4uZQNWMldia5Bq2IEi6Ij4qSnh1IBpAstVu5pneDquNa9riazgF6EceeBrYXjvSnqYKHtpHlH5OeqT7212S0K1B0Rva/9nLIyPLuMibPuQ94yqxF1HLP+iGwbuVWGBOkF7umDNIRYIX6KwAY6O1u6c+XWvFINVA5DkGmafSzZsLWWjtY4wHPQxGRNUzatXLHoS7EqEUPKj2eGYeLfGKGo6jAAWRvw0iGHvL/NMJz2pSMNUDBWpFu8V3LHIdqdRjVmcAEvP5GgrEmlsXpzBYeEUxP/2dOLzVykcR70gyeZkCoHqMfqJ5qjMr9F/gOiQPlIscB/hGmhFXKlYnb8USY4tzKPdQD57XF95gvu3UtRPIv7yXfWToasL7mm9l40jCwJ/9SbC58EZwDKwb+SltCB59b98jDyQbOkdTjCfhLqYlLXmxIIStiF5XKVnMVbpHUSpa148W+8x+1TTko7t+CDKzyDUzvwvE5ZCLD7jp0vPKEf1rOo0fHrisDHUOFPgWrrwGsDsHf6B6g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(376002)(136003)(366004)(39860400002)(346002)(230922051799003)(186009)(451199024)(64100799003)(1800799012)(31686004)(2906002)(8676002)(8936002)(6862004)(4001150100001)(54906003)(478600001)(31696002)(6636002)(36756003)(37006003)(66476007)(316002)(5660300002)(86362001)(4326008)(6486002)(41300700001)(6512007)(53546011)(6666004)(6506007)(82960400001)(66556008)(2616005)(26005)(38100700002)(83380400001)(66946007)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?R0Z3ZThlYk5ya0VLUU4yM1ZJekJtU1MwSDdtS1NNMDJQZXFUVk1qamlzVW14?=
 =?utf-8?B?cWFQZlVvNGMvODE0UGJvcmFmamlJdGlVdjRnSjF6UzFodjk4cjJIZVJkbnB2?=
 =?utf-8?B?RlJLRFRsQ1FRTHNMUW5SMTI5M3BUajFrdEtWczNodm92VmNDL3FUL2pLelMx?=
 =?utf-8?B?MjBMUGNGV0dYTVBYTmI4U1VsZDYzdDBNRi9GaVhZajJPVDF4dkZwVVBsUXBM?=
 =?utf-8?B?UXR2NDliM2hCSnZZOHE3V1ZXUE5FU215ak9LZkRiSG42UjJVRHI1dTRVY2Fs?=
 =?utf-8?B?SnEwamY3TFE2ZGlkSnM1MkppYVlyRkxPWkdxWEJPdHg1NCtrbm1ZZFdDem5z?=
 =?utf-8?B?RG9vYzR6Vm1LN2RNcFJBRzQ4bTk1b3BBYzRYTzNpQmJOTmhKSmJzNER4U2pi?=
 =?utf-8?B?YnVwR1ZXNWdWVHVhTmlEc29ha2dYZTl3WVZld2djMVZIb1gyV0JqR0J3TDdE?=
 =?utf-8?B?OUhSUi94MWxTL1JoOS9mdnBTY0RXWkFxRDhocm56d1JtOXgrY082aEw1dWNL?=
 =?utf-8?B?dUdMUkE1c3ZWSzV5Z1MrVTFFYWE1WW5HcXNVWGkxZ0R6bjFOckNmY3FwcmV4?=
 =?utf-8?B?L2oyVi9KSnQ5VmVuTngrKy91bklhNjAybm1VUW02YXVmMVZIOUkxVEtnV1I2?=
 =?utf-8?B?V05tcHA3VDNmUEEvb0xHS1pvWk1NYnJFeDJnMyszZk1zaDcwK2t4eTZoNjhR?=
 =?utf-8?B?TVV1ejVNQXR5TnkxWVVSYlFGVTQyOW5YblliWDd2b3E4VC9Ceks1YW5KVnZI?=
 =?utf-8?B?L3haMkM5WjU4MlZYcUxxSUI1bW5rOG9SWGw2d2dwWnIvVkEydFlsaDU1d0Jk?=
 =?utf-8?B?RVJKRlBRMlNjSGMrK3pTcDhibWNGdStXSWwxNm4vRnZIaG9MalM2L3JTSlJM?=
 =?utf-8?B?SmZ6UE5ubnh6UE5DNlFhNTVYSHZJMWpHS3pDTkx3RVd2cGlDR0x0RWU0ekpF?=
 =?utf-8?B?WkVxMXNiVTNXK0dzNWRvbE1oWDZGb2ZRZHdwUEVLNU45UHdqWXJldmdldjQy?=
 =?utf-8?B?cjlzMkNRZjkrRFNTMXhkckhONWJiMXdRbWNLY3c4RTVPbitKczNQbldJVHQz?=
 =?utf-8?B?U05JMEtSUG1QOHh3MG40L0ZkdTBhYVVlT1FCaUxkMWxGcVFHenFVV0pOY2Nq?=
 =?utf-8?B?N292UnBVclQvUDQxQWppMnI1VHg0SnZiMG9SVkh2N1pOUUJaVFFabG54b3Rx?=
 =?utf-8?B?c21IMUxRaHR4ZWI3SjY0MXFUZmVWbFREZVZHZFZTd3ZJRHNOTHg0dGdxdkVp?=
 =?utf-8?B?eTI1VGh2MlIyMmRjSU1uMnluWEZxMFNaMDd5MTJhdHdwQ1UzOUJrcUdicnFE?=
 =?utf-8?B?NHkrbDJ5eWpUQmJSNUZTWFMrOXFSYkdBM0xVK3JiY3BZYVhONVYwTVAzSmJG?=
 =?utf-8?B?NFJOMUViWjJTcCtaVXhUZU9aR3JQR2ZzdE9PL1BFekdENjB5Q0NTNmdKWW5Y?=
 =?utf-8?B?VEZNUUJRcmg0amVjWlhNUVQwVmFDaGZVNk9DeU9GOUxDVG0wMkV4Umk2OVJE?=
 =?utf-8?B?bEgrK3JqWVNJSE5jWUhBK3BnelQ5aUtqT0dZaU9adTY5OUgzU21VQnplVFl3?=
 =?utf-8?B?OXBPeGFlZDhOYUpvU1hBamkxSzJxNEFWeU5idTNvaUp6cklTZUhhZWpZWkEz?=
 =?utf-8?B?VlIwN2dLYUZDNUVUVi8vRGtONHNoMTR6VklWcEZDd3F0dVd4WmYxWm9vMmZs?=
 =?utf-8?B?V041eXNhc0Z2aXRTMjQ4cXVKanU5NXRyN0JEdmlLN04wUHBVVUdSRGZvV0xJ?=
 =?utf-8?B?LzNwaEJLWDJoWXN3elowdHJxOTRnSXIrcDNzUWpNczByb21ZZFNJdnBaVzZV?=
 =?utf-8?B?N0VibzFzNm9sUGNHSFVnUmpXaUdicGI5dkdsWmNJalIwNzllNWVxRlZRaUJ6?=
 =?utf-8?B?ekF4L2JkZlBLZXg4U1dIV1llWElzQzB4KzNzeVZ5bFFNcXA3Smk5TXZiQWhq?=
 =?utf-8?B?ZlAvZFZUM1pRYngwaTU5YmIycmN5ZHlRZHNKQkJGeHFEdmdaTGtrajRMbGxx?=
 =?utf-8?B?WHBpenBueWF0L201b0dNbVk2K0RyWnh2dkl2VzI0eUxCclU1VHZOUUFVdkVN?=
 =?utf-8?B?ZDJ2dDJDV2ZQL2daTTBBajRTaHBOeEpMamUyck5XRVU1NTdwZ2lzenFhaXlv?=
 =?utf-8?B?eS9vekl4RGJ3azBSUXpoMDRjZkd5OFBSNGkwTFJZdVlXb3A4ZVNVNUNmN1BR?=
 =?utf-8?B?c3c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 94acdae1-a99c-43da-a313-08dc0ccb3dc5
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jan 2024 02:17:03.7634
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mcv2sSq4ajoan40D8Z3q2HqL1WoZBvJoHq/bC0CvSZ1P6hfmDin12fbErwv8PIOWKsF0QuBIf23U8Nt5LPCb5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB7434
X-OriginatorOrg: intel.com

On 1/4/2024 2:16 AM, Edgecombe, Rick P wrote:
> On Thu, 2023-12-21 at 09:02 -0500, Yang Weijiang wrote:
>>   #if IS_ENABLED(CONFIG_KVM)
>> -static void __fpstate_reset(struct fpstate *fpstate, u64 xfd);
>> -
>>   static void fpu_init_guest_permissions(struct fpu_guest *gfpu)
>>   {
>>          struct fpu_state_perm *fpuperm;
>> @@ -272,25 +270,54 @@ static void fpu_init_guest_permissions(struct
>> fpu_guest *gfpu)
>>          gfpu->perm = perm & ~FPU_GUEST_PERM_LOCKED;
>>   }
>>   
>> -bool fpu_alloc_guest_fpstate(struct fpu_guest *gfpu)
>> +static struct fpstate *__fpu_alloc_init_guest_fpstate(struct
>> fpu_guest *gfpu)
>>   {
>> +       bool compacted = cpu_feature_enabled(X86_FEATURE_XCOMPACTED);
> With CONFIG_WERROR I get:
> arch/x86/kernel/fpu/core.c: In function
> ‘__fpu_alloc_init_guest_fpstate’:
> arch/x86/kernel/fpu/core.c:275:14: error: unused variable ‘compacted’
> [-Werror=unused-variable]
> 275 |         bool compacted =
> cpu_feature_enabled(X86_FEATURE_XCOMPACTED);

Nice catch! Will remove this unused variable, thanks!

>


