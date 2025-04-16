Return-Path: <kvm+bounces-43474-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1CD6FA907EE
	for <lists+kvm@lfdr.de>; Wed, 16 Apr 2025 17:45:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8FF3B5A1152
	for <lists+kvm@lfdr.de>; Wed, 16 Apr 2025 15:45:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F59E20F06C;
	Wed, 16 Apr 2025 15:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b="CPx3J8+r"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-42ae.mail.infomaniak.ch (smtp-42ae.mail.infomaniak.ch [84.16.66.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 990D420D4E9
	for <kvm@vger.kernel.org>; Wed, 16 Apr 2025 15:45:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=84.16.66.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744818308; cv=none; b=sUsfFgZzZk3ALqPh7oQq7AekcUtyslksm/boJF6unIjrp5DuX8y6TG6E8roCsgftQXn6g3K/tdYg9fLN1RwrqwewlQXlN9s2erzu7lCUkqATDCQf7UmuIu+50UO4xcXXxa9Pe82NDmNNMk6IkbAvzsgpq5Bb5aXIGkGpH8KErYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744818308; c=relaxed/simple;
	bh=fAZO7Fa7jV+kYREsmNuqdJYFtwNwzzT0nKy+oP+3Fno=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=vBNnr1dELWWGya2MEbwZYzWsrvdAH2njg4Kw+xzZlhgt9btRF5IMHO3PcgfjCpNNQyaKRydaSfaLrZkLvtfJrtaQc0FtHovgg4692XmNOKqhmOzo6qoTmJjlmjUF1fOcS8wKF1eRnll0po9s6khZhk3/OyilU/T8copPy+lvqik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net; spf=pass smtp.mailfrom=digikod.net; dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b=CPx3J8+r; arc=none smtp.client-ip=84.16.66.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=digikod.net
Received: from smtp-3-0001.mail.infomaniak.ch (unknown [IPv6:2001:1600:4:17::246c])
	by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4Zd51z0MMBzXQr;
	Wed, 16 Apr 2025 17:44:55 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=digikod.net;
	s=20191114; t=1744818294;
	bh=VNzT8ZztgMzMVgyJuMBomyM+QeQmnFJJGsXoHwrUSGY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CPx3J8+rRA5zOicU2627y0zUqiODQSi85at4aUcNZ/Pn7TrJRrNsx2zwWkedu6yUq
	 aa5lmFcD23/vQeyPQDhXVvxLOx74R3c1oGaBjB9z48rhCj89uQ7NhX6SO2oDVRSmfb
	 UnBP/RPas3jAYxGs6Ef4d282gK6fV8X3mchSXgMI=
Received: from unknown by smtp-3-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4Zd51x4myzzm99;
	Wed, 16 Apr 2025 17:44:53 +0200 (CEST)
Date: Wed, 16 Apr 2025 17:44:52 +0200
From: =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>
To: Jon Kohler <jon@nutanix.com>
Cc: Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, "tglx@linutronix.de" <tglx@linutronix.de>, 
	"mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "x86@kernel.org" <x86@kernel.org>, 
	"hpa@zytor.com" <hpa@zytor.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Alexander Grest <Alexander.Grest@microsoft.com>, 
	Nicolas Saenz Julienne <nsaenz@amazon.es>, "Madhavan T . Venkataraman" <madvenka@linux.microsoft.com>, 
	Tao Su <tao1.su@linux.intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	Zhao Liu <zhao1.liu@intel.com>
Subject: Re: [RFC PATCH 00/18] KVM: VMX: Introduce Intel Mode-Based Execute
 Control (MBEC)
Message-ID: <20250416.peYa4autei9u@digikod.net>
References: <20250313203702.575156-1-jon@nutanix.com>
 <20250415.AegioKi3ioda@digikod.net>
 <A32D3985-4F3E-4839-BF1D-5674DE372741@nutanix.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <A32D3985-4F3E-4839-BF1D-5674DE372741@nutanix.com>
X-Infomaniak-Routing: alpha

On Tue, Apr 15, 2025 at 02:43:57PM +0000, Jon Kohler wrote:
> 
> 
> > On Apr 15, 2025, at 5:29 AM, Mickaël Salaün <mic@digikod.net> wrote:
> > 
> > !-------------------------------------------------------------------|
> >  CAUTION: External Email
> > 
> > |-------------------------------------------------------------------!
> > 
> > Hi,
> > 
> > This series looks good, just some inlined questions.
> 
> RE Inlined questions - Did you send those elsewhere? I didn’t
> see any others in my inbox, nor on lore.

No, I just wanted to highlight that you inserted questions in several
patches. :)

> 
> > Sean, Paolo, what do you think?
> > 
> > Jon, what is the status of the QEMU patches?
> 
> I was waiting for comments here before sending to mailing list, but
> I did post a link to the tree in the cover letter. The actual commit itself
> is wicked trivial, so knock on wood, I’d imagine that would be the easiest
> part of this endeavor.
> 
> Would you suggest I sent those to QEMU mailing list now, while kernel side
> is still in RFC? Happy to do so if that makes sense.
> 
> https://github.com/JonKohler/qemu/commit/7a245414a0138b83cabcb809f5585ef8b5f78553

You can wait until Sean gets a look at this series, but you don't need
to wait for it to be merged before starting a discussion with QEMU
developers.

