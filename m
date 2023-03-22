Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75E126C530C
	for <lists+kvm@lfdr.de>; Wed, 22 Mar 2023 18:52:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230296AbjCVRwN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Mar 2023 13:52:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230182AbjCVRwI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Mar 2023 13:52:08 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4569B65455
        for <kvm@vger.kernel.org>; Wed, 22 Mar 2023 10:52:03 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id e8-20020a17090a118800b0023d35ae431eso6177196pja.8
        for <kvm@vger.kernel.org>; Wed, 22 Mar 2023 10:52:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679507523;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=iZTwETswiMkR6MsJjj+d7N8Pb7VPbOvVsKiiVr9TOhM=;
        b=i5+mifpqoOF/KxF3sUQl2/YU4M7kOnSQCVi7BGq43pujy0oUUBe8hPcWfsLGYLtG2m
         NSWswmC+HelxhvUeFVi96enYnxro0IrBcV1F8hUHYm6ihUptDyofwPVDeVmWnluPN4HP
         HRf5b33RDynRy5Y+O3asK9iHxQHDn7pOA9FXeGaGkmvyvvYPcU+Xo0AqeWHb75LvpXHh
         sEffnSPQ2LbrSDwhGGIpWGHUz6DtdDawZV5p6zKiRZT0zGS0Kv+JN6aMnb3fQ7nqDoyi
         T9Tu517oJGvpdQBkdLcni99k6uilxYjJokNEdA1jOwVCRoACOawG30Jl92aK1QIYTxQW
         +Arw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679507523;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iZTwETswiMkR6MsJjj+d7N8Pb7VPbOvVsKiiVr9TOhM=;
        b=YUZaX0XhBUKTwwH2tGoyDO6eEi6LKueCIQ9MIIhdWVcNkWN8a9+GxM/C+SyhORzWqp
         bye9jDfd82ohEWDIxQIpay1Qm8FvBSLMgtD7T0W4Q4SMNgqaHcWd7bvQaJBUqPAH1Hjw
         YLzJk4WPY4DSpdwCFsRYf3Pc7Ohc7lC+WXWSoBGWY3mcVo9FFsfRh+hH0eF+3FCD/MfH
         e4JpQxTLxCPnlzXV+W69Y8Eu7mQ4lNgtWxq1ROwUVidr5YEgTenhAR16V2l8wR96c1C0
         ftSE4qwZ3LoMaV+nu1Q6OJavxSqesRjjF59JhjXuSuz7T4sopwsp5ahiucN1BKuucbag
         OPug==
X-Gm-Message-State: AO0yUKUm3kS/+ycCZdQRp/ovdWPkYUFwsysREDgpLggM1N+5Lh7l/1Tt
        l9OR6oFBaRI7BnP+yeVH+fAIw2hA7pc=
X-Google-Smtp-Source: AK7set+RGHNA/eCwuNR2wbBn238UqLumF+xL7hx3F6oNRxE1rmepDqciOMOmxEg+y7rjgstoo1w3iS7S8xg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:22c1:b0:1a0:6b23:7b55 with SMTP id
 y1-20020a17090322c100b001a06b237b55mr1415684plg.4.1679507522821; Wed, 22 Mar
 2023 10:52:02 -0700 (PDT)
Date:   Wed, 22 Mar 2023 10:52:01 -0700
In-Reply-To: <20230307023946.14516-6-xin3.li@intel.com>
Mime-Version: 1.0
References: <20230307023946.14516-1-xin3.li@intel.com> <20230307023946.14516-6-xin3.li@intel.com>
Message-ID: <ZBtAQc8Jz5GWGrJr@google.com>
Subject: Re: [PATCH v5 05/34] x86/traps: export external_interrupt() for VMX
 IRQ reinjection
From:   Sean Christopherson <seanjc@google.com>
To:     Xin Li <xin3.li@intel.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, peterz@infradead.org,
        andrew.cooper3@citrix.com, pbonzini@redhat.com,
        ravi.v.shankar@intel.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 06, 2023, Xin Li wrote:
> To eliminate dispatching IRQ through the IDT, export external_interrupt()
> for VMX IRQ reinjection.
> 
> Tested-by: Shan Kang <shan.kang@intel.com>
> Signed-off-by: Xin Li <xin3.li@intel.com>
> ---
>  arch/x86/include/asm/traps.h |  2 ++
>  arch/x86/kernel/traps.c      | 14 ++++++++++++++
>  2 files changed, 16 insertions(+)
> 
> diff --git a/arch/x86/include/asm/traps.h b/arch/x86/include/asm/traps.h
> index 46f5e4e2a346..da4c21ed68b4 100644
> --- a/arch/x86/include/asm/traps.h
> +++ b/arch/x86/include/asm/traps.h
> @@ -56,4 +56,6 @@ void __noreturn handle_stack_overflow(struct pt_regs *regs,
>  	void f (struct pt_regs *regs)
>  typedef DECLARE_SYSTEM_INTERRUPT_HANDLER((*system_interrupt_handler));
>  
> +int external_interrupt(struct pt_regs *regs, unsigned int vector);
> +
>  #endif /* _ASM_X86_TRAPS_H */
> diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
> index 31ad645be2fb..cebba1f49e19 100644
> --- a/arch/x86/kernel/traps.c
> +++ b/arch/x86/kernel/traps.c
> @@ -1540,6 +1540,20 @@ int external_interrupt(struct pt_regs *regs, unsigned int vector)
>  	return 0;
>  }
>  
> +#if IS_ENABLED(CONFIG_KVM_INTEL)
> +/*
> + * KVM VMX reinjects IRQ on its current stack, it's a sync call
> + * thus the values in the pt_regs structure are not used in
> + * executing IRQ handlers, except cs.RPL and flags.IF, which
> + * are both always 0 in the VMX IRQ reinjection context.
> + *
> + * However, the pt_regs structure is sometimes used in stack
> + * dump, e.g., show_regs(). So let the caller, i.e., KVM VMX
> + * decide how to initialize the input pt_regs structure.
> + */
> +EXPORT_SYMBOL_GPL(external_interrupt);
> +#endif

If the x86 maintainers don't object, I would prefer this to be squashed with the
actual KVM usage, that way discussions on exactly what the exported API should be
can be contained in a single thread.
