Return-Path: <kvm+bounces-72357-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eMteOpF0pWkNBgYAu9opvQ
	(envelope-from <kvm+bounces-72357-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Mar 2026 12:29:21 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 485161D7807
	for <lists+kvm@lfdr.de>; Mon, 02 Mar 2026 12:29:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 693533033E54
	for <lists+kvm@lfdr.de>; Mon,  2 Mar 2026 11:29:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F07D363096;
	Mon,  2 Mar 2026 11:29:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="WPkbthSN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 385BD302753
	for <kvm@vger.kernel.org>; Mon,  2 Mar 2026 11:29:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772450942; cv=none; b=DJ7BXgyt9QmOBUXK8MiAibkzWzgVEQvylslsYD8gzD2LRrlsESVEcavLIv0HLiRh092owIZKjukbaJ/MMN2eYT7TdamOgl0CvBmEcFTVGxzmVdT6Gk/6D1hChm3LrnsnWyyTt8IhU74IngbJ88U1gzuFxlM4Aj1xlruX7eIBozY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772450942; c=relaxed/simple;
	bh=K5ULHdjkJWFTrPH0dXx05JrTB8YMHL8lkvPnUG9C6K8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=U9Y3R/Zt6FVCyItWB+kPyOl7J1gc3QvFOeB2JJH2+eJvsTvunsVRIAn+Nsm7idE7flgex1xiBHmFknHp7dpiS1suChjeenEq3ZSOZMyvtZcQhdoEhmAd0SYjGEzVZRlxjK2oeBESv68tDyQRf3F0YJYXSA+1w67BYfbk3ZnrX64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=WPkbthSN; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4836d541968so4116375e9.2
        for <kvm@vger.kernel.org>; Mon, 02 Mar 2026 03:29:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1772450939; x=1773055739; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1aYNafgGLMp2zV21P8+oK10uFDyPLpaq2eVinuia9OY=;
        b=WPkbthSNzjYrkGU2OaP3MGRaE9A5AuVqltBR4seCVfRAZXAhlC2TmDaxdGFWEk7/FL
         +Ozwiv1gLw5N71yFaR9/B/GpXOPMZk3ECkeWegS0Ge9zjts8Brb4zpbLMhBLOJP+E20V
         Hs4PcY2KtdCjAuGG7dKrzJGniGx+rzz35WjCQUkni89jmc2Q20+6Dl8WLZrwiBm5rPCp
         SfYa99XbWEjSffA4H7rVRo5lYkAAXl6e/v1BIDONDbAJHKl8/1Py2xtyICM4Er+bgT17
         rbpFg9Wp+FpJ0JgiVdfqJX/KzMX6DXLZHg37CTAI3ZkB/Qa7KYzAu+5JhO3A5r53N0MK
         z4mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772450939; x=1773055739;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1aYNafgGLMp2zV21P8+oK10uFDyPLpaq2eVinuia9OY=;
        b=GTZG63FOV2Sonz/M8vG9imMDErfOBHoNTlUEsHv6uOxKRoA5/Rw1iHdAhkZo06ZPJc
         FCq8K7k9rrIiKP3INzW9IQZwjP+qevEzog/FqeMrSzg9aXpDLnIkQFeq7cNbZEm9P90p
         nMxrMr+3gulTvXdjmssYWHRxSynWbzl1aEK8LnoKekOHTYF5MMRZlMGwBurhukICJKGQ
         7XctZ+g76idVYakKjy9cZk9FhbV9v8Ck+SiApPfxVab1GSQFeEHYPajvSCkI87V2kyg4
         uX0nbs3TvkF2T860JRH4HQTJPQHeL3qqStQNygPwT7m56AxHbnQbTDf2kG8lg9oUVEpJ
         b6cA==
X-Gm-Message-State: AOJu0YxkgmubITmziyGYDUEf3bh2ggDqv47ivLwOgiDf+Cy5XIpNcE0g
	/QlnF+/ofd2joVjZciIKgJVTDeo3AnMHEobrxEYCbGXpGdUTb8J1BEVY2Nax86AUyvo=
X-Gm-Gg: ATEYQzw38yYa2PYWuCDUu840qHqzvBNrLIHhImbFBSRZouNXZZMZX8sE6OHS/daN20y
	gal4EpiS7DC8tOM9VG9as56fIrzYFRv4I/QdxvUTW07OnCjILXgylVh9bxQ57OYySd5Uw8HGAp/
	R8lHZnRqHhfd4UtydlWg39f2BM+fHrgMuqlKRFRp+qCYiiEnib2y7BEet1HlL0armTLeN561Zhu
	Z9B4cAUwvOp5C4QHmGKpfXOi8N5pH3NuZ6AebQthrd2wP/gJ3tC/H1Xb6BrPnIVnJbrL3lhjRb4
	iCATgD3gXCyKGZ8pG7RUo8bAgLgI33v3vHPM3XZzOTGLcaZQEFQ0JdPgOEY1e8TQaqybFaspgXE
	x0VdorXG868tAHx8Clvn2Opv/lzzab5OA+qF5zmjqdWTgGw1n7qqQxQEAHK22eka5mJuUofSEoh
	zECsrSqDHAMP7sBa0BEHcJ6z4NuNZBxo6Da/3AWglsz9JrSyrECDrj9qSEoQ==
X-Received: by 2002:a05:600c:1989:b0:46e:43f0:6181 with SMTP id 5b1f17b1804b1-483c9bfbdd5mr117360665e9.7.1772450939437;
        Mon, 02 Mar 2026 03:28:59 -0800 (PST)
Received: from ?IPV6:2001:1a48:8:903:1ed6:4f73:ce38:f9d4? ([2001:1a48:8:903:1ed6:4f73:ce38:f9d4])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-483bfb789efsm210891065e9.2.2026.03.02.03.28.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Mar 2026 03:28:59 -0800 (PST)
Message-ID: <5097ff66-b727-4eac-b845-3bd08d1a0ead@suse.com>
Date: Mon, 2 Mar 2026 12:28:57 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2 2/6] KVM: guest_memfd: Directly allocate folios
 with filemap_alloc_folio()
