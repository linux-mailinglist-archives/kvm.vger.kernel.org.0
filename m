Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3E4F70090A
	for <lists+kvm@lfdr.de>; Fri, 12 May 2023 15:20:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241174AbjELNUq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 May 2023 09:20:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240871AbjELNUm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 May 2023 09:20:42 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31EAEE72
        for <kvm@vger.kernel.org>; Fri, 12 May 2023 06:20:41 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id a640c23a62f3a-965fc25f009so1526961666b.3
        for <kvm@vger.kernel.org>; Fri, 12 May 2023 06:20:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1683897639; x=1686489639;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Qa8LWCnpnjsYiqtvKVSJdNLhlbxO/kudwlUnqlbTiAY=;
        b=Ddi1mJsYxyPgJ9MOFOIUY+tLhU8bv6TWfJe5fSq3tciDpFlLjNlbXydgtQYddAg5RV
         C5Quxc5YI+X+yDeNllZzwhUcDvihmkOX7zbqPWoB97Al/kk1Jhgwf1fdZml2XrUMa9Z8
         BgP7+UVz22QO9k9GxyxsWY96ttQkiUPxNV2XGnuz8lpR02mFZWvJohAcp92U2XCBtsxe
         oeWFvFxZr/0FLJAUO3HcC7w0yaQku5YjcCZ3m43anrv/vWhxr9aFoMKshb4XtEKSxuLH
         619ccjq0P5Wg1yTGzuwdnZEcHz7mZ5ljSyrTUq77zJEDKDGZ8RJD5/sNKgDAkwpRZUQ/
         C9Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683897639; x=1686489639;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Qa8LWCnpnjsYiqtvKVSJdNLhlbxO/kudwlUnqlbTiAY=;
        b=KnmB2/f8P7qZ855m07HqhT6Cb2LF2BENZ71oHz0BIFmTb6kaZQw3IfTvn5WtErt8c9
         NOP5Isg9sdKVAe9bAdKy1+r0MTBRIMCQhAMnXyY4+OXYdbmi1nn/rXmPGqV98KSLG9ug
         LUGY4L/di4HdzPL1w+yerxdoZ4Z78jiN0B/IfKaqEiw7WbYXxarFqOHr5ElIpQBzUwCw
         Yux7e7jqfKU94fyvNGu0m3dOqAiwVo0EM3KWWZ6AB2qrtaz3+px4e2shL+TNVSRa1T9C
         yh8k1PEbYF81G7Q3h+egcH5wxvAbQXILcph8zg26YXaGsavk+47ao4Ap7n9ItiqetzUI
         HwWA==
X-Gm-Message-State: AC+VfDyOWpo1NPQK9CUa+yVjithkHOyhCYQCyRupmdYN4hYuBa5mr3a7
        od8eepMyDmdj2KTZGwK2w5VLYZaYvL/oBMUF5hs=
X-Google-Smtp-Source: ACHHUZ4+gIHhXtbr3PVxk8DkcxbldJwX8tJ9ACY7/rrBQUFCyrEBrUWF9BrQa+ISOCpwSdqsfY9iOA==
X-Received: by 2002:a17:907:3e9c:b0:966:471c:2565 with SMTP id hs28-20020a1709073e9c00b00966471c2565mr19629938ejc.48.1683897639582;
        Fri, 12 May 2023 06:20:39 -0700 (PDT)
Received: from nuc.fritz.box (p200300f6af43a100a78da3f586d44204.dip0.t-ipconnect.de. [2003:f6:af43:a100:a78d:a3f5:86d4:4204])
        by smtp.gmail.com with ESMTPSA id w21-20020a170907271500b00969dfd160aesm5077981ejk.109.2023.05.12.06.20.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 May 2023 06:20:39 -0700 (PDT)
