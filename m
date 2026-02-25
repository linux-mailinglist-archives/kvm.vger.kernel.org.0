Return-Path: <kvm+bounces-71897-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uPfcNvd7n2mMcQQAu9opvQ
	(envelope-from <kvm+bounces-71897-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 23:47:19 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 48FDA19E700
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 23:47:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 374783066423
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 22:46:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A24536656A;
	Wed, 25 Feb 2026 22:46:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fLfzE9sq"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42C703195FB;
	Wed, 25 Feb 2026 22:46:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772059613; cv=none; b=XvR2wUu4eRsuAhrRPtj5Qr9TZX6ws2dimoEep9QmtNkpYaqi9oEPZ4Z1V/xHmKMWI4rTdV5DKpqnmU1Pd0t6QNy01s/C53sz8pRsRptA9tJJ8dl04gAp+pmbYdV0Aq4+fbM4lWI+xcClfFOnSt+KjyNnxnpLBtgjqF6z3QVlb5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772059613; c=relaxed/simple;
	bh=PTjq+4/D+IzkYXkv5mizn+hDJB3L4KyyQ4pV0ihQ7vc=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=RprVu+TlmhKCBfS//vI92VP7niklxORU7bXandhim+/jHqG3NlVeTWX6zDG0nsArJBXV96g/99ceyTxuNWRu0nvbEG3kFZQ9NnsHJNYG2QQLrMXpKxOKkBj2qDSElSPvuPgRG+LTIlftRcFl+OUgDYNQe7694VcunrfpMt8fYW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fLfzE9sq; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B517BC116D0;
	Wed, 25 Feb 2026 22:46:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772059612;
	bh=PTjq+4/D+IzkYXkv5mizn+hDJB3L4KyyQ4pV0ihQ7vc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:From;
	b=fLfzE9sqNX2M3OlPq9XtgvX2CSblhRxIxYwGfOqWzh73vdkJ1eyR/SDMoNxIs4htN
	 exQpwOsZqx/gffethdxaIee4xk7hQXLH7P8yPYRbjRyPL8BuYDfKOjWFCkhyMs9G6G
	 UzNmLV3HCkjtDK/itE87sZYNt9sCt2ye8RSVBOXDtJY+emFSkRqhku/ykxwUsKtbc2
	 glWyhSGXSpU6WOpfPMaezlLyos9hJPVzH3t39UaYh/6AkdIW01zHD85NW+udcoivsC
	 CfwaP5OJI6BOHkXjZ268AnM+f4Bp5dAfLtutNyB6FEr4S0gpWMzguYJIwjySgqVqcC
	 VVG8d1yPPitOQ==
Date: Wed, 25 Feb 2026 16:46:51 -0600
From: Bjorn Helgaas <helgaas@kernel.org>
To: David Matlack <dmatlack@google.com>
Cc: Alex Williamson <alex@shazbot.org>,
	Adithya Jayachandran <ajayachandra@nvidia.com>,
	Alexander Graf <graf@amazon.com>, Alex Mastro <amastro@fb.com>,
	Alistair Popple <apopple@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ankit Agrawal <ankita@nvidia.com>,
	Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Jacob Pan <jacob.pan@linux.microsoft.com>,
	Jason Gunthorpe <jgg@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>,
	Kevin Tian <kevin.tian@intel.com>, kexec@lists.infradead.org,
	kvm@vger.kernel.org, Leon Romanovsky <leon@kernel.org>,
	Leon Romanovsky <leonro@nvidia.com>, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org, linux-pci@vger.kernel.org,
	Lukas Wunner <lukas@wunner.de>,
	=?utf-8?Q?Micha=C5=82?= Winiarski <michal.winiarski@intel.com>,
	Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pranjal Shrivastava <praan@google.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Thomas =?utf-8?Q?Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Tomita Moeko <tomitamoeko@gmail.com>,
	Vipin Sharma <vipinsh@google.com>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>,
	Zhu Yanjun <yanjun.zhu@linux.dev>
Subject: Re: [PATCH v2 02/22] PCI: Add API to track PCI devices preserved
 across Live Update
Message-ID: <20260225224651.GA3711085@bhelgaas>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260129212510.967611-3-dmatlack@google.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71897-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[shazbot.org,nvidia.com,amazon.com,fb.com,linux-foundation.org,google.com,kernel.org,linux.microsoft.com,ziepe.ca,lwn.net,intel.com,lists.infradead.org,vger.kernel.org,kvack.org,wunner.de,soleen.com,linuxfoundation.org,linux.intel.com,gmail.com,linux.dev];
	RCPT_COUNT_TWELVE(0.00)[45];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[helgaas@kernel.org,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 48FDA19E700
X-Rspamd-Action: no action

On Thu, Jan 29, 2026 at 09:24:49PM +0000, David Matlack wrote:
> Add an API to enable the PCI subsystem to track all devices that are
> preserved across a Live Update, including both incoming devices (passed
> from the previous kernel) and outgoing devices (passed to the next
> kernel).

I'd probably describe this in the "outgoing ... incoming" order since
that's the order of operation.

> Use PCI segment number and BDF to keep track of devices across Live
> Update. This means the kernel must keep both identifiers constant across
> a Live Update for any preserved device. VFs are not supported for now,
> since that requires preserving SR-IOV state on the device to ensure the
> same number of VFs appear after kexec and with the same BDFs.
> 
> Drivers that preserve devices across Live Update can now register their
> struct liveupdate_file_handler with the PCI subsystem so that the PCI
> subsystem can allocate and manage File-Lifecycle-Bound (FLB) global data
> to track the list of incoming and outgoing preserved devices.

In what sense is this "global"?  I assume it doesn't mean global
scope; does it mean something that persists across the kexec?

>   pci_liveupdate_register_fh(driver_fh)
>   pci_liveupdate_unregister_fh(driver_fh)
> 
> Drivers can notify the PCI subsystem whenever a device is preserved and
> unpreserved with the following APIs:
>
>   pci_liveupdate_outgoing_preserve(pci_dev)
>   pci_liveupdate_outgoing_unpreserve(pci_dev)

IIUC this is basically asking the PCI core to preserve the generic PCI
parts of a device, i.e., the PCI core and the driver collaborate to
preserve it?

I know what "preserve" means: "please maintain the original state."
The sort of made-up "unpreserve" sounds nicely symmetric, but I don't
think it means "destroy the original state."  It feels like more of a
"cancel" of the original request to preserve something.  Maybe not
worth any change, but I suspect this operation is going to be part of
the user interface for the administrator, and the description of
"unpreserve" will probably include something like "cancel."

> After a Live Update, the PCI subsystem fetches its FLB global data
> from the previous kernel from the Live Update Orchestrator (LUO) during
> device initialization to determine which devices were preserved.
> 
> Drivers can check if a device was preserved before userspace retrieves
> the file for it via pci_dev->liveupdate_incoming.

I see how drivers need to know whether their device has been preserved
and needs to be adopted, but what does userspace have to do with this?

I don't know what the file is, but it doesn't sound related to the PCI
core, so maybe it should be mentioned elsewhere?

I assume the PCI core preserves a device based only on the indication
from the previous kernel.

> Once a driver has finished restoring an incoming preserved device, it
> can notify the PCI subsystem with the following call, which clears
> pci_dev->liveupdate_incoming.
> 
>   pci_liveupdate_incoming_finish(pci_dev)
>
> This API will be used in subsequent commits by the vfio-pci driver to
> preserve VFIO devices across Live Update and by the PCI subsystem.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>  drivers/pci/Makefile        |   1 +
>  drivers/pci/liveupdate.c    | 212 ++++++++++++++++++++++++++++++++++++
>  drivers/pci/probe.c         |   2 +
>  include/linux/kho/abi/pci.h |  55 ++++++++++
>  include/linux/pci.h         |  47 ++++++++
>  5 files changed, 317 insertions(+)
>  create mode 100644 drivers/pci/liveupdate.c
>  create mode 100644 include/linux/kho/abi/pci.h
> 
> diff --git a/drivers/pci/Makefile b/drivers/pci/Makefile
> index 8c259a9a8796..a32f7658b9e5 100644
> --- a/drivers/pci/Makefile
> +++ b/drivers/pci/Makefile
> @@ -16,6 +16,7 @@ obj-$(CONFIG_PROC_FS)		+= proc.o
>  obj-$(CONFIG_SYSFS)		+= pci-sysfs.o slot.o
>  obj-$(CONFIG_ACPI)		+= pci-acpi.o
>  obj-$(CONFIG_GENERIC_PCI_IOMAP) += iomap.o
> +obj-$(CONFIG_LIVEUPDATE)	+= liveupdate.o
>  endif
>  
>  obj-$(CONFIG_OF)		+= of.o
> diff --git a/drivers/pci/liveupdate.c b/drivers/pci/liveupdate.c
> new file mode 100644
> index 000000000000..182cfc793b80
> --- /dev/null
> +++ b/drivers/pci/liveupdate.c
> @@ -0,0 +1,212 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +/*
> + * Copyright (c) 2025, Google LLC.

2026

> + * David Matlack <dmatlack@google.com>
> + */
> +
> +#include <linux/bsearch.h>
> +#include <linux/io.h>
> +#include <linux/kexec_handover.h>
> +#include <linux/kho/abi/pci.h>
> +#include <linux/liveupdate.h>
> +#include <linux/mutex.h>
> +#include <linux/mm.h>
> +#include <linux/pci.h>
> +#include <linux/sort.h>
> +
> +static DEFINE_MUTEX(pci_flb_outgoing_lock);
> +
> +static int pci_flb_preserve(struct liveupdate_flb_op_args *args)
> +{
> +	struct pci_dev *dev = NULL;
> +	int max_nr_devices = 0;
> +	struct pci_ser *ser;
> +	unsigned long size;
> +
> +	for_each_pci_dev(dev)
> +		max_nr_devices++;

How is this protected against hotplug?

> +	size = struct_size_t(struct pci_ser, devices, max_nr_devices);
> +
> +	ser = kho_alloc_preserve(size);
> +	if (IS_ERR(ser))
> +		return PTR_ERR(ser);
> +
> +	ser->max_nr_devices = max_nr_devices;
> +
> +	args->obj = ser;
> +	args->data = virt_to_phys(ser);
> +	return 0;
> +}
> +
> +static void pci_flb_unpreserve(struct liveupdate_flb_op_args *args)
> +{
> +	struct pci_ser *ser = args->obj;
> +
> +	WARN_ON_ONCE(ser->nr_devices);

What is this warning telling the user?  Is there something wrong?
What would I do to fix things if I saw this, and how would I know what
to do?

Is this telling us that we're undoing a "preserve" operation, which is
supposed to involve "unpreserve" on each device that has previously
been marked for preservation, but something (what?) forgot to
unpreserve one of the devices?

Seems like maybe a debugging aid, but probably not something an
indication that the administrator did something wrong?

> +	kho_unpreserve_free(ser);
> +}
> +
> +static int pci_flb_retrieve(struct liveupdate_flb_op_args *args)
> +{
> +	args->obj = phys_to_virt(args->data);
> +	return 0;
> +}
> +
> +static void pci_flb_finish(struct liveupdate_flb_op_args *args)
> +{
> +	kho_restore_free(args->obj);
> +}
> +
> +static struct liveupdate_flb_ops pci_liveupdate_flb_ops = {
> +	.preserve = pci_flb_preserve,
> +	.unpreserve = pci_flb_unpreserve,
> +	.retrieve = pci_flb_retrieve,
> +	.finish = pci_flb_finish,
> +	.owner = THIS_MODULE,
> +};
> +
> +static struct liveupdate_flb pci_liveupdate_flb = {
> +	.ops = &pci_liveupdate_flb_ops,
> +	.compatible = PCI_LUO_FLB_COMPATIBLE,

I don't see anything in this series that checks this.  Maybe omit it
until it's used?

> +};
> +
> +#define INIT_PCI_DEV_SER(_dev) {		\
> +	.domain = pci_domain_nr((_dev)->bus),	\
> +	.bdf = pci_dev_id(_dev),		\
> +}
> +
> +static int pci_dev_ser_cmp(const void *__a, const void *__b)
> +{
> +	const struct pci_dev_ser *a = __a, *b = __b;
> +
> +	return cmp_int(a->domain << 16 | a->bdf, b->domain << 16 | b->bdf);
> +}
> +
> +static struct pci_dev_ser *pci_ser_find(struct pci_ser *ser,
> +					struct pci_dev *dev)
> +{
> +	const struct pci_dev_ser key = INIT_PCI_DEV_SER(dev);
> +
> +	return bsearch(&key, ser->devices, ser->nr_devices,
> +		       sizeof(key), pci_dev_ser_cmp);
> +}
> +
> +static int pci_ser_delete(struct pci_ser *ser, struct pci_dev *dev)
> +{
> +	struct pci_dev_ser *dev_ser;
> +	int i;
> +
> +	dev_ser = pci_ser_find(ser, dev);
> +	if (!dev_ser)
> +		return -ENOENT;
> +
> +	for (i = dev_ser - ser->devices; i < ser->nr_devices - 1; i++)
> +		ser->devices[i] = ser->devices[i + 1];
> +
> +	ser->nr_devices--;
> +	return 0;
> +}
> +
> +int pci_liveupdate_outgoing_preserve(struct pci_dev *dev)
> +{
> +	struct pci_dev_ser new = INIT_PCI_DEV_SER(dev);
> +	struct pci_ser *ser;
> +	int i, ret;
> +
> +	/* Preserving VFs is not supported yet. */
> +	if (dev->is_virtfn)
> +		return -EINVAL;
> +
> +	guard(mutex)(&pci_flb_outgoing_lock);
> +
> +	if (dev->liveupdate_outgoing)

Is there a real need to keep "dev->liveupdate_outgoing", as opposed to
just searching ser->devices[]?  It looks like the only use is to keep
from adding a device to ser->devices[] twice.

> +		return -EBUSY;
> +
> +	ret = liveupdate_flb_get_outgoing(&pci_liveupdate_flb, (void **)&ser);

I guess this "get" must correspond with the kho_alloc_preserve() in
pci_flb_preserve()?  It's sort of annoying that there's nothing in the
function names to connect them because it's hard to find the source.

> +	if (ret)
> +		return ret;
> +
> +	if (ser->nr_devices == ser->max_nr_devices)
> +		return -E2BIG;
> +
> +	for (i = ser->nr_devices; i > 0; i--) {
> +		struct pci_dev_ser *prev = &ser->devices[i - 1];
> +		int cmp = pci_dev_ser_cmp(&new, prev);
> +
> +		if (WARN_ON_ONCE(!cmp))
> +			return -EBUSY;
> +
> +		if (cmp > 0)
> +			break;
> +
> +		ser->devices[i] = *prev;
> +	}
> +
> +	ser->devices[i] = new;
> +	ser->nr_devices++;
> +	dev->liveupdate_outgoing = true;
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(pci_liveupdate_outgoing_preserve);
> +
> +void pci_liveupdate_outgoing_unpreserve(struct pci_dev *dev)
> +{
> +	struct pci_ser *ser;
> +	int ret;
> +
> +	guard(mutex)(&pci_flb_outgoing_lock);
> +
> +	ret = liveupdate_flb_get_outgoing(&pci_liveupdate_flb, (void **)&ser);
> +	if (WARN_ON_ONCE(ret))

I'm a little dubious about all the WARN_ON_ONCE() calls here.  They
seem like debugging aids that we would want to remove eventually, so
maybe they should just be out-of-tree to begin with.

> +		return;
> +
> +	WARN_ON_ONCE(pci_ser_delete(ser, dev));

I don't like putting code with side effects inside WARN_ON() because
the important code gets hidden.

> +	dev->liveupdate_outgoing = false;
> +}
> +EXPORT_SYMBOL_GPL(pci_liveupdate_outgoing_unpreserve);
> +
> +u32 pci_liveupdate_incoming_nr_devices(void)
> +{
> +	struct pci_ser *ser;
> +	int ret;
> +
> +	ret = liveupdate_flb_get_incoming(&pci_liveupdate_flb, (void **)&ser);
> +	if (ret)
> +		return 0;
> +
> +	return ser->nr_devices;
> +}
> +EXPORT_SYMBOL_GPL(pci_liveupdate_incoming_nr_devices);

Currently only called from drivers/pci/probe.c; does this really need
to be declared in include/linux/pci.h and exported?  We can do that
later if/when needed.  Put in drivers/pci/pci.h if only needed in
drivers/pci/.

> +void pci_liveupdate_setup_device(struct pci_dev *dev)
> +{
> +	struct pci_ser *ser;
> +	int ret;
> +
> +	ret = liveupdate_flb_get_incoming(&pci_liveupdate_flb, (void **)&ser);
> +	if (ret)
> +		return;
> +
> +	dev->liveupdate_incoming = !!pci_ser_find(ser, dev);

I think this would be easier to read as:

  if (pci_ser_find(ser, dev))
    dev->liveupdate_incoming = true;

> +}
> +EXPORT_SYMBOL_GPL(pci_liveupdate_setup_device);

Currently only called from pci_setup_device(); does this really need
to be declared in include/linux/pci.h and exported?  We can do that
later if/when needed.

> +void pci_liveupdate_incoming_finish(struct pci_dev *dev)
> +{
> +	dev->liveupdate_incoming = false;

What is this useful for?  Does the PCI core need to *do* anything
after a driver finishes its own adoption of a preserved device?  I
assume everything the PCI core does, i.e., rebuilding its pci_dev and
related things based on KHO data, must be done before the driver sees
the device.

> +}
> +EXPORT_SYMBOL_GPL(pci_liveupdate_incoming_finish);
> +
> +int pci_liveupdate_register_fh(struct liveupdate_file_handler *fh)
> +{
> +	return liveupdate_register_flb(fh, &pci_liveupdate_flb);
> +}
> +EXPORT_SYMBOL_GPL(pci_liveupdate_register_fh);
> +
> +int pci_liveupdate_unregister_fh(struct liveupdate_file_handler *fh)
> +{
> +	return liveupdate_unregister_flb(fh, &pci_liveupdate_flb);
> +}
> +EXPORT_SYMBOL_GPL(pci_liveupdate_unregister_fh);
> diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
> index 37329095e5fe..af6356c5a156 100644
> --- a/drivers/pci/probe.c
> +++ b/drivers/pci/probe.c
> @@ -2060,6 +2060,8 @@ int pci_setup_device(struct pci_dev *dev)
>  	if (pci_early_dump)
>  		early_dump_pci_device(dev);
>  
> +	pci_liveupdate_setup_device(dev);
> +
>  	/* Need to have dev->class ready */
>  	dev->cfg_size = pci_cfg_space_size(dev);
>  
> diff --git a/include/linux/kho/abi/pci.h b/include/linux/kho/abi/pci.h
> new file mode 100644
> index 000000000000..6577767f8da6
> --- /dev/null
> +++ b/include/linux/kho/abi/pci.h

Seems unusual to make an abi/ subdirectory when that's the only thing
in kho/, but I assume you have plans for more.

There are several *-abi.h files in include/uapi/, but this abi/
directory is the ABI-ish name in include/linux (except for the
include/soc/tegra/bpmp-abi.h oddity).

> @@ -0,0 +1,55 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +
> +/*
> + * Copyright (c) 2025, Google LLC.
> + * David Matlack <dmatlack@google.com>
> + */
> +
> +#ifndef _LINUX_KHO_ABI_PCI_H
> +#define _LINUX_KHO_ABI_PCI_H
> +
> +#include <linux/compiler.h>
> +#include <linux/types.h>
> +
> +/**
> + * DOC: PCI File-Lifecycle Bound (FLB) Live Update ABI
> + *
> + * This header defines the ABI for preserving core PCI state across kexec using
> + * Live Update File-Lifecycle Bound (FLB) data.
> + *
> + * This interface is a contract. Any modification to any of the serialization
> + * structs defined here constitutes a breaking change. Such changes require
> + * incrementing the version number in the PCI_LUO_FLB_COMPATIBLE string.
> + */
> +
> +#define PCI_LUO_FLB_COMPATIBLE "pci-v1"
> +
> +/**
> + * struct pci_dev_ser - Serialized state about a single PCI device.
> + *
> + * @domain: The device's PCI domain number (segment).
> + * @bdf: The device's PCI bus, device, and function number.
> + */
> +struct pci_dev_ser {
> +	u16 domain;

ACPI _SEG is limited to 16 bits, but I think all the Linux interfaces
use "int" and VMD creates domains starting with 0x10000 to avoid
colliding with ACPI segment numbers.  I think we should probably use
u32 here (and for the Linux interfaces, but that's another patch).

> +	u16 bdf;
> +} __packed;
> +
> +/**
> + * struct pci_ser - PCI Subsystem Live Update State
> + *
> + * This struct tracks state about all devices that are being preserved across
> + * a Live Update for the next kernel.
> + *
> + * @max_nr_devices: The length of the devices[] flexible array.
> + * @nr_devices: The number of devices that were preserved.
> + * @devices: Flexible array of pci_dev_ser structs for each device. Guaranteed
> + *           to be sorted ascending by domain and bdf.
> + */
> +struct pci_ser {
> +	u64 max_nr_devices;
> +	u64 nr_devices;
> +	struct pci_dev_ser devices[];
> +} __packed;
> +
> +#endif /* _LINUX_KHO_ABI_PCI_H */
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index 7e36936bb37a..9ead6d84aef6 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -40,6 +40,7 @@
>  #include <linux/resource_ext.h>
>  #include <linux/msi_api.h>
>  #include <uapi/linux/pci.h>
> +#include <linux/liveupdate.h>
>  
>  #include <linux/pci_ids.h>
>  
> @@ -582,6 +583,10 @@ struct pci_dev {
>  	u8		tph_mode;	/* TPH mode */
>  	u8		tph_req_type;	/* TPH requester type */
>  #endif
> +#ifdef CONFIG_LIVEUPDATE
> +	unsigned int	liveupdate_incoming:1;	/* Preserved by previous kernel */
> +	unsigned int	liveupdate_outgoing:1;	/* Preserved for next kernel */
> +#endif
>  };
>  
>  static inline struct pci_dev *pci_physfn(struct pci_dev *dev)
> @@ -2854,4 +2859,46 @@ void pci_uevent_ers(struct pci_dev *pdev, enum  pci_ers_result err_type);
>  	WARN_ONCE(condition, "%s %s: " fmt, \
>  		  dev_driver_string(&(pdev)->dev), pci_name(pdev), ##arg)
>  
> +#ifdef CONFIG_LIVEUPDATE
> +int pci_liveupdate_outgoing_preserve(struct pci_dev *dev);
> +void pci_liveupdate_outgoing_unpreserve(struct pci_dev *dev);
> +void pci_liveupdate_setup_device(struct pci_dev *dev);
> +u32 pci_liveupdate_incoming_nr_devices(void);
> +void pci_liveupdate_incoming_finish(struct pci_dev *dev);
> +int pci_liveupdate_register_fh(struct liveupdate_file_handler *fh);
> +int pci_liveupdate_unregister_fh(struct liveupdate_file_handler *fh);
> +#else /* !CONFIG_LIVEUPDATE */
> +static inline int pci_liveupdate_outgoing_preserve(struct pci_dev *dev)
> +{
> +	return -EOPNOTSUPP;
> +}
> +
> +static inline void pci_liveupdate_outgoing_unpreserve(struct pci_dev *dev)
> +{
> +}
> +
> +static inline void pci_liveupdate_setup_device(struct pci_dev *dev)
> +{
> +}
> +
> +static inline u32 pci_liveupdate_incoming_nr_devices(void)
> +{
> +	return 0;
> +}
> +
> +static inline void pci_liveupdate_incoming_finish(struct pci_dev *dev)
> +{
> +}
> +
> +static inline int pci_liveupdate_register_fh(struct liveupdate_file_handler *fh)
> +{
> +	return -EOPNOTSUPP;
> +}
> +
> +static inline int pci_liveupdate_unregister_fh(struct liveupdate_file_handler *fh)
> +{
> +	return -EOPNOTSUPP;
> +}
> +#endif /* !CONFIG_LIVEUPDATE */
> +
>  #endif /* LINUX_PCI_H */
> -- 
> 2.53.0.rc1.225.gd81095ad13-goog
> 

