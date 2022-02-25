Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F4A24C46F1
	for <lists+kvm@lfdr.de>; Fri, 25 Feb 2022 14:54:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238418AbiBYNyQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Feb 2022 08:54:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230078AbiBYNyO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Feb 2022 08:54:14 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1E0D61A8C91
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 05:53:40 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E23DC106F;
        Fri, 25 Feb 2022 05:53:39 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 271CA3F5A1;
        Fri, 25 Feb 2022 05:53:38 -0800 (PST)
Date:   Fri, 25 Feb 2022 13:54:03 +0000
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Sebastian Ene <sebastianene@google.com>
Cc:     kvm@vger.kernel.org, qperret@google.com, maz@kernel.org,
        kvmarm@lists.cs.columbia.edu, will@kernel.org,
        julien.thierry.kdev@gmail.com
Subject: Re: [PATCH kvmtool v4 1/3] aarch64: Add stolen time support
Message-ID: <Yhjfe7yuIW8WGot6@monolith.localdoman>
References: <20220224165103.1157358-1-sebastianene@google.com>
 <20220224165103.1157358-2-sebastianene@google.com>
 <YhjDl/1BvaMu3d/9@monolith.localdoman>
 <YhjX1kHqDuVaGH/l@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YhjX1kHqDuVaGH/l@google.com>
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On Fri, Feb 25, 2022 at 01:21:26PM +0000, Sebastian Ene wrote:
> On Fri, Feb 25, 2022 at 11:55:03AM +0000, Alexandru Elisei wrote:
> > Hi,
> > 
> 
> Hi,
> 
> > On Thu, Feb 24, 2022 at 04:51:03PM +0000, Sebastian Ene wrote:
> > > This patch adds support for stolen time by sharing a memory region
> > > with the guest which will be used by the hypervisor to store the stolen
> > > time information. Reserve a 64kb MMIO memory region after the RTC peripheral
> > > to be used by pvtime. The exact format of the structure stored by the
> > > hypervisor is described in the ARM DEN0057A document.
> > > 
> > > Signed-off-by: Sebastian Ene <sebastianene@google.com>
> > > ---
> > >  Makefile                               |  1 +
> > >  arm/aarch64/arm-cpu.c                  |  1 +
> > >  arm/aarch64/include/kvm/kvm-cpu-arch.h |  1 +
> > >  arm/aarch64/pvtime.c                   | 94 ++++++++++++++++++++++++++
> > >  arm/include/arm-common/kvm-arch.h      |  6 +-
> > >  include/kvm/kvm-config.h               |  1 +
> > >  6 files changed, 103 insertions(+), 1 deletion(-)
> > >  create mode 100644 arm/aarch64/pvtime.c
> > > 
> > > diff --git a/Makefile b/Makefile
> > > index f251147..e9121dc 100644
> > > --- a/Makefile
> > > +++ b/Makefile
> > > @@ -182,6 +182,7 @@ ifeq ($(ARCH), arm64)
> > >  	OBJS		+= arm/aarch64/arm-cpu.o
> > >  	OBJS		+= arm/aarch64/kvm-cpu.o
> > >  	OBJS		+= arm/aarch64/kvm.o
> > > +	OBJS		+= arm/aarch64/pvtime.o
> > >  	ARCH_INCLUDE	:= $(HDRS_ARM_COMMON)
> > >  	ARCH_INCLUDE	+= -Iarm/aarch64/include
> > >  
> > > diff --git a/arm/aarch64/arm-cpu.c b/arm/aarch64/arm-cpu.c
> > > index d7572b7..326fb20 100644
> > > --- a/arm/aarch64/arm-cpu.c
> > > +++ b/arm/aarch64/arm-cpu.c
> > > @@ -22,6 +22,7 @@ static void generate_fdt_nodes(void *fdt, struct kvm *kvm)
> > >  static int arm_cpu__vcpu_init(struct kvm_cpu *vcpu)
> > >  {
> > >  	vcpu->generate_fdt_nodes = generate_fdt_nodes;
> > > +	kvm_cpu__setup_pvtime(vcpu);
> > >  	return 0;
> > >  }
> > >  
> > > diff --git a/arm/aarch64/include/kvm/kvm-cpu-arch.h b/arm/aarch64/include/kvm/kvm-cpu-arch.h
> > > index 8dfb82e..b57d6e6 100644
> > > --- a/arm/aarch64/include/kvm/kvm-cpu-arch.h
> > > +++ b/arm/aarch64/include/kvm/kvm-cpu-arch.h
> > > @@ -19,5 +19,6 @@
> > >  
> > >  void kvm_cpu__select_features(struct kvm *kvm, struct kvm_vcpu_init *init);
> > >  int kvm_cpu__configure_features(struct kvm_cpu *vcpu);
> > > +void kvm_cpu__setup_pvtime(struct kvm_cpu *vcpu);
> > >  
> > >  #endif /* KVM__KVM_CPU_ARCH_H */
> > > diff --git a/arm/aarch64/pvtime.c b/arm/aarch64/pvtime.c
> > > new file mode 100644
> > > index 0000000..8251f6a
> > > --- /dev/null
> > > +++ b/arm/aarch64/pvtime.c
> > > @@ -0,0 +1,94 @@
> > > +#include "kvm/kvm.h"
> > > +#include "kvm/kvm-cpu.h"
> > > +#include "kvm/util.h"
> > > +
> > > +#include <linux/byteorder.h>
> > > +#include <linux/types.h>
> > > +
> > > +#define ARM_PVTIME_STRUCT_SIZE		(64)
> > > +
> > > +struct pvtime_data_priv {
> > > +	bool	is_supported;
> > > +	char	*usr_mem;
> > > +};
> > > +
> > > +static struct pvtime_data_priv pvtime_data = {
> > > +	.is_supported	= true,
> > > +	.usr_mem	= NULL
> > > +};
> > > +
> > > +static int pvtime__alloc_region(struct kvm *kvm)
> > > +{
> > > +	char *mem;
> > > +	int ret = 0;
> > > +
> > > +	mem = mmap(NULL, ARM_PVTIME_MMIO_SIZE, PROT_RW,
> > > +		   MAP_ANON_NORESERVE, -1, 0);
> > > +	if (mem == MAP_FAILED)
> > > +		return -ENOMEM;
> > 
> > Hm... man 2 mmap lists a few dozen error codes, why use -ENOMEM here instead of
> > -errno? This just makes debugging harder.
> > 
> 
> I will return the -errno error code here.
> 
> > > +
> > > +	ret = kvm__register_dev_mem(kvm, ARM_PVTIME_MMIO_BASE,
> > > +				    ARM_PVTIME_MMIO_SIZE, mem);
> > > +	if (ret) {
> > > +		munmap(mem, ARM_PVTIME_MMIO_SIZE);
> > > +		return ret;
> > > +	}
> > > +
> > > +	pvtime_data.usr_mem = mem;
> > > +	return ret;
> > > +}
> > > +
> > > +static int pvtime__teardown_region(struct kvm *kvm)
> > > +{
> > > +	if (pvtime_data.usr_mem == NULL)
> > > +		return 0;
> > > +
> > > +	kvm__destroy_mem(kvm, ARM_PVTIME_MMIO_BASE,
> > > +			 ARM_PVTIME_MMIO_SIZE, pvtime_data.usr_mem);
> > > +	munmap(pvtime_data.usr_mem, ARM_PVTIME_MMIO_SIZE);
> > > +	pvtime_data.usr_mem = NULL;
> > > +	return 0;
> > > +}
> > > +
> > > +void kvm_cpu__setup_pvtime(struct kvm_cpu *vcpu)
> > > +{
> > > +	int ret;
> > > +	u64 pvtime_guest_addr = ARM_PVTIME_MMIO_BASE + vcpu->cpu_id *
> > 
> > That's trange, cpu_id is not initialized here because target->init() is called
> > before setting up the cpu_id. The following patch in the series, "aarch64:
> > Populate the vCPU struct before target->init()" should come before this one.
> > 
> > > +		ARM_PVTIME_STRUCT_SIZE;
> > > +	struct kvm_config *kvm_cfg = NULL;
> > > +	struct kvm_device_attr pvtime_attr = (struct kvm_device_attr) {
> > > +		.group	= KVM_ARM_VCPU_PVTIME_CTRL,
> > > +		.addr	= KVM_ARM_VCPU_PVTIME_IPA
> > > +	};
> > > +
> > > +	BUG_ON(!vcpu);
> > > +	BUG_ON(!vcpu->kvm);
> > > +
> > > +	kvm_cfg = &vcpu->kvm->cfg;
> > > +	if (kvm_cfg && kvm_cfg->no_pvtime)
> > 
> > If you move the next patch in the series before this one, all the above checks
> > will not be needed and should be removed.
> > 
> > In general, each patch in a series should be able to build properly and run a VM
> > without errors. This is to help users when bisecting [1]. If I build kvmtool
> > from this patch and I try to run a VM I get the error:
> > 
> > Error: BUG at arm/aarch64/pvtime.c:65
> > 
> > [1] https://github.com/torvalds/linux/blob/master/Documentation/process/submitting-patches.rst#separate-your-changes
> > 
> 
> I will move the patch that handles the structure initialisation before
> this one and I will remove those checks. Thanks for the suggestion !
> 
> > > +		return;
> > > +
> > > +	if (!pvtime_data.is_supported)
> > > +		return;
> > > +
> > > +	ret = ioctl(vcpu->vcpu_fd, KVM_HAS_DEVICE_ATTR, &pvtime_attr);
> > > +	if (ret)
> > > +		goto out_err;
> > 
> > You should check that pvtime is supported by checking the KVM_CAP_STEAL_TIME on
> > the VM fd, as that's how capabilities are advertised by KVM.
> > 
> 
> I thought that it is sufficient to verify that it has the device
> attributes for *PVTIME. I will add this check too, thanks for the
> suggestion !
> 
> > > +
> > > +	if (!pvtime_data.usr_mem) {
> > > +		ret = pvtime__alloc_region(vcpu->kvm);
> > 
> > pvtime__alloc_region() can fail pretty catastrophically, is it ok to ignore it
> > and go on? I would have expected kvm_cpu__setup_pvtime() to return an error
> > which is then propagated to target->init().
> >
> 
> Hmm, I didn't propagate the error code from kvm_cpu__setup_pvtime()
> because if this feature is not supported it will hit:"Unable to
> initialise vcpu".

That's totally fine. If the feature is not supported by KVM, then return 0
from kvm_cpu__setup_pvtime(). But if the capability is supported by KVM and
kvmtool encounters and error when it tries to configure it, then kvmtool
should abort and complain loudly about it.

For example, kvmtool already unconditionally tries to enable SVE if KVM
supports it (look at kvm_cpu__arch_init() ->
kvm_cpu__configure_features()), and it dies if it cannot finalize the VCPU
(which is the final stage in SVE configuration).

> 
> But I guess that now we can propagate the error code as we have '--no-pvtime'
> command argument. What do you think ?

Yes, please propagate the error.

Thanks,
Alex

> 
> > > +		if (ret)
> > > +			goto out_err;
> > > +	}
> > > +
> > > +	pvtime_attr.addr = (u64)&pvtime_guest_addr;
> > > +	ret = ioctl(vcpu->vcpu_fd, KVM_SET_DEVICE_ATTR, &pvtime_attr);
> > > +	if (!ret)
> > > +		return;
> > > +
> > > +	pvtime__teardown_region(vcpu->kvm);
> > > +out_err:
> > > +	pvtime_data.is_supported = false;
> > > +}
> > > +
> > > +dev_exit(pvtime__teardown_region);
> > 
> > It is customary to put the dev_exit() exactly after the function it refers to.
> > 
> 
> I will move this.
> 
> > > diff --git a/arm/include/arm-common/kvm-arch.h b/arm/include/arm-common/kvm-arch.h
> > > index c645ac0..3f82663 100644
> > > --- a/arm/include/arm-common/kvm-arch.h
> > > +++ b/arm/include/arm-common/kvm-arch.h
> > > @@ -15,7 +15,8 @@
> > >   * |  PCI  |////| plat  |       |        |     |         |
> > >   * |  I/O  |////| MMIO: | Flash | virtio | GIC |   PCI   |  DRAM
> > >   * | space |////| UART, |       |  MMIO  |     |  (AXI)  |
> > > - * |       |////| RTC   |       |        |     |         |
> > > + * |       |////| RTC,  |       |        |     |         |
> > > + * |       |////| PVTIME|       |        |     |         |
> > >   * +-------+----+-------+-------+--------+-----+---------+---......
> > >   */
> > >  
> > > @@ -34,6 +35,9 @@
> > >  #define ARM_RTC_MMIO_BASE	(ARM_UART_MMIO_BASE + ARM_UART_MMIO_SIZE)
> > >  #define ARM_RTC_MMIO_SIZE	0x10000
> > >  
> > > +#define ARM_PVTIME_MMIO_BASE	(ARM_RTC_MMIO_BASE + ARM_RTC_MMIO_SIZE)
> > > +#define ARM_PVTIME_MMIO_SIZE	SZ_64K
> > 
> > This looks good.
> > 
> > Thanks,
> > Alex
> >
> 
> Thanks for the review,
> Sebastian
> 
> > > +
> > >  #define KVM_FLASH_MMIO_BASE	(ARM_MMIO_AREA + 0x1000000)
> > >  #define KVM_FLASH_MAX_SIZE	0x1000000
> > >  
> > > diff --git a/include/kvm/kvm-config.h b/include/kvm/kvm-config.h
> > > index 6a5720c..48adf27 100644
> > > --- a/include/kvm/kvm-config.h
> > > +++ b/include/kvm/kvm-config.h
> > > @@ -62,6 +62,7 @@ struct kvm_config {
> > >  	bool no_dhcp;
> > >  	bool ioport_debug;
> > >  	bool mmio_debug;
> > > +	bool no_pvtime;
> > >  };
> > >  
> > >  #endif
> > > -- 
> > > 2.35.1.473.g83b2b277ed-goog
> > > 
> > > _______________________________________________
> > > kvmarm mailing list
> > > kvmarm@lists.cs.columbia.edu
> > > https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
