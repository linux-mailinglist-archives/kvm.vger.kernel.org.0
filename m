Return-Path: <kvm+bounces-53639-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B6CEAB14DED
	for <lists+kvm@lfdr.de>; Tue, 29 Jul 2025 14:52:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6F82E7AF68E
	for <lists+kvm@lfdr.de>; Tue, 29 Jul 2025 12:51:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97BA73597C;
	Tue, 29 Jul 2025 12:52:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="gX4K6wLq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D07B570808
	for <kvm@vger.kernel.org>; Tue, 29 Jul 2025 12:52:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753793544; cv=none; b=OuZJZ8yv+dTtcyahXSrnEvZuGh0OWMjzt98OgTuqNHZd8ig+gBkah3K3Xkst3kncBL6g0fQ3Ox+p4oIZCi0wWtQPU7f25x+VmF4Ng3OX7GxSMzhh+nevc4eXyBGDDck0298grMYWTulp9dd57kVfv6H6McAlipFypALrKx7vjHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753793544; c=relaxed/simple;
	bh=je78B2vkIOT6PJlrxdZd5+Sx/CBri2HjCaq6yrjVT3k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tW16VxrvP2GrmzfrOekR6cZrV4BYg+FI/FOH7iplnKBM9IN+nylqn7npVOM0YZ8QqgSlIulU/NfZAIEEyYyEktM3UyQQPc21F62kKrTDgU2g6Wm072k10Jgqf/OlTNCNVIB8wAKNItXt3rPM9lh51immrHOjlC/PbfvDwah+FmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=gX4K6wLq; arc=none smtp.client-ip=209.85.167.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-55a33eecc35so5844753e87.2
        for <kvm@vger.kernel.org>; Tue, 29 Jul 2025 05:52:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1753793540; x=1754398340; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SWjHC+OGnvv/XJLYvpyn4u4ZP15ZxkznDvUzFCsHKC8=;
        b=gX4K6wLqxvyjKJirpIypgmtm4RVLwdrp/irKVW65DRIH37pQwEEZvGNgSs3L5S5M/w
         FxC67ls+KZd2cU0Ol4C6us928L3OiOkw0Gsc+OR0hPTsqrGrMVd5xIp2XT4S1QxwodIJ
         blTyWR7CYfzI9DxInnMKsYsuUcJMLelJ7y4atw8TLiJZwo5zUwJTxHv+lFchQsjoXP2c
         zyKEykpu8GP2HsHYIQXsbHHaBJPWn3MgLbdzfgpeDsxAS3CVnCRDqfiPVUm5KtzqKeNu
         oWa1BhMPa4PiVSwVTv/IRx/uQC1o9KuCRG5kyVAivtiMARSQN67FvssIllooEVTlNfiy
         Pcqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753793540; x=1754398340;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SWjHC+OGnvv/XJLYvpyn4u4ZP15ZxkznDvUzFCsHKC8=;
        b=PC7tg4hLB2Li7O/ReJxd5jT2IX1pQqCS/maGUzPC87invUX6Mw1yvJYYAnfeDDgXcW
         LUHuimHQUe1jsLy34DfxBhGhETHDhQ3ys19ObEk+ZcnPDhLR6LInQ6AKM9RjzGL/V+RB
         QgyUsF9OEOeBnoBY2ff3FSq8TYtS3i0Bb7KM8Lw6zZV2XZRdK0tpJW+B5+NxV8BD0wan
         5kU8UcOUjNyBRI8L+Xcvq1jypQBkf4123vf5ZTmR5sBpVmhFe5fOnqLvKDO4UgTXNDRR
         Ldz7VyBVAaBs4YgdYYAWfI1Fhxx7BrkaiHwqJ9S7YKm7oX1iocllEMmbUvRG37DkjHSz
         zJxg==
X-Forwarded-Encrypted: i=1; AJvYcCVFCmLpHmDFa8shseeDlYB+32N7bMtG9ySxLZW80d48I+3ePY/ouD+aF98wi4/SgPr4Ba0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz9byjdxvQxnT3vs1BlOTsqDgCnfVhVI4OL3JamPotaUzmQn9H7
	a9rLcCW6F3CHOVgoHPSeWMI/vendD2MWRW2m/xN6Wzws4THNoaA8H5mX0yeFTuCDMIXmBRUXahb
	R/SzoEZQwsGRiruYZha1sxlrKAKMzmz9i4efWptzcF9e3ZaJGmzZF
