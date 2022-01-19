Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 761C34943A0
	for <lists+kvm@lfdr.de>; Thu, 20 Jan 2022 00:09:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344502AbiASXJp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jan 2022 18:09:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344302AbiASXIB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jan 2022 18:08:01 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A779C06175E
        for <kvm@vger.kernel.org>; Wed, 19 Jan 2022 15:08:01 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id t27-20020a63461b000000b00342c204e4f3so2510499pga.11
        for <kvm@vger.kernel.org>; Wed, 19 Jan 2022 15:08:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=bFqSO9GhIrq7/q8ry8SyB115cIj+EzEpZTQAJaeeMIs=;
        b=X4NmAkWWyB4nE67ptW29AuU7BCKuQoryzYksX7w0p/BzEIgdJq6u7km1g10xXyUQ0U
         YinvhuwI/cf1zzzbz9MdGtHg/oyCBypC1/4i3/mmQFE6TzpXDWCt64BuDgG8xs4HrEeh
         /CAoZWkzbagMeq05YKn8RlCGgM1onVUyf03JpCaEVdf0+MOBylGF3Vq+dAQ76pw1fF68
         5QD5U/9TgEYvfQAlWAChC5PWiFWdO81IM/eGktXstn1n8jJDukhqRwkLQeVStsgF0g//
         xXBjiEzAEd4tFJTogF3vldznG6ppFaV5DNnDhJHijfymjL1dM/oYS1UXJ+fCfhVT6NaX
         omYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=bFqSO9GhIrq7/q8ry8SyB115cIj+EzEpZTQAJaeeMIs=;
        b=MRjdfN857DAerVyjl1YT0RCe506HMpdfYDOUHrNu48t+72UAbsZErgxgv5UuxXD+9O
         xWnXJ+jiUlD1EyeFokGNr97z5Qb2zLqpVPAHD4Oxe8f/nUnIVFBnrglK+CwqAwbUQy+k
         kC6kCaZdD7fcQ3M+2DWZuf/YRw3HIxlmkxVkWcXOsLmNdPBvo1SFlDAg1/Xlr8m+1mFn
         CN0KtPcfy2qewu+YKuMGoq06VYJ7lOVy7LD8wtvUVIjtJ0qerGi8gqIpxBWG/LsSBznh
         C8j2kpNwDaPKzWnw2p3pGPNl2CqR0l8u+m9Zj4u+1rvyuUpBDwrJCBEZKtrLub7k0iCj
         qlng==
X-Gm-Message-State: AOAM531VnCS65PvJSQJdMh8ZI+6ZZkrslBHffn6QcsAVCXs6osRTQoen
        1idqYxE+EfrMaXLpPWiM12yFSDu14sVw4A==
X-Google-Smtp-Source: ABdhPJyIzi1D797C8LkwEjjKFr8fCIu/AYIXhZzIeEP59gVyjM/BZSMOzh7duMK+KtpkqIIvpF9kMgxyTBsr4w==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a05:6a00:2181:b0:4c1:3b84:b43f with SMTP
 id h1-20020a056a00218100b004c13b84b43fmr32747307pfi.50.1642633680986; Wed, 19
 Jan 2022 15:08:00 -0800 (PST)
Date:   Wed, 19 Jan 2022 23:07:29 +0000
In-Reply-To: <20220119230739.2234394-1-dmatlack@google.com>
Message-Id: <20220119230739.2234394-9-dmatlack@google.com>
Mime-Version: 1.0
References: <20220119230739.2234394-1-dmatlack@google.com>
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
Subject: [PATCH v2 08/18] KVM: x86/mmu: Remove unnecessary warnings from restore_acc_track_spte()
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

The warnings in restore_acc_track_spte() can be removed because the only
caller checks is_access_track_spte(), and is_access_track_spte() checks
!spte_ad_enabled(). In other words, the warning can never be triggered.

No functional change intended.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index fb6718714caa..4485554336d7 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -653,9 +653,6 @@ static u64 restore_acc_track_spte(u64 spte)
 	u64 saved_bits = (spte >> SHADOW_ACC_TRACK_SAVED_BITS_SHIFT)
 			 & SHADOW_ACC_TRACK_SAVED_BITS_MASK;
 
-	WARN_ON_ONCE(spte_ad_enabled(spte));
-	WARN_ON_ONCE(!is_access_track_spte(spte));
-
 	new_spte &= ~shadow_acc_track_mask;
 	new_spte &= ~(SHADOW_ACC_TRACK_SAVED_BITS_MASK <<
 		      SHADOW_ACC_TRACK_SAVED_BITS_SHIFT);
-- 
2.35.0.rc0.227.g00780c9af4-goog

