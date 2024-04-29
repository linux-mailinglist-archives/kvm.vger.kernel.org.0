Return-Path: <kvm+bounces-16153-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 65D148B59D9
	for <lists+kvm@lfdr.de>; Mon, 29 Apr 2024 15:26:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E818C1F22038
	for <lists+kvm@lfdr.de>; Mon, 29 Apr 2024 13:26:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47E8671B24;
	Mon, 29 Apr 2024 13:26:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="2+QkD5zC";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="iAbpU9GK";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="2+QkD5zC";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="iAbpU9GK"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EE916EB62;
	Mon, 29 Apr 2024 13:26:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714397200; cv=none; b=pZx4XSthJFZtqwjLMxAnWsX3QTpSHnLc8iaYu+F7E2yQaXFdJKs0mZ99YHFF7M5fwoWrQTPo9VIZrPobPPLX3MNcDaQ5vuE4WSUe+9QN9S0vXHz3OzV8alG7IoL/kLZY+56x0dQjHKasT0CaEcu9Y6UVqhsVPbb05lU2wgI+OzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714397200; c=relaxed/simple;
	bh=/yemEOTWZKrifYummf8xeeoGIVx96JeK3xoOmxzKSVE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SXEYQAYhKG7wNwRKOSbxzdR/OxvEJhvR6O+pep+zg4kaOu6uQK/0DWBNbBoBYQro50HRu+q2H/SKlpHbw3/ioSxJ3luphSDE7Ol1WUIXtQp9LuLCUC3Bo0+XsOQ5fcDBZDUxgfpR77VgXtEP3uqxbnjYN3r/T8hybKog01DGQyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=2+QkD5zC; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=iAbpU9GK; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=2+QkD5zC; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=iAbpU9GK; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id BFAA6337CC;
	Mon, 29 Apr 2024 13:26:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1714397196; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ZO2lVgZje2mYzQxKUpsp3vuxZMsN6w58TYrHGtC6q9Y=;
	b=2+QkD5zC/ZudRy5tE2LEKB2JO9Z3840uE0QaXtbaKs31We7ZrRj+6tiAJbB9NSqPR8z4/T
	0/RqaGR6APP7GvPFSKf4jegEj8n2GYwQhJWTOV1bpbpHqA6oz7fnUZBVTTY00YH+Q/FI7h
	I7gujP8dd4ZaFkEGXtmAj+WT2thyJY8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1714397196;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ZO2lVgZje2mYzQxKUpsp3vuxZMsN6w58TYrHGtC6q9Y=;
	b=iAbpU9GKQyQirQEeRugOt0YP0woUaFiF9EGyF2aOpd3+3j0nHqBrg4XbPd8viD5ALpJRAu
	oucqixTIHa6e1OCg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=2+QkD5zC;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=iAbpU9GK
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1714397196; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ZO2lVgZje2mYzQxKUpsp3vuxZMsN6w58TYrHGtC6q9Y=;
	b=2+QkD5zC/ZudRy5tE2LEKB2JO9Z3840uE0QaXtbaKs31We7ZrRj+6tiAJbB9NSqPR8z4/T
	0/RqaGR6APP7GvPFSKf4jegEj8n2GYwQhJWTOV1bpbpHqA6oz7fnUZBVTTY00YH+Q/FI7h
	I7gujP8dd4ZaFkEGXtmAj+WT2thyJY8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1714397196;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ZO2lVgZje2mYzQxKUpsp3vuxZMsN6w58TYrHGtC6q9Y=;
	b=iAbpU9GKQyQirQEeRugOt0YP0woUaFiF9EGyF2aOpd3+3j0nHqBrg4XbPd8viD5ALpJRAu
	oucqixTIHa6e1OCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id AA862138A7;
	Mon, 29 Apr 2024 13:26:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id A45OKQygL2YqcgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 29 Apr 2024 13:26:36 +0000
Message-ID: <b820a144-de29-4722-a39d-ef4d86791ca6@suse.cz>
Date: Mon, 29 Apr 2024 15:26:36 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/11] filemap: add FGP_CREAT_ONLY
Content-Language: en-US
To: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, Matthew Wilcox <willy@infradead.org>
Cc: seanjc@google.com, michael.roth@amd.com, isaku.yamahata@intel.com,
 Yosry Ahmed <yosryahmed@google.com>
References: <20240404185034.3184582-1-pbonzini@redhat.com>
 <20240404185034.3184582-5-pbonzini@redhat.com>
 <a4a38f76-d012-4ff4-a2a3-40af9a9a7052@redhat.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 EP+ylKVEKb0Q2A==
