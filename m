Return-Path: <kvm+bounces-59727-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 9016EBCADE3
	for <lists+kvm@lfdr.de>; Thu, 09 Oct 2025 22:58:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id E54C734509C
	for <lists+kvm@lfdr.de>; Thu,  9 Oct 2025 20:58:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5F6927781D;
	Thu,  9 Oct 2025 20:58:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="G383v09Y"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 472372741DA
	for <kvm@vger.kernel.org>; Thu,  9 Oct 2025 20:58:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760043522; cv=none; b=sfJEFVfsjN5BkwRtH0wS4umgJu4C61P0ka6MNQLtQzBdbHWQNlzwu2dnU9137fnLKKtOYDaG2zUd62khJeseVoVBt4++d2EDrZAEUXbjzJbiLVfPNBaHNh8t37qA26GJQVCXsFmu/PY4nqNeS0kPx/rWqOSsJbykKFOPtBxfQtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760043522; c=relaxed/simple;
	bh=BqbCwuAVAX3DK9Bwr4mndwxsIa7VrBg+LRl7NYKu6/o=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=eEnVSja9kwoimUvuu/YT8KhIFpWUq95VOO5GkvmZM/uSsgXTK9PbqV0o+DmOPccwNpG/7dcY+y8DzlFbUI2wqmksnWq4kttce0jKEz+nHCTOnV2t7xIOcCg+MOFnoIv/Vl5rmwf9XZ0iWnNhT5HFV11X+Bro9XcCyBSJEDoGt4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=G383v09Y; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-32eddb7e714so2381616a91.1
        for <kvm@vger.kernel.org>; Thu, 09 Oct 2025 13:58:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760043520; x=1760648320; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=6Svmg4fC9qEdNkkbW7Zw7TQK03ok0QyEpUIGM0MaKbU=;
        b=G383v09YB3KaE+seKuAIY4h6vevadvRlhgtb9qgIrFKO0RzxSy0om2wwHptHxmsEG7
         REhPUpSklb8fMXxLCcvfewBv3okjvukQgPsJ2azvYF/TnTVtLmqYaMxLBF6ibMJJSo7o
         mAEW+ugxscexS2Wzoud5PUpGr1rJUv7+sMA3XLxNshwgQmpHJwgfskG7uOC9XPNcasDI
         tLRZSTlco90Xdrs4YXYQt3mslgTXJY08vKPd90OYAAFqMvaMra4M6eGSPVHga/bBp2JQ
         HiACqoXg3iBOVEzal2bvzFGwygbUx71axyS6H5yWUMNdOLsbKbiTgF3TbmX8i0Hml/jl
         D81A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760043520; x=1760648320;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6Svmg4fC9qEdNkkbW7Zw7TQK03ok0QyEpUIGM0MaKbU=;
        b=T+tBtxetruxeHaaYWlZI4+iDQWqeoUpbA4DGnnrm38bAPf2fzZ8cazjUwWuTnjL1LZ
         gsRHQwNzn/pSIslyT5G3TPAwjNOHIx5B741ROpo6fD4yP98mFQ1f5TYT7ZWMHo3wMee8
         PnY/pPBqNjZ4nouNt9ANinFUq4TGxbpjfkpwoS2IbuA+/cefNAJHk25bbBqv+uPkckIc
         dtthiPEzmLCnPEfC4xMzrjMU5FuM35yCwzP5BWwY+TM9/bgrHxQk1D43T293tO7MXS3M
         J9x5Nle+Elp1FgwbmceTrp8KoYaXnNI5TPYfKhnLih6I0t/Le31kawmZp8o1Wwil5GL/
         726w==
X-Forwarded-Encrypted: i=1; AJvYcCXD8PtmcUg6k7QM98eh+Psw0UOaLeo9J+/EXmwBz8613WxKg7nOrpCNOOjCwjMLDn3b/zU=@vger.kernel.org
X-Gm-Message-State: AOJu0YyZg5gRs4/vti05uKayg/5HX/9HARlJ0GvcJbJlPQDxvXohMHcw
	joOmTmcUHi75vGWfk1v2VYGbfrZyNZ6AWXZloc/e9W0GSmV//6O9MGPhN0NWdSzbXtNFhHfjQ0L
	PrJJR456K/UfDNN4ViCLnOJRgpA==
X-Google-Smtp-Source: AGHT+IF2ixNEPysZXr3u0xayZWztnMtb0Ewpjd6TyH2GT7xRzPzkdMEBQLXdOtzl9AkJxD9WHYyAbFyQ74Srl6hOyQ==
X-Received: from pjtv5.prod.google.com ([2002:a17:90a:c905:b0:332:7fae:e138])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:52cc:b0:30a:4874:5397 with SMTP id 98e67ed59e1d1-33b511185e2mr11670768a91.9.1760043520294;
 Thu, 09 Oct 2025 13:58:40 -0700 (PDT)
Date: Thu, 09 Oct 2025 13:58:24 -0700
In-Reply-To: <20251007221420.344669-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251007221420.344669-1-seanjc@google.com>
Message-ID: <diqz5xcniyhb.fsf@google.com>
Subject: Re: [PATCH v12 00/12] KVM: guest_memfd: Add NUMA mempolicy support
From: Ackerley Tng <ackerleytng@google.com>
To: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>, Shivank Garg <shivankg@amd.com>, 
	Ashish Kalra <ashish.kalra@amd.com>, Vlastimil Babka <vbabka@suse.cz>
Content-Type: text/plain; charset="UTF-8"

Sean Christopherson <seanjc@google.com> writes:

