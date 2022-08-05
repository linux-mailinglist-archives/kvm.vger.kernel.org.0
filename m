Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8557758AC04
	for <lists+kvm@lfdr.de>; Fri,  5 Aug 2022 15:59:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240836AbiHEN7I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Aug 2022 09:59:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240823AbiHEN6k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Aug 2022 09:58:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 668B365803
        for <kvm@vger.kernel.org>; Fri,  5 Aug 2022 06:58:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2F98D60DB5
        for <kvm@vger.kernel.org>; Fri,  5 Aug 2022 13:58:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71BE6C433D7;
        Fri,  5 Aug 2022 13:58:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659707902;
        bh=fnjZXmQs1tDgHKunRFBtmiC6pfdsO8wOT2zzddjLFLc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MbbYoLwzOiHHLBcNrMYB2NIcsy4kr5yMLUzjt3eSEdihMZYFHXLTA6PaAeCM9crhF
         wQOBWsx4CUoVxT2IqasgqEHjd6/AcYHZxMpug/w3EqN3NDpsCZfK4shatRTxPaf/A0
         IM1STFfUaCOt62d/uoiWmCNNjGbFbU1nRvLqUgt1Ettu09Qak6y54MS3208/d9G/Xn
         OMCCx4GyCzOP+YI8L70bsfMTGdfcZXhr22UoEHgRrTu+6/WhuazRtsrIYbElq6FTRY
         AYuOoZ4O6eiU6j+LjXZyjbCBplRFLB0gQoAHEhRYNvIAYqVGV2F3D/n+DytpfezoZW
         ugFd/k71x5jqA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1oJxqG-001AeL-Mw;
        Fri, 05 Aug 2022 14:58:20 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Ricardo Koller <ricarkol@google.com>, kernel-team@android.com
Subject: [PATCH 7/9] KVM: arm64: PMU: Allow ID_AA64DFR0_EL1.PMUver to be set from userspace
Date:   Fri,  5 Aug 2022 14:58:11 +0100
Message-Id: <20220805135813.2102034-8-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220805135813.2102034-1-maz@kernel.org>
References: <20220805135813.2102034-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, oliver.upton@linux.dev, ricarkol@google.com, kernel-team@android.com
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

Allow userspace to write ID_AA64DFR0_EL1, on the condition that only
the PMUver field can be altered and be at most the one that was
initially computed for the guest.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 35 ++++++++++++++++++++++++++++++++++-
 1 file changed, 34 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 55451f49017c..c0595f31dab8 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1236,6 +1236,38 @@ static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
+static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
+			       const struct sys_reg_desc *rd,
+			       u64 val)
+{
+	u8 pmuver, host_pmuver;
+
+	host_pmuver = kvm_arm_pmu_get_host_pmuver();
+
+	/*
+	 * Allow AA64DFR0_EL1.PMUver to be set from userspace as long
+	 * as it doesn't promise more than what the HW gives us. We
+	 * don't allow an IMPDEF PMU though.
+	 */
+	pmuver = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_PMUVER), val);
+	if (pmuver == ID_AA64DFR0_PMUVER_IMP_DEF || pmuver > host_pmuver)
+		return -EINVAL;
+
+	/* We already have a PMU, don't try to disable it... */
+	if (kvm_vcpu_has_pmu(vcpu) && pmuver == 0)
+		return -EINVAL;
+
+	/* We can only differ with PMUver, and anything else is an error */
+	val ^= read_id_reg(vcpu, rd, false);
+	val &= ~(0xFUL << ID_AA64DFR0_PMUVER_SHIFT);
+	if (val)
+		return -EINVAL;
+
+	vcpu->kvm->arch.dfr0_pmuver = pmuver;
+
+	return 0;
+}
+
 /*
  * cpufeature ID register user accessors
  *
@@ -1510,7 +1542,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	ID_UNALLOCATED(4,7),
 
 	/* CRm=5 */
-	ID_SANITISED(ID_AA64DFR0_EL1),
+	{ SYS_DESC(SYS_ID_AA64DFR0_EL1), .access = access_id_reg,
+	  .get_user = get_id_reg, .set_user = set_id_aa64dfr0_el1, },
 	ID_SANITISED(ID_AA64DFR1_EL1),
 	ID_UNALLOCATED(5,2),
 	ID_UNALLOCATED(5,3),
-- 
2.34.1

