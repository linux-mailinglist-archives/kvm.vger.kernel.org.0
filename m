Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA51C30F3A3
	for <lists+kvm@lfdr.de>; Thu,  4 Feb 2021 14:06:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236228AbhBDNFU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Feb 2021 08:05:20 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:28965 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236224AbhBDNFG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 4 Feb 2021 08:05:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612443819;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LNmCI2qa2oNRzk6pe2ACw9Aec8o5VaxAt01B6jxHxt8=;
        b=aIzKvfKXpY00jiOC2t2Q34FFTB8h4m0Gl2jh166tpHEc5YjD2kz4W8rmCi6JrEun9OvtDd
        H+cCsHoSN1s60aXOsmbIGXTOXfY0TDmY+nyq1Z64hSSFJg+c8P/wcyBJdD/9C+Z7aLNCVY
        4F5Dux2Ab03UCd10PTqlrTzC3rgSQq4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-563-Cv-AFhI7N1CYleqpF1kyrA-1; Thu, 04 Feb 2021 08:03:35 -0500
X-MC-Unique: Cv-AFhI7N1CYleqpF1kyrA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 17CFD18CAE18;
        Thu,  4 Feb 2021 13:03:34 +0000 (UTC)
Received: from gondolin (ovpn-113-130.ams2.redhat.com [10.36.113.130])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D584C60C5F;
        Thu,  4 Feb 2021 13:03:32 +0000 (UTC)
Date:   Thu, 4 Feb 2021 14:03:29 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Elena Afanasova <eafanasova@gmail.com>
Cc:     kvm@vger.kernel.org, stefanha@redhat.com, jag.raman@oracle.com,
        elena.ufimtseva@oracle.com
Subject: Re: [RESEND RFC v2 1/4] KVM: add initial support for
 KVM_SET_IOREGION
Message-ID: <20210204140329.5f3a49ca.cohuck@redhat.com>
In-Reply-To: <de84fca7e7ad62943eb15e4e9dd598d4d0f806ef.1611850291.git.eafanasova@gmail.com>
References: <cover.1611850290.git.eafanasova@gmail.com>
        <de84fca7e7ad62943eb15e4e9dd598d4d0f806ef.1611850291.git.eafanasova@gmail.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 29 Jan 2021 21:48:26 +0300
Elena Afanasova <eafanasova@gmail.com> wrote:

[Note: I've just started looking at this, please excuse any questions
that have already been answered elsewhere.]

> This vm ioctl adds or removes an ioregionfd MMIO/PIO region. Guest
> read and write accesses are dispatched through the given ioregionfd
> instead of returning from ioctl(KVM_RUN). Regions can be deleted by
> setting fds to -1.
> 
> Signed-off-by: Elena Afanasova <eafanasova@gmail.com>
> ---
> Changes in v2:
>   - changes after code review
> 
>  arch/x86/kvm/Kconfig     |   1 +
>  arch/x86/kvm/Makefile    |   1 +
>  arch/x86/kvm/x86.c       |   1 +
>  include/linux/kvm_host.h |  17 +++
>  include/uapi/linux/kvm.h |  23 ++++
>  virt/kvm/Kconfig         |   3 +
>  virt/kvm/eventfd.c       |  25 +++++
>  virt/kvm/eventfd.h       |  14 +++
>  virt/kvm/ioregion.c      | 232 +++++++++++++++++++++++++++++++++++++++
>  virt/kvm/ioregion.h      |  15 +++
>  virt/kvm/kvm_main.c      |  11 ++
>  11 files changed, 343 insertions(+)
>  create mode 100644 virt/kvm/eventfd.h
>  create mode 100644 virt/kvm/ioregion.c
>  create mode 100644 virt/kvm/ioregion.h

(...)

> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index ca41220b40b8..81e775778c66 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -732,6 +732,27 @@ struct kvm_ioeventfd {
>  	__u8  pad[36];
>  };
>  
> +enum {
> +	kvm_ioregion_flag_nr_pio,
> +	kvm_ioregion_flag_nr_posted_writes,
> +	kvm_ioregion_flag_nr_max,
> +};
> +
> +#define KVM_IOREGION_PIO (1 << kvm_ioregion_flag_nr_pio)
> +#define KVM_IOREGION_POSTED_WRITES (1 << kvm_ioregion_flag_nr_posted_writes)
> +
> +#define KVM_IOREGION_VALID_FLAG_MASK ((1 << kvm_ioregion_flag_nr_max) - 1)
> +
> +struct kvm_ioregion {
> +	__u64 guest_paddr; /* guest physical address */
> +	__u64 memory_size; /* bytes */
> +	__u64 user_data;
> +	__s32 rfd;
> +	__s32 wfd;

I guess these are read and write file descriptors? Maybe call them
read_fd and write_fd?

> +	__u32 flags;
> +	__u8  pad[28];
> +};
> +
>  #define KVM_X86_DISABLE_EXITS_MWAIT          (1 << 0)
>  #define KVM_X86_DISABLE_EXITS_HLT            (1 << 1)
>  #define KVM_X86_DISABLE_EXITS_PAUSE          (1 << 2)
> @@ -1053,6 +1074,7 @@ struct kvm_ppc_resize_hpt {
>  #define KVM_CAP_X86_USER_SPACE_MSR 188
>  #define KVM_CAP_X86_MSR_FILTER 189
>  #define KVM_CAP_ENFORCE_PV_FEATURE_CPUID 190
> +#define KVM_CAP_IOREGIONFD 191
>  
>  #ifdef KVM_CAP_IRQ_ROUTING
>  
> @@ -1308,6 +1330,7 @@ struct kvm_vfio_spapr_tce {
>  					struct kvm_userspace_memory_region)
>  #define KVM_SET_TSS_ADDR          _IO(KVMIO,   0x47)
>  #define KVM_SET_IDENTITY_MAP_ADDR _IOW(KVMIO,  0x48, __u64)
> +#define KVM_SET_IOREGION          _IOW(KVMIO,  0x49, struct kvm_ioregion)

This new ioctl needs some documentation under
Documentation/virt/kvm/api.rst. (That would also make review easier.)

>  
>  /* enable ucontrol for s390 */
>  struct kvm_s390_ucas_mapping {

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

Not a problem right now, as this is x86 only, but I'm not sure we can
define "overlap" in a meaningful way for every bus_idx. (For example,
the s390-only ccw notifications use addr to identify a device; as long
as addr is unique, there will be no clash. I'm not sure yet if
ioregions are usable for ccw devices, and if yes, in which form, but we
should probably keep it in mind.)

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
> +	if (p->bus_idx == KVM_MMIO_BUS || p->bus_idx == KVM_PIO_BUS)
> +		if (kvm_ioregion_collides(kvm, p->bus_idx, p->addr,
> +					  !p->length ? 8 : p->length))

What about KVM_FAST_MMIO_BUS?

> +			return true;
> +#endif
> +
>  	return false;
>  }
>  

(...)

> +/* check for not overlapping case and reverse */
> +inline bool
> +overlap(u64 start1, u64 size1, u64 start2, u64 size2)
> +{
> +	u64 end1 = start1 + size1 - 1;
> +	u64 end2 = start2 + size2 - 1;
> +
> +	return !(end1 < start2 || start1 >= end2);
> +}

I'm wondering whether there's already a generic function to do a check
like this?

(...)

