Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 753AC12E288
	for <lists+kvm@lfdr.de>; Thu,  2 Jan 2020 06:15:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727741AbgABFPh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jan 2020 00:15:37 -0500
Received: from mga12.intel.com ([192.55.52.136]:22045 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727728AbgABFPY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jan 2020 00:15:24 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 01 Jan 2020 21:15:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,385,1571727600"; 
   d="scan'208";a="369236622"
Received: from unknown (HELO local-michael-cet-test.sh.intel.com) ([10.239.159.128])
  by orsmga004.jf.intel.com with ESMTP; 01 Jan 2020 21:15:23 -0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, jmattson@google.com,
        sean.j.christopherson@intel.com
Cc:     yu.c.zhang@linux.intel.com, alazar@bitdefender.com,
        edwin.zhai@intel.com, Yang Weijiang <weijiang.yang@intel.com>
Subject: [RESEND PATCH v10 09/10] x86: spp: Add SPP protection check in emulation
Date:   Thu,  2 Jan 2020 13:19:03 +0800
Message-Id: <20200102051904.32090-10-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20200102051904.32090-1-weijiang.yang@intel.com>
References: <20200102051904.32090-1-weijiang.yang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In instruction/mmio emulation cases, if the target write memroy
is SPP protected, exit to user-space to handle it as if it's
caused by SPP induced EPT violation due to guest write.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/kvm/x86.c | 37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a9d7fc21dad6..f2fb95249bf6 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5731,6 +5731,37 @@ static const struct read_write_emulator_ops write_emultor = {
 	.write = true,
 };
 
+static bool is_emulator_spp_protected(struct kvm_vcpu *vcpu,
+				      gpa_t gpa,
+				      unsigned int bytes)
+{
+	gfn_t gfn, start_gfn, end_gfn;
+	struct kvm *kvm = vcpu->kvm;
+	struct kvm_memory_slot *slot;
+	u32 *access;
+
+	if (!kvm->arch.spp_active)
+		return false;
+
+	start_gfn = gpa >> PAGE_SHIFT;
+	end_gfn = (gpa + bytes) >> PAGE_SHIFT;
+	for (gfn = start_gfn; gfn <= end_gfn; gfn++) {
+		slot = gfn_to_memslot(kvm, gfn);
+		if (slot) {
+			access = gfn_to_subpage_wp_info(slot, gfn);
+			if (access && *access != FULL_SPP_ACCESS) {
+				vcpu->run->exit_reason = KVM_EXIT_SPP;
+				vcpu->run->spp.addr = gfn;
+				vcpu->run->spp.ins_len =
+					kvm_x86_ops->get_inst_len(vcpu);
+				return true;
+			}
+		}
+	}
+
+	return false;
+}
+
 static int emulator_read_write_onepage(unsigned long addr, void *val,
 				       unsigned int bytes,
 				       struct x86_exception *exception,
@@ -5761,6 +5792,9 @@ static int emulator_read_write_onepage(unsigned long addr, void *val,
 			return X86EMUL_PROPAGATE_FAULT;
 	}
 
+	if (write && is_emulator_spp_protected(vcpu, gpa, bytes))
+		return X86EMUL_UNHANDLEABLE;
+
 	if (!ret && ops->read_write_emulate(vcpu, gpa, val, bytes))
 		return X86EMUL_CONTINUE;
 
@@ -6837,6 +6871,9 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu,
 		return 1;
 
 	if (r == EMULATION_FAILED) {
+		if (vcpu->run->exit_reason == KVM_EXIT_SPP)
+			return 0;
+
 		if (reexecute_instruction(vcpu, cr2, write_fault_to_spt,
 					emulation_type))
 			return 1;
-- 
2.17.2

