Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E28E1459469
	for <lists+kvm@lfdr.de>; Mon, 22 Nov 2021 18:58:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233748AbhKVSBl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Nov 2021 13:01:41 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:33857 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239764AbhKVSBk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 22 Nov 2021 13:01:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637603913;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Hazvb/oLnE0S4p00gZpiwfDjAfE/nO71NZErwwXCP8Q=;
        b=XVvI6n+Af+4VitcxVnyJr+WWi9/xATgJ9PjWoO79F/36t6K4FhW8X43hkFAierMmsku4ym
        mmBUPhzwmOgJhFGBdhdxK3a+4TKWIPBf55sYZBiBwCohYTVgVcC32iODWBYkaJ9z3G3fpx
        lHeOIjWFg1FXZ1MwT0r+BczcV8Q7n4s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-238-evlMqVPhOqi_OZ820b3geA-1; Mon, 22 Nov 2021 12:58:30 -0500
X-MC-Unique: evlMqVPhOqi_OZ820b3geA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 00C981023F4E;
        Mon, 22 Nov 2021 17:58:29 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.192.236])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 68A7B1017CE5;
        Mon, 22 Nov 2021 17:58:22 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] KVM: selftests: Avoid KVM_SET_CPUID2 after KVM_RUN in hyperv_features test
Date:   Mon, 22 Nov 2021 18:58:17 +0100
Message-Id: <20211122175818.608220-2-vkuznets@redhat.com>
In-Reply-To: <20211122175818.608220-1-vkuznets@redhat.com>
References: <20211122175818.608220-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

hyperv_features's sole purpose is to test access to various Hyper-V MSRs
and hypercalls with different CPUID data. As KVM_SET_CPUID2 after KVM_RUN
is deprecated and soon-to-be forbidden, avoid it by re-creating test VM
for each sub-test.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 .../selftests/kvm/x86_64/hyperv_features.c    | 140 +++++++++---------
 1 file changed, 71 insertions(+), 69 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_features.c b/tools/testing/selftests/kvm/x86_64/hyperv_features.c
index 91d88aaa9899..672915ce73d8 100644
--- a/tools/testing/selftests/kvm/x86_64/hyperv_features.c
+++ b/tools/testing/selftests/kvm/x86_64/hyperv_features.c
@@ -165,10 +165,10 @@ static void hv_set_cpuid(struct kvm_vm *vm, struct kvm_cpuid2 *cpuid,
 	vcpu_set_cpuid(vm, VCPU_ID, cpuid);
 }
 
