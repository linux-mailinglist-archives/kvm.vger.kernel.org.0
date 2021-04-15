Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE958360AE2
	for <lists+kvm@lfdr.de>; Thu, 15 Apr 2021 15:44:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233406AbhDONof (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Apr 2021 09:44:35 -0400
Received: from linux.microsoft.com ([13.77.154.182]:41626 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233410AbhDONoW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Apr 2021 09:44:22 -0400
Received: from viremana-dev.fwjladdvyuiujdukmejncen4mf.xx.internal.cloudapp.net (unknown [13.66.132.26])
        by linux.microsoft.com (Postfix) with ESMTPSA id 2D58020B83E8;
        Thu, 15 Apr 2021 06:43:58 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 2D58020B83E8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1618494238;
        bh=NSl4mmuN0fWV7X9bel04RUo28vwYage3zxPQZMAmy78=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LKf9rmUTqE3FYM0jHIfhZfR9KL8EZj+xeWInM3WdjT28AKqwxw/KEubg585eNNmWI
         H4/OMcqu4MAelUdnxQq+T8FoIbU4SLCNRxmwQ5122MzT0eakfVdOYgF+abrOjYumLa
         2WgGwi5nXq4oa7W6UVrWxe4fpaOa+4G85XI2Kh/c=
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
Subject: [PATCH v2 6/7] KVM: SVM: hyper-v: Enlightened MSR-Bitmap support
Date:   Thu, 15 Apr 2021 13:43:41 +0000
Message-Id: <c9e0964a49a883a4889814232acd33781bd0c4fb.1618492553.git.viremana@linux.microsoft.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1618492553.git.viremana@linux.microsoft.com>
References: <cover.1618492553.git.viremana@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Enlightened MSR-Bitmap as per TLFS:

 "The L1 hypervisor may collaborate with the L0 hypervisor to make MSR
  accesses more efficient. It can enable enlightened MSR bitmaps by setting
  the corresponding field in the enlightened VMCS to 1. When enabled, L0
  hypervisor does not monitor the MSR bitmaps for changes. Instead, the L1
  hypervisor must invalidate the corresponding clean field after making
  changes to one of the MSR bitmaps."

Enable this for SVM.

Related VMX changes:
commit ceef7d10dfb6 ("KVM: x86: VMX: hyper-v: Enlightened MSR-Bitmap support")

Signed-off-by: Vineeth Pillai <viremana@linux.microsoft.com>
---
 arch/x86/kvm/svm/svm.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index de141d5ae5fb..f59f03b5c722 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -649,6 +649,27 @@ static bool msr_write_intercepted(struct kvm_vcpu *vcpu, u32 msr)
 	return !!test_bit(bit_write,  &tmp);
 }
 
+#if IS_ENABLED(CONFIG_HYPERV)
+static inline void hv_vmcb_dirty_nested_enlightenments(struct kvm_vcpu *vcpu)
+{
+	struct vmcb *vmcb = to_svm(vcpu)->vmcb;
+
+	/*
+	 * vmcb can be NULL if called during early vcpu init.
+	 * And its okay not to mark vmcb dirty during vcpu init
+	 * as we mark it dirty unconditionally towards end of vcpu
+	 * init phase.
+	 */
+	if (vmcb && vmcb_is_clean(vmcb, VMCB_HV_NESTED_ENLIGHTENMENTS) &&
+	    vmcb->hv_enlightenments.hv_enlightenments_control.msr_bitmap)
+		vmcb_mark_dirty(vmcb, VMCB_HV_NESTED_ENLIGHTENMENTS);
+}
+#else
+static inline void hv_vmcb_dirty_nested_enlightenments(struct kvm_vcpu *vcpu)
+{
+}
+#endif
+
 static void set_msr_interception_bitmap(struct kvm_vcpu *vcpu, u32 *msrpm,
 					u32 msr, int read, int write)
 {
@@ -680,6 +701,9 @@ static void set_msr_interception_bitmap(struct kvm_vcpu *vcpu, u32 *msrpm,
 	write ? clear_bit(bit_write, &tmp) : set_bit(bit_write, &tmp);
 
 	msrpm[offset] = tmp;
+
+	hv_vmcb_dirty_nested_enlightenments(vcpu);
+
 }
 
 void set_msr_interception(struct kvm_vcpu *vcpu, u32 *msrpm, u32 msr,
@@ -1143,6 +1167,9 @@ static void hv_init_vmcb(struct vmcb *vmcb)
 	if (npt_enabled &&
 	    ms_hyperv.nested_features & HV_X64_NESTED_ENLIGHTENED_TLB)
 		hve->hv_enlightenments_control.enlightened_npt_tlb = 1;
+
+	if (ms_hyperv.nested_features & HV_X64_NESTED_MSR_BITMAP)
+		hve->hv_enlightenments_control.msr_bitmap = 1;
 }
 #else
 static inline void hv_init_vmcb(struct vmcb *vmcb)
-- 
2.25.1

