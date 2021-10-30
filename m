Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFC03440B89
	for <lists+kvm@lfdr.de>; Sat, 30 Oct 2021 21:46:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231165AbhJ3TtE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 30 Oct 2021 15:49:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230497AbhJ3TtD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 30 Oct 2021 15:49:03 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B50BC061746
        for <kvm@vger.kernel.org>; Sat, 30 Oct 2021 12:46:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=oLvZ4oUv+JlX0dOr7KVY1E/i7qAM2QVUmxT2vZxhivA=; b=HsgyDfVbLjfkEvvo/E9MDE5Hs9
        X7NVkkwWC/eVe2KzTOxXRAJKqBwREcV2D+RW78huLz3YvXiJeU/m9S3Tclq2/4qRJHVj+qWBIdYKo
        1o+pOhO964kqCWX/HbAAjJgepqQ5KRiFY9HP3pDF2VQWjx6847RMVmmbwJT/k07RSdUWiSXWserg+
        g0y1juPMo1ZVdJnrS7+V8jE34zc9LOrOPU+fm9go0NbW8hYzWsiDozjX6jNLajpvTwUSwhrhirm5x
        soukyFV5TLXh/BMmJEfi2dqeJWXPbemIm+i1BYCuljNhp4VTWXB7UvSikd5V0hWWkdr4rGsoN2m6Q
        TcxtMlNg==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mguHF-002cmN-9K; Sat, 30 Oct 2021 19:45:12 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mguHE-00066E-QN; Sat, 30 Oct 2021 20:44:28 +0100
From:   David Woodhouse <dwmw2@infradead.org>
To:     "kvm @ vger . kernel . org" <kvm@vger.kernel.org>
Cc:     "jmattson @ google . com" <jmattson@google.com>,
        "pbonzini @ redhat . com" <pbonzini@redhat.com>,
        "wanpengli @ tencent . com" <wanpengli@tencent.com>,
        "seanjc @ google . com" <seanjc@google.com>,
        "vkuznets @ redhat . com" <vkuznets@redhat.com>,
        "mtosatti @ redhat . com" <mtosatti@redhat.com>,
        "joro @ 8bytes . org" <joro@8bytes.org>,
        Joao Martins <joao.m.martins@oracle.com>,
        Ankur Arora <ankur.a.arora@oracle.com>, karahmed@amazon.com
Subject: [PATCH 3/5] KVM: Fix kvm_map_gfn()/kvm_unmap_gfn() to take a kvm as their names imply
Date:   Sat, 30 Oct 2021 20:44:26 +0100
Message-Id: <20211030194428.23395-3-dwmw2@infradead.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211030194428.23395-1-dwmw2@infradead.org>
References: <20211030194428.23395-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Woodhouse <dwmw@amazon.co.uk>

These were somewhat misnamed, as they actually took a kvm_vcpu, even
though they didn't do anything with it except to find vcpu->kvm.

And more to the point I don't *have* a vcpu to give them, in an upcoming
use case...

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/x86/kvm/x86.c       |  8 ++++----
 include/linux/kvm_host.h |  4 ++--
 virt/kvm/kvm_main.c      | 11 +++++------
 3 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index cd42d58008f7..8e9b850d967b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3207,7 +3207,7 @@ static void record_steal_time(struct kvm_vcpu *vcpu)
 		return;
 
 	/* -EAGAIN is returned in atomic context so we can just return. */
