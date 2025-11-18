Return-Path: <kvm+bounces-63613-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 10E2AC6BF96
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 00:21:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sin.lore.kernel.org (Postfix) with ESMTPS id C6CEB2BEBE
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 23:21:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 033BC2F83DC;
	Tue, 18 Nov 2025 23:20:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Mw28gouR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97570277011
	for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 23:20:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763508054; cv=none; b=fjrz2gMIxkwSaA6fXQLuk6MOXd/iiE9ZpmsMx5RSYMC5FwiXN/9HK9TqNrvA9UHX+8yZPAI4tZOkeWUIOvjsS4KHmapvxuI1CA/hzx4nSH0eoBJPGFFh6JY6pnUCDUWvyzcdnGFgK0s3K/BTGANJh2o58UDQUSeqBKvA5S6Ex0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763508054; c=relaxed/simple;
	bh=VJDb4Je4ELN7YZRgLh61wjgTSlJ+6dYHnsbyjaew6Lc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=PyM6N/bK7E2ScuPb/xbhNoFPYXYck6IlEHnTBLzg7Fc8yjhqVVQkUTjxK0jz+cA15AOJFO8o3k+MqqGKINTWY+HYnM0TEk1ZOpEYcJ8oS2NSmJi7AU3Hbanq8MMl7fhsz8t2xGknVJO9QhLX6XdQ2SHcsMluJTiqtRqa0AEPEqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Mw28gouR; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-34176460924so5836915a91.3
        for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 15:20:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763508052; x=1764112852; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=vRAa74uCGTsHAbA5kZTO9ywKahKcwnIviIqeSQSB7gc=;
        b=Mw28gouRtbDnjQdPtk1G367dqrZ5GJD8NyGV67hheNZOo+JUgxqGhO1HLmYdv7m1k6
         SR6ikAY51BJSfyaTUAfpgzklck+SyxFLU3MYyVYopXN/ZMVCx+yaV7o/rNyATxdahycT
         PiRV9q9hQOfxQtugkgujWtXz6nxuAnr0s9WjRgqMp6fuQIMHwrZ+eDsN4Ak3tHzVNQDz
         b7S4RMe9/WThxSyQVeC0MAb20ErF3LuFVJNLaCdmr94azWRScOKlG7yzrw59O4FbrAcO
         fvoJ9iD0RYCw0EvIPncULSKFtkBl5OSD9rkq/KKiAhg2qGlFIxSRjFd7w6Mj9vl+XOnk
         pWyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763508052; x=1764112852;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vRAa74uCGTsHAbA5kZTO9ywKahKcwnIviIqeSQSB7gc=;
        b=S9ce4yQzyJERdABK9eCMLeGnNtTOTS6pAWM+OIefC1L1Pyzn3KN1xRS6UjLG7Zr/lD
         ftT6c5jC1E0XVPay5wNIVp2hYJQPhiTbrubYxeXCpcCDGUjcYV40Ox0qLrbWjO10g9qU
         mUwI8hKxoQ7MpycsbX6S3r76n9ElCIc/eGaTKVMEyBYd36EcEjfoQk9c12LDMQTALSVN
         p4At5IOvjFnc3H0yGwe/mGKDkh3rJ/x/Oskkb5rPylH3xDqXu2uX0bwfZsTXkmZ4IlVR
         upcOW5giOyPfEk2VHeXECXHaMCP6tw7kNiCieHaSmFMivPyMpOx2QVMwNgit8xySxIv1
         stOA==
X-Gm-Message-State: AOJu0Yz5p9k3jy7HR73+XvRKR1Rs6nXJUDlCt3jhZLHlDvYo0ud45gZP
	alCKE4BGZrhXieHiycM0Ro1MmT4aAKh5/DGh37cTW7VL5jeudYpxtzQeAQqjzGTtT69rQHxfNtv
	/dDmSow==
X-Google-Smtp-Source: AGHT+IFkSfUAYvzAQZKNtqRhXcyxT5U8uh7iL64Fohl1BjfUQXxZMqZr6Vf3ONg4mNpXFQ21RH7cJHhyYU0=
X-Received: from pjbsl11.prod.google.com ([2002:a17:90b:2e0b:b0:345:b42b:cf16])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:e18c:b0:336:b60f:3936
 with SMTP id 98e67ed59e1d1-343f9e9f23bmr20624097a91.12.1763508051835; Tue, 18
 Nov 2025 15:20:51 -0800 (PST)
