Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC39F51B25C
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 00:51:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352149AbiEDWyn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 18:54:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379338AbiEDWxy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 18:53:54 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04B4554199
        for <kvm@vger.kernel.org>; Wed,  4 May 2022 15:50:10 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id m6-20020a17090a730600b001d9041534e4so1076154pjk.7
        for <kvm@vger.kernel.org>; Wed, 04 May 2022 15:50:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=9MYqVcaHqXemKrQxjWs3On/yC1RfQIL11OGjYRaSgOM=;
        b=FsbWapnOxw+aJpu2dQXg5tRUbDM3UKFkFMUYQ94yQ2sULr3pEbwriHNABnvbACsrhW
         Uq6itWrAWng5bSmX5LoAPkm2tL+6J2vT0KZQ1JPoDLed9ab30kgngTC4munf8zjml2v5
         BvBN/rPivO9t55c+jyqcao7I7b2vCHzAYcbcf+7IzK0Q5V1HW7uM/owiQhjUJyv4ojMV
         rTebazwSY1Yk5KCPD2QiaFfWsolNFjnA25MTeheuv9+ZiZuHAHaAW55onfMXyEmsZTG2
         LYWemW3vgwmkVKGysOrcJC37C3f43yceeen3IntU5aFNeUX/kVmskepv2otKv188Pyxj
         gsrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=9MYqVcaHqXemKrQxjWs3On/yC1RfQIL11OGjYRaSgOM=;
        b=8HnUFjLKDGi2ByJkQGA0mH81SOD3fKlo2apU6mRw7wwevH+OpALegJIrIh9ZKohuUJ
         L8QqCaIQbAnptME05BG8oP5UqXJBvyYY4l7Wg8bPWiav9cm0yNuQcPqc1d3qEIAh19+D
         f78l4BlNQxIZkbeBa28Bi5qj40JUTHjDMKDsNbKIvmwRc6/uvp6/LYZv34V1nk31Eofw
         rn6fTQYFUhidYKo3NyQA16I0UEfSIVyBAtV18LoMYBF7jWJjvm4/IyNVfpgxB341Jut/
         YeqcnKa58jLS5Zkfu2IC1K3etX81B2nX4DPiMeFSPI0KfE9I7Mi2qmY6GlcsUncnlYAY
         awUQ==
X-Gm-Message-State: AOAM5335PpJkDrkCBFvDj6hO31Es+g/MvLP8C7t/UC8kZaImv0xHfAi8
        zFJ2YJnC7/UlVeroKdM9nYEuRIs7hls=
X-Google-Smtp-Source: ABdhPJwD6QMoI+HXifXgxvIHBwuUXwD0JHYrffG0bTubcmw4tYm4XyClCI1Q8P+9XSz8+p+RgAIJNDfh6SA=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:21c6:b0:4fa:914c:2c2b with SMTP id
 t6-20020a056a0021c600b004fa914c2c2bmr22967081pfj.56.1651704609534; Wed, 04
 May 2022 15:50:09 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  4 May 2022 22:47:28 +0000
In-Reply-To: <20220504224914.1654036-1-seanjc@google.com>
Message-Id: <20220504224914.1654036-23-seanjc@google.com>
Mime-Version: 1.0
References: <20220504224914.1654036-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH 022/128] KVM: selftests: Drop @test param from kvm_create_device()
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

Remove the two calls that pass @test=true to kvm_create_device() and drop
the @test param entirely.  The two removed calls don't check the return
value of kvm_create_device(), so other than verifying KVM doesn't explode,
which is extremely unlikely given that the non-test variant was _just_
called, they are pointless and provide no validation coverage.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/aarch64/vgic_init.c    | 14 ++++++--------
 .../testing/selftests/kvm/include/kvm_util_base.h  |  2 +-
 tools/testing/selftests/kvm/lib/kvm_util.c         | 12 ++++--------
 3 files changed, 11 insertions(+), 17 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/vgic_init.c b/tools/testing/selftests/kvm/aarch64/vgic_init.c
index 9a153b2ea3de..9cd58f22f5bd 100644
--- a/tools/testing/selftests/kvm/aarch64/vgic_init.c
+++ b/tools/testing/selftests/kvm/aarch64/vgic_init.c
@@ -65,7 +65,7 @@ static struct vm_gic vm_gic_create_with_vcpus(uint32_t gic_dev_type, uint32_t nr
 
 	v.gic_dev_type = gic_dev_type;
 	v.vm = vm_create_default_with_vcpus(nr_vcpus, 0, 0, guest_code, NULL);
-	v.gic_fd = kvm_create_device(v.vm, gic_dev_type, false);
+	v.gic_fd = kvm_create_device(v.vm, gic_dev_type);
 
 	return v;
 }
@@ -406,7 +406,7 @@ static void test_v3_typer_accesses(void)
 
 	v.vm = vm_create_default(0, 0, guest_code);
 
