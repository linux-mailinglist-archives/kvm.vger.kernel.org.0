Return-Path: <kvm+bounces-41246-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AB263A657FE
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 17:28:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BE1571893684
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 16:28:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 357FA19E998;
	Mon, 17 Mar 2025 16:27:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="w9SreRvH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E445117A2E5
	for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 16:27:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742228876; cv=none; b=tqTWX9XqoZsZFu5Wiq15EdYvf6vY4SudiZEzvHZgh0O3tX5oI/5DrLmnz2/2VKGoZ1nt0YeaHFJnG85RUCEKZUtHxSBJczCbNIpR5lwtgGDqcIM7H1n7TEGO9fDFk19Pny7pHVHpdzsDhj9pT6cpt4LkdztMmWbNj7YbLGQHVus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742228876; c=relaxed/simple;
	bh=LeEmEJJ9eGeq8YfwJZC1ZtfJPbwd3P8PaOZPDHYHIfE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=rJQjC5JgDicDPavphjn9OKlIb5dTUhs1gpl1xB58uh0WlTfqYDAVMiqZFFN9on39XfnSBXOn/LK0NfCnevEzZwkLjanso2bBBctQvpxuVJoGskGsyn4ZPaQ3rCL455KiBqznHCD9yBxXNP+oAhkdtvuGonqVIBdQvueDWYSvGh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=w9SreRvH; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ff55176edcso3131669a91.1
        for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 09:27:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1742228874; x=1742833674; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=W8d3f9bwZb24F92RREK1YCHX2o38Tp6QBPGEvO0sKaU=;
        b=w9SreRvHsssw11edOVYLPDQSXWlOA64JhzuDZT0tn6l3wtlBqHu+sIIw2j+E2e41iv
         sz3fOmVX3B4/WDmB3v4/ZBtnLOdIvic0pS0hDMmshIm7EO7khc7ks6Ypm3KqXJuSJpbr
         TCTvdaBkSbMx0SNSvFkSWsP6TmgJdxa4V1/6xHc2F6GlmJy9WYGpJ3i8cfQ+P1RfjN8h
         u/QSkVTzEEIWx8XweA+tQQgztTeQmGVWrmTReHUuVxIUBd3MXPNk0FLyRQmztRdPk8Sh
         gUfOUKXraeZ0/eIMvEQtgULUh1K4CC85ygN3GlOWuiE4625omKI200fYdi8n87EIA8TV
         5kYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742228874; x=1742833674;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=W8d3f9bwZb24F92RREK1YCHX2o38Tp6QBPGEvO0sKaU=;
        b=TnRKCCU6sR4jxCWZApwSweH3GvoYhGocDBEpS+0S61MaLiVGsmTZhCp5G618GeiAXD
         QGMqXaVjzc1T0ITAFRAqpIOota2EY6EA7HqA+4nvnTq3gvCIzReYDptdrkaRuH3ieipC
         bUwwhaxmbM58VQeWtZ+1HlXt/pVuW5vjoLMfjUnnvWdJ5KrSm6Pg96dD4DeNfap+LcZO
         43ufvinnfIfPCPMQnHnAvJOqlusUO1wE890yLpWJVoZ7QQDkF2oWcKzS8cs0KF4mkA3r
         /ty97zBGWGDeVdKF6X1jSUwk0LD2b+KyJzoNSqz8bFDoDZNSz8bn2js8PFrviKp6Czyr
         9JeA==
X-Gm-Message-State: AOJu0Yz4hvNKb08cXb+qQ5s9LoFWjj7xFO2izfn5FZwhH7mhlO3gcrUb
	g8972+UlCvkMlES51A1kmhGQioeTZsunR/AFGY9KG4o9AQNSNCyas4sO/fhSNGp/nKMEJxuunLq
	EALb1nR0sAuhxD3u92H3uDA==
