Return-Path: <kvm+bounces-37872-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B6B60A30E86
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 15:37:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 680643A7743
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 14:37:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32292250BF2;
	Tue, 11 Feb 2025 14:37:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="utkVcdLp"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56C9F24C671;
	Tue, 11 Feb 2025 14:37:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739284666; cv=none; b=ZP+qNOFYop543TxWoASTJksR3hGgg+rte3o1qSh5EwR710CdwrTjxE5NGly6GGxh4KD9KqkeuKDJra60zS90nQ7UANGcgpHjBAOoD6PM6d6WTFGI3/oXZeSMHsBaM0a3Ahv42rDwrct7I5YXhj/DOwFRJOtFAYpMbQNwSXEkPoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739284666; c=relaxed/simple;
	bh=zZUX3dcU+L2kq2852aFMoMk3aZLTjDr55brLUK+tEGY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G0j9T09K0eYHAr/t3OWzE0o9r/uk9S7R9QZpzf+qShQUNSNjSYXAfVsgR1BcPy03xB35LIqSRMEsS5CaKzIjEK7Yauveb496+aOIUruF/u6cSZYXBRGP8sVr9AWreQ6sFtaV/VkRpnGgwLU/GMv+Va7sQP64D9nt/Cge6priDv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=utkVcdLp; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7B03C4CEDD;
	Tue, 11 Feb 2025 14:37:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739284665;
	bh=zZUX3dcU+L2kq2852aFMoMk3aZLTjDr55brLUK+tEGY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=utkVcdLpn7mhlzeCQlCl0e5CSJBIx+gf4u7jOBBevgdb45xMvhkBwJB+o5T9MpQTL
	 vEwtRn3d7j8uRTqJH6W6XMArk/IA1fwUV5T95bV25LlkWM7ReXsysLWLtNaEj7//Pw
	 Ls+AiG04rqk5FfEJgL0EPOr4FgCOl36qq5968KjCG3MeK//m7mRtx5sL+qGjEcrLUs
	 F93GmqBVws5cymC7IBVr2rFnjT0ORoAV9r3m1ZpBZTGsFdlW8WTijxVl3jmWb/kyHK
	 UGfgO2aHTysXes1+IaCbiklFGuv+LH6h2Fbbp9G9i9ztSO+fGEZjPwXWl1UQxtdESv
	 Xir8rjnFJ8zdg==
Date: Tue, 11 Feb 2025 20:07:02 +0530
From: Naveen N Rao <naveen@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>, 
	Vasant Hegde <vasant.hegde@amd.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH 3/3] KVM: x86: Decouple APICv activation state from
 apicv_inhibit_reasons
Message-ID: <6y4yuwuz4twz7gc6farvpuekl5ryx3sk2j6mw4howdwz42nwoo@hyecnb3nobmu>
References: <cover.1738595289.git.naveen@kernel.org>
 <405a98c2f21b9fe73eddbc35c80b60d6523db70c.1738595289.git.naveen@kernel.org>
 <Z6EOxxZA9XLdXvrA@google.com>
 <60cef3e4-8e94-4cf1-92ae-34089e78a82d@redhat.com>
 <Z6FVaLOsPqmAPNWu@google.com>
 <uroh6wvlhfj4whlf2ull4iob6k7nr4igeplcfvax7nksav6mtf@ek5ja23dkjtn>
 <CABgObfbZYBRx96Cye9HdF=TMkrVMcGa7hJiyYZ4KY3WvbD+4nw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABgObfbZYBRx96Cye9HdF=TMkrVMcGa7hJiyYZ4KY3WvbD+4nw@mail.gmail.com>

On Tue, Feb 04, 2025 at 03:08:57PM +0100, Paolo Bonzini wrote:
> On Tue, Feb 4, 2025 at 12:15 PM Naveen N Rao <naveen@kernel.org> wrote:
> > As a separate change, I have been testing a patch that moves the
> > PIT_REINJ inhibit from PIT creation to the point at which the guest
> > actually programs it so that default guest configurations can utilize
> > AVIC:
> 
> In-kernel PIC and PIT is sort of a legacy setup; the so-called
> "split irqchip" (LAPIC in KVM, PIC/PIT in userspace) is strongly
> preferred.  So I don't think it's particularly important to cater
> for PIT_REINJ.

Sure, though it would be nice if we can enable AVIC to function in wider 
configurations especially if the guest doesn't use the PIT :)

> 
> > If it is, or if we choose to delay PIT_REINJ inhibit to vcpu creation time,
> > then making PT_REINJ or IRQWIN inhibits sticky will prevent AVIC from being
> > enabled later on. I can see in my tests that BIOS (both seabios and edk2)
> > programs the PIT though Linux guest itself doesn't (unless -no-hpet is used).
> 
> Even with -no-hpet, Linux should turn off the PIT relatively soon
> and only rely on the local APIC's timer.

I am not seeing that. With -no-hpet, I see that the guest continues to 
use the PIT, as well as the local APIC timer.

> 
> > You're right -- APICv isn't actually being toggled, but IRQWIN inhibit is
> > constantly being set and cleared while trying to inject device interrupts into
> > the guests. The places where we set/clear IRQWIN inhibit has comments
> > indicating that it is only required for ExtINT, though that's not actually the
> > case here.
> >
> > What is actually happening is that since the PIT is in reinject mode, APICv is
> > not active in the guest. When that happens, kvm_cpu_has_injectable_intr()
> > returns true when any interrupt is pending:
> >
> >     /*
> >      * check if there is injectable interrupt:
> >      * when virtual interrupt delivery enabled,
> >      * interrupt from apic will handled by hardware,
> >      * we don't need to check it here.
> >      */
> >     int kvm_cpu_has_injectable_intr(struct kvm_vcpu *v)
> >     {
> >             if (kvm_cpu_has_extint(v))
> >                     return 1;
> >
> >             if (!is_guest_mode(v) && kvm_vcpu_apicv_active(v))
> >                     return 0;
> >
> >             return kvm_apic_has_interrupt(v) != -1; /* LAPIC */
> >     }
> >
> > The second if condition fails since APICv is not active. So,
> > kvm_check_and_inject_events() calls enable_irq_window() to request for an IRQ
> > window to inject those interrupts.
> 
> Ok, that's due solely to the presence of *another* active inhibit.
> Since sticky inhibits cannot work, making the IRQWIN inhibit per-CPU
> will still cause vCPUs to pound on the apicv_update_lock, but only on
> the read side of the rwsem so that should be more tolerable.
> 
> Using atomics is considerably more complicated and I'd rather avoid it.

Understood, thanks!


- Naveen


