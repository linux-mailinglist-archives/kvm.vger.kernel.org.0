Return-Path: <kvm+bounces-40885-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E3948A5EBD7
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 07:42:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 23E951758EA
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 06:42:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7A621FBC8B;
	Thu, 13 Mar 2025 06:42:42 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 226D21FAC38
	for <kvm@vger.kernel.org>; Thu, 13 Mar 2025 06:42:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741848162; cv=none; b=ZjAKH4+GC9y70YG0IdPRUitHSOoxjlhvAQnLL8htcpnI13j+trp4mWEHe0ymPgmRUQRSGkU7xu/g9rTUvlPwTp9yE1LYQW7PPRbvDYA9TpMKl/F0ZB+tyL5V5YU4RvaERqLvrb96eEjcnZ/4CzdpdxoP+gWTd7E515jMeGOklRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741848162; c=relaxed/simple;
	bh=72GOgf5EZMb/WeOuXYWdvyFh+GK9+QQtkNoZR0xyE68=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H/FQ2qXFsKSOuw+FDgMv5oS+cZHRQ68nmyp+W2LuNtjGphiXbbSTT+j1V2Xl4bBCaLGg9dA0lxPjMez53H67FM13Pvl9pTpsfLEDU5r3+EtgrB7AYt4kb3tska/T8g9shgIgzgGX76+OSgVdjmIs4obM5GIIdHm62XesPveWqEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 349BF68C4E; Thu, 13 Mar 2025 07:42:36 +0100 (CET)
Date: Thu, 13 Mar 2025 07:42:36 +0100
From: Christoph Hellwig <hch@lst.de>
To: Mike Christie <michael.christie@oracle.com>
Cc: chaitanyak@nvidia.com, kbusch@kernel.org, hch@lst.de, sagi@grimberg.me,
	joao.m.martins@oracle.com, linux-nvme@lists.infradead.org,
	kvm@vger.kernel.org, kwankhede@nvidia.com,
	alex.williamson@redhat.com, mlevitsk@redhat.com
Subject: Re: [PATCH RFC 10/11] nvmet: Add addr fam and trtype for mdev pci
 driver
Message-ID: <20250313064236.GE9967@lst.de>
References: <20250313052222.178524-1-michael.christie@oracle.com> <20250313052222.178524-11-michael.christie@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250313052222.178524-11-michael.christie@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Mar 13, 2025 at 12:18:11AM -0500, Mike Christie wrote:
> This allocates 253 for mdev pci since it might not fit into any
> existing value (not sure how to co-exist with pci-epf).
> 
> One of the reasons this patchset is a RFC is because I was not sure
> if allocating a new number for this was the best. Another approach
> is that I could break up pci-epf into a:
> 
> 1. PCI component - Common PCI and NVMe PCI code.
> 2. Interface/bus component - Callouts so pci-epf can use the
> pci_epf_driver/pci_epf_ops and mdev-pci can use mdev and vfio
> callouts.
> 3. Memory management component - Callouts for using DMA for pci-epf
> vs vfio related memory for mdev-pci.
> 
> On one hand, by creating a core nvmet pci driver then have subdrivers
> we could share NVMF_ADDR_FAMILY_PCI and NVMF_TRTYPE_PCI. However,
> it will get messy. There is some PCI code we could share for 1
> but 2 and 3 will make sharing difficult becuse of how different the
> drivers work (mdev-vfio vs pci-epf layers).

I think we'll need to discuss this more based on concrete code proposals
once we go along, but here's my handwavy 2cents for now:

  - in addition to the pure software endpoint and mdev I also expect
    hardardware offloaded PCIe endpoints to show up really soon, so
    we'll have more than just the two
  - having common code for different PCIe tagets where applicable is
    thus a good idea, but I'd expect it to be a set of library
    functions or conditionals in the core code, not a new layer
    with indirect calls
  - I had quite a lot of discussions with Damien about the trtype and
    related bits.  I suspect by the time we get to having multiple
    PCIe endpoints we just need to split the configfs interface naming
    from the on-wire fabrics trtrype enum to not need trtype assignments.


