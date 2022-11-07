Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E2E561EDC8
	for <lists+kvm@lfdr.de>; Mon,  7 Nov 2022 09:55:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231448AbiKGIzG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Nov 2022 03:55:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231481AbiKGIzA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Nov 2022 03:55:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C16785F6C
        for <kvm@vger.kernel.org>; Mon,  7 Nov 2022 00:54:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5E4B960F59
        for <kvm@vger.kernel.org>; Mon,  7 Nov 2022 08:54:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 302D7C433C1;
        Mon,  7 Nov 2022 08:54:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667811299;
        bh=1MGy/QeMLxL2CeOt6PAMUGtVNnUoFMhc4YFKjn7bA+o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BHSpl37PyS9UD7KpTMinH5idrkCKRejExK7CADYpgkMlcYwf81rJ+loFBn3GksfWc
         9TPE7nm1i551Vwq8r/72nQm6pnxjhLbUBg/MuUs5B1W9uEHe26EjFuZ1on09kNQxos
         1Btu/TCJARMvFaJaGId20k9ehUeBsxKjRFDUO8KSVtI/GXurgPsYrrwpJyWlfGbZYO
         0ZicSAOqNCbHU5j6fpsUuFQXb9rGq4u4Vdz+Iqm36Z7U04UiHWr1iX2w8xtrmBgxXW
         D6nAAbhPLly2DwsjX6dQIh8b71HXJWXOftGldaCjuMe95LY7IRuBpjrzpgCEhIOvm5
         UdiyCCTzW2YIw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1orxuD-004KxX-8Z;
        Mon, 07 Nov 2022 08:54:57 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org,
        <kvmarm@lists.cs.columbia.edu>, <kvmarm@lists.linux.dev>,
        kvm@vger.kernel.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>
Subject: [PATCH v3 08/14] KVM: arm64: PMU: Simplify setting a counter to a specific value
Date:   Mon,  7 Nov 2022 08:54:29 +0000
Message-Id: <20221107085435.2581641-9-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221107085435.2581641-1-maz@kernel.org>
References: <20221107085435.2581641-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvmarm@lists.linux.dev, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, oliver.upton@linux.dev, ricarkol@google.com, reijiw@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

kvm_pmu_set_counter_value() is pretty odd, as it tries to update
the counter value while taking into account the value that is
currently held by the running perf counter.

This is not only complicated, this is quite wrong. Nowhere in
the architecture is it said that the counter would be offset
by something that is pending. The counter should be updated
with the value set by SW, and start counting from there if
required.

Remove the odd computation and just assign the provided value
after having released the perf event (which is then restarted).

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/pmu-emul.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 44ad0fdba4db..03b761a63f5f 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -23,6 +23,7 @@ static LIST_HEAD(arm_pmus);
 static DEFINE_MUTEX(arm_pmus_lock);
 
 static void kvm_pmu_create_perf_event(struct kvm_vcpu *vcpu, u64 select_idx);
+static void kvm_pmu_release_perf_event(struct kvm_pmc *pmc);
 
 static u32 kvm_pmu_event_mask(struct kvm *kvm)
 {
@@ -131,8 +132,10 @@ void kvm_pmu_set_counter_value(struct kvm_vcpu *vcpu, u64 select_idx, u64 val)
 	if (!kvm_vcpu_has_pmu(vcpu))
 		return;
 
+	kvm_pmu_release_perf_event(&vcpu->arch.pmu.pmc[select_idx]);
+
 	reg = counter_index_to_reg(select_idx);
-	__vcpu_sys_reg(vcpu, reg) += (s64)val - kvm_pmu_get_counter_value(vcpu, select_idx);
+	__vcpu_sys_reg(vcpu, reg) = val;
 
 	/* Recreate the perf event to reflect the updated sample_period */
 	kvm_pmu_create_perf_event(vcpu, select_idx);
-- 
2.34.1

