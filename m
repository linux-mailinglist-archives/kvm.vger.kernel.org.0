Return-Path: <kvm+bounces-68087-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 22282D2150B
	for <lists+kvm@lfdr.de>; Wed, 14 Jan 2026 22:23:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 386F13048EE7
	for <lists+kvm@lfdr.de>; Wed, 14 Jan 2026 21:22:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6EF2361676;
	Wed, 14 Jan 2026 21:22:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zFQuqASd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2073430DEA2
	for <kvm@vger.kernel.org>; Wed, 14 Jan 2026 21:22:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768425727; cv=none; b=br70/QNDc9CWSpFQeLvoOdbHLSJui9ed57gNPLQR59E2WD+cxvGmiCVBmBCTWm/FTR+pgFWl947Vu8tk52fzQ+xFiaLaBakFYxs8XJ4fjA8OU1FWaUjwB0wNxXdTc3joF0KEPioTmD+wHzyNr0io2dihv+Ht3sLg4dqenzYPDIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768425727; c=relaxed/simple;
	bh=pcM72MKuav/QuAZ8ZjSyTm/+mJ8IcZF9kpgDH1NOXZI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=s5CaZjqlAnkcr6Aj/7TYE9zyykweLMoBCeP4GEFEYYSSoxOO2AI1tb/sWxVsCj/21XkiOEh7lvWrLDjm4daQKFbe++l0Cddhyt7gIXXPFJ04Bb8uBoxW9TNfuF3VlZKeWJiwtfjMOJ28+90jQPoD8BfIkD0wvkyrlRWpx6aKt+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zFQuqASd; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-34c66cb671fso139919a91.3
        for <kvm@vger.kernel.org>; Wed, 14 Jan 2026 13:22:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768425725; x=1769030525; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jewDq1FR8YPlL6xUTS1W3TOu/T773vGPiXdXngKGp6g=;
        b=zFQuqASdfJ/L4sMqejOB44KdZhe2LBzg4gSRQ5/P5BRhex2DDDqrKwLbkO0EVLMmz+
         4Lc2UXYxEDDSGcUcEYqGXbTqaaTl8RYKtho/VdSytuKykRMx6a4gjZILod2DHWoW5d7O
         MytNgXho+tg/GZPEfDc6E6A891bEs3WZ5QR+qigPricomkrTM459yke5bfrcsz22FlYi
         esNohHJoatcYPyfwd7rJFAG16nI5XbodwLeyvIz4UXIBRSpfxgpq768Z/nwCDAxSGWmO
         GsGF4JZ6HxEmVzgv6btMZwgz803dqapgzRwEtQ67UhjSOAR9V36VLVjGkdJ6m3U+UZ1a
         kTeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768425725; x=1769030525;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jewDq1FR8YPlL6xUTS1W3TOu/T773vGPiXdXngKGp6g=;
        b=Si46lB/MQctOm90ByiUUpUiIi6ypIaDM9vm/C5rvDABSX9qrUa5135BEbEQTiU29zl
         UtxhVTRTAGVopfOKqbdVwQ8rVi1beoYThJZcZTy2h16Q0P67C/YjDTfBIT1KlSeC4OIi
         e1BaJ3So14w0qdIqilpZEVxkwFfHOk7+5c1WwYo0/jRWHtQBxkFdodvF2IPwFVC9XIRs
         2Q1hhTXBVpD+GgF9D4KfQRxMv3IoQFMIJe4UVQb7HTEFJGyW+XT1zaGyyCZpQtuK4k8S
         U0PLGQ5kITNc4VLb/tXH722xj91ureu8clz2jjtQ7YiinNrWUX+Ld9qJRnIAhFnJG8MA
         LDmA==
X-Gm-Message-State: AOJu0YxN/uG7o7Sa+3fdm1BAA7qO65vCzPVBVVidG5Ws9EzCcAaaFkQ2
	tnqa7fhKdEJmAoFAT2S0bHvS8z2HnI6SicVaExLISP+mrn4JJd0KffMIDZ9lAMitf3CLFrx2DZp
	pyjeenQ==
