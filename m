Return-Path: <kvm+bounces-23249-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A115948174
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2024 20:14:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 496741C21EB7
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2024 18:14:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59C8C15F3F2;
	Mon,  5 Aug 2024 18:14:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QJ8Qjmsd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3B9C48CCD
	for <kvm@vger.kernel.org>; Mon,  5 Aug 2024 18:14:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722881665; cv=none; b=nRff5U9RJVtHT98PR1WT0pizg7Jh8FNl9tSO1nG6Y1ZjHxxT5A3EeZfHDd/umdm/FHOlHB7KD2bBZZ6U9hwRaZS+Z+oKZesuy+v6txjE0jMesNn5sHYZmyn2cS7BKV32SNCXle+oGcpdTloNqNW3LmnXxQrwLnFxl45OkFv/pzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722881665; c=relaxed/simple;
	bh=pKKrtRU/oK2NzXAGLHlgfbRyDc40QEG5mVLO5SzVclY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EYbns3fqYABAi+H4rIOhjJCj/0y3eaQe11GYyHYwRQWOT2seQyTDequspaC7cvU1GZ9iGNJzqwMyxWeN+cZoNPkX1TC8+QzQ6WJLC9nZBFhUwQ2q05tBA3ALArTLRJHaDSO4GHMmOHk363+5JrJfbjcH0sUEI/Af2IUd1Tqrt+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QJ8Qjmsd; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-42816ca782dso73391395e9.2
        for <kvm@vger.kernel.org>; Mon, 05 Aug 2024 11:14:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722881662; x=1723486462; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=fAeqV+sN0ITKMWm//lkdLvhATQzN1HfwEkp06Qf6xOg=;
        b=QJ8QjmsdEEfmMDKUy09Z57KZ40dS3zJYFGyIXK/iRSu4ymBt0uzJBIInIymE6UwY5L
         Cxzp/kibHB7NwLK/JAj578iBuE6CevJMZjrDF+ydM67dKI7sHq5nblu5zBYSFfCNZgos
         9SyUS4RbKke21f0QqzqzNZi2hSA4ybAeMMinXEhGai4f+CH+5K3t+N0auJiTF4aes6zw
         lRT8V2pXD7EO6foi0KAD/pUu5tK2bMZ7KYy5OeytFnLCzOSdsJxpM7JqHEi5uVTDJhad
         U1dWQD6f9NglGpV3Ns7f2Sn5isVO3WqMW/GOT6LEvGMiyc076bDccH/Ao69o59FHff26
         OSig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722881662; x=1723486462;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fAeqV+sN0ITKMWm//lkdLvhATQzN1HfwEkp06Qf6xOg=;
        b=XkN6FWnK5mzzbvQoK8B7YnQakWxIH9ow16J8Er964FU7AArOnH6xUWRUHSZjxtdQU0
         9Byae0hWcfrWx6q27YP4JSQ0b7FUyjW0AvhD8vx6t3d7NloW1PIU1LkLVV7r0PoGuPdc
         cYgsG8D7cAnjZmiuwLLRWxYwfVgBzFa/iwN344S8N+YBwBsWrGh6gG49T3Ww1cNRXqpV
         vLK0mJVQbXc1ZqcW3ZvmXHmf6mqhfrikS4BHPpyu1KIqUrlWIHn9AeBl3zyQojuzqs/j
         TAi/mV87npqSNG8X7o2aLqB/gOvYVGwJAYxFM+GtBCxwovllRfKDF7bokHEDw75fa4nc
         zEJQ==
X-Gm-Message-State: AOJu0YwCQdb+41RgO5WTQnL8EOIjVLta/Zi3xDlK+qr9pjr8xEerHXVK
	AypLvGiUJt16ZAwAmCiwxzHzyMavXy6Jt0vO0BpIYTRzvhbrVDd96yhe3GkUtz1g2qDUKmk8RJz
	ZP75rLJrH7qC+usSvNCBH3fk5SOVpPbegXdJo
X-Google-Smtp-Source: AGHT+IEfhXcJinsrfbkchEG4uQywphXjLx+UXwCvHE0dt8SzKT7ubH451aLvoGt5MtLCH2b5Wn5cQvCvkgjzNhQ3bu8=
X-Received: by 2002:a05:600c:1c04:b0:426:6153:5318 with SMTP id
 5b1f17b1804b1-428e6b07c00mr88003955e9.19.1722881661714; Mon, 05 Aug 2024
 11:14:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240801090117.3841080-1-tabba@google.com> <diqzfrriewrw.fsf@ackerleytng-ctop.c.googlers.com>
In-Reply-To: <diqzfrriewrw.fsf@ackerleytng-ctop.c.googlers.com>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 5 Aug 2024 19:13:45 +0100
Message-ID: <CA+EHjTyL7P9tCp4Wi_seeuniB6iNJSpamDkeKrFiOvK8vQ6G6Q@mail.gmail.com>
Subject: Re: [RFC PATCH v2 00/10] KVM: Restricted mapping of guest_memfd at
 the host and pKVM/arm64 support
To: Ackerley Tng <ackerleytng@google.com>
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
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com
Content-Type: text/plain; charset="UTF-8"

Hi Ackerley,

