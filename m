Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 342306B4990
	for <lists+kvm@lfdr.de>; Fri, 10 Mar 2023 16:14:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233592AbjCJPOE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Mar 2023 10:14:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233343AbjCJPNd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Mar 2023 10:13:33 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5D6DD11E6F6
        for <kvm@vger.kernel.org>; Fri, 10 Mar 2023 07:04:57 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5EEAC1FB;
        Fri, 10 Mar 2023 07:04:48 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4AEA33F71A;
        Fri, 10 Mar 2023 07:04:03 -0800 (PST)
Date:   Fri, 10 Mar 2023 15:03:52 +0000
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Rajnesh Kanwal <rkanwal@rivosinc.com>
Cc:     atishp@rivosinc.com, apatel@ventanamicro.com, kvm@vger.kernel.org,
        will@kernel.org, julien.thierry.kdev@gmail.com, maz@kernel.org,
        andre.przywara@arm.com, jean-philippe@linaro.org
Subject: Re: [PATCH kvmtool 1/1] Add virtio-transport option and deprecate
 force-pci and virtio-legacy.
Message-ID: <ZAtG2Jk6VOOyT0xJ@monolith.localdoman>
References: <20230306120329.535320-1-rkanwal@rivosinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230306120329.535320-1-rkanwal@rivosinc.com>
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

Thank you for doing this!

The patch looks good, some nitpicks below.

On Mon, Mar 06, 2023 at 12:03:29PM +0000, Rajnesh Kanwal wrote:
> This is a follow-up patch for [0] which introduced --force-pci option

"which proposed the --force-pci [..]"? The way you have worded it makes it
sound, at least to me, like the patch was already merged.

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
> ---
>  arm/include/arm-common/kvm-arch.h        |  5 ----
>  arm/include/arm-common/kvm-config-arch.h |  8 +++----
>  builtin-run.c                            | 11 +++++++--
>  include/kvm/kvm-config.h                 |  2 +-
>  include/kvm/kvm.h                        |  6 +----
>  include/kvm/virtio.h                     |  2 ++
>  riscv/include/kvm/kvm-arch.h             |  3 ---
>  virtio/core.c                            | 29 ++++++++++++++++++++++++
>  8 files changed, 46 insertions(+), 20 deletions(-)
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
> index 9949bfe..2e620fd 100644
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

Couldn't you pass &(cfg)->virtio_transport here for the third parameter instead
of NULL as you do for the other options, to avoid special casing force-pci in
virtio_tranport_parser()?

> +			   "Force virtio devices to use PCI as their default "	\
> +			   "transport [Deprecated: Use --virtio-transport "	\

Small detail, but the usual way of adding a note to a help text is to use
curved paranthesis ( "()", see?) instead of square brackets. kvmtool does that
for the help text for kaslr-seed (see
arm/aarch64/include/kvm/kvm-config-arch.h). The man pages also use paranthesis.

> +			   "option instead]", virtio_tranport_parser, kvm),	\

Looks to me like the function name wants to be virtio_tran**s**port_parser()
(emphasis added), and the current name (without the 's') is a typo.

>          OPT_CALLBACK('\0', "irqchip", &(cfg)->irqchip,				\
>  		     "[gicv2|gicv2m|gicv3|gicv3-its]",				\
>  		     "Type of interrupt controller to emulate in the guest",	\
> diff --git a/builtin-run.c b/builtin-run.c
> index bb7e6e8..50e8796 100644
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
> +			   "Use legacy virtio transport [Deprecated:"	\
> +			   " Use --virtio-transport option instead]",	\
> +			   virtio_tranport_parser, NULL),		\
> +	OPT_CALLBACK('\0', "virtio-transport", &(cfg)->virtio_transport,\
> +		     "[pci|pci-legacy|mmio|mmio-legacy]",		\
> +		     "Type of virtio transport",			\
> +		     virtio_tranport_parser, NULL),			\
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

I was about to suggest changing this to enum virtio_trans virtio_transport,
but that means including virtio.h in this file, which leads to header
dependency hell. Let's leave that alone for now :)

>  };
>  
>  #endif
> diff --git a/include/kvm/kvm.h b/include/kvm/kvm.h
> index 3872dc6..7015def 100644
> --- a/include/kvm/kvm.h
> +++ b/include/kvm/kvm.h
> @@ -45,11 +45,7 @@ struct kvm_cpu;
>  typedef void (*mmio_handler_fn)(struct kvm_cpu *vcpu, u64 addr, u8 *data,
>  				u32 len, u8 is_write, void *ptr);
>  
> -/* Archs can override this in kvm-arch.h */
> -#ifndef VIRTIO_DEFAULT_TRANS
> -#define VIRTIO_DEFAULT_TRANS(kvm) \
> -	((kvm)->cfg.virtio_legacy ? VIRTIO_PCI_LEGACY : VIRTIO_PCI)
> -#endif
> +#define VIRTIO_DEFAULT_TRANS(kvm) (kvm)->cfg.virtio_transport

Well, the purpose of the define was to allow architectures to override it,
the way arm did it.

Since all architectures behave the same way now and there is no need for an
override, how about we drop the macro altogether? We can also remove the
virtio_trans parameter from virtio_init(), because it already has a
reference to kvm.

>  
>  enum {
>  	KVM_VMSTATE_RUNNING,
> diff --git a/include/kvm/virtio.h b/include/kvm/virtio.h
> index 94bddef..4a733f5 100644
> --- a/include/kvm/virtio.h
> +++ b/include/kvm/virtio.h
> @@ -248,4 +248,6 @@ void virtio_set_guest_features(struct kvm *kvm, struct virtio_device *vdev,
>  void virtio_notify_status(struct kvm *kvm, struct virtio_device *vdev,
>  			  void *dev, u8 status);
>  
> +int virtio_tranport_parser(const struct option *opt, const char *arg, int unset);
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
> diff --git a/virtio/core.c b/virtio/core.c
> index ea0e5b6..4b863c7 100644
> --- a/virtio/core.c
> +++ b/virtio/core.c
> @@ -21,6 +21,35 @@ const char* virtio_trans_name(enum virtio_trans trans)
>  	return "unknown";
>  }
>  
> +int virtio_tranport_parser(const struct option *opt, const char *arg, int unset)

If --virtio-transport is not specified on the kvmtool command line, then
the default transport is set to VIRTIO_PCI, because that is the first
member in the virtio_trans enum, and struct kvm is initialized to 0 in
kvm__new() when it's allocated with calloc.

The above can be obscure for someone who is not familiar with the code. I
think making the default explicit, by setting kvm->cfg.virtio_transport =
VIRTIO_PCI in kvm_cmd_run_init(), before the command line arguments are
parsed, would be clearer.

Thanks,
Alex

> +{
> +	enum virtio_trans *type = opt->value;
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
> +		struct kvm *kvm = opt->ptr;
> +		kvm->cfg.virtio_transport = VIRTIO_PCI;
> +	}
> +
> +	return 0;
> +}
> +
>  void virt_queue__used_idx_advance(struct virt_queue *queue, u16 jump)
>  {
>  	u16 idx = virtio_guest_to_host_u16(queue, queue->vring.used->idx);
> -- 
> 2.25.1
> 
