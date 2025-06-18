Return-Path: <kvm+bounces-49862-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 70B54ADEA7F
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 13:42:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DEED417CB70
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 11:42:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 510492E763E;
	Wed, 18 Jun 2025 11:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gc57ibY0"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B7F02E7188
	for <kvm@vger.kernel.org>; Wed, 18 Jun 2025 11:40:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750246820; cv=none; b=YvGQL/ytf1EaPjLSeHWCAmixLuw4HqV6IZbPXdXeC5R1eQE1kCcnqXYlzg7u39GpSKO9kZH9qrvyTy4jNf8ovMfbS9cJpO7CRk0ykljsrEtPRvlyQM4q9AgekbzOdgcRt3GoqhtanQ6rpdbhtWBWrE6j8TMzXNOrtNDslqJ/4vc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750246820; c=relaxed/simple;
	bh=rJv34prLfR9DztULYI+RpySdv0ciBuTK8+A8GpaylNU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=q6iXqYe7TAdCtL/9eGo3SBDSqG5h28gdN88YhRKh7wsbD1iwer7/2xjgjMGTOKEFc42DMJklNLc3Sarwo5rdyY4wrWDWYE/iKn7mK4iboOrMJlB0MYZYZZAh8R1/u82k+k59wpTDZ2PJ+Y+FMT9RwS0RVRvrL4qiSQApkBK15Qs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gc57ibY0; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750246817;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=3xDO9S5s2rEX7oweu/3FQY3ihC5X7U1SC0vT6ArEkZE=;
	b=gc57ibY0ZplX9bLgpUURxYpKH9j8QgKYbZZ5QnuoZE3AaeMgRji3pilBgM80OuCqSU9UTF
	NYsuSK2GHeY/OFAB82uVGw8Rt2IonpzZ3Lv3L9qDvwEnRhtsvXANset6YQoTNsoF3r2eQN
	2ufVwlTKVKlrGAOpKfqJwUGjrqufnoY=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-417-3JtqBIatO7KAjL0Ve1Wn2w-1; Wed, 18 Jun 2025 07:40:16 -0400
X-MC-Unique: 3JtqBIatO7KAjL0Ve1Wn2w-1
X-Mimecast-MFC-AGG-ID: 3JtqBIatO7KAjL0Ve1Wn2w_1750246815
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4532514dee8so57716345e9.0
        for <kvm@vger.kernel.org>; Wed, 18 Jun 2025 04:40:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750246815; x=1750851615;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=3xDO9S5s2rEX7oweu/3FQY3ihC5X7U1SC0vT6ArEkZE=;
        b=RLL2dAA54EV5vBJFhaNIqQhWp6Z9ktvenERuwCHOkIkKa5c/Si3uXzuyWFfn9cjlG+
         CflZsPxWwK4UFsb1IxqAGGa9rVWjNQ1X2vuH5QOniRFV9Pgxii85RlguN7wETlHpsJ32
         dULj7JJS4aw7xGjP6G5g/YP9FVW0tZwRPPpTHRyj0qfbTp/d67rFxeoQunlm2S8xEE0+
         bG+eI8qrAzhycXFv0PdsB6SWAn8FtmAhsbPf5BsF//W7NsHNTPcGFsIccN2vcGGxWf1P
         LInCZvZ2tSeA3qoNu/jl7m/tnTyWo7EbdyeRb/FKFZ7VeKn2z07/yIsblZDK3M+YE9qA
         4nkw==
X-Forwarded-Encrypted: i=1; AJvYcCW+vY8a9wprTkNCsK6laU1BZ7GJLHiEvr7959/SxfJhEux6F6TUPxlcco1NrHmzMe5UmSA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw6UvOCf8Rm27sQ+ES2Yxv9hUdNeBPDFaHNxuYxopagn5n+z5Aa
	fuCRRgRfnPPW2LfDwXAs0EARdd0teT+Vb60zNQHMVJxZ+x4i+i/LAc++wmC9XnfEbUZc5D04wgP
	ZkibfKL7BbKRidr3qULJXknXRYhTCRAZuKBiPNCMm9xctgHUJ/6+KiA==
