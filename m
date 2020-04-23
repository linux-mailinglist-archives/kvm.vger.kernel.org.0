Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90A571B5275
	for <lists+kvm@lfdr.de>; Thu, 23 Apr 2020 04:26:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726717AbgDWC0f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Apr 2020 22:26:35 -0400
Received: from mga05.intel.com ([192.55.52.43]:43426 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726569AbgDWCZ6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Apr 2020 22:25:58 -0400
IronPort-SDR: XzJtcZ5c2jLyXtvR8d3V5EXIugLSSvqY6G5NDAtatXg/CjBKeC9qt471wipd4nGragA1v0ExMD
 TB7zN+oi9SyA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2020 19:25:55 -0700
IronPort-SDR: 5obXN5J3zVIVFquFwCMy3RWEsX06NRvCPuM9JfSHd23MjFR/Dbtycx3vsPh9PJh3eIOcoEi3sR
 zC3hSFyGnWGQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,305,1583222400"; 
   d="scan'208";a="259273951"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga006.jf.intel.com with ESMTP; 22 Apr 2020 19:25:54 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
Subject: [PATCH 07/13] KVM: VMX: Split out architectural interrupt/NMI blocking checks
Date:   Wed, 22 Apr 2020 19:25:44 -0700
Message-Id: <20200423022550.15113-8-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200423022550.15113-1-sean.j.christopherson@intel.com>
References: <20200423022550.15113-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move the architectural (non-KVM specific) interrupt/NMI blocking checks
to a separate helper so that they can be used in a future patch by
vmx_check_nested_events().

No functional change intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 41 +++++++++++++++++++++++++----------------
 arch/x86/kvm/vmx/vmx.h |  2 ++
 2 files changed, 27 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index c7bb9d90d441..50c726a21feb 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4511,34 +4511,43 @@ void vmx_set_nmi_mask(struct kvm_vcpu *vcpu, bool masked)
 	}
 }
 
-static bool vmx_nmi_allowed(struct kvm_vcpu *vcpu)
+bool vmx_nmi_blocked(struct kvm_vcpu *vcpu)
 {
-	if (to_vmx(vcpu)->nested.nested_run_pending)
-		return false;
-
 	if (is_guest_mode(vcpu) && nested_exit_on_nmi(vcpu))
+		return false;
+
+	if (!enable_vnmi && to_vmx(vcpu)->loaded_vmcs->soft_vnmi_blocked)
 		return true;
 
-	if (!enable_vnmi &&
-	    to_vmx(vcpu)->loaded_vmcs->soft_vnmi_blocked)
-		return false;
-
-	return	!(vmcs_read32(GUEST_INTERRUPTIBILITY_INFO) &
-		  (GUEST_INTR_STATE_MOV_SS | GUEST_INTR_STATE_STI
-		   | GUEST_INTR_STATE_NMI));
+	return (vmcs_read32(GUEST_INTERRUPTIBILITY_INFO) &
+		(GUEST_INTR_STATE_MOV_SS | GUEST_INTR_STATE_STI |
+		 GUEST_INTR_STATE_NMI));
 }
 
-static bool vmx_interrupt_allowed(struct kvm_vcpu *vcpu)
+static bool vmx_nmi_allowed(struct kvm_vcpu *vcpu)
 {
 	if (to_vmx(vcpu)->nested.nested_run_pending)
 		return false;
 
+	return !vmx_nmi_blocked(vcpu);
+}
+
+bool vmx_interrupt_blocked(struct kvm_vcpu *vcpu)
+{
 	if (is_guest_mode(vcpu) && nested_exit_on_intr(vcpu))
-		return true;
+		return false;
 
-	return (vmcs_readl(GUEST_RFLAGS) & X86_EFLAGS_IF) &&
-		!(vmcs_read32(GUEST_INTERRUPTIBILITY_INFO) &
-			(GUEST_INTR_STATE_STI | GUEST_INTR_STATE_MOV_SS));
+	return !(vmcs_readl(GUEST_RFLAGS) & X86_EFLAGS_IF) ||
+	       (vmcs_read32(GUEST_INTERRUPTIBILITY_INFO) &
+		(GUEST_INTR_STATE_STI | GUEST_INTR_STATE_MOV_SS));
+}
+
+static bool vmx_interrupt_allowed(struct kvm_vcpu *vcpu)
+{
+	if (to_vmx(vcpu)->nested.nested_run_pending)
+		return false;
+
+	return !vmx_interrupt_blocked(vcpu);
 }
 
 static int vmx_set_tss_addr(struct kvm *kvm, unsigned int addr)
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index edfb739e5907..b5e773267abe 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -344,6 +344,8 @@ void vmx_set_segment(struct kvm_vcpu *vcpu, struct kvm_segment *var, int seg);
 u64 construct_eptp(struct kvm_vcpu *vcpu, unsigned long root_hpa);
 void update_exception_bitmap(struct kvm_vcpu *vcpu);
 void vmx_update_msr_bitmap(struct kvm_vcpu *vcpu);
+bool vmx_nmi_blocked(struct kvm_vcpu *vcpu);
+bool vmx_interrupt_blocked(struct kvm_vcpu *vcpu);
 bool vmx_get_nmi_mask(struct kvm_vcpu *vcpu);
 void vmx_set_nmi_mask(struct kvm_vcpu *vcpu, bool masked);
 void vmx_set_virtual_apic_mode(struct kvm_vcpu *vcpu);
-- 
2.26.0

