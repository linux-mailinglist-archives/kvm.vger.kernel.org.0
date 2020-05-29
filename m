Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B1341E7F17
	for <lists+kvm@lfdr.de>; Fri, 29 May 2020 15:46:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727013AbgE2NqE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 May 2020 09:46:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726978AbgE2NqC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 May 2020 09:46:02 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED162C03E969;
        Fri, 29 May 2020 06:46:01 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id t18so3679952wru.6;
        Fri, 29 May 2020 06:46:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=N84w9yk692+T6Ori/vh46LJPbvHt6aQTERCo+HzpHJU=;
        b=WjJ9Koh4WQNDj3Z6HjwactNgJHjWUNMbrW+iDK59fVkd44DUH8O2SLz7RrZcIY2YhF
         AoM8jcd1sIiyxHYoyVU4toqWgeXRwQJNJptIYOrWYqNhdU1sQipnjt+AAd5CiAN28ldL
         RM2mAHIcUoC/g/qdqC3WdwRcVMlSyrNeamIfg0r9lkErAEJxF6mxaWNabmgH69r4IE9C
         HPhlwTrkN4RRugkfjZpyXtZ+sguIQ/BgNhXK0/2aFPEmc66m9S+Dw7RrhipYh50ARraW
         wZ995sOtlrsdc6fjLj3sr7cknkwUkD7wGhdHmWs4UiVFsGSZ907JP1LzHMpltg0POXey
         p+iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=N84w9yk692+T6Ori/vh46LJPbvHt6aQTERCo+HzpHJU=;
        b=aNo1WoR7asw5GJBzb5L+joehG9AcS3nxWisxwmkQVDHXmZPPKnqGZ//76Sr7sm6LZj
         e8BukCR5v8lE7ewApIz6NIlAN7NWHSKG/FeppLXKY9JDEZmMROz9QPzzOJp6gMTDZUvE
         IFx3+1O5C1/jrqi0GWNgNUzNUGCBV7DJmSBxWbg4V+ouKOj8FmJ9h0I/mvP1mZJgWYNV
         EdpydvACsjQfz5unm1XYeaZZjzLXLRjIwack6TRt0UWeq9efNBSXMSMJU7+HmV7ByBWi
         zeZkpkr4yrd5iS/aFmou7uLfJNRGCFVnyRNgJWhOPe8AtqtaTHIBxfU28hJ8u9oN3UIu
         CjOg==
X-Gm-Message-State: AOAM532lEzrbgdNKoQx2xJqYjTbfB8m4UER5NzzMBLRaZRABbjeRNaT8
        PZiLQkUky1Xyxa3h4/rgwit29iwq
X-Google-Smtp-Source: ABdhPJy+aFyAx6PhCBFALlB9UbaUHuZ5Xb+36kF8sTYsJFiW8zRjbxZFWlYncRYsFHD/8RAYHFwCmA==
X-Received: by 2002:a5d:4042:: with SMTP id w2mr9264328wrp.423.1590759960191;
        Fri, 29 May 2020 06:46:00 -0700 (PDT)
Received: from jondnuc.lan (IGLD-84-229-154-20.inter.net.il. [84.229.154.20])
        by smtp.gmail.com with ESMTPSA id y37sm12347263wrd.55.2020.05.29.06.45.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 May 2020 06:45:59 -0700 (PDT)
From:   Jon Doron <arilou@gmail.com>
To:     kvm@vger.kernel.org, linux-hyperv@vger.kernel.org
Cc:     vkuznets@redhat.com, pbonzini@redhat.com, rvkagan@yandex-team.ru,
        Jon Doron <arilou@gmail.com>
Subject: [PATCH v12 3/6] x86/kvm/hyper-v: Add support for synthetic debugger capability
Date:   Fri, 29 May 2020 16:45:40 +0300
Message-Id: <20200529134543.1127440-4-arilou@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200529134543.1127440-1-arilou@gmail.com>
References: <20200529134543.1127440-1-arilou@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add support for Hyper-V synthetic debugger (syndbg) interface.
The syndbg interface is using MSRs to emulate a way to send/recv packets
data.

