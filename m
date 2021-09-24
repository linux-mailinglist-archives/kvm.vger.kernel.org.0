Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B286C41789D
	for <lists+kvm@lfdr.de>; Fri, 24 Sep 2021 18:32:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347600AbhIXQds (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Sep 2021 12:33:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:46314 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1347495AbhIXQdk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 24 Sep 2021 12:33:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632501126;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oMd3mlble1sarM4+p7fceRGA3xM2nIsoq7CZoA8zc+Y=;
        b=TfdSGjmSPFVG+A3EcAJ+0vo0/BM1Tv/p86QK3PRsJjzqIgwXgoc9PhPK8SNP/8zsjK15V7
        6GYhB92XX8CzdsT8AkAS99wCKHvZQrap2RglZGUf9+zYQ6XJIcu0+QH/8CRt8Sa/6zfW9V
        jzDZkXFVTvn+BdPQ5k8KQCfI2fVZ0WU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-19-dRII3_NlMy-VPUttO-NsEg-1; Fri, 24 Sep 2021 12:32:03 -0400
X-MC-Unique: dRII3_NlMy-VPUttO-NsEg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0CBE610168C3;
        Fri, 24 Sep 2021 16:32:02 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9EC8060E1C;
        Fri, 24 Sep 2021 16:32:01 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     dmatlack@google.com, seanjc@google.com
Subject: [PATCH v3 15/31] KVM: MMU: change tracepoints arguments to kvm_page_fault
Date:   Fri, 24 Sep 2021 12:31:36 -0400
Message-Id: <20210924163152.289027-16-pbonzini@redhat.com>
In-Reply-To: <20210924163152.289027-1-pbonzini@redhat.com>
References: <20210924163152.289027-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Pass struct kvm_page_fault to tracepoints instead of extracting the
arguments from the struct.  This also lets the kvm_mmu_spte_requested
tracepoint pick the gfn directly from fault->gfn, instead of using
the address.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c         |  4 ++--
 arch/x86/kvm/mmu/mmutrace.h    | 18 +++++++++---------
 arch/x86/kvm/mmu/paging_tmpl.h |  2 +-
 arch/x86/kvm/mmu/tdp_mmu.c     |  2 +-
 4 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 7491dc685842..5ba0a844f576 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2986,7 +2986,7 @@ static int __direct_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 
 	kvm_mmu_hugepage_adjust(vcpu, fault);
 
-	trace_kvm_mmu_spte_requested(fault->addr, fault->goal_level, fault->pfn);
+	trace_kvm_mmu_spte_requested(fault);
 	for_each_shadow_entry(vcpu, fault->addr, it) {
 		/*
 		 * We cannot overwrite existing page tables with an NX
@@ -3276,7 +3276,7 @@ static int fast_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 
 	} while (true);
 
-	trace_fast_page_fault(vcpu, fault->addr, fault->error_code, sptep, spte, ret);
+	trace_fast_page_fault(vcpu, fault, sptep, spte, ret);
 	walk_shadow_page_lockless_end(vcpu);
 
 	return ret;
diff --git a/arch/x86/kvm/mmu/mmutrace.h b/arch/x86/kvm/mmu/mmutrace.h
index 2924a4081a19..b8151bbca36a 100644
--- a/arch/x86/kvm/mmu/mmutrace.h
+++ b/arch/x86/kvm/mmu/mmutrace.h
@@ -252,9 +252,9 @@ TRACE_EVENT(
 
 TRACE_EVENT(
 	fast_page_fault,
-	TP_PROTO(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u32 error_code,
+	TP_PROTO(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
 		 u64 *sptep, u64 old_spte, int ret),
-	TP_ARGS(vcpu, cr2_or_gpa, error_code, sptep, old_spte, ret),
+	TP_ARGS(vcpu, fault, sptep, old_spte, ret),
 
 	TP_STRUCT__entry(
 		__field(int, vcpu_id)
@@ -268,8 +268,8 @@ TRACE_EVENT(
 
 	TP_fast_assign(
 		__entry->vcpu_id = vcpu->vcpu_id;
-		__entry->cr2_or_gpa = cr2_or_gpa;
-		__entry->error_code = error_code;
+		__entry->cr2_or_gpa = fault->addr;
+		__entry->error_code = fault->error_code;
 		__entry->sptep = sptep;
 		__entry->old_spte = old_spte;
 		__entry->new_spte = *sptep;
@@ -367,8 +367,8 @@ TRACE_EVENT(
 
 TRACE_EVENT(
 	kvm_mmu_spte_requested,
-	TP_PROTO(gpa_t addr, int level, kvm_pfn_t pfn),
-	TP_ARGS(addr, level, pfn),
+	TP_PROTO(struct kvm_page_fault *fault),
+	TP_ARGS(fault),
 
 	TP_STRUCT__entry(
 		__field(u64, gfn)
@@ -377,9 +377,9 @@ TRACE_EVENT(
 	),
 
 	TP_fast_assign(
-		__entry->gfn = addr >> PAGE_SHIFT;
-		__entry->pfn = pfn | (__entry->gfn & (KVM_PAGES_PER_HPAGE(level) - 1));
-		__entry->level = level;
+		__entry->gfn = fault->gfn;
+		__entry->pfn = fault->pfn | (fault->gfn & (KVM_PAGES_PER_HPAGE(fault->goal_level) - 1));
+		__entry->level = fault->goal_level;
 	),
 
 	TP_printk("gfn %llx pfn %llx level %d",
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 4a263f4511a5..6bc0dbc0baff 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -730,7 +730,7 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
 
 	kvm_mmu_hugepage_adjust(vcpu, fault);
 
-	trace_kvm_mmu_spte_requested(fault->addr, gw->level, fault->pfn);
+	trace_kvm_mmu_spte_requested(fault);
 
 	for (; shadow_walk_okay(&it); shadow_walk_next(&it)) {
 		clear_sp_write_flooding_count(it.sptep);
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 737af596adaf..3bf85a8c7d15 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -995,7 +995,7 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 
 	kvm_mmu_hugepage_adjust(vcpu, fault);
 
-	trace_kvm_mmu_spte_requested(fault->addr, fault->goal_level, fault->pfn);
+	trace_kvm_mmu_spte_requested(fault);
 
 	rcu_read_lock();
 
-- 
2.27.0


