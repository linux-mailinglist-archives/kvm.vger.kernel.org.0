Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2C9E331EA3
	for <lists+kvm@lfdr.de>; Tue,  9 Mar 2021 06:27:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230228AbhCIF1W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Mar 2021 00:27:22 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25038 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229726AbhCIF1F (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 9 Mar 2021 00:27:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615267624;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=X78VEc4H4G4p3+XiuQ7VvW/ZhmkKUF0PlBhzSEWxJl0=;
        b=J1tBfZ2nwtF8CPwf4uce34zHxEV8CDC2cVHwEDI6chXqaPmLXtmXaQx7q/HUz0RSTC4UNQ
        3TltexFUa4lqI2t/h+Lkb7DmBfFzZSE5vVA5cWDri4c4zaK9bIikIHL6TxlPdp5Njun/ar
        mODwfqjLk5Nh2FjrquZQ1ynnFQnPKGA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-33-Ij2M4T4XNDKoi4JHq_8xHw-1; Tue, 09 Mar 2021 00:27:02 -0500
X-MC-Unique: Ij2M4T4XNDKoi4JHq_8xHw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3D27851A7;
        Tue,  9 Mar 2021 05:27:00 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-12-195.pek2.redhat.com [10.72.12.195])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F37C96F968;
        Tue,  9 Mar 2021 05:26:49 +0000 (UTC)
Subject: Re: [RFC v3 1/5] KVM: add initial support for KVM_SET_IOREGION
To:     Elena Afanasova <eafanasova@gmail.com>, kvm@vger.kernel.org
Cc:     stefanha@redhat.com, jag.raman@oracle.com,
        elena.ufimtseva@oracle.com, pbonzini@redhat.com, mst@redhat.com,
        cohuck@redhat.com, john.levon@nutanix.com
References: <cover.1613828726.git.eafanasova@gmail.com>
 <f77bbc58289508b5b0633521cf8c03eb0303707a.1613828727.git.eafanasova@gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <41e24c31-8742-099d-5011-9b762faa8670@redhat.com>
