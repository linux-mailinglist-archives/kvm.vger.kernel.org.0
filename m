Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C2B041B6A3
	for <lists+kvm@lfdr.de>; Tue, 28 Sep 2021 20:48:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242138AbhI1SuD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Sep 2021 14:50:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242329AbhI1SuA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Sep 2021 14:50:00 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 996EEC061745
        for <kvm@vger.kernel.org>; Tue, 28 Sep 2021 11:48:20 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id z24-20020a17090a8b9800b0019f0a4d03d9so3084862pjn.3
        for <kvm@vger.kernel.org>; Tue, 28 Sep 2021 11:48:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=DAIt+H09/55OKEtE9w5bih5JH14ibKqMeAyogQTb7NA=;
        b=V9boUQARyAIacnbUDUeErmiotuKDAaOjvI+Zyh7Jk5DyJcOgLKNUNUcZAK9+AtDYsM
         5DrGTDpuf4+k7NM4GiefH0KhqJrY7VWQc6Pb/QB0EEAZvTSML9AHMANHOhl6QqjiRhr1
         zf/PRkGQBSLNNkUlOyUPQV8A3F7BjQDw73jU8AHk5ZHkGb0d99YhkvmpA+QsIv0q78vj
         3+S5u08Tz7CpqyUSQpecNBbb8g7V9IqJolvOU7ZXpnAnSBzpm36x37L+IDuWJahhxM0i
         /xJI65YMZfH9Ds+OWKK5idobadvujKpxvgt7RJZpWCVuYCZmum/9AAXyEH/EXuBzphYB
         6BPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=DAIt+H09/55OKEtE9w5bih5JH14ibKqMeAyogQTb7NA=;
        b=7yE75WpNEx5p3yD5T0qOC2AV/atGpyT4FBwg6DGIE0pjeWamPLYzJ0yJJfbg1sfo/R
         axq9RFIOnSa7sJl0Dgg/fcxJ3m5KhwHn1Tde9gPOjDkDryoabplzopladbYAH9YJs+De
         GCRuY3hrSwNpufEmOJa7RnsFLt1tmKeX2jp25EcrDh/U6Vgfu1Q/Qmg6C0CFTJ77zoAE
         WQnunoHwngeqGVVQc5WrWwVshKV1HWh59Spgzdkr30g6Sq8geVRs9Bim43S0+tB5zXjW
         5rYYw8eMe0boG94OYzeIctNdyQYeg4/7gd8iFVyBELkmPPMtjI2nr+Wa+MMZTKI1Ikuz
         WLaA==
X-Gm-Message-State: AOAM530SzcnnT86TJ0L8jRVmOqozHZRourL3hxMz8n+Vv8qzYXAISzLc
        6XxrwPYk4nX8QIbMQm75vcH4gcj97ndkavYF2lysGljkbxDX+y8ehnk4chkYnTrM8teIunOshO9
        Lx6l8K0LzqMCbZ70vf1R8Bu77iV7qCQjNEA7Rb1GV6keeYp/QOiNaTb9MaZZZDVI=
X-Google-Smtp-Source: ABdhPJzBsTVis9j8OArZICNpPTg91je2dRVms+08Gd+Zw0+o9ENIltafYzAWzsGkahkSD6Zbrj6mYRkqyxOFEg==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:aa7:8f11:0:b0:44b:21bf:b76 with SMTP id
 x17-20020aa78f11000000b0044b21bf0b76mr6991440pfr.43.1632854899868; Tue, 28
 Sep 2021 11:48:19 -0700 (PDT)
Date:   Tue, 28 Sep 2021 11:48:02 -0700
In-Reply-To: <20210928184803.2496885-1-ricarkol@google.com>
Message-Id: <20210928184803.2496885-9-ricarkol@google.com>
Mime-Version: 1.0
References: <20210928184803.2496885-1-ricarkol@google.com>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
Subject: [PATCH v3 08/10] KVM: arm64: selftests: Add tests for GIC
 redist/cpuif partially above IPA range
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

Add tests for checking that KVM returns the right error when trying to
set GICv2 CPU interfaces or GICv3 Redistributors partially above the
addressable IPA range. Also tighten the IPA range by replacing
KVM_CAP_ARM_VM_IPA_SIZE with the IPA range currently configured for the
guest (i.e., the default).

