Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E52E24064FA
	for <lists+kvm@lfdr.de>; Fri, 10 Sep 2021 03:14:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235129AbhIJBQD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Sep 2021 21:16:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234581AbhIJBPz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Sep 2021 21:15:55 -0400
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE28AC08ED6D
        for <kvm@vger.kernel.org>; Thu,  9 Sep 2021 17:49:25 -0700 (PDT)
Received: by mail-qt1-x849.google.com with SMTP id r6-20020a05622a034600b002a0ba9994f4so4214qtw.22
        for <kvm@vger.kernel.org>; Thu, 09 Sep 2021 17:49:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=qXTzlQcki5Z1B3LV6gzbhBx4QrZxfh2wOWzu6LDwbLI=;
        b=DvMVWjV3QYWlrellGcgEt+A/tPhUiz5dpu+g0e7xAqEBmW+XVsbtrG9TSYRL/rQbF/
         Vb8PshuGDJefFH7kzGp5MQuYE4qrful3MV7uzGaerCHJkLlyAGRIqp+Fxfc5PC2M8IsI
         aCDSZ9Q4tEw62gWGjSFCY9w09U3jPwLqNBEsvGbDeRlLCi6Wz7AwUU/gRyLcto7iRBVm
         TRmv5hSI6M4wM1n2YZ59xwuxCIyw9GlkBAwvjlSKcoUB5gkBfuZGfObHt+Dxxp97BBRM
         pU3QP1vrVQGZvyf2CH3rmBHrJOMRO73ARJ1C5a+KsAiKEjtpkkxBBD7YAHn7RQBdHGps
         VfnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=qXTzlQcki5Z1B3LV6gzbhBx4QrZxfh2wOWzu6LDwbLI=;
        b=6lckXFuueZAC3jiKQvYP3c3Z9DckqtHIPAuNXEa9gsr53he4ei+DxWKaQqjf9V8Fub
         iawRZaDUkA+XczEZ17/0lDVkSi9QQ4SKt/PGTJgH0E+APWWfU/T9bQztQujl0YCTE9xA
         wU+bifmfrJ7XdDD9nGOjlvbJgcIAMaJlBVm/cMNNXZBJIw2UWaNdOQquNUpcMNidG/iu
         Wzkz+WSBCmQLqbnRvVh5EUeFI456lshsU4hSn/4SayohDzF72jNDwFS0IX5sTMW+fvxo
         kWyZNxv7yvCyZKY3tXjrxDj8ZBLo5Llvl1vmx83AFqvJufknQuGJn0UtXlOg1OVCntlm
         ZKmA==
X-Gm-Message-State: AOAM532drhvw/aEt7cBdZhuZQDyNy9Dy7Y0REQ6nA8IBrTgySWVUR4Ot
        dDNTCkJw5LRgRloltntJB/tRuD8K6R5x2ZXtnwVHYiCkqBD6WhdNbGI9xy2koX7PTekkYaN4o0y
        +Rl/bWtgn04kakR+57vIdimHY91PEvQkft/BgB2bVnDmPHj6y7jk1Jm3ewaTcC9Y=
X-Google-Smtp-Source: ABdhPJziAmZhL+w/+T/9SGzl2L6SkBxRI7kg2xJlY6KsdHMtvzcpxiUebER6o80VRB2Z/qQzuTXCgswqOmGYtg==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:ad4:522c:: with SMTP id
 r12mr5969701qvq.17.1631234965148; Thu, 09 Sep 2021 17:49:25 -0700 (PDT)
Date:   Thu,  9 Sep 2021 17:49:19 -0700
In-Reply-To: <20210910004919.1610709-1-ricarkol@google.com>
Message-Id: <20210910004919.1610709-3-ricarkol@google.com>
Mime-Version: 1.0
References: <20210910004919.1610709-1-ricarkol@google.com>
X-Mailer: git-send-email 2.33.0.309.g3052b89438-goog
Subject: [PATCH v2 2/2] KVM: arm64: selftests: tests for vgic redist regions
 above the VM IPA size
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

