Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D496932DEE5
	for <lists+kvm@lfdr.de>; Fri,  5 Mar 2021 02:12:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230416AbhCEBLj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Mar 2021 20:11:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230155AbhCEBL1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Mar 2021 20:11:27 -0500
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C2BFC061765
        for <kvm@vger.kernel.org>; Thu,  4 Mar 2021 17:11:25 -0800 (PST)
Received: by mail-qt1-x849.google.com with SMTP id t5so279700qti.5
        for <kvm@vger.kernel.org>; Thu, 04 Mar 2021 17:11:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=SZwHUSvDdXIjOwL6DYqZk6MGlJKECDbIyHyFjVNd5DY=;
        b=XbErS6UpsKnvave61IB3C2uZlgtOfq/eJ41z1RORqSUIwc79t99F0vpyCi0Im3xIcp
         64KWQePLR7YCrmhbdti2+XQIH44YQMm7O5eV+mtp3rR8Gv9PIr1AzvspMx1GAHxxDVR+
         pdbJma85yk71m29tUTY7C4srHm9U/r/PbrKEsgjXAoVsxjkyESpiewkSOjWRZVnrF3dF
         FlAGxRQEgKKVQ3d7sRvituaJXCdzYeq2wIJAuknuo013TkAjVxq1r7vhxD/UarFMW7w3
         +375dR5e8TTa1MSXrCOwLe+mAAsMfnEraJ4WRL9ZELZHzHlPdBsrl6aCXnLv3R53TvWQ
         uVtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=SZwHUSvDdXIjOwL6DYqZk6MGlJKECDbIyHyFjVNd5DY=;
        b=YTjeWaIRs9dcXlcmmqZcgCMKmfCaCLOun/WrkBdR/l5Wq3NAuXZzmMFrdPiohsZRmV
         GrCbvR+4XzR4MVkFD+hXTVPRyDGZBHYIe3WO/uFdpF7CDUJOLT+iRzBS/Nx+pbkEL23d
         +LjgWw3MB5KqoibljUty9f+CWDpVrqjaoQ7MSOFbO0kaiPUsC4OyPSyEI3p38FbiL9zI
         alXup52meD1s9JiAkGR3TsXYSoVDCSKhVzAjFi0TFyLiRmfZA3P+Nb10HVfuAjUBjQW7
         7/+QhwirAV/R4KgnnKe9rzhu5Ub6wdwxtAF0XaS4rWK+u2DyhAPY0TliXKR2vxLpeALJ
         iiTA==
X-Gm-Message-State: AOAM532zSjaaFfPTmpXTFgQc0dROiAtb/7zdNx253h1s/ox9Mta+FdH1
        XZNRkZYSUkWhjA2eS0pnHwe+umC+bAo=
X-Google-Smtp-Source: ABdhPJwzbr84Spc6kUFtsp2d0ycR+uQPDfjyLmxkIwxSgviJq5GyStPAn18I3GkNfErIdMu0vHCYrdFOKY8=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:9857:be95:97a2:e91c])
 (user=seanjc job=sendgmr) by 2002:a0c:b59f:: with SMTP id g31mr6709578qve.28.1614906684731;
 Thu, 04 Mar 2021 17:11:24 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu,  4 Mar 2021 17:10:52 -0800
In-Reply-To: <20210305011101.3597423-1-seanjc@google.com>
Message-Id: <20210305011101.3597423-9-seanjc@google.com>
Mime-Version: 1.0
References: <20210305011101.3597423-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH v2 08/17] KVM: x86/mmu: Fix and unconditionally enable WARNs
 to detect PAE leaks
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
 arch/x86/kvm/mmu/mmu.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 9fc2b46f8541..b82c1b0d6d6e 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3250,7 +3250,8 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
 		mmu->root_hpa = root;
 	} else if (shadow_root_level == PT32E_ROOT_LEVEL) {
 		for (i = 0; i < 4; ++i) {
-			MMU_WARN_ON(VALID_PAGE(mmu->pae_root[i]));
+			WARN_ON_ONCE(mmu->pae_root[i] &&
+				     VALID_PAGE(mmu->pae_root[i]));
 
 			root = mmu_alloc_root(vcpu, i << (30 - PAGE_SHIFT),
 					      i << 30, PT32_ROOT_LEVEL, true);
@@ -3296,8 +3297,6 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 	 * write-protect the guests page table root.
 	 */
 	if (mmu->root_level >= PT64_ROOT_4LEVEL) {
-		MMU_WARN_ON(VALID_PAGE(mmu->root_hpa));
-
 		root = mmu_alloc_root(vcpu, root_gfn, 0,
 				      mmu->shadow_root_level, false);
 		mmu->root_hpa = root;
@@ -3317,7 +3316,7 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 	}
 
 	for (i = 0; i < 4; ++i) {
-		MMU_WARN_ON(VALID_PAGE(mmu->pae_root[i]));
+		WARN_ON_ONCE(mmu->pae_root[i] && VALID_PAGE(mmu->pae_root[i]));
 
 		if (mmu->root_level == PT32E_ROOT_LEVEL) {
 			if (!(pdptrs[i] & PT_PRESENT_MASK)) {
-- 
2.30.1.766.gb4fecdf3b7-goog

