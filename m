Return-Path: <kvm+bounces-47986-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D8377AC804A
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 17:28:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E8DFA4A1928
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 15:28:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3184C22D4F1;
	Thu, 29 May 2025 15:28:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2osmZqIY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF50E22CBF3
	for <kvm@vger.kernel.org>; Thu, 29 May 2025 15:28:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748532510; cv=none; b=QzV9vNndlEH16Qy2D1ZB6f+Wt9Qk4xotPWUMHytvFvlpeDNpZw5bxfUv+XPTKPe5So5Uu/u42S8EN4c1/A1tHTGl131IIX4H39KSQoCy3q80TnLPN666fseKvUTkVVDgVD9vB6yYNi9hHa4KtV1+XIr2878yRpbZfggK6aU5tT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748532510; c=relaxed/simple;
	bh=8uxml1kMzoiWO8d4mb5zk+neEveN0f+NthT2SxLL2HU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=EVvwyPjIo8uZRbihpzFYfOxVPC9CuNRV/irDGubN7LvxBP+BRFxK/vWOesC+WpcwbYqlhvN5RGuTHIUJ5NYYT07LgV0QvaFT2PM79DjqJEwJlNoeh/CoYh9+1k895v0ZRy32zLKDYZBb2X+eo9kQWapANIepYAwAegcVLSGFDUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2osmZqIY; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-31171a736b2so1692401a91.1
        for <kvm@vger.kernel.org>; Thu, 29 May 2025 08:28:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748532508; x=1749137308; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=WU9RnG3prte+XfxV/XkwbzM4ROyF/nnLjJ6rboFsA7o=;
        b=2osmZqIYu5rrYH5Rypis9rvLcc2g4P4UBgrR3ayNk4RwYi0int9wJFFUiFXiwWfSJA
         1OVFNQBq9TagdbSJs8+947v+vs0geQRTA+MiyTI/ufq5bgyt3tzMDkdN4OgS+vRIcJcY
         Lpc35sXKKkxq0Ddfit8skIW5uxwsdsRuKR9Xu9jQ0fQnQOH5DCq9J/9U8UcmsPiFNSLo
         FiZhp0Hzx+OeLLCEHhDWUmVlSd3mVsSlbO9l1uLnTJk6YmP9hqLvNW6ZVpQf8YdvAHZC
         IGOAml+i25YCViSCPx5wUnOGz1ZG0ogcfxwk3ZnIMFGMpa/qINjb8iJtJHOeZlR6p2Ve
         gHDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748532508; x=1749137308;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WU9RnG3prte+XfxV/XkwbzM4ROyF/nnLjJ6rboFsA7o=;
        b=TM7YnHwNoKGxl279HIeQdoXLF8vCD1UJtod+9Q6GXzhc1ti4Yb1rNU5p3ZSLLDALYJ
         qlNmWK+cJZ4BJIVmupL/rtRvUUiw476pKTuZi91S3I43d6YGwvIvpJXdXG9o/hc4UvTk
         xDKARUTRcPB3kgv+9Sd7AHAKmjjGe0U1ArUEH9dy1v2BedtOnSQhNjRCb0FWVkdyCkWW
         D46W9g6AQjadyzoOrDxM3P8k0zogw0Hk1Hx2+QOM36vvNJYpVaC6FJ8CwH2BLqBJV0dA
         WqUOHg2STu2oBMN3/BEbrRlR015IfZo2Il7+urzsF/bLVytzcKUX5i073Ilt6QfWtXy1
         CfeQ==
X-Forwarded-Encrypted: i=1; AJvYcCXwSYvvMkX/K50zow7aiCsZzgqL2kGRp2Mn2DqzyY8fD1g4d0Jo6gtD8uFZR7/mtnYp4Bw=@vger.kernel.org
X-Gm-Message-State: AOJu0YxGlyLVh1q+vUHvH93sOHsGi4szHmX9hU+gUdy12YX5Z/0B+AfV
	lrtXtXec2y0Od0vYDHn84Zn303SQvqJWuCU8/c+wHNMUxhukwBH7hSVavPOpNJM6vgT+EtaKVrN
	WNPMuDA==
X-Google-Smtp-Source: AGHT+IHbtuprtUf3WXvE9In2+LJbs9yJtttrgnsqC0Q6ZRBKRVcjg83ZBIKBGMMJVz/hhN7+gaivfNuenbM=
X-Received: from pjbpx18.prod.google.com ([2002:a17:90b:2712:b0:311:8076:14f1])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1dce:b0:312:26d9:d5a0
 with SMTP id 98e67ed59e1d1-312413f60famr66406a91.3.1748532508047; Thu, 29 May
 2025 08:28:28 -0700 (PDT)
