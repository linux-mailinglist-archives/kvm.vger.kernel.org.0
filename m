Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C50415C95D
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2020 18:23:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728530AbgBMRXb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Feb 2020 12:23:31 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:53200 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727966AbgBMRXa (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 13 Feb 2020 12:23:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581614608;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5ZMRVz/WdCTWZhSrZBtOojCPqykVcHGAI17WszWJS+8=;
        b=VR7hWvXHHwUirb3k+M9ovzT9MLC9BRpNB5esHycdWfUvz0i7q3woCxFkQWDtznpBLAXnsd
        XdPc1zMRDowDzTlUGio5gB03qztBqRfeiMwmIJsf4NkYZWkxysFHbWob28mKEWSS3bqFMH
        kgXuFbZrXeJ7qBrJYq79hHigcPKyHns=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-105-ct_soC2HMr-QkKjI0riS7g-1; Thu, 13 Feb 2020 12:23:24 -0500
X-MC-Unique: ct_soC2HMr-QkKjI0riS7g-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 545A6107ACCC;
        Thu, 13 Feb 2020 17:23:22 +0000 (UTC)
Received: from w520.home (ovpn-116-28.phx2.redhat.com [10.3.116.28])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7619D60BF1;
        Thu, 13 Feb 2020 17:23:21 +0000 (UTC)
Date:   Thu, 13 Feb 2020 10:23:21 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, dev@dpdk.org, mtosatti@redhat.com,
        thomas@monjalon.net, bluca@debian.org, jerinjacobk@gmail.com,
        bruce.richardson@intel.com
Subject: Re: [PATCH 3/7] vfio/pci: Introduce VF token
Message-ID: <20200213102321.0341db63@w520.home>
In-Reply-To: <20200213124654.76128d29.cohuck@redhat.com>
References: <158145472604.16827.15751375540102298130.stgit@gimli.home>
        <158146234273.16827.10591457733122265139.stgit@gimli.home>
        <20200213124654.76128d29.cohuck@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 13 Feb 2020 12:46:54 +0100
Cornelia Huck <cohuck@redhat.com> wrote:

> On Tue, 11 Feb 2020 16:05:42 -0700
> Alex Williamson <alex.williamson@redhat.com> wrote:
> 
> > If we enable SR-IOV on a vfio-pci owned PF, the resulting VFs are not
> > fully isolated from the PF.  The PF can always cause a denial of
> > service to the VF, if not access data passed through the VF directly.
> > This is why vfio-pci currently does not bind to PFs with SR-IOV enabled
> > and does not provide access itself to enabling SR-IOV on a PF.  The
> > IOMMU grouping mechanism might allow us a solution to this lack of
> > isolation, however the deficiency isn't actually in the DMA path, so
> > much as the potential cooperation between PF and VF devices.  Also,
> > if we were to force VFs into the same IOMMU group as the PF, we severely
> > limit the utility of having independent drivers managing PFs and VFs
> > with vfio.
> > 
> > Therefore we introduce the concept of a VF token.  The token is
> > implemented as a UUID and represents a shared secret which must be set
> > by the PF driver and used by the VF drivers in order to access a vfio
> > device file descriptor for the VF.  The ioctl to set the VF token will
> > be provided in a later commit, this commit implements the underlying
> > infrastructure.  The concept here is to augment the string the user
> > passes to match a device within a group in order to retrieve access to
> > the device descriptor.  For example, rather than passing only the PCI
> > device name (ex. "0000:03:00.0") the user would also pass a vf_token
> > UUID (ex. "2ab74924-c335-45f4-9b16-8569e5b08258").  The device match
> > string therefore becomes:
> > 
> > "0000:03:00.0 vf_token=2ab74924-c335-45f4-9b16-8569e5b08258"
> > 
> > This syntax is expected to be extensible to future options as well, with
> > the standard being:
> > 
> > "$DEVICE_NAME $OPTION1=$VALUE1 $OPTION2=$VALUE2"  
> 
> Is this designed to be an AND condition? (I read it as such.)

Not sure I understand, the device name is always required for
compatibility, then zero or more key/value pairs may be needed
depending on the vfio bus driver and device requirements.  I'm not
suggesting that the user would pass multiple vf_token= options and the
implementation here would only parse the first.  I'm really only
suggesting the parsing format we'd use for multiple options, I'm not
trying to dictate how a bus driver might make use of them.  Does that
make sense, should I change some wording?
 
> > 
> > The device name must be first and option=value pairs are separated by
> > spaces.
> > 
> > The vf_token option is only required for VFs where the PF device is
> > bound to vfio-pci.  There is no change for PFs using existing host
> > drivers.
> > 
> > Note that in order to protect existing VF users, not only is it required
> > to set a vf_token on the PF before VFs devices can be accessed, but also
> > if there are existing VF users, (re)opening the PF device must also
> > provide the current vf_token as authentication.  This is intended to
> > prevent a VF driver starting with a trusted PF driver and later being
> > replaced by an unknown driver.  A vf_token is not required to open the
> > PF device when none of the VF devices are in use by vfio-pci drivers.
> > 
> > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> > ---
> >  drivers/vfio/pci/vfio_pci.c         |  127 +++++++++++++++++++++++++++++++++++
> >  drivers/vfio/pci/vfio_pci_private.h |    8 ++
> >  2 files changed, 134 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
> > index 2ec6c31d0ab0..26aea9ac4863 100644
> > --- a/drivers/vfio/pci/vfio_pci.c
> > +++ b/drivers/vfio/pci/vfio_pci.c
> > @@ -466,6 +466,35 @@ static void vfio_pci_disable(struct vfio_pci_device *vdev)
> >  		vfio_pci_set_power_state(vdev, PCI_D3hot);
> >  }
> >  
> > +static struct pci_driver vfio_pci_driver;
> > +
> > +static void vfio_pci_vf_token_user_add(struct vfio_pci_device *vdev, int val)  
> 
> Suggestion: call this _user_modify(), and have _user_add() and
> _user_remove() as wrappers. That said, ...

