Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22530128675
	for <lists+kvm@lfdr.de>; Sat, 21 Dec 2019 02:50:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727029AbfLUBu1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Dec 2019 20:50:27 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:42477 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726633AbfLUBtw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Dec 2019 20:49:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576892990;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xQjPBgffYJmUdXwhQa7UpTs/UC7BUPavY9NeRZmBhog=;
        b=A95bEOngC4YuEdI+DAKPu2z4aUKqEf0dyVKpWhZSFRGB5uEOrWGEp0wGFq2JT7/qr7Quav
        M2g0z8AwA3k0iNX4ZUUZLGH1t7CcmP6xM9OVY+7nV8R8e/S2KE4gIyI6y4AoNOTgPd24AG
        gDSvOKWDQDnJqjmTsO/hl/pYIUTY8VY=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-36-42ELN-csNBuqQaHr7ANrqQ-1; Fri, 20 Dec 2019 20:49:48 -0500
X-MC-Unique: 42ELN-csNBuqQaHr7ANrqQ-1
Received: by mail-qk1-f197.google.com with SMTP id m13so201373qka.9
        for <kvm@vger.kernel.org>; Fri, 20 Dec 2019 17:49:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xQjPBgffYJmUdXwhQa7UpTs/UC7BUPavY9NeRZmBhog=;
        b=ilLD4EsAxV2yB8P+EljaDEfRRBnJHm3qnAUG9YfujzesC5tXUhh76uavLksiOZq+uT
         rESMcr/IJwHxQpUDZSeadKl96MSVwaTqGUZcCNNVm1ffGbJ1XrlHc8UGnmLQis4lUHzg
         dVA9QCPuLVyMnukAwUUkBLqF+8+yGqDzAxVF4qcphyVmFWixnPNLT0jr/+pWF1qkwdUG
         hk/xSGo8k5ityIKpxjFr8hnfD84Ptrx4qjf5WFKcx5CGNVnGRHUWTWby/c0mhKeyvHhO
         GTqG5FXhYmVu+T9pKGNz3RkpiU0PGgy2HXozHpZ8CBRIZqH7j9eu2W2PyLr6wXbJCSKE
         tKDQ==
X-Gm-Message-State: APjAAAV9DF85eLPpnDs8jHHui+EQgXqwqF2h8+L4cqOQgwV6I1p6gx/0
        IqzQ6gVQH8Hsoi6QUxYxNbK6F4Y44atUA43YBbvnkqAVT6+UGDLJpG3E+Ok9ktNOkWgvj7jqp3l
        TM3/m8xgkVnHy
X-Received: by 2002:aed:3fce:: with SMTP id w14mr14857186qth.0.1576892988159;
        Fri, 20 Dec 2019 17:49:48 -0800 (PST)
X-Google-Smtp-Source: APXvYqxusDUFuW9fZ9zt/P8QAy4NqWh8OJ4WUcmcWJ8lRhEDt+5XnwaMK6qLOeb3rDbVcX7lOyD60g==
X-Received: by 2002:aed:3fce:: with SMTP id w14mr14857162qth.0.1576892987894;
        Fri, 20 Dec 2019 17:49:47 -0800 (PST)
Received: from xz-x1.hitronhub.home (CPEf81d0fb19163-CMf81d0fb19160.cpe.net.fido.ca. [72.137.123.47])
        by smtp.gmail.com with ESMTPSA id e21sm3396932qkm.55.2019.12.20.17.49.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Dec 2019 17:49:47 -0800 (PST)
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
Subject: [PATCH RESEND v2 03/17] KVM: X86: Don't track dirty for KVM_SET_[TSS_ADDR|IDENTITY_MAP_ADDR]
Date:   Fri, 20 Dec 2019 20:49:24 -0500
Message-Id: <20191221014938.58831-4-peterx@redhat.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191221014938.58831-1-peterx@redhat.com>
References: <20191221014938.58831-1-peterx@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Originally, we have three code paths that can dirty a page without
vcpu context for X86:

  - init_rmode_identity_map
  - init_rmode_tss
  - kvmgt_rw_gpa

init_rmode_identity_map and init_rmode_tss will be setup on
destination VM no matter what (and the guest cannot even see them), so
it does not make sense to track them at all.

To do this, a new parameter is added to kvm_[write|clear]_guest_page()
to show whether we would like to track dirty bits for the operations.
With that, pass in "false" to this new parameter for any guest memory
write of the ioctls (KVM_SET_TSS_ADDR, KVM_SET_IDENTITY_MAP_ADDR).

