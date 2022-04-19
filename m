Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3837F50794D
	for <lists+kvm@lfdr.de>; Tue, 19 Apr 2022 20:42:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357310AbiDSSg7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Apr 2022 14:36:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357344AbiDSSgu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Apr 2022 14:36:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE3244BFF4
        for <kvm@vger.kernel.org>; Tue, 19 Apr 2022 11:28:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ABFD461500
        for <kvm@vger.kernel.org>; Tue, 19 Apr 2022 18:28:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 108DBC385AE;
        Tue, 19 Apr 2022 18:28:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650392887;
        bh=WTSGbHSbmfmHWAy9D3aVTWCpO7YVxCypnvPY1Fp2Syo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rCvMzrhUYxVyuxpP3MuTSHG0wFPZg480Kyb+lg4pTFwE6A1k9FgYN0aUZqetdsxsh
         ABlKwK0KoM8k6M3r1hmVH9UdPeQfUf2K2E0vMTZVhd2Orah3G8MghySdOj9ar6xzO6
         QYPLRcT6PQBNqS4ITtQ4UJFKcWboBb0xv2HtGGbudRn+/GkGO94lKszW6IMjX1ROne
         oQPDFoP8qPXlH1CQN7EjelZ8l57bYUHYqK+oOj7LXR581aNXgzvzQmtXeUo9/8UPMx
         xl7HRXNdyVC4F+maZJtUCssuOVD/A+MT5DRyBkpS0ZHbIlPOXKou6Ap/5ABa8NVn5I
         wTljq4Qh4iyHA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1ngsa4-005QYF-VV; Tue, 19 Apr 2022 19:28:05 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Joey Gouly <joey.gouly@arm.com>, kernel-team@android.com
Subject: [PATCH v2 03/10] KVM: arm64: Simplify kvm_cpu_has_pending_timer()
Date:   Tue, 19 Apr 2022 19:27:48 +0100
Message-Id: <20220419182755.601427-4-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220419182755.601427-1-maz@kernel.org>
References: <20220419182755.601427-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, joey.gouly@arm.com, kernel-team@android.com
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

kvm_cpu_has_pending_timer() ends up checking all the possible
timers for a wake-up cause. However, we already check for
pending interrupts whenever we try to wake-up a vcpu, including
the timer interrupts.

Obviously, doing the same work twice is once too many. Reduce
this helper to almost nothing, but keep it around, as we are
going to make use of it soon.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/arch_timer.c  | 10 ++--------
 arch/arm64/kvm/arm.c         |  5 -----
 include/kvm/arm_arch_timer.h |  2 --
 3 files changed, 2 insertions(+), 15 deletions(-)

diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index 6e542e2eae32..16dda1a383a6 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -350,15 +350,9 @@ static bool kvm_timer_should_fire(struct arch_timer_context *timer_ctx)
 	return cval <= now;
 }
 
-bool kvm_timer_is_pending(struct kvm_vcpu *vcpu)
+int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu)
 {
-	struct timer_map map;
-
-	get_timer_map(vcpu, &map);
-
-	return kvm_timer_should_fire(map.direct_vtimer) ||
-	       kvm_timer_should_fire(map.direct_ptimer) ||
-	       kvm_timer_should_fire(map.emul_ptimer);
+	return 0;
 }
 
 /*
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 523bc934fe2f..2122c699af06 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -356,11 +356,6 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 	kvm_arm_vcpu_destroy(vcpu);
 }
 
-int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu)
-{
-	return kvm_timer_is_pending(vcpu);
-}
-
 void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu)
 {
 
diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
index 51c19381108c..cd6d8f260eab 100644
--- a/include/kvm/arm_arch_timer.h
+++ b/include/kvm/arm_arch_timer.h
@@ -76,8 +76,6 @@ int kvm_arm_timer_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr);
 int kvm_arm_timer_get_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr);
 int kvm_arm_timer_has_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr);
 
-bool kvm_timer_is_pending(struct kvm_vcpu *vcpu);
-
 u64 kvm_phys_timer_read(void);
 
 void kvm_timer_vcpu_load(struct kvm_vcpu *vcpu);
-- 
2.34.1

