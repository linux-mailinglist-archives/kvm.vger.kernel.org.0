Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94CC44A601A
	for <lists+kvm@lfdr.de>; Tue,  1 Feb 2022 16:28:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240470AbiBAP21 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Feb 2022 10:28:27 -0500
Received: from foss.arm.com ([217.140.110.172]:46966 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240366AbiBAP2Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Feb 2022 10:28:16 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9FB31113E;
        Tue,  1 Feb 2022 07:28:16 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BD8B33F40C;
        Tue,  1 Feb 2022 07:28:15 -0800 (PST)
Date:   Tue, 1 Feb 2022 15:28:24 +0000
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Martin Radev <martin.b.radev@gmail.com>
Cc:     kvm@vger.kernel.org, will@kernel.org, julien.thierry.kdev@gmail.com
Subject: Re: [PATCH kvmtool 2/5] virtio: Check for overflows in QUEUE_NOTIFY
 and QUEUE_SEL
Message-ID: <YflReAK5Ui+mlLNr@monolith.localdoman>
References: <cover.1642457047.git.martin.b.radev@gmail.com>
 <bd5048ca2de1c548fa599d12fea0fa21397688af.1642457047.git.martin.b.radev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bd5048ca2de1c548fa599d12fea0fa21397688af.1642457047.git.martin.b.radev@gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Martin,

On Tue, Jan 18, 2022 at 12:12:00AM +0200, Martin Radev wrote:
> This patch checks for overflows in QUEUE_NOTIFY and QUEUE_SEL in
> the PCI and MMIO operation handling paths. Further, the return
> value type of get_vq_count is changed from int to u32 since negative
> doesn't carry any semantic meaning.
> 
> Signed-off-by: Martin Radev <martin.b.radev@gmail.com>
> ---
>  include/kvm/virtio.h |  2 +-
>  virtio/9p.c          |  2 +-
>  virtio/balloon.c     |  2 +-
>  virtio/blk.c         |  2 +-
>  virtio/console.c     |  2 +-
>  virtio/mmio.c        | 25 ++++++++++++++++++++++---
>  virtio/net.c         |  2 +-
>  virtio/pci.c         | 21 ++++++++++++++++++---
>  virtio/rng.c         |  2 +-
>  virtio/scsi.c        |  2 +-
>  virtio/vsock.c       |  2 +-
>  11 files changed, 49 insertions(+), 15 deletions(-)
> 
> diff --git a/include/kvm/virtio.h b/include/kvm/virtio.h
> index 3880e74..40f2a6d 100644
> --- a/include/kvm/virtio.h
> +++ b/include/kvm/virtio.h
> @@ -187,7 +187,7 @@ struct virtio_ops {
>  	size_t (*get_config_size)(struct kvm *kvm, void *dev);
>  	u32 (*get_host_features)(struct kvm *kvm, void *dev);
>  	void (*set_guest_features)(struct kvm *kvm, void *dev, u32 features);
> -	int (*get_vq_count)(struct kvm *kvm, void *dev);
> +	u32 (*get_vq_count)(struct kvm *kvm, void *dev);
>  	int (*init_vq)(struct kvm *kvm, void *dev, u32 vq, u32 page_size,
>  		       u32 align, u32 pfn);
>  	void (*exit_vq)(struct kvm *kvm, void *dev, u32 vq);
> diff --git a/virtio/9p.c b/virtio/9p.c
> index 89bec5e..8f1fc1f 100644
> --- a/virtio/9p.c
> +++ b/virtio/9p.c
> @@ -1468,7 +1468,7 @@ static int set_size_vq(struct kvm *kvm, void *dev, u32 vq, int size)
>  	return size;
>  }
>  
> -static int get_vq_count(struct kvm *kvm, void *dev)
> +static u32 get_vq_count(struct kvm *kvm, void *dev)
>  {
>  	return NUM_VIRT_QUEUES;
>  }
> diff --git a/virtio/balloon.c b/virtio/balloon.c
> index 233a3a5..de3882e 100644
> --- a/virtio/balloon.c
> +++ b/virtio/balloon.c
> @@ -249,7 +249,7 @@ static int set_size_vq(struct kvm *kvm, void *dev, u32 vq, int size)
>  	return size;
>  }
>  
> -static int get_vq_count(struct kvm *kvm, void *dev)
> +static u32 get_vq_count(struct kvm *kvm, void *dev)
>  {
>  	return NUM_VIRT_QUEUES;
>  }
> diff --git a/virtio/blk.c b/virtio/blk.c
> index 9164b51..46918a4 100644
> --- a/virtio/blk.c
> +++ b/virtio/blk.c
> @@ -289,7 +289,7 @@ static int set_size_vq(struct kvm *kvm, void *dev, u32 vq, int size)
>  	return size;
>  }
>  
> -static int get_vq_count(struct kvm *kvm, void *dev)
> +static u32 get_vq_count(struct kvm *kvm, void *dev)
>  {
>  	return NUM_VIRT_QUEUES;
>  }
> diff --git a/virtio/console.c b/virtio/console.c
> index 00bafa2..84466d0 100644
> --- a/virtio/console.c
> +++ b/virtio/console.c
> @@ -214,7 +214,7 @@ static int set_size_vq(struct kvm *kvm, void *dev, u32 vq, int size)
>  	return size;
>  }
>  
> -static int get_vq_count(struct kvm *kvm, void *dev)
> +static u32 get_vq_count(struct kvm *kvm, void *dev)
>  {
>  	return VIRTIO_CONSOLE_NUM_QUEUES;
>  }
> diff --git a/virtio/mmio.c b/virtio/mmio.c
> index 32bba17..fd9a411 100644
> --- a/virtio/mmio.c
> +++ b/virtio/mmio.c
> @@ -171,14 +171,26 @@ static void virtio_mmio_config_out(struct kvm_cpu *vcpu,
>  	struct virtio_mmio *vmmio = vdev->virtio;
>  	struct kvm *kvm = vmmio->kvm;
>  	u32 val = 0;
> +	u32 vq_count = 0;
> +	vq_count = vdev->ops->get_vq_count(kvm, vmmio->dev);
>  
>  	switch (addr) {
>  	case VIRTIO_MMIO_HOST_FEATURES_SEL:
>  	case VIRTIO_MMIO_GUEST_FEATURES_SEL:
> -	case VIRTIO_MMIO_QUEUE_SEL:
>  		val = ioport__read32(data);
>  		*(u32 *)(((void *)&vmmio->hdr) + addr) = val;
>  		break;
> +	case VIRTIO_MMIO_QUEUE_SEL:
> +		{

The braces aren't necessary here.

> +			val = ioport__read32(data);
> +			if (val >= vq_count) {
> +				pr_warning("QUEUE_SEL value (%u) is larger than VQ count (%u)\n",
> +					val, vq_count);
> +				break;
> +			}
> +			*(u32 *)(((void *)&vmmio->hdr) + addr) = val;
> +			break;
> +		}
>  	case VIRTIO_MMIO_STATUS:
>  		vmmio->hdr.status = ioport__read32(data);
>  		if (!vmmio->hdr.status) /* Sample endianness on reset */
> @@ -222,6 +234,11 @@ static void virtio_mmio_config_out(struct kvm_cpu *vcpu,
>  		break;
>  	case VIRTIO_MMIO_QUEUE_NOTIFY:
>  		val = ioport__read32(data);
> +		if (val > vq_count) {

"The driver notifies the device about new buffers being available in a queue by
writing the index of the updated queue to QueueNotify".

Shouldn't the inequality be val >= vq_count, as the maximum queue index is
vq_count - 1? This is also how virtio-pci does the check for
VIRTIO_PCI_QUEUE_NOTIFY.

> +			pr_warning("QUEUE_NOTIFY value (%u) is larger than VQ count (%u)\n",
> +				val, vq_count);
> +			break;
> +		}
>  		vdev->ops->notify_vq(vmmio->kvm, vmmio->dev, val);
>  		break;
>  	case VIRTIO_MMIO_INTERRUPT_ACK:
> @@ -341,10 +358,12 @@ int virtio_mmio_init(struct kvm *kvm, void *dev, struct virtio_device *vdev,
>  
>  int virtio_mmio_reset(struct kvm *kvm, struct virtio_device *vdev)
>  {
> -	int vq;
> +	u32 vq;
>  	struct virtio_mmio *vmmio = vdev->virtio;
> +	u32 vq_count;
>  
> -	for (vq = 0; vq < vdev->ops->get_vq_count(kvm, vmmio->dev); vq++)
> +	vq_count = vdev->ops->get_vq_count(kvm, vmmio->dev);
> +	for (vq = 0; vq < vq_count; vq++)

Why this change?

Thanks,
Alex

>  		virtio_mmio_exit_vq(kvm, vdev, vq);
>  
>  	return 0;
> diff --git a/virtio/net.c b/virtio/net.c
> index 75d9ae5..9a25bfa 100644
> --- a/virtio/net.c
> +++ b/virtio/net.c
> @@ -753,7 +753,7 @@ static int set_size_vq(struct kvm *kvm, void *dev, u32 vq, int size)
>  	return size;
>  }
>  
> -static int get_vq_count(struct kvm *kvm, void *dev)
> +static u32 get_vq_count(struct kvm *kvm, void *dev)
>  {
>  	struct net_dev *ndev = dev;
>  
> diff --git a/virtio/pci.c b/virtio/pci.c
> index 50fdaa4..60ae2cb 100644
> --- a/virtio/pci.c
> +++ b/virtio/pci.c
> @@ -308,9 +308,11 @@ static bool virtio_pci__data_out(struct kvm_cpu *vcpu, struct virtio_device *vde
>  	struct virtio_pci *vpci;
>  	struct kvm *kvm;
>  	u32 val;
> +	u32 vq_count;
>  
>  	kvm = vcpu->kvm;
>  	vpci = vdev->virtio;
> +	vq_count = vdev->ops->get_vq_count(kvm, vpci->dev);
>  
>  	switch (offset) {
>  	case VIRTIO_PCI_GUEST_FEATURES:
> @@ -330,10 +332,21 @@ static bool virtio_pci__data_out(struct kvm_cpu *vcpu, struct virtio_device *vde
>  		}
>  		break;
>  	case VIRTIO_PCI_QUEUE_SEL:
> -		vpci->queue_selector = ioport__read16(data);
> +		val = ioport__read16(data);
> +		if (val >= vq_count) {
> +			pr_warning("QUEUE_SEL value (%u) is larger than VQ count (%u)\n",
> +				val, vq_count);
> +			return false;
> +		}
> +		vpci->queue_selector = val;
>  		break;
>  	case VIRTIO_PCI_QUEUE_NOTIFY:
>  		val = ioport__read16(data);
> +		if (val >= vq_count) {
> +			pr_warning("QUEUE_SEL value (%u) is larger than VQ count (%u)\n",
> +				val, vq_count);
> +			return false;
> +		}
>  		vdev->ops->notify_vq(kvm, vpci->dev, val);
>  		break;
>  	case VIRTIO_PCI_STATUS:
> @@ -626,10 +639,12 @@ int virtio_pci__init(struct kvm *kvm, void *dev, struct virtio_device *vdev,
>  
>  int virtio_pci__reset(struct kvm *kvm, struct virtio_device *vdev)
>  {
> -	int vq;
> +	u32 vq;
>  	struct virtio_pci *vpci = vdev->virtio;
> +	u32 vq_count;
>  
> -	for (vq = 0; vq < vdev->ops->get_vq_count(kvm, vpci->dev); vq++)
> +	vq_count = vdev->ops->get_vq_count(kvm, vpci->dev);
> +	for (vq = 0; vq < vq_count; vq++)
>  		virtio_pci_exit_vq(kvm, vdev, vq);
>  
>  	return 0;
> diff --git a/virtio/rng.c b/virtio/rng.c
> index c7835a0..d9b9e68 100644
> --- a/virtio/rng.c
> +++ b/virtio/rng.c
> @@ -147,7 +147,7 @@ static int set_size_vq(struct kvm *kvm, void *dev, u32 vq, int size)
>  	return size;
>  }
>  
> -static int get_vq_count(struct kvm *kvm, void *dev)
> +static u32 get_vq_count(struct kvm *kvm, void *dev)
>  {
>  	return NUM_VIRT_QUEUES;
>  }
> diff --git a/virtio/scsi.c b/virtio/scsi.c
> index 37418f8..cdf553d 100644
> --- a/virtio/scsi.c
> +++ b/virtio/scsi.c
> @@ -174,7 +174,7 @@ static int set_size_vq(struct kvm *kvm, void *dev, u32 vq, int size)
>  	return size;
>  }
>  
> -static int get_vq_count(struct kvm *kvm, void *dev)
> +static u32 get_vq_count(struct kvm *kvm, void *dev)
>  {
>  	return NUM_VIRT_QUEUES;
>  }
> diff --git a/virtio/vsock.c b/virtio/vsock.c
> index 2df04d7..7d523df 100644
> --- a/virtio/vsock.c
> +++ b/virtio/vsock.c
> @@ -202,7 +202,7 @@ static void notify_vq_gsi(struct kvm *kvm, void *dev, u32 vq, u32 gsi)
>  		die_perror("VHOST_SET_VRING_CALL failed");
>  }
>  
> -static int get_vq_count(struct kvm *kvm, void *dev)
> +static u32 get_vq_count(struct kvm *kvm, void *dev)
>  {
>  	return VSOCK_VQ_MAX;
>  }
> -- 
> 2.25.1
> 
