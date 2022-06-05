Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7831053DA77
	for <lists+kvm@lfdr.de>; Sun,  5 Jun 2022 08:43:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350742AbiFEGnV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 5 Jun 2022 02:43:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350702AbiFEGnJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 5 Jun 2022 02:43:09 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 940683818A;
        Sat,  4 Jun 2022 23:43:08 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id d12-20020a17090abf8c00b001e2eb431ce4so10215165pjs.1;
        Sat, 04 Jun 2022 23:43:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=X+oVc5Jc2YZlyFStynYpBPKDNUvLM8aeKT+uK1k5JEA=;
        b=Ku4OmJ+WXgLGs0srjvwrm+2S0nMCWDp+mnf6WSBti1bQhuufoJEOJv/4sbwcumzQs7
         M3jSUcb5/iIAtQasQC56uxpEpSY+E56hchLIRc2GVEZ1/4wLX4bzGNoORn44+K1A/Svf
         Ule6uBVQ1qE2eMaPo/Qrn+lKGZHVjYtPsAq3OQhL2a8KFQi9HelVE6oNGpOB+AZwhYqN
         yN4izr8BTmFxPA6QRxmnMsT2lV44+g0Fsms6Fe38+UamX/EEG9Qf5PQST7MJa++B2VbX
         fC00uWG0OhE/swo26Uybw5sBDz/JVBI/TaIML23iiponDkD9R8t8WSU37u26VXHMBajS
         2ftw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=X+oVc5Jc2YZlyFStynYpBPKDNUvLM8aeKT+uK1k5JEA=;
        b=4B6CoUMc/MpuHdIN/M+kSx4M+ysyhUgetPTRq8oL5PouxELnVfgLPL20sf7wp7DxIr
         +Aker28y919c62J8N3QhAzu6xSxRcvLg0Zgf/xn2KGNujskApC9XlnAKFuJEUGHuSKVm
         NwwPllrH/QmLftFmdEc/jHUvazk7MoXjfXG0dLFD15r7T8y6d3tXZnmmAPG3erZlCWTf
         0da7evxGo/tdSv0AhcNc+QFofXh2aaGghs48fRfcqc63SZQvUfsbVcmXgiSEV4pBYtgg
         F6XCSxhAOv9BwKPcTuRsR87F9/WhSqm+xo4xHjQtLD1pT+M0cBuWk/j4RfpLA7WbrggT
         SAIQ==
X-Gm-Message-State: AOAM5324Z5GNwaCVHp5oAze/K0dKmYUSeDMcHeDqhO73UUZVkhA1mqNv
        GQknguT1KIvBl/Jhs1d748KVH9Czc+0=
X-Google-Smtp-Source: ABdhPJz8GBmZ3diXVAJtJRy94jd1RtPCSu8Fgy0ih6j6jnD0Sv6PFvAkoZIy2dCAV3QOo40ysDpqKQ==
X-Received: by 2002:a17:902:f641:b0:15f:21f8:92a1 with SMTP id m1-20020a170902f64100b0015f21f892a1mr18846794plg.56.1654411387727;
        Sat, 04 Jun 2022 23:43:07 -0700 (PDT)
Received: from localhost ([198.11.178.15])
        by smtp.gmail.com with ESMTPSA id m13-20020a170902db0d00b001616c3bd5c2sm8342929plx.162.2022.06.04.23.43.07
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 04 Jun 2022 23:43:07 -0700 (PDT)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>
Subject: [PATCH 04/12] KVM: X86/MMU: Remove mmu_pages_clear_parents()
Date:   Sun,  5 Jun 2022 14:43:34 +0800
Message-Id: <20220605064342.309219-5-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20220605064342.309219-1-jiangshanlai@gmail.com>
References: <20220605064342.309219-1-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <jiangshan.ljs@antgroup.com>

mmu_unsync_walk() is designed to be workable in a pagetable which has
unsync child bits set in the shadow pages in the pagetable but without
any unsync shadow pages.

This can be resulted when the unsync shadow pages of a pagetable
can be walked from other pagetables and have been synced or zapped
when other pagetables are synced or zapped.

So mmu_pages_clear_parents() is not required even when the callers of
mmu_unsync_walk() zap or sync the pagetable.

So remove mmu_pages_clear_parents() and the child bits can be cleared in
the next call of mmu_unsync_walk() in one go.

Removing mmu_pages_clear_parents() allows for further simplifying
mmu_unsync_walk() including removing the struct mmu_page_path since
the function is the only user of it.

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
---
 arch/x86/kvm/mmu/mmu.c | 19 -------------------
 1 file changed, 19 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index cc0207e26f6e..f35fd5c59c38 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1948,23 +1948,6 @@ static int mmu_pages_first(struct kvm_mmu_pages *pvec,
 	return mmu_pages_next(pvec, parents, 0);
 }
 
-static void mmu_pages_clear_parents(struct mmu_page_path *parents)
-{
-	struct kvm_mmu_page *sp;
-	unsigned int level = 0;
-
-	do {
-		unsigned int idx = parents->idx[level];
-		sp = parents->parent[level];
-		if (!sp)
-			return;
-
-		WARN_ON(idx == INVALID_INDEX);
-		clear_unsync_child_bit(sp, idx);
-		level++;
-	} while (!sp->unsync_children);
-}
-
 static int mmu_sync_children(struct kvm_vcpu *vcpu,
 			     struct kvm_mmu_page *parent, bool can_yield)
 {
@@ -1989,7 +1972,6 @@ static int mmu_sync_children(struct kvm_vcpu *vcpu,
 		for_each_sp(pages, sp, parents, i) {
 			kvm_mmu_page_clear_unsync(vcpu->kvm, sp);
 			flush |= kvm_sync_page(vcpu, sp, &invalid_list) > 0;
-			mmu_pages_clear_parents(&parents);
 		}
 		if (need_resched() || rwlock_needbreak(&vcpu->kvm->mmu_lock)) {
 			kvm_mmu_remote_flush_or_zap(vcpu->kvm, &invalid_list, flush);
@@ -2298,7 +2280,6 @@ static int mmu_zap_unsync_children(struct kvm *kvm,
 
 		for_each_sp(pages, sp, parents, i) {
 			kvm_mmu_prepare_zap_page(kvm, sp, invalid_list);
-			mmu_pages_clear_parents(&parents);
 			zapped++;
 		}
 	}
-- 
2.19.1.6.gb485710b

