Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 068FE53C2AD
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 04:13:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240799AbiFCA5y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 20:57:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240866AbiFCAuN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 20:50:13 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1DF227167
        for <kvm@vger.kernel.org>; Thu,  2 Jun 2022 17:47:17 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id b20-20020a62a114000000b0050a6280e374so3493663pff.13
        for <kvm@vger.kernel.org>; Thu, 02 Jun 2022 17:47:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=Bg3FPUcZataZgkboHwnXDx99Xu5ipyIuGSF/1JKcQfw=;
        b=r5WSnaka7CXH0wlXynNN4uQxttq7kJ4YsbzZ0enYjpYokYGKDW0qbKDCg7eglLaapy
         F26w1RHjl9BMrbehybOrFS7Prd3nJNTOkk/wlH2sRTn2oqqZlYsIBSlEEqmZVimS5eGE
         11JkyiFyYMMhS1LEMVouylNR+RKaX7IeE1S74qkitrUnZIy8OqGmDsYl6DgmuOOoEhx0
         R2buenp+ruYspCJ18AjikS+dwpkMqKiQjJoQRfC6ViNSwi1YzsX3AyeYa39S6oAE5zdc
         hDjLU0AJ7VLT1aQfqgm4eUQtLFunPObAs6mPx6KBsfygcviGukDD+lnoUfvvwrpZy8oV
         zbag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=Bg3FPUcZataZgkboHwnXDx99Xu5ipyIuGSF/1JKcQfw=;
        b=oX31k4NW90TUhQzyx0C5K2JDVjgh54tkuywX+IsnJTfqL6tBXWvHtXh6Qx5/FtRsKF
         qpNGe2LemfjivSmCFZbg9xL1JE43KxUjTZf6UVQypx4JEyqUvzLFAG2ABtn546NfO4ZG
         skeS2oeCTKRzoJsoMKRqS8PJg5bArfcPVsv8bC4NgPwMzw/K7QX+P+2loKoDinCQ+7K5
         4xp0+2N3/0REmEafvnWbtMJlGE3By8WqkPWW/trXIxJE9Hmv1XoLF+ds0li1s3QXY2ON
         YMGja2qMuYmgarHXQghOJ43R6JotYYcv4NJ8Uaw0XBdxpIWTWDWQeQpExefycSx+RCYd
         uJYQ==
X-Gm-Message-State: AOAM533Q//Be2mK+iH0D3hpyCVt090KvdvYC6ghhBNwXeu7QhMXufjos
        x96q+EuOpf8ybU0iCt55an3MjcGsm9g=
X-Google-Smtp-Source: ABdhPJyTO9AHxnuaCGvBwIyBSheX/uf1B7aKrIh+JpxC4rT9IMTY2p60oDRYrHIZnzTXJAtOBByGLqLBGvc=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90a:d01:b0:1e0:2e32:8650 with SMTP id
 t1-20020a17090a0d0100b001e02e328650mr8094037pja.156.1654217236702; Thu, 02
 Jun 2022 17:47:16 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  3 Jun 2022 00:43:09 +0000
In-Reply-To: <20220603004331.1523888-1-seanjc@google.com>
Message-Id: <20220603004331.1523888-123-seanjc@google.com>
Mime-Version: 1.0
References: <20220603004331.1523888-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v2 122/144] KVM: selftests: Use vm_create_with_vcpus() in max_guest_memory_test
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

Use vm_create_with_vcpus() in max_guest_memory_test and reference vCPUs
by their 'struct kvm_vcpu' object instead of their ID.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/max_guest_memory_test.c     | 26 ++++++++++++-------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/kvm/max_guest_memory_test.c b/tools/testing/selftests/kvm/max_guest_memory_test.c
index 3875c4b23a04..956fc56b8c68 100644
--- a/tools/testing/selftests/kvm/max_guest_memory_test.c
+++ b/tools/testing/selftests/kvm/max_guest_memory_test.c
@@ -28,8 +28,7 @@ static void guest_code(uint64_t start_gpa, uint64_t end_gpa, uint64_t stride)
 }
 
 struct vcpu_info {
-	struct kvm_vm *vm;
-	uint32_t id;
+	struct kvm_vcpu *vcpu;
 	uint64_t start_gpa;
 	uint64_t end_gpa;
 };
