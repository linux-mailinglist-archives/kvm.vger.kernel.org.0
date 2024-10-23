Return-Path: <kvm+bounces-29464-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 566D19AC031
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 09:28:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 124D92815C0
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 07:28:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF8121547D5;
	Wed, 23 Oct 2024 07:28:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="W/7KjDeC"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DBBF1547E4
	for <kvm@vger.kernel.org>; Wed, 23 Oct 2024 07:28:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729668532; cv=none; b=FpuAwEERlXxIrUS99cyRfvRwY3IR+9Z5kI3MfyomXMsIHDHju6jtTOZDIOaIaQQ9bwT2qL0b4dS03cBicNFWOtUkfs4XxwbJgK2ImD4y7MM6oCTH9fFxarKQG3LoX629wNptcEGspIIAbNUy4IOoiSzdX7xfYNUbmrbjGpHZbdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729668532; c=relaxed/simple;
	bh=tQy7Z/wXQN4bQ5hmaRyeOHr78J2Jpa8mKsqNYYeOX6w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LkiTtGt2WLhcYsXaooBrx8O9KpvvBqw2dSLSEQhujE2QYbizT9ip3ErVNY22Xb8zsZ0llISiRtKGO8eAczVlf0jASTbwtfd6M/70oMM8h9kWHmHtBXh7heN5MmPtCkxaSnbUf4K94rlJQVi447rqYz0cNCISw+1c1LiLSKMdCic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=W/7KjDeC; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729668528;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=n3bFd8/vbccyYuQYQ2+btECDTQp1eTA3rb9KvkPx0Ts=;
	b=W/7KjDeCOwZjSdSohkjoDY8Te22Jy3cAoo8MGZHQ06FuP8nu1YbciT0efMZAKH4qsCxNcq
	7ei4bCKEnXKXxp+35oqayXp72/d9FPvnSBb4iKhYIFalf1I5KB2W8x6naA8R+NHTEvFnOY
	qXOg69UvG+Yd1G2q1asrGU5HefryZf8=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-659-Bci_mFFIOXiaWSRaKcZs-Q-1; Wed, 23 Oct 2024 03:28:47 -0400
X-MC-Unique: Bci_mFFIOXiaWSRaKcZs-Q-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4315b7b0c16so47655625e9.1
        for <kvm@vger.kernel.org>; Wed, 23 Oct 2024 00:28:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729668526; x=1730273326;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=n3bFd8/vbccyYuQYQ2+btECDTQp1eTA3rb9KvkPx0Ts=;
        b=YvCn/ZMcSrBLfNVWeZ2AA5to9d0b/+8OsAlCrJdEwB4KIHMKmz8IAsyeLlL7gTF9f2
         vReDyIZRCb1o66fQDIS6753iAWR4h1u6bK6mYNQokOdc5I/smbcq7rFEYvEjYHH/N+Hx
         b01K1NV++jce1mskHV/xt9Fm1M4z3xtThir1jO2WDyHDNXVwamGMeec9d1uASLfym52B
         feiQw/Zot6/XPoYBwFEdQUyYkAB8FopWuzeXtJFK6X5Er0w44XOqUSVzYcmr7lExVs4T
         kxx8GmmhV/+AuX0sCCjxhbnypXgWJdKu8IbKSofOC86erP+mEDP970NPaP48wLPanX7n
         G6lg==
X-Forwarded-Encrypted: i=1; AJvYcCV8Op3c4WIkJVsq+ucr4HoBGRsqNXQs7AXjaBVdK9WLcDxynDam4Di34fnYa1HB9ZA9hVI=@vger.kernel.org
X-Gm-Message-State: AOJu0YwWOYMfwXBdso53c79/ZqBF5kWj1viQAv5AMre8DR7OUd6q7wqC
	t/20zTtBV3Yn+soYTwkEgw1YqLWk9OQkBJ4S9y5hc9HrmcXfo2Q8XF5XlKCZLwBeCBP2qvpXfUW
	iHjwmQnatruhbvO479ShrI0JczYm/FMCp9r9+k5KRLJh9pSBzGg==
X-Received: by 2002:a05:600c:4fc6:b0:42c:ba1f:5482 with SMTP id 5b1f17b1804b1-431841b6110mr9953585e9.35.1729668525963;
        Wed, 23 Oct 2024 00:28:45 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFSQp7KFRiSfNAAWWy/79lbw+H+eUimxk+XUNKNGd4tlk0i5h/4iB14tXJZmIuKHVr5wY98NA==
