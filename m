Return-Path: <kvm+bounces-44581-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C9557A9F410
	for <lists+kvm@lfdr.de>; Mon, 28 Apr 2025 17:05:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 408133B6216
	for <lists+kvm@lfdr.de>; Mon, 28 Apr 2025 15:05:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 941522797A3;
	Mon, 28 Apr 2025 15:05:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iVTSuYvj"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9767192D83;
	Mon, 28 Apr 2025 15:05:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745852732; cv=none; b=g3w5W9M02UEBoGcTweh+Xb6p5rAHgFweVu1oR0pl4DqoEHov1Nqpg3+zFY+G3ma8kiimYx7HZUNLYnXfNXAXEcQIeD5Lf9neilIcqbuo21CHIjj9n+XvbAr1Ojsp+27VHe8nM1QgKzjAi4t70AYLHwN/VQlUHPvXtE12W7Dzjwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745852732; c=relaxed/simple;
	bh=VJxXe/Ga2jumdetbeBRYvHL7yi4RCMj/Ek53LW4jqPA=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=mTSlu0AvfiOQqCY9YJfKr4qtDVq/C6CscPHEfoBRwbz4RvsJH0fVGPSECtZoAngM28/crpC9/ZiyWaSBg7ckYFjJrEZHNg4eUChlihmTTXXzWOxitMQW7e1V5xbNaVPsjHkmF8d+xcBvsmS1aylv5O854/bINLbYPXk6XjP1TnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iVTSuYvj; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CE7CC4CEE4;
	Mon, 28 Apr 2025 15:05:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745852732;
	bh=VJxXe/Ga2jumdetbeBRYvHL7yi4RCMj/Ek53LW4jqPA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:From;
	b=iVTSuYvjNmUeYSiWEuEEl722TPRNNSMcZEfDNMMXcgrnTA4Y1k8XDQy/rq9RVk0JG
	 V7j1S08LtgwQqZ1uBzIB8gEM2xvVqowRGithWICn7J3JZabF4ApvJINi8g3N4q5LwE
	 BFTYNRy0sJPpclkHMyQf9nqD52F9aG4ESc5FxnUjwbuT69lYfCvnmC8HrcobFXa4zk
	 EXaqk8hmP82hyFaEjhgpL59DKTl1zYRDH3C1P9tIS1Sl7FE739OPOKAEg6a2wRNzWD
	 /J9usLZhoVhpurE9DT0U4OGZnsttUVCrSwepq6EtiRFZ0PEXEAD6AQMPoaTLrQTX7e
	 A3gICimQjCE+g==
Date: Mon, 28 Apr 2025 10:05:30 -0500
From: Bjorn Helgaas <helgaas@kernel.org>
To: Chathura Rajapaksha <chathura.abeyrathne.lk@gmail.com>
Cc: kvm@vger.kernel.org, Chathura Rajapaksha <chath@bu.edu>,
	William Wang <xwill@bu.edu>,
	Alex Williamson <alex.williamson@redhat.com>,
	Paul Moore <paul@paul-moore.com>, Eric Paris <eparis@redhat.com>,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Xin Zeng <xin.zeng@intel.com>, Kevin Tian <kevin.tian@intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Yahui Cao <yahui.cao@intel.com>, Yunxiang Li <Yunxiang.Li@amd.com>,
	Dongdong Zhang <zhangdongdong@eswincomputing.com>,
	Avihai Horon <avihaih@nvidia.com>, linux-kernel@vger.kernel.org,
	audit@vger.kernel.org
Subject: Re: [RFC PATCH 2/2] audit accesses to unassigned PCI config regions
Message-ID: <20250428150530.GA670882@bhelgaas>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250426212253.40473-3-chath@bu.edu>

On Sat, Apr 26, 2025 at 09:22:49PM +0000, Chathura Rajapaksha wrote:
> Some PCIe devices trigger PCI bus errors when accesses are made to
> unassigned regions within their PCI configuration space. On certain
> platforms, this can lead to host system hangs or reboots.
> 
> The current vfio-pci driver allows guests to access unassigned regions
> in the PCI configuration space. Therefore, when such a device is passed
> through to a guest, the guest can induce a host system hang or reboot
> through crafted configuration space accesses, posing a threat to
> system availability.
> 
> This patch introduces auditing support for config space accesses to
> unassigned regions. When enabled, this logs such accesses for all
> passthrough devices. 
> This feature is controlled via a new Kconfig option:

Add blank line between paragraphs.

>   CONFIG_VFIO_PCI_UNASSIGNED_ACCESS_AUDIT
> 
> A new audit event type, AUDIT_VFIO, has been introduced to support
> this, allowing administrators to monitor and investigate suspicious
> behavior by guests.