@@ -60,12 +59,13 @@ static void run_vcpu(struct kvm_vm *vm, uint32_t vcpu_id)
 
 static void *vcpu_worker(void *data)
 {
-	struct vcpu_info *vcpu = data;
+	struct vcpu_info *info = data;
+	struct kvm_vcpu *vcpu = info->vcpu;
 	struct kvm_vm *vm = vcpu->vm;
 	struct kvm_sregs sregs;
 	struct kvm_regs regs;
 
-	vcpu_args_set(vm, vcpu->id, 3, vcpu->start_gpa, vcpu->end_gpa,
+	vcpu_args_set(vm, vcpu->id, 3, info->start_gpa, info->end_gpa,
 		      vm_get_page_size(vm));
 
 	/* Snapshot regs before the first run. */
@@ -89,8 +89,8 @@ static void *vcpu_worker(void *data)
 	return NULL;
 }
 
-static pthread_t *spawn_workers(struct kvm_vm *vm, uint64_t start_gpa,
-				uint64_t end_gpa)
+static pthread_t *spawn_workers(struct kvm_vm *vm, struct kvm_vcpu **vcpus,
+				uint64_t start_gpa, uint64_t end_gpa)
 {
 	struct vcpu_info *info;
 	uint64_t gpa, nr_bytes;
@@ -108,8 +108,7 @@ static pthread_t *spawn_workers(struct kvm_vm *vm, uint64_t start_gpa,
 	TEST_ASSERT(nr_bytes, "C'mon, no way you have %d CPUs", nr_vcpus);
 
 	for (i = 0, gpa = start_gpa; i < nr_vcpus; i++, gpa += nr_bytes) {
-		info[i].vm = vm;
-		info[i].id = i;
+		info[i].vcpu = vcpus[i];
 		info[i].start_gpa = gpa;
 		info[i].end_gpa = gpa + nr_bytes;
 		pthread_create(&threads[i], NULL, vcpu_worker, &info[i]);
@@ -172,6 +171,7 @@ int main(int argc, char *argv[])
 	uint64_t max_gpa, gpa, slot_size, max_mem, i;
 	int max_slots, slot, opt, fd;
 	bool hugepages = false;
+	struct kvm_vcpu **vcpus;
 	pthread_t *threads;
 	struct kvm_vm *vm;
 	void *mem;
@@ -215,7 +215,10 @@ int main(int argc, char *argv[])
 		}
 	}
 
-	vm = vm_create_default_with_vcpus(nr_vcpus, 0, 0, guest_code, NULL);
+	vcpus = malloc(nr_vcpus * sizeof(*vcpus));
+	TEST_ASSERT(vcpus, "Failed to allocate vCPU array");
+
+	vm = vm_create_with_vcpus(nr_vcpus, guest_code, vcpus);
 
 	max_gpa = vm_get_max_gfn(vm) << vm_get_page_shift(vm);
 	TEST_ASSERT(max_gpa > (4 * slot_size), "MAXPHYADDR <4gb ");
@@ -252,7 +255,10 @@ int main(int argc, char *argv[])
 	}
 
 	atomic_set(&rendezvous, nr_vcpus + 1);
-	threads = spawn_workers(vm, start_gpa, gpa);
+	threads = spawn_workers(vm, vcpus, start_gpa, gpa);
+
+	free(vcpus);
+	vcpus = NULL;
 
 	pr_info("Running with %lugb of guest memory and %u vCPUs\n",
 		(gpa - start_gpa) / size_1gb, nr_vcpus);
-- 
2.36.1.255.ge46751e96f-goog

