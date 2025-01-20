Return-Path: <kvm+bounces-35994-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 412BAA16C07
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 13:06:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6DCAE163F7B
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 12:06:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29B091DF99B;
	Mon, 20 Jan 2025 12:06:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OQdTgaOb"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D413D1DEFFE
	for <kvm@vger.kernel.org>; Mon, 20 Jan 2025 12:06:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737374812; cv=none; b=mCA/V0idPloMm13yVU/G4mSV1hoH2diOrxL5TuYiloANrpSo3wezZRMtcrhhv9NuACl6OoeEtFcaDYzR5OBezWSIR/jDogKh2eO17ZNfVEyCu8YWNLOpnbiRZfWE8sIOKlyNzT3da187HsMfiSu0waq8tAKtZkUun2/1dvALRiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737374812; c=relaxed/simple;
	bh=Sur6MJWlZIqeg/rFl+mL3sU+tN/U/FA+Szn0X1gL+8o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Z3vm4pzc+00JM2Yd2WfDzY0S/KjqFMBuLRmGhHHljC9Kbo7DTGPtL3vr5+eLxd6ISETp7Zc8jbs6mMsaJE0kXpiSKB6WCDLfgqYhud+yE8MvXFQNRMTP4i65RVAejotZ3+7eYOLEiffz3KCoDds0jo+7u4aIzXU+cQ1LGjosdQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OQdTgaOb; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737374809;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=72ba0MjJUR1x91K6P/is/aJRUy5fIeddwn3W4Ob0+2c=;
	b=OQdTgaObZRCMaJzmedAs0+5KFUCi3eMdZ02/KYyHtprrj24cVofxvZaCUS5jUIhqrcPW2s
	c3F2TMMsrZNhaDIwphwYbxYIz1+M8TjRq+xr5fRkPRipsFB6Kj4Xji5nrIasRSd4+oXV+U
	KSd6VjOQ2vYMYxpmobpdvf02rPXhP1Y=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-278-AipiG4GQMuii6sWn-KG-iw-1; Mon, 20 Jan 2025 07:06:43 -0500
X-MC-Unique: AipiG4GQMuii6sWn-KG-iw-1
X-Mimecast-MFC-AGG-ID: AipiG4GQMuii6sWn-KG-iw
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-38a684a096eso1750729f8f.2
        for <kvm@vger.kernel.org>; Mon, 20 Jan 2025 04:06:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737374802; x=1737979602;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=72ba0MjJUR1x91K6P/is/aJRUy5fIeddwn3W4Ob0+2c=;
        b=wd4gYyWwXqyEes+tiOYkA1HYUFKCyz99MpNazD+CXgjIOkEl1yYsS6n2QyIBCopemh
         GDkd8Bxx2PWbfLCp/lh33v4At3B9hiFDl3urcjzjYXFC+inzq94nBiYdwzaQ5VCjwNIx
         4qImBzaFfMSlOTXDKjpHNead/gJWnTsCTO/NVGhsZMQJjZap+GS5te/MJEMD3IvaL4Yq
         mNXDj5AVS5ZG3JInzpQ2J7U1ZIfxMFt5+To3VtWhuZeDsCg9PlYvdGGWXsDIwaFZ6VxA
         5/jGNpse29vwsUJd9UDVqBpIL+FjBK6eNMRbHy+tLJs/PHDa03CvSpYVzZB3HqzdMDRM
         IhLg==
X-Forwarded-Encrypted: i=1; AJvYcCU9NhpEamjBOYAhoP9xJRTFKWxgK21DB39BhI9Jm98gwdcWw+3DmZKVqBFORJi/vv4v/EQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YzKk9u/0XTtHNsNK9iy5tUuGTj1UqrhoU6Nyh89JiG8WeXBDUng
	X8lPYh/w0A/gVjDuBKoIaUxVfOFXQCTxuMrDIMIBnCwWmFxa8uGpQueM6zlSBhjkdEqcKFCvk0Z
	K5dgySldHasN5GWR0YEWIRAxaPqOtuOITF/ZYnH3XRM+Z3y6sAQ==
