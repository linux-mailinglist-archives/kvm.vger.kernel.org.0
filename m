Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE06A672045
	for <lists+kvm@lfdr.de>; Wed, 18 Jan 2023 15:54:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231660AbjAROyb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Jan 2023 09:54:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231591AbjAROyC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Jan 2023 09:54:02 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FBC517143
        for <kvm@vger.kernel.org>; Wed, 18 Jan 2023 06:48:52 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id z11so49958632ede.1
        for <kvm@vger.kernel.org>; Wed, 18 Jan 2023 06:48:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=joD6UNobMMls+6tKVhM1/laXbk6jjwsQnCEiOHpSVIA=;
        b=kcTDj7kf9QUJL+m+KQdNrIqCOkXZxTmuAvbzi81FXwYxVb+iwApEJJeoKQAwCF9lar
         nPAW2STRniXosa99/5v96Ok1DbvuMCIfuz0pHV+XG/DMBOVkt04a4+Hven9XxZaSX+B0
         1jSd2+vjSESJDsW3PGJatIc4Yq7db3Lnuwc3FsW3jk4h6DhYWiwzIHvt8pR/lrR7ynap
         VkqfDr7Y9Hj5Lp7TEAi/G+0w6QjF5pwRUhwyODQxzl6HYsJ697XRNFHX0bgPAVy4ADi5
         /ju1rCNHmd4/Mxa4rpPnm9DE5Gfe3QQZF5eJ6zVVpi9qitRuHPwxwKHBZET61/Lk0D3/
         tJPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=joD6UNobMMls+6tKVhM1/laXbk6jjwsQnCEiOHpSVIA=;
        b=8JdXMZg0LaK5YiCqfEbKj1arNjO60azbMfSWVuIp+Mw37hj1yL65xg1cfqQRghJRL2
         +jntnwvaXDVDDbqvgcHL7B/zDMkYTp3s/RALxw7DTFUrA/qokV4iE22IDxZq0FhWC01G
         ULgKiTcnGT0P+ijUrEBbeuyl1FAuyYv0CfZrsrVkmYbruEXntEjzlZ7MbLXgcgQHWaUl
         R5FRLeJeV/22vBMYVcugO2rbGFVRiz7AcPJswWDd1MyyXodDwX8zbN1Liu6Eufto6CGK
         KpgOquJ5LCJPIplnQbjfiBe/CeVM7JNIWyoADYpNCBhwpALO0Lne4BHRSAKSr0HEaA27
         ujTg==
X-Gm-Message-State: AFqh2kqaqDHN9pv4bFVRp5k19eZ1LLy4I2LDEFBjtnXoa4SSkSncmaSj
        7k4OY5jJTBr9CGOy5Ne74AisYRdwcazDdW9h
X-Google-Smtp-Source: AMrXdXsCiq4BB50JFFr2xefbFSgO+VrMFTurwjxRt4giCZjEb8rNN5+/UgmlPxt1jZ2UeFNZK+fLmA==
X-Received: by 2002:a05:6402:10c9:b0:49d:a87f:ba78 with SMTP id p9-20020a05640210c900b0049da87fba78mr7121605edu.35.1674053330954;
        Wed, 18 Jan 2023 06:48:50 -0800 (PST)
Received: from nuc.fritz.box (p200300f6af03d2006e0fc0b921f9db5c.dip0.t-ipconnect.de. [2003:f6:af03:d200:6e0f:c0b9:21f9:db5c])
        by smtp.gmail.com with ESMTPSA id p11-20020a05640243cb00b0049e19136c22sm3627509edc.95.2023.01.18.06.48.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 06:48:50 -0800 (PST)
From:   Mathias Krause <minipli@grsecurity.net>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Mathias Krause <minipli@grsecurity.net>
Subject: [PATCH v2 1/3] KVM: x86/mmu: avoid indirect call for get_cr3
Date:   Wed, 18 Jan 2023 15:50:28 +0100
Message-Id: <20230118145030.40845-2-minipli@grsecurity.net>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230118145030.40845-1-minipli@grsecurity.net>
References: <20230118145030.40845-1-minipli@grsecurity.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

Most of the time, calls to get_guest_pgd result in calling
kvm_read_cr3 (the exception is only nested TDP).  Hardcode
the default instead of using the get_cr3 function, avoiding
a retpoline if they are enabled.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Mathias Krause <minipli@grsecurity.net>
---
 arch/x86/kvm/mmu/mmu.c         | 31 ++++++++++++++++++++-----------
 arch/x86/kvm/mmu/paging_tmpl.h |  2 +-
 2 files changed, 21 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index aeb240b339f5..505768631614 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -241,6 +241,20 @@ static struct kvm_mmu_role_regs vcpu_to_role_regs(struct kvm_vcpu *vcpu)
 	return regs;
 }
 
