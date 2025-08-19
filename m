Return-Path: <kvm+bounces-54953-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F9F6B2B974
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 08:33:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D0A251BA5EE5
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 06:31:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C8BD26CE02;
	Tue, 19 Aug 2025 06:31:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="NnC4547D"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CD1A26B76E
	for <kvm@vger.kernel.org>; Tue, 19 Aug 2025 06:30:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755585060; cv=none; b=HK/a4SM3hHuTMZlrscDlZ9hCvp4AzobqmAxoEdmNo+6Bx5LjD+iwjxr0pd89tgZyb0003hl7i3q72RNFNDzdvHypOpuOW4oo06JVMm/TM+ZJrJy1AKrRBe469ts91MZaZpruG1Z4LzsrVwq8JAsNyx71T4a87MDMBFhtk49sods=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755585060; c=relaxed/simple;
	bh=x5X4ewm5a89y5y4039N/SNIncKcOQEgQsBChRS5leiM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZsiqS1/CHhmtOseKEgopYzRjf2uAhYJTJaV3cnXmYtY9Uziq2bUvFV3kOiO9nDJ/YoLN4UFgefwVeWeAealgGSPsCAHhdH8exwwI2vJ8PGV8Nwx49ngiXK42ZWU8d5Z8jxE6E5mvsGQz5jetTx69zmSONws1n7saXB73Y/7Zm4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=NnC4547D; arc=none smtp.client-ip=209.85.167.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-55ce5287a47so4462404e87.3
        for <kvm@vger.kernel.org>; Mon, 18 Aug 2025 23:30:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1755585056; x=1756189856; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=x5X4ewm5a89y5y4039N/SNIncKcOQEgQsBChRS5leiM=;
        b=NnC4547Dt2cNAa4tdZ3Hz4tq3lRpCfukYB0aLUKB7Q8/EXrP1kjd8VQZCTcJQGw67m
         5mqBKBKazW4jeT6oHXTOnRSoGy8pz/gydTtTeAea0YVrEkB2pOKle87GGLg5O0oNbg3X
         uL73kco4TTvuXGUvLGQt9J4vALPqg6tVeZWajXe5nWK9YLtklxCbhYd0R4gVCnxgtB8C
         O17wz9XvdXJpfNJ2BVYHIOVKzBiK4ra4ZnrFTf8aK/FMCRDC/eFinegOTBjK9iXapACs
         wOnNWvQKa25Edp+o7+Vb5iP20EuoiOkqGZjb3kogjItUgl+QVSTN/EgB9fxt9Yy3KxRP
         V9rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755585056; x=1756189856;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=x5X4ewm5a89y5y4039N/SNIncKcOQEgQsBChRS5leiM=;
        b=Tu7HIYrlrFSFeivs3JXmg1dHxsBrGDLnmgrhSUKmQMkdDtu2vMDsWz3QfVdh3vaxC/
         qvZPf8MSBLzSlIQTmYyLQrAQxGYZQK93Sl23UtAcP4kmxDO8vrO6cR3sUiIjyryNlrGE
         cCrUx+wwh3fNMecJwaChT6TaoaHKN7Xocg4kLwxetY/2WG5vLuL6YCpVyU/WWNxhlmb+
         OoY2asn9j0yuqQ8/iczzhNFAcuLVeV3H09WQHontO7VymC8nKX+y+maVyjGkZSctmC1I
         AzGmaQ+D4pyeBp4GqBOV1rdNS2/SLBJeKfzAocnCDS1cBFaAqbG1q8Lvh6xFjz1Yd/rc
         8fHQ==
X-Forwarded-Encrypted: i=1; AJvYcCXLXQ3K4GmXeoRGOGCyW5JMK9xUb6uIFZlHDUJxHngmGfGV63zBba9k3S0q4BrCANJ7NFY=@vger.kernel.org
X-Gm-Message-State: AOJu0YzK6BzG1O5fi29gzuGYoW+L6u/gdegncXDD27yMDNKZAZ+VbfQi
	XxrfGv8yqtdJt2GS9p7Uknl86C7/0pg5JWT5NYm7M+cYy5hL2pScfRJLz/lEX+kOeDIUWaVjkiU
	u2PelpnIWYtNAC+dU/EsFd6kc3qNufK82eQ9P9FFyCg==
