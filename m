Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3ABAB2921
	for <lists+kvm@lfdr.de>; Sat, 14 Sep 2019 02:39:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390857AbfINAjw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Sep 2019 20:39:52 -0400
Received: from mail-pf1-f201.google.com ([209.85.210.201]:38512 "EHLO
        mail-pf1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390769AbfINAjv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Sep 2019 20:39:51 -0400
Received: by mail-pf1-f201.google.com with SMTP id o73so10239018pfg.5
        for <kvm@vger.kernel.org>; Fri, 13 Sep 2019 17:39:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=v2NNiNbBHjh/sr6wF0wadGyXp3b8GenhdQjFtyuiNzU=;
        b=A4B+7q+ADVVY2uHI57WWk5JweAkSqBM1Kno6+BfEP/r00Kz66KmZhIF5wikQUgdiPf
         KtSMcfPud9SyTRxorBp/YkWGGAFf/obtljnT6p2ljyqIBgnQgMt1YoocE6qPe3EHJvhm
         gVqlUKvg8//rcVv/EGdAQ++beKZm+dVahsvyRM4VYx3h2LS5wS0fJpbfUBLF9oPuJ/6b
         V66NbUIB1TmHFf8UroeQ7hPtj41djV9A8+cMJxjRwI9JndVd5hiXAUfAqtkugJpl95wS
         iz45rwlECOgrv2mE17pc5P1eMvdSnJKdvbcqGE76023ULWUufdKzIgm8nwa8bEp4aTfK
         UTew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=v2NNiNbBHjh/sr6wF0wadGyXp3b8GenhdQjFtyuiNzU=;
        b=EpHD2wp6amtNehX7TjcI+wYsnQcrioQYi6giZd3D1VJzGNausINafllfiPTlfmWmlA
         SuF6h8seDwWpw1Lz2LP48PPKUQy8x8AEnxuuJtTSmUZAjF+SzLxLsfx3Bni7F421xVdu
         I63ml9JoOHWlzxJub1KsSjY5YFJ2HK4I0bm1gbP1k+gtVQgLQbJ122OpgDdtYlUshmUb
         HfuZgUI5mdB2tDLFr/UwLufmr3nw07gmnWyww7Xdx9yhyV1pGy5j7ilXwV3lOuw2zIVh
         qWLrH6vZbtyGoSrKjctTOs/AChGpZtUsc7LQIS8JGAoQ3eJ+eRg0LBEt+Js5n3nm4P2R
         q9IA==
X-Gm-Message-State: APjAAAX0izDUbfQaXuE0cNFPtf4/86bRLQiqR/+tavEx0e4kEJioN1W5
        oCtF48hufopRfI9FJqqhwywFc6DpZ70FViQPRbnlWjKafg2BtLSI5eL63eQjr4gThL6b537l6H4
        vXdnSMzAg3jtJvzDmooDwIvUk8yWW8PtGafTqXDIl6ezLNZqUEkm3DF1o44nW
X-Google-Smtp-Source: APXvYqyZES+h9kwjNqffvapAZ980nXxRi2RXMQUyV+EScWYpVz7fB93zZYYshUSyVsgnbrr5RFho7A7SJ3CW
X-Received: by 2002:a63:10a:: with SMTP id 10mr46107383pgb.281.1568421590433;
 Fri, 13 Sep 2019 17:39:50 -0700 (PDT)
Date:   Fri, 13 Sep 2019 17:39:40 -0700
Message-Id: <20190914003940.203636-1-marcorr@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.23.0.237.gc6a4ce50a0-goog
Subject: [PATCH v2] kvm: nvmx: limit atomic switch MSRs
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

Thus, force a VM-entry to fail due to MSR loading when the MSR load
list is too large. Similarly, trigger an abort during a VM exit that
encounters an MSR load list or MSR store list that is too large.

Test these new checks with the kvm-unit-test "x86: nvmx: test max atomic
switch MSRs".

Suggested-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Peter Shier <pshier@google.com>
Signed-off-by: Marc Orr <marcorr@google.com>
---
v1 -> v2
* Updated description to distinguish the relevant appendix.
* Renamed VMX_MISC_MSR_LIST_INCREMENT to VMX_MISC_MSR_LIST_MULTIPLIER.
* Moved vmx_control_msr() and vmx_control_verify() up in the source.
* Modified nested_vmx_store_msr() to fail lazily, like
  nested_vmx_load_msr().

 arch/x86/include/asm/vmx.h |  1 +
 arch/x86/kvm/vmx/nested.c  | 41 ++++++++++++++++++++++++++++----------
 2 files changed, 31 insertions(+), 11 deletions(-)

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
index ced9fba32598..bca0167b8bdd 100644
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
@@ -856,6 +866,17 @@ static int nested_vmx_store_msr_check(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
+static u64 vmx_control_msr(u32 low, u32 high);
+
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
@@ -865,9 +886,13 @@ static u32 nested_vmx_load_msr(struct kvm_vcpu *vcpu, u64 gpa, u32 count)
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
@@ -899,9 +924,14 @@ static int nested_vmx_store_msr(struct kvm_vcpu *vcpu, u64 gpa, u32 count)
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
@@ -1009,17 +1039,6 @@ static u16 nested_get_vpid02(struct kvm_vcpu *vcpu)
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

