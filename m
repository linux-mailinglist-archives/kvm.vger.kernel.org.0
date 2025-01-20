Return-Path: <kvm+bounces-35987-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E3148A16BB7
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 12:37:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AF0B87A18B4
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 11:37:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD0C71DF268;
	Mon, 20 Jan 2025 11:37:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="QvZyBT4I";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="LgYnM6Bm";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="QvZyBT4I";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="LgYnM6Bm"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FF6010E9;
	Mon, 20 Jan 2025 11:37:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737373048; cv=none; b=BNsHUmUxdkSua8MLdtfYIVr2HJ8BSVBhim/lxvByP4Az6U+N8wRdLJCeYEaMAiFNhQlWJ/9nz9sxfh/qNUnEL8GR4TMgA/+Mmrxo+OrocNXkF3EEMlebhUPT5q/7To/alvfVCgWUA2ivdq0HA30yURZFTOAPG3HW7Il2+BDd5oU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737373048; c=relaxed/simple;
	bh=aqi4IBJO38D5FT+nn7NemeaSZwW16X/ah5q2DnX8IPA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=I8Zbk3aKyX473c6V5v2Sq8dWX8cZgAcOCdSs586bpxqLZyQ52i8ZJB4QDyNYTNJjKvzSIuoxa+LEamO+QTB/Za2toa3kq1cPX9QAa2xmnEGsXJ2s2pTwnOcEuPGG4fW3qMceyAyQvO/wNSSBXbo4sVj9BFYEBUhK3/2pf8h7+7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=QvZyBT4I; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=LgYnM6Bm; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=QvZyBT4I; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=LgYnM6Bm; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A30C52117C;
	Mon, 20 Jan 2025 11:37:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1737373044; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=0heZTp15TjIEO3jgb9UtiZ+J2o7dx4nQ/nK+jvHlbwA=;
	b=QvZyBT4Id1yARWTgeUpnpPWgxlfFqBKgXwLa/CIsufLkbJR7I/n2i5PnU4CmQ1WdUTjHyw
	vhrw5N7LFPuqu47O37ITJm5NoLPIaA8pT2FoZ/OOHxL+y1gTf137f6Oyly2wof59rFsJlT
	h3/TDu8m/AAqtqAx24fbJsXtOCPNDlk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1737373044;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=0heZTp15TjIEO3jgb9UtiZ+J2o7dx4nQ/nK+jvHlbwA=;
	b=LgYnM6BmiY04BcxCk6fZdpAi4zTCDX5WS5l18AJxHonuVY3qKaijYoFx8v+2S5iLQWnJx/
	geC6gXY64lhkOhBQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1737373044; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=0heZTp15TjIEO3jgb9UtiZ+J2o7dx4nQ/nK+jvHlbwA=;
	b=QvZyBT4Id1yARWTgeUpnpPWgxlfFqBKgXwLa/CIsufLkbJR7I/n2i5PnU4CmQ1WdUTjHyw
	vhrw5N7LFPuqu47O37ITJm5NoLPIaA8pT2FoZ/OOHxL+y1gTf137f6Oyly2wof59rFsJlT
	h3/TDu8m/AAqtqAx24fbJsXtOCPNDlk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1737373044;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=0heZTp15TjIEO3jgb9UtiZ+J2o7dx4nQ/nK+jvHlbwA=;
	b=LgYnM6BmiY04BcxCk6fZdpAi4zTCDX5WS5l18AJxHonuVY3qKaijYoFx8v+2S5iLQWnJx/
	geC6gXY64lhkOhBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 275931393E;
	Mon, 20 Jan 2025 11:37:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id XvBGCXQ1jmc0LAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 20 Jan 2025 11:37:24 +0000
Message-ID: <417ca32d-b7f3-4dc9-8d3f-dc0ba67214ad@suse.cz>
Date: Mon, 20 Jan 2025 12:37:23 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v5 06/15] KVM: guest_memfd: Handle final folio_put()
 of guestmem pages
Content-Language: en-US
To: Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org,
 linux-arm-msm@vger.kernel.org, linux-mm@kvack.org
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au,
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
References: <20250117163001.2326672-1-tabba@google.com>
 <20250117163001.2326672-7-tabba@google.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 EP+ylKVEKb0Q2A==
