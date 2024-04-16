Return-Path: <kvm+bounces-14902-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6CF0C8A778D
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 00:11:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 834271C21AF0
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 22:11:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB90884E1A;
	Tue, 16 Apr 2024 22:11:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DnbmLz0s"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C628984DED;
	Tue, 16 Apr 2024 22:11:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713305475; cv=none; b=FtaEc6DJm+JllDxbLR6fb8Htyjb3GNkdXd8IxlKWWXiNLNOuTMtTwsu6CqrqTasHMQyjb/lknj/3/0S13a4cN8/DO1mrYqedQaW1ibbq8WX9YWAW7VLKRI16gmQkG29E1lmnfeC2v3/qcxavajFfjDxWl9KiUXpxeHn5Tjzg6S0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713305475; c=relaxed/simple;
	bh=rdpsXIWGDG4PvT893grQx+rL878rDudcA5OJ2YWiugA=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Jq6evJSgj8w6LZcP8HPv5fwjvCi5J7IP/wS20xN6t/nF8oSH7tz9qKLT9C5CQgsohagpZinJPRUfLGWB3cmx4+XET/LIIIBce+eMuyho4kcYl7v37enrSqonUcAkSXoa/jNm8X4HR9onJTHcz77svKkfBSB+6gPvXYHkAKHhfM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DnbmLz0s; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713305474; x=1744841474;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rdpsXIWGDG4PvT893grQx+rL878rDudcA5OJ2YWiugA=;
  b=DnbmLz0sIaJCmIiAdcoqj0SC/n7hhg6kVSTlRmSbyVlrsAzdulVbcNpf
   3tr6LcrNAxHS9Xdzt4N4nwV2PbmDDQVJBAcp9p5ZTCgzvpumOlP2M7UFf
   PMLJp80ywz7IQyWPUiMWH3mTjVKDItPYpZakPM9nT9Rwmwyj5XVbIjwyG
   V1ob1OnZf3lzLYzPZ7WWZs6F69Vm/zbzPoN1wyMHeNzWlMcmZDFA6J5DW
   LfLh96sFunUmGBe5/t+7htlpSYqrnHCMOgXU9NyQGnpnWZu1Q++fM73DF
   ca++N3RNVYEamiGx9+Ew5uIClf4pjI2lBn0mnekcrJ+gjiNQFf6Lb2lbk
   w==;
X-CSE-ConnectionGUID: Xx1lQBwvS2CNAy/JbWq3OA==
X-CSE-MsgGUID: hmCokJaCSqaQgxSKhVCXxA==
X-IronPort-AV: E=McAfee;i="6600,9927,11046"; a="19379750"
X-IronPort-AV: E=Sophos;i="6.07,207,1708416000"; 
   d="scan'208";a="19379750"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2024 15:11:13 -0700
X-CSE-ConnectionGUID: aOB0hx/ZTfejf2l/oBjZZA==
X-CSE-MsgGUID: pDbsOPGDQQKNgY3FIPHMFw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,207,1708416000"; 
   d="scan'208";a="22884358"
Received: from jacob-builder.jf.intel.com (HELO jacob-builder) ([10.54.39.125])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2024 15:11:12 -0700
Date: Tue, 16 Apr 2024 15:15:46 -0700
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: "Tian, Kevin" <kevin.tian@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, X86 Kernel <x86@kernel.org>, Peter
 Zijlstra <peterz@infradead.org>, "iommu@lists.linux.dev"
 <iommu@lists.linux.dev>, Thomas Gleixner <tglx@linutronix.de>, Lu Baolu
 <baolu.lu@linux.intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "Hansen, Dave" <dave.hansen@intel.com>, Joerg Roedel <joro@8bytes.org>, "H.
 Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>, Ingo Molnar
 <mingo@redhat.com>, "Luse, Paul E" <paul.e.luse@intel.com>, "Williams, Dan
 J" <dan.j.williams@intel.com>, Jens Axboe <axboe@kernel.dk>, "Raj, Ashok"
 <ashok.raj@intel.com>, "maz@kernel.org" <maz@kernel.org>,
 "seanjc@google.com" <seanjc@google.com>, Robin Murphy
 <robin.murphy@arm.com>, "jim.harris@samsung.com" <jim.harris@samsung.com>,
 "a.manzanares@samsung.com" <a.manzanares@samsung.com>, Bjorn Helgaas
 <helgaas@kernel.org>, "Zeng, Guang" <guang.zeng@intel.com>,
 "robert.hoo.linux@gmail.com" <robert.hoo.linux@gmail.com>,
 jacob.jun.pan@linux.intel.com
Subject: Re: [PATCH v2 12/13] iommu/vt-d: Add an irq_chip for posted MSIs
Message-ID: <20240416151546.31a539e8@jacob-builder>
In-Reply-To: <BN9PR11MB5276051CAD86374C666ACFD48C042@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240405223110.1609888-1-jacob.jun.pan@linux.intel.com>
	<20240405223110.1609888-13-jacob.jun.pan@linux.intel.com>
	<BN9PR11MB5276051CAD86374C666ACFD48C042@BN9PR11MB5276.namprd11.prod.outlook.com>
Organization: OTC
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi Kevin,

On Fri, 12 Apr 2024 09:36:10 +0000, "Tian, Kevin" <kevin.tian@intel.com>
wrote:

> > From: Jacob Pan <jacob.jun.pan@linux.intel.com>
> > Sent: Saturday, April 6, 2024 6:31 AM
> >=20
> > + *
> > + * For the example below, 3 MSIs are coalesced into one CPU
> > notification. Only
> > + * one apic_eoi() is needed.
> > + *
> > + * __sysvec_posted_msi_notification()
> > + *	irq_enter();
> > + *		handle_edge_irq()
> > + *			irq_chip_ack_parent()
> > + *				dummy(); // No EOI
> > + *			handle_irq_event()
> > + *				driver_handler()
> > + *	irq_enter();
> > + *		handle_edge_irq()
> > + *			irq_chip_ack_parent()
> > + *				dummy(); // No EOI
> > + *			handle_irq_event()
> > + *				driver_handler()
> > + *	irq_enter();
> > + *		handle_edge_irq()
> > + *			irq_chip_ack_parent()
> > + *				dummy(); // No EOI
> > + *			handle_irq_event()
> > + *				driver_handler() =20
>=20
> typo: you added three irq_enter()'s here
right, will remove the middle two.

>=20
> > + *	apic_eoi()
> > + * irq_exit()
> > + */
> > +static struct irq_chip intel_ir_chip_post_msi =3D {
> > +	.name			=3D "INTEL-IR-POST",
> > +	.irq_ack		=3D dummy,
> > +	.irq_set_affinity	=3D intel_ir_set_affinity,
> > +	.irq_compose_msi_msg	=3D intel_ir_compose_msi_msg,
> > +	.irq_set_vcpu_affinity	=3D intel_ir_set_vcpu_affinity,
> > +}; =20
>=20
> What about putting this patch at end of the series (combining the
> change in intel_irq_remapping_alloc()) to finally enable this
> feature?
>=20
> It reads slightly better to me to first get those callbacks extended
> to deal with the new mechanism (i.e. most changes in patch13)
> before using them in the new irqchip. =F0=9F=98=8A

makes sense, will do.

Thanks,

Jacob

