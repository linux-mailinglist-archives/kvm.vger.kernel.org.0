Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 644411B5280
	for <lists+kvm@lfdr.de>; Thu, 23 Apr 2020 04:27:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726787AbgDWC1O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Apr 2020 22:27:14 -0400
Received: from mga05.intel.com ([192.55.52.43]:43420 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725781AbgDWCZz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Apr 2020 22:25:55 -0400
IronPort-SDR: kSu3cH7pfQu2+vbmxptdO2yup/t4YlWft3/4CukXOgcj0FlwREG+9V+zBE+ojAvLOWED5chXIJ
 /lx/tCY9yQbA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2020 19:25:54 -0700
IronPort-SDR: Sj0xkETfau7RSHL1gMh2XMRjajiIEIwpVHoIBFwExTsGKMHTA+/lI86EIom76SFCcTbEHaVLOz
 qk7HRI6CiZ+g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,305,1583222400"; 
   d="scan'208";a="259273935"
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
Subject: [PATCH 02/13] KVM: nVMX: Open a window for pending nested VMX preemption timer
Date:   Wed, 22 Apr 2020 19:25:39 -0700
Message-Id: <20200423022550.15113-3-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200423022550.15113-1-sean.j.christopherson@intel.com>
References: <20200423022550.15113-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a kvm_x86_ops hook to detect a nested pending "hypervisor timer" and
use it to effectively open a window for servicing the expired timer.
Like pending SMIs on VMX, opening a window simply means requesting an
immediate exit.

This fixes a bug where an expired VMX preemption timer (for L2) will be
delayed and/or lost if a pending exception is injected into L2.  The
pending exception is rightly prioritized by vmx_check_nested_events()
and injected into L2, with the preemption timer left pending.  Because
no window opened, L2 is free to run uninterrupted.

Fixes: f4124500c2c13 ("KVM: nVMX: Fully emulate preemption timer")
Reported-by: Jim Mattson <jmattson@google.com>
Cc: Oliver Upton <oupton@google.com>
Cc: Peter Shier <pshier@google.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/vmx/nested.c       | 10 ++++++++--
 arch/x86/kvm/x86.c              |  4 ++++
 3 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index f26df2cb0591..65dc2c88d8b2 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1179,6 +1179,7 @@ struct kvm_x86_ops {
 	void (*handle_exit_irqoff)(struct kvm_vcpu *vcpu);
 
 	int (*check_nested_events)(struct kvm_vcpu *vcpu);
+	bool (*nested_hv_timer_pending)(struct kvm_vcpu *vcpu);
 	void (*request_immediate_exit)(struct kvm_vcpu *vcpu);
 
 	void (*sched_in)(struct kvm_vcpu *kvm, int cpu);
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index dc7315b31fee..63cf339a13ac 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3687,6 +3687,12 @@ static void nested_vmx_update_pending_dbg(struct kvm_vcpu *vcpu)
 			    vcpu->arch.exception.payload);
 }
 
+static bool nested_vmx_preemption_timer_pending(struct kvm_vcpu *vcpu)
+{
+	return nested_cpu_has_preemption_timer(get_vmcs12(vcpu)) &&
+	       to_vmx(vcpu)->nested.preemption_timer_expired;
+}
+
 static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
@@ -3742,8 +3748,7 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
 		return 0;
 	}
 
-	if (nested_cpu_has_preemption_timer(get_vmcs12(vcpu)) &&
-	    vmx->nested.preemption_timer_expired) {
+	if (nested_vmx_preemption_timer_pending(vcpu)) {
 		if (block_nested_events)
 			return -EBUSY;
 		nested_vmx_vmexit(vcpu, EXIT_REASON_PREEMPTION_TIMER, 0, 0);
@@ -6443,6 +6448,7 @@ __init int nested_vmx_hardware_setup(struct kvm_x86_ops *ops,
 	exit_handlers[EXIT_REASON_VMFUNC]	= handle_vmfunc;
 
 	ops->check_nested_events = vmx_check_nested_events;
+	ops->nested_hv_timer_pending = nested_vmx_preemption_timer_pending;
 	ops->get_nested_state = vmx_get_nested_state;
 	ops->set_nested_state = vmx_set_nested_state;
 	ops->get_vmcs12_pages = nested_get_vmcs12_pages;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 59958ce2b681..ecd612807546 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8324,6 +8324,10 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 				kvm_x86_ops.enable_nmi_window(vcpu);
 			if (kvm_cpu_has_injectable_intr(vcpu) || req_int_win)
 				kvm_x86_ops.enable_irq_window(vcpu);
+			if (is_guest_mode(vcpu) &&
+			    kvm_x86_ops.nested_hv_timer_pending &&
+			    kvm_x86_ops.nested_hv_timer_pending(vcpu))
+				req_immediate_exit = true;
 			WARN_ON(vcpu->arch.exception.pending);
 		}
 
-- 
2.26.0

