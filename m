Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FDF84BE4CC
	for <lists+kvm@lfdr.de>; Mon, 21 Feb 2022 18:59:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380297AbiBUQXb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Feb 2022 11:23:31 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380209AbiBUQXP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Feb 2022 11:23:15 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5D7CE27150
        for <kvm@vger.kernel.org>; Mon, 21 Feb 2022 08:22:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645460571;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sHLGPL/EpORL8eln5yr/neSEVnvit4E1fsmv6+KfrzA=;
        b=RdRqiqf22aT5U7Jik7tq4OHAvG6p1preA3YuXtecqBVvaXq+p7ZM4HTb5utggDjsfeuLfe
        4qsCsCUjofY7JjAl4E0TNUP/VtRR1GsQq0BTlZmz7Q3A8gCCePRThtkAV3eEonBHbH/vwU
        7X1yQlxgC3SezUoTc5NQIAu+R4BnMbs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-492-lkQ-WVWmMbK7lFtovrgbJA-1; Mon, 21 Feb 2022 11:22:48 -0500
X-MC-Unique: lkQ-WVWmMbK7lFtovrgbJA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3131F1926DA0;
        Mon, 21 Feb 2022 16:22:47 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9CBB077468;
        Mon, 21 Feb 2022 16:22:46 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     dmatlack@google.com, seanjc@google.com
Subject: [PATCH v2 06/25] KVM: nVMX/nSVM: do not monkey-patch inject_page_fault callback
Date:   Mon, 21 Feb 2022 11:22:24 -0500
Message-Id: <20220221162243.683208-7-pbonzini@redhat.com>
In-Reply-To: <20220221162243.683208-1-pbonzini@redhat.com>
References: <20220221162243.683208-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently, vendor code is patching the inject_page_fault and later, on
vmexit, expecting kvm_init_mmu to restore the inject_page_fault callback.

This is brittle, as exposed by the fact that SVM KVM_SET_NESTED_STATE
forgets to do it.  Instead, do the check at the time a page fault actually
has to be injected.  This does incur the cost of an extra retpoline
for nested vmexits when TDP is disabled, but is overall much cleaner.
While at it, add a comment that explains why the different behavior
is needed in this case.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |  3 +++
 arch/x86/kvm/mmu/mmu.c          |  2 +-
 arch/x86/kvm/svm/nested.c       |  4 +---
 arch/x86/kvm/vmx/nested.c       |  4 +---
 arch/x86/kvm/x86.c              | 17 +++++++++++++++++
 5 files changed, 23 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 713e08f62385..92855d3984a7 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1508,6 +1508,8 @@ struct kvm_x86_nested_ops {
 	int (*enable_evmcs)(struct kvm_vcpu *vcpu,
 			    uint16_t *vmcs_version);
 	uint16_t (*get_evmcs_version)(struct kvm_vcpu *vcpu);
+	void (*inject_page_fault)(struct kvm_vcpu *vcpu,
+				  struct x86_exception *fault);
 };
 
 struct kvm_x86_init_ops {
@@ -1747,6 +1749,7 @@ void kvm_queue_exception_p(struct kvm_vcpu *vcpu, unsigned nr, unsigned long pay
 void kvm_requeue_exception(struct kvm_vcpu *vcpu, unsigned nr);
 void kvm_requeue_exception_e(struct kvm_vcpu *vcpu, unsigned nr, u32 error_code);
 void kvm_inject_page_fault(struct kvm_vcpu *vcpu, struct x86_exception *fault);
+void kvm_inject_page_fault_shadow(struct kvm_vcpu *vcpu, struct x86_exception *fault);
 bool kvm_inject_emulated_page_fault(struct kvm_vcpu *vcpu,
 				    struct x86_exception *fault);
 bool kvm_require_cpl(struct kvm_vcpu *vcpu, int required_cpl);
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 0e393506f4df..f3494dcc4e2f 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4950,7 +4950,7 @@ static void init_kvm_softmmu(struct kvm_vcpu *vcpu,
 
 	context->get_guest_pgd	   = kvm_get_guest_cr3;
 	context->get_pdptr         = kvm_pdptr_read;
-	context->inject_page_fault = kvm_inject_page_fault;
+	context->inject_page_fault = kvm_inject_page_fault_shadow;
 }
 
 static union kvm_mmu_role
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 96bab464967f..ff58c9ebc552 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -680,9 +680,6 @@ int enter_svm_guest_mode(struct kvm_vcpu *vcpu, u64 vmcb12_gpa,
 	if (ret)
 		return ret;
 
-	if (!npt_enabled)
-		vcpu->arch.mmu->inject_page_fault = svm_inject_page_fault_nested;
-
 	if (!from_vmrun)
 		kvm_make_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu);
 
@@ -1571,4 +1568,5 @@ struct kvm_x86_nested_ops svm_nested_ops = {
 	.get_nested_state_pages = svm_get_nested_state_pages,
 	.get_state = svm_get_nested_state,
 	.set_state = svm_set_nested_state,
+	.inject_page_fault = svm_inject_page_fault_nested,
 };
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 1dfe23963a9e..564c60566da7 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2615,9 +2615,6 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
 		vmcs_write64(GUEST_PDPTR3, vmcs12->guest_pdptr3);
 	}
 
-	if (!enable_ept)
-		vcpu->arch.walk_mmu->inject_page_fault = vmx_inject_page_fault_nested;
-
 	if ((vmcs12->vm_entry_controls & VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL) &&
 	    WARN_ON_ONCE(kvm_set_msr(vcpu, MSR_CORE_PERF_GLOBAL_CTRL,
 				     vmcs12->guest_ia32_perf_global_ctrl))) {
@@ -6807,4 +6804,5 @@ struct kvm_x86_nested_ops vmx_nested_ops = {
 	.write_log_dirty = nested_vmx_write_pml_buffer,
 	.enable_evmcs = nested_enable_evmcs,
 	.get_evmcs_version = nested_get_evmcs_version,
+	.inject_page_fault = vmx_inject_page_fault_nested,
 };
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index da33d3a88a8d..1546a25a9307 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -746,6 +746,23 @@ void kvm_inject_page_fault(struct kvm_vcpu *vcpu, struct x86_exception *fault)
 }
 EXPORT_SYMBOL_GPL(kvm_inject_page_fault);
 
+void kvm_inject_page_fault_shadow(struct kvm_vcpu *vcpu,
+				  struct x86_exception *fault)
+{
+	/*
+	 * The core exception injection code is not able to combine
+	 * an exception with a vmexit; if a page fault happens while
+	 * a page fault exception is being delivered, the original
+	 * page fault would be changed incorrectly into a double
+	 * fault.  To work around this, #PF vmexits are injected
+	 * without going through kvm_queue_exception.
+	 */
+	if (unlikely(is_guest_mode(vcpu)))
+		kvm_x86_ops.nested_ops->inject_page_fault(vcpu, fault);
+	else
+		kvm_inject_page_fault(vcpu, fault);
+}
+
 bool kvm_inject_emulated_page_fault(struct kvm_vcpu *vcpu,
 				    struct x86_exception *fault)
 {
-- 
2.31.1


