Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 179F21EF6E9
	for <lists+kvm@lfdr.de>; Fri,  5 Jun 2020 13:59:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726499AbgFEL7V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Jun 2020 07:59:21 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:44900 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726324AbgFEL7R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Jun 2020 07:59:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591358355;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=mxwh1xC29UBQwrK34p7n7N+1k3tNOzXKm1hVG0/SjCw=;
        b=h8wJ57xqCs5bEqD9odQsTzWsdKaPOHGIWdzTlA/jw9qtMx4qAHXgjO8bB5aUacIzL90Tgl
        s/BmODxjausiiW/nQENYFWCaS5biIKTV6Cn+c2o6u8/IkcAY7SOd9xTthn3LV+E4Vb0HSt
        iR2HQR2NjlrZ3TOrXqEc70pqfGAb1Qc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-455-kdWgtLIDPkmc42XH3ejItg-1; Fri, 05 Jun 2020 07:59:11 -0400
X-MC-Unique: kdWgtLIDPkmc42XH3ejItg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4C5C88018A7;
        Fri,  5 Jun 2020 11:59:10 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.93])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B45915D9DA;
        Fri,  5 Jun 2020 11:59:07 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] KVM: nVMX: Properly handle kvm_read/write_guest_virt*() result
Date:   Fri,  5 Jun 2020 13:59:05 +0200
Message-Id: <20200605115906.532682-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Syzbot reports the following issue:

WARNING: CPU: 0 PID: 6819 at arch/x86/kvm/x86.c:618
 kvm_inject_emulated_page_fault+0x210/0x290 arch/x86/kvm/x86.c:618
...
Call Trace:
...
RIP: 0010:kvm_inject_emulated_page_fault+0x210/0x290 arch/x86/kvm/x86.c:618
...
 nested_vmx_get_vmptr+0x1f9/0x2a0 arch/x86/kvm/vmx/nested.c:4638
 handle_vmon arch/x86/kvm/vmx/nested.c:4767 [inline]
 handle_vmon+0x168/0x3a0 arch/x86/kvm/vmx/nested.c:4728
 vmx_handle_exit+0x29c/0x1260 arch/x86/kvm/vmx/vmx.c:6067

'exception' we're trying to inject with kvm_inject_emulated_page_fault()
comes from:

  nested_vmx_get_vmptr()
   kvm_read_guest_virt()
     kvm_read_guest_virt_helper()
       vcpu->arch.walk_mmu->gva_to_gpa()

but it is only set when GVA to GPA conversion fails. In case it doesn't but
we still fail kvm_vcpu_read_guest_page(), X86EMUL_IO_NEEDED is returned and
nested_vmx_get_vmptr() calls kvm_inject_emulated_page_fault() with zeroed
'exception'. This happen when the argument is MMIO.

Paolo also noticed that nested_vmx_get_vmptr() is not the only place in
KVM code where kvm_read/write_guest_virt*() return result is mishandled.
All VMX instructions along with INVPCID/INVVPID/INVEPT have the same
issue. This was already noticed before, e.g. see commit 541ab2aeb282 ("KVM:
x86: work around leak of uninitialized stack contents") but was never fully
fixed.

KVM could've handled the request correctly by going to userspace and
performing I/O but there doesn't seem to be a good need for such requests
in the first place.

Introduce vmx_handle_memory_failure() as an interim solution.

Note, nested_vmx_get_vmptr() now has three possible outcomes: OK, PF,
KVM_EXIT_INTERNAL_ERROR and callers need to know if userspace exit is
needed (for KVM_EXIT_INTERNAL_ERROR) in case of failure. We don't seem
to have a good enum describing this tristate, just add "int *ret" to
nested_vmx_get_vmptr() interface to pass the information.

Reported-by: syzbot+2a7156e11dc199bdbd8a@syzkaller.appspotmail.com
Suggested-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/vmx/nested.c | 78 +++++++++++++++++++++------------------
 arch/x86/kvm/vmx/vmx.c    | 34 +++++++++++++++--
 arch/x86/kvm/vmx/vmx.h    |  2 +
 3 files changed, 74 insertions(+), 40 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 9c74a732b08d..bcb50724be38 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4624,19 +4624,24 @@ void nested_vmx_pmu_entry_exit_ctls_update(struct kvm_vcpu *vcpu)
 	}
 }
 
