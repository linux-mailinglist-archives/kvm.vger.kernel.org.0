Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 957583A5B71
	for <lists+kvm@lfdr.de>; Mon, 14 Jun 2021 04:02:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232306AbhFNCEk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 13 Jun 2021 22:04:40 -0400
Received: from mail-pg1-f171.google.com ([209.85.215.171]:45720 "EHLO
        mail-pg1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232269AbhFNCEk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 13 Jun 2021 22:04:40 -0400
Received: by mail-pg1-f171.google.com with SMTP id q15so7385404pgg.12;
        Sun, 13 Jun 2021 19:02:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=aPSRd8P5hbet2BrvYpNfkNZg8dhljgNsDNnwb2YMsGI=;
        b=JC1aQPJj+qQigSbo7O1IkpT/ka2zI8z8qKcoPOz7lofHF1ouNK2Tq5SBQcCN8BZsSG
         3HeiW8S0XFbcS986M7UMAmdXxAjQMHPiXu2HXficRiEVNihtq5xmaCdbw1tG6TgTNgpl
         R3EhfVBn/sp6CEuadFI9Eu+8pw5A3gG9IfK4UG0aUy1XNOzlIh3pwfZWjvkV4lWdstEv
         WJAuPCTeGnrkbJOMlorMlfx9+b4vN08OKAQkYcyVj9f3fzjiKgzCYZv2qWQle7Bo3D43
         yp4eXdlvw5YZDi9X+7pXuuFZekS+SvY/YYJIrikSN7H7FVSqvz0g7//ErOVKCik9BL/Y
         pSYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=aPSRd8P5hbet2BrvYpNfkNZg8dhljgNsDNnwb2YMsGI=;
        b=uAupY9zLNz9RYXUQQaApgup/VVzJINPnUs1k4o6UIhElSqGgFprCqZ9OQGPRWyUVNG
         BOtyEs9jrF6hKX5ikyQ/tzoGp4f1we4j+Lm+LfIb9ynncz/FR876F1gJgG6MByFjhML9
         7uW/ovgBU4Z7VRGU/BA7xAEHn/MeDSH3m3528j+JWBg5Pnc0ZfNTTIumgFpjZFWRhXUj
         Li1cKcMbRpJV4IoD7ZfubIoh0775kHqmanFs1VjrGufbjB5t2P0dcTaJ65Hb3k6MeRXX
         0hAxkrdPAeA7aiuX9TO96cokqpuWWoqVIhbX4PdtZc82MEuIyJQ4En4d/SKHJpDUEsrX
         VKoQ==
X-Gm-Message-State: AOAM532sSlB7f0N2EjsFZ4O4o9ZGLIXANnon38t444yJJDyL+dQZ73TO
        3CQfPJr4dYaRLeGtlmYZ//Y5tILAe9g=
X-Google-Smtp-Source: ABdhPJyyH00nJQUuyvLRvmwKzG2y669zY7GJTP55TKXM+laNn6eQIVX8mu49pYmwdCKmwiupJn2dNQ==
X-Received: by 2002:a65:4689:: with SMTP id h9mr14893660pgr.347.1623636083110;
        Sun, 13 Jun 2021 19:01:23 -0700 (PDT)
Received: from localhost (60-242-147-73.tpgi.com.au. [60.242.147.73])
        by smtp.gmail.com with ESMTPSA id b21sm8322294pgj.74.2021.06.13.19.01.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Jun 2021 19:01:22 -0700 (PDT)
Date:   Mon, 14 Jun 2021 12:01:17 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH v3 1/2] mm/vmalloc: add vmalloc_no_huge
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>,
        linux-kernel@vger.kernel.org
Cc:     Andrew Morton <akpm@linux-foundation.org>, borntraeger@de.ibm.com,
        Catalin Marinas <catalin.marinas@arm.com>, cohuck@redhat.com,
        david@redhat.com, frankja@linux.ibm.com,
        Christoph Hellwig <hch@infradead.org>, kvm@vger.kernel.org,
        linux-mm@kvack.org, linux-s390@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>,
        David Rientjes <rientjes@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Uladzislau Rezki <urezki@gmail.com>
References: <20210610154220.529122-1-imbrenda@linux.ibm.com>
        <20210610154220.529122-2-imbrenda@linux.ibm.com>
In-Reply-To: <20210610154220.529122-2-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Message-Id: <1623635127.zn5jrobj51.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Excerpts from Claudio Imbrenda's message of June 11, 2021 1:42 am:
> The recent patches to add support for hugepage vmalloc mappings added a
> flag for __vmalloc_node_range to allow to request small pages.
> This flag is not accessible when calling vmalloc, the only option is to
> call directly __vmalloc_node_range, which is not exported.
>=20
> This means that a module can't vmalloc memory with small pages.
>=20
> Case in point: KVM on s390x needs to vmalloc a large area, and it needs
> to be mapped with small pages, because of a hardware limitation.
>=20
> This patch adds the function vmalloc_no_huge, which works like vmalloc,
> but it is guaranteed to always back the mapping using small pages. This
> function is exported, therefore it is usable by modules.
>=20
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Nicholas Piggin <npiggin@gmail.com>
> Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: David Rientjes <rientjes@google.com>
> Cc: Christoph Hellwig <hch@infradead.org>
> ---
>  include/linux/vmalloc.h |  1 +
>  mm/vmalloc.c            | 16 ++++++++++++++++
>  2 files changed, 17 insertions(+)
>=20
> diff --git a/include/linux/vmalloc.h b/include/linux/vmalloc.h
> index 4d668abb6391..bfaaf0b6fa76 100644
> --- a/include/linux/vmalloc.h
> +++ b/include/linux/vmalloc.h
> @@ -135,6 +135,7 @@ extern void *__vmalloc_node_range(unsigned long size,=
 unsigned long align,
>  			const void *caller);
>  void *__vmalloc_node(unsigned long size, unsigned long align, gfp_t gfp_=
mask,
>  		int node, const void *caller);
> +void *vmalloc_no_huge(unsigned long size);
> =20
>  extern void vfree(const void *addr);
>  extern void vfree_atomic(const void *addr);
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index a13ac524f6ff..296a2fcc3fbe 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -2998,6 +2998,22 @@ void *vmalloc(unsigned long size)
>  }
>  EXPORT_SYMBOL(vmalloc);
> =20
> +/**
> + * vmalloc_no_huge - allocate virtually contiguous memory using small pa=
ges
> + * @size:    allocation size
> + *
> + * Allocate enough non-huge pages to cover @size from the page level
> + * allocator and map them into contiguous kernel virtual space.
> + *
> + * Return: pointer to the allocated memory or %NULL on error
> + */
> +void *vmalloc_no_huge(unsigned long size)
> +{
> +	return __vmalloc_node_range(size, 1, VMALLOC_START, VMALLOC_END, GFP_KE=
RNEL, PAGE_KERNEL,
> +				    VM_NO_HUGE_VMAP, NUMA_NO_NODE, __builtin_return_address(0));
> +}
> +EXPORT_SYMBOL(vmalloc_no_huge);

At some point if the combination of flags becomes too much we will need a=20
different strategy. A vmalloc API with (size, align, gfp_t, vm_flags,=20
node) args would help 3/6 of the existing non-arch callers too. And one=20
more if you had a prot parameter or _exec variant.

But for now I'm okay with this.

Acked-by: Nicholas Piggin <npiggin@gmail.com>

Thanks,
Nick
