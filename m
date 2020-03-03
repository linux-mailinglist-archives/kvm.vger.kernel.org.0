Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2BBE17769E
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2020 14:05:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729280AbgCCNEM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Mar 2020 08:04:12 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:32771 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728602AbgCCNEM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Mar 2020 08:04:12 -0500
Received: by mail-wm1-f68.google.com with SMTP id a25so2320292wmm.0
        for <kvm@vger.kernel.org>; Tue, 03 Mar 2020 05:04:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HBOsRyY7YIPQAQ60tzetiMJFheF1EFDUBhmMusYANqQ=;
        b=KutXbXi4YvACdnLfwoodun4kNtdd9ZroO34qf1xAGHSi7DIiF+XYeVLQ37qKdbaJ2e
         S/mjCyiZCi0a5XTkZf3Za0jlVjv0QT1ls3/1W3azyPARSqiBWQy14sMqAj1fZ7h/rysL
         NNdtLXsGcP6GOS/B+70GEOKxVIlp8KNk5dn/0e7qCP+4zPCweY2e/s/wyscWcSZu7wMW
         ES+LvM2aTz0pghpsoXFHlL7GRgEUVF9vdFbSmCipygZ7BFw8maz+CfHMaRQfqJ3eQLXr
         nKZRkgCqFXMwp0+KBiblbL+K51L2uJHX55SFQ4MIEm4Q/t1R6Gsq/oitHHByGPGGt7PY
         4dLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HBOsRyY7YIPQAQ60tzetiMJFheF1EFDUBhmMusYANqQ=;
        b=auh8/xrDcrwR0tnAMOYItI9IbuNIlbZbUee3qHbhNqiMapyYZi6MKMHB0eLl0z/y9F
         L7+l9AuqBbQWjUFFMxUeouliARvnLEtcKSz7KtfAt909NR5TlXNLtabrk4J92DbkSq15
         8F1XrCNDByLh3v9OwO1m93odWVx8RzXVwoLgJ+YiOjuwoRRThs4H/mtie4nm5WPMrSFQ
         v71g3xxCfGTzl9U8na2rxlxs17Pwjqm7QDO20A1rfLd4m0r3HKdpKHlBtDYUAh/oBAI+
         1INPCOi9atI0mzckkHGdIbgirqfsDI2uN/s5YzabtgXcgiNt1ZWxGIQQoPqZ0ooLIem6
         QSuw==
X-Gm-Message-State: ANhLgQ1fY7ot9yNyPi4JXmQGXDxH75vwp9+OpbpJRGdvpZrwfMXzBhJT
        sAsMMVwEYTkgpeXkIV/YJN6QQfG5
X-Google-Smtp-Source: ADFU+vsIevAqEV94/aZ8ye7VwH4K5mWOPQGg2PZcl/rb7v49NAkShLUAcfGnZ1VR7ORl9zB8uAzNEQ==
X-Received: by 2002:a1c:9dcb:: with SMTP id g194mr4474924wme.114.1583240648472;
        Tue, 03 Mar 2020 05:04:08 -0800 (PST)
Received: from linux.local ([199.203.162.213])
        by smtp.gmail.com with ESMTPSA id w17sm2171951wrm.92.2020.03.03.05.04.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2020 05:04:08 -0800 (PST)
From:   Jon Doron <arilou@gmail.com>
To:     kvm@vger.kernel.org
Cc:     vkuznets@redhat.com, Jon Doron <arilou@gmail.com>
Subject: [PATCH v1 1/3] x86/kvm/hyper-v: Add support for synthetic debugger capability
Date:   Tue,  3 Mar 2020 15:03:54 +0200
Message-Id: <20200303130356.50405-2-arilou@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200303130356.50405-1-arilou@gmail.com>
References: <20200303130356.50405-1-arilou@gmail.com>
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
 arch/x86/include/asm/hyperv-tlfs.h |  16 +++++
 arch/x86/include/asm/kvm_host.h    |  11 +++
 arch/x86/kvm/hyperv.c              | 109 +++++++++++++++++++++++++++++
 arch/x86/kvm/hyperv.h              |   5 ++
 arch/x86/kvm/trace.h               |  22 ++++++
 arch/x86/kvm/x86.c                 |   8 +++
 include/uapi/linux/kvm.h           |   9 +++
 7 files changed, 180 insertions(+)

