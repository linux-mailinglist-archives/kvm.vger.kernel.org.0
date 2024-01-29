Return-Path: <kvm+bounces-7337-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4DE2984083A
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 15:26:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7C1741C21972
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 14:26:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F803664A7;
	Mon, 29 Jan 2024 14:26:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="MoS1gs2H";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="lWxaA4vI";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="gfO7Mc1E";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="sd1TWSyq"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1DA865BAC;
	Mon, 29 Jan 2024 14:26:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706538395; cv=none; b=baj6qki1xC561MRX1J086jafdrkRFfE8nHxxfFShHsLLsD1anAgXcHukfc2+IpWEoFT5HSg6rn3otQTTtvy5DIbNU5o7xSbFtnFZPqH93MGVzKTaCkj7ETlk7/XUzeqDfGk7blp9yYQXYrTxZ7umGO0RGme6+p2X0BTHWoBBcgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706538395; c=relaxed/simple;
	bh=1CWG8fGDTE0PFV2DRxwsn6+363/lO1dP/IeyyUt0PoY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rsGd+iSf8nacC2mm6Ysrdp/iF6szX4yypq4LQGADPqYnzY2CoNEAsjwG5Of0myJrVS2pMy74xwsG54edAuCuyUY0CZju19mNxNdbvPt3hJhfTNDSCBNnK7Ym2GdMNvRxpgG5VgoVq8LiXgR/rySXq4p0qPVN73nRgFR8lLxSYOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=MoS1gs2H; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=lWxaA4vI; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=gfO7Mc1E; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=sd1TWSyq; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E012C21BF5;
	Mon, 29 Jan 2024 14:26:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1706538391; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yVCErth3fJSXbSPYKO931WJVaP5CdJG9Rs6XjxdlFvY=;
	b=MoS1gs2Hl4EgJ5NL6qalPr5In9E86rdnlvIznU6e6uzBepu+P+a0IA3lv84Ad2PzWvlMyQ
	hxoXkyxOG2VPmgjftKtmq1GlPP379m4z03COsx7ohuQr/BlvK5JSkoDNk7WLGBSbAbNLFw
	5KJ009zaCwYLAYNjS9CHarYnvFpB7FI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1706538391;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yVCErth3fJSXbSPYKO931WJVaP5CdJG9Rs6XjxdlFvY=;
	b=lWxaA4vI45WlLR5SVl+jZF3+l5yuFu9OW9bU6bJGmfamA8bxRT4JWrN5/sgvElyJ5cHzV1
	wUM/aMXPmstFo6CQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1706538389; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yVCErth3fJSXbSPYKO931WJVaP5CdJG9Rs6XjxdlFvY=;
	b=gfO7Mc1E1PiMODYu+5MLfCH3iGbrIB26IpBO4ToDdMgglzyXCPJCUV6j/pBJwIh28EHLOA
	vso3+m3dnRk3TNOJ/iAPbh9RFv8O4T1LKt1VC0+uiF+y+P1peMVG41CIi4juS3SKyDiOhf
	Hgrn5fDKGnsuNp7qAdgKdQBVKVSG3mQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1706538389;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yVCErth3fJSXbSPYKO931WJVaP5CdJG9Rs6XjxdlFvY=;
	b=sd1TWSyqZeSLloNag5rRyzE3DDd9JvMRR0bf2I1EfXwV4odzaQaVunxZ/10QQB7zUqffYs
	u7U2ysU9swvXdECA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9B73012FF7;
	Mon, 29 Jan 2024 14:26:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id BmKbJZW1t2WqNQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 29 Jan 2024 14:26:29 +0000
Message-ID: <1cc76023-ef3e-4639-9a02-644c5abe918d@suse.cz>
Date: Mon, 29 Jan 2024 15:26:29 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 15/25] x86/sev: Introduce snp leaked pages list
Content-Language: en-US
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
 pankaj.gupta@amd.com, liam.merwick@oracle.com
References: <20240126041126.1927228-1-michael.roth@amd.com>
 <20240126041126.1927228-16-michael.roth@amd.com>
From: Vlastimil Babka <vbabka@suse.cz>
In-Reply-To: <20240126041126.1927228-16-michael.roth@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Authentication-Results: smtp-out1.suse.de;
	none
