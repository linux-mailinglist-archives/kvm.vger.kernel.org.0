Return-Path: <kvm+bounces-35963-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EF72CA16997
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 10:30:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 97F3D3A9CF0
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 09:28:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78DCC1B424A;
	Mon, 20 Jan 2025 09:27:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="sdbXDw5m";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="USaH9ikl";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="sdbXDw5m";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="USaH9ikl"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 601A41B423D;
	Mon, 20 Jan 2025 09:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737365222; cv=none; b=g2NUJZrJJXrXyO66ntlDssE0QpeumQThaM31ILGTPDs4eBTYkmT+24AV1wMVQ2yzzCkFgshaR+/f32vuBM+O0sxIU/7AI3R6UY9HvwyM0Zu1qQ7CBDYPZ7uRKfP3XnFu4XHmk0Bmo/3yzRk/fTbT8xKRyg9rJUoNa2f/RwKoMjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737365222; c=relaxed/simple;
	bh=/ifm/rS6EPJWzVKnxWSy4fnzOc7ij2BECSv5cfXbCCU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mBX8r3fpNhGtjfAQWDT0ivOej5THkdcuC3RbPXS8Sb/lrPADyqkd/0uBMqP9O2FRiFkd6DhTNLlBPgPSO+nElEdqbcQ98dpY1LMPQtm/aQ7WhhTshhUyJpoPfehKyw818OuR8Q9MwlHrCx2ic4u/KRlva6JGjfeLg0hJKuxRohg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=sdbXDw5m; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=USaH9ikl; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=sdbXDw5m; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=USaH9ikl; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 1DBC32115C;
	Mon, 20 Jan 2025 09:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1737365218; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=bv6KB66AQ+hDsgqF2IhGJ+tldjMx6QQt1nxuy0Q52+w=;
	b=sdbXDw5mVVlck7Fyr8xDAw8Pg426CrkvDWcb+S05GLUXdq2wMM1tdVqx4Ueg/8/6armRYs
	z2/MOuOREa4KYz0knsrXCjezUJAWBtro/vpGH/1zaiAJn0C6NyXfLbYFjTUNQknNMS0r+s
	S/QMU+iaylh6QaZ/2WuuCE0VLhBF4r8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1737365218;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=bv6KB66AQ+hDsgqF2IhGJ+tldjMx6QQt1nxuy0Q52+w=;
	b=USaH9iklyq1L1vL7LVhOtwTNtEXFrf/PXsAe/YCSpq8dr2omufIQY5GupxIc1jD8plv08z
	Eqw6k7rBa4Jk/TDA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=sdbXDw5m;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=USaH9ikl
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1737365218; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=bv6KB66AQ+hDsgqF2IhGJ+tldjMx6QQt1nxuy0Q52+w=;
	b=sdbXDw5mVVlck7Fyr8xDAw8Pg426CrkvDWcb+S05GLUXdq2wMM1tdVqx4Ueg/8/6armRYs
	z2/MOuOREa4KYz0knsrXCjezUJAWBtro/vpGH/1zaiAJn0C6NyXfLbYFjTUNQknNMS0r+s
	S/QMU+iaylh6QaZ/2WuuCE0VLhBF4r8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1737365218;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=bv6KB66AQ+hDsgqF2IhGJ+tldjMx6QQt1nxuy0Q52+w=;
	b=USaH9iklyq1L1vL7LVhOtwTNtEXFrf/PXsAe/YCSpq8dr2omufIQY5GupxIc1jD8plv08z
	Eqw6k7rBa4Jk/TDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 954B21393E;
	Mon, 20 Jan 2025 09:26:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id P8j8I+EWjmeQFgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 20 Jan 2025 09:26:57 +0000
Message-ID: <e49e3e78-1fb9-44b8-af11-69f7c39f5820@suse.cz>
Date: Mon, 20 Jan 2025 10:26:57 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v4 00/14] KVM: Restricted mapping of guest_memfd at
 the host and arm64 support
To: Fuad Tabba <tabba@google.com>, Ackerley Tng <ackerleytng@google.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org,
 pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au,
 anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com,
 aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk,
 brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org,
 xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com,
 jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com,
 yu.c.zhang@linux.intel.com, isaku.yamahata@intel.com, mic@digikod.net,
 vannapurve@google.com, mail@maciej.szmigiero.name, david@redhat.com,
 michael.roth@amd.com, wei.w.wang@intel.com, liam.merwick@oracle.com,
 isaku.yamahata@gmail.com, kirill.shutemov@linux.intel.com,
 suzuki.poulose@arm.com, steven.price@arm.com, quic_eberman@quicinc.com,
 quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com,
 quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com,
 quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com,
 james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev,
 maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com,
 roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com,
 rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com,
 jthoughton@google.com
