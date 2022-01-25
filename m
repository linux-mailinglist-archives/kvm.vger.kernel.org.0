Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B32B49B11B
	for <lists+kvm@lfdr.de>; Tue, 25 Jan 2022 11:04:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238732AbiAYKCe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jan 2022 05:02:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238382AbiAYJ7Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jan 2022 04:59:25 -0500
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC4C2C061401;
        Tue, 25 Jan 2022 01:59:22 -0800 (PST)
Received: by mail-pj1-x1043.google.com with SMTP id d5so17022438pjk.5;
        Tue, 25 Jan 2022 01:59:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zds+6NGj4r5Cgf49TNd0ICEUzlDMHJlb5d/51ngIGcY=;
        b=FPq9Vcjqt0nTW+XIHcP+SFASqW+hp1tbi/NDSAy5DGJNynrClbaVord3oKGHXwgk0e
         y1yov5feI2dwoI5FcjI0YIXpZJhLWRyf2vT1R/KvWLhNaNk6FHVAMofkk/UxEbwAw6fh
         r5IsdNml1hDxTvdyJ+Iv4Yf6Wcjud8kQ4DEwdXWtsxrumZKgzFwgbSv4Gi+7Zk8KA7kV
         3YrhRRtt98L2nrt4AYjLwG1MyTex+0YqaVtOCkAG0xVNwORhZDrIgP2A61Ysd3fVO72Q
         Xww2Jf2mMfK+6gXVbmOopE3KHM0UpPP9j8cAU2QzgPtekl0fFrH3KWw5GsnEuf7YMI9+
         UrqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zds+6NGj4r5Cgf49TNd0ICEUzlDMHJlb5d/51ngIGcY=;
        b=p5jAt7ihPfBADiJyFsdF/7R2IARyniBlBEcSjKHzbaqWsQk40vGa+u957/7lN4MV5l
         yyRkwhYSdFbY612CbX1aHb0NCIeTXkJnDGiNoY2f2vWktIyxj5T+mvMElIHt7F09dFif
         j0uuwxYoLOJs1LfK7kRKRhNaa9EGa2AEppXS1+UrPV8C4C9ZV1efucGSNWckwdW534ir
         vYJGfiNIlaAfSU1xkxfLYQg4oNW5NgvdGXigsMCDR4F9RBgIU7hXQ53nnZngPZhbxVtW
         RscCGBJQtRz5bdFTZI2EnzrscORp8Rb+RoJhvhTDfDTaoUYC8vpzgGiemt2AHMc/LjJT
         cY4Q==
X-Gm-Message-State: AOAM531jlWWrGM6gKODj+MulQ6e3LI2m7t7TB2H+Sv3+YEK7ZtZW3Y2A
        FE1qmkywuIFU3tncXLLdJ/A=
X-Google-Smtp-Source: ABdhPJyJ/kfuWDn6T2bse0t/3zBL2P2KyOlJhtUHjbpznQcxoh4DcmAlrs6pIXWssTrGtABK9yzabA==
X-Received: by 2002:a17:903:24d:b0:149:b68f:579 with SMTP id j13-20020a170903024d00b00149b68f0579mr18675922plh.1.1643104762396;
        Tue, 25 Jan 2022 01:59:22 -0800 (PST)
Received: from CLOUDLIANG-MB0.tencent.com ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id mq3sm201606pjb.4.2022.01.25.01.59.20
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Jan 2022 01:59:22 -0800 (PST)
From:   Jinrong Liang <ljr.kernel@gmail.com>
X-Google-Original-From: Jinrong Liang <cloudliang@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Xianting Tian <xianting.tian@linux.alibaba.com>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 02/19] KVM: x86/mmu: Remove unused "kvm" of __rmap_write_protect()
Date:   Tue, 25 Jan 2022 17:58:52 +0800
Message-Id: <20220125095909.38122-3-cloudliang@tencent.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
In-Reply-To: <20220125095909.38122-1-cloudliang@tencent.com>
References: <20220125095909.38122-1-cloudliang@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jinrong Liang <cloudliang@tencent.com>

The "struct kvm *kvm" parameter of __rmap_write_protect()
is not used, so remove it. No functional change intended.

Signed-off-by: Jinrong Liang <cloudliang@tencent.com>
---
 arch/x86/kvm/mmu/mmu.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 305aa0c5026f..bb9791564ca9 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1229,8 +1229,7 @@ static bool spte_write_protect(u64 *sptep, bool pt_protect)
 	return mmu_spte_update(sptep, spte);
 }
 
-static bool __rmap_write_protect(struct kvm *kvm,
-				 struct kvm_rmap_head *rmap_head,
+static bool __rmap_write_protect(struct kvm_rmap_head *rmap_head,
 				 bool pt_protect)
 {
 	u64 *sptep;
@@ -1311,7 +1310,7 @@ static void kvm_mmu_write_protect_pt_masked(struct kvm *kvm,
 	while (mask) {
 		rmap_head = gfn_to_rmap(slot->base_gfn + gfn_offset + __ffs(mask),
 					PG_LEVEL_4K, slot);
-		__rmap_write_protect(kvm, rmap_head, false);
+		__rmap_write_protect(rmap_head, false);
 
 		/* clear the first set bit */
 		mask &= mask - 1;
@@ -1410,7 +1409,7 @@ bool kvm_mmu_slot_gfn_write_protect(struct kvm *kvm,
 	if (kvm_memslots_have_rmaps(kvm)) {
 		for (i = min_level; i <= KVM_MAX_HUGEPAGE_LEVEL; ++i) {
 			rmap_head = gfn_to_rmap(gfn, i, slot);
-			write_protected |= __rmap_write_protect(kvm, rmap_head, true);
+			write_protected |= __rmap_write_protect(rmap_head, true);
 		}
 	}
 
@@ -5802,7 +5801,7 @@ static bool slot_rmap_write_protect(struct kvm *kvm,
 				    struct kvm_rmap_head *rmap_head,
 				    const struct kvm_memory_slot *slot)
 {
-	return __rmap_write_protect(kvm, rmap_head, false);
+	return __rmap_write_protect(rmap_head, false);
 }
 
 void kvm_mmu_slot_remove_write_access(struct kvm *kvm,
-- 
2.33.1

