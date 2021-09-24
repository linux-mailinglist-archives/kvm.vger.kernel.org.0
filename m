Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BB464178AF
	for <lists+kvm@lfdr.de>; Fri, 24 Sep 2021 18:33:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347816AbhIXQeQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Sep 2021 12:34:16 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34603 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1347558AbhIXQdo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 24 Sep 2021 12:33:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632501131;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qd7uH3Dy1pjgoohcxNMZVPPJGZvTh/ePOy5CzEuffw0=;
        b=TbuBeoOLh7xl2lYIt3rDMrFY2o/O/yA2lE5Nmnr3dto9bYZvpVO3/rS7qchZHDN4f4+VdC
        B3cMhCLtK8WeFg44w05y2VLgW2uPh09nBm7T4cZnfl/THGtDSAG5L6IWUUT2xlLATZ7MKD
        OG100v19zf4iRHVbj9lThbuIA8Pe1v0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-241-RY1TDW8sMBeO3Tb37P8_ug-1; Fri, 24 Sep 2021 12:32:09 -0400
X-MC-Unique: RY1TDW8sMBeO3Tb37P8_ug-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3182C1015209;
        Fri, 24 Sep 2021 16:32:08 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 81299794B1;
        Fri, 24 Sep 2021 16:32:07 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     dmatlack@google.com, seanjc@google.com
Subject: [PATCH v3 25/31] KVM: MMU: remove unnecessary argument to mmu_set_spte
Date:   Fri, 24 Sep 2021 12:31:46 -0400
Message-Id: <20210924163152.289027-26-pbonzini@redhat.com>
In-Reply-To: <20210924163152.289027-1-pbonzini@redhat.com>
References: <20210924163152.289027-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The level of the new SPTE can be found in the kvm_mmu_page struct; there
is no need to pass it down.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c         | 7 ++++---
 arch/x86/kvm/mmu/paging_tmpl.h | 6 +++---
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index dcbe7df2f890..91303006faaf 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2675,11 +2675,12 @@ int mmu_try_to_unsync_pages(struct kvm_vcpu *vcpu, gfn_t gfn, bool can_unsync,
 }
 
 static int mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
-			unsigned int pte_access, bool write_fault, int level,
+			unsigned int pte_access, bool write_fault,
 			gfn_t gfn, kvm_pfn_t pfn, bool speculative,
 			bool host_writable)
 {
 	struct kvm_mmu_page *sp = sptep_to_sp(sptep);
+	int level = sp->role.level;
 	int was_rmapped = 0;
 	int ret = RET_PF_FIXED;
 	bool flush = false;
@@ -2777,7 +2778,7 @@ static int direct_pte_prefetch_many(struct kvm_vcpu *vcpu,
 		return -1;
 
 	for (i = 0; i < ret; i++, gfn++, start++) {
-		mmu_set_spte(vcpu, start, access, false, sp->role.level, gfn,
+		mmu_set_spte(vcpu, start, access, false, gfn,
 			     page_to_pfn(pages[i]), true, true);
 		put_page(pages[i]);
 	}
@@ -2980,7 +2981,7 @@ static int __direct_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 		return -EFAULT;
 
 	ret = mmu_set_spte(vcpu, it.sptep, ACC_ALL,
-			   fault->write, fault->goal_level, base_gfn, fault->pfn,
+			   fault->write, base_gfn, fault->pfn,
 			   fault->prefault, fault->map_writable);
 	if (ret == RET_PF_SPURIOUS)
 		return ret;
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 500962dceda0..7f2c6eeed04f 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -582,7 +582,7 @@ FNAME(prefetch_gpte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	 * we call mmu_set_spte() with host_writable = true because
 	 * pte_prefetch_gfn_to_pfn always gets a writable pfn.
 	 */
-	mmu_set_spte(vcpu, spte, pte_access, false, PG_LEVEL_4K, gfn, pfn,
+	mmu_set_spte(vcpu, spte, pte_access, false, gfn, pfn,
 		     true, true);
 
 	kvm_release_pfn_clean(pfn);
@@ -764,8 +764,8 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
 		return -EFAULT;
 
 	ret = mmu_set_spte(vcpu, it.sptep, gw->pte_access, fault->write,
-			   fault->goal_level, base_gfn, fault->pfn,
-			   fault->prefault, fault->map_writable);
+			   base_gfn, fault->pfn, fault->prefault,
+			   fault->map_writable);
 	if (ret == RET_PF_SPURIOUS)
 		return ret;
 
-- 
2.27.0


