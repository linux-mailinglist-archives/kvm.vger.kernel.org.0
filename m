Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B00031FCDA
	for <lists+kvm@lfdr.de>; Fri, 19 Feb 2021 17:12:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229806AbhBSQLg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Feb 2021 11:11:36 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:60506 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229849AbhBSQL2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 19 Feb 2021 11:11:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613751001;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=N9P/i9bBxjxPUr0fTpSG6GTSxPWOv5nXFwFZ5OtmTGs=;
        b=BharaA6PMFsmVxUfDfTpyhEAsRMn0P+At24gal1D+TJ3cvQbgd/Ipi2Uw5vDC8bNTVWRxE
        UIHSWqFUi7m/y54IjqtYlgbY3x0Fg4wmZlnGcHXhjuDSNb2XuE0Rr8JQ+6w1j6599QMuMP
        GlVK3caRwa4I+KPjroXZvP8BqGmJ+nI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-422-woNH6Pj5M9aDhHWjQOZu9g-1; Fri, 19 Feb 2021 11:09:59 -0500
X-MC-Unique: woNH6Pj5M9aDhHWjQOZu9g-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BA4E1835E20;
        Fri, 19 Feb 2021 16:09:56 +0000 (UTC)
Received: from gondolin (ovpn-113-92.ams2.redhat.com [10.36.113.92])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 17BC71970D;
        Fri, 19 Feb 2021 16:09:51 +0000 (UTC)
Date:   Fri, 19 Feb 2021 17:09:49 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        thuth@redhat.com
Subject: Re: [PATCH v3 1/1] s390:kvm: diag9c forwarding
Message-ID: <20210219170949.6300c056.cohuck@redhat.com>
In-Reply-To: <1613405210-16532-2-git-send-email-pmorel@linux.ibm.com>
References: <1613405210-16532-1-git-send-email-pmorel@linux.ibm.com>
        <1613405210-16532-2-git-send-email-pmorel@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 15 Feb 2021 17:06:50 +0100
Pierre Morel <pmorel@linux.ibm.com> wrote:

Make $SUBJECT

"KVM: s390: diag9c (directed yield) forwarding" ?

> When we receive intercept a DIAG_9C from the guest we verify

Either 'receive' or 'intercept', I guess :)

> that the target real CPU associated with the virtual CPU
> designated by the guest is running and if not we forward the
> DIAG_9C to the target real CPU.
> 
> To avoid a diag9c storm we allow a maximal rate of diag9c forwarding.
> 
> The rate is calculated as a count per second defined as a
> new parameter of the s390 kvm module: diag9c_forwarding_hz .
> 
> The default value is to not forward diag9c.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>  Documentation/virt/kvm/s390-diag.rst | 33 ++++++++++++++++++++++++++++
>  arch/s390/include/asm/kvm_host.h     |  1 +
>  arch/s390/include/asm/smp.h          |  1 +
>  arch/s390/kernel/smp.c               |  1 +
>  arch/s390/kvm/diag.c                 | 31 +++++++++++++++++++++++---
>  arch/s390/kvm/kvm-s390.c             |  6 +++++
>  arch/s390/kvm/kvm-s390.h             |  8 +++++++
>  7 files changed, 78 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/s390-diag.rst b/Documentation/virt/kvm/s390-diag.rst
> index eaac4864d3d6..a6371bc4ea90 100644
> --- a/Documentation/virt/kvm/s390-diag.rst
> +++ b/Documentation/virt/kvm/s390-diag.rst
> @@ -84,3 +84,36 @@ If the function code specifies 0x501, breakpoint functions may be performed.
>  This function code is handled by userspace.
>  
>  This diagnose function code has no subfunctions and uses no parameters.
> +
> +
> +DIAGNOSE function code 'X'9C - Voluntary Time Slice Yield
> +---------------------------------------------------------
> +
> +General register 1 contains the target CPU address.
> +
> +In a guest of a hypervisor like LPAR, KVM or z/VM using shared host CPUs,
> +DIAGNOSE with function code 'X'9C may improve system performance by
> +yielding the host CPU on which the guest CPU is running to be assigned
> +to another guest CPU, preferably the logical CPU containing the specified
> +target CPU.
> +
> +
> +DIAG 'X'9C forwarding
> ++++++++++++++++++++++
> +
> +Under KVM, the guest operating system may send a DIAGNOSE code 'X'9C to
> +the host when it fails to acquire a spinlock for a virtual CPU
> +and detects that the host CPU on which the virtual guest CPU owner is
> +assigned to is not running to try to get this host CPU running and
> +consequently the guest virtual CPU running and freeing the lock.

What about:

"The guest may send a DIAGNOSE 0x9c in order to yield to a certain
other vcpu. An example is a Linux guest that tries to yield to the vcpu
that is currently holding a spinlock, but not running."

> +
> +However, on the logical partition the real CPU on which the previously
> +targeted host CPU is assign may itself not be running.

"However, on the host the real cpu backing the vcpu may itself not be
running."

> +By forwarding the DIAGNOSE code 'X'9C, initially sent by the guest,
> +from the host to LPAR hypervisor, this one will hopefully schedule
> +the host CPU which will let KVM run the target guest CPU.

"Forwarding the DIAGNOSE 0x9c initially sent by the guest to yield to
the backing cpu will hopefully cause that cpu, and thus subsequently
the guest's vcpu, to be scheduled."

[I don't think we should explicitly talk about LPAR here, as the same
should apply if we are running second-or-deeper level, right?]

> +
> +diag9c_forwarding_hz
> +    KVM kernel parameter allowing to specify the maximum number of DIAGNOSE
> +    'X'9C forwarding per second in the purpose of avoiding a DIAGNOSE 'X'9C
> +    forwarding storm.

I think 0x9c is the more common way to write the hex code.

Also,

"A value of 0 turns the forwarding off" ?

(...)

> diff --git a/arch/s390/kernel/smp.c b/arch/s390/kernel/smp.c
> index 27c763014114..15e207a671fd 100644
> --- a/arch/s390/kernel/smp.c
> +++ b/arch/s390/kernel/smp.c
> @@ -422,6 +422,7 @@ void notrace smp_yield_cpu(int cpu)
>  	asm volatile("diag %0,0,0x9c"
>  		     : : "d" (pcpu_devices[cpu].address));
>  }
> +EXPORT_SYMBOL(smp_yield_cpu);

EXPORT_SYMBOL_GPL?

>  
>  /*
>   * Send cpus emergency shutdown signal. This gives the cpus the

(...)

> @@ -190,6 +191,11 @@ static bool use_gisa  = true;
>  module_param(use_gisa, bool, 0644);
>  MODULE_PARM_DESC(use_gisa, "Use the GISA if the host supports it.");
>  
> +/* maximum diag9c forwarding per second */
> +unsigned int diag9c_forwarding_hz;
> +module_param(diag9c_forwarding_hz, uint, 0644);
> +MODULE_PARM_DESC(diag9c_forwarding_hz, "Maximum diag9c forwarding per second");

Maybe also add "(0 to turn off forwarding)" here?

> +
>  /*
>   * For now we handle at most 16 double words as this is what the s390 base
>   * kernel handles and stores in the prefix page. If we ever need to go beyond

(...)

