Return-Path: <kvm+bounces-47693-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 82A1BAC3C67
	for <lists+kvm@lfdr.de>; Mon, 26 May 2025 11:08:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D3A4B1896E09
	for <lists+kvm@lfdr.de>; Mon, 26 May 2025 09:09:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66B7A1F3B83;
	Mon, 26 May 2025 09:08:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OwTWoZpZ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E14041F099C
	for <kvm@vger.kernel.org>; Mon, 26 May 2025 09:08:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748250503; cv=none; b=fEy5B34YwW4i9mMrLz6ahW+If28VDg63HRVph79bQn6Ck3oWKGEPps+1m1jSlfncG4Let7bmYSjJEANwn/2FWzOwzaGn6AOeAhIZfkdj0viQmF3tFYMQCYpK6cNLBnmVEnlUSuw3fk6KclwVT0JS9mmG9atnhuIGGFEUjKxWLzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748250503; c=relaxed/simple;
	bh=LaOoOuum53zSM/sg8L0CA7QpQCvdV+tHLGG+vx57rmg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bfGPtrT0L/F5DWELMtWKG3fwaKHlMU5emOdHwh7Gk9wuiXv7lDy81XUfCZGpk5m0Z25rT04Fg/Zmaw0R6tGLTH5TkCinV3togZT8IV3Pe0bOCU9cZfRN5cAnRma7irgWIxelkItFqOX+0xilJSLLf2HH8lu2u0RLvNB8XK1imx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OwTWoZpZ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1748250500;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=LQxCWuutrhRX1ozeQ1hSnlARkYaLf5Pk8UUtSEwfD18=;
	b=OwTWoZpZ77JnNatUVn1bRMtjroFzVnswUTPGLNDg0ej1LnZRJG/2E9wh1rG4bgr9vi4wlN
	FNvLzzVKqW6XLDPqmEVGwRrs1eBmfzVKZyXtihYbtsP1Z1LzHdxaekNXTFmRQDsNTwoy03
	zlxmp9yj4JVFxtzA0rf9l6Cvugl9sxo=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-31-1iWvgYG0PJy8sEa4ils-XA-1; Mon, 26 May 2025 05:08:19 -0400
X-MC-Unique: 1iWvgYG0PJy8sEa4ils-XA-1
X-Mimecast-MFC-AGG-ID: 1iWvgYG0PJy8sEa4ils-XA_1748250498
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-442cd12d151so16816835e9.1
        for <kvm@vger.kernel.org>; Mon, 26 May 2025 02:08:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748250498; x=1748855298;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=LQxCWuutrhRX1ozeQ1hSnlARkYaLf5Pk8UUtSEwfD18=;
        b=PkbgLyyUCB8PjHy2/dRjlBGQy04EloLrIRURkMdhTR2xYENkAFMZ5a6PaknwQPORRv
         lYL2r+Z0CaU3I8yKiVB6zubU5I4XtoAnG80Y1h8+q2fotEGME3olQ+a9fr3UXBujCqmp
         mDSqIs16ac/QkoQVeWgY7n9UjwJN6c7u0riDY7tmSZtjxvdrThdAfuuprYWUqyodbzDt
         U7mMBAoCKsC70SNYdWfWj8EhCBL3fjvUvZVHffO3DYqeDOS7Q0s9c3U7gKasCE0q2Sp3
         BuX5fNv2Ni7R8ZpQ9OgI8zUrA4Xq5bUOM7UQzQWfCdAbikZ757h3Su3fVeGSXnR2BIiF
         NpnA==
X-Forwarded-Encrypted: i=1; AJvYcCWbdjC/0LqGo6POFmyO5eeeGn5H9FB8qFaW3MNl7nCq11hr/3TjbHGd8Brdz06PoxjZHfg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy+FM9EfGSbN4L6xGk/p1xcXVujZKZ/klI71CWeS4508DM8jNgl
	TdSUfc4hGaOAq7se89vKgwtEU9RaIlNJmuu82tYM81XGsWtGgtN3/pOdPn7lqyVtfmLBc55A5qS
	2gCC6Kl5NKWuI/Ft8xEjqZ6cFc0r0koc9w6uALOZeD/29q8oRNH1b4Q==
