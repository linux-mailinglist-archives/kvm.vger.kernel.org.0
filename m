Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D07821ED9B0
	for <lists+kvm@lfdr.de>; Thu,  4 Jun 2020 01:57:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726385AbgFCX4p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Jun 2020 19:56:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726496AbgFCX4n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Jun 2020 19:56:43 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6212FC08C5C1
        for <kvm@vger.kernel.org>; Wed,  3 Jun 2020 16:56:42 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id c17so5818881ybf.7
        for <kvm@vger.kernel.org>; Wed, 03 Jun 2020 16:56:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=GDC7mHVEx9J0qsxVbqJ+q0YDuEWFn7Rk7hUHvs3vmKc=;
        b=trjmkU/kEsi1M62waF9MP7VyMYned5dRZzxppbzW2Q6NlE+0YViNLdYpfD9AHspyvh
         oWCFyQ7kLr8S2bNGUadGPtqUh1A0Pi2alZr067sZTy84U1lg6hVZM6iIPC0NcuYniCEX
         6ARK31dpAS3rlor8bVPEg0IWjXkR47JH4DJKDuGLd8xxqBhPflIwtF3PNGNgzsbXCvsd
         pi+ofnfH/OmZA1iOpe3VWRMCTIDne5HasSruYfckmPe4YmKb1p07CUvkbg/9vwaCDhm9
         dJBpant7ARCQ7vCd8Hwb0z24Z2vjbVwQI1XTkMk9QfN59S7MGZw3VzYGipbXnV/AZ+aF
         wYsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=GDC7mHVEx9J0qsxVbqJ+q0YDuEWFn7Rk7hUHvs3vmKc=;
        b=jAwBLo3WNkqzVEGl2wcTnR390O9azz8Q15PfW2eCBTw+Oph8Yvy6Mau8M26Zgzme8Q
         IN9zj/33fupZiunoPQk+7LYhj+Qp/NfKYWPCYBbAi9S1507zXqtIRvDObLAXasccZqG6
         0JRS4xsC7i9kUMaJjQD5MlaJgKPUJmAkFzxK6t1tuKM4zQgozAlaYZ7R9zLx9LKcbs9D
         lyZj32AH88hCqddukf68T0hqOMBxxz1R0QjAgr3fnQ4NFyIeVY7+4fm0ZsFNzP+lCGR0
         m5VntQ9/4QGU1k7tS+kNjZC/nVWOqZjDgJfid5KvsbrYl+3MCMHWz5/zZVYfD50AphUy
         XBjQ==
X-Gm-Message-State: AOAM530lxCOJhbCG9gn1yswNu+KcJjBYNAHLrbo54TUYhqPUU+DXqO2C
        7eKOd8boeQGUrJ7g9i2TNIoYe3WejmnkMfqZn4CNxs3N05hFMdmgemsD1riU0FsBNjLqPCirH3+
        zdSWF6XO0Hm3C/O/QOu/KT59uByMNuQ2APE2LAjWOrc9hFXRJ6Mhqh7bBtYBqgEY=
X-Google-Smtp-Source: ABdhPJz3qCQdGUWwWh1fTxeQefa7Vf6LCGZnLvE/if9U0e05K8zJh9wBwBLM4MIDNQHrUYcE3dNv7QVW0017qw==
X-Received: by 2002:a25:b8cb:: with SMTP id g11mr3675334ybm.189.1591228601575;
 Wed, 03 Jun 2020 16:56:41 -0700 (PDT)
Date:   Wed,  3 Jun 2020 16:56:22 -0700
In-Reply-To: <20200603235623.245638-1-jmattson@google.com>
Message-Id: <20200603235623.245638-6-jmattson@google.com>
Mime-Version: 1.0
References: <20200603235623.245638-1-jmattson@google.com>
X-Mailer: git-send-email 2.27.0.rc2.251.g90737beb825-goog
Subject: [PATCH v4 5/6] kvm: x86: Move last_cpu into kvm_vcpu_arch as last_vmentry_cpu
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Liran Alon <liran.alon@oracle.com>,
        Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Both the vcpu_vmx structure and the vcpu_svm structure have a
'last_cpu' field. Move the common field into the kvm_vcpu_arch
structure. For clarity, rename it to 'last_vmentry_cpu.'

Suggested-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Oliver Upton <oupton@google.com>
Reviewed-by: Peter Shier <pshier@google.com>
---
 arch/x86/include/asm/kvm_host.h |  3 +++
 arch/x86/kvm/svm/sev.c          |  2 +-
 arch/x86/kvm/svm/svm.c          |  6 +++---
 arch/x86/kvm/svm/svm.h          |  3 ---
 arch/x86/kvm/vmx/vmx.c          | 12 ++++++------
 arch/x86/kvm/vmx/vmx.h          |  3 ---
 6 files changed, 13 insertions(+), 16 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 58337a25396a..fa33b0f8028f 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -827,6 +827,9 @@ struct kvm_vcpu_arch {
 	/* Flush the L1 Data cache for L1TF mitigation on VMENTER */
 	bool l1tf_flush_l1d;
 
+	/* Host CPU on which VM-entry was most recently attempted */
+	unsigned int last_vmentry_cpu;
+
 	/* AMD MSRC001_0015 Hardware Configuration */
 	u64 msr_hwcr;
 };
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index aa61d5d1e7f3..126d9014635a 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1181,7 +1181,7 @@ void pre_sev_run(struct vcpu_svm *svm, int cpu)
 	 * 2) or this VMCB was executed on different host CPU in previous VMRUNs.
 	 */
 	if (sd->sev_vmcbs[asid] == svm->vmcb &&
-	    svm->last_cpu == cpu)
+	    svm->vcpu.arch.last_vmentry_cpu == cpu)
 		return;
 
 	sd->sev_vmcbs[asid] = svm->vmcb;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 938be4172bab..78b64d1ab7b1 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2945,7 +2945,7 @@ static int handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 		kvm_run->exit_reason = KVM_EXIT_FAIL_ENTRY;
 		kvm_run->fail_entry.hardware_entry_failure_reason
 			= svm->vmcb->control.exit_code;