On Mon, 5 Aug 2024 at 17:53, Ackerley Tng <ackerleytng@google.com> wrote:
>
> Fuad Tabba <tabba@google.com> writes:
>
> > This series adds restricted mmap() support to guest_memfd, as
> > well as support for guest_memfd on pKVM/arm64. It is based on
> > Linux 6.10.
> >
> > Main changes since V1 [1]:
> >
> > - Decoupled whether guest memory is mappable from KVM memory
> > attributes (SeanC)
> >
> > Mappability is now tracked in the guest_mem object, orthogonal to
> > whether userspace wants the memory to be private or shared.
> > Moreover, the memory attributes capability (i.e.,
> > KVM_CAP_MEMORY_ATTRIBUTES) is not enabled for pKVM, since for
> > software-based hypervisors such as pKVM and Gunyah, userspace is
> > informed of the state of the memory via hypervisor exits if
> > needed.
> >
> > Even if attributes are enabled, this patch series would still
> > work (modulo bugs), without compromising guest memory nor
> > crashing the system.
> >
> > - Use page_mapped() instead of page_mapcount() to check if page
> > is mapped (DavidH)
> >
> > - Add a new capability, KVM_CAP_GUEST_MEMFD_MAPPABLE, to query
> > whether guest private memory can be mapped (with aforementioned
> > restrictions)
> >
> > - Add a selftest to check whether memory is mappable when the
> > capability is enabled, and not mappable otherwise. Also, test the
> > effect of punching holes in mapped memory. (DavidH)
> >
> > By design, guest_memfd cannot be mapped, read, or written by the
> > host. In pKVM, memory shared between a protected guest and the
>
> I think we should use "cannot be faulted in" to be clear that
> guest_memfd can be mmaped but not faulted in.
>
> Would it be better to have all the variables/config macros be something
> about faultability instead of mappability?

With mappability, I mean having a valid mapping in the host. But like
I said in the reply to the other patch, I don't have a strong opinion
about this.

Cheers,
/fuad

> > host is shared in-place, unlike the other confidential computing
> > solutions that guest_memfd was originally envisaged for (e.g,
> > TDX). When initializing a guest, as well as when accessing memory
> > shared by the guest with the host, it would be useful to support
> > mapping that memory at the host to avoid copying its contents.
> >
> > One of the benefits of guest_memfd is that it prevents a
> > misbehaving host process from crashing the system when attempting
> > to access (deliberately or accidentally) protected guest memory,
> > since this memory isn't mapped to begin with. Without
> > guest_memfd, the hypervisor would still prevent such accesses,
> > but in certain cases the host kernel wouldn't be able to recover,
> > causing the system to crash.
> >
> > Support for mmap() in this patch series maintains the invariant
> > that only memory shared with the host, either explicitly by the
> > guest or implicitly before the guest has started running (in
> > order to populate its memory) is allowed to have a valid mapping
> > at the host. At no time should private (as viewed by the
> > hypervisor) guest memory be mapped at the host.
> >
> > This patch series is divided into two parts:
> >
> > The first part is to the KVM core code. It adds opt-in support
> > for mapping guest memory only as long as it is shared. For that,
> > the host needs to know the mappability status of guest memory.
> > Therefore, the series adds a structure to track whether memory is
> > mappable. This new structure is associated with each guest_memfd
> > object.
> >
> > The second part of the series adds guest_memfd support for
> > pKVM/arm64.
> >
> > We don't enforce the invariant that only memory shared with the
> > host can be mapped by the host userspace in
> > file_operations::mmap(), but we enforce it in
> > vm_operations_struct:fault(). On vm_operations_struct::fault(),
> > we check whether the page is allowed to be mapped. If not, we
> > deliver a SIGBUS to the current task, as discussed in the Linux
> > MM Alignment Session on this topic [2].
> >
> > Currently there's no support for huge pages, which is something
> > we hope to add in the future, and seems to be a hot topic for the
> > upcoming LPC 2024 [3].
> >
> > Cheers,
> > /fuad
> >
> > [1] https://lore.kernel.org/all/20240222161047.402609-1-tabba@google.com/
> >
> > [2] https://lore.kernel.org/all/20240712232937.2861788-1-ackerleytng@google.com/
> >
> > [3] https://lpc.events/event/18/sessions/183/#20240919
> >
> > Fuad Tabba (10):
> >   KVM: Introduce kvm_gmem_get_pfn_locked(), which retains the folio lock
> >   KVM: Add restricted support for mapping guestmem by the host
> >   KVM: Implement kvm_(read|/write)_guest_page for private memory slots
> >   KVM: Add KVM capability to check if guest_memfd can be mapped by the
> >     host
> >   KVM: selftests: guest_memfd mmap() test when mapping is allowed
> >   KVM: arm64: Skip VMA checks for slots without userspace address
> >   KVM: arm64: Do not allow changes to private memory slots
> >   KVM: arm64: Handle guest_memfd()-backed guest page faults
> >   KVM: arm64: arm64 has private memory support when config is enabled
> >   KVM: arm64: Enable private memory kconfig for arm64
> >
> >  arch/arm64/include/asm/kvm_host.h             |   3 +
> >  arch/arm64/kvm/Kconfig                        |   1 +
> >  arch/arm64/kvm/mmu.c                          | 139 +++++++++-
> >  include/linux/kvm_host.h                      |  72 +++++
> >  include/uapi/linux/kvm.h                      |   3 +-
> >  tools/testing/selftests/kvm/Makefile          |   1 +
> >  .../testing/selftests/kvm/guest_memfd_test.c  |  47 +++-
> >  virt/kvm/Kconfig                              |   4 +
> >  virt/kvm/guest_memfd.c                        | 129 ++++++++-
> >  virt/kvm/kvm_main.c                           | 253 ++++++++++++++++--
> >  10 files changed, 628 insertions(+), 24 deletions(-)
> >
> >
> > base-commit: 0c3836482481200ead7b416ca80c68a29cfdaabd

