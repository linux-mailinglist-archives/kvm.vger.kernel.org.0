Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77CE421D9EC
	for <lists+kvm@lfdr.de>; Mon, 13 Jul 2020 17:17:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729811AbgGMPRV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jul 2020 11:17:21 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:58245 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729027AbgGMPRV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Jul 2020 11:17:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594653440;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=hM2nC7NazUrdbFTMayY6WhNfpIWkJewG8K1PDOACjA4=;
        b=fTNJaOftAsBNi1THOtj1mOEF9M4Po7paszdiEsLsUeVV91OHTtIFaAQopO7xgSgo0HhGE1
        zSE4C3DevmwQvIVxpouAlOQ0gfUFspc/RBqWPLnDQWpl/brrDPG3kpccydBUh4Y7HBKtt8
        7of4p1b+jQLcjGV6xwVpRuHd/SgxsqQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-260-BXr-RbMqM4SS6k_sQHe6og-1; Mon, 13 Jul 2020 11:17:15 -0400
X-MC-Unique: BXr-RbMqM4SS6k_sQHe6og-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E1302FFCD9;
        Mon, 13 Jul 2020 15:17:10 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-125.ams2.redhat.com [10.36.112.125])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D106C73022;
        Mon, 13 Jul 2020 15:16:45 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v2 2/4] lib/alloc_page: change some
 parameter types
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org,
        pbonzini@redhat.com
Cc:     frankja@linux.ibm.com, david@redhat.com, drjones@redhat.com
References: <20200706164324.81123-1-imbrenda@linux.ibm.com>
 <20200706164324.81123-3-imbrenda@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <c1d8729e-74fb-abdd-c107-581ddde3c832@redhat.com>
Date:   Mon, 13 Jul 2020 17:16:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200706164324.81123-3-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/07/2020 18.43, Claudio Imbrenda wrote:
> For size parameters, size_t is probably semantically more appropriate
> than unsigned long (although they map to the same value).
> 
> For order, unsigned long is just too big. Also, get_order returns an
> unsigned int anyway.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Reviewed-by: Andrew Jones <drjones@redhat.com>
> ---
>  lib/alloc_page.h | 6 +++---
>  lib/alloc_page.c | 8 ++++----
>  2 files changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/lib/alloc_page.h b/lib/alloc_page.h
> index 6181299..d9aceb7 100644
> --- a/lib/alloc_page.h
> +++ b/lib/alloc_page.h
> @@ -11,10 +11,10 @@
>  bool page_alloc_initialized(void);
>  void page_alloc_ops_enable(void);
>  void *alloc_page(void);
> -void *alloc_pages(unsigned long order);
> +void *alloc_pages(unsigned int order);
>  void free_page(void *page);
> -void free_pages(void *mem, unsigned long size);
> -void free_pages_by_order(void *mem, unsigned long order);
> +void free_pages(void *mem, size_t size);
> +void free_pages_by_order(void *mem, unsigned int order);
>  unsigned int get_order(size_t size);
>  
>  #endif
> diff --git a/lib/alloc_page.c b/lib/alloc_page.c
> index 8769c3f..f16eaad 100644
> --- a/lib/alloc_page.c
> +++ b/lib/alloc_page.c
> @@ -21,7 +21,7 @@ bool page_alloc_initialized(void)
>  	return freelist != 0;
>  }
>  
> -void free_pages(void *mem, unsigned long size)
> +void free_pages(void *mem, size_t size)

 Hi Claudio,

this patch broke 32-bit x86 and arm builds:

 https://travis-ci.com/github/huth/kvm-unit-tests/jobs/360418977#L693
 https://travis-ci.com/github/huth/kvm-unit-tests/jobs/360418980#L545

I think you either need to adjust the format string, or cast the argument.

 Thomas

