Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4548E1554BF
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2020 10:33:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726857AbgBGJdu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Feb 2020 04:33:50 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:38172 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726674AbgBGJdu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 Feb 2020 04:33:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581068028;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8PAzHny0x2QHx+dIx+vP8eKtbzz9uBF25gnK6yMYgy8=;
        b=Z84OwjpKpwg/3A6RE14Q1vxzNkWPmtTLlsNiH7obRsjfEoC8lnPTk2NEMv+yjpL1BTtqCs
        7sgLPpyBEc+uQ9MyScFofd8GPcbnxHY2YdDMIwYpe/n9cq8d55dNSf6X6agqMQH9uJVZkK
        aNAXpwtsMXuJuGFRZ+SjrKfsNjaiGkA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-191-gMqxWvVyMVmcXEgZT7bA4g-1; Fri, 07 Feb 2020 04:33:43 -0500
X-MC-Unique: gMqxWvVyMVmcXEgZT7bA4g-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A69B1101FC60;
        Fri,  7 Feb 2020 09:33:41 +0000 (UTC)
Received: from gondolin (ovpn-117-112.ams2.redhat.com [10.36.117.112])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3E3AC790F8;
        Fri,  7 Feb 2020 09:33:36 +0000 (UTC)
Date:   Fri, 7 Feb 2020 10:33:34 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, dev@dpdk.org, mtosatti@redhat.com,
        thomas@monjalon.net, bluca@debian.org, jerinjacobk@gmail.com,
        bruce.richardson@intel.com
Subject: Re: [RFC PATCH 1/7] vfio: Include optional device match in
 vfio_device_ops callbacks
Message-ID: <20200207103334.25b17267.cohuck@redhat.com>
In-Reply-To: <20200206111842.705bf58a@w520.home>
References: <158085337582.9445.17682266437583505502.stgit@gimli.home>
        <158085754299.9445.4389176548645142886.stgit@gimli.home>
        <20200206121419.69997326.cohuck@redhat.com>
        <20200206111842.705bf58a@w520.home>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 6 Feb 2020 11:18:42 -0700
Alex Williamson <alex.williamson@redhat.com> wrote:

> On Thu, 6 Feb 2020 12:14:19 +0100
> Cornelia Huck <cohuck@redhat.com> wrote:
> 
> > On Tue, 04 Feb 2020 16:05:43 -0700
> > Alex Williamson <alex.williamson@redhat.com> wrote:
> >   
> > > Allow bus drivers to provide their own callback to match a device to
> > > the user provided string.
> > > 
> > > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> > > ---
> > >  drivers/vfio/vfio.c  |   19 +++++++++++++++----
> > >  include/linux/vfio.h |    3 +++

> I think with your first option we arrive at something like this:
> 
> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> index dda1726adda8..b5609a411139 100644
> --- a/drivers/vfio/vfio.c
> +++ b/drivers/vfio/vfio.c
> @@ -883,14 +883,15 @@ static struct vfio_device *vfio_device_get_from_name(struct vfio_group *group,
>  
>  		if (it->ops->match) {
>  			ret = it->ops->match(it->device_data, buf);
> -			if (ret < 0 && ret != -ENODEV) {
> +			if (ret < 0) {
>  				device = ERR_PTR(ret);
>  				break;
>  			}
> -		} else
> -			ret = strcmp(dev_name(it->dev), buf);
> +		} else {
> +			ret = !strcmp(dev_name(it->dev), buf);
> +		}
>  
> -		if (!ret) {
> +		if (ret) {
>  			device = it;
>  			vfio_device_get(device);
>  			break;
> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> index 755e0f0e2900..029694b977f2 100644
> --- a/include/linux/vfio.h
> +++ b/include/linux/vfio.h
> @@ -26,8 +26,9 @@
>   *         operations documented below
>   * @mmap: Perform mmap(2) on a region of the device file descriptor
>   * @request: Request for the bus driver to release the device
> - * @match: Optional device name match callback (return: 0 for match, -ENODEV
> - *         (or >0) for no match and continue, other -errno: no match and stop)
> + * @match: Optional device name match callback (return: 0 for no-match, >0 for
> + *         match, -errno for abort (ex. match with insufficient or incorrect
> + *         additional args)
>   */
>  struct vfio_device_ops {
>  	char	*name;
> 
> 
> I like that.  Thanks,
> 
> Alex

Looks good to me.

