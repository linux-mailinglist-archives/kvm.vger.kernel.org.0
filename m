Return-Path: <kvm+bounces-9521-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B9D518610EB
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 13:01:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6F23D287887
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 12:01:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D75297B3ED;
	Fri, 23 Feb 2024 12:01:12 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7C9E7AE47
	for <kvm@vger.kernel.org>; Fri, 23 Feb 2024 12:01:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708689672; cv=none; b=muDuTN7H2fGlKyWzg8a1MsJY2/HVqX41VI3x3vS7wDSE11Hy8LAfZOK3sR6xozQltCm3I1YG9CYxVL8VB0x1Zyp/9w62yIKm6MfM44lOoYMj6XUSb8vwN2kbHytwVOqDXUbd/agIEaKmdgb7i/ohzWWSWdbdO3L6uQACbBLw/go=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708689672; c=relaxed/simple;
	bh=nwiPvihfP8vJg+CcssSpGBm+rbytvX9pdy9lB0BiOhk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hcWiux1klgjG/5DjZKntHWApzEsPdxyvJplL+0AOY9EKYCHk3k6R1rPDSrL6L6bb69hGcl3YOtV/hDTy5Czg6xpD35Wu+TxemqAXzd1844ZZCs9zi8J37hHoq86mNCahPDbV2RACkjmXSA63tyQ/ikAtK/qGG0NX//1lQQfb/H0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 378EC11FB;
	Fri, 23 Feb 2024 04:01:47 -0800 (PST)
