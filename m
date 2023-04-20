Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E4F56E97B5
	for <lists+kvm@lfdr.de>; Thu, 20 Apr 2023 16:52:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231521AbjDTOwx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Apr 2023 10:52:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231940AbjDTOww (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Apr 2023 10:52:52 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C8E75527A
        for <kvm@vger.kernel.org>; Thu, 20 Apr 2023 07:52:41 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 662A41595;
        Thu, 20 Apr 2023 07:53:25 -0700 (PDT)
Received: from donnerap.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E842F3F6C4;
        Thu, 20 Apr 2023 07:52:40 -0700 (PDT)
Date:   Thu, 20 Apr 2023 15:11:56 +0100
From:   Andre Przywara <andre.przywara@arm.com>
To:     Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc:     kvm@vger.kernel.org, will@kernel.org, suzuki.poulose@arm.com
Subject: Re: [PATCH kvmtool 02/16] virtio/vhost: Factor vring operation
Message-ID: <20230420151156.33da0880@donnerap.cambridge.arm.com>
In-Reply-To: <20230419132119.124457-3-jean-philippe@linaro.org>
References: <20230419132119.124457-1-jean-philippe@linaro.org>
        <20230419132119.124457-3-jean-philippe@linaro.org>
Organization: ARM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.32; aarch64-unknown-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 19 Apr 2023 14:21:06 +0100
Jean-Philippe Brucker <jean-philippe@linaro.org> wrote:

> The VHOST_VRING* ioctls are common to all device types, move them to
> virtio/vhost.c
> 
> Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>

Verified that the moved-in and moved-out code is equivalent:

Reviewed-by: Andre Przywara <andre.przywara@arm.com>

Cheers,
Andre

> ---
>  include/kvm/virtio.h |  2 ++
>  virtio/net.c         | 25 +------------------------
>  virtio/scsi.c        | 24 +-----------------------
>  virtio/vhost.c       | 33 ++++++++++++++++++++++++++++++++-
>  virtio/vsock.c       | 30 ++----------------------------
>  5 files changed, 38 insertions(+), 76 deletions(-)
> 
> diff --git a/include/kvm/virtio.h b/include/kvm/virtio.h
> index cd72bf11..c8fd69e0 100644
> --- a/include/kvm/virtio.h
> +++ b/include/kvm/virtio.h
> @@ -248,6 +248,8 @@ void virtio_set_guest_features(struct kvm *kvm, struct virtio_device *vdev,
>  void virtio_notify_status(struct kvm *kvm, struct virtio_device *vdev,
>  			  void *dev, u8 status);
>  void virtio_vhost_init(struct kvm *kvm, int vhost_fd);
> +void virtio_vhost_set_vring(struct kvm *kvm, int vhost_fd, u32 index,
> +			    struct virt_queue *queue);
>  
>  int virtio_transport_parser(const struct option *opt, const char *arg, int unset);
>  
> diff --git a/virtio/net.c b/virtio/net.c
> index 6b44754f..021c81d3 100644
> --- a/virtio/net.c
> +++ b/virtio/net.c
> @@ -600,10 +600,8 @@ static bool is_ctrl_vq(struct net_dev *ndev, u32 vq)
>  
>  static int init_vq(struct kvm *kvm, void *dev, u32 vq)
>  {
> -	struct vhost_vring_state state = { .index = vq };
>  	struct vhost_vring_file file = { .index = vq };
>  	struct net_dev_queue *net_queue;
> -	struct vhost_vring_addr addr;
>  	struct net_dev *ndev = dev;
>  	struct virt_queue *queue;
>  	int r;
> @@ -634,28 +632,7 @@ static int init_vq(struct kvm *kvm, void *dev, u32 vq)
>  		return 0;
>  	}
>  
> -	if (queue->endian != VIRTIO_ENDIAN_HOST)
> -		die_perror("VHOST requires the same endianness in guest and host");
> -
> -	state.num = queue->vring.num;
> -	r = ioctl(ndev->vhost_fd, VHOST_SET_VRING_NUM, &state);
> -	if (r < 0)
> -		die_perror("VHOST_SET_VRING_NUM failed");
> -	state.num = 0;
> -	r = ioctl(ndev->vhost_fd, VHOST_SET_VRING_BASE, &state);
> -	if (r < 0)
> -		die_perror("VHOST_SET_VRING_BASE failed");
> -
> -	addr = (struct vhost_vring_addr) {
> -		.index = vq,
> -		.desc_user_addr = (u64)(unsigned long)queue->vring.desc,
> -		.avail_user_addr = (u64)(unsigned long)queue->vring.avail,
> -		.used_user_addr = (u64)(unsigned long)queue->vring.used,
> -	};
> -
> -	r = ioctl(ndev->vhost_fd, VHOST_SET_VRING_ADDR, &addr);
> -	if (r < 0)
> -		die_perror("VHOST_SET_VRING_ADDR failed");
> +	virtio_vhost_set_vring(kvm, ndev->vhost_fd, vq, queue);
>  
>  	file.fd = ndev->tap_fd;
>  	r = ioctl(ndev->vhost_fd, VHOST_NET_SET_BACKEND, &file);
> diff --git a/virtio/scsi.c b/virtio/scsi.c
> index 4dee24a0..674aad34 100644
> --- a/virtio/scsi.c
> +++ b/virtio/scsi.c
> @@ -74,11 +74,8 @@ static void notify_status(struct kvm *kvm, void *dev, u32 status)
>  
>  static int init_vq(struct kvm *kvm, void *dev, u32 vq)
>  {
> -	struct vhost_vring_state state = { .index = vq };
> -	struct vhost_vring_addr addr;
>  	struct scsi_dev *sdev = dev;
>  	struct virt_queue *queue;
> -	int r;
>  
>  	compat__remove_message(compat_id);
>  
> @@ -89,26 +86,7 @@ static int init_vq(struct kvm *kvm, void *dev, u32 vq)
>  	if (sdev->vhost_fd == 0)
>  		return 0;
>  
> -	state.num = queue->vring.num;
> -	r = ioctl(sdev->vhost_fd, VHOST_SET_VRING_NUM, &state);
> -	if (r < 0)
> -		die_perror("VHOST_SET_VRING_NUM failed");
> -	state.num = 0;
> -	r = ioctl(sdev->vhost_fd, VHOST_SET_VRING_BASE, &state);
> -	if (r < 0)
> -		die_perror("VHOST_SET_VRING_BASE failed");
> -
> -	addr = (struct vhost_vring_addr) {
> -		.index = vq,
> -		.desc_user_addr = (u64)(unsigned long)queue->vring.desc,
> -		.avail_user_addr = (u64)(unsigned long)queue->vring.avail,
> -		.used_user_addr = (u64)(unsigned long)queue->vring.used,
> -	};
> -
> -	r = ioctl(sdev->vhost_fd, VHOST_SET_VRING_ADDR, &addr);
> -	if (r < 0)
> -		die_perror("VHOST_SET_VRING_ADDR failed");
> -
> +	virtio_vhost_set_vring(kvm, sdev->vhost_fd, vq, queue);
>  	return 0;
>  }
>  
> diff --git a/virtio/vhost.c b/virtio/vhost.c
> index f9f72f51..afe37465 100644
> --- a/virtio/vhost.c
> +++ b/virtio/vhost.c
> @@ -1,7 +1,8 @@
> +#include "kvm/virtio.h"
> +
>  #include <linux/kvm.h>
>  #include <linux/vhost.h>
>  #include <linux/list.h>
> -#include "kvm/virtio.h"
>  
>  void virtio_vhost_init(struct kvm *kvm, int vhost_fd)
>  {
> @@ -34,3 +35,33 @@ void virtio_vhost_init(struct kvm *kvm, int vhost_fd)
>  
>  	free(mem);
>  }
> +
> +void virtio_vhost_set_vring(struct kvm *kvm, int vhost_fd, u32 index,
> +			    struct virt_queue *queue)
> +{
> +	int r;
> +	struct vhost_vring_addr addr = {
> +		.index = index,
> +		.desc_user_addr = (u64)(unsigned long)queue->vring.desc,
> +		.avail_user_addr = (u64)(unsigned long)queue->vring.avail,
> +		.used_user_addr = (u64)(unsigned long)queue->vring.used,
> +	};
> +	struct vhost_vring_state state = { .index = index };
> +
> +	if (queue->endian != VIRTIO_ENDIAN_HOST)
> +		die("VHOST requires the same endianness in guest and host");
> +
> +	state.num = queue->vring.num;
> +	r = ioctl(vhost_fd, VHOST_SET_VRING_NUM, &state);
> +	if (r < 0)
> +		die_perror("VHOST_SET_VRING_NUM failed");
> +
> +	state.num = 0;
> +	r = ioctl(vhost_fd, VHOST_SET_VRING_BASE, &state);
> +	if (r < 0)
> +		die_perror("VHOST_SET_VRING_BASE failed");
> +
> +	r = ioctl(vhost_fd, VHOST_SET_VRING_ADDR, &addr);
> +	if (r < 0)
> +		die_perror("VHOST_SET_VRING_ADDR failed");
> +}
> diff --git a/virtio/vsock.c b/virtio/vsock.c
> index 4b8be8d7..2f7906f2 100644
> --- a/virtio/vsock.c
> +++ b/virtio/vsock.c
> @@ -62,44 +62,18 @@ static bool is_event_vq(u32 vq)
>  
>  static int init_vq(struct kvm *kvm, void *dev, u32 vq)
>  {
> -	struct vhost_vring_state state = { .index = vq };
> -	struct vhost_vring_addr addr;
>  	struct vsock_dev *vdev = dev;
>  	struct virt_queue *queue;
> -	int r;
>  
>  	compat__remove_message(compat_id);
>  
>  	queue		= &vdev->vqs[vq];
>  	virtio_init_device_vq(kvm, &vdev->vdev, queue, VIRTIO_VSOCK_QUEUE_SIZE);
>  
> -	if (vdev->vhost_fd == -1)
> +	if (vdev->vhost_fd == -1 || is_event_vq(vq))
>  		return 0;
>  
> -	if (is_event_vq(vq))
> -		return 0;
> -
> -	state.num = queue->vring.num;
> -	r = ioctl(vdev->vhost_fd, VHOST_SET_VRING_NUM, &state);
> -	if (r < 0)
> -		die_perror("VHOST_SET_VRING_NUM failed");
> -
> -	state.num = 0;
> -	r = ioctl(vdev->vhost_fd, VHOST_SET_VRING_BASE, &state);
> -	if (r < 0)
> -		die_perror("VHOST_SET_VRING_BASE failed");
> -
> -	addr = (struct vhost_vring_addr) {
> -		.index = vq,
> -		.desc_user_addr = (u64)(unsigned long)queue->vring.desc,
> -		.avail_user_addr = (u64)(unsigned long)queue->vring.avail,
> -		.used_user_addr = (u64)(unsigned long)queue->vring.used,
> -	};
> -
> -	r = ioctl(vdev->vhost_fd, VHOST_SET_VRING_ADDR, &addr);
> -	if (r < 0)
> -		die_perror("VHOST_SET_VRING_ADDR failed");
> -
> +	virtio_vhost_set_vring(kvm, vdev->vhost_fd, vq, queue);
>  	return 0;
>  }
>  

