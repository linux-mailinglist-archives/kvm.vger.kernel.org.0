Return-Path: <kvm+bounces-23241-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 32194947FB3
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2024 18:53:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AF32B1F21A90
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2024 16:53:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2535F15DBD5;
	Mon,  5 Aug 2024 16:53:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vo4d6Roh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B45AB2C684
	for <kvm@vger.kernel.org>; Mon,  5 Aug 2024 16:53:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722876824; cv=none; b=ORiF9Bnfy1hPCeW5WIwaJrmHfam3PiBPSoUZ7ZFljE21llYt0dAmLFDTYKiQZtYIqwAlwHvQycdCIAGvTuGyk/P9kkMsApdBdVaZ/c4W7tHuASdKtW3y95cohZy82AEpBePA97vExBiN75g3tTfdl/Dbz3w3sB6O08GiPhaNedg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722876824; c=relaxed/simple;
	bh=w6vNmWurLrgr0ymgAaITOvvjUjovCC+cH1KdY6CmBxI=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=IO0RP8OoffxJOFvrABmdGSnZaPRaXdSgcEkP3QMBkYQWiorTZWL+pab+QBBhOh8+8Zyqj+m0IdqXdIaaUmjHkYOZxfqOkY5tMNzgLIrVuCzw5A3YM88zXEB510zSGxWYaLE/oFJePU+f/an+OJItvd7W/pE4t8pm8mOwIPMw4cI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vo4d6Roh; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-690404fd34eso48913257b3.1
        for <kvm@vger.kernel.org>; Mon, 05 Aug 2024 09:53:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722876822; x=1723481622; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=5RINMmanv5d77bAGQFePUMBVazdRsDXA+mtc4C0tc9c=;
        b=vo4d6RohnTzy+jOLdiTSVecv4XP01FnU872wlQNQuUj791E9mfnIUh/AlaiAvMx68Q
         wTZ8I+6vGrlo9oELGhxW74XllCfZ5F4Pqi7fOO9GM2aCsM6sUJCIdzrZYRAkK+A2jEMM
         YIeCPUXB1xv5b/PHJEpYkJnaEiTAZrXiH9M9aCa/xvRbPvayUSsGTT4Vh+adbUlt+HhQ
         Hnvlc+LfdmXx/GJXoQ5HRqBeejqr4sCJ3rLQhvWa3TW55SswMbj0xQCJWOoI8+iN+aDw
         agmTupl12GSLnyBvry/qWWpb7GtFHFX56Vh1RHh8gfxgHXwLBN4EuZd+aoXs3XtlGvYN
         vczQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722876822; x=1723481622;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5RINMmanv5d77bAGQFePUMBVazdRsDXA+mtc4C0tc9c=;
        b=vPHx8E5E6ihK11SHqdDDbaz963oucC2UEKx1RffZ3AtDoAZUyHYGx3YKelIvyauHSN
         WuoeUVX698vFoKIldJgM1Toy7kxPiveW7gJiE7oFg2TD4+Lhl9f20TvZ94o56g4NdVZf
         4kkg7En119QujHSBvnYeOaHHR3OiX2cXjAUPgqzqDvraAm+IvGNmzQY9g4xX6UE9cUB7
         E66WRlomI2+O0XLsBW+Em0rcGzsXsYzJ3zmn8nBmNRZYYVpIApgTdkA2jZKOnnYkGD32
         cm2NUnV1dgNFSUtSnu7f2DQUvhRqKUhHFt2XWLnyG0+aa/rJUZsFJMcQ1CaIAmHEmJgR
         IJlA==
X-Gm-Message-State: AOJu0Yy0FgOMXtXZUD8+J7kjEBC/uYpFbu3pISiEKI9wgYiD2FG7q++G
	6/CgZk7rieLVsbqBWtWq81DO0s+ekWHlfWlvOzR5lDmZ1h7oRCr6PIhyFgGTBj+s75GuNycE63H
	lVkcaCqOov/fNNoZ1HJEEbA==
X-Google-Smtp-Source: AGHT+IHELS7pYbC3Zr7WBPtJ3Cq214iX6+GHHwXiPeaVsTvMZI0On/kcO/ZamF4rcV5eByN04Yo229KkFlFLUH/VmA==
X-Received: from ackerleytng-ctop.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:13f8])
 (user=ackerleytng job=sendgmr) by 2002:a05:690c:113:b0:648:3f93:61f2 with
 SMTP id 00721157ae682-689641a414emr4467787b3.6.1722876821677; Mon, 05 Aug
 2024 09:53:41 -0700 (PDT)
Date: Mon, 05 Aug 2024 16:53:39 +0000
In-Reply-To: <20240801090117.3841080-1-tabba@google.com> (message from Fuad
 Tabba on Thu,  1 Aug 2024 10:01:07 +0100)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Message-ID: <diqzfrriewrw.fsf@ackerleytng-ctop.c.googlers.com>
Subject: Re: [RFC PATCH v2 00/10] KVM: Restricted mapping of guest_memfd at
 the host and pKVM/arm64 support
From: Ackerley Tng <ackerleytng@google.com>
To: Fuad Tabba <tabba@google.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	yu.c.zhang@linux.intel.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, vannapurve@google.com, mail@maciej.szmigiero.name, 
	david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com, 
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Fuad Tabba <tabba@google.com> writes:

