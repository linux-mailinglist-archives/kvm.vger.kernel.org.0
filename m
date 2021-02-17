Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B29E31DC90
	for <lists+kvm@lfdr.de>; Wed, 17 Feb 2021 16:41:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233756AbhBQPkf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Feb 2021 10:40:35 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49091 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233730AbhBQPkd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 17 Feb 2021 10:40:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613576346;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Fva47oAuw/bGzCzXQdHv2Fg9oz19f4RsSm8/YlamQ4Y=;
        b=ikBGCC6/voVt7av3n/0KJ2mpvcpRmx3hXVRX9uiktMV9ZSLLQAezCccZwa2FxKhfnODFc+
        ZU2aOn9PQck9TSOjXl2H/9lso50pYC11555q2336OSRqa9lIDZ2uYYL81vfsOITtor0nMF
        OMdmlXp0UDZnNMA7vcp4hebu3xefFss=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-595-VkvXmX3pNI-4KQBhTEniAA-1; Wed, 17 Feb 2021 10:38:58 -0500
X-MC-Unique: VkvXmX3pNI-4KQBhTEniAA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E78E3192D786;
        Wed, 17 Feb 2021 15:38:56 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-116.ams2.redhat.com [10.36.112.116])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5437860C62;
        Wed, 17 Feb 2021 15:38:52 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v2 3/8] RFC: s390x: Define
 STACK_FRAME_INT_SIZE macro
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        pmorel@linux.ibm.com, david@redhat.com
References: <20210217144116.3368-1-frankja@linux.ibm.com>
 <20210217144116.3368-4-frankja@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <6fd0eb37-03f5-d0ee-8649-27fca1aa50fb@redhat.com>
Date:   Wed, 17 Feb 2021 16:38:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210217144116.3368-4-frankja@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/02/2021 15.41, Janosch Frank wrote:
> Using sizeof is safer than using magic constants. However, it doesn't
> really fit into asm-offsets.h as it's not an offset so I'm happy to
> receive suggestions on where to put it.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>   lib/s390x/asm-offsets.c | 1 +
>   s390x/macros.S          | 4 ++--
>   2 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/lib/s390x/asm-offsets.c b/lib/s390x/asm-offsets.c
> index 96cb21cf..2658b59a 100644
> --- a/lib/s390x/asm-offsets.c
> +++ b/lib/s390x/asm-offsets.c
> @@ -86,6 +86,7 @@ int main(void)
>   	OFFSET(STACK_FRAME_INT_CRS, stack_frame_int, crs);
>   	OFFSET(STACK_FRAME_INT_GRS0, stack_frame_int, grs0);
>   	OFFSET(STACK_FRAME_INT_GRS1, stack_frame_int, grs1);
> +	DEFINE(STACK_FRAME_INT_SIZE, sizeof(struct stack_frame_int));
>   
>   	return 0;
>   }
> diff --git a/s390x/macros.S b/s390x/macros.S
> index d7eeeb55..a7d62c6f 100644
> --- a/s390x/macros.S
> +++ b/s390x/macros.S
> @@ -43,14 +43,14 @@
>   /* Save registers on the stack (r15), so we can have stacked interrupts. */
>   	.macro SAVE_REGS_STACK
>   	/* Allocate a full stack frame */
> -	slgfi   %r15, 32 * 8 + 4 * 8
> +	slgfi   %r15, STACK_FRAME_INT_SIZE
>   	/* Store registers r0 to r14 on the stack */
>   	stmg    %r2, %r15, STACK_FRAME_INT_GRS0(%r15)
>   	stg     %r0, STACK_FRAME_INT_GRS1(%r15)
>   	stg     %r1, STACK_FRAME_INT_GRS1 + 8(%r15)
>   	/* Store the gr15 value before we allocated the new stack */
>   	lgr     %r0, %r15
> -	algfi   %r0, 32 * 8 + 4 * 8
> +	algfi   %r0, STACK_FRAME_INT_SIZE

Ah, well, that of course fixes the problem that I had with the previous 
patch. I'd suggest to merge it into patch 2.

  Thomas