diff --git a/arch/x86/include/asm/hyperv-tlfs.h b/arch/x86/include/asm/hyperv-tlfs.h
index 92abc1e42bfc..8efdf974c23f 100644
--- a/arch/x86/include/asm/hyperv-tlfs.h
+++ b/arch/x86/include/asm/hyperv-tlfs.h
@@ -33,6 +33,9 @@
 #define HYPERV_CPUID_ENLIGHTMENT_INFO		0x40000004
 #define HYPERV_CPUID_IMPLEMENT_LIMITS		0x40000005
 #define HYPERV_CPUID_NESTED_FEATURES		0x4000000A
+#define HYPERV_CPUID_SYNDBG_VENDOR_AND_MAX_FUNCTIONS	0x40000080
+#define HYPERV_CPUID_SYNDBG_INTERFACE			0x40000081
+#define HYPERV_CPUID_SYNDBG_PLATFORM_CAPABILITIES	0x40000082
 
 #define HYPERV_HYPERVISOR_PRESENT_BIT		0x80000000
 #define HYPERV_CPUID_MIN			0x40000005
@@ -131,6 +134,8 @@
 #define HV_FEATURE_FREQUENCY_MSRS_AVAILABLE		BIT(8)
 /* Crash MSR available */
 #define HV_FEATURE_GUEST_CRASH_MSR_AVAILABLE		BIT(10)
+/* Support for debug MSRs available */
+#define HV_FEATURE_DEBUG_MSRS_AVAILABLE			BIT(11)
 /* stimer Direct Mode is available */
 #define HV_STIMER_DIRECT_MODE_AVAILABLE			BIT(19)
 
@@ -194,6 +199,9 @@
 #define HV_X64_NESTED_GUEST_MAPPING_FLUSH		BIT(18)
 #define HV_X64_NESTED_MSR_BITMAP			BIT(19)
 
+/* Hyper-V synthetic debugger platform capabilities */
+#define HV_X64_SYNDBG_CAP_ALLOW_KERNEL_DEBUGGING	BIT(1)
+
 /* Hyper-V specific model specific registers (MSRs) */
 
 /* MSR used to identify the guest OS. */
@@ -267,6 +275,14 @@
 /* Hyper-V guest idle MSR */
 #define HV_X64_MSR_GUEST_IDLE			0x400000F0
 
+/* Hyper-V Synthetic debug options MSR */
+#define HV_X64_MSR_SYNDBG_CONTROL		0x400000F1
+#define HV_X64_MSR_SYNDBG_STATUS		0x400000F2
+#define HV_X64_MSR_SYNDBG_SEND_BUFFER		0x400000F3
+#define HV_X64_MSR_SYNDBG_RECV_BUFFER		0x400000F4
+#define HV_X64_MSR_SYNDBG_PENDING_BUFFER	0x400000F5
+#define HV_X64_MSR_SYNDBG_OPTIONS		0x400000FF
+
 /* Hyper-V guest crash notification MSR's */
 #define HV_X64_MSR_CRASH_P0			0x40000100
 #define HV_X64_MSR_CRASH_P1			0x40000101
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 98959e8cd448..2b755174d683 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -854,6 +854,15 @@ struct kvm_apic_map {
 	struct kvm_lapic *phys_map[];
 };
 
