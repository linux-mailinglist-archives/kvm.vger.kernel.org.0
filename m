Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 198C14A82A0
	for <lists+kvm@lfdr.de>; Thu,  3 Feb 2022 11:46:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245105AbiBCKqo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Feb 2022 05:46:44 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:33645 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S245544AbiBCKqh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 3 Feb 2022 05:46:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643885197;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8v6kxyM9hKRtPGk0AXiTX1T8lCykPR/yoWwhfqN+jqY=;
        b=TPkXXyfyakxYZQEkfthmNlOAdejzjCfbjiR8q9hh1d20A4L6XWJnBHKcsodGE1g6ic2AOw
        3KJ+eXpGekkDVl8fnDuBLfcQEK0ZkhZSwTRSHh36fWDHKfvnYV0pi+a1uBvPenstc7HS4R
        10XFn1ZN/RcHyJvpqnZCA0Mb9XcuScU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-269-TixnJ339ObK_kpzDAxjCTg-1; Thu, 03 Feb 2022 05:46:34 -0500
X-MC-Unique: TixnJ339ObK_kpzDAxjCTg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C0199190A7A0;
        Thu,  3 Feb 2022 10:46:32 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.194.240])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DF4BF108B4;
        Thu,  3 Feb 2022 10:46:30 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 4/6] KVM: selftests: nSVM: Set up MSR-Bitmap for SVM guests
Date:   Thu,  3 Feb 2022 11:46:18 +0100
Message-Id: <20220203104620.277031-5-vkuznets@redhat.com>
In-Reply-To: <20220203104620.277031-1-vkuznets@redhat.com>
References: <20220203104620.277031-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Similar to VMX, allocate memory for MSR-Bitmap and fill in 'msrpm_base_pa'
in VMCB. To use it, tests will need to set INTERCEPT_MSR_PROT interception
along with the required bits in the MSR-Bitmap.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 tools/testing/selftests/kvm/include/x86_64/svm_util.h | 5 +++++
 tools/testing/selftests/kvm/lib/x86_64/svm.c          | 6 ++++++
 2 files changed, 11 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/x86_64/svm_util.h b/tools/testing/selftests/kvm/include/x86_64/svm_util.h
index 587fbe408b99..e23c8a3e8a66 100644
--- a/tools/testing/selftests/kvm/include/x86_64/svm_util.h
+++ b/tools/testing/selftests/kvm/include/x86_64/svm_util.h
@@ -28,6 +28,11 @@ struct svm_test_data {
 	struct vmcb_save_area *save_area; /* gva */
 	void *save_area_hva;
 	uint64_t save_area_gpa;
+
+	/* MSR-Bitmap */
+	void *msr; /* gva */
+	void *msr_hva;
+	uint64_t msr_gpa;
 };
 
 struct svm_test_data *vcpu_alloc_svm(struct kvm_vm *vm, vm_vaddr_t *p_svm_gva);
diff --git a/tools/testing/selftests/kvm/lib/x86_64/svm.c b/tools/testing/selftests/kvm/lib/x86_64/svm.c
index 0ebc03ce079c..736ee4a23df6 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/svm.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/svm.c
@@ -43,6 +43,11 @@ vcpu_alloc_svm(struct kvm_vm *vm, vm_vaddr_t *p_svm_gva)
 	svm->save_area_hva = addr_gva2hva(vm, (uintptr_t)svm->save_area);
 	svm->save_area_gpa = addr_gva2gpa(vm, (uintptr_t)svm->save_area);
 
+	svm->msr = (void *)vm_vaddr_alloc_page(vm);
+	svm->msr_hva = addr_gva2hva(vm, (uintptr_t)svm->msr);
+	svm->msr_gpa = addr_gva2gpa(vm, (uintptr_t)svm->msr);
+	memset(svm->msr_hva, 0, getpagesize());
+
 	*p_svm_gva = svm_gva;
 	return svm;
 }
@@ -106,6 +111,7 @@ void generic_svm_setup(struct svm_test_data *svm, void *guest_rip, void *guest_r
 	save->dbgctl = rdmsr(MSR_IA32_DEBUGCTLMSR);
 	ctrl->intercept = (1ULL << INTERCEPT_VMRUN) |
 				(1ULL << INTERCEPT_VMMCALL);
+	ctrl->msrpm_base_pa = svm->msr_gpa;
 
 	vmcb->save.rip = (u64)guest_rip;
 	vmcb->save.rsp = (u64)guest_rsp;
-- 
2.34.1

