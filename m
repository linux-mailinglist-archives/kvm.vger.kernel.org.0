Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03FDC331CE3
	for <lists+kvm@lfdr.de>; Tue,  9 Mar 2021 03:20:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230527AbhCICTt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Mar 2021 21:19:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231137AbhCICTh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Mar 2021 21:19:37 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A12ABC061760
        for <kvm@vger.kernel.org>; Mon,  8 Mar 2021 18:19:26 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id u1so15263950ybu.14
        for <kvm@vger.kernel.org>; Mon, 08 Mar 2021 18:19:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=uw3BH6/FNGDtu+4dVVcD0nL4Y6kUw34aDqiVArA19lY=;
        b=IZK3UaFgccqSlDtKoefnNy8R8/MW1kIsozIrVUFZ1dTElrg1ja90xK3sGIRILOE9JH
         OjavFyRSEGScFUML5G7+WfhsEPDkhr/W9R1n2ZAHAYwk1Fdx00AjXbxZWHlxiGHhUicg
         1lZSr6R7BHI3/Z+r5/oqPC1VJysvnt0ETLFZGoQ+JlnhJwZD2QS2u6ih89zULztJuls3
         mGV8SnlJiDR4z+E1QyrSkCtE/ju1Yf6CG4M27FEivkpP8IFm2hs2icmDa2mr7MBU3R6c
         WO3DKeADdw+YdTGU014A8DkuGGOEIwy5FeLemqGckXTlqiq9V3M67BkAB1ichrYtfIKG
         bXPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=uw3BH6/FNGDtu+4dVVcD0nL4Y6kUw34aDqiVArA19lY=;
        b=FwAuNZndYpj4U7H4JPdMFaLXTBOtklg9NEcPM7X+u4PTqiPZ86UeXKWUZDZ+8vLpXf
         glEySwHlL9kfZVIpVMi5LfjpHcrLQjKtkXMiOKUy0TE6HgTr31VoyGMpmp3+n1X9wH6B
         lk9i8RPz2X4yy5DIlgTOZgs9gG9sBeVwT4whi3ehDfGTxZi7tsDYJ6TKOrRhMgHBfhwP
         NY6TrXVyYOvKHA8sbeDNXVp3BPg98cqUxwg4U8VGjgyn8P4GgKmPtPd2cW/I4vEDSGun
         N2lQwdsT6u2URe2u6hhIIKUlWJ23grzXe7+St7ojRbvIRUN0yHfSFdrwngE/i/HfQ7GM
         T+kg==
X-Gm-Message-State: AOAM532h0KmQZ6CU6aU1Dg2GUStNN4cav+OoXv0X5ro11DXy38e/a1gB
        qj5oakcUrwN/NIE1ucFaYzqG7jylgKY=
X-Google-Smtp-Source: ABdhPJznSpnEuo7BWTAIYUHsYq5YwWMaQgxuorJi6erke3MnODxHexRPNN67nOZrPgAlcfbNPbVUZNTOz0Y=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:8:847a:d8b5:e2cc])
 (user=seanjc job=sendgmr) by 2002:a25:d296:: with SMTP id j144mr38486674ybg.33.1615256365942;
 Mon, 08 Mar 2021 18:19:25 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Mon,  8 Mar 2021 18:19:00 -0800
In-Reply-To: <20210309021900.1001843-1-seanjc@google.com>
Message-Id: <20210309021900.1001843-3-seanjc@google.com>
Mime-Version: 1.0
References: <20210309021900.1001843-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH 2/2] KVM: x86/mmu: Exclude the MMU_PRESENT bit from MMIO
 SPTE's generation
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>
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

