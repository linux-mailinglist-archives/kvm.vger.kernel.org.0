Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 146BC42820F
	for <lists+kvm@lfdr.de>; Sun, 10 Oct 2021 16:56:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232788AbhJJO6w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 10 Oct 2021 10:58:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232773AbhJJO6v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 10 Oct 2021 10:58:51 -0400
Received: from mail-wr1-x449.google.com (mail-wr1-x449.google.com [IPv6:2a00:1450:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0A95C061570
        for <kvm@vger.kernel.org>; Sun, 10 Oct 2021 07:56:52 -0700 (PDT)
Received: by mail-wr1-x449.google.com with SMTP id p12-20020adfc38c000000b00160d6a7e293so8687605wrf.18
        for <kvm@vger.kernel.org>; Sun, 10 Oct 2021 07:56:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=VhuTEAoXz/dF/jFcm1SrjIjX6UWTaTkDztAyYYvfOi8=;
        b=qWI4G5g36XxXyEsgPjeNAI4W97txYnCt+D1vMKXxad2mu+zc9lDk69KVLbgb7MoKDY
         x4b65PqwGCwM5iC6D0Z8c+mqJ60ImWNqWz8ID4P27GoBikiJflNd6oskhEdJ7dCX/hjI
         r+eIfx4aFm0iit0UHZ1DV0uMo5OrQJNk2zDrucrBYWGDZ6RYQmXK5Z40NpPTgxZskO6K
         pI6ppf5RTnHu6yfBd0HWnDKOgxR11KaPNl6p+wLJeOCUcCJNU+sLsfxkKgnH/Tpedtd+
         GWyavAG0HDOHpRkTCDF0//3M/NyzLOZjlUL7XEyP9lxtvKi0dz+HLHueq6d9gvPdHdNS
         jLAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=VhuTEAoXz/dF/jFcm1SrjIjX6UWTaTkDztAyYYvfOi8=;
        b=La33nDGChCkPoDE5NcfRZFXOOXzmY74IEjPdc8ZVty9K8B3jvXSix6NRIb1fAZbx5+
         rBz204KKsDDF+RomqaooyljjIhWGbvj/LefQgQ4WVPZvgQzvxKiBoIooo7HUR8+4dcS2
         BXpCjvu8xNaHtVmnGaTxYZlPYl2JLvNNRS5MFsSUuc03G8bNuDvpnLRB3jHgCNQPlqe5
         fr9uMIEH0x+KygBNws5Rh4cqcsTATjxN5qzIt3QYhlLBjO2a91wMz6MlbAd6oENBqVrb
         J1s8p4llSZ09VD8P6xY0YjBCwLEDQz7QWVMePsrQ10cwvDi4ZwRwXu6BNNWOjleqjrG/
         zSiQ==
X-Gm-Message-State: AOAM5313PkJd10Rfgmp44cyw20II7h8THKFawceg3WaRBBb1gn90rTRG
        xpZ76kzBAUTD6HJW0wQOoRkTHavbkw==
X-Google-Smtp-Source: ABdhPJz9fEWzeoXAkJy2EB0zc/fuvxlPm1VqHcpI+f8um4/Z2ygNhevMtDfldGJvxH5VKZYVvAdv4s5YJw==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a05:600c:4e88:: with SMTP id
 f8mr4351133wmq.185.1633877811342; Sun, 10 Oct 2021 07:56:51 -0700 (PDT)
Date:   Sun, 10 Oct 2021 15:56:31 +0100
In-Reply-To: <20211010145636.1950948-1-tabba@google.com>
Message-Id: <20211010145636.1950948-7-tabba@google.com>
Mime-Version: 1.0
References: <20211010145636.1950948-1-tabba@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [PATCH v8 06/11] KVM: arm64: Simplify masking out MTE in feature id reg
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
Reviewed-by: Andrew Jones <drjones@redhat.com>
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
2.33.0.882.g93a45727a2-goog