+/* Hyper-V synthetic debugger (SynDbg)*/
+struct kvm_hv_syndbg {
+	u64 control;
+	u64 status;
+	u64 send_page;
+	u64 recv_page;
+	u64 pending_page;
+};
+
 /* Hyper-V emulation context */
 struct kvm_hv {
 	struct mutex hv_lock;
@@ -877,6 +886,8 @@ struct kvm_hv {
 	atomic_t num_mismatched_vp_indexes;
 
 	struct hv_partition_assist_pg *hv_pa_pg;
+	u64 hv_syndbg_options;
+	struct kvm_hv_syndbg hv_syndbg;
 };
 
 enum kvm_irqchip_mode {
diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index a86fda7a1d03..13176ec23496 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -266,6 +266,66 @@ static int synic_set_msr(struct kvm_vcpu_hv_synic *synic,
 	return ret;
 }
 
+static int kvm_hv_syndbg_complete_userspace(struct kvm_vcpu *vcpu)
+{
+	struct kvm *kvm = vcpu->kvm;
+	struct kvm_hv *hv = &kvm->arch.hyperv;
+
+	if (vcpu->run->hyperv.u.syndbg.msr == HV_X64_MSR_SYNDBG_CONTROL)
+		hv->hv_syndbg.status = vcpu->run->hyperv.u.syndbg.status;
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
+	hv_vcpu->exit.u.syndbg.control = syndbg->control;
+	hv_vcpu->exit.u.syndbg.send_page = syndbg->send_page;
+	hv_vcpu->exit.u.syndbg.recv_page = syndbg->recv_page;
+	hv_vcpu->exit.u.syndbg.pending_page = syndbg->pending_page;
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
+	trace_kvm_hv_syndbg_set_msr(vcpu->vcpu_id, msr, data);
+	ret = 0;
+	switch (msr) {
+	case HV_X64_MSR_SYNDBG_CONTROL:
+		syndbg->control = data;
+		syndbg_exit(vcpu, msr);
+		break;
+	case HV_X64_MSR_SYNDBG_STATUS:
+		syndbg->status = data;
+		break;
+	case HV_X64_MSR_SYNDBG_SEND_BUFFER:
+		syndbg->send_page = data;
+		break;
+	case HV_X64_MSR_SYNDBG_RECV_BUFFER:
+		syndbg->recv_page = data;
+		break;
+	case HV_X64_MSR_SYNDBG_PENDING_BUFFER:
+		syndbg->pending_page = data;
+		syndbg_exit(vcpu, msr);
+		break;
+	default:
+		ret = 1;
+		break;
+	}
+
+	return ret;
+}
+
 static int synic_get_msr(struct kvm_vcpu_hv_synic *synic, u32 msr, u64 *pdata,
 			 bool host)
 {
@@ -800,6 +860,8 @@ static bool kvm_hv_msr_partition_wide(u32 msr)
 	case HV_X64_MSR_REENLIGHTENMENT_CONTROL:
 	case HV_X64_MSR_TSC_EMULATION_CONTROL:
 	case HV_X64_MSR_TSC_EMULATION_STATUS:
+	case HV_X64_MSR_SYNDBG_OPTIONS:
+	case HV_X64_MSR_SYNDBG_CONTROL ... HV_X64_MSR_SYNDBG_PENDING_BUFFER:
 		r = true;
 		break;
 	}
@@ -1061,6 +1123,11 @@ static int kvm_hv_set_msr_pw(struct kvm_vcpu *vcpu, u32 msr, u64 data,
 		if (!host)
 			return 1;
 		break;
+	case HV_X64_MSR_SYNDBG_OPTIONS:
+		hv->hv_syndbg_options = data;
+		break;
+	case HV_X64_MSR_SYNDBG_CONTROL ... HV_X64_MSR_SYNDBG_PENDING_BUFFER:
+		return syndbg_set_msr(vcpu, msr, data);
 	default:
 		vcpu_unimpl(vcpu, "Hyper-V unhandled wrmsr: 0x%x data 0x%llx\n",
 			    msr, data);
@@ -1227,6 +1294,24 @@ static int kvm_hv_get_msr_pw(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata)
 	case HV_X64_MSR_TSC_EMULATION_STATUS:
 		data = hv->hv_tsc_emulation_status;
 		break;
+	case HV_X64_MSR_SYNDBG_OPTIONS:
+		data = hv->hv_syndbg_options;
+		break;
+	case HV_X64_MSR_SYNDBG_CONTROL:
+		data = hv->hv_syndbg.control;
+		break;
+	case HV_X64_MSR_SYNDBG_STATUS:
+		data = hv->hv_syndbg.status;
+		break;
+	case HV_X64_MSR_SYNDBG_SEND_BUFFER:
+		data = hv->hv_syndbg.send_page;
+		break;
+	case HV_X64_MSR_SYNDBG_RECV_BUFFER:
+		data = hv->hv_syndbg.recv_page;
+		break;
+	case HV_X64_MSR_SYNDBG_PENDING_BUFFER:
+		data = hv->hv_syndbg.pending_page;
+		break;
 	default:
 		vcpu_unimpl(vcpu, "Hyper-V unhandled rdmsr: 0x%x\n", msr);
 		return 1;
@@ -1797,6 +1882,9 @@ int kvm_vcpu_ioctl_get_hv_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid,
 		{ .function = HYPERV_CPUID_ENLIGHTMENT_INFO },
 		{ .function = HYPERV_CPUID_IMPLEMENT_LIMITS },
 		{ .function = HYPERV_CPUID_NESTED_FEATURES },
+		{ .function = HYPERV_CPUID_SYNDBG_VENDOR_AND_MAX_FUNCTIONS },
+		{ .function = HYPERV_CPUID_SYNDBG_INTERFACE },
+		{ .function = HYPERV_CPUID_SYNDBG_PLATFORM_CAPABILITIES	},
 	};
 	int i, nent = ARRAY_SIZE(cpuid_entries);
 
@@ -1856,9 +1944,12 @@ int kvm_vcpu_ioctl_get_hv_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid,
 
 			ent->ebx |= HV_X64_POST_MESSAGES;
 			ent->ebx |= HV_X64_SIGNAL_EVENTS;
+			ent->ebx |= HV_X64_DEBUGGING;
 
 			ent->edx |= HV_FEATURE_FREQUENCY_MSRS_AVAILABLE;
 			ent->edx |= HV_FEATURE_GUEST_CRASH_MSR_AVAILABLE;
+			ent->edx |= HV_X64_GUEST_DEBUGGING_AVAILABLE;
+			ent->edx |= HV_FEATURE_DEBUG_MSRS_AVAILABLE;
 
 			/*
 			 * Direct Synthetic timers only make sense with in-kernel
@@ -1903,6 +1994,24 @@ int kvm_vcpu_ioctl_get_hv_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid,
 
 			break;
 
+		case HYPERV_CPUID_SYNDBG_VENDOR_AND_MAX_FUNCTIONS:
+			memcpy(signature, "Microsoft VS", 12);
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
index 757cb578101c..6a86151fac53 100644
--- a/arch/x86/kvm/hyperv.h
+++ b/arch/x86/kvm/hyperv.h
@@ -46,6 +46,11 @@ static inline struct kvm_vcpu *synic_to_vcpu(struct kvm_vcpu_hv_synic *synic)
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
index f194dd058470..235b9ab673a2 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -1515,6 +1515,28 @@ TRACE_EVENT(kvm_nested_vmenter_failed,
 		__print_symbolic(__entry->err, VMX_VMENTER_INSTRUCTION_ERRORS))
 );
 
+/*
+ * Tracepoint for syndbg_set_msr.
+ */
+TRACE_EVENT(kvm_hv_syndbg_set_msr,
+	TP_PROTO(int vcpu_id, u32 msr, u64 data),
+	TP_ARGS(vcpu_id, msr, data),
+
+	TP_STRUCT__entry(
+		__field(int, vcpu_id)
+		__field(u32, msr)
+		__field(u64, data)
+	),
+
+	TP_fast_assign(
+		__entry->vcpu_id = vcpu_id;
+		__entry->msr = msr;
+		__entry->data = data;
+	),
+
+	TP_printk("vcpu_id %d msr 0x%x data 0x%llx",
+		  __entry->vcpu_id, __entry->msr, __entry->data)
+);
 #endif /* _TRACE_KVM_H */
 
 #undef TRACE_INCLUDE_PATH
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 5de200663f51..9d4d72a88572 100644
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
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 4b95f9a31a2f..fae8cf608976 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -188,6 +188,7 @@ struct kvm_s390_cmma_log {
 struct kvm_hyperv_exit {
 #define KVM_EXIT_HYPERV_SYNIC          1
 #define KVM_EXIT_HYPERV_HCALL          2
+#define KVM_EXIT_HYPERV_SYNDBG         3
 	__u32 type;
 	union {
 		struct {
@@ -201,6 +202,14 @@ struct kvm_hyperv_exit {
 			__u64 result;
 			__u64 params[2];
 		} hcall;
+		struct {
+			__u32 msr;
+			__u64 control;
+			__u64 status;
+			__u64 send_page;
+			__u64 recv_page;
+			__u64 pending_page;
+		} syndbg;
 	} u;
 };
 
-- 
2.24.1

