Return-Path: <kvm+bounces-56178-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D1BB7B3AB39
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 22:02:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 87E13A00BD0
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 20:02:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDC0A27934E;
	Thu, 28 Aug 2025 20:02:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IR/4/nDL"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 653AE11187
	for <kvm@vger.kernel.org>; Thu, 28 Aug 2025 20:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756411329; cv=none; b=j4o5uT740YsaJmcjRU2QC0beQLY4qOWhH58/F2MQ9cYoikQDc64AxaXEHSwFgq6wl8EPmyGzaLwYJXvEc15Diw5kS1gJeDt6YC21zpIfWEGcDv2BdWLSwaX9pWfRcyb7BZ5MgbGIRMkmEWAXYMuFng/xJwEatqpvl7mDUnZIQQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756411329; c=relaxed/simple;
	bh=2KpL/YbmEXnHuFTvSMBKGQC8nuR4dgX0UfBNcS0nW2A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HHxq97H9xQWZtHGrwMFRUeYpXo7L32Em+Jr8LwUjES3CsszF084pqSla0C2XY6e3xgkAJMwT5Mck+VNqDqlAhD90nmoMTHieET1nN5ZKEOI50Rh1NExxpCH4nOZglisuoBMzSgfqzQj8+Li70KM6Fp3SaPSevnGySutnw0Hqxl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IR/4/nDL; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756411326;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=kHCGitpqD+5wH/FOTflpYSjcwP5kCCQ1zm861x/hElE=;
	b=IR/4/nDLZRjRnOPaqnPgKt5Hei85CNKICXX75cdvOtiKEazkzFs11XTOfHhl7a3FImej9u
	NOH3odZmk8gUoQB6wCnMQHjT37990hVeMRog4s3pLsE4HCdPJ3FrIaUu1YWcxx0w72/yeG
	Zm3witYdHq6EVgmW4fZ+pzc4vSfE4Z4=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-644-sQPyD2YWMvS_nQV-9Ze2BA-1; Thu, 28 Aug 2025 16:02:04 -0400
X-MC-Unique: sQPyD2YWMvS_nQV-9Ze2BA-1
X-Mimecast-MFC-AGG-ID: sQPyD2YWMvS_nQV-9Ze2BA_1756411321
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3c6abcfd303so167550f8f.3
        for <kvm@vger.kernel.org>; Thu, 28 Aug 2025 13:02:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756411321; x=1757016121;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kHCGitpqD+5wH/FOTflpYSjcwP5kCCQ1zm861x/hElE=;
        b=FAAOtbLtXO2QMMzfhb3GmR8u6NspqBLBcwsGMygATzAde5rs2Kb5A/YvaFRYpVYs1l
         mCUd/vjVh/U8+LKK29o2f5APc0oSKkYMHIOKZiRynCiKnBRYQ+C56jqvML4TMr6oB+uE
         Zax3tJULZDXeyiry5z4swuHmPzN3VWbdph3kpqdzKyTLHe0mgzJpiCNH39r/88EEc0E+
         CFnpTxz1H9ggk9nfiXopoiwbX+GCR6fsAwgxDCJ1rT+r2iL6zfKpyMYQq7YtElJynPOx
         bxz6ZBev9mSo+NlxrjoT/lwJ+c6kX4RmOxjIlqqdg3Ezno/GLzKzh38Ng/IXbx1Hb9vn
         6D6w==
X-Gm-Message-State: AOJu0YzvnSuyG9ewIN3XijSeYuJ9LrZEvSULe2s2au2Tijxe5YlVtVvE
	lEcOxc8RwUic5rkRjpqaQw59knFHg/kD3LMkyENP8Mdv+Ct42VjGNPds582Iyae+KC7eNBfN8IF
	55o6b+ZE2rE5vNYEiV2l5Xqf01KtGa4XK72bzK12p1R36Xh0m5uWiVw==
