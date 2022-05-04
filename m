Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 286F051B25F
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 00:51:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230337AbiEDWyr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 18:54:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379365AbiEDWx5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 18:53:57 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B4F4115
        for <kvm@vger.kernel.org>; Wed,  4 May 2022 15:50:13 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id s185-20020a632cc2000000b003c18e076a2bso1338913pgs.13
        for <kvm@vger.kernel.org>; Wed, 04 May 2022 15:50:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=KNlMIi/5CD/FZqIH5hea8ZZiDw7T78aX5qVZNF9SKlk=;
        b=Bx0HXgIBdqqfUItCqbnUC6lRO1YyL9mQod1z7AJjwLWNdnw9hysn65hDCROePdpSLh
         baK/HVPYtwiOflMsTXas+WWsAjAH0lX/BYQCpbCEMEzEubx6Zfc7HNgFlNYoQnfFAUPF
         gxQnkJiy0hDCxqGpUfu1jLuYlI4r5Qvc6jNUQgLDnq8hKDxv5xuYWBBwwjb2F+J2fvqU
         iHXPeDrkl6f8KAEOqQTlFe2zN4VCsYCzM3YS/Ga8pkkIBGowwp8d4xaCXzvL1HoRUbuh
         XSZ3HjZiqjxQ1cnYG2avwE+iZm9Yb5omUP9wcFrtwdKuLGeoeAUHPL38cuNhRpVyZT6O
         N80w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=KNlMIi/5CD/FZqIH5hea8ZZiDw7T78aX5qVZNF9SKlk=;
        b=ld1OnTzSsfm0yxNBxmTywOqSmE/gaxjJePejU5gzN09xKmXwWllbF56sUgvU253Yt6
         yoVVUH3+wy4RzQ8KdFho+m4sQqpTRmm2Z+skQbUgRQ7KfymaVy/haCDDXQnxcm2bTcvA
         JyPV4LYHwfaGtcFeeGy0zO82qmHsTFe6VH3Sqnqt5i5K/mmereQya0So5mLw4LIM2AyG
         fpy65RJHqWovWj1iZuLmm2kgeou7UdJ1NJWwtGxci3E8NBSwrGerCVsvmXjorjK15vKF
         Pc1K6Hu+uc7+NSy+yFEfMzJehk6ow6GmFUci6MGlQf+f2lM6HOUR+6pSr7bUo3jDQuCT
         wvJQ==
X-Gm-Message-State: AOAM5328+k3t295c8YnVPhBEmj0EDcYgtbDbzcPMJwKophYwFgkUUR/5
        08NxNysup+GTdlz+bFmoY9GGi3fCo30=
X-Google-Smtp-Source: ABdhPJx1tg43rZpUL2vSpPWkpp3iSZOaDhrPZAHI7pErY2gleGBrUEoeFlINhiiODljj46JGoQvfRH4RSXk=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90a:6501:b0:1ca:a7df:695c with SMTP id
 i1-20020a17090a650100b001caa7df695cmr2262636pjj.152.1651704612814; Wed, 04
 May 2022 15:50:12 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  4 May 2022 22:47:30 +0000
In-Reply-To: <20220504224914.1654036-1-seanjc@google.com>
Message-Id: <20220504224914.1654036-25-seanjc@google.com>
Mime-Version: 1.0
References: <20220504224914.1654036-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH 024/128] KVM: selftests: Multiplex return code and fd in __kvm_create_device()
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

Multiplex the return value and fd (on success) in __kvm_create_device()
to mimic common library helpers that return file descriptors, e.g. open().

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/aarch64/vgic_init.c  |  6 +++---
 .../selftests/kvm/include/kvm_util_base.h        |  2 +-
 tools/testing/selftests/kvm/lib/aarch64/vgic.c   |  5 +++--
 tools/testing/selftests/kvm/lib/kvm_util.c       | 16 +++++++---------
 4 files changed, 14 insertions(+), 15 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/vgic_init.c b/tools/testing/selftests/kvm/aarch64/vgic_init.c
