Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 175371B7345
	for <lists+kvm@lfdr.de>; Fri, 24 Apr 2020 13:38:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727039AbgDXLiM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Apr 2020 07:38:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727044AbgDXLiL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Apr 2020 07:38:11 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78BAAC09B045;
        Fri, 24 Apr 2020 04:38:09 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id s10so10413090wrr.0;
        Fri, 24 Apr 2020 04:38:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OID6aVyRGdNlga7hA9OiJ6lO0t4PTWFR0gHXeaUp+Is=;
        b=I8P8QiuW5Hnrv8K7svmfELrLu0paJlM7xc6GHcKMUyrGKRlEkK/fthh4knT7VDSDrV
         8wzTKPIQBh7a6R31mbvumVa9tlCG8S1bnQui4rHDMYHjCNJTfEqvt6xzxm4IQaZqRhv5
         ZkEL+3YPbWJoL7RZpfsChW8of4mKNMdrx27ival9tUyS1G5H35diYJuNnu7anIhfnCuW
         v9ONWwmlGv7s6dhAUBpRn6jveJK+GdkVIVQbEip4BaBIzvZQNIFfYG8Uk7/k1pyInhDy
         CG4RDYMOCyTzETYGpwepefu//PJtBjoWHhR0bdQVKRqUA0Z7EcCWwHqlo0bw8v6Pe9Bw
         bBaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OID6aVyRGdNlga7hA9OiJ6lO0t4PTWFR0gHXeaUp+Is=;
        b=BuihYQGxq6VASMbBUY3EY1+NTv3r7AYmYRPa9YuRnO9ew732Wo6T6vY68mBYmAxgAl
         q8fRELOS6r9r8oB27CuxrLzfeohyswhoMN7qK76hkISdakDySzjy+/fsHgGYwIkwvqIt
         QgdVkJj6/IXHWu06Mj26jqd16PAS7n3D3GUkk5mBsz0ulPfdSDXIYBe4Sbb5/yi+FHR8
         J1Whk2eTkYfgmGY+jcTYNwReMFdfbrSpJLS4PjvnZ2HFwM/+6AdrLil66jQE6UiAqN1O
         7m7NWOIDwhynlZ4VYtqevWIavCJ3rKTxjTR+r+BdSpwpvZMTHLayjf/Be22211PEjhwe
         fd6Q==
X-Gm-Message-State: AGi0PubpVK/cf8/oqPxwAayPHvlkASmuNDS5NwLINJ/V4eP6PHexEnrh
        GjM0PGzAasNf+cLxKUExPm+WgiSoXao=
X-Google-Smtp-Source: APiQypKYzs859i3AryDB46QvnF24MMlODFPx7nOTuKwSzx0mw9v/GCbMOkSuwZHXJVelBPHjwK1BLA==
X-Received: by 2002:a5d:6188:: with SMTP id j8mr10282034wru.119.1587728287650;
        Fri, 24 Apr 2020 04:38:07 -0700 (PDT)
Received: from jondnuc.lan (IGLD-84-229-154-20.inter.net.il. [84.229.154.20])
        by smtp.gmail.com with ESMTPSA id w83sm2451007wmb.37.2020.04.24.04.38.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Apr 2020 04:38:06 -0700 (PDT)
