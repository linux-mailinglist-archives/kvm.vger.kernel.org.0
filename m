Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08A9851B2A9
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 01:23:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379626AbiEDW4w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 18:56:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379353AbiEDWxz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 18:53:55 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9242C53B7A
        for <kvm@vger.kernel.org>; Wed,  4 May 2022 15:50:11 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id q14-20020a17090a178e00b001dc970bf587so1942859pja.1
        for <kvm@vger.kernel.org>; Wed, 04 May 2022 15:50:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=w5Ek3pNn+zgpTimrLM2NeiBwJXLo+yC/AOU9ElYI0s8=;
        b=MopPeM3N8fxIAPiwK1n3koAqXWH+OgyMbJXC561jYAYh0TJQiham7PbUAMpy6eNruO
         Kz6L2OZteF8qFLF7U8b1fotng8TpL6/mMQCRJHm3sL+mzA3jgxyk3Dmx3z0iul1EuNuk
         9D71VbfCPrT2RQlVntdgT6q7OVC/h/Aro0j9cUqSrG7ZmVpqtV4wI9/8Fydh8EAqU5jG
         E0/x5L8oKHD7cW7mTOYTo9DSt3XdzIvD5T2wuB5T/3QPA7VB2iSNBPCBwHJvbwA3oy6L
         wfDkf94LVQF95glWMEKh1V0SCf3JbuEocK4Zl4tTYazPLUwO8mavCO/S7K59JTKTXwfv
         yaRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=w5Ek3pNn+zgpTimrLM2NeiBwJXLo+yC/AOU9ElYI0s8=;
        b=WPbcqjbsIe2OS6Nc/2sKWyjZktH9lHaabUdWB+ugU8tu/adBOM7yy/wdLUgFPsvXp7
         HOeghAzNwcWqV0wyU/zKKHhLIAugRlP12NyKNCTzyvZir9v+sFqPL6ZGgS+jGu3WDxly
         3yderaxQFUfM/CvY1lxsAKwt3Lv4xJ9beoBQs3CqFTybrvyRL+fe0KQn/g8cCV27nndV
         PglIM2Y/BuejPa2lTmiH4xuJWBG4gAmjVztMV3+fY0g2zlsgjdjAMiVpkm3zbodqOyXq
         kUioix6Ht3R6MTT+Y1S3Ed2yb0fZbKrqN9oOg9PoKPwzQrFSIFSpYemQ2bI3d1EmVEH7
         4g8w==
X-Gm-Message-State: AOAM532wecJoEIQ1ckotqpeYWFNMvm6/ikDtz0QCs9wrdZenXuk5lEH/
        WQEYBBdUK5B/5lKxplefVJqZrDyQ3SI=
X-Google-Smtp-Source: ABdhPJy8mF106ymdK7WcXSxN1PdSCxKU8bMX1yGpTZitke2REvLbdTt4LlT5LiQUmOaESc00oKXKN/z8RaM=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90a:c002:b0:1d9:250a:73c8 with SMTP id
 p2-20020a17090ac00200b001d9250a73c8mr2161247pjt.133.1651704611101; Wed, 04
 May 2022 15:50:11 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  4 May 2022 22:47:29 +0000
In-Reply-To: <20220504224914.1654036-1-seanjc@google.com>
Message-Id: <20220504224914.1654036-24-seanjc@google.com>
Mime-Version: 1.0
References: <20220504224914.1654036-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH 023/128] KVM: selftests: Move KVM_CREATE_DEVICE_TEST code to
 separate helper
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

Move KVM_CREATE_DEVICE_TEST to its own helper, identifying "real" versus
"test" device creation based on a hardcoded boolean buried in the middle
of a param list is painful for readers.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../testing/selftests/kvm/aarch64/vgic_init.c | 10 ++++----
 .../selftests/kvm/include/kvm_util_base.h     |  3 ++-
 .../testing/selftests/kvm/lib/aarch64/vgic.c  |  3 +--
 tools/testing/selftests/kvm/lib/kvm_util.c    | 23 ++++++++++++++-----
 4 files changed, 25 insertions(+), 14 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/vgic_init.c b/tools/testing/selftests/kvm/aarch64/vgic_init.c
index 9cd58f22f5bd..18d1d0335108 100644
--- a/tools/testing/selftests/kvm/aarch64/vgic_init.c
+++ b/tools/testing/selftests/kvm/aarch64/vgic_init.c
@@ -648,24 +648,24 @@ int test_kvm_device(uint32_t gic_dev_type)
 	v.vm = vm_create_default_with_vcpus(NR_VCPUS, 0, 0, guest_code, NULL);
 
 	/* try to create a non existing KVM device */
-	ret = _kvm_create_device(v.vm, 0, true, &fd);
+	ret = __kvm_test_create_device(v.vm, 0);
 	TEST_ASSERT(ret && errno == ENODEV, "unsupported device");
 
 	/* trial mode */
