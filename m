Return-Path: <kvm+bounces-44914-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 10869AA4CFD
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 15:12:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 212EA1BA1F3D
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 13:09:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A29A2343CF;
	Wed, 30 Apr 2025 13:02:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="c4D1Olsn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f180.google.com (mail-il1-f180.google.com [209.85.166.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BEE825C80B
	for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 13:02:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746018165; cv=none; b=ozE0YVCQ+3+4v6oVbb+SznG6hDQ8LYWeYVkN+g5Tw+9uAIQ14dUaFPWaMXp3OHzFQyLuiCPYKb/+gi+3iGxCpcAaBaYEPENiMWBFdfmVoaT+pjlBJlxAyPJQLqTaDW6lG94p2YYIRzt/bnmQV3R8l3WvYku4HR5CydiAwUj4EDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746018165; c=relaxed/simple;
	bh=9DUhpk2lmQbTIMq3KEpB/+7ggizBjRi+nmm8Z/B3rgc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cEPQmd8aTfYJXjYPhmIWsqBW64mzrbg5c7sR57repDmZzBYsW+hlcmupo2omd62R4ZXlG8fNzaxgdtgf4JckqrXg32dboELdsQ5rxzo2T+JWSQnVVv7pvnQAF2g4C0VMOwqa4etiOhqq4+lDmPkvdKzopHHx3vrgMOe2lBSmWvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=c4D1Olsn; arc=none smtp.client-ip=209.85.166.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-il1-f180.google.com with SMTP id e9e14a558f8ab-3d91db4f0c3so34990905ab.3
        for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 06:02:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1746018162; x=1746622962; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vp0okNAQhGtn3j89G0GTNiN0i7XN6OEtooLucIvK78M=;
        b=c4D1OlsnXBd2hR40p2rtyaN5Hc0YfYKbUQrlwOokGWwhybBfnX4KTmGaLoF4JLJ2SF
         1VBy7TwX+AkqueGqz4wYFf/0Bz5gK0cvm3J/d2jh5EstHuo3kfW7vNIRLP3GWBxp8OXq
         iKj1b4VADiKzn8I4ELCHw0HXXVhVXO39QYZ+B5WyP5pC/jKfUxzYZ+rh2JBc3eSbbTJj
         jeLsEE3XZZQ9gefPVKJmnsDduGVskW8hpiKBSe827NBvHvShdJfwBW7EHtk7CK6Cgydr
         b4nOi2tq72+ZFm0ghRjnoU/A/5NHgoudbGMFm4XmyTSfsbdkUR/IXjCvpr1rrVnU0+4k
         FfHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746018162; x=1746622962;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vp0okNAQhGtn3j89G0GTNiN0i7XN6OEtooLucIvK78M=;
        b=UThXqWbUWNsBj7Y5GowmvOti2Fe7iM+7BKPvIOjotOP43qljG0GRbC1Tv9Vo4MVEp1
         xPxwKCGbbBnFSPl8WUPygS+7fI9K2AJmocCesYMoPGV1to6RDBcffpHxJCN0z040y1FX
         SUQtgoOvEhjTUI3PdpVK7sqf/1CJUkg2GkTYfLxKXFkhftqKU1Wzfn2jQ5V8TBsj5bSF
         Vdn0IFRVnaLfDaRjjWxy423CgpUepeAfQeFfiZzUGrXQmRaUQB5IGyBAkQKpgs/ruYzI
         FjVzBIOO/05HzuNjEioy7KbjSvEjPz9CCYMrPjjWa4/VVy6C1A45NDvDLzjeHfpvUfzl
         v1UA==
X-Forwarded-Encrypted: i=1; AJvYcCUymIxbXgkNGNgYrfBb3wm96TEfXTBSbDqmc7ekro2OFOiZCH96drf0MBo08VCqNRF2NyY=@vger.kernel.org
X-Gm-Message-State: AOJu0YxeSlfDU8ji2pnwtm0JOHLauq5J2Rbmi7Pak25WQrQw7pBMrnK+
	aQCj+Avcz4R3VXiiVOmzIuEMPjlmNPxOk/u5wphK1JVZJPj21yv/IkmwxGsPB1QUd5hymupXH98
	im94dcRQQLhaIlLiRaxFUYweOx7vKPbYT+hjfqg==
