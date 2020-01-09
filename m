Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E037E136374
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2020 23:50:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729000AbgAIWse (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jan 2020 17:48:34 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:42164 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728783AbgAIWse (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Jan 2020 17:48:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578610113;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xkcV4WuNVmEEXZYjZzhPqU+nZBHOvLSeRuwZyqbKBLk=;
        b=GqYsiEEjiV492sT/ydNozXzA2leqrAEw4wwoHNQfYZu+KyJlMG4y+GlA3pL+ImTM+4ycNd
        CKmvKVuBPAGthr6q4Q4cWIJobzO8GFIHji8EE58QRA18oN6zwFmtc1r2Kc+uGg++z0omlm
        1ym5IorhAhSaVmxT9PGg9DFgst4v93c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-436-Si8wLbbfM4yHGSHXyGIu1w-1; Thu, 09 Jan 2020 17:48:31 -0500
X-MC-Unique: Si8wLbbfM4yHGSHXyGIu1w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 45C00800D48;
        Thu,  9 Jan 2020 22:48:30 +0000 (UTC)
Received: from w520.home (ovpn-116-128.phx2.redhat.com [10.3.116.128])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4CA0D8061B;
        Thu,  9 Jan 2020 22:48:27 +0000 (UTC)
Date:   Thu, 9 Jan 2020 15:48:26 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Liu Yi L <yi.l.liu@intel.com>
Cc:     kwankhede@nvidia.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kevin.tian@intel.com, joro@8bytes.org,
        peterx@redhat.com, baolu.lu@linux.intel.com
Subject: Re: [PATCH v4 07/12] vfio_pci: shrink vfio_pci.c
Message-ID: <20200109154826.7a818be8@w520.home>
In-Reply-To: <1578398509-26453-8-git-send-email-yi.l.liu@intel.com>
References: <1578398509-26453-1-git-send-email-yi.l.liu@intel.com>
        <1578398509-26453-8-git-send-email-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue,  7 Jan 2020 20:01:44 +0800
Liu Yi L <yi.l.liu@intel.com> wrote:

> This patch removes the common codes in vfio_pci.c, leave the module
> specific codes, new vfio_pci.c will leverage the common functions
> implemented in vfio_pci_common.c.
> 
> Cc: Kevin Tian <kevin.tian@intel.com>
> Cc: Lu Baolu <baolu.lu@linux.intel.com>
> Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> ---
>  drivers/vfio/pci/Makefile           |    3 +-
>  drivers/vfio/pci/vfio_pci.c         | 1442 -----------------------------------
>  drivers/vfio/pci/vfio_pci_common.c  |    2 +-
>  drivers/vfio/pci/vfio_pci_private.h |    2 +
>  4 files changed, 5 insertions(+), 1444 deletions(-)
> 
> diff --git a/drivers/vfio/pci/Makefile b/drivers/vfio/pci/Makefile
> index f027f8a..d94317a 100644
> --- a/drivers/vfio/pci/Makefile
> +++ b/drivers/vfio/pci/Makefile
> @@ -1,6 +1,7 @@
>  # SPDX-License-Identifier: GPL-2.0-only
>  
> -vfio-pci-y := vfio_pci.o vfio_pci_intrs.o vfio_pci_rdwr.o vfio_pci_config.o
> +vfio-pci-y := vfio_pci.o vfio_pci_common.o vfio_pci_intrs.o \
> +		vfio_pci_rdwr.o vfio_pci_config.o
>  vfio-pci-$(CONFIG_VFIO_PCI_IGD) += vfio_pci_igd.o
>  vfio-pci-$(CONFIG_VFIO_PCI_NVLINK2) += vfio_pci_nvlink2.o
>  
> diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
> index 103e493..7e24da2 100644
> --- a/drivers/vfio/pci/vfio_pci.c
> +++ b/drivers/vfio/pci/vfio_pci.c

I think there are a bunch of headers that are no longer needed here
too.  It at least compiles without these:

-#include <linux/eventfd.h>
-#include <linux/file.h>
-#include <linux/interrupt.h>
-#include <linux/notifier.h>
-#include <linux/pm_runtime.h>
-#include <linux/uaccess.h>
-#include <linux/nospec.h>


> @@ -54,411 +54,6 @@ module_param(disable_idle_d3, bool, S_IRUGO | S_IWUSR);
>  MODULE_PARM_DESC(disable_idle_d3,
>  		 "Disable using the PCI D3 low power state for idle, unused devices");
>  
> -/*
> - * Our VGA arbiter participation is limited since we don't know anything
> - * about the device itself.  However, if the device is the only VGA device
> - * downstream of a bridge and VFIO VGA support is disabled, then we can
> - * safely return legacy VGA IO and memory as not decoded since the user
> - * has no way to get to it and routing can be disabled externally at the
> - * bridge.
> - */
> -unsigned int vfio_pci_set_vga_decode(void *opaque, bool single_vga)
> -{
> -	struct vfio_pci_device *vdev = opaque;
> -	struct pci_dev *tmp = NULL, *pdev = vdev->pdev;
> -	unsigned char max_busnr;
> -	unsigned int decodes;
> -
> -	if (single_vga || !vfio_vga_disabled(vdev) ||
> -		pci_is_root_bus(pdev->bus))
> -		return VGA_RSRC_NORMAL_IO | VGA_RSRC_NORMAL_MEM |
> -		       VGA_RSRC_LEGACY_IO | VGA_RSRC_LEGACY_MEM;
> -
> -	max_busnr = pci_bus_max_busnr(pdev->bus);
> -	decodes = VGA_RSRC_NORMAL_IO | VGA_RSRC_NORMAL_MEM;
> -
> -	while ((tmp = pci_get_class(PCI_CLASS_DISPLAY_VGA << 8, tmp)) != NULL) {
> -		if (tmp == pdev ||
> -		    pci_domain_nr(tmp->bus) != pci_domain_nr(pdev->bus) ||
> -		    pci_is_root_bus(tmp->bus))
> -			continue;
> -
> -		if (tmp->bus->number >= pdev->bus->number &&
> -		    tmp->bus->number <= max_busnr) {
> -			pci_dev_put(tmp);
> -			decodes |= VGA_RSRC_LEGACY_IO | VGA_RSRC_LEGACY_MEM;
> -			break;
> -		}
> -	}
> -
> -	return decodes;
> -}
> -
> -static void vfio_pci_probe_mmaps(struct vfio_pci_device *vdev)
> -{
> -	struct resource *res;
> -	int i;
> -	struct vfio_pci_dummy_resource *dummy_res;
> -
> -	INIT_LIST_HEAD(&vdev->dummy_resources_list);
> -
> -	for (i = 0; i < PCI_STD_NUM_BARS; i++) {
> -		int bar = i + PCI_STD_RESOURCES;
> -
> -		res = &vdev->pdev->resource[bar];
> -
> -		if (!IS_ENABLED(CONFIG_VFIO_PCI_MMAP))
> -			goto no_mmap;
> -
> -		if (!(res->flags & IORESOURCE_MEM))
> -			goto no_mmap;
> -
> -		/*
> -		 * The PCI core shouldn't set up a resource with a
> -		 * type but zero size. But there may be bugs that
> -		 * cause us to do that.
> -		 */
> -		if (!resource_size(res))
> -			goto no_mmap;
> -
> -		if (resource_size(res) >= PAGE_SIZE) {
> -			vdev->bar_mmap_supported[bar] = true;
> -			continue;
> -		}
> -
> -		if (!(res->start & ~PAGE_MASK)) {
> -			/*
> -			 * Add a dummy resource to reserve the remainder
> -			 * of the exclusive page in case that hot-add
> -			 * device's bar is assigned into it.
> -			 */
> -			dummy_res = kzalloc(sizeof(*dummy_res), GFP_KERNEL);
> -			if (dummy_res == NULL)
> -				goto no_mmap;
> -
> -			dummy_res->resource.name = "vfio sub-page reserved";
> -			dummy_res->resource.start = res->end + 1;
> -			dummy_res->resource.end = res->start + PAGE_SIZE - 1;
> -			dummy_res->resource.flags = res->flags;
> -			if (request_resource(res->parent,
> -						&dummy_res->resource)) {
> -				kfree(dummy_res);
> -				goto no_mmap;
> -			}
> -			dummy_res->index = bar;
> -			list_add(&dummy_res->res_next,
> -					&vdev->dummy_resources_list);
> -			vdev->bar_mmap_supported[bar] = true;
> -			continue;
> -		}
> -		/*
> -		 * Here we don't handle the case when the BAR is not page
> -		 * aligned because we can't expect the BAR will be
> -		 * assigned into the same location in a page in guest
> -		 * when we passthrough the BAR. And it's hard to access
> -		 * this BAR in userspace because we have no way to get
> -		 * the BAR's location in a page.
> -		 */
> -no_mmap:
> -		vdev->bar_mmap_supported[bar] = false;
> -	}
> -}
> -
> -static void vfio_pci_try_bus_reset(struct vfio_pci_device *vdev);
> -
> -/*
> - * INTx masking requires the ability to disable INTx signaling via PCI_COMMAND
> - * _and_ the ability detect when the device is asserting INTx via PCI_STATUS.
> - * If a device implements the former but not the latter we would typically
> - * expect broken_intx_masking be set and require an exclusive interrupt.
> - * However since we do have control of the device's ability to assert INTx,
> - * we can instead pretend that the device does not implement INTx, virtualizing
> - * the pin register to report zero and maintaining DisINTx set on the host.
> - */
> -static bool vfio_pci_nointx(struct pci_dev *pdev)
> -{
> -	switch (pdev->vendor) {
> -	case PCI_VENDOR_ID_INTEL:
> -		switch (pdev->device) {
> -		/* All i40e (XL710/X710/XXV710) 10/20/25/40GbE NICs */
> -		case 0x1572:
> -		case 0x1574:
> -		case 0x1580 ... 0x1581:
> -		case 0x1583 ... 0x158b:
> -		case 0x37d0 ... 0x37d2:
> -			return true;
> -		default:
> -			return false;
> -		}
> -	}
> -
> -	return false;
> -}
> -
> -void vfio_pci_probe_power_state(struct vfio_pci_device *vdev)
> -{
> -	struct pci_dev *pdev = vdev->pdev;
> -	u16 pmcsr;
> -
> -	if (!pdev->pm_cap)
> -		return;
> -
> -	pci_read_config_word(pdev, pdev->pm_cap + PCI_PM_CTRL, &pmcsr);
> -
> -	vdev->needs_pm_restore = !(pmcsr & PCI_PM_CTRL_NO_SOFT_RESET);
> -}
> -
> -/*
> - * pci_set_power_state() wrapper handling devices which perform a soft reset on
> - * D3->D0 transition.  Save state prior to D0/1/2->D3, stash it on the vdev,
> - * restore when returned to D0.  Saved separately from pci_saved_state for use
> - * by PM capability emulation and separately from pci_dev internal saved state
> - * to avoid it being overwritten and consumed around other resets.
> - */
> -int vfio_pci_set_power_state(struct vfio_pci_device *vdev, pci_power_t state)
> -{
> -	struct pci_dev *pdev = vdev->pdev;
> -	bool needs_restore = false, needs_save = false;
> -	int ret;
> -
> -	if (vdev->needs_pm_restore) {
> -		if (pdev->current_state < PCI_D3hot && state >= PCI_D3hot) {
> -			pci_save_state(pdev);
> -			needs_save = true;
> -		}
> -
> -		if (pdev->current_state >= PCI_D3hot && state <= PCI_D0)
> -			needs_restore = true;
> -	}
> -
> -	ret = pci_set_power_state(pdev, state);
> -
> -	if (!ret) {
> -		/* D3 might be unsupported via quirk, skip unless in D3 */
> -		if (needs_save && pdev->current_state >= PCI_D3hot) {
> -			vdev->pm_save = pci_store_saved_state(pdev);
> -		} else if (needs_restore) {
> -			pci_load_and_free_saved_state(pdev, &vdev->pm_save);
> -			pci_restore_state(pdev);
> -		}
> -	}


This gets a bit ugly, vfio_pci_remove() retains:

kfree(vdev->pm_save)

But vfio_pci.c otherwise has no use of this field on the
vfio_pci_device.  I'm afraid we're really just doing a pretty rough
splitting of the code rather than massaging the callbacks between the
modules into an actual API, for example maybe there should be init and
exit callbacks into the common code to handle such things.
ioeventfds_{list,lock} are similar, vfio_pci.c inits and destroys them,
but otherwise doesn't know what they're for.  I wonder how many more
such things exist.  Thanks,

Alex

