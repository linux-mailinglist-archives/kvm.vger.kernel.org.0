Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CA604D1CFA
	for <lists+kvm@lfdr.de>; Tue,  8 Mar 2022 17:16:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347997AbiCHQRd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Mar 2022 11:17:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238000AbiCHQRd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Mar 2022 11:17:33 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C45550E15
        for <kvm@vger.kernel.org>; Tue,  8 Mar 2022 08:16:36 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id n2so7993902plf.4
        for <kvm@vger.kernel.org>; Tue, 08 Mar 2022 08:16:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=u43xiIzdToYyNnIi4SkjFPIKs2NeakO8JJZvxccrXJI=;
        b=n3DOQjy5Si7UPfdp3xIsCtFT0p8P1d2sb7RXLzDqG9dWTdQyJmp//2IWkBj+fPQ/PF
         /RFFw3XR4s5FWdFJ5tIh94Bwtp6rWnqhFGJ6dR1X7qcrYa+QLS3M5d3hyPYOSHVePJ23
         bd119KjqKa814dNb+EUQptrYVI+96x601g5v9KLYbMo7AjWRS1G0qT+zlsxJQcMtEP2Q
         PqfEPidTzv4vNsNsVpz+k3jnObaliEi7wgZ/CuGQc0KftRWZbQ0OEBFsJkw9JqyKxRpI
         Qb52HcBCC4UtEitHAOkwHz/qchzlyChksu+m/piebvtk0C9ROa/Nzd4TCQ/ubRKEzlsH
         6TPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=u43xiIzdToYyNnIi4SkjFPIKs2NeakO8JJZvxccrXJI=;
        b=XdxEC2zIN9LOexZuTLCKv8NvjvGpx6aX5UAWUNvgT6buFVy/TeOLBwVEePwZW//c61
         cp79xqacfBU7Pp4irqtAAOyERmgMczLCAf+jA9S2k9loyuKCXdocchvtyw6znhzchaBt
         RGgRcaZPqv+/NbZD7SBJa2tx1Z5zdCEISX514f5+GCrXCI2eRS4BaLMYWG3DLDV4DhFJ
         XKn+NFAufrilNx5B2H0xdKktxqtaAUi5OSULwp+PiOgh9sK9Zr+TBcq8Vl1kyHteGTiB
         88C1tfwLELE1CdZ20G2d045oguN/9yZ5cv+qfbZiLayCpXazVcYYm/mP33XeRuvs8F3T
         xA7A==
X-Gm-Message-State: AOAM5307Rz2il4NJX3Z9XzrQnWVLpr7x5oFdnt5rg4tD4JAVW9CMEBhH
        RXRQtGBC0OG6vxT/9kIA2QLTng==
X-Google-Smtp-Source: ABdhPJzEl/PqG/eYn90V/v7gwG57/FJkYPrscymutUImiBNn+QVUpWVW+LQiMIIoOJyUhb+XLZ5fjA==
X-Received: by 2002:a17:902:f684:b0:151:93ab:3483 with SMTP id l4-20020a170902f68400b0015193ab3483mr18571496plg.4.1646756195577;
        Tue, 08 Mar 2022 08:16:35 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id e18-20020a056a001a9200b004bc82d0e125sm20015997pfv.119.2022.03.08.08.16.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 08:16:34 -0800 (PST)
Date:   Tue, 8 Mar 2022 16:16:31 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        dmatlack@google.com
Subject: Re: [PATCH v2 01/25] KVM: x86/mmu: avoid indirect call for get_cr3
Message-ID: <YieBXzkOkB9SZpyp@google.com>
References: <20220221162243.683208-1-pbonzini@redhat.com>
 <20220221162243.683208-2-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220221162243.683208-2-pbonzini@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 21, 2022, Paolo Bonzini wrote:
> Most of the time, calls to get_guest_pgd result in calling kvm_read_cr3
> (the exception is only nested TDP).  Check if that is the case if
> retpolines are enabled, thus avoiding an expensive indirect call.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/mmu.h             | 10 ++++++++++
>  arch/x86/kvm/mmu/mmu.c         | 15 ++++++++-------
>  arch/x86/kvm/mmu/paging_tmpl.h |  2 +-
>  arch/x86/kvm/x86.c             |  2 +-
>  4 files changed, 20 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> index 1d0c1904d69a..6ee4436e46f1 100644
> --- a/arch/x86/kvm/mmu.h
> +++ b/arch/x86/kvm/mmu.h
> @@ -116,6 +116,16 @@ static inline void kvm_mmu_load_pgd(struct kvm_vcpu *vcpu)
>  					  vcpu->arch.mmu->shadow_root_level);
>  }
>  
> +extern unsigned long kvm_get_guest_cr3(struct kvm_vcpu *vcpu);

