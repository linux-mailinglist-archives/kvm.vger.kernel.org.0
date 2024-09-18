Return-Path: <kvm+bounces-27067-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 63CA797BB17
	for <lists+kvm@lfdr.de>; Wed, 18 Sep 2024 12:48:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 247F2281CBC
	for <lists+kvm@lfdr.de>; Wed, 18 Sep 2024 10:48:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5847C1862B9;
	Wed, 18 Sep 2024 10:48:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Gb2YmsS5"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFCB717B401;
	Wed, 18 Sep 2024 10:48:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726656489; cv=none; b=CVdtxvbZn3bFHUdU8M6PtJIs94V/ufCsHBB9N4lTv8XbGxFtU5LoyGlPnus6ehU5DP+f7ZeI4raAijzHAG0mvKJhBVegYaZaHSnN7nO12rZFN8S5YRu0n+/hxhYDXL72rA/w3lAVBajzbf2rtaB5898fiySqntl7uO87ULfoC2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726656489; c=relaxed/simple;
	bh=TiIy7EfGXyCmAuvsoen3rZWUqqgVpPDNqDz5ADa6soM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CZl/m1dR+DREkTF3MipfZndP2sEZ2nnL5b0xjmhWjZJeQrAajPUbU6cDiRiMmkXopt7faNoigArHfP+bUqNBpbpM8Hr5efChukCKwTIX38ArqEUlhw0G+3Dq2rw+Eu+cBhQ0hfP2jER12a7G3IVn9Kw1kVNUAD4MiXA01dzki0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Gb2YmsS5; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1726656488; x=1758192488;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=TiIy7EfGXyCmAuvsoen3rZWUqqgVpPDNqDz5ADa6soM=;
  b=Gb2YmsS52OqKh/nG8i/gMnJzA51opXYFTR7Zh8mnSrKFocIWDRlQAU+z
   Hug/X8atK1jyy+I1b6rlzhAHAUbCCNcd9oZy8meQlayCsHb+bY2AWJQ2c
   TyGL5A8ma/1kFW9A3ewoq/XgFRDXk7LvfuowE1lgt1G+HXvPLLKDwDixv
   Q6ALX0Np+Br50Ego6A8mTACKZNHSta5wKG2xHw57JH41wsHcyBxM2MDzq
   qQUmrq7ecu+4G3vW9fwlJsTqIkb0frHQUdgw7pIXLh8PKkJgU+LMKaGyi
   QoA8ghdLjlq/QrI/WPFmXipupotyEya9+vOlBK+yaCZvpD+XhmGKk71Qr
   Q==;
X-CSE-ConnectionGUID: SWaxycP5Sp60FTn38JVV4w==
X-CSE-MsgGUID: A/1XsqVRSHyJ3/r8XoXSkg==
X-IronPort-AV: E=McAfee;i="6700,10204,11198"; a="36228035"
X-IronPort-AV: E=Sophos;i="6.10,238,1719903600"; 
   d="scan'208";a="36228035"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2024 03:48:07 -0700
X-CSE-ConnectionGUID: r1ktb154Qomnw/3/dLbBPw==
X-CSE-MsgGUID: +YEmRqY1RuCSlWKwZz3t1A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,238,1719903600"; 
   d="scan'208";a="73864529"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by fmviesa005.fm.intel.com with ESMTP; 18 Sep 2024 03:48:02 -0700
Date: Wed, 18 Sep 2024 18:45:14 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: Zhi Wang <zhiw@nvidia.com>
Cc: "Tian, Kevin" <kevin.tian@intel.com>,
	"Williams, Dan J" <dan.j.williams@intel.com>,
	Zhi Wang <zhiwang@kernel.org>, Alexey Kardashevskiy <aik@amd.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
	"linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	"pratikrajesh.sampat@amd.com" <pratikrajesh.sampat@amd.com>,
	"michael.day@amd.com" <michael.day@amd.com>,
	"david.kaplan@amd.com" <david.kaplan@amd.com>,
	"dhaval.giani@amd.com" <dhaval.giani@amd.com>,
	Santosh Shukla <santosh.shukla@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Michael Roth <michael.roth@amd.com>, Alexander Graf <agraf@suse.de>,
	Nikunj A Dadhania <nikunj@amd.com>,
	Vasant Hegde <vasant.hegde@amd.com>, Lukas Wunner <lukas@wunner.de>
Subject: Re: [RFC PATCH 11/21] KVM: SEV: Add TIO VMGEXIT and bind TDI
Message-ID: <ZuqvOt1WEn/Pa/wQ@yilunxu-OptiPlex-7050>
References: <20240823132137.336874-1-aik@amd.com>
 <20240823132137.336874-12-aik@amd.com>
 <20240913165011.000028f4.zhiwang@kernel.org>
 <66e4b7fabf8df_ae21294c7@dwillia2-mobl3.amr.corp.intel.com.notmuch>
 <BN9PR11MB527607712924E6574159C4908C662@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240914081946.000079ae.zhiw@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240914081946.000079ae.zhiw@nvidia.com>

