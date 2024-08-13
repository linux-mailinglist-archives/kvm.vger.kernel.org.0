Return-Path: <kvm+bounces-24049-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 939E5950B79
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 19:30:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5566F286154
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 17:30:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BA021A2C23;
	Tue, 13 Aug 2024 17:30:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="Mt41DhNp";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="UUeC+kSb"
X-Original-To: kvm@vger.kernel.org
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F9AC282E5;
	Tue, 13 Aug 2024 17:30:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723570245; cv=none; b=Xt1Ns9gD22GAEUktGUEoyfciEvPxr4QN2x53ylxD8IxRjNDVvr0gVoGp7e6SQllUx1MGv8snA6t9U9+IGuKv8DTGpQldJmV5iPYLw+4JUWWRjv3+tmD5mM5FE0BHYiFRYlfz7p1R4OBXYWu2E9RNtUBDoCQeKoMwOlAljoQDan8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723570245; c=relaxed/simple;
	bh=CgPGSw4BGQN7J8xvALSQIjXECj3FjxVzt0UM38Sz2A4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=fm/iqNU8IgMIcVwpSFH2UgiXaI/llorfe0xNudh+5CyGb1b9VjSsEwLTXIER9tCHA8D38VGCjhNF8HC4SYsPoAK5qMFlnoPmy5nnrNR63h/AMx1cDkCl+2NB9Y2IbM/o57ebcUuFyMMY3ZE4nUGyxqbjpGuvOiVO4WYYP2bi4dg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=Mt41DhNp; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=UUeC+kSb; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1723570241;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nLYNakiS7XZO9BB9N7Fyevs65e05aWL1XGxAXFuVTVk=;
	b=Mt41DhNpxne5dyvSWgRTV6r+1D1ctf2j+254poZWoREb4GDghU04Y2szQGHLkI3gN7t4kM
	v6wEkhb2pXN7567WzcsGBuMdCtGXkJwAmFVkrHczTaZuaDXITsJfa20vPfdyK0kksWotLb
	c8Khw3bmVQBOyfxb/Qx5CnNyyZwU0Jl6DrVXgq5G//8pgMvoSFPBeDntPX/Sq1bqmLAfFi
	3uc9S/l86hXzj0IgNLXdAD3y/0sl6+VKbknoEx/OnamdPsNtVl227kKLOgMbIKDWedXBPD
	N2871RW+cIpw9nXcr5qrvIkzDDnToTwCEya6tLvbvzJdNnpGI4+cSYznQXAAsQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1723570241;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nLYNakiS7XZO9BB9N7Fyevs65e05aWL1XGxAXFuVTVk=;
	b=UUeC+kSbV/jkQoPN5g2XCYL6IeWXke547KIvgCJIkeRYW1M/RBV5YV7R8JmQCcz7gS6exg
	20LAmw5r7AVtNzCg==
To: Jason Gunthorpe <jgg@ziepe.ca>, Alex Williamson
 <alex.williamson@redhat.com>
Cc: kvm@vger.kernel.org, quic_bqiang@quicinc.com, kvalo@kernel.org,
 prestwoj@gmail.com, linux-wireless@vger.kernel.org,
 ath11k@lists.infradead.org, dwmw2@infradead.org, iommu@lists.linux.dev,
 kernel@quicinc.com, johannes@sipsolutions.net, jtornosm@redhat.com
Subject: Re: [PATCH RFC/RFT] vfio/pci: Create feature to disable MSI
 virtualization
In-Reply-To: <20240813163053.GK1985367@ziepe.ca>
References: <adcb785e-4dc7-4c4a-b341-d53b72e13467@gmail.com>
 <20240812170014.1583783-1-alex.williamson@redhat.com>
 <20240813163053.GK1985367@ziepe.ca>
Date: Tue, 13 Aug 2024 19:30:41 +0200
Message-ID: <87r0aspby6.ffs@tglx>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Tue, Aug 13 2024 at 13:30, Jason Gunthorpe wrote:
> On Mon, Aug 12, 2024 at 10:59:12AM -0600, Alex Williamson wrote:
>> vfio-pci has always virtualized the MSI address and data registers as
>> MSI programming is performed through the SET_IRQS ioctl.  Often this
>> virtualization is not used, and in specific cases can be unhelpful.
>> 
>> One such case where the virtualization is a hinderance is when the
>> device contains an onboard interrupt controller programmed by the guest
>> driver.  Userspace VMMs have a chance to quirk this programming,
>> injecting the host physical MSI information, but only if the userspace
>> driver can get access to the host physical address and data registers.
>> 
>> This introduces a device feature which allows the userspace driver to
>> disable virtualization of the MSI capability address and data registers
>> in order to provide read-only access the the physical values.
>
> Personally, I very much dislike this. Encouraging such hacky driver
> use of the interrupt subsystem is not a good direction. Enabling this
> in VMs will further complicate fixing the IRQ usages in these drivers
> over the long run.
>
> If the device has it's own interrupt sources then the device needs to
> create an irq_chip and related and hook them up properly. Not hackily
> read the MSI-X registers and write them someplace else.
>
> Thomas Gleixner has done alot of great work recently to clean this up.
>
> So if you imagine the driver is fixed, then this is not necessary.

Yes. I looked at the at11k driver when I was reworking the PCI/MSI
subsystem and that's a perfect candidate for a proper device specific
interrupt domain to replace the horrible MSI hackery it has.

> Howver, it will still not work in a VM. Making IMS and non-MSI
> interrupt controlers work within VMs is still something that needs to
> be done.

Sure, but we really want to do that in a generic way and not based on ad
hoc workarounds.

Did the debate around this go anywhere?

Thanks,

        tglx

