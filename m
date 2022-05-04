Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DF3551B263
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 00:51:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379136AbiEDWya (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 18:54:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379161AbiEDWxg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 18:53:36 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F76A53B73
        for <kvm@vger.kernel.org>; Wed,  4 May 2022 15:49:50 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id j24-20020a637a58000000b003ab45990247so1334041pgn.17
        for <kvm@vger.kernel.org>; Wed, 04 May 2022 15:49:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=zKnCLZBl0iKbuaUJ2c8P14+HTnYeKNOrT10EIR+YEXk=;
        b=MmrNHNzQ+BmNHxua+Mydg7tD8a+0M4PzDyq1R5HsLSodMO/j6CTd/7xoM8r+nyVUzi
         yuTF8+xUtDP/vwQgB/yIms7KZ4l91i4bTBEaak0o42hPhYexEaZ5+9UdHijDAQgQ5deP
         yl9yTA4ajtsIwAFR/dOY4AU7/c7mHpUybR1QnQ55WV6xpGwX9ex3RzgM1+HhRNUWhxfj
         L1qUqPO6MC9MU8m0fPnu3VcqEwlltKZkXX9StgQznXiU9eUNvpS7/9RDK4EHsEFBYO0p
         GaERpEvTiBEPR0XR9zDyGHpFN3HNIum7kla2GKKaZdN53SPLi7S+yOl4w+NyRUIYGQPe
         ZMag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=zKnCLZBl0iKbuaUJ2c8P14+HTnYeKNOrT10EIR+YEXk=;
        b=x70K8WwnTK5T34Qgspr0fbVpiseUpWZ9Ls3SccpjE9lT58SJrsvG2earNMbXZGLA4W
         JLY0BsOGSGMj5dyFCPg1re0wO/Q31529I2WR1CJrytHja/LeqPs5PlBUWJ+w7s6CZzyv
         Myoe6lS1NUyyLJJqZOgLt4YqFvtAlsdrO3wHULlZj7z4WSZbcE7WFpKlImzb1yD3a5eU
         LvC09iq6WpfLiFu5wevEnspbXYR7F1XvfGQ7gQO4j+PmgtvjLnD8iqaR3gUCySa6ReMa
         o4/7kX1m3yeDHzqeUBoHMs1vo36LVQCVul0xBqoY3n3Li2syNRSAU716CgLadaNwxXPb
         GxVw==
X-Gm-Message-State: AOAM530IeRVBs6VKs7PqGHtOlRy0yNikpMx0Nv2q3U9fvaM45aRAV5Jq
        mYBP8ZFiTz61IRS7rkjvIW59qKkbAsw=
X-Google-Smtp-Source: ABdhPJzX9q1EH0NVpgVFri34UYpD+hyxfHrnn9pZ4155kGZTjgh2EWV1zLz8Tcx94vzs5yLdnN9Fc2LRKvs=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90a:e510:b0:1d9:ee23:9fa1 with SMTP id
 t16-20020a17090ae51000b001d9ee239fa1mr139773pjy.0.1651704589073; Wed, 04 May
 2022 15:49:49 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  4 May 2022 22:47:16 +0000
In-Reply-To: <20220504224914.1654036-1-seanjc@google.com>
Message-Id: <20220504224914.1654036-11-seanjc@google.com>
Mime-Version: 1.0
References: <20220504224914.1654036-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH 010/128] KVM: selftests: Add __vcpu_run() helper
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
index 373c8005c2e7..9a153b2ea3de 100644
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
2.36.0.464.gb9c8b46e94-goog

