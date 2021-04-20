Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D557936575C
	for <lists+kvm@lfdr.de>; Tue, 20 Apr 2021 13:20:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231621AbhDTLUx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Apr 2021 07:20:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21998 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231309AbhDTLUp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 20 Apr 2021 07:20:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618917614;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=tyZposn6UrVgl3kX+dZoOBqzz3tb6Zptt4NBxTo0Y80=;
        b=P/7JbMzCXaxEDD0k7IqjQkvCTZ/rkHcjuXae0pvuacqV3hNjLsu1WR2vorXgKy980pX8Ne
        nj3bhvyxb73Svy+Ii359/DcuIijbqtuGT1v+4vw7B7yH/7WooHG9+YItl8bBt7Ig/+vHG8
        FdY64KpMsljGaYlwil0Sr1GcC7M9Q3I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-589-XqYVblC6MlaLTDs9A8mytA-1; Tue, 20 Apr 2021 07:20:10 -0400
X-MC-Unique: XqYVblC6MlaLTDs9A8mytA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3D52E1006C80;
        Tue, 20 Apr 2021 11:20:08 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id ED9505D9C0;
        Tue, 20 Apr 2021 11:20:06 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com, srutherford@google.com, joro@8bytes.org,
        brijesh.singh@amd.com, thomas.lendacky@amd.com,
        venu.busireddy@oracle.com, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@suse.de>,
        x86@kernel.org, Ashish Kalra <ashish.kalra@amd.com>
Subject: [PATCH 0/3] KVM: x86: guest interface for SEV live migration
Date:   Tue, 20 Apr 2021 07:20:06 -0400
Message-Id: <20210420112006.741541-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is a reviewed version of the guest interface (hypercall+MSR)
for SEV live migration.  The differences lie mostly in the API
for userspace.  In particular:

- the CPUID feature is not exposed in KVM_GET_SUPPORTED_CPUID

- the hypercall must be enabled manually with KVM_ENABLE_CAP