-static int nested_vmx_get_vmptr(struct kvm_vcpu *vcpu, gpa_t *vmpointer)
+static int nested_vmx_get_vmptr(struct kvm_vcpu *vcpu, gpa_t *vmpointer,
+				int *ret)
 {
 	gva_t gva;
 	struct x86_exception e;
+	int r;
 
 	if (get_vmx_mem_address(vcpu, vmx_get_exit_qual(vcpu),
 				vmcs_read32(VMX_INSTRUCTION_INFO), false,
-				sizeof(*vmpointer), &gva))
-		return 1;
+				sizeof(*vmpointer), &gva)) {
+		*ret = 1;
+		return -EINVAL;
+	}
 
-	if (kvm_read_guest_virt(vcpu, gva, vmpointer, sizeof(*vmpointer), &e)) {
-		kvm_inject_emulated_page_fault(vcpu, &e);
-		return 1;
+	r = kvm_read_guest_virt(vcpu, gva, vmpointer, sizeof(*vmpointer), &e);
+	if (r != X86EMUL_CONTINUE) {
+		*ret = vmx_handle_memory_failure(vcpu, r, &e);
+		return -EINVAL;
 	}
 
 	return 0;
@@ -4764,8 +4769,8 @@ static int handle_vmon(struct kvm_vcpu *vcpu)
 		return 1;
 	}
 
-	if (nested_vmx_get_vmptr(vcpu, &vmptr))
-		return 1;
+	if (nested_vmx_get_vmptr(vcpu, &vmptr, &ret))
+		return ret;
 
 	/*
 	 * SDM 3: 24.11.5
@@ -4838,12 +4843,13 @@ static int handle_vmclear(struct kvm_vcpu *vcpu)
 	u32 zero = 0;
 	gpa_t vmptr;
 	u64 evmcs_gpa;
+	int r;
 
 	if (!nested_vmx_check_permission(vcpu))
 		return 1;
 
-	if (nested_vmx_get_vmptr(vcpu, &vmptr))
-		return 1;
+	if (nested_vmx_get_vmptr(vcpu, &vmptr, &r))
+		return r;
 
 	if (!page_address_valid(vcpu, vmptr))
 		return nested_vmx_failValid(vcpu,
@@ -4902,7 +4908,7 @@ static int handle_vmread(struct kvm_vcpu *vcpu)
 	u64 value;
 	gva_t gva = 0;
 	short offset;
-	int len;
+	int len, r;
 
 	if (!nested_vmx_check_permission(vcpu))
 		return 1;
@@ -4943,10 +4949,9 @@ static int handle_vmread(struct kvm_vcpu *vcpu)
 					instr_info, true, len, &gva))
 			return 1;
 		/* _system ok, nested_vmx_check_permission has verified cpl=0 */
-		if (kvm_write_guest_virt_system(vcpu, gva, &value, len, &e)) {
-			kvm_inject_emulated_page_fault(vcpu, &e);
-			return 1;
-		}
+		r = kvm_write_guest_virt_system(vcpu, gva, &value, len, &e);
+		if (r != X86EMUL_CONTINUE)
+			return vmx_handle_memory_failure(vcpu, r, &e);
 	}
 
 	return nested_vmx_succeed(vcpu);
@@ -4987,7 +4992,7 @@ static int handle_vmwrite(struct kvm_vcpu *vcpu)
 	unsigned long field;
 	short offset;
 	gva_t gva;
