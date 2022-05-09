Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB622520258
	for <lists+kvm@lfdr.de>; Mon,  9 May 2022 18:26:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239054AbiEIQaN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 May 2022 12:30:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239030AbiEIQaJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 May 2022 12:30:09 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B9D01FD1FD
        for <kvm@vger.kernel.org>; Mon,  9 May 2022 09:26:15 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id s18-20020a17090aa11200b001d92f7609e8so6586771pjp.3
        for <kvm@vger.kernel.org>; Mon, 09 May 2022 09:26:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=ramO0+cEkxqJX3F8coHgv6jkuFbFeK102oolsavMu20=;
        b=dzr2hls94IW3ClUuA2BSr4qrrnhWvuyEZI8nmXUIdiJHGzCNV42d2pewDNyyq80z8v
         bWsUx/m5Ue/BW1YKhvz5ey2N7GtbjeXfSalL431rTrIhm9CbPH2N7m/FTSxFsyeD3qUp
         vXJqArAH9zH6NJ6jgi3AYOdxSAZQ/zZ5hPibtfe7o8lwCwTgu6Cz50/+wdJ7XGjzpShB
         ARsg0FK+LbtIxB0pYfEVUWq8IWxV5K/BYzouxazPSfK7emCZnaAacA2ohaNp1x+3aIGa
         jyR/0vEsVlbDWN+XzL8wXDCFCcrU9hSGVTMq87y7rn8FTavQQDuIBOI5u0j2wnP/e64n
         LqNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=ramO0+cEkxqJX3F8coHgv6jkuFbFeK102oolsavMu20=;
        b=uV0ETGBnv4J2pifwBzYM4BK/W4NNpXg22+/AbLX077J/QrHTGLCyM1Bcq2bJzhxrnH
         g3/oICUZF4EDy7SYOer77RH56hGPjqnsdc5nXs9DmjjnleJ+Q9B7GOJEhczrXbAv5u2x
         uUQ7M3DnZ50KNUKiPuIYn998s6rwtPKTy3JKio3V59mM4m3he/dMdSn1rqfNxVOtBG8g
         1j3vSeSP26AQgkZ11ILdUPLmJH9BDKz6mkwgPCmdC92oeFpIek7U8KGOdxoYaVTJe8Y2
         +vGcgXYvLJy9AgjqR9YE6oiYJ6J4R04aqGWWIVAgNCXhEGS4ib6syMCT2vl9rLBjrJpC
         41MA==
X-Gm-Message-State: AOAM531DoXuKV7CqjW6aihvUuH5PTd5iyHVWRsqLbvTqolOiwDqEojWb
        KzxZkfjJhaVOAq5idilGnG6BeIFEXqQ=
X-Google-Smtp-Source: ABdhPJzdjvmm33Xww7qbolbHONdNzfLPiXVqOOHjncbxPv2g5srfZyPR6YVyWtFPJJJKmTvTXT956abVHGQ=
X-Received: from oupton3.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:21eb])
 (user=oupton job=sendgmr) by 2002:a17:902:e74d:b0:15e:94f7:611e with SMTP id
 p13-20020a170902e74d00b0015e94f7611emr17008035plf.37.1652113574927; Mon, 09
 May 2022 09:26:14 -0700 (PDT)
Date:   Mon,  9 May 2022 16:25:58 +0000
In-Reply-To: <20220509162559.2387784-1-oupton@google.com>
Message-Id: <20220509162559.2387784-2-oupton@google.com>
Mime-Version: 1.0
References: <20220509162559.2387784-1-oupton@google.com>
X-Mailer: git-send-email 2.36.0.512.ge40c2bad7a-goog
Subject: [PATCH 1/2] KVM: arm64: pkvm: Drop unnecessary FP/SIMD trap handler
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
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pVM-specific FP/SIMD trap handler just calls straight into the
generic trap handler. Avoid the indirection and just call the hyp
handler directly.

Note that the BUILD_BUG_ON() pattern is repeated in
pvm_init_traps_aa64pfr0(), which is likely a better home for it.

No functional change intended.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/kvm/hyp/nvhe/switch.c | 19 +------------------
 1 file changed, 1 insertion(+), 18 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 6410d21d8695..3dee2ad96e10 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -175,23 +175,6 @@ static bool kvm_handle_pvm_sys64(struct kvm_vcpu *vcpu, u64 *exit_code)
 		kvm_handle_pvm_sysreg(vcpu, exit_code));
 }
 
-/**
- * Handler for protected floating-point and Advanced SIMD accesses.
- *
- * Returns true if the hypervisor has handled the exit, and control should go
- * back to the guest, or false if it hasn't.
- */
-static bool kvm_handle_pvm_fpsimd(struct kvm_vcpu *vcpu, u64 *exit_code)
-{
-	/* Linux guests assume support for floating-point and Advanced SIMD. */
-	BUILD_BUG_ON(!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR0_FP),
-				PVM_ID_AA64PFR0_ALLOW));
-	BUILD_BUG_ON(!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR0_ASIMD),
-				PVM_ID_AA64PFR0_ALLOW));
-
-	return kvm_hyp_handle_fpsimd(vcpu, exit_code);
-}
-
 static const exit_handler_fn hyp_exit_handlers[] = {
 	[0 ... ESR_ELx_EC_MAX]		= NULL,
 	[ESR_ELx_EC_CP15_32]		= kvm_hyp_handle_cp15_32,
@@ -207,7 +190,7 @@ static const exit_handler_fn pvm_exit_handlers[] = {
 	[0 ... ESR_ELx_EC_MAX]		= NULL,
 	[ESR_ELx_EC_SYS64]		= kvm_handle_pvm_sys64,
 	[ESR_ELx_EC_SVE]		= kvm_handle_pvm_restricted,
-	[ESR_ELx_EC_FP_ASIMD]		= kvm_handle_pvm_fpsimd,
+	[ESR_ELx_EC_FP_ASIMD]		= kvm_hyp_handle_fpsimd,
 	[ESR_ELx_EC_IABT_LOW]		= kvm_hyp_handle_iabt_low,
 	[ESR_ELx_EC_DABT_LOW]		= kvm_hyp_handle_dabt_low,
 	[ESR_ELx_EC_PAC]		= kvm_hyp_handle_ptrauth,
-- 
2.36.0.512.ge40c2bad7a-goog

