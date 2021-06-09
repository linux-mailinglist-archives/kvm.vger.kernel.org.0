Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FCA93A20FC
	for <lists+kvm@lfdr.de>; Thu, 10 Jun 2021 01:44:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230344AbhFIXqC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Jun 2021 19:46:02 -0400
Received: from mail-yb1-f202.google.com ([209.85.219.202]:54856 "EHLO
        mail-yb1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230370AbhFIXp7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Jun 2021 19:45:59 -0400
Received: by mail-yb1-f202.google.com with SMTP id n129-20020a2527870000b02904ed02e1aab5so33463915ybn.21
        for <kvm@vger.kernel.org>; Wed, 09 Jun 2021 16:44:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=OUQR2M6ORqp4R4Q1XNMmsY3Jpp0VsWP0Wlsf/XP786M=;
        b=e573bk0IhJWH1KrhuNXg6S0B40xlHphSQjHX5zez/NH5JKvS0U3LKHjxi/W9ZTj/iX
         Djq6KWyvSQXrTczghntGdbOzeGs+E9PeM3yRyExQxONDN/xpYJQCOI24BG49/qXGrRYs
         4WgaxK/lGhTaZZ4dcwZvjnV2o8Jwi1ZOR/GZiN52WW+UD23ESJIZDl3IN6JMWwS062Q4
         ll9U61n+qf8cpAMoY5VqAiJ+kZKXx2egKGOC3s21sz+/YDofPbZG0npmdP/uNxAvnwgb
         PzIK200AyWJhul+KIPaP6FJQwpBzFfv9oVcotyAPAH0SXPpRCUzy0XIeOaOq8qw11fZw
         uENw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=OUQR2M6ORqp4R4Q1XNMmsY3Jpp0VsWP0Wlsf/XP786M=;
        b=GmZQ3OtsUXsfCA2ebeYBCN0tgrPaKf5VFrt8OJmS91uPh0ptMEmJbvlpWyZWaGPIWX
         Ey4ozj/mgj1OnoI+ee4OKTcp20Um185lx9iot7tOA7yCPIgRBnj8qVm1oIl9G8U+135S
         +dCgG16gAlScwWsHkJBsjRAqKwnaiZBMWlfYt8Fmh5w8fhIT0o6WsYG+nk0EiuCWO/sh
         ZUV9/NLhIp3EP3nxv4FmBD7rpUshG6VcNQPNUjffGT1I5wiOurDMzVz8RvG5dlj0mdT8
         gxN03OgVi/LA0lmACgGhYzw02o6rKypXxA3CHKsNMt54d6JauJ4hYM6MVY6STXs95bBC
         i6JA==
X-Gm-Message-State: AOAM531kfON2uJVArAOX1KAG/xbE5Fbqo2R63pboz68XjaqmA9lQKzJt
        gdgqsyF8RRVB6w1ZpwmIo7kAMnPX0cQ=
X-Google-Smtp-Source: ABdhPJxQ9nCGPraYT+eSs9eaqwy1FxGg/921tA/4pDpTqwKUUebnfytfLTqxWPsgFjSVFeHSWQcbdkxv3GM=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:8daf:e5e:ae50:4f28])
 (user=seanjc job=sendgmr) by 2002:a25:c7c1:: with SMTP id w184mr3529192ybe.204.1623282183334;
 Wed, 09 Jun 2021 16:43:03 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  9 Jun 2021 16:42:29 -0700
In-Reply-To: <20210609234235.1244004-1-seanjc@google.com>
Message-Id: <20210609234235.1244004-10-seanjc@google.com>
Mime-Version: 1.0
References: <20210609234235.1244004-1-seanjc@google.com>
X-Mailer: git-send-email 2.32.0.rc1.229.g3e70b5a671-goog
Subject: [PATCH 09/15] KVM: nVMX: Free only guest_mode (L2) roots on INVVPID
 w/o EPT
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Junaid Shahid <junaids@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Lai Jiangshan <laijs@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When emulating INVVPID for L1, free only L2+ roots, using the guest_mode
tag in the MMU role to identify L2+ roots.  From L1's perspective, its
own TLB entries use VPID=0, and INVVPID is not requied to invalidate such
entries.  Per Intel's SDM, INVVPID _may_ invalidate entries with VPID=0,
but it is not required to do so.

