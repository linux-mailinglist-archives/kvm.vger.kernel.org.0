Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 322AB51B34F
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 01:27:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379684AbiEDW5W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 18:57:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379239AbiEDWzy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 18:55:54 -0400
Received: from mail-oo1-xc49.google.com (mail-oo1-xc49.google.com [IPv6:2607:f8b0:4864:20::c49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2137054BFD
        for <kvm@vger.kernel.org>; Wed,  4 May 2022 15:51:33 -0700 (PDT)
Received: by mail-oo1-xc49.google.com with SMTP id t19-20020a4a96d3000000b003295d7ce159so1242118ooi.11
        for <kvm@vger.kernel.org>; Wed, 04 May 2022 15:51:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=KiE9VficpCeN1xBVdUN8xYll0C4HLuJFd4x1wesa6do=;
        b=RR06S68mHbetxo2/DFm9fevn41ldDuSZzFIqQLw3luNwdEAeyVrZbWkd4295+phqwo
         zuWTiWktZRYLy1NzIDnkeeQNPvRmX/dihUUNC3FybgUvKuRkBaoSDI83eMKomc2MQOrO
         TFVKi7CcYGQ9Oe25D7B26dz9I8/odtVhXmuNRho0rQHGz5LiB+6xmZS3+4WNsDq0tTfY
         ZinvBHjG2Hv4w7Wk0WSeTR4yOOrBoUyAXOF7knimUSprtXe1wtpvx3Fk00t7kqiG6o+N
         i6yalRzQjGKAFffYBMmVfB+7i2QC0DBm9REMmycPmq29wbOBv8u9C0jUawysWhu04qVC
         VdCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=KiE9VficpCeN1xBVdUN8xYll0C4HLuJFd4x1wesa6do=;
        b=oP4mHxGzlmJYp1Rijg5Do3Hy1j1STgfHyPifjL8ou1t76cVVKTnCitS8VAUofB/SfY
         rTzGc0mTmBZXzMccYEzmdDzC4GPlN6p6cDRH1ASBvzWVsieq8ffVGigYB+NIIRS+JXtr
         s20oEvcWJO1N+PmcxWIpyLb9YW7sO6UtdVekWR6G+NZNgZOoqY+EyXFnFMBAzLojPKWB
         e1h5W5jfl/94KZOtotzThgBMTiFAqW1iBIqF+k+ul+9HUslN5pypx+QuF2ZMOeWLW7p6
         cTbl65Xh4EQKvedyHZ3iDIsXAC+GfV/OJbAUdY0ngqQ7FPAKHkSbflP/9j6VirePnyw0
         nwcg==
X-Gm-Message-State: AOAM531J9CglRaCmvRKCXsoTUOZm8Vstkbmwn3EAQpzpsxqv1JRzPmf9
        nygYmxlZCeSp4kif8vfjj+joWlyUvx0=
X-Google-Smtp-Source: ABdhPJxnrpq5WxtjmZ6u+D0kWIimk3PB8r/vORqJp7aU2tk7sgFX4X0l+1lPevztzsqswm3eWOEIXvXDCdQ=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6870:32d6:b0:e3:6e1a:e56b with SMTP id
 r22-20020a05687032d600b000e36e1ae56bmr904389oac.206.1651704692371; Wed, 04
 May 2022 15:51:32 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  4 May 2022 22:48:16 +0000
In-Reply-To: <20220504224914.1654036-1-seanjc@google.com>
Message-Id: <20220504224914.1654036-71-seanjc@google.com>
Mime-Version: 1.0
References: <20220504224914.1654036-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH 070/128] KVM: selftests: Convert hyperv_clock away from VCPU_ID
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Oliver Upton <oupton@google.com>,
        Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
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
2.36.0.464.gb9c8b46e94-goog

