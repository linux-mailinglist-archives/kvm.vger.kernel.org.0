Return-Path: <kvm+bounces-41230-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 16E6BA65185
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 14:43:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1B9B0188628F
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 13:43:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F20A023F296;
	Mon, 17 Mar 2025 13:43:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="qUU8Xunw";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="vT8Ci5J9";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="qUU8Xunw";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="vT8Ci5J9"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 650DF23BD0E
	for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 13:43:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742219013; cv=none; b=rSpHWIHRKB0l2G7p0RFDAZSUMdx0wfJERXyP276xKi45gV49BNz6lPsTIExoMHiH1kep4NfClZPsWOrfJPUz9eOCMT+5D+PF5MQPYHkrTCQhxEPn0YoAvmAtY8yeMTlBTWlksxbd0kv5MvAzLJEwqSaM+PlQ92cMjivEGwIoEZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742219013; c=relaxed/simple;
	bh=IKEqcVsHwD31A2MXhVTPGlvSt9SmEGw8tJfT3YuWBVg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JIuEpseuMWlMEGjzMGhMrwfOHNmkg33dGvihhBBB9R+36CDRmkGNJX6rntlItfxwMJL7VLnhkg1PkNui71aEg4kYLvsL5fEHajw3H54KUV7IyLDgxsrAc/frjjFdbqU3Yk86IBVHbWRV8QcdMwVM/b/RG8w87hptBRWBwb0vTmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=qUU8Xunw; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=vT8Ci5J9; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=qUU8Xunw; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=vT8Ci5J9; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 93E981FE7B;
	Mon, 17 Mar 2025 13:43:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1742219009; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=36UxgCjXd+zUwHnW5IFylHTFmHnIYg203Aq8g5JDPuE=;
	b=qUU8Xunwic24ii7M/gpCd6m2gySVMRB9pYtshEjrzlFi6rFcSFlcQd6ggz+MV9enD1/Rkr
	1xcOWYG/hEPRyFJ0qyYaBwMMaCMonXuJyvO3OktCRcugEOtl/BTydirFl2APwUeSUklLMn
	HW02nzcsVT2VKoI3m6v6hi+Fz4ysaHs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1742219009;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=36UxgCjXd+zUwHnW5IFylHTFmHnIYg203Aq8g5JDPuE=;
	b=vT8Ci5J9El/++OKj0vgk8aT76aPRuRHv3+CDseqSsce3te6AjwGa8f/1csmMiczJA5/hCl
	f+55iIqCfnjhrBBQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1742219009; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=36UxgCjXd+zUwHnW5IFylHTFmHnIYg203Aq8g5JDPuE=;
	b=qUU8Xunwic24ii7M/gpCd6m2gySVMRB9pYtshEjrzlFi6rFcSFlcQd6ggz+MV9enD1/Rkr
	1xcOWYG/hEPRyFJ0qyYaBwMMaCMonXuJyvO3OktCRcugEOtl/BTydirFl2APwUeSUklLMn
	HW02nzcsVT2VKoI3m6v6hi+Fz4ysaHs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1742219009;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=36UxgCjXd+zUwHnW5IFylHTFmHnIYg203Aq8g5JDPuE=;
	b=vT8Ci5J9El/++OKj0vgk8aT76aPRuRHv3+CDseqSsce3te6AjwGa8f/1csmMiczJA5/hCl
	f+55iIqCfnjhrBBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 16F3A132CF;
	Mon, 17 Mar 2025 13:43:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id GX3sBAEn2GfuXwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 17 Mar 2025 13:43:29 +0000
Message-ID: <fe2955d4-c0a2-411a-9e50-a25cc15c75dd@suse.cz>
Date: Mon, 17 Mar 2025 14:43:28 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 03/10] KVM: guest_memfd: Handle
 kvm_gmem_handle_folio_put() for KVM as a module
Content-Language: en-US
To: Ackerley Tng <ackerleytng@google.com>, Fuad Tabba <tabba@google.com>
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
 kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com,
 steven.price@arm.com, quic_eberman@quicinc.com, quic_mnalajal@quicinc.com,
 quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com,
 quic_cvanscha@quicinc.com, quic_pderrin@quicinc.com,
 quic_pheragu@quicinc.com, catalin.marinas@arm.com, james.morse@arm.com,
 yuzenghui@huawei.com, oliver.upton@linux.dev, maz@kernel.org,
 will@kernel.org, qperret@google.com, keirf@google.com, roypat@amazon.co.uk,
 shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, rientjes@google.com,
 jhubbard@nvidia.com, fvdl@google.com, hughd@google.com,
 jthoughton@google.com, peterx@redhat.com
References: <diqzy0x9rqf4.fsf@ackerleytng-ctop.c.googlers.com>
From: Vlastimil Babka <vbabka@suse.cz>
In-Reply-To: <diqzy0x9rqf4.fsf@ackerleytng-ctop.c.googlers.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Level: 
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	TAGGED_RCPT(0.00)[];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RCPT_COUNT_GT_50(0.00)[60];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,kvack.org,redhat.com,kernel.org,ellerman.id.au,brainfault.org,sifive.com,dabbelt.com,eecs.berkeley.edu,google.com,zeniv.linux.org.uk,infradead.org,linux-foundation.org,intel.com,linux.intel.com,digikod.net,maciej.szmigiero.name,amd.com,oracle.com,gmail.com,arm.com,quicinc.com,huawei.com,linux.dev,amazon.co.uk,nvidia.com];
	MIME_TRACE(0.00)[0:+];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_SOME(0.00)[];
	TO_DN_SOME(0.00)[]
