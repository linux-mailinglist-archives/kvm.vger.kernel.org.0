Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 248FD2A941E
	for <lists+kvm@lfdr.de>; Fri,  6 Nov 2020 11:25:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726918AbgKFKZ0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Nov 2020 05:25:26 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24149 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726813AbgKFKZZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 6 Nov 2020 05:25:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604658324;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=rzIGS6pP6lZWtk6SQ8xr2MVcGhW0ibnx4UquLJftED4=;
        b=VSZbBYUBuQinlppbMy5K+664LCZwnmArxmoxG//XQBtGGARWEG1jAnRBj++UF+cXhl58im
        i8jNa1uHzp6nN3dxiYV82l+4sQYmGRu1tIrOirmnDCwLFZ7ljuNwCdbMwhwp7esarEtmDk
        6R2cPZcVwsgtM0uuj2AHrnMnvuQIHLU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-7-x8h7qqNrOmm7t1TuMTU4mg-1; Fri, 06 Nov 2020 05:25:22 -0500
X-MC-Unique: x8h7qqNrOmm7t1TuMTU4mg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 45DA01868416;
        Fri,  6 Nov 2020 10:25:21 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 024B519C4F;
        Fri,  6 Nov 2020 10:25:17 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     peterx@redhat.com
Subject: [PATCH] KVM: remove kvm_clear_guest_page
Date:   Fri,  6 Nov 2020 05:25:17 -0500
Message-Id: <20201106102517.664773-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

kvm_clear_guest_page is not used anymore after "KVM: X86: Don't track dirty
for KVM_SET_[TSS_ADDR|IDENTITY_MAP_ADDR]", except from kvm_clear_guest.
We can just inline it in its sole user.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 include/linux/kvm_host.h |  1 -
 virt/kvm/kvm_main.c      | 11 ++---------
 2 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 7f2e2a09ebbd..66a4324f329d 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -792,7 +792,6 @@ int kvm_gfn_to_hva_cache_init(struct kvm *kvm, struct gfn_to_hva_cache *ghc,
 			offset_in_page(__gpa), v);			\
 })
 
-int kvm_clear_guest_page(struct kvm *kvm, gfn_t gfn, int offset, int len);
 int kvm_clear_guest(struct kvm *kvm, gpa_t gpa, unsigned long len);
 struct kvm_memory_slot *gfn_to_memslot(struct kvm *kvm, gfn_t gfn);
 bool kvm_is_visible_gfn(struct kvm *kvm, gfn_t gfn);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 2541a17ff1c4..1c7514579861 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2616,23 +2616,16 @@ int kvm_read_guest_cached(struct kvm *kvm, struct gfn_to_hva_cache *ghc,
 }
 EXPORT_SYMBOL_GPL(kvm_read_guest_cached);
 
-int kvm_clear_guest_page(struct kvm *kvm, gfn_t gfn, int offset, int len)
-{
-	const void *zero_page = (const void *) __va(page_to_phys(ZERO_PAGE(0)));
-
-	return kvm_write_guest_page(kvm, gfn, zero_page, offset, len);
-}
-EXPORT_SYMBOL_GPL(kvm_clear_guest_page);
-
 int kvm_clear_guest(struct kvm *kvm, gpa_t gpa, unsigned long len)
 {
+	const void *zero_page = (const void *) __va(page_to_phys(ZERO_PAGE(0)));
 	gfn_t gfn = gpa >> PAGE_SHIFT;
 	int seg;
 	int offset = offset_in_page(gpa);
 	int ret;
 
 	while ((seg = next_segment(len, offset)) != 0) {
-		ret = kvm_clear_guest_page(kvm, gfn, offset, seg);
+		ret = kvm_write_guest_page(kvm, gfn, zero_page, offset, len);
 		if (ret < 0)
 			return ret;
 		offset = 0;
-- 
2.26.2

