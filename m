Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BCAD51B2E0
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 01:24:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238540AbiEDXAx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 19:00:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379990AbiEDW7g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 18:59:36 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12DCE56402
        for <kvm@vger.kernel.org>; Wed,  4 May 2022 15:52:43 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id a23-20020a17090a6d9700b001d60327d73aso3558700pjk.7
        for <kvm@vger.kernel.org>; Wed, 04 May 2022 15:52:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=jMEQySaj1Rxs5aGpP5khdJki27/sUpGqRcC5WiSoU3o=;
        b=c16ep8pv9Mq2l2AD//OApNL/YycrUvJr5MCjdpfAYkqE439mqkAdRwFXe4/MTeaRco
         ig0tXHGFXUgygkF1G6Cig5flclR0D32TziyFhHZ+mULBqiWgeH1r3M3n42i2oo5KuJsg
         mFMrhWAH/f9AwE7O+oukkvuGPa83qHrYsA1HWEXsdGAql5cnLrROGwkw4OhtPs4WjRr5
         HK72RfWOgiai4Ecvk3XHpCvKNZa43ib6/Mah4igxWUHBu7S73phiNhi5OfvjFr5RpYtF
         d/r1hHivR/yEu1K4NkSbWQFy+qBpZDc4ZWo/yQ/KDKQv/1hBFA4MM1Jn1JMXXxge3rQJ
         RXFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=jMEQySaj1Rxs5aGpP5khdJki27/sUpGqRcC5WiSoU3o=;
        b=wmNH8Dyhhc3VPyctYW4b2tsXaFf3ucA4Qr9RoHJaVJI7jOBVZauEBQqSj1P3F/4uga
         yJJjk3WnVJ9+qRZGs49jlCZmbSQkngoqTVx1O5Y0keyen3dVA4tO9oGGNuVGbFZKID+8
         NdeAiWZwda4B/S9aRYkF+98nODLHLhpcQG/VVm/U0ITn9zX5O98VYggmJ4jkZHDIibyx
         jkF/rdJQ6w8YU2rtiKrWes52tJULk+qVo5VsYjoFatdtRwkXR+kXgUgPYqz/2jxQsnhF
         +hLpoUPTu5LPjd769bX8IPJ894UuKKze4N/GGNCre602MtK79a5QrdE2kArOipJaSSg0
         h0Sg==
X-Gm-Message-State: AOAM530VkFMKX6KgYy/BCd+9F04i5QhBJeTQv35vlVPajhrWPNU8bdVc
        jqpCmitcUhoZAi4co1bv+16XHRke3Q4=
X-Google-Smtp-Source: ABdhPJwxPw5SYRUumfnsshwju/m/hT5MRtSZ0zseZdiMFidvFkNg7cef7sU0Mh351TWknbDslQxcIdgzKLA=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:903:230e:b0:15e:d0a1:922f with SMTP id
 d14-20020a170903230e00b0015ed0a1922fmr3114818plh.75.1651704742910; Wed, 04
 May 2022 15:52:22 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  4 May 2022 22:48:46 +0000
In-Reply-To: <20220504224914.1654036-1-seanjc@google.com>
Message-Id: <20220504224914.1654036-101-seanjc@google.com>
Mime-Version: 1.0
References: <20220504224914.1654036-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH 100/128] KVM: selftests: Convert arch_timer away from VCPU_ID
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
2.36.0.464.gb9c8b46e94-goog