- the MSR has sensible behavior if not filtered (reads as zero,
  writes must leave undefined bits as zero or they #GP)

Patch 1 is an unrelated cleanup, that was made moot by not
exposing the bit in KVM_GET_SUPPORTED_CPUID.

Paolo

Ashish Kalra (1):
  KVM: X86: Introduce KVM_HC_PAGE_ENC_STATUS hypercall

Paolo Bonzini (2):
  KVM: SEV: mask CPUID[0x8000001F].eax according to supported features
  KVM: x86: add MSR_KVM_MIGRATION_CONTROL

 Documentation/virt/kvm/api.rst        | 11 ++++++
 Documentation/virt/kvm/cpuid.rst      |  6 ++++
 Documentation/virt/kvm/hypercalls.rst | 15 +++++++++
 Documentation/virt/kvm/msr.rst        | 10 ++++++
 arch/x86/include/asm/kvm_host.h       |  2 ++
 arch/x86/include/uapi/asm/kvm_para.h  |  4 +++
 arch/x86/kvm/cpuid.c                  |  5 ++-
 arch/x86/kvm/cpuid.h                  |  1 +
 arch/x86/kvm/svm/svm.c                |  7 ++++
 arch/x86/kvm/x86.c                    | 48 +++++++++++++++++++++++++++
 include/uapi/linux/kvm.h              |  1 +
 include/uapi/linux/kvm_para.h         |  1 +
 12 files changed, 110 insertions(+), 1 deletion(-)

-- 
2.26.2

From 547d4d4edcd05fdfac6ce650d65db1d42bcd2807 Mon Sep 17 00:00:00 2001
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Tue, 20 Apr 2021 05:49:11 -0400
Subject: [PATCH 1/3] KVM: SEV: mask CPUID[0x8000001F].eax according to
 supported features

Do not return the SEV-ES bit from KVM_GET_SUPPORTED_CPUID unless
the corresponding module parameter is 1, and clear the memory encryption
leaf completely if SEV is disabled.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/cpuid.c   | 5 ++++-
 arch/x86/kvm/cpuid.h   | 1 +
 arch/x86/kvm/svm/svm.c | 7 +++++++
 3 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 2ae061586677..d791d1f093ab 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -944,8 +944,11 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 		break;
 	/* Support memory encryption cpuid if host supports it */
 	case 0x8000001F:
-		if (!boot_cpu_has(X86_FEATURE_SEV))
+		if (!kvm_cpu_cap_has(X86_FEATURE_SEV)) {
 			entry->eax = entry->ebx = entry->ecx = entry->edx = 0;
+			break;
+		}
+		cpuid_entry_override(entry, CPUID_8000_001F_EAX);
 		break;
 	/*Add support for Centaur's CPUID instruction*/
 	case 0xC0000000:
diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
index 888e88b42e8d..e873a60a4830 100644
--- a/arch/x86/kvm/cpuid.h
+++ b/arch/x86/kvm/cpuid.h
@@ -99,6 +99,7 @@ static const struct cpuid_reg reverse_cpuid[] = {
 	[CPUID_7_EDX]         = {         7, 0, CPUID_EDX},
 	[CPUID_7_1_EAX]       = {         7, 1, CPUID_EAX},
 	[CPUID_12_EAX]        = {0x00000012, 0, CPUID_EAX},
+	[CPUID_8000_001F_EAX] = {0x8000001F, 0, CPUID_EAX},
 };
 
 /*
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index cd8c333ed2dc..acdb8457289e 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -923,6 +923,13 @@ static __init void svm_set_cpu_caps(void)
 	if (boot_cpu_has(X86_FEATURE_LS_CFG_SSBD) ||
 	    boot_cpu_has(X86_FEATURE_AMD_SSBD))
 		kvm_cpu_cap_set(X86_FEATURE_VIRT_SSBD);
+
+	/* CPUID 0x8000001F */
+	if (sev) {
+		kvm_cpu_cap_set(X86_FEATURE_SEV);
+		if (sev_es)
+			kvm_cpu_cap_set(X86_FEATURE_SEV_ES);
+	}
 }
 
 static __init int svm_hardware_setup(void)
-- 
2.26.2


From ef78673f78e3f2eedc498c1fbf9271146caa83cb Mon Sep 17 00:00:00 2001
From: Ashish Kalra <ashish.kalra@amd.com>
Date: Thu, 15 Apr 2021 15:57:02 +0000
Subject: [PATCH 2/3] KVM: X86: Introduce KVM_HC_PAGE_ENC_STATUS hypercall

This hypercall is used by the SEV guest to notify a change in the page
encryption status to the hypervisor. The hypercall should be invoked
only when the encryption attribute is changed from encrypted -> decrypted
and vice versa. By default all guest pages are considered encrypted.

The hypercall exits to userspace to manage the guest shared regions and
integrate with the userspace VMM's migration code.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Borislav Petkov <bp@suse.de>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: x86@kernel.org
Cc: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Reviewed-by: Steve Rutherford <srutherford@google.com>
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <93d7f2c2888315adc48905722574d89699edde33.1618498113.git.ashish.kalra@amd.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 Documentation/virt/kvm/api.rst        | 11 +++++++++
 Documentation/virt/kvm/cpuid.rst      |  5 ++++
 Documentation/virt/kvm/hypercalls.rst | 15 ++++++++++++
 arch/x86/include/asm/kvm_host.h       |  2 ++
 arch/x86/include/uapi/asm/kvm_para.h  |  1 +
 arch/x86/kvm/x86.c                    | 34 +++++++++++++++++++++++++++
 include/uapi/linux/kvm.h              |  1 +
 include/uapi/linux/kvm_para.h         |  1 +
 8 files changed, 70 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index fd4a84911355..2bc353d1f356 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6766,3 +6766,14 @@ they will get passed on to user space. So user space still has to have
 an implementation for these despite the in kernel acceleration.
 
 This capability is always enabled.
