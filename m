Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CE1941E795
	for <lists+kvm@lfdr.de>; Fri,  1 Oct 2021 08:30:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352242AbhJAGc3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Oct 2021 02:32:29 -0400
Received: from gandalf.ozlabs.org ([150.107.74.76]:41989 "EHLO
        gandalf.ozlabs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352125AbhJAGc1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Oct 2021 02:32:27 -0400
Received: by gandalf.ozlabs.org (Postfix, from userid 1007)
        id 4HLKxG54zmz4xbR; Fri,  1 Oct 2021 16:30:42 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gibson.dropbear.id.au; s=201602; t=1633069842;
        bh=K4BHDoiWTjnYxEiM7KxTgO/MtSIfmeycDfNJ3LKXLAc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZJh1+ik15KtihcPpVhMIA1lM1tPQU3tk2wJJAY76tdzCmGvzInhCE7xcfJ3fUlCBj
         8L9IDL7KSQMFp/OCBJijEQsoQ/uXL4pE0NF7Xrq3s5P+cgfzGniZveXZ44udupPiqf
         Fww12/h5/fTXIGHZQYNYE5zBrIaLAEhpb5pGQ7o8=
Date:   Fri, 1 Oct 2021 16:11:14 +1000
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
Subject: Re: [RFC 11/20] iommu/iommufd: Add IOMMU_IOASID_ALLOC/FREE
Message-ID: <YVamgnMzuv3TCQiX@yekko>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-12-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="emeUklQwaw/5Jbba"
Content-Disposition: inline
In-Reply-To: <20210919063848.1476776-12-yi.l.liu@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--emeUklQwaw/5Jbba
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Sep 19, 2021 at 02:38:39PM +0800, Liu Yi L wrote:
> This patch adds IOASID allocation/free interface per iommufd. When
> allocating an IOASID, userspace is expected to specify the type and
> format information for the target I/O page table.
>=20
> This RFC supports only one type (IOMMU_IOASID_TYPE_KERNEL_TYPE1V2),
> implying a kernel-managed I/O page table with vfio type1v2 mapping
> semantics. For this type the user should specify the addr_width of
> the I/O address space and whether the I/O page table is created in
> an iommu enfore_snoop format. enforce_snoop must be true at this point,
> as the false setting requires additional contract with KVM on handling
> WBINVD emulation, which can be added later.
>=20
> Userspace is expected to call IOMMU_CHECK_EXTENSION (see next patch)
> for what formats can be specified when allocating an IOASID.
>=20
> Open:
> - Devices on PPC platform currently use a different iommu driver in vfio.
>   Per previous discussion they can also use vfio type1v2 as long as there
>   is a way to claim a specific iova range from a system-wide address spac=
e.
>   This requirement doesn't sound PPC specific, as addr_width for pci devi=
ces
>   can be also represented by a range [0, 2^addr_width-1]. This RFC hasn't
>   adopted this design yet. We hope to have formal alignment in v1 discuss=
ion
>   and then decide how to incorporate it in v2.

Ok, there are several things we need for ppc.  None of which are
inherently ppc specific and some of which will I think be useful for
most platforms.  So, starting from most general to most specific
here's basically what's needed:

1. We need to represent the fact that the IOMMU can only translate
   *some* IOVAs, not a full 64-bit range.  You have the addr_width
   already, but I'm entirely sure if the translatable range on ppc
   (or other platforms) is always a power-of-2 size.  It usually will
   be, of course, but I'm not sure that's a hard requirement.  So
   using a size/max rather than just a number of bits might be safer.

   I think basically every platform will need this.  Most platforms
   don't actually implement full 64-bit translation in any case, but
   rather some smaller number of bits that fits their page table
   format.

2. The translatable range of IOVAs may not begin at 0.  So we need to
   advertise to userspace what the base address is, as well as the
   size.  POWER's main IOVA range begins at 2^59 (at least on the
   models I know about).

   I think a number of platforms are likely to want this, though I
   couldn't name them apart from POWER.  Putting the translated IOVA
   window at some huge address is a pretty obvious approach to making
   an IOMMU which can translate a wide address range without colliding
   with any legacy PCI addresses down low (the IOMMU can check if this
   transaction is for it by just looking at some high bits in the
   address).

