Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB16A1E8210
	for <lists+kvm@lfdr.de>; Fri, 29 May 2020 17:40:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728093AbgE2PkM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 May 2020 11:40:12 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:44524 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728015AbgE2Pjz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 29 May 2020 11:39:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590766794;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3iybW9pvfsjFGlyD1Po9ufsJAFkMntfpExVs230pXfo=;
        b=iheqtxdHIuwlslrEAAYWYqBPvyM7prr2sD220mVm3BTGHXkg4p6z9sGtQfKsuBPF7DKPn7
        edrOTQ7VTknMwmb3j+yDgNopbT7jdhz6JvzMalswToYyQNNTXxDQmCEEhjhS1/OnLJwza4
        vo8pQzoMv2VzViq+JBlxk3LGH5yf53k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-365-Ww42C1CgNiC2ZzIN6B039g-1; Fri, 29 May 2020 11:39:51 -0400
X-MC-Unique: Ww42C1CgNiC2ZzIN6B039g-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 75DF9107ACCA;
        Fri, 29 May 2020 15:39:50 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1F4D910013D4;
        Fri, 29 May 2020 15:39:50 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [PATCH 29/30] selftests: kvm: fix smm test on SVM
Date:   Fri, 29 May 2020 11:39:33 -0400
Message-Id: <20200529153934.11694-30-pbonzini@redhat.com>
In-Reply-To: <20200529153934.11694-1-pbonzini@redhat.com>
References: <20200529153934.11694-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Vitaly Kuznetsov <vkuznets@redhat.com>

KVM_CAP_NESTED_STATE is now supported for AMD too but smm test acts like
it is still Intel only.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Message-Id: <20200529130407.57176-2-vkuznets@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 tools/testing/selftests/kvm/x86_64/smm_test.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/smm_test.c b/tools/testing/selftests/kvm/x86_64/smm_test.c
index 8230b6bc6b8f..6f8f478b3ceb 100644
--- a/tools/testing/selftests/kvm/x86_64/smm_test.c
+++ b/tools/testing/selftests/kvm/x86_64/smm_test.c
@@ -17,6 +17,7 @@
 #include "kvm_util.h"
 
 #include "vmx.h"
+#include "svm_util.h"
 
 #define VCPU_ID	      1
 
@@ -58,7 +59,7 @@ void self_smi(void)
 	      APIC_DEST_SELF | APIC_INT_ASSERT | APIC_DM_SMI);
 }
 
-void guest_code(struct vmx_pages *vmx_pages)
+void guest_code(void *arg)
 {
 	uint64_t apicbase = rdmsr(MSR_IA32_APICBASE);
 
@@ -72,8 +73,11 @@ void guest_code(struct vmx_pages *vmx_pages)
 
 	sync_with_host(4);
 
-	if (vmx_pages) {
-		GUEST_ASSERT(prepare_for_vmx_operation(vmx_pages));
+	if (arg) {
+		if (cpu_has_svm())
+			generic_svm_setup(arg, NULL, NULL);
+		else
+			GUEST_ASSERT(prepare_for_vmx_operation(arg));
 
 		sync_with_host(5);
 
@@ -87,7 +91,7 @@ void guest_code(struct vmx_pages *vmx_pages)
 
 int main(int argc, char *argv[])
 {
-	vm_vaddr_t vmx_pages_gva = 0;
+	vm_vaddr_t nested_gva = 0;
 
 	struct kvm_regs regs;
 	struct kvm_vm *vm;
@@ -114,8 +118,11 @@ int main(int argc, char *argv[])
 	vcpu_set_msr(vm, VCPU_ID, MSR_IA32_SMBASE, SMRAM_GPA);
 
 	if (kvm_check_cap(KVM_CAP_NESTED_STATE)) {
-		vcpu_alloc_vmx(vm, &vmx_pages_gva);
-		vcpu_args_set(vm, VCPU_ID, 1, vmx_pages_gva);
+		if (kvm_get_supported_cpuid_entry(0x80000001)->ecx & CPUID_SVM)
+			vcpu_alloc_svm(vm, &nested_gva);
+		else
+			vcpu_alloc_vmx(vm, &nested_gva);
+		vcpu_args_set(vm, VCPU_ID, 1, nested_gva);
 	} else {
 		pr_info("will skip SMM test with VMX enabled\n");
 		vcpu_args_set(vm, VCPU_ID, 1, 0);
-- 
2.26.2


