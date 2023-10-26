Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE4C17D868A
	for <lists+kvm@lfdr.de>; Thu, 26 Oct 2023 18:14:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231423AbjJZQOb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Oct 2023 12:14:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230330AbjJZQO3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Oct 2023 12:14:29 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2063.outbound.protection.outlook.com [40.107.6.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 064351A2;
        Thu, 26 Oct 2023 09:14:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AAePAkStC6KZbMfsTdIM95DnDnfl/n2MxH/Hkc0AYeNsC80qgnDwrt/j1FQy+F5C801DdBVr4hr1jmJ0UMQ97UcnEiNAVryemj5aMvOY/+L4f/58+5Eib3ov8wpX8bWBG8BrCYmOjZlkT0PvS4gin5Rla5i13boujqKsaVxcu5lM3N89tFgWVA4zaH8SZiYWlMFhfroUWHUREnMSIdgJQQK4/rIxCJKlHCfmYhdX0WYXI6oEyIZz4+lH184qtV3DATyQN1uMXQ5l88ATLnyuhs8Ca//N586j3ojLM63ykDRd9ngu4ovqbhla/iQ3zkxHv4+ASTybjy5jSh+Kw+Zyng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AOJUwHpgd1T4BXb53faM5x2RDjc6OG6FAd9jiqS9Vjo=;
 b=GQt9xr6RXzzBlciyLM69HID0H80iee66fGHsD5/N9THUHXW3tcN9nW8zrzJAnu0n5inhrS4XGhzc38/fQHOyhMeZkxPyRYvjQnZ5ftXhwW5OsK5Ln8tORPNwojNxJxyCkHsBglLpCnIS4TKJO9GCiDHS+mz0P4Cc8Ryiz0WQ70SzRhIo4V4PG6sMObRz1sPueJjUNDmW91mhOuL7FgAjVorYN888YTmDwTOXBaPmnsUk4E35HdhdTT6g3zGYYhg0I+LXhPWsSAgamn8rqwMl16tl27dSESEWcFE7+FuL043DEFbaMOgFOBLGd6eAoZmEkgTxA8pHE6RsLnArwz1JHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AOJUwHpgd1T4BXb53faM5x2RDjc6OG6FAd9jiqS9Vjo=;
 b=MqDIUzZTwivNLPti5PTwfNUxMZ5VbabGLKZvxXW7SF3RS5KXbMfk3Y07w3JayNkBcSlnKcLLKG2/E39mZXTHZNpLdJAPmBkNUbwx+NkM5+hVaU0TYUCeg3l7YzFSH+Lp6q0BRu7cyvGoyWNPPITwyfjLp7qlCnZFLTqsjVlZCUAP7FTsD0Y3TZn8bD41J+DwaOLKzJZGvq/ZTtjwiYdaWIgrRlImxXV71eU3Tkg4pnfcd3QA93O/RwNej3EgmCChy+xeUW9JAuaP5Oc0l3/9IPPl0lATq4YBJngCpTVjqBCTwokXuHKsA8P4UOMgkJDSVicOnXGALw8VIaWnttmQPw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from PA4PR04MB7790.eurprd04.prod.outlook.com (2603:10a6:102:cc::8)
 by AS1PR04MB9454.eurprd04.prod.outlook.com (2603:10a6:20b:4d9::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6933.14; Thu, 26 Oct
 2023 16:14:23 +0000
Received: from PA4PR04MB7790.eurprd04.prod.outlook.com
 ([fe80::6bbb:37c3:40c4:9780]) by PA4PR04MB7790.eurprd04.prod.outlook.com
 ([fe80::6bbb:37c3:40c4:9780%4]) with mapi id 15.20.6933.019; Thu, 26 Oct 2023
 16:14:23 +0000
Message-ID: <cb8d8ae8-edf6-42a2-8cdc-3bd7b7e0711e@suse.com>
Date:   Thu, 26 Oct 2023 19:14:18 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 6/6] KVM: VMX: Move VERW closer to VMentry for MDS
 mitigation
Content-Language: en-US
To:     Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, tony.luck@intel.com,
        ak@linux.intel.com, tim.c.chen@linux.intel.com
Cc:     linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        kvm@vger.kernel.org,
        Alyssa Milburn <alyssa.milburn@linux.intel.com>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        antonio.gomez.iglesias@linux.intel.com
References: <20231025-delay-verw-v3-0-52663677ee35@linux.intel.com>
 <20231025-delay-verw-v3-6-52663677ee35@linux.intel.com>
From:   Nikolay Borisov <nik.borisov@suse.com>
In-Reply-To: <20231025-delay-verw-v3-6-52663677ee35@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: VI1PR09CA0135.eurprd09.prod.outlook.com
 (2603:10a6:803:12c::19) To PA4PR04MB7790.eurprd04.prod.outlook.com
 (2603:10a6:102:cc::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PA4PR04MB7790:EE_|AS1PR04MB9454:EE_
X-MS-Office365-Filtering-Correlation-Id: 9a7bd5a2-3450-4ece-bfc7-08dbd63e9ddb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0yy+Fz+8IqU3aGWiesRN1TC0hYCVYqO8/cGlEJRtlBvH/fzo/5XlmwMrcFa9zBJYw3LLcXI15sWN6UnXzjDClRvRPwOktiaMDsgNw2vChIFwuLOj50VZN7pQhSsmQVPF8uS+vXJJ4myAiCYVc/jLPHzhGHmuTvRCahvaL1oVwB6T2HjHMtDk0WIVl4bTGMe/jcXmgsu6+g8Q6q1RSLPdqo+KsW9CEtujlifYSzS/Qhxt7dKvCWaE7aJeqQXuWgAZgm2/qOiblIHMOLUEzXroxiJmF6SpV/kuQ3ftiuxgUfC9uS+vYmpAnt1Lt/LqN6gj8CJYe4k/BVStPJELBOq14Ns4P+cFO5FkOMyfMNEDecDluA1TR5Q/40Z1qQSzm/DaTJ3vGW8RtmbG1DlJXF/JZC/Qs7r/DrfL2zS3rGJniddjw8UrUTo8uh3XhBVQZiQR+CXrkfCye7FQQj0wYIF6E1gCzvxDAnrwU4utUpUm+KGpQqA33ETb6EucP/03MgDojD0zRHe+Lwwh46pODhph1Ne43mle0ikaLWTRs7UTggk/DGWF05Uy4ITzDAbm/CsI+n3TkcS4CufsbwBgXKnnQ7vA+MZdAQalQRuz8aiAH6kM3Of1k/REKXhc+G0cjR8x2qE6LO4AFTrlimSpSe7qe6UZz2cpsfCRYdOmsZe8Hss=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PA4PR04MB7790.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(366004)(346002)(39860400002)(396003)(376002)(230922051799003)(186009)(64100799003)(451199024)(1800799009)(7416002)(8936002)(8676002)(921008)(4326008)(41300700001)(2906002)(5660300002)(2616005)(110136005)(6666004)(6512007)(6506007)(36756003)(38100700002)(66946007)(83380400001)(86362001)(316002)(31686004)(31696002)(66556008)(6486002)(66476007)(478600001)(54906003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dHRYVEM2UHpCVDByKytQaHhYNWxGUG1JUzI4bnpZT0NuemdGWGVsQzFTVXV4?=
 =?utf-8?B?dFBPeHhRSFhranVQNmE1OGtOK05KOTdPU2F1MXE5UGlWM2YzeTh4WXFNNVdF?=
 =?utf-8?B?cHVMbGVORjFON0NGbnhkZi8yWEFXUm1HZEdrNnZSejdmSkMxV09zL29qMHBR?=
 =?utf-8?B?MnM4OW0rQ3pLSHI3SFFFTi9BbUttTDJTeEI4TFpUUFhUNGUvQ09Sci8vZXd1?=
 =?utf-8?B?bkxNcUl6cVdtQ09XNDlJcDhzR2hWcFFmMmJubHdNWmpTR0lkZE9OMWVRNkNW?=
 =?utf-8?B?RkpIeSt6RnRUOUk1eE5mU3lwanJlRE9NYXFiSmx6YktRVHZ6ZTQ4bXgva01J?=
 =?utf-8?B?NXhOQTZweHAwd2tPd3hTMFNZT2VGTm54ZVJEbWI2K3kyRjZQQkR4QmpVcGs1?=
 =?utf-8?B?bmpGT21nQjVDc1ZJWkF3K215ZWhHRGt4c1JGbnhWbkFkSEluVHc3VEQ3a09v?=
 =?utf-8?B?MEZ0a3JkWGY2SUNENnVlS0ZmakQrd3NLekJsbE15K25naGQ3VFNROU9MbkZG?=
 =?utf-8?B?UE11N3NYOXVqcGw0UVhQWVkrS09mL1BTSG1EYnpyZkxYdE1ISDRYOHlYeUl3?=
 =?utf-8?B?eDFSdGhkOWl6M0pkYnBNOUxFWjlqckR5OXQ0eE0rb2I0bTRKRnVtc0UyUmJU?=
 =?utf-8?B?MHNrRUR3eCtoTld4SzlzN2JHVGM3eDg0QSsrVHExWXk5dHZKRDNCQkF2Qm5y?=
 =?utf-8?B?Y1BmUk9MZ1NBRUxEZDVudEhEdERaSzBVSEJTYU81QVVLYkdEN2s3Y2lBdFNo?=
 =?utf-8?B?a3V6enBNOFpMZUtDYm5HUFZNb3IxWEttQW9JVnFJckFUTFRLTGs3Z0tHWGQ4?=
 =?utf-8?B?VHpFY2xaLy93Zm1GRWRXRGl3akR4YmRzQnhjNkxBbElPTGZHb3haVnJETWE0?=
 =?utf-8?B?d1NhSFFodFV4cUF3UXFkZGxhUnVDaFNsTFpOKzIvenZMTTdjRHpzRy9KdGg2?=
 =?utf-8?B?dEhOUTBzWE9mVnEzeUJRK1RiSFozT2R5Y1h0WDB6UEdUVG5mRmVpSnh4T3Rh?=
 =?utf-8?B?T2dmUjBoS2JZbVF1MngxbDFCZGhHTng5T1VYSzN6OXVCWFpmSElEUkw5WXhv?=
 =?utf-8?B?Q2hTTXRXKzF2MDNXOU1aYkV2ZzJWemc1dXN1cnhZMWFXSmVKd0t3ei9BWEVQ?=
 =?utf-8?B?RWVkWmJkeFZXQmdRLzBDdzFLcVZSV0cvNENiTFZ2MUFjZnFHMlJYYy8rSEdl?=
 =?utf-8?B?MzQ4ZXZ4aHRJT0NDbEtVL2JhQmNVT0NkSFMwMFVJN2FYL2lEMVpxY3cvTVdu?=
 =?utf-8?B?dGVuT2swcHI2Nm9wNDUwc2kyMHVQZmdHU1VtYWN2YVJWTW02Ri9VMW5BSUJF?=
 =?utf-8?B?SUZycytsdUxlNytDOUJZNVByTERYVGpqK2N2dGJ6UU9wdVRLV0lzZmxZcVBN?=
 =?utf-8?B?MTdRdUFOY2NZS3JLSHJCQ3NkSjc5RThPNDNkQ01TUk5PaU9rMWl2UXBpVkNF?=
 =?utf-8?B?ckFqdEkvZjVsUERVV0l4VHg4K1FHVUZTTC9uQ2xjOHdQYzhnSmEvSEg4TW1j?=
 =?utf-8?B?UVQ2MytmQ1NFSDJzMGhjN2g5ZnI4ZlhTSERsYk1CMEQ4VU0wbGZlZFgwR2xG?=
 =?utf-8?B?aFlkWkJvUUhqZUZZNEQrc1UwMHRTNUl0dXJSc1pubHdXZWlhM2p2ZU1UR1Jl?=
 =?utf-8?B?RnplcStkU3RSaWptc0F1bjFvRHE0cFlKSEFYd1FpeEl1MERmdTFLSmhaNmha?=
 =?utf-8?B?bXpuR0k1NHU0MExWcm5OVGF5K1U4WTFIZDdaVGFqRFdhWElHK3FhS2NVaEJl?=
 =?utf-8?B?MWZ6emY0OUw2YkJyRTFIblhaVEkxK3hzVGE0ZmJPTkxiWkJtMjZxSTV2TkNO?=
 =?utf-8?B?QUtQNy90eFBLaHI3OUNHUmZvUUNHZ3FuMXhaT0REc3NUaDNXUU43Q1ZGZUc4?=
 =?utf-8?B?MkFYc3IyYWxaaHo3TmpNbUVYZXZkMlQycEt0aTJtRDFLWEFQVm85MThnMGt6?=
 =?utf-8?B?Zk9yZWVqL1VUM0wwU21hSXNFaXgvWjRxOHFuMFhhQ0hJS2J2T0ozY3RGY2Uz?=
 =?utf-8?B?b3htN0YwN0FCdTRJQ3FXWDZBL1VjTkFwZUV2MkFrbnpTT3BFWWYrRFE3TGZY?=
 =?utf-8?B?NEV0RUFTYWl2YVdtRERyc21JelBaQVIvV2JiWG9tWmpxeVBvRksxa2U0eDAy?=
 =?utf-8?B?emtOaTlNbGFjc1I0TWxwcmVtbmFaMnljTnhuVzcvN1hvdWkvSlFqM2tWOGxV?=
 =?utf-8?Q?+eBb9ShczB5os0XUkyc3cdWzGfxVSiq2PdyzAQ74BxX+?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a7bd5a2-3450-4ece-bfc7-08dbd63e9ddb
X-MS-Exchange-CrossTenant-AuthSource: PA4PR04MB7790.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2023 16:14:23.0808
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XgoZYJ84aNf4TbS1uNhGX+bLq/KsY2XzTkxRYfoZs+nCVM7908XNL/e9aLkASLHIp6XVOyTliMGEUCJ904A0jg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS1PR04MB9454
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 25.10.23 г. 23:53 ч., Pawan Gupta wrote:
> During VMentry VERW is executed to mitigate MDS. After VERW, any memory
> access like register push onto stack may put host data in MDS affected
> CPU buffers. A guest can then use MDS to sample host data.
> 
> Although likelihood of secrets surviving in registers at current VERW
> callsite is less, but it can't be ruled out. Harden the MDS mitigation
> by moving the VERW mitigation late in VMentry path.
> 
> Note that VERW for MMIO Stale Data mitigation is unchanged because of
> the complexity of per-guest conditional VERW which is not easy to handle
> that late in asm with no GPRs available. If the CPU is also affected by
> MDS, VERW is unconditionally executed late in asm regardless of guest
> having MMIO access.
> 
> Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
> ---
>   arch/x86/kvm/vmx/vmenter.S |  3 +++
>   arch/x86/kvm/vmx/vmx.c     | 10 +++++++---
>   2 files changed, 10 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmenter.S b/arch/x86/kvm/vmx/vmenter.S
> index b3b13ec04bac..139960deb736 100644
> --- a/arch/x86/kvm/vmx/vmenter.S
> +++ b/arch/x86/kvm/vmx/vmenter.S
> @@ -161,6 +161,9 @@ SYM_FUNC_START(__vmx_vcpu_run)
>   	/* Load guest RAX.  This kills the @regs pointer! */
>   	mov VCPU_RAX(%_ASM_AX), %_ASM_AX
>   
> +	/* Clobbers EFLAGS.ZF */
> +	CLEAR_CPU_BUFFERS
> +
>   	/* Check EFLAGS.CF from the VMX_RUN_VMRESUME bit test above. */
>   	jnc .Lvmlaunch
>   
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 24e8694b83fc..2d149589cf5b 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7226,13 +7226,17 @@ static noinstr void vmx_vcpu_enter_exit(struct kvm_vcpu *vcpu,
>   
>   	guest_state_enter_irqoff();
>   
> -	/* L1D Flush includes CPU buffer clear to mitigate MDS */
> +	/*
> +	 * L1D Flush includes CPU buffer clear to mitigate MDS, but VERW
> +	 * mitigation for MDS is done late in VMentry and is still
> +	 * executed inspite of L1D Flush. This is because an extra VERW
> +	 * should not matter much after the big hammer L1D Flush.
> +	 */
>   	if (static_branch_unlikely(&vmx_l1d_should_flush))
>   		vmx_l1d_flush(vcpu);
> -	else if (cpu_feature_enabled(X86_FEATURE_CLEAR_CPU_BUF))
> -		mds_clear_cpu_buffers();
>   	else if (static_branch_unlikely(&mmio_stale_data_clear) &&
>   		 kvm_arch_has_assigned_device(vcpu->kvm))
> +		/* MMIO mitigation is mutually exclusive with MDS mitigation later in asm */

Mutually exclusive implies that you have one or the other but not both, 
whilst I think the right formulation here is redundant? Because if mmio 
is enabled  mds_clear_cpu_buffers() will clear the buffers here  and 
later they'll be cleared again, no ? Alternatively you might augment 
this check to only execute iff X86_FEATURE_CLEAR_CPU_BUF is not set?

>   		mds_clear_cpu_buffers();
>   
>   	vmx_disable_fb_clear(vmx);
> 
