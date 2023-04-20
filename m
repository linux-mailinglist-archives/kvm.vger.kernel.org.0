Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CCEB6E97B3
	for <lists+kvm@lfdr.de>; Thu, 20 Apr 2023 16:52:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231621AbjDTOww (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Apr 2023 10:52:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231521AbjDTOwu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Apr 2023 10:52:50 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 073736A40
        for <kvm@vger.kernel.org>; Thu, 20 Apr 2023 07:52:40 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 80941152B;
        Thu, 20 Apr 2023 07:53:23 -0700 (PDT)
Received: from donnerap.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 043C03F6C4;
        Thu, 20 Apr 2023 07:52:38 -0700 (PDT)
Date:   Thu, 20 Apr 2023 15:12:47 +0100
From:   Andre Przywara <andre.przywara@arm.com>
To:     Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc:     kvm@vger.kernel.org, will@kernel.org, suzuki.poulose@arm.com
Subject: Re: [PATCH kvmtool 03/16] virtio/vhost: Factor notify_vq_eventfd()
Message-ID: <20230420151247.1f2a1645@donnerap.cambridge.arm.com>
In-Reply-To: <20230419132119.124457-4-jean-philippe@linaro.org>
References: <20230419132119.124457-1-jean-philippe@linaro.org>
        <20230419132119.124457-4-jean-philippe@linaro.org>
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

On Wed, 19 Apr 2023 14:21:07 +0100
Jean-Philippe Brucker <jean-philippe@linaro.org> wrote:

Hi,

> All vhost devices perform the same operation when setting up the
> ioeventfd. Move it to virtio/vhost.c

Indeed they do:

Reviewed-by: Andre Przywara <andre.przywara@arm.com>

Cheers,
Andre

> 
> Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
> ---
>  include/kvm/virtio.h |  2 ++
>  virtio/net.c         |  9 +--------
>  virtio/scsi.c        |  9 +--------
>  virtio/vhost.c       | 14 ++++++++++++++
>  virtio/vsock.c       | 14 ++------------
>  5 files changed, 20 insertions(+), 28 deletions(-)
> 
> diff --git a/include/kvm/virtio.h b/include/kvm/virtio.h
> index c8fd69e0..4a364a02 100644
> --- a/include/kvm/virtio.h
> +++ b/include/kvm/virtio.h
> @@ -250,6 +250,8 @@ void virtio_notify_status(struct kvm *kvm, struct virtio_device *vdev,
>  void virtio_vhost_init(struct kvm *kvm, int vhost_fd);
>  void virtio_vhost_set_vring(struct kvm *kvm, int vhost_fd, u32 index,
>  			    struct virt_queue *queue);
> +void virtio_vhost_set_vring_kick(struct kvm *kvm, int vhost_fd,
> +				 u32 index, int event_fd);
>  
>  int virtio_transport_parser(const struct option *opt, const char *arg, int unset);
>  
> diff --git a/virtio/net.c b/virtio/net.c
> index 021c81d3..b935d24f 100644
> --- a/virtio/net.c
> +++ b/virtio/net.c
> @@ -701,18 +701,11 @@ static void notify_vq_gsi(struct kvm *kvm, void *dev, u32 vq, u32 gsi)
>  static void notify_vq_eventfd(struct kvm *kvm, void *dev, u32 vq, u32 efd)
>  {
>  	struct net_dev *ndev = dev;
> -	struct vhost_vring_file file = {
> -		.index	= vq,
> -		.fd	= efd,
> -	};
> -	int r;
>  
>  	if (ndev->vhost_fd == 0 || is_ctrl_vq(ndev, vq))
>  		return;
>  
> -	r = ioctl(ndev->vhost_fd, VHOST_SET_VRING_KICK, &file);
> -	if (r < 0)
> -		die_perror("VHOST_SET_VRING_KICK failed");
> +	virtio_vhost_set_vring_kick(kvm, ndev->vhost_fd, vq, efd);
>  }
>  
>  static int notify_vq(struct kvm *kvm, void *dev, u32 vq)
> diff --git a/virtio/scsi.c b/virtio/scsi.c
> index 674aad34..1f757404 100644
> --- a/virtio/scsi.c
> +++ b/virtio/scsi.c
> @@ -123,18 +123,11 @@ static void notify_vq_gsi(struct kvm *kvm, void *dev, u32 vq, u32 gsi)
>  static void notify_vq_eventfd(struct kvm *kvm, void *dev, u32 vq, u32 efd)
>  {
>  	struct scsi_dev *sdev = dev;
> -	struct vhost_vring_file file = {
> -		.index	= vq,
> -		.fd	= efd,
> -	};
> -	int r;
>  
>  	if (sdev->vhost_fd == 0)
>  		return;
>  
> -	r = ioctl(sdev->vhost_fd, VHOST_SET_VRING_KICK, &file);
> -	if (r < 0)
> -		die_perror("VHOST_SET_VRING_KICK failed");
> +	virtio_vhost_set_vring_kick(kvm, sdev->vhost_fd, vq, efd);
>  }
>  
>  static int notify_vq(struct kvm *kvm, void *dev, u32 vq)
> diff --git a/virtio/vhost.c b/virtio/vhost.c
> index afe37465..3acfd30a 100644
> --- a/virtio/vhost.c
> +++ b/virtio/vhost.c
> @@ -65,3 +65,17 @@ void virtio_vhost_set_vring(struct kvm *kvm, int vhost_fd, u32 index,
>  	if (r < 0)
>  		die_perror("VHOST_SET_VRING_ADDR failed");
>  }
> +
> +void virtio_vhost_set_vring_kick(struct kvm *kvm, int vhost_fd,
> +				 u32 index, int event_fd)
> +{
> +	int r;
> +	struct vhost_vring_file file = {
> +		.index	= index,
> +		.fd	= event_fd,
> +	};
> +
> +	r = ioctl(vhost_fd, VHOST_SET_VRING_KICK, &file);
> +	if (r < 0)
> +		die_perror("VHOST_SET_VRING_KICK failed");
> +}
> diff --git a/virtio/vsock.c b/virtio/vsock.c
> index 2f7906f2..0ada9e09 100644
> --- a/virtio/vsock.c
> +++ b/virtio/vsock.c
> @@ -80,21 +80,11 @@ static int init_vq(struct kvm *kvm, void *dev, u32 vq)
>  static void notify_vq_eventfd(struct kvm *kvm, void *dev, u32 vq, u32 efd)
>  {
>  	struct vsock_dev *vdev = dev;
> -	struct vhost_vring_file file = {
> -		.index	= vq,
> -		.fd	= efd,
> -	};
> -	int r;
>  
> -	if (is_event_vq(vq))
> -		return;
> -
> -	if (vdev->vhost_fd == -1)
> +	if (vdev->vhost_fd == -1 || is_event_vq(vq))
>  		return;
>  
> -	r = ioctl(vdev->vhost_fd, VHOST_SET_VRING_KICK, &file);
> -	if (r < 0)
> -		die_perror("VHOST_SET_VRING_KICK failed");
> +	virtio_vhost_set_vring_kick(kvm, vdev->vhost_fd, vq, efd);
>  }
>  
>  static void notify_status(struct kvm *kvm, void *dev, u32 status)

