Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34DC12F3835
	for <lists+kvm@lfdr.de>; Tue, 12 Jan 2021 19:14:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406582AbhALSN5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jan 2021 13:13:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406278AbhALSMj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jan 2021 13:12:39 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 751DAC061347
        for <kvm@vger.kernel.org>; Tue, 12 Jan 2021 10:11:23 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id m7so2181438pjr.0
        for <kvm@vger.kernel.org>; Tue, 12 Jan 2021 10:11:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=UBoo2fCmFJGzXhXWYE7DtuvRH/Onu5tHDfHxpfcIjEQ=;
        b=aUsijLju1lhuBX60hyH4ICGlB8ruZdoEKm3mE8dJPzxs0NPqgwo3V/gWkLpNCDeTtU
         fvTTF1/hp9D/VdmMJUjWYz2GdfyWmFeW1Gt1QM6ddzXRvwhWyh/fXBjUVrhjakFYhK82
         XHAwC/6nUFmTVRYQYL4XBafuA1ChZGtHx7GKDBF24tLUhNEGd2G6ZL9p6PL5QnGnQCRx
         TXkwnAcgOcPcYetGo7huCPBPeMobo1WXZ0nRyOvgy6Eb/TLd5b2VEktBkSfgvwjccuNQ
         oKFTaNvpY54jeNbqraPzTdp3ZNrEMXQLma8VAYQOZn4wOSZC2R42C9GS8Q281YeC7C5v
         8gnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=UBoo2fCmFJGzXhXWYE7DtuvRH/Onu5tHDfHxpfcIjEQ=;
        b=LfL3K2o1B802J7LpN3nUddgai+khbOZ/m/mXrd9tKXi4yIHN+G6qmTVrfqa5ITIdSQ
         6P+vsVFzBdbnZLunnu9qll7mgE6jlOBMUIe1nlBDMAc2EHnIm5wfPUoCbAfREZ1Glbd4
         TH3Df/i5kd2NgEjSTY6EPtfHQM524A5I4UYtnNqE2qmQiP3ALuOAcndvjEefj1HdtJNJ
         2+8/6BYlMRx2+QoEaIZ0/CMPlMGfeKFGtd9FxYeEXYszWgLr6tyBDLbKwGkdeevGIyXC
         TFV5xwgDIi9MQUtZpJHPVrmzbpbxRFcJjEMyPCQjW8CNIVnLVbwsHOcVixz7Y/ivl0IU
         fipQ==
X-Gm-Message-State: AOAM531aq+c8W4k2BkIk8O54qUCj3rRqJkFn/lrtUbhvHZqoKsf9XBn3
        0EW2UrXXzjJokgNRSYOCEDOcEEDdaIom
X-Google-Smtp-Source: ABdhPJyY12528ymLrH01ojxqjlGYFXTeMg/eRaqEg67g5CdpZom5RuSfCb3BzBaby9wLlVlNG0h2mwxElr03
Sender: "bgardon via sendgmr" <bgardon@bgardon.sea.corp.google.com>
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:f693:9fff:fef4:a293])
 (user=bgardon job=sendgmr) by 2002:a17:902:7881:b029:de:2fb:99e with SMTP id
 q1-20020a1709027881b02900de02fb099emr302383pll.53.1610475082969; Tue, 12 Jan
 2021 10:11:22 -0800 (PST)
Date:   Tue, 12 Jan 2021 10:10:38 -0800
In-Reply-To: <20210112181041.356734-1-bgardon@google.com>
Message-Id: <20210112181041.356734-22-bgardon@google.com>
Mime-Version: 1.0
References: <20210112181041.356734-1-bgardon@google.com>
X-Mailer: git-send-email 2.30.0.284.gd98b1dd5eaa7-goog
Subject: [PATCH 21/24] kvm: x86/mmu: Use atomic ops to set SPTEs in TDP MMU map
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To prepare for handling page faults in parallel, change the TDP MMU
page fault handler to use atomic operations to set SPTEs so that changes
are not lost if multiple threads attempt to modify the same SPTE.

