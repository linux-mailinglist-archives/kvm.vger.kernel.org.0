Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 509C32973E1
	for <lists+kvm@lfdr.de>; Fri, 23 Oct 2020 18:31:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1751585AbgJWQan (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Oct 2020 12:30:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22113 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751572AbgJWQam (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 23 Oct 2020 12:30:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603470641;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kd5jDLvDsdB8sdAWI6XTM1U0ZvoV5rDpBsLPGi97b80=;
        b=BX68Rf/jmfjADEXnQnbBfKkj4fJ6lWsoEq6qjCDXG+K2MiXn+zj6Se5f5LKmXHkpVOHT2q
        eqy5Fl4ChwI98qM15xpQQD2Jc8SVSco2Mqasl0feyHkMk1ui2ANKuJwYj2Iz+V1HyqzWGf
        ES9PWqPhzlpxDhi2QljWKe5jEaE6aX4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-589-V3ubQcCLMT6FMuZMm7-xLQ-1; Fri, 23 Oct 2020 12:30:38 -0400
X-MC-Unique: V3ubQcCLMT6FMuZMm7-xLQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 66C45804B80;
        Fri, 23 Oct 2020 16:30:37 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1104861983;
        Fri, 23 Oct 2020 16:30:37 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     bgardon@google.com
Subject: [PATCH 11/22] kvm: x86/mmu: Remove disallowed_hugepage_adjust shadow_walk_iterator arg
Date:   Fri, 23 Oct 2020 12:30:13 -0400
Message-Id: <20201023163024.2765558-12-pbonzini@redhat.com>
In-Reply-To: <20201023163024.2765558-1-pbonzini@redhat.com>
References: <20201023163024.2765558-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ben Gardon <bgardon@google.com>

In order to avoid creating executable hugepages in the TDP MMU PF
handler, remove the dependency between disallowed_hugepage_adjust and
the shadow_walk_iterator. This will open the function up to being used
by the TDP MMU PF handler in a future patch.

Tested by running kvm-unit-tests and KVM selftests on an Intel Haswell
machine. This series introduced no new failures.

This series can be viewed in Gerrit at:
	https://linux-review.googlesource.com/c/virt/kvm/kvm/+/2538

Signed-off-by: Ben Gardon <bgardon@google.com>
Message-Id: <20201014182700.2888246-10-bgardon@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c         | 13 +++++++------
 arch/x86/kvm/mmu/paging_tmpl.h |  3 ++-
 2 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index dd15e519c361..6f22c155381d 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2818,13 +2818,12 @@ static int kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, gfn_t gfn,
 	return level;
 }
 
-static void disallowed_hugepage_adjust(struct kvm_shadow_walk_iterator it,
-				       gfn_t gfn, kvm_pfn_t *pfnp, int *levelp)
+static void disallowed_hugepage_adjust(u64 spte, gfn_t gfn, int cur_level,
+				       kvm_pfn_t *pfnp, int *levelp)
 {
 	int level = *levelp;
-	u64 spte = *it.sptep;
 
-	if (it.level == level && level > PG_LEVEL_4K &&
+	if (cur_level == level && level > PG_LEVEL_4K &&
 	    is_shadow_present_pte(spte) &&
 	    !is_large_pte(spte)) {
 		/*
@@ -2834,7 +2833,8 @@ static void disallowed_hugepage_adjust(struct kvm_shadow_walk_iterator it,
 		 * patching back for them into pfn the next 9 bits of
 		 * the address.
 		 */
-		u64 page_mask = KVM_PAGES_PER_HPAGE(level) - KVM_PAGES_PER_HPAGE(level - 1);
+		u64 page_mask = KVM_PAGES_PER_HPAGE(level) -
+				KVM_PAGES_PER_HPAGE(level - 1);
 		*pfnp |= gfn & page_mask;
 		(*levelp)--;
 	}
@@ -2867,7 +2867,8 @@ static int __direct_map(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 		 * large page, as the leaf could be executable.
 		 */
 		if (nx_huge_page_workaround_enabled)
-			disallowed_hugepage_adjust(it, gfn, &pfn, &level);
+			disallowed_hugepage_adjust(*it.sptep, gfn, it.level,
+						   &pfn, &level);
 
 		base_gfn = gfn & ~(KVM_PAGES_PER_HPAGE(it.level) - 1);
 		if (it.level == level)
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 9a1a15f19beb..50e268eb8e1a 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -695,7 +695,8 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, gpa_t addr,
 		 * large page, as the leaf could be executable.
 		 */
 		if (nx_huge_page_workaround_enabled)
-			disallowed_hugepage_adjust(it, gw->gfn, &pfn, &level);
+			disallowed_hugepage_adjust(*it.sptep, gw->gfn, it.level,
+						   &pfn, &level);
 
 		base_gfn = gw->gfn & ~(KVM_PAGES_PER_HPAGE(it.level) - 1);
 		if (it.level == level)
-- 
2.26.2


