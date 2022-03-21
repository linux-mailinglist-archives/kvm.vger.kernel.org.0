Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A16884E32DF
	for <lists+kvm@lfdr.de>; Mon, 21 Mar 2022 23:48:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230105AbiCUWta (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Mar 2022 18:49:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229758AbiCUWtY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Mar 2022 18:49:24 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A76A36E3E
        for <kvm@vger.kernel.org>; Mon, 21 Mar 2022 15:44:09 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id c6-20020a621c06000000b004fa7307e2e0so5835258pfc.6
        for <kvm@vger.kernel.org>; Mon, 21 Mar 2022 15:44:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=JAqLlS07OA/mtsxC0lr2Zf5cFpfFqBoRXPdNY1Wgz24=;
        b=H0R79d5UcBxs6D8qTK2NTVn6tY35vwRgidZ9zKMSXB6AwWAv393rNwo+bk6Kobd6Z5
         oRZV28Nt+t3/pMmVONdGgSbhQmFKF1O3YFr49wCsjKjt3jqNXClIKbn9rtYDAStiWYH6
         en2bFzaGUklc2rPx+LnmFK/I+5qR7NPW22uRZsApafZ+drfZt9UVbr3bEMAMmoJ9QqCn
         SZs6gzWXmc96NYNWk8Sv6UWauWLr2i3zc3RvA7a8yfzvlWypGS0q3PYA7Sbv+VlXeili
         7btitqt8zcL1ZY35A8yPxwCp7++B/0K0l/LqF4PrZ4n2PiPCxyKXVW0fo8OkJefTS/zt
         qPUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=JAqLlS07OA/mtsxC0lr2Zf5cFpfFqBoRXPdNY1Wgz24=;
        b=kBurMRDm1jT8Y6iQlITiEKLUnermn1hB/8Zb+Bb6dpeqJQwyfCV+ouWxkvUzHYjOXc
         5Ze0aQ4IHTegwkDdrXGIADV32jME0ljXFmve4DxQTiaKCKoBeX07IGB8yQeikNsXEUQu
         gFRxWcNeQFQGhjXSWWRcl4WTfrGFz7KUr2eM6mHUi42SgTu2WOrTQU/NgyGB5NKH3/J0
         F9jEmqtr0Cc7Z86P/WRn2FF987xbubXRvQMXO5VMKnJIAqxGUS5QAWNbjN0BdrE8IXxh
         HBlIkQdxcaq/DiE0WAFRnEKudAR/Fp9/tb4rfBMR3pSYJwQRCt1NdibGS6BO8Fo2A6f9
         /NKw==
X-Gm-Message-State: AOAM530ZzSusmSZaZRpFQuBjxC8q8yV6GM+7P6cRUy15IhuIQZOfFM1q
        vKFtyeJF+jb1zsEqO0yzVSpYISkO0y8U
X-Google-Smtp-Source: ABdhPJxAtqyFX+JDYmmYwf3rvEhv5BiLfQfw2OU879/OP5hly2ytp4JfLR+hS/L7jvzneV2Wb/vLVdfuP+fm
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:b76a:f152:cb5e:5cd2])
 (user=bgardon job=sendgmr) by 2002:a17:903:2348:b0:154:dd0:aba8 with SMTP id
 c8-20020a170903234800b001540dd0aba8mr15543475plh.51.1647902649014; Mon, 21
 Mar 2022 15:44:09 -0700 (PDT)
Date:   Mon, 21 Mar 2022 15:43:52 -0700
In-Reply-To: <20220321224358.1305530-1-bgardon@google.com>
Message-Id: <20220321224358.1305530-4-bgardon@google.com>
Mime-Version: 1.0
References: <20220321224358.1305530-1-bgardon@google.com>
X-Mailer: git-send-email 2.35.1.894.gb6a874cedc-goog
Subject: [PATCH v2 3/9] KVM: x86/mmu: Factor shadow_zero_check out of __make_spte
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Dunn <daviddunn@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Junaid Shahid <junaids@google.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In the interest of devloping a version of __make_spte that can function
without a vCPU pointer, factor out the shadow_zero_mask to be an
additional argument to the function.

No functional change intended.

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu/spte.c | 10 ++++++----
 arch/x86/kvm/mmu/spte.h |  2 +-
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index 931cf93c3b7e..ef2d85577abb 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -94,7 +94,7 @@ bool __make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 		 const struct kvm_memory_slot *slot, unsigned int pte_access,
 		 gfn_t gfn, kvm_pfn_t pfn, u64 old_spte, bool prefetch,
 		 bool can_unsync, bool host_writable, u64 mt_mask,
-		 u64 *new_spte)
+		 struct rsvd_bits_validate *shadow_zero_check, u64 *new_spte)
 {
 	int level = sp->role.level;
 	u64 spte = SPTE_MMU_PRESENT_MASK;
@@ -177,9 +177,9 @@ bool __make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	if (prefetch)
 		spte = mark_spte_for_access_track(spte);
 
-	WARN_ONCE(is_rsvd_spte(&vcpu->arch.mmu->shadow_zero_check, spte, level),
+	WARN_ONCE(is_rsvd_spte(shadow_zero_check, spte, level),
 		  "spte = 0x%llx, level = %d, rsvd bits = 0x%llx", spte, level,
-		  get_rsvd_bits(&vcpu->arch.mmu->shadow_zero_check, spte, level));
+		  get_rsvd_bits(shadow_zero_check, spte, level));
 
 	if ((spte & PT_WRITABLE_MASK) && kvm_slot_dirty_track_enabled(slot)) {
 		/* Enforced by kvm_mmu_hugepage_adjust. */
@@ -199,10 +199,12 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 {
 	u64 mt_mask = static_call(kvm_x86_get_mt_mask)(vcpu, gfn,
 						       kvm_is_mmio_pfn(pfn));
+	struct rsvd_bits_validate *shadow_zero_check =
+			&vcpu->arch.mmu->shadow_zero_check;
 
 	return __make_spte(vcpu, sp, slot, pte_access, gfn, pfn, old_spte,
 			   prefetch, can_unsync, host_writable, mt_mask,
-			   new_spte);
+			   shadow_zero_check, new_spte);
 
 }
 
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index d051f955699e..e8a051188eb6 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -414,7 +414,7 @@ bool __make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 		 const struct kvm_memory_slot *slot, unsigned int pte_access,
 		 gfn_t gfn, kvm_pfn_t pfn, u64 old_spte, bool prefetch,
 		 bool can_unsync, bool host_writable, u64 mt_mask,
-		 u64 *new_spte);
+		 struct rsvd_bits_validate *shadow_zero_check, u64 *new_spte);
 bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	       const struct kvm_memory_slot *slot,
 	       unsigned int pte_access, gfn_t gfn, kvm_pfn_t pfn,
-- 
2.35.1.894.gb6a874cedc-goog

