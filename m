Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B20F6369E44
	for <lists+kvm@lfdr.de>; Sat, 24 Apr 2021 02:56:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244209AbhDXA4y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Apr 2021 20:56:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244455AbhDXAzU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Apr 2021 20:55:20 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8506BC061244
        for <kvm@vger.kernel.org>; Fri, 23 Apr 2021 17:48:36 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id d89-20020a25a3620000b02904dc8d0450c6so26113060ybi.2
        for <kvm@vger.kernel.org>; Fri, 23 Apr 2021 17:48:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=R43ABUZ9/Fi53IKsY58euoL+dVYl7LoEC4YFNOGoqao=;
        b=gXjNOqK1L7vM4ncBy6xohX2vvBi4KwcgSkBOQa8L7aBPQfp16D1WJmCV/jdeojHOb3
         +DSylbvxS8KAgWscv86gsTLDKq3gjRiTy4ihusv4PEreJ42QGVxpCDxewRnMBBTJuBAy
         HFzGOqeuT3p+ktZJ6FljmDgd6X3hNhSgFY692LBEoiE4EsJmf2ceP9tNJ5CbIbmqHM9n
         KkFsE7lyGMYLmTWoYraea9HlpCHVi4V0P2ptJBwM9pft6TPEpT4kUgdOXrLEJJV/bIVA
         uYGiCZ1YyGIVzV5bglKD3vQhbGUIPZdbEMjV1hh4fEZgbJvuQwLIeQ/K6gRcPp5SLPPx
         1dvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=R43ABUZ9/Fi53IKsY58euoL+dVYl7LoEC4YFNOGoqao=;
        b=LG60DOB5Y9iwV2/rIrv/sU9x51/bYIH02Np3YO9O3vkQ2j4+pu+K6CxibOKe6ZkJkV
         660eCZIG0Mjw2Y5RosEAniE3J8tanTxGL5FyNJ/cj2+FYMSd9QVUzp//EmSROXao8kXo
         rT9igb+8MP4H4D9f0onGkWKSGFYpBDKHonZf6ZfJA/+KtRnee/CxoYUURoLQh0m7qwcE
         DK+BEkribQaySRqwIFF3DwOh9ESoYUDiNsZh8XDDqhzmpH4q1lQp3XijfncIvUOryNL2
         CRguGyYMro4ncA64SRlvuOD4daCgLwI8G1DkHzizRgiGRM4ZSqVSsOtiizWeaPdiIjK+
         Rw3Q==
X-Gm-Message-State: AOAM533tIQm6Kj4BKx4RXZgwD0jIjQeYzGHJ1fvDWOtrdJrXfuSUBU4C
        749beKx+Ez6TW7DFfCoEuFCPVn7V0yE=
X-Google-Smtp-Source: ABdhPJzPKy+rI/zbpn2Xldk6fWBp/khBlsJXC/ketf7A0l2T/NPalRCb7nmHR5GXqtN+0kehgINMCJzse5Q=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:ad52:3246:e190:f070])
 (user=seanjc job=sendgmr) by 2002:a25:840c:: with SMTP id u12mr9012245ybk.345.1619225315623;
 Fri, 23 Apr 2021 17:48:35 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 23 Apr 2021 17:46:45 -0700
In-Reply-To: <20210424004645.3950558-1-seanjc@google.com>
Message-Id: <20210424004645.3950558-44-seanjc@google.com>
Mime-Version: 1.0
References: <20210424004645.3950558-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.1.498.g6c1eba8ee3d-goog
Subject: [PATCH 43/43] KVM: x86: Drop pointless @reset_roots from kvm_init_mmu()
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Remove the @reset_roots param from kvm_init_mmu(), the one user,
kvm_mmu_reset_context() has already unloaded the MMU and thus freed and
invalidated all roots.  This also happens to be why the reset_roots=true
paths doesn't leak roots; they're already invalid.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu.h        |  2 +-
 arch/x86/kvm/mmu/mmu.c    | 13 ++-----------
 arch/x86/kvm/svm/nested.c |  2 +-
 arch/x86/kvm/vmx/nested.c |  2 +-
 4 files changed, 5 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 88d0ed5225a4..63b49725fb24 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -65,7 +65,7 @@ void kvm_mmu_set_ept_masks(bool has_ad_bits, bool has_exec_only);
 void
 reset_shadow_zero_bits_mask(struct kvm_vcpu *vcpu, struct kvm_mmu *context);
 
-void kvm_init_mmu(struct kvm_vcpu *vcpu, bool reset_roots);
+void kvm_init_mmu(struct kvm_vcpu *vcpu);
 void kvm_init_shadow_npt_mmu(struct kvm_vcpu *vcpu, u32 cr0, u32 cr4, u32 efer,
 			     gpa_t nested_cr3);
 void kvm_init_shadow_ept_mmu(struct kvm_vcpu *vcpu, bool execonly,
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 930ac8a7e7c9..ff3e200b32dd 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4793,17 +4793,8 @@ static void init_kvm_nested_mmu(struct kvm_vcpu *vcpu)
 	update_last_nonleaf_level(vcpu, g_context);
 }
 
-void kvm_init_mmu(struct kvm_vcpu *vcpu, bool reset_roots)
+void kvm_init_mmu(struct kvm_vcpu *vcpu)
 {
-	if (reset_roots) {
-		uint i;
-
-		vcpu->arch.mmu->root_hpa = INVALID_PAGE;
-
-		for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++)
-			vcpu->arch.mmu->prev_roots[i] = KVM_MMU_ROOT_INFO_INVALID;
-	}
-
 	if (mmu_is_nested(vcpu))
 		init_kvm_nested_mmu(vcpu);
 	else if (tdp_enabled)
@@ -4829,7 +4820,7 @@ kvm_mmu_calc_root_page_role(struct kvm_vcpu *vcpu)
 void kvm_mmu_reset_context(struct kvm_vcpu *vcpu)
 {
 	kvm_mmu_unload(vcpu);
-	kvm_init_mmu(vcpu, true);
+	kvm_init_mmu(vcpu);
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_reset_context);
 
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 540d43ba2cf4..a0b48a8f32ed 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -406,7 +406,7 @@ static int nested_svm_load_cr3(struct kvm_vcpu *vcpu, unsigned long cr3,
 	vcpu->arch.cr3 = cr3;
 	kvm_register_mark_available(vcpu, VCPU_EXREG_CR3);
 
-	kvm_init_mmu(vcpu, false);
+	kvm_init_mmu(vcpu);
 
 	return 0;
 }
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 9dcdf158a405..3a5b86932a5e 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -1137,7 +1137,7 @@ static int nested_vmx_load_cr3(struct kvm_vcpu *vcpu, unsigned long cr3, bool ne
 	vcpu->arch.cr3 = cr3;
 	kvm_register_mark_available(vcpu, VCPU_EXREG_CR3);
 
-	kvm_init_mmu(vcpu, false);
+	kvm_init_mmu(vcpu);
 
 	return 0;
 }
-- 
2.31.1.498.g6c1eba8ee3d-goog

