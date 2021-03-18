Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C85B23408EF
	for <lists+kvm@lfdr.de>; Thu, 18 Mar 2021 16:32:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230040AbhCRPba (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Mar 2021 11:31:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30969 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231693AbhCRPbZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 18 Mar 2021 11:31:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616081484;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ao7CPe7kd5qz4GgxN6cUhKscPdpjYusPLJxpKNKQhsI=;
        b=JrLpmvx6m/2WbFDzs1rAewSg9M0QRNJTAKIBN9yLCQgB1EiiSzTI8TBeIandwLj/kA2qZm
        clm2/V7sKb+/uoBNwfb1L3SqqOe57Tm71lGKlXcAmm/T2Z24J6soz81qVv0kOj0Ds3x/IT
        mp0Go+EIEvar+eXWgX8qCGfrM5uz6cA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-351-TwECCVB-NZKXTr7WV_h3Ng-1; Thu, 18 Mar 2021 11:31:23 -0400
X-MC-Unique: TwECCVB-NZKXTr7WV_h3Ng-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ADA338018A2;
        Thu, 18 Mar 2021 15:31:21 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.196.5])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0D8455044A;
        Thu, 18 Mar 2021 15:31:16 +0000 (UTC)
Date:   Thu, 18 Mar 2021 16:31:14 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, lvivier@redhat.com, thuth@redhat.com,
        david@redhat.com, pbonzini@redhat.com, cohuck@redhat.com
Subject: Re: [kvm-unit-tests RFC 1/2] scripts: Check kvm availability by
 asking qemu
Message-ID: <20210318153114.ohppqscosrijj7bs@kamzik.brq.redhat.com>
References: <20210318124500.45447-1-frankja@linux.ibm.com>
 <20210318124500.45447-2-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210318124500.45447-2-frankja@linux.ibm.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 18, 2021 at 12:44:59PM +0000, Janosch Frank wrote:
> The existence of the /dev/kvm character device doesn't imply that the
> kvm module is part of the kernel or that it's always magically loaded
> when needed.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  arm/run               | 4 ++--
>  powerpc/run           | 4 ++--
>  s390x/run             | 4 ++--
>  scripts/arch-run.bash | 7 +++++--
>  x86/run               | 4 ++--
>  5 files changed, 13 insertions(+), 10 deletions(-)
> 
> diff --git a/arm/run b/arm/run
> index a390ca5a..ca2d44e0 100755
> --- a/arm/run
> +++ b/arm/run
> @@ -10,10 +10,10 @@ if [ -z "$STANDALONE" ]; then
>  fi
>  processor="$PROCESSOR"
>  
> -ACCEL=$(get_qemu_accelerator) ||
> +qemu=$(search_qemu_binary) ||
>  	exit $?
>  
> -qemu=$(search_qemu_binary) ||
> +ACCEL=$(get_qemu_accelerator) ||
>  	exit $?

How about renaming search_qemu_binary() to set_qemu_accelerator(), which
would also ensure QEMU is set (if it doesn't error out on failure) and
then call that from get_qemu_accelerator()? That way we don't need to
worry about this order of calls nor this lowercase 'qemu' variable being
set. Also, we can rename get_qemu_accelerator() to set_qemu_accelerator()
and ensure it sets ACCEL.

Thanks,
drew

