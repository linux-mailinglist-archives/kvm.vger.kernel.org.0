Return-Path: <kvm+bounces-54573-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8DFC9B24579
	for <lists+kvm@lfdr.de>; Wed, 13 Aug 2025 11:31:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E2C053A76B7
	for <lists+kvm@lfdr.de>; Wed, 13 Aug 2025 09:31:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2D672ED16F;
	Wed, 13 Aug 2025 09:30:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aeeG2oA+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oa1-f48.google.com (mail-oa1-f48.google.com [209.85.160.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94DC51A9F8F;
	Wed, 13 Aug 2025 09:30:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755077452; cv=none; b=K0dMhioj0ZyFDgcmaZDQ0dBgCMoGixA0Pv2BDXLyv/8AUY755VLVIunAFMX/Aw747Jo6sS9iVdtOW0cprmFj0H3U6iaJmanerVSaXdwLuTvDN0tG9gXC/UGzwhk8wbes3a7CbbS60SUzQqq/njGTPOW90TbCgTKqnjf7wsWmBGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755077452; c=relaxed/simple;
	bh=TJ8OdN4pbIcaVrkCD+qSlewG6MleJKciSH5T+oYGUJU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fqLCdG3CqQWN+EvSdYxSnNS13Q41jnBucLcx2ZSKYDJ3ckmpb8WoVJtPZ3Ck9TuWg43gppO+X9JiY3eFI3ovI54GRJR9AWGpQpsaDUZ2fKxwmELoEqUOhSGs8KtOBuemdo19J5PyN6DJSC7Nj/I8P+MNyGfxR1dljJCJo/qA77I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aeeG2oA+; arc=none smtp.client-ip=209.85.160.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oa1-f48.google.com with SMTP id 586e51a60fabf-2e95ab2704fso5484590fac.3;
        Wed, 13 Aug 2025 02:30:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755077449; x=1755682249; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=TJ8OdN4pbIcaVrkCD+qSlewG6MleJKciSH5T+oYGUJU=;
        b=aeeG2oA+O6jlvXkOeirlrRMfUZ71EILzYV02/Qcq4okrK1ySmXdqYatT0wbxPtuqyN
         bDfAjMkiOYg3bCqEzgchYe3/Iy8GwiQWjGlN2rFZlEFlF36uS0gVnvwGGlKARWREFpMq
         nuOcSWxNyjstkLK8+qakt2osW9jyZS0td5ZkUW+7WCQ6YLtFTlTZYXwE4nwH6ji3atbQ
         yAoOAubktafl+4S9xLA1PhB0vGkK4e1X7FM1AFJ3kho7PrCC8eZvN//JDb1koQrFuSu2
         +O/bZcVb2JTvr+QTnv/QObYKzqVf+naAu9+rZw3ND5JJcYsQqtINVXH59zI9Sz8FANrm
         mZww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755077449; x=1755682249;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TJ8OdN4pbIcaVrkCD+qSlewG6MleJKciSH5T+oYGUJU=;
        b=H4loqgl6Ma6cc2G0tc3E4xsqmvbqPIiJNQ9pwHcLHp6DrNVDihbjykZ89jBllzpi/C
         W5J7FbpowQpjMfttS0XrqBZu/Kak39nKOGuQYIVCjZ4mTbNCstYknO36uBqmrEs1/vvc
         O/Psmqv9k9z1PYTXnloGZ4sYr5yhnTd2c7KRbWGUCbNavlxE9hnFgN3+IivBeV26EYjZ
         EiYJahAfPxYDDfkrelA41o79WBbaNWSo488WM9PMLhcfSGFipkZdKqdSsBvw5MEP2VLD
         43DywD+8DQEMZBYgzEHlFcf/e0EABy8Hx+y5ePpyfhxIl/dnM4d1fikBXQ+4seQZL2KT
         lwsQ==
X-Forwarded-Encrypted: i=1; AJvYcCVPFiNJaAzLhKP0rvRHJ9XPjtGoHBn1iV945wetlZEaDR6TzfzceglIpmFwoQrofZjg0KZxnOew3WHDH3U5@vger.kernel.org, AJvYcCWbsEVqz9tCPPXoW9Lwr52cgkafQtopO5h4J6NOvkDC9ybRvML8eetHwHQlaQLIA0USfBU=@vger.kernel.org
X-Gm-Message-State: AOJu0YwklQU9bqnbv6u7IQBsKDszeuQVEHFQlJciWqFL3dGI6963YHKX
	vMhpkVd4awzxkvjsiTz3/Feluj94n+fb1IAWSSc4t9XTgAi2FB1YdkDFMclxSLpZeBxvgHYa5cA
	mKiGPRteZEDTIxqOngAqCkikJvNWUShg=
X-Gm-Gg: ASbGncvGttSCpUt/m8J9eca9DCs4BEIxTqp88RjCg7FCoc+G4efhpJaXzGb4wwfCzPk
	wB2pTyQ/E0DzTVDFM9bZld9d4wUdQgWfZbWXi+av6h9G82PJGXZks55XbEGRn7dR6RjKKxelLLD
	GoY3O1CfaoaIfZDzvg2sBLypmp9iw/AOTt+5aDy8naI5Xr0q5tE742xNVjwX1nxEeUGtDEZTsmM
	MdqMI/SJeYePd6bZQ==
X-Google-Smtp-Source: AGHT+IGCleggzyNiTDxmweBcMCWhRvEBcEKho5wWuH9zx1B9IpkLVeCcnWKB0fTkTz4J8m22a8rBanwmKxDFanxcSmQ=
X-Received: by 2002:a05:6871:113:b0:30b:ba5e:3472 with SMTP id
 586e51a60fabf-30cb5a1034dmr1408492fac.12.1755077449383; Wed, 13 Aug 2025
 02:30:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250806081051.3533470-1-hugoolli@tencent.com>
 <aJOc8vIkds_t3e8C@google.com> <CAAdeq_+Ppuj8PxABvCT54phuXY021HxdayYyb68G3JjkQE0WQg@mail.gmail.com>
 <aJTytueCqmZXtbUk@google.com> <CAAdeq_+wLaze3TVY5To8_DhE_S9jocKn4+M9KvHp0Jg8pT99KQ@mail.gmail.com>
 <aJobIRQ7Z4Ou1hz0@google.com> <CAAdeq_KK_eChRpPUOrw3XaKXJj+abg63rYfNc4A+dTdKKN1M6A@mail.gmail.com>
 <d3e44057beb8db40d90e838265df7f4a2752361a.camel@infradead.org>
 <CAAdeq_LmqKymD8J9tgEG5AXCXsJTQ1Z1XQan5nD-1qqUXv976w@mail.gmail.com> <e35732dfe5531e4a933cbca37f0d0b7bbaedf515.camel@infradead.org>
In-Reply-To: <e35732dfe5531e4a933cbca37f0d0b7bbaedf515.camel@infradead.org>
From: hugo lee <cs.hugolee@gmail.com>
Date: Wed, 13 Aug 2025 17:30:37 +0800
X-Gm-Features: Ac12FXxlCVBq0xCCepPf1U4Z-qVa-4DktvSXJVYRytGaqZ7S8pD7hWDvutj6DbQ
Message-ID: <CAAdeq_LbUkhN-tnO2zbKP9vJNznFRj+28Xxoy3Wb-utmfaW_eQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: Synchronize APIC State with QEMU when irqchip=split
To: David Woodhouse <dwmw2@infradead.org>
Cc: Sean Christopherson <seanjc@google.com>, pbonzini@redhat.com, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com, 
	x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yuguo Li <hugoolli@tencent.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, Aug 12, David Woodhouse <dwmw2@infradead.org> wrote:
>
> On Tue, 2025-08-12 at 19:50 +0800, hugo lee wrote:
> > On Tue, Aug 12, David Woodhouse <dwmw2@infradead.org> wrote:
> > >
> > > On Tue, 2025-08-12 at 18:08 +0800, hugo lee wrote:
> > > >
> > > > On some legacy bios images using guests, they may disable PIT
> > > > after booting.
> > >
> > > Do you mean they may *not* disable the PIT after booting? Linux had
> > > that problem for a long time, until I fixed it with
> > > https://git.kernel.org/torvalds/c/70e6b7d9ae3
> > >
> >
> > True, they disabled LINT0 and left PIT unaware.
> >
> > > > When irqchip=split is on, qemu will keep kicking the guest and try to
> > > > get the Big QEMU Lock.
> > >
> > > If it's the PIT, surely QEMU will keep stealing time pointlessly unless
> > > we actually disable the PIT itself? Not just the IRQ delivery? Or do
> > > you use this to realise that the IRQ output from the PIT isn't going
> > > anywhere and thus disable the event in QEMU completely?
> > >
> >
> > I'm using this to disable the PIT event in QEMU.
> >
> > I'm aiming to solve the desynchronization caused by
> > irqchip=split, so the VM will behave more like the
> > physical one.
>
> I suspect I'm going to hate your QEMU patch when I see it.
>
> KVM has a callback when the IRQ is acked, which it uses to retrigger
> the next interrupt in reinject mode.
>
> Even in !reinject mode, the kvm_pit_ack_irq() callback could just as
> easily be used to allow the hrtimer to stop completely until the
> interrupt gets acked. Which I understand is basically what you want to
> do in QEMU?
>
> There shouldn't be any reason to special-case it on the LINT0 setup; if
> the interrupt just remains pending in the PIC and is never serviced,
> that should *also* mean we stop wasting steal time on it, right?
>
> So ideally, QEMU would have the same infrastructure to 'resample' an
> IRQ when it gets acked. And then it would know when the guest is
> ignoring the PIT and it needn't bother to generate any more interrupts.
>
> Except QEMU's interrupt controllers don't yet support that. So for VFIO
> INTx interrupts, for example, QEMU unmaps the MMIO BARs of the device
> while an interrupt is outstanding, then sends an event to the kernel's
> resample irqfd when the guest touches a register therein!
>
> I'd love to see you fix this in QEMU by hooking up that 'resample'
> signal when the interrupt is acked in the interrupt controller, and
> then wouldn't the kernel side of this and the special case for LINT0 be
> unneeded?
>

Sorry for the misleading, what I was going to say is
do only cpu_synchroniza_state() in this new userspace exit reason
and do nothing on the PIT.
So QEMU will ignore the PIT as the guests do.

The resample is great and needed, but the synchronization
makes more sense to me on this question.