X-Gm-Gg: ASbGncu4D3BN/TPCidIoa3tUeWrXeIoMj+IrZepOxmT2FZx7B9FjYjtA5XrVzAJJv94
	SJHUpVwNBnAQyBoYNeFPyraJE7vs5bodEMhnAKI8SZ1NHoYQbTO907CO+eK1KihIs+WiExFOY87
	pA9znryRYQ4Culk9fI40FXiwBLtjBGpNX/1S+Hv8XLqrhB5OZEO+W1QwiW3fzK1VX6zDeJGeJjE
	djTNsxyiUGiPwbjx6nkSrpm3P1BdUbL88Dg+Z5nPrcJF4/A8QEW7S7BxhpIb9FcQxgKo/8N7CGd
	NU6PYroDO7sMHD0esj/l7mhIB4fAhQ52JldS9CRN7F+BcZkzSZWB43h0CpO9tSDnAU5uZsZ5Nyk
	Fqri9C9Un37sMwX4PV73P1g==
X-Received: by 2002:a5d:5256:0:b0:386:1cd3:8a03 with SMTP id ffacd0b85a97d-38bf57a2079mr8754134f8f.32.1737374801955;
        Mon, 20 Jan 2025 04:06:41 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF5Gu3viSkRCW0ZB6VOdgGS/fHgN6E3Rfw3X3LsM+Q3M5bOEsBqq+vZ4cx/yg4911KYxmF+cw==
X-Received: by 2002:a5d:5256:0:b0:386:1cd3:8a03 with SMTP id ffacd0b85a97d-38bf57a2079mr8754106f8f.32.1737374801489;
        Mon, 20 Jan 2025 04:06:41 -0800 (PST)
Received: from ?IPV6:2003:d8:2f22:1000:d72d:fd5f:4118:c70b? (p200300d82f221000d72dfd5f4118c70b.dip0.t-ipconnect.de. [2003:d8:2f22:1000:d72d:fd5f:4118:c70b])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38bf32845e8sm10398460f8f.97.2025.01.20.04.06.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Jan 2025 04:06:40 -0800 (PST)
Message-ID: <3e2a6060-6e53-4f89-8392-ff6080b30504@redhat.com>
Date: Mon, 20 Jan 2025 13:06:38 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 01/15] KVM: Do not restrict the size of KVM-internal
 memory regions
To: Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, frankja@linux.ibm.com,
 borntraeger@de.ibm.com, schlameuss@linux.ibm.com, willy@infradead.org,
 hca@linux.ibm.com, svens@linux.ibm.com, agordeev@linux.ibm.com,
 gor@linux.ibm.com, nrb@linux.ibm.com, nsg@linux.ibm.com, seanjc@google.com,
 seiden@linux.ibm.com
References: <20250117190938.93793-1-imbrenda@linux.ibm.com>
 <20250117190938.93793-2-imbrenda@linux.ibm.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20250117190938.93793-2-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 17.01.25 20:09, Claudio Imbrenda wrote:
> From: Sean Christopherson <seanjc@google.com>
> 
> Exempt KVM-internal memslots from the KVM_MEM_MAX_NR_PAGES restriction, as
> the limit on the number of pages exists purely to play nice with dirty
> bitmap operations, which use 32-bit values to index the bitmaps, and dirty
> logging isn't supported for KVM-internal memslots.
> 
> Link: https://lore.kernel.org/all/20240802205003.353672-6-seanjc@google.com
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Reviewed-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
> ---
>   virt/kvm/kvm_main.c | 10 +++++++++-
>   1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index a8a84bf450f9..ee3f040a4891 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1966,7 +1966,15 @@ static int kvm_set_memory_region(struct kvm *kvm,
>   		return -EINVAL;
>   	if (mem->guest_phys_addr + mem->memory_size < mem->guest_phys_addr)
>   		return -EINVAL;
> -	if ((mem->memory_size >> PAGE_SHIFT) > KVM_MEM_MAX_NR_PAGES)
> +
> +	/*
> +	 * The size of userspace-defined memory regions is restricted in order
> +	 * to play nice with dirty bitmap operations, which are indexed with an
> +	 * "unsigned int".  KVM's internal memory regions don't support dirty
> +	 * logging, and so are exempt.
> +	 */
> +	if (id < KVM_USER_MEM_SLOTS &&
> +	    (mem->memory_size >> PAGE_SHIFT) > KVM_MEM_MAX_NR_PAGES)
>   		return -EINVAL;
>   
>   	slots = __kvm_memslots(kvm, as_id);


Reviewed-by: David Hildenbrand <david@redhat.com>

-- 
Cheers,

David / dhildenb


