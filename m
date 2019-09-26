Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FF6EBFBDF
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2019 01:19:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729072AbfIZXT2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Sep 2019 19:19:28 -0400
Received: from mail-pl1-f202.google.com ([209.85.214.202]:54810 "EHLO
        mail-pl1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729073AbfIZXT2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Sep 2019 19:19:28 -0400
Received: by mail-pl1-f202.google.com with SMTP id j9so453609plk.21
        for <kvm@vger.kernel.org>; Thu, 26 Sep 2019 16:19:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=JfDeLVxckSbuxvoobfrDn0KoCHmXdzom4g1j7usnEf8=;
        b=irIWD+rb7q97rYKemG2B/3ZPawfdoH6L4aaUTkeipkVYAmZGB5pn3p8/VoHyMJHviU
         d4UKYVfL/oQIqnPIkd+ieV1wk0I+QfATqBVHIrswjG5F1akSR3Z2yKKKRnorGzW//3ee
         AbooL3rflLP7OORaxz4uJ3D0clgEj4OCwPdDru7j8bdcI3ybiar1xoJ3ev8rcdUf3eFY
         KjBnJHaXZNeT8aYYSbkvZjkK0p4d7N1MqQjcU1lkNNvltzC+WPJg4XHJBAFjEQC/0rx7
         8sS2/ZII9X5Laycf/GqllgxrbhdPofuyTYoEitzDBSsoGbk+MUdovt5ILPLVUrCFEJBL
         4ZwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=JfDeLVxckSbuxvoobfrDn0KoCHmXdzom4g1j7usnEf8=;
        b=bOo+/BlTZlcL3PIoJXvtOqfBXoQtpDxLzs494Ff98tl/reCXPkImX7QN7dKsNZAnyU
         uIqPo8GMQ2blBOEQD8OV6flgWfk2pzfit95g4Kk07VdnCn1HrqgBKzzM6EH7lNzPQ2N5
         VGZRKEJzKRde8dO93H1yncMrsCyENYyFfU0IrhB843sTYQsSackp3URRoOc2YfnY+Ojl
         nkYzsGNS08ffoa0JpQgrI7HDG76EYRtoi/wsVXgfAWnJ3GfiW1fw+lDmOned745/al6L
         DxFdkIYDSuXSFgfnZj3xz7Y3AvnIkkHUfuvFBlAXifQDs/egmAETwZ8qc5Ys3u03UO8R
         vQ5g==
X-Gm-Message-State: APjAAAUSCVOskZdqtXeE3kpXUDLkP08SnmPOvaLzB6a5h0nHDJev9cFJ
        VjEqychIhAdB9Yr1824C8B3Ordm4Cf8NljfsQdz/ZcccxK4syUqK+vqRJmZkTVYMJHmqZN4MEa/
        l0xY/OFboVZ45w47wl3BXqqKZ+nGrhXff8JZ9lSfOam6UE+E0dEnfV/GuOHPi
X-Google-Smtp-Source: APXvYqycUacQUNFjaesE8Ugk2g3b1EDiUnQse53R0VirEk/9laIBFfgjEKQJxlkUEZ0XZ+n9G3U1buoDFD3l
X-Received: by 2002:a63:4857:: with SMTP id x23mr6080652pgk.142.1569539967277;
 Thu, 26 Sep 2019 16:19:27 -0700 (PDT)
Date:   Thu, 26 Sep 2019 16:18:22 -0700
In-Reply-To: <20190926231824.149014-1-bgardon@google.com>
Message-Id: <20190926231824.149014-27-bgardon@google.com>
Mime-Version: 1.0
References: <20190926231824.149014-1-bgardon@google.com>
X-Mailer: git-send-email 2.23.0.444.g18eeb5a265-goog
Subject: [RFC PATCH 26/28] kvm: mmu: Integrate direct MMU with nesting
From:   Ben Gardon <bgardon@google.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Peter Feiner <pfeiner@google.com>,
        Peter Shier <pshier@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Allows the existing nesting implementation to interoperate with the
direct MMU.

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu.c | 51 ++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 45 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index a0c5271ae2381..e0f35da0d1027 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2742,6 +2742,29 @@ void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
 		kvm_mmu_write_protect_pt_masked(kvm, slot, gfn_offset, mask);
 }
 
