Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8616E42448B
	for <lists+kvm@lfdr.de>; Wed,  6 Oct 2021 19:40:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239194AbhJFRmg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Oct 2021 13:42:36 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:53450 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233287AbhJFRmc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 6 Oct 2021 13:42:32 -0400
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id ED5D63086402;
        Wed,  6 Oct 2021 20:31:25 +0300 (EEST)
Received: from localhost (unknown [91.199.104.28])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id D6787305FFA0;
        Wed,  6 Oct 2021 20:31:25 +0300 (EEST)
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
        =?UTF-8?q?Mihai=20Don=C8=9Bu?= <mdontu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v12 77/77] KVM: x86: call the page tracking code on emulation failure
Date:   Wed,  6 Oct 2021 20:31:13 +0300
Message-Id: <20211006173113.26445-78-alazar@bitdefender.com>
In-Reply-To: <20211006173113.26445-1-alazar@bitdefender.com>
References: <20211006173113.26445-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Mihai Donțu <mdontu@bitdefender.com>

The information we can provide this way is incomplete, but current users
of the page tracking code can work with it.

Signed-off-by: Mihai Donțu <mdontu@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 arch/x86/kvm/x86.c | 49 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 49 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9a3fac9b30ba..a9caacea0207 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7872,6 +7872,51 @@ int x86_decode_emulated_instruction(struct kvm_vcpu *vcpu, int emulation_type,
 }
 EXPORT_SYMBOL_GPL(x86_decode_emulated_instruction);
 
+/*
+ * With introspection enabled, emulation failures translate in events being
+ * missed because the read/write callbacks are not invoked. All we have is
+ * the fetch event (kvm_page_track_preexec). Below we use the EPT/NPT VMEXIT
+ * information to generate the events, but without providing accurate
+ * data and size (the emulator would have computed those). If an instruction
+ * would happen to read and write in the same page, the second event will
+ * initially be missed and we rely on the page tracking mechanism to bring
+ * us back here to send it.
+ */
+static bool kvm_page_track_emulation_failure(struct kvm_vcpu *vcpu, gpa_t gpa)
+{
+	u64 error_code = vcpu->arch.error_code;
+	u8 data = 0;
+	gva_t gva;
+	bool ret;
+
+	/* MMIO emulation failures should be treated the normal way */
+	if (unlikely(error_code & PFERR_RSVD_MASK))
+		return true;
+
+	/* EPT/NTP must be enabled */
+	if (unlikely(!vcpu->arch.mmu->direct_map))
+		return true;
+
+	/*
+	 * The A/D bit emulation should make this test unneeded, but just
+	 * in case
+	 */
+	if (unlikely((error_code & PFERR_NESTED_GUEST_PAGE) ==
+		     PFERR_NESTED_GUEST_PAGE))
+		return true;
+
+	gva = static_call(kvm_x86_fault_gla)(vcpu);
+
+	if (error_code & PFERR_WRITE_MASK)
+		ret = kvm_page_track_prewrite(vcpu, gpa, gva, &data, 0);
+	else if (error_code & PFERR_USER_MASK)
+		ret = kvm_page_track_preread(vcpu, gpa, gva, 0);
+	else
+		ret = true;
+
+	return ret;
+}
+
 int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 			    int emulation_type, void *insn, int insn_len)
 {
@@ -7905,6 +7950,8 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 				kvm_queue_exception(vcpu, UD_VECTOR);
 				return 1;
 			}
+			if (!kvm_page_track_emulation_failure(vcpu, cr2_or_gpa))
+				return 1;
 			if (reexecute_instruction(vcpu, cr2_or_gpa,
 						  write_fault_to_spt,
 						  emulation_type))
@@ -7974,6 +8021,8 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 		return 1;
 
 	if (r == EMULATION_FAILED) {
+		if (!kvm_page_track_emulation_failure(vcpu, cr2_or_gpa))
+			return 1;
 		if (reexecute_instruction(vcpu, cr2_or_gpa, write_fault_to_spt,
 					emulation_type))
 			return 1;
