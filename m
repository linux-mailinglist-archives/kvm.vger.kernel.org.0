Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70D3921EF1D
	for <lists+kvm@lfdr.de>; Tue, 14 Jul 2020 13:21:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726999AbgGNLUe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jul 2020 07:20:34 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:43797 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728076AbgGNLU1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 14 Jul 2020 07:20:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594725626;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=nN63u7ZzhdOr8CcBKl8SjTbtHOAyFMI20KsZW1OJumA=;
        b=Qb0InkdXhxOlNfXoEELwZvo25LAyHDecSW05hELwgFuKWv8W7wkkJyofyzPzVZZ3yCaUCw
        SfCgJm+3HnGX1D7vvaWj41AX7/9mSin5zrjJmEmGU4ARE12R/0ExrqkSY9cuPlbK0HgLSU
        UXlqN5t7vi0ULYB3/E8pgWyy0iGbwfQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-282-PGpuTFAOP6ag8DPDm15pEw-1; Tue, 14 Jul 2020 07:20:25 -0400
X-MC-Unique: PGpuTFAOP6ag8DPDm15pEw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A63031902EA1;
        Tue, 14 Jul 2020 11:20:23 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-11.ams2.redhat.com [10.36.112.11])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8C7AC1CA;
        Tue, 14 Jul 2020 11:20:18 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v1 2/2] lib/alloc_page: Fix compilation
 issue on 32bit archs
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org,
        pbonzini@redhat.com
Cc:     frankja@linux.ibm.com, david@redhat.com, drjones@redhat.com,
        jmattson@google.com, sean.j.christopherson@intel.com
References: <20200714110919.50724-1-imbrenda@linux.ibm.com>
 <20200714110919.50724-3-imbrenda@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <866d79a4-0205-5d49-d407-4e3415b63762@redhat.com>
Date:   Tue, 14 Jul 2020 13:20:16 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200714110919.50724-3-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/07/2020 13.09, Claudio Imbrenda wrote:
> The assert in lib/alloc_page is hardcoded to long, and size_t is just
> an int on 32 bit architectures.
> 
> Adding a cast makes the compiler happy.
> 
> Fixes: 73f4b202beb39 ("lib/alloc_page: change some parameter types")
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>  lib/alloc_page.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/lib/alloc_page.c b/lib/alloc_page.c
> index fa3c527..617b003 100644
> --- a/lib/alloc_page.c
> +++ b/lib/alloc_page.c
> @@ -29,11 +29,12 @@ void free_pages(void *mem, size_t size)
>  	assert_msg((unsigned long) mem % PAGE_SIZE == 0,
>  		   "mem not page aligned: %p", mem);
>  
> -	assert_msg(size % PAGE_SIZE == 0, "size not page aligned: %#lx", size);
> +	assert_msg(size % PAGE_SIZE == 0, "size not page aligned: %#lx",
> +		(unsigned long)size);
>  
>  	assert_msg(size == 0 || (uintptr_t)mem == -size ||
>  		   (uintptr_t)mem + size > (uintptr_t)mem,
> -		   "mem + size overflow: %p + %#lx", mem, size);
> +		   "mem + size overflow: %p + %#lx", mem, (unsigned long)size);

Looking at lib/printf.c, it seems like it also supports %z ... have you
tried?

 Thomas

