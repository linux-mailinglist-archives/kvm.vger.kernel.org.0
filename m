Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25E682190CC
	for <lists+kvm@lfdr.de>; Wed,  8 Jul 2020 21:35:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726894AbgGHTfP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jul 2020 15:35:15 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:24453 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726789AbgGHTe0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 8 Jul 2020 15:34:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594236864;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+DuEkmhXAvt9+R96raKtmzheUiL1ATBvHnUNG4ad3CE=;
        b=YptxLJJvjK7L7lypUpjowsPI28dLyij6Pj5Hmcuh8yGR5gSkbA1MZ1gJkf9KuNmNwBEROP
        hA96/z7PGG7EknkAhOqTAUuz9r5HCuBnNBAkghyR5dN63agFCODxVjVKzx2nRNZbfCd6sl
        6J/9ALW0pHcqAmnOcWerz4G6Z18Qo7U=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-107-IpyGiVh0PZKpQiNVak_01g-1; Wed, 08 Jul 2020 15:34:23 -0400
X-MC-Unique: IpyGiVh0PZKpQiNVak_01g-1
Received: by mail-qv1-f71.google.com with SMTP id cv20so19021320qvb.12
        for <kvm@vger.kernel.org>; Wed, 08 Jul 2020 12:34:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+DuEkmhXAvt9+R96raKtmzheUiL1ATBvHnUNG4ad3CE=;
        b=tap6D7vmNnsAPNcAasN1eBjtH17f0V2IZ1bQQRVFL6GKbDNv3Exycv/8Dyw0/AQ8yW
         5sgx5uH8boFqt7lzjPT+ju0LyGmFgybmjxLE0Mqq7hP0LJM3AOeAqIXk3YI0ZEQ656jm
         BHM307rDxPb/0YEDsmbXI3cmNKAP1wI3g7AbOlNHLRYJrJ9De81h+W+BhJVwGZw0GLXB
         uPw8QWXyoznn3wT6m83HG/nny5IK2ZaxkymKzq0BspXN197IDRtb3kvDDKjlyt3fkWVx
         YgTW7TdW8k4gKw5swBkhVLM93qaNCdClvX9iduWCtKavta1iRLrHzeN6W5zW1czqz25E
         69fg==
X-Gm-Message-State: AOAM530I0vd+P1QF/9tA/rVfUW154kRYvmkfsDtbLlTsAur62ylZsQSe
        Xk6Xbdu86BvpTX2H1g+oqEsR0KNE8Y1vRGR5ItAqrHGCYhmdTt5gR2Qah8lFp02dViqsE3kMfNg
        zAMZHCdMmbYAB
X-Received: by 2002:ac8:4714:: with SMTP id f20mr61043902qtp.141.1594236862621;
        Wed, 08 Jul 2020 12:34:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJygriJjnnU7BuDycPb8rWE85wv0+HxahjfXXPH3ZmHI/biWbw63o5AVBW+tBMH9XxKtFI9kHg==
X-Received: by 2002:ac8:4714:: with SMTP id f20mr61043881qtp.141.1594236862384;
        Wed, 08 Jul 2020 12:34:22 -0700 (PDT)
Received: from xz-x1.redhat.com ([2607:9880:19c8:6f::1f4f])
        by smtp.gmail.com with ESMTPSA id f18sm664884qtc.28.2020.07.08.12.34.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2020 12:34:21 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     peterx@redhat.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v11 06/13] KVM: Don't allocate dirty bitmap if dirty ring is enabled
Date:   Wed,  8 Jul 2020 15:34:01 -0400
Message-Id: <20200708193408.242909-7-peterx@redhat.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200708193408.242909-1-peterx@redhat.com>
References: <20200708193408.242909-1-peterx@redhat.com>
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
 arch/x86/kvm/mmu/mmu.c   | 2 +-
 include/linux/kvm_host.h | 5 +++++
 virt/kvm/kvm_main.c      | 4 ++--
 3 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 1ed625445bef..df5ff9f0232a 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1278,7 +1278,7 @@ gfn_to_memslot_dirty_bitmap(struct kvm_vcpu *vcpu, gfn_t gfn,
 	slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
 	if (!slot || slot->flags & KVM_MEMSLOT_INVALID)
 		return NULL;
-	if (no_dirty_log && slot->dirty_bitmap)
+	if (no_dirty_log && kvm_slot_dirty_track_enabled(slot))
 		return NULL;
 
 	return slot;
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 824dd15df580..f749ac50c898 100644
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
index c8c249edc885..b5b6401c0270 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1313,7 +1313,7 @@ int __kvm_set_memory_region(struct kvm *kvm,
 	/* Allocate/free page dirty bitmap as needed */
 	if (!(new.flags & KVM_MEM_LOG_DIRTY_PAGES))
 		new.dirty_bitmap = NULL;
-	else if (!new.dirty_bitmap) {
+	else if (!new.dirty_bitmap && !kvm->dirty_ring_size) {
 		r = kvm_alloc_dirty_bitmap(&new);
 		if (r)
 			return r;
@@ -2604,7 +2604,7 @@ static void mark_page_dirty_in_slot(struct kvm *kvm,
 				    struct kvm_memory_slot *memslot,
 				    gfn_t gfn)
 {
-	if (memslot && memslot->dirty_bitmap) {
+	if (memslot && kvm_slot_dirty_track_enabled(memslot)) {
 		unsigned long rel_gfn = gfn - memslot->base_gfn;
 		u32 slot = (memslot->as_id << 16) | memslot->id;
 
-- 
2.26.2

