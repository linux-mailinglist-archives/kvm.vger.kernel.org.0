Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E70C426E3D
	for <lists+kvm@lfdr.de>; Fri,  8 Oct 2021 17:58:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243249AbhJHQAq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Oct 2021 12:00:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243213AbhJHQAo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Oct 2021 12:00:44 -0400
Received: from mail-wr1-x449.google.com (mail-wr1-x449.google.com [IPv6:2a00:1450:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 177ADC061570
        for <kvm@vger.kernel.org>; Fri,  8 Oct 2021 08:58:49 -0700 (PDT)
Received: by mail-wr1-x449.google.com with SMTP id c2-20020adfa302000000b0015e4260febdso7639090wrb.20
        for <kvm@vger.kernel.org>; Fri, 08 Oct 2021 08:58:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=VhuTEAoXz/dF/jFcm1SrjIjX6UWTaTkDztAyYYvfOi8=;
        b=YY62UZxzS49MsZTZDt7m5bixF5e4/e56Js7FNy8P/5WB6wDKNIpJ03vT0NjcVy2pcO
         k4S9nE42zrsnb47cjDZ89XxxQmuF9Jvle7QR4o7Fw1pLDAVywodrNs4jr4QV9K8+j9AV
         p4yqmNUbDQ793eHOGgBcAsgD36WOo27/9FMSYUB1T+YaiiNgPRAG1LvnsZqjShKTx8Ub
         tDDUieO72w0VRTTvEfgOiBi2oeUUntZmEc1dxx6lTnL/NMyUhWin7P26egfGZC9RNTmC
         m1voxEvf4FvgSnSnAYsz4zkuTlUwyn4zcUc5i7dqdZ3/4vOlybThZbC1BHjhYEoMADMs
         J7KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=VhuTEAoXz/dF/jFcm1SrjIjX6UWTaTkDztAyYYvfOi8=;
        b=K4BXVAVy5zMuO8QR2RiS8QFY3TxceFAfI2xsuNfVV9ONQ/xCDqijB6RnatMcVrixdY
         yHy5akRCnVIQB5H0cnrkpsGJhqRIDwzOA83u5iEj7IQYy2YxgRrXiJWAxBV2NygtlAS4
         wt1eywCD2bsgNCPQkB4VNR5t2jFOQ45PUExlwrYpze8jYPakk7coA63RY1yVuvShR389
         s9HO/RfaeFazbUXEICLlTbfzZNzdiPCV4KlJZFr9Fz54gYxJs1AZOEdlPWQEr1JreIPH
         dyTI5AA0U5jstLxh1xSinSEqv8UQ3tGM+t0LjTwzJOkkaSWxpuJTY899ZxrZmMZUERFN
         Fe/A==
X-Gm-Message-State: AOAM53306Zp/49RlFj9ZblehmXHKcL9Tdy3hZ33Jwqqz9xsRLTi1gJMw
        FAuytX2aFW1Y2IOXeUZ4MNPhebFN7g==
X-Google-Smtp-Source: ABdhPJyK9TfYAioqZj/6q2+tGeZz6Ky7JDG6jIcXRQ+nU98pxDyYEfO4P6pHAn09YmYjpoCemTRkwnkldQ==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a7b:c3cc:: with SMTP id t12mr4352516wmj.34.1633708727501;
 Fri, 08 Oct 2021 08:58:47 -0700 (PDT)
Date:   Fri,  8 Oct 2021 16:58:27 +0100
In-Reply-To: <20211008155832.1415010-1-tabba@google.com>
Message-Id: <20211008155832.1415010-7-tabba@google.com>
Mime-Version: 1.0
References: <20211008155832.1415010-1-tabba@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [PATCH v7 06/11] KVM: arm64: Simplify masking out MTE in feature id reg
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

