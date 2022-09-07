Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 519CC5AFAC1
	for <lists+kvm@lfdr.de>; Wed,  7 Sep 2022 05:43:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229831AbiIGDnT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Sep 2022 23:43:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiIGDnS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Sep 2022 23:43:18 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B810915E6;
        Tue,  6 Sep 2022 20:43:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662522197; x=1694058197;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   mime-version:in-reply-to;
  bh=/C9hMb/vqwzLp+1sLbG2jxkkx4aFONBeYuPiLUHezhU=;
  b=OPyPBME8pqy1yzTETRnlVMQS5LJljryBDwyxhMKmAbvnoTCzWyQFXHQf
   lMKHiOOiFjnluVBkUGa2p3HxQPf8HlKiwP9sE7nm40voZxDg8zwxBxyOV
   K4kjrKSiGBHzyKKk60/mO5l4oxDO4vthVNZq72FRZJgQz1lsLMygqlqjl
   GDujIwYto64geeEgN0MV+43CO6bUySW7LwvLnTv9O6fg99tU9kYKQt8n3
   DxnufkPlZW0F2q0o4XfuxLUeUV5NYusL3P8PWSldu9cc+SpZE/TJhqi5M
   MnA6e/P2gQbgV2OL3Mqu7pnEEP7cbGfVpMMTUZAMw0cjb8SOqO9g3pADR
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10462"; a="297554880"
X-IronPort-AV: E=Sophos;i="5.93,295,1654585200"; 
   d="asc'?scan'208";a="297554880"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Sep 2022 20:43:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,295,1654585200"; 
   d="asc'?scan'208";a="675990194"
Received: from zhen-hp.sh.intel.com (HELO zhen-hp) ([10.239.159.108])
  by fmsmga008.fm.intel.com with ESMTP; 06 Sep 2022 20:43:09 -0700
Date:   Wed, 7 Sep 2022 11:17:32 +0800
From:   Zhenyu Wang <zhenyuw@linux.intel.com>
To:     Kevin Tian <kevin.tian@intel.com>
Cc:     Zhi Wang <zhi.a.wang@intel.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Longfang Liu <liulongfang@huawei.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Yishai Hadas <yishaih@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Abhishek Sahu <abhsahu@nvidia.com>,
        intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH v2 08/15] drm/i915/gvt: Use the new device life cycle
 helpers
Message-ID: <20220907031732.GV1089@zhen-hp.sh.intel.com>
Reply-To: Zhenyu Wang <zhenyuw@linux.intel.com>
References: <20220901143747.32858-1-kevin.tian@intel.com>
 <20220901143747.32858-9-kevin.tian@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="v1mHNXBTCsim3EdZ"
Content-Disposition: inline
In-Reply-To: <20220901143747.32858-9-kevin.tian@intel.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--v1mHNXBTCsim3EdZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2022.09.01 22:37:40 +0800, Kevin Tian wrote:
> Move vfio_device to the start of intel_vgpu as required by the new
> helpers.
>=20
> Change intel_gvt_create_vgpu() to use intel_vgpu as the first param
> as other vgpu helpers do.
>=20
> Signed-off-by: Kevin Tian <kevin.tian@intel.com>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> ---

Looks good to me.

Reviewed-by: Zhenyu Wang <zhenyuw@linux.intel.com>

