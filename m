Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43885421BC2
	for <lists+kvm@lfdr.de>; Tue,  5 Oct 2021 03:19:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231137AbhJEBV0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Oct 2021 21:21:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230510AbhJEBVZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Oct 2021 21:21:25 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 965C1C061745
        for <kvm@vger.kernel.org>; Mon,  4 Oct 2021 18:19:35 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id h10-20020ac8584a000000b002a712bc435fso14172756qth.20
        for <kvm@vger.kernel.org>; Mon, 04 Oct 2021 18:19:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=rCtk0QZvGtJNNX968ZJI39G337e0fJGVp+XxoDUDdkE=;
        b=SXQnZ9JXeCK/1KvyKnaXPDby0VXKeDZEHG83sFNEnLHoS6OcJX0esOtEx5UMCaWA3J
         zem2hpT8tL7nMrmUE/AHs/Ca7QgecZZMCnQQM14JF8pvPu/A2gzcZpEUYXp1KTIFnFrB
         +KSWoCZHwa1ncWJ4jU9hGJFAXRg+hrXPJmAh5F9TwV2YCJiGgtFfqYpLav8FQQvNjgOW
         v4GkOJ2G48Iz8fIQHrzjM6TGFdZtUMX2bTzWzZih+UfpYlxcZDPKE5o7cyu/Z2gOfVnV
         /JvM8dLQzXMoCoqCg38MR2rOTpe+3CWa4yc7GCKWtTYQ5himxyksTSdxZnaGFjkjtgla
         oWlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=rCtk0QZvGtJNNX968ZJI39G337e0fJGVp+XxoDUDdkE=;
        b=VPCqjl++inwi1ujZabdT144f745V0+wXUmTSKeQgBd2Wdlg+R53ZhrpNG2piZDS0Ck
         E7aK7EPsIkG/DVTqWVJaOOAe4xPYh8vIRF5IwYiZ7Mv48ep9YuWosSuRoG8qCTlufuRu
         +Cfhy41E6KTvXvn0bdomoG203qVHT1vjVxSzDQS/r8Lie0W7KAPeNSM2GWM12JNoDl/i
         luJkGNQPY3FmOG7Wx8cmA2yUXKEdRZoGMopGCkEYrpphP3yP7/XYGf5kAjd1mRmuCSzz
         V4O6s9zgXp+NIK91fLAB/SNjk4KOPsvxDvKUarJXK99h/YqIeOENLG+RgdKjfSp32SDZ
         Ljiw==
X-Gm-Message-State: AOAM5339Lql8/cOcmScXhKaM4dopzCQWSHTqFRpnM/zDzPUwlbLaR43P
        dvS6RFX59uNYvpXTB0CfOHt3QUMcqmLfHxIxT8hyoXlq5izhw0Avk60HBVrXfYBRbpkh3UaVNv6
        olVADiCRwgoZeejwWlgwmLx6bFiXKtQQSg/bU4PYwxKqpdbc7bI75K0AHsFn0c3U=
X-Google-Smtp-Source: ABdhPJyCZCbvLGaSOMLBNe3BbAg0ASeNDo4wRQXjlyaPDuVIvUAXFBLjEBfIfBt3sWnzogbCLGnR6iAx5B0baQ==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a05:6214:528:: with SMTP id
 x8mr24810755qvw.30.1633396774726; Mon, 04 Oct 2021 18:19:34 -0700 (PDT)
Date:   Mon,  4 Oct 2021 18:19:17 -0700
In-Reply-To: <20211005011921.437353-1-ricarkol@google.com>
Message-Id: <20211005011921.437353-8-ricarkol@google.com>
Mime-Version: 1.0
References: <20211005011921.437353-1-ricarkol@google.com>
X-Mailer: git-send-email 2.33.0.800.g4c38ced690-goog
Subject: [PATCH v4 07/11] KVM: arm64: selftests: Make vgic_init/vm_gic_create
 version agnostic
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org, maz@kernel.org, kvmarm@lists.cs.columbia.edu,
        drjones@redhat.com, eric.auger@redhat.com, alexandru.elisei@arm.com
