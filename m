Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD05641BBA2
	for <lists+kvm@lfdr.de>; Wed, 29 Sep 2021 02:10:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243372AbhI2AL4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Sep 2021 20:11:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240284AbhI2ALz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Sep 2021 20:11:55 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CADCC06161C
        for <kvm@vger.kernel.org>; Tue, 28 Sep 2021 17:10:15 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id d16-20020a17090ab31000b0019ec685f551so2766550pjr.0
        for <kvm@vger.kernel.org>; Tue, 28 Sep 2021 17:10:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=2MtiYmsIZAKiCkiOVDptQ2jlzTFkcgsG+KFRVqe4f7g=;
        b=OcduwanS9+zbQtBQIsn7QLDWapwaawQ6JYaomhRYXBHwKP3XxspuKTqdNY7AHjZ8LF
         Mam7c87/hCgEunUPqruWzUs0W0B2vL/lnW0dDhkCDckbXOw81whQkk3s1mqsRZooDgNd
         aa4wWGsEiK5jw4PFOucqC9dvc8Tu7MRjkDenf6dtdNlaXrgKsh5kxuYsn54X9sAM2iY4
         Veszu21OfBFfpXUYQlikUUb/Ksiw6p9HgOtBfCHH5dRihO4A+S3VGBRPld3pkvmYmojB
         hQ0jQzZhtUqUyDzVt5neAxmB5AnVksFqNVWTvTvgGFJOSQig230no6FXWPAggEKIPEiD
         ihow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=2MtiYmsIZAKiCkiOVDptQ2jlzTFkcgsG+KFRVqe4f7g=;
        b=esE6+2gjKf5ZNZu4KizQaOqyBw5yscy8arNXPQY4ycHg0tlJ5YFmuF/2aw1/dwDnIA
         8opj5FSyuI597NkZI3FMWPmHgb4TyGs2kirsyTgIG1s6JtjwXMg+Jh+C95avcXAV6T+s
         mqKDVdiFb0Ha2XNJIArXLcPqH7hL9Ky+dQ2kw6BwJtcnxuEjaJiJmgYbLut5CYJ1P31X
         qgt2ACov977u0iBZzRPqSAladsHRUnwowOC9VtwWNTOdT6wqo1YS5BPdK/jvATv3MLJQ
         04lUThQoEQ9SgPrCahSyNBXdOn0bN/XN8PWH0x9JuSrPbngmnE4AEbmwEXgVnSELqwDr
         x9kA==
X-Gm-Message-State: AOAM533Lxlvo1/fULzapCzaVT94FvyhvTDjGJLMPVto8cFJO4UJATo5D
        5RKddSZPcn+7HZMIUMvTeBVs0Mgjnt9bWbz7k9nuIX9ILFm40wrldUOiZhZRHWTzte0RtaGifZg
        9sLH2UAJOySqIQzmBHmutaSIDjHfqR0Tc3VceFp3VM+p8dobjbBz4+n0njj5XffU=
X-Google-Smtp-Source: ABdhPJzkzLjl4g92VY7arsAEzBKHD6nwmq0Y1oE1FPFvZWFUloyF1dOqEoVeAe2wWT4qPxV/MTdo5z8oskqrWg==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:902:7b85:b0:13d:cdc4:9531 with SMTP
 id w5-20020a1709027b8500b0013dcdc49531mr7715978pll.27.1632874214400; Tue, 28
 Sep 2021 17:10:14 -0700 (PDT)
Date:   Tue, 28 Sep 2021 17:10:12 -0700
In-Reply-To: <20210928184803.2496885-1-ricarkol@google.com>
Message-Id: <20210929001012.2539461-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20210928184803.2496885-1-ricarkol@google.com>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
Subject: [PATCH v3 10/10] KVM: arm64: selftests: Add basic ITS device tests
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

Add some ITS device tests: general KVM device tests (address not defined
already, address aligned) and tests for the ITS region being within the
addressable IPA range.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 .../testing/selftests/kvm/aarch64/vgic_init.c | 42 +++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/tools/testing/selftests/kvm/aarch64/vgic_init.c b/tools/testing/selftests/kvm/aarch64/vgic_init.c
index 417a9a515cad..180221ec325d 100644
--- a/tools/testing/selftests/kvm/aarch64/vgic_init.c
+++ b/tools/testing/selftests/kvm/aarch64/vgic_init.c
@@ -603,6 +603,47 @@ static void test_v3_redist_ipa_range_check_at_vcpu_run(void)
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
@@ -655,6 +696,7 @@ void run_tests(uint32_t gic_dev_type)
 		test_v3_last_bit_redist_regions();
 		test_v3_last_bit_single_rdist();
 		test_v3_redist_ipa_range_check_at_vcpu_run();
+		test_v3_its_region();
 	}
 }
 
-- 
2.33.0.685.g46640cef36-goog

