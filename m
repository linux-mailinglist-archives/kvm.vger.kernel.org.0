Return-Path: <kvm+bounces-57774-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 2CD3FB5A03E
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 20:10:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 205574E27F3
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 18:10:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 238492C3770;
	Tue, 16 Sep 2025 18:10:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j5tkEZKU"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FC3032D5B5;
	Tue, 16 Sep 2025 18:09:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758046200; cv=none; b=B7RkDltw4k1lwCbB+eN364+9ljV8YuHSYsc/HqEqEN4gsL5n4/OcPCApTChomTgns6ycOjGjNQTioyUoUvWxWbFsSttIy6D1DtUlSiZBbba8cpzPEMb7rZ1mCdD7q5bt4bNLXfWBWuWA9Lp5Wdx6fGAAXJCM+scVcE+v7nuSJOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758046200; c=relaxed/simple;
	bh=m6QCS+P9YxrpdZ57DX6UqOO6VhSgbr2yZ4pXMyKZ084=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=fyd4yJW2VTY41X3L+/HoS+ZDTOrLPVzU/br6Hrfwf4jK2Z3vNGbdMnTDNF/hwIhdrE+d+WUQCopBOG/QGr4WLu96tSabBRlcB/LFXz8msIuF/wQyoajliKpOkPgcoXjLx/IOcNEwhbo+Tr7Gkb4iW2xIkSV+2i9vX/na7P8Y42Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j5tkEZKU; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87B7EC4CEEB;
	Tue, 16 Sep 2025 18:09:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758046199;
	bh=m6QCS+P9YxrpdZ57DX6UqOO6VhSgbr2yZ4pXMyKZ084=;
	h=Date:From:To:Cc:Subject:In-Reply-To:From;
	b=j5tkEZKULkLrmweXNKv11lM/CpL3BnmoV7wggD67l6FdeZKCCZyUufO2UVOOlbsWb
	 zLx6Dp2BB2O914sMRl+9olsMfiQdErBLovDUuFc7ThY5jFoJR6wlYL/nv9c+748bRj
	 Wi1IS0iplCuM2l19mCD3ZiBDd3agSW2xRDPmD4OCI/RzUWtafaMliL9JIB6bON8fJW
	 5oOzHZHH8V/BOAouZeJbz5WQRiIO69objOg90STjUHOzEMPcDURvqeBD+myI2omNcF
	 VQ2lRE+tdWO5qB5dwLxEn0U8NgsM9E75hI1SMCrH2m4f3ZW69OiY6eQ8d86cPQARAY
	 bL2Z1N9igSspw==
Date: Tue, 16 Sep 2025 13:09:58 -0500
From: Bjorn Helgaas <helgaas@kernel.org>
To: Farhan Ali <alifm@linux.ibm.com>
Cc: linux-s390@vger.kernel.org, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
	alex.williamson@redhat.com, schnelle@linux.ibm.com,
	mjrosato@linux.ibm.com
Subject: Re: [PATCH v3 01/10] PCI: Avoid saving error values for config space
Message-ID: <20250916180958.GA1797871@bhelgaas>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250911183307.1910-2-alifm@linux.ibm.com>

On Thu, Sep 11, 2025 at 11:32:58AM -0700, Farhan Ali wrote:
> The current reset process saves the device's config space state before
> reset and restores it afterward. However, when a device is in an error
> state before reset, config space reads may return error values instead of
> valid data. This results in saving corrupted values that get written back
> to the device during state restoration.
> 
> Avoid saving the state of the config space when the device is in error.
> While restoring we only restorei the state that can be restored through
> kernel data such as BARs or doesn't depend on the saved state.
> 
> Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
> ---
>  drivers/pci/pci.c      | 29 ++++++++++++++++++++++++++---
>  drivers/pci/pcie/aer.c |  5 +++++
>  drivers/pci/pcie/dpc.c |  5 +++++
>  drivers/pci/pcie/ptm.c |  5 +++++
>  drivers/pci/tph.c      |  5 +++++
>  drivers/pci/vc.c       |  5 +++++
>  6 files changed, 51 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> index b0f4d98036cd..4b67d22faf0a 100644
> --- a/drivers/pci/pci.c
> +++ b/drivers/pci/pci.c
> @@ -1720,6 +1720,11 @@ static void pci_restore_pcie_state(struct pci_dev *dev)
>  	struct pci_cap_saved_state *save_state;
>  	u16 *cap;
>  
> +	if (!dev->state_saved) {
> +		pci_warn(dev, "Not restoring pcie state, no saved state");
> +		return;

Seems like a lot of messages.  If we want to warn about this, why
don't we do it once in pci_restore_state()?

I guess you're making some judgment about what things can be restored
even when !dev->state_saved.  That seems kind of hard to maintain in
the future as other capabilities are added.

Also seems sort of questionable if we restore partial state and keep
using the device as if all is well.  Won't the device be in some kind
of inconsistent, unpredictable state then?

Bjorn

