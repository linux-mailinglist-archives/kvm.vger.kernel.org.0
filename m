Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3AEA391E6C
	for <lists+kvm@lfdr.de>; Wed, 26 May 2021 19:52:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234508AbhEZRxu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 May 2021 13:53:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234466AbhEZRxt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 May 2021 13:53:49 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C54D9C061574
        for <kvm@vger.kernel.org>; Wed, 26 May 2021 10:52:16 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id n6-20020a17090ac686b029015d2f7aeea8so770988pjt.1
        for <kvm@vger.kernel.org>; Wed, 26 May 2021 10:52:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ozaRyASrDvgcYSKFxAksSnaGIqsO4XNQHszbmucdN5Y=;
        b=mNKPhtPk2hp1Sn+H2thZmoNcYsyGcAteQsRC/WJqraeLEodXq47RYA7/HjZ4Phfh8M
         j2YXhCFFbUM6Ly+fWFJ9xA8exBdpqZA8pSOFZQsn1m48JHn+XdIk6OISkBcHirNJstpj
         1IxFgxIy8NYWB9NY1jTwWYFDLELTwon5/zWS6IUYDH1Uzd6LBdIFqMqEdYQcC1ETaBmT
         Vi6/k9fabebO3GqszGkjri53UgmQttkpocaJWf4Vg0tx/fVs41XEtO1zECz3hbYaqYui
         UV6mr4OpEgvbxmrgXOjp9FfGF0N1w2YQXlmINfkEXCuEBLdA9mg255EJumPxn1dELbK1
         n1Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ozaRyASrDvgcYSKFxAksSnaGIqsO4XNQHszbmucdN5Y=;
        b=ixiPeU3fWlqqfBrHuf8ua1/3xztciutxqPKmS3jnmCUV/Aorrc+HnbTOPpnFCvFYim
         jPUPXamrWffeJzOeWiKtgYUI4gQSEPa/XpcEt1ln0nezegQyp7s0SiAIqTNZ+xIicPJQ
         7vNVmULRBPjicwEykvY4Mcacd4YZMNQiOj5np5/1xfhsrzYOoYFi7x0NiEjKQJxa9rts
         TNWwsCLrfesia3x4yW+TPFfD2W7a2Bv6jCk4w35dN17Hlxrhho72a+TkBY5g9obzM8Lt
         mVCM+BcUPoS+qtHVcxxGxLJrEaMhfRRznjvxid1Mjr2C0d74vY1cJjQ674fItLBA5N0V
         ipbQ==
X-Gm-Message-State: AOAM530seoYFpHyzCwXxZQV75OYP5Rf8Tdrhd43OR7JUEW9/3PnZmacn
        2qs3hTpMUy+quojOqrA/t6owcg==
X-Google-Smtp-Source: ABdhPJztcSr2OeiT5lfyuR6zv0w/dhi1TxkOUtMUBsiBWCGLIRE/UZsdhCoYFTU/wow956J2AQlr1g==
X-Received: by 2002:a17:902:a50b:b029:f7:820f:fd1c with SMTP id s11-20020a170902a50bb02900f7820ffd1cmr26486937plq.69.1622051536239;
        Wed, 26 May 2021 10:52:16 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id u5sm2936508pfi.179.2021.05.26.10.52.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 May 2021 10:52:15 -0700 (PDT)
Date:   Wed, 26 May 2021 17:52:11 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH v2 1/2] KVM: X86: Fix warning caused by stale emulation
 context
Message-ID: <YK6Ky7+QJUZjO0DT@google.com>
References: <1621911767-11703-1-git-send-email-wanpengli@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1621911767-11703-1-git-send-email-wanpengli@tencent.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 24, 2021, Wanpeng Li wrote:
> From: Wanpeng Li <wanpengli@tencent.com>
> 
> Reported by syzkaller:
> 
>   WARNING: CPU: 7 PID: 10526 at /home/kernel/ssd/linux/arch/x86/kvm//x86.c:7621 x86_emulate_instruction+0x41b/0x510 [kvm]
>   RIP: 0010:x86_emulate_instruction+0x41b/0x510 [kvm]
>   Call Trace:
>    kvm_mmu_page_fault+0x126/0x8f0 [kvm]
>    vmx_handle_exit+0x11e/0x680 [kvm_intel]
>    vcpu_enter_guest+0xd95/0x1b40 [kvm]
>    kvm_arch_vcpu_ioctl_run+0x377/0x6a0 [kvm]
>    kvm_vcpu_ioctl+0x389/0x630 [kvm]
>    __x64_sys_ioctl+0x8e/0xd0
>    do_syscall_64+0x3c/0xb0
>    entry_SYSCALL_64_after_hwframe+0x44/0xae
> 
> Commit 4a1e10d5b5d8c (KVM: x86: handle hardware breakpoints during emulation())
> adds hardware breakpoints check before emulation the instruction and parts of 
> emulation context initialization, actually we don't have the EMULTYPE_NO_DECODE flag 
> here and the emulation context will not be reused. Commit c8848cee74ff (KVM: x86: 
> set ctxt->have_exception in x86_decode_insn()) triggers the warning because it 
> catches the stale emulation context has #UD, however, it is not during instruction 
> decoding which should result in EMULATION_FAILED. This patch fixes it by moving 
> the second part emulation context initialization into init_emulate_ctxt() and 
> before hardware breakpoints check. The ctxt->ud will be dropped by a follow-up 
> patch.
> 
> syzkaller source: https://syzkaller.appspot.com/x/repro.c?x=134683fdd00000
> 
> Reported-by: syzbot+71271244f206d17f6441@syzkaller.appspotmail.com
> Fixes: 4a1e10d5b5d8 (KVM: x86: handle hardware breakpoints during emulation)
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
> v1 -> v2:
>  * move the second part emulation context initialization into init_emulate_ctxt()
> 
>  arch/x86/kvm/x86.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index bed7b53..3c109d3 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -7228,6 +7228,11 @@ static void init_emulate_ctxt(struct kvm_vcpu *vcpu)
>  	BUILD_BUG_ON(HF_SMM_MASK != X86EMUL_SMM_MASK);
>  	BUILD_BUG_ON(HF_SMM_INSIDE_NMI_MASK != X86EMUL_SMM_INSIDE_NMI_MASK);
>  
> +	ctxt->interruptibility = 0;
> +	ctxt->have_exception = false;
> +	ctxt->exception.vector = -1;
> +	ctxt->perm_ok = false;
> +
>  	init_decode_cache(ctxt);
>  	vcpu->arch.emulate_regs_need_sync_from_vcpu = false;
>  }
> @@ -7554,6 +7559,8 @@ int x86_decode_emulated_instruction(struct kvm_vcpu *vcpu, int emulation_type,
>  
>  	init_emulate_ctxt(vcpu);
>  
> +	ctxt->ud = emulation_type & EMULTYPE_TRAP_UD;

Heh, you sent the delta relative to v1.  To avoid confusion, can you post v3
with this squashed in?

Thanks!
