Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CC4B442076
	for <lists+kvm@lfdr.de>; Mon,  1 Nov 2021 20:05:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232179AbhKATHw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Nov 2021 15:07:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231378AbhKATHv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Nov 2021 15:07:51 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D98AC061714
        for <kvm@vger.kernel.org>; Mon,  1 Nov 2021 12:05:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=7NngfLUXw64hTWX6qMzP6o9n7ByXE3q7Z7V8F78v1X4=; b=TSMUOOfOaglh1pVqg1gCqetl3R
        2LRwnWTrTEhuqKrxswCTEgqknATuYKPpQ19DnSy8XZEbCkg0Bf3Vkk4JMJChlI+V0Hnnl9HpO9mK5
        e7eRnN/8ZePwxQiIJh13K7q/iKCQvubj1YOgWJiZYmAqkXRsp6b7yaa039KfdV5fx7d00YGinmxlZ
        bnWi2MFWHLO/hICgNZ9v8b1hYkyZBryFu+6sPmvd4C8tW5ChfDyYQc0XDrw1O9YSG8BTGNpNRDQ80
        G6tR5VOgtUbtYgCf2bvnWnFbhG+MZYHooKOtkCoEUP8kPMXJfVgwmjE5X/jTxx8dDk6RPq1tG+J+Q
        TzeYoAgg==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mhcaS-003xXc-Th; Mon, 01 Nov 2021 19:03:37 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mhcaS-0004hZ-Dn; Mon, 01 Nov 2021 19:03:16 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Joao Martins <joao.m.martins@oracle.com>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        KarimAllah Raslan <karahmed@amazon.com>
Subject: [PATCH v2 4/6] KVM: Fix kvm_map_gfn()/kvm_unmap_gfn() to take a kvm as their names imply
Date:   Mon,  1 Nov 2021 19:03:12 +0000
Message-Id: <20211101190314.17954-5-dwmw2@infradead.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211101190314.17954-1-dwmw2@infradead.org>
References: <20211101190314.17954-1-dwmw2@infradead.org>
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
 include/linux/kvm_host.h |  4 ++--
 virt/kvm/kvm_main.c      | 11 +++++------
 2 files changed, 7 insertions(+), 8 deletions(-)

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

