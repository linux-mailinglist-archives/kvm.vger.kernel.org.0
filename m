Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CFC215C370
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2020 16:44:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729423AbgBMPlT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Feb 2020 10:41:19 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:39227 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729110AbgBMPlS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Feb 2020 10:41:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581608477;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+ek7ovueQ1Zw26uD1wE6yB4d2TtRDHlkQXfHHqxBETA=;
        b=Rd0bRQzgtTD8VbCV8w1t0GbfoiWld97aFLDMhKiqBNuZH5Av6LrtyaS3xQs+MdnY4fv8YL
        GHuzwVy8cb0n6sQxmyszwXGrmz1c+s7PIuv/y3tcQZ4ZxIuhSBDJu3y1o4qmkxLxgl6Mcz
        /slilF5++Pawhj+uj67YWWBHHnYe7FM=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-208-TcLBRPy8P9S2ozb7Qj_K1g-1; Thu, 13 Feb 2020 10:41:15 -0500
X-MC-Unique: TcLBRPy8P9S2ozb7Qj_K1g-1
Received: by mail-qt1-f200.google.com with SMTP id p12so3886316qtu.6
        for <kvm@vger.kernel.org>; Thu, 13 Feb 2020 07:41:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=+ek7ovueQ1Zw26uD1wE6yB4d2TtRDHlkQXfHHqxBETA=;
        b=MGIh0olPJ4LF+ZvKEOSzudryK9mo93E6ww2/zXU+m3k6TWt14nnmj8MJKuqFOyyDNn
         tu0ZTAVE/0hqpGSOqi6vqLpZbZJIM4h/92NfvvF2TstTjC5FRwxpH1Is0XmwS7rId0GQ
         eM2NJFInc0VNlyqXC0sqtX2r3ds1RRVzy1YUD14svOtikj2wSi1/Yhvz4es9aZ7V04XJ
         pcM3tLSMsGZcxEuODz6pVXC55qES5eUhUOZ9RPhgL0y4dxEMazDt0EGXm/cbJhpTTapu
         37JPx68qU6f4CFm0a6lHIqwWCWjgNWsRMrVwBSRGb1phhKSpxCQrWrAUwRYY2UoRS7t4
         1lxg==
X-Gm-Message-State: APjAAAXzdCFGC1Doe1FPAWQxaXX86wBblI387FwKs/f4/WSSQlmsgvuG
        MaFPBUkXGKL7Ep7dupFdPOzIyx1Q7JICGt79FXTzigZ8qJ5VU148umCjQAmXuyl0qJqAXSIA5aD
        cp9a0pW0T/xo0
X-Received: by 2002:ac8:73c7:: with SMTP id v7mr12288241qtp.269.1581608474718;
        Thu, 13 Feb 2020 07:41:14 -0800 (PST)
X-Google-Smtp-Source: APXvYqxuqtb2eDuJSUZlrEktyKz5ywe6U44aZfk5M0ldus3W3zRLJxwzeEMRVv8ZApy9boqdJBD+1Q==
X-Received: by 2002:ac8:73c7:: with SMTP id v7mr12288206qtp.269.1581608474439;
        Thu, 13 Feb 2020 07:41:14 -0800 (PST)
Received: from redhat.com (bzq-79-176-28-95.red.bezeqint.net. [79.176.28.95])
        by smtp.gmail.com with ESMTPSA id x41sm1711309qtj.52.2020.02.13.07.41.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Feb 2020 07:41:13 -0800 (PST)
Date:   Thu, 13 Feb 2020 10:41:06 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Gunthorpe <jgg@mellanox.com>
Cc:     Jason Wang <jasowang@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, tiwei.bie@intel.com,
        maxime.coquelin@redhat.com, cunming.liang@intel.com,
        zhihong.wang@intel.com, rob.miller@broadcom.com,
        xiao.w.wang@intel.com, haotian.wang@sifive.com,
        lingshan.zhu@intel.com, eperezma@redhat.com, lulu@redhat.com,
        parav@mellanox.com, kevin.tian@intel.com, stefanha@redhat.com,
        rdunlap@infradead.org, hch@infradead.org, aadam@redhat.com,
        jiri@mellanox.com, shahafs@mellanox.com, hanand@xilinx.com,
        mhabets@solarflare.com
