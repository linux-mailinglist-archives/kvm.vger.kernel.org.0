Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD166128377
	for <lists+kvm@lfdr.de>; Fri, 20 Dec 2019 22:02:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727612AbfLTVCC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Dec 2019 16:02:02 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:27724 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727595AbfLTVCB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Dec 2019 16:02:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576875720;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Pol5PWFpYE9QDZtFO4p/0Ih4s1j3WxPFfstxyW/mAdA=;
        b=hzwLttrhX60vxgak5o+hMNOJ/7L9SLphvHpCekJ7vnp0a8AO5vmLmnOKcAG1s5yJ4WzQn3
        rMd2U+JuEnak9ahgNNI8QL7vRPwCE8BebEcm1zEOtdrlVRh3RLLDSBebvV6U5ZpP+sWOKk
        qWyVRo+0pPL9h/k0Yq2YrA6Ag4ZJOaw=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-415-Vhl17eNdP06dM0ANEShHNw-1; Fri, 20 Dec 2019 16:01:59 -0500
X-MC-Unique: Vhl17eNdP06dM0ANEShHNw-1
Received: by mail-qt1-f199.google.com with SMTP id l1so6758802qtp.21
        for <kvm@vger.kernel.org>; Fri, 20 Dec 2019 13:01:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Pol5PWFpYE9QDZtFO4p/0Ih4s1j3WxPFfstxyW/mAdA=;
        b=kGzQ78Yyhfun8F218ZAjesjxRjwrNq7dwKbA8aI7Y9X5hwENZF9EAyCZoSQ4oevuLP
         cnYmeVMSsHP1Cpl1dDVxq96Xu2wQM/3iQ610Zt4JTi71P6gOiE4mstJxiGr4TTVsSe/C
         DhqgO4vpEgX+4MIRe+o53x81PQxYF+HnjOhA/lI/sqAiVzmSJkLWTqCbMATeXPJEyF1Y
         EWhqW52rrq1benbZhcikzrffusyIEt1EezEV24UhkvI//uNDaUNj6pawgJtR4i5FNZt7
         ZGl59LXNz6cMMBGBD1V8o4G3GvObtK6q3NNcJdcyb+V1QmhGSTRL4afjrxBWZ7R1hV8W
         53DA==
X-Gm-Message-State: APjAAAXSWM5ytIBz817x0FjM+ac1OGFut9Ig/AqD6mTxbisAIP8sNVnT
        4FiyjmpU3pTiY3GkJE12OaZVspiER+puzoppchm5AvHwzhb92giXKbG3RHfEoDC7Eg3trwxmEQK
        dJnG+lQ0ovl53
X-Received: by 2002:a05:620a:136e:: with SMTP id d14mr14833536qkl.342.1576875718842;
        Fri, 20 Dec 2019 13:01:58 -0800 (PST)
X-Google-Smtp-Source: APXvYqwmejq1un/q5Y5HhQi65oM6oBQnk5ATnGfGkoCMJcANM3lipg4NnfeVvRTMvdSOX2vtDM4QcQ==
X-Received: by 2002:a05:620a:136e:: with SMTP id d14mr14833515qkl.342.1576875718617;
        Fri, 20 Dec 2019 13:01:58 -0800 (PST)
Received: from xz-x1.redhat.com ([104.156.64.74])
        by smtp.gmail.com with ESMTPSA id q25sm3243836qkq.88.2019.12.20.13.01.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Dec 2019 13:01:57 -0800 (PST)
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Jason Wang <jasowang@redhat.com>, peterx@redhat.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Christophe de Dinechin <dinechin@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>
Subject: [PATCH v2 06/17] KVM: Pass in kvm pointer into mark_page_dirty_in_slot()
Date:   Fri, 20 Dec 2019 16:01:36 -0500
Message-Id: <20191220210147.49617-7-peterx@redhat.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191220210147.49617-1-peterx@redhat.com>
References: <20191220210147.49617-1-peterx@redhat.com>
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

