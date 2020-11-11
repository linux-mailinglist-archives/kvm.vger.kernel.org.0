Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD87E2AF094
	for <lists+kvm@lfdr.de>; Wed, 11 Nov 2020 13:27:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726753AbgKKM1a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Nov 2020 07:27:30 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44773 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726685AbgKKM1Y (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 11 Nov 2020 07:27:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605097643;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Hof5lLh9Kx30J4SqBmN2dynh8t7ZWpqJU8bVNw6v7uc=;
        b=SrrsRSIXxkeygymUQkjQRCzTJ6GtmuB2Q2i3USXguKU1OTslNRbdjOsVKaCoQDkyLLBGpv
        HS5i6rOiq+jdQMmpmb86p8KXl5y/E3c19daAZQ0aWu0R1mwXh0GHAAP66aXPZj2jeqerO1
        +qqvF+8uzjbCczHmnLhjt1Fz7CyyqHs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-557-Xa_L8bkJNR2FsSCh571csg-1; Wed, 11 Nov 2020 07:27:22 -0500
X-MC-Unique: Xa_L8bkJNR2FsSCh571csg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B65A1805EF7;
        Wed, 11 Nov 2020 12:27:20 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.193.216])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D723D5DA6A;
        Wed, 11 Nov 2020 12:27:18 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        bgardon@google.com, peterx@redhat.com
Subject: [PATCH v2 11/11] KVM: selftests: Make test skipping consistent
Date:   Wed, 11 Nov 2020 13:26:36 +0100
Message-Id: <20201111122636.73346-12-drjones@redhat.com>
In-Reply-To: <20201111122636.73346-1-drjones@redhat.com>
References: <20201111122636.73346-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 tools/testing/selftests/kvm/x86_64/kvm_pv_test.c   |  4 ++--
 tools/testing/selftests/kvm/x86_64/user_msr_test.c |  6 +++++-
 .../kvm/x86_64/vmx_preemption_timer_test.c         | 14 +++++++-------
 3 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/kvm_pv_test.c b/tools/testing/selftests/kvm/x86_64/kvm_pv_test.c
index b10a27485bad..732b244d6956 100644
--- a/tools/testing/selftests/kvm/x86_64/kvm_pv_test.c
+++ b/tools/testing/selftests/kvm/x86_64/kvm_pv_test.c
@@ -211,8 +211,8 @@ int main(void)
 	struct kvm_vm *vm;
 
 	if (!kvm_check_cap(KVM_CAP_ENFORCE_PV_FEATURE_CPUID)) {
-		pr_info("will skip kvm paravirt restriction tests.\n");
-		return 0;
+		print_skip("KVM_CAP_ENFORCE_PV_FEATURE_CPUID not supported");
+		exit(KSFT_SKIP);
 	}
 
 	vm = vm_create_default(VCPU_ID, 0, guest_main);
diff --git a/tools/testing/selftests/kvm/x86_64/user_msr_test.c b/tools/testing/selftests/kvm/x86_64/user_msr_test.c
index 013766547084..fe88b98908ee 100644
--- a/tools/testing/selftests/kvm/x86_64/user_msr_test.c
+++ b/tools/testing/selftests/kvm/x86_64/user_msr_test.c
@@ -208,7 +208,11 @@ int main(int argc, char *argv[])
 	run = vcpu_state(vm, VCPU_ID);
 
 	rc = kvm_check_cap(KVM_CAP_X86_USER_SPACE_MSR);
-	TEST_ASSERT(rc, "KVM_CAP_X86_USER_SPACE_MSR is available");
+	if (!rc) {
+		print_skip("KVM_CAP_X86_USER_SPACE_MSR not supported");
+		exit(KSFT_SKIP);
+	}
+
 	vm_enable_cap(vm, &cap);
 
 	rc = kvm_check_cap(KVM_CAP_X86_MSR_FILTER);
diff --git a/tools/testing/selftests/kvm/x86_64/vmx_preemption_timer_test.c b/tools/testing/selftests/kvm/x86_64/vmx_preemption_timer_test.c
index 150c98263273..a07480aed397 100644
--- a/tools/testing/selftests/kvm/x86_64/vmx_preemption_timer_test.c
+++ b/tools/testing/selftests/kvm/x86_64/vmx_preemption_timer_test.c
@@ -169,19 +169,19 @@ int main(int argc, char *argv[])
 	 */
 	nested_vmx_check_supported();
 
+	if (!kvm_check_cap(KVM_CAP_NESTED_STATE)) {
+		print_skip("KVM_CAP_NESTED_STATE not supported");
+		exit(KSFT_SKIP);
+	}
+
 	/* Create VM */
 	vm = vm_create_default(VCPU_ID, 0, guest_code);
 	run = vcpu_state(vm, VCPU_ID);
 
 	vcpu_regs_get(vm, VCPU_ID, &regs1);
 
-	if (kvm_check_cap(KVM_CAP_NESTED_STATE)) {
-		vcpu_alloc_vmx(vm, &vmx_pages_gva);
-		vcpu_args_set(vm, VCPU_ID, 1, vmx_pages_gva);
-	} else {
-		pr_info("will skip vmx preemption timer checks\n");
-		goto done;
-	}
+	vcpu_alloc_vmx(vm, &vmx_pages_gva);
+	vcpu_args_set(vm, VCPU_ID, 1, vmx_pages_gva);
 
 	for (stage = 1;; stage++) {
 		_vcpu_run(vm, VCPU_ID);
-- 
2.26.2

