Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 679A2BD356
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2019 22:10:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410323AbfIXUKc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Sep 2019 16:10:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47334 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728862AbfIXUKc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Sep 2019 16:10:32 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 893AFA26675;
        Tue, 24 Sep 2019 20:10:31 +0000 (UTC)
Received: from x1.home (ovpn-118-102.phx2.redhat.com [10.3.118.102])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0D809608C2;
        Tue, 24 Sep 2019 20:10:28 +0000 (UTC)
Date:   Tue, 24 Sep 2019 14:10:27 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Tina Zhang <tina.zhang@intel.com>
Cc:     intel-gvt-dev@lists.freedesktop.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, kraxel@redhat.com,
        zhenyuw@linux.intel.com, zhiyuan.lv@intel.com,
        zhi.a.wang@intel.com, kevin.tian@intel.com, hang.yuan@intel.com,
        yi.l.liu@intel.com, Kechen Lu <kechen.lu@intel.com>
Subject: Re: [PATCH v6 4/6] drm/i915/gvt: Deliver vGPU refresh event to
 userspace
Message-ID: <20190924141027.317af985@x1.home>
In-Reply-To: <20190924064143.9282-5-tina.zhang@intel.com>
References: <20190924064143.9282-1-tina.zhang@intel.com>
        <20190924064143.9282-5-tina.zhang@intel.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.68]); Tue, 24 Sep 2019 20:10:31 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 24 Sep 2019 14:41:41 +0800
Tina Zhang <tina.zhang@intel.com> wrote:

> Deliver the display refresh events to the user land. Userspace can use
> the irq mask/unmask mechanism to disable or enable the event delivery.
> 
> As we know, delivering refresh event at each vblank safely avoids
> tearing and unexpected event overwhelming, but there are still spaces
> to optimize.
> 
> For handling the normal case, deliver the page flip refresh
> event at each vblank, in other words, bounded by vblanks. Skipping some
> events bring performance enhancement while not hurting user experience.
> 
> For single framebuffer case, deliver the refresh events to userspace at
> all vblanks. This heuristic at each vblank leverages pageflip_count
> incresements to determine if there is no page flip happens after a certain
> period and so that the case is regarded as single framebuffer one.
> Although this heuristic makes incorrect decision sometimes and it depends
> on guest behavior, for example, when no cursor movements happen, the
> user experience does not harm and front buffer is still correctly acquired.
> Meanwhile, in actual single framebuffer case, the user experience is
> enhanced compared with page flip events only.
> 
> Addtionally, to mitigate the events delivering footprints, one eventfd and
> 8 byte eventfd counter partition are leveraged.
> 
> v3:
> - make no_pageflip_count be per-vgpu instead of static. (Zhenyu)
> 
> v2:
> - Support vfio_irq_info_cap_display_plane_events. (Tina)
> 
> Signed-off-by: Tina Zhang <tina.zhang@intel.com>
> Signed-off-by: Kechen Lu <kechen.lu@intel.com>
> ---
>  drivers/gpu/drm/i915/gvt/display.c |  20 ++++
>  drivers/gpu/drm/i915/gvt/gvt.h     |   3 +
>  drivers/gpu/drm/i915/gvt/kvmgt.c   | 159 +++++++++++++++++++++++++++--
>  3 files changed, 173 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/gvt/display.c b/drivers/gpu/drm/i915/gvt/display.c
> index 1a0a4ae4826e..9f2c2cd10369 100644
> --- a/drivers/gpu/drm/i915/gvt/display.c
> +++ b/drivers/gpu/drm/i915/gvt/display.c
> @@ -34,6 +34,8 @@
>  
>  #include "i915_drv.h"
>  #include "gvt.h"
> +#include <uapi/linux/vfio.h>
> +#include <drm/drm_plane.h>
>  
>  static int get_edp_pipe(struct intel_vgpu *vgpu)
>  {
> @@ -387,6 +389,8 @@ void intel_gvt_check_vblank_emulation(struct intel_gvt *gvt)
>  	mutex_unlock(&gvt->lock);
>  }
>  
> +#define PAGEFLIP_DELAY_THR 10
> +
>  static void emulate_vblank_on_pipe(struct intel_vgpu *vgpu, int pipe)
>  {
>  	struct drm_i915_private *dev_priv = vgpu->gvt->dev_priv;
> @@ -396,7 +400,9 @@ static void emulate_vblank_on_pipe(struct intel_vgpu *vgpu, int pipe)
>  		[PIPE_B] = PIPE_B_VBLANK,
>  		[PIPE_C] = PIPE_C_VBLANK,
>  	};
> +	int pri_flip_event = SKL_FLIP_EVENT(pipe, PLANE_PRIMARY);
>  	int event;
> +	u64 eventfd_signal_val = 0;
>  
>  	if (pipe < PIPE_A || pipe > PIPE_C)
>  		return;
> @@ -407,9 +413,23 @@ static void emulate_vblank_on_pipe(struct intel_vgpu *vgpu, int pipe)
>  		if (!pipe_is_enabled(vgpu, pipe))
>  			continue;
>  
> +		if (event == pri_flip_event)
> +			eventfd_signal_val |= DISPLAY_PRI_REFRESH_EVENT_VAL;
> +
>  		intel_vgpu_trigger_virtual_event(vgpu, event);
>  	}
>  
> +	if (eventfd_signal_val)
> +		vgpu->no_pageflip_count = 0;
> +	else if (!eventfd_signal_val && vgpu->no_pageflip_count > PAGEFLIP_DELAY_THR)

