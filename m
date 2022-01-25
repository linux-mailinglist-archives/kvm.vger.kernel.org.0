Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D846849BF55
	for <lists+kvm@lfdr.de>; Wed, 26 Jan 2022 00:05:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234639AbiAYXFn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jan 2022 18:05:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229759AbiAYXF2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jan 2022 18:05:28 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1386C06161C
        for <kvm@vger.kernel.org>; Tue, 25 Jan 2022 15:05:27 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id y17-20020a170902d65100b0014a17faf0bdso5806249plh.12
        for <kvm@vger.kernel.org>; Tue, 25 Jan 2022 15:05:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=HxJAxQ4MI8aCCbQ5x8o8jo9zvmoSS9iK0+ytmF0z014=;
        b=kVzDjs4bjahxuMCvNGitg3FRBPyJuW9NDLycy7/obZSpg/GDZ1bQ27pYMWGZMD1xty
         O/aJ9+vAsRl9toaNqOTroihCadE6R6u260hWMjAZwGObz9Ee1n7+uRKKnT70amRCNZtP
         MVLj0Mv8N5fAe5h6M5eBflc1El/hEsbWKh6jNzvVIWhZN/DOUagFFlfU+u2TrJJvOQWe
         /DEqoh0VoyE97SRkKp4lsVnQtYibMYFeikWDhQmzsi0g6pxkCSYIPKzA/TqqKwvUwkE+
         b+ua72azS+EUxIEjCsoDKAZMIgWrwztKHivdxHpwNU4W401a1DnKl9sinwnRXRsXIo7A
         Ubxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=HxJAxQ4MI8aCCbQ5x8o8jo9zvmoSS9iK0+ytmF0z014=;
        b=2++chZDul1AgxzFdfwG34sU/worWPOB8K9XdYj3FlbtW36ctXdaeVCnVUV6FmsWeyX
         d9CazkMdBBL4NAuns24eFYD496mHxqk911mFfMy9tUQcmZEivHoi1VAIK9iPGAXStxX5
         RlFPV2csBgvphWM6ZzLgY+hkukr8SYYPIrdX6VGgTBLGw0GwERFISscelAvKoKLHW++l
         GKjdRF7M/CYL97PHz+zjAh5uUR6r9/UO5SLV+/T3fD+WEhZOKHQUSZmAOYSwkUkMK5RI
         8W29aqexqaMHryl9bEbXhDuAZc7yP0AETO98ZeoW0DpZhn+gjaOB0OSR21jz1L5WXIex
         VTuQ==
X-Gm-Message-State: AOAM530ZhPWDn+wwpTDtp7CFElbtVyQ64L4OLRm/5xz84e9vAN4F8qJA
        7k5j3qez+E81ifCs6SBEbtkydnOrPk7crQ==
X-Google-Smtp-Source: ABdhPJxdkfimymCW0uzOnRFpuurtDT4twVS+xM6DqgEJYmF8lIS+Nk7SuveuhBVezcpIqMegHHQIgHfbgoWoYA==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a05:6a00:22d2:b0:4c1:d0dd:4b with SMTP id
 f18-20020a056a0022d200b004c1d0dd004bmr20498701pfj.59.1643151927140; Tue, 25
 Jan 2022 15:05:27 -0800 (PST)
Date:   Tue, 25 Jan 2022 23:05:14 +0000
In-Reply-To: <20220125230518.1697048-1-dmatlack@google.com>
Message-Id: <20220125230518.1697048-2-dmatlack@google.com>
Mime-Version: 1.0
References: <20220125230518.1697048-1-dmatlack@google.com>
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
Subject: [PATCH 1/5] KVM: x86/mmu: Move SPTE writable invariant checks to a
 helper function
From:   David Matlack <dmatlack@google.com>
To:     pbonzini@redhat.com
Cc:     seanjc@google.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, kvm@vger.kernel.org,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move the WARNs in spte_can_locklessly_be_made_writable() to a separate
helper function. This is in preparation for moving these checks to the
places where SPTEs are set.

Opportunistically add warning error messages that include the SPTE to
make future debugging of these warnings easier.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/spte.h | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index be6a007a4af3..912e66859ea0 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -339,15 +339,21 @@ static __always_inline bool is_rsvd_spte(struct rsvd_bits_validate *rsvd_check,
 	       __is_rsvd_bits_set(rsvd_check, spte, level);
 }
 
-static inline bool spte_can_locklessly_be_made_writable(u64 spte)
+static inline void check_spte_writable_invariants(u64 spte)
 {
-	if (spte & shadow_mmu_writable_mask) {
-		WARN_ON_ONCE(!(spte & shadow_host_writable_mask));
-		return true;
-	}
+	if (spte & shadow_mmu_writable_mask)
+		WARN_ONCE(!(spte & shadow_host_writable_mask),
+			  "kvm: MMU-writable SPTE is not Host-writable: %llx",
+			  spte);
+	else
+		WARN_ONCE(spte & PT_WRITABLE_MASK,
+			  "kvm: Writable SPTE is not MMU-writable: %llx", spte);
+}
 
-	WARN_ON_ONCE(spte & PT_WRITABLE_MASK);
-	return false;
+static inline bool spte_can_locklessly_be_made_writable(u64 spte)
+{
+	check_spte_writable_invariants(spte);
+	return spte & shadow_mmu_writable_mask;
 }
 
 static inline u64 get_mmio_spte_generation(u64 spte)

base-commit: e2e83a73d7ce66f62c7830a85619542ef59c90e4
-- 
2.35.0.rc0.227.g00780c9af4-goog

