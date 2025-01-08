Return-Path: <kvm+bounces-34845-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0783CA0673B
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 22:35:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 864E518894C9
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 21:35:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4768520408A;
	Wed,  8 Jan 2025 21:34:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="V7i6lvz9"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2A9518D626
	for <kvm@vger.kernel.org>; Wed,  8 Jan 2025 21:34:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736372095; cv=none; b=utYSjiciO/XhXKzFtD7psLjNhvfcVEIiLA9sjMtm/AkkS0b5m25fXr+bg7QgWd4fMKpVNWZ4JZdzSQLxr9IybmyJM16bmeuFBjNeKoiQTBcjYsiBTf56dVHftuPOXg30QHjVLJgJNn++18wifCsaA44slxqexVF1lhqNnMWJ8+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736372095; c=relaxed/simple;
	bh=8D7+YDCS6m2B9nOwtVTbVXmna86sg9oGSxnAP52jnho=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KdVffe6AzD8lTmo+Kn+ND2dfUrpaXXW/gJVXbMxtCfCfk4pBmIY1eIpwDOHJ6gp7K01xADKqoJKXJ+YIn77hxoFtds39jVxm3KfdAiIol16PI82DGoU9wGJouLGziek8ghnVG/x2Jv9K6Sft894yOrnQ75X4zBoRYvdsvn7d9eU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=V7i6lvz9; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736372092;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=41M+R/XKCImcVpiXngXcgQ/wxhxdyEth/DA3pcD/uAY=;
	b=V7i6lvz9QD7/LcH9zxqmwaKd5qPfKltKgmSWhzG2lAKe0d2OURjN/dH1e7NC7pdzMp7dV2
	OzQ+dHuTHHsdLDJW4jQYT8SFmXTvdRg3vn/p+ZgTQN6ZgUaE19+55qTJb9ZX5xmhJaFDse
	9l5Y3O+hzXNZjW4yafMbKEYkK/QG8dk=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-449-kaKw_RjHOI2W_GfsqjKLVg-1; Wed, 08 Jan 2025 16:34:51 -0500
X-MC-Unique: kaKw_RjHOI2W_GfsqjKLVg-1
X-Mimecast-MFC-AGG-ID: kaKw_RjHOI2W_GfsqjKLVg
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-385e03f54d0so76685f8f.3
        for <kvm@vger.kernel.org>; Wed, 08 Jan 2025 13:34:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736372090; x=1736976890;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=41M+R/XKCImcVpiXngXcgQ/wxhxdyEth/DA3pcD/uAY=;
        b=xN0w1sZ/DluGwoBMwpANTnyjeAHLFbdlJqd3xFs2JnDEKhePyOjMwhTbnGGcc7na0O
         QeHud5b+748viNgoJ0WqBUe70JcHeqgZbz1rDxlX4W30aeH9dgoSyU48l+MuaCveCieV
         HyQe72vl3it6QwmGNKIm+mUOJ0i/Eu3Z5Saw+YAifD3vC30SlsKW4EBZ3ghgiStMybVA
         UO+V3QhvZ5/5DmFXrsBUBvzBl1/FTNyVnBkDbhomm5hJbhXEzWrtNHBX8WvBzN/1ydy3
         qP1fF45tj26itggsZhlLBOeQLvBSXTKZc8qBBAIh+A+Fb9hl2KTnzZX8GlJYZ2E17579
         hG+A==
X-Forwarded-Encrypted: i=1; AJvYcCWHyJXGeW606unK565bKXSYEpCSXoi2c5uwQVIqoa1SoqVILlklFXvQ/gkDm1y2xUmYWcU=@vger.kernel.org
X-Gm-Message-State: AOJu0YwrpFvG+VQKDGCbqI0d14E1ZSC1cpDMnpzp2D6CEkcuVUauXRHg
	8XTb92FsRBO+Pr2gL9FPvuB5l5nwcx0zCxWxEP8QABFuERBfbLLtmE9ArViwJsHpTVRYxSUl2pN
	h9G+1YGY152FYLsZRYeGfdNLENp8ejxKdGcRVkhNOSzoNebAcwg==
X-Gm-Gg: ASbGnctdbZsJsCBhqY0SQxx3wu7EdlIYvgzYKR1+6UUAToaIQqu5NyV0QU/p0cXRNcX
	RrXbA/B33+6gtPgr/5H58IZPvOd/WsGH+TMr/Lf25pPRxDGFLZwg55skW6XZVLTljoUum4SPKoz
	cOLuXi7cmm8LtS4Txsig36sSINJWy+XczuP6LFg/ea7ESXTrICUkjoWRTF9kgeLRFhyLHz/QxQu
	CEGAr3SWrp/Pg3wouKVnPSjbF1Ib49BiXrE7fo3yKLs1vUC27xenEHQP8F1Z+yYd/H6AnaIk3aX
	Cnr4t/BnjZYVIG0iLZHPD5FAy6MMIuRFbFFUQZ3C9aANp5NHT083xmMVSZxN4MdLsVVVB1vuDOs
	nICvI1Q==
