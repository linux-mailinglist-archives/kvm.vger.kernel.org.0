Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 553FA28696F
	for <lists+kvm@lfdr.de>; Wed,  7 Oct 2020 22:54:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728615AbgJGUyA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Oct 2020 16:54:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:31601 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728554AbgJGUx5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 7 Oct 2020 16:53:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602104035;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4NS8iwyIXOJFzj6So0GL06bw2MEksIZDFHtJ24IXHgI=;
        b=CADvSHwQmCDxPawK3P64KymmpHvI/V6zqqPxZRdxLlkbWsDtPwssUQ5oA8YyzLp/oa999r
        jJp4VwpGbZuqF+pS2IJleRu8tfkPXtlTgjegXHZHVGugI6Qh7Sfgo6qS5Nwp+jknlGc/We
        H6VBgEvoSrPNQB/tBZBF0unaoMzPqQk=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-564-LiDxR3JXO3WiM0MIuGONJA-1; Wed, 07 Oct 2020 16:53:54 -0400
X-MC-Unique: LiDxR3JXO3WiM0MIuGONJA-1
Received: by mail-qk1-f197.google.com with SMTP id i10so2246686qkh.1
        for <kvm@vger.kernel.org>; Wed, 07 Oct 2020 13:53:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4NS8iwyIXOJFzj6So0GL06bw2MEksIZDFHtJ24IXHgI=;
        b=gy7hUrRGDFEphDTZypADM3QMcxjcNrDBKYZ2Dc3Tjud0wBnII/X6hkFGYdP4WXiXFz
         8kkLV96Lg1wi12KQ40uPwJE4FfRuiLw5Wujsx7vzhaCfaJa0O+extqLjrnM9eE7RE8/y
         DiE2KwL5lcvuOdqh37BirJsG+hp6KFAv9kNFx0z5c3ETII/W9sDkZuE61Jv3OPoODjMy
         SrjV3IBQ5DvDj4HNtQ8Ymnxvp6H5ugmCVQuzsS7IqDyYF1Zs4BuuwdV9XUyJqTW2rv5H
         FxFNXBOj/D2DVHN8UsyYc4PK6Bsvnlb0d8KM7IGkqvJRadSa9Wti/AIFq47BIhZBuTY1
         YKtg==
X-Gm-Message-State: AOAM5316ZChIMYmP/de9Np6XJmeIzl+jwGTW/yRmnzyMhLHREUaFeBZC
        kCUCsFOuY14DF28Oo8DWeI8Nv5iDg9rf5ti4rcU2AnTlorfYWsUSBSP6cmUzFwMK/kRaJ1FAv1a
        a66n19jDyXFZ8
X-Received: by 2002:a05:620a:4084:: with SMTP id f4mr5297782qko.449.1602104033738;
        Wed, 07 Oct 2020 13:53:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwfXNqc9LjuBpE16D9f0db+3N1EwuCLePBnJeLa9DV0nEJeXe839hCXt8tatTJC62Jv9O1ssQ==
X-Received: by 2002:a05:620a:4084:: with SMTP id f4mr5297760qko.449.1602104033530;
        Wed, 07 Oct 2020 13:53:53 -0700 (PDT)
Received: from xz-x1.redhat.com (toroon474qw-lp140-04-174-95-215-133.dsl.bell.ca. [174.95.215.133])
        by smtp.gmail.com with ESMTPSA id j24sm2390695qkg.107.2020.10.07.13.53.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Oct 2020 13:53:52 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     peterx@redhat.com, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Andrew Jones <drjones@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>
Subject: [PATCH v14 07/14] KVM: Don't allocate dirty bitmap if dirty ring is enabled
Date:   Wed,  7 Oct 2020 16:53:35 -0400
Message-Id: <20201007205342.295402-8-peterx@redhat.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201007205342.295402-1-peterx@redhat.com>
References: <20201007205342.295402-1-peterx@redhat.com>
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
index 84471417930d..3725583f4f56 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1240,7 +1240,7 @@ gfn_to_memslot_dirty_bitmap(struct kvm_vcpu *vcpu, gfn_t gfn,
 	slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
 	if (!slot || slot->flags & KVM_MEMSLOT_INVALID)
 		return NULL;
-	if (no_dirty_log && slot->dirty_bitmap)
+	if (no_dirty_log && kvm_slot_dirty_track_enabled(slot))
 		return NULL;
 
 	return slot;
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 0656de40bff7..43cde6e80a1a 100644
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
index f32f9fc60d0e..a0c19f398719 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1369,7 +1369,7 @@ int __kvm_set_memory_region(struct kvm *kvm,
 	/* Allocate/free page dirty bitmap as needed */
 	if (!(new.flags & KVM_MEM_LOG_DIRTY_PAGES))
 		new.dirty_bitmap = NULL;
-	else if (!new.dirty_bitmap) {
+	else if (!new.dirty_bitmap && !kvm->dirty_ring_size) {
 		r = kvm_alloc_dirty_bitmap(&new);
 		if (r)
 			return r;
@@ -2668,7 +2668,7 @@ static void mark_page_dirty_in_slot(struct kvm *kvm,
 				    struct kvm_memory_slot *memslot,
 				    gfn_t gfn)
 {
-	if (memslot && memslot->dirty_bitmap) {
+	if (memslot && kvm_slot_dirty_track_enabled(memslot)) {
 		unsigned long rel_gfn = gfn - memslot->base_gfn;
 		u32 slot = (memslot->as_id << 16) | memslot->id;
 
-- 
2.26.2

