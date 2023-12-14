Return-Path: <kvm+bounces-4426-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C0C48125CB
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 04:13:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 57E301C20F73
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 03:13:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E6D015BD;
	Thu, 14 Dec 2023 03:13:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="O7bjHpUe"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.88])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABD50B0;
	Wed, 13 Dec 2023 19:13:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1702523587; x=1734059587;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=FmRORALTgLIRBvp5uX+T/w2+i1ZxjjDLrd0gZVQ1DKw=;
  b=O7bjHpUez4HbA1Fg1vtmCGjRZzWZRr0Xj5PDxDt+7TiVpcroGcOj/9/7
   zwDNSTvfd7YLxjd9lztvqNBeaArVnwBBMVJNW/zy0ByD0fJ3cpNPg7Qpl
   BGWAKpInnLpzAOZdtQshy7Bptac5YI7clWRyj7doq1fWFqcsXz4ONp5i3
   r/hz3NGUDue3BLHn2jKeBbtT9522r2GAFG4dbOw7sM7J1zwalVkutNz2i
   ZrRLTC6EwuMIysHHkdPgde8uxM7948NL3VyS68DWVedcb0vETX5cqETOS
   L2Be6X3IUePIu39b7tOGBR1LP1YLY2Z+jsA96o+8JHzYS+EVf3DhUHe/+
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10923"; a="426194004"
X-IronPort-AV: E=Sophos;i="6.04,274,1695711600"; 
   d="scan'208";a="426194004"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2023 19:13:07 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.04,274,1695711600"; 
   d="scan'208";a="22220369"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 13 Dec 2023 19:13:07 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 13 Dec 2023 19:13:06 -0800
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 13 Dec 2023 19:13:06 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 13 Dec 2023 19:13:06 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 13 Dec 2023 19:13:06 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ntLRXkykMePkZ8RLaWBh4dAAWdpOu7NVytFsqA6YOnb8VGElSFCFWXEe5bGOZFuzOxZ8LelvEATKHfG4bmABCYE1Y0fkfDZvMH665j01936jMYLZMHHW2sjcfX2Jm/1I4R7qtg0F1y/NAdJkUaKUE5+pACp1gj/rdNP0m3HYtTDs6m7vvWiytv4alLx7OO7AUwyzX3Mfh+LwNc8vJYULxpbnsKifeox8kTRNoHgr9rujTpulKQpBXozJUhsI0rRR1rotc+P5G2NFvwfnaWskLyiHcJEkGJenon/YSJC6bmclY2PhzEALfrHfdf43gRmgvPJDRLj/to/8jiEXJ4wsNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FmRORALTgLIRBvp5uX+T/w2+i1ZxjjDLrd0gZVQ1DKw=;
 b=F1lqoN4mxK9JYvJnTimHRaIlxiLD790olZL3fR8YWaUOl7xSfyEjbNtXTI2IKee++l1C5/7xJlECeNsKR1XASF2um9WmYwtIoZeTec9BtRk+6O238NsAPsOnb++JWFHS42MviHGzq+Uov1H1lJ7qcP0cYQI3RIxsiUtlyJwVE2fhhRd82DPxN7KqtqKR71zuu0zt8NLI7Qvoj6b1eyK0MIMqvnlI/S/iHY2gSn9Jo+21h6s2l/pWl8PuMoJ6mMgqgSHt5ME6khddxqM6U8hxtqcGgBtx9UCXNNy4sHmiBbf8JMK2EfsAI7jNTbrarO6GQqPh6BshD1YotAgcbckO9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by SN7PR11MB7668.namprd11.prod.outlook.com (2603:10b6:806:341::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.28; Thu, 14 Dec
 2023 03:13:04 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::ea04:122f:f20c:94e8]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::ea04:122f:f20c:94e8%2]) with mapi id 15.20.7068.033; Thu, 14 Dec 2023
 03:13:04 +0000
Message-ID: <121cb43b-029d-4d34-8f6c-15f41c2dd0aa@intel.com>
Date: Thu, 14 Dec 2023 11:12:54 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 02/26] x86/fpu/xstate: Refine CET user xstate bit
 enabling