X-Received: by 2002:a05:6000:1a85:b0:385:e0d6:fb48 with SMTP id ffacd0b85a97d-38a872f6f22mr3585461f8f.7.1736372090206;
        Wed, 08 Jan 2025 13:34:50 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEb3cbHq2ETie7LVaxVOhPaqZj91QSORGfs8AUXFme7GEmdJD1HTMJ71G/up3Uu3f2wI8hTSQ==
X-Received: by 2002:a05:6000:1a85:b0:385:e0d6:fb48 with SMTP id ffacd0b85a97d-38a872f6f22mr3585426f8f.7.1736372089356;
        Wed, 08 Jan 2025 13:34:49 -0800 (PST)
Received: from ?IPV6:2003:cb:c70d:3a00:d73c:6a8:ca9f:1df7? (p200300cbc70d3a00d73c06a8ca9f1df7.dip0.t-ipconnect.de. [2003:cb:c70d:3a00:d73c:6a8:ca9f:1df7])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38a1c89e2f9sm55147455f8f.81.2025.01.08.13.34.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jan 2025 13:34:48 -0800 (PST)
Message-ID: <a00d6d67-c0a1-4d54-9932-bf3b3a7054d8@redhat.com>
Date: Wed, 8 Jan 2025 22:34:47 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/7] hwpoison_page_list and qemu_ram_remap are based on
 pages
To: =?UTF-8?Q?=E2=80=9CWilliam_Roche?= <william.roche@oracle.com>,
 kvm@vger.kernel.org, qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc: peterx@redhat.com, pbonzini@redhat.com, richard.henderson@linaro.org,
 philmd@linaro.org, peter.maydell@linaro.org, mtosatti@redhat.com,
 imammedo@redhat.com, eduardo@habkost.net, marcel.apfelbaum@gmail.com,
 wangyanan55@huawei.com, zhao1.liu@intel.com, joao.m.martins@oracle.com
References: <cf587c8b-3894-4589-bfea-be5db70e81f3@redhat.com>
 <20241214134555.440097-1-william.roche@oracle.com>
 <20241214134555.440097-2-william.roche@oracle.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20241214134555.440097-2-william.roche@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 14.12.24 14:45, “William Roche wrote:
> From: William Roche <william.roche@oracle.com>

Subject should likely start with "system/physmem:".

Maybe

"system/physmem: handle hugetlb correctly in qemu_ram_remap()"

> 
> The list of hwpoison pages used to remap the memory on reset
> is based on the backend real page size. When dealing with
> hugepages, we create a single entry for the entire page.

Maybe add something like:

"To correctly handle hugetlb, we must mmap(MAP_FIXED) a complete hugetlb 
page; hugetlb pages cannot be partially mapped."

> 
> Co-developed-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: William Roche <william.roche@oracle.com>
> ---
>   accel/kvm/kvm-all.c       |  6 +++++-
>   include/exec/cpu-common.h |  3 ++-
>   system/physmem.c          | 32 ++++++++++++++++++++++++++------
>   3 files changed, 33 insertions(+), 8 deletions(-)
> 
> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
> index 801cff16a5..24c0c4ce3f 100644
> --- a/accel/kvm/kvm-all.c
> +++ b/accel/kvm/kvm-all.c
> @@ -1278,7 +1278,7 @@ static void kvm_unpoison_all(void *param)
>   
>       QLIST_FOREACH_SAFE(page, &hwpoison_page_list, list, next_page) {
>           QLIST_REMOVE(page, list);
> -        qemu_ram_remap(page->ram_addr, TARGET_PAGE_SIZE);
> +        qemu_ram_remap(page->ram_addr);
>           g_free(page);
>       }
>   }
> @@ -1286,6 +1286,10 @@ static void kvm_unpoison_all(void *param)
>   void kvm_hwpoison_page_add(ram_addr_t ram_addr)
>   {
>       HWPoisonPage *page;
> +    size_t page_size = qemu_ram_pagesize_from_addr(ram_addr);
> +
> +    if (page_size > TARGET_PAGE_SIZE)
> +        ram_addr = QEMU_ALIGN_DOWN(ram_addr, page_size);

Is that part still required? I thought it would be sufficient (at least 
in the context of this patch) to handle it all in qemu_ram_remap().

qemu_ram_remap() will calculate the range to process based on the 
RAMBlock page size. IOW, the QEMU_ALIGN_DOWN() we do now in 
qemu_ram_remap().

Or am I missing something?

(sorry if we discussed that already; if there is a good reason it might 
make sense to state it in the patch description)
-- 
Cheers,

David / dhildenb


