Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F9A958B07E
	for <lists+kvm@lfdr.de>; Fri,  5 Aug 2022 21:42:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241541AbiHETmD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Aug 2022 15:42:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241357AbiHETlq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Aug 2022 15:41:46 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A475613D18
        for <kvm@vger.kernel.org>; Fri,  5 Aug 2022 12:41:38 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-324989683fdso28862297b3.12
        for <kvm@vger.kernel.org>; Fri, 05 Aug 2022 12:41:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:mime-version:message-id:date:reply-to:from:to:cc;
        bh=AqDbpS3tKOnMAygn4Y+bPVaibFr+A3nAwDRXJDQenbU=;
        b=T36RbBJqSwXAI7p0EtgwJkmUwLqP2o9NToASYr6lEWGg0+KY1uumxgBYLpDFQ4jWZn
         2hgtMsUfvLUpHhOZwh9Pr91C0RoEUhoG0s/lytEOwmi3m15f/AI3/lpR85IXw0e8+i/u
         3gHizKELR2f4XpOQicoG5SD3a1RynwBxhlj/4xS00pRVpM7RXVP0pU6iGKQH1VGPFg0y
         JlYHsn7TqATM+o+G/mdP0plGiIcnP/zqVCCOo5o+PV+ry4st445f+S7cUh/nu0t+78Kp
         4JWDArH9HWYK4KId8JvI0n3sOl3ddRco6S6YwR8GaJb8OjUk02cSKnKTwpPxLw9nmr86
         AyPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:mime-version:message-id:date:reply-to
         :x-gm-message-state:from:to:cc;
        bh=AqDbpS3tKOnMAygn4Y+bPVaibFr+A3nAwDRXJDQenbU=;
        b=ebyX/Zqi0fhkUz3AZ0B9V9DTc+am6HT01oJXRLmw9Fl/gvWSRpxTXTFqXOfbkt2PO3
         N0kspDU5g5qJmjmK3/vLd14mCiMCnLypOeg04BcfGwk+2kkoVFu+NHAjGIkyIW0xR52d
         fRURXkH2ncTO6Q2PpY11RwY/55SLFhoFUb1QM9PyXeaO9zthtN76YIxtTysLdAxSQsqW
         FB4XbHvKrzOBuOCdI00/wu91GR2YerDu9iwCL61U2wzoSM9n1qcSAAMpEMj+8Fgetb18
         BhYwjVrwOEtWq0TnsAZul+GjBmHk9L6DyKTxUtS5VJl17pb7B1rHoLvTc+ByROX5brqi
         J4Ww==
X-Gm-Message-State: ACgBeo3p8l1MqTW69iAClXtyZP1SBlDqdqW7ZbnAZzndugu+TwzY/J37
        64ekGVUjNQPbkE3/piO5A+azXP2O1kw=
X-Google-Smtp-Source: AA6agR5ZdS7BvImoBdsApE9Xgt4ptDDxg5olo2D88FCk+SUYh8qkzoYzD2w/C84DnsPoxOI7xrsvHeaLiJE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:ae55:0:b0:31f:6630:9736 with SMTP id
 g21-20020a81ae55000000b0031f66309736mr7614405ywk.346.1659728497753; Fri, 05
 Aug 2022 12:41:37 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  5 Aug 2022 19:41:33 +0000
Message-Id: <20220805194133.86299-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.1.559.g78731f0fdb-goog
Subject: [PATCH v2] KVM: x86/mmu: Add sanity check that MMIO SPTE mask doesn't
 overlap gen
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kai Huang <kai.huang@intel.com>
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

Add compile-time and init-time sanity checks to ensure that the MMIO SPTE
mask doesn't overlap the MMIO SPTE generation or the MMU-present bit.
The generation currently avoids using bit 63, but that's as much
coincidence as it is strictly necessarly.  That will change in the future,
as TDX support will require setting bit 63 (SUPPRESS_VE) in the mask.

Explicitly carve out the bits that are allowed in the mask so that any
future shuffling of SPTE bits doesn't silently break MMIO caching (KVM
has broken MMIO caching more than once due to overlapping the generation
with other things).

Suggested-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---

Kai, I didn't included your review since I pretty much rewrote the entire
comment.

v2: Prevent overlap with SPTE_MMU_PRESENT_MASK
v1: https://lore.kernel.org/all/20220803213354.951376-1-seanjc@google.com

 arch/x86/kvm/mmu/spte.c |  8 ++++++++
 arch/x86/kvm/mmu/spte.h | 14 ++++++++++++++
 2 files changed, 22 insertions(+)

diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index 7314d27d57a4..08e8c46f3037 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -343,6 +343,14 @@ void kvm_mmu_set_mmio_spte_mask(u64 mmio_value, u64 mmio_mask, u64 access_mask)
 	if (!enable_mmio_caching)
 		mmio_value = 0;
 
+	/*
+	 * The mask must contain only bits that are carved out specifically for
+	 * the MMIO SPTE mask, e.g. to ensure there's no overlap with the MMIO
+	 * generation.
+	 */
+	if (WARN_ON(mmio_mask & ~SPTE_MMIO_ALLOWED_MASK))
+		mmio_value = 0;
+
 	/*
 	 * Disable MMIO caching if the MMIO value collides with the bits that
 	 * are used to hold the relocated GFN when the L1TF mitigation is
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index cabe3fbb4f39..10f16421e876 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -125,6 +125,20 @@ static_assert(!(EPT_SPTE_MMU_WRITABLE & SHADOW_ACC_TRACK_SAVED_MASK));
 static_assert(!(SPTE_MMU_PRESENT_MASK &
 		(MMIO_SPTE_GEN_LOW_MASK | MMIO_SPTE_GEN_HIGH_MASK)));
 
+/*
+ * The SPTE MMIO mask must NOT overlap the MMIO generation bits or the
+ * MMU-present bit.  The generation obviously co-exists with the magic MMIO
+ * mask/value, and MMIO SPTEs are considered !MMU-present.
+ *
+ * The SPTE MMIO mask is allowed to use hardware "present" bits (i.e. all EPT
+ * RWX bits), all physical address bits (legal PA bits are used for "fast" MMIO
+ * and so they're off-limits for generation; additional checks ensure the mask
+ * doesn't overlap legal PA bits), and bit 63 (carved out for future usage).
+ */
+#define SPTE_MMIO_ALLOWED_MASK (BIT_ULL(63) | GENMASK_ULL(51, 12) | GENMASK_ULL(2, 0))
+static_assert(!(SPTE_MMIO_ALLOWED_MASK &
+		(SPTE_MMU_PRESENT_MASK | MMIO_SPTE_GEN_LOW_MASK | MMIO_SPTE_GEN_HIGH_MASK)));
+
 #define MMIO_SPTE_GEN_LOW_BITS		(MMIO_SPTE_GEN_LOW_END - MMIO_SPTE_GEN_LOW_START + 1)
 #define MMIO_SPTE_GEN_HIGH_BITS		(MMIO_SPTE_GEN_HIGH_END - MMIO_SPTE_GEN_HIGH_START + 1)
 

base-commit: 93472b79715378a2386598d6632c654a2223267b
-- 
2.37.1.559.g78731f0fdb-goog

