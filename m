Return-Path: <kvm+bounces-5983-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D5AF5829584
	for <lists+kvm@lfdr.de>; Wed, 10 Jan 2024 10:00:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4A2691F26021
	for <lists+kvm@lfdr.de>; Wed, 10 Jan 2024 09:00:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C2CB3AC1A;
	Wed, 10 Jan 2024 08:59:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="qjBrksVJ";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="RY4cswgs";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="qjBrksVJ";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="RY4cswgs"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11E243A8C6;
	Wed, 10 Jan 2024 08:59:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 1F65B21E17;
	Wed, 10 Jan 2024 08:59:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1704877184; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0GtM+U/m1/8CwPcl+4EBtNE2sj1pzKEolTyiwmoL/Us=;
	b=qjBrksVJ7ayqtT+hHMQ3E32pBal7nh9Y3++2UcNMq4F1aQ3R606xDvDXyS+8yjW8lBsHyI
	zAW5/0Mpb1ig+YsUu+Cz467VrCMZ8P/EL0QCo9fUb6+aYrPjF4yCSvFvSD3XKPexpTJLzA
	+575X+EQKkKnU9eakb6GIjaE4bFTFB4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1704877184;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0GtM+U/m1/8CwPcl+4EBtNE2sj1pzKEolTyiwmoL/Us=;
	b=RY4cswgsDRFXGOkmPW9cy8ROFg9IKH3nV+B1DI5nTja1CXyN+Fuu1V6t+BKZ6incmHbQow
	/wczs5i4KHO89nBA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1704877184; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0GtM+U/m1/8CwPcl+4EBtNE2sj1pzKEolTyiwmoL/Us=;
	b=qjBrksVJ7ayqtT+hHMQ3E32pBal7nh9Y3++2UcNMq4F1aQ3R606xDvDXyS+8yjW8lBsHyI
	zAW5/0Mpb1ig+YsUu+Cz467VrCMZ8P/EL0QCo9fUb6+aYrPjF4yCSvFvSD3XKPexpTJLzA
	+575X+EQKkKnU9eakb6GIjaE4bFTFB4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1704877184;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0GtM+U/m1/8CwPcl+4EBtNE2sj1pzKEolTyiwmoL/Us=;
	b=RY4cswgsDRFXGOkmPW9cy8ROFg9IKH3nV+B1DI5nTja1CXyN+Fuu1V6t+BKZ6incmHbQow
	/wczs5i4KHO89nBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CCB0E13786;
	Wed, 10 Jan 2024 08:59:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id MHKKMX9cnmVXewAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 10 Jan 2024 08:59:43 +0000
Message-ID: <7234513d-45c9-4bda-a537-4278387cedc4@suse.cz>
Date: Wed, 10 Jan 2024 09:59:43 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 15/26] x86/sev: Introduce snp leaked pages list
To: "Kalra, Ashish" <ashish.kalra@amd.com>,
 Michael Roth <michael.roth@amd.com>, x86@kernel.org
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
 jarkko@kernel.org, nikunj.dadhania@amd.com, pankaj.gupta@amd.com,
 liam.merwick@oracle.com, zhi.a.wang@intel.com
References: <20231230161954.569267-1-michael.roth@amd.com>
 <20231230161954.569267-16-michael.roth@amd.com>
 <f221ad9d-6fc3-466b-bacf-23986b8655f5@suse.cz>
 <5cdd2093-b007-404d-96a8-89b3aa6e6e4b@amd.com>
