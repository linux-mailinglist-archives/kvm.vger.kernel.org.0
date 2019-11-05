Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A1E0F0A3A
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2019 00:35:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729048AbfKEXfy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Nov 2019 18:35:54 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:33303 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727046AbfKEXfx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Nov 2019 18:35:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572996952;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=czdzSvV3k1c+hHQwlkGWN41Rge6L8DF10GFMATNbkS8=;
        b=GVXLrvf/XGM+WZSY9wdXscs6XAIeKRrO9tkTjsIn3tAAtfWIvyei4qJ5XK55eo6Yi/VBBy
        /8QXrcdYlN/dDVss1WLBhVb4mLA1Jmo1EWBsaf1+x9Q4tCtJqkHedFYb+V1NeoXvZJDtzf
        knCQkH1ar849rmjdqUtOxdBAngq01D8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-430-DPhczA-8O0CgFmaXYaOmVg-1; Tue, 05 Nov 2019 18:35:48 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 09E02477;
        Tue,  5 Nov 2019 23:35:47 +0000 (UTC)
Received: from x1.home (ovpn-116-110.phx2.redhat.com [10.3.116.110])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 305AD608AC;
        Tue,  5 Nov 2019 23:35:38 +0000 (UTC)
Date:   Tue, 5 Nov 2019 16:35:37 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Liu Yi L <yi.l.liu@intel.com>
Cc:     eric.auger@redhat.com, kevin.tian@intel.com,
        jacob.jun.pan@linux.intel.com, joro@8bytes.org,
        ashok.raj@intel.com, jun.j.tian@intel.com, yi.y.sun@intel.com,
        jean-philippe.brucker@arm.com, peterx@redhat.com,
        iommu@lists.linux-foundation.org, kvm@vger.kernel.org
Subject: Re: [RFC v2 2/3] vfio/type1: VFIO_IOMMU_PASID_REQUEST(alloc/free)
Message-ID: <20191105163537.1935291c@x1.home>
In-Reply-To: <1571919983-3231-3-git-send-email-yi.l.liu@intel.com>
References: <1571919983-3231-1-git-send-email-yi.l.liu@intel.com>
        <1571919983-3231-3-git-send-email-yi.l.liu@intel.com>
Organization: Red Hat
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: DPhczA-8O0CgFmaXYaOmVg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 24 Oct 2019 08:26:22 -0400
Liu Yi L <yi.l.liu@intel.com> wrote:

> This patch adds VFIO_IOMMU_PASID_REQUEST ioctl which aims
> to passdown PASID allocation/free request from the virtual
> iommu. This is required to get PASID managed in system-wide.
>=20
> Cc: Kevin Tian <kevin.tian@intel.com>
> Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> Signed-off-by: Yi Sun <yi.y.sun@linux.intel.com>
> Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 114 ++++++++++++++++++++++++++++++++++=
++++++
>  include/uapi/linux/vfio.h       |  25 +++++++++
>  2 files changed, 139 insertions(+)
>=20
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_ty=
pe1.c
> index cd8d3a5..3d73a7d 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -2248,6 +2248,83 @@ static int vfio_cache_inv_fn(struct device *dev, v=
oid *data)
>  =09return iommu_cache_invalidate(dc->domain, dev, &ustruct->info);
>  }
> =20
> +static int vfio_iommu_type1_pasid_alloc(struct vfio_iommu *iommu,
> +=09=09=09=09=09 int min_pasid,
> +=09=09=09=09=09 int max_pasid)
> +{
> +=09int ret;
> +=09ioasid_t pasid;
> +=09struct mm_struct *mm =3D NULL;
> +
> +=09mutex_lock(&iommu->lock);
> +=09if (!IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu)) {
> +=09=09ret =3D -EINVAL;
> +=09=09goto out_unlock;
> +=09}
> +=09mm =3D get_task_mm(current);
> +=09/* Track ioasid allocation owner by mm */
> +=09pasid =3D ioasid_alloc((struct ioasid_set *)mm, min_pasid,
> +=09=09=09=09max_pasid, NULL);

Are we sure we want to tie this to the task mm vs perhaps the
vfio_iommu pointer?

> +=09if (pasid =3D=3D INVALID_IOASID) {
> +=09=09ret =3D -ENOSPC;
> +=09=09goto out_unlock;
> +=09}
> +=09ret =3D pasid;
> +out_unlock:
> +=09mutex_unlock(&iommu->lock);
> +=09if (mm)
> +=09=09mmput(mm);
> +=09return ret;
> +}
> +
> +static int vfio_iommu_type1_pasid_free(struct vfio_iommu *iommu,
> +=09=09=09=09       unsigned int pasid)
> +{
> +=09struct mm_struct *mm =3D NULL;
> +=09void *pdata;
> +=09int ret =3D 0;
> +
> +=09mutex_lock(&iommu->lock);
> +=09if (!IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu)) {
> +=09=09ret =3D -EINVAL;
> +=09=09goto out_unlock;
> +=09}
> +
> +=09/**
> +=09 * REVISIT:
> +=09 * There are two cases free could fail:
> +=09 * 1. free pasid by non-owner, we use ioasid_set to track mm, if
> +=09 * the set does not match, caller is not permitted to free.
> +=09 * 2. free before unbind all devices, we can check if ioasid private
> +=09 * data, if data !=3D NULL, then fail to free.
> +=09 */
> +=09mm =3D get_task_mm(current);
> +=09pdata =3D ioasid_find((struct ioasid_set *)mm, pasid, NULL);
> +=09if (IS_ERR(pdata)) {
> +=09=09if (pdata =3D=3D ERR_PTR(-ENOENT))
> +=09=09=09pr_err("PASID %u is not allocated\n", pasid);
> +=09=09else if (pdata =3D=3D ERR_PTR(-EACCES))
> +=09=09=09pr_err("Free PASID %u by non-owner, denied", pasid);
> +=09=09else
> +=09=09=09pr_err("Error searching PASID %u\n", pasid);

This should be removed, errno is sufficient for the user, this just
provides the user with a trivial DoS vector filling logs.

> +=09=09ret =3D -EPERM;

But why not return PTR_ERR(pdata)?

> +=09=09goto out_unlock;
> +=09}
> +=09if (pdata) {
> +=09=09pr_debug("Cannot free pasid %d with private data\n", pasid);
> +=09=09/* Expect PASID has no private data if not bond */
> +=09=09ret =3D -EBUSY;
> +=09=09goto out_unlock;
> +=09}
> +=09ioasid_free(pasid);

