Return-Path: <kvm+bounces-34846-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2FB8CA06763
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 22:44:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 109057A3149
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 21:44:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 235EF204689;
	Wed,  8 Jan 2025 21:44:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BY0gGDN/"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7366715E8B
	for <kvm@vger.kernel.org>; Wed,  8 Jan 2025 21:44:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736372672; cv=none; b=nB/Vim9Ut6kSBE3CbQ4hfjFkQsllv9iTOtrQ0QC6LCBONWq6nkpFbTJdRvx2FXLFEhF5uMtjobqlXBAcWYBxX3FjI6eoexSlFM0JY3jDaIjMAGHVxySECUCczgj++17cLuZhQgZPLeSa+DbTV+8LtGbwhTO/K6u6lp4YOO9X8dU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736372672; c=relaxed/simple;
	bh=MU44lBPaXq7IycJXE000SE4ZtBq2z1/H+y56lw3tQpM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Q/Sve+ySVNEQCTyQh7+ldcVZtvRnnGUpOrotYB2q79t0xxfvEQC854cky/p1IHMSWyps7pKG0N61IMuiQiFDl56GtLRhtfRtU0vwMxsTMNLN7zLADgeyaLwSqxgknwpC5oKjeg/VaOfl/FbnkTWxEf38YJKhVx/VmsDnlaaUcJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BY0gGDN/; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736372669;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=xe207xIJRaSpzuMsR3EqT+bSoOIHF0zacdEBvhMxx3Y=;
	b=BY0gGDN/WStOoYBKAHbt0q4z3JsWE3dM+NLp3qGhpkHRQI7pXh3bMTXt+Ia8EF/edw6g+j
	8npBuiXntURgRcQ0/PcxxRUrtkGDXbtG9nSL45bjmNa1ZA0VoVNAWvn+GXLtAUKSgJLSsz
	ea9TsYMkp/LCVDT47T8qS+EfXTc1cCg=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-655-qFJoKkbVO8yfiHJbUCbB1Q-1; Wed, 08 Jan 2025 16:44:28 -0500
X-MC-Unique: qFJoKkbVO8yfiHJbUCbB1Q-1
X-Mimecast-MFC-AGG-ID: qFJoKkbVO8yfiHJbUCbB1Q
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4362f893bfaso1336085e9.1
        for <kvm@vger.kernel.org>; Wed, 08 Jan 2025 13:44:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736372667; x=1736977467;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=xe207xIJRaSpzuMsR3EqT+bSoOIHF0zacdEBvhMxx3Y=;
        b=eJUNuLqyRS5AkHJv4mYvRT4kS6XCLh0E+ysPW1FgVGnzTxNjI2E+davP8mKiinBAf/
         EvQ0qj3V38k2IUtJ+txsAlOYqauxf8Lt+Ni1fZri68EdCrg0DOU8shV2K/C9M2yGLvLE
         UXfwe3WJIqFC+AWoonphzv2yfZaA7Bqikx1HJpaj0NqFTU2Zi4T+vsSlo1kY1bsfppvq
         Mft44a47CWgHDFEV4lvg6QCT4htSNIVK66JelEEAY3qPcLGbtevPgh6iplheDZAKfRco
         AnfH3MYY7EQFn4xwYdBM0VIXArBDjgv6fa4+BQOkGoE/5NrtprgiwAgcjzEhPWoLDnQY
         Boiw==
X-Forwarded-Encrypted: i=1; AJvYcCVgQKdIDTySHUR9Q1O/TnC/aiW+mMwpFAnRN5wz/Lt15ebeHkl0Fzv1doZrqqv3qE1owbo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw/HqkdX6R5obEWbYBJHXg7MrjXWIiUbB8a3v7O8jct3opECq7/
	5G8P6nRPUIkvOMji/aq/zYF/Zc93XbFcQbvpMUkfz8Az+vEyS9fW2Nw2wB4C+EdrpJPxMNkv/UU
	6mT+cCjXykXFMc5seV/DHg/3ZLK2XrEJn5ykBKsIN9d0PiN1XtA==
