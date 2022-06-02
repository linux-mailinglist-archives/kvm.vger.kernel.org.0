Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84F1953B52A
	for <lists+kvm@lfdr.de>; Thu,  2 Jun 2022 10:31:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232428AbiFBIaq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 04:30:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232421AbiFBIak (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 04:30:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A91D8D9A
        for <kvm@vger.kernel.org>; Thu,  2 Jun 2022 01:30:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 28E73B81EE8
        for <kvm@vger.kernel.org>; Thu,  2 Jun 2022 08:30:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE15DC3411D;
        Thu,  2 Jun 2022 08:30:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654158635;
        bh=haGu+jI7bthU49uBnWUYZDqFo4eo6P3HlxDw/iKv+bg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OoyfVgdGWh8QTZLWKeBSKcxkFIirLp5xe3j7V5r2WxMNbDdnhrk/Ko5L48eQhRUoI
         0V1HnqR6lRKJWYMRPOh28MQ4dArtnypScXYhp+Un6xK33q+E+/3X8NMSZGs6RqFD/b
         2wcWISq6TwYnTTAAgyLChmLVU1dK9OSYNYfd3gcYPrqe4JBv6IJLxJ1V18Ensi1kcA
         ozBh8bNVFXn61deaBDnRTzNlwh//OnQiJiGwB01W2L65Ek9Lb1TJA9sMR+JPtWSkv/
         fElVFC6PRZW8/evhKrLepQaxNX3w5kp5aRgdPiySH/ha55Pxx25W9YutgjvVJ3S7ej
         TKGROVgwqUmKA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1nwgDx-00F9Sj-FB; Thu, 02 Jun 2022 09:30:33 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org
Cc:     Eric Auger <eauger@redhat.com>,
        Ricardo Koller <ricarkol@google.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Oliver Upton <oupton@google.com>, kernel-team@android.com
Subject: [PATCH 3/3] KVM: arm64: Warn if accessing timer pending state outside of vcpu context
Date:   Thu,  2 Jun 2022 09:30:25 +0100
Message-Id: <20220602083025.1110433-4-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220602083025.1110433-1-maz@kernel.org>
References: <20220602083025.1110433-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, eauger@redhat.com, ricarkol@google.com, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, oupton@google.com, kernel-team@android.com
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

A recurrent bug in the KVM/arm64 code base consists in trying to
access the timer pending state outside of the vcpu context, which
makes zero sense (the pending state only exists when the vcpu
is loaded).

In order to avoid more embarassing crashes and catch the offenders
red-handed, add a warning to kvm_arch_timer_get_input_level() and
return the state as non-pending. This avoids taking the system down,
and still helps tracking down silly bugs.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/arch_timer.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index 5290ca5db663..bb24a76b4224 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -1230,6 +1230,9 @@ bool kvm_arch_timer_get_input_level(int vintid)
 	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
 	struct arch_timer_context *timer;
 
+	if (WARN(!vcpu, "No vcpu context!\n"))
+		return false;
+
 	if (vintid == vcpu_vtimer(vcpu)->irq.irq)
 		timer = vcpu_vtimer(vcpu);
 	else if (vintid == vcpu_ptimer(vcpu)->irq.irq)
-- 
2.34.1

