Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96CAA3B0C42
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 20:03:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232845AbhFVSFF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 14:05:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232418AbhFVSEf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Jun 2021 14:04:35 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC7D8C0698C6
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 10:59:23 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id e11-20020a17090a77cbb029016f97f61097so2552267pjs.6
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 10:59:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=sfaf2IGfGyV8jrRA1K16QS51TpLUBf3mITH/5zkyd+0=;
        b=lxl6gjgOp/QD3H2OOX2yInb7NSJjgsrk/Y9I/xjy8O4HDGKgy0mEDE+vH7bnThYWig
         j6UhcM9JxacEGJ+WNc7CIFvWoAvca91Ry+DPFv/ZaKa3MEOryFeDa4/65QrU2yypNRHq
         baLlrsoNicQgEHT/8Si19A5LBsoS3hm6HIGm2SrUvdhwU3guYCXKQyBlAAsKjwGwlkLY
         XTBnrEMt+d4Xy5CcBa0tvCIRnM/8I6A0NQN9XQ0KTTnNswSkDDC+G3Xermjf0nqhmuzY
         ktd+8gcLkIkslD8rjLXGVueyAm9yRav4ZQAW9M7idjJQuzGYiDeYWViQeuxZm4+5P8el
         sWfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=sfaf2IGfGyV8jrRA1K16QS51TpLUBf3mITH/5zkyd+0=;
        b=ALHpZwmfxAoJ79Xo5Oz7nvhQKD+oLYal6k9HyzgYdgZIkFAmtuW4A2pU34f/+eFqPZ
         93R/bQviWMsR7Ch90r3KuE7z2YwGmRTtPJCuhqsDXBqHjBpVfenEaaeiUnk4QzSE18Z9
         tife6Go/HASpJ7XZvm4R6O4LePNHWFGd2o19w0ROokmIm2GT6BPkCG3gE1fTkQdb5412
         fKfVjGJTIoCFW/YBX/hOBR+ROGitriqM6t9jKrsCMSIrWcb/o/VFqYV0kniqI791/4gu
         6ZDKVydh9xS55Ibj75t8HQL5/te8Q9qNOLDHSJsBhVn2E8HLKaOsRNF19xTQG2sNQPji
         s+/A==
X-Gm-Message-State: AOAM530tclAWnC/13prQhby+RaGWTvgmtn+p0oGVU8b94kt466DYitCv
        yeY6FXu6RNR1AMlFsdzgpQ2TAEKsMfo=
X-Google-Smtp-Source: ABdhPJyRq0HKb5yJuVL4wlclkhB7vNy+XVJbe26EkhATnU+3/hH4U/ach5cmsQ2beiHPijYkFaY++JH3IAU=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:5722:92ce:361f:3832])
 (user=seanjc job=sendgmr) by 2002:a62:2601:0:b029:300:bd5a:9268 with SMTP id
 m1-20020a6226010000b0290300bd5a9268mr4905343pfm.1.1624384763183; Tue, 22 Jun
 2021 10:59:23 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 22 Jun 2021 10:57:23 -0700
In-Reply-To: <20210622175739.3610207-1-seanjc@google.com>
Message-Id: <20210622175739.3610207-39-seanjc@google.com>
Mime-Version: 1.0
References: <20210622175739.3610207-1-seanjc@google.com>
X-Mailer: git-send-email 2.32.0.288.g62a8d224e6-goog
Subject: [PATCH 38/54] KVM: x86/mmu: Drop "nx" from MMU context now that there
 are no readers
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Drop kvm_mmu.nx as there no consumers left.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |  2 --
 arch/x86/kvm/mmu/mmu.c          | 17 -----------------
 2 files changed, 19 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 8aa798c75e9a..be7088fb0594 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -423,8 +423,6 @@ struct kvm_mmu {
 	/* Can have large pages at levels 2..last_nonleaf_level-1. */
 	u8 last_nonleaf_level;
 
-	bool nx;
-
 	u64 pdptrs[4]; /* pae */
 };
 
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index eb6386bcc2ef..6c4655c356b7 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -322,11 +322,6 @@ static int is_cpuid_PSE36(void)
 	return 1;
 }
 
