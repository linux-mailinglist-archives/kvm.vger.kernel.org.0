Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE9FD6E97B2
	for <lists+kvm@lfdr.de>; Thu, 20 Apr 2023 16:52:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231196AbjDTOwv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Apr 2023 10:52:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231699AbjDTOws (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Apr 2023 10:52:48 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 144785241
        for <kvm@vger.kernel.org>; Thu, 20 Apr 2023 07:52:38 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A6A7F1480;
        Thu, 20 Apr 2023 07:53:21 -0700 (PDT)
Received: from donnerap.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 341643F6C4;
        Thu, 20 Apr 2023 07:52:37 -0700 (PDT)
Date:   Thu, 20 Apr 2023 12:23:43 +0100
From:   Andre Przywara <andre.przywara@arm.com>
To:     Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc:     kvm@vger.kernel.org, will@kernel.org, suzuki.poulose@arm.com
Subject: Re: [PATCH kvmtool 01/16] virtio: Factor vhost initialization
Message-ID: <20230420122343.42b96261@donnerap.cambridge.arm.com>
In-Reply-To: <20230419132119.124457-2-jean-philippe@linaro.org>
References: <20230419132119.124457-1-jean-philippe@linaro.org>
        <20230419132119.124457-2-jean-philippe@linaro.org>
Organization: ARM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.32; aarch64-unknown-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DATE_IN_PAST_03_06,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 19 Apr 2023 14:21:05 +0100
Jean-Philippe Brucker <jean-philippe@linaro.org> wrote:

> Move vhost owner and memory table setup to virtio/vhost.c.
> 
> This also fixes vsock and SCSI which did not support multiple memory
> regions until now (vsock didn't allocate the right region size and would
> trigger a buffer overflow).

Compared the code in all the versions, and it matches what the commit
message claims, also still compiles:

Reviewed-by: Andre Przywara <andre.przywara@arm.com>

Cheers,
Andre

> Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
> ---
>  Makefile             |  1 +
>  include/kvm/virtio.h |  1 +
>  virtio/net.c         | 29 +----------------------------
>  virtio/scsi.c        | 21 +--------------------
>  virtio/vhost.c       | 36 ++++++++++++++++++++++++++++++++++++
>  virtio/vsock.c       | 29 ++---------------------------
>  6 files changed, 42 insertions(+), 75 deletions(-)
>  create mode 100644 virtio/vhost.c
> 
> diff --git a/Makefile b/Makefile
> index ed2414bd..86e19339 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -76,6 +76,7 @@ OBJS	+= virtio/pci.o
>  OBJS	+= virtio/vsock.o
>  OBJS	+= virtio/pci-legacy.o
>  OBJS	+= virtio/pci-modern.o
> +OBJS	+= virtio/vhost.o
>  OBJS	+= disk/blk.o
>  OBJS	+= disk/qcow.o
>  OBJS	+= disk/raw.o
> diff --git a/include/kvm/virtio.h b/include/kvm/virtio.h
> index 0e8c7a67..cd72bf11 100644
> --- a/include/kvm/virtio.h
> +++ b/include/kvm/virtio.h
> @@ -247,6 +247,7 @@ void virtio_set_guest_features(struct kvm *kvm, struct virtio_device *vdev,
>  			       void *dev, u64 features);
>  void virtio_notify_status(struct kvm *kvm, struct virtio_device *vdev,
>  			  void *dev, u8 status);
> +void virtio_vhost_init(struct kvm *kvm, int vhost_fd);
>  
>  int virtio_transport_parser(const struct option *opt, const char *arg, int unset);
>  
> diff --git a/virtio/net.c b/virtio/net.c
> index 8749ebfe..6b44754f 100644
> --- a/virtio/net.c
> +++ b/virtio/net.c
> @@ -791,40 +791,13 @@ static struct virtio_ops net_dev_virtio_ops = {
>  
>  static void virtio_net__vhost_init(struct kvm *kvm, struct net_dev *ndev)
>  {
> -	struct kvm_mem_bank *bank;
> -	struct vhost_memory *mem;
> -	int r, i;
> -
>  	ndev->vhost_fd = open("/dev/vhost-net", O_RDWR);
>  	if (ndev->vhost_fd < 0)
>  		die_perror("Failed openning vhost-net device");
>  
> -	mem = calloc(1, sizeof(*mem) + kvm->mem_slots * sizeof(struct vhost_memory_region));
> -	if (mem == NULL)
> -		die("Failed allocating memory for vhost memory map");
> -
> -	i = 0;
> -	list_for_each_entry(bank, &kvm->mem_banks, list) {
> -		mem->regions[i] = (struct vhost_memory_region) {
> -			.guest_phys_addr = bank->guest_phys_addr,
> -			.memory_size	 = bank->size,
> -			.userspace_addr	 = (unsigned long)bank->host_addr,
> -		};
> -		i++;
> -	}
> -	mem->nregions = i;
> -
> -	r = ioctl(ndev->vhost_fd, VHOST_SET_OWNER);
> -	if (r != 0)
> -		die_perror("VHOST_SET_OWNER failed");
> -
> -	r = ioctl(ndev->vhost_fd, VHOST_SET_MEM_TABLE, mem);
> -	if (r != 0)
> -		die_perror("VHOST_SET_MEM_TABLE failed");
> +	virtio_vhost_init(kvm, ndev->vhost_fd);
>  
>  	ndev->vdev.use_vhost = true;
> -
> -	free(mem);
>  }
>  
>  static inline void str_to_mac(const char *str, char *mac)
> diff --git a/virtio/scsi.c b/virtio/scsi.c
> index 893dfe60..4dee24a0 100644
> --- a/virtio/scsi.c
> +++ b/virtio/scsi.c
> @@ -203,7 +203,6 @@ static struct virtio_ops scsi_dev_virtio_ops = {
>  
>  static void virtio_scsi_vhost_init(struct kvm *kvm, struct scsi_dev *sdev)
>  {
> -	struct vhost_memory *mem;
>  	u64 features;
>  	int r;
>  
> @@ -211,20 +210,7 @@ static void virtio_scsi_vhost_init(struct kvm *kvm, struct scsi_dev *sdev)
>  	if (sdev->vhost_fd < 0)
>  		die_perror("Failed openning vhost-scsi device");
>  
> -	mem = calloc(1, sizeof(*mem) + sizeof(struct vhost_memory_region));
> -	if (mem == NULL)
> -		die("Failed allocating memory for vhost memory map");
> -
> -	mem->nregions = 1;
> -	mem->regions[0] = (struct vhost_memory_region) {
> -		.guest_phys_addr	= 0,
> -		.memory_size		= kvm->ram_size,
> -		.userspace_addr		= (unsigned long)kvm->ram_start,
> -	};
> -
> -	r = ioctl(sdev->vhost_fd, VHOST_SET_OWNER);
> -	if (r != 0)
> -		die_perror("VHOST_SET_OWNER failed");
> +	virtio_vhost_init(kvm, sdev->vhost_fd);
>  
>  	r = ioctl(sdev->vhost_fd, VHOST_GET_FEATURES, &features);
>  	if (r != 0)
> @@ -233,13 +219,8 @@ static void virtio_scsi_vhost_init(struct kvm *kvm, struct scsi_dev *sdev)
>  	r = ioctl(sdev->vhost_fd, VHOST_SET_FEATURES, &features);
>  	if (r != 0)
>  		die_perror("VHOST_SET_FEATURES failed");
> -	r = ioctl(sdev->vhost_fd, VHOST_SET_MEM_TABLE, mem);
> -	if (r != 0)
> -		die_perror("VHOST_SET_MEM_TABLE failed");
>  
>  	sdev->vdev.use_vhost = true;
> -
> -	free(mem);
>  }
>  
>  
> diff --git a/virtio/vhost.c b/virtio/vhost.c
> new file mode 100644
> index 00000000..f9f72f51
> --- /dev/null
> +++ b/virtio/vhost.c
> @@ -0,0 +1,36 @@
> +#include <linux/kvm.h>
> +#include <linux/vhost.h>
> +#include <linux/list.h>
> +#include "kvm/virtio.h"
> +
> +void virtio_vhost_init(struct kvm *kvm, int vhost_fd)
> +{
> +	struct kvm_mem_bank *bank;
> +	struct vhost_memory *mem;
> +	int i = 0, r;
> +
> +	mem = calloc(1, sizeof(*mem) +
> +		     kvm->mem_slots * sizeof(struct vhost_memory_region));
> +	if (mem == NULL)
> +		die("Failed allocating memory for vhost memory map");
> +
> +	list_for_each_entry(bank, &kvm->mem_banks, list) {
> +		mem->regions[i] = (struct vhost_memory_region) {
> +			.guest_phys_addr = bank->guest_phys_addr,
> +			.memory_size	 = bank->size,
> +			.userspace_addr	 = (unsigned long)bank->host_addr,
> +		};
> +		i++;
> +	}
> +	mem->nregions = i;
> +
> +	r = ioctl(vhost_fd, VHOST_SET_OWNER);
> +	if (r != 0)
> +		die_perror("VHOST_SET_OWNER failed");
> +
> +	r = ioctl(vhost_fd, VHOST_SET_MEM_TABLE, mem);
> +	if (r != 0)
> +		die_perror("VHOST_SET_MEM_TABLE failed");
> +
> +	free(mem);
> +}
> diff --git a/virtio/vsock.c b/virtio/vsock.c
> index a108e637..4b8be8d7 100644
> --- a/virtio/vsock.c
> +++ b/virtio/vsock.c
> @@ -218,37 +218,14 @@ static struct virtio_ops vsock_dev_virtio_ops = {
>  
>  static void virtio_vhost_vsock_init(struct kvm *kvm, struct vsock_dev *vdev)
>  {
> -	struct kvm_mem_bank *bank;
> -	struct vhost_memory *mem;
>  	u64 features;
> -	int r, i;
> +	int r;
>  
>  	vdev->vhost_fd = open("/dev/vhost-vsock", O_RDWR);
>  	if (vdev->vhost_fd < 0)
>  		die_perror("Failed opening vhost-vsock device");
>  
> -	mem = calloc(1, sizeof(*mem) + sizeof(struct vhost_memory_region));
> -	if (mem == NULL)
> -		die("Failed allocating memory for vhost memory map");
> -
> -	i = 0;
> -	list_for_each_entry(bank, &kvm->mem_banks, list) {
> -		mem->regions[i] = (struct vhost_memory_region) {
> -			.guest_phys_addr = bank->guest_phys_addr,
> -			.memory_size	 = bank->size,
> -			.userspace_addr	 = (unsigned long)bank->host_addr,
> -		};
> -		i++;
> -	}
> -	mem->nregions = i;
> -
> -	r = ioctl(vdev->vhost_fd, VHOST_SET_OWNER);
> -	if (r != 0)
> -		die_perror("VHOST_SET_OWNER failed");
> -
> -	r = ioctl(vdev->vhost_fd, VHOST_SET_MEM_TABLE, mem);
> -	if (r != 0)
> -		die_perror("VHOST_SET_MEM_TABLE failed");
> +	virtio_vhost_init(kvm, vdev->vhost_fd);
>  
>  	r = ioctl(vdev->vhost_fd, VHOST_GET_FEATURES, &features);
>  	if (r != 0)
> @@ -263,8 +240,6 @@ static void virtio_vhost_vsock_init(struct kvm *kvm, struct vsock_dev *vdev)
>  		die_perror("VHOST_VSOCK_SET_GUEST_CID failed");
>  
>  	vdev->vdev.use_vhost = true;
> -
> -	free(mem);
>  }
>  
>  static int virtio_vsock_init_one(struct kvm *kvm, u64 guest_cid)

