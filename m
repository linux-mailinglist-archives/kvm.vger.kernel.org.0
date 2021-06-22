Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F40D83B0C09
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 19:59:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232767AbhFVSBW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 14:01:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232476AbhFVSA5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Jun 2021 14:00:57 -0400
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 162CDC061768
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 10:58:29 -0700 (PDT)
Received: by mail-qt1-x849.google.com with SMTP id a5-20020ac84d850000b029024998e61d00so58177qtw.14
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 10:58:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=uTc90HlRvNxV1/4nXHcBOYKgMxpy+5jWYh9NNDOLUD8=;
        b=d+4QRZf2vjtSjIFvpLRxJyq+dSUFgq6Q8H3Ui2TPuYfKcaQ4aO/f8HzfxE1XLHpECC
         RVLzWUw9ClVb1VymCJcIDfXB0aAHSz2Hh4MYq8HH4wO/32Ja0wDmwv/N4vf/CqPjRnbF
         MNwJ58W59X7x9Bs7iIX5xY7dHkHdw0adBZt9QO1CrZA10I8shjlrn4qUiBMxTyfKXtSH
         U5Vz1y4jHLB6ETlMlq3gGjQSkMNo/tvEjhEBu0zno2JlILBXGhQ7ycfY2UhxvvI/7EBN
         yFpOqz/76Pp0KqtTavVjUFuGCN2rW96/Lrl5KzBIRg2X4H9MGtfjCRq1y38XPev8F6qT
         l5LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=uTc90HlRvNxV1/4nXHcBOYKgMxpy+5jWYh9NNDOLUD8=;
        b=Ox6zIpueAz0xnpTkyMIb6R0WOmxxucGy4DySetkiuYEE7FZHIt0Sjqjmmmj4QNiG99
         9uyLP3Va7pf8hdxGs3yeHDcSHJezXVri324jvaG5hwTynMF8MPyoFUP/nk17D3t13ejD
         DUU+Mm2Su7qu2ot4X6NS8KqBor9thEy1PCfQId/02OZ6sUXxjTinDSA/6jbACCcRp89A
         Saum849Jz9i2j/ZpST/uEsCUXAd0dF4GTSSrDO5nl68E71wrFUvcay0sTP1NedRMtsca
         hYEu7UHwszoChjD8nD8p67h5tVorFUt43yh96SfyObnDeq59QqhBhyR08hQvjH8im625
         JztQ==
X-Gm-Message-State: AOAM532Fb6i+tpiIfbER3Y3Xo83ORk6FAeD09QUR+eL142LNrTIsGlVO
        bqsbj9ApbPBa8OWY3BbKooQjjMIx8lA=
X-Google-Smtp-Source: ABdhPJz2LE0P39MT7JrSChNHGeZB/3WIosyg/xkSg5rQgJuK+6VHqX2zw2HqTGfq4giguLjPphzSkycR2Ac=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:5722:92ce:361f:3832])
 (user=seanjc job=sendgmr) by 2002:a25:11c2:: with SMTP id 185mr6652606ybr.101.1624384708229;
 Tue, 22 Jun 2021 10:58:28 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 22 Jun 2021 10:56:59 -0700
In-Reply-To: <20210622175739.3610207-1-seanjc@google.com>
Message-Id: <20210622175739.3610207-15-seanjc@google.com>
Mime-Version: 1.0
References: <20210622175739.3610207-1-seanjc@google.com>
X-Mailer: git-send-email 2.32.0.288.g62a8d224e6-goog
Subject: [PATCH 14/54] KVM: x86: Fix sizes used to pass around CR0, CR4, and EFER
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

