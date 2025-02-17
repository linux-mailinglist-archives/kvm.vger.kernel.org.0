Return-Path: <kvm+bounces-38365-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D5F16A38191
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2025 12:21:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3681D172112
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2025 11:21:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD6F8217F46;
	Mon, 17 Feb 2025 11:21:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="lbGDprLN";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="hJQygmLk";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="lbGDprLN";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="hJQygmLk"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F421D217F2E
	for <kvm@vger.kernel.org>; Mon, 17 Feb 2025 11:21:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739791265; cv=none; b=WHsilFlLFiXZgdfJzTRmltzqZ/FdtRVIgV3o6oqRydjMeHqsWkhkg2caTWIX5twhKGhQsXPyEb6dXCGr1+99B5G7dxue/4u1CAWgIObcdb4jfNEawjOAGBtbmdwrmREbavCH5AOYt3bama/tKRrvH1K1yhaNSwBuyCAYYprdalA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739791265; c=relaxed/simple;
	bh=StOS5D7zH6/xXeQh/f6q8IsheU1zokztuKbn0xEediw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Jh5rtBGyEqrpVBYAbfWsJgkXWwRw8KYEzsvqp75HZHye4DFqU4LLqBaSdvFf+7ivI0tazmO0Xp4YU8ZiXEeE2KWWr74WtpD9r/yn5Doc6aDOi5bZY5jq3G6D2dRkVYDboeQX0wKyVSMX/IEEKbboODhigZur6dk8VlwtW7ojqmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=fail smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=lbGDprLN; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=hJQygmLk; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=lbGDprLN; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=hJQygmLk; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 1DB0F1F770;
	Mon, 17 Feb 2025 11:21:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1739791261; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=rhh3e6zx3MKYnrC4lTRHJHaRjHgG8pWDLAc6vixpV08=;
	b=lbGDprLNLgx95lYo2O9ziBOclWOxLegD4VZ/knSiZfukhp8cg/pRiRM4y9XiKoO/0Lb+2Y
	QgWQ3sJq6wbw1PfUa37Kl5ei3ge3lrWnTANV8GV3/Eqsa7TWUog6bgkCDHxNwfj8rAHLnR
	KFZOCo2F43ygxY+bQr3mi/od4CInwrs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1739791261;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=rhh3e6zx3MKYnrC4lTRHJHaRjHgG8pWDLAc6vixpV08=;
	b=hJQygmLk3VKRqQzXnbpjkUci/KCovWf+XZHBl9B3ibBwWkUoQyQwXR8dCYjb3URkgcDjUM
	ryakz2Uqizx2EMCg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1739791261; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=rhh3e6zx3MKYnrC4lTRHJHaRjHgG8pWDLAc6vixpV08=;
	b=lbGDprLNLgx95lYo2O9ziBOclWOxLegD4VZ/knSiZfukhp8cg/pRiRM4y9XiKoO/0Lb+2Y
	QgWQ3sJq6wbw1PfUa37Kl5ei3ge3lrWnTANV8GV3/Eqsa7TWUog6bgkCDHxNwfj8rAHLnR
	KFZOCo2F43ygxY+bQr3mi/od4CInwrs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1739791261;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=rhh3e6zx3MKYnrC4lTRHJHaRjHgG8pWDLAc6vixpV08=;
	b=hJQygmLk3VKRqQzXnbpjkUci/KCovWf+XZHBl9B3ibBwWkUoQyQwXR8dCYjb3URkgcDjUM
	ryakz2Uqizx2EMCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9C8AD1379D;
	Mon, 17 Feb 2025 11:21:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id cX3kJZwbs2erYgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 17 Feb 2025 11:21:00 +0000
Message-ID: <5a2f8aaa-1664-48ee-8fb0-3fa80e2e8a23@suse.cz>
Date: Mon, 17 Feb 2025 12:21:00 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 02/11] KVM: guest_memfd: Handle final folio_put() of
 guest_memfd pages
