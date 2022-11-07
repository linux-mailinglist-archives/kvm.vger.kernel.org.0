Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9DCA620261
	for <lists+kvm@lfdr.de>; Mon,  7 Nov 2022 23:39:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232290AbiKGWjP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Nov 2022 17:39:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231883AbiKGWjN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Nov 2022 17:39:13 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2054.outbound.protection.outlook.com [40.107.237.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2C54205D3;
        Mon,  7 Nov 2022 14:39:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wu4zIoBCAwIIuj4TYDafxRQjkNFNV5s5P62e+NClOERobPlNEyg+kAPH8Sn0T+Ix7pRql/vu46N/EaHMI31Enkadj1b6dJ6d8RsEMOTY+WPrtcsmZMfulxYOw8g8dzbYYyshgV3JQE5OekLMFI/LfM+OFWnChnclr1+j4gsNEw66PXaj9LEEMTy4MX0xNSp/RUUm9fZPMOpLO4PnTT9nIZrLaLKSWALI0gxgwhitHI2Kps9547CMQgHI5kABwbutJB9ua7oMyIGH6jKVmZ8SVVVb61kHJW7AMlBwA4nIzRSZB/mDkDbTicSa6X/LbcQsZjqYUWShvJsuxrdKJpQPJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ff4kri761zhyB9UmgJ+kZOLnMozkJU3rP0RRRjPP9MY=;
 b=C1lLNWA2pnyvmIjCUFL/0GuMiZR8ADxke3IEkU+V7LpT5+7p1VO9iuEcCHtlRVeU/dfYanVIIvrVZO6GBCejnhwxcc/Ha1/EtUz/ZxJEA6LYB3+6qXp98IYMnDXgxURVmlwe8b7K+DkkFhppDYI8V2Ch/aUYOTHx3nrOGFwJzWPAiqdHbKFxA0KMXEgYwYa31CSoLXkM41qc65Y+599p5MbUSnviG+/LSLc7LdNmfcZ1vFM92YB2zGZfDp6A8Jk92eeOdAD9wnvPPZ0FGOxo18A6zg9+pQP0yxW5sCHNpsJfpF7OUMd7x39kzp50Ru7m+O9FgAHeWI3uMz1ZXgTPYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ff4kri761zhyB9UmgJ+kZOLnMozkJU3rP0RRRjPP9MY=;
 b=rB4A5yd6t/XZyXm/qqh3afeQb+fsvD3XZ+1L2zCQFIyIgcsDWFtD29RN5ou9aGXMLhSBr86Xfh2l1SXG7I1QYl7wlFZ+xJJ5SEV6Es07um3EvaI1mOsVwUWcAmGgyZBdwV0gOqu74Zb7smObYcKZ8ZvHMNSZ+TfsR5UwEKy64gs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6263.namprd12.prod.outlook.com (2603:10b6:8:95::17) by
 CH0PR12MB5347.namprd12.prod.outlook.com (2603:10b6:610:d6::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5791.25; Mon, 7 Nov 2022 22:39:05 +0000
Received: from DS7PR12MB6263.namprd12.prod.outlook.com
 ([fe80::6f5:7c8f:32d9:e72c]) by DS7PR12MB6263.namprd12.prod.outlook.com
 ([fe80::6f5:7c8f:32d9:e72c%3]) with mapi id 15.20.5791.026; Mon, 7 Nov 2022
 22:39:05 +0000
Message-ID: <d413c064-ee9b-5853-9cf1-544adde22c8a@amd.com>
Date:   Mon, 7 Nov 2022 16:39:02 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Content-Language: en-US
To:     Peter Zijlstra <peterz@infradead.org>,
        Borislav Petkov <bp@alien8.de>
Cc:     x86@kernel.org, Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Juergen Gross <jgross@suse.com>,
        Tony Luck <tony.luck@intel.com>,
        Babu Moger <Babu.Moger@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20221104213651.141057-1-kim.phillips@amd.com>
 <20221104213651.141057-3-kim.phillips@amd.com> <Y2WJjdY3wwQl9/q9@zn.tnic>
 <Y2ZEinL+wlIX+1Sn@hirez.programming.kicks-ass.net>
From:   Kim Phillips <kim.phillips@amd.com>
Subject: Re: [PATCH 2/3] x86/speculation: Support Automatic IBRS
In-Reply-To: <Y2ZEinL+wlIX+1Sn@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR03CA0349.namprd03.prod.outlook.com
 (2603:10b6:610:11a::33) To DS7PR12MB6263.namprd12.prod.outlook.com
 (2603:10b6:8:95::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6263:EE_|CH0PR12MB5347:EE_
X-MS-Office365-Filtering-Correlation-Id: 65b21f86-9b9e-46cd-5619-08dac110e040
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iwOp/0IBko65mikwcgAiJ7IjT+ZFUUVoK1XiH46d0kvHdMVTWr0s3P2zlMSAxB1m34fST6OE6XwjeXNdfzUzV0T942koRYFrzS4dgH/YgzcEIt9bIJxCzfKivMvKpG/577uHyKnHdrg0RyyUoRAXVjowEcPSiazznETJuqFhU/uX33x5pxVeU6FRpVdnd0UexRugMNrcJRqhC+SpQBtbIk6Bh/QYpvRLLPmIVhR2iKiUtYMz4GKWdOpRuWcCJU+ZytOENZVWWc3QcV8fCX2FaNHFj3A7bu6UxFYtx+JGYd9OXBXmTNrB/U2ZGvssKoYH37NLlDeUCW9vtUXqq8N521iTT7ICbiX6T8qfnPuNHr4u/M21+QTL2gDGCEp3P8WkNTat6bIEColAUAsqykYheER+9EPRzIunoLNijdtdyBK+r+nqWwRIBOdjRd7fD51y6snQ/OAscXD/5ZPBYixZ50s6OXk3qfgnM3vlGuewTnir/Eac5BMYb+7brRVmp/Lr+HnnLFB7Cj/hxIwDvq/ZOH0wbCHNk+wTm3xoH5VRp77lYGd6Eti8dSsU5sZA42T95VeufQYqZcd3stthldT8hHFSIAyj/YcOx8RFK0ZW4vckAUd096SG7XiENlAnNs76aKq89GrlcFhbYBNJHUGU99KkoQfkyh9Qb6jprMVNJVQaD7kV9RNZqsGMLjSZ891PSN8sTgSv3DBPzjokpapPnRx0xOvmjvNS2d6roT+sp4ioKhKhH83d7hEOEMgt04geZ5ACLgDoBbdgPksJo2SyALusRJo/YxqjWMCe25YJunA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6263.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(346002)(366004)(376002)(136003)(39860400002)(451199015)(7416002)(66556008)(8676002)(66946007)(4326008)(66476007)(110136005)(2906002)(83380400001)(8936002)(44832011)(6486002)(478600001)(316002)(5660300002)(36756003)(2616005)(6512007)(186003)(53546011)(31686004)(26005)(38100700002)(41300700001)(54906003)(31696002)(86362001)(6506007)(6666004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dWhoTjJGLytxRzlpMnFHV1lKODFFRFRNL3FFM09FcnFDaUtrT1dOcjVFMENx?=
 =?utf-8?B?ektCOGhpaUxDNFFRaEE0WDFZRUVXUWJhcWNEL0ExcGFOZjNvMDBqTFZYbDF3?=
 =?utf-8?B?N2hYaG5OVXFBQ2hmb2RrbE1RWG5ndHdXQnVsWWJYZzZZR1pxY2pkbE4rb0pD?=
 =?utf-8?B?eWFhdllPeHZ2Z2FqRm10WUt0L3hoY3hCNmlxTWZlNWdSTUIyRGVIOWtIZlY4?=
 =?utf-8?B?NkgyeTUwdjVueTd2VTdHcXBsVVZybE5JVXpJLzNON1NNekNyaDhBczhMOEdK?=
 =?utf-8?B?emp3c0ZOdklxVGFobk1Bb21xUEp3RzJZNHJ6alpMa0s3cStlQnRXNitIcUtO?=
 =?utf-8?B?UFNWUU56dUlWKzlwRFVHajVtcWs2eHVWTlpSeCtad2dBZjVRVFFQN3BVYTAy?=
 =?utf-8?B?SzlTeGlNNkZHdnFWU25FdXZPZGZCUzlEZllUUUd2S2RGTnFmK3J3WE42RFJC?=
 =?utf-8?B?ZmJ0K2tBWmV6dEs5c1JPdGpMLzV1WFdzOHd0dUFPc21SUWZBZldIRHozd0FC?=
 =?utf-8?B?bjJzVjY5VUJ2Q2o5cjF3YWJBTHM1S0xFVzZYVXVoSWd1VFNibmNCdVE4L0Ro?=
 =?utf-8?B?cTBHb2p1WDFoUElpdzBaOXpUSm1IemhnS1VEZkRVNFhjcXJJanM0REhxOFFR?=
 =?utf-8?B?NXZIQUNkWTBTRTlhbXlOM1c4SjluNVlxR3p0bFl1bVozNEVaUDhJV1FoTFl5?=
 =?utf-8?B?a3NtWDNWVWY4MitSWG1tTm5TUllQUVZyZERDMUFwNURldGJFTWRKUG9jMVBz?=
 =?utf-8?B?NWJiWlpJR2VLYUlCNTh5Vm9SSi9RNGl3TENtWDV0NERJVDhuZ0ROTnB6RmN5?=
 =?utf-8?B?YTRWQzB0R2c3NktETDVxeDJmMEo5MFlqUGc3MUNoRmFJMnpLamQvb0tiQ3ph?=
 =?utf-8?B?R3VpRWFGK1BWQnFpK045UVN6cDdqcytkT0NmM0FJT1Z4UFREcXN5QkVrT1d0?=
 =?utf-8?B?dmZqUWhmSCtGQXdaVEdDbjViT1pTV2J0d1YybjBYS3ZVRWtZS0RQRVl2YllP?=
 =?utf-8?B?VzRwZ0Rwa0t5ME1pZnNBaUlrNnNqKzdrakY0MzFIQ3QyZjBYajRZS2o3djhH?=
 =?utf-8?B?bEVFVkNkNWtYbXpIbStOeHBsTmk4aWlxbVhWRTFMUzQza3hmOW1MRWZVWU53?=
 =?utf-8?B?cnovdmt1ZGNQK1F2WXBHQ25NSGtrSmxPNVl6c0R5OHhlYWszc0IxTGxnVHpN?=
 =?utf-8?B?cDJ2bENTb1FJVm9CV0dyZEZpYldtUUJOK1hFSDcwbFRoOWxzRXFKOHdPS3hj?=
 =?utf-8?B?b3B3ZWZQYmkrei9hQ3FSdjVuclpSUlczTWZVU2E2MDhYVjlJZmJ2WVBxYURm?=
 =?utf-8?B?S0JXajBQNW50Ymd6SEZ1R1dWTDRkREhvb3FHdGJCZ2Z4bmVKTmFucFg1bHhE?=
 =?utf-8?B?WUdiOGZBckRRVzQ0aHRRR0dSclBBdk1vK0JrVWhjQTgvYWJvRURPM25rNStK?=
 =?utf-8?B?U3FmT3F3RVplaFA2L1pYM202ZEpYcDdNMmVaMXJyUkV2bEsxVk5QbFRGc1VH?=
 =?utf-8?B?anBlV3dBKzc1alZjVks4Q0trbG8vUmxwSkNnUTlCaDBTaWJxQThuU0lpNzZ4?=
 =?utf-8?B?eHFybEtuSjhGUG1RclpBUCtCUlQ5Ymt3bVo1MGxSbURlekQ1WjVBZ25ybGpM?=
 =?utf-8?B?M0o4SkhmSTJvQXNseWM1L2pydEtCZEVoOVVENjNQQzFtemFNZXEyeWpyc3cw?=
 =?utf-8?B?eFZQWXJQaHBKUk13WVBmdkFQTVZLUHQyQ04xNExqeFBwVVlobi9WaS9FMHI0?=
 =?utf-8?B?bXhwUGdjelY3MGZXVkZ1cHNvNS9zekhMTHpkN3V6QzI3eXl1RUtoYnVETW1y?=
 =?utf-8?B?OENobk1ZeXVTV1ErRmlxRFIvaVdkYlh6Qmhyd2VlOHFyZVRWRy9zdW91NUhx?=
 =?utf-8?B?c0hYZTZtYk9CTGx3NnliQTNQVmVHZ3phQVdTTjRRRW9pdlJrRmttUjE0K1JM?=
 =?utf-8?B?NENFZkVnUGErTGdocCs3VmRoUW0zZENhVnZpTW05Zm9EeHdENTlqTGdPRWJG?=
 =?utf-8?B?cGVQSGRpUzRFYkYydFZabUh1K3lNd1BaSk9RU0ZIZmg1clpMeW1wYjhQNVY2?=
 =?utf-8?B?MGs3dmdBMEgzTXlVWlBqNFRTbjRXdzlqUCtLK0c5dDJUK3p5LzFCOE11a1hR?=
 =?utf-8?Q?ZAF6a2X4LYkEFfogqJ6H810VN?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 65b21f86-9b9e-46cd-5619-08dac110e040
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6263.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2022 22:39:05.3403
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GPCy0yMVGGnUtgBJN0+SqvGcTDAgv1GHHKlxMFQmnp5/SXlQUFbvRj3IAQSnpGnEhp/Ab3/SGIDPouqh7wReSg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5347
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/5/22 6:10 AM, Peter Zijlstra wrote:
> On Fri, Nov 04, 2022 at 10:52:13PM +0100, Borislav Petkov wrote:
>> On Fri, Nov 04, 2022 at 04:36:50PM -0500, Kim Phillips wrote:
>>>   - Allow for spectre_v2=autoibrs in the kernel command line,
>>>     reverting to auto-selection if the feature isn't available.
>>
>> Why?
>>
>> What the whole logic here should do is enable autoibrs when detected
>> automatically, without the need for the user to even select it as it is
>> the superior mitigation.
> 
> Well; perhaps the whole autoibrs thing should be mapped to the existing
> eIBRS options. AFAICT this is the same thing under a new name, no need
> to invent yet more options. bugs.c is quite insane enough already.

I've started a version that has AUTOIBRS reuse SPECTRE_V2_EIBRS
spectre_v2_mitigation enum, but, so far, it's change to bugs.c
looks bigger: 58 lines changed vs. 34 (see below).

Let me know if you want me to send it as a part of a v2 submission
after I take care of the kvm CPUID review.

Thanks,

Kim

Autoibrs-as-eibrs diff:

diff --git a/arch/x86/include/asm/nospec-branch.h b/arch/x86/include/asm/nospec-branch.h
index 2e9dd8823244..3ab90f23e7f7 100644
--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -442,7 +442,6 @@ enum spectre_v2_mitigation {
  	SPECTRE_V2_EIBRS_RETPOLINE,
  	SPECTRE_V2_EIBRS_LFENCE,
  	SPECTRE_V2_IBRS,
-	SPECTRE_V2_AUTO_IBRS,
  };

  /* The indirect branch speculation control variants */
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 31e5af78baa0..ccfd8fb12095 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -1005,6 +1005,7 @@ static inline const char *spectre_v2_module_string(void) { return ""; }
  #endif

  #define SPECTRE_V2_LFENCE_MSG "WARNING: LFENCE mitigation is not recommended for this CPU, data leaks possible!\n"
+#define SPECTRE_V2_EIBRS_AMD_MSG "WARNING: AutoIBRS does not need additional RETPOLINE/LFENCE mitigations, not doing them\n"
  #define SPECTRE_V2_EIBRS_EBPF_MSG "WARNING: Unprivileged eBPF is enabled with eIBRS on, data leaks possible via Spectre v2 BHB attacks!\n"
  #define SPECTRE_V2_EIBRS_LFENCE_EBPF_SMT_MSG "WARNING: Unprivileged eBPF is enabled with eIBRS+LFENCE mitigation and SMT, data leaks possible via Spectre v2 BHB attacks!\n"
  #define SPECTRE_V2_IBRS_PERF_MSG "WARNING: IBRS mitigation selected on Enhanced IBRS CPU, this may cause unnecessary performance loss\n"
@@ -1125,7 +1126,7 @@ spectre_v2_parse_user_cmdline(void)
  	return SPECTRE_V2_USER_CMD_AUTO;
  }

-/* Checks for Intel IBRS versions */
+/* Checks for IBRS versions */
  static inline bool spectre_v2_in_ibrs_mode(enum spectre_v2_mitigation mode)
  {
  	return mode == SPECTRE_V2_IBRS ||
@@ -1201,7 +1202,8 @@ spectre_v2_user_select_mitigation(void)
  	 */
  	if (!boot_cpu_has(X86_FEATURE_STIBP) ||
  	    !smt_possible ||
-	    spectre_v2_in_ibrs_mode(spectre_v2_enabled))
+	    (spectre_v2_in_ibrs_mode(spectre_v2_enabled) &&
+	     !boot_cpu_has(X86_FEATURE_AUTOIBRS)))
  		return;

  	/*
@@ -1231,11 +1233,10 @@ static const char * const spectre_v2_strings[] = {
  	[SPECTRE_V2_NONE]			= "Vulnerable",
  	[SPECTRE_V2_RETPOLINE]			= "Mitigation: Retpolines",
  	[SPECTRE_V2_LFENCE]			= "Mitigation: LFENCE",
-	[SPECTRE_V2_EIBRS]			= "Mitigation: Enhanced IBRS",
+	[SPECTRE_V2_EIBRS]			= "Mitigation: Enhanced / Automatic IBRS",
  	[SPECTRE_V2_EIBRS_LFENCE]		= "Mitigation: Enhanced IBRS + LFENCE",
  	[SPECTRE_V2_EIBRS_RETPOLINE]		= "Mitigation: Enhanced IBRS + Retpolines",
  	[SPECTRE_V2_IBRS]			= "Mitigation: IBRS",
-	[SPECTRE_V2_AUTO_IBRS]			= "Mitigation: Automatic IBRS",
  };

  static const struct {
@@ -1250,9 +1251,9 @@ static const struct {
  	{ "retpoline,lfence",	SPECTRE_V2_CMD_RETPOLINE_LFENCE,  false },
  	{ "retpoline,generic",	SPECTRE_V2_CMD_RETPOLINE_GENERIC, false },
  	{ "eibrs",		SPECTRE_V2_CMD_EIBRS,		  false },
+	{ "autoibrs",		SPECTRE_V2_CMD_EIBRS,		  false },
  	{ "eibrs,lfence",	SPECTRE_V2_CMD_EIBRS_LFENCE,	  false },
  	{ "eibrs,retpoline",	SPECTRE_V2_CMD_EIBRS_RETPOLINE,	  false },
-	{ "autoibrs",		SPECTRE_V2_CMD_AUTOIBRS,	  false },
  	{ "auto",		SPECTRE_V2_CMD_AUTO,		  false },
  	{ "ibrs",		SPECTRE_V2_CMD_IBRS,              false },
  };
@@ -1303,15 +1304,17 @@ static enum spectre_v2_mitigation_cmd __init spectre_v2_parse_cmdline(void)
  	if ((cmd == SPECTRE_V2_CMD_EIBRS ||
  	     cmd == SPECTRE_V2_CMD_EIBRS_LFENCE ||
  	     cmd == SPECTRE_V2_CMD_EIBRS_RETPOLINE) &&
-	    !boot_cpu_has(X86_FEATURE_IBRS_ENHANCED)) {
-		pr_err("%s selected but CPU doesn't have eIBRS. Switching to AUTO select\n",
+	    (!boot_cpu_has(X86_FEATURE_IBRS_ENHANCED) ||
+	     !boot_cpu_has(X86_FEATURE_AUTOIBRS))) {
+		pr_err("%s selected but CPU doesn't have Enhanced or Automatic IBRS. Switching to AUTO select\n",
  		       mitigation_options[i].option);
  		return SPECTRE_V2_CMD_AUTO;
  	}

-	if (cmd == SPECTRE_V2_CMD_AUTOIBRS &&
-	    !boot_cpu_has(X86_FEATURE_AUTOIBRS)) {
-		pr_err("%s selected but CPU doesn't have AMD Automatic IBRS. Switching to AUTO select\n",
+	if ((cmd == SPECTRE_V2_CMD_EIBRS_LFENCE ||
+	     cmd == SPECTRE_V2_CMD_EIBRS_RETPOLINE) &&
+	    boot_cpu_has(X86_FEATURE_AUTOIBRS)) {
+		pr_err("%s selected but AMD Automatic IBRS doesn't need extra retpoline mitigations. Switching to AUTO select\n",
  		       mitigation_options[i].option);
  		return SPECTRE_V2_CMD_AUTO;
  	}
@@ -1403,7 +1406,6 @@ static void __init spectre_v2_determine_rsb_fill_type_at_vmexit(enum spectre_v2_
  	 */
  	switch (mode) {
  	case SPECTRE_V2_NONE:
-	case SPECTRE_V2_AUTO_IBRS:
  		return;

  	case SPECTRE_V2_EIBRS_LFENCE:
@@ -1447,12 +1449,8 @@ static void __init spectre_v2_select_mitigation(void)

  	case SPECTRE_V2_CMD_FORCE:
  	case SPECTRE_V2_CMD_AUTO:
-		if (boot_cpu_has(X86_FEATURE_AUTOIBRS)) {
-			mode = SPECTRE_V2_AUTO_IBRS;
-			break;
-		}
-
-		if (boot_cpu_has(X86_FEATURE_IBRS_ENHANCED)) {
+		if (boot_cpu_has(X86_FEATURE_IBRS_ENHANCED) ||
+		    boot_cpu_has(X86_FEATURE_AUTOIBRS)) {
  			mode = SPECTRE_V2_EIBRS;
  			break;
  		}
@@ -1488,19 +1486,24 @@ static void __init spectre_v2_select_mitigation(void)
  		break;

  	case SPECTRE_V2_CMD_EIBRS:
+	case SPECTRE_V2_CMD_AUTOIBRS:
  		mode = SPECTRE_V2_EIBRS;
  		break;

  	case SPECTRE_V2_CMD_EIBRS_LFENCE:
-		mode = SPECTRE_V2_EIBRS_LFENCE;
+		if (boot_cpu_has(X86_FEATURE_AUTOIBRS)) {
+			pr_err(SPECTRE_V2_EIBRS_AMD_MSG);
+			mode = SPECTRE_V2_EIBRS;
+		} else
+			mode = SPECTRE_V2_EIBRS_LFENCE;
  		break;

  	case SPECTRE_V2_CMD_EIBRS_RETPOLINE:
-		mode = SPECTRE_V2_EIBRS_RETPOLINE;
-		break;
-
-	case SPECTRE_V2_CMD_AUTOIBRS:
-		mode = SPECTRE_V2_AUTO_IBRS;
+		if (boot_cpu_has(X86_FEATURE_AUTOIBRS)) {
+			pr_err(SPECTRE_V2_EIBRS_AMD_MSG);
+			mode = SPECTRE_V2_EIBRS;
+		} else
+			mode = SPECTRE_V2_EIBRS_RETPOLINE;
  		break;
  	}

@@ -1508,8 +1511,13 @@ static void __init spectre_v2_select_mitigation(void)
  		pr_err(SPECTRE_V2_EIBRS_EBPF_MSG);

  	if (spectre_v2_in_ibrs_mode(mode)) {
-		x86_spec_ctrl_base |= SPEC_CTRL_IBRS;
-		write_spec_ctrl_current(x86_spec_ctrl_base, true);
+		if (boot_cpu_has(X86_FEATURE_AUTOIBRS)) {
+			rdmsrl(MSR_EFER, efer);
+			wrmsrl(MSR_EFER, efer | EFER_AUTOIBRS);
+		} else {
+			x86_spec_ctrl_base |= SPEC_CTRL_IBRS;
+			write_spec_ctrl_current(x86_spec_ctrl_base, true);
+		}
  	}

  	switch (mode) {
@@ -1517,11 +1525,6 @@ static void __init spectre_v2_select_mitigation(void)
  	case SPECTRE_V2_EIBRS:
  		break;

-	case SPECTRE_V2_AUTO_IBRS:
-		rdmsrl(MSR_EFER, efer);
-		wrmsrl(MSR_EFER, efer | EFER_AUTOIBRS);
-		break;
-
  	case SPECTRE_V2_IBRS:
  		setup_force_cpu_cap(X86_FEATURE_KERNEL_IBRS);
  		if (boot_cpu_has(X86_FEATURE_IBRS_ENHANCED))
@@ -1616,8 +1619,8 @@ static void __init spectre_v2_select_mitigation(void)
  			pr_info("Enabling Speculation Barrier for firmware calls\n");
  		}

-	} else if (boot_cpu_has(X86_FEATURE_IBRS) && !spectre_v2_in_ibrs_mode(mode) &&
-		   mode != SPECTRE_V2_AUTO_IBRS) {
+	} else if ((boot_cpu_has(X86_FEATURE_IBRS) && !spectre_v2_in_ibrs_mode(mode)) ||
+		   (boot_cpu_has(X86_FEATURE_AUTOIBRS) && !spectre_v2_in_ibrs_mode(mode))) {
  		setup_force_cpu_cap(X86_FEATURE_USE_IBRS_FW);
  		pr_info("Enabling Restricted Speculation for firmware calls\n");
  	}
@@ -2353,7 +2356,8 @@ static ssize_t mmio_stale_data_show_state(char *buf)

  static char *stibp_state(void)
  {
-	if (spectre_v2_in_ibrs_mode(spectre_v2_enabled))
+	if (spectre_v2_in_ibrs_mode(spectre_v2_enabled) &&
+	    !boot_cpu_has(X86_FEATURE_AUTOIBRS))
  		return "";

  	switch (spectre_v2_user_stibp) {
