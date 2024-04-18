Return-Path: <kvm+bounces-15120-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 24F198AA112
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 19:31:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 52A191C20B54
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 17:31:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D655D175544;
	Thu, 18 Apr 2024 17:30:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="JaPzhGeU";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="usvJW0EI"
X-Original-To: kvm@vger.kernel.org
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFEA0171092;
	Thu, 18 Apr 2024 17:30:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713461458; cv=none; b=ro+279j8OIsgCrQrEhjUQLmRRGZlQes7a6wRgdXLpPwgtMDRUB/1XBu9aEZ4mSTiQTZBuvIdl1MhjSth/1vuYSV1gftNWVGRX/BBmv52cr74/2Nd/bzV07q+AEpj64f1IyZEbg7OTo+H43G4frSUGgQTN8ZJ4Oqyj0vx/3uTGgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713461458; c=relaxed/simple;
	bh=o01ymuKifh+K0Qu307eSX0ERloFE9BsY+DcrAJ29XVM=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=t7BTdSfEhCiinMaaJgSK+cQ7E63nciFz0pJf+3wY3TQBlf/xha794iT12iT+PQx3SsVpfwCZJ08U9OIsftMm7SLeTNRHuzOT61pbP+U5pkhE0IGOReduJIy8XJgM0/9jk/ORN1CZI0rnloZLJQiHAzF6Oo9TRSubIFSFL8Y1psQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=JaPzhGeU; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=usvJW0EI; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1713461454;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=n133tZXDB6Bd91GvCflFVAWL+NU2byLCtgDyzJMIL+U=;
	b=JaPzhGeUkDR0xJWNGEOZX6QlTvHj+laTe+Gb7LSuFrynIBfCTbrdk02GsZUHBPUa3MxyH7
	Ja4MJ4n94Wesjd3qChowGdMXyBLVyaAMDZ3OduoZddQ/d4am634dGPFU4lNxcEAlIj98mL
	0NbXX4yhuiMnTKA77HYiqgxXJKJ4t5IQHMSac/KT5csV6NB8Frzw++e9VD8bKNu83l8SPy
	Ru8PhXlzhAo/MpRAM7QnQwEyYuFHP3GVdBN7o7ktbq/dH5EbjprkQMSaRfw3RDJAx0ZJG1
	bwodGvkjdU78nLkjnjYed1D6mBhcCtlJywIJA0ljhdOK6ikUpRbkvJO85Yl7jg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1713461454;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=n133tZXDB6Bd91GvCflFVAWL+NU2byLCtgDyzJMIL+U=;
	b=usvJW0EICUWJjhC/qhtiJVBvvnPiIIv+LS4QdG+QAWCzmyg+6eR2HBrklesFtjER9a/45F
	7OSjfw5XMeZQdJCg==
To: Jacob Pan <jacob.jun.pan@linux.intel.com>, Sean Christopherson
 <seanjc@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, X86 Kernel <x86@kernel.org>, Peter
 Zijlstra <peterz@infradead.org>, iommu@lists.linux.dev, Lu Baolu
 <baolu.lu@linux.intel.com>, kvm@vger.kernel.org, Dave Hansen
 <dave.hansen@intel.com>, Joerg Roedel <joro@8bytes.org>, "H. Peter Anvin"
 <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>, Ingo Molnar
 <mingo@redhat.com>, Paul Luse <paul.e.luse@intel.com>, Dan Williams
 <dan.j.williams@intel.com>, Jens
 Axboe <axboe@kernel.dk>, Raj Ashok <ashok.raj@intel.com>, Kevin Tian
 <kevin.tian@intel.com>, maz@kernel.org, Robin Murphy
 <robin.murphy@arm.com>, jim.harris@samsung.com, a.manzanares@samsung.com,
 Bjorn Helgaas <helgaas@kernel.org>, guang.zeng@intel.com,
 robert.hoo.linux@gmail.com, jacob.jun.pan@linux.intel.com,
 oliver.sang@intel.com
Subject: Re: [PATCH v2 03/13] x86/irq: Remove bitfields in posted interrupt
 descriptor
In-Reply-To: <20240417110131.4aaf1d66@jacob-builder>
References: <20240405223110.1609888-1-jacob.jun.pan@linux.intel.com>
 <20240405223110.1609888-4-jacob.jun.pan@linux.intel.com>
 <Zh8aTitLwSYYlZW5@google.com> <20240417110131.4aaf1d66@jacob-builder>
Date: Thu, 18 Apr 2024 19:30:52 +0200
Message-ID: <87wmouy3w3.ffs@tglx>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Wed, Apr 17 2024 at 11:01, Jacob Pan wrote:
> On Tue, 16 Apr 2024 17:39:42 -0700, Sean Christopherson <seanjc@google.com>
> wrote:
>> > diff --git a/arch/x86/kvm/vmx/posted_intr.c
>> > b/arch/x86/kvm/vmx/posted_intr.c index af662312fd07..592dbb765675 100644
>> > --- a/arch/x86/kvm/vmx/posted_intr.c
>> > +++ b/arch/x86/kvm/vmx/posted_intr.c
>> > @@ -107,7 +107,7 @@ void vmx_vcpu_pi_load(struct kvm_vcpu *vcpu, int
>> > cpu)
>> >  		 * handle task migration (@cpu != vcpu->cpu).
>> >  		 */
>> >  		new.ndst = dest;
>> > -		new.sn = 0;
>> > +		new.notif_ctrl &= ~POSTED_INTR_SN;  
>> 
>> At the risk of creating confusing, would it make sense to add
>> double-underscore, non-atomic versions of the set/clear helpers for ON
>> and SN?
>> 
>> I can't tell if that's a net positive versus open coding clear() and
>> set() here and below.
> IMHO, we can add non-atomic helpers when we have more than one user for
> each operation.
>
> I do have a stupid bug here, it should be:
> -               new.notif_ctrl &= ~POSTED_INTR_SN;
> +               new.notif_ctrl &= ~BIT(POSTED_INTR_SN);

That's a perfect reason to use a proper helper.

