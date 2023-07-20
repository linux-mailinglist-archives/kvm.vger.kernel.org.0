Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B1CD75A426
	for <lists+kvm@lfdr.de>; Thu, 20 Jul 2023 03:55:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229732AbjGTBzU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jul 2023 21:55:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbjGTBzT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jul 2023 21:55:19 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 187A21FF1;
        Wed, 19 Jul 2023 18:55:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689818118; x=1721354118;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=cRUqsJQSEaibpc1Xsk3sFFFhdcWZkCPriiFS6LSIpvE=;
  b=ecARvgBUrLdZYqAORlb74OA81vB3OgdknzufC15XJTBtEgKqCCkhzLHv
   91MRXLVgrboUiRcl+DV2lt60DOrDOYavDpMYW2pAVjideVy4YwmDKpDsF
   ztQ4fVhM1P5X22xCSe54zp4s+BfjzPujora0q1m3jKN+tg/NDqBZPVfL3
   KG6APb/cAOAZdMk5nneMidpGjoNK7TnMlTB+/iQDnj8QMEemOP2NyWRoh
   puv7e3rm6wf65fiWgIIxpo9W8d3MDEncS+f4AX2Wnxuydv6+/IuZkIZLc
   vJ3mTxfg/5bHHEZb4BaGq3kf8saPIe7cA38YBCdzwYII12SgN5POnIKMb
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10776"; a="432805743"
X-IronPort-AV: E=Sophos;i="6.01,216,1684825200"; 
   d="scan'208";a="432805743"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jul 2023 18:55:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10776"; a="789611220"
X-IronPort-AV: E=Sophos;i="6.01,216,1684825200"; 
   d="scan'208";a="789611220"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga008.fm.intel.com with ESMTP; 19 Jul 2023 18:55:16 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 19 Jul 2023 18:55:16 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 19 Jul 2023 18:55:13 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Wed, 19 Jul 2023 18:55:13 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Wed, 19 Jul 2023 18:55:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VsMLZ8U+lET9VVNNSYY12UFqsTAl+9pZeLfMewJuyKBKw0tkgXOLzNoGw8CwpDRXVC9wkFtqnXx4cBIwntrD8cK7u5FFtKUQpafki+fq6HC0ire+c/ooD3s0PY5yFdPDuwK70yxxNZByytSfX9SYtlM/gH/WE6FgKXzLtshqqR5wHvizyvQpy0fCisd6pWNMjqbHNbMmMSqrSxoj68t1e7TGc7SGLv85s5X2gbHcTJbi0zAWHWZPZzp1R4AhQoXlLmn9Sb7fMQwMtVEW7Xz2nADC96gCpUkryeX0+SYNQCoxEsq2n3TYQp0M5+5Be49NqNBt9FzsO8gfghq0VdKz8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pwhRAVZBbLIkfCbutDI/IjTrSZGnndtKTKqgitDvDoE=;
 b=gCEEQ9HTHo16fBNZVzGM/pJwKPwHNweTsaiN+4f0u14uVoUdZcj3n5J7hmgLFcpRvPvPU7qcKJNnm6/srmoQqUYL+G/wRIH4q04u1ZPlkDsHSSwYJOM/x4wGl9XtT8yp+WQSgVP4KR7VVpLdf19y4jPrj9S6voOnmZ8hmUbgNM1KwSMiAgr5di7yPFzFni/yfu40891zBlbZ+Lj8xnV89LEfjeICf7rwCd+0khABRENCLED+yfkZs7B63wEDMbpN/esc8r+AutZO6EniYm3vuFgMY9ujTNlLcTUvBX1kRusvyj79wJIXEXeBjROoutgPfZybMfBqfPBPRQcTV2en2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by SA1PR11MB5921.namprd11.prod.outlook.com (2603:10b6:806:22a::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.23; Thu, 20 Jul
 2023 01:55:10 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::f99f:b4d:65e6:7d47]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::f99f:b4d:65e6:7d47%6]) with mapi id 15.20.6588.031; Thu, 20 Jul 2023
 01:55:10 +0000
