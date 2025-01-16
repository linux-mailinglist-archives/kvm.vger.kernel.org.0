Return-Path: <kvm+bounces-35668-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 62529A13CE8
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2025 15:54:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 833DB188E15B
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2025 14:53:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CC2B22BACF;
	Thu, 16 Jan 2025 14:50:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wPkxZ/lc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0295022ACDF
	for <kvm@vger.kernel.org>; Thu, 16 Jan 2025 14:50:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737039034; cv=none; b=swdICsnQdAw1H9+ehnO4czJbDD2YJZ4DmPZblf1sI9lCqDFCP158QOx4jTXWF2bFVcVaEb5wJrCSWMQ5SMri3YiXzVXy1Kf8fcDOALX7T15LWEDmLRnLZXsp4MF3L+AaJP17ol60cRiuNpkwUYi5hFMK8WM7p/7azj35PBwE78I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737039034; c=relaxed/simple;
	bh=B50r6mF3uUIAQ4MHrs7uWZ7mk+2yxym413nLGZq3eFQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WWdI/aJR/J46wyl6IBf42ZMSZ5x1Hf/3akSr8u0KeQ93eyRWp7gfx+g0/USMVCaHu5ER5ZXYyq2F+zix96gNbOEQdnnsmocXA4ofRGrB/r4xZeF/+uCV7oy35X6bJwU89MztndvDimMoP3P9LrdyL1VBPTDZdNj5UplSP56OcHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wPkxZ/lc; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2163dc0f689so26796505ad.1
        for <kvm@vger.kernel.org>; Thu, 16 Jan 2025 06:50:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737039032; x=1737643832; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Q6wF4bDoqoZcUXv9fAJC0Vah7skPyI0OZj+deykmF4Y=;
        b=wPkxZ/lcejuY/BfPoswdmf0f14Xul5V9n54JyMmmd1WxgsQ4Bu5YpYEkIwfnf5ohRh
         3yyCkOPFhjqEHl3a/bN8VqQ/Hw5f9fgt8q+6bu6VEwoR0m9IYwyHrAfe3cKMUalKIdaX
         DPFPcO9v/mFF0n08u4/yOzysAZztkH/zPFQaKQw3kC+FTMAKgFolkCL9z2GWMvZCqo9w
         3rHpQRS3bmykBWnrnyOGV2RdsZHt0hqY34KcPlopg3G7aTN6riWsqsIWIiZdInuymjRg
         aXVGLvioE+aC06R0vfknJDDzLbmuJZwZUxgJzhIdcyIT5Ko4p2fA9lPeeVS83/y8w2y4
         bqsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737039032; x=1737643832;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Q6wF4bDoqoZcUXv9fAJC0Vah7skPyI0OZj+deykmF4Y=;
        b=cGQ/w092Jle1O/BqLo0aOWDOK4PHwedXiSX2oGXKKDOlnNE8xr2+gqtSCCDzR88fCr
         SpyumApXDfvZyzyoO7REOQWJjF900HbIK+yaSrY/GXjSQeTuPpl6No3uHxTigqHSsg3R
         Goen4XmvT4E5iGKkgka4gGIgLBbcuz2xSvvy0FXNW6LgVhh1ioDsj8zfBt8depFzjTUV
         s4U/anFlM7w8aa2244W3HRkgeLgd74Hxlbt0rvFrhQ9ffNUkQ0tkGWA7CwSlV2m23j5a
         UHq3ub0mMbKBjLTdt9Tnx1wWnMEKxIBhA5yBcZ9IaRSGZUH90fvXoL+R6c4ViS79bTD6
         Nw1A==
X-Gm-Message-State: AOJu0YzFcIoCFsrUs5ck6xK+3OwsbWwE88sh6ZiZDIzhVranA13oY+On
	VgIbCjdW6ZazK79CObpVGBpsNGsB2/XFDt1pE/Huj8qrgNDM1VdoKro0ybk29o//VTnX1+lu1vG
	HpQ==
X-Google-Smtp-Source: AGHT+IFcNm0YhLfn1IQWETLZBgtFHHve6y0+jp73eBOAgf+E6TVqHHHhdFRj1JsTeJv5uZW2p1iUSHsj+QM=
X-Received: from pfhx22.prod.google.com ([2002:a05:6a00:1896:b0:725:e05b:5150])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:4303:b0:1e6:5323:58c5
 with SMTP id adf61e73a8af0-1e88cfa6845mr49547713637.12.1737039032286; Thu, 16
 Jan 2025 06:50:32 -0800 (PST)
Date: Thu, 16 Jan 2025 06:50:31 -0800
In-Reply-To: <61e66ef579a86deb453bb25febd30f5aec7472fc.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241209010734.3543481-1-binbin.wu@linux.intel.com>
 <20241209010734.3543481-13-binbin.wu@linux.intel.com> <8a9b761b-3ffc-4e67-8254-cf4150a997ae@linux.intel.com>
 <e3a2e8fa-b496-4010-9a8c-bfeb131bc43b@linux.intel.com> <61e66ef579a86deb453bb25febd30f5aec7472fc.camel@intel.com>
