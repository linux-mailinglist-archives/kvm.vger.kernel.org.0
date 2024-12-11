Return-Path: <kvm+bounces-33511-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 224E39ED775
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2024 21:47:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 07C46283B0C
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2024 20:47:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BB9E2288C2;
	Wed, 11 Dec 2024 20:47:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QHV2rwch"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 668DD2036F6;
	Wed, 11 Dec 2024 20:47:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733950031; cv=none; b=pqIUDbT5cl/INj/oofnuAA5QHbd4/eFLZHryhVB0D912N3vz2145R8WGbz+rqFet7JUTs2iFCZBx11mdaiMLyK8iSahdA1bYk+Px9LuuUt/+XOklHWP+5d7jaxTZW5Q/UV0AmY+pGO+EjQouBZYRQUSDHMN4goHWWEK9Z87zEWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733950031; c=relaxed/simple;
	bh=aknAFx8VaUwPVga7KKu4RUZNHyfZuQaVaB1D3qt7qZ4=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=ohjzOWKYRnDh+qpHVoOjxyriUiGulEFGNBKnmMOaK7eQz5PaGCY9Y9PN7blJ/Y9ocgRFF6wU/a2O3YRXtUQ1QbBipQK93xPvoXhpgPxLwaKvjbjLOM/rOTJXy+ECiGUMJcDhCv8jqB+CzFSlAow4iKR/PDEOgzyw2Enn0HFUP9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QHV2rwch; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C69C9C4CED2;
	Wed, 11 Dec 2024 20:47:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733950030;
	bh=aknAFx8VaUwPVga7KKu4RUZNHyfZuQaVaB1D3qt7qZ4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:From;
	b=QHV2rwch1gz59dvCZw7JoUC2YzoswfWi76w8T8rY/qqAxs688/XXJGJBv3TAGBpp5
	 yYDg7ahXE+Ejki3N83rRS6ysfCK9v4XlLwwJKhPfR5ZijS8wQz1PZivpNbKNKsjjVO
	 6TZ/b/cqGF6d++KC6QfNhZDi8Uf+GPB7+ztgmftdPXVN8grzfNMmcs0ahHNWYtPb1T
	 CEVOOHbJohTaHYVWKW3au0/ZZAj4WVzR4vfIPB7cOgTpuWJqlR6at7IDrEgPlyDyTV
	 Lfnn/lZNreZYil7ihPnRBzUtwkpcbUhqE+9g8PNO0JN9WCv5peVnziOvr8E8RZMVay
	 vTUKhHoSbndtg==
Date: Wed, 11 Dec 2024 14:47:09 -0600
From: Bjorn Helgaas <helgaas@kernel.org>
To: Jian-Hong Pan <jhp@endlessos.org>,
	Alex Williamson <alex.williamson@redhat.com>
Cc: Krzysztof =?utf-8?Q?Wilczy=C5=84ski?= <kw@linux.com>,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	Nirmal Patel <nirmal.patel@linux.intel.com>,
	linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux@endlessos.org,
	Ilpo =?utf-8?B?SsOkcnZpbmVu?= <ilpo.jarvinen@linux.intel.com>,
	"David E. Box" <david.e.box@linux.intel.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v13] PCI/ASPM: Make pci_save_aspm_l1ss_state save both
 child and parent's L1SS configuration
Message-ID: <20241211204709.GA3305716@bhelgaas>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20241115072200.37509-3-jhp@endlessos.org>

[+to Alex, +cc kvm]

On Fri, Nov 15, 2024 at 03:22:02PM +0800, Jian-Hong Pan wrote:
> PCI devices' parameters on the VMD bus have been programmed properly
> originally. But, cleared after pci_reset_bus() and have not been restored
> correctly. This leads the link's L1.2 between PCIe Root Port and child
> device gets wrong configs.

