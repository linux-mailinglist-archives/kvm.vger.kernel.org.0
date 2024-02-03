Return-Path: <kvm+bounces-7894-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 989E7847DC2
	for <lists+kvm@lfdr.de>; Sat,  3 Feb 2024 01:25:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7C57EB26AEE
	for <lists+kvm@lfdr.de>; Sat,  3 Feb 2024 00:25:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8AF0EEACD;
	Sat,  3 Feb 2024 00:23:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Q/OYFDCz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36BC879E2
	for <kvm@vger.kernel.org>; Sat,  3 Feb 2024 00:23:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706919835; cv=none; b=BQXIiMFDcRLeV36Zo7Y7aKDij0vZpJn+i178lnO+buj0Xhw3zbKynaq1+NQhIyyuCE+z//Y/3PkhcX3grsCCUdT9P8dlTiWZvqB8UfhgUoDMx3hHZg2Q1wvvMHaGowzFBfqquw6pOn4cC+EvgZ2NNcT6ZJjjAGzbEV3jbcEC4nc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706919835; c=relaxed/simple;
	bh=bj+xt0tQx/aHe27FVFwz6GpRQEJPlX/TxMKuiSnFpKQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YjqRen465QtgeAXBZisesg7xn5u3DT72+0UgYMWRcS8t11OYs7NcCHwn/lmZ4gb3LRfpH7fiFtyUdR2h0nORltwYFbDP770ovOwrb71EzUaRtU8x+akvLuZ728Qc1k4SviPDdgzOSRZML6nfWt1Nk3MSBnVfSrQrTejOQvyqBDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Q/OYFDCz; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-6dde04e1c67so2319382b3a.0
        for <kvm@vger.kernel.org>; Fri, 02 Feb 2024 16:23:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706919833; x=1707524633; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=YMTbLD7fakVliu9PWzNdDCpL894AL7erRJ6ZL070HUM=;
        b=Q/OYFDCzEaEi2/ExUkal7KFup9u8uyc315UNMDCVabluK+X1gZhwFt8Onb9m8UR2Vv
         0yKEA45jTgqAZP2Xtl3ZrJfrtxiouT4c1zQ3ByDHU4uJ4/apoeauRdt6eci/i5S77eoE
         xCRMnuspDTra4KVyMUqucpKgita6vxg/seqSHhQMNFwqcdbCaZqpKRqFnngNY1MSQQtU
         c+eO3+v3Y/K83to0GVC7d1OjxLJ8HT0LVRNbxEhMlLCu7jgwE1Axu/FhLQ7gv4iaTFcg
         KfrTQskfdMkZSCdvTD/Bkw9Bp4HwUnhobQgqa6pezTCx249YsoElHKAscAoDjFuLp2LH
         CVmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706919833; x=1707524633;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YMTbLD7fakVliu9PWzNdDCpL894AL7erRJ6ZL070HUM=;
        b=HVF20bWJqLNoPUrI/RJlxjhGKi8ZN8NoP2GRGzp/wBGZIKlJo8oqVQePj1yOiIR3aR
         wzUhOtpIckH5EL+jEjMvhbPZb+ZdRhAEEW+d6n0+GgTzi8KASUwNsQ+fIKsetd3iuuVK
         PuIvQNv0gpYzdM3+ZeU9C7KqtaeuwzXgSXQ4YjeIw7NFvEkMpiBcwCQTzBtyk+a4lU/L
         Hfs3f80vm52haX/W4g+/CGIDM/gDDVjc5hOCBCoFjumaB2nABPVve47hZ+SQe7T+s4Ri
         BetYAwmfNYardrXU9SsezohvoKKwC7QH5kl52VX3sc169NB79AzBMqkzupxXkuFv1oEx
         TWAg==
X-Gm-Message-State: AOJu0YzXZrGGeUVuC4VfwXb0vwWJV6eVvtoF5cCV0D9GrB1p7s+nSFQS
	ddlkksNjJERKdOQlhf73d6tiheNNme2l8ajUu+LjrbwrzV2xFCPqNFYpph5M2brwKx7zRIqHi+B
	RTw==