Signed-off-by: Peter Xu <peterx@redhat.com>
---
 arch/x86/kvm/vmx/vmx.c   | 18 ++++++++++--------
 include/linux/kvm_host.h |  5 +++--
 virt/kvm/kvm_main.c      | 25 ++++++++++++++++---------
 3 files changed, 29 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 04a8212704c1..1ff5a428f489 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3452,24 +3452,24 @@ static int init_rmode_tss(struct kvm *kvm)
 
 	idx = srcu_read_lock(&kvm->srcu);
 	fn = to_kvm_vmx(kvm)->tss_addr >> PAGE_SHIFT;
-	r = kvm_clear_guest_page(kvm, fn, 0, PAGE_SIZE);
+	r = kvm_clear_guest_page(kvm, fn, 0, PAGE_SIZE, false);
 	if (r < 0)
 		goto out;
 	data = TSS_BASE_SIZE + TSS_REDIRECTION_SIZE;
 	r = kvm_write_guest_page(kvm, fn++, &data,
-			TSS_IOPB_BASE_OFFSET, sizeof(u16));
+				 TSS_IOPB_BASE_OFFSET, sizeof(u16), false);
 	if (r < 0)
 		goto out;
-	r = kvm_clear_guest_page(kvm, fn++, 0, PAGE_SIZE);
+	r = kvm_clear_guest_page(kvm, fn++, 0, PAGE_SIZE, false);
 	if (r < 0)
 		goto out;
-	r = kvm_clear_guest_page(kvm, fn, 0, PAGE_SIZE);
+	r = kvm_clear_guest_page(kvm, fn, 0, PAGE_SIZE, false);
 	if (r < 0)
 		goto out;
 	data = ~0;
 	r = kvm_write_guest_page(kvm, fn, &data,
 				 RMODE_TSS_SIZE - 2 * PAGE_SIZE - 1,
-				 sizeof(u8));
+				 sizeof(u8), false);
 out:
 	srcu_read_unlock(&kvm->srcu, idx);
 	return r;
@@ -3498,7 +3498,7 @@ static int init_rmode_identity_map(struct kvm *kvm)
 		goto out2;
 
 	idx = srcu_read_lock(&kvm->srcu);
-	r = kvm_clear_guest_page(kvm, identity_map_pfn, 0, PAGE_SIZE);
+	r = kvm_clear_guest_page(kvm, identity_map_pfn, 0, PAGE_SIZE, false);
 	if (r < 0)
 		goto out;
 	/* Set up identity-mapping pagetable for EPT in real mode */
@@ -3506,7 +3506,8 @@ static int init_rmode_identity_map(struct kvm *kvm)
 		tmp = (i << 22) + (_PAGE_PRESENT | _PAGE_RW | _PAGE_USER |
 			_PAGE_ACCESSED | _PAGE_DIRTY | _PAGE_PSE);
 		r = kvm_write_guest_page(kvm, identity_map_pfn,
-				&tmp, i * sizeof(tmp), sizeof(tmp));
+					 &tmp, i * sizeof(tmp),
+					 sizeof(tmp), false);
 		if (r < 0)
 			goto out;
 	}