Date:   Tue, 9 Mar 2021 13:26:48 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <f77bbc58289508b5b0633521cf8c03eb0303707a.1613828727.git.eafanasova@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2021/2/21 8:04 下午, Elena Afanasova wrote:
> This vm ioctl adds or removes an ioregionfd MMIO/PIO region. Guest
> read and write accesses are dispatched through the given ioregionfd
> instead of returning from ioctl(KVM_RUN).
>
> Signed-off-by: Elena Afanasova <eafanasova@gmail.com>
> ---
> v3:
>   - add FAST_MMIO bus support
>   - add KVM_IOREGION_DEASSIGN flag
>   - rename kvm_ioregion read/write file descriptors
>
>   arch/x86/kvm/Kconfig     |   1 +
>   arch/x86/kvm/Makefile    |   1 +
>   arch/x86/kvm/x86.c       |   1 +
>   include/linux/kvm_host.h |  18 +++
>   include/uapi/linux/kvm.h |  25 ++++
>   virt/kvm/Kconfig         |   3 +
>   virt/kvm/eventfd.c       |  25 ++++
>   virt/kvm/eventfd.h       |  14 +++
>   virt/kvm/ioregion.c      | 265 +++++++++++++++++++++++++++++++++++++++
>   virt/kvm/ioregion.h      |  15 +++
>   virt/kvm/kvm_main.c      |  11 ++
>   11 files changed, 379 insertions(+)
>   create mode 100644 virt/kvm/eventfd.h
>   create mode 100644 virt/kvm/ioregion.c
>   create mode 100644 virt/kvm/ioregion.h
>
> diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
> index f92dfd8ef10d..b914ef375199 100644
> --- a/arch/x86/kvm/Kconfig
> +++ b/arch/x86/kvm/Kconfig
> @@ -33,6 +33,7 @@ config KVM
>   	select HAVE_KVM_IRQ_BYPASS
>   	select HAVE_KVM_IRQ_ROUTING
>   	select HAVE_KVM_EVENTFD
> +	select KVM_IOREGION
>   	select KVM_ASYNC_PF
>   	select USER_RETURN_NOTIFIER
>   	select KVM_MMIO
> diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
> index b804444e16d4..b3b17dc9f7d4 100644
> --- a/arch/x86/kvm/Makefile
> +++ b/arch/x86/kvm/Makefile
> @@ -12,6 +12,7 @@ KVM := ../../../virt/kvm
>   kvm-y			+= $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o \
>   				$(KVM)/eventfd.o $(KVM)/irqchip.o $(KVM)/vfio.o
>   kvm-$(CONFIG_KVM_ASYNC_PF)	+= $(KVM)/async_pf.o
> +kvm-$(CONFIG_KVM_IOREGION)	+= $(KVM)/ioregion.o
>   
>   kvm-y			+= x86.o emulate.o i8259.o irq.o lapic.o \
>   			   i8254.o ioapic.o irq_comm.o cpuid.o pmu.o mtrr.o \
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index e545a8a613b1..ddb28f5ca252 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -3739,6 +3739,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>   	case KVM_CAP_X86_USER_SPACE_MSR:
>   	case KVM_CAP_X86_MSR_FILTER:
>   	case KVM_CAP_ENFORCE_PV_FEATURE_CPUID:
> +	case KVM_CAP_IOREGIONFD:
>   		r = 1;
>   		break;
>   	case KVM_CAP_SYNC_REGS:
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 7f2e2a09ebbd..f35f0976f5cf 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -470,6 +470,11 @@ struct kvm {
>   		struct mutex      resampler_lock;
>   	} irqfds;
>   	struct list_head ioeventfds;
> +#endif
> +#ifdef CONFIG_KVM_IOREGION
> +	struct list_head ioregions_fast_mmio;
> +	struct list_head ioregions_mmio;
> +	struct list_head ioregions_pio;
>   #endif
>   	struct kvm_vm_stat stat;
>   	struct kvm_arch arch;
> @@ -1262,6 +1267,19 @@ static inline int kvm_ioeventfd(struct kvm *kvm, struct kvm_ioeventfd *args)
>   
>   #endif /* CONFIG_HAVE_KVM_EVENTFD */
>   
> +#ifdef CONFIG_KVM_IOREGION
> +void kvm_ioregionfd_init(struct kvm *kvm);
> +int kvm_ioregionfd(struct kvm *kvm, struct kvm_ioregion *args);
> +
> +#else
> +
> +static inline void kvm_ioregionfd_init(struct kvm *kvm) {}
> +static inline int kvm_ioregionfd(struct kvm *kvm, struct kvm_ioregion *args)
> +{
> +	return -ENOSYS;
> +}
> +#endif
> +
>   void kvm_arch_irq_routing_update(struct kvm *kvm);
>   
>   static inline void kvm_make_request(int req, struct kvm_vcpu *vcpu)
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index ca41220b40b8..a1b1a60571f8 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -732,6 +732,29 @@ struct kvm_ioeventfd {
>   	__u8  pad[36];
>   };
>   
> +enum {
> +	kvm_ioregion_flag_nr_pio,
> +	kvm_ioregion_flag_nr_posted_writes,
> +	kvm_ioregion_flag_nr_deassign,
> +	kvm_ioregion_flag_nr_max,
> +};
> +
> +#define KVM_IOREGION_PIO (1 << kvm_ioregion_flag_nr_pio)
> +#define KVM_IOREGION_POSTED_WRITES (1 << kvm_ioregion_flag_nr_posted_writes)
> +#define KVM_IOREGION_DEASSIGN (1 << kvm_ioregion_flag_nr_deassign)
> +
> +#define KVM_IOREGION_VALID_FLAG_MASK ((1 << kvm_ioregion_flag_nr_max) - 1)
> +
> +struct kvm_ioregion {
> +	__u64 guest_paddr; /* guest physical address */
> +	__u64 memory_size; /* bytes */
> +	__u64 user_data;
> +	__s32 read_fd;
> +	__s32 write_fd;
> +	__u32 flags;
> +	__u8  pad[28];
> +};
> +
>   #define KVM_X86_DISABLE_EXITS_MWAIT          (1 << 0)
>   #define KVM_X86_DISABLE_EXITS_HLT            (1 << 1)
>   #define KVM_X86_DISABLE_EXITS_PAUSE          (1 << 2)
> @@ -1053,6 +1076,7 @@ struct kvm_ppc_resize_hpt {
>   #define KVM_CAP_X86_USER_SPACE_MSR 188
>   #define KVM_CAP_X86_MSR_FILTER 189
>   #define KVM_CAP_ENFORCE_PV_FEATURE_CPUID 190
> +#define KVM_CAP_IOREGIONFD 191
>   
>   #ifdef KVM_CAP_IRQ_ROUTING
>   
> @@ -1308,6 +1332,7 @@ struct kvm_vfio_spapr_tce {
>   					struct kvm_userspace_memory_region)
>   #define KVM_SET_TSS_ADDR          _IO(KVMIO,   0x47)
>   #define KVM_SET_IDENTITY_MAP_ADDR _IOW(KVMIO,  0x48, __u64)
> +#define KVM_SET_IOREGION          _IOW(KVMIO,  0x49, struct kvm_ioregion)


I wonder how could we extend ioregion fd in the future? Do we need 
something like handshake or version here?


>   
>   /* enable ucontrol for s390 */
>   struct kvm_s390_ucas_mapping {
> diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
> index 1c37ccd5d402..5e6620bbf000 100644
> --- a/virt/kvm/Kconfig
> +++ b/virt/kvm/Kconfig
> @@ -17,6 +17,9 @@ config HAVE_KVM_EVENTFD
>          bool
>          select EVENTFD
>   
> +config KVM_IOREGION
> +       boolƒ
> +
>   config KVM_MMIO
>          bool
>   
> diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
> index c2323c27a28b..aadb73903f8b 100644
> --- a/virt/kvm/eventfd.c
> +++ b/virt/kvm/eventfd.c
> @@ -27,6 +27,7 @@
>   #include <trace/events/kvm.h>
>   
>   #include <kvm/iodev.h>
> +#include "ioregion.h"
>   
>   #ifdef CONFIG_HAVE_KVM_IRQFD
>   
> @@ -755,6 +756,23 @@ static const struct kvm_io_device_ops ioeventfd_ops = {
>   	.destructor = ioeventfd_destructor,
>   };
>   
> +#ifdef CONFIG_KVM_IOREGION
> +/* assumes kvm->slots_lock held */
> +bool kvm_eventfd_collides(struct kvm *kvm, int bus_idx,
> +			  u64 start, u64 size)
> +{
> +	struct _ioeventfd *_p;
> +
> +	list_for_each_entry(_p, &kvm->ioeventfds, list)
> +		if (_p->bus_idx == bus_idx &&
> +		    overlap(start, size, _p->addr,
> +			    !_p->length ? 8 : _p->length))
> +			return true;
> +
> +	return false;
> +}
> +#endif
> +
>   /* assumes kvm->slots_lock held */
>   static bool
>   ioeventfd_check_collision(struct kvm *kvm, struct _ioeventfd *p)
> @@ -770,6 +788,13 @@ ioeventfd_check_collision(struct kvm *kvm, struct _ioeventfd *p)
>   		       _p->datamatch == p->datamatch))))
>   			return true;
>   
> +#ifdef CONFIG_KVM_IOREGION
> +	if (p->bus_idx == KVM_MMIO_BUS || p->bus_idx == KVM_PIO_BUS)
> +		if (kvm_ioregion_collides(kvm, p->bus_idx, p->addr,
> +					  !p->length ? 8 : p->length))
> +			return true;
> +#endif
> +
>   	return false;
>   }
>   
> diff --git a/virt/kvm/eventfd.h b/virt/kvm/eventfd.h
> new file mode 100644
> index 000000000000..73a621eebae3
> --- /dev/null
> +++ b/virt/kvm/eventfd.h
> @@ -0,0 +1,14 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +#ifndef __KVM_EVENTFD_H__
> +#define __KVM_EVENTFD_H__
> +
> +#ifdef CONFIG_KVM_IOREGION
> +bool kvm_eventfd_collides(struct kvm *kvm, int bus_idx, u64 start, u64 size);
> +#else
> +static inline bool
> +kvm_eventfd_collides(struct kvm *kvm, int bus_idx, u64 start, u64 size)
> +{
> +	return false;
> +}
> +#endif
> +#endif
> diff --git a/virt/kvm/ioregion.c b/virt/kvm/ioregion.c
> new file mode 100644
> index 000000000000..e09ef3e2c9d7
> --- /dev/null
> +++ b/virt/kvm/ioregion.c
> @@ -0,0 +1,265 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +#include <linux/kvm_host.h>
> +#include <linux/fs.h>
> +#include <kvm/iodev.h>
> +#include "eventfd.h"
> +
> +void
> +kvm_ioregionfd_init(struct kvm *kvm)
> +{
> +	INIT_LIST_HEAD(&kvm->ioregions_fast_mmio);
> +	INIT_LIST_HEAD(&kvm->ioregions_mmio);
> +	INIT_LIST_HEAD(&kvm->ioregions_pio);
> +}
> +
> +struct ioregion {
> +	struct list_head     list;
> +	u64                  paddr;  /* guest physical address */
> +	u64                  size;   /* size in bytes */
> +	struct file         *rf;
> +	struct file         *wf;
> +	u64                  user_data; /* opaque token used by userspace */
> +	struct kvm_io_device dev;
> +	bool                 posted_writes;
> +};
> +
> +static inline struct ioregion *
> +to_ioregion(struct kvm_io_device *dev)
> +{
> +	return container_of(dev, struct ioregion, dev);
> +}
> +
> +/* assumes kvm->slots_lock held */
> +static void
> +ioregion_release(struct ioregion *p)
> +{
> +	if (p->rf)
> +		fput(p->rf);
> +	fput(p->wf);
> +	list_del(&p->list);
> +	kfree(p);
> +}
> +
> +static int
> +ioregion_read(struct kvm_vcpu *vcpu, struct kvm_io_device *this, gpa_t addr,
> +	      int len, void *val)
> +{
> +	return -EOPNOTSUPP;
> +}
> +
> +static int
> +ioregion_write(struct kvm_vcpu *vcpu, struct kvm_io_device *this, gpa_t addr,
> +		int len, const void *val)
> +{
> +	return -EOPNOTSUPP;
> +}
> +
> +/*
> + * This function is called as KVM is completely shutting down.  We do not
> + * need to worry about locking just nuke anything we have as quickly as possible
> + */
> +static void
> +ioregion_destructor(struct kvm_io_device *this)
> +{
> +	struct ioregion *p = to_ioregion(this);
> +
> +	ioregion_release(p);
> +}
> +
> +static const struct kvm_io_device_ops ioregion_ops = {
> +	.read       = ioregion_read,
> +	.write      = ioregion_write,
> +	.destructor = ioregion_destructor,
> +};
> +
> +static inline struct list_head *
> +get_ioregion_list(struct kvm *kvm, enum kvm_bus bus_idx)
> +{
> +	if (bus_idx == KVM_FAST_MMIO_BUS)
> +		return &kvm->ioregions_fast_mmio;
> +	if (bus_idx == KVM_MMIO_BUS)
> +		return &kvm->ioregions_mmio;
> +	if (bus_idx == KVM_PIO_BUS)
> +		return &kvm->ioregions_pio;
> +}
> +
> +/* check for not overlapping case and reverse */


