Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32BDE41B3DE
	for <lists+kvm@lfdr.de>; Tue, 28 Sep 2021 18:27:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241792AbhI1Q30 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Sep 2021 12:29:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:59886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241768AbhI1Q3Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Sep 2021 12:29:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 636A360EE9;
        Tue, 28 Sep 2021 16:27:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632846466;
        bh=pxmRZz6UdCKyo/pIVTPGaxM9qJvC87Qcki0mcSQG0Gc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QOZ1Eyxws/1pmJeQ1d8Rz+AAw2zaFbTsRdmGXgZ0EuuCNMAnvjr0hvhZkhJZYEjfj
         uW8aT2SBMEBI6njSafdsdsdK2Np+fmUeCOChkM6Tp/gt5QnJTmiUg0/vjJE+k6yUIE
         VNiZh45LgC+8EhnSmzhPQzliLswMH2tgkFYLGahoPXXexWTnU6J7KKKL8jC82GzVRR
         57UETot+3TQaJmhd1ITCbcBIcMkDwZAjD1hX0uVIIA+GVmMh9e+GKb1nuSBOtvX76c
         0ZuADBIy+RtZmPDHKonWSA3KftxSaj8l94/qhoO58dfGzRDH1m2Dx0TA+IDh/jt3GK
         QjdJG113AplqA==
Date:   Tue, 28 Sep 2021 19:27:42 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Max Gurtovoy <mgurtovoy@nvidia.com>
Cc:     mst@redhat.com, virtualization@lists.linux-foundation.org,
        kvm@vger.kernel.org, stefanha@redhat.com, oren@nvidia.com,
        nitzanc@nvidia.com, israelr@nvidia.com, hch@infradead.org,
        linux-block@vger.kernel.org, axboe@kernel.dk,
        Yaron Gepstein <yarong@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: [PATCH 2/2] virtio-blk: set NUMA affinity for a tagset
Message-ID: <YVNCflMxWh4m7ewU@unreal>
References: <20210926145518.64164-1-mgurtovoy@nvidia.com>
 <20210926145518.64164-2-mgurtovoy@nvidia.com>
 <YVGsMsIjD2+aS3eC@unreal>
 <0c155679-e1db-3d1e-2b4e-a0f12ce5950c@nvidia.com>
 <YVIMIFxjRcfDDub4@unreal>
 <f8de7c19-9f04-a458-6c1d-8133a83aa93f@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f8de7c19-9f04-a458-6c1d-8133a83aa93f@nvidia.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 28, 2021 at 06:59:15PM +0300, Max Gurtovoy wrote:
> 
> On 9/27/2021 9:23 PM, Leon Romanovsky wrote:
> > On Mon, Sep 27, 2021 at 08:25:09PM +0300, Max Gurtovoy wrote:
> > > On 9/27/2021 2:34 PM, Leon Romanovsky wrote:
> > > > On Sun, Sep 26, 2021 at 05:55:18PM +0300, Max Gurtovoy wrote:
> > > > > To optimize performance, set the affinity of the block device tagset
> > > > > according to the virtio device affinity.
> > > > > 
> > > > > Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
> > > > > ---
> > > > >    drivers/block/virtio_blk.c | 2 +-
> > > > >    1 file changed, 1 insertion(+), 1 deletion(-)
> > > > > 
> > > > > diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
> > > > > index 9b3bd083b411..1c68c3e0ebf9 100644
> > > > > --- a/drivers/block/virtio_blk.c
> > > > > +++ b/drivers/block/virtio_blk.c
> > > > > @@ -774,7 +774,7 @@ static int virtblk_probe(struct virtio_device *vdev)
> > > > >    	memset(&vblk->tag_set, 0, sizeof(vblk->tag_set));
> > > > >    	vblk->tag_set.ops = &virtio_mq_ops;
> > > > >    	vblk->tag_set.queue_depth = queue_depth;
> > > > > -	vblk->tag_set.numa_node = NUMA_NO_NODE;
> > > > > +	vblk->tag_set.numa_node = virtio_dev_to_node(vdev);
> > > > I afraid that by doing it, you will increase chances to see OOM, because
> > > > in NUMA_NO_NODE, MM will try allocate memory in whole system, while in
> > > > the latter mode only on specific NUMA which can be depleted.
> > > This is a common methodology we use in the block layer and in NVMe subsystem
> > > and we don't afraid of the OOM issue you raised.
> > There are many reasons for that, but we are talking about virtio here
> > and not about NVMe.
> 
> Ok. what reasons ?

For example, NVMe are physical devices that rely on DMA operations,
PCI connectivity e.t.c to operate. Such systems indeed can benefit from
NUMA locality hints. At the end, these devices are physically connected
to that NUMA node.

In our case, virtio-blk is a software interface that doesn't have all
these limitations. On the contrary, the virtio-blk can be created on one
CPU and moved later to be close to the QEMU which can run on another NUMA
node.

Also this patch increases chances to get OOM by factor of NUMA nodes.
Before your patch, the virtio_blk can allocate from X memory, after your
patch it will be X/NUMB_NUMA_NODES.

In addition, it has all chances to even hurt performance.

So yes, post v2, but as Stefan and I asked, please provide supportive
performance results, because what was done for another subsystem doesn't
mean that it will be applicable here.

Thanks
