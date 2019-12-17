Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6436A1238B4
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2019 22:33:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728415AbfLQVc4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Dec 2019 16:32:56 -0500
Received: from mga04.intel.com ([192.55.52.120]:17437 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728318AbfLQVcq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Dec 2019 16:32:46 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Dec 2019 13:32:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,326,1571727600"; 
   d="scan'208";a="227639445"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga002.jf.intel.com with ESMTP; 17 Dec 2019 13:32:42 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/5] KVM: x86: Add dedicated emulator helpers for querying CPUID features
Date:   Tue, 17 Dec 2019 13:32:38 -0800
Message-Id: <20191217213242.11712-2-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191217213242.11712-1-sean.j.christopherson@intel.com>
References: <20191217213242.11712-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add feature-specific helpers for querying guest CPUID support from the
emulator instead of having the emulator do a full CPUID and perform its
own bit tests.  The primary motivation is to eliminate the emulator's
usage of bit() so that future patches can add more extensive build-time
assertions on the usage of bit() without having to expose yet more code
to the emulator.

Note, providing a generic guest_cpuid_has() to the emulator doesn't work
due to the existing built-time assertions in guest_cpuid_has(), which
require the feature being checked to be a compile-time constant.

No functional change intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/asm/kvm_emulate.h |  4 ++++
 arch/x86/kvm/emulate.c             | 21 +++------------------
 arch/x86/kvm/x86.c                 | 18 ++++++++++++++++++
 3 files changed, 25 insertions(+), 18 deletions(-)

diff --git a/arch/x86/include/asm/kvm_emulate.h b/arch/x86/include/asm/kvm_emulate.h
index 77cf6c11f66b..03946eb3e2b9 100644
--- a/arch/x86/include/asm/kvm_emulate.h
+++ b/arch/x86/include/asm/kvm_emulate.h
@@ -222,6 +222,10 @@ struct x86_emulate_ops {
 
 	bool (*get_cpuid)(struct x86_emulate_ctxt *ctxt, u32 *eax, u32 *ebx,
 			  u32 *ecx, u32 *edx, bool check_limit);
+	bool (*guest_has_long_mode)(struct x86_emulate_ctxt *ctxt);
+	bool (*guest_has_movbe)(struct x86_emulate_ctxt *ctxt);
+	bool (*guest_has_fxsr)(struct x86_emulate_ctxt *ctxt);
+
 	void (*set_nmi_mask)(struct x86_emulate_ctxt *ctxt, bool masked);
 
 	unsigned (*get_hflags)(struct x86_emulate_ctxt *ctxt);
diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 952d1a4f4d7e..e9833e345a5c 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -2348,12 +2348,7 @@ static int em_lseg(struct x86_emulate_ctxt *ctxt)
 static int emulator_has_longmode(struct x86_emulate_ctxt *ctxt)
 {
 #ifdef CONFIG_X86_64
-	u32 eax, ebx, ecx, edx;
-
-	eax = 0x80000001;
-	ecx = 0;
-	ctxt->ops->get_cpuid(ctxt, &eax, &ebx, &ecx, &edx, false);
-	return edx & bit(X86_FEATURE_LM);
+	return ctxt->ops->guest_has_long_mode(ctxt);
 #else
 	return false;
 #endif
@@ -3618,18 +3613,11 @@ static int em_mov(struct x86_emulate_ctxt *ctxt)
 	return X86EMUL_CONTINUE;
 }
 
-#define FFL(x) bit(X86_FEATURE_##x)
-
 static int em_movbe(struct x86_emulate_ctxt *ctxt)
 {
-	u32 ebx, ecx, edx, eax = 1;
 	u16 tmp;
 
-	/*
-	 * Check MOVBE is set in the guest-visible CPUID leaf.
-	 */
-	ctxt->ops->get_cpuid(ctxt, &eax, &ebx, &ecx, &edx, false);
-	if (!(ecx & FFL(MOVBE)))
+	if (!ctxt->ops->guest_has_movbe(ctxt))
 		return emulate_ud(ctxt);
 
 	switch (ctxt->op_bytes) {
@@ -4027,10 +4015,7 @@ static int em_movsxd(struct x86_emulate_ctxt *ctxt)
 
 static int check_fxsr(struct x86_emulate_ctxt *ctxt)
 {
-	u32 eax = 1, ebx, ecx = 0, edx;
-
-	ctxt->ops->get_cpuid(ctxt, &eax, &ebx, &ecx, &edx, false);
-	if (!(edx & FFL(FXSR)))
+	if (!ctxt->ops->guest_has_fxsr(ctxt))
 		return emulate_ud(ctxt);
 
 	if (ctxt->ops->get_cr(ctxt, 0) & (X86_CR0_TS | X86_CR0_EM))
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 8bb2fb1705ff..6bca14071d30 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6184,6 +6184,21 @@ static bool emulator_get_cpuid(struct x86_emulate_ctxt *ctxt,
 	return kvm_cpuid(emul_to_vcpu(ctxt), eax, ebx, ecx, edx, check_limit);
 }
 
+static bool emulator_guest_has_long_mode(struct x86_emulate_ctxt *ctxt)
+{
+	return guest_cpuid_has(emul_to_vcpu(ctxt), X86_FEATURE_LM);
+}
+
+static bool emulator_guest_has_movbe(struct x86_emulate_ctxt *ctxt)
+{
+	return guest_cpuid_has(emul_to_vcpu(ctxt), X86_FEATURE_MOVBE);
+}
+
+static bool emulator_guest_has_fxsr(struct x86_emulate_ctxt *ctxt)
+{
+	return guest_cpuid_has(emul_to_vcpu(ctxt), X86_FEATURE_FXSR);
+}
+
 static ulong emulator_read_gpr(struct x86_emulate_ctxt *ctxt, unsigned reg)
 {
 	return kvm_register_read(emul_to_vcpu(ctxt), reg);
@@ -6261,6 +6276,9 @@ static const struct x86_emulate_ops emulate_ops = {
 	.fix_hypercall       = emulator_fix_hypercall,
 	.intercept           = emulator_intercept,
 	.get_cpuid           = emulator_get_cpuid,
+	.guest_has_long_mode = emulator_guest_has_long_mode,
+	.guest_has_movbe     = emulator_guest_has_movbe,
+	.guest_has_fxsr      = emulator_guest_has_fxsr,
 	.set_nmi_mask        = emulator_set_nmi_mask,
 	.get_hflags          = emulator_get_hflags,
 	.set_hflags          = emulator_set_hflags,
-- 
2.24.1

