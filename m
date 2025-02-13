Return-Path: <kvm+bounces-38097-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CA108A34F36
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2025 21:16:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DA4973ADC36
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2025 20:16:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3D7526618E;
	Thu, 13 Feb 2025 20:16:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="II4DFcJT"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF1A924BC1F
	for <kvm@vger.kernel.org>; Thu, 13 Feb 2025 20:16:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739477773; cv=none; b=C8NSax0Oce9jnv6C154DS/MeWeWkUFoAsKrspwEMq159rekvzarkw1Qy44Y18DJWuk8qc2q12sPxLr2sD7dQjQ5iGDCRYckBFn96S6r8lRbhI1e0gAy1vB4jdv5aAMpwA9exN6tXcK+vHlAnxC6ab4AZPAXSqFEIX0b4zEeNCBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739477773; c=relaxed/simple;
	bh=3UWHctqrbsPrYky0+K2FnRNyyxEuk6bcndSyRwZE9wI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=M63+rZBDKOiBywc9F7s0MO/BY1QPoxEvm8Izu8NNgy/2t4qeVqdYXJDY5fK+avO7uSWV+Re0KFPDjpvdVLmw853PKxlcytDqETFg3OKAq/r2rQZjA56123oRhVBNNyQQjHH6xzuekg3ZvaDZ2QDM3Wk4XdAJ8qS/mJVzEE0J0YY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=II4DFcJT; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739477769;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=6ILeGkWoXeClHCHdsbugyUQaaF47n5jodfjLWAcOmSc=;
	b=II4DFcJTPdqLykeEOao+OaDOaRF0wmdbgQY6Y0o7wpsBuLPw7K7yyCTBNUu4cSaXj4Vmgd
	9sBwTZxyLPnt6HT9YiOHIpqln56gkar5CwJTWHVJaPwcwiFUYnJXZpwrFwpfPakf4dknED
	7/Zy91gBjX90QVhD44omaOZkqs73k0E=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-524-lCebK9h5P6y0EcA_hF6jDQ-1; Thu, 13 Feb 2025 15:16:08 -0500
X-MC-Unique: lCebK9h5P6y0EcA_hF6jDQ-1
X-Mimecast-MFC-AGG-ID: lCebK9h5P6y0EcA_hF6jDQ
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4394c489babso7171655e9.1
        for <kvm@vger.kernel.org>; Thu, 13 Feb 2025 12:16:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739477767; x=1740082567;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=6ILeGkWoXeClHCHdsbugyUQaaF47n5jodfjLWAcOmSc=;
        b=ExeCsbw8Pjade8XKctbSGc7asPSsrCd/kfzzpLIdb8z7B0gqYJDm1My/JX7TjJRQFI
         AP9TwF6pud8AabCDVmZl8slOEb+DLhcRlZo5uTNINoAsm5n8XJxdlMxSdmLoraMk9byg
         7yw2THQtx81ejoxAn7TPoYz9zPES2Lv/DtbY+ZYU3dR6YakV02DeB5Z+KQKl6fw9A6IG
         tfhTBOrnHDygfyUeQ98rR6bAUVx2dmEXsQvLATL/MWnxmxxwIDurSo6/b3hSMWdIQQKh
         xomwUWe66Z7y9kwQOxuiP9J0iq0CtUUnDzLWbSLtouePJUmwzphUpgwZQpezuZLsU/Jr
         xklQ==
X-Forwarded-Encrypted: i=1; AJvYcCXYhgP7jWCrUQhEk6SYHtmsfMqRGF3o0Lqc7quwuq/tsTcUVFzc/phgeKPWsNZnjeGv0tc=@vger.kernel.org
X-Gm-Message-State: AOJu0YyYRL7wU/WPwrBS87gTYn5yk278R5ovC7PEglOlSfPxJN8W+waV
	3ykmEDrrGJjgUNS10faiq0Th4MTD8L4fK0Eq0CMVhM+lN77nm0LMFDUd4DJgA0eMsgsuh2Ss2mb
	x7mkEXFmQ6U+94fNI2G+Na+lUT4Jk+U8Ci7QISe+mswVgWMY33w==