X-Received: from pjbft22.prod.google.com ([2002:a17:90b:f96:b0:34a:ae36:b509])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3c41:b0:349:7f0a:381b
 with SMTP id 98e67ed59e1d1-35109086493mr3767736a91.8.1768425725407; Wed, 14
 Jan 2026 13:22:05 -0800 (PST)
Date: Wed, 14 Jan 2026 13:22:03 -0800
In-Reply-To: <20260114031139.GA107826@k08j02272.eu95sqa>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <0ac6908b608cf80eab7437004334fedd0f5f5317.1768304590.git.houwenlong.hwl@antgroup.com>
 <aWZwE1QukfjYDB_Q@google.com> <20260114031139.GA107826@k08j02272.eu95sqa>
Message-ID: <aWgI-_2mxtTsx_li@google.com>
Subject: Re: [PATCH] KVM: VMX: Don't register posted interrupt wakeup handler
 if alloc_kvm_area() fails
From: Sean Christopherson <seanjc@google.com>
To: Hou Wenlong <houwenlong.hwl@antgroup.com>
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Wed, Jan 14, 2026, Hou Wenlong wrote:
> On Tue, Jan 13, 2026 at 08:17:23AM -0800, Sean Christopherson wrote:
> > On Tue, Jan 13, 2026, Hou Wenlong wrote:
> > > Unregistering the posted interrupt wakeup handler only happens during
> > > hardware unsetup. Therefore, if alloc_kvm_area() fails and continue to
> > > register the posted interrupt wakeup handler, this will leave the global
> > > posted interrupt wakeup handler pointer in an incorrect state. Although
> > > it should not be an issue, it's still better to change it.
> > 
> > Ouch, yeah, that's ugly.  It's not entirely benign, as a failed allocation followed
> > by a spurious notification vector IRQ would trigger UAF.  So it's probably worth
> > adding:
> > 
> >   Fixes: ec5a4919fa7b ("KVM: VMX: Unregister posted interrupt wakeup handler on hardware unsetup")
> >   Cc: stable@vger.kernel.org
> >
> Actually, I'm not sure which commit is better as the fix tag:
> 'bf9f6ac8d749' or 'ec5a4919fa7b'. Before commit 'ec5a4919fa7b', the
> handler was registered before alloc_kvm_areas() and was not unregistered
> if alloc_kvm_areas() failed. However, it seems my commit message
> description is more suitable for fixing 'ec5a4919fa7b'.

Yeah, and the Fixes: chain of <this patch> => ec5a4919fa7b => bf9f6ac8d749 provides
the context needed to get back to the original bug.

> > even though I agree it's extremely unlikely to be an issue in practice.
> > 
> > > Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
> > > ---
> > >  arch/x86/kvm/vmx/vmx.c | 7 +++++--
> > >  1 file changed, 5 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > > index 9b92f672ccfe..676f32aa72bb 100644
> > > --- a/arch/x86/kvm/vmx/vmx.c
> > > +++ b/arch/x86/kvm/vmx/vmx.c
> > > @@ -8829,8 +8829,11 @@ __init int vmx_hardware_setup(void)
> > >  	}
> > >  
> > >  	r = alloc_kvm_area();
> > > -	if (r && nested)
> > > -		nested_vmx_hardware_unsetup();
> > > +	if (r) {
> > > +		if (nested)
> > > +			nested_vmx_hardware_unsetup();
> > > +		return r;
> > > +	}
> > 
> > I'm leaning towards using a goto with an explicit "return 0" in the happy case,
> > to make it less likely that a similar bug is introduced in the future.  Any
> > preference on your end?
> > 
> I don't have a strong preference either way. However, I agree that using
> a goto statement could help prevent potential bugs in the future. Do I
> Thanks!

Nah, I'll change it to a goto when applying.

Thanks!

