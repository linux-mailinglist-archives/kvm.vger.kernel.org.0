Return-Path: <kvm+bounces-40886-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E40B4A5EBE2
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 07:47:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BCF33189AD3B
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 06:48:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A745A1F91C7;
	Thu, 13 Mar 2025 06:47:50 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0635136658
	for <kvm@vger.kernel.org>; Thu, 13 Mar 2025 06:47:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741848470; cv=none; b=iAxkQxFe4AoWF8J0NQtu9VyMBdD6k93j2HaXOULWW9kQVv0AQItt4OD8gUl0u/MAwRElnm3ypD+Ti46NkHUTAlR4nroUtJ7avqw3UnytzUHRbOFBfkJo6RjUpxD0chiQh4f7jIy4yHvQpoOOV1FpYZLJ042Q5c+gydmhM9L0x5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741848470; c=relaxed/simple;
	bh=JqOnqPvBauN17fWAqwG6ze79GdzPNv37S4EAxVv0ghY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IuDHMq4W2Yrhw2fp2NmxLfHxRtdbLhnbCNb9jGM6HIN5dpSI83tGa21qCSufiRo6jXXyFPnM7Mx27oj60viHLfG1640T/bJphkZOzFe3bjaE9b/p7TdqS32IDjp5r137KeOp7/UZ/4Iezsn8xNgwfnX+rQsO/FkDJpCEyGiXGCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 789CD68C4E; Thu, 13 Mar 2025 07:47:43 +0100 (CET)
Date: Thu, 13 Mar 2025 07:47:43 +0100
From: Christoph Hellwig <hch@lst.de>
To: Mike Christie <michael.christie@oracle.com>
Cc: chaitanyak@nvidia.com, kbusch@kernel.org, hch@lst.de, sagi@grimberg.me,
	joao.m.martins@oracle.com, linux-nvme@lists.infradead.org,
	kvm@vger.kernel.org, kwankhede@nvidia.com,
	alex.williamson@redhat.com, mlevitsk@redhat.com
Subject: Re: [PATCH RFC 00/11] nvmet: Add NVMe target mdev/vfio driver
Message-ID: <20250313064743.GA10198@lst.de>
References: <20250313052222.178524-1-michael.christie@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250313052222.178524-1-michael.christie@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Mar 13, 2025 at 12:18:01AM -0500, Mike Christie wrote:
> 
> If we agree on a new virtual NVMe driver being ok, why mdev vs vhost?
> =====================================================================
> The problem with a vhost nvme is:
> 
> 2.1. If we do a fully vhost nvmet solution, it will require new guest
> drivers that present NVMe interfaces to userspace then perform the
> vhost spec on the backend like how vhost-scsi does.
>
> I don't want to implement a windows or even a linux nvme vhost
> driver. I don't think anyone wants the extra headache.

As in a nvme-virtio spec?  Note that I suspect you could use the
vhost infrastructure for something that isn't virtio, but it would
be a fair amount of work.

> 2.2. We can do a hybrid approach where in the guest it looks like we
> are a normal old local NVMe drive and use the guest's native NVMe driver.
> However in QEMU we would have a vhost nvme module that instead of using
> vhost virtqueues handles virtual PCI memory accesses as well as a vhost
> nvme kernel or user driver to process IO.
> 
> So not as much extra code as option 1 since we don't have to worry about
> the guest but still extra QEMU code.

And it does sound rather inefficient to me.

> Why not a new blk driver or why not vdpa blk?
> =============================================
> Applications want standardized interfaces for things like persistent
> reservations. They have to support them with SCSI and NVMe already
> and don't want to have to support a new virtio block interface.
> 
> Also the nvmet-mdev-pci driver in this patchset can perform was well
> as SPDK vhost blk so that doesn't have the perf advantage like it
> used to.

Maybe I'm too old school, but I find vdpa a complete pain in the neck
to deal with in any way..

> 1. Should the driver integrate with pci-epf (the drivers work very
> differently but could share some code)?

If we can easily share code we should in a library.  But we should
not force sharing code where it just make things more complicated.

> 2. Should it try to fit into the existing configfs interface or implement
> it's own like how pci-epf did? I did an attempt for this but it feels
> wrong.

pci-epf needs to integrate with the pci endpoint configfs interface
exposed by that subsystem.  So the way it works wasn't really a choice
but a requirement to interact with the underlying abstraction.


