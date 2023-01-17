Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F974670B81
	for <lists+kvm@lfdr.de>; Tue, 17 Jan 2023 23:15:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229680AbjAQWOl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Jan 2023 17:14:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230051AbjAQWOF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Jan 2023 17:14:05 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA38447EEB
        for <kvm@vger.kernel.org>; Tue, 17 Jan 2023 12:44:31 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id az20so59167644ejc.1
        for <kvm@vger.kernel.org>; Tue, 17 Jan 2023 12:44:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=joD6UNobMMls+6tKVhM1/laXbk6jjwsQnCEiOHpSVIA=;
        b=uNJwbBkZ2OYvc+3MK2JpuwUBcUSsXIPchhZmTbZfiIf3phVjJD2exKjZz1S87BXs/v
         qAu1ZV7HUlvWm7k4NFwXRXrvKfHN4EU/QEg8qUOC0MPTKTww5t/xI44WhL/R6s0+nMow
         DcAJ3cYBieTKHWHMT1tL92A5pXDYYFPpUdYhbmBocgdmE+4HZnPiRyXK6dLY08LZqRJk
         PvS9BHFUEbUQKq7QG5+SPL6O4xCxLw6m8Yjs5u1HqaqDFn2T4Nh4LZq6x9LsLJ7JbF9f
         OV4sIP+RbjYVcNyJL7oJ2izf/kCSjgKIBlU9HUmutuk43eplU+CEe96XRD5qFqrE7rWJ
         6yWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=joD6UNobMMls+6tKVhM1/laXbk6jjwsQnCEiOHpSVIA=;
        b=E4wY/J9EBg98BXPyS0d13U7udC/X2RzyDm8WzsEpQIaq9d2pry543pf1XXdsKNpCSJ
         k1EzeMfhfUoTs3vcrg/VVV3Lzq9aEYJpMmCHfK1ib4bBY8EfkNuOCErH9vE1WDWHraUL
         56mONxvkS3cRwc5heYwbP49Sm2OnozuQ8rOSDbSLG3wWrzk45wAzNgrtnU4MZPkwES4j
         DfFoQIgcV36fFpdzqfo80+gRjkucUKRgC/18OL/XNayT1ZjaC9y0zZJwpri1+2seZJu5
         TngCczxDI7doz+u4BDpn6poKLQQnm7uoVjcSP2vz5CEC/NWGRJXRPU+cLr3f7TcFJ65X
         GGZg==
X-Gm-Message-State: AFqh2krrOtPWIdQCnpcdHsgmZpSN6fxqh8dR7hqsw0Mi+vBFynoF/8XF
        x8dvxwbVA4uEN4nWIcWaOfNz7q2eG0wUa/uM4hY=
X-Google-Smtp-Source: AMrXdXvdqRpWYkx5fV5QmNteGDEyAGWOxNgAqXU1sQpZsIja/afYqaJkC/B6S7veK3AjzZdSNSurMQ==
X-Received: by 2002:a17:906:5da8:b0:7b2:c227:126d with SMTP id n8-20020a1709065da800b007b2c227126dmr472951ejv.20.1673988269748;
        Tue, 17 Jan 2023 12:44:29 -0800 (PST)
Received: from nuc.fritz.box (p200300f6af098f00245ad18781b5e181.dip0.t-ipconnect.de. [2003:f6:af09:8f00:245a:d187:81b5:e181])
        by smtp.gmail.com with ESMTPSA id k2-20020a170906970200b0073dbaeb50f6sm13477051ejx.169.2023.01.17.12.44.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jan 2023 12:44:29 -0800 (PST)
From:   Mathias Krause <minipli@grsecurity.net>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Mathias Krause <minipli@grsecurity.net>
Subject: [PATCH 1/3] KVM: x86/mmu: avoid indirect call for get_cr3
Date:   Tue, 17 Jan 2023 21:45:54 +0100
Message-Id: <20230117204556.16217-2-minipli@grsecurity.net>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230117204556.16217-1-minipli@grsecurity.net>
References: <20230117204556.16217-1-minipli@grsecurity.net>
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

