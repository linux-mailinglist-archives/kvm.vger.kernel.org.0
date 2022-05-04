Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 186A851B271
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 00:51:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359732AbiEDWzK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 18:55:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379487AbiEDWyM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 18:54:12 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E7549FEB
        for <kvm@vger.kernel.org>; Wed,  4 May 2022 15:50:34 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-2dc7bdd666fso24171617b3.7
        for <kvm@vger.kernel.org>; Wed, 04 May 2022 15:50:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=G2bckr8dzy/VpMTALQzDwVbtP/BZXFx63tXxVXAvLBY=;
        b=BrDqCBXd9hHHGusLXGgzJHeRY9VMkolLcSa6S05adud2BGld2gVU+AUIf0ootTyHxO
         eszMDj68mLaaQtjgew8B+zPep6hXxko491KqVS6rA4zLigv8SCuq6yWqUl0iKeHujp3b
         sGyeTFzoaFBnK6+u+8j1+CsuzZdAMM1Zpssh9Jd8D5bPzBJOgopWcg45+pRhpQQZvaq0
         ZQAWBF+rFFwA/0PSIyExy/afq+3yf16J9zPiX04LulnFjyHncxZ+ZiRhpmSwd4m9FfrZ
         w2AUJn8SlvwXTFJR4Fdmv/JsvmoD9fBOhtfWrbUzTouee+tYGy/henU4Elr2zD44+oyr
         h/Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=G2bckr8dzy/VpMTALQzDwVbtP/BZXFx63tXxVXAvLBY=;
        b=MezVkOQ6BnUrGvcKw0DgZ/ar6pcjKRdQDTBUhlltiKYfyYFaZ+f9ZHszlDdaRtFGFo
         wqziFfURtMKqbnAxnL4oSls2RC4GBiHbmh7n2l1cwL/tigOSGnSR60SGANRq3iWievB5
         cbds6Rx2aWcyQqXaMKVvTcHZ4j1ezLdjM5OhJNU3Jq633KdB6oUaooWAIeI8On1Ld+WW
         /oGqfJMWSB4QSo0w1bSVmzLwdad4eec+im5mBpH5okToRBLOuFLgge61tZBpciNvMeHL
         R/9Rh253fcVwK8P1UTqDPLQPZ+96A2GNx+V12JFUGrvAXg+7cuJ6hIAf6fzWqEFXo3Su
         AIlA==
X-Gm-Message-State: AOAM532kQWgeqJQXzB0WXFdCeboHXyWNiAxbVra7nFy6nNu7kCIkwMLk
        8Fxrm82R4DJfCmWIk0zEFwAw/m6Etkc=
X-Google-Smtp-Source: ABdhPJxT/tsWqHDDRzAP8Y4BfSRDxOHh7HCIH/9+qICwO8fydYXcrrSW0oAi7zbyVDQk2t6nuIUfESKFCNM=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a25:9f90:0:b0:624:521e:d4a5 with SMTP id
 u16-20020a259f90000000b00624521ed4a5mr19240052ybq.230.1651704633637; Wed, 04
 May 2022 15:50:33 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  4 May 2022 22:47:42 +0000
In-Reply-To: <20220504224914.1654036-1-seanjc@google.com>
Message-Id: <20220504224914.1654036-37-seanjc@google.com>
Mime-Version: 1.0
References: <20220504224914.1654036-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH 036/128] KVM: selftests: Rename vm_create_without_vcpus() => vm_create()
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

Rename vm_create_without_vcpus() to vm_create() so that it's not
misconstrued as helper that creates a VM that can never have vCPUs, as
opposed to a helper that "just" creates a VM without vCPUs added at time
zero.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/aarch64/psci_cpu_on_test.c     | 2 +-
 tools/testing/selftests/kvm/dirty_log_test.c               | 2 +-
 tools/testing/selftests/kvm/hardware_disable_test.c        | 2 +-
 tools/testing/selftests/kvm/include/kvm_util_base.h        | 2 +-
 tools/testing/selftests/kvm/lib/kvm_util.c                 | 4 ++--
 tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c | 2 +-
 tools/testing/selftests/kvm/x86_64/set_boot_cpu_id.c       | 2 +-
 7 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/psci_cpu_on_test.c b/tools/testing/selftests/kvm/aarch64/psci_cpu_on_test.c
index b4b0fa5d7c21..4dc04a12f527 100644
--- a/tools/testing/selftests/kvm/aarch64/psci_cpu_on_test.c
+++ b/tools/testing/selftests/kvm/aarch64/psci_cpu_on_test.c
@@ -76,7 +76,7 @@ int main(void)
 	struct kvm_vm *vm;
 	struct ucall uc;
 
-	vm = vm_create_without_vcpus(VM_MODE_DEFAULT, DEFAULT_GUEST_PHY_PAGES);
+	vm = vm_create(VM_MODE_DEFAULT, DEFAULT_GUEST_PHY_PAGES);
 	ucall_init(vm, NULL);
 
 	vm_ioctl(vm, KVM_ARM_PREFERRED_TARGET, &init);
diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
index 74dcac0c22c5..aa7eb01ad25f 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -677,7 +677,7 @@ static struct kvm_vm *create_vm(enum vm_guest_mode mode, uint32_t vcpuid,
 
 	pr_info("Testing guest mode: %s\n", vm_guest_mode_string(mode));
 
-	vm = vm_create_without_vcpus(mode, DEFAULT_GUEST_PHY_PAGES + extra_pg_pages);
+	vm = vm_create(mode, DEFAULT_GUEST_PHY_PAGES + extra_pg_pages);
 
 	log_mode_create_vm_done(vm);
 	vm_vcpu_add_default(vm, vcpuid, guest_code);
diff --git a/tools/testing/selftests/kvm/hardware_disable_test.c b/tools/testing/selftests/kvm/hardware_disable_test.c
index 32837207fe4e..299862a85b8d 100644
--- a/tools/testing/selftests/kvm/hardware_disable_test.c
+++ b/tools/testing/selftests/kvm/hardware_disable_test.c
@@ -104,7 +104,7 @@ static void run_test(uint32_t run)
 	for (i = 0; i < VCPU_NUM; i++)
 		CPU_SET(i, &cpu_set);
 
-	vm  = vm_create_without_vcpus(VM_MODE_DEFAULT, DEFAULT_GUEST_PHY_PAGES);
+	vm  = vm_create(VM_MODE_DEFAULT, DEFAULT_GUEST_PHY_PAGES);
 
 	pr_debug("%s: [%d] start vcpus\n", __func__, run);
 	for (i = 0; i < VCPU_NUM; ++i) {
diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index 0110c415cd8c..48a4000222c1 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -629,7 +629,7 @@ struct kvm_vm *vm_create_with_vcpus(enum vm_guest_mode mode, uint32_t nr_vcpus,
 				    uint32_t vcpuids[]);
 
 /* Create a default VM without any vcpus. */
-struct kvm_vm *vm_create_without_vcpus(enum vm_guest_mode mode, uint64_t pages);
+struct kvm_vm *vm_create(enum vm_guest_mode mode, uint64_t pages);
 
 /*
  * Create a VM with a single vCPU with reasonable defaults and @extra_mem_pages
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index aa93b37bc5cf..632912aeaeb9 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -262,7 +262,7 @@ struct kvm_vm *__vm_create(enum vm_guest_mode mode, uint64_t phy_pages)
 	return vm;
 }
 
-struct kvm_vm *vm_create_without_vcpus(enum vm_guest_mode mode, uint64_t pages)
+struct kvm_vm *vm_create(enum vm_guest_mode mode, uint64_t pages)
 {
 	struct kvm_vm *vm;
 
@@ -327,7 +327,7 @@ struct kvm_vm *vm_create_with_vcpus(enum vm_guest_mode mode, uint32_t nr_vcpus,
 		    "nr_vcpus = %d too large for host, max-vcpus = %d",
 		    nr_vcpus, kvm_check_cap(KVM_CAP_MAX_VCPUS));
 
-	vm = vm_create_without_vcpus(mode, pages);
+	vm = vm_create(mode, pages);
 
 	for (i = 0; i < nr_vcpus; ++i) {
 		uint32_t vcpuid = vcpuids ? vcpuids[i] : i;
diff --git a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
index 269033af43ce..d80b0a408937 100644
--- a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
+++ b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
@@ -340,7 +340,7 @@ static void test_pmu_config_disable(void (*guest_code)(void))
 	if (!(r & KVM_PMU_CAP_DISABLE))
 		return;
 
-	vm = vm_create_without_vcpus(VM_MODE_DEFAULT, DEFAULT_GUEST_PHY_PAGES);
+	vm = vm_create(VM_MODE_DEFAULT, DEFAULT_GUEST_PHY_PAGES);
 
 	cap.cap = KVM_CAP_PMU_CAPABILITY;
 	cap.args[0] = KVM_PMU_CAP_DISABLE;
diff --git a/tools/testing/selftests/kvm/x86_64/set_boot_cpu_id.c b/tools/testing/selftests/kvm/x86_64/set_boot_cpu_id.c
index 4c5775a8de6a..6bc13cf17220 100644
--- a/tools/testing/selftests/kvm/x86_64/set_boot_cpu_id.c
+++ b/tools/testing/selftests/kvm/x86_64/set_boot_cpu_id.c
@@ -86,7 +86,7 @@ static struct kvm_vm *create_vm(void)
 	uint64_t extra_pg_pages = vcpu_pages / PTES_PER_MIN_PAGE * N_VCPU;
 	uint64_t pages = DEFAULT_GUEST_PHY_PAGES + vcpu_pages + extra_pg_pages;
 
-	return vm_create_without_vcpus(VM_MODE_DEFAULT, pages);
+	return vm_create(VM_MODE_DEFAULT, pages);
 }
 
 static void add_x86_vcpu(struct kvm_vm *vm, uint32_t vcpuid, bool bsp_code)
-- 
2.36.0.464.gb9c8b46e94-goog

