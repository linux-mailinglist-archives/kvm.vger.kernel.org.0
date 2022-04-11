Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A1824FC7EE
	for <lists+kvm@lfdr.de>; Tue, 12 Apr 2022 01:01:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230399AbiDKXDO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Apr 2022 19:03:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbiDKXDM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Apr 2022 19:03:12 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CBBE1ADB9
        for <kvm@vger.kernel.org>; Mon, 11 Apr 2022 16:00:56 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id s137so12733684pgs.5
        for <kvm@vger.kernel.org>; Mon, 11 Apr 2022 16:00:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rdzr/cKB3yUSg51zMS1T2tJHNR+gYeObGbybld3vA4k=;
        b=hq5oG4UUfizVn0A+6bpeJF1V822lw28w9dFQYijxN7p1yXxb0enTZ4vW79jwq8A2Xr
         ESxrgCs9Jb2vyo3p6d/SPvL577BWICLOXoBAAaplL/109O5qNzd7WSzwSPj7hAhKsMIm
         EhDy/RlsO+Nkzgw0LzDbwGz0+iw6+ewvuVX5bMoD6OMXqNIONdwhls31q8QUsBMb2cYe
         Ulv0BCQb5gNJaco3PkYpZ5x2b40wOkinqvMKxDnpdQok8ad03d8sQnhVyeMehBjvUVA8
         Jvbv9ZjjJmp1+Z2xSUxRvTANgnmUHjSYQCNwdHj0nTnpYtctFQXxN3buLDKS2n7/NDPy
         OYiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rdzr/cKB3yUSg51zMS1T2tJHNR+gYeObGbybld3vA4k=;
        b=UhpOA1Xi70oD4+B4FUD5m+pilXbOd80A/1fELla2bdJvDI59ci087JlAtwLrq4ZiSP
         4IumG5sUtF/tCJM9zJ0/AZxT4TbQ/aystPV57PgNZWdJjXL747WKJ30Z/XQNTJ5s7v7S
         GINKeR91Zf7m8zpAOs+XLQtnY5/FaAxp83FCm8Jhl4nXfFQ0hNTgo9gY3ytwUVl8/Uai
         UJOX0qUL538yLG48IZ02VJ2IyVU31mCPtN9UQPEYZNIPoEGNzg5mF6HE5j5GmNnH4Qht
         QPOhWpu04js+Bn36Oodowgqgft2R3S5oGX9NJL7lFaFxkS/z6E7Fj5j/GM6vaxAApJ+P
         QpUA==
X-Gm-Message-State: AOAM532p2FsCtoOtAxdOBeFGuNRkfHBB/waCrmoO7cdcz4nkAuOcUL2n
        2WXvQBIAq2S9vfAaLn0gsJe79g==
X-Google-Smtp-Source: ABdhPJyTrzBW3UQC1QEkNqeOxb87DeV8J0oCZSgheovHaxl4CdUPb2nO17folfSeFQOYHpU6zwC4EQ==
X-Received: by 2002:a63:6645:0:b0:382:65eb:1215 with SMTP id a66-20020a636645000000b0038265eb1215mr28200476pgc.337.1649718055804;
        Mon, 11 Apr 2022 16:00:55 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id m2-20020a17090a4d8200b001cb41f25148sm524749pjh.17.2022.04.11.16.00.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Apr 2022 16:00:55 -0700 (PDT)
Date:   Mon, 11 Apr 2022 23:00:51 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Dunn <daviddunn@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Junaid Shahid <junaids@google.com>
Subject: Re: [PATCH v2 7/9] KVM: x86/mmu: Add try_get_mt_mask to x86_ops
Message-ID: <YlSzI9ZfzPQZhPqj@google.com>
References: <20220321224358.1305530-1-bgardon@google.com>
 <20220321224358.1305530-8-bgardon@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220321224358.1305530-8-bgardon@google.com>
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

