Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D50BB712883
	for <lists+kvm@lfdr.de>; Fri, 26 May 2023 16:36:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243672AbjEZOgY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 May 2023 10:36:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237293AbjEZOgW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 May 2023 10:36:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BFB3E6D
        for <kvm@vger.kernel.org>; Fri, 26 May 2023 07:36:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D169165042
        for <kvm@vger.kernel.org>; Fri, 26 May 2023 14:33:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FB0BC4339C;
        Fri, 26 May 2023 14:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685111635;
        bh=UaDqzpeXMxTsA0h1VeMgRA4blxON31O7kP8OlVYUq/E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YM7MX8Og8fTJWm0KWs/I7dne4K44omL0VLbEekfs24gCmx9xA4Mk2SjugXCspyakv
         LLi80+GB4edTIHojuCkYRwVpKm0ToLME9mt3vj5p5xOytsOsbAadmZNt4sn72OqB6U
         llDKyzNhvxnzemQqU7FG8OTDdt8jqH1vnqz8+vQDLiKnxrasWtPap7dkD9kRG71+uj
         0r6/EbZ2RVJJiLpjwlbrfCjhHVzEXiX1Q4h706Q5oJEdVG0i/V0rkuL2UGxZWYvjre
         /4IpGBV7jGvCjCFUWJellPhYwmgGr9haAyyCBejFGRStaHW3MTCL28FF1eBsKS6tH5
         /PyI/fRSxuBQg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1q2YVt-000aHS-AY;
        Fri, 26 May 2023 15:33:53 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Quentin Perret <qperret@google.com>,
        Will Deacon <will@kernel.org>, Fuad Tabba <tabba@google.com>
Subject: [PATCH v2 08/17] KVM: arm64: Remove alternatives from sysreg accessors in VHE hypervisor context
Date:   Fri, 26 May 2023 15:33:39 +0100
Message-Id: <20230526143348.4072074-9-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230526143348.4072074-1-maz@kernel.org>
References: <20230526143348.4072074-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, qperret@google.com, will@kernel.org, tabba@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In the VHE hypervisor code, we should be using the remapped VHE
accessors, no ifs, no buts. No need to generate any alternative.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_hyp.h | 25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index bdd9cf546d95..fea04eb25cb4 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -16,6 +16,23 @@ DECLARE_PER_CPU(struct kvm_cpu_context, kvm_hyp_ctxt);
 DECLARE_PER_CPU(unsigned long, kvm_hyp_vector);
 DECLARE_PER_CPU(struct kvm_nvhe_init_params, kvm_init_params);
 
+/*
+ * Unified accessors for registers that have a different encoding
+ * between VHE and non-VHE. They must be specified without their "ELx"
+ * encoding, but with the SYS_ prefix, as defined in asm/sysreg.h.
+ */
+
+#if defined(__KVM_VHE_HYPERVISOR__)
+
+#define read_sysreg_el0(r)	read_sysreg_s(r##_EL02)
+#define write_sysreg_el0(v,r)	write_sysreg_s(v, r##_EL02)
+#define read_sysreg_el1(r)	read_sysreg_s(r##_EL12)
+#define write_sysreg_el1(v,r)	write_sysreg_s(v, r##_EL12)
+#define read_sysreg_el2(r)	read_sysreg_s(r##_EL1)
+#define write_sysreg_el2(v,r)	write_sysreg_s(v, r##_EL1)
+
+#else // !__KVM_VHE_HYPERVISOR__
+
 #define read_sysreg_elx(r,nvh,vh)					\
 	({								\
 		u64 reg;						\
@@ -35,12 +52,6 @@ DECLARE_PER_CPU(struct kvm_nvhe_init_params, kvm_init_params);
 					 : : "rZ" (__val));		\
 	} while (0)
 
-/*
- * Unified accessors for registers that have a different encoding
- * between VHE and non-VHE. They must be specified without their "ELx"
- * encoding, but with the SYS_ prefix, as defined in asm/sysreg.h.
- */
-
 #define read_sysreg_el0(r)	read_sysreg_elx(r, _EL0, _EL02)
 #define write_sysreg_el0(v,r)	write_sysreg_elx(v, r, _EL0, _EL02)
 #define read_sysreg_el1(r)	read_sysreg_elx(r, _EL1, _EL12)
@@ -48,6 +59,8 @@ DECLARE_PER_CPU(struct kvm_nvhe_init_params, kvm_init_params);
 #define read_sysreg_el2(r)	read_sysreg_elx(r, _EL2, _EL1)
 #define write_sysreg_el2(v,r)	write_sysreg_elx(v, r, _EL2, _EL1)
 
+#endif	// __KVM_VHE_HYPERVISOR__
+
 /*
  * Without an __arch_swab32(), we fall back to ___constant_swab32(), but the
  * static inline can allow the compiler to out-of-line this. KVM always wants
-- 
2.34.1

