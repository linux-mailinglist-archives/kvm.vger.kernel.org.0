Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BCBB53C266
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 04:12:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239072AbiFCAyc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 20:54:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240822AbiFCAuL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 20:50:11 -0400
Received: from mail-ua1-x949.google.com (mail-ua1-x949.google.com [IPv6:2607:f8b0:4864:20::949])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAFE5245B3
        for <kvm@vger.kernel.org>; Thu,  2 Jun 2022 17:47:03 -0700 (PDT)
Received: by mail-ua1-x949.google.com with SMTP id w8-20020ab05a88000000b00368e9354775so2721944uae.18
        for <kvm@vger.kernel.org>; Thu, 02 Jun 2022 17:47:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=UZ39FwqPuZSwzhKmIpJpQ529gOFccXb7mEmumiCcntE=;
        b=qmsPw6+cATPxvN7VKqvjg2HNvYBMfDisXruYDZCP1ExEA9KU7j8DzSoAnTeqZN/KT5
         CH+/sCCbcW6O5PlOPp8+QfhmHOudc7A/z7zixhmDVG8OeM+U1r7Igj0L5bTrEp2+iWKe
         Ul/BGxTaQV1oGidDpr8FGb9BZRYFX6Ax4SFK0NJaS12FJbxJ3+f8bse2/RYAZJ0JVlWi
         wnrCSyMFHolf3CBCcfToZvpB3skj/jr5PARSD6+v/CXRtGIHOyTS0uw8CUTC/TXnK/Z6
         1198MpZr8OZyTI7qWIz3DL0cFwWeYKrSLxa1I35OMHFq70fKpYOyY7NJLieIWd/zXhGG
         6cgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=UZ39FwqPuZSwzhKmIpJpQ529gOFccXb7mEmumiCcntE=;
        b=r187bx/fHpIeSVd178eVtzgwrla6JUaEWnWa9hxS3wLwsKVFeho/tDWUdjzuSrq8KU
         kRYrAuKLh1ppJJuxlfhwGYHSWU6Cdb2eMbuEzU9Tvusx5ktXZJH/L8ftAZmJRqDITauw
         L8YOzSS7VEyXbKAXjRXBGuL1mBem1Q7RNShOK/0Z8fi97/yGP0U+8MpCGNZFUCUHBaaq
         oiAiqmFAJv/8ehrWO4S6b8JZGkpjbDzdOyP5FgF4vNvhOA2U/MIfX5CinNhcWTJFgGB9
         69xW22zxAqF2EpRQQWJuwRpGGaMYefYpaC0XaeJ6cYHWEC/Gny0KYb06uTRpkoW6AcPn
         fu/Q==
X-Gm-Message-State: AOAM532MvlVFwnZvAUREk+E7jtKPJBrT0AkToUUzm+V8GrNcIht/0l6w
        c0uxgcvQo23Y2ipeW19hBcKfZcvKtQ4=
X-Google-Smtp-Source: ABdhPJxfDVcVqvcYU69U83ovg0EbI6neC7aNWV8nTeap+CSPzCrBdfD6xCbaWjVSqIAywXTYICbwjuRo3lM=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:b85:b0:51b:bd9b:869 with SMTP id
 g5-20020a056a000b8500b0051bbd9b0869mr7817160pfj.31.1654217211690; Thu, 02 Jun
 2022 17:46:51 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  3 Jun 2022 00:42:55 +0000
In-Reply-To: <20220603004331.1523888-1-seanjc@google.com>
Message-Id: <20220603004331.1523888-109-seanjc@google.com>
Mime-Version: 1.0
References: <20220603004331.1523888-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v2 108/144] KVM: selftests: Convert arch_timer away from VCPU_ID
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
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Convert arch_timer to use vm_create_with_vcpus() and pass around a
'struct kvm_vcpu' object instead of requiring that the index into the
array of vCPUs for a given vCPU is also the ID of the vCPU

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/aarch64/arch_timer.c        | 62 ++++++++-----------
 1 file changed, 27 insertions(+), 35 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/arch_timer.c b/tools/testing/selftests/kvm/aarch64/arch_timer.c
