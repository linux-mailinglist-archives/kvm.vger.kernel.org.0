Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75EDABF778
	for <lists+kvm@lfdr.de>; Thu, 26 Sep 2019 19:19:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727769AbfIZRSn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Sep 2019 13:18:43 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:45091 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726029AbfIZRSd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Sep 2019 13:18:33 -0400
Received: by mail-wr1-f66.google.com with SMTP id r5so3360785wrm.12;
        Thu, 26 Sep 2019 10:18:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=xwic50KwZcJPp/KZaRqAPwK8c1hW088iDUhsMHxdYPw=;
        b=WjCTfMH5Dzl3ID5kPlU8vrvKXyQucve4ckJu80EXO3sltgeCMZ/zfJfA9ufCtbGvJ/
         pRXMOdPZsdAqfOf1fhJEti8qMRnl1S3xvPKuILwT53vX5VUzEo9VLODtwBUDlpwGKNAD
         1U0MFe82y0zCjZqYHr571/QCX/om+86UBli64Dr3Cjs5rzQc2IAEtlcHcCr5DzHKJrMv
         sYE/zlkIW1HmrmHXRFcUxpwqog3N+TBGrq267wkEVKqBniveN9Nd5jVT3R7bILW49lCP
         54U9U9SguV406+KxweXnjRAEOsN1uQ4vAr5naTIjz0YFyntwkS7hxLwMxuJX6KwL/YzK
         ydQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=xwic50KwZcJPp/KZaRqAPwK8c1hW088iDUhsMHxdYPw=;
        b=XGglH5hnBtTUVR5EZRaozRsZ2W06RRjCVXRrWf9jo+H3C2BPifbcvaQzeNhqOMPduo
         02l1Lgfy0KgAFf0wfZfujoXgTgdVJFsM3YzAN8IrhazrZxBLhPHx2PaUKnKx2wONccp3
         WVye3QjhvQ/HSLceH0YT5mpE7amNZtY0NwvUtKwCbz1SIQ5t1RjOXOurXFJBvkHgbh6g
         7mIadFh40qyx8G4hdf0fA384T0D3d7ScLeU9DDCNZcXT4ofR23VdfKYlXGUgHsZCeg3R
         eNX05C7RxfbMHm2IrUEwNgwAA+e9q4wX7JXzzYMnb2QPawR4J3jYyWjU+cbZ9Box8HL1
         HyPg==
X-Gm-Message-State: APjAAAWch9oL4uMsFfC21gbCi9d8DH+jGzlZUeKaX0iV0CG0CLO0BTWQ
        AGdfCrCDH4Z9u5qh/jCmCLxo7jnh
X-Google-Smtp-Source: APXvYqzCn6HrXPfes3oUc6CQ+SWJj/oUjwJPpw788apigE8rCpVuX5OYBPKIh93LtA/uCEoCkxzkOA==
X-Received: by 2002:adf:fc0e:: with SMTP id i14mr3902835wrr.302.1569518311191;
        Thu, 26 Sep 2019 10:18:31 -0700 (PDT)
Received: from 640k.localdomain.com ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id v4sm4792782wrg.56.2019.09.26.10.18.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 26 Sep 2019 10:18:30 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Junaid Shahid <junaids@google.com>
Subject: [PATCH 2/3] KVM: x86: fix nested guest live migration with PML
Date:   Thu, 26 Sep 2019 19:18:25 +0200
Message-Id: <1569518306-46567-3-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1569518306-46567-1-git-send-email-pbonzini@redhat.com>
References: <1569518306-46567-1-git-send-email-pbonzini@redhat.com>
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
 arch/x86/kvm/mmu.c | 32 ++++++++++++++++++++++++++++++--
 1 file changed, 30 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index bac8d228d82b..722a3b5fc0db 100644
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
@@ -1597,8 +1615,11 @@ static bool spte_clear_dirty(u64 *sptep)
 
 	rmap_printk("rmap_clear_dirty: spte %p %llx\n", sptep, *sptep);
 
-	spte &= ~shadow_dirty_mask;
+	WARN_ON(!spte_ad_enabled(spte));
+	if (spte_ad_need_write_protect(spte))
+		return spte_write_protect(sptep, false);
 
+	spte &= ~shadow_dirty_mask;
 	return mmu_spte_update(sptep, spte);
 }
 
@@ -1639,6 +1660,11 @@ static bool spte_set_dirty(u64 *sptep)
 
 	rmap_printk("rmap_set_dirty: spte %p %llx\n", sptep, *sptep);
 
+	/*
+	 * Similar to the !kvm_x86_ops->slot_disable_log_dirty case,
+	 * do not bother adding back write access to pages marked
+	 * SPTE_AD_WRPROT_ONLY_MASK.
+	 */
 	spte |= shadow_dirty_mask;
 
 	return mmu_spte_update(sptep, spte);
@@ -2977,6 +3003,8 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 	sp = page_header(__pa(sptep));
 	if (sp_ad_disabled(sp))
 		spte |= SPTE_AD_DISABLED_MASK;
+	else if (kvm_vcpu_ad_need_write_protect(vcpu))
+		spte |= SPTE_AD_WRPROT_ONLY_MASK;
 
 	/*
 	 * For the EPT case, shadow_present_mask is 0 if hardware
-- 
1.8.3.1


