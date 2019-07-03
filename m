Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B1575E19F
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2019 12:07:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727004AbfGCKHg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Jul 2019 06:07:36 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:46779 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726473AbfGCKHd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Jul 2019 06:07:33 -0400
Received: by mail-wr1-f65.google.com with SMTP id n4so2049707wrw.13
        for <kvm@vger.kernel.org>; Wed, 03 Jul 2019 03:07:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=VNvFKH5K+pDMmuMUJ4DZzYn2K79WWFEugthw2tWzrCE=;
        b=W0YXFfzVo78uYxo6za87RCnqZ4SQylHtKmhCLa6Pzd0fnSGey5CWHsomUI/qxeDqn5
         RLbdfs5ZIrl1DDPeJC8CjCrnwBBEMl5fsB60sCX8YmPv7VrZ48rQjlq2c/uXcyPo/sPl
         emczbpRsxVdM1JyWUxIiLTTZ4GWLihxXCFzr8JO/jylFFxAV6HuJlgmY+XgN7m6t+gA/
         32Gtb3FJ0eG9W6VZu5fPeJ9xRKYBA4WEjWvmbdSrlrRp3vdMfXh4RrdzaCu/fYbeQa8V
         hzUAg6ZfTlxYMBBaTHTMJT4d2IU3Lq4PZr2JIgbuEsDWQuH6gIgevrc4QLILhkgFpqgY
         PUoQ==
X-Gm-Message-State: APjAAAUJmNtJlFmtoOQZTUSHPkxsyYOesNhjLcTM354EtGvTpi1SpmPz
        Nug0T5HdMETrVtZnGo7dtfJiyg==
X-Google-Smtp-Source: APXvYqzGzHZlSIMty2RhAvvB1Uo0isxGnCtD5XKYMHI9/IRY2pIO6xkm3T2evQoOaleJYQ+jY3ZeIw==
X-Received: by 2002:adf:dfc4:: with SMTP id q4mr27669596wrn.54.1562148450882;
        Wed, 03 Jul 2019 03:07:30 -0700 (PDT)
Received: from steredhat (host21-207-dynamic.52-79-r.retail.telecomitalia.it. [79.52.207.21])
        by smtp.gmail.com with ESMTPSA id z5sm1183115wmf.48.2019.07.03.03.07.29
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 03 Jul 2019 03:07:30 -0700 (PDT)
Date:   Wed, 3 Jul 2019 12:07:27 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Stefan Hajnoczi <stefanha@gmail.com>
Cc:     netdev@vger.kernel.org, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH v2 0/3] vsock/virtio: several fixes in the .probe() and
 .remove()
Message-ID: <20190703100727.kuwpyc5sksrgmoxb@steredhat>
References: <20190628123659.139576-1-sgarzare@redhat.com>
 <20190701151113.GE11900@stefanha-x1.localdomain>
 <20190701170357.jtuhy3ank7mv6izb@steredhat>
 <20190703091453.GA11844@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190703091453.GA11844@stefanha-x1.localdomain>
User-Agent: NeoMutt/20180716
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 03, 2019 at 10:14:53AM +0100, Stefan Hajnoczi wrote:
> On Mon, Jul 01, 2019 at 07:03:57PM +0200, Stefano Garzarella wrote:
> > On Mon, Jul 01, 2019 at 04:11:13PM +0100, Stefan Hajnoczi wrote:
> > > On Fri, Jun 28, 2019 at 02:36:56PM +0200, Stefano Garzarella wrote:
> > > > During the review of "[PATCH] vsock/virtio: Initialize core virtio vsock
> > > > before registering the driver", Stefan pointed out some possible issues
> > > > in the .probe() and .remove() callbacks of the virtio-vsock driver.
> > > > 
> > > > This series tries to solve these issues:
> > > > - Patch 1 adds RCU critical sections to avoid use-after-free of
> > > >   'the_virtio_vsock' pointer.
> > > > - Patch 2 stops workers before to call vdev->config->reset(vdev) to
> > > >   be sure that no one is accessing the device.
> > > > - Patch 3 moves the works flush at the end of the .remove() to avoid
> > > >   use-after-free of 'vsock' object.
> > > > 
> > > > v2:
> > > > - Patch 1: use RCU to protect 'the_virtio_vsock' pointer
> > > > - Patch 2: no changes
> > > > - Patch 3: flush works only at the end of .remove()
> > > > - Removed patch 4 because virtqueue_detach_unused_buf() returns all the buffers
> > > >   allocated.
> > > > 
> > > > v1: https://patchwork.kernel.org/cover/10964733/
> > > 
> > > This looks good to me.
> > 
> > Thanks for the review!
> > 
> > > 
> > > Did you run any stress tests?  For example an SMP guest constantly
> > > connecting and sending packets together with a script that
> > > hotplug/unplugs vhost-vsock-pci from the host side.
> > 
> > Yes, I started an SMP guest (-smp 4 -monitor tcp:127.0.0.1:1234,server,nowait)
> > and I run these scripts to stress the .probe()/.remove() path:
> > 
> > - guest
> >   while true; do
> >       cat /dev/urandom | nc-vsock -l 4321 > /dev/null &
> >       cat /dev/urandom | nc-vsock -l 5321 > /dev/null &
> >       cat /dev/urandom | nc-vsock -l 6321 > /dev/null &
> >       cat /dev/urandom | nc-vsock -l 7321 > /dev/null &
> >       wait
> >   done
> > 
> > - host
> >   while true; do
> >       cat /dev/urandom | nc-vsock 3 4321 > /dev/null &
> >       cat /dev/urandom | nc-vsock 3 5321 > /dev/null &
> >       cat /dev/urandom | nc-vsock 3 6321 > /dev/null &
> >       cat /dev/urandom | nc-vsock 3 7321 > /dev/null &
> >       sleep 2
> >       echo "device_del v1" | nc 127.0.0.1 1234
> >       sleep 1
> >       echo "device_add vhost-vsock-pci,id=v1,guest-cid=3" | nc 127.0.0.1 1234
> >       sleep 1
> >   done
> > 
> > Do you think is enough or is better to have a test more accurate?
> 
> That's good when left running overnight so that thousands of hotplug
> events are tested.

Honestly I run the test for ~30 mins (because without the patch the
crash happens in a few seconds), but of course, I'll run it this night :)

Thanks,
Stefano
