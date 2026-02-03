Return-Path: <kvm+bounces-70028-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SB4/Hss1gmnZQgMAu9opvQ
	(envelope-from <kvm+bounces-70028-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 18:52:11 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0FBAADD22F
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 18:52:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 629AB311A24F
	for <lists+kvm@lfdr.de>; Tue,  3 Feb 2026 17:45:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9AB6F361DB1;
	Tue,  3 Feb 2026 17:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FY9s5nF7";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="PqcnK/Y+"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A4FF35CB9C
	for <kvm@vger.kernel.org>; Tue,  3 Feb 2026 17:45:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770140709; cv=none; b=lqK1OdwlPeygEKDzuaUd0Lq8suO+6KjukSt5+DFY2LG0j7GlcUKX1MQ5FyNYXbkM/N/oC45vc0L2AmgmpC7bmwATKFWq6vkEJ6zD+MXSAav7mxmQiWLENdeJk4jZJjjOYZyPUJF7C3p9lVLREwdwbJ6uasHsmTZRHG3dTq42h/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770140709; c=relaxed/simple;
	bh=9t1fUsY8nDNXTD2RVVJumI8FxVBqWXScBzfMykEVp8U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C05iUChmhfGwI9Fz590p9SV3qhf+WR3lb/pvvk9AifVH9rTv+PiauncbhmVrzcAfXIkIYyseEyMS68Zes1bbkISOhadsMrAXZfz8SgI2Vzd4pigmdYCD9Gp9W6S6Zd38fGW2lBkVV8P6WlmIbFgY+QHKM8I8WR0V6OL3j2sW60U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FY9s5nF7; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=PqcnK/Y+; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770140707;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tlFrmjhVpayg8OBXKv6tROkmIHF/xjSd9Muscu3Dpsk=;
	b=FY9s5nF7qrQQ/SpoSiAXwucg4M13UD90jHocFZj5mswY4pGFRBXGrg1GnAO2GSRLsuyqkJ
	kTtEmHKd8u0aiiN8c/g9KoTNpoz/YQ4rCkLbgVgzFsxNIoG+DnfLZGOdDi3Sz0T00h9S7i
	3IPoeAJKD4e/hqVqsYBMWnBLLiCrhV4=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-643-DT3XR51pPKyW8BD2GXpaVA-1; Tue, 03 Feb 2026 12:45:06 -0500
X-MC-Unique: DT3XR51pPKyW8BD2GXpaVA-1
X-Mimecast-MFC-AGG-ID: DT3XR51pPKyW8BD2GXpaVA_1770140706
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-50335bd75bdso57858391cf.0
        for <kvm@vger.kernel.org>; Tue, 03 Feb 2026 09:45:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1770140706; x=1770745506; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=tlFrmjhVpayg8OBXKv6tROkmIHF/xjSd9Muscu3Dpsk=;
        b=PqcnK/Y+P5srIVqAQL7NO12bhlJArUFo761gJdPAvEMeFT1OIlkBEBFQhZEyeWRd1U
         niEe6xS/8u9v6c1GNBP7aTffvDSl4ChTot+Hi7NCKKV3vNCGFqWoNYahCQK4rq13GlgV
         nBe06UBjkDeyPnO38jwUbMRZB1CfWOyRhpUrVZv9LDG/1MNawhLIo4Fg/Wnq+FFus/+L
         DVELzX+u6Y8YMgd7YA2ve77CaTx9RLX6dbCg9OHF8HUSXerWSi+gq+MWHz8U1ymXtTlP
         jIDGvo7VKa7U6HKu5C5mxxfIQ3cATWJ486uuJq8BN3ctiWY5tQWSTZD4KIN0OwxqWOFP
         HUPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770140706; x=1770745506;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tlFrmjhVpayg8OBXKv6tROkmIHF/xjSd9Muscu3Dpsk=;
        b=A8ru2DlbnOj3KWLcej3geZw+Oa0WxOGjUaVWfZ+mwXEwkF2afDfJVAx7JC0Kp+OXGn
         TFUvvwIW8L7LL20hhYE3ruIwDzbo1ewPqVG2zerMFC117OSmD0LKkdDP7zdcXySGf5Ld
         zMq7zfi6cWqiSEsco4eTaZDU+LTFnOOOUxazEWc7QxuiATKcCE0gOGPKzvYcrSiEcbvF
         MXNe9px4B0TUYc6Mf/6HAk+YbsDEmoEDb9Jfxoe3T4MtZEun4LvpgfZbBrutFPqgKELD
         rA+77QQRVVhlJWzZPp9FVHzBmW9x0PM4AL9wAmZfYqoFmHpoHcpqGZkb0PlJrR3fhFan
         EHhg==
X-Forwarded-Encrypted: i=1; AJvYcCVVoabD41ts8P59KrAWofG2PfrJ7aKkfKpiMmNM8mSZo6qHKK+DKIM44zQMSYnTDUKmdHM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy7cDc+04IV+qvm1hOQxxTk6LMJtsUE/QLmeh/NJDFtj7vp/K7b
	Lou8ee58EA92x1xdI4TPdCwsZxkx3xwGrsDubgZwvaSTJYrHf6B5S2Uq9OovRjmRz1SP5iCOl+R
	mkQUci31VcXphKvmTsjW+KW25IJ4GVUNAvu6P9w+xffRQsc7nwOuDsg==
X-Gm-Gg: AZuq6aIXSVVpv3o3kAk+cM5oEyTKeRlhRW81C1AgpnHA6aY7CsjGf+4te1sv668Gg1i
	gtF0EZh4a3uK70UBHDrbJz0TYoe8f+HQZBAig8iU01umg8+SyTIpkygsRPoYzkHg9NdsM5oC3RP
	/zXCVsQ1EJXwZX4bbE5KvwqmldEmd5418IWWEGuheyeVGKNrC/EXbtrG6JqP90qJEe0VHEpyZ6t
	XwsoDKf23fQ6ysLawChN0yCCtdghO82gaBBzY7JR2PClfqaknhZhwQmtF+47SnkWL41LQBrw3K5
	eoJTx5DcU/n+sXYC5JAE441ngbpF9ER/+Fm7xZauCpawU4FD5ebDKPQLa9dRXqFArXLvy0bXXhU
	4V78=
X-Received: by 2002:a05:622a:1ba3:b0:501:181d:f71e with SMTP id d75a77b69052e-5061c18ec18mr1176551cf.38.1770140705451;
        Tue, 03 Feb 2026 09:45:05 -0800 (PST)
X-Received: by 2002:a05:622a:1ba3:b0:501:181d:f71e with SMTP id d75a77b69052e-5061c18ec18mr1175931cf.38.1770140704851;
        Tue, 03 Feb 2026 09:45:04 -0800 (PST)
Received: from x1.local ([142.188.210.156])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5061c1f7764sm401081cf.23.2026.02.03.09.45.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Feb 2026 09:45:04 -0800 (PST)
Date: Tue, 3 Feb 2026 12:45:02 -0500
From: Peter Xu <peterx@redhat.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org, Andrea Arcangeli <aarcange@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@redhat.com>,
	Hugh Dickins <hughd@google.com>,
	James Houghton <jthoughton@google.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
	Nikita Kalyazin <kalyazin@amazon.com>,
	Oscar Salvador <osalvador@suse.de>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH RFC 01/17] userfaultfd: introduce
 mfill_copy_folio_locked() helper
