Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 660C630C6BE
	for <lists+kvm@lfdr.de>; Tue,  2 Feb 2021 17:58:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237023AbhBBQ5k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Feb 2021 11:57:40 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:56765 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236853AbhBBQxM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 2 Feb 2021 11:53:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612284706;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bmydRBNKRT8IwsZtBsgzpq6QGxxHd/gPbm4AgFGJl68=;
        b=CzBJGLQTuneKrzp2F7yqvK6bKemFjXlvWm+1hY2FmieeA4v8hnP2F3NDryQVLowNklplOm
        ajWaeS6Ly2QJYDMAXwriqt/ZCbIT5cHuUXTgjmnJ4LjjklJmatRcjq9mw/5t2U99dKUe12
        s7dtjOfQujMfIYU+Ahcrl4w9njaC1e0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-86-mGUl0i5HNhSllOjPgRSk0w-1; Tue, 02 Feb 2021 11:51:44 -0500
X-MC-Unique: mGUl0i5HNhSllOjPgRSk0w-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 22589801817;
        Tue,  2 Feb 2021 16:51:43 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C17F06EF45;
        Tue,  2 Feb 2021 16:51:42 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com
Subject: [PATCH 2/3] KVM: x86: move kvm_inject_gp up from kvm_handle_invpcid to callers
Date:   Tue,  2 Feb 2021 11:51:40 -0500
Message-Id: <20210202165141.88275-3-pbonzini@redhat.com>
In-Reply-To: <20210202165141.88275-1-pbonzini@redhat.com>
References: <20210202165141.88275-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Push the injection of #GP up to the callers, so that they can just use
kvm_complete_insn_gp.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm/svm.c | 11 ++++++-----
 arch/x86/kvm/vmx/vmx.c | 11 ++++++-----
 arch/x86/kvm/x86.c     |  9 +++------
 3 files changed, 15 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 65d70b9691b4..c0d41a6920f0 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3057,6 +3057,7 @@ static int invpcid_interception(struct vcpu_svm *svm)
 	struct kvm_vcpu *vcpu = &svm->vcpu;
 	unsigned long type;
 	gva_t gva;
+	int err;
 
 	if (!guest_cpuid_has(vcpu, X86_FEATURE_INVPCID)) {
 		kvm_queue_exception(vcpu, UD_VECTOR);
@@ -3071,12 +3072,12 @@ static int invpcid_interception(struct vcpu_svm *svm)
 	type = svm->vmcb->control.exit_info_2;
 	gva = svm->vmcb->control.exit_info_1;
 
-	if (type > 3) {
-		kvm_inject_gp(vcpu, 0);
-		return 1;
-	}
+	if (type > 3)
+		err = 1;
+	else
+		err = kvm_handle_invpcid(vcpu, type, gva);
 
-	return kvm_handle_invpcid(vcpu, type, gva);
+	return kvm_complete_insn_gp(&svm->vcpu, err);
 }
 
 static int (*const svm_exit_handlers[])(struct vcpu_svm *svm) = {
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 28daceb4f70d..a07fce6d0bbb 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5559,6 +5559,7 @@ static int handle_invpcid(struct kvm_vcpu *vcpu)
 		u64 pcid;
 		u64 gla;
 	} operand;
+	int err = 1;
 
 	if (!guest_cpuid_has(vcpu, X86_FEATURE_INVPCID)) {
 		kvm_queue_exception(vcpu, UD_VECTOR);
@@ -5568,10 +5569,8 @@ static int handle_invpcid(struct kvm_vcpu *vcpu)
 	vmx_instruction_info = vmcs_read32(VMX_INSTRUCTION_INFO);
 	type = kvm_register_readl(vcpu, (vmx_instruction_info >> 28) & 0xf);
 
-	if (type > 3) {
-		kvm_inject_gp(vcpu, 0);
-		return 1;
-	}
+	if (type > 3)
+		goto out;
 
 	/* According to the Intel instruction reference, the memory operand
 	 * is read even if it isn't needed (e.g., for type==all)
@@ -5581,7 +5580,9 @@ static int handle_invpcid(struct kvm_vcpu *vcpu)
 				sizeof(operand), &gva))
 		return 1;
 
-	return kvm_handle_invpcid(vcpu, type, gva);
+	err = kvm_handle_invpcid(vcpu, type, gva);
+out:
+	return kvm_complete_insn_gp(vcpu, err);
 }
 
 static int handle_pml_full(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 08568c47337c..edbeb162012b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11375,7 +11375,6 @@ int kvm_handle_invpcid(struct kvm_vcpu *vcpu, unsigned long type, gva_t gva)
 		return kvm_handle_memory_failure(vcpu, r, &e);
 
 	if (operand.pcid >> 12 != 0) {
-		kvm_inject_gp(vcpu, 0);
 		return 1;
 	}
 
@@ -11385,15 +11384,13 @@ int kvm_handle_invpcid(struct kvm_vcpu *vcpu, unsigned long type, gva_t gva)
 	case INVPCID_TYPE_INDIV_ADDR:
 		if ((!pcid_enabled && (operand.pcid != 0)) ||
 		    is_noncanonical_address(operand.gla, vcpu)) {
-			kvm_inject_gp(vcpu, 0);
 			return 1;
 		}
 		kvm_mmu_invpcid_gva(vcpu, operand.gla, operand.pcid);
-		return kvm_skip_emulated_instruction(vcpu);
+		return 0;
 
 	case INVPCID_TYPE_SINGLE_CTXT:
 		if (!pcid_enabled && (operand.pcid != 0)) {
-			kvm_inject_gp(vcpu, 0);
 			return 1;
 		}
 
@@ -11414,7 +11411,7 @@ int kvm_handle_invpcid(struct kvm_vcpu *vcpu, unsigned long type, gva_t gva)
 		 * resync will happen anyway before switching to any other CR3.
 		 */
 
-		return kvm_skip_emulated_instruction(vcpu);
+		return 0;
 
 	case INVPCID_TYPE_ALL_NON_GLOBAL:
 		/*
@@ -11427,7 +11424,7 @@ int kvm_handle_invpcid(struct kvm_vcpu *vcpu, unsigned long type, gva_t gva)
 		fallthrough;
 	case INVPCID_TYPE_ALL_INCL_GLOBAL:
 		kvm_mmu_unload(vcpu);
-		return kvm_skip_emulated_instruction(vcpu);
+		return 0;
 
 	default:
 		BUG(); /* We have already checked above that type <= 3 */
-- 
2.26.2