These new tests attempt (and fail) to set a redist region using the
KVM_VGIC_V3_ADDR_TYPE_REDIST and KVM_VGIC_V3_ADDR_TYPE_REDIST_REGIONS
with regions partially above the VM-specified IPA size (phys_size).

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 .../testing/selftests/kvm/aarch64/vgic_init.c | 52 +++++++++++++++++++
 1 file changed, 52 insertions(+)

diff --git a/tools/testing/selftests/kvm/aarch64/vgic_init.c b/tools/testing/selftests/kvm/aarch64/vgic_init.c
index 623f31a14326..15aa01dc6a4d 100644
--- a/tools/testing/selftests/kvm/aarch64/vgic_init.c
+++ b/tools/testing/selftests/kvm/aarch64/vgic_init.c
@@ -285,6 +285,57 @@ static void test_vcpus_then_vgic(void)
 	vm_gic_destroy(&v);
 }
 
+static void test_redist_above_vm_pa_bits(enum vm_guest_mode mode)
+{
+	struct vm_gic v;
+	int ret, i;
+	uint32_t vcpuids[] = { 1, 2, 3, 4, };
+	int pa_bits = vm_guest_mode_params[mode].pa_bits;
+	uint64_t addr, psize = 1ULL << pa_bits;
+
+	/* Add vcpu 1 */
+	v.vm = vm_create_with_vcpus(mode, 1, DEFAULT_GUEST_PHY_PAGES,
+				    0, 0, guest_code, vcpuids);
+	v.gic_fd = kvm_create_device(v.vm, KVM_DEV_TYPE_ARM_VGIC_V3, false);
+
+	/* The redist end is above the IPA size, so this fails. */
+	addr = REDIST_REGION_ATTR_ADDR(1, psize - 0x10000, 0, 0);
+	ret = _kvm_device_access(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				 KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, true);
+	TEST_ASSERT(ret && errno == E2BIG,
+		"register redist region with end address beyond IPA range");
+
+	/* Set space for half a redist, we have 1 vcpu, so this fails. */
+	addr = psize - 0x10000;
+	ret = _kvm_device_access(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				 KVM_VGIC_V3_ADDR_TYPE_REDIST, &addr, true);
+	TEST_ASSERT(ret && errno == E2BIG,
+		"register redist (legacy) with end address beyond IPA range");
+
+	/* Set space for 3 redists, we have 1 vcpu, so this succeeds. */
+	addr = psize - (3 * 2 * 0x10000);
+	kvm_device_access(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				 KVM_VGIC_V3_ADDR_TYPE_REDIST, &addr, true);
+
+	addr = 0x00000;
+	kvm_device_access(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+			KVM_VGIC_V3_ADDR_TYPE_DIST, &addr, true);
+
+	/* Add the rest of the VCPUs */
+	for (i = 1; i < 4; ++i)
+		vm_vcpu_add_default(v.vm, vcpuids[i], guest_code);
+
+	kvm_device_access(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
+			  KVM_DEV_ARM_VGIC_CTRL_INIT, NULL, true);
+
+	/* Attempt to run a vcpu without enough redist space. */
+	ret = run_vcpu(v.vm, vcpuids[3]);
+	TEST_ASSERT(ret && errno == EINVAL,
+			"redist base+size above IPA detected on 1st vcpu run");
+
+	vm_gic_destroy(&v);
+}
+
 static void test_new_redist_regions(void)
 {
 	void *dummy = NULL;
@@ -542,6 +593,7 @@ int main(int ac, char **av)
 	test_kvm_device();
 	test_vcpus_then_vgic();
 	test_vgic_then_vcpus();
+	test_redist_above_vm_pa_bits(VM_MODE_DEFAULT);
 	test_new_redist_regions();
 	test_typer_accesses();
 	test_last_bit_redist_regions();
-- 
2.33.0.309.g3052b89438-goog