-	int len;
+	int len, r;
 
 	/*
 	 * The value to write might be 32 or 64 bits, depending on L1's long
@@ -5017,10 +5022,9 @@ static int handle_vmwrite(struct kvm_vcpu *vcpu)
 		if (get_vmx_mem_address(vcpu, exit_qualification,
 					instr_info, false, len, &gva))
 			return 1;
-		if (kvm_read_guest_virt(vcpu, gva, &value, len, &e)) {
-			kvm_inject_emulated_page_fault(vcpu, &e);
-			return 1;
-		}
+		r = kvm_read_guest_virt(vcpu, gva, &value, len, &e);
+		if (r != X86EMUL_CONTINUE)
+			return vmx_handle_memory_failure(vcpu, r, &e);
 	}
 
 	field = kvm_register_readl(vcpu, (((instr_info) >> 28) & 0xf));
@@ -5103,12 +5107,13 @@ static int handle_vmptrld(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	gpa_t vmptr;
+	int r;
 
 	if (!nested_vmx_check_permission(vcpu))
 		return 1;
 
-	if (nested_vmx_get_vmptr(vcpu, &vmptr))
-		return 1;
+	if (nested_vmx_get_vmptr(vcpu, &vmptr, &r))
+		return r;
 
 	if (!page_address_valid(vcpu, vmptr))
 		return nested_vmx_failValid(vcpu,
@@ -5170,6 +5175,7 @@ static int handle_vmptrst(struct kvm_vcpu *vcpu)
 	gpa_t current_vmptr = to_vmx(vcpu)->nested.current_vmptr;
 	struct x86_exception e;
 	gva_t gva;
+	int r;
 
 	if (!nested_vmx_check_permission(vcpu))
 		return 1;
@@ -5181,11 +5187,11 @@ static int handle_vmptrst(struct kvm_vcpu *vcpu)
 				true, sizeof(gpa_t), &gva))
 		return 1;
 	/* *_system ok, nested_vmx_check_permission has verified cpl=0 */
-	if (kvm_write_guest_virt_system(vcpu, gva, (void *)&current_vmptr,
-					sizeof(gpa_t), &e)) {
-		kvm_inject_emulated_page_fault(vcpu, &e);
-		return 1;
-	}
+	r = kvm_write_guest_virt_system(vcpu, gva, (void *)&current_vmptr,
+					sizeof(gpa_t), &e);
+	if (r != X86EMUL_CONTINUE)
+		return vmx_handle_memory_failure(vcpu, r, &e);
+
 	return nested_vmx_succeed(vcpu);
 }
 
@@ -5209,7 +5215,7 @@ static int handle_invept(struct kvm_vcpu *vcpu)
 	struct {
 		u64 eptp, gpa;
 	} operand;