+static unsigned long get_guest_cr3(struct kvm_vcpu *vcpu)
+{
+	return kvm_read_cr3(vcpu);
+}
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
 static inline bool kvm_available_flush_tlb_with_range(void)
 {
 	return kvm_x86_ops.tlb_remote_flush_with_range;
@@ -3722,7 +3736,7 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 	int quadrant, i, r;
 	hpa_t root;
 
-	root_pgd = mmu->get_guest_pgd(vcpu);
+	root_pgd = kvm_mmu_get_guest_pgd(vcpu, mmu);
 	root_gfn = root_pgd >> PAGE_SHIFT;
 
 	if (mmu_check_root(vcpu, root_gfn))
@@ -4172,7 +4186,7 @@ static bool kvm_arch_setup_async_pf(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 	arch.token = alloc_apf_token(vcpu);
 	arch.gfn = gfn;
 	arch.direct_map = vcpu->arch.mmu->root_role.direct;
-	arch.cr3 = vcpu->arch.mmu->get_guest_pgd(vcpu);
+	arch.cr3 = kvm_mmu_get_guest_pgd(vcpu, vcpu->arch.mmu);
 
 	return kvm_setup_async_pf(vcpu, cr2_or_gpa,
 				  kvm_vcpu_gfn_to_hva(vcpu, gfn), &arch);
@@ -4191,7 +4205,7 @@ void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu, struct kvm_async_pf *work)
 		return;
 
 	if (!vcpu->arch.mmu->root_role.direct &&
-	      work->arch.cr3 != vcpu->arch.mmu->get_guest_pgd(vcpu))
+	      work->arch.cr3 != kvm_mmu_get_guest_pgd(vcpu, vcpu->arch.mmu))
 		return;
 
 	kvm_mmu_do_page_fault(vcpu, work->cr2_or_gpa, 0, true);
@@ -4592,11 +4606,6 @@ void kvm_mmu_new_pgd(struct kvm_vcpu *vcpu, gpa_t new_pgd)
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_new_pgd);
 
-static unsigned long get_cr3(struct kvm_vcpu *vcpu)
-{
-	return kvm_read_cr3(vcpu);
-}
-
 static bool sync_mmio_spte(struct kvm_vcpu *vcpu, u64 *sptep, gfn_t gfn,
 			   unsigned int access)
 {
@@ -5147,7 +5156,7 @@ static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu,
 	context->page_fault = kvm_tdp_page_fault;
 	context->sync_page = nonpaging_sync_page;
 	context->invlpg = NULL;
-	context->get_guest_pgd = get_cr3;
+	context->get_guest_pgd = get_guest_cr3;
 	context->get_pdptr = kvm_pdptr_read;
 	context->inject_page_fault = kvm_inject_page_fault;
 
@@ -5297,7 +5306,7 @@ static void init_kvm_softmmu(struct kvm_vcpu *vcpu,
 
 	kvm_init_shadow_mmu(vcpu, cpu_role);
 
-	context->get_guest_pgd     = get_cr3;
+	context->get_guest_pgd     = get_guest_cr3;
 	context->get_pdptr         = kvm_pdptr_read;
 	context->inject_page_fault = kvm_inject_page_fault;
 }
@@ -5311,7 +5320,7 @@ static void init_kvm_nested_mmu(struct kvm_vcpu *vcpu,
 		return;
 
 	g_context->cpu_role.as_u64   = new_mode.as_u64;
-	g_context->get_guest_pgd     = get_cr3;
+	g_context->get_guest_pgd     = get_guest_cr3;
 	g_context->get_pdptr         = kvm_pdptr_read;
 	g_context->inject_page_fault = kvm_inject_page_fault;
 
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index e5662dbd519c..78448fb84bd6 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -324,7 +324,7 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
 	trace_kvm_mmu_pagetable_walk(addr, access);
 retry_walk:
 	walker->level = mmu->cpu_role.base.level;
-	pte           = mmu->get_guest_pgd(vcpu);
+	pte           = kvm_mmu_get_guest_pgd(vcpu, mmu);
 	have_ad       = PT_HAVE_ACCESSED_DIRTY(mmu);
 
 #if PTTYPE == 64
-- 
2.39.0

