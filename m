Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B503F35241C
	for <lists+kvm@lfdr.de>; Fri,  2 Apr 2021 01:41:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236471AbhDAXif (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Apr 2021 19:38:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236421AbhDAXi2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Apr 2021 19:38:28 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72276C0613E6
        for <kvm@vger.kernel.org>; Thu,  1 Apr 2021 16:38:27 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id u128so7415457ybf.12
        for <kvm@vger.kernel.org>; Thu, 01 Apr 2021 16:38:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=431jpCNAbz4ff8aRGDz2CylqoUFVtLTXMyFJDApsl0M=;
        b=c/JTkYaCSPcEu9gZ6oGaCnHSmz9zwYtrH6/nMAVzYMC9CA/vu4Hb+k0IEhF2+h+mqc
         1xGZPaLOj94CcK38WOvvZtz6Nb/eL/syC8a0ObG5snmHCjtITuWcFZTxUAdH79JqxZe4
         0N6EYf5mTEEz/VxDZr/YlQZd4a2PDcCqSwxYQ+zKpnA3YO3j021KabTs/+6EQdaCYE9b
         EtKznR+KjTX1GO6F/QTcaANY99+PJ2kJYrUIfrfnRy7jHnBs7zYF0TTFdetHEzaoQQzZ
         BTMF5ecoa5eZ08stFAE0bzMfz/w0p4B5njtDklYnEaN4tpslOtkOFeBwIs+gI+4/kdul
         PoZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=431jpCNAbz4ff8aRGDz2CylqoUFVtLTXMyFJDApsl0M=;
        b=IoTRJPzXq+VDFjIY4vnpIY0kZ6xFN0DuSmIRXKDLnjGRFhYvXIORQAQ6GLnTG+Xxbz
         m+/DsCIo8tsFBzpjE7l5I2clRzjgroPGoNo4I2CvPcvpQwx/NYoU7RTBfCTfTGzlYXRW
         E2SOQrgnPN8BDpqqCSqUxZzbLFVwVv+JGCZuR6AvsguSFX6pGnXH3bxERkshKJwh/PNQ
         jrQt86H1lxyDK/gxJP2wBwvpE9JFHoUK/lJT8TakVuYu4Ug+i85KohLeIVjffx2YNDw6
         BnitZ28boBT+PxA3LA9A4La1e3m8GOTgIWSxIVT/k1MaHFdgybO74OefpVrziJw00U1/
         moxw==
X-Gm-Message-State: AOAM5314/Wmjurq+rjXfr0L4CYuyef3Zhqwx9OmbizGLBR+u0WAAO/2V
        xqOSpnFfYOBfUO14DSv9KdYOhRXldIWU
X-Google-Smtp-Source: ABdhPJxPGWZTAkhYz2+fQtZeS3Keq4NCQuFs2ZA09MoH8cRNcO686wNodJqesSvXqlEYXKi71FfGbFhOm9NO
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:e088:88b8:ea4a:22b6])
 (user=bgardon job=sendgmr) by 2002:a25:c5c9:: with SMTP id
 v192mr15582738ybe.299.1617320306715; Thu, 01 Apr 2021 16:38:26 -0700 (PDT)
Date:   Thu,  1 Apr 2021 16:37:36 -0700
In-Reply-To: <20210401233736.638171-1-bgardon@google.com>
Message-Id: <20210401233736.638171-14-bgardon@google.com>
Mime-Version: 1.0
References: <20210401233736.638171-1-bgardon@google.com>
X-Mailer: git-send-email 2.31.0.208.g409f899ff0-goog
Subject: [PATCH v2 13/13] KVM: x86/mmu: Tear down roots in fast invalidation thread
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

To avoid saddling a vCPU thread with the work of tearing down an entire
paging structure, take a reference on each root before they become
obsolete, so that the thread initiating the fast invalidation can tear
down the paging structure and (most likely) release the last reference.
As a bonus, this teardown can happen under the MMU lock in read mode so
as not to block the progress of vCPU threads.

Signed-off-by: Ben Gardon <bgardon@google.com>
---

Changelog
v2:
--	rename kvm_tdp_mmu_zap_all_fast to
	kvm_tdp_mmu_zap_invalidated_roots

 arch/x86/kvm/mmu/mmu.c     | 21 +++++++++++-
 arch/x86/kvm/mmu/tdp_mmu.c | 68 ++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/mmu/tdp_mmu.h |  1 +
 3 files changed, 89 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index ba0c65076200..5f2064ee7220 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5441,6 +5441,18 @@ static void kvm_mmu_zap_all_fast(struct kvm *kvm)
 		 * will drop their references and allow the root count to
 		 * go to 0.
 		 *
