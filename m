Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96D2F4D14FE
	for <lists+kvm@lfdr.de>; Tue,  8 Mar 2022 11:44:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345942AbiCHKpS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Mar 2022 05:45:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235914AbiCHKpR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Mar 2022 05:45:17 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C4A734130B
        for <kvm@vger.kernel.org>; Tue,  8 Mar 2022 02:44:20 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 950FE1FB;
        Tue,  8 Mar 2022 02:44:20 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 684AA3FA45;
        Tue,  8 Mar 2022 02:44:18 -0800 (PST)
Date:   Tue, 8 Mar 2022 10:44:40 +0000
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Sebastian Ene <sebastianene@google.com>
Cc:     kvm@vger.kernel.org, qperret@google.com, maz@kernel.org,
        kvmarm@lists.cs.columbia.edu, will@kernel.org,
        julien.thierry.kdev@gmail.com
Subject: Re: [PATCH kvmtool v8 2/3] aarch64: Add stolen time support
Message-ID: <YiczmAGAIf0BYLNr@monolith.localdoman>
References: <20220307144243.2039409-1-sebastianene@google.com>
 <20220307144243.2039409-3-sebastianene@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220307144243.2039409-3-sebastianene@google.com>
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On Mon, Mar 07, 2022 at 02:42:43PM +0000, Sebastian Ene wrote:
> This patch adds support for stolen time by sharing a memory region
> with the guest which will be used by the hypervisor to store the stolen
> time information. Reserve a 64kb MMIO memory region after the RTC peripheral
> to be used by pvtime. The exact format of the structure stored by the
> hypervisor is described in the ARM DEN0057A document.
> 
> Signed-off-by: Sebastian Ene <sebastianene@google.com>
> ---
>  Makefile                               |   1 +
>  arm/aarch64/arm-cpu.c                  |   2 +-
>  arm/aarch64/include/kvm/kvm-cpu-arch.h |   2 +
>  arm/aarch64/pvtime.c                   | 108 +++++++++++++++++++++++++
>  arm/include/arm-common/kvm-arch.h      |   6 +-
>  arm/kvm-cpu.c                          |   1 +
>  include/kvm/kvm-config.h               |   1 +
>  7 files changed, 119 insertions(+), 2 deletions(-)
>  create mode 100644 arm/aarch64/pvtime.c
> 
> diff --git a/Makefile b/Makefile
> index f251147..e9121dc 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -182,6 +182,7 @@ ifeq ($(ARCH), arm64)
>  	OBJS		+= arm/aarch64/arm-cpu.o
>  	OBJS		+= arm/aarch64/kvm-cpu.o
>  	OBJS		+= arm/aarch64/kvm.o
> +	OBJS		+= arm/aarch64/pvtime.o
>  	ARCH_INCLUDE	:= $(HDRS_ARM_COMMON)
>  	ARCH_INCLUDE	+= -Iarm/aarch64/include
>  
> diff --git a/arm/aarch64/arm-cpu.c b/arm/aarch64/arm-cpu.c
> index d7572b7..7e4a3c1 100644
> --- a/arm/aarch64/arm-cpu.c
> +++ b/arm/aarch64/arm-cpu.c
> @@ -22,7 +22,7 @@ static void generate_fdt_nodes(void *fdt, struct kvm *kvm)
>  static int arm_cpu__vcpu_init(struct kvm_cpu *vcpu)
>  {
>  	vcpu->generate_fdt_nodes = generate_fdt_nodes;
> -	return 0;
> +	return kvm_cpu__setup_pvtime(vcpu);
>  }
>  
>  static struct kvm_arm_target target_generic_v8 = {
> diff --git a/arm/aarch64/include/kvm/kvm-cpu-arch.h b/arm/aarch64/include/kvm/kvm-cpu-arch.h
> index 8dfb82e..35996dc 100644
> --- a/arm/aarch64/include/kvm/kvm-cpu-arch.h
> +++ b/arm/aarch64/include/kvm/kvm-cpu-arch.h
> @@ -19,5 +19,7 @@
>  
>  void kvm_cpu__select_features(struct kvm *kvm, struct kvm_vcpu_init *init);
>  int kvm_cpu__configure_features(struct kvm_cpu *vcpu);
> +int kvm_cpu__setup_pvtime(struct kvm_cpu *vcpu);
> +int kvm_cpu__teardown_pvtime(struct kvm *kvm);
>  
>  #endif /* KVM__KVM_CPU_ARCH_H */
> diff --git a/arm/aarch64/pvtime.c b/arm/aarch64/pvtime.c
> new file mode 100644
> index 0000000..4db2e9f
> --- /dev/null
> +++ b/arm/aarch64/pvtime.c
> @@ -0,0 +1,108 @@
> +#include "kvm/kvm.h"
> +#include "kvm/kvm-cpu.h"
> +#include "kvm/util.h"
> +
> +#include <linux/byteorder.h>
> +#include <linux/types.h>
> +
> +#define ARM_PVTIME_STRUCT_SIZE		(64)
> +
> +struct pvtime_data_priv {
> +	bool	is_failed_cfg;
> +	void	*usr_mem;
> +};
> +
> +static struct pvtime_data_priv pvtime_data = {
> +	.is_failed_cfg	= true,
> +	.usr_mem	= NULL
> +};
> +
> +static int pvtime__alloc_region(struct kvm *kvm)
> +{
> +	char *mem;
> +	int ret = 0;
> +
> +	mem = mmap(NULL, ARM_PVTIME_BASE, PROT_RW,
> +		   MAP_ANON_NORESERVE, -1, 0);
> +	if (mem == MAP_FAILED)
> +		return -errno;
> +
> +	ret = kvm__register_ram(kvm, ARM_PVTIME_BASE,
> +				ARM_PVTIME_BASE, mem);
> +	if (ret) {
> +		munmap(mem, ARM_PVTIME_BASE);
> +		return ret;
> +	}
> +
> +	pvtime_data.usr_mem = mem;
> +	return ret;
> +}
> +
> +static int pvtime__teardown_region(struct kvm *kvm)
> +{
> +	if (pvtime_data.usr_mem == NULL)
> +		return 0;
> +
> +	kvm__destroy_mem(kvm, ARM_PVTIME_BASE,
> +			 ARM_PVTIME_BASE, pvtime_data.usr_mem);
> +	munmap(pvtime_data.usr_mem, ARM_PVTIME_BASE);
> +	pvtime_data.usr_mem = NULL;
> +	return 0;
> +}
> +
> +int kvm_cpu__setup_pvtime(struct kvm_cpu *vcpu)
> +{
> +	int ret;
> +	bool has_stolen_time;
> +	u64 pvtime_guest_addr = ARM_PVTIME_BASE + vcpu->cpu_id *
> +		ARM_PVTIME_STRUCT_SIZE;
> +	struct kvm_config *kvm_cfg = NULL;
> +	struct kvm_device_attr pvtime_attr = (struct kvm_device_attr) {
> +		.group	= KVM_ARM_VCPU_PVTIME_CTRL,
> +		.addr	= KVM_ARM_VCPU_PVTIME_IPA
> +	};
> +
> +	kvm_cfg = &vcpu->kvm->cfg;
> +	if (kvm_cfg->no_pvtime)
> +		return 0;
> +
> +	if (!pvtime_data.is_failed_cfg)
> +		return -ENOTSUP;
> +
> +	has_stolen_time = kvm__supports_extension(vcpu->kvm,
> +						  KVM_CAP_STEAL_TIME);
> +	if (!has_stolen_time) {
> +		kvm_cfg->no_pvtime = true;
> +		return 0;
> +	}
> +
> +	ret = ioctl(vcpu->vcpu_fd, KVM_HAS_DEVICE_ATTR, &pvtime_attr);
> +	if (ret) {
> +		perror("KVM_HAS_DEVICE_ATTR failed\n");
> +		goto out_err;
> +	}
> +
> +	if (!pvtime_data.usr_mem) {
> +		ret = pvtime__alloc_region(vcpu->kvm);
> +		if (ret) {
> +			perror("Failed allocating pvtime region\n");
> +			goto out_err;
> +		}
> +	}
> +
> +	pvtime_attr.addr = (u64)&pvtime_guest_addr;
> +	ret = ioctl(vcpu->vcpu_fd, KVM_SET_DEVICE_ATTR, &pvtime_attr);
> +	if (!ret)
> +		return 0;
> +
> +	perror("KVM_SET_DEVICE_ATTR failed\n");
> +	pvtime__teardown_region(vcpu->kvm);
> +out_err:
> +	pvtime_data.is_failed_cfg = false;

kvm_cpu__init() calls kvm_cpu__arch_init()->kvm_cpu__setup_pvtime() for each
VCPU from the main thread (so sequentually), not from the VCPU threads.  If this
function returns an error, kvm_cpu__arch_init() calls die(), which means that
kvmtool will terminate without calling kvm_cpu__setup_pvtime() for the other
VCPUs.

What I'm trying to say is that the field is_failed_cfg is not useful, because if
one VCPU fails initialization, then kvmtool will not attempt to initialize the
rest of the VCPUs.

If you drop is_failed_cfg you can also drop the pvtime_data_priv struct and use
a static user_mem variable (up to you).

> +	return ret;
> +}
> +
> +int kvm_cpu__teardown_pvtime(struct kvm *kvm)
> +{
> +	return pvtime__teardown_region(kvm);
> +}
> diff --git a/arm/include/arm-common/kvm-arch.h b/arm/include/arm-common/kvm-arch.h
> index c645ac0..43b1f77 100644
> --- a/arm/include/arm-common/kvm-arch.h
> +++ b/arm/include/arm-common/kvm-arch.h
> @@ -15,7 +15,8 @@
>   * |  PCI  |////| plat  |       |        |     |         |
>   * |  I/O  |////| MMIO: | Flash | virtio | GIC |   PCI   |  DRAM
>   * | space |////| UART, |       |  MMIO  |     |  (AXI)  |
> - * |       |////| RTC   |       |        |     |         |
> + * |       |////| RTC,  |       |        |     |         |
> + * |       |////| PVTIME|       |        |     |         |
>   * +-------+----+-------+-------+--------+-----+---------+---......
>   */
>  
> @@ -34,6 +35,9 @@
>  #define ARM_RTC_MMIO_BASE	(ARM_UART_MMIO_BASE + ARM_UART_MMIO_SIZE)
>  #define ARM_RTC_MMIO_SIZE	0x10000
>  
> +#define ARM_PVTIME_BASE		(ARM_RTC_MMIO_BASE + ARM_RTC_MMIO_SIZE)
> +#define ARM_PVTIME_SIZE		SZ_64K
> +
>  #define KVM_FLASH_MMIO_BASE	(ARM_MMIO_AREA + 0x1000000)
>  #define KVM_FLASH_MAX_SIZE	0x1000000
>  
> diff --git a/arm/kvm-cpu.c b/arm/kvm-cpu.c
> index 84ac1e9..00660d6 100644
> --- a/arm/kvm-cpu.c
> +++ b/arm/kvm-cpu.c
> @@ -144,6 +144,7 @@ void kvm_cpu__arch_nmi(struct kvm_cpu *cpu)
>  
>  void kvm_cpu__delete(struct kvm_cpu *vcpu)
>  {
> +	kvm_cpu__teardown_pvtime(vcpu->kvm);

This causes compilation for aarch32 to fail:

arm/kvm-cpu.c: In function ‘kvm_cpu__delete’:
arm/kvm-cpu.c:147:2: error: implicit declaration of function ‘kvm_cpu__teardown_pvtime’ [-Werror=implicit-function-declaration]
  147 |  kvm_cpu__teardown_pvtime(vcpu->kvm);
      |  ^~~~~~~~~~~~~~~~~~~~~~~~
arm/kvm-cpu.c:147:2: error: nested extern declaration of ‘kvm_cpu__teardown_pvtime’ [-Werror=nested-externs]
cc1: all warnings being treated as errors
make: *** [Makefile:482: arm/kvm-cpu.o] Error 1

The reason for that is that there is no stub for kvm_cpu__teardown_pvtime() for
aarch32. This fixes the compilation error for me:

diff --git a/arm/aarch32/include/kvm/kvm-cpu-arch.h b/arm/aarch32/include/kvm/kvm-cpu-arch.h
index 780e0e2f0934..ae77a136d0ce 100644
--- a/arm/aarch32/include/kvm/kvm-cpu-arch.h
+++ b/arm/aarch32/include/kvm/kvm-cpu-arch.h
@@ -19,5 +19,9 @@ static inline int kvm_cpu__configure_features(struct kvm_cpu *vcpu)
 {
        return 0;
 }
+static inline int kvm_cpu__teardown_pvtime(struct kvm *kvm)
+{
+       return 0;
+}

 #endif /* KVM__KVM_CPU_ARCH_H */

Thanks,
Alex

>  	free(vcpu);
>  }
>  
> diff --git a/include/kvm/kvm-config.h b/include/kvm/kvm-config.h
> index 6a5720c..48adf27 100644
> --- a/include/kvm/kvm-config.h
> +++ b/include/kvm/kvm-config.h
> @@ -62,6 +62,7 @@ struct kvm_config {
>  	bool no_dhcp;
>  	bool ioport_debug;
>  	bool mmio_debug;
> +	bool no_pvtime;
>  };
>  
>  #endif
> -- 
> 2.35.1.616.g0bdcbb4464-goog
> 
