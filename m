Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B89F6166E6
	for <lists+kvm@lfdr.de>; Tue,  7 May 2019 17:36:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726931AbfEGPgc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 May 2019 11:36:32 -0400
Received: from mga11.intel.com ([192.55.52.93]:51035 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726000AbfEGPgc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 May 2019 11:36:32 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 May 2019 08:36:31 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.181])
  by fmsmga006.fm.intel.com with ESMTP; 07 May 2019 08:36:31 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     kvm@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Liran Alon <liran.alon@oracle.com>
Subject: [PATCH 2/7] KVM: nVMX: Intercept VMWRITEs to GUEST_{CS,SS}_AR_BYTES
Date:   Tue,  7 May 2019 08:36:24 -0700
Message-Id: <20190507153629.3681-3-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190507153629.3681-1-sean.j.christopherson@intel.com>
References: <20190507153629.3681-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

VMMs frequently read the guest's CS and SS AR bytes to detect 64-bit
mode and CPL respectively, but effectively never write said fields once
the VM is initialized.  Intercepting VMWRITEs for the two fields saves
~55 cycles in copy_shadow_to_vmcs12().

Because some Intel CPUs, e.g. Haswell, drop the reserved bits of the
guest access rights fields on VMWRITE, exposing the fields to L1 for
VMREAD but not VMWRITE leads to inconsistent behavior between L1 and L2.
On hardware that drops the bits, L1 will see the stripped down value due
to reading the value from hardware, while L2 will see the full original
value as stored by KVM.  To avoid such an inconsistency, emulate the
behavior on all CPUS, but only for intercepted VMWRITEs so as to avoid
introducing pointless latency into copy_shadow_to_vmcs12(), e.g. if the
emulation were added to vmcs12_write_any().

Since the AR_BYTES emulation is done only for intercepted VMWRITE, if a
future patch (re)exposed AR_BYTES for both VMWRITE and VMREAD, then KVM
would end up with incosistent behavior on pre-Haswell hardware, e.g. KVM
would drop the reserved bits on intercepted VMWRITE, but direct VMWRITE
to the shadow VMCS would not drop the bits.  Add a WARN in the shadow
field initialization to detect any attempt to expose an AR_BYTES field
without updating vmcs12_write_any().

Note, emulation of the AR_BYTES reserved bit behavior is based on a
patch[1] from Jim Mattson that applied the emulation to all writes to
vmcs12 so that live migration across different generations of hardware
would not introduce divergent behavior.  But given that live migration
of nested state has already been enabled, that ship has sailed (not to
mention that no sane VMM will be affected by this behavior).

[1] https://patchwork.kernel.org/patch/10483321/

Cc: Jim Mattson <jmattson@google.com>
Cc: Liran Alon <liran.alon@oracle.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/nested.c             | 15 +++++++++++++++
 arch/x86/kvm/vmx/vmcs_shadow_fields.h |  4 ++--
 2 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 1f7c4af70903..9310c6db9e80 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -91,6 +91,10 @@ static void init_vmcs_shadow_fields(void)
 			pr_err("Missing field from shadow_read_write_field %x\n",
 			       field + 1);
 
+		WARN_ONCE(field >= GUEST_ES_AR_BYTES &&
+			  field <= GUEST_TR_AR_BYTES,
+			  "Update vmcs12_write_any() to expose AR_BYTES RW");
+
 		/*
 		 * PML and the preemption timer can be emulated, but the
 		 * processor cannot vmwrite to fields that don't exist
@@ -4471,6 +4475,17 @@ static int handle_vmwrite(struct kvm_vcpu *vcpu)
 		vmcs12 = get_shadow_vmcs12(vcpu);
 	}
 
+	/*
+	 * Some Intel CPUs intentionally drop the reserved bits of the AR byte
+	 * fields on VMWRITE.  Emulate this behavior to ensure consistent KVM
+	 * behavior regardless of the underlying hardware, e.g. if an AR_BYTE
+	 * field is intercepted for VMWRITE but not VMREAD (in L1), then VMREAD
+	 * from L1 will return a different value than VMREAD from L2 (L1 sees
+	 * the stripped down value, L2 sees the full value as stored by KVM).
+	 */
+	if (field >= GUEST_ES_AR_BYTES && field <= GUEST_TR_AR_BYTES)
+		field_value &= 0x1f0ff;
+
 	if (vmcs12_write_any(vmcs12, field, field_value) < 0)
 		return nested_vmx_failValid(vcpu,
 			VMXERR_UNSUPPORTED_VMCS_COMPONENT);
diff --git a/arch/x86/kvm/vmx/vmcs_shadow_fields.h b/arch/x86/kvm/vmx/vmcs_shadow_fields.h
index 132432f375c2..97dd5295be31 100644
--- a/arch/x86/kvm/vmx/vmcs_shadow_fields.h
+++ b/arch/x86/kvm/vmx/vmcs_shadow_fields.h
@@ -40,14 +40,14 @@ SHADOW_FIELD_RO(VM_EXIT_INSTRUCTION_LEN)
 SHADOW_FIELD_RO(IDT_VECTORING_INFO_FIELD)
 SHADOW_FIELD_RO(IDT_VECTORING_ERROR_CODE)
 SHADOW_FIELD_RO(VM_EXIT_INTR_ERROR_CODE)
+SHADOW_FIELD_RO(GUEST_CS_AR_BYTES)
+SHADOW_FIELD_RO(GUEST_SS_AR_BYTES)
 SHADOW_FIELD_RW(CPU_BASED_VM_EXEC_CONTROL)
 SHADOW_FIELD_RW(EXCEPTION_BITMAP)
 SHADOW_FIELD_RW(VM_ENTRY_EXCEPTION_ERROR_CODE)
 SHADOW_FIELD_RW(VM_ENTRY_INTR_INFO_FIELD)
 SHADOW_FIELD_RW(VM_ENTRY_INSTRUCTION_LEN)
 SHADOW_FIELD_RW(TPR_THRESHOLD)
-SHADOW_FIELD_RW(GUEST_CS_AR_BYTES)
-SHADOW_FIELD_RW(GUEST_SS_AR_BYTES)
 SHADOW_FIELD_RW(GUEST_INTERRUPTIBILITY_INFO)
 SHADOW_FIELD_RW(VMX_PREEMPTION_TIMER_VALUE)
 
-- 
2.21.0

