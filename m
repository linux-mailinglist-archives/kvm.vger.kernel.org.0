Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97850524A3E
	for <lists+kvm@lfdr.de>; Thu, 12 May 2022 12:29:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352607AbiELK3L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 May 2022 06:29:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235697AbiELK3K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 May 2022 06:29:10 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B88E3200F5D
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 03:29:08 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6FFD2106F;
        Thu, 12 May 2022 03:29:08 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A4D3F3F66F;
        Thu, 12 May 2022 03:29:07 -0700 (PDT)
Date:   Thu, 12 May 2022 11:29:10 +0100
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Martin Radev <martin.b.radev@gmail.com>
Cc:     kvm@vger.kernel.org, will@kernel.org
Subject: Re: [PATCH v3 kvmtool 4/6] virtio: Sanitize config accesses
Message-ID: <YnzhdgUwrLlqmzch@monolith.localdoman>
References: <20220509203940.754644-1-martin.b.radev@gmail.com>
 <20220509203940.754644-5-martin.b.radev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220509203940.754644-5-martin.b.radev@gmail.com>
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Martin,

On Mon, May 09, 2022 at 11:39:38PM +0300, Martin Radev wrote:
> The handling of VIRTIO_PCI_O_CONFIG is prone to buffer access overflows.
> This patch sanitizes this operation by using the newly added virtio op
> get_config_size. Any access which goes beyond the config structure's
> size is prevented and a failure is returned.
> 
> Additionally, PCI accesses which span more than a single byte are prevented
> and a warning is printed because the implementation does not currently
> support the behavior correctly.
> 
> Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
> Signed-off-by: Martin Radev <martin.b.radev@gmail.com>
> ---
>  include/kvm/virtio-9p.h |  1 +
>  include/kvm/virtio.h    |  1 +
>  virtio/9p.c             | 25 ++++++++++++++++++++-----
>  virtio/balloon.c        |  8 ++++++++
>  virtio/blk.c            |  8 ++++++++
>  virtio/console.c        |  8 ++++++++
>  virtio/mmio.c           | 18 ++++++++++++++----
>  virtio/net.c            |  8 ++++++++
>  virtio/pci.c            | 29 +++++++++++++++++++++++++++++
>  virtio/rng.c            |  6 ++++++
>  virtio/scsi.c           |  8 ++++++++
>  virtio/vsock.c          |  8 ++++++++
>  12 files changed, 119 insertions(+), 9 deletions(-)
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
> index b78f2b3..57cd6d0 100644
> --- a/virtio/9p.c
> +++ b/virtio/9p.c
> @@ -1375,6 +1375,13 @@ static u8 *get_config(struct kvm *kvm, void *dev)
>  	return ((u8 *)(p9dev->config));
>  }
>  
> +static size_t get_config_size(struct kvm *kvm, void *dev)
> +{
> +	struct p9_dev *p9dev = dev;
> +
> +	return p9dev->config_size;
> +}
> +
>  static u32 get_host_features(struct kvm *kvm, void *dev)
>  {
>  	return 1 << VIRTIO_9P_MOUNT_TAG;
> @@ -1469,6 +1476,7 @@ static int get_vq_count(struct kvm *kvm, void *dev)
>  
>  struct virtio_ops p9_dev_virtio_ops = {
>  	.get_config		= get_config,
> +	.get_config_size	= get_config_size,
>  	.get_host_features	= get_host_features,
>  	.set_guest_features	= set_guest_features,
>  	.init_vq		= init_vq,
> @@ -1568,7 +1576,9 @@ virtio_dev_init(virtio_9p__init);
>  int virtio_9p__register(struct kvm *kvm, const char *root, const char *tag_name)
>  {
>  	struct p9_dev *p9dev;
> -	int err = 0;
> +	size_t tag_length;
> +	size_t config_size;
> +	int err;
>  
>  	p9dev = calloc(1, sizeof(*p9dev));
>  	if (!p9dev)
> @@ -1577,29 +1587,34 @@ int virtio_9p__register(struct kvm *kvm, const char *root, const char *tag_name)
>  	if (!tag_name)
>  		tag_name = VIRTIO_9P_DEFAULT_TAG;
>  
> -	p9dev->config = calloc(1, sizeof(*p9dev->config) + strlen(tag_name) + 1);
> +	tag_length = strlen(tag_name);
> +	/* The tag_name zero byte is intentionally excluded */
> +	config_size = sizeof(*p9dev->config) + tag_length;
> +
> +	p9dev->config = calloc(1, config_size);

This still needs to be a separate patch, as I explained earlier [1]. Something
like this (you don't need to credit me):

---------------------------------------------------------------------(snip)
    virtio/9p: Fix virtio_9p_config allocation size

    Per the Linux user API, the struct virtio_9p_config "tag" field contains
    the non-NULL terminated tag name and this is how the tag name is
    copied by kvmtool in virtio_9p__register(). However, the memory allocation
    for the struct is off by one, as it allocates memory for the tag name and
    the NULL byte. Fix it by reducing the allocation by exactly one byte.

    This is also matches how the struct is allocated by QEMU tagged v7.0.0
    in virtio_9p_get_config().

diff --git a/virtio/9p.c b/virtio/9p.c
index b78f2b3f0e09..ca83436ae488 100644
--- a/virtio/9p.c
+++ b/virtio/9p.c
@@ -1577,7 +1577,7 @@ int virtio_9p__register(struct kvm *kvm, const char *root, const char *tag_name)
        if (!tag_name)
                tag_name = VIRTIO_9P_DEFAULT_TAG;

-       p9dev->config = calloc(1, sizeof(*p9dev->config) + strlen(tag_name) + 1);
+       p9dev->config = calloc(1, sizeof(*p9dev->config) + strlen(tag_name));
        if (p9dev->config == NULL) {
                err = -ENOMEM;
                goto free_p9dev;
---------------------------------------------------------------------(snip)

[1] https://lore.kernel.org/all/YmJ%2FebYEP7tcrxem@monolith.localdoman/

Thanks,
Alex
