Return-Path: <kvm+bounces-48883-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 32833AD45E6
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 00:25:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9D5FF189E41A
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 22:25:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8CDF28C010;
	Tue, 10 Jun 2025 22:25:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JJ7r/8ny"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60FAA28BA9D
	for <kvm@vger.kernel.org>; Tue, 10 Jun 2025 22:25:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749594311; cv=none; b=Nr4/thzXdgrTQSDTI+ng6VoiDexlP5bZuPhQLqd2DBMbGrBokcKB6gvj5Ny8W05XNUNa2qIijdpvy+JxHJ0/3xs7qdDykBJEWavNutVnoV5JwF4+8xmwbBu20AkaDY4v5RbG3dkQ/ceu2ZWB7X9GjJeIDRd5WMm8yTjDzVv1emw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749594311; c=relaxed/simple;
	bh=bjEQw4isrba+nP1ZYwzcYPZbVaYkMsqnYrte+EEhbmE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MLmbYxDzAzoDF1qm+NBIj8evvmWOAP81KbBHCiuDcC5PBcOtmu1+KV3h5pnNrJzcB3wgpQ1X4+VqcUTpwmJMgfMYC7IEoBY1XbAnI+Bu48sY7FmuObpVCQUZ0dVxg71XqThgS5aeWI1glG/7d6Z/8DaINdIId9LF946Rux/iEVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JJ7r/8ny; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749594308;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jeldsOfLIW+0Hr4bYxPOhI4qHvZBHHNPgSq/+bzEbT4=;
	b=JJ7r/8nylq9p8XUPBIJoCglrzm6WhcrlLknWRuBFgxYtjwd79OegBviDQd/Lkt32xP6F5k
	uoPLlsLhVh8aVEoXgg78c8/GwWykxs4rAaEFhMciRGAAbNoiyzOTj85BNJqkrcfl5FF6X0
	w7ZWFklfpYdZarPspeiXybSvyxCwTCU=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-558-Xn1SV5VCObiT-2bxkzCTdQ-1; Tue, 10 Jun 2025 18:25:07 -0400
X-MC-Unique: Xn1SV5VCObiT-2bxkzCTdQ-1
X-Mimecast-MFC-AGG-ID: Xn1SV5VCObiT-2bxkzCTdQ_1749594307
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-4a589edc51aso142034531cf.0
        for <kvm@vger.kernel.org>; Tue, 10 Jun 2025 15:25:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749594307; x=1750199107;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jeldsOfLIW+0Hr4bYxPOhI4qHvZBHHNPgSq/+bzEbT4=;
        b=QdzCWFYn7oXBih4bkCI7nBxJxj9jaMNJZhE7Eu4W3xcVnzGYFAeNVbrec9G/xxgPCH
         3kq26W04qXcWXitiLAEzhjRF1d3yGpAkqRcOPIUYk0SfFVck8F/WHwzdIAugLIQGciZY
         A64MDEw6mXoN+QESttzIiSmd5vvSP09cPiA+bBU/u48C9T+Q5FEB6Mb6lc68K7bHjxJZ
         dLDGufK2QnrrUl9rIlLScwKTr3PJWwNzkE/tFiNPqdDJyrZVclkNP3tRofcKQYYdVJL1
         6k3aSP2Ix8FJ7ToMFCTg/HjQYmvVUSsnoTXXibxsZXqfcHu60T5PAuDZxrBiBnmWQpj8
         31bQ==
X-Forwarded-Encrypted: i=1; AJvYcCUjS6oIRAH6lxMx+FVmlixUaBIPMDZRBRRangixxpx/IWEuMekVvpeDMcWnCva2+sHNIrs=@vger.kernel.org
X-Gm-Message-State: AOJu0YxjZNnxmttQDNF9COvsuKIGV6JhgUg+RP4ARM1aeJ+Qmccdge+k
	LYV5b3MKX4Id8s7cctUnnYj9fXcowfP6Gqovooiocbwx7Pj3j8hymhYvyJ/6fskDyz99FxCwpHS
	sWU1sZnTDj0Ayp+luPbXD8xpmUXt+pJGPBzuVtvDBmYt7D7L25cro7g==
