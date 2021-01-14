Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 944432F55A0
	for <lists+kvm@lfdr.de>; Thu, 14 Jan 2021 01:41:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729933AbhANAlA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jan 2021 19:41:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726983AbhANAjT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Jan 2021 19:39:19 -0500
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43360C0617A3
        for <kvm@vger.kernel.org>; Wed, 13 Jan 2021 16:37:40 -0800 (PST)
Received: by mail-qt1-x84a.google.com with SMTP id b24so2953982qtt.22
        for <kvm@vger.kernel.org>; Wed, 13 Jan 2021 16:37:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=wOBP2RkmQVjfNopz2sDe0MTwMLiCidw7C7eIsxIrYII=;
        b=d5HallwW2J+DLmealbbzCxFKbyAzfK0TCDbwfh2qMm5YWuuskaf+J+g2Y1HBZE/+36
         t95u9GZ2O9AVZxH2zRkVsS7VzsiEpdru7b+em49iDS3EWnmJWFv90DQuBcHChZAf75rO
         VP02JzsqqznnSDOTDf0eonMszZ3vXgtU2vVaKV34p+gW5Et1K06G5mJhgBwoOaSNBEJl
         WbKXUOWXGBYjSyCP3bY9d4dFlimPm7F29OLixyGicfnLAl0aReI/0Gvy7tgrK+sDAAFj
         xIRu74vuI2atJgPvKzfBw2xjPcCGE2+1cuWIipDSZDTCcH9/n/vEm9zso27LK6FEu01I
         hFEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=wOBP2RkmQVjfNopz2sDe0MTwMLiCidw7C7eIsxIrYII=;
        b=XSKO8Q1vTpXpxBCg6PNhFQ5Lcdbi1/iSTlXMa+lm4ZF6TvUy3CXE2rR7sl9lHVbotR
         QdKVIAy80j9hEZpy9mJB/AnG2Bj9CafboUHVbUWRSfp/dDTRD11Zy6Y16x4+l1NuIkw2
         Xc+HI9OrXjIWqtdaPu5QbJ6MtyB8jpnKi5uPlRKQgFYXeSZX+4AMaCCdh6bznm6MygBF
         azgCzdiLMidg+vMJ2BGeZJ5/ZJKyeT3vXa76gX979mHs3y8m5ZKuhchmMS/v9lCDsX9R
         f3JSynxFjhtrbi0EWgLCN4x/Sa/TgrYQ+IoY+b1byWPglF5imY5pigYd1Da8Qhwqv/qs
         5YMw==
X-Gm-Message-State: AOAM530Cd+GcpjRiUmMeQSl664kKdn7red9oWw4IyXR/0UfTW+RE5NzF
        FptWvh6PvPLgaYxcRsR1ueAJBUBmBUc=
X-Google-Smtp-Source: ABdhPJzroYZoNQxP6r2XJyTfpLb/UvCXqjUCC3lNQ7J4R0aAzyCK6+Qeih/+mF1Mqy1YwLwmgknKdkcu0kk=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
 (user=seanjc job=sendgmr) by 2002:a05:6214:58d:: with SMTP id
 bx13mr4647837qvb.61.1610584659417; Wed, 13 Jan 2021 16:37:39 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 13 Jan 2021 16:36:56 -0800
In-Reply-To: <20210114003708.3798992-1-seanjc@google.com>
Message-Id: <20210114003708.3798992-3-seanjc@google.com>
Mime-Version: 1.0
References: <20210114003708.3798992-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.0.284.gd98b1dd5eaa7-goog
Subject: [PATCH v2 02/14] KVM: SVM: Free sev_asid_bitmap during init if SEV
 setup fails
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Free sev_asid_bitmap if the reclaim bitmap allocation fails, othwerise
KVM will unnecessarily keep the bitmap when SEV is not fully enabled.

Freeing the page is also necessary to avoid introducing a bug when a
future patch eliminates svm_sev_enabled() in favor of using the global
'sev' flag directly.  While sev_hardware_enabled() checks max_sev_asid,
which is true even if KVM setup fails, 'sev' will be true if and only
if KVM setup fully succeeds.

Fixes: 33af3a7ef9e6 ("KVM: SVM: Reduce WBINVD/DF_FLUSH invocations")
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/sev.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index c8ffdbc81709..0eeb6e1b803d 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1274,8 +1274,10 @@ void __init sev_hardware_setup(void)
 		goto out;
 
 	sev_reclaim_asid_bitmap = bitmap_zalloc(max_sev_asid, GFP_KERNEL);
-	if (!sev_reclaim_asid_bitmap)
+	if (!sev_reclaim_asid_bitmap) {
+		bitmap_free(sev_asid_bitmap);
 		goto out;
+	}
 
 	pr_info("SEV supported: %u ASIDs\n", max_sev_asid - min_sev_asid + 1);
 	sev_supported = true;
-- 
2.30.0.284.gd98b1dd5eaa7-goog