Message-ID: <3d150139-55ad-ff33-d6fd-4c2123ebd37b@intel.com>
Date:   Thu, 20 Jul 2023 09:55:00 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v3 00/21] Enable CET Virtualization
To:     Sean Christopherson <seanjc@google.com>
CC:     <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <peterz@infradead.org>,
        <rppt@kernel.org>, <binbin.wu@linux.intel.com>,
        <rick.p.edgecombe@intel.com>, <john.allen@amd.com>,
        Chao Gao <chao.gao@intel.com>
References: <20230511040857.6094-1-weijiang.yang@intel.com>
 <ZIufL7p/ZvxjXwK5@google.com>
 <147246fc-79a2-3bb5-f51f-93dfc1cffcc0@intel.com>
 <ZIyiWr4sR+MqwmAo@google.com>
 <c438b5b1-b34d-3e77-d374-37053f4c14fa@intel.com>
 <ZJYF7haMNRCbtLIh@google.com>
 <e44a9a1a-0826-dfa7-4bd9-a11e5790d162@intel.com>
 <ZLg8ezG/XrZH+KGD@google.com>
Content-Language: en-US
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <ZLg8ezG/XrZH+KGD@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR06CA0009.apcprd06.prod.outlook.com
 (2603:1096:4:186::17) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|SA1PR11MB5921:EE_
