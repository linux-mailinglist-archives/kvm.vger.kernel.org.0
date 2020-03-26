Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48A2F193BF8
	for <lists+kvm@lfdr.de>; Thu, 26 Mar 2020 10:35:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727901AbgCZJfd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Mar 2020 05:35:33 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:57628 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727868AbgCZJfY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 26 Mar 2020 05:35:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585215323;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=L2sYLwTjpS4Wy/1BaruUB/j+qeV3x0Y8fENUYH2uZrU=;
        b=TbKs66vsw47zidbVX+OktoypcYUi69/q6JGZUO8TQdZRCC2srek6wa3Up67jJl72d+jQWG
        YmAwH6wLee05C1cc8ql47ySrwfCvEMoewKXPreiK+cWfR4CaoYStLE5mElXf571BXq9xe4
        0jqCnP8IUB0yJm/ZVzWd2k5wKBeNPwM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-214-WkidQZtAOkig5nPGd6aNHw-1; Thu, 26 Mar 2020 05:35:21 -0400
X-MC-Unique: WkidQZtAOkig5nPGd6aNHw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 24EF4DB21;
        Thu, 26 Mar 2020 09:35:20 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 76FF69CA3;
        Thu, 26 Mar 2020 09:35:19 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Junaid Shahid <junaids@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [PATCH 3/3] KVM: x86: Sync SPTEs when injecting page/EPT fault into L1
Date:   Thu, 26 Mar 2020 05:35:16 -0400
Message-Id: <20200326093516.24215-4-pbonzini@redhat.com>
In-Reply-To: <20200326093516.24215-1-pbonzini@redhat.com>
References: <20200326093516.24215-1-pbonzini@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Junaid Shahid <junaids@google.com>

When injecting a page fault or EPT violation/misconfiguration, KVM is
not syncing any shadow PTEs associated with the faulting address,
including those in previous MMUs that are associated with L1's current
EPTP (in a nested EPT scenario), nor is it flushing any hardware TLB
entries.  All this is done by kvm_mmu_invalidate_gva.

Page faults that are either !PRESENT or RSVD are exempt from the flushing,
as the CPU is not allowed to cache such translations.

Signed-off-by: Junaid Shahid <junaids@google.com>
Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Message-Id: <20200320212833.3507-8-sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/nested.c | 12 ++++++------
 arch/x86/kvm/vmx/vmx.c    |  2 +-
 arch/x86/kvm/x86.c        | 11 ++++++++++-
 3 files changed, 17 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 2c450b0ba592..1586b1b5ba93 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4559,7 +4559,7 @@ static int nested_vmx_get_vmptr(struct kvm_vcpu *vcpu, gpa_t *vmpointer)
 		return 1;
 
 	if (kvm_read_guest_virt(vcpu, gva, vmpointer, sizeof(*vmpointer), &e)) {
-		kvm_inject_page_fault(vcpu, &e);
+		kvm_inject_emulated_page_fault(vcpu, &e);
 		return 1;
 	}
 
@@ -4868,7 +4868,7 @@ static int handle_vmread(struct kvm_vcpu *vcpu)
 			return 1;
 		/* _system ok, nested_vmx_check_permission has verified cpl=0 */
 		if (kvm_write_guest_virt_system(vcpu, gva, &value, len, &e)) {
-			kvm_inject_page_fault(vcpu, &e);
+			kvm_inject_emulated_page_fault(vcpu, &e);
 			return 1;
 		}
 	}
@@ -4942,7 +4942,7 @@ static int handle_vmwrite(struct kvm_vcpu *vcpu)
 					instr_info, false, len, &gva))
 			return 1;
 		if (kvm_read_guest_virt(vcpu, gva, &value, len, &e)) {
-			kvm_inject_page_fault(vcpu, &e);
+			kvm_inject_emulated_page_fault(vcpu, &e);
 			return 1;
 		}
 	}
@@ -5107,7 +5107,7 @@ static int handle_vmptrst(struct kvm_vcpu *vcpu)
 	/* *_system ok, nested_vmx_check_permission has verified cpl=0 */
 	if (kvm_write_guest_virt_system(vcpu, gva, (void *)&current_vmptr,
 					sizeof(gpa_t), &e)) {
-		kvm_inject_page_fault(vcpu, &e);
+		kvm_inject_emulated_page_fault(vcpu, &e);
 		return 1;
 	}
 	return nested_vmx_succeed(vcpu);
@@ -5151,7 +5151,7 @@ static int handle_invept(struct kvm_vcpu *vcpu)
 			vmx_instruction_info, false, sizeof(operand), &gva))
 		return 1;
 	if (kvm_read_guest_virt(vcpu, gva, &operand, sizeof(operand), &e)) {
-		kvm_inject_page_fault(vcpu, &e);
+		kvm_inject_emulated_page_fault(vcpu, &e);
 		return 1;
 	}
 
@@ -5219,7 +5219,7 @@ static int handle_invvpid(struct kvm_vcpu *vcpu)
 			vmx_instruction_info, false, sizeof(operand), &gva))
 		return 1;
 	if (kvm_read_guest_virt(vcpu, gva, &operand, sizeof(operand), &e)) {
-		kvm_inject_page_fault(vcpu, &e);
+		kvm_inject_emulated_page_fault(vcpu, &e);
 		return 1;
 	}
 	if (operand.vpid >> 16)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 07299a957d4a..c944726b3c0c 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5404,7 +5404,7 @@ static int handle_invpcid(struct kvm_vcpu *vcpu)
 		return 1;
 
 	if (kvm_read_guest_virt(vcpu, gva, &operand, sizeof(operand), &e)) {
-		kvm_inject_page_fault(vcpu, &e);
+		kvm_inject_emulated_page_fault(vcpu, &e);
 		return 1;
 	}
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 522905523bf0..dbca6c3bd0db 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -618,8 +618,17 @@ bool kvm_inject_emulated_page_fault(struct kvm_vcpu *vcpu,
 	WARN_ON_ONCE(fault->vector != PF_VECTOR);
 
 	fault_mmu = fault->nested_page_fault ? vcpu->arch.mmu : vcpu->arch.walk_mmu;
-	fault_mmu->inject_page_fault(vcpu, fault);
 
+	/*
+	 * Invalidate the TLB entry for the faulting address, if it exists,
+	 * else the access will fault indefinitely (and to emulate hardware).
+	 */
+	if ((fault->error_code & PFERR_PRESENT_MASK)
+	    && !(fault->error_code & PFERR_RSVD_MASK))
+		kvm_mmu_invalidate_gva(vcpu, fault_mmu,
+				       fault->address, fault_mmu->root_hpa);
+
+	fault_mmu->inject_page_fault(vcpu, fault);
 	return fault->nested_page_fault;
 }
 EXPORT_SYMBOL_GPL(kvm_inject_emulated_page_fault);
-- 
2.18.2

