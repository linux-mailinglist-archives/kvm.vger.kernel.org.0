Return-Path: <kvm+bounces-19073-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B333B90084D
	for <lists+kvm@lfdr.de>; Fri,  7 Jun 2024 17:11:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3BFEB1F27C7D
	for <lists+kvm@lfdr.de>; Fri,  7 Jun 2024 15:11:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED8D71922F2;
	Fri,  7 Jun 2024 15:11:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SvCJ05FJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A245F25740
	for <kvm@vger.kernel.org>; Fri,  7 Jun 2024 15:11:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717773091; cv=none; b=iILxNlyRKuHTz86Xja7IEFe5v+pZrpHkMdAUYryUUm9AKzunNkiSUK77odGL4JRXe8izNKo3EkyZCiaf2YhahWqUzGo6wSnQoPURuTBC4fbqgGpa2clCLzSlDZQ/Y1i126OP8pHYTxwNQ/ciBtfs8QE17a76CEtD6pHZU7r7uDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717773091; c=relaxed/simple;
	bh=t9H8jpD3p11qwd7sytuCB98EQ9NueIlYwx4Tt8/psKA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=qfg2wXNfyBLRI4dgmIlZAkCz2RRMYdE9v7081yE6fMws/T8+5wblmE0WcWi0WKnUDJvrhLtTXWjSFlFUIA50sqqyo7JZRLymjK1bHGx294FAubtoL2IKb/VnQjryOeOiQACjI7Nkc80kXeW41lx1aj0+OJBWJn8DgcPBFFusCXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SvCJ05FJ; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-62a08273919so34368987b3.1
        for <kvm@vger.kernel.org>; Fri, 07 Jun 2024 08:11:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717773089; x=1718377889; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ex2nZHRLv3gtg4nC8Gp/3+MSsGZYhmqvJ3bWYCD2SdY=;
        b=SvCJ05FJlC8gyIyJJNlEX750hi5r1vsRvgrDDw31bITazF6vK0fo7PjcaZ3ku3SwmA
         Yxd8rf/lBiYwO/p0p736gt/Csz7Xs5l/WKV6hTMR4yhpDgmihJCvuWxFNGdC45oQPK7Y
         LkGbrsmxpUSCD7yJlwMMuQE+4GPRKtUTnwLQM8PnbHty6LsFuE+r2c3BmxzY8lbQpxlc
         oBlVVefERlCzuVaEWYQRrzShud77IBPFjBiW3famyoCoC4kqIMz8C88IanotOeM6orqL
         ODeCekp2AHV17f4yp2HsBHJnynxVsK1ed7zR0TDYsTRQofzdfRVwYDPkODHw3i9Uc3e5
         GdUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717773089; x=1718377889;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ex2nZHRLv3gtg4nC8Gp/3+MSsGZYhmqvJ3bWYCD2SdY=;
        b=qKlnz2vUFRpezDO1pWGr5WOvSch/ScqdkD27W8wsPUfDxegqAlZc/BUFxhK6Hz+Wrl
         his0jpO9dkQtiNlJkKGif86hM/G2KSYZfM2JrAZiZsRzkVMe4XJLMsUNagYVBL0tmnmc
         sfNXjCYGo3itsee0x2C2eoX6XfLFzvgYhPHj5D4pXB8n8Q+hFP6rtEoyvY7k9d0AX9Ig
         bVD9Q8eTZeGfc0eGPVeWs+XOPTW8miEFvuDw47bGWLKnRfLjYnEmDwF6XMlL3OrNPiWv
         b/5cd007Z/S0zg/wHhGRS2bqaTHNGLvQO8sOiMLGybrFERcC9cAhLxEO0Or1c9gQPudg
         eBKw==
X-Gm-Message-State: AOJu0Yw6TvTyHPQ2X0EMuCifFc/3e/NRNuM1yFnIS1nCDxZiycsP5IBy
	Imn09of/pMaF+NEYo04eSLY6K4A5iGKNPpM7wtkhndE0IhZ6QYveuElKEiwFfHJfKy2Ppk9Ttv0
	xBA==
X-Google-Smtp-Source: AGHT+IHhAdfZH4OI2iNJh44mDt2T7ugxfQWP/zFMFnsGk76Nup/Du4ZDAUM5QiFXi8YCO8DJ1unaelYyyBI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1248:b0:df4:a393:8769 with SMTP id
 3f1490d57ef6-dfaf65ba959mr237734276.9.1717773088585; Fri, 07 Jun 2024
 08:11:28 -0700 (PDT)
Date: Fri, 7 Jun 2024 08:11:27 -0700
In-Reply-To: <06e6b7c6-ba5d-4fb0-9a77-30ac44f6935a@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240429155738.990025-1-alejandro.j.jimenez@oracle.com>
 <20240429155738.990025-5-alejandro.j.jimenez@oracle.com> <Zl5cUwGiMrng2zcc@google.com>
 <06e6b7c6-ba5d-4fb0-9a77-30ac44f6935a@oracle.com>
Message-ID: <ZmMjHwavCLk0lRd7@google.com>
Subject: Re: [PATCH 4/4] KVM: x86: Add vCPU stat for APICv interrupt
 injections causing #VMEXIT
