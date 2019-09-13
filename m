Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FF29B16D4
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2019 02:00:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727239AbfIMAAr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Sep 2019 20:00:47 -0400
Received: from mga06.intel.com ([134.134.136.31]:36785 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726516AbfIMAAr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Sep 2019 20:00:47 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Sep 2019 17:00:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,492,1559545200"; 
   d="scan'208";a="179517264"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by orsmga008.jf.intel.com with ESMTP; 12 Sep 2019 17:00:46 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     kvm@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Fuqian Huang <huangfq.daxian@gmail.com>
Subject: [kvm-unit-tests PATCH] x86: nVMX: Add tests of VMPTRLD and VMPTRST to MMIO addresses
Date:   Thu, 12 Sep 2019 17:00:45 -0700
Message-Id: <20190913000045.19214-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM uses master abort semantics to handle MMIO accesses when emulating
VMX instructions.  Ensure this is the case, i.e. that KVM doesn't inject
a #PF, by emitting VMPTRLD and VMPTRST to the TXT private address space.

Use the TXT private space as the bogus MMIO address so that the tests
can also pass on bare metal.  If my recollection of TXT is correct,
accesses to private space when it is locked trigger master aborts.

Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Jim Mattson <jmattson@google.com>
Cc: Fuqian Huang <huangfq.daxian@gmail.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---

This obviously assumes the associated KVM change[*] is applied.

[*] https://lkml.kernel.org/r/20190912235603.18954-1-sean.j.christopherson@intel.com

 x86/vmx.c | 15 +++++++++++++++
 x86/vmx.h | 20 ++++++++++++++++++++
 2 files changed, 35 insertions(+)

diff --git a/x86/vmx.c b/x86/vmx.c
index 6079420..b14fc02 100644
--- a/x86/vmx.c
+++ b/x86/vmx.c
@@ -1374,6 +1374,8 @@ out:
 	return ret;
 }
 
+#define INTEL_TXT_PRIVATE_SPACE	0xfed20000
+
 static void test_vmptrld(void)
 {
 	struct vmcs *vmcs, *tmp_root;
@@ -1393,6 +1395,10 @@ static void test_vmptrld(void)
 	report("test vmptrld with vmcs address bits set beyond physical address width",
 	       make_vmcs_current(tmp_root) == 1);
 
+	/* Non-existent address, i.e. emulated MMIO */
+	report("test vmptrld with non-existent address (for operand)",
+	       vmptrld_raw((void *)INTEL_TXT_PRIVATE_SPACE) == 1);
+
 	/* Pass VMXON region */
 	assert(!vmcs_clear(vmcs));
 	assert(!make_vmcs_current(vmcs));
@@ -1414,6 +1420,15 @@ static void test_vmptrst(void)
 	init_vmcs(&vmcs1);
 	ret = vmcs_save(&vmcs2);
 	report("test vmptrst", (!ret) && (vmcs1 == vmcs2));
+
+	/*
+	 * Non-existent address, i.e. emulated MMIO.  Counter-intuitively, this
+	 * is expected to succeed as KVM handles unexpected MMIO accesses using
+	 * master abort semantics, i.e. drops the write but doesn't signal a
+	 * fault of any kind.
+	 */
+	report("test vmptrst with non-existent address (for operand)",
+	       vmptrst_raw((void *)INTEL_TXT_PRIVATE_SPACE) == 0);
 }
 
 struct vmx_ctl_msr {
diff --git a/x86/vmx.h b/x86/vmx.h
index 75abf9a..4ed4aba 100644
--- a/x86/vmx.h
+++ b/x86/vmx.h
@@ -685,6 +685,26 @@ static int vmx_off(void)
 	return ret;
 }
 
+static inline bool vmptrld_raw(void *ptr)
+{
+	bool ret;
+	u64 rflags = read_rflags() | X86_EFLAGS_CF | X86_EFLAGS_ZF;
+
+	asm volatile ("push %1; popf; vmptrld (%%rax); setbe %0"
+		      : "=q" (ret) : "q" (rflags), "a" (ptr) : "cc");
+	return ret;
+}
+
+static inline int vmptrst_raw(void *ptr)
+{
+	bool ret;
+	u64 rflags = read_rflags() | X86_EFLAGS_CF | X86_EFLAGS_ZF;
+
+	asm volatile ("push %1; popf; vmptrst (%%rax); setbe %0"
+		      : "=q" (ret) : "q" (rflags), "a" (ptr) : "cc");
+	return ret;
+}
+
 static inline int make_vmcs_current(struct vmcs *vmcs)
 {
 	bool ret;
-- 
2.22.0

