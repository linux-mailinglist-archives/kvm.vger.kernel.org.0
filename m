Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 111113F97F8
	for <lists+kvm@lfdr.de>; Fri, 27 Aug 2021 12:18:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244839AbhH0KRI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Aug 2021 06:17:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244492AbhH0KRI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Aug 2021 06:17:08 -0400
Received: from mail-wm1-x349.google.com (mail-wm1-x349.google.com [IPv6:2a00:1450:4864:20::349])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B6E2C061757
        for <kvm@vger.kernel.org>; Fri, 27 Aug 2021 03:16:19 -0700 (PDT)
Received: by mail-wm1-x349.google.com with SMTP id o20-20020a05600c379400b002e755735eedso1606388wmr.0
        for <kvm@vger.kernel.org>; Fri, 27 Aug 2021 03:16:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Ndy6VNY2Oh4Ysf845vj9tsZMixjR9xf1QOuntbi4ZaI=;
        b=WcIs2d0aQaKoHbdUo0nizodc0raiIVSlXaKetGAFfV+XmVSaJE+nHQ2SfGN4k2/W2k
         VsbJM8mRc5oD6ZxO/nC521ZYvX2bHcKDdzW8LESNXxmwNb2SGKpFegBdw3Iu9sR+xAY6
         N0R44zAnaiz3IdkiRCbmxX7S60aAlB8Q6ONoHSbxAs+WqDFkurR+Yy7aPUxD6xcbm+90
         hNcz5tI90qZpMmPHddT7TemzywJ4IeQQ4At+YUVDdRPMB4/lpZorFQsC/2g6Km9boLx1
         skWXlfxvpM9vI5p8belx+BHqXvqL+YXgihEUCJcu1ZpqzPQCgS+8lH5fOL2KGw2YkjJC
         ivYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Ndy6VNY2Oh4Ysf845vj9tsZMixjR9xf1QOuntbi4ZaI=;
        b=FZTYMKp/MmhHPgP/Q46L0ET+l5Z6yF5So7b03nPJ1FDMXtZFXAmueV7z7Qxf50Uros
         p/Nh5hSgKFqhb4CEkfp2hJm4AUpQXaIsrsexDyvOBKQFDcJBrgmFAPYlNbYTLXN+67SO
         k0+D9LHUJli9bmkbztHWu36bwuvRoUFlV10Wk2mk/DEjCrtDAhYZmvsU0xP4L1vqtLcp
         OBBAWxnxFTLwumeTEFwh/zQjgvwqbTFZ/4QLtejCQV6ifP7yw3aqVC7tf45qYjJBo6mF
         HwUlb89nf1ooSsQT7p2lCd3ulmheQEwdLQb+CXljFpyb70NZcmwP0KDRPUjn/RsMepAO
         etmA==
X-Gm-Message-State: AOAM530fSNDd1l2qbYsSAWKSa+XAWoz9ONP8mWQRj1/JzsyHMSY3Jacy
        iCswR7BZiw7ll8X8DpOGFmTB/Tn1Iw==
X-Google-Smtp-Source: ABdhPJyKPDcykD+jZqtrY7F6z2+IYUsvk6Ld/uleTUzz1jiOs7fYD1kJ+7VGHzCekPCIlgM/IBedXZxLDA==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:adf:e788:: with SMTP id n8mr9277808wrm.214.1630059377746;
 Fri, 27 Aug 2021 03:16:17 -0700 (PDT)
Date:   Fri, 27 Aug 2021 11:16:04 +0100
In-Reply-To: <20210827101609.2808181-1-tabba@google.com>
Message-Id: <20210827101609.2808181-4-tabba@google.com>
Mime-Version: 1.0
References: <20210827101609.2808181-1-tabba@google.com>
X-Mailer: git-send-email 2.33.0.259.gc128427fd7-goog
Subject: [PATCH v5 3/8] KVM: arm64: Simplify masking out MTE in feature id reg
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

Simplify code for hiding MTE support in feature id register when
MTE is not enabled/supported by KVM.

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/sys_regs.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 1d46e185f31e..447acce9ca84 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1077,14 +1077,8 @@ static u64 read_id_reg(const struct kvm_vcpu *vcpu,
 		val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_CSV3), (u64)vcpu->kvm->arch.pfr0_csv3);
 		break;
 	case SYS_ID_AA64PFR1_EL1:
-		val &= ~ARM64_FEATURE_MASK(ID_AA64PFR1_MTE);
-		if (kvm_has_mte(vcpu->kvm)) {
-			u64 pfr, mte;
-
-			pfr = read_sanitised_ftr_reg(SYS_ID_AA64PFR1_EL1);
-			mte = cpuid_feature_extract_unsigned_field(pfr, ID_AA64PFR1_MTE_SHIFT);
-			val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR1_MTE), mte);
-		}
+		if (!kvm_has_mte(vcpu->kvm))
+			val &= ~ARM64_FEATURE_MASK(ID_AA64PFR1_MTE);
 		break;
 	case SYS_ID_AA64ISAR1_EL1:
 		if (!vcpu_has_ptrauth(vcpu))
-- 
2.33.0.259.gc128427fd7-goog