X-Gm-Gg: ASbGncs558M4Pe07tOiZ6Fi1OvP2UnVywy/7BwaPPXFEaKU4LjCq44R1J9zNV9z7wuD
	8s+N43ZnhQ42iSXo8zNY2e8WHY3QVvsOO10SZynCP7VsLBxn2KBAoWeLBXAedP5y5gXnd4bxFmg
	vixYnwrc3XsGqlGgn7UjIIC6FhuURcOngc0QbWa++NpgtjK6nFF+LlBab6akRggRkXK0YXQMVnB
	UYmocklURfymI1KnBw+C6vjkX2KGLV1EHUpEHx3TJ1P+oIXafmA8JhIAeGH/HiT6TU2RKzm11RL
	M3WiJEhYhu4ZTefL1+ZbidTWRYBHv4soGSTJSCH2YWeeM5VbcGg+f1m4ZVMUyizbFAuJfnVTPlj
	g2yQKq2Djp+M0ly2QUzBl1Aqb6zWrpjcRKQeMSHs=
X-Received: by 2002:a05:600c:5286:b0:43b:c0fa:f9cd with SMTP id 5b1f17b1804b1-44c91ad6c06mr67951065e9.7.1748250497717;
        Mon, 26 May 2025 02:08:17 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEBNQlYC1hvLZSSmh6Jjv2kh2e5AJrTyiKyxY21nmxjLlkOjxliRfA3Bxef5aUzhLswspqfqQ==
X-Received: by 2002:a05:600c:5286:b0:43b:c0fa:f9cd with SMTP id 5b1f17b1804b1-44c91ad6c06mr67950705e9.7.1748250497280;
        Mon, 26 May 2025 02:08:17 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f19:6500:e1c1:8216:4c25:efe4? (p200300d82f196500e1c182164c25efe4.dip0.t-ipconnect.de. [2003:d8:2f19:6500:e1c1:8216:4c25:efe4])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-447f73d3edcsm236811905e9.20.2025.05.26.02.08.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 May 2025 02:08:16 -0700 (PDT)
Message-ID: <7af3f5c9-7385-432f-aad6-7c25db2fafe2@redhat.com>
Date: Mon, 26 May 2025 11:08:15 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 07/10] RAMBlock: Make guest_memfd require coordinate
 discard
To: Chenyi Qiang <chenyi.qiang@intel.com>, Alexey Kardashevskiy
 <aik@amd.com>, Peter Xu <peterx@redhat.com>,
 Gupta Pankaj <pankaj.gupta@amd.com>, Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Michael Roth <michael.roth@amd.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org,
 Williams Dan J <dan.j.williams@intel.com>, Zhao Liu <zhao1.liu@intel.com>,
 Baolu Lu <baolu.lu@linux.intel.com>, Gao Chao <chao.gao@intel.com>,
 Xu Yilun <yilun.xu@intel.com>, Li Xiaoyao <xiaoyao.li@intel.com>
References: <20250520102856.132417-1-chenyi.qiang@intel.com>
 <20250520102856.132417-8-chenyi.qiang@intel.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20250520102856.132417-8-chenyi.qiang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 20.05.25 12:28, Chenyi Qiang wrote:
> As guest_memfd is now managed by RamBlockAttribute with
> RamDiscardManager, only block uncoordinated discard.
> 
> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
> ---
> Changes in v5:
>      - Revert to use RamDiscardManager.
> 
> Changes in v4:
>      - Modify commit message (RamDiscardManager->PrivateSharedManager).
> 
> Changes in v3:
>      - No change.
> 
> Changes in v2:
>      - Change the ram_block_discard_require(false) to
>        ram_block_coordinated_discard_require(false).
> ---
>   system/physmem.c | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/system/physmem.c b/system/physmem.c
> index f05f7ff09a..58b7614660 100644
> --- a/system/physmem.c
> +++ b/system/physmem.c
> @@ -1916,7 +1916,7 @@ static void ram_block_add(RAMBlock *new_block, Error **errp)
>           }
>           assert(new_block->guest_memfd < 0);
>   
> -        ret = ram_block_discard_require(true);
> +        ret = ram_block_coordinated_discard_require(true);
>           if (ret < 0) {
>               error_setg_errno(errp, -ret,
>                                "cannot set up private guest memory: discard currently blocked");
> @@ -1939,7 +1939,7 @@ static void ram_block_add(RAMBlock *new_block, Error **errp)
>                * ever develops a need to check for errors.
>                */
>               close(new_block->guest_memfd);
> -            ram_block_discard_require(false);
> +            ram_block_coordinated_discard_require(false);
>               qemu_mutex_unlock_ramlist();
>               goto out_free;
>           }
> @@ -2302,7 +2302,7 @@ static void reclaim_ramblock(RAMBlock *block)
>       if (block->guest_memfd >= 0) {
>           ram_block_attribute_destroy(block->ram_shared);
>           close(block->guest_memfd);
> -        ram_block_discard_require(false);
> +        ram_block_coordinated_discard_require(false);
>       }
>   
>       g_free(block);


I think this patch should be squashed into the previous one, then the 
story in that single patch is consistent.

-- 
Cheers,

David / dhildenb


