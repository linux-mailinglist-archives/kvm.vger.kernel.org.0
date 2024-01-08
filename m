Return-Path: <kvm+bounces-5795-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EB361826BC4
	for <lists+kvm@lfdr.de>; Mon,  8 Jan 2024 11:46:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7DA33282FEB
	for <lists+kvm@lfdr.de>; Mon,  8 Jan 2024 10:46:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0343613FFC;
	Mon,  8 Jan 2024 10:45:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="eiEEANnR";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="IV8c+llT";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="eiEEANnR";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="IV8c+llT"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56ED613FFA;
	Mon,  8 Jan 2024 10:45:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 3202A1F799;
	Mon,  8 Jan 2024 10:45:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1704710737; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DUrMQ588PontGGXfiGWoujWrvGIzdjiET4ISNVeyer4=;
	b=eiEEANnRZeJbaI8CjaucatZH8wxLgTMD8Nk1SAQoE9nwmL1h2dUv1nlSVapgm4KTIOeJ2/
	aMrE4dOrgd1/yC96csd/826bfs3cmng0vvAESMigZFOw1zkE56jOHBFH4mnYcyuOEsWu22
	ZBeQB6XKFbe9p8uVFqSSaQ149yYvCzY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1704710737;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DUrMQ588PontGGXfiGWoujWrvGIzdjiET4ISNVeyer4=;
	b=IV8c+llTYz1HJ2A4ILW2O+hnTA2OBYy29S6zX46BbRE/P0eK+LIIY/1uKRHvcMglTAu+a4
	O3kM68xKIg9EAIAA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1704710737; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DUrMQ588PontGGXfiGWoujWrvGIzdjiET4ISNVeyer4=;
	b=eiEEANnRZeJbaI8CjaucatZH8wxLgTMD8Nk1SAQoE9nwmL1h2dUv1nlSVapgm4KTIOeJ2/
	aMrE4dOrgd1/yC96csd/826bfs3cmng0vvAESMigZFOw1zkE56jOHBFH4mnYcyuOEsWu22
	ZBeQB6XKFbe9p8uVFqSSaQ149yYvCzY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1704710737;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DUrMQ588PontGGXfiGWoujWrvGIzdjiET4ISNVeyer4=;
	b=IV8c+llTYz1HJ2A4ILW2O+hnTA2OBYy29S6zX46BbRE/P0eK+LIIY/1uKRHvcMglTAu+a4
	O3kM68xKIg9EAIAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DC53B1392C;
	Mon,  8 Jan 2024 10:45:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Ew51NVDSm2V1QgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 08 Jan 2024 10:45:36 +0000
Message-ID: <f221ad9d-6fc3-466b-bacf-23986b8655f5@suse.cz>
Date: Mon, 8 Jan 2024 11:45:36 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 15/26] x86/sev: Introduce snp leaked pages list
To: Michael Roth <michael.roth@amd.com>, x86@kernel.org
Cc: kvm@vger.kernel.org, linux-coco@lists.linux.dev, linux-mm@kvack.org,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 tglx@linutronix.de, mingo@redhat.com, jroedel@suse.de,
 thomas.lendacky@amd.com, hpa@zytor.com, ardb@kernel.org,
 pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
 jmattson@google.com, luto@kernel.org, dave.hansen@linux.intel.com,
 slp@redhat.com, pgonda@google.com, peterz@infradead.org,
 srinivas.pandruvada@linux.intel.com, rientjes@google.com, tobin@ibm.com,
 bp@alien8.de, kirill@shutemov.name, ak@linux.intel.com, tony.luck@intel.com,
 sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
 jarkko@kernel.org, ashish.kalra@amd.com, nikunj.dadhania@amd.com,
 pankaj.gupta@amd.com, liam.merwick@oracle.com, zhi.a.wang@intel.com
References: <20231230161954.569267-1-michael.roth@amd.com>
 <20231230161954.569267-16-michael.roth@amd.com>
Content-Language: en-US
From: Vlastimil Babka <vbabka@suse.cz>
In-Reply-To: <20231230161954.569267-16-michael.roth@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Level: 
X-Spam-Level: 
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=eiEEANnR;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=IV8c+llT
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-1.51 / 50.00];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 XM_UA_NO_VERSION(0.01)[];
	 SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	 TO_DN_SOME(0.00)[];
	 RCVD_COUNT_THREE(0.00)[3];
	 DKIM_TRACE(0.00)[suse.cz:+];
	 MX_GOOD(-0.01)[];
	 NEURAL_HAM_SHORT(-0.20)[-1.000];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 MID_RHS_MATCH_FROM(0.00)[];
	 BAYES_HAM(-0.01)[51.02%];
	 ARC_NA(0.00)[];
	 R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	 FROM_HAS_DN(0.00)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 NEURAL_HAM_LONG(-1.00)[-1.000];
	 MIME_GOOD(-0.10)[text/plain];
	 DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	 RCPT_COUNT_TWELVE(0.00)[37];
	 DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 RCVD_TLS_ALL(0.00)[]
X-Spam-Score: -1.51
X-Rspamd-Queue-Id: 3202A1F799
X-Spam-Flag: NO

On 12/30/23 17:19, Michael Roth wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> Pages are unsafe to be released back to the page-allocator, if they
> have been transitioned to firmware/guest state and can't be reclaimed
> or transitioned back to hypervisor/shared state. In this case add
> them to an internal leaked pages list to ensure that they are not freed
> or touched/accessed to cause fatal page faults.
> 
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> [mdr: relocate to arch/x86/virt/svm/sev.c]
> Signed-off-by: Michael Roth <michael.roth@amd.com>

Hi, sorry I didn't respond in time to the last mail discussing previous
version in
https://lore.kernel.org/all/8c1fd8da-912a-a9ce-9547-107ba8a450fc@amd.com/
due to upcoming holidays.

I would rather avoid the approach of allocating container objects:
- it's allocating memory when effectively losing memory, a dangerous thing
- are all the callers and their context ok with GFP_KERNEL?
- GFP_KERNEL_ACCOUNT seems wrong, why would we be charging this to the
current process, it's probably not its fault the pages are leaked? Also the
charging can fail?
- given the benefit of having leaked pages on a list is basically just
debugging (i.e. crash dump or drgn inspection) this seems too heavy

I think it would be better and sufficient to use page->lru for order-0 and
head pages, and simply skip tail pages (possibly with adjusted warning
message for that case).

Vlastimil

<snip>

> +
> +void snp_leak_pages(u64 pfn, unsigned int npages)
> +{
> +	struct page *page = pfn_to_page(pfn);
> +	struct leaked_page *leak;
> +
> +	pr_debug("%s: leaking PFN range 0x%llx-0x%llx\n", __func__, pfn, pfn + npages);
> +
> +	spin_lock(&snp_leaked_pages_list_lock);
> +	while (npages--) {
> +		leak = kzalloc(sizeof(*leak), GFP_KERNEL_ACCOUNT);
> +		if (!leak)
> +			goto unlock;

Should we skip the dump_rmpentry() in such a case?

> +		leak->page = page;
> +		list_add_tail(&leak->list, &snp_leaked_pages_list);
> +		dump_rmpentry(pfn);
> +		snp_nr_leaked_pages++;
> +		pfn++;
> +		page++;
> +	}
> +unlock:
> +	spin_unlock(&snp_leaked_pages_list_lock);
> +}
> +EXPORT_SYMBOL_GPL(snp_leak_pages);


