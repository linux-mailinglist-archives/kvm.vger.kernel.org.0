Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CC5EC03E9
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2019 13:18:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727140AbfI0LPx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Sep 2019 07:15:53 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:51261 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725992AbfI0LPw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Sep 2019 07:15:52 -0400
Received: by mail-wm1-f67.google.com with SMTP id 7so6158193wme.1;
        Fri, 27 Sep 2019 04:15:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=U//T57ckRUfqFptbXCZJO0PB/mpYWhUpr3TQWke5zyc=;
        b=RlMkfyRxJLRmtJByoiygNWMU9wzXXuSYBMW538K/ygniWIscoW5YXHZxsSBqVoxfSe
         hT6F8NhcBsrOl9MOyY24volqjGj+CM8x8Pg4EnVrlIytXpjiv58SVWcnvPP0wDS8lDGF
         wDT1M+++IA77ZOY1Hl2J49gtuFxnSla2MHPFvVETn8wwsgPr2br6z3M3XXnrJaH3oXPd
         YCtNeWC/qu9ECWz1qTqt/MdBUsZbkMESIMO/6X0YmDGFakMKGYGu6Nol8+rMJOBOOq+f
         N/9dtK02wX6ZxCWp19Af/caWz8yC5oxhaGZ4mp7fR5q/BqaljkyvzoMTow1hp27wAC8/
         3CHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=U//T57ckRUfqFptbXCZJO0PB/mpYWhUpr3TQWke5zyc=;
        b=PUa3GZkpSxmR7e4OX70k0Xdhdhpjz3Sm7vAp7o1Y0Ev3ABWEIHeuqYunPg+k3ksDTS
         wQVfOmfPvh3NV0MbDz5ynejkwLfhcGqsgcd+p1/LBGtcoxzbSKgjlskRS89nw+c3LXkG
         ymj1NIQCdkYIZxE7rev2QOtRCB5A2P6hiMrLlzSmDpgsVX5LhKEXSDCldfxJtdg7yqmN
         EWDQBEt4wOEe+PRd4rx83SFXtUrkHgucbLDOgjEZ14wvYmGpd0rsayjm4ScjlAhOH8Kp
         apH5zZLMPsZisaapSnaiXNN2iCxhC9gkAl5L8iBDJy5lweSt2hAGRsAsUAt8BhCahEmI
         YKVQ==
X-Gm-Message-State: APjAAAXMye6BqNmgfnK2VpsDZZWG7klgy3o8XwV7bL6Bvx1qhahpaMWb
        d1TEbLsfaahQtjJQQNgXW7bJyrn0
X-Google-Smtp-Source: APXvYqz5ETFhyGacXxTr9VbDwb0adhUJ0CsIBeqX53QRBZ0R652r3XM9o5pjMAN29K9laHkhH5Q0xw==
X-Received: by 2002:a05:600c:2252:: with SMTP id a18mr7041154wmm.141.1569582948993;
        Fri, 27 Sep 2019 04:15:48 -0700 (PDT)
Received: from 640k.lan ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id r28sm2913848wrr.94.2019.09.27.04.15.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 27 Sep 2019 04:15:47 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Junaid Shahid <junaids@google.com>
Subject: [PATCH v2 2/3] KVM: x86: fix nested guest live migration with PML
Date:   Fri, 27 Sep 2019 13:15:42 +0200
Message-Id: <1569582943-13476-3-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1569582943-13476-1-git-send-email-pbonzini@redhat.com>
References: <1569582943-13476-1-git-send-email-pbonzini@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Shadow paging is fundamentally incompatible with the page-modification
log, because the GPAs in the log come from the wrong memory map.
In particular, for the EPT page-modification log, the GPAs in the log come
from L2 rather than L1.  (If there was a non-EPT page-modification log,
we couldn't use it for shadow paging because it would log GVAs rather
than GPAs).

Therefore, we need to rely on write protection to record dirty pages.
This has the side effect of bypassing PML, since writes now result in an
EPT violation vmexit.

