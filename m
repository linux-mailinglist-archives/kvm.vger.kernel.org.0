Return-Path: <kvm+bounces-16151-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 23F9E8B59A2
	for <lists+kvm@lfdr.de>; Mon, 29 Apr 2024 15:16:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 58411B25A65
	for <lists+kvm@lfdr.de>; Mon, 29 Apr 2024 13:14:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B57A55C2E;
	Mon, 29 Apr 2024 13:14:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="fpeWq1Hg";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="ji35ZKLT";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="uEt1mUaw";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="fYnllc6C"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E391C127;
	Mon, 29 Apr 2024 13:14:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714396475; cv=none; b=EfYsjgQaehivIwtsQw+/ZXPnvobFfLbmOOhsClyjWnx5cYO17zz/ItrgujrmgyStgH9PZ81/ANpH4YEgGCgOvNE5GcJCMU9iVITgZtcU3RWFVhZ254fe6Lu7D2HeZU9OnEgaQ3wE4iQ7gDnMjdmtLNawFc59ZyiWDDpSZLc1txY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714396475; c=relaxed/simple;
	bh=n0+8LITiEBNTweMfiZbJDI3PDBBblTQm/VyjqtdpaUc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=vAfgmsgnOlY8lS8gbUU0GQYBXmX9bYtIShNZ/UrCPjdfxIoMTSbWsLPeQxHmjmJKGFA/LUN2zL9uONT9USHOo4x5OawNJdnFuzgOefOIQY7S7vHvP4qTUlIynVnXztuQZ2JMpLzgh8z2AGB9iUH/JSJ62Y3kCkvtBiSkJQY9cYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=fpeWq1Hg; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=ji35ZKLT; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=uEt1mUaw; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=fYnllc6C; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id EA809337B0;
	Mon, 29 Apr 2024 13:14:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1714396470; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ZLHKvl4iebc937hsJX+j20dIQJbExB9vYsG/6MMQS2U=;
	b=fpeWq1HgWBczmn2Sxa8ZQKG8UVKttaWGhnkm867gbi8JPYoIxRTNIQ5GieIk0tzWmbTppj
	splp/Iupnwr2+3p16ql2SUq0hB+nibFhMDICad1WRsVExj8d2kRV8XqLjGqtY6Ib9JSogr
	tzLZHHGlfyxI/XCZ7j9uuq3G0R6uAtc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1714396470;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ZLHKvl4iebc937hsJX+j20dIQJbExB9vYsG/6MMQS2U=;
	b=ji35ZKLTHMN6Qu7isi/mrlwn0JTTJOpnqUGNtjSAx2mhEWLKcu+e90r3Su/vS/fXlnTQOU
	H2EX0rzXamei3gCg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=uEt1mUaw;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=fYnllc6C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1714396468; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ZLHKvl4iebc937hsJX+j20dIQJbExB9vYsG/6MMQS2U=;
	b=uEt1mUaw6HtVYaqIBrDr7b1QrFuc77BO7+zxIGkuY2FA8fSRT+9hhnWnQvY6fvw6+TVK5N
	RzRxgR8V+72oo/umNxY7sAq0CKHp+xEfST0ctSnmd3EX5dpzAPBmB0HuW6WB5/jT/iu5dL
	LBaPgV7wOXmNWaN2YtP3ufAqaD17dnM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1714396468;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ZLHKvl4iebc937hsJX+j20dIQJbExB9vYsG/6MMQS2U=;
	b=fYnllc6Cpv6iX8qtwt4hOrS1qfd8eWiBuox63glFnBMvr32/K2T6NVN5VHizRaPEdrP330
	XTHSYOEVTo7rp8Ag==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D7B0B138A7;
	Mon, 29 Apr 2024 13:14:28 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 6bxMNDSdL2YtbQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 29 Apr 2024 13:14:28 +0000
Message-ID: <9e906b0e-e030-4d35-97ae-1ec7ae522265@suse.cz>
Date: Mon, 29 Apr 2024 15:14:28 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/11] mm: Introduce AS_INACCESSIBLE for
 encrypted/confidential memory
To: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org
Cc: seanjc@google.com, michael.roth@amd.com, isaku.yamahata@intel.com,
 Matthew Wilcox <willy@infradead.org>
References: <20240404185034.3184582-1-pbonzini@redhat.com>
 <20240404185034.3184582-2-pbonzini@redhat.com>
Content-Language: en-US
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 EP+ylKVEKb0Q2A==
In-Reply-To: <20240404185034.3184582-2-pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Flag: NO
X-Spam-Score: -4.50
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: EA809337B0
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
	RCPT_COUNT_SEVEN(0.00)[7];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.cz:+]

On 4/4/24 8:50 PM, Paolo Bonzini wrote:
> From: Michael Roth <michael.roth@amd.com>
> 
> filemap users like guest_memfd may use page cache pages to
> allocate/manage memory that is only intended to be accessed by guests
> via hardware protections like encryption. Writes to memory of this sort
> in common paths like truncation may cause unexpected behavior such
> writing garbage instead of zeros when attempting to zero pages, or
> worse, triggering hardware protections that are considered fatal as far
> as the kernel is concerned.
> 
> Introduce a new address_space flag, AS_INACCESSIBLE, and use this
> initially to prevent zero'ing of pages during truncation, with the
> understanding that it is up to the owner of the mapping to handle this
> specially if needed.
> 
> Link: https://lore.kernel.org/lkml/ZR9LYhpxTaTk6PJX@google.com/
> Cc: Matthew Wilcox <willy@infradead.org>
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> Message-ID: <20240329212444.395559-5-michael.roth@amd.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

I've replied on Michael's original series thread but that was after this one
was already posted, and I missed it due to smaller Cc list, e.g. linux-mm
not being Cc... so let me repeat here:


Hm somehow it seems like a rather blunt solution to a fairly specific issue
on one hand, and on the other hand I'm not sure whether there are other
places (not yet triggered) that should now take into account the flag to
keep its promise. But as long as it gets the job done, and can be replaced
later with something better...

Acked-by: Vlastimil Babka <vbabka@suse.cz>


> ---
>  include/linux/pagemap.h | 1 +
>  mm/truncate.c           | 3 ++-
>  2 files changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
> index 2df35e65557d..f879c1d54da7 100644
> --- a/include/linux/pagemap.h
> +++ b/include/linux/pagemap.h
> @@ -207,6 +207,7 @@ enum mapping_flags {
>  	AS_STABLE_WRITES,	/* must wait for writeback before modifying
>  				   folio contents */
>  	AS_UNMOVABLE,		/* The mapping cannot be moved, ever */
> +	AS_INACCESSIBLE,	/* Do not attempt direct R/W access to the mapping */
>  };
>  
>  /**
> diff --git a/mm/truncate.c b/mm/truncate.c
> index 725b150e47ac..c501338c7ebd 100644
> --- a/mm/truncate.c
> +++ b/mm/truncate.c
> @@ -233,7 +233,8 @@ bool truncate_inode_partial_folio(struct folio *folio, loff_t start, loff_t end)
>  	 * doing a complex calculation here, and then doing the zeroing
>  	 * anyway if the page split fails.
>  	 */
> -	folio_zero_range(folio, offset, length);
> +	if (!(folio->mapping->flags & AS_INACCESSIBLE))
> +		folio_zero_range(folio, offset, length);
>  
>  	if (folio_has_private(folio))
>  		folio_invalidate(folio, offset, length);