17423360a27a ("PCI/ASPM: Save L1 PM Substates Capability for
suspend/resume") appeared in v6.9 and added a bug in the save/restore
path: we save the device L1SS state, but restore both the device L1SS
state and the parent's L1SS state (when the parent state may be junk)
afterwards.

Jian-Hong sees this on VMD, which makes sense because vmd uses
pci_reset_bus() when enabling the VMD domain.

But this should be a problem for any device reset, so I added you,
Alex, in case you've seen this with the resets VFIO does?

We also save/restore for suspend, but I suppose we don't notice the
problem there because in that case we save state for *all* devices,
so the parent state should be valid when we restore.

> Here is a failed example on ASUS B1400CEAE with enabled VMD. Both PCIe
> bridge and NVMe device should have the same LTR1.2_Threshold value.
> However, they are configured as different values in this case:
> 
> 10000:e0:06.0 PCI bridge [0604]: Intel Corporation 11th Gen Core Processor PCIe Controller [8086:9a09] (rev 01) (prog-if 00 [Normal decode])
>   ...
>   Capabilities: [200 v1] L1 PM Substates
>     L1SubCtl1: PCI-PM_L1.2- PCI-PM_L1.1- ASPM_L1.2+ ASPM_L1.1-
>       T_CommonMode=0us LTR1.2_Threshold=0ns
>     L1SubCtl2: T_PwrOn=0us
> 
> 10000:e1:00.0 Non-Volatile memory controller [0108]: Sandisk Corp WD Blue SN550 NVMe SSD [15b7:5009] (rev 01) (prog-if 02 [NVM Express])
>   ...
>   Capabilities: [900 v1] L1 PM Substates
>     L1SubCtl1: PCI-PM_L1.2- PCI-PM_L1.1- ASPM_L1.2+ ASPM_L1.1-
>       T_CommonMode=0us LTR1.2_Threshold=101376ns
>     L1SubCtl2: T_PwrOn=50us

I think T_PwrOn should also be the same for both devices, FWIW.

In fact, I think L1SS should be configured identically for both ends
of the link, with the exceptions of Link Activation and
Common_Mode_Restore_Time, which are RsvdP for the Upstream Port.

> Here is VMD mapped PCI device tree:
> 
> -+-[0000:00]-+-00.0  Intel Corporation Device 9a04
>  | ...
>  \-[10000:e0]-+-06.0-[e1]----00.0  Sandisk Corp WD Blue SN550 NVMe SSD
>               \-17.0  Intel Corporation Tiger Lake-LP SATA Controller
> 
> When pci_reset_bus() resets the bus [e1] of the NVMe, it only saves and
> restores NVMe's state before and after reset. Then, when it restores the
> NVMe's state, ASPM code restores L1SS for both the parent bridge and the
> NVMe in pci_restore_aspm_l1ss_state(). The NVMe's L1SS is restored
> correctly. But, the parent bridge's L1SS is restored with a wrong value 0x0
> because the parent bridge's L1SS wasn't saved by pci_save_aspm_l1ss_state()
> before reset.
> 
> To avoid pci_restore_aspm_l1ss_state() restore wrong value to the parent's
> L1SS config like this example, make pci_save_aspm_l1ss_state() save the
> parent's L1SS config, if the PCI device has a parent.
> 
> Link: https://lore.kernel.org/linux-pci/CAPpJ_eexU0gCHMbXw_z924WxXw0+B6SdS4eG9oGpEX1wmnMLkQ@mail.gmail.com/
> Closes: https://bugzilla.kernel.org/show_bug.cgi?id=218394
> Fixes: 17423360a27a ("PCI/ASPM: Save L1 PM Substates Capability for suspend/resume")
> Suggested-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
> Signed-off-by: Jian-Hong Pan <jhp@endlessos.org>
> Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
> Reviewed-by: David E. Box <david.e.box@linux.intel.com>
> ---
> v9:
> - Drop the v8 fix about drivers/pci/pcie/aspm.c. Use this in VMD instead.
> 
> v10:
> - Drop the v9 fix about drivers/pci/controller/vmd.c
> - Fix in PCIe ASPM to make it symmetric between pci_save_aspm_l1ss_state()
>   and pci_restore_aspm_l1ss_state()
> 
> v11:
> - Introduce __pci_save_aspm_l1ss_state as a resusable helper function
>   which is same as the original pci_configure_aspm_l1ss
> - Make pci_save_aspm_l1ss_state invoke __pci_save_aspm_l1ss_state for
>   both child and parent devices
> - Smooth the commit message
> 
> v12:
> - Update the commit message
> 
> v13:
> - Tweak the commit message to make it more like a general fix
> - When pci_alloc_dev() prepares the pci_dev, it sets the pci_dev's bus.
>   So, let pci_save_aspm_l1ss_state() access pdev's bus directly.
> - Add comment in pci_save_aspm_l1ss_state() to describe why it does not
>   save both the PCIe device and the parent's L1SS config like
>   pci_restore_aspm_l1ss_state() directly.
> 
>  drivers/pci/pcie/aspm.c | 18 +++++++++++++++++-
>  1 file changed, 17 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/pci/pcie/aspm.c b/drivers/pci/pcie/aspm.c
> index 28567d457613..0bcd060aab32 100644
> --- a/drivers/pci/pcie/aspm.c
> +++ b/drivers/pci/pcie/aspm.c
> @@ -79,7 +79,7 @@ void pci_configure_aspm_l1ss(struct pci_dev *pdev)
>  			ERR_PTR(rc));
>  }
>  
> -void pci_save_aspm_l1ss_state(struct pci_dev *pdev)
> +static void __pci_save_aspm_l1ss_state(struct pci_dev *pdev)
>  {
>  	struct pci_cap_saved_state *save_state;
>  	u16 l1ss = pdev->l1ss;
> @@ -101,6 +101,22 @@ void pci_save_aspm_l1ss_state(struct pci_dev *pdev)
>  	pci_read_config_dword(pdev, l1ss + PCI_L1SS_CTL1, cap++);
>  }
>  
> +void pci_save_aspm_l1ss_state(struct pci_dev *pdev)
> +{
> +	struct pci_dev *parent = pdev->bus->self;
> +
> +	__pci_save_aspm_l1ss_state(pdev);
> +
> +	/*
> +	 * Save parent's L1 substate configuration, if the parent has not saved
> +	 * state. It avoids pci_restore_aspm_l1ss_state() restore wrong value to
> +	 * parent's L1 substate configuration. However, the parent might be
> +	 * nothing, if pdev is a PCI bridge.
> +	 */
> +	if (parent && !parent->state_saved)
> +		__pci_save_aspm_l1ss_state(parent);
> +}
> +
>  void pci_restore_aspm_l1ss_state(struct pci_dev *pdev)
>  {
>  	struct pci_cap_saved_state *pl_save_state, *cl_save_state;
> -- 
> 2.47.0
> 

