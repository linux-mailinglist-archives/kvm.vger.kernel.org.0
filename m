Return-Path: <kvm+bounces-63370-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id A45CBC63EE5
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 12:52:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 6C5E74EB0FB
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 11:48:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C73A32ABCE;
	Mon, 17 Nov 2025 11:48:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BBQh6X0a"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0657D32A3C5
	for <kvm@vger.kernel.org>; Mon, 17 Nov 2025 11:48:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763380132; cv=none; b=qC3rsB3tIplQLrXadIGE2sX0ynngnzR50aFRbPnMBMlWjRcWQOsUGKVfAuA7tS1bCW7BUIihSUlCkUqiSToivaofxPX17zZHNF9fSDMU+ZUAErt/ZnSco4cwXWBiD7+yS4GXpKfKjepkccxFREUGslgUyS4POJ05K8kqkV1igj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763380132; c=relaxed/simple;
	bh=sRlq8ZsHJ8wENkGdYQx+aafifaQb0Y8TbYSZjuDARps=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OhDYzM4gL7dEKnP/2YMcCL57Bux6leb60qWtLYt4FhGupyE1BtvSrWhq4BYXspT3gjXVpf7p2aCE6HeqCcjCTZr6UB/cJIOeZHMFQs9zUlLkHwre2L3lmHsUwi49IRT1C0FOorvuK++NYykXDciHxEx2e2ucgTIIU9+4JRov8ic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BBQh6X0a; arc=none smtp.client-ip=209.85.160.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-4ee243b98caso191301cf.1
        for <kvm@vger.kernel.org>; Mon, 17 Nov 2025 03:48:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763380130; x=1763984930; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=wtFMwliyeURMAMFY1byC+UBdCK6dtQy078PTE9BuABk=;
        b=BBQh6X0a3KcJDFv2BKEqNWtOE/oNl55DDte+bKO6CtCgWCtmj4f6okNjV64sL4DEBv
         swbx2OB+vech/+FsX1D2XlWAH9N7s4xRvAVU27Cge3XnN0OvvAyH2tjB10zFEOiWdMn+
         fxm2GqLEz4lJPappPsQTNdLhxGJksHn/dNHTL/vfd+f5Npip6NlRKCxW3totWGDEXoAY
         D2IYe5Xew97S2Mq2Zw2h/UOQtZGjquyfWoIyefmxuyCn21gtKKNKqlvHmCiim2UTgg1p
         hMjEpipXb8Mw7BCDMYObj3DMP04ePbk1L3P0eZlPi3frC3JBH7BlQwQZXrPX4ABB5lOY
         JroA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763380130; x=1763984930;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wtFMwliyeURMAMFY1byC+UBdCK6dtQy078PTE9BuABk=;
        b=K3PQjjQkeyahrOHIW90MeYty9U2dtrpDNMPrnqQGRI+OrzftaeM95BwxcFnRiHcAFb
         lpxMiE2U6VaMtoZBefIxtdy38WYeh6h2rOxeLOU7i8gsDO+M76i3KXYeCkQmc56NY1HO
         V3GIIDxnbQfXMHDttobLd1rsJPHKhu3yDkSJHf14GyC29Go9sv+Lpdb/Ke6cgda8/AjI
         aZ2Lnmvfe8YvYymN7AzW+ZH3XsrOFW7GYlkC5Ti+WbzRWxJUsNnIjkloMIDzvjga1ZMJ
         6N0BYHnZSDwW6l+Bh7XNYmO9kRH7NUgtlF7+K3Km06ECdXsTFjGIhp+8Kukjvimre7BJ
         fGdA==
X-Forwarded-Encrypted: i=1; AJvYcCUXd62Jn7SdFEuEezCNdihI+9k4ufwIyzqWSx1mBJEXc3/Zg2y2q/OT+Vg8jV/yGBIr2W0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyn7hG2sBgyPbY5Vr60mPjC62oARorTH1rdj8t3ku1bTfWSu5pP
	CUJa9bJ+JTz4ddNEi8Ec0nDjIUbdq8bVZgxghFQCk8an5NDBdD1q4/JPjSG2HLvLZu33BqyckVJ
	53v5PeP08zv5fr2GwZ9gk3i6RMvP3zZO4Mhi/Gt1p
X-Gm-Gg: ASbGncsFeYAWVBcC2FYY+dIIOE8KCYec15dqoYM0ZYE7YLQIbG0JeyO4bbY7EJnika8
	kN4cpx7vIPSFqzFRALsKuV9hEIKZILXcGsW7ppjenTlEel4J2swUxxniTYh+5E2v/vf+/OVkEA1
	RgVbu9648v/CQ+AZsRghjCKOEicACGWUFHT6/anDC2qIWJQbMRioridIcb2KBWeOCy4u51Hq+cx
	OyasxWQRBpD2NmvEPZ6+E8HsnFUhNsOMKEDi7iPjmyLxTQDWbgpsvcFnYOzkXpNziR/kQY=
