Return-Path: <kvm+bounces-10344-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8859286BF33
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 04:00:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AB4E31C21C2E
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 03:00:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF30B43AD8;
	Thu, 29 Feb 2024 02:58:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="iMgLyVET"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oi1-f174.google.com (mail-oi1-f174.google.com [209.85.167.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69EB242053
	for <kvm@vger.kernel.org>; Thu, 29 Feb 2024 02:58:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709175517; cv=none; b=qxgqLMRkv3q6kGWkqeJYtjsemk9Ix3+rQtOke7xM6BWMEyECzlpcw2iH+vxgujvbdhRhPe1h+OsXWb/TKIUU9WDaIJg/t5qJoYgMEDKbBvvyrFmCQroZA2zwYBKeM7v7TDnYysJ/QWg/dUTpEOzCN1YtCnXCdqlpS7D9v3uTFb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709175517; c=relaxed/simple;
	bh=UIJzBxDI/Inn6eJziAqaeOpmUvLyyhxfpWjO2dCmE1Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gJJuXJc2pmJJspq+CveRvmU+9PuA4UvKtqLw290Py2NAOelHS2IHacFv+lHDCJYUsiKFJPfafBhkaQRodMaTi5cvUAP2I3xj7wsf4Z19tDAzlnMs4JCkenCbjAjN36ovc0W0fhbi12v2T8TJA0MOHKm+ruOtmJcLtvAFtGIAMwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=iMgLyVET; arc=none smtp.client-ip=209.85.167.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Received: by mail-oi1-f174.google.com with SMTP id 5614622812f47-3bb9d54575cso256067b6e.2
        for <kvm@vger.kernel.org>; Wed, 28 Feb 2024 18:58:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1709175514; x=1709780314; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rjuEwew1c9XXdIDCEsgjgWaQEbnELox0pWUx+WG8IvI=;
        b=iMgLyVETxWC8KRYKo/7f74QL9LDcZBAMlVPkBKvtTNYj/ZL14ZW7CKnWrEJVkO1PKA
         mBcVirTjXDxpOt84VuuDZLrF/Z3h5ayEsGwJvGsfhp0e9xPGn9eNwv7r2Kovve3L+KVF
         odJU3QEC08tnBddJm/oQYWU46oyOvELb6P/jI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709175514; x=1709780314;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rjuEwew1c9XXdIDCEsgjgWaQEbnELox0pWUx+WG8IvI=;
        b=dD8zEODzihFiWMVNoAVNHH79iIbivPf1HCrSKOuRwGSAbQXVKAc+ARLgqW6oi2pZHK
         J9OYH3gTpJ/yeTLOotGOsvzG3twHACH8NqdPY1/d4Q2O8LpVrppS92z824VbDLHA2jz6
         LoCQ8QaPZgQXuZG5e1v5vJK45FD9Pul0iKQc0KkVq5rYQbQrDP0U/4lw8MBuGmctULNw
         xXvmhdjCgI+3mwGqNFrcWg3v6WgSE22toe2OlOCM8yD8BCS/p0JPjkYmmzn12pHH8Mdz
         UaIpfrYz3Tf0DC4zIpY8tSrHfysdeEr1r8rZtq/HDxxbf8GEm7o10LTP+6YhlBl/vw3a
         sutw==
X-Forwarded-Encrypted: i=1; AJvYcCXfp5AnN73J1ox/abwxOAFh+ADNK7unznzfeWZW18mqhxaJKwdC+PfHA3EXpDqeB2zkYiBQVZWjzVeQyPky00Q9Bjqp
X-Gm-Message-State: AOJu0YzlGAJ7ujDzsZSKGZj9l24SNUjWC186J4wD99RVwb7mtjD1RQ0n
	fgoZIv2dGUKUf8VO5XFwjEkjpRuOrwUhBk1VhePJ6aHETzqZZ+QN0o2IYcqHjQ==
X-Google-Smtp-Source: AGHT+IHv5f1wWy5Mteh5mYoqzd0nZksGuXKcqFrO3o6Kt/eptOM26RonYJOAOu65xJX16drRYjcd3w==
X-Received: by 2002:a05:6808:2196:b0:3c1:acc3:99ce with SMTP id be22-20020a056808219600b003c1acc399cemr1050071oib.37.1709175514558;
        Wed, 28 Feb 2024 18:58:34 -0800 (PST)
Received: from localhost ([2401:fa00:8f:203:f51:e79e:9056:77ea])
        by smtp.gmail.com with UTF8SMTPSA id e25-20020a62aa19000000b006e45dce37basm153830pff.220.2024.02.28.18.58.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Feb 2024 18:58:34 -0800 (PST)
From: David Stevens <stevensd@chromium.org>
X-Google-Original-From: David Stevens <stevensd@google.com>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: Yu Zhang <yu.c.zhang@linux.intel.com>,
	Isaku Yamahata <isaku.yamahata@gmail.com>,
	Zhi Wang <zhi.wang.linux@gmail.com>,
	Maxim Levitsky <mlevitsk@redhat.com>,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	David Stevens <stevensd@chromium.org>
Subject: [PATCH v11 6/8] KVM: x86: Migrate to kvm_follow_pfn()
Date: Thu, 29 Feb 2024 11:57:57 +0900
Message-ID: <20240229025759.1187910-7-stevensd@google.com>
X-Mailer: git-send-email 2.44.0.rc1.240.g4c46232300-goog
In-Reply-To: <20240229025759.1187910-1-stevensd@google.com>
References: <20240229025759.1187910-1-stevensd@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: David Stevens <stevensd@chromium.org>

Migrate functions which need to be able to map non-refcounted struct
pages to kvm_follow_pfn(). These functions are kvm_faultin_pfn() and
reexecute_instruction(). The former requires replacing the async in/out
parameter with FOLL_NOWAIT parameter and the KVM_PFN_ERR_NEEDS_IO return
value (actually handling non-refcounted pages is complicated, so it will
be done in a followup). The latter is a straightforward refactor.

APIC related callers do not need to migrate because KVM controls the
memslot, so it will always be regular memory. Prefetch related callers
do not need to be migrated because atomic gfn_to_pfn() calls can never
make it to hva_to_pfn_remapped().

Signed-off-by: David Stevens <stevensd@chromium.org>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c | 43 ++++++++++++++++++++++++++++++++----------
 arch/x86/kvm/x86.c     | 11 +++++++++--
 virt/kvm/kvm_main.c    | 11 ++++-------
 3 files changed, 46 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 2d6cdeab1f8a..bbeb0f6783d7 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4331,7 +4331,14 @@ static int kvm_faultin_pfn_private(struct kvm_vcpu *vcpu,
 static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 {
 	struct kvm_memory_slot *slot = fault->slot;
-	bool async;
+	struct kvm_follow_pfn kfp = {
+		.slot = slot,
+		.gfn = fault->gfn,
+		.flags = FOLL_GET | (fault->write ? FOLL_WRITE : 0),
+		.try_map_writable = true,
+		.guarded_by_mmu_notifier = true,
+		.allow_non_refcounted_struct_page = false,
+	};
 
 	/*
 	 * Retry the page fault if the gfn hit a memslot that is being deleted
@@ -4368,12 +4375,20 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	if (fault->is_private)
 		return kvm_faultin_pfn_private(vcpu, fault);
 
-	async = false;
-	fault->pfn = __gfn_to_pfn_memslot(slot, fault->gfn, false, false, &async,
-					  fault->write, &fault->map_writable,
-					  &fault->hva);
-	if (!async)
-		return RET_PF_CONTINUE; /* *pfn has correct page already */
+	kfp.flags |= FOLL_NOWAIT;
+	fault->pfn = kvm_follow_pfn(&kfp);
+
+	if (!is_error_noslot_pfn(fault->pfn))
+		goto success;
+
+	/*
+	 * If kvm_follow_pfn() failed because I/O is needed to fault in the
+	 * page, then either set up an asynchronous #PF to do the I/O, or if
+	 * doing an async #PF isn't possible, retry kvm_follow_pfn() with
+	 * I/O allowed. All other failures are fatal, i.e. retrying won't help.
+	 */
+	if (fault->pfn != KVM_PFN_ERR_NEEDS_IO)
+		return RET_PF_CONTINUE;
 
 	if (!fault->prefetch && kvm_can_do_async_pf(vcpu)) {
 		trace_kvm_try_async_get_page(fault->addr, fault->gfn);
@@ -4391,9 +4406,17 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	 * to wait for IO.  Note, gup always bails if it is unable to quickly
 	 * get a page and a fatal signal, i.e. SIGKILL, is pending.
 	 */
-	fault->pfn = __gfn_to_pfn_memslot(slot, fault->gfn, false, true, NULL,
-					  fault->write, &fault->map_writable,
-					  &fault->hva);
+	kfp.flags |= FOLL_INTERRUPTIBLE;
+	kfp.flags &= ~FOLL_NOWAIT;
+	fault->pfn = kvm_follow_pfn(&kfp);
+
+	if (!is_error_noslot_pfn(fault->pfn))
+		goto success;
+
+	return RET_PF_CONTINUE;
+success:
+	fault->hva = kfp.hva;
+	fault->map_writable = kfp.writable;
 	return RET_PF_CONTINUE;
 }
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 363b1c080205..f4a20e9bc7a6 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8747,6 +8747,7 @@ static bool reexecute_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 {
 	gpa_t gpa = cr2_or_gpa;
 	kvm_pfn_t pfn;
+	struct kvm_follow_pfn kfp;
 
 	if (!(emulation_type & EMULTYPE_ALLOW_RETRY_PF))
 		return false;
@@ -8776,7 +8777,13 @@ static bool reexecute_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 	 * retry instruction -> write #PF -> emulation fail -> retry
 	 * instruction -> ...
 	 */
-	pfn = gfn_to_pfn(vcpu->kvm, gpa_to_gfn(gpa));
+	kfp = (struct kvm_follow_pfn) {
+		.slot = gfn_to_memslot(vcpu->kvm, gpa_to_gfn(gpa)),
+		.gfn = gpa_to_gfn(gpa),
+		.flags = FOLL_GET | FOLL_WRITE,
+		.allow_non_refcounted_struct_page = true,
+	};
+	pfn = kvm_follow_pfn(&kfp);
 
 	/*
 	 * If the instruction failed on the error pfn, it can not be fixed,
@@ -8785,7 +8792,7 @@ static bool reexecute_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 	if (is_error_noslot_pfn(pfn))
 		return false;
 
-	kvm_release_pfn_clean(pfn);
+	kvm_release_page_clean(kfp.refcounted_page);
 
 	/* The instructions are well-emulated on direct mmu. */
 	if (vcpu->arch.mmu->root_role.direct) {
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 17bf9fd6774e..24e2269339cb 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3293,6 +3293,9 @@ void kvm_release_page_clean(struct page *page)
 {
 	WARN_ON(is_error_page(page));
 
+	if (!page)
+		return;
+
 	kvm_set_page_accessed(page);
 	put_page(page);
 }
@@ -3300,16 +3303,10 @@ EXPORT_SYMBOL_GPL(kvm_release_page_clean);
 
 void kvm_release_pfn_clean(kvm_pfn_t pfn)
 {
-	struct page *page;
-
 	if (is_error_noslot_pfn(pfn))
 		return;
 
-	page = kvm_pfn_to_refcounted_page(pfn);
-	if (!page)
-		return;
-
-	kvm_release_page_clean(page);
+	kvm_release_page_clean(kvm_pfn_to_refcounted_page(pfn));
 }
 EXPORT_SYMBOL_GPL(kvm_release_pfn_clean);
 
-- 
2.44.0.rc1.240.g4c46232300-goog


