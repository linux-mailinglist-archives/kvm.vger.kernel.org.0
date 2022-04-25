Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A6D450ED03
	for <lists+kvm@lfdr.de>; Tue, 26 Apr 2022 01:55:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238630AbiDYX5J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Apr 2022 19:57:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238644AbiDYX5G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Apr 2022 19:57:06 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D689B1102B4
        for <kvm@vger.kernel.org>; Mon, 25 Apr 2022 16:53:53 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id u3-20020a637903000000b003ab040c4807so2398997pgc.13
        for <kvm@vger.kernel.org>; Mon, 25 Apr 2022 16:53:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=IxHNHx5wJBVm+rn+jgN7nIqGaCqRxbvwWyLEAglKnWI=;
        b=BO1aKVrSqDD9Ar0XuW9GCnstLd6dqzKgozWJIYb2AWXq+i9HInlKJW+JM8QQ7DwNfq
         BzCri9AGFee+/Cg03nTnxQknM85IOpD1VLlaks2DOYHxTnDc0GDUtxrn8jFmyoc7Iwya
         LrB+PzlU7uNFxxEbFBLUDx5GqzUBM7Du2WHaUmp1uEqjJpahl6fY2OEUueuS+fJmFePz
         a6GUInOaDxJD1otn6Q5byCPbTRs090t5DzYKPvMKlUexwbyBZUActCjMi/Rb70jJQGGo
         AnZYlz5v/iyJreScwHMG3OgX0zXV7QcvUfaDMbRUc+hIMqqSyjWDHX4b1AwE+Ci//r06
         uqfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=IxHNHx5wJBVm+rn+jgN7nIqGaCqRxbvwWyLEAglKnWI=;
        b=1J+wePlvPxZ5sI0kPekpVuZsA60N6cliAqZWSwFzveWx6XaGl5JQ1VAaTbWfrOodxT
         qgyed543j38p3TkLKljg0R3vczHmgpqp/tLKsCPxT5x8RnNB+i2QHNVJsLdZQR2kdcS8
         DGKaIhC1qE90ySEvWocPJAJ2pbuAAXMJQThXyh/AzVrNqYS0r7WJBM51KVTyUEsb408T
         9PUg11OfGBgYuMrpo+tybCrHgDXtf6c4G5tU3ans56fJ9VjyXAQLoKnMVv5GJun4MMkR
         o9JINHUhMSYLrp3pafZp3kYRD6qaEunCbYvrCXi6F7G1jhkf9S68Jlb6XMBK5RgK6vX7
         rUsg==
X-Gm-Message-State: AOAM532PVRcmxffWeAtzyisXxaZJ8IMzqqANdQtUi1vYequfIm2gee04
        beoWjG1XYiGhF60V1neLByUdiNPnwD8=
X-Google-Smtp-Source: ABdhPJy8VMFMNE9Q7UkBKYVM4qUrLDosnMII9dPPPSbr5WKYB/hKuYfHo0mtNOfXwW2DsxYsAqekF2bfA/Q=
X-Received: from oupton3.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:21eb])
 (user=oupton job=sendgmr) by 2002:a17:90a:9105:b0:1d2:9e98:7e1e with SMTP id
 k5-20020a17090a910500b001d29e987e1emr1694934pjo.0.1650930832927; Mon, 25 Apr
 2022 16:53:52 -0700 (PDT)
Date:   Mon, 25 Apr 2022 23:53:42 +0000
In-Reply-To: <20220425235342.3210912-1-oupton@google.com>
Message-Id: <20220425235342.3210912-6-oupton@google.com>
Mime-Version: 1.0
References: <20220425235342.3210912-1-oupton@google.com>
X-Mailer: git-send-email 2.36.0.rc2.479.g8af0fa9b8e-goog
Subject: [PATCH v3 5/5] KVM: arm64: Start trapping ID registers for 32 bit guests
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
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
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
index 7496deab025a..ab5c66b77bb0 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -86,13 +86,6 @@ static inline void vcpu_reset_hcr(struct kvm_vcpu *vcpu)
 
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
2.36.0.rc2.479.g8af0fa9b8e-goog

