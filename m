Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBC3636E908
	for <lists+kvm@lfdr.de>; Thu, 29 Apr 2021 12:47:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240546AbhD2KsF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Apr 2021 06:48:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50203 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240488AbhD2KsC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 29 Apr 2021 06:48:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619693235;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JHQgAS1bsP7sQSGYEE1Hl1QBULZxi58+oE80C0usLLs=;
        b=NSmxz01nvdSyZ5yzW25IBiY2BNmvV81RUlssOA3u3d3tAe2SPsg5VpRuodKzqmdHKnKAVd
        SBsIx5uOx4yCMiL/H+WlaCZaGHFzGseQ/EA5VOama7ttAun8zGT/t5zmJWnx7VgFwqyZKf
        JKLJMRKrWm4NN1QRlVrq7tnZNQKFslQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-17-pH9dac-RMSScQe5GeWrjHA-1; Thu, 29 Apr 2021 06:47:12 -0400
X-MC-Unique: pH9dac-RMSScQe5GeWrjHA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BA0636D24F;
        Thu, 29 Apr 2021 10:47:10 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BF4C84EC68;
        Thu, 29 Apr 2021 10:47:09 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     srutherford@google.com, seanjc@google.com, joro@8bytes.org,
        brijesh.singh@amd.com, thomas.lendacky@amd.com,
        ashish.kalra@amd.com, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@suse.de>,
        x86@kernel.org
