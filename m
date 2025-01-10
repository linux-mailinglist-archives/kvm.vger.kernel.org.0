Return-Path: <kvm+bounces-35123-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 427AEA09DA5
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 23:16:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 534BA3A6A62
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 22:15:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88AC1215F40;
	Fri, 10 Jan 2025 22:15:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yc2W6Uhl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F6E824B25E
	for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 22:15:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736547354; cv=none; b=rGednQ2jRBKH+7sBq1UDzJNSeaVSs2zE/5k0fc1D9bQ/aO4kXo52IGmGEMkCaLmcbbZouIOd6A3eQnmyfe3SWukkYcuLKWCeI0a681PTCcwhrGy4GTb1MnutQsPvJAAj4TqSwrWSfaulX66Z7H1zTzWB3oWNarxGoazqhbPWLuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736547354; c=relaxed/simple;
	bh=gnlGkcqoy8HDXZ9a0ZC+/Ln+qP750ey1PbJxmMWBHiA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=aCVk2YNqusC3oeCu7mQVqlH6qNXViXY+KQYNtIdNZJWI35vTf2kJwRJln6mLDev5zT5W2xuYjzWz5QtlarAhJTZlWujcw0wETQi5yx7c5NTQzPWYTMau+NZ+brBvRpY/XGCz/TmU6p4WP/EpgJTksmdnCO3JBBCjNFySnmC36fg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yc2W6Uhl; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ef8c7ef51dso4568859a91.1
        for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 14:15:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736547352; x=1737152152; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=WARCt/vdn+mdVM4SzGkFnsiJbS611IMJoZ0S5oBY9ZA=;
        b=yc2W6Uhl6pzurS2W/JKQmE/G0LxxQ4TYYSYraCyyv1JtXhbe/y6PzLTTqY4AbbLLR2
         duo6HLjFOxVsJWsHmKy/ILGh7+x5bmrbPKJ1r3MooRpY6jL1QleAAtwhda3FppEI5eRj
         FiTcwi0UZv4OrxYQT3au15zJSGDxEsNlezRpNcuFI9SWVnE/qmpmNQDlvPWHbhapwf30
         6B1sexpGhTYLoEpD/oN4thFJRxkCIorwcegmw74o62B2XT9pAXKOu2bmbiYG4o+pNmQ5
         pKzwKe06Txtj92zZgLR2GMLvtUhiZN/HLWb8HmSuoPpSmGITjCJ6DzKIFAxm+iRU3iFV
         3qrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736547352; x=1737152152;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WARCt/vdn+mdVM4SzGkFnsiJbS611IMJoZ0S5oBY9ZA=;
        b=K7670mC8u06W8z0svjEzDlIT8iMD4vUsdE39CygLuZKf92TVNEGF1jPpatx5dAfxpj
         lJN0KgEbmsEjh3mmuxU0BEsp+yUaRjKysoJ6fViKSVZrRUizGCt+fEJsehQJSbZFkb5O
         uSUL0IT0vBumhy7CTpfPpBmqsszcs0o1JF3CHY131AiTNH+TOTSFEBUOZAc2DV1anu0+
         qUDNCtd436mVrFiv7Wy9MkkO/ZUUPNXgaRKzJUiR5zOskX4qqJv0sy5U5MT/DSY6L/NZ
         fpVolU1tJy+EaBcFNBipMGQ+By8xYCyX1zz1p5Ff/Z8l6UqVlMRCbQxnMhxsrLbVdvxk
         Tnng==
X-Forwarded-Encrypted: i=1; AJvYcCXjN1caeDAHywxRTNLzo4jcSb+6A8VDX9adVauvFY64f266nHttP1li4uErjEsjY2CMKJ4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw74yyfz1TdF/mT3Q/PVN8S3KFknGlSBbK9xgFIR3+JuvIYkbtx
	rd3gOM5OcyPdN2UIjL45oql24mHBD5cI0wcIFNLBho8j5bU01VhFK76ZQhdAMPRbxHDdKMHuR7y
	XJg==
