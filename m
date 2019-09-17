Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFE54B55A6
	for <lists+kvm@lfdr.de>; Tue, 17 Sep 2019 20:51:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727936AbfIQSvG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Sep 2019 14:51:06 -0400
Received: from mail-qk1-f201.google.com ([209.85.222.201]:33124 "EHLO
        mail-qk1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725865AbfIQSvG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Sep 2019 14:51:06 -0400
Received: by mail-qk1-f201.google.com with SMTP id w198so3467502qka.0
        for <kvm@vger.kernel.org>; Tue, 17 Sep 2019 11:51:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=NMPWcurabeQXP7vAPNbg7afSkO+tYJpZfmXbtM2pzw8=;
        b=QgDOcQb+FZoMyFo0XV1gnldIvWLAV4jPghdUNU48j9HlGtYL+buXxH3tB78MCDeh9v
         d6aojj3/dYSQul7X3GbSH3bJKSKj74rRg3VYXCOT9Ywh8xej73KmL4WCbBDWlk0BZQCf
         86JLynF7K63QiJSoFTls4kFw4OL9tphAFnztjUR7n4h/VptK5ihGS/6vQ0HGBxUBZ1NS
         NHDcZVUjN/23DOvVScDcqr3zDarKZWBgry6CQvhmPS7CQkPL/7p6/vXUBVZCwTUlR5JT
         Dq39gPNvdAoS8nLEoiczAFU4obcWkCzPrB1c6SjJysQx36mv8tyj3ABHaa2i/Z4Ob3U5
         sKYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=NMPWcurabeQXP7vAPNbg7afSkO+tYJpZfmXbtM2pzw8=;
        b=Gqa1Nb5wE39dYNrzXMarIvewcAFWfGvba7uNBxEFdEs3VKM7T8KRDbIBTeTRDPN1ne
         HQK2rhr2n3qEmtvaDQuzt79jIIilhlWXevcEvwA01N1o52Fw4+ub4O0YKi55Vt1y+LsH
         rq8yGCCAVLYSs+LcAnw26UzuzKW8jXuWdLglY7MljaHsUlHpW5bMoNI7O+0eXU4Anxj6
         WWtZD8TvZJV/Enwwy9yyIv975FxOO9ugEYmrMflP5eOxZ3FQSQA31EwpZ0mBsBDV4bcn
         oYJYlnbcPXWNcWKh+1RVmt4vJAwcOLXhL/7NPgiG7aaa9OcAA1iJVcWkk4VF0oisjxa2
         Aesg==
X-Gm-Message-State: APjAAAWsk9C45jfhxQYWVbkfjr5NIa1gjdKqtN4rfdpy7BiOcaBGBjhQ
        w3pMw0/dMovoSf89p4nupB++pWzypWlm+9SUjqv0VtvpqsXTq5bjX3TrVch2CPFZKQSsXqKdBxJ
        bYETNal7RQws9hSgVhYLS3JhO2mDFSKwV9XCMO/0wKaKeElszO0KkjOSZjRpv
X-Google-Smtp-Source: APXvYqxH1zKHgCyCEQenmMAdiVtMyPQD5NJItLfgxMD8rUdEazhB8Qf4Eu5UbDZXF6WUXZJ87ujmJQviKlli
X-Received: by 2002:a0c:8a6d:: with SMTP id 42mr9207qvu.138.1568746264379;
 Tue, 17 Sep 2019 11:51:04 -0700 (PDT)
Date:   Tue, 17 Sep 2019 11:50:57 -0700
Message-Id: <20190917185057.224221-1-marcorr@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.23.0.237.gc6a4ce50a0-goog
Subject: [PATCH v3] kvm: nvmx: limit atomic switch MSRs
From:   Marc Orr <marcorr@google.com>
To:     kvm@vger.kernel.org, jmattson@google.com, pshier@google.com,
        sean.j.christopherson@intel.com
Cc:     Marc Orr <marcorr@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Allowing an unlimited number of MSRs to be specified via the VMX
load/store MSR lists (e.g., vm-entry MSR load list) is bad for two
reasons. First, a guest can specify an unreasonable number of MSRs,
forcing KVM to process all of them in software. Second, the SDM bounds
the number of MSRs allowed to be packed into the atomic switch MSR lists.
Quoting the "Miscellaneous Data" section in the "VMX Capability
Reporting Facility" appendix:

"Bits 27:25 is used to compute the recommended maximum number of MSRs
that should appear in the VM-exit MSR-store list, the VM-exit MSR-load
list, or the VM-entry MSR-load list. Specifically, if the value bits
27:25 of IA32_VMX_MISC is N, then 512 * (N + 1) is the recommended
maximum number of MSRs to be included in each list. If the limit is
exceeded, undefined processor behavior may result (including a machine
check during the VMX transition)."

Because KVM needs to protect itself and can't model "undefined processor
behavior", arbitrarily force a VM-entry to fail due to MSR loading when
the MSR load list is too large. Similarly, trigger an abort during a VM
exit that encounters an MSR load list or MSR store list that is too large.

The MSR list size is intentionally not pre-checked so as to maintain
compatibility with hardware inasmuch as possible.

Test these new checks with the kvm-unit-test "x86: nvmx: test max atomic
switch MSRs".

Suggested-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Peter Shier <pshier@google.com>
Signed-off-by: Marc Orr <marcorr@google.com>
---
v2 -> v3
* Updated commit message.
* Removed superflous function declaration.
* Expanded in-line comment.

 arch/x86/include/asm/vmx.h |  1 +
 arch/x86/kvm/vmx/nested.c  | 44 ++++++++++++++++++++++++++++----------
 2 files changed, 34 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index a39136b0d509..a1f6ed187ccd 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -110,6 +110,7 @@
 #define VMX_MISC_SAVE_EFER_LMA			0x00000020
 #define VMX_MISC_ACTIVITY_HLT			0x00000040
 #define VMX_MISC_ZERO_LEN_INS			0x40000000
+#define VMX_MISC_MSR_LIST_MULTIPLIER		512
 
 /* VMFUNC functions */
 #define VMX_VMFUNC_EPTP_SWITCHING               0x00000001
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index ced9fba32598..0e29882bb45f 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -190,6 +190,16 @@ static void nested_vmx_abort(struct kvm_vcpu *vcpu, u32 indicator)
 	pr_debug_ratelimited("kvm: nested vmx abort, indicator %d\n", indicator);
 }
 
