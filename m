Return-Path: <kvm+bounces-3876-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AD16D808CFF
	for <lists+kvm@lfdr.de>; Thu,  7 Dec 2023 17:20:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 286281F2139A
	for <lists+kvm@lfdr.de>; Thu,  7 Dec 2023 16:20:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E18144C92;
	Thu,  7 Dec 2023 16:20:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="xxTXJx3G";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="TGD6PJiW";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="xxTXJx3G";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="TGD6PJiW"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 373E3D4A;
	Thu,  7 Dec 2023 08:20:38 -0800 (PST)
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 49D4A1FB8F;
	Thu,  7 Dec 2023 16:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1701966036; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=R9gDJpilOFtri5BMtSk1bR16VKzmy1EoAMg8XN+4Hs8=;
	b=xxTXJx3GPoOl7SBcxIJqOQY+tneUAmrvullQZsq6Y0AdZHg7xq11tltLJ6XCWQKwQxYcwk
	HT33a4nMU2w3w9MG+rUa8S0IjxZBChoNpEM/Fk61JsRbYhku/KT2ETpZ6RCdOFtcJMjyDz
	IKKnYkKtyOjkwmj0q+ZaOkeGmOSUCXE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1701966036;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=R9gDJpilOFtri5BMtSk1bR16VKzmy1EoAMg8XN+4Hs8=;
	b=TGD6PJiW4rWFAKNCxeLhi1pT83vgP+nsYq+vHBQVED9NbLzgVnBTcoOEz45J5WokkGcnPi
	EpQoh63MFcmvc0Bw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1701966036; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=R9gDJpilOFtri5BMtSk1bR16VKzmy1EoAMg8XN+4Hs8=;
	b=xxTXJx3GPoOl7SBcxIJqOQY+tneUAmrvullQZsq6Y0AdZHg7xq11tltLJ6XCWQKwQxYcwk
	HT33a4nMU2w3w9MG+rUa8S0IjxZBChoNpEM/Fk61JsRbYhku/KT2ETpZ6RCdOFtcJMjyDz
	IKKnYkKtyOjkwmj0q+ZaOkeGmOSUCXE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1701966036;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=R9gDJpilOFtri5BMtSk1bR16VKzmy1EoAMg8XN+4Hs8=;
	b=TGD6PJiW4rWFAKNCxeLhi1pT83vgP+nsYq+vHBQVED9NbLzgVnBTcoOEz45J5WokkGcnPi
	EpQoh63MFcmvc0Bw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E7DE013B6A;
	Thu,  7 Dec 2023 16:20:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id liI5ONPwcWWzXwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Thu, 07 Dec 2023 16:20:35 +0000
Message-ID: <0e84720f-bb52-c77f-e496-40d91e94a4f6@suse.cz>
Date: Thu, 7 Dec 2023 17:20:35 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v10 16/50] x86/sev: Introduce snp leaked pages list
To: Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org
Cc: linux-coco@lists.linux.dev, linux-mm@kvack.org,
 linux-crypto@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
 tglx@linutronix.de, mingo@redhat.com, jroedel@suse.de,
 thomas.lendacky@amd.com, hpa@zytor.com, ardb@kernel.org,
 pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
 jmattson@google.com, luto@kernel.org, dave.hansen@linux.intel.com,
 slp@redhat.com, pgonda@google.com, peterz@infradead.org,
 srinivas.pandruvada@linux.intel.com, rientjes@google.com,
 dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de, kirill@shutemov.name,
 ak@linux.intel.com, tony.luck@intel.com, marcorr@google.com,
 sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
 jarkko@kernel.org, ashish.kalra@amd.com, nikunj.dadhania@amd.com,
 pankaj.gupta@amd.com, liam.merwick@oracle.com, zhi.a.wang@intel.com
References: <20231016132819.1002933-1-michael.roth@amd.com>
 <20231016132819.1002933-17-michael.roth@amd.com>
