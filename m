Return-Path: <kvm+bounces-28579-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A9FF3999A13
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2024 04:11:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CB57D1C2318A
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2024 02:11:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40A481F1318;
	Fri, 11 Oct 2024 02:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Mfu/9XEN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E91721EABC8
	for <kvm@vger.kernel.org>; Fri, 11 Oct 2024 02:10:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728612658; cv=none; b=YIYNcS3CIeKVWONUa9RK4J6uNKYH/uOiabJATeP5rgyD7w7Z20IHCG18mrd+jWwaFBd9YF8bAiesHcpsP/2E7UZNC9KDWKbBE6rwf18fhPF3X3YuQOjf0Iw+kop06ROGfadanhtdaGBAiAFWoP+2aeZ18O005G4C/ArLocBf70Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728612658; c=relaxed/simple;
	bh=ZfG0AxRcRvfbvEdSICe+Rwv0lp2Ksqh/F9qZHu/Bn+4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=NMZIlOxgA/PrHZdVTaDpb6U6ApQfVHCskhiIBFggWxnY9tYk1XH+eLU2AfC02dTVDbsjYQBQyw6zJVbiURCT97DSjx7m+PIAyO7xZH6q5FBoEMSb3geoRwr7bLl3iBRXnmbCrOK4uWqUm1hLKj+M53SJnEoPHPnmx5smpVLhLDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Mfu/9XEN; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-71e048c1595so1640505b3a.1
        for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 19:10:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728612656; x=1729217456; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=ggNrOR87h1WmliSveAkfM74VH4GfRIzogWsDRg6oVL4=;
        b=Mfu/9XENfvETfwSYCSzzSYiAJOrjTBvoKVhA2YgsQMp3zeXR2zrapgg75O/asbhoMw
         yk41BfS5/OJLohYmR9HXkAMPITZrfHPexvjms9P4IYdUS+KmGjK4SqMhuA9Xtnyk7W1L
         75o8tTvsqLjtUSqZrO92cF2zZRqhWaECOd+WMhmtnC0DCClmormjnRRcKbci0Vd8MmDE
         8evvv0cUQuW8OR8JQTxjXpUFfrrpmtQdY8D40qn4EZ7k/kLgloKlRNZchx/V91549EPO
         dnEDezf6R9mekA/YNc6SkOJNINxulU72Gux4VJRB6QvdzeqFgRCMh1jOWUDsGlDazOba
         7RBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728612656; x=1729217456;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ggNrOR87h1WmliSveAkfM74VH4GfRIzogWsDRg6oVL4=;
        b=NNUih7FZ0MR7v3Aymfq2dV80wEZAyavDGfar+wXzGu8OfS4c/YAydwk1etDzyx+NLF
         mUCcM99qNnhbo6P4NJyU4Ac6mfMKipVDJGL4l3AZsIu9IravaObkdNxHLK5R5D4irNoo
         xtBkbXU4jhPVZxuVHEU633ugCv0fVR7ne/zfudxXHyeYae2ysICou5ERBl2IYU2Artcb
         DLK80od4WazekbV/Xtpq3tCpwgYp6LmG+Uci1mFDef+ddNSzv4rPVZ8JOPDbuDwXMmae
         6Po4W/zH9xV8VWmEjHE5yCZ/wOIUuO4fEyUnE3gmKU0ejaeWYyvt+cGZu76PMKTYqJba
         yxlQ==
X-Gm-Message-State: AOJu0YxnMwfaDvFTlRT160QdaENeoxUAvIAO+jx7jIsaE2XiaRlVlqLs
	wS+iJYqKg2xEQQgnPrCL9voIgyugNxKRvg5smqk9wwOTsVKcEKmuH3wy+4pU2eS9YAfs8hryR2m
	cOQ==
