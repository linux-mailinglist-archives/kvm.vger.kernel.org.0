Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 674941E0C76
	for <lists+kvm@lfdr.de>; Mon, 25 May 2020 13:07:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390043AbgEYLHC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 May 2020 07:07:02 -0400
Received: from 12.mo5.mail-out.ovh.net ([46.105.39.65]:48550 "EHLO
        12.mo5.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389897AbgEYLHB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 May 2020 07:07:01 -0400
X-Greylist: delayed 2340 seconds by postgrey-1.27 at vger.kernel.org; Mon, 25 May 2020 07:07:00 EDT
Received: from player157.ha.ovh.net (unknown [10.108.42.66])
        by mo5.mail-out.ovh.net (Postfix) with ESMTP id AAC0627E7DA
        for <kvm@vger.kernel.org>; Mon, 25 May 2020 12:27:58 +0200 (CEST)
Received: from kaod.org (lns-bzn-46-82-253-208-248.adsl.proxad.net [82.253.208.248])
        (Authenticated sender: groug@kaod.org)
        by player157.ha.ovh.net (Postfix) with ESMTPSA id DF20712AE49C8;
        Mon, 25 May 2020 10:27:36 +0000 (UTC)
Authentication-Results: garm.ovh; auth=pass (GARM-95G0018e3cef46-2c28-4a7f-b44a-ec4150264288,22A89661A4361147AF88D80C9EA00EFFECB1F326) smtp.auth=groug@kaod.org
Date:   Mon, 25 May 2020 12:27:35 +0200
From:   Greg Kurz <groug@kaod.org>
To:     David Gibson <david@gibson.dropbear.id.au>
Cc:     qemu-devel@nongnu.org, brijesh.singh@amd.com,
        frankja@linux.ibm.com, dgilbert@redhat.com, pair@us.ibm.com,
        Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, cohuck@redhat.com,
        mdroth@linux.vnet.ibm.com, qemu-ppc@nongnu.org,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <rth@twiddle.net>
Subject: Re: [RFC v2 10/18] guest memory protection: Add guest memory
 protection interface
Message-ID: <20200525122735.1d4a45c7@bahia.lan>
In-Reply-To: <20200521034304.340040-11-david@gibson.dropbear.id.au>
References: <20200521034304.340040-1-david@gibson.dropbear.id.au>
        <20200521034304.340040-11-david@gibson.dropbear.id.au>
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 11362018912813488614
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduhedruddvtddgvdekucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepfffhvffukfgjfhfogggtgfesthejredtredtvdenucfhrhhomhepifhrvghgucfmuhhriicuoehgrhhouhhgsehkrghougdrohhrgheqnecuggftrfgrthhtvghrnhepheekhfdtheegheehjeeludefkefhvdelfedvieehhfekhfdufffhueeuvdfftdfhnecukfhppedtrddtrddtrddtpdekvddrvdehfedrvddtkedrvdegkeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhhouggvpehsmhhtphdqohhuthdphhgvlhhopehplhgrhigvrhduheejrdhhrgdrohhvhhdrnhgvthdpihhnvghtpedtrddtrddtrddtpdhmrghilhhfrhhomhepghhrohhugheskhgrohgurdhorhhgpdhrtghpthhtohepkhhvmhesvhhgvghrrdhkvghrnhgvlhdrohhrgh
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 21 May 2020 13:42:56 +1000
David Gibson <david@gibson.dropbear.id.au> wrote:

> Several architectures have mechanisms which are designed to protect guest
> memory from interference or eavesdropping by a compromised hypervisor.  AMD
> SEV does this with in-chip memory encryption and Intel has a similar
> mechanism.  POWER's Protected Execution Framework (PEF) accomplishes a
> similar goal using an ultravisor and new memory protection features,
> instead of encryption.
> 
> This introduces a new GuestMemoryProtection QOM interface which we'll use
> to (partially) unify handling of these various mechanisms.
> 
> Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
> ---
>  backends/Makefile.objs                 |  2 ++
>  backends/guest-memory-protection.c     | 29 +++++++++++++++++++++
>  include/exec/guest-memory-protection.h | 36 ++++++++++++++++++++++++++
>  3 files changed, 67 insertions(+)
>  create mode 100644 backends/guest-memory-protection.c
>  create mode 100644 include/exec/guest-memory-protection.h
> 
> diff --git a/backends/Makefile.objs b/backends/Makefile.objs
> index 28a847cd57..e4fb4f5280 100644
> --- a/backends/Makefile.objs
> +++ b/backends/Makefile.objs
> @@ -21,3 +21,5 @@ common-obj-$(CONFIG_LINUX) += hostmem-memfd.o
>  common-obj-$(CONFIG_GIO) += dbus-vmstate.o
>  dbus-vmstate.o-cflags = $(GIO_CFLAGS)
>  dbus-vmstate.o-libs = $(GIO_LIBS)
> +
> +common-obj-y += guest-memory-protection.o
> diff --git a/backends/guest-memory-protection.c b/backends/guest-memory-protection.c
> new file mode 100644
> index 0000000000..7e538214f7
> --- /dev/null
> +++ b/backends/guest-memory-protection.c
> @@ -0,0 +1,29 @@
> +#/*
> + * QEMU Guest Memory Protection interface
> + *
> + * Copyright: David Gibson, Red Hat Inc. 2020
> + *
> + * Authors:
> + *  David Gibson <david@gibson.dropbear.id.au>
> + *
> + * This work is licensed under the terms of the GNU GPL, version 2 or
> + * later.  See the COPYING file in the top-level directory.
> + *
> + */
> +
> +#include "qemu/osdep.h"
> +
> +#include "exec/guest-memory-protection.h"
> +
> +static const TypeInfo guest_memory_protection_info = {
> +    .name = TYPE_GUEST_MEMORY_PROTECTION,
> +    .parent = TYPE_INTERFACE,
> +    .class_size = sizeof(GuestMemoryProtectionClass),
> +};
> +
> +static void guest_memory_protection_register_types(void)
> +{
> +    type_register_static(&guest_memory_protection_info);
> +}
> +
> +type_init(guest_memory_protection_register_types)
> diff --git a/include/exec/guest-memory-protection.h b/include/exec/guest-memory-protection.h
> new file mode 100644
> index 0000000000..38e9b01667
> --- /dev/null
> +++ b/include/exec/guest-memory-protection.h
> @@ -0,0 +1,36 @@
> +#/*
> + * QEMU Guest Memory Protection interface
> + *
> + * Copyright: David Gibson, Red Hat Inc. 2020
> + *
> + * Authors:
> + *  David Gibson <david@gibson.dropbear.id.au>
> + *
> + * This work is licensed under the terms of the GNU GPL, version 2 or
> + * later.  See the COPYING file in the top-level directory.
> + *
> + */
> +#ifndef QEMU_GUEST_MEMORY_PROTECTION_H
> +#define QEMU_GUEST_MEMORY_PROTECTION_H
> +
> +#include "qom/object.h"
> +
> +typedef struct GuestMemoryProtection GuestMemoryProtection;
> +
> +#define TYPE_GUEST_MEMORY_PROTECTION "guest-memory-protection"
> +#define GUEST_MEMORY_PROTECTION(obj)                                    \
> +    INTERFACE_CHECK(GuestMemoryProtection, (obj),                       \
> +                    TYPE_GUEST_MEMORY_PROTECTION)
> +#define GUEST_MEMORY_PROTECTION_CLASS(klass)                            \
> +    OBJECT_CLASS_CHECK(GuestMemoryProtectionClass, (klass),             \
> +                       TYPE_GUEST_MEMORY_PROTECTION)
> +#define GUEST_MEMORY_PROTECTION_GET_CLASS(obj)                          \
> +    OBJECT_GET_CLASS(GuestMemoryProtectionClass, (obj),                 \
> +                     TYPE_GUEST_MEMORY_PROTECTION)
> +
> +typedef struct GuestMemoryProtectionClass {
> +    InterfaceClass parent;
> +} GuestMemoryProtectionClass;
> +
> +#endif /* QEMU_GUEST_MEMORY_PROTECTION_H */
> +

Applying patch #1294935 using "git am -s -m"
Description: [RFC,v2,10/18] guest memory protection: Add guest memory protection
Applying: guest memory protection: Add guest memory protection interface
.git/rebase-apply/patch:95: new blank line at EOF.
+
warning: 1 line adds whitespace errors.