From:   Jon Doron <arilou@gmail.com>
To:     kvm@vger.kernel.org, linux-hyperv@vger.kernel.org
Cc:     vkuznets@redhat.com, Jon Doron <arilou@gmail.com>
Subject: [PATCH v11 4/7] x86/kvm/hyper-v: Add support for synthetic debugger capability
Date:   Fri, 24 Apr 2020 14:37:43 +0300
Message-Id: <20200424113746.3473563-5-arilou@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200424113746.3473563-1-arilou@gmail.com>
References: <20200424113746.3473563-1-arilou@gmail.com>
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
 arch/x86/include/asm/kvm_host.h |  14 +++
 arch/x86/kvm/hyperv.c           | 165 +++++++++++++++++++++++++++++++-
 arch/x86/kvm/hyperv.h           |   6 ++
 arch/x86/kvm/trace.h            |  51 ++++++++++
 arch/x86/kvm/x86.c              |  13 +++
 include/uapi/linux/kvm.h        |  11 +++
 7 files changed, 273 insertions(+), 3 deletions(-)

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
index 42a2d0d3984a..563a9e69f113 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -854,6 +854,19 @@ struct kvm_apic_map {
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
+	bool active;
+};
+
 /* Hyper-V emulation context */
 struct kvm_hv {
 	struct mutex hv_lock;
@@ -877,6 +890,7 @@ struct kvm_hv {
 	atomic_t num_mismatched_vp_indexes;
 
 	struct hv_partition_assist_pg *hv_pa_pg;
+	struct kvm_hv_syndbg hv_syndbg;
 };
 
 enum kvm_irqchip_mode {
diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index ab3e9dbcabbe..435516595090 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -266,6 +266,117 @@ static int synic_set_msr(struct kvm_vcpu_hv_synic *synic,
 	return ret;
 }
 
+void kvm_hv_activate_syndbg(struct kvm_vcpu *vcpu)
+{
+	struct kvm_hv_syndbg *syndbg = vcpu_to_hv_syndbg(vcpu);
+
+	syndbg->active = true;
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
+	if (!syndbg->active && !host)
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
+	if (!syndbg->active && !host)
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
@@ -800,6 +911,8 @@ static bool kvm_hv_msr_partition_wide(u32 msr)
 	case HV_X64_MSR_REENLIGHTENMENT_CONTROL:
 	case HV_X64_MSR_TSC_EMULATION_CONTROL:
 	case HV_X64_MSR_TSC_EMULATION_STATUS:
+	case HV_X64_MSR_SYNDBG_OPTIONS:
+	case HV_X64_MSR_SYNDBG_CONTROL ... HV_X64_MSR_SYNDBG_PENDING_BUFFER:
 		r = true;
 		break;
 	}
@@ -1061,6 +1174,9 @@ static int kvm_hv_set_msr_pw(struct kvm_vcpu *vcpu, u32 msr, u64 data,
 		if (!host)
 			return 1;
 		break;
+	case HV_X64_MSR_SYNDBG_OPTIONS:
+	case HV_X64_MSR_SYNDBG_CONTROL ... HV_X64_MSR_SYNDBG_PENDING_BUFFER:
+		return syndbg_set_msr(vcpu, msr, data, host);
 	default:
 		vcpu_unimpl(vcpu, "Hyper-V unhandled wrmsr: 0x%x data 0x%llx\n",
 			    msr, data);
@@ -1190,7 +1306,8 @@ static int kvm_hv_set_msr(struct kvm_vcpu *vcpu, u32 msr, u64 data, bool host)
 	return 0;
 }
 
-static int kvm_hv_get_msr_pw(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata)
+static int kvm_hv_get_msr_pw(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata,
+			     bool host)
 {
 	u64 data = 0;
 	struct kvm *kvm = vcpu->kvm;
@@ -1227,6 +1344,9 @@ static int kvm_hv_get_msr_pw(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata)
 	case HV_X64_MSR_TSC_EMULATION_STATUS:
 		data = hv->hv_tsc_emulation_status;
 		break;
+	case HV_X64_MSR_SYNDBG_OPTIONS:
+	case HV_X64_MSR_SYNDBG_CONTROL ... HV_X64_MSR_SYNDBG_PENDING_BUFFER:
+		return syndbg_get_msr(vcpu, msr, pdata, host);
 	default:
 		vcpu_unimpl(vcpu, "Hyper-V unhandled rdmsr: 0x%x\n", msr);
 		return 1;
@@ -1316,7 +1436,7 @@ int kvm_hv_get_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata, bool host)
 		int r;
 
 		mutex_lock(&vcpu->kvm->arch.hyperv.hv_lock);
-		r = kvm_hv_get_msr_pw(vcpu, msr, pdata);
+		r = kvm_hv_get_msr_pw(vcpu, msr, pdata, host);
 		mutex_unlock(&vcpu->kvm->arch.hyperv.hv_lock);
 		return r;
 	} else
@@ -1799,9 +1919,16 @@ static struct kvm_cpuid_entry2 evmcs_cpuid_entries[] = {
 	{ .function = HYPERV_CPUID_NESTED_FEATURES },
 };
 
+static struct kvm_cpuid_entry2 syndbg_cpuid_entries[] = {
+	{ .function = HYPERV_CPUID_SYNDBG_VENDOR_AND_MAX_FUNCTIONS },
+	{ .function = HYPERV_CPUID_SYNDBG_INTERFACE },
+	{ .function = HYPERV_CPUID_SYNDBG_PLATFORM_CAPABILITIES	},
+};
+
 #define HV_MAX_CPUID_ENTRIES \
 	(ARRAY_SIZE(core_cpuid_entries) +\
-	 ARRAY_SIZE(evmcs_cpuid_entries))
+	 ARRAY_SIZE(evmcs_cpuid_entries) +\
+	 ARRAY_SIZE(syndbg_cpuid_entries))
 
 int kvm_vcpu_ioctl_get_hv_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid,
 				struct kvm_cpuid_entry2 __user *entries)
@@ -1809,6 +1936,7 @@ int kvm_vcpu_ioctl_get_hv_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid,
 	uint16_t evmcs_ver = 0;
 	struct kvm_cpuid_entry2 cpuid_entries[HV_MAX_CPUID_ENTRIES];
 	int i, nent = 0;
+	struct kvm_hv_syndbg *syndbg = vcpu_to_hv_syndbg(vcpu);
 
 	/* Set the core cpuid entries required for Hyper-V */
 	memcpy(&cpuid_entries[nent], &core_cpuid_entries,
@@ -1825,6 +1953,13 @@ int kvm_vcpu_ioctl_get_hv_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid,
 		nent += ARRAY_SIZE(evmcs_cpuid_entries);
 	}
 
