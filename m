Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60497400F0A
	for <lists+kvm@lfdr.de>; Sun,  5 Sep 2021 12:19:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237661AbhIEKU1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 5 Sep 2021 06:20:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:52950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237479AbhIEKUZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 5 Sep 2021 06:20:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BFD6460F6D;
        Sun,  5 Sep 2021 10:19:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630837162;
        bh=/Jh57FDF7CrbtrzmZhhQAoJJIYs9XIm6zMIp6uc03I4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LGOkSlYsfjfYCzvNWDsAXLFUTw4MXHcAbPPJaSS6T+C/zPFCmoGDJH4FSADcHgtN2
         jdLnZ1ZQmAUbB7IzaPrncqKD63Rzdy38Otwwlll5450iVoie0mONxCasnXVvqAbPZJ
         6wUvZCNOruamFIzSxZ8w6SMJtUM0HWNW6NjlfcDSuJAYryyutEq9sKZ6lVpeqQ5jTM
         0the62IXiYWnm7XKKsPeZIUoDH+JYhVig8h+MotCgRGTE01Fh/gAcGXTEMCURvgyCE
         Am+FNJdz/WZd6CZaDXhs7Rx+995i+f5hVXxDDNkKJaviTTGvUdrPQg9kuMn0wY+XDa
         Cpgts6xLPHsCA==
Date:   Sun, 5 Sep 2021 13:19:18 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Max Gurtovoy <mgurtovoy@nvidia.com>
Cc:     Chaitanya Kulkarni <ckulkarnilinux@gmail.com>, hch@infradead.org,
        mst@redhat.com, virtualization@lists.linux-foundation.org,
        kvm@vger.kernel.org, stefanha@redhat.com, israelr@nvidia.com,
        nitzanc@nvidia.com, oren@nvidia.com, linux-block@vger.kernel.org,
        axboe@kernel.dk
Subject: Re: [PATCH v3 1/1] virtio-blk: add num_request_queues module
 parameter
Message-ID: <YTSZpm1GZGT4BUDR@unreal>
References: <20210902204622.54354-1-mgurtovoy@nvidia.com>
 <YTR12AHOGs1nhfz1@unreal>
 <b2e60035-2e63-3162-6222-d8c862526a28@gmail.com>
 <e4455133-ac9f-44d0-a07d-be55b336ebcc@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e4455133-ac9f-44d0-a07d-be55b336ebcc@nvidia.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Sep 05, 2021 at 12:19:09PM +0300, Max Gurtovoy wrote:
> 
> On 9/5/2021 11:49 AM, Chaitanya Kulkarni wrote:
> > 
> > On 9/5/2021 12:46 AM, Leon Romanovsky wrote:
> > > > +static unsigned int num_request_queues;
> > > > +module_param_cb(num_request_queues, &queue_count_ops,
> > > > &num_request_queues,
> > > > +        0644);
> > > > +MODULE_PARM_DESC(num_request_queues,
> > > > +         "Number of request queues to use for blk device.
> > > > Should > 0");
> > > > +
> > > Won't it limit all virtio block devices to the same limit?
> > > 
> > > It is very common to see multiple virtio-blk devices on the same system
> > > and they probably need different limits.
> > > 
> > > Thanks
> > 
> > 
> > Without looking into the code, that can be done adding a configfs
> > 
> > interface and overriding a global value (module param) when it is set
> > from
> > 
> > configfs.
> > 
> > 
> You have many ways to overcome this issue.
> 
> For example:
> 
> # ls -l /sys/block/vda/mq/
> drwxr-xr-x 18 root root 0 Sep  5 12:14 0
> drwxr-xr-x 18 root root 0 Sep  5 12:14 1
> drwxr-xr-x 18 root root 0 Sep  5 12:14 2
> drwxr-xr-x 18 root root 0 Sep  5 12:14 3
> 
> # echo virtio0 > /sys/bus/virtio/drivers/virtio_blk/unbind
> 
> # echo 8 > /sys/module/virtio_blk/parameters/num_request_queues

This is global to all virtio-blk devices.

> 
> # echo virtio0 > /sys/bus/virtio/drivers/virtio_blk/bind
> 
> # ls -l /sys/block/vda/mq/
> drwxr-xr-x 10 root root 0 Sep  5 12:17 0
> drwxr-xr-x 10 root root 0 Sep  5 12:17 1
> drwxr-xr-x 10 root root 0 Sep  5 12:17 2
> drwxr-xr-x 10 root root 0 Sep  5 12:17 3
> drwxr-xr-x 10 root root 0 Sep  5 12:17 4
> drwxr-xr-x 10 root root 0 Sep  5 12:17 5
> drwxr-xr-x 10 root root 0 Sep  5 12:17 6
> drwxr-xr-x 10 root root 0 Sep  5 12:17 7
> 
> -Max.
> 
> 
