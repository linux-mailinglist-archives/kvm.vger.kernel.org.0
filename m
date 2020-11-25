Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39A212C3CA2
	for <lists+kvm@lfdr.de>; Wed, 25 Nov 2020 10:43:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728668AbgKYJmX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Nov 2020 04:42:23 -0500
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:57190 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728560AbgKYJmG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 25 Nov 2020 04:42:06 -0500
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id BCD52305D511;
        Wed, 25 Nov 2020 11:35:47 +0200 (EET)
Received: from localhost.localdomain (unknown [91.199.104.27])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 9BC703072785;
        Wed, 25 Nov 2020 11:35:47 +0200 (EET)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Mircea=20C=C3=AErjaliu?= <mcirjaliu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v10 31/81] KVM: x86: disable gpa_available optimization for fetch and page-walk SPT violations
Date:   Wed, 25 Nov 2020 11:35:10 +0200
Message-Id: <20201125093600.2766-32-alazar@bitdefender.com>
In-Reply-To: <20201125093600.2766-1-alazar@bitdefender.com>
References: <20201125093600.2766-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Mircea Cîrjaliu <mcirjaliu@bitdefender.com>

This change is needed because the introspection tool can write-protect
guest page tables or exec-protect heap/stack pages.

Signed-off-by: Mircea Cîrjaliu <mcirjaliu@bitdefender.com>
Co-developed-by: Adalbert Lazăr <alazar@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 arch/x86/include/asm/kvm_host.h | 5 +++++
 arch/x86/kvm/mmu/mmu.c          | 7 +++++++
 arch/x86/kvm/x86.c              | 2 +-
 3 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 0342835a79d2..46849b92f937 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1448,6 +1448,10 @@ extern u64 kvm_mce_cap_supported;
  *			     retry native execution under certain conditions,
  *			     Can only be set in conjunction with EMULTYPE_PF.
  *
+ * EMULTYPE_GPA_AVAILABLE_PF - Set when the emulator can avoid a page walk
+ *                           to get the GPA.
+ *                           Can only be set in conjunction with EMULTYPE_PF.
+ *
  * EMULTYPE_TRAP_UD_FORCED - Set when emulating an intercepted #UD that was
  *			     triggered by KVM's magic "force emulation" prefix,
  *			     which is opt in via module param (off by default).
@@ -1470,6 +1474,7 @@ extern u64 kvm_mce_cap_supported;
 #define EMULTYPE_TRAP_UD_FORCED	    (1 << 4)
 #define EMULTYPE_VMWARE_GP	    (1 << 5)
 #define EMULTYPE_PF		    (1 << 6)
+#define EMULTYPE_GPA_AVAILABLE_PF   (1 << 7)
 
 int kvm_emulate_instruction(struct kvm_vcpu *vcpu, int emulation_type);
 int kvm_emulate_instruction_from_buffer(struct kvm_vcpu *vcpu,
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 23b72532cd18..f79cf58a27dc 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5148,6 +5148,13 @@ int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 error_code,
 
 	if (WARN_ON(!VALID_PAGE(vcpu->arch.mmu->root_hpa)))
 		return RET_PF_RETRY;
+	/*
+	 * With shadow page tables, fault_address contains a GVA or nGPA.
+	 * On a fetch fault, fault_address contains the instruction pointer.
+	 */
+	if (direct && likely(!(error_code & PFERR_FETCH_MASK)) &&
+	    (error_code & PFERR_GUEST_FINAL_MASK))
+		emulation_type |= EMULTYPE_GPA_AVAILABLE_PF;
 
 	r = RET_PF_INVALID;
 	if (unlikely(error_code & PFERR_RSVD_MASK)) {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a82db6b30aee..d9b1034465c8 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7406,7 +7406,7 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 		ctxt->exception.address = cr2_or_gpa;
 
 		/* With shadow page tables, cr2 contains a GVA or nGPA. */
-		if (vcpu->arch.mmu->direct_map) {
+		if (emulation_type & EMULTYPE_GPA_AVAILABLE_PF) {
 			ctxt->gpa_available = true;
 			ctxt->gpa_val = cr2_or_gpa;
 		}
