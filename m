Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3F581DFB7E
	for <lists+kvm@lfdr.de>; Sun, 24 May 2020 00:59:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388252AbgEWW5a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 23 May 2020 18:57:30 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:60124 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2388234AbgEWW52 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 23 May 2020 18:57:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590274646;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MlUVdjeJ0J1hQ9k5pkbQKVuK1AkzVVvG+iv/Zueckg0=;
        b=JKTe7v1MxTDsOam/+Q/TGTX8jgkT2Rme6ektBXurlrijpdN8Wracs8KW11AoA1aO5Hq0jZ
        6HiEWOIwamMbaywtt1cK+6/RKn3ZsnnQDUtYh9PNRvUvX/wdhRdvsxMiExnkarlt+S70h5
        gJFTnVOkqAquVdqfoettbEgiLIk/Rgo=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-97-6BR_myCbPmKB8hMJafLWwQ-1; Sat, 23 May 2020 18:57:24 -0400
X-MC-Unique: 6BR_myCbPmKB8hMJafLWwQ-1
Received: by mail-qt1-f197.google.com with SMTP id 19so15924347qtp.8
        for <kvm@vger.kernel.org>; Sat, 23 May 2020 15:57:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MlUVdjeJ0J1hQ9k5pkbQKVuK1AkzVVvG+iv/Zueckg0=;
        b=XVTodd6WrnbXGMiU8hASwoTliJuhfYB8vpKQ5MQC+X8G0ACjmh+IhbiGfpm1ZDIKZs
         Jr00a0NAC65IHUBU8hK2vnI8dwMhWZiFCEGpdXj3ekzdCoD1x3Q0k5SRYAt9LVrb01rD
         Z7bBqK6csPWETMRRkMCoUIs19X5yHQbYjg9nFAJGt8bRTTmx6G/Ndlb09oSPWAs5a8hT
         1WKKJgNwumB4RsouL/GwV8ho4eZAv9AWWeFkkQeuDfqJr6ElUMaqY6y8oc4Uo6QcuLdT
         jUQlgm5n3kfQnP7Tzzuprlm1wIN69UaRr4FW4fcrRhrQYVEyR6GGCDVoKMNP63KU4yQZ
         lYeg==
X-Gm-Message-State: AOAM530vcu0jkRw9v6mqoZQRaTeQ5LTx5adRfbykH4YBsvVDxppQm3ak
        e+jH8kBmjcEUTCJdTAJoam8288ibUutUYJKV8fqxxbK1iFkC0qio+80leMC6EFW+4mqtGhZwNuM
        lSK2/d72qH0C9
X-Received: by 2002:a0c:b60c:: with SMTP id f12mr9814666qve.244.1590274644155;
        Sat, 23 May 2020 15:57:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwEpr2rTp0JHKP5YqM2SA8N//ah+ThOYj9WbkHvw7lOkC/5fdIL+wNw3pRJyi7DmAx3q/SzRA==
X-Received: by 2002:a0c:b60c:: with SMTP id f12mr9814661qve.244.1590274643903;
        Sat, 23 May 2020 15:57:23 -0700 (PDT)
Received: from xz-x1.hitronhub.home (CPEf81d0fb19163-CMf81d0fb19160.cpe.net.fido.ca. [72.137.123.47])
        by smtp.gmail.com with ESMTPSA id w14sm11630979qtt.82.2020.05.23.15.57.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 May 2020 15:57:22 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Christophe de Dinechin <dinechin@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>, peterx@redhat.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH v9 07/14] KVM: Don't allocate dirty bitmap if dirty ring is enabled
Date:   Sat, 23 May 2020 18:56:52 -0400
Message-Id: <20200523225659.1027044-8-peterx@redhat.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200523225659.1027044-1-peterx@redhat.com>
References: <20200523225659.1027044-1-peterx@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
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
 arch/x86/kvm/mmu/mmu.c   | 4 ++--
 include/linux/kvm_host.h | 5 +++++
 virt/kvm/kvm_main.c      | 4 ++--
 3 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 94d84a383b80..ebc86f661db3 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1276,8 +1276,8 @@ gfn_to_memslot_dirty_bitmap(struct kvm_vcpu *vcpu, gfn_t gfn,
 	slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
 	if (!slot || slot->flags & KVM_MEMSLOT_INVALID)
 		return NULL;
-	if (no_dirty_log && slot->dirty_bitmap)
-		return NULL;
+	if (no_dirty_log && kvm_slot_dirty_track_enabled(slot))
+		return false;
 
 	return slot;
 }
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index a7eaef494f45..5081c6e2ae06 100644
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
index 9639cf8d8c9c..ae7ba67eab63 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1294,7 +1294,7 @@ int __kvm_set_memory_region(struct kvm *kvm,
 	/* Allocate/free page dirty bitmap as needed */
 	if (!(new.flags & KVM_MEM_LOG_DIRTY_PAGES))
 		new.dirty_bitmap = NULL;
-	else if (!new.dirty_bitmap) {
+	else if (!new.dirty_bitmap && !kvm->dirty_ring_size) {
 		r = kvm_alloc_dirty_bitmap(&new);
 		if (r)
 			return r;
@@ -2581,7 +2581,7 @@ static void mark_page_dirty_in_slot(struct kvm *kvm,
 				    struct kvm_memory_slot *memslot,
 				    gfn_t gfn)
 {
-	if (memslot && memslot->dirty_bitmap) {
+	if (memslot && kvm_slot_dirty_track_enabled(memslot)) {
 		unsigned long rel_gfn = gfn - memslot->base_gfn;
 		u32 slot = (memslot->as_id << 16) | memslot->id;
 
-- 
2.26.2

