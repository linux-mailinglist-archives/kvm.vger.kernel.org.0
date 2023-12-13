Return-Path: <kvm+bounces-4368-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E7AC811A53
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 18:01:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 99ED71C209BB
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 17:01:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F35223A8CC;
	Wed, 13 Dec 2023 17:01:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="A3/I22Kz"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C18CCD5;
	Wed, 13 Dec 2023 09:01:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1702486905; x=1734022905;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=i2Btu+LppD23/CpTFvAsyEJJzgAepbd+Kdk09dCu/m4=;
  b=A3/I22KzNxbeziabEquPJBW9W8cB81VsVknh0hd4c/Xj8yd728N+Mrqu
   K5YXm1Q4HrmsvkRUobnmeLc6Y3ZcQODnPg2iF/8rFXh3GPJD0d8BLz/2Z
   qfSil6cuW1axZHKaq+ZFSkVogikNWuoAc1GGKIHu3GT8daDjdW7vkQz0G
   Nwc/g/lv5y/Ix35mV3kGD36ur2d25NGaGX5hj2/NTkMJ0BfGlS+C1kbuv
   DYJ2+bfRuKXhmVn2W5vu1imiS+P2mFY0D5OyGjavUI0FSSXPRYk7bdZp4
   kjz9lfyYZ7kNojgkDaMPK/3EUbZoFrbk3/lS4bjl+MZCnCAIEUeKnGLQr
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10923"; a="1832553"
X-IronPort-AV: E=Sophos;i="6.04,273,1695711600"; 
   d="scan'208";a="1832553"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2023 09:01:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10923"; a="767276123"
X-IronPort-AV: E=Sophos;i="6.04,273,1695711600"; 
   d="scan'208";a="767276123"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 13 Dec 2023 09:01:44 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 13 Dec 2023 09:01:43 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 13 Dec 2023 09:01:43 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 13 Dec 2023 09:01:41 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QylBhvYjV32NiQ3KnAz6N7QV+BacKcPXew79JYVJXt4pO4g1nJO8xKJ9iqosDRFSr+La548Nt174dkQa9QmkNfcTOLy6AwjDmein8IDGVzWD0o0LNaI91Gh7cFra4l4Y7z0XX0YmRDf36O2z1HhHTHUsL4Fw+oE3Evt7sqAM+yDNjP4WYgl3Qbmyskt0dh8QcODJY9sro86PumYWm0gf9ee5/PbS+nP2HSgYpR8tVHypJG0eOghsAXWfUtd0UJDrSgTQQQVUBHCPjlu4Ys6Zm0nqrCfvI2Tsk+W8uBY11oMU7ORFUmr+yP7RUW5Sr1KP8JepTwUSvtOk+BPS203NxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vAilKBwhOpJeSaZweRcWnCOqslTi1oibcempo1JGTnA=;
 b=dWbLYa+HlFLQkZYWKxvMZT4KThayZEyiNaushW00CHJqysZW+7o5on2UwUjeRMQISr3NyJQkpftFCcYFe67Ss1vDrsCfBMs+KCTwKr+m1tcn+woG38QnEK5XdiWIF0SzUKPFkTXXR8TJXzcBYyQRZ7KQSoNcL6AQq+ZCX5s06eOGMt0M1ERLh748Au+xSjFGccKHadj1au7GiD0zhdAl0Ic3MEZyFx2ULRdMRbnfQ6Fj13da6rBS0vqhFfapgDyWyP8wYmBgsYDbKOwC1ZD+Xn842xz2qHUtFlQ+H2W3Aep34b/kVJXxNMovidIZPCbkbkchdPMo/o4A/w5EK3r2Lg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MW4PR11MB7164.namprd11.prod.outlook.com (2603:10b6:303:212::6)
 by MN6PR11MB8101.namprd11.prod.outlook.com (2603:10b6:208:46e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.26; Wed, 13 Dec
 2023 17:01:38 +0000
Received: from MW4PR11MB7164.namprd11.prod.outlook.com
 ([fe80::b046:5de9:de04:1398]) by MW4PR11MB7164.namprd11.prod.outlook.com
 ([fe80::b046:5de9:de04:1398%6]) with mapi id 15.20.7091.022; Wed, 13 Dec 2023
 17:01:37 +0000
Message-ID: <62ff5c86-a63a-46f2-88f8-6c1589433a89@intel.com>
Date: Wed, 13 Dec 2023 09:01:35 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 02/26] x86/fpu/xstate: Refine CET user xstate bit
 enabling
