Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BB832B4F9B
	for <lists+kvm@lfdr.de>; Mon, 16 Nov 2020 19:34:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388054AbgKPS2C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Nov 2020 13:28:02 -0500
Received: from mga06.intel.com ([134.134.136.31]:20628 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387771AbgKPS2B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Nov 2020 13:28:01 -0500
IronPort-SDR: WoVba1Axp/k8FrY97SANrXZ96KizjveiwvyTcmPfkcdjqgeaW34QXXkY+6UTQM8YaTOLQDtY9G
 Tn7yaLoRDXnw==
X-IronPort-AV: E=McAfee;i="6000,8403,9807"; a="232410017"
X-IronPort-AV: E=Sophos;i="5.77,483,1596524400"; 
   d="scan'208";a="232410017"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2020 10:28:00 -0800
IronPort-SDR: 0JTcbWU0K0RTbpdP8qYFfT7xWmV1wAD3/6l5xaRUGXdlr+rV4VBpoLMgZWynVipuWDrWMDyAUF
 bMdOrZHl6M0w==
X-IronPort-AV: E=Sophos;i="5.77,483,1596524400"; 
   d="scan'208";a="400527917"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2020 10:28:00 -0800
From:   isaku.yamahata@intel.com
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [RFC PATCH 18/67] KVM: x86: Add per-VM flag to disable direct IRQ injection
Date:   Mon, 16 Nov 2020 10:26:03 -0800
Message-Id: <9b3fb23c848a5937b47b6b784aca71427bf2e001.1605232743.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1605232743.git.isaku.yamahata@intel.com>
References: <cover.1605232743.git.isaku.yamahata@intel.com>
In-Reply-To: <cover.1605232743.git.isaku.yamahata@intel.com>
References: <cover.1605232743.git.isaku.yamahata@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Add a flag to disable IRQ injection, which is not supported by TDX.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/asm/kvm_host.h | 1 +
 arch/x86/kvm/x86.c              | 4 +++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index e687a8bd46ad..e8180a1fe610 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -995,6 +995,7 @@ struct kvm_arch {
 	} msr_filter;
 
 	bool guest_state_protected;
+	bool irq_injection_disallowed;
 
 	struct kvm_pmu_event_filter *pmu_event_filter;
 	struct task_struct *nx_lpage_recovery_thread;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6154abecd546..ec66d5d53a1a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4041,7 +4041,8 @@ static int kvm_vcpu_ready_for_interrupt_injection(struct kvm_vcpu *vcpu)
 static int kvm_vcpu_ioctl_interrupt(struct kvm_vcpu *vcpu,
 				    struct kvm_interrupt *irq)
 {
-	if (irq->irq >= KVM_NR_INTERRUPTS)
+	if (irq->irq >= KVM_NR_INTERRUPTS ||
+	    vcpu->kvm->arch.irq_injection_disallowed)
 		return -EINVAL;
 
 	if (!irqchip_in_kernel(vcpu->kvm)) {
@@ -8170,6 +8171,7 @@ static int emulator_fix_hypercall(struct x86_emulate_ctxt *ctxt)
 static int dm_request_for_irq_injection(struct kvm_vcpu *vcpu)
 {
 	return vcpu->run->request_interrupt_window &&
+	       !vcpu->kvm->arch.irq_injection_disallowed &&
 		likely(!pic_in_kernel(vcpu->kvm));
 }
 
-- 
2.17.1

