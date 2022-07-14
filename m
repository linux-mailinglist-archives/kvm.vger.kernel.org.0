Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B9E757520F
	for <lists+kvm@lfdr.de>; Thu, 14 Jul 2022 17:41:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240380AbiGNPlU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jul 2022 11:41:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240169AbiGNPlT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jul 2022 11:41:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD62D5004A
        for <kvm@vger.kernel.org>; Thu, 14 Jul 2022 08:41:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 69E0E61F56
        for <kvm@vger.kernel.org>; Thu, 14 Jul 2022 15:41:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAB38C341C8;
        Thu, 14 Jul 2022 15:41:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657813277;
        bh=KCci7Zc0Qe8DJO0od+8TvidaaIOOcDyEDf6L//1MnIM=;
        h=From:To:Cc:Subject:Date:From;
        b=MAWQIz2V3VT7z9NNgf/QdQgKf55qjyCy2Xk8RZ7CQ57P404/TWyNiu/Q4bgK56QR+
         gQ/WfESMD5VEFTtFPE+HN3VmANQEHtivXI8h0w8jytnMoWi+ygLplB1SzdBdgYYtWH
         HICyUftjCz2xnsZ1hSEdqC1FqFdMVBbxEjjStQCvm2yKj9B2d3Q/Yn5a0qYZul/pix
         zzV9n25j3IzlfajpjcTpV7Byq1oYet4duxQb+O5vIGxT/zuovTUH3JjFfjRe9JBWMI
         5wiklH9eb7MnE8DNjLALRbMmLb+LiNbFSenFha1PNDUxnWW3SmLE3vz7EhMktsyyLx
         xH6SSQh7P2Jdg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1oC0xn-007V0d-P5;
        Thu, 14 Jul 2022 16:41:15 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Ricardo Koller <ricarkol@google.com>
Subject: [PATCH] KVM: arm64: selftests: Add support for GICv2 on v3
Date:   Thu, 14 Jul 2022 16:41:08 +0100
Message-Id: <20220714154108.3531213-1-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, oliver.upton@linux.dev, ricarkol@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The current vgic_init test wrongly assumes that the host cannot
multiple versions of the GIC architecture, while v2 emulation
on v3 has almost always been supported (it was supported before
the standalone v3 emulation).

Tweak the test to support multiple GIC incarnations.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 tools/testing/selftests/kvm/aarch64/vgic_init.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/vgic_init.c b/tools/testing/selftests/kvm/aarch64/vgic_init.c
index 34379c98d2f4..21ba4002fc18 100644
--- a/tools/testing/selftests/kvm/aarch64/vgic_init.c
+++ b/tools/testing/selftests/kvm/aarch64/vgic_init.c
@@ -670,7 +670,7 @@ int test_kvm_device(uint32_t gic_dev_type)
 
 	if (!_kvm_create_device(v.vm, other, true, &fd)) {
 		ret = _kvm_create_device(v.vm, other, false, &fd);
-		TEST_ASSERT(ret && errno == EINVAL,
+		TEST_ASSERT(ret && (errno == EINVAL || errno == EEXIST),
 				"create GIC device while other version exists");
 	}
 
@@ -698,6 +698,7 @@ int main(int ac, char **av)
 {
 	int ret;
 	int pa_bits;
+	int cnt_impl = 0;
 
 	pa_bits = vm_guest_mode_params[VM_MODE_DEFAULT].pa_bits;
 	max_phys_size = 1ULL << pa_bits;
@@ -706,17 +707,19 @@ int main(int ac, char **av)
 	if (!ret) {
 		pr_info("Running GIC_v3 tests.\n");
 		run_tests(KVM_DEV_TYPE_ARM_VGIC_V3);
-		return 0;
+		cnt_impl++;
 	}
 
 	ret = test_kvm_device(KVM_DEV_TYPE_ARM_VGIC_V2);
 	if (!ret) {
 		pr_info("Running GIC_v2 tests.\n");
 		run_tests(KVM_DEV_TYPE_ARM_VGIC_V2);
-		return 0;
+		cnt_impl++;
 	}
 
-	print_skip("No GICv2 nor GICv3 support");
-	exit(KSFT_SKIP);
+	if (!cnt_impl) {
+		print_skip("No GICv2 nor GICv3 support");
+		exit(KSFT_SKIP);
+	}
 	return 0;
 }
-- 
2.34.1