3. There might be multiple translatable ranges.  So, on POWER the
   IOMMU can typically translate IOVAs from 0..2GiB, and also from
   2^59..2^59+<RAM size>.  The two ranges have completely separate IO
   page tables, with (usually) different layouts.  (The low range will
   nearly always be a single-level page table with 4kiB or 64kiB
   entries, the high one will be multiple levels depending on the size
   of the range and pagesize).

   This may be less common, but I suspect POWER won't be the only
   platform to do something like this.  As above, using a high range
   is a pretty obvious approach, but clearly won't handle older
   devices which can't do 64-bit DMA.  So adding a smaller range for
   those devices is again a pretty obvious solution.  Any platform
   with an "IO hole" can be treated as having two ranges, one below
   the hole and one above it (although in that case they may well not
   have separate page tables=20

4. The translatable ranges might not be fixed.  On ppc that 0..2GiB
   and 2^59..whatever ranges are kernel conventions, not specified by
   the hardware or firmware.  When running as a guest (which is the
   normal case on POWER), there are explicit hypercalls for
   configuring the allowed IOVA windows (along with pagesize, number
   of levels etc.).  At the moment it is fixed in hardware that there
   are only 2 windows, one starting at 0 and one at 2^59 but there's
   no inherent reason those couldn't also be configurable.

   This will probably be rarer, but I wouldn't be surprised if it
   appears on another platform.  If you were designing an IOMMU ASIC
   for use in a variety of platforms, making the base address and size
   of the translatable range(s) configurable in registers would make
   sense.


Now, for (3) and (4), representing lists of windows explicitly in
ioctl()s is likely to be pretty ugly.  We might be able to avoid that,
for at least some of the interfaces, by using the nested IOAS stuff.
One way or another, though, the IOASes which are actually attached to
devices need to represent both windows.

e.g.
Create a "top-level" IOAS <A> representing the device's view.  This
would be either TYPE_KERNEL or maybe a special type.  Into that you'd
make just two iomappings one for each of the translation windows,
pointing to IOASes <B> and <C>.  IOAS <B> and <C> would have a single
window, and would represent the IO page tables for each of the
translation windows.  These could be either TYPE_KERNEL or (say)
TYPE_POWER_TCE for a user managed table.  Well.. in theory, anyway.
The way paravirtualization on POWER is done might mean user managed
tables aren't really possible for other reasons, but that's not
relevant here.

The next problem here is that we don't want userspace to have to do
different things for POWER, at least not for the easy case of a
userspace driver that just wants a chunk of IOVA space and doesn't
really care where it is.

In general I think the right approach to handle that is to
de-emphasize "info" or "query" interfaces.  We'll probably still need
some for debugging and edge cases, but in the normal case userspace
should just specify what it *needs* and (ideally) no more with
optional hints, and the kernel will either supply that or fail.

e.g. A simple userspace driver would simply say "I need an IOAS with
at least 1GiB of IOVA space" and the kernel says "Ok, you can use
2^59..2^59+2GiB".  qemu, emulating the POWER vIOMMU might say "I need
an IOAS with translatable addresses from 0..2GiB with 4kiB page size
and from 2^59..2^59+1TiB with 64kiB page size" and the kernel would
either say "ok", or "I can't do that".

> - Currently ioasid term has already been used in the kernel (drivers/iomm=
u/
>   ioasid.c) to represent the hardware I/O address space ID in the wire. It
>   covers both PCI PASID (Process Address Space ID) and ARM SSID (Sub-Stre=
am
>   ID). We need find a way to resolve the naming conflict between the hard=
ware
>   ID and software handle. One option is to rename the existing ioasid to =
be
>   pasid or ssid, given their full names still sound generic. Appreciate m=
ore
>   thoughts on this open!
>=20
> Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> ---
>  drivers/iommu/iommufd/iommufd.c | 120 ++++++++++++++++++++++++++++++++
>  include/linux/iommufd.h         |   3 +
>  include/uapi/linux/iommu.h      |  54 ++++++++++++++
>  3 files changed, 177 insertions(+)
>=20
> diff --git a/drivers/iommu/iommufd/iommufd.c b/drivers/iommu/iommufd/iomm=
ufd.c
> index 641f199f2d41..4839f128b24a 100644
> --- a/drivers/iommu/iommufd/iommufd.c
> +++ b/drivers/iommu/iommufd/iommufd.c
> @@ -24,6 +24,7 @@
>  struct iommufd_ctx {
>  	refcount_t refs;
>  	struct mutex lock;
> +	struct xarray ioasid_xa; /* xarray of ioasids */
>  	struct xarray device_xa; /* xarray of bound devices */
>  };
> =20
> @@ -42,6 +43,16 @@ struct iommufd_device {
>  	u64 dev_cookie;
>  };
> =20
> +/* Represent an I/O address space */
> +struct iommufd_ioas {
> +	int ioasid;
> +	u32 type;
> +	u32 addr_width;
> +	bool enforce_snoop;
> +	struct iommufd_ctx *ictx;
> +	refcount_t refs;
> +};
> +
>  static int iommufd_fops_open(struct inode *inode, struct file *filep)
>  {
>  	struct iommufd_ctx *ictx;
> @@ -53,6 +64,7 @@ static int iommufd_fops_open(struct inode *inode, struc=
t file *filep)
> =20
>  	refcount_set(&ictx->refs, 1);
>  	mutex_init(&ictx->lock);
> +	xa_init_flags(&ictx->ioasid_xa, XA_FLAGS_ALLOC);
>  	xa_init_flags(&ictx->device_xa, XA_FLAGS_ALLOC);
>  	filep->private_data =3D ictx;
> =20
> @@ -102,16 +114,118 @@ static void iommufd_ctx_put(struct iommufd_ctx *ic=
tx)
>  	if (!refcount_dec_and_test(&ictx->refs))
>  		return;
> =20
> +	WARN_ON(!xa_empty(&ictx->ioasid_xa));
>  	WARN_ON(!xa_empty(&ictx->device_xa));
>  	kfree(ictx);
>  }
> =20
> +/* Caller should hold ictx->lock */
> +static void ioas_put_locked(struct iommufd_ioas *ioas)
> +{
> +	struct iommufd_ctx *ictx =3D ioas->ictx;
> +	int ioasid =3D ioas->ioasid;
> +
> +	if (!refcount_dec_and_test(&ioas->refs))
> +		return;
> +
> +	xa_erase(&ictx->ioasid_xa, ioasid);
> +	iommufd_ctx_put(ictx);
> +	kfree(ioas);
> +}
> +
> +static int iommufd_ioasid_alloc(struct iommufd_ctx *ictx, unsigned long =
arg)
> +{
> +	struct iommu_ioasid_alloc req;
> +	struct iommufd_ioas *ioas;
> +	unsigned long minsz;
> +	int ioasid, ret;
> +
> +	minsz =3D offsetofend(struct iommu_ioasid_alloc, addr_width);
> +
> +	if (copy_from_user(&req, (void __user *)arg, minsz))
> +		return -EFAULT;
> +
> +	if (req.argsz < minsz || !req.addr_width ||
> +	    req.flags !=3D IOMMU_IOASID_ENFORCE_SNOOP ||
> +	    req.type !=3D IOMMU_IOASID_TYPE_KERNEL_TYPE1V2)
> +		return -EINVAL;
> +
> +	ioas =3D kzalloc(sizeof(*ioas), GFP_KERNEL);
> +	if (!ioas)
> +		return -ENOMEM;
> +
> +	mutex_lock(&ictx->lock);
> +	ret =3D xa_alloc(&ictx->ioasid_xa, &ioasid, ioas,
> +		       XA_LIMIT(IOMMUFD_IOASID_MIN, IOMMUFD_IOASID_MAX),
> +		       GFP_KERNEL);
> +	mutex_unlock(&ictx->lock);
> +	if (ret) {
> +		pr_err_ratelimited("Failed to alloc ioasid\n");
> +		kfree(ioas);
> +		return ret;
> +	}
> +
> +	ioas->ioasid =3D ioasid;
> +
> +	/* only supports kernel managed I/O page table so far */
> +	ioas->type =3D IOMMU_IOASID_TYPE_KERNEL_TYPE1V2;
> +
> +	ioas->addr_width =3D req.addr_width;
> +
> +	/* only supports enforce snoop today */
> +	ioas->enforce_snoop =3D true;
> +
> +	iommufd_ctx_get(ictx);
> +	ioas->ictx =3D ictx;
> +
> +	refcount_set(&ioas->refs, 1);
> +
> +	return ioasid;
> +}
> +
> +static int iommufd_ioasid_free(struct iommufd_ctx *ictx, unsigned long a=
rg)
> +{
> +	struct iommufd_ioas *ioas =3D NULL;
> +	int ioasid, ret;
> +
> +	if (copy_from_user(&ioasid, (void __user *)arg, sizeof(ioasid)))
> +		return -EFAULT;
> +
> +	if (ioasid < 0)
> +		return -EINVAL;
> +
> +	mutex_lock(&ictx->lock);
> +	ioas =3D xa_load(&ictx->ioasid_xa, ioasid);
> +	if (IS_ERR(ioas)) {
> +		ret =3D -EINVAL;
> +		goto out_unlock;
> +	}
> +
> +	/* Disallow free if refcount is not 1 */
> +	if (refcount_read(&ioas->refs) > 1) {
> +		ret =3D -EBUSY;
> +		goto out_unlock;
> +	}
> +
> +	ioas_put_locked(ioas);
> +out_unlock:
> +	mutex_unlock(&ictx->lock);
> +	return ret;
> +};
> +
>  static int iommufd_fops_release(struct inode *inode, struct file *filep)
>  {
>  	struct iommufd_ctx *ictx =3D filep->private_data;
> +	struct iommufd_ioas *ioas;
> +	unsigned long index;
> =20
>  	filep->private_data =3D NULL;
> =20
> +	mutex_lock(&ictx->lock);
> +	xa_for_each(&ictx->ioasid_xa, index, ioas)
> +		ioas_put_locked(ioas);
> +	mutex_unlock(&ictx->lock);
> +
>  	iommufd_ctx_put(ictx);
> =20
>  	return 0;
> @@ -195,6 +309,12 @@ static long iommufd_fops_unl_ioctl(struct file *file=
p,
>  	case IOMMU_DEVICE_GET_INFO:
>  		ret =3D iommufd_get_device_info(ictx, arg);
>  		break;
> +	case IOMMU_IOASID_ALLOC:
> +		ret =3D iommufd_ioasid_alloc(ictx, arg);
> +		break;
> +	case IOMMU_IOASID_FREE:
> +		ret =3D iommufd_ioasid_free(ictx, arg);
> +		break;
>  	default:
>  		pr_err_ratelimited("unsupported cmd %u\n", cmd);
>  		break;
> diff --git a/include/linux/iommufd.h b/include/linux/iommufd.h
> index 1603a13937e9..1dd6515e7816 100644
> --- a/include/linux/iommufd.h
> +++ b/include/linux/iommufd.h
> @@ -14,6 +14,9 @@
>  #include <linux/err.h>
>  #include <linux/device.h>
> =20
> +#define IOMMUFD_IOASID_MAX	((unsigned int)(0x7FFFFFFF))
> +#define IOMMUFD_IOASID_MIN	0
> +
>  #define IOMMUFD_DEVID_MAX	((unsigned int)(0x7FFFFFFF))
>  #define IOMMUFD_DEVID_MIN	0
> =20
> diff --git a/include/uapi/linux/iommu.h b/include/uapi/linux/iommu.h
> index 76b71f9d6b34..5cbd300eb0ee 100644
> --- a/include/uapi/linux/iommu.h
> +++ b/include/uapi/linux/iommu.h
> @@ -57,6 +57,60 @@ struct iommu_device_info {
> =20
>  #define IOMMU_DEVICE_GET_INFO	_IO(IOMMU_TYPE, IOMMU_BASE + 1)
> =20
> +/*
> + * IOMMU_IOASID_ALLOC	- _IOWR(IOMMU_TYPE, IOMMU_BASE + 2,
> + *				struct iommu_ioasid_alloc)
> + *
> + * Allocate an IOASID.
> + *
> + * IOASID is the FD-local software handle representing an I/O address
> + * space. Each IOASID is associated with a single I/O page table. User
> + * must call this ioctl to get an IOASID for every I/O address space
> + * that is intended to be tracked by the kernel.
> + *
> + * User needs to specify the attributes of the IOASID and associated
> + * I/O page table format information according to one or multiple devices
> + * which will be attached to this IOASID right after. The I/O page table
> + * is activated in the IOMMU when it's attached by a device. Incompatible
> + * format between device and IOASID will lead to attaching failure in
> + * device side.
> + *
> + * Currently only one flag (IOMMU_IOASID_ENFORCE_SNOOP) is supported and
> + * must be always set.
> + *
> + * Only one I/O page table type (kernel-managed) is supported, with vfio
> + * type1v2 mapping semantics.
> + *
> + * User should call IOMMU_CHECK_EXTENSION for future extensions.
> + *
> + * @argsz:	    user filled size of this data.
> + * @flags:	    additional information for IOASID allocation.
> + * @type:	    I/O address space page table type.
> + * @addr_width:    address width of the I/O address space.
> + *
> + * Return: allocated ioasid on success, -errno on failure.
> + */
> +struct iommu_ioasid_alloc {
> +	__u32	argsz;
> +	__u32	flags;
> +#define IOMMU_IOASID_ENFORCE_SNOOP	(1 << 0)
> +	__u32	type;
> +#define IOMMU_IOASID_TYPE_KERNEL_TYPE1V2	1
> +	__u32	addr_width;
> +};
> +
> +#define IOMMU_IOASID_ALLOC		_IO(IOMMU_TYPE, IOMMU_BASE + 2)
> +
> +/**
> + * IOMMU_IOASID_FREE - _IOWR(IOMMU_TYPE, IOMMU_BASE + 3, int)
> + *
> + * Free an IOASID.
> + *
> + * returns: 0 on success, -errno on failure
> + */
> +
> +#define IOMMU_IOASID_FREE		_IO(IOMMU_TYPE, IOMMU_BASE + 3)
> +
>  #define IOMMU_FAULT_PERM_READ	(1 << 0) /* read */
>  #define IOMMU_FAULT_PERM_WRITE	(1 << 1) /* write */
>  #define IOMMU_FAULT_PERM_EXEC	(1 << 2) /* exec */

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--emeUklQwaw/5Jbba
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIyBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAmFWpoAACgkQbDjKyiDZ
s5KAag/yAoYoDdwVglF9/hA+gs1yNHBnEodRj4fXPKdOeR3UFQhvqiYpsHskHG6+
37zal7BDrh4uRh3rvISQoWa5Q97nIjw8rXVrSd8Us/PD2RP3SE9H2tGuntz0lzuV
Pps4kWauTm/DBKX3YYFpbWmMBHijUNA7fihgx4W+I9eYefYLYxnbb4z7yrs1nxCq
lq99qVWKQEID6r32FqJGGl37GSIsqwdXdDB6EbpimtbpICRux3xvxqidZkBPFCNv
2KI5eUA0pUGNF6bbCH1xdTFnGwHmukHkvxrOGdgmfGOI6cN97V5cxsDDKCzLkVit
Byr/mWyG11hqaFXNmxAamyd4YcX0xx1uf6o2Wol5a1/zV0SUE9S+NgPlIti/i6UU
Tx9jhSUvdl9KBC1HUYg1+4acJc8dX0PUSZdQI6FT9fqWBywbCqK5rU0R2Ekwn64F
DtqHMDIN3FK0FMvvO5I+fYSMTEhTi4qBqC6neyTIzjYI2uzFbdks1DI4kxzYAoKq
q81vzXeO8BifZqgUXg9DB2VnzYOgXqnUj+SoWI7hnrKZfLbbDjq20RTafm6TJvDf
Ja+zg7cFf9oTFKkVdkNxej6vmZaMVO5I1iGCzoMn39zoO2rannO1CfULfpc1LbAs
RDsvVT9E75rooh4rujJgCESvAnvF5Fti+G8XkmKh6yN83oyhgQ==
=WQqD
-----END PGP SIGNATURE-----

--emeUklQwaw/5Jbba--
