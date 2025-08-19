Return-Path: <kvm+bounces-55001-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B3632B2C8C9
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 17:53:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 04BD65A5A5F
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 15:52:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1CDC29E0FF;
	Tue, 19 Aug 2025 15:52:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="Zp1Vj9Ri"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0EEC28750D
	for <kvm@vger.kernel.org>; Tue, 19 Aug 2025 15:52:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755618765; cv=none; b=Zo64gRzGNd2I09mJGUsGjhtfzR5cPRwhOlB1PdipsrSDXELZCTxxcwACJLEvH1KObzGqrkeuROhAa+gdsLtAnJS6PMcmAw1mNC3foY2cKEBdThfl2c3bLLG0gt9Dcu4U3LaY7vZzqJ3vfhYC47wBHX55ExCMySrdQ9eBvDrUR7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755618765; c=relaxed/simple;
	bh=gJi311INLUz9BB4yAJRwXjUEoKqhQCr8Iw5pJB/GKQY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tqwYIDYtF7vyK35GqZYmm8PwjC8V3zoK4auHjVaImhBhDAmfSUheh2oc52DJ+oNDWqwT/CqqjxjF8m4LMKzK2xKGojbQ3NTSEMcJTVW9P60O356enC5ajc4QQqmI52Y7UNEl4X69Fox1CdrI4uNAGg01Iur7rTk7fXGOZKDM1tY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=Zp1Vj9Ri; arc=none smtp.client-ip=209.85.167.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-55ce5284d63so25539e87.0
        for <kvm@vger.kernel.org>; Tue, 19 Aug 2025 08:52:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1755618760; x=1756223560; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PVPEZJwGOc7DWah0Wa62QJ8Wx+o9x389K3rLNeH+kRI=;
        b=Zp1Vj9RiKup9kfBA2Mw8fBcFa3vzAFd059rGgv78q531AfRkBl5zpWZSQzPpoGmbl7
         fqcgJEjVVdmUbKYxUuf2uCFj+TInmE0Bcblb3TSfJ7++hyYNDS78oZAUsKiyQsDOA0Pb
         mMZaC0Fvn+bRtXVpzB50VPsW5YSnywI1fHKhPJqK+nzQ7IDy1jc6srCvbCfaDPAgA/xV
         NS5vNdUkQKFHLZKTimcdnj+VMFUX44zeo7YAQF6OJdDQhNrE8Q5yJQtAZTActwgbvj4x
         aKtFF0N8kTqRLKwJL9HQmel6eFy4ZfoNDUNwrQ8Zt2ufmIKDrwBVyezDhhztmymM6lgM
         +I/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755618760; x=1756223560;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PVPEZJwGOc7DWah0Wa62QJ8Wx+o9x389K3rLNeH+kRI=;
        b=eE9hDhpYV2c/+V/PHW7L+2HTh2QeiFJEmmhPNex/gAFKkTMrZPKo+q2YWefbA+sGk8
         IMALFE5NNRsreXaWtzowjw/cco3f88sc6cRjG+v3IQEZVXqDlLsKyDI9vkhQEadFJvow
         rBaMzh/ymgxmuso/QjR5mUpe/Lt5Kl0hL7QA+JI2OemoVZX8Bn3j+15WdHO/fGMUscCt
         DMPJHXEVhqLGAVmLn18ZGo9ke1bo18BV+2vk20wsPp6qIPUjtXH02XjDZDO7Ktrs9OCu
         mXya57/GKKF89xM/Ch6gZNfGmB4lpTA+qfppW7SiDbBYjJattE5A3+SdGpwNHx0MFIg2
         YZNg==
X-Forwarded-Encrypted: i=1; AJvYcCXwFjFclusxjjYUjoNHjjXn59REx7RkV6UUUvxgxPVBPninjxQQSZ1/Ycaj51n9S2hVA+M=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy2965ifS/xxiKvQxPy2396A9VADyshYDmBu4p+E0hitkLMu6iR
	lGrFcgIXyDuM+JhZw6CG/qRjCPwy2AOCyWA7WP5CadWeXhWjom3t+jX7anww9goCCzq6CJREW5H
	iWYG3qnL0xtwaJMUTbo7f8tEsu6Q18S0DsF+jdQpwhQ==
