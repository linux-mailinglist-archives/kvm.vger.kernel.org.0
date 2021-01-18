Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85D712FA80C
	for <lists+kvm@lfdr.de>; Mon, 18 Jan 2021 18:55:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407286AbhARRzT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Jan 2021 12:55:19 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:52162 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2436615AbhARRgR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 18 Jan 2021 12:36:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610991290;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eWK8quOaZneogEHvBG4bKxZP6nmi8RjG3iH4OALN36M=;
        b=EEhbHC5hwMmjlgHCLiMayLy1BKrShwaQlFKhoS7PYhPgXIl8hhrtBauEIgPTavxYcR+9fC
        qRDsI/4xvlrawn2iRrIGuPM3CzyVkNhUrIUXO+iYC+7COvREhX+cVSe0Qx2q3rCgGGCoWm
        H9JIpuRdZXiG+W7mNH78IrtkF31xNdA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-146-BJ2vr762Ps6954n_Oxx7DA-1; Mon, 18 Jan 2021 12:34:49 -0500
X-MC-Unique: BJ2vr762Ps6954n_Oxx7DA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 456BC107ACF6
        for <kvm@vger.kernel.org>; Mon, 18 Jan 2021 17:34:48 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-189.ams2.redhat.com [10.36.112.189])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5240919C66;
        Mon, 18 Jan 2021 17:34:47 +0000 (UTC)
Subject: Re: [PATCH kvm-unit-tests 1/4] libcflat: add a few more runtime
 functions
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     mlevitsk@redhat.com
References: <20201223010850.111882-1-pbonzini@redhat.com>
 <20201223010850.111882-2-pbonzini@redhat.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <3f80c41b-30e7-e5e6-e69f-d2fa844b4778@redhat.com>
Date:   Mon, 18 Jan 2021 18:34:46 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20201223010850.111882-2-pbonzini@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/12/2020 02.08, Paolo Bonzini wrote:
> These functions will be used to parse the chaos test's command line.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>   lib/alloc.c    |  9 +++++++-
>   lib/alloc.h    |  1 +
>   lib/libcflat.h |  4 +++-
>   lib/string.c   | 59 +++++++++++++++++++++++++++++++++++++++++++++++---
>   lib/string.h   |  3 +++
>   5 files changed, 71 insertions(+), 5 deletions(-)
> 
> diff --git a/lib/alloc.c b/lib/alloc.c
> index a46f464..a56f664 100644
> --- a/lib/alloc.c
> +++ b/lib/alloc.c
> @@ -1,7 +1,7 @@
>   #include "alloc.h"
>   #include "bitops.h"
>   #include "asm/page.h"
> -#include "bitops.h"
> +#include "string.h"
>   
>   void *malloc(size_t size)
>   {
> @@ -50,6 +50,13 @@ void *calloc(size_t nmemb, size_t size)
>   	return ptr;
>   }
>   
> +char *strdup(const char *s)
> +{
> +	size_t len = strlen(s) + 1;
> +	char *d = malloc(len);
> +	return strcpy(d, s);
> +}
> +
>   void free(void *ptr)
>   {
>   	if (alloc_ops->free)
> diff --git a/lib/alloc.h b/lib/alloc.h
> index 9b4b634..4139465 100644
> --- a/lib/alloc.h
> +++ b/lib/alloc.h
> @@ -34,5 +34,6 @@ void *malloc(size_t size);
>   void *calloc(size_t nmemb, size_t size);
>   void free(void *ptr);
>   void *memalign(size_t alignment, size_t size);
> +char *strdup(const char *s);

Why did you put the prototype in alloc.h and not in string.h?

  Thomas