Date: Tue, 18 Nov 2025 15:20:50 -0800
In-Reply-To: <20250820162951.3499017-1-chengkev@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250820162951.3499017-1-chengkev@google.com>
Message-ID: <aRz_UkBPM7FcfmpP@google.com>
Subject: Re: [kvm-unit-tests PATCH] x86: nSVM: Add test for EPT A/D bits
From: Sean Christopherson <seanjc@google.com>
To: Kevin Cheng <chengkev@google.com>
Cc: kvm@vger.kernel.org, jmattson@google.com, pbonzini@redhat.com
Content-Type: text/plain; charset="us-ascii"

On Wed, Aug 20, 2025, Kevin Cheng wrote:
> The nVMX tests already have coverage for TDP A/D bits. Add a
> similar test for nSVM to improve test parity between nSVM and nVMX.

Please write a more verbose changelog that explains _exactly_ what you intend to
test.  Partly because I don't entirely trust the EPT A/D tests, but mostly
because I think it will help you fully understand the double walks that need to
be done.  E.g. explain what all NPT entries will be touched if the guest writes
using a virtual address.

> Signed-off-by: Kevin Cheng <chengkev@google.com>
> ---
>  x86/svm.c     | 93 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  x86/svm.h     |  5 +++
>  x86/svm_npt.c | 46 +++++++++++++++++++++++++

The {check,clear}_npt_ad() helpers belong in svm_npt.c, not svm.c

>  3 files changed, 144 insertions(+)
> 
> diff --git a/x86/svm.c b/x86/svm.c
> index e715e270..53b78d16 100644
> --- a/x86/svm.c
> +++ b/x86/svm.c
> @@ -14,6 +14,8 @@
>  #include "isr.h"
>  #include "apic.h"
>  
> +#include <asm/page.h>
> +
>  /* for the nested page table*/
>  u64 *pml4e;
>  
> @@ -43,6 +45,97 @@ u64 *npt_get_pml4e(void)
>  	return pml4e;
>  }
>  
> +void clear_npt_ad(unsigned long *pml4e, u64 guest_cr3,
> +		  unsigned long guest_addr)

GPAs are of type phys_addr_t, not "unsigned long".  The tests pass because they're
64-bit only, but that's ugly and shouldn't be relied upon.

And pml4e, a.k.a. npt_get_pml4e(), is a u64 *.  Actually, pml4e isn't even used,
which makes me question whether or not this test does what it intended to do.

Ah, guest_addr is actually a _virtual_ address.  Please name it "gva" to remove
ambiguity (and to help clarify that guest_cr3 really is CR3, not nCR3).

> +{
> +	int l;
> +	unsigned long *pt = (unsigned long *)guest_cr3, gpa;
> +	u64 *npt_pte, pte, offset_in_page;
> +	unsigned offset;

Please don't use bare "unsigned", and use reverse fir-tree.  "offset" can simply
be an "int" because we're 100% relying on it not to be greater than 511.  I.e.

	unsigned long *pt = (unsigned long *)guest_cr3, gpa;
	u64 *npt_pte, pte, offset_in_page;
	int l, offset;

> +
> +	for (l = PAGE_LEVEL; ; --l) {
> +		offset = PGDIR_OFFSET(guest_addr, l);
> +		npt_pte = npt_get_pte((u64) &pt[offset]);

This is retrieving a PTE from a non-NPT page table (pt == guest_cr3).

> +		if(!npt_pte) {
> +			printf("NPT - guest level %d page table is not mapped.\n", l);

Why printf instead of report_fail()?

> +			return;
> +		}
> +
> +		*npt_pte &= ~(PT_AD_MASK);

And so here you're clearing bits in the non-nested page tables.  The test passes
because check_npt_ad() also checks the non-nested page tables, but the test isn't
doing what it purports to do.

> +
> +		pte = pt[offset];
> +		if (l == 1 || (l < 4 && (pte & PT_PAGE_SIZE_MASK)))
> +			break;
> +		if (!(pte & PT_PRESENT_MASK))
> +			return;
> +		pt = (unsigned long *)(pte & PT_ADDR_MASK);
> +	}
> +
> +	offset = PGDIR_OFFSET(guest_addr, l);
> +	offset_in_page = guest_addr &  ((1 << PGDIR_BITS(l)) - 1);
> +	gpa = (pt[offset] & PT_ADDR_MASK) | (guest_addr & offset_in_page);
> +	npt_pte = npt_get_pte(gpa);

Ah, the nested NPT tables are checked, but only for the leaf PTE of the final GPA.
This fails to validate address.  This fails to validate Accessed bits on non-leaf
NPT entries, and fails to validate A/D bits on NPT entries used to translate GPAs
accessed while walking the guest GVA=>GPA page tables.

> +	*npt_pte &= ~(PT_AD_MASK);
> +}
> +
> +void check_npt_ad(unsigned long *pml4e, u64 guest_cr3,
> +	unsigned long guest_addr, int expected_gpa_ad,
> +	int expected_pt_ad)

