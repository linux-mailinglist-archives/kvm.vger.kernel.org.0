Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70DDB141BD5
	for <lists+kvm@lfdr.de>; Sun, 19 Jan 2020 05:02:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727403AbgASEAl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 18 Jan 2020 23:00:41 -0500
Received: from mga14.intel.com ([192.55.52.115]:62803 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727117AbgASEAj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 18 Jan 2020 23:00:39 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Jan 2020 20:00:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,336,1574150400"; 
   d="scan'208";a="214910515"
Received: from local-michael-cet-test.sh.intel.com ([10.239.159.128])
  by orsmga007.jf.intel.com with ESMTP; 18 Jan 2020 20:00:37 -0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, jmattson@google.com,
        sean.j.christopherson@intel.com
Cc:     yu.c.zhang@linux.intel.com, alazar@bitdefender.com,
        edwin.zhai@intel.com, Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v11 08/10] x86: spp: Add SPP protection check in instruction emulation
Date:   Sun, 19 Jan 2020 12:05:05 +0800
Message-Id: <20200119040507.23113-9-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20200119040507.23113-1-weijiang.yang@intel.com>
References: <20200119040507.23113-1-weijiang.yang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In instruction/mmio emulation cases, if the target write memroy
is SPP protected, "fake" an vmexit to userspace to let application
handle it.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/kvm/x86.c | 37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e93641d631cb..102a3ff8f690 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5726,6 +5726,37 @@ static const struct read_write_emulator_ops write_emultor = {
 	.write = true,
 };
 
+static bool is_emulator_spp_protected(struct kvm_vcpu *vcpu,
+				      gpa_t gpa,
+				      unsigned int bytes)
+{
+	gfn_t gfn, gfn_start, gfn_end;
+	struct kvm *kvm = vcpu->kvm;
+	struct kvm_memory_slot *slot;
+	u32 *access;
+
+	if (!kvm->arch.spp_active)
+		return false;
+
+	gfn_start = gpa_to_gfn(gpa);
+	gfn_end = gpa_to_gfn(gpa + bytes);
+	for (gfn = gfn_start; gfn <= gfn_end; gfn++) {
+		slot = gfn_to_memslot(kvm, gfn);
+		if (slot) {
+			access = gfn_to_subpage_wp_info(slot, gfn);
+			if (access && *access != FULL_SPP_ACCESS) {
+				vcpu->run->exit_reason = KVM_EXIT_SPP;
+				vcpu->run->spp.addr = gfn;
+				vcpu->run->spp.insn_len =
+					kvm_x86_ops->get_insn_len(vcpu);
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
@@ -5756,6 +5787,9 @@ static int emulator_read_write_onepage(unsigned long addr, void *val,
 			return X86EMUL_PROPAGATE_FAULT;
 	}
 
+	if (write && is_emulator_spp_protected(vcpu, gpa, bytes))
+		return X86EMUL_UNHANDLEABLE;
+
 	if (!ret && ops->read_write_emulate(vcpu, gpa, val, bytes))
 		return X86EMUL_CONTINUE;
 
@@ -6832,6 +6866,9 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu,
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