To: "Chang S. Bae" <chang.seok.bae@intel.com>, Maxim Levitsky
	<mlevitsk@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<dave.hansen@intel.com>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<peterz@infradead.org>, <chao.gao@intel.com>, <rick.p.edgecombe@intel.com>,
	<john.allen@amd.com>
References: <20231124055330.138870-1-weijiang.yang@intel.com>
 <20231124055330.138870-3-weijiang.yang@intel.com>
 <c22d17ab04bf5f27409518e3e79477d579b55071.camel@redhat.com>
 <cdf53e44-62d0-452d-9c06-5c2d2ce3ce66@intel.com>
 <20d45cb6adaa4a8203822535e069cdbbf3b8ba2d.camel@redhat.com>
 <a3a14562-db72-4c19-9f40-7778f14fc516@intel.com>
 <039eaa7c35020774b74dc5e2d03bb0ecfa7c6d60.camel@redhat.com>
 <eb30c3e0-8e13-402c-b23d-48b21e0a1498@intel.com>
 <e7d7709a5962e8518ccb062e3818811cdbe110f8.camel@redhat.com>
 <917a9dc4-bcae-4a1d-b5b5-d086431e8650@intel.com>
 <62ff5c86-a63a-46f2-88f8-6c1589433a89@intel.com>