-	ret = _kvm_create_device(v.vm, gic_dev_type, true, &fd);
+	ret = __kvm_test_create_device(v.vm, gic_dev_type);
 	if (ret)
 		return ret;
 	v.gic_fd = kvm_create_device(v.vm, gic_dev_type);
 
-	ret = _kvm_create_device(v.vm, gic_dev_type, false, &fd);
+	ret = __kvm_create_device(v.vm, gic_dev_type, &fd);
 	TEST_ASSERT(ret && errno == EEXIST, "create GIC device twice");
 
 	/* try to create the other gic_dev_type */
 	other = VGIC_DEV_IS_V2(gic_dev_type) ? KVM_DEV_TYPE_ARM_VGIC_V3
 					     : KVM_DEV_TYPE_ARM_VGIC_V2;
 
-	if (!_kvm_create_device(v.vm, other, true, &fd)) {
-		ret = _kvm_create_device(v.vm, other, false, &fd);
+	if (!__kvm_test_create_device(v.vm, other)) {
+		ret = __kvm_test_create_device(v.vm, other);
 		TEST_ASSERT(ret && errno == EINVAL,
 				"create GIC device while other version exists");
 	}
diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index 6e1926abb248..8795f4624c2c 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -484,7 +484,8 @@ void vcpu_args_set(struct kvm_vm *vm, uint32_t vcpuid, unsigned int num, ...);
 
 int _kvm_device_check_attr(int dev_fd, uint32_t group, uint64_t attr);
 int kvm_device_check_attr(int dev_fd, uint32_t group, uint64_t attr);
-int _kvm_create_device(struct kvm_vm *vm, uint64_t type, bool test, int *fd);
+int __kvm_test_create_device(struct kvm_vm *vm, uint64_t type);
+int __kvm_create_device(struct kvm_vm *vm, uint64_t type, int *fd);
 int kvm_create_device(struct kvm_vm *vm, uint64_t type);
 int _kvm_device_access(int dev_fd, uint32_t group, uint64_t attr,
 		       void *val, bool write);
diff --git a/tools/testing/selftests/kvm/lib/aarch64/vgic.c b/tools/testing/selftests/kvm/lib/aarch64/vgic.c
index c34f0f116f39..74b4bcaffcfa 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/vgic.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/vgic.c
@@ -51,8 +51,7 @@ int vgic_v3_setup(struct kvm_vm *vm, unsigned int nr_vcpus, uint32_t nr_irqs,
 			nr_vcpus, nr_vcpus_created);
 
 	/* Distributor setup */
-	if (_kvm_create_device(vm, KVM_DEV_TYPE_ARM_VGIC_V3,
-			       false, &gic_fd) != 0)
+	if (__kvm_create_device(vm, KVM_DEV_TYPE_ARM_VGIC_V3, &gic_fd))
 		return -1;
 
 	kvm_device_access(gic_fd, KVM_DEV_ARM_VGIC_GRP_NR_IRQS,
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index cb2e42aa1c03..9c0122b0e393 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1629,14 +1629,25 @@ int kvm_device_check_attr(int dev_fd, uint32_t group, uint64_t attr)
 	return ret;
 }
 
-int _kvm_create_device(struct kvm_vm *vm, uint64_t type, bool test, int *fd)
+int __kvm_test_create_device(struct kvm_vm *vm, uint64_t type)
 {
-	struct kvm_create_device create_dev;
+	struct kvm_create_device create_dev = {
+		.type = type,
+		.flags = KVM_CREATE_DEVICE_TEST,
+	};
+
+	return __vm_ioctl(vm, KVM_CREATE_DEVICE, &create_dev);
+}
+
+int __kvm_create_device(struct kvm_vm *vm, uint64_t type, int *fd)
+{
+	struct kvm_create_device create_dev = {
+		.type = type,
+		.fd = -1,
+		.flags = 0,
+	};
 	int ret;
 
-	create_dev.type = type;
-	create_dev.fd = -1;
-	create_dev.flags = test ? KVM_CREATE_DEVICE_TEST : 0;
 	ret = __vm_ioctl(vm, KVM_CREATE_DEVICE, &create_dev);
 	*fd = create_dev.fd;
 	return ret;
@@ -1646,7 +1657,7 @@ int kvm_create_device(struct kvm_vm *vm, uint64_t type)
 {
 	int fd, ret;
 
-	ret = _kvm_create_device(vm, type, false, &fd);
+	ret = __kvm_create_device(vm, type, &fd);
 
 	TEST_ASSERT(!ret, "KVM_CREATE_DEVICE IOCTL failed, rc: %i errno: %i", ret, errno);
 	return fd;
-- 
2.36.0.464.gb9c8b46e94-goog

