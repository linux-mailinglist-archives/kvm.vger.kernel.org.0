Return-Path: <kvm+bounces-66619-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 80440CDAC0A
	for <lists+kvm@lfdr.de>; Tue, 23 Dec 2025 23:26:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 802E730329FB
	for <lists+kvm@lfdr.de>; Tue, 23 Dec 2025 22:26:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E2B1313534;
	Tue, 23 Dec 2025 22:26:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QxHNtICw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E96752C17A1
	for <kvm@vger.kernel.org>; Tue, 23 Dec 2025 22:26:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766528784; cv=none; b=l8O9wA6rNrCeenTbskb9aw9P18yQKilYJcrXG03Kgi1ct/SCI5VRdKiXVflHTD8TtpkEFfBbR5M7ohrFsQtHHQjj4plGlm9hGgh1Up1A8/gY0M75tSh25h0g3qgSqQkMpRxO3D64/mSHLldFulVdYZ1UTGDNqLfgGwJvDE5uJtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766528784; c=relaxed/simple;
	bh=MSm1DQoGA7VguDanON0JVBLg3oITZmQyXa37YNZ5BwQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=a0tqTEr55tT0fqlc7ykr+uiFPrRR7nwJ9vVLfKOL/k0uCq/zHxP9KeIRBvHkbIvTxVkbD0MEvSCxacigIoaHOfzlToSWcjZmKWX1aJELATl3pY/kAFo4I5HudHFrHgj6IHYTg3EIIM25S+mVjaUq8V8187XHM3GL9YmAcf+IZGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QxHNtICw; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-34c6e05af6fso5652194a91.1
        for <kvm@vger.kernel.org>; Tue, 23 Dec 2025 14:26:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766528782; x=1767133582; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=B/iz1prZohd6/NaRQNethXdQcwNa2lZjSPWIi6zRaGs=;
        b=QxHNtICwNuwG2YFp9nDR1sPKYfWAMDGK4SpVReHXBKNLGamNZamFiB1UnLXXhgY1Ja
         Pq+hAYJPkkNmrKFtgDLoR6NBjWYaaxvnzNU340srltLRzvIcGf8lurIFjIh2tDQuPed4
         dsQEaMydoMeoWFKu6HdrEIZEPQoEAPwXdX4kDBlvdnb/d6kbuApX7Y99bXAS8jL5WVfP
         PChkhWii3lWxJSkK6aOyt0Ic8XDIasVX8Kv55EnkAeCIU9XaRz0GOwAELHlY08c0Kdhl
         /H0xESOZDnzOLl881BHq+A/H5AHhxFl05XlpGU3apM5IeiVWuTJ5pkP3BZhQBTf2VMuf
         MM5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766528782; x=1767133582;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=B/iz1prZohd6/NaRQNethXdQcwNa2lZjSPWIi6zRaGs=;
        b=WNdIKBK5GkYDqO0eu2DCI7V6rW2sHfOdENgwA3Cfs6sQl4aTgWN6m+X0yWLiqR3l/y
         OF+XZOORU+F4B8a18uXIqkRn1+JdcQYsIN8M1sjVoM+VIU3KzXI1h/qigjVdzgonCVHZ
         rAwEsd2TAo6WCw7L7U7ZTZV50KB8lUhrVFqyyEkk//X7Onq/64l63L9g0RrcTCwYWKj7
         Euy9Ut0JoHSy6xwVFrNuUiN8bAl0uKTOmmzI6QC2RTfyNf4+SrzViftlojoIMFe9TXsv
         LUgB+Pg7JiXSRLK4/CkQUurse4rnfMAHzApczAqGvIfee+MY7y+oz+km4g3o7jEYiq9R
         BAxA==
X-Forwarded-Encrypted: i=1; AJvYcCWy9yMeslCGMn9R4omHdf4A9/D4lwV6qTp9w5/4k5ZUJqydJMweU1xXK6aITSaTTIM8p7s=@vger.kernel.org
X-Gm-Message-State: AOJu0YzahN3EG34SB/77McGHdy7c/kt69WKbLSQttMADL7qNgeQAk/Nk
	oVGL4t8CtkRaDROODiuERyAucYBZU+tZi/UcN0V3eGkljiaJESbPIUQ0lFUZdeWLxqv+ub2z9rx
	7pz+ilA==
