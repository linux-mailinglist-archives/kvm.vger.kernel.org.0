Return-Path: <kvm+bounces-7978-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F2CB8495D5
	for <lists+kvm@lfdr.de>; Mon,  5 Feb 2024 10:04:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 131EC1F2102D
	for <lists+kvm@lfdr.de>; Mon,  5 Feb 2024 09:04:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42413125AD;
	Mon,  5 Feb 2024 09:04:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="czEBrsje"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60549125A2;
	Mon,  5 Feb 2024 09:04:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707123882; cv=none; b=hxSrr/MLsV3bJSQMqEYiMjymycZiQY2HmaMEvLu3oZV5Xo2OzWylgysaC6joFsHdNhFjhaJGfJrqI2TdDUvr0tJIkFJtnBybykJInYmk5P8eD7D7U5xxAsPibVd8v5D8I18/CrO2Ldq6ObameXYKXMiXPoNsqG7T3+KsV4l83cc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707123882; c=relaxed/simple;
	bh=AhFj+NbhJQwl2gOMvK1IeIBD9Vy34Q37EALd4FbPXJk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=czC2Ms1vKQcF+Es6PSEH+TQn3ZJaTTjZZKLNRfUPv/S8QwSCpDEYrZGDvUM+xhIO7P1iisd+46tT3NIjpzqjX6bLFpuBjXcQw1Ap7qiGOK+Q72AoiOTHQ/6DAmoTYRtxGAdfnoYPqoW1h2fQ4YleS2jLo56dMqgRNk+9H0KAMzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=czEBrsje; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6031BC433F1;
	Mon,  5 Feb 2024 09:04:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707123881;
	bh=AhFj+NbhJQwl2gOMvK1IeIBD9Vy34Q37EALd4FbPXJk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=czEBrsjeKGMW31f8hsl7TK7tUIKfkCMjT57iKlDVxItWbHLufwLm9dBf9artG6Hno
	 i64gtHIzofmmhuKOOa32qT2yheWObI5k1KFIE/NAjjeleAwBq1ip4QLaaUub5PCXlQ
	 YD4XZrOVn4+2bXFGKXrHxzroLJg2VdFqSwfCrKvOK7kAcT6szuk9IC6ajGO/lBNuWC
	 lXxHPV+589M5W748Mav5HTCQHBQ8ZzcKBGTyXkIElJiiuHSRl6H+XN5gfwV2yuVFl2
	 ew2Z6CRZ7LWvLxdUxywfL7DE7boEqN/it5+g1V091t7jKUJkGYWAVRR62zkg42dzOY
	 p4TIK2W/+wvKQ==
Date: Mon, 5 Feb 2024 11:04:38 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Emily Deng <Emily.Deng@amd.com>
Cc: bhelgaas@google.com, alex.williamson@redhat.com,
	linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, Jerry.Jiang@amd.com, Andy.Zhang@amd.com,
	HaiJun.Chang@amd.com, Monk.Liu@amd.com, Horace.Chen@amd.com,
	ZhenGuo.Yin@amd.com
Subject: Re: [PATCH 1/2] PCI: Add VF reset notification to PF's VFIO user
 mode driver
Message-ID: <20240205090438.GB6294@unreal>
References: <20240205071538.2665628-1-Emily.Deng@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240205071538.2665628-1-Emily.Deng@amd.com>

On Mon, Feb 05, 2024 at 03:15:37PM +0800, Emily Deng wrote:
> VF doesn't have the ability to reset itself completely which will cause the
> hardware in unstable state. So notify PF driver when the VF has been reset
> to let the PF resets the VF completely, and remove the VF out of schedule.


I'm sorry but this explanation is not different from the previous
version. Please provide a better explanation of the problem, why it is
needed, which VFs need and can't reset themselves, how and why it worked
before e.t.c.

In addition, please follow kernel submission guidelines, write
changelong, add versions, cover letter e.t.c.

Thanks

> 
> How to implement this?
> Add the reset callback function in pci_driver
> 
> Implement the callback functin in VFIO_PCI driver.
> 
> Add the VF RESET IRQ for user mode driver to let the user mode driver
> know the VF has been reset.
> 
> Signed-off-by: Emily Deng <Emily.Deng@amd.com>
> ---
>  drivers/pci/pci.c   | 8 ++++++++
>  include/linux/pci.h | 1 +
>  2 files changed, 9 insertions(+)
> 
> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> index 60230da957e0..aca937b05531 100644
> --- a/drivers/pci/pci.c
> +++ b/drivers/pci/pci.c
> @@ -4780,6 +4780,14 @@ EXPORT_SYMBOL_GPL(pcie_flr);
>   */
>  int pcie_reset_flr(struct pci_dev *dev, bool probe)
>  {
> +	struct pci_dev *pf_dev;
> +
> +	if (dev->is_virtfn) {
> +		pf_dev = dev->physfn;
> +		if (pf_dev->driver->sriov_vf_reset_notification)
> +			pf_dev->driver->sriov_vf_reset_notification(pf_dev, dev);
> +	}
> +
>  	if (dev->dev_flags & PCI_DEV_FLAGS_NO_FLR_RESET)
>  		return -ENOTTY;
>  
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index c69a2cc1f412..4fa31d9b0aa7 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -926,6 +926,7 @@ struct pci_driver {
>  	int  (*sriov_configure)(struct pci_dev *dev, int num_vfs); /* On PF */
>  	int  (*sriov_set_msix_vec_count)(struct pci_dev *vf, int msix_vec_count); /* On PF */
>  	u32  (*sriov_get_vf_total_msix)(struct pci_dev *pf);
> +	void  (*sriov_vf_reset_notification)(struct pci_dev *pf, struct pci_dev *vf);
>  	const struct pci_error_handlers *err_handler;
>  	const struct attribute_group **groups;
>  	const struct attribute_group **dev_groups;
> -- 
> 2.36.1
> 
> 

