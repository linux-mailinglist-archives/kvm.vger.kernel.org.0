Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0038D1283BD
	for <lists+kvm@lfdr.de>; Fri, 20 Dec 2019 22:17:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727669AbfLTVRL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Dec 2019 16:17:11 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:55858 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727605AbfLTVQu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 20 Dec 2019 16:16:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576876609;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Pol5PWFpYE9QDZtFO4p/0Ih4s1j3WxPFfstxyW/mAdA=;
        b=Hj06DgbM3woctTNhZtoHyNDvb4XkXnvp/nvvspAgmk6AGkrZ2r4aM7TjgRMF4W3j10febg
        sZJOg9GI1WT2ARHP/Qwz7ZUCYqp4QkbgMeF+fKtbAI9T2NesVJSEtk3zcIVX6asOdQRagP
        XNUi7okjmTnRKj73IXgXlGRcpezMVgk=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-401-rzdIGd08O4iS2Hv3Jsik3Q-1; Fri, 20 Dec 2019 16:16:47 -0500
X-MC-Unique: rzdIGd08O4iS2Hv3Jsik3Q-1
Received: by mail-qt1-f197.google.com with SMTP id d9so2338056qtq.13
        for <kvm@vger.kernel.org>; Fri, 20 Dec 2019 13:16:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Pol5PWFpYE9QDZtFO4p/0Ih4s1j3WxPFfstxyW/mAdA=;
        b=BNu7cfgVrf6gdHDnbc4yaTqxq7l7ZKd+UP5a5yfzrVYMiiPoOaVrvuE+BjP8+qWN6m
         qQyJK9UghNT7R56q1jslbA6GhJK7w1sDAC/Ekeb0GOop2imtPNpxXVjbrpFuY2qtk/oa
         46K1VFjJzTA0+YOEEVJhBERfoM8EhuHWOJggj5+F6U/XqAk4JF/Ev8OA15uCXZ0BLeOz
         W8NC62JI1SL/Jfq019bIBE1AU0ait82TXcSBlH0C4KoxSedFalWamrXDzW1i5aZnvvpW
         gPUccGbmLdRmzC7MsZJjXjmf3Om0bouB4aTOY2mDv72ERu0+DRCMYpuJb9RuVdubg2u3
         4aBw==
X-Gm-Message-State: APjAAAXNB92QPB4jSSl9V5XtIG8bwOZveqjQNC6DdKFQof+87h9iLd+k
        ysb1Cdk1Va4G9jV9rzxtKrERkNtL2oa9ZdCoW8lmBSgDJmqpABeNU9Dz48/FJZxVBkL3ju6AHXH
        +pMrINJgO4Q3o
X-Received: by 2002:ac8:47d3:: with SMTP id d19mr13203051qtr.142.1576876606792;
        Fri, 20 Dec 2019 13:16:46 -0800 (PST)
X-Google-Smtp-Source: APXvYqzNym5p3t8R3aAuwzdPCLNwWO1VoH4b45iDYzDaeWWsmzp0D8R3vZGPxt/vm34Ap2UdpnYSjQ==
X-Received: by 2002:ac8:47d3:: with SMTP id d19mr13203032qtr.142.1576876606597;
        Fri, 20 Dec 2019 13:16:46 -0800 (PST)
Received: from xz-x1.redhat.com ([104.156.64.74])
        by smtp.gmail.com with ESMTPSA id d25sm3385231qtq.11.2019.12.20.13.16.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Dec 2019 13:16:46 -0800 (PST)
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     "Michael S . Tsirkin" <mst@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>, peterx@redhat.com,
        Jason Wang <jasowang@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Christophe de Dinechin <dinechin@redhat.com>
Subject: [PATCH v2 06/17] KVM: Pass in kvm pointer into mark_page_dirty_in_slot()
Date:   Fri, 20 Dec 2019 16:16:23 -0500
Message-Id: <20191220211634.51231-7-peterx@redhat.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191220211634.51231-1-peterx@redhat.com>
References: <20191220211634.51231-1-peterx@redhat.com>
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