Content-Language: en-US
From: "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <62ff5c86-a63a-46f2-88f8-6c1589433a89@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI2P153CA0005.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:140::11) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|SN7PR11MB7668:EE_
X-MS-Office365-Filtering-Correlation-Id: aad72991-8137-46c2-74cb-08dbfc52962a
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bb4G36mgh8quCt4KPZJIWTm5sPfeMBxFC5DlbrvdNBoF2TTVOxwkvSUJF3SbWjLYQT/ds2n7fhXMSIgoWLA5ynkMvYSb32Zdsfmp10KGvAusFfp1OgfKwwT3ditcxUHUGpUDYf1b8mbpZp9VT6xFRtHEbY5Qg2XtpxMFMTu7QDWAPAgzMGW3VDw0aCVp+UVN1Q3/EObzlwZkQPemutsQigfZXV2+VuqXSQv4AE9R4puJ8Z7jfcNQwBYqOvNYntZ2M/W0iyz++9h9XNcPDuXW0bUUnyw31BIMSXiT0j14SM/8AkB25vxlA7OWKZAe3HoQzD4dSilSgQwq6/BlbAOcwW+h4yVpF/5X491N8XG/DbySrwaVJgWlZ3oBcI91Qua4l/NoXQeltpLYNlxr0EjjCPAuXX7DJYZBpVbFLe689UAkI6TkLrwmnJx0MLdwtgkK4DIoPRuF+eUGDObdbT6g4oG+212poaqvnJJjBkB2/40YyXalpIa3BpIkRg4f65GXwbNGaTfWWRxt+/+ltzjaqaMPk2OA7+p7UhBWJDNrQ69ylqPbBIqppbWbpmbZ+uOSaLsSPc5xN68e2j27tD4b8JRmVUgfXsfeePkOjbUR6I63v/c8/Mg+kJvDUxfQW+Hh9jpNerjr5IKMMV/EyeC0HA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(39860400002)(376002)(346002)(136003)(366004)(230922051799003)(1800799012)(64100799003)(451199024)(186009)(31686004)(31696002)(86362001)(82960400001)(36756003)(6666004)(41300700001)(478600001)(6506007)(53546011)(66946007)(66476007)(66556008)(26005)(6512007)(38100700002)(83380400001)(2616005)(2906002)(316002)(110136005)(6486002)(966005)(5660300002)(4326008)(8676002)(8936002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SVNnSjNON0w3bXV2UEMxajg0ZDZ6VWNhd0lLRXFpUW5CSnRCU3IyVTRKYXdN?=
 =?utf-8?B?VkNkTEZpeHpYTVdoWVZJT0ZodHVYR28zZFlzdG1xTHJFblVlUDM3WUp0YWhF?=
 =?utf-8?B?b2Z0dFNOOEFhazQ5TlNTZWhBWTgrZU11bFp6ZFlEeGsvZVRzYURSTFkrZ2U5?=
 =?utf-8?B?bUF6Nk90Q2FKaU1TY29ubVJJUVhxMFlpelkzTExXb0k3Z01zRHBuYWsvb1F2?=
 =?utf-8?B?RlhrTmp1QW5malJqSXo2RXl2amRHM1JQWWYwVE5TS3g5Zzc2VGVSTy95NUVQ?=
 =?utf-8?B?OElJQisrQWdzYy81c0QzTGczajlMcmF2eSs1eis0M1JCZ1Z6SytxT2FXcW5w?=
 =?utf-8?B?YkdhdGF6Q3JMMnJJN1lKQUp5L1hCWFlUVmoxcU1tV28rbjZxUEozTVBQWm96?=
 =?utf-8?B?NTVZdG9NeE9QY09ONmtvVXhPaUR0dXJUczgxbm1DSVd6RTNOUWxtdGRCOFkw?=
 =?utf-8?B?YXJxUXIzdng0MFNsQW9VbEt4eGl3MGpDSVRMQ3diNko5ZlJwZE9YTnhJN0Nh?=
 =?utf-8?B?ckhEWDNaaDJyTWxaNmNrVGF1T2EzNzUwZHgyL3dTWlorMmxxTDFQdjZackN5?=
 =?utf-8?B?Q0NzSHc4NnZzWWI0U2JIczcrR05jU3lZTlNIWCtFM3BuaFozZDVIRitINXBN?=
 =?utf-8?B?SXovQWtCNDJGdUhnNU8zcWttbVpzZjB6RCtzTG1zbnUwcXY1S3ZuRDltWlBi?=
 =?utf-8?B?OEY0WmtQeEo1bGdqSUltM2wxODlKeVo0MmVCQXN1bXpuOVFTOGhVSWN0NzRo?=
 =?utf-8?B?ZlJ1UGpzUFVpRzA1RVpLZkhVbm9PWVJiRmR2SWJHTytEQkhqOFA3MGlva2NQ?=
 =?utf-8?B?L1lHR0RiU0p6TXZnMWdWQkQrSHhNNVFYeitkVnQ1c0VHTzI0VEF6V2JWTWFz?=
 =?utf-8?B?amZPRWFkS0RIUDFnQ09lZkthUlhHZjBiOU50QndtSVFDeU1Yd1ZFRDdBNUpa?=
 =?utf-8?B?akJDdDNTeG4yYXdab0hROHIxUEd4c1NMamFqOWFBSEVjYzBIYmNKRnRyTStW?=
 =?utf-8?B?VXhGVkkzbXFUejYzTno0WDFxcUVwcUFqUFkyOURSazk2WUduZXNWZDJCY3pt?=
 =?utf-8?B?M1hCYVB3VVNxeG1jcDl0eVdXc3V5SzlKT2kvd2YwdTdNS2hEcmxqQ2x1S3pD?=
 =?utf-8?B?RjRvM3lzdFdESDQrWjRKbFlxUnlJOHpaVC9VM0tGQis5cVdjdDdBbXJnM3lP?=
 =?utf-8?B?MGJsbjdabHhPSTFrTWttNGh2Nk1xUHZRU2tDR3pCN3pOTmx6VytacVZOb2FM?=
 =?utf-8?B?STl5TGhqMHh2WDkzOXY3ejBmZVBsZzBnRnZCV01XSG03RS90SGoxOCtjVytk?=
 =?utf-8?B?cnZaL2dqd2lXMVNSWXlOYTE3VzhoYnJOQ3ZXcXdpODhiNVNFVm9aS054ait1?=
 =?utf-8?B?cEVjUU4xM3dhSmNuV215WU10b04weTNYbEhXV3JJQ21lSEQ2R2NrWmRMSnA1?=
 =?utf-8?B?bUlva3lORlNPZE9lU1dKNmlEd0hUc21iVXJIWnBrQTFYbTlGVk5pZHRUb3FZ?=
 =?utf-8?B?V09lekJJQjBQcHBodFZwV045VmZyODkraWxCNUV3Q0tTckxLaFRvYnRBZ3JS?=
 =?utf-8?B?VFJLcDNLeUx2RzVMeEMreXFURnAxa2dyeVBiWmUyVm1vM1FoV09CL1pZR1BR?=
 =?utf-8?B?d3JHQ0lUQWJGZWxkU0FlUFFzYWdKallOaktsUy80VTJIVTVndHQvYmRwV1RK?=
 =?utf-8?B?Z2ZxVnc0dnRaNlhvbUVPWjQ3QlZ4aXdZaXFIb09Wajh4ckY3dmp4QU10Wis0?=
 =?utf-8?B?M1FjME52YjltQVNpNDc5L3AyeFFEY2ozRGNNQXp6dm5ic05UVkZSMFNYK2ZO?=
 =?utf-8?B?ZS9Ub2wrcm5aU2dmNDBJaHNheURTWHhQc3RKUzdGMUQvRGVjRnBROHlrc2M2?=
 =?utf-8?B?ZDkyZUVESDlHemxjOURDWEsrMHhocjg4aW1FS1g4QldFTEgrZFRwa2JkNnVr?=
 =?utf-8?B?czlrSTFXZmlsTko3ekFQNjljWFhRdVBJVDB0eSs0UStlSFJOUjRURG5ORTEy?=
 =?utf-8?B?bHNaVVQ0aEpoVThaaWRxQ24vVUZHOW5mZndXenlxeDVyYXhUUmg1RU9Va09m?=
 =?utf-8?B?VG9kbCt2UGx5emo4dEs0d3lXNCtrY0krR08zZ0kwZzlndlBrOFVnUHlVZEZL?=
 =?utf-8?B?V0NuSjZZSjRaWkp4bXpTVFY1Tms3ams0ckZjTWhNaGtGOVBkVGgzeHIvOGE4?=
 =?utf-8?B?V2c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: aad72991-8137-46c2-74cb-08dbfc52962a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2023 03:13:04.3043
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3wo41TgC9MgV7YUcAPS/jKh9SjlzL2+gp1EUtxF2oIRVLB5Jb/pgma+f4iDXqghtVQX0mMOtsdvV832TfqT9CA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7668
X-OriginatorOrg: intel.com

On 12/14/2023 1:01 AM, Chang S. Bae wrote:
> On 12/13/2023 1:30 AM, Yang, Weijiang wrote:
>>
>> Let me involve Chang, the author of the code in question.
>>
>> Hi, Chang,
>> In commit 70c3f1671b0c ("x86/fpu/xstate: Prepare XSAVE feature table for gaps in state component numbers"),
>> you modified the loop as below:
>>          for (i = 0; i < ARRAY_SIZE(xsave_cpuid_features); i++) {
>> -               if (!boot_cpu_has(xsave_cpuid_features[i]))
>> +               unsigned short cid = xsave_cpuid_features[i];
>> +
>> +               /* Careful: X86_FEATURE_FPU is 0! */
>> +               if ((i != XFEATURE_FP && !cid) || !boot_cpu_has(cid))
>>                          fpu_kernel_cfg.max_features &= ~BIT_ULL(i);
>>          }
>>
>> IMHO the change resulted functional change of the loop, i.e., before that only it only clears the bits without CPUIDs,
>> but after the change, the side-effect of the loop will clear the bits of blank entries ( where xsave_cpuid_features[i] == 0 )
>> since the loop hits (i != XFEATURE_FP && !cid), is it intended or something else?
>
> The code was considered as much *simpler* than the other [1]. Yes, it clears those not listed in the table but they were either non-existed or disabled at that moment.

Thanks Chang, so I assume the "side-effect" is intended.

>
> Thanks,
> Chang
>
> [1] https://lore.kernel.org/lkml/87y2eha576.fsf@nanos.tec.linutronix.de/
>


