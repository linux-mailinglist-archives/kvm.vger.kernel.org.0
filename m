Return-Path: <kvm+bounces-51563-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D0CBAF8C61
	for <lists+kvm@lfdr.de>; Fri,  4 Jul 2025 10:46:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EFDC416B10B
	for <lists+kvm@lfdr.de>; Fri,  4 Jul 2025 08:46:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4117028BA8B;
	Fri,  4 Jul 2025 08:41:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fopQ/fMF"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA84A28B3E2
	for <kvm@vger.kernel.org>; Fri,  4 Jul 2025 08:41:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751618510; cv=none; b=Hn6cZfYim5wKcr1s8smAfRTDxavQZ25U6tgBn9dtJdE8thM3PidCBEeJGqu3Z4wzM2IzW7lHHlL3n4Bcjq2yKSz5CaQpfcJEyj3cIdSoN/5oSjwG0YNlgpSH7XzSeitsVIMbvCnzfQP5hgiAfkO+eaPRNyqFor7zfAwgJngPnNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751618510; c=relaxed/simple;
	bh=U290KhS+sQvMO857eG6/+pLQ1yd/ze9A03Sz9p5GymU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mRoWizKQ6McMJYpNaQ8GqsUQX8aZMqGvA1QU+QiM5mZ3iTu1HaReHV8PHIiQJFaJ2QZh7FqcR5H3ul729BmtLggZXTvz23LABrzvHepTkjlhCiGB+BgZOQZ7bC4wUFE5xcuRNLP89k/EbsnSLKl3QbM7uicmKyz7/ehyuIBqbbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fopQ/fMF; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1751618506;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=DtiG2g8/+dbJ0SRACiMmc2C5udd730N4XdleYm8ejAE=;
	b=fopQ/fMFmA3A/fh+IniZFSdVTBuqz2RQm708gJl8xirnGCYQb4JIbS1O9+8+KfgjrH5d7M
	oyLhR24XOOCzfrXZ2UvmDNzWrF2uK4jQqRr1sctJzH21lIyi6hSpnmQ3tPeCrRjZQ/aeK0
	S6A92mU4ak69eiV7th3a4ISgAw2PFXQ=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-468-jivtpXchO52VpQAEy9XLhw-1; Fri, 04 Jul 2025 04:41:45 -0400
X-MC-Unique: jivtpXchO52VpQAEy9XLhw-1
X-Mimecast-MFC-AGG-ID: jivtpXchO52VpQAEy9XLhw_1751618504
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4536962204aso2700465e9.3
        for <kvm@vger.kernel.org>; Fri, 04 Jul 2025 01:41:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751618504; x=1752223304;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=DtiG2g8/+dbJ0SRACiMmc2C5udd730N4XdleYm8ejAE=;
        b=X6OCStZQWmbUo2BvOT9j1syvvbIWBimWHWcjUlI4zlwiTlhpBlnHqgIsGiV339R0Kn
         ZMZuk3con3UjJxKJx47kXh0GtLP+U+gtzA02SjfEtQQ5itY+MfyvpI+NTiF369blqyxZ
         IUHJ+2rQG0eJ5zBESR+XO29ix6Uu+5WtEQYpTMeRUq4dF+491PoFssYZ+7C0h71e8VbC
         7qv01WY6ajft+uMQG5J5aRLOA653gQgZuiyDRN6PiUpAuqC0BDCcTwEqbve8pnmhUjUR
         01u0HHGdb9GvSu/egc+XaI9jCW9V+X31rRLhxCZfaSrlT1rcu6yz20fjuAmQE5OejG+E
         0jsg==
X-Gm-Message-State: AOJu0YycwuI7X5jsk38Kc2MHLCAToCfdaBM/Lmn8IamMHkj22GwKuRPC
	nxhgDY6NaGfw/7PxGm8317IoHqBJWe6UKmBeYQrOO6z6S1kpnje1CCb91SqcWMd7cq70I4zVomb
	h4hYA81vt6LbPGQCfXJ5SnuyKSsjyRHGdmtC2cQJK909yEAQek+yY6Q==
