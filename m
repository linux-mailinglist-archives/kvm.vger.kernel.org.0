Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6156C52025C
	for <lists+kvm@lfdr.de>; Mon,  9 May 2022 18:26:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239055AbiEIQaQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 May 2022 12:30:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239048AbiEIQaM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 May 2022 12:30:12 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CE011FD1FD
        for <kvm@vger.kernel.org>; Mon,  9 May 2022 09:26:17 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id v17-20020a056902029100b006484d85132eso12428378ybh.14
        for <kvm@vger.kernel.org>; Mon, 09 May 2022 09:26:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=xGoqp6X+CPpEHo725m8Wu+g1erF1chW9bMEShQucuQI=;
        b=N0Zb4Gxa4HC1uAASPa5PNvN6IZjx7J7GkqJJxcHMPKOV18yjIl3pcEmceZOJesdcnG
         QyYuP15OLQgQAzxZvOx9T/u4IcSod9jZabxpWQQRxegBDjAddti9A+I5FItlHEwguaJN
         TpTsFWnpbz8e2DrUL88byAshOTHwqCzr3yK86hOE/LVy9b/KYkpySe/p+6GKXer9+ZsT
         AJn8WeUun7zv6Aus63gh3Xr1mdIhrS9YxFDp64pMHUMFpR3ooGR2iVg+ijhT2AzXWlvC
         0smRDvmncy7dBiwIBRAlq8Ds4xGlgiZR/k0QeJkvUFeyICFF+QBvChLD1FP9jVkilG9n
         6zEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=xGoqp6X+CPpEHo725m8Wu+g1erF1chW9bMEShQucuQI=;
        b=AdOQVS9SbxbKrubtvslRxWlDh8vtxBscdlzDg9tzeTSgjB0pZNeExKjcuqRwxpUNV3
         rSUq7Yro5+NRiFtyndA2AN5LhwqBfPGFtbRtTP7Rb4Sk7YaOEhDowBLaWluaC4hrvCL8
         3aCFXPNJGG1lzFhJpE7fKwqN+Lj+lp3bsIkT30DgULikyqAysPOGYNCw8uQQaQpKU5TL
         A0YVrH+7nUzBfoNx1xYE+qSChCubyp675h9i25EJaSroh/ynZZ4gio65dt/vUNpXs/mI
         1O0jCdMnKomVVspAd/cU9+P8tSfvJ+kldg4qwrpUBZcIMK633p8iWUHoqP0TszGgRnbh
         Mjcw==
X-Gm-Message-State: AOAM533CBxhg1KLojT6r201HFUvTaOZ/IcwIa8vryLiZs+aDde4oErsn
        5AsDvCIR1fSlaoxld+PhT/edGd40Ac0=
X-Google-Smtp-Source: ABdhPJwbEmmNk02jHZlxW+mCJH3BMBXB3kvXc9tx+Zc+AF6gVkBuuuHex37mMcuOHpy47pgj2Z6U4qDyQ2M=
X-Received: from oupton3.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:21eb])
 (user=oupton job=sendgmr) by 2002:a25:3157:0:b0:649:b216:bb4e with SMTP id
 x84-20020a253157000000b00649b216bb4emr14278182ybx.387.1652113576747; Mon, 09
 May 2022 09:26:16 -0700 (PDT)
Date:   Mon,  9 May 2022 16:25:59 +0000
In-Reply-To: <20220509162559.2387784-1-oupton@google.com>
Message-Id: <20220509162559.2387784-3-oupton@google.com>
Mime-Version: 1.0
References: <20220509162559.2387784-1-oupton@google.com>
X-Mailer: git-send-email 2.36.0.512.ge40c2bad7a-goog
Subject: [PATCH 2/2] KVM: arm64: pkvm: Don't mask already zeroed FEAT_SVE
From:   Oliver Upton <oupton@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, maz@kernel.org, james.morse@arm.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com, tabba@google.com,
        qperret@google.com, will@kernel.org,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

FEAT_SVE is already masked by the fixed configuration for
ID_AA64PFR0_EL1; don't try and mask it at runtime.

No functional change intended.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/kvm/hyp/nvhe/sys_regs.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
index 33f5181af330..3f5d7bd171c5 100644
--- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
+++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
@@ -90,9 +90,6 @@ static u64 get_pvm_id_aa64pfr0(const struct kvm_vcpu *vcpu)
 	u64 set_mask = 0;
 	u64 allow_mask = PVM_ID_AA64PFR0_ALLOW;
 
-	if (!vcpu_has_sve(vcpu))
-		allow_mask &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_SVE);
-
 	set_mask |= get_restricted_features_unsigned(id_aa64pfr0_el1_sys_val,
 		PVM_ID_AA64PFR0_RESTRICT_UNSIGNED);
 
-- 
2.36.0.512.ge40c2bad7a-goog

