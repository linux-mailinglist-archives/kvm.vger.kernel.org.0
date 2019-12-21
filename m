Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AEE3F12866B
	for <lists+kvm@lfdr.de>; Sat, 21 Dec 2019 02:50:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726965AbfLUBt6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Dec 2019 20:49:58 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:28043 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726936AbfLUBt5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 20 Dec 2019 20:49:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576892995;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Pol5PWFpYE9QDZtFO4p/0Ih4s1j3WxPFfstxyW/mAdA=;
        b=Kj515We8Tvq170gtJt8vvKjxbSzzEOPnr/s4RcjaPAO2X2XkIteoJQd1TsnY81i3H1kXkd
        wn74fF5zsAXh+UEsxzQ8v6bh+xcqY4DOMktfNzgnzOMPFlKFRHERIZRrrBwTviCWOk54Fr
        HfFmMOpMGJdDRY89ZDQs7UDFDec71jA=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-304-sCngDPFHO_u-bBy6JLbqJQ-1; Fri, 20 Dec 2019 20:49:54 -0500
X-MC-Unique: sCngDPFHO_u-bBy6JLbqJQ-1
Received: by mail-qt1-f199.google.com with SMTP id o24so2167689qtr.17
        for <kvm@vger.kernel.org>; Fri, 20 Dec 2019 17:49:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Pol5PWFpYE9QDZtFO4p/0Ih4s1j3WxPFfstxyW/mAdA=;
        b=pjU1VWj6sxA5PchzURcBWPIm4BATU4o+MdCh7KY6bWWVYngdCvdFL+P61ELtzMB8Zy
         oUFZvUenNvK9XG2rp1k9OpF7Ecc6hS/Uc3kLOrh9/Ig4zpuZXhLcREhkQQaYfqi91aRW
         qDsv1nRetfreD/zMdfxcriN05NIa/Z6UocYBqu6GIy1TypfoXJ4yk7nM9aIW7ZFkVV/1
         3jqP1ySTyQ8JOsly32TIZVsVBYSseWikBd1CB8oopt3bqHNnhLw79ZCY1GDims3HyENT
         aedCw4BPYhmvZlCfKN/HrLzwv7ClxaMGSEyziGbYAOPKHeOK6C+wOm7d/zG86ZLf9jyE
         YBJA==
X-Gm-Message-State: APjAAAVsmi3sGYo2nFvOvodlDBLhKG5qucLT131RXpGzmBqoK4SckPtx
        kWn6DXp3DwRkjsQdVPDq9aq3C/d4Wf8v9iAGgvWMvGV4g7qp6MuXK09ODVHXSqWcp879Lrhc1oS
        KnH0ZdGCnh8He
X-Received: by 2002:ac8:43c1:: with SMTP id w1mr3396759qtn.156.1576892993863;
        Fri, 20 Dec 2019 17:49:53 -0800 (PST)
X-Google-Smtp-Source: APXvYqwexdTgJ4zu662hB1w/QZ+qxEl14+TJcNVwxCuytbomEU65sXvbKltJEPimaJYhb8IhcKe3kw==
X-Received: by 2002:ac8:43c1:: with SMTP id w1mr3396744qtn.156.1576892993680;
        Fri, 20 Dec 2019 17:49:53 -0800 (PST)
Received: from xz-x1.hitronhub.home (CPEf81d0fb19163-CMf81d0fb19160.cpe.net.fido.ca. [72.137.123.47])
        by smtp.gmail.com with ESMTPSA id e21sm3396932qkm.55.2019.12.20.17.49.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Dec 2019 17:49:53 -0800 (PST)
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Christophe de Dinechin <dinechin@redhat.com>,
        peterx@redhat.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [PATCH RESEND v2 06/17] KVM: Pass in kvm pointer into mark_page_dirty_in_slot()
Date:   Fri, 20 Dec 2019 20:49:27 -0500
Message-Id: <20191221014938.58831-7-peterx@redhat.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191221014938.58831-1-peterx@redhat.com>
References: <20191221014938.58831-1-peterx@redhat.com>
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

