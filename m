Return-Path: <kvm+bounces-69914-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OE3jI64hgWlvEQMAu9opvQ
	(envelope-from <kvm+bounces-69914-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 23:14:06 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C435D2095
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 23:14:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B29AF3036078
	for <lists+kvm@lfdr.de>; Mon,  2 Feb 2026 22:13:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F159C335097;
	Mon,  2 Feb 2026 22:13:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ltf0x0Wy";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="SR6wQaiG"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5F9F335070
	for <kvm@vger.kernel.org>; Mon,  2 Feb 2026 22:13:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770070409; cv=none; b=MIDrYAFa6ufQmebztnViNHADFgQTCJW3dStwjm8KRL5ikkO/TI0BSV+scJEIE/yLZ/12HazPYFc0BPzbkUNmjRRjLesycR1fK1IftrxVTVVxUXTNerg+hnwbLuqLt0IXu+ZUppvi6UHFZlDUL3zS04/H1cHCvxI9n4aODPh4wAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770070409; c=relaxed/simple;
	bh=N0sSOQ0f8rnPwD/KRhdnLNJC/bfbDb56Wa9rXTXP8zs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XEvvkRu1h1+Xp3ezusSvF8leNIgy/zaNWjrnqMkSkuSl48jmEw3MWLbBAUF2u5vpgrpxpjOq2NH0UWXZtaLsVdClKLacM/OMq7xr/rfNWi3er59wamY/ZNEc9e/oD4ag1GJU+5LiyrcftNWodFYzuihieMU55CaifZZ3HPMV3aA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ltf0x0Wy; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=SR6wQaiG; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770070406;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NetS+z/lB9Vjk8awsEzStStR7YjfBL5uvT3v62JS7ho=;
	b=Ltf0x0Wy6kmHmj9tEr/RbFjqlhD1gTcAYB/I2Z+GFR4RahbluTBUL0et5uLkf/vIrkSwfh
	OAty3MRPDLL9JmdwicGbvQJBMjmGwT04xQLibrjXDhByihzL5PGyB8Sdte77VLy48m7qOj
	vkh2faPXgzcAmDgIBXPJ6IlpRr2P7bQ=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-135-3S3Mkl5-Os-63nrc_r88Og-1; Mon, 02 Feb 2026 17:13:24 -0500
X-MC-Unique: 3S3Mkl5-Os-63nrc_r88Og-1
X-Mimecast-MFC-AGG-ID: 3S3Mkl5-Os-63nrc_r88Og_1770070404
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-501473ee94fso250499501cf.3
        for <kvm@vger.kernel.org>; Mon, 02 Feb 2026 14:13:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1770070404; x=1770675204; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=NetS+z/lB9Vjk8awsEzStStR7YjfBL5uvT3v62JS7ho=;
        b=SR6wQaiG3cJugALih14e1Q8AYRYx0rjUn4H5fzdlrg5DlYkrYS9QaTpH/uKHYp9ATm
         4iw7MXqNNsBxIMZaRx4YCuWkfZyjk1nD8UkvqOY/cthB5Kgop1ZzkDgSkZVOIkKO+7zr
         2csupAfzHy1Wf85n4zuSK8Ns6DtKCtDqlPLdTsDPuGrLHs1wbBSWULcXbjXnDS54cwwx
         s+Bzc90FFxjT/SWoDCx9Y6SgP3PHFZ1qsueUhYubfVMcPTG1toEutKu3g1Hn1BeoB4dJ
         S9Z5Iw4YNv9GxBmQPVYKAN/5F6rDzEduQLDm4PBkZJjFnJgyql+N3TCa5Yp9h34J1l3S
         SKqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770070404; x=1770675204;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NetS+z/lB9Vjk8awsEzStStR7YjfBL5uvT3v62JS7ho=;
        b=Lw1uUrdPOg1SXqe33p0tFXTUjM6uo1nhqOGWP5JgfpPxdfaU0u1uufnUbLQtnvXKKp
         L0efQ13yr4XG98QgNDasM3z0cPMNLaIju7LdQ3ubBZOeTH3ocM3rQurErezgCtgZVbVT
         e/XXxck+fFWH+klfS3vPMJinYjId+7ciXpMs60jOly0KhY+5FlVXJMUn19rUF2gGw9dI
         vpiCmSf0OLlZeZoMiPTXvm58l+AU6QJEzlBKwkG6h18E9g7dZyLEZ8eNFCjULL5EK0C7
         7EQNwg7U14P1kvkXT75Dq/Ucalz5QrHJ9RutsAk7YHCfXYX0N0ebj42CqRs+MbUfBed0
         KlSQ==
X-Forwarded-Encrypted: i=1; AJvYcCXuh56OdnTdK0I9Om6gXFuRSiySHk2hVinxtEEaiB3Jv859xaQc9kqOi3B9ef488mYrhzk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyk04ie7vR9hUSEalBhRL9p1Rhsd3vXMKcE/2okSuKEEYexLs+H
	Kn9grfpVIfjV4Uy52mjbQa/ZR3rb40bmq4Cso/umnSxQt5NsHw3RvCRwkM4EwKjUPdAjg7vyQb7
	GcDR3ADzVMgy87+8E2AqFgvpsmpVqe2u9pJP49GAGOy+enpzOY2dwJg==
X-Gm-Gg: AZuq6aKtdgKNOhiB6ZS0e713vrxilbNndOiEEwiWzHKlGUg3ZItF/wiSxQ7n+4nKzOl
	OjnqJEd+Y7IGeTTWa5w7P6VR0oKxymOHaqThYxil8IHiker+Hlg1iyIfeatk8wxHQkYfwedeq6e
	WQkhrdk0FAEix5PeKwW4cNeo/kQmg7RcUN1eihK0qEnFMMJw7D873sjXvBp/R7sIb1qmwaD5i+l
	h5+zza4Md5ube+kZBMockiIbVwJ5SxdCYcYEKr/Ye/ig7ZvJGxTCKvxWmVFOhRK2PUYTfV/xyst
	omjWaH3qteU5dIoS7D1H3iZJQ/j4vbFkN8f/wnXbFPGlUB8B01vE5tPsH8dRQUfgN5g3E//lGpx
	f9Tw=
X-Received: by 2002:a05:622a:28d:b0:4ed:af59:9df0 with SMTP id d75a77b69052e-505d228ac43mr152974701cf.40.1770070404196;
        Mon, 02 Feb 2026 14:13:24 -0800 (PST)
X-Received: by 2002:a05:622a:28d:b0:4ed:af59:9df0 with SMTP id d75a77b69052e-505d228ac43mr152974231cf.40.1770070403763;
        Mon, 02 Feb 2026 14:13:23 -0800 (PST)
Received: from x1.local ([142.188.210.156])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50489d1b52csm101407911cf.8.2026.02.02.14.13.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Feb 2026 14:13:23 -0800 (PST)
Date: Mon, 2 Feb 2026 17:13:20 -0500
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
Subject: Re: [PATCH RFC 09/17] userfaultfd: introduce
 vm_uffd_ops->alloc_folio()
Message-ID: <aYEhgA1dY0biVYb8@x1.local>
References: <20260127192936.1250096-1-rppt@kernel.org>
 <20260127192936.1250096-10-rppt@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260127192936.1250096-10-rppt@kernel.org>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69914-lists,kvm=lfdr.de];
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
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[x1.local:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 1C435D2095
X-Rspamd-Action: no action

On Tue, Jan 27, 2026 at 09:29:28PM +0200, Mike Rapoport wrote:

[...]

> -static int mfill_atomic_pte_zeroed_folio(pmd_t *dst_pmd,
> -					 struct vm_area_struct *dst_vma,
> -					 unsigned long dst_addr)
> +static int mfill_atomic_pte_copy(struct mfill_state *state)
>  {
> -	struct folio *folio;
> -	int ret = -ENOMEM;
> -
> -	folio = vma_alloc_zeroed_movable_folio(dst_vma, dst_addr);
> -	if (!folio)
> -		return ret;
> -
> -	if (mem_cgroup_charge(folio, dst_vma->vm_mm, GFP_KERNEL))
> -		goto out_put;
> +	const struct vm_uffd_ops *ops = vma_uffd_ops(state->vma);
>  
> -	/*
> -	 * The memory barrier inside __folio_mark_uptodate makes sure that
> -	 * zeroing out the folio become visible before mapping the page
> -	 * using set_pte_at(). See do_anonymous_page().
> -	 */
> -	__folio_mark_uptodate(folio);
> +	return __mfill_atomic_pte(state, ops);
> +}
>  
> -	ret = mfill_atomic_install_pte(dst_pmd, dst_vma, dst_addr,
> -				       &folio->page, true, 0);
> -	if (ret)
> -		goto out_put;
> +static int mfill_atomic_pte_zeroed_folio(struct mfill_state *state)
> +{
> +	const struct vm_uffd_ops *ops = vma_uffd_ops(state->vma);
>  
> -	return 0;
> -out_put:
> -	folio_put(folio);
> -	return ret;
> +	return __mfill_atomic_pte(state, ops);
>  }
>  
>  static int mfill_atomic_pte_zeropage(struct mfill_state *state)
> @@ -542,7 +546,7 @@ static int mfill_atomic_pte_zeropage(struct mfill_state *state)
>  	int ret;
>  
>  	if (mm_forbids_zeropage(dst_vma->vm_mm))
> -		return mfill_atomic_pte_zeroed_folio(dst_pmd, dst_vma, dst_addr);
> +		return mfill_atomic_pte_zeroed_folio(state);

After this patch, mfill_atomic_pte_zeroed_folio() should be 100% the same
impl with mfill_atomic_pte_copy(), so IIUC we can drop it.

>  
>  	_dst_pte = pte_mkspecial(pfn_pte(my_zero_pfn(dst_addr),
>  					 dst_vma->vm_page_prot));
> -- 
> 2.51.0
> 

-- 
Peter Xu


