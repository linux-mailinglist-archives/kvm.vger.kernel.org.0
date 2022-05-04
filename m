Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C8BF51B365
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 01:27:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379300AbiEDW4D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 18:56:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379263AbiEDWyz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 18:54:55 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB38253E2D
        for <kvm@vger.kernel.org>; Wed,  4 May 2022 15:51:09 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id l5-20020a170902ec0500b0015cf1cfa4eeso1366765pld.17
        for <kvm@vger.kernel.org>; Wed, 04 May 2022 15:51:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=bMvlXr4HK274DGrq7E1ZqyuDr7AgFq7Bi5INTr4PZKw=;
        b=YK+tS9LfZmGLA7Bho21OiBw8rKzeNiEj4sY+1i0gx0vFeikcRT8pP7zPEWgDb2YpNB
         8p4wE9suyOi9romXiKEPfSalzjTia7IWT2d8bLR1gmIJof3ldvg08j6HGJSi46HjG28+
         NiBdYv3hO4Gc8l8HMmt3XPK05j3JUqUd6oRzB9cqJfoOAq3P2eM3HdeRm/K3e1ECMDbk
         wDDk7Y9r/VWn+oRBivt27nvLky444c5npoefpgCRL7HcuBjYrLRKLOVMwpfn95KZNROZ
         0E3q/8WEcn9QhnyTxg+SjQ40A6BIoWe/FfzgYiAxc69Jabm/qyfAFZHj82usnvh3py7z
         ANMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=bMvlXr4HK274DGrq7E1ZqyuDr7AgFq7Bi5INTr4PZKw=;
        b=RH8o9SLWW2Vr9rkFMswto7QNhurh4yP7BrYLdYhH+PkjdIoqWLy/E6PYEc+c2UreA+
         ow1iKSsF5wcvD7VQGpgRYCo8Lz94FxdCV3dRE4hDdrF13aHZwpAyqUd/jwlQyAjos170
         Tg2uBUDag4tmS9eBBdxOr9uwAI9D26+3QkVMH09aqZCL9twCNf4jMPC7Vlpr/0pb3BaD
         1RWeeazSv5vgtTEWGQIqG3q2XhqoyEQiGtVwEqoXmr3+ueqNhzFiJkVFZEYBz+f1cS5V
         X8KL2PMMYUTy5PAhC1LUYA51c6gAiWGRTrFtvWXKSFfdN7Q9ZMQdb5CULfioC2xTo3W+
         cLnQ==
X-Gm-Message-State: AOAM533vYv12KUfw+Xhcff4ZoYHOThb24Agx43bOzU06kLGBxPoocs9K
        OsGiLzldoUt0lfTlmMrcedOcc+KukaY=
X-Google-Smtp-Source: ABdhPJy68rQWjft05zs1OiHxG8HTloycRQW5Q0CXSL/URVnTP56SDUr26ibFxiI58mHhF1NMcPx5QxlWvlM=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a62:3848:0:b0:50d:376e:57ed with SMTP id
 f69-20020a623848000000b0050d376e57edmr22824042pfa.71.1651704669140; Wed, 04
 May 2022 15:51:09 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  4 May 2022 22:48:03 +0000
In-Reply-To: <20220504224914.1654036-1-seanjc@google.com>
Message-Id: <20220504224914.1654036-58-seanjc@google.com>
Mime-Version: 1.0
References: <20220504224914.1654036-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH 057/128] KVM: selftests: Convert kvm_pv_test away from VCPU_ID
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
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Convert kvm_pv_test to use vm_create_with_one_vcpu() and pass arounda
'struct kvm_vcpu' object instead of using a global VCPU_ID.

Opportunistically use vcpu_run() instead of _vcpu_run() with an open
coded assert that KVM_RUN succeeded.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/x86_64/kvm_pv_test.c        | 25 ++++++++-----------
 1 file changed, 10 insertions(+), 15 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/kvm_pv_test.c b/tools/testing/selftests/kvm/x86_64/kvm_pv_test.c
index 04ed975662c9..cce9016e31a7 100644
--- a/tools/testing/selftests/kvm/x86_64/kvm_pv_test.c
+++ b/tools/testing/selftests/kvm/x86_64/kvm_pv_test.c
@@ -171,24 +171,18 @@ static void handle_abort(struct ucall *uc)
 		  __FILE__, uc->args[1]);
 }
 
-#define VCPU_ID 0
-
-static void enter_guest(struct kvm_vm *vm)
+static void enter_guest(struct kvm_vcpu *vcpu)
 {
-	struct kvm_run *run;
+	struct kvm_run *run = vcpu->run;
 	struct ucall uc;
-	int r;
-
-	run = vcpu_state(vm, VCPU_ID);
 
 	while (true) {
-		r = _vcpu_run(vm, VCPU_ID);
-		TEST_ASSERT(!r, "vcpu_run failed: %d\n", r);
+		vcpu_run(vcpu->vm, vcpu->id);
 		TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
 			    "unexpected exit reason: %u (%s)",
 			    run->exit_reason, exit_reason_str(run->exit_reason));
 
-		switch (get_ucall(vm, VCPU_ID, &uc)) {
+		switch (get_ucall(vcpu->vm, vcpu->id, &uc)) {
 		case UCALL_PR_MSR:
 			pr_msr(&uc);
 			break;
@@ -208,6 +202,7 @@ int main(void)
 {
 	struct kvm_enable_cap cap = {0};
 	struct kvm_cpuid2 *best;
+	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
 
 	if (!kvm_check_cap(KVM_CAP_ENFORCE_PV_FEATURE_CPUID)) {
@@ -215,20 +210,20 @@ int main(void)
 		exit(KSFT_SKIP);
 	}
 
-	vm = vm_create_default(VCPU_ID, 0, guest_main);
+	vm = vm_create_with_one_vcpu(&vcpu, guest_main);
 
 	cap.cap = KVM_CAP_ENFORCE_PV_FEATURE_CPUID;
 	cap.args[0] = 1;
-	vcpu_enable_cap(vm, VCPU_ID, &cap);
+	vcpu_enable_cap(vm, vcpu->id, &cap);
 
 	best = kvm_get_supported_cpuid();
 	clear_kvm_cpuid_features(best);
-	vcpu_set_cpuid(vm, VCPU_ID, best);
+	vcpu_set_cpuid(vm, vcpu->id, best);
 
 	vm_init_descriptor_tables(vm);
-	vcpu_init_descriptor_tables(vm, VCPU_ID);
+	vcpu_init_descriptor_tables(vm, vcpu->id);
 	vm_install_exception_handler(vm, GP_VECTOR, guest_gp_handler);
 
-	enter_guest(vm);
+	enter_guest(vcpu);
 	kvm_vm_free(vm);
 }
-- 
2.36.0.464.gb9c8b46e94-goog

