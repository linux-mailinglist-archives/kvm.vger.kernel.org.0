Return-Path: <kvm+bounces-8244-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 67DD584CE5B
	for <lists+kvm@lfdr.de>; Wed,  7 Feb 2024 16:47:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8C9CF1C235D3
	for <lists+kvm@lfdr.de>; Wed,  7 Feb 2024 15:47:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8242980041;
	Wed,  7 Feb 2024 15:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YSNDXVs1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5234C7FBBD
	for <kvm@vger.kernel.org>; Wed,  7 Feb 2024 15:46:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707320803; cv=none; b=c9jiONLvJAo7u6WP+BgJBjfEyoU3Q3MFTTuKj5Ce5K/JUDxpfHsIYJQslMFsEwkIReSZRfytOHkeaHx4G4cS5VRQ2l1dHfLWGej56MX/PgvfjgtD+/CgxPBTqPCiL76/pZp+gwvdS6VlGS0cwfKFAD5TV2SAPGJlX/Px+t/L/KA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707320803; c=relaxed/simple;
	bh=K53ZZvCsrolT8X395l++Yn5v68FJcDCJp22aYenng28=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=A/IeJKg1Sy7Bq4ng+KdN8/kAoTkyqynWIR/K7fw4ug6cb+iWYcNzBFqa/U8wBLmZL/ftaMvXXudY/xV1/aGexE7YV1YX8FNa4AYfQZqX3c1Ioy95vpRBu8k7f0JzAkwmj0oQPXac9Gj7t8bJ+A5xZ2lhy4hZL+jtvu/fFJig4PI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YSNDXVs1; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-29679438039so581131a91.2
        for <kvm@vger.kernel.org>; Wed, 07 Feb 2024 07:46:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707320801; x=1707925601; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=K1vUU5GtV/HreAMSegqNxbtSuUlLZ3yEj2TqAzmQFAQ=;
        b=YSNDXVs1S+YhNYmI7+zg3JEjEnQq5vybKwmTDEz45SGIKGf8JL4rSLNqpIryb56JPt
         /fRzkaLWsIdY3GIC//uFNpMke9SlunUbM4NdNrr5Jt+LTrnewqUtDxfhOA/R/TVzfqcA
         MsxQ/Qvftto15+sQ7ufZs/0cPJcEQC2nAVsBUc1eJtswWgaVrVn6fYc4Y63fntvvI5Yr
         jpCGNDTbhAg0yJtEzAeE3zzdI0RbnfZGhWVVRYQYowJUj5lJ+BxugK6WWW68VAm55DDO
         MRE2OotzftXhRzP4cdUTT/Tcoom0NNYLy4nW+WIdjjR6eyYYVovdDtMYaED3fD8lquHN
         HFqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707320801; x=1707925601;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=K1vUU5GtV/HreAMSegqNxbtSuUlLZ3yEj2TqAzmQFAQ=;
        b=E9jc2dobrI2nd7pe/Agywa1zFQrhU79eps0QayGGIpH/Ov+W7L76pSYVYpGmiuzd9A
         HHxaS4/NPRlmp9VPjchsWYV2MVeztK+aFowdXhR611JraRCtuFrw50pTmJIraxJIGa4j
         F9S5NDP0WmGAzV4guE+cx8nFEXrWsbieax5vqgGXnEt+C//CWtv8JmUsHrt+qbpsjBzd
         e0muCAFd8ueCI7oeWFN6L3aKyvRSpGdoN8JBDAXp2iKNqYYZtFIvrxEA4t+wmAQ8Tdif
         Hb0lRnAX+pCzT4M3lgeNw+1+jpxvu0lpOKgYgClnQSh8dcHODnzhVgWM+f0PWnMZvcDd
         DsQg==
X-Gm-Message-State: AOJu0Yz0usE/YZKM2rDDLYEqOP9XUUS4VBJsqzTZbmC0Pqq2XrpwqZHN
	BxTshEQSI2xpkmGw9yey32z2hd883j0qkY/smeMUgHwn1ug3Jcp4hCNQsyB1MEvGikMIOtJtImp
	zKg==
X-Google-Smtp-Source: AGHT+IG7frfAntHd6YSunGAL3Hn4axWdZ7/qTDuWTl4579rwZ2kTb+Iw2ltwdxLQXj5I7ZHZyi9fLGwQvM8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:2b4f:b0:296:3a3a:92ae with SMTP id
 rr15-20020a17090b2b4f00b002963a3a92aemr8912pjb.4.1707320801606; Wed, 07 Feb
 2024 07:46:41 -0800 (PST)
Date: Wed, 7 Feb 2024 07:46:40 -0800
In-Reply-To: <20231109210325.3806151-1-amoorthy@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231109210325.3806151-1-amoorthy@google.com>
Message-ID: <ZcOl4PTbobZTsuNW@google.com>
Subject: Re: [PATCH v6 00/14] Improve KVM + userfaultfd performance via
 KVM_MEMORY_FAULT_EXITs on stage-2 faults
