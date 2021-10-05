Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75334421BC8
	for <lists+kvm@lfdr.de>; Tue,  5 Oct 2021 03:19:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231297AbhJEBVa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Oct 2021 21:21:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231229AbhJEBV3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Oct 2021 21:21:29 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E725DC061745
        for <kvm@vger.kernel.org>; Mon,  4 Oct 2021 18:19:39 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id p19-20020a634f53000000b002877a03b293so11560853pgl.10
        for <kvm@vger.kernel.org>; Mon, 04 Oct 2021 18:19:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=LALo9JihRPRBkG1fYYMRtr74GhwkziudPmPUGtI9Fw4=;
        b=hLp0tj96F1OWP6HZwu3DGIrMazfL6bcOfnvTYKxYCIBaSh7ob8veeFJ1cVziBgXiNu
         bqDrG6sf6VCe/KsbjSR1p681zdh/F+klgPr6dB1bTJk/a4PtAI6cijGq+E9agkE4aFia
         Cz7Eh7XfwNv1k3E3mcPqWnhYUmyBjKyzPC1NH5IRoVCNFnkLS09HpMcftjRF+Yi8698c
         YrHRxITfEQOixXsbTKe7pNCA/4goHDQf2kL5LCTSXPQKvj61JXw5DWKR+L4y0qXYfaoL
         qk6JF+TDk4oO40MLI0Zjx2Ls1zHqiuP21PrRPIgk/+99jerLdZ4m2+nKG/47fiu8X3t3
         C0Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=LALo9JihRPRBkG1fYYMRtr74GhwkziudPmPUGtI9Fw4=;
        b=xdWxiWYrf14fK8cpjT6lFx7lltk9KrJQ1Pzp5w+Wt87f8W+fDetC0qq8PI1MOoheQ/
         pICUKu/xstV98oLfO0tOPC0uTOg2Yncn3riKsC/R+PlDp3R0kN82VcgPYHBLB/roL/bC
         d56nNYukrxQnIiPrQnJ7tutblISFs6GoMTHew9N4+iegybZl47LOC2+FbiqSIUUabr1O
         plMZnjQaoZnNtKbbVSdt/fqoGWJY/upYEj0ABai6ZvG3ztcDIboUuVMVnZaHIJjstb3A
         nFtKKBtaVCWDT1CgV+US5YDc+4p0cfSK8W3V75D+g9/McD9uTHfpLYjgeF1fD377xVcT
         VQWQ==
X-Gm-Message-State: AOAM530rqDY/XPQFsK5AoxeM6w5sdnPWzoMV+TirXTy+4DsZEacE7aiF
        a6jNErWKxJSWqpH8c7GKRulYyZoe3R0dItqE7sVvFgZ3F8vuWAYA8dYfNswfZqlJASDN4yQVWgR
        fOkN7Cocl2HkH13x4vFh1s4WPIKp8Pdl7S2Gi7oKUh28VZlwjFDhkMHrci4UIJWE=
X-Google-Smtp-Source: ABdhPJzUUkZEXh0YtKOvuw4kldQta6Fk0jXOVYU6rXgMHyhp34IKvaz+CMANxBajmBBPTWnz+esVVsUyc0CDoQ==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:90b:1804:: with SMTP id
 lw4mr383225pjb.174.1633396779303; Mon, 04 Oct 2021 18:19:39 -0700 (PDT)
Date:   Mon,  4 Oct 2021 18:19:20 -0700
In-Reply-To: <20211005011921.437353-1-ricarkol@google.com>
Message-Id: <20211005011921.437353-11-ricarkol@google.com>
Mime-Version: 1.0
References: <20211005011921.437353-1-ricarkol@google.com>
X-Mailer: git-send-email 2.33.0.800.g4c38ced690-goog
Subject: [PATCH v4 10/11] KVM: arm64: selftests: Add test for legacy GICv3
 REDIST base partially above IPA range
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

Add a new test into vgic_init which checks that the first vcpu fails to
run if there is not sufficient REDIST space below the addressable IPA
range.  This only applies to the KVM_VGIC_V3_ADDR_TYPE_REDIST legacy API
as the required REDIST space is not know when setting the DIST region.

Note that using the REDIST_REGION API results in a different check at
first vcpu run: that the number of redist regions is enough for all
vcpus. And there is already a test for that case in, the first step of
test_v3_new_redist_regions.

Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 .../testing/selftests/kvm/aarch64/vgic_init.c | 34 +++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/tools/testing/selftests/kvm/aarch64/vgic_init.c b/tools/testing/selftests/kvm/aarch64/vgic_init.c
index eadd448b3a96..80be1940d2ad 100644
--- a/tools/testing/selftests/kvm/aarch64/vgic_init.c
+++ b/tools/testing/selftests/kvm/aarch64/vgic_init.c
@@ -565,6 +565,39 @@ static void test_v3_last_bit_single_rdist(void)
 	vm_gic_destroy(&v);
 }
 
+/* Uses the legacy REDIST region API. */
+static void test_v3_redist_ipa_range_check_at_vcpu_run(void)
+{
+	struct vm_gic v;
+	int ret, i;
+	uint64_t addr;
+
+	v = vm_gic_create_with_vcpus(KVM_DEV_TYPE_ARM_VGIC_V3, 1);
+
+	/* Set space for 3 redists, we have 1 vcpu, so this succeeds. */
+	addr = max_phys_size - (3 * 2 * 0x10000);
+	kvm_device_access(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				 KVM_VGIC_V3_ADDR_TYPE_REDIST, &addr, true);
+
+	addr = 0x00000;
+	kvm_device_access(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+			KVM_VGIC_V3_ADDR_TYPE_DIST, &addr, true);
+
+	/* Add the rest of the VCPUs */
+	for (i = 1; i < NR_VCPUS; ++i)
+		vm_vcpu_add_default(v.vm, i, guest_code);
+
+	kvm_device_access(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
+			  KVM_DEV_ARM_VGIC_CTRL_INIT, NULL, true);
+
+	/* Attempt to run a vcpu without enough redist space. */
+	ret = run_vcpu(v.vm, 2);
+	TEST_ASSERT(ret && errno == EINVAL,
+		"redist base+size above PA range detected on 1st vcpu run");
+
+	vm_gic_destroy(&v);
+}
+
 /*
  * Returns 0 if it's possible to create GIC device of a given type (V2 or V3).
  */
@@ -616,6 +649,7 @@ void run_tests(uint32_t gic_dev_type)
 		test_v3_typer_accesses();
 		test_v3_last_bit_redist_regions();
 		test_v3_last_bit_single_rdist();
+		test_v3_redist_ipa_range_check_at_vcpu_run();
 	}
 }
 
-- 
2.33.0.800.g4c38ced690-goog

