Return-Path: <kvm+bounces-60853-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D9644BFE125
	for <lists+kvm@lfdr.de>; Wed, 22 Oct 2025 21:41:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9851B19C70A7
	for <lists+kvm@lfdr.de>; Wed, 22 Oct 2025 19:41:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0475834CFD5;
	Wed, 22 Oct 2025 19:40:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ew5eRYxs"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B01131D377
	for <kvm@vger.kernel.org>; Wed, 22 Oct 2025 19:40:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761162055; cv=none; b=rNBB+mafZ7mCB4i/Dmy1PvnkDBO7WpRlAqKxrztbVMfcjDn7nskcK0B1NR5bmoxpPtX3vGnnbdIeWYThJT9I9xksSkgAx/O7v9SOzUEQmfe88T26RJyP0mibapx4fw2O7Jf5G6eWI1wRD4M0W++Hd6IU3Nkmc6THZ18SNTpH9TI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761162055; c=relaxed/simple;
	bh=Ry/CqQF8gSsC5NG7sbHzCUi7cATayg+V+Dt7AGOsJ4k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TToo5+I5a90eAOZfNOSxVgZy6Xdd2oUtJXbckarjPU6khCQNtwAUocYYvu/pGcESizeI87G9oEaX8fFyDA0s0DhojCJCozJ6JfRZ7dWNOTvXHDfYsn0VnpqJz/2g0LsTTfUjqsK6PxQjpUoqwqh4q7kF2xwHFy+JuETT3DMOlnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ew5eRYxs; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761162051;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ctjARE35XeKYScTYpzOp9NxY/HaJoJcJWB6BlYqpxGU=;
	b=Ew5eRYxs/mVa+TGaW1lCFNYPZxOhKEo/hbZBoYrPhlUECnSlwyQPksmRCGmFgEtgUY/jXK
	DOe/wOTqVs4HcEbEi9ih0SesL3zeJxacvEnuuntPN8poBu8msN7QcS5swbsH99wXFlCXIU
	HQJ9WaG5YKW761SFnh4608MPl4wKrMI=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-167-62jxuT0NNNyjRUBQ_BxQZQ-1; Wed, 22 Oct 2025 15:40:50 -0400
X-MC-Unique: 62jxuT0NNNyjRUBQ_BxQZQ-1
X-Mimecast-MFC-AGG-ID: 62jxuT0NNNyjRUBQ_BxQZQ_1761162048
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-471201dc0e9so60041695e9.2
        for <kvm@vger.kernel.org>; Wed, 22 Oct 2025 12:40:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761162048; x=1761766848;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ctjARE35XeKYScTYpzOp9NxY/HaJoJcJWB6BlYqpxGU=;
        b=ikAiwoUQrORLHrfrAtf9l0BFOC55RPtEQ6JwPyfxm3BheS8F+xV3DCXPx2QYU3+VgK
         kKxfptQkPKp5kaBjAF73LLOFyXEki6tn8BOX1x/4C+5edUPBPrE5YS2olrjArebSm5ca
         ydC3IU79x76taz+XBYUXn7H3ONy/Z2IS+7GsZ+nlmQXXkxfWTfxD0grkM+lnrebHUX38
         UafYHoLoV2Eix/777erdvFbe5UBglIkOXyayLdf4pXOaNq38rCGxmQmkSR/zVIgvHxOp
         +G7ivbWjIgCVpFtgPmqimi7OqKYsaTFPwvl//qbmryTlYyO7eQTBRUbdlsJW3luMfnz5
         JUqQ==
X-Gm-Message-State: AOJu0YwP2+8QjHc28ij/4dLYqEXeqq/mq3EPgZmZ1ceHoimhtM9BWfw8
	QWNa5B+fKs6WFU7CTxRTScEwfKQvra/I/kO7OwLKZzk8dv/LNDRt+Lbrr0i1ejVGIeeyxAatOi5
	poJ3ugVRncZlOZvyVtyW3G/7XyvnSHM5f/MISO0/0BWDErVaAG/8TGA==
X-Gm-Gg: ASbGncvGePSYOCJm1YqbRyMDXvtjlTQSajfN93ESGW0T70HegA19oPr0wYJ9SdPJ5tW
	DukJMiUFAywTPveYShCQpEuEnrb+wHjhRBJ7KG/OADR55QitGfhQni9xvqfx6aWE3kBWmvJDCko
	16A8dzHhpZQlrHFV7bGzWA4B/VdCLhgmZxQGBxBWlQry1EpHQhGToVDeVsyQ1Ls4wenvH+nXAqS
	u0fE1eo4uC12LPzLYKS8XoSBnpzntUr8tWTX8SJwZhowlVzsjtXvcJiMFqgDJIZ+EI7mHyNNf/0
	j1yga2Dqlj2s/Iwh6zmkqqx+QU7Q9bnyVFnnmwy0dBPScTh187JfqeHohzHs1lf3RRnuOWrbgJ8
	iWSJpUXDdq4jGsx/q0D8hf6OBCxn54e/Ghxa2W+sl4HGGG1b4ozDh349RjgP+cQLctKRVdjA5xu
	13x2otNXuGaRLsW/KWKAkZUfRG7/g=
X-Received: by 2002:a05:600c:190b:b0:46e:3b1a:20d7 with SMTP id 5b1f17b1804b1-47117903f8bmr167609435e9.19.1761162048245;
        Wed, 22 Oct 2025 12:40:48 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEy+Eo/xxRScxUEKnSMiH68Eap1NqKqjxN/w+YYeBbE25Q45lbcy38dC2C5VTWzT9Wk28Nb6Q==
X-Received: by 2002:a05:600c:190b:b0:46e:3b1a:20d7 with SMTP id 5b1f17b1804b1-47117903f8bmr167609395e9.19.1761162047887;
        Wed, 22 Oct 2025 12:40:47 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3? (p200300d82f4e3200c99da38b3f3ad4b3.dip0.t-ipconnect.de. [2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-475c428a5bcsm59988735e9.7.2025.10.22.12.40.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Oct 2025 12:40:47 -0700 (PDT)
Message-ID: <73fc00c5-5626-43b0-be46-6b89a9004375@redhat.com>
Date: Wed, 22 Oct 2025 21:40:46 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: use folio_nr_pages() instead of shift operation
To: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20251004030210.49080-1-pedrodemargomes@gmail.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251004030210.49080-1-pedrodemargomes@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 04.10.25 05:02, Pedro Demarchi Gomes wrote:
> folio_nr_pages() is a faster helper function to get the number of pages when
> NR_PAGES_IN_LARGE_FOLIO is enabled.
> 
> Signed-off-by: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
> ---
>   virt/kvm/guest_memfd.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 7d85cc33c0bb..5fc5475cf826 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -77,9 +77,9 @@ static int kvm_gmem_prepare_folio(struct kvm *kvm, struct kvm_memory_slot *slot,
>   	 * The order will be passed when creating the guest_memfd, and
>   	 * checked when creating memslots.
>   	 */
> -	WARN_ON(!IS_ALIGNED(slot->gmem.pgoff, 1 << folio_order(folio)));
> +	WARN_ON(!IS_ALIGNED(slot->gmem.pgoff, folio_nr_pages(folio)));
>   	index = gfn - slot->base_gfn + slot->gmem.pgoff;
> -	index = ALIGN_DOWN(index, 1 << folio_order(folio));
> +	index = ALIGN_DOWN(index, folio_nr_pages(folio));
>   	r = __kvm_gmem_prepare_folio(kvm, slot, index, folio);
>   	if (!r)
>   		kvm_gmem_mark_prepared(folio);

FWIW

Reviewed-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


