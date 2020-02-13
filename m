Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B648615BDFE
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2020 12:47:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729674AbgBMLrO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Feb 2020 06:47:14 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:22991 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727059AbgBMLrN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Feb 2020 06:47:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581594432;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VrWnGqqwBxjz6lDUPr1v80TiFd7C+Cunt0cqiT1oD0s=;
        b=cqVhl+ZgL1MBtMRoSgruesSOi2ZuYeq3CXT2MZ4dB/iPLiSDHQAIJCLrbBMLVBK8WnCZsk
        SrD844xJK0Uap9sdihOWuCumo26OalWrQ41rQOd7Pl/FI8UB3WAXKiAF3vhLLH38ktTQeA
        Ywd/L2KdXmz4xq+OxZgp/2+MurJERps=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-142-UO6wRuJNMNej8OiklcNbTA-1; Thu, 13 Feb 2020 06:47:08 -0500
X-MC-Unique: UO6wRuJNMNej8OiklcNbTA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3119B8018AE;
        Thu, 13 Feb 2020 11:47:07 +0000 (UTC)
Received: from gondolin (ovpn-117-100.ams2.redhat.com [10.36.117.100])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CE69D5C13F;
        Thu, 13 Feb 2020 11:46:56 +0000 (UTC)
Date:   Thu, 13 Feb 2020 12:46:54 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, dev@dpdk.org, mtosatti@redhat.com,
        thomas@monjalon.net, bluca@debian.org, jerinjacobk@gmail.com,
        bruce.richardson@intel.com
Subject: Re: [PATCH 3/7] vfio/pci: Introduce VF token
Message-ID: <20200213124654.76128d29.cohuck@redhat.com>
In-Reply-To: <158146234273.16827.10591457733122265139.stgit@gimli.home>
References: <158145472604.16827.15751375540102298130.stgit@gimli.home>
        <158146234273.16827.10591457733122265139.stgit@gimli.home>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 11 Feb 2020 16:05:42 -0700
Alex Williamson <alex.williamson@redhat.com> wrote:

> If we enable SR-IOV on a vfio-pci owned PF, the resulting VFs are not
> fully isolated from the PF.  The PF can always cause a denial of
> service to the VF, if not access data passed through the VF directly.
> This is why vfio-pci currently does not bind to PFs with SR-IOV enabled
> and does not provide access itself to enabling SR-IOV on a PF.  The
> IOMMU grouping mechanism might allow us a solution to this lack of
> isolation, however the deficiency isn't actually in the DMA path, so
> much as the potential cooperation between PF and VF devices.  Also,
> if we were to force VFs into the same IOMMU group as the PF, we severely
> limit the utility of having independent drivers managing PFs and VFs
> with vfio.
> 
> Therefore we introduce the concept of a VF token.  The token is
> implemented as a UUID and represents a shared secret which must be set
> by the PF driver and used by the VF drivers in order to access a vfio
> device file descriptor for the VF.  The ioctl to set the VF token will
> be provided in a later commit, this commit implements the underlying
> infrastructure.  The concept here is to augment the string the user
> passes to match a device within a group in order to retrieve access to
> the device descriptor.  For example, rather than passing only the PCI
> device name (ex. "0000:03:00.0") the user would also pass a vf_token
> UUID (ex. "2ab74924-c335-45f4-9b16-8569e5b08258").  The device match
> string therefore becomes:
> 
> "0000:03:00.0 vf_token=2ab74924-c335-45f4-9b16-8569e5b08258"
> 
> This syntax is expected to be extensible to future options as well, with
> the standard being:
> 
> "$DEVICE_NAME $OPTION1=$VALUE1 $OPTION2=$VALUE2"

Is this designed to be an AND condition? (I read it as such.)

> 
> The device name must be first and option=value pairs are separated by
> spaces.
> 
> The vf_token option is only required for VFs where the PF device is
> bound to vfio-pci.  There is no change for PFs using existing host
> drivers.
> 
> Note that in order to protect existing VF users, not only is it required
> to set a vf_token on the PF before VFs devices can be accessed, but also
> if there are existing VF users, (re)opening the PF device must also
> provide the current vf_token as authentication.  This is intended to
> prevent a VF driver starting with a trusted PF driver and later being
> replaced by an unknown driver.  A vf_token is not required to open the
> PF device when none of the VF devices are in use by vfio-pci drivers.
> 
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> ---
>  drivers/vfio/pci/vfio_pci.c         |  127 +++++++++++++++++++++++++++++++++++
>  drivers/vfio/pci/vfio_pci_private.h |    8 ++
>  2 files changed, 134 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
> index 2ec6c31d0ab0..26aea9ac4863 100644
> --- a/drivers/vfio/pci/vfio_pci.c
> +++ b/drivers/vfio/pci/vfio_pci.c
> @@ -466,6 +466,35 @@ static void vfio_pci_disable(struct vfio_pci_device *vdev)
>  		vfio_pci_set_power_state(vdev, PCI_D3hot);
>  }
>  
> +static struct pci_driver vfio_pci_driver;
> +
> +static void vfio_pci_vf_token_user_add(struct vfio_pci_device *vdev, int val)

Suggestion: call this _user_modify(), and have _user_add() and
_user_remove() as wrappers. That said, ...