Cc: Lai Jiangshan <laijs@linux.alibaba.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/mmu/mmu.c          | 27 +++++++++++++++++++++++++++
 arch/x86/kvm/vmx/nested.c       |  7 +++----
 3 files changed, 31 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index c05448d3beff..05c5ca047c53 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1650,6 +1650,7 @@ int kvm_mmu_unprotect_page(struct kvm *kvm, gfn_t gfn);
 void __kvm_mmu_free_some_pages(struct kvm_vcpu *vcpu);
 void kvm_mmu_free_roots(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 			ulong roots_to_free);
+void kvm_mmu_free_guest_mode_roots(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu);
 gpa_t translate_nested_gpa(struct kvm_vcpu *vcpu, gpa_t gpa, u32 access,
 			   struct x86_exception *exception);
 gpa_t kvm_mmu_gva_to_gpa_read(struct kvm_vcpu *vcpu, gva_t gva,
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index a832e0fedf32..f987f2ea4a01 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3180,6 +3180,33 @@ void kvm_mmu_free_roots(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_free_roots);
 
+void kvm_mmu_free_guest_mode_roots(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu)
+{
+	unsigned long roots_to_free = 0;
+	hpa_t root_hpa;
+	int i;
+
+	/*
+	 * This should not be called while L2 is active, L2 can't invalidate
+	 * _only_ its own roots, e.g. INVVPID unconditionally exits.
+	 */
+	WARN_ON_ONCE(mmu->mmu_role.base.guest_mode);
+
+	for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++) {
+		root_hpa = mmu->prev_roots[i].hpa;
+		if (!VALID_PAGE(root_hpa))
+			continue;
+
+		if (!to_shadow_page(root_hpa) ||
+			to_shadow_page(root_hpa)->role.guest_mode)
+			roots_to_free |= KVM_MMU_ROOT_PREVIOUS(i);
+	}
+
+	kvm_mmu_free_roots(vcpu, mmu, roots_to_free);
+}
+EXPORT_SYMBOL_GPL(kvm_mmu_free_guest_mode_roots);
+
+
 static int mmu_check_root(struct kvm_vcpu *vcpu, gfn_t root_gfn)
 {
 	int ret = 0;
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 6d7c368c92e7..2a881afc1fd0 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -5423,8 +5423,8 @@ static int handle_invvpid(struct kvm_vcpu *vcpu)
 
 	/*
 	 * Sync the shadow page tables if EPT is disabled, L1 is invalidating
-	 * linear mappings for L2 (tagged with L2's VPID).  Free all roots as
-	 * VPIDs are not tracked in the MMU role.
+	 * linear mappings for L2 (tagged with L2's VPID).  Free all guest
+	 * roots as VPIDs are not tracked in the MMU role.
 	 *
 	 * Note, this operates on root_mmu, not guest_mmu, as L1 and L2 share
 	 * an MMU when EPT is disabled.
@@ -5432,8 +5432,7 @@ static int handle_invvpid(struct kvm_vcpu *vcpu)
 	 * TODO: sync only the affected SPTEs for INVDIVIDUAL_ADDR.
 	 */
 	if (!enable_ept)
-		kvm_mmu_free_roots(vcpu, &vcpu->arch.root_mmu,
-				   KVM_MMU_ROOTS_ALL);
+		kvm_mmu_free_guest_mode_roots(vcpu, &vcpu->arch.root_mmu);
 
 	return nested_vmx_succeed(vcpu);
 }
-- 
2.32.0.rc1.229.g3e70b5a671-goog

