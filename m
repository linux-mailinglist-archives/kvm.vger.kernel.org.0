Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E41F12867D
	for <lists+kvm@lfdr.de>; Sat, 21 Dec 2019 02:58:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726671AbfLUB6X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Dec 2019 20:58:23 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:37159 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726633AbfLUB6X (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 20 Dec 2019 20:58:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576893502;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aLnceZhQvz4L7d3FILFkZlXmK4gcpiqbWBlsyV3pAtU=;
        b=WcpCrYsSXmV43VMFaGfdV+hmMYv3Ug2+re9GMPA82rObd21292fY6bWz20o+ceWKMlsdUu
        0sMIqE+Y8KNZULuBZblCcvg1x//BaUK0/Gyh94rK/UPzU7JYDXGHEPDur+NMl5ApcDGWgd
        QCjeQl0kHwX8G7U+l2wzf6KV+UNc6xE=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-163-A6m_AsXRMLG9Ipii4Kl2cg-1; Fri, 20 Dec 2019 20:58:20 -0500
X-MC-Unique: A6m_AsXRMLG9Ipii4Kl2cg-1
Received: by mail-qk1-f200.google.com with SMTP id k10so1887871qki.2
        for <kvm@vger.kernel.org>; Fri, 20 Dec 2019 17:58:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aLnceZhQvz4L7d3FILFkZlXmK4gcpiqbWBlsyV3pAtU=;
        b=MZlCd5Lz3Jab8w8kln3bp0tP6wnImswKY7S8GzKwo8OecBmC9opWpWJG723FBM/2ch
         DwZifH1zQaiVV2fF9FxNZ1LW6VtfQtmg7vKi626M/QJ2MvA0jTlVm2typRpkAQ4WG9vA
         yfg2qUOiZBP267olfGXHt2FaKUURi+NiJhhR/OYYHO9ddwnV7Q3ULRmNmc9JNLDyWeET
         kDamgdAw3Nm3I3fkw0Cr+/ZThgJH+eUf0lKnnjOeBczYnMK7FMXAaVZ9KTlz1baYN8A9
         8tqY5jpyW3Ev1soBg2/hEx0iufkr6mWVuYXT45Wj803h7rP36rfsgFV+4uG/ke4cdtR2
         vkfQ==
X-Gm-Message-State: APjAAAXIWHP5nc7GTmviZ3XHuxjCLBMj72yDEEVbMtAUloGxS2kkHKwx
        7AoFMbgh+fxTh7NoVxJyqQX038VaT5i/2eUMwiry5SMlD6RwL1Lo/O7iOvwZdIL40CCLp5XyR5s
        sa1vkESBu3tYf
X-Received: by 2002:a37:3d8:: with SMTP id 207mr15869153qkd.335.1576893500015;
        Fri, 20 Dec 2019 17:58:20 -0800 (PST)
X-Google-Smtp-Source: APXvYqx5DU0WULLKatVhGXGRGbGlKp19wDJAuuBgK1zQE/iicrZZvmuGD5jchP31zgAGacHyHkw59Q==
X-Received: by 2002:a37:3d8:: with SMTP id 207mr15869137qkd.335.1576893499774;
        Fri, 20 Dec 2019 17:58:19 -0800 (PST)
Received: from xz-x1.hitronhub.home (CPEf81d0fb19163-CMf81d0fb19160.cpe.net.fido.ca. [72.137.123.47])
        by smtp.gmail.com with ESMTPSA id c8sm3660106qtv.61.2019.12.20.17.58.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Dec 2019 17:58:19 -0800 (PST)
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Peter Xu <peterx@redhat.com>,
        Dr David Alan Gilbert <dgilbert@redhat.com>,
        Christophe de Dinechin <dinechin@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S . Tsirkin " <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [PATCH RESEND v2 10/17] KVM: Don't allocate dirty bitmap if dirty ring is enabled
Date:   Fri, 20 Dec 2019 20:58:17 -0500
Message-Id: <20191221015817.59537-1-peterx@redhat.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191221014938.58831-1-peterx@redhat.com>
References: 
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
 include/linux/kvm_host.h | 5 +++++
 virt/kvm/kvm_main.c      | 5 +++--
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index dff214ab72eb..725650aac05d 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -353,6 +353,11 @@ struct kvm_memory_slot {
 	u8 as_id;
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
index b69d34425f8d..bb11fec1bf08 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1113,7 +1113,8 @@ int __kvm_set_memory_region(struct kvm *kvm,
 	}
 
 	/* Allocate page dirty bitmap if needed */
-	if ((new.flags & KVM_MEM_LOG_DIRTY_PAGES) && !new.dirty_bitmap) {
+	if ((new.flags & KVM_MEM_LOG_DIRTY_PAGES) && !new.dirty_bitmap &&
+	    !kvm->dirty_ring_size) {
 		if (kvm_create_dirty_bitmap(&new) < 0)
 			goto out_free;
 	}
@@ -2312,7 +2313,7 @@ static void mark_page_dirty_in_slot(struct kvm *kvm,
 				    struct kvm_memory_slot *memslot,
 				    gfn_t gfn)
 {
-	if (memslot && memslot->dirty_bitmap) {
+	if (memslot && kvm_slot_dirty_track_enabled(memslot)) {
 		unsigned long rel_gfn = gfn - memslot->base_gfn;
 
 		if (kvm->dirty_ring_size)
-- 
2.24.1

