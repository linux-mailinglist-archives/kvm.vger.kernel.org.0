Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 300A5553714
	for <lists+kvm@lfdr.de>; Tue, 21 Jun 2022 18:00:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353254AbiFUP7R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jun 2022 11:59:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353564AbiFUP6z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jun 2022 11:58:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 622D5B60
        for <kvm@vger.kernel.org>; Tue, 21 Jun 2022 08:58:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655827132;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Y9f+5hJejFOP7LVQYOM+alkQkCfaW5L37ESdvjKAjl4=;
        b=aZKKoCCc3idA/jAw7iOk63sRmQtH3F1lJ2yL2XFyesrRQn0eQlE2hHZS34B98yhlULG1YH
        +rPh8gWu98Tcq3+EKQ6Bu8bN+CsQJw9Ig2Q9yrxiDEYE6YRPoGIZC0tv/oDJtBfGqJMt9c
        au6n3w3LuyXoRqkpx5hrD7llti0+//0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-511-gVrb6TzzNWWxa7Poj3eyyg-1; Tue, 21 Jun 2022 11:58:49 -0400
X-MC-Unique: gVrb6TzzNWWxa7Poj3eyyg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C7D41100BADC;
        Tue, 21 Jun 2022 15:58:48 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.195.134])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6BF992026985;
        Tue, 21 Jun 2022 15:58:46 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 06/11] KVM: nVMX: Introduce KVM_CAP_HYPERV_ENLIGHTENED_VMCS2
Date:   Tue, 21 Jun 2022 17:58:25 +0200
Message-Id: <20220621155830.60115-7-vkuznets@redhat.com>
In-Reply-To: <20220621155830.60115-1-vkuznets@redhat.com>
References: <20220621155830.60115-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Turns out Enlightened VMCS can gain new fields without version change
and KVM_CAP_HYPERV_ENLIGHTENED_VMCS which KVM currently has cant's
handle this reliably. In particular, just updating the current definition
of eVMCSv1 with the new fields and adjusting the VMX MSR filtering will
inevitably break live migration to older KVMs. Note: enabling eVMCS and
setting VMX feature MSR can happen in any order.

Introduce a notion of KVM internal "Enlightened VMCS revision" and add
a new capability allowing to add fields to Enlightened VMCS while keeping
its version.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 Documentation/virt/kvm/api.rst  | 42 ++++++++++++++++++++++++++++++++-
 arch/x86/include/asm/kvm_host.h |  2 +-
 arch/x86/kvm/vmx/evmcs.c        | 20 +++++++++++-----
 arch/x86/kvm/vmx/evmcs.h        | 13 ++++++++--
 arch/x86/kvm/vmx/nested.c       | 10 ++++----
 arch/x86/kvm/vmx/vmx.c          |  2 +-
 arch/x86/kvm/vmx/vmx.h          | 15 ++++++------
 arch/x86/kvm/x86.c              | 15 +++++++++++-
 include/uapi/linux/kvm.h        |  3 ++-
 9 files changed, 97 insertions(+), 25 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 84c486ce6279..248386247bbf 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -4974,7 +4974,7 @@ version has the following quirks:
 
 - HYPERV_CPUID_NESTED_FEATURES leaf and HV_X64_ENLIGHTENED_VMCS_RECOMMENDED
   feature bit are only exposed when Enlightened VMCS was previously enabled
-  on the corresponding vCPU (KVM_CAP_HYPERV_ENLIGHTENED_VMCS).
+  on the corresponding vCPU (KVM_CAP_HYPERV_ENLIGHTENED_VMCS2).
 - HV_STIMER_DIRECT_MODE_AVAILABLE bit is only exposed with in-kernel LAPIC.
   (presumes KVM_CREATE_IRQCHIP has already been called).
 
@@ -8193,6 +8193,46 @@ PV guests. The `KVM_PV_DUMP` command is available for the
 dump related UV data. Also the vcpu ioctl `KVM_S390_PV_CPU_COMMAND` is
 available and supports the `KVM_PV_DUMP_CPU` subcommand.
 
