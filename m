Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 666181AB042
	for <lists+kvm@lfdr.de>; Wed, 15 Apr 2020 20:00:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2411632AbgDOR7x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Apr 2020 13:59:53 -0400
Received: from mga14.intel.com ([192.55.52.115]:26432 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2440946AbgDORz2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Apr 2020 13:55:28 -0400
IronPort-SDR: nnoHj2tUtvnQ8lgsRHKyB2JVmrLf4TQ2Yc4nTGjc6pY8T8MCKdpJb4PdBuBwLgyGjqSxPU2Jle
 y5RkN+7uho7w==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2020 10:55:23 -0700
IronPort-SDR: Y8pGBw8L+f0YVJYXe3HnF5fcwG9oIM13F1tFQSWysl6aTtB8gr8AolIyWNddj/BReMLv3iRfUg
 Sptf9WhU8ATA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,387,1580803200"; 
   d="scan'208";a="332567357"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga001.jf.intel.com with ESMTP; 15 Apr 2020 10:55:23 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v2 07/10] KVM: nVMX: Pull exit_reason from vcpu_vmx in nested_vmx_reflect_vmexit()
Date:   Wed, 15 Apr 2020 10:55:16 -0700
Message-Id: <20200415175519.14230-8-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200415175519.14230-1-sean.j.christopherson@intel.com>
References: <20200415175519.14230-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Grab the exit reason from the vcpu struct in nested_vmx_reflect_vmexit()
instead of having the exit reason explicitly passed from the caller.
This fixes a discrepancy between VM-Fail and VM-Exit handling, as the
VM-Fail case is already handled by checking vcpu_vmx, e.g. the exit
reason previously passed on the stack is bogus if vmx->fail is set.

Not taking the exit reason on the stack also avoids having to document
that nested_vmx_reflect_vmexit() requires the full exit reason, as
opposed to just the basic exit reason, which is not at all obvious since
the only usages of the full exit reason are for tracing and way down in
prepare_vmcs12() where it's propagated to vmcs12.

No functional change intended.

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/nested.c | 3 ++-
 arch/x86/kvm/vmx/nested.h | 2 +-
 arch/x86/kvm/vmx/vmx.c    | 2 +-
 3 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index e8db560ee3eb..67d27bc40143 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -5826,9 +5826,10 @@ static bool nested_vmx_l1_wants_exit(struct kvm_vcpu *vcpu, u32 exit_reason)
  * Conditionally reflect a VM-Exit into L1.  Returns %true if the VM-Exit was
  * reflected into L1.
  */
-bool nested_vmx_reflect_vmexit(struct kvm_vcpu *vcpu, u32 exit_reason)
+bool nested_vmx_reflect_vmexit(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	u32 exit_reason = vmx->exit_reason;
 	u32 exit_intr_info, exit_qual;
 
 	WARN_ON_ONCE(vmx->nested.nested_run_pending);
diff --git a/arch/x86/kvm/vmx/nested.h b/arch/x86/kvm/vmx/nested.h
index bd959bd2eb58..61cafee13ece 100644
--- a/arch/x86/kvm/vmx/nested.h
+++ b/arch/x86/kvm/vmx/nested.h
@@ -25,7 +25,7 @@ void nested_vmx_set_vmcs_shadowing_bitmap(void);
 void nested_vmx_free_vcpu(struct kvm_vcpu *vcpu);
 enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
 						     bool from_vmentry);
-bool nested_vmx_reflect_vmexit(struct kvm_vcpu *vcpu, u32 exit_reason);
+bool nested_vmx_reflect_vmexit(struct kvm_vcpu *vcpu);
 void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 exit_reason,
 		       u32 exit_intr_info, unsigned long exit_qualification);
 void nested_sync_vmcs12_to_shadow(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index d92ed73b22da..19a82f846e8e 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5905,7 +5905,7 @@ static int vmx_handle_exit(struct kvm_vcpu *vcpu,
 		 */
 		nested_mark_vmcs12_pages_dirty(vcpu);
 
-		if (nested_vmx_reflect_vmexit(vcpu, exit_reason))
+		if (nested_vmx_reflect_vmexit(vcpu))
 			return 1;
 	}
 
-- 
2.26.0