Align indentation.

> +{
> +	int l;
> +	unsigned long *pt = (unsigned long *)guest_cr3, gpa;
> +	u64 *npt_pte, pte, offset_in_page;
> +	unsigned offset;
> +	bool bad_pt_ad = false;
> +
> +	for (l = PAGE_LEVEL; ; --l) {
> +		offset = PGDIR_OFFSET(guest_addr, l);
> +		npt_pte = npt_get_pte((u64) &pt[offset]);
> +
> +		if(!npt_pte) {
> +			printf("NPT - guest level %d page table is not mapped.\n", l);

Why printf instead of report_fail()?

> +			return;
> +		}
> +
> +		if (!bad_pt_ad) {
> +			bad_pt_ad |= (*npt_pte & PT_AD_MASK) != expected_pt_ad;
> +			if(bad_pt_ad)

Unnecessary nesting.  E.g. ignoring the below feedback, this could be:

		if (!bad_pt_ad && (*npt_pte & PT_AD_MASK) != expected_pt_ad) {
			bad_pt_ad = true
			report_fail(...)
		}

> +				report_fail("NPT - received guest level %d page table A=%d/D=%d",
> +					    l,
> +					    !!(expected_pt_ad & PT_ACCESSED_MASK),
> +					    !!(expected_pt_ad & PT_DIRTY_MASK));

Print both expected and actual, otherwise debugging is no fun.  Actually, looking
at the caller, passing in @expected_pt_ad is quite silly.  The only time A/D bits
are expected to be '0' are for the initial check, immediately after A/D bits are
zeroed.  That's honestly uninteresting, it's basically verifying KVM hasn't
randomly corrupted memory.  If someone _really_ wants to verify that A/D bits are
cleared, just read back immediately after writing.

Dropping @expected_pt_ad will make it easier to expand coverage, e.g. for reads
vs. writes, and of intermediate GPAs.

E.g. 

> +		}
> +
> +		pte = pt[offset];
> +		if (l == 1 || (l < 4 && (pte & PT_PAGE_SIZE_MASK)))
> +			break;
> +		if (!(pte & PT_PRESENT_MASK))
> +			return;
> +		pt = (unsigned long *)(pte & PT_ADDR_MASK);
> +	}
> +
> +	if (!bad_pt_ad)
> +		report_pass("NPT - guest page table structures A=%d/D=%d",
> +			    !!(expected_pt_ad & PT_ACCESSED_MASK),
> +			    !!(expected_pt_ad & PT_DIRTY_MASK));
> +
> +	offset = PGDIR_OFFSET(guest_addr, l);
> +	offset_in_page = guest_addr &  ((1 << PGDIR_BITS(l)) - 1);
> +	gpa = (pt[offset] & PT_ADDR_MASK) | (guest_addr & offset_in_page);
> +
> +	npt_pte = npt_get_pte(gpa);
> +
> +	if (!npt_pte) {
> +		report_fail("NPT - guest physical address is not mapped");
> +		return;
> +	}
> +	report((*npt_pte & PT_AD_MASK) == expected_gpa_ad,
> +	       "NPT - guest physical address A=%d/D=%d",
> +	       !!(expected_gpa_ad & PT_ACCESSED_MASK),
> +	       !!(expected_gpa_ad & PT_DIRTY_MASK));
> +}

