Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 830B13331A6
	for <lists+kvm@lfdr.de>; Tue,  9 Mar 2021 23:43:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232095AbhCIWmd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Mar 2021 17:42:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232101AbhCIWmT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Mar 2021 17:42:19 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ACA1C06174A
        for <kvm@vger.kernel.org>; Tue,  9 Mar 2021 14:42:19 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id q77so19080661ybq.0
        for <kvm@vger.kernel.org>; Tue, 09 Mar 2021 14:42:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=lsTrBguBJ33tlWNbEPVySyXiNpj8s/BCHc56IoJDIiw=;
        b=qF8XJ66q2Y/it4EK9taRHSOkIeXPutLgTrwsvj79SpSXAD5hNpqW/Ry+yVn/KzVOWx
         qkUbmv+U7rgXGiq6Q4QNl2PCf+Q/jVe65w9Lum0TAGh2cwn31Sy5waZXlp9FJ1ZjVOBP
         7HaH4dTObwlqU2IXjPJSOUpe0n0wavCM0BYo0riidZD+zB2bJ+CtzJIZ5P0Mk6cEtFrO
         LaeyRgH4zjWE63BB5U4HtkAdEJ2SLbo3Pk3fCDSOpUD8SjKQq0ndiJ5PfXq+87lKmN6p
         tQODzEuQXfEbWVgq54MLUrEKMjOwxg0uVQsulD91krEwVb6/B9qzLD5yp5Cs9WSmvnb0
         /0xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=lsTrBguBJ33tlWNbEPVySyXiNpj8s/BCHc56IoJDIiw=;
        b=UxxiphINO9luDAzDTyS+tQ6Ose0SkrKcozk2VHc24SpFtVBgjolMvs1ctu9WgIUya/
         oKCTDr0i4xt8wiWVStiw3/MEtmtNwpr1m+2sRb0poE0GwQ2OHuATiAFT4WSCzxW0Zyvf
         AAox31KV8AV/x9P0N2ZaqpBJo2okwCsq0SLBVSOHd2WUZA1zTJvImVaW98jpOIerjsQD
         kZmlqGSThB0CSPt1bFo6aw1YHACvi9kLs9ptyBhbA61lSc9dhVE1WPMsECYkDrHjF3Cg
         hR1Q/OoX9m5qxQCsexMnZRCQ7HmJ44T8rNBW5r7Sgre3+C7m7Ls5M4ciB5W4OjuqIxnl
         eEgA==
X-Gm-Message-State: AOAM533vUCz3VB8Saj7f8YUUBP5fSPHB5o16IQNhSR5z5H904a617tqt
        dswmPbfJ8fzfAP1MhFBKE2rjcsmE3PY=
X-Google-Smtp-Source: ABdhPJx6AEOtkTqNg9rttQTRVJPCrBwoWb02SpJI50TEvPxJjU+v0/F+/WuOOuqc8q8wRrtJdPR9bOM8dF0=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:e4dd:6c31:9463:f8da])
 (user=seanjc job=sendgmr) by 2002:a25:8b0d:: with SMTP id i13mr32562ybl.521.1615329738523;
 Tue, 09 Mar 2021 14:42:18 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue,  9 Mar 2021 14:42:05 -0800
In-Reply-To: <20210309224207.1218275-1-seanjc@google.com>
Message-Id: <20210309224207.1218275-3-seanjc@google.com>
Mime-Version: 1.0
References: <20210309224207.1218275-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH v2 2/4] KVM: x86/mmu: Exclude the MMU_PRESENT bit from MMIO
 SPTE's generation
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Drop bit 11, used for the MMU_PRESENT flag, from the set of bits used to
store the generation number in MMIO SPTEs.  MMIO SPTEs with bit 11 set,
which occurs when userspace creates 128+ memslots in an address space,
get false positives for is_shadow_present_spte(), which lead to a variety
of fireworks, crashes KVM, and likely hangs the host kernel.

Fixes: b14e28f37e9b ("KVM: x86/mmu: Use a dedicated bit to track shadow/MMU-present SPTEs")
Reported-by: Tom Lendacky <thomas.lendacky@amd.com>
Reported-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Tested-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/spte.h | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index b53036d9ddf3..bca0ba11cccf 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -101,11 +101,11 @@ static_assert(!(EPT_SPTE_MMU_WRITABLE & SHADOW_ACC_TRACK_SAVED_MASK));
 #undef SHADOW_ACC_TRACK_SAVED_MASK
 
 /*
- * Due to limited space in PTEs, the MMIO generation is a 20 bit subset of
+ * Due to limited space in PTEs, the MMIO generation is a 19 bit subset of
  * the memslots generation and is derived as follows:
  *
- * Bits 0-8 of the MMIO generation are propagated to spte bits 3-11
- * Bits 9-19 of the MMIO generation are propagated to spte bits 52-62
+ * Bits 0-7 of the MMIO generation are propagated to spte bits 3-10
+ * Bits 8-18 of the MMIO generation are propagated to spte bits 52-62
  *
  * The KVM_MEMSLOT_GEN_UPDATE_IN_PROGRESS flag is intentionally not included in
  * the MMIO generation number, as doing so would require stealing a bit from
@@ -116,7 +116,7 @@ static_assert(!(EPT_SPTE_MMU_WRITABLE & SHADOW_ACC_TRACK_SAVED_MASK));
  */
 
 #define MMIO_SPTE_GEN_LOW_START		3
-#define MMIO_SPTE_GEN_LOW_END		11
+#define MMIO_SPTE_GEN_LOW_END		10
 
 #define MMIO_SPTE_GEN_HIGH_START	52
 #define MMIO_SPTE_GEN_HIGH_END		62
@@ -125,12 +125,14 @@ static_assert(!(EPT_SPTE_MMU_WRITABLE & SHADOW_ACC_TRACK_SAVED_MASK));
 						    MMIO_SPTE_GEN_LOW_START)
 #define MMIO_SPTE_GEN_HIGH_MASK		GENMASK_ULL(MMIO_SPTE_GEN_HIGH_END, \
 						    MMIO_SPTE_GEN_HIGH_START)
+static_assert(!(SPTE_MMU_PRESENT_MASK &
+		(MMIO_SPTE_GEN_LOW_MASK | MMIO_SPTE_GEN_HIGH_MASK)));
 
 #define MMIO_SPTE_GEN_LOW_BITS		(MMIO_SPTE_GEN_LOW_END - MMIO_SPTE_GEN_LOW_START + 1)
 #define MMIO_SPTE_GEN_HIGH_BITS		(MMIO_SPTE_GEN_HIGH_END - MMIO_SPTE_GEN_HIGH_START + 1)
 
 /* remember to adjust the comment above as well if you change these */
-static_assert(MMIO_SPTE_GEN_LOW_BITS == 9 && MMIO_SPTE_GEN_HIGH_BITS == 11);
+static_assert(MMIO_SPTE_GEN_LOW_BITS == 8 && MMIO_SPTE_GEN_HIGH_BITS == 11);
 
 #define MMIO_SPTE_GEN_LOW_SHIFT		(MMIO_SPTE_GEN_LOW_START - 0)
 #define MMIO_SPTE_GEN_HIGH_SHIFT	(MMIO_SPTE_GEN_HIGH_START - MMIO_SPTE_GEN_LOW_BITS)
-- 
2.30.1.766.gb4fecdf3b7-goog

