Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07B7F4A5FF9
	for <lists+kvm@lfdr.de>; Tue,  1 Feb 2022 16:27:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240243AbiBAP1O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Feb 2022 10:27:14 -0500
Received: from foss.arm.com ([217.140.110.172]:46876 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240255AbiBAP1J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Feb 2022 10:27:09 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3F250113E;
        Tue,  1 Feb 2022 07:27:08 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5B3373F40C;
        Tue,  1 Feb 2022 07:27:07 -0800 (PST)
Date:   Tue, 1 Feb 2022 15:27:23 +0000
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Martin Radev <martin.b.radev@gmail.com>
Cc:     kvm@vger.kernel.org, will@kernel.org, julien.thierry.kdev@gmail.com
Subject: Re: [PATCH kvmtool 1/5] virtio: Sanitize config accesses
Message-ID: <YflRW6vnR+xItfFa@monolith.localdoman>
References: <cover.1642457047.git.martin.b.radev@gmail.com>
 <4a68381d2251d4bdbc0a31f0210f3e0f1c3d18ce.1642457047.git.martin.b.radev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4a68381d2251d4bdbc0a31f0210f3e0f1c3d18ce.1642457047.git.martin.b.radev@gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Martin,

I'm on shaky ground when it comes to the virtio spec, but I'll do my best
to review your patch.

On Tue, Jan 18, 2022 at 12:11:59AM +0200, Martin Radev wrote:
> The handling of VIRTIO_PCI_O_CONFIG is prone to buffer access overflows.
> This patch sanitizes this operation by using the newly added virtio op
> get_config_size. Any access which goes beyond the config structure's
> size is prevented and a failure is returned.
> 
> Signed-off-by: Martin Radev <martin.b.radev@gmail.com>
> ---
>  include/kvm/virtio-9p.h |  1 +
>  include/kvm/virtio.h    |  1 +
>  virtio/9p.c             | 19 ++++++++++++++++---
>  virtio/balloon.c        |  6 ++++++
>  virtio/blk.c            |  6 ++++++
>  virtio/console.c        |  6 ++++++
>  virtio/mmio.c           | 19 +++++++++++++++----
>  virtio/net.c            |  6 ++++++
>  virtio/pci.c            | 19 ++++++++++++++++++-
>  virtio/rng.c            |  6 ++++++
>  virtio/scsi.c           |  6 ++++++
>  virtio/vsock.c          |  6 ++++++
>  12 files changed, 93 insertions(+), 8 deletions(-)
> 
> diff --git a/include/kvm/virtio-9p.h b/include/kvm/virtio-9p.h
> index 3ea7698..77c5062 100644
> --- a/include/kvm/virtio-9p.h
> +++ b/include/kvm/virtio-9p.h
> @@ -44,6 +44,7 @@ struct p9_dev {
>  	struct virtio_device	vdev;
>  	struct rb_root		fids;
>  
> +	size_t config_size;
>  	struct virtio_9p_config	*config;
>  	u32			features;
>  
> diff --git a/include/kvm/virtio.h b/include/kvm/virtio.h
> index 3a311f5..3880e74 100644
> --- a/include/kvm/virtio.h
> +++ b/include/kvm/virtio.h
> @@ -184,6 +184,7 @@ struct virtio_device {
>  
>  struct virtio_ops {
>  	u8 *(*get_config)(struct kvm *kvm, void *dev);
> +	size_t (*get_config_size)(struct kvm *kvm, void *dev);
>  	u32 (*get_host_features)(struct kvm *kvm, void *dev);
>  	void (*set_guest_features)(struct kvm *kvm, void *dev, u32 features);
>  	int (*get_vq_count)(struct kvm *kvm, void *dev);
> diff --git a/virtio/9p.c b/virtio/9p.c
> index b78f2b3..89bec5e 100644
> --- a/virtio/9p.c
> +++ b/virtio/9p.c
> @@ -1375,6 +1375,12 @@ static u8 *get_config(struct kvm *kvm, void *dev)
>  	return ((u8 *)(p9dev->config));
>  }
>  
> +static size_t get_config_size(struct kvm *kvm, void *dev)
> +{
> +	struct p9_dev *p9dev = dev;
> +	return p9dev->config_size;
> +}
> +
>  static u32 get_host_features(struct kvm *kvm, void *dev)
>  {
>  	return 1 << VIRTIO_9P_MOUNT_TAG;
> @@ -1469,6 +1475,7 @@ static int get_vq_count(struct kvm *kvm, void *dev)
>  
>  struct virtio_ops p9_dev_virtio_ops = {
>  	.get_config		= get_config,
> +	.get_config_size	= get_config_size,
>  	.get_host_features	= get_host_features,
>  	.set_guest_features	= set_guest_features,
>  	.init_vq		= init_vq,
> @@ -1569,6 +1576,8 @@ int virtio_9p__register(struct kvm *kvm, const char *root, const char *tag_name)
>  {
>  	struct p9_dev *p9dev;
>  	int err = 0;
> +	size_t tag_name_length = 0;
> +	size_t config_size = 0;
>  
>  	p9dev = calloc(1, sizeof(*p9dev));
>  	if (!p9dev)
> @@ -1577,22 +1586,26 @@ int virtio_9p__register(struct kvm *kvm, const char *root, const char *tag_name)
>  	if (!tag_name)
>  		tag_name = VIRTIO_9P_DEFAULT_TAG;
>  
> -	p9dev->config = calloc(1, sizeof(*p9dev->config) + strlen(tag_name) + 1);
> +	tag_name_length = strlen(tag_name);
> +	config_size = sizeof(*p9dev->config) + tag_name_length + 1;
> +
> +	p9dev->config = calloc(1, config_size);
>  	if (p9dev->config == NULL) {
>  		err = -ENOMEM;
>  		goto free_p9dev;
>  	}
> +	p9dev->config_size = config_size;
>  
>  	strncpy(p9dev->root_dir, root, sizeof(p9dev->root_dir));
>  	p9dev->root_dir[sizeof(p9dev->root_dir)-1] = '\x00';
>  
> -	p9dev->config->tag_len = strlen(tag_name);
> +	p9dev->config->tag_len = tag_name_length;
>  	if (p9dev->config->tag_len > MAX_TAG_LEN) {
>  		err = -EINVAL;
>  		goto free_p9dev_config;
>  	}
>  
> -	memcpy(&p9dev->config->tag, tag_name, strlen(tag_name));
> +	memcpy(&p9dev->config->tag, tag_name, tag_name_length);
>  
>  	list_add(&p9dev->list, &devs);
>  
> diff --git a/virtio/balloon.c b/virtio/balloon.c
> index 8e8803f..233a3a5 100644
> --- a/virtio/balloon.c
> +++ b/virtio/balloon.c
> @@ -181,6 +181,11 @@ static u8 *get_config(struct kvm *kvm, void *dev)
>  	return ((u8 *)(&bdev->config));
>  }
>  
> +static size_t get_config_size(struct kvm *kvm, void *dev)
> +{
> +	return sizeof(struct virtio_balloon_config);
> +}
> +
>  static u32 get_host_features(struct kvm *kvm, void *dev)
>  {
>  	return 1 << VIRTIO_BALLOON_F_STATS_VQ;
> @@ -251,6 +256,7 @@ static int get_vq_count(struct kvm *kvm, void *dev)
>  
>  struct virtio_ops bln_dev_virtio_ops = {
>  	.get_config		= get_config,
> +	.get_config_size	= get_config_size,
>  	.get_host_features	= get_host_features,
>  	.set_guest_features	= set_guest_features,
>  	.init_vq		= init_vq,
> diff --git a/virtio/blk.c b/virtio/blk.c
> index 4d02d10..9164b51 100644
> --- a/virtio/blk.c
> +++ b/virtio/blk.c
> @@ -146,6 +146,11 @@ static u8 *get_config(struct kvm *kvm, void *dev)
>  	return ((u8 *)(&bdev->blk_config));
>  }
>  
> +static size_t get_config_size(struct kvm *kvm, void *dev)
> +{
> +	return sizeof(struct virtio_blk_config);
> +}
> +
>  static u32 get_host_features(struct kvm *kvm, void *dev)
>  {
>  	struct blk_dev *bdev = dev;
> @@ -291,6 +296,7 @@ static int get_vq_count(struct kvm *kvm, void *dev)
>  
>  static struct virtio_ops blk_dev_virtio_ops = {
>  	.get_config		= get_config,
> +	.get_config_size	= get_config_size,
>  	.get_host_features	= get_host_features,
>  	.set_guest_features	= set_guest_features,
>  	.get_vq_count		= get_vq_count,
> diff --git a/virtio/console.c b/virtio/console.c
> index e0b98df..00bafa2 100644
> --- a/virtio/console.c
> +++ b/virtio/console.c
> @@ -121,6 +121,11 @@ static u8 *get_config(struct kvm *kvm, void *dev)
>  	return ((u8 *)(&cdev->config));
>  }
>  
> +static size_t get_config_size(struct kvm *kvm, void *dev)
> +{
> +	return sizeof(struct virtio_console_config);
> +}
> +
>  static u32 get_host_features(struct kvm *kvm, void *dev)
>  {
>  	return 0;
> @@ -216,6 +221,7 @@ static int get_vq_count(struct kvm *kvm, void *dev)
>  
>  static struct virtio_ops con_dev_virtio_ops = {
>  	.get_config		= get_config,
> +	.get_config_size	= get_config_size,
>  	.get_host_features	= get_host_features,
>  	.set_guest_features	= set_guest_features,
>  	.get_vq_count		= get_vq_count,
> diff --git a/virtio/mmio.c b/virtio/mmio.c
> index 875a288..32bba17 100644
> --- a/virtio/mmio.c
> +++ b/virtio/mmio.c
> @@ -103,15 +103,26 @@ static void virtio_mmio_device_specific(struct kvm_cpu *vcpu,
>  					u8 is_write, struct virtio_device *vdev)
>  {
>  	struct virtio_mmio *vmmio = vdev->virtio;
> +	u8 *config_aperture = NULL;
> +	u32 config_aperture_size = 0;
>  	u32 i;
>  
> +	config_aperture = vdev->ops->get_config(vmmio->kvm, vmmio->dev);
> +	/* The cast here is safe because get_config_size will always fit in 32 bits. */
> +	config_aperture_size = (u32)vdev->ops->get_config_size(vmmio->kvm, vmmio->dev);
> +
> +	/* Reduce length to no more than the config size to avoid buffer overflows. */
> +	if (config_aperture_size < len) {
> +		pr_warning("Length (%u) goes beyond config size (%u).\n",
> +			len, config_aperture_size);
> +		len = config_aperture_size;
> +	}

I think the case where addr is beyong the config region for the device
isn't handled (it is handled in the case of the PCI transport). I think the
function should return early if that's the case.

> +
>  	for (i = 0; i < len; i++) {
>  		if (is_write)
> -			vdev->ops->get_config(vmmio->kvm, vmmio->dev)[addr + i] =
> -					      *(u8 *)data + i;
> +			config_aperture[addr + i] = *(u8 *)data + i;
>  		else
> -			data[i] = vdev->ops->get_config(vmmio->kvm,
> -							vmmio->dev)[addr + i];
> +			data[i] = config_aperture[addr+i];

Nitpick: it should be addr + i (notice the spaces) to be consistent with
the rest of the file.

>  	}
>  }
>  
> diff --git a/virtio/net.c b/virtio/net.c
> index 1ee3c19..75d9ae5 100644
> --- a/virtio/net.c
> +++ b/virtio/net.c
> @@ -480,6 +480,11 @@ static u8 *get_config(struct kvm *kvm, void *dev)
>  	return ((u8 *)(&ndev->config));
>  }
>  
> +static size_t get_config_size(struct kvm *kvm, void *dev)
> +{
> +	return sizeof(struct virtio_net_config);
> +}
> +
>  static u32 get_host_features(struct kvm *kvm, void *dev)
>  {
>  	u32 features;
> @@ -757,6 +762,7 @@ static int get_vq_count(struct kvm *kvm, void *dev)
>  
>  static struct virtio_ops net_dev_virtio_ops = {
>  	.get_config		= get_config,
> +	.get_config_size	= get_config_size,
>  	.get_host_features	= get_host_features,
>  	.set_guest_features	= set_guest_features,
>  	.get_vq_count		= get_vq_count,
> diff --git a/virtio/pci.c b/virtio/pci.c
> index 4108529..50fdaa4 100644
> --- a/virtio/pci.c
> +++ b/virtio/pci.c
> @@ -136,7 +136,15 @@ static bool virtio_pci__specific_data_in(struct kvm *kvm, struct virtio_device *
>  		return true;
>  	} else if (type == VIRTIO_PCI_O_CONFIG) {
>  		u8 cfg;
> -
> +		size_t config_size;
> +
> +		config_size = vdev->ops->get_config_size(kvm, vpci->dev);
> +		if (config_offset >= config_size) {

What happens when offset + size > vdev->ops.get_config() + config_size?
This case is handled in the mmio transport case, but not here. More details
below.


> +			/* Access goes beyond the config size, so return failure. */
> +			pr_warning("Config access offset (%u) is beyond config size (%zu)\n",
> +				config_offset, config_size);
> +			return false;
> +		}
>  		cfg = vdev->ops->get_config(kvm, vpci->dev)[config_offset];
>  		ioport__write8(data, cfg);

I think this is wrong. Looking at struct virtio_net_config, there are
fields larger than a byte and the read here doesn't take into account the
size parameter of the function. IMO, the function should be fixed to read
the correct size before doing any boundary checks.

This is what virtio-v1.0 has to say about transitional devices:

"When using the legacy interface the driver MAY access the device-specific
configuration region using any width accesses, and a transitional device
MUST present driver with the same results as when accessed using the
“natural” access method (i.e. 32-bit accesses for 32-bit fields, etc)".

Is there something that I'm missing here?

Same thing with virtio_pci__specific_data_out() below, it ignores the size
parameter.

Thanks,
Alex

>  		return true;
> @@ -276,6 +284,15 @@ static bool virtio_pci__specific_data_out(struct kvm *kvm, struct virtio_device
>  
>  		return true;
>  	} else if (type == VIRTIO_PCI_O_CONFIG) {
> +		size_t config_size;
> +
> +		config_size = vdev->ops->get_config_size(kvm, vpci->dev);
> +		if (config_offset >= config_size) {
> +			/* Access goes beyond the config size, so return failure. */
> +			pr_warning("Config access offset (%u) is beyond config size (%zu)\n",
> +				config_offset, config_size);
> +			return false;
> +		}
>  		vdev->ops->get_config(kvm, vpci->dev)[config_offset] = *(u8 *)data;
>  
>  		return true;
> diff --git a/virtio/rng.c b/virtio/rng.c
> index 78eaa64..c7835a0 100644
> --- a/virtio/rng.c
> +++ b/virtio/rng.c
> @@ -47,6 +47,11 @@ static u8 *get_config(struct kvm *kvm, void *dev)
>  	return 0;
>  }
>  
> +static size_t get_config_size(struct kvm *kvm, void *dev)
> +{
> +	return 0;
> +}
> +
>  static u32 get_host_features(struct kvm *kvm, void *dev)
>  {
>  	/* Unused */
> @@ -149,6 +154,7 @@ static int get_vq_count(struct kvm *kvm, void *dev)
>  
>  static struct virtio_ops rng_dev_virtio_ops = {
>  	.get_config		= get_config,
> +	.get_config_size	= get_config_size,
>  	.get_host_features	= get_host_features,
>  	.set_guest_features	= set_guest_features,
>  	.init_vq		= init_vq,
> diff --git a/virtio/scsi.c b/virtio/scsi.c
> index 16a86cb..37418f8 100644
> --- a/virtio/scsi.c
> +++ b/virtio/scsi.c
> @@ -38,6 +38,11 @@ static u8 *get_config(struct kvm *kvm, void *dev)
>  	return ((u8 *)(&sdev->config));
>  }
>  
> +static size_t get_config_size(struct kvm *kvm, void *dev)
> +{
> +	return sizeof(struct virtio_scsi_config);
> +}
> +
>  static u32 get_host_features(struct kvm *kvm, void *dev)
>  {
>  	return	1UL << VIRTIO_RING_F_EVENT_IDX |
> @@ -176,6 +181,7 @@ static int get_vq_count(struct kvm *kvm, void *dev)
>  
>  static struct virtio_ops scsi_dev_virtio_ops = {
>  	.get_config		= get_config,
> +	.get_config_size	= get_config_size,
>  	.get_host_features	= get_host_features,
>  	.set_guest_features	= set_guest_features,
>  	.init_vq		= init_vq,
> diff --git a/virtio/vsock.c b/virtio/vsock.c
> index 5b99838..2df04d7 100644
> --- a/virtio/vsock.c
> +++ b/virtio/vsock.c
> @@ -41,6 +41,11 @@ static u8 *get_config(struct kvm *kvm, void *dev)
>  	return ((u8 *)(&vdev->config));
>  }
>  
> +static size_t get_config_size(struct kvm *kvm, void *dev)
> +{
> +	return sizeof(struct virtio_vsock_config);
> +}
> +
>  static u32 get_host_features(struct kvm *kvm, void *dev)
>  {
>  	return 1UL << VIRTIO_RING_F_EVENT_IDX
> @@ -204,6 +209,7 @@ static int get_vq_count(struct kvm *kvm, void *dev)
>  
>  static struct virtio_ops vsock_dev_virtio_ops = {
>  	.get_config		= get_config,
> +	.get_config_size	= get_config_size,
>  	.get_host_features	= get_host_features,
>  	.set_guest_features	= set_guest_features,
>  	.init_vq		= init_vq,
> -- 
> 2.25.1
> 