The debug transport dll (kdvm/kdnet) will identify if Hyper-V is enabled
and if it supports the synthetic debugger interface it will attempt to
use it, instead of trying to initialize a network adapter.

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Jon Doron <arilou@gmail.com>
---
 Documentation/virt/kvm/api.rst  |  16 ++++
 arch/x86/include/asm/kvm_host.h |  13 +++
 arch/x86/kvm/hyperv.c           | 158 +++++++++++++++++++++++++++++++-
 arch/x86/kvm/hyperv.h           |   5 +
 arch/x86/kvm/trace.h            |  51 +++++++++++
 arch/x86/kvm/x86.c              |   9 ++
 include/uapi/linux/kvm.h        |  11 +++
 7 files changed, 260 insertions(+), 3 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 750d005a75bc..52ba12758f7c 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -5066,6 +5066,7 @@ EOI was received.
 		struct kvm_hyperv_exit {
   #define KVM_EXIT_HYPERV_SYNIC          1
   #define KVM_EXIT_HYPERV_HCALL          2
+  #define KVM_EXIT_HYPERV_SYNDBG         3
 			__u32 type;
 			__u32 pad1;
 			union {
@@ -5081,6 +5082,15 @@ EOI was received.
 					__u64 result;
 					__u64 params[2];
 				} hcall;
+				struct {
+					__u32 msr;
+					__u32 pad2;
+					__u64 control;
+					__u64 status;
+					__u64 send_page;
+					__u64 recv_page;
+					__u64 pending_page;
+				} syndbg;
 			} u;
 		};
 		/* KVM_EXIT_HYPERV */
@@ -5097,6 +5107,12 @@ Hyper-V SynIC state change. Notification is used to remap SynIC
 event/message pages and to enable/disable SynIC messages/events processing
 in userspace.
 
+	- KVM_EXIT_HYPERV_SYNDBG -- synchronously notify user-space about
+
+Hyper-V Synthetic debugger state change. Notification is used to either update
+the pending_page location or to send a control command (send the buffer located
+in send_page or recv a buffer to recv_page).
+
 ::
 
 		/* KVM_EXIT_ARM_NISV */
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 0a6b35353fc7..cf13a1b0c680 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -855,6 +855,18 @@ struct kvm_apic_map {
 	struct kvm_lapic *phys_map[];
 };
 
