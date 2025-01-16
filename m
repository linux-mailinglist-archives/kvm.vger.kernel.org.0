Return-Path: <kvm+bounces-35609-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3261BA1300E
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2025 01:35:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BCA653A1268
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2025 00:35:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4210517C8B;
	Thu, 16 Jan 2025 00:35:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fDglf5uI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 519D6B67E
	for <kvm@vger.kernel.org>; Thu, 16 Jan 2025 00:35:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736987738; cv=none; b=JTM1eP/SyQOv5WRmkloUkOObaDh5jOAVLOoEFb4liPV7WxUZ3hYzJNvL2Tmhlg2rSe/iAwoUHeYXpUaKZDOowfMr13lrFAs+skE+BZhuHMQESaFsuYDmK1bQrH8elsU3TC2/28ReZNVFeLjc0yhzgpJHj0LXbVoQcsh3G+8ytuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736987738; c=relaxed/simple;
	bh=cqk7jKAnFKD3qxSp8rD+kZBaPY54HemalT1voY1isiU=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=gdIz9/ZJpekBtnmkWNj9CO9iem4rqxA/4SzH7U70v9XRynmmsmv97tJlkq7ZKsR9DHTgqvp7EZ2b3Cj1hiiquvGGx/li1HQvXanDsgIrRN4/8vSArNB6DKnCoc+cnECTmPAcRsgy2+lZIexieT2WsYKjI/j3wGfTMUZ9ilOlOU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fDglf5uI; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2166855029eso6240425ad.0
        for <kvm@vger.kernel.org>; Wed, 15 Jan 2025 16:35:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736987735; x=1737592535; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ZI95E/grQOj5lmAqAkKwCbXt2uGVrqNSdSRAEqaCEQw=;
        b=fDglf5uIfusxnkHEnsq7mgZCSmgjL9KhPIN6EFd3Uv6dTpj6Krb+zzixUoKrh+/4Zb
         w3iZta5mjerRz7KIOy8bVHS+qapnfp/LCn5xrPcS2iW8A51JjfvvrcP2U1JsDAGDpxh4
         kliiHLmhNMdWUvJplIht/bgfCPi/L/CEecY/1/MS/955SaXV1NOkpPfOydFstuG07gkG
         ZFv0ij3VjzSolW2xYlaRVZ45cdqq6FOMxuiCurhpx2LwksOaaJNgM4wyfb0QoUJs2hWY
         l5pYCxbwRHQ7D570EYx7ksWFuOOTy6XvEjKT8ZSvxpaw+VXS53s/TzfJlTKMnoW5f/Cr
         16Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736987735; x=1737592535;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZI95E/grQOj5lmAqAkKwCbXt2uGVrqNSdSRAEqaCEQw=;
        b=XOkgONlDAlMfswmVdx8Lcub6VmUENF5z1oa7crxjzrG0/Ktbm9oX+PnC9RJ8b9M+1v
         2zfWllOvJAxhw8ZOUO9r1akoo+s5a6iHu7BXaxUilhl5rV5eDwsmZQbjXLmQKnvfRjSw
         RbnRnx7BOJYtRbm7uTzxi6m1Z5LRPPN76B6RreCaa8HbzjOnsVr7TvSEuvH3nP/XfJKB
         3Lc6GI+/XbJ1lsxzUDpGxzxyXnUzC0sB3W52FA9hW3ZbdSQJqdZw4h3gXkXihkspPt9P
         PBFni2u+et+0VxtTG3AXrWvdzdE4TlhPDf61IEctrWqCyHXti3g3Rs2o73y/rzn+wXnx
         OFqg==
X-Gm-Message-State: AOJu0YzTo0LuoLer/OPl/7LnWFo3M3g/3apkya0gXVi3r25r58fTGrfG
	xjT99ti0d4GEPFl9VeTciqUyuN1SirBtZJlv38/RZgtsp35l3m7pFeFC4cHfY0p2CH/0syPn/Lg
	q+L6N6rOGXBrVsviFlOW2RA==