When configuring KVM's MMU, pass CR0 and CR4 as unsigned longs, and EFER
as a u64 in various flows (mostly MMU).  Passing the params as u32s is
functionally ok since all of the affected registers reserve bits 63:32 to
zero (enforced by KVM), but it's technically wrong.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu.h        |  4 ++--
 arch/x86/kvm/mmu/mmu.c    | 11 ++++++-----
 arch/x86/kvm/svm/nested.c |  2 +-
 arch/x86/kvm/x86.c        |  2 +-
 4 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index bc11402df83b..47131b92b990 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -66,8 +66,8 @@ void
 reset_shadow_zero_bits_mask(struct kvm_vcpu *vcpu, struct kvm_mmu *context);
 
 void kvm_init_mmu(struct kvm_vcpu *vcpu);
-void kvm_init_shadow_npt_mmu(struct kvm_vcpu *vcpu, u32 cr0, u32 cr4, u32 efer,
-			     gpa_t nested_cr3);
+void kvm_init_shadow_npt_mmu(struct kvm_vcpu *vcpu, unsigned long cr0,
+			     unsigned long cr4, u64 efer, gpa_t nested_cr3);
 void kvm_init_shadow_ept_mmu(struct kvm_vcpu *vcpu, bool execonly,
 			     bool accessed_dirty, gpa_t new_eptp);
 bool kvm_can_do_async_pf(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 0171c245ecc7..96c16a6e0044 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4659,8 +4659,8 @@ kvm_calc_shadow_mmu_root_page_role(struct kvm_vcpu *vcpu, bool base_only)
 }
 
 static void shadow_mmu_init_context(struct kvm_vcpu *vcpu, struct kvm_mmu *context,
-				    u32 cr0, u32 cr4, u32 efer,
-				    union kvm_mmu_role new_role)
+				    unsigned long cr0, unsigned long cr4,
+				    u64 efer, union kvm_mmu_role new_role)
 {
 	if (!(cr0 & X86_CR0_PG))
 		nonpaging_init_context(vcpu, context);
@@ -4675,7 +4675,8 @@ static void shadow_mmu_init_context(struct kvm_vcpu *vcpu, struct kvm_mmu *conte
 	reset_shadow_zero_bits_mask(vcpu, context);
 }
 
-static void kvm_init_shadow_mmu(struct kvm_vcpu *vcpu, u32 cr0, u32 cr4, u32 efer)
+static void kvm_init_shadow_mmu(struct kvm_vcpu *vcpu, unsigned long cr0,
+				unsigned long cr4, u64 efer)
 {
 	struct kvm_mmu *context = &vcpu->arch.root_mmu;
 	union kvm_mmu_role new_role =
@@ -4697,8 +4698,8 @@ kvm_calc_shadow_npt_root_page_role(struct kvm_vcpu *vcpu)
 	return role;
 }
 
-void kvm_init_shadow_npt_mmu(struct kvm_vcpu *vcpu, u32 cr0, u32 cr4, u32 efer,
-			     gpa_t nested_cr3)
+void kvm_init_shadow_npt_mmu(struct kvm_vcpu *vcpu, unsigned long cr0,
+			     unsigned long cr4, u64 efer, gpa_t nested_cr3)
 {
 	struct kvm_mmu *context = &vcpu->arch.guest_mmu;
 	union kvm_mmu_role new_role = kvm_calc_shadow_npt_root_page_role(vcpu);
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index dca20f949b63..9f0e7ed672b2 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1244,8 +1244,8 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 		&user_kvm_nested_state->data.svm[0];
 	struct vmcb_control_area *ctl;
 	struct vmcb_save_area *save;
+	unsigned long cr0;
 	int ret;
-	u32 cr0;
 
 	BUILD_BUG_ON(sizeof(struct vmcb_control_area) + sizeof(struct vmcb_save_area) >
 		     KVM_STATE_NESTED_SVM_VMCB_SIZE);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 92b4a9305651..2d3b9f10b14a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9076,8 +9076,8 @@ static void enter_smm(struct kvm_vcpu *vcpu)
 {
 	struct kvm_segment cs, ds;
 	struct desc_ptr dt;
+	unsigned long cr0;
 	char buf[512];
-	u32 cr0;
 
 	memset(buf, 0, 512);
 #ifdef CONFIG_X86_64
-- 
2.32.0.288.g62a8d224e6-goog