Content-Language: en-US
To: Fuad Tabba <tabba@google.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org,
 pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au,
 anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com,
 aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk,
 brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org,
 xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com,
 jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com,
 yu.c.zhang@linux.intel.com, isaku.yamahata@intel.com, mic@digikod.net,
 vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name,
 david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com,
 liam.merwick@oracle.com, isaku.yamahata@gmail.com,
 kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com,
 steven.price@arm.com, quic_eberman@quicinc.com, quic_mnalajal@quicinc.com,
 quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com,
 quic_cvanscha@quicinc.com, quic_pderrin@quicinc.com,
 quic_pheragu@quicinc.com, catalin.marinas@arm.com, james.morse@arm.com,
 yuzenghui@huawei.com, oliver.upton@linux.dev, maz@kernel.org,
 will@kernel.org, qperret@google.com, keirf@google.com, roypat@amazon.co.uk,
 shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, rientjes@google.com,
 jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, jthoughton@google.com
References: <20250211121128.703390-1-tabba@google.com>
 <20250211121128.703390-3-tabba@google.com>
 <4311493d-c709-485a-a36d-456e5c57c593@suse.cz>
 <CA+EHjTxOmSQA90joVqR90cJ_eTrdvNfmAgtUmopP_ZdcaCPcjQ@mail.gmail.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 EP+ylKVEKb0Q2A==
In-Reply-To: <CA+EHjTxOmSQA90joVqR90cJ_eTrdvNfmAgtUmopP_ZdcaCPcjQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Score: -2.80
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TAGGED_RCPT(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,kvack.org,redhat.com,kernel.org,ellerman.id.au,brainfault.org,sifive.com,dabbelt.com,eecs.berkeley.edu,google.com,zeniv.linux.org.uk,infradead.org,linux-foundation.org,intel.com,linux.intel.com,digikod.net,maciej.szmigiero.name,amd.com,oracle.com,gmail.com,arm.com,quicinc.com,huawei.com,linux.dev,amazon.co.uk,nvidia.com];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_SOME(0.00)[];
	RCPT_COUNT_GT_50(0.00)[60];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO
X-Spam-Level: 