X-Google-Smtp-Source: AGHT+IGAsGunK2FzDulfjw3tOwuPn1zWdFCLhFH0XiViYbpTu3Cro/+3F9g9kMYHMexKuSAzVMO8CIJzcPXKR++RZA==
X-Received: from pgph7.prod.google.com ([2002:a65:4047:0:b0:7fe:ffa9:4e54])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:3943:b0:1e8:bd15:6819 with SMTP id adf61e73a8af0-1e8bd156be3mr30608996637.22.1736987735482;
 Wed, 15 Jan 2025 16:35:35 -0800 (PST)
Date: Thu, 16 Jan 2025 00:35:34 +0000
In-Reply-To: <CA+EHjTzcx=eXSERSANMByhcgRRAbUL3kPAYkeu-uUgd0nPBPPA@mail.gmail.com>
 (message from Fuad Tabba on Thu, 9 Jan 2025 16:34:42 +0000)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Message-ID: <diqzh65zzjc9.fsf@ackerleytng-ctop.c.googlers.com>
Subject: Re: [RFC PATCH v4 00/14] KVM: Restricted mapping of guest_memfd at
 the host and arm64 support
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
	jthoughton@google.com
Content-Type: text/plain; charset="UTF-8"

Fuad Tabba <tabba@google.com> writes:

> Hi,
>
> As mentioned in the guest_memfd sync (2025-01-09), below is the state
> diagram that uses the new states in this patch series, and how they
> would interact with sharing/unsharing in pKVM:
>
> https://lpc.events/event/18/contributions/1758/attachments/1457/3699/Guestmemfd%20folio%20state%20page_type.pdf

Thanks Fuad!

I took a look at the state diagram [1] and the branch that this patch is
on [2], and here's what I understand about the flow:

1. From state H in the state diagram, the guest can request to unshare a
   page. When KVM handles this unsharing, KVM marks the folio
   mappability as NONE (state J).
2. The transition from state J to state K or I is independent of KVM -
   userspace has to do this unmapping
3. On the next vcpu_run() from userspace, continuing from userspace's
   handling of the unshare request, guest_memfd will check and try to
   register a callback if the folio's mappability is NONE. If the folio
   is mapped, or if folio is not mapped but refcount is elevated for
   whatever reason, vcpu_run() fails and exits to userspace. If folio is
   not mapped and gmem holds the last refcount, set folio mappability to
   GUEST.

Here's one issue I see based on the above understanding:

Registration of the folio_put() callback only happens if the VMM
actually tries to do vcpu_run(). For 4K folios I think this is okay
since the 4K folio can be freed via the transition state K -> state I,
but for hugetlb folios that have been split for sharing with userspace,
not getting a folio_put() callback means never putting the hugetlb folio
together. Hence, relying on vcpu_run() to add the folio_put() callback
leaves a way that hugetlb pages can be removed from the system.

I think we should try and find a path forward that works for both 4K and
hugetlb folios.

IIUC page._mapcount and page.page_type works as a union because
page_type is only set for page types that are never mapped to userspace,
like PGTY_slab, PGTY_offline, etc.

Technically PGTY_guest_memfd is only set once the page can never be
mapped to userspace, but PGTY_guest_memfd can only be set once mapcount
reaches 0. Since mapcount is added in the faulting process, could gmem
perhaps use some kind of .unmap/.unfault callback, so that gmem gets
notified of all unmaps and will know for sure that the mapcount gets to
0?

Alternatively, I took a look at the folio_is_zone_device()
implementation, and page.flags is used to identify the page's type. IIUC
a ZONE_DEVICE page also falls in the intersection of needing a
folio_put() callback and can be mapped to userspace. Could we use a
similar approach, using page.flags to identify a page as a guest_memfd
page? That way we don't need to know when unmapping happens, and will
always be able to get a folio_put() callback.

