Return-Path: <kvm+bounces-13895-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A70F589C58D
	for <lists+kvm@lfdr.de>; Mon,  8 Apr 2024 15:58:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CB4001C2155A
	for <lists+kvm@lfdr.de>; Mon,  8 Apr 2024 13:58:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84C777E116;
	Mon,  8 Apr 2024 13:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bitbyteword.org header.i=@bitbyteword.org header.b="bxmlN9n5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f172.google.com (mail-yb1-f172.google.com [209.85.219.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A049C7C092
	for <kvm@vger.kernel.org>; Mon,  8 Apr 2024 13:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584651; cv=none; b=Q+6iHQSEt2SdnNAEhRUYttOZD3WkRhHGn39YG38u2CSSeywCML1hNRNwJ22aJ0YMcOW4bQKBCOJT6T+i3gsfQo7Yo+lmIc8BJ3WDzRzMePfsI7rpAU9wZRNtZvdQVWgF3rHkOkrlxaeFQNgMjI60PsAnHzNTpzd/ss6hkpmequY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584651; c=relaxed/simple;
	bh=fcm0rR+VFa6I5t56wMuVdz4ik9Y9MFtr+ZTAeE7d6KM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PbMDdve3wZtL3KgdJ3mY7Lv8f3hOX93gaeaQZBAsE9E/6ziktQUP4kGahLnKpz+he3+skoP9pbibvd2zdXmp0dX4hYsmc4nqddUMfghLRWieu7eGGgQzp1lR6hb1k3A3DXhGludPpcIYn6VpNCDExIAPtYaeZ7U8hGqiMU1cbro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bitbyteword.org; spf=pass smtp.mailfrom=bitbyteword.org; dkim=pass (2048-bit key) header.d=bitbyteword.org header.i=@bitbyteword.org header.b=bxmlN9n5; arc=none smtp.client-ip=209.85.219.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bitbyteword.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bitbyteword.org
Received: by mail-yb1-f172.google.com with SMTP id 3f1490d57ef6-dc6d8bd618eso4191002276.3
        for <kvm@vger.kernel.org>; Mon, 08 Apr 2024 06:57:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bitbyteword.org; s=google; t=1712584647; x=1713189447; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4PKpGR+hikgIIApkYBWwcp7qOeAc0n1wCBYJDkNV8qk=;
        b=bxmlN9n5Wv2XAuBEboql4/AjftDvbrt1t6ewGcpnLUJmrvYQBVZOiaYHPTxow8Zhru
         m+YNj1mkxSQNFrLV8uIPyKvCuiErAuTaGJB2Gfdx+yWshNUf6ZdEL6GG8li9iHTo/z51
         630r/OSh3skJTzYL54MNVYgT7uymakKjEwhE2PM5HeT59j104qKckuJ8qBuDfxBJ/vwR
         9uNliDKHzesrLD0RB3Zc3Jz9FMUr4Fc27qaprHh6AhY3nafwRRbXBgBZCss3sfE6KwlA
         oHHe2cQ1+G3kXv6s6KIdTMJO9ZOriYXCCJ49rxUi24NyX06RrMwcDCii461Xs0GNDw4T
         Jz8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712584647; x=1713189447;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4PKpGR+hikgIIApkYBWwcp7qOeAc0n1wCBYJDkNV8qk=;
        b=F6vkWxrp1WZD3NPAY7eny+Y6A/NmF4bGvR7dVNX2qT7LEgUia0PwLdaNwShqXlPFgh
         xOMqIfxtyl56oqmEMMZAV2uE3yrutQ9EDZ09lHvaAUGbjpW6M5l233V6Hf0Eyc4GF3sN
         sjiSWhk+5AFn7HwZATAhXQ9kdW2IxuPqZqYdXMG+W0vdFypDERDa9ALqqQFOO24BiqFo
         zQt7mPvIRbT87fwTDNuDyVvXTCgbtxh2a+9e9oF0rFievgNKg24HQhrJyfMTJG23gACk
         YqRfYIHBBjdLLWxEUk0SRzppykGLivG3Y8INdNZpGGXingzMxdTrpWHIGtpc8q61VPTT
         KLHQ==
