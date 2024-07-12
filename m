Return-Path: <kvm+bounces-21476-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6529192F648
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 09:32:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D6AE01F23752
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 07:32:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E73001422C2;
	Fri, 12 Jul 2024 07:31:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="k78EhUZD";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Jqa4Giwo";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="fgAEA1Ww";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="4dB1TG3N"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52E24142631;
	Fri, 12 Jul 2024 07:31:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720769508; cv=none; b=X5G7wIwBUYH1WEcMvaShGYp3B3Otvl8gn3xuOwTc/Z4nK3AZY2NbNm1u4a8XzKeEaDkHRBsQ6tzMHyxAXr3tgqwdol35ocYfBM9U9AUhiPKU4980NKXekK2imYGLMUM1jZFDmRPGJ7W5zauwzfZ2+wnX1AIqEbNyCnPyNetMRrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720769508; c=relaxed/simple;
	bh=HiR9R3mJ8RDZXDmyVdyHEkCbsFJI0FdbRhc2b1AU9c0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PgbUVWQUyGlgolm3Wk1pIflw6c4kSXZ6Qt34C7onZX3x0WkwZbjLQZIhcYxJ7/zP+hX27vvg36tLz0+CrfQ+jes1AI8fyAbpTkxQ7EMae7E8wVeMuFH6eBQupjYfYj2lS4uhGo5Ax2aXNyovmF4wHpIfCZ7ZoDrq92+k2g/oYV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=k78EhUZD; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Jqa4Giwo; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=fgAEA1Ww; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=4dB1TG3N; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 467151FB6B;
	Fri, 12 Jul 2024 07:31:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1720769504; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=SjZVBzIUaf1khRP/YIvYQuEOJxhVyi3gzEMJbGBqfc0=;
	b=k78EhUZDIung5HU9QU76XWgv4Zf2/0CbK8Ei6WCFaFLMzBXcy/2UCuk7IWKw4JBrqs5DVE
	akMtNHqZjKw2bWJmQOi48fadpsTVkAPjHq64hHDK9iIUW1JYrEZtYozPiZqA/BlCQEM4Co
	FrKyTMVtk7v3yhWc7/LvF8e6fGff5UA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1720769504;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=SjZVBzIUaf1khRP/YIvYQuEOJxhVyi3gzEMJbGBqfc0=;
	b=Jqa4GiwoDVi64v34AcsZ5oPG4crdf/B/iWA4e7savTcsR263Tvs23fFHbiaV07GsJ0xMhL
	N5rawFd/XjjCpFAg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1720769503; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=SjZVBzIUaf1khRP/YIvYQuEOJxhVyi3gzEMJbGBqfc0=;
	b=fgAEA1WwVTuPAWzPNyTPkq5YWnNNkIgYbSSBMB45JZutj+CHzvQ+mN0RgUk6QXPO9I2TwY
	OYSXuHFm1gg7XaxhuvKN3T6FBQ75qAHs2+UOMLrevyIBuXOGr0WFtvl8O43VTrLFQf8IZM
	pfyz3hDMZ9u08uPd0kVin+X31f/lZwM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1720769503;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=SjZVBzIUaf1khRP/YIvYQuEOJxhVyi3gzEMJbGBqfc0=;
	b=4dB1TG3N6zLUNfGJq2a2noiJp0D6cJjBxWJFvOOzeLB59ggaGhS0qFXyEe27bt9vqUAd/I
	xtM4Fd2ml+onfVAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 33FF313686;
	Fri, 12 Jul 2024 07:31:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id edNfDN/bkGalcgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 12 Jul 2024 07:31:43 +0000
Message-ID: <089a7f92-edfe-40c8-a111-f8b3d94e2bfc@suse.cz>
Date: Fri, 12 Jul 2024 09:31:42 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm, virt: merge AS_UNMOVABLE and AS_INACCESSIBLE
Content-Language: en-US
To: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org
Cc: david@redhat.com, seanjc@google.com, michael.roth@amd.com,
 linux-mm@kvack.org
