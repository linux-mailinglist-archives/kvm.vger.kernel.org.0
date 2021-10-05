Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56D4D421BCB
	for <lists+kvm@lfdr.de>; Tue,  5 Oct 2021 03:19:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231363AbhJEBVc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Oct 2021 21:21:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231311AbhJEBVb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Oct 2021 21:21:31 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 635EBC061753
        for <kvm@vger.kernel.org>; Mon,  4 Oct 2021 18:19:41 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id l12-20020a170903120c00b0013eb930584fso812200plh.22
        for <kvm@vger.kernel.org>; Mon, 04 Oct 2021 18:19:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=ebBYyYb0auVU2YwhpjKMMCWgRzY2PJI9/2w5/quPrGs=;
        b=nnff9YiUi6n1ZXyRJwhfFa6RWAeI0wcpnPssLqmBzAlrRBcjFTQuzDYAjwhxx0tlOq
         e+S5uaB88ivXuMxCX8mLqcIxGLvJF0V0OgaJn+sutt6n3gSl0AMpkFhY5mvQYmX5ew+D
         WI5qVOypc6GBHMoJ6nmlJlq3ZzygfPXlMg/tlTJA1W3D9pghl6JYJB8QCS8actNnmxEH
         gpEXsFZyynm2ozl0zbOPO6kP0yJ+/Dd4eq1ppv3Z4wAoJhWULYv6Ab7hmS6ncnX9p3JE
         ETbTYxijY0mT28Xuh1/n2HOfAvYiMaaq70PB0zVzfsXQ57Q6XK+yfungcx56nOHn9I0/
         XKTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=ebBYyYb0auVU2YwhpjKMMCWgRzY2PJI9/2w5/quPrGs=;
        b=giAvg4XdFDx1OfK4ovUFnXuTFn8KIFLFHA7h5ur12WRsObiD2iXr534IgNruTFwKvg
         UR2m6m+D9Jpw7wR2dVg/GEwxKtS/7BSHhZnzc+1xhVctE/h3iBiv3bi+K7mwSInU5jy0
         QCLyKbQREYDeq4IZShJo1O3G7v0TheCk4C1kyA9XuXeUqXa7zIJACc/NLaJ/n7NtQzYy
         1bzrHLWcPxN35QuuTfBaKIu7N5USOtTrp74b/AAuBls43UEfBEpgrWdYZZ0GJu7aKjVz
         mAOFpHRQapskWKDdvPeQm4OXKfkafdDwoam06pOwYzr0DaxpDbGIzcREIIaW0GcuLzwV
         ak1Q==
X-Gm-Message-State: AOAM532WtLR1lrmYJkrmuMnyzXtxPc4++uutFvbAAbbCNfYJNPUZXdR2
        mLmXWFuN6olAOl0//2xgjtyU9pEw4o6+RfnyARArvALdvEmpvyy0xVijBRSX3S3DS4AiRpXWeAR
        4Sy5wL+5iBRssfgTlwMwI4uR43+By9mm+yjOlZG+dKsEmvX8OLHPMiJjJkY9OPeg=
X-Google-Smtp-Source: ABdhPJxSvUsBKjgUTRIyeKoK/lGVqGBvu8uO5Dr1jcgTFqQndyorWtPI9bFQSzNvrMxfbls15hUJ0mio4/S5Vg==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:902:7e88:b0:13e:91ec:4114 with SMTP
 id z8-20020a1709027e8800b0013e91ec4114mr2606928pla.30.1633396780779; Mon, 04
 Oct 2021 18:19:40 -0700 (PDT)
Date:   Mon,  4 Oct 2021 18:19:21 -0700
In-Reply-To: <20211005011921.437353-1-ricarkol@google.com>
Message-Id: <20211005011921.437353-12-ricarkol@google.com>
Mime-Version: 1.0
References: <20211005011921.437353-1-ricarkol@google.com>
X-Mailer: git-send-email 2.33.0.800.g4c38ced690-goog
Subject: [PATCH v4 11/11] KVM: arm64: selftests: Add init ITS device test
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

Add some ITS device init tests: general KVM device tests (address not
defined already, address aligned) and tests for the ITS region being
within the addressable IPA range.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 .../testing/selftests/kvm/aarch64/vgic_init.c | 42 +++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/tools/testing/selftests/kvm/aarch64/vgic_init.c b/tools/testing/selftests/kvm/aarch64/vgic_init.c
index 80be1940d2ad..c563489ff760 100644
--- a/tools/testing/selftests/kvm/aarch64/vgic_init.c
+++ b/tools/testing/selftests/kvm/aarch64/vgic_init.c
@@ -598,6 +598,47 @@ static void test_v3_redist_ipa_range_check_at_vcpu_run(void)
 	vm_gic_destroy(&v);
 }
 
+static void test_v3_its_region(void)
+{
+	struct vm_gic v;
+	uint64_t addr;
+	int its_fd, ret;
+
+	v = vm_gic_create_with_vcpus(KVM_DEV_TYPE_ARM_VGIC_V3, NR_VCPUS);
+	its_fd = kvm_create_device(v.vm, KVM_DEV_TYPE_ARM_VGIC_ITS, false);
+
+	addr = 0x401000;
+	ret = _kvm_device_access(its_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+			  KVM_VGIC_ITS_ADDR_TYPE, &addr, true);
+	TEST_ASSERT(ret && errno == EINVAL,
+		"ITS region with misaligned address");
+
+	addr = max_phys_size;
+	ret = _kvm_device_access(its_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+			  KVM_VGIC_ITS_ADDR_TYPE, &addr, true);
+	TEST_ASSERT(ret && errno == E2BIG,
+		"register ITS region with base address beyond IPA range");
+
+	addr = max_phys_size - 0x10000;
+	ret = _kvm_device_access(its_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+			  KVM_VGIC_ITS_ADDR_TYPE, &addr, true);
+	TEST_ASSERT(ret && errno == E2BIG,
+		"Half of ITS region is beyond IPA range");
+
+	/* This one succeeds setting the ITS base */
+	addr = 0x400000;
+	kvm_device_access(its_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+			  KVM_VGIC_ITS_ADDR_TYPE, &addr, true);
+
+	addr = 0x300000;
+	ret = _kvm_device_access(its_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+			  KVM_VGIC_ITS_ADDR_TYPE, &addr, true);
+	TEST_ASSERT(ret && errno == EEXIST, "ITS base set again");
+
+	close(its_fd);
+	vm_gic_destroy(&v);
+}
+
 /*
  * Returns 0 if it's possible to create GIC device of a given type (V2 or V3).
  */
@@ -650,6 +691,7 @@ void run_tests(uint32_t gic_dev_type)
 		test_v3_last_bit_redist_regions();
 		test_v3_last_bit_single_rdist();
 		test_v3_redist_ipa_range_check_at_vcpu_run();
+		test_v3_its_region();
 	}
 }
 
-- 
2.33.0.800.g4c38ced690-goog

