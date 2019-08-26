Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2457C9CB2D
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2019 10:00:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730212AbfHZIAi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Aug 2019 04:00:38 -0400
Received: from mga06.intel.com ([134.134.136.31]:52940 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728233AbfHZIAi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Aug 2019 04:00:38 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Aug 2019 01:00:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,431,1559545200"; 
   d="asc'?scan'208";a="182366789"
Received: from zhen-hp.sh.intel.com (HELO zhen-hp) ([10.239.13.116])
  by orsmga003.jf.intel.com with ESMTP; 26 Aug 2019 01:00:32 -0700
Date:   Mon, 26 Aug 2019 15:55:53 +0800
From:   Zhenyu Wang <zhenyuw@linux.intel.com>
To:     Tina Zhang <tina.zhang@intel.com>
Cc:     intel-gvt-dev@lists.freedesktop.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, hang.yuan@intel.com,
        alex.williamson@redhat.com, kraxel@redhat.com,
        Kechen Lu <kechen.lu@intel.com>, zhiyuan.lv@intel.com
Subject: Re: [PATCH v5 4/6] drm/i915/gvt: Deliver vGPU refresh event to
 userspace
Message-ID: <20190826075553.GC29455@zhen-hp.sh.intel.com>
Reply-To: Zhenyu Wang <zhenyuw@linux.intel.com>
References: <20190816023528.30210-1-tina.zhang@intel.com>
 <20190816023528.30210-5-tina.zhang@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="Clx92ZfkiYIKRjnr"
Content-Disposition: inline
In-Reply-To: <20190816023528.30210-5-tina.zhang@intel.com>
User-Agent: Mutt/1.10.0 (2018-05-17)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--Clx92ZfkiYIKRjnr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2019.08.16 10:35:26 +0800, Tina Zhang wrote:
> Deliver the display refresh events to the user land. Userspace can use
> the irq mask/unmask mechanism to disable or enable the event delivery.
>=20
> As we know, delivering refresh event at each vblank safely avoids
> tearing and unexpected event overwhelming, but there are still spaces
> to optimize.
>=20
> For handling the normal case, deliver the page flip refresh
> event at each vblank, in other words, bounded by vblanks. Skipping some
> events bring performance enhancement while not hurting user experience.
>=20
> For single framebuffer case, deliver the refresh events to userspace at
> all vblanks. This heuristic at each vblank leverages pageflip_count
> incresements to determine if there is no page flip happens after a certain
> period and so that the case is regarded as single framebuffer one.
> Although this heuristic makes incorrect decision sometimes and it depends
> on guest behavior, for example, when no cursor movements happen, the
> user experience does not harm and front buffer is still correctly acquire=
d.
> Meanwhile, in actual single framebuffer case, the user experience is
> enhanced compared with page flip events only.
>=20
> Addtionally, to mitigate the events delivering footprints, one eventfd and
> 8 byte eventfd counter partition are leveraged.
>=20
> v2:
> - Support vfio_irq_info_cap_display_plane_events. (Tina)
>=20
> Signed-off-by: Tina Zhang <tina.zhang@intel.com>
> Signed-off-by: Kechen Lu <kechen.lu@intel.com>
> ---
>  drivers/gpu/drm/i915/gvt/display.c |  22 ++++
>  drivers/gpu/drm/i915/gvt/gvt.h     |   2 +
>  drivers/gpu/drm/i915/gvt/kvmgt.c   | 159 +++++++++++++++++++++++++++--
>  3 files changed, 174 insertions(+), 9 deletions(-)
>=20
> diff --git a/drivers/gpu/drm/i915/gvt/display.c b/drivers/gpu/drm/i915/gv=
t/display.c
> index 1a0a4ae4826e..616285e4a014 100644
> --- a/drivers/gpu/drm/i915/gvt/display.c
> +++ b/drivers/gpu/drm/i915/gvt/display.c
> @@ -34,6 +34,8 @@
> =20
>  #include "i915_drv.h"
>  #include "gvt.h"
> +#include <uapi/linux/vfio.h>
> +#include <drm/drm_plane.h>
> =20
>  static int get_edp_pipe(struct intel_vgpu *vgpu)
>  {
> @@ -387,6 +389,8 @@ void intel_gvt_check_vblank_emulation(struct intel_gv=
t *gvt)
>  	mutex_unlock(&gvt->lock);
>  }
> =20
> +#define PAGEFLIP_DELAY_THR 10
> +
>  static void emulate_vblank_on_pipe(struct intel_vgpu *vgpu, int pipe)
>  {
>  	struct drm_i915_private *dev_priv =3D vgpu->gvt->dev_priv;
> @@ -396,7 +400,10 @@ static void emulate_vblank_on_pipe(struct intel_vgpu=
 *vgpu, int pipe)
>  		[PIPE_B] =3D PIPE_B_VBLANK,
>  		[PIPE_C] =3D PIPE_C_VBLANK,
>  	};
> +	int pri_flip_event =3D SKL_FLIP_EVENT(pipe, PLANE_PRIMARY);
>  	int event;
> +	u64 eventfd_signal_val =3D 0;
> +	static int no_pageflip_count;
> =20
>  	if (pipe < PIPE_A || pipe > PIPE_C)
>  		return;
> @@ -407,11 +414,26 @@ static void emulate_vblank_on_pipe(struct intel_vgp=
u *vgpu, int pipe)
>  		if (!pipe_is_enabled(vgpu, pipe))
>  			continue;
> =20
> +		if (event =3D=3D pri_flip_event)
> +			eventfd_signal_val |=3D DISPLAY_PRI_REFRESH_EVENT_VAL;
> +
>  		intel_vgpu_trigger_virtual_event(vgpu, event);
>  	}
> =20
> +	if (eventfd_signal_val)
> +		no_pageflip_count =3D 0;
> +	else if (!eventfd_signal_val && no_pageflip_count > PAGEFLIP_DELAY_THR)

