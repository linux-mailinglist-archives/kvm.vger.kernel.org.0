Return-Path: <kvm+bounces-57149-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D543AB5085B
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 23:44:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DB9D51C240C4
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 21:44:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9EEE825DCF0;
	Tue,  9 Sep 2025 21:43:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fmwieSAP"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7C00253951;
	Tue,  9 Sep 2025 21:43:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757454232; cv=none; b=rt5jNixJsG80xnGdTzpZc7PtBmnPZA1VmdGsknQTEM2rNF4C9L+JDz5BqjgpA76jtyWjXk0JXCK3au+ETZV7wVwLnIVbokXXvpuLjfY5Of6Zp3qxS6ebbSsiBCmTEXfJToRFUdwLRnQ/H4x4ONFPJoVLniOLysXjHB4nd5821RA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757454232; c=relaxed/simple;
	bh=EHmfTFLkid85VbCuO6PiomNVaM5EIInYfn27UtWfSNg=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=G/xQFGqC5plJYh0/Sb+bMp96iNTRjwKQCNQLM3lYydqXARmeQkEMyT9u94cAtVUNEyGki9+OZegWJCzLmMofHvl/0WcL/k47rhy9le12J6oYBibfLvZyzotq5a8FIxsc68CanGS1mB+7eD9uU4YatZlWR9GDrKVwnuQ+jBuf9D8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fmwieSAP; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20693C4CEF4;
	Tue,  9 Sep 2025 21:43:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757454232;
	bh=EHmfTFLkid85VbCuO6PiomNVaM5EIInYfn27UtWfSNg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:From;
	b=fmwieSAPc/rcjk2TW4uX2xHGpIGLhwWJ3b8DPUlSwF+BJtT9ddtcweujqd4/VnG/3
	 ZH9WLTsNOhZeiHtd1d9omq2BUj0yrbj7zMpyRmBURlwwZOJZ4HHhBSPp8FeMFFVNSG
	 k8J3voT7swpsF1K5wMkc++mRB3Go4sOnYxn796kCbgSBkALEAv38sOu3G0/YNVKlh7
	 0JNSQKWDfYpCFeC4V6VRPNtQQn3F2EYQZxbneJRN72bL0uyQ81PlgfV6pCnC34DWt4
	 XoAGeBKOzAv07Ol12LTVNC9HjtL8T3jh3BpDDQeAOI9A3IJoydbaVi1evLvpH53et3
	 a170xIOe84+1Q==
Date: Tue, 9 Sep 2025 16:43:50 -0500
From: Bjorn Helgaas <helgaas@kernel.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>, linux-pci@vger.kernel.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Donald Dutile <ddutile@redhat.com>, galshalom@nvidia.com,
	Joerg Roedel <jroedel@suse.de>, Kevin Tian <kevin.tian@intel.com>,
	kvm@vger.kernel.org, maorg@nvidia.com, patches@lists.linux.dev,
	tdave@nvidia.com, Tony Zhu <tony.zhu@intel.com>
Subject: Re: [PATCH v3 10/11] PCI: Check ACS DSP/USP redirect bits in
 pci_enable_pasid()
Message-ID: <20250909214350.GA1509037@bhelgaas>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <10-v3-8827cc7fc4e0+23f-pcie_switch_groups_jgg@nvidia.com>

On Fri, Sep 05, 2025 at 03:06:25PM -0300, Jason Gunthorpe wrote:
> Switches ignore the PASID when routing TLPs. This means the path from the
> PASID issuing end point to the IOMMU must be direct with no possibility
> for another device to claim the addresses.
> 
> This is done using ACS flags and pci_enable_pasid() checks for this.
> 
> The new ACS Enhanced bits clarify some undefined behaviors in the spec
> around what P2P Request Redirect means.
> 
> Linux has long assumed that PCI_ACS_RR implies PCI_ACS_DSP_MT_RR |
> PCI_ACS_USP_MT_RR | PCI_ACS_UNCLAIMED_RR.
> 
> If the device supports ACS Enhanced then use the information it reports to
> determine if PASID SVA is supported or not.
> 
>  PCI_ACS_DSP_MT_RR: Prevents Downstream Port BAR's from claiming upstream
>                     flowing transactions
> 
>  PCI_ACS_USP_MT_RR: Prevents Upstream Port BAR's from claiming upstream
>                     flowing transactions

s/BAR's/BARs/ (no possession here)