+
+8.32 KVM_CAP_EXIT_HYPERCALL
+---------------------------
+
+:Capability: KVM_CAP_EXIT_HYPERCALL
+:Architectures: x86
+:Type: vm
+
+This capability, if enabled, will cause KVM to exit to userspace
+with KVM_EXIT_HYPERCALL exit reason to process some hypercalls.
+Right now, the only such hypercall is KVM_HC_PAGE_ENC_STATUS.
diff --git a/Documentation/virt/kvm/cpuid.rst b/Documentation/virt/kvm/cpuid.rst
index cf62162d4be2..c9378d163b5a 100644
--- a/Documentation/virt/kvm/cpuid.rst
+++ b/Documentation/virt/kvm/cpuid.rst
@@ -96,6 +96,11 @@ KVM_FEATURE_MSI_EXT_DEST_ID        15          guest checks this feature bit
                                                before using extended destination
                                                ID bits in MSI address bits 11-5.
 
+KVM_FEATURE_HC_PAGE_ENC_STATUS     16          guest checks this feature bit before
+                                               using the page encryption state
+                                               hypercall to notify the page state
+                                               change
+
 KVM_FEATURE_CLOCKSOURCE_STABLE_BIT 24          host will warn if no guest-side
                                                per-cpu warps are expected in
                                                kvmclock
diff --git a/Documentation/virt/kvm/hypercalls.rst b/Documentation/virt/kvm/hypercalls.rst
index ed4fddd364ea..234ed5188aef 100644
--- a/Documentation/virt/kvm/hypercalls.rst
+++ b/Documentation/virt/kvm/hypercalls.rst
@@ -169,3 +169,18 @@ a0: destination APIC ID
 
 :Usage example: When sending a call-function IPI-many to vCPUs, yield if
 	        any of the IPI target vCPUs was preempted.
+
+
+8. KVM_HC_PAGE_ENC_STATUS
+-------------------------
+:Architecture: x86
+:Status: active
+:Purpose: Notify the encryption status changes in guest page table (SEV guest)
+
+a0: the guest physical address of the start page
+a1: the number of pages
+a2: page encryption status
+
+   Where:
+	* 1: Page is encrypted
+	* 0: Page is decrypted
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 6e195f7df4f0..45cb09543b56 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1047,6 +1047,8 @@ struct kvm_arch {
 
 	bool bus_lock_detection_enabled;
 
+	bool hypercall_exit_enabled;
+
 	/* Guest can access the SGX PROVISIONKEY. */
 	bool sgx_provisioning_allowed;
 
diff --git a/arch/x86/include/uapi/asm/kvm_para.h b/arch/x86/include/uapi/asm/kvm_para.h
index 950afebfba88..be49956b603f 100644
--- a/arch/x86/include/uapi/asm/kvm_para.h
+++ b/arch/x86/include/uapi/asm/kvm_para.h
@@ -33,6 +33,7 @@
 #define KVM_FEATURE_PV_SCHED_YIELD	13
 #define KVM_FEATURE_ASYNC_PF_INT	14
 #define KVM_FEATURE_MSI_EXT_DEST_ID	15
+#define KVM_FEATURE_HC_PAGE_ENC_STATUS	16
 
 #define KVM_HINTS_REALTIME      0
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c9ba6f2d9bcd..590cc811c99a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3809,6 +3809,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_SGX_ATTRIBUTE:
 #endif
 	case KVM_CAP_VM_COPY_ENC_CONTEXT_FROM:
+	case KVM_CAP_EXIT_HYPERCALL:
 		r = 1;
 		break;
 	case KVM_CAP_SET_GUEST_DEBUG2:
@@ -5413,6 +5414,10 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		break;
 	}
 #endif
+	case KVM_CAP_EXIT_HYPERCALL:
+		kvm->arch.hypercall_exit_enabled = cap->args[0];
+		r = 0;
+		break;
 	case KVM_CAP_VM_COPY_ENC_CONTEXT_FROM:
 		r = -EINVAL;
 		if (kvm_x86_ops.vm_copy_enc_context_from)
