Return-Path: <kvm+bounces-68109-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id BFD36D21F1A
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 02:12:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id C2857301693F
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 01:12:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 698E2239E8B;
	Thu, 15 Jan 2026 01:12:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="B7RHcOzD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-vk1-f172.google.com (mail-vk1-f172.google.com [209.85.221.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51C5A20E31C
	for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 01:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768439523; cv=none; b=eX855oq7UdfxgNpDpbBLCkRNlIV+SOxDkJeg3HD8UrnBMl51zuhGM67QRph9oA+9n593DAXjA0PmtMoy/527TNu0KgnnLtK5quRSK3wefc/X4p+lSVDutGN8W091vX1aGt7GLXW/6duDmeh9xetc3vUJ5vcfGXvhgMxcFyAKLs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768439523; c=relaxed/simple;
	bh=wwrYL/J5B7wYRc5HNCMc7y5prIHbnIpbz/8qQN9vhMA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YXtMHUz81JrGBuwwi0XrsguWFfxJbqlLuHu6MGHsSW2+6ZKSoj15o6PD8yZ2o72iyOs6Ghd5Sj08oEGCWDVSqU6schDRnsflNgBR8g0SQ8FCukZvr8xdHRfXkdibHbsVyA/VrjTX6nPSArZvZCjl3wd1J/FNmMytGGRaNjJhrnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=B7RHcOzD; arc=none smtp.client-ip=209.85.221.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-vk1-f172.google.com with SMTP id 71dfb90a1353d-563641b24b9so158464e0c.3
        for <kvm@vger.kernel.org>; Wed, 14 Jan 2026 17:12:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768439521; x=1769044321; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gUr1YpmXUWWfc7TvOLgzjWtFpZs3Z7OTVcw608ZR5w0=;
        b=B7RHcOzDwytl54XuDW4dyUCH3T6rzmIQWIiJEJjyrF9nvkfC3bzrlDvI5QPw/x+wqh
         eHYijsZ+Z3wm9hfHN3I7zDKNkV7OwRnf6dQ4NjZ3b60jPanPMl5IGMONz02VlqPGyH98
         sS3A56xKgnQvJpdBAGttKV44AEknfOHd8cgEpUOWKYAssMjW+r8JSHpfY4MRfRRTGuHO
         zCV6uQV5w7y9DDTRighdaB8HRdJg6l4nOANFUdUubzNb/XXUk1hBCPYANfWPMRr/n1Ys
         JGOk1/1kvRdJHGmnKgWxty8Z8SeEUvQeAUzAVvYgB3Byusadug2SMFmnVyGuW5B3xspx
         r5Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768439521; x=1769044321;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=gUr1YpmXUWWfc7TvOLgzjWtFpZs3Z7OTVcw608ZR5w0=;
        b=Y1REUup++j8PtifZvEh64FekvXhTD21+okynmnupBi81SAS4OkErvVxkyVDlVmevIK
         AL2wI2IYwo3IlZhvMzuS7hd6Sf8bw2YZY+T6H+6V73NO5hfEz8GRB2JKIJ4HWv0G8Mo5
         V9GQIQbZw27HI7slhe8u35RsnsifzLPyIoSIMhFV9beBtmVQCTtHtFYUUB6gX33OEuo2
         y0wPdAOI635+k5fcvGRDothiTPwQVzx7DtMLjqrfMU8RZRbunefZFrDi+y1UDa+EFWMe
         7B3CO63GSoqf22ZwVCWYLjrC0YJilpercbFuUWfk4AYx3JwaH3O3zPXUK7aCdut55jUc
         iIlg==
X-Forwarded-Encrypted: i=1; AJvYcCX4If1di6VDCxASRWOwbVVx/jl06K3xXVLscymMCgB9xWyVpJutMmdjJV8EQXg/CBda4hs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz/zURPEBmXpE5vS686GLMolvhfdEPyov07jT/dZgqgRGZTQq3L
	eYL3S6Wwg/ALurLuISs/PxCTFgqz/oizB00OjaGYlkTTKtFUeupjmuLp6xYR6ZwmHiDhlE4uMH4
	zt3H9c6nyW9Piau7QujOFSYcRi8mArnc=
X-Gm-Gg: AY/fxX4dkHQHA0MeOKHA2iHQ8MfyoHvQhvTUUtpy/TImXXdVf5Dd8I+dF4LzcXRQ20B
	xzBXtpSi/l39d+r3VUi82XkaGvS80DH3TBGzK6WxdRUSM4pxQjjlxc0Gm3o5j/a2lKl/UQsNpvM
	Hz9MtTpas1sESf/ReOp6OQvCaGKqW4qdnVqC12K2Np5XdK0DqZpT7+GJZyytekb3VvxrRz+HsyP
	YPDAxZC9QHPTpGiSQhmvi0jjYGISJv8e4DvvT7U97OJfzLWufshHqSSqfmGz9jhnMc8pUOx0Q==
