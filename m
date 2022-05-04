Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A506C51B269
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 00:51:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379335AbiEDWyt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 18:54:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379399AbiEDWyC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 18:54:02 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACF2A1007
        for <kvm@vger.kernel.org>; Wed,  4 May 2022 15:50:17 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id q14-20020a17090a178e00b001dc970bf587so1942957pja.1
        for <kvm@vger.kernel.org>; Wed, 04 May 2022 15:50:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=ABkJ+xdsSyQQbclWdh79qI/Sw/9eZJ1mPAtO9vDn39s=;
        b=ZFsZLeKwKy56ZE1YxkyRcVbhtV7DjPQTGIahWMWPeW7ihhZlH1tAM+qMNmJZCiuLg0
         wUefZU0fpxlMPZhFJn8b3DjoNIBQxWZXg2hyw+NJGBQ6TYJkluvYPJfE7NQWhGp3ZeYI
         kbNDg/8UvHvJtEBaXciPZ3KWpAHA8XoW9gERptHaxNwtvKevLazYnaKznCUYHCG4L5mV
         pKGSzSBz4wCucZEzeaZ7AZitmjxFoBYAwRGNI/Mze0PQ8GJU7nZDLB/BO8ncwChPT7wY
         1UZqUP+UA3AuBxIudKF1PrLYLzcWTOKSzwBXtzu529NIxx3v+Pi5fydMb71PgSzfjTEK
         vuOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=ABkJ+xdsSyQQbclWdh79qI/Sw/9eZJ1mPAtO9vDn39s=;
        b=bQaME93Qc0C4qwxneaED5H8IKnlpKhWm13Vg/6CFzLKWHFlHIIYgDQVKn5h/vpM3e4
         BPYYZMlihdEXbsGzomQ2AwF4sllkPnDhFry4rqc9cjYP26klqchL5PUZoXlpoSY/cWl9
         SWBtdjrUtC7kRitO92lWE1D4sdkPoNpZcbnV8by0+i8yvoE4dz68PmhdPC4DkVxcQb/9
         euXLtRBGkofCqWwFEI1SRA2uODS9kCspl/PL/K5sNHS8dM2L1ECYFw3+WwSE1ZDbEHpd
         LbzOq4Ctfk/lwFIxWhHZLWhx8DHeDNp6AywMc4FDbdbYKdXSl7eZaoNfvniJqoZ85CPY
         vI3A==
X-Gm-Message-State: AOAM532r2XWcb/aquGURx9AV+rNnF/3INBwJs8KeQPw99MIRIpxGtkr5
        F8NERC0kZhkNCbliWoMBKx7zaJc3TAY=
X-Google-Smtp-Source: ABdhPJyFvrQg8+REjJN/9YrdzQsl2xKTXMuWGDaxYXcUh8fxtH8+FwCyziWCoj1TgYa1fgF9OyQie/zhLdY=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:a5c4:b0:15d:4ca:90cf with SMTP id
 t4-20020a170902a5c400b0015d04ca90cfmr23951338plq.133.1651704616542; Wed, 04
 May 2022 15:50:16 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  4 May 2022 22:47:32 +0000
In-Reply-To: <20220504224914.1654036-1-seanjc@google.com>
Message-Id: <20220504224914.1654036-27-seanjc@google.com>
Mime-Version: 1.0
References: <20220504224914.1654036-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH 026/128] KVM: selftests: Drop 'int' return from asserting *_has_device_attr()
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

Drop 'int' returns from *_device_has_attr() helpers that assert the
return is '0', there's no point in returning '0' and "requiring" the
caller to perform a redundant assertion.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../testing/selftests/kvm/aarch64/vgic_init.c |  4 ++--
 .../selftests/kvm/include/kvm_util_base.h     | 20 ++++++++++++++++---
 tools/testing/selftests/kvm/lib/kvm_util.c    | 17 ----------------
 3 files changed, 19 insertions(+), 22 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/vgic_init.c b/tools/testing/selftests/kvm/aarch64/vgic_init.c
index 223fef4c1f62..2425894b3775 100644
--- a/tools/testing/selftests/kvm/aarch64/vgic_init.c
+++ b/tools/testing/selftests/kvm/aarch64/vgic_init.c
@@ -201,8 +201,8 @@ static void subtest_v3_redist_regions(struct vm_gic *v)
 	uint64_t addr, expected_addr;
 	int ret;
 
