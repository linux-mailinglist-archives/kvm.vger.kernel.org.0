Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B992E2973E4
	for <lists+kvm@lfdr.de>; Fri, 23 Oct 2020 18:32:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1751525AbgJWQad (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Oct 2020 12:30:33 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:35322 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750673AbgJWQac (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 23 Oct 2020 12:30:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603470631;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9XP8+73+4MPF4qF13p2CcXbfnB2Aa5OPRsJarmBdtcw=;
        b=XslsxuWUDJz4/Evb1BXVZz7ti5TjtoA2GtK1/AqcJNNt1d0F0o7atpl7aE+hrWjf5XLIMe
        bbBbGL7jIfIWIXspbkVDYHvySLnOSplRLEr2c1gSPYmKJVstbVQPKowZ8OCu0WV2oGFufw
        Y1/NDx2rQXFqF3NlWCeuDIGTGCJu6ZQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-238-sQMR7binMT2F2UfX8F0xbg-1; Fri, 23 Oct 2020 12:30:27 -0400
X-MC-Unique: sQMR7binMT2F2UfX8F0xbg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 062A6ADC5E;
        Fri, 23 Oct 2020 16:30:26 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 86E705DA78;
        Fri, 23 Oct 2020 16:30:25 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     bgardon@google.com, Peter Shier <pshier@google.com>
Subject: [PATCH 02/22] kvm: x86/mmu: Separate making SPTEs from set_spte
Date:   Fri, 23 Oct 2020 12:30:04 -0400
Message-Id: <20201023163024.2765558-3-pbonzini@redhat.com>
In-Reply-To: <20201023163024.2765558-1-pbonzini@redhat.com>
References: <20201023163024.2765558-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ben Gardon <bgardon@google.com>

Separate the functions for generating leaf page table entries from the
function that inserts them into the paging structure. This refactoring
will facilitate changes to the MMU sychronization model to use atomic
compare / exchanges (which are not guaranteed to succeed) instead of a
monolithic MMU lock.

No functional change expected.

Tested by running kvm-unit-tests and KVM selftests on an Intel Haswell
machine. This commit introduced no new failures.

This series can be viewed in Gerrit at:
	https://linux-review.googlesource.com/c/virt/kvm/kvm/+/2538

Signed-off-by: Ben Gardon <bgardon@google.com>
Reviewed-by: Peter Shier <pshier@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c | 49 ++++++++++++++++++++++++++++--------------
 1 file changed, 33 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 60103fd07bd2..ef4a63af8fce 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2996,20 +2996,15 @@ static bool kvm_is_mmio_pfn(kvm_pfn_t pfn)
 #define SET_SPTE_NEED_REMOTE_TLB_FLUSH	BIT(1)
 #define SET_SPTE_SPURIOUS		BIT(2)
 
-static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
-		    unsigned int pte_access, int level,
-		    gfn_t gfn, kvm_pfn_t pfn, bool speculative,
-		    bool can_unsync, bool host_writable)
+static int make_spte(struct kvm_vcpu *vcpu, unsigned int pte_access, int level,
+		     gfn_t gfn, kvm_pfn_t pfn, u64 old_spte, bool speculative,
+		     bool can_unsync, bool host_writable, bool ad_disabled,
+		     u64 *new_spte)
 {
 	u64 spte = 0;
 	int ret = 0;
-	struct kvm_mmu_page *sp;
 
-	if (set_mmio_spte(vcpu, sptep, gfn, pfn, pte_access))
-		return 0;
-
-	sp = sptep_to_sp(sptep);
-	if (sp_ad_disabled(sp))
+	if (ad_disabled)
 		spte |= SPTE_AD_DISABLED_MASK;
 	else if (kvm_vcpu_ad_need_write_protect(vcpu))
 		spte |= SPTE_AD_WRPROT_ONLY_MASK;
@@ -3062,8 +3057,8 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 		 * is responsibility of mmu_get_page / kvm_sync_page.
 		 * Same reasoning can be applied to dirty page accounting.
 		 */
-		if (!can_unsync && is_writable_pte(*sptep))
-			goto set_pte;
+		if (!can_unsync && is_writable_pte(old_spte))
+			goto out;
 
 		if (mmu_need_write_protect(vcpu, gfn, can_unsync)) {
 			pgprintk("%s: found shadow page for %llx, marking ro\n",
@@ -3074,15 +3069,37 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 		}
 	}
 
-	if (pte_access & ACC_WRITE_MASK) {
-		kvm_vcpu_mark_page_dirty(vcpu, gfn);
+	if (pte_access & ACC_WRITE_MASK)
 		spte |= spte_shadow_dirty_mask(spte);
-	}
 
 	if (speculative)
 		spte = mark_spte_for_access_track(spte);
 
-set_pte:
+out:
+	*new_spte = spte;
+	return ret;
+}
+
+static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
+		    unsigned int pte_access, int level,
+		    gfn_t gfn, kvm_pfn_t pfn, bool speculative,
+		    bool can_unsync, bool host_writable)
+{
+	u64 spte;
+	struct kvm_mmu_page *sp;
+	int ret;
+
+	if (set_mmio_spte(vcpu, sptep, gfn, pfn, pte_access))
+		return 0;
+
+	sp = sptep_to_sp(sptep);
+
+	ret = make_spte(vcpu, pte_access, level, gfn, pfn, *sptep, speculative,
+			can_unsync, host_writable, sp_ad_disabled(sp), &spte);
+
+	if (spte & PT_WRITABLE_MASK)
+		kvm_vcpu_mark_page_dirty(vcpu, gfn);
+
 	if (*sptep == spte)
 		ret |= SET_SPTE_SPURIOUS;
 	else if (mmu_spte_update(sptep, spte))
-- 
2.26.2