X-Google-Smtp-Source: AGHT+IFdh99V2tM7O2ZTQjK+2KSFUG7mdx47/k6wCN3Dq6hcxr5sbk5Qwfu9yU7pPF5nEGWFotYGwzH+t3U=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1797:b0:6df:eae5:79bd with SMTP id
 s23-20020a056a00179700b006dfeae579bdmr185067pfg.0.1706919833504; Fri, 02 Feb
 2024 16:23:53 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  2 Feb 2024 16:23:43 -0800
In-Reply-To: <20240203002343.383056-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240203002343.383056-1-seanjc@google.com>
X-Mailer: git-send-email 2.43.0.594.gd9cf4e227d-goog
Message-ID: <20240203002343.383056-5-seanjc@google.com>
Subject: [PATCH v2 4/4] KVM: x86/mmu: Fix a *very* theoretical race in kvm_mmu_track_write()
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Jim Mattson <jmattson@google.com>, Mingwei Zhang <mizhang@google.com>
Content-Type: text/plain; charset="UTF-8"

Add full memory barriers in kvm_mmu_track_write() and account_shadowed()
to plug a (very, very theoretical) race where kvm_mmu_track_write() could
miss a 0->1 transition of indirect_shadow_pages and fail to zap relevant,
*stale* SPTEs.

Without the barriers, because modern x86 CPUs allow (per the SDM):

  Reads may be reordered with older writes to different locations but not
  with older writes to the same location.

it's (again, super theoretically) possible that the following could happen
(terms of values being visible/resolved):

 CPU0                          CPU1
 read memory[gfn] (=Y)
                               memory[gfn] Y=>X
                               read indirect_shadow_pages (=0)
 indirect_shadow_pages 0=>1

or conversely:

 CPU0                          CPU1
 indirect_shadow_pages 0=>1
                               read indirect_shadow_pages (=0)
 read memory[gfn] (=Y)
                               memory[gfn] Y=>X

In practice, this bug is likely benign as both the 0=>1 transition and
reordering of this scope are extremely rare occurrences.

Note, if the cost of the barrier (which is simply a locked ADD, see commit
450cbdd0125c ("locking/x86: Use LOCK ADD for smp_mb() instead of MFENCE")),
is problematic, KVM could avoid the barrier by bailing earlier if checking
kvm_memslots_have_rmaps() is false.  But the odds of the barrier being
problematic is extremely low, *and* the odds of the extra checks being
meaningfully faster overall is also low.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 3c193b096b45..86b85060534d 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -830,6 +830,14 @@ static void account_shadowed(struct kvm *kvm, struct kvm_mmu_page *sp)
 	struct kvm_memory_slot *slot;
 	gfn_t gfn;
 
+	/*
+	 * Ensure indirect_shadow_pages is elevated prior to re-reading guest
+	 * child PTEs in FNAME(gpte_changed), i.e. guarantee either in-flight
+	 * emulated writes are visible before re-reading guest PTEs, or that
+	 * an emulated write will see the elevated count and acquire mmu_lock
+	 * to update SPTEs.  Pairs with the smp_mb() in kvm_mmu_track_write().
+	 */
+	smp_mb();
 	kvm->arch.indirect_shadow_pages++;
 	gfn = sp->gfn;
 	slots = kvm_memslots_for_spte_role(kvm, sp->role);
@@ -5747,10 +5755,15 @@ void kvm_mmu_track_write(struct kvm_vcpu *vcpu, gpa_t gpa, const u8 *new,
 	bool flush = false;
 
 	/*
-	 * If we don't have indirect shadow pages, it means no page is
-	 * write-protected, so we can exit simply.
+	 * When emulating guest writes, ensure the written value is visible to
+	 * any task that is handling page faults before checking whether or not
+	 * KVM is shadowing a guest PTE.  This ensures either KVM will create
+	 * the correct SPTE in the page fault handler, or this task will see
+	 * a non-zero indirect_shadow_pages.  Pairs with the smp_mb() in
+	 * account_shadowed().
 	 */
-	if (!READ_ONCE(vcpu->kvm->arch.indirect_shadow_pages))
+	smp_mb();
+	if (!vcpu->kvm->arch.indirect_shadow_pages)
 		return;
 
 	write_lock(&vcpu->kvm->mmu_lock);
-- 
2.43.0.594.gd9cf4e227d-goog