On 2/17/25 11:12, Fuad Tabba wrote:
> Hi Vlastimil,
> 
> On Mon, 17 Feb 2025 at 09:49, Vlastimil Babka <vbabka@suse.cz> wrote:
>>
>> On 2/11/25 13:11, Fuad Tabba wrote:
>> > Before transitioning a guest_memfd folio to unshared, thereby
>> > disallowing access by the host and allowing the hypervisor to
>> > transition its view of the guest page as private, we need to be
>> > sure that the host doesn't have any references to the folio.
>> >
>> > This patch introduces a new type for guest_memfd folios, which
>> > isn't activated in this series but is here as a placeholder and
>> > to facilitate the code in the next patch. This will be used in
>>
>> It's not clear to me how the code in the next page is facilitated as it
>> doesn't use any of this?
> 
> I'm sorry about that, I'm missing the word "series". i.e.,
> 
>> > This patch introduces a new type for guest_memfd folios, which
>> > isn't activated in this series but is here as a placeholder and
>> > to facilitate the code in the next patch *series*.
> 
> I'm referring to this series:
> https://lore.kernel.org/all/20250117163001.2326672-1-tabba@google.com/
> 
>> > the future to register a callback that informs the guest_memfd
>> > subsystem when the last reference is dropped, therefore knowing
>> > that the host doesn't have any remaining references.
>> >
>> > Signed-off-by: Fuad Tabba <tabba@google.com>
>> > ---
>> >  include/linux/kvm_host.h   |  9 +++++++++
>> >  include/linux/page-flags.h | 17 +++++++++++++++++
>> >  mm/debug.c                 |  1 +
>> >  mm/swap.c                  |  9 +++++++++
>> >  virt/kvm/guest_memfd.c     |  7 +++++++
>> >  5 files changed, 43 insertions(+)
>> >
>> > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
>> > index f34f4cfaa513..8b5f28f6efff 100644
>> > --- a/include/linux/kvm_host.h
>> > +++ b/include/linux/kvm_host.h
>> > @@ -2571,4 +2571,13 @@ long kvm_arch_vcpu_pre_fault_memory(struct kvm_vcpu *vcpu,
>> >                                   struct kvm_pre_fault_memory *range);
>> >  #endif
>> >
>> > +#ifdef CONFIG_KVM_GMEM_SHARED_MEM
>> > +void kvm_gmem_handle_folio_put(struct folio *folio);
>> > +#else
>> > +static inline void kvm_gmem_handle_folio_put(struct folio *folio)
>> > +{
>> > +     WARN_ON_ONCE(1);
>> > +}
>>
>> Since the caller is guarded by CONFIG_KVM_GMEM_SHARED_MEM, do we need the
>> CONFIG_KVM_GMEM_SHARED_MEM=n variant at all?
> 
> No. I'll remove it.
> 
>> > +#endif
>> > +
>> >  #endif
>> > diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
>> > index 6dc2494bd002..734afda268ab 100644
>> > --- a/include/linux/page-flags.h
>> > +++ b/include/linux/page-flags.h
>> > @@ -933,6 +933,17 @@ enum pagetype {
>> >       PGTY_slab       = 0xf5,
>> >       PGTY_zsmalloc   = 0xf6,
>> >       PGTY_unaccepted = 0xf7,
>> > +     /*
>> > +      * guestmem folios are used to back VM memory as managed by guest_memfd.
>> > +      * Once the last reference is put, instead of freeing these folios back
>> > +      * to the page allocator, they are returned to guest_memfd.
>> > +      *
>> > +      * For now, guestmem will only be set on these folios as long as they
>> > +      * cannot be mapped to user space ("private state"), with the plan of
>>
>> Might be a bit misleading as I don't think it's set yet as of this series.
>> But I guess we can keep it to avoid another update later.
> 
> You're right, it's not in this series. But as you said, the idea is to
> have the least amount of churn in the core mm code.
> 
>> > +      * always setting that type once typed folios can be mapped to user
>> > +      * space cleanly.
>> > +      */
>> > +     PGTY_guestmem   = 0xf8,
>> >
>> >       PGTY_mapcount_underflow = 0xff
>> >  };
>> > @@ -1082,6 +1093,12 @@ FOLIO_TYPE_OPS(hugetlb, hugetlb)
>> >  FOLIO_TEST_FLAG_FALSE(hugetlb)
>> >  #endif
>> >
>> > +#ifdef CONFIG_KVM_GMEM_SHARED_MEM
>> > +FOLIO_TYPE_OPS(guestmem, guestmem)
>> > +#else
>> > +FOLIO_TEST_FLAG_FALSE(guestmem)
>> > +#endif
>> > +
>> >  PAGE_TYPE_OPS(Zsmalloc, zsmalloc, zsmalloc)
>> >
>> >  /*
>> > diff --git a/mm/debug.c b/mm/debug.c
>> > index 8d2acf432385..08bc42c6cba8 100644
>> > --- a/mm/debug.c
>> > +++ b/mm/debug.c
>> > @@ -56,6 +56,7 @@ static const char *page_type_names[] = {
>> >       DEF_PAGETYPE_NAME(table),
>> >       DEF_PAGETYPE_NAME(buddy),
>> >       DEF_PAGETYPE_NAME(unaccepted),
>> > +     DEF_PAGETYPE_NAME(guestmem),
>> >  };
>> >
>> >  static const char *page_type_name(unsigned int page_type)
>> > diff --git a/mm/swap.c b/mm/swap.c
>> > index 47bc1bb919cc..241880a46358 100644
>> > --- a/mm/swap.c
>> > +++ b/mm/swap.c
>> > @@ -38,6 +38,10 @@
>> >  #include <linux/local_lock.h>
>> >  #include <linux/buffer_head.h>
>> >
>> > +#ifdef CONFIG_KVM_GMEM_SHARED_MEM
>> > +#include <linux/kvm_host.h>
>> > +#endif
>>
>> Do we need to guard the include?
> 
> Yes, otherwise allnoconfig complains due to many of the x86 things it
> drags along if included but KVM isn't configured. I could put it in a
> different header that doesn't have this problem, but I couldn't think
> of a better header for this.

Ok, you can add
Acked-by: Vlastimil Babka <vbabka@suse.cz>



