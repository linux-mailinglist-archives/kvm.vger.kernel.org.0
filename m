Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 292931CFBBB
	for <lists+kvm@lfdr.de>; Tue, 12 May 2020 19:14:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727999AbgELROr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 May 2020 13:14:47 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:31660 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725938AbgELROr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 May 2020 13:14:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589303684;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/0pgjMZm6lULlzrvtypsxGc5pMPdZMVaKayFWhHAubI=;
        b=W7ltpBbIV+inxrhMLGyUDEiqrC2jqp61HHuHEQ1YYEys046UkSLUrCByPWnGgAMhytUhU8
        2c3Z96b2tXwKHIDtN4SZ6fhzmPbub/k69CYsIpc22uYtaTSjwFYKB4IKQrpoEFllyNwFVv
        fqJgvKL0X/wvaebzxT1nyyOXWzKFUR4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-36-JFnCUloqNJ-Xa7PtiQlKOw-1; Tue, 12 May 2020 13:14:42 -0400
X-MC-Unique: JFnCUloqNJ-Xa7PtiQlKOw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 823D2835B4A;
        Tue, 12 May 2020 17:14:41 +0000 (UTC)
Received: from w520.home (ovpn-113-111.phx2.redhat.com [10.3.113.111])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0CEE87D8F5;
        Tue, 12 May 2020 17:14:41 +0000 (UTC)
Date:   Tue, 12 May 2020 11:14:40 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Micah Morton <mortonm@chromium.org>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com
Subject: Re: [RFC PATCH] KVM: Add module for IRQ forwarding
Message-ID: <20200512111440.15caaca2@w520.home>
In-Reply-To: <20200511220046.120206-1-mortonm@chromium.org>
References: <20200511220046.120206-1-mortonm@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 11 May 2020 15:00:46 -0700
Micah Morton <mortonm@chromium.org> wrote:

> Relevant KVM maintainers:
> I'm looking for comments on the feasibility of adding a module like
> this in KVM for solving the problem described below:
> 
> 
> Currently, KVM/VFIO offers no way to forward interrupts into a guest
> from devices that are implicitly assigned to the VM by nature of being
> downstream from a bus controller PCI device (e.g. I2C controller) that
> gets explicitly assigned to the VM. This module allows for forwarding
> arbitrary interrupts on the host system into the guest, supporting this
> platform-device-behind-PCI-controller scenario.
> 
> This code is mostly inspired/taken from the equivalent code in VFIO. It
> is not a finished product, but I wanted to check in with the KVM mailing
> list in order to assess feasibility before doing any more work on it.
> 
> One obvious question would be why not just add this support to VFIO?
> See https://www.redhat.com/archives/vfio-users/2019-December/msg00008.html
> and the encompassing thread for a discussion as to why this probably
> isn't the way to go.
> 
> Forwarding arbitrary IRQs to a guest VM does require the VMM to "tell"
> the guest about the interrupt (e.g. through ACPI), since such info is
> not discoverable by the guest like it is for PCI devices. So separate
> logic is needed in the VMM to set this up -- this isn't something done
> by the module shared here.
> 
> Forwarding platform IRQs can have a big payoff for getting platform
> devices to work in a guest, especially when the platform devices sit
> behind a PCI bus controller that can be easily passed through to the
> guest. On an Intel device I'm using for development, this module allowed
> me to get multiple devices (keyboard, touchscreen, touchpad) working in
> a VM guest on the device that wouldn't have worked otherwise -- straight
> out of the box after passing through the PCI bus controller with
> vfio-pci (plus constructing some AML for the guest in the VMM).

But why not assign the individual platform devices via vfio-platform
rather than assign the i2c controller via vfio-pci and then assembling
the interrupts from those sub-devices with this ad-hoc interface?  An
emulated i2c controller in the guest could provide the same discovery
mechanism as is available in the host.