X-Gm-Gg: ASbGncuutaYtSA+sf3ihUCvbJ1tt7/2GpnaS5vmAk5l3jUjvztOBeL6r0Q6RW+owNZm
	s94LAYuYoSjAFQEeokScxkdI/2dWDx9NTf1l8h1nXvnUfOvCqr1y3jFEoHf2Sed8yAojZE9VZ3H
	iDFl/7ruHyRZOrxLb1u/4MdLq7ozaqF9I4zorOqrErDPik7Qo8wFqDP9uko6l3I6orFfLoF8fxL
	/zmEKe6OMunrZy6thYl/P2zn39zSt4MwvMXmr1A16RFPwtBxdVg9NKt/BbvWB1iuUBcx9hboOCU
	KPLmseoNzBv+2Q==
X-Received: by 2002:a05:622a:17cb:b0:477:ea0:1b27 with SMTP id d75a77b69052e-4a713c2b203mr19488541cf.26.1749594306763;
        Tue, 10 Jun 2025 15:25:06 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEh6veUjTr0aDX8Dk7lxqv8igglcGEC5XvjmK9Q5HpFTvrfcPRBsYoFnhvHMTj0/FgKtwRQ1A==
X-Received: by 2002:a05:622a:17cb:b0:477:ea0:1b27 with SMTP id d75a77b69052e-4a713c2b203mr19488271cf.26.1749594306427;
        Tue, 10 Jun 2025 15:25:06 -0700 (PDT)
Received: from x1.local ([85.131.185.92])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4a619866975sm78374471cf.68.2025.06.10.15.25.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Jun 2025 15:25:05 -0700 (PDT)
Date: Tue, 10 Jun 2025 18:25:02 -0400
From: Peter Xu <peterx@redhat.com>
To: Nikita Kalyazin <kalyazin@amazon.com>
Cc: akpm@linux-foundation.org, pbonzini@redhat.com, shuah@kernel.org,
	viro@zeniv.linux.org.uk, brauner@kernel.org, muchun.song@linux.dev,
	hughd@google.com, kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, jack@suse.cz,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
	jannh@google.com, ryan.roberts@arm.com, david@redhat.com,
	jthoughton@google.com, graf@amazon.de, jgowans@amazon.com,
	roypat@amazon.co.uk, derekmn@amazon.com, nsaenz@amazon.es,
	xmarcalx@amazon.com
Subject: Re: [PATCH v3 4/6] KVM: guest_memfd: add support for userfaultfd
 minor
Message-ID: <aEiwvi-oqfTiyP3s@x1.local>
References: <20250404154352.23078-1-kalyazin@amazon.com>
 <20250404154352.23078-5-kalyazin@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250404154352.23078-5-kalyazin@amazon.com>

On Fri, Apr 04, 2025 at 03:43:50PM +0000, Nikita Kalyazin wrote:
> Add support for sending a pagefault event if userfaultfd is registered.
> Only page minor event is currently supported.
> 
> Signed-off-by: Nikita Kalyazin <kalyazin@amazon.com>
> ---
>  virt/kvm/guest_memfd.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index fbf89e643add..096d89e7282d 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -4,6 +4,9 @@
>  #include <linux/kvm_host.h>
>  #include <linux/pagemap.h>
>  #include <linux/anon_inodes.h>
> +#ifdef CONFIG_KVM_PRIVATE_MEM
> +#include <linux/userfaultfd_k.h>
> +#endif /* CONFIG_KVM_PRIVATE_MEM */
>  
>  #include "kvm_mm.h"
>  
> @@ -380,6 +383,13 @@ static vm_fault_t kvm_gmem_fault(struct vm_fault *vmf)
>  		kvm_gmem_mark_prepared(folio);
>  	}
>  
> +	if (userfaultfd_minor(vmf->vma) &&
> +	    !(vmf->flags & FAULT_FLAG_USERFAULT_CONTINUE)) {
> +		folio_unlock(folio);
> +		filemap_invalidate_unlock_shared(inode->i_mapping);
> +		return handle_userfault(vmf, VM_UFFD_MINOR);
> +	}
> +

Hmm, does guest-memfd (when with your current approach) at least needs to
define the new can_userfault() hook?

Meanwhile, we have some hard-coded lines so far, like:

mfill_atomic():
	if (!vma_is_shmem(dst_vma) &&
	    uffd_flags_mode_is(flags, MFILL_ATOMIC_CONTINUE))
		goto out_unlock;

I thought it would fail guest-memfd already on a CONTINUE request, and it
doesn't seem to be touched yet in this series.

I'm not yet sure how the test worked out without hitting things like it.
Highly likely I missed something.  Some explanations would be welcomed.. 

Thanks,

>  	vmf->page = folio_file_page(folio, vmf->pgoff);
>  
>  out_folio:
> -- 
> 2.47.1
> 

-- 
Peter Xu