Message-ID: <aYI0HmP-XZNBI-gb@x1.local>
References: <20260127192936.1250096-1-rppt@kernel.org>
 <20260127192936.1250096-2-rppt@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260127192936.1250096-2-rppt@kernel.org>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70028-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	RCPT_COUNT_TWELVE(0.00)[23];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[peterx@redhat.com,kvm@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.999];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[x1.local:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 0FBAADD22F
X-Rspamd-Action: no action

On Tue, Jan 27, 2026 at 09:29:20PM +0200, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> Split copying of data when locks held from mfill_atomic_pte_copy() into
> a helper function mfill_copy_folio_locked().
> 
> This makes improves code readability and makes complex
> mfill_atomic_pte_copy() function easier to comprehend.
> 
> No functional change.
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

The movement looks all fine,

Acked-by: Peter Xu <peterx@redhat.com>

Just one pure question to ask.

> ---
>  mm/userfaultfd.c | 59 ++++++++++++++++++++++++++++--------------------
>  1 file changed, 35 insertions(+), 24 deletions(-)
> 
> diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> index e6dfd5f28acd..a0885d543f22 100644
> --- a/mm/userfaultfd.c
> +++ b/mm/userfaultfd.c
> @@ -238,6 +238,40 @@ int mfill_atomic_install_pte(pmd_t *dst_pmd,
>  	return ret;
>  }
>  
> +static int mfill_copy_folio_locked(struct folio *folio, unsigned long src_addr)
> +{
> +	void *kaddr;
> +	int ret;
> +
> +	kaddr = kmap_local_folio(folio, 0);
> +	/*
> +	 * The read mmap_lock is held here.  Despite the
> +	 * mmap_lock being read recursive a deadlock is still
> +	 * possible if a writer has taken a lock.  For example:
> +	 *
> +	 * process A thread 1 takes read lock on own mmap_lock
> +	 * process A thread 2 calls mmap, blocks taking write lock
> +	 * process B thread 1 takes page fault, read lock on own mmap lock
> +	 * process B thread 2 calls mmap, blocks taking write lock
> +	 * process A thread 1 blocks taking read lock on process B
> +	 * process B thread 1 blocks taking read lock on process A

While moving, I wonder if we need this complex use case to describe the
deadlock.  Shouldn't this already happen with 1 process only?

  process A thread 1 takes read lock (e.g. reaching here but
                     before copy_from_user)
  process A thread 2 calls mmap, blocks taking write lock
  process A thread 1 goes on copy_from_user(), trigger page fault,
                     then tries to re-take the read lock

IIUC above should already cause deadlock when rwsem prioritize the write
lock here.

> +	 *
> +	 * Disable page faults to prevent potential deadlock
> +	 * and retry the copy outside the mmap_lock.
> +	 */
> +	pagefault_disable();
> +	ret = copy_from_user(kaddr, (const void __user *) src_addr,
> +			     PAGE_SIZE);
> +	pagefault_enable();
> +	kunmap_local(kaddr);
> +
> +	if (ret)
> +		return -EFAULT;
> +
> +	flush_dcache_folio(folio);
> +	return ret;
> +}
> +
>  static int mfill_atomic_pte_copy(pmd_t *dst_pmd,
>  				 struct vm_area_struct *dst_vma,
>  				 unsigned long dst_addr,
> @@ -245,7 +279,6 @@ static int mfill_atomic_pte_copy(pmd_t *dst_pmd,
>  				 uffd_flags_t flags,
>  				 struct folio **foliop)
>  {
> -	void *kaddr;
>  	int ret;
>  	struct folio *folio;
>  
> @@ -256,27 +289,7 @@ static int mfill_atomic_pte_copy(pmd_t *dst_pmd,
>  		if (!folio)
>  			goto out;
>  
> -		kaddr = kmap_local_folio(folio, 0);
> -		/*
> -		 * The read mmap_lock is held here.  Despite the
> -		 * mmap_lock being read recursive a deadlock is still
> -		 * possible if a writer has taken a lock.  For example:
> -		 *
> -		 * process A thread 1 takes read lock on own mmap_lock
> -		 * process A thread 2 calls mmap, blocks taking write lock
> -		 * process B thread 1 takes page fault, read lock on own mmap lock
> -		 * process B thread 2 calls mmap, blocks taking write lock
> -		 * process A thread 1 blocks taking read lock on process B
> -		 * process B thread 1 blocks taking read lock on process A
> -		 *
> -		 * Disable page faults to prevent potential deadlock
> -		 * and retry the copy outside the mmap_lock.
> -		 */
> -		pagefault_disable();
> -		ret = copy_from_user(kaddr, (const void __user *) src_addr,
> -				     PAGE_SIZE);
> -		pagefault_enable();
> -		kunmap_local(kaddr);
> +		ret = mfill_copy_folio_locked(folio, src_addr);
>  
>  		/* fallback to copy_from_user outside mmap_lock */
>  		if (unlikely(ret)) {
> @@ -285,8 +298,6 @@ static int mfill_atomic_pte_copy(pmd_t *dst_pmd,
>  			/* don't free the page */
>  			goto out;
>  		}
> -
> -		flush_dcache_folio(folio);
>  	} else {
>  		folio = *foliop;
>  		*foliop = NULL;
> -- 
> 2.51.0
> 

-- 
Peter Xu


