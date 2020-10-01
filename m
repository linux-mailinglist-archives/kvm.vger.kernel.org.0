Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4FE627FC4F
	for <lists+kvm@lfdr.de>; Thu,  1 Oct 2020 11:12:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731635AbgJAJMr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Oct 2020 05:12:47 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43317 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731464AbgJAJMr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 1 Oct 2020 05:12:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601543566;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PBIZ69tJ8CkdKZBKw7xnPhYY8S9fPm/kvG6Y8QgGEEw=;
        b=cG20GxlN5nzKjspkYzvKCPSTEfqq7hGdlPlvAV9hsQsWflZXectZKNAjncv4izIe3QISKE
        hWGqE/dU8b1Lej3Jn8ZV2zN7/bcEp5D1K4PqoeamJ9BHR5QO1dzj5ypk2x+rmHwImdLwWf
        H3paNC/SSKapHsJ1BCqWVBg7NqvB5YQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-209-MuvVybAtMFyRWO79LDOFRQ-1; Thu, 01 Oct 2020 05:12:44 -0400
X-MC-Unique: MuvVybAtMFyRWO79LDOFRQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6F9721074642
        for <kvm@vger.kernel.org>; Thu,  1 Oct 2020 09:12:43 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.193.100])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 311B478837;
        Thu,  1 Oct 2020 09:12:41 +0000 (UTC)
Date:   Thu, 1 Oct 2020 11:12:39 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Thomas Huth <thuth@redhat.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, lvivier@redhat.com
Subject: Re: [PATCH v2 5/7] arm/pmu: Fix inline assembly for Clang
Message-ID: <20201001091239.cfuazqd6ear726pd@kamzik.brq.redhat.com>
References: <20201001072234.143703-1-thuth@redhat.com>
 <20201001072234.143703-6-thuth@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201001072234.143703-6-thuth@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 01, 2020 at 09:22:32AM +0200, Thomas Huth wrote:
> Clang complains here:
> 
> arm/pmu.c:201:16: error: value size does not match register size specified by
>  the constraint and modifier [-Werror,-Wasm-operand-widths]
>         : [pmcr] "r" (pmcr)
>                       ^
> arm/pmu.c:194:18: note: use constraint modifier "w"
>         "       msr     pmcr_el0, %[pmcr]\n"
>                                   ^~~~~~~
>                                   %w[pmcr]
> arm/pmu.c:200:17: error: value size does not match register size specified by
>  the constraint and modifier [-Werror,-Wasm-operand-widths]
>         : [loop] "+r" (loop)
>                        ^
> arm/pmu.c:196:11: note: use constraint modifier "w"
>         "1:     subs    %[loop], %[loop], #1\n"
>                         ^~~~~~~
>                         %w[loop]
> arm/pmu.c:200:17: error: value size does not match register size specified by
>  the constraint and modifier [-Werror,-Wasm-operand-widths]
>         : [loop] "+r" (loop)
>                        ^
> arm/pmu.c:196:20: note: use constraint modifier "w"
>         "1:     subs    %[loop], %[loop], #1\n"
>                                  ^~~~~~~
>                                  %w[loop]
> arm/pmu.c:284:35: error: value size does not match register size specified
>  by the constraint and modifier [-Werror,-Wasm-operand-widths]
>         : [addr] "r" (addr), [pmcr] "r" (pmcr), [loop] "r" (loop)
>                                          ^
> arm/pmu.c:274:28: note: use constraint modifier "w"
>         "       msr     pmcr_el0, %[pmcr]\n"
>                                   ^~~~~~~
>                                   %w[pmcr]
> arm/pmu.c:284:54: error: value size does not match register size specified
>  by the constraint and modifier [-Werror,-Wasm-operand-widths]
>         : [addr] "r" (addr), [pmcr] "r" (pmcr), [loop] "r" (loop)
>                                                             ^
> arm/pmu.c:276:23: note: use constraint modifier "w"
>         "       mov     x10, %[loop]\n"
>                              ^~~~~~~
>                              %w[loop]
> 
> pmcr should be 64-bit since it is a sysreg, but for loop we can use the
> "w" modifier.
> 
> Suggested-by: Drew Jones <drjones@redhat.com>
> Signed-off-by: Thomas Huth <thuth@redhat.com>
> ---
>  arm/pmu.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
>

Reviewed-by: Andrew Jones <drjones@redhat.com>
Tested-by: Andrew Jones <drjones@redhat.com> 

