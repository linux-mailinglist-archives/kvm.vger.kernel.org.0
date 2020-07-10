Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E651421B7EF
	for <lists+kvm@lfdr.de>; Fri, 10 Jul 2020 16:12:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728146AbgGJOMN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jul 2020 10:12:13 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:20074 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726496AbgGJOML (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jul 2020 10:12:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594390329;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vHoUdqcWmCYR4qi3PrugHYTP3M3+EpRb12azAQ/0uIU=;
        b=GQc5MiPaICaz6vu2vP3fDJIAtegwNEGHc1SzY4Odzl1Si5V77c7Hy2ERNAjGMMFHHa6tII
        Q31VpUMUwLPSfvVZ6fByK5nkFU1y7Xv3b2aPkKkCgf1Ej+llAXF3Rb8Y+LjdxglIe1REB0
        b5Y0L2dETlN0eGof216UvvF/IEeY/KA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-36-D9o55wPwNruu77r6tc_XZA-1; Fri, 10 Jul 2020 10:12:07 -0400
X-MC-Unique: D9o55wPwNruu77r6tc_XZA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 928F5100CCC2;
        Fri, 10 Jul 2020 14:12:06 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.35])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 642C774F52;
        Fri, 10 Jul 2020 14:12:04 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Junaid Shahid <junaids@google.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 2/9] KVM: MMU: stop dereferencing vcpu->arch.mmu to get the context for MMU init
Date:   Fri, 10 Jul 2020 16:11:50 +0200
Message-Id: <20200710141157.1640173-3-vkuznets@redhat.com>
In-Reply-To: <20200710141157.1640173-1-vkuznets@redhat.com>
References: <20200710141157.1640173-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

kvm_init_shadow_mmu() was actually the only function that could be called
with different vcpu->arch.mmu values.  Now that kvm_init_shadow_npt_mmu()
is separated from kvm_init_shadow_mmu(), we always know the MMU context
we need to use and there is no need to dereference vcpu->arch.mmu pointer.

Based on a patch by Vitaly Kuznetsov <vkuznets@redhat.com>.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 93f18e5fa8b5..3a306ab1a9c9 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4884,7 +4884,7 @@ kvm_calc_tdp_mmu_root_page_role(struct kvm_vcpu *vcpu, bool base_only)
 
 static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu)
 {
-	struct kvm_mmu *context = vcpu->arch.mmu;
+	struct kvm_mmu *context = &vcpu->arch.root_mmu;
 	union kvm_mmu_role new_role =
 		kvm_calc_tdp_mmu_root_page_role(vcpu, false);
 
@@ -4952,11 +4952,10 @@ kvm_calc_shadow_mmu_root_page_role(struct kvm_vcpu *vcpu, bool base_only)
 	return role;
 }
 
-static void shadow_mmu_init_context(struct kvm_vcpu *vcpu, u32 cr0, u32 cr4,
-				    u32 efer, union kvm_mmu_role new_role)
+static void shadow_mmu_init_context(struct kvm_vcpu *vcpu, struct kvm_mmu *context,
+				    u32 cr0, u32 cr4, u32 efer,
+				    union kvm_mmu_role new_role)
 {
-	struct kvm_mmu *context = vcpu->arch.mmu;
-
 	if (!(cr0 & X86_CR0_PG))
 		nonpaging_init_context(vcpu, context);
 	else if (efer & EFER_LMA)
@@ -4972,23 +4971,23 @@ static void shadow_mmu_init_context(struct kvm_vcpu *vcpu, u32 cr0, u32 cr4,
 
 static void kvm_init_shadow_mmu(struct kvm_vcpu *vcpu, u32 cr0, u32 cr4, u32 efer)
 {
-	struct kvm_mmu *context = vcpu->arch.mmu;
+	struct kvm_mmu *context = &vcpu->arch.root_mmu;
 	union kvm_mmu_role new_role =
 		kvm_calc_shadow_mmu_root_page_role(vcpu, false);
 
 	if (new_role.as_u64 != context->mmu_role.as_u64)
-		shadow_mmu_init_context(vcpu, cr0, cr4, efer, new_role);
+		shadow_mmu_init_context(vcpu, context, cr0, cr4, efer, new_role);
 }
 
 void kvm_init_shadow_npt_mmu(struct kvm_vcpu *vcpu, u32 cr0, u32 cr4, u32 efer,
 			     gpa_t nested_cr3)
 {
-	struct kvm_mmu *context = vcpu->arch.mmu;
+	struct kvm_mmu *context = &vcpu->arch.guest_mmu;
 	union kvm_mmu_role new_role =
 		kvm_calc_shadow_mmu_root_page_role(vcpu, false);
 
 	if (new_role.as_u64 != context->mmu_role.as_u64)
-		shadow_mmu_init_context(vcpu, cr0, cr4, efer, new_role);
+		shadow_mmu_init_context(vcpu, context, cr0, cr4, efer, new_role);
 }
 EXPORT_SYMBOL_GPL(kvm_init_shadow_npt_mmu);
 
@@ -5024,7 +5023,7 @@ kvm_calc_shadow_ept_root_page_role(struct kvm_vcpu *vcpu, bool accessed_dirty,
 void kvm_init_shadow_ept_mmu(struct kvm_vcpu *vcpu, bool execonly,
 			     bool accessed_dirty, gpa_t new_eptp)
 {
-	struct kvm_mmu *context = vcpu->arch.mmu;
+	struct kvm_mmu *context = &vcpu->arch.guest_mmu;
 	u8 level = vmx_eptp_page_walk_level(new_eptp);
 	union kvm_mmu_role new_role =
 		kvm_calc_shadow_ept_root_page_role(vcpu, accessed_dirty,
@@ -5058,7 +5057,7 @@ EXPORT_SYMBOL_GPL(kvm_init_shadow_ept_mmu);
 
 static void init_kvm_softmmu(struct kvm_vcpu *vcpu)
 {
-	struct kvm_mmu *context = vcpu->arch.mmu;
+	struct kvm_mmu *context = &vcpu->arch.root_mmu;
 
 	kvm_init_shadow_mmu(vcpu,
 			    kvm_read_cr0_bits(vcpu, X86_CR0_PG),
-- 
2.25.4

