Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E11F1325808
	for <lists+kvm@lfdr.de>; Thu, 25 Feb 2021 21:53:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234600AbhBYUwU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Feb 2021 15:52:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234220AbhBYUuN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Feb 2021 15:50:13 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6015C0611C2
        for <kvm@vger.kernel.org>; Thu, 25 Feb 2021 12:48:33 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id j4so7502442ybt.23
        for <kvm@vger.kernel.org>; Thu, 25 Feb 2021 12:48:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=iKJLs+velK3tbbbqG24O5VyKgRTy3wHLluGHdOvzpgU=;
        b=c16m5fP+SpCoY8+Sz3VL1bRlpB0IOoWxnO0jmB37hGhNGm2KgtoNzrIye/2rFrSAt8
         KhBU9Q9IloU6akt/33FAi29Elcb+fD7Ldf3WQWpKeayx/39ZbGeeLnVXYTOJqi+qjOJw
         xHGGweXg+BWHNZvy6ML1iAKUTK9y5c9Jv3NtsLgD+DV0ueb5W9MJX9OcMNIgBnFVfaVA
         3FLemBZ0WblYjTtAa3Mxavr/gGaEvm+xn53jy2B6Vh8U2lQ4oMuxZvT6+4mGKVrtazWl
         KEMcpAI1Pf90DZIqpxlarn52e+A8PAZ8jDvKHd6UE7gd3oaRRVzp64/u/bnhYS0ovZwb
         sw7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=iKJLs+velK3tbbbqG24O5VyKgRTy3wHLluGHdOvzpgU=;
        b=ZpW/5ZEM6fbKxEcG76oCEjiccuWUvkLsXiJw/ajMwjUpSIhupy24sBH9KmRvuYPXkW
         JrafFcDsm+kXIJpUcRjVCIW20F0RybUGm36KMvPZK1JRYKpAes24wNOdGiZhJEkxEpRA
         hNvLn9TvKIm4daj8chIhHdGBs+3k+JPyXj+s3to0W42kj7v0/0/A9npycdwBDceJzAa/
         iK66Cj6JBrMq/aHJNmW4ZwPJTMggnCCBbfF80najY1LlMNutwO/D3RCcg/4gVxy1saq4
         12QBlH6tgs6bEhSSXzTmj5sIoX5walObBHrQ1VRiINNOpW87jEpEkOLYSZtdRra2Wa2g
         x+GQ==
X-Gm-Message-State: AOAM533q1WoJhi1Ydil/bszcSx0Je0iH3DXgLkndthwytDrCbaZWIpmF
        A/L8/ojbmqOb0KecoMZTRnlD1VwVscA=
X-Google-Smtp-Source: ABdhPJyxdfNw7gAbChySrqKHw9zv/yCfvcjoe75Yr2KYX6LuA2A8TRL9xhG7JHcEgHCraEL9ypNV3Ztjmy8=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:34c4:7c1d:f9ba:4576])
 (user=seanjc job=sendgmr) by 2002:a25:482:: with SMTP id 124mr6891292ybe.315.1614286112926;
 Thu, 25 Feb 2021 12:48:32 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 25 Feb 2021 12:47:38 -0800
In-Reply-To: <20210225204749.1512652-1-seanjc@google.com>
Message-Id: <20210225204749.1512652-14-seanjc@google.com>
Mime-Version: 1.0
References: <20210225204749.1512652-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH 13/24] KVM: x86/mmu: Use MMIO SPTE bits 53 and 52 for the MMIO generation
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use bits 53 and 52 for the MMIO generation now that they're not used to
identify MMIO SPTEs.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/spte.c | 1 -
 arch/x86/kvm/mmu/spte.h | 8 ++++----
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index 3eaf143b7d12..cf0e20b34cd3 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -42,7 +42,6 @@ static u64 generation_mmio_spte_mask(u64 gen)
 	u64 mask;
 
 	WARN_ON(gen & ~MMIO_SPTE_GEN_MASK);
-	BUILD_BUG_ON((MMIO_SPTE_GEN_HIGH_MASK | MMIO_SPTE_GEN_LOW_MASK) & SPTE_TDP_AD_MASK);
 
 	mask = (gen << MMIO_SPTE_GEN_LOW_SHIFT) & MMIO_SPTE_GEN_LOW_MASK;
 	mask |= (gen << MMIO_SPTE_GEN_HIGH_SHIFT) & MMIO_SPTE_GEN_HIGH_MASK;
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index fd0a7911f098..bf4f49890606 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -65,11 +65,11 @@ static_assert(SPTE_TDP_AD_ENABLED_MASK == 0);
 #define SPTE_MMU_WRITEABLE	(1ULL << (PT_FIRST_AVAIL_BITS_SHIFT + 1))
 
 /*
- * Due to limited space in PTEs, the MMIO generation is a 18 bit subset of
+ * Due to limited space in PTEs, the MMIO generation is a 20 bit subset of
  * the memslots generation and is derived as follows:
  *
  * Bits 0-8 of the MMIO generation are propagated to spte bits 3-11
- * Bits 9-17 of the MMIO generation are propagated to spte bits 54-62
+ * Bits 9-19 of the MMIO generation are propagated to spte bits 52-62
  *
  * The KVM_MEMSLOT_GEN_UPDATE_IN_PROGRESS flag is intentionally not included in
  * the MMIO generation number, as doing so would require stealing a bit from
@@ -82,7 +82,7 @@ static_assert(SPTE_TDP_AD_ENABLED_MASK == 0);
 #define MMIO_SPTE_GEN_LOW_START		3
 #define MMIO_SPTE_GEN_LOW_END		11
 
-#define MMIO_SPTE_GEN_HIGH_START	PT64_SECOND_AVAIL_BITS_SHIFT
+#define MMIO_SPTE_GEN_HIGH_START	52
 #define MMIO_SPTE_GEN_HIGH_END		62
 
 #define MMIO_SPTE_GEN_LOW_MASK		GENMASK_ULL(MMIO_SPTE_GEN_LOW_END, \
@@ -94,7 +94,7 @@ static_assert(SPTE_TDP_AD_ENABLED_MASK == 0);
 #define MMIO_SPTE_GEN_HIGH_BITS		(MMIO_SPTE_GEN_HIGH_END - MMIO_SPTE_GEN_HIGH_START + 1)
 
 /* remember to adjust the comment above as well if you change these */
-static_assert(MMIO_SPTE_GEN_LOW_BITS == 9 && MMIO_SPTE_GEN_HIGH_BITS == 9);
+static_assert(MMIO_SPTE_GEN_LOW_BITS == 9 && MMIO_SPTE_GEN_HIGH_BITS == 11);
 
 #define MMIO_SPTE_GEN_LOW_SHIFT		(MMIO_SPTE_GEN_LOW_START - 0)
 #define MMIO_SPTE_GEN_HIGH_SHIFT	(MMIO_SPTE_GEN_HIGH_START - MMIO_SPTE_GEN_LOW_BITS)
-- 
2.30.1.766.gb4fecdf3b7-goog

