Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8B873BA56A
	for <lists+kvm@lfdr.de>; Sat,  3 Jul 2021 00:06:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233349AbhGBWII (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jul 2021 18:08:08 -0400
Received: from mga12.intel.com ([192.55.52.136]:50197 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233119AbhGBWH5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Jul 2021 18:07:57 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10033"; a="188472731"
X-IronPort-AV: E=Sophos;i="5.83,320,1616482800"; 
   d="scan'208";a="188472731"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2021 15:05:23 -0700
X-IronPort-AV: E=Sophos;i="5.83,320,1616482800"; 
   d="scan'208";a="642814753"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2021 15:05:23 -0700
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
        Sean Christopherson <seanjc@google.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [RFC PATCH v2 25/69] KVM: x86: Add per-VM flag to disable direct IRQ injection
Date:   Fri,  2 Jul 2021 15:04:31 -0700
Message-Id: <15c51e04bc3c5c2b6131c649291a3ee1b006abf0.1625186503.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1625186503.git.isaku.yamahata@intel.com>
References: <cover.1625186503.git.isaku.yamahata@intel.com>
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
index 301b10172cbf..be329f0a7054 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1063,6 +1063,7 @@ struct kvm_arch {
 	bool exception_payload_enabled;
 
 	bool bus_lock_detection_enabled;
+	bool irq_injection_disallowed;
 
 	/* Deflect RDMSR and WRMSR to user space when they trigger a #GP */
 	u32 user_space_msr_mask;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b89845dfb679..4070786f17d1 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4264,7 +4264,8 @@ static int kvm_vcpu_ready_for_interrupt_injection(struct kvm_vcpu *vcpu)
 static int kvm_vcpu_ioctl_interrupt(struct kvm_vcpu *vcpu,
 				    struct kvm_interrupt *irq)
 {
-	if (irq->irq >= KVM_NR_INTERRUPTS)
+	if (irq->irq >= KVM_NR_INTERRUPTS ||
+	    vcpu->kvm->arch.irq_injection_disallowed)
 		return -EINVAL;
 
 	if (!irqchip_in_kernel(vcpu->kvm)) {
@@ -8562,6 +8563,7 @@ static int emulator_fix_hypercall(struct x86_emulate_ctxt *ctxt)
 static int dm_request_for_irq_injection(struct kvm_vcpu *vcpu)
 {
 	return vcpu->run->request_interrupt_window &&
+	       !vcpu->kvm->arch.irq_injection_disallowed &&
 		likely(!pic_in_kernel(vcpu->kvm));
 }
 
-- 
2.25.1

