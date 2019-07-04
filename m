Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 466985F5A9
	for <lists+kvm@lfdr.de>; Thu,  4 Jul 2019 11:34:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727509AbfGDJdH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Jul 2019 05:33:07 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:38851 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727446AbfGDJdG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Jul 2019 05:33:06 -0400
Received: by mail-wm1-f66.google.com with SMTP id s15so5359599wmj.3;
        Thu, 04 Jul 2019 02:33:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vD2wscCUTIxvAcaXu6IxNc1J6EFhwYX7r/38KI9pR+A=;
        b=j0ZDqOUpfrhRUxEypZP6NYNfLcN5su/X3Se4lbNuQuCfLNkXqr5TLDcxY1vhd25xNq
         Ic1D0M+DucKf9HblggnpwDrKKCATcFdrQ7zgsdK09CTFodFE1bXbgjM5X2aoQkHmh21K
         2MbwjfkJzx55ws9QmVN526HKLwesuHmiJK2kWxMGzJZTjXFndOgKRVPJyb4n2nu0DVCl
         DIWMDl3a14dAgsVLgJ99pXSxBPw2DiMPlMgs0FCX5ngq4ye0OaGpStArVq8gpCzDiJND
         lq4Kn0UyWxaYAoV6KYTiuNeyUwH/7uQlIPbv7sC0agG5CHTyjaAiqlYmSq4zeHZ++nDP
         TbyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=vD2wscCUTIxvAcaXu6IxNc1J6EFhwYX7r/38KI9pR+A=;
        b=DejbJG1WF6uK0WI9hxSYl/PyRAg//G9i6iqbg+Ha3ZuLJOYqW6HFUHYevFGz0ntxCR
         VIvWl6N493W5UTMS/7ATQXb61sDqsL5ah2260wNglVZHGx7vnFl5+pETcc+2cQ/ef9sD
         Qf2ClW8qRMTJhf1Kum6UfI+L/LGl4OpdAOG643HemuMn+9ZY27wWC0MC0kVJcuMWEc3J
         Y3/MXjQ85sNiX+p6m+/nASm55cnzfY+Go9aPFF4zP65zsMGbHYG7VkY2hARA+lBhrFPM
         SYOUsOTpP8wILJEpHDmHK4OE+artO9BD22krbQ0Kqu+3CFnndb+pqU6UESfPJPnzMpeo
         +T1Q==
X-Gm-Message-State: APjAAAUL8sNxZ6VHHq0JB2ZgqcWawVTcZmfpfY5GVSSxOW3KjL9yG8Ao
        Wr3nPdF5AIXfjxhAnfjQ61V67yCFwmQ=
X-Google-Smtp-Source: APXvYqzuzhFqsgGVplP6ATDYoIicFVUCLYT7WgdWgZEfRZpkUpqfibtezWWUXoLWy9SvEpe9FaqCKQ==
X-Received: by 2002:a1c:2e09:: with SMTP id u9mr11819125wmu.137.1562232783514;
        Thu, 04 Jul 2019 02:33:03 -0700 (PDT)
Received: from donizetti.redhat.com (nat-pool-mxp-u.redhat.com. [149.6.153.187])
        by smtp.gmail.com with ESMTPSA id m9sm4868320wrn.92.2019.07.04.02.33.02
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 04 Jul 2019 02:33:02 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     sean.j.christopherson@intel.com, vkuznets@redhat.com
Subject: [PATCH 5/5] KVM: x86: add tracepoints around __direct_map and FNAME(fetch)
Date:   Thu,  4 Jul 2019 11:32:56 +0200
Message-Id: <20190704093256.12989-6-pbonzini@redhat.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190704093256.12989-1-pbonzini@redhat.com>
References: <20190704093256.12989-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

These are useful in debugging shadow paging.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu.c         | 13 ++++-----
 arch/x86/kvm/mmutrace.h    | 59 ++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/paging_tmpl.h |  2 ++
 3 files changed, 67 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 0629a89bb070..6248c39a33ef 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -143,9 +143,6 @@ module_param(dbg, bool, 0644);
 
 #include <trace/events/kvm.h>
 
-#define CREATE_TRACE_POINTS
-#include "mmutrace.h"
-
 #define SPTE_HOST_WRITEABLE	(1ULL << PT_FIRST_AVAIL_BITS_SHIFT)
 #define SPTE_MMU_WRITEABLE	(1ULL << (PT_FIRST_AVAIL_BITS_SHIFT + 1))
 
@@ -269,9 +266,13 @@ static u64 __read_mostly shadow_nonpresent_or_rsvd_lower_gfn_mask;
 static u8 __read_mostly shadow_phys_bits;
 
 static void mmu_spte_set(u64 *sptep, u64 spte);
