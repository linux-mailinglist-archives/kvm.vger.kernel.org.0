Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2B4D41BD62
	for <lists+kvm@lfdr.de>; Wed, 29 Sep 2021 05:28:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243954AbhI2D3n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Sep 2021 23:29:43 -0400
Received: from gandalf.ozlabs.org ([150.107.74.76]:44577 "EHLO
        gandalf.ozlabs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243907AbhI2D3m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Sep 2021 23:29:42 -0400
Received: by gandalf.ozlabs.org (Postfix, from userid 1007)
        id 4HK1zN6KgDz4xZJ; Wed, 29 Sep 2021 13:28:00 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gibson.dropbear.id.au; s=201602; t=1632886080;
        bh=or14ij/yBL19FjOCDsq0iAERcyiiYaHgFexNi04sb48=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jK76m0XsvCYgqc5O5vt60FBITyisxy37c72l0yhrARzYXhnqOHbuEDZXS3rqSNwKa
         LDl3EBUKF3iXf6FoCnHsokBb8jPZenL2TYKf+4WEHthw3EjMsbu+Bw17crMQDvL7fv
         MGdaUPaeiRdaBOALa7efNweYMOueSg3zZgFhhlD0=
Date:   Wed, 29 Sep 2021 12:08:59 +1000
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Liu Yi L <yi.l.liu@intel.com>
Cc:     alex.williamson@redhat.com, jgg@nvidia.com, hch@lst.de,
        jasowang@redhat.com, joro@8bytes.org, jean-philippe@linaro.org,
        kevin.tian@intel.com, parav@mellanox.com, lkml@metux.net,
        pbonzini@redhat.com, lushenming@huawei.com, eric.auger@redhat.com,
        corbet@lwn.net, ashok.raj@intel.com, yi.l.liu@linux.intel.com,
        jun.j.tian@intel.com, hao.wu@intel.com, dave.jiang@intel.com,
        jacob.jun.pan@linux.intel.com, kwankhede@nvidia.com,
        robin.murphy@arm.com, kvm@vger.kernel.org,
        iommu@lists.linux-foundation.org, dwmw2@infradead.org,
        linux-kernel@vger.kernel.org, baolu.lu@linux.intel.com,
        nicolinc@nvidia.com
Subject: Re: [RFC 02/20] vfio: Add device class for /dev/vfio/devices
Message-ID: <YVPKu/F3IpPMtGCh@yekko>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-3-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="rFAAVZBIABvNkDR9"
Content-Disposition: inline
In-Reply-To: <20210919063848.1476776-3-yi.l.liu@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--rFAAVZBIABvNkDR9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Sep 19, 2021 at 02:38:30PM +0800, Liu Yi L wrote:
> This patch introduces a new interface (/dev/vfio/devices/$DEVICE) for
> userspace to directly open a vfio device w/o relying on container/group
> (/dev/vfio/$GROUP). Anything related to group is now hidden behind
> iommufd (more specifically in iommu core by this RFC) in a device-centric
> manner.
>=20
> In case a device is exposed in both legacy and new interfaces (see next
> patch for how to decide it), this patch also ensures that when the device
> is already opened via one interface then the other one must be blocked.
>=20
> Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
[snip]

> +static bool vfio_device_in_container(struct vfio_device *device)
> +{
> +	return !!(device->group && device->group->container);

You don't need !! here.  && is already a logical operation, so returns
a valid bool.

> +}
> +
>  static int vfio_device_fops_release(struct inode *inode, struct file *fi=
lep)
>  {
>  	struct vfio_device *device =3D filep->private_data;
> @@ -1560,7 +1691,16 @@ static int vfio_device_fops_release(struct inode *=
inode, struct file *filep)
> =20
>  	module_put(device->dev->driver->owner);
> =20
> -	vfio_group_try_dissolve_container(device->group);
> +	if (vfio_device_in_container(device)) {
> +		vfio_group_try_dissolve_container(device->group);
> +	} else {
> +		atomic_dec(&device->opened);
> +		if (device->group) {
> +			mutex_lock(&device->group->opened_lock);
> +			device->group->opened--;
> +			mutex_unlock(&device->group->opened_lock);
> +		}
> +	}
> =20
>  	vfio_device_put(device);
> =20
> @@ -1613,6 +1753,7 @@ static int vfio_device_fops_mmap(struct file *filep=
, struct vm_area_struct *vma)
> =20
>  static const struct file_operations vfio_device_fops =3D {
>  	.owner		=3D THIS_MODULE,
> +	.open		=3D vfio_device_fops_open,
>  	.release	=3D vfio_device_fops_release,
>  	.read		=3D vfio_device_fops_read,
>  	.write		=3D vfio_device_fops_write,
> @@ -2295,6 +2436,52 @@ static struct miscdevice vfio_dev =3D {
>  	.mode =3D S_IRUGO | S_IWUGO,
>  };
> =20
> +static char *vfio_device_devnode(struct device *dev, umode_t *mode)
> +{
> +	return kasprintf(GFP_KERNEL, "vfio/devices/%s", dev_name(dev));

Others have pointed out some problems with the use of dev_name()
here.  I'll add that I think you'll make things much easier if instead
of using one huge "devices" subdir, you use a separate subdir for each
vfio sub-driver (so, one for PCI, one for each type of mdev, one for
platform, etc.).  That should make avoiding name conflicts a lot simpler.

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--rFAAVZBIABvNkDR9
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAmFTyrkACgkQbDjKyiDZ
s5LDRxAA45DlpAfiA499JLduAg68fEU3Bdr3uqrAxaxXW5bnLJVw9BLOv1YV6Izb
GffTAoUJE/gceiS+dIPmE1A8Zxsdb3vCT3Ci8gKEevQ/zMcqBdnO5KZ//nRAlrMl
vsDahtaUQy/3uxRqSA8r2jlEujuHfdFJzi5pNosxfLQkCiSkYzAG7ePdxDOEBhJv
bqay3ZBkns2E8RjTZ8ytDBV2zHqQW3G2/kqFAK7qx8eefGROcDAv7NoroHt8EB8+
EYBXZgj+4nQChP+wQoEmXkRzkDocPtS4IKODB1YjTTCKW4O0YI8TfuvnCCPRLrku
VZFk4PNw9sADsqB4plA+3/QkeDLskC23/GTZ/+djAVcsSAs+Oyiisw63I7LibeKg
h5LKefqlBoOURSgk9f0AHIYwaxoE7qXgsf7zGKcI80waLoVWkOQXSj5/D0asFtGf
sZrthpsKPKAl40jH+lA35r98Acb/m8uJdICPUoG/QTtc8F/0UIjWKsZxJH8Wtss8
FaCAP1lw3gKK76Trdi2XavMZFkRmWNatPKTiCaNY8qQRyt/RvAteJjnwR1R2RKji
fAQo8P1ZNxAhrGdYI9QzAsy0pYyO0Va/TPy0lf9KRQHIH4ff2DGHQB0azLwyJ+JF
3x7clC6gMiPwmHmWUMwTgrenfi6br6zggTRWzC2sWbs0iJCzIRo=
=C+J/
-----END PGP SIGNATURE-----

--rFAAVZBIABvNkDR9--