X-Received: by 2002:a05:600c:4fc6:b0:42c:ba1f:5482 with SMTP id 5b1f17b1804b1-431841b6110mr9953385e9.35.1729668525405;
        Wed, 23 Oct 2024 00:28:45 -0700 (PDT)
Received: from ?IPV6:2003:cb:c70c:cd00:c139:924e:3595:3b5? (p200300cbc70ccd00c139924e359503b5.dip0.t-ipconnect.de. [2003:cb:c70c:cd00:c139:924e:3595:3b5])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43186c3a7a1sm8161615e9.32.2024.10.23.00.28.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Oct 2024 00:28:45 -0700 (PDT)
Message-ID: <a0fda9e7-d55b-455b-aeaa-27162b6cdc65@redhat.com>
Date: Wed, 23 Oct 2024 09:28:43 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 2/4] accel/kvm: Keep track of the HWPoisonPage
 page_size
To: =?UTF-8?Q?=E2=80=9CWilliam_Roche?= <william.roche@oracle.com>,
 peterx@redhat.com, pbonzini@redhat.com, richard.henderson@linaro.org,
 philmd@linaro.org, peter.maydell@linaro.org, mtosatti@redhat.com,
 kvm@vger.kernel.org, qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc: joao.m.martins@oracle.com
References: <ZwalK7Dq_cf-EA_0@x1n>
 <20241022213503.1189954-1-william.roche@oracle.com>
 <20241022213503.1189954-3-william.roche@oracle.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20241022213503.1189954-3-william.roche@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 22.10.24 23:35, “William Roche wrote:
> From: William Roche <william.roche@oracle.com>
> 
> Add the page size information to the hwpoison_page_list elements.
> As the kernel doesn't always report the actual poisoned page size,
> we adjust this size from the backend real page size.
> We take into account the recorded page size to adjust the size
> and location of the memory hole.
> 
> Signed-off-by: William Roche <william.roche@oracle.com>
> ---
>   accel/kvm/kvm-all.c       | 14 ++++++++++----
>   include/exec/cpu-common.h |  1 +
>   include/sysemu/kvm.h      |  3 ++-
>   include/sysemu/kvm_int.h  |  3 ++-
>   system/physmem.c          | 20 ++++++++++++++++++++
>   target/arm/kvm.c          |  8 ++++++--
>   target/i386/kvm/kvm.c     |  8 ++++++--
>   7 files changed, 47 insertions(+), 10 deletions(-)
> 
> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
> index 2adc4d9c24..40117eefa7 100644
> --- a/accel/kvm/kvm-all.c
> +++ b/accel/kvm/kvm-all.c
> @@ -1266,6 +1266,7 @@ int kvm_vm_check_extension(KVMState *s, unsigned int extension)
>    */
>   typedef struct HWPoisonPage {
>       ram_addr_t ram_addr;
> +    size_t     page_size;
>       QLIST_ENTRY(HWPoisonPage) list;
>   } HWPoisonPage;
>   
> @@ -1278,15 +1279,18 @@ static void kvm_unpoison_all(void *param)
>   
>       QLIST_FOREACH_SAFE(page, &hwpoison_page_list, list, next_page) {
>           QLIST_REMOVE(page, list);
> -        qemu_ram_remap(page->ram_addr, TARGET_PAGE_SIZE);
> +        qemu_ram_remap(page->ram_addr, page->page_size);

Can't we just use the page size from the RAMBlock in qemu_ram_remap? 
There we lookup the RAMBlock, and all pages in a RAMBlock have the same 
size.

I'll note that qemu_ram_remap() is rather stupid and optimized only for 
private memory (not shmem etc).

mmap(MAP_FIXED|MAP_SHARED, fd) will give you the same poisoned page from 
the pagecache; you'd have to punch a hole instead.

It might be better to use ram_block_discard_range() in the long run. 
Memory preallocation + page pinning is tricky, but we could simply bail 
out in these cases (preallocation failing, ram discard being disabled).

qemu_ram_remap() might be problematic with page pinning (vfio) as is in 
any way :(

-- 
Cheers,

David / dhildenb


