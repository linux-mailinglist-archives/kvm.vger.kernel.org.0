Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1233546292
	for <lists+kvm@lfdr.de>; Fri, 10 Jun 2022 11:35:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348172AbiFJJfi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jun 2022 05:35:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348469AbiFJJfh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jun 2022 05:35:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 126FB2A95C
        for <kvm@vger.kernel.org>; Fri, 10 Jun 2022 02:35:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 43FFCB83310
        for <kvm@vger.kernel.org>; Fri, 10 Jun 2022 09:35:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0ED1C34114;
        Fri, 10 Jun 2022 09:35:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654853730;
        bh=758kdgbfRBxqYLfubpHfal7ect+RIRPul5AalTtWWUs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UTricDyp2IaeH42popcAYWhyNnS4tepGtWOLDkU8d4biCfbLcp9ZVO1D8oQcUapRs
         IgwLeq8XX+6T7a4E+iPCYMANAB0CbibdWPVHnGvqc+0NSB50vDGGNMl3scHlTijpXe
         H8hcCEod9vLevhsgme4lmr0FsDf3NCRDjrjzRoeqos283mGB+LWkAsFCGO2Yhtcts4
         CCJ1qYGmG7v+vKFtpCgPOsXNdOU6147qT79Fy8KANKcjX1mzKYRKP0BmF3bGfIDK5c
         iIJ8ihxc2UEkCsNkHI4t6GG66J9aKZ5zIceuZai6UAFoyQ+aNymP/MYDLhXoEta4Sp
         T154cU/SLxrlQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1nzawq-00H6Dt-Ff; Fri, 10 Jun 2022 10:28:56 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Oliver Upton <oupton@google.com>,
        Will Deacon <will@kernel.org>, Fuad Tabba <tabba@google.com>,
        Quentin Perret <qperret@google.com>,
        Mark Brown <broonie@kernel.org>,
        Reiji Watanabe <reijiw@google.com>, kernel-team@android.com
Subject: [PATCH v2 11/19] KVM: arm64: Move vcpu ON_UNSUPPORTED_CPU flag to the state flag set
Date:   Fri, 10 Jun 2022 10:28:30 +0100
Message-Id: <20220610092838.1205755-12-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220610092838.1205755-1-maz@kernel.org>
References: <20220610092838.1205755-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, oupton@google.com, will@kernel.org, tabba@google.com, qperret@google.com, broonie@kernel.org, reijiw@google.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

Reviewed-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 4f147bdc5ce9..0c22514cb7c7 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -519,6 +519,8 @@ struct kvm_vcpu_arch {
 #define HOST_SVE_ENABLED	__vcpu_single_flag(sflags, BIT(0))
 /* SME enabled for EL0 */
 #define HOST_SME_ENABLED	__vcpu_single_flag(sflags, BIT(1))
+/* Physical CPU not in supported_cpus */
+#define ON_UNSUPPORTED_CPU	__vcpu_single_flag(sflags, BIT(2))
 
 /* Pointer to the vcpu's SVE FFR for sve_{save,load}_state() */
 #define vcpu_sve_pffr(vcpu) (kern_hyp_va((vcpu)->arch.sve_state) +	\
@@ -541,7 +543,6 @@ struct kvm_vcpu_arch {
 })
 
 /* vcpu_arch flags field values: */
-#define KVM_ARM64_ON_UNSUPPORTED_CPU	(1 << 15) /* Physical CPU not in supported_cpus */
 #define KVM_ARM64_WFIT			(1 << 17) /* WFIT instruction trapped */
 #define KVM_GUESTDBG_VALID_MASK (KVM_GUESTDBG_ENABLE | \
 				 KVM_GUESTDBG_USE_SW_BP | \
@@ -561,13 +562,13 @@ struct kvm_vcpu_arch {
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

