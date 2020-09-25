Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DE5527934F
	for <lists+kvm@lfdr.de>; Fri, 25 Sep 2020 23:24:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729451AbgIYVYX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Sep 2020 17:24:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729258AbgIYVXi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Sep 2020 17:23:38 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 770F2C0613D5
        for <kvm@vger.kernel.org>; Fri, 25 Sep 2020 14:23:38 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id c5so3230309qtd.12
        for <kvm@vger.kernel.org>; Fri, 25 Sep 2020 14:23:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=jRVbtRnVunaUbsRIJ3qqaIgFOVHoYWyu7xL6dJMWEVU=;
        b=dfKIlNg1y7ZqiIyhdvXSMvj8pVfsBfNZKnyiXx9VE5GfVSl8WjprUfryl5rIymrH7i
         XJ5s8PI7wf36Feoycno1aFCYIdLW1nOpheLf6Ol5H7/wydSBAcGTZrv3yOD6n1ixHN7g
         TFN8MFXDwstrtpdbz3Bdy/ZmPNuf5BKCWp51ogfcYtoQlKNiODD/+gQTSHj0VUvhme+E
         bkbmyzK6iDSvJO6R9T1UVGbCqIewIbrTGl5UbW5LhlUfSabrFEF5NAy1jgQY6BDYbK+6
         DSoaRk9Y3Z5QYdeDtnAeLl3NLxVPSfu+P6M+YUz3iYag3LHoHwrwwPuebKGPw53HoJUb
         itpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=jRVbtRnVunaUbsRIJ3qqaIgFOVHoYWyu7xL6dJMWEVU=;
        b=ZddU+VRbXhBVRyXve+XDAsi6KJlS6p69yRLQyTrHcxepeugcgNckGmqI+lvRlpbP+n
         l07IDek5IEPxtDNj+BSljqTqNHTM2VhsJo98PC7owpvTpHf3kh8kgnDemCPbaKoCCCmY
         rmPKzROvSNEzCf1HJbjbxI+5SkkGgZTTjlzKLnHh7oowWkUfFDb1J2iOp1Z8XWY/7fJg
         Jk9Qvx1eEbLfyqeQuLNSwAqH2fIW2yb3qLXenRdimsCRDQWJHiYbAZdBntKrd9SOtAuj
         jQo9FBeQb7V9gNy0QTgziEy6aOJmUccYGwlbrq/GehYVUkiqDrqvgVb7P1vCAsDsmy5O
         gI8g==
X-Gm-Message-State: AOAM533JT0jRhNCBM6ZNxNPn3N4E7mzA1L0/1+ziYRDBQp2ce5JPNTX9
        V0RbOYO+3OXgJb2pPJTSLubLJ4r9vMrz
X-Google-Smtp-Source: ABdhPJw17NhL/7qCi5kl9UW4U6EP5dY6yG9Ua1eYsaf+4istvoy/1+8ZHu8SQUzB7xuFrOmapRmOE+NxZVtZ
Sender: "bgardon via sendgmr" <bgardon@bgardon.sea.corp.google.com>
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:f693:9fff:fef4:a293])
 (user=bgardon job=sendgmr) by 2002:ad4:5745:: with SMTP id
 q5mr636253qvx.29.1601069017635; Fri, 25 Sep 2020 14:23:37 -0700 (PDT)
Date:   Fri, 25 Sep 2020 14:22:56 -0700
In-Reply-To: <20200925212302.3979661-1-bgardon@google.com>
Message-Id: <20200925212302.3979661-17-bgardon@google.com>
Mime-Version: 1.0
References: <20200925212302.3979661-1-bgardon@google.com>
X-Mailer: git-send-email 2.28.0.709.gb0816b6eb0-goog
Subject: [PATCH 16/22] kvm: mmu: Add dirty logging handler for changed sptes
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Cannon Matthews <cannonmatthews@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
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

Add a function to handle the dirty logging bookkeeping associated with
SPTE changes. This will be important for future commits which will allow
the TDP MMU to log dirty pages the same way the x86 shadow paging based
MMU does.

Tested by running kvm-unit-tests and KVM selftests on an Intel Haswell
machine. This series introduced no new failures.