+8.38 KVM_CAP_HYPERV_ENLIGHTENED_VMCS
+------------------------------------
+
+:Capability: KVM_CAP_HYPERV_ENLIGHTENED_VMCS
+:Architectures: x86
+:Type: vcpu
+:Parameters: arg[0] is a pointer to uint16_t where the supported Enlightened
+VMCS version range will be stored by KVM.
+:Returns: 0 on success, -EINVAL when Enlightened VMCS is already enabled,
+-EFAULT when write to arg[0] fails.
+
+This capability enables Enlightened VMCS interface. Obsolete, use
+KVM_CAP_HYPERV_ENLIGHTENED_VMCS2 instead.
+
+8.39 KVM_CAP_HYPERV_ENLIGHTENED_VMCS2
+-------------------------------------
+
+:Capability: KVM_CAP_HYPERV_ENLIGHTENED_VMCS2
+:Architectures: x86
+:Type: vcpu
+:Parameters: arg[0] is the desired Enlightened VMCS revision (uint32_t). Special
+value 'U32_MAX' indicates the latest supported revision. (Optional) arg[1] is a
+pointer to 'uint16_t' where the supported Enlightened VMCS version range will be
+stored by KVM.
+:Returns: 0 on success, -ENOTTY on SVM, -EINVAL when Enlightened VMCS is already
+enabled or the requested revision is not supported, -EFAULT when write to arg[1]
+fails.
+
+This capability enables Hyper-V Enlightened VMCS interface as described in
+Hyper-V Top Level Functional Specification (TLFS). Note: when the interface is
+enabled, L1 guest doesn't necessarily have to use it, however, the exposed VMX
+features will be limited to what the particular revision of the Enlightened VMCS
+supports.
+
+Enlightened VMCS version range (optionally written to arg[1]) is encoded in the
+following way:
+ ((uint8_t)HIGHEST_SUPPORTED_VERSION << 8) | (uint8_t)LOWEST_SUPPORTED_VERSION
+
+The interface is only available on VMX. Once set, changing the supported
+Enlightened VMCS revision not supported.
 
 9. Known KVM API problems
 =========================
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 7e98b2876380..f6c087b10472 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1629,7 +1629,7 @@ struct kvm_x86_nested_ops {
 	bool (*get_nested_state_pages)(struct kvm_vcpu *vcpu);
 	int (*write_log_dirty)(struct kvm_vcpu *vcpu, gpa_t l2_gpa);
 
-	int (*enable_evmcs)(struct kvm_vcpu *vcpu,
+	int (*enable_evmcs)(struct kvm_vcpu *vcpu, u32 evmcs_revision,
 			    uint16_t *vmcs_version);
 	uint16_t (*get_evmcs_version)(struct kvm_vcpu *vcpu);
 };
diff --git a/arch/x86/kvm/vmx/evmcs.c b/arch/x86/kvm/vmx/evmcs.c
index 8bea5dea0341..21d9f0ed4bd2 100644
--- a/arch/x86/kvm/vmx/evmcs.c
+++ b/arch/x86/kvm/vmx/evmcs.c
@@ -362,7 +362,7 @@ uint16_t nested_get_evmcs_version(struct kvm_vcpu *vcpu)
 	 * KVM_EVMCS_VERSION.
 	 */
 	if (kvm_cpu_cap_get(X86_FEATURE_VMX) &&
-	    (!vcpu || to_vmx(vcpu)->nested.enlightened_vmcs_enabled))
+	    (!vcpu || to_vmx(vcpu)->nested.active_evmcs_revision))
 		return (KVM_EVMCS_VERSION << 8) | 1;
 
 	return 0;
@@ -453,15 +453,23 @@ int nested_evmcs_check_controls(struct vmcs12 *vmcs12)
 	return ret;
 }
 
-int nested_enable_evmcs(struct kvm_vcpu *vcpu,
-			uint16_t *vmcs_version)
+int nested_enable_evmcs(struct kvm_vcpu *vcpu, u32 evmcs_revision, uint16_t *evmcs_version)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
-	vmx->nested.enlightened_vmcs_enabled = true;
+	if (evmcs_revision > KVM_EVMCS_REVISION && evmcs_revision != U32_MAX)
+		return -EINVAL;
 
-	if (vmcs_version)
-		*vmcs_version = nested_get_evmcs_version(vcpu);
+	/* Disabling or changing active eVMCS version is not supported */
+	if (vmx->nested.active_evmcs_revision)
+		return -EINVAL;
+
+	if (evmcs_revision != U32_MAX)
+		vmx->nested.active_evmcs_revision = evmcs_revision;
+	else
+		vmx->nested.active_evmcs_revision = KVM_EVMCS_REVISION;
+
+	*evmcs_version = nested_get_evmcs_version(vcpu);
 
 	return 0;
 }
