Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2423DE48B2
	for <lists+kvm@lfdr.de>; Fri, 25 Oct 2019 12:41:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394402AbfJYKlF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Oct 2019 06:41:05 -0400
Received: from foss.arm.com ([217.140.110.172]:38784 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730471AbfJYKlE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Oct 2019 06:41:04 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0102A1FB;
        Fri, 25 Oct 2019 03:41:04 -0700 (PDT)
Received: from donnerap.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 663333F6C4;
        Fri, 25 Oct 2019 03:41:03 -0700 (PDT)
Date:   Fri, 25 Oct 2019 11:41:00 +0100
From:   Andre Przywara <andre.przywara@arm.com>
To:     Will Deacon <will@kernel.org>
Cc:     kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>
Subject: Re: [PATCH kvmtool] virtio: Ensure virt_queue is always initialised
Message-ID: <20191025114100.70238d61@donnerap.cambridge.arm.com>
In-Reply-To: <20191010142852.15437-1-will@kernel.org>
References: <20191010142852.15437-1-will@kernel.org>
Organization: ARM
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; aarch64-unknown-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 10 Oct 2019 15:28:52 +0100
Will Deacon <will@kernel.org> wrote:

Hi Will,

> Failing to initialise the virt_queue via virtio_init_device_vq() leaves,
> amongst other things, the endianness unspecified. On arm/arm64 this
> results in virtio_guest_to_host_uxx() treating the queue as big-endian
> and trying to translate bogus addresses:
> 
>   Warning: unable to translate guest address 0x80b8249800000000 to host

Ouch, a user! ;-)

> Ensure the virt_queue is always initialised by the virtio device during
> setup.

Indeed, this is also what the other virtio devices do.
Confirmed to fix rng and balloon.

Thanks for spotting this!

Reviewed-by: Andre Przywara <andre.przywara@arm.com>
Tested-by: Andre Przywara <andre.przywara@arm.com>

Cheers,
Andre.

> 
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Julien Thierry <julien.thierry.kdev@gmail.com>
> Cc: Andre Przywara <andre.przywara@arm.com>
> Signed-off-by: Will Deacon <will@kernel.org>
> ---
>  virtio/balloon.c | 1 +
>  virtio/rng.c     | 1 +
>  virtio/scsi.c    | 1 +
>  3 files changed, 3 insertions(+)
> 
> diff --git a/virtio/balloon.c b/virtio/balloon.c
> index 15a9a46e77e0..0bd16703dfee 100644
> --- a/virtio/balloon.c
> +++ b/virtio/balloon.c
> @@ -212,6 +212,7 @@ static int init_vq(struct kvm *kvm, void *dev, u32 vq, u32 page_size, u32 align,
>  
>  	thread_pool__init_job(&bdev->jobs[vq], kvm, virtio_bln_do_io, queue);
>  	vring_init(&queue->vring, VIRTIO_BLN_QUEUE_SIZE, p, align);
> +	virtio_init_device_vq(&bdev->vdev, queue);
>  
>  	return 0;
>  }
> diff --git a/virtio/rng.c b/virtio/rng.c
> index 9dd757b7e6e9..78eaa64bda17 100644
> --- a/virtio/rng.c
> +++ b/virtio/rng.c
> @@ -103,6 +103,7 @@ static int init_vq(struct kvm *kvm, void *dev, u32 vq, u32 page_size, u32 align,
>  	job = &rdev->jobs[vq];
>  
>  	vring_init(&queue->vring, VIRTIO_RNG_QUEUE_SIZE, p, align);
> +	virtio_init_device_vq(&rdev->vdev, queue);
>  
>  	*job = (struct rng_dev_job) {
>  		.vq	= queue,
> diff --git a/virtio/scsi.c b/virtio/scsi.c
> index a72bb2a9a206..1ec78fe0945a 100644
> --- a/virtio/scsi.c
> +++ b/virtio/scsi.c
> @@ -72,6 +72,7 @@ static int init_vq(struct kvm *kvm, void *dev, u32 vq, u32 page_size, u32 align,
>  	p		= virtio_get_vq(kvm, queue->pfn, page_size);
>  
>  	vring_init(&queue->vring, VIRTIO_SCSI_QUEUE_SIZE, p, align);
> +	virtio_init_device_vq(&sdev->vdev, queue);
>  
>  	if (sdev->vhost_fd == 0)
>  		return 0;

