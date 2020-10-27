Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D49FF29C4EE
	for <lists+kvm@lfdr.de>; Tue, 27 Oct 2020 19:08:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1823940AbgJ0SA7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Oct 2020 14:00:59 -0400
Received: from mail-pj1-f74.google.com ([209.85.216.74]:55818 "EHLO
        mail-pj1-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1823703AbgJ0R7s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Oct 2020 13:59:48 -0400
Received: by mail-pj1-f74.google.com with SMTP id r1so1206096pjp.5
        for <kvm@vger.kernel.org>; Tue, 27 Oct 2020 10:59:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=ZbaL988uKrohM7H6ZS9XBC1GZUReqphtGwoVjHruBgI=;
        b=ETkQP5HGCh/KwMlK6Oa4F6JkS2Vrb4/abSeRSBvhnNdoh7fS6XT3reiyLt2vKVEC0z
         M9iipXbsW21hYHi4VY4x6NVg9OXjZAUZPAZnHb7jYSlaf4x1ZFfY0FUxi1xSxbrBP5f/
         +F5/GDtp3fd8zI9NK/53rWJ6NJurivwnp9kVLRvzrui/mQTKomi0YHubwm/FCoviFIT3
         Ozgg0HEh4WKWyKEIjr4VumLXFvyuC1skb2uVBq/lkf46H/hvZAtgFyg17x/qvSZkyUsF
         8ZTcFNbTXGcZI883jiYK3JocvhaDa/1CI4lDm53uHpwtHEkWyzhHpBepYSwTuTlQw8uo
         ArSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=ZbaL988uKrohM7H6ZS9XBC1GZUReqphtGwoVjHruBgI=;
        b=lmBDTy3d7H0skHwRVMTU5znPLmH2EFZwZ8TsnNMDcsD1TCMQDHFpEjg/z3OmCSIlVU
         E4n1vQ969SlPZd+a3i3cIH6zf3GDqIj6bKT6BbB6h/ZaSdfXlgz4EFFXCHGioabu73yv
         JPL1LqcwaXE976ajrah0IbZOhRH5L9b+1sH2+cXAjjANbAYnU4H4ckOTpFwWLqYu83j7
         fQuySBjCR+RPQiILNhyA/t7lo1dau+Q7f1bRbZ9BxgQiIewJlaVmYvNrh6Nt4FNc0LZ2
         v6VIytEoKJtrRC5nwEhOf6hjPCleFi7EVphQnlWsGlbY3fzHDWMmKCTXWpZwXuqmNgm7
         U3dw==
X-Gm-Message-State: AOAM53073pYo/B61m4hUvFNiSiq7+jwC6XgDYumgEENDToGgqIfRjGC/
        vgZqzmefTNIB+x4Ig2CJW1NmE2NLnjJ/
X-Google-Smtp-Source: ABdhPJxHHWvVxLU1UFqepNXpxQRVm0nystR88ugkX/J00ithmflQf37LyJF5KikOJDXp10J+BKeVZjWT3LcQ
Sender: "bgardon via sendgmr" <bgardon@bgardon.sea.corp.google.com>
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:f693:9fff:fef4:a293])
 (user=bgardon job=sendgmr) by 2002:a17:90b:f85:: with SMTP id
 ft5mr266022pjb.1.1603821587576; Tue, 27 Oct 2020 10:59:47 -0700 (PDT)
Date:   Tue, 27 Oct 2020 10:59:43 -0700
Message-Id: <20201027175944.1183301-1-bgardon@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.29.0.rc2.309.g374f81d7ae-goog
Subject: [PATCH 1/2] kvm: x86/mmu: Add existing trace points to TDP MMU
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Peter Shier <pshier@google.com>,
        Junaid Shahid <junaids@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The TDP MMU was initially implemented without some of the usual
tracepoints found in mmu.c. Correct this discrepancy by adding the
missing trace points to the TDP MMU.

Tested: ran the demand paging selftest on an Intel Skylake machine with
	all the trace points used by the TDP MMU enabled and observed
	them firing with expected values.

This patch can be viewed in Gerrit at:
https://linux-review.googlesource.com/c/virt/kvm/kvm/+/3812

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 27e381c9da6c2..047e2d966abef 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -7,6 +7,8 @@
 #include "tdp_mmu.h"
 #include "spte.h"
 
+#include <trace/events/kvm.h>
+
 #ifdef CONFIG_X86_64
 static bool __read_mostly tdp_mmu_enabled = false;
 module_param_named(tdp_mmu, tdp_mmu_enabled, bool, 0644);
@@ -101,6 +103,8 @@ static struct kvm_mmu_page *alloc_tdp_mmu_page(struct kvm_vcpu *vcpu, gfn_t gfn,
 	sp->gfn = gfn;
 	sp->tdp_mmu_page = true;
 
+	trace_kvm_mmu_get_page(sp, true);
+
 	return sp;
 }
 
@@ -271,6 +275,8 @@ static void __handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
 		pt = spte_to_child_pt(old_spte, level);
 		sp = sptep_to_sp(pt);
 
+		trace_kvm_mmu_prepare_zap_page(sp);
+
 		list_del(&sp->link);
 
 		if (sp->lpage_disallowed)
@@ -473,11 +479,13 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu, int write,
 	if (unlikely(is_noslot_pfn(pfn))) {
 		new_spte = make_mmio_spte(vcpu, iter->gfn, ACC_ALL);
 		trace_mark_mmio_spte(iter->sptep, iter->gfn, new_spte);
-	} else
+	} else {
 		make_spte_ret = make_spte(vcpu, ACC_ALL, iter->level, iter->gfn,
 					 pfn, iter->old_spte, prefault, true,
 					 map_writable, !shadow_accessed_mask,
 					 &new_spte);
+		trace_kvm_mmu_set_spte(iter->level, iter->gfn, iter->sptep);
+	}
 
 	if (new_spte == iter->old_spte)
 		ret = RET_PF_SPURIOUS;
@@ -691,6 +699,8 @@ static int age_gfn_range(struct kvm *kvm, struct kvm_memory_slot *slot,
 
 		tdp_mmu_set_spte_no_acc_track(kvm, &iter, new_spte);
 		young = 1;
+
+		trace_kvm_age_page(iter.gfn, iter.level, slot, young);
 	}
 
 	return young;
-- 
2.29.0.rc2.309.g374f81d7ae-goog