X-Google-Smtp-Source: AGHT+IEHIBrDsl1tNBXJlZjvy3Cf3bvvIt0plNzv8yp90Dy54B0sd0uogGQ1BYNz1nQ2J5pl3F6LJlVNsJl1l4fGJHA=
X-Received: by 2002:a05:622a:4f13:b0:4ed:ff77:1a87 with SMTP id
 d75a77b69052e-4ee02a994a9mr8359641cf.19.1763380129366; Mon, 17 Nov 2025
 03:48:49 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251117091527.1119213-1-maz@kernel.org> <20251117091527.1119213-6-maz@kernel.org>
 <CA+EHjTxVr7uk8Ofhb2VHjDw+LfC4ZSz4dDun5+xLcnRQy5AKaQ@mail.gmail.com> <86346cubqo.wl-maz@kernel.org>
In-Reply-To: <86346cubqo.wl-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 17 Nov 2025 11:48:11 +0000
X-Gm-Features: AWmQ_bnWedPYEhHQPg2C4X-v3VYqSp4JpRxkKgnh4axAij7gQDfBobnagYWNTiE
Message-ID: <CA+EHjTxB6qf80zLYQJnpr=beJWg2CiqcbTwPhodgtBceEGLVUw@mail.gmail.com>
Subject: Re: [PATCH v3 5/5] KVM: arm64: GICv3: Force exit to sync ICH_HCR_EL2.En
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oupton@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>, Christoffer Dall <christoffer.dall@arm.com>, 
	Mark Brown <broonie@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Mon, 17 Nov 2025 at 11:42, Marc Zyngier <maz@kernel.org> wrote:
>
> On Mon, 17 Nov 2025 11:35:18 +0000,
> Fuad Tabba <tabba@google.com> wrote:
> >
> > Hi Marc,
> >
> > On Mon, 17 Nov 2025 at 09:22, Marc Zyngier <maz@kernel.org> wrote:
> > >
> > > FEAT_NV2 is pretty terrible for anything that tries to enforce immediate
> > > effects, and writing to ICH_HCR_EL2 in the hope to disable a maintenance
> > > interrupt is vain. This only hits memory, and the guest hasn't cleared
> > > anything -- the MI will fire.
> > >
> > > For example, running the vgic_irq test under NV results in about 800
> > > maintenance interrupts being actually handled by the L1 guest,
> > > when none were expected.
> > >
> > > As a cheap workaround, read back ICH_MISR_EL2 after writing 0 to
> > > ICH_HCR_EL2. This is very cheap on real HW, and causes a trap to
> > > the host in NV, giving it the opportunity to retire the pending
> > > MI. With this, the above test tuns to completion without any MI
> > > being actually handled.
> >
> > nit: tuns->runs
> >
> >
> > >
> > > Yes, this is really poor...
> > >
> > > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > > ---
> > >  arch/arm64/kvm/hyp/vgic-v3-sr.c      | 7 +++++++
> > >  arch/arm64/kvm/vgic/vgic-v3-nested.c | 6 ++++--
> > >  2 files changed, 11 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/arch/arm64/kvm/hyp/vgic-v3-sr.c b/arch/arm64/kvm/hyp/vgic-v3-sr.c
> > > index 99342c13e1794..f503cf01ac82c 100644
> > > --- a/arch/arm64/kvm/hyp/vgic-v3-sr.c
> > > +++ b/arch/arm64/kvm/hyp/vgic-v3-sr.c
> > > @@ -244,6 +244,13 @@ void __vgic_v3_save_state(struct vgic_v3_cpu_if *cpu_if)
> > >         }
> > >
> > >         write_gicreg(0, ICH_HCR_EL2);
> > > +
> > > +       /*
> > > +        * Hack alert: On NV, this results in a trap so that the above
> > > +        * write actually takes effect...
> > > +        */
> > > +       isb();
> > > +       read_gicreg(ICH_MISR_EL2);
> > >  }
> >
> > nit: is it worth gating this with "ARM64_HAS_NESTED_VIRT"?
>
> This is in a *guest*, which knows nothing about being virtualised!

Nested makes my head hurt :D

Cheers,
/fuad

>
> > Otherwise,
> > Reviewed-by: Fuad Tabba <tabba@google.com>
>
> Thanks!
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.