Cc:     Paolo Bonzini <pbonzini@redhat.com>, oupton@google.com,
        james.morse@arm.com, suzuki.poulose@arm.com, shuah@kernel.org,
        jingzhangos@google.com, pshier@google.com, rananta@google.com,
        reijiw@google.com, Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Make vm_gic_create GIC version agnostic in the vgic_init test. Also
add a nr_vcpus arg into it instead of defaulting to NR_VCPUS.

No functional change.

Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 .../testing/selftests/kvm/aarch64/vgic_init.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/vgic_init.c b/tools/testing/selftests/kvm/aarch64/vgic_init.c
index 896a29f2503d..7521dc80cf23 100644
--- a/tools/testing/selftests/kvm/aarch64/vgic_init.c
+++ b/tools/testing/selftests/kvm/aarch64/vgic_init.c
@@ -28,6 +28,7 @@
 struct vm_gic {
 	struct kvm_vm *vm;
 	int gic_fd;
+	uint32_t gic_dev_type;
 };
 
 static int max_ipa_bits;
@@ -61,12 +62,13 @@ static int run_vcpu(struct kvm_vm *vm, uint32_t vcpuid)
 	return 0;
 }
 
-static struct vm_gic vm_gic_v3_create(void)
+static struct vm_gic vm_gic_create_with_vcpus(uint32_t gic_dev_type, uint32_t nr_vcpus)
 {
 	struct vm_gic v;
 
-	v.vm = vm_create_default_with_vcpus(NR_VCPUS, 0, 0, guest_code, NULL);
-	v.gic_fd = kvm_create_device(v.vm, KVM_DEV_TYPE_ARM_VGIC_V3, false);
+	v.gic_dev_type = gic_dev_type;
+	v.vm = vm_create_default_with_vcpus(nr_vcpus, 0, 0, guest_code, NULL);
+	v.gic_fd = kvm_create_device(v.vm, gic_dev_type, false);
 
 	return v;
 }
@@ -257,8 +259,7 @@ static void test_v3_vgic_then_vcpus(uint32_t gic_dev_type)
 	struct vm_gic v;
 	int ret, i;
 
-	v.vm = vm_create_default(0, 0, guest_code);
-	v.gic_fd = kvm_create_device(v.vm, KVM_DEV_TYPE_ARM_VGIC_V3, false);
+	v = vm_gic_create_with_vcpus(gic_dev_type, 1);
 
 	subtest_v3_dist_rdist(&v);
 
@@ -278,7 +279,7 @@ static void test_v3_vcpus_then_vgic(uint32_t gic_dev_type)
 	struct vm_gic v;
 	int ret;
 
-	v = vm_gic_v3_create();
+	v = vm_gic_create_with_vcpus(gic_dev_type, NR_VCPUS);
 
 	subtest_v3_dist_rdist(&v);
 
@@ -295,7 +296,7 @@ static void test_v3_new_redist_regions(void)
 	uint64_t addr;
 	int ret;
 
-	v = vm_gic_v3_create();
+	v = vm_gic_create_with_vcpus(KVM_DEV_TYPE_ARM_VGIC_V3, NR_VCPUS);
 	subtest_v3_redist_regions(&v);
 	kvm_device_access(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
 			  KVM_DEV_ARM_VGIC_CTRL_INIT, NULL, true);
@@ -306,7 +307,7 @@ static void test_v3_new_redist_regions(void)
 
 	/* step2 */
 
-	v = vm_gic_v3_create();
+	v = vm_gic_create_with_vcpus(KVM_DEV_TYPE_ARM_VGIC_V3, NR_VCPUS);
 	subtest_v3_redist_regions(&v);
 
 	addr = REDIST_REGION_ATTR_ADDR(1, 0x280000, 0, 2);
@@ -320,7 +321,7 @@ static void test_v3_new_redist_regions(void)
 
 	/* step 3 */
 
-	v = vm_gic_v3_create();
+	v = vm_gic_create_with_vcpus(KVM_DEV_TYPE_ARM_VGIC_V3, NR_VCPUS);
 	subtest_v3_redist_regions(&v);
 
 	_kvm_device_access(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
-- 
2.33.0.800.g4c38ced690-goog