+/* Hyper-V synthetic debugger (SynDbg)*/
+struct kvm_hv_syndbg {
+	struct {
+		u64 control;
+		u64 status;
+		u64 send_page;
+		u64 recv_page;
+		u64 pending_page;
+	} control;
+	u64 options;
+};
+
 /* Hyper-V emulation context */
 struct kvm_hv {
 	struct mutex hv_lock;
@@ -878,6 +890,7 @@ struct kvm_hv {
 	atomic_t num_mismatched_vp_indexes;
 
 	struct hv_partition_assist_pg *hv_pa_pg;
+	struct kvm_hv_syndbg hv_syndbg;
 };
 
 enum kvm_irqchip_mode {
diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 54d4b98b49e1..dc7dd48621ca 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -21,6 +21,7 @@
 #include "x86.h"
 #include "lapic.h"
 #include "ioapic.h"
+#include "cpuid.h"
 #include "hyperv.h"
 
 #include <linux/cpu.h>
@@ -266,6 +267,123 @@ static int synic_set_msr(struct kvm_vcpu_hv_synic *synic,
 	return ret;
 }
 
+static bool kvm_hv_is_syndbg_enabled(struct kvm_vcpu *vcpu)
+{
+	struct kvm_cpuid_entry2 *entry;
+
+	entry = kvm_find_cpuid_entry(vcpu,
+				     HYPERV_CPUID_SYNDBG_PLATFORM_CAPABILITIES,
+				     0);
+	if (!entry)
+		return false;
+
+	return entry->eax & HV_X64_SYNDBG_CAP_ALLOW_KERNEL_DEBUGGING;
+}
+
+static int kvm_hv_syndbg_complete_userspace(struct kvm_vcpu *vcpu)
+{
+	struct kvm *kvm = vcpu->kvm;
+	struct kvm_hv *hv = &kvm->arch.hyperv;
+
+	if (vcpu->run->hyperv.u.syndbg.msr == HV_X64_MSR_SYNDBG_CONTROL)
+		hv->hv_syndbg.control.status =
+			vcpu->run->hyperv.u.syndbg.status;
+	return 1;
+}
+
+static void syndbg_exit(struct kvm_vcpu *vcpu, u32 msr)
+{
+	struct kvm_hv_syndbg *syndbg = vcpu_to_hv_syndbg(vcpu);
+	struct kvm_vcpu_hv *hv_vcpu = &vcpu->arch.hyperv;
+
+	hv_vcpu->exit.type = KVM_EXIT_HYPERV_SYNDBG;
+	hv_vcpu->exit.u.syndbg.msr = msr;
+	hv_vcpu->exit.u.syndbg.control = syndbg->control.control;
+	hv_vcpu->exit.u.syndbg.send_page = syndbg->control.send_page;
+	hv_vcpu->exit.u.syndbg.recv_page = syndbg->control.recv_page;
+	hv_vcpu->exit.u.syndbg.pending_page = syndbg->control.pending_page;
+	vcpu->arch.complete_userspace_io =
+			kvm_hv_syndbg_complete_userspace;
+
+	kvm_make_request(KVM_REQ_HV_EXIT, vcpu);
+}
+
+static int syndbg_set_msr(struct kvm_vcpu *vcpu, u32 msr, u64 data, bool host)
+{
+	struct kvm_hv_syndbg *syndbg = vcpu_to_hv_syndbg(vcpu);
+
+	if (!kvm_hv_is_syndbg_enabled(vcpu) && !host)
+		return 1;
+
+	trace_kvm_hv_syndbg_set_msr(vcpu->vcpu_id,
+				    vcpu_to_hv_vcpu(vcpu)->vp_index, msr, data);
+	switch (msr) {
+	case HV_X64_MSR_SYNDBG_CONTROL:
+		syndbg->control.control = data;
+		if (!host)
+			syndbg_exit(vcpu, msr);
+		break;
+	case HV_X64_MSR_SYNDBG_STATUS:
+		syndbg->control.status = data;
+		break;
+	case HV_X64_MSR_SYNDBG_SEND_BUFFER:
+		syndbg->control.send_page = data;
+		break;
+	case HV_X64_MSR_SYNDBG_RECV_BUFFER:
+		syndbg->control.recv_page = data;
+		break;
+	case HV_X64_MSR_SYNDBG_PENDING_BUFFER:
+		syndbg->control.pending_page = data;
+		if (!host)
+			syndbg_exit(vcpu, msr);
+		break;
+	case HV_X64_MSR_SYNDBG_OPTIONS:
+		syndbg->options = data;
+		break;
+	default:
+		break;
+	}
+
+	return 0;
+}
+
+static int syndbg_get_msr(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata, bool host)
+{
+	struct kvm_hv_syndbg *syndbg = vcpu_to_hv_syndbg(vcpu);
+
+	if (!kvm_hv_is_syndbg_enabled(vcpu) && !host)
+		return 1;
+
+	switch (msr) {
+	case HV_X64_MSR_SYNDBG_CONTROL:
+		*pdata = syndbg->control.control;
+		break;
+	case HV_X64_MSR_SYNDBG_STATUS:
+		*pdata = syndbg->control.status;
+		break;
+	case HV_X64_MSR_SYNDBG_SEND_BUFFER:
+		*pdata = syndbg->control.send_page;
+		break;
+	case HV_X64_MSR_SYNDBG_RECV_BUFFER:
+		*pdata = syndbg->control.recv_page;
+		break;
+	case HV_X64_MSR_SYNDBG_PENDING_BUFFER:
+		*pdata = syndbg->control.pending_page;
+		break;
+	case HV_X64_MSR_SYNDBG_OPTIONS:
+		*pdata = syndbg->options;
+		break;
+	default:
+		break;
+	}
+
+	trace_kvm_hv_syndbg_get_msr(vcpu->vcpu_id,
+				    vcpu_to_hv_vcpu(vcpu)->vp_index, msr,
+				    *pdata);
+
+	return 0;
+}
+
 static int synic_get_msr(struct kvm_vcpu_hv_synic *synic, u32 msr, u64 *pdata,
 			 bool host)
 {
@@ -800,6 +918,8 @@ static bool kvm_hv_msr_partition_wide(u32 msr)
 	case HV_X64_MSR_REENLIGHTENMENT_CONTROL:
 	case HV_X64_MSR_TSC_EMULATION_CONTROL:
 	case HV_X64_MSR_TSC_EMULATION_STATUS:
+	case HV_X64_MSR_SYNDBG_OPTIONS:
+	case HV_X64_MSR_SYNDBG_CONTROL ... HV_X64_MSR_SYNDBG_PENDING_BUFFER:
 		r = true;
 		break;
 	}
@@ -1061,6 +1181,9 @@ static int kvm_hv_set_msr_pw(struct kvm_vcpu *vcpu, u32 msr, u64 data,
 		if (!host)
 			return 1;
 		break;
+	case HV_X64_MSR_SYNDBG_OPTIONS:
+	case HV_X64_MSR_SYNDBG_CONTROL ... HV_X64_MSR_SYNDBG_PENDING_BUFFER:
+		return syndbg_set_msr(vcpu, msr, data, host);
 	default:
 		vcpu_unimpl(vcpu, "Hyper-V unhandled wrmsr: 0x%x data 0x%llx\n",
 			    msr, data);
@@ -1190,7 +1313,8 @@ static int kvm_hv_set_msr(struct kvm_vcpu *vcpu, u32 msr, u64 data, bool host)
 	return 0;
 }
 
-static int kvm_hv_get_msr_pw(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata)
+static int kvm_hv_get_msr_pw(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata,
+			     bool host)
 {
 	u64 data = 0;
 	struct kvm *kvm = vcpu->kvm;
@@ -1227,6 +1351,9 @@ static int kvm_hv_get_msr_pw(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata)
 	case HV_X64_MSR_TSC_EMULATION_STATUS:
 		data = hv->hv_tsc_emulation_status;
 		break;
+	case HV_X64_MSR_SYNDBG_OPTIONS:
+	case HV_X64_MSR_SYNDBG_CONTROL ... HV_X64_MSR_SYNDBG_PENDING_BUFFER:
+		return syndbg_get_msr(vcpu, msr, pdata, host);
 	default:
 		vcpu_unimpl(vcpu, "Hyper-V unhandled rdmsr: 0x%x\n", msr);
 		return 1;
@@ -1316,7 +1443,7 @@ int kvm_hv_get_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata, bool host)
 		int r;
 
 		mutex_lock(&vcpu->kvm->arch.hyperv.hv_lock);
-		r = kvm_hv_get_msr_pw(vcpu, msr, pdata);
+		r = kvm_hv_get_msr_pw(vcpu, msr, pdata, host);
 		mutex_unlock(&vcpu->kvm->arch.hyperv.hv_lock);
 		return r;
 	} else
@@ -1796,6 +1923,9 @@ int kvm_vcpu_ioctl_get_hv_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid,
 		{ .function = HYPERV_CPUID_FEATURES },
 		{ .function = HYPERV_CPUID_ENLIGHTMENT_INFO },
 		{ .function = HYPERV_CPUID_IMPLEMENT_LIMITS },
+		{ .function = HYPERV_CPUID_SYNDBG_VENDOR_AND_MAX_FUNCTIONS },
+		{ .function = HYPERV_CPUID_SYNDBG_INTERFACE },
+		{ .function = HYPERV_CPUID_SYNDBG_PLATFORM_CAPABILITIES	},
 		{ .function = HYPERV_CPUID_NESTED_FEATURES },
 	};
 	int i, nent = ARRAY_SIZE(cpuid_entries);
