Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95A6453C270
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 04:13:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240023AbiFCAor (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 20:44:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240066AbiFCAo1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 20:44:27 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD0FF344D8
        for <kvm@vger.kernel.org>; Thu,  2 Jun 2022 17:44:25 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id y4-20020a17090322c400b001637287812bso3475428plg.6
        for <kvm@vger.kernel.org>; Thu, 02 Jun 2022 17:44:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=fWVU4G9FQ3711ydUOpFRiGOBFG7oKk9mO87RLDsuxUU=;
        b=TEkHSIOjYwi4/FOo/GsXvu1uiP1Iwkpn3Q3rZDi2pJ3dL57pxhZRtq04be6Pr1QFaj
         NyRMNZeK534nnse4Yn6IzfaXkWhwaaY7mr2f7GlMigBRzWiHIh9sq1wPEsejVVLLRQIh
         mrKZ3a21XUM99zPMTNoONp6N9k/fULyL3cJHuBV2Q+lezovgGu8BzWBbRdqBU4avizXO
         0SV/yaY93+ntMBqc03uEvRZ5O9aIL1NrAbZdf9q4Gv3pG6eJliF9EzzljEpDeWwMsnp4
         nZJZgdQS0NsF0XTNSNHIHJGzQQf7vvQPZZJp8PI3N1wV+RT8W0dQheQXp+izM1UqdVzN
         S89w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=fWVU4G9FQ3711ydUOpFRiGOBFG7oKk9mO87RLDsuxUU=;
        b=zK3V6XXDu4FAN91FPIr4+jOk0vb47TbYwPExR/15kGHz1tcTQXbD5qNxnLIGsNALBg
         550IuFiZe6EXEahFcdZX4lzS+Uw4DFknibV7awvrwV7lX3vS7pgUUmQKFlsV8L1wz2gj
         uqbRXRhvOaNGkrLZYaTL1C1zbuL5Xh8tMl5Q6+KbDxHlAXqbbyCPuZqDH7NeYidyPgwE
         ojI9dgDv0K1v8TpLR1TRaq/Z5jQF+TrwppFcgCxKqfA1xyh6wat94Nxk0g4SOX1zFfhI
         jri8/PNZDAs0kPD+wnqZZW0A0ZmjwiLU/28p5F+rE7JPb2frNXNeu8/CzQToZSdvvoTu
         6atg==
X-Gm-Message-State: AOAM532lUGZnaIwLux0L4sEUpwR95KUrOm5tsArRPq8qZpVdcTl/8lQr
        jlgkK5yvyeHwIHJpafDPVugcHyiJ0VE=
X-Google-Smtp-Source: ABdhPJyGLKO8icLCJiPXLDXyjUv0YbG/oYOZvjEGh7qGX8nPj+jO28x3Axg5YukBRqRzpmtcqpOPAVlxO1w=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:e5d2:b0:164:1958:c858 with SMTP id
 u18-20020a170902e5d200b001641958c858mr7701148plf.62.1654217065282; Thu, 02
 Jun 2022 17:44:25 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  3 Jun 2022 00:41:34 +0000
In-Reply-To: <20220603004331.1523888-1-seanjc@google.com>
Message-Id: <20220603004331.1523888-28-seanjc@google.com>
Mime-Version: 1.0
References: <20220603004331.1523888-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v2 027/144] KVM: selftests: Drop 'int' return from asserting *_has_device_attr()
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
index 3aecf097969a..a692bb74fed8 100644
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
2.36.1.255.ge46751e96f-goog