Reviewed-by: Peter Feiner <pfeiner@google.com>

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 38 ++++++++++++++++++++++----------------
 1 file changed, 22 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 1380ed313476..7b12a87a4124 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -714,21 +714,18 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu, int write,
 	int ret = 0;
 	int make_spte_ret = 0;
 
-	if (unlikely(is_noslot_pfn(pfn))) {
+	if (unlikely(is_noslot_pfn(pfn)))
 		new_spte = make_mmio_spte(vcpu, iter->gfn, ACC_ALL);
-		trace_mark_mmio_spte(iter->sptep, iter->gfn, new_spte);
-	} else {
+	else
 		make_spte_ret = make_spte(vcpu, ACC_ALL, iter->level, iter->gfn,
 					 pfn, iter->old_spte, prefault, true,
 					 map_writable, !shadow_accessed_mask,
 					 &new_spte);
-		trace_kvm_mmu_set_spte(iter->level, iter->gfn, iter->sptep);
-	}
 
 	if (new_spte == iter->old_spte)
 		ret = RET_PF_SPURIOUS;
-	else
-		tdp_mmu_set_spte(vcpu->kvm, iter, new_spte);
+	else if (!tdp_mmu_set_spte_atomic(vcpu->kvm, iter, new_spte))
+		return RET_PF_RETRY;
 
 	/*
 	 * If the page fault was caused by a write but the page is write
@@ -742,8 +739,11 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu, int write,
 	}
 
 	/* If a MMIO SPTE is installed, the MMIO will need to be emulated. */
-	if (unlikely(is_mmio_spte(new_spte)))
+	if (unlikely(is_mmio_spte(new_spte))) {
+		trace_mark_mmio_spte(iter->sptep, iter->gfn, new_spte);
 		ret = RET_PF_EMULATE;
+	} else
+		trace_kvm_mmu_set_spte(iter->level, iter->gfn, iter->sptep);
 
 	trace_kvm_mmu_set_spte(iter->level, iter->gfn, iter->sptep);
 	if (!prefault)
@@ -801,7 +801,8 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 		 */
 		if (is_shadow_present_pte(iter.old_spte) &&
 		    is_large_pte(iter.old_spte)) {
-			tdp_mmu_set_spte(vcpu->kvm, &iter, 0);
+			if (!tdp_mmu_set_spte_atomic(vcpu->kvm, &iter, 0))
+				break;
 
 			kvm_flush_remote_tlbs_with_address(vcpu->kvm, iter.gfn,
 					KVM_PAGES_PER_HPAGE(iter.level));
@@ -818,19 +819,24 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 			sp = alloc_tdp_mmu_page(vcpu, iter.gfn, iter.level);
 			child_pt = sp->spt;
 
-			tdp_mmu_link_page(vcpu->kvm, sp, false,
-					  huge_page_disallowed &&
-					  req_level >= iter.level);
-
 			new_spte = make_nonleaf_spte(child_pt,
 						     !shadow_accessed_mask);
 
-			trace_kvm_mmu_get_page(sp, true);
-			tdp_mmu_set_spte(vcpu->kvm, &iter, new_spte);
+			if (tdp_mmu_set_spte_atomic(vcpu->kvm, &iter,
+						    new_spte)) {
+				tdp_mmu_link_page(vcpu->kvm, sp, true,
+						  huge_page_disallowed &&
+						  req_level >= iter.level);
+
+				trace_kvm_mmu_get_page(sp, true);
+			} else {
+				tdp_mmu_free_sp(sp);
+				break;
+			}
 		}
 	}
 
-	if (WARN_ON(iter.level != level)) {
+	if (iter.level != level) {
 		rcu_read_unlock();
 		return RET_PF_RETRY;
 	}
-- 
2.30.0.284.gd98b1dd5eaa7-goog