From: Sean Christopherson <seanjc@google.com>
To: Anish Moorthy <amoorthy@google.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, oliver.upton@linux.dev, 
	pbonzini@redhat.com, maz@kernel.org, robert.hoo.linux@gmail.com, 
	jthoughton@google.com, dmatlack@google.com, axelrasmussen@google.com, 
	peterx@redhat.com, nadav.amit@gmail.com, isaku.yamahata@gmail.com, 
	kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="us-ascii"

On Thu, Nov 09, 2023, Anish Moorthy wrote:
> Base Commit
> ~~~~~~~~~~~
> This series is based off of kvm/next (45b890f7689e) with v14 of the
> guest_memfd series applied, with some fixes on top [3].

Please use `--base`.  I have gotten spoiled by git appending the object ID at the
bottom, and get annoyed every time I have to go spelunking for the base :-)

Also, in the future, when posting a series that has multiple dependencies, it is
*very* helpful to reviewers and maintainers to provide a full branch somewhere,
e.g. on github, gitlab, etc.  That way someone that wants to actually test things
doesn't need to hunt down and splice together a bunch of different assets.

From Documentation/process/maintainer-kvm-x86.rst:

Git Base
~~~~~~~~
If you are using git version 2.9.0 or later (Googlers, this is all of you!),
use ``git format-patch`` with the ``--base`` flag to automatically include the
base tree information in the generated patches.

Note, ``--base=auto`` works as expected if and only if a branch's upstream is
set to the base topic branch, e.g. it will do the wrong thing if your upstream
is set to your personal repository for backup purposes.  An alternative "auto"
solution is to derive the names of your development branches based on their
KVM x86 topic, and feed that into ``--base``.  E.g. ``x86/pmu/my_branch_name``,
and then write a small wrapper to extract ``pmu`` from the current branch name
to yield ``--base=x/pmu``, where ``x`` is whatever name your repository uses to
track the KVM x86 remote.

> Anish Moorthy (14):
>   KVM: Documentation: Clarify meaning of hva_to_pfn()'s 'atomic'
>     parameter
>   KVM: Documentation: Add docstrings for __kvm_read/write_guest_page()
>   KVM: Simplify error handling in __gfn_to_pfn_memslot()
>   KVM: Define and communicate KVM_EXIT_MEMORY_FAULT RWX flags to
>     userspace
>   KVM: Try using fast GUP to resolve read faults
>   KVM: Add memslot flag to let userspace force an exit on missing hva
>     mappings
>   KVM: x86: Enable KVM_CAP_EXIT_ON_MISSING and annotate EFAULTs from
>     stage-2 fault handler
>   KVM: arm64: Enable KVM_CAP_MEMORY_FAULT_INFO
>   KVM: arm64: Enable KVM_CAP_EXIT_ON_MISSING and annotate an EFAULT from
>     stage-2 fault-handler
>   KVM: selftests: Report per-vcpu demand paging rate from demand paging
>     test
>   KVM: selftests: Allow many vCPUs and reader threads per UFFD in demand
>     paging test
>   KVM: selftests: Use EPOLL in userfaultfd_util reader threads and
>     signal errors via TEST_ASSERT
>   KVM: selftests: Add memslot_flags parameter to memstress_create_vm()
>   KVM: selftests: Handle memory fault exits in demand_paging_test
> 
>  Documentation/virt/kvm/api.rst                |  33 +-
>  arch/arm64/kvm/Kconfig                        |   1 +
>  arch/arm64/kvm/arm.c                          |   1 +
>  arch/arm64/kvm/mmu.c                          |   7 +-
>  arch/powerpc/kvm/book3s_64_mmu_hv.c           |   2 +-
>  arch/powerpc/kvm/book3s_64_mmu_radix.c        |   2 +-
>  arch/x86/kvm/Kconfig                          |   1 +
>  arch/x86/kvm/mmu/mmu.c                        |   8 +-
>  include/linux/kvm_host.h                      |  21 +-
>  include/uapi/linux/kvm.h                      |   5 +
>  .../selftests/kvm/aarch64/page_fault_test.c   |   4 +-
>  .../selftests/kvm/access_tracking_perf_test.c |   2 +-
>  .../selftests/kvm/demand_paging_test.c        | 295 ++++++++++++++----
>  .../selftests/kvm/dirty_log_perf_test.c       |   2 +-
>  .../testing/selftests/kvm/include/memstress.h |   2 +-
>  .../selftests/kvm/include/userfaultfd_util.h  |  17 +-
>  tools/testing/selftests/kvm/lib/memstress.c   |   4 +-
>  .../selftests/kvm/lib/userfaultfd_util.c      | 159 ++++++----
>  .../kvm/memslot_modification_stress_test.c    |   2 +-
>  .../x86_64/dirty_log_page_splitting_test.c    |   2 +-
>  virt/kvm/Kconfig                              |   3 +
>  virt/kvm/kvm_main.c                           |  46 ++-
>  22 files changed, 444 insertions(+), 175 deletions(-)

A few nits throughout, but this is looking good for 6.9.

Oliver / Marc,

Any objection to taking this through kvm-x86? (when you feel it's ready, obviously)
My plan is to put it in a dedicated topic branch, with a massaged cover letter as
the tag used for the pull request so that we can capture the motivation/benefits.

