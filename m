Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEE3E3187CC
	for <lists+kvm@lfdr.de>; Thu, 11 Feb 2021 11:09:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230071AbhBKKJH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Feb 2021 05:09:07 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35058 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230362AbhBKKHo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 11 Feb 2021 05:07:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613037978;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=y+GIf5Za2WhePB3rg6+AcRIvHAWQepwvul0mjNjwyjw=;
        b=b8bLZoqcDPEmlQOua+jd4VWA2i/o5s/RuA5IHavJigvnpZklo4C3SPc44T+MgBj50vvYT6
        4gr6TX+NsoNU32utgNwhkttJ5csROj5fGfuD/Csm+IFd4uRgD5KIwquaaDuzVmLaTaAFwF
        UwqfouZ83TMc6tOrzcXrRVLKb3hDc+Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-91-qCUL60YbMNKnwuvuU_NeRA-1; Thu, 11 Feb 2021 05:06:14 -0500
X-MC-Unique: qCUL60YbMNKnwuvuU_NeRA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CF3B5107ACC7;
        Thu, 11 Feb 2021 10:06:12 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-46.ams2.redhat.com [10.36.112.46])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 04A035C260;
        Thu, 11 Feb 2021 10:06:07 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v1 3/4] s390x: mmu: add support for large
 pages
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com,
        frankja@linux.ibm.com, cohuck@redhat.com, pmorel@linux.ibm.com
References: <20210209143835.1031617-1-imbrenda@linux.ibm.com>
 <20210209143835.1031617-4-imbrenda@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <9d99a22d-5bcd-5544-a78e-4fe0e025f961@redhat.com>
Date:   Thu, 11 Feb 2021 11:06:06 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210209143835.1031617-4-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/02/2021 15.38, Claudio Imbrenda wrote:
> Add support for 1M and 2G pages.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>   lib/s390x/mmu.h |  73 +++++++++++++-
>   lib/s390x/mmu.c | 246 +++++++++++++++++++++++++++++++++++++++++++-----
>   2 files changed, 294 insertions(+), 25 deletions(-)
[...]
> +/*
> + * Get the pte (page) DAT table entry for the given address and pmd,
> + * allocating it if necessary.
> + * The pmd must not be large.
> + */
> +static inline pte_t *get_pte(pmd_t *pmd, uintptr_t vaddr)
> +{
>   	pte_t *pte = pte_alloc(pmd, vaddr);
>   
> -	return &pte_val(*pte);
> +	assert(!pmd_large(*pmd));
> +	pte = pte_alloc(pmd, vaddr);

Why is this function doing "pte = pte_alloc(pmd, vaddr)" twice now?

> +	return pte;
> +}
[...]
> +	if ((level == 1) && !pgd_none(*(pgd_t *)ptr))
> +		idte_pgdp(va, ptr);
> +	else if ((level == 2) && !p4d_none(*(p4d_t *)ptr))
> +		idte_p4dp(va, ptr);
> +	else if ((level == 3) && !pud_none(*(pud_t *)ptr))
> +		idte_pudp(va, ptr);
> +	else if ((level == 4) && !pmd_none(*(pmd_t *)ptr))
> +		idte_pmdp(va, ptr);
> +	else if (!pte_none(*(pte_t *)ptr))
> +		ipte(va, ptr);

Meta-comment: Being someone who worked quite a bit with the page tables on 
s390x, but never really got in touch with the way it is handled in the Linux 
kernel, I'm always having a hard time to match all these TLAs to the PoP: 
pmd, pud, p4d ...
Can we please have a proper place in the kvm-unit-tests sources somewhere 
(maybe at the beginning of mmu.c), where the TLAs are explained and how they 
map to the region and segment tables of the Z architecture?
(I personally would prefer to completely switch to the Z arch naming 
instead, but I guess that's too much of a change right now)

  Thomas