X-Google-Smtp-Source: AGHT+IHiJfmTGlfIJvaSgpYOtjfY/pLkr5LWn0PLu48c12kbgFTvRCTH+q9OJPqtDUvnnwwLgAkH7OMuic4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:91c7:b0:71e:38c7:eb9 with SMTP id
 d2e1a72fcca58-71e38c71335mr9078b3a.1.1728612656058; Thu, 10 Oct 2024 19:10:56
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 10 Oct 2024 19:10:34 -0700
In-Reply-To: <20241011021051.1557902-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241011021051.1557902-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Message-ID: <20241011021051.1557902-3-seanjc@google.com>
Subject: [PATCH 02/18] KVM: x86/mmu: Always set SPTE's dirty bit if it's
 created as writable
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yan Zhao <yan.y.zhao@intel.com>, Sagi Shahar <sagis@google.com>, 
	"=?UTF-8?q?Alex=20Benn=C3=A9e?=" <alex.bennee@linaro.org>, David Matlack <dmatlack@google.com>, 
	James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"

When creating a SPTE, always set the Dirty bit if the Writable bit is set,
i.e. if KVM is creating a writable mapping.  If two (or more) vCPUs are
racing to install a writable SPTE on a !PRESENT fault, only the "winning"
vCPU will create a SPTE with W=1 and D=1, all "losers" will generate a
SPTE with W=1 && D=0.

As a result, tdp_mmu_map_handle_target_level() will fail to detect that
the losing faults are effectively spurious, and will overwrite the D=1
SPTE with a D=0 SPTE.  For normal VMs, overwriting a present SPTE is a
small performance blip; KVM blasts a remote TLB flush, but otherwise life
goes on.

For upcoming TDX VMs, overwriting a present SPTE is much more costly, and
can even lead to the VM being terminated if KVM isn't careful, e.g. if KVM
attempts TDH.MEM.PAGE.AUG because the TDX code doesn't detect that the
new SPTE is actually the same as the old SPTE (which would be a bug in its
own right).

Suggested-by: Sagi Shahar <sagis@google.com>
Cc: Yan Zhao <yan.y.zhao@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/spte.c | 28 +++++++++-------------------
 1 file changed, 9 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index e5af69a8f101..09ce93c4916a 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -219,30 +219,21 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	if (pte_access & ACC_WRITE_MASK) {
 		spte |= PT_WRITABLE_MASK | shadow_mmu_writable_mask;
 
-		/*
-		 * When overwriting an existing leaf SPTE, and the old SPTE was
-		 * writable, skip trying to unsync shadow pages as any relevant
-		 * shadow pages must already be unsync, i.e. the hash lookup is
-		 * unnecessary (and expensive).
-		 *
-		 * The same reasoning applies to dirty page/folio accounting;
-		 * KVM marked the folio dirty when the old SPTE was created,
-		 * thus there's no need to mark the folio dirty again.
-		 *
-		 * Note, both cases rely on KVM not changing PFNs without first
-		 * zapping the old SPTE, which is guaranteed by both the shadow
-		 * MMU and the TDP MMU.
-		 */
-		if (is_last_spte(old_spte, level) && is_writable_pte(old_spte))
-			goto out;
-
 		/*
 		 * Unsync shadow pages that are reachable by the new, writable
 		 * SPTE.  Write-protect the SPTE if the page can't be unsync'd,
 		 * e.g. it's write-tracked (upper-level SPs) or has one or more
 		 * shadow pages and unsync'ing pages is not allowed.
+		 *
+		 * When overwriting an existing leaf SPTE, and the old SPTE was
+		 * writable, skip trying to unsync shadow pages as any relevant
+		 * shadow pages must already be unsync, i.e. the hash lookup is
+		 * unnecessary (and expensive).  Note, this relies on KVM not
+		 * changing PFNs without first zapping the old SPTE, which is
+		 * guaranteed by both the shadow MMU and the TDP MMU.
 		 */
-		if (mmu_try_to_unsync_pages(vcpu->kvm, slot, gfn, synchronizing, prefetch)) {
+		if ((!is_last_spte(old_spte, level) || !is_writable_pte(old_spte)) &&
+		    mmu_try_to_unsync_pages(vcpu->kvm, slot, gfn, synchronizing, prefetch)) {
 			wrprot = true;
 			pte_access &= ~ACC_WRITE_MASK;
 			spte &= ~(PT_WRITABLE_MASK | shadow_mmu_writable_mask);
@@ -252,7 +243,6 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	if (pte_access & ACC_WRITE_MASK)
 		spte |= spte_shadow_dirty_mask(spte);
 
-out:
 	if (prefetch && !synchronizing)
 		spte = mark_spte_for_access_track(spte);
 
-- 
2.47.0.rc1.288.g06298d1525-goog