-	int i;
+	int i, r;
 
 	if (!(vmx->nested.msrs.secondary_ctls_high &
 	      SECONDARY_EXEC_ENABLE_EPT) ||
@@ -5236,10 +5242,9 @@ static int handle_invept(struct kvm_vcpu *vcpu)
 	if (get_vmx_mem_address(vcpu, vmx_get_exit_qual(vcpu),
 			vmx_instruction_info, false, sizeof(operand), &gva))
 		return 1;
-	if (kvm_read_guest_virt(vcpu, gva, &operand, sizeof(operand), &e)) {
-		kvm_inject_emulated_page_fault(vcpu, &e);
-		return 1;
-	}
+	r = kvm_read_guest_virt(vcpu, gva, &operand, sizeof(operand), &e);
+	if (r != X86EMUL_CONTINUE)
+		return vmx_handle_memory_failure(vcpu, r, &e);
 
 	/*
 	 * Nested EPT roots are always held through guest_mmu,
@@ -5291,6 +5296,7 @@ static int handle_invvpid(struct kvm_vcpu *vcpu)
 		u64 gla;
 	} operand;
 	u16 vpid02;
+	int r;
 
 	if (!(vmx->nested.msrs.secondary_ctls_high &
 	      SECONDARY_EXEC_ENABLE_VPID) ||
@@ -5318,10 +5324,10 @@ static int handle_invvpid(struct kvm_vcpu *vcpu)
 	if (get_vmx_mem_address(vcpu, vmx_get_exit_qual(vcpu),
 			vmx_instruction_info, false, sizeof(operand), &gva))
 		return 1;
-	if (kvm_read_guest_virt(vcpu, gva, &operand, sizeof(operand), &e)) {
-		kvm_inject_emulated_page_fault(vcpu, &e);
-		return 1;
-	}
+	r = kvm_read_guest_virt(vcpu, gva, &operand, sizeof(operand), &e);
+	if (r != X86EMUL_CONTINUE)
+		return vmx_handle_memory_failure(vcpu, r, &e);
+
 	if (operand.vpid >> 16)
 		return nested_vmx_failValid(vcpu,
 			VMXERR_INVALID_OPERAND_TO_INVEPT_INVVPID);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 170cc76a581f..d9083f80ec87 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1600,6 +1600,32 @@ static int skip_emulated_instruction(struct kvm_vcpu *vcpu)
 	return 1;
 }
 
+/*
+ * Handles kvm_read/write_guest_virt*() result and either injects #PF or returns
+ * KVM_EXIT_INTERNAL_ERROR for cases not currently handled by KVM. Return value
+ * indicates whether exit to userspace is needed.
+ */
+int vmx_handle_memory_failure(struct kvm_vcpu *vcpu, int r,
+			      struct x86_exception *e)
+{
+	if (r == X86EMUL_PROPAGATE_FAULT) {
+		kvm_inject_emulated_page_fault(vcpu, e);
+		return 1;
+	}
+
+	/*
+	 * In case kvm_read/write_guest_virt*() failed with X86EMUL_IO_NEEDED
+	 * while handling a VMX instruction KVM could've handled the request
+	 * correctly by exiting to userspace and performing I/O but there
+	 * doesn't seem to be a real use-case behind such requests, just return
+	 * KVM_EXIT_INTERNAL_ERROR for now.
+	 */
+	vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
+	vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_EMULATION;
+	vcpu->run->internal.ndata = 0;
+
+	return 0;
+}
 
 /*
  * Recognizes a pending MTF VM-exit and records the nested state for later
@@ -5486,6 +5512,7 @@ static int handle_invpcid(struct kvm_vcpu *vcpu)
 		u64 pcid;
 		u64 gla;
 	} operand;
+	int r;
 
 	if (!guest_cpuid_has(vcpu, X86_FEATURE_INVPCID)) {
 		kvm_queue_exception(vcpu, UD_VECTOR);
@@ -5508,10 +5535,9 @@ static int handle_invpcid(struct kvm_vcpu *vcpu)
 				sizeof(operand), &gva))
 		return 1;
 
-	if (kvm_read_guest_virt(vcpu, gva, &operand, sizeof(operand), &e)) {
-		kvm_inject_emulated_page_fault(vcpu, &e);
-		return 1;
-	}
+	r = kvm_read_guest_virt(vcpu, gva, &operand, sizeof(operand), &e);
+	if (r != X86EMUL_CONTINUE)
+		return vmx_handle_memory_failure(vcpu, r, &e);
 
 	if (operand.pcid >> 12 != 0) {
 		kvm_inject_gp(vcpu, 0);
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 672c28f17e49..8a83b5edc820 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -355,6 +355,8 @@ struct shared_msr_entry *find_msr_entry(struct vcpu_vmx *vmx, u32 msr);
 void pt_update_intercept_for_msr(struct vcpu_vmx *vmx);
 void vmx_update_host_rsp(struct vcpu_vmx *vmx, unsigned long host_rsp);
 int vmx_find_msr_index(struct vmx_msrs *m, u32 msr);
+int vmx_handle_memory_failure(struct kvm_vcpu *vcpu, int r,
+			      struct x86_exception *e);
 
 #define POSTED_INTR_ON  0
 #define POSTED_INTR_SN  1
-- 
2.25.4

