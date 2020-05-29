Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4CA41E8A52
	for <lists+kvm@lfdr.de>; Fri, 29 May 2020 23:46:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728500AbgE2Vp7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 May 2020 17:45:59 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:54627 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728448AbgE2Vp4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 29 May 2020 17:45:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590788755;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Hk0at023Zvqhem6/Bx2jt7JMXphEsEpczIZcYvSi8MU=;
        b=R7l49T5sac2HVDpJCUS40QstAmdPWRl63dZ+tz+RXn7zbcDQkbf3/nx5Xka7EpOf8e16sD
        qz5t8SBoGh8G+ROUkHlnBeiQHvqq0zjUBbXRs4APsZzuoxQJXudYYrkcmfqe/oVar+OxCK
        8V8zG1cZym7Mavj9W6tSJD26ZHKle4Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-108-q_XJbKVmNCq31t6eorr3qg-1; Fri, 29 May 2020 17:45:51 -0400
X-MC-Unique: q_XJbKVmNCq31t6eorr3qg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 304B01005510;
        Fri, 29 May 2020 21:45:49 +0000 (UTC)
Received: from x1.home (ovpn-112-195.phx2.redhat.com [10.3.112.195])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6EF3210013C2;
        Fri, 29 May 2020 21:45:48 +0000 (UTC)
Date:   Fri, 29 May 2020 15:45:47 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Yan Zhao <yan.y.zhao@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        cohuck@redhat.com, zhenyuw@linux.intel.com, zhi.a.wang@intel.com,
        kevin.tian@intel.com, shaopeng.he@intel.com, yi.l.liu@intel.com,
        xin.zeng@intel.com, hang.yuan@intel.com
Subject: Re: [RFC PATCH v4 07/10] vfio/pci: introduce a new irq type
 VFIO_IRQ_TYPE_REMAP_BAR_REGION
Message-ID: <20200529154547.19a6685f@x1.home>
In-Reply-To: <20200518025245.14425-1-yan.y.zhao@intel.com>
References: <20200518024202.13996-1-yan.y.zhao@intel.com>
        <20200518025245.14425-1-yan.y.zhao@intel.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, 17 May 2020 22:52:45 -0400
Yan Zhao <yan.y.zhao@intel.com> wrote:

> This is a virtual irq type.
> vendor driver triggers this irq when it wants to notify userspace to
> remap PCI BARs.
> 
> 1. vendor driver triggers this irq and packs the target bar number in
>    the ctx count. i.e. "1 << bar_number".
>    if a bit is set, the corresponding bar is to be remapped.
> 
> 2. userspace requery the specified PCI BAR from kernel and if flags of
> the bar regions are changed, it removes the old subregions and attaches
> subregions according to the new flags.
> 
> 3. userspace notifies back to kernel by writing one to the eventfd of
> this irq.
> 
> Please check the corresponding qemu implementation from the reply of this
> patch, and a sample usage in vendor driver in patch [10/10].
> 
> Cc: Kevin Tian <kevin.tian@intel.com>
> Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> ---
>  include/uapi/linux/vfio.h | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index 2d0d85c7c4d4..55895f75d720 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -704,6 +704,17 @@ struct vfio_irq_info_cap_type {
>  	__u32 subtype;  /* type specific */
>  };
>  
> +/* Bar Region Query IRQ TYPE */
> +#define VFIO_IRQ_TYPE_REMAP_BAR_REGION			(1)
> +
> +/* sub-types for VFIO_IRQ_TYPE_REMAP_BAR_REGION */
> +/*
> + * This irq notifies userspace to re-query BAR region and remaps the
> + * subregions.
> + */
> +#define VFIO_IRQ_SUBTYPE_REMAP_BAR_REGION	(0)

Hi Yan,

How do we do this in a way that's backwards compatible?  Or maybe, how
do we perform a handshake between the vendor driver and userspace to
indicate this support?  Would the vendor driver refuse to change
device_state in the migration region if the user has not enabled this
IRQ?

Everything you've described in the commit log needs to be in this
header, we can't have the usage protocol buried in a commit log.  It
also seems like this is unnecessarily PCI specific.  Can't the count
bitmap simply indicate the region index to re-evaluate?  Maybe you were
worried about running out of bits in the ctx count?  An IRQ per region
could resolve that, but maybe we could also just add another IRQ for
the next bitmap of regions.  I assume that the bitmap can indicate
multiple regions to re-evaluate, but that should be documented.

Also, what sort of service requirements does this imply?  Would the
vendor driver send this IRQ when the user tries to set the device_state
to _SAVING and therefore we'd require the user to accept, implement the
mapping change, and acknowledge the IRQ all while waiting for the write
to device_state to return?  That implies quite a lot of asynchronous
support in the userspace driver.  Thanks,

Alex

> +
> +
>  /**
>   * VFIO_DEVICE_SET_IRQS - _IOW(VFIO_TYPE, VFIO_BASE + 10, struct vfio_irq_set)
>   *