Subject: [PATCH v3 2/2] KVM: X86: Introduce KVM_HC_PAGE_ENC_STATUS hypercall
Date:   Thu, 29 Apr 2021 06:47:07 -0400
Message-Id: <20210429104707.203055-3-pbonzini@redhat.com>
In-Reply-To: <20210429104707.203055-1-pbonzini@redhat.com>
References: <20210429104707.203055-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ashish Kalra <ashish.kalra@amd.com>

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
 Documentation/virt/kvm/api.rst        | 14 +++++++++
 Documentation/virt/kvm/cpuid.rst      |  6 ++++
 Documentation/virt/kvm/hypercalls.rst | 21 ++++++++++++++
 Documentation/virt/kvm/msr.rst        |  7 ++++-
 arch/x86/include/asm/kvm_host.h       |  2 ++
 arch/x86/include/uapi/asm/kvm_para.h  |  1 +
 arch/x86/kvm/x86.c                    | 42 +++++++++++++++++++++++++++
 include/uapi/linux/kvm.h              |  1 +
 include/uapi/linux/kvm_para.h         |  1 +
 9 files changed, 94 insertions(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 37c520ddb7e8..f8794fed23a4 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6891,3 +6891,17 @@ This capability is always enabled.
 This capability indicates that the KVM virtual PTP service is
 supported in the host. A VMM can check whether the service is
 available to the guest on migration.
+
+8.33 KVM_CAP_EXIT_HYPERCALL
+---------------------------
+
+:Capability: KVM_CAP_EXIT_HYPERCALL
+:Architectures: x86
+:Type: vm
+
+This capability, if enabled, will cause KVM to exit to userspace
+with KVM_EXIT_HYPERCALL exit reason to process some hypercalls.
+Right now, the only such hypercall is KVM_HC_PAGE_ENC_STATUS.
+
+Calling KVM_CHECK_EXTENSION for this capability will return a bitmask
+of hypercalls that will exit to userspace.
diff --git a/Documentation/virt/kvm/cpuid.rst b/Documentation/virt/kvm/cpuid.rst
index c53d7e2b8ff4..014ceffc46f2 100644
--- a/Documentation/virt/kvm/cpuid.rst
+++ b/Documentation/virt/kvm/cpuid.rst
@@ -99,6 +99,12 @@ KVM_FEATURE_MSI_EXT_DEST_ID        15          guest checks this feature bit
 KVM_FEATURE_MIGRATION_CONTROL      16          guest checks this feature bit before
                                                using MSR_KVM_MIGRATION_CONTROL
 
+KVM_FEATURE_HC_PAGE_ENC_STATUS     17          guest checks this feature bit before
+                                               using the page encryption state
+                                               hypercall to notify the page state
+                                               change, and before modifying bit 0 of
+                                               MSR_KVM_MIGRATION_CONTROL
+
 KVM_FEATURE_CLOCKSOURCE_STABLE_BIT 24          host will warn if no guest-side
                                                per-cpu warps are expected in
                                                kvmclock
diff --git a/Documentation/virt/kvm/hypercalls.rst b/Documentation/virt/kvm/hypercalls.rst
index ed4fddd364ea..117ff3b27d3c 100644
--- a/Documentation/virt/kvm/hypercalls.rst
+++ b/Documentation/virt/kvm/hypercalls.rst
@@ -169,3 +169,24 @@ a0: destination APIC ID
 
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
+
+**Implementation note**: this hypercall is implemented in userspace via
+the KVM_CAP_EXIT_HYPERCALL capability.  Userspace must enable that capability
+before advertising KVM_FEATURE_HC_PAGE_ENC_STATUS in the guest CPUID.  In
+addition, if the guest supports KVM_FEATURE_MIGRATION_CONTROL, userspace
+must also set up an MSR filter to process writes to MSR_KVM_MIGRATION_CONTROL.
diff --git a/Documentation/virt/kvm/msr.rst b/Documentation/virt/kvm/msr.rst
index 57fc4090031a..cf1b0b2099b0 100644
--- a/Documentation/virt/kvm/msr.rst
+++ b/Documentation/virt/kvm/msr.rst
@@ -383,5 +383,10 @@ MSR_KVM_MIGRATION_CONTROL:
 data:
         This MSR is available if KVM_FEATURE_MIGRATION_CONTROL is present in
         CPUID.  Bit 0 represents whether live migration of the guest is allowed.
+
         When a guest is started, bit 0 will be 1 if the guest has encrypted
-        memory and 0 if the guest does not have encrypted memory.
+        memory and 0 if the guest does not have encrypted memory.  If the
+        guest is communicating page encryption status to the host using the
+        ``KVM_HC_PAGE_ENC_STATUS`` hypercall, it can set bit 0 in this MSR to
+        allow live migration of the guest.  The MSR is read-only if
+        ``KVM_FEATURE_HC_PAGE_STATUS`` is not advertised to the guest.
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 5491fc617451..9b90a0faeab4 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1065,6 +1065,8 @@ struct kvm_arch {
 	u32 user_space_msr_mask;
 	struct kvm_x86_msr_filter __rcu *msr_filter;
 
+	bool hypercall_exit_enabled;
+
 	/* Guest can access the SGX PROVISIONKEY. */
 	bool sgx_provisioning_allowed;
 
diff --git a/arch/x86/include/uapi/asm/kvm_para.h b/arch/x86/include/uapi/asm/kvm_para.h
index 21390fccfb90..8fadae64bc66 100644
--- a/arch/x86/include/uapi/asm/kvm_para.h
+++ b/arch/x86/include/uapi/asm/kvm_para.h
@@ -34,6 +34,7 @@
 #define KVM_FEATURE_ASYNC_PF_INT	14
 #define KVM_FEATURE_MSI_EXT_DEST_ID	15
 #define KVM_FEATURE_MIGRATION_CONTROL	16
+#define KVM_FEATURE_HC_PAGE_ENC_STATUS	17
 
 #define KVM_HINTS_REALTIME      0
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e9c40be9235c..0c2524bbaa84 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3279,6 +3279,12 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		if (!guest_pv_has(vcpu, KVM_FEATURE_MIGRATION_CONTROL))
 			return 1;
 
+		/*
+		 * This implementation is only good if userspace has *not*
+		 * enabled KVM_FEATURE_HC_PAGE_ENC_STATUS.  If userspace
+		 * enables KVM_FEATURE_HC_PAGE_ENC_STATUS it must set up an
+		 * MSR filter in order to accept writes that change bit 0.
+		 */
 		if (data != !static_call(kvm_x86_has_encrypted_memory)(vcpu->kvm))
 			return 1;
 		break;
@@ -3842,6 +3848,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_VM_COPY_ENC_CONTEXT_FROM:
 		r = 1;
 		break;
+	case KVM_CAP_EXIT_HYPERCALL:
+		r = (1 << KVM_HC_PAGE_ENC_STATUS);
+		break;
 	case KVM_CAP_SET_GUEST_DEBUG2:
 		return KVM_GUESTDBG_VALID_MASK;
 #ifdef CONFIG_KVM_XEN
@@ -5444,6 +5453,10 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
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
@@ -8329,6 +8342,13 @@ static void kvm_sched_yield(struct kvm_vcpu *vcpu, unsigned long dest_id)
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
@@ -8394,6 +8414,28 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
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
index 3fd9a7e9d90c..1fb4fd863324 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1082,6 +1082,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_SGX_ATTRIBUTE 196
 #define KVM_CAP_VM_COPY_ENC_CONTEXT_FROM 197
 #define KVM_CAP_PTP_KVM 198
+#define KVM_CAP_EXIT_HYPERCALL 199
 
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

