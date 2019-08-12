Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FE098A847
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2019 22:20:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727513AbfHLUUe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Aug 2019 16:20:34 -0400
Received: from mga12.intel.com ([192.55.52.136]:47822 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727195AbfHLUUd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Aug 2019 16:20:33 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Aug 2019 13:20:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,378,1559545200"; 
   d="scan'208";a="204848918"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga002.fm.intel.com with ESMTP; 12 Aug 2019 13:20:30 -0700
Date:   Mon, 12 Aug 2019 13:20:30 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Adalbert =?utf-8?B?TGF6xINy?= <alazar@bitdefender.com>
Cc:     kvm@vger.kernel.org, linux-mm@kvack.org,
        virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Tamas K Lengyel <tamas@tklengyel.com>,
        Mathieu Tarral <mathieu.tarral@protonmail.com>,
        Samuel =?iso-8859-1?Q?Laur=E9n?= <samuel.lauren@iki.fi>,
        Patrick Colp <patrick.colp@oracle.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Weijiang Yang <weijiang.yang@intel.com>, Zhang@vger.kernel.org,
        Yu C <yu.c.zhang@intel.com>,
        Mihai =?utf-8?B?RG9uyJt1?= <mdontu@bitdefender.com>,
        Mircea =?iso-8859-1?Q?C=EErjaliu?= <mcirjaliu@bitdefender.com>
Subject: Re: [RFC PATCH v6 01/92] kvm: introduce KVMI (VM introspection
 subsystem)
Message-ID: <20190812202030.GB1437@linux.intel.com>
References: <20190809160047.8319-1-alazar@bitdefender.com>
 <20190809160047.8319-2-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190809160047.8319-2-alazar@bitdefender.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 09, 2019 at 06:59:16PM +0300, Adalbert Lazăr wrote:
> diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
> index 72fa955f4a15..f70a6a1b6814 100644
> --- a/arch/x86/kvm/Kconfig
> +++ b/arch/x86/kvm/Kconfig
> @@ -96,6 +96,13 @@ config KVM_MMU_AUDIT
>  	 This option adds a R/W kVM module parameter 'mmu_audit', which allows
>  	 auditing of KVM MMU events at runtime.
>  
> +config KVM_INTROSPECTION
> +	bool "VM Introspection"
> +	depends on KVM && (KVM_INTEL || KVM_AMD)
> +	help
> +	 This option enables functions to control the execution of VM-s, query
> +	 the state of the vCPU-s (GPR-s, MSR-s etc.).

This does a lot more than enable functions, it allows userspace to do all
of these things *while the VM is running*.  Everything above can already
be done by userspace.

The "-s" syntax is difficult to read and unnecessary, e.g. at first I
thought VM-s was referring to a new subsystem or feature introduced by
introspection.  VMs, vCPUs, GPRs, MSRs, etc...

> +
>  # OK, it's a little counter-intuitive to do this, but it puts it neatly under
>  # the virtualization menu.
>  source "drivers/vhost/Kconfig"
> diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
> index 31ecf7a76d5a..312597bd47c7 100644
> --- a/arch/x86/kvm/Makefile
> +++ b/arch/x86/kvm/Makefile
> @@ -7,6 +7,7 @@ KVM := ../../../virt/kvm
>  kvm-y			+= $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o \
>  				$(KVM)/eventfd.o $(KVM)/irqchip.o $(KVM)/vfio.o
>  kvm-$(CONFIG_KVM_ASYNC_PF)	+= $(KVM)/async_pf.o
> +kvm-$(CONFIG_KVM_INTROSPECTION) += $(KVM)/kvmi.o
>  
>  kvm-y			+= x86.o mmu.o emulate.o i8259.o irq.o lapic.o \
>  			   i8254.o ioapic.o irq_comm.o cpuid.o pmu.o mtrr.o \
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index c38cc5eb7e73..582b0187f5a4 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -455,6 +455,10 @@ struct kvm {
>  	struct srcu_struct srcu;
>  	struct srcu_struct irq_srcu;
>  	pid_t userspace_pid;
> +
> +	struct completion kvmi_completed;
> +	refcount_t kvmi_ref;

The refcounting approach seems a bit backwards, and AFAICT is driven by
implementing unhook via a message, which also seems backwards.  I assume
hook and unhook are relatively rare events and not performance critical,
so make those the restricted/slow flows, e.g. force userspace to quiesce
the VM by making unhook() mutually exclusive with every vcpu ioctl() and
maybe anything that takes kvm->lock. 

Then kvmi_ioctl_unhook() can use thread_stop() and kvmi_recv() just needs
to check kthread_should_stop().

That way kvmi doesn't need to be refcounted since it's guaranteed to be
alive if the pointer is non-null.  Eliminating the refcounting will clean
up a lot of the code by eliminating calls to kvmi_{get,put}(), e.g.
wrappers like kvmi_breakpoint_event() just check vcpu->kvmi, or maybe
even get dropped altogether.

> +	void *kvmi;

Why is this a void*?  Just forward declare struct kvmi in kvmi.h.

IMO this should be 'struct kvm_introspection *introspection', similar to
'struct kvm_vcpu_arch arch' and 'struct kvm_vmx'.  Ditto for the vCPU
flavor.  Local variables could be kvmi+vcpui, kvm_i+vcpu_i, or maybe
a more long form if someone can come up with a good abbreviation?

Using 'ikvm' as the local variable name when everything else refers to
introspection as 'kvmi' is especially funky.

>  };
>  
>  #define kvm_err(fmt, ...) \
> diff --git a/include/linux/kvmi.h b/include/linux/kvmi.h
> new file mode 100644
> index 000000000000..e36de3f9f3de
> --- /dev/null
> +++ b/include/linux/kvmi.h
> @@ -0,0 +1,23 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef __KVMI_H__
> +#define __KVMI_H__
> +
> +#define kvmi_is_present() IS_ENABLED(CONFIG_KVM_INTROSPECTION)

Peeking forward a few patches, introspection should have a module param.
The code is also inconsistent in its usage of kvmi_is_present() versus
#ifdef CONFIG_KVM_INTROSPECTION.

And maybe kvm_is_instrospection_enabled() so that the gating function has
a more descriptive name for first-time readers?

> +
> +#ifdef CONFIG_KVM_INTROSPECTION
> +
> +int kvmi_init(void);
> +void kvmi_uninit(void);
> +void kvmi_create_vm(struct kvm *kvm);
> +void kvmi_destroy_vm(struct kvm *kvm);
> +
> +#else
> +
> +static inline int kvmi_init(void) { return 0; }
> +static inline void kvmi_uninit(void) { }
> +static inline void kvmi_create_vm(struct kvm *kvm) { }
> +static inline void kvmi_destroy_vm(struct kvm *kvm) { }
> +
> +#endif /* CONFIG_KVM_INTROSPECTION */
> +
> +#endif
> diff --git a/include/uapi/linux/kvmi.h b/include/uapi/linux/kvmi.h
> new file mode 100644
> index 000000000000..dbf63ad0862f
> --- /dev/null
> +++ b/include/uapi/linux/kvmi.h
> @@ -0,0 +1,68 @@
> +/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
> +#ifndef _UAPI__LINUX_KVMI_H
> +#define _UAPI__LINUX_KVMI_H
> +
> +/*
> + * KVMI structures and definitions
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/types.h>
> +
> +#define KVMI_VERSION 0x00000001
> +
> +enum {
> +	KVMI_EVENT_REPLY           = 0,
> +	KVMI_EVENT                 = 1,
> +
> +	KVMI_FIRST_COMMAND         = 2,
> +
> +	KVMI_GET_VERSION           = 2,
> +	KVMI_CHECK_COMMAND         = 3,
> +	KVMI_CHECK_EVENT           = 4,
> +	KVMI_GET_GUEST_INFO        = 5,
> +	KVMI_GET_VCPU_INFO         = 6,
> +	KVMI_PAUSE_VCPU            = 7,
> +	KVMI_CONTROL_VM_EVENTS     = 8,
> +	KVMI_CONTROL_EVENTS        = 9,
> +	KVMI_CONTROL_CR            = 10,
> +	KVMI_CONTROL_MSR           = 11,
> +	KVMI_CONTROL_VE            = 12,
> +	KVMI_GET_REGISTERS         = 13,
> +	KVMI_SET_REGISTERS         = 14,
> +	KVMI_GET_CPUID             = 15,
> +	KVMI_GET_XSAVE             = 16,
> +	KVMI_READ_PHYSICAL         = 17,
> +	KVMI_WRITE_PHYSICAL        = 18,
> +	KVMI_INJECT_EXCEPTION      = 19,
> +	KVMI_GET_PAGE_ACCESS       = 20,
> +	KVMI_SET_PAGE_ACCESS       = 21,
> +	KVMI_GET_MAP_TOKEN         = 22,
> +	KVMI_GET_MTRR_TYPE         = 23,
> +	KVMI_CONTROL_SPP           = 24,
> +	KVMI_GET_PAGE_WRITE_BITMAP = 25,
> +	KVMI_SET_PAGE_WRITE_BITMAP = 26,
> +	KVMI_CONTROL_CMD_RESPONSE  = 27,

Each command should be introduced along with the patch that adds the
associated functionality.

It'd be helpful to incorporate the scope of the command in the name,
e.g. VM vs. vCPU.

Why are VM and vCPU commands smushed together?

> +
> +	KVMI_NEXT_AVAILABLE_COMMAND,

Why not KVMI_NR_COMMANDS or KVM_NUM_COMMANDS?  At least be consistent
between COMMANDS and EVENTS below.

> +
> +};
> +
> +enum {
> +	KVMI_EVENT_UNHOOK      = 0,
> +	KVMI_EVENT_CR	       = 1,
> +	KVMI_EVENT_MSR	       = 2,
> +	KVMI_EVENT_XSETBV      = 3,
> +	KVMI_EVENT_BREAKPOINT  = 4,
> +	KVMI_EVENT_HYPERCALL   = 5,
> +	KVMI_EVENT_PF	       = 6,
> +	KVMI_EVENT_TRAP	       = 7,
> +	KVMI_EVENT_DESCRIPTOR  = 8,
> +	KVMI_EVENT_CREATE_VCPU = 9,
> +	KVMI_EVENT_PAUSE_VCPU  = 10,
> +	KVMI_EVENT_SINGLESTEP  = 11,
> +
> +	KVMI_NUM_EVENTS
> +};
> +
> +#endif /* _UAPI__LINUX_KVMI_H */
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 585845203db8..90e432d225ab 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -51,6 +51,7 @@
>  #include <linux/slab.h>
>  #include <linux/sort.h>
>  #include <linux/bsearch.h>
> +#include <linux/kvmi.h>
>  
>  #include <asm/processor.h>
>  #include <asm/io.h>
> @@ -680,6 +681,8 @@ static struct kvm *kvm_create_vm(unsigned long type)
>  	if (r)
>  		goto out_err;
>  
> +	kvmi_create_vm(kvm);
> +
>  	spin_lock(&kvm_lock);
>  	list_add(&kvm->vm_list, &vm_list);
>  	spin_unlock(&kvm_lock);
> @@ -725,6 +728,7 @@ static void kvm_destroy_vm(struct kvm *kvm)
>  	int i;
>  	struct mm_struct *mm = kvm->mm;
>  
> +	kvmi_destroy_vm(kvm);
>  	kvm_uevent_notify_change(KVM_EVENT_DESTROY_VM, kvm);
>  	kvm_destroy_vm_debugfs(kvm);
>  	kvm_arch_sync_events(kvm);
> @@ -1556,7 +1560,7 @@ static int hva_to_pfn_remapped(struct vm_area_struct *vma,
>  	 * Whoever called remap_pfn_range is also going to call e.g.
>  	 * unmap_mapping_range before the underlying pages are freed,
>  	 * causing a call to our MMU notifier.
> -	 */ 
> +	 */

Spurious whitespace change.

>  	kvm_get_pfn(pfn);
>  
>  	*p_pfn = pfn;
> @@ -4204,6 +4208,9 @@ int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
>  	r = kvm_vfio_ops_init();
>  	WARN_ON(r);
>  
> +	r = kvmi_init();
> +	WARN_ON(r);

Leftover development/debugging crud.

> +
>  	return 0;
>  
>  out_unreg:
> @@ -4229,6 +4236,7 @@ EXPORT_SYMBOL_GPL(kvm_init);
>  
>  void kvm_exit(void)
>  {
> +	kvmi_uninit();
>  	debugfs_remove_recursive(kvm_debugfs_dir);
>  	misc_deregister(&kvm_dev);
>  	kmem_cache_destroy(kvm_vcpu_cache);
> diff --git a/virt/kvm/kvmi.c b/virt/kvm/kvmi.c
> new file mode 100644
> index 000000000000..20638743bd03
> --- /dev/null
> +++ b/virt/kvm/kvmi.c
> @@ -0,0 +1,64 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * KVM introspection
> + *
> + * Copyright (C) 2017-2019 Bitdefender S.R.L.
> + *
> + */
> +#include <uapi/linux/kvmi.h>
> +#include "kvmi_int.h"
> +
> +int kvmi_init(void)
> +{
> +	return 0;
> +}
> +
> +void kvmi_uninit(void)
> +{
> +}
> +
> +struct kvmi * __must_check kvmi_get(struct kvm *kvm)
> +{
> +	if (refcount_inc_not_zero(&kvm->kvmi_ref))
> +		return kvm->kvmi;
> +
> +	return NULL;
> +}
> +
> +static void kvmi_destroy(struct kvm *kvm)
> +{
> +}
> +
> +static void kvmi_release(struct kvm *kvm)
> +{
> +	kvmi_destroy(kvm);
> +
> +	complete(&kvm->kvmi_completed);
> +}
> +
> +/* This function may be called from atomic context and must not sleep */
> +void kvmi_put(struct kvm *kvm)
> +{
> +	if (refcount_dec_and_test(&kvm->kvmi_ref))
> +		kvmi_release(kvm);
> +}
> +
> +void kvmi_create_vm(struct kvm *kvm)
> +{
> +	init_completion(&kvm->kvmi_completed);
> +	complete(&kvm->kvmi_completed);

Pretty sure you don't want to be calling complete() here.

> +}
> +
> +void kvmi_destroy_vm(struct kvm *kvm)
> +{
> +	struct kvmi *ikvm;
> +
> +	ikvm = kvmi_get(kvm);
> +	if (!ikvm)
> +		return;
> +
> +	kvmi_put(kvm);
> +
> +	/* wait for introspection resources to be released */
> +	wait_for_completion_killable(&kvm->kvmi_completed);
> +}
> diff --git a/virt/kvm/kvmi_int.h b/virt/kvm/kvmi_int.h
> new file mode 100644
> index 000000000000..ac23ad6fc4df
> --- /dev/null
> +++ b/virt/kvm/kvmi_int.h
> @@ -0,0 +1,12 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef __KVMI_INT_H__
> +#define __KVMI_INT_H__
> +
> +#include <linux/kvm_host.h>
> +
> +#define IKVM(kvm) ((struct kvmi *)((kvm)->kvmi))
> +
> +struct kvmi {
> +};
> +
> +#endif
