Return-Path: <kvm+bounces-44806-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F7FEAA1174
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 18:21:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 68F4D4A0333
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 16:21:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53FC8245010;
	Tue, 29 Apr 2025 16:21:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="loH6rd46"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8523E241665
	for <kvm@vger.kernel.org>; Tue, 29 Apr 2025 16:21:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745943698; cv=none; b=Yg0Ksk5j9Pp3AsalhhBziaPU9DwdyawIfLWW09a12fsK8p9PVKt72XPQerR6Dq5awR+V5sEw9waoY2NRtcEO5Vsx4m1x53k7HYqXfVaUSZ2Bu7RiHteP7OIl8H0s2OFmLaz+OyVWBujjshFT0WprGTg0VCM8m0N/zMSY0XouBNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745943698; c=relaxed/simple;
	bh=X203x4J2u2Uiks7D81+rBjwN7+PlsNhFkfzpcAr2Qng=;
	h=Mime-Version:Content-Type:Date:Message-Id:From:Subject:Cc:To:
	 References:In-Reply-To; b=RZ0dro5HxBCUHajep/0TewYnAfYlxCYUBwf2JaCCTn3zlxD4LgDy++/9mLP3m5xx/XvUDbT9oNly4jP0jmbghXDHtCJylVMJuNUlzyQIFnfwwUiW/VtjWmzAha52zIHv+MllJhrPZ0cx51h3ZpnlT832BfWaFCVI1h22RHLmN/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=loH6rd46; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-39d73b97500so371592f8f.3
        for <kvm@vger.kernel.org>; Tue, 29 Apr 2025 09:21:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1745943695; x=1746548495; darn=vger.kernel.org;
        h=in-reply-to:references:to:cc:subject:from:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n4Wt+BZ71x/abgZTG5PyDsFpbW2D/kzzpuguZVbmGlc=;
        b=loH6rd46YIM60l2Qf33WQz7VCTkW+nz/YbTExMeFeU/L5yPaxhnsZFQS0vuK8Ouby6
         4l+uM/SbNjllAqgz09hmq8YdGI8i6UsakzZQ6yE775YxXZS7qMOToeRL3ujGTLomOi+F
         dnUKvld0pwCdGzRCUIB4WH2jUSY5FIGXvutylAvSfTfc1LKaMll/pPB5VuQEvLdv8h1w
         OZUgCJNBX0tDBa0CcOFpdVGaiNwwxhit2UZ9lvMKAHGZmhaJrl1Bfic99s8LUcF+QabN
         UBm/+G+gv3IpQrupABvccVjMulERuLfPknDWx5PUDnyzrH+BBldmwlSWewbSVd7b31mB
         YAEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745943695; x=1746548495;
        h=in-reply-to:references:to:cc:subject:from:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=n4Wt+BZ71x/abgZTG5PyDsFpbW2D/kzzpuguZVbmGlc=;
        b=WATCvdrkmr9myzGPpQ347d6CjUHcLMp+4aLmoAIjuO1xSau7/Svs5IHo54vTQTh0Cx
         XOvmC/SMZN+dBgrhOIUW3H0HGgWO4lHXvnD6f782kbXoTf5yb/H3QdxKfIAWQYxk2H9l
         pzRead/VALIDsIGCYl/fQDlSBhBusy/up44GVG9VntZp4EU/xEiJR5V8OaLikm4c8ILi
         4xP9RFLYMonbOYfHOXineHKiwoL/3W5K5DpYWUmscYPh5zydFQrmwQLifjHGESQZ79jV
         EInauCqjWUPE1gO6ldWiYwCNZragfxnQRLjvbgf9c621+bXAgRkVFitduVUjQinnKLa1
         0f8w==
X-Forwarded-Encrypted: i=1; AJvYcCVVgAD4VyFbWsXOdJl7UQaYsUGuG6kQQ+rJ5Pqnr5fmZiGNny3VqsyAlkUIQwbD2xuXpwo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzdy2wbZHsXSg+uJzlhDvVcGYalosHCeen7X0FcpdvKm7pg55Kd
	8VjfxeswhrEgbPgozaS1LS2SrKeje/xM12gvTfwMkmYtHnsfW6Jhr6ttJU2MFZI=
