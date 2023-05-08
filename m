Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8655B6FB42C
	for <lists+kvm@lfdr.de>; Mon,  8 May 2023 17:47:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234178AbjEHPrm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 May 2023 11:47:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233864AbjEHPrk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 May 2023 11:47:40 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0E3640C7
        for <kvm@vger.kernel.org>; Mon,  8 May 2023 08:47:19 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id 4fb4d7f45d1cf-50bd2d7ba74so49945127a12.1
        for <kvm@vger.kernel.org>; Mon, 08 May 2023 08:47:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1683560838; x=1686152838;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CX0HY5Dhn8sXQJZD/VhXh7Y9Z1W5/IGYy7pEt9qRBEI=;
        b=Zut+1EbnZAxY1pFQj+lFNKhEa+qFGSw3trv8O+gk5vL+L8TxS20JUrk1vc7RTY3DGp
         pitiiZbo4HhdH/sY7L89gnu0iYuPo9XpKjwRc10/gl/8avqv3SefNqfMOO38Tl/jL7hj
         HmoiGvkWHjmMJmrPHbDnlVWgUXUSZjJpof3NrYBsku3pYlzdR9G7RV6XGdyO7B3eqYms
         WlVlXgy1Xwfh7JhenE8blM4DQfql0W87MayPdKdF6h1wmbHZJ1WUmOQqPqtMW61Kyb9C
         2aFfEONAf2uANt+XT/95SXBS1AEUqKSArHVD7TKEwu8gVBcENeTsztCBVnodA51Bbkjs
         Mamw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683560838; x=1686152838;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CX0HY5Dhn8sXQJZD/VhXh7Y9Z1W5/IGYy7pEt9qRBEI=;
        b=R1wTsNfoNaHgTb2P2uh+LIdnLtCtXKY0SUv4xoNsfiTYm1y9KOv9gYTpoBdnp0JTCa
         OHRujHMhSdnI4i3DOz/LDyTMaqR3D0u0xRkV1EtQmaGdOB76AQk1Jm+jt1XzOVaEb4cq
         MgdTcTh7vDqcq2om096IDE8/7U/YrFaxudhplcyeznvi2hMRC9hHz4HVsp8rZG0Tr4G3
         F0unc/X6bf/sPyTGloSxwanHZJ3zsTsbWimKcVaGK1QxPWYsD0SAw9aNrCIApodNDrIM
         tD6ynsyJ3z7qtIv598LLz04kh1CQqQKwZPxBnBsHFq1qGZALZmCsnMnAYDz16hz4Uyf9
         T6xQ==
X-Gm-Message-State: AC+VfDxRpEAvZRLKYDvY2ElNVVmqUL+QUXIXWijIRKyFebOJEK9+IAC9
        t7ZZh15/BxAH97z0SymyzRGdGQ==
X-Google-Smtp-Source: ACHHUZ5y0A5OCcuWqG4aV9RiEAIJmn1LodjKaJGsqf4OmSCGVu/fbqTVzWyy3zKDQxFnsXExvqshCA==
X-Received: by 2002:a17:907:8a08:b0:969:2df9:a0dd with SMTP id sc8-20020a1709078a0800b009692df9a0ddmr1556233ejc.25.1683560838249;
        Mon, 08 May 2023 08:47:18 -0700 (PDT)
Received: from localhost.localdomain (p549211c7.dip0.t-ipconnect.de. [84.146.17.199])
        by smtp.gmail.com with ESMTPSA id md1-20020a170906ae8100b0094b5ce9d43dsm121822ejb.85.2023.05.08.08.47.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 May 2023 08:47:17 -0700 (PDT)
From:   Mathias Krause <minipli@grsecurity.net>
To:     stable@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        Mathias Krause <minipli@grsecurity.net>
Subject: [PATCH 5.15 1/8] KVM: x86/mmu: Avoid indirect call for get_cr3
Date:   Mon,  8 May 2023 17:47:02 +0200
Message-Id: <20230508154709.30043-2-minipli@grsecurity.net>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230508154709.30043-1-minipli@grsecurity.net>
References: <20230508154709.30043-1-minipli@grsecurity.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

[ Upstream commit 2fdcc1b324189b5fb20655baebd40cd82e2bdf0c ]

Most of the time, calls to get_guest_pgd result in calling
kvm_read_cr3 (the exception is only nested TDP).  Hardcode
the default instead of using the get_cr3 function, avoiding
a retpoline if they are enabled.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Mathias Krause <minipli@grsecurity.net>
Link: https://lore.kernel.org/r/20230322013731.102955-2-minipli@grsecurity.net
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Mathias Krause <minipli@grsecurity.net>	# backport to v5.15.x
---
 arch/x86/kvm/mmu.h             | 11 +++++++++++
 arch/x86/kvm/mmu/mmu.c         | 12 ++++++------
 arch/x86/kvm/mmu/paging_tmpl.h |  2 +-
 arch/x86/kvm/x86.c             |  2 +-
 4 files changed, 19 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 7bb165c23233..baafc5d8bb9e 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -115,6 +115,17 @@ static inline void kvm_mmu_load_pgd(struct kvm_vcpu *vcpu)
 					  vcpu->arch.mmu->shadow_root_level);
 }
 
