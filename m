Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC1282CE4EB
	for <lists+kvm@lfdr.de>; Fri,  4 Dec 2020 02:22:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388368AbgLDBUN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Dec 2020 20:20:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388205AbgLDBUK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Dec 2020 20:20:10 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09DD0C08E85E
        for <kvm@vger.kernel.org>; Thu,  3 Dec 2020 17:18:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=nlfk7fo9/eeQqoeGTfsdj4FxMlsVP85cXV+6FJSJYMM=; b=Z06/nG6wsbv0rgrdz49teJtMZe
        2a3vEiqEXIUdqnFf5nxKLzcZwdLO+uDbRi87+fFZGBwjoJzwG+UzA7Qe5vTnXhzBGkD4zVk9Q8AMy
        urZewtDbOI7ME3ShR00yTu9q+RTfKNAm0ZlGY+UwBp1jL7SK4TGoevC8gqbpxrDgf1ndiyzxF4hkK
        5j+So41fOF6ToOFL2aBiLVqawHoYacNimVjoI2MC0SYphQzA04+t5gggq2M3x3Vft91qUgW4uO7xO
        nkVkT07AydaudeEiX55o9RTdB4AGKj4odA8g0KVTIq7VhM85JWf/E2o2/sSBhSSTn79Uxd/GrpRQ1
        Olc9MkKg==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kkzkL-0002jx-8p; Fri, 04 Dec 2020 01:18:53 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1kkzkK-00CS9k-6l; Fri, 04 Dec 2020 01:18:52 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sean Christopherson <seanjc@google.com>
Subject: [PATCH 01/15] KVM: Fix arguments to kvm_{un,}map_gfn()
Date:   Fri,  4 Dec 2020 01:18:34 +0000
Message-Id: <20201204011848.2967588-2-dwmw2@infradead.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201204011848.2967588-1-dwmw2@infradead.org>
References: <20201204011848.2967588-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by merlin.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Woodhouse <dwmw@amazon.co.uk>

It shouldn't take a vcpu.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/x86/kvm/x86.c       | 8 ++++----
 include/linux/kvm_host.h | 4 ++--
 virt/kvm/kvm_main.c      | 8 ++++----
 3 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e545a8a613b1..c7f1ba21212e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2957,7 +2957,7 @@ static void record_steal_time(struct kvm_vcpu *vcpu)
 		return;
 
 	/* -EAGAIN is returned in atomic context so we can just return. */
-	if (kvm_map_gfn(vcpu, vcpu->arch.st.msr_val >> PAGE_SHIFT,
+	if (kvm_map_gfn(vcpu->kvm, vcpu->arch.st.msr_val >> PAGE_SHIFT,
 			&map, &vcpu->arch.st.cache, false))
 		return;
 
@@ -2992,7 +2992,7 @@ static void record_steal_time(struct kvm_vcpu *vcpu)
 
 	st->version += 1;
 
-	kvm_unmap_gfn(vcpu, &map, &vcpu->arch.st.cache, true, false);
+	kvm_unmap_gfn(vcpu->kvm, &map, &vcpu->arch.st.cache, true, false);
 }
 
 int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
@@ -3981,7 +3981,7 @@ static void kvm_steal_time_set_preempted(struct kvm_vcpu *vcpu)
 	if (vcpu->arch.st.preempted)
 		return;
 
-	if (kvm_map_gfn(vcpu, vcpu->arch.st.msr_val >> PAGE_SHIFT, &map,
+	if (kvm_map_gfn(vcpu->kvm, vcpu->arch.st.msr_val >> PAGE_SHIFT, &map,
 			&vcpu->arch.st.cache, true))
 		return;
 
@@ -3990,7 +3990,7 @@ static void kvm_steal_time_set_preempted(struct kvm_vcpu *vcpu)
 
 	st->preempted = vcpu->arch.st.preempted = KVM_VCPU_PREEMPTED;
 
-	kvm_unmap_gfn(vcpu, &map, &vcpu->arch.st.cache, true, true);
+	kvm_unmap_gfn(vcpu->kvm, &map, &vcpu->arch.st.cache, true, true);
 }
 
 void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 7f2e2a09ebbd..8eb5eb1399f5 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -806,11 +806,11 @@ struct kvm_memory_slot *kvm_vcpu_gfn_to_memslot(struct kvm_vcpu *vcpu, gfn_t gfn
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
index 2541a17ff1c4..f01a8df7806a 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2181,10 +2181,10 @@ static int __kvm_map_gfn(struct kvm_memslots *slots, gfn_t gfn,
 	return 0;
 }
 
-int kvm_map_gfn(struct kvm_vcpu *vcpu, gfn_t gfn, struct kvm_host_map *map,
+int kvm_map_gfn(struct kvm *kvm, gfn_t gfn, struct kvm_host_map *map,
 		struct gfn_to_pfn_cache *cache, bool atomic)
 {
-	return __kvm_map_gfn(kvm_memslots(vcpu->kvm), gfn, map,
+	return __kvm_map_gfn(kvm_memslots(kvm), gfn, map,
 			cache, atomic);
 }
 EXPORT_SYMBOL_GPL(kvm_map_gfn);
@@ -2232,10 +2232,10 @@ static void __kvm_unmap_gfn(struct kvm_memory_slot *memslot,
 	map->page = NULL;
 }
 
-int kvm_unmap_gfn(struct kvm_vcpu *vcpu, struct kvm_host_map *map, 
+int kvm_unmap_gfn(struct kvm *kvm, struct kvm_host_map *map,
 		  struct gfn_to_pfn_cache *cache, bool dirty, bool atomic)
 {
-	__kvm_unmap_gfn(gfn_to_memslot(vcpu->kvm, map->gfn), map,
+	__kvm_unmap_gfn(gfn_to_memslot(kvm, map->gfn), map,
 			cache, dirty, atomic);
 	return 0;
 }
-- 
2.26.2