X-Google-Smtp-Source: AGHT+IG4WirUOV3+r5B2lb31NOl3SYbtGGIlb7cjVN18KcQU2Z2EqVpQ/NTkkFp10CSOZgMn9KFkZaVD4S3aseWUuQ==
X-Received: from pjn6.prod.google.com ([2002:a17:90b:5706:b0:2f9:e05f:187f])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:2e44:b0:2ff:502e:62d4 with SMTP id 98e67ed59e1d1-30151d5bcdamr14234779a91.32.1742228874055;
 Mon, 17 Mar 2025 09:27:54 -0700 (PDT)
Date: Mon, 17 Mar 2025 16:27:52 +0000
In-Reply-To: <fe2955d4-c0a2-411a-9e50-a25cc15c75dd@suse.cz>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <diqzy0x9rqf4.fsf@ackerleytng-ctop.c.googlers.com> <fe2955d4-c0a2-411a-9e50-a25cc15c75dd@suse.cz>
Message-ID: <diqzmsdjk4fr.fsf@ackerleytng-ctop.c.googlers.com>
Subject: Re: [PATCH v6 03/10] KVM: guest_memfd: Handle kvm_gmem_handle_folio_put()
 for KVM as a module
From: Ackerley Tng <ackerleytng@google.com>
To: Vlastimil Babka <vbabka@suse.cz>, Fuad Tabba <tabba@google.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vannapurve@google.com, 
	mail@maciej.szmigiero.name, david@redhat.com, michael.roth@amd.com, 
	wei.w.wang@intel.com, liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, peterx@redhat.com
Content-Type: text/plain; charset="UTF-8"

Vlastimil Babka <vbabka@suse.cz> writes:

> On 3/13/25 14:49, Ackerley Tng wrote:
>> Fuad Tabba <tabba@google.com> writes:
>> 
>>> In some architectures, KVM could be defined as a module. If there is a
>>> pending folio_put() while KVM is unloaded, the system could crash. By
>>> having a helper check for that and call the function only if it's
>>> available, we are able to handle that case more gracefully.
>>>
>>> Signed-off-by: Fuad Tabba <tabba@google.com>
>>>
>>> ---
>>>
>>> This patch could be squashed with the previous one of the maintainers
>>> think it would be better.
>>> ---
>>>  include/linux/kvm_host.h |  5 +----
>>>  mm/swap.c                | 20 +++++++++++++++++++-
>>>  virt/kvm/guest_memfd.c   |  8 ++++++++
>>>  3 files changed, 28 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
>>> index 7788e3625f6d..3ad0719bfc4f 100644
>>> --- a/include/linux/kvm_host.h
>>> +++ b/include/linux/kvm_host.h
>>> @@ -2572,10 +2572,7 @@ long kvm_arch_vcpu_pre_fault_memory(struct kvm_vcpu *vcpu,
>>>  #endif
>>>  
>>>  #ifdef CONFIG_KVM_GMEM_SHARED_MEM
>>> -static inline void kvm_gmem_handle_folio_put(struct folio *folio)
>>> -{
>>> -	WARN_ONCE(1, "A placeholder that shouldn't trigger. Work in progress.");
>>> -}
>>> +void kvm_gmem_handle_folio_put(struct folio *folio);
>>>  #endif
>>>  
>>>  #endif
>>> diff --git a/mm/swap.c b/mm/swap.c
>>> index 241880a46358..27dfd75536c8 100644
>>> --- a/mm/swap.c
>>> +++ b/mm/swap.c
>>> @@ -98,6 +98,24 @@ static void page_cache_release(struct folio *folio)
>>>  		unlock_page_lruvec_irqrestore(lruvec, flags);
>>>  }
>>>  
>>> +#ifdef CONFIG_KVM_GMEM_SHARED_MEM
>>> +static void gmem_folio_put(struct folio *folio)
>>> +{
>>> +#if IS_MODULE(CONFIG_KVM)
>>> +	void (*fn)(struct folio *folio);
>>> +
>>> +	fn = symbol_get(kvm_gmem_handle_folio_put);
>>> +	if (WARN_ON_ONCE(!fn))
>>> +		return;
>>> +
>>> +	fn(folio);
>>> +	symbol_put(kvm_gmem_handle_folio_put);
>>> +#else
>>> +	kvm_gmem_handle_folio_put(folio);
>>> +#endif
>>> +}
>>> +#endif
>
> Yeah, this is not great. The vfio code isn't setting a good example to follow :(
>
>> Sorry about the premature sending earlier!
>> 
>> I was thinking about having a static function pointer in mm/swap.c that
>> will be filled in when KVM is loaded and cleared when KVM is unloaded.
>> 
>> One benefit I see is that it'll avoid the lookup that symbol_get() does
>> on every folio_put(), but some other pinning on KVM would have to be
>> done to prevent KVM from being unloaded in the middle of
>> kvm_gmem_handle_folio_put() call.
>
> Isn't there some "natural" dependency between things such that at the point
> the KVM module is able to unload itself, no guest_memfd areas should be
> existing anymore at that point, and thus also not any pages that would use
> this callback should exist? In that case it would mean there's a memory leak
> if that happens so while we might be trying to avoid calling a function that
> was unleaded, we don't need to try has hard as symbol_get()/put() on every
> invocation, but a racy check would be good enough?
> Or would such a late folio_put() be legitimate to happen because some
> short-lived folio_get() from e.g. a pfn scanner could prolong the page's
> lifetime beyond the KVM module? I'd hope that since you want to make pages
> PGTY_guestmem only in certain points of their lifetime, then maybe this
> should not be possible to happen?
>

