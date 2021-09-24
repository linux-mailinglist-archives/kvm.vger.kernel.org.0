Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B1ED4178BD
	for <lists+kvm@lfdr.de>; Fri, 24 Sep 2021 18:33:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347641AbhIXQei (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Sep 2021 12:34:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57580 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1347631AbhIXQdu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 24 Sep 2021 12:33:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632501137;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ShO+L7/AJFOxDIBUGfYK4hr3DWcOlyut9Lb0Cbs67AU=;
        b=P3FfVPtAqzn2Xi7+Q0Pujo0NMQxYVyJ7k22pTXl6Nijn4kG80TpK50r8l/Z5FlamInQtnZ
        FypV0T3ost2qhZVUr/eUHEOu6DcUhxaLL5h/9icJTX5EbmzVf/XMDF6+i4ZCcBKwMscPwR
        uOEKaxAfBC/PDUr0slU33UmUZKlE4Ek=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-203-sVUF0mX5NHGhM7qSAVt3Zw-1; Fri, 24 Sep 2021 12:32:13 -0400
X-MC-Unique: sVUF0mX5NHGhM7qSAVt3Zw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4A80EA0CBE;
        Fri, 24 Sep 2021 16:32:11 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1B5D75FC25;
        Fri, 24 Sep 2021 16:32:09 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     dmatlack@google.com, seanjc@google.com
Subject: [PATCH v3 28/31] KVM: MMU: pass struct kvm_page_fault to mmu_set_spte
Date:   Fri, 24 Sep 2021 12:31:49 -0400
Message-Id: <20210924163152.289027-29-pbonzini@redhat.com>
In-Reply-To: <20210924163152.289027-1-pbonzini@redhat.com>
References: <20210924163152.289027-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

mmu_set_spte is called for either PTE prefetching or page faults.  The
three boolean arguments write_fault, speculative and host_writable are
always respectively false/true/true for prefetching and coming from
a struct kvm_page_fault for page faults.

Let mmu_set_spte distinguish these two situation by accepting a
possibly NULL struct kvm_page_fault argument.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c         | 17 ++++++++++-------
 arch/x86/kvm/mmu/paging_tmpl.h | 13 +++----------
 2 files changed, 13 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index c208f001c302..4b304f60cf44 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2675,9 +2675,8 @@ int mmu_try_to_unsync_pages(struct kvm_vcpu *vcpu, gfn_t gfn, bool can_unsync,
 }
 
 static int mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
-			unsigned int pte_access, bool write_fault,
-			gfn_t gfn, kvm_pfn_t pfn, bool speculative,
-			bool host_writable)
+			unsigned int pte_access, gfn_t gfn,
+			kvm_pfn_t pfn, struct kvm_page_fault *fault)
 {
 	struct kvm_mmu_page *sp = sptep_to_sp(sptep);
 	int level = sp->role.level;
@@ -2687,6 +2686,11 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 	bool wrprot;
 	u64 spte;
 
+	/* Prefetching always gets a writable pfn.  */
+	bool host_writable = !fault || fault->map_writable;
+	bool speculative = !fault || fault->prefault;
+	bool write_fault = fault && fault->write;
+
 	pgprintk("%s: spte %llx write_fault %d gfn %llx\n", __func__,
 		 *sptep, write_fault, gfn);
 
@@ -2778,8 +2782,8 @@ static int direct_pte_prefetch_many(struct kvm_vcpu *vcpu,
 		return -1;
 
 	for (i = 0; i < ret; i++, gfn++, start++) {
-		mmu_set_spte(vcpu, start, access, false, gfn,
-			     page_to_pfn(pages[i]), true, true);
+		mmu_set_spte(vcpu, start, access, gfn,
+			     page_to_pfn(pages[i]), NULL);
 		put_page(pages[i]);
 	}
 
@@ -2981,8 +2985,7 @@ static int __direct_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 		return -EFAULT;
 
 	ret = mmu_set_spte(vcpu, it.sptep, ACC_ALL,
-			   fault->write, base_gfn, fault->pfn,
-			   fault->prefault, fault->map_writable);
+			   base_gfn, fault->pfn, fault);
 	if (ret == RET_PF_SPURIOUS)
 		return ret;
 
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index fbbaa3f5fb4e..8c07c42a4d73 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -578,13 +578,7 @@ FNAME(prefetch_gpte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	if (is_error_pfn(pfn))
 		return false;
 
-	/*
-	 * we call mmu_set_spte() with host_writable = true because
-	 * pte_prefetch_gfn_to_pfn always gets a writable pfn.
-	 */
-	mmu_set_spte(vcpu, spte, pte_access, false, gfn, pfn,
-		     true, true);
-
+	mmu_set_spte(vcpu, spte, pte_access, gfn, pfn, NULL);
 	kvm_release_pfn_clean(pfn);
 	return true;
 }
@@ -763,9 +757,8 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
 	if (WARN_ON_ONCE(it.level != fault->goal_level))
 		return -EFAULT;
 
-	ret = mmu_set_spte(vcpu, it.sptep, gw->pte_access, fault->write,
-			   base_gfn, fault->pfn, fault->prefault,
-			   fault->map_writable);
+	ret = mmu_set_spte(vcpu, it.sptep, gw->pte_access,
+			   base_gfn, fault->pfn, fault);
 	if (ret == RET_PF_SPURIOUS)
 		return ret;
 
-- 
2.27.0


