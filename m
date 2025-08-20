Return-Path: <kvm+bounces-55201-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A8DCB2E3F0
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 19:32:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7556F1C84E0E
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 17:27:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DBAC258EF1;
	Wed, 20 Aug 2025 17:22:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E793WzSw"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8214C21D3F3;
	Wed, 20 Aug 2025 17:21:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755710519; cv=none; b=sp5YVR2gb15yY6GrLrnJ5PPBMnkjVY/yJDlnoiqFm1CXd+F1aVAl0bKv66ohxy+RK0sC0zw5N6q0TMn2TCYSI9c8pZWEqm9HNbX7dK7XbgWZu0U1AOVEl/li/SFYxpxN2LRKShBM9S64QHTvgDyYLgc71QOnj9SU6MpIDlRW6gE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755710519; c=relaxed/simple;
	bh=0wJCklLNzHw0yMvc8jq3Ced2Renj3s1CQo1D7CkAvnw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kHm2bGaqM8W6+lVufpQzDF34qT87xFgbjSJwtbpX/ASLEm72IKFV8aAoxIgPJKoMjoKLUjsvPG6M0pjdanK9XfjRi0WyZzXAxAMkhTKwAKB/88/35R02OnCUm2dxYLfGLZFSBttXKe3jLkxRaMyC5iDCMRmZ390eKdZJAJ7o0pY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E793WzSw; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 428DEC4CEE7;
	Wed, 20 Aug 2025 17:21:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755710519;
	bh=0wJCklLNzHw0yMvc8jq3Ced2Renj3s1CQo1D7CkAvnw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=E793WzSwdXRgKqQLiMmqMJT6lgjCE3yiR6Z73/rnc8Q4gKB/lbH7v/ChYME/ha+/F
	 1z30QljiCykBNr5KDkvREtVyTUuRhaKpKXRoTnMg2lxLuusNULzdVEn6Hs98shv6hq
	 Uo92PXqlqYiaD8JEPQlG5xKcPS/YsbiCaTTgcOsL5IEKnp56nBENil4fSjFUQj1NnJ
	 nubLvdocP9VIYxIdhMDL45CVN4gm15xXTgBkNlAQyKEyuZMDYvB7s2eGy91jl2ecSW
	 ayj7DhKwPzWi82resWxKXMB1iSEJPUR5r5GSbYmF78yzXUv0L6jiba9NH+D6i81O8o
	 uCvPZSQ7JfBlQ==
Date: Wed, 20 Aug 2025 11:21:56 -0600
From: Keith Busch <kbusch@kernel.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>, linux-pci@vger.kernel.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Lu Baolu <baolu.lu@linux.intel.com>, galshalom@nvidia.com,
	Joerg Roedel <jroedel@suse.de>, Kevin Tian <kevin.tian@intel.com>,
	kvm@vger.kernel.org, maorg@nvidia.com, patches@lists.linux.dev,
	tdave@nvidia.com, Tony Zhu <tony.zhu@intel.com>
Subject: Re: [PATCH v2 10/16] PCI: Add pci_mfd_isolation()
Message-ID: <aKYENMLMwULmQYhb@kbusch-mbp>
References: <0-v2-4a9b9c983431+10e2-pcie_switch_groups_jgg@nvidia.com>
 <10-v2-4a9b9c983431+10e2-pcie_switch_groups_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <10-v2-4a9b9c983431+10e2-pcie_switch_groups_jgg@nvidia.com>

On Wed, Jul 09, 2025 at 11:52:13AM -0300, Jason Gunthorpe wrote:
> @@ -2078,6 +2079,9 @@ pci_reachable_set(struct pci_dev *start, struct pci_reachable_set *devfns,
>  static inline enum pci_bus_isolation pci_bus_isolated(struct pci_bus *bus)
>  { return PCIE_NON_ISOLATED; }
>  
> +bool pci_mfd_isolated(struct pci_dev *dev)
> +{ return false; }
> +

This needs to be 'static inline'.