[1] https://lpc.events/event/18/contributions/1758/attachments/1457/3699/Guestmemfd%20folio%20state%20page_type.pdf
[2] https://android-kvm.googlesource.com/linux/+/764360863785ba16d974253a572c87abdd9fdf0b%5E%21/#F0

> This patch series doesn't necessarily impose all these transitions,
> many of them would be a matter of policy. This just happens to be the
> current way I've done it with pKVM/arm64.
>
> Cheers,
> /fuad
>
> On Fri, 13 Dec 2024 at 16:48, Fuad Tabba <tabba@google.com> wrote:
>>
>> This series adds restricted mmap() support to guest_memfd, as
>> well as support for guest_memfd on arm64. It is based on Linux
>> 6.13-rc2.  Please refer to v3 for the context [1].
>>
>> Main changes since v3:
>> - Added a new folio type for guestmem, used to register a
>>   callback when a folio's reference count reaches 0 (Matthew
>>   Wilcox, DavidH) [2]
>> - Introduce new mappability states for folios, where a folio can
>> be mappable by the host and the guest, only the guest, or by no
>> one (transient state)
>> - Rebased on Linux 6.13-rc2
>> - Refactoring and tidying up
>>
>> Cheers,
>> /fuad
>>
>> [1] https://lore.kernel.org/all/20241010085930.1546800-1-tabba@google.com/
>> [2] https://lore.kernel.org/all/20241108162040.159038-1-tabba@google.com/
>>
>> Ackerley Tng (2):
>>   KVM: guest_memfd: Make guest mem use guest mem inodes instead of
>>     anonymous inodes
>>   KVM: guest_memfd: Track mappability within a struct kvm_gmem_private
>>
>> Fuad Tabba (12):
>>   mm: Consolidate freeing of typed folios on final folio_put()
>>   KVM: guest_memfd: Introduce kvm_gmem_get_pfn_locked(), which retains
>>     the folio lock
>>   KVM: guest_memfd: Folio mappability states and functions that manage
>>     their transition
>>   KVM: guest_memfd: Handle final folio_put() of guestmem pages
>>   KVM: guest_memfd: Allow host to mmap guest_memfd() pages when shared
>>   KVM: guest_memfd: Add guest_memfd support to
>>     kvm_(read|/write)_guest_page()
>>   KVM: guest_memfd: Add KVM capability to check if guest_memfd is host
>>     mappable
>>   KVM: guest_memfd: Add a guest_memfd() flag to initialize it as
>>     mappable
>>   KVM: guest_memfd: selftests: guest_memfd mmap() test when mapping is
>>     allowed
>>   KVM: arm64: Skip VMA checks for slots without userspace address
>>   KVM: arm64: Handle guest_memfd()-backed guest page faults
>>   KVM: arm64: Enable guest_memfd private memory when pKVM is enabled
>>
>>  Documentation/virt/kvm/api.rst                |   4 +
>>  arch/arm64/include/asm/kvm_host.h             |   3 +
>>  arch/arm64/kvm/Kconfig                        |   1 +
>>  arch/arm64/kvm/mmu.c                          | 119 +++-
>>  include/linux/kvm_host.h                      |  75 +++
>>  include/linux/page-flags.h                    |  22 +
>>  include/uapi/linux/kvm.h                      |   2 +
>>  include/uapi/linux/magic.h                    |   1 +
>>  mm/debug.c                                    |   1 +
>>  mm/swap.c                                     |  28 +-
>>  tools/testing/selftests/kvm/Makefile          |   1 +
>>  .../testing/selftests/kvm/guest_memfd_test.c  |  64 +-
>>  virt/kvm/Kconfig                              |   4 +
>>  virt/kvm/guest_memfd.c                        | 579 +++++++++++++++++-
>>  virt/kvm/kvm_main.c                           | 229 ++++++-
>>  15 files changed, 1074 insertions(+), 59 deletions(-)
>>
>>
>> base-commit: fac04efc5c793dccbd07e2d59af9f90b7fc0dca4
>> --
>> 2.47.1.613.gc27f4b7a9f-goog
>>