X-MS-Office365-Filtering-Correlation-Id: 096400b4-ec13-4faf-7311-08db88c459ad
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WjAg1SPQZuQ6cY4jyqSvgTIV6AWaWGBwJWcGPGbuGYqQs+ijM7IlTiTYmJ+XhUuahsyCu1Yq2jmkRB26iSj2EBGQ34fRBg/N8hSlCDcPJczSoNucT69rvoNn6fIwIbOKTr/CJk+o/V3sfWBpR9yCJBFaZBt3VNTcIF9gVRcbvVpi0jdpdlkujax+Z7pshr1LfgYaV7cApeutpuDe1MFptRpQj/A1Jq/x/iVY7WAwKEfImv+mAaehg1kwGKR/Ui9bdrTW90xjvSApstlMfB9IkJfbFxrElx75TQKoT0ZLvLr3e82/31FkNjbu2ZnZy/mHm54tNQ8SBehus/L36JH9382IuiakTovSz1CsU0D5HRmbjWhppgwUBuhYs1OTM1ambdRGx+9CXEciAb6ont2KmwB0aZSAqG8E9RaMglRBpfdTCwxaY+5Gyjc31nBTvWH3uni7cTL1O7Hzzs3WtPUVjOqjJ7xs67oaiqphvB4CL18hfkz70JfjL3hJnFaxmhgmIS+q2thbu6ljBjGhY2k+ezNKr8xLPAvYCKvKaNEsTBkyK1TMLy4nb0CPUeOLUd+2Fx6suHFnMuW63Rkde489StmdEYwVNhzfTQTvLyB+TFmWg7t7XVsSlqNP2ogdyhmBG/ZQPk4xgdwDWbQJoVPsSw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(376002)(39860400002)(346002)(136003)(366004)(451199021)(66556008)(6916009)(2616005)(66946007)(66476007)(4326008)(316002)(6512007)(6486002)(6666004)(6506007)(478600001)(53546011)(186003)(26005)(2906002)(31696002)(86362001)(8936002)(36756003)(41300700001)(8676002)(82960400001)(5660300002)(38100700002)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SVNNS2t3YmpNOGFJQ01OMms3RnlTcHByWUQ5eTE1eHYydmhMK28xalZqcUtY?=
 =?utf-8?B?c1JLQTdvWUFIaENXUGJZVUxiSHlZMS84ZjZhQTd3YnhNYWkyRS9oaDZHV1lN?=
 =?utf-8?B?MzN4ZnNRc2s0eW5zZW81NXRuMVpkc1ZQSHlnVU0yaTIwbDZkQTlvcGJsWXZr?=
 =?utf-8?B?T201TXR1VkVTcjZrQW1aZmc2ditxREkvdzM5OVNYbm1qV2VaWFRJSHlDNmNn?=
 =?utf-8?B?RjI2YlUvbHQvVVREYUZoaitPVGwxdzJ1ZFZMbDk3R2U5Rm4yVzlod2s5ajJ1?=
 =?utf-8?B?MngvOVlsL2ptVzdhenpnVVJqemtPeVFDN0dZb2NnZEVqcUNnVkVVaVJXa1N1?=
 =?utf-8?B?QXUvSWpwOUp4bEhOOTc1aUhydis0N3hQRkRrRjlRaDR4TmJIWFpUK3Q4UjRp?=
 =?utf-8?B?czg1d1FabDdEeUlFMkQ3SXhaeE5nZlp1MW1kcHZUUEcyRVZxbGFDYzB3TklJ?=
 =?utf-8?B?cWZjM3VIR3lyMFk0NjVEdHlDNDAvdGM1U1hOa1ErK1U4QUN0SEZwWm5OaWNQ?=
 =?utf-8?B?YSs4TDQrYnNQbW41Sk1DcUUyVldOMERONVM3YXk5c2JVblBCV0hrWUJIeitJ?=
 =?utf-8?B?aS9aS0ZEMkRwZ25PbkJZNmNybVpwTVhVbmIrMkNhMXVYY3k5L21rMjZmWVN2?=
 =?utf-8?B?ajVQYW8wYTkwamVFMlBtclQ4SmxRdERQNG1LRUVRYVRTVWRnUWFBdlgwdzZT?=
 =?utf-8?B?Rks5TEUzK3FMaTRXZVVQTnFQUGp1UGRRY21yelBTOExjaXloekVwME5Fc09y?=
 =?utf-8?B?RWV1OWNDUUp6M0JObkFTSjJIa0lMNUFzQStOclVuY2VDdXkzR2lUc0FuUmNH?=
 =?utf-8?B?VmhobytNblFQZXk5QXh0U25LejdKKzNwSUdmTUNPcXlmQ1dtWG1aZVA5cjNS?=
 =?utf-8?B?czFTK29WQk1uU0pCbjhBNmlUNFpFbE56UmtYYlpUdnczQTZ0QjF6WjcrV05x?=
 =?utf-8?B?b2dwK2IzQVh6UzJRZ2FQK3Y1eEJMWnJtUkRiRFQ4Ly9RNTJtVkFtUkNTUWZL?=
 =?utf-8?B?RGVjOHBFeWVFN0hnRnkrZWdpLzdyT0NLM0xIWnhDN21uOEl5MDJCS09xNmsx?=
 =?utf-8?B?NXd0Wkx5dStKbFVmalMvd0preERhQllIRlNicGE1QnZJTElLb2pSZS9TRHBk?=
 =?utf-8?B?YVNKakhwMmNJWGxnTGZWNlhpei9hY1hCL0R3ZzM5bHpNRFBlcG54VmJwRllI?=
 =?utf-8?B?aUcrRjFVc2s2UDFGMFltSVg4amdUcXZMNEQyYi8zOTdrM2QvUFZHOWhmNHM3?=
 =?utf-8?B?NjVnNXgwUEtlZXRoeVk4V3Y2SnIxUlFYZ010ZDZLd292ejJVVm9EcTJLc1V4?=
 =?utf-8?B?UVQrSXRDRG9zR0xTd3R0SUYzU1llbW1kSitGUDM0MUIrWWR6ZnhYazBMMFBR?=
 =?utf-8?B?azVmSloxc2dBYkRFYTBJOU5FeUxRMG1pRURjb1JNNDMyMW5VZ29WUHBjaHRn?=
 =?utf-8?B?VFNtYUs3alNqdUdLRjd5d2thOUlvSXBSZ3ZyK2xwK2pueTM5TFd4NzZIZmxk?=
 =?utf-8?B?Wlczcm9JSFVKamlmSnUzQlJzekJEVWxzZTlNSUNQYktLVnpST2FabEQ2TGJ4?=
 =?utf-8?B?NElsemNTbnZLeDF0OUhuZjByNXB4M3luaXRKZkZESlpUcGRtdzZXeFhVU3Js?=
 =?utf-8?B?bTVVcE8wZXJjNjFWU0FvTnBtUlR5QUxVSC9Xd09CajdCVnpJU0NYVEtGQlNL?=
 =?utf-8?B?RjQzUlZLV3NNNnJDOEI1dGlpNE5YMWVNVi9FUmFTVklGU1FtQUl4aVdWTlF4?=
 =?utf-8?B?bFBScjM2YVU5UXMxRUp4ckF3aVk1NHZvQnhjVlNuTlZGMENqZmhrZG9SQmpO?=
 =?utf-8?B?NWVXMzZIQ09Od2xLOWxQaXk1VE5id05IWk9Qb0JUcC9yRldSQUJXMVVkMkhB?=
 =?utf-8?B?RkNRQmRBalJQZ3BhME14ak9OYUJmdHhTeUdydUhHekRTNzRSeUR0TW1SUnFp?=
 =?utf-8?B?Uzk5Y2JYb0Q5VDFNalBwVU44TFBteE9lYTNvZ3dHNVh4ZUE0b1hua3YzcVhl?=
 =?utf-8?B?SUprT2t0U0ZoVHhqS3VlQUMvK0h5UWR3QnhldDRURURGS2NkUnBOYmNGaGZJ?=
 =?utf-8?B?VUlkSURXL29BZmk2cHA3b0MxRFNJeDlwdlROME9yREU3OXV6S3B2VUZiTEZO?=
 =?utf-8?B?MXJ0MW5wWlZoUGg0emJ5TjR6RlZvWEw5OUhhcWRTcE8vZXBuZ2hjU3l3VENT?=
 =?utf-8?B?clE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 096400b4-ec13-4faf-7311-08db88c459ad
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2023 01:55:10.5912
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3EGYf5lxBRHTRNJvrT/zCidCh/EtvGWxXqrHSkAOf1soOGRcoohbC8clpaQwSmLEW0pBOj9FYui8SrVwUGgtOQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB5921
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 7/20/2023 3:41 AM, Sean Christopherson wrote:
> [...]
> My understanding is that PL[0-2]_SSP are used only on transitions to the
> corresponding privilege level from a *different* privilege level.  That means
> KVM should be able to utilize the user_return_msr framework to load the host
> values.  Though if Linux ever supports SSS, I'm guessing the core kernel will
> have some sort of mechanism to defer loading MSR_IA32_PL0_SSP until an exit to
> userspace, e.g. to avoid having to write PL0_SSP, which will presumably be
> per-task, on every context switch.
>
> But note my original wording: **If that's necessary**

Thanks!

I think host SSS enabling won't happen in short-term, handling the guest 
supervisor

states in KVM side is doable.

>
> If nothing in the host ever consumes those MSRs, i.e. if SSS is NOT enabled in
> IA32_S_CET, then running host stuff with guest values should be ok.  KVM only
> needs to guarantee that it doesn't leak values between guests.  But that should
> Just Work, e.g. KVM should load the new vCPU's values if SHSTK is exposed to the
> guest, and intercept (to inject #GP) if SHSTK is not exposed to the guest.

Yes, these handling have been covered by the new version.

>
> And regardless of what the mechanism ends up managing SSP MSRs, it should only
> ever touch PL0_SSP, because Linux never runs anything at CPL1 or CPL2, i.e. will
> never consume PL{1,2}_SSP.
>
> Am I missing something?

I think, guest PL{0,1,2}_SSP can be handled as a bundle to make the 
handling easy(instead of handling each

separately) because guest can be non-Linux systems, as you said before 
they could even be used as scratch registers.

But for host side as it's Linux, I can omit reloading/resetting host 
PL{1,2}_SSP when vCPU thread is preempted.

I will post new version to community if above is minor divergence.

