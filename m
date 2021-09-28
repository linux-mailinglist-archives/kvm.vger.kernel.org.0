Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32A8241B82D
	for <lists+kvm@lfdr.de>; Tue, 28 Sep 2021 22:12:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242679AbhI1UNn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Sep 2021 16:13:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242609AbhI1UNm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Sep 2021 16:13:42 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 871CEC06161C
        for <kvm@vger.kernel.org>; Tue, 28 Sep 2021 13:12:02 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id b5-20020a251b05000000b005b575f23711so261926ybb.4
        for <kvm@vger.kernel.org>; Tue, 28 Sep 2021 13:12:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=2MtiYmsIZAKiCkiOVDptQ2jlzTFkcgsG+KFRVqe4f7g=;
        b=Nc9t1pLswT3y0G3mxJl8UdpIzcua8x8wgYPHnJt4U4C7m+A+xdDKv+yPTgKb6X4pPB
         tGeFDlt4eHfjy/+pg5ztGzMK0UPRlLSpv4/qQs7GYsu1cirMcqcPDs3aCS9B2XMaHwuh
         jlaSseJfAO+NGWoERn46AEsCt2zIVJpAIch40je1xmUy5Gj0pybObZyMGNai0Z/tCaLG
         Cju53o5orzJvYMyRaisaS0ZgR80mcDaYjuxuAoOeO2Q5VfFRuBYWf8sG8rR2HY/72qgO
         smjiXPVlaMu/ZHmTujWM1OfRrO7aEeGjrz70ueFNHnUywNSxl32aKfpw+vmi1rHnqYup
         PkYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=2MtiYmsIZAKiCkiOVDptQ2jlzTFkcgsG+KFRVqe4f7g=;
        b=ZDYqN8NAvt0YJkSYChaM/5Yd0I4mq4jucUSCATwjP8ulU36qvvmLdmDN0pln37uB58
         V3osXkXxElshlW2Bs4KpjgNTcC77OZOIWRZ6uUq+cx+2C+YCWhoHUjcyJ6Rhzsj5q7ai
         cwgCSudN5+DXcuxvsh69sXATA0sm9LkKidWXWbUZ5HLV270+5nlqXDESawVp/clLeF6O
         nqVqHQRNb6ElPOR8XcGZKpvGz2pg/NCQpg+Qf6BuFSlt+8UJfh9ps+VSGgaF2CFqWpkv
         JxYySzPCJMq3ccWoYIfRuFNWuSQDvZp6tJCT5fM0jmjkRYeSBW95ntJsx7ol/L2UYSwc
         RJqw==
X-Gm-Message-State: AOAM530nyAJfq38S6Dfy4e3Xh+3eP1tMSXWQ5BdBEEPGkuMFY6npjQpY
        Vz9Tib1aHjQeGuAWwhpS4pOKOde2prN6JPfXsNC1cXKfnXByHbxCRThN7TkH1wEQCCmzj+c/VeL
        Vgtupx/SSHDayfeUbG0MhwUdk3WQxfUWPiwfDwUslG7Inxi5ApKQ0UE4NDQF/Ofs=
X-Google-Smtp-Source: ABdhPJw8MrJiLzblo6lnWZ5IAC2p8lhfkKmhypzz27FkHzMv1y+sZHucn0xw+0jnRkZwdZQ6VxVlyt03jGas1Q==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a25:d1cc:: with SMTP id
 i195mr8710836ybg.195.1632859921712; Tue, 28 Sep 2021 13:12:01 -0700 (PDT)
Date:   Tue, 28 Sep 2021 13:11:57 -0700
Message-Id: <20210928201157.2510143-1-ricarkol@google.com>
Mime-Version: 1.0
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