-	v.gic_fd = kvm_create_device(v.vm, KVM_DEV_TYPE_ARM_VGIC_V3, false);
+	v.gic_fd = kvm_create_device(v.vm, KVM_DEV_TYPE_ARM_VGIC_V3);
 
 	vm_vcpu_add_default(v.vm, 3, guest_code);
 
@@ -486,7 +486,7 @@ static void test_v3_last_bit_redist_regions(void)
 
 	v.vm = vm_create_default_with_vcpus(6, 0, 0, guest_code, vcpuids);
 
-	v.gic_fd = kvm_create_device(v.vm, KVM_DEV_TYPE_ARM_VGIC_V3, false);
+	v.gic_fd = kvm_create_device(v.vm, KVM_DEV_TYPE_ARM_VGIC_V3);
 
 	kvm_device_access(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
 			  KVM_DEV_ARM_VGIC_CTRL_INIT, NULL, true);
@@ -535,7 +535,7 @@ static void test_v3_last_bit_single_rdist(void)
 
 	v.vm = vm_create_default_with_vcpus(6, 0, 0, guest_code, vcpuids);
 
-	v.gic_fd = kvm_create_device(v.vm, KVM_DEV_TYPE_ARM_VGIC_V3, false);
+	v.gic_fd = kvm_create_device(v.vm, KVM_DEV_TYPE_ARM_VGIC_V3);
 
 	kvm_device_access(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
 			  KVM_DEV_ARM_VGIC_CTRL_INIT, NULL, true);
@@ -602,7 +602,7 @@ static void test_v3_its_region(void)
 	int its_fd, ret;
 
 	v = vm_gic_create_with_vcpus(KVM_DEV_TYPE_ARM_VGIC_V3, NR_VCPUS);
-	its_fd = kvm_create_device(v.vm, KVM_DEV_TYPE_ARM_VGIC_ITS, false);
+	its_fd = kvm_create_device(v.vm, KVM_DEV_TYPE_ARM_VGIC_ITS);
 
 	addr = 0x401000;
 	ret = _kvm_device_access(its_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
@@ -655,13 +655,11 @@ int test_kvm_device(uint32_t gic_dev_type)
 	ret = _kvm_create_device(v.vm, gic_dev_type, true, &fd);
 	if (ret)
 		return ret;
-	v.gic_fd = kvm_create_device(v.vm, gic_dev_type, false);
+	v.gic_fd = kvm_create_device(v.vm, gic_dev_type);
 
 	ret = _kvm_create_device(v.vm, gic_dev_type, false, &fd);
 	TEST_ASSERT(ret && errno == EEXIST, "create GIC device twice");
 
-	kvm_create_device(v.vm, gic_dev_type, true);
-
 	/* try to create the other gic_dev_type */
 	other = VGIC_DEV_IS_V2(gic_dev_type) ? KVM_DEV_TYPE_ARM_VGIC_V3
 					     : KVM_DEV_TYPE_ARM_VGIC_V2;
diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index c0199f3b59bb..6e1926abb248 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -485,7 +485,7 @@ void vcpu_args_set(struct kvm_vm *vm, uint32_t vcpuid, unsigned int num, ...);
 int _kvm_device_check_attr(int dev_fd, uint32_t group, uint64_t attr);
 int kvm_device_check_attr(int dev_fd, uint32_t group, uint64_t attr);
 int _kvm_create_device(struct kvm_vm *vm, uint64_t type, bool test, int *fd);
-int kvm_create_device(struct kvm_vm *vm, uint64_t type, bool test);
+int kvm_create_device(struct kvm_vm *vm, uint64_t type);
 int _kvm_device_access(int dev_fd, uint32_t group, uint64_t attr,
 		       void *val, bool write);
 int kvm_device_access(int dev_fd, uint32_t group, uint64_t attr,
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index a57958a39c1b..cb2e42aa1c03 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1642,18 +1642,14 @@ int _kvm_create_device(struct kvm_vm *vm, uint64_t type, bool test, int *fd)
 	return ret;
 }
 
-int kvm_create_device(struct kvm_vm *vm, uint64_t type, bool test)
+int kvm_create_device(struct kvm_vm *vm, uint64_t type)
 {
 	int fd, ret;
 
-	ret = _kvm_create_device(vm, type, test, &fd);
+	ret = _kvm_create_device(vm, type, false, &fd);
 
-	if (!test) {
-		TEST_ASSERT(!ret,
-			    "KVM_CREATE_DEVICE IOCTL failed, rc: %i errno: %i", ret, errno);
-		return fd;
-	}
-	return ret;
+	TEST_ASSERT(!ret, "KVM_CREATE_DEVICE IOCTL failed, rc: %i errno: %i", ret, errno);
+	return fd;
 }
 
 int _kvm_device_access(int dev_fd, uint32_t group, uint64_t attr,
-- 
2.36.0.464.gb9c8b46e94-goog

