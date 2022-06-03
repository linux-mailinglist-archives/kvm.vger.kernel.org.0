Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C480053C32A
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 04:14:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237701AbiFCA5N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 20:57:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240977AbiFCAuT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 20:50:19 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ED962251B
        for <kvm@vger.kernel.org>; Thu,  2 Jun 2022 17:47:28 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id e18-20020a656492000000b003fa4033f9a7so3046202pgv.17
        for <kvm@vger.kernel.org>; Thu, 02 Jun 2022 17:47:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=DKAdsy+CbhbQu5idsYWabteAUIKVcNwzF/4fJTm3POU=;
        b=FGno/y0zjLWs12Taz6KbePN8m9c144rgOp20f5jhnuKd70pSSeW+5LHzDzA9QNhbDK
         wYGBrC8yYQynrn4wSs6j4O0iBbv/UG7JNyGNQM59ALZICqoHpM2jC3e5BPAH6beIxuXY
         CT3mGhrmwIOqmJhJ+G/c6leHQ/qjFU5URgTGSLUV3BtaMjxxAH6M9fJ1TYfuV0fNasdH
         hXRIuUD3dN6FpVLCWRtUIkJjCYy4XEkS8LYaruS+pz23nllOk3K5ZsEyHBea+aGopUrN
         1P0EJm225VLUNMOneXHtD8F77F5avW58sCopdvZMGKKqM6xrEaFlzXlqi3mKcIc2xG9m
         ZEgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=DKAdsy+CbhbQu5idsYWabteAUIKVcNwzF/4fJTm3POU=;
        b=bN3ylu84Pc1Al1h8eKZY7o0L9kFofuaHUPEbn5ZDqwKNN51K1XDWZwlkr8/iN1+Iqy
         QRnWppAbBTwFcg4vIkJW3cFPTStMONsfE9LVli0rY0DTg+e2BN48IhF86ALKnLzivZ0W
         luh/nBB9UScPJNWHUDYeNB0pZ43LtoNSFJmIbhpNDMTtd6xit4Mkv9FgAA4hvvwg2/Og
         HxX3w1oBVT0JKSkweuC2zl2GXwLOad1+6n15dG63hp8Ns1vIHnzTR6MNHLgfcupB0YH2
         fc/PiCLDzbdsZEa5QmyhqW8YppsijZ0EgHGgT7CFV9FpBWopnPnxtIDF7GTgw8Q062q/
         G6aQ==
X-Gm-Message-State: AOAM531PM0QJC4AdQJONuyb4/34yT5vtDJd30ytqcmXY3WqFhhstftjv
        aenhAvhQ/EiyzuAMFfcbb6jK/6tvvVM=
X-Google-Smtp-Source: ABdhPJxae9DqBW/W2fOFOGwcmGTuIhm7PePm2k8oFnbO+zZVyH/np/0gy0x+Z0AuQTMQ2TUTGOfE+Nsikzw=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90a:249:b0:1e0:a8a3:3c6c with SMTP id
 t9-20020a17090a024900b001e0a8a33c6cmr307330pje.0.1654217247683; Thu, 02 Jun
 2022 17:47:27 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  3 Jun 2022 00:43:15 +0000
In-Reply-To: <20220603004331.1523888-1-seanjc@google.com>
Message-Id: <20220603004331.1523888-129-seanjc@google.com>
Mime-Version: 1.0
References: <20220603004331.1523888-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v2 128/144] KVM: selftests: Stop hardcoding vCPU IDs in vcpu_width_config
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
2.36.1.255.ge46751e96f-goog

