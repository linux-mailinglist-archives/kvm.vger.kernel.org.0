Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7FA03257EC
	for <lists+kvm@lfdr.de>; Thu, 25 Feb 2021 21:48:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233557AbhBYUsv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Feb 2021 15:48:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233161AbhBYUsn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Feb 2021 15:48:43 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98843C061788
        for <kvm@vger.kernel.org>; Thu, 25 Feb 2021 12:48:03 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id d8so7627560ybs.11
        for <kvm@vger.kernel.org>; Thu, 25 Feb 2021 12:48:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=+xZ858irlb6FpgV9qRqhKqfeu+ijlTKA7VlYstFtMqQ=;
        b=PtDP0nkf66ltqftVB5b4R66eJDmEzTvZ/GwTuLwCpuuPlat3uIbiyQaAJ1fJMXbnKB
         ZtMd9SgzJYo2oo+qZ1IHkP3fLqL0yJqHSNO4GE91BkfV2a4HHJ2WDoB1oaN1/Iq93U0b
         pLViuagdt2GdbIbJFTvH3V4IANkCWR4iEA2r3DeD4NEZpy/bPgY0wrEGv2uq8vbQ8lrc
         sQNbL0lHlVNm+Cl6okH/9urblJNrVQ87cis1qqsnxbsz44FigdgIEj52e9VLv9Thw/Gp
         TkAR+PKwI/pfKc/dQpAcAUSU+KcDdA9aAl2O80p1H6BXWkcaQpcgPtEPRg3QyK3jOLGB
         M+7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=+xZ858irlb6FpgV9qRqhKqfeu+ijlTKA7VlYstFtMqQ=;
        b=TeFi95MT2CADixw5t1WxMrqqtp1Xd9ShD1R5BM7y1+IufWOHl5eNdbx8Z6JdFsY5jt
         /UGsOAYnvigKg9mBY+T1HQ8FxeOOZT6F0KzmaQbvQrIBPgrjejC/j6ICQbKy8AHO5DqL
         3XqVdCcK1eehjUCKTBtu86YHixBCA1W/y2TstTNK5npSNFaga2vWPFdA53jqj4WtyN+K
         1wzLjpNS3ZxR4q3Tl/+VTjdiLW8ksvT2I8vhqV3SmWk5pItECL9+4W8/G4xc6AjYaiB2
         QpyciH/JhCcR9/3WZuJROC5Bb0tTwmCDKuXvmLZE6LkQdqP+WyRC7uMrWZy9syRsbc3J
         69ig==
X-Gm-Message-State: AOAM530rJu8+oDfshzG5N80dPicP75N1dw/eVMPtOphIumy86xFUQQ1a
        g7Rkm/AdMHuhe5UZrix7gpadeUgj8hA=
X-Google-Smtp-Source: ABdhPJwJdk88Cn1vr8QKJWKIAG58De/q53rJRiGSKfR1+pb1TM0+RUkWMxlhQgca2wfVDwGfHCmucILesuU=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:34c4:7c1d:f9ba:4576])
 (user=seanjc job=sendgmr) by 2002:a25:bbd0:: with SMTP id c16mr6531571ybk.23.1614286082831;
 Thu, 25 Feb 2021 12:48:02 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 25 Feb 2021 12:47:27 -0800
In-Reply-To: <20210225204749.1512652-1-seanjc@google.com>
Message-Id: <20210225204749.1512652-3-seanjc@google.com>
Mime-Version: 1.0
References: <20210225204749.1512652-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH 02/24] KVM: x86/mmu: Check for shadow-present SPTE before
 querying A/D status
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

When updating accessed and dirty bits, check that the new SPTE is present
before attempting to query its A/D bits.  Failure to confirm the SPTE is
present can theoretically cause a false negative, e.g. if a MMIO SPTE
replaces a "real" SPTE and somehow the PFNs magically match.

Realistically, this is all but guaranteed to be a benign bug.  Fix it up
primarily so that a future patch can tweak the MMU_WARN_ON checking A/D
status to fire if the SPTE is not-present.

Fixes: f8e144971c68 ("kvm: x86/mmu: Add access tracking for tdp_mmu")
Cc: Ben Gardon <bgardon@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index c926c6b899a1..f46972892a2d 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -210,13 +210,12 @@ static int kvm_mmu_page_as_id(struct kvm_mmu_page *sp)
 
 static void handle_changed_spte_acc_track(u64 old_spte, u64 new_spte, int level)
 {
-	bool pfn_changed = spte_to_pfn(old_spte) != spte_to_pfn(new_spte);
-
 	if (!is_shadow_present_pte(old_spte) || !is_last_spte(old_spte, level))
 		return;
 
 	if (is_accessed_spte(old_spte) &&
-	    (!is_accessed_spte(new_spte) || pfn_changed))
+	    (!is_shadow_present_pte(new_spte) || !is_accessed_spte(new_spte) ||
+	     spte_to_pfn(old_spte) != spte_to_pfn(new_spte)))
 		kvm_set_pfn_accessed(spte_to_pfn(old_spte));
 }
 
@@ -444,7 +443,7 @@ static void __handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
 
 
 	if (was_leaf && is_dirty_spte(old_spte) &&
-	    (!is_dirty_spte(new_spte) || pfn_changed))
+	    (!is_present || !is_dirty_spte(new_spte) || pfn_changed))
 		kvm_set_pfn_dirty(spte_to_pfn(old_spte));
 
 	/*
-- 
2.30.1.766.gb4fecdf3b7-goog

