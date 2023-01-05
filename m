Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B73765E86F
	for <lists+kvm@lfdr.de>; Thu,  5 Jan 2023 10:58:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232262AbjAEJ6A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Jan 2023 04:58:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232218AbjAEJ5x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Jan 2023 04:57:53 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF6654FD5D;
        Thu,  5 Jan 2023 01:57:52 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id cl14so2857280pjb.2;
        Thu, 05 Jan 2023 01:57:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jT6Gs3/9dHAVjZQVK0HTl12Ujux2L3UISr1bIxfWhlY=;
        b=BlhGxnSZaa8CbZNSOY077fMOr3vU/JlTd28fPoqQj9JZmRt3puXfRNIZXhOxRH2JcZ
         YTdDaE24l8kMb9hn2EzWVBdlJK8ZO+aHEIBFMTWSHBr7DcG9gwPTLRH65ufew25kDePe
         X/Uv3KnWn+s29Hk5fXRY4QIVNN7YaeMDjyuwv32+n3Iv6FG/IeRP3WlGK/t/15qYGt+D
         RWpJizzaziusak5833EXUTu0EGe4Q3QTH/v+xsKWYlAHIRkVO5l7mCaZof1w4UGYHnTL
         3lRDVGrSv85xLj9ulzcSOwpcv4+RwCn89kyfO3KtuL9hYotQS2QoNZkLg7laCi5PpDcb
         gFGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jT6Gs3/9dHAVjZQVK0HTl12Ujux2L3UISr1bIxfWhlY=;
        b=mmDYfAvVTju+73skrpv7W+Pww1fik9/AkHnruUywFxOfEmUTjkIyEbMHVjteiC9m42
         peId98uBB/yWJ48gOe+qmiwrwe83oggKypA306dF1+tHmW/8gsbtn+8wSq+C0IslTIL7
         rR31UBUEfTqyw0XeIWkbBFTBBcCxCQ+cSV72PxU0I8CCqOZrSODYeEMhSOlaKtN+XZmg
         CFOKdCmxT7021vPzfEYvge4na40boeyU3q/DA7ABhau1axMCzBiQkqD4nd1ohmdchWP2
         Wr1GAjBsWQnmOjbTd+xzv9xQ8frjqE+5BjfblnxibJPEMXdwk9UvFNjsNyeG3A6zjJWI
         dqew==
X-Gm-Message-State: AFqh2kr4+mUj2n3jjL/yOeDTPBZ0Yml/8oAdBpHMBqBNYGPL6RLH1Zue
        SA5dCXD8sn8EK5T8+wT/494rIdYrFg0=
X-Google-Smtp-Source: AMrXdXsIH3C3UU2l6lxFxaFRZXWzMX7j8nuH2iLVmIRvXHFqd8ADKQ7fqxSoCsfM4MlqRl7fLFZ08g==
X-Received: by 2002:a17:902:ee13:b0:191:3c8:a7bd with SMTP id z19-20020a170902ee1300b0019103c8a7bdmr55989129plb.6.1672912672058;
        Thu, 05 Jan 2023 01:57:52 -0800 (PST)
Received: from localhost ([47.254.32.37])
        by smtp.gmail.com with ESMTPSA id b13-20020a170902650d00b0019300c89011sm693843plk.63.2023.01.05.01.57.51
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Jan 2023 01:57:51 -0800 (PST)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org
Subject: [PATCH 4/7] kvm: x86/mmu: Reduce the update to the spte in FNAME(sync_page)
Date:   Thu,  5 Jan 2023 17:58:45 +0800
Message-Id: <20230105095848.6061-5-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20230105095848.6061-1-jiangshanlai@gmail.com>
References: <20230105095848.6061-1-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <jiangshan.ljs@antgroup.com>

Sometimes when the guest updates its pagetable, it adds only new gptes
to it without changing any existed one, so there is no point to update
the sptes for these existed gptes.

Also when the sptes for these unchanged gptes are updated, the AD
bits are also removed since make_spte() is called with prefetch=true
which might result unneeded TLB flushing.

Do nothing if the permissions are unchanged.

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
---
 arch/x86/kvm/mmu/paging_tmpl.h | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 11f17efbec97..ab0b031d4825 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -985,7 +985,7 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 	for (i = 0; i < SPTE_ENT_PER_PAGE; i++) {
 		u64 *sptep, spte;
 		struct kvm_memory_slot *slot;
-		unsigned pte_access;
+		unsigned old_pte_access, pte_access;
 		pt_element_t gpte;
 		gpa_t pte_gpa;
 		gfn_t gfn;
@@ -1025,6 +1025,12 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 			flush = true;
 			continue;
 		}
+		/*
+		 * Do nothing if the permissions are unchanged.
+		 */
+		old_pte_access = kvm_mmu_page_get_access(sp, i);
+		if (old_pte_access == pte_access)
+			continue;
 
 		/* Update the shadowed access bits in case they changed. */
 		kvm_mmu_page_set_access(sp, i, pte_access);
-- 
2.19.1.6.gb485710b