In-Reply-To: <a4a38f76-d012-4ff4-a2a3-40af9a9a7052@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Flag: NO
X-Spam-Score: -4.50
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: BFAA6337CC
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.50 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	MX_GOOD(-0.01)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.cz:dkim,infradead.org:email];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.cz:+]

On 4/25/24 7:52 AM, Paolo Bonzini wrote:
> On 4/4/24 20:50, Paolo Bonzini wrote:
>> KVM would like to add a ioctl to encrypt and install a page into private
>> memory (i.e. into a guest_memfd), in preparation for launching an
>> encrypted guest.
>> 
>> This API should be used only once per page (unless there are failures),
>> so we want to rule out the possibility of operating on a page that is
>> already in the guest_memfd's filemap.  Overwriting the page is almost
>> certainly a sign of a bug, so we might as well forbid it.
>> 
>> Therefore, introduce a new flag for __filemap_get_folio (to be passed
>> together with FGP_CREAT) that allows *adding* a new page to the filemap
>> but not returning an existing one.
>> 
>> An alternative possibility would be to force KVM users to initialize
>> the whole filemap in one go, but that is complicated by the fact that
>> the filemap includes pages of different kinds, including some that are
>> per-vCPU rather than per-VM.  Basically the result would be closer to
>> a system call that multiplexes multiple ioctls, than to something
>> cleaner like readv/writev.
>> 
>> Races between callers that pass FGP_CREAT_ONLY are uninteresting to
>> the filemap code: one of the racers wins and one fails with EEXIST,
>> similar to calling open(2) with O_CREAT|O_EXCL.  It doesn't matter to
>> filemap.c if the missing synchronization is in the kernel or in userspace,
>> and in fact it could even be intentional.  (In the case of KVM it turns
>> out that a mutex is taken around these calls for unrelated reasons,
>> so there can be no races.)
>> 
>> Cc: Matthew Wilcox <willy@infradead.org>
>> Cc: Yosry Ahmed <yosryahmed@google.com>
>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> 
> Matthew, are your objections still valid or could I have your ack?

So per the sub-thread on PATCH 09/11, IIUC this is now moot, right?

Vlastimil

> Thanks,
> 
> Paolo
> 
>> ---
>>   include/linux/pagemap.h | 2 ++
>>   mm/filemap.c            | 4 ++++
>>   2 files changed, 6 insertions(+)
>> 
>> diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
>> index f879c1d54da7..a8c0685e8c08 100644
>> --- a/include/linux/pagemap.h
>> +++ b/include/linux/pagemap.h
>> @@ -587,6 +587,7 @@ pgoff_t page_cache_prev_miss(struct address_space *mapping,
>>    * * %FGP_CREAT - If no folio is present then a new folio is allocated,
>>    *   added to the page cache and the VM's LRU list.  The folio is
>>    *   returned locked.
>> + * * %FGP_CREAT_ONLY - Fail if a folio is present
>>    * * %FGP_FOR_MMAP - The caller wants to do its own locking dance if the
>>    *   folio is already in cache.  If the folio was allocated, unlock it
>>    *   before returning so the caller can do the same dance.
>> @@ -607,6 +608,7 @@ typedef unsigned int __bitwise fgf_t;
>>   #define FGP_NOWAIT		((__force fgf_t)0x00000020)
>>   #define FGP_FOR_MMAP		((__force fgf_t)0x00000040)
>>   #define FGP_STABLE		((__force fgf_t)0x00000080)
>> +#define FGP_CREAT_ONLY		((__force fgf_t)0x00000100)
>>   #define FGF_GET_ORDER(fgf)	(((__force unsigned)fgf) >> 26)	/* top 6 bits */
>>   
>>   #define FGP_WRITEBEGIN		(FGP_LOCK | FGP_WRITE | FGP_CREAT | FGP_STABLE)
>> diff --git a/mm/filemap.c b/mm/filemap.c
>> index 7437b2bd75c1..e7440e189ebd 100644
>> --- a/mm/filemap.c
>> +++ b/mm/filemap.c
>> @@ -1863,6 +1863,10 @@ struct folio *__filemap_get_folio(struct address_space *mapping, pgoff_t index,
>>   		folio = NULL;
>>   	if (!folio)
>>   		goto no_page;
>> +	if (fgp_flags & FGP_CREAT_ONLY) {
>> +		folio_put(folio);
>> +		return ERR_PTR(-EEXIST);
>> +	}
>>   
>>   	if (fgp_flags & FGP_LOCK) {
>>   		if (fgp_flags & FGP_NOWAIT) {
> 


