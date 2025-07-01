Return-Path: <kvm+bounces-51210-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 34465AF03C4
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 21:29:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0D1823B1ECC
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 19:28:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 944A71DACA7;
	Tue,  1 Jul 2025 19:29:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DUAEz8Nu"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17EAB27EFFB
	for <kvm@vger.kernel.org>; Tue,  1 Jul 2025 19:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751398149; cv=none; b=OUcVkn3eg2oejz1Qwk79YNpYZzVaTWLzc4HUcUhY+Cus01Hyx2F7Glb7QSRE5JYBhmwTNkJJzYkhqtVY/bLIC34FzI5qJIgS8EancJnrH8ccKqrUPF9/SvIofULR4AInPmiGpeVEcdiE2C+aOovYbymvJcxWFdbI0g1vpbSNnRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751398149; c=relaxed/simple;
	bh=qi5MFGChAXKFUZDjtd1nmNXpvDA6MtQYTfDI2UZXy1Q=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VMqE+R0ss1+FSLCe5UkOoCQbZwd5pdDovhjU0p9ZB6rS9r2/Yuob4veDryGfwOPYsa0R3ZOPr9nOUzoIzQaicn+2EJotFTcJDNkEoWZPF1Hj+iEanQINh/8eVbSU/ZPBSQFHGFAn/tqJ3iLPXOgn98+Cyay5cjC8TiWSc7vBdqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DUAEz8Nu; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1751398147;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+gDtWunL173OL9YHHTWlvkL7hyhpmJ6KyKj/K99C8D4=;
	b=DUAEz8NuiyGu3XrlAz/KdNq49MQMN3e3G6TOWk0bpm3lEw7Q8z6SGYOb/HWhlrSXJQ4Vlj
	wr8LdbSOdixagLQvldrKO+AINxe0cUj86Ji+kcHJXpdrzRGgqL1GcNDfogLeDnchro4b37
	DcPngW7IGvw3282/43BAQu0SbGN1kXc=
