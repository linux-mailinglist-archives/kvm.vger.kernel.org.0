Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC51053C20C
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 04:12:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239077AbiFCAoq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 20:44:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240053AbiFCAoX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 20:44:23 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D6EE37A39
        for <kvm@vger.kernel.org>; Thu,  2 Jun 2022 17:44:21 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id j8-20020a17090a3e0800b001e3425c05c4so3421501pjc.0
        for <kvm@vger.kernel.org>; Thu, 02 Jun 2022 17:44:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=YQR+b5OeEVvL6VtC5wb44JTG7irNUdL3F/WIGJP+RwM=;
        b=DQMUjhQ71Bxj1FyyI1Qz5olUwdGxj1si1kXxQl4K6XyzqNOSDWAKYkIMSiKxRp30uP
         D2YSg4uTj9GU0E89lGlNNmGYKd/K6HS/PaaxX1ZKm6kVAVyWcEHl4kyvfJnbkrsFizyE
         0siOpbqtoMaN5ldAu8t87N5y4Q7tG9A6d6jxmv2gjIv4Fpmz2Rbpz1Vjjt4bDnUtYD9d
         Wlw8PHxmlSOcz09dPCtgs3crefBXOwUFojvq/2ujtwu7AdACRD7RODQVHzGGU1D2ACyu
         nguEyk7PwjTEh1tiH4lgNgPQShmjgKky5Z92OR0wbzpkiUmFUBH3y2DKfWp0vV4Hp10y
         pPRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=YQR+b5OeEVvL6VtC5wb44JTG7irNUdL3F/WIGJP+RwM=;
        b=qpE3OVtoxSInoAXnI8rjqiSJl5p/9UzR/Wrw6UTZi7pOaISPQVKiWhiRTX8xRwC8RD
         nRwTQ+YEVm6Z4pX+30Sn9U2T9GWFSm584WlYy5voNHNOJFmYWq2iwKkQc4fFEFUi9XH8
         JVgC6DH8JJWiNkf3HNar2fQMKeyu6V2VKq8OWShYc3/khtBtW5mTRzUoogU4x5wnO0rM
         GJ6PBnKc1xjXUKQxRPHddOQQArcVDwDHkWDTktK7Vu3Jysfpbh8xOCpl5c+78mtQnJ/J
         w7akc+m7A0HT7h/wLfFBMD+VhYRnS3f7pGd+yf7lmEGixhlLu/aZJuSe7BrQgLrE6Aqb
         rEHA==
X-Gm-Message-State: AOAM532tT35EdHfI6Nsm7JQZxLyI2f1nMI+jbNbzj7yeDESD3vgM6aZl
        /yLF/h8WZV//plL5mrkGhcMflosQAZw=
X-Google-Smtp-Source: ABdhPJzuRv/UJXBKRY7AWWjmJsAVUBl25WV0DIZIRv/Vc9cnp+Afr0NlTJSt5jym7vWQlKkCoY0CEelXJVI=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90a:249:b0:1e0:a8a3:3c6c with SMTP id
 t9-20020a17090a024900b001e0a8a33c6cmr307291pje.0.1654217060998; Thu, 02 Jun
 2022 17:44:20 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  3 Jun 2022 00:41:32 +0000
In-Reply-To: <20220603004331.1523888-1-seanjc@google.com>
Message-Id: <20220603004331.1523888-26-seanjc@google.com>
Mime-Version: 1.0
References: <20220603004331.1523888-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v2 025/144] KVM: selftests: Multiplex return code and fd in __kvm_create_device()
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
index 77ba8a160887..4519ca2a48d1 100644
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
2.36.1.255.ge46751e96f-goog