The !eventfd_signal_val test is redundant since this is and else branch
of a test for eventfd_signal_val.

> +		eventfd_signal_val |= DISPLAY_PRI_REFRESH_EVENT_VAL;
> +	else
> +		vgpu->no_pageflip_count++;
> +
> +	if (vgpu->vdev.vblank_trigger && !vgpu->vdev.display_event_mask &&
> +		eventfd_signal_val)
> +		eventfd_signal(vgpu->vdev.vblank_trigger, eventfd_signal_val);
> +
>  	if (pipe_is_enabled(vgpu, pipe)) {
>  		vgpu_vreg_t(vgpu, PIPE_FRMCOUNT_G4X(pipe))++;
>  		intel_vgpu_trigger_virtual_event(vgpu, vblank_event[pipe]);
> diff --git a/drivers/gpu/drm/i915/gvt/gvt.h b/drivers/gpu/drm/i915/gvt/gvt.h
> index 8008047d026c..cc39b449b061 100644
> --- a/drivers/gpu/drm/i915/gvt/gvt.h
> +++ b/drivers/gpu/drm/i915/gvt/gvt.h
> @@ -205,6 +205,8 @@ struct intel_vgpu {
>  		int num_irqs;
>  		struct eventfd_ctx *intx_trigger;
>  		struct eventfd_ctx *msi_trigger;
> +		struct eventfd_ctx *vblank_trigger;
> +		bool display_event_mask;
>  
>  		/*
>  		 * Two caches are used to avoid mapping duplicated pages (eg.
> @@ -229,6 +231,7 @@ struct intel_vgpu {
>  	struct idr object_idr;
>  
>  	struct completion vblank_done;
> +	int no_pageflip_count;
>  
>  	u32 scan_nonprivbb;
>  };
> diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/kvmgt.c
> index 269506300310..f30b7a5272e8 100644
> --- a/drivers/gpu/drm/i915/gvt/kvmgt.c
> +++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
> @@ -1250,6 +1250,8 @@ static int intel_vgpu_get_irq_count(struct intel_vgpu *vgpu, int type)
>  {
>  	if (type == VFIO_PCI_INTX_IRQ_INDEX || type == VFIO_PCI_MSI_IRQ_INDEX)
>  		return 1;
> +	else if (type < VFIO_PCI_NUM_IRQS + vgpu->vdev.num_irqs)
> +		return vgpu->vdev.irq[type - VFIO_PCI_NUM_IRQS].count;
>  
>  	return 0;
>  }
> @@ -1297,7 +1299,60 @@ static int intel_vgpu_set_msi_trigger(struct intel_vgpu *vgpu,
>  	return 0;
>  }
>  
> -static int intel_vgpu_set_irqs(struct intel_vgpu *vgpu, u32 flags,
> +static int intel_vgu_set_display_irq_mask(struct intel_vgpu *vgpu,
> +		unsigned int index, unsigned int start, unsigned int count,
> +		u32 flags, void *data)
> +{
> +	if (start != 0 || count > 2)
> +		return -EINVAL;

Was this meant to be >= 2?  Or just > 1?  I think we're only
advertising an index with a count of 1.

> +
> +	if (flags & VFIO_IRQ_SET_DATA_NONE)
> +		vgpu->vdev.display_event_mask = true;

It's also valid for a user to set this with DATA_BOOL.

Both comments above apply to instances below as well.

> +
> +	return 0;
> +}
> +
> +static int intel_vgu_set_display_irq_unmask(struct intel_vgpu *vgpu,
> +		unsigned int index, unsigned int start, unsigned int count,
> +		u32 flags, void *data)
> +{
> +	if (start != 0 || count > 2)
> +		return -EINVAL;
> +
> +	if (flags & VFIO_IRQ_SET_DATA_NONE)
> +		vgpu->vdev.display_event_mask = false;
> +
> +	return 0;
> +}
> +
> +static int intel_vgpu_set_display_event_trigger(struct intel_vgpu *vgpu,
> +		unsigned int index, unsigned int start, unsigned int count,
> +		u32 flags, void *data)
> +{
> +	struct eventfd_ctx *trigger;

start and count are ignored here, the user could pass anything.

> +	if (flags & VFIO_IRQ_SET_DATA_EVENTFD) {
> +		int fd = *(int *)data;
> +
> +		trigger = eventfd_ctx_fdget(fd);
> +		if (IS_ERR(trigger)) {
> +			gvt_vgpu_err("eventfd_ctx_fdget failed\n");
> +			return PTR_ERR(trigger);
> +		}
> +		vgpu->vdev.vblank_trigger = trigger;
> +		vgpu->vdev.display_event_mask = false;
> +	} else if ((flags & VFIO_IRQ_SET_DATA_NONE) && !count) {
> +		trigger = vgpu->vdev.vblank_trigger;
> +		if (trigger) {
> +			eventfd_ctx_put(trigger);
> +			vgpu->vdev.vblank_trigger = NULL;
> +		}
> +	}

I don't think this supports all user interactions either, notably
providing an eventfd of -1 to disable the IRQ as defined in the uapi.
Thanks,

Alex

> +
> +	return 0;
> +}
> +
> +int intel_vgpu_set_irqs(struct intel_vgpu *vgpu, u32 flags,
>  		unsigned int index, unsigned int start, unsigned int count,
>  		void *data)
>  {
> @@ -1330,6 +1385,35 @@ static int intel_vgpu_set_irqs(struct intel_vgpu *vgpu, u32 flags,
>  			break;
>  		}
>  		break;
> +	default:
> +	{
> +		int i;
> +
> +		if (index >= VFIO_PCI_NUM_IRQS +
> +					vgpu->vdev.num_irqs)
> +			return -EINVAL;
> +		index =
> +			array_index_nospec(index,
> +						VFIO_PCI_NUM_IRQS +
> +						vgpu->vdev.num_irqs);
> +
> +		i = index - VFIO_PCI_NUM_IRQS;
> +		if (vgpu->vdev.irq[i].type == VFIO_IRQ_TYPE_GFX &&
> +		    vgpu->vdev.irq[i].subtype ==
> +		    VFIO_IRQ_SUBTYPE_GFX_DISPLAY_IRQ) {
> +			switch (flags & VFIO_IRQ_SET_ACTION_TYPE_MASK) {
> +			case VFIO_IRQ_SET_ACTION_MASK:
> +				func = intel_vgu_set_display_irq_mask;
> +				break;
> +			case VFIO_IRQ_SET_ACTION_UNMASK:
> +				func = intel_vgu_set_display_irq_unmask;
> +				break;
> +			case VFIO_IRQ_SET_ACTION_TRIGGER:
> +				func = intel_vgpu_set_display_event_trigger;
> +				break;
> +			}
> +		}
> +	}
>  	}
>  
>  	if (!func)
> @@ -1361,7 +1445,7 @@ static long intel_vgpu_ioctl(struct mdev_device *mdev, unsigned int cmd,
>  		info.flags |= VFIO_DEVICE_FLAGS_RESET;
>  		info.num_regions = VFIO_PCI_NUM_REGIONS +
>  				vgpu->vdev.num_regions;
> -		info.num_irqs = VFIO_PCI_NUM_IRQS;
> +		info.num_irqs = VFIO_PCI_NUM_IRQS + vgpu->vdev.num_irqs;
>  
>  		return copy_to_user((void __user *)arg, &info, minsz) ?
>  			-EFAULT : 0;
> @@ -1519,32 +1603,88 @@ static long intel_vgpu_ioctl(struct mdev_device *mdev, unsigned int cmd,
>  			-EFAULT : 0;
>  	} else if (cmd == VFIO_DEVICE_GET_IRQ_INFO) {
>  		struct vfio_irq_info info;
> +		struct vfio_info_cap caps = { .buf = NULL, .size = 0 };
> +		unsigned int i;
> +		int ret;
>  
>  		minsz = offsetofend(struct vfio_irq_info, count);
>  
>  		if (copy_from_user(&info, (void __user *)arg, minsz))
>  			return -EFAULT;
>  
> -		if (info.argsz < minsz || info.index >= VFIO_PCI_NUM_IRQS)
> +		if (info.argsz < minsz)
>  			return -EINVAL;
>  
>  		switch (info.index) {
>  		case VFIO_PCI_INTX_IRQ_INDEX:
>  		case VFIO_PCI_MSI_IRQ_INDEX:
> +			info.flags = VFIO_IRQ_INFO_EVENTFD;
>  			break;
> -		default:
> +		case VFIO_PCI_MSIX_IRQ_INDEX:
> +		case VFIO_PCI_ERR_IRQ_INDEX:
> +		case VFIO_PCI_REQ_IRQ_INDEX:
>  			return -EINVAL;
> -		}
> +		default:
> +		{
> +			struct vfio_irq_info_cap_type cap_type = {
> +				.header.id = VFIO_IRQ_INFO_CAP_TYPE,
> +				.header.version = 1 };
>  
> -		info.flags = VFIO_IRQ_INFO_EVENTFD;
> +			if (info.index >= VFIO_PCI_NUM_IRQS +
> +					vgpu->vdev.num_irqs)
> +				return -EINVAL;
> +			info.index =
> +				array_index_nospec(info.index,
> +						VFIO_PCI_NUM_IRQS +
> +						vgpu->vdev.num_irqs);
> +
> +			i = info.index - VFIO_PCI_NUM_IRQS;
> +
> +			info.flags = vgpu->vdev.irq[i].flags;
> +			cap_type.type = vgpu->vdev.irq[i].type;
> +			cap_type.subtype = vgpu->vdev.irq[i].subtype;
> +
> +			ret = vfio_info_add_capability(&caps,
> +						&cap_type.header,
> +						sizeof(cap_type));
> +			if (ret)
> +				return ret;
> +
> +			if (vgpu->vdev.irq[i].ops->add_capability) {
> +				ret = vgpu->vdev.irq[i].ops->add_capability(vgpu,
> +									    &caps);
> +				if (ret)
> +					return ret;
> +			}
> +		}
> +		}
>  
>  		info.count = intel_vgpu_get_irq_count(vgpu, info.index);
>  
>  		if (info.index == VFIO_PCI_INTX_IRQ_INDEX)
>  			info.flags |= (VFIO_IRQ_INFO_MASKABLE |
>  				       VFIO_IRQ_INFO_AUTOMASKED);
> -		else
> -			info.flags |= VFIO_IRQ_INFO_NORESIZE;
> +
> +		if (caps.size) {
> +			info.flags |= VFIO_IRQ_INFO_FLAG_CAPS;
> +			if (info.argsz < sizeof(info) + caps.size) {
> +				info.argsz = sizeof(info) + caps.size;
> +				info.cap_offset = 0;
> +			} else {
> +				vfio_info_cap_shift(&caps, sizeof(info));
> +				if (copy_to_user((void __user *)arg +
> +						  sizeof(info), caps.buf,
> +						  caps.size)) {
> +					kfree(caps.buf);
> +					return -EFAULT;
> +				}
> +				info.cap_offset = sizeof(info);
> +				if (offsetofend(struct vfio_irq_info, cap_offset) > minsz)
> +					minsz = offsetofend(struct vfio_irq_info, cap_offset);
> +			}
> +
> +			kfree(caps.buf);
> +		}
>  
>  		return copy_to_user((void __user *)arg, &info, minsz) ?
>  			-EFAULT : 0;
> @@ -1563,7 +1703,8 @@ static long intel_vgpu_ioctl(struct mdev_device *mdev, unsigned int cmd,
>  			int max = intel_vgpu_get_irq_count(vgpu, hdr.index);
>  
>  			ret = vfio_set_irqs_validate_and_prepare(&hdr, max,
> -						VFIO_PCI_NUM_IRQS, &data_size);
> +					VFIO_PCI_NUM_IRQS + vgpu->vdev.num_irqs,
> +								 &data_size);
>  			if (ret) {
>  				gvt_vgpu_err("intel:vfio_set_irqs_validate_and_prepare failed\n");
>  				return -EINVAL;