Received: from mail-oa1-f69.google.com (mail-oa1-f69.google.com
 [209.85.160.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-363-GC-SKTYnO8aQfKGeDzwHSQ-1; Tue, 01 Jul 2025 15:29:06 -0400
X-MC-Unique: GC-SKTYnO8aQfKGeDzwHSQ-1
X-Mimecast-MFC-AGG-ID: GC-SKTYnO8aQfKGeDzwHSQ_1751398145
Received: by mail-oa1-f69.google.com with SMTP id 586e51a60fabf-2e9b1c38495so1308990fac.3
        for <kvm@vger.kernel.org>; Tue, 01 Jul 2025 12:29:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751398145; x=1752002945;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+gDtWunL173OL9YHHTWlvkL7hyhpmJ6KyKj/K99C8D4=;
        b=PPI/popsPhsd6bOjGjO/+RWn2UrLpasjfll80YeCZWryvZV+p8IWTYtuSqQ60AvCaF
         dHnB4myCr5hKRdTHCLlQsLZ9diIjicap4lPM3Oh19b5W2xdwFpMLDYf1K7ATQU12gU+o
         q3KgVkjGsnIdac4xPhxKNw8nwaoTsz9JLUSDv787ZzG3+0z0r6Y8r8H8tfz49loLFmye
         i3iYBisPwWyBskUFCAG4iRS5/3Uz3EfDS4TFeLg4JeC/wah6JnRoYSwpDGDVZzcm9qBS
         pGtCpiYvP5Lkk3ezwxoikFST15oH7E7fIWdhu+Fg/NebbuV//V0Rtz5+CKORXYvUF24N
         4x6g==
X-Forwarded-Encrypted: i=1; AJvYcCUn6Anu5O7GaDvxLFwMn1YtSAb/nrY72cUHpG3HGsWzOxrDO7msAqGty+wuhynR1OOPwQU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yym8K4jw49QPPtyC5lUq81kMGiqWhl6i/yvb7xhhcLezfGPc9Nf
	ezciDFsVjrOXstZtTUCpCDPf360njR9+vCgLtQTGt46gvpgifuMy9SgBtwNtB5db0WwBSOqHuTM
	pNFWfygs1H+9wBfdHbn2gs3mCte36LliWGtq4w8O6p1w8I3EwiCg9zA==
X-Gm-Gg: ASbGnct8KjFUhLPRDEpxS5IMhT4hD05zTJ/8NTuwsTPv+4QGPRUjKDhW4Cei2RhIyP7
	O7LoU0+cth4yo3QfQEUq8xzGM4HFe227pSm7cPwNJWziuQuAWHnyjIB6oxjAiocYJpn8/EEFh5s
	jFoWgrarH5FdzlUpOeV9C8WDtl5S4ViJ5j2kZKgzWjI/KcRvYxn2BAWbsE34kf5P/DvmtsEmJSG
	rkAdbmyB0zr32Z3e9R8maKTw1/qCCmud4jI+Re+kTXXk56jGoW54cyl+6nilTJY+TKyHbGk1Kx9
	k7OzuX7E/VTCFj4AWv/k7GkeEQ==
X-Received: by 2002:a05:6871:3a14:b0:2d6:1e7:f583 with SMTP id 586e51a60fabf-2f5a8c8e573mr2987fac.3.1751398144972;
        Tue, 01 Jul 2025 12:29:04 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEzxKBtIcEO/jlL/s7uq955z0t1nlv/4m/A44xpr3gujAXNCGCC9EjB5EeKqcMmTn3VuTuxcA==
X-Received: by 2002:a05:6871:3a14:b0:2d6:1e7:f583 with SMTP id 586e51a60fabf-2f5a8c8e573mr2981fac.3.1751398144405;
        Tue, 01 Jul 2025 12:29:04 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-2efd4ef71e3sm3405314fac.19.2025.07.01.12.29.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Jul 2025 12:29:03 -0700 (PDT)
Date: Tue, 1 Jul 2025 13:28:59 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, iommu@lists.linux.dev, Joerg Roedel
 <joro@8bytes.org>, linux-pci@vger.kernel.org, Robin Murphy
 <robin.murphy@arm.com>, Will Deacon <will@kernel.org>, Lu Baolu
 <baolu.lu@linux.intel.com>, galshalom@nvidia.com, Joerg Roedel
 <jroedel@suse.de>, Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
 maorg@nvidia.com, patches@lists.linux.dev, tdave@nvidia.com, Tony Zhu
 <tony.zhu@intel.com>
Subject: Re: [PATCH 02/11] PCI: Add pci_bus_isolation()
Message-ID: <20250701132859.2a6661a7.alex.williamson@redhat.com>
In-Reply-To: <2-v1-74184c5043c6+195-pcie_switch_groups_jgg@nvidia.com>
References: <0-v1-74184c5043c6+195-pcie_switch_groups_jgg@nvidia.com>
	<2-v1-74184c5043c6+195-pcie_switch_groups_jgg@nvidia.com>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 30 Jun 2025 19:28:32 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:
> diff --git a/drivers/pci/search.c b/drivers/pci/search.c
> index 53840634fbfc2b..540a503b499e3f 100644
> --- a/drivers/pci/search.c
> +++ b/drivers/pci/search.c
> @@ -113,6 +113,156 @@ int pci_for_each_dma_alias(struct pci_dev *pdev,
>  	return ret;
>  }
>  
> +static enum pci_bus_isolation pcie_switch_isolated(struct pci_bus *bus)
> +{
> +	struct pci_dev *pdev;
> +
> +	/*
> +	 * Within a PCIe switch we have an interior bus that has the Upstream
> +	 * port as the bridge and a set of Downstream port bridging to the
> +	 * egress ports.
> +	 *
> +	 * Each DSP has an ACS setting which controls where its traffic is
> +	 * permitted to go. Any DSP with a permissive ACS setting can send
> +	 * traffic flowing upstream back downstream through another DSP.
> +	 *
> +	 * Thus any non-permissive DSP spoils the whole bus.
> +	 */
> +	guard(rwsem_read)(&pci_bus_sem);
> +	list_for_each_entry(pdev, &bus->devices, bus_list) {
> +		/* Don't understand what this is, be conservative */
> +		if (!pci_is_pcie(pdev) ||
> +		    pci_pcie_type(pdev) != PCI_EXP_TYPE_DOWNSTREAM ||
> +		    pdev->dma_alias_mask)
> +			return PCIE_NON_ISOLATED;
> +
> +		if (!pci_acs_enabled(pdev, PCI_ACS_ISOLATED))
> +			return PCIE_SWITCH_DSP_NON_ISOLATED;
> +	}
> +	return PCIE_ISOLATED;
> +}
> +
> +static bool pci_has_mmio(struct pci_dev *pdev)
> +{
> +	unsigned int i;
> +
> +	for (i = 0; i <= PCI_ROM_RESOURCE; i++) {
> +		struct resource *res = pci_resource_n(pdev, i);
> +
> +		if (resource_size(res) && resource_type(res) == IORESOURCE_MEM)
> +			return true;
> +	}
> +	return false;
> +}

Maybe the intent is to make this as generic as possible, but it seems
to only be used for bridge devices, so technically it could get
away with testing only the first two resources, right?

> +
> +/**
> + * pci_bus_isolated - Determine how isolated connected devices are
> + * @bus: The bus to check
> + *
> + * Isolation is the ability of devices to talk to each other. Full isolation
> + * means that a device can only communicate with the IOMMU and can not do peer
> + * to peer within the fabric.
> + *
> + * We consider isolation on a bus by bus basis. If the bus will permit a
> + * transaction originated downstream to complete on anything other than the
> + * IOMMU then the bus is not isolated.
> + *
> + * Non-isolation includes all the downstream devices on this bus, and it may
> + * include the upstream bridge or port that is creating this bus.
> + *
> + * The various cases are returned in an enum.
> + *
> + * Broadly speaking this function evaluates the ACS settings in a PCI switch to
> + * determine if a PCI switch is configured to have full isolation.
> + *
> + * Old PCI/PCI-X busses cannot have isolation due to their physical properties,
> + * but they do have some aliasing properties that effect group creation.
> + *
> + * pci_bus_isolated() does not consider loopback internal to devices, like
> + * multi-function devices performing a self-loopback. The caller must check
> + * this separately. It does not considering alasing within the bus.
> + *
> + * It does not currently support the ACS P2P Egress Control Vector, Linux does
> + * not yet have any way to enable this feature. EC will create subsets of the
> + * bus that are isolated from other subsets.
> + */
> +enum pci_bus_isolation pci_bus_isolated(struct pci_bus *bus)
> +{
> +	struct pci_dev *bridge = bus->self;
> +	int type;
> +
> +	/* Consider virtual busses isolated */
> +	if (!bridge)
> +		return PCIE_ISOLATED;
> +	if (pci_is_root_bus(bus))
> +		return PCIE_ISOLATED;

How do we know the root bus isn't conventional?  I suppose this is only
called by IOMMU code, but QEMU can make some pretty weird
configurations.  Thanks,

Alex


