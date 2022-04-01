Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CAAF4EE596
	for <lists+kvm@lfdr.de>; Fri,  1 Apr 2022 03:08:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243656AbiDABKe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 31 Mar 2022 21:10:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243658AbiDABKb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 31 Mar 2022 21:10:31 -0400
Received: from mail-il1-x14a.google.com (mail-il1-x14a.google.com [IPv6:2607:f8b0:4864:20::14a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDEC1140A8
        for <kvm@vger.kernel.org>; Thu, 31 Mar 2022 18:08:42 -0700 (PDT)
Received: by mail-il1-x14a.google.com with SMTP id y2-20020a056e020f4200b002c9de5a79a1so833109ilj.23
        for <kvm@vger.kernel.org>; Thu, 31 Mar 2022 18:08:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=KA/GWZbBcAZRmPygWsfcVB729yBAl8Atyl9ZfVZwME0=;
        b=sMywx6e53vxiNm4E7wJ847vJbS+tcnm34/ZvNhHoQYy3ROOnRY8CHkP+7EpwRTLD2h
         AEVnejaGwfgGzpWlTAvEbVcBQm1DiuJymuDnOlrWvcpiYhiAAfIie8xcEH5/lV2gi+Rg
         rIeKknmv5TNIOdJJvLCVQvMIxhl5TA5nhOFphDxuLihvtPjhacgeXFDDGIijv/QtJEP4
         VQEi8k5K+UV2d75IyliDY1pMTb/7L71JmYJYDFuFb1xuspzzyYBYfjE4S1v5dqgIZyeU
         bgfxp0AuTGYKCl70CX9fglhMu9JKuwbtXv4epNY207xjuTeVr5xPsSH8+Cy5xh0SKL6A
         +x7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=KA/GWZbBcAZRmPygWsfcVB729yBAl8Atyl9ZfVZwME0=;
        b=1QZK6F4xA5M7ykVtb27AsRIVhOPzo6gmPKz4+nmoXGySvhi34UgYVMA5w726T/DUNh
         9Vjt4au1I+kcD/lLuvO50a2n4F7EkYyMFQIalENtQ3THFrZ0RUFTSoYBeFiiW96JQAAT
         ZpBV7lVefFDOshF+2rb0JBjYFYsviJnx0mVVg3+/qOLcO0+UBmfSYslwrHWnnJsEPU/N
         fk5JR6XvX1slBKAtJVTdBb80sUnHK1rfz/pnPVU+Pak9AvddL3E8dnyOjpyB/mt3mUnY
         r4VA1uk0pLBhy3FFys1+JI+MSyEN5pd0D7mjg6LBaYdM7flwymhqUXlVsA3Qtr/fX41B
         UhhA==
X-Gm-Message-State: AOAM530OHqP2x6G8aL0rmGip9+GO9E3YEZ1Udkzn53YsSgoLw5zgotB+
        WowkTsKjCAcv64YkzdQbc3nlzLnFBQE=
X-Google-Smtp-Source: ABdhPJxcIUgZkoq89DTW0ywDzVC0rUVYrGgHm6b0KDPOULWi8CbLKK4sO2bQ4yU/R77yJcpXNH3RlNMdqm8=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6e02:190b:b0:2ca:3be:2f52 with SMTP id
 w11-20020a056e02190b00b002ca03be2f52mr1730936ilu.8.1648775322203; Thu, 31 Mar
 2022 18:08:42 -0700 (PDT)
Date:   Fri,  1 Apr 2022 01:08:32 +0000
In-Reply-To: <20220401010832.3425787-1-oupton@google.com>
Message-Id: <20220401010832.3425787-4-oupton@google.com>
Mime-Version: 1.0
References: <20220401010832.3425787-1-oupton@google.com>
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
Subject: [PATCH v2 3/3] KVM: arm64: Start trapping ID registers for 32 bit guests
From:   Oliver Upton <oupton@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
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
---
 arch/arm64/include/asm/kvm_arm.h     | 3 ++-
 arch/arm64/include/asm/kvm_emulate.h | 8 --------
 2 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 01d47c5886dc..2fc2d995c10a 100644
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
index d62405ce3e6d..fe32b4c8b35b 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -75,14 +75,6 @@ static inline void vcpu_reset_hcr(struct kvm_vcpu *vcpu)
 	if (test_bit(KVM_ARM_VCPU_EL1_32BIT, vcpu->arch.features))
 		vcpu->arch.hcr_el2 &= ~HCR_RW;
 
-	/*
-	 * TID3: trap feature register accesses that we virtualise.
-	 * For now this is conditional, since no AArch32 feature regs
-	 * are currently virtualised.
-	 */
-	if (!vcpu_el1_is_32bit(vcpu))
-		vcpu->arch.hcr_el2 |= HCR_TID3;
-
 	if (cpus_have_const_cap(ARM64_MISMATCHED_CACHE_TYPE) ||
 	    vcpu_el1_is_32bit(vcpu))
 		vcpu->arch.hcr_el2 |= HCR_TID2;
-- 
2.35.1.1094.g7c7d902a7c-goog

