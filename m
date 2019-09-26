Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51941BFBD5
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2019 01:19:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729050AbfIZXTI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Sep 2019 19:19:08 -0400
Received: from mail-pg1-f202.google.com ([209.85.215.202]:48379 "EHLO
        mail-pg1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729025AbfIZXTH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Sep 2019 19:19:07 -0400
Received: by mail-pg1-f202.google.com with SMTP id w13so2335249pge.15
        for <kvm@vger.kernel.org>; Thu, 26 Sep 2019 16:19:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=6mS1NA7D3Okqq6Iz6AwG0BJcrsajspJtR6LdvWfB7Lo=;
        b=NXrdMUZLcOYiwUyyAvHAkgcbbBICcwIV4StGAmANm1xk2TkvXzY/SQKiAT92scZ4xE
         0IIwF/tzMQDMS/IIWImbctunYnzeEywBp+oQ46OFICzzRrD7L0EKqLcwRoWN2oAYpNE/
         gDnLrYDBL9ZN4ZbwDsGO/sL4UrJmgtfniBL1tL9vLwumWn4KbR2YISGkg3emJHiSUxB+
         pkKwM8qtd9isz6B51cCyCra1FMwLaG9HpKpBQ/ag0baBJ8e1O5/KIZvlJHoFZkklLylE
         Wmb0GCxYFfM7mn7xaqcf5cNV8W56bb8SxfcquXR+lgXDU/7FcApJSrOvsXcyAg0AQJlN
         W0Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=6mS1NA7D3Okqq6Iz6AwG0BJcrsajspJtR6LdvWfB7Lo=;
        b=LawUQeD040lpnwQdDtVKHhqPMEgvYb2qJjXdyYXmhU8bZPklnlcg5vYKFvnJs2Igp1
         uNgK5dUHmRfqTMXIHc1ttK8+HzEnKeOLu0la8GhJEW7Seyu1yWsv9GOtwBC5uZ+9DNp1
         7ePqz9B/0M6qcEoBzgFWHSh9fqDsRjVgazGhXMurdccmfx7LE3+E9omcmtduYbXQEhsJ
         OJVChyVwtpkjXiJTUZNo3Jar0gVPl0OsooDmvfyQMtaSe4lFAR08jvKGyvTW01CjOGke
         bFF33TGvaSe18iG54XJIU+ACrqOPNTxdLX/a3XdslFTcsgg1F2V6PQoPvLaUBnVvlSGZ
         E5rA==
X-Gm-Message-State: APjAAAXu8hIW/6nnZvE/Dzh+1ncaZUv56qP1FTfRaEnBRZUlXFkqh8Tb
        YHqB74P5GY4H0PDiiwYbrnHVFAmPOj3B0KIHNnqbmOBP3PbgHF3tI4Hnf7cdp+1z58YGuiYm4B7
        u22M7tQrTxKnTJEo8eFzySt+t4ehjQIePXIPjqrlAaKONVli7thYVzjo+um0p
X-Google-Smtp-Source: APXvYqx/Xado94oyi45O1zbfaUB6hKPsTb/DmCxwDWimZIiRiwG+fLEo+LMV0XrgDzGOQ0JdHVx5PDaaj3wf
X-Received: by 2002:a63:3f46:: with SMTP id m67mr6125465pga.146.1569539946408;
 Thu, 26 Sep 2019 16:19:06 -0700 (PDT)
Date:   Thu, 26 Sep 2019 16:18:13 -0700
In-Reply-To: <20190926231824.149014-1-bgardon@google.com>
Message-Id: <20190926231824.149014-18-bgardon@google.com>
Mime-Version: 1.0
References: <20190926231824.149014-1-bgardon@google.com>
X-Mailer: git-send-email 2.23.0.444.g18eeb5a265-goog
Subject: [RFC PATCH 17/28] kvm: mmu: Add direct MMU fast page fault handler
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

While the direct MMU can handle page faults much faster than the
existing implementation, it cannot handle faults caused by write
protection or access tracking as quickly. Add a fast path similar to the
existing fast path to handle these cases without the MMU read lock or
calls to get_user_pages.

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu.c | 93 +++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 92 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index f3a26a32c8174..3d4a78f2461a9 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -4490,6 +4490,93 @@ static bool fast_page_fault(struct kvm_vcpu *vcpu, gva_t gva, int level,
 	return fault_handled;
 }
 
+/*
+ * Attempt to handle a page fault without the use of get_user_pages, or
+ * acquiring the MMU lock. This function can handle page faults resulting from
+ * missing permissions on a PTE, set up by KVM for dirty logging or access
+ * tracking.
+ *
+ * Return value:
+ * - true: The page fault may have been fixed by this function. Let the vCPU
+ *	   access on the same address again.
+ * - false: This function cannot handle the page fault. Let the full page fault
+ *	    path fix it.
+ */
+static bool fast_direct_page_fault(struct kvm_vcpu *vcpu, gva_t gpa, int level,
+				   u32 error_code)
+{
+	struct direct_walk_iterator iter;
+	bool fault_handled = false;
+	bool remove_write_prot;
+	bool remove_acc_track;
+	u64 new_pte;
+
+	if (!VALID_PAGE(vcpu->arch.mmu->root_hpa))
+		return false;
+
+	if (!page_fault_can_be_fast(error_code))
+		return false;
+
+	direct_walk_iterator_setup_walk(&iter, vcpu->kvm,
+			kvm_arch_vcpu_memslots_id(vcpu), gpa >> PAGE_SHIFT,
+			(gpa >> PAGE_SHIFT) + 1, MMU_NO_LOCK);
+	while (direct_walk_iterator_next_present_leaf_pte(&iter)) {
+		remove_write_prot = (error_code & PFERR_WRITE_MASK);
+		remove_write_prot &= !(iter.old_pte & PT_WRITABLE_MASK);
+		remove_write_prot &= spte_can_locklessly_be_made_writable(
+				iter.old_pte);
+
+		remove_acc_track = is_access_track_spte(iter.old_pte);
+
+		/* Verify that the fault can be handled in the fast path */
+		if (!remove_acc_track && !remove_write_prot)
+			break;
+
+		/*
+		 * If dirty logging is enabled:
+		 *
+		 * Do not fix write-permission on the large spte since we only
+		 * dirty the first page into the dirty-bitmap in
+		 * fast_pf_fix_direct_spte() that means other pages are missed
+		 * if its slot is dirty-logged.
+		 *
+		 * Instead, we let the slow page fault path create a normal spte
+		 * to fix the access.
+		 *
+		 * See the comments in kvm_arch_commit_memory_region().
+		 */
+		if (remove_write_prot &&
+		    iter.level > PT_PAGE_TABLE_LEVEL)
+			break;
+
+		new_pte = iter.old_pte;
+		if (remove_acc_track)
+			new_pte = restore_acc_track_spte(iter.old_pte);
+		if (remove_write_prot)
+			new_pte |= PT_WRITABLE_MASK;
+
+		if (new_pte == iter.old_pte) {
+			fault_handled = true;
+			break;
+		}
+
+		if (!direct_walk_iterator_set_pte(&iter, new_pte))
+			continue;
+
+		if (remove_write_prot)
+			kvm_vcpu_mark_page_dirty(vcpu, iter.pte_gfn_start);
+
+		fault_handled = true;
+		break;
+	}
+	direct_walk_iterator_end_traversal(&iter);
+
+	trace_fast_page_fault(vcpu, gpa, error_code, iter.ptep,
+			      iter.old_pte, fault_handled);
+
+	return fault_handled;
+}
+
 static bool try_async_pf(struct kvm_vcpu *vcpu, bool prefault, gfn_t gfn,
 			 gva_t gva, kvm_pfn_t *pfn, bool write, bool *writable);
 static int make_mmu_pages_available(struct kvm_vcpu *vcpu);
@@ -5182,9 +5269,13 @@ static int tdp_page_fault(struct kvm_vcpu *vcpu, gva_t gpa, u32 error_code,
 		gfn &= ~(KVM_PAGES_PER_HPAGE(level) - 1);
 	}
 
-	if (!vcpu->kvm->arch.direct_mmu_enabled)
+	if (vcpu->kvm->arch.direct_mmu_enabled) {
+		if (fast_direct_page_fault(vcpu, gpa, level, error_code))
+			return RET_PF_RETRY;
+	} else {
 		if (fast_page_fault(vcpu, gpa, level, error_code))
 			return RET_PF_RETRY;
+	}
 
 	mmu_seq = vcpu->kvm->mmu_notifier_seq;
 	smp_rmb();
-- 
2.23.0.444.g18eeb5a265-goog

