Return-Path: <kvm+bounces-11549-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D07FB8781A9
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 15:30:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5B2231F2110C
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 14:30:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED4F3383A4;
	Mon, 11 Mar 2024 14:30:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bwd4DACS"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AF3740C1F
	for <kvm@vger.kernel.org>; Mon, 11 Mar 2024 14:30:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710167443; cv=none; b=QdgovkNs3V7D+M8IfILsnTWH4gvcqL7lz0Ut/U9DjwWe6VXsPrUOEiLGTnaT572SIORAHBCSaT1yV38pbzkxui7rC/roUOCIntue9Lhiide5g52LikFNJA+7RwRdVGaXSw4kZ84Xp42ORNOOIGwjCOWYBgB46OEY9heEj8nS6Yg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710167443; c=relaxed/simple;
	bh=1yTEiKSiyUHemYNzJTnemPdsDE+Wf76MT+JqC6zEVAU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bod5fPO0dEyNXC1VEP9mdomHLM0NFGL83xDno/DhP5xB3Iu6ENlSFt84BJVIbaNub/SnvAcnTEtve08fvpn4j6r4i0FInQ0d5GAksgpyZFUtnb+SxdTeRcwyw5fPNbY8BNRtSNGdZfyH22kaJdcEpDu8WB49BuQWnJD3Lb5ZtFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bwd4DACS; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710167440;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=1Oul+4p1r6szbX/v2IwBpO0PMKqm0aeNFHvedPEUl4Q=;
	b=bwd4DACSWfxmeJVWLXToJ30Tfnfn9MNDaGR7p6WMgdqQ8BT7qGzME9CftEXRo+vM6HUddj
	KBexB/7MzY5cikjZcc6sX41GBTQ8QEg57LTAvJFUOT2fH83p7J19Cq+tSU2Ou5QYC8EnN6
	HIBTw3mKfXQPDylnZGqp9nAqFZBNsGk=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-634-MAqaaxi9OeerrY_ypCmfpg-1; Mon, 11 Mar 2024 10:30:38 -0400
X-MC-Unique: MAqaaxi9OeerrY_ypCmfpg-1
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-5682c6c7c70so1312198a12.2
        for <kvm@vger.kernel.org>; Mon, 11 Mar 2024 07:30:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710167437; x=1710772237;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1Oul+4p1r6szbX/v2IwBpO0PMKqm0aeNFHvedPEUl4Q=;
        b=HsTFLgRUCuQblqbgRK84brZdvIHUel+7P6xvGJUwrC4FlZGKzHCSPD/P/qgM10TZaY
         EpkgKBVduOc7ll/0AsOHcCNHiJKgO5YeS6nhGVs8z1OHtx/IpzytITzgJlk+m7NrwK2P
         w0KlQdC6mpMNbJJpwdXpCmHYdDrUJjF0qCxndBEsvpL947WiYJP9+ZjXZlFbXTwsaNCk
         fzvFOIjz7Br1i/wmcNCZqPWDmrCdMM7POFs0KatgGg3Z0sxzsXVNkbM23UYe3tzdCGbp
         kowBI8iBivmUB7YSzkHZul7UEJnbOVONiyIdOUhoCz+IadKfH6lFikaSGJGXLwnNt2Bb
         ZIxg==
X-Gm-Message-State: AOJu0YzGqtsHzeUzcP8w5aqz9iVzeQ4HR/mRpNVjQ2J7zTdJU/3uQ6vJ
	zTFscTmnYubdPWd3y51d4/pxuG3gNxLM6jou3wn1QWnbagocP/vrdduamVXyeS7gjTJG6Oz/cho
	jaZ0x7xg7KDGmA3el9yLaPKiJFyTmEiEM950FHlX/VVeohTb8kg==
X-Received: by 2002:a50:d695:0:b0:566:fc25:5627 with SMTP id r21-20020a50d695000000b00566fc255627mr3387181edi.41.1710167437401;
        Mon, 11 Mar 2024 07:30:37 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGsWQbEA5YCqa3msTPJnw6h3VjBukuPIVLv5EP0oJgRGaC8fwxHb/NoxmhQiOY4IpZhg/SaZQ==
X-Received: by 2002:a50:d695:0:b0:566:fc25:5627 with SMTP id r21-20020a50d695000000b00566fc255627mr3387171edi.41.1710167437067;
        Mon, 11 Mar 2024 07:30:37 -0700 (PDT)
