Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36D921AB046
	for <lists+kvm@lfdr.de>; Wed, 15 Apr 2020 20:00:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2411676AbgDOSAI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Apr 2020 14:00:08 -0400
Received: from mga18.intel.com ([134.134.136.126]:30605 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2440834AbgDORzZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Apr 2020 13:55:25 -0400
IronPort-SDR: 055wamzeSkwpfONDcX4rQ/0P+EreQS0cjqX4aI9zfjDE7vT5LeCW/cW4Af8z3llQ7t1ckzzj1a
 oemRsjIhLgKw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2020 10:55:24 -0700
IronPort-SDR: tv2P1kuIyopIUKehbakyNGkMk3xMgzusOZGJje4Xko8VA7aeC0FrgUBeoLD89VvTV/nJDrRGGV
 Hxaa74kC5eUQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,387,1580803200"; 
   d="scan'208";a="332567359"
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
Subject: [PATCH v2 08/10] KVM: nVMX: Cast exit_reason to u16 to check for nested EXTERNAL_INTERRUPT
Date:   Wed, 15 Apr 2020 10:55:17 -0700
Message-Id: <20200415175519.14230-9-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200415175519.14230-1-sean.j.christopherson@intel.com>
References: <20200415175519.14230-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Explicitly check only the basic exit reason when emulating an external
interrupt VM-Exit in nested_vmx_vmexit().  Checking the full exit reason
doesn't currently cause problems, but only because the only exit reason
modifier support by KVM is FAILED_VMENTRY, which is mutually exclusive
with EXTERNAL_INTERRUPT.  Future modifiers, e.g. ENCLAVE_MODE, will
coexist with EXTERNAL_INTERRUPT.

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/nested.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 67d27bc40143..23d84d063197 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4406,7 +4406,7 @@ void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 exit_reason,
 	vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
 
 	if (likely(!vmx->fail)) {
-		if (exit_reason == EXIT_REASON_EXTERNAL_INTERRUPT &&
+		if ((u16)exit_reason == EXIT_REASON_EXTERNAL_INTERRUPT &&
 		    nested_exit_intr_ack_set(vcpu)) {
 			int irq = kvm_cpu_get_interrupt(vcpu);
 			WARN_ON(irq < 0);
-- 
2.26.0