A few issues I see here:

 - Please don't squat on vfio ioctls (ie. IRQ_FORWARD_BASE/TYPE)

 - This provides only a single /dev/irq-forward device file with default
   user/group/other r/w permissions.  It's not secured by default and
   there's no way to restrict a given IRQ to a given user.  Access to
   this file allows the user to be signaled for any host IRQ the user
   chooses, and in the event of level IRQs, register an exclusive
   interrupt handler, blocking host drivers from legitimately
   registering shared IRQ handlers.  This is fatally poor security, IMO.

 - There's no lock protection for concurrent access to level and edge
   lists.

If we had an interface where arbitrary interrupts are exposed to
userspace, I think at a minimum we'd need a device file per IRQ so that
we can give access to a specific IRQ to a specific user.  However that
puts quite a burden on VM orchestration tools to be able to determine
this hidden IRQ dependency.  Thanks,

Alex

> NOTE: This code works for forwarding IRQs to a guest (with the VMM
> calling the appropriate ioctls with the appropriate args), although it's
> missing some code and testing related to shutdown/irq disable/reboot.
> Works well enough to demonstrate the feasibility though.
> 
> Developed on top of v5.7-rc4.
> 
> Signed-off-by: Micah Morton <mortonm@chromium.org>
> ---
>  include/linux/irqfd.h           |  22 +++
>  include/linux/miscdevice.h      |   1 +
>  include/uapi/linux/irqforward.h |  55 ++++++
>  virt/lib/Kconfig                |   3 +
>  virt/lib/Makefile               |   1 +
>  virt/lib/irqfd.c                | 146 ++++++++++++++++
>  virt/lib/irqforward.c           | 289 ++++++++++++++++++++++++++++++++
>  7 files changed, 517 insertions(+)
>  create mode 100644 include/linux/irqfd.h
>  create mode 100644 include/uapi/linux/irqforward.h
>  create mode 100644 virt/lib/irqfd.c
>  create mode 100644 virt/lib/irqforward.c
> 
> diff --git a/include/linux/irqfd.h b/include/linux/irqfd.h
> new file mode 100644
> index 000000000000..79d2a8c779e1
> --- /dev/null
> +++ b/include/linux/irqfd.h
> @@ -0,0 +1,22 @@
> +/*
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +#ifndef IRQFD_H
> +#define IRQFD_H
> +
> +#include <linux/poll.h>
> +
> +struct irq_forward_irqfd {
> +	struct eventfd_ctx	*eventfd;
> +	int			(*handler)(void *, void *);
> +	void			*data;
> +	wait_queue_entry_t	wait;
> +	poll_table		pt;
> +	struct work_struct	shutdown;
> +	struct irq_forward_irqfd		**pirqfd;
> +};
> +
> +int irq_forward_irqfd_enable(int (*handler)(void *, void *), void *data, struct irq_forward_irqfd **pirqfd, int fd);
> +#endif /* IRQFD_H */
> diff --git a/include/linux/miscdevice.h b/include/linux/miscdevice.h
> index c7a93002a3c1..f17b37fb8264 100644
> --- a/include/linux/miscdevice.h
> +++ b/include/linux/miscdevice.h
> @@ -50,6 +50,7 @@
>  #define D7S_MINOR		193
>  #define VFIO_MINOR		196
>  #define PXA3XX_GCU_MINOR	197
> +#define IRQ_FORWARD_MINOR       198
>  #define TUN_MINOR		200
>  #define CUSE_MINOR		203
>  #define MWAVE_MINOR		219	/* ACP/Mwave Modem */
> diff --git a/include/uapi/linux/irqforward.h b/include/uapi/linux/irqforward.h
> new file mode 100644
> index 000000000000..a77aaa4841b5
> --- /dev/null
> +++ b/include/uapi/linux/irqforward.h
> @@ -0,0 +1,55 @@
> +/*
> + * API definition for IRQ Forwarding to KVM guests
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +#ifndef _UAPIIRQFORWARD_H
> +#define _UAPIIRQFORWARD_H
> +
> +#include <linux/ioctl.h>
> +
> +#define IRQ_FORWARD_API_VERSION	0
> +
> +#define IRQ_FORWARD_TYPE       (';')
> +#define IRQ_FORWARD_BASE       100
> +
> +struct irq_forward_edge_triggered {
> +	struct eventfd_ctx *trigger;
> +	uint32_t irq_num;
> +	struct list_head list;
> +};
> +
> +struct irq_forward_level_triggered {
> +	struct eventfd_ctx *trigger;
> +	struct irq_forward_irqfd *unmask;
> +	bool is_masked;
> +	spinlock_t spinlock;
> +	uint32_t irq_num;
> +	struct list_head list;
> +};
> +
> +/**
> + *
> + * Set masking and unmasking of interrupts.  Caller provides
> + * struct irq_forward_set with all fields set.
> + *
> + */
> +struct irq_forward_set {
> +	__u32	argsz;
> +	__u32	action_flags;
> +#define IRQ_FORWARD_SET_LEVEL_TRIGGER_EVENTFD	(1 << 0)
> +#define IRQ_FORWARD_SET_LEVEL_UNMASK_EVENTFD	(1 << 1)
> +#define IRQ_FORWARD_SET_EDGE_TRIGGER		(1 << 2)
> +	__u32	irq_number_host;
> +	__u32	count;
> +	__u8	eventfd[];
> +};
> +
> +/* ---- IOCTLs for IRQ Forwarding fd (/dev/irq-forward) ---- */
> +#define IRQ_FORWARD_SET _IO(IRQ_FORWARD_TYPE, IRQ_FORWARD_BASE + 0)
> +
> +/* *********************************************************************** */
> +
> +#endif /* _UAPIIRQFORWARD_H */
> diff --git a/virt/lib/Kconfig b/virt/lib/Kconfig
> index 2d9523b7155e..847b06a95c14 100644
> --- a/virt/lib/Kconfig
> +++ b/virt/lib/Kconfig
> @@ -1,3 +1,6 @@
>  # SPDX-License-Identifier: GPL-2.0-only
>  config IRQ_BYPASS_MANAGER
>  	tristate
> +
> +config IRQ_FORWARD
> +	tristate "Enable forwarding arbitrary IRQs to guest in KVM"
> diff --git a/virt/lib/Makefile b/virt/lib/Makefile
> index bd7f9a78bb6b..bd46aad8d426 100644
> --- a/virt/lib/Makefile
> +++ b/virt/lib/Makefile
> @@ -1,2 +1,3 @@
>  # SPDX-License-Identifier: GPL-2.0-only
>  obj-$(CONFIG_IRQ_BYPASS_MANAGER) += irqbypass.o
> +obj-$(CONFIG_IRQ_FORWARD) += irqforward.o irqfd.o
> diff --git a/virt/lib/irqfd.c b/virt/lib/irqfd.c
> new file mode 100644
> index 000000000000..4eb47a1c1e6f
> --- /dev/null
> +++ b/virt/lib/irqfd.c
> @@ -0,0 +1,146 @@
> +#include <linux/file.h>
> +#include <linux/vfio.h>
> +#include <linux/eventfd.h>
> +#include <linux/slab.h>
> +#include <uapi/linux/irqforward.h>
> +#include <linux/irqfd.h>
> +
> +static struct workqueue_struct *irqfd_cleanup_wq;
> +static DEFINE_SPINLOCK(irqfd_lock);
> +
> +static void irqfd_deactivate(struct irq_forward_irqfd *irqfd)
> +{
> +        queue_work(irqfd_cleanup_wq, &irqfd->shutdown);
> +}
> +
> +static int irqfd_wakeup(wait_queue_entry_t *wait, unsigned mode, int sync, void *key)
> +{
> +        struct irq_forward_irqfd *irqfd = container_of(wait, struct irq_forward_irqfd, wait);
> +        __poll_t flags = key_to_poll(key);
> +
> +        if (flags & EPOLLIN) {
> +                /* An event has been signaled, call function */
> +                if (!irqfd->handler ||
> +                     irqfd->handler(NULL, irqfd->data))
> +                        printk(KERN_EMERG "handler failed\n");
> +        }
> +
> +        if (flags & EPOLLHUP) {
> +                unsigned long flags;
> +                spin_lock_irqsave(&irqfd_lock, flags);
> +
> +                /*
> +                 * The eventfd is closing, if the irqfd has not yet been
> +                 * queued for release, as determined by testing whether the
> +                 * irqfd pointer to it is still valid, queue it now.  As
> +                 * with kvm irqfds, we know we won't race against the irqfd
> +                 * going away because we hold the lock to get here.
> +                 */
> +                if (*(irqfd->pirqfd) == irqfd) {
> +                        *(irqfd->pirqfd) = NULL;
> +                        irqfd_deactivate(irqfd);
> +                }
> +
> +                spin_unlock_irqrestore(&irqfd_lock, flags);
> +        }
> +
> +        return 0;
> +}
> +
> +
> +static void irqfd_ptable_queue_proc(struct file *file,
> +                                     wait_queue_head_t *wqh, poll_table *pt)
> +{
> +        struct irq_forward_irqfd *irqfd = container_of(pt, struct irq_forward_irqfd, pt);
> +        add_wait_queue(wqh, &irqfd->wait);
> +}
> +
> +static void irqfd_shutdown(struct work_struct *work)
> +{
> +        struct irq_forward_irqfd *irqfd = container_of(work, struct irq_forward_irqfd, shutdown);
> +        u64 cnt;
> +
> +        eventfd_ctx_remove_wait_queue(irqfd->eventfd, &irqfd->wait, &cnt);
> +        eventfd_ctx_put(irqfd->eventfd);
> +
> +        kfree(irqfd);
> +}
> +
> +int irq_forward_irqfd_enable(int (*handler)(void *, void *), void *data, struct irq_forward_irqfd **pirqfd, int fd)
> +{
> +        struct fd irqfd;
> +        struct eventfd_ctx *ctx;
> +        struct irq_forward_irqfd *irqfd_struct;
> +        int ret = 0;
> +        unsigned int events;
> +
> +        irqfd_struct = kzalloc(sizeof(*irqfd_struct), GFP_KERNEL);
> +        if (!irqfd_struct)
> +                return -ENOMEM;
> +
> +        irqfd_struct->pirqfd = pirqfd;
> +        irqfd_struct->handler = handler;
> +        irqfd_struct->data = data;
> +
> +        // shutdown causes crash
> +        INIT_WORK(&irqfd_struct->shutdown, irqfd_shutdown);
> +
> +        irqfd = fdget(fd);
> +        if (!irqfd.file) {
> +                ret = -EBADF;
> +                goto err_fd;
> +        }
> +
> +        ctx = eventfd_ctx_fileget(irqfd.file);
> +        if (IS_ERR(ctx)) {
> +                ret = PTR_ERR(ctx);
> +                goto err_ctx;
> +        }
> +
> +        irqfd_struct->eventfd = ctx;
> +
> +         // irqfds can be released by closing the eventfd or directly
> +         // through ioctl.  These are both done through a workqueue, so
> +         // we update the pointer to the irqfd under lock to avoid
> +         // pushing multiple jobs to release the same irqfd.
> +        spin_lock_irq(&irqfd_lock);
> +
> +        if (*pirqfd) {
> +                printk(KERN_EMERG "pirqfd should be NULL. BUG!\n");
> +                spin_unlock_irq(&irqfd_lock);
> +                ret = -EBUSY;
> +                goto err_busy;
> +        }
> +        *pirqfd = irqfd_struct;
> +
> +        spin_unlock_irq(&irqfd_lock);
> +
> +         // Install our own custom wake-up handling so we are notified via
> +         // a callback whenever someone signals the underlying eventfd.
> +        init_waitqueue_func_entry(&irqfd_struct->wait, irqfd_wakeup);
> +        init_poll_funcptr(&irqfd_struct->pt, irqfd_ptable_queue_proc);
> +
> +        events = irqfd.file->f_op->poll(irqfd.file, &irqfd_struct->pt);
> +
> +         // Check if there was an event already pending on the eventfd
> +         // before we registered and trigger it as if we didn't miss it.
> +        if (events & POLLIN) {
> +                if (!handler || handler(NULL, data))
> +                        printk(KERN_EMERG "handler failed\n");
> +        }
> +
> +         // Do not drop the file until the irqfd is fully initialized,
> +         // otherwise we might race against the POLLHUP.
> +        fdput(irqfd);
> +
> +        return 0;
> +err_busy:
> +        eventfd_ctx_put(ctx);
> +err_ctx:
> +        fdput(irqfd);
> +err_fd:
> +        kfree(irqfd_struct);
> +
> +        return ret;
> +}
> +EXPORT_SYMBOL_GPL(irq_forward_irqfd_enable);
> diff --git a/virt/lib/irqforward.c b/virt/lib/irqforward.c
> new file mode 100644
> index 000000000000..1d5030d347aa
> --- /dev/null
> +++ b/virt/lib/irqforward.c
> @@ -0,0 +1,289 @@
> +#include <linux/cdev.h>
> +#include <linux/compat.h>
> +#include <linux/file.h>
> +#include <linux/fs.h>
> +#include <linux/miscdevice.h>
> +#include <linux/module.h>
> +#include <linux/pci.h>
> +#include <linux/sched.h>
> +//#include <linux/vfio.h>
> +#include <linux/eventfd.h>
> +#include <linux/delay.h>
> +#include <uapi/linux/irqforward.h>
> +#include <linux/irqfd.h>
> +
> +#define VERSION	"0.1"
> +#define AUTHOR	"Micah Morton <mortonm@chromium.org>"
> +#define DESC	"IRQ Forwarding"
> +
> +MODULE_VERSION(VERSION);
> +MODULE_LICENSE("GPL v2");
> +MODULE_AUTHOR(AUTHOR);
> +MODULE_DESCRIPTION(DESC);
> +MODULE_ALIAS_MISCDEV(IRQ_FORWARD_MINOR);
> +MODULE_ALIAS("devname:irq-forward");
> +
> +static LIST_HEAD(level_triggered_irqs);
> +static LIST_HEAD(edge_triggered_irqs);
> +
> +
> +static int irq_forward_unmask_handler_level(void *opaque, void *level)
> +{
> +	unsigned long flags;
> +	struct irq_forward_level_triggered *l = (struct irq_forward_level_triggered *) level;
> +
> +	spin_lock_irqsave(&(l->spinlock), flags);
> +	if (l->is_masked) {
> +		enable_irq(l->irq_num);
> +		l->is_masked = false;
> +	}
> +	spin_unlock_irqrestore(&(l->spinlock), flags);
> +	return 0;
> +}
> +
> +
> +static irqreturn_t irq_forward_handler_level(int irq, void *level)
> +{
> +	unsigned long flags;
> +	int ret = IRQ_NONE;
> +	struct irq_forward_level_triggered *l = (struct irq_forward_level_triggered *) level;
> +	spin_lock_irqsave(&(l->spinlock), flags);
> +
> +	disable_irq_nosync(irq);
> +	l->is_masked = true;
> +	ret = IRQ_HANDLED;
> +
> +	spin_unlock_irqrestore(&(l->spinlock), flags);
> +
> +	if (ret == IRQ_HANDLED)
> +	        eventfd_signal(l->trigger, 1);
> +
> +	return ret;
> +}
> +
> +static irqreturn_t irq_forward_handler_edge(int irq, void *edge)
> +{
> +        eventfd_signal(((struct irq_forward_edge_triggered*)edge)->trigger, 1);
> +
> +        return IRQ_HANDLED;
> +}
> +
> +static int irq_forward_set_level_trigger(void *data, uint32_t irq_number_host, struct irq_forward_level_triggered *level)
> +{
> +	int32_t fd;
> +	struct eventfd_ctx *trigger;
> +	int ret;
> +
> +	fd = *(int32_t *)data;
> +
> +	if (fd < 0) /* Disable only */
> +	        return 0;
> +
> +	trigger = eventfd_ctx_fdget(fd);
> +	if (IS_ERR(trigger)) {
> +	        return PTR_ERR(trigger);
> +	}
> +
> +	level->trigger = trigger;
> +	spin_lock_init(&(level->spinlock));
> +
> +	ret = request_irq(irq_number_host, irq_forward_handler_level, 0, "level-triggered-irq", level);
> +	if (ret) {
> +	        level->trigger = NULL;
> +	        eventfd_ctx_put(trigger);
> +	        return ret;
> +	}
> +
> +	return 0;
> +
> +}
> +
> +static int irq_forward_set_level_unmask(void *data, struct irq_forward_level_triggered *level)
> +{
> +	int32_t fd;
> +	fd = *(int32_t *)data;
> +
> +	if (fd >= 0)
> +	        return irq_forward_irqfd_enable(irq_forward_unmask_handler_level, level, &(level->unmask), fd);
> +	return -1;
> +}
> +
> +static int irq_forward_set_edge_trigger(void *data, uint32_t irq_number_host, struct irq_forward_edge_triggered *edge)
> +{
> +	struct eventfd_ctx *trigger;
> +    int ret;
> +	int32_t fd;
> +	fd = *(int32_t *)data;
> +
> +	if (fd < 0) /* Disable only */
> +                return 0;
> +
> +        trigger = eventfd_ctx_fdget(fd);
> +        if (IS_ERR(trigger)) {
> +                return PTR_ERR(trigger);
> +        }
> +
> +        edge->trigger = trigger;
> +
> +        ret = request_irq(irq_number_host, irq_forward_handler_edge, IRQF_SHARED, "edge-triggered-irq", edge);
> +        if (ret) {
> +                edge->trigger = NULL;
> +                eventfd_ctx_put(trigger);
> +                return ret;
> +        }
> +
> +        return 0;
> +}
> +
> +
> +int set_irqs_ioctl_level_trigger(uint32_t irq_number_host, void *data) {
> +
> +        struct irq_forward_level_triggered *level_irq = kzalloc(sizeof(struct irq_forward_level_triggered), GFP_KERNEL);
> +        if (!level_irq)
> +                return -ENOMEM;
> +        level_irq->trigger = NULL;
> +        level_irq->irq_num = irq_number_host;
> +        level_irq->unmask = NULL;
> +        level_irq->is_masked = true;
> +        list_add(&(level_irq->list), &level_triggered_irqs);
> +
> +        return irq_forward_set_level_trigger(data, irq_number_host, level_irq);
> +}
> +
> +int set_irqs_ioctl_level_unmask(uint32_t irq_number_host, void *data) {
> +
> +        struct list_head* position = NULL;
> +        struct irq_forward_level_triggered *level_irq = NULL;
> +        // We must already have a trigger for the IRQ before we add an unmask
> +        list_for_each(position, &level_triggered_irqs) {
> +                level_irq = list_entry(position, struct irq_forward_level_triggered, list);
> +                if (level_irq->irq_num == irq_number_host)
> +                        return irq_forward_set_level_unmask(data, level_irq);
> +        }
> +
> +        return -1;
> +}
> +
> +int set_irqs_ioctl_edge_trigger(uint32_t irq_number_host, void *data) {
> +
> +        struct irq_forward_edge_triggered *edge_irq = kzalloc(sizeof(struct irq_forward_edge_triggered), GFP_KERNEL);
> +        if (!edge_irq)
> +                return -ENOMEM;
> +        edge_irq->trigger = NULL;
> +        edge_irq->irq_num = irq_number_host;
> +        list_add(&(edge_irq->list), &edge_triggered_irqs);
> +
> +        return irq_forward_set_edge_trigger(data, irq_number_host, edge_irq);
> +}
> +
> +int irq_forward_ioctl(void *device_data, unsigned long arg)
> +{
> +	u8 *data = NULL;
> +	unsigned long minsz;
> +	struct irq_forward_set hdr;
> +
> +
> +	minsz = offsetofend(struct irq_forward_set, count);
> +
> +	if (copy_from_user(&hdr, (void __user *)arg, minsz))
> +                return -EFAULT;
> +
> +	data = memdup_user((void __user *)(arg + minsz), sizeof(int32_t));
> +	if (IS_ERR(data))
> +	        return PTR_ERR(data);
> +
> +    switch (hdr.action_flags)
> +    {
> +        case IRQ_FORWARD_SET_LEVEL_TRIGGER_EVENTFD:
> +            return set_irqs_ioctl_level_trigger(hdr.irq_number_host, data);
> +        case IRQ_FORWARD_SET_LEVEL_UNMASK_EVENTFD:
> +            return set_irqs_ioctl_level_unmask(hdr.irq_number_host, data);
> +        case IRQ_FORWARD_SET_EDGE_TRIGGER:
> +            return set_irqs_ioctl_edge_trigger(hdr.irq_number_host, data);
> +        default:
> +            return -EINVAL;
> +    }
> +
> +	kfree(data);
> +	return 0;
> +}
> +
> +/**
> + * IRQ Forwarding fd, /dev/irq-forward
> + */
> +static long irq_forward_fops_unl_ioctl(struct file *filep,
> +				unsigned int cmd, unsigned long arg)
> +{
> +	long ret = -EINVAL;
> +
> +	switch (cmd) {
> +	case IRQ_FORWARD_SET:
> +		ret = (long) irq_forward_ioctl(filep, arg);
> +		break;
> +	default:
> +		ret = -EINVAL;
> +	}
> +
> +	return ret;
> +}
> +
> +#ifdef CONFIG_COMPAT
> +static long irq_forward_fops_compat_ioctl(struct file *filep,
> +				   unsigned int cmd, unsigned long arg)
> +{
> +	arg = (unsigned long)compat_ptr(arg);
> +	return irq_forward_fops_unl_ioctl(filep, cmd, arg);
> +}
> +#endif	/* CONFIG_COMPAT */
> +
> +static int irq_forward_fops_open(struct inode *inode, struct file *filep)
> +{
> +	return 0;
> +}
> +
> +static int irq_forward_fops_release(struct inode *inode, struct file *filep)
> +{
> +	return 0;
> +}
> +
> +static const struct file_operations irq_forward_fops = {
> +	.owner		= THIS_MODULE,
> +	.open		= irq_forward_fops_open,
> +	.release	= irq_forward_fops_release,
> +	.unlocked_ioctl	= irq_forward_fops_unl_ioctl,
> +#ifdef CONFIG_COMPAT
> +	.compat_ioctl	= irq_forward_fops_compat_ioctl,
> +#endif
> +};
> +
> +static struct miscdevice irq_forward_dev = {
> +	.minor = IRQ_FORWARD_MINOR,
> +	.name = "irq-forward",
> +	.fops = &irq_forward_fops,
> +	.nodename = "irq-forward",
> +	.mode = S_IRUGO | S_IWUGO,
> +};
> +
> +static int __init irq_forward_init(void)
> +{
> +	int ret;
> +
> +	ret = misc_register(&irq_forward_dev);
> +	if (ret) {
> +		pr_err("irq-forward: misc device register failed\n");
> +		return ret;
> +	}
> +
> +	pr_info(DESC " version: " VERSION "\n");
> +
> +	return 0;
> +}
> +
> +// TODO: cleanup/free/disconnect stuff
> +static void __exit irq_forward_cleanup(void)
> +{
> +	misc_deregister(&irq_forward_dev);
> +}
> +
> +module_init(irq_forward_init);
> +module_exit(irq_forward_cleanup);

