Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B332F53C1D2
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 04:12:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241326AbiFCAu7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 20:50:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240272AbiFCAqQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 20:46:16 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A638E37A80
        for <kvm@vger.kernel.org>; Thu,  2 Jun 2022 17:45:59 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id i8-20020a170902c94800b0016517194819so3357389pla.7
        for <kvm@vger.kernel.org>; Thu, 02 Jun 2022 17:45:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=V6Qblx5lgVdv7/tV21pVO2NtMRka/tCwNSFbm8VV6yE=;
        b=R00heZFqrMSzNiiaEXBl9wdBZTmxrtlRD6RwP+t09rGRfCiFSVgtBk7RW7uW7Q8f36
         TUs3PeW1vlO2g6UEqK2NYjvLlJD4kFf6q4DCZ3fieSBrpP02a9JjMXja1Hw8vzHm4TOS
         9/bzW88qmcHL35bPUi/Kjgp5di12OUL3/NHFWtK9p9wgEOIc/QoaNPUgIcZH4g00Q0DK
         8RjPmI8qvUxC8IIYhcDfavPW0UYNLvlg7iZIgZojv8VZb35uFyfhL4nHbDCWDU/GrRvm
         xs/6r8Y/PagwDU3eshsAkRX/TwATxp8/ELjJ7M1CF8gKZ++9kc23wU4HG5XYQIMOF8bh
         t1Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=V6Qblx5lgVdv7/tV21pVO2NtMRka/tCwNSFbm8VV6yE=;
        b=WkBRBV3x+CJwYxX+5nkXl8uVAIZMhMN7Hvg5aceay0CvG4sGMek2kOciX/kJjwWkyi
         ZWGwl+juYzClvVTVsKaUM6D9BVAXYIJ25nOxd9LJBvvgcTN1/vB8DK+4Xa8Z5Inv2lL6
         BzvkP+YZpKsXujDwbFHzMLL8J1cfscZDUoS+ilQ+dk3SfOcIVUrC7PEUgwF5fOyuTLnX
         EJQt0H9mpqRFsbwqNQ5n8YH4tKzMb4qQYREKNvGgqqjYPK9t+sOf7aLr0fm7db3XQfHn
         TZ+gtOrwpCWuQ9iiufr7BnpD/s9N6WW8xbySj87SHNflfmFQgBCHT0VQ5/nKIjnn4XzF
         Dl8g==
X-Gm-Message-State: AOAM530t2Dx5dd+RkqPhZ5eCkckLfgyuXjmvNhQeFgBfO/b9i/neWo9Q
        3awFYC7qGEVPgavn4GU94KMXFrMgLP8=
X-Google-Smtp-Source: ABdhPJyhDwHVK1l2HyYJvdBbuN1ekPDgGWL89/uE/lWKIDd/weJnZTzpjcsjSCP+LHeigcwFL/YROXsqhsw=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a63:f5e:0:b0:3fd:23e1:e086 with SMTP id
 30-20020a630f5e000000b003fd23e1e086mr616477pgp.61.1654217159294; Thu, 02 Jun
 2022 17:45:59 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  3 Jun 2022 00:42:25 +0000
In-Reply-To: <20220603004331.1523888-1-seanjc@google.com>
Message-Id: <20220603004331.1523888-79-seanjc@google.com>
Mime-Version: 1.0
References: <20220603004331.1523888-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v2 078/144] KVM: selftests: Convert hyperv_clock away from VCPU_ID
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Oliver Upton <oupton@google.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Convert hyperv_clock to use vm_create_with_one_vcpu() and pass around a
'struct kvm_vcpu' object instead of using a global VCPU_ID.

Opportunistically use vcpu_run() instead of _vcpu_run() with an open
coded assert that KVM_RUN succeeded.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/x86_64/hyperv_clock.c       | 25 +++++++++----------
 1 file changed, 12 insertions(+), 13 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_clock.c b/tools/testing/selftests/kvm/x86_64/hyperv_clock.c
