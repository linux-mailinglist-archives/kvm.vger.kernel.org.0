Return-Path: <kvm+bounces-61030-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 34603C07101
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 17:48:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1CA313ACD54
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 15:47:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43ACC32ED45;
	Fri, 24 Oct 2025 15:47:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="ozk8+url"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C1C832E754
	for <kvm@vger.kernel.org>; Fri, 24 Oct 2025 15:46:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761320821; cv=none; b=VPNbSIDtcoxzeT51nWlrPESSC/SOcpiowoOSo84FEqg1rcoUL7qb6Ns0KpH2g82aFNwUdrr1zRxG60SfGxR9QymGXEe0WQqzbX7A3RB8lcEblCnmwxTW7pvIFjDcVCnC6dsZoTlFg82Fky+E54HfprSTcSJgnCzqowa7lVg/ndA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761320821; c=relaxed/simple;
	bh=cbo+EeuNQpaV8ZS4GCG7a4BRMY3NEk6LJyKjqlPwTLg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GnU3SLwSzGqNxy811mcp1umXnGEtwLm+vx2Rl8liN2w/TL1LeW5eXNxZSOEE4tZn8WjiULDJNS2EacOkmTjY+w6iXo25ksIu26nMGg82nrihmjgAFnijARVbJ76vNvvq/1yShdrBV/WDCzE8cW3f7ikFHINFVsWs/oIW6C1RULs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=ozk8+url; arc=none smtp.client-ip=209.85.167.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-592f7e50da2so2365253e87.0
        for <kvm@vger.kernel.org>; Fri, 24 Oct 2025 08:46:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1761320818; x=1761925618; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Qn/+5LSgb4Ivu5qW8rNSwz2BTYP5iSWYVocmoADghq0=;
        b=ozk8+urluzCBmWYwlVTjtMYshwyTQ0z80qKpFOrvvJ6GNpivdDeRMpYkgr0dVcx0kO
         KRqrLzyUr9gQ5TYFFxDLmZplQI2hgd9JJBkuoIEoVCNTon1GwUamQ4hJqGoYyBiIhmg+
         rOekpl///pgu4i6FcWGYZ8Q4MKkavUNCePT2kHYAYszJEvfG1Zr8grNbfxUUC7yR2iKw
         sDdOGVjyaKrfEfbBAS0YrJiYcbShqPg8fwZbur0hM8g7/f5YtK7gLmRuGIglHoF0WEoe
         f8vpig4rDexBQH5CfTgN9a1S/8EQdQ62eqN+CnuPBUOiqK2HqvgYO+dS+TSIJCK5CfSM
         YQcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761320818; x=1761925618;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Qn/+5LSgb4Ivu5qW8rNSwz2BTYP5iSWYVocmoADghq0=;
        b=OYXDJKkbh4eb3KczUmShIJlNbLXh4Cxf05RIfQ0XvoNJa556FUOUX2qNfj75LQ/mgA
         YK8H8wP2VrDPLiT/nC3xbHjA8NzNveeggwBuZosMtfyA76hePC1uG3ojwaVWXZH9KIlV
         dPOBW+4AvVf3VumWxKU6yCEJKnPOZXkbisH7UzG7aGXmeHzulPVgS7BKxVV+VIQrejIa
         6U6+UJUapAqWiBpxyqG5Q71r5AJJG+PBl6z+sPc/xry94XpE9sS6vT2yyilqdFHYYFVx
         jsjXSfpwvq3w3PQ81SqZl1Vz9BvHfO2hcv/T1oZA3NglL4miwI2SFguhDfx4/tQzp0n8
         Bo9A==
X-Forwarded-Encrypted: i=1; AJvYcCW4HF7IaZPPq23HE/9KNA9BZ/TkidVVyPqc9ZJ3OCzZoAwSqajSYsFJP60/KB253OjmL5o=@vger.kernel.org
X-Gm-Message-State: AOJu0YzJes4gRWpLVgm8Qn50vJwHg3n6Mzsnq0uAVoShqBiVwkqxzVN5
	VvrD8ccPHavPPUt+qGvV0989eeNgu2vimly7dpnlsOPT4kW0IwDI1lwat2I6rjzNVSPojxy0M6T
	QSyFdPA93SfDlNW0a/XrASXFMwHcdQ7Mi/70dGdTyxg==
