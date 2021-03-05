Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3069B32DEE4
	for <lists+kvm@lfdr.de>; Fri,  5 Mar 2021 02:12:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230406AbhCEBLi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Mar 2021 20:11:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230107AbhCEBL2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Mar 2021 20:11:28 -0500
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDA4AC0613D7
        for <kvm@vger.kernel.org>; Thu,  4 Mar 2021 17:11:27 -0800 (PST)
Received: by mail-qt1-x849.google.com with SMTP id h13so250357qti.21
        for <kvm@vger.kernel.org>; Thu, 04 Mar 2021 17:11:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=70+pbfsr9FN7xUzI6QuNzJ56yN8wNBmmQK3zMq55CLc=;
        b=pmvh31yoJyb4qrUv2ew3hjgo7ixYIuYizEYdNw1S8Gq+ecXPDzJKFHb3LM+e/2mqlG
         fSdsnhAOdSBYIPi4Yn9DL7cP7LY+onbUmEF6zZ2YIQba5+ujrgJc2v0BCLWm6SwvtX9m
         pkB/+anEXQ8lTyWLQ6E3g+cS4mTKDg+RYpwSnWSciyGNxDOeKaoU0RjNRc+d06+gT1b3
         1FxItGOw2GqdRP4E4UcBo0GbAbvV4Y0psgkuzUalH67kDa0N08Y/ZgiEem2gbWboUZBr
         AdGwoXl3tVta/PsBOVFM/z/pfBU6r8PAXyUbeMVY8rNmrNrF9Z/EW8BL/MT9Sv4o9WyC
         8ZZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=70+pbfsr9FN7xUzI6QuNzJ56yN8wNBmmQK3zMq55CLc=;
        b=f1iRbA5xORgT+oAI+W+ShcHAwetbl/MfCMwlwLbodM/71UA0/AEsWwUr/aa1E/7cs1
         4VR2gQAJYB3nw9Dj27B7u+uQe3qlYTkWZvj2dNT9FXyJM5OBlWv/pBRmlYGcxTLj5W8C
         vdDsA1K/j3hOi+J4UVFpsH5u4Rhih4hjBZvP5fFkhBZiHLY/TT5acM1E6+KrxBFt0qUB
         h71wHY8e27mSFWt+7Fnv0sD9mCrwVzPP778UVbmcDWqy9IIy7P21JDwACKlcO85ixfRS
         Q3PHhAIbhlwfCM2qbsz7KzAGUi+NEEr6bOWJzJ7AduJ7cgSdxKG12rGQVjj70HIBOKpt
         ALzA==
X-Gm-Message-State: AOAM531v85qwQ1UORLkkrur2QFjUbwAjfi+c1d/bETS96RYs2JuHvRNK
        AdYSobaJK4AzkVHeovpVmt+EboyYRPU=
X-Google-Smtp-Source: ABdhPJw0wUHUyLIyV84zNUK5PAtf+fBteAA09FyMWMOjiUWzcaumAVi1oNZhRU3hAx+V+kxeA4J903pJaRo=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:9857:be95:97a2:e91c])
 (user=seanjc job=sendgmr) by 2002:a0c:ef11:: with SMTP id t17mr6672405qvr.21.1614906687093;
 Thu, 04 Mar 2021 17:11:27 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu,  4 Mar 2021 17:10:53 -0800
In-Reply-To: <20210305011101.3597423-1-seanjc@google.com>
Message-Id: <20210305011101.3597423-10-seanjc@google.com>
Mime-Version: 1.0
References: <20210305011101.3597423-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH v2 09/17] KVM: x86/mmu: Use '0' as the one and only value for
 an invalid PAE root
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

Use '0' to denote an invalid pae_root instead of '0' or INVALID_PAGE.
Unlike root_hpa, the pae_roots hold permission bits and thus are
guaranteed to be non-zero.  Having to deal with both values leads to
bugs, e.g. failing to set back to INVALID_PAGE, warning on the wrong
value, etc...

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index b82c1b0d6d6e..dbf7f0395e4b 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3197,11 +3197,14 @@ void kvm_mmu_free_roots(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 		    (mmu->root_level >= PT64_ROOT_4LEVEL || mmu->direct_map)) {
 			mmu_free_root_page(kvm, &mmu->root_hpa, &invalid_list);
 		} else if (mmu->pae_root) {
-			for (i = 0; i < 4; ++i)
-				if (mmu->pae_root[i] != 0)
-					mmu_free_root_page(kvm,
-							   &mmu->pae_root[i],
-							   &invalid_list);
+			for (i = 0; i < 4; ++i) {
+				if (!mmu->pae_root[i])
+					continue;
+
+				mmu_free_root_page(kvm, &mmu->pae_root[i],
+						   &invalid_list);
+				mmu->pae_root[i] = 0;
+			}
 		}
 		mmu->root_hpa = INVALID_PAGE;
 		mmu->root_pgd = 0;
@@ -3250,8 +3253,7 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
 		mmu->root_hpa = root;
 	} else if (shadow_root_level == PT32E_ROOT_LEVEL) {
 		for (i = 0; i < 4; ++i) {
-			WARN_ON_ONCE(mmu->pae_root[i] &&
-				     VALID_PAGE(mmu->pae_root[i]));
+			WARN_ON_ONCE(mmu->pae_root[i]);
 
 			root = mmu_alloc_root(vcpu, i << (30 - PAGE_SHIFT),
 					      i << 30, PT32_ROOT_LEVEL, true);
@@ -3316,7 +3318,7 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 	}
 
 	for (i = 0; i < 4; ++i) {
-		WARN_ON_ONCE(mmu->pae_root[i] && VALID_PAGE(mmu->pae_root[i]));
+		WARN_ON_ONCE(mmu->pae_root[i]);
 
 		if (mmu->root_level == PT32E_ROOT_LEVEL) {
 			if (!(pdptrs[i] & PT_PRESENT_MASK)) {
@@ -3438,7 +3440,7 @@ void kvm_mmu_sync_roots(struct kvm_vcpu *vcpu)
 	for (i = 0; i < 4; ++i) {
 		hpa_t root = vcpu->arch.mmu->pae_root[i];
 
-		if (root && VALID_PAGE(root)) {
+		if (root && !WARN_ON_ONCE(!VALID_PAGE(root))) {
 			root &= PT64_BASE_ADDR_MASK;
 			sp = to_shadow_page(root);
 			mmu_sync_children(vcpu, sp);
@@ -5296,7 +5298,7 @@ static int __kvm_mmu_create(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu)
 
 	mmu->pae_root = page_address(page);
 	for (i = 0; i < 4; ++i)
-		mmu->pae_root[i] = INVALID_PAGE;
+		mmu->pae_root[i] = 0;
 
 	return 0;
 }
-- 
2.30.1.766.gb4fecdf3b7-goog