X-Gm-Gg: ASbGncsEnhWMyS2jg0zYmY+2T3QG//S4I4MpxX00O78aHzIOkArCHtXzm/zYR1lLZAY
	C7dm93NMDFk2WvEgiFA+VxvE/0a+AECY32gX1oeiQd8T8jJ1wHHhen+JS86cgDLUvFhsIQJWkwW
	yiIojL8WaL2zm73Vk47rVNL1k=
X-Google-Smtp-Source: AGHT+IFltNG5LrzMPCK7C6LDg14PO7W7coDdcuUm278zKD9SLwj77Gzwt4AG6zeQBZfmymsMU1N87BYFfyazgTLsFRc=
X-Received: by 2002:a05:6e02:188a:b0:3d8:975:b825 with SMTP id
 e9e14a558f8ab-3d967fa1b89mr21495005ab.5.1746018162237; Wed, 30 Apr 2025
 06:02:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250403112522.1566629-3-rkrcmar@ventanamicro.com>
 <20250403112522.1566629-7-rkrcmar@ventanamicro.com> <CAAhSdy0e3HVN6pX-hcX2N+kpwsupsCf6BqrYq=bvtwtFOuEVhA@mail.gmail.com>
 <D9IGJR9DGFAM.1PVHVOOTVRFZW@ventanamicro.com> <CAK9=C2Woc5MtrJeqNtaVkMXWEsGeZPsmUgtFQET=OKLHLwRbPA@mail.gmail.com>
 <D9J1TBKYC8YH.1OPUI289U0O2C@ventanamicro.com> <CAAhSdy01yBBfJwdTn90WeXFR85=1zTxuebFhi4CQJuOujVTHXg@mail.gmail.com>
 <D9J9DW53Q2GD.1PB647ISOCXRX@ventanamicro.com> <CAAhSdy0B-pF-jHmTXNYE7NXwdCWJepDtGR__S+P4MhZ1bfUERQ@mail.gmail.com>
 <CAAhSdy20pq3KvbCeST=h+O5PWfs2E4uXpX9BbbzE7GJzn+pzkA@mail.gmail.com>
 <D9JTZ6HH00KY.1B1SKH1Z0UI1S@ventanamicro.com> <CAAhSdy0TfpWQ-kC_gUUCU0oC5dR45A1v9q84H2Tj9A8kdO0d1A@mail.gmail.com>
 <D9JY52BJEFX2.2S5XL9NOOGBS7@ventanamicro.com>
In-Reply-To: <D9JY52BJEFX2.2S5XL9NOOGBS7@ventanamicro.com>
From: Anup Patel <anup@brainfault.org>
Date: Wed, 30 Apr 2025 18:32:31 +0530
X-Gm-Features: ATxdqUEFxpf2kco5RCzE6InKYF1PowLSM7jupULrAjdgxCDaTJf8QVEmoaCDMJQ
Message-ID: <CAAhSdy1xCRocu2uNri4iDm+NQd+VE8JRVeASfYJ8Qspr5aEz8g@mail.gmail.com>
Subject: Re: [PATCH 4/5] KVM: RISC-V: reset VCPU state when becoming runnable
To: =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@ventanamicro.com>
Cc: Anup Patel <apatel@ventanamicro.com>, kvm-riscv@lists.infradead.org, 
	kvm@vger.kernel.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Atish Patra <atishp@atishpatra.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>, 
	Andrew Jones <ajones@ventanamicro.com>, Mayuresh Chitale <mchitale@ventanamicro.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 30, 2025 at 5:15=E2=80=AFPM Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcma=
