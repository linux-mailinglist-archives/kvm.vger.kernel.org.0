Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 149FC128390
	for <lists+kvm@lfdr.de>; Fri, 20 Dec 2019 22:04:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727657AbfLTVDp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Dec 2019 16:03:45 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:44822 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727791AbfLTVDo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Dec 2019 16:03:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576875823;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Pol5PWFpYE9QDZtFO4p/0Ih4s1j3WxPFfstxyW/mAdA=;
        b=DY6BObZwpbNZmPs8rTOT6EIyAK7uEeoq6ACN1ZqqlWH6K2AAVoIG45HAs9PCtpGbQ27/Oo
        4gjWNYPyvTha+RW8YGhCGvN4BoA8R6tjSAMJpDyQVQEJ9SZRw95mlZDdUU3z6woJfBS7R7
        XkMCVfJszGe6dr0vEySpboh6j1JwAJc=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-278-6w-vEMEUPQm06gzJzBjFgQ-1; Fri, 20 Dec 2019 16:03:41 -0500
X-MC-Unique: 6w-vEMEUPQm06gzJzBjFgQ-1
Received: by mail-qv1-f72.google.com with SMTP id n11so6715130qvp.15
        for <kvm@vger.kernel.org>; Fri, 20 Dec 2019 13:03:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Pol5PWFpYE9QDZtFO4p/0Ih4s1j3WxPFfstxyW/mAdA=;
        b=J7H/jjoHfSpeLexzdNyuLZv8tnmGWMDWfYJzO3/mo23QXXkh0HGBKfu6hNXE5vt2rq
         u1PitISVptJvGjrCYf0AWz3pRuDxem1XGbDvRGdQxh7L6aIgoRDvPrNL7s1zhjkfom6H
         Nz5F485FPSUMk0LMPZp7LiS9OFcaaSw0LM8qTLnL+mmApzM3IoURzWB5tlx+yfooCNfc
         TOaj75NGM/3b0M93QCrI8y7kDIhpBGbvQinZRPoqfWra+YwpEH9APxKxM4l7O+K437u4
         5OaGgIlvrhHjnqvBYAxqIR4wpPuoNn/YEGN0aqvIIMTRO39OLHuUxRnK6/D9gxOulsff
         HcLA==
X-Gm-Message-State: APjAAAVzpcuDiOqGPyIDCubvNG+HQxGQxhuvb9fsiISQrdz/YcZokHI3
        RJEJ+4in6Up2rgf5BJLpP0YyonfBjssGsqsLrPAeKSnA3kuMQ0LCkC7DbjBULTjfO3uJ83LVkhW
        pgD5WyINp/Q5z
X-Received: by 2002:a05:6214:154b:: with SMTP id t11mr14198261qvw.175.1576875820317;
        Fri, 20 Dec 2019 13:03:40 -0800 (PST)
X-Google-Smtp-Source: APXvYqzGnJV6VBQmJy+GFtTEPIamqoxpbiwGxjBUhIu4gj7U2ESjQ87es1j2xQ7YLZG/dmVH7VrxCg==
X-Received: by 2002:a05:6214:154b:: with SMTP id t11mr14198242qvw.175.1576875820067;
        Fri, 20 Dec 2019 13:03:40 -0800 (PST)
Received: from xz-x1.redhat.com ([104.156.64.74])
        by smtp.gmail.com with ESMTPSA id a9sm3061018qtb.36.2019.12.20.13.03.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Dec 2019 13:03:39 -0800 (PST)
From:   Peter Xu <peterx@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     peterx@redhat.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Christophe de Dinechin <dinechin@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Jason Wang <jasowang@redhat.com>
Subject: [PATCH v2 06/17] KVM: Pass in kvm pointer into mark_page_dirty_in_slot()
Date:   Fri, 20 Dec 2019 16:03:15 -0500
Message-Id: <20191220210326.49949-7-peterx@redhat.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191220210326.49949-1-peterx@redhat.com>
References: <20191220210326.49949-1-peterx@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The context will be needed to implement the kvm dirty ring.