X-Gm-Gg: ASbGncsgAKU4YWWZFoODm3WwYlXDJHd9HaM7F5LrRXldYJHHR4NFTMFiyKCPBL8mAO1
	Qf1JcyHY0zd7xjj0yQn4UwZGm6sqA4HH9UA+uPb5D9xCG1UbMHGe6nxlDsbxiHaoneGhF0yzQta
	NOG1HosTuIn+L5fUZyVsqATGU/sCndHKSEu4fy9bNrWLabkd/P9bREDbkaCYzsiMo5f3TJbnETG
	iprSAdS
X-Google-Smtp-Source: AGHT+IG93vPg3JnmzC4TQkSt2WLHPF7ygY8dUaQKyxThGovvr67BbEe1KR/tk+Sl0qrBQnuofCDYFgGP0rmeWdsfVZM=
X-Received: by 2002:ac2:51d5:0:b0:553:2438:8d16 with SMTP id
 2adb3069b0e04-55e010dcb08mr788867e87.20.1755618760305; Tue, 19 Aug 2025
 08:52:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250814155548.457172-1-apatel@ventanamicro.com>
 <DC5HEJRMZ84K.34OPU922A7XBE@ventanamicro.com> <CAK9=C2X8-DBi7qQ87kMA0AiVdiFH0_4L4mzzZzbeCg2eiNm8Qg@mail.gmail.com>
 <DC6DLP13J0LA.XW9J3XFBCM1Y@ventanamicro.com>
In-Reply-To: <DC6DLP13J0LA.XW9J3XFBCM1Y@ventanamicro.com>
From: Anup Patel <apatel@ventanamicro.com>
Date: Tue, 19 Aug 2025 21:22:27 +0530
X-Gm-Features: Ac12FXwIAb9BKGOobvU4ZtbnqG39Qq3DT3T0Na2EUpHQtF7QYeWAFYPZ5CYlMEA
Message-ID: <CAK9=C2VA2jswYm_yxYsCaGKUkJT46rxUH-6OKdsApMZ8nhkrQw@mail.gmail.com>
Subject: Re: [PATCH 0/6] ONE_REG interface for SBI FWFT extension
To: =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@ventanamicro.com>
Cc: Atish Patra <atish.patra@linux.dev>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Alexandre Ghiti <alex@ghiti.fr>, 
	Andrew Jones <ajones@ventanamicro.com>, Anup Patel <anup@brainfault.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-riscv <linux-riscv-bounces@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 19, 2025 at 5:13=E2=80=AFPM Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcma=
r@ventanamicro.com> wrote:
>
> 2025-08-19T12:00:43+05:30, Anup Patel <apatel@ventanamicro.com>:
> > On Mon, Aug 18, 2025 at 3:59=E2=80=AFPM Radim Kr=C4=8Dm=C3=A1=C5=99 <rk=
rcmar@ventanamicro.com> wrote:
> >>
> >> 2025-08-14T21:25:42+05:30, Anup Patel <apatel@ventanamicro.com>:
> >> > This series adds ONE_REG interface for SBI FWFT extension implemente=
d
> >> > by KVM RISC-V.
> >>
> >> I think it would be better to ONE_REG the CSRs (medeleg/menvcfg), or a=
t
> >> least expose their CSR fields (each sensible medeleg bit, PMM, ...)
> >> through kvm_riscv_config, than to couple this with SBI/FWFT.
> >>
> >> The controlled behavior is defined by the ISA, and userspace might wan=
t
> >> to configure the S-mode execution environment even when SBI/FWFT is no=
t
> >> present, which is not possible with the current design.
> >>
> >> Is there a benefit in expressing the ISA model through SBI/FWFT?
> >>
> >
> > Exposing medeleg/menvcfg is not the right approach because a
> > Guest/VM does not have M-mode hence it is not appropriate to
> > expose m<xyz> CSRs via ONE_REG interface. This also aligns
> > with H-extension architecture which does not virtualize M-mode.
>
> We already have mvendorid, marchid, and mipid in kvm_riscv_config.

The mvendorid, marchid, and mipid are accessible via SBI BASE
extension but not any other M-mode CSRs hence these are special.

