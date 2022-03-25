Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32B8C4E7DD4
	for <lists+kvm@lfdr.de>; Sat, 26 Mar 2022 01:23:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232114AbiCYUUN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Mar 2022 16:20:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232018AbiCYUUM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Mar 2022 16:20:12 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5B3458388
        for <kvm@vger.kernel.org>; Fri, 25 Mar 2022 13:18:37 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id h19so6365373pfv.1
        for <kvm@vger.kernel.org>; Fri, 25 Mar 2022 13:18:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+BiLrsol8UooQIBgOwX5PV4NHr4Qkzt2YsBo+6MoPXY=;
        b=C7dF2Wm/2i36wTwed281ekQrLIxMZdr+6MdijR84uMjQjAJ7ewmU19tDcBy5dR1/Jl
         ON+2Ft8Sp0zatWxRfpWJtVfULKQfoMAuCkt9ypaGCW5tXqJPrlVlTbDcQ/CxFwmkm1VW
         ikC7zVMIEfKqVQ93eeNSp3tVBeBNR5Z8zLlML1qMtguVfo+NgYqjAeFfvqsqdvD2yOxQ
         sW8/RbCg26TuKWs8YghjRgG/jREeztcnK/QYW2SSrV/hBHM+Z2XO5e6FiR28NLW/zBI/
         bc/xMoDdN7QNjuVOxVlQvUy1WjLpnAYzuqO+ZM8emxchaln3d1cVcen5aiDgXWPMspK3
         l3pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+BiLrsol8UooQIBgOwX5PV4NHr4Qkzt2YsBo+6MoPXY=;
        b=Mry3cemBIkFcLaWZgQzHmb0e1d0NOReBUjarJz1IoAmRbgkWVzoh/LZGtQvOLHqVXd
         mB1aa2wBZ7lUoYPL1iBs4B6GuHvLK23dsUZ6iDyuC6XM5gKJx2/4VUwT+8WyYpin5+cj
         xm0r7g7BinuuqZdpNhMx427V8n5ModhZdVbEUv09erTULXmjqxPwKMvUBTgNlYsPClP4
         r5BgfEsrQUyO3tn44gbdywZlInktlyhmtOye+WEGW8NnfapUicGUtvQsEd/fDupAoeeA
         W2u3Mfz7KfvvXYP2zINz3runGPQXU777hpk8j9cI7AEa7oF9v/2w9EgR0eAJAsGy9ZHW
         VeDg==
X-Gm-Message-State: AOAM5339jvuy7Q4kdKHheSnu0cHmDkrcdOn/J8fVxHm40QEsnOMNSm5Y
        jAHUY8ih8nE5so20FPkINgD+PQ==
X-Google-Smtp-Source: ABdhPJxVK7LN8fN0CxrEFZyc2Ktita/GU1jn9CKCcSGfof8Md3k9iTge7MCfm39/1dTm5ftjtPJdmQ==
X-Received: by 2002:a63:6c45:0:b0:37c:714a:4ffe with SMTP id h66-20020a636c45000000b0037c714a4ffemr978294pgc.513.1648239516919;
        Fri, 25 Mar 2022 13:18:36 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id b10-20020a056a00114a00b004f784ba5e6asm8074729pfm.17.2022.03.25.13.18.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Mar 2022 13:18:36 -0700 (PDT)
Date:   Fri, 25 Mar 2022 20:18:32 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [FYI PATCH] Revert "KVM: x86/mmu: Zap only TDP MMU leafs in
 kvm_zap_gfn_range()"
Message-ID: <Yj4jmAjj5ZTJodQM@google.com>
References: <20220318164833.2745138-1-pbonzini@redhat.com>
 <d6367754-7782-7c29-e756-ac02dbd4520b@redhat.com>
 <Yj0FYSC2sT4k/ELl@google.com>
 <87r16qnkgl.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87r16qnkgl.fsf@redhat.com>
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

