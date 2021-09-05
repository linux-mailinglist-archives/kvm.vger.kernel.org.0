Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C209E400FCE
	for <lists+kvm@lfdr.de>; Sun,  5 Sep 2021 15:10:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233744AbhIENLM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 5 Sep 2021 09:11:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:35840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231917AbhIENLL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 5 Sep 2021 09:11:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8855D60F45;
        Sun,  5 Sep 2021 13:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630847408;
        bh=6R0PUe/Nldfy234Rj0kTE5wnvjhWU3jlHe4lOOg9EM0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fkUXo6sTgIvPZs1UAlTNxvcnjEU0QjYSwNW69nUy1GiDXPH3Vvh1rG8182NhIlmjm
         e6K3OtPTSaeZU0LV/LLXg+B/wCASRMB0PRjs93MOPUeLz9on0DfrG/u9YjXhXPBaUJ
         KRW7Ya1Pc5HyARZ20x1gEkJ6xD6Mlm4Z2hXg6CqbzhsStZdJ/UvOJiSD0TyZ4Cquyi
         7dC21adnc9KavFQ4eGKInvggKgY/5HiMleug0twNsTxX3LbrzJazWl57JQOJg1DQsA
         5Ez63Honh6Ek04gBY797cZlrFNAYGt/On7zH7k5VbZYbzSdnj2cxhohRimkQz0gRCy
         Mb57SlRwpfcAg==
Date:   Sun, 5 Sep 2021 16:10:04 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Max Gurtovoy <mgurtovoy@nvidia.com>
Cc:     Chaitanya Kulkarni <ckulkarnilinux@gmail.com>, hch@infradead.org,
        mst@redhat.com, virtualization@lists.linux-foundation.org,
        kvm@vger.kernel.org, stefanha@redhat.com, israelr@nvidia.com,
        nitzanc@nvidia.com, oren@nvidia.com, linux-block@vger.kernel.org,
        axboe@kernel.dk
Subject: Re: [PATCH v3 1/1] virtio-blk: add num_request_queues module
 parameter
Message-ID: <YTTBrD/0bHcyfNGm@unreal>
References: <20210902204622.54354-1-mgurtovoy@nvidia.com>
 <YTR12AHOGs1nhfz1@unreal>
 <b2e60035-2e63-3162-6222-d8c862526a28@gmail.com>
 <e4455133-ac9f-44d0-a07d-be55b336ebcc@nvidia.com>
 <YTSZpm1GZGT4BUDR@unreal>
 <5aada544-356f-5363-c6e4-6885e9812f82@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5aada544-356f-5363-c6e4-6885e9812f82@nvidia.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Sep 05, 2021 at 02:16:58PM +0300, Max Gurtovoy wrote:
> 
> On 9/5/2021 1:19 PM, Leon Romanovsky wrote:
> > On Sun, Sep 05, 2021 at 12:19:09PM +0300, Max Gurtovoy wrote:
> > > On 9/5/2021 11:49 AM, Chaitanya Kulkarni wrote:
> > > > On 9/5/2021 12:46 AM, Leon Romanovsky wrote:
> > > > > > +static unsigned int num_request_queues;
> > > > > > +module_param_cb(num_request_queues, &queue_count_ops,
> > > > > > &num_request_queues,
> > > > > > +        0644);
> > > > > > +MODULE_PARM_DESC(num_request_queues,
> > > > > > +         "Number of request queues to use for blk device.
> > > > > > Should > 0");
> > > > > > +
> > > > > Won't it limit all virtio block devices to the same limit?
> > > > > 
> > > > > It is very common to see multiple virtio-blk devices on the same system
> > > > > and they probably need different limits.
> > > > > 
> > > > > Thanks
> > > > 
> > > > Without looking into the code, that can be done adding a configfs
> > > > 
> > > > interface and overriding a global value (module param) when it is set
> > > > from
> > > > 
> > > > configfs.
> > > > 
> > > > 
> > > You have many ways to overcome this issue.
> > > 
> > > For example:
> > > 
> > > # ls -l /sys/block/vda/mq/
> > > drwxr-xr-x 18 root root 0 Sep  5 12:14 0
> > > drwxr-xr-x 18 root root 0 Sep  5 12:14 1
> > > drwxr-xr-x 18 root root 0 Sep  5 12:14 2
> > > drwxr-xr-x 18 root root 0 Sep  5 12:14 3
> > > 
> > > # echo virtio0 > /sys/bus/virtio/drivers/virtio_blk/unbind
> > > 
> > > # echo 8 > /sys/module/virtio_blk/parameters/num_request_queues
> > This is global to all virtio-blk devices.
> 
> You define a global module param but you bind/unbind a specific device.
> 
> Do you have a better way to control it ?

One of the possible solutions will be to extend virtio bus to allow
setting of such pre-probe parameters. However I don't know if it is
really worth doing it,

> 
> if the device is already probed, it's too late to change the queue_num.
> 
> 
> > 
> > > # echo virtio0 > /sys/bus/virtio/drivers/virtio_blk/bind
> > > 
> > > # ls -l /sys/block/vda/mq/
> > > drwxr-xr-x 10 root root 0 Sep  5 12:17 0
> > > drwxr-xr-x 10 root root 0 Sep  5 12:17 1
> > > drwxr-xr-x 10 root root 0 Sep  5 12:17 2
> > > drwxr-xr-x 10 root root 0 Sep  5 12:17 3
> > > drwxr-xr-x 10 root root 0 Sep  5 12:17 4
> > > drwxr-xr-x 10 root root 0 Sep  5 12:17 5
> > > drwxr-xr-x 10 root root 0 Sep  5 12:17 6
> > > drwxr-xr-x 10 root root 0 Sep  5 12:17 7
> > > 
> > > -Max.
> > > 
> > > 