The check for the GICv3 redistributor created using the REDIST legacy
API is not sufficient as this new test only checks the check done using
vcpus already created when setting the base. The next commit will add
the missing test which verifies that the KVM check is done at first vcpu
run.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 .../testing/selftests/kvm/aarch64/vgic_init.c | 46 ++++++++++++++-----
 1 file changed, 35 insertions(+), 11 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/vgic_init.c b/tools/testing/selftests/kvm/aarch64/vgic_init.c
index 92f5c6ca6b8b..77a1941e61fa 100644
--- a/tools/testing/selftests/kvm/aarch64/vgic_init.c
+++ b/tools/testing/selftests/kvm/aarch64/vgic_init.c
@@ -31,7 +31,7 @@ struct vm_gic {
 	uint32_t gic_dev_type;
 };
 
-static int max_ipa_bits;
+static uint64_t max_phys_size;
 
 /* helper to access a redistributor register */
 static int access_v3_redist_reg(int gicv3_fd, int vcpu, int offset,
@@ -150,16 +150,21 @@ static void subtest_dist_rdist(struct vm_gic *v)
 	TEST_ASSERT(ret && errno == EINVAL, "GIC redist/cpu base not aligned");
 
 	/* out of range address */
-	if (max_ipa_bits) {
-		addr = 1ULL << max_ipa_bits;
-		ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
-					 dist.attr, &addr, true);
-		TEST_ASSERT(ret && errno == E2BIG, "dist address beyond IPA limit");
+	addr = max_phys_size;
+	ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				 dist.attr, &addr, true);
+	TEST_ASSERT(ret && errno == E2BIG, "dist address beyond IPA limit");
 
-		ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
-					 rdist.attr, &addr, true);
-		TEST_ASSERT(ret && errno == E2BIG, "redist address beyond IPA limit");
-	}
+	ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				 rdist.attr, &addr, true);
+	TEST_ASSERT(ret && errno == E2BIG, "redist address beyond IPA limit");
+
+	/* Space for half a rdist (a rdist is: 2 * rdist.alignment). */
+	addr = max_phys_size - dist.alignment;
+	ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				 rdist.attr, &addr, true);
+	TEST_ASSERT(ret && errno == E2BIG,
+			"half of the redist is beyond IPA limit");
 
 	/* set REDIST base address @0x0*/
 	addr = 0x00000;
@@ -248,7 +253,21 @@ static void subtest_v3_redist_regions(struct vm_gic *v)
 	kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
 			  KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, true);
 
-	addr = REDIST_REGION_ATTR_ADDR(1, 1ULL << max_ipa_bits, 0, 2);
+	addr = REDIST_REGION_ATTR_ADDR(1, max_phys_size, 0, 2);
+	ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				 KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, true);
+	TEST_ASSERT(ret && errno == E2BIG,
+		    "register redist region with base address beyond IPA range");
+
+	/* The last redist is above the pa range. */
+	addr = REDIST_REGION_ATTR_ADDR(1, max_phys_size - 0x10000, 0, 2);
+	ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				 KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, true);
+	TEST_ASSERT(ret && errno == E2BIG,
+		    "register redist region with base address beyond IPA range");
+
+	/* The last redist is above the pa range. */
+	addr = REDIST_REGION_ATTR_ADDR(2, max_phys_size - 0x30000, 0, 2);
 	ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
 				 KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, true);
 	TEST_ASSERT(ret && errno == E2BIG,
@@ -608,8 +627,13 @@ void run_tests(uint32_t gic_dev_type)
 int main(int ac, char **av)
 {
 	int ret;
+	int max_ipa_bits, pa_bits;
 
 	max_ipa_bits = kvm_check_cap(KVM_CAP_ARM_VM_IPA_SIZE);
+	pa_bits = vm_guest_mode_params[VM_MODE_DEFAULT].pa_bits;
+	TEST_ASSERT(max_ipa_bits && pa_bits <= max_ipa_bits,
+		"The default PA range should not be larger than the max.");
+	max_phys_size = 1ULL << pa_bits;
 
 	ret = test_kvm_device(KVM_DEV_TYPE_ARM_VGIC_V3);
 	if (!ret) {
-- 
2.33.0.685.g46640cef36-goog

