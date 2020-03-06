Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2599A17C1FD
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2020 16:39:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727146AbgCFPjS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Mar 2020 10:39:18 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:44283 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726237AbgCFPjR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Mar 2020 10:39:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583509155;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3xtxih/bq+8b0V3y0yN1D6C2FJxTFJSZm/+YuuYZmEU=;
        b=Wx3ZSRg2U07Q5NCQ5XRo9Vtf8gwSY+IQcO+ZFMm4XAM+IEgL1BMa+IzCBjdjaA9SJad9bp
        jwk9REHxFs4nwWfvD/QelR5vt6Sw2V24CoMwsxGCKUvt6wOKZ2bDM5rHz3SG3l26r+IGWf
        CYBlFt1ISPYLHzFyGYJn9xS1PNnyS9k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-139-HbF-MofLPFegstdgg-TM5g-1; Fri, 06 Mar 2020 10:39:11 -0500
X-MC-Unique: HbF-MofLPFegstdgg-TM5g-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 236478010FF;
        Fri,  6 Mar 2020 15:39:09 +0000 (UTC)
Received: from x1.home (ovpn-116-28.phx2.redhat.com [10.3.116.28])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 949577389A;
        Fri,  6 Mar 2020 15:39:07 +0000 (UTC)
Date:   Fri, 6 Mar 2020 08:39:06 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dev@dpdk.org" <dev@dpdk.org>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "thomas@monjalon.net" <thomas@monjalon.net>,
        "bluca@debian.org" <bluca@debian.org>,
        "jerinjacobk@gmail.com" <jerinjacobk@gmail.com>,
        "Richardson, Bruce" <bruce.richardson@intel.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>
Subject: Re: [PATCH v2 3/7] vfio/pci: Introduce VF token
Message-ID: <20200306083906.13c9a762@x1.home>
In-Reply-To: <AADFC41AFE54684AB9EE6CBC0274A5D19D7C084D@SHSMSX104.ccr.corp.intel.com>
References: <158213716959.17090.8399427017403507114.stgit@gimli.home>
        <158213845243.17090.15563257812711358228.stgit@gimli.home>
        <AADFC41AFE54684AB9EE6CBC0274A5D19D79A904@SHSMSX104.ccr.corp.intel.com>
        <20200305111734.4025ce2f@w520.home>
        <AADFC41AFE54684AB9EE6CBC0274A5D19D7C084D@SHSMSX104.ccr.corp.intel.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 6 Mar 2020 08:32:40 +0000
"Tian, Kevin" <kevin.tian@intel.com> wrote:

> > From: Alex Williamson <alex.williamson@redhat.com>
> > Sent: Friday, March 6, 2020 2:18 AM
> >=20
> > On Tue, 25 Feb 2020 02:59:37 +0000
> > "Tian, Kevin" <kevin.tian@intel.com> wrote:
> >  =20
> > > > From: Alex Williamson
> > > > Sent: Thursday, February 20, 2020 2:54 AM
> > > >
> > > > If we enable SR-IOV on a vfio-pci owned PF, the resulting VFs are n=
ot
> > > > fully isolated from the PF.  The PF can always cause a denial of se=
rvice
> > > > to the VF, even if by simply resetting itself.  The degree to which=
 a PF
> > > > can access the data passed through a VF or interfere with its opera=
tion
> > > > is dependent on a given SR-IOV implementation.  Therefore we want to
> > > > avoid a scenario where an existing vfio-pci based userspace driver =
might
> > > > assume the PF driver is trusted, for example assigning a PF to one =
VM
> > > > and VF to another with some expectation of isolation.  IOMMU groupi=
ng
> > > > could be a solution to this, but imposes an unnecessarily strong
> > > > relationship between PF and VF drivers if they need to operate with=
 the
> > > > same IOMMU context.  Instead we introduce a "VF token", which is
> > > > essentially just a shared secret between PF and VF drivers, impleme=
nted
> > > > as a UUID.
> > > >
> > > > The VF token can be set by a vfio-pci based PF driver and must be k=
nown
> > > > by the vfio-pci based VF driver in order to gain access to the devi=
ce.
> > > > This allows the degree to which this VF token is considered secret =
to be
> > > > determined by the applications and environment.  For example a VM =
=20
> > might =20
> > > > generate a random UUID known only internally to the hypervisor whil=
e a
> > > > userspace networking appliance might use a shared, or even well kno=
w,
> > > > UUID among the application drivers.
> > > >
> > > > To incorporate this VF token, the VFIO_GROUP_GET_DEVICE_FD interfac=
e =20
> > is =20
> > > > extended to accept key=3Dvalue pairs in addition to the device name=
.  This
> > > > allows us to most easily deny user access to the device without risk
> > > > that existing userspace drivers assume region offsets, IRQs, and ot=
her
> > > > device features, leading to more elaborate error paths.  The format=
 of
