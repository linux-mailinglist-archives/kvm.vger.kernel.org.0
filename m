Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D0D0360AE0
	for <lists+kvm@lfdr.de>; Thu, 15 Apr 2021 15:44:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233497AbhDONoe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Apr 2021 09:44:34 -0400
Received: from linux.microsoft.com ([13.77.154.182]:41592 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233098AbhDONoV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Apr 2021 09:44:21 -0400
Received: from viremana-dev.fwjladdvyuiujdukmejncen4mf.xx.internal.cloudapp.net (unknown [13.66.132.26])
        by linux.microsoft.com (Postfix) with ESMTPSA id 1535720B83DA;
        Thu, 15 Apr 2021 06:43:58 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 1535720B83DA
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1618494238;
        bh=Qw/EY77O8e33M5gocLOEipcrWWMJKjdlnCTsMyAxTWU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K3OC8jKNznKtb08xkul5GrgE8OuXIcSo2cH8qF06C+zIvszVDzPB55JU72K/izX94
         fgUy20t31PZMpHdyCv56rzDgfsrvT6fXjw0M7U5D+VFFMe2HRY1t1LCmWBzSjHQB/f
         94dcBA6iYb33VeYE+U6wLnFHMsUJz6T4fiTmTjnY=
From:   Vineeth Pillai <viremana@linux.microsoft.com>
To:     Lan Tianyu <Tianyu.Lan@microsoft.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Wei Liu <wei.liu@kernel.org>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Cc:     Vineeth Pillai <viremana@linux.microsoft.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "K. Y. Srinivasan" <kys@microsoft.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hyperv@vger.kernel.org
Subject: [PATCH v2 5/7] KVM: SVM: hyper-v: Remote TLB flush for SVM
Date:   Thu, 15 Apr 2021 13:43:40 +0000
Message-Id: <959f6cc899a17c709a2f5a71f6b2dc8c072ae600.1618492553.git.viremana@linux.microsoft.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1618492553.git.viremana@linux.microsoft.com>
References: <cover.1618492553.git.viremana@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Enable remote TLB flush for SVM.

Signed-off-by: Vineeth Pillai <viremana@linux.microsoft.com>
---
 arch/x86/kvm/svm/svm.c | 37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 2ad1f55c88d0..de141d5ae5fb 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -37,6 +37,7 @@
 #include <asm/spec-ctrl.h>
 #include <asm/cpu_device_id.h>
 #include <asm/traps.h>
+#include <asm/mshyperv.h>
 
 #include <asm/virtext.h>
 #include "trace.h"
@@ -44,6 +45,8 @@
 #include "svm.h"
 #include "svm_ops.h"
 
+#include "hyperv.h"
+
 #define __ex(x) __kvm_handle_fault_on_reboot(x)
 
 MODULE_AUTHOR("Qumranet");
@@ -931,6 +934,8 @@ static __init void svm_set_cpu_caps(void)
 		kvm_cpu_cap_set(X86_FEATURE_VIRT_SSBD);
 }
 
+static struct kvm_x86_ops svm_x86_ops;
+
 static __init int svm_hardware_setup(void)
 {
 	int cpu;
@@ -1000,6 +1005,16 @@ static __init int svm_hardware_setup(void)
 	kvm_configure_mmu(npt_enabled, get_max_npt_level(), PG_LEVEL_1G);
 	pr_info("kvm: Nested Paging %sabled\n", npt_enabled ? "en" : "dis");
 
+#if IS_ENABLED(CONFIG_HYPERV)
+	if (ms_hyperv.nested_features & HV_X64_NESTED_ENLIGHTENED_TLB
+	    && npt_enabled) {
+		pr_info("kvm: Hyper-V enlightened NPT TLB flush enabled\n");
+		svm_x86_ops.tlb_remote_flush = kvm_hv_remote_flush_tlb;
+		svm_x86_ops.tlb_remote_flush_with_range =
+				kvm_hv_remote_flush_tlb_with_range;
+	}
+#endif
+
 	if (nrips) {
 		if (!boot_cpu_has(X86_FEATURE_NRIPS))
 			nrips = false;
@@ -1120,6 +1135,21 @@ static void svm_check_invpcid(struct vcpu_svm *svm)
 	}
 }
 
+#if IS_ENABLED(CONFIG_HYPERV)
+static void hv_init_vmcb(struct vmcb *vmcb)
+{
+	struct hv_enlightenments *hve = &vmcb->hv_enlightenments;
+
+	if (npt_enabled &&
+	    ms_hyperv.nested_features & HV_X64_NESTED_ENLIGHTENED_TLB)
+		hve->hv_enlightenments_control.enlightened_npt_tlb = 1;
+}
+#else
+static inline void hv_init_vmcb(struct vmcb *vmcb)
+{
+}
+#endif
+
 static void init_vmcb(struct vcpu_svm *svm)
 {
 	struct vmcb_control_area *control = &svm->vmcb->control;
@@ -1282,6 +1312,8 @@ static void init_vmcb(struct vcpu_svm *svm)
 		}
 	}
 
+	hv_init_vmcb(svm->vmcb);
+
 	vmcb_mark_all_dirty(svm->vmcb);
 
 	enable_gif(svm);
@@ -3975,6 +4007,11 @@ static void svm_load_mmu_pgd(struct kvm_vcpu *vcpu, unsigned long root,
 		svm->vmcb->control.nested_cr3 = cr3;
 		vmcb_mark_dirty(svm->vmcb, VMCB_NPT);
 
+#if IS_ENABLED(CONFIG_HYPERV)
+		if (kvm_x86_ops.tlb_remote_flush)
+			kvm_update_arch_tdp_pointer(vcpu->kvm, vcpu, cr3);
+#endif
+
 		/* Loading L2's CR3 is handled by enter_svm_guest_mode.  */
 		if (!test_bit(VCPU_EXREG_CR3, (ulong *)&vcpu->arch.regs_avail))
 			return;
-- 
2.25.1