X-Gm-Gg: ASbGncuG50M/jPRlB2wjf7WGhOgtZiJOGaWUaotCudegGW4s9X27PikunI+Z9FUDnMM
	Teg0Pu6aYGQ0MGvgDrmUFpLGt7FvuGmws5etcpOQy15AW4gUnE5a2kOPr9N9NLeHXDWYAFBv+9i
	7XZ+8qZUKURwdXBeebXQEER1OuPdysaCe/tro6zZxnA5bH2gNlPuX1ZRKC2cKEaNwMS624Uw+PW
	DixxbuF/qQsBcDQTkFhWIroopqAai0jMZeRjtSBM23Lq1Kn50Kfn1qeiLt91IKeoFVh27vYUnrn
	mxV9dDU3M/dHHKzUhb+vR85bADMFGm45TN5mAZjdpnrg2Sr1NimofDck9vaGdO/spxNQJdFhv5+
	bNjmXeQ==
X-Received: by 2002:a05:600c:1552:b0:434:fb65:ebbb with SMTP id 5b1f17b1804b1-436e26be5a3mr41716045e9.17.1736372666929;
        Wed, 08 Jan 2025 13:44:26 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFZN1xA10dZU9VY8m3zEelbCKDn8erEpfmDdd+3vIFMlhLDHe6a2JHQG+ONKrkvMHrswFVoCg==
X-Received: by 2002:a05:600c:1552:b0:434:fb65:ebbb with SMTP id 5b1f17b1804b1-436e26be5a3mr41715825e9.17.1736372666576;
        Wed, 08 Jan 2025 13:44:26 -0800 (PST)
Received: from ?IPV6:2003:cb:c70d:3a00:d73c:6a8:ca9f:1df7? (p200300cbc70d3a00d73c06a8ca9f1df7.dip0.t-ipconnect.de. [2003:cb:c70d:3a00:d73c:6a8:ca9f:1df7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-436e2da66fcsm33595405e9.6.2025.01.08.13.44.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jan 2025 13:44:26 -0800 (PST)
Message-ID: <15d255c8-31fb-4155-83f0-bf294696621b@redhat.com>
Date: Wed, 8 Jan 2025 22:44:25 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/7] system/physmem: poisoned memory discard on reboot
To: =?UTF-8?Q?=E2=80=9CWilliam_Roche?= <william.roche@oracle.com>,
 kvm@vger.kernel.org, qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc: peterx@redhat.com, pbonzini@redhat.com, richard.henderson@linaro.org,
 philmd@linaro.org, peter.maydell@linaro.org, mtosatti@redhat.com,
 imammedo@redhat.com, eduardo@habkost.net, marcel.apfelbaum@gmail.com,
 wangyanan55@huawei.com, zhao1.liu@intel.com, joao.m.martins@oracle.com
References: <cf587c8b-3894-4589-bfea-be5db70e81f3@redhat.com>
 <20241214134555.440097-1-william.roche@oracle.com>
 <20241214134555.440097-3-william.roche@oracle.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20241214134555.440097-3-william.roche@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 14.12.24 14:45, “William Roche wrote:
> From: William Roche <william.roche@oracle.com>
> 
> Repair poisoned memory location(s), calling ram_block_discard_range():
> punching a hole in the backend file when necessary and regenerating
> a usable memory.
> If the kernel doesn't support the madvise calls used by this function
> and we are dealing with anonymous memory, fall back to remapping the
> location(s).
> 
> Signed-off-by: William Roche <william.roche@oracle.com>
> ---
>   system/physmem.c | 63 ++++++++++++++++++++++++++++++++----------------
>   1 file changed, 42 insertions(+), 21 deletions(-)
> 
> diff --git a/system/physmem.c b/system/physmem.c
> index 2c90cc2d78..b228a692f8 100644
> --- a/system/physmem.c
> +++ b/system/physmem.c
> @@ -2180,13 +2180,37 @@ void qemu_ram_free(RAMBlock *block)
>   }
>   
>   #ifndef _WIN32
> +/* Try to simply remap the given location */
> +static void qemu_ram_remap_mmap(RAMBlock *block, void* vaddr, size_t size,
> +                                ram_addr_t offset)

