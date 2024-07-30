Return-Path: <kvm+bounces-22636-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 50F96940C99
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 10:58:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8C0CAB25A3D
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 08:58:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6A5D19409A;
	Tue, 30 Jul 2024 08:58:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KBRrCz0z"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B09F11922C1
	for <kvm@vger.kernel.org>; Tue, 30 Jul 2024 08:58:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722329885; cv=none; b=eKUF/zAzPegPFNEk2wSJpfNwMfDCAZ1B1ee6ejeyDFkT9jXE76LZOMZJinBgp8gwNet1kYHYTq9ZFbw86upCyFHfJUbzIuonYzlVSiVf2oU9rxCDLEG66fJuFyzmV8F1YpOGByR6qdqbQfFBJU1NYqdXRFTM/+6uxhJeiCUEsX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722329885; c=relaxed/simple;
	bh=UOn93hUpu6nETBc80RJAdFaC1UNmh5dFpSEiFmnvSVI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jgnzyYHOIP8sd4yeMkDq+ZzqXIfkZ/8XbKq0Ill87VCsnILeGYieVGyhnjVzB6Q/hyGgo82phuiCyOrx9MUORb2TCGLrAwvfRP75flwNm9dVCMSQ12lrYik4KzCoFJoCncZr+BY1Dk8pA41YxS5eAVzoIHRGkt0s83VWHxJZo58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KBRrCz0z; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722329881;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ZpZjVsHvHCj8FzxVeFJOZEzA3scYhLR2Ib5TteBtfAg=;
	b=KBRrCz0zOtVzNNRjfM/kTmnO01ui/3uWFXR5wT/Ez/tfRi0XDULz9d48rpYEx5BvUISUET
	Q/SmwHWDY9SCic0gIG6qftZK/Lgt2iGV5pepDrX7sOrrG3a2dqxqoe+BrZDF+qIaBjpcY9
	9PA7AWNOn//0RqVlBb0UhI+SD2WW3c0=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-42-MSqovcIaO8K9Xb4Lr-bsKw-1; Tue, 30 Jul 2024 04:57:59 -0400
X-MC-Unique: MSqovcIaO8K9Xb4Lr-bsKw-1
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-a7a979cae97so392560566b.1
        for <kvm@vger.kernel.org>; Tue, 30 Jul 2024 01:57:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722329878; x=1722934678;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZpZjVsHvHCj8FzxVeFJOZEzA3scYhLR2Ib5TteBtfAg=;
        b=i3AbmpcYi+3bkhxNOx1yq43aQ1uuPXp/DNC6YT836APLLFkt44HxOqAJTZUZ9qaueU
         Je5Z4NcHGgcUHCldJkgY0Gp75G+tiBCTJrR+qcoBlh1CbeFTmwuYXE6RjA9WKyHahlx0
         IJYJBEFPmR8ELfmsx5mDWfPgjbPRNIZyXS5t9bPNA/73B5RE5XeTyCmWh6VkTj913SE6
         Pv0uQ7ju3lUK7lT/ejfVYIHa4ri8W5qHGLidqRVkNwMnclY0iCTCbPsbyQSZeP403a+U
         cVeN8ofapiUe2knxfFAJS6hd3aWOjmPypswC9it1ew3hHth1Wufsz/VGQ7NK7vNKbl8T
         5Ibg==
X-Gm-Message-State: AOJu0Yz4LZfzHptD+ak34T1XBOpJ83FHa7OhgQMmUsNIcUq+2IhucNSJ
	i9A8iIo8gcxhAUxa7BCfRHoFtLtUwZv7fYNBJCTX2hjlE1HLb021jXfSwHlPacZrA8UkxXtA2wI
	Ap7d5OFOeG+f/2Q3iq8xoRaQuvsHxDU094iMGKkvLc28frGh46A==
X-Received: by 2002:a17:907:3f1f:b0:a7a:c106:3647 with SMTP id a640c23a62f3a-a7d401861c0mr815521866b.58.1722329878638;
        Tue, 30 Jul 2024 01:57:58 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFO2B6RyDZT6FnZIzF9nSeY5BVBQwIsgCkX4qd602jC/+1nmH3bvjS4vKWDGNBFOCLTdQ0vMQ==
X-Received: by 2002:a17:907:3f1f:b0:a7a:c106:3647 with SMTP id a640c23a62f3a-a7d401861c0mr815518266b.58.1722329878201;
        Tue, 30 Jul 2024 01:57:58 -0700 (PDT)
Received: from [192.168.10.47] ([151.95.101.29])
        by smtp.googlemail.com with ESMTPSA id a640c23a62f3a-a7acad411a6sm609184766b.117.2024.07.30.01.57.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Jul 2024 01:57:57 -0700 (PDT)
Message-ID: <e425ac5e-6ca2-463e-879c-acb7d231ab72@redhat.com>
Date: Tue, 30 Jul 2024 10:57:55 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 41/84] KVM: x86/mmu: Mark pages/folios dirty at the
 origin of make_spte()