X-Gm-Gg: ASbGncur7xUcA8UByhMgWIXB4R0GvsJjfREqbZ+q+Jk0pMCn4aqfc/BfeT5t/0YPZ+G
	ulKMeIbpFloRBybqZPhK6wsVE6RUGiAw55nVRQVmBoFYqHkbMbuSmOn7Gn2l2Dvq/1dIcksk74b
	xuoJvwwZztG9F7GmZAVg/7AXwVps/p2hJ3qRffQY6kBKCbP+5Pzf+E4sB4/edAPBaD4iMzM2rwR
	mU+xpPgzzXe5EZfcWngUDpVh4v+llzvx5xiR/FKDY+Ld/fkoi7Fto5kDNH/rrxD6KoTkHQaIB/J
	A462mlmwrDLrzHsbO77U/QhS40szonx8s1UkC4n6iu8GouXO
X-Google-Smtp-Source: AGHT+IE7T1o3gyNSKYkssQg0Lf54mrrx8eDIwrOxAiax301n2e5FcgwZ3P+UeYD0s4r1YzAGb1Az4w==
X-Received: by 2002:adf:f4c7:0:b0:3a0:75ff:261f with SMTP id ffacd0b85a97d-3a075ff267amr3429312f8f.11.1745943694680;
        Tue, 29 Apr 2025 09:21:34 -0700 (PDT)
Received: from localhost ([2a02:8308:a00c:e200:b996:f7e3:35e8:5091])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a073e4641csm14226859f8f.80.2025.04.29.09.21.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Apr 2025 09:21:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 29 Apr 2025 18:21:33 +0200
Message-Id: <D9J9DW53Q2GD.1PB647ISOCXRX@ventanamicro.com>
From: =?utf-8?q?Radim_Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@ventanamicro.com>
Subject: Re: [PATCH 4/5] KVM: RISC-V: reset VCPU state when becoming
 runnable
Cc: "Anup Patel" <apatel@ventanamicro.com>, <kvm-riscv@lists.infradead.org>,
 <kvm@vger.kernel.org>, <linux-riscv@lists.infradead.org>,
 <linux-kernel@vger.kernel.org>, "Atish Patra" <atishp@atishpatra.org>,
 "Paul Walmsley" <paul.walmsley@sifive.com>, "Palmer Dabbelt"
 <palmer@dabbelt.com>, "Albert Ou" <aou@eecs.berkeley.edu>, "Alexandre
 Ghiti" <alex@ghiti.fr>, "Andrew Jones" <ajones@ventanamicro.com>, "Mayuresh
 Chitale" <mchitale@ventanamicro.com>
To: "Anup Patel" <anup@brainfault.org>
References: <20250403112522.1566629-3-rkrcmar@ventanamicro.com>
 <20250403112522.1566629-7-rkrcmar@ventanamicro.com>
 <CAAhSdy0e3HVN6pX-hcX2N+kpwsupsCf6BqrYq=bvtwtFOuEVhA@mail.gmail.com>
 <D9IGJR9DGFAM.1PVHVOOTVRFZW@ventanamicro.com>
 <CAK9=C2Woc5MtrJeqNtaVkMXWEsGeZPsmUgtFQET=OKLHLwRbPA@mail.gmail.com>
 <D9J1TBKYC8YH.1OPUI289U0O2C@ventanamicro.com>
 <CAAhSdy01yBBfJwdTn90WeXFR85=1zTxuebFhi4CQJuOujVTHXg@mail.gmail.com>
In-Reply-To: <CAAhSdy01yBBfJwdTn90WeXFR85=1zTxuebFhi4CQJuOujVTHXg@mail.gmail.com>

