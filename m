Return-Path: <kvm+bounces-35387-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A291A108A8
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 15:10:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 97C2D1884C2E
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 14:09:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6168513C695;
	Tue, 14 Jan 2025 14:08:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="adKEtE4C"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD3AC45C14
	for <kvm@vger.kernel.org>; Tue, 14 Jan 2025 14:08:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736863691; cv=none; b=bMYeHqMLnvRSublV0IBCOl4qCfU0CRxweq7Btc+c7vMC01cMS8KcctAYFgU+TjGTUlDyi97ukqxrNccMxCJoteT54JOJSwUqzs5bpSU6RN9hwBuv/XtVfdz4nKfYvNWOzKT3mJsHNIT/5dJ7/KH7wlzRuKY1Kl952Vpv4FqLQ40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736863691; c=relaxed/simple;
	bh=/ZZ4cXU2EgNOcYrgYavMpF7FGn73uS0nIhNjGCQ10lo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LUpI2j2b6Nuejk8HzKtPhPnPAGaSZj/zCyecP0Hr6LlD2+BK0AL7vN+EJ9DOjiR+YwDWDFUB4DWg//7Xm7zUZq5Erw563aVYbvULZh5r1wElkt09bavK5Cb05FtAmASiNS4zTVFpbQkuToaD0EhEQriOqWcgUNr0k+DBz+vPCy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=adKEtE4C; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736863688;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=bq4gpVCuWRxilqmmULIZ76664+bjXBB++jnvhJ0jtQI=;
	b=adKEtE4CmqDHFEeoMx8Lp7votnzbRV1kH/PJTeMDjUtEV89CRj7pomYMf0imUH+EKz7Ki/
	dxN3Wh6DwWV59IYw1ZWg1eKhZ0xk7Tg1cfUunDjKO5TePPDYHzRfSDXwPa2E6WUvC5dkWe
	gK0QEFDbIFKIkpkaZReQNTw1O3i0McI=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-161-j2cG_UWWMtSvKoYU8pd96w-1; Tue, 14 Jan 2025 09:08:02 -0500
X-MC-Unique: j2cG_UWWMtSvKoYU8pd96w-1
X-Mimecast-MFC-AGG-ID: j2cG_UWWMtSvKoYU8pd96w
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-385d51ba2f5so2772018f8f.2
        for <kvm@vger.kernel.org>; Tue, 14 Jan 2025 06:08:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736863681; x=1737468481;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=bq4gpVCuWRxilqmmULIZ76664+bjXBB++jnvhJ0jtQI=;
        b=jHyZ/iXUGE2+gE+vemVJcfcO6V4NaxXHK1fSq87yxe/hipYnnc1XFEsTGQITmc/S3V
         RDqID8G5VcU8USuv1jzZbAgQjmZa6ioRJNaa8RuuatKTTQC0aAWyeKFtg+NdOaC29paM
         IXg6huQCZEux1EoNQx8BbihX+1GMvvmLhbn9fzWbt86s0f8geK1z9XK9r28AUg3VSNlQ
         1d9gRQ6Idmu777qf5ppbZ+ZT+V9N+HlBL7R4UvWRikHCra9lvOrfoZcs8/DmLev2GNlz
         pHTV3JZByXCdqyh5NPzkh3XdYaZWMmNWM2GN1frlpmSmYwpYoYc5oHqxzjliFa+u6lqP
         9HGg==
X-Forwarded-Encrypted: i=1; AJvYcCVgBI3qibZbme4RYw5NhePfdlZgcYqnQ/gEpx2TbvBwrVb03U/XVtRBB1lQNPIyIGuPivs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy1thNyrC4+6LrnFNk/4m1T7CXmM48nMInbyHKKP9DHZCLGpeFa
	X1ADPUjAQFygU0anE+CgwSsY1rFZmlnPWrfIpHHAIY8a//wVpHm+u9pS414jnu2QLCZtV8QE2m1
	h2Cnq2sKSFfAKdV3yFXiiMOmoJLXKnSuoPm3GVWn/TXt3sR3hMQ==
X-Gm-Gg: ASbGncvvYt8cZDqSjNi95vIMUuEwSUfACPATy+5fA/ExLXYPYZAI24GK2IuRSDwZCUa
	oykyGtJCFHxol3vhr19Jyzd1z1wiet828ddl3Vn84dsTF9MWsf1EJDkpRb5ROGzrCepuV4xn1VX
	lp8xFiWB1SZEqj8D8F2olYF/982OjH3TOBm38Nuf/+Tif879Zb5BXQizAc6ukzRS5kGOvod6qjk
	meGij86ISP01OlZEK+7h+6dNf0SepD6oMVTW+85V8eiXqMpLy9Dce/AfTvOXgWMScaMiqVmKC9D
	pk7CC2rQHVGycdycUwStbuPs7AYMscGkO1H9DGffHwjLSFPxS7PHpxGiWQG0peXVMvrd5Xdc8ph
	Yhbp+7x7C