In-Reply-To: <20250117163001.2326672-7-tabba@google.com>
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
	FREEMAIL_CC(0.00)[redhat.com,kernel.org,ellerman.id.au,brainfault.org,sifive.com,dabbelt.com,eecs.berkeley.edu,google.com,zeniv.linux.org.uk,infradead.org,linux-foundation.org,intel.com,linux.intel.com,digikod.net,maciej.szmigiero.name,amd.com,oracle.com,gmail.com,arm.com,quicinc.com,huawei.com,linux.dev,amazon.co.uk,nvidia.com];
	MIME_TRACE(0.00)[0:+];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_SOME(0.00)[];
	TO_DN_SOME(0.00)[]
X-Spam-Score: -2.80
X-Spam-Flag: NO

On 1/17/25 17:29, Fuad Tabba wrote:
> Before transitioning a guest_memfd folio to unshared, thereby
> disallowing access by the host and allowing the hypervisor to
> transition its view of the guest page as private, we need to be
> sure that the host doesn't have any references to the folio.
> 
> This patch introduces a new type for guest_memfd folios, and uses
> that to register a callback that informs the guest_memfd
> subsystem when the last reference is dropped, therefore knowing
> that the host doesn't have any remaining references.
> 
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
> The function kvm_slot_gmem_register_callback() isn't used in this
> series. It will be used later in code that performs unsharing of
> memory. I have tested it with pKVM, based on downstream code [*].
> It's included in this RFC since it demonstrates the plan to
> handle unsharing of private folios.
> 
> [*] https://android-kvm.googlesource.com/linux/+/refs/heads/tabba/guestmem-6.13-v5-pkvm

<snip>

> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -387,6 +387,28 @@ enum folio_mappability {
>  	KVM_GMEM_NONE_MAPPABLE	= 0b11, /* Not mappable, transient state. */
>  };
>  
> +/*
> + * Unregisters the __folio_put() callback from the folio.
> + *
> + * Restores a folio's refcount after all pending references have been released,
> + * and removes the folio type, thereby removing the callback. Now the folio can
> + * be freed normaly once all actual references have been dropped.
> + *
> + * Must be called with the filemap (inode->i_mapping) invalidate_lock held.
> + * Must also have exclusive access to the folio: folio must be either locked, or
> + * gmem holds the only reference.
> + */
> +static void __kvm_gmem_restore_pending_folio(struct folio *folio)
> +{
> +	if (WARN_ON_ONCE(folio_mapped(folio) || !folio_test_guestmem(folio)))
> +		return;
> +
> +	WARN_ON_ONCE(!folio_test_locked(folio) && folio_ref_count(folio) > 1);

Similar to Kirill's objection on the other patch, I think there might be a
speculative refcount increase (i.e. from a pfn scanner) as long as we have
refcount over 1. Probably not a problem here if we want to restore refcount
anyway? But the warning would be spurious.

> +
> +	__folio_clear_guestmem(folio);
> +	folio_ref_add(folio, folio_nr_pages(folio));
> +}
> +
>  /*
>   * Marks the range [start, end) as mappable by both the host and the guest.
>   * Usually called when guest shares memory with the host.
> @@ -400,7 +422,31 @@ static int gmem_set_mappable(struct inode *inode, pgoff_t start, pgoff_t end)
>  
>  	filemap_invalidate_lock(inode->i_mapping);
>  	for (i = start; i < end; i++) {
> +		struct folio *folio = NULL;
> +
> +		/*
> +		 * If the folio is NONE_MAPPABLE, it indicates that it is
> +		 * transitioning to private (GUEST_MAPPABLE). Transition it to
> +		 * shared (ALL_MAPPABLE) immediately, and remove the callback.
> +		 */
> +		if (xa_to_value(xa_load(mappable_offsets, i)) == KVM_GMEM_NONE_MAPPABLE) {
> +			folio = filemap_lock_folio(inode->i_mapping, i);
> +			if (WARN_ON_ONCE(IS_ERR(folio))) {
> +				r = PTR_ERR(folio);
> +				break;
> +			}
> +
> +			if (folio_test_guestmem(folio))
> +				__kvm_gmem_restore_pending_folio(folio);
> +		}
> +
>  		r = xa_err(xa_store(mappable_offsets, i, xval, GFP_KERNEL));
> +
> +		if (folio) {
> +			folio_unlock(folio);
> +			folio_put(folio);
> +		}
> +
>  		if (r)
>  			break;
>  	}
> @@ -473,6 +519,105 @@ static int gmem_clear_mappable(struct inode *inode, pgoff_t start, pgoff_t end)
>  	return r;
>  }
>  
> +/*
> + * Registers a callback to __folio_put(), so that gmem knows that the host does
> + * not have any references to the folio. It does that by setting the folio type
> + * to guestmem.
> + *
> + * Returns 0 if the host doesn't have any references, or -EAGAIN if the host
> + * has references, and the callback has been registered.

Note this comment.

> + *
> + * Must be called with the following locks held:
> + * - filemap (inode->i_mapping) invalidate_lock
> + * - folio lock
> + */
> +static int __gmem_register_callback(struct folio *folio, struct inode *inode, pgoff_t idx)
> +{
> +	struct xarray *mappable_offsets = &kvm_gmem_private(inode)->mappable_offsets;
> +	void *xval_guest = xa_mk_value(KVM_GMEM_GUEST_MAPPABLE);
> +	int refcount;
> +
> +	rwsem_assert_held_write_nolockdep(&inode->i_mapping->invalidate_lock);
> +	WARN_ON_ONCE(!folio_test_locked(folio));
> +
> +	if (folio_mapped(folio) || folio_test_guestmem(folio))
> +		return -EAGAIN;

But here we return -EAGAIN and no callback was registered?

> +
> +	/* Register a callback first. */
> +	__folio_set_guestmem(folio);
> +
> +	/*
> +	 * Check for references after setting the type to guestmem, to guard
> +	 * against potential races with the refcount being decremented later.
> +	 *
> +	 * At least one reference is expected because the folio is locked.
> +	 */
> +
> +	refcount = folio_ref_sub_return(folio, folio_nr_pages(folio));
> +	if (refcount == 1) {
> +		int r;
> +
> +		/* refcount isn't elevated, it's now faultable by the guest. */

Again this seems racy, somebody could have just speculatively increased it.
Maybe we need to freeze here as well?

> +		r = WARN_ON_ONCE(xa_err(xa_store(mappable_offsets, idx, xval_guest, GFP_KERNEL)));
> +		if (!r)
> +			__kvm_gmem_restore_pending_folio(folio);
> +
> +		return r;
> +	}
> +
> +	return -EAGAIN;
> +}
> +
> +int kvm_slot_gmem_register_callback(struct kvm_memory_slot *slot, gfn_t gfn)
> +{
> +	unsigned long pgoff = slot->gmem.pgoff + gfn - slot->base_gfn;
> +	struct inode *inode = file_inode(slot->gmem.file);
> +	struct folio *folio;
> +	int r;
> +
> +	filemap_invalidate_lock(inode->i_mapping);
> +
> +	folio = filemap_lock_folio(inode->i_mapping, pgoff);
> +	if (WARN_ON_ONCE(IS_ERR(folio))) {
> +		r = PTR_ERR(folio);
> +		goto out;
> +	}
> +
> +	r = __gmem_register_callback(folio, inode, pgoff);
> +
> +	folio_unlock(folio);
> +	folio_put(folio);
> +out:
> +	filemap_invalidate_unlock(inode->i_mapping);
> +
> +	return r;
> +}
> +
> +/*
> + * Callback function for __folio_put(), i.e., called when all references by the
> + * host to the folio have been dropped. This allows gmem to transition the state
> + * of the folio to mappable by the guest, and allows the hypervisor to continue
> + * transitioning its state to private, since the host cannot attempt to access
> + * it anymore.
> + */
> +void kvm_gmem_handle_folio_put(struct folio *folio)
> +{
> +	struct xarray *mappable_offsets;
> +	struct inode *inode;
> +	pgoff_t index;
> +	void *xval;
> +
> +	inode = folio->mapping->host;
> +	index = folio->index;
> +	mappable_offsets = &kvm_gmem_private(inode)->mappable_offsets;
> +	xval = xa_mk_value(KVM_GMEM_GUEST_MAPPABLE);
> +
> +	filemap_invalidate_lock(inode->i_mapping);
> +	__kvm_gmem_restore_pending_folio(folio);
> +	WARN_ON_ONCE(xa_err(xa_store(mappable_offsets, index, xval, GFP_KERNEL)));
> +	filemap_invalidate_unlock(inode->i_mapping);
> +}
> +
>  static bool gmem_is_mappable(struct inode *inode, pgoff_t pgoff)
>  {
>  	struct xarray *mappable_offsets = &kvm_gmem_private(inode)->mappable_offsets;