+static bool rmap_write_protect_direct_gfn(struct kvm *kvm,
+					  struct kvm_memory_slot *slot,
+					  gfn_t gfn)
+{
+	struct direct_walk_iterator iter;
+	u64 new_pte;
+
+	direct_walk_iterator_setup_walk(&iter, kvm, slot->as_id, gfn, gfn + 1,
+					MMU_WRITE_LOCK);
+	while (direct_walk_iterator_next_present_leaf_pte(&iter)) {
+		if (!is_writable_pte(iter.old_pte) &&
+		    !spte_can_locklessly_be_made_writable(iter.old_pte))
+			break;
+
+		new_pte = iter.old_pte &
+			~(PT_WRITABLE_MASK | SPTE_MMU_WRITEABLE);
+
+		if (!direct_walk_iterator_set_pte(&iter, new_pte))
+			continue;
+	}
+	return direct_walk_iterator_end_traversal(&iter);
+}
+
 /**
  * kvm_arch_write_log_dirty - emulate dirty page logging
  * @vcpu: Guest mode vcpu
@@ -2764,6 +2787,10 @@ bool kvm_mmu_slot_gfn_write_protect(struct kvm *kvm,
 	int i;
 	bool write_protected = false;
 
+	if (kvm->arch.direct_mmu_enabled)
+		write_protected |= rmap_write_protect_direct_gfn(kvm, slot,
+								 gfn);
+
 	for (i = PT_PAGE_TABLE_LEVEL; i <= PT_MAX_HUGEPAGE_LEVEL; ++i) {
 		rmap_head = __gfn_to_rmap(gfn, i, slot);
 		write_protected |= __rmap_write_protect(kvm, rmap_head, true);
@@ -5755,6 +5782,8 @@ static bool cached_root_available(struct kvm_vcpu *vcpu, gpa_t new_cr3,
 	uint i;
 	struct kvm_mmu_root_info root;
 	struct kvm_mmu *mmu = vcpu->arch.mmu;
+	bool direct_mmu_root = (vcpu->kvm->arch.direct_mmu_enabled &&
+				new_role.direct);
 
 	root.cr3 = mmu->root_cr3;
 	root.hpa = mmu->root_hpa;
@@ -5762,10 +5791,14 @@ static bool cached_root_available(struct kvm_vcpu *vcpu, gpa_t new_cr3,
 	for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++) {
 		swap(root, mmu->prev_roots[i]);
 
-		if (new_cr3 == root.cr3 && VALID_PAGE(root.hpa) &&
-		    page_header(root.hpa) != NULL &&
-		    new_role.word == page_header(root.hpa)->role.word)
-			break;
+		if (new_cr3 == root.cr3 && VALID_PAGE(root.hpa)) {
+			BUG_ON(direct_mmu_root &&
+				!is_direct_mmu_root(vcpu->kvm, root.hpa));
+
+			if (direct_mmu_root || (page_header(root.hpa) != NULL &&
+			    new_role.word == page_header(root.hpa)->role.word))
+				break;
+		}
 	}
 
 	mmu->root_hpa = root.hpa;
@@ -5813,8 +5846,14 @@ static bool fast_cr3_switch(struct kvm_vcpu *vcpu, gpa_t new_cr3,
 			 */
 			vcpu_clear_mmio_info(vcpu, MMIO_GVA_ANY);
 
-			__clear_sp_write_flooding_count(
-				page_header(mmu->root_hpa));
+			/*
+			 * If this is a direct MMU root page, it doesn't have a
+			 * write flooding count.
+			 */
+			if (!(vcpu->kvm->arch.direct_mmu_enabled &&
+			      new_role.direct))
+				__clear_sp_write_flooding_count(
+						page_header(mmu->root_hpa));
 
 			return true;
 		}
-- 
2.23.0.444.g18eeb5a265-goog

