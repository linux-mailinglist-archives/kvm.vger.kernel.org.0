Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2004823DBC
	for <lists+kvm@lfdr.de>; Mon, 20 May 2019 18:44:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389301AbfETQoT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 May 2019 12:44:19 -0400
Received: from mx2.suse.de ([195.135.220.15]:54890 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389205AbfETQoT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 May 2019 12:44:19 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 5D061AC63;
        Mon, 20 May 2019 16:44:18 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 06D1CE0184; Mon, 20 May 2019 18:44:18 +0200 (CEST)
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH RESEND] kvm: make kvm_vcpu_(un)map dependency on CONFIG_HAS_IOMEM
 explicit
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Radim Krcmar <rkrcmar@redhat.com>,
        KarimAllah Ahmed <karahmed@amazon.de>,
        linux-kernel@vger.kernel.org
Message-Id: <20190520164418.06D1CE0184@unicorn.suse.cz>
Date:   Mon, 20 May 2019 18:44:18 +0200 (CEST)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Recently introduced functions kvm_vcpu_map() and kvm_vcpu_unmap() call
memremap() and memunmap() which are only available if HAS_IOMEM is enabled
but this dependency is not explicit, so that the build fails with HAS_IOMEM
disabled.

As both function are only used on x86 where HAS_IOMEM is always enabled,
the easiest fix seems to be to only provide them when HAS_IOMEM is enabled.

Fixes: e45adf665a53 ("KVM: Introduce a new guest mapping API")
Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 include/linux/kvm_host.h | 6 +++++-
 virt/kvm/kvm_main.c      | 2 ++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 79fa4426509c..371d68fef5e1 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -759,9 +759,13 @@ struct kvm_memslots *kvm_vcpu_memslots(struct kvm_vcpu *vcpu);
 struct kvm_memory_slot *kvm_vcpu_gfn_to_memslot(struct kvm_vcpu *vcpu, gfn_t gfn);
 kvm_pfn_t kvm_vcpu_gfn_to_pfn_atomic(struct kvm_vcpu *vcpu, gfn_t gfn);
 kvm_pfn_t kvm_vcpu_gfn_to_pfn(struct kvm_vcpu *vcpu, gfn_t gfn);
+
+#ifdef CONFIG_HAS_IOMEM
 int kvm_vcpu_map(struct kvm_vcpu *vcpu, gpa_t gpa, struct kvm_host_map *map);
-struct page *kvm_vcpu_gfn_to_page(struct kvm_vcpu *vcpu, gfn_t gfn);
 void kvm_vcpu_unmap(struct kvm_vcpu *vcpu, struct kvm_host_map *map, bool dirty);
+#endif
+
+struct page *kvm_vcpu_gfn_to_page(struct kvm_vcpu *vcpu, gfn_t gfn);
 unsigned long kvm_vcpu_gfn_to_hva(struct kvm_vcpu *vcpu, gfn_t gfn);
 unsigned long kvm_vcpu_gfn_to_hva_prot(struct kvm_vcpu *vcpu, gfn_t gfn, bool *writable);
 int kvm_vcpu_read_guest_page(struct kvm_vcpu *vcpu, gfn_t gfn, void *data, int offset,
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index f0d13d9d125d..4a2c813e75d6 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1743,6 +1743,7 @@ struct page *gfn_to_page(struct kvm *kvm, gfn_t gfn)
 }
 EXPORT_SYMBOL_GPL(gfn_to_page);
 
+#ifdef CONFIG_HAS_IOMEM
 static int __kvm_map_gfn(struct kvm_memory_slot *slot, gfn_t gfn,
 			 struct kvm_host_map *map)
 {
@@ -1806,6 +1807,7 @@ void kvm_vcpu_unmap(struct kvm_vcpu *vcpu, struct kvm_host_map *map,
 	map->page = NULL;
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_unmap);
+#endif /* CONFIG_HAS_IOMEM */
 
 struct page *kvm_vcpu_gfn_to_page(struct kvm_vcpu *vcpu, gfn_t gfn)
 {
-- 
2.21.0