> Shivank's series to add support for NUMA-aware memory placement in
> guest_memfd.  This is based on:
>
>   https://github.com/kvm-x86/linux.git gmem
>
> which is an unstable topic branch that contains the guest_memfd MMAP fixes
> destined for 6.18 (to avoid conflicts), and three non-KVM changes related to
> mempolicy that were in previous versions of this series

For future reference, these are the three specific patches:

[1] https://lore.kernel.org/all/20250827175247.83322-4-shivankg@amd.com/
[2] https://lore.kernel.org/all/20250827175247.83322-5-shivankg@amd.com/
[3] https://lore.kernel.org/all/20250827175247.83322-6-shivankg@amd.com/

Might have missed this, did we discuss how these 3 would get merged? I
noticed this patch was withdrawn, not sure what that means: [4]

[4] https://lore.kernel.org/all/20250625000155.62D08C4CEE3@smtp.kernel.org/

> (I want to keep this
> version KVM focused, and AFAICT there is nothing left to discuss in the prep
> paches).
>
> Once 6.18-rc1 is cut I'll turn "gmem" into a proper topic branch, rebase it,
> and freeze the hashes.
>
> v12:
>  - Add missing functionality to KVM selftests' existing numaif.h instead of
>    linking to libnuma (which appears to have caveats with -static).
>  - Add KVM_SYSCALL_DEFINE() infrastructure to reduce the boilerplate needed
>    to wrap syscalls and/or to assert that a syscall succeeds.
>  - Rename kvm_gmem to gmem_file, and use gmem_inode for the inode structure.
>  - Track flags in a gmem_inode field instead of using i_private.
>  - Add comments to call out subtleties in the mempolicy code (e.g. that
>    returning NULL for vm_operations_struct.get_policy() is important for ABI
>    reasons).
>  - Improve debugability of guest_memfd_test (I kept generating SIGBUS when
>    tweaking the tests).
>  - Test mbind() with private memory (sadly, verifying placement with
>    move_pages() doesn't work due to the dependency on valid page tables).
>
> - V11: Rebase on kvm-next, remove RFC tag, use Ackerley's latest patch
>        and fix a rcu race bug during kvm module unload.
> - V10: Rebase on top of Fuad's V17. Use latest guest_memfd inode patch
>        from Ackerley (with David's review comments). Use newer kmem_cache_create()
>        API variant with arg parameter (Vlastimil)
> - v9: Rebase on top of Fuad's V13 and incorporate review comments
> - v8: Rebase on top of Fuad's V12: Host mmaping for guest_memfd memory.
> - v7: Use inodes to store NUMA policy instead of file [0].
> - v4-v6: Current approach using shared_policy support and vm_ops (based on
>          suggestions from David [1] and guest_memfd bi-weekly upstream
>          call discussion [2]).
> - v3: Introduced fbind() syscall for VMM memory-placement configuration.
> - v1,v2: Extended the KVM_CREATE_GUEST_MEMFD IOCTL to pass mempolicy.
>
> [0] https://lore.kernel.org/all/diqzbjumm167.fsf@ackerleytng-ctop.c.googlers.com
> [1] https://lore.kernel.org/all/6fbef654-36e2-4be5-906e-2a648a845278@redhat.com
> [2] https://lore.kernel.org/all/2b77e055-98ac-43a1-a7ad-9f9065d7f38f@amd.com
>
> Ackerley Tng (1):
>   KVM: guest_memfd: Use guest mem inodes instead of anonymous inodes
>
> Sean Christopherson (7):
>   KVM: guest_memfd: Rename "struct kvm_gmem" to "struct gmem_file"
>   KVM: guest_memfd: Add macro to iterate over gmem_files for a
>     mapping/inode
>   KVM: selftests: Define wrappers for common syscalls to assert success
>   KVM: selftests: Report stacktraces SIGBUS, SIGSEGV, SIGILL, and SIGFPE
>     by default
>   KVM: selftests: Add additional equivalents to libnuma APIs in KVM's
>     numaif.h
>   KVM: selftests: Use proper uAPI headers to pick up mempolicy.h
>     definitions
>   KVM: guest_memfd: Add gmem_inode.flags field instead of using
>     i_private
>
> Shivank Garg (4):
>   KVM: guest_memfd: Add slab-allocated inode cache
>   KVM: guest_memfd: Enforce NUMA mempolicy using shared policy
>   KVM: selftests: Add helpers to probe for NUMA support, and multi-node
>     systems
>   KVM: selftests: Add guest_memfd tests for mmap and NUMA policy support
>
>  include/uapi/linux/magic.h                    |   1 +
>  tools/testing/selftests/kvm/arm64/vgic_irq.c  |   2 +-
>  .../testing/selftests/kvm/guest_memfd_test.c  |  98 +++++
>  .../selftests/kvm/include/kvm_syscalls.h      |  81 +++++
>  .../testing/selftests/kvm/include/kvm_util.h  |  29 +-
>  tools/testing/selftests/kvm/include/numaif.h  | 110 +++---
>  .../selftests/kvm/kvm_binary_stats_test.c     |   4 +-
>  tools/testing/selftests/kvm/lib/kvm_util.c    |  55 +--
>  .../kvm/x86/private_mem_conversions_test.c    |   9 +-
>  .../selftests/kvm/x86/xapic_ipi_test.c        |   5 +-
>  virt/kvm/guest_memfd.c                        | 344 ++++++++++++++----
>  virt/kvm/kvm_main.c                           |   7 +-
>  virt/kvm/kvm_mm.h                             |   9 +-
>  13 files changed, 576 insertions(+), 178 deletions(-)
>  create mode 100644 tools/testing/selftests/kvm/include/kvm_syscalls.h
>
>
> base-commit: 67033eaa5ea2cb67b6cdaa91d7f5c42bfafb36f7
> -- 
> 2.51.0.710.ga91ca5db03-goog

