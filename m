Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3D5E3ED86B
	for <lists+kvm@lfdr.de>; Mon, 16 Aug 2021 16:01:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236532AbhHPOBO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Aug 2021 10:01:14 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:28817 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231271AbhHPN70 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 16 Aug 2021 09:59:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629122277;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=j3zwB4umWAR5hgPMKgLnLcK8o/PyyPVw/5nTJsz9JWI=;
        b=ZDjmwmZplFf4ruViOoNLpmkt7RY1Daa90nVAw8fLnB+d4rnvWN41r17K2puMl6939zc3gG
        EuQJQfBSlkoC77f5VRr92SbcjWfqYjsUmnGsN6nFHJdyjrDy6z2sU5Bdq8Ykykxe7GESX5
        xxF/q7XCeF/tHNXFY1ELt0lev4dQcXc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-364-2IeNXc24MkKbo03U-WeXhQ-1; Mon, 16 Aug 2021 09:57:34 -0400
X-MC-Unique: 2IeNXc24MkKbo03U-WeXhQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 85C83801AEB;
        Mon, 16 Aug 2021 13:57:33 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 05F9D60916;
        Mon, 16 Aug 2021 13:57:32 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com, Maxim Levitsky <mlevitsk@redhat.com>
Subject: [FYI PATCH] KVM: nSVM: avoid picking up unsupported bits from L2 in int_ctl (CVE-2021-3653)
Date:   Mon, 16 Aug 2021 09:57:31 -0400
Message-Id: <20210816135732.3836586-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Maxim Levitsky <mlevitsk@redhat.com>

* Invert the mask of bits that we pick from L2 in
  nested_vmcb02_prepare_control

* Invert and explicitly use VIRQ related bits bitmask in svm_clear_vintr

This fixes a security issue that allowed a malicious L1 to run L2 with
AVIC enabled, which allowed the L2 to exploit the uninitialized and enabled
AVIC to read/write the host physical memory at some offsets.

Fixes: 3d6368ef580a ("KVM: SVM: Add VMRUN handler")
Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/svm.h |  2 ++
 arch/x86/kvm/svm/nested.c  | 10 +++++++---
 arch/x86/kvm/svm/svm.c     |  9 +++++----
 3 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index e322676039f4..b00dbc5fac2b 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -184,6 +184,8 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 #define V_IGN_TPR_SHIFT 20
 #define V_IGN_TPR_MASK (1 << V_IGN_TPR_SHIFT)
 
+#define V_IRQ_INJECTION_BITS_MASK (V_IRQ_MASK | V_INTR_PRIO_MASK | V_IGN_TPR_MASK)
+
 #define V_INTR_MASKING_SHIFT 24
 #define V_INTR_MASKING_MASK (1 << V_INTR_MASKING_SHIFT)
 
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 61738ff8ef33..28381ca5221c 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -503,7 +503,11 @@ static void nested_vmcb02_prepare_save(struct vcpu_svm *svm, struct vmcb *vmcb12
 
 static void nested_vmcb02_prepare_control(struct vcpu_svm *svm)
 {
-	const u32 mask = V_INTR_MASKING_MASK | V_GIF_ENABLE_MASK | V_GIF_MASK;
+	const u32 int_ctl_vmcb01_bits =
+		V_INTR_MASKING_MASK | V_GIF_MASK | V_GIF_ENABLE_MASK;
+
+	const u32 int_ctl_vmcb12_bits = V_TPR_MASK | V_IRQ_INJECTION_BITS_MASK;
+
 	struct kvm_vcpu *vcpu = &svm->vcpu;
 
 	/*
@@ -535,8 +539,8 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm)
 		vcpu->arch.l1_tsc_offset + svm->nested.ctl.tsc_offset;
 
 	svm->vmcb->control.int_ctl             =
-		(svm->nested.ctl.int_ctl & ~mask) |
-		(svm->vmcb01.ptr->control.int_ctl & mask);
+		(svm->nested.ctl.int_ctl & int_ctl_vmcb12_bits) |
+		(svm->vmcb01.ptr->control.int_ctl & int_ctl_vmcb01_bits);
 
 	svm->vmcb->control.virt_ext            = svm->nested.ctl.virt_ext;
 	svm->vmcb->control.int_vector          = svm->nested.ctl.int_vector;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index e8ccab50ebf6..69639f9624f5 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1589,17 +1589,18 @@ static void svm_set_vintr(struct vcpu_svm *svm)
 
 static void svm_clear_vintr(struct vcpu_svm *svm)
 {
-	const u32 mask = V_TPR_MASK | V_GIF_ENABLE_MASK | V_GIF_MASK | V_INTR_MASKING_MASK;
 	svm_clr_intercept(svm, INTERCEPT_VINTR);
 
 	/* Drop int_ctl fields related to VINTR injection.  */
-	svm->vmcb->control.int_ctl &= mask;
+	svm->vmcb->control.int_ctl &= ~V_IRQ_INJECTION_BITS_MASK;
 	if (is_guest_mode(&svm->vcpu)) {
-		svm->vmcb01.ptr->control.int_ctl &= mask;
+		svm->vmcb01.ptr->control.int_ctl &= ~V_IRQ_INJECTION_BITS_MASK;
 
 		WARN_ON((svm->vmcb->control.int_ctl & V_TPR_MASK) !=
 			(svm->nested.ctl.int_ctl & V_TPR_MASK));
-		svm->vmcb->control.int_ctl |= svm->nested.ctl.int_ctl & ~mask;
+
+		svm->vmcb->control.int_ctl |= svm->nested.ctl.int_ctl &
+			V_IRQ_INJECTION_BITS_MASK;
 	}
 
 	vmcb_mark_dirty(svm->vmcb, VMCB_INTR);
-- 
2.27.0