+static inline bool vmx_control_verify(u32 control, u32 low, u32 high)
+{
+	return fixed_bits_valid(control, low, high);
+}
+
+static inline u64 vmx_control_msr(u32 low, u32 high)
+{
+	return low | ((u64)high << 32);
+}
+
 static void vmx_disable_shadow_vmcs(struct vcpu_vmx *vmx)
 {
 	secondary_exec_controls_clearbit(vmx, SECONDARY_EXEC_SHADOW_VMCS);
@@ -856,18 +866,36 @@ static int nested_vmx_store_msr_check(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
+static u32 nested_vmx_max_atomic_switch_msrs(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	u64 vmx_misc = vmx_control_msr(vmx->nested.msrs.misc_low,
+				       vmx->nested.msrs.misc_high);
+
+	return (vmx_misc_max_msr(vmx_misc) + 1) * VMX_MISC_MSR_LIST_MULTIPLIER;
+}
+
 /*
  * Load guest's/host's msr at nested entry/exit.
  * return 0 for success, entry index for failure.
+ *
+ * One of the failure modes for MSR load/store is when a list exceeds the
+ * virtual hardware's capacity. To maintain compatibility with hardware inasmuch
+ * as possible, process all valid entries before failing rather than precheck
+ * for a capacity violation.
  */
 static u32 nested_vmx_load_msr(struct kvm_vcpu *vcpu, u64 gpa, u32 count)
 {
 	u32 i;
 	struct vmx_msr_entry e;
 	struct msr_data msr;
+	u32 max_msr_list_size = nested_vmx_max_atomic_switch_msrs(vcpu);
 
 	msr.host_initiated = false;
 	for (i = 0; i < count; i++) {
+		if (unlikely(i >= max_msr_list_size))
+			goto fail;
+
 		if (kvm_vcpu_read_guest(vcpu, gpa + i * sizeof(e),
 					&e, sizeof(e))) {
 			pr_debug_ratelimited(
@@ -899,9 +927,14 @@ static int nested_vmx_store_msr(struct kvm_vcpu *vcpu, u64 gpa, u32 count)
 {
 	u32 i;
 	struct vmx_msr_entry e;
+	u32 max_msr_list_size = nested_vmx_max_atomic_switch_msrs(vcpu);
 
 	for (i = 0; i < count; i++) {
 		struct msr_data msr_info;
+
+		if (unlikely(i >= max_msr_list_size))
+			return -EINVAL;
+
 		if (kvm_vcpu_read_guest(vcpu,
 					gpa + i * sizeof(e),
 					&e, 2 * sizeof(u32))) {
@@ -1009,17 +1042,6 @@ static u16 nested_get_vpid02(struct kvm_vcpu *vcpu)
 	return vmx->nested.vpid02 ? vmx->nested.vpid02 : vmx->vpid;
 }
 
-
-static inline bool vmx_control_verify(u32 control, u32 low, u32 high)
-{
-	return fixed_bits_valid(control, low, high);
-}
-
-static inline u64 vmx_control_msr(u32 low, u32 high)
-{
-	return low | ((u64)high << 32);
-}
-
 static bool is_bitwise_subset(u64 superset, u64 subset, u64 mask)
 {
 	superset &= mask;
-- 
2.23.0.237.gc6a4ce50a0-goog