@@ -7265,7 +7266,8 @@ static int vmx_write_pml_buffer(struct kvm_vcpu *vcpu)
 		dst = vmcs12->pml_address + sizeof(u64) * vmcs12->guest_pml_index;
 
 		if (kvm_write_guest_page(vcpu->kvm, gpa_to_gfn(dst), &gpa,
-					 offset_in_page(dst), sizeof(gpa)))
+					 offset_in_page(dst), sizeof(gpa),
+					 false))
 			return 0;
 
 		vmcs12->guest_pml_index--;
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 2ea1ea79befd..4e34cf97ca90 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -734,7 +734,7 @@ int kvm_read_guest(struct kvm *kvm, gpa_t gpa, void *data, unsigned long len);
 int kvm_read_guest_cached(struct kvm *kvm, struct gfn_to_hva_cache *ghc,
 			   void *data, unsigned long len);
 int kvm_write_guest_page(struct kvm *kvm, gfn_t gfn, const void *data,
-			 int offset, int len);
+			 int offset, int len, bool track_dirty);
 int kvm_write_guest(struct kvm *kvm, gpa_t gpa, const void *data,
 		    unsigned long len);
 int kvm_write_guest_cached(struct kvm *kvm, struct gfn_to_hva_cache *ghc,
@@ -744,7 +744,8 @@ int kvm_write_guest_offset_cached(struct kvm *kvm, struct gfn_to_hva_cache *ghc,
 				  unsigned long len);
 int kvm_gfn_to_hva_cache_init(struct kvm *kvm, struct gfn_to_hva_cache *ghc,
 			      gpa_t gpa, unsigned long len);
-int kvm_clear_guest_page(struct kvm *kvm, gfn_t gfn, int offset, int len);
+int kvm_clear_guest_page(struct kvm *kvm, gfn_t gfn, int offset, int len,
+			 bool track_dirty);
 int kvm_clear_guest(struct kvm *kvm, gpa_t gpa, unsigned long len);
 struct kvm_memory_slot *gfn_to_memslot(struct kvm *kvm, gfn_t gfn);
 bool kvm_is_visible_gfn(struct kvm *kvm, gfn_t gfn);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 7ee28af9eb48..b1047173d78e 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2051,7 +2051,8 @@ int kvm_vcpu_read_guest_atomic(struct kvm_vcpu *vcpu, gpa_t gpa,
 EXPORT_SYMBOL_GPL(kvm_vcpu_read_guest_atomic);
 
 static int __kvm_write_guest_page(struct kvm_memory_slot *memslot, gfn_t gfn,
-			          const void *data, int offset, int len)
+			          const void *data, int offset, int len,
+				  bool track_dirty)
 {
 	int r;
 	unsigned long addr;
@@ -2062,16 +2063,19 @@ static int __kvm_write_guest_page(struct kvm_memory_slot *memslot, gfn_t gfn,
 	r = __copy_to_user((void __user *)addr + offset, data, len);
 	if (r)
 		return -EFAULT;
-	mark_page_dirty_in_slot(memslot, gfn);
+	if (track_dirty)
+		mark_page_dirty_in_slot(memslot, gfn);
 	return 0;
 }
 
 int kvm_write_guest_page(struct kvm *kvm, gfn_t gfn,
-			 const void *data, int offset, int len)
+			 const void *data, int offset, int len,
+			 bool track_dirty)
 {
 	struct kvm_memory_slot *slot = gfn_to_memslot(kvm, gfn);
 
-	return __kvm_write_guest_page(slot, gfn, data, offset, len);
+	return __kvm_write_guest_page(slot, gfn, data, offset, len,
+				      track_dirty);
 }
 EXPORT_SYMBOL_GPL(kvm_write_guest_page);
 
@@ -2080,7 +2084,8 @@ int kvm_vcpu_write_guest_page(struct kvm_vcpu *vcpu, gfn_t gfn,
 {
 	struct kvm_memory_slot *slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
 
-	return __kvm_write_guest_page(slot, gfn, data, offset, len);
+	return __kvm_write_guest_page(slot, gfn, data, offset,
+				      len, true);
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_write_guest_page);
 
@@ -2093,7 +2098,7 @@ int kvm_write_guest(struct kvm *kvm, gpa_t gpa, const void *data,
 	int ret;
 
 	while ((seg = next_segment(len, offset)) != 0) {
-		ret = kvm_write_guest_page(kvm, gfn, data, offset, seg);
+		ret = kvm_write_guest_page(kvm, gfn, data, offset, seg, true);
 		if (ret < 0)
 			return ret;
 		offset = 0;
@@ -2232,11 +2237,13 @@ int kvm_read_guest_cached(struct kvm *kvm, struct gfn_to_hva_cache *ghc,
 }
 EXPORT_SYMBOL_GPL(kvm_read_guest_cached);
 
-int kvm_clear_guest_page(struct kvm *kvm, gfn_t gfn, int offset, int len)
+int kvm_clear_guest_page(struct kvm *kvm, gfn_t gfn, int offset, int len,
+			 bool track_dirty)
 {
 	const void *zero_page = (const void *) __va(page_to_phys(ZERO_PAGE(0)));
 
-	return kvm_write_guest_page(kvm, gfn, zero_page, offset, len);
+	return kvm_write_guest_page(kvm, gfn, zero_page, offset, len,
+				    track_dirty);
 }
 EXPORT_SYMBOL_GPL(kvm_clear_guest_page);
 
@@ -2248,7 +2255,7 @@ int kvm_clear_guest(struct kvm *kvm, gpa_t gpa, unsigned long len)
 	int ret;
 
 	while ((seg = next_segment(len, offset)) != 0) {
-		ret = kvm_clear_guest_page(kvm, gfn, offset, seg);
+		ret = kvm_clear_guest_page(kvm, gfn, offset, seg, true);
 		if (ret < 0)
 			return ret;
 		offset = 0;
-- 
2.24.1

