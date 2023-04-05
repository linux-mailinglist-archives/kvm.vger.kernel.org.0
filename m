Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 984016D71A3
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 02:45:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236717AbjDEApf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 20:45:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236698AbjDEApa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 20:45:30 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0C6D4C13
        for <kvm@vger.kernel.org>; Tue,  4 Apr 2023 17:45:28 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id s4-20020a170902ea0400b001a1f4137086so20156193plg.14
        for <kvm@vger.kernel.org>; Tue, 04 Apr 2023 17:45:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680655528;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=tf25xAl4fSdxFBAk8i0l5aGjOrxXQadDD1CZezPxob4=;
        b=k3vSRE8uQSYLQ5FHcz/pee6bDiPafNfanLHpLWinnqWSebl9zem+gxu9QQCpk/1Brr
         55gJmi5Wx+I48U9ScE+y+g8gHjPKFwfcATMGdcaqLioTN3kx0U6W9NqCr3xKtOt3dqAL
         41/V11LD7CC3rDGsHXBIiRdUOer0/+Nyl1JEuiv0BHHyHp2Td/Ok924VfjEFsKwwEojB
         ywDI8B4uzpOSjrB94WT9uSVf4u9rj6DcnfUdsQZBto5gS3FaVEHCmdVeqFPs+wEtWcbW
         J26aicb/UNXWJw2I9Yo0vTBRTQr5QMnYiGkS/yGxNxB14JmxviepHPNH3t+5kfJkCixT
         t8eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680655528;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tf25xAl4fSdxFBAk8i0l5aGjOrxXQadDD1CZezPxob4=;
        b=6apHCGWSWvawYExur/t5WFbfJk0dPSVaEhz6bQ9v4QmifFVAuk+aXEEHntrQYk62B0
         KWzoeP2CNUS+AYa/x3nH67JXT0IcyaF+ZgIcHecE/TpLSHjhpKKy4OgcVIk5Q4VDrmYH
         KQ07pbPig+WjV8zAr+VS6NxUQgyrH6Jy8ZrprEpPTFah9qe/N1Ob0yvlbgg0Jy2QkFbk
         jESCcFgir3Vx0dzj7RTf8f+PtuYNHEEvfdec1W4YwEXjxR5a8p1RXwnQfzMxWspWY3t4
         QHAksbc2BYIZaNSWXObwTV71vvSuMBONu8mBSJrbg4BESLZA6EhW5gWk+4L3/6WCgns6
         Pyqg==
X-Gm-Message-State: AAQBX9dRx3c+7tQmBF0eRSNWKWmU8AD1ruYZ5kURD1Ztu1NEaEWRevwO
        R4Jr8ZOFplD4pbGexSLj62U6++br4bY=
X-Google-Smtp-Source: AKy350YQgPiVQ7TtKQ68stor3n0AywFETiUdHnWp6vGFe/hNxqXs6gbyqffX7Pgd+A5LSfaogEOyIqxTAkE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:b692:b0:19f:3aa9:9ea1 with SMTP id
 c18-20020a170902b69200b0019f3aa99ea1mr1802510pls.8.1680655528391; Tue, 04 Apr
 2023 17:45:28 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue,  4 Apr 2023 17:45:17 -0700
In-Reply-To: <20230405004520.421768-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230405004520.421768-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <20230405004520.421768-4-seanjc@google.com>
Subject: [PATCH v4 3/6] KVM: selftests: Move XGETBV and XSETBV helpers to
 common code
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Aaron Lewis <aaronlewis@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Aaron Lewis <aaronlewis@google.com>

The instructions XGETBV and XSETBV are useful to other tests.  Move
them to processor.h to make them more broadly available.

No functional change intended.

Reviewed-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Aaron Lewis <aaronlewis@google.com>
Reviewed-by: Mingwei Zhang <mizhang@google.com>
[sean: reword shortlog]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/include/x86_64/processor.h  | 18 ++++++++++++++
 tools/testing/selftests/kvm/x86_64/amx_test.c | 24 +++----------------
 2 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 3538fa6db72d..f6061fe7057f 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -510,6 +510,24 @@ static inline void set_cr4(uint64_t val)
 	__asm__ __volatile__("mov %0, %%cr4" : : "r" (val) : "memory");
 }
 
+static inline u64 xgetbv(u32 index)
+{
+	u32 eax, edx;
+
+	__asm__ __volatile__("xgetbv;"
+		     : "=a" (eax), "=d" (edx)
+		     : "c" (index));
+	return eax | ((u64)edx << 32);
+}
+
+static inline void xsetbv(u32 index, u64 value)
+{
+	u32 eax = value;
+	u32 edx = value >> 32;
+
+	__asm__ __volatile__("xsetbv" :: "a" (eax), "d" (edx), "c" (index));
+}
+
 static inline struct desc_ptr get_gdt(void)
 {
 	struct desc_ptr gdt;
diff --git a/tools/testing/selftests/kvm/x86_64/amx_test.c b/tools/testing/selftests/kvm/x86_64/amx_test.c
index 5c82d7e6f552..af1ef6f79d32 100644
--- a/tools/testing/selftests/kvm/x86_64/amx_test.c
+++ b/tools/testing/selftests/kvm/x86_64/amx_test.c
@@ -65,24 +65,6 @@ struct xtile_info {
 
 static struct xtile_info xtile;
 
-static inline u64 __xgetbv(u32 index)
-{
-	u32 eax, edx;
-
-	asm volatile("xgetbv;"
-		     : "=a" (eax), "=d" (edx)
-		     : "c" (index));
-	return eax + ((u64)edx << 32);
-}
-
-static inline void __xsetbv(u32 index, u64 value)
-{
-	u32 eax = value;
-	u32 edx = value >> 32;
-
-	asm volatile("xsetbv" :: "a" (eax), "d" (edx), "c" (index));
-}
-
 static inline void __ldtilecfg(void *cfg)
 {
 	asm volatile(".byte 0xc4,0xe2,0x78,0x49,0x00"
@@ -160,10 +142,10 @@ static void init_regs(void)
 	set_cr4(cr4);
 	GUEST_ASSERT(this_cpu_has(X86_FEATURE_OSXSAVE));
 
-	xcr0 = __xgetbv(0);
+	xcr0 = xgetbv(0);
 	xcr0 |= XFEATURE_MASK_XTILE;
-	__xsetbv(0x0, xcr0);
-	GUEST_ASSERT((__xgetbv(0) & XFEATURE_MASK_XTILE) == XFEATURE_MASK_XTILE);
+	xsetbv(0x0, xcr0);
+	GUEST_ASSERT((xgetbv(0) & XFEATURE_MASK_XTILE) == XFEATURE_MASK_XTILE);
 }
 
 static void __attribute__((__flatten__)) guest_code(struct tile_config *amx_cfg,
-- 
2.40.0.348.gf938b09366-goog