+		 * Also take a reference on all roots so that this thread
+		 * can do the bulk of the work required to free the roots
+		 * once they are invalidated. Without this reference, a
+		 * vCPU thread might drop the last reference to a root and
+		 * get stuck with tearing down the entire paging structure.
+		 *
+		 * Roots which have a zero refcount should be skipped as
+		 * they're already being torn down.
+		 * Already invalid roots should be referenced again so that
+		 * they aren't freed before kvm_tdp_mmu_zap_all_fast is
+		 * done with them.
+		 *
 		 * This has essentially the same effect for the TDP MMU
 		 * as updating mmu_valid_gen above does for the shadow
 		 * MMU.
@@ -5452,7 +5464,8 @@ static void kvm_mmu_zap_all_fast(struct kvm *kvm)
 		 * could drop the MMU lock and yield.
 		 */
 		list_for_each_entry(root, &kvm->arch.tdp_mmu_roots, link)
-			root->role.invalid = true;
+			if (refcount_inc_not_zero(&root->tdp_mmu_root_count))
+				root->role.invalid = true;
 	}
 
 	/*
@@ -5468,6 +5481,12 @@ static void kvm_mmu_zap_all_fast(struct kvm *kvm)
 	kvm_zap_obsolete_pages(kvm);
 
 	write_unlock(&kvm->mmu_lock);
+
+	if (is_tdp_mmu_enabled(kvm)) {
+		read_lock(&kvm->mmu_lock);
+		kvm_tdp_mmu_zap_invalidated_roots(kvm);
+		read_unlock(&kvm->mmu_lock);
+	}
 }
 
 static bool kvm_has_zapped_obsolete_pages(struct kvm *kvm)
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 501722a524a7..0adcfa5750f6 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -798,6 +798,74 @@ void kvm_tdp_mmu_zap_all(struct kvm *kvm)
 		kvm_flush_remote_tlbs(kvm);
 }
 
+static struct kvm_mmu_page *next_invalidated_root(struct kvm *kvm,
+						  struct kvm_mmu_page *prev_root)
+{
+	struct kvm_mmu_page *next_root;
+
+	if (prev_root)
+		next_root = list_next_or_null_rcu(&kvm->arch.tdp_mmu_roots,
+						  &prev_root->link,
+						  typeof(*prev_root), link);
+	else
+		next_root = list_first_or_null_rcu(&kvm->arch.tdp_mmu_roots,
+						   typeof(*next_root), link);
+
+	while (next_root && !(next_root->role.invalid &&
+			      refcount_read(&next_root->tdp_mmu_root_count)))
+		next_root = list_next_or_null_rcu(&kvm->arch.tdp_mmu_roots,
+						  &next_root->link,
+						  typeof(*next_root), link);
+
+	return next_root;
+}
+
+/*
+ * Since kvm_mmu_zap_all_fast has acquired a reference to each
+ * invalidated root, they will not be freed until this function drops the
+ * reference. Before dropping that reference, tear down the paging
+ * structure so that whichever thread does drop the last reference
+ * only has to do a trivial ammount of work. Since the roots are invalid,
+ * no new SPTEs should be created under them.
+ */
+void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm)
+{
+	gfn_t max_gfn = 1ULL << (shadow_phys_bits - PAGE_SHIFT);
+	struct kvm_mmu_page *next_root;
+	struct kvm_mmu_page *root;
+	bool flush = false;
+
+	lockdep_assert_held_read(&kvm->mmu_lock);
+
+	rcu_read_lock();
+
+	root = next_invalidated_root(kvm, NULL);
+
+	while (root) {
+		next_root = next_invalidated_root(kvm, root);
+
+		rcu_read_unlock();
+
+		flush = zap_gfn_range(kvm, root, 0, max_gfn, true, flush,
+				      true);
+
+		/*
+		 * Put the reference acquired in
+		 * kvm_tdp_mmu_invalidate_roots
+		 */
+		kvm_tdp_mmu_put_root(kvm, root, true);
+
+		root = next_root;
+
+		rcu_read_lock();
+	}
+
+	rcu_read_unlock();
+
+	if (flush)
+		kvm_flush_remote_tlbs(kvm);
+}
+
 /*
  * Installs a last-level SPTE to handle a TDP page fault.
  * (NPT/EPT violation/misconfiguration)
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index 8fa3e7421a93..f8db381e3059 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -47,6 +47,7 @@ static inline bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
 					   sp->gfn, end, false, false, false);
 }
 void kvm_tdp_mmu_zap_all(struct kvm *kvm);
+void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm);
 
 int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 		    int map_writable, int max_level, kvm_pfn_t pfn,
-- 
2.31.0.208.g409f899ff0-goog