From: Sean Christopherson <seanjc@google.com>
To: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, linux-kernel@vger.kernel.org, 
	suravee.suthikulpanit@amd.com, vashegde@amd.com, mlevitsk@redhat.com, 
	joao.m.martins@oracle.com, boris.ostrovsky@oracle.com, mark.kanda@oracle.com
Content-Type: text/plain; charset="us-ascii"

On Thu, Jun 06, 2024, Alejandro Jimenez wrote:
> On 6/3/24 20:14, Sean Christopherson wrote:
> > On Mon, Apr 29, 2024, Alejandro Jimenez wrote:
> > > Even when APICv/AVIC is active, certain guest accesses to its local APIC(s)
> > > cannot be fully accelerated, and cause a #VMEXIT to allow the VMM to
> > > emulate the behavior and side effects. Expose a counter stat for these
> > > specific #VMEXIT types.
> > > 
> > > Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
> > > Signed-off-by: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
> > > ---
> > >   arch/x86/include/asm/kvm_host.h | 1 +
> > >   arch/x86/kvm/svm/avic.c         | 7 +++++++
> > >   arch/x86/kvm/vmx/vmx.c          | 2 ++
> > >   arch/x86/kvm/x86.c              | 1 +
> > >   4 files changed, 11 insertions(+)
> > > 
> > > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > > index e7e3213cefae..388979dfe9f3 100644
> > > --- a/arch/x86/include/asm/kvm_host.h
> > > +++ b/arch/x86/include/asm/kvm_host.h
> > > @@ -1576,6 +1576,7 @@ struct kvm_vcpu_stat {
> > >   	u64 guest_mode;
> > >   	u64 notify_window_exits;
> > >   	u64 apicv_active;
> > > +	u64 apicv_unaccelerated_inj;
> > 
> > The stat name doesn't match the changelog or the code.  The AVIC updates in
> > avic_incomplete_ipi_interception() are unaccelerated _injection_, they're
> > unaccelarated _delivery_.  And in those cases, the fact that delivery wasn't
> > accelerated is relatively uninteresting in most cases.
> > 
> 
> Yeah, this was my flawed attempt to interpret/implement Paolo's comment in
> the RFC thread:
> 
> "... for example I'd add an interrupt_injections stat for unaccelerated
> injections causing a vmexit or otherwise hitting lapic.c"

KVM essentially already has this stat, irq_injections.  Sort of.  The problem is
that the stat isn't bumped when APICv is enabled because the IRQ isn't *directly*
injected.  KVM does "inject" the IRQ into the IRR (and RVI on Intel), but KVM
doesn't go through .inject_irq().

For APICv, KVM could bump the stat when manually moving the IRQ from the IRR to
RVI, but that'd be more than a bit misleading with respect to AVIC.  With AVIC,
the CPU itself processes the IRR on VMRUN, i.e. there's no software intervention
needed to get the CPU to inject the IRQ.  But practically speaking, there's no
meaningful difference between the two flows; in both cases an IRQ arrived while
the target vCPU wasn't actively running the guest.  And that means KVM would need
to parse the IRR on AMD just to bump a stat.

It'd also be misleading to some extent in general, because when the target vCPU
is in its inner run loop, but not actually post-VM-Enter, KVM doesn't kick the
vCPU because either KVM or the CPU will automatically process the pending IRQ.
I.e. KVM would bump the stat cases where the injection isn't fully accelerated,
but that's somewhat disingenuous because KVM didn't need to slow down the vCPU
in order to deliver the interrupt.

And KVM already has an irq_exits stat, which can be used to get a rough feel for
how often KVM is kicking a vCPU (though timer ticks likely dominate the stat).

> > And avic_unaccelerated_access_interception() and handle_apic_write() don't
> > necessarily have anything to do with injection.
> 
> apicv_unaccelerated_acccess is perhaps a better name (assuming stat is
> updated in handle_apic_access() as well)?

This is again not super interesting.  If we were to add this stat, I would lobby
hard for turning "exits" into an array that accounts each individual VM-Exit,
though with some massaging to reconcile differences between VMX and SVM.

Unaccelerated APIC exits aren't completely uninteresting, but they suffer similar
issues to the "exits" stat: a few flavors of APIC exits would dominate the stats,
and _those_ exits aren't very interesting.

> > On the flip side, the slow paths for {svm,vmx}_deliver_interrupt() are very
> > explicitly unnaccelerated injection.
> 
> Now that you highlight this, I think it might be closer to Paolo's idea. i.e.
> a stat for the slow path on these can be contrasted/compared with the
> kvm_apicv_accept_irq tracepoint that is hit on the fast path.  My initial
> reaction would be to update a stat for the fast path, as a confirmation that
> apicv is active which is how/why I typically use the kvm_apicv_accept_irq
> tracepoint, but that becomes redundant by having the apicv_active stat on
> PATCH 1.
> 
> So, if you don't think it is useful to have a general
> apicv_unaccelerated_acccess counter, I can drop this patch.

The one thing I can think of that might be somewhat interesting is when
kvm_apic_send_ipi() is invoked to deliver an IPI.  If KVM manually sends the IPI,
and IPI virtualization is enabled (on-by-default in AVIC, and an add-on feature
for APICv), then it means IPI virtualization isn't doing it's job for whatever
reason.  But even then, I'm doubt it's worth a stat, because it likely just means
the guest is doing something weird, not that there's a problem in KVM.