index f04ca07c7f14..a873d9adc558 100644
--- a/tools/testing/selftests/kvm/aarch64/arch_timer.c
+++ b/tools/testing/selftests/kvm/aarch64/arch_timer.c
@@ -76,13 +76,8 @@ struct test_vcpu_shared_data {
 	uint64_t xcnt;
 };
 
-struct test_vcpu {
-	uint32_t vcpuid;
-	pthread_t pt_vcpu_run;
-	struct kvm_vm *vm;
-};
-
-static struct test_vcpu test_vcpu[KVM_MAX_VCPUS];
+static struct kvm_vcpu *vcpus[KVM_MAX_VCPUS];
+static pthread_t pt_vcpu_run[KVM_MAX_VCPUS];
 static struct test_vcpu_shared_data vcpu_shared_data[KVM_MAX_VCPUS];
 
 static int vtimer_irq, ptimer_irq;
@@ -217,20 +212,20 @@ static void guest_code(void)
 
 static void *test_vcpu_run(void *arg)
 {
+	unsigned int vcpu_idx = (unsigned long)arg;
 	struct ucall uc;
-	struct test_vcpu *vcpu = arg;
+	struct kvm_vcpu *vcpu = vcpus[vcpu_idx];
 	struct kvm_vm *vm = vcpu->vm;
-	uint32_t vcpuid = vcpu->vcpuid;
-	struct test_vcpu_shared_data *shared_data = &vcpu_shared_data[vcpuid];
+	struct test_vcpu_shared_data *shared_data = &vcpu_shared_data[vcpu_idx];
 
-	vcpu_run(vm, vcpuid);
+	vcpu_run(vm, vcpu->id);
 
 	/* Currently, any exit from guest is an indication of completion */
 	pthread_mutex_lock(&vcpu_done_map_lock);
-	set_bit(vcpuid, vcpu_done_map);
+	set_bit(vcpu_idx, vcpu_done_map);
 	pthread_mutex_unlock(&vcpu_done_map_lock);
 
-	switch (get_ucall(vm, vcpuid, &uc)) {
+	switch (get_ucall(vm, vcpu->id, &uc)) {
 	case UCALL_SYNC:
 	case UCALL_DONE:
 		break;
@@ -238,7 +233,7 @@ static void *test_vcpu_run(void *arg)
 		sync_global_from_guest(vm, *shared_data);
 		TEST_FAIL("%s at %s:%ld\n\tvalues: %lu, %lu; %lu, vcpu: %u; stage: %u; iter: %u",
 			(const char *)uc.args[0], __FILE__, uc.args[1],
-			uc.args[2], uc.args[3], uc.args[4], vcpuid,
+			uc.args[2], uc.args[3], uc.args[4], vcpu_idx,
 			shared_data->guest_stage, shared_data->nr_iter);
 		break;
 	default:
@@ -265,7 +260,7 @@ static uint32_t test_get_pcpu(void)
 	return pcpu;
 }
 
-static int test_migrate_vcpu(struct test_vcpu *vcpu)
+static int test_migrate_vcpu(unsigned int vcpu_idx)
 {
 	int ret;
 	cpu_set_t cpuset;
@@ -274,15 +269,15 @@ static int test_migrate_vcpu(struct test_vcpu *vcpu)
 	CPU_ZERO(&cpuset);
 	CPU_SET(new_pcpu, &cpuset);
 
-	pr_debug("Migrating vCPU: %u to pCPU: %u\n", vcpu->vcpuid, new_pcpu);
+	pr_debug("Migrating vCPU: %u to pCPU: %u\n", vcpu_idx, new_pcpu);
 
-	ret = pthread_setaffinity_np(vcpu->pt_vcpu_run,
-					sizeof(cpuset), &cpuset);
+	ret = pthread_setaffinity_np(pt_vcpu_run[vcpu_idx],
+				     sizeof(cpuset), &cpuset);
 
 	/* Allow the error where the vCPU thread is already finished */
 	TEST_ASSERT(ret == 0 || ret == ESRCH,
-			"Failed to migrate the vCPU:%u to pCPU: %u; ret: %d\n",
-			vcpu->vcpuid, new_pcpu, ret);
+		    "Failed to migrate the vCPU:%u to pCPU: %u; ret: %d\n",
+		    vcpu_idx, new_pcpu, ret);
 
 	return ret;
 }
@@ -305,7 +300,7 @@ static void *test_vcpu_migration(void *arg)
 				continue;
 			}
 