diff --git a/arch/x86/kvm/vmx/evmcs.h b/arch/x86/kvm/vmx/evmcs.h
index f886a8ff0342..022a51ae81e4 100644
--- a/arch/x86/kvm/vmx/evmcs.h
+++ b/arch/x86/kvm/vmx/evmcs.h
@@ -18,8 +18,18 @@ DECLARE_STATIC_KEY_FALSE(enable_evmcs);
 
 #define current_evmcs ((struct hv_enlightened_vmcs *)this_cpu_read(current_vmcs))
 
+/*
+ * Maximum supported eVMCS version as described in TLFS, gets reported to the
+ * guest.
+ */
 #define KVM_EVMCS_VERSION 1
 
+/*
+ * Internal KVM eVMCS revision number, gets bumped when eVMCS needs to be
+ * updated but its version remain intact.
+ */
+#define KVM_EVMCS_REVISION 1
+
 /*
  * Enlightened VMCSv1 doesn't support these:
  *
@@ -241,8 +251,7 @@ enum nested_evmptrld_status {
 
 bool nested_enlightened_vmentry(struct kvm_vcpu *vcpu, u64 *evmcs_gpa);
 uint16_t nested_get_evmcs_version(struct kvm_vcpu *vcpu);
-int nested_enable_evmcs(struct kvm_vcpu *vcpu,
-			uint16_t *vmcs_version);
+int nested_enable_evmcs(struct kvm_vcpu *vcpu, u32 evmcs_revision, uint16_t *vmcs_version);
 void nested_evmcs_filter_control_msr(u32 msr_index, u64 *pdata);
 int nested_evmcs_check_controls(struct vmcs12 *vmcs12);
 
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 162f4b4502e1..be019c3c5eab 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2008,7 +2008,7 @@ static enum nested_evmptrld_status nested_vmx_handle_enlightened_vmptrld(
 	bool evmcs_gpa_changed = false;
 	u64 evmcs_gpa;
 
-	if (likely(!vmx->nested.enlightened_vmcs_enabled))
+	if (likely(!vmx->nested.active_evmcs_revision))
 		return EVMPTRLD_DISABLED;
 
 	if (!nested_enlightened_vmentry(vcpu, &evmcs_gpa)) {
@@ -2889,7 +2889,7 @@ static int nested_vmx_check_controls(struct kvm_vcpu *vcpu,
 	    nested_check_vm_entry_controls(vcpu, vmcs12))
 		return -EINVAL;
 
-	if (to_vmx(vcpu)->nested.enlightened_vmcs_enabled)
+	if (to_vmx(vcpu)->nested.active_evmcs_revision)
 		return nested_evmcs_check_controls(vmcs12);
 
 	return 0;
@@ -3171,7 +3171,7 @@ static bool nested_get_evmcs_page(struct kvm_vcpu *vcpu)
 	 * L2 was running), map it here to make sure vmcs12 changes are
 	 * properly reflected.
 	 */