On Fri, Mar 25, 2022, Vitaly Kuznetsov wrote:
> Sean Christopherson <seanjc@google.com> writes:
> > Actually, since this is apparently specific to kvm_zap_gfn_range(), can you add
> > printk "tracing" in update_mtrr(), kvm_post_set_cr0(), and __kvm_request_apicv_update()
> > to see what is actually triggering zaps?  Capturing the start and end GFNs would be very
> > helpful for the MTRR case.
> >
> > The APICv update seems unlikely to affect only Hyper-V guests, though there is the auto
> > EOI crud.  And the other two only come into play with non-coherent DMA.  In other words,
> > figuring out exactly what sequence leads to failure should be straightforward.
> 
> The tricky part here is that Hyper-V doesn't crash immediately, the
> crash is always different (if you look at the BSOD) and happens at
> different times. Crashes mention various stuff like trying to execute
> non-executable memory, ...
> 
> I've added tracing you've suggested:
> - __kvm_request_apicv_update() happens only once in the very beginning.

And thinking through this again, APICv changes should never result in a shadow
page being zapped as they'll only zap a 4k range.

> - update_mtrr() never actually reaches kvm_zap_gfn_range()
> 
> - kvm_post_set_cr0() happen in early boot but the crash happen much much
>   later. E.g.:

Ah rats, I got the sequencing of the revert messed up.  mmu_notifier is also in
play, via kvm_tdp_mmu_unmap_gfn_range().

> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 4fa4d8269e5b..db7c5a05e574 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -870,6 +870,8 @@ EXPORT_SYMBOL_GPL(load_pdptrs);
>  
>  void kvm_post_set_cr0(struct kvm_vcpu *vcpu, unsigned long old_cr0, unsigned long cr0)
>  {
> +       trace_printk("vCPU %d %lx %lx\n", vcpu->vcpu_id, old_cr0, cr0);

This doesn't guarantee kvm_zap_gfn_range() will be reached.   The guest has to
have non-coherente DMA and be running with the CD/NW memtyp quirk.  Moving the
print inside the if statement would show if KVM is actually zapping in those
cases.

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d3a9ce07a565..25c7d8fc3287 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -887,8 +887,10 @@ void kvm_post_set_cr0(struct kvm_vcpu *vcpu, unsigned long old_cr0, unsigned lon

        if (((cr0 ^ old_cr0) & X86_CR0_CD) &&
            kvm_arch_has_noncoherent_dma(vcpu->kvm) &&
-           !kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_CD_NW_CLEARED))
+           !kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_CD_NW_CLEARED)) {
+               trace_printk("vCPU %d %lx %lx\n", vcpu->vcpu_id, old_cr0, cr0);
                kvm_zap_gfn_range(vcpu->kvm, 0, ~0ULL);
+       }
 }
 EXPORT_SYMBOL_GPL(kvm_post_set_cr0);

> kvm_hv_set_msr_pw() call is when Hyper-V writes to HV_X64_MSR_CRASH_CTL
> ('hv-crash' QEMU flag is needed to enable the feature). The debug patch
> is:
> 
> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> index a32f54ab84a2..59a72f6ced99 100644
> --- a/arch/x86/kvm/hyperv.c
> +++ b/arch/x86/kvm/hyperv.c
> @@ -1391,6 +1391,7 @@ static int kvm_hv_set_msr_pw(struct kvm_vcpu *vcpu, u32 msr, u64 data,
>  
>                         /* Send notification about crash to user space */
>                         kvm_make_request(KVM_REQ_HV_CRASH, vcpu);
> +                       trace_printk("%d\n", vcpu->vcpu_id);
>                 }
>                 break;
>         case HV_X64_MSR_RESET:
> 
> So it's 20 seconds (!) between the last kvm_post_set_cr0() call and the
> crash. My (disappointing) conclusion is: the problem can be anywhere and
> Hyper-V detects it much much later.

And reproduced... 'twas indeed the mmu_notifier.  Hyper-V 2019 booted just fine,
until I turned on KSM and cranked up the scanning.

The bug has nothing to do with zapping only leafs, it's a simple goof where the
TLB flush gets lost.  Not sure why only Hyper-V detects the issue; maybe because
it maintains a pool of zeroed pages that are KSM-friendly?

I'll send a patch to reintroduce the reverted code.

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index c71debdbc732..a641737725d1 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -885,7 +885,7 @@ bool kvm_tdp_mmu_zap_leafs(struct kvm *kvm, int as_id, gfn_t start, gfn_t end,
        struct kvm_mmu_page *root;

        for_each_tdp_mmu_root_yield_safe(kvm, root, as_id)
-               flush = tdp_mmu_zap_leafs(kvm, root, start, end, can_yield, false);
+               flush = tdp_mmu_zap_leafs(kvm, root, start, end, can_yield, flush);

        return flush;
 }
