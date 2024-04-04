Return-Path: <kvm+bounces-13590-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 41387898D3F
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 19:33:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6417B1C27639
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 17:33:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1DE012DDBF;
	Thu,  4 Apr 2024 17:33:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gLSSquWR"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A4D812AAE8;
	Thu,  4 Apr 2024 17:33:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712251996; cv=none; b=phRHDMPYb5m0wWvH9H11/F/98+FvOHvSxgBK1HAZo8KFMhZEsOPenVcj4acPStpD0hFcfSeGpJocuiwtzz+lEutXknqGMHZ/o0VP+epZvNM0ZuZpoSkj0HKe+ipQcMhQToUNDALmWm+LAQ04+SKZmZzHgENSd+o8sOJvuj4HsVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712251996; c=relaxed/simple;
	bh=WhycKvDs8Nm0e2yE6FewUWSMhX4pZiW2qepdqQnqjQU=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sAZUh9SJZkEoFU+9+mN3oU3m8YC8wE2SrAmPC6Nk98lRs6aZ6vie7UkAuINZnzEleTU+KgMCcs9miagB4vnFq4AxwwhT9vPG47HDEWsUwdtLhpKn2XgHDwj9Qrba3QSE9IFB9ciOOiY0OfHKOXEPrlmEgj13g48DKUfZ7cYvBeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gLSSquWR; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712251995; x=1743787995;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=WhycKvDs8Nm0e2yE6FewUWSMhX4pZiW2qepdqQnqjQU=;
  b=gLSSquWRbOk30KJOLa1Pxfr+fIXQGvKqAm1+bWUcE3J723rn7DVOLihZ
   upoXGlliFQ1XKgOuuKNn1JMjaM52YLSwRkIKwJBIgA3uKFlg0J1O1DWaY
   6JziuEH437sZ0afJ+qBr+VVBjoA3G851z3ARjIaYbj71EoU6OHXC+bh7+
   StT7knzN8Lxeqz7b58c3o2ageC6dtfw/44AFr3p5Ny+K+lvTvky6c/4SX
   bbuTPU4F16Vp99CNrk58ULrsmX1BCv0uzvjzoBs+KJcjM7d41uu2iwbtc
   2bsp0Yjdpk8XrzNp/iUoqjgj9NOprBZlMBq5mcW2hxVAFnjHLaf2rQ3lE
   Q==;
X-CSE-ConnectionGUID: 15L8qycaRnSAtoLa8Dqq2g==
X-CSE-MsgGUID: bsmX5D5xQduy/bQKQwNrWw==
X-IronPort-AV: E=McAfee;i="6600,9927,11034"; a="7709650"
X-IronPort-AV: E=Sophos;i="6.07,179,1708416000"; 
   d="scan'208";a="7709650"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Apr 2024 10:33:09 -0700
X-CSE-ConnectionGUID: TuJmPMI7T6u58LeAAqTTfg==
X-CSE-MsgGUID: ximBQxIZSoGR85aXhPDCVQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,179,1708416000"; 
   d="scan'208";a="23356605"
Received: from jacob-builder.jf.intel.com (HELO jacob-builder) ([10.54.39.125])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Apr 2024 10:33:08 -0700
Date: Thu, 4 Apr 2024 10:37:35 -0700
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: Robert Hoo <robert.hoo.linux@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, X86 Kernel <x86@kernel.org>, Peter
 Zijlstra <peterz@infradead.org>, iommu@lists.linux.dev, Thomas Gleixner
 <tglx@linutronix.de>, Lu Baolu <baolu.lu@linux.intel.com>,
 kvm@vger.kernel.org, Dave Hansen <dave.hansen@intel.com>, Joerg Roedel
 <joro@8bytes.org>, "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov
 <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>, Paul Luse
 <paul.e.luse@intel.com>, Dan Williams <dan.j.williams@intel.com>, Jens
 Axboe <axboe@kernel.dk>, Raj Ashok <ashok.raj@intel.com>, "Tian, Kevin"
 <kevin.tian@intel.com>, maz@kernel.org, seanjc@google.com, Robin Murphy
 <robin.murphy@arm.com>, jacob.jun.pan@linux.intel.com, Bjorn Helgaas
 <helgaas@kernel.org>
Subject: Re: [PATCH 00/15] Coalesced Interrupt Delivery with posted MSI
Message-ID: <20240404103735.003ed5a3@jacob-builder>
In-Reply-To: <fe40498a-3bb2-43c6-b3e2-1e4e10205db1@gmail.com>
References: <20240126234237.547278-1-jacob.jun.pan@linux.intel.com>
	<fe40498a-3bb2-43c6-b3e2-1e4e10205db1@gmail.com>
Organization: OTC
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Robert,

On Thu, 4 Apr 2024 21:45:05 +0800, Robert Hoo <robert.hoo.linux@gmail.com>
wrote:

> On 1/27/2024 7:42 AM, Jacob Pan wrote:
> > Hi Thomas and all,
> >=20
> > This patch set is aimed to improve IRQ throughput on Intel Xeon by
> > making use of posted interrupts.
> >=20
> > There is a session at LPC2023 IOMMU/VFIO/PCI MC where I have presented
> > this topic.
> >=20
> > https://lpc.events/event/17/sessions/172/#20231115
> >=20
> > Background
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > On modern x86 server SoCs, interrupt remapping (IR) is required and
> > turned on by default to support X2APIC. Two interrupt remapping modes
> > can be supported by IOMMU/VT-d:
> >=20
> > - Remappable 	(host)
> > - Posted	(guest only so far)
> >=20
> > With remappable mode, the device MSI to CPU process is a HW flow
> > without system software touch points, it roughly goes as follows:
> >=20
> > 1.	Devices issue interrupt requests with writes to 0xFEEx_xxxx
> > 2.	The system agent accepts and remaps/translates the IRQ
> > 3.	Upon receiving the translation response, the system agent
> > notifies the destination CPU with the translated MSI
> > 4.	CPU's local APIC accepts interrupts into its IRR/ISR registers
> > 5.	Interrupt delivered through IDT (MSI vector)
> >=20
> > The above process can be inefficient under high IRQ rates. The
> > notifications in step #3 are often unnecessary when the destination CPU
> > is already overwhelmed with handling bursts of IRQs. On some
> > architectures, such as Intel Xeon, step #3 is also expensive and
> > requires strong ordering w.r.t DMA.  =20
>=20
> Can you tell more on this "step #3 requires strong ordering w.r.t. DMA"?
>=20
I am not sure how much micro architecture details I can disclose but the
point is that there are ordering rules related to DMA read/writes
and posted MSI writes. I am not a hardware expert.

=46rom PCIe pov, my understanding is that the upstream writes tested here on
NVMe drives as the result of 4K random reads are relaxed ordered. I can see
lspci showing: RlxdOrd+ on my Samsung drives.

DevCtl: CorrErr+ NonFatalErr+ FatalErr+ UnsupReq-
                        RlxdOrd+ ExtTag+ PhantFunc- AuxPwr- NoSnoop+ FLRese=
t-
                        MaxPayload 512 bytes, MaxReadReq 4096 bytes

But MSIs are strictly ordered afaik.

> > As a result, slower
> > IRQ rates can become a limiting factor for DMA I/O performance.
> >  =20
>=20
>=20


Thanks,

Jacob

