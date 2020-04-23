Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F8BD1B526E
	for <lists+kvm@lfdr.de>; Thu, 23 Apr 2020 04:26:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726693AbgDWC00 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Apr 2020 22:26:26 -0400
Received: from mga05.intel.com ([192.55.52.43]:43426 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726579AbgDWCZ7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Apr 2020 22:25:59 -0400
IronPort-SDR: C2+ujekk7e3guA0m+HSKE4LxoB7NFHbX6QGzJk8WfxiXtr406puFURE6H3Eubq0Mz+ngLj4XSs
 Q9y0WwQoaYnA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2020 19:25:55 -0700
IronPort-SDR: A6/N5J8iIG6Dvtnsaxb8uhvV0LJZ6i+Vqj5hekMhI5JLba2OleIeuTcaCN5vtBKW3tEl4qf6dC
 p2McRqgKiGYQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,305,1583222400"; 
   d="scan'208";a="259273954"
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
Subject: [PATCH 08/13] KVM: nVMX: Preserve IRQ/NMI priority irrespective of exiting behavior
Date:   Wed, 22 Apr 2020 19:25:45 -0700
Message-Id: <20200423022550.15113-9-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200423022550.15113-1-sean.j.christopherson@intel.com>
References: <20200423022550.15113-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Short circuit vmx_check_nested_events() if an unblocked IRQ/NMI is
pending and needs to be injected into L2, priority between coincident
events is not dependent on exiting behavior.

Fixes: b6b8a1451fc4 ("KVM: nVMX: Rework interception of IRQs and NMIs")
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/nested.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 40b2427f35b7..1fdaca5fd93d 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3750,9 +3750,12 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
 		return 0;
 	}
 
-	if (vcpu->arch.nmi_pending && nested_exit_on_nmi(vcpu)) {
+	if (vcpu->arch.nmi_pending && !vmx_nmi_blocked(vcpu)) {
 		if (block_nested_events)
 			return -EBUSY;
+		if (!nested_exit_on_nmi(vcpu))
+			goto no_vmexit;
+
 		nested_vmx_vmexit(vcpu, EXIT_REASON_EXCEPTION_NMI,
 				  NMI_VECTOR | INTR_TYPE_NMI_INTR |
 				  INTR_INFO_VALID_MASK, 0);
@@ -3765,9 +3768,11 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
 		return 0;
 	}
 
-	if (kvm_cpu_has_interrupt(vcpu) && nested_exit_on_intr(vcpu)) {
+	if (kvm_cpu_has_interrupt(vcpu) && !vmx_interrupt_blocked(vcpu)) {
 		if (block_nested_events)
 			return -EBUSY;
+		if (!nested_exit_on_intr(vcpu))
+			goto no_vmexit;
 		nested_vmx_vmexit(vcpu, EXIT_REASON_EXTERNAL_INTERRUPT, 0, 0);
 		return 0;
 	}
-- 
2.26.0

