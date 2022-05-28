Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD355536CA8
	for <lists+kvm@lfdr.de>; Sat, 28 May 2022 13:50:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234860AbiE1Lt4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 28 May 2022 07:49:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234641AbiE1Ltz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 28 May 2022 07:49:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7329DFF
        for <kvm@vger.kernel.org>; Sat, 28 May 2022 04:49:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 845D4B826FD
        for <kvm@vger.kernel.org>; Sat, 28 May 2022 11:49:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24207C34100;
        Sat, 28 May 2022 11:49:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653738592;
        bh=N0NNp71i7DfCF28Gn1//ZvCMFd8ZM8wQyOhM8D3TpFo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=POkvcqcM/zISGrTrfs/06p5WIB6cFBniHoIl8hdw+/hFD8yZfL/zMblqwioESv8ZK
         EBrJllFUcTdqPoUu6KsVNGQKIgUVgPccW81QT1EnVWSqnRvU1qIFg41ZBc9MztI/B1
         F8bhfFIIbXlkMidzI5txFiESLJn44CrA6jKD2W3+UcNHF66DH0+aFJFZ61ncOrF6Rt
         wd+Qks8nXzUigfLRIvZbMDBULPAHUXampzzlteT6PEEOrQI7RxGcfnJCW0nc7UDgKV
         EO5jXBpA8uOWnt1vbAfW7qwi4Gai1hcwk3SrJOsazqvAsEF24j6cGHgOJODVtvWD5K
         m8kaJsjL6FxzA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1nuumC-00EEGh-1n; Sat, 28 May 2022 12:38:36 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Oliver Upton <oupton@google.com>,
        Will Deacon <will@kernel.org>, Fuad Tabba <tabba@google.com>,
        Quentin Perret <qperret@google.com>,
        Mark Brown <broonie@kernel.org>, kernel-team@android.com
Subject: [PATCH 11/18] KVM: arm64: Move vcpu ON_UNSUPPORTED_CPU flag to the state flag set
Date:   Sat, 28 May 2022 12:38:21 +0100
Message-Id: <20220528113829.1043361-12-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220528113829.1043361-1-maz@kernel.org>
References: <20220528113829.1043361-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, oupton@google.com, will@kernel.org, tabba@google.com, qperret@google.com, broonie@kernel.org, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The ON_UNSUPPORTED_CPU flag is only there to track the sad fact
that we have ended-up on a CPU where we cannot really run.

Since this is only for the host kernel's use, move it to the state
set.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index a28a2dca8767..e0a2edca5861 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -511,6 +511,8 @@ struct kvm_vcpu_arch {
 #define HOST_SVE_ENABLED	__vcpu_single_flag(sflags, BIT(0))
 /* SME enabled for EL0 */
 #define HOST_SME_ENABLED	__vcpu_single_flag(sflags, BIT(1))
+/* Physical CPU not in supported_cpus */
+#define ON_UNSUPPORTED_CPU	__vcpu_single_flag(sflags, BIT(2))
 
 /* Pointer to the vcpu's SVE FFR for sve_{save,load}_state() */
 #define vcpu_sve_pffr(vcpu) (kern_hyp_va((vcpu)->arch.sve_state) +	\
@@ -533,7 +535,6 @@ struct kvm_vcpu_arch {
 })
 
 /* vcpu_arch flags field values: */
-#define KVM_ARM64_ON_UNSUPPORTED_CPU	(1 << 15) /* Physical CPU not in supported_cpus */
 #define KVM_ARM64_WFIT			(1 << 17) /* WFIT instruction trapped */
 #define KVM_GUESTDBG_VALID_MASK (KVM_GUESTDBG_ENABLE | \
 				 KVM_GUESTDBG_USE_SW_BP | \
@@ -553,13 +554,13 @@ struct kvm_vcpu_arch {
 #endif
 
 #define vcpu_on_unsupported_cpu(vcpu)					\
-	((vcpu)->arch.flags & KVM_ARM64_ON_UNSUPPORTED_CPU)
+	vcpu_get_flag(vcpu, ON_UNSUPPORTED_CPU)
 
 #define vcpu_set_on_unsupported_cpu(vcpu)				\
-	((vcpu)->arch.flags |= KVM_ARM64_ON_UNSUPPORTED_CPU)
+	vcpu_set_flag(vcpu, ON_UNSUPPORTED_CPU)
 
 #define vcpu_clear_on_unsupported_cpu(vcpu)				\
-	((vcpu)->arch.flags &= ~KVM_ARM64_ON_UNSUPPORTED_CPU)
+	vcpu_clear_flag(vcpu, ON_UNSUPPORTED_CPU)
 
 #define vcpu_gp_regs(v)		(&(v)->arch.ctxt.regs)
 
-- 
2.34.1