-			test_migrate_vcpu(&test_vcpu[i]);
+			test_migrate_vcpu(i);
 		}
 	} while (test_args.nr_vcpus != n_done);
 
@@ -314,16 +309,17 @@ static void *test_vcpu_migration(void *arg)
 
 static void test_run(struct kvm_vm *vm)
 {
-	int i, ret;
 	pthread_t pt_vcpu_migration;
+	unsigned int i;
+	int ret;
 
 	pthread_mutex_init(&vcpu_done_map_lock, NULL);
 	vcpu_done_map = bitmap_zalloc(test_args.nr_vcpus);
 	TEST_ASSERT(vcpu_done_map, "Failed to allocate vcpu done bitmap\n");
 
-	for (i = 0; i < test_args.nr_vcpus; i++) {
-		ret = pthread_create(&test_vcpu[i].pt_vcpu_run, NULL,
-				test_vcpu_run, &test_vcpu[i]);
+	for (i = 0; i < (unsigned long)test_args.nr_vcpus; i++) {
+		ret = pthread_create(&pt_vcpu_run[i], NULL, test_vcpu_run,
+				     (void *)(unsigned long)i);
 		TEST_ASSERT(!ret, "Failed to create vCPU-%d pthread\n", i);
 	}
 
@@ -338,7 +334,7 @@ static void test_run(struct kvm_vm *vm)
 
 
 	for (i = 0; i < test_args.nr_vcpus; i++)
-		pthread_join(test_vcpu[i].pt_vcpu_run, NULL);
+		pthread_join(pt_vcpu_run[i], NULL);
 
 	if (test_args.migration_freq_ms)
 		pthread_join(pt_vcpu_migration, NULL);
@@ -349,9 +345,9 @@ static void test_run(struct kvm_vm *vm)
 static void test_init_timer_irq(struct kvm_vm *vm)
 {
 	/* Timer initid should be same for all the vCPUs, so query only vCPU-0 */
-	vcpu_device_attr_get(vm, 0, KVM_ARM_VCPU_TIMER_CTRL,
+	vcpu_device_attr_get(vm, vcpus[0]->id, KVM_ARM_VCPU_TIMER_CTRL,
 			     KVM_ARM_VCPU_TIMER_IRQ_PTIMER, &ptimer_irq);
-	vcpu_device_attr_get(vm, 0, KVM_ARM_VCPU_TIMER_CTRL,
+	vcpu_device_attr_get(vm, vcpus[0]->id, KVM_ARM_VCPU_TIMER_CTRL,
 			     KVM_ARM_VCPU_TIMER_IRQ_VTIMER, &vtimer_irq);
 
 	sync_global_to_guest(vm, ptimer_irq);
@@ -368,17 +364,13 @@ static struct kvm_vm *test_vm_create(void)
 	unsigned int i;
 	int nr_vcpus = test_args.nr_vcpus;
 
-	vm = vm_create_default_with_vcpus(nr_vcpus, 0, 0, guest_code, NULL);
+	vm = vm_create_with_vcpus(nr_vcpus, guest_code, vcpus);
 
 	vm_init_descriptor_tables(vm);
 	vm_install_exception_handler(vm, VECTOR_IRQ_CURRENT, guest_irq_handler);
 
-	for (i = 0; i < nr_vcpus; i++) {
-		vcpu_init_descriptor_tables(vm, i);
-
-		test_vcpu[i].vcpuid = i;
-		test_vcpu[i].vm = vm;
-	}
+	for (i = 0; i < nr_vcpus; i++)
+		vcpu_init_descriptor_tables(vm, vcpus[i]->id);
 
 	ucall_init(vm, NULL);
 	test_init_timer_irq(vm);
-- 
2.36.1.255.ge46751e96f-goog