+static bool is_executable_pte(u64 spte);
 static union kvm_mmu_page_role
 kvm_mmu_calc_root_page_role(struct kvm_vcpu *vcpu);
 
+#define CREATE_TRACE_POINTS
+#include "mmutrace.h"
+
 
 static inline bool kvm_available_flush_tlb_with_range(void)
 {
@@ -3086,10 +3087,7 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep, unsigned pte_access,
 		ret = RET_PF_EMULATE;
 
 	pgprintk("%s: setting spte %llx\n", __func__, *sptep);
-	pgprintk("instantiating %s PTE (%s) at %llx (%llx) addr %p\n",
-		 is_large_pte(*sptep)? "2MB" : "4kB",
-		 *sptep & PT_WRITABLE_MASK ? "RW" : "R", gfn,
-		 *sptep, sptep);
+	trace_kvm_mmu_set_spte(level, gfn, sptep);
 	if (!was_rmapped && is_large_pte(*sptep))
 		++vcpu->kvm->stat.lpages;
 
@@ -3200,6 +3198,7 @@ static int __direct_map(struct kvm_vcpu *vcpu, gpa_t gpa, int write,
 	if (!VALID_PAGE(vcpu->arch.mmu->root_hpa))
 		return RET_PF_RETRY;
 
+	trace_kvm_mmu_spte_requested(gpa, level, pfn);
 	for_each_shadow_entry(vcpu, gpa, it) {
 		base_gfn = gfn & ~(KVM_PAGES_PER_HPAGE(it.level) - 1);
 		if (it.level == level)
diff --git a/arch/x86/kvm/mmutrace.h b/arch/x86/kvm/mmutrace.h
index dd30dccd2ad5..d8001b4bca05 100644
--- a/arch/x86/kvm/mmutrace.h
+++ b/arch/x86/kvm/mmutrace.h
@@ -301,6 +301,65 @@ TRACE_EVENT(
 		  __entry->kvm_gen == __entry->spte_gen
 	)
 );
+
+TRACE_EVENT(
+	kvm_mmu_set_spte,
+	TP_PROTO(int level, gfn_t gfn, u64 *sptep),
+	TP_ARGS(level, gfn, sptep),
+
+	TP_STRUCT__entry(
+		__field(u64, gfn)
+		__field(u64, spte)
+		__field(u64, sptep)
+		__field(u8, level)
+		/* These depend on page entry type, so compute them now.  */
+		__field(bool, r)
+		__field(bool, x)
+		__field(u8, u)
+	),
+
+	TP_fast_assign(
+		__entry->gfn = gfn;
+		__entry->spte = *sptep;
+		__entry->sptep = virt_to_phys(sptep);
+		__entry->level = level;
+		__entry->r = shadow_present_mask || (__entry->spte & PT_PRESENT_MASK);
+		__entry->x = is_executable_pte(__entry->spte);
+		__entry->u = shadow_user_mask ? !!(__entry->spte & shadow_user_mask) : -1;
+	),
+
+	TP_printk("gfn %llx spte %llx (%s%s%s%s) level %d at %llx",
+		  __entry->gfn, __entry->spte,
+		  __entry->r ? "r" : "-",
+		  __entry->spte & PT_WRITABLE_MASK ? "w" : "-",
+		  __entry->x ? "x" : "-",
+		  __entry->u == -1 ? "" : (__entry->u ? "u" : "-"),
+		  __entry->level, __entry->sptep
+	)
+);
+
+TRACE_EVENT(
+	kvm_mmu_spte_requested,
+	TP_PROTO(gpa_t addr, int level, kvm_pfn_t pfn),
+	TP_ARGS(addr, level, pfn),
+
+	TP_STRUCT__entry(
+		__field(u64, gfn)
+		__field(u64, pfn)
+		__field(u8, level)
+	),
+
+	TP_fast_assign(
+		__entry->gfn = addr >> PAGE_SHIFT;
+		__entry->pfn = pfn | (__entry->gfn & (KVM_PAGES_PER_HPAGE(level) - 1));
+		__entry->level = level;
+	),
+
+	TP_printk("gfn %llx pfn %llx level %d",
+		  __entry->gfn, __entry->pfn, __entry->level
+	)
+);
+
 #endif /* _TRACE_KVMMMU_H */
 
 #undef TRACE_INCLUDE_PATH
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index f39b381a8b88..e9d110fdcb8e 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -670,6 +670,8 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
 
 	base_gfn = gw->gfn;
 
+	trace_kvm_mmu_spte_requested(addr, gw->level, pfn);
+
 	for (; shadow_walk_okay(&it); shadow_walk_next(&it)) {
 		clear_sp_write_flooding_count(it.sptep);
 		base_gfn = gw->gfn & ~(KVM_PAGES_PER_HPAGE(it.level) - 1);
-- 
2.21.0