> > > > these options are expected to take the form:
> > > >
> > > > "$DEVICE_NAME $OPTION1=3D$VALUE1 $OPTION2=3D$VALUE2"
> > > >
> > > > Where the device name is always provided first for compatibility and
> > > > additional options are specified in a space separated list.  The
> > > > relation between and requirements for the additional options will be
> > > > vfio bus driver dependent, however unknown or unused option within =
=20
> > this =20
> > > > schema should return error.  This allow for future use of unknown
> > > > options as well as a positive indication to the user that an option=
 is
> > > > used.
> > > >
> > > > An example VF token option would take this form:
> > > >
> > > > "0000:03:00.0 vf_token=3D2ab74924-c335-45f4-9b16-8569e5b08258"
> > > >
> > > > When accessing a VF where the PF is making use of vfio-pci, the user
> > > > MUST provide the current vf_token.  When accessing a PF, the user M=
UST
> > > > provide the current vf_token IF there are active VF users or MAY pr=
ovide
> > > > a vf_token in order to set the current VF token when no VF users are
> > > > active.  The former requirement assures VF users that an unassociat=
ed
> > > > driver cannot usurp the PF device.  These semantics also imply that=
 a
> > > > VF token MUST be set by a PF driver before VF drivers can access th=
eir
> > > > device, the default token is random and mechanisms to read the toke=
n =20
> > are =20
> > > > not provided in order to protect the VF token of previous users.  U=
se of
> > > > the vf_token option outside of these cases will return an error, as
> > > > discussed above.
> > > >
> > > > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> > > > ---
> > > >  drivers/vfio/pci/vfio_pci.c         |  198
> > > > +++++++++++++++++++++++++++++++++++
> > > >  drivers/vfio/pci/vfio_pci_private.h |    8 +
> > > >  2 files changed, 205 insertions(+), 1 deletion(-)
> > > >
> > > > diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pc=
i.c
> > > > index 2ec6c31d0ab0..8dd6ef9543ca 100644
> > > > --- a/drivers/vfio/pci/vfio_pci.c
> > > > +++ b/drivers/vfio/pci/vfio_pci.c
> > > > @@ -466,6 +466,44 @@ static void vfio_pci_disable(struct =20
> > vfio_pci_device =20
> > > > *vdev)
> > > >  		vfio_pci_set_power_state(vdev, PCI_D3hot);
> > > >  }
> > > >
> > > > +static struct pci_driver vfio_pci_driver;
> > > > +
> > > > +static struct vfio_pci_device *get_pf_vdev(struct vfio_pci_device =
*vdev,
> > > > +					   struct vfio_device **pf_dev)
> > > > +{
> > > > +	struct pci_dev *physfn =3D pci_physfn(vdev->pdev);
> > > > +
> > > > +	if (!vdev->pdev->is_virtfn)
> > > > +		return NULL;
> > > > +
> > > > +	*pf_dev =3D vfio_device_get_from_dev(&physfn->dev);
> > > > +	if (!*pf_dev)
> > > > +		return NULL;
> > > > +
> > > > +	if (pci_dev_driver(physfn) !=3D &vfio_pci_driver) {
> > > > +		vfio_device_put(*pf_dev);
> > > > +		return NULL;
> > > > +	}
> > > > +
> > > > +	return vfio_device_data(*pf_dev);
> > > > +}
> > > > +
> > > > +static void vfio_pci_vf_token_user_add(struct vfio_pci_device *vde=
v, int =20
> > val) =20
> > > > +{
> > > > +	struct vfio_device *pf_dev;
> > > > +	struct vfio_pci_device *pf_vdev =3D get_pf_vdev(vdev, &pf_dev);
> > > > +
> > > > +	if (!pf_vdev)
> > > > +		return;
> > > > +
> > > > +	mutex_lock(&pf_vdev->vf_token->lock);
> > > > +	pf_vdev->vf_token->users +=3D val;
> > > > +	WARN_ON(pf_vdev->vf_token->users < 0);
> > > > +	mutex_unlock(&pf_vdev->vf_token->lock);
> > > > +
> > > > +	vfio_device_put(pf_dev);
> > > > +}
> > > > +
> > > >  static void vfio_pci_release(void *device_data)
> > > >  {
> > > >  	struct vfio_pci_device *vdev =3D device_data;
> > > > @@ -473,6 +511,7 @@ static void vfio_pci_release(void *device_data)
> > > >  	mutex_lock(&vdev->reflck->lock);
> > > >
> > > >  	if (!(--vdev->refcnt)) {
> > > > +		vfio_pci_vf_token_user_add(vdev, -1);
> > > >  		vfio_spapr_pci_eeh_release(vdev->pdev);
> > > >  		vfio_pci_disable(vdev);
> > > >  	}
> > > > @@ -498,6 +537,7 @@ static int vfio_pci_open(void *device_data)
> > > >  			goto error;
> > > >
> > > >  		vfio_spapr_pci_eeh_open(vdev->pdev);
> > > > +		vfio_pci_vf_token_user_add(vdev, 1);
> > > >  	}
> > > >  	vdev->refcnt++;
> > > >  error:
> > > > @@ -1278,11 +1318,148 @@ static void vfio_pci_request(void =20
> > *device_data, =20
> > > > unsigned int count)
> > > >  	mutex_unlock(&vdev->igate);
> > > >  }
> > > >
> > > > +static int vfio_pci_validate_vf_token(struct vfio_pci_device *vdev,
> > > > +				      bool vf_token, uuid_t *uuid)
> > > > +{
> > > > +	/*
> > > > +	 * There's always some degree of trust or collaboration between S=
R-
> > > > IOV
> > > > +	 * PF and VFs, even if just that the PF hosts the SR-IOV capabili=
ty and
> > > > +	 * can disrupt VFs with a reset, but often the PF has more explic=
it
> > > > +	 * access to deny service to the VF or access data passed through=
 the
> > > > +	 * VF.  We therefore require an opt-in via a shared VF token (UUI=
D)
> > > > to
> > > > +	 * represent this trust.  This both prevents that a VF driver mig=
ht
> > > > +	 * assume the PF driver is a trusted, in-kernel driver, and also =
that
> > > > +	 * a PF driver might be replaced with a rogue driver, unknown to =
in-
> > > > use
> > > > +	 * VF drivers.
> > > > +	 *
> > > > +	 * Therefore when presented with a VF, if the PF is a vfio device=
 and
> > > > +	 * it is bound to the vfio-pci driver, the user needs to provide =
a VF
> > > > +	 * token to access the device, in the form of appending a vf_toke=
n to
> > > > +	 * the device name, for example:
> > > > +	 *
> > > > +	 * "0000:04:10.0 vf_token=3Dbd8d9d2b-5a5f-4f5a-a211-f591514ba1f3"
> > > > +	 *
> > > > +	 * When presented with a PF which has VFs in use, the user must a=
lso
> > > > +	 * provide the current VF token to prove collaboration with exist=
ing
> > > > +	 * VF users.  If VFs are not in use, the VF token provided for th=
e PF
> > > > +	 * device will act to set the VF token.
> > > > +	 *
> > > > +	 * If the VF token is provided but unused, a fault is generated. =
=20
> > >
> > > fault->error, otherwise it is easy to consider a CPU fault. =F0=9F=98=
=8A =20
> >=20
> > Ok, I can make that change, but I think you might have a unique
> > background to make a leap that a userspace ioctl can trigger a CPU
> > fault ;)
> >  =20
> > > > +	 */
> > > > +	if (!vdev->pdev->is_virtfn && !vdev->vf_token && !vf_token)
> > > > +		return 0; /* No VF token provided or required */
> > > > +
> > > > +	if (vdev->pdev->is_virtfn) {
> > > > +		struct vfio_device *pf_dev;
> > > > +		struct vfio_pci_device *pf_vdev =3D get_pf_vdev(vdev,
> > > > &pf_dev);
> > > > +		bool match;
> > > > +
> > > > +		if (!pf_vdev) {
> > > > +			if (!vf_token)
> > > > +				return 0; /* PF is not vfio-pci, no VF token */
> > > > +
> > > > +			pci_info_ratelimited(vdev->pdev,
> > > > +				"VF token incorrectly provided, PF not bound
> > > > to vfio-pci\n");
> > > > +			return -EINVAL;
> > > > +		}
> > > > +
> > > > +		if (!vf_token) {
> > > > +			vfio_device_put(pf_dev);
> > > > +			pci_info_ratelimited(vdev->pdev,
> > > > +				"VF token required to access device\n");
> > > > +			return -EACCES;
> > > > +		}
> > > > +
> > > > +		mutex_lock(&pf_vdev->vf_token->lock);
> > > > +		match =3D uuid_equal(uuid, &pf_vdev->vf_token->uuid);
> > > > +		mutex_unlock(&pf_vdev->vf_token->lock);
> > > > +
> > > > +		vfio_device_put(pf_dev);
> > > > +
> > > > +		if (!match) {
> > > > +			pci_info_ratelimited(vdev->pdev,
> > > > +				"Incorrect VF token provided for device\n");
> > > > +			return -EACCES;
> > > > +		}
> > > > +	} else if (vdev->vf_token) {
> > > > +		mutex_lock(&vdev->vf_token->lock);
> > > > +		if (vdev->vf_token->users) {
> > > > +			if (!vf_token) {
> > > > +				mutex_unlock(&vdev->vf_token->lock);
> > > > +				pci_info_ratelimited(vdev->pdev,
> > > > +					"VF token required to access
> > > > device\n");
> > > > +				return -EACCES;
> > > > +			}
> > > > +
> > > > +			if (!uuid_equal(uuid, &vdev->vf_token->uuid)) {
> > > > +				mutex_unlock(&vdev->vf_token->lock);
> > > > +				pci_info_ratelimited(vdev->pdev,
> > > > +					"Incorrect VF token provided for
> > > > device\n");
> > > > +				return -EACCES;
> > > > +			}
> > > > +		} else if (vf_token) {
> > > > +			uuid_copy(&vdev->vf_token->uuid, uuid);
> > > > +		} =20
> > >
> > > It implies that we allow PF to be accessed w/o providing a VF token,
> > > as long as no VF is currently in-use, which further means no VF can
> > > be further assigned since no one knows the random uuid allocated
> > > by vfio. Just want to confirm whether it is the desired flavor. If an
> > > user really wants to use PF-only, possibly he should disable SR-IOV
> > > instead... =20
> >=20
> > Yes, this is the behavior I'm intending.  Are you suggesting that we
> > should require a VF token in order to access a PF that has SR-IOV
> > already enabled?  This introduces an inconsistency that SR-IOV can be =
=20
>=20
> yes. I felt that it's meaningless otherwise if an user has no attempt to=
=20
> manage SR-IOV but still leaving it enabled. In many cases, enabling of=20
> SR-IOV may reserve some resource in the hardware, thus simply hurting=20
> PF performance.

But a user needs to be granted access to a device by a privileged
entity and the privileged entity may also enable SR-IOV, so it seems
you're assuming the privileged entity is operating independently and
not in the best interest of enabling the specific user case.

> > enabled via sysfs asynchronous to the GET_DEVICE_FD ioctl, so we'd need
> > to secure the sysfs interface to only allow enabling SR-IOV when the PF
> > is already opened to cases where the VF token is already set?  Thus =20
>=20
> yes, the PF is assigned to the userspace driver, thus it's reasonable to
> have the userspace driver decide whether to enable or disable SR-IOV
> when the PF is under its control. as I replied to patch [5/7], the sysfs
> interface alone looks problematic w/o knowing whether the userspace
> driver is willing to manage VFs (by setting a token)...

As I replied in patch [5/7] the operations don't need to happen
independently, configuring SR-IOV in advance of the user driver
attaching or in collaboration with the user driver can also be enabled
with this series as is.  Allowing the user driver to directly enable
SR-IOV and create VFs in the host is something I've avoided here, but
not precluded for later extensions.  I think that allowing a user to
perform these operations represents a degree of privilege beyond
ownership of the PF itself, which is why I'm currently only enabling
the sysfs sriov_configure interface.  The user driver needs to work in
collaboration with a privileged entity to enable SR-IOV, or be granted
access to operate on the sysfs interface directly.

> > SR-IOV could be pre-enabled, but the user must provide a vf_token
> > option on GET_DEVICE_FD, otherwise SR-IOV could only be enabled after
> > the user sets a VF token.  But then do we need to invalidate the token
> > at some point, or else it seems like we have the same scenario when the
> > next user comes along.  We believe there are PFs that require no =20
>=20
> I think so, e.g. when SR-IOV is being disabled, or when the fd is closed.

Can you articulate a specific risk that this would resolve?  If we have
devices like the one supported by pci-pf-stub, where it's apparently
sufficient to provide no device access other than to enable SR-IOV on
the PF, re-implementing that in vfio-pci would require that the
userspace driver is notified when the SR-IOV configuration is changed
such that a VF token can be re-inserted.  For what gain?

> > special VF support other than sriov_configure, so those driver could
> > theoretically close the PF after setting a VF token.  That makes it =20
>=20
> theoretically yes, but I'm not sure the real gain of supporting such
> usage. =F0=9F=98=8A=20

Likewise I don't see the gain of restricting it.
=20
> btw with your question I realize another potential open. Now an=20
> user could also use sysfs to reset the PF, which definitely affects the
> state of VFs. Do we want a token match with that path? or such
> intention is assumed to be trusted by VF drivers given that only
> privileged users can do it?

I think we're going into the weeds here, a privileged user can use the
pci-sysfs reset interface to break all sorts of things.  I'm certainly
not going to propose any sort of VF token interface to restrict it.
Privileged users can do bad things via sysfs.  Privileged users can
configure PFs in ways that may not be compatible with any given
userspace VF driver.  I'm assuming collaboration in the best interest
of enabling the user driver.  Thanks,

Alex

> > difficult to determine the lifetime of a VF token and leads to the
> > interface proposed here of an initial random token, then the user set
> > token persisting indefinitely.
> >=20
> > I've tended consider all of these to be mechanisms that a user can
> > shoot themselves in the foot.  Yes, the user and admin can do things
> > that will fail to work with this interface, for example my testing
> > involves QEMU, where we don't expose SR-IOV to the guest yet and the
> > igb driver for the PF will encounter problems running a device with
> > SR-IOV enabled that it doesn't know about.  Do we want to try to play
> > nanny and require specific semantics?  I've opt'd for the more simple
> > code here.
> >  =20
> > > > +
> > > > +		mutex_unlock(&vdev->vf_token->lock);
> > > > +	} else if (vf_token) {
> > > > +		pci_info_ratelimited(vdev->pdev,
> > > > +			"VF token incorrectly provided, not a PF or VF\n");
> > > > +		return -EINVAL;
> > > > +	}
> > > > +
> > > > +	return 0;
> > > > +}
> > > > +
> > > > +#define VF_TOKEN_ARG "vf_token=3D"
> > > > +
> > > >  static int vfio_pci_match(void *device_data, char *buf)
> > > >  {
> > > >  	struct vfio_pci_device *vdev =3D device_data;
> > > > +	bool vf_token =3D false;
> > > > +	uuid_t uuid;
> > > > +	int ret;
> > > > +
> > > > +	if (strncmp(pci_name(vdev->pdev), buf, strlen(pci_name(vdev- =20
> > > > >pdev)))) =20
> > > > +		return 0; /* No match */
> > > > +
> > > > +	if (strlen(buf) > strlen(pci_name(vdev->pdev))) {
> > > > +		buf +=3D strlen(pci_name(vdev->pdev));
> > > > +
> > > > +		if (*buf !=3D ' ')
> > > > +			return 0; /* No match: non-whitespace after name */
> > > > +
> > > > +		while (*buf) {
> > > > +			if (*buf =3D=3D ' ') {
> > > > +				buf++;
> > > > +				continue;
> > > > +			}
> > > > +
> > > > +			if (!vf_token && !strncmp(buf, VF_TOKEN_ARG,
> > > > +						  strlen(VF_TOKEN_ARG))) {
> > > > +				buf +=3D strlen(VF_TOKEN_ARG);
> > > > +
> > > > +				if (strlen(buf) < UUID_STRING_LEN)
> > > > +					return -EINVAL;
> > > > +
> > > > +				ret =3D uuid_parse(buf, &uuid);
> > > > +				if (ret)
> > > > +					return ret;
> > > >
> > > > -	return !strcmp(pci_name(vdev->pdev), buf);
> > > > +				vf_token =3D true;
> > > > +				buf +=3D UUID_STRING_LEN;
> > > > +			} else {
> > > > +				/* Unknown/duplicate option */
> > > > +				return -EINVAL;
> > > > +			}
> > > > +		}
> > > > +	}
> > > > +
> > > > +	ret =3D vfio_pci_validate_vf_token(vdev, vf_token, &uuid);
> > > > +	if (ret)
> > > > +		return ret;
> > > > +
> > > > +	return 1; /* Match */
> > > >  }
> > > >
> > > >  static const struct vfio_device_ops vfio_pci_ops =3D {
> > > > @@ -1354,6 +1531,19 @@ static int vfio_pci_probe(struct pci_dev *pd=
ev,
> > > > const struct pci_device_id *id)
> > > >  		return ret;
> > > >  	}
> > > >
> > > > +	if (pdev->is_physfn) {
> > > > +		vdev->vf_token =3D kzalloc(sizeof(*vdev->vf_token),
> > > > GFP_KERNEL);
> > > > +		if (!vdev->vf_token) {
> > > > +			vfio_pci_reflck_put(vdev->reflck);
> > > > +			vfio_del_group_dev(&pdev->dev);
> > > > +			vfio_iommu_group_put(group, &pdev->dev);
> > > > +			kfree(vdev);
> > > > +			return -ENOMEM;
> > > > +		}
> > > > +		mutex_init(&vdev->vf_token->lock);
> > > > +		uuid_gen(&vdev->vf_token->uuid); =20
> > >
> > > should we also regenerate a random uuid somewhere when SR-IOV is
> > > disabled and then re-enabled on a PF? Although vfio disallows userspa=
ce
> > > to read uuid, it is always safer to avoid caching a secret from previ=
ous
> > > user. =20
> >=20
> > What if our user is QEMU emulating SR-IOV to the guest.  Do we want to
> > force a new VF token is set every time we bounce the VFs?  Why?  As
> > above, the session lifetime of the VF token might be difficult to
> > determine and I'm not sure paranoia is a sufficient reason to try to
> > create boundaries for it.  Thanks,
> >=20
> > Alex
> >  =20
> > > > +	}
> > > > +
> > > >  	if (vfio_pci_is_vga(pdev)) {
> > > >  		vga_client_register(pdev, vdev, NULL,
> > > > vfio_pci_set_vga_decode);
> > > >  		vga_set_legacy_decoding(pdev,
> > > > @@ -1387,6 +1577,12 @@ static void vfio_pci_remove(struct pci_dev =
=20
> > *pdev) =20
> > > >  	if (!vdev)
> > > >  		return;
> > > >
> > > > +	if (vdev->vf_token) {
> > > > +		WARN_ON(vdev->vf_token->users);
> > > > +		mutex_destroy(&vdev->vf_token->lock);
> > > > +		kfree(vdev->vf_token);
> > > > +	}
> > > > +
> > > >  	vfio_pci_reflck_put(vdev->reflck);
> > > >
> > > >  	vfio_iommu_group_put(pdev->dev.iommu_group, &pdev->dev);
> > > > diff --git a/drivers/vfio/pci/vfio_pci_private.h
> > > > b/drivers/vfio/pci/vfio_pci_private.h
> > > > index 8a2c7607d513..76c11c915949 100644
> > > > --- a/drivers/vfio/pci/vfio_pci_private.h
> > > > +++ b/drivers/vfio/pci/vfio_pci_private.h
> > > > @@ -12,6 +12,7 @@
> > > >  #include <linux/pci.h>
> > > >  #include <linux/irqbypass.h>
> > > >  #include <linux/types.h>
> > > > +#include <linux/uuid.h>
> > > >
> > > >  #ifndef VFIO_PCI_PRIVATE_H
> > > >  #define VFIO_PCI_PRIVATE_H
> > > > @@ -84,6 +85,12 @@ struct vfio_pci_reflck {
> > > >  	struct mutex		lock;
> > > >  };
> > > >
> > > > +struct vfio_pci_vf_token {
> > > > +	struct mutex		lock;
> > > > +	uuid_t			uuid;
> > > > +	int			users;
> > > > +};
> > > > +
> > > >  struct vfio_pci_device {
> > > >  	struct pci_dev		*pdev;
> > > >  	void __iomem		*barmap[PCI_STD_NUM_BARS];
> > > > @@ -122,6 +129,7 @@ struct vfio_pci_device {
> > > >  	struct list_head	dummy_resources_list;
> > > >  	struct mutex		ioeventfds_lock;
> > > >  	struct list_head	ioeventfds_list;
> > > > +	struct vfio_pci_vf_token	*vf_token;
> > > >  };
> > > >
> > > >  #define is_intx(vdev) (vdev->irq_type =3D=3D VFIO_PCI_INTX_IRQ_IND=
EX) =20
> > > =20
>=20

