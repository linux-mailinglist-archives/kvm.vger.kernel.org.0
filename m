Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DA07404068
	for <lists+kvm@lfdr.de>; Wed,  8 Sep 2021 23:03:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352468AbhIHVEi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Sep 2021 17:04:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350646AbhIHVEf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Sep 2021 17:04:35 -0400
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B73BC06175F
        for <kvm@vger.kernel.org>; Wed,  8 Sep 2021 14:03:27 -0700 (PDT)
Received: by mail-qv1-xf49.google.com with SMTP id c4-20020a0ce7c4000000b00370a5bb605eso6911771qvo.0
        for <kvm@vger.kernel.org>; Wed, 08 Sep 2021 14:03:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=mdwlcJAV0GStJsITLNL3ZqNZME4agwBiOXArc7PbMag=;
        b=kARn5cBx61tJryJHFvH86n9eBN3rIZHcjfFArqGVKf+BaFhVd2k9Tm595wtt61FSox
         jj8wQUHlKUu4wT2BVRkWaeWpvIv+6YAB6Lv5feC+yKISuAb+dficClmK5DbAJlYgCE7p
         M3ZPeLNw8O1yae2EU/+9FxhyrfxFObDT9AQC16+fS473/rVQu6hgFV2UmuoVTBH/vTln
         d29ncLcAdgoGeCf++fySf2IJjLEo1KVCDiDZKJqgAe6UMJxE0rRrA8plDewHFi/DiR3h
         qjvhewyGkaMUT0zhKENRcG/uDsCY5+C7tPalDj1EcEhOYMXObTyShukIjLAQIoPZ7fC7
         B8Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=mdwlcJAV0GStJsITLNL3ZqNZME4agwBiOXArc7PbMag=;
        b=ivfOlJYv3onmY4IzIPfzsRCk+RWeIQAE02FB9UwXhgviltMvn7913RzlxtFOX9b0or
         0mW5aHGf+F/CnFM3SIUyX+aluIYe8atpNcx7vVzS92Mi5+1Bvyb0qZZKDbyaZLe0hvm6
         OAJT1d1dV18DYbHR9u+jCgvmxRCDgy74Pft7HjekwqgwtMaajk8qfvI9CN8BWJyVxwrs
         Dp6pY2B/soi7b8HMFgrvR9vVjJy/TSwyfCQYbECJjPBOWr//ijcn2VdIvtoAu55qa3a8
         ICGtdkpRMLaC+bef10cod0hf7XMNw4XHVsXzCfsQ4QhimZWQGAxRUOUigE0dK1+teTmj
         /n2g==
X-Gm-Message-State: AOAM533jOQc0MDxxbFsA7IdTTnm1QhtCXYRL79hKL4BG1cgFznQ0JObH
        GqLXp2K2nBUD4RtR/a4Jc8oSPB2D5DWAx00R3isLI0VcR/N6BDsRJqfZwVKooyqSeflYoGZjO1X
        rtQMCjj7LOhCz+YZgaxyO+v/oZly0GFFVeGf71Gg/Z57DXLDZr4R4P42+4xLtWNg=
X-Google-Smtp-Source: ABdhPJzzdVOk4rvgoJk+dMuIIaVXLnnnjlRHrF4C3jZ6VX7trB2IyB3whLb/y9r6YyBdSetyplYF7XQKp58/rA==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a05:6214:132a:: with SMTP id
 c10mr232058qvv.35.1631135006184; Wed, 08 Sep 2021 14:03:26 -0700 (PDT)
Date:   Wed,  8 Sep 2021 14:03:20 -0700
In-Reply-To: <20210908210320.1182303-1-ricarkol@google.com>
Message-Id: <20210908210320.1182303-3-ricarkol@google.com>
Mime-Version: 1.0
References: <20210908210320.1182303-1-ricarkol@google.com>
X-Mailer: git-send-email 2.33.0.153.gba50c8fa24-goog
Subject: [PATCH 2/2] KVM: arm64: selftests: test for vgic redist above the VM
 IPA size
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

This test attempts (and fails) to set a redistributor region using the
legacy KVM_VGIC_V3_ADDR_TYPE_REDIST that's partially above the
VM-specified IPA size.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 .../testing/selftests/kvm/aarch64/vgic_init.c | 44 +++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/tools/testing/selftests/kvm/aarch64/vgic_init.c b/tools/testing/selftests/kvm/aarch64/vgic_init.c
index 623f31a14326..6dd7b5e91421 100644
--- a/tools/testing/selftests/kvm/aarch64/vgic_init.c
+++ b/tools/testing/selftests/kvm/aarch64/vgic_init.c
@@ -285,6 +285,49 @@ static void test_vcpus_then_vgic(void)
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
+	/* Set space for half a redist, we have 1 vcpu, so this fails. */
+	addr = psize - 0x10000;
+	ret = _kvm_device_access(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				 KVM_VGIC_V3_ADDR_TYPE_REDIST, &addr, true);
+	TEST_ASSERT(ret && errno == EINVAL, "not enough space for one redist");
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
+	/* Add three vcpus (2, 3, 4). */
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
@@ -542,6 +585,7 @@ int main(int ac, char **av)
 	test_kvm_device();
 	test_vcpus_then_vgic();
 	test_vgic_then_vcpus();
+	test_redist_above_vm_pa_bits(VM_MODE_DEFAULT);
 	test_new_redist_regions();
 	test_typer_accesses();
 	test_last_bit_redist_regions();
-- 
2.33.0.153.gba50c8fa24-goog