To: "Yang, Weijiang" <weijiang.yang@intel.com>, Maxim Levitsky
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
Content-Language: en-US
From: "Chang S. Bae" <chang.seok.bae@intel.com>
Autocrypt: addr=chang.seok.bae@intel.com; keydata=
 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
 QkQDm7wWI9p7y/dzNpPNWICDtQ==
In-Reply-To: <917a9dc4-bcae-4a1d-b5b5-d086431e8650@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR13CA0234.namprd13.prod.outlook.com
 (2603:10b6:a03:2c1::29) To MW4PR11MB7164.namprd11.prod.outlook.com
 (2603:10b6:303:212::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW4PR11MB7164:EE_|MN6PR11MB8101:EE_
X-MS-Office365-Filtering-Correlation-Id: d5ba02ae-dca0-4b68-87b6-08dbfbfd2b72
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TodLKJw0jwU7NOTfnF3Cf0ZTxmqOXOOI0SwlAhgFTUbZwuJrmKm3lL2TnHhcbiqxhH+SjlAIJI7ljEE194xV6P/S2QTLYpNDPYwaRyL+LI6Wa49ZwJJYmrfj7GaJWvr6bqfgX1UV4i90O3iKaNEL/FtUZHFmwt2UGbXpaTo1LeKQFvIP9+fMXDYOjzj2LOFoNzvUDZFWoWxPB8iWIaTNg9u6fGkyXJdXp8GxoQ1crX791/xhtNZIFC08tM+BBdzyH5B1o9qrxB4Tcii9w2XUVZ5xKZwCTOnlcfBEUQlAZHgEvoTiDpVzNK4QDzBDRp2fks5RxsajAyDyPx48hAR1g4A0jtBaPkmYZ8GS2AOgZ0y/TJ4Cvr7j8loSVJhTjOTYp8cyGAid6XECSjhgyZT1+C/6V626G1/sjSQ5KkgR0oNgrohQQ8bx2Sa95Rpjd2LPXQOj/Dfho5pIBAPBBeAhLA1GRozyA+oJ2+3D7oJF2fscJn/YtaKu0uK/JjKnRFMWo3CCQp8zch6QivJ+C5EvLH2JQGPTQjVh4QVyix9BMqrl5Ct4ZQ4OgB7RFGLr8NPD1MO5i7/mT5edZi5ocr2cw5AsG+PXJOzdOdf6iAaQpB0HgWwGxgda3oLhsXi+ZMSeyD6b3DpC+ry0nAyWMp/6Zg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB7164.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(396003)(136003)(346002)(376002)(366004)(230922051799003)(64100799003)(186009)(451199024)(1800799012)(83380400001)(41300700001)(2616005)(26005)(6486002)(966005)(66946007)(66556008)(5660300002)(478600001)(86362001)(36756003)(31696002)(31686004)(110136005)(82960400001)(8676002)(2906002)(8936002)(4326008)(66476007)(316002)(6512007)(6506007)(53546011)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Rzd0akhDYVQxUWxYdVlINGRXb01lK2dIc3h3QmhMQ0tndDJpUUpEMGQ0M2FC?=
 =?utf-8?B?R3JBQmRDeU8xR1pYbUhPQ2c4TklxaDFVaTRuclJBakpQaDgwRGFTOE5LaGUx?=
 =?utf-8?B?bkF3bFZvcDlab1g1cmt2WWpwZkFHTTVKeHdtRUExdUZJMWNDSkdFRGxYemdk?=
 =?utf-8?B?Nm9jMndVMEUxVlVpZGxPVmoxdmd3VVBWZlBlZUlyUm5oOWdUc3pERTlYVDlS?=
 =?utf-8?B?SXJXTVgyNEh6RHFYd3hscElVejRVcmZEa3dNMys2VldpSURCdjhNS0RLSVJp?=
 =?utf-8?B?RXN0aG1wSG5ybVpmb0J4Y0JLLzJKdGh4WURLNHJpR1Z2VEJFc2ZkYXJJek52?=
 =?utf-8?B?cWQxaUhULytRczQ5MEhaT1cvRjBtd3hvejFnYi93SVRhR1NBQmdXWXllZnRZ?=
 =?utf-8?B?N2wzcklWaWVNY1ZZa1l0cHpmcVlEakJRNXVzZ0hrRndSYm1pQWVUWUkvMUNB?=
 =?utf-8?B?aHR4elRuUVl2OHN1RnR4RmU0THRUQjRNcXM0dmlZK3FXaVhObmRaY09Hanh6?=
 =?utf-8?B?WWxoQlA5L0tmWXNGZGZ6L0xpVnRIVzZJSHZ5TjNsU2ozdTl3Z1pnTERwNC9H?=
 =?utf-8?B?ZzhsVkNEZnRqNHk0eS84S250VGVmVndEUkx1MHFkWWlmYzhTd2JYYm5BejA4?=
 =?utf-8?B?MFRWMHYySFA3V2lUQlFjVXNheHRnVTNZSjNFTmFRWkhyWlE1YkZhd3BjVTlQ?=
 =?utf-8?B?eWgzODROUGZvN3BXRVk5SWM5QTVsaUluZk1FRExiOGlXUWxKa2pJcnJmMWVj?=
 =?utf-8?B?WnZTYjY2ME52OXUrazd2YnRtZmxjSTIzV3ZvM1h2ZTZCbUx4TmgxYWV4d1pN?=
 =?utf-8?B?Q1QyQzlhRG9BYkFPUGF3WVpmRWsvajRUdkVlTDFKQVRaWHJldnJiU0NQekpn?=
 =?utf-8?B?bENKLzBLbUkzT2pFQW9hSm05dGR6ZWd1bmQ5YlBkdW1pNXlJNG1ySlBHb0NZ?=
 =?utf-8?B?OTY0bk9YNmxwa3MwSTFnRkNOTDh4aXlzei9iWW96OWhabEV6RkwyZGtCeHYy?=
 =?utf-8?B?UWt4TitEVkl3OWROKzFVVmovTWlxMFMySmpzM213WmdCMFIyWFZpYnZMRzBw?=
 =?utf-8?B?S2hvMmNoYmM1V21oajN6NVdPTTRUcUcxT2RnQlRDZGZReU9FVEJzOFk1ZDU3?=
 =?utf-8?B?N3Vra2hpY0J0WFl6Qk1mMGh0bTlYM2Jla0ZZejh4UmN0MFA2eEFRSForYkVl?=
 =?utf-8?B?OG55V3AxeFdoRUFKS1JDdjRtbTlEWTcvekRRVlpkWVZYQUhieW5RSElFNVYx?=
 =?utf-8?B?cXpGZVJsOUlaVUE3WnFYeklIN2VocGZ5bHlvYmRMRWljdXJtZkk5THBtcEVY?=
 =?utf-8?B?SVpveGdhTTBlYmM3c3VUUlRhZVFrczRlZk1FUEk5dUlmaTczOVJyeE1HSUNO?=
 =?utf-8?B?OWp0dXNnejhRUHJTeUJNZHJDQjJtS1lPZGxYTFc1MG5KeHd5eE5jZmkrZHQx?=
 =?utf-8?B?NmovemlBMnk5dW5raEVTbUp6VmE5QlBlQ29QTUtzU1NTQTh0MFRLQVhYRjUx?=
 =?utf-8?B?cG1INHhiNVVQMVpta0pSTXpJMlY4aEZEK20vMUFERkFPMnJvMXpmQjNiak5u?=
 =?utf-8?B?czF6UDBFQ2pVNG5TcUdaNjdzWEdFNGgxUGRkWnNNT0FPeU44Nmxac21aTGxw?=
 =?utf-8?B?dGlQVlFtZ2ZsZ0JWay9UMFRLSWNOZ2lwTlFpb0I1aXdPbWZwdFdOZGJaZjEz?=
 =?utf-8?B?QmxKcU94cWhkS1JCWXdxL3RqZFpIVEd3TnFXODY4Q2ZvUXFlUkUrSFVoS0xj?=
 =?utf-8?B?c1V1bWxkdDhQQ253L1B0SzFja3NSUXFtTnFFcEpQbGhJUmk2SEFEN01aUTBt?=
 =?utf-8?B?U0tnYU9IZlhPTGJoSWFMTEY2aUc0bWZ1c2JPM3pFSHhsZzRpa0JKbWxWZXhT?=
 =?utf-8?B?YXpCL2kreGtFUXpzZDJCaEF1U0wzckdtWDk3RndmK3RNbEMwK2hqRHQ1Rm5t?=
 =?utf-8?B?TDQ4d2ZFWWQvZkNMU2R4OWx5VjkwMms4TnhGM0dKVlphbmxMYldzRTlhNDVM?=
 =?utf-8?B?djQvcDVDQVBUMTQwSWo4bVR0Z0tDbzNTVzd1aU1qaHZCMEFWck50YmVweGhO?=
 =?utf-8?B?R1VCQjlWSDhCU1A2L24vazlKSmdBMFZGYzJqVzducFlnRUNsR0g3RUZqVlJv?=
 =?utf-8?B?VHV0K2h4d0lwemVYWkhCU2FYQlR5S21VVW8zdTl2R0o4ZlJmVWd0Z1I1UVFt?=
 =?utf-8?B?dFE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d5ba02ae-dca0-4b68-87b6-08dbfbfd2b72
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB7164.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Dec 2023 17:01:37.8991
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z0Pz4txnR3q1XhfLjCXiJrrDCQci2jKdD3pDVF4dE8x8ZkskCMUPAZWfbFFdB7tBcUiws6NWu+ppnIFr/U8HoqzfztHLjHI0geAEtcNfCIM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR11MB8101
X-OriginatorOrg: intel.com

On 12/13/2023 1:30 AM, Yang, Weijiang wrote:
> 
> Let me involve Chang, the author of the code in question.
> 
> Hi, Chang,
> In commit 70c3f1671b0c ("x86/fpu/xstate: Prepare XSAVE feature table for 
> gaps in state component numbers"),
> you modified the loop as below:
>          for (i = 0; i < ARRAY_SIZE(xsave_cpuid_features); i++) {
> -               if (!boot_cpu_has(xsave_cpuid_features[i]))
> +               unsigned short cid = xsave_cpuid_features[i];
> +
> +               /* Careful: X86_FEATURE_FPU is 0! */
> +               if ((i != XFEATURE_FP && !cid) || !boot_cpu_has(cid))
>                          fpu_kernel_cfg.max_features &= ~BIT_ULL(i);
>          }
> 
> IMHO the change resulted functional change of the loop, i.e., before 
> that only it only clears the bits without CPUIDs,
> but after the change, the side-effect of the loop will clear the bits of 
> blank entries ( where xsave_cpuid_features[i] == 0 )
> since the loop hits (i != XFEATURE_FP && !cid), is it intended or 
> something else?

The code was considered as much *simpler* than the other [1]. Yes, it 
clears those not listed in the table but they were either non-existed or 
disabled at that moment.

Thanks,
Chang

[1] https://lore.kernel.org/lkml/87y2eha576.fsf@nanos.tec.linutronix.de/