We only ever get here with pasid =3D=3D NULL?!  Something is wrong.  Should
that be 'if (!pdata)'?  (which also makes that pr_debug another DoS
vector)

> +
> +out_unlock:
> +=09if (mm)
> +=09=09mmput(mm);
> +=09mutex_unlock(&iommu->lock);
> +=09return ret;
> +}
> +
>  static long vfio_iommu_type1_ioctl(void *iommu_data,
>  =09=09=09=09   unsigned int cmd, unsigned long arg)
>  {
> @@ -2370,6 +2447,43 @@ static long vfio_iommu_type1_ioctl(void *iommu_dat=
a,
>  =09=09=09=09=09    &ustruct);
>  =09=09mutex_unlock(&iommu->lock);
>  =09=09return ret;
> +
> +=09} else if (cmd =3D=3D VFIO_IOMMU_PASID_REQUEST) {
> +=09=09struct vfio_iommu_type1_pasid_request req;
> +=09=09int min_pasid, max_pasid, pasid;
> +
> +=09=09minsz =3D offsetofend(struct vfio_iommu_type1_pasid_request,
> +=09=09=09=09    flag);
> +
> +=09=09if (copy_from_user(&req, (void __user *)arg, minsz))
> +=09=09=09return -EFAULT;
> +
> +=09=09if (req.argsz < minsz)
> +=09=09=09return -EINVAL;
> +
> +=09=09switch (req.flag) {

This works, but it's strange.  Let's make the code a little easier for
the next flag bit that gets used so they don't need to rework this case
statement.  I'd suggest creating a VFIO_IOMMU_PASID_OPS_MASK that is
the OR of the ALLOC/FREE options, test that no bits are set outside of
that mask, then AND that mask as the switch arg with the code below.

> +=09=09/**
> +=09=09 * TODO: min_pasid and max_pasid align with
> +=09=09 * typedef unsigned int ioasid_t
> +=09=09 */
> +=09=09case VFIO_IOMMU_PASID_ALLOC:
> +=09=09=09if (copy_from_user(&min_pasid,
> +=09=09=09=09(void __user *)arg + minsz, sizeof(min_pasid)))
> +=09=09=09=09return -EFAULT;
> +=09=09=09if (copy_from_user(&max_pasid,
> +=09=09=09=09(void __user *)arg + minsz + sizeof(min_pasid),
> +=09=09=09=09sizeof(max_pasid)))
> +=09=09=09=09return -EFAULT;
> +=09=09=09return vfio_iommu_type1_pasid_alloc(iommu,
> +=09=09=09=09=09=09min_pasid, max_pasid);
> +=09=09case VFIO_IOMMU_PASID_FREE:
> +=09=09=09if (copy_from_user(&pasid,
> +=09=09=09=09(void __user *)arg + minsz, sizeof(pasid)))
> +=09=09=09=09return -EFAULT;
> +=09=09=09return vfio_iommu_type1_pasid_free(iommu, pasid);
> +=09=09default:
> +=09=09=09return -EINVAL;
> +=09=09}
>  =09}
> =20
>  =09return -ENOTTY;
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index ccf60a2..04de290 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -807,6 +807,31 @@ struct vfio_iommu_type1_cache_invalidate {
>  };
>  #define VFIO_IOMMU_CACHE_INVALIDATE      _IO(VFIO_TYPE, VFIO_BASE + 24)
> =20
> +/*
> + * @flag=3DVFIO_IOMMU_PASID_ALLOC, refer to the @min_pasid and @max_pasi=
d fields
> + * @flag=3DVFIO_IOMMU_PASID_FREE, refer to @pasid field
> + */
> +struct vfio_iommu_type1_pasid_request {
> +=09__u32=09argsz;
> +#define VFIO_IOMMU_PASID_ALLOC=09(1 << 0)
> +#define VFIO_IOMMU_PASID_FREE=09(1 << 1)
> +=09__u32=09flag;
> +=09union {
> +=09=09struct {
> +=09=09=09int min_pasid;
> +=09=09=09int max_pasid;
> +=09=09};
> +=09=09int pasid;

Perhaps:

=09=09struct {
=09=09=09u32 min;
=09=09=09u32 max;
=09=09} alloc_pasid;
=09=09u32 free_pasid;

(note also the s/int/u32/)

> +=09};
> +};
> +
> +/**
> + * VFIO_IOMMU_PASID_REQUEST - _IOWR(VFIO_TYPE, VFIO_BASE + 27,
> + *=09=09=09=09struct vfio_iommu_type1_pasid_request)
> + *
> + */
> +#define VFIO_IOMMU_PASID_REQUEST=09_IO(VFIO_TYPE, VFIO_BASE + 27)
> +
>  /* -------- Additional API for SPAPR TCE (Server POWERPC) IOMMU --------=
 */
> =20
>  /*