2025-04-29T20:31:18+05:30, Anup Patel <anup@brainfault.org>:
> On Tue, Apr 29, 2025 at 3:55=E2=80=AFPM Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrc=
mar@ventanamicro.com> wrote:
>>
>> 2025-04-29T11:25:35+05:30, Anup Patel <apatel@ventanamicro.com>:
>> > On Mon, Apr 28, 2025 at 11:15=E2=80=AFPM Radim Kr=C4=8Dm=C3=A1=C5=99 <=
rkrcmar@ventanamicro.com> wrote:
>> >>
>> >> 2025-04-28T17:52:25+05:30, Anup Patel <anup@brainfault.org>:
>> >> > On Thu, Apr 3, 2025 at 5:02=E2=80=AFPM Radim Kr=C4=8Dm=C3=A1=C5=99 =
<rkrcmar@ventanamicro.com> wrote:
>> >> >> For a cleaner solution, we should add interfaces to perform the KV=
M-SBI
>> >> >> reset request on userspace demand.  I think it would also be much =
better
>> >> >> if userspace was in control of the post-reset state.
>> >> >
>> >> > Apart from breaking KVM user-space, this patch is incorrect and
>> >> > does not align with the:
>> >> > 1) SBI spec
>> >> > 2) OS boot protocol.
>> >> >
>> >> > The SBI spec only defines the entry state of certain CPU registers
>> >> > (namely, PC, A0, and A1) when CPU enters S-mode:
>> >> > 1) Upon SBI HSM start call from some other CPU
>> >> > 2) Upon resuming from non-retentive SBI HSM suspend or
>> >> >     SBI system suspend
>> >> >
>> >> > The S-mode entry state of the boot CPU is defined by the
>> >> > OS boot protocol and not by the SBI spec. Due to this, reason
>> >> > KVM RISC-V expects user-space to set up the S-mode entry
>> >> > state of the boot CPU upon system reset.
>> >>
>> >> We can handle the initial state consistency in other patches.
>> >> What needs addressing is a way to trigger the KVM reset from userspac=
e,
>> >> even if only to clear the internal KVM state.
>> >>
>> >> I think mp_state is currently the best signalization that KVM should
>> >> reset, so I added it there.
>> >>
>> >> What would be your preferred interface for that?
>> >>
>> >
>> > Instead of creating a new interface, I would prefer that VCPU
>> > which initiates SBI System Reset should be resetted immediately
>> > in-kernel space before forwarding the system reset request to
>> > user space.
>>
>> The initiating VCPU might not be the boot VCPU.
>> It would be safer to reset all of them.
>
> I meant initiating VCPU and not the boot VCPU. Currently, the
> non-initiating VCPUs are already resetted by VCPU requests
> so nothing special needs to be done.

Currently, we make the request only for VCPUs brought up by HSM -- the
non-boot VCPUs.  There is a single VCPU not being reset and resetting
the reset initiating VCPU changes nothing. e.g.

  1) VCPU 1 initiates the reset through an ecall.
  2) All VCPUs are stopped and return to userspace.
  3) Userspace prepares VCPU 0 as the boot VCPU.
  4) VCPU 0 executes without going through KVM reset paths.

The point of this patch is to reset the boot VCPU, so we reset the VCPU
that is made runnable by the KVM_SET_MP_STATE IOCTL.

For design alternatives, it is also possible to reset immediately in an
IOCTL instead of making the reset request.

>> You also previously mentioned that we need to preserve the pre-reset
>> state for userspace, which I completely agree with and it is why the
>> reset happens later.
>
> Yes, that was only for debug purposes from user space. At the
> moment, there is no one using this for debug purposes so we
> can sacrifice that.

We still can't immediately reset the boot VCPU, because it might already
be in userspace.  We don't really benefit from immediately resetting the
initiating VCPU.
Also, making the reset request for all VCPUs from the initiating VCPU
has some undesirable race conditions we would have to prevent, so I do
prefer we go the IOCTL reset way.

>> >             This way we also force KVM user-space to explicitly
>> > set the PC, A0, and A1 before running the VCPU again after
>> > system reset.
>>
>> We also want to consider reset from emulation outside of KVM.
>>
>> There is a "simple" solution that covers everything (except speed) --
>> the userspace can tear down the whole VM and re-create it.
>> Do we want to do this instead and drop all resets from KVM?
>
> I think we should keep the VCPU resets in KVM so that handling
> of system reset handling in user space remains simple. The user
> space can also re-create the VM upon system reset but that is
> user space choice.

Ok.

