Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1F291B5278
	for <lists+kvm@lfdr.de>; Thu, 23 Apr 2020 04:27:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726700AbgDWC0f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Apr 2020 22:26:35 -0400
Received: from mga05.intel.com ([192.55.52.43]:43423 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726566AbgDWCZ6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Apr 2020 22:25:58 -0400
IronPort-SDR: 2+yn6XKlbhBdQS6FMbEsWqg7o6buTuxg2T1jynp5suzR+oxkzm//quX/zShXSWp03XrtpCat2H
 28VXC/zfTyng==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2020 19:25:54 -0700
IronPort-SDR: bOGXL2Q6vtAyfC1m2AyNtPmwIxm00w36xy+ihcBTehjipx0n8wB3g2BfYwq6uZi9O+N2vNUGcX
 3+R6r5JgOYcA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,305,1583222400"; 
   d="scan'208";a="259273944"
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
Subject: [PATCH 05/13] KVM: nVMX: Move nested_exit_on_nmi() to nested.h
Date:   Wed, 22 Apr 2020 19:25:42 -0700
Message-Id: <20200423022550.15113-6-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200423022550.15113-1-sean.j.christopherson@intel.com>
References: <20200423022550.15113-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Expose nested_exit_on_nmi() for use by vmx_nmi_allowed() in a future
patch.

No functional change intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/nested.c | 5 -----
 arch/x86/kvm/vmx/nested.h | 5 +++++
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 63cf339a13ac..40b2427f35b7 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -698,11 +698,6 @@ static bool nested_exit_intr_ack_set(struct kvm_vcpu *vcpu)
 		VM_EXIT_ACK_INTR_ON_EXIT;
 }
 
-static bool nested_exit_on_nmi(struct kvm_vcpu *vcpu)
-{
-	return nested_cpu_has_nmi_exiting(get_vmcs12(vcpu));
-}
-
 static int nested_vmx_check_apic_access_controls(struct kvm_vcpu *vcpu,
 					  struct vmcs12 *vmcs12)
 {
diff --git a/arch/x86/kvm/vmx/nested.h b/arch/x86/kvm/vmx/nested.h
index 1514ff4db77f..7d7475549b9f 100644
--- a/arch/x86/kvm/vmx/nested.h
+++ b/arch/x86/kvm/vmx/nested.h
@@ -225,6 +225,11 @@ static inline bool nested_cpu_has_save_preemption_timer(struct vmcs12 *vmcs12)
 	    VM_EXIT_SAVE_VMX_PREEMPTION_TIMER;
 }
 
+static inline bool nested_exit_on_nmi(struct kvm_vcpu *vcpu)
+{
+	return nested_cpu_has_nmi_exiting(get_vmcs12(vcpu));
+}
+
 /*
  * In nested virtualization, check if L1 asked to exit on external interrupts.
  * For most existing hypervisors, this will always return true.
-- 
2.26.0

