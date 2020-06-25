Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 102B6209D41
	for <lists+kvm@lfdr.de>; Thu, 25 Jun 2020 13:09:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404083AbgFYLJu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Jun 2020 07:09:50 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:44331 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2404042AbgFYLJt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 25 Jun 2020 07:09:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593083387;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=414dz0hN6JZuQ+Lj2kCtX1/sSgrlvJ69+d5ay2kJPaU=;
        b=d9YRXUaOX/TGvy942v0w3mWoblHE/v12hTrdPUfcVPFqhuSJeKN0w/fAluZYMjVB85Sggh
        xsoIkHybGZXnXXuaHnuQI3g37C575yegGTc1+F8P2sQicKe070EqMXv6FdWiVd7VDZRPnW
        rYWFhaDNs5PxYjceSgcXVwTsY2f1M7I=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-117-m9NchG2hNX-uU-WgKlj56A-1; Thu, 25 Jun 2020 07:09:46 -0400
X-MC-Unique: m9NchG2hNX-uU-WgKlj56A-1
Received: by mail-wr1-f72.google.com with SMTP id f5so6515725wrv.22
        for <kvm@vger.kernel.org>; Thu, 25 Jun 2020 04:09:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=414dz0hN6JZuQ+Lj2kCtX1/sSgrlvJ69+d5ay2kJPaU=;
        b=pU2yG1Y2ct+jvK+7bqgpws6Md63d2mrpBmcG7BORglfuF6yJxB0SWyEflcqTuKtmar
         ZvoGLHaqOMcwotjYtXm/nv7xoWMqRQonNClkFMiFAWUMQ6kMmASGWZ8fcn3bz5Q8735O
         nNI4gRtBTgMs3wNhaAtegwIGk6+fZR1OeHt6Xxmt9LkfkVw+RHIcM/YhrSvwJi9Sjdcy
         y0BZTmuPWTgJiDs59DzkSUmg6AUlLcrI6gsbJHR6CtnhuU3G+scdkTTkUeJ0yHB+AOHe
         IrPZYRJq7H6w4nwcvkyPz8sm4SqYstclgaB4X/qtp920LgxvrTku8SRUUrRhiTdpgp18
         pS3A==
X-Gm-Message-State: AOAM531vmHxXRKyaxXCyQ/2l0FsM41S9yRKHK3nOcRkTqTjTI6/OlKzC
        AGOr/obNCHTG/NbFCY8QYWgyAvSQpT3O2m/sMTYbAlr3MkemXQ6yCyN7OzftaVmTQo6e7DhV5iM
        Uln8ZeyXbMFDm
X-Received: by 2002:adf:afc7:: with SMTP id y7mr36134502wrd.173.1593083384733;
        Thu, 25 Jun 2020 04:09:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJysruiP9wUV/6ak5eR135Z60MsRm2t2OatIMsUZA7SZ/jK/0PsGFsU+eMGLSQ9pBGrO94xaTA==
X-Received: by 2002:adf:afc7:: with SMTP id y7mr36134484wrd.173.1593083384540;
        Thu, 25 Jun 2020 04:09:44 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:91d0:a5f0:9f34:4d80? ([2001:b07:6468:f312:91d0:a5f0:9f34:4d80])
        by smtp.gmail.com with ESMTPSA id o7sm10264034wmb.9.2020.06.25.04.09.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Jun 2020 04:09:44 -0700 (PDT)
Subject: Re: [PATCH kvm-unit-tests] i386: setup segment registers before
 percpu areas
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     kvm@vger.kernel.org
References: <20200624141429.382157-1-pbonzini@redhat.com>
 <A954DB27-C5E8-435B-A1D7-76D21943F70F@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f284b980-32dc-1cb3-84d7-923ce9dea503@redhat.com>
Date:   Thu, 25 Jun 2020 13:09:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <A954DB27-C5E8-435B-A1D7-76D21943F70F@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/06/20 21:58, Nadav Amit wrote:
> From: Nadav Amit <namit@vmware.com>
> Date: Wed, 24 Jun 2020 19:50:36 +0000
> Subject: [PATCH] x86: load gdt while loading segments
> 
> Signed-off-by: Nadav Amit <namit@vmware.com>
> ---
>  x86/cstart.S | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/x86/cstart.S b/x86/cstart.S
> index dd33d4d..1d8b8ac 100644
> --- a/x86/cstart.S
> +++ b/x86/cstart.S
> @@ -95,6 +95,8 @@ MSR_GS_BASE = 0xc0000101
>  .endm
>  
>  .macro setup_segments
> +	lgdtl gdt32_descr
> +
>  	mov $0x10, %ax
>  	mov %ax, %ds
>  	mov %ax, %es
> @@ -106,6 +108,8 @@ MSR_GS_BASE = 0xc0000101
>  .globl start
>  start:
>          mov $stacktop, %esp
> +	setup_segments
> +
>          push %ebx
>          call setup_multiboot
>          call setup_libcflat
> @@ -117,9 +121,6 @@ start:
>          jmpl $8, $start32
>  
>  prepare_32:
> -        lgdtl gdt32_descr
> -	setup_segments
> -
>  	mov %cr4, %eax
>  	bts $4, %eax  // pse
>  	mov %eax, %cr4
> -- 

The GDT is already loaded elsewhere for APs, but the gist of the patch
is good.  I'll send v2

Paolo

