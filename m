Return-Path: <kvm+bounces-15890-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F8238B1A73
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 07:53:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3FF0E2815C3
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 05:53:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7AE53C467;
	Thu, 25 Apr 2024 05:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="J6r7RDj/"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46BB83A1AC
	for <kvm@vger.kernel.org>; Thu, 25 Apr 2024 05:52:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714024381; cv=none; b=umRz6mvQ5EhEiyP77Jtbw0rm7akpdlYxD6bG866Qv27s6mwXxlAYXobciGfbDD1p1Lwe01tzJklpYJei4Hjmk56aVpxTN83iTR+llLBO+zn1SbFzkZsSYm3FyZGTYu52ZJu+YtCQJaJXMSEqrJUxZXsEh9tuC1RfadKCjEPw7ew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714024381; c=relaxed/simple;
	bh=0u82w9dolSvFU8Uwn8LV3m70Xn2FRnCiM4BxMwYdWf0=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=IA+0y8rUIN9+35Zj7FG7zH9GU4d98sR/WGP6iBrP8FgpCG2hlq2EUjLamf0GP6E+vkh8bg//XRA8/Ov1+v5KF7RXVrLlvtfaUlJM2qUeZMZBkxUpZ05zawhW/W/xBHOTZhqpDFDt9Av+vl4Ml72l0+LirpbkIR2pSvv4R2JaKuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=J6r7RDj/; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1714024378;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=dI7dijdI2QDdzkWi+eYKfMeHQJXKvryugjHN3nteeaY=;
	b=J6r7RDj/tyl1BSJDGTF9N/Jhkz0hc8JApvO39oLXORemWUXKhO4WUQl3yh04Dz4j/Zz1JU
	s1PKp7vCtQELuZy1/EXEsLbXoe6ABnDnqoAQ8z81V6NfgtKBJk8MVs8VrTbbQgIyasrCgS
	HOmJcpN7MM3YVvTtuysXHOhshKKEkeY=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-117-kNHBUNSCMGeLw1RDGzJbkA-1; Thu, 25 Apr 2024 01:52:56 -0400
X-MC-Unique: kNHBUNSCMGeLw1RDGzJbkA-1
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-a559bc02601so36335566b.0
        for <kvm@vger.kernel.org>; Wed, 24 Apr 2024 22:52:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714024375; x=1714629175;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dI7dijdI2QDdzkWi+eYKfMeHQJXKvryugjHN3nteeaY=;
        b=HSvBv2ETkF2L/E+DjLjBHCD/I3K9iWqaNoOf/FKZzDlZnWhY8YtHTbR1bGD46b11Sg
         FkNlHuLELiqOYK7vhXF7zFUyUc37Xl6ndtFvRa2MfyIX7wJNVImYgqV/MP9HOvGwKkbd
         XK0qDDaqYVVqTrPAHVOwpRhuzd004ZnqtvDjQeDyTbYZA/1OxxmB883tGkYstVDe7uCO
         T3X5SAC7uY68UnO1kfDREKreQ1ixX0OyjUvmdz0FMSMbCEFBbBdGCygsIyWyq9K4uFJ2
         PCy/deSER32qSq52SAp7KLuP059KaZXP+nw4/xQgs4yjOY52XORE/5Ms5D8RjsXIZQqG
         QUlw==
X-Forwarded-Encrypted: i=1; AJvYcCXoIqR5qy+9QTGXIWbP8MYLo4MU66OKkJtoAalnoAtoIauG4UvaCQQS0IomtI/p40OGhqlHwHwUir3u91Wzoo8SkYRj
X-Gm-Message-State: AOJu0YzfFdPjwVyeEjhUEqJbD5VXjp33ecgKWdNODUGllBF17EaFfQK3
	jFUOMPmU+2g4IxIz/9RrTN7d2bZZ634sXxDq5pYs2TOsclNWRfVVNlKx+vQUyigjtDtZFSf52IC
	0OSdjgNfR3PObJzmYvJKRDyMoFiI1bEjwBnDFoobBvh93LFkXlg==
X-Received: by 2002:a17:906:24d5:b0:a55:5b50:847f with SMTP id f21-20020a17090624d500b00a555b50847fmr2947393ejb.22.1714024375292;
        Wed, 24 Apr 2024 22:52:55 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG23ABnMxk4+XVx922H/ggA8ZeIwiF3utlZB7UPIYbYKuXtJb/8LuC3GBJPxkNizcFpIOHBtA==
X-Received: by 2002:a17:906:24d5:b0:a55:5b50:847f with SMTP id f21-20020a17090624d500b00a555b50847fmr2947377ejb.22.1714024374862;
        Wed, 24 Apr 2024 22:52:54 -0700 (PDT)
