Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 804FE356F05
	for <lists+kvm@lfdr.de>; Wed,  7 Apr 2021 16:42:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353116AbhDGOmE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Apr 2021 10:42:04 -0400
Received: from linux.microsoft.com ([13.77.154.182]:52758 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235879AbhDGOlv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Apr 2021 10:41:51 -0400
Received: from viremana-dev.fwjladdvyuiujdukmejncen4mf.xx.internal.cloudapp.net (unknown [13.66.132.26])
        by linux.microsoft.com (Postfix) with ESMTPSA id 1B40120B5688;
        Wed,  7 Apr 2021 07:41:40 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 1B40120B5688
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1617806500;
        bh=FbbsiSn1b1BNYpNIUbmPn9/HfbTYoqX0ImNm4EZLeCU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rs0v3XPXKJWMZmDeDX+F64LGzN8yXqebQyhbcxuarNXJ30GXrAe8tl7VkZojYrvQY
         FPo1SOa98fQjNGmdySrFzMnK0p/sipWdcTl4d2oiRgULB7zCCGrSPrDoDhELr5t7KW
         ecJ6Zk/Uuy4gomSxo98FBa/bgLW1XSDLwvKij2WE=
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
Subject: [PATCH 7/7] KVM: SVM: hyper-v: Direct Virtual Flush support
Date:   Wed,  7 Apr 2021 14:41:28 +0000
Message-Id: <aa634c867aa395aa2d3eae950dfec137f59a62c6.1617804573.git.viremana@linux.microsoft.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1617804573.git.viremana@linux.microsoft.com>
References: <cover.1617804573.git.viremana@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From Hyper-V TLFS:
 "The hypervisor exposes hypercalls (HvFlushVirtualAddressSpace,
  HvFlushVirtualAddressSpaceEx, HvFlushVirtualAddressList, and
  HvFlushVirtualAddressListEx) that allow operating systems to more
  efficiently manage the virtual TLB. The L1 hypervisor can choose to
  allow its guest to use those hypercalls and delegate the responsibility
  to handle them to the L0 hypervisor. This requires the use of a
  partition assist page."

Add the Direct Virtual Flush support for SVM.

Related VMX changes:
commit 6f6a657c9998 ("KVM/Hyper-V/VMX: Add direct tlb flush support")

Signed-off-by: Vineeth Pillai <viremana@linux.microsoft.com>
---
 arch/x86/kvm/svm/svm.c | 48 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 3562a247b7e8..c6d3f3a7c986 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -440,6 +440,32 @@ static void svm_init_osvw(struct kvm_vcpu *vcpu)
 		vcpu->arch.osvw.status |= 1;
 }
 
+#if IS_ENABLED(CONFIG_HYPERV)
+static int hv_enable_direct_tlbflush(struct kvm_vcpu *vcpu)
+{
+	struct hv_enlightenments *hve;
+	struct hv_partition_assist_pg **p_hv_pa_pg =
+			&to_kvm_hv(vcpu->kvm)->hv_pa_pg;
+
+	if (!*p_hv_pa_pg)
+		*p_hv_pa_pg = kzalloc(PAGE_SIZE, GFP_KERNEL);
+
+	if (!*p_hv_pa_pg)
+		return -ENOMEM;
+
+	hve = (struct hv_enlightenments *)&to_svm(vcpu)->vmcb->hv_enlightenments;
+
+	hve->partition_assist_page = __pa(*p_hv_pa_pg);
+	hve->hv_vm_id = (unsigned long)vcpu->kvm;
+	if (!hve->hv_enlightenments_control.nested_flush_hypercall) {
+		hve->hv_enlightenments_control.nested_flush_hypercall = 1;
+		vmcb_mark_dirty(to_svm(vcpu)->vmcb, VMCB_HV_NESTED_ENLIGHTENMENTS);
+	}
+
+	return 0;
+}
+#endif
+
 static int has_svm(void)
 {
 	const char *msg;
@@ -1034,6 +1060,21 @@ static __init int svm_hardware_setup(void)
 		svm_x86_ops.tlb_remote_flush_with_range =
 				kvm_hv_remote_flush_tlb_with_range;
 	}
+
+	if (ms_hyperv.nested_features & HV_X64_NESTED_DIRECT_FLUSH) {
+		pr_info("kvm: Hyper-V Direct TLB Flush enabled\n");
+		for_each_online_cpu(cpu) {
+			struct hv_vp_assist_page *vp_ap =
+				hv_get_vp_assist_page(cpu);
+
+			if (!vp_ap)
+				continue;
+
+			vp_ap->nested_control.features.directhypercall = 1;
+		}
+		svm_x86_ops.enable_direct_tlbflush =
+				hv_enable_direct_tlbflush;
+	}
 #endif
 
 	if (nrips) {
@@ -3913,6 +3954,13 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
 	}
 	svm->vmcb->save.cr2 = vcpu->arch.cr2;
 
+#if IS_ENABLED(CONFIG_HYPERV)
+	if (svm->vmcb->hv_enlightenments.hv_vp_id != to_hv_vcpu(vcpu)->vp_index) {
+		svm->vmcb->hv_enlightenments.hv_vp_id = to_hv_vcpu(vcpu)->vp_index;
+		vmcb_mark_dirty(svm->vmcb, VMCB_HV_NESTED_ENLIGHTENMENTS);
+	}
+#endif
+
 	/*
 	 * Run with all-zero DR6 unless needed, so that we can get the exact cause
 	 * of a #DB.
-- 
2.25.1

