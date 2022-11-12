Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3E14626803
	for <lists+kvm@lfdr.de>; Sat, 12 Nov 2022 09:17:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234774AbiKLIRX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 12 Nov 2022 03:17:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234629AbiKLIRU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 12 Nov 2022 03:17:20 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18A3213EAE
        for <kvm@vger.kernel.org>; Sat, 12 Nov 2022 00:17:20 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id y6-20020a25b9c6000000b006c1c6161716so6316089ybj.8
        for <kvm@vger.kernel.org>; Sat, 12 Nov 2022 00:17:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=bR8iaUgvP1KhoHZDz60Ag9zfSgL9+5xkoUuLuzW9M/E=;
        b=pIfn545Xg4RILlmoV71GI5wUoqZTMmdLuKi3J1MKvNujIUDEvJocA2w/+4VdHLrydh
         sK0Kz45DrHxyinoIeLQ4cXcCDHNvB/fiegMkUkCZ/jootdi1olpyg74PID7iMbDKYQR3
         oTZOhZlJUcV6lDPT4LQuQKTAkUOdnm8NMJhFxby6atuXio/kFt9Ro18NJkwc66I1I2gD
         WtsbfVbkSfXyC7tjTyG3DVsO9TzFV+X60s4LMAxkSYCQPawuBtmOiZYDkpv12smEP4OZ
         34OKYJg7ZObKGYB0um41oXBgQvIAn4s1YHbR2atKJANaTgagyZ5lL6q2a92cdPP49H8g
         pC2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bR8iaUgvP1KhoHZDz60Ag9zfSgL9+5xkoUuLuzW9M/E=;
        b=HuV1iQdHK91ujH0tA4Tf1fLcavyxgY45GRL4aA0/q3RamLsab6/C/hDxoQZ5sOHPbp
         MPNqNFKskrUyE2Bw7guDsGZzm7/wecnTDrnQ8gIjQipNV8uXO5+z0HKmXwaV923Qyleg
         HSn7nkpuhJVQK72tUO6iZlmDlFthsBBoNEDVGXchLiH1o0+7GebQRsma5vvIIKoZE+Lm
         Z4NCYi244FSX6RdOVWs4uNRedVBIuUTVtI6zcDWo3Va45ez7LsMsIAMmV4Uu1LASCstn
         eUwlth9SqD9zz2/DbliyjFJI0X8vPH4gjeuwXMatLoZrXhhK3vNU2lc31V9WUpgsDko8
         M6Nw==
X-Gm-Message-State: ACrzQf0pYVbLWpH6lmeixEz56rwmVoU/D2lqel9uAVIdqUzzN7+5+iP3
        AINqSDyAwQK5nWUbw6+OlvpEePs1QzuDJA==
X-Google-Smtp-Source: AMsMyM4ah6NGC8kmhMxLtTth8Jo+WhdvvMmY7TiDG/C+ZbL8Crz+PCFuUZuBbeleghI7+CU1WJykCKDc7+AiiA==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a81:6554:0:b0:349:8e3:a882 with SMTP id
 z81-20020a816554000000b0034908e3a882mr65030760ywb.388.1668241038874; Sat, 12
 Nov 2022 00:17:18 -0800 (PST)
Date:   Sat, 12 Nov 2022 08:17:03 +0000
In-Reply-To: <20221112081714.2169495-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20221112081714.2169495-1-ricarkol@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221112081714.2169495-2-ricarkol@google.com>
Subject: [RFC PATCH 01/12] KVM: arm64: Relax WARN check in stage2_make_pte()
From:   Ricardo Koller <ricarkol@google.com>
To:     pbonzini@redhat.com, maz@kernel.org, oupton@google.com,
        dmatlack@google.com, qperret@google.com, catalin.marinas@arm.com,
        andrew.jones@linux.dev, seanjc@google.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        eric.auger@redhat.com, gshan@redhat.com, reijiw@google.com,
        rananta@google.com, bgardon@google.com
Cc:     kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, ricarkol@gmail.com,
        Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

stage2_make_pte() throws a warning when used in a non-shared walk, as PTEs
are not "locked" when walking non-shared. Add a check so it can be used
non-shared.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 arch/arm64/kvm/hyp/pgtable.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index c12462439e70..b16107bf917c 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -733,7 +733,8 @@ static void stage2_make_pte(const struct kvm_pgtable_visit_ctx *ctx, kvm_pte_t n
 {
 	struct kvm_pgtable_mm_ops *mm_ops = ctx->mm_ops;
 
-	WARN_ON(!stage2_pte_is_locked(*ctx->ptep));
+	if (kvm_pgtable_walk_shared(ctx))
+		WARN_ON(!stage2_pte_is_locked(*ctx->ptep));
 
 	if (stage2_pte_is_counted(new))
 		mm_ops->get_page(ctx->ptep);
-- 
2.38.1.431.g37b22c650d-goog

