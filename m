Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B6AB82D64
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2019 10:05:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732277AbfHFIFD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Aug 2019 04:05:03 -0400
Received: from mga03.intel.com ([134.134.136.65]:5765 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732264AbfHFIFD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Aug 2019 04:05:03 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Aug 2019 01:00:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,352,1559545200"; 
   d="scan'208";a="373337292"
Received: from devel-ww.sh.intel.com ([10.239.48.128])
  by fmsmga005.fm.intel.com with ESMTP; 06 Aug 2019 01:00:40 -0700
From:   Wei Wang <wei.w.wang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        ak@linux.intel.com, peterz@infradead.org, pbonzini@redhat.com
Cc:     kan.liang@intel.com, mingo@redhat.com, rkrcmar@redhat.com,
        like.xu@intel.com, wei.w.wang@intel.com, jannh@google.com,
        arei.gonglei@huawei.com, jmattson@google.com
Subject: [PATCH v8 03/14] KVM/x86: KVM_CAP_X86_GUEST_LBR
Date:   Tue,  6 Aug 2019 15:16:03 +0800
Message-Id: <1565075774-26671-4-git-send-email-wei.w.wang@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1565075774-26671-1-git-send-email-wei.w.wang@intel.com>
References: <1565075774-26671-1-git-send-email-wei.w.wang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce KVM_CAP_X86_GUEST_LBR to allow per-VM enabling of the guest
lbr feature.

Signed-off-by: Wei Wang <wei.w.wang@intel.com>
---
 Documentation/virt/kvm/api.txt  | 26 ++++++++++++++++++++++++++
 arch/x86/include/asm/kvm_host.h |  2 ++
 arch/x86/kvm/x86.c              | 16 ++++++++++++++++
 include/uapi/linux/kvm.h        |  1 +
 4 files changed, 45 insertions(+)

diff --git a/Documentation/virt/kvm/api.txt b/Documentation/virt/kvm/api.txt
index 2d06776..64632a8 100644
--- a/Documentation/virt/kvm/api.txt
+++ b/Documentation/virt/kvm/api.txt
@@ -5046,6 +5046,32 @@ it hard or impossible to use it correctly.  The availability of
 KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2 signals that those bugs are fixed.
 Userspace should not try to use KVM_CAP_MANUAL_DIRTY_LOG_PROTECT.
 
+7.19 KVM_CAP_X86_GUEST_LBR
+Architectures: x86
+Parameters: args[0] whether feature should be enabled or not
+            args[1] pointer to the userspace memory to load the lbr stack info
+
+The lbr stack info is described by
+struct x86_perf_lbr_stack {
+	unsigned int	nr;
+	unsigned int	tos;
+	unsigned int	from;
+	unsigned int	to;
+	unsigned int	info;
+};
+
+@nr: number of lbr stack entries
+@tos: index of the top of stack msr
+@from: index of the msr that stores a branch source address
+@to: index of the msr that stores a branch destination address
+@info: index of the msr that stores lbr related flags
+
+Enabling this capability allows guest accesses to the lbr feature. Otherwise,
+#GP will be injected to the guest when it accesses to the lbr related msrs.
+
+After the feature is enabled, before exiting to userspace, kvm handlers should
+fill the lbr stack info into the userspace memory pointed by args[1].
+
 8. Other capabilities.
 ----------------------
 
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 7b0a4ee..d29dddd 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -875,6 +875,7 @@ struct kvm_arch {
 	atomic_t vapics_in_nmi_mode;
 	struct mutex apic_map_lock;
 	struct kvm_apic_map *apic_map;
+	struct x86_perf_lbr_stack lbr_stack;
 
 	bool apic_access_page_done;
 
@@ -884,6 +885,7 @@ struct kvm_arch {
 	bool hlt_in_guest;
 	bool pause_in_guest;
 	bool cstate_in_guest;
+	bool lbr_in_guest;
 
 	unsigned long irq_sources_bitmap;
 	s64 kvmclock_offset;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c6d951c..e1eb1be 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3129,6 +3129,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_EXCEPTION_PAYLOAD:
 		r = 1;
 		break;
+	case KVM_CAP_X86_GUEST_LBR:
+		r = sizeof(struct x86_perf_lbr_stack);
+		break;
 	case KVM_CAP_SYNC_REGS:
 		r = KVM_SYNC_X86_VALID_FIELDS;
 		break;
@@ -4670,6 +4673,19 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		kvm->arch.exception_payload_enabled = cap->args[0];
 		r = 0;
 		break;
+	case KVM_CAP_X86_GUEST_LBR:
+		r = -EINVAL;
+		if (cap->args[0] &&
+		    x86_perf_get_lbr_stack(&kvm->arch.lbr_stack))
+			break;
+
+		if (copy_to_user((void __user *)cap->args[1],
+				 &kvm->arch.lbr_stack,
+				 sizeof(struct x86_perf_lbr_stack)))
+			break;
+		kvm->arch.lbr_in_guest = cap->args[0];
+		r = 0;
+		break;
 	default:
 		r = -EINVAL;
 		break;
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 5e3f12d..dd53edc 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -996,6 +996,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_ARM_PTRAUTH_ADDRESS 171
 #define KVM_CAP_ARM_PTRAUTH_GENERIC 172
 #define KVM_CAP_PMU_EVENT_FILTER 173
+#define KVM_CAP_X86_GUEST_LBR 174
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
2.7.4

