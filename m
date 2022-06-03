Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84F5D53C273
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 04:13:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240077AbiFCAod (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 20:44:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239998AbiFCAoD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 20:44:03 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 941043464B
        for <kvm@vger.kernel.org>; Thu,  2 Jun 2022 17:43:56 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id c4-20020a170902d48400b001640bfb2b4fso3459609plg.20
        for <kvm@vger.kernel.org>; Thu, 02 Jun 2022 17:43:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=aE6X5aIfjmoZMi1iYEAJcoIlasrtQaqLVj89AeYY4Cw=;
        b=fpAMkds5U0PawHg7Nz1aRzfBl76q66Z6oRmBVphY6V79rJfPEj8u01Rt4f9jhxDVSz
         Lo3Xr5Mk0uV8SF7Tvbn3NWGAf5Zih/jLLsaxRzdY8fgCuypix60YO8u6YFLoQu4xaAuJ
         mF6b4i8YQr3L5vI5e7MAwon/z6kqFQASjjfZkKXzaZGM1IiA8OW1lWqQ8kbl0ur0m2Pz
         UPjKQQ80plgrYHwTAoYkduOMRdwTjPqGz1EAsbSZAgmG1g4Vg8xEXxIc0nDu98ODVRvD
         7FeA6JydHBLp0swoKuTRzZRzi5/giPbF7LpvJ3kc1a8dXND/bkS7YKOLBZalIFeZEjdK
         W+bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=aE6X5aIfjmoZMi1iYEAJcoIlasrtQaqLVj89AeYY4Cw=;
        b=SImAJ60VEIZdeL+YDALOw+x7AceTnn3N+JdtRy+9GDoH+LXwwKR4mGa+fj8QOanzss
         /XIVxEXYzjp2nvSUBMmJeoMtTJ2I+51j5FeunnqzACu3OqaQ6vMis7BguNVFAevhXT8d
         ck9ZaS7vQbnEccYLCTp5r1Tc6kxnCCNnCI4WvfaxzQd6GhkPJBgAcSmuBwNhJ/Ou90m8
         n6s9jv6/eSVpGd+XW5KSdDHWBX+i3z75Va1OJxaJh5HFiuUDXgwiG6QHZ8VU4XR5nSJ7
         ggpdHkKymu8hseaISFry1Q1Yf7W4tnCNj4mJ2fyCKx1mzkKErXlo94Vp3k+isv1ahQNQ
         vrfQ==
X-Gm-Message-State: AOAM531RbX17J971xzd9FJFTEQdelgfdqlucJuPEw0JvSXZWbQbvCvw8
        eyx2grCLaNI/aKCPGsJVUy8hvMyGObM=
X-Google-Smtp-Source: ABdhPJxA8TpuxBnJt5vYMgGydp3GjUq4sn2VeD/NOU6Cqi6YmFmNey14bakMa8BQ9Uv4e3ltX/2kLCSS1r8=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:a583:b0:15d:197b:9259 with SMTP id
 az3-20020a170902a58300b0015d197b9259mr7707341plb.51.1654217036046; Thu, 02
 Jun 2022 17:43:56 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  3 Jun 2022 00:41:18 +0000
In-Reply-To: <20220603004331.1523888-1-seanjc@google.com>
Message-Id: <20220603004331.1523888-12-seanjc@google.com>
Mime-Version: 1.0
References: <20220603004331.1523888-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v2 011/144] KVM: selftests: Add __vcpu_run() helper
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

Add __vcpu_run() so that tests that want to avoid asserts on KVM_RUN
failures don't need to open code the ioctl() call.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/aarch64/vgic_init.c     | 6 ++----
 tools/testing/selftests/kvm/dirty_log_test.c        | 6 ++----
 tools/testing/selftests/kvm/include/kvm_util_base.h | 6 ++++++
 tools/testing/selftests/kvm/lib/kvm_util.c          | 6 ++----
 4 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/vgic_init.c b/tools/testing/selftests/kvm/aarch64/vgic_init.c
