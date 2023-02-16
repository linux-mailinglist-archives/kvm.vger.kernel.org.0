Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4799C69A2A7
	for <lists+kvm@lfdr.de>; Fri, 17 Feb 2023 00:52:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229879AbjBPXwc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Feb 2023 18:52:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbjBPXw2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Feb 2023 18:52:28 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75FEE4BEAA;
        Thu, 16 Feb 2023 15:52:27 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id q15so245353plx.13;
        Thu, 16 Feb 2023 15:52:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2T3A+NeBb/ccoI9DDnY4IUQQOPg/c+nwhtLLZFEmqEM=;
        b=NR+n4Siy5dXYe7kU/AvBxHFyugjEXMuEhh5Pks0mmzfgKbjdI+ZLgVznSLll2yBI1l
         SWaxQk2Vi2kOQOnneE/asqszJeyscY6CmbZcEj/MVeQOh68RquIbXKe3PZSS6Hu3RpCH
         AN8R3XTd4bO9OggSnNZA8WlMxCa6mBZyBmu+9IyyapmJ1bcVhG2To/oltOAd8bMB4Lt7
         97anQkA7caomQwFJ4AhFhokZ5zsXgLpawMST8Yu7FLBnUj+dxw4gv4VsYFuH1RUNGr74
         9ZTTanjw0ycoazZbpfdl+hAI0BMJF9EagS5FehtYJ8t2flQ+gLl05WjzaKf6hCaCMXgc
         PGJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2T3A+NeBb/ccoI9DDnY4IUQQOPg/c+nwhtLLZFEmqEM=;
        b=m9z1ic8OFK+r4bEBjKsOZ5qG4+96suxMSk9hAaISll0vQLC1HkyPMedm7cFRbWm4Rz
         Qe9HWK0aILi8jk0zJ5WWAUyXwkojGVVMblwKBlqoii0Jxy1Vb9hZbtTATJmwy9ldP71v
         kn44t7tEV3Yt5FVWIn0SzNoOipKj4PzKNvxEmQKbG9z0sOwmZ4SPcKLQMYsryEwQo8YL
         uHz1KSd3bFg/Bq1QjlvhTCoN9ZiqbFedTeqYPfhA0QPsFQaykUxaQS+g3AU4ZI929WFF
         is8/K0sGaqTMH3RB+Xiru15dXK3ENh0x290cxlqJ5JPy/FZgLowbVqj6W8VFmyybAuSF
         MuwQ==
X-Gm-Message-State: AO0yUKWIX0c4N8D5tqXmkuLGx7J7OQMw+7wKz+yO77NMypE6qjqh7k5p
        G5Gfh+e07vli3+FAdxFeesh6M9l+CpA=
X-Google-Smtp-Source: AK7set9t3Kj7SGI5txkaX7nq7X2HbHjUNjVGtrkDxomkAQX57eAoU7sCztMS9pGaWm63UfPUL5wwEw==
X-Received: by 2002:a17:903:32d1:b0:19a:7d73:ef47 with SMTP id i17-20020a17090332d100b0019a7d73ef47mr4498268plr.17.1676591546665;
        Thu, 16 Feb 2023 15:52:26 -0800 (PST)
Received: from localhost ([198.11.178.15])
        by smtp.gmail.com with ESMTPSA id v10-20020a1709029a0a00b0019abb539cddsm1851958plp.10.2023.02.16.15.52.25
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 16 Feb 2023 15:52:26 -0800 (PST)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org
Subject: [PATCH V3 11/14] kvm: x86/mmu: Allow the roots to be invalid in FNAME(invlpg)
Date:   Fri, 17 Feb 2023 07:53:18 +0800
Message-Id: <20230216235321.735214-2-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20230216235321.735214-1-jiangshanlai@gmail.com>
References: <20230216154115.710033-1-jiangshanlai@gmail.com>
 <20230216235321.735214-1-jiangshanlai@gmail.com>
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

Don't assume the current root to be valid, just check it and remove
the WARN().

Also move the code to check if the root is valid into FNAME(invlpg)
to simplify the code.

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
---
 arch/x86/kvm/mmu/mmu.c         | 3 +--
 arch/x86/kvm/mmu/paging_tmpl.h | 4 +---
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 9b5e3afbcdb4..7d5ff2b0f6d5 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5786,8 +5786,7 @@ void kvm_mmu_invalidate_addr(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 		mmu->invlpg(vcpu, addr, mmu->root.hpa);
 
 	for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++) {
-		if ((roots & KVM_MMU_ROOT_PREVIOUS(i)) &&
-		    VALID_PAGE(mmu->prev_roots[i].hpa))
+		if (roots & KVM_MMU_ROOT_PREVIOUS(i))
 			mmu->invlpg(vcpu, addr, mmu->prev_roots[i].hpa);
 	}
 }
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 7db167876cd7..9be5a0f22a9f 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -904,10 +904,8 @@ static void FNAME(invlpg)(struct kvm_vcpu *vcpu, u64 addr, hpa_t root_hpa)
 	 */
 	mmu_topup_memory_caches(vcpu, true);
 
-	if (!VALID_PAGE(root_hpa)) {
-		WARN_ON(1);
+	if (!VALID_PAGE(root_hpa))
 		return;
-	}
 
 	write_lock(&vcpu->kvm->mmu_lock);
 	for_each_shadow_entry_using_root(vcpu, root_hpa, addr, iterator) {
-- 
2.19.1.6.gb485710b