@@ -8269,6 +8274,13 @@ static void kvm_sched_yield(struct kvm_vcpu *vcpu, unsigned long dest_id)
 	return;
 }
 
+static int complete_hypercall_exit(struct kvm_vcpu *vcpu)
+{
+	kvm_rax_write(vcpu, vcpu->run->hypercall.ret);
+	++vcpu->stat.hypercalls;
+	return kvm_skip_emulated_instruction(vcpu);
+}
+
 int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
 {
 	unsigned long nr, a0, a1, a2, a3, ret;
@@ -8334,6 +8346,28 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
 		kvm_sched_yield(vcpu, a0);
 		ret = 0;
 		break;
+	case KVM_HC_PAGE_ENC_STATUS: {
+		u64 gpa = a0, npages = a1, enc = a2;
+
+		ret = -KVM_ENOSYS;
+		if (!vcpu->kvm->arch.hypercall_exit_enabled)
+			break;
+
+		if (!PAGE_ALIGNED(gpa) || !npages ||
+		    gpa_to_gfn(gpa) + npages <= gpa_to_gfn(gpa)) {
+			ret = -EINVAL;
+			break;
+		}
+
+		vcpu->run->exit_reason        = KVM_EXIT_HYPERCALL;
+		vcpu->run->hypercall.nr       = KVM_HC_PAGE_ENC_STATUS;
+		vcpu->run->hypercall.args[0]  = gpa;
+		vcpu->run->hypercall.args[1]  = npages;
+		vcpu->run->hypercall.args[2]  = enc;
+		vcpu->run->hypercall.longmode = op_64_bit;
+		vcpu->arch.complete_userspace_io = complete_hypercall_exit;
+		return 0;
+	}
 	default:
 		ret = -KVM_ENOSYS;
 		break;
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index d76533498543..7dc1c217704f 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1081,6 +1081,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_SET_GUEST_DEBUG2 195
 #define KVM_CAP_SGX_ATTRIBUTE 196
 #define KVM_CAP_VM_COPY_ENC_CONTEXT_FROM 197
+#define KVM_CAP_EXIT_HYPERCALL 198
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
diff --git a/include/uapi/linux/kvm_para.h b/include/uapi/linux/kvm_para.h
index 8b86609849b9..847b83b75dc8 100644
--- a/include/uapi/linux/kvm_para.h
+++ b/include/uapi/linux/kvm_para.h
@@ -29,6 +29,7 @@
 #define KVM_HC_CLOCK_PAIRING		9
 #define KVM_HC_SEND_IPI		10
 #define KVM_HC_SCHED_YIELD		11
+#define KVM_HC_PAGE_ENC_STATUS		12
 
 /*
  * hypercalls use architecture specific
-- 
2.26.2


From b9109a4be9c33eb09658003d135abe77da4bbaa1 Mon Sep 17 00:00:00 2001
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Tue, 20 Apr 2021 06:50:21 -0400
Subject: [PATCH 3/3] KVM: x86: add MSR_KVM_MIGRATION_CONTROL

Add a new MSR that can be used to communicate whether the page
encryption status bitmap is up to date and therefore whether live
migration of an encrypted guest is possible.

The MSR should be processed by userspace if it is going to live
migrate the guest; the default implementation does nothing.

Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 Documentation/virt/kvm/cpuid.rst     |  3 ++-
 Documentation/virt/kvm/msr.rst       | 10 ++++++++++
 arch/x86/include/uapi/asm/kvm_para.h |  3 +++
 arch/x86/kvm/x86.c                   | 14 ++++++++++++++
 4 files changed, 29 insertions(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/cpuid.rst b/Documentation/virt/kvm/cpuid.rst
index c9378d163b5a..15923857de56 100644
--- a/Documentation/virt/kvm/cpuid.rst
+++ b/Documentation/virt/kvm/cpuid.rst
@@ -99,7 +99,8 @@ KVM_FEATURE_MSI_EXT_DEST_ID        15          guest checks this feature bit
 KVM_FEATURE_HC_PAGE_ENC_STATUS     16          guest checks this feature bit before
                                                using the page encryption state
                                                hypercall to notify the page state
-                                               change
+                                               change, and before setting bit 0 of
+                                               MSR_KVM_MIGRATION_CONTROL
 
 KVM_FEATURE_CLOCKSOURCE_STABLE_BIT 24          host will warn if no guest-side
                                                per-cpu warps are expected in
diff --git a/Documentation/virt/kvm/msr.rst b/Documentation/virt/kvm/msr.rst
index e37a14c323d2..691d718df60a 100644
--- a/Documentation/virt/kvm/msr.rst
+++ b/Documentation/virt/kvm/msr.rst
@@ -376,3 +376,13 @@ data:
 	write '1' to bit 0 of the MSR, this causes the host to re-scan its queue
 	and check if there are more notifications pending. The MSR is available
 	if KVM_FEATURE_ASYNC_PF_INT is present in CPUID.
+
+MSR_KVM_MIGRATION_CONTROL:
+        0x4b564d08
+
+data:
+        If the guest is running with encrypted memory and it is communicating
+        page encryption status to the host using the ``KVM_HC_PAGE_ENC_STATUS``
+        hypercall, it can set bit 0 in this MSR to allow live migration of
+        the guest.  The bit can be set if KVM_FEATURE_HC_PAGE_ENC_STATUS is
+        present in CPUID.
diff --git a/arch/x86/include/uapi/asm/kvm_para.h b/arch/x86/include/uapi/asm/kvm_para.h
index be49956b603f..c5ee419775d8 100644
--- a/arch/x86/include/uapi/asm/kvm_para.h
+++ b/arch/x86/include/uapi/asm/kvm_para.h
@@ -55,6 +55,7 @@
 #define MSR_KVM_POLL_CONTROL	0x4b564d05
 #define MSR_KVM_ASYNC_PF_INT	0x4b564d06
 #define MSR_KVM_ASYNC_PF_ACK	0x4b564d07
+#define MSR_KVM_MIGRATION_CONTROL	0x4b564d08
 
 struct kvm_steal_time {
 	__u64 steal;
@@ -91,6 +92,8 @@ struct kvm_clock_pairing {
 /* MSR_KVM_ASYNC_PF_INT */
 #define KVM_ASYNC_PF_VEC_MASK			GENMASK(7, 0)
 
+/* MSR_KVM_MIGRATION_CONTROL */
+#define KVM_PAGE_ENC_STATUS_UPTODATE		(1 << 0)
 
 /* Operations for KVM_HC_MMU_OP */
 #define KVM_MMU_OP_WRITE_PTE            1
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 590cc811c99a..d696a9f13e33 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3258,6 +3258,14 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		vcpu->arch.msr_kvm_poll_control = data;
 		break;
 
+	case MSR_KVM_MIGRATION_CONTROL:
+		if (data & ~KVM_PAGE_ENC_STATUS_UPTODATE)
+			return 1;
+
+		if (data && !guest_pv_has(vcpu, KVM_FEATURE_HC_PAGE_ENC_STATUS))
+			return 1;
+		break;
+
 	case MSR_IA32_MCG_CTL:
 	case MSR_IA32_MCG_STATUS:
 	case MSR_IA32_MC0_CTL ... MSR_IA32_MCx_CTL(KVM_MAX_MCE_BANKS) - 1:
@@ -3549,6 +3557,12 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		if (!guest_pv_has(vcpu, KVM_FEATURE_ASYNC_PF))
 			return 1;
 
+		msr_info->data = 0;
+		break;
+	case MSR_KVM_MIGRATION_CONTROL:
+		if (!guest_pv_has(vcpu, KVM_FEATURE_HC_PAGE_ENC_STATUS))
+			return 1;
+
 		msr_info->data = 0;
 		break;
 	case MSR_KVM_STEAL_TIME:
-- 
2.26.2

