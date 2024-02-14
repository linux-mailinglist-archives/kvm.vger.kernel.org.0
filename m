Return-Path: <kvm+bounces-8699-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 640B4855070
	for <lists+kvm@lfdr.de>; Wed, 14 Feb 2024 18:36:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 96DB01C211AF
	for <lists+kvm@lfdr.de>; Wed, 14 Feb 2024 17:36:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 583577C6D4;
	Wed, 14 Feb 2024 17:36:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HV6EdSim"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 173B15579B
	for <kvm@vger.kernel.org>; Wed, 14 Feb 2024 17:36:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707932175; cv=none; b=Kkg8VBlqmkR9CCThlNA9TqXe4hhWfMpfsbwTTetrzwnMn0N5mngGkruTC3SbsCW9Npgjo/L6QBMRROXNjhBawgX13UU6VcaQhEarMWqztOe7NrVp5ONAGIblBIoTADtlcjRlWxnYQFHx8LW6CToONvKmU1MxbU8OW1mWS8xu+Ow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707932175; c=relaxed/simple;
	bh=BTxzQRUiDmN2XGR+yNXCCUDOsAUtIJNIeSzAtnzscAE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=B0FPniA0e1grVmfEi4aJjlsQ8/0+MCJuenX4+BBgq05qGVw9RUc6vITsiaieoG4qSgM1I9tH2GwT7dsH/rSJvRd9iOBO8fxt9caWkoZqEXmqsUe1oxvIEqH7e0itMcbgWP/lalzAEScsmdEtYAkxNUjD1y6ZbLMr3iSBmjRKFqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HV6EdSim; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707932172;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1GcHMMWy+FZF1FwbsgoWJxHZU4oMtx7MWWdSce+ajXI=;
	b=HV6EdSimBQ8iPhuo2v/7/m0a+UVElCKN3ucDrAtdBSmFRnZ/SabL0lxion2LgWHe3c7d8z
	o/0Kw8KZvNqxO/nVVpPx7VtlB3SBxNglJ0o6qUflGugFrdeYTRfJ+1txfKmWK9pCigyIce
	WrkGEDlSH97nRhS9iOI2MggdvIejprQ=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-88-5JQNXcJaOgOLjdbhvMNDsQ-1; Wed, 14 Feb 2024 12:36:11 -0500
X-MC-Unique: 5JQNXcJaOgOLjdbhvMNDsQ-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-33cf638ee62so76064f8f.1
        for <kvm@vger.kernel.org>; Wed, 14 Feb 2024 09:36:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707932170; x=1708536970;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1GcHMMWy+FZF1FwbsgoWJxHZU4oMtx7MWWdSce+ajXI=;
        b=jWrmIORafHRcJ0lLLIgPoQloGLrWFA3W9uFJ48q4pJfXmRxUkfMeUV1DYk2oFAzdTv
         2lIk5mx9Jt0vzej1VCYG+PUS7BrMSYeolRx0wmPttS8VCSPQyVgwWAvfDOA6RkPiQ8jY
         DoFDjG6sqIVl9Sl7eZjR/jKHTEmf0Sk+juz61PAMIYYbHEVqlz1jLzcOl8BJU6+GQSZW
         H26OlHbNgjRr6EkoKAEF+h8ROznFz7JCgVXSMGNFn4CVuqfYoIx5dufd49CNKrl7SH1E
         LskhTYicUnec/3e9p/uv1fFiuKfJWlo7JuLAQm/xp+2O5DWgC95O7+lYtJsWnDApMaQ9
         BFhA==
X-Forwarded-Encrypted: i=1; AJvYcCXVhTvkuYzMi6MZ0BLZa46YA64oZ19Mp7OQQTgf5rS/JuSTpon0RBTJ6ljGr7u7VrS1+Sas61kC1YqqZpYx2sEY9CNl
X-Gm-Message-State: AOJu0YxCi/itIrxPmS175p0quFZH+T4QSyt/Z7FZmBkmPd4NHa1It5uq
	R2HyqEGa0lIvN43lhrRRiw0zJdNOchCrTzIqxtwFgO2z6JwBwoOnMxFVl8XqdKEkkRzhiw36XLp
	kosVEVkzTYkfOLrEhLYob6NdLQ0RUOS0X/MKSfK8cdsgbPIBVYb57w41tHmLHun7SevSQol3k4u
	TB2x32zywuY+6yBakAOjm1VWDd
X-Received: by 2002:adf:ef43:0:b0:33c:e365:dfaa with SMTP id c3-20020adfef43000000b0033ce365dfaamr2503465wrp.3.1707932170354;
        Wed, 14 Feb 2024 09:36:10 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHFZOhzVtUAb05AYTKuZO41g2mr2YF2D8O/7ofLzT6isxa88O5eZzk0s55C3wmXmWoc3MFv5ywXwSxLAb/77Kw=
X-Received: by 2002:adf:ef43:0:b0:33c:e365:dfaa with SMTP id
 c3-20020adfef43000000b0033ce365dfaamr2503445wrp.3.1707932170085; Wed, 14 Feb
 2024 09:36:10 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAAhSdy3TXDCnA+hqJyNq3CiJD9LTtL_OOqX0N=GqScL1VU8FeQ@mail.gmail.com>
In-Reply-To: <CAAhSdy3TXDCnA+hqJyNq3CiJD9LTtL_OOqX0N=GqScL1VU8FeQ@mail.gmail.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Wed, 14 Feb 2024 18:35:58 +0100
Message-ID: <CABgObfZXYLTnaK3b24Uui2nMMrZGXgpCU8KaRM=rjC32vLGJKg@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/riscv fixes for 6.8, take #1
To: Anup Patel <anup@brainfault.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>, Palmer Dabbelt <palmer@rivosinc.com>, 
	Atish Patra <atishp@atishpatra.org>, Atish Patra <atishp@rivosinc.com>, 
	Andrew Jones <ajones@ventanamicro.com>, 
	"open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" <kvm-riscv@lists.infradead.org>, 
	linux-riscv <linux-riscv@lists.infradead.org>, KVM General <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 9, 2024 at 12:57=E2=80=AFPM Anup Patel <anup@brainfault.org> wr=
ote:
>
> Hi Paolo,
>
> We have three fixes for 6.8 which address steal-time
> related sparse warnings.
>
> Please pull.
>
> Regards,
> Anup
>
> The following changes since commit 54be6c6c5ae8e0d93a6c4641cb7528eb0b6ba4=
78:
>
>   Linux 6.8-rc3 (2024-02-04 12:20:36 +0000)
>
> are available in the Git repository at:
>
>   https://github.com/kvm-riscv/linux.git tags/kvm-riscv-fixes-6.8-1
>
> for you to fetch changes up to f072b272aa27d57cf7fe6fdedb30fb50f391974e:
>
>   RISC-V: KVM: Use correct restricted types (2024-02-09 11:53:13 +0530)

Pulled (but not pushed), thanks.

Paolo

>
> ----------------------------------------------------------------
> KVM/riscv fixes for 6.8, take #1
>
> - Fix steal-time related sparse warnings
>
> ----------------------------------------------------------------
> Andrew Jones (3):
>       RISC-V: paravirt: steal_time should be static
>       RISC-V: paravirt: Use correct restricted types
>       RISC-V: KVM: Use correct restricted types
>
>  arch/riscv/kernel/paravirt.c  |  6 +++---
>  arch/riscv/kvm/vcpu_sbi_sta.c | 20 ++++++++++++--------
>  2 files changed, 15 insertions(+), 11 deletions(-)
>


