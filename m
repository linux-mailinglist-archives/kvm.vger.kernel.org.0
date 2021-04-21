Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14E5C367177
	for <lists+kvm@lfdr.de>; Wed, 21 Apr 2021 19:37:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244804AbhDURiJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Apr 2021 13:38:09 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30427 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244790AbhDURiI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 21 Apr 2021 13:38:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619026654;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=T+C3tBmxlj3Ck1rJs8rCiHYuQKpr1tRXoF5sXcWv7z8=;
        b=M1xRw2aKWZ/3apy0SH4Ziaekx8yy6fFTGKCg2d1vvm2pbfIdHmpG176UNcLvrbutnPG7fl
        LriIv3Y3zPFJ0rTDxZfm6jeOm4PBVuQAq1ixk8Wu23xFizTqbh24BqUGiUJWFTLV9Wv+9L
        Aw1kOu0RtqgGPMczO7SXjXEakHhbXbU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-217-pBON5cLAOZaSc6YcIF7sFw-1; Wed, 21 Apr 2021 13:37:24 -0400
X-MC-Unique: pBON5cLAOZaSc6YcIF7sFw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 387DE513A;
        Wed, 21 Apr 2021 17:37:22 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2C8ED10016FE;
        Wed, 21 Apr 2021 17:37:18 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com, srutherford@google.com, joro@8bytes.org,
        brijesh.singh@amd.com, thomas.lendacky@amd.com,
        venu.busireddy@oracle.com, Ashish Kalra <ashish.kalra@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@suse.de>,
        x86@kernel.org
Subject: [PATCH v2 1/2] KVM: X86: Introduce KVM_HC_PAGE_ENC_STATUS hypercall
Date:   Wed, 21 Apr 2021 13:37:15 -0400
Message-Id: <20210421173716.1577745-2-pbonzini@redhat.com>
In-Reply-To: <20210421173716.1577745-1-pbonzini@redhat.com>
References: <20210421173716.1577745-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
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
 Documentation/virt/kvm/api.rst        | 19 ++++++++++++++
 Documentation/virt/kvm/cpuid.rst      |  5 ++++
 Documentation/virt/kvm/hypercalls.rst | 15 +++++++++++
 arch/x86/include/asm/kvm_host.h       |  2 ++
 arch/x86/include/uapi/asm/kvm_para.h  |  1 +
 arch/x86/kvm/x86.c                    | 36 +++++++++++++++++++++++++++
 include/uapi/linux/kvm.h              |  1 +
 include/uapi/linux/kvm_para.h         |  1 +
 8 files changed, 80 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index fd4a84911355..413d5ebbf49c 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6766,3 +6766,22 @@ they will get passed on to user space. So user space still has to have
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
+
+The arguments to KVM_ENABLE_CAP are a bitmask of hypercalls that
+will exit to userspace.  The bits that can be set are returned by
+KVM_CHECK_EXTENSION.  The behavior of hypercalls that are not enabled
+depends on the individual hypercall.
+
+Right now, the only bit that can be set is bit 12, corresponding to
+KVM_HC_PAGE_ENC_STATUS.  The hypercall returns ENOSYS if bit 12 is not
+set or KVM_CAP_EXIT_HYPERCALL is not enabled.
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
index 6e195f7df4f0..b3c40f0bc80e 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1050,6 +1050,8 @@ struct kvm_arch {
 	/* Guest can access the SGX PROVISIONKEY. */
 	bool sgx_provisioning_allowed;
 
+	u64 hypercall_exit_enabled;
+
 	struct kvm_pmu_event_filter __rcu *pmu_event_filter;
 	struct task_struct *nx_lpage_recovery_thread;
 
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
index c9ba6f2d9bcd..c2babf70a587 100644
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
@@ -5413,6 +5414,14 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		break;
 	}
 #endif
+	case KVM_CAP_EXIT_HYPERCALL:
+		r = -EINVAL;
+		if ((cap->args[0] & ~(1 << KVM_HC_PAGE_ENC_STATUS)) ||
+		    cap->args[1] || cap->args[2] || cap->args[3])
+			break;
+		r = 0;
+		kvm->arch.hypercall_exit_enabled = cap->args[0];
+		break;
 	case KVM_CAP_VM_COPY_ENC_CONTEXT_FROM:
 		r = -EINVAL;
 		if (kvm_x86_ops.vm_copy_enc_context_from)
@@ -8269,6 +8278,13 @@ static void kvm_sched_yield(struct kvm_vcpu *vcpu, unsigned long dest_id)
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
@@ -8334,6 +8350,26 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
 		kvm_sched_yield(vcpu, a0);
 		ret = 0;
 		break;
+	case KVM_HC_PAGE_ENC_STATUS: {
+		u64 gpa = a0, npages = a1, enc = a2;
+		if (!guest_pv_has(vcpu, KVM_FEATURE_HC_PAGE_ENC_STATUS)
+		    || !(vcpu->kvm->arch.hypercall_exit_enabled & (1 << KVM_HC_PAGE_ENC_STATUS)))
+			break;
+
+		ret = -KVM_EINVAL;
+		if (!PAGE_ALIGNED(gpa) || !npages ||
+		    gpa_to_gfn(gpa) + npages <= gpa_to_gfn(gpa))
+			break;
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


