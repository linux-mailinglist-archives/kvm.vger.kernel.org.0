Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 739F1410271
	for <lists+kvm@lfdr.de>; Sat, 18 Sep 2021 02:56:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240776AbhIRA6D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Sep 2021 20:58:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239732AbhIRA6C (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Sep 2021 20:58:02 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED0A7C061574;
        Fri, 17 Sep 2021 17:56:39 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id c1so7803594pfp.10;
        Fri, 17 Sep 2021 17:56:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=a6PYG+m/xoIoPiMToxE/tL9ihqq7/KCP6ZvYVM4ScbM=;
        b=Id5nrQDA9hbBo1pTm7dyu3rzF/UaBwZN4f08xl7BEFnELljpNcXOjr1gaGFvgbjf8M
         tBpuzWgfQSWCexBTPWT7QDrKcUAknEARhdyzat3Vb8lCdukJtUFsO4SzigrSSAE1vdaD
         /3F850MjiYPSE2kj0hKrpeZCCemsa6064j9zZc9PCb0Qhc2g+3DprBa2driccPairPya
         gkK5/o1uhZcwINhcfUieXWPipuS+bn2WJwJSstpSMhxU4Ti4Nzr9D1nsv9jY7vnqbT7K
         QHsYeFro+vwdRN1Eyc1LMWnk/kpOA1VK3UAsPUNFiCTBft7dJm7oAS+FSJoJKxubNWGx
         9G3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=a6PYG+m/xoIoPiMToxE/tL9ihqq7/KCP6ZvYVM4ScbM=;
        b=HUTeE4QXf4eGdyAm+7J4gH6fHUORhNTDvCB/Om6LANOfIFWeC9B5XzXaxLuS5/Bc6s
         QYjqbSzOBtZJW6N9dZIxTgNvI4dmhGKQfped84vdgZsbAkDZN5NKNTzMgigJgM13Sl/4
         6/evGH4wuNfWTBnqExdKgUx4ehkyiFeyq/cpk+1y0atRx1uCeIWogO37MIvUKY3IImWu
         DnKQFMUORPI1Me4YwIMvp9IQfnLVOE4t1DN5Kyu9VK8EDDOva+CW8lNxHxHD29/1IWvW
         2/MqdDboreaTnCFYvrC1dZ7Od1oY9fZ16WDSPSUFBp3d24Kyvg5nxEUZG+0nUmfHpL7E
         y1Tg==
X-Gm-Message-State: AOAM532C3Q7ytbY2dWfKSwEkQcBr3AYENluKWPbeQP7YEUBuoDPisL/h
        /YTH/3CGble/A68fcy5zcASMO25jamw=
X-Google-Smtp-Source: ABdhPJyi8fJXwyTUVRT7Hto96wu/kHTmSfokskyY0wwfMbqexfa1cRYzmSyppYoELdMkKJqHyRBsUQ==
X-Received: by 2002:a63:185b:: with SMTP id 27mr12394199pgy.0.1631926599350;
        Fri, 17 Sep 2021 17:56:39 -0700 (PDT)
Received: from localhost ([47.251.4.198])
        by smtp.gmail.com with ESMTPSA id e11sm6809246pfv.201.2021.09.17.17.56.38
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 17 Sep 2021 17:56:39 -0700 (PDT)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     Lai Jiangshan <laijs@linux.alibaba.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org
Subject: [PATCH V2 01/10] KVM: X86: Fix missed remote tlb flush in rmap_write_protect()
Date:   Sat, 18 Sep 2021 08:56:27 +0800
Message-Id: <20210918005636.3675-2-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20210918005636.3675-1-jiangshanlai@gmail.com>
References: <20210918005636.3675-1-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <laijs@linux.alibaba.com>

When kvm->tlbs_dirty > 0, some rmaps might have been deleted
without flushing tlb remotely after kvm_sync_page().  If @gfn
was writable before and it's rmaps was deleted in kvm_sync_page(),
and if the tlb entry is still in a remote running VCPU,  the @gfn
is not safely protected.

To fix the problem, kvm_sync_page() does the remote flush when
needed to avoid the problem.

Fixes: a4ee1ca4a36e ("KVM: MMU: delay flush all tlbs on sync_page path")
Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
---
Changed from V1:
	force remote flush timely instead of increasing tlbs_dirty.

 arch/x86/kvm/mmu/paging_tmpl.h | 23 ++---------------------
 1 file changed, 2 insertions(+), 21 deletions(-)

diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 72f358613786..5962d4f8a72e 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -1038,14 +1038,6 @@ static gpa_t FNAME(gva_to_gpa_nested)(struct kvm_vcpu *vcpu, gpa_t vaddr,
  * Using the cached information from sp->gfns is safe because:
  * - The spte has a reference to the struct page, so the pfn for a given gfn
  *   can't change unless all sptes pointing to it are nuked first.
- *
- * Note:
- *   We should flush all tlbs if spte is dropped even though guest is
- *   responsible for it. Since if we don't, kvm_mmu_notifier_invalidate_page
- *   and kvm_mmu_notifier_invalidate_range_start detect the mapping page isn't
- *   used by guest then tlbs are not flushed, so guest is allowed to access the
- *   freed pages.
- *   And we increase kvm->tlbs_dirty to delay tlbs flush in this case.
  */
 static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 {
@@ -1098,13 +1090,7 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 			return 0;
 
 		if (FNAME(prefetch_invalid_gpte)(vcpu, sp, &sp->spt[i], gpte)) {
-			/*
-			 * Update spte before increasing tlbs_dirty to make
-			 * sure no tlb flush is lost after spte is zapped; see
-			 * the comments in kvm_flush_remote_tlbs().
-			 */
-			smp_wmb();
-			vcpu->kvm->tlbs_dirty++;
+			set_spte_ret |= SET_SPTE_NEED_REMOTE_TLB_FLUSH;
 			continue;
 		}
 
@@ -1119,12 +1105,7 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 
 		if (gfn != sp->gfns[i]) {
 			drop_spte(vcpu->kvm, &sp->spt[i]);
-			/*
-			 * The same as above where we are doing
-			 * prefetch_invalid_gpte().
-			 */
-			smp_wmb();
-			vcpu->kvm->tlbs_dirty++;
+			set_spte_ret |= SET_SPTE_NEED_REMOTE_TLB_FLUSH;
 			continue;
 		}
 
-- 
2.19.1.6.gb485710b