This check is much more stricit than what has been done in 
ioeventfd_check_collision(). Any raeson for that?



> +inline bool
> +overlap(u64 start1, u64 size1, u64 start2, u64 size2)
> +{
> +	u64 end1 = start1 + size1 - 1;
> +	u64 end2 = start2 + size2 - 1;
> +
> +	return !(end1 < start2 || start1 >= end2);
> +}
> +
> +/* assumes kvm->slots_lock held */
> +bool
> +kvm_ioregion_collides(struct kvm *kvm, int bus_idx,
> +		      u64 start, u64 size)
> +{
> +	struct ioregion *p;
> +	struct list_head *ioregions = get_ioregion_list(kvm, bus_idx);
> +
> +	list_for_each_entry(p, ioregions, list)
> +		if (overlap(start, size, p->paddr, !p->size ? 8 : p->size))
> +			return true;
> +
> +	return false;
> +}
> +
> +/* assumes kvm->slots_lock held */
> +static bool
> +ioregion_collision(struct kvm *kvm, struct ioregion *p, enum kvm_bus bus_idx)
> +{
> +	if (kvm_ioregion_collides(kvm, bus_idx, p->paddr, !p->size ? 8 : p->size) ||
> +	    kvm_eventfd_collides(kvm, bus_idx, p->paddr, !p->size ? 8 : p->size))
> +		return true;
> +
> +	return false;
> +}
> +
> +static enum kvm_bus
> +get_bus_from_flags(__u32 flags)
> +{
> +	if (flags & KVM_IOREGION_PIO)
> +		return KVM_PIO_BUS;
> +	return KVM_MMIO_BUS;
> +}
> +
> +int
> +kvm_set_ioregion_idx(struct kvm *kvm, struct kvm_ioregion *args, enum kvm_bus bus_idx)
> +{
> +	struct ioregion *p;
> +	struct file *rfile = NULL, *wfile;
> +	int ret = 0;
> +
> +	wfile = fget(args->write_fd);
> +	if (!wfile)
> +		return -EBADF;
> +	if (args->memory_size) {
> +		rfile = fget(args->read_fd);
> +		if (!rfile) {
> +			fput(wfile);
> +			return -EBADF;
> +		}
> +	}
> +	p = kzalloc(sizeof(*p), GFP_KERNEL_ACCOUNT);
> +	if (!p) {
> +		ret = -ENOMEM;
> +		goto fail;
> +	}
> +
> +	INIT_LIST_HEAD(&p->list);
> +	p->paddr = args->guest_paddr;
> +	p->size = args->memory_size;
> +	p->user_data = args->user_data;
> +	p->rf = rfile;
> +	p->wf = wfile;
> +	p->posted_writes = args->flags & KVM_IOREGION_POSTED_WRITES;
> +
> +	mutex_lock(&kvm->slots_lock);
> +
> +	if (ioregion_collision(kvm, p, bus_idx)) {
> +		ret = -EEXIST;
> +		goto unlock_fail;
> +	}
> +	kvm_iodevice_init(&p->dev, &ioregion_ops);
> +	ret = kvm_io_bus_register_dev(kvm, bus_idx, p->paddr, p->size,
> +				      &p->dev);
> +	if (ret < 0)
> +		goto unlock_fail;
> +	list_add_tail(&p->list, get_ioregion_list(kvm, bus_idx));
> +
> +	mutex_unlock(&kvm->slots_lock);
> +
> +	return 0;
> +
> +unlock_fail:
> +	mutex_unlock(&kvm->slots_lock);
> +	kfree(p);
> +fail:
> +	if (rfile)
> +		fput(rfile);
> +	fput(wfile);
> +
> +	return ret;
> +}
> +
> +static int
> +kvm_rm_ioregion_idx(struct kvm *kvm, struct kvm_ioregion *args, enum kvm_bus bus_idx)
> +{
> +	struct ioregion *p, *tmp;
> +	int ret = -ENOENT;
> +
> +	struct list_head *ioregions = get_ioregion_list(kvm, bus_idx);
> +
> +	mutex_lock(&kvm->slots_lock);
> +
> +	list_for_each_entry_safe(p, tmp, ioregions, list) {
> +		if (p->paddr == args->guest_paddr  &&
> +		    p->size == args->memory_size) {
> +			kvm_io_bus_unregister_dev(kvm, bus_idx, &p->dev);
> +			ioregion_release(p);
> +			ret = 0;
> +			break;
> +		}
> +	}
> +
> +	mutex_unlock(&kvm->slots_lock);
> +
> +	return ret;
> +}
> +
> +static int
> +kvm_set_ioregion(struct kvm *kvm, struct kvm_ioregion *args)
> +{
> +	int ret;
> +
> +	enum kvm_bus bus_idx = get_bus_from_flags(args->flags);
> +
> +	/* check for range overflow */
> +	if (args->guest_paddr + args->memory_size < args->guest_paddr)
> +		return -EINVAL;
> +	/* If size is ignored only posted writes are allowed */
> +	if (!args->memory_size && !(args->flags & KVM_IOREGION_POSTED_WRITES))


We don't have flags like KVM_IOREGION_POSTED_WRITES for ioeventfd. Is 
this a must?


> +		return -EINVAL;
> +
> +	ret = kvm_set_ioregion_idx(kvm, args, bus_idx);
> +	if (ret)
> +		return ret;
> +
> +	/* If size is ignored, MMIO is also put on a FAST_MMIO bus */
> +	if (!args->memory_size && bus_idx == KVM_MMIO_BUS)
> +		ret = kvm_set_ioregion_idx(kvm, args, KVM_FAST_MMIO_BUS);
> +	if (ret) {


The check is duplicaetd if it wasn't a FAST_MMIO_BUS. Let's check only 
for FAST_MMIO.


> +		kvm_rm_ioregion_idx(kvm, args, bus_idx);
> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +static int
> +kvm_rm_ioregion(struct kvm *kvm, struct kvm_ioregion *args)
> +{


Since we use "kvm_set_ioregion" is it better to use "kvm_unset_ioregion" 
or just use assign/deassign as what ioeventfd did?

Thanks


> +	enum kvm_bus bus_idx = get_bus_from_flags(args->flags);
> +	int ret = kvm_rm_ioregion_idx(kvm, args, bus_idx);
> +
> +	if (!args->memory_size && bus_idx == KVM_MMIO_BUS)
> +		kvm_rm_ioregion_idx(kvm, args, KVM_FAST_MMIO_BUS);
> +
> +	return ret;
> +}
> +
> +int
> +kvm_ioregionfd(struct kvm *kvm, struct kvm_ioregion *args)
> +{
> +	if (args->flags & ~KVM_IOREGION_VALID_FLAG_MASK)
> +		return -EINVAL;
> +
> +	if (args->flags & KVM_IOREGION_DEASSIGN)
> +		return kvm_rm_ioregion(kvm, args);
> +
> +	return kvm_set_ioregion(kvm, args);
> +}
> diff --git a/virt/kvm/ioregion.h b/virt/kvm/ioregion.h
> new file mode 100644
> index 000000000000..23ffa812ec7a
> --- /dev/null
> +++ b/virt/kvm/ioregion.h
> @@ -0,0 +1,15 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +#ifndef __KVM_IOREGION_H__
> +#define __KVM_IOREGION_H__
> +
> +#ifdef CONFIG_KVM_IOREGION
> +inline bool overlap(u64 start1, u64 size1, u64 start2, u64 size2);
> +bool kvm_ioregion_collides(struct kvm *kvm, int bus_idx, u64 start, u64 size);
> +#else
> +static inline bool
> +kvm_ioregion_collides(struct kvm *kvm, int bus_idx, u64 start, u64 size)
> +{
> +	return false;
> +}
> +#endif
> +#endif
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 2541a17ff1c4..88b92fc3da51 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -747,6 +747,7 @@ static struct kvm *kvm_create_vm(unsigned long type)
>   	mmgrab(current->mm);
>   	kvm->mm = current->mm;
>   	kvm_eventfd_init(kvm);
> +	kvm_ioregionfd_init(kvm);
>   	mutex_init(&kvm->lock);
>   	mutex_init(&kvm->irq_lock);
>   	mutex_init(&kvm->slots_lock);
> @@ -3708,6 +3709,16 @@ static long kvm_vm_ioctl(struct file *filp,
>   		r = kvm_vm_ioctl_set_memory_region(kvm, &kvm_userspace_mem);
>   		break;
>   	}
> +	case KVM_SET_IOREGION: {
> +		struct kvm_ioregion data;
> +
> +		r = -EFAULT;
> +		if (copy_from_user(&data, argp, sizeof(data)))
> +			goto out;
> +
> +		r = kvm_ioregionfd(kvm, &data);
> +		break;
> +	}
>   	case KVM_GET_DIRTY_LOG: {
>   		struct kvm_dirty_log log;
>   

