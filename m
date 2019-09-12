Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A66EFB1454
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2019 20:11:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727000AbfILSLL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Sep 2019 14:11:11 -0400
Received: from mail-pl1-f201.google.com ([209.85.214.201]:35977 "EHLO
        mail-pl1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726986AbfILSLL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Sep 2019 14:11:11 -0400
Received: by mail-pl1-f201.google.com with SMTP id z7so14644325plo.3
        for <kvm@vger.kernel.org>; Thu, 12 Sep 2019 11:11:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=IOK6Oqh2vh89Leb/hwKJdMjwLKONo65EI6QbrZVSCqU=;
        b=pjE+0Yr6zBzBLtFpVEk4AM5T+jXJgc2AvcPMA8UTMAK7oUcaOEQGZRmMcXBU35gA/O
         6ZY65PHYl7V9q4/JF4leNKmCV7Apa5XY34Gu+Erpxi0j1fHI32U2VNrJ5oyAOz7wPRVv
         kE3xjFnn7Q2RRsQk4MHnS4sBd/MKvY/5TmVESijx5tRxDmb0RLozi2AOjFuRLhphATMt
         BSEq9AYb9DYJX8gH7cjty9mAI3SGkFgRgUKBmZnToviT154fJFPFu303Vs/7F0L5sSoG
         ZdHyQpGcy9GDiDH6k8ayc3MG3X8fTIjlWn6+7jjdSoQYxnncBTvEG1NKB5Gyp5zHpUlD
         3zuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=IOK6Oqh2vh89Leb/hwKJdMjwLKONo65EI6QbrZVSCqU=;
        b=sGbBaBDwPoFBVnhqLZJVl29u0ijvJE97payA1rx6yI/RQsMzV2gG1e7N10d8t3X+cH
         B/8MdAwmrwXn+OYIsJd2ITsH3ODfJruNT+ROquMNIDeyJxXtTSgCa+Lb3CyEABV2FF0o
         S5biMNXd+xxh500YgsunMlBi+8e59XHe1cTa5Sx7T/g8IKMBrgqqIA18pKtoL2XGnqib
         9QA4bfgu324JgPWkOB70mN6kQHJN+jNm436yLVaSkaWr+SlDCYWXXg0R50JivakIC6DX
         EwgX3trNrdwzK1YiIjW048fA+1Z7Qhwg2ji6Oj8c7SCy+ns97IVLSd5EwR2tzKu0ittV
         S8Hg==
X-Gm-Message-State: APjAAAUuqsl6PMBeOzW+2hYqitN4NzHMRGDYmyhvFt/MLhBKW7yYtW28
        ktrBQ0OPkqgPtWKBCCh5BJSyPOX5AlB42nezzRro0whNxsY8bcy5gE8XZgmUjEpZcXq3YV7ox1V
        8Fur5JJP6khAIdWg8lyD05w8gA4OShtG9lD5caWw5H0QoK+zCEm+YZjPBMC3c
X-Google-Smtp-Source: APXvYqyzrhzNt0OfGS2Hk3z+fpHkJgg3309ngNRCDtZlz6M8WbchENoPfyf+6FuvK45deOqrNsLiHMM7Tzr+
X-Received: by 2002:a65:6552:: with SMTP id a18mr7985263pgw.208.1568311870081;
 Thu, 12 Sep 2019 11:11:10 -0700 (PDT)
Date:   Thu, 12 Sep 2019 11:11:00 -0700
Message-Id: <20190912181100.131124-1-marcorr@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.23.0.237.gc6a4ce50a0-goog
Subject: [PATCH] kvm: nvmx: limit atomic switch MSRs
From:   Marc Orr <marcorr@google.com>
To:     kvm@vger.kernel.org, jmattson@google.com, pshier@google.com
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
Quoting the appendix chapter, titled "MISCELLANEOUS DATA":

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
 arch/x86/include/asm/vmx.h |  1 +
 arch/x86/kvm/vmx/nested.c  | 19 +++++++++++++++++++
 2 files changed, 20 insertions(+)

diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index a39136b0d509..21c2a1d982e8 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -110,6 +110,7 @@
 #define VMX_MISC_SAVE_EFER_LMA			0x00000020
 #define VMX_MISC_ACTIVITY_HLT			0x00000040
 #define VMX_MISC_ZERO_LEN_INS			0x40000000
+#define VMX_MISC_MSR_LIST_INCREMENT             512
 
 /* VMFUNC functions */
 #define VMX_VMFUNC_EPTP_SWITCHING               0x00000001
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index ced9fba32598..69c6fc5557d8 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -856,6 +856,17 @@ static int nested_vmx_store_msr_check(struct kvm_vcpu *vcpu,
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
+	return (vmx_misc_max_msr(vmx_misc) + 1) * VMX_MISC_MSR_LIST_INCREMENT;
+}
+
 /*
  * Load guest's/host's msr at nested entry/exit.
  * return 0 for success, entry index for failure.
@@ -865,9 +876,13 @@ static u32 nested_vmx_load_msr(struct kvm_vcpu *vcpu, u64 gpa, u32 count)
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
@@ -899,6 +914,10 @@ static int nested_vmx_store_msr(struct kvm_vcpu *vcpu, u64 gpa, u32 count)
 {
 	u32 i;
 	struct vmx_msr_entry e;
+	u32 max_msr_list_size = nested_vmx_max_atomic_switch_msrs(vcpu);
+
+	if (unlikely(count > max_msr_list_size))
+		return -EINVAL;
 
 	for (i = 0; i < count; i++) {
 		struct msr_data msr_info;
-- 
2.23.0.237.gc6a4ce50a0-goog

