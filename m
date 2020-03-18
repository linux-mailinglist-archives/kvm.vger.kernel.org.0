Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B85B18A09A
	for <lists+kvm@lfdr.de>; Wed, 18 Mar 2020 17:38:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727187AbgCRQh6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Mar 2020 12:37:58 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:48001 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727222AbgCRQh6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 18 Mar 2020 12:37:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584549476;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JQNQ8EKMwfaTG4iN1CtwGNUUCvT2F90E2HxXpDz/FrM=;
        b=XnY5E4+oaMzaYh9pO2jG+hZZrWLJFD/KJO+nszzRqD/dYxzFTVunJeCqdrftNHGP81LI2j
        eWOhBW/jTmtVmYGcrYdHrItZovex0itBfXacqcmECJezARczK7bSPM6hUbxLv9B4oGwsbg
        FUeL3o/yMt26JGsmS3FKs93u0sxwSPw=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-301-hWWcBNnAMeyfZEAerUTBAw-1; Wed, 18 Mar 2020 12:37:55 -0400
X-MC-Unique: hWWcBNnAMeyfZEAerUTBAw-1
Received: by mail-wm1-f72.google.com with SMTP id p18so1325655wmk.9
        for <kvm@vger.kernel.org>; Wed, 18 Mar 2020 09:37:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JQNQ8EKMwfaTG4iN1CtwGNUUCvT2F90E2HxXpDz/FrM=;
        b=s4jBc/A63dKw0rtMVDHn0NpXa35430kpKrBUILkXWwF+X8QzsIqKsaURfEOFoSsJsO
         QBGmX1Gnoegwi0i4qN3i9A0Xf02RMUobXqBHUKYEQhFhV45TvKavsYtVWL3ExLtAn3Sk
         FUHrpQwXtt70gWgQcsr+BxEzACNp965AWobVKDDIA/f0GUp88ooAgUeHdjhLKh9Esf76
         ccRfcbwOK6T6A8xWyRs8YA7jkJmvjJi4CbgOeiwY0PlpS8O3+Zppn669LYDo7lxyYraQ
         vYKEjbU08N9A23PppwjjniOx5qDTvIua/TPS+kBr5V19/AuZZOPqIZUDJXDlxzpGx/JS
         K/ww==
X-Gm-Message-State: ANhLgQ1Ma4e4sYvcIm2JVnLEF1iaetMwSdGM6O+YQbGXrhxvc2+9ands
        FCJ7hv/vorZVl6DggmbPIONMirLGn6qRLJWbd0myKSCnp9SYqLBDwYIePp8AmAlbDPmsGfzktdl
        zOGz+sRcUzsae
X-Received: by 2002:adf:b18b:: with SMTP id q11mr6268183wra.240.1584549473902;
        Wed, 18 Mar 2020 09:37:53 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vuwi587FpKJ6PlqfvOI5XJ4zyt/rOggdr0fCO5u9+IAf/o2/rgemOq6iMqYD4l3GGGoYXs+Xg==
X-Received: by 2002:adf:b18b:: with SMTP id q11mr6268150wra.240.1584549473640;
        Wed, 18 Mar 2020 09:37:53 -0700 (PDT)
Received: from xz-x1.redhat.com ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id x206sm4282406wmg.17.2020.03.18.09.37.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Mar 2020 09:37:53 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     "Michael S . Tsirkin" <mst@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Yan Zhao <yan.y.zhao@intel.com>, peterx@redhat.com,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Christophe de Dinechin <dinechin@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v7 04/14] KVM: Pass in kvm pointer into mark_page_dirty_in_slot()
Date:   Wed, 18 Mar 2020 12:37:10 -0400
Message-Id: <20200318163720.93929-5-peterx@redhat.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200318163720.93929-1-peterx@redhat.com>
References: <20200318163720.93929-1-peterx@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The context will be needed to implement the kvm dirty ring.

Signed-off-by: Peter Xu <peterx@redhat.com>
---
 virt/kvm/kvm_main.c | 33 +++++++++++++++++++--------------
 1 file changed, 19 insertions(+), 14 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index e24e7111a308..6838dc6ba394 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -144,7 +144,9 @@ static void hardware_disable_all(void);
 
 static void kvm_io_bus_destroy(struct kvm_io_bus *bus);
 
-static void mark_page_dirty_in_slot(struct kvm_memory_slot *memslot, gfn_t gfn);
+static void mark_page_dirty_in_slot(struct kvm *kvm,
+				    struct kvm_memory_slot *memslot,
+				    gfn_t gfn);
 
 __visible bool kvm_rebooting;
 EXPORT_SYMBOL_GPL(kvm_rebooting);
@@ -2117,7 +2119,8 @@ int kvm_vcpu_map(struct kvm_vcpu *vcpu, gfn_t gfn, struct kvm_host_map *map)
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_map);
 
