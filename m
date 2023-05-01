Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B0A06F35C2
	for <lists+kvm@lfdr.de>; Mon,  1 May 2023 20:22:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232101AbjEASWB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 May 2023 14:22:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232391AbjEASV4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 May 2023 14:21:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55B78213A
        for <kvm@vger.kernel.org>; Mon,  1 May 2023 11:21:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E5ED260B26
        for <kvm@vger.kernel.org>; Mon,  1 May 2023 18:21:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47652C433EF;
        Mon,  1 May 2023 18:21:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682965312;
        bh=V/JH3cr9i5AijKPl0ZmPkv2OS3bZnxOQkZm7dFZvhHo=;
        h=From:To:Cc:Subject:Date:From;
        b=CK5QhAiNIHFoRaUP2WIHEiSGo1c/bRWtHDsZ05Ye/yAQMs9YrQXN4qqaVATAdEOng
         E97XWF46/o8TQVVJXRbMg3LO/jwpaQ4vAU24DUrAGpT6Nwm0Zc2chUFHKKIyIEKYcT
         vyCt6TDxs951YOUjSx6fUyRjk110t1XneF37n9Uj4mw1V5vfOmOGnCyqPojsO+qYWR
         8v64OIaDeJyEijbLQNkFwsmeTaC6u4uz9PD5PGR5cPyKh6tkFE/Mlf0xhuPK6Nq87P
         nWoALt8YogrZOwUtqGp541pZF6iotS5lVkbln/3xTslPQhpSfSVU6KdsKAJ1/VmqkR
         uUF/NplBt6asg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1ptY9l-00CKYH-VJ;
        Mon, 01 May 2023 19:21:50 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>
Subject: [PATCH] KVM: arm64: vgic: Add Apple M2 PRO/MAX cpus to the list of broken SEIS implementations
Date:   Mon,  1 May 2023 19:21:41 +0100
Message-Id: <20230501182141.39770-1-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UPPERCASE_50_75
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Unsurprisingly, the M2 PRO is also affected by the SEIS bug, so add it
to the naughty list. And since M2 MAX is likely to be of the same ilk,
flag it as well.

Tested on a M2 PRO mini machine.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/cputype.h | 8 ++++++++
 arch/arm64/kvm/vgic/vgic-v3.c    | 4 ++++
 2 files changed, 12 insertions(+)

diff --git a/arch/arm64/include/asm/cputype.h b/arch/arm64/include/asm/cputype.h
index 683ca3af4084..5f6f84837a49 100644
--- a/arch/arm64/include/asm/cputype.h
+++ b/arch/arm64/include/asm/cputype.h
@@ -126,6 +126,10 @@
 #define APPLE_CPU_PART_M1_FIRESTORM_MAX	0x029
 #define APPLE_CPU_PART_M2_BLIZZARD	0x032
 #define APPLE_CPU_PART_M2_AVALANCHE	0x033
+#define APPLE_CPU_PART_M2_BLIZZARD_PRO	0x034
+#define APPLE_CPU_PART_M2_AVALANCHE_PRO	0x035
+#define APPLE_CPU_PART_M2_BLIZZARD_MAX	0x038
+#define APPLE_CPU_PART_M2_AVALANCHE_MAX	0x039
 
 #define AMPERE_CPU_PART_AMPERE1		0xAC3
 
@@ -181,6 +185,10 @@
 #define MIDR_APPLE_M1_FIRESTORM_MAX MIDR_CPU_MODEL(ARM_CPU_IMP_APPLE, APPLE_CPU_PART_M1_FIRESTORM_MAX)
 #define MIDR_APPLE_M2_BLIZZARD MIDR_CPU_MODEL(ARM_CPU_IMP_APPLE, APPLE_CPU_PART_M2_BLIZZARD)
 #define MIDR_APPLE_M2_AVALANCHE MIDR_CPU_MODEL(ARM_CPU_IMP_APPLE, APPLE_CPU_PART_M2_AVALANCHE)
+#define MIDR_APPLE_M2_BLIZZARD_PRO MIDR_CPU_MODEL(ARM_CPU_IMP_APPLE, APPLE_CPU_PART_M2_BLIZZARD_PRO)
+#define MIDR_APPLE_M2_AVALANCHE_PRO MIDR_CPU_MODEL(ARM_CPU_IMP_APPLE, APPLE_CPU_PART_M2_AVALANCHE_PRO)
+#define MIDR_APPLE_M2_BLIZZARD_MAX MIDR_CPU_MODEL(ARM_CPU_IMP_APPLE, APPLE_CPU_PART_M2_BLIZZARD_MAX)
+#define MIDR_APPLE_M2_AVALANCHE_MAX MIDR_CPU_MODEL(ARM_CPU_IMP_APPLE, APPLE_CPU_PART_M2_AVALANCHE_MAX)
 #define MIDR_AMPERE1 MIDR_CPU_MODEL(ARM_CPU_IMP_AMPERE, AMPERE_CPU_PART_AMPERE1)
 
 /* Fujitsu Erratum 010001 affects A64FX 1.0 and 1.1, (v0r0 and v1r0) */
diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
index 469d816f356f..93a47a515c13 100644
--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -616,6 +616,10 @@ static const struct midr_range broken_seis[] = {
 	MIDR_ALL_VERSIONS(MIDR_APPLE_M1_FIRESTORM_MAX),
 	MIDR_ALL_VERSIONS(MIDR_APPLE_M2_BLIZZARD),
 	MIDR_ALL_VERSIONS(MIDR_APPLE_M2_AVALANCHE),
+	MIDR_ALL_VERSIONS(MIDR_APPLE_M2_BLIZZARD_PRO),
+	MIDR_ALL_VERSIONS(MIDR_APPLE_M2_AVALANCHE_PRO),
+	MIDR_ALL_VERSIONS(MIDR_APPLE_M2_BLIZZARD_MAX),
+	MIDR_ALL_VERSIONS(MIDR_APPLE_M2_AVALANCHE_MAX),
 	{},
 };
 
-- 
2.34.1

