Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3A168CCF9
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2019 09:35:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727732AbfHNHfP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Aug 2019 03:35:15 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:46259 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727425AbfHNHfO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Aug 2019 03:35:14 -0400
Received: by mail-pf1-f194.google.com with SMTP id q139so4787060pfc.13;
        Wed, 14 Aug 2019 00:35:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=RvOc0S7L+lCehYN7NwY8YVP/8Xm95XsVdVbZaeL90AA=;
        b=FuIOWtcHEQM1Ce4fe65VIXjPpzEavnemStWVRXcRZw9p0bCZCvItlDnPuTnai2Bfqb
         lEZ+sFyfqI1W0qSL5k8QvUMEFU8LFBrtqy4ygLs445cDbpnbeElBHqpwy7p1ow+Z7jdV
         wbzC8iMUy4aEZOqXSc2t9sIxsuV8lbcbAwMqa5BIc4btvgRvOoZw0LWzOlj+4FhVzhkL
         +quIxZSFl2rJAygCgREUM3hlCV5GFr7UPVAE8DUoJlFONPWuU9AqUwg9weoLTHnaei9G
         3oRydj3g5K7XQ/tdV56ubk6RTAD5qvy4FCTpLrDuVMUrzFXPj0R8ZMcMxLnQDSdiMen5
         AIlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=RvOc0S7L+lCehYN7NwY8YVP/8Xm95XsVdVbZaeL90AA=;
        b=im3wNtYwjdHj/Yqn5IcLiwpbEx1ednzY1IGiyXVU/zMxe+2Plqx90d0D7F7uMzjMcZ
         UtInkF5WrV6Hh6Mm+5r4A0Lh4Feq7xnSgjhLeHViva3PZAs83OKrghR5go66RE8AKxju
         qhDeT23+gygKYDU7OXa5X2VLC4GYR1dwvXZUpSI7GuqCeoaTN+Cgh+UrfyJDSqMBLET7
         hz6PWbPy29zS5DdT2lv9qhBmlPEyKa/eWf+EG/gVe6aG8dK5Pfqopmppr82cYK1Jo1Wh
         4awpGp+jt4yov/IBVZAp13UVd7wF0pB+DRGb4h5X/0m9TpXUT5VstJVKBAdFiiioRbDK
         UpQw==
X-Gm-Message-State: APjAAAXE5vBh8Y8WxonYose7VzqNTwA3VvWa0Rxw0lFKb1Yv7wFCM/6a
        parzT2Q73eccRF8/gIlH99E=
X-Google-Smtp-Source: APXvYqwQ7bR1LWrbow273ffogtcqLSWiV9lZVAvH/FM1SUJBAoGZC/AtiPVi2hc5Maa9ZmUVzf+Rmw==
X-Received: by 2002:a17:90a:c386:: with SMTP id h6mr5796971pjt.122.1565768113122;
        Wed, 14 Aug 2019 00:35:13 -0700 (PDT)
Received: from localhost.corp.microsoft.com ([167.220.255.114])
        by smtp.googlemail.com with ESMTPSA id v184sm109639230pfb.82.2019.08.14.00.35.08
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 14 Aug 2019 00:35:12 -0700 (PDT)
From:   lantianyu1986@gmail.com
X-Google-Original-From: Tianyu.Lan@microsoft.com
To:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        sashal@kernel.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, hpa@zytor.com, x86@kernel.org, pbonzini@redhat.com,
        rkrcmar@redhat.com, michael.h.kelley@microsoft.com
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Tianyu Lan <Tianyu.Lan@microsoft.com>
Subject: [PATCH V2 3/3] KVM/Hyper-V/VMX: Add direct tlb flush support
Date:   Wed, 14 Aug 2019 15:34:47 +0800
Message-Id: <20190814073447.96141-4-Tianyu.Lan@microsoft.com>
X-Mailer: git-send-email 2.14.5
In-Reply-To: <20190814073447.96141-1-Tianyu.Lan@microsoft.com>
References: <20190814073447.96141-1-Tianyu.Lan@microsoft.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Vitaly Kuznetsov <vkuznets@redhat.com>

This patch is to enable Hyper-V direct tlb flush function
for vmx.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
---
 arch/x86/include/asm/hyperv-tlfs.h |  4 ++++
 arch/x86/kvm/vmx/evmcs.h           |  2 ++
 arch/x86/kvm/vmx/vmx.c             | 38 ++++++++++++++++++++++++++++++++++++++
 include/linux/kvm_host.h           |  1 +
 4 files changed, 45 insertions(+)

diff --git a/arch/x86/include/asm/hyperv-tlfs.h b/arch/x86/include/asm/hyperv-tlfs.h
index cf0b2a04271d..d53d6e4a6210 100644
--- a/arch/x86/include/asm/hyperv-tlfs.h
+++ b/arch/x86/include/asm/hyperv-tlfs.h
@@ -171,6 +171,7 @@
 #define HV_X64_ENLIGHTENED_VMCS_RECOMMENDED		BIT(14)
 
 /* Nested features. These are HYPERV_CPUID_NESTED_FEATURES.EAX bits. */