Received: from raptor (unknown [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 02C603F73F;
	Fri, 23 Feb 2024 04:01:01 -0800 (PST)
Date: Fri, 23 Feb 2024 12:00:59 +0000
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Fuad Tabba <tabba@google.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, pbonzini@redhat.com,
	chenhuacai@kernel.org, mpe@ellerman.id.au, anup@brainfault.org,
	paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu,
	seanjc@google.com, viro@zeniv.linux.org.uk, brauner@kernel.org,
	willy@infradead.org, akpm@linux-foundation.org,
	xiaoyao.li@intel.com, yilun.xu@intel.com,
	chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com,
	dmatlack@google.com, yu.c.zhang@linux.intel.com,
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz,
	vannapurve@google.com, ackerleytng@google.com,
	mail@maciej.szmigiero.name, david@redhat.com, michael.roth@amd.com,
	wei.w.wang@intel.com, liam.merwick@oracle.com,
	isaku.yamahata@gmail.com, kirill.shutemov@linux.intel.com,
	suzuki.poulose@arm.com, steven.price@arm.com,
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com,
	quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com,
	quic_cvanscha@quicinc.com, quic_pderrin@quicinc.com,
	quic_pheragu@quicinc.com, catalin.marinas@arm.com,
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev,
	maz@kernel.org, will@kernel.org, qperret@google.com,
	keirf@google.com
Subject: Re: [RFC PATCH v1 00/26] KVM: Restricted mapping of guest_memfd at
 the host and pKVM/arm64 support
Message-ID: <ZdiI-40gNDKf6YgC@raptor>
References: <20240222161047.402609-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240222161047.402609-1-tabba@google.com>

Hi,

I have a question regarding memory shared between the host and a protected
guest. I scanned the series, and the pKVM patches this series is based on,
but I couldn't easily find the answer.

When a page is shared, that page is not mapped in the stage 2 tables that
the host maintains for a regular VM (kvm->arch.mmu), right? It wouldn't
make much sense for KVM to maintain its own stage 2 that is never used, but
I thought I should double check that to make sure I'm not missing
something.

Thanks,
Alex

On Thu, Feb 22, 2024 at 04:10:21PM +0000, Fuad Tabba wrote:
> This series adds restricted mmap() support to guest_memfd [1], as
> well as support guest_memfd on pKVM/arm64.
> 
> This series is based on Linux 6.8-rc4 + our pKVM core series [2].
> The KVM core patches apply to Linux 6.8-rc4 (patches 1-6), but
> the remainder (patches 7-26) require the pKVM core series. A git
> repo with this series applied can be found here [3]. We have a
> (WIP) kvmtool port capable of running the code in this series
> [4]. For a technical deep dive into pKVM, please refer to Quentin
> Perret's KVM Forum Presentation [5, 6].
> 
> I've covered some of the issues presented here in my LPC 2023
> presentation [7].
> 
> We haven't started using this in Android yet, but we aim to move
> away from anonymous memory to guest_memfd once we have the
> necessary support merged upstream. Others (e.g., Gunyah [8]) are
> also looking into guest_memfd for similar reasons as us.
> 
> By design, guest_memfd cannot be mapped, read, or written by the
> host userspace. In pKVM, memory shared between a protected guest
> and the host is shared in-place, unlike the other confidential
> computing solutions that guest_memfd was originally envisaged for
> (e.g, TDX). When initializing a guest, as well as when accessing
> memory shared by the guest to the host, it would be useful to
> support mapping that memory at the host to avoid copying its
> contents.
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
> order to populate its memory) is allowed to be mapped. At no time
> should private memory be mapped at the host.
> 
> This patch series is divided into two parts:
> 
> The first part is to the KVM core code (patches 1-6), and is
> based on guest_memfd as of Linux 6.8-rc4. It adds opt-in support
> for mapping guest memory only as long as it is shared. For that,
> the host needs to know the sharing status of guest memory.
> Therefore, the series adds a new KVM memory attribute, accessible
> only by the host kernel, that specifies whether the memory is
> allowed to be mapped by the host userspace.
> 
> The second part of the series (patches 7-26) adds guest_memfd
> support for pKVM/arm64, and is based on the latest version of our
> pKVM series [2]. It uses guest_memfd instead of the current
> approach in Android (not upstreamed) of maintaining a long-term
> GUP on anonymous memory donated to the guest. These patches
> handle faulting in guest memory for a guest, as well as handling
> sharing and unsharing of guest memory while maintaining the
> invariant mentioned earlier.
> 
> In addition to general feedback, we would like feedback on how we
> handle mmap() and faulting-in guest pages at the host (KVM: Add
> restricted support for mapping guest_memfd by the host).
> 
> We don't enforce the invariant that only memory shared with the
> host can be mapped by the host userspace in
> file_operations::mmap(), but in vm_operations_struct:fault(). On
> vm_operations_struct::fault(), we check whether the page is
> shared with the host. If not, we deliver a SIGBUS to the current
> task. The reason for enforcing this at fault() is that mmap()
> does not elevate the pagecount(); it's the faulting in of the
> page which does. Even if we were to check at mmap() whether an
> address can be mapped, we would still need to check again on
> fault(), since between mmap() and fault() the status of the page
> can change.
> 
> This creates the situation where access to successfully mmap()'d
> memory might SIGBUS at page fault. There is precedence for
> similar behavior in the kernel I believe, with MADV_HWPOISON and
> the hugetlbfs cgroups controller, which could SIGBUS at page
> fault time depending on the accounting limit.
> 
> Another pKVM specific aspect we would like feedback on, is how to
> handle memory mapped by the host being unshared by a guest. The
> approach we've taken is that on an unshare call from the guest,
> the host userspace is notified that the memory has been unshared,
> in order to allow it to unmap it and mark it as PRIVATE as
> acknowledgment. If the host does not unmap the memory, the
> unshare call issued by the guest fails, which the guest is
> informed about on return.
> 
> Cheers,
> /fuad
> 
> [1] https://lore.kernel.org/all/20231105163040.14904-1-pbonzini@redhat.com/
> 
> [2] https://android-kvm.googlesource.com/linux/+/refs/heads/for-upstream/pkvm-core
> 
> [3] https://android-kvm.googlesource.com/linux/+/refs/heads/tabba/guestmem-6.8-rfc-v1
> 
> [4] https://android-kvm.googlesource.com/kvmtool/+/refs/heads/tabba/guestmem-6.8
> 
> [5] Protected KVM on arm64 (slides)
> https://static.sched.com/hosted_files/kvmforum2022/88/KVM%20forum%202022%20-%20pKVM%20deep%20dive.pdf
> 
> [6] Protected KVM on arm64 (video)
> https://www.youtube.com/watch?v=9npebeVFbFw
> 
> [7] Supporting guest private memory in Protected KVM on Android (presentation)
> https://lpc.events/event/17/contributions/1487/
> 
> [8] Drivers for Gunyah (patch series)
> https://lore.kernel.org/all/20240109-gunyah-v16-0-634904bf4ce9@quicinc.com/
> 
> Fuad Tabba (20):
>   KVM: Split KVM memory attributes into user and kernel attributes
>   KVM: Introduce kvm_gmem_get_pfn_locked(), which retains the folio lock
>   KVM: Add restricted support for mapping guestmem by the host
>   KVM: Don't allow private attribute to be set if mapped by host
>   KVM: Don't allow private attribute to be removed for unmappable memory
>   KVM: Implement kvm_(read|/write)_guest_page for private memory slots
>   KVM: arm64: Create hypercall return handler
>   KVM: arm64: Refactor code around handling return from host to guest
>   KVM: arm64: Rename kvm_pinned_page to kvm_guest_page
>   KVM: arm64: Add a field to indicate whether the guest page was pinned
>   KVM: arm64: Do not allow changes to private memory slots
>   KVM: arm64: Skip VMA checks for slots without userspace address
>   KVM: arm64: Handle guest_memfd()-backed guest page faults
>   KVM: arm64: Track sharing of memory from protected guest to host
>   KVM: arm64: Mark a protected VM's memory as unmappable at
>     initialization
>   KVM: arm64: Handle unshare on way back to guest entry rather than exit
>   KVM: arm64: Check that host unmaps memory unshared by guest
>   KVM: arm64: Add handlers for kvm_arch_*_set_memory_attributes()
>   KVM: arm64: Enable private memory support when pKVM is enabled
>   KVM: arm64: Enable private memory kconfig for arm64
> 
> Keir Fraser (3):
>   KVM: arm64: Implement MEM_RELINQUISH SMCCC hypercall
>   KVM: arm64: Strictly check page type in MEM_RELINQUISH hypercall
>   KVM: arm64: Avoid unnecessary unmap walk in MEM_RELINQUISH hypercall
> 
> Quentin Perret (1):
>   KVM: arm64: Turn llist of pinned pages into an rb-tree
> 
> Will Deacon (2):
>   KVM: arm64: Add initial support for KVM_CAP_EXIT_HYPERCALL
>   KVM: arm64: Allow userspace to receive SHARE and UNSHARE notifications
> 
>  arch/arm64/include/asm/kvm_host.h             |  17 +-
>  arch/arm64/include/asm/kvm_pkvm.h             |   1 +
>  arch/arm64/kvm/Kconfig                        |   2 +
>  arch/arm64/kvm/arm.c                          |  32 ++-
>  arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |   2 +
>  arch/arm64/kvm/hyp/include/nvhe/pkvm.h        |   1 +
>  arch/arm64/kvm/hyp/nvhe/hyp-main.c            |  24 +-
>  arch/arm64/kvm/hyp/nvhe/mem_protect.c         |  67 +++++
>  arch/arm64/kvm/hyp/nvhe/pkvm.c                |  89 +++++-
>  arch/arm64/kvm/hyp/nvhe/switch.c              |   1 +
>  arch/arm64/kvm/hypercalls.c                   | 117 +++++++-
>  arch/arm64/kvm/mmu.c                          | 138 +++++++++-
>  arch/arm64/kvm/pkvm.c                         |  83 +++++-
>  include/linux/arm-smccc.h                     |   7 +
>  include/linux/kvm_host.h                      |  34 +++
>  include/uapi/linux/kvm.h                      |   4 +
>  virt/kvm/Kconfig                              |   4 +
>  virt/kvm/guest_memfd.c                        |  89 +++++-
>  virt/kvm/kvm_main.c                           | 260 ++++++++++++++++--
>  19 files changed, 904 insertions(+), 68 deletions(-)
> 
> -- 
> 2.44.0.rc1.240.g4c46232300-goog
> 
> 