Content-Language: en-US
From: Vlastimil Babka <vbabka@suse.cz>
In-Reply-To: <5cdd2093-b007-404d-96a8-89b3aa6e6e4b@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 1F65B21E17
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=qjBrksVJ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=RY4cswgs
X-Spam-Score: -4.50
X-Spam-Level: 
X-Spam-Flag: NO
X-Spamd-Result: default: False [-4.50 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	 XM_UA_NO_VERSION(0.01)[];
	 FROM_HAS_DN(0.00)[];
	 TO_DN_SOME(0.00)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 BAYES_HAM(-3.00)[100.00%];
	 MIME_GOOD(-0.10)[text/plain];
	 NEURAL_HAM_LONG(-1.00)[-1.000];
	 R_RATELIMIT(0.00)[to_ip_from(RLisu716frudqkg98kczdd9eac)];
	 RCVD_COUNT_THREE(0.00)[3];
	 DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	 DKIM_TRACE(0.00)[suse.cz:+];
	 MX_GOOD(-0.01)[];
	 RCPT_COUNT_TWELVE(0.00)[37];
	 DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 NEURAL_HAM_SHORT(-0.20)[-1.000];
	 RCVD_TLS_ALL(0.00)[];
	 MID_RHS_MATCH_FROM(0.00)[]

On 1/9/24 23:19, Kalra, Ashish wrote:
> Hello Vlastimil,
> 
> On 1/8/2024 4:45 AM, Vlastimil Babka wrote:
>> On 12/30/23 17:19, Michael Roth wrote:
>>> From: Ashish Kalra <ashish.kalra@amd.com>
>>>
>>> Pages are unsafe to be released back to the page-allocator, if they
>>> have been transitioned to firmware/guest state and can't be reclaimed
>>> or transitioned back to hypervisor/shared state. In this case add
>>> them to an internal leaked pages list to ensure that they are not freed
>>> or touched/accessed to cause fatal page faults.
>>>
>>> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
>>> [mdr: relocate to arch/x86/virt/svm/sev.c]
>>> Signed-off-by: Michael Roth <michael.roth@amd.com>
>> Hi, sorry I didn't respond in time to the last mail discussing previous
>> version in
>> https://lore.kernel.org/all/8c1fd8da-912a-a9ce-9547-107ba8a450fc@amd.com/
>> due to upcoming holidays.
>>
>> I would rather avoid the approach of allocating container objects:
>> - it's allocating memory when effectively losing memory, a dangerous thing
>> - are all the callers and their context ok with GFP_KERNEL?
>> - GFP_KERNEL_ACCOUNT seems wrong, why would we be charging this to the
>> current process, it's probably not its fault the pages are leaked? Also the
>> charging can fail?
>> - given the benefit of having leaked pages on a list is basically just
>> debugging (i.e. crash dump or drgn inspection) this seems too heavy
>>
>> I think it would be better and sufficient to use page->lru for order-0 and
>> head pages, and simply skip tail pages (possibly with adjusted warning
>> message for that case).
>>
>> Vlastimil
>>
>> <snip
> 
> Considering the above thoughts, this is updated version of 
> snp_leak_pages(), looking forward to any review comments/feedback you 
> have on the same:
> 
> void snp_leak_pages(u64 pfn, unsigned int npages)
> {
>          struct page *page = pfn_to_page(pfn);
> 
>          pr_debug("%s: leaking PFN range 0x%llx-0x%llx\n", __func__, 
> pfn, pfn + npages);
> 
>          spin_lock(&snp_leaked_pages_list_lock);
>          while (npages--) {
>                  /*
>                   * Reuse the page's buddy list for chaining into the leaked
>                   * pages list. This page should not be on a free list 
> currently
>                   * and is also unsafe to be added to a free list.
>                   */
>                  if ((likely(!PageCompound(page))) || (PageCompound(page) &&
>                      !PageTail(page) && compound_head(page) == page))

This is unnecessarily paranoid wrt that compound_head(page) test, but OTOH
doesn't handle the weird case when we're leaking less than whole compound
page (if that can even happen). So I'd suggest:

while (npages) {

  if ((likely(!PageCompound(page))) || (PageHead(page) && compound_nr(page)
<= npages))
	list_add_tail(&page->buddy_list, ...)
  }

  ... (no change from yours)

  npages--;
}

(or an equivalent for()) perhaps

>                          /*
>                           * Skip inserting tail pages of compound page as
>                           * page->buddy_list of tail pages is not usable.
>                           */
>                          list_add_tail(&page->buddy_list, 
> &snp_leaked_pages_list);
>                  sev_dump_rmpentry(pfn);
>                  snp_nr_leaked_pages++;
>                  pfn++;
>                  page++;
>          }
>          spin_unlock(&snp_leaked_pages_list_lock);
> }
> 
> Thanks, Ashish
> 


