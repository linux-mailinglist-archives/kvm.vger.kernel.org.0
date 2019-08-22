Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A862996B2
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2019 16:31:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389027AbfHVOav (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Aug 2019 10:30:51 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:38243 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732001AbfHVOau (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Aug 2019 10:30:50 -0400
Received: by mail-pf1-f195.google.com with SMTP id o70so4096014pfg.5;
        Thu, 22 Aug 2019 07:30:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=RNQC63n6Fm1YHdNyfk/Lkjcq7Nl47jl6vkcYe0yjErw=;
        b=FGV/rUADkx1Ag2pr0ZUnYBp4s5HZiWYJbL4+qHCxALt/HRjVy2un3gdFifvB6gqh/P
         zKdLLnWlFRz6waWazEmp5OGCGKyhxJ4mvHQDCoI3Cm5Uz/wxaWiPiOXrcftIKm2irK7w
         ZzI0npbJU8d/wOnsZAStvPR2hQT9T0OSEjwSCjX5wHRXUDTE6VShqYEAztQsdVwNwE74
         hbyyN1huEuuF2YjcRwP50AEkecFaFf/jgKte7Fr7am4rt+Vp+y2GaGDTHUhFTvUDh4rt
         jtHzaElm0QBh+A7aOdtvxM+mFObTwyh/0mbCgAYTtWiZG1Uc9twcLjA2cjM2IBVr6pE5
         vvlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=RNQC63n6Fm1YHdNyfk/Lkjcq7Nl47jl6vkcYe0yjErw=;
        b=D4xg+Cy8plzd1Ya1uCP8M/11/FkvskfCzczEs39adHTsJ9CxP9SKDS129H8D3tsb4R
         UX3mDl+MmXFqykG5cmCucxdp7QrTxhNIHAVw1j3Fegs8LdSpV4XA2VxKa9o7xfQ6YER1
         r3nBbN1X8Z8bxvWHssfnlJLQ2tdwrZ2AF/LUk5hkYVDAkjDpE+2bCjalkqTT7kq2hhYg
         DzjnGdormPG7K/P3gz9ce6x9b09nP9yyg/BFdhYvjH4iSmPdU9mDqaLlHYIyymG38KbF
         ifgSaXBOX75NkvZ1SqngZ0Vlw3/nwjlK5CgfkiF8OODRztz+jXQusxKHBlZpTX0IV/hn
         Psvw==
X-Gm-Message-State: APjAAAU6vYC84H1962XK6mEaYCDHswjlPJtJgLMCKorwSrpltjw7QBYI
        OByyCLZf27m4fIjFfdBfi4c=
X-Google-Smtp-Source: APXvYqwDJfZNu6EwzOKImb8bvki8/OzBGcRQs5XbOsBD2vgDzlOQILxY05wKvTHb58QPq3+NNIs/Ww==
X-Received: by 2002:a65:49cc:: with SMTP id t12mr31774650pgs.83.1566484250068;
        Thu, 22 Aug 2019 07:30:50 -0700 (PDT)
Received: from localhost.corp.microsoft.com ([167.220.255.114])
        by smtp.googlemail.com with ESMTPSA id r23sm32263161pfg.10.2019.08.22.07.30.45
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 22 Aug 2019 07:30:49 -0700 (PDT)
From:   lantianyu1986@gmail.com
X-Google-Original-From: Tianyu.Lan@microsoft.com
To:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        sashal@kernel.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, hpa@zytor.com, x86@kernel.org, pbonzini@redhat.com,
        rkrcmar@redhat.com, michael.h.kelley@microsoft.com
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Tianyu Lan <Tianyu.Lan@microsoft.com>
Subject: [PATCH V4 3/3] KVM/Hyper-V/VMX: Add direct tlb flush support
Date:   Thu, 22 Aug 2019 22:30:21 +0800
Message-Id: <20190822143021.7518-4-Tianyu.Lan@microsoft.com>
X-Mailer: git-send-email 2.14.5
In-Reply-To: <20190822143021.7518-1-Tianyu.Lan@microsoft.com>
References: <20190822143021.7518-1-Tianyu.Lan@microsoft.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Vitaly Kuznetsov <vkuznets@redhat.com>

Hyper-V provides direct tlb flush function which helps
L1 Hypervisor to handle Hyper-V tlb flush request from
L2 guest. Add the function support for VMX.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
---
Change since v3:
       - Update changlog
Change since v2:
       - Move hv assist page(hv_pa_pg) from struct kvm  to struct kvm_hv.
---
 arch/x86/include/asm/hyperv-tlfs.h |  4 ++++
 arch/x86/include/asm/kvm_host.h    |  2 ++
 arch/x86/kvm/vmx/evmcs.h           |  2 ++
 arch/x86/kvm/vmx/vmx.c             | 39 ++++++++++++++++++++++++++++++++++++++
 4 files changed, 47 insertions(+)

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
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 667d154e89d4..ad4b5c02db0e 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -840,6 +840,8 @@ struct kvm_hv {
 
 	/* How many vCPUs have VP index != vCPU index */
 	atomic_t num_mismatched_vp_indexes;
+
+	struct hv_partition_assist_pg *hv_pa_pg;
 };
 
 enum kvm_irqchip_mode {
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
index 84f8d49a2fd2..ed8056049070 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -486,6 +486,35 @@ static int hv_remote_flush_tlb(struct kvm *kvm)
 	return hv_remote_flush_tlb_with_range(kvm, NULL);
 }
 
+static int hv_enable_direct_tlbflush(struct kvm_vcpu *vcpu)
+{
+	struct hv_enlightened_vmcs *evmcs;
+	struct hv_partition_assist_pg **p_hv_pa_pg =
+			&vcpu->kvm->arch.hyperv.hv_pa_pg;
+	/*
+	 * Synthetic VM-Exit is not enabled in current code and so All
+	 * evmcs in singe VM shares same assist page.
+	 */
+	if (!*p_hv_pa_pg) {
+		*p_hv_pa_pg = kzalloc(PAGE_SIZE, GFP_KERNEL);
+		if (!*p_hv_pa_pg)
+			return -ENOMEM;
+		pr_debug("KVM: Hyper-V: allocated PA_PG for %llx\n",
+		       (u64)&vcpu->kvm);
+	}
+
+	evmcs = (struct hv_enlightened_vmcs *)to_vmx(vcpu)->loaded_vmcs->vmcs;
+
+	evmcs->partition_assist_page =
+		__pa(*p_hv_pa_pg);
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
@@ -6516,6 +6545,9 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
 		current_evmcs->hv_clean_fields |=
 			HV_VMX_ENLIGHTENED_CLEAN_FIELD_ALL;
 
+	if (static_branch_unlikely(&enable_evmcs))
+		current_evmcs->hv_vp_id = vcpu->arch.hyperv.vp_index;
+
 	/* MSR_IA32_DEBUGCTLMSR is zeroed on vmexit. Restore it if needed */
 	if (vmx->host_debugctlmsr)
 		update_debugctlmsr(vmx->host_debugctlmsr);
@@ -6583,6 +6615,7 @@ static struct kvm *vmx_vm_alloc(void)
 
 static void vmx_vm_free(struct kvm *kvm)
 {
+	kfree(kvm->arch.hyperv.hv_pa_pg);
 	vfree(to_kvm_vmx(kvm));
 }
 
@@ -7815,6 +7848,7 @@ static void vmx_exit(void)
 			if (!vp_ap)
 				continue;
 
+			vp_ap->nested_control.features.directhypercall = 0;
 			vp_ap->current_nested_vmcs = 0;
 			vp_ap->enlighten_vmentry = 0;
 		}
@@ -7854,6 +7888,11 @@ static int __init vmx_init(void)
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
-- 
2.14.5