Content-Language: en-US
To: Ackerley Tng <ackerleytng@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Shuah Khan <shuah@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 seanjc@google.com, rientjes@google.com, rick.p.edgecombe@intel.com,
 yan.y.zhao@intel.com, fvdl@google.com, jthoughton@google.com,
 vannapurve@google.com, shivankg@amd.com, michael.roth@amd.com,
 pratyush@kernel.org, pasha.tatashin@soleen.com, kalyazin@amazon.com,
 tabba@google.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-doc@vger.kernel.org
References: <20260225-gmem-st-blocks-v2-0-87d7098119a9@google.com>
 <20260225-gmem-st-blocks-v2-2-87d7098119a9@google.com>
From: Vlastimil Babka <vbabka@suse.com>
In-Reply-To: <20260225-gmem-st-blocks-v2-2-87d7098119a9@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[suse.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[suse.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[35];
	TAGGED_FROM(0.00)[bounces-72357-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[vbabka@suse.com,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,suse.com:dkim,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,suse.cz:email]
X-Rspamd-Queue-Id: 485161D7807
X-Rspamd-Action: no action

On 2/25/26 08:20, Ackerley Tng wrote:
> __filemap_get_folio_mpol() is parametrized by a bunch of GFP flags, which

                                                           FGP?

> adds complexity for the reader. Since guest_memfd doesn't meaningfully use
> any of the other FGP flags, undo that complexity by directly calling
> filemap_alloc_folio().
> 
> Directly calling filemap_alloc_folio() also allows the order of 0 to be
> explicitly specified, which is the only order guest_memfd supports. This is
> easier to understand, and removes the chance of anything else being able to
> unintentionally influence allocated folio size.

Isn't it determined by FGF_GET_ORDER() so when you pass FGP_LOCK | FGP_CREAT
and no order, it's straigtforward the order will be 0?

But if this helps with patch 4, ok.

> Signed-off-by: Ackerley Tng <ackerleytng@google.com>

Acked-by: Vlastimil Babka <vbabka@suse.cz>

> ---
>  virt/kvm/guest_memfd.c | 51 +++++++++++++++++++++++++++++++++++---------------
>  1 file changed, 36 insertions(+), 15 deletions(-)
> 
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 2df27b6443115..2488d7b8f2b0d 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -107,6 +107,39 @@ static int kvm_gmem_prepare_folio(struct kvm *kvm, struct kvm_memory_slot *slot,
>  	return __kvm_gmem_prepare_folio(kvm, slot, index, folio);
>  }
>  
> +static struct folio *__kvm_gmem_get_folio(struct inode *inode, pgoff_t index)
> +{
> +	/* TODO: Support huge pages. */
> +	struct mempolicy *policy;
> +	struct folio *folio;
> +	gfp_t gfp;
> +	int ret;
> +
> +	/*
> +	 * Fast-path: See if folio is already present in mapping to avoid
> +	 * policy_lookup.
> +	 */
> +	folio = filemap_lock_folio(inode->i_mapping, index);
> +	if (!IS_ERR(folio))
> +		return folio;
> +
> +	gfp = mapping_gfp_mask(inode->i_mapping);
> +
> +	policy = mpol_shared_policy_lookup(&GMEM_I(inode)->policy, index);
> +	folio = filemap_alloc_folio(gfp, 0, policy);
> +	mpol_cond_put(policy);
> +	if (!folio)
> +		return ERR_PTR(-ENOMEM);
> +
> +	ret = filemap_add_folio(inode->i_mapping, folio, index, gfp);
> +	if (ret) {
> +		folio_put(folio);
> +		return ERR_PTR(ret);
> +	}
> +
> +	return folio;
> +}
> +
>  /*
>   * Returns a locked folio on success.  The caller is responsible for
>   * setting the up-to-date flag before the memory is mapped into the guest.
> @@ -118,23 +151,11 @@ static int kvm_gmem_prepare_folio(struct kvm *kvm, struct kvm_memory_slot *slot,
>   */
>  static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index)
>  {
> -	/* TODO: Support huge pages. */
> -	struct mempolicy *policy;
>  	struct folio *folio;
>  
> -	/*
> -	 * Fast-path: See if folio is already present in mapping to avoid
> -	 * policy_lookup.
> -	 */
> -	folio = filemap_lock_folio(inode->i_mapping, index);
> -	if (!IS_ERR(folio))
> -		return folio;
> -
> -	policy = mpol_shared_policy_lookup(&GMEM_I(inode)->policy, index);
> -	folio = __filemap_get_folio_mpol(inode->i_mapping, index,
> -					 FGP_LOCK | FGP_CREAT,
> -					 mapping_gfp_mask(inode->i_mapping), policy);
> -	mpol_cond_put(policy);
> +	do {
> +		folio = __kvm_gmem_get_folio(inode, index);
> +	} while (PTR_ERR(folio) == -EEXIST);
>  
>  	/*
>  	 * External interfaces like kvm_gmem_get_pfn() support dealing
> 