-	if (vmx->nested.enlightened_vmcs_enabled &&
+	if (vmx->nested.active_evmcs_revision &&
 	    vmx->nested.hv_evmcs_vmptr == EVMPTR_MAP_PENDING) {
 		enum nested_evmptrld_status evmptrld_status =
 			nested_vmx_handle_enlightened_vmptrld(vcpu, false);
@@ -5125,7 +5125,7 @@ static int handle_vmclear(struct kvm_vcpu *vcpu)
 	 * state. It is possible that the area will stay mapped as
 	 * vmx->nested.hv_evmcs but this shouldn't be a problem.
 	 */
-	if (likely(!vmx->nested.enlightened_vmcs_enabled ||
+	if (likely(!vmx->nested.active_evmcs_revision ||
 		   !nested_enlightened_vmentry(vcpu, &evmcs_gpa))) {
 		if (vmptr == vmx->nested.current_vmptr)
 			nested_release_vmcs12(vcpu);
@@ -6414,7 +6414,7 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
 		return -EINVAL;
 
 	if ((kvm_state->flags & KVM_STATE_NESTED_EVMCS) &&
-		(!nested_vmx_allowed(vcpu) || !vmx->nested.enlightened_vmcs_enabled))
+		(!nested_vmx_allowed(vcpu) || !vmx->nested.active_evmcs_revision))
 			return -EINVAL;
 
 	vmx_leave_nested(vcpu);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 5e14e4c40007..e892956850ee 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1857,7 +1857,7 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		 * features out.
 		 */
 		if (!msr_info->host_initiated &&
-		    vmx->nested.enlightened_vmcs_enabled)
+		    vmx->nested.active_evmcs_revision)
 			nested_evmcs_filter_control_msr(msr_info->index,
 							&msr_info->data);
 		break;
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 71bcb486e73f..f9948a2a6432 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -185,13 +185,6 @@ struct nested_vmx {
 	bool update_vmcs01_cpu_dirty_logging;
 	bool update_vmcs01_apicv_status;
 
-	/*
-	 * Enlightened VMCS has been enabled. It does not mean that L1 has to
-	 * use it. However, VMX features available to L1 will be limited based
-	 * on what the enlightened VMCS supports.
-	 */
-	bool enlightened_vmcs_enabled;
-
 	/* L2 must run next, and mustn't decide to exit to L1. */
 	bool nested_run_pending;
 
@@ -239,6 +232,14 @@ struct nested_vmx {
 		bool guest_mode;
 	} smm;
 
+	/*
+	 * Enlightened VMCS revision enabled (1..KVM_EVMCS_REVISION) on the vCPU.
+	 * When, enabled, L1 doesn't necessarily have to use eVMCS interface,
+	 * however, the exposed VMX features will be limited to what the particular
+	 * revision of eVMCS supports.
+	 */
+	u32 active_evmcs_revision;
+
 	gpa_t hv_evmcs_vmptr;
 	struct kvm_host_map hv_evmcs_map;
 	struct hv_enlightened_vmcs *hv_evmcs;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2318a99139fa..b5b7d43a39e7 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4376,6 +4376,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		r = kvm_x86_ops.enable_direct_tlbflush != NULL;
 		break;
 	case KVM_CAP_HYPERV_ENLIGHTENED_VMCS:
+	case KVM_CAP_HYPERV_ENLIGHTENED_VMCS2:
 		r = kvm_x86_ops.nested_ops->enable_evmcs != NULL;
 		break;
 	case KVM_CAP_SMALLER_MAXPHYADDR:
@@ -5307,7 +5308,8 @@ static int kvm_vcpu_ioctl_enable_cap(struct kvm_vcpu *vcpu,
 	case KVM_CAP_HYPERV_ENLIGHTENED_VMCS:
 		if (!kvm_x86_ops.nested_ops->enable_evmcs)
 			return -ENOTTY;
-		r = kvm_x86_ops.nested_ops->enable_evmcs(vcpu, &vmcs_version);
+		/* Legacy: enable rev.1 */
+		r = kvm_x86_ops.nested_ops->enable_evmcs(vcpu, 1, &vmcs_version);
 		if (!r) {
 			user_ptr = (void __user *)(uintptr_t)cap->args[0];
 			if (copy_to_user(user_ptr, &vmcs_version,
@@ -5315,6 +5317,17 @@ static int kvm_vcpu_ioctl_enable_cap(struct kvm_vcpu *vcpu,
 				r = -EFAULT;
 		}
 		return r;
+	case KVM_CAP_HYPERV_ENLIGHTENED_VMCS2:
+		if (!kvm_x86_ops.nested_ops->enable_evmcs)
+			return -ENOTTY;
+		r = kvm_x86_ops.nested_ops->enable_evmcs(vcpu, cap->args[0], &vmcs_version);
+		if (!r && cap->args[1]) {
+			user_ptr = (void __user *)(uintptr_t)cap->args[1];
+			if (copy_to_user(user_ptr, &vmcs_version,
+					 sizeof(vmcs_version)))
+				r = -EFAULT;
+		}
+		return r;
 	case KVM_CAP_HYPERV_DIRECT_TLBFLUSH:
 		if (!kvm_x86_ops.enable_direct_tlbflush)
 			return -ENOTTY;
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 7569b4ec199c..d3267b7be9b0 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1109,7 +1109,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_PPC_NESTED_HV 160
 #define KVM_CAP_HYPERV_SEND_IPI 161
 #define KVM_CAP_COALESCED_PIO 162
-#define KVM_CAP_HYPERV_ENLIGHTENED_VMCS 163
+#define KVM_CAP_HYPERV_ENLIGHTENED_VMCS 163 /* Obsolete */
 #define KVM_CAP_EXCEPTION_PAYLOAD 164
 #define KVM_CAP_ARM_VM_IPA_SIZE 165
 #define KVM_CAP_MANUAL_DIRTY_LOG_PROTECT 166 /* Obsolete */
@@ -1166,6 +1166,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_S390_PROTECTED_DUMP 217
 #define KVM_CAP_X86_TRIPLE_FAULT_EVENT 218
 #define KVM_CAP_X86_NOTIFY_VMEXIT 219
+#define KVM_CAP_HYPERV_ENLIGHTENED_VMCS2 220
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
2.35.3

