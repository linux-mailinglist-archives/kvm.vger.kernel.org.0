Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3548B27F47C
	for <lists+kvm@lfdr.de>; Wed, 30 Sep 2020 23:55:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730961AbgI3Vyq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Sep 2020 17:54:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:50552 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728721AbgI3Vyl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 30 Sep 2020 17:54:41 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601502879;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dVzpa3BKRx0YyAVDajEnp/DonC0rVrA5Oak/DU3uxIQ=;
        b=HeZ4mTrK8AMcYtQxYbo0G7Z1L3o2JMKGWKk/Yia3MFxThkySH7KOHEeUZB1CoQmOVqXccp
        t1Evxmrc6/C57sqrtuqYAAWem4LVLPrTuqZVJVWzdQzAWPKcaFy66xrCbJj2R25LNVt3TS
        h/qm1Vvdywg2Yq0m37K93ypons+LTWU=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-230-EaUpCmy3M4uYuncbu29FRQ-1; Wed, 30 Sep 2020 17:54:38 -0400
X-MC-Unique: EaUpCmy3M4uYuncbu29FRQ-1
Received: by mail-qv1-f69.google.com with SMTP id ct11so1832227qvb.16
        for <kvm@vger.kernel.org>; Wed, 30 Sep 2020 14:54:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dVzpa3BKRx0YyAVDajEnp/DonC0rVrA5Oak/DU3uxIQ=;
        b=Jidv5FqNybTS7SpPcj11Gsgbzi7QyrCGZRTaDp1OpLclf5PtlR72G7NXxCsaLfZrdq
         CZCkkZfBLkL5yMVE4ttPwJlizNLN9k3VPBW+IC5OOdjKFVHFuAbd4Dkd7RXw7O5QFwmQ
         qttHOVlHwdRMKikOK5jXBQRGaGVxatwcCZFu9B4wX81QewGR1ml5Cv2mbY6wCRoJ5P1E
         r3ItKQ97BMdavaHw1GPhkW9aHzq2zhGOXXNJTsGT3LRW+nNDwjLkDY8poRuO7nepqD+r
         zsQ/3YXUCo1+ozXhHknN696ajjU6W9JCoCcFPAU2s5UIKkNC9OM6ZJ8vop8Pnm8ktD2s
         P14g==
X-Gm-Message-State: AOAM531fEsGamqFmLv/6Wwg2c7lqIGBRGjxgBUCp0UVtDyLMu9EMF5Ea
        rGGUmQYcrrGsGZf+BmRAsEj8rWBh4SN4EGWUvvNxA+KfrDh5Ip+46bW7msrax8k8tV/aUlTcUue
        VEuMzq5vmZZbR
X-Received: by 2002:a37:a354:: with SMTP id m81mr4858657qke.307.1601502877447;
        Wed, 30 Sep 2020 14:54:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJybrUOcPMiUfoNVfwXbXElgAaRYjk3+O2DIjtqFBoAzmMevewCXwe9C/uZ1bhbMiQWUGicOyA==
X-Received: by 2002:a37:a354:: with SMTP id m81mr4858643qke.307.1601502877202;
        Wed, 30 Sep 2020 14:54:37 -0700 (PDT)
Received: from xz-x1.redhat.com (toroon474qw-lp130-09-184-147-14-204.dsl.bell.ca. [184.147.14.204])
        by smtp.gmail.com with ESMTPSA id f33sm4065834qtb.45.2020.09.30.14.54.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Sep 2020 14:54:36 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Andrew Jones <drjones@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>, peterx@redhat.com
Subject: [PATCH v12 06/13] KVM: Don't allocate dirty bitmap if dirty ring is enabled
Date:   Wed, 30 Sep 2020 17:54:35 -0400
Message-Id: <20200930215435.48054-1-peterx@redhat.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200930214948.47225-1-peterx@redhat.com>
References: <20200930214948.47225-1-peterx@redhat.com>
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
index 4a030b668cb9..7ce9f3e3efdd 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1237,7 +1237,7 @@ gfn_to_memslot_dirty_bitmap(struct kvm_vcpu *vcpu, gfn_t gfn,
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
index 0574a9725727..8f1cda853ec2 100644
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