Received: from [192.168.10.81] ([151.49.77.21])
        by smtp.googlemail.com with ESMTPSA id k15-20020aa7c04f000000b0056864cde14dsm621950edo.68.2024.03.11.07.30.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Mar 2024 07:30:36 -0700 (PDT)
Message-ID: <d49b773e-c857-41e4-a84e-a18ebaa9a334@redhat.com>
Date: Mon, 11 Mar 2024 15:30:35 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] KVM: x86: MMU changes for 6.9
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20240308223702.1350851-1-seanjc@google.com>
 <20240308223702.1350851-5-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20240308223702.1350851-5-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/8/24 23:36, Sean Christopherson wrote:
> The bulk of the changes are TDP MMU improvements related to memslot deletion
> (ChromeOS has a use case that "requires" frequent deletion of a GPU buffer).
> The other highlight is allocating the write-tracking metadata on-demand, e.g.
> so that distro kernels pay the memory cost of the arrays if and only if KVM
> or KVMGT actually needs to shadow guest page tables.
> 
> The following changes since commit 41bccc98fb7931d63d03f326a746ac4d429c1dd3:
> 
>    Linux 6.8-rc2 (2024-01-28 17:01:12 -0800)
> 
> are available in the Git repository at:
> 
>    https://github.com/kvm-x86/linux.git tags/kvm-x86-mmu-6.9
> 
> for you to fetch changes up to a364c014a2c1ad6e011bc5fdb8afb9d4ba316956:
> 
>    kvm/x86: allocate the write-tracking metadata on-demand (2024-02-27 11:49:54 -0800)

Pulled, thanks.

Paolo

> ----------------------------------------------------------------
> KVM x86 MMU changes for 6.9:
> 
>   - Clean up code related to unprotecting shadow pages when retrying a guest
>     instruction after failed #PF-induced emulation.
> 
>   - Zap TDP MMU roots at 4KiB granularity to minimize the delay in yielding if
>     a reschedule is needed, e.g. if a high priority task needs to run.  Because
>     KVM doesn't support yielding in the middle of processing a zapped non-leaf
>     SPTE, zapping at 1GiB granularity can result in multi-millisecond lag when
>     attempting to schedule in a high priority.
> 
>   - Rework TDP MMU root unload, free, and alloc to run with mmu_lock held for
>     read, e.g. to avoid serializing vCPUs when userspace deletes a memslot.
> 
>   - Allocate write-tracking metadata on-demand to avoid the memory overhead when
>     running kernels built with KVMGT support (external write-tracking enabled),
>     but for workloads that don't use nested virtualization (shadow paging) or
>     KVMGT.
> 
> ----------------------------------------------------------------
> Andrei Vagin (1):
>        kvm/x86: allocate the write-tracking metadata on-demand
> 
> Kunwu Chan (1):
>        KVM: x86/mmu: Use KMEM_CACHE instead of kmem_cache_create()
> 
> Mingwei Zhang (1):
>        KVM: x86/mmu: Don't acquire mmu_lock when using indirect_shadow_pages as a heuristic
> 
> Sean Christopherson (10):
>        KVM: x86: Drop dedicated logic for direct MMUs in reexecute_instruction()
>        KVM: x86: Drop superfluous check on direct MMU vs. WRITE_PF_TO_SP flag
>        KVM: x86/mmu: Zap invalidated TDP MMU roots at 4KiB granularity
>        KVM: x86/mmu: Don't do TLB flush when zappings SPTEs in invalid roots
>        KVM: x86/mmu: Allow passing '-1' for "all" as_id for TDP MMU iterators
>        KVM: x86/mmu: Skip invalid roots when zapping leaf SPTEs for GFN range
>        KVM: x86/mmu: Skip invalid TDP MMU roots when write-protecting SPTEs
>        KVM: x86/mmu: Check for usable TDP MMU root while holding mmu_lock for read
>        KVM: x86/mmu: Alloc TDP MMU roots while holding mmu_lock for read
>        KVM: x86/mmu: Free TDP MMU roots while holding mmy_lock for read
> 
>   arch/x86/include/asm/kvm_host.h |   9 +++
>   arch/x86/kvm/mmu/mmu.c          |  37 +++++++-----
>   arch/x86/kvm/mmu/page_track.c   |  68 +++++++++++++++++++++-
>   arch/x86/kvm/mmu/tdp_mmu.c      | 124 ++++++++++++++++++++++++++++------------
>   arch/x86/kvm/mmu/tdp_mmu.h      |   2 +-
>   arch/x86/kvm/x86.c              |  35 +++++-------
>   6 files changed, 201 insertions(+), 74 deletions(-)
> 


