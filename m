Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99F6327FC52
	for <lists+kvm@lfdr.de>; Thu,  1 Oct 2020 11:13:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731725AbgJAJNF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Oct 2020 05:13:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21931 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731670AbgJAJND (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 1 Oct 2020 05:13:03 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601543582;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oR88XqIfPJutZN/QCN2SiWCj/QQj5tqcPUaLprpR3Kc=;
        b=Uxvjlxa53q22Eab+2jycSOQ3a1IWSsZiIoREGPHVa+Zs/4Zo/4hdsqkORh7JViOw9hS4Sm
        3Hre9dIs6zwCoTxCHGkiBNw0eL1Jc5DFIkD02a/qBpsrOXmVcHo6urqrmUiTPrFS/FRutN
        D5GIA0uJVs+IMqu/VIFhsOZ2GZvZa2c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-561-NQSR-oVdO3S1a8ZwaiYq-g-1; Thu, 01 Oct 2020 05:13:00 -0400
X-MC-Unique: NQSR-oVdO3S1a8ZwaiYq-g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4F4FE1074642
        for <kvm@vger.kernel.org>; Thu,  1 Oct 2020 09:12:59 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.193.100])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 11B475C1DA;
        Thu,  1 Oct 2020 09:12:57 +0000 (UTC)
Date:   Thu, 1 Oct 2020 11:12:55 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Thomas Huth <thuth@redhat.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, lvivier@redhat.com
Subject: Re: [PATCH v2 6/7] lib/arm64/spinlock: Fix inline assembly for Clang
Message-ID: <20201001091255.uomjxjvsuyi23pql@kamzik.brq.redhat.com>
References: <20201001072234.143703-1-thuth@redhat.com>
 <20201001072234.143703-7-thuth@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201001072234.143703-7-thuth@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 01, 2020 at 09:22:33AM +0200, Thomas Huth wrote:
> /home/travis/build/huth/kvm-unit-tests/lib/arm64/spinlock.c:29:12: error:
>  value size does not match register size specified by the constraint and
>  modifier [-Werror,-Wasm-operand-widths]
>                 : "=&r" (val), "=&r" (fail)
>                          ^
> /home/travis/build/huth/kvm-unit-tests/lib/arm64/spinlock.c:27:9: note: use
>  constraint modifier "w"
>                 "       mov     %0, #1\n"
>                                 ^~
>                                 %w0
> 
> Use the "w" modifier as suggested to fix the issue.
> 
> Signed-off-by: Thomas Huth <thuth@redhat.com>
> ---
>  lib/arm64/spinlock.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/lib/arm64/spinlock.c b/lib/arm64/spinlock.c
> index fac4fc9..258303d 100644
> --- a/lib/arm64/spinlock.c
> +++ b/lib/arm64/spinlock.c
> @@ -24,7 +24,7 @@ void spin_lock(struct spinlock *lock)
>  		asm volatile(
>  		"1:	ldaxr	%w0, [%2]\n"
>  		"	cbnz	%w0, 1b\n"
> -		"	mov	%0, #1\n"
> +		"	mov	%w0, #1\n"
>  		"	stxr	%w1, %w0, [%2]\n"
>  		: "=&r" (val), "=&r" (fail)
>  		: "r" (&lock->v)
> -- 
> 2.18.2
>

Reviewed-by: Andrew Jones <drjones@redhat.com>
Tested-by: Andrew Jones <drjones@redhat.com> 

