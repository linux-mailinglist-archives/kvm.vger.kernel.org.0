Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82EBEBD3A7
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2019 22:35:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731179AbfIXUfN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Sep 2019 16:35:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22499 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727071AbfIXUfN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Sep 2019 16:35:13 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 91AC118C8914;
        Tue, 24 Sep 2019 20:35:12 +0000 (UTC)
Received: from x1.home (ovpn-118-102.phx2.redhat.com [10.3.118.102])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8E70B5D9CA;
        Tue, 24 Sep 2019 20:35:09 +0000 (UTC)
Date:   Tue, 24 Sep 2019 14:35:09 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Tina Zhang <tina.zhang@intel.com>
Cc:     intel-gvt-dev@lists.freedesktop.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, kraxel@redhat.com,
        zhenyuw@linux.intel.com, zhiyuan.lv@intel.com,
        zhi.a.wang@intel.com, kevin.tian@intel.com, hang.yuan@intel.com,
        yi.l.liu@intel.com
Subject: Re: [PATCH v6 2/6] vfio: Introduce vGPU display irq type
Message-ID: <20190924143509.181affe2@x1.home>
In-Reply-To: <20190924064143.9282-3-tina.zhang@intel.com>
References: <20190924064143.9282-1-tina.zhang@intel.com>
        <20190924064143.9282-3-tina.zhang@intel.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.70]); Tue, 24 Sep 2019 20:35:12 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 24 Sep 2019 14:41:39 +0800
Tina Zhang <tina.zhang@intel.com> wrote:

> Introduce vGPU specific irq type VFIO_IRQ_TYPE_GFX, and
> VFIO_IRQ_SUBTYPE_GFX_DISPLAY_IRQ as the subtype for vGPU display.
> 
> Introduce vfio_irq_info_cap_display_plane_events capability to notify
> user space with the vGPU's plane update events
> 
> v3:
> - Add more description to VFIO_IRQ_SUBTYPE_GFX_DISPLAY_IRQ and
>   VFIO_IRQ_INFO_CAP_DISPLAY. (Alex & Gerd)
> 
> v2:
> - Add VFIO_IRQ_SUBTYPE_GFX_DISPLAY_IRQ description. (Alex & Kechen)
> - Introduce vfio_irq_info_cap_display_plane_events. (Gerd & Alex)
> 
> Signed-off-by: Tina Zhang <tina.zhang@intel.com>
> ---
>  include/uapi/linux/vfio.h | 38 ++++++++++++++++++++++++++++++++++++++
>  1 file changed, 38 insertions(+)
> 
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index aa6850f1daef..2946a028b0c3 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -476,6 +476,44 @@ struct vfio_irq_info_cap_type {
>  	__u32 subtype;  /* type specific */
>  };
>  
> +/* vGPU IRQ TYPE */
> +#define VFIO_IRQ_TYPE_GFX			(1)
> +
> +/* sub-types for VFIO_IRQ_TYPE_GFX */
> +/*
> + * vGPU device display refresh interrupt request. This irq asking for
> + * a user space display refresh, covers all display updates events,
> + * i.e. user space can stop the display update timer and fully depend
> + * on getting the notification if an update is needed.
> + */
> +#define VFIO_IRQ_SUBTYPE_GFX_DISPLAY_IRQ	(1)
> +
> +/*
> + * Display capability of reporting display refresh interrupt events.

Perhaps, "Capability for interpreting GFX_DISPLAY_IRQ eventfd value"

> + * This gives user space the capability to identify different display
> + * updates events of the display refresh interrupt request.
> + *
> + * When notified by VFIO_IRQ_SUBTYPE_GFX_DISPLAY_IRQ, user space can
> + * use the eventfd counter value to identify which plane has been
> + * updated.
> + *
> + * Note that there might be some cases like counter_value >
> + * (cur_event_val + pri_event_val), if notifications haven't been
> + * handled on time in user mode. These cases can be handled as all
> + * plane updated case or signle plane updated case depending on the
> + * value.

Seems like in the GVT-g implementation such a value is not possible.
In fact, when this capability is provided, doesn't userspace interpret
the eventfd value more as a bitmask of events rather than a counter?
If so, (cur_event_val + pri_event_val) may be mathematically accurate,
but maybe obfuscates the logical interpretation... or maybe that's just
me.

> + *
> + * cur_event_val: eventfd counter value for cursor plane change event.
> + * pri_event_val: eventfd counter value for primary plane change event.

I think there should be a note that this capability is optional and
lacking this feature, userspace should refresh all display events on
notification.

> + */
> +#define VFIO_IRQ_INFO_CAP_DISPLAY	2
> +
> +struct vfio_irq_info_cap_display_plane_events {
> +	struct vfio_info_cap_header header;
> +	__u64 cur_event_val;
> +	__u64 pri_event_val;

AIUI, the GVT-g implementation sets a single bit and userspace expects
one or both of those bits to be set on notification.  Should we
simplify this a bit and just define these as cur_event_bit,
pri_event_bit and use a __u8 for each to define the bit position?
Thanks,

Alex
