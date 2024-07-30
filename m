Return-Path: <kvm+bounces-22637-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CEB08940C9C
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 10:58:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F1EB51C23F89
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 08:58:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5722A19309D;
	Tue, 30 Jul 2024 08:58:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FowL94K0"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F33DE193066
	for <kvm@vger.kernel.org>; Tue, 30 Jul 2024 08:58:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722329922; cv=none; b=YwKOPeU5pAjsTAFG7CYaLuNHTuWLWEARzKmj0rfqJsz9cMvrJOji6b4kgTaqRz2+Hu4uBEvR5vmALUMg+63vQy2vZxeHd2B4m7DfP3iWvthcQecX4DUhk8qC1r1IJ3CW5eYoVBQ425NpwTN0Yq+lpIfMNxyDd0WLkzand0ijs1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722329922; c=relaxed/simple;
	bh=EpbFft7k9LR3yuwv5SneRaCSrWFjcX4GdMUQP2+iYwQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=vDnx5tq1n733cJQIbvOomsgzVx4RuA8AZLG7wxDOPxOrNihBMvoT2tBvLA4TTqB6TBB298YrDXXlnBH7CKOtY8ZfCKhs16arCyQzO9YEzDEFne3NCfJA6JEVBy3/Bv94H7xRFPBdp1CIMOZ1/Yc6hH3p67c4QAZcHropzg10DT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FowL94K0; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722329919;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=zlKIS7PY1R1uG9/LMJppzQ5g00aOsNX7QI5FGYK14fE=;
	b=FowL94K0t0e9Iezl+57zuy6HqDVX7aqwW2i1d4pGrT12JucNN0c9PbOISaCNzusohEj38N
	OwH4zz5OUuEMYvAB8UHNCqYflqFWSQPtqJ5HJ6bcU36JfS1184ABEzDMdcKvQ4FkZPUJbH
	Ngq0CTP2s+WA8ytCeK/EBufJUySTbjU=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-338-P3hxgKQ6PpWO0MLVlMfNVw-1; Tue, 30 Jul 2024 04:58:37 -0400
X-MC-Unique: P3hxgKQ6PpWO0MLVlMfNVw-1
Received: by mail-lf1-f69.google.com with SMTP id 2adb3069b0e04-52fcb0f226bso5418110e87.0
        for <kvm@vger.kernel.org>; Tue, 30 Jul 2024 01:58:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722329915; x=1722934715;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zlKIS7PY1R1uG9/LMJppzQ5g00aOsNX7QI5FGYK14fE=;
        b=gT0qhEV110eG+sKtRdXYTokRQku73FlC//tMBupjlutJPXR3KMh5hBxrDGuJqvt0+K
         z7G2V//XOZJjsyxLJYFUIEnNRXZw4fWPJVPKNISDkyU2tduoMECnIR4lGiOyLfbCxMs3
         cOOcPnfNtAjumaayHw+4J40RvQgnVJvnqUrE0dPEstFgoZzbnBP+39u2K0vreLlsXxze
         TlmQtrVlZEFLO/sJig2RJc+HsrkQxVg74bmCOPud1R0Dj2g3VxZ1kcUoXTFaZQFiX2b9
         qvmVvSFePWUPojpip8p+R8Y3anyraV6hnjpdQCD9kR+S0tBD/UT/YyYRQ+1v9l+ICbjD
         XmRQ==
X-Gm-Message-State: AOJu0YwRK9XgUeFeQtxGnUKoehCaq4mB57xrbypxPvkyMYgaCNoiffJk
	JNPA5vLRgOEXr4zrOl6tQPr887rht69hXqgaxJtz0zH26Em8AgacIGQeVVN7TA8cWkIz26gaYoa
	TnVu80YTdhxw2IQ2YN1geoBmal2lysRjZGuWnRGhhcTMDFXfGVw==
X-Received: by 2002:a19:6a0e:0:b0:52e:fa14:cc96 with SMTP id 2adb3069b0e04-5309b27e54dmr7004182e87.34.1722329915433;
        Tue, 30 Jul 2024 01:58:35 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHAOIIltVQdWTS+wB0eMPC1Ma/f+US5vc2+G0XsatRnSCbICJZcTeRE4zXEmrhssvwMjnoa3g==