index e0b2bb1339b1..43584ddc4de0 100644
--- a/tools/testing/selftests/kvm/x86_64/hyperv_clock.c
+++ b/tools/testing/selftests/kvm/x86_64/hyperv_clock.c
@@ -171,22 +171,20 @@ static void guest_main(struct ms_hyperv_tsc_page *tsc_page, vm_paddr_t tsc_page_
 	GUEST_DONE();
 }
 
-#define VCPU_ID 0
-
-static void host_check_tsc_msr_rdtsc(struct kvm_vm *vm)
+static void host_check_tsc_msr_rdtsc(struct kvm_vcpu *vcpu)
 {
 	u64 tsc_freq, r1, r2, t1, t2;
 	s64 delta_ns;
 
-	tsc_freq = vcpu_get_msr(vm, VCPU_ID, HV_X64_MSR_TSC_FREQUENCY);
+	tsc_freq = vcpu_get_msr(vcpu->vm, vcpu->id, HV_X64_MSR_TSC_FREQUENCY);
 	TEST_ASSERT(tsc_freq > 0, "TSC frequency must be nonzero");
 
 	/* First, check MSR-based clocksource */
 	r1 = rdtsc();
-	t1 = vcpu_get_msr(vm, VCPU_ID, HV_X64_MSR_TIME_REF_COUNT);
+	t1 = vcpu_get_msr(vcpu->vm, vcpu->id, HV_X64_MSR_TIME_REF_COUNT);
 	nop_loop();
 	r2 = rdtsc();
-	t2 = vcpu_get_msr(vm, VCPU_ID, HV_X64_MSR_TIME_REF_COUNT);
+	t2 = vcpu_get_msr(vcpu->vm, vcpu->id, HV_X64_MSR_TIME_REF_COUNT);
 
 	TEST_ASSERT(t2 > t1, "Time reference MSR is not monotonic (%ld <= %ld)", t1, t2);
 
@@ -203,33 +201,34 @@ static void host_check_tsc_msr_rdtsc(struct kvm_vm *vm)
 
 int main(void)
 {
+	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
 	struct kvm_run *run;
 	struct ucall uc;
 	vm_vaddr_t tsc_page_gva;
 	int stage;
 
-	vm = vm_create_default(VCPU_ID, 0, guest_main);
-	run = vcpu_state(vm, VCPU_ID);
+	vm = vm_create_with_one_vcpu(&vcpu, guest_main);
+	run = vcpu->run;
 
-	vcpu_set_hv_cpuid(vm, VCPU_ID);
+	vcpu_set_hv_cpuid(vm, vcpu->id);
 
 	tsc_page_gva = vm_vaddr_alloc_page(vm);
 	memset(addr_gva2hva(vm, tsc_page_gva), 0x0, getpagesize());
 	TEST_ASSERT((addr_gva2gpa(vm, tsc_page_gva) & (getpagesize() - 1)) == 0,
 		"TSC page has to be page aligned\n");
-	vcpu_args_set(vm, VCPU_ID, 2, tsc_page_gva, addr_gva2gpa(vm, tsc_page_gva));
+	vcpu_args_set(vm, vcpu->id, 2, tsc_page_gva, addr_gva2gpa(vm, tsc_page_gva));
 
-	host_check_tsc_msr_rdtsc(vm);
+	host_check_tsc_msr_rdtsc(vcpu);
 
 	for (stage = 1;; stage++) {
-		_vcpu_run(vm, VCPU_ID);
+		vcpu_run(vm, vcpu->id);
 		TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
 			    "Stage %d: unexpected exit reason: %u (%s),\n",
 			    stage, run->exit_reason,
 			    exit_reason_str(run->exit_reason));
 
-		switch (get_ucall(vm, VCPU_ID, &uc)) {
+		switch (get_ucall(vm, vcpu->id, &uc)) {
 		case UCALL_ABORT:
 			TEST_FAIL("%s at %s:%ld", (const char *)uc.args[0],
 				  __FILE__, uc.args[1]);
-- 
2.36.1.255.ge46751e96f-goog