X-Google-Smtp-Source: AGHT+IGyuxIIc+L4Y/yduwfQmfPjOeuScGy3ktLBLbGKl1hM7fmDbxvCjr6yDWktVmqzAXpuuKaw598y59Y=
X-Received: from pjbnk22.prod.google.com ([2002:a17:90b:1956:b0:34c:4c6d:ad4f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1fcc:b0:34c:6124:3616
 with SMTP id 98e67ed59e1d1-34e921ddcb6mr14680730a91.27.1766528782224; Tue, 23
 Dec 2025 14:26:22 -0800 (PST)
Date: Tue, 23 Dec 2025 14:26:20 -0800
In-Reply-To: <20251127013440.3324671-6-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251127013440.3324671-1-yosry.ahmed@linux.dev> <20251127013440.3324671-6-yosry.ahmed@linux.dev>
Message-ID: <aUsXDKeYorxt7VMM@google.com>
Subject: Re: [PATCH v3 05/16] KVM: selftests: Stop setting AD bits on nested
 EPTs on creation
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Nov 27, 2025, Yosry Ahmed wrote:
> When new nested EPTs are created, the AD bits are set. This was
> introduced by commit 094444204570 ("selftests: kvm: add test for dirty
> logging inside nested guests"), which introduced vmx_dirty_log_test.
> 
> It's unclear why that was needed at the time, but regardless, the test
> seems to pass without them so probably no longer needed.
> dirty_log_perf_test (with -n to run in L2) also passes, and these are
> the only tests currently using nested EPT mappings.

Please, please don't take the approach of "beat on it until it passes".  Yes,
Paolo's changelog and comment from 094444204570 are awful, and yes, figuring out
what Paolo _likely_ intended requires a lot of guesswork and esoteric shadow MMU
knowledge, but _at best_, modifying code without having at least a plausible
explanation only adds to the confusion, and at worst is actively dangerous.

As you've discovered a few times now, there is plenty of code in KVM and its
tests that elicit a WTF?!!? response from pretty much everyone, i.e. odds are
good you'll run into something along these lines again, sooner or later.  If/when
that happens, and you can't unravel the mystery, please send a mail with a question
instead of sending a patch that papers over the issue.  E.g. casting "raise dead"
on the original thread is totally acceptable (and probably even encouraged).
That _might_ be a slower and/or more painful approach, but it's generally safer,
e.g. it's all too easy for a maintainer to speed read and apply a seemingly
uninteresting patch like this.

In this case, I strongly suspect that what Paolo was _trying_ to do was coerce
KVM into creating a writable SPTE in response to the initial READ.  I.e. in the
vmx_dirty_log_test's L2 code, setting the Dirty bit in the guest stage-2 PTE is
necessary to get KVM to install a writable SPTE on the READ_ONCE():

  static void l2_guest_code(u64 *a, u64 *b)
  {
	READ_ONCE(*a);
	WRITE_ONCE(*a, 1);
	GUEST_SYNC(true);
	GUEST_SYNC(false);
 
	...
  }

When handling a read fault in FNAME(walk_addr_generic)(), KVM adjusts the guest
PTE access protections via FNAME(protect_clean_gpte):

	if (!write_fault)
		FNAME(protect_clean_gpte)(mmu, &walker->pte_access, pte);
	else
		/*
		 * On a write fault, fold the dirty bit into accessed_dirty.
		 * For modes without A/D bits support accessed_dirty will be
		 * always clear.
		 */
		accessed_dirty &= pte >>
			(PT_GUEST_DIRTY_SHIFT - PT_GUEST_ACCESSED_SHIFT);


where FNAME(protect_clean_gpte) is:

	unsigned mask;

	/* dirty bit is not supported, so no need to track it */
	if (!PT_HAVE_ACCESSED_DIRTY(mmu))
		return;

	BUILD_BUG_ON(PT_WRITABLE_MASK != ACC_WRITE_MASK);

	mask = (unsigned)~ACC_WRITE_MASK;
	/* Allow write access to dirty gptes */
	mask |= (gpte >> (PT_GUEST_DIRTY_SHIFT - PT_WRITABLE_SHIFT)) &
		PT_WRITABLE_MASK;
	*access &= mask;

The idea is that KVM can elide a VM-Exit on a READ=>WRITE sequence by making the
SPTE writable on the READ fault if the guest PTEs allow the page to be written.
But KVM can only do that if the guest Dirty bit is '1'; if the Dirty bit is '0',
then KVM needs to intercept the next write in order to emulate the Dirty assist.

I emphasized "trying" above because, in the context of the dirty logging test,
simply establishing a writable SPTE on the READ_ONCE() doesn't meaningfully improve
coverage without checking KVM's behavior after the READ_ONCE().  E.g. KVM marks
GFNs as dirty (in the dirty bitmap) when creating writable SPTEs, and so doing
READ+WRITE and _then_ checking the dirty bitmap would hide the KVM PML bug that
the test was written to find.

The second part of the L2 guest code:

	WRITE_ONCE(*b, 1);
	GUEST_SYNC(true);
	WRITE_ONCE(*b, 1);
	GUEST_SYNC(true);
	GUEST_SYNC(false);

_does_ trigger and detect the KVM bug, but with a WRITE=>CHECK=>WRITE=>CHECK
sequence instead of READ=>CHECK=>WRITE=>CHECK.  I.e. even if there was a false
pass in the first phase, as written the second phase will detect the bug,
assuming the bug affects WRITE=>WRITE and READ=>WRITE equally.  Which isn't a
great assumption, but it was the case for the PML bug.

All that said, for this patch, I think it makes sense to drop the A/D code from
the common APIs, because (a) it will be trivially easy to have the test set them
as needed once the common APIs are used for TDP mappings, and (b) temporarily
dropping the code doesn't affect the test coverage in practice.

--
Stop setting Accessed/Dirty bits when creating EPT entries for L2 so that
the stage-1 and stage-2 (a.k.a. TDP) page table APIs can use common code
without bleeding the EPT hack into the common APIs.

While commit 094444204570 ("selftests: kvm: add test for dirty logging
inside nested guests") is _very_ light on details, the most likely
explanation is that vmx_dirty_log_test was attempting to avoid taking an
EPT Violation on the first _write_ from L2.

  static void l2_guest_code(u64 *a, u64 *b)
  {
	READ_ONCE(*a);
	WRITE_ONCE(*a, 1);   <===
	GUEST_SYNC(true);

	...
  }

When handling read faults in the shadow MMU, KVM opportunistically creates
a writable SPTE if the mapping can be writable *and* the gPTE is dirty (or
doesn't support the Dirty bit), i.e. if KVM doesn't need to intercept
writes in order to emulate Dirty-bit updates.  By setting A/D bits in the
test's EPT entries, the above READ+WRITE will fault only on the read, and
in theory expose the bug fixed by KVM commit 1f4e5fc83a42 ("KVM: x86: fix
nested guest live migration with PML").  If the Dirty bit is NOT set, the
test will get a false pass due; though again, in theory.

However, the test is flawed (and always was, at least in the versions
posted publicly), as KVM (correctly) marks the corresponding L1 GFN as
dirty (in the dirty bitmap) when creating the writable SPTE.  I.e. without
a check on the dirty bitmap after the READ_ONCE(), the check after the
first WRITE_ONCE() will get a false pass due to the dirty bitmap/log having
been updated by the read fault, not by PML.

Furthermore, the subsequent behavior in the test's l2_guest_code()
effectively hides the flawed test behavior, as the straight writes to a
new L2 GPA fault also trigger the KVM bug, and so the test will still
detect the failure due to lack of isolation between the two testcases
(Read=>Write vs. Write=>Write).

	WRITE_ONCE(*b, 1);
	GUEST_SYNC(true);
	WRITE_ONCE(*b, 1);
	GUEST_SYNC(true);
	GUEST_SYNC(false);

Punt on fixing vmx_dirty_log_test for the moment as it will be easier to
properly fix the test once the TDP code uses the common MMU APIs, at which
point it will be trivially easy for the test to retrieve the EPT PTE and
set the Dirty bit as needed.
--