Can you make the parameters match the ones of ram_block_discard_range() 
so the invocation gets easier to read? You can calculate vaddr easily 
internally.

Something like

static void qemu_ram_remap_mmap(RAMBlock *rb, uint64_t start,
				size_t length)

> +{
> +    int flags, prot;
> +    void *area;
> +
> +    flags = MAP_FIXED;
> +    flags |= block->flags & RAM_SHARED ? MAP_SHARED : MAP_PRIVATE;
> +    flags |= block->flags & RAM_NORESERVE ? MAP_NORESERVE : 0;
> +    prot = PROT_READ;
> +    prot |= block->flags & RAM_READONLY ? 0 : PROT_WRITE;
> +    if (block->fd >= 0) {

Heh, that case can no longer happen!

assert(block->fs < 0);

?

> +        area = mmap(vaddr, size, prot, flags, block->fd,
> +                    offset + block->fd_offset);
> +    } else {
> +        flags |= MAP_ANONYMOUS;
> +        area = mmap(vaddr, size, prot, flags, -1, 0);
> +    }
> +    if (area != vaddr) {
> +        error_report("Could not remap addr: " RAM_ADDR_FMT "@" RAM_ADDR_FMT "",
> +                     size, block->offset + offset);
> +        exit(1);
> +    }
> +}
> +
>   void qemu_ram_remap(ram_addr_t addr)
>   {
>       RAMBlock *block;
>       ram_addr_t offset;
> -    int flags;
> -    void *area, *vaddr;
> -    int prot;
> +    void *vaddr;
>       size_t page_size;
>   
>       RAMBLOCK_FOREACH(block) {
> @@ -2202,24 +2226,21 @@ void qemu_ram_remap(ram_addr_t addr)
>               } else if (xen_enabled()) {
>                   abort();
>               } else {
> -                flags = MAP_FIXED;
> -                flags |= block->flags & RAM_SHARED ?
> -                         MAP_SHARED : MAP_PRIVATE;
> -                flags |= block->flags & RAM_NORESERVE ? MAP_NORESERVE : 0;
> -                prot = PROT_READ;
> -                prot |= block->flags & RAM_READONLY ? 0 : PROT_WRITE;
> -                if (block->fd >= 0) {
> -                    area = mmap(vaddr, page_size, prot, flags, block->fd,
> -                                offset + block->fd_offset);
> -                } else {
> -                    flags |= MAP_ANONYMOUS;
> -                    area = mmap(vaddr, page_size, prot, flags, -1, 0);
> -                }
> -                if (area != vaddr) {
> -                    error_report("Could not remap addr: "
> -                                 RAM_ADDR_FMT "@" RAM_ADDR_FMT "",
> -                                 page_size, addr);
> -                    exit(1);
> +                if (ram_block_discard_range(block, offset + block->fd_offset,
> +                                            page_size) != 0) {
> +                    /*
> +                     * Fold back to using mmap() only for anonymous mapping,

s/Fold/Fall/

> +                     * as if a backing file is associated we may not be able
> +                     * to recover the memory in all cases.
> +                     * So don't take the risk of using only mmap and fail now.
> +                     */
> +                    if (block->fd >= 0) {
> +                        error_report("Memory poison recovery failure addr: "
> +                                     RAM_ADDR_FMT "@" RAM_ADDR_FMT "",
> +                                     page_size, addr);
> +                        exit(1);
> +                    }
> +                    qemu_ram_remap_mmap(block, vaddr, page_size, offset);
>                   }
>                   memory_try_enable_merging(vaddr, page_size);
>                   qemu_ram_setup_dump(vaddr, page_size);

These two can be moved into qemu_ram_remap_mmap(). They are not required 
if we didn't actually mess with mmap().

-- 
Cheers,

David / dhildenb