-	ret = kvm_has_device_attr(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
-				     KVM_VGIC_V3_ADDR_TYPE_REDIST);
+	ret = __kvm_has_device_attr(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				    KVM_VGIC_V3_ADDR_TYPE_REDIST);
 	TEST_ASSERT(!ret, "Multiple redist regions advertised");
 
 	addr = REDIST_REGION_ATTR_ADDR(NR_VCPUS, 0x100000, 2, 0);
diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index 66d896c8e19b..f9aeac540699 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -483,7 +483,14 @@ void *vcpu_map_dirty_ring(struct kvm_vm *vm, uint32_t vcpuid);
 void vcpu_args_set(struct kvm_vm *vm, uint32_t vcpuid, unsigned int num, ...);
 
 int __kvm_has_device_attr(int dev_fd, uint32_t group, uint64_t attr);
-int kvm_has_device_attr(int dev_fd, uint32_t group, uint64_t attr);
+
+static inline void kvm_has_device_attr(int dev_fd, uint32_t group, uint64_t attr)
+{
+	int ret = __kvm_has_device_attr(dev_fd, group, attr);
+
+	TEST_ASSERT(!ret, "KVM_HAS_DEVICE_ATTR failed, rc: %i errno: %i", ret, errno);
+}
+
 int __kvm_test_create_device(struct kvm_vm *vm, uint64_t type);
 int __kvm_create_device(struct kvm_vm *vm, uint64_t type);
 int kvm_create_device(struct kvm_vm *vm, uint64_t type);
@@ -496,8 +503,15 @@ int _kvm_irq_line(struct kvm_vm *vm, uint32_t irq, int level);
 
 int __vcpu_has_device_attr(struct kvm_vm *vm, uint32_t vcpuid, uint32_t group,
 			  uint64_t attr);
-int vcpu_has_device_attr(struct kvm_vm *vm, uint32_t vcpuid, uint32_t group,
-			 uint64_t attr);
+
+static inline void vcpu_has_device_attr(struct kvm_vm *vm, uint32_t vcpuid,
+					uint32_t group, uint64_t attr)
+{
+	int ret = __vcpu_has_device_attr(vm, vcpuid, group, attr);
+
+	TEST_ASSERT(!ret, KVM_IOCTL_ERROR(KVM_HAS_DEVICE_ATTR, ret));
+}
+
 int _vcpu_access_device_attr(struct kvm_vm *vm, uint32_t vcpuid, uint32_t group,
 			  uint64_t attr, void *val, bool write);
 int vcpu_access_device_attr(struct kvm_vm *vm, uint32_t vcpuid, uint32_t group,
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index ca313dc8b37a..a7bc6b623871 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1621,14 +1621,6 @@ int __kvm_has_device_attr(int dev_fd, uint32_t group, uint64_t attr)
 	return ioctl(dev_fd, KVM_HAS_DEVICE_ATTR, &attribute);
 }
 
-int kvm_has_device_attr(int dev_fd, uint32_t group, uint64_t attr)
-{
-	int ret = __kvm_has_device_attr(dev_fd, group, attr);
-
-	TEST_ASSERT(!ret, "KVM_HAS_DEVICE_ATTR failed, rc: %i errno: %i", ret, errno);
-	return ret;
-}
-
 int __kvm_test_create_device(struct kvm_vm *vm, uint64_t type)
 {
 	struct kvm_create_device create_dev = {
@@ -1694,15 +1686,6 @@ int __vcpu_has_device_attr(struct kvm_vm *vm, uint32_t vcpuid, uint32_t group,
 	return __kvm_has_device_attr(vcpu->fd, group, attr);
 }
 
-int vcpu_has_device_attr(struct kvm_vm *vm, uint32_t vcpuid, uint32_t group,
-				 uint64_t attr)
-{
-	int ret = __vcpu_has_device_attr(vm, vcpuid, group, attr);
-
-	TEST_ASSERT(!ret, "KVM_HAS_DEVICE_ATTR IOCTL failed, rc: %i errno: %i", ret, errno);
-	return ret;
-}
-
 int _vcpu_access_device_attr(struct kvm_vm *vm, uint32_t vcpuid, uint32_t group,
 			     uint64_t attr, void *val, bool write)
 {
-- 
2.36.0.464.gb9c8b46e94-goog

