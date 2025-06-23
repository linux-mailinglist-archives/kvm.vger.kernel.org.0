Return-Path: <kvm+bounces-50426-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B057AE5790
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 00:46:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0E3B54E1A0A
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 22:46:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C4D8221DBD;
	Mon, 23 Jun 2025 22:46:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="kP5iaZ3Y"
X-Original-To: kvm@vger.kernel.org
Received: from mail-vs1-f43.google.com (mail-vs1-f43.google.com [209.85.217.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4036F1E1DFE
	for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 22:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750718806; cv=none; b=GD8To2wkhywMA1+3tr8PfoagQenwXKclFMZjqPPBpfmve8rVayUhBJfumrJIJztdniRgUeE3ZfQaFn9sYVLXt0z0sZTm3yKS3cijDmHk5H7blOD1Aq7oHgjdZdjrNkR6Gg9lO6EvGAvUCSq+b0hxNZCtB/qUhsAu2Uhq13hvEws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750718806; c=relaxed/simple;
	bh=aB8q6uQ5QYvHj+vZzXwzH1v84Y6Pcwj3l0cxll3CiDo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sVrEKnXFi10bm34BSu0ltlzxWK8MymlIqNY+RHh4LeuGfG9PeuuBQAIprVD2WDLrMiE/pdq/j9y9u4dFyvzUmRUZypA4nUiwRlg2jt5En3caKOd1QFPoRnkRZiOniMcqL+W3HR0XUvyuRFJR0qKyVA7Aa66C8Z6xGunyQ6r7QxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=kP5iaZ3Y; arc=none smtp.client-ip=209.85.217.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-vs1-f43.google.com with SMTP id ada2fe7eead31-4e8110ac0f5so1116974137.0
        for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 15:46:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1750718803; x=1751323603; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ym0HxdMynda5jpDn6I4eu6hPVQjdVA1rMVxf5FN/Ffs=;
        b=kP5iaZ3YVlMqB6c4yGPGsyAfPaqDoe1wfZChxvG3nogGZ+vEOoFYg+zuD3w2uDI3zw
         tnuR2sqAfbu037i2GZlm0dVwAwN8w0jRv/1kxF20+8Fxei2vNe2E00oIbcq9Eo68lcB5
         JViJIKWEVPHzcQeeyw+VjzdDM+AHwfLEck6MC9NRtuIQXi7ezVn+OXvnrMQbSmrz1QjJ
         YrgFvStBlBlIv3zhD0TV5A6qczs573cIpX8qhYBHD47MptJ6Q/XQRQWqvxVleVeJekhf
         RffanWtS2tLymAFTvBoXXM6eZdjBrzjJWOZ0iCSei5Da/fvGfRCOfctYxKGhXBgNs/Oi
         swTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750718803; x=1751323603;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ym0HxdMynda5jpDn6I4eu6hPVQjdVA1rMVxf5FN/Ffs=;
        b=XsVEAY7fe6CWYY2yuLQCF26vkbCH6kqAjNyJ7tePCpHn36UNtBMra6mHC2Lm+xuADJ
         0K52++Hdk51mTRhc3htociWGzQQQEvgNktA6N/DLQBZ5cHifaUxINOAwUVgZIArAE9Ob
         11BOKYfXPcRTKXm+hJQNrA6ATrSXmuUwahjAdZ2qaNrxj26h39kSLRQIgZo4NNKdtuOT
         qy4j9KB0lXxI07JyvYIl/RA0Np/eU6FpahG4kOoUr7FdBVeEaz3wzGb2vmL0efGfezBO
         cQ+HclS7xSdmiozCRtIqhdVOWBn+W/QSEKd9QctI2xcauNU28lUSBdFO6U0g4vXlcbty
         h4EA==
X-Gm-Message-State: AOJu0YxXe/qW1tXOqEWCMfidRawBzzJwURann0XPDPxqHBzVWVjFffek
	tUdRSSeahQDydS+0Dmm3qaR/2KUbdABT32VZIiCQlz+U33Eu9ppsI5j9kJS9cIaps73eFNcMl/R
	G1S403HbA+f8bjQsOwTfvwg28o5818TFnzXbyccGPcQ==
X-Gm-Gg: ASbGnct6l4mE8p2iOqGtpMVc3UurweBewf1N3JfztPv8j/XOlKlm0YL7s9uoHAYdJdn
	nsZ1oSxIq3b3BFzO38J9L+iOzasulk+Dzxs+hV1ugdFRCxyTERRr0LSwrrRR3fd3GRcXDVU0lg3
	KtIsMupP29yO4a6HyGYRI16XE3qgMkJbcXuYQNi98zZC9F
X-Google-Smtp-Source: AGHT+IFFi5eDNgPmLRk5B8kDGRwTLx842aYBtGrbpiDH5LOZp5sY2aVIe4JANq3ZFJwGeg3PELwobnK+RDfeH6qpX80=
X-Received: by 2002:a05:6102:6ca:b0:4e9:94a3:1a34 with SMTP id
 ada2fe7eead31-4e9c299dff9mr7875257137.16.1750718803142; Mon, 23 Jun 2025
 15:46:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250620155051.68377-1-jesse@rivosinc.com> <20250623-c4c3115e6402176024bac6ea@orel>
In-Reply-To: <20250623-c4c3115e6402176024bac6ea@orel>
From: Jesse Taube <jesse@rivosinc.com>
Date: Mon, 23 Jun 2025 15:46:31 -0700
X-Gm-Features: Ac12FXzOlaSm8467YuophwGI70NXmcwcBfhPWLQv-KNC7l7Ri6aKh7MVt_taL8w
Message-ID: <CALSpo=YQun4owTSkCULpgSu386nHK4q8kuU--oif4Wtw2S_V1w@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH] riscv: lib: sbi_shutdown add exit code.
To: Andrew Jones <andrew.jones@linux.dev>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-kselftest@vger.kernel.org, =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>, 
	Charlie Jenkins <charlie@rivosinc.com>, James Raphael Tiovalen <jamestiotio@gmail.com>, 
	Sean Christopherson <seanjc@google.com>, Cade Richard <cade.richard@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 23, 2025 at 10:01=E2=80=AFAM Andrew Jones <andrew.jones@linux.d=
ev> wrote:
>
> On Fri, Jun 20, 2025 at 08:50:51AM -0700, Jesse Taube wrote:
> > When exiting it may be useful for the sbi implementation to know the
> > exit code.
> > Add exit code to sbi_shutdown, and use it in exit().
> >
> > Signed-off-by: Jesse Taube <jesse@rivosinc.com>
> > ---
> >  lib/riscv/asm/sbi.h | 2 +-
> >  lib/riscv/io.c      | 2 +-
> >  lib/riscv/sbi.c     | 4 ++--
> >  3 files changed, 4 insertions(+), 4 deletions(-)
> >
> > diff --git a/lib/riscv/asm/sbi.h b/lib/riscv/asm/sbi.h
> > index a5738a5c..de11c109 100644
> > --- a/lib/riscv/asm/sbi.h
> > +++ b/lib/riscv/asm/sbi.h
> > @@ -250,7 +250,7 @@ struct sbiret sbi_ecall(int ext, int fid, unsigned =
long arg0,
> >                       unsigned long arg3, unsigned long arg4,
> >                       unsigned long arg5);
> >
> > -void sbi_shutdown(void);
> > +void sbi_shutdown(unsigned int code);
> >  struct sbiret sbi_hart_start(unsigned long hartid, unsigned long entry=
, unsigned long sp);
> >  struct sbiret sbi_hart_stop(void);
> >  struct sbiret sbi_hart_get_status(unsigned long hartid);
> > diff --git a/lib/riscv/io.c b/lib/riscv/io.c
> > index fb40adb7..02231268 100644
> > --- a/lib/riscv/io.c
> > +++ b/lib/riscv/io.c
> > @@ -150,7 +150,7 @@ void halt(int code);
> >  void exit(int code)
> >  {
> >       printf("\nEXIT: STATUS=3D%d\n", ((code) << 1) | 1);
> > -     sbi_shutdown();
> > +     sbi_shutdown(code & 1);
> >       halt(code);
> >       __builtin_unreachable();
> >  }
> > diff --git a/lib/riscv/sbi.c b/lib/riscv/sbi.c
> > index 2959378f..9dd11e9d 100644
> > --- a/lib/riscv/sbi.c
> > +++ b/lib/riscv/sbi.c
> > @@ -107,9 +107,9 @@ struct sbiret sbi_sse_inject(unsigned long event_id=
, unsigned long hart_id)
> >       return sbi_ecall(SBI_EXT_SSE, SBI_EXT_SSE_INJECT, event_id, hart_=
id, 0, 0, 0, 0);
> >  }
> >
> > -void sbi_shutdown(void)
> > +void sbi_shutdown(unsigned int code)
> >  {
> > -     sbi_ecall(SBI_EXT_SRST, 0, 0, 0, 0, 0, 0, 0);
> > +     sbi_ecall(SBI_EXT_SRST, 0, 0, code, 0, 0, 0, 0);
>
> We can't do this because a kvm-unit-tests exit code is not an
> SRST::reset_reason[1]. This could result in the SBI implementation
> returning an error, or doing something else, rather than shutting
> down.

Yes that's why there is:
+sbi_shutdown(code & 1);
Admittedly it should probably be:
+sbi_shutdown(!!code);

>
> If this is a custom kvm-unit-tests-specific SBI implementation, then
> we could pass in a reset_reason in the 0xE0000000 - 0xEFFFFFFF range.

That still doesn't guarantee it to succeed.
In the exit function we can add a fallback like `sbi_shutdown(0);`,
but reason code 1 (System failure) should always work.
If anyone wants to use it for SBI specific codes, that's fine,
but I only added it for the No reason and System failure exit codes.

Thanks,
Jesse Taube.

>
> [1] https://github.com/riscv-non-isa/riscv-sbi-doc/blob/master/src/ext-sy=
s-reset.adoc#table_srst_system_reset_reasons
>
> Thanks,
> drew
>
>
> >       puts("SBI shutdown failed!\n");
> >  }
> >
> > --
> > 2.43.0
> >
> >
> > --
> > kvm-riscv mailing list
> > kvm-riscv@lists.infradead.org
> > http://lists.infradead.org/mailman/listinfo/kvm-riscv

