Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC6131D6112
	for <lists+kvm@lfdr.de>; Sat, 16 May 2020 14:55:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726763AbgEPMyM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 16 May 2020 08:54:12 -0400
Received: from mga07.intel.com ([134.134.136.100]:47574 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726727AbgEPMyL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 16 May 2020 08:54:11 -0400
IronPort-SDR: 6b79BH64DYEl80K0sRQBUI4hi6au2naNifJh2fYaFnu6NJlaLU+4blWRhmvOL06qLjvF+bukyU
 jbBWIf2bG8aQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2020 05:54:10 -0700
IronPort-SDR: MJo07iisMKJsHLVColE+rvMMYvQhsVNUKFjvwiHVgPKu2vUcUCE4tgaBJ2iCMRmHr0yO1cJHlm
 Htr0EKpfHOyA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,398,1583222400"; 
   d="scan'208";a="288076613"
Received: from local-michael-cet-test.sh.intel.com ([10.239.159.128])
  by fmsmga004.fm.intel.com with ESMTP; 16 May 2020 05:54:08 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, jmattson@google.com,
        sean.j.christopherson@intel.com
Cc:     yu.c.zhang@linux.intel.com, alazar@bitdefender.com,
        edwin.zhai@intel.com, ssicleru@bitdefender.com,
        Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v12 09/11] x86: spp: Add SPP protection check in instruction emulation
Date:   Sat, 16 May 2020 20:55:05 +0800
Message-Id: <20200516125507.5277-10-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20200516125507.5277-1-weijiang.yang@intel.com>
References: <20200516125507.5277-1-weijiang.yang@intel.com>
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
index 4b033a39d6c3..e3999a3ab911 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5788,6 +5788,37 @@ static const struct read_write_emulator_ops write_emultor = {
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
+					kvm_x86_ops.get_insn_len(vcpu);
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
@@ -5817,6 +5848,9 @@ static int emulator_read_write_onepage(unsigned long addr, void *val,
 			return X86EMUL_PROPAGATE_FAULT;
 	}
 
+	if (write && is_emulator_spp_protected(vcpu, gpa, bytes))
+		return X86EMUL_UNHANDLEABLE;
+
 	if (!ret && ops->read_write_emulate(vcpu, gpa, val, bytes))
 		return X86EMUL_CONTINUE;
 
@@ -6963,6 +6997,9 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 		return 1;
 
 	if (r == EMULATION_FAILED) {
+		if (vcpu->run->exit_reason == KVM_EXIT_SPP)
+			return 0;
+
 		if (reexecute_instruction(vcpu, cr2_or_gpa, write_fault_to_spt,
 					emulation_type))
 			return 1;
-- 
2.17.2

