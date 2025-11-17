Return-Path: <kvm+bounces-63427-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C8F1C66816
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 00:00:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 3C33A34AE68
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 22:59:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68C7834A3D6;
	Mon, 17 Nov 2025 22:58:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jo7u/QNd"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72AA12F39A0;
	Mon, 17 Nov 2025 22:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763420335; cv=none; b=bNK+SYsdvnuwrq3Irmhkzaw3NiVYTz21RKYoe/SQ1KXqysgeQ206CCDds67sVK1Sr5F3+sPmUvZON/LANkQmSkDvmvqwdIc1DcP5Z8lPkRTRIbsuUPQzDgC5p5D0r07uqzztsYG+43D+8Qw5xmatTH3a/S1xvvHfnuAJy6dY00c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763420335; c=relaxed/simple;
	bh=yfF05U4RF+SjY7Vvy+25AHoW6V6B9W7JtUipFLOoZAY=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=q7XHf4UebNEw1DI130+OgGgvI7l0q9yrBwXwEv7pcRT8Sjg0Sn2/Bd/ey353SvbtG9zzlMnq86jKwngN51iBZ/SmFbYk72Z5mGO38LZ9+5BElZ0WuWp0DCp7ZZd7MwEn6M8Bp6liDyCi1Cn3Eu/PQXERcwoeJGoeqcQ+pSCO48w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jo7u/QNd; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80D04C19423;
	Mon, 17 Nov 2025 22:58:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763420334;
	bh=yfF05U4RF+SjY7Vvy+25AHoW6V6B9W7JtUipFLOoZAY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:From;
	b=jo7u/QNdMQcZ0HiLdmqU1BcI9yil/ZZRFOvlLcWSCOYpykU32AJPrFgqSxPjOC5WU
	 p5ALUsyQswJELk4yY0ZiwBezUvJswC+0mFC/CZ4CI5WRnqdEXynrrjzuWh5KkldHbz
	 aWnza2wNr+rbBJ3iChBxI84YXKVCQyM3sYO8ypMcz2PnbBialFEXMZ2zpgCQzfNWgo
	 Rf+DPvQRgYH9EbvUlzi/dpVeOoFpuHgYMeaTOzIr23sYK6elAa2c5oOz6nWIxEGIUv
	 FQPmCqAXV7PU+5F+zU3DJIXmr90rdfesgtKl7ueFJHtH3lLwaDp+3kapjBq9dRPm+x
	 KjijbvlphfhIQ==
Date: Mon, 17 Nov 2025 16:58:52 -0600
From: Bjorn Helgaas <helgaas@kernel.org>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: joro@8bytes.org, rafael@kernel.org, bhelgaas@google.com,
	alex@shazbot.org, jgg@nvidia.com, kevin.tian@intel.com,
	will@kernel.org, robin.murphy@arm.com, lenb@kernel.org,
	baolu.lu@linux.intel.com, linux-arm-kernel@lists.infradead.org,
	iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-acpi@vger.kernel.org, linux-pci@vger.kernel.org,
	kvm@vger.kernel.org, patches@lists.linux.dev,
	pjaroszynski@nvidia.com, vsethi@nvidia.com, etzhao1900@gmail.com
Subject: Re: [PATCH v5 5/5] pci: Suspend iommu function prior to resetting a
 device
Message-ID: <20251117225659.GA2536275@bhelgaas>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a166b07a254d3becfcb0f86e4911af556acbe2a9.1762835355.git.nicolinc@nvidia.com>

On Mon, Nov 10, 2025 at 09:12:55PM -0800, Nicolin Chen wrote:

Run "git log --oneline drivers/pci/pci.c" and match the subject line
style.

> PCIe permits a device to ignore ATS invalidation TLPs, while processing a
> reset. This creates a problem visible to the OS where an ATS invalidation
> command will time out: e.g. an SVA domain will have no coordination with a
> reset event and can racily issue ATS invalidations to a resetting device.

s/TLPs, while/TLPs while/

> The PCIe spec in sec 10.3.1 IMPLEMENTATION NOTE recommends to disable and
> block ATS before initiating a Function Level Reset. It also mentions that
> other reset methods could have the same vulnerability as well.

Include spec revision, e.g., "PCIe r7.0, sec 10.3.1".

> Now iommu_dev_reset_prepare/done() helpers are introduced for this matter.

s/Now ... are introduced for this matter/Add ...helpers/

> Use them in all the existing reset functions, which will attach the device
> to an IOMMU_DOMAIN_BLOCKED during a reset, so as to allow IOMMU driver to:
>  - invoke pci_disable_ats() and pci_enable_ats(), if necessary
>  - wait for all ATS invalidations to complete
>  - stop issuing new ATS invalidations
>  - fence any incoming ATS queries

Thanks for addressing this problem.

> +++ b/drivers/pci/pci-acpi.c
> @@ -971,6 +971,7 @@ void pci_set_acpi_fwnode(struct pci_dev *dev)
>  int pci_dev_acpi_reset(struct pci_dev *dev, bool probe)
>  {
>  	acpi_handle handle = ACPI_HANDLE(&dev->dev);
> +	int ret = 0;

Unnecessary initialization.

> +int pci_reset_iommu_prepare(struct pci_dev *dev)
> +{
> +	if (pci_ats_supported(dev))
> +		return iommu_dev_reset_prepare(&dev->dev);

Why bother checking pci_ats_supported() here?  That could be done
inside iommu_dev_reset_prepare(), since iommu.c already uses
dev_is_pci() and pci_ats_supported() is already exported outside
drivers/pci/.

> +void pci_reset_iommu_done(struct pci_dev *dev)
> +{
> +	if (pci_ats_supported(dev))
> +		iommu_dev_reset_done(&dev->dev);

And here.

>  int pcie_flr(struct pci_dev *dev)
>  {
> +	int ret = 0;

Unnecessary initialization.

>  static int pci_af_flr(struct pci_dev *dev, bool probe)
>  {
> +	int ret = 0;

Unnecessary initialization.