X-Gm-Gg: ASbGncsEsMXBGp8ybRWoTRzASa+hY0O+BoBdslTAK2+ZA/GUT/7zKZGO1hz+sHXMUPm
	jhCeyltdHOQr+bxQ5qoRCu4Zw/z9tBV+co9g+ieeYFB7p2ENlXn8ngvFaDEX2hIc3LKI6YimuZx
	8x0b+H7mb6mtUCmEisqX+fxGvQS47ffpxMQIM3lQZgS4JRjG0u4jAHZqUze1UoWLKiWe6Ojg4Eg
	l72Li29ly/iiuwSBe7KgDc0RYD9FhNp+srAJuCVvcS5HG1wcPY+3MZBuS2OfA==
X-Google-Smtp-Source: AGHT+IHdluFO85waETK/KLkbS3VYmEGHof52U3/ULO+x99Eru8BPoeAX0r1u9msXeZkbSU5Z2jh0fCXXs/3AzKJBMNI=
X-Received: by 2002:a05:6512:3b8e:b0:592:ed6f:9a59 with SMTP id
 2adb3069b0e04-592fc0fa4camr1180695e87.2.1761320817702; Fri, 24 Oct 2025
 08:46:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAAhSdy0h=PuKTG=aWou_8y8qb7kSHS46TLXoXrjrTXN1xv-uQg@mail.gmail.com>
In-Reply-To: <CAAhSdy0h=PuKTG=aWou_8y8qb7kSHS46TLXoXrjrTXN1xv-uQg@mail.gmail.com>
From: Anup Patel <apatel@ventanamicro.com>
Date: Fri, 24 Oct 2025 21:16:45 +0530
X-Gm-Features: AS18NWAZshTymUeon3-SNkimUIgzYNwnvkiP5JITg3o0ZerB1osHRyFXcW_yBwI
Message-ID: <CAK9=C2VXQRGFChGB2xzkRCzf_GbH2VexjAjO2d83e_tSwhddcw@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/riscv fixes for 6.18 take #1
To: Anup Patel <anup@brainfault.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Paul Walmsley <pjw@kernel.org>, Andrew Jones <ajones@ventanamicro.com>, 
	Atish Patra <atish.patra@linux.dev>, 
	"open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" <kvm-riscv@lists.infradead.org>, KVM General <kvm@vger.kernel.org>, 
	linux-riscv <linux-riscv@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Paolo,

On Fri, Oct 24, 2025 at 4:39=E2=80=AFPM Anup Patel <anup@brainfault.org> wr=
ote:
>
> Hi Paolo,
>
> We have three fixes for the 6.18 kernel. Two of these
> are related to checking pending interrupts whereas
> the third one removes automatic I/O mapping from
> kvm_arch_prepare_memory_region().
>
> Please pull.

Please disregard this PR. I will send v2 PR with a build warning fix.

Apologies for the noise.

Regards,
Anup

>
> Regards,
> Anup
>
> The following changes since commit 3a8660878839faadb4f1a6dd72c3179c1df567=
87:
>
>   Linux 6.18-rc1 (2025-10-12 13:42:36 -0700)
>
> are available in the Git repository at:
>
>   https://github.com/kvm-riscv/linux.git tags/kvm-riscv-fixes-6.18-1
>
> for you to fetch changes up to be01d4d5c30114e9df37fca9efbb2c5cb0ad36f6:
>
>   RISC-V: KVM: Remove automatic I/O mapping for VM_PFNMAP (2025-10-24
> 11:00:48 +0530)
>
> ----------------------------------------------------------------
> KVM/riscv fixes for 6.18, take #1
>
> - Fix check for local interrupts on riscv32
> - Read HGEIP CSR on the correct cpu when checking for IMSIC interrupts
> - Remove automatic I/O mapping from kvm_arch_prepare_memory_region()
>
> ----------------------------------------------------------------
> Fangyu Yu (2):
>       RISC-V: KVM: Read HGEIP CSR on the correct cpu
>       RISC-V: KVM: Remove automatic I/O mapping for VM_PFNMAP
>
> Samuel Holland (1):
>       RISC-V: KVM: Fix check for local interrupts on riscv32
>
>  arch/riscv/kvm/aia_imsic.c | 16 ++++++++++++++--
>  arch/riscv/kvm/mmu.c       | 20 +-------------------
>  arch/riscv/kvm/vcpu.c      |  2 +-
>  3 files changed, 16 insertions(+), 22 deletions(-)
>
> --
> kvm-riscv mailing list
> kvm-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kvm-riscv

