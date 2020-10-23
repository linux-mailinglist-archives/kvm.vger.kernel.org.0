Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 757542976F8
	for <lists+kvm@lfdr.de>; Fri, 23 Oct 2020 20:34:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1754898AbgJWSeU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Oct 2020 14:34:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26904 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754869AbgJWSeP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 23 Oct 2020 14:34:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603478054;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7bU0wiJLATmj7mwD+p1vewMpZhS8DPN+XFbmzRlSmU4=;
        b=bMuhZCsxE/7zRUlAaYGC5nrcQnnf6HjK+va+rfdblbOTTAbJ5jk9HJ0SAgI8ImDKMn4IGo
        eRUXuJYMV8Ct9IpZ/OiFpaUujHKmsa0Iymopip2LWLHWpO5LsUoGPPPnWLsU6nIMT239hJ
        Pmf4/PNca1bfawDdByEtiHQeFmN8wEs=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-3-FYuJrBIsOe2GlmIOQs1dvg-1; Fri, 23 Oct 2020 14:34:12 -0400
X-MC-Unique: FYuJrBIsOe2GlmIOQs1dvg-1
Received: by mail-qv1-f72.google.com with SMTP id l8so1572637qvz.2
        for <kvm@vger.kernel.org>; Fri, 23 Oct 2020 11:34:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7bU0wiJLATmj7mwD+p1vewMpZhS8DPN+XFbmzRlSmU4=;
        b=s5Gq88VkrS9D/z34kwNNgmZdBsvH0rXovqBgLUymyZGvWKGJ2vC/0C66LJ7t2tsI1u
         JRzsboxy+spQ+ImeVsdafl7BQTvK3Ht8LfYmxdkieGVOABm3sHJH07a4Gk62h9oRMk/a
         g+hrlMMAaxhMB0q1GQ3v91+afLHG9f18aXFdDCTeW3hsBd2GPZAdz96Q7I/MVM0yIWv3
         OcFGPB3CJse4gihsCNYH3Amdn0SApRufVLlJ6FMPUrGAGgFWpvqYblwA7xZ7q+l1Wp4h
         53xIpM8nsKvNc2EDRDgubdlKKwCUPJBUAz2nzpwmsF3S+u3GqgFnS6+7+f7HZ+DTIRgM
         gvTg==
X-Gm-Message-State: AOAM5317X4oyNb0+ijwKlrlpsim30586kbkfLGLDTuhUMH2meD9+FrFr
        +rtZmGxb0tsWkjU8I06jkS4rnf7yLpKzR1UAsw4FKxE7uLeClyuqKhjFahBgJzAt5LYUds5BQe5
        n1x+xUeO2pte9
X-Received: by 2002:a37:5ca:: with SMTP id 193mr3631130qkf.44.1603478051491;
        Fri, 23 Oct 2020 11:34:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx2BvSDmeA/DQo1WlKLH5Sh49c8JiIjEnWjrJdZ2KaYBDlqsWlSfnI2XBSixjBAGFGyb76Czg==
X-Received: by 2002:a37:5ca:: with SMTP id 193mr3631100qkf.44.1603478051236;
        Fri, 23 Oct 2020 11:34:11 -0700 (PDT)
Received: from xz-x1.redhat.com (toroon474qw-lp140-04-174-95-215-133.dsl.bell.ca. [174.95.215.133])
        by smtp.gmail.com with ESMTPSA id u11sm1490407qtk.61.2020.10.23.11.34.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Oct 2020 11:34:10 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        peterx@redhat.com, Andrew Jones <drjones@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v15 07/14] KVM: Don't allocate dirty bitmap if dirty ring is enabled
Date:   Fri, 23 Oct 2020 14:33:51 -0400
Message-Id: <20201023183358.50607-8-peterx@redhat.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201023183358.50607-1-peterx@redhat.com>
References: <20201023183358.50607-1-peterx@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Because kvm dirty rings and kvm dirty log is used in an exclusive way,
Let's avoid creating the dirty_bitmap when kvm dirty ring is enabled.
At the meantime, since the dirty_bitmap will be conditionally created
now, we can't use it as a sign of "whether this memory slot enabled
dirty tracking".  Change users like that to check against the kvm
memory slot flags.

Note that there still can be chances where the kvm memory slot got its
dirty_bitmap allocated, _if_ the memory slots are created before
enabling of the dirty rings and at the same time with the dirty
tracking capability enabled, they'll still with the dirty_bitmap.
However it should not hurt much (e.g., the bitmaps will always be
freed if they are there), and the real users normally won't trigger
this because dirty bit tracking flag should in most cases only be
applied to kvm slots only before migration starts, that should be far
latter than kvm initializes (VM starts).

Signed-off-by: Peter Xu <peterx@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c   | 2 +-
 include/linux/kvm_host.h | 5 +++++
 virt/kvm/kvm_main.c      | 4 ++--
 3 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index d3cc173dcf55..af2460c42922 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -820,7 +820,7 @@ gfn_to_memslot_dirty_bitmap(struct kvm_vcpu *vcpu, gfn_t gfn,
 	slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
 	if (!slot || slot->flags & KVM_MEMSLOT_INVALID)
 		return NULL;
-	if (no_dirty_log && slot->dirty_bitmap)
+	if (no_dirty_log && kvm_slot_dirty_track_enabled(slot))
 		return NULL;
 
 	return slot;
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index c10cf91bde19..dcc1f0e44366 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -351,6 +351,11 @@ struct kvm_memory_slot {
 	u16 as_id;
 };
 
+static inline bool kvm_slot_dirty_track_enabled(struct kvm_memory_slot *slot)
+{
+	return slot->flags & KVM_MEM_LOG_DIRTY_PAGES;
+}
+
 static inline unsigned long kvm_dirty_bitmap_bytes(struct kvm_memory_slot *memslot)
 {
 	return ALIGN(memslot->npages, BITS_PER_LONG) / 8;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index c05b94696b21..abe921f90f35 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1365,7 +1365,7 @@ int __kvm_set_memory_region(struct kvm *kvm,
 	/* Allocate/free page dirty bitmap as needed */
 	if (!(new.flags & KVM_MEM_LOG_DIRTY_PAGES))
 		new.dirty_bitmap = NULL;
-	else if (!new.dirty_bitmap) {
+	else if (!new.dirty_bitmap && !kvm->dirty_ring_size) {
 		r = kvm_alloc_dirty_bitmap(&new);
 		if (r)
 			return r;
@@ -2663,7 +2663,7 @@ EXPORT_SYMBOL_GPL(kvm_clear_guest);
 void mark_page_dirty_in_slot(struct kvm *kvm, struct kvm_memory_slot *memslot,
 			     gfn_t gfn)
 {
-	if (memslot && memslot->dirty_bitmap) {
+	if (memslot && kvm_slot_dirty_track_enabled(memslot)) {
 		unsigned long rel_gfn = gfn - memslot->base_gfn;
 		u32 slot = (memslot->as_id << 16) | memslot->id;
 
-- 
2.26.2