References: <CA+EHjTzcx=eXSERSANMByhcgRRAbUL3kPAYkeu-uUgd0nPBPPA@mail.gmail.com>
 <diqzh65zzjc9.fsf@ackerleytng-ctop.c.googlers.com>
 <CA+EHjTwXqUHoEp8oqiNDcWqXxCBLHU1+jAdEN8J-pHZjxKnM+A@mail.gmail.com>
From: Vlastimil Babka <vbabka@suse.cz>
Content-Language: en-US
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 EP+ylKVEKb0Q2A==
In-Reply-To: <CA+EHjTwXqUHoEp8oqiNDcWqXxCBLHU1+jAdEN8J-pHZjxKnM+A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 1DBC32115C
X-Spam-Level: 
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	ARC_NA(0.00)[];
	TAGGED_RCPT(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ASN(0.00)[asn:25478, ipnet:::/0, country:RU];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim,suse.cz:mid];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,kvack.org,redhat.com,kernel.org,ellerman.id.au,brainfault.org,sifive.com,dabbelt.com,eecs.berkeley.edu,google.com,zeniv.linux.org.uk,infradead.org,linux-foundation.org,intel.com,linux.intel.com,digikod.net,maciej.szmigiero.name,amd.com,oracle.com,gmail.com,arm.com,quicinc.com,huawei.com,linux.dev,amazon.co.uk,nvidia.com];
	MID_RHS_MATCH_FROM(0.00)[];
	TO_MATCH_ENVRCPT_SOME(0.00)[];
	RCPT_COUNT_GT_50(0.00)[60];
	RCVD_COUNT_TWO(0.00)[2];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Score: -3.01
X-Spam-Flag: NO

On 1/16/25 10:19, Fuad Tabba wrote:
> Hi Ackerley,
> 
> On Thu, 16 Jan 2025 at 00:35, Ackerley Tng <ackerleytng@google.com> wrote:
>>
>> Registration of the folio_put() callback only happens if the VMM
>> actually tries to do vcpu_run(). For 4K folios I think this is okay
>> since the 4K folio can be freed via the transition state K -> state I,
>> but for hugetlb folios that have been split for sharing with userspace,
>> not getting a folio_put() callback means never putting the hugetlb folio
>> together. Hence, relying on vcpu_run() to add the folio_put() callback
>> leaves a way that hugetlb pages can be removed from the system.
>>
>> I think we should try and find a path forward that works for both 4K and
>> hugetlb folios.
> 
> I agree, this could be an issue, but we could find other ways to
> trigger the callback for huge folios. The important thing I was trying
> to get to is how to have the callback and be able to register it.
> 
>> IIUC page._mapcount and page.page_type works as a union because
>> page_type is only set for page types that are never mapped to userspace,
>> like PGTY_slab, PGTY_offline, etc.
> 
> In the last guest_memfd sync, David Hildenbrand mentioned that that
> would be a temporary restriction since the two structures would
> eventually be decoupled, work being done by Matthew Wilcox I believe.

Note the "temporary" might be few years still, it's a long-term project.

>> Technically PGTY_guest_memfd is only set once the page can never be
>> mapped to userspace, but PGTY_guest_memfd can only be set once mapcount
>> reaches 0. Since mapcount is added in the faulting process, could gmem
>> perhaps use some kind of .unmap/.unfault callback, so that gmem gets
>> notified of all unmaps and will know for sure that the mapcount gets to
>> 0?
> 
> I'm not sure if there is such a callback. If there were, I'm not sure
> what that would buy us really. The main pain point is the refcount
> going down to zero. The mapcount part is pretty straightforard and
> likely to be only temporary as mentioned, i.e., when it get decoupled,
> we could register the callback earlier and simplify the transition
> altogether.
> 
>> Alternatively, I took a look at the folio_is_zone_device()
>> implementation, and page.flags is used to identify the page's type. IIUC
>> a ZONE_DEVICE page also falls in the intersection of needing a
>> folio_put() callback and can be mapped to userspace. Could we use a
>> similar approach, using page.flags to identify a page as a guest_memfd
>> page? That way we don't need to know when unmapping happens, and will
>> always be able to get a folio_put() callback.
> 
> Same as above, with this being temporary, adding a new page flag might
> not be something that the rest of the community might be too excited
> about :)

Yeah, adding a page flag is very difficult these days. Also while it's
technically true that being a ZONE_DEVICE page is recorded in the page flags
field, it's not really a separate flag - just that some bits of the flags
field encode the zonenum. But zonenum is a number, not independent flags -
i.e. there can be up to 8 zones, using up to 3 flag bits. And page's zonenum
also has to match the zone's pfn range, so we couldn't just change the zone
of a page to some hypothetical ZONE_MEMFD when it becomes used for memfd.

