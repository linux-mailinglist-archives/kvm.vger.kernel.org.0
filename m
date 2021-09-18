Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2797D410283
	for <lists+kvm@lfdr.de>; Sat, 18 Sep 2021 02:59:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245065AbhIRA7F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Sep 2021 20:59:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242022AbhIRA7D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Sep 2021 20:59:03 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A23BC061574;
        Fri, 17 Sep 2021 17:57:40 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id v2so7269031plp.8;
        Fri, 17 Sep 2021 17:57:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oxK1ob4roXyy3ZVWd2lGw+F2XcCDp2ZaJLGKfR9pxws=;
        b=IANeNGrCqrt3WDWCCioYG9kAL1ElSTErWjDK1D4eEYXgi7boZG5smt7RVTerSgMfPZ
         tFEWi27f34JhHoVBYY7pE3wAPCxoCLRbck6EUHY1/oqm28XFGINIUCVJGSwDVyCsmv6S
         RRWWxZ/kgvFtT3t8yhB0UzJdpse3xlKhbpkQPL45MgIhmA4X1Yl4Z94aqSpBfXugBbAm
         uRyP/BCy1W2ytzGbpTPl4u7c72uTJFKP82rhTRHqS+NYHu8Z05gzzaD99FQfUQunkeTH
         cI5dxFBCkMQoRbGLrlrhQAOf3cYkqpzf6tLdsyjmWzJ3i6MuiWE6LJweREo/3XdQ9W4Y
         g38w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oxK1ob4roXyy3ZVWd2lGw+F2XcCDp2ZaJLGKfR9pxws=;
        b=iW1yGX25o+u5gcd/CzGJa19JAx2q8IGMuC3yibg8dDL8vZ3R2kGiMolkcXMZuTxgt9
         ajQwXq0gwN2PkoQ2olwmcEGZ9EmXgBwLszosCcK+8hPt4i0A1labUukKNfEyEmKQPxKn
         GqW9nhhG4Tpt8q+dMzIKeZ+JTmNAZDQB9fk+Sy7GcZETteaTXSHl6aMa7EnL3qzN+/Fm
         1TGULjhSO9P9/NAREbGAl6YEZCcIBUttwVv/nUdK2GNdDa4u2sy7z5KSsf1YAccR2HsA
         z9k6MIcE2rJ9ZzSR4g9PNwhWrC6icVK9cwyVklqULzCSCsEBuQmI+5QGGd0FAldtX3zx
         h6gQ==
X-Gm-Message-State: AOAM532RgDC4XqN7g5tMfs0uy6lkcQ67ExVuxiOoGJqwjERmKoUU32Vc
        ld8SA1hZzm3YvXqUqP3Tm6jT4dMx1Dw=
X-Google-Smtp-Source: ABdhPJzPMTRNDrgN1TgCxUqYfsVXYkhJck1T+xcbJFAbA+Vlj/zIScih/9aFt5V65C6o/czg/plaKg==
X-Received: by 2002:a17:90a:1a43:: with SMTP id 3mr2350434pjl.242.1631926659991;
        Fri, 17 Sep 2021 17:57:39 -0700 (PDT)
Received: from localhost ([47.251.4.198])
        by smtp.gmail.com with ESMTPSA id 203sm6665814pfx.119.2021.09.17.17.57.38
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 17 Sep 2021 17:57:39 -0700 (PDT)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     Lai Jiangshan <laijs@linux.alibaba.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        kvm@vger.kernel.org
Subject: [PATCH V2 10/10] KVM: X86: Don't check unsync if the original spte is writible
Date:   Sat, 18 Sep 2021 08:56:36 +0800
Message-Id: <20210918005636.3675-11-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20210918005636.3675-1-jiangshanlai@gmail.com>
References: <20210918005636.3675-1-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <laijs@linux.alibaba.com>

If the original spte is writable, the target gfn should not be the
gfn of synchronized shadowpage and can continue to be writable.

When !can_unsync, speculative must be false.  So when the check of
"!can_unsync" is removed, we need to move the label of "out" up.

Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
---
 arch/x86/kvm/mmu/spte.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index b68a580f3510..a33c581aabd6 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -150,7 +150,7 @@ int make_spte(struct kvm_vcpu *vcpu, unsigned int pte_access, int level,
 		 * is responsibility of kvm_mmu_get_page / kvm_mmu_sync_roots.
 		 * Same reasoning can be applied to dirty page accounting.
 		 */
-		if (!can_unsync && is_writable_pte(old_spte))
+		if (is_writable_pte(old_spte))
 			goto out;
 
 		/*
@@ -171,10 +171,10 @@ int make_spte(struct kvm_vcpu *vcpu, unsigned int pte_access, int level,
 	if (pte_access & ACC_WRITE_MASK)
 		spte |= spte_shadow_dirty_mask(spte);
 
+out:
 	if (speculative)
 		spte = mark_spte_for_access_track(spte);
 
-out:
 	WARN_ONCE(is_rsvd_spte(&vcpu->arch.mmu->shadow_zero_check, spte, level),
 		  "spte = 0x%llx, level = %d, rsvd bits = 0x%llx", spte, level,
 		  get_rsvd_bits(&vcpu->arch.mmu->shadow_zero_check, spte, level));
-- 
2.19.1.6.gb485710b