X-Received: by 2002:a19:6a0e:0:b0:52e:fa14:cc96 with SMTP id 2adb3069b0e04-5309b27e54dmr7004170e87.34.1722329914765;
        Tue, 30 Jul 2024 01:58:34 -0700 (PDT)
Received: from [192.168.10.47] ([151.95.101.29])
        by smtp.googlemail.com with ESMTPSA id a640c23a62f3a-a7acab23125sm616347566b.1.2024.07.30.01.58.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Jul 2024 01:58:34 -0700 (PDT)
Message-ID: <96df1dd5-cc31-4e84-84fd-ea75b4800be8@redhat.com>
Date: Tue, 30 Jul 2024 10:58:32 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 48/84] KVM: Move x86's API to release a faultin page
 to common KVM
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
 <20240726235234.228822-49-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20240726235234.228822-49-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/27/24 01:51, Sean Christopherson wrote:
> Move KVM x86's helper that "finishes" the faultin process to common KVM
> so that the logic can be shared across all architectures.  Note, not all
> architectures implement a fast page fault path, but the gist of the
> comment applies to all architectures.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/mmu/mmu.c   | 24 ++----------------------
>   include/linux/kvm_host.h | 26 ++++++++++++++++++++++++++
>   2 files changed, 28 insertions(+), 22 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 95beb50748fc..2a0cfa225c8d 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4323,28 +4323,8 @@ static u8 kvm_max_private_mapping_level(struct kvm *kvm, kvm_pfn_t pfn,
>   static void kvm_mmu_finish_page_fault(struct kvm_vcpu *vcpu,
>   				      struct kvm_page_fault *fault, int r)
>   {
> -	lockdep_assert_once(lockdep_is_held(&vcpu->kvm->mmu_lock) ||
> -			    r == RET_PF_RETRY);
> -
> -	if (!fault->refcounted_page)
> -		return;
> -
> -	/*
> -	 * If the page that KVM got from the *primary MMU* is writable, and KVM
> -	 * installed or reused a SPTE, mark the page/folio dirty.  Note, this
> -	 * may mark a folio dirty even if KVM created a read-only SPTE, e.g. if
> -	 * the GFN is write-protected.  Folios can't be safely marked dirty
> -	 * outside of mmu_lock as doing so could race with writeback on the
> -	 * folio.  As a result, KVM can't mark folios dirty in the fast page
> -	 * fault handler, and so KVM must (somewhat) speculatively mark the
> -	 * folio dirty if KVM could locklessly make the SPTE writable.
> -	 */
> -	if (r == RET_PF_RETRY)
> -		kvm_release_page_unused(fault->refcounted_page);
> -	else if (!fault->map_writable)
> -		kvm_release_page_clean(fault->refcounted_page);
> -	else
> -		kvm_release_page_dirty(fault->refcounted_page);
> +	kvm_release_faultin_page(vcpu->kvm, fault->refcounted_page,
> +				 r == RET_PF_RETRY, fault->map_writable);

Does it make sense to move RET_PF_* to common code, and avoid a bool 
argument here?

Paolo

>   }
>   
>   static int kvm_mmu_faultin_pfn_private(struct kvm_vcpu *vcpu,
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 9d2a97eb30e4..91341cdc6562 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -1216,6 +1216,32 @@ static inline void kvm_release_page_unused(struct page *page)
>   void kvm_release_page_clean(struct page *page);
>   void kvm_release_page_dirty(struct page *page);
>   
> +static inline void kvm_release_faultin_page(struct kvm *kvm, struct page *page,
> +					    bool unused, bool dirty)
> +{
> +	lockdep_assert_once(lockdep_is_held(&kvm->mmu_lock) || unused);
> +
> +	if (!page)
> +		return;
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
> +	if (unused)
> +		kvm_release_page_unused(page);
> +	else if (dirty)
> +		kvm_release_page_dirty(page);
> +	else
> +		kvm_release_page_clean(page);
> +}
> +
>   kvm_pfn_t kvm_lookup_pfn(struct kvm *kvm, gfn_t gfn);
>   kvm_pfn_t __kvm_faultin_pfn(const struct kvm_memory_slot *slot, gfn_t gfn,
>   			    unsigned int foll, bool *writable,