X-Spamd-Result: default: False [-3.09 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 XM_UA_NO_VERSION(0.01)[];
	 FROM_HAS_DN(0.00)[];
	 TO_DN_SOME(0.00)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 BAYES_HAM(-3.00)[100.00%];
	 MIME_GOOD(-0.10)[text/plain];
	 R_RATELIMIT(0.00)[to_ip_from(RL81e5qggtdx371s8ik49ru6xr)];
	 RCVD_COUNT_THREE(0.00)[3];
	 DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	 RCPT_COUNT_TWELVE(0.00)[36];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 RCVD_TLS_ALL(0.00)[];
	 MID_RHS_MATCH_FROM(0.00)[]
X-Spam-Level: 
X-Spam-Flag: NO
X-Spam-Score: -3.09

On 1/26/24 05:11, Michael Roth wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> Pages are unsafe to be released back to the page-allocator, if they
> have been transitioned to firmware/guest state and can't be reclaimed
> or transitioned back to hypervisor/shared state. In this case add
> them to an internal leaked pages list to ensure that they are not freed
> or touched/accessed to cause fatal page faults.
> 
> Suggested-by: Vlastimil Babka <vbabka@suse.cz>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> [mdr: relocate to arch/x86/virt/svm/sev.c]
> Signed-off-by: Michael Roth <michael.roth@amd.com>

Reviewed-by: Vlastimil Babka <vbabka@suse.cz>

Some minor nitpicks:

> ---
>  arch/x86/include/asm/sev.h |  2 ++
>  arch/x86/virt/svm/sev.c    | 34 ++++++++++++++++++++++++++++++++++
>  2 files changed, 36 insertions(+)
> 
> diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
> index d3ccb7a0c7e9..435ba9bc4510 100644
> --- a/arch/x86/include/asm/sev.h
> +++ b/arch/x86/include/asm/sev.h
> @@ -264,6 +264,7 @@ void snp_dump_hva_rmpentry(unsigned long address);
>  int psmash(u64 pfn);
>  int rmp_make_private(u64 pfn, u64 gpa, enum pg_level level, int asid, bool immutable);
>  int rmp_make_shared(u64 pfn, enum pg_level level);
> +void snp_leak_pages(u64 pfn, unsigned int npages);
>  #else
>  static inline bool snp_probe_rmptable_info(void) { return false; }
>  static inline int snp_lookup_rmpentry(u64 pfn, bool *assigned, int *level) { return -ENODEV; }
> @@ -275,6 +276,7 @@ static inline int rmp_make_private(u64 pfn, u64 gpa, enum pg_level level, int as
>  	return -ENODEV;
>  }
>  static inline int rmp_make_shared(u64 pfn, enum pg_level level) { return -ENODEV; }
> +static inline void snp_leak_pages(u64 pfn, unsigned int npages) {}
>  #endif
>  
>  #endif
> diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
> index 1a13eff78c9d..649ac1bb6b0e 100644
> --- a/arch/x86/virt/svm/sev.c
> +++ b/arch/x86/virt/svm/sev.c
> @@ -65,6 +65,11 @@ static u64 probed_rmp_base, probed_rmp_size;
>  static struct rmpentry *rmptable __ro_after_init;
>  static u64 rmptable_max_pfn __ro_after_init;
>  
> +static LIST_HEAD(snp_leaked_pages_list);
> +static DEFINE_SPINLOCK(snp_leaked_pages_list_lock);
> +
> +static unsigned long snp_nr_leaked_pages;
> +
>  #undef pr_fmt
>  #define pr_fmt(fmt)	"SEV-SNP: " fmt
>  
> @@ -505,3 +510,32 @@ int rmp_make_shared(u64 pfn, enum pg_level level)
>  	return rmpupdate(pfn, &state);
>  }
>  EXPORT_SYMBOL_GPL(rmp_make_shared);
> +
> +void snp_leak_pages(u64 pfn, unsigned int npages)
> +{
> +	struct page *page = pfn_to_page(pfn);
> +
> +	pr_warn("Leaking PFN range 0x%llx-0x%llx\n", pfn, pfn + npages);
> +
> +	spin_lock(&snp_leaked_pages_list_lock);
> +	while (npages--) {
> +		/*
> +		 * Reuse the page's buddy list for chaining into the leaked
> +		 * pages list. This page should not be on a free list currently
> +		 * and is also unsafe to be added to a free list.
> +		 */
> +		if (likely(!PageCompound(page)) ||
> +		    (PageHead(page) && compound_nr(page) <= npages))
> +			/*
> +			 * Skip inserting tail pages of compound page as
> +			 * page->buddy_list of tail pages is not usable.
> +			 */
> +			list_add_tail(&page->buddy_list, &snp_leaked_pages_list);

Even though it's not necessary for correctness, with the comment I'd put the
whole block into { } to make easier to follow. Or just move the comment
above the if() itself?

> +		dump_rmpentry(pfn);
> +		snp_nr_leaked_pages++;
> +		pfn++;
> +		page++;
> +	}
> +	spin_unlock(&snp_leaked_pages_list_lock);
> +}
> +EXPORT_SYMBOL_GPL(snp_leak_pages);


