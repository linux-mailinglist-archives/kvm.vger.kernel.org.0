Return-Path: <kvm+bounces-4044-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 10ECF80CA8B
	for <lists+kvm@lfdr.de>; Mon, 11 Dec 2023 14:08:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C02D0281DA3
	for <lists+kvm@lfdr.de>; Mon, 11 Dec 2023 13:08:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BF2F3D974;
	Mon, 11 Dec 2023 13:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Ty3aJdb8";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="xrT8La9J";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Ty3aJdb8";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="xrT8La9J"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2a07:de40:b251:101:10:150:64:2])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91CD58E;
	Mon, 11 Dec 2023 05:08:40 -0800 (PST)
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 10B761FB8C;
	Mon, 11 Dec 2023 13:08:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1702300119; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SmntiEclpJUrVX6mOseshDU2f41UdhrdCN/1UahG/nA=;
	b=Ty3aJdb89YN1/TyZTmB8friFjALhJaT7wRhSsvXG9LUl+mrKaL87QNQ3077mSbG9T69P5H
	ri9bAd29p7hsQ45pDClzY/hLBn92myJMIK1Hp3L+9FyC4H5C/Dhdbr8H/Xj4ED3MJRisa4
	JX3sdjCD8Ob8PfIeo5Ar0DZintsCFOE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1702300119;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SmntiEclpJUrVX6mOseshDU2f41UdhrdCN/1UahG/nA=;
	b=xrT8La9JMjmb+L1xwUN6brQtsZmB1wfGVHmui83jV19zl80BucV2FEDjO5YHq9LItiU2a8
	ZRd2rfQ8q1vDO6BA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1702300119; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SmntiEclpJUrVX6mOseshDU2f41UdhrdCN/1UahG/nA=;
	b=Ty3aJdb89YN1/TyZTmB8friFjALhJaT7wRhSsvXG9LUl+mrKaL87QNQ3077mSbG9T69P5H
	ri9bAd29p7hsQ45pDClzY/hLBn92myJMIK1Hp3L+9FyC4H5C/Dhdbr8H/Xj4ED3MJRisa4
	JX3sdjCD8Ob8PfIeo5Ar0DZintsCFOE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1702300119;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SmntiEclpJUrVX6mOseshDU2f41UdhrdCN/1UahG/nA=;
	b=xrT8La9JMjmb+L1xwUN6brQtsZmB1wfGVHmui83jV19zl80BucV2FEDjO5YHq9LItiU2a8
	ZRd2rfQ8q1vDO6BA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 138A1133DE;
	Mon, 11 Dec 2023 13:08:38 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 5lRHA9YJd2U8BwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 11 Dec 2023 13:08:38 +0000
Message-ID: <b1b0decf-dc0b-b1bb-db9d-2a00a8c81b0d@suse.cz>
Date: Mon, 11 Dec 2023 14:08:37 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v10 16/50] x86/sev: Introduce snp leaked pages list
To: "Kalra, Ashish" <ashish.kalra@amd.com>,
 Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org
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
 jarkko@kernel.org, nikunj.dadhania@amd.com, pankaj.gupta@amd.com,
 liam.merwick@oracle.com, zhi.a.wang@intel.com
References: <20231016132819.1002933-1-michael.roth@amd.com>
 <20231016132819.1002933-17-michael.roth@amd.com>
 <0e84720f-bb52-c77f-e496-40d91e94a4f6@suse.cz>
 <b54fdac3-9bdf-184e-f3fc-4790a328837c@amd.com>
Content-Language: en-US
From: Vlastimil Babka <vbabka@suse.cz>
In-Reply-To: <b54fdac3-9bdf-184e-f3fc-4790a328837c@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spam-Score: -4.30
Authentication-Results: smtp-out2.suse.de;
	none
X-Spam-Level: 
X-Spam-Score: -4.30
X-Spamd-Result: default: False [-4.30 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 BAYES_HAM(-3.00)[100.00%];
	 FROM_HAS_DN(0.00)[];
	 TO_DN_SOME(0.00)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 NEURAL_HAM_LONG(-1.00)[-1.000];
	 MIME_GOOD(-0.10)[text/plain];
	 R_RATELIMIT(0.00)[to_ip_from(RL81e5qggtdx371s8ik49ru6xr)];
	 RCVD_COUNT_THREE(0.00)[3];
	 DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	 NEURAL_HAM_SHORT(-0.20)[-1.000];
	 RCPT_COUNT_TWELVE(0.00)[39];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 RCVD_TLS_ALL(0.00)[];
	 MID_RHS_MATCH_FROM(0.00)[]
X-Spam-Flag: NO



On 12/8/23 23:10, Kalra, Ashish wrote:
> Hello Vlastimil,
> 
> On 12/7/2023 10:20 AM, Vlastimil Babka wrote:
> 
>>> +
>>> +void snp_leak_pages(u64 pfn, unsigned int npages)
>>> +{
>>> +    struct page *page = pfn_to_page(pfn);
>>> +
>>> +    pr_debug("%s: leaking PFN range 0x%llx-0x%llx\n", __func__, pfn,
>>> pfn + npages);
>>> +
>>> +    spin_lock(&snp_leaked_pages_list_lock);
>>> +    while (npages--) {
>>> +        /*
>>> +         * Reuse the page's buddy list for chaining into the leaked
>>> +         * pages list. This page should not be on a free list currently
>>> +         * and is also unsafe to be added to a free list.
>>> +         */
>>> +        list_add_tail(&page->buddy_list, &snp_leaked_pages_list);
>>> +        sev_dump_rmpentry(pfn);
>>> +        pfn++;
>>
>> You increment pfn, but not page, which is always pointing to the page
>> of the
>> initial pfn, so need to do page++ too.
> 
> Yes, that is a bug and needs to be fixed.
> 
>> But that assumes it's all order-0 pages (hard to tell for me whether
>> that's
>> true as we start with a pfn), if there can be compound pages, it would be
>> best to only add the head page and skip the tail pages - it's not
>> expected
>> to use page->buddy_list of tail pages.
> 
> Can't we use PageCompound() to check if the page is a compound page and
> then use page->compound_head to get and add the head page to leaked
> pages list. I understand the tail pages for compound pages are really
> limited for usage.

Yeah that should work. Need to be careful though, should probably only
process head pages and check if the whole compound_order() is within the
range we are to leak, and then leak the head page and advance the loop
by compound_order(). And if we encounter a tail page, it should probably
be just skipped. I'm looking at snp_reclaim_pages() which seems to
process a number of pages with SEV_CMD_SNP_PAGE_RECLAIM and once any
fails, call snp_leak_pages() on the rest. Could that invoke
snp_leak_pages with the first pfn being a tail page?

> Thanks,
> Ashish