X-Gm-Gg: ASbGncv+r2s15+vZZFZVMDCRp0MUvsCPE4uGyGPh7iYvN6vqAGETKJc3uho2coZTel8
	YwnLI6gPyffJQxesxn96BYoSIz58qknx5CMCrmLPFau1j1i3jz52gj066kdDWp4GiqDkNc7IigV
	V2dh/j+kx7R2+wPPXPqLEyRqlO8LBW2W2myYZ8QZYcExSqXrcRrAEaaPh8QNS1Nb4OZ0FCRw/2o
	PY3mKaGEZR+RwA/8tZZ735Dge1Wzn49xIeM7LguoBhTcQNCpIQYKQvwWCmcupO7XuFSpmI9Vukq
	LJAcSUfnSA+kwzujEWY4RvFYqRtvwWO9qE0=
X-Received: by 2002:a05:600c:540e:b0:439:4355:2f7e with SMTP id 5b1f17b1804b1-43960184c65mr62430155e9.13.1739477767161;
        Thu, 13 Feb 2025 12:16:07 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF+iegTS8TYhdEwjubKVfOb8mEUIUT3/1aMgrqq2GRD/uqaWa8b1odcp1lOrDdgVwyScb3n5Q==
X-Received: by 2002:a05:600c:540e:b0:439:4355:2f7e with SMTP id 5b1f17b1804b1-43960184c65mr62429785e9.13.1739477766743;
        Thu, 13 Feb 2025 12:16:06 -0800 (PST)
Received: from [192.168.3.141] (p5b0c6c7e.dip0.t-ipconnect.de. [91.12.108.126])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38f258b4423sm2800682f8f.11.2025.02.13.12.16.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Feb 2025 12:16:05 -0800 (PST)
Message-ID: <6c741da9-a793-4a59-920f-8df77807bc4d@redhat.com>
Date: Thu, 13 Feb 2025 21:16:03 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 2/2] KVM: s390: pv: fix race when making a page secure
To: Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
 frankja@linux.ibm.com, borntraeger@de.ibm.com, nrb@linux.ibm.com,
 seiden@linux.ibm.com, nsg@linux.ibm.com, schlameuss@linux.ibm.com,
 hca@linux.ibm.com
References: <20250213200755.196832-1-imbrenda@linux.ibm.com>
 <20250213200755.196832-3-imbrenda@linux.ibm.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20250213200755.196832-3-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 13.02.25 21:07, Claudio Imbrenda wrote:
> Holding the pte lock for the page that is being converted to secure is
> needed to avoid races. A previous commit removed the locking, which
> caused issues. Fix by locking the pte again.
> 
> Fixes: 5cbe24350b7d ("KVM: s390: move pv gmap functions into kvm")

If you found this because of my report about the changed locking, 
consider adding a Suggested-by / Reported-y.

> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>   arch/s390/include/asm/uv.h |  2 +-
>   arch/s390/kernel/uv.c      | 19 +++++++++++++++++--
>   arch/s390/kvm/gmap.c       | 12 ++++++++----
>   3 files changed, 26 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
> index b11f5b6d0bd1..46fb0ef6f984 100644
> --- a/arch/s390/include/asm/uv.h
> +++ b/arch/s390/include/asm/uv.h
> @@ -631,7 +631,7 @@ int uv_pin_shared(unsigned long paddr);
>   int uv_destroy_folio(struct folio *folio);
>   int uv_destroy_pte(pte_t pte);
>   int uv_convert_from_secure_pte(pte_t pte);
> -int make_folio_secure(struct folio *folio, struct uv_cb_header *uvcb);
> +int make_hva_secure(struct mm_struct *mm, unsigned long hva, struct uv_cb_header *uvcb);
>   int uv_convert_from_secure(unsigned long paddr);
>   int uv_convert_from_secure_folio(struct folio *folio);
>   
> diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
> index 9f05df2da2f7..de3c092da7b9 100644
> --- a/arch/s390/kernel/uv.c
> +++ b/arch/s390/kernel/uv.c
> @@ -245,7 +245,7 @@ static int expected_folio_refs(struct folio *folio)
>    * Context: The caller must hold exactly one extra reference on the folio
>    *          (it's the same logic as split_folio())
>    */
> -int make_folio_secure(struct folio *folio, struct uv_cb_header *uvcb)
> +static int __make_folio_secure(struct folio *folio, unsigned long hva, struct uv_cb_header *uvcb)
>   {
>   	int expected, cc = 0;
>   
> @@ -277,7 +277,22 @@ int make_folio_secure(struct folio *folio, struct uv_cb_header *uvcb)
>   		return -EAGAIN;
>   	return uvcb->rc == 0x10a ? -ENXIO : -EINVAL;
>   }
> -EXPORT_SYMBOL_GPL(make_folio_secure);
> +
> +int make_hva_secure(struct mm_struct *mm, unsigned long hva, struct uv_cb_header *uvcb)
> +{
> +	spinlock_t *ptelock;
> +	pte_t *ptep;
> +	int rc;
> +
> +	ptep = get_locked_pte(mm, hva, &ptelock);
> +	if (!ptep)
> +		return -ENXIO;
> +	rc = __make_folio_secure(page_folio(pte_page(*ptep)), hva, uvcb);
> +	pte_unmap_unlock(ptep, ptelock);
> +
> +	return rc;
> +}
> +EXPORT_SYMBOL_GPL(make_hva_secure);
>   
>   /*
>    * To be called with the folio locked or with an extra reference! This will
> diff --git a/arch/s390/kvm/gmap.c b/arch/s390/kvm/gmap.c
> index fc4d490d25a2..e56c0ab5fec7 100644
> --- a/arch/s390/kvm/gmap.c
> +++ b/arch/s390/kvm/gmap.c
> @@ -55,7 +55,7 @@ static bool should_export_before_import(struct uv_cb_header *uvcb, struct mm_str
>   	return atomic_read(&mm->context.protected_count) > 1;
>   }
>   
> -static int __gmap_make_secure(struct gmap *gmap, struct page *page, void *uvcb)
> +static int __gmap_make_secure(struct gmap *gmap, struct page *page, unsigned long hva, void *uvcb)
>   {
>   	struct folio *folio = page_folio(page);
>   	int rc;
> @@ -83,7 +83,7 @@ static int __gmap_make_secure(struct gmap *gmap, struct page *page, void *uvcb)
>   		return -EAGAIN;
>   	if (should_export_before_import(uvcb, gmap->mm))
>   		uv_convert_from_secure(folio_to_phys(folio));
> -	rc = make_folio_secure(folio, uvcb);
> +	rc = make_hva_secure(gmap->mm, hva, uvcb);
>   	folio_unlock(folio);
>   
>   	/*
> @@ -120,6 +120,7 @@ static int __gmap_make_secure(struct gmap *gmap, struct page *page, void *uvcb)
>   int gmap_make_secure(struct gmap *gmap, unsigned long gaddr, void *uvcb)
>   {
>   	struct kvm *kvm = gmap->private;
> +	unsigned long vmaddr;
>   	struct page *page;
>   	int rc = 0;
>   
> @@ -127,8 +128,11 @@ int gmap_make_secure(struct gmap *gmap, unsigned long gaddr, void *uvcb)
>   
>   	page = gfn_to_page(kvm, gpa_to_gfn(gaddr));
>   	mmap_read_lock(gmap->mm);
> -	if (page)
> -		rc = __gmap_make_secure(gmap, page, uvcb);
> +	vmaddr = gfn_to_hva(gmap->private, gpa_to_gfn(gaddr));
> +	if (kvm_is_error_hva(vmaddr))
> +		rc = -ENXIO;
> +	if (!rc && page)
> +		rc = __gmap_make_secure(gmap, page, vmaddr, uvcb);
>   	kvm_release_page_clean(page);
>   	mmap_read_unlock(gmap->mm);
>   

You effectively make the code more complicated and inefficient than 
before. Now you effectively walk the page table twice in the common 
small-folio case ...

Can we just go back to the old handling that we had before here?

-- 
Cheers,

David / dhildenb