Use imperative mood ("Introduce" instead of "This patch introduces
..." and "Add ..." instead of "A new type has been introduced").

> Co-developed by: William Wang <xwill@bu.edu>
> Signed-off-by: William Wang <xwill@bu.edu>
> Signed-off-by: Chathura Rajapaksha <chath@bu.edu>
> ---
>  drivers/vfio/pci/Kconfig           | 12 ++++++++
>  drivers/vfio/pci/vfio_pci_config.c | 46 ++++++++++++++++++++++++++++--
>  include/uapi/linux/audit.h         |  1 +
>  3 files changed, 57 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
> index c3bcb6911c53..7f9f16262b90 100644
> --- a/drivers/vfio/pci/Kconfig
> +++ b/drivers/vfio/pci/Kconfig
> @@ -42,6 +42,18 @@ config VFIO_PCI_IGD
>  	  and LPC bridge config space.
>  
>  	  To enable Intel IGD assignment through vfio-pci, say Y.
> +
> +config VFIO_PCI_UNASSIGNED_ACCESS_AUDIT
> +	bool "Audit accesses to unassigned PCI configuration regions"
> +	depends on AUDIT && VFIO_PCI_CORE
> +	help
> +	  Some PCIe devices are known to cause bus errors when accessing
> +	  unassigned PCI configuration space, potentially leading to host
> +	  system hangs on certain platforms. When enabled, this option
> +	  audits accesses to unassigned PCI configuration regions.
> +
> +	  If you don't know what to do here, say N.
> +
>  endif
>  
>  config VFIO_PCI_ZDEV_KVM
> diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
> index cb4d11aa5598..ddd10904d60f 100644
> --- a/drivers/vfio/pci/vfio_pci_config.c
> +++ b/drivers/vfio/pci/vfio_pci_config.c
> @@ -25,6 +25,7 @@
>  #include <linux/uaccess.h>
>  #include <linux/vfio.h>
>  #include <linux/slab.h>
> +#include <linux/audit.h>
>  
>  #include "vfio_pci_priv.h"
>  
> @@ -1980,6 +1981,37 @@ static size_t vfio_pci_cap_remaining_dword(struct vfio_pci_core_device *vdev,
>  	return i;
>  }
>  
> +enum vfio_audit {
> +	VFIO_AUDIT_READ,
> +	VFIO_AUDIT_WRITE,
> +	VFIO_AUDIT_MAX,
> +};
> +
> +static const char * const vfio_audit_str[VFIO_AUDIT_MAX] = {
> +	[VFIO_AUDIT_READ]  = "READ",
> +	[VFIO_AUDIT_WRITE] = "WRITE",
> +};
> +
> +static void vfio_audit_access(const struct pci_dev *pdev,
> +			      size_t count, loff_t *ppos, bool blocked, unsigned int op)
> +{
> +	struct audit_buffer *ab;
> +
> +	if (WARN_ON_ONCE(op >= VFIO_AUDIT_MAX))
> +		return;
> +	if (audit_enabled == AUDIT_OFF)
> +		return;
> +	ab = audit_log_start(audit_context(), GFP_ATOMIC, AUDIT_VFIO);
> +	if (unlikely(!ab))
> +		return;
> +	audit_log_format(ab,
> +			 "device=%04x:%02x:%02x.%d access=%s offset=0x%llx size=%ld blocked=%u\n",
> +			 pci_domain_nr(pdev->bus), pdev->bus->number,
> +			 PCI_SLOT(pdev->devfn), PCI_FUNC(pdev->devfn),
> +			 vfio_audit_str[op], *ppos, count, blocked);
> +	audit_log_end(ab);
> +}
> +
>  static ssize_t vfio_config_do_rw(struct vfio_pci_core_device *vdev, char __user *buf,
>  				 size_t count, loff_t *ppos, bool iswrite)
>  {
> @@ -1989,6 +2021,7 @@ static ssize_t vfio_config_do_rw(struct vfio_pci_core_device *vdev, char __user
>  	int cap_start = 0, offset;
>  	u8 cap_id;
>  	ssize_t ret;
> +	bool blocked;
>  
>  	if (*ppos < 0 || *ppos >= pdev->cfg_size ||
>  	    *ppos + count > pdev->cfg_size)
> @@ -2011,13 +2044,22 @@ static ssize_t vfio_config_do_rw(struct vfio_pci_core_device *vdev, char __user
>  	cap_id = vdev->pci_config_map[*ppos];
>  
>  	if (cap_id == PCI_CAP_ID_INVALID) {
> -		if (((iswrite && block_pci_unassigned_write) ||
> +		blocked = (((iswrite && block_pci_unassigned_write) ||
>  		     (!iswrite && block_pci_unassigned_read)) &&
> -		    !pci_uaccess_lookup(pdev))
> +		    !pci_uaccess_lookup(pdev));
> +		if (blocked)
>  			perm = &block_unassigned_perms;
>  		else
>  			perm = &unassigned_perms;
>  		cap_start = *ppos;
> +		if (IS_ENABLED(CONFIG_VFIO_PCI_UNASSIGNED_ACCESS_AUDIT)) {
> +			if (iswrite)
> +				vfio_audit_access(pdev, count, ppos, blocked,
> +						  VFIO_AUDIT_WRITE);
> +			else
> +				vfio_audit_access(pdev, count, ppos, blocked,
> +						  VFIO_AUDIT_READ);
> +		}

Simplify this patch by adding "blocked" in the first patch.  Then you
won't have to touch the permission checking that is unrelated to the
audit logging.  Consider adding a helper to do the checking and return
"blocked" so it doesn't clutter vfio_config_do_rw().

>  	} else if (cap_id == PCI_CAP_ID_INVALID_VIRT) {
>  		perm = &virt_perms;
>  		cap_start = *ppos;
> diff --git a/include/uapi/linux/audit.h b/include/uapi/linux/audit.h
> index 9a4ecc9f6dc5..c0aace7384f3 100644
> --- a/include/uapi/linux/audit.h
> +++ b/include/uapi/linux/audit.h
> @@ -122,6 +122,7 @@
>  #define AUDIT_OPENAT2		1337	/* Record showing openat2 how args */
>  #define AUDIT_DM_CTRL		1338	/* Device Mapper target control */
>  #define AUDIT_DM_EVENT		1339	/* Device Mapper events */
> +#define AUDIT_VFIO		1340	/* VFIO events */
>  
>  #define AUDIT_AVC		1400	/* SE Linux avc denial or grant */
>  #define AUDIT_SELINUX_ERR	1401	/* Internal SE Linux Errors */
> -- 
> 2.34.1
> 

