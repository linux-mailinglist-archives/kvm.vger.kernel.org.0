Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8DD645D202
	for <lists+kvm@lfdr.de>; Thu, 25 Nov 2021 01:27:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352774AbhKYA2Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Nov 2021 19:28:24 -0500
Received: from mga14.intel.com ([192.55.52.115]:6408 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352776AbhKYAYT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Nov 2021 19:24:19 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10178"; a="235649673"
X-IronPort-AV: E=Sophos;i="5.87,261,1631602800"; 
   d="scan'208";a="235649673"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2021 16:21:07 -0800
X-IronPort-AV: E=Sophos;i="5.87,261,1631602800"; 
   d="scan'208";a="675042147"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2021 16:21:07 -0800
From:   isaku.yamahata@intel.com
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [RFC PATCH v3 16/59] KVM: x86: Add per-VM flag to disable direct IRQ injection
Date:   Wed, 24 Nov 2021 16:19:59 -0800
Message-Id: <dbf8648ee18606a5a450bce32100771a3de5fd83.1637799475.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1637799475.git.isaku.yamahata@intel.com>
References: <cover.1637799475.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Add a flag to disable IRQ injection, which is not supported by TDX.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/include/asm/kvm_host.h | 1 +
 arch/x86/kvm/x86.c              | 4 +++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index cdb908ed7d5b..ebc4de32bf0e 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1141,6 +1141,7 @@ struct kvm_arch {
 	bool exception_payload_enabled;
 
 	bool bus_lock_detection_enabled;
+	bool irq_injection_disallowed;
 	/*
 	 * If exit_on_emulation_error is set, and the in-kernel instruction
 	 * emulator fails to emulate an instruction, allow userspace
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b21fcf3c0cc8..b399e64e8863 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4506,7 +4506,8 @@ static int kvm_vcpu_ready_for_interrupt_injection(struct kvm_vcpu *vcpu)
 static int kvm_vcpu_ioctl_interrupt(struct kvm_vcpu *vcpu,
 				    struct kvm_interrupt *irq)
 {
-	if (irq->irq >= KVM_NR_INTERRUPTS)
+	if (irq->irq >= KVM_NR_INTERRUPTS ||
+	    vcpu->kvm->arch.irq_injection_disallowed)
 		return -EINVAL;
 
 	if (!irqchip_in_kernel(vcpu->kvm)) {
@@ -8997,6 +8998,7 @@ static int emulator_fix_hypercall(struct x86_emulate_ctxt *ctxt)
 static int dm_request_for_irq_injection(struct kvm_vcpu *vcpu)
 {
 	return vcpu->run->request_interrupt_window &&
+	       !vcpu->kvm->arch.irq_injection_disallowed &&
 		likely(!pic_in_kernel(vcpu->kvm));
 }
 
-- 
2.25.1

