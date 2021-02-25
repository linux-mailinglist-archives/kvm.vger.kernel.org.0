Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FBDB325819
	for <lists+kvm@lfdr.de>; Thu, 25 Feb 2021 21:56:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234849AbhBYUya (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Feb 2021 15:54:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234361AbhBYUuj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Feb 2021 15:50:39 -0500
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B839C0611C3
        for <kvm@vger.kernel.org>; Thu, 25 Feb 2021 12:48:36 -0800 (PST)
Received: by mail-qv1-xf49.google.com with SMTP id t18so5213563qva.6
        for <kvm@vger.kernel.org>; Thu, 25 Feb 2021 12:48:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=XrhTobC3OEejIHUBLuboOaA6T5Q73z3PUoVSkeTI1do=;
        b=aOzJdenBeIwRZ3lWzSYRNWm/xIW0vfl+EgOdNvwi6R8AnIq/ZzSlUdSGeRrUx95KxJ
         2yPhrNwzMATkLxCIxAmov2eVFFUYHT6HXT4qXkgHrPAi4Oa/tDNWqTNAN3DR8v7kxZMv
         JxalCH8pAWAfRAXu+6QAQYPv4AqRVYbAMiojyHqaQjnwHHAD7m/B0LPrT1g3wfYKx9et
         V7S6wNYBao4hKs132T4TqsIK4H//1Cdm42pgf2bdDiocrlrh2Blw6G7gED2+3LE8BUZU
         dqGIXksnz5qjUfQ42JaHilDFhG4W3H/QwD92DokDgeMoeNe7AQZEw5sIBRPX8FbHGy8w
         1ylg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=XrhTobC3OEejIHUBLuboOaA6T5Q73z3PUoVSkeTI1do=;
        b=eKSmTM0u8VC5cHAYI5rMsZTjMqoQQOAOQlYzoafp6sT01CekvTPgehg9AlJ0CAncLF
         gZ15aOx6AjZTlDjJkQtsbaclvvQOPwMxX6dGEyUZnNyvpIziFlPB1OAwXjul9JwvwG/I
         FsB57f2yXQ8+UfG1ZhlC8U8ma8Rm+9jnT0v2+e+YE/QHGyhxFbkn9+NborwbRc+uLd1H
         yQLAiKSqK/bd+Zmr2wsmuo/vOAaTwz/cGt+cMs0yhj+Eqgj4hhbVNN/vWIYdleEzC+Xp
         62KMHdMvbkVCYSQn/x2usPQthG1/UCVqj+21kTy0eao5gQdsMgCQltsxaBoiHG/My/GX
         ZIaw==
X-Gm-Message-State: AOAM5325Vk71UaTXe5hz9MYaUZHfwG92MCpiU2Mg1mN5AVl7xNHVSJS7
        +1jL73qCr10G3syGdktSuLebrmxBydo=
X-Google-Smtp-Source: ABdhPJzmHrWxgypzPvNxUR+MzZsthqv2F8rLtCNZ7vvIfW28XqAAHBWf1aaOed/HfQ3WRJnGQ/a0POQ71/s=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:34c4:7c1d:f9ba:4576])
 (user=seanjc job=sendgmr) by 2002:a0c:ea87:: with SMTP id d7mr4583465qvp.27.1614286115712;
 Thu, 25 Feb 2021 12:48:35 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 25 Feb 2021 12:47:39 -0800
In-Reply-To: <20210225204749.1512652-1-seanjc@google.com>
Message-Id: <20210225204749.1512652-15-seanjc@google.com>
Mime-Version: 1.0
References: <20210225204749.1512652-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH 14/24] KVM: x86/mmu: Document dependency bewteen TDP A/D type
 and saved bits
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

Document that SHADOW_ACC_TRACK_SAVED_BITS_SHIFT is directly dependent on
bits 53:52 being used to track the A/D type.

Remove PT64_SECOND_AVAIL_BITS_SHIFT as it is at best misleading, and at
worst wrong.  For PAE paging, which arguably is a variant of PT64, the
bits are reserved.  For MMIO SPTEs the bits are not available as they're
used for the MMIO generation.  For access tracked SPTEs, they are also
not available as bits 56:54 are used to store the original RX bits.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/spte.h | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index bf4f49890606..e918b8f0b21d 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -6,7 +6,6 @@
 #include "mmu_internal.h"
 
 #define PT_FIRST_AVAIL_BITS_SHIFT 10
-#define PT64_SECOND_AVAIL_BITS_SHIFT 54
 
 /*
  * TDP SPTES (more specifically, EPT SPTEs) may not have A/D bits, and may also
@@ -134,11 +133,14 @@ extern u64 __read_mostly shadow_nonpresent_or_rsvd_mask;
  * The mask/shift to use for saving the original R/X bits when marking the PTE
  * as not-present for access tracking purposes. We do not save the W bit as the
  * PTEs being access tracked also need to be dirty tracked, so the W bit will be
- * restored only when a write is attempted to the page.
+ * restored only when a write is attempted to the page.  This mask obviously
+ * must not overlap the A/D type mask.
  */
 #define SHADOW_ACC_TRACK_SAVED_BITS_MASK (PT64_EPT_READABLE_MASK | \
 					  PT64_EPT_EXECUTABLE_MASK)
-#define SHADOW_ACC_TRACK_SAVED_BITS_SHIFT PT64_SECOND_AVAIL_BITS_SHIFT
+#define SHADOW_ACC_TRACK_SAVED_BITS_SHIFT 54
+static_assert(!(SPTE_TDP_AD_MASK & (SHADOW_ACC_TRACK_SAVED_BITS_MASK <<
+				    SHADOW_ACC_TRACK_SAVED_BITS_SHIFT)));
 
 /*
  * If a thread running without exclusive control of the MMU lock must perform a
-- 
2.30.1.766.gb4fecdf3b7-goog

