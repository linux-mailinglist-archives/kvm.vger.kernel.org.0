Return-Path: <kvm+bounces-25798-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D7DFE96AA8A
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 23:46:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8EFD91F26B89
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 21:46:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B5541A3A99;
	Tue,  3 Sep 2024 21:46:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K2WWDuC7"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 926BB1EBFEC;
	Tue,  3 Sep 2024 21:46:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725399966; cv=none; b=S7xHlO4UI6uecxPnuTFCdVRJsvtS4gZB6Jco26JUYnoauFvgt0H7EVt0dCthdbqbxUxH/MU68mtFt8srmxHg5Hd/eF3PMEG6KLG6ayky+S1cKRXgPujZbT3MJNk4z8vZb8Argrp1MbBP6UtJ8+fbHFwIahvVb4C6Gw++YEm1Pho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725399966; c=relaxed/simple;
	bh=p7rqK+c3+AbaVlz6xMAoFuo6JQj+X/iXW+rvmpzRJmU=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=XsJcR/Q5dCMQs+LALR5lSYUh49zhBfk000kU1b6lhyd86yRlCIBTJsDeZ789NCFikXZgPW92Lx+dW2HljUFB8wBaYQ/FIf7TWqr+q0Q1lC3rx9UpYRa/tXG0z/1RsVcb3/73a4OCtpA0xkTj+EFYDnBrbkF7NRDbxajpqRoW6Gw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K2WWDuC7; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D34AAC4CEC4;
	Tue,  3 Sep 2024 21:46:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725399966;
	bh=p7rqK+c3+AbaVlz6xMAoFuo6JQj+X/iXW+rvmpzRJmU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:From;
	b=K2WWDuC7149nQDSRkx090OlRMUUtZAfJ4FNvmOD3mufPec/fjv0x8ZNoZSBc0G+kE
	 F+sA0gi3ArqwD1kOluWuD54yQuaEGWtNL8oT2uSqYpDDiMF5xODIaJtM/sutLF3Y1C
	 IdydrjmbWAdZIDEGJZQ+PWV4UgBkFx2ckAgOMqoi0lO5oEMH0wgCuwkUXAN+/2gcsM
	 f98oNWpmOxasgOe5gkYmms8GlnSCPUxwLn/wT/3XDKxp7Wej0d/C+llKShYaS+lGED
	 jvv/b/8q05wU1OuM+sqxT6p6Al2sCrrP2IubT4TymSoKjLZpKngSvxu3mUfhaS2xjr
	 NFKDwGKEQS9Og==
Date: Tue, 3 Sep 2024 16:46:04 -0500
From: Bjorn Helgaas <helgaas@kernel.org>
To: Alexey Kardashevskiy <aik@amd.com>
Cc: kvm@vger.kernel.org, iommu@lists.linux.dev, linux-coco@lists.linux.dev,
	linux-pci@vger.kernel.org,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Dan Williams <dan.j.williams@intel.com>,
	pratikrajesh.sampat@amd.com, michael.day@amd.com,
	david.kaplan@amd.com, dhaval.giani@amd.com,
	Santosh Shukla <santosh.shukla@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Michael Roth <michael.roth@amd.com>, Alexander Graf <agraf@suse.de>,
	Nikunj A Dadhania <nikunj@amd.com>,
	Vasant Hegde <vasant.hegde@amd.com>, Lukas Wunner <lukas@wunner.de>
Subject: Re: [RFC PATCH 20/21] pci: Allow encrypted MMIO mapping via sysfs
Message-ID: <20240903214604.GA304177@bhelgaas>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <028e2952-ad4f-465d-870e-93e1ae6268f6@amd.com>

On Mon, Sep 02, 2024 at 06:22:00PM +1000, Alexey Kardashevskiy wrote:
> On 24/8/24 08:37, Bjorn Helgaas wrote:
> > On Fri, Aug 23, 2024 at 11:21:34PM +1000, Alexey Kardashevskiy wrote:
> > > Add another resource#d_enc to allow mapping MMIO as
> > > an encrypted/private region.
> > > 
> > > Unlike resourceN_wc, the node is added always as ability to
> > > map MMIO as private depends on negotiation with the TSM which
> > > happens quite late.

> > > @@ -46,6 +46,15 @@ int pci_mmap_resource_range(struct pci_dev *pdev, int bar,
> > >   	vma->vm_ops = &pci_phys_vm_ops;
> > > +	/*
> > > +	 * Calling remap_pfn_range() directly as io_remap_pfn_range()
> > > +	 * enforces shared mapping.
> > 
> > s/Calling/Call/
> > 
> > Needs some additional context about why io_remap_pfn_range() can't be
> > used here.
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=f8f6ae5d077a9bdaf5cbf2ac960a5d1a04b47482
> added this.
> 
> "IO devices do not understand encryption, so this memory must always be
> decrypted" it says.

Thanks for the pointer.  Given that hint, the pgprot_decrypted()
inside io_remap_pfn_range() is ... at least *there*, if not obvious.
io_remap_pfn_range() probably could benefit from a simple comment to
highlight that.

> But devices do understand encryption so forcing decryption is not wanted.
> What additional context is missing here, that "shared" means
> "non-encrypted"? Thanks,

If "shared" means "non-encrypted", that would be useful.  That wasn't
obvious to me.

IIUC, in the "enc" case, you *want* the mapping to remain encrypted?
In that case, it would be helpful to say something like
"io_remap_pfn_range() always produces decrypted mappings, so use
remap_pfn_range() directly to avoid the decryption".

Renaming "enc" to "encrypted" would also be a nice hint.

> > > +	 */
> > > +	if (enc)
> > > +		return remap_pfn_range(vma, vma->vm_start, vma->vm_pgoff,
> > > +				       vma->vm_end - vma->vm_start,
> > > +				       vma->vm_page_prot);
> > > +
> > >   	return io_remap_pfn_range(vma, vma->vm_start, vma->vm_pgoff,
> > >   				  vma->vm_end - vma->vm_start,
> > >   				  vma->vm_page_prot);
> 
> -- 
> Alexey
> 