X-Gm-Gg: ASbGncsBHPXDs/kjKWw91QJPwKDxCiitZgBplvKqihfRTVGGvnkAwIlrdJt+UnC7p/a
	lf4ogK83XxKjB56AOeloXC9yMYTkbJikaV/7Y/qZIpaX42fhMXIsQ0wRj7S55LKaf8mXQgudgb+
	cL6z7HFMjgxbfJiJ9p8kmZPBOsQfyUkq6h8Q/W/Lg4FwOMbxaBICTqH0l8n5J1C7lMeniBdaoW6
	laekXmg3R5GZeobtJlrZj/a7sDsrXxqNRKql7tRH1/SKwG0ON6yt/32tP5TFVQ/7x4+fcy3pRdT
	jkJI/65mwO1+lvLUmqNtn4g2Mzl8cTZN3WImgeCDkzw4J6Rh6epxZRXZduk64ot1N/adaUY9N6o
	Jb58LIL7s53oNvi6CItMEEVY4LifJ20csfJeyhfwPNZg5xHw=
X-Received: by 2002:a05:600c:4ed1:b0:453:1058:f8aa with SMTP id 5b1f17b1804b1-454b4e7d051mr13519345e9.15.1751618503771;
        Fri, 04 Jul 2025 01:41:43 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHf48etFOJwEGYaWEt7WrZh4RJh7lnUUC4K0ZRVjz1wBiG8LdBhaSPsGLY+hT98h8z32cI4Ow==
X-Received: by 2002:a05:600c:4ed1:b0:453:1058:f8aa with SMTP id 5b1f17b1804b1-454b4e7d051mr13519025e9.15.1751618503395;
        Fri, 04 Jul 2025 01:41:43 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f2c:5500:988:23f9:faa0:7232? (p200300d82f2c5500098823f9faa07232.dip0.t-ipconnect.de. [2003:d8:2f2c:5500:988:23f9:faa0:7232])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b471b96731sm1899752f8f.55.2025.07.04.01.41.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Jul 2025 01:41:42 -0700 (PDT)
Message-ID: <8806f687-12e4-4456-a7b6-ecdc5adc9f2e@redhat.com>
Date: Fri, 4 Jul 2025 10:41:41 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/5] vfio/type1: optimize vfio_pin_pages_remote()
To: lizhe.67@bytedance.com, alex.williamson@redhat.com,
 akpm@linux-foundation.org, peterx@redhat.com, jgg@ziepe.ca
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20250704062602.33500-1-lizhe.67@bytedance.com>
 <20250704062602.33500-3-lizhe.67@bytedance.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20250704062602.33500-3-lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


>    * Attempt to pin pages.  We really don't want to track all the pfns and
>    * the iommu can only map chunks of consecutive pfns anyway, so get the
> @@ -680,32 +724,47 @@ static long vfio_pin_pages_remote(struct vfio_dma *dma, unsigned long vaddr,
>   		 * and rsvd here, and therefore continues to use the batch.
>   		 */
>   		while (true) {
> +			long nr_pages, acct_pages = 0;
> +
>   			if (pfn != *pfn_base + pinned ||
>   			    rsvd != is_invalid_reserved_pfn(pfn))
>   				goto out;
>   
> +			/*
> +			 * Using GUP with the FOLL_LONGTERM in
> +			 * vaddr_get_pfns() will not return invalid
> +			 * or reserved pages.
> +			 */
> +			nr_pages = num_pages_contiguous(
> +					&batch->pages[batch->offset],
> +					batch->size);
> +			if (!rsvd) {
> +				acct_pages = nr_pages;
> +				acct_pages -= vpfn_pages(dma, iova, nr_pages);

I'm not familiar with the vpfn_pages() part, but the other stuff LGTM.

-- 
Cheers,

David / dhildenb


