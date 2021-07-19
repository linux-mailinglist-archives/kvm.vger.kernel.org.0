Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E0013CE506
	for <lists+kvm@lfdr.de>; Mon, 19 Jul 2021 18:37:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236886AbhGSPrc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Jul 2021 11:47:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350262AbhGSPpq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Jul 2021 11:45:46 -0400
Received: from mail-wm1-x349.google.com (mail-wm1-x349.google.com [IPv6:2a00:1450:4864:20::349])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFBCBC0ABCA5
        for <kvm@vger.kernel.org>; Mon, 19 Jul 2021 08:38:19 -0700 (PDT)
Received: by mail-wm1-x349.google.com with SMTP id h22-20020a7bc9360000b0290215b0f3da63so2005704wml.3
        for <kvm@vger.kernel.org>; Mon, 19 Jul 2021 09:04:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=U8tD0ZWRxueOiZnXn8UX8nsv6z5g8QfT23T+iieg6fI=;
        b=ea29I0iVbjUEGeftel12Gbq366g83QtA8E8r2Uz+6IHkJ5UWd79gUIX3JA3bLyJe2D
         QopBkuDzcKVtOEKFgcYrOrqaG1U79giGVajM4WVon/jAnyPxWl7lSRLHkf5bUKq7hgqI
         qYrGlejOsSSAggxfvj3GQmg9m+MadgXLM2jZmKxePlf5wMrQg7oXbwV1tsjyrjq2MRA6
         FvMoXKvos5kv9fcrVWa87rlDj4y5EvS+eYCN+qe3HXSpqhRo9Kq1RukOmpGNRgkw1sAf
         vmRE9+AgJ5UoMmzOf5n3YI7T6NGPJw9OgUFVbWdHiFjEvWuFY/8WIPBGjuVN8OxaTsLr
         z+AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=U8tD0ZWRxueOiZnXn8UX8nsv6z5g8QfT23T+iieg6fI=;
        b=BJ+SQtNEN5UjIc9rgb244s3oe0onVS8z6Xtl5hSDR+kOp3zlcBYp3PyiL3vBbnUlyT
         x2fKQ5oa40YDyDabt7DblSyQ3ZZV7mr4wNpLmgQ37u22BtSeLZf91NdXGGFBaC3mbysu
         GcR5WN83cx4oM+DoB5fC6z8D7ereq6rT8CaUIf6dmjTho0r8ctJalDOgwB/7KgyjCjhP
         /0CvH/7XteAa5Kybix8QNio49XTCLuEYi6rS0p9rShI+NE4fMjmfCYIMtvsKrV/YZtOL
         6ZQNd6XTn25jHWzZsC5Etv8c2fLVxlcWB61SxNhqj4FedbslM7NHZDGNpH5d1YTq5XDW
         V71w==
X-Gm-Message-State: AOAM533r3W17IPfbFga3suGzlL/p1EDzzi7R+qyt9MoMYqwXsf1DTO2Z
        Hc30O02NJCeUFed/SDoGxPVEgc9+Gw==
X-Google-Smtp-Source: ABdhPJyZIExAAOBCez1kX40oKv+JGxZhb6d/02I7dL1PYFLCOK6saRJUulsso2zHWmJh0mrJepqqSzq7lA==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a5d:4ccb:: with SMTP id c11mr30162930wrt.331.1626710642525;
 Mon, 19 Jul 2021 09:04:02 -0700 (PDT)
Date:   Mon, 19 Jul 2021 17:03:38 +0100
In-Reply-To: <20210719160346.609914-1-tabba@google.com>
Message-Id: <20210719160346.609914-8-tabba@google.com>
Mime-Version: 1.0
References: <20210719160346.609914-1-tabba@google.com>
X-Mailer: git-send-email 2.32.0.402.g57bb445576-goog
Subject: [PATCH v3 07/15] KVM: arm64: Track value of cptr_el2 in struct kvm_vcpu_arch
From:   Fuad Tabba <tabba@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     maz@kernel.org, will@kernel.org, james.morse@arm.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        mark.rutland@arm.com, christoffer.dall@arm.com,
        pbonzini@redhat.com, drjones@redhat.com, qperret@google.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kernel-team@android.com, tabba@google.com
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
2.32.0.402.g57bb445576-goog

