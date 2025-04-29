Return-Path: <kvm+bounces-44719-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CEE83AA05E8
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 10:38:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 844CA4A05B7
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 08:38:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0EAAB293453;
	Tue, 29 Apr 2025 08:38:22 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08F852367C1
	for <kvm@vger.kernel.org>; Tue, 29 Apr 2025 08:38:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745915901; cv=none; b=AFPG4nM7Rzmdq4qux8SOLg0Yi+nFIIIme2lWj1FVY3O79R46M5omgl3kiIUQXaRZxGp6msmlKNsYetHaUiY444TMKTUkYxFvoVNXUlBCrYaBrvOe4m5mJFJ8/pjmyDuyn6JzZf22/mC9ACQSHgPhImZpCxhdbXPN6ffB7/pyAVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745915901; c=relaxed/simple;
	bh=qmVpBr5s9HUsn8RwSJ69aXCeue4NNN2woKyEEuyNnOE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OTkygJxVeawHHRowdAj05Uttv520O0vQeYQjxS47U4deH6Y/DhUhuIbGRSceP1YaPFg7aP1JvEFxFv+yWNIZU+yO8JHevZTWXRIKICMK9kEp6lZyWhljkGLqIVc6O7k5rZ0xVMkXO7W6T+4e5mrEaESbBXgRID8UtrQ1X0JTqXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 374C51515;
	Tue, 29 Apr 2025 01:38:11 -0700 (PDT)
Received: from arm.com (e134078.arm.com [10.1.36.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5DAAB3F66E;
	Tue, 29 Apr 2025 01:38:16 -0700 (PDT)
Date: Tue, 29 Apr 2025 09:38:12 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: kvm@vger.kernel.org, Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Steven Price <steven.price@arm.com>, Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>
Subject: Re: [PATCH kvmtool v3 2/3] cpu: vmexit: Retry KVM_RUN ioctl on EINTR
 and EAGAIN
Message-ID: <aBCP9MjXWDZFMoHW@arm.com>
References: <20250428115745.70832-1-aneesh.kumar@kernel.org>
 <20250428115745.70832-3-aneesh.kumar@kernel.org>
 <aA+dIAof4faNGjCf@arm.com>
 <yq5abjsfvdsx.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq5abjsfvdsx.fsf@kernel.org>

Hi Anessh,

On Tue, Apr 29, 2025 at 09:07:02AM +0530, Aneesh Kumar K.V wrote:
> Alexandru Elisei <alexandru.elisei@arm.com> writes:
> 
> > Hi Aneesh,
> >
> > Is this to fix Will's report that the series breaks boot on x86?
> >
> 
> Yes.
> 
> > On Mon, Apr 28, 2025 at 05:27:44PM +0530, Aneesh Kumar K.V (Arm) wrote:
> >> When KVM_RUN fails with EINTR or EAGAIN, we should retry the ioctl
> >> without checking kvm_run->exit_reason. These errors don't indicate a
> >> valid VM exit, hence exit_reason may contain stale or undefined values.
> >
> > EAGAIN is not documented in Documentation/virt/kvm/api.rst. So I'm going to
> > assume it's this code path that is causing the -EAGAIN return value [1].
> >
> 
> IIUC, EAGAIN and EINTR are syscall return errno that indicates a system
> call need to be retried. Documentation/virt/kvm/api.rst do mention that
> exit_reason is value only with return value 0.
> 
> 	__u32 exit_reason;
> 
> When KVM_RUN has returned successfully (return value 0), this informs
> application code why KVM_RUN has returned.

Yeah, that makes sense. api.rst is a bit weird, because it doesn't document
all of the error codes, and they are documented in different places, like
-EFAULT which is under KVM_EXIT_MEMORY_FAULT, not under KVM_RUN.

Thanks for the explanation!

> 
> >
> > If that's the case, how does retrying KVM_RUN solve the issue? Just trying to
> > get to the bottom of it, because there's not much detail in the docs.
> >
> > [1] https://elixir.bootlin.com/linux/v6.15-rc3/source/arch/x86/kvm/x86.c#L11532
> >
> >
> 
> So in that code path vcpu will be in kvm_vcpu_block(vcpu) waiting for
> the IPI. On IPI kvm_apic_accept_events() will return 0 after setting the
> vcpu->arch.mp_state. Hence a KVM_RUN ioctl again will find the mp_state
> correctly updated. 

I think that would be useful to have in the commit message.

Thanks,
Alex

> 
> -aneesh