X-Received: by 2002:a05:6102:1611:b0:5ee:a55c:882 with SMTP id
 ada2fe7eead31-5f17f43d3bcmr2256437137.12.1768439521237; Wed, 14 Jan 2026
 17:12:01 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260104135938.524-1-naohiko.shimizu@gmail.com>
 <20260104135938.524-3-naohiko.shimizu@gmail.com> <CAAhSdy2rH5Jt5t7zCRfFd5d1X7qG41QoUuWvKgwuKX=X3Wk6cA@mail.gmail.com>
In-Reply-To: <CAAhSdy2rH5Jt5t7zCRfFd5d1X7qG41QoUuWvKgwuKX=X3Wk6cA@mail.gmail.com>
From: Naohiko Shimizu <naohiko.shimizu@gmail.com>
Date: Thu, 15 Jan 2026 10:11:52 +0900
X-Gm-Features: AZwV_Qh3_8WiK11p2oDu-jwTcTccWhocAbVxHWGZR4SGJ8O3cJg7N4AR5bNOlrk
Message-ID: <CAA7_YY_ej7+mSi+i0NpHNeHv=a5n5_eGkjBi8pu2u=8h0Opsbg@mail.gmail.com>
Subject: Re: [PATCH v3 2/3] riscv: kvm: Fix vstimecmp update hazard on RV32
To: Anup Patel <anup@brainfault.org>
Cc: pjw@kernel.org, palmer@dabbelt.com, aou@eecs.berkeley.edu, alex@ghiti.fr, 
	atish.patra@linux.dev, daniel.lezcano@linaro.org, tglx@linutronix.de, 
	nick.hu@sifive.com, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Thank you very much, Anup.
I appreciate your review and queuing this as fixes for v6.19.

Naohiko


On Mon, Jan 5, 2026 at 1:31=E2=80=AFPM Anup Patel <anup@brainfault.org> wro=
te:
>
> On Sun, Jan 4, 2026 at 7:30=E2=80=AFPM Naohiko Shimizu
> <naohiko.shimizu@gmail.com> wrote:
> >
> > On RV32, updating the 64-bit stimecmp (or vstimecmp) CSR requires two
> > separate 32-bit writes. A race condition exists if the timer triggers
> > during these two writes.
> >
> > The RISC-V Privileged Specification (e.g., Section 3.2.1 for mtimecmp)
> > recommends a specific 3-step sequence to avoid spurious interrupts
> > when updating 64-bit comparison registers on 32-bit systems:
> >
> > 1. Set the low-order bits (stimecmp) to all ones (ULONG_MAX).
> > 2. Set the high-order bits (stimecmph) to the desired value.
> > 3. Set the low-order bits (stimecmp) to the desired value.
> >
> > Current implementation writes the LSB first without ensuring a future
> > value, which may lead to a transient state where the 64-bit comparison
> > is incorrectly evaluated as "expired" by the hardware. This results in
> > spurious timer interrupts.
> >
> > This patch adopts the spec-recommended 3-step sequence to ensure the
> > intermediate 64-bit state is never smaller than the current time.
> >
> > Fixes: 8f5cb44b1bae ("RISC-V: KVM: Support sstc extension")
> > Signed-off-by: Naohiko Shimizu <naohiko.shimizu@gmail.com>
>
> LGTM.
>
> Reviewed-by: Anup Patel <anup@brainfault.org>
>
> Queued this as fixes for Linux-6.19.
>
> Thanks,
> Anup
>
> > ---
> >  arch/riscv/kvm/vcpu_timer.c | 6 ++++--
> >  1 file changed, 4 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/riscv/kvm/vcpu_timer.c b/arch/riscv/kvm/vcpu_timer.c
> > index 85a7262115e1..f36247e4c783 100644
> > --- a/arch/riscv/kvm/vcpu_timer.c
> > +++ b/arch/riscv/kvm/vcpu_timer.c
> > @@ -72,8 +72,9 @@ static int kvm_riscv_vcpu_timer_cancel(struct kvm_vcp=
u_timer *t)
> >  static int kvm_riscv_vcpu_update_vstimecmp(struct kvm_vcpu *vcpu, u64 =
ncycles)
> >  {
> >  #if defined(CONFIG_32BIT)
> > -       ncsr_write(CSR_VSTIMECMP, ncycles & 0xFFFFFFFF);
> > +       ncsr_write(CSR_VSTIMECMP,  ULONG_MAX);
> >         ncsr_write(CSR_VSTIMECMPH, ncycles >> 32);
> > +       ncsr_write(CSR_VSTIMECMP, (u32)ncycles);
> >  #else
> >         ncsr_write(CSR_VSTIMECMP, ncycles);
> >  #endif
> > @@ -307,8 +308,9 @@ void kvm_riscv_vcpu_timer_restore(struct kvm_vcpu *=
vcpu)
> >                 return;
> >
> >  #if defined(CONFIG_32BIT)
> > -       ncsr_write(CSR_VSTIMECMP, (u32)t->next_cycles);
> > +       ncsr_write(CSR_VSTIMECMP, ULONG_MAX);
> >         ncsr_write(CSR_VSTIMECMPH, (u32)(t->next_cycles >> 32));
> > +       ncsr_write(CSR_VSTIMECMP, (u32)(t->next_cycles));
> >  #else
> >         ncsr_write(CSR_VSTIMECMP, t->next_cycles);
> >  #endif
> > --
> > 2.39.5
> >

