Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45EA532EBEC
	for <lists+kvm@lfdr.de>; Fri,  5 Mar 2021 14:12:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229749AbhCENMJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Mar 2021 08:12:09 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:50173 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229729AbhCENLw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 5 Mar 2021 08:11:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614949911;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rgnKng4hqKLgD3zTYstd+/SkskcTGFWcTR4OwRSFbLw=;
        b=clwm0XREtg4XpjWXds4pSXwDFAQU6rbF07vA/ZlNXDcK36tRNtU9AHqo26YQ5/TB2FixA6
        NyLypE7vWpLJeSdjrlRk+7DZvMWB4vypQ3lezQiXggxFPVcP0NetBEQ/4i6JDVjO0owrnD
        C0d3awZ8+Avlp7gSYy5JR/OnsdXq7Kg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-230-FKXI08mCPOK9JnXUOJuctQ-1; Fri, 05 Mar 2021 08:11:49 -0500
X-MC-Unique: FKXI08mCPOK9JnXUOJuctQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8BD7094DCE;
        Fri,  5 Mar 2021 13:11:48 +0000 (UTC)
Received: from gondolin (ovpn-112-55.ams2.redhat.com [10.36.112.55])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9D64A19D9B;
        Fri,  5 Mar 2021 13:11:40 +0000 (UTC)
Date:   Fri, 5 Mar 2021 14:09:57 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Elena Afanasova <eafanasova@gmail.com>
Cc:     kvm@vger.kernel.org, stefanha@redhat.com, jag.raman@oracle.com,
        elena.ufimtseva@oracle.com, pbonzini@redhat.com,
        jasowang@redhat.com, mst@redhat.com, john.levon@nutanix.com
Subject: Re: [RFC v3 1/5] KVM: add initial support for KVM_SET_IOREGION
Message-ID: <20210305140957.745f151f.cohuck@redhat.com>
In-Reply-To: <f77bbc58289508b5b0633521cf8c03eb0303707a.1613828727.git.eafanasova@gmail.com>
References: <cover.1613828726.git.eafanasova@gmail.com>
        <f77bbc58289508b5b0633521cf8c03eb0303707a.1613828727.git.eafanasova@gmail.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, 21 Feb 2021 15:04:37 +0300
Elena Afanasova <eafanasova@gmail.com> wrote:

> This vm ioctl adds or removes an ioregionfd MMIO/PIO region. Guest
> read and write accesses are dispatched through the given ioregionfd
> instead of returning from ioctl(KVM_RUN).
> 
> Signed-off-by: Elena Afanasova <eafanasova@gmail.com>
> ---
> v3:
>  - add FAST_MMIO bus support
>  - add KVM_IOREGION_DEASSIGN flag
>  - rename kvm_ioregion read/write file descriptors
> 
>  arch/x86/kvm/Kconfig     |   1 +
>  arch/x86/kvm/Makefile    |   1 +
>  arch/x86/kvm/x86.c       |   1 +
>  include/linux/kvm_host.h |  18 +++
>  include/uapi/linux/kvm.h |  25 ++++
>  virt/kvm/Kconfig         |   3 +
>  virt/kvm/eventfd.c       |  25 ++++
>  virt/kvm/eventfd.h       |  14 +++
>  virt/kvm/ioregion.c      | 265 +++++++++++++++++++++++++++++++++++++++
>  virt/kvm/ioregion.h      |  15 +++
>  virt/kvm/kvm_main.c      |  11 ++
>  11 files changed, 379 insertions(+)
>  create mode 100644 virt/kvm/eventfd.h
>  create mode 100644 virt/kvm/ioregion.c
>  create mode 100644 virt/kvm/ioregion.h
> 

(...)

> diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
> index c2323c27a28b..aadb73903f8b 100644
> --- a/virt/kvm/eventfd.c
> +++ b/virt/kvm/eventfd.c
> @@ -27,6 +27,7 @@
>  #include <trace/events/kvm.h>
>  
>  #include <kvm/iodev.h>
> +#include "ioregion.h"
>  
>  #ifdef CONFIG_HAVE_KVM_IRQFD
>  
> @@ -755,6 +756,23 @@ static const struct kvm_io_device_ops ioeventfd_ops = {
>  	.destructor = ioeventfd_destructor,
>  };
>  
> +#ifdef CONFIG_KVM_IOREGION
> +/* assumes kvm->slots_lock held */
> +bool kvm_eventfd_collides(struct kvm *kvm, int bus_idx,
> +			  u64 start, u64 size)
> +{
> +	struct _ioeventfd *_p;
> +
> +	list_for_each_entry(_p, &kvm->ioeventfds, list)
> +		if (_p->bus_idx == bus_idx &&
> +		    overlap(start, size, _p->addr,
> +			    !_p->length ? 8 : _p->length))

I'm wondering whether we should enable a bus-specific overlap()
function; that would make it possible to wire up weird things like ccw.
But not really needed right now, and can be easily added when it
becomes relevant.

> +			return true;
> +
> +	return false;
> +}
> +#endif
> +
>  /* assumes kvm->slots_lock held */
>  static bool
>  ioeventfd_check_collision(struct kvm *kvm, struct _ioeventfd *p)
> @@ -770,6 +788,13 @@ ioeventfd_check_collision(struct kvm *kvm, struct _ioeventfd *p)
>  		       _p->datamatch == p->datamatch))))
>  			return true;
>  
> +#ifdef CONFIG_KVM_IOREGION

This might benefit from a comment why you only check these two
(especially as you also check FAST_MMIO during ioregionfd setup.)

> +	if (p->bus_idx == KVM_MMIO_BUS || p->bus_idx == KVM_PIO_BUS)
> +		if (kvm_ioregion_collides(kvm, p->bus_idx, p->addr,
> +					  !p->length ? 8 : p->length))
> +			return true;
> +#endif
> +
>  	return false;
>  }
>  

(...)