-static int is_nx(struct kvm_vcpu *vcpu)
-{
-	return vcpu->arch.efer & EFER_NX;
-}
-
 static gfn_t pse36_gfn_delta(u32 gpte)
 {
 	int shift = 32 - PT32_DIR_PSE36_SHIFT - PAGE_SHIFT;
@@ -3956,7 +3951,6 @@ static void nonpaging_init_context(struct kvm_mmu *context)
 	context->invlpg = NULL;
 	context->root_level = 0;
 	context->direct_map = true;
-	context->nx = false;
 }
 
 static inline bool is_root_usable(struct kvm_mmu_root_info *root, gpa_t pgd,
@@ -4516,7 +4510,6 @@ static void update_last_nonleaf_level(struct kvm_mmu *mmu)
 static void paging64_init_context_common(struct kvm_mmu *context,
 					 int root_level)
 {
-	context->nx = is_efer_nx(context);
 	context->root_level = root_level;
 
 	WARN_ON_ONCE(!is_cr4_pae(context));
@@ -4538,7 +4531,6 @@ static void paging64_init_context(struct kvm_mmu *context,
 
 static void paging32_init_context(struct kvm_mmu *context)
 {
-	context->nx = false;
 	context->root_level = PT32_ROOT_LEVEL;
 	context->page_fault = paging32_page_fault;
 	context->gva_to_gpa = paging32_gva_to_gpa;
@@ -4640,22 +4632,18 @@ static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu)
 	context->inject_page_fault = kvm_inject_page_fault;
 
 	if (!is_paging(vcpu)) {
-		context->nx = false;
 		context->gva_to_gpa = nonpaging_gva_to_gpa;
 		context->root_level = 0;
 	} else if (is_long_mode(vcpu)) {
-		context->nx = is_nx(vcpu);
 		context->root_level = is_la57_mode(vcpu) ?
 				PT64_ROOT_5LEVEL : PT64_ROOT_4LEVEL;
 		reset_rsvds_bits_mask(vcpu, context);
 		context->gva_to_gpa = paging64_gva_to_gpa;
 	} else if (is_pae(vcpu)) {
-		context->nx = is_nx(vcpu);
 		context->root_level = PT32E_ROOT_LEVEL;
 		reset_rsvds_bits_mask(vcpu, context);
 		context->gva_to_gpa = paging64_gva_to_gpa;
 	} else {
-		context->nx = false;
 		context->root_level = PT32_ROOT_LEVEL;
 		reset_rsvds_bits_mask(vcpu, context);
 		context->gva_to_gpa = paging32_gva_to_gpa;
@@ -4818,7 +4806,6 @@ void kvm_init_shadow_ept_mmu(struct kvm_vcpu *vcpu, bool execonly,
 
 	context->shadow_root_level = level;
 
-	context->nx = true;
 	context->ept_ad = accessed_dirty;
 	context->page_fault = ept_page_fault;
 	context->gva_to_gpa = ept_gva_to_gpa;
@@ -4903,22 +4890,18 @@ static void init_kvm_nested_mmu(struct kvm_vcpu *vcpu)
 	 * the gva_to_gpa functions between mmu and nested_mmu are swapped.
 	 */
 	if (!is_paging(vcpu)) {
-		g_context->nx = false;
 		g_context->root_level = 0;
 		g_context->gva_to_gpa = nonpaging_gva_to_gpa_nested;
 	} else if (is_long_mode(vcpu)) {
-		g_context->nx = is_nx(vcpu);
 		g_context->root_level = is_la57_mode(vcpu) ?
 					PT64_ROOT_5LEVEL : PT64_ROOT_4LEVEL;
 		reset_rsvds_bits_mask(vcpu, g_context);
 		g_context->gva_to_gpa = paging64_gva_to_gpa_nested;
 	} else if (is_pae(vcpu)) {
-		g_context->nx = is_nx(vcpu);
 		g_context->root_level = PT32E_ROOT_LEVEL;
 		reset_rsvds_bits_mask(vcpu, g_context);
 		g_context->gva_to_gpa = paging64_gva_to_gpa_nested;
 	} else {
-		g_context->nx = false;
 		g_context->root_level = PT32_ROOT_LEVEL;
 		reset_rsvds_bits_mask(vcpu, g_context);
 		g_context->gva_to_gpa = paging32_gva_to_gpa_nested;
-- 
2.32.0.288.g62a8d224e6-goog

