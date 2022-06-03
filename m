Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18C0553C1E0
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 04:12:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240424AbiFCAr7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 20:47:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240260AbiFCApm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 20:45:42 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A51137A2C
        for <kvm@vger.kernel.org>; Thu,  2 Jun 2022 17:45:36 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id y1-20020a17090a390100b001e66bb0fcefso3256645pjb.0
        for <kvm@vger.kernel.org>; Thu, 02 Jun 2022 17:45:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=2NUR3kcMimAgoeykOecAs8DzqbcQZgV/1v20kj2SjLU=;
        b=sCwxBAMN4xJd13skRvWUcMuNbhrJd88mnTFAl1rmggkVjgXTJh5Am+wwIFxdRZtXbo
         eafPneBVQV90Q1b6xly36VW0tauLlmiMJ3PfjXWos798p66RuvXVldA/Z9tKPde39EeJ
         qcrPd8D30qgfo8irNRSDa8h1aiC8oDAk9b4QX4KZmus8c3QbNJFLQ9U+jYigXjSr7cRB
         1ddrR/OkMkenZAqnn3eZ1T82/QXV0H4BseB4sKyrbcoNS/7uDvbGSQ+Z7lco2mYK4rHF
         JlrVQ4RE56ipNkmQa6Iu02hx4YK9xdsekBzva4Oci+ayhCVW+Ret+Iz/Bml5ERGppv9q
         3TeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=2NUR3kcMimAgoeykOecAs8DzqbcQZgV/1v20kj2SjLU=;
        b=6uQ/WMXM2xEBZ+RCWR/b0D0lFXJ+JrULxkclP9FHCc0w/RmoJdA+kRmxiNjPEGDQ62
         HFMENZ44V0oqMhrYgLOcLNdx6Ln3S42qUyFKaVtlczUitrZFoKITA4svQkzwB8tlkUy2
         xK8fdnFfmcuEVgOaej2llo8O+kIe7Xi+wGwqnM3A+RrMUq0iDyhq35LkZptjDhF1joeG
         FmhWq6DZ4vQCx/Q7t2QT/CBEIZ0H9rbHUiD7ZHsW+SNiRFVmlPTC5WK1oqCUrlGL041S
         +mvpGL9rBWCwI9sPBPe3hD9s3YJmfuoc2Ieuc98Vk4bmKEX1i96ZjxUiopQ/awez+ZVW
         fc2Q==
X-Gm-Message-State: AOAM531IipgIhkBCb+POB6FTb029HwjFS2QT2CVhThrodnjwHUcMlIkS
        UhZv2cyULKvS0Sa42YsLwR8GU55YRZU=
X-Google-Smtp-Source: ABdhPJwI1uqYe5NEtYiWcYCdx2k56uWR2/DJ+HC9kV3hNdx0TaMroAKt0HrX1qZFTcvy3rgZ6mhH5Y4ouBg=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:d481:b0:162:4f1f:3f82 with SMTP id
 c1-20020a170902d48100b001624f1f3f82mr7464933plg.52.1654217135658; Thu, 02 Jun
 2022 17:45:35 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  3 Jun 2022 00:42:12 +0000
In-Reply-To: <20220603004331.1523888-1-seanjc@google.com>
Message-Id: <20220603004331.1523888-66-seanjc@google.com>
Mime-Version: 1.0
References: <20220603004331.1523888-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v2 065/144] KVM: selftests: Convert kvm_pv_test away from VCPU_ID
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

Convert kvm_pv_test to use vm_create_with_one_vcpu() and pass arounda
'struct kvm_vcpu' object instead of using a global VCPU_ID.

Opportunistically use vcpu_run() instead of _vcpu_run() with an open
coded assert that KVM_RUN succeeded.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/x86_64/kvm_pv_test.c        | 25 ++++++++-----------
 1 file changed, 10 insertions(+), 15 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/kvm_pv_test.c b/tools/testing/selftests/kvm/x86_64/kvm_pv_test.c
index 5eea3ac7958e..734e71739d33 100644
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
@@ -207,6 +201,7 @@ static void enter_guest(struct kvm_vm *vm)
 int main(void)
 {
 	struct kvm_cpuid2 *best;
+	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
 
 	if (!kvm_check_cap(KVM_CAP_ENFORCE_PV_FEATURE_CPUID)) {
@@ -214,18 +209,18 @@ int main(void)
 		exit(KSFT_SKIP);
 	}
 
-	vm = vm_create_default(VCPU_ID, 0, guest_main);
+	vm = vm_create_with_one_vcpu(&vcpu, guest_main);
 
-	vcpu_enable_cap(vm, VCPU_ID, KVM_CAP_ENFORCE_PV_FEATURE_CPUID, 1);
+	vcpu_enable_cap(vm, vcpu->id, KVM_CAP_ENFORCE_PV_FEATURE_CPUID, 1);
 
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
2.36.1.255.ge46751e96f-goog

