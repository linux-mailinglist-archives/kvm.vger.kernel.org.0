Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0C1432B580
	for <lists+kvm@lfdr.de>; Wed,  3 Mar 2021 08:21:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379923AbhCCHR4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Mar 2021 02:17:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381093AbhCBS4f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Mar 2021 13:56:35 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC7C1C061226
        for <kvm@vger.kernel.org>; Tue,  2 Mar 2021 10:46:01 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id v6so23498261ybk.9
        for <kvm@vger.kernel.org>; Tue, 02 Mar 2021 10:46:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=EnZFLski9RQiJKTWgrYgjdNat8xIrKSM9EmpDdRBoag=;
        b=scxjXT29yqaE1bBIE5x4Zgc6F4LOv8EyyWUiNAAv+qDm/hGXjM6o9kg5KhmWRVLUFM
         zhdR8/FEoWylqMQhxxHRXOmgM4H+qgRCyEhB8wDHUUXuiNZCbdlP9I1NtEUqdVkaTeam
         gugwntXjBdNu0JeTdAQsJcohYbSAh+LKkDEEfxFRTv1e3Ptcv+o+csDw8rXsx+ROPOPq
         PsNJl9LbRTh46hey3Z5YBQMwM9I1yUcTUhXsGy/vZXyLm/z6foWh2VFoUYuK3nA681DM
         DTp0zxmhLdpOzkoivjLs9wnh+z7T/CGXbwor9IaPLSpVlgJPeOWYp7nz0Gn2oUSa9Y78
         3gLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=EnZFLski9RQiJKTWgrYgjdNat8xIrKSM9EmpDdRBoag=;
        b=hjdCuqW8v+uxB5/tqgkrq4urEztRvZfrUb9bPb/dzbDkBBWuDp3J2KaDNz+7UhOTfz
         JF0YFEbVrucVyR9Q2PNkSVZr8gsetY1rUl+4ji5FkcsuAb1HFvJ5NE371FpFaZHNgLYL
         a/2PiL5baE5eBu/QT/HQ12+KBBPl0M+lCfiVg3qbaQNqHV3ssaWr9+0M0nNLdevmdD6C
         yZnnGC5uUwwJvG4BtkX98RilmswUd4rPAlv7q1ckYrdPcp1vCbYgjAfIDMyc2n/tT38o
         Q32LVUMOs1I8F0BkGKX+fwVKPGFhEBavzXkjXfiS543OjzXFMx0tcai1PD2Wvum15jjC
         Hjvg==
X-Gm-Message-State: AOAM530lY0U9hFshYojQwhJwcvYnhdHR8AHLUNMEXSYtFPsPUH8uJdLq
        yJP1fQ7SVtLtRTJkHXcCOCNsm6fwXi4=
X-Google-Smtp-Source: ABdhPJwv3m9DetMSaQqbcfD5ZJfQ7ppifSrZOl1LVpPtrJ2Cq+kVO1NCxwUULwBeK8zws6nAxNFtsyNNbBo=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:805d:6324:3372:6183])
 (user=seanjc job=sendgmr) by 2002:a25:e08b:: with SMTP id x133mr32155992ybg.138.1614710761217;
 Tue, 02 Mar 2021 10:46:01 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue,  2 Mar 2021 10:45:31 -0800
In-Reply-To: <20210302184540.2829328-1-seanjc@google.com>
Message-Id: <20210302184540.2829328-7-seanjc@google.com>
Mime-Version: 1.0
References: <20210302184540.2829328-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH 06/15] KVM: x86/mmu: Fix and unconditionally enable WARNs to
 detect PAE leaks
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Exempt NULL PAE roots from the check to detect leaks, since
kvm_mmu_free_roots() doesn't set them back to INVALID_PAGE.  Stop hiding
the WARNs to detect PAE root leaks behind MMU_WARN_ON, the hidden WARNs
obviously didn't do their job given the hilarious number of bugs that
could lead to PAE roots being leaked, not to mention the above false
positive.

Opportunistically delete a warning on root_hpa being valid, there's
nothing special about 4/5-level shadow pages that warrants a WARN.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index aa20e8d32197..3ef7fb2a9878 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3244,7 +3244,8 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
 		vcpu->arch.mmu->root_hpa = root;
 	} else if (shadow_root_level == PT32E_ROOT_LEVEL) {
 		for (i = 0; i < 4; ++i) {
-			MMU_WARN_ON(VALID_PAGE(vcpu->arch.mmu->pae_root[i]));
+			WARN_ON_ONCE(vcpu->arch.mmu->pae_root[i] &&
+				     VALID_PAGE(vcpu->arch.mmu->pae_root[i]));
 
 			root = mmu_alloc_root(vcpu, i << (30 - PAGE_SHIFT),
 					      i << 30, PT32_ROOT_LEVEL, true);
@@ -3289,8 +3290,6 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 	 * write-protect the guests page table root.
 	 */
 	if (vcpu->arch.mmu->root_level >= PT64_ROOT_4LEVEL) {
-		MMU_WARN_ON(VALID_PAGE(vcpu->arch.mmu->root_hpa));
-
 		root = mmu_alloc_root(vcpu, root_gfn, 0,
 				      vcpu->arch.mmu->shadow_root_level, false);
 		vcpu->arch.mmu->root_hpa = root;
@@ -3339,7 +3338,8 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 	}
 
 	for (i = 0; i < 4; ++i) {
-		MMU_WARN_ON(VALID_PAGE(vcpu->arch.mmu->pae_root[i]));
+		WARN_ON_ONCE(vcpu->arch.mmu->pae_root[i] &&
+			     VALID_PAGE(vcpu->arch.mmu->pae_root[i]));
 
 		if (vcpu->arch.mmu->root_level == PT32E_ROOT_LEVEL) {
 			if (!(pdptrs[i] & PT_PRESENT_MASK)) {
-- 
2.30.1.766.gb4fecdf3b7-goog