This series can be viewed in Gerrit at:
	https://linux-review.googlesource.com/c/virt/kvm/kvm/+/2538

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 21 +++++++++++++++++++++
 include/linux/kvm_host.h   |  1 +
 virt/kvm/kvm_main.c        |  6 ++----
 3 files changed, 24 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 3119583409131..bbe973d3f8084 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -236,6 +236,24 @@ static void handle_changed_spte_acc_track(u64 old_spte, u64 new_spte, int level)
 		kvm_set_pfn_accessed(spte_to_pfn(old_spte));
 }
 
+static void handle_changed_spte_dlog(struct kvm *kvm, int as_id, gfn_t gfn,
+				    u64 old_spte, u64 new_spte, int level)
+{
+	bool pfn_changed;
+	struct kvm_memory_slot *slot;
+
+	if (level > PG_LEVEL_4K)
+		return;
+
+	pfn_changed = spte_to_pfn(old_spte) != spte_to_pfn(new_spte);
+
+	if ((!is_writable_pte(old_spte) || pfn_changed) &&
+	    is_writable_pte(new_spte)) {
+		slot = __gfn_to_memslot(__kvm_memslots(kvm, as_id), gfn);
+		mark_page_dirty_in_slot(slot, gfn);
+	}
+}
+
 /**
  * handle_changed_spte - handle bookkeeping associated with an SPTE change
  * @kvm: kvm instance
@@ -348,6 +366,7 @@ static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
 {
 	__handle_changed_spte(kvm, as_id, gfn, old_spte, new_spte, level);
 	handle_changed_spte_acc_track(old_spte, new_spte, level);
+	handle_changed_spte_dlog(kvm, as_id, gfn, old_spte, new_spte, level);
 }
 
 #define for_each_tdp_pte_root(_iter, _root, _start, _end) \
@@ -685,6 +704,8 @@ static int age_gfn_range(struct kvm *kvm, struct kvm_memory_slot *slot,
 		*iter.sptep = new_spte;
 		__handle_changed_spte(kvm, as_id, iter.gfn, iter.old_spte,
 				      new_spte, iter.level);
+		handle_changed_spte_dlog(kvm, as_id, iter.gfn, iter.old_spte,
+					 new_spte, iter.level);
 		young = true;
 	}
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index a460bc712a81c..2f8c3f644d809 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -798,6 +798,7 @@ struct kvm_memory_slot *gfn_to_memslot(struct kvm *kvm, gfn_t gfn);
 bool kvm_is_visible_gfn(struct kvm *kvm, gfn_t gfn);
 bool kvm_vcpu_is_visible_gfn(struct kvm_vcpu *vcpu, gfn_t gfn);
 unsigned long kvm_host_page_size(struct kvm_vcpu *vcpu, gfn_t gfn);
+void mark_page_dirty_in_slot(struct kvm_memory_slot *memslot, gfn_t gfn);
 void mark_page_dirty(struct kvm *kvm, gfn_t gfn);
 
 struct kvm_memslots *kvm_vcpu_memslots(struct kvm_vcpu *vcpu);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index f9c80351c9efd..b5082ce60a33f 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -143,8 +143,6 @@ static void hardware_disable_all(void);
 
 static void kvm_io_bus_destroy(struct kvm_io_bus *bus);
 
-static void mark_page_dirty_in_slot(struct kvm_memory_slot *memslot, gfn_t gfn);
-
 __visible bool kvm_rebooting;
 EXPORT_SYMBOL_GPL(kvm_rebooting);
 
@@ -2640,8 +2638,7 @@ int kvm_clear_guest(struct kvm *kvm, gpa_t gpa, unsigned long len)
 }
 EXPORT_SYMBOL_GPL(kvm_clear_guest);
 
-static void mark_page_dirty_in_slot(struct kvm_memory_slot *memslot,
-				    gfn_t gfn)
+void mark_page_dirty_in_slot(struct kvm_memory_slot *memslot, gfn_t gfn)
 {
 	if (memslot && memslot->dirty_bitmap) {
 		unsigned long rel_gfn = gfn - memslot->base_gfn;
@@ -2649,6 +2646,7 @@ static void mark_page_dirty_in_slot(struct kvm_memory_slot *memslot,
 		set_bit_le(rel_gfn, memslot->dirty_bitmap);
 	}
 }
+EXPORT_SYMBOL_GPL(mark_page_dirty_in_slot);
 
 void mark_page_dirty(struct kvm *kvm, gfn_t gfn)
 {
-- 
2.28.0.709.gb0816b6eb0-goog