>
> The virtualized M-mode is userspace+KVM.  (KVM doesn't allow userspace
> to configure most things now, but I think we'll have to change that when
> getting ready for production.)

The RISC-V architecture is not designed to virtualize M-mode
and there is no practical use-case for virtualized M-mode hence
WE WON'T BE SUPPORTING IT IN KVM RISC-V.

FYI, the KVM ARM64 does not virtualize EL3 either and it is
already in production so please stop making random arguments
for requiring virtualized M-mode for production.

>
> > We already had discussions about this in the past.
> >
> > As such, we have two options. One option is to expose
> > hedeleg/henvcfg via kvm_riscv_config and another option
> > is to have a separate ONE_REG for each FWFT feature.
> >
> > Separate ONE_REG registers for each FWFT feature is better
> > than directly exposing hedeleg/henvcfg via ONE_REG because:
> >
> > 1) Once nested virtualization lands, we will be having separate
> > hedeleg/henvcfg as part of nested virtualization state of Guest
> > which is trap-n-emulated by KVM. The existence of hedeleg/henvcfg
> > in kvm_riscv_config and nested virtualization state will only create
> > more confusion.
>
> Right, the userspace registers for this can't be called h*.
>
> > 2) Not all bits in hedeleg/henvcfg are used for FWFT since quite
> > a few bits are programmed with fixed value based on KVM
> > implementation choices (which may change in future).
>
> Yes, we'll want to expose some to userspace.
>
> >                                                      Also,
> > things like set_debug_ioctl() change hedeleg at runtime
> > which allow KVM user space to decide who takes breakpoint
> > traps from Guest/VM.
>
> This is still doable.  The clear hedeleg bit does not have to change the
> virtualized behavior -- if the guest is expecting to see breakpoint
> traps, then even if userspace+KVM configure the architecture to direct
> the traps to the hypervisor, they must then forward the breakpoints that
> were supposed to be delivered to the guest.
>
> >                      This means value saved/restored
> > through hedeleg/henvcfg in kvm_riscv_config becomes
> > specific to the kernel version and specific to host ISA features.
>
> Hedeleg/henvcfg bits do not have to be the same as userspace interface
> bits -- KVM always has to distinguish what the userspace wants to
> virtualize, and what the KVM changed for its own reasons.
>
> > 3) We anyway need to provide ONE_REG interface to
> > save/restore FWFT feature flags so it's better to keep the
> > FWFT feature value as part of the same ONE_REG interface.
>
> I think we want to have SBI in userspace (especially for single-shot
> ecalls like FWFT).  The userspace implementation will want an interface
> to set the ISA bits, and it's very awkward with the proposed design.
>
> Flags can to stay, in case the userpace wants to accelerate FWFT.
>
> > 4) The availability of quite a few FWFT features is dependent
> > on corresponding ISA extensions so having separate ONE_REG
> > registers of each FWFT feature allows get_reg_list_ioctl() to
> > provide KVM user-space only available FWFT feature registers.
>
> Yes, but similarly the userspace would be forbidden from setting bits
> that cannot be expressed in henvcfg/hededeg.

Instead of having henvcfg/hededeg via ONE_REG with restrictions,
it's much cleaner and maintainable to have a separate ONE_REG
register for each FWFT feature.

>
> There are also behaviors we want to configure that do not have a FWFT
> toggle.  e.g. the recent patches for delegation of illegal-instruction
> exceptions that changed the guest behavior -- someone might want to
> keep incrementing the SBI PMU counter, and someone will want to forward
> them to be implemented in userspace (when developing a new extension,
> because most of the existing ISA can still be accelerated by KVM).

There are alternate approaches for supporting SBI PMU counters in
user-mode where we don't need virtualized M-mode. In any case, we
will support user-mode emulated perf counters only when absolutely
needed.

>
> For general virtualization, we want to be able to configure the
> following behavior for each exception that would go to the virtualized
> M-mode:
>   0) delegated to the guest
>   1) implemented by userspace
>   2-N) implementations by KVM (ideally zero or one)
>
> We can have medeleg, and another method to decide how to handle trapped
> exceptions, but it probably makes more sense to have a per-exception
> ONE_REG that sets how each exception behaves.
>

No pointing in discussing this further since we won't be supporting
virtualized M-mode.

--
Anup

