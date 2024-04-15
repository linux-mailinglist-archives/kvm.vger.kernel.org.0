Return-Path: <kvm+bounces-14649-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E10AD8A513D
	for <lists+kvm@lfdr.de>; Mon, 15 Apr 2024 15:27:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 23EAAB23E86
	for <lists+kvm@lfdr.de>; Mon, 15 Apr 2024 13:27:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D27C3745E4;
	Mon, 15 Apr 2024 13:19:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="A8Et9KPF";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="vwPJMc0u";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="rQz+lYAm";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Yj71c2zY"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 270A4745E5
	for <kvm@vger.kernel.org>; Mon, 15 Apr 2024 13:19:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713187183; cv=none; b=SAGCnZVhTNQCIbKkBwjlEdf0bpXBQSZAUY/6ygvLWxS1rodpxc4sBU0svJTmQazeHT2qtsMC5obXzM0ED8N3dHUhK0M/D3wuYpqSeMd05ZVY3+ybvsuL5AS2mn6sH3YLYQrWgYuPv5EF4G211TGK+czeSxLkGi0sc/Vq672Z5Pw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713187183; c=relaxed/simple;
	bh=w6FLPHNjc6uFf/X8w+GapDuJLRLmtoazR5QFzH6PGDs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=p8PBWvkzh94so7nnh3xuk53mrsmVA7JCZ3LkrATGnxx2pqwOsWvvpyM9Fcr3dRDkjr74DDfWkYTT6ME58D+Z9h5p6NAQC4sHaVQsvrISdouhJG9QR3DaUsmw0S4ZQh1MaztGWpnlQmP+F4QaR0nIwsHjZ7TWXjNPvbN+wNKvqP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=A8Et9KPF; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=vwPJMc0u; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=rQz+lYAm; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Yj71c2zY; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 33E1A37146;
	Mon, 15 Apr 2024 13:19:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1713187179; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=/xSAXOT8/SoZivKEskbbl3/MVtPhAdO/Agey4m81M1o=;
	b=A8Et9KPFfmUKOGxkCPABJVcMxVIcSiu32edbjQ8etJUPiVnNKLBJTG74VH1202I6Nu94sd
	KV/u/w1siwsvkAZRQJdp6BD0NToKEsQ/3edNmLa3+YErvqxQOvFb5pJvDUD2hKGhALim81
	YCiZFq++u884y7LYHSCSKjOxZEyFHq0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1713187179;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=/xSAXOT8/SoZivKEskbbl3/MVtPhAdO/Agey4m81M1o=;
	b=vwPJMc0uZeMh82dwCsXcpDnj8gZ77e0K4fR7Ndex2igxOeuDsyABhL/UMZhj+eGtn/krS1
	JFdIuqtbDRcMxMBA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1713187178; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=/xSAXOT8/SoZivKEskbbl3/MVtPhAdO/Agey4m81M1o=;
	b=rQz+lYAmJRJUn7gbWfrj77BDXfSGPs6PSBXq2pDEwgSIm6gh0XTVuCopeLWTksj6jpWWPg
	cuwMEH5kr0rkUtN2etncXOetHZy9XGPwIsL3lldzZEqU7lhqWXapOv2cf5qn6r6riRt+PO
	6Jl8hZ28GOeAHlHKd55Ds648atZgECk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1713187178;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=/xSAXOT8/SoZivKEskbbl3/MVtPhAdO/Agey4m81M1o=;
	b=Yj71c2zYtiE454keoExc7GTArH6OKQjJKXKw9vvzD3bVUdU1/GLN/JZfj4x8hKuH/z47xx
	gQ0LT+8GQUH7cjCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1C1F21368B;
	Mon, 15 Apr 2024 13:19:38 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 9WiDBmopHWZ5EAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 15 Apr 2024 13:19:38 +0000
Message-ID: <804e4ee3-b9f0-4890-9945-db20831745b8@suse.cz>
Date: Mon, 15 Apr 2024 15:19:37 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH gmem 4/6] mm: Introduce AS_INACCESSIBLE for
 encrypted/confidential memory
Content-Language: en-US
To: Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org
Cc: linux-coco@lists.linux.dev, Paolo Bonzini <pbonzini@redhat.com>,
 Sean Christopherson <seanjc@google.com>,
 Isaku Yamahata <isaku.yamahata@linux.intel.com>,
 Xu Yilun <yilun.xu@linux.intel.com>, Binbin Wu <binbin.wu@linux.intel.com>,
 Xiaoyao Li <xiaoyao.li@intel.com>, Matthew Wilcox <willy@infradead.org>
References: <20240329212444.395559-1-michael.roth@amd.com>
 <20240329212444.395559-5-michael.roth@amd.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 EP+ylKVEKb0Q2A==
In-Reply-To: <20240329212444.395559-5-michael.roth@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Flag: NO
X-Spam-Score: -4.29
X-Spam-Level: 
X-Spamd-Result: default: False [-4.29 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	ARC_NA(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCPT_COUNT_SEVEN(0.00)[10];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,infradead.org:email,suse.cz:email,amd.com:email]

On 3/29/24 10:24 PM, Michael Roth wrote:
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
> index e8ac0b32f84d..a7c3f43d1d22 100644
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


