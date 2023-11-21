Return-Path: <kvm+bounces-2213-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5157A7F358C
	for <lists+kvm@lfdr.de>; Tue, 21 Nov 2023 19:04:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0C60C282B9A
	for <lists+kvm@lfdr.de>; Tue, 21 Nov 2023 18:04:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C143722069;
	Tue, 21 Nov 2023 18:03:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=xen.org header.i=@xen.org header.b="erG+F38a"
X-Original-To: kvm@vger.kernel.org
Received: from mail.xenproject.org (mail.xenproject.org [104.130.215.37])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEA3219A;
	Tue, 21 Nov 2023 10:03:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=xen.org;
	s=20200302mail; h=Content-Transfer-Encoding:MIME-Version:References:
	In-Reply-To:Message-Id:Date:Subject:To:From;
	bh=ul4KEFASJpTyKeeWEaoEGIEJkAp76tc14RGcJ05EwiA=; b=erG+F38airXnNflww1t2so14R0
	digkEX2GGR3Oi798xyp5sw6vC2tZbX4ylcCt7x4nGGkjR4bBmgYvyfqau4e86DRvrXx27nu+XFmBY
	JMwv2gRcUEJxXpJqzao6rE77ceGI0+DXOQAcUnN/D/NLKJPIPRG3SxK2qyUPYAWywauw=;
Received: from xenbits.xenproject.org ([104.239.192.120])
	by mail.xenproject.org with esmtp (Exim 4.92)
	(envelope-from <paul@xen.org>)
	id 1r5V5f-00085K-UE; Tue, 21 Nov 2023 18:03:15 +0000
Received: from 54-240-197-231.amazon.com ([54.240.197.231] helo=REM-PW02S00X.ant.amazon.com)
	by xenbits.xenproject.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <paul@xen.org>)
	id 1r5V5f-0004Z3-Le; Tue, 21 Nov 2023 18:03:15 +0000
From: Paul Durrant <paul@xen.org>
To: David Woodhouse <dwmw2@infradead.org>,
	Paul Durrant <paul@xen.org>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v8 07/15] KVM: pfncache: include page offset in uhva and use it consistently
Date: Tue, 21 Nov 2023 18:02:15 +0000
Message-Id: <20231121180223.12484-8-paul@xen.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231121180223.12484-1-paul@xen.org>
References: <20231121180223.12484-1-paul@xen.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Paul Durrant <pdurrant@amazon.com>

Currently the pfncache page offset is sometimes determined using the gpa
and sometimes the khva, whilst the uhva is always page-aligned. After a
subsequent patch is applied the gpa will not always be valid so adjust
the code to include the page offset in the uhva and use it consistently
as the source of truth.

Also, where a page-aligned address is required, use PAGE_ALIGN_DOWN()
for clarity.

Signed-off-by: Paul Durrant <pdurrant@amazon.com>
---
Cc: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: David Woodhouse <dwmw2@infradead.org>

v8:
 - New in this version.
---
 virt/kvm/pfncache.c | 27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)

diff --git a/virt/kvm/pfncache.c b/virt/kvm/pfncache.c
index 0eeb034d0674..c545f6246501 100644
--- a/virt/kvm/pfncache.c
+++ b/virt/kvm/pfncache.c
@@ -48,10 +48,10 @@ bool kvm_gpc_check(struct gfn_to_pfn_cache *gpc, unsigned long len)
 	if (!gpc->active)
 		return false;
 
-	if (offset_in_page(gpc->gpa) + len > PAGE_SIZE)
+	if (gpc->generation != slots->generation || kvm_is_error_hva(gpc->uhva))
 		return false;
 
-	if (gpc->generation != slots->generation || kvm_is_error_hva(gpc->uhva))
+	if (offset_in_page(gpc->uhva) + len > PAGE_SIZE)
 		return false;
 
 	if (!gpc->valid)
@@ -119,7 +119,7 @@ static inline bool mmu_notifier_retry_cache(struct kvm *kvm, unsigned long mmu_s
 static kvm_pfn_t hva_to_pfn_retry(struct gfn_to_pfn_cache *gpc)
 {
 	/* Note, the new page offset may be different than the old! */
-	void *old_khva = gpc->khva - offset_in_page(gpc->khva);
+	void *old_khva = (void *)PAGE_ALIGN_DOWN((uintptr_t)gpc->khva);
 	kvm_pfn_t new_pfn = KVM_PFN_ERR_FAULT;
 	void *new_khva = NULL;
 	unsigned long mmu_seq;
@@ -192,7 +192,7 @@ static kvm_pfn_t hva_to_pfn_retry(struct gfn_to_pfn_cache *gpc)
 
 	gpc->valid = true;
 	gpc->pfn = new_pfn;
-	gpc->khva = new_khva + offset_in_page(gpc->gpa);
+	gpc->khva = new_khva + offset_in_page(gpc->uhva);
 
 	/*
 	 * Put the reference to the _new_ pfn.  The pfn is now tracked by the
@@ -215,8 +215,8 @@ static int __kvm_gpc_refresh(struct gfn_to_pfn_cache *gpc, gpa_t gpa,
 	struct kvm_memslots *slots = kvm_memslots(gpc->kvm);
 	unsigned long page_offset = offset_in_page(gpa);
 	bool unmap_old = false;
-	unsigned long old_uhva;
 	kvm_pfn_t old_pfn;
+	bool hva_change = false;
 	void *old_khva;
 	int ret;
 
@@ -242,8 +242,7 @@ static int __kvm_gpc_refresh(struct gfn_to_pfn_cache *gpc, gpa_t gpa,
 	}
 
 	old_pfn = gpc->pfn;
-	old_khva = gpc->khva - offset_in_page(gpc->khva);
-	old_uhva = gpc->uhva;
+	old_khva = (void *)PAGE_ALIGN_DOWN((uintptr_t)gpc->khva);
 
 	/* If the userspace HVA is invalid, refresh that first */
 	if (gpc->gpa != gpa || gpc->generation != slots->generation ||
@@ -259,13 +258,25 @@ static int __kvm_gpc_refresh(struct gfn_to_pfn_cache *gpc, gpa_t gpa,
 			ret = -EFAULT;
 			goto out;
 		}
+
+		hva_change = true;
+	} else {
+		/*
+		 * No need to do any re-mapping if the only thing that has
+		 * changed is the page offset. Just page align it to allow the
+		 * new offset to be added in.
+		 */
+		gpc->uhva = PAGE_ALIGN_DOWN(gpc->uhva);
 	}
 
+	/* Note: the offset must be correct before calling hva_to_pfn_retry() */
+	gpc->uhva += page_offset;
+
 	/*
 	 * If the userspace HVA changed or the PFN was already invalid,
 	 * drop the lock and do the HVA to PFN lookup again.
 	 */
-	if (!gpc->valid || old_uhva != gpc->uhva) {
+	if (!gpc->valid || hva_change) {
 		ret = hva_to_pfn_retry(gpc);
 	} else {
 		/*
-- 
2.39.2