No extern please, it's superfluous and against KVM style.  Moot point though, see
below.

> +static inline unsigned long kvm_mmu_get_guest_pgd(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu)

Wrap the params, no reason to make this line so long.

> +{
> +#ifdef CONFIG_RETPOLINE
> +	if (mmu->get_guest_pgd == kvm_get_guest_cr3)
> +		return kvm_read_cr3(vcpu);

This is unnecessarily fragile and confusing at first glance.  Compilers are smart
enough to generate a non-inline version of functions if they're used for function
pointers, while still inlining where appropriate.  In other words, just drop
kvm_get_guest_cr3() entirely, a al get_pdptr => kvm_pdptr_read().

---
 arch/x86/kvm/mmu.h     |  6 +++---
 arch/x86/kvm/mmu/mmu.c | 11 +++--------
 2 files changed, 6 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 3af66b9df640..50528d39de8d 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -117,11 +117,11 @@ static inline void kvm_mmu_load_pgd(struct kvm_vcpu *vcpu)
 					  vcpu->arch.mmu->shadow_root_level);
 }

-extern unsigned long kvm_get_guest_cr3(struct kvm_vcpu *vcpu);
-static inline unsigned long kvm_mmu_get_guest_pgd(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu)
+static inline unsigned long kvm_mmu_get_guest_pgd(struct kvm_vcpu *vcpu,
+						  struct kvm_mmu *mmu)
 {
 #ifdef CONFIG_RETPOLINE
-	if (mmu->get_guest_pgd == kvm_get_guest_cr3)
+	if (mmu->get_guest_pgd == kvm_read_cr3)
 		return kvm_read_cr3(vcpu);
 #endif
 	return mmu->get_guest_pgd(vcpu);
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 995c3450c20f..cc2414397e4b 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4234,11 +4234,6 @@ void kvm_mmu_new_pgd(struct kvm_vcpu *vcpu, gpa_t new_pgd)
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_new_pgd);

-unsigned long kvm_get_guest_cr3(struct kvm_vcpu *vcpu)
-{
-	return kvm_read_cr3(vcpu);
-}
-
 static bool sync_mmio_spte(struct kvm_vcpu *vcpu, u64 *sptep, gfn_t gfn,
 			   unsigned int access)
 {
@@ -4793,7 +4788,7 @@ static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu)
 	context->invlpg = NULL;
 	context->shadow_root_level = kvm_mmu_get_tdp_level(vcpu);
 	context->direct_map = true;
-	context->get_guest_pgd = kvm_get_guest_cr3;
+	context->get_guest_pgd = kvm_read_cr3;
 	context->get_pdptr = kvm_pdptr_read;
 	context->inject_page_fault = kvm_inject_page_fault;
 	context->root_level = role_regs_to_root_level(&regs);
@@ -4968,7 +4963,7 @@ static void init_kvm_softmmu(struct kvm_vcpu *vcpu)

 	kvm_init_shadow_mmu(vcpu, &regs);

-	context->get_guest_pgd	   = kvm_get_guest_cr3;
+	context->get_guest_pgd	   = kvm_read_cr3;
 	context->get_pdptr         = kvm_pdptr_read;
 	context->inject_page_fault = kvm_inject_page_fault;
 }
@@ -5000,7 +4995,7 @@ static void init_kvm_nested_mmu(struct kvm_vcpu *vcpu)
 		return;

 	g_context->mmu_role.as_u64 = new_role.as_u64;
-	g_context->get_guest_pgd     = kvm_get_guest_cr3;
+	g_context->get_guest_pgd     = kvm_read_cr3;
 	g_context->get_pdptr         = kvm_pdptr_read;
 	g_context->inject_page_fault = kvm_inject_page_fault;
 	g_context->root_level        = new_role.base.level;

base-commit: c31df3e63672c14d8b52e34606c823e2166024b8
--