-	if (kvm_map_gfn(vcpu, vcpu->arch.st.msr_val >> PAGE_SHIFT,
+	if (kvm_map_gfn(vcpu->kvm, vcpu->arch.st.msr_val >> PAGE_SHIFT,
 			&map, &vcpu->arch.st.cache, false))
 		return;
 
@@ -3246,7 +3246,7 @@ static void record_steal_time(struct kvm_vcpu *vcpu)
 
 	st->version += 1;
 
-	kvm_unmap_gfn(vcpu, &map, &vcpu->arch.st.cache, true, false);
+	kvm_unmap_gfn(vcpu->kvm, &map, &vcpu->arch.st.cache, true, false);
 }
 
 int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
@@ -4294,7 +4294,7 @@ static void kvm_steal_time_set_preempted(struct kvm_vcpu *vcpu)
 	if (vcpu->arch.st.preempted)
 		return;
 
-	if (kvm_map_gfn(vcpu, vcpu->arch.st.msr_val >> PAGE_SHIFT, &map,
+	if (kvm_map_gfn(vcpu->kvm, vcpu->arch.st.msr_val >> PAGE_SHIFT, &map,
 			&vcpu->arch.st.cache, true))
 		return;
 
@@ -4303,7 +4303,7 @@ static void kvm_steal_time_set_preempted(struct kvm_vcpu *vcpu)
 
 	st->preempted = vcpu->arch.st.preempted = KVM_VCPU_PREEMPTED;
 
-	kvm_unmap_gfn(vcpu, &map, &vcpu->arch.st.cache, true, true);
+	kvm_unmap_gfn(vcpu->kvm, &map, &vcpu->arch.st.cache, true, true);
 }
 
 void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 0f18df7fe874..749cdc77fc4e 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -943,11 +943,11 @@ struct kvm_memory_slot *kvm_vcpu_gfn_to_memslot(struct kvm_vcpu *vcpu, gfn_t gfn
 kvm_pfn_t kvm_vcpu_gfn_to_pfn_atomic(struct kvm_vcpu *vcpu, gfn_t gfn);
 kvm_pfn_t kvm_vcpu_gfn_to_pfn(struct kvm_vcpu *vcpu, gfn_t gfn);
 int kvm_vcpu_map(struct kvm_vcpu *vcpu, gpa_t gpa, struct kvm_host_map *map);
-int kvm_map_gfn(struct kvm_vcpu *vcpu, gfn_t gfn, struct kvm_host_map *map,
+int kvm_map_gfn(struct kvm *kvm, gfn_t gfn, struct kvm_host_map *map,
 		struct gfn_to_pfn_cache *cache, bool atomic);
 struct page *kvm_vcpu_gfn_to_page(struct kvm_vcpu *vcpu, gfn_t gfn);
 void kvm_vcpu_unmap(struct kvm_vcpu *vcpu, struct kvm_host_map *map, bool dirty);
-int kvm_unmap_gfn(struct kvm_vcpu *vcpu, struct kvm_host_map *map,
+int kvm_unmap_gfn(struct kvm *kvm, struct kvm_host_map *map,
 		  struct gfn_to_pfn_cache *cache, bool dirty, bool atomic);
 unsigned long kvm_vcpu_gfn_to_hva(struct kvm_vcpu *vcpu, gfn_t gfn);
 unsigned long kvm_vcpu_gfn_to_hva_prot(struct kvm_vcpu *vcpu, gfn_t gfn, bool *writable);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 7851f3a1b5f7..f3a2740660ae 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2620,11 +2620,10 @@ static int __kvm_map_gfn(struct kvm_memslots *slots, gfn_t gfn,
 	return 0;
 }
 
-int kvm_map_gfn(struct kvm_vcpu *vcpu, gfn_t gfn, struct kvm_host_map *map,
+int kvm_map_gfn(struct kvm *kvm, gfn_t gfn, struct kvm_host_map *map,
 		struct gfn_to_pfn_cache *cache, bool atomic)
 {
-	return __kvm_map_gfn(kvm_memslots(vcpu->kvm), gfn, map,
-			cache, atomic);
+	return __kvm_map_gfn(kvm_memslots(kvm), gfn, map, cache, atomic);
 }
 EXPORT_SYMBOL_GPL(kvm_map_gfn);
 
@@ -2672,11 +2671,11 @@ static void __kvm_unmap_gfn(struct kvm *kvm,
 	map->page = NULL;
 }
 
-int kvm_unmap_gfn(struct kvm_vcpu *vcpu, struct kvm_host_map *map, 
+int kvm_unmap_gfn(struct kvm *kvm, struct kvm_host_map *map,
 		  struct gfn_to_pfn_cache *cache, bool dirty, bool atomic)
 {
-	__kvm_unmap_gfn(vcpu->kvm, gfn_to_memslot(vcpu->kvm, map->gfn), map,
-			cache, dirty, atomic);
+	__kvm_unmap_gfn(kvm, gfn_to_memslot(kvm, map->gfn), map, cache, dirty,
+			atomic);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(kvm_unmap_gfn);
-- 
2.31.1

