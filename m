Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6664F41D1AF
	for <lists+kvm@lfdr.de>; Thu, 30 Sep 2021 05:02:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347944AbhI3DE3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Sep 2021 23:04:29 -0400
Received: from gandalf.ozlabs.org ([150.107.74.76]:53435 "EHLO
        gandalf.ozlabs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347939AbhI3DE3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Sep 2021 23:04:29 -0400
Received: by gandalf.ozlabs.org (Postfix, from userid 1007)
        id 4HKdMn56h9z4xbL; Thu, 30 Sep 2021 13:02:45 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gibson.dropbear.id.au; s=201602; t=1632970965;
        bh=2chqBsylnpGWmu4/Ed3eGkp8ajdFLitawmHgzQaDmXw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=A4cfx1VeFIsTqJ1k4Q6E8pZP0Hfou7CmoniTfjOaeN1WkMvgKiG8Vw28t86iAyGSh
         N7PAncCR5TeJOCgm6Q07ayfhhXlfSLz4baebq0BiVDlF5nS2SLDRyOO6qFAIj8SIJX
         tGP84lGIl13L4sz2ILlRGWUZErmjSbvgGaN6oY6w=
Date:   Thu, 30 Sep 2021 12:43:46 +1000
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Liu Yi L <yi.l.liu@intel.com>, jgg@nvidia.com, hch@lst.de,
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
Message-ID: <YVUkYu59TJn5tcFg@yekko>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-3-yi.l.liu@intel.com>
 <YVPKu/F3IpPMtGCh@yekko>
 <20210929130521.738c56ed.alex.williamson@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="BWB8IX6FMezkTNqc"
Content-Disposition: inline
In-Reply-To: <20210929130521.738c56ed.alex.williamson@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--BWB8IX6FMezkTNqc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 29, 2021 at 01:05:21PM -0600, Alex Williamson wrote:
> On Wed, 29 Sep 2021 12:08:59 +1000
> David Gibson <david@gibson.dropbear.id.au> wrote:
>=20
> > On Sun, Sep 19, 2021 at 02:38:30PM +0800, Liu Yi L wrote:
> > > This patch introduces a new interface (/dev/vfio/devices/$DEVICE) for
> > > userspace to directly open a vfio device w/o relying on container/gro=
up
> > > (/dev/vfio/$GROUP). Anything related to group is now hidden behind
> > > iommufd (more specifically in iommu core by this RFC) in a device-cen=
tric
> > > manner.
> > >=20
> > > In case a device is exposed in both legacy and new interfaces (see ne=
xt
> > > patch for how to decide it), this patch also ensures that when the de=
vice
> > > is already opened via one interface then the other one must be blocke=
d.
> > >=20
> > > Signed-off-by: Liu Yi L <yi.l.liu@intel.com> =20
> > [snip]
> >=20
> > > +static bool vfio_device_in_container(struct vfio_device *device)
> > > +{
> > > +	return !!(device->group && device->group->container); =20
> >=20
> > You don't need !! here.  && is already a logical operation, so returns
> > a valid bool.
> >=20
> > > +}
> > > +
> > >  static int vfio_device_fops_release(struct inode *inode, struct file=
 *filep)
> > >  {
> > >  	struct vfio_device *device =3D filep->private_data;
> > > @@ -1560,7 +1691,16 @@ static int vfio_device_fops_release(struct ino=
de *inode, struct file *filep)
> > > =20
> > >  	module_put(device->dev->driver->owner);
> > > =20
> > > -	vfio_group_try_dissolve_container(device->group);
> > > +	if (vfio_device_in_container(device)) {
> > > +		vfio_group_try_dissolve_container(device->group);
> > > +	} else {
> > > +		atomic_dec(&device->opened);
> > > +		if (device->group) {
> > > +			mutex_lock(&device->group->opened_lock);
> > > +			device->group->opened--;
> > > +			mutex_unlock(&device->group->opened_lock);
> > > +		}
> > > +	}
> > > =20
> > >  	vfio_device_put(device);
> > > =20
> > > @@ -1613,6 +1753,7 @@ static int vfio_device_fops_mmap(struct file *f=
ilep, struct vm_area_struct *vma)
> > > =20
> > >  static const struct file_operations vfio_device_fops =3D {
> > >  	.owner		=3D THIS_MODULE,
> > > +	.open		=3D vfio_device_fops_open,
> > >  	.release	=3D vfio_device_fops_release,
> > >  	.read		=3D vfio_device_fops_read,
> > >  	.write		=3D vfio_device_fops_write,
> > > @@ -2295,6 +2436,52 @@ static struct miscdevice vfio_dev =3D {
> > >  	.mode =3D S_IRUGO | S_IWUGO,
> > >  };
> > > =20
> > > +static char *vfio_device_devnode(struct device *dev, umode_t *mode)
> > > +{
> > > +	return kasprintf(GFP_KERNEL, "vfio/devices/%s", dev_name(dev)); =20
> >=20
> > Others have pointed out some problems with the use of dev_name()
> > here.  I'll add that I think you'll make things much easier if instead
> > of using one huge "devices" subdir, you use a separate subdir for each
> > vfio sub-driver (so, one for PCI, one for each type of mdev, one for
> > platform, etc.).  That should make avoiding name conflicts a lot simple=
r.
>=20
> It seems like this is unnecessary if we use the vfioX naming approach.
> Conflicts are trivial to ignore if we don't involve dev_name() and
> looking for the correct major:minor chardev in the correct subdirectory
> seems like a hassle for userspace.  Thanks,

Right.. it does sound like a hassle, but AFAICT that's *more*
necessary with /dev/vfio/vfioXX than with /dev/vfio/pci/DDDD:BB:SS.F,
since you have to look up a meaningful name in sysfs to find the right
devnode.

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--BWB8IX6FMezkTNqc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAmFVJGAACgkQbDjKyiDZ
s5KzhhAApuv/xOzLxLHMyjuwLZM9hndWaHiOABTekrzAPageCyg8VIoWQld0IJZ7
m7jhClwoV3hwiJlg6HmyiRv7RAR6tMDJ3mVmaVXbHtWnRutl+4ZFBVdtuVlN3kYZ
WPVbqDupUviFlyO2+1i42HczlsUi2AFRiz7iEnJ8VBmkk00iYQNww0yRl8aB/vwl
E7c9G0HujmDtL+ob2jleWp2ynLDHCIU6VffkKUnp4irpyjPcWZ0pmnAVFiblP9I+
WdTEYw+HX+N3RWPKs7h+azughTZNJL+W6WGQkorEOvBmIYLgrt0Llf6UxXglw98d
QbtvusTEpn59yGnPuJQoSg8c3wPGuK81MFZQXY34GJwyNNf6j69UZMk82/TmUwav
u7DbHq82cG3Dn1jAlwRJnT4PSGBKU9dYmwh9J9sxCoPyS9nJqCk9tCj2aj5+WQqC
vJ9VP/p4QXwMnlPnXsKEBgDSyzC2WrNiwZ6tIy2TtsPMVaTQQts/3lKrABR5bGiN
2kjHuVbRpMxch0cXDo01Ft+wEhDLDl5zv6P5hhcdSgixX0GGh2M0YHZu/cxy4eS2
rbvrS5/NhtAGprFhdQDWFN5u+m1xE8tytmVCpY/23FBn6jU0nagNvEqx1fSqX4GY
UZQM5BL9nAbEY3hH9h1Y2ioJKMgdKT/XqK10coN5jku6rByU2Rs=
=o0Zb
-----END PGP SIGNATURE-----

--BWB8IX6FMezkTNqc--