Date: Thu, 29 May 2025 08:28:26 -0700
In-Reply-To: <CADrL8HXjLjVyFiFee9Q58TQ9zBfXiO+VG=25Rw4UD+fbDmxQFg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250109204929.1106563-1-jthoughton@google.com>
 <aBqlkz1bqhu-9toV@google.com> <CADrL8HXjLjVyFiFee9Q58TQ9zBfXiO+VG=25Rw4UD+fbDmxQFg@mail.gmail.com>
Message-ID: <aDh9GtncjlVvvVJ1@google.com>
Subject: Re: [PATCH v2 00/13] KVM: Introduce KVM Userfault
From: Sean Christopherson <seanjc@google.com>
To: James Houghton <jthoughton@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Yan Zhao <yan.y.zhao@intel.com>, 
	Nikita Kalyazin <kalyazin@amazon.com>, Anish Moorthy <amoorthy@google.com>, 
	Peter Gonda <pgonda@google.com>, Peter Xu <peterx@redhat.com>, 
	David Matlack <dmatlack@google.com>, wei.w.wang@intel.com, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	Jiaqi Yan <jiaqiyan@google.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, May 28, 2025, James Houghton wrote:
> The only thing that I want to call out again is that this UAPI works
> great for when we are going from userfault --> !userfault. That is, it
> works well for postcopy (both for guest_memfd and for standard
> memslots where userfaultfd scalability is a concern).
> 
> But there is another use case worth bringing up: unmapping pages that
> the VMM is emulating as poisoned.
> 
> Normally this can be handled by mm (e.g. with UFFDIO_POISON), but for
> 4K poison within a HugeTLB-backed memslot (if the HugeTLB page remains
> mapped in userspace), KVM Userfault is the only option (if we don't
> want to punch holes in memslots). This leaves us with three problems:
> 
> 1. If using KVM Userfault to emulate poison, we are stuck with small
> pages in stage 2 for the entire memslot.
> 2. We must unmap everything when toggling on KVM Userfault just to
> unmap a single page.
> 3. If KVM Userfault is already enabled, we have no choice but to
> toggle KVM Userfault off and on again to unmap the newly poisoned
> pages (i.e., there is no ioctl to scan the bitmap and unmap
> newly-userfault pages).
> 
> All of these are non-issues if we emulate poison by removing memslots,
> and I think that's possible. But if that proves too slow, we'd need to
> be a little bit more clever with hugepage recovery and with unmapping
> newly-userfault pages, both of which I think can be solved by adding
> some kind of bitmap re-scan ioctl. We can do that later if the need
> arises.

Hmm.

On the one hand, punching a hole in a memslot is generally gross, e.g. requires
deleting the entire memslot and thus unmapping large swaths of guest memory (or
all of guest memory for most x86 VMs).

On the other hand, unless userspace sets KVM_MEM_USERFAULT from time zero, KVM
will need to unmap guest memory (or demote the mapping size a la eager page
splitting?) when KVM_MEM_USERFAULT is toggled from 0=>1.

One thought would be to change the behavior of KVM's processing of the userfault
bitmap, such that KVM doesn't infer *anything* about the mapping sizes, and instead
give userspace more explicit control over the mapping size.  However, on non-x86
architectures, implementing such a control would require a non-trivial amount of
code and complexity, and would incur overhead that doesn't exist today (i.e. we'd
need to implement equivalent infrastructure to x86's disallow_lpage tracking).

And IIUC, another problem with KVM Userfault is that it wouldn't Just Work for
KVM accesses to guest memory.  E.g. if the HugeTLB page is still mapped into
userspace, then depending on the flow that gets hit, I'm pretty sure that emulating
an access to the poisoned memory would result in KVM_EXIT_INTERNAL_ERROR, whereas
punching a hole in a memslot would result in a much more friendly KVM_EXIT_MMIO.

All in all, given that KVM needs to correctly handle hugepage vs. memslot
alignment/size issues no matter what, and that KVM has well-established behavior
for handling no-memslot accesses, I'm leaning towards saying userspace should
punch a hole in the memslot in order to emulate a poisoned page.  The only reason
I can think of for preferring a different approach is if userspace can't provide
the desired latency/performance characteristics when punching a hole in a memslot.
Hopefully reacting to a poisoned page is a fairly slow path?

