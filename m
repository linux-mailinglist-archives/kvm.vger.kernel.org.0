Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C847AF9711
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2019 18:25:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726979AbfKLRZ4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Nov 2019 12:25:56 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:30037 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726958AbfKLRZ4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Nov 2019 12:25:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573579554;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RgNm5vGJQ9dRe37oDh+EYyVmulqOmkZWRS+WQ/0s2fI=;
        b=QX+wvMRM7em+kVUOSxsFaboNuq1d0VeR/KOlWLRkABMx9fU3FJFZbSccD1U16q9GY6/6By
        AjmYuzk5es5BPMBGtivxDEXyGOBzVyuxv9Wy6XjKycS5nHNFkoLRoKWju749TDoi6dbCMw
        85JT9nz2EKzqnjGBCC/VgwYAwqGxLxc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-297-GPS7cFSANueYBwKZXvK8mA-1; Tue, 12 Nov 2019 12:25:47 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 193581938923;
        Tue, 12 Nov 2019 17:25:46 +0000 (UTC)
Received: from x1.home (ovpn-116-138.phx2.redhat.com [10.3.116.138])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 28C636046C;
        Tue, 12 Nov 2019 17:25:35 +0000 (UTC)
Date:   Tue, 12 Nov 2019 10:25:34 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "jean-philippe.brucker@arm.com" <jean-philippe.brucker@arm.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Lu, Baolu" <baolu.lu@intel.com>, "Wu, Hao" <hao.wu@intel.com>
Subject: Re: [RFC v2 3/3] vfio/type1: bind guest pasid (guest page tables)
 to host
Message-ID: <20191112102534.75968ccd@x1.home>
In-Reply-To: <A2975661238FB949B60364EF0F2C25743A0F6894@SHSMSX104.ccr.corp.intel.com>
References: <1571919983-3231-1-git-send-email-yi.l.liu@intel.com>
        <1571919983-3231-4-git-send-email-yi.l.liu@intel.com>
        <20191107162041.31e620a4@x1.home>
        <A2975661238FB949B60364EF0F2C25743A0F6894@SHSMSX104.ccr.corp.intel.com>
Organization: Red Hat
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: GPS7cFSANueYBwKZXvK8mA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 12 Nov 2019 11:21:40 +0000
"Liu, Yi L" <yi.l.liu@intel.com> wrote:

> > From: Alex Williamson < alex.williamson@redhat.com >
> > Sent: Friday, November 8, 2019 7:21 AM
> > To: Liu, Yi L <yi.l.liu@intel.com>
> > Subject: Re: [RFC v2 3/3] vfio/type1: bind guest pasid (guest page tabl=
es) to host
> >=20
> > On Thu, 24 Oct 2019 08:26:23 -0400
> > Liu Yi L <yi.l.liu@intel.com> wrote:
> >  =20
> > > This patch adds vfio support to bind guest translation structure
> > > to host iommu. VFIO exposes iommu programming capability to user-
> > > space. Guest is a user-space application in host under KVM solution.
> > > For SVA usage in Virtual Machine, guest owns GVA->GPA translation
> > > structure. And this part should be passdown to host to enable nested
> > > translation (or say two stage translation). This patch reuses the
> > > VFIO_IOMMU_BIND proposal from Jean-Philippe Brucker, and adds new
> > > bind type for binding guest owned translation structure to host.
> > >
> > > *) Add two new ioctls for VFIO containers.
> > >
> > >   - VFIO_IOMMU_BIND: for bind request from userspace, it could be
> > >                    bind a process to a pasid or bind a guest pasid
> > >                    to a device, this is indicated by type
> > >   - VFIO_IOMMU_UNBIND: for unbind request from userspace, it could be
> > >                    unbind a process to a pasid or unbind a guest pasi=
d
> > >                    to a device, also indicated by type
> > >   - Bind type:
> > > =09VFIO_IOMMU_BIND_PROCESS: user-space request to bind a process
> > >                    to a device
> > > =09VFIO_IOMMU_BIND_GUEST_PASID: bind guest owned translation
> > >                    structure to host iommu. e.g. guest page table
> > >
> > > *) Code logic in vfio_iommu_type1_ioctl() to handle VFIO_IOMMU_BIND/U=
NBIND
> > >
> > > Cc: Kevin Tian <kevin.tian@intel.com>
> > > Signed-off-by: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
> > > Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> > > Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
> > > ---
> > >  drivers/vfio/vfio_iommu_type1.c | 136 =20
> > ++++++++++++++++++++++++++++++++++++++++ =20
> > >  include/uapi/linux/vfio.h       |  44 +++++++++++++
> > >  2 files changed, 180 insertions(+)
> > >
> > > diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iomm=
u_type1.c
> > > index 3d73a7d..1a27e25 100644
> > > --- a/drivers/vfio/vfio_iommu_type1.c
> > > +++ b/drivers/vfio/vfio_iommu_type1.c
> > > @@ -2325,6 +2325,104 @@ static int vfio_iommu_type1_pasid_free(struct=
 =20
> > vfio_iommu *iommu, =20
> > >  =09return ret;
> > >  }
> > >
> > > +static int vfio_bind_gpasid_fn(struct device *dev, void *data)
> > > +{
> > > +=09struct domain_capsule *dc =3D (struct domain_capsule *)data;
> > > +=09struct iommu_gpasid_bind_data *ustruct =3D
> > > +=09=09(struct iommu_gpasid_bind_data *) dc->data;
> > > +
> > > +=09return iommu_sva_bind_gpasid(dc->domain, dev, ustruct);
> > > +}
> > > +
> > > +static int vfio_unbind_gpasid_fn(struct device *dev, void *data)
> > > +{
> > > +=09struct domain_capsule *dc =3D (struct domain_capsule *)data;
> > > +=09struct iommu_gpasid_bind_data *ustruct =3D
> > > +=09=09(struct iommu_gpasid_bind_data *) dc->data;
> > > +
> > > +=09return iommu_sva_unbind_gpasid(dc->domain, dev,
> > > +=09=09=09=09=09=09ustruct->hpasid);
> > > +}
> > > +
> > > +/*
> > > + * unbind specific gpasid, caller of this function requires hold
> > > + * vfio_iommu->lock
> > > + */
> > > +static long vfio_iommu_type1_do_guest_unbind(struct vfio_iommu *iomm=
u,
> > > +=09=09  struct iommu_gpasid_bind_data *gbind_data)
> > > +{
> > > +=09return vfio_iommu_lookup_dev(iommu, vfio_unbind_gpasid_fn, gbind_=
data);
> > > +}
> > > +
> > > +static long vfio_iommu_type1_bind_gpasid(struct vfio_iommu *iommu,
> > > +=09=09=09=09=09    void __user *arg,
> > > +=09=09=09=09=09    struct vfio_iommu_type1_bind *bind)
> > > +{
> > > +=09struct iommu_gpasid_bind_data gbind_data;
> > > +=09unsigned long minsz;
> > > +=09int ret =3D 0;
> > > +
> > > +=09minsz =3D sizeof(*bind) + sizeof(gbind_data);
> > > +=09if (bind->argsz < minsz)
> > > +=09=09return -EINVAL;
> > > +
> > > +=09if (copy_from_user(&gbind_data, arg, sizeof(gbind_data)))
> > > +=09=09return -EFAULT;
> > > +
> > > +=09mutex_lock(&iommu->lock);
> > > +=09if (!IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu)) {
> > > +=09=09ret =3D -EINVAL;
> > > +=09=09goto out_unlock;
> > > +=09}
> > > +
> > > +=09ret =3D vfio_iommu_lookup_dev(iommu, vfio_bind_gpasid_fn, &gbind_=
data);
> > > +=09/*
> > > +=09 * If bind failed, it may not be a total failure. Some devices wi=
thin
> > > +=09 * the iommu group may have bind successfully. Although we don't =
enable
> > > +=09 * pasid capability for non-singletion iommu groups, a unbind ope=
ration
> > > +=09 * would be helpful to ensure no partial binding for an iommu gro=
up.
> > > +=09 */
> > > +=09if (ret)
> > > +=09=09/*
> > > +=09=09 * Undo all binds that already succeeded, no need to check the
> > > +=09=09 * return value here since some device within the group has no
> > > +=09=09 * successful bind when coming to this place switch.
> > > +=09=09 */
> > > +=09=09vfio_iommu_type1_do_guest_unbind(iommu, &gbind_data);
> > > +
> > > +out_unlock:
> > > +=09mutex_unlock(&iommu->lock);
> > > +=09return ret;
> > > +}
> > > +
> > > +static long vfio_iommu_type1_unbind_gpasid(struct vfio_iommu *iommu,
> > > +=09=09=09=09=09    void __user *arg,
> > > +=09=09=09=09=09    struct vfio_iommu_type1_bind *bind)
> > > +{
> > > +=09struct iommu_gpasid_bind_data gbind_data;
> > > +=09unsigned long minsz;
> > > +=09int ret =3D 0;
> > > +
> > > +=09minsz =3D sizeof(*bind) + sizeof(gbind_data);
> > > +=09if (bind->argsz < minsz)
> > > +=09=09return -EINVAL; =20
> >=20
> > But gbind_data can change size if new vendor specific data is added to
> > the union, so kernel updates break existing userspace.  Fail. =20
>=20
> yes, we have a version field in struct iommu_gpasid_bind_data. How
> about doing sanity check per versions? kernel knows the gbind_data
> size of specific versions. Does it make sense? If yes, I'll also apply it
> to the other sanity check in this series to avoid userspace fail after
> kernel update.

Has it already been decided that the version field will be updated for
every addition to the union?  It seems there are two options, either
the version definition includes the possible contents of the union,
which means we need to support multiple versions concurrently in the
kernel to maintain compatibility with userspace and follow deprecation
protocols for removing that support, or we need to consider version to
be the general form of the structure and interpret the format field to
determine necessary length to copy from the user.

> > > +
> > > +=09if (copy_from_user(&gbind_data, arg, sizeof(gbind_data)))
> > > +=09=09return -EFAULT;
> > > +
> > > +=09mutex_lock(&iommu->lock);
> > > +=09if (!IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu)) {
> > > +=09=09ret =3D -EINVAL;
> > > +=09=09goto out_unlock;
> > > +=09}
> > > +
> > > +=09ret =3D vfio_iommu_type1_do_guest_unbind(iommu, &gbind_data);
> > > +
> > > +out_unlock:
> > > +=09mutex_unlock(&iommu->lock);
> > > +=09return ret;
> > > +}
> > > +
> > >  static long vfio_iommu_type1_ioctl(void *iommu_data,
> > >  =09=09=09=09   unsigned int cmd, unsigned long arg)
> > >  {
> > > @@ -2484,6 +2582,44 @@ static long vfio_iommu_type1_ioctl(void *iommu=
_data,
> > >  =09=09default:
> > >  =09=09=09return -EINVAL;
> > >  =09=09}
> > > +
> > > +=09} else if (cmd =3D=3D VFIO_IOMMU_BIND) {
> > > +=09=09struct vfio_iommu_type1_bind bind;
> > > +
> > > +=09=09minsz =3D offsetofend(struct vfio_iommu_type1_bind, bind_type)=
;
> > > +
> > > +=09=09if (copy_from_user(&bind, (void __user *)arg, minsz))
> > > +=09=09=09return -EFAULT;
> > > +
> > > +=09=09if (bind.argsz < minsz)
> > > +=09=09=09return -EINVAL;
> > > +
> > > +=09=09switch (bind.bind_type) {
> > > +=09=09case VFIO_IOMMU_BIND_GUEST_PASID:
> > > +=09=09=09return vfio_iommu_type1_bind_gpasid(iommu,
> > > +=09=09=09=09=09(void __user *)(arg + minsz), &bind); =20
> >=20
> > Why are we defining BIND_PROCESS if it's not supported?  How does the
> > user learn it's not supported? =20
>=20
> I think I should drop it so far since I only add BIND_GUEST_PASID. I thin=
k
> Jean Philippe may need it in his native SVA enabling patchset. For the wa=
y
> to let user learn it, may be using VFIO_IOMMU_GET_INFO as you mentioned
> below?
>=20
> >  =20
> > > +=09=09default:
> > > +=09=09=09return -EINVAL;
> > > +=09=09}
> > > +
> > > +=09} else if (cmd =3D=3D VFIO_IOMMU_UNBIND) {
> > > +=09=09struct vfio_iommu_type1_bind bind;
> > > +
> > > +=09=09minsz =3D offsetofend(struct vfio_iommu_type1_bind, bind_type)=
;
> > > +
> > > +=09=09if (copy_from_user(&bind, (void __user *)arg, minsz))
> > > +=09=09=09return -EFAULT;
> > > +
> > > +=09=09if (bind.argsz < minsz)
> > > +=09=09=09return -EINVAL;
> > > +
> > > +=09=09switch (bind.bind_type) {
> > > +=09=09case VFIO_IOMMU_BIND_GUEST_PASID:
> > > +=09=09=09return vfio_iommu_type1_unbind_gpasid(iommu,
> > > +=09=09=09=09=09(void __user *)(arg + minsz), &bind);
> > > +=09=09default:
> > > +=09=09=09return -EINVAL;
> > > +=09=09}
> > >  =09}
> > >
> > >  =09return -ENOTTY;
> > > diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> > > index 04de290..78e8c64 100644
> > > --- a/include/uapi/linux/vfio.h
> > > +++ b/include/uapi/linux/vfio.h
> > > @@ -832,6 +832,50 @@ struct vfio_iommu_type1_pasid_request {
> > >   */
> > >  #define VFIO_IOMMU_PASID_REQUEST=09_IO(VFIO_TYPE, VFIO_BASE + 27)
> > >
> > > +enum vfio_iommu_bind_type {
> > > +=09VFIO_IOMMU_BIND_PROCESS,
> > > +=09VFIO_IOMMU_BIND_GUEST_PASID,
> > > +};
> > > +
> > > +/*
> > > + * Supported types:
> > > + *=09- VFIO_IOMMU_BIND_GUEST_PASID: bind guest pasid, which invoked
> > > + *=09=09=09by guest, it takes iommu_gpasid_bind_data in data.
> > > + */
> > > +struct vfio_iommu_type1_bind {
> > > +=09__u32=09=09=09=09argsz;
> > > +=09enum vfio_iommu_bind_type=09bind_type;
> > > +=09__u8=09=09=09=09data[];
> > > +}; =20
> >=20
> > I don't think enum defines a compiler invariant data size.  We can't
> > use it for a kernel/user interface.  Also why no flags field as is
> > essentially standard for every vfio ioctl?  Couldn't we specify
> > process/guest-pasid with flags? =20
>=20
> I remember there is an early comment in community which pointed out
> that using flags potentially allows to config multiples types in one IOCT=
L.
> Regards to it, defining explicit emums avoids it. But I agree with you,
> it makes variant size. I'll fix it if this matter more.
>=20
> > For that matter couldn't we specify
> > bind/unbind using a single ioctl?  I think that would be more
> > consistent with the pasid alloc/free ioctl in the previous patch. =20
>=20
> yes, let me make it in next version.
>=20
> > Why are we appending opaque data to the end of the structure when
> > clearly we expect a struct iommu_gpasid_bind_data? =20
>=20
> This is due to the intention to support BIND_GUEST_PASID and
> BIND_PROCESS with a single IOCTL. Maybe we can use a separate
> IOCTL for BIND_PROCESS. what's your opinion here?

If the ioctls have similar purpose and form, then re-using a single
ioctl might make sense, but BIND_PROCESS is only a place-holder in this
series, which is not acceptable.  A dual purpose ioctl does not
preclude that we could also use a union for the data field to make the
structure well specified.
=20
> > That bind data
> > structure expects a format (ex. IOMMU_PASID_FORMAT_INTEL_VTD).  How doe=
s
> > a user determine what formats are accepted from within the vfio API (or
> > even outside of the vfio API)? =20
>=20
> The info is provided by vIOMMU emulator (e.g. virtual VT-d). The vSVA pat=
ch
> from Jacob has a sanity check on it.
> https://lkml.org/lkml/2019/10/28/873

The vIOMMU emulator runs at a layer above vfio.  How does the vIOMMU
emulator know that the vfio interface supports virtual VT-d?  IMO, it's
not acceptable that the user simply assume that an Intel host platform
supports VT-d.  For example, consider what happens when we need to
define IOMMU_PASID_FORMAT_INTEL_VTDv2.  How would the user learn that
VTDv2 is supported and the original VTD format is not supported?

> > > +
> > > +/*
> > > + * VFIO_IOMMU_BIND - _IOWR(VFIO_TYPE, VFIO_BASE + 28, struct =20
> > vfio_iommu_bind)
> >                             ^
> > The semantics appear to just be _IOW, nothing is written back to the
> > userspace buffer on return. =20
>=20
> will fix it. thanks.
>=20
> > > + *
> > > + * Manage address spaces of devices in this container. Initially a T=
YPE1
> > > + * container can only have one address space, managed with
> > > + * VFIO_IOMMU_MAP/UNMAP_DMA.
> > > + *
> > > + * An IOMMU of type VFIO_TYPE1_NESTING_IOMMU can be managed by both =
=20
> > MAP/UNMAP =20
> > > + * and BIND ioctls at the same time. MAP/UNMAP acts on the stage-2 (=
host) page
> > > + * tables, and BIND manages the stage-1 (guest) page tables. Other t=
ypes of
> > > + * IOMMU may allow MAP/UNMAP and BIND to coexist, where MAP/UNMAP =
=20
> > controls =20
> > > + * non-PASID traffic and BIND controls PASID traffic. But this depen=
ds on the
> > > + * underlying IOMMU architecture and isn't guaranteed.
> > > + *
> > > + * Availability of this feature depends on the device, its bus, the =
underlying
> > > + * IOMMU and the CPU architecture. =20
> >=20
> > And the user discovers this is available by...?  There's no probe here,
> > are they left only to setup a VM to the point of trying to use this
> > before they fail the ioctl?  Could VFIO_IOMMU_GET_INFO fill this gap?
> > Thanks, =20
>=20
> I think VFIO_IOMMU_GET_INFO could help. let me extend it to fill this gap
> if you agree.

It's a start.  Thanks,

Alex