IIUC the last refcount on a guest_memfd folio may not be held by
guest_memfd if the folios is already truncated from guest_memfd. The
inode could already be closed. If the inode is closed then the KVM is
free to be unloaded.

This means that someone could hold on to the last refcount, unload KVM,
and then drop the last refcount and have the folio_put() call a
non-existent callback.

If we first check that folio->mapping != NULL and then do
kvm_gmem_handle_folio_put(), then I think what you suggested would work,
since folio->mapping is only NULL when the folio has been disassociated
from the inode.

gmem_folio_put() should probably end with

if (folio_ref_count(folio) == 0)
	__folio_put(folio)

so that if kvm_gmem_handle_folio_put() is done with whatever it needs to
(e.g. complete the conversion) gmem_folio_put() will free the folio.

>> Do you/anyone else see pros/cons either way?
>> 
>>> +
>>>  static void free_typed_folio(struct folio *folio)
>>>  {
>>>  	switch (folio_get_type(folio)) {
>>> @@ -108,7 +126,7 @@ static void free_typed_folio(struct folio *folio)
>>>  #endif
>>>  #ifdef CONFIG_KVM_GMEM_SHARED_MEM
>>>  	case PGTY_guestmem:
>>> -		kvm_gmem_handle_folio_put(folio);
>>> +		gmem_folio_put(folio);
>>>  		return;
>>>  #endif
>>>  	default:
>>> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
>>> index b2aa6bf24d3a..5fc414becae5 100644
>>> --- a/virt/kvm/guest_memfd.c
>>> +++ b/virt/kvm/guest_memfd.c
>>> @@ -13,6 +13,14 @@ struct kvm_gmem {
>>>  	struct list_head entry;
>>>  };
>>>  
>>> +#ifdef CONFIG_KVM_GMEM_SHARED_MEM
>>> +void kvm_gmem_handle_folio_put(struct folio *folio)
>>> +{
>>> +	WARN_ONCE(1, "A placeholder that shouldn't trigger. Work in progress.");
>>> +}
>>> +EXPORT_SYMBOL_GPL(kvm_gmem_handle_folio_put);
>>> +#endif /* CONFIG_KVM_GMEM_SHARED_MEM */
>>> +
>>>  /**
>>>   * folio_file_pfn - like folio_file_page, but return a pfn.
>>>   * @folio: The folio which contains this index.

