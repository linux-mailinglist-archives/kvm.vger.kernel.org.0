Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68BCD2FF659
	for <lists+kvm@lfdr.de>; Thu, 21 Jan 2021 21:52:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726817AbhAUUv6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jan 2021 15:51:58 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38804 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726411AbhAUUvy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 21 Jan 2021 15:51:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611262228;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MtA/rotM7LM+Bn3G3T+jNqr3eNcqPFdB3Dx8FJkKl8I=;
        b=ZmUcDO6WWj78/H70tAz4c0iARLcqBySJSZEluYr1NGFmpaBX3Tw01he38+jdg7qZl/TLE/
        0LFdu1ihO+JzldG9fp4WpKOMY8dxhAIjaOcLA/8v2nbqttNu7kZ54HRjVa7xNWtZUl2A80
        /ZVLlVcDc80U2SaEw9kZ/8vPBAeBvTE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-7-Sl9xzLQdMp-zP7fumoqVkA-1; Thu, 21 Jan 2021 15:50:24 -0500
X-MC-Unique: Sl9xzLQdMp-zP7fumoqVkA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5B5C6800D55;
        Thu, 21 Jan 2021 20:50:22 +0000 (UTC)
Received: from omen.home.shazbot.org (ovpn-112-255.phx2.redhat.com [10.3.112.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A2CEF61F55;
        Thu, 21 Jan 2021 20:50:21 +0000 (UTC)
Date:   Thu, 21 Jan 2021 13:50:21 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Niklas Schnelle <schnelle@linux.ibm.com>
Cc:     Matthew Rosato <mjrosato@linux.ibm.com>, cohuck@redhat.com,
        pmorel@linux.ibm.com, borntraeger@de.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, gerald.schaefer@linux.ibm.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] vfio-pci/zdev: Introduce the zPCI I/O vfio region
Message-ID: <20210121135021.0eb7e873@omen.home.shazbot.org>
In-Reply-To: <90d99da8-02cf-e051-314b-2ab192f8fd57@linux.ibm.com>
References: <1611086550-32765-1-git-send-email-mjrosato@linux.ibm.com>
        <1611086550-32765-5-git-send-email-mjrosato@linux.ibm.com>
        <90d99da8-02cf-e051-314b-2ab192f8fd57@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 20 Jan 2021 14:21:59 +0100
Niklas Schnelle <schnelle@linux.ibm.com> wrote:

> On 1/19/21 9:02 PM, Matthew Rosato wrote:
> > Some s390 PCI devices (e.g. ISM) perform I/O operations that have very  
> .. snip ...
> > +
> > +static size_t vfio_pci_zdev_io_rw(struct vfio_pci_device *vdev,
> > +				  char __user *buf, size_t count,
> > +				  loff_t *ppos, bool iswrite)
> > +{  
> ... snip ...
> > +	/*
> > +	 * For now, the largest allowed block I/O is advertised as PAGE_SIZE,
> > +	 * and cannot exceed a page boundary - so a single page is enough.  The
> > +	 * guest should have validated this but let's double-check that the
> > +	 * request will not cross a page boundary.
> > +	 */
> > +	if (((region->req.gaddr & ~PAGE_MASK)
> > +			+ region->req.len - 1) & PAGE_MASK) {
> > +		return -EIO;
> > +	}
> > +
> > +	mutex_lock(&zdev->lock);  
> 
> I plan on using the zdev->lock for preventing concurrent zPCI devices
> removal/configuration state changes between zPCI availability/error
> events and enable_slot()/disable_slot() and /sys/bus/pci/devices/<dev>/recover.
> 
> With that use in place using it here causes a deadlock when doing 
> "echo 0 > /sys/bus/pci/slots/<fid>/power from the host for an ISM device
> attached to a guest.
> 
> This is because the (soft) hot unplug will cause vfio to notify QEMU, which
> sends a deconfiguration request to the guest, which then tries to
> gracefully shutdown the device. During that shutdown the device will
> be accessed, running into this code path which then blocks on
> the lock held by the disable_slot() code which waits on vfio
> releasing the device.
> 
> Alex may correct me if I'm wrong but I think instead vfio should
> be holding the PCI device lock via pci_device_lock(pdev).

There be dragons in device_lock, which is why we have all the crude
try-lock semantics in reset paths.  Don't use it trivially.  Device
lock is not necessary here otherwise, the device is bound to a driver
and has an open userspace file descriptor through which the user is
performing this access.  The device can't be removed without unbinding
the driver, which can't happen while the user still has open files to
it.  Thanks,

Alex