>  drivers/gpu/drm/i915/gvt/gvt.h   |  5 ++-
>  drivers/gpu/drm/i915/gvt/kvmgt.c | 52 ++++++++++++++++++++++----------
>  drivers/gpu/drm/i915/gvt/vgpu.c  | 33 ++++++++------------
>  3 files changed, 50 insertions(+), 40 deletions(-)
>=20
> diff --git a/drivers/gpu/drm/i915/gvt/gvt.h b/drivers/gpu/drm/i915/gvt/gv=
t.h
> index 705689e64011..89fab7896fc6 100644
> --- a/drivers/gpu/drm/i915/gvt/gvt.h
> +++ b/drivers/gpu/drm/i915/gvt/gvt.h
> @@ -172,6 +172,7 @@ struct intel_vgpu_submission {
>  #define KVMGT_DEBUGFS_FILENAME		"kvmgt_nr_cache_entries"
> =20
>  struct intel_vgpu {
> +	struct vfio_device vfio_device;
>  	struct intel_gvt *gvt;
>  	struct mutex vgpu_lock;
>  	int id;
> @@ -211,7 +212,6 @@ struct intel_vgpu {
> =20
>  	u32 scan_nonprivbb;
> =20
> -	struct vfio_device vfio_device;
>  	struct vfio_region *region;
>  	int num_regions;
>  	struct eventfd_ctx *intx_trigger;
> @@ -494,8 +494,7 @@ void intel_gvt_clean_vgpu_types(struct intel_gvt *gvt=
);
> =20
>  struct intel_vgpu *intel_gvt_create_idle_vgpu(struct intel_gvt *gvt);
>  void intel_gvt_destroy_idle_vgpu(struct intel_vgpu *vgpu);
> -struct intel_vgpu *intel_gvt_create_vgpu(struct intel_gvt *gvt,
> -					 struct intel_vgpu_type *type);
> +int intel_gvt_create_vgpu(struct intel_vgpu *vgpu, struct intel_vgpu_typ=
e *type);
>  void intel_gvt_destroy_vgpu(struct intel_vgpu *vgpu);
>  void intel_gvt_release_vgpu(struct intel_vgpu *vgpu);
>  void intel_gvt_reset_vgpu_locked(struct intel_vgpu *vgpu, bool dmlr,
> diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/=
kvmgt.c
> index e3cd58946477..41bba40feef8 100644
> --- a/drivers/gpu/drm/i915/gvt/kvmgt.c
> +++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
> @@ -1546,7 +1546,33 @@ static const struct attribute_group *intel_vgpu_gr=
oups[] =3D {
>  	NULL,
>  };
> =20
> +static int intel_vgpu_init_dev(struct vfio_device *vfio_dev)
> +{
> +	struct mdev_device *mdev =3D to_mdev_device(vfio_dev->dev);
> +	struct device *pdev =3D mdev_parent_dev(mdev);
> +	struct intel_gvt *gvt =3D kdev_to_i915(pdev)->gvt;
> +	struct intel_vgpu_type *type;
> +	struct intel_vgpu *vgpu =3D vfio_dev_to_vgpu(vfio_dev);
> +
> +	type =3D &gvt->types[mdev_get_type_group_id(mdev)];
> +	if (!type)
> +		return -EINVAL;
> +
> +	vgpu->gvt =3D gvt;
> +	return intel_gvt_create_vgpu(vgpu, type);
> +}
> +
> +static void intel_vgpu_release_dev(struct vfio_device *vfio_dev)
> +{
> +	struct intel_vgpu *vgpu =3D vfio_dev_to_vgpu(vfio_dev);
> +
> +	intel_gvt_destroy_vgpu(vgpu);
> +	vfio_free_device(vfio_dev);
> +}
> +
>  static const struct vfio_device_ops intel_vgpu_dev_ops =3D {
> +	.init		=3D intel_vgpu_init_dev,
> +	.release	=3D intel_vgpu_release_dev,
>  	.open_device	=3D intel_vgpu_open_device,
>  	.close_device	=3D intel_vgpu_close_device,
>  	.read		=3D intel_vgpu_read,
> @@ -1558,35 +1584,28 @@ static const struct vfio_device_ops intel_vgpu_de=
v_ops =3D {
> =20
>  static int intel_vgpu_probe(struct mdev_device *mdev)
>  {
> -	struct device *pdev =3D mdev_parent_dev(mdev);
> -	struct intel_gvt *gvt =3D kdev_to_i915(pdev)->gvt;
> -	struct intel_vgpu_type *type;
>  	struct intel_vgpu *vgpu;
>  	int ret;
> =20
> -	type =3D &gvt->types[mdev_get_type_group_id(mdev)];
> -	if (!type)
> -		return -EINVAL;
> -
> -	vgpu =3D intel_gvt_create_vgpu(gvt, type);
> +	vgpu =3D vfio_alloc_device(intel_vgpu, vfio_device, &mdev->dev,
> +				 &intel_vgpu_dev_ops);
>  	if (IS_ERR(vgpu)) {
>  		gvt_err("failed to create intel vgpu: %ld\n", PTR_ERR(vgpu));
>  		return PTR_ERR(vgpu);
>  	}
> =20
> -	vfio_init_group_dev(&vgpu->vfio_device, &mdev->dev,
> -			    &intel_vgpu_dev_ops);
> -
>  	dev_set_drvdata(&mdev->dev, vgpu);
>  	ret =3D vfio_register_emulated_iommu_dev(&vgpu->vfio_device);
> -	if (ret) {
> -		intel_gvt_destroy_vgpu(vgpu);
> -		return ret;
> -	}
> +	if (ret)
> +		goto out_put_vdev;
> =20
>  	gvt_dbg_core("intel_vgpu_create succeeded for mdev: %s\n",
>  		     dev_name(mdev_dev(mdev)));
>  	return 0;
> +
> +out_put_vdev:
> +	vfio_put_device(&vgpu->vfio_device);
> +	return ret;
>  }
> =20
>  static void intel_vgpu_remove(struct mdev_device *mdev)
> @@ -1595,7 +1614,8 @@ static void intel_vgpu_remove(struct mdev_device *m=
dev)
> =20
>  	if (WARN_ON_ONCE(vgpu->attached))
>  		return;
> -	intel_gvt_destroy_vgpu(vgpu);
> +
> +	vfio_put_device(&vgpu->vfio_device);
>  }
> =20
>  static struct mdev_driver intel_vgpu_mdev_driver =3D {
> diff --git a/drivers/gpu/drm/i915/gvt/vgpu.c b/drivers/gpu/drm/i915/gvt/v=
gpu.c
> index 46da19b3225d..5c533fbc2c8d 100644
> --- a/drivers/gpu/drm/i915/gvt/vgpu.c
> +++ b/drivers/gpu/drm/i915/gvt/vgpu.c
> @@ -302,8 +302,6 @@ void intel_gvt_destroy_vgpu(struct intel_vgpu *vgpu)
>  	mutex_lock(&gvt->lock);
>  	intel_gvt_update_vgpu_types(gvt);
>  	mutex_unlock(&gvt->lock);
> -
> -	vfree(vgpu);
>  }
> =20
>  #define IDLE_VGPU_IDR 0
> @@ -363,28 +361,23 @@ void intel_gvt_destroy_idle_vgpu(struct intel_vgpu =
*vgpu)
>  	vfree(vgpu);
>  }
> =20
> -static struct intel_vgpu *__intel_gvt_create_vgpu(struct intel_gvt *gvt,
> -		struct intel_vgpu_creation_params *param)
> +static int __intel_gvt_create_vgpu(struct intel_vgpu *vgpu,
> +				   struct intel_vgpu_creation_params *param)
>  {
> +	struct intel_gvt *gvt =3D vgpu->gvt;
>  	struct drm_i915_private *dev_priv =3D gvt->gt->i915;
> -	struct intel_vgpu *vgpu;
>  	int ret;
> =20
>  	gvt_dbg_core("low %llu MB high %llu MB fence %llu\n",
>  			param->low_gm_sz, param->high_gm_sz,
>  			param->fence_sz);
> =20
> -	vgpu =3D vzalloc(sizeof(*vgpu));
> -	if (!vgpu)
> -		return ERR_PTR(-ENOMEM);
> -
>  	ret =3D idr_alloc(&gvt->vgpu_idr, vgpu, IDLE_VGPU_IDR + 1, GVT_MAX_VGPU,
>  		GFP_KERNEL);
>  	if (ret < 0)
> -		goto out_free_vgpu;
> +		return ret;
> =20
>  	vgpu->id =3D ret;
> -	vgpu->gvt =3D gvt;
>  	vgpu->sched_ctl.weight =3D param->weight;
>  	mutex_init(&vgpu->vgpu_lock);
>  	mutex_init(&vgpu->dmabuf_lock);
> @@ -437,7 +430,7 @@ static struct intel_vgpu *__intel_gvt_create_vgpu(str=
uct intel_gvt *gvt,
>  	if (ret)
>  		goto out_clean_sched_policy;
> =20
> -	return vgpu;
> +	return 0;
> =20
>  out_clean_sched_policy:
>  	intel_vgpu_clean_sched_policy(vgpu);
> @@ -455,9 +448,7 @@ static struct intel_vgpu *__intel_gvt_create_vgpu(str=
uct intel_gvt *gvt,
>  	intel_vgpu_clean_mmio(vgpu);
>  out_clean_idr:
>  	idr_remove(&gvt->vgpu_idr, vgpu->id);
> -out_free_vgpu:
> -	vfree(vgpu);
> -	return ERR_PTR(ret);
> +	return ret;
>  }
> =20
>  /**
> @@ -470,11 +461,11 @@ static struct intel_vgpu *__intel_gvt_create_vgpu(s=
truct intel_gvt *gvt,
>   * Returns:
>   * pointer to intel_vgpu, error pointer if failed.
>   */
> -struct intel_vgpu *intel_gvt_create_vgpu(struct intel_gvt *gvt,
> -				struct intel_vgpu_type *type)
> +int intel_gvt_create_vgpu(struct intel_vgpu *vgpu, struct intel_vgpu_typ=
e *type)
>  {
> +	struct intel_gvt *gvt =3D vgpu->gvt;
>  	struct intel_vgpu_creation_params param;
> -	struct intel_vgpu *vgpu;
> +	int ret;
> =20
>  	param.primary =3D 1;
>  	param.low_gm_sz =3D type->low_gm_size;
> @@ -488,15 +479,15 @@ struct intel_vgpu *intel_gvt_create_vgpu(struct int=
el_gvt *gvt,
>  	param.high_gm_sz =3D BYTES_TO_MB(param.high_gm_sz);
> =20
>  	mutex_lock(&gvt->lock);
> -	vgpu =3D __intel_gvt_create_vgpu(gvt, &param);
> -	if (!IS_ERR(vgpu)) {
> +	ret =3D __intel_gvt_create_vgpu(vgpu, &param);
> +	if (!ret) {
>  		/* calculate left instance change for types */
>  		intel_gvt_update_vgpu_types(gvt);
>  		intel_gvt_update_reg_whitelist(vgpu);
>  	}
>  	mutex_unlock(&gvt->lock);
> =20
> -	return vgpu;
> +	return ret;
>  }
> =20
>  /**
> --=20
> 2.21.3
>=20

--v1mHNXBTCsim3EdZ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EARECAB0WIQTXuabgHDW6LPt9CICxBBozTXgYJwUCYxgNTAAKCRCxBBozTXgY
J9AhAJsHdw+uwnIf1EAv79KfeCNmLe7nNQCgigQq5RjziXJK5KFRZO1f/CCsIVk=
=X9aw
-----END PGP SIGNATURE-----

--v1mHNXBTCsim3EdZ--