-static void guest_test_msrs_access(struct kvm_vm *vm, struct msr_data *msr,
-				   struct kvm_cpuid2 *best)
+static void guest_test_msrs_access(void)
 {
 	struct kvm_run *run;
+	struct kvm_vm *vm;
 	struct ucall uc;
 	int stage = 0, r;
 	struct kvm_cpuid_entry2 feat = {
@@ -180,11 +180,34 @@ static void guest_test_msrs_access(struct kvm_vm *vm, struct msr_data *msr,
 	struct kvm_cpuid_entry2 dbg = {
 		.function = HYPERV_CPUID_SYNDBG_PLATFORM_CAPABILITIES
 	};
-	struct kvm_enable_cap cap = {0};
-
-	run = vcpu_state(vm, VCPU_ID);
+	struct kvm_cpuid2 *best;
+	vm_vaddr_t msr_gva;
+	struct kvm_enable_cap cap = {
+		.cap = KVM_CAP_HYPERV_ENFORCE_CPUID,
+		.args = {1}
+	};
+	struct msr_data *msr;
 
 	while (true) {
+		vm = vm_create_default(VCPU_ID, 0, guest_msr);
+
+		msr_gva = vm_vaddr_alloc_page(vm);
+		memset(addr_gva2hva(vm, msr_gva), 0x0, getpagesize());
+		msr = addr_gva2hva(vm, msr_gva);
+
+		vcpu_args_set(vm, VCPU_ID, 1, msr_gva);
+		vcpu_enable_cap(vm, VCPU_ID, &cap);
+
+		vcpu_set_hv_cpuid(vm, VCPU_ID);
+
+		best = kvm_get_supported_hv_cpuid();
+
+		vm_init_descriptor_tables(vm);
+		vcpu_init_descriptor_tables(vm, VCPU_ID);
+		vm_install_exception_handler(vm, GP_VECTOR, guest_gp_handler);
+
+		run = vcpu_state(vm, VCPU_ID);
+
 		switch (stage) {
 		case 0:
 			/*
@@ -315,6 +338,7 @@ static void guest_test_msrs_access(struct kvm_vm *vm, struct msr_data *msr,
 			 * capability enabled and guest visible CPUID bit unset.
 			 */
 			cap.cap = KVM_CAP_HYPERV_SYNIC2;
+			cap.args[0] = 0;
 			vcpu_enable_cap(vm, VCPU_ID, &cap);
 			break;
 		case 22:
@@ -461,9 +485,9 @@ static void guest_test_msrs_access(struct kvm_vm *vm, struct msr_data *msr,
 
 		switch (get_ucall(vm, VCPU_ID, &uc)) {
 		case UCALL_SYNC:
-			TEST_ASSERT(uc.args[1] == stage,
-				    "Unexpected stage: %ld (%d expected)\n",
-				    uc.args[1], stage);
+			TEST_ASSERT(uc.args[1] == 0,
+				    "Unexpected stage: %ld (0 expected)\n",
+				    uc.args[1]);
 			break;
 		case UCALL_ABORT:
 			TEST_FAIL("%s at %s:%ld", (const char *)uc.args[0],
@@ -474,13 +498,14 @@ static void guest_test_msrs_access(struct kvm_vm *vm, struct msr_data *msr,
 		}
 
 		stage++;
+		kvm_vm_free(vm);
 	}
 }
 
-static void guest_test_hcalls_access(struct kvm_vm *vm, struct hcall_data *hcall,
-				     void *input, void *output, struct kvm_cpuid2 *best)
+static void guest_test_hcalls_access(void)
 {
 	struct kvm_run *run;
+	struct kvm_vm *vm;
 	struct ucall uc;
 	int stage = 0, r;
 	struct kvm_cpuid_entry2 feat = {
@@ -493,10 +518,38 @@ static void guest_test_hcalls_access(struct kvm_vm *vm, struct hcall_data *hcall
 	struct kvm_cpuid_entry2 dbg = {
 		.function = HYPERV_CPUID_SYNDBG_PLATFORM_CAPABILITIES
 	};
-
-	run = vcpu_state(vm, VCPU_ID);
+	struct kvm_enable_cap cap = {
+		.cap = KVM_CAP_HYPERV_ENFORCE_CPUID,
+		.args = {1}
+	};
+	vm_vaddr_t hcall_page, hcall_params;
+	struct hcall_data *hcall;
+	struct kvm_cpuid2 *best;
 
 	while (true) {
+		vm = vm_create_default(VCPU_ID, 0, guest_hcall);
+
+		vm_init_descriptor_tables(vm);
+		vcpu_init_descriptor_tables(vm, VCPU_ID);
+		vm_install_exception_handler(vm, UD_VECTOR, guest_ud_handler);
+
+		/* Hypercall input/output */
+		hcall_page = vm_vaddr_alloc_pages(vm, 2);
+		hcall = addr_gva2hva(vm, hcall_page);
+		memset(addr_gva2hva(vm, hcall_page), 0x0, 2 * getpagesize());
+
+		hcall_params = vm_vaddr_alloc_page(vm);
+		memset(addr_gva2hva(vm, hcall_params), 0x0, getpagesize());
+
+		vcpu_args_set(vm, VCPU_ID, 2, addr_gva2gpa(vm, hcall_page), hcall_params);
+		vcpu_enable_cap(vm, VCPU_ID, &cap);
+
+		vcpu_set_hv_cpuid(vm, VCPU_ID);
+
+		best = kvm_get_supported_hv_cpuid();
+
+		run = vcpu_state(vm, VCPU_ID);
+
 		switch (stage) {
 		case 0:
 			hcall->control = 0xdeadbeef;
@@ -606,9 +659,9 @@ static void guest_test_hcalls_access(struct kvm_vm *vm, struct hcall_data *hcall
 
 		switch (get_ucall(vm, VCPU_ID, &uc)) {
 		case UCALL_SYNC:
-			TEST_ASSERT(uc.args[1] == stage,
-				    "Unexpected stage: %ld (%d expected)\n",
-				    uc.args[1], stage);
+			TEST_ASSERT(uc.args[1] == 0,
+				    "Unexpected stage: %ld (0 expected)\n",
+				    uc.args[1]);
 			break;
 		case UCALL_ABORT:
 			TEST_FAIL("%s at %s:%ld", (const char *)uc.args[0],
@@ -619,66 +672,15 @@ static void guest_test_hcalls_access(struct kvm_vm *vm, struct hcall_data *hcall
 		}
 
 		stage++;
+		kvm_vm_free(vm);
 	}
 }
 
 int main(void)
 {
-	struct kvm_cpuid2 *best;
-	struct kvm_vm *vm;
-	vm_vaddr_t msr_gva, hcall_page, hcall_params;
-	struct kvm_enable_cap cap = {
-		.cap = KVM_CAP_HYPERV_ENFORCE_CPUID,
-		.args = {1}
-	};
-
-	/* Test MSRs */
-	vm = vm_create_default(VCPU_ID, 0, guest_msr);
-
-	msr_gva = vm_vaddr_alloc_page(vm);
-	memset(addr_gva2hva(vm, msr_gva), 0x0, getpagesize());
-	vcpu_args_set(vm, VCPU_ID, 1, msr_gva);
-	vcpu_enable_cap(vm, VCPU_ID, &cap);
-
-	vcpu_set_hv_cpuid(vm, VCPU_ID);
-
-	best = kvm_get_supported_hv_cpuid();
-
-	vm_init_descriptor_tables(vm);
-	vcpu_init_descriptor_tables(vm, VCPU_ID);
-	vm_install_exception_handler(vm, GP_VECTOR, guest_gp_handler);
-
 	pr_info("Testing access to Hyper-V specific MSRs\n");
-	guest_test_msrs_access(vm, addr_gva2hva(vm, msr_gva),
-			       best);
-	kvm_vm_free(vm);
-
-	/* Test hypercalls */
-	vm = vm_create_default(VCPU_ID, 0, guest_hcall);
-
-	vm_init_descriptor_tables(vm);
-	vcpu_init_descriptor_tables(vm, VCPU_ID);
-	vm_install_exception_handler(vm, UD_VECTOR, guest_ud_handler);
-
-	/* Hypercall input/output */
-	hcall_page = vm_vaddr_alloc_pages(vm, 2);
-	memset(addr_gva2hva(vm, hcall_page), 0x0, 2 * getpagesize());
-
-	hcall_params = vm_vaddr_alloc_page(vm);
-	memset(addr_gva2hva(vm, hcall_params), 0x0, getpagesize());
-
-	vcpu_args_set(vm, VCPU_ID, 2, addr_gva2gpa(vm, hcall_page), hcall_params);
-	vcpu_enable_cap(vm, VCPU_ID, &cap);
-
-	vcpu_set_hv_cpuid(vm, VCPU_ID);
-
-	best = kvm_get_supported_hv_cpuid();
+	guest_test_msrs_access();
 
 	pr_info("Testing access to Hyper-V hypercalls\n");
-	guest_test_hcalls_access(vm, addr_gva2hva(vm, hcall_params),
-				 addr_gva2hva(vm, hcall_page),
-				 addr_gva2hva(vm, hcall_page) + getpagesize(),
-				 best);
-
-	kvm_vm_free(vm);
+	guest_test_hcalls_access();
 }
-- 
2.33.1