r@ventanamicro.com> wrote:
>
> 2025-04-30T15:47:13+05:30, Anup Patel <anup@brainfault.org>:
> > On Wed, Apr 30, 2025 at 1:59=E2=80=AFPM Radim Kr=C4=8Dm=C3=A1=C5=99 <rk=
rcmar@ventanamicro.com> wrote:
> >> 2025-04-30T10:56:35+05:30, Anup Patel <anup@brainfault.org>:
> >> > On Wed, Apr 30, 2025 at 9:52=E2=80=AFAM Anup Patel <anup@brainfault.=
org> wrote:
> >> >> On Tue, Apr 29, 2025 at 9:51=E2=80=AFPM Radim Kr=C4=8Dm=C3=A1=C5=99=
 <rkrcmar@ventanamicro.com> wrote:
> >> >> > The point of this patch is to reset the boot VCPU, so we reset th=
e VCPU
> >> >> > that is made runnable by the KVM_SET_MP_STATE IOCTL.
> >> >>
> >> >> Like I said before, we don't need to do this. The initiating VCPU
> >> >> can be resetted just before exiting to user space for system reset
> >> >> event exit.
> >>
> >> You assume initiating VCPU =3D=3D boot VCPU.
> >>
> >> We should prevent KVM_SET_MP_STATE IOCTL for all non-initiating VCPUs =
if
> >> we decide to accept the assumption.
> >
> > There is no such assumption.
>
> You probably haven't intended it:
>
>   1) VCPU 0 is "chilling" in userspace.
>   2) VCPU 1 initiates SBI reset.
>   3) VCPU 1 makes a reset request to VCPU 0.
>   4) VCPU 1 returns to userspace.
>   5) Userspace knows it should reset the VM.
>   6) VCPU 0 still hasn't entered KVM.
>   7) Userspace sets the initial state of VCPU 0 and enters KVM.
>   8) VCPU 0 is reset in KVM, because of the pending request.
>   9) The initial boot state from userspace is lost.
>
> >> I'd rather choose a different design, though.
> >>
> >> How about a new userspace interface for IOCTL reset?
> >> (Can be capability toggle for KVM_SET_MP_STATE or a straight new IOCTL=
.)
> >>
> >> That wouldn't "fix" current userspaces, but would significantly improv=
e
> >> the sanity of the KVM interface.
> >
> > I believe the current implementation needs a few improvements
> > that's all. We certainly don't need to introduce any new IOCTL.
>
> I do too.  The whole patch could have been a single line:
>
> diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> index d3d957a9e5c4..b3e6ad87e1cd 100644
> --- a/arch/riscv/kvm/vcpu.c
> +++ b/arch/riscv/kvm/vcpu.c
> @@ -511,6 +511,7 @@ int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *=
vcpu,
>
>         switch (mp_state->mp_state) {
>         case KVM_MP_STATE_RUNNABLE:
> +               kvm_riscv_reset_vcpu(vcpu);
>                 WRITE_ONCE(vcpu->arch.mp_state, *mp_state);
>                 break;
>         case KVM_MP_STATE_STOPPED:
>
> It is the backward compatibility and trying to fix current userspaces
> that's making it ugly.  I already gave up on the latter, so we can have
> a decently clean solution with the former.
>
> > Also, keep in mind that so far we have avoided any RISC-V
> > specific KVM IOCTLs and we should try to keep it that way
> > as long as we can.
>
> We can re-use KVM_SET_MP_STATE and add a KVM capability.
> Userspace will opt-in to reset the VCPU through the existing IOCTL.
>
> This design will also allow userspace to trigger a VCPU reset without
> tearing down the whole VM.

Okay, lets go ahead with a KVM capability which user space can opt-in
for KVM_SET_MP_STATE ioctl().

Keep in mind that at runtime Guest can still do CPU hotplug using SBI
HSM start/stop and do system suspend using SBI SUSP so we should
continue to have VCPU reset requests for both these SBI extensions.

Regards,
Anup

