Return-Path: <kvm+bounces-54307-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 276CBB1E0AF
	for <lists+kvm@lfdr.de>; Fri,  8 Aug 2025 04:47:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AC7E77B0896
	for <lists+kvm@lfdr.de>; Fri,  8 Aug 2025 02:45:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 277A119995E;
	Fri,  8 Aug 2025 02:46:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fSP0r76W"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oa1-f47.google.com (mail-oa1-f47.google.com [209.85.160.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD5D28F54;
	Fri,  8 Aug 2025 02:46:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754621212; cv=none; b=QpBRYBLB4z61nSuYKe4E/gooVvLaNczw56LJSkFfSrchDSSg0ZGnbSSUqsiUMgozjiVjk8wQvYV7v9Ofw9p5tNssKAtrU/HTYmZxelp7hzivbnjzgq8aC+7Z54OamfcNCA2aVHcusXGJKZswqN4qa6pmXgdLE3YT0fXGGh9tJwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754621212; c=relaxed/simple;
	bh=6eSIumEnVqBAHxkcRySbKyk8WK2BmCyzcvRVh0iuIX4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BNhaJkxrYxKyyW+K03eJ0rsU+j1ylmXDdcdBnLqhiX3NZMdNsvkMx5QwutXE4amsLP9kzarmunPpR9VJgFEACgzPl7G8c03pdcpLk0dxcrB/syZsZXMnehu9WWtB0zpubUVZzidutYwQrIO7qiTLyHrbMK1SQs15M659Nl2hLMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fSP0r76W; arc=none smtp.client-ip=209.85.160.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oa1-f47.google.com with SMTP id 586e51a60fabf-30babf43ddaso590614fac.3;
        Thu, 07 Aug 2025 19:46:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754621210; x=1755226010; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=MUTlcJcSAf0RqZ1mjBBPM2/hxVYL9IMk97YOwGgUXR4=;
        b=fSP0r76WT3n0DW0pt4GXsuuOsplBj/q54H++1Wc4+28BJ9sNmto42x1lgEQcL+XCIE
         5Ep+W2mspZBt6urk1WH2Zq4fZI4xTTf4UsF9wjN1mx3Cs4/H7QGyX6SNPC9Y7qH3DZd4
         w0PskYsKh/AqK4iRqoVNq5WIJZ4WgQWFuGAZxhAspf5TzKI6Yu5pXkt1FTADeAEMPhPx
         6sYq4gaVgfT91C2beXP5zAMAoI7JZ0x+LMYsprbESl7Qm8UURIqwe1H7WWGw1QR5XVwm
         wotolPcXKHWZR1i5J5wK8J3Z3jcee/d6eTy1A3JtlD95GRjYZycPS0r9twL2VlafKFqb
         G97Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754621210; x=1755226010;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MUTlcJcSAf0RqZ1mjBBPM2/hxVYL9IMk97YOwGgUXR4=;
        b=TaHWdVGuKSEnnX18xZ9SlWh3bP+h6IPw5bGbdemxZfsuGTU0NW0FG7ln7uExSzAc4W
         xZxrPfQkAMycmTP/FXNLTWYPjqVFGCiNyLoCs0CrMPP+fCQCYDu/Nk2oFcts2nyuvnXV
         8cICIuKMRZhQEyHBVSsh3aB6c+zVxPMSgs7H3C+mmwOY+N1TkIruGb5a+YBuFHNJKziF
         2iNDCiCrmhO3scT3+IP8r8N1VyYV5H3jBYMbFi/tNRd00ss1fdqcqOFJbcmZRHSklfBC
         MN52boO/AvXrm+/enukn6DCCBVEVFkPp/ngDCJA72IoSyDzVDMzMMic1mAKUTulJGRqL
         COGA==
X-Forwarded-Encrypted: i=1; AJvYcCUl810TfzGjK1SiLkBdOlNcCaMQm/xDs+uH9UZ8zKRxAqC1R+bO1DQqd9vPFk1rqpPdUBS+VRtJJJ25CNks@vger.kernel.org, AJvYcCVT8ZFG0lNW2WQIIIEHdF2w+HhvJLizbd4KH+n7FjNsj0Ij6beA1u89CAQoK0Rdp2KOQAY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx5IN8k+4DN8YCzcXitrmJW3XqOdbvYEvk7oP/dC3lN2LexZJIE
	C5+RkP7BPCW5Aw5xbGpdo2zhuZWOcILhdyYNCO61NI59V99SWubx3zksaiU9jY5dhAxNVCI7UXX
	Nn/e2GJT2yCxTiba7jaqwzD2g7sKE0DM=
X-Gm-Gg: ASbGncs4G3cgAkcMVxx3EPVAoCrSmXzfUnYO3nq8QTUzNGgUB2DAJW4MHhhwt4iC9pB
	ZqLCZ5+gYZ0ZaQy8I/iot4nd4WlfEpgCF0iuR3+Y69luk8njqLFKarYMx6CXfh1upKQzQfcNY3d
	57M7hEqBCGYA1GKtvFT9QB0jYzEZ27jJfVyhi0k4HEXTPyVfyTsOASNSKlreGGsG8KqlV/jjSIt
	XtDQ70=
