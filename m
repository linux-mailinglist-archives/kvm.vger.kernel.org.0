Return-Path: <kvm+bounces-54511-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 05B2FB2244A
	for <lists+kvm@lfdr.de>; Tue, 12 Aug 2025 12:13:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5AA0F3B4784
	for <lists+kvm@lfdr.de>; Tue, 12 Aug 2025 10:12:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BD862F0C62;
	Tue, 12 Aug 2025 10:08:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="X6qfKtXx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ot1-f41.google.com (mail-ot1-f41.google.com [209.85.210.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC4D92EFD8C;
	Tue, 12 Aug 2025 10:08:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754993327; cv=none; b=Ew+unD7vlIkZ2mLixW7BM1DXuryjTGTAAsJszpiiD5QfDYlqJKssxUc7ljxdbwQmNcQWmdFtFJ1s7l1/lHpnIx5+KE++aXTOBKaPdOVc8yATn1ML6U2u33b7OsmH4SO3MliU7t0O7ukj1Ebt+UjWT/eApLBXgCgwDV4rVembzOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754993327; c=relaxed/simple;
	bh=DjqfYw7FfGHEVt8z0PE4BgYTRCUaXilqlhjs2mJJKYs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SL6mTdv3yWtM6ZUhBultNVUUK5tKDF2Z6DtoyXpzro1LFaEhH0lMexjPqoQ0sMrCKpPo7NOBSEuT1KFq3tsNDpaYouZhKS1t/Rj7tpsvWSj2+5chDhkXpzje/HhlB6r5s5C3Kl50aUZ43CI5SpURyfydUU1srLcx8FkzmnZ7V9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=X6qfKtXx; arc=none smtp.client-ip=209.85.210.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ot1-f41.google.com with SMTP id 46e09a7af769-741a1ee9366so2891392a34.2;
        Tue, 12 Aug 2025 03:08:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754993324; x=1755598124; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=0mbtoPK9RLYvEJgFSPX9XEe5WXKpdc3Vi/T4wNJL2tE=;
        b=X6qfKtXxICKy/JcDzQAej2/EfwW+ravZjewPruDKw+oLhZUKdtWQC9721yDaVlpSoY
         eHAEXzXVg9MxLyE06AVYPorg2QuGNp4mFz+5gzY1jGYhADmcqbEvQ6dWG35tNg+ehQPV
         /959HT2p5vlB+P4uVc9wA9at5abwvhYwLJ37VJ3UYhDSJ9AGGZyeSgxv4bb36MnbJzOH
         zOt9ca0atWxtPcO8VyOi6DOUO7qCKDA5UWtJhP9QO3j01GJuT5+iY3AYgwc5RigfWJma
         tAxAZLQTKepKe4cblEVHBc5qUYUfxxKeX9BzusGvhwBpLPysDTnqg+BTYg5+UjRCM9jp
         copA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754993324; x=1755598124;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0mbtoPK9RLYvEJgFSPX9XEe5WXKpdc3Vi/T4wNJL2tE=;
        b=DFeatq0w+iOWnMyAEpb+WMG2Nva0NKclTb0jsRXffujvacDY8Yv6nalDL1rROLVf04
         D5/BGlO3XP9XLsi/e8yAcy04rthq9WjSg9whvoXv8urxeI5AqH2yXlTEl4VQ73R19w7r
         NsP4wu6eVvpB9H5k3+aaqcZ9ntvDJZ8PW356XFPyz4JUR3qrAPcEzteBDoxUYMHp+J8w
         Mp8oGB+LtIbvzdI4YihuLVjGBKHXZmAMJv7hXOBd1dxd158eN1RuzMOVeU5wnQmvFsUL
         iAfY+PzyLA0upRG3B/6c1PFo5nw2eMTo8cbOT23juTJKOm0V72iw5Vt/URbQCDW2TeGy
         jmmQ==
X-Forwarded-Encrypted: i=1; AJvYcCUvyiCeGYqMOyULygABmvMGgJhpoWXCIMe9TndZCp9SPnjzkz0AtejVTD3pdWJ36G6uljc=@vger.kernel.org, AJvYcCXAtx0vBffNYLC2Qf1SXYSRHscN8PliEqFb8fqpNNSgdCEZ5csXpAU8oLUEhB/OPlcV/zJSvgapK6bbQdjD@vger.kernel.org
X-Gm-Message-State: AOJu0YwHjz5mxCYPLOTYGd/C3vF/cEQJSlqL+gYLo3FWJ+L1IwaGFf3r
	jJGtc0onbqiIkq1Uo30fpPQ2HVUBFGe6LtRV6XjuA5Fp6oBlEniEL5KWTKedc6WLumVSJLrTfhX
	+RU/Wg4V9CvBjSHHz5qxRKsgXgKDqE/HGEKAEGprvYg==