Received: from [192.168.10.48] ([151.81.119.75])
        by smtp.googlemail.com with ESMTPSA id ig13-20020a1709072e0d00b00a5886d91099sm2252346ejc.189.2024.04.24.22.52.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Apr 2024 22:52:53 -0700 (PDT)
Message-ID: <a4a38f76-d012-4ff4-a2a3-40af9a9a7052@redhat.com>
Date: Thu, 25 Apr 2024 07:52:52 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/11] filemap: add FGP_CREAT_ONLY
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 Matthew Wilcox <willy@infradead.org>, Vlastimil Babka <vbabka@suse.cz>
Cc: seanjc@google.com, michael.roth@amd.com, isaku.yamahata@intel.com,
 Yosry Ahmed <yosryahmed@google.com>
References: <20240404185034.3184582-1-pbonzini@redhat.com>
 <20240404185034.3184582-5-pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20240404185034.3184582-5-pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/4/24 20:50, Paolo Bonzini wrote:
> KVM would like to add a ioctl to encrypt and install a page into private
> memory (i.e. into a guest_memfd), in preparation for launching an
> encrypted guest.
> 
> This API should be used only once per page (unless there are failures),
> so we want to rule out the possibility of operating on a page that is
> already in the guest_memfd's filemap.  Overwriting the page is almost
> certainly a sign of a bug, so we might as well forbid it.
> 
> Therefore, introduce a new flag for __filemap_get_folio (to be passed
> together with FGP_CREAT) that allows *adding* a new page to the filemap
> but not returning an existing one.
> 
> An alternative possibility would be to force KVM users to initialize
> the whole filemap in one go, but that is complicated by the fact that
> the filemap includes pages of different kinds, including some that are
> per-vCPU rather than per-VM.  Basically the result would be closer to
> a system call that multiplexes multiple ioctls, than to something
> cleaner like readv/writev.
> 
> Races between callers that pass FGP_CREAT_ONLY are uninteresting to
> the filemap code: one of the racers wins and one fails with EEXIST,
> similar to calling open(2) with O_CREAT|O_EXCL.  It doesn't matter to
> filemap.c if the missing synchronization is in the kernel or in userspace,
> and in fact it could even be intentional.  (In the case of KVM it turns
> out that a mutex is taken around these calls for unrelated reasons,
> so there can be no races.)
> 
> Cc: Matthew Wilcox <willy@infradead.org>
> Cc: Yosry Ahmed <yosryahmed@google.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Matthew, are your objections still valid or could I have your ack?

Thanks,

Paolo

> ---
>   include/linux/pagemap.h | 2 ++
>   mm/filemap.c            | 4 ++++
>   2 files changed, 6 insertions(+)
> 
> diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
> index f879c1d54da7..a8c0685e8c08 100644
> --- a/include/linux/pagemap.h
> +++ b/include/linux/pagemap.h
> @@ -587,6 +587,7 @@ pgoff_t page_cache_prev_miss(struct address_space *mapping,
>    * * %FGP_CREAT - If no folio is present then a new folio is allocated,
>    *   added to the page cache and the VM's LRU list.  The folio is
>    *   returned locked.
> + * * %FGP_CREAT_ONLY - Fail if a folio is present
>    * * %FGP_FOR_MMAP - The caller wants to do its own locking dance if the
>    *   folio is already in cache.  If the folio was allocated, unlock it
>    *   before returning so the caller can do the same dance.
> @@ -607,6 +608,7 @@ typedef unsigned int __bitwise fgf_t;
>   #define FGP_NOWAIT		((__force fgf_t)0x00000020)
>   #define FGP_FOR_MMAP		((__force fgf_t)0x00000040)
>   #define FGP_STABLE		((__force fgf_t)0x00000080)
> +#define FGP_CREAT_ONLY		((__force fgf_t)0x00000100)
>   #define FGF_GET_ORDER(fgf)	(((__force unsigned)fgf) >> 26)	/* top 6 bits */
>   
>   #define FGP_WRITEBEGIN		(FGP_LOCK | FGP_WRITE | FGP_CREAT | FGP_STABLE)
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 7437b2bd75c1..e7440e189ebd 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -1863,6 +1863,10 @@ struct folio *__filemap_get_folio(struct address_space *mapping, pgoff_t index,
>   		folio = NULL;
>   	if (!folio)
>   		goto no_page;
> +	if (fgp_flags & FGP_CREAT_ONLY) {
> +		folio_put(folio);
> +		return ERR_PTR(-EEXIST);
> +	}
>   
>   	if (fgp_flags & FGP_LOCK) {
>   		if (fgp_flags & FGP_NOWAIT) {