+unsigned long get_guest_cr3(struct kvm_vcpu *vcpu);
+
+static inline unsigned long kvm_mmu_get_guest_pgd(struct kvm_vcpu *vcpu,
+						  struct kvm_mmu *mmu)
+{
+	if (IS_ENABLED(CONFIG_RETPOLINE) && mmu->get_guest_pgd == get_guest_cr3)
+		return kvm_read_cr3(vcpu);
+
+	return mmu->get_guest_pgd(vcpu);
+}
+
 int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 		       bool prefault);
 
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 4724289c8a7f..7c3b809f24b3 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3472,7 +3472,7 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 	unsigned i;
 	int r;
 
-	root_pgd = mmu->get_guest_pgd(vcpu);
+	root_pgd = kvm_mmu_get_guest_pgd(vcpu, mmu);
 	root_gfn = root_pgd >> PAGE_SHIFT;
 
 	if (mmu_check_root(vcpu, root_gfn))
@@ -3899,7 +3899,7 @@ static bool kvm_arch_setup_async_pf(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 	arch.token = alloc_apf_token(vcpu);
 	arch.gfn = gfn;
 	arch.direct_map = vcpu->arch.mmu->direct_map;
-	arch.cr3 = vcpu->arch.mmu->get_guest_pgd(vcpu);
+	arch.cr3 = kvm_mmu_get_guest_pgd(vcpu, vcpu->arch.mmu);
 
 	return kvm_setup_async_pf(vcpu, cr2_or_gpa,
 				  kvm_vcpu_gfn_to_hva(vcpu, gfn), &arch);
@@ -4203,7 +4203,7 @@ void kvm_mmu_new_pgd(struct kvm_vcpu *vcpu, gpa_t new_pgd)
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_new_pgd);
 
-static unsigned long get_cr3(struct kvm_vcpu *vcpu)
+unsigned long get_guest_cr3(struct kvm_vcpu *vcpu)
 {
 	return kvm_read_cr3(vcpu);
 }
@@ -4756,7 +4756,7 @@ static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu)
 	context->invlpg = NULL;
 	context->shadow_root_level = kvm_mmu_get_tdp_level(vcpu);
 	context->direct_map = true;
-	context->get_guest_pgd = get_cr3;
+	context->get_guest_pgd = get_guest_cr3;
 	context->get_pdptr = kvm_pdptr_read;
 	context->inject_page_fault = kvm_inject_page_fault;
 	context->root_level = role_regs_to_root_level(&regs);
@@ -4933,7 +4933,7 @@ static void init_kvm_softmmu(struct kvm_vcpu *vcpu)
 
 	kvm_init_shadow_mmu(vcpu, &regs);
 
-	context->get_guest_pgd     = get_cr3;
+	context->get_guest_pgd     = get_guest_cr3;
 	context->get_pdptr         = kvm_pdptr_read;
 	context->inject_page_fault = kvm_inject_page_fault;
 }
@@ -4965,7 +4965,7 @@ static void init_kvm_nested_mmu(struct kvm_vcpu *vcpu)
 		return;
 
 	g_context->mmu_role.as_u64 = new_role.as_u64;
-	g_context->get_guest_pgd     = get_cr3;
+	g_context->get_guest_pgd     = get_guest_cr3;
 	g_context->get_pdptr         = kvm_pdptr_read;
 	g_context->inject_page_fault = kvm_inject_page_fault;
 	g_context->root_level        = new_role.base.level;
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index a1811f51eda9..dbb54f65d1df 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -359,7 +359,7 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
 	trace_kvm_mmu_pagetable_walk(addr, access);
 retry_walk:
 	walker->level = mmu->root_level;
-	pte           = mmu->get_guest_pgd(vcpu);
+	pte           = kvm_mmu_get_guest_pgd(vcpu, mmu);
 	have_ad       = PT_HAVE_ACCESSED_DIRTY(mmu);
 
 #if PTTYPE == 64
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 5cb4af42ba64..018f6a394d44 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12155,7 +12155,7 @@ void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu, struct kvm_async_pf *work)
 		return;
 
 	if (!vcpu->arch.mmu->direct_map &&
-	      work->arch.cr3 != vcpu->arch.mmu->get_guest_pgd(vcpu))
+	      work->arch.cr3 != kvm_mmu_get_guest_pgd(vcpu, vcpu->arch.mmu))
 		return;
 
 	kvm_mmu_do_page_fault(vcpu, work->cr2_or_gpa, 0, true);
-- 
2.39.2

