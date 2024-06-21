Return-Path: <kvm+bounces-20291-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EBE6C912A9F
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 17:49:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 19A6B1C20327
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 15:49:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62F0C15B96B;
	Fri, 21 Jun 2024 15:49:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="HQ62niwU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFFA715B142
	for <kvm@vger.kernel.org>; Fri, 21 Jun 2024 15:49:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718984959; cv=none; b=Kb54ssSi1gmrtPmbQdBx9e7jnV03cpoOa6gqNW4AR6eP/wJXvTKSOChWlCm32jMM8O5seSmEl/6bbJBVlcvY76LzzLqn4N793YRTqtW1qVYDbasCtHY/g6y7E6QTqC5y1aw2BhItFQNOsIBS5AmUFvZShtE3Lm5EFrjGvFOC8yM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718984959; c=relaxed/simple;
	bh=TGFyvwNrEmQks3294HCinLZyU+qAtfD/q/6Lxua0vyo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mU72mbR5RmRyrcdNYQQUIixNTxI8efPAi5ldR+QAWyU771RRNoCxQHXFgZUnctG57/L0PaBoAIE0DxPShm1FO2kKcZuJPr+5CT7ypUe8FGtMBCLElSS2CCN20KQkWWzVFG01KamptRU8MsLRTJTkkL3ViikrFR0dNnqrOd4spgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=HQ62niwU; arc=none smtp.client-ip=209.85.167.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-52cd8897c73so793426e87.2
        for <kvm@vger.kernel.org>; Fri, 21 Jun 2024 08:49:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1718984956; x=1719589756; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=B9NGJolxVegzvzzH4Y5uH5Gg6q02FwSDu+585339v7U=;
        b=HQ62niwUxgeL3zsQuYTbu/0DGoigAuw/wptH0EAL3IaTQyfPZCF/ZQ1mxBPNrfHUzO
         vB4rfG2wUx6oNtSKluu5DTsoNX30Dg79TaBdBLEpvjvnSRhZLu2tvvekHdjV0b6EFNVw
         3w38YNB0GYDwfWC0DOC2/EEjCD+hYUFUQGX3KOp+Nt4GWiVXDhIcvPDLQhlADEXmxUSk
         vV9h/J6By9flVMQ+OE1FgPAdjGtjPsBouny9nIfpAJl2+THzFRfVJ/TmIyi/3uE0krMP
         eHPi3c6vdcR4ZJ+Emujx495hg0Qkqu0rmde37c0XMId6aq4XWsO6eOUVD66rXesw3iwV
         wunw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718984956; x=1719589756;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=B9NGJolxVegzvzzH4Y5uH5Gg6q02FwSDu+585339v7U=;
        b=MYOF5hWGJMBQZi8aVLWoWHWmNoR4QS71CtD7gIY6pCJvUMgE1YJqZuGmaPgkC8mQsh
         nAj+9yb9naW+7U0zGZaBZKW9g931vvy3ju+HN/Gqlrwar2LTw3GDn+uWu1tVPowHPdy+
         o6ryq0SrWUVzI5CF93EbpqvCeUXVWlEka7dkkgSIPnuOvhh+McEZMvIkwSMV7zvH0Z+V
         Xf3rzRh/6fPiqQCn+Twle5evDAzzSH/rb718ZX06nv/V2wNd78eQiNtRSH3FEUltDgPL
         5tCVDMVetd4gDLLAAAu/TzWaB3ITI0tHl51erIJ172G8b6u2jknP50idhgDNT7QHvyPR
         PIdw==
X-Forwarded-Encrypted: i=1; AJvYcCXJxjWFcJTkD1mbwzYl0fi/0Rv+u8ch6WAnpqP2i0FQOoTFwQlwlWf9VM37seqsF5AdfdbQbvABIlv28vhOFsFJvrzH
X-Gm-Message-State: AOJu0YxXBib2q6Mkk40QG90Suhl6/m4TDN51ApA4gj+I3JXI9dALPo68
	FF8tvzUA0GhAQk8MZ301jQJ1qAM0V8HqHtc4nLZvVxVyvebT+ef7KFigNmDnTvQX6DTPwPmbtqU
	S96+q3GPCDH+TsaC4/IYW7t8hCzFgvj171RZBzg==
X-Google-Smtp-Source: AGHT+IFmnWDjWQguDETRbwwysDxgSzCHmz0Sb7mnxeHmapku20OtEXoGJ/6GtczTTFZJqaN+mutlTjFrGhrqBNpBLiE=
X-Received: by 2002:a19:8c0d:0:b0:52c:db7b:b463 with SMTP id
 2adb3069b0e04-52cdb7bb5cfmr580715e87.61.1718984955699; Fri, 21 Jun 2024
 08:49:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAAhSdy0wc=e5LW92Y7YdK6Bi0cxk6C1EhSyv5vMo1FxKMu_CpA@mail.gmail.com>
In-Reply-To: <CAAhSdy0wc=e5LW92Y7YdK6Bi0cxk6C1EhSyv5vMo1FxKMu_CpA@mail.gmail.com>
From: Anup Patel <apatel@ventanamicro.com>
Date: Fri, 21 Jun 2024 21:19:04 +0530
Message-ID: <CAK9=C2U6Mctz6fMOVQroDUHeCJf6HPGrKkK35BPeTkPAx2WMfA@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/riscv fixes for 6.10 take #2
To: Anup Patel <anup@brainfault.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Palmer Dabbelt <palmer@rivosinc.com>, Atish Patra <atishp@atishpatra.org>, 
	Atish Patra <atishp@rivosinc.com>, Andrew Jones <ajones@ventanamicro.com>, 
	"open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" <kvm-riscv@lists.infradead.org>, KVM General <kvm@vger.kernel.org>, 
	linux-riscv <linux-riscv@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Paolo,

On Fri, Jun 7, 2024 at 12:20=E2=80=AFPM Anup Patel <anup@brainfault.org> wr=
ote:
>
> Hi Paolo,
>
> We have one additional fix for 6.10 to take care of
> the compilation issue in KVM selftests.
>
> Please pull.
>
> Regards,
> Anup
>
> The following changes since commit c66f3b40b17d3dfc4b6abb5efde8e71c469718=
21:
>
>   RISC-V: KVM: Fix incorrect reg_subtype labels in
> kvm_riscv_vcpu_set_reg_isa_ext function (2024-05-31 10:40:39 +0530)
>
> are available in the Git repository at:
>
>   https://github.com/kvm-riscv/linux.git tags/kvm-riscv-fixes-6.10-2
>
> for you to fetch changes up to 0fc670d07d5de36a54f061f457743c9cde1d8b46:
>
>   KVM: selftests: Fix RISC-V compilation (2024-06-06 15:53:16 +0530)
>
> ----------------------------------------------------------------
> KVM/riscv fixes for 6.10, take #2
>
> - Fix compilation for KVM selftests
>
> ----------------------------------------------------------------
> Andrew Jones (1):
>       KVM: selftests: Fix RISC-V compilation
>
>  tools/testing/selftests/kvm/lib/riscv/ucall.c    | 1 +
>  tools/testing/selftests/kvm/riscv/ebreak_test.c  | 1 +
>  tools/testing/selftests/kvm/riscv/sbi_pmu_test.c | 1 +
>  3 files changed, 3 insertions(+)
>

Friendly ping ?

Regards,
Anup