X-Gm-Gg: ASbGncshEvQ74HetYDILhAisL4PGDHFElPEByxD3+M9P7IhEMEIGS65et/v4uJzfcZG
	7WuRxMZN5yuVCOHtjKu98wI0IrRwT9MetEfoQnvxGVoEfoARTWHYmUzXvYOSizmcEqFEpnu7IWw
	Mnxf++5qA5WAOCBusVrzZH9EvtstcFKn2u9m8oF0utZGJm4CXA9/LrnS7pVHbDOzbZzcGNzwi99
	NQQlR+j
X-Google-Smtp-Source: AGHT+IHuUnkayMnm4m01Hr69szIdeJHEwA007T0e+mW36V5XSzk+1rDhTFTJSpPJE6Nc6E9BssiE9tqnDraG33SbUD4=
X-Received: by 2002:a05:6512:3ba5:b0:553:2a16:2513 with SMTP id
 2adb3069b0e04-55b5f4bf04emr3872961e87.47.1753793539693; Tue, 29 Jul 2025
 05:52:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAAhSdy12xtRRem-AybfymGHh+sj4qSDDG0XL6M6as=cD5Y2tkA@mail.gmail.com>
 <CABgObfYEgf9mTLWByDJeqDT+2PukVn3x2S0gu4TZQP6u5dCtoQ@mail.gmail.com>
 <CAAhSdy3Jr1-8TVcEhiCUrc-DHQSTPE1RjF--marQPtcV6FPjJA@mail.gmail.com>
 <CABgObfaDkfUa+=Dthqx_ZFy418KLFkqy2+tKLaGEZmbZ6SbhBA@mail.gmail.com>
 <CAK9=C2VamSz4ySKc6JKjrLv9ugcTOONAL4+NmKAexoUgw7kP6w@mail.gmail.com>
 <CABgObfZu2fPFaSy2EHzpD_MUwYYeYMfz6BfXmTw_h3ob1q2=yg@mail.gmail.com>
 <DBOIBORLK6YM.7SND5YPEJR60@ventanamicro.com> <a486e649-d2c0-471c-87f2-c7a01dff9ae4@redhat.com>
In-Reply-To: <a486e649-d2c0-471c-87f2-c7a01dff9ae4@redhat.com>
From: Anup Patel <apatel@ventanamicro.com>
Date: Tue, 29 Jul 2025 18:22:07 +0530
X-Gm-Features: Ac12FXxG38FjWac-eP2Unm7GtAZ_b9c89wpUPy0z_mJTQsoPBm1U1ATUL4DgWdk
Message-ID: <CAK9=C2VaAST1yRoX9yqYqyRaS299iJtTLsvvsZwr2gwBEKfDvw@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/riscv changes for 6.17
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@ventanamicro.com>, 
	Anup Patel <anup@brainfault.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Andrew Jones <ajones@ventanamicro.com>, Atish Patra <atishp@rivosinc.com>, 
	Atish Patra <atish.patra@linux.dev>, 
	"open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" <kvm-riscv@lists.infradead.org>, KVM General <kvm@vger.kernel.org>, 
	linux-riscv <linux-riscv@lists.infradead.org>, 
	linux-riscv <linux-riscv-bounces@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 29, 2025 at 5:29=E2=80=AFPM Paolo Bonzini <pbonzini@redhat.com>=
 wrote:
>
> On 7/29/25 13:37, Radim Kr=C4=8Dm=C3=A1=C5=99 wrote:
> > Sorry, I didn't try too hard to convince others after noticing it, and
> > planned to fix the most significant breakage in later rcs.
>
> You shouldn't have to convince anyone,
> Documentation/virt/kvm/review-checklist.rst is pretty clear: new state
> must include support for save/restore, new features must default to off,
> and the feature should be testable.
>
> The file was just updated (and now makes further remarks about testing),
> but the same things were basically in the older version.
>
> So you need:
>
> - a KVM_ENABLE_CAP to enable/disable FWFT

We don't need separate KVM CAP for every SBI extension
since we already have the SBI ONE_REG interface to
enable/disable individual SBI extensions.

>
> - an ioctl to get the list of FWFT features (kind of like
> KVM_GET_MSR_INDEX_LIST on x86?  It seems unlikely that you get more than
> 50 or 60)
>
> - an ioctl to enable/disable FWFT individual features
>
> - the GET/SET_ONE_REG to migrate the state etc.
>
> - selftests
>

These things need to be added anyway since we have it
for other SBI extensions.

Regards,
Anup