X-Gm-Gg: ASbGnctkqWn+o40i7i/1C5aNtDG3zsD+X3dcNeQZYoKesgGfa0QqD2egfu3Gz2Zgh5K
	BKFDwUPSX8FZ0UWoZnqh060+xNCw66a3EWAhisE4raXfDZXL37SXW4NrgE+EHDr3cnGrmfGA1iL
	FPNc7S9r+GM5Yr59pjl3TIJ+xip1v/VrnXatSw5ngRjgn4WhDc7013L0cjE8SEGsdwWWXEx/n5Q
	XTNZRm0uYhh91KeJ5zJ0ytQ34Lg5IdcWku/wjgGx07n/nHBUINlOdTJzGUYYAr848R+294RO73r
	G103k0B9H+sH7RWn8F8M7WqnpE7w30By5H9d/y8GDC2oEwVt/Bna/SYBIEMIWGeLa0xsf7agmLZ
	ZX51lRpm1kqWJSmC0UxBKmek6azm+WonZ66z/jbOlVeybbD4=
X-Received: by 2002:a05:600c:1d0d:b0:441:b00d:e9d1 with SMTP id 5b1f17b1804b1-4533ca4658amr168075585e9.2.1750246814710;
        Wed, 18 Jun 2025 04:40:14 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHQFaxkhFP76Yhxn9ktE3C8a7/XVi0BEU4JLqAjlqNbCFPzncE0STAA5a0na8RvLU5davaKRA==
X-Received: by 2002:a05:600c:1d0d:b0:441:b00d:e9d1 with SMTP id 5b1f17b1804b1-4533ca4658amr168075305e9.2.1750246814341;
        Wed, 18 Jun 2025 04:40:14 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f2d:2400:4052:3b5:fff9:4ed0? (p200300d82f2d2400405203b5fff94ed0.dip0.t-ipconnect.de. [2003:d8:2f2d:2400:4052:3b5:fff9:4ed0])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4532dea1cc5sm209672895e9.16.2025.06.18.04.40.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Jun 2025 04:40:13 -0700 (PDT)
Message-ID: <9c31da33-8579-414a-9b2a-21d7d8049050@redhat.com>
Date: Wed, 18 Jun 2025 13:40:13 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/3] gup: introduce unpin_user_folio_dirty_locked()
To: Jason Gunthorpe <jgg@ziepe.ca>, lizhe.67@bytedance.com
Cc: akpm@linux-foundation.org, alex.williamson@redhat.com,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 peterx@redhat.com
References: <20250617152210.GA1552699@ziepe.ca>
 <20250618062820.8477-1-lizhe.67@bytedance.com>
 <20250618113626.GK1376515@ziepe.ca>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20250618113626.GK1376515@ziepe.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 18.06.25 13:36, Jason Gunthorpe wrote:
> On Wed, Jun 18, 2025 at 02:28:20PM +0800, lizhe.67@bytedance.com wrote:
>> On Tue, 17 Jun 2025 12:22:10 -0300, jgg@ziepe.ca wrote:
>>> +	while (npage) {
>>> +		long nr_pages = 1;
>>> +
>>> +		if (!is_invalid_reserved_pfn(pfn)) {
>>> +			struct page *page = pfn_to_page(pfn);
>>> +			struct folio *folio = page_folio(page);
>>> +			long folio_pages_num = folio_nr_pages(folio);
>>> +
>>> +			/*
>>> +			 * For a folio, it represents a physically
>>> +			 * contiguous set of bytes, and all of its pages
>>> +			 * share the same invalid/reserved state.
>>> +			 *
>>> +			 * Here, our PFNs are contiguous. Therefore, if we
>>> +			 * detect that the current PFN belongs to a large
>>> +			 * folio, we can batch the operations for the next
>>> +			 * nr_pages PFNs.
>>> +			 */
>>> +			if (folio_pages_num > 1)
>>> +				nr_pages = min_t(long, npage,
>>> +					folio_pages_num -
>>> +					folio_page_idx(folio, page));
>>> +
>>> +			unpin_user_folio_dirty_locked(folio, nr_pages,
>>> +					dma->prot & IOMMU_WRITE);
>>
>> Are you suggesting that we should directly call
>> unpin_user_page_range_dirty_lock() here (patch 3/3) instead?
> 
> I'm saying you should not have the word 'folio' inside the VFIO. You
> accumulate a contiguous range of pfns, by only checking the pfn, and
> then call
> 
> unpin_user_page_range_dirty_lock(pfn_to_page(first_pfn)...);
> 
> No need for any of this. vfio should never look at the struct page
> except as the last moment to pass the range.

Hah, agreed, that's actually simpler and there is no need to factor 
anything out.

-- 
Cheers,

David / dhildenb