This is relatively easy to add to KVM, because pretty much the only place
that needs changing is spte_clear_dirty.  The first access to the page
already goes through the page fault path and records the correct GPA;
it's only subsequent accesses that are wrong.  Therefore, we can equip
set_spte (where the first access happens) to record that the SPTE will
have to be write protected, and then spte_clear_dirty will use this
information to do the right thing.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu.c | 39 ++++++++++++++++++++++++++++++++-------
 1 file changed, 32 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index bac8d228d82b..24c23c66b226 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -92,6 +92,7 @@ enum {
 #define SPTE_SPECIAL_MASK (3ULL << 52)
 #define SPTE_AD_ENABLED_MASK (0ULL << 52)
 #define SPTE_AD_DISABLED_MASK (1ULL << 52)
+#define SPTE_AD_WRPROT_ONLY_MASK (2ULL << 52)
 #define SPTE_MMIO_MASK (3ULL << 52)
 
 #define PT64_LEVEL_BITS 9
@@ -328,10 +329,27 @@ static inline bool sp_ad_disabled(struct kvm_mmu_page *sp)
 	return sp->role.ad_disabled;
 }
 
+static inline bool kvm_vcpu_ad_need_write_protect(struct kvm_vcpu *vcpu)
+{
+	/*
+	 * When using the EPT page-modification log, the GPAs in the log
+	 * would come from L2 rather than L1.  Therefore, we need to rely
+	 * on write protection to record dirty pages.  This also bypasses
+	 * PML, since writes now result in a vmexit.
+	 */
+	return vcpu->arch.mmu == &vcpu->arch.guest_mmu;
+}
+
 static inline bool spte_ad_enabled(u64 spte)
 {
 	MMU_WARN_ON(is_mmio_spte(spte));
-	return (spte & SPTE_SPECIAL_MASK) == SPTE_AD_ENABLED_MASK;
+	return (spte & SPTE_SPECIAL_MASK) != SPTE_AD_DISABLED_MASK;
+}
+
+static inline bool spte_ad_need_write_protect(u64 spte)
+{
+	MMU_WARN_ON(is_mmio_spte(spte));
+	return (spte & SPTE_SPECIAL_MASK) != SPTE_AD_ENABLED_MASK;
 }
 
 static inline u64 spte_shadow_accessed_mask(u64 spte)
@@ -1597,16 +1615,16 @@ static bool spte_clear_dirty(u64 *sptep)
 
 	rmap_printk("rmap_clear_dirty: spte %p %llx\n", sptep, *sptep);
 
+	MMU_WARN_ON(!spte_ad_enabled(spte));
 	spte &= ~shadow_dirty_mask;
-
 	return mmu_spte_update(sptep, spte);
 }
 
-static bool wrprot_ad_disabled_spte(u64 *sptep)
+static bool spte_wrprot_for_clear_dirty(u64 *sptep)
 {
 	bool was_writable = test_and_clear_bit(PT_WRITABLE_SHIFT,
 					       (unsigned long *)sptep);
-	if (was_writable)
+	if (was_writable && !spte_ad_enabled(*sptep))
 		kvm_set_pfn_dirty(spte_to_pfn(*sptep));
 
 	return was_writable;
@@ -1625,10 +1643,10 @@ static bool __rmap_clear_dirty(struct kvm *kvm, struct kvm_rmap_head *rmap_head)
 	bool flush = false;
 
 	for_each_rmap_spte(rmap_head, &iter, sptep)
-		if (spte_ad_enabled(*sptep))
-			flush |= spte_clear_dirty(sptep);
+		if (spte_ad_need_write_protect(*sptep))
+			flush |= spte_wrprot_for_clear_dirty(sptep);
 		else
-			flush |= wrprot_ad_disabled_spte(sptep);
+			flush |= spte_clear_dirty(sptep);
 
 	return flush;
 }
@@ -1639,6 +1657,11 @@ static bool spte_set_dirty(u64 *sptep)
 
 	rmap_printk("rmap_set_dirty: spte %p %llx\n", sptep, *sptep);
 
+	/*
+	 * Similar to the !kvm_x86_ops->slot_disable_log_dirty case,
+	 * do not bother adding back write access to pages marked
+	 * SPTE_AD_WRPROT_ONLY_MASK.
+	 */
 	spte |= shadow_dirty_mask;
 
 	return mmu_spte_update(sptep, spte);
@@ -2977,6 +3000,8 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 	sp = page_header(__pa(sptep));
 	if (sp_ad_disabled(sp))
 		spte |= SPTE_AD_DISABLED_MASK;
+	else if (kvm_vcpu_ad_need_write_protect(vcpu))
+		spte |= SPTE_AD_WRPROT_ONLY_MASK;
 
 	/*
 	 * For the EPT case, shadow_present_mask is 0 if hardware
-- 
1.8.3.1