On Mon, Mar 21, 2022, Ben Gardon wrote:
> Add another function for getting the memory type mask to x86_ops.
> This version of the function can fail, but it does not require a vCPU
> pointer. It will be used in a subsequent commit for in-place large page
> promotion when disabling dirty logging.
> 
> No functional change intended.
> 
> Signed-off-by: Ben Gardon <bgardon@google.com>
> ---
>  arch/x86/include/asm/kvm-x86-ops.h | 1 +
>  arch/x86/include/asm/kvm_host.h    | 2 ++
>  arch/x86/kvm/svm/svm.c             | 9 +++++++++
>  arch/x86/kvm/vmx/vmx.c             | 1 +
>  4 files changed, 13 insertions(+)
> 
> diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
> index 29affccb353c..29880363b5ed 100644
> --- a/arch/x86/include/asm/kvm-x86-ops.h
> +++ b/arch/x86/include/asm/kvm-x86-ops.h
> @@ -88,6 +88,7 @@ KVM_X86_OP_OPTIONAL(sync_pir_to_irr)
>  KVM_X86_OP_OPTIONAL_RET0(set_tss_addr)
>  KVM_X86_OP_OPTIONAL_RET0(set_identity_map_addr)
>  KVM_X86_OP_OPTIONAL_RET0(get_mt_mask)
> +KVM_X86_OP(try_get_mt_mask)
>  KVM_X86_OP(load_mmu_pgd)
>  KVM_X86_OP(has_wbinvd_exit)
>  KVM_X86_OP(get_l2_tsc_offset)
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index f72e80178ffc..a114e4782702 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1422,6 +1422,8 @@ struct kvm_x86_ops {
>  	int (*set_tss_addr)(struct kvm *kvm, unsigned int addr);
>  	int (*set_identity_map_addr)(struct kvm *kvm, u64 ident_addr);
>  	u64 (*get_mt_mask)(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio);
> +	bool (*try_get_mt_mask)(struct kvm *kvm, gfn_t gfn,
> +				bool is_mmio, u64 *mask);

There's an old saying in Tennessee - I know it's in Texas, probably in Tennessee -
that says, fool me once, shame on... shame on you. Fool me... you can't get fooled again.

Thou shalt not trick me again by using a bool for pass/fail!  Though this one
doesn't have same potential for pain as the TDP MMU's atomic operations.

And as a bonus, if we use 0/-errno, then we can use KVM_X86_OP_OPTIONAL_RET0()
and SVM doesn't need to provide an implementation.

Tangentially related to the return type, what about naming it something like
get_vm_wide_mt_mask() to convey exactly what it's doing?  The @kvm param kinda
does that, but IMO it doesn't do a good of capturing why the function can fail.
Adding "vm_wide" helps explain why it can, i.e. that there may not be a VM-wide
memtype established for the gfn.

As penance for your boolean sin, can you slot this in earlier in your series?
It's obviously not a hard dependency, but using a u64 for the mask here and then
undoing the whole thing is rather silly.  Compile tested only at this point, I'll
test on an actual system ASAP and let you know if I did something stupid.

From: Sean Christopherson <seanjc@google.com>
Date: Mon, 11 Apr 2022 15:12:16 -0700
Subject: [PATCH] KVM: x86: Restrict get_mt_mask() to a u8, use
 KVM_X86_OP_OPTIONAL_RET0

Restrict get_mt_mask() to a u8 and reintroduce using a RET0 static_call
for the SVM implementation.  EPT stores the memtype information in the
lower 8 bits (bits 6:3 to be precise), and even returns a shifted u8
without an explicit cast to a larger type; there's no need to return a
full u64.

Note, RET0 doesn't play nice with a u64 return on 32-bit kernels, see
commit bf07be36cd88 ("KVM: x86: do not use KVM_X86_OP_OPTIONAL_RET0 for
get_mt_mask").

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm-x86-ops.h | 2 +-
 arch/x86/include/asm/kvm_host.h    | 2 +-
 arch/x86/kvm/svm/svm.c             | 6 ------
 arch/x86/kvm/vmx/vmx.c             | 2 +-
 4 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 96e4e9842dfc..0d16f21a6203 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -87,7 +87,7 @@ KVM_X86_OP(deliver_interrupt)
 KVM_X86_OP_OPTIONAL(sync_pir_to_irr)
 KVM_X86_OP_OPTIONAL_RET0(set_tss_addr)
 KVM_X86_OP_OPTIONAL_RET0(set_identity_map_addr)
-KVM_X86_OP(get_mt_mask)
+KVM_X86_OP_OPTIONAL_RET0(get_mt_mask)
 KVM_X86_OP(load_mmu_pgd)
 KVM_X86_OP(has_wbinvd_exit)
 KVM_X86_OP(get_l2_tsc_offset)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 2c20f715f009..dc4d34f1bcf9 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1421,7 +1421,7 @@ struct kvm_x86_ops {
 	int (*sync_pir_to_irr)(struct kvm_vcpu *vcpu);
 	int (*set_tss_addr)(struct kvm *kvm, unsigned int addr);
 	int (*set_identity_map_addr)(struct kvm *kvm, u64 ident_addr);
-	u64 (*get_mt_mask)(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio);
+	u8 (*get_mt_mask)(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio);

 	void (*load_mmu_pgd)(struct kvm_vcpu *vcpu, hpa_t root_hpa,
 			     int root_level);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index fc1725b7d05f..56f03eafe421 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4011,11 +4011,6 @@ static bool svm_has_emulated_msr(struct kvm *kvm, u32 index)
 	return true;
 }

-static u64 svm_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
-{
-	return 0;
-}
-
 static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
@@ -4673,7 +4668,6 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.check_apicv_inhibit_reasons = avic_check_apicv_inhibit_reasons,
 	.apicv_post_state_restore = avic_apicv_post_state_restore,

-	.get_mt_mask = svm_get_mt_mask,
 	.get_exit_info = svm_get_exit_info,

 	.vcpu_after_set_cpuid = svm_vcpu_after_set_cpuid,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index cf8581978bce..646fa609aa0d 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7142,7 +7142,7 @@ static int __init vmx_check_processor_compat(void)
 	return 0;
 }

-static u64 vmx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
+static u8 vmx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
 {
 	u8 cache;


base-commit: 59d9e75d641565603e7c293f4cec182d86db8586
--






