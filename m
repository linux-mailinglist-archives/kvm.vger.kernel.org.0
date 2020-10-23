Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 343202973E5
	for <lists+kvm@lfdr.de>; Fri, 23 Oct 2020 18:32:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1751535AbgJWQae (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Oct 2020 12:30:34 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:54642 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751518AbgJWQad (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 23 Oct 2020 12:30:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603470632;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=E+3IRJB6Q1/p5CmMrxkT9gnBU657hxEY63DzKc8Vg14=;
        b=Lmzy0GO/R7Qab7QilElPTjk/UEqjwbNlV/9BqFPIO8DeXTFXNw8Lb9XB+y9mj/bLAs38vJ
        qZ83oLECwN8Ds93Af/XVXhXSzMHNegwdbKqBLG/ZpOiZwOKiZ0qRxeEmd26hkZ8ws55OEI
        d+msXIyLsZwA0AJI76wcnzSyNMQ3euo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-532-E-Q0nn2iM_atWqcOb2snhw-1; Fri, 23 Oct 2020 12:30:26 -0400
X-MC-Unique: E-Q0nn2iM_atWqcOb2snhw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 66C39ADC3A;
        Fri, 23 Oct 2020 16:30:25 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 05FEF5DA78;
        Fri, 23 Oct 2020 16:30:24 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     bgardon@google.com
Subject: [PATCH 01/22] kvm: mmu: Separate making non-leaf sptes from link_shadow_page
Date:   Fri, 23 Oct 2020 12:30:03 -0400
Message-Id: <20201023163024.2765558-2-pbonzini@redhat.com>
In-Reply-To: <20201023163024.2765558-1-pbonzini@redhat.com>
References: <20201023163024.2765558-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ben Gardon <bgardon@google.com>

The TDP MMU page fault handler will need to be able to create non-leaf
SPTEs to build up the paging structures. Rather than re-implementing the
function, factor the SPTE creation out of link_shadow_page.

Tested by running kvm-unit-tests and KVM selftests on an Intel Haswell
machine. This series introduced no new failures.

This series can be viewed in Gerrit at:
	https://linux-review.googlesource.com/c/virt/kvm/kvm/+/2538

Signed-off-by: Ben Gardon <bgardon@google.com>
Message-Id: <20200925212302.3979661-9-bgardon@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 08c5fb60fcce..60103fd07bd2 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2573,21 +2573,30 @@ static void shadow_walk_next(struct kvm_shadow_walk_iterator *iterator)
 	__shadow_walk_next(iterator, *iterator->sptep);
 }
 
-static void link_shadow_page(struct kvm_vcpu *vcpu, u64 *sptep,
-			     struct kvm_mmu_page *sp)
+static u64 make_nonleaf_spte(u64 *child_pt, bool ad_disabled)
 {
 	u64 spte;
 
-	BUILD_BUG_ON(VMX_EPT_WRITABLE_MASK != PT_WRITABLE_MASK);
-
-	spte = __pa(sp->spt) | shadow_present_mask | PT_WRITABLE_MASK |
+	spte = __pa(child_pt) | shadow_present_mask | PT_WRITABLE_MASK |
 	       shadow_user_mask | shadow_x_mask | shadow_me_mask;
 
-	if (sp_ad_disabled(sp))
+	if (ad_disabled)
 		spte |= SPTE_AD_DISABLED_MASK;
 	else
 		spte |= shadow_accessed_mask;
 
+	return spte;
+}
+
+static void link_shadow_page(struct kvm_vcpu *vcpu, u64 *sptep,
+			     struct kvm_mmu_page *sp)
+{
+	u64 spte;
+
+	BUILD_BUG_ON(VMX_EPT_WRITABLE_MASK != PT_WRITABLE_MASK);
+
+	spte = make_nonleaf_spte(sp->spt, sp_ad_disabled(sp));
+
 	mmu_spte_set(sptep, spte);
 
 	mmu_page_add_parent_pte(vcpu, sp, sptep);
-- 
2.26.2