@@ -1821,7 +1951,7 @@ int kvm_vcpu_ioctl_get_hv_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid,
 		case HYPERV_CPUID_VENDOR_AND_MAX_FUNCTIONS:
 			memcpy(signature, "Linux KVM Hv", 12);
 
-			ent->eax = HYPERV_CPUID_NESTED_FEATURES;
+			ent->eax = HYPERV_CPUID_SYNDBG_PLATFORM_CAPABILITIES;
 			ent->ebx = signature[0];
 			ent->ecx = signature[1];
 			ent->edx = signature[2];
@@ -1860,6 +1990,10 @@ int kvm_vcpu_ioctl_get_hv_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid,
 			ent->edx |= HV_FEATURE_FREQUENCY_MSRS_AVAILABLE;
 			ent->edx |= HV_FEATURE_GUEST_CRASH_MSR_AVAILABLE;
 
+			ent->ebx |= HV_X64_DEBUGGING;
+			ent->edx |= HV_X64_GUEST_DEBUGGING_AVAILABLE;
+			ent->edx |= HV_FEATURE_DEBUG_MSRS_AVAILABLE;
+
 			/*
 			 * Direct Synthetic timers only make sense with in-kernel
 			 * LAPIC
@@ -1903,6 +2037,24 @@ int kvm_vcpu_ioctl_get_hv_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid,
 
 			break;
 
+		case HYPERV_CPUID_SYNDBG_VENDOR_AND_MAX_FUNCTIONS:
+			memcpy(signature, "Linux KVM Hv", 12);
+
+			ent->eax = 0;
+			ent->ebx = signature[0];
+			ent->ecx = signature[1];
+			ent->edx = signature[2];
+			break;
+
+		case HYPERV_CPUID_SYNDBG_INTERFACE:
+			memcpy(signature, "VS#1\0\0\0\0\0\0\0\0", 12);
+			ent->eax = signature[0];
+			break;
+
+		case HYPERV_CPUID_SYNDBG_PLATFORM_CAPABILITIES:
+			ent->eax |= HV_X64_SYNDBG_CAP_ALLOW_KERNEL_DEBUGGING;
+			break;
+
 		default:
 			break;
 		}
diff --git a/arch/x86/kvm/hyperv.h b/arch/x86/kvm/hyperv.h
index 7f50ff0bad07..e68c6c2e9649 100644
--- a/arch/x86/kvm/hyperv.h
+++ b/arch/x86/kvm/hyperv.h
@@ -73,6 +73,11 @@ static inline struct kvm_vcpu *synic_to_vcpu(struct kvm_vcpu_hv_synic *synic)
 	return hv_vcpu_to_vcpu(container_of(synic, struct kvm_vcpu_hv, synic));
 }
 
+static inline struct kvm_hv_syndbg *vcpu_to_hv_syndbg(struct kvm_vcpu *vcpu)
+{
+	return &vcpu->kvm->arch.hyperv.hv_syndbg;
+}
+
 int kvm_hv_set_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 data, bool host);
 int kvm_hv_get_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata, bool host);
 
diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index 249062f24b94..df95c45ec3bb 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -1539,6 +1539,57 @@ TRACE_EVENT(kvm_nested_vmenter_failed,
 		__print_symbolic(__entry->err, VMX_VMENTER_INSTRUCTION_ERRORS))
 );
 
+/*
+ * Tracepoint for syndbg_set_msr.
+ */
+TRACE_EVENT(kvm_hv_syndbg_set_msr,
+	TP_PROTO(int vcpu_id, u32 vp_index, u32 msr, u64 data),
+	TP_ARGS(vcpu_id, vp_index, msr, data),
+
+	TP_STRUCT__entry(
+		__field(int, vcpu_id)
+		__field(u32, vp_index)
+		__field(u32, msr)
+		__field(u64, data)
+	),
+
+	TP_fast_assign(
+		__entry->vcpu_id = vcpu_id;
+		__entry->vp_index = vp_index;
+		__entry->msr = msr;
+		__entry->data = data;
+	),
+
+	TP_printk("vcpu_id %d vp_index %u msr 0x%x data 0x%llx",
+		  __entry->vcpu_id, __entry->vp_index, __entry->msr,
+		  __entry->data)
+);
+
+/*
+ * Tracepoint for syndbg_get_msr.
+ */
+TRACE_EVENT(kvm_hv_syndbg_get_msr,
+	TP_PROTO(int vcpu_id, u32 vp_index, u32 msr, u64 data),
+	TP_ARGS(vcpu_id, vp_index, msr, data),
+
+	TP_STRUCT__entry(
+		__field(int, vcpu_id)
+		__field(u32, vp_index)
+		__field(u32, msr)
+		__field(u64, data)
+	),
+
+	TP_fast_assign(
+		__entry->vcpu_id = vcpu_id;
+		__entry->vp_index = vp_index;
+		__entry->msr = msr;
+		__entry->data = data;
+	),
+
+	TP_printk("vcpu_id %d vp_index %u msr 0x%x data 0x%llx",
+		  __entry->vcpu_id, __entry->vp_index, __entry->msr,
+		  __entry->data)
+);
 #endif /* _TRACE_KVM_H */
 
 #undef TRACE_INCLUDE_PATH
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c17e6eb9ad43..26f89660a6f6 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1233,6 +1233,10 @@ static const u32 emulated_msrs_all[] = {
 	HV_X64_MSR_VP_ASSIST_PAGE,
 	HV_X64_MSR_REENLIGHTENMENT_CONTROL, HV_X64_MSR_TSC_EMULATION_CONTROL,
 	HV_X64_MSR_TSC_EMULATION_STATUS,
+	HV_X64_MSR_SYNDBG_OPTIONS,
+	HV_X64_MSR_SYNDBG_CONTROL, HV_X64_MSR_SYNDBG_STATUS,
+	HV_X64_MSR_SYNDBG_SEND_BUFFER, HV_X64_MSR_SYNDBG_RECV_BUFFER,
+	HV_X64_MSR_SYNDBG_PENDING_BUFFER,
 
 	MSR_KVM_ASYNC_PF_EN, MSR_KVM_STEAL_TIME,
 	MSR_KVM_PV_EOI_EN,
@@ -2932,6 +2936,8 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		 */
 		break;
 	case HV_X64_MSR_GUEST_OS_ID ... HV_X64_MSR_SINT15:
+	case HV_X64_MSR_SYNDBG_CONTROL ... HV_X64_MSR_SYNDBG_PENDING_BUFFER:
+	case HV_X64_MSR_SYNDBG_OPTIONS:
 	case HV_X64_MSR_CRASH_P0 ... HV_X64_MSR_CRASH_P4:
 	case HV_X64_MSR_CRASH_CTL:
 	case HV_X64_MSR_STIMER0_CONFIG ... HV_X64_MSR_STIMER3_COUNT:
@@ -3187,6 +3193,8 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		msr_info->data = 0x20000000;
 		break;
 	case HV_X64_MSR_GUEST_OS_ID ... HV_X64_MSR_SINT15:
+	case HV_X64_MSR_SYNDBG_CONTROL ... HV_X64_MSR_SYNDBG_PENDING_BUFFER:
+	case HV_X64_MSR_SYNDBG_OPTIONS:
 	case HV_X64_MSR_CRASH_P0 ... HV_X64_MSR_CRASH_P4:
 	case HV_X64_MSR_CRASH_CTL:
 	case HV_X64_MSR_STIMER0_CONFIG ... HV_X64_MSR_STIMER3_COUNT:
@@ -3358,6 +3366,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_HYPERV_TLBFLUSH:
 	case KVM_CAP_HYPERV_SEND_IPI:
 	case KVM_CAP_HYPERV_CPUID:
+	case KVM_CAP_HYPERV_SYNDBG:
 	case KVM_CAP_PCI_SEGMENT:
 	case KVM_CAP_DEBUGREGS:
 	case KVM_CAP_X86_ROBUST_SINGLESTEP:
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 9cdc5356f542..ec1b2c7b449e 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -188,6 +188,7 @@ struct kvm_s390_cmma_log {
 struct kvm_hyperv_exit {
 #define KVM_EXIT_HYPERV_SYNIC          1
 #define KVM_EXIT_HYPERV_HCALL          2
+#define KVM_EXIT_HYPERV_SYNDBG         3
 	__u32 type;
 	__u32 pad1;
 	union {
@@ -203,6 +204,15 @@ struct kvm_hyperv_exit {
 			__u64 result;
 			__u64 params[2];
 		} hcall;
+		struct {
+			__u32 msr;
+			__u32 pad2;
+			__u64 control;
+			__u64 status;
+			__u64 send_page;
+			__u64 recv_page;
+			__u64 pending_page;
+		} syndbg;
 	} u;
 };
 
@@ -1019,6 +1029,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_S390_VCPU_RESETS 179
 #define KVM_CAP_S390_PROTECTED 180
 #define KVM_CAP_PPC_SECURE_GUEST 181
+#define KVM_CAP_HYPERV_SYNDBG 182
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
2.24.1

