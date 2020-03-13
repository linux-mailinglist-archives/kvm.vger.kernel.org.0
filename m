Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BE041847EB
	for <lists+kvm@lfdr.de>; Fri, 13 Mar 2020 14:21:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726637AbgCMNVC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Mar 2020 09:21:02 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:39859 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726642AbgCMNVB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Mar 2020 09:21:01 -0400
Received: by mail-wm1-f65.google.com with SMTP id f7so10264836wml.4;
        Fri, 13 Mar 2020 06:21:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1Zvgi5rkuek3Ed87nuE+THuyaSMIn47jBgR7d38SrB4=;
        b=eZI0O2T2cD1RXoP91CIOyMDhihBYczuPIDmVePrO5VMsvNX+zUvddu5iB1SnbtDPqX
         XwjN6IOg+n09qHOoJeonKPjlLMf+PsiIiEHmOMrJxoWA/SsHeGg5MsABh7uq6TA+T7Ga
         7WhaqxdSVT1IbioTtrG4V0QRIRz4sah/DG5sf+R7IfU6P8a/4cWzAMpVsvEJh+LltOAx
         1X7ChZDAEkhGGXqDIM6PKaJaZiBq2+C/SqKviWnFcz4X9PZOwv9nUW0R34FiHhOcIYPT
         opXXDFkMdvCbW/C1kvrTYZspdYwhjQZfN9i/fYUSEpAhAiZQl65ia7qFYyVoRVLu/pOX
         zHFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1Zvgi5rkuek3Ed87nuE+THuyaSMIn47jBgR7d38SrB4=;
        b=lHscdtprUOZ1SqNkEAuDR7EOuua6Hfd11qCqKSxW+7KfsmMUJsKgixJL5O1QnDayJL
         jTI+/RWAa8KIi29ZjlMbPmahMCzoG/VGF8RtZ+k2P2p11U0hpC047Po0aSd0+21fs6+l
         UXQZQlQSTiKnUHwwd2oIcokaNgoKDcw+ZfLJpl2SebQkxybjqKrhhQlySd0lfB5+F4AS
         zTO7gdcH3KxRplE07jOHMAydLpgkbASpCg+Wv/WKloFTa9N4kFiTSUGMChhUp1FdTz9g
         owgtSJMWskwYyYeiwjOvbCHOh+FB9KP9DhYj/hDYWhSXdakonQRuu/9WI93ahYGBFKW3
         wUCg==
X-Gm-Message-State: ANhLgQ32mC9Kmroi+N31YSDejDyOGePCiu3kkroQTn32sSjGHKD+bCD/
        M2wZKrBIgF3KHdDzKPQlzqp0n27Nwe4=
X-Google-Smtp-Source: ADFU+vuESjSfMTeCGp1aZ1RiDqa/bdJ0mOJiTZvTvXEOjnDY9ER47HMdpAesYabxrVivc6q+6bIqUw==
X-Received: by 2002:a1c:b183:: with SMTP id a125mr11163451wmf.46.1584105658976;
        Fri, 13 Mar 2020 06:20:58 -0700 (PDT)
Received: from jondnuc.lan (IGLD-84-229-155-229.inter.net.il. [84.229.155.229])
        by smtp.gmail.com with ESMTPSA id v8sm77112121wrw.2.2020.03.13.06.20.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Mar 2020 06:20:58 -0700 (PDT)
From:   Jon Doron <arilou@gmail.com>
To:     kvm@vger.kernel.org, linux-hyperv@vger.kernel.org
Cc:     vkuznets@redhat.com, Jon Doron <arilou@gmail.com>
Subject: [PATCH v5 3/5] x86/kvm/hyper-v: Add support for synthetic debugger capability
Date:   Fri, 13 Mar 2020 15:20:32 +0200
Message-Id: <20200313132034.132315-4-arilou@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200313132034.132315-1-arilou@gmail.com>
References: <20200313132034.132315-1-arilou@gmail.com>
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

