Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69AF725C38D
	for <lists+kvm@lfdr.de>; Thu,  3 Sep 2020 16:53:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729333AbgICOxf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Sep 2020 10:53:35 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:31993 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729198AbgICOMD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 3 Sep 2020 10:12:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599142317;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=CT+BTbU04vXEyP9pdcH57nOtkyvU1kgH7PF3bGLUJr8=;
        b=IEUXwMWcXiIqHYPAIxe4CJSi7Eovn2LhMucfZrlKnWkjidGEHHygsX0Oln7ATTQj9qN+wZ
        qiqTPK0MWmY6IXIfoYdSQlQEmFiqys1I/T9PnrGjPLoPc4ryef2ioUCCIOUwGsqHLSbIxF
        3dGKMbnc5lBBG9Qe413Is9dsnynEsIw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-92-gECEWAk0PASqH66S4LxuRQ-1; Thu, 03 Sep 2020 10:11:56 -0400
X-MC-Unique: gECEWAk0PASqH66S4LxuRQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 61C0510051D3;
        Thu,  3 Sep 2020 14:11:54 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-114-36.ams2.redhat.com [10.36.114.36])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3160319C78;
        Thu,  3 Sep 2020 14:11:43 +0000 (UTC)
From:   Mohammed Gamal <mgamal@redhat.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     linux-kernel@vger.kernel.org, sean.j.christopherson@intel.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, Mohammed Gamal <mgamal@redhat.com>
Subject: [PATCH] KVM: x86: VMX: Make smaller physical guest address space support user-configurable
Date:   Thu,  3 Sep 2020 16:11:22 +0200
Message-Id: <20200903141122.72908-1-mgamal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch exposes allow_smaller_maxphyaddr to the user as a module parameter.

Since smaller physical address spaces are only supported on VMX, the parameter
is only exposed in the kvm_intel module.
Modifications to VMX page fault and EPT violation handling will depend on whether
that parameter is enabled.

Also disable support by default, and let the user decide if they want to enable
it.

Signed-off-by: Mohammed Gamal <mgamal@redhat.com>
---
 arch/x86/kvm/vmx/vmx.c | 15 ++++++---------
 arch/x86/kvm/vmx/vmx.h |  3 +++
 arch/x86/kvm/x86.c     |  2 +-
 3 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 819c185adf09..dc778c7b5a06 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -129,6 +129,9 @@ static bool __read_mostly enable_preemption_timer = 1;
 module_param_named(preemption_timer, enable_preemption_timer, bool, S_IRUGO);
 #endif
 
+extern bool __read_mostly allow_smaller_maxphyaddr;
+module_param(allow_smaller_maxphyaddr, bool, S_IRUGO | S_IWUSR);
+
 #define KVM_VM_CR0_ALWAYS_OFF (X86_CR0_NW | X86_CR0_CD)
 #define KVM_VM_CR0_ALWAYS_ON_UNRESTRICTED_GUEST X86_CR0_NE
 #define KVM_VM_CR0_ALWAYS_ON				\
@@ -4798,7 +4801,8 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
 
 	if (is_page_fault(intr_info)) {
 		cr2 = vmx_get_exit_qual(vcpu);
-		if (enable_ept && !vcpu->arch.apf.host_apf_flags) {
+		if (enable_ept && !vcpu->arch.apf.host_apf_flags
+			&& allow_smaller_maxphyaddr) {
 			/*
 			 * EPT will cause page fault only if we need to
 			 * detect illegal GPAs.
@@ -5331,7 +5335,7 @@ static int handle_ept_violation(struct kvm_vcpu *vcpu)
 	 * would also use advanced VM-exit information for EPT violations to
 	 * reconstruct the page fault error code.
 	 */
-	if (unlikely(kvm_mmu_is_illegal_gpa(vcpu, gpa)))
+	if (unlikely(kvm_mmu_is_illegal_gpa(vcpu, gpa)) && allow_smaller_maxphyaddr)
 		return kvm_emulate_instruction(vcpu, 0);
 
 	return kvm_mmu_page_fault(vcpu, gpa, error_code, NULL, 0);
@@ -8303,13 +8307,6 @@ static int __init vmx_init(void)
 #endif
 	vmx_check_vmcs12_offsets();
 
-	/*
-	 * Intel processors don't have problems with
-	 * GUEST_MAXPHYADDR < HOST_MAXPHYADDR so enable
-	 * it for VMX by default
-	 */
-	allow_smaller_maxphyaddr = true;
-
 	return 0;
 }
 module_init(vmx_init);
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 26175a4759fa..b859435efa2e 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -551,6 +551,9 @@ static inline bool vmx_has_waitpkg(struct vcpu_vmx *vmx)
 
 static inline bool vmx_need_pf_intercept(struct kvm_vcpu *vcpu)
 {
+	if (!allow_smaller_maxphyaddr)
+		return false;
+
 	return !enable_ept || cpuid_maxphyaddr(vcpu) < boot_cpu_data.x86_phys_bits;
 }
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d39d6cf1d473..982f1d73a884 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -188,7 +188,7 @@ static struct kvm_shared_msrs __percpu *shared_msrs;
 u64 __read_mostly host_efer;
 EXPORT_SYMBOL_GPL(host_efer);
 
-bool __read_mostly allow_smaller_maxphyaddr;
+bool __read_mostly allow_smaller_maxphyaddr = 0;
 EXPORT_SYMBOL_GPL(allow_smaller_maxphyaddr);
 
 static u64 __read_mostly host_xss;
-- 
2.26.2