References: <20240711180305.15626-1-pbonzini@redhat.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 EP+ylKVEKb0Q2A==
In-Reply-To: <20240711180305.15626-1-pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Flag: NO
X-Spam-Score: -0.29
X-Spamd-Result: default: False [-0.29 / 50.00];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email,kvack.org:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Level: 

On 7/11/24 8:03 PM, Paolo Bonzini wrote:
> The flags AS_UNMOVABLE and AS_INACCESSIBLE were both added just for guest_memfd;
> AS_UNMOVABLE is already in existing versions of Linux, while AS_INACCESSIBLE was
> acked for inclusion in 6.11.
> 
> But really, they are the same thing: only guest_memfd uses them, at least for
> now, and guest_memfd pages are unmovable because they should not be
> accessed by the CPU.
> 
> So merge them into one; use the AS_INACCESSIBLE name which is more comprehensive.
> At the same time, this fixes an embarrassing bug where AS_INACCESSIBLE was used
> as a bit mask, despite it being just a bit index.
> 
> The bug was mostly benign, becaus AS_INACCESSIBLE's bit representation (1010)
> corresponded to setting AS_UNEVICTABLE (which is already set) and AS_ENOSPC
> (except no async writes can happen on the guest_memfd).  So the AS_INACCESSIBLE
> flag simply had no effect.

Oops, thanks for catching that before becoming mainline.

> Fixes: 1d23040caa8b ("KVM: guest_memfd: Use AS_INACCESSIBLE when creating guest_memfd inode")
> Fixes: c72ceafbd12c ("mm: Introduce AS_INACCESSIBLE for encrypted/confidential memory")
> Cc: linux-mm@kvack.org
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Acked-by: Vlastimil Babka <vbabka@suse.cz>

