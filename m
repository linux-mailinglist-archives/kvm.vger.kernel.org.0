Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74D386A60D1
	for <lists+kvm@lfdr.de>; Tue, 28 Feb 2023 22:01:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229840AbjB1VBK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Feb 2023 16:01:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbjB1VBJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Feb 2023 16:01:09 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C660222DF9;
        Tue, 28 Feb 2023 13:01:07 -0800 (PST)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1677618066;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GINJMaOMVEa/0BnuxANTZw7J7gtIv9G1Tgm4tmy0fMw=;
        b=O9FP/U9j8lOfeghAXC6OGfzlTjTqhhA31djN2F3dagJgUjo1sAy5rMsVCB2/KBAL5ZmHlv
        3Wo76mL4NQ/tDJ1VlAL+wx94dPs+PKgquKwN92HHzwnD+MQrv1sL5SoQAkSAL9RBBid+w8
        OT+ipl9+y+4nKczYF8FW793okKIa9q4rUWGKi3bZcZesIoQxTdzHy35Xtma+1hvy/Xsths
        lX40xBf7GtzG2ZFQvyjNxgEu1ktk0ZhEQmSpIS0ADs9JYVdlawAuJhDswAiWM3tDeYUHSN
        Sa1wuIQ++1hOjCeVJcoRAoTisy1YS5DkNYGULs3AQgcsRtgDrxA//qRlYPvO4Q==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1677618066;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GINJMaOMVEa/0BnuxANTZw7J7gtIv9G1Tgm4tmy0fMw=;
        b=uyzf/xGHa60na5Ixygi1+bQO5hb7cPMMdMRnyBrUT9ZHZiOJixsbxP5ZulAP9bJs74d+dQ
        vPEzDuIIch2fgfAw==
To:     Usama Arif <usama.arif@bytedance.com>, dwmw2@infradead.org,
        kim.phillips@amd.com, brgerst@gmail.com
Cc:     piotrgorski@cachyos.org, oleksandr@natalenko.name,
        arjan@linux.intel.com, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, x86@kernel.org,
        pbonzini@redhat.com, paulmck@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        rcu@vger.kernel.org, mimoja@mimoja.de, hewenliang4@huawei.com,
        thomas.lendacky@amd.com, seanjc@google.com, pmenzel@molgen.mpg.de,
        fam.zheng@bytedance.com, punit.agrawal@bytedance.com,
        simon.evans@bytedance.com, liangma@liangbit.com,
        David Woodhouse <dwmw@amazon.co.uk>,
        Usama Arif <usama.arif@bytedance.com>
Subject: Re: [PATCH v12 07/11] x86/smpboot: Remove early_gdt_descr on 64-bit
In-Reply-To: <20230226110802.103134-8-usama.arif@bytedance.com>
References: <20230226110802.103134-1-usama.arif@bytedance.com>
 <20230226110802.103134-8-usama.arif@bytedance.com>
Date:   Tue, 28 Feb 2023 22:01:05 +0100
Message-ID: <878rghmrn2.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Feb 26 2023 at 11:07, Usama Arif wrote:
> @@ -265,7 +265,12 @@ SYM_INNER_LABEL(secondary_startup_64_no_verify, SYM_L_GLOBAL)
>  	 * addresses where we're currently running on. We have to do that here
>  	 * because in 32bit we couldn't load a 64bit linear address.
>  	 */
> -	lgdt	early_gdt_descr(%rip)
> +	subq	$16, %rsp
> +	movw	$(GDT_SIZE-1), (%rsp)
> +	leaq	gdt_page(%rdx), %rax

Even on !SMP gdt_page is in the 0...__per_cpu_end range. Which means
that on !SMP this results in:

      leaq    0xb000(%rdx),%rax

and RDX is 0. That's not really a valid GDT pointer, right?

> +	movq	%rax, 2(%rsp)
> +	lgdt	(%rsp)

and obviously that's equally broken for the task stack part:

>	movq	pcpu_hot + X86_current_task(%rdx), %rax

This needs:

--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -239,7 +239,7 @@ SYM_INNER_LABEL(secondary_startup_64_no_
 	/* Get the per cpu offset for the given CPU# which is in ECX */
 	movq	__per_cpu_offset(,%rcx,8), %rdx
 #else
-	xorl	%edx, %edx
+	leaq	INIT_PER_CPU_VAR(fixed_percpu_data)(%rip), %rdx
 #endif /* CONFIG_SMP */
 
 	/*

in the initial_stack patch, which then allows to remove this hunk in the
initial_gs patch:

@@ -286,9 +286,6 @@ SYM_INNER_LABEL(secondary_startup_64_no_
 	 * the per cpu areas are set up.
 	 */
 	movl	$MSR_GS_BASE,%ecx
-#ifndef CONFIG_SMP
-	leaq	INIT_PER_CPU_VAR(fixed_percpu_data)(%rip), %rdx
-#endif
 	movl	%edx, %eax
 	shrq	$32, %rdx
 	wrmsr

Maybe we should enforce CONFIG_SMP=y first :)

Thanks,

        tglx
