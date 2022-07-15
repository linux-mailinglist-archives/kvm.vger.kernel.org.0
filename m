Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 036D95763D3
	for <lists+kvm@lfdr.de>; Fri, 15 Jul 2022 16:47:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232923AbiGOOrn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jul 2022 10:47:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230359AbiGOOrm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jul 2022 10:47:42 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7223576943
        for <kvm@vger.kernel.org>; Fri, 15 Jul 2022 07:47:41 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id v4-20020a17090abb8400b001ef966652a3so11723947pjr.4
        for <kvm@vger.kernel.org>; Fri, 15 Jul 2022 07:47:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3tUNFb/MgVcjx+q+xnHzJmvjWkinIDyAxRghu8rwyXg=;
        b=Rym6NMECh44r0rwd+1g0imZUyyBEkDdo3kxGbrMPCZFbCbLl/8BZolpTX8W+VAh9J4
         LD7SKH80SdA/NeNTOJFsfxYM8GTz1SGNA0gP0NIwSRANXAG0FNukKoxH1KK97dQAdNdZ
         8wD6skWaNDKebwz+6vNNVeNOvyVxqY0MWM2VLATFbOa72eeqbsLdt8PujtPqPaJ0jmHm
         9Vd+jdFjPnQF0klX7fMRdkrRegi+DQc/Vz8loSDSwCry9LFXOU5I3DsNPpjtNIZJPACo
         tv6/7lXuWQA3HOUAH5sR1YEVV3j6ZJzbWs2uSZxZWowxWWMiXS/qdJtnKJABP3YCVV4n
         fVSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3tUNFb/MgVcjx+q+xnHzJmvjWkinIDyAxRghu8rwyXg=;
        b=I55eGhPUFwhZUSzuCKxNhfhCO1dMkwTFcEcwLmkdpNTiXuZzyDZgJf8JjqWYJF1MyG
         VJbnlfDdFxI7xzOz5y506wBoFdVTE5xMUXhycd1Ncx2pGKQtMLrpiBBm5LA3Hw8FqHQP
         kfE3Z5HRZdnR7lzLLh2EmMeZCzr0IjKBHQEfzBNaVTX8+56gMVLy11QydhB7euiQpXcG
         zccAZLhkJ+kCPxSAnd020QrohtQP635SDRc+SFLH1EuqBFt+1o5GTIfCEdvxrU1SqIlM
         8HadVGo0eT7w84nKooqRM1fO5U6hmgn8aadAceIKRn3SSissuXcPhdtpIeVUg5cx9x4w
         zzxw==
X-Gm-Message-State: AJIora/j8bVDQn03LBF9ODnpdcPWUH0ODziFvzAG2GnznMCYzH9NSzJE
        jUK72blV9v2Kp8+gNMOs0cMmdw==
X-Google-Smtp-Source: AGRyM1s+NPdiYftBQZwlpnh1yi1YFLFqWcXd2bsDwLI/KbcXrV5CTmR6Cwvi9UcyTn2+4UBAiJ4TEw==
X-Received: by 2002:a17:902:b612:b0:16c:7e2d:ff39 with SMTP id b18-20020a170902b61200b0016c7e2dff39mr12737288pls.111.1657896460825;
        Fri, 15 Jul 2022 07:47:40 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id e2-20020a17090a118200b001ef3f85d1aasm5821172pja.9.2022.07.15.07.47.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jul 2022 07:47:40 -0700 (PDT)
Date:   Fri, 15 Jul 2022 14:47:36 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Yu Zhang <yu.c.zhang@linux.intel.com>
Cc:     pbonzini@redhat.com, vkuznets@redhat.com, jmattson@google.com,
        joro@8bytes.org, wanpengli@tencent.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] KVM: X86: Initialize 'fault' in
 kvm_fixup_and_inject_pf_error().
Message-ID: <YtF+CF2FkS7Ho1d5@google.com>
References: <20220715114211.53175-1-yu.c.zhang@linux.intel.com>
 <20220715114211.53175-2-yu.c.zhang@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220715114211.53175-2-yu.c.zhang@linux.intel.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 15, 2022, Yu Zhang wrote:
> kvm_fixup_and_inject_pf_error() was introduced to fixup the error code(
> e.g., to add RSVD flag) and inject the #PF to the guest, when guest
> MAXPHYADDR is smaller than the host one.
> 
> When it comes to nested, L0 is expected to intercept and fix up the #PF
> and then inject to L2 directly if
> - L2.MAXPHYADDR < L0.MAXPHYADDR and
> - L1 has no intention to intercept L2's #PF (e.g., L2 and L1 have the
>   same MAXPHYADDR value && L1 is using EPT for L2),
> instead of constructing a #PF VM Exit to L1. Currently, with PFEC_MASK
> and PFEC_MATCH both set to 0 in vmcs02, the interception and injection
> may happen on all L2 #PFs.
> 
> However, failing to initialize 'fault' in kvm_fixup_and_inject_pf_error()
> may cause the fault.async_page_fault being NOT zeroed, and later the #PF
> being treated as a nested async page fault, and then being injected to L1.
> So just fix it by initialize the 'fault' value in the beginning.

Ouch.

> Fixes: 897861479c064 ("KVM: x86: Add helper functions for illegal GPA checking and page fault injection")
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=216178
> Reported-by: Yang Lixiao <lixiao.yang@intel.com>
> Signed-off-by: Yu Zhang <yu.c.zhang@linux.intel.com>
> ---
>  arch/x86/kvm/x86.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 031678eff28e..3246b3c9dfb3 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -12983,7 +12983,7 @@ EXPORT_SYMBOL_GPL(kvm_spec_ctrl_test_value);
>  void kvm_fixup_and_inject_pf_error(struct kvm_vcpu *vcpu, gva_t gva, u16 error_code)
>  {
>  	struct kvm_mmu *mmu = vcpu->arch.walk_mmu;
> -	struct x86_exception fault;
> +	struct x86_exception fault = {0};
>  	u64 access = error_code &
>  		(PFERR_WRITE_MASK | PFERR_FETCH_MASK | PFERR_USER_MASK);

As stupid as it may be to intentionally not fix the uninitialized data in a robust
way, I'd actually prefer to manually clear fault.async_page_fault instead of
zero-initializing the struct.  Unlike a similar bug fix in commit 159e037d2e36
("KVM: x86: Fully initialize 'struct kvm_lapic_irq' in kvm_pv_kick_cpu_op()"),
this code actually cares about async_page_fault being false as opposed to just
being _initialized_.

And if another field is added to struct x86_exception in the future, leaving the
struct uninitialized means that if such a patch were to miss this case, running
with various sanitizers should in theory be able to detect such a bug.  I suspect
no one has found this with syzkaller due to the need to opt into running with
allow_smaller_maxphyaddr=1.

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f389691d8c04..aeed737b55c2 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12996,6 +12996,7 @@ void kvm_fixup_and_inject_pf_error(struct kvm_vcpu *vcpu, gva_t gva, u16 error_c
                fault.error_code = error_code;
                fault.nested_page_fault = false;
                fault.address = gva;
+               fault.async_page_fault = false;
        }
        vcpu->arch.walk_mmu->inject_page_fault(vcpu, &fault);
 }