Signed-off-by: Peter Xu <peterx@redhat.com>
---
 virt/kvm/kvm_main.c | 24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index c80a363831ae..17969cf110dd 100644
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
@@ -2053,8 +2055,9 @@ int kvm_vcpu_read_guest_atomic(struct kvm_vcpu *vcpu, gpa_t gpa,
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_read_guest_atomic);
 
-static int __kvm_write_guest_page(struct kvm_memory_slot *memslot, gfn_t gfn,
-			          const void *data, int offset, int len,
+static int __kvm_write_guest_page(struct kvm *kvm,
+				  struct kvm_memory_slot *memslot, gfn_t gfn,
+				  const void *data, int offset, int len,
 				  bool track_dirty)
 {
 	int r;
@@ -2067,7 +2070,7 @@ static int __kvm_write_guest_page(struct kvm_memory_slot *memslot, gfn_t gfn,
 	if (r)
 		return -EFAULT;
 	if (track_dirty)
-		mark_page_dirty_in_slot(memslot, gfn);
+		mark_page_dirty_in_slot(kvm, memslot, gfn);
 	return 0;
 }
 
@@ -2077,7 +2080,7 @@ int kvm_write_guest_page(struct kvm *kvm, gfn_t gfn,
 {
 	struct kvm_memory_slot *slot = gfn_to_memslot(kvm, gfn);
 
-	return __kvm_write_guest_page(slot, gfn, data, offset, len,
+	return __kvm_write_guest_page(kvm, slot, gfn, data, offset, len,
 				      track_dirty);
 }
 EXPORT_SYMBOL_GPL(kvm_write_guest_page);
@@ -2087,7 +2090,7 @@ int kvm_vcpu_write_guest_page(struct kvm_vcpu *vcpu, gfn_t gfn,
 {
 	struct kvm_memory_slot *slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
 
-	return __kvm_write_guest_page(slot, gfn, data, offset,
+	return __kvm_write_guest_page(vcpu->kvm, slot, gfn, data, offset,
 				      len, true);
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_write_guest_page);
@@ -2202,7 +2205,7 @@ int kvm_write_guest_offset_cached(struct kvm *kvm, struct gfn_to_hva_cache *ghc,
 	r = __copy_to_user((void __user *)ghc->hva + offset, data, len);
 	if (r)
 		return -EFAULT;
-	mark_page_dirty_in_slot(ghc->memslot, gpa >> PAGE_SHIFT);
+	mark_page_dirty_in_slot(kvm, ghc->memslot, gpa >> PAGE_SHIFT);
 
 	return 0;
 }
@@ -2269,7 +2272,8 @@ int kvm_clear_guest(struct kvm *kvm, gpa_t gpa, unsigned long len)
 }
 EXPORT_SYMBOL_GPL(kvm_clear_guest);
 
-static void mark_page_dirty_in_slot(struct kvm_memory_slot *memslot,
+static void mark_page_dirty_in_slot(struct kvm *kvm,
+				    struct kvm_memory_slot *memslot,
 				    gfn_t gfn)
 {
 	if (memslot && memslot->dirty_bitmap) {
@@ -2284,7 +2288,7 @@ void mark_page_dirty(struct kvm *kvm, gfn_t gfn)
 	struct kvm_memory_slot *memslot;
 
 	memslot = gfn_to_memslot(kvm, gfn);
-	mark_page_dirty_in_slot(memslot, gfn);
+	mark_page_dirty_in_slot(kvm, memslot, gfn);
 }
 EXPORT_SYMBOL_GPL(mark_page_dirty);
 
@@ -2293,7 +2297,7 @@ void kvm_vcpu_mark_page_dirty(struct kvm_vcpu *vcpu, gfn_t gfn)
 	struct kvm_memory_slot *memslot;
 
 	memslot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
-	mark_page_dirty_in_slot(memslot, gfn);
+	mark_page_dirty_in_slot(vcpu->kvm, memslot, gfn);
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_mark_page_dirty);
 
-- 
2.24.1