X-Forwarded-Encrypted: i=1; AJvYcCVKdsk1ZwQr6I1G3IAanH9eumxqB/kiHlgzmc/UbNc7/V2N88hrTQF0jhOWDIf0jcuv57BwO/oPPHm+YxJo5VLctvJ7
X-Gm-Message-State: AOJu0YwWIZx2qcbhhxb/GoRucjE0nbqntswVKktEZqnFJUZLLnhJAY4n
	bURX3WvjKpP0o9zh2uGRNro4hiVjEKm4pCeceX8or8Cm1l0mFGePKBwfDeQr2bNlBhrDl6Utuc8
	Md9xrdr/UHvF3P3rjF8qbk694V9ZKT8WIGwbMCA==
X-Google-Smtp-Source: AGHT+IH/15TMOu4uAVgWlsFYin9REzLPhRddHH40hBtCDR3UkZW2jsspsAZmCdPO2KE4hZGNfvZbV1ucoL6wCUKbOL8=
X-Received: by 2002:a05:6902:f82:b0:dd0:972b:d218 with SMTP id
 ft2-20020a0569020f8200b00dd0972bd218mr7993576ybb.41.1712584647554; Mon, 08
 Apr 2024 06:57:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240403140116.3002809-1-vineeth@bitbyteword.org> <20240403140116.3002809-2-vineeth@bitbyteword.org>
In-Reply-To: <20240403140116.3002809-2-vineeth@bitbyteword.org>
From: Vineeth Remanan Pillai <vineeth@bitbyteword.org>
Date: Mon, 8 Apr 2024 09:57:17 -0400
Message-ID: <CAO7JXPh1-iqwjEnSDDJE5OophbeFS5dghOuQhUesLVJoKX_wAw@mail.gmail.com>
Subject: Re: [RFC PATCH v2 1/5] pvsched: paravirt scheduling framework
To: Ben Segall <bsegall@google.com>, Borislav Petkov <bp@alien8.de>, 
	Daniel Bristot de Oliveira <bristot@redhat.com>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Dietmar Eggemann <dietmar.eggemann@arm.com>, "H . Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, 
	Juri Lelli <juri.lelli@redhat.com>, Mel Gorman <mgorman@suse.de>, 
	Paolo Bonzini <pbonzini@redhat.com>, Andy Lutomirski <luto@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Sean Christopherson <seanjc@google.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Valentin Schneider <vschneid@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Vitaly Kuznetsov <vkuznets@redhat.com>, 
	Wanpeng Li <wanpengli@tencent.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Joel Fernandes <joel@joelfernandes.org>, 
	Suleiman Souhlal <suleiman@google.com>, Masami Hiramatsu <mhiramat@kernel.org>, himadrics@inria.fr, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org, 
	Tejun Heo <tj@kernel.org>, Josh Don <joshdon@google.com>, Barret Rhoden <brho@google.com>, 
	David Vernet <dvernet@meta.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Adding sched_ext folks

