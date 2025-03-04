Return-Path: <kvm+bounces-40095-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 80617A4F1AB
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 00:41:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CB9DF3A63F7
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 23:40:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D54AC27700D;
	Tue,  4 Mar 2025 23:40:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RVpfvPqS"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F206D1EBA1C;
	Tue,  4 Mar 2025 23:40:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741131653; cv=none; b=elphyMH5zji2BdBYohZuMpRkmB5vDCpOGldSsGeJvco9iab+vneVlNQns63FTKhSGg8cJOFQaU3cMzSjtPN1fT+/u/nvdBD8TWfhTowtyqOBEg64TiHqoSkA1v8ERqC/34cCgJCmLy9k5jBei6B5tlNP6KpHsXyZbvhNK+Ympo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741131653; c=relaxed/simple;
	bh=cxLfUqLkhwKVUt3Tqn/g8gs/5ZZ0Yq3hQzO2yTAaSmw=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=hf/X5L2F+ErU4USMnMwriD9PT6XgU2JoNSdrt2OnH0PQVoNcfn8eLzOzJEpp75kSMMX2ZHk6LQeM0l909jMzonE/EY8zP4zIda6Jd79uwzub7rvWVe3fuSs/RPDkmYqnseJCzijQOFPTr1HWzLekZh+7a+nzbzL5HrTAhy2DSBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RVpfvPqS; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3305BC4CEE5;
	Tue,  4 Mar 2025 23:40:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741131652;
	bh=cxLfUqLkhwKVUt3Tqn/g8gs/5ZZ0Yq3hQzO2yTAaSmw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:From;
	b=RVpfvPqSBf5hnaE72AMOGKHXeBeG1G1Rh+1hVECFXa3TWZ7Js8+191d5iSw1gK8j5
	 9gXaR8MvjXlambzJY1lQM7oPb58SiJJiOGZ3KuaHKItCci20C23GhPhIwsNFpM6k/n
	 yJAoCBeq9r73+UDgtYXu3LDGHgUNhgmnFrY2Z1P6Yz4+1guX8S925V4ntxpwFzTZnd
	 eZAVecZaTqE78uW+TYURDRfkObpI9uoQ5nxrghvsPCGgdVCzvmR40mldxflGKhyRRu
	 Tx4LP6pHNxCisO5pKYl3U7mkCgVIP4dO9wnnfLQCOcgsrMzam7m1W64axTlX14WMNi
	 NxDT+zxwvSA4w==
Date: Tue, 4 Mar 2025 17:40:50 -0600
From: Bjorn Helgaas <helgaas@kernel.org>
To: Nishanth Aravamudan <naravamudan@nvidia.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Raphael Norwitz <raphael.norwitz@nutanix.com>,
	Amey Narkhede <ameynarkhede03@gmail.com>, linux-pci@vger.kernel.org,
	linux-kernel@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v3] PCI: account for sysfs-disabled reset in
 pci_{slot,bus}_resettable()
Message-ID: <20250304234050.GA265524@bhelgaas>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250207205600.1846178-1-naravamudan@nvidia.com>

On Fri, Feb 07, 2025 at 02:56:00PM -0600, Nishanth Aravamudan wrote:
> Commit d88f521da3ef ("PCI: Allow userspace to query and set
> device reset mechanism") added support for userspace to disable reset of
> specific PCI devices (by echo'ing "" into reset_method) and
> pci_{slot,bus}_resettable() methods do not check pci_reset_supported()
> to see if userspace has disabled reset.
> 
> __pci_reset_bus()
> 	-> pci_bus_reset(..., PCI_RESET_PROBE)
> 		-> pci_bus_resettable()
> 
> __pci_reset_slot()
> 	-> pci_slot_reset(..., PCI_RESET_PROBE)
> 		-> pci_slot_resettable()
> 
> pci_reset_bus()
> 	-> pci_probe_reset_slot()
> 		-> pci_slot_reset(..., PCI_RESET_PROBE)
> 			-> pci_bus_resettable()
> 	if true:
> 		__pci_reset_slot()
> 	else:
> 		__pci_reset_bus()
> 
> I was able to reproduce this issue with a vfio device passed to a qemu
> guest, where I had disabled PCI reset via sysfs. Both
> vfio_pci_ioctl_get_pci_hot_reset_info() and
> vfio_pci_ioctl_pci_hot_reset() check if either the vdev's slot or bus is
> not resettable by calling pci_probe_reset_slot(). Before my change, this
> ends up ignoring the sysfs file contents and vfio-pci happily ends up
> issuing a reset to that device.
> 
> Add an explicit check of pci_reset_supported() in both
> pci_slot_resettable() and pci_bus_resettable() to ensure both the reset
> status and reset execution are both bypassed if an administrator
> disables it for a device.
> 
> Fixes: d88f521da3ef ("PCI: Allow userspace to query and set device reset mechanism")
> Signed-off-by: Nishanth Aravamudan <naravamudan@nvidia.com>
> Cc: Bjorn Helgaas <bhelgaas@google.com>
> Cc: Alex Williamson <alex.williamson@redhat.com>
> Cc: Raphael Norwitz <raphael.norwitz@nutanix.com>
> Cc: Amey Narkhede <ameynarkhede03@gmail.com>
> Cc: linux-pci@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: Jason Gunthorpe <jgg@nvidia.com>
> Cc: Yishai Hadas <yishaih@nvidia.com>
> Cc: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> Cc: Kevin Tian <kevin.tian@intel.com>
> Cc: kvm@vger.kernel.org

Applied to pci/reset for v6.15, thanks!

> ---
> 
> Changes since v2:
>  - update commit message to include more details
> 
> Changes since v1:
>  - fix capitalization and ()s
>  - clarify same checks are done in reset path
> 
>  drivers/pci/pci.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> index 869d204a70a3..738d29375ad3 100644
> --- a/drivers/pci/pci.c
> +++ b/drivers/pci/pci.c
> @@ -5405,6 +5405,8 @@ static bool pci_bus_resettable(struct pci_bus *bus)
>  		return false;
>  
>  	list_for_each_entry(dev, &bus->devices, bus_list) {
> +		if (!pci_reset_supported(dev))
> +			return false;
>  		if (dev->dev_flags & PCI_DEV_FLAGS_NO_BUS_RESET ||
>  		    (dev->subordinate && !pci_bus_resettable(dev->subordinate)))
>  			return false;
> @@ -5481,6 +5483,8 @@ static bool pci_slot_resettable(struct pci_slot *slot)
>  	list_for_each_entry(dev, &slot->bus->devices, bus_list) {
>  		if (!dev->slot || dev->slot != slot)
>  			continue;
> +		if (!pci_reset_supported(dev))
> +			return false;
>  		if (dev->dev_flags & PCI_DEV_FLAGS_NO_BUS_RESET ||
>  		    (dev->subordinate && !pci_bus_resettable(dev->subordinate)))
>  			return false;
> -- 
> 2.34.1
> 

