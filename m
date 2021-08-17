Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6CBC3EE820
	for <lists+kvm@lfdr.de>; Tue, 17 Aug 2021 10:12:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239103AbhHQIMi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Aug 2021 04:12:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239088AbhHQIM1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Aug 2021 04:12:27 -0400
Received: from mail-wr1-x44a.google.com (mail-wr1-x44a.google.com [IPv6:2a00:1450:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 915A8C0613C1
        for <kvm@vger.kernel.org>; Tue, 17 Aug 2021 01:11:54 -0700 (PDT)
Received: by mail-wr1-x44a.google.com with SMTP id v18-20020adfe2920000b029013bbfb19640so6271793wri.17
        for <kvm@vger.kernel.org>; Tue, 17 Aug 2021 01:11:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=+LnYz68K0/l+zVlwhzMBHhFllBcdwA8o9zPnuvPdhe0=;
        b=eNCBRoMkjOMI1w4Bde0MwYe/+fVCHL1uO5oA1/7mvgpVquoq/U7usqWzx9nDuVenns
         BQi5B7hZi3es7WYC/W87KlBzYklGyJPgnQV7TfmgIoys5AQ4YA6+IunfsZvAIidGmumc
         XPNo4d52vG8FKOb94+28WQIeUjE2bFAMqVAHwcYCHWKtJC23mfmij3uHJSrBA7NsjnHn
         OydKvJ4RnpdwTpLfFQ+i/NK/GHDCZP3c5L+oe3KhCnYAiU9B9KOjwd0rQDJccClee7/z
         0KtgAGBKfcMOFu2mGsWMrmdAw//fBve6xiM1Yq8lW8dhDvbha/o14XZtd/52XL/ZIk1U
         Okng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=+LnYz68K0/l+zVlwhzMBHhFllBcdwA8o9zPnuvPdhe0=;
        b=HKDMB/t2XwHEhSkGq8YUOUIaSO+SP5xJmAcMypGzrTbOeRX0X/aCNbUMDyxA6G9h2X
         qVJ4z3/wjIZRSU3+CmUh/s64URUE+qqaHGbX2eKSb6DG+DLQA7lmjO7onTVbMwhWufL7
         koP0aoAGTJqsOU4ztHIjzD2EuJ/oeJBeQ0C7CEtEpofgWwz9XO8RB2hIOjrhirK8cRYQ
         S3U//+25naap5prNkxSiiQKA0nGD/Q5S+wa6gYQMH0APFYegD7v1TPZlepMCV9PTPwKg
         TZuiJZPWx2FjeSuGTKqnSHPsx8N3qJBINjVxzS0ReCuudptB5Wjv3qPdrh0vDHHk4HQ3
         YKWQ==
X-Gm-Message-State: AOAM533LLWy1n13MC4MwoqLX0Hsd+X+GYx9GgDPyBGIhLIFkxi3W9VMJ
        JDtdpCWl9m3ItUtFBhr8iit90VqUow==
X-Google-Smtp-Source: ABdhPJyZWFpU/vfGQ67R9j5JsRWqvs8PPjjGpxXblDdr0ny97M2MYAIupQIWIGkVZyPx3cSOzFUeUusJBQ==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a1c:4c:: with SMTP id 73mr2053153wma.139.1629187912994;
 Tue, 17 Aug 2021 01:11:52 -0700 (PDT)
Date:   Tue, 17 Aug 2021 09:11:27 +0100
In-Reply-To: <20210817081134.2918285-1-tabba@google.com>
Message-Id: <20210817081134.2918285-9-tabba@google.com>
Mime-Version: 1.0
References: <20210817081134.2918285-1-tabba@google.com>
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH v4 08/15] KVM: arm64: Track value of cptr_el2 in struct kvm_vcpu_arch
From:   Fuad Tabba <tabba@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     maz@kernel.org, will@kernel.org, james.morse@arm.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        mark.rutland@arm.com, christoffer.dall@arm.com,
        pbonzini@redhat.com, drjones@redhat.com, oupton@google.com,
        qperret@google.com, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
        tabba@google.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Track the baseline guest value for cptr_el2 in struct
kvm_vcpu_arch, similar to the other registers that control traps.
Use this value when setting cptr_el2 for the guest.

Currently this value is unchanged (CPTR_EL2_DEFAULT), but future
patches will set trapping bits based on features supported for
the guest.

No functional change intended.

Acked-by: Will Deacon <will@kernel.org>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_host.h | 1 +
 arch/arm64/kvm/arm.c              | 1 +
 arch/arm64/kvm/hyp/nvhe/switch.c  | 2 +-
 3 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 76462c6a91ee..ac67d5699c68 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -290,6 +290,7 @@ struct kvm_vcpu_arch {
 	/* Values of trap registers for the guest. */
 	u64 hcr_el2;
 	u64 mdcr_el2;
+	u64 cptr_el2;
 
 	/* Values of trap registers for the host before guest entry. */
 	u64 mdcr_el2_host;
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index e9a2b8f27792..14b12f2c08c0 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1104,6 +1104,7 @@ static int kvm_arch_vcpu_ioctl_vcpu_init(struct kvm_vcpu *vcpu,
 	}
 
 	vcpu_reset_hcr(vcpu);
+	vcpu->arch.cptr_el2 = CPTR_EL2_DEFAULT;
 
 	/*
 	 * Handle the "start in power-off" case.
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 1778593a08a9..86f3d6482935 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -41,7 +41,7 @@ static void __activate_traps(struct kvm_vcpu *vcpu)
 	___activate_traps(vcpu);
 	__activate_traps_common(vcpu);
 
-	val = CPTR_EL2_DEFAULT;
+	val = vcpu->arch.cptr_el2;
 	val |= CPTR_EL2_TTA | CPTR_EL2_TAM;
 	if (!update_fp_enabled(vcpu)) {
 		val |= CPTR_EL2_TFP | CPTR_EL2_TZ;
-- 
2.33.0.rc1.237.g0d66db33f3-goog

