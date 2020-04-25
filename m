Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1372D1B8410
	for <lists+kvm@lfdr.de>; Sat, 25 Apr 2020 09:02:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726295AbgDYHCG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 25 Apr 2020 03:02:06 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:51009 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726188AbgDYHCF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 25 Apr 2020 03:02:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587798124;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=Zhop02cboELmmyjJa4pTw5otGh2YRyzNp42T5e+hcbY=;
        b=F32QWdSaIa4u31G8zsCSSHpy68Jn311I0mSQQFW7NGMzndASnRXk4f62syDZd+rqq832Yy
        X6JsBXyK6qQHPb3gR5V0Mkk/nmR3s2ur2oHxMoKDLHmGv3caWRK43FvshQV9LMtojlyVKA
        Q1oTI6i1eh7Ogc8Z7KX8Uizp5bw5bpk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-249-L3qCV47DNH-5TfaqJEYYqA-1; Sat, 25 Apr 2020 03:01:59 -0400
X-MC-Unique: L3qCV47DNH-5TfaqJEYYqA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8CED11005510;
        Sat, 25 Apr 2020 07:01:58 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D32835D9C5;
        Sat, 25 Apr 2020 07:01:57 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     wei.huang2@amd.com, cavery@redhat.com, vkuznets@redhat.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Oliver Upton <oupton@google.com>,
        Jim Mattson <jmattson@google.com>
Subject: [PATCH v2 13/22] KVM: VMX: Split out architectural interrupt/NMI blocking checks
Date:   Sat, 25 Apr 2020 03:01:45 -0400
Message-Id: <20200425070154.251290-4-pbonzini@redhat.com>
In-Reply-To: <20200424172416.243870-1-pbonzini@redhat.com>
References: <20200424172416.243870-1-pbonzini@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Move the architectural (non-KVM specific) interrupt/NMI blocking checks
to a separate helper so that they can be used in a future patch by
vmx_check_nested_events().

No functional change intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Message-Id: <20200423022550.15113-8-sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/vmx.c | 35 ++++++++++++++++++++++-------------
 arch/x86/kvm/vmx/vmx.h |  2 ++
 2 files changed, 24 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 37b1986a4e8f..7fb7dcb3d94d 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4511,21 +4511,35 @@ void vmx_set_nmi_mask(struct kvm_vcpu *vcpu, bool masked)
 	}
 }
 
+bool vmx_nmi_blocked(struct kvm_vcpu *vcpu)
+{
+	if (is_guest_mode(vcpu) && nested_exit_on_nmi(vcpu))
+		return false;
+
+	if (!enable_vnmi && to_vmx(vcpu)->loaded_vmcs->soft_vnmi_blocked)
+		return true;
+
+	return (vmcs_read32(GUEST_INTERRUPTIBILITY_INFO) &
+		(GUEST_INTR_STATE_MOV_SS | GUEST_INTR_STATE_STI |
+		 GUEST_INTR_STATE_NMI));
+}
+
 static bool vmx_nmi_allowed(struct kvm_vcpu *vcpu)
 {
 	if (to_vmx(vcpu)->nested.nested_run_pending)
 		return false;
 
-	if (is_guest_mode(vcpu) && nested_exit_on_nmi(vcpu))
-		return true;
+	return !vmx_nmi_blocked(vcpu);
+}
 
-	if (!enable_vnmi &&
-	    to_vmx(vcpu)->loaded_vmcs->soft_vnmi_blocked)
+bool vmx_interrupt_blocked(struct kvm_vcpu *vcpu)
+{
+	if (is_guest_mode(vcpu) && nested_exit_on_intr(vcpu))
 		return false;
 
-	return	!(vmcs_read32(GUEST_INTERRUPTIBILITY_INFO) &
-		  (GUEST_INTR_STATE_MOV_SS | GUEST_INTR_STATE_STI
-		   | GUEST_INTR_STATE_NMI));
+	return !(vmcs_readl(GUEST_RFLAGS) & X86_EFLAGS_IF) ||
+	       (vmcs_read32(GUEST_INTERRUPTIBILITY_INFO) &
+		(GUEST_INTR_STATE_STI | GUEST_INTR_STATE_MOV_SS));
 }
 
 static bool vmx_interrupt_allowed(struct kvm_vcpu *vcpu)
@@ -4533,12 +4547,7 @@ static bool vmx_interrupt_allowed(struct kvm_vcpu *vcpu)
 	if (to_vmx(vcpu)->nested.nested_run_pending)
 		return false;
 
-	if (is_guest_mode(vcpu) && nested_exit_on_intr(vcpu))
-		return true;
-
-	return (vmcs_readl(GUEST_RFLAGS) & X86_EFLAGS_IF) &&
-		!(vmcs_read32(GUEST_INTERRUPTIBILITY_INFO) &
-			(GUEST_INTR_STATE_STI | GUEST_INTR_STATE_MOV_SS));
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
2.18.2