On Sat, Sep 14, 2024 at 08:19:46AM +0300, Zhi Wang wrote:
> On Sat, 14 Sep 2024 02:47:27 +0000
> "Tian, Kevin" <kevin.tian@intel.com> wrote:
> 
> > > From: Dan Williams <dan.j.williams@intel.com>
> > > Sent: Saturday, September 14, 2024 6:09 AM
> > > 
> > > Zhi Wang wrote:
> > > > On Fri, 23 Aug 2024 23:21:25 +1000
> > > > Alexey Kardashevskiy <aik@amd.com> wrote:
> > > >
> > > > > The SEV TIO spec defines a new TIO_GUEST_MESSAGE message to
> > > > > provide a secure communication channel between a SNP VM and
> > > > > the PSP.
> > > > >
> > > > > The defined messages provide way to read TDI info and do secure
> > > > > MMIO/DMA setup.
> > > > >
> > > > > On top of this, GHCB defines an extension to return
> > > > > certificates/ measurements/report and TDI run status to the VM.
> > > > >
> > > > > The TIO_GUEST_MESSAGE handler also checks if a specific TDI
> > > > > bound to the VM and exits the KVM to allow the userspace to
> > > > > bind it.
> > > > >
> > > >
> > > > Out of curiosity, do we have to handle the TDI bind/unbind in the
> > > > kernel space? It seems we are get the relationship between
> > > > modules more complicated. What is the design concern that letting
> > > > QEMU to handle the TDI bind/unbind message, because QEMU can talk
> > > > to VFIO/KVM and also
> > > TSM.
> > > 
> > > Hmm, the flow I have in mind is:
> > > 
> > > Guest GHCx(BIND) => KVM => TSM GHCx handler => VFIO state update +
> > > TSM low-level BIND
> > > 
> > > vs this: (if I undertand your question correctly?)
> > > 
> > > Guest GHCx(BIND) => KVM => TSM GHCx handler => QEMU => VFIO => TSM
> > > low-level BIND
> > 
> > Reading this patch appears that it's implemented this way except QEMU
> > calls a KVM_DEV uAPI instead of going through VFIO (as Yilun
> > suggested).
> > 
> > > 
> > > Why exit to QEMU only to turn around and call back into the kernel?
> > > VFIO should already have the context from establishing the vPCI
> > > device as "bind-capable" at setup time.

Previously we tried to do host side "bind-capable" setup (TDI context
creation required by firmware but no LOCK) at setup time. But didn't
see enough value, only to make the error recovery flow more complex. So
now I actually didn't see much work to do for "bind-capable", just to
mark the device as can-be-private. I.e. the context from establishing
the vPCI device are moved to GHCx BIND phase.

> > > 
> > 
> > The general practice in VFIO is to design things around userspace
> > driver control over the device w/o assuming the existence of KVM.
> > When VMM comes to the picture the interaction with KVM is minimized
> > unless for functional or perf reasons.
> > 
> > e.g. KVM needs to know whether an assigned device allows non-coherent
> > DMA for proper cache control, or mdev/new vIOMMU object needs
> > a reference to struct kvm, etc. 
> > 
> > sometimes frequent trap-emulates is too costly then KVM/VFIO may
> > enable in-kernel acceleration to skip Qemu via eventfd, but in 
> > this case the slow-path via Qemu has been firstly implemented.
> > 
> > Ideally BIND/UNBIND is not a frequent operation, so falling back to
> > Qemu in a longer path is not a real problem. If no specific
> > functionality or security reason for doing it in-kernel, I'm inclined
> > to agree with Zhi here (though not about complexity).

I agree GHCx BIND/UNBIND been routed to QEMU, cause there are host side
cross module managements for BIND/UNBIND. E.g. IOMMUFD page table
switching, VFIO side settings that builds host side TDI context & LOCK
TDI.

But I do support other GHCx calls between BIND/UNBIND been directly
route to TSM low-level. E.g. get device interface report, get device
certification/measurement, TDISP RUN. It is because these communications
are purely for CoCo-VM, firmware and TDI. Host is totally out of its
business and worth nothing to pass these requirements to QEMU/VFIO and
still back into TSM low-level.

Thanks,
Yilun

> > 
> > 
> 
> Exactly what I was thinking. Folks had been spending quite some efforts
> on keeping VFIO and KVM independent. The existing shortcut calling
> between two modules is there because there is no other better way to do
> it.
> 
> TSM BIND/UNBIND should not be a performance critical path. Thus falling
> back to QEMU would be fine. Besides, not sure about others' opinion, I
> don't think adding tsm_{bind, unbind} in kvm_x86_ops is a good idea.
> 
> If we have to stick to the current approach, I think we need more
> justifications.
> 

