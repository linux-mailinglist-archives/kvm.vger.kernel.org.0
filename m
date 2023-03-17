Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE0436BED8F
	for <lists+kvm@lfdr.de>; Fri, 17 Mar 2023 17:00:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231130AbjCQQAe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Mar 2023 12:00:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231466AbjCQQAa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Mar 2023 12:00:30 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3BBA560D6C
        for <kvm@vger.kernel.org>; Fri, 17 Mar 2023 09:00:25 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A9D9B13D5;
        Fri, 17 Mar 2023 09:01:08 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4C6B73F885;
        Fri, 17 Mar 2023 09:00:23 -0700 (PDT)
Date:   Fri, 17 Mar 2023 16:00:12 +0000
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Rajnesh Kanwal <rkanwal@rivosinc.com>
Cc:     atishp@rivosinc.com, apatel@ventanamicro.com, kvm@vger.kernel.org,
        will@kernel.org, julien.thierry.kdev@gmail.com, maz@kernel.org,
        andre.przywara@arm.com, jean-philippe@linaro.org
Subject: Re: [PATCH v2 kvmtool] Add virtio-transport option and deprecate
 force-pci and virtio-legacy.
Message-ID: <ZBSOjLC/V6iWHGmA@monolith.localdoman>
References: <20230315171238.300572-1-rkanwal@rivosinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230315171238.300572-1-rkanwal@rivosinc.com>
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On Wed, Mar 15, 2023 at 05:12:38PM +0000, Rajnesh Kanwal wrote:
> This is a follow-up patch for [0] which proposed the --force-pci option
> for riscv. As per the discussion it was concluded to add virtio-tranport
> option taking in four options (pci, pci-legacy, mmio, mmio-legacy).
> 
> With this change force-pci and virtio-legacy are both deprecated and
> arm's default transport changes from MMIO to PCI as agreed in [0].
> This is also true for riscv.
> 
> Nothing changes for other architectures.
> 
> [0]: https://lore.kernel.org/all/20230118172007.408667-1-rkanwal@rivosinc.com/
> 
> Signed-off-by: Rajnesh Kanwal <rkanwal@rivosinc.com>
>     

The changes between patch versions should come after the triple dash, not
before it, that way it won't show up in git log when the patch gets merged.