Message-ID: <Z4kcjygm19Qv1dNN@google.com>
Subject: Re: [PATCH 12/16] KVM: TDX: Inhibit APICv for TDX guest
From: Sean Christopherson <seanjc@google.com>
To: Kai Huang <kai.huang@intel.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, Chao Gao <chao.gao@intel.com>, 
	Rick P Edgecombe <rick.p.edgecombe@intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	Reinette Chatre <reinette.chatre@intel.com>, Yan Y Zhao <yan.y.zhao@intel.com>, 
	Adrian Hunter <adrian.hunter@intel.com>, 
	"tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 16, 2025, Kai Huang wrote:
> On Mon, 2025-01-13 at 10:09 +0800, Binbin Wu wrote:
> > Lazy check for pending APIC EOI when In-kernel IOAPIC
> > -----------------------------------------------------
> > In-kernel IOAPIC does not receive EOI with AMD SVM AVIC since the proce=
ssor
> > accelerates write to APIC EOI register and does not trap if the interru=
pt
> > is edge-triggered. So there is a workaround by lazy check for pending A=
PIC
> > EOI at the time when setting new IOAPIC irq, and update IOAPIC EOI if n=
o
> > pending APIC EOI.
> > KVM is also not be able to intercept EOI for TDX guests.
> > - When APICv is enabled
> > =C2=A0=C2=A0 The code of lazy check for pending APIC EOI doesn't work f=
or TDX because
> > =C2=A0=C2=A0 KVM can't get the status of real IRR and ISR, and the valu=
es are 0s in
> > =C2=A0=C2=A0 vIRR and vISR in apic->regs[], kvm_apic_pending_eoi() will=
 always return
> > =C2=A0=C2=A0 false. So the RTC pending EOI will always be cleared when =
ioapic_set_irq()
> > =C2=A0=C2=A0 is called for RTC. Then userspace may miss the coalesced R=
TC interrupts.
> > - When When APICv is disabled
> > =C2=A0=C2=A0 ioapic_lazy_update_eoi() will not be called=EF=BC=8Cthen p=
ending EOI status for
> > =C2=A0=C2=A0 RTC will not be cleared after setting and this will mislea=
d userspace to
> > =C2=A0=C2=A0 see coalesced RTC interrupts.
> > Options:
> > - Force irqchip split for TDX guests to eliminate the use of in-kernel =
IOAPIC.
> > - Leave it as it is, but the use of RTC may not be accurate.
>=20
> Looking at the code, it seems KVM only traps EOI for level-triggered inte=
rrupt
> for in-kernel IOAPIC chip, but IIUC IOAPIC in userspace also needs to be =
told
> upon EOI for level-triggered interrupt.  I don't know how does KVM works =
with
> userspace IOAPIC w/o trapping EOI for level-triggered interrupt, but "for=
ce
> irqchip split for TDX guest" seems not right.

Forcing a "split" IRQ chip is correct, in the sense that TDX doesn't suppor=
t an
I/O APIC and the "split" model is the way to concoct such a setup.  With a =
"full"
IRQ chip, KVM is responsible for emulating the I/O APIC, which is more or l=
ess
nonsensical on TDX because it's fully virtual world, i.e. there's no reason=
 to
emulate legacy devices that only know how to talk to the I/O APIC (or PIC, =
etc.).
Disallowing an in-kernel I/O APIC is ideal from KVM's perspective, because
level-triggered interrupts and thus the I/O APIC as a whole can't be faithf=
ully
emulated (see below).

> I think the problem is level-triggered interrupt,

Yes, because the TDX Module doesn't allow the hypervisor to modify the EOI-=
bitmap,
i.e. all EOIs are accelerated and never trigger exits.

> so I think another option is to reject level-triggered interrupt for TDX =
guest.

This is a "don't do that, it will hurt" situation.  With a sane VMM, the le=
vel-ness
of GSIs is controlled by the guest.  For GSIs that are routed through the I=
/O APIC,
the level-ness is determined by the corresponding Redirection Table entry. =
 For
"GSIs" that are actually MSIs (KVM piggybacks legacy GSI routing to let use=
rspace
wire up MSIs), and for direct MSIs injection (KVM_SIGNAL_MSI), the level-ne=
ss is
dictated by the MSI itself, which again is guest controlled.

If the guest induces generation of a level-triggered interrupt, the VMM is =
left
with the choice of dropping the interrupt, sending it as-is, or converting =
it to
an edge-triggered interrupt.  Ditto for KVM.  All of those options will mak=
e the
guest unhappy.

So while it _might_ make debugging broken guests either, I don't think it's=
 worth
the complexity to try and prevent the VMM/guest from sending level-triggere=
d
GSI-routed interrupts.  It'd be a bit of a whack-a-mole and there's no arch=
itectural
behavior KVM can provide that's better than sending the interrupt and hopin=
g for
the best.