X-Received: by 2002:a05:6000:1847:b0:385:f060:b7fc with SMTP id ffacd0b85a97d-38a8730a60cmr23977243f8f.25.1736863681029;
        Tue, 14 Jan 2025 06:08:01 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH9xEqCaeRyof0lCkuoXA1eYcp8T3X9crUx1fpEgL6xbIoMiOieKC/KO01voLoAIbKzCrRj+Q==
X-Received: by 2002:a05:6000:1847:b0:385:f060:b7fc with SMTP id ffacd0b85a97d-38a8730a60cmr23977164f8f.25.1736863680366;
        Tue, 14 Jan 2025 06:08:00 -0800 (PST)
Received: from ?IPV6:2003:cb:c738:3100:8133:26cf:7877:94aa? (p200300cbc7383100813326cf787794aa.dip0.t-ipconnect.de. [2003:cb:c738:3100:8133:26cf:7877:94aa])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38a8e383dedsm15188834f8f.35.2025.01.14.06.07.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jan 2025 06:07:59 -0800 (PST)
Message-ID: <83c251ff-60b9-4a31-b61f-466942bcf34e@redhat.com>
Date: Tue, 14 Jan 2025 15:07:57 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 2/6] system/physmem: poisoned memory discard on reboot
To: =?UTF-8?Q?=E2=80=9CWilliam_Roche?= <william.roche@oracle.com>,
 kvm@vger.kernel.org, qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc: peterx@redhat.com, pbonzini@redhat.com, richard.henderson@linaro.org,
 philmd@linaro.org, peter.maydell@linaro.org, mtosatti@redhat.com,
 imammedo@redhat.com, eduardo@habkost.net, marcel.apfelbaum@gmail.com,
 wangyanan55@huawei.com, zhao1.liu@intel.com, joao.m.martins@oracle.com
References: <cf587c8b-3894-4589-bfea-be5db70e81f3@redhat.com>
 <20250110211405.2284121-1-william.roche@oracle.com>
 <20250110211405.2284121-3-william.roche@oracle.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20250110211405.2284121-3-william.roche@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 10.01.25 22:14, “William Roche wrote:
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
>   system/physmem.c | 57 ++++++++++++++++++++++++++++++------------------
>   1 file changed, 36 insertions(+), 21 deletions(-)
> 
> diff --git a/system/physmem.c b/system/physmem.c
> index 7a87548f99..ae1caa97d8 100644
> --- a/system/physmem.c
> +++ b/system/physmem.c
> @@ -2180,13 +2180,32 @@ void qemu_ram_free(RAMBlock *block)
>   }
>   
>   #ifndef _WIN32
> +/* Simply remap the given VM memory location from start to start+length */
> +static void qemu_ram_remap_mmap(RAMBlock *block, uint64_t start, size_t length)
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
> +    if (area != host_startaddr) {
> +        error_report("Could not remap addr: " RAM_ADDR_FMT "@" RAM_ADDR_FMT "",
> +                     length, start);
> +        exit(1);
> +    }

Can we return an error and have a single error printed in the caller?

return area != host_startaddr ? -errno : 0;

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
> @@ -2202,24 +2221,20 @@ void qemu_ram_remap(ram_addr_t addr)
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
> +                if (ram_block_discard_range(block, offset, page_size) != 0) {
> +                    /*
> +                     * Fall back to using mmap() only for anonymous mapping,
> +                     * as if a backing file is associated we may not be able
> +                     * to recover the memory in all cases.
> +                     * So don't take the risk of using only mmap and fail now.
> +                     */
> +                    if (block->fd >= 0) {
> +                        error_report("Memory poison recovery failure addr: "
> +                                     RAM_ADDR_FMT "@" RAM_ADDR_FMT "",
> +                                     page_size, addr);

See my error message proposal as reply to v4 patch #1: we should similarly
just print rb->idstr, offset and page_size like ram_block_discard_range() does.

ram_addr_t is weird and not helpful for users.


To have a single error

if (ram_block_discard_range(block, offset, page_size) != 0) {
	/* ...
	if (block->fd >= 0 || qemu_ram_remap_mmap(block, offset, page_size)) {
		error_report() ... // use proposal from my reply to v4 patch #1
		exit(1);
	}
}

-- 
Cheers,

David / dhildenb


