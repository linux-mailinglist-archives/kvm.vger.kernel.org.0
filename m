Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93FD83DDF3D
	for <lists+kvm@lfdr.de>; Mon,  2 Aug 2021 20:33:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231199AbhHBSdz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Aug 2021 14:33:55 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:24186 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230506AbhHBSdx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 2 Aug 2021 14:33:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627929223;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Y0XEacTTDUSlhr+SbKYIkZXMudH6vraVMEcqoiG/vJU=;
        b=Ve6Guht8ez6a3Y2uHCA+tAp77onq6oHZNnt7LFrdApLQHqClj/kuAJpVUqsARqz9MDHZ9G
        rqebnl7+7kBWetbmYqWqVTzgTUxgGX83Y2rTA0txVq3KAunzAkgFuYMz2EYSOrZtfuoJbf
        WpN/vjGB5Dx79RqFqdHorzqSLNo0JGU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-2-unGUVflsMw-JuaNSVWQaZA-1; Mon, 02 Aug 2021 14:33:39 -0400
X-MC-Unique: unGUVflsMw-JuaNSVWQaZA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 43EF1824F83;
        Mon,  2 Aug 2021 18:33:38 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.50])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 73F043AE1;
        Mon,  2 Aug 2021 18:33:34 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@alien8.de>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE (32-BIT AND
        64-BIT)), Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v3 01/12] Revert "KVM: x86/mmu: Allow zap gfn range to operate under the mmu read lock"
Date:   Mon,  2 Aug 2021 21:33:18 +0300
Message-Id: <20210802183329.2309921-2-mlevitsk@redhat.com>
In-Reply-To: <20210802183329.2309921-1-mlevitsk@redhat.com>
References: <20210802183329.2309921-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

This together with the next patch will fix a future race between
kvm_zap_gfn_range and the page fault handler, which will happen
when AVIC memslot is going to be only partially disabled.

This is based on a patch suggested by Sean Christopherson:
https://lkml.org/lkml/2021/7/22/1025

Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c     | 19 ++++++++-----------
 arch/x86/kvm/mmu/tdp_mmu.c | 15 ++++-----------
 arch/x86/kvm/mmu/tdp_mmu.h | 11 ++++-------
 3 files changed, 16 insertions(+), 29 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index a8cdfd8d45c4..9d78cb1c0f35 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5638,8 +5638,9 @@ void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
 	int i;
 	bool flush = false;
 
+	write_lock(&kvm->mmu_lock);
+
 	if (kvm_memslots_have_rmaps(kvm)) {
-		write_lock(&kvm->mmu_lock);
 		for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
 			slots = __kvm_memslots(kvm, i);
 			kvm_for_each_memslot(memslot, slots) {
@@ -5659,22 +5660,18 @@ void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
 		}
 		if (flush)
 			kvm_flush_remote_tlbs_with_address(kvm, gfn_start, gfn_end);
-		write_unlock(&kvm->mmu_lock);
 	}
 
 	if (is_tdp_mmu_enabled(kvm)) {
-		flush = false;
-
-		read_lock(&kvm->mmu_lock);
 		for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++)
 			flush = kvm_tdp_mmu_zap_gfn_range(kvm, i, gfn_start,
-							  gfn_end, flush, true);
-		if (flush)
-			kvm_flush_remote_tlbs_with_address(kvm, gfn_start,
-							   gfn_end);
-
-		read_unlock(&kvm->mmu_lock);
+							  gfn_end, flush);
 	}
+
+	if (flush)
+		kvm_flush_remote_tlbs_with_address(kvm, gfn_start, gfn_end);
+
+	write_unlock(&kvm->mmu_lock);
 }
 
 static bool slot_rmap_write_protect(struct kvm *kvm,
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 43f12f5d12c0..3e0222ce3f4e 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -777,21 +777,15 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
  * non-root pages mapping GFNs strictly within that range. Returns true if
  * SPTEs have been cleared and a TLB flush is needed before releasing the
  * MMU lock.
- *
- * If shared is true, this thread holds the MMU lock in read mode and must
- * account for the possibility that other threads are modifying the paging
- * structures concurrently. If shared is false, this thread should hold the
- * MMU in write mode.
  */
 bool __kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, int as_id, gfn_t start,
-				 gfn_t end, bool can_yield, bool flush,
-				 bool shared)
+				 gfn_t end, bool can_yield, bool flush)
 {
 	struct kvm_mmu_page *root;
 
-	for_each_tdp_mmu_root_yield_safe(kvm, root, as_id, shared)
+	for_each_tdp_mmu_root_yield_safe(kvm, root, as_id, false)
 		flush = zap_gfn_range(kvm, root, start, end, can_yield, flush,
-				      shared);
+				      false);
 
 	return flush;
 }
@@ -803,8 +797,7 @@ void kvm_tdp_mmu_zap_all(struct kvm *kvm)
 	int i;
 
 	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++)
-		flush = kvm_tdp_mmu_zap_gfn_range(kvm, i, 0, max_gfn,
-						  flush, false);
+		flush = kvm_tdp_mmu_zap_gfn_range(kvm, i, 0, max_gfn, flush);
 
 	if (flush)
 		kvm_flush_remote_tlbs(kvm);
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index b224d126adf9..358f447d4012 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -20,14 +20,11 @@ void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root,
 			  bool shared);
 
 bool __kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, int as_id, gfn_t start,
-				 gfn_t end, bool can_yield, bool flush,
-				 bool shared);
+				 gfn_t end, bool can_yield, bool flush);
 static inline bool kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, int as_id,
-					     gfn_t start, gfn_t end, bool flush,
-					     bool shared)
+					     gfn_t start, gfn_t end, bool flush)
 {
-	return __kvm_tdp_mmu_zap_gfn_range(kvm, as_id, start, end, true, flush,
-					   shared);
+	return __kvm_tdp_mmu_zap_gfn_range(kvm, as_id, start, end, true, flush);
 }
 static inline bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
 {
@@ -44,7 +41,7 @@ static inline bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
 	 */
 	lockdep_assert_held_write(&kvm->mmu_lock);
 	return __kvm_tdp_mmu_zap_gfn_range(kvm, kvm_mmu_page_as_id(sp),
-					   sp->gfn, end, false, false, false);
+					   sp->gfn, end, false, false);
 }
 
 void kvm_tdp_mmu_zap_all(struct kvm *kvm);
-- 
2.26.3

