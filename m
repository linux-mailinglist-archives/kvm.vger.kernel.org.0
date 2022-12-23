Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9C8F6549E8
	for <lists+kvm@lfdr.de>; Fri, 23 Dec 2022 01:57:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231278AbiLWA5x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Dec 2022 19:57:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230076AbiLWA5u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Dec 2022 19:57:50 -0500
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D4EC2188A
        for <kvm@vger.kernel.org>; Thu, 22 Dec 2022 16:57:49 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-43ea89bc5d8so36595537b3.4
        for <kvm@vger.kernel.org>; Thu, 22 Dec 2022 16:57:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=BIUstVDoT6s4wHBx8tH1b6wi7gNM5cmrC590QJLnU+k=;
        b=P84tHODTrynNhdwBSDHNrxQLisM+BhYybSBCojVB/63wz1zWifGIfdd5+Pu04t7g9y
         +9zTX7G/UYvQjnElf0ibJnn+n/r7F1g8IOGyhM07oROfKPBCKEWpWaHxC2yRRxR2YIXx
         gI96EHJgCijYm/1ncMTKq9j1xLzlY3f+6bYt6gzKWP8s4CXW/oix2fcIDxJye8MUYPTk
         PHUWUupAlaFjQxaeCAslY4oMoZQKrNhKriuaMxDrzPpjHAg6ly1DgFDmhC2CwaZsnjjN
         xdcCdmgHTPervwSEitdWLEjfgm4TfySNkQAAvvpkEuVhOO3L03cFnyk2s7rr2r5qhtDT
         OnQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BIUstVDoT6s4wHBx8tH1b6wi7gNM5cmrC590QJLnU+k=;
        b=NRwgyxWZOPwwd1tMUhCNYEV0kmyi36qgS1eki7hMQYvkoRbV+T6VY36TmzRFThuK9K
         O7W1+GaqV7bMB7tF8PBna47jQUD1/mK88Mkk0/b0alEMNENkuIw5j2GqlaC/HBqeOhwp
         H7pqJsjTpLQvJFJtENAn8e0MoVlA8k4oTvuULuqOew7PVy9VsLjmF+K87f4XhSBwsr0L
         +DbkpkwTyiA5yb955e8efEWtQ/50Uw1CkdZAPbhy5Ok6X8PsuaTQVMGN85WX3zsQlo+H
         FeuEvlPSlQDjWn3VIAQ604VRzLdOEkt2XFyQQRynk5hKFbzuw05WdSm4hBlLlrI/bSCr
         9adg==
X-Gm-Message-State: AFqh2kpqD/cQXPPcHob3GKHSsg6fwYiyGex3cWIdIhFcQ6v412sZ/yXG
        0lMrwRshUfir0HciEemxK/YaTg0cKAY=
X-Google-Smtp-Source: AMrXdXv4bGDDi5QQRCJL+YPqg5st0+aZU++VjOVKB75nplXuiGLciZpny6R0v6NU0Om8fPi8KJFSW9/oFM0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:e6c6:0:b0:746:cd75:3ab8 with SMTP id
 d189-20020a25e6c6000000b00746cd753ab8mr831064ybh.7.1671757068716; Thu, 22 Dec
 2022 16:57:48 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 23 Dec 2022 00:57:14 +0000
In-Reply-To: <20221223005739.1295925-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221223005739.1295925-1-seanjc@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20221223005739.1295925-3-seanjc@google.com>
Subject: [PATCH 02/27] KVM: x86/mmu: Factor out helper to get max mapping size
 of a memslot
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>
Cc:     kvm@vger.kernel.org, intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Yan Zhao <yan.y.zhao@intel.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Extract the memslot-related logic of kvm_mmu_max_mapping_level() into a
new helper so that KVMGT can determine whether or not mapping a 2MiB page
into the guest is (dis)allowed per KVM's memslots.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c          | 21 +++++++++++++++------
 arch/x86/kvm/mmu/mmu_internal.h |  2 ++
 2 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 254bc46234e0..ca7428b68eba 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3064,20 +3064,29 @@ static int host_pfn_mapping_level(struct kvm *kvm, gfn_t gfn,
 	return level;
 }
 
+int kvm_mmu_max_slot_mapping_level(const struct kvm_memory_slot *slot,
+				   gfn_t gfn, int max_level)
+{
+	struct kvm_lpage_info *linfo;
+
+	for ( ; max_level > PG_LEVEL_4K; max_level--) {
+		linfo = lpage_info_slot(gfn, slot, max_level);
+		if (!linfo->disallow_lpage)
+			break;
+	}
+	return max_level;
+}
+
 int kvm_mmu_max_mapping_level(struct kvm *kvm,
 			      const struct kvm_memory_slot *slot, gfn_t gfn,
 			      int max_level)
 {
-	struct kvm_lpage_info *linfo;
 	int host_level;
 
 	max_level = min(max_level, max_huge_page_level);
-	for ( ; max_level > PG_LEVEL_4K; max_level--) {
-		linfo = lpage_info_slot(gfn, slot, max_level);
-		if (!linfo->disallow_lpage)
-			break;
-	}
+	max_level = kvm_mmu_max_slot_mapping_level(slot, gfn, max_level);
 
+	/* Avoid walking the host page tables if a hugepage is impossible. */
 	if (max_level == PG_LEVEL_4K)
 		return PG_LEVEL_4K;
 
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index ac00bfbf32f6..b078c29e5674 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -314,6 +314,8 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 	return r;
 }
 
+int kvm_mmu_max_slot_mapping_level(const struct kvm_memory_slot *slot,
+				   gfn_t gfn, int max_level);
 int kvm_mmu_max_mapping_level(struct kvm *kvm,
 			      const struct kvm_memory_slot *slot, gfn_t gfn,
 			      int max_level);
-- 
2.39.0.314.g84b9a713c41-goog