-static void __kvm_unmap_gfn(struct kvm_memory_slot *memslot,
+static void __kvm_unmap_gfn(struct kvm *kvm,
+			struct kvm_memory_slot *memslot,
 			struct kvm_host_map *map,
 			struct gfn_to_pfn_cache *cache,
 			bool dirty, bool atomic)
@@ -2142,7 +2145,7 @@ static void __kvm_unmap_gfn(struct kvm_memory_slot *memslot,
 #endif
 
 	if (dirty)
-		mark_page_dirty_in_slot(memslot, map->gfn);
+		mark_page_dirty_in_slot(kvm, memslot, map->gfn);
 
 	if (cache)
 		cache->dirty |= dirty;
@@ -2156,7 +2159,7 @@ static void __kvm_unmap_gfn(struct kvm_memory_slot *memslot,
 int kvm_unmap_gfn(struct kvm_vcpu *vcpu, struct kvm_host_map *map, 
 		  struct gfn_to_pfn_cache *cache, bool dirty, bool atomic)
 {
-	__kvm_unmap_gfn(gfn_to_memslot(vcpu->kvm, map->gfn), map,
+	__kvm_unmap_gfn(vcpu->kvm, gfn_to_memslot(vcpu->kvm, map->gfn), map,
 			cache, dirty, atomic);
 	return 0;
 }
@@ -2164,8 +2167,8 @@ EXPORT_SYMBOL_GPL(kvm_unmap_gfn);
 
 void kvm_vcpu_unmap(struct kvm_vcpu *vcpu, struct kvm_host_map *map, bool dirty)
 {
-	__kvm_unmap_gfn(kvm_vcpu_gfn_to_memslot(vcpu, map->gfn), map, NULL,
-			dirty, false);
+	__kvm_unmap_gfn(vcpu->kvm, kvm_vcpu_gfn_to_memslot(vcpu, map->gfn),
+			map, NULL, dirty, false);
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_unmap);
 
@@ -2339,7 +2342,8 @@ int kvm_vcpu_read_guest_atomic(struct kvm_vcpu *vcpu, gpa_t gpa,
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_read_guest_atomic);
 
-static int __kvm_write_guest_page(struct kvm_memory_slot *memslot, gfn_t gfn,
+static int __kvm_write_guest_page(struct kvm *kvm,
+				  struct kvm_memory_slot *memslot, gfn_t gfn,
 			          const void *data, int offset, int len)
 {
 	int r;
@@ -2351,7 +2355,7 @@ static int __kvm_write_guest_page(struct kvm_memory_slot *memslot, gfn_t gfn,
 	r = __copy_to_user((void __user *)addr + offset, data, len);
 	if (r)
 		return -EFAULT;
-	mark_page_dirty_in_slot(memslot, gfn);
+	mark_page_dirty_in_slot(kvm, memslot, gfn);
 	return 0;
 }
 
@@ -2360,7 +2364,7 @@ int kvm_write_guest_page(struct kvm *kvm, gfn_t gfn,
 {
 	struct kvm_memory_slot *slot = gfn_to_memslot(kvm, gfn);
 
-	return __kvm_write_guest_page(slot, gfn, data, offset, len);
+	return __kvm_write_guest_page(kvm, slot, gfn, data, offset, len);
 }
 EXPORT_SYMBOL_GPL(kvm_write_guest_page);
 
@@ -2369,7 +2373,7 @@ int kvm_vcpu_write_guest_page(struct kvm_vcpu *vcpu, gfn_t gfn,
 {
 	struct kvm_memory_slot *slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
 
-	return __kvm_write_guest_page(slot, gfn, data, offset, len);
+	return __kvm_write_guest_page(vcpu->kvm, slot, gfn, data, offset, len);
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_write_guest_page);
 
@@ -2488,7 +2492,7 @@ int kvm_write_guest_offset_cached(struct kvm *kvm, struct gfn_to_hva_cache *ghc,
 	r = __copy_to_user((void __user *)ghc->hva + offset, data, len);
 	if (r)
 		return -EFAULT;
-	mark_page_dirty_in_slot(ghc->memslot, gpa >> PAGE_SHIFT);
+	mark_page_dirty_in_slot(kvm, ghc->memslot, gpa >> PAGE_SHIFT);
 
 	return 0;
 }
@@ -2555,7 +2559,8 @@ int kvm_clear_guest(struct kvm *kvm, gpa_t gpa, unsigned long len)
 }
 EXPORT_SYMBOL_GPL(kvm_clear_guest);
 
-static void mark_page_dirty_in_slot(struct kvm_memory_slot *memslot,
+static void mark_page_dirty_in_slot(struct kvm *kvm,
+				    struct kvm_memory_slot *memslot,
 				    gfn_t gfn)
 {
 	if (memslot && memslot->dirty_bitmap) {
@@ -2570,7 +2575,7 @@ void mark_page_dirty(struct kvm *kvm, gfn_t gfn)
 	struct kvm_memory_slot *memslot;
 
 	memslot = gfn_to_memslot(kvm, gfn);
-	mark_page_dirty_in_slot(memslot, gfn);
+	mark_page_dirty_in_slot(kvm, memslot, gfn);
 }
 EXPORT_SYMBOL_GPL(mark_page_dirty);
 
@@ -2579,7 +2584,7 @@ void kvm_vcpu_mark_page_dirty(struct kvm_vcpu *vcpu, gfn_t gfn)
 	struct kvm_memory_slot *memslot;
 
 	memslot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
-	mark_page_dirty_in_slot(memslot, gfn);
+	mark_page_dirty_in_slot(vcpu->kvm, memslot, gfn);
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_mark_page_dirty);
 
-- 
2.24.1