From:   Mathias Krause <minipli@grsecurity.net>
To:     stable@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        Mathias Krause <minipli@grsecurity.net>
Subject: [PATCH 6.3 1/5] KVM: x86/mmu: Avoid indirect call for get_cr3
Date:   Fri, 12 May 2023 15:20:20 +0200
Message-Id: <20230512132024.4029-2-minipli@grsecurity.net>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230512132024.4029-1-minipli@grsecurity.net>
References: <20230512132024.4029-1-minipli@grsecurity.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
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
Signed-off-by: Mathias Krause <minipli@grsecurity.net>	# backport to v6.3.x
---
 arch/x86/kvm/mmu/mmu.c         | 31 ++++++++++++++++++++-----------
 arch/x86/kvm/mmu/paging_tmpl.h |  2 +-
 2 files changed, 21 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index c8ebe542c565..18c0deeaa2ec 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -242,6 +242,20 @@ static struct kvm_mmu_role_regs vcpu_to_role_regs(struct kvm_vcpu *vcpu)
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
@@ -3731,7 +3745,7 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 	int quadrant, i, r;
 	hpa_t root;
 
-	root_pgd = mmu->get_guest_pgd(vcpu);
+	root_pgd = kvm_mmu_get_guest_pgd(vcpu, mmu);
 	root_gfn = root_pgd >> PAGE_SHIFT;
 
 	if (mmu_check_root(vcpu, root_gfn))
@@ -4181,7 +4195,7 @@ static bool kvm_arch_setup_async_pf(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 	arch.token = alloc_apf_token(vcpu);
 	arch.gfn = gfn;
 	arch.direct_map = vcpu->arch.mmu->root_role.direct;
-	arch.cr3 = vcpu->arch.mmu->get_guest_pgd(vcpu);
+	arch.cr3 = kvm_mmu_get_guest_pgd(vcpu, vcpu->arch.mmu);
 
 	return kvm_setup_async_pf(vcpu, cr2_or_gpa,
 				  kvm_vcpu_gfn_to_hva(vcpu, gfn), &arch);
@@ -4200,7 +4214,7 @@ void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu, struct kvm_async_pf *work)
 		return;
 
 	if (!vcpu->arch.mmu->root_role.direct &&
-	      work->arch.cr3 != vcpu->arch.mmu->get_guest_pgd(vcpu))
+	      work->arch.cr3 != kvm_mmu_get_guest_pgd(vcpu, vcpu->arch.mmu))
 		return;
 
 	kvm_mmu_do_page_fault(vcpu, work->cr2_or_gpa, 0, true);
@@ -4604,11 +4618,6 @@ void kvm_mmu_new_pgd(struct kvm_vcpu *vcpu, gpa_t new_pgd)
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
@@ -5159,7 +5168,7 @@ static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu,
 	context->page_fault = kvm_tdp_page_fault;
 	context->sync_page = nonpaging_sync_page;
 	context->invlpg = NULL;
-	context->get_guest_pgd = get_cr3;
+	context->get_guest_pgd = get_guest_cr3;
 	context->get_pdptr = kvm_pdptr_read;
 	context->inject_page_fault = kvm_inject_page_fault;
 
@@ -5309,7 +5318,7 @@ static void init_kvm_softmmu(struct kvm_vcpu *vcpu,
 
 	kvm_init_shadow_mmu(vcpu, cpu_role);
 
-	context->get_guest_pgd     = get_cr3;
+	context->get_guest_pgd     = get_guest_cr3;
 	context->get_pdptr         = kvm_pdptr_read;
 	context->inject_page_fault = kvm_inject_page_fault;
 }
@@ -5323,7 +5332,7 @@ static void init_kvm_nested_mmu(struct kvm_vcpu *vcpu,
 		return;
 
 	g_context->cpu_role.as_u64   = new_mode.as_u64;
-	g_context->get_guest_pgd     = get_cr3;
+	g_context->get_guest_pgd     = get_guest_cr3;
 	g_context->get_pdptr         = kvm_pdptr_read;
 	g_context->inject_page_fault = kvm_inject_page_fault;
 
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 57f0b75c80f9..2ea2861bbb3c 100644
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
2.39.2