X-Spam-Score: -2.80
X-Spam-Flag: NO

On 3/13/25 14:49, Ackerley Tng wrote:
> Fuad Tabba <tabba@google.com> writes:
> 
>> In some architectures, KVM could be defined as a module. If there is a
>> pending folio_put() while KVM is unloaded, the system could crash. By
>> having a helper check for that and call the function only if it's
>> available, we are able to handle that case more gracefully.
>>
>> Signed-off-by: Fuad Tabba <tabba@google.com>
>>
>> ---
>>
>> This patch could be squashed with the previous one of the maintainers
>> think it would be better.
>> ---
>>  include/linux/kvm_host.h |  5 +----
>>  mm/swap.c                | 20 +++++++++++++++++++-
>>  virt/kvm/guest_memfd.c   |  8 ++++++++
>>  3 files changed, 28 insertions(+), 5 deletions(-)
>>
>> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
>> index 7788e3625f6d..3ad0719bfc4f 100644
>> --- a/include/linux/kvm_host.h
>> +++ b/include/linux/kvm_host.h
>> @@ -2572,10 +2572,7 @@ long kvm_arch_vcpu_pre_fault_memory(struct kvm_vcpu *vcpu,
>>  #endif
>>  
>>  #ifdef CONFIG_KVM_GMEM_SHARED_MEM
>> -static inline void kvm_gmem_handle_folio_put(struct folio *folio)
>> -{
>> -	WARN_ONCE(1, "A placeholder that shouldn't trigger. Work in progress.");
>> -}
>> +void kvm_gmem_handle_folio_put(struct folio *folio);
>>  #endif
>>  
>>  #endif
>> diff --git a/mm/swap.c b/mm/swap.c
>> index 241880a46358..27dfd75536c8 100644
>> --- a/mm/swap.c
>> +++ b/mm/swap.c
>> @@ -98,6 +98,24 @@ static void page_cache_release(struct folio *folio)
>>  		unlock_page_lruvec_irqrestore(lruvec, flags);
>>  }
>>  
>> +#ifdef CONFIG_KVM_GMEM_SHARED_MEM
>> +static void gmem_folio_put(struct folio *folio)
>> +{
>> +#if IS_MODULE(CONFIG_KVM)
>> +	void (*fn)(struct folio *folio);
>> +
>> +	fn = symbol_get(kvm_gmem_handle_folio_put);
>> +	if (WARN_ON_ONCE(!fn))
>> +		return;
>> +
>> +	fn(folio);
>> +	symbol_put(kvm_gmem_handle_folio_put);
>> +#else
>> +	kvm_gmem_handle_folio_put(folio);
>> +#endif
>> +}
>> +#endif

Yeah, this is not great. The vfio code isn't setting a good example to follow :(

> Sorry about the premature sending earlier!
> 
> I was thinking about having a static function pointer in mm/swap.c that
> will be filled in when KVM is loaded and cleared when KVM is unloaded.
> 
> One benefit I see is that it'll avoid the lookup that symbol_get() does
> on every folio_put(), but some other pinning on KVM would have to be
> done to prevent KVM from being unloaded in the middle of
> kvm_gmem_handle_folio_put() call.

Isn't there some "natural" dependency between things such that at the point
the KVM module is able to unload itself, no guest_memfd areas should be
existing anymore at that point, and thus also not any pages that would use
this callback should exist? In that case it would mean there's a memory leak
if that happens so while we might be trying to avoid calling a function that
was unleaded, we don't need to try has hard as symbol_get()/put() on every
invocation, but a racy check would be good enough?
Or would such a late folio_put() be legitimate to happen because some
short-lived folio_get() from e.g. a pfn scanner could prolong the page's
lifetime beyond the KVM module? I'd hope that since you want to make pages
PGTY_guestmem only in certain points of their lifetime, then maybe this
should not be possible to happen?

> Do you/anyone else see pros/cons either way?
> 
>> +
>>  static void free_typed_folio(struct folio *folio)
>>  {
>>  	switch (folio_get_type(folio)) {
>> @@ -108,7 +126,7 @@ static void free_typed_folio(struct folio *folio)
>>  #endif
>>  #ifdef CONFIG_KVM_GMEM_SHARED_MEM
>>  	case PGTY_guestmem:
>> -		kvm_gmem_handle_folio_put(folio);
>> +		gmem_folio_put(folio);
>>  		return;
>>  #endif
>>  	default:
>> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
>> index b2aa6bf24d3a..5fc414becae5 100644
>> --- a/virt/kvm/guest_memfd.c
>> +++ b/virt/kvm/guest_memfd.c
>> @@ -13,6 +13,14 @@ struct kvm_gmem {
>>  	struct list_head entry;
>>  };
>>  
>> +#ifdef CONFIG_KVM_GMEM_SHARED_MEM
>> +void kvm_gmem_handle_folio_put(struct folio *folio)
>> +{
>> +	WARN_ONCE(1, "A placeholder that shouldn't trigger. Work in progress.");
>> +}
>> +EXPORT_SYMBOL_GPL(kvm_gmem_handle_folio_put);
>> +#endif /* CONFIG_KVM_GMEM_SHARED_MEM */
>> +
>>  /**
>>   * folio_file_pfn - like folio_file_page, but return a pfn.
>>   * @folio: The folio which contains this index.