X-Google-Smtp-Source: AGHT+IHwEfdTGFfLBzTAAdGW8Mg/b51BAGAxnhdAPxMyWF/3/GJIWPrt6OV+0ucQFa1FYFvEYF2z7EM0XXmqFqP3X5c=
X-Received: by 2002:a05:6870:a910:b0:30b:aeb8:fa62 with SMTP id
 586e51a60fabf-30c20f50a06mr990473fac.16.1754621209668; Thu, 07 Aug 2025
 19:46:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250806081051.3533470-1-hugoolli@tencent.com>
 <aJOc8vIkds_t3e8C@google.com> <CAAdeq_+Ppuj8PxABvCT54phuXY021HxdayYyb68G3JjkQE0WQg@mail.gmail.com>
 <aJTytueCqmZXtbUk@google.com>
In-Reply-To: <aJTytueCqmZXtbUk@google.com>
From: hugo lee <cs.hugolee@gmail.com>
Date: Fri, 8 Aug 2025 10:46:37 +0800
X-Gm-Features: Ac12FXwrw46uHl0Gmh5Te-yT6pNi6Eq_nyRwXIAuZbf3W_z-lWvESf1ROWiZJMg
Message-ID: <CAAdeq_+wLaze3TVY5To8_DhE_S9jocKn4+M9KvHp0Jg8pT99KQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: Synchronize APIC State with QEMU when irqchip=split
To: Sean Christopherson <seanjc@google.com>
Cc: pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, hpa@zytor.com, x86@kernel.org, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yuguo Li <hugoolli@tencent.com>
Content-Type: text/plain; charset="UTF-8"

On Fri, Aug 8, 2025, Sean Christopherson <seanjc@google.com> wrote:
>
> On Thu, Aug 07, 2025, hugo lee wrote:
> > On Thu, Aug 7, 2025 Sean Christopherson wrote:
> > >
> > > On Wed, Aug 06, 2025, Yuguo Li wrote:
> > > > When using split irqchip mode, IOAPIC is handled by QEMU while the LAPIC is
> > > > emulated by KVM.  When guest disables LINT0, KVM doesn't exit to QEMU for
> > > > synchronization, leaving IOAPIC unaware of this change.  This may cause vCPU
> > > > to be kicked when external devices(e.g. PIT)keep sending interrupts.
> > >
> > > I don't entirely follow what the problem is.  Is the issue that QEMU injects an
> > > IRQ that should have been blocked?  Or is QEMU forcing the vCPU to exit unnecessarily?
> > >
> >
> > This issue is about QEMU keeps injecting should-be-blocked
> > (blocked by guest and qemu just doesn't know that) IRQs.
> > As a result, QEMU forces vCPU to exit unnecessarily.
>
> Is the problem that the guest receives spurious IRQs, or that QEMU is forcing
> unnecesary exits, i.e hurting performance?
>

It is QEMU is forcing unnecessary exits which will hurt performance by
trying to require the Big QEMU Lock in qemu_wait_io_event.

> > > > diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> > > > index 8172c2042dd6..65ffa89bf8a6 100644
> > > > --- a/arch/x86/kvm/lapic.c
> > > > +++ b/arch/x86/kvm/lapic.c
> > > > @@ -2329,6 +2329,10 @@ static int kvm_lapic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val)
> > > >                       val |= APIC_LVT_MASKED;
> > > >               val &= apic_lvt_mask[index];
> > > >               kvm_lapic_set_reg(apic, reg, val);
> > > > +             if (irqchip_split(apic->vcpu->kvm) && (val & APIC_LVT_MASKED)) {
> > >
> > > This applies to much more than just LINT0, and for at least LVTPC and LVTCMCI,
> > > KVM definitely doesn't want to exit on every change.
> >
> > Actually every masking on LAPIC should be synchronized with IOAPIC.
>
> No, because not all LVT entries can be wired up to the I/O APIC.
>
> > Because any desynchronization may cause unnecessary kicks
> > which rarely happens due to the well-behaving guests.
> > Exits here won't harm, but maybe only exit when LINT0 is being masked?
>
> Exits here absolutely will harm the VM by generating spurious slow path exits.
>
> > Since others unlikely cause exits.
>
> On Intel, LVTPC is masked on every PMI.
>

So I will make it only exit when LINT0/1 is being masked.

> > > Even for LINT0, it's not obvious that "pushing" from KVM is a better option than
> > > having QEMU "pull" as needed.
> > >
> >
> > QEMU has no idea when LINT0 is masked by the guest. Then the problem becomes
> > when it is needed to "pull". The guess on this could lead to extra costs.
>
> So this patch is motivated by performance?

Yes.

