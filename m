Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6453B2D65CE
	for <lists+kvm@lfdr.de>; Thu, 10 Dec 2020 20:03:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393279AbgLJS6Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Dec 2020 13:58:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:35000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393133AbgLJS6V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Dec 2020 13:58:21 -0500
Date:   Thu, 10 Dec 2020 12:57:38 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607626660;
        bh=bY6QyKta2HG7QnuulXpGmzijvxYT716CvFeUnK73lGE=;
        h=From:To:Cc:Subject:In-Reply-To:From;
        b=IRfRt9Rbs6p8tsMig0XCBR+5RMuUFTJpQU/itpNPQJss029/xNV2PTcALOb5np5XG
         zcwl8b5UN0AUTNvZygu3PLrHWaXKFWeOs7GdyJr2xkvsb77dJM4GnzvA0zI10a+7sz
         YEN8hqBWTGLsO2U/FwvhArfhtHNUeHgAE/uTNYBTmG5kQYSi2cD6IB4rR3dZq9zF2R
         B+xe6OO9OSACmhBZ3rx37KSKvkrxQ1RXCC32KPiB3NDzHpxF9DUMqA0eI1L3zrB4Xn
         bi5h/XhwxflLmu1WGNb1+frIySTwiFfSF/+4qiFHfGnATz+gpiUYgxjmUL58Cm+qEv
         x+c3Er225XIQQ==
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Lu Baolu <baolu.lu@linux.intel.com>
Cc:     tglx@linutronix.de, ashok.raj@intel.com, kevin.tian@intel.com,
        dave.jiang@intel.com, megha.dey@intel.com,
        alex.williamson@redhat.com, bhelgaas@google.com,
        dan.j.williams@intel.com, dmaengine@vger.kernel.org,
        eric.auger@redhat.com, jacob.jun.pan@intel.com, jgg@mellanox.com,
        jing.lin@intel.com, kvm@vger.kernel.org, kwankhede@nvidia.com,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        maz@kernel.org, mona.hossain@intel.com, netanelg@mellanox.com,
        parav@mellanox.com, pbonzini@redhat.com, rafael@kernel.org,
        samuel.ortiz@intel.com, sanjay.k.kumar@intel.com,
        shahafs@mellanox.com, tony.luck@intel.com, vkoul@kernel.org,
        yan.y.zhao@linux.intel.com, yi.l.liu@intel.com
Subject: Re: [RFC PATCH 1/1] platform-msi: Add platform check for subdevice
 irq domain
Message-ID: <20201210185738.GA49060@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201210004624.345282-1-baolu.lu@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 10, 2020 at 08:46:24AM +0800, Lu Baolu wrote:
> The pci_subdevice_msi_create_irq_domain() should fail if the underlying
> platform is not able to support IMS (Interrupt Message Storage). Otherwise,
> the isolation of interrupt is not guaranteed.
> 
> For x86, IMS is only supported on bare metal for now. We could enable it
> in the virtualization environments in the future if interrupt HYPERCALL
> domain is supported or the hardware has the capability of interrupt
> isolation for subdevices.

> + * We want to figure out which context we are running in. But the hardware
> + * does not introduce a reliable way (instruction, CPUID leaf, MSR, whatever)
> + * which can be manipulated by the VMM to let the OS figure out where it runs.
> + * So we go with the below probably_on_bare_metal() function as a replacement
> + * for definitely_on_bare_metal() to go forward only for the very simple reason
> + * that this is the only option we have.
> + */
> +static const char * const possible_vmm_vendor_name[] = {
> +	"QEMU", "Bochs", "KVM", "Xen", "VMware", "VMW", "VMware Inc.",
> +	"innotek GmbH", "Oracle Corporation", "Parallels", "BHYVE",
> +	"Microsoft Corporation"
> +};
> +
> +static bool probably_on_bare_metal(void)

What is the point of a function called probably_on_bare_metal()?
*Probably*?  The caller can't really do anything with the fact that
we're not 100% sure this gives the correct answer.  Just call it
"on_bare_metal()" or something and accept the fact that it might be
wrong sometimes.

This patch goes with IMS support, which somebody else is handling, so
I assume you don't need anything from the PCI side.
