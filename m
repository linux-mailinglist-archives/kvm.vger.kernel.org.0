Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A49AC51B2E1
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 01:24:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379454AbiEDXBR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 19:01:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380471AbiEDXAC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 19:00:02 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38CFA579A8
        for <kvm@vger.kernel.org>; Wed,  4 May 2022 15:53:24 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id s18-20020a17090aa11200b001d92f7609e8so1089508pjp.3
        for <kvm@vger.kernel.org>; Wed, 04 May 2022 15:53:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=f5f/LLx9WhINchyLZxvs4xznbsCcXbPaUrDUqVFjwOU=;
        b=M+Z2YfuAplTjHTdRLuuiglVwyDuuBa3aYjRTFeA9f5WBoigc1/JlpdXMASISCWzJ6Z
         VynBbIB7Fmn66vT1RcrtV8TzY5MoBCtVaNTGTMhgRlsnLOdcr6p4/AXpxj3f/rZgJLxT
         xky171nhvkrXxfGTVjA4n25+ujd7r5bWfi9Msr2Ij/H5vSsot4qMraRxnHv+lW65bTHg
         RaXf4igJyGhunqyasLkrRvv/FMFZ3ZyurZ2bIckhZorOXe7jiGk/NPcjm/bT7/hL+qpl
         +JwIJ2djcYF18cH5iB9rM8AdhPo9j5781ZmsAhCa/IuM6UizayOoUKV9Sxu6PUjm1JGa
         F0ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=f5f/LLx9WhINchyLZxvs4xznbsCcXbPaUrDUqVFjwOU=;
        b=Iq1zi7Z2Vv2jED3I9RvpXgVPM+sm/l8cDz+vksVf2lxS/HTjCUnDUDDv8Qr86mObNC
         LhQtYkCsYENsnPkUv2To7b+NuduHRdSIOdtxuyvKkynsC8AhIBzFlGAvPTRuDnXYQmkJ
         UxPIbO3QSJ4F6TLU/ici2Q4wH8mVKeOXBjOrayrmWnyGWGrYW0kpgPK2zUMlsRnG8hJt
         cng2hT8bFz5TEjs0LWSHOUDqwZVFxbzKbbSpOVC2mB/uzcz06SqfT+PXl+P+SEi4RKba
         Fl+ekor4JzxEnfK/A4Bw+kdPi9rIUZrSM0V7Rwo/PWdn0s+i5azDuT/zwrH7vZF7yEeh
         HNMQ==
X-Gm-Message-State: AOAM530QqbFDq2SvfUIR5zskt/0u043mCaOuFlq+Ede9Xae8txfTd4ju
        jkTNNL1NwzInk4e/GhvHZIpezUwWjBo=
X-Google-Smtp-Source: ABdhPJzCDtyBxpndtkFGHjTkVZEIuNBNo3OWmesmo2laDtlePxcjYHM4V5SFKJrcjTl62Up63NckZYRIi2A=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90b:3ec7:b0:1dc:b008:3cd3 with SMTP id
 rm7-20020a17090b3ec700b001dcb0083cd3mr2232406pjb.226.1651704771485; Wed, 04
 May 2022 15:52:51 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  4 May 2022 22:49:02 +0000
In-Reply-To: <20220504224914.1654036-1-seanjc@google.com>
Message-Id: <20220504224914.1654036-117-seanjc@google.com>
Mime-Version: 1.0
References: <20220504224914.1654036-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH 116/128] KVM: selftests: Stop hardcoding vCPU IDs in vcpu_width_config
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

In preparation for taking a vCPU pointer in vCPU-scoped functions, grab
the vCPU(s) created by __vm_vcpu_add() and use the ID from the vCPU
object instead of hardcoding the ID in ioctl() invocations.

Rename init1/init2 => init0/init1 to avoid having odd/confusing code
where vcpu0 consumes init1 and vcpu1 consumes init2.

Note, this change could easily be done when the functions are converted
in the future, and/or the vcpu{0,1} vs. init{1,2} discrepancy could be
ignored, but then there would be no opportunity to poke fun at the
1-based counting scheme.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/aarch64/vcpu_width_config.c | 60 ++++++++++---------
 1 file changed, 31 insertions(+), 29 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/vcpu_width_config.c b/tools/testing/selftests/kvm/aarch64/vcpu_width_config.c
index 1dd856a58f5d..e4e66632f05c 100644
--- a/tools/testing/selftests/kvm/aarch64/vcpu_width_config.c
+++ b/tools/testing/selftests/kvm/aarch64/vcpu_width_config.c
@@ -15,24 +15,25 @@
 
 
 /*
- * Add a vCPU, run KVM_ARM_VCPU_INIT with @init1, and then
- * add another vCPU, and run KVM_ARM_VCPU_INIT with @init2.
+ * Add a vCPU, run KVM_ARM_VCPU_INIT with @init0, and then
+ * add another vCPU, and run KVM_ARM_VCPU_INIT with @init1.
  */