-		kvm_run->fail_entry.cpu = svm->last_cpu;
+		kvm_run->fail_entry.cpu = vcpu->arch.last_vmentry_cpu;
 		dump_vmcb(vcpu);
 		return 0;
 	}
@@ -2971,7 +2971,7 @@ static int handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 			KVM_INTERNAL_ERROR_UNEXPECTED_EXIT_REASON;
 		vcpu->run->internal.ndata = 2;
 		vcpu->run->internal.data[0] = exit_code;
-		vcpu->run->internal.data[1] = svm->last_cpu;
+		vcpu->run->internal.data[1] = vcpu->arch.last_vmentry_cpu;
 		return 0;
 	}
 
@@ -3396,7 +3396,7 @@ static fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
 	 */
 	x86_spec_ctrl_set_guest(svm->spec_ctrl, svm->virt_spec_ctrl);
 
-	svm->last_cpu = vcpu->cpu;
+	vcpu->arch.last_vmentry_cpu = vcpu->cpu;
 	__svm_vcpu_run(svm->vmcb_pa, (unsigned long *)&svm->vcpu.arch.regs);
 
 #ifdef CONFIG_X86_64
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 6ac4c00a5d82..613356f85da6 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -158,9 +158,6 @@ struct vcpu_svm {
 	 */
 	struct list_head ir_list;
 	spinlock_t ir_list_lock;
-
-	/* which host CPU was used for running this vcpu */
-	unsigned int last_cpu;
 };
 
 struct svm_cpu_data {
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index da5490b94704..562381073c40 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4762,7 +4762,7 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
 		vcpu->run->internal.data[0] = vect_info;
 		vcpu->run->internal.data[1] = intr_info;
 		vcpu->run->internal.data[2] = error_code;
-		vcpu->run->internal.data[3] = vmx->last_cpu;
+		vcpu->run->internal.data[3] = vcpu->arch.last_vmentry_cpu;
 		return 0;
 	}
 
@@ -5984,7 +5984,7 @@ static int vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 		vcpu->run->exit_reason = KVM_EXIT_FAIL_ENTRY;
 		vcpu->run->fail_entry.hardware_entry_failure_reason
 			= exit_reason;
-		vcpu->run->fail_entry.cpu = vmx->last_cpu;
+		vcpu->run->fail_entry.cpu = vcpu->arch.last_vmentry_cpu;
 		return 0;
 	}
 
@@ -5993,7 +5993,7 @@ static int vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 		vcpu->run->exit_reason = KVM_EXIT_FAIL_ENTRY;
 		vcpu->run->fail_entry.hardware_entry_failure_reason
 			= vmcs_read32(VM_INSTRUCTION_ERROR);
-		vcpu->run->fail_entry.cpu = vmx->last_cpu;
+		vcpu->run->fail_entry.cpu = vcpu->arch.last_vmentry_cpu;
 		return 0;
 	}
 
@@ -6021,7 +6021,7 @@ static int vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 				vmcs_read64(GUEST_PHYSICAL_ADDRESS);
 		}
 		vcpu->run->internal.data[vcpu->run->internal.ndata++] =
-			vmx->last_cpu;
+			vcpu->arch.last_vmentry_cpu;
 		return 0;
 	}
 
@@ -6079,7 +6079,7 @@ static int vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 			KVM_INTERNAL_ERROR_UNEXPECTED_EXIT_REASON;
 	vcpu->run->internal.ndata = 2;
 	vcpu->run->internal.data[0] = exit_reason;
-	vcpu->run->internal.data[1] = vmx->last_cpu;
+	vcpu->run->internal.data[1] = vcpu->arch.last_vmentry_cpu;
 	return 0;
 }
 
@@ -6736,7 +6736,7 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
 	if (vcpu->arch.cr2 != read_cr2())
 		write_cr2(vcpu->arch.cr2);
 
-	vmx->last_cpu = vcpu->cpu;
+	vcpu->arch.last_vmentry_cpu = vcpu->cpu;
 	vmx->fail = __vmx_vcpu_run(vmx, (unsigned long *)&vcpu->arch.regs,
 				   vmx->loaded_vmcs->launched);
 
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 8a1e833cf4fb..672c28f17e49 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -302,9 +302,6 @@ struct vcpu_vmx {
 	u64 ept_pointer;
 
 	struct pt_desc pt_desc;
-
-	/* which host CPU was used for running this vcpu */
-	unsigned int last_cpu;
 };
 
 enum ept_pointers_status {
-- 
2.27.0.rc2.251.g90737beb825-goog

