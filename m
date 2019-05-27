Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C815D2B119
	for <lists+kvm@lfdr.de>; Mon, 27 May 2019 11:12:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726115AbfE0JM3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 May 2019 05:12:29 -0400
Received: from mga02.intel.com ([134.134.136.20]:14216 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725869AbfE0JM3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 May 2019 05:12:29 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 May 2019 02:12:28 -0700
X-ExtLoop1: 1
Received: from zhen-hp.sh.intel.com (HELO zhen-hp) ([10.239.13.116])
  by FMSMGA003.fm.intel.com with ESMTP; 27 May 2019 02:12:26 -0700
Date:   Mon, 27 May 2019 17:11:13 +0800
From:   Zhenyu Wang <zhenyuw@linux.intel.com>
To:     Tina Zhang <tina.zhang@intel.com>
Cc:     intel-gvt-dev@lists.freedesktop.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, kraxel@redhat.com,
        zhenyuw@linux.intel.com, alex.williamson@redhat.com,
        hang.yuan@intel.com, zhiyuan.lv@intel.com
Subject: Re: [PATCH 2/2] drm/i915/gvt: Support delivering page flip event to
 userspace
Message-ID: <20190527091113.GF29553@zhen-hp.sh.intel.com>
Reply-To: Zhenyu Wang <zhenyuw@linux.intel.com>
References: <20190527084312.8872-1-tina.zhang@intel.com>
 <20190527084312.8872-3-tina.zhang@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="BRE3mIcgqKzpedwo"
Content-Disposition: inline
In-Reply-To: <20190527084312.8872-3-tina.zhang@intel.com>
User-Agent: Mutt/1.10.0 (2018-05-17)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--BRE3mIcgqKzpedwo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2019.05.27 16:43:12 +0800, Tina Zhang wrote:
> Use the eventfd based signaling mechanism provided by vfio/display
> to deliver vGPU framebuffer page flip event to userspace.
>=20
> Signed-off-by: Tina Zhang <tina.zhang@intel.com>
> ---
>  drivers/gpu/drm/i915/gvt/dmabuf.c   | 31 +++++++++++++++++++++++++++++
>  drivers/gpu/drm/i915/gvt/dmabuf.h   |  1 +
>  drivers/gpu/drm/i915/gvt/gvt.c      |  1 +
>  drivers/gpu/drm/i915/gvt/gvt.h      |  2 ++
>  drivers/gpu/drm/i915/gvt/handlers.c |  2 ++
>  drivers/gpu/drm/i915/gvt/kvmgt.c    |  7 +++++++
>  6 files changed, 44 insertions(+)
>=20
> diff --git a/drivers/gpu/drm/i915/gvt/dmabuf.c b/drivers/gpu/drm/i915/gvt=
/dmabuf.c
> index 4e1e425189ba..f2ed45616d72 100644
> --- a/drivers/gpu/drm/i915/gvt/dmabuf.c
> +++ b/drivers/gpu/drm/i915/gvt/dmabuf.c
> @@ -538,6 +538,35 @@ int intel_vgpu_get_dmabuf(struct intel_vgpu *vgpu, u=
nsigned int dmabuf_id)
>  	return ret;
>  }
> =20
> +static void release_flip_eventfd_ctx(struct intel_vgpu *vgpu)
> +{
> +	struct eventfd_ctx **trigger =3D &vgpu->page_flip_trigger;
> +
> +	if (*trigger) {
> +		eventfd_ctx_put(*trigger);
> +		*trigger =3D NULL;
> +	}

Why so twisted?

        if (vgpu->page_flip_trigger) {
                eventfd_ctx_put(vgpu->page_flip_trigger);
		vgpu->page_flip_trigger =3D NULL;
        }

> +}
> +
> +int intel_vgpu_set_flip_eventfd(struct intel_vgpu *vgpu, int fd)
> +{
> +	struct eventfd_ctx *trigger;
> +
> +	if (fd =3D=3D -1) {
> +		release_flip_eventfd_ctx(vgpu);
> +	} else if (fd >=3D 0) {
> +		trigger =3D eventfd_ctx_fdget(fd);
> +		if (IS_ERR(trigger)) {
> +			gvt_vgpu_err("eventfd_ctx_fdget failed\n");
> +			return PTR_ERR(trigger);
> +		}
> +		vgpu->page_flip_trigger =3D trigger;
> +	} else
> +		return -EINVAL;

Better put (fd < 0) check earlier in ioctl handler to simplify this.

> +
> +	return 0;
> +}
> +
>  void intel_vgpu_dmabuf_cleanup(struct intel_vgpu *vgpu)
>  {
>  	struct list_head *pos, *n;
> @@ -561,4 +590,6 @@ void intel_vgpu_dmabuf_cleanup(struct intel_vgpu *vgp=
u)
> =20
>  	}
>  	mutex_unlock(&vgpu->dmabuf_lock);
> +
> +	release_flip_eventfd_ctx(vgpu);
>  }
> diff --git a/drivers/gpu/drm/i915/gvt/dmabuf.h b/drivers/gpu/drm/i915/gvt=
/dmabuf.h
> index 5f8f03fb1d1b..4d9caa3732d2 100644
> --- a/drivers/gpu/drm/i915/gvt/dmabuf.h
> +++ b/drivers/gpu/drm/i915/gvt/dmabuf.h
> @@ -62,6 +62,7 @@ struct intel_vgpu_dmabuf_obj {
> =20
>  int intel_vgpu_query_plane(struct intel_vgpu *vgpu, void *args);
>  int intel_vgpu_get_dmabuf(struct intel_vgpu *vgpu, unsigned int dmabuf_i=
d);
> +int intel_vgpu_set_flip_eventfd(struct intel_vgpu *vgpu, int fd);
>  void intel_vgpu_dmabuf_cleanup(struct intel_vgpu *vgpu);
> =20
>  #endif
> diff --git a/drivers/gpu/drm/i915/gvt/gvt.c b/drivers/gpu/drm/i915/gvt/gv=
t.c
> index 43f4242062dd..7fd4afa432ef 100644
> --- a/drivers/gpu/drm/i915/gvt/gvt.c
> +++ b/drivers/gpu/drm/i915/gvt/gvt.c
> @@ -184,6 +184,7 @@ static const struct intel_gvt_ops intel_gvt_ops =3D {
>  	.get_gvt_attrs =3D intel_get_gvt_attrs,
>  	.vgpu_query_plane =3D intel_vgpu_query_plane,
>  	.vgpu_get_dmabuf =3D intel_vgpu_get_dmabuf,
> +	.vgpu_set_flip_eventfd =3D intel_vgpu_set_flip_eventfd,
>  	.write_protect_handler =3D intel_vgpu_page_track_handler,
>  	.emulate_hotplug =3D intel_vgpu_emulate_hotplug,
>  };
> diff --git a/drivers/gpu/drm/i915/gvt/gvt.h b/drivers/gpu/drm/i915/gvt/gv=
t.h
> index f5a328b5290a..86ca223f9a60 100644
> --- a/drivers/gpu/drm/i915/gvt/gvt.h
> +++ b/drivers/gpu/drm/i915/gvt/gvt.h
> @@ -229,6 +229,7 @@ struct intel_vgpu {
>  	struct completion vblank_done;
> =20
>  	u32 scan_nonprivbb;
> +	struct eventfd_ctx *page_flip_trigger;
>  };
> =20
>  /* validating GM healthy status*/
> @@ -570,6 +571,7 @@ struct intel_gvt_ops {
>  			struct attribute_group ***intel_vgpu_type_groups);
>  	int (*vgpu_query_plane)(struct intel_vgpu *vgpu, void *);
>  	int (*vgpu_get_dmabuf)(struct intel_vgpu *vgpu, unsigned int);
> +	int (*vgpu_set_flip_eventfd)(struct intel_vgpu *vgpu, int fd);
>  	int (*write_protect_handler)(struct intel_vgpu *, u64, void *,
>  				     unsigned int);
>  	void (*emulate_hotplug)(struct intel_vgpu *vgpu, bool connected);
> diff --git a/drivers/gpu/drm/i915/gvt/handlers.c b/drivers/gpu/drm/i915/g=
vt/handlers.c
> index 18f01eeb2510..1b5455888bdf 100644
> --- a/drivers/gpu/drm/i915/gvt/handlers.c
> +++ b/drivers/gpu/drm/i915/gvt/handlers.c
> @@ -763,6 +763,8 @@ static int pri_surf_mmio_write(struct intel_vgpu *vgp=
u, unsigned int offset,
>  	else
>  		set_bit(event, vgpu->irq.flip_done_event[pipe]);
> =20
> +	eventfd_signal(vgpu->page_flip_trigger, 1);

Need to check if page_flip_trigger is armed or not.

> +
>  	return 0;
>  }
> =20
> diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/=
kvmgt.c
> index a68addf95c23..00c75bd76bc0 100644
> --- a/drivers/gpu/drm/i915/gvt/kvmgt.c
> +++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
> @@ -1547,6 +1547,13 @@ static long intel_vgpu_ioctl(struct mdev_device *m=
dev, unsigned int cmd,
>  		dmabuf_fd =3D intel_gvt_ops->vgpu_get_dmabuf(vgpu, dmabuf_id);
>  		return dmabuf_fd;
> =20
> +	} else if (cmd =3D=3D VFIO_DEVICE_SET_GFX_FLIP_EVENTFD) {
> +		__s32 event_fd;
> +
> +		if (get_user(event_fd, (__s32 __user *)arg))
> +			return -EFAULT;
> +
> +		return intel_gvt_ops->vgpu_set_flip_eventfd(vgpu, event_fd);
>  	}
> =20
>  	return -ENOTTY;
> --=20
> 2.17.1
>=20

--=20
Open Source Technology Center, Intel ltd.

$gpg --keyserver wwwkeys.pgp.net --recv-keys 4D781827

--BRE3mIcgqKzpedwo
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EARECAB0WIQTXuabgHDW6LPt9CICxBBozTXgYJwUCXOupsQAKCRCxBBozTXgY
JxbuAJ4kNMoua0PETExQpHBAIZ2hJDRvaQCfekjRkSFcY0VlZyW57GoruPc4/H4=
=T0iT
-----END PGP SIGNATURE-----

--BRE3mIcgqKzpedwo--
