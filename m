Return-Path: <kvm+bounces-49961-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id F203DAE025A
	for <lists+kvm@lfdr.de>; Thu, 19 Jun 2025 12:06:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D6FB31BC3532
	for <lists+kvm@lfdr.de>; Thu, 19 Jun 2025 10:06:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4A3E2222BE;
	Thu, 19 Jun 2025 10:06:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rPRpGmTk"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02AA6221546;
	Thu, 19 Jun 2025 10:06:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750327573; cv=none; b=F+UbabH8NpYNBJcBbcOYChi+VHSD7lGO69bauvN9Ui7x+ig4/nJ9EsPfCrciwOX2KZytcc0dOHwnnS+5UmcV+YKsCYtBuSUQ6pNwj35eF4JN4nzS5rTLABeKTmeDS3U3RHyeW0NTDHgh0qi7t4KDE4QRbjg+wrNDd5nYzhEo4q4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750327573; c=relaxed/simple;
	bh=dE+h7rh7tiZM8297BPSLUIsYW0VQEHR8+t5nyCcR9ao=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U+BORebNNMf62clSMBM6kXjy+5eptNHC86RpXcJO552OqgzVcM6AIypmfMqjKVXnpZv63Ikz+X/3AvwklKzIyVVzycY6b788n4bMdMWhvLIODyNbKmm8+bMpGUsJwZXsuYM3DLcEXbIaSi4HD8TMpxB0LljOthuu8Tb6uenGsRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rPRpGmTk; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB910C4CEEA;
	Thu, 19 Jun 2025 10:06:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750327572;
	bh=dE+h7rh7tiZM8297BPSLUIsYW0VQEHR8+t5nyCcR9ao=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rPRpGmTkJbGH84h6vCnBwUL3obIMt77yCA7GBV3mjduAB8wRvTExBNRvuZCNDUPtN
	 f6Tk492HURP7GzskGsbqqwvhE6C0mTy53gm9BvJsNQhhRqc2n+8TG4p6gN82xWjZrv
	 LH45zKZ6hzPflyjmzrowOru3Jvs7f62jN4om4osmKuIawj/jwAS9AApudzV0dbZEPg
	 84EHBpUOe7vW3tbph8HkKwzzy3zgzmrEhI242VkV9WC7128BqDs+yEmoccnYocDXw/
	 XiQUe3xSwSX6jILHt76cjGbSoa+J8nBxcGhia1zLasf691ZPYcBVHEoXjqzgeituZd
	 lxDKVv841YBMw==
Date: Thu, 19 Jun 2025 15:35:07 +0530
From: Naveen N Rao <naveen@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>, 
	Kai Huang <kai.huang@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "vkuznets@redhat.com" <vkuznets@redhat.com>
Subject: Re: [PATCH 11/15] KVM: x86: Add CONFIG_KVM_IOAPIC to allow disabling
 in-kernel I/O APIC
Message-ID: <qus75blxbosrfohbbies4cqlwcmli2ofbmaoqfhcrkuyzeyiek@44rldpbnngeq>
References: <20250519232808.2745331-1-seanjc@google.com>
 <20250519232808.2745331-12-seanjc@google.com>
 <d131524927ffe1ec70300296343acdebd31c35b3.camel@intel.com>
 <019c1023c26e827dc538f24d885ec9a8530ad4af.camel@intel.com>
 <aDhvs1tXH6pv8MxN@google.com>
 <58a580b0f3274f6a7bba8431b2a6e6fef152b237.camel@intel.com>
 <aDjo16EcJiWx9Nfa@google.com>
 <2667fad4-3635-413b-87a9-26cb6102ffab@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2667fad4-3635-413b-87a9-26cb6102ffab@redhat.com>

[Sorry for bumping an old thread]

On Wed, Jun 04, 2025 at 06:54:44PM +0200, Paolo Bonzini wrote:
> On 5/30/25 01:08, Sean Christopherson wrote:
> > On Thu, May 29, 2025, Kai Huang wrote:
> > > On Thu, 2025-05-29 at 07:31 -0700, Sean Christopherson wrote:
> > > > On Thu, May 29, 2025, Kai Huang wrote:
> > > > > On Thu, 2025-05-29 at 23:55 +1200, Kai Huang wrote:
> > > > > > Do they only support userspace IRQ chip, or not support any IRQ chip at all?
> > > > 
> > > > The former, only userspace I/O APIC (and associated devices), though some VM
> > > > shapes, e.g. TDX, don't provide an I/O APIC or PIC.
> > > 
> > > Thanks for the info.
> > > 
> > > Just wondering what's the benefit of using userspace IRQCHIP instead of
> > > emulating in the kernel?
> > 
> > Reduced kernel attack surface (this was especially true years ago, before KVM's
> > I/O APIC emulation was well-tested) and more flexibility (e.g. shipping userspace
> > changes is typically easier than shipping new kernels.  I'm pretty sure there's
> > one more big one that I'm blanking on at the moment.
> 
> Feature-wise, the big one is support for IRQ remapping which is not
> implemented in the in-kernel IOAPIC.

Is there a reason to prefer the in-kernel IOAPIC today, seeing as it is 
still the default with Qemu?


Thanks,
Naveen