extra !eventfd_signal_val

> +		eventfd_signal_val |=3D DISPLAY_PRI_REFRESH_EVENT_VAL;
> +	else
> +		no_pageflip_count++;

no_pageflip_count should be per-vgpu instead of static.

> +
> +	if (vgpu->vdev.vblank_trigger && !vgpu->vdev.display_event_mask &&
> +		eventfd_signal_val)
> +		eventfd_signal(vgpu->vdev.vblank_trigger, eventfd_signal_val);
> +
>  	if (pipe_is_enabled(vgpu, pipe)) {
>  		vgpu_vreg_t(vgpu, PIPE_FRMCOUNT_G4X(pipe))++;
> +

extra line

>  		intel_vgpu_trigger_virtual_event(vgpu, vblank_event[pipe]);
>  	}
>  }
> diff --git a/drivers/gpu/drm/i915/gvt/gvt.h b/drivers/gpu/drm/i915/gvt/gv=
t.h
> index cd29ea28d7ed..6c8ed030c30b 100644
> --- a/drivers/gpu/drm/i915/gvt/gvt.h
> +++ b/drivers/gpu/drm/i915/gvt/gvt.h
> @@ -205,6 +205,8 @@ struct intel_vgpu {
>  		int num_irqs;
>  		struct eventfd_ctx *intx_trigger;
>  		struct eventfd_ctx *msi_trigger;
> +		struct eventfd_ctx *vblank_trigger;
> +		u32 display_event_mask;
> =20
>  		/*
>  		 * Two caches are used to avoid mapping duplicated pages (eg.
> diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/=
kvmgt.c
> index fd1633342e53..9ace1f4ff9eb 100644
> --- a/drivers/gpu/drm/i915/gvt/kvmgt.c
> +++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
> @@ -1250,6 +1250,8 @@ static int intel_vgpu_get_irq_count(struct intel_vg=
pu *vgpu, int type)
>  {
>  	if (type =3D=3D VFIO_PCI_INTX_IRQ_INDEX || type =3D=3D VFIO_PCI_MSI_IRQ=
_INDEX)
>  		return 1;
> +	else if (type < VFIO_PCI_NUM_IRQS + vgpu->vdev.num_irqs)
> +		return vgpu->vdev.irq[type - VFIO_PCI_NUM_IRQS].count;
> =20
>  	return 0;
>  }
> @@ -1297,7 +1299,60 @@ static int intel_vgpu_set_msi_trigger(struct intel=
_vgpu *vgpu,
>  	return 0;
>  }
> =20
> -static int intel_vgpu_set_irqs(struct intel_vgpu *vgpu, u32 flags,
> +static int intel_vgu_set_display_irq_mask(struct intel_vgpu *vgpu,
> +		unsigned int index, unsigned int start, unsigned int count,
> +		u32 flags, void *data)
> +{
> +	if (start !=3D 0 || count > 2)
> +		return -EINVAL;
> +
> +	if (flags & VFIO_IRQ_SET_DATA_NONE)
> +		vgpu->vdev.display_event_mask |=3D 1;

see below..

> +
> +	return 0;
> +}
> +
> +static int intel_vgu_set_display_irq_unmask(struct intel_vgpu *vgpu,
> +		unsigned int index, unsigned int start, unsigned int count,
> +		u32 flags, void *data)
> +{
> +	if (start !=3D 0 || count > 2)
> +		return -EINVAL;
> +
> +	if (flags & VFIO_IRQ_SET_DATA_NONE)
> +		vgpu->vdev.display_event_mask &=3D 0;

looks display_event_mask is used as flag for enable/disable, just write 1 o=
r 0?


> +
> +	return 0;
> +}
> +
> +static int intel_vgpu_set_display_event_trigger(struct intel_vgpu *vgpu,
> +		unsigned int index, unsigned int start, unsigned int count,
> +		u32 flags, void *data)
> +{
> +	struct eventfd_ctx *trigger;
> +
> +	if (flags & VFIO_IRQ_SET_DATA_EVENTFD) {
> +		int fd =3D *(int *)data;
> +
> +		trigger =3D eventfd_ctx_fdget(fd);
> +		if (IS_ERR(trigger)) {
> +			gvt_vgpu_err("eventfd_ctx_fdget failed\n");
> +			return PTR_ERR(trigger);
> +		}
> +		vgpu->vdev.vblank_trigger =3D trigger;
> +		vgpu->vdev.display_event_mask =3D 0;
> +	} else if ((flags & VFIO_IRQ_SET_DATA_NONE) && !count) {
> +		trigger =3D vgpu->vdev.vblank_trigger;
> +		if (trigger) {
> +			eventfd_ctx_put(trigger);
> +			vgpu->vdev.vblank_trigger =3D NULL;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +int intel_vgpu_set_irqs(struct intel_vgpu *vgpu, u32 flags,
>  		unsigned int index, unsigned int start, unsigned int count,
>  		void *data)
>  {
> @@ -1330,6 +1385,35 @@ static int intel_vgpu_set_irqs(struct intel_vgpu *=
vgpu, u32 flags,
>  			break;
>  		}
>  		break;
> +	default:
> +	{
> +		int i;
> +
> +		if (index >=3D VFIO_PCI_NUM_IRQS +
> +					vgpu->vdev.num_irqs)
> +			return -EINVAL;
> +		index =3D
> +			array_index_nospec(index,
> +						VFIO_PCI_NUM_IRQS +
> +						vgpu->vdev.num_irqs);
> +
> +		i =3D index - VFIO_PCI_NUM_IRQS;
> +		if (vgpu->vdev.irq[i].type =3D=3D VFIO_IRQ_TYPE_GFX &&
> +		    vgpu->vdev.irq[i].subtype =3D=3D
> +		    VFIO_IRQ_SUBTYPE_GFX_DISPLAY_IRQ) {
> +			switch (flags & VFIO_IRQ_SET_ACTION_TYPE_MASK) {
> +			case VFIO_IRQ_SET_ACTION_MASK:
> +				func =3D intel_vgu_set_display_irq_mask;
> +				break;
> +			case VFIO_IRQ_SET_ACTION_UNMASK:
> +				func =3D intel_vgu_set_display_irq_unmask;
> +				break;
> +			case VFIO_IRQ_SET_ACTION_TRIGGER:
> +				func =3D intel_vgpu_set_display_event_trigger;
> +				break;
> +			}
> +		}
> +	}
>  	}
> =20
>  	if (!func)
> @@ -1361,7 +1445,7 @@ static long intel_vgpu_ioctl(struct mdev_device *md=
ev, unsigned int cmd,
>  		info.flags |=3D VFIO_DEVICE_FLAGS_RESET;
>  		info.num_regions =3D VFIO_PCI_NUM_REGIONS +
>  				vgpu->vdev.num_regions;
> -		info.num_irqs =3D VFIO_PCI_NUM_IRQS;
> +		info.num_irqs =3D VFIO_PCI_NUM_IRQS + vgpu->vdev.num_irqs;
> =20
>  		return copy_to_user((void __user *)arg, &info, minsz) ?
>  			-EFAULT : 0;
> @@ -1521,32 +1605,88 @@ static long intel_vgpu_ioctl(struct mdev_device *=
mdev, unsigned int cmd,
>  			-EFAULT : 0;
>  	} else if (cmd =3D=3D VFIO_DEVICE_GET_IRQ_INFO) {
>  		struct vfio_irq_info info;
> +		struct vfio_info_cap caps =3D { .buf =3D NULL, .size =3D 0 };
> +		unsigned int i;
> +		int ret;
> =20
>  		minsz =3D offsetofend(struct vfio_irq_info, count);
> =20
>  		if (copy_from_user(&info, (void __user *)arg, minsz))
>  			return -EFAULT;
> =20
> -		if (info.argsz < minsz || info.index >=3D VFIO_PCI_NUM_IRQS)
> +		if (info.argsz < minsz)
>  			return -EINVAL;
> =20
>  		switch (info.index) {
>  		case VFIO_PCI_INTX_IRQ_INDEX:
>  		case VFIO_PCI_MSI_IRQ_INDEX:
> +			info.flags =3D VFIO_IRQ_INFO_EVENTFD;
>  			break;
> -		default:
> +		case VFIO_PCI_MSIX_IRQ_INDEX:
> +		case VFIO_PCI_ERR_IRQ_INDEX:
> +		case VFIO_PCI_REQ_IRQ_INDEX:
>  			return -EINVAL;
> -		}
> +		default:
> +		{
> +			struct vfio_irq_info_cap_type cap_type =3D {
> +				.header.id =3D VFIO_IRQ_INFO_CAP_TYPE,
> +				.header.version =3D 1 };
> =20
> -		info.flags =3D VFIO_IRQ_INFO_EVENTFD;
> +			if (info.index >=3D VFIO_PCI_NUM_IRQS +
> +					vgpu->vdev.num_irqs)
> +				return -EINVAL;
> +			info.index =3D
> +				array_index_nospec(info.index,
> +						VFIO_PCI_NUM_IRQS +
> +						vgpu->vdev.num_irqs);
> +
> +			i =3D info.index - VFIO_PCI_NUM_IRQS;
> +
> +			info.flags =3D vgpu->vdev.irq[i].flags;
> +			cap_type.type =3D vgpu->vdev.irq[i].type;
> +			cap_type.subtype =3D vgpu->vdev.irq[i].subtype;
> +
> +			ret =3D vfio_info_add_capability(&caps,
> +						&cap_type.header,
> +						sizeof(cap_type));
> +			if (ret)
> +				return ret;
> +
> +			if (vgpu->vdev.irq[i].ops->add_capability) {
> +				ret =3D vgpu->vdev.irq[i].ops->add_capability(vgpu,
> +									    &caps);
> +				if (ret)
> +					return ret;
> +			}
> +		}
> +		}
> =20
>  		info.count =3D intel_vgpu_get_irq_count(vgpu, info.index);
> =20
>  		if (info.index =3D=3D VFIO_PCI_INTX_IRQ_INDEX)
>  			info.flags |=3D (VFIO_IRQ_INFO_MASKABLE |
>  				       VFIO_IRQ_INFO_AUTOMASKED);
> -		else
> -			info.flags |=3D VFIO_IRQ_INFO_NORESIZE;
> +
> +		if (caps.size) {
> +			info.flags |=3D VFIO_IRQ_INFO_FLAG_CAPS;
> +			if (info.argsz < sizeof(info) + caps.size) {
> +				info.argsz =3D sizeof(info) + caps.size;
> +				info.cap_offset =3D 0;
> +			} else {
> +				vfio_info_cap_shift(&caps, sizeof(info));
> +				if (copy_to_user((void __user *)arg +
> +						  sizeof(info), caps.buf,
> +						  caps.size)) {
> +					kfree(caps.buf);
> +					return -EFAULT;
> +				}
> +				info.cap_offset =3D sizeof(info);
> +				if (offsetofend(struct vfio_irq_info, cap_offset) > minsz)
> +					minsz =3D offsetofend(struct vfio_irq_info, cap_offset);
> +			}
> +
> +			kfree(caps.buf);
> +		}
> =20
>  		return copy_to_user((void __user *)arg, &info, minsz) ?
>  			-EFAULT : 0;
> @@ -1565,7 +1705,8 @@ static long intel_vgpu_ioctl(struct mdev_device *md=
ev, unsigned int cmd,
>  			int max =3D intel_vgpu_get_irq_count(vgpu, hdr.index);
> =20
>  			ret =3D vfio_set_irqs_validate_and_prepare(&hdr, max,
> -						VFIO_PCI_NUM_IRQS, &data_size);
> +					VFIO_PCI_NUM_IRQS + vgpu->vdev.num_irqs,
> +								 &data_size);
>  			if (ret) {
>  				gvt_vgpu_err("intel:vfio_set_irqs_validate_and_prepare failed\n");
>  				return -EINVAL;
> --=20
> 2.17.1
>=20
> _______________________________________________
> intel-gvt-dev mailing list
> intel-gvt-dev@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/intel-gvt-dev

--=20
Open Source Technology Center, Intel ltd.

$gpg --keyserver wwwkeys.pgp.net --recv-keys 4D781827

--Clx92ZfkiYIKRjnr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EARECAB0WIQTXuabgHDW6LPt9CICxBBozTXgYJwUCXWOQiQAKCRCxBBozTXgY
J+ijAJ4ihAfuPS5xnKtpSJDpIKCPhrfXEACfVpCvQOHwIbgHw2DkdgO0IKBrYJc=
=xe22
-----END PGP SIGNATURE-----

--Clx92ZfkiYIKRjnr--
