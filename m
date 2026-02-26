Return-Path: <kvm+bounces-71965-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WPFAIE09oGmrhAQAu9opvQ
	(envelope-from <kvm+bounces-71965-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 13:32:13 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 994DB1A5B92
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 13:32:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 5D3653018066
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 12:31:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8564B3815F6;
	Thu, 26 Feb 2026 12:31:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="vSIQtv1E";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="5N5MjjgV";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="vSIQtv1E";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="5N5MjjgV"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96DE7285056
	for <kvm@vger.kernel.org>; Thu, 26 Feb 2026 12:31:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772109107; cv=none; b=awBTUzWRvtaryzaBZmkY9SWCZQWvAdRiwRIxiSp1y2oKStqUCIHvMY2sNa7sWBf3df6VMvdNm6EgVJZl+3vpGgOoAlhlEcM4B1xVNw8Lzl2VXwE1Z8XpRTB6JWard3KqRuiU8ie5bmthceqcoi1sGY5E3Ww14XhrIo6RtgSyYKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772109107; c=relaxed/simple;
	bh=YKaeuaDYeNuOykIoWYqQiy4RBmNAjGUyUtnfcUBcqZw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PsjDatgDonitQlVz37yY+tDydJVuRNKJ+HBJeyRt5BJqocYOLLtihun6aw0UCpSGYvkMSgGZU6wVsi39lfVBQIKIVmk5G2RDya6J+A/86E1C7g+zgl3V9PkX9rvxLOtU5bjMNEHVOmIajvaRx32GwBiShUwGfyF2T8kIrmDxhKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=vSIQtv1E; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=5N5MjjgV; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=vSIQtv1E; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=5N5MjjgV; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 76C801FA8E;
	Thu, 26 Feb 2026 12:31:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772109104; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=f5WEnpROlC9fgWu+KGiqZFKe3oMMY1tyFav7WdEwLBc=;
	b=vSIQtv1E7WnqPn0ENIfIOEmaSpvOt9Q0fMqP2kUhYl09j9A20zwA4LTFWE8UHxDzOkQuxs
	5B2qs3tj1TPz7CPUGMBtl06RQNtZ92ZkC6lFLSfnUuiYnk4ZSzLIOa3jWTasYwcfhJW6/b
	w4lg49Z+os+DhYIqbt6kXcOHCIGau80=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772109104;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=f5WEnpROlC9fgWu+KGiqZFKe3oMMY1tyFav7WdEwLBc=;
	b=5N5MjjgVLaDn8W3omolC50q8cwfMNo9NPN0KBHCWuKhhRO4JrhUZVuXf1uFNS1Jr0BgPqz
	c5zrlc4TlDcKfIAg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772109104; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=f5WEnpROlC9fgWu+KGiqZFKe3oMMY1tyFav7WdEwLBc=;
	b=vSIQtv1E7WnqPn0ENIfIOEmaSpvOt9Q0fMqP2kUhYl09j9A20zwA4LTFWE8UHxDzOkQuxs
	5B2qs3tj1TPz7CPUGMBtl06RQNtZ92ZkC6lFLSfnUuiYnk4ZSzLIOa3jWTasYwcfhJW6/b
	w4lg49Z+os+DhYIqbt6kXcOHCIGau80=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772109104;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=f5WEnpROlC9fgWu+KGiqZFKe3oMMY1tyFav7WdEwLBc=;
	b=5N5MjjgVLaDn8W3omolC50q8cwfMNo9NPN0KBHCWuKhhRO4JrhUZVuXf1uFNS1Jr0BgPqz
	c5zrlc4TlDcKfIAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6912F3EA62;
	Thu, 26 Feb 2026 12:31:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id /mugGTA9oGlzHQAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 26 Feb 2026 12:31:44 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 2B3A0A0A27; Thu, 26 Feb 2026 13:31:40 +0100 (CET)
Date: Thu, 26 Feb 2026 13:31:40 +0100
From: Jan Kara <jack@suse.cz>
To: Ackerley Tng <ackerleytng@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Shuah Khan <shuah@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	seanjc@google.com, rientjes@google.com, rick.p.edgecombe@intel.com, 
	yan.y.zhao@intel.com, fvdl@google.com, jthoughton@google.com, vannapurve@google.com, 
	shivankg@amd.com, michael.roth@amd.com, pratyush@kernel.org, 
	pasha.tatashin@soleen.com, kalyazin@amazon.com, tabba@google.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH RFC v2 3/6] fs: Add .unaccount_folio callback
Message-ID: <2s33j7wg6ehizvdoz5fggc6kfa5byrs4yg2hk4fvwvfjp7nigo@se7fhyaknqqm>
References: <20260225-gmem-st-blocks-v2-0-87d7098119a9@google.com>
 <20260225-gmem-st-blocks-v2-3-87d7098119a9@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260225-gmem-st-blocks-v2-3-87d7098119a9@google.com>
X-Spam-Score: -3.80
X-Spam-Level: 
X-Spam-Flag: NO
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim,suse.com:email];
	DMARC_NA(0.00)[suse.cz];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71965-lists,kvm=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[35];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[suse.cz:+];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jack@suse.cz,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: 994DB1A5B92
X-Rspamd-Action: no action

On Wed 25-02-26 07:20:38, Ackerley Tng wrote:
> Add .unaccount_folio callback to allow filesystems to do accounting-related
> updates to the inode or struct address_space mapping, when the folio is
> about to be removed from the filemap/page_cache.
> 
> .free_folio cannot be used since .free_folio cannot assume that struct
> address_space mapping still exists.

I agree .free_folio isn't the right place.

> From the name, .invalidate_folio and .release_folio seem suitable, but
> those are meant only to handle freeing of a folio's private
> data. .release_folio is also not called in the truncation path.
 
But this I don't quite understand. .invalidate_folio is called when
the file is truncated (or when the whole inode is being evicted from
memory). Filesystem can do whatever it wishes there, not just free folio
private data. Are you pointing at folio_needs_release() check? But you can
mark your mappings with mapping_release_always() - it's there exactly for
such usecases... Am I missing something?

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

