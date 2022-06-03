Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1C6053C26E
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 04:13:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240039AbiFCAok (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 20:44:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240048AbiFCAoX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 20:44:23 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88D3E37A3A
        for <kvm@vger.kernel.org>; Thu,  2 Jun 2022 17:44:19 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id q13-20020a65624d000000b003fa74c57243so3039887pgv.19
        for <kvm@vger.kernel.org>; Thu, 02 Jun 2022 17:44:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=k1Q42T/S1yGxYqwtKybSTPfRe2IMMYvCe2uCWIlmgTA=;
        b=ebkLZ0HK3dOEvtoudU28vFAk9x01xfHmY1dxW8/4g9TCe5ceH/j4/zL0WvK/IL3N5K
         +aE9C0CI/fP6PAc4sQwaP5xIWAFcYCB6lcDcfd0bbyaSsi2G8FiB6c9SsTnaq7mWgW/C
         TGHRc+Ifha8DHVYsVXsBFZI3PkdNFwHYROzPTbDyJxPlhhLBnYxilmZy2zFkmbzvoyCi
         jHEeFUjJKT4FvkOmBwiNXtkzG2j7GHuv1Ok9MYLJBT9uVGCHiIC0L1T2Tx2xabuIPzf3
         O5vfigYVGuqR4eFy5A2XTyEtZN5+2+OzN3DWNyUNKZJPpVPaFvnU9OV1HSaLyESdJ/CT
         msww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=k1Q42T/S1yGxYqwtKybSTPfRe2IMMYvCe2uCWIlmgTA=;
        b=VT3HUBTOBbnl8nxXioSLRDLOesR+AuyAqImELpMrSYUdXNB0TcnL9pAVSiLQ+lEx2/
         58q3SRwNvpdHIdfcO3QS1UB8OjldaR+K3KMyAMPDamX/X3QGc8Q8zivqcs1mguEcd2/B
         w0vktowDkQU3J3Jp5IU6SFY7KM0Fp6cZoFoTGFJzy3xAYVRjRs9D+CMMvgN09QGA1oCI
         XAcRCXpvIMFVv1a2aird+OUXSRaBnZUrB5Hjr/i6YMqS3CGMUf79W7uqGbprhaBlwfuN
         xjTk4rVX8mWAsyFmZ8lhG74IsKGxOKri5QFE79dxhOfoc74W+KiJB6gWMSvyaNQu9hoE
         VLFQ==
X-Gm-Message-State: AOAM532WKlnx2TN6l2xvZToUrHcrC7qaQz4hi15kRDDyWiU+OR4vkPEo
        MeKbV4VaDzbQ8EaR7Rxa1kn0vEWLTQQ=
X-Google-Smtp-Source: ABdhPJyE/Hx8D/Xb1v7h3qXbULKPRJHSfomSLoJ8sU/LXNsLbL6qodc91CH5RRQ9x2zACWn74bxsNWHgmCo=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:338e:b0:51b:c452:4210 with SMTP id
 cm14-20020a056a00338e00b0051bc4524210mr6976736pfb.69.1654217059225; Thu, 02
 Jun 2022 17:44:19 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  3 Jun 2022 00:41:31 +0000
In-Reply-To: <20220603004331.1523888-1-seanjc@google.com>
Message-Id: <20220603004331.1523888-25-seanjc@google.com>
Mime-Version: 1.0
References: <20220603004331.1523888-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v2 024/144] KVM: selftests: Move KVM_CREATE_DEVICE_TEST code
 to separate helper
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
index 48b795eadafd..77ba8a160887 100644
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
2.36.1.255.ge46751e96f-goog