X-Gm-Gg: ASbGnctl0daPgzRDPVq4IgwjQeqfgWcEOoOChXECStpidR/wb50y5zJDT2BbQnXtpVs
	1Nq58Mhvgw/MxqYKfRkHVvZ29ojndgomEfoU3wLH83a91wXsPI/2UzSIAJ0NqO/a+adcsMZF0/a
	NaomBZRd5XYVd7Vhof5NqujRBDn0A/jmTLEY/ocjeVrwu+ywuc9uDjewRCQ96Ujm0a+A2koAknY
	EEI3IwJpnqzQPjOeEdPbrwTRtzLpbP4IjZmPRU3jPKz90G3fyvX6MqEhmvHPdpDgh+3818eWq6a
	Tiqr9jWhVKSxvzc53vfkgctbRmZjtnRAPzvzjW/Ke86u8H/Y41hOXpy6vXLsH++Lxv/9FQy0nEq
	piFTTLlmsyn1qQMCBBoDLvyjx/VDfIjVz2zE+kel6JelKWYZJZHxx7mNSoOoYhFE21dw=
X-Received: by 2002:a05:6000:2203:b0:3c9:9b3b:53c9 with SMTP id ffacd0b85a97d-3c99b3b586fmr13112442f8f.44.1756411320640;
        Thu, 28 Aug 2025 13:02:00 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFJfxknfutCFzm6P/qKfs5UtdmvpY/7sBFiB6PROkHg4xXnNZaYtYUH5wqWfppKoahFU7sb6A==
X-Received: by 2002:a05:6000:2203:b0:3c9:9b3b:53c9 with SMTP id ffacd0b85a97d-3c99b3b586fmr13112421f8f.44.1756411320141;
        Thu, 28 Aug 2025 13:02:00 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f28:c100:2225:10aa:f247:7b85? (p200300d82f28c100222510aaf2477b85.dip0.t-ipconnect.de. [2003:d8:2f28:c100:2225:10aa:f247:7b85])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b73cf86f4sm67580865e9.6.2025.08.28.13.01.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Aug 2025 13:01:59 -0700 (PDT)
Message-ID: <d58425d4-8e4f-4b70-915f-322658e9878e@redhat.com>
Date: Thu, 28 Aug 2025 22:01:58 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/2] KVM: guest_memfd: add generic population via write
To: "Kalyazin, Nikita" <kalyazin@amazon.co.uk>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "shuah@kernel.org" <shuah@kernel.org>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "michael.day@amd.com" <michael.day@amd.com>,
 "jthoughton@google.com" <jthoughton@google.com>,
 "Roy, Patrick" <roypat@amazon.co.uk>, "Thomson, Jack"
 <jackabt@amazon.co.uk>, "Manwaring, Derek" <derekmn@amazon.com>,
 "Cali, Marco" <xmarcalx@amazon.co.uk>
References: <20250828153049.3922-1-kalyazin@amazon.com>
 <20250828153049.3922-2-kalyazin@amazon.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250828153049.3922-2-kalyazin@amazon.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 28.08.25 17:31, Kalyazin, Nikita wrote:
> write syscall populates guest_memfd with user-supplied data in a generic
> way, ie no vendor-specific preparation is performed.  This is supposed
> to be used in non-CoCo setups where guest memory is not
> hardware-encrypted.
> 
> The following behaviour is implemented:
>   - only page-aligned count and offset are allowed
>   - if the memory is already allocated, the call will successfully
>     populate it
>   - if the memory is not allocated, the call will both allocate and
>     populate
>   - if the memory is already populated, the call will not repopulate it
> 
> Signed-off-by: Nikita Kalyazin <kalyazin@amazon.com>
> ---

Just nothing that checkpatch complains about

a) Usage of "unsigned" instead of "unsigned int"

b) The From doesn't completely match the SOB: "Kalyazin, Nikita" vs 
"Nikita Kalyazin"

-- 
Cheers

David / dhildenb