Subject: Re: [PATCH V2 3/5] vDPA: introduce vDPA bus
Message-ID: <20200213103714-mutt-send-email-mst@kernel.org>
References: <20200210035608.10002-1-jasowang@redhat.com>
 <20200210035608.10002-4-jasowang@redhat.com>
 <20200211134746.GI4271@mellanox.com>
 <cf7abcc9-f8ef-1fe2-248e-9b9028788ade@redhat.com>
 <20200212125108.GS4271@mellanox.com>
 <12775659-1589-39e4-e344-b7a2c792b0f3@redhat.com>
 <20200213134128.GV4271@mellanox.com>
 <ebaea825-5432-65e2-2ab3-720a8c4030e7@redhat.com>
 <20200213150542.GW4271@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200213150542.GW4271@mellanox.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 13, 2020 at 11:05:42AM -0400, Jason Gunthorpe wrote:
> On Thu, Feb 13, 2020 at 10:58:44PM +0800, Jason Wang wrote:
> > 
> > On 2020/2/13 下午9:41, Jason Gunthorpe wrote:
> > > On Thu, Feb 13, 2020 at 11:34:10AM +0800, Jason Wang wrote:
> > > 
> > > > >    You have dev, type or
> > > > > class to choose from. Type is rarely used and doesn't seem to be used
> > > > > by vdpa, so class seems the right choice
> > > > > 
> > > > > Jason
> > > > Yes, but my understanding is class and bus are mutually exclusive. So we
> > > > can't add a class to a device which is already attached on a bus.
> > > While I suppose there are variations, typically 'class' devices are
> > > user facing things and 'bus' devices are internal facing (ie like a
> > > PCI device)
> > 
> > 
> > Though all vDPA devices have the same programming interface, but the
> > semantic is different. So it looks to me that use bus complies what
> > class.rst said:
> > 
> > "
> > 
> > Each device class defines a set of semantics and a programming interface
> > that devices of that class adhere to. Device drivers are the
> > implementation of that programming interface for a particular device on
> > a particular bus.
> > 
> > "
> 
> Here we are talking about the /dev/XX node that provides the
> programming interface. All the vdpa devices have the same basic
> chardev interface and discover any semantic variations 'in band'
> 
> > > So why is this using a bus? VDPA is a user facing object, so the
> > > driver should create a class vhost_vdpa device directly, and that
> > > driver should live in the drivers/vhost/ directory.
> >  
> > This is because we want vDPA to be generic for being used by different
> > drivers which is not limited to vhost-vdpa. E.g in this series, it allows
> > vDPA to be used by kernel virtio drivers. And in the future, we will
> > probably introduce more drivers in the future.
> 
> I don't see how that connects with using a bus.
> 
> Every class of virtio traffic is going to need a special HW driver to
> enable VDPA, that special driver can create the correct vhost side
> class device.


That's just a ton of useless code duplication, and a good chance
to have minor variations in implementations confusing
userspace.

Instead, each device implement the same interface, and then
vhost sits on top.

> > > For the PCI VF case this driver would bind to a PCI device like
> > > everything else
> > > 
> > > For our future SF/ADI cases the driver would bind to some
> > > SF/ADI/whatever device on a bus.
> > 
> > All these driver will still be bound to their own bus (PCI or other). And
> > what the driver needs is to present a vDPA device to virtual vDPA bus on
> > top.
> 
> Again, I can't see any reason to inject a 'vdpa virtual bus' on
> top. That seems like mis-using the driver core.
> 
> Jason

That bus is exactly what Greg KH proposed. There are other ways
to solve this I guess but this bikeshedding is getting tiring.
Come on it's an internal kernel interface, if we feel
it was a wrong direction to take we can change our minds later.
Main thing is getting UAPI right.

-- 
MST