X-Gm-Gg: ASbGncsBCl66ODPQprthIkStES8U282O0g5+sDd/IDVd+3txkuBgZM83KNzUZPnN5kk
	XYYoIXwAXHVnYp4E/Tw3PajM8+d67R018cCtmIdJIuN87eGriP/4d5uJYoWl/ZMdMnZG+mWz2Wl
	gFcg+lI9MstDXgQnDEUQ+v6Fe+okfsabwa6M5EhwHxFNZ1Cb6VSjt3UaB/cNL83UAv3Yfji0CFB
	j+SrRHWluIzUxumuA==
X-Google-Smtp-Source: AGHT+IHLYBR9FRHku7D8FoeSGgUSH00eJVLHooNUBOpl2H4XdeuhM2qdiszLQqrJTsyt7F8+YR0scWaDdewr2xHQTPM=
X-Received: by 2002:a05:6870:b529:b0:2d5:2955:aa58 with SMTP id
 586e51a60fabf-30c20b4fc61mr10740903fac.0.1754993324595; Tue, 12 Aug 2025
 03:08:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250806081051.3533470-1-hugoolli@tencent.com>
 <aJOc8vIkds_t3e8C@google.com> <CAAdeq_+Ppuj8PxABvCT54phuXY021HxdayYyb68G3JjkQE0WQg@mail.gmail.com>
 <aJTytueCqmZXtbUk@google.com> <CAAdeq_+wLaze3TVY5To8_DhE_S9jocKn4+M9KvHp0Jg8pT99KQ@mail.gmail.com>
 <aJobIRQ7Z4Ou1hz0@google.com>
In-Reply-To: <aJobIRQ7Z4Ou1hz0@google.com>
From: hugo lee <cs.hugolee@gmail.com>
Date: Tue, 12 Aug 2025 18:08:33 +0800
X-Gm-Features: Ac12FXwfHLNsPAI852Q7kHhQBUY6TI-7W2sWvQ6jEkPDyJAdsz9Ul1R6mGeaq-E
Message-ID: <CAAdeq_KK_eChRpPUOrw3XaKXJj+abg63rYfNc4A+dTdKKN1M6A@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: Synchronize APIC State with QEMU when irqchip=split
To: Sean Christopherson <seanjc@google.com>
Cc: pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, hpa@zytor.com, x86@kernel.org, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yuguo Li <hugoolli@tencent.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, Aug 12, 2025, Sean Christopherson <seanjc@google.com> wrote:
>
> On Fri, Aug 08, 2025, hugo lee wrote:
> > On Fri, Aug 8, 2025, Sean Christopherson <seanjc@google.com> wrote:
> > >
> > > On Thu, Aug 07, 2025, hugo lee wrote:
> > > > On Thu, Aug 7, 2025 Sean Christopherson wrote:
> > > > >
> > > > > On Wed, Aug 06, 2025, Yuguo Li wrote:
> > > > > > When using split irqchip mode, IOAPIC is handled by QEMU while the LAPIC is
> > > > > > emulated by KVM.  When guest disables LINT0, KVM doesn't exit to QEMU for
> > > > > > synchronization, leaving IOAPIC unaware of this change.  This may cause vCPU
> > > > > > to be kicked when external devices(e.g. PIT)keep sending interrupts.
> > > > >
> > > > > I don't entirely follow what the problem is.  Is the issue that QEMU injects an
> > > > > IRQ that should have been blocked?  Or is QEMU forcing the vCPU to exit unnecessarily?
> > > > >
> > > >
> > > > This issue is about QEMU keeps injecting should-be-blocked
> > > > (blocked by guest and qemu just doesn't know that) IRQs.
> > > > As a result, QEMU forces vCPU to exit unnecessarily.
> > >
> > > Is the problem that the guest receives spurious IRQs, or that QEMU is forcing
> > > unnecesary exits, i.e hurting performance?
> > >
> >
> > It is QEMU is forcing unnecessary exits which will hurt performance by
> > trying to require the Big QEMU Lock in qemu_wait_io_event.
>
> Please elaborate on the performance impact and why the issue can't be solved in
> QEMU.

On some legacy bios images using guests, they may disable PIT
after booting.
When irqchip=split is on, qemu will keep kicking the guest and try to
get the Big QEMU Lock.

This could be solved in QEMU by guessing when to synchronize,
since QEMU doesn't know what's happening on the LAPIC in the kernel.
It can do synchronize in every qemu_cpu_kick which could also
cause unnecessary syncs and influence the performance.
So I think it is more reasonable to synchronize by the writer
than guessing in QEMU.