-static int add_init_2vcpus(struct kvm_vcpu_init *init1,
-			   struct kvm_vcpu_init *init2)
+static int add_init_2vcpus(struct kvm_vcpu_init *init0,
+			   struct kvm_vcpu_init *init1)
 {
+	struct kvm_vcpu *vcpu0, *vcpu1;
 	struct kvm_vm *vm;
 	int ret;
 
 	vm = vm_create_barebones();
 
-	__vm_vcpu_add(vm, 0);
-	ret = __vcpu_ioctl(vm, 0, KVM_ARM_VCPU_INIT, init1);
+	vcpu0 = __vm_vcpu_add(vm, 0);
+	ret = __vcpu_ioctl(vm, vcpu0->id, KVM_ARM_VCPU_INIT, init0);
 	if (ret)
 		goto free_exit;
 
-	__vm_vcpu_add(vm, 1);
-	ret = __vcpu_ioctl(vm, 1, KVM_ARM_VCPU_INIT, init2);
+	vcpu1 = __vm_vcpu_add(vm, 1);
+	ret = __vcpu_ioctl(vm, vcpu1->id, KVM_ARM_VCPU_INIT, init1);
 
 free_exit:
 	kvm_vm_free(vm);
@@ -40,25 +41,26 @@ static int add_init_2vcpus(struct kvm_vcpu_init *init1,
 }
 
 /*
- * Add two vCPUs, then run KVM_ARM_VCPU_INIT for one vCPU with @init1,
- * and run KVM_ARM_VCPU_INIT for another vCPU with @init2.
+ * Add two vCPUs, then run KVM_ARM_VCPU_INIT for one vCPU with @init0,
+ * and run KVM_ARM_VCPU_INIT for another vCPU with @init1.
  */
-static int add_2vcpus_init_2vcpus(struct kvm_vcpu_init *init1,
-				  struct kvm_vcpu_init *init2)
+static int add_2vcpus_init_2vcpus(struct kvm_vcpu_init *init0,
+				  struct kvm_vcpu_init *init1)
 {
+	struct kvm_vcpu *vcpu0, *vcpu1;
 	struct kvm_vm *vm;
 	int ret;
 
 	vm = vm_create_barebones();
 
-	__vm_vcpu_add(vm, 0);
-	__vm_vcpu_add(vm, 1);
+	vcpu0 = __vm_vcpu_add(vm, 0);
+	vcpu1 = __vm_vcpu_add(vm, 1);
 
-	ret = __vcpu_ioctl(vm, 0, KVM_ARM_VCPU_INIT, init1);
+	ret = __vcpu_ioctl(vm, vcpu0->id, KVM_ARM_VCPU_INIT, init0);
 	if (ret)
 		goto free_exit;
 
-	ret = __vcpu_ioctl(vm, 1, KVM_ARM_VCPU_INIT, init2);
+	ret = __vcpu_ioctl(vm, vcpu1->id, KVM_ARM_VCPU_INIT, init1);
 
 free_exit:
 	kvm_vm_free(vm);
@@ -76,7 +78,7 @@ static int add_2vcpus_init_2vcpus(struct kvm_vcpu_init *init1,
  */
 int main(void)
 {
-	struct kvm_vcpu_init init1, init2;
+	struct kvm_vcpu_init init0, init1;
 	struct kvm_vm *vm;
 	int ret;
 
@@ -85,36 +87,36 @@ int main(void)
 		exit(KSFT_SKIP);
 	}
 
-	/* Get the preferred target type and copy that to init2 for later use */
+	/* Get the preferred target type and copy that to init1 for later use */
 	vm = vm_create_barebones();
-	vm_ioctl(vm, KVM_ARM_PREFERRED_TARGET, &init1);
+	vm_ioctl(vm, KVM_ARM_PREFERRED_TARGET, &init0);
 	kvm_vm_free(vm);
-	init2 = init1;
+	init1 = init0;
 
 	/* Test with 64bit vCPUs */
-	ret = add_init_2vcpus(&init1, &init1);
+	ret = add_init_2vcpus(&init0, &init0);
 	TEST_ASSERT(ret == 0,
 		    "Configuring 64bit EL1 vCPUs failed unexpectedly");
-	ret = add_2vcpus_init_2vcpus(&init1, &init1);
+	ret = add_2vcpus_init_2vcpus(&init0, &init0);
 	TEST_ASSERT(ret == 0,
 		    "Configuring 64bit EL1 vCPUs failed unexpectedly");
 
 	/* Test with 32bit vCPUs */
-	init1.features[0] = (1 << KVM_ARM_VCPU_EL1_32BIT);
-	ret = add_init_2vcpus(&init1, &init1);
+	init0.features[0] = (1 << KVM_ARM_VCPU_EL1_32BIT);
+	ret = add_init_2vcpus(&init0, &init0);
 	TEST_ASSERT(ret == 0,
 		    "Configuring 32bit EL1 vCPUs failed unexpectedly");
-	ret = add_2vcpus_init_2vcpus(&init1, &init1);
+	ret = add_2vcpus_init_2vcpus(&init0, &init0);
 	TEST_ASSERT(ret == 0,
 		    "Configuring 32bit EL1 vCPUs failed unexpectedly");
 
 	/* Test with mixed-width vCPUs  */
-	init1.features[0] = 0;
-	init2.features[0] = (1 << KVM_ARM_VCPU_EL1_32BIT);
-	ret = add_init_2vcpus(&init1, &init2);
+	init0.features[0] = 0;
+	init1.features[0] = (1 << KVM_ARM_VCPU_EL1_32BIT);
+	ret = add_init_2vcpus(&init0, &init1);
 	TEST_ASSERT(ret != 0,
 		    "Configuring mixed-width vCPUs worked unexpectedly");
-	ret = add_2vcpus_init_2vcpus(&init1, &init2);
+	ret = add_2vcpus_init_2vcpus(&init0, &init1);
 	TEST_ASSERT(ret != 0,
 		    "Configuring mixed-width vCPUs worked unexpectedly");
 
-- 
2.36.0.464.gb9c8b46e94-goog