>  PCI_ACS_UNCLAIMED_RR: Prevents a hole in the USP bridge window compared
>                        to all the DSP bridge windows from generating a
>                        error.
> 
> Each of these cases would poke a hole in the PASID address space which is
> not permitted.
> 
> Enhance the comments around pci_acs_flags_enabled() to better explain the
> reasoning for its logic. Continue to take the approach of assuming the
> device is doing the "right ACS" if it does not explicitly declare
> otherwise.
> 
> Fixes: 201007ef707a ("PCI: Enable PASID only when ACS RR & UF enabled on upstream path")
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/pci/ats.c |  4 +++-
>  drivers/pci/pci.c | 54 +++++++++++++++++++++++++++++++++++++++++------
>  2 files changed, 50 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/pci/ats.c b/drivers/pci/ats.c
> index ec6c8dbdc5e9c9..00603c2c4ff0ea 100644
> --- a/drivers/pci/ats.c
> +++ b/drivers/pci/ats.c
> @@ -416,7 +416,9 @@ int pci_enable_pasid(struct pci_dev *pdev, int features)
>  	if (!pasid)
>  		return -EINVAL;
>  
> -	if (!pci_acs_path_enabled(pdev, NULL, PCI_ACS_RR | PCI_ACS_UF))
> +	if (!pci_acs_path_enabled(pdev, NULL,
> +				  PCI_ACS_RR | PCI_ACS_UF | PCI_ACS_USP_MT_RR |
> +				  PCI_ACS_DSP_MT_RR | PCI_ACS_UNCLAIMED_RR))
>  		return -EINVAL;
>  
>  	pci_read_config_word(pdev, pasid + PCI_PASID_CAP, &supported);
> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> index 983f71211f0055..620b7f79093854 100644
> --- a/drivers/pci/pci.c
> +++ b/drivers/pci/pci.c
> @@ -3606,6 +3606,52 @@ void pci_configure_ari(struct pci_dev *dev)
>  	}
>  }
>  
> +
> +/*
> + * The spec is not clear what it means if the capability bit is 0. One view is
> + * that the device acts as though the ctrl bit is zero, another view is the
> + * device behavior is undefined.
> + *
> + * Historically Linux has taken the position that the capability bit as 0 means
> + * the device supports the most favorable interpretation of the spec - ie that
> + * things like P2P RR are always on. As this is security sensitive we expect
> + * devices that do not follow this rule to be quirked.

Interpreting a 0 Capability bit, i.e., per spec "the component does
not implement the feature", as "the component behaves as though the
feature is always enabled" sounds like a stretch to me.

The point of ACS is to prevent things that are normally allowed, so if
a component doesn't implement an ACS feature, my first guess would be
that the component doesn't prevent the relevant behavior.

Sounds like a mess and might be worth an ECR to clarify the spec.

"Most favorable interpretation of the spec" feels a little ambiguous
to me since it assumes something about what we consider "favorable".

> + * ACS Enhanced eliminated undefined areas of the spec around MMIO in root ports
> + * and switch ports. If those ports have no MMIO then it is not relavent.
> + * PCI_ACS_UNCLAIMED_RR eliminates the undefined area around an upstream switch
> + * window that is not fully decoded by the downstream windows.

s/relavent/relevant/

> + * This takes the same approach with ACS Enhanced, if the device does not
> + * support it then we assume the ACS P2P RR has all the enhanced behaviors too.
> + *
> + * Due to ACS Enhanced bits being force set to 0 by older Linux kernels, and
> + * those values would break old kernels on the edge cases they cover, the only
> + * compatible thing for a new device to implement is ACS Enhanced supported with
> + * the control bits (except PCI_ACS_IORB) wired to follow ACS_RR.
> + */
> +static u16 pci_acs_ctrl_mask(struct pci_dev *pdev, u16 hw_cap)
> +{
> +	/*
> +	 * Egress Control enables use of the Egress Control Vector which is not
> +	 * present without the cap.
> +	 */
> +	u16 mask = PCI_ACS_EC;
> +
> +	mask = hw_cap & (PCI_ACS_SV | PCI_ACS_TB | PCI_ACS_RR |
> +				      PCI_ACS_CR | PCI_ACS_UF | PCI_ACS_DT);
> +
> +	/*
> +	 * If ACS Enhanced is supported the device reports what it is doing
> +	 * through these bits which may not be settable.
> +	 */
> +	if (hw_cap & PCI_ACS_ENHANCED)
> +		mask |= PCI_ACS_IORB | PCI_ACS_DSP_MT_RB | PCI_ACS_DSP_MT_RR |
> +			PCI_ACS_USP_MT_RB | PCI_ACS_USP_MT_RR |
> +			PCI_ACS_UNCLAIMED_RR;
> +	return mask;
> +}
> +
>  static bool pci_acs_flags_enabled(struct pci_dev *pdev, u16 acs_flags)
>  {
>  	int pos;
> @@ -3615,15 +3661,9 @@ static bool pci_acs_flags_enabled(struct pci_dev *pdev, u16 acs_flags)
>  	if (!pos)
>  		return false;
>  
> -	/*
> -	 * Except for egress control, capabilities are either required
> -	 * or only required if controllable.  Features missing from the
> -	 * capability field can therefore be assumed as hard-wired enabled.
> -	 */
>  	pci_read_config_word(pdev, pos + PCI_ACS_CAP, &cap);
> -	acs_flags &= (cap | PCI_ACS_EC);
> -
>  	pci_read_config_word(pdev, pos + PCI_ACS_CTRL, &ctrl);
> +	acs_flags &= pci_acs_ctrl_mask(pdev, cap);
>  	return (ctrl & acs_flags) == acs_flags;
>  }
>  
> -- 
> 2.43.0
> 