> +{
> +	struct pci_dev *physfn = pci_physfn(vdev->pdev);
> +	struct vfio_device *pf_dev;
> +	struct vfio_pci_device *pf_vdev;
> +
> +	if (!vdev->pdev->is_virtfn)
> +		return;
> +
> +	pf_dev = vfio_device_get_from_dev(&physfn->dev);
> +	if (!pf_dev)
> +		return;
> +
> +	if (pci_dev_driver(physfn) != &vfio_pci_driver) {
> +		vfio_device_put(pf_dev);
> +		return;
> +	}
> +
> +	pf_vdev = vfio_device_data(pf_dev);
> +
> +	mutex_lock(&pf_vdev->vf_token->lock);
> +	pf_vdev->vf_token->users += val;

...is this expected to always be >= 0? If yes, it looks like a bug if
this is called with val==-n for n > users.

> +	mutex_unlock(&pf_vdev->vf_token->lock);
> +
> +	vfio_device_put(pf_dev);
> +}
> +
>  static void vfio_pci_release(void *device_data)
>  {
>  	struct vfio_pci_device *vdev = device_data;
> @@ -475,6 +504,7 @@ static void vfio_pci_release(void *device_data)
>  	if (!(--vdev->refcnt)) {
>  		vfio_spapr_pci_eeh_release(vdev->pdev);
>  		vfio_pci_disable(vdev);
> +		vfio_pci_vf_token_user_add(vdev, -1);
>  	}
>  
>  	mutex_unlock(&vdev->reflck->lock);
> @@ -493,6 +523,7 @@ static int vfio_pci_open(void *device_data)
>  	mutex_lock(&vdev->reflck->lock);
>  
>  	if (!vdev->refcnt) {
> +		vfio_pci_vf_token_user_add(vdev, 1);
>  		ret = vfio_pci_enable(vdev);
>  		if (ret)
>  			goto error;
> @@ -1278,11 +1309,86 @@ static void vfio_pci_request(void *device_data, unsigned int count)
>  	mutex_unlock(&vdev->igate);
>  }
>  
> +#define VF_TOKEN_ARG "vf_token="
> +
> +/* Called with vdev->vf_token->lock */
> +static int vfio_pci_vf_token_match(struct vfio_pci_device *vdev, char *opts)
> +{
> +	char *token;
> +	uuid_t uuid;
> +	int ret;
> +
> +	if (!opts)
> +		return -EINVAL;
> +
> +	token = strstr(opts, VF_TOKEN_ARG);
> +	if (!token)
> +		return -EINVAL;
> +
> +	token += strlen(VF_TOKEN_ARG);
> +
> +	ret = uuid_parse(token, &uuid);
> +	if (ret)
> +		return ret;
> +
> +	if (!uuid_equal(&uuid, &vdev->vf_token->uuid))
> +		return -EACCES;
> +
> +	return 0;
> +}
> +
>  static int vfio_pci_match(void *device_data, char *buf)
>  {
>  	struct vfio_pci_device *vdev = device_data;
> +	char *opts;
> +
> +	opts = strchr(buf, ' ');
> +	if (opts) {
> +		*opts = 0;
> +		opts++;
> +	}
> +
> +	if (strcmp(pci_name(vdev->pdev), buf))
> +		return 0; /* No match */

Up to here, this function is fine; but below, it gets a bit hard to
follow...

> +
> +	if (vdev->pdev->is_virtfn) {
> +		struct pci_dev *physfn = pci_physfn(vdev->pdev);
> +		struct vfio_device *pf_dev;
> +		int ret = 0;
> +
> +		pf_dev = vfio_device_get_from_dev(&physfn->dev);
> +		if (pf_dev) {
> +			if (pci_dev_driver(physfn) == &vfio_pci_driver) {
> +				struct vfio_pci_device *pf_vdev =
> +						vfio_device_data(pf_dev);
> +
> +				mutex_lock(&pf_vdev->vf_token->lock);
> +				ret = vfio_pci_vf_token_match(pf_vdev, opts);
> +				mutex_unlock(&pf_vdev->vf_token->lock);
> +			}
> +
> +			vfio_device_put(pf_dev);
> +
> +			if (ret)
> +				return -EACCES;
> +		}
> +	}

If we are a VF, and the PF is bound to vfio, pass whatever stuff other
than the device name that was passed in to an opaque match function.

>  
> -	return !strcmp(pci_name(vdev->pdev), buf);
> +	if (vdev->vf_token) {
> +		int ret = 0;
> +
> +		mutex_lock(&vdev->vf_token->lock);
> +
> +		if (vdev->vf_token->users)
> +			ret = vfio_pci_vf_token_match(vdev, opts);
> +
> +		mutex_unlock(&vdev->vf_token->lock);
> +
> +		if (ret)
> +			return -EACCES;
> +	}

If we have a VF token with users, pass whatever stuff other than the
device name that was passed in to an opaque match function.

What about the following instead:

- parse the passed-in string into device name and key/value pairs
- maybe reject anything with an unknown key
- check the device name
- if we're a VF with the PF bound to vfio, require a VF token to be
  specified and pass it to a token match function
- if we have a VF token with users, require a VF token to be specified
  and pass it to a token match function

My main gripes with the current code are:
- key=value parsing is done in the match function for vf_token
- it looks hard to extend the list of supported key/value pairs
- I don't see a good way to find out (as the user) _why_ the VF isn't
  matching


> +
> +	return 1; /* Match */
>  }

(...)