> Thanks for your comments!
> /fuad
> 
>> [1] https://lpc.events/event/18/contributions/1758/attachments/1457/3699/Guestmemfd%20folio%20state%20page_type.pdf
>> [2] https://android-kvm.googlesource.com/linux/+/764360863785ba16d974253a572c87abdd9fdf0b%5E%21/#F0
>>
>> > This patch series doesn't necessarily impose all these transitions,
>> > many of them would be a matter of policy. This just happens to be the
>> > current way I've done it with pKVM/arm64.
>> >
>> > Cheers,
>> > /fuad
>> >
>> > On Fri, 13 Dec 2024 at 16:48, Fuad Tabba <tabba@google.com> wrote:
>> >>
>> >> This series adds restricted mmap() support to guest_memfd, as
>> >> well as support for guest_memfd on arm64. It is based on Linux
>> >> 6.13-rc2.  Please refer to v3 for the context [1].
>> >>
>> >> Main changes since v3:
>> >> - Added a new folio type for guestmem, used to register a
>> >>   callback when a folio's reference count reaches 0 (Matthew
>> >>   Wilcox, DavidH) [2]
>> >> - Introduce new mappability states for folios, where a folio can
>> >> be mappable by the host and the guest, only the guest, or by no
>> >> one (transient state)
>> >> - Rebased on Linux 6.13-rc2
>> >> - Refactoring and tidying up
>> >>
>> >> Cheers,
>> >> /fuad
>> >>
>> >> [1] https://lore.kernel.org/all/20241010085930.1546800-1-tabba@google.com/
>> >> [2] https://lore.kernel.org/all/20241108162040.159038-1-tabba@google.com/
>> >>
>> >> Ackerley Tng (2):
>> >>   KVM: guest_memfd: Make guest mem use guest mem inodes instead of
>> >>     anonymous inodes
>> >>   KVM: guest_memfd: Track mappability within a struct kvm_gmem_private
>> >>
>> >> Fuad Tabba (12):
>> >>   mm: Consolidate freeing of typed folios on final folio_put()
>> >>   KVM: guest_memfd: Introduce kvm_gmem_get_pfn_locked(), which retains
>> >>     the folio lock
>> >>   KVM: guest_memfd: Folio mappability states and functions that manage
>> >>     their transition
>> >>   KVM: guest_memfd: Handle final folio_put() of guestmem pages
>> >>   KVM: guest_memfd: Allow host to mmap guest_memfd() pages when shared
>> >>   KVM: guest_memfd: Add guest_memfd support to
>> >>     kvm_(read|/write)_guest_page()
>> >>   KVM: guest_memfd: Add KVM capability to check if guest_memfd is host
>> >>     mappable
>> >>   KVM: guest_memfd: Add a guest_memfd() flag to initialize it as
>> >>     mappable
>> >>   KVM: guest_memfd: selftests: guest_memfd mmap() test when mapping is
>> >>     allowed
>> >>   KVM: arm64: Skip VMA checks for slots without userspace address
>> >>   KVM: arm64: Handle guest_memfd()-backed guest page faults
>> >>   KVM: arm64: Enable guest_memfd private memory when pKVM is enabled
>> >>
>> >>  Documentation/virt/kvm/api.rst                |   4 +
>> >>  arch/arm64/include/asm/kvm_host.h             |   3 +
>> >>  arch/arm64/kvm/Kconfig                        |   1 +
>> >>  arch/arm64/kvm/mmu.c                          | 119 +++-
>> >>  include/linux/kvm_host.h                      |  75 +++
>> >>  include/linux/page-flags.h                    |  22 +
>> >>  include/uapi/linux/kvm.h                      |   2 +
>> >>  include/uapi/linux/magic.h                    |   1 +
>> >>  mm/debug.c                                    |   1 +
>> >>  mm/swap.c                                     |  28 +-
>> >>  tools/testing/selftests/kvm/Makefile          |   1 +
>> >>  .../testing/selftests/kvm/guest_memfd_test.c  |  64 +-
>> >>  virt/kvm/Kconfig                              |   4 +
>> >>  virt/kvm/guest_memfd.c                        | 579 +++++++++++++++++-
>> >>  virt/kvm/kvm_main.c                           | 229 ++++++-
>> >>  15 files changed, 1074 insertions(+), 59 deletions(-)
>> >>
>> >>
>> >> base-commit: fac04efc5c793dccbd07e2d59af9f90b7fc0dca4
>> >> --
>> >> 2.47.1.613.gc27f4b7a9f-goog
>> >>


