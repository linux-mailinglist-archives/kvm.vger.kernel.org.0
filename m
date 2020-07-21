Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 334E5228AF0
	for <lists+kvm@lfdr.de>; Tue, 21 Jul 2020 23:18:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731257AbgGUVQB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jul 2020 17:16:01 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:37788 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731214AbgGUVQA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Jul 2020 17:16:00 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 599EF30412EA;
        Wed, 22 Jul 2020 00:09:24 +0300 (EEST)
Received: from localhost.localdomain (unknown [91.199.104.27])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 3AE38304FA14;
        Wed, 22 Jul 2020 00:09:24 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Mircea=20C=C3=AErjaliu?= <mcirjaliu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v9 36/84] KVM: x86: disable gpa_available optimization for fetch and page-walk SPT violations
Date:   Wed, 22 Jul 2020 00:08:34 +0300
Message-Id: <20200721210922.7646-37-alazar@bitdefender.com>
In-Reply-To: <20200721210922.7646-1-alazar@bitdefender.com>
References: <20200721210922.7646-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
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
 arch/x86/kvm/mmu/mmu.c          | 8 ++++++++
 arch/x86/kvm/x86.c              | 2 +-
 3 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index b6a1704e0f89..8a119fb7c623 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1436,6 +1436,10 @@ extern u64 kvm_mce_cap_supported;
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
@@ -1458,6 +1462,7 @@ extern u64 kvm_mce_cap_supported;
 #define EMULTYPE_TRAP_UD_FORCED	    (1 << 4)
 #define EMULTYPE_VMWARE_GP	    (1 << 5)
 #define EMULTYPE_PF		    (1 << 6)
+#define EMULTYPE_GPA_AVAILABLE_PF   (1 << 7)
 
 int kvm_emulate_instruction(struct kvm_vcpu *vcpu, int emulation_type);
 int kvm_emulate_instruction_from_buffer(struct kvm_vcpu *vcpu,
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index da57321e0cec..4df5b729e2c5 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5566,6 +5566,14 @@ int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 error_code,
 	 */
 	if (!mmio_info_in_cache(vcpu, cr2_or_gpa, direct) && !is_guest_mode(vcpu))
 		emulation_type |= EMULTYPE_ALLOW_RETRY_PF;
+
+	/*
+	 * With shadow page tables, fault_address contains a GVA or nGPA.
+	 * On a fetch fault, fault_address contains the instruction pointer.
+	 */
+	if (direct && likely(!(error_code & PFERR_FETCH_MASK)) &&
+	    (error_code & PFERR_GUEST_FINAL_MASK))
+		emulation_type |= EMULTYPE_GPA_AVAILABLE_PF;
 emulate:
 	/*
 	 * On AMD platforms, under certain conditions insn_len may be zero on #NPF.
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 7668ca5b8a7a..ffcf09e9bf78 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6987,7 +6987,7 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 		ctxt->exception.address = cr2_or_gpa;
 
 		/* With shadow page tables, cr2 contains a GVA or nGPA. */
-		if (vcpu->arch.mmu->direct_map) {
+		if (emulation_type & EMULTYPE_GPA_AVAILABLE_PF) {
 			ctxt->gpa_available = true;
 			ctxt->gpa_val = cr2_or_gpa;
 		}
