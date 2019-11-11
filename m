Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30836F712A
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2019 10:49:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726910AbfKKJtX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Nov 2019 04:49:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:57696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726768AbfKKJtX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Nov 2019 04:49:23 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E1664206C3;
        Mon, 11 Nov 2019 09:49:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573465762;
        bh=gNabya5j1CFBN/o4JOXgls+YOBZqNstKbkaeVu6qUX8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ncu7rCdzObqzGfjCEAga+VHdoCibWkdlqmjuO5oZ7KShXtlPgRL2AEuSAchbunpiH
         IfGtD69s49azMb7EWqdqVlrWokvz20/UnaDTlIWD0uVQHpNMitTAz9eD5gNqjvgpBB
         Q2GErzAIhCx+SfoYqtkixRw/QLnGHsZ9Xzp7giC8=
Date:   Mon, 11 Nov 2019 10:49:20 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     lantianyu1986@gmail.com
Cc:     alex.williamson@redhat.com, cohuck@redhat.com, kys@microsoft.com,
        haiyangz@microsoft.com, sthemmin@microsoft.com, sashal@kernel.org,
        mchehab+samsung@kernel.org, davem@davemloft.net, robh@kernel.org,
        Jonathan.Cameron@huawei.com, paulmck@linux.ibm.com,
        michael.h.kelley@microsoft.com,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-hyperv@vger.kernel.org, vkuznets@redhat.com
Subject: Re: [PATCH] VFIO/VMBUS: Add VFIO VMBUS driver support
Message-ID: <20191111094920.GA135867@kroah.com>
References: <20191111084507.9286-1-Tianyu.Lan@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191111084507.9286-1-Tianyu.Lan@microsoft.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 11, 2019 at 04:45:07PM +0800, lantianyu1986@gmail.com wrote:
> +#define DRIVER_VERSION	"0.0.1"

Never a need for DRIVER_VERSION as your driver just becomes part of the
main kernel tree, so please drop this.  We keep trying to delete these
types of numbers and they keep coming back...

> +static void
> +vfio_vmbus_new_channel(struct vmbus_channel *new_sc)
> +{
> +	struct hv_device *hv_dev = new_sc->primary_channel->device_obj;
> +	struct device *device = &hv_dev->device;
> +	int ret;
> +
> +	/* Create host communication ring */
> +	ret = vmbus_open(new_sc, HV_RING_SIZE, HV_RING_SIZE, NULL, 0,
> +			 vfio_vmbus_channel_cb, new_sc);
> +	if (ret) {
> +		dev_err(device, "vmbus_open subchannel failed: %d\n", ret);
> +		return;
> +	}
> +
> +	/* Disable interrupts on sub channel */
> +	new_sc->inbound.ring_buffer->interrupt_mask = 1;
> +	set_channel_read_mode(new_sc, HV_CALL_ISR);
> +
> +	ret = sysfs_create_bin_file(&new_sc->kobj, &ring_buffer_bin_attr);

No documentation on this new sysfs file?

And by creating it here, userspace is not notified of it, so tools will
not see it :(

> +	if (ret)
> +		dev_notice(&hv_dev->device,
> +			   "sysfs create ring bin file failed; %d\n", ret);

Doesn't the call spit out an error if something happens?

> +	ret = sysfs_create_bin_file(&channel->kobj, &ring_buffer_bin_attr);
> +	if (ret)
> +		dev_notice(&dev->device,
> +			   "sysfs create ring bin file failed; %d\n", ret);
> +

Again, don't create sysfs files on your own, the bus code should be
doing this for you automatically and in a way that is race-free.

thanks,

greg k-h
