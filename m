Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E7C54BBD69
	for <lists+kvm@lfdr.de>; Fri, 18 Feb 2022 17:24:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237711AbiBRQYP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Feb 2022 11:24:15 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:45032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231320AbiBRQYO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Feb 2022 11:24:14 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B8A15C85F
        for <kvm@vger.kernel.org>; Fri, 18 Feb 2022 08:23:58 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id 132so8302052pga.5
        for <kvm@vger.kernel.org>; Fri, 18 Feb 2022 08:23:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=yOF1n7tghKKIAbhQ9j+Q3jSmefs92rndMD1UKm3tdV4=;
        b=HudpNHEwpV1T8DC9ek4CCWrNPF+lHxBdB/NYDU6fuC1dHsFHNK5Wwm1gYEyKR2DTUV
         Y6xGW/CaRVHbAS+YH3TM3wKXfEa/orADgD5SkHZjQGKgE3RfC/nHWfS/vIVYaS+KmmCX
         +yJGswkQIH0w0VFrpB8lRAqkxjQ6aRgL5P/7LQqWQOh36L7tEzsc6+AOUYJmBfBtiI9v
         5wOua4yA0WngQNzG0B4lxQP8YqKPEnE4sdfNaFPbvCxXDy5vBWBamWAt4Hske/mn93n9
         2h+z2shm+kVy4F6QkVUUCjodx3p3UZrdQP1E1/a9rAyZuxmigtdZ5LAIyEKxEhsP5y1i
         UZ5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=yOF1n7tghKKIAbhQ9j+Q3jSmefs92rndMD1UKm3tdV4=;
        b=oqoB0kueOVaes208jcE9JGArGrHsy6Dca03TPp+RKxpGfzQi+I+uHOJDl7ePrl1WWy
         vCd4KiHGBBpeuxS3UD93dKbIV8A1fh3FgwgTRvptg2eTNO8QHzNrsN3jZkmIut9Ne8WN
         epeDZ7wQGEQUXvVDtvbzHrTQQwkryTLk67IM8FL63G9SfTyHI+V1WnI+XdSXafbJ33If
         HxyZhesTZLuWwV0szXGoI6g04Y3V+imvX0DmJqQkXbWb6GzsaKqOJ8W7NV4vDXdgyTgb
         /bC6v4bX71zM93tbqbNEr9SQnx6xiwEKRzCIFQVPaSmPYdk2g0unAiDws8j3hAwDVooE
         ijpw==
X-Gm-Message-State: AOAM531uYnWI2btromYC/tay3heHAIf6YXvMGFMaTHW6p7IoTYwNul1d
        AKXBmn6NtAT1j20sbyejtvJIcQ==
X-Google-Smtp-Source: ABdhPJzVnGVBGRXc9lULlH6X/u7mIhDrQGo9oIZHMJe+2Q7U2uEh47vc0cnImf7Se8j5jb/m7OPcLQ==
X-Received: by 2002:a63:f04f:0:b0:373:bd70:af2 with SMTP id s15-20020a63f04f000000b00373bd700af2mr5258065pgj.497.1645201437311;
        Fri, 18 Feb 2022 08:23:57 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id s40sm3725094pfg.145.2022.02.18.08.23.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Feb 2022 08:23:56 -0800 (PST)
Date:   Fri, 18 Feb 2022 16:23:53 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v3 5/6] KVM: x86: make several AVIC callbacks optional
Message-ID: <Yg/IGUFqqS2r98II@google.com>
References: <20220217180831.288210-1-pbonzini@redhat.com>
 <20220217180831.288210-6-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220217180831.288210-6-pbonzini@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Nit, s/AVIC/APICv in the shortlog.  The "AVIC" callbacks are being deleted, not
made optional, it's kvm_x86_ops' APICv hooks that are becoming optional.

On Thu, Feb 17, 2022, Paolo Bonzini wrote:
> SVM does not need them, so mark them as optional and delete the
> implementation.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/include/asm/kvm-x86-ops.h | 10 +++++-----
>  arch/x86/kvm/lapic.c               | 24 ++++++++++--------------
>  arch/x86/kvm/svm/avic.c            | 18 ------------------
>  arch/x86/kvm/svm/svm.c             |  4 ----
>  arch/x86/kvm/svm/svm.h             |  1 -
>  arch/x86/kvm/x86.c                 |  4 ++--
>  6 files changed, 17 insertions(+), 44 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
> index 5e3296c07207..c0ec066a8599 100644
> --- a/arch/x86/include/asm/kvm-x86-ops.h
> +++ b/arch/x86/include/asm/kvm-x86-ops.h
> @@ -75,11 +75,11 @@ KVM_X86_OP(enable_irq_window)
>  KVM_X86_OP_OPTIONAL(update_cr8_intercept)
>  KVM_X86_OP(check_apicv_inhibit_reasons)
>  KVM_X86_OP(refresh_apicv_exec_ctrl)
> -KVM_X86_OP(hwapic_irr_update)
> -KVM_X86_OP(hwapic_isr_update)
> +KVM_X86_OP_OPTIONAL(hwapic_irr_update)
> +KVM_X86_OP_OPTIONAL(hwapic_isr_update)
>  KVM_X86_OP_OPTIONAL(guest_apic_has_interrupt)
> -KVM_X86_OP(load_eoi_exitmap)
> -KVM_X86_OP(set_virtual_apic_mode)
> +KVM_X86_OP_OPTIONAL(load_eoi_exitmap)
> +KVM_X86_OP_OPTIONAL(set_virtual_apic_mode)
>  KVM_X86_OP_OPTIONAL(set_apic_access_page_addr)
>  KVM_X86_OP(deliver_interrupt)
>  KVM_X86_OP_OPTIONAL(sync_pir_to_irr)
> @@ -102,7 +102,7 @@ KVM_X86_OP_OPTIONAL(vcpu_blocking)
>  KVM_X86_OP_OPTIONAL(vcpu_unblocking)
>  KVM_X86_OP_OPTIONAL(pi_update_irte)
>  KVM_X86_OP_OPTIONAL(pi_start_assignment)
> -KVM_X86_OP(apicv_post_state_restore)
> +KVM_X86_OP_OPTIONAL(apicv_post_state_restore)

apicv_post_state_restore() isn't conditional, it's implemented and wired up
unconditionally by both VMX and SVM.
