Return-Path: <kvm+bounces-32741-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 457039DB658
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 12:15:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0C1EE281644
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 11:15:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE371198822;
	Thu, 28 Nov 2024 11:15:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="p1sHVd2n";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="CYR8n5Xj"
X-Original-To: kvm@vger.kernel.org
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85F7684E1C;
	Thu, 28 Nov 2024 11:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732792524; cv=none; b=pb5AyF5ogPk5pfSq84337yuC+7VT08W2ULOx9/Dc4Z3bxu9GbofynXkOAoNy/wtg2zdLfEalrK3xcPKcEB40UCRLXmC+C/QpMP+Pm9Oic/vjDoaPIMc8NesuHGh+xKd4jFfwxP8o7wwwUT3Mjg7FWyxxHHcLW7duV4GmyMCMyGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732792524; c=relaxed/simple;
	bh=hc2eW85zH30ycpF7jG93e4JqdOgrxxqEdvi+gUlfo6k=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=pmC3aU6BMzEnw4nwdeoRBfXd3fJg6u8/0UoqaOlkeuSHHuEif/K+dirCn0WcI5vW9Zq34xSyMwYTbskxiAis6+zo8s5lfHUzF5M+wPMGjiCS9Ko2DZdgBX/+1ri8HlxU07/H1gxwNQTCi3wO8gxMNVlO1Ir92q8rusWyrv8JlBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=p1sHVd2n; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=CYR8n5Xj; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1732792520;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BepIv+zsVxwnGd+vRGJKobT/i3K2E0sdG4yWASd1NkE=;
	b=p1sHVd2nF4+Wcf895ouKTQQoSekm/Z0/pHKLqMXZfyVoZtPx8ito7bNXqvpFFTTrgsBGir
	z2WPrTjtm0R+7d4vtevK5z8bJb/Ic16GEiXqO0c2ssuAqKxgxC/+nTMGgX5EGx8eHVvEoQ
	1JnFUDIuFcG4BarV6+JuDFjT+9lmHDBA3++qPXTgD3L+zDK62nsydQfuF+FA0CM16Pob+S
	g6WljcbwJljkAvWZHAjAPwTnytNkqNEDAxaLlcGiAkNbZDS/dZMPL1RxbR7KBCAGBhPWJ2
	ZNZAHvN4yWTGwIlyiyYK1p26sLaYMeM/YRaoszgZLqIR4lg0ozZLDS0ZsIabAA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1732792520;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BepIv+zsVxwnGd+vRGJKobT/i3K2E0sdG4yWASd1NkE=;
	b=CYR8n5Xj31ApiPOAIzYejnuG5cbHitE/iV/uP91bN59JLrhalJuYwg4IpOGHOFgzhEcEJu
	BIP3cMUELs1sUDDg==
To: Jason Gunthorpe <jgg@nvidia.com>, Eric Auger <eric.auger@redhat.com>
Cc: Robin Murphy <robin.murphy@arm.com>, Alex Williamson
 <alex.williamson@redhat.com>, Nicolin Chen <nicolinc@nvidia.com>,
 maz@kernel.org, bhelgaas@google.com, leonro@nvidia.com,
 shameerali.kolothum.thodi@huawei.com, dlemoal@kernel.org,
 kevin.tian@intel.com, smostafa@google.com,
 andriy.shevchenko@linux.intel.com, reinette.chatre@intel.com,
 ddutile@redhat.com, yebin10@huawei.com, brauner@kernel.org,
 apatel@ventanamicro.com, shivamurthy.shastri@linutronix.de,
 anna-maria@linutronix.de, nipun.gupta@amd.com,
 marek.vasut+renesas@mailbox.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
 kvm@vger.kernel.org
Subject: Re: [PATCH RFCv1 0/7] vfio: Allow userspace to specify the address
 for each MSI vector
In-Reply-To: <20241120140337.GA772273@nvidia.com>
References: <cover.1731130093.git.nicolinc@nvidia.com>
 <a63e7c3b-ce96-47a5-b462-d5de3a2edb56@arm.com>
 <ZzPOsrbkmztWZ4U/@Asurada-Nvidia> <20241113013430.GC35230@nvidia.com>
 <20241113141122.2518c55a.alex.williamson@redhat.com>
 <2621385c-6fcf-4035-a5a0-5427a08045c8@arm.com>
 <66977090-d707-4585-b0c5-8b48f663827e@redhat.com>
 <20241120140337.GA772273@nvidia.com>
Date: Thu, 28 Nov 2024 12:15:20 +0100
Message-ID: <87frnby5h3.ffs@tglx>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 20 2024 at 10:03, Jason Gunthorpe wrote:
> On Wed, Nov 20, 2024 at 02:17:46PM +0100, Eric Auger wrote:
>> > Yeah, I wasn't really suggesting to literally hook into this exact
>> > case; it was more just a general observation that if VFIO already has
>> > one justification for tinkering with pci_write_msi_msg() directly
>> > without going through the msi_domain layer, then adding another
>> > (wherever it fits best) can't be *entirely* unreasonable.
>
> I'm not sure that we can assume VFIO is the only thing touching the
> interrupt programming.

Correct.

> I think there is a KVM path, and also the /proc/ path that will change
> the MSI affinity on the fly for a VFIO created IRQ. If the platform
> requires a MSI update to do this (ie encoding affinity in the
> add/data, not using IRQ remapping HW) then we still need to ensure the
> correct MSI address is hooked in.

Yes.

>> >> Is it possible to do this with the existing write_msi_msg callback on
>> >> the msi descriptor?=C2=A0 For instance we could simply translate the =
msg
>> >> address and call pci_write_msi_msg() (while avoiding an infinite
>> >> recursion).=C2=A0 Or maybe there should be an xlate_msi_msg callback =
we can
>> >> register.=C2=A0 Or I suppose there might be a way to insert an irqchi=
p that
>> >> does the translation on write.=C2=A0 Thanks,
>> >
>> > I'm far from keen on the idea, but if there really is an appetite for
>> > more indirection, then I guess the least-worst option would be yet
>> > another type of iommu_dma_cookie to work via the existing
>> > iommu_dma_compose_msi_msg() flow,=20
>
> For this direction I think I would turn iommu_dma_compose_msi_msg()
> into a function pointer stored in the iommu_domain and have
> vfio/iommufd provide its own implementation. The thing that is in
> control of the domain's translation should be providing the msi_msg.

Yes. The resulting cached message should be writeable as is.

>> > update per-device addresses direcitly. But then it's still going to
>> > need some kind of "layering violation" for VFIO to poke the IRQ layer
>> > into re-composing and re-writing a message whenever userspace feels
>> > like changing an address
>
> I think we'd need to get into the affinity update path and force a MSI
> write as well, even if the platform isn't changing the MSI for
> affinity. Processing a vMSI entry update would be two steps where we
> update the MSI addr in VFIO and then set the affinity.

The affinity callback of the domain/chip can return IRQ_SET_MASK_OK_DONE
which prevents recomposing and writing the message.

So you want a explicit update/write of the message similar to what
msi_domain_activate() does.

Thanks,

        tglx