index 8c16b5a750e5..a4d015e1d2f6 100644
--- a/tools/testing/selftests/kvm/aarch64/vgic_init.c
+++ b/tools/testing/selftests/kvm/aarch64/vgic_init.c
@@ -55,10 +55,8 @@ static void guest_code(void)
 static int run_vcpu(struct kvm_vm *vm, uint32_t vcpuid)
 {
 	ucall_init(vm, NULL);
-	int ret = __vcpu_ioctl(vm, vcpuid, KVM_RUN, NULL);
-	if (ret)
-		return -errno;
-	return 0;
+
+	return __vcpu_run(vm, vcpuid) ? -errno : 0;
 }
 
 static struct vm_gic vm_gic_create_with_vcpus(uint32_t gic_dev_type, uint32_t nr_vcpus)
diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
index 01c01d40201f..5752486764c9 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -509,7 +509,7 @@ static void generate_random_array(uint64_t *guest_array, uint64_t size)
 
 static void *vcpu_worker(void *data)
 {
-	int ret, vcpu_fd;
+	int ret;
 	struct kvm_vm *vm = data;
 	uint64_t *guest_array;
 	uint64_t pages_count = 0;
@@ -517,8 +517,6 @@ static void *vcpu_worker(void *data)
 						 + sizeof(sigset_t));
 	sigset_t *sigset = (sigset_t *) &sigmask->sigset;
 
-	vcpu_fd = vcpu_get_fd(vm, VCPU_ID);
-
 	/*
 	 * SIG_IPI is unblocked atomically while in KVM_RUN.  It causes the
 	 * ioctl to return with -EINTR, but it is still pending and we need
@@ -539,7 +537,7 @@ static void *vcpu_worker(void *data)
 		generate_random_array(guest_array, TEST_PAGES_PER_LOOP);
 		pages_count += TEST_PAGES_PER_LOOP;
 		/* Let the guest dirty the random pages */
-		ret = ioctl(vcpu_fd, KVM_RUN, NULL);
+		ret = __vcpu_run(vm, VCPU_ID);
 		if (ret == -1 && errno == EINTR) {
 			int sig = -1;
 			sigwait(sigset, &sig);
diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index 4f18f03c537f..6b7a5297053e 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -208,6 +208,12 @@ vm_paddr_t addr_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva);
 struct kvm_run *vcpu_state(struct kvm_vm *vm, uint32_t vcpuid);
 void vcpu_run(struct kvm_vm *vm, uint32_t vcpuid);
 int _vcpu_run(struct kvm_vm *vm, uint32_t vcpuid);
+
+static inline int __vcpu_run(struct kvm_vm *vm, uint32_t vcpuid)
+{
+	return __vcpu_ioctl(vm, vcpuid, KVM_RUN, NULL);
+}
+
 int vcpu_get_fd(struct kvm_vm *vm, uint32_t vcpuid);
 void vcpu_run_complete_io(struct kvm_vm *vm, uint32_t vcpuid);
 struct kvm_reg_list *vcpu_get_reg_list(struct kvm_vm *vm, uint32_t vcpuid);
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 7ac4516d764c..45895c9ca35a 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1597,12 +1597,10 @@ void vcpu_run(struct kvm_vm *vm, uint32_t vcpuid)
 
 int _vcpu_run(struct kvm_vm *vm, uint32_t vcpuid)
 {
-	struct vcpu *vcpu = vcpu_find(vm, vcpuid);
 	int rc;
 
-	TEST_ASSERT(vcpu != NULL, "vcpu not found, vcpuid: %u", vcpuid);
 	do {
-		rc = ioctl(vcpu->fd, KVM_RUN, NULL);
+		rc = __vcpu_run(vm, vcpuid);
 	} while (rc == -1 && errno == EINTR);
 
 	assert_on_unhandled_exception(vm, vcpuid);
@@ -1627,7 +1625,7 @@ void vcpu_run_complete_io(struct kvm_vm *vm, uint32_t vcpuid)
 	TEST_ASSERT(vcpu != NULL, "vcpu not found, vcpuid: %u", vcpuid);
 
 	vcpu->state->immediate_exit = 1;
-	ret = ioctl(vcpu->fd, KVM_RUN, NULL);
+	ret = __vcpu_run(vm, vcpuid);
 	vcpu->state->immediate_exit = 0;
 
 	TEST_ASSERT(ret == -1 && errno == EINTR,
-- 
2.36.1.255.ge46751e96f-goog

