Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6621A712884
	for <lists+kvm@lfdr.de>; Fri, 26 May 2023 16:36:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243560AbjEZOgZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 May 2023 10:36:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243670AbjEZOgY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 May 2023 10:36:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5502AE5B
        for <kvm@vger.kernel.org>; Fri, 26 May 2023 07:36:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EAE1465069
        for <kvm@vger.kernel.org>; Fri, 26 May 2023 14:33:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58048C433D2;
        Fri, 26 May 2023 14:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685111635;
        bh=kD0iyRxdqfv2pvJX3Hjwo3JKxYWjJAruZ+EvPdKsFjc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fz488rrt29CFnO8bWJvAl0I475QVEG2yXe+abKp+5FUkAG2vOKhQCs3bnxTeiHYc9
         BFlmQZTVRQQ24sORmWnRCXISPD4YSCuITccWa8tCVWu1WRtNI2s2y3Z0Z8GQd5wvA9
         nCOdVMaw2ieZF1Tkwl+iqG5WRV/OH3S990JPl+iUT0zDdNu7GLk0fWXsyOhMSdOi+H
         LiWWv+Nu2J4HdBpeAVUVpNkA68V8v6YKaagGnUprcttnZYTQB4LdHQSjDeuzAtBwyK
         Q2rcOYxbvpEb/GhotbF8z3Zqba1m34nqyo09br3sz8/TzQY0NjEToH65HuIQoyOgFE
         OdLMKdv3bOmDw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1q2YVt-000aHS-IW;
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
Subject: [PATCH v2 09/17] KVM: arm64: Key use of VHE instructions in nVHE code off ARM64_KVM_HVHE
Date:   Fri, 26 May 2023 15:33:40 +0100
Message-Id: <20230526143348.4072074-10-maz@kernel.org>
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

We can now start with the fun stuff: if we enable VHE *only* for
the hypervisor, we need to generate the VHE instructions when
accessing the system registers.

For this, reporpose the alternative sequence to be keyed off
ARM64_KVM_HVHE in the nVHE hypervisor code, and only there.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_hyp.h | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index fea04eb25cb4..b7238c72a04c 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -33,12 +33,18 @@ DECLARE_PER_CPU(struct kvm_nvhe_init_params, kvm_init_params);
 
 #else // !__KVM_VHE_HYPERVISOR__
 
+#if defined(__KVM_NVHE_HYPERVISOR__)
+#define VHE_ALT_KEY	ARM64_KVM_HVHE
+#else
+#define VHE_ALT_KEY	ARM64_HAS_VIRT_HOST_EXTN
+#endif
+
 #define read_sysreg_elx(r,nvh,vh)					\
 	({								\
 		u64 reg;						\
-		asm volatile(ALTERNATIVE(__mrs_s("%0", r##nvh),	\
+		asm volatile(ALTERNATIVE(__mrs_s("%0", r##nvh),		\
 					 __mrs_s("%0", r##vh),		\
-					 ARM64_HAS_VIRT_HOST_EXTN)	\
+					 VHE_ALT_KEY)			\
 			     : "=r" (reg));				\
 		reg;							\
 	})
@@ -48,7 +54,7 @@ DECLARE_PER_CPU(struct kvm_nvhe_init_params, kvm_init_params);
 		u64 __val = (u64)(v);					\
 		asm volatile(ALTERNATIVE(__msr_s(r##nvh, "%x0"),	\
 					 __msr_s(r##vh, "%x0"),		\
-					 ARM64_HAS_VIRT_HOST_EXTN)	\
+					 VHE_ALT_KEY)			\
 					 : : "rZ" (__val));		\
 	} while (0)
 
-- 
2.34.1