Signed-off-by: Jon Doron <arilou@gmail.com>
---
 Documentation/virt/kvm/api.rst  |  16 ++++
 arch/x86/include/asm/kvm_host.h |  13 +++
 arch/x86/kvm/hyperv.c           | 135 +++++++++++++++++++++++++++++++-
 arch/x86/kvm/hyperv.h           |   5 ++
 arch/x86/kvm/trace.h            |  51 ++++++++++++
 arch/x86/kvm/x86.c              |   9 +++
 include/uapi/linux/kvm.h        |  11 +++
 7 files changed, 239 insertions(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 4872c47bbcff..fe992dcf4f93 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -5024,6 +5024,7 @@ EOI was received.
 		struct kvm_hyperv_exit {
   #define KVM_EXIT_HYPERV_SYNIC          1
   #define KVM_EXIT_HYPERV_HCALL          2
+  #define KVM_EXIT_HYPERV_SYNDBG         3
 			__u32 type;
 			__u32 pad1;
 			union {
@@ -5039,6 +5040,15 @@ EOI was received.
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
@@ -5055,6 +5065,12 @@ Hyper-V SynIC state change. Notification is used to remap SynIC
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
index 98959e8cd448..f8e58e8866bb 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -854,6 +854,18 @@ struct kvm_apic_map {
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
@@ -877,6 +889,7 @@ struct kvm_hv {
 	atomic_t num_mismatched_vp_indexes;
 
 	struct hv_partition_assist_pg *hv_pa_pg;
+	struct kvm_hv_syndbg hv_syndbg;
 };
 
 enum kvm_irqchip_mode {
diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index a86fda7a1d03..b6a97abe2bc9 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -266,6 +266,107 @@ static int synic_set_msr(struct kvm_vcpu_hv_synic *synic,
 	return ret;
 }
 
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
+static int syndbg_set_msr(struct kvm_vcpu *vcpu, u32 msr, u64 data)
+{
+	struct kvm_hv_syndbg *syndbg = vcpu_to_hv_syndbg(vcpu);
+	int ret;
+
+	trace_kvm_hv_syndbg_set_msr(vcpu->vcpu_id,
+				    vcpu_to_hv_vcpu(vcpu)->vp_index, msr, data);
+	ret = 0;
+	switch (msr) {
+	case HV_X64_MSR_SYNDBG_CONTROL:
+		syndbg->control.control = data;
+		syndbg_exit(vcpu, msr);
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
+		syndbg_exit(vcpu, msr);
+		break;
+	case HV_X64_MSR_SYNDBG_OPTIONS:
+		syndbg->options = data;
+		break;
+	default:
+		ret = 1;
+		break;
+	}
+
+	return ret;
+}
+
+static int syndbg_get_msr(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata)
+{
+	struct kvm_hv_syndbg *syndbg = vcpu_to_hv_syndbg(vcpu);
+	int ret;
+
+	ret = 0;
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
+		ret = 1;
+		break;
+	}
+
+	trace_kvm_hv_syndbg_get_msr(vcpu->vcpu_id,
+				    vcpu_to_hv_vcpu(vcpu)->vp_index, msr,
+				    *pdata);
+	return ret;
+}
+
 static int synic_get_msr(struct kvm_vcpu_hv_synic *synic, u32 msr, u64 *pdata,
 			 bool host)
 {
@@ -800,6 +901,8 @@ static bool kvm_hv_msr_partition_wide(u32 msr)
 	case HV_X64_MSR_REENLIGHTENMENT_CONTROL:
 	case HV_X64_MSR_TSC_EMULATION_CONTROL:
 	case HV_X64_MSR_TSC_EMULATION_STATUS:
+	case HV_X64_MSR_SYNDBG_OPTIONS:
+	case HV_X64_MSR_SYNDBG_CONTROL ... HV_X64_MSR_SYNDBG_PENDING_BUFFER:
 		r = true;
 		break;
 	}
@@ -1061,6 +1164,9 @@ static int kvm_hv_set_msr_pw(struct kvm_vcpu *vcpu, u32 msr, u64 data,
 		if (!host)
 			return 1;
 		break;
+	case HV_X64_MSR_SYNDBG_OPTIONS:
+	case HV_X64_MSR_SYNDBG_CONTROL ... HV_X64_MSR_SYNDBG_PENDING_BUFFER:
+		return syndbg_set_msr(vcpu, msr, data);
 	default:
 		vcpu_unimpl(vcpu, "Hyper-V unhandled wrmsr: 0x%x data 0x%llx\n",
 			    msr, data);
@@ -1227,6 +1333,9 @@ static int kvm_hv_get_msr_pw(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata)
 	case HV_X64_MSR_TSC_EMULATION_STATUS:
 		data = hv->hv_tsc_emulation_status;
 		break;
+	case HV_X64_MSR_SYNDBG_OPTIONS:
+	case HV_X64_MSR_SYNDBG_CONTROL ... HV_X64_MSR_SYNDBG_PENDING_BUFFER:
+		return syndbg_get_msr(vcpu, msr, pdata);
 	default:
 		vcpu_unimpl(vcpu, "Hyper-V unhandled rdmsr: 0x%x\n", msr);
 		return 1;
@@ -1797,6 +1906,9 @@ int kvm_vcpu_ioctl_get_hv_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid,
 		{ .function = HYPERV_CPUID_ENLIGHTMENT_INFO },
 		{ .function = HYPERV_CPUID_IMPLEMENT_LIMITS },
 		{ .function = HYPERV_CPUID_NESTED_FEATURES },
+		{ .function = HYPERV_CPUID_SYNDBG_VENDOR_AND_MAX_FUNCTIONS },
+		{ .function = HYPERV_CPUID_SYNDBG_INTERFACE },
+		{ .function = HYPERV_CPUID_SYNDBG_PLATFORM_CAPABILITIES	},
 	};
 	int i, nent = ARRAY_SIZE(cpuid_entries);
 
@@ -1821,7 +1933,7 @@ int kvm_vcpu_ioctl_get_hv_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid,
 		case HYPERV_CPUID_VENDOR_AND_MAX_FUNCTIONS:
 			memcpy(signature, "Linux KVM Hv", 12);
 
-			ent->eax = HYPERV_CPUID_NESTED_FEATURES;
+			ent->eax = HYPERV_CPUID_SYNDBG_PLATFORM_CAPABILITIES;
 			ent->ebx = signature[0];
 			ent->ecx = signature[1];
 			ent->edx = signature[2];
@@ -1856,9 +1968,12 @@ int kvm_vcpu_ioctl_get_hv_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid,
 
 			ent->ebx |= HV_X64_POST_MESSAGES;
 			ent->ebx |= HV_X64_SIGNAL_EVENTS;
+			ent->ebx |= HV_X64_DEBUGGING;
 
 			ent->edx |= HV_FEATURE_FREQUENCY_MSRS_AVAILABLE;
 			ent->edx |= HV_FEATURE_GUEST_CRASH_MSR_AVAILABLE;
+			ent->edx |= HV_X64_GUEST_DEBUGGING_AVAILABLE;
+			ent->edx |= HV_FEATURE_DEBUG_MSRS_AVAILABLE;
 
 			/*
 			 * Direct Synthetic timers only make sense with in-kernel
@@ -1903,6 +2018,24 @@ int kvm_vcpu_ioctl_get_hv_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid,
 
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
index 56bc3416b62f..b8695dc5a3c0 100644
--- a/arch/x86/kvm/hyperv.h
+++ b/arch/x86/kvm/hyperv.h
@@ -68,6 +68,11 @@ static inline struct kvm_vcpu *synic_to_vcpu(struct kvm_vcpu_hv_synic *synic)
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
index f194dd058470..bf6c3852868d 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -1515,6 +1515,57 @@ TRACE_EVENT(kvm_nested_vmenter_failed,
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
index 5de200663f51..619c24bac79e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1214,6 +1214,10 @@ static const u32 emulated_msrs_all[] = {
 	HV_X64_MSR_VP_ASSIST_PAGE,
 	HV_X64_MSR_REENLIGHTENMENT_CONTROL, HV_X64_MSR_TSC_EMULATION_CONTROL,
 	HV_X64_MSR_TSC_EMULATION_STATUS,
+	HV_X64_MSR_SYNDBG_OPTIONS,
+	HV_X64_MSR_SYNDBG_CONTROL, HV_X64_MSR_SYNDBG_STATUS,
+	HV_X64_MSR_SYNDBG_SEND_BUFFER, HV_X64_MSR_SYNDBG_RECV_BUFFER,
+	HV_X64_MSR_SYNDBG_PENDING_BUFFER,
 
 	MSR_KVM_ASYNC_PF_EN, MSR_KVM_STEAL_TIME,
 	MSR_KVM_PV_EOI_EN,
@@ -2906,6 +2910,8 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		 */
 		break;
 	case HV_X64_MSR_GUEST_OS_ID ... HV_X64_MSR_SINT15:
+	case HV_X64_MSR_SYNDBG_CONTROL ... HV_X64_MSR_SYNDBG_PENDING_BUFFER:
+	case HV_X64_MSR_SYNDBG_OPTIONS:
 	case HV_X64_MSR_CRASH_P0 ... HV_X64_MSR_CRASH_P4:
 	case HV_X64_MSR_CRASH_CTL:
 	case HV_X64_MSR_STIMER0_CONFIG ... HV_X64_MSR_STIMER3_COUNT:
@@ -3151,6 +3157,8 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		msr_info->data = 0x20000000;
 		break;
 	case HV_X64_MSR_GUEST_OS_ID ... HV_X64_MSR_SINT15:
+	case HV_X64_MSR_SYNDBG_CONTROL ... HV_X64_MSR_SYNDBG_PENDING_BUFFER:
+	case HV_X64_MSR_SYNDBG_OPTIONS:
 	case HV_X64_MSR_CRASH_P0 ... HV_X64_MSR_CRASH_P4:
 	case HV_X64_MSR_CRASH_CTL:
 	case HV_X64_MSR_STIMER0_CONFIG ... HV_X64_MSR_STIMER3_COUNT:
@@ -3323,6 +3331,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_HYPERV_TLBFLUSH:
 	case KVM_CAP_HYPERV_SEND_IPI:
 	case KVM_CAP_HYPERV_CPUID:
+	case KVM_CAP_HYPERV_DEBUGGING:
 	case KVM_CAP_PCI_SEGMENT:
 	case KVM_CAP_DEBUGREGS:
 	case KVM_CAP_X86_ROBUST_SINGLESTEP:
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 7ee0ddc4c457..f20b81894f23 100644
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
 
@@ -1012,6 +1022,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_ARM_NISV_TO_USER 177
 #define KVM_CAP_ARM_INJECT_EXT_DABT 178
 #define KVM_CAP_S390_VCPU_RESETS 179
+#define KVM_CAP_HYPERV_DEBUGGING 180
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
2.24.1

