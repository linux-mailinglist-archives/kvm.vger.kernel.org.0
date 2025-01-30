Return-Path: <kvm+bounces-36920-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B0A2A22B4C
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2025 11:08:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 509573A86FD
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2025 10:08:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91FA31B85D3;
	Thu, 30 Jan 2025 10:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VxGGWKE1"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08AE415382E
	for <kvm@vger.kernel.org>; Thu, 30 Jan 2025 10:08:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738231716; cv=none; b=aNCLGMQ/raOSoLBKMonphQnVaUbGWaSQjRHTqpFdpbLIZ5d8S5R69lKnZB+aNJXROekLkC4hTYmyNTRpcUQ9tMQyvvxN9Kci3OSaTFROHCCI2YznTqwfraWu6+ncSucEog/F9ZYcWGZ0i8Thz4a4b8gq81/umNobiiMstsLbIys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738231716; c=relaxed/simple;
	bh=KKk7k+HJ6w80lPjeTb2TdUg4YNUzhG9xolmvryWdUmg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hb1MbaNjoNnzFx5TsMfJCXq0okBSEFsamoTRQdmQas7PxIBV/53lOKSMRCLeQFvD+pZsh9RHW2MaggAGV94HiMUp7w7doxq6cv+p4UnPPdL+Cw4WRZagA2hjogx+AUU20m+0vCk1tp8uN26KzHfaQ439n0ha8IBvspGAGsfbFG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VxGGWKE1; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738231714;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=GxtuEqLCldMCiqHlL9qdk33s4rX5+fECbKiC+L8VbpM=;
	b=VxGGWKE1vzx2Zg9Y63GwV7mXywsxzvgDfI2Zh8Cya1zcHxqPXFMyQx9NUsC9/VfSPLRcnf
	CL6UMnwW2zcGWHs4qmLPAIoesvbTwxFJZxCplcnALJ+rhKJVV1LiwK5FJln3xve76XkloZ
	3I3UgjHMedij5SJOvn/nByCkM1eN8yU=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-669-QIIxQDTiM62q-TqayuchcA-1; Thu, 30 Jan 2025 05:08:32 -0500
X-MC-Unique: QIIxQDTiM62q-TqayuchcA-1
X-Mimecast-MFC-AGG-ID: QIIxQDTiM62q-TqayuchcA
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-38634103b0dso363383f8f.2
        for <kvm@vger.kernel.org>; Thu, 30 Jan 2025 02:08:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738231711; x=1738836511;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=GxtuEqLCldMCiqHlL9qdk33s4rX5+fECbKiC+L8VbpM=;
        b=ePJ8uiMyEieM4KvT1d+jZY/wnWaU7uLczm8ylCz5cyMUJHUv5gVGbKFoUfKb6LYIxR
         +9dnay6/I65hVO3RjJrsIBFW6mmuljvJGoNzqx1Gnu40MB46+Qzj+5RqnsnKsfUQ0r14
         FG7rz32GAjBGPrL6ZNqMHviI8HE72BVCHZlq52h2U5SASKP50XicCO5RN556CEU6/NAx
         Cv2snHt2n0rvmwD3IkORyhr+75vomFG03RA7g+Y1xSoJElBSKG1B4lpljKQxn/DxIbPc
         GiBfSSWO/3mmRuVNXzYAh6Dt2rF/88Vse8UdjJttFOcCB3uFe1zTPbgv6sPF69uLansZ
         /uOA==
X-Forwarded-Encrypted: i=1; AJvYcCUwAvkh+evo/Oe6MEYlugR2JYG8Q3L/LbqFzviwrNINycNnKlFq1KB9rlXX6BNz73tWD1o=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyz1wmWuogiEXqlcP3nS70ptvnHn7BvtpsTmoLHV2lSTIYmHr2u
	xSy5wkAi7CJ/liFbzk9wS9G+OezzKnFi//+vVtcIgSQbqsJhl54j98omgji6s2WTiWrj7xU6ctg
	XOiNvKBODXICMqLnq6yL70v2ZKP4LkfJU9CQCRhP+7uMv++4bAg==
X-Gm-Gg: ASbGncs8iUA4xfc24MR1poMuGwIJ1CMZXvTRa1oe6+3m8oOrBCcaDoAlXOCUZw2etyL
	QMCT+F3dzmwPmdyMZXeB5mmmA7zFwKq5hG/qufTIUeo4kymBF5gI7dSRlbxgy/fnbKOGq7N0eX3
	kEEnICf0ZuvXP7TvBztaGZvG2R9eWx8pvU+VeJPYmQqzR1aKLXq/6LRSdlEDeimwyV1VilCA6e5
	5+zfqsyCUoLk+B6GB5gcRBvEQUG3gzjTq6ingjSR+WQqk+i/ComvdMk2NMfJoQTpnzMMsduYoZh
	YytJw6KVLTc8Wmjj7CSEwxrKBYW3b+uCH8TlEmvKdEir