+	if (syndbg->active) {
+		/* Syndbg is enabled, add the required Syndbg CPUID leafs */
+		memcpy(&cpuid_entries[nent], &syndbg_cpuid_entries,
+		       sizeof(syndbg_cpuid_entries));
+		nent += ARRAY_SIZE(syndbg_cpuid_entries);
+	}
+
 	if (cpuid->nent < nent)
 		return -E2BIG;
 
@@ -1878,6 +2013,12 @@ int kvm_vcpu_ioctl_get_hv_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid,
 			ent->edx |= HV_FEATURE_FREQUENCY_MSRS_AVAILABLE;
 			ent->edx |= HV_FEATURE_GUEST_CRASH_MSR_AVAILABLE;
 
+			if (syndbg->active) {
+				ent->ebx |= HV_X64_DEBUGGING;
+				ent->edx |= HV_X64_GUEST_DEBUGGING_AVAILABLE;
+				ent->edx |= HV_FEATURE_DEBUG_MSRS_AVAILABLE;
+			}
+
 			/*
 			 * Direct Synthetic timers only make sense with in-kernel
 			 * LAPIC
@@ -1921,6 +2062,24 @@ int kvm_vcpu_ioctl_get_hv_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid,
 
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
index 7f50ff0bad07..50cca85b5e48 100644
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
 
@@ -83,6 +88,7 @@ void kvm_hv_irq_routing_update(struct kvm *kvm);
 int kvm_hv_synic_set_irq(struct kvm *kvm, u32 vcpu_id, u32 sint);
 void kvm_hv_synic_send_eoi(struct kvm_vcpu *vcpu, int vector);
 int kvm_hv_activate_synic(struct kvm_vcpu *vcpu, bool dont_zero_synic_pages);
+void kvm_hv_activate_syndbg(struct kvm_vcpu *vcpu);
 
 void kvm_hv_vcpu_init(struct kvm_vcpu *vcpu);
 void kvm_hv_vcpu_postcreate(struct kvm_vcpu *vcpu);
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
index 3bf2ecafd027..28b304be5419 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1241,6 +1241,10 @@ static const u32 emulated_msrs_all[] = {
 	HV_X64_MSR_VP_ASSIST_PAGE,
 	HV_X64_MSR_REENLIGHTENMENT_CONTROL, HV_X64_MSR_TSC_EMULATION_CONTROL,
 	HV_X64_MSR_TSC_EMULATION_STATUS,
+	HV_X64_MSR_SYNDBG_OPTIONS,
+	HV_X64_MSR_SYNDBG_CONTROL, HV_X64_MSR_SYNDBG_STATUS,
+	HV_X64_MSR_SYNDBG_SEND_BUFFER, HV_X64_MSR_SYNDBG_RECV_BUFFER,
+	HV_X64_MSR_SYNDBG_PENDING_BUFFER,
 
 	MSR_KVM_ASYNC_PF_EN, MSR_KVM_STEAL_TIME,
 	MSR_KVM_PV_EOI_EN,
@@ -2940,6 +2944,8 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		 */
 		break;
 	case HV_X64_MSR_GUEST_OS_ID ... HV_X64_MSR_SINT15:
+	case HV_X64_MSR_SYNDBG_CONTROL ... HV_X64_MSR_SYNDBG_PENDING_BUFFER:
+	case HV_X64_MSR_SYNDBG_OPTIONS:
 	case HV_X64_MSR_CRASH_P0 ... HV_X64_MSR_CRASH_P4:
 	case HV_X64_MSR_CRASH_CTL:
 	case HV_X64_MSR_STIMER0_CONFIG ... HV_X64_MSR_STIMER3_COUNT:
@@ -3184,6 +3190,8 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		msr_info->data = 0x20000000;
 		break;
 	case HV_X64_MSR_GUEST_OS_ID ... HV_X64_MSR_SINT15:
+	case HV_X64_MSR_SYNDBG_CONTROL ... HV_X64_MSR_SYNDBG_PENDING_BUFFER:
+	case HV_X64_MSR_SYNDBG_OPTIONS:
 	case HV_X64_MSR_CRASH_P0 ... HV_X64_MSR_CRASH_P4:
 	case HV_X64_MSR_CRASH_CTL:
 	case HV_X64_MSR_STIMER0_CONFIG ... HV_X64_MSR_STIMER3_COUNT:
@@ -3355,6 +3363,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_HYPERV_TLBFLUSH:
 	case KVM_CAP_HYPERV_SEND_IPI:
 	case KVM_CAP_HYPERV_CPUID:
+	case KVM_CAP_HYPERV_SYNDBG:
 	case KVM_CAP_PCI_SEGMENT:
 	case KVM_CAP_DEBUGREGS:
 	case KVM_CAP_X86_ROBUST_SINGLESTEP:
@@ -4209,6 +4218,10 @@ static int kvm_vcpu_ioctl_enable_cap(struct kvm_vcpu *vcpu,
 		return -EINVAL;
 
 	switch (cap->cap) {
+	case KVM_CAP_HYPERV_SYNDBG:
+		kvm_hv_activate_syndbg(vcpu);
+		return 0;
+
 	case KVM_CAP_HYPERV_SYNIC2:
 		if (cap->args[0])
 			return -EINVAL;
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

