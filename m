Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 242481542CE
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2020 12:14:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727635AbgBFLOg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Feb 2020 06:14:36 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:59318 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727634AbgBFLOf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Feb 2020 06:14:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580987674;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rHTZHgmASPSoMGwevhPMX79nOsZmoqk9zStUKfH69Ac=;
        b=iuQQoERaiBV5tX7Dus2H45lzJlKqsCLBbMBjwVfvrTD75eBdtsLa7IMuqF43EaWfx6oN1x
        RIoIoj8Da+HXBX1gvZxbj0b7/GVJDrLdviRgH3b+Kk8qXoewauNv8URYLwrsv7HfIpIE2F
        OaZ2BFAUzxUv2y9RM6DWmzHxMdVWYe0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-160-1MlG-dHJOhuoPlWtqAiYTw-1; Thu, 06 Feb 2020 06:14:31 -0500
X-MC-Unique: 1MlG-dHJOhuoPlWtqAiYTw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4C9141857341;
        Thu,  6 Feb 2020 11:14:29 +0000 (UTC)
Received: from gondolin (dhcp-192-195.str.redhat.com [10.33.192.195])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4670910016DA;
        Thu,  6 Feb 2020 11:14:22 +0000 (UTC)
Date:   Thu, 6 Feb 2020 12:14:19 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, dev@dpdk.org, mtosatti@redhat.com,
        thomas@monjalon.net, bluca@debian.org, jerinjacobk@gmail.com,
        bruce.richardson@intel.com
Subject: Re: [RFC PATCH 1/7] vfio: Include optional device match in
 vfio_device_ops callbacks
Message-ID: <20200206121419.69997326.cohuck@redhat.com>
In-Reply-To: <158085754299.9445.4389176548645142886.stgit@gimli.home>
References: <158085337582.9445.17682266437583505502.stgit@gimli.home>
        <158085754299.9445.4389176548645142886.stgit@gimli.home>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 04 Feb 2020 16:05:43 -0700
Alex Williamson <alex.williamson@redhat.com> wrote:

> Allow bus drivers to provide their own callback to match a device to
> the user provided string.
> 
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> ---
>  drivers/vfio/vfio.c  |   19 +++++++++++++++----
>  include/linux/vfio.h |    3 +++
>  2 files changed, 18 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> index 388597930b64..dda1726adda8 100644
> --- a/drivers/vfio/vfio.c
> +++ b/drivers/vfio/vfio.c
> @@ -875,11 +875,22 @@ EXPORT_SYMBOL_GPL(vfio_device_get_from_dev);
>  static struct vfio_device *vfio_device_get_from_name(struct vfio_group *group,
>  						     char *buf)
>  {
> -	struct vfio_device *it, *device = NULL;
> +	struct vfio_device *it, *device = ERR_PTR(-ENODEV);
>  
>  	mutex_lock(&group->device_lock);
>  	list_for_each_entry(it, &group->device_list, group_next) {
> -		if (!strcmp(dev_name(it->dev), buf)) {
> +		int ret;
> +
> +		if (it->ops->match) {
> +			ret = it->ops->match(it->device_data, buf);
> +			if (ret < 0 && ret != -ENODEV) {
> +				device = ERR_PTR(ret);
> +				break;
> +			}
> +		} else
> +			ret = strcmp(dev_name(it->dev), buf);

The asymmetric braces look a bit odd.

> +
> +		if (!ret) {
>  			device = it;
>  			vfio_device_get(device);
>  			break;
> @@ -1441,8 +1452,8 @@ static int vfio_group_get_device_fd(struct vfio_group *group, char *buf)
>  		return -EPERM;
>  
>  	device = vfio_device_get_from_name(group, buf);
> -	if (!device)
> -		return -ENODEV;
> +	if (IS_ERR(device))
> +		return PTR_ERR(device);
>  
>  	ret = device->ops->open(device->device_data);
>  	if (ret) {
> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> index e42a711a2800..755e0f0e2900 100644
> --- a/include/linux/vfio.h
> +++ b/include/linux/vfio.h
> @@ -26,6 +26,8 @@
>   *         operations documented below
>   * @mmap: Perform mmap(2) on a region of the device file descriptor
>   * @request: Request for the bus driver to release the device
> + * @match: Optional device name match callback (return: 0 for match, -ENODEV
> + *         (or >0) for no match and continue, other -errno: no match and stop)

I'm wondering about these conventions.

If you basically want a tri-state return (match, don't match/continue,
don't match/stop), putting -ENODEV and >0 together feels odd. I would
rather expect either
- < 0 == don't match/stop, 0 == don't match/continue, > 0 == match, or
- 0 == match, -ENODEV (or some other defined error) == don't
  match/continue, all other values == don't match/abort?

>   */
>  struct vfio_device_ops {
>  	char	*name;
> @@ -39,6 +41,7 @@ struct vfio_device_ops {
>  			 unsigned long arg);
>  	int	(*mmap)(void *device_data, struct vm_area_struct *vma);
>  	void	(*request)(void *device_data, unsigned int count);
> +	int	(*match)(void *device_data, char *buf);
>  };
>  
>  extern struct iommu_group *vfio_iommu_group_get(struct device *dev);
> 