X-Received: by 2002:a05:6000:1fac:b0:386:3329:6a04 with SMTP id ffacd0b85a97d-38c51e8de63mr6292567f8f.39.1738231711171;
        Thu, 30 Jan 2025 02:08:31 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGvS3Uy7Eodh52ChzmXqGnzBkmmZ7MfTvQSBcAfuge2S8sB/SSD++pYiQdwzpMFbW+y3P8ccA==
X-Received: by 2002:a05:6000:1fac:b0:386:3329:6a04 with SMTP id ffacd0b85a97d-38c51e8de63mr6292513f8f.39.1738231710443;
        Thu, 30 Jan 2025 02:08:30 -0800 (PST)
Received: from ?IPV6:2a01:599:904:96e0:a245:aa9f:6c57:eb41? ([2a01:599:904:96e0:a245:aa9f:6c57:eb41])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38c5c1cf555sm1508408f8f.97.2025.01.30.02.08.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jan 2025 02:08:29 -0800 (PST)
Message-ID: <6943198a-4d3b-4e3c-a206-d031e8f943b9@redhat.com>
Date: Thu, 30 Jan 2025 11:08:27 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 2/6] system/physmem: poisoned memory discard on reboot
To: =?UTF-8?Q?=E2=80=9CWilliam_Roche?= <william.roche@oracle.com>,
 kvm@vger.kernel.org, qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc: peterx@redhat.com, pbonzini@redhat.com, richard.henderson@linaro.org,
 philmd@linaro.org, peter.maydell@linaro.org, mtosatti@redhat.com,
 imammedo@redhat.com, eduardo@habkost.net, marcel.apfelbaum@gmail.com,
 wangyanan55@huawei.com, zhao1.liu@intel.com, joao.m.martins@oracle.com
References: <20250127213107.3454680-1-william.roche@oracle.com>
 <20250127213107.3454680-3-william.roche@oracle.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20250127213107.3454680-3-william.roche@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 27.01.25 22:31, “William Roche wrote:
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
>   system/physmem.c | 54 ++++++++++++++++++++++++++++--------------------
>   1 file changed, 32 insertions(+), 22 deletions(-)
> 
> diff --git a/system/physmem.c b/system/physmem.c
> index 3dd2adde73..3dc10ae27b 100644
> --- a/system/physmem.c
> +++ b/system/physmem.c
> @@ -2167,6 +2167,23 @@ void qemu_ram_free(RAMBlock *block)
>   }
>   
>   #ifndef _WIN32
> +/* Simply remap the given VM memory location from start to start+length */
> +static int qemu_ram_remap_mmap(RAMBlock *block, uint64_t start, size_t length)
> +{
> +    int flags, prot;
> +    void *area;
> +    void *host_startaddr = block->host + start;
> +
> +    assert(block->fd < 0);
> +    flags = MAP_FIXED | MAP_ANONYMOUS;
> +    flags |= block->flags & RAM_SHARED ? MAP_SHARED : MAP_PRIVATE;
> +    flags |= block->flags & RAM_NORESERVE ? MAP_NORESERVE : 0;
> +    prot = PROT_READ;
> +    prot |= block->flags & RAM_READONLY ? 0 : PROT_WRITE;
> +    area = mmap(host_startaddr, length, prot, flags, -1, 0);
> +    return area != host_startaddr ? -errno : 0;
> +}
> +
>   /*
>    * qemu_ram_remap - remap a single RAM page
>    *
> @@ -2184,9 +2201,7 @@ void qemu_ram_remap(ram_addr_t addr)
>   {
>       RAMBlock *block;
>       uint64_t offset;
> -    int flags;
> -    void *area, *vaddr;
> -    int prot;
> +    void *vaddr;
>       size_t page_size;
>   
>       RAMBLOCK_FOREACH(block) {
> @@ -2201,25 +2216,20 @@ void qemu_ram_remap(ram_addr_t addr)
>                   ;
>               } else if (xen_enabled()) {
>                   abort();
> -            } else {
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
> -                    error_report("Could not remap RAM %s:%" PRIx64 "+%" PRIx64
> -                                 " +%zx", block->idstr, offset,
> -                                 block->fd_offset, page_size);
> -                    exit(1);
> +                if (ram_block_discard_range(block, offset, page_size) != 0) {
> +                    /*
> +                     * Fall back to using mmap() only for anonymous mapping,
> +                     * as if a backing file is associated we may not be able
> +                     * to recover the memory in all cases.
> +                     * So don't take the risk of using only mmap and fail now.
> +                     */
> +                    if (block->fd >= 0 ||
> +                        qemu_ram_remap_mmap(block, offset, page_size) != 0) {
> +                        error_report("Could not remap RAM %s:%" PRIx64 "+%"
> +                                     PRIx64 " +%zx", block->idstr, offset,
> +                                     block->fd_offset, page_size);
> +                        exit(1);
> +                    }
>                   }
>                   memory_try_enable_merging(vaddr, page_size);
>                   qemu_ram_setup_dump(vaddr, page_size);


Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers,

David / dhildenb