> V2:
>     - Removed VIRTIO_DEFAULT_TRANS macro.
>     - Replaced `[]` with `()` in cmdline arguments notes.
>     - Fixed virtio_tranport_parser -> virtio_transport_parser
> 
> v1: https://lore.kernel.org/all/20230306120329.535320-1-rkanwal@rivosinc.com/
> 
> ---
>  arm/include/arm-common/kvm-arch.h        |  5 ----
>  arm/include/arm-common/kvm-config-arch.h |  8 +++----
>  builtin-run.c                            | 11 +++++++--
>  include/kvm/kvm-config.h                 |  2 +-
>  include/kvm/kvm.h                        |  6 -----
>  include/kvm/virtio.h                     |  2 ++
>  riscv/include/kvm/kvm-arch.h             |  3 ---
>  virtio/9p.c                              |  2 +-
>  virtio/balloon.c                         |  2 +-
>  virtio/blk.c                             |  2 +-
>  virtio/console.c                         |  2 +-
>  virtio/core.c                            | 30 ++++++++++++++++++++++++
>  virtio/net.c                             |  4 ++--
>  virtio/rng.c                             |  2 +-
>  virtio/scsi.c                            |  2 +-
>  virtio/vsock.c                           |  2 +-
>  16 files changed, 55 insertions(+), 30 deletions(-)
> 
> diff --git a/arm/include/arm-common/kvm-arch.h b/arm/include/arm-common/kvm-arch.h
> index b2ae373..60eec02 100644
> --- a/arm/include/arm-common/kvm-arch.h
> +++ b/arm/include/arm-common/kvm-arch.h
> @@ -80,11 +80,6 @@
>  
>  #define KVM_VM_TYPE		0
>  
> -#define VIRTIO_DEFAULT_TRANS(kvm)					\
> -	((kvm)->cfg.arch.virtio_trans_pci ?				\
> -	 ((kvm)->cfg.virtio_legacy ? VIRTIO_PCI_LEGACY : VIRTIO_PCI) :	\
> -	 ((kvm)->cfg.virtio_legacy ? VIRTIO_MMIO_LEGACY : VIRTIO_MMIO))
> -
>  #define VIRTIO_RING_ENDIAN	(VIRTIO_ENDIAN_LE | VIRTIO_ENDIAN_BE)
>  
>  #define ARCH_HAS_PCI_EXP	1
> diff --git a/arm/include/arm-common/kvm-config-arch.h b/arm/include/arm-common/kvm-config-arch.h
> index 9949bfe..87f5035 100644
> --- a/arm/include/arm-common/kvm-config-arch.h
> +++ b/arm/include/arm-common/kvm-config-arch.h
> @@ -7,7 +7,6 @@ struct kvm_config_arch {
>  	const char	*dump_dtb_filename;
>  	const char	*vcpu_affinity;
>  	unsigned int	force_cntfrq;
> -	bool		virtio_trans_pci;
>  	bool		aarch32_guest;
>  	bool		has_pmuv3;
>  	bool		mte_disabled;
> @@ -28,9 +27,10 @@ int irqchip_parser(const struct option *opt, const char *arg, int unset);
>  		     "Specify Generic Timer frequency in guest DT to "		\
>  		     "work around buggy secure firmware *Firmware should be "	\
>  		     "updated to program CNTFRQ correctly*"),			\
> -	OPT_BOOLEAN('\0', "force-pci", &(cfg)->virtio_trans_pci,		\
> -		    "Force virtio devices to use PCI as their default "		\
> -		    "transport"),						\
> +	OPT_CALLBACK_NOOPT('\0', "force-pci", NULL, '\0',			\
> +			   "Force virtio devices to use PCI as their default "	\
> +			   "transport (Deprecated: Use --virtio-transport "	\
> +			   "option instead)", virtio_transport_parser, kvm),	\
>          OPT_CALLBACK('\0', "irqchip", &(cfg)->irqchip,				\
>  		     "[gicv2|gicv2m|gicv3|gicv3-its]",				\
>  		     "Type of interrupt controller to emulate in the guest",	\
> diff --git a/builtin-run.c b/builtin-run.c
> index bb7e6e8..f2f179d 100644
> --- a/builtin-run.c
> +++ b/builtin-run.c
> @@ -200,8 +200,15 @@ static int mem_parser(const struct option *opt, const char *arg, int unset)
>  			" rootfs"),					\
>  	OPT_STRING('\0', "hugetlbfs", &(cfg)->hugetlbfs_path, "path",	\
>  			"Hugetlbfs path"),				\
> -	OPT_BOOLEAN('\0', "virtio-legacy", &(cfg)->virtio_legacy,	\
> -		    "Use legacy virtio transport"),			\
> +	OPT_CALLBACK_NOOPT('\0', "virtio-legacy",			\
> +			   &(cfg)->virtio_transport, '\0',		\
> +			   "Use legacy virtio transport (Deprecated:"	\
> +			   " Use --virtio-transport option instead)",	\
> +			   virtio_transport_parser, NULL),		\
> +	OPT_CALLBACK('\0', "virtio-transport", &(cfg)->virtio_transport,\
> +		     "[pci|pci-legacy|mmio|mmio-legacy]",		\

While that is true for arm/arm64/riscv, those options are not available for
other architectures and attempting to set virtio-transport to mmio or
mmio-legacy will result in an error:

  Error: virtio-transport: unknown type "mmio"

That's when attempting to run lkvm on x86. You can solve that by doing what
--mem does, something like:

diff --git a/builtin-run.c b/builtin-run.c
index f2f179dcb495..a32e186587c5 100644
--- a/builtin-run.c
+++ b/builtin-run.c
@@ -162,6 +162,12 @@ static int mem_parser(const struct option *opt, const char *arg, int unset)
        " in megabytes (M)"
 #endif

+#if defined(CONFIG_ARM) || defined(CONFIG_ARM64) || defined(CONFIG_RISCV)
+#define VIRTIO_TRANS_OPT_HELP_SHORT    "[pci|pci-legacy|mmio|mmio-legacy]"
+#else
+#define VIRTIO_TRANS_OPT_HELP_SHORT    "[pci|pci-legacy]"
+#endif
+
 #define BUILD_OPTIONS(name, cfg, kvm)                                  \
        struct option name[] = {                                        \
        OPT_GROUP("Basic options:"),                                    \
@@ -206,7 +212,7 @@ static int mem_parser(const struct option *opt, const char *arg, int unset)
                           " Use --virtio-transport option instead)",   \
                           virtio_transport_parser, NULL),              \
        OPT_CALLBACK('\0', "virtio-transport", &(cfg)->virtio_transport,\
-                    "[pci|pci-legacy|mmio|mmio-legacy]",               \
+                    VIRTIO_TRANS_OPT_HELP_SHORT,                       \
                     "Type of virtio transport",                        \
                     virtio_transport_parser, NULL),                    \

Otherwise, looks good.

Thanks,
Alex

> +		     "Type of virtio transport",			\
> +		     virtio_transport_parser, NULL),			\
>  									\
>  	OPT_GROUP("Kernel options:"),					\
>  	OPT_STRING('k', "kernel", &(cfg)->kernel_filename, "kernel",	\
> diff --git a/include/kvm/kvm-config.h b/include/kvm/kvm-config.h
> index 368e6c7..592b035 100644
> --- a/include/kvm/kvm-config.h
> +++ b/include/kvm/kvm-config.h
> @@ -64,7 +64,7 @@ struct kvm_config {
>  	bool no_dhcp;
>  	bool ioport_debug;
>  	bool mmio_debug;
> -	bool virtio_legacy;
> +	int virtio_transport;
>  };
>  
>  #endif
> diff --git a/include/kvm/kvm.h b/include/kvm/kvm.h
> index 3872dc6..eb23e2f 100644
> --- a/include/kvm/kvm.h
> +++ b/include/kvm/kvm.h
> @@ -45,12 +45,6 @@ struct kvm_cpu;
>  typedef void (*mmio_handler_fn)(struct kvm_cpu *vcpu, u64 addr, u8 *data,
>  				u32 len, u8 is_write, void *ptr);
>  
> -/* Archs can override this in kvm-arch.h */
> -#ifndef VIRTIO_DEFAULT_TRANS
> -#define VIRTIO_DEFAULT_TRANS(kvm) \
> -	((kvm)->cfg.virtio_legacy ? VIRTIO_PCI_LEGACY : VIRTIO_PCI)
> -#endif
> -
>  enum {
>  	KVM_VMSTATE_RUNNING,
>  	KVM_VMSTATE_PAUSED,
> diff --git a/include/kvm/virtio.h b/include/kvm/virtio.h
> index 94bddef..0e8c7a6 100644
> --- a/include/kvm/virtio.h
> +++ b/include/kvm/virtio.h
> @@ -248,4 +248,6 @@ void virtio_set_guest_features(struct kvm *kvm, struct virtio_device *vdev,
>  void virtio_notify_status(struct kvm *kvm, struct virtio_device *vdev,
>  			  void *dev, u8 status);
>  
> +int virtio_transport_parser(const struct option *opt, const char *arg, int unset);
> +
>  #endif /* KVM__VIRTIO_H */
> diff --git a/riscv/include/kvm/kvm-arch.h b/riscv/include/kvm/kvm-arch.h
> index 1e130f5..4106099 100644
> --- a/riscv/include/kvm/kvm-arch.h
> +++ b/riscv/include/kvm/kvm-arch.h
> @@ -46,9 +46,6 @@
>  
>  #define KVM_VM_TYPE		0
>  
> -#define VIRTIO_DEFAULT_TRANS(kvm) \
> -	((kvm)->cfg.virtio_legacy ? VIRTIO_MMIO_LEGACY : VIRTIO_MMIO)
> -
>  #define VIRTIO_RING_ENDIAN	VIRTIO_ENDIAN_LE
>  
>  #define ARCH_HAS_PCI_EXP	1
> diff --git a/virtio/9p.c b/virtio/9p.c
> index 19b66df..b809bcd 100644
> --- a/virtio/9p.c
> +++ b/virtio/9p.c
> @@ -1552,7 +1552,7 @@ int virtio_9p__init(struct kvm *kvm)
>  
>  	list_for_each_entry(p9dev, &devs, list) {
>  		r = virtio_init(kvm, p9dev, &p9dev->vdev, &p9_dev_virtio_ops,
> -				VIRTIO_DEFAULT_TRANS(kvm), PCI_DEVICE_ID_VIRTIO_9P,
> +				kvm->cfg.virtio_transport, PCI_DEVICE_ID_VIRTIO_9P,
>  				VIRTIO_ID_9P, PCI_CLASS_9P);
>  		if (r < 0)
>  			return r;
> diff --git a/virtio/balloon.c b/virtio/balloon.c
> index 3a73432..01d1982 100644
> --- a/virtio/balloon.c
> +++ b/virtio/balloon.c
> @@ -279,7 +279,7 @@ int virtio_bln__init(struct kvm *kvm)
>  	memset(&bdev.config, 0, sizeof(struct virtio_balloon_config));
>  
>  	r = virtio_init(kvm, &bdev, &bdev.vdev, &bln_dev_virtio_ops,
> -			VIRTIO_DEFAULT_TRANS(kvm), PCI_DEVICE_ID_VIRTIO_BLN,
> +			kvm->cfg.virtio_transport, PCI_DEVICE_ID_VIRTIO_BLN,
>  			VIRTIO_ID_BALLOON, PCI_CLASS_BLN);
>  	if (r < 0)
>  		return r;
> diff --git a/virtio/blk.c b/virtio/blk.c
> index 2d06391..f3c34f3 100644
> --- a/virtio/blk.c
> +++ b/virtio/blk.c
> @@ -329,7 +329,7 @@ static int virtio_blk__init_one(struct kvm *kvm, struct disk_image *disk)
>  	list_add_tail(&bdev->list, &bdevs);
>  
>  	r = virtio_init(kvm, bdev, &bdev->vdev, &blk_dev_virtio_ops,
> -			VIRTIO_DEFAULT_TRANS(kvm), PCI_DEVICE_ID_VIRTIO_BLK,
> +			kvm->cfg.virtio_transport, PCI_DEVICE_ID_VIRTIO_BLK,
>  			VIRTIO_ID_BLOCK, PCI_CLASS_BLK);
>  	if (r < 0)
>  		return r;
> diff --git a/virtio/console.c b/virtio/console.c
> index d29319c..11a22a9 100644
> --- a/virtio/console.c
> +++ b/virtio/console.c
> @@ -229,7 +229,7 @@ int virtio_console__init(struct kvm *kvm)
>  		return 0;
>  
>  	r = virtio_init(kvm, &cdev, &cdev.vdev, &con_dev_virtio_ops,
> -			VIRTIO_DEFAULT_TRANS(kvm), PCI_DEVICE_ID_VIRTIO_CONSOLE,
> +			kvm->cfg.virtio_transport, PCI_DEVICE_ID_VIRTIO_CONSOLE,
>  			VIRTIO_ID_CONSOLE, PCI_CLASS_CONSOLE);
>  	if (r < 0)
>  		return r;
> diff --git a/virtio/core.c b/virtio/core.c
> index ea0e5b6..568243a 100644
> --- a/virtio/core.c
> +++ b/virtio/core.c
> @@ -21,6 +21,36 @@ const char* virtio_trans_name(enum virtio_trans trans)
>  	return "unknown";
>  }
>  
> +int virtio_transport_parser(const struct option *opt, const char *arg, int unset)
> +{
> +	enum virtio_trans *type = opt->value;
> +	struct kvm *kvm;
> +
> +	if (!strcmp(opt->long_name, "virtio-transport")) {
> +		if (!strcmp(arg, "pci")) {
> +			*type = VIRTIO_PCI;
> +		} else if (!strcmp(arg, "pci-legacy")) {
> +			*type = VIRTIO_PCI_LEGACY;
> +#if defined(CONFIG_ARM) || defined(CONFIG_ARM64) || defined(CONFIG_RISCV)
> +		} else if (!strcmp(arg, "mmio")) {
> +			*type = VIRTIO_MMIO;
> +		} else if (!strcmp(arg, "mmio-legacy")) {
> +			*type = VIRTIO_MMIO_LEGACY;
> +#endif
> +		} else {
> +			pr_err("virtio-transport: unknown type \"%s\"\n", arg);
> +			return -1;
> +		}
> +	} else if (!strcmp(opt->long_name, "virtio-legacy")) {
> +		*type = VIRTIO_PCI_LEGACY;
> +	} else if (!strcmp(opt->long_name, "force-pci")) {
> +		kvm = opt->ptr;
> +		kvm->cfg.virtio_transport = VIRTIO_PCI;
> +	}
> +
> +	return 0;
> +}
> +
>  void virt_queue__used_idx_advance(struct virt_queue *queue, u16 jump)
>  {
>  	u16 idx = virtio_guest_to_host_u16(queue, queue->vring.used->idx);
> diff --git a/virtio/net.c b/virtio/net.c
> index a5e0cea..8749ebf 100644
> --- a/virtio/net.c
> +++ b/virtio/net.c
> @@ -928,10 +928,10 @@ done:
>  
>  static int virtio_net__init_one(struct virtio_net_params *params)
>  {
> -	int i, r;
> +	enum virtio_trans trans = params->kvm->cfg.virtio_transport;
>  	struct net_dev *ndev;
>  	struct virtio_ops *ops;
> -	enum virtio_trans trans = VIRTIO_DEFAULT_TRANS(params->kvm);
> +	int i, r;
>  
>  	ndev = calloc(1, sizeof(struct net_dev));
>  	if (ndev == NULL)
> diff --git a/virtio/rng.c b/virtio/rng.c
> index 63ab8fc..8f85d5e 100644
> --- a/virtio/rng.c
> +++ b/virtio/rng.c
> @@ -173,7 +173,7 @@ int virtio_rng__init(struct kvm *kvm)
>  	}
>  
>  	r = virtio_init(kvm, rdev, &rdev->vdev, &rng_dev_virtio_ops,
> -			VIRTIO_DEFAULT_TRANS(kvm), PCI_DEVICE_ID_VIRTIO_RNG,
> +			kvm->cfg.virtio_transport, PCI_DEVICE_ID_VIRTIO_RNG,
>  			VIRTIO_ID_RNG, PCI_CLASS_RNG);
>  	if (r < 0)
>  		goto cleanup;
> diff --git a/virtio/scsi.c b/virtio/scsi.c
> index 0286b86..893dfe6 100644
> --- a/virtio/scsi.c
> +++ b/virtio/scsi.c
> @@ -264,7 +264,7 @@ static int virtio_scsi_init_one(struct kvm *kvm, struct disk_image *disk)
>  	list_add_tail(&sdev->list, &sdevs);
>  
>  	r = virtio_init(kvm, sdev, &sdev->vdev, &scsi_dev_virtio_ops,
> -			VIRTIO_DEFAULT_TRANS(kvm), PCI_DEVICE_ID_VIRTIO_SCSI,
> +			kvm->cfg.virtio_transport, PCI_DEVICE_ID_VIRTIO_SCSI,
>  			VIRTIO_ID_SCSI, PCI_CLASS_BLK);
>  	if (r < 0)
>  		return r;
> diff --git a/virtio/vsock.c b/virtio/vsock.c
> index 18b45f3..a108e63 100644
> --- a/virtio/vsock.c
> +++ b/virtio/vsock.c
> @@ -285,7 +285,7 @@ static int virtio_vsock_init_one(struct kvm *kvm, u64 guest_cid)
>  	list_add_tail(&vdev->list, &vdevs);
>  
>  	r = virtio_init(kvm, vdev, &vdev->vdev, &vsock_dev_virtio_ops,
> -		    VIRTIO_DEFAULT_TRANS(kvm), PCI_DEVICE_ID_VIRTIO_VSOCK,
> +		    kvm->cfg.virtio_transport, PCI_DEVICE_ID_VIRTIO_VSOCK,
>  		    VIRTIO_ID_VSOCK, PCI_CLASS_VSOCK);
>  	if (r < 0)
>  	    return r;
> -- 
> 2.25.1
> 