To: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oliver.upton@linux.dev>, Tianrui Zhao
 <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>,
 Huacai Chen <chenhuacai@kernel.org>, Michael Ellerman <mpe@ellerman.id.au>,
 Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>,
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev, loongarch@lists.linux.dev,
 linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
 linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>,
 David Stevens <stevensd@chromium.org>
References: <20240726235234.228822-1-seanjc@google.com>
 <20240726235234.228822-42-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20240726235234.228822-42-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/27/24 01:51, Sean Christopherson wrote:
> Move the marking of folios dirty from make_spte() out to its callers,
> which have access to the _struct page_, not just the underlying pfn.
> Once all architectures follow suit, this will allow removing KVM's ugly
> hack where KVM elevates the refcount of VM_MIXEDMAP pfns that happen to
> be struct page memory.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/mmu/mmu.c         | 29 +++++++++++++++++++++++++++--
>   arch/x86/kvm/mmu/paging_tmpl.h |  5 +++++
>   arch/x86/kvm/mmu/spte.c        | 11 -----------
>   3 files changed, 32 insertions(+), 13 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 1cdd67707461..7e7b855ce1e1 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -2918,7 +2918,16 @@ static bool kvm_mmu_prefetch_sptes(struct kvm_vcpu *vcpu, gfn_t gfn, u64 *sptep,
>   	for (i = 0; i < nr_pages; i++, gfn++, sptep++) {
>   		mmu_set_spte(vcpu, slot, sptep, access, gfn,
>   			     page_to_pfn(pages[i]), NULL);
> -		kvm_release_page_clean(pages[i]);
> +
> +		/*
> +		 * KVM always prefetches writable pages from the primary MMU,
> +		 * and KVM can make its SPTE writable in the fast page, without

"with a fast page fault"

Paolo

> +		 * notifying the primary MMU.  Mark pages/folios dirty now to
> +		 * ensure file data is written back if it ends up being written
> +		 * by the guest.  Because KVM's prefetching GUPs writable PTEs,
> +		 * the probability of unnecessary writeback is extremely low.
> +		 */
> +		kvm_release_page_dirty(pages[i]);
>   	}
>   
>   	return true;
> @@ -4314,7 +4323,23 @@ static u8 kvm_max_private_mapping_level(struct kvm *kvm, kvm_pfn_t pfn,
>   static void kvm_mmu_finish_page_fault(struct kvm_vcpu *vcpu,
>   				      struct kvm_page_fault *fault, int r)
>   {
> -	kvm_release_pfn_clean(fault->pfn);
> +	lockdep_assert_once(lockdep_is_held(&vcpu->kvm->mmu_lock) ||
> +			    r == RET_PF_RETRY);
> +
> +	/*
> +	 * If the page that KVM got from the *primary MMU* is writable, and KVM
> +	 * installed or reused a SPTE, mark the page/folio dirty.  Note, this
> +	 * may mark a folio dirty even if KVM created a read-only SPTE, e.g. if
> +	 * the GFN is write-protected.  Folios can't be safely marked dirty
> +	 * outside of mmu_lock as doing so could race with writeback on the
> +	 * folio.  As a result, KVM can't mark folios dirty in the fast page
> +	 * fault handler, and so KVM must (somewhat) speculatively mark the
> +	 * folio dirty if KVM could locklessly make the SPTE writable.
> +	 */
> +	if (!fault->map_writable || r == RET_PF_RETRY)
> +		kvm_release_pfn_clean(fault->pfn);
> +	else
> +		kvm_release_pfn_dirty(fault->pfn);
>   }
>   
>   static int kvm_mmu_faultin_pfn_private(struct kvm_vcpu *vcpu,
> diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
> index b6897916c76b..2e2d87a925ac 100644
> --- a/arch/x86/kvm/mmu/paging_tmpl.h
> +++ b/arch/x86/kvm/mmu/paging_tmpl.h
> @@ -953,6 +953,11 @@ static int FNAME(sync_spte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp, int
>   		  spte_to_pfn(spte), spte, true, false,
>   		  host_writable, &spte);
>   
> +	/*
> +	 * There is no need to mark the pfn dirty, as the new protections must
> +	 * be a subset of the old protections, i.e. synchronizing a SPTE cannot
> +	 * change the SPTE from read-only to writable.
> +	 */
>   	return mmu_spte_update(sptep, spte);
>   }
>   
> diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
> index 9b8795bd2f04..2c5650390d3b 100644
> --- a/arch/x86/kvm/mmu/spte.c
> +++ b/arch/x86/kvm/mmu/spte.c
> @@ -277,17 +277,6 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
>   		mark_page_dirty_in_slot(vcpu->kvm, slot, gfn);
>   	}
>   
> -	/*
> -	 * If the page that KVM got from the primary MMU is writable, i.e. if
> -	 * it's host-writable, mark the page/folio dirty.  As alluded to above,
> -	 * folios can't be safely marked dirty in the fast page fault handler,
> -	 * and so KVM must (somewhat) speculatively mark the folio dirty even
> -	 * though it isn't guaranteed to be written as KVM won't mark the folio
> -	 * dirty if/when the SPTE is made writable.
> -	 */
> -	if (host_writable)
> -		kvm_set_pfn_dirty(pfn);
> -
>   	*new_spte = spte;
>   	return wrprot;
>   }


