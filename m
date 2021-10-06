Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 744D2424487
	for <lists+kvm@lfdr.de>; Wed,  6 Oct 2021 19:40:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238617AbhJFRmd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Oct 2021 13:42:33 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:53434 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231624AbhJFRmc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 6 Oct 2021 13:42:32 -0400
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id E31E6307CAF0;
        Wed,  6 Oct 2021 20:31:04 +0300 (EEST)
Received: from localhost (unknown [91.199.104.28])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id C83E8305FFA0;
        Wed,  6 Oct 2021 20:31:04 +0300 (EEST)
X-Is-Junk-Enabled: fGZTSsP0qEJE2AIKtlSuFiRRwg9xyHmJ
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Mathieu Tarral <mathieu.tarral@protonmail.com>,
        Tamas K Lengyel <tamas@tklengyel.com>,
        =?UTF-8?q?Mircea=20C=C3=AErjaliu?= <mcirjaliu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v12 28/77] KVM: x86: disable gpa_available optimization for fetch and page-walk SPT violations
Date:   Wed,  6 Oct 2021 20:30:24 +0300
Message-Id: <20211006173113.26445-29-alazar@bitdefender.com>
In-Reply-To: <20211006173113.26445-1-alazar@bitdefender.com>
References: <20211006173113.26445-1-alazar@bitdefender.com>
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
index 692e55a5c312..dc3c83edc4bc 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1664,6 +1664,10 @@ extern u64 kvm_mce_cap_supported;
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
@@ -1686,6 +1690,7 @@ extern u64 kvm_mce_cap_supported;
 #define EMULTYPE_TRAP_UD_FORCED	    (1 << 4)
 #define EMULTYPE_VMWARE_GP	    (1 << 5)
 #define EMULTYPE_PF		    (1 << 6)
+#define EMULTYPE_GPA_AVAILABLE_PF   (1 << 7)
 
 int kvm_emulate_instruction(struct kvm_vcpu *vcpu, int emulation_type);
 int kvm_emulate_instruction_from_buffer(struct kvm_vcpu *vcpu,
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index b5685e342945..c90683284098 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5297,6 +5297,13 @@ int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 error_code,
 
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
index c52ac5e9a020..ab97e0175c04 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7933,7 +7933,7 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 		ctxt->exception.address = cr2_or_gpa;
 
 		/* With shadow page tables, cr2 contains a GVA or nGPA. */
-		if (vcpu->arch.mmu->direct_map) {
+		if (emulation_type & EMULTYPE_GPA_AVAILABLE_PF) {
 			ctxt->gpa_available = true;
 			ctxt->gpa_val = cr2_or_gpa;
 		}
