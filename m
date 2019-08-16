Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B613909AA
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2019 22:52:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727589AbfHPUvw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Aug 2019 16:51:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56626 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727607AbfHPUvv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Aug 2019 16:51:51 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id CB462859FB;
        Fri, 16 Aug 2019 20:51:51 +0000 (UTC)
Received: from x1.home (ovpn-116-99.phx2.redhat.com [10.3.116.99])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 12AE44139;
        Fri, 16 Aug 2019 20:51:49 +0000 (UTC)
Date:   Fri, 16 Aug 2019 14:51:48 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Tina Zhang <tina.zhang@intel.com>
Cc:     intel-gvt-dev@lists.freedesktop.org, kraxel@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        hang.yuan@intel.com, zhiyuan.lv@intel.com
Subject: Re: [PATCH v5 2/6] vfio: Introduce vGPU display irq type
Message-ID: <20190816145148.307408dc@x1.home>
In-Reply-To: <20190816023528.30210-3-tina.zhang@intel.com>
References: <20190816023528.30210-1-tina.zhang@intel.com>
        <20190816023528.30210-3-tina.zhang@intel.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Fri, 16 Aug 2019 20:51:51 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 16 Aug 2019 10:35:24 +0800
Tina Zhang <tina.zhang@intel.com> wrote:

> Introduce vGPU specific irq type VFIO_IRQ_TYPE_GFX, and
> VFIO_IRQ_SUBTYPE_GFX_DISPLAY_IRQ as the subtype for vGPU display.
> 
> Introduce vfio_irq_info_cap_display_plane_events capability to notify
> user space with the vGPU's plane update events
> 
> v2:
> - Add VFIO_IRQ_SUBTYPE_GFX_DISPLAY_IRQ description. (Alex & Kechen)
> - Introduce vfio_irq_info_cap_display_plane_events. (Gerd & Alex)
> 
> Signed-off-by: Tina Zhang <tina.zhang@intel.com>
> ---
>  include/uapi/linux/vfio.h | 21 +++++++++++++++++++++
>  1 file changed, 21 insertions(+)
> 
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index d83c9f136a5b..21ac69f0e1a9 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -465,6 +465,27 @@ struct vfio_irq_info_cap_type {
>  	__u32 subtype;  /* type specific */
>  };
>  
> +#define VFIO_IRQ_TYPE_GFX				(1)
> +/*
> + * vGPU vendor sub-type
> + * vGPU device display related interrupts e.g. vblank/pageflip
> + */
> +#define VFIO_IRQ_SUBTYPE_GFX_DISPLAY_IRQ		(1)

If this is a GFX/DISPLAY IRQ, why are we talking about a "vGPU" in the
description?  It's not specific to a vGPU implementation, right?  Is
this related to a physical display or a virtual display?  If it's
related to the GFX PLANE ioctls, it should state that.  It's not well
specified what this interrupt signals.  Is it vblank?  Is it pageflip?
Is it both?  Neither?  Something else?

> +
> +/*
> + * Display capability of using one eventfd to notify user space with the
> + * vGPU's plane update events.
> + * cur_event_val: eventfd value stands for cursor plane change event.
> + * pri_event_val: eventfd value stands for primary plane change event.
> + */
> +#define VFIO_IRQ_INFO_CAP_DISPLAY	4
> +
> +struct vfio_irq_info_cap_display_plane_events {
> +	struct vfio_info_cap_header header;
> +	__u64 cur_event_val;
> +	__u64 pri_event_val;
> +};

Again, what display?  Does this reference a GFX plane?  The event_val
data is not well specified, examples might be necessary.  They seem to
be used as a flag bit, so should we simply define a bit index for the
flag rather than a u64 value?  Where are the actual events per plane
defined?

I'm not sure this patch shouldn't be rolled back into 1, I couldn't
find the previous discussion that triggered it to be separate.  Perhaps
simply for sharing with the work Eric is doing?  If so, that's fine,
but maybe make note of it in the cover letter.  Thanks,

Alex
