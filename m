Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD7F7605AA8
	for <lists+kvm@lfdr.de>; Thu, 20 Oct 2022 11:07:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231147AbiJTJHy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Oct 2022 05:07:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230318AbiJTJHo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Oct 2022 05:07:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF10F19B655
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 02:07:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3430FB826B4
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 09:07:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA6F7C433B5;
        Thu, 20 Oct 2022 09:07:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666256859;
        bh=ofpdzFYKOYn+eXOLFJLXsfl4t5FhR9196xaEkofE7aM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PTKdsBtzypQOm/L/vDlDpw07NNLw1kHTybU9V7/i4EGa59YfJNdmnyX2nDzNWs9Wy
         KzYzWNuEJyCpt/tFL0ZgKpqu4SUz147DQUUJRaRFfRvSaJMTbfRoT/w8cgbyGDd5Ud
         u1Q6ybU8k1ONx7GWM5XA3e4gfpZByeAC0mE8OIwIJlI18ZYuovG2HeeeRhrEf2kyGl
         O5P50ATFagZK1Z7odQdCot1u4WqCSv0/CCdltOhORsHnEq6HaSkKkv8GcATRuiYxJR
         rbhRdwfD9uHser7UPh4VCAwWzWpXE0PYa7K8+NnLNzdGjI+NsKxRv8v2Vjx0/v7Rlw
         xWbwiZJ/4mwfw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1olRWa-000Buf-Qe;
        Thu, 20 Oct 2022 10:07:36 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     <kvmarm@lists.cs.columbia.edu>, <kvmarm@lists.linux.dev>,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Quentin Perret <qperret@google.com>,
        Will Deacon <will@kernel.org>, Fuad Tabba <tabba@google.com>
Subject: [PATCH 09/17] KVM: arm64: Key use of VHE instructions in nVHE code off ARM64_KVM_HVHE
Date:   Thu, 20 Oct 2022 10:07:19 +0100
Message-Id: <20221020090727.3669908-10-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221020090727.3669908-1-maz@kernel.org>
References: <20221020090727.3669908-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, oliver.upton@linux.dev, qperret@google.com, will@kernel.org, tabba@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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
index 461fc0dc4a70..e45215a62b43 100644
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