X-Gm-Gg: ASbGncsCIXEz4KfkoHd4A3bPisCy9sPzBO1GciurZfze1ost5t1K7z1xaF+CTCv1xVH
	aN1wlZ0o6DyhetYAB+FhZR2WhuhIf8IhYT4aMNQSNLTAB5EW8bNNuP6vnAK64l993y62fYoE91l
	VI0QDXZNbPZKTllqkJ18Yg2IFhgrdGvi2c1+kvnMWUpd5F724sEiMz8fYm2i2t3+McqlglpfaXB
	5PSZ7F1mYhduu39lf4=
X-Google-Smtp-Source: AGHT+IHHkURi8B2o/4zRpbceYSK5peOTCukcS7TN3aV1RdQ+I1LvQUMDMhIAD9wu5TYxwZrH3wzL9O70PnE8RRwWRSk=
X-Received: by 2002:a05:6512:2351:b0:553:2e42:fffb with SMTP id
 2adb3069b0e04-55e007af767mr477220e87.33.1755585056179; Mon, 18 Aug 2025
 23:30:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250814155548.457172-1-apatel@ventanamicro.com> <DC5HEJRMZ84K.34OPU922A7XBE@ventanamicro.com>
In-Reply-To: <DC5HEJRMZ84K.34OPU922A7XBE@ventanamicro.com>
From: Anup Patel <apatel@ventanamicro.com>
Date: Tue, 19 Aug 2025 12:00:43 +0530
X-Gm-Features: Ac12FXyJ8d4Eeyc3Nquuqj0vADLxjc_tq1DtUjG2ODWh3IKeJDYP9l_pzAP_rIM
Message-ID: <CAK9=C2X8-DBi7qQ87kMA0AiVdiFH0_4L4mzzZzbeCg2eiNm8Qg@mail.gmail.com>
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

On Mon, Aug 18, 2025 at 3:59=E2=80=AFPM Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcma=
r@ventanamicro.com> wrote:
>
> 2025-08-14T21:25:42+05:30, Anup Patel <apatel@ventanamicro.com>:
> > This series adds ONE_REG interface for SBI FWFT extension implemented
> > by KVM RISC-V.
>
> I think it would be better to ONE_REG the CSRs (medeleg/menvcfg), or at
> least expose their CSR fields (each sensible medeleg bit, PMM, ...)
> through kvm_riscv_config, than to couple this with SBI/FWFT.
>
> The controlled behavior is defined by the ISA, and userspace might want
> to configure the S-mode execution environment even when SBI/FWFT is not
> present, which is not possible with the current design.
>
> Is there a benefit in expressing the ISA model through SBI/FWFT?
>

Exposing medeleg/menvcfg is not the right approach because a
Guest/VM does not have M-mode hence it is not appropriate to
expose m<xyz> CSRs via ONE_REG interface. This also aligns
with H-extension architecture which does not virtualize M-mode.
We already had discussions about this in the past.

As such, we have two options. One option is to expose
hedeleg/henvcfg via kvm_riscv_config and another option
is to have a separate ONE_REG for each FWFT feature.

Separate ONE_REG registers for each FWFT feature is better
than directly exposing hedeleg/henvcfg via ONE_REG because:

1) Once nested virtualization lands, we will be having separate
hedeleg/henvcfg as part of nested virtualization state of Guest
which is trap-n-emulated by KVM. The existence of hedeleg/henvcfg
in kvm_riscv_config and nested virtualization state will only create
more confusion.

2) Not all bits in hedeleg/henvcfg are used for FWFT since quite
a few bits are programmed with fixed value based on KVM
implementation choices (which may change in future). Also,
things like set_debug_ioctl() change hedeleg at runtime
which allow KVM user space to decide who takes breakpoint
traps from Guest/VM. This means value saved/restored
through hedeleg/henvcfg in kvm_riscv_config becomes
specific to the kernel version and specific to host ISA features.

3) We anyway need to provide ONE_REG interface to
save/restore FWFT feature flags so it's better to keep the
FWFT feature value as part of the same ONE_REG interface.

4) The availability of quite a few FWFT features is dependent
on corresponding ISA extensions so having separate ONE_REG
registers of each FWFT feature allows get_reg_list_ioctl() to
provide KVM user-space only available FWFT feature registers.

Regards,
Anup

