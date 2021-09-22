Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EFD8414984
	for <lists+kvm@lfdr.de>; Wed, 22 Sep 2021 14:47:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236113AbhIVMs7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Sep 2021 08:48:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236091AbhIVMsw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Sep 2021 08:48:52 -0400
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F5A5C061574
        for <kvm@vger.kernel.org>; Wed, 22 Sep 2021 05:47:22 -0700 (PDT)
Received: by mail-qv1-xf49.google.com with SMTP id w10-20020a0cb54a000000b0037a9848b92fso13148349qvd.0
        for <kvm@vger.kernel.org>; Wed, 22 Sep 2021 05:47:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=+XjKwBEU8XHurAeXBX8jHTz51rXfXyCyxwuOVOoJtgE=;
        b=SQICd5Wi/tLS6YqYvGCfeYH/8a8o9qHXUQfDX5jpZ6xU3Ui3cJZI06CCo3qkYEc570
         ezYzwjPC1hKUa+yCn/ZSvCVtDqXm/CqhhcXfUBUHW2eJL6tL+UHdAoC5GuSpzRCljUbQ
         3/Panm01VDkkZHLP+KnFqGrfwdNVErXheqH4d+7Be4IoQ8Qg0f/vdKT4ZkHt4jyy1cSD
         RYkW1dQRn4Rzex3jGkjc3Wf6CTuagfM/l71/QQ2flL2/ZKCLJTRApg8/iE05YQv6X0LE
         eyUOqv9lBoQPUCovDo7CRclsfjB69SfaQXT22JzhQUEI0wiX0mWhnzEcfL2FVgG9fPUj
         SRxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=+XjKwBEU8XHurAeXBX8jHTz51rXfXyCyxwuOVOoJtgE=;
        b=Ab8OdF2ZGAEm0LESoztHWRsp5pTuLdAG+r+TzdfygwqcVwQKWb9/BWBrOZmySlSZ42
         6TYnShhrYSFpZB7TrJ4dCRN9QT9Lgzf0AXMnljn6HcB/s4GvfSK9lKhF7hrkYQuJKfPo
         5Gq+6kJ918wp8gXncgjb0duGKKmKSkfETiZEQWK5umRonUt0kBjcyW1HEVjL8OBTmzEl
         vJ8J/4/eZMe8TEPLGL9XkCWv/b5f681fklmDF8VqKvX1OkDPo7QiG4+Wl35HD/DUSbRu
         lZdDhIlDicCejGnSpw5LO3pIqYIvoDn5DbQeCw3nk54V2N+kAuyH2jxR5STFtMwnraGP
         8h4A==
X-Gm-Message-State: AOAM533FdBKSrazu3MvEW0T/mLbVveA0Q8s7+WbHdlhnAlcblGsXhNk8
        TfXqr6c6dwd8Df9c+nL0xlwjhE+gTg==
X-Google-Smtp-Source: ABdhPJy8aSobofh0Qai9hz2nCfb+UCZ9fXyZoPgAPtLb/DlaFbORkM5gtPL+Ayu+m1LXY6nESzHqO+khOw==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a0c:f10b:: with SMTP id i11mr36186303qvl.67.1632314841458;
 Wed, 22 Sep 2021 05:47:21 -0700 (PDT)
Date:   Wed, 22 Sep 2021 13:46:59 +0100
In-Reply-To: <20210922124704.600087-1-tabba@google.com>
Message-Id: <20210922124704.600087-8-tabba@google.com>
Mime-Version: 1.0
References: <20210922124704.600087-1-tabba@google.com>
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
Subject: [PATCH v6 07/12] KVM: arm64: Simplify masking out MTE in feature id reg
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
2.33.0.464.g1972c5931b-goog