+#define HV_X64_NESTED_DIRECT_FLUSH			BIT(17)
 #define HV_X64_NESTED_GUEST_MAPPING_FLUSH		BIT(18)
 #define HV_X64_NESTED_MSR_BITMAP			BIT(19)
 
@@ -882,4 +883,7 @@ struct hv_tlb_flush_ex {
 	u64 gva_list[];
 } __packed;
 
+struct hv_partition_assist_pg {
+	u32 tlb_lock_count;
+};
 #endif
diff --git a/arch/x86/kvm/vmx/evmcs.h b/arch/x86/kvm/vmx/evmcs.h
index 39a24eec8884..07ebf6882a45 100644
--- a/arch/x86/kvm/vmx/evmcs.h
+++ b/arch/x86/kvm/vmx/evmcs.h
@@ -178,6 +178,8 @@ static inline void evmcs_load(u64 phys_addr)
 	struct hv_vp_assist_page *vp_ap =
 		hv_get_vp_assist_page(smp_processor_id());
 
+	if (current_evmcs->hv_enlightenments_control.nested_flush_hypercall)
+		vp_ap->nested_control.features.directhypercall = 1;
 	vp_ap->current_nested_vmcs = phys_addr;
 	vp_ap->enlighten_vmentry = 1;
 }
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 84f8d49a2fd2..a49be029864e 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -486,6 +486,34 @@ static int hv_remote_flush_tlb(struct kvm *kvm)
 	return hv_remote_flush_tlb_with_range(kvm, NULL);
 }
 
+static int hv_enable_direct_tlbflush(struct kvm_vcpu *vcpu)
+{
+	struct hv_enlightened_vmcs *evmcs;
+
+	/*
+	 * Synthetic VM-Exit is not enabled in current code and so All
+	 * evmcs in singe VM shares same assist page.
+	 */
+	if (!vcpu->kvm->hv_pa_pg) {
+		vcpu->kvm->hv_pa_pg = kzalloc(PAGE_SIZE, GFP_KERNEL);
+		if (!vcpu->kvm->hv_pa_pg)
+			return -ENOMEM;
+		pr_debug("KVM: Hyper-V: allocated PA_PG for %llx\n",
+		       (u64)&vcpu->kvm);
+	}
+
+	evmcs = (struct hv_enlightened_vmcs *)to_vmx(vcpu)->loaded_vmcs->vmcs;
+
+	evmcs->partition_assist_page =
+		__pa(vcpu->kvm->hv_pa_pg);
+	evmcs->hv_vm_id = (u64)vcpu->kvm;
+	evmcs->hv_enlightenments_control.nested_flush_hypercall = 1;
+
+	pr_debug("KVM: Hyper-V: enabled DIRECT flush for %llx\n",
+		 (u64)vcpu->kvm);
+	return 0;
+}
+
 #endif /* IS_ENABLED(CONFIG_HYPERV) */
 
 /*
@@ -6516,6 +6544,9 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
 		current_evmcs->hv_clean_fields |=
 			HV_VMX_ENLIGHTENED_CLEAN_FIELD_ALL;
 
+	if (static_branch_unlikely(&enable_evmcs))
+		current_evmcs->hv_vp_id = vcpu->arch.hyperv.vp_index;
+
 	/* MSR_IA32_DEBUGCTLMSR is zeroed on vmexit. Restore it if needed */
 	if (vmx->host_debugctlmsr)
 		update_debugctlmsr(vmx->host_debugctlmsr);
@@ -6583,6 +6614,7 @@ static struct kvm *vmx_vm_alloc(void)
 
 static void vmx_vm_free(struct kvm *kvm)
 {
+	kfree(kvm->hv_pa_pg);
 	vfree(to_kvm_vmx(kvm));
 }
 
@@ -7815,6 +7847,7 @@ static void vmx_exit(void)
 			if (!vp_ap)
 				continue;
 
+			vp_ap->nested_control.features.directhypercall = 0;
 			vp_ap->current_nested_vmcs = 0;
 			vp_ap->enlighten_vmentry = 0;
 		}
@@ -7854,6 +7887,11 @@ static int __init vmx_init(void)
 			pr_info("KVM: vmx: using Hyper-V Enlightened VMCS\n");
 			static_branch_enable(&enable_evmcs);
 		}
+
+		if (ms_hyperv.nested_features & HV_X64_NESTED_DIRECT_FLUSH)
+			vmx_x86_ops.enable_direct_tlbflush
+				= hv_enable_direct_tlbflush;
+
 	} else {
 		enlightened_vmcs = false;
 	}
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index c5da875f19e3..479ad76661e6 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -500,6 +500,7 @@ struct kvm {
 	struct srcu_struct srcu;
 	struct srcu_struct irq_srcu;
 	pid_t userspace_pid;
+	struct hv_partition_assist_pg *hv_pa_pg;
 };
 
 #define kvm_err(fmt, ...) \
-- 
2.14.5

