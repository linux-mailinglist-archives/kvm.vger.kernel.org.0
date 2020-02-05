Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 902F91524F5
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2020 03:59:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727862AbgBEC6u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Feb 2020 21:58:50 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:26702 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727708AbgBEC6t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Feb 2020 21:58:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580871528;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iMoyuUQG6mGTZVCTKYztmS6Hs0K242TSdWPEeOxZW6A=;
        b=Zk8Pnsf2ajJs2A8PU1TMYhlCMP3QCH+1zyGe7XH59GdobpRhqwsakGFtcWBX6ZKSjAdfAr
        z/SBWwrcX7HbYbeCfvmgUYLgzluBlxc3hEwf3Jpex99tjYbcLq982afc4JuLs5z52Scaou
        AK2HwdMUH1ycPgML81mtVr8bpsWuo24=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-50-82FxKHxYPEGgZODUFk0-Ng-1; Tue, 04 Feb 2020 21:58:46 -0500
X-MC-Unique: 82FxKHxYPEGgZODUFk0-Ng-1
Received: by mail-qv1-f71.google.com with SMTP id dc2so631932qvb.7
        for <kvm@vger.kernel.org>; Tue, 04 Feb 2020 18:58:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iMoyuUQG6mGTZVCTKYztmS6Hs0K242TSdWPEeOxZW6A=;
        b=jBmc5V3iyIDPoS9LVIZbn9srDvE06K2trImDOoSECT5izMG0uXRoIpyVqDANtR7e3X
         6JNAOcLB/eqMCLHlsq394Vq6RatAXZjVlx0OtlJ1mPI0864XijLcL//sC0YsmHhP/EX8
         xWzNxNnOl14Ay6N+tZw7GJZTINOp271IypN8JxWFd6egfp07mR4T5BOwLsihkNteO8dc
         TLr3lDhc3W+shHkAYytX8JKxiU6I/tEbdPxy9+64ABFEJtZjLcXNCVBNCqn2VRdZ0TRK
         jjlXqGxUXwophf2lXchVDrqdWRLaX3AuYlPUlhicZvuh9C/CybppNIWnMWdlmUaDkYD4
         4JSw==
X-Gm-Message-State: APjAAAWhQVQ6KY48jO/BmSsUMqK8XvxgKaoE09T9GDFAU6KC1MALeUNB
        vfH0ZKLlRjXpDKLZ7bFUr28QRILfhAl3Zi+KIkK/12SsBpJNRQbbrStoLNLAXACPpEK/0GMKV7U
        j2zP2pA9fDUoB
X-Received: by 2002:ac8:1415:: with SMTP id k21mr31821680qtj.300.1580871525712;
        Tue, 04 Feb 2020 18:58:45 -0800 (PST)
X-Google-Smtp-Source: APXvYqwcW1YtKLT8v5bd10IJa63sORuNDIe53LmsHkfWJo8kyUKgeShP1B4VamT5gnlv2wvLf68pxw==
X-Received: by 2002:ac8:1415:: with SMTP id k21mr31821664qtj.300.1580871525461;
        Tue, 04 Feb 2020 18:58:45 -0800 (PST)
Received: from xz-x1.redhat.com ([2607:9880:19c8:32::2])
        by smtp.gmail.com with ESMTPSA id e64sm12961649qtd.45.2020.02.04.18.58.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Feb 2020 18:58:44 -0800 (PST)
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     dinechin@redhat.com, sean.j.christopherson@intel.com,
        pbonzini@redhat.com, jasowang@redhat.com, yan.y.zhao@intel.com,
        mst@redhat.com, peterx@redhat.com, kevin.tian@intel.com,
        alex.williamson@redhat.com, dgilbert@redhat.com,
        vkuznets@redhat.com