Content-Language: en-US
From: Vlastimil Babka <vbabka@suse.cz>
In-Reply-To: <20231016132819.1002933-17-michael.roth@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Level: 
X-Spam-Score: -4.30
X-Spam-Flag: NO
X-Spamd-Result: default: False [-3.10 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 BAYES_HAM(-3.00)[100.00%];
	 FROM_HAS_DN(0.00)[];
	 TO_DN_SOME(0.00)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 MIME_GOOD(-0.10)[text/plain];
	 R_RATELIMIT(0.00)[to_ip_from(RL81e5qggtdx371s8ik49ru6xr)];
	 RCVD_COUNT_THREE(0.00)[3];
	 DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	 RCPT_COUNT_TWELVE(0.00)[39];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 RCVD_TLS_ALL(0.00)[];
	 MID_RHS_MATCH_FROM(0.00)[]
Authentication-Results: smtp-out2.suse.de;
	none
X-Spam-Level: 
X-Spam-Score: -3.10

On 10/16/23 15:27, Michael Roth wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> Pages are unsafe to be released back to the page-allocator, if they
> have been transitioned to firmware/guest state and can't be reclaimed
> or transitioned back to hypervisor/shared state. In this case add
> them to an internal leaked pages list to ensure that they are not freed

Note the adding to the list doesn't ensure anything like that. Not dropping
the refcount to zero does. But tracking them might indeed not be bad for
e.g. crashdump investigations so no objection there.

> or touched/accessed to cause fatal page faults.
> 
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> [mdr: relocate to arch/x86/coco/sev/host.c]
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---
>  arch/x86/include/asm/sev-host.h |  3 +++
>  arch/x86/virt/svm/sev.c         | 28 ++++++++++++++++++++++++++++
>  2 files changed, 31 insertions(+)
> 
> diff --git a/arch/x86/include/asm/sev-host.h b/arch/x86/include/asm/sev-host.h
> index 1df989411334..7490a665e78f 100644
> --- a/arch/x86/include/asm/sev-host.h
> +++ b/arch/x86/include/asm/sev-host.h
> @@ -19,6 +19,8 @@ void sev_dump_hva_rmpentry(unsigned long address);
>  int psmash(u64 pfn);
>  int rmp_make_private(u64 pfn, u64 gpa, enum pg_level level, int asid, bool immutable);
>  int rmp_make_shared(u64 pfn, enum pg_level level);
> +void snp_leak_pages(u64 pfn, unsigned int npages);
> +
>  #else
>  static inline int snp_lookup_rmpentry(u64 pfn, bool *assigned, int *level) { return -ENXIO; }
>  static inline void sev_dump_hva_rmpentry(unsigned long address) {}
> @@ -29,6 +31,7 @@ static inline int rmp_make_private(u64 pfn, u64 gpa, enum pg_level level, int as
>  	return -ENXIO;
>  }
>  static inline int rmp_make_shared(u64 pfn, enum pg_level level) { return -ENXIO; }
> +static inline void snp_leak_pages(u64 pfn, unsigned int npages) {}
>  #endif
>  
>  #endif
> diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
> index bf9b97046e05..29a69f4b8cfb 100644
> --- a/arch/x86/virt/svm/sev.c
> +++ b/arch/x86/virt/svm/sev.c
> @@ -59,6 +59,12 @@ struct rmpentry {
>  static struct rmpentry *rmptable_start __ro_after_init;
>  static u64 rmptable_max_pfn __ro_after_init;
>  
> +/* list of pages which are leaked and cannot be reclaimed */
> +static LIST_HEAD(snp_leaked_pages_list);
> +static DEFINE_SPINLOCK(snp_leaked_pages_list_lock);
> +
> +static atomic_long_t snp_nr_leaked_pages = ATOMIC_LONG_INIT(0);
> +
>  #undef pr_fmt
>  #define pr_fmt(fmt)	"SEV-SNP: " fmt
>  
> @@ -518,3 +524,25 @@ int rmp_make_shared(u64 pfn, enum pg_level level)
>  	return rmpupdate(pfn, &val);
>  }
>  EXPORT_SYMBOL_GPL(rmp_make_shared);
> +
> +void snp_leak_pages(u64 pfn, unsigned int npages)
> +{
> +	struct page *page = pfn_to_page(pfn);
> +
> +	pr_debug("%s: leaking PFN range 0x%llx-0x%llx\n", __func__, pfn, pfn + npages);
> +
> +	spin_lock(&snp_leaked_pages_list_lock);
> +	while (npages--) {
> +		/*
> +		 * Reuse the page's buddy list for chaining into the leaked
> +		 * pages list. This page should not be on a free list currently
> +		 * and is also unsafe to be added to a free list.
> +		 */
> +		list_add_tail(&page->buddy_list, &snp_leaked_pages_list);
> +		sev_dump_rmpentry(pfn);
> +		pfn++;

You increment pfn, but not page, which is always pointing to the page of the
initial pfn, so need to do page++ too.
But that assumes it's all order-0 pages (hard to tell for me whether that's
true as we start with a pfn), if there can be compound pages, it would be
best to only add the head page and skip the tail pages - it's not expected
to use page->buddy_list of tail pages.

> +	}
> +	spin_unlock(&snp_leaked_pages_list_lock);
> +	atomic_long_inc(&snp_nr_leaked_pages);
> +}
> +EXPORT_SYMBOL_GPL(snp_leak_pages);