> This series adds restricted mmap() support to guest_memfd, as
> well as support for guest_memfd on pKVM/arm64. It is based on
> Linux 6.10.
>
> Main changes since V1 [1]:
>
> - Decoupled whether guest memory is mappable from KVM memory
> attributes (SeanC)
>
> Mappability is now tracked in the guest_mem object, orthogonal to
> whether userspace wants the memory to be private or shared.
> Moreover, the memory attributes capability (i.e.,
> KVM_CAP_MEMORY_ATTRIBUTES) is not enabled for pKVM, since for
> software-based hypervisors such as pKVM and Gunyah, userspace is
> informed of the state of the memory via hypervisor exits if
> needed.
>
> Even if attributes are enabled, this patch series would still
> work (modulo bugs), without compromising guest memory nor
> crashing the system.
>
> - Use page_mapped() instead of page_mapcount() to check if page
> is mapped (DavidH)
>
> - Add a new capability, KVM_CAP_GUEST_MEMFD_MAPPABLE, to query
> whether guest private memory can be mapped (with aforementioned
> restrictions)
>
> - Add a selftest to check whether memory is mappable when the
> capability is enabled, and not mappable otherwise. Also, test the
> effect of punching holes in mapped memory. (DavidH)
>
> By design, guest_memfd cannot be mapped, read, or written by the
> host. In pKVM, memory shared between a protected guest and the

I think we should use "cannot be faulted in" to be clear that
guest_memfd can be mmaped but not faulted in.

Would it be better to have all the variables/config macros be something
about faultability instead of mappability?

> host is shared in-place, unlike the other confidential computing
> solutions that guest_memfd was originally envisaged for (e.g,
> TDX). When initializing a guest, as well as when accessing memory
> shared by the guest with the host, it would be useful to support
> mapping that memory at the host to avoid copying its contents.
>
> One of the benefits of guest_memfd is that it prevents a
> misbehaving host process from crashing the system when attempting
> to access (deliberately or accidentally) protected guest memory,
> since this memory isn't mapped to begin with. Without
> guest_memfd, the hypervisor would still prevent such accesses,
> but in certain cases the host kernel wouldn't be able to recover,
> causing the system to crash.
>
> Support for mmap() in this patch series maintains the invariant
> that only memory shared with the host, either explicitly by the
> guest or implicitly before the guest has started running (in
> order to populate its memory) is allowed to have a valid mapping
> at the host. At no time should private (as viewed by the
> hypervisor) guest memory be mapped at the host.
>
> This patch series is divided into two parts:
>
> The first part is to the KVM core code. It adds opt-in support
> for mapping guest memory only as long as it is shared. For that,
> the host needs to know the mappability status of guest memory.
> Therefore, the series adds a structure to track whether memory is
> mappable. This new structure is associated with each guest_memfd
> object.
>
> The second part of the series adds guest_memfd support for
> pKVM/arm64.
>
> We don't enforce the invariant that only memory shared with the
> host can be mapped by the host userspace in
> file_operations::mmap(), but we enforce it in
> vm_operations_struct:fault(). On vm_operations_struct::fault(),
> we check whether the page is allowed to be mapped. If not, we
> deliver a SIGBUS to the current task, as discussed in the Linux
> MM Alignment Session on this topic [2].
>
> Currently there's no support for huge pages, which is something
> we hope to add in the future, and seems to be a hot topic for the
> upcoming LPC 2024 [3].
>
> Cheers,
> /fuad
>
> [1] https://lore.kernel.org/all/20240222161047.402609-1-tabba@google.com/
>
> [2] https://lore.kernel.org/all/20240712232937.2861788-1-ackerleytng@google.com/
>
> [3] https://lpc.events/event/18/sessions/183/#20240919
>
> Fuad Tabba (10):
>   KVM: Introduce kvm_gmem_get_pfn_locked(), which retains the folio lock
>   KVM: Add restricted support for mapping guestmem by the host
>   KVM: Implement kvm_(read|/write)_guest_page for private memory slots
>   KVM: Add KVM capability to check if guest_memfd can be mapped by the
>     host
>   KVM: selftests: guest_memfd mmap() test when mapping is allowed
>   KVM: arm64: Skip VMA checks for slots without userspace address
>   KVM: arm64: Do not allow changes to private memory slots
>   KVM: arm64: Handle guest_memfd()-backed guest page faults
>   KVM: arm64: arm64 has private memory support when config is enabled
>   KVM: arm64: Enable private memory kconfig for arm64
>
>  arch/arm64/include/asm/kvm_host.h             |   3 +
>  arch/arm64/kvm/Kconfig                        |   1 +
>  arch/arm64/kvm/mmu.c                          | 139 +++++++++-
>  include/linux/kvm_host.h                      |  72 +++++
>  include/uapi/linux/kvm.h                      |   3 +-
>  tools/testing/selftests/kvm/Makefile          |   1 +
>  .../testing/selftests/kvm/guest_memfd_test.c  |  47 +++-
>  virt/kvm/Kconfig                              |   4 +
>  virt/kvm/guest_memfd.c                        | 129 ++++++++-
>  virt/kvm/kvm_main.c                           | 253 ++++++++++++++++--
>  10 files changed, 628 insertions(+), 24 deletions(-)
>
>
> base-commit: 0c3836482481200ead7b416ca80c68a29cfdaabd