Subject: [PATCH 04/14] KVM: Pass in kvm pointer into mark_page_dirty_in_slot()
Date:   Tue,  4 Feb 2020 21:58:32 -0500
Message-Id: <20200205025842.367575-1-peterx@redhat.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200205025105.367213-1-peterx@redhat.com>
References: <20200205025105.367213-1-peterx@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The context will be needed to implement the kvm dirty ring.

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Peter Xu <peterx@redhat.com>
---
 virt/kvm/kvm_main.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 69190f9f7bd8..5307f6e33587 100644
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
@@ -2057,7 +2059,8 @@ int kvm_vcpu_read_guest_atomic(struct kvm_vcpu *vcpu, gpa_t gpa,
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_read_guest_atomic);
 
-static int __kvm_write_guest_page(struct kvm_memory_slot *memslot, gfn_t gfn,
+static int __kvm_write_guest_page(struct kvm *kvm,
+				  struct kvm_memory_slot *memslot, gfn_t gfn,
 			          const void *data, int offset, int len)
 {
 	int r;
@@ -2069,7 +2072,7 @@ static int __kvm_write_guest_page(struct kvm_memory_slot *memslot, gfn_t gfn,
 	r = __copy_to_user((void __user *)addr + offset, data, len);
 	if (r)
 		return -EFAULT;
-	mark_page_dirty_in_slot(memslot, gfn);
+	mark_page_dirty_in_slot(kvm, memslot, gfn);
 	return 0;
 }
 
@@ -2078,7 +2081,7 @@ int kvm_write_guest_page(struct kvm *kvm, gfn_t gfn,
 {
 	struct kvm_memory_slot *slot = gfn_to_memslot(kvm, gfn);
 
-	return __kvm_write_guest_page(slot, gfn, data, offset, len);
+	return __kvm_write_guest_page(kvm, slot, gfn, data, offset, len);
 }
 EXPORT_SYMBOL_GPL(kvm_write_guest_page);
 
@@ -2087,7 +2090,7 @@ int kvm_vcpu_write_guest_page(struct kvm_vcpu *vcpu, gfn_t gfn,
 {
 	struct kvm_memory_slot *slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
 
-	return __kvm_write_guest_page(slot, gfn, data, offset, len);
+	return __kvm_write_guest_page(vcpu->kvm, slot, gfn, data, offset, len);
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_write_guest_page);
 
@@ -2206,7 +2209,7 @@ int kvm_write_guest_offset_cached(struct kvm *kvm, struct gfn_to_hva_cache *ghc,
 	r = __copy_to_user((void __user *)ghc->hva + offset, data, len);
 	if (r)
 		return -EFAULT;
-	mark_page_dirty_in_slot(ghc->memslot, gpa >> PAGE_SHIFT);
+	mark_page_dirty_in_slot(kvm, ghc->memslot, gpa >> PAGE_SHIFT);
 
 	return 0;
 }
@@ -2273,7 +2276,8 @@ int kvm_clear_guest(struct kvm *kvm, gpa_t gpa, unsigned long len)
 }
 EXPORT_SYMBOL_GPL(kvm_clear_guest);
 
-static void mark_page_dirty_in_slot(struct kvm_memory_slot *memslot,
+static void mark_page_dirty_in_slot(struct kvm *kvm,
+				    struct kvm_memory_slot *memslot,
 				    gfn_t gfn)
 {
 	if (memslot && memslot->dirty_bitmap) {
@@ -2288,7 +2292,7 @@ void mark_page_dirty(struct kvm *kvm, gfn_t gfn)
 	struct kvm_memory_slot *memslot;
 
 	memslot = gfn_to_memslot(kvm, gfn);
-	mark_page_dirty_in_slot(memslot, gfn);
+	mark_page_dirty_in_slot(kvm, memslot, gfn);
 }
 EXPORT_SYMBOL_GPL(mark_page_dirty);
 
@@ -2297,7 +2301,7 @@ void kvm_vcpu_mark_page_dirty(struct kvm_vcpu *vcpu, gfn_t gfn)
 	struct kvm_memory_slot *memslot;
 
 	memslot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
-	mark_page_dirty_in_slot(memslot, gfn);
+	mark_page_dirty_in_slot(vcpu->kvm, memslot, gfn);
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_mark_page_dirty);
 
-- 
2.24.1