X-Google-Smtp-Source: AGHT+IFMgbGPh/f2NFCJsUCfG4G1W6cH/dRD+d3e6//H3dc23WWf2uFuIbgG2SvY04H9rIGvR5K/Qf9mhR0=
X-Received: from pjboh12.prod.google.com ([2002:a17:90b:3a4c:b0:2da:5868:311c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3b4f:b0:2f2:a974:fc11
 with SMTP id 98e67ed59e1d1-2f554603e39mr12751309a91.17.1736547352564; Fri, 10
 Jan 2025 14:15:52 -0800 (PST)
Date: Fri, 10 Jan 2025 14:15:51 -0800
In-Reply-To: <20241105184333.2305744-2-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241105184333.2305744-1-jthoughton@google.com> <20241105184333.2305744-2-jthoughton@google.com>
Message-ID: <Z4GcF4sIJHfEAEDg@google.com>
Subject: Re: [PATCH v8 01/11] KVM: Remove kvm_handle_hva_range helper functions
From: Sean Christopherson <seanjc@google.com>
To: James Houghton <jthoughton@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, David Matlack <dmatlack@google.com>, 
	David Rientjes <rientjes@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Wei Xu <weixugc@google.com>, Yu Zhao <yuzhao@google.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Nov 05, 2024, James Houghton wrote:
> kvm_handle_hva_range is only used by the young notifiers. In a later
> patch, it will be even further tied to the young notifiers. Instead of
> renaming kvm_handle_hva_range to something like

When referencing functions, include parantheses so its super obvious that the
symbol is a function(), e.g. kvm_handle_hva_range(), kvm_handle_hva_range_young(),
etc.

> kvm_handle_hva_range_young, simply remove kvm_handle_hva_range. This
> seems slightly more readable, 

I disagree, quite strongly in fact.  The amount of duplication makes it harder
to see the differences between the three aging flow, and the fewer instances of
this pattern:

	return kvm_handle_hva_range(kvm, &range).ret;

the better.  I added the tuple return as a way to avoid an out-param (which I
still think is a good tradeoff), but there's definitely a cost to it.

> though there is slightly more code duplication.

Heh, you have a different definition of "slightly".  The total lines of code may
be close to a wash, but at the end of the series there's ~10 lines of code that
is nearly identical in three different places.

My vote is for this:

---
 virt/kvm/kvm_main.c | 27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index de2c11dae231..bf4670e9fcc6 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -551,8 +551,8 @@ static void kvm_null_fn(void)
 	     node;							     \
 	     node = interval_tree_iter_next(node, start, last))	     \
 
-static __always_inline kvm_mn_ret_t __kvm_handle_hva_range(struct kvm *kvm,
-							   const struct kvm_mmu_notifier_range *range)
+static __always_inline kvm_mn_ret_t kvm_handle_hva_range(struct kvm *kvm,
+							 const struct kvm_mmu_notifier_range *range)
 {
 	struct kvm_mmu_notifier_return r = {
 		.ret = false,
@@ -628,7 +628,7 @@ static __always_inline kvm_mn_ret_t __kvm_handle_hva_range(struct kvm *kvm,
 	return r;
 }
 
-static __always_inline int kvm_handle_hva_range(struct mmu_notifier *mn,
+static __always_inline int kvm_age_hva_range(struct mmu_notifier *mn,
 						unsigned long start,
 						unsigned long end,
 						gfn_handler_t handler,
@@ -647,10 +647,10 @@ static __always_inline int kvm_handle_hva_range(struct mmu_notifier *mn,
 	return __kvm_handle_hva_range(kvm, &range).ret;
 }
 
-static __always_inline int kvm_handle_hva_range_no_flush(struct mmu_notifier *mn,
-							 unsigned long start,
-							 unsigned long end,
-							 gfn_handler_t handler)
+static __always_inline int kvm_age_hva_range_no_flush(struct mmu_notifier *mn,
+						      unsigned long start,
+						      unsigned long end,
+						      gfn_handler_t handler)
 {
 	return kvm_handle_hva_range(mn, start, end, handler, false);
 }
@@ -747,7 +747,7 @@ static int kvm_mmu_notifier_invalidate_range_start(struct mmu_notifier *mn,
 	 * that guest memory has been reclaimed.  This needs to be done *after*
 	 * dropping mmu_lock, as x86's reclaim path is slooooow.
 	 */
-	if (__kvm_handle_hva_range(kvm, &hva_range).found_memslot)
+	if (kvm_handle_hva_range(kvm, &hva_range).found_memslot)
 		kvm_arch_guest_memory_reclaimed(kvm);
 
 	return 0;
@@ -793,7 +793,7 @@ static void kvm_mmu_notifier_invalidate_range_end(struct mmu_notifier *mn,
 	};
 	bool wake;
 
-	__kvm_handle_hva_range(kvm, &hva_range);
+	kvm_handle_hva_range(kvm, &hva_range);
 
 	/* Pairs with the increment in range_start(). */
 	spin_lock(&kvm->mn_invalidate_lock);
@@ -817,8 +817,8 @@ static int kvm_mmu_notifier_clear_flush_young(struct mmu_notifier *mn,
 {
 	trace_kvm_age_hva(start, end);
 
-	return kvm_handle_hva_range(mn, start, end, kvm_age_gfn,
-				    !IS_ENABLED(CONFIG_KVM_ELIDE_TLB_FLUSH_IF_YOUNG));
+	return kvm_age_hva_range(mn, start, end, kvm_age_gfn,
+				 !IS_ENABLED(CONFIG_KVM_ELIDE_TLB_FLUSH_IF_YOUNG));
 }
 
 static int kvm_mmu_notifier_clear_young(struct mmu_notifier *mn,
@@ -841,7 +841,7 @@ static int kvm_mmu_notifier_clear_young(struct mmu_notifier *mn,
 	 * cadence. If we find this inaccurate, we might come up with a
 	 * more sophisticated heuristic later.
 	 */
-	return kvm_handle_hva_range_no_flush(mn, start, end, kvm_age_gfn);
+	return kvm_age_hva_range_no_flush(mn, start, end, kvm_age_gfn);
 }
 
 static int kvm_mmu_notifier_test_young(struct mmu_notifier *mn,
@@ -850,8 +850,7 @@ static int kvm_mmu_notifier_test_young(struct mmu_notifier *mn,
 {
 	trace_kvm_test_age_hva(address);
 
-	return kvm_handle_hva_range_no_flush(mn, address, address + 1,
-					     kvm_test_age_gfn);
+	return kvm_age_hva_range_no_flush(mn, address, address + 1, kvm_test_age_gfn);
 }
 
 static void kvm_mmu_notifier_release(struct mmu_notifier *mn,

base-commit: 2d5faa6a8402435d6332e8e8f3c3f18cca382d83
-- 

