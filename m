Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D46DA4943AF
	for <lists+kvm@lfdr.de>; Thu, 20 Jan 2022 00:10:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357960AbiASXJf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jan 2022 18:09:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344102AbiASXID (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jan 2022 18:08:03 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CFC1C06175F
        for <kvm@vger.kernel.org>; Wed, 19 Jan 2022 15:08:03 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id o7-20020a17090a3d4700b001b4243e9ea2so2664772pjf.6
        for <kvm@vger.kernel.org>; Wed, 19 Jan 2022 15:08:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=SzpUxNwCpNHnqmiexHxG+Qtmmb9j6ESj4QKd4NHNfOQ=;
        b=C+r/BHH/umnNW0kEXIkSCoIWX49+z4SnFuuyW6miFrnrmQ+77SO1VkA3slUrrtZql4
         5GRYMnWLqFe4zeeDoO0GEbnfe5pJdzWuPwx0UtA+1nwhBdGVYol3Wz9orTOvjDAmgim9
         lCya+7edLKEfXTMjeQ9XFDviHkJx1c3BiyKerS7ubQGJa54fLsTcdX5fqTUbOhvQFBCx
         hwWbe/sWSbrtfx+pRNIzH09KNS9PwmXHeItEuQomCCblfgop6EJI2peGttCv2AX+JOr8
         vWMc/PYHMWIYoWw0uxREj0Ffv8CFpMb9TkMWhZvii2Dti0/BhvToaGUXZhIdEve0TFr/
         lg6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=SzpUxNwCpNHnqmiexHxG+Qtmmb9j6ESj4QKd4NHNfOQ=;
        b=1GDIWC7PcbjSTtlWwgj41O5/NhKITYG+Ktk9TUjJUktyv3q0/efPtJ73X59PZFboih
         +ivBv1onQZrP7cc4cW84ZdzuMjtGERlJr/e/krJAu+zho8VPKA8mX+16spe5lB/ogk45
         AnG2/6bueGyMvAzxJV8QjUBPyulMbQ9Dliz7FZ2Mk3Hgt6U/ir/Esu6K+IhHNmUwKCzY
         PQVKaysUD/NzIvXOAMM1KBXuS07QOm7oJsbPK7Ib1iL+nlU/twVUorYgGvZZIcQA5Ngi
         SwrAEW0huvfqrPp8rW3LN1rKTUP87T3mcmDkEwTq/Wr5gdsSPbQ3UYdUWwvb2EG7lY0O
         KfrQ==
X-Gm-Message-State: AOAM531dGClW7hpS2TRtOXNOLXG3PXPBhyGZtIt76MBBKknkAhWsxDEJ
        KgswSlvEppN9qeWxbsQ1pDUCguJa9Pk5Rw==
X-Google-Smtp-Source: ABdhPJyW7GagFRt2Sm7iNbU/IhIEPapew83E2GC3abrXggeOVVmpXAyk4ISaoNPPyifSi15cVe/YiWdktNRqCw==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:902:bd44:b0:14a:2c66:a06c with SMTP
 id b4-20020a170902bd4400b0014a2c66a06cmr35829040plx.152.1642633682725; Wed,
 19 Jan 2022 15:08:02 -0800 (PST)
Date:   Wed, 19 Jan 2022 23:07:30 +0000
In-Reply-To: <20220119230739.2234394-1-dmatlack@google.com>
Message-Id: <20220119230739.2234394-10-dmatlack@google.com>
Mime-Version: 1.0
References: <20220119230739.2234394-1-dmatlack@google.com>
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
Subject: [PATCH v2 09/18] KVM: x86/mmu: Drop new_spte local variable from restore_acc_track_spte()
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>,
        Junaid Shahid <junaids@google.com>,
        Oliver Upton <oupton@google.com>,
        Harish Barathvajasankar <hbarath@google.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>,
        "Nikunj A . Dadhania" <nikunj@amd.com>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The new_spte local variable is unnecessary. Deleting it can save a line
of code and simplify the remaining lines a bit.

No functional change intended.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 4485554336d7..7a70c238cd26 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -649,16 +649,15 @@ static u64 mmu_spte_get_lockless(u64 *sptep)
 /* Restore an acc-track PTE back to a regular PTE */
 static u64 restore_acc_track_spte(u64 spte)
 {
-	u64 new_spte = spte;
 	u64 saved_bits = (spte >> SHADOW_ACC_TRACK_SAVED_BITS_SHIFT)
 			 & SHADOW_ACC_TRACK_SAVED_BITS_MASK;
 
-	new_spte &= ~shadow_acc_track_mask;
-	new_spte &= ~(SHADOW_ACC_TRACK_SAVED_BITS_MASK <<
-		      SHADOW_ACC_TRACK_SAVED_BITS_SHIFT);
-	new_spte |= saved_bits;
+	spte &= ~shadow_acc_track_mask;
+	spte &= ~(SHADOW_ACC_TRACK_SAVED_BITS_MASK <<
+		  SHADOW_ACC_TRACK_SAVED_BITS_SHIFT);
+	spte |= saved_bits;
 
-	return new_spte;
+	return spte;
 }
 
 /* Returns the Accessed status of the PTE and resets it at the same time. */
-- 
2.35.0.rc0.227.g00780c9af4-goog

