Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D447517CFB
	for <lists+kvm@lfdr.de>; Tue,  3 May 2022 08:02:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229666AbiECGGA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 May 2022 02:06:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbiECGFs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 May 2022 02:05:48 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7FE133351
        for <kvm@vger.kernel.org>; Mon,  2 May 2022 23:02:16 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id y17-20020a637d11000000b003ab06870074so7989130pgc.15
        for <kvm@vger.kernel.org>; Mon, 02 May 2022 23:02:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=szYmrqPYm2+NRRnt6PLMcdW9lpIQNg8jUIBDaOx8F6c=;
        b=V0Ff2JHN/1ixKrZ4eXGKn+a1zJeLIYlGYLahoOCZr8dElnZtvoleLd1AUljKq2Go9d
         rH4xnD+d0QINZ8krn4kU/t4Al1gAUsxZeaOoqF4H59F5jNmYCo6PfQ/j996ln7nA7iu8
         pcY1n42K41AdqbRiqGlMilri6fmVwnRuNxSSChGk4LLAFC+zWHSxjezK72kFqeIKYTCR
         qEjEjFBkaHLm853u2Nu+XOemUA5hy7bvcgJzwKdVriGETjug41pMjNR07Ya9twKoO51H
         4xtYqUYCWtZr+UavK1Se7ZAlRTGAHQ3RkVEeWKw8se1PuhyA07Pf+d7OgRKMC7GNtttW
         Ntug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=szYmrqPYm2+NRRnt6PLMcdW9lpIQNg8jUIBDaOx8F6c=;
        b=NzlrYdG8P72mK9B6fYi8Gjyo6sVIEhMYmbu2vC4x3TRJC8pStnJ52LLhHrYym8DdL4
         GIcxerFee+6adQg71dGkoE+a45t3rI0QMKa9IAhEYlWDdrJy1J3AdLNcrkLJIycqbdgk
         InfVqK5qySe8HEs9bYqEAdkjK+I2OQJZcISg8LgXJNErZWW6UsJjZNL0K9/XeqT8wqLe
         Qbt/Z3SNC2bjkfJEEc29FYfZI7QHkcJKV49Ps5VBA0LuyWIetQD+d1FquolzOwWRjdGO
         htNAU3GsZ/j5ZdUdwZkfvB8OZyCT8cN77bTgOjdbIu+4fO/mmw5RefnGTU0oTR9uQHY9
         2zbg==
X-Gm-Message-State: AOAM533i4TvCWCwh1BsiJgDN7Ebk50cgxcHrNswytsDd1FnD3vj72yim
        px/yh5kv+Aopo5+BnAIvBVYRJCvjil8=
X-Google-Smtp-Source: ABdhPJzb2TkawwG87rw4pGRJ8PwWuWWZ0LiwEjnIjgPb3w5iW4PoKAlHdEQUIZdxC52BhyeVWcl2kMFzdMo=
X-Received: from oupton3.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:21eb])
 (user=oupton job=sendgmr) by 2002:a05:6a00:1496:b0:50d:9f76:ec7b with SMTP id
 v22-20020a056a00149600b0050d9f76ec7bmr14700869pfu.58.1651557736423; Mon, 02
 May 2022 23:02:16 -0700 (PDT)
Date:   Tue,  3 May 2022 06:02:03 +0000
In-Reply-To: <20220503060205.2823727-1-oupton@google.com>
Message-Id: <20220503060205.2823727-6-oupton@google.com>
Mime-Version: 1.0
References: <20220503060205.2823727-1-oupton@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH v4 5/7] KVM: arm64: Start trapping ID registers for 32 bit guests
From:   Oliver Upton <oupton@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, maz@kernel.org, james.morse@arm.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        reijiw@google.com, ricarkol@google.com,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To date KVM has not trapped ID register accesses from AArch32, meaning
that guests get an unconstrained view of what hardware supports. This
can be a serious problem because we try to base the guest's feature
registers on values that are safe system-wide. Furthermore, KVM does not
implement the latest ISA in the PMU and Debug architecture, so we
constrain these fields to supported values.

Since KVM now correctly handles CP15 and CP10 register traps, we no
longer need to clear HCR_EL2.TID3 for 32 bit guests and will instead
emulate reads with their safe values.

Signed-off-by: Oliver Upton <oupton@google.com>
Reviewed-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/include/asm/kvm_arm.h     | 3 ++-
 arch/arm64/include/asm/kvm_emulate.h | 7 -------
 2 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 1767ded83888..b5de102928d8 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -80,11 +80,12 @@
  * FMO:		Override CPSR.F and enable signaling with VF
  * SWIO:	Turn set/way invalidates into set/way clean+invalidate
  * PTW:		Take a stage2 fault if a stage1 walk steps in device memory
+ * TID3:	Trap EL1 reads of group 3 ID registers
  */
 #define HCR_GUEST_FLAGS (HCR_TSC | HCR_TSW | HCR_TWE | HCR_TWI | HCR_VM | \
 			 HCR_BSU_IS | HCR_FB | HCR_TACR | \
 			 HCR_AMO | HCR_SWIO | HCR_TIDCP | HCR_RW | HCR_TLOR | \
-			 HCR_FMO | HCR_IMO | HCR_PTW )
+			 HCR_FMO | HCR_IMO | HCR_PTW | HCR_TID3 )
 #define HCR_VIRT_EXCP_MASK (HCR_VSE | HCR_VI | HCR_VF)
 #define HCR_HOST_NVHE_FLAGS (HCR_RW | HCR_API | HCR_APK | HCR_ATA)
 #define HCR_HOST_NVHE_PROTECTED_FLAGS (HCR_HOST_NVHE_FLAGS | HCR_TSC)
diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index f71358271b71..07812680fcaf 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -87,13 +87,6 @@ static inline void vcpu_reset_hcr(struct kvm_vcpu *vcpu)
 
 	if (vcpu_el1_is_32bit(vcpu))
 		vcpu->arch.hcr_el2 &= ~HCR_RW;
-	else
-		/*
-		 * TID3: trap feature register accesses that we virtualise.
-		 * For now this is conditional, since no AArch32 feature regs
-		 * are currently virtualised.
-		 */
-		vcpu->arch.hcr_el2 |= HCR_TID3;
 
 	if (cpus_have_const_cap(ARM64_MISMATCHED_CACHE_TYPE) ||
 	    vcpu_el1_is_32bit(vcpu))
-- 
2.36.0.464.gb9c8b46e94-goog