I did consider something along these lines, but it seems overly
explicit for a helper that's used in two places with only two obvious
and discrete values.  If this were an exposed API, absolutely I'd agree.

> > +{
> > +	struct pci_dev *physfn = pci_physfn(vdev->pdev);
> > +	struct vfio_device *pf_dev;
> > +	struct vfio_pci_device *pf_vdev;
> > +
> > +	if (!vdev->pdev->is_virtfn)
> > +		return;
> > +
> > +	pf_dev = vfio_device_get_from_dev(&physfn->dev);
> > +	if (!pf_dev)
> > +		return;
> > +
> > +	if (pci_dev_driver(physfn) != &vfio_pci_driver) {
> > +		vfio_device_put(pf_dev);
> > +		return;
> > +	}
> > +
> > +	pf_vdev = vfio_device_data(pf_dev);
> > +
> > +	mutex_lock(&pf_vdev->vf_token->lock);
> > +	pf_vdev->vf_token->users += val;  
> 
> ...is this expected to always be >= 0? If yes, it looks like a bug if
> this is called with val==-n for n > users.

I'm not sure if you're inadvertently pointing out the bug in the
vfio_pci_open() path below where we increment token users before
vfio_pci_enable() which can fail, or your suggesting a WARN_ON here
should this go negative.  This is a static helper function, so I
generally don't try to sanitize the inputs like I would for an exposed
API.
 
> > +	mutex_unlock(&pf_vdev->vf_token->lock);
> > +
> > +	vfio_device_put(pf_dev);
> > +}
> > +
> >  static void vfio_pci_release(void *device_data)
> >  {
> >  	struct vfio_pci_device *vdev = device_data;
> > @@ -475,6 +504,7 @@ static void vfio_pci_release(void *device_data)
> >  	if (!(--vdev->refcnt)) {
> >  		vfio_spapr_pci_eeh_release(vdev->pdev);
> >  		vfio_pci_disable(vdev);
> > +		vfio_pci_vf_token_user_add(vdev, -1);
> >  	}
> >  
> >  	mutex_unlock(&vdev->reflck->lock);
> > @@ -493,6 +523,7 @@ static int vfio_pci_open(void *device_data)
> >  	mutex_lock(&vdev->reflck->lock);
> >  
> >  	if (!vdev->refcnt) {
> > +		vfio_pci_vf_token_user_add(vdev, 1);
> >  		ret = vfio_pci_enable(vdev);
> >  		if (ret)
> >  			goto error;

I think we want to include decrementing token users in the error path
here.

> > @@ -1278,11 +1309,86 @@ static void vfio_pci_request(void *device_data, unsigned int count)
> >  	mutex_unlock(&vdev->igate);
> >  }
> >  
> > +#define VF_TOKEN_ARG "vf_token="
> > +
> > +/* Called with vdev->vf_token->lock */
> > +static int vfio_pci_vf_token_match(struct vfio_pci_device *vdev, char *opts)
> > +{
> > +	char *token;
> > +	uuid_t uuid;
> > +	int ret;
> > +
> > +	if (!opts)
> > +		return -EINVAL;
> > +
> > +	token = strstr(opts, VF_TOKEN_ARG);
> > +	if (!token)
> > +		return -EINVAL;
> > +
> > +	token += strlen(VF_TOKEN_ARG);
> > +
> > +	ret = uuid_parse(token, &uuid);
> > +	if (ret)
> > +		return ret;
> > +
> > +	if (!uuid_equal(&uuid, &vdev->vf_token->uuid))
> > +		return -EACCES;
> > +
> > +	return 0;
> > +}
> > +
> >  static int vfio_pci_match(void *device_data, char *buf)
> >  {
> >  	struct vfio_pci_device *vdev = device_data;
> > +	char *opts;
> > +
> > +	opts = strchr(buf, ' ');
> > +	if (opts) {
> > +		*opts = 0;
> > +		opts++;
> > +	}
> > +
> > +	if (strcmp(pci_name(vdev->pdev), buf))
> > +		return 0; /* No match */  
> 
> Up to here, this function is fine; but below, it gets a bit hard to
> follow...
> 
> > +
> > +	if (vdev->pdev->is_virtfn) {
> > +		struct pci_dev *physfn = pci_physfn(vdev->pdev);
> > +		struct vfio_device *pf_dev;
> > +		int ret = 0;
> > +
> > +		pf_dev = vfio_device_get_from_dev(&physfn->dev);
> > +		if (pf_dev) {
> > +			if (pci_dev_driver(physfn) == &vfio_pci_driver) {
> > +				struct vfio_pci_device *pf_vdev =
> > +						vfio_device_data(pf_dev);
> > +
> > +				mutex_lock(&pf_vdev->vf_token->lock);
> > +				ret = vfio_pci_vf_token_match(pf_vdev, opts);
> > +				mutex_unlock(&pf_vdev->vf_token->lock);
> > +			}
> > +
> > +			vfio_device_put(pf_dev);
> > +
> > +			if (ret)
> > +				return -EACCES;
> > +		}
> > +	}  
> 
> If we are a VF, and the PF is bound to vfio, pass whatever stuff other
> than the device name that was passed in to an opaque match function.

vfio_pci_match() is an opaque match function relative to vfio.c, but
there's nothing opaque here.  We have a VF where the associated PF is
bound to vfio-pci, therefore we require that the additional options
include a vf_token matching the PF and we go looking to verify that.
 
> > -	return !strcmp(pci_name(vdev->pdev), buf);
> > +	if (vdev->vf_token) {
> > +		int ret = 0;
> > +
> > +		mutex_lock(&vdev->vf_token->lock);
> > +
> > +		if (vdev->vf_token->users)
> > +			ret = vfio_pci_vf_token_match(vdev, opts);
> > +
> > +		mutex_unlock(&vdev->vf_token->lock);
> > +
> > +		if (ret)
> > +			return -EACCES;
> > +	}  
> 
> If we have a VF token with users, pass whatever stuff other than the
> device name that was passed in to an opaque match function.

This description strays further off course a bit.  If we have a
vf_token then we are a PF and clearly bound to vfio-pci.  If there are
existing VF users then we require the user to provide a vf_token
matching the one currently on the device.

> What about the following instead:
> 
> - parse the passed-in string into device name and key/value pairs
> - maybe reject anything with an unknown key

This is definitely something that we should decided whether or not we
want to do it.  I think an argument for it is that a user can pick
arbitrary key=value options that would be ignored with this
implementation, but later might match a key that gets defined and then
we break them.  Misuse of the API on the part of the user, but maybe
better to just prevent it ahead of time.

> - check the device name
> - if we're a VF with the PF bound to vfio, require a VF token to be
>   specified and pass it to a token match function
> - if we have a VF token with users, require a VF token to be specified
>   and pass it to a token match function

This is essentially what we do above.  Maybe we just disagree about
whether we're calling an "opaque match function" versus a "token match
function".

> 
> My main gripes with the current code are:
> - key=value parsing is done in the match function for vf_token
> - it looks hard to extend the list of supported key/value pairs
> - I don't see a good way to find out (as the user) _why_ the VF isn't
>   matching

If we want to reject unknown options, then yes, the parsing should be
done ahead.  I don't see that it's hard to extend though, each new
requirement can follow the same methodology to check for it in the
remaining options string.

The last point is the one I brought up in the cover letter and where
I'm also not happy with the opaque error condition, but I have no
thoughts on how to resolve it.  Either we block the user from getting
the device file descriptor, and they're left scratching their heads
why, or we give them access to the file descriptor AND we need to
impose barriers to access mechanisms (ex. block read/write/mmap, limit
ioctls) AND we need to use VFIO_DEVICE_FEATURE and VFIO_DEVICE_GET_INFO
as a mechanism for the user to figure out that the device requires
"something" to get full access.  With the latter, I'm concerned whether
existing userspace code will fail in predictable ways and that it
snowballs into an ugly API.  For instance, if we add a flag to device
info to indicate it's locked, existing code won't know about that flag,
so we have to cripple device info to report no regions and no irqs to
make that code fail.  Then a user needs to know which feature to probe
for to figure out how the device is locked, then once they do we make
device info report real values?  It's maybe a little more deterministic
than blocking access to the file descriptor, but I'm not sure it's
worth it.  We could do a log-once if the match fails for token, but we
need to be careful not to provide an obvious point where the user could
spam the logs.  I've also considered if we could write an error back
into the user's buffer, but the ioctl isn't designed that way and we
don't know if we'd break how the user consumes that buffer later.

Ideas greatly welcomed in this space.  Thanks for the review!

Alex

