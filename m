Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC75323868
	for <lists+kvm@lfdr.de>; Mon, 20 May 2019 15:41:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731385AbfETNlF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 May 2019 09:41:05 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:46001 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727682AbfETNlF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 May 2019 09:41:05 -0400
Received: by mail-wr1-f67.google.com with SMTP id b18so14616774wrq.12;
        Mon, 20 May 2019 06:41:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=pxalDK/lEAAA1vrNRXNOUg51uWf8D/bvJySintxZsSI=;
        b=sDqq3hBCW4e/iFe8vPihu6wBp7wJU6ShXhgEpFEvr3FGKUbW/Vp81aX2Zll29j/w8i
         +3qz03FIW2jdao+8cYdxcaVDr2jpU3cNhHjgqf7oN3/ROvkxm0DPge4KDtlf1DRdSp1o
         WqKwHZhXf/To2i0pZjA/YZ7eOfC0zDjDZ/+huerfEwMTUXF2ffbkls7hKdPCHWmENRW4
         qQR5kGvWY698Enk0U/6Bwp1d/cwxi7PiLqMQVYuB2vV8ey/IOqe4MCneSxW9PDfp9wu1
         nyF0T06qW20qmRghalcwruLza/+yGh/jkA74AvgWTgVs1DO+k3pPNQVQXrNGnESbg6Yn
         nvyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id;
        bh=pxalDK/lEAAA1vrNRXNOUg51uWf8D/bvJySintxZsSI=;
        b=Oo4TsZ6/JKapB0i+naUeU4EITwf3YWdUoMW5HVCvul0u9PAIBo6xj8d6NzYOo7KNvl
         UMG7p/n4HbAUrieiRoZDLTgAHJ3Rqz0gCMoiviaRuTBYq9x0rL9tPYS66k85x6R8/bwG
         IJn5QaUFinzYFwRSd19g2HMcnIXPg5MHx5E2RVVMQSCKAEQq7RH3LkTW1qq289HIXZ6s
         uaJAVasRkkmU+Ed6r/d7yiURUY88rCDqilyH5JaqLyTt5ItuyY7aTPxly0zmDj1m+xIv
         oCH/+sNaj7XzhKu0Xa1YzC18Neqgq9QamrSh7jWaoj4v7gkIadBxiDFf2y0GfrG7uM8E
         zIiQ==
X-Gm-Message-State: APjAAAVRMXQEofPLOpxlPHrBfYf8WwCn8kiOxyyKRYSUe2ILsBFzSbU5
        7ezwC/1WVbuohPOoj6ZUDUP0N3iY
X-Google-Smtp-Source: APXvYqyBOcsBF+HdiA9JrCMkV89LroPQELkzqr/7WyslmZs2tAje8S03xg13C0Ym2UxJqbsqhDvbqQ==
X-Received: by 2002:adf:cd09:: with SMTP id w9mr8854725wrm.242.1558359662928;
        Mon, 20 May 2019 06:41:02 -0700 (PDT)
Received: from 640k.lan ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id a10sm20296423wrm.94.2019.05.20.06.41.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 May 2019 06:41:02 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH] KVM: x86: do not spam dmesg with VMCS/VMCB dumps
Date:   Mon, 20 May 2019 15:41:01 +0200
Message-Id: <1558359661-17796-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Userspace can easily set up invalid processor state in such a way that
dmesg will be filled with VMCS or VMCB dumps.  Disable this by default
using a module parameter.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm.c     |  9 ++++++++-
 arch/x86/kvm/vmx/vmx.c | 26 +++++++++++++++++++-------
 2 files changed, 27 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index a9e553a1317f..735b8c01895e 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -379,6 +379,9 @@ struct amd_svm_iommu_ir {
 static int sev = IS_ENABLED(CONFIG_AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT);
 module_param(sev, int, 0444);
 
+static bool __read_mostly dump_invalid_vmcb = 0;
+module_param(dump_invalid_vmcb, bool, 0644);
+
 static u8 rsm_ins_bytes[] = "\x0f\xaa";
 
 static void svm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0);
@@ -4828,6 +4831,11 @@ static void dump_vmcb(struct kvm_vcpu *vcpu)
 	struct vmcb_control_area *control = &svm->vmcb->control;
 	struct vmcb_save_area *save = &svm->vmcb->save;
 
+	if (!dump_invalid_vmcb) {
+		pr_warn_ratelimited("set kvm_amd.dump_invalid_vmcb=1 to dump internal KVM state.\n");
+		return;
+	}
+
 	pr_err("VMCB Control Area:\n");
 	pr_err("%-20s%04x\n", "cr_read:", control->intercept_cr & 0xffff);
 	pr_err("%-20s%04x\n", "cr_write:", control->intercept_cr >> 16);
@@ -4986,7 +4994,6 @@ static int handle_exit(struct kvm_vcpu *vcpu)
 		kvm_run->exit_reason = KVM_EXIT_FAIL_ENTRY;
 		kvm_run->fail_entry.hardware_entry_failure_reason
 			= svm->vmcb->control.exit_code;
-		pr_err("KVM: FAILED VMRUN WITH VMCB:\n");
 		dump_vmcb(vcpu);
 		return 0;
 	}
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 1ac167614032..b93e36ddee5e 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -114,6 +114,9 @@
 bool __read_mostly enable_pml = 1;
 module_param_named(pml, enable_pml, bool, S_IRUGO);
 
+static bool __read_mostly dump_invalid_vmcs = 0;
+module_param(dump_invalid_vmcs, bool, 0644);
+
 #define MSR_BITMAP_MODE_X2APIC		1
 #define MSR_BITMAP_MODE_X2APIC_APICV	2
 
@@ -5607,15 +5610,24 @@ static void vmx_dump_dtsel(char *name, uint32_t limit)
 
 void dump_vmcs(void)
 {
-	u32 vmentry_ctl = vmcs_read32(VM_ENTRY_CONTROLS);
-	u32 vmexit_ctl = vmcs_read32(VM_EXIT_CONTROLS);
-	u32 cpu_based_exec_ctrl = vmcs_read32(CPU_BASED_VM_EXEC_CONTROL);
-	u32 pin_based_exec_ctrl = vmcs_read32(PIN_BASED_VM_EXEC_CONTROL);
-	u32 secondary_exec_control = 0;
-	unsigned long cr4 = vmcs_readl(GUEST_CR4);
-	u64 efer = vmcs_read64(GUEST_IA32_EFER);
+	u32 vmentry_ctl, vmexit_ctl;
+	u32 cpu_based_exec_ctrl, pin_based_exec_ctrl, secondary_exec_control;
+	unsigned long cr4;
+	u64 efer;
 	int i, n;
 
+	if (!dump_invalid_vmcs) {
+		pr_warn_ratelimited("set kvm_intel.dump_invalid_vmcs=1 to dump internal KVM state.\n");
+		return;
+	}
+
+	vmentry_ctl = vmcs_read32(VM_ENTRY_CONTROLS);
+	vmexit_ctl = vmcs_read32(VM_EXIT_CONTROLS);
+	cpu_based_exec_ctrl = vmcs_read32(CPU_BASED_VM_EXEC_CONTROL);
+	pin_based_exec_ctrl = vmcs_read32(PIN_BASED_VM_EXEC_CONTROL);
+	cr4 = vmcs_readl(GUEST_CR4);
+	efer = vmcs_read64(GUEST_IA32_EFER);
+	secondary_exec_control = 0;
 	if (cpu_has_secondary_exec_ctrls())
 		secondary_exec_control = vmcs_read32(SECONDARY_VM_EXEC_CONTROL);
 
-- 
1.8.3.1

