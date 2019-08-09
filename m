Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 397B38769B
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2019 11:50:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406187AbfHIJum (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Aug 2019 05:50:42 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:45828 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406043AbfHIJum (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Aug 2019 05:50:42 -0400
Received: by mail-pf1-f194.google.com with SMTP id w26so503205pfq.12;
        Fri, 09 Aug 2019 02:50:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=4G5k1KWaCtE9amIrlew5Zx3E4m7cQTXlbvrmQ86F7fc=;
        b=BZnKyMY6EYCpbJk/2QF0zuPCa1fKduEtqcwN85fThgS82krX11kyCEMwpeQ9zKiDnA
         UQMV43aWf5QgjEx6i8JKyJ1LTiihuig+lr0KjSPN+Nz1vZdl6+DHh1QQCn73+hKBol08
         DpnYkaeU63aSxVP4WzERwWY3vt8F+sw2YDR9Nj295a6Tlq64qJ9nhBVZM/bflm/4z4Vs
         ioQTdyD5Y3tN5bScqSkTm4HmCNpd/vJ1YBeKA/gJUgVUcIEfVrP1Qtw6LS+dsN5ohT9j
         StrLFMPbwQ9Qd7p1Yf06nUMwJXDOBM9cxP7eulwf04mTnF+RtNLJMSIU/LDtgcVES77N
         8AdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=4G5k1KWaCtE9amIrlew5Zx3E4m7cQTXlbvrmQ86F7fc=;
        b=IZdhdO6AphA/jIhzq573djfNpUAwpSjVxel7eEcdWzhQT2gx0/5E6IUxAnWGs9a+EQ
         QQU40ZzasjMgrqOF58j6xhlEbbdI9RT4xymRmJxmTwHtFBLtQ5majz8QkL5BDukDCrfo
         GgzmqTNmJUjsnENhU/yDRSCqMmbxyWbsaPe6bnR5cyFe/yypTz+9aRMneRbwls9QUAug
         +Xa8yEVyxl5WoyFzDBMyHqUWyozm54b/gpGGC8RoXD3XTHzBqGUH0RVM7oZaTPa7Mx6a
         4grtj3JLerkKu8sBhFlzXtSEziojVu2rqnzFscLLDziEyZtTHXyqJiF15zwyje5IPlWq
         2GNg==
X-Gm-Message-State: APjAAAVHBRAsxZDHNwDTHqLOFwzX2+/z+gwVZlNLwQyT8DDlsAsV8oEk
        vMADofWn79zpQBjSi84sHcs=
X-Google-Smtp-Source: APXvYqx1Lnfhc/sWcv9TxJl3TzAyklYnYNVJ2dOJjZFHKhzxLMTgvoFDjeWa8GPH8iAkbhRJj8SPOA==
X-Received: by 2002:a65:5b8e:: with SMTP id i14mr16656450pgr.188.1565344241264;
        Fri, 09 Aug 2019 02:50:41 -0700 (PDT)
Received: from localhost.corp.microsoft.com ([167.220.255.114])
        by smtp.googlemail.com with ESMTPSA id b16sm159653631pfo.54.2019.08.09.02.50.36
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 09 Aug 2019 02:50:40 -0700 (PDT)
From:   lantianyu1986@gmail.com
X-Google-Original-From: Tianyu.Lan@microsoft.com
To:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        sashal@kernel.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, hpa@zytor.com, x86@kernel.org, pbonzini@redhat.com,
        rkrcmar@redhat.com, michael.h.kelley@microsoft.com
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Tianyu Lan <Tianyu.Lan@microsoft.com>
Subject: [PATCH 3/3] KVM/Hyper-V/VMX: Add direct tlb flush support
Date:   Fri,  9 Aug 2019 17:49:39 +0800
Message-Id: <20190809094939.76093-4-Tianyu.Lan@microsoft.com>
X-Mailer: git-send-email 2.14.5
In-Reply-To: <20190809094939.76093-1-Tianyu.Lan@microsoft.com>
References: <20190809094939.76093-1-Tianyu.Lan@microsoft.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Vitaly Kuznetsov <vkuznets@redhat.com>

This patch is to enable Hyper-V direct tlb flush function
for VMX.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
---
 arch/x86/include/asm/hyperv-tlfs.h | 16 +++++++++++++++-
 arch/x86/kvm/vmx/evmcs.h           |  2 ++
 arch/x86/kvm/vmx/vmx.c             | 38 ++++++++++++++++++++++++++++++++++++++
 include/linux/kvm_host.h           |  1 +
 4 files changed, 56 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/hyperv-tlfs.h b/arch/x86/include/asm/hyperv-tlfs.h
index a79703c56ebe..d53d6e4a6210 100644
--- a/arch/x86/include/asm/hyperv-tlfs.h
+++ b/arch/x86/include/asm/hyperv-tlfs.h
@@ -171,6 +171,7 @@
 #define HV_X64_ENLIGHTENED_VMCS_RECOMMENDED		BIT(14)
 
 /* Nested features. These are HYPERV_CPUID_NESTED_FEATURES.EAX bits. */
+#define HV_X64_NESTED_DIRECT_FLUSH			BIT(17)
 #define HV_X64_NESTED_GUEST_MAPPING_FLUSH		BIT(18)
 #define HV_X64_NESTED_MSR_BITMAP			BIT(19)
 
@@ -514,12 +515,22 @@ struct hv_timer_message_payload {
 	__u64 delivery_time;	/* When the message was delivered */
 } __packed;
 
+struct hv_nested_enlightenments_control {
+	struct {
+		__u32 directhypercall:1;
+		__u32 reserved:31;
+	} features;
+	struct {
+		__u32 reserved;
+	} hypercallControls;
+} __packed;
+
 /* Define virtual processor assist page structure. */
 struct hv_vp_assist_page {
 	__u32 apic_assist;
 	__u32 reserved1;
 	__u64 vtl_control[3];
-	__u64 nested_enlightenments_control[2];
+	struct hv_nested_enlightenments_control nested_control;
 	__u8 enlighten_vmentry;
 	__u8 reserved2[7];
 	__u64 current_nested_vmcs;
@@ -872,4 +883,7 @@ struct hv_tlb_flush_ex {
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
2.14.2

