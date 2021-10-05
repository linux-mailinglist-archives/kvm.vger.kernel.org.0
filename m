Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF92C421BC6
	for <lists+kvm@lfdr.de>; Tue,  5 Oct 2021 03:19:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231222AbhJEBV3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Oct 2021 21:21:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231229AbhJEBV2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Oct 2021 21:21:28 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3B7DC061745
        for <kvm@vger.kernel.org>; Mon,  4 Oct 2021 18:19:38 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id z2-20020a254c02000000b005b68ef4fe24so26047131yba.11
        for <kvm@vger.kernel.org>; Mon, 04 Oct 2021 18:19:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=S76O3ETAe3yQxXAd2JJTjNgxqbnnjrbVIsMmqpzrAMM=;
        b=Yc3iAwJ1KU0xk6PUvDOO1DgsqmjfDLUcct/Cp5cplfLvtPICb0rCsFcEtIZJ9bDna8
         sHiNe5RXDfTtL+rUhKyj+lG76BwPPVCrwx+UtBvtwuE6fXeahv+aXLtwaWZJ5PBHu57X
         Nx9xldr7H4lvuoW4dVJBA5Isg4HZBYdy1v6SMtTUYSyq18GDlrpJ7aLRpD10wT8xPuAB
         a8CCrcDx2rNjjS+MZqWj9pDWVA8zsMR/GVMiIHk04n3ot2qLt+9UIH/41ihcMMym5Azx
         +jfxBWE4kq2KdkjtjIun9W/bXWcx5xp0zbkXPdCum3IT+RqqUXDU8Ny0fVk59eWHjWSn
         +v9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=S76O3ETAe3yQxXAd2JJTjNgxqbnnjrbVIsMmqpzrAMM=;
        b=Pjg7R16KmOsGXWgK29SjDOloSQmD6aESu4Ht7Rm7F5YyBwX7r/utCVjxRbCmd5BNsO
         PgosDbTa02UR89SGsr29JBb56ICqzlY22EpYb163Duu2EBNop12cnMIYatu7IvOOSMOu
         kIpEcrYC42n6y47PfVzrJakBFbLZMoSIzTtLkiIhYfDA10CTfXbOcE9ssSoOWaMYtZUL
         J5e/YT4m8nm9GVKKBnXIfeE5xThw2e+jYStKT2VgiR/OBylvaaeB/udOHm8nX9I6RPEy
         9SVduhRwVSsRcdUbbD1So9jnLuun9uWd4u/XczOD0/ZGe+MbIVoB6aAQAPr8Sohq8Jar
         nZkg==
X-Gm-Message-State: AOAM532gBPR8S5DAYr3N/dYcsJbMsJ01WuauEGhE+SWO3kY8on6kYNIW
        toE2Me1chrdzIe4+/OdBvw96rDFJTWN5ad0MaXMLkIggPWvVUsMyXKlnGlp38oKTYERgOXkWDP3
        gBv9flDwl//xK/y6skETVYsvHWuurpu8gCuzXCbWlbLwAPKH9IuRR3XNR03YX2M4=
X-Google-Smtp-Source: ABdhPJzLLpKp+6FIvPQvjCg8Ehu7YXxwucVWSZhjf1W55UmsjljX4QCwDd3o5as7VVh3HZvvAVWVG523KA8lWA==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a25:c183:: with SMTP id
 r125mr17844375ybf.37.1633396777861; Mon, 04 Oct 2021 18:19:37 -0700 (PDT)
Date:   Mon,  4 Oct 2021 18:19:19 -0700
In-Reply-To: <20211005011921.437353-1-ricarkol@google.com>
Message-Id: <20211005011921.437353-10-ricarkol@google.com>
Mime-Version: 1.0
References: <20211005011921.437353-1-ricarkol@google.com>
X-Mailer: git-send-email 2.33.0.800.g4c38ced690-goog
Subject: [PATCH v4 09/11] KVM: arm64: selftests: Add tests for GIC
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
 .../testing/selftests/kvm/aarch64/vgic_init.c | 38 +++++++++++++------
 1 file changed, 26 insertions(+), 12 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/vgic_init.c b/tools/testing/selftests/kvm/aarch64/vgic_init.c
index cb69e195ad1d..eadd448b3a96 100644
--- a/tools/testing/selftests/kvm/aarch64/vgic_init.c
+++ b/tools/testing/selftests/kvm/aarch64/vgic_init.c
@@ -31,7 +31,7 @@ struct vm_gic {
 	uint32_t gic_dev_type;
 };
 
-static int max_ipa_bits;
+static uint64_t max_phys_size;
 
 /* helper to access a redistributor register */
 static int access_v3_redist_reg(int gicv3_fd, int vcpu, int offset,
@@ -152,16 +152,21 @@ static void subtest_dist_rdist(struct vm_gic *v)
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
@@ -250,12 +255,19 @@ static void subtest_v3_redist_regions(struct vm_gic *v)
 	kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
 			  KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, true);
 
-	addr = REDIST_REGION_ATTR_ADDR(1, 1ULL << max_ipa_bits, 0, 2);
+	addr = REDIST_REGION_ATTR_ADDR(1, max_phys_size, 0, 2);
 	ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
 				 KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, true);
 	TEST_ASSERT(ret && errno == E2BIG,
 		    "register redist region with base address beyond IPA range");
 
+	/* The last redist is above the pa range. */
+	addr = REDIST_REGION_ATTR_ADDR(2, max_phys_size - 0x30000, 0, 2);
+	ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				 KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, true);
+	TEST_ASSERT(ret && errno == E2BIG,
+		    "register redist region with top address beyond IPA range");
+
 	addr = 0x260000;
 	ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
 				 KVM_VGIC_V3_ADDR_TYPE_REDIST, &addr, true);
@@ -610,8 +622,10 @@ void run_tests(uint32_t gic_dev_type)
 int main(int ac, char **av)
 {
 	int ret;
+	int pa_bits;
 
-	max_ipa_bits = kvm_check_cap(KVM_CAP_ARM_VM_IPA_SIZE);
+	pa_bits = vm_guest_mode_params[VM_MODE_DEFAULT].pa_bits;
+	max_phys_size = 1ULL << pa_bits;
 
 	ret = test_kvm_device(KVM_DEV_TYPE_ARM_VGIC_V3);
 	if (!ret) {
-- 
2.33.0.800.g4c38ced690-goog

