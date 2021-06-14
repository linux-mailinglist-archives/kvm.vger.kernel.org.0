Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 371E53A6849
	for <lists+kvm@lfdr.de>; Mon, 14 Jun 2021 15:44:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233831AbhFNNq5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Jun 2021 09:46:57 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38396 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234020AbhFNNq4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 14 Jun 2021 09:46:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623678293;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WB47Pni+nWnZCpL3j99qdXOV/pBIAB8A+KnYUYN28RA=;
        b=IA58C7pvf4dGyL9Vt89mklcGWVzHiP9PGQTAR7XSo5YmbgRe18d4N/MnEaN9iEX19EWT1v
        /UGPcJqIF58MzIAfsFwsBngPM6wQ9Ji1sH6opxxcELRunrsteWucEvA5/2CEB9Mxo7Oc/g
        TNjqolFNI0ru+vFh3YkUlfi50/uMuqI=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-157-h0fJ5BIsNlKWDifKvDdDVg-1; Mon, 14 Jun 2021 09:44:52 -0400
X-MC-Unique: h0fJ5BIsNlKWDifKvDdDVg-1
Received: by mail-wm1-f72.google.com with SMTP id v25-20020a1cf7190000b0290197a4be97b7so5700620wmh.9
        for <kvm@vger.kernel.org>; Mon, 14 Jun 2021 06:44:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=WB47Pni+nWnZCpL3j99qdXOV/pBIAB8A+KnYUYN28RA=;
        b=rQ56ZwAcvLBC7Aihy+NPiR+qZG/HrZfKd/R72z0PdF1ka8GRZVAWiKCHxqA0PE6LLT
         ySux7PrRh9uTULEVHjuiaqfYir6tiYVrrr15seWmbUr9ifYI9CosABSXVIE+EKACq+B5
         kQz4+mj6YRsOKpWfevWLqsfhppzAuxeMvTeX+v9PLXynvZBXBDIJN8SFMGhA3afudDnO
         ADNShZJV5lsbUSj0tgNo3mkw1DwJRve1cReDJKxEG9zfgOT2I3JryRdy7p22uaLUF138
         Bdv0lPPk5vyzaerVv0YinTZpFlYGPooAukkE8mFUmP3iDrdv1914tEHBpG7pzHNhCXFg
         MdEg==
X-Gm-Message-State: AOAM533ZXfKP9/sWXJso9UElTNJ1ddNoewVzdRlskaKrBAL1PiuJS4d0
        dhQRB65cI4Lt3oTY2CQlR6paJ5eJJDO63jFeWR5Yw7Zc/YD5mvq0qhoJGw8P5UrkOhv2mMd3UUM
        J8bvNjHI+btdU
X-Received: by 2002:a1c:4e12:: with SMTP id g18mr28719061wmh.101.1623678290830;
        Mon, 14 Jun 2021 06:44:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzWpm7VHBHg5E8TavVz/PqtB9z7c94nrDgE5PFAe0bmP/4EluavDGqNCHfZLyv6MB54rYIebA==
X-Received: by 2002:a1c:4e12:: with SMTP id g18mr28719035wmh.101.1623678290649;
        Mon, 14 Jun 2021 06:44:50 -0700 (PDT)
Received: from [192.168.3.132] (p5b0c66ca.dip0.t-ipconnect.de. [91.12.102.202])
        by smtp.gmail.com with ESMTPSA id 125sm21656180wmb.34.2021.06.14.06.44.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Jun 2021 06:44:50 -0700 (PDT)
Subject: Re: [PATCH v4 1/2] mm/vmalloc: add vmalloc_no_huge
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>,
        linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        linux-mm@kvack.org, Uladzislau Rezki <urezki@gmail.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        David Rientjes <rientjes@google.com>,
        Christoph Hellwig <hch@infradead.org>
References: <20210614132357.10202-1-imbrenda@linux.ibm.com>
 <20210614132357.10202-2-imbrenda@linux.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Message-ID: <8f24292e-e8c9-9b9b-0429-2ac984a01611@redhat.com>
Date:   Mon, 14 Jun 2021 15:44:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210614132357.10202-2-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14.06.21 15:23, Claudio Imbrenda wrote:
> Commit 121e6f3258fe3 ("mm/vmalloc: hugepage vmalloc mappings") added
> support for hugepage vmalloc mappings, it also added the flag
> VM_NO_HUGE_VMAP for __vmalloc_node_range to request the allocation to
> be performed with 0-order non-huge pages.  This flag is not accessible
> when calling vmalloc, the only option is to call directly
> __vmalloc_node_range, which is not exported.
> 
> This means that a module can't vmalloc memory with small pages.
> 
> Case in point: KVM on s390x needs to vmalloc a large area, and it needs
> to be mapped with non-huge pages, because of a hardware limitation.
> 
> This patch adds the function vmalloc_no_huge, which works like vmalloc,
> but it is guaranteed to always back the mapping using small pages. This
> new function is exported, therefore it is usable by modules.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
> Acked-by: Nicholas Piggin <npiggin@gmail.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Nicholas Piggin <npiggin@gmail.com>
> Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: David Rientjes <rientjes@google.com>
> Cc: Christoph Hellwig <hch@infradead.org>
> ---
>   include/linux/vmalloc.h |  1 +
>   mm/vmalloc.c            | 16 ++++++++++++++++
>   2 files changed, 17 insertions(+)
> 
> diff --git a/include/linux/vmalloc.h b/include/linux/vmalloc.h
> index 4d668abb6391..bfaaf0b6fa76 100644
> --- a/include/linux/vmalloc.h
> +++ b/include/linux/vmalloc.h
> @@ -135,6 +135,7 @@ extern void *__vmalloc_node_range(unsigned long size, unsigned long align,
>   			const void *caller);
>   void *__vmalloc_node(unsigned long size, unsigned long align, gfp_t gfp_mask,
>   		int node, const void *caller);
> +void *vmalloc_no_huge(unsigned long size);
>   
>   extern void vfree(const void *addr);
>   extern void vfree_atomic(const void *addr);
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index a13ac524f6ff..296a2fcc3fbe 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -2998,6 +2998,22 @@ void *vmalloc(unsigned long size)
>   }
>   EXPORT_SYMBOL(vmalloc);
>   
> +/**
> + * vmalloc_no_huge - allocate virtually contiguous memory using small pages
> + * @size:    allocation size
> + *
> + * Allocate enough non-huge pages to cover @size from the page level
> + * allocator and map them into contiguous kernel virtual space.
> + *
> + * Return: pointer to the allocated memory or %NULL on error
> + */
> +void *vmalloc_no_huge(unsigned long size)
> +{
> +	return __vmalloc_node_range(size, 1, VMALLOC_START, VMALLOC_END, GFP_KERNEL, PAGE_KERNEL,
> +				    VM_NO_HUGE_VMAP, NUMA_NO_NODE, __builtin_return_address(0));
> +}
> +EXPORT_SYMBOL(vmalloc_no_huge);
> +
>   /**
>    * vzalloc - allocate virtually contiguous memory with zero fill
>    * @size:    allocation size
> 

Reviewed-by: David Hildenbrand <david@redhat.com>

-- 
Thanks,

David / dhildenb