> ---
>  include/linux/pagemap.h | 14 +++++++-------
>  mm/compaction.c         | 12 ++++++------
>  mm/migrate.c            |  2 +-
>  mm/truncate.c           |  2 +-
>  virt/kvm/guest_memfd.c  |  3 +--
>  5 files changed, 16 insertions(+), 17 deletions(-)
> 
> diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
> index ce7bac8f81da..e05585eda771 100644
> --- a/include/linux/pagemap.h
> +++ b/include/linux/pagemap.h
> @@ -208,8 +208,8 @@ enum mapping_flags {
>  	AS_RELEASE_ALWAYS,	/* Call ->release_folio(), even if no private data */
>  	AS_STABLE_WRITES,	/* must wait for writeback before modifying
>  				   folio contents */
> -	AS_UNMOVABLE,		/* The mapping cannot be moved, ever */
> -	AS_INACCESSIBLE,	/* Do not attempt direct R/W access to the mapping */
> +	AS_INACCESSIBLE,	/* Do not attempt direct R/W access to the mapping,
> +				   including to move the mapping */
>  };
>  
>  /**
> @@ -310,20 +310,20 @@ static inline void mapping_clear_stable_writes(struct address_space *mapping)
>  	clear_bit(AS_STABLE_WRITES, &mapping->flags);
>  }
>  
> -static inline void mapping_set_unmovable(struct address_space *mapping)
> +static inline void mapping_set_inaccessible(struct address_space *mapping)
>  {
>  	/*
> -	 * It's expected unmovable mappings are also unevictable. Compaction
> +	 * It's expected inaccessible mappings are also unevictable. Compaction
>  	 * migrate scanner (isolate_migratepages_block()) relies on this to
>  	 * reduce page locking.
>  	 */
>  	set_bit(AS_UNEVICTABLE, &mapping->flags);
> -	set_bit(AS_UNMOVABLE, &mapping->flags);
> +	set_bit(AS_INACCESSIBLE, &mapping->flags);
>  }
>  
> -static inline bool mapping_unmovable(struct address_space *mapping)
> +static inline bool mapping_inaccessible(struct address_space *mapping)
>  {
> -	return test_bit(AS_UNMOVABLE, &mapping->flags);
> +	return test_bit(AS_INACCESSIBLE, &mapping->flags);
>  }
>  
>  static inline gfp_t mapping_gfp_mask(struct address_space * mapping)
> diff --git a/mm/compaction.c b/mm/compaction.c
> index e731d45befc7..714afd9c6df6 100644
> --- a/mm/compaction.c
> +++ b/mm/compaction.c
> @@ -1172,22 +1172,22 @@ isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
>  		if (((mode & ISOLATE_ASYNC_MIGRATE) && is_dirty) ||
>  		    (mapping && is_unevictable)) {
>  			bool migrate_dirty = true;
> -			bool is_unmovable;
> +			bool is_inaccessible;
>  
>  			/*
>  			 * Only folios without mappings or that have
>  			 * a ->migrate_folio callback are possible to migrate
>  			 * without blocking.
>  			 *
> -			 * Folios from unmovable mappings are not migratable.
> +			 * Folios from inaccessible mappings are not migratable.
>  			 *
>  			 * However, we can be racing with truncation, which can
>  			 * free the mapping that we need to check. Truncation
>  			 * holds the folio lock until after the folio is removed
>  			 * from the page so holding it ourselves is sufficient.
>  			 *
> -			 * To avoid locking the folio just to check unmovable,
> -			 * assume every unmovable folio is also unevictable,
> +			 * To avoid locking the folio just to check inaccessible,
> +			 * assume every inaccessible folio is also unevictable,
>  			 * which is a cheaper test.  If our assumption goes
>  			 * wrong, it's not a correctness bug, just potentially
>  			 * wasted cycles.
> @@ -1200,9 +1200,9 @@ isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
>  				migrate_dirty = !mapping ||
>  						mapping->a_ops->migrate_folio;
>  			}
> -			is_unmovable = mapping && mapping_unmovable(mapping);
> +			is_inaccessible = mapping && mapping_inaccessible(mapping);
>  			folio_unlock(folio);
> -			if (!migrate_dirty || is_unmovable)
> +			if (!migrate_dirty || is_inaccessible)
>  				goto isolate_fail_put;
>  		}
>  
> diff --git a/mm/migrate.c b/mm/migrate.c
> index dd04f578c19c..50b60fb414e9 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -965,7 +965,7 @@ static int move_to_new_folio(struct folio *dst, struct folio *src,
>  
>  		if (!mapping)
>  			rc = migrate_folio(mapping, dst, src, mode);
> -		else if (mapping_unmovable(mapping))
> +		else if (mapping_inaccessible(mapping))
>  			rc = -EOPNOTSUPP;
>  		else if (mapping->a_ops->migrate_folio)
>  			/*
> diff --git a/mm/truncate.c b/mm/truncate.c
> index 60388935086d..581977d2356f 100644
> --- a/mm/truncate.c
> +++ b/mm/truncate.c
> @@ -233,7 +233,7 @@ bool truncate_inode_partial_folio(struct folio *folio, loff_t start, loff_t end)
>  	 * doing a complex calculation here, and then doing the zeroing
>  	 * anyway if the page split fails.
>  	 */
> -	if (!(folio->mapping->flags & AS_INACCESSIBLE))
> +	if (!mapping_inaccessible(folio->mapping))
>  		folio_zero_range(folio, offset, length);
>  
>  	if (folio_has_private(folio))
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 9148b9679bb1..1c509c351261 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -416,11 +416,10 @@ static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
>  	inode->i_private = (void *)(unsigned long)flags;
>  	inode->i_op = &kvm_gmem_iops;
>  	inode->i_mapping->a_ops = &kvm_gmem_aops;
> -	inode->i_mapping->flags |= AS_INACCESSIBLE;
>  	inode->i_mode |= S_IFREG;
>  	inode->i_size = size;
>  	mapping_set_gfp_mask(inode->i_mapping, GFP_HIGHUSER);
> -	mapping_set_unmovable(inode->i_mapping);
> +	mapping_set_inaccessible(inode->i_mapping);
>  	/* Unmovable mappings are supposed to be marked unevictable as well. */
>  	WARN_ON_ONCE(!mapping_unevictable(inode->i_mapping));
>  