On Wed, Apr 3, 2024 at 10:01=E2=80=AFAM Vineeth Pillai (Google)
<vineeth@bitbyteword.org> wrote:
>
> Implement a paravirt scheduling framework for linux kernel.
>
> The framework allows for pvsched driver to register to the kernel and
> receive callbacks from hypervisor(eg: kvm) for interested vcpu events
> like VMENTER, VMEXIT etc.
>
> The framework also allows hypervisor to select a pvsched driver (from
> the available list of registered drivers) for each guest.
>
> Also implement a sysctl for listing the available pvsched drivers.
>
> Signed-off-by: Vineeth Pillai (Google) <vineeth@bitbyteword.org>
> Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
> ---
>  Kconfig                 |   2 +
>  include/linux/pvsched.h | 102 +++++++++++++++++++
>  kernel/sysctl.c         |  27 +++++
>  virt/Makefile           |   2 +-
>  virt/pvsched/Kconfig    |  12 +++
>  virt/pvsched/Makefile   |   2 +
>  virt/pvsched/pvsched.c  | 215 ++++++++++++++++++++++++++++++++++++++++
>  7 files changed, 361 insertions(+), 1 deletion(-)
>  create mode 100644 include/linux/pvsched.h
>  create mode 100644 virt/pvsched/Kconfig
>  create mode 100644 virt/pvsched/Makefile
>  create mode 100644 virt/pvsched/pvsched.c
>
> diff --git a/Kconfig b/Kconfig
> index 745bc773f567..4a52eaa21166 100644
> --- a/Kconfig
> +++ b/Kconfig
> @@ -29,4 +29,6 @@ source "lib/Kconfig"
>
>  source "lib/Kconfig.debug"
>
> +source "virt/pvsched/Kconfig"
> +
>  source "Documentation/Kconfig"
> diff --git a/include/linux/pvsched.h b/include/linux/pvsched.h
> new file mode 100644
> index 000000000000..59df6b44aacb
> --- /dev/null
> +++ b/include/linux/pvsched.h
> @@ -0,0 +1,102 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/* Copyright (c) 2024 Google  */
> +
> +#ifndef _LINUX_PVSCHED_H
> +#define _LINUX_PVSCHED_H 1
> +
> +/*
> + * List of events for which hypervisor calls back into pvsched driver.
> + * Driver can specify the events it is interested in.
> + */
> +enum pvsched_vcpu_events {
> +       PVSCHED_VCPU_VMENTER =3D 0x1,
> +       PVSCHED_VCPU_VMEXIT =3D 0x2,
> +       PVSCHED_VCPU_HALT =3D 0x4,
> +       PVSCHED_VCPU_INTR_INJ =3D 0x8,
> +};
> +
> +#define PVSCHED_NAME_MAX       32
> +#define PVSCHED_MAX            8
> +#define PVSCHED_DRV_BUF_MAX    (PVSCHED_NAME_MAX * PVSCHED_MAX + PVSCHED=
_MAX)
> +
> +/*
> + * pvsched driver callbacks.
> + * TODO: versioning support for better compatibility with the guest
> + *       component implementing this feature.
> + */
> +struct pvsched_vcpu_ops {
> +       /*
> +        * pvsched_vcpu_register() - Register the vcpu with pvsched drive=
r.
> +        * @pid: pid of the vcpu task.
> +        *
> +        * pvsched driver can store the pid internally and initialize
> +        * itself to prepare for receiving callbacks from thsi vcpu.
> +        */
> +       int (*pvsched_vcpu_register)(struct pid *pid);
> +
> +       /*
> +        * pvsched_vcpu_unregister() - Un-register the vcpu with pvsched =
driver.
> +        * @pid: pid of the vcpu task.
> +        */
> +       void (*pvsched_vcpu_unregister)(struct pid *pid);
> +
> +       /*
> +        * pvsched_vcpu_notify_event() - Callback for pvsched events
> +        * @addr: Address of the memory region shared with guest
> +        * @pid: pid of the vcpu task.
> +        * @events: bit mask of the events that hypervisor wants to notif=
y.
> +        */
> +       void (*pvsched_vcpu_notify_event)(void *addr, struct pid *pid, u3=
2 event);
> +
> +       char name[PVSCHED_NAME_MAX];
> +       struct module *owner;
> +       struct list_head list;
> +       u32 events;
> +       u32 key;
> +};
> +
> +#ifdef CONFIG_PARAVIRT_SCHED_HOST
> +int pvsched_get_available_drivers(char *buf, size_t maxlen);
> +
> +int pvsched_register_vcpu_ops(struct pvsched_vcpu_ops *ops);
> +void pvsched_unregister_vcpu_ops(struct pvsched_vcpu_ops *ops);
> +
> +struct pvsched_vcpu_ops *pvsched_get_vcpu_ops(char *name);
> +void pvsched_put_vcpu_ops(struct pvsched_vcpu_ops *ops);
> +
> +static inline int pvsched_validate_vcpu_ops(struct pvsched_vcpu_ops *ops=
)
> +{
> +       /*
> +        * All callbacks are mandatory.
> +        */
> +       if (!ops->pvsched_vcpu_register || !ops->pvsched_vcpu_unregister =
||
> +                       !ops->pvsched_vcpu_notify_event)
> +               return -EINVAL;
> +
> +       return 0;
> +}
> +#else
> +static inline void pvsched_get_available_drivers(char *buf, size_t maxle=
n)
> +{
> +}
> +
> +static inline int pvsched_register_vcpu_ops(struct pvsched_vcpu_ops *ops=
)
> +{
> +       return -ENOTSUPP;
> +}
> +
> +static inline void pvsched_unregister_vcpu_ops(struct pvsched_vcpu_ops *=
ops)
> +{
> +}
> +
> +static inline struct pvsched_vcpu_ops *pvsched_get_vcpu_ops(char *name)
> +{
> +       return NULL;
> +}
> +
> +static inline void pvsched_put_vcpu_ops(struct pvsched_vcpu_ops *ops)
> +{
> +}
> +#endif
> +
> +#endif
> diff --git a/kernel/sysctl.c b/kernel/sysctl.c
> index 157f7ce2942d..10a18a791b4f 100644
> --- a/kernel/sysctl.c
> +++ b/kernel/sysctl.c
> @@ -63,6 +63,7 @@
>  #include <linux/mount.h>
>  #include <linux/userfaultfd_k.h>
>  #include <linux/pid.h>
> +#include <linux/pvsched.h>
>
>  #include "../lib/kstrtox.h"
>
> @@ -1615,6 +1616,24 @@ int proc_do_static_key(struct ctl_table *table, in=
t write,
>         return ret;
>  }
>
> +#ifdef CONFIG_PARAVIRT_SCHED_HOST
> +static int proc_pvsched_available_drivers(struct ctl_table *ctl,
> +                                                int write, void *buffer,
> +                                                size_t *lenp, loff_t *pp=
os)
> +{
> +       struct ctl_table tbl =3D { .maxlen =3D PVSCHED_DRV_BUF_MAX, };
> +       int ret;
> +
> +       tbl.data =3D kmalloc(tbl.maxlen, GFP_USER);
> +       if (!tbl.data)
> +               return -ENOMEM;
> +       pvsched_get_available_drivers(tbl.data, PVSCHED_DRV_BUF_MAX);
> +       ret =3D proc_dostring(&tbl, write, buffer, lenp, ppos);
> +       kfree(tbl.data);
> +       return ret;
> +}
> +#endif
> +
>  static struct ctl_table kern_table[] =3D {
>         {
>                 .procname       =3D "panic",
> @@ -2033,6 +2052,14 @@ static struct ctl_table kern_table[] =3D {
>                 .extra1         =3D SYSCTL_ONE,
>                 .extra2         =3D SYSCTL_INT_MAX,
>         },
> +#endif
> +#ifdef CONFIG_PARAVIRT_SCHED_HOST
> +       {
> +               .procname       =3D "pvsched_available_drivers",
> +               .maxlen         =3D PVSCHED_DRV_BUF_MAX,
> +               .mode           =3D 0444,
> +               .proc_handler   =3D proc_pvsched_available_drivers,
> +       },
>  #endif
>         { }
>  };
> diff --git a/virt/Makefile b/virt/Makefile
> index 1cfea9436af9..9d0f32d775a1 100644
> --- a/virt/Makefile
> +++ b/virt/Makefile
> @@ -1,2 +1,2 @@
>  # SPDX-License-Identifier: GPL-2.0-only
> -obj-y  +=3D lib/
> +obj-y  +=3D lib/ pvsched/
> diff --git a/virt/pvsched/Kconfig b/virt/pvsched/Kconfig
> new file mode 100644
> index 000000000000..5ca2669060cb
> --- /dev/null
> +++ b/virt/pvsched/Kconfig
> @@ -0,0 +1,12 @@
> +# SPDX-License-Identifier: GPL-2.0-only
> +config PARAVIRT_SCHED_HOST
> +       bool "Paravirt scheduling framework in the host kernel"
> +       default n
> +       help
> +         Paravirtualized scheduling facilitates the exchange of scheduli=
ng
> +         related information between the host and guest through shared m=
emory,
> +         enhancing the efficiency of vCPU thread scheduling by the hyper=
visor.
> +         An illustrative use case involves dynamically boosting the prio=
rity of
> +         a vCPU thread when the guest is executing a latency-sensitive w=
orkload
> +         on that specific vCPU.
> +         This config enables paravirt scheduling framework in the host k=
ernel.
> diff --git a/virt/pvsched/Makefile b/virt/pvsched/Makefile
> new file mode 100644
> index 000000000000..4ca38e30479b
> --- /dev/null
> +++ b/virt/pvsched/Makefile
> @@ -0,0 +1,2 @@
> +
> +obj-$(CONFIG_PARAVIRT_SCHED_HOST) +=3D pvsched.o
> diff --git a/virt/pvsched/pvsched.c b/virt/pvsched/pvsched.c
> new file mode 100644
> index 000000000000..610c85cf90d2
> --- /dev/null
> +++ b/virt/pvsched/pvsched.c
> @@ -0,0 +1,215 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/* Copyright (c) 2024 Google  */
> +
> +/*
> + *  Paravirt scheduling framework
> + *
> + */
> +
> +/*
> + * Heavily inspired from tcp congestion avoidance implementation.
> + * (net/ipv4/tcp_cong.c)
> + */
> +
> +#define pr_fmt(fmt) "PVSCHED: " fmt
> +
> +#include <linux/module.h>
> +#include <linux/bpf.h>
> +#include <linux/gfp.h>
> +#include <linux/types.h>
> +#include <linux/list.h>
> +#include <linux/jhash.h>
> +#include <linux/pvsched.h>
> +
> +static DEFINE_SPINLOCK(pvsched_drv_list_lock);
> +static int nr_pvsched_drivers =3D 0;
> +static LIST_HEAD(pvsched_drv_list);
> +
> +/*
> + * Retrieve pvsched_vcpu_ops given the name.
> + */
> +static struct pvsched_vcpu_ops *pvsched_find_vcpu_ops_name(char *name)
> +{
> +       struct pvsched_vcpu_ops *ops;
> +
> +       list_for_each_entry_rcu(ops, &pvsched_drv_list, list) {
> +               if (strcmp(ops->name, name) =3D=3D 0)
> +                       return ops;
> +       }
> +
> +       return NULL;
> +}
> +
> +/*
> + * Retrieve pvsched_vcpu_ops given the hash key.
> + */
> +static struct pvsched_vcpu_ops *pvsched_find_vcpu_ops_key(u32 key)
> +{
> +       struct pvsched_vcpu_ops *ops;
> +
> +       list_for_each_entry_rcu(ops, &pvsched_drv_list, list) {
> +               if (ops->key =3D=3D key)
> +                       return ops;
> +       }
> +
> +       return NULL;
> +}
> +
> +/*
> + * pvsched_get_available_drivers() - Copy space separated list of pvsche=
d
> + * driver names.
> + * @buf: buffer to store the list of driver names
> + * @maxlen: size of the buffer
> + *
> + * Return: 0 on success, negative value on error.
> + */
> +int pvsched_get_available_drivers(char *buf, size_t maxlen)
> +{
> +       struct pvsched_vcpu_ops *ops;
> +       size_t offs =3D 0;
> +
> +       if (!buf)
> +               return -EINVAL;
> +
> +       if (maxlen > PVSCHED_DRV_BUF_MAX)
> +               maxlen =3D PVSCHED_DRV_BUF_MAX;
> +
> +       rcu_read_lock();
> +       list_for_each_entry_rcu(ops, &pvsched_drv_list, list) {
> +               offs +=3D snprintf(buf + offs, maxlen - offs,
> +                                "%s%s",
> +                                offs =3D=3D 0 ? "" : " ", ops->name);
> +
> +               if (WARN_ON_ONCE(offs >=3D maxlen))
> +                       break;
> +       }
> +       rcu_read_unlock();
> +
> +       return 0;
> +}
> +EXPORT_SYMBOL_GPL(pvsched_get_available_drivers);
> +
> +/*
> + * pvsched_register_vcpu_ops() - Register the driver in the kernel.
> + * @ops: Driver data(callbacks)
> + *
> + * After the registration, driver will be exposed to the hypervisor
> + * for assignment to the guest VMs.
> + *
> + * Return: 0 on success, negative value on error.
> + */
> +int pvsched_register_vcpu_ops(struct pvsched_vcpu_ops *ops)
> +{
> +       int ret =3D 0;
> +
> +       ops->key =3D jhash(ops->name, sizeof(ops->name), strlen(ops->name=
));
> +       spin_lock(&pvsched_drv_list_lock);
> +       if (nr_pvsched_drivers > PVSCHED_MAX) {
> +               ret =3D -ENOSPC;
> +       } if (pvsched_find_vcpu_ops_key(ops->key)) {
> +               ret =3D -EEXIST;
> +       } else if (!(ret =3D pvsched_validate_vcpu_ops(ops))) {
> +               list_add_tail_rcu(&ops->list, &pvsched_drv_list);
> +               nr_pvsched_drivers++;
> +       }
> +       spin_unlock(&pvsched_drv_list_lock);
> +
> +       return ret;
> +}
> +EXPORT_SYMBOL_GPL(pvsched_register_vcpu_ops);
> +
> +/*
> + * pvsched_register_vcpu_ops() - Un-register the driver from the kernel.
> + * @ops: Driver data(callbacks)
> + *
> + * After un-registration, driver will not be visible to hypervisor.
> + */
> +void pvsched_unregister_vcpu_ops(struct pvsched_vcpu_ops *ops)
> +{
> +       spin_lock(&pvsched_drv_list_lock);
> +       list_del_rcu(&ops->list);
> +       nr_pvsched_drivers--;
> +       spin_unlock(&pvsched_drv_list_lock);
> +
> +       synchronize_rcu();
> +}
> +EXPORT_SYMBOL_GPL(pvsched_unregister_vcpu_ops);
> +
> +/*
> + * pvsched_get_vcpu_ops: Acquire the driver.
> + * @name: Name of the driver to be acquired.
> + *
> + * Hypervisor can use this API to get the driver structure for
> + * assigning it to guest VMs. This API takes a reference on the
> + * module/bpf program so that driver doesn't vanish under the
> + * hypervisor.
> + *
> + * Return: driver structure if found, else NULL.
> + */
> +struct pvsched_vcpu_ops *pvsched_get_vcpu_ops(char *name)
> +{
> +       struct pvsched_vcpu_ops *ops;
> +
> +       if (!name || (strlen(name) >=3D PVSCHED_NAME_MAX))
> +               return NULL;
> +
> +       rcu_read_lock();
> +       ops =3D pvsched_find_vcpu_ops_name(name);
> +       if (!ops)
> +               goto out;
> +
> +       if (unlikely(!bpf_try_module_get(ops, ops->owner))) {
> +               ops =3D NULL;
> +               goto out;
> +       }
> +
> +out:
> +       rcu_read_unlock();
> +       return ops;
> +}
> +EXPORT_SYMBOL_GPL(pvsched_get_vcpu_ops);
> +
> +/*
> + * pvsched_put_vcpu_ops: Release the driver.
> + * @name: Name of the driver to be releases.
> + *
> + * Hypervisor can use this API to release the driver.
> + */
> +void pvsched_put_vcpu_ops(struct pvsched_vcpu_ops *ops)
> +{
> +       bpf_module_put(ops, ops->owner);
> +}
> +EXPORT_SYMBOL_GPL(pvsched_put_vcpu_ops);
> +
> +/*
> + * NOP vm_ops Sample implementation.
> + * This driver doesn't do anything other than registering itself.
> + * Placeholder for adding some default logic when the feature is
> + * complete.
> + */
> +static int nop_pvsched_vcpu_register(struct pid *pid)
> +{
> +       return 0;
> +}
> +static void nop_pvsched_vcpu_unregister(struct pid *pid)
> +{
> +}
> +static void nop_pvsched_notify_event(void *addr, struct pid *pid, u32 ev=
ent)
> +{
> +}
> +
> +struct pvsched_vcpu_ops nop_vcpu_ops =3D {
> +       .events =3D PVSCHED_VCPU_VMENTER | PVSCHED_VCPU_VMEXIT | PVSCHED_=
VCPU_HALT,
> +       .pvsched_vcpu_register =3D nop_pvsched_vcpu_register,
> +       .pvsched_vcpu_unregister =3D nop_pvsched_vcpu_unregister,
> +       .pvsched_vcpu_notify_event =3D nop_pvsched_notify_event,
> +       .name =3D "pvsched_nop",
> +       .owner =3D THIS_MODULE,
> +};
> +
> +static int __init pvsched_init(void)
> +{
> +       return WARN_ON(pvsched_register_vcpu_ops(&nop_vcpu_ops));
> +}
> +
> +late_initcall(pvsched_init);
> --
> 2.40.1
>