index 18d1d0335108..1015f6fc352c 100644
--- a/tools/testing/selftests/kvm/aarch64/vgic_init.c
+++ b/tools/testing/selftests/kvm/aarch64/vgic_init.c
@@ -642,8 +642,8 @@ static void test_v3_its_region(void)
 int test_kvm_device(uint32_t gic_dev_type)
 {
 	struct vm_gic v;
-	int ret, fd;
 	uint32_t other;
+	int ret;
 
 	v.vm = vm_create_default_with_vcpus(NR_VCPUS, 0, 0, guest_code, NULL);
 
@@ -657,8 +657,8 @@ int test_kvm_device(uint32_t gic_dev_type)
 		return ret;
 	v.gic_fd = kvm_create_device(v.vm, gic_dev_type);
 
-	ret = __kvm_create_device(v.vm, gic_dev_type, &fd);
-	TEST_ASSERT(ret && errno == EEXIST, "create GIC device twice");
+	ret = __kvm_create_device(v.vm, gic_dev_type);
+	TEST_ASSERT(ret < 0 && errno == EEXIST, "create GIC device twice");
 
 	/* try to create the other gic_dev_type */
 	other = VGIC_DEV_IS_V2(gic_dev_type) ? KVM_DEV_TYPE_ARM_VGIC_V3
diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index 8795f4624c2c..1ccf44805fa0 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -485,7 +485,7 @@ void vcpu_args_set(struct kvm_vm *vm, uint32_t vcpuid, unsigned int num, ...);
 int _kvm_device_check_attr(int dev_fd, uint32_t group, uint64_t attr);
 int kvm_device_check_attr(int dev_fd, uint32_t group, uint64_t attr);
 int __kvm_test_create_device(struct kvm_vm *vm, uint64_t type);
-int __kvm_create_device(struct kvm_vm *vm, uint64_t type, int *fd);
+int __kvm_create_device(struct kvm_vm *vm, uint64_t type);
 int kvm_create_device(struct kvm_vm *vm, uint64_t type);
 int _kvm_device_access(int dev_fd, uint32_t group, uint64_t attr,
 		       void *val, bool write);
diff --git a/tools/testing/selftests/kvm/lib/aarch64/vgic.c b/tools/testing/selftests/kvm/lib/aarch64/vgic.c
index 74b4bcaffcfa..7925b4c5dad0 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/vgic.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/vgic.c
@@ -51,8 +51,9 @@ int vgic_v3_setup(struct kvm_vm *vm, unsigned int nr_vcpus, uint32_t nr_irqs,
 			nr_vcpus, nr_vcpus_created);
 
 	/* Distributor setup */
-	if (__kvm_create_device(vm, KVM_DEV_TYPE_ARM_VGIC_V3, &gic_fd))
-		return -1;
+	gic_fd = __kvm_create_device(vm, KVM_DEV_TYPE_ARM_VGIC_V3);
+	if (gic_fd < 0)
+		return gic_fd;
 
 	kvm_device_access(gic_fd, KVM_DEV_ARM_VGIC_GRP_NR_IRQS,
 			0, &nr_irqs, true);
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 9c0122b0e393..17e226107b65 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1639,27 +1639,25 @@ int __kvm_test_create_device(struct kvm_vm *vm, uint64_t type)
 	return __vm_ioctl(vm, KVM_CREATE_DEVICE, &create_dev);
 }
 
-int __kvm_create_device(struct kvm_vm *vm, uint64_t type, int *fd)
+int __kvm_create_device(struct kvm_vm *vm, uint64_t type)
 {
 	struct kvm_create_device create_dev = {
 		.type = type,
 		.fd = -1,
 		.flags = 0,
 	};
-	int ret;
+	int err;
 
-	ret = __vm_ioctl(vm, KVM_CREATE_DEVICE, &create_dev);
-	*fd = create_dev.fd;
-	return ret;
+	err = __vm_ioctl(vm, KVM_CREATE_DEVICE, &create_dev);
+	TEST_ASSERT(err <= 0, "KVM_CREATE_DEVICE shouldn't return a positive value");
+	return err ? : create_dev.fd;
 }
 
 int kvm_create_device(struct kvm_vm *vm, uint64_t type)
 {
-	int fd, ret;
+	int fd = __kvm_create_device(vm, type);
 
-	ret = __kvm_create_device(vm, type, &fd);
-
-	TEST_ASSERT(!ret, "KVM_CREATE_DEVICE IOCTL failed, rc: %i errno: %i", ret, errno);
+	TEST_ASSERT(fd >= 0, "KVM_CREATE_DEVICE IOCTL failed, rc: %i errno: %i", fd, errno);
 	return fd;
 }
 
-- 
2.36.0.464.gb9c8b46e94-goog

