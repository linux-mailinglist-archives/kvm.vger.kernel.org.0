Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1772C325B21
	for <lists+kvm@lfdr.de>; Fri, 26 Feb 2021 02:05:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232144AbhBZBFP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Feb 2021 20:05:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231787AbhBZBFG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Feb 2021 20:05:06 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C20F6C06178C
        for <kvm@vger.kernel.org>; Thu, 25 Feb 2021 17:03:41 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id 194so8358770ybl.5
        for <kvm@vger.kernel.org>; Thu, 25 Feb 2021 17:03:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=qpS7GnYM+VvVuInH7Q+CEmlH+I0WNjfKsvpZu1wz92s=;
        b=Wben5QyU96ys7KjMGaMwlDENkCrkljjCcTiQK7iqau4peOpcza4F9Nu5kai1mo7aHB
         wowSzju/bwAwXxMLBGdCBG3Vo3x9rviVRz5Bk2xXxl9lZFfBrZy5gPg76k2B1MiGnBZy
         BcTRRAQTdJGX5yu2za10oYQgWodsHWF7se0NAl4wk46k+/GYHyff5aK0LaPO/32P/h5h
         ysdX8JS1qvkkbBMKYR58Otttd3LX2dAeIRbplsgtg76qqHHjwyXvqaHd2ZnwC86bE+6b
         1OvbirwMVSUNB8bsMJ8pgQs4PBIzbhuhTg3iR7hvgH2lzMLXU6ypMAU9kWXpApmGDcTx
         e5xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=qpS7GnYM+VvVuInH7Q+CEmlH+I0WNjfKsvpZu1wz92s=;
        b=cA9GXwfiUH+seP8dsKp76DGVErZtW2ipdVMNTd2oOornWMtTk9w9qYWLGHm+EcnFSm
         RL3jW9W8bvAxY14yCULe5dK231BTysTxIg5K6CEK9g6UYiDSN9EdJZiSHiiqm9preecD
         TPlhSRyyFX2pIeSRzkp0zKS4JGpCQcd3iSmTx6g8DrtPKF63R7/lcARLg2bVJfORa1aR
         JveDDuDcx9iQZIUOT/7uCA8hFmiEa1CblIvmFWgMADRsZ7XsAMgo7F95vltTJt3MF+h0
         n53mvzHiwk+e6f9L5VjJPDdtrxgdglmUr8ZuJNRlEZgWkESPm5rEZsea3Vl4JfrClLEd
         nAjA==
X-Gm-Message-State: AOAM5313k6dSqFjUMSaDSJaj9Jwb+sqvGYg+B7ETzlrryxXHAWQaoUGo
        oR0lySn1Rof6Of8TRqA+PSC/VEyEgjI=
X-Google-Smtp-Source: ABdhPJxAv8NLAGkTg59FY3aLxcVqNtcoJWj9Dd9vAhOtBjufQnxrIDaMn2J+HNxN+TdwAN5N5mOfq/PEVIY=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:34c4:7c1d:f9ba:4576])
 (user=seanjc job=sendgmr) by 2002:a05:6902:6ac:: with SMTP id
 j12mr867837ybt.440.1614301421040; Thu, 25 Feb 2021 17:03:41 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 25 Feb 2021 17:03:27 -0800
In-Reply-To: <20210226010329.1766033-1-seanjc@google.com>
Message-Id: <20210226010329.1766033-4-seanjc@google.com>
Mime-Version: 1.0
References: <20210226010329.1766033-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH 3/5] KVM: x86/mmu: Use 'end' param in TDP MMU's test_age_gfn()
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

Use the @end param when aging a GFN instead of hardcoding the walk to a
single GFN.  Unlike tdp_set_spte(), which simply cannot work with more
than one GFN, aging multiple GFNs would not break, though admittedly it
would be weird.  Be nice to the casual reader and don't make them puzzle
out why the end GFN is unused.

No functional change intended.

Cc: Ben Gardon <bgardon@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 020f2e573f44..9ce8d226b621 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -997,12 +997,12 @@ int kvm_tdp_mmu_age_hva_range(struct kvm *kvm, unsigned long start,
 }
 
 static int test_age_gfn(struct kvm *kvm, struct kvm_memory_slot *slot,
-			struct kvm_mmu_page *root, gfn_t gfn, gfn_t unused,
-			unsigned long unused2)
+			struct kvm_mmu_page *root, gfn_t gfn, gfn_t end,
+			unsigned long unused)
 {
 	struct tdp_iter iter;
 
-	tdp_root_for_each_leaf_pte(iter, root, gfn, gfn + 1)
+	tdp_root_for_each_leaf_pte(iter, root, gfn, end)
 		if (is_accessed_spte(iter.old_spte))
 			return 1;
 
-- 
2.30.1.766.gb4fecdf3b7-goog

