Return-Path: <kvm+bounces-49410-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E1A76AD8BD1
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 14:11:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 979CE17ABFA
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 12:11:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB69F2D6637;
	Fri, 13 Jun 2025 12:11:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="Ov/9AN5N"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-f41.google.com (mail-oo1-f41.google.com [209.85.161.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D575A275AF7
	for <kvm@vger.kernel.org>; Fri, 13 Jun 2025 12:11:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749816706; cv=none; b=c4vowSf6g+7zH6yoMlMplFMYbRHyEyeqMeqzC3isC1P0Ya49hO3YCYUl4I41CKjrWNxO4opnRW8CkHBdgz+a2/ONRCu5DSBP/T5d6ecKqQpTFcsCp/Bzu+sxwNIO8I8RtYpX6Pvvezt8fBi/MXPxoATjIQtV2d76ZedYcMweDAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749816706; c=relaxed/simple;
	bh=PCmyTvAo0Y9E5L3Vm9scl9nxwaWyZ/FjeUDc34zHLvI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bZkVO50Cl2QVuDFP6F29Z1hw/IcnI99JKbTL638SJ0M7Dts+06bxNYXomU5ONIZmVm8YlY6AC/wM0nw+pEI9RcY7mmWRQ11Q/lRH3XVhy5o2zSRQBpmqcE4SG2dwegMEy9G+iKnE6XtbNbTrFEIofncwqGEoQi3iVVXJTSt7IWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=Ov/9AN5N; arc=none smtp.client-ip=209.85.161.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-oo1-f41.google.com with SMTP id 006d021491bc7-605fda00c30so1154227eaf.1
        for <kvm@vger.kernel.org>; Fri, 13 Jun 2025 05:11:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1749816703; x=1750421503; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SsOlh25eLPnAb9J/+yH/D8rpShrHOWsq5A94rPdZuNA=;
        b=Ov/9AN5NpLmzXdI4yon0O4Y/KxRCiFKbzEtV/4t3NT1t7skYjeGBThYV1yWthkcGsx
         WVJd+hU4R7VPHZzsOsDWS2g0g8Y6CFX+I8U2wMXx4vwXzDuzk2I4QIstnMqppndMabmU
         hzNtrKJZrSpXLkwdPGh9B0LcMVfNqQkVze4bkqaHeAO0Rz8HQC6jjgDt8zMOeW6Tkexq
         rSgOf9O7vhnwBfz+e3YtvYe4uiHgIeOrFsKV3Tghv8KWZncwWdp2glvda302Gnz8K1sh
         GBrNmxNayLiaOZ9GFtYkAssIIkaIPNfKPjRg3FC7raiAycLmXdWYLZUCLb9goL9fLvx8
         XAog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749816703; x=1750421503;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SsOlh25eLPnAb9J/+yH/D8rpShrHOWsq5A94rPdZuNA=;
        b=ANhaxNnOkVQs2hUMHyBPfsO3tjXNuaPc00sj2nv2EGvI2MV3thGD+wjTRn5QhkmKjD
         gG8ITSZXwHFuXnK4JlJn5TUS6f9QHw32/vdYmOnu9QWtAYs47o0LoD0xGjam9LXKSrkZ
         GvndOKCjs92xpNbm6mTjzqlCUy/XfzIr0SfYl1E1OsizREvmh6jmZQzEHksfjiUh/pEv
         KnHtAbu1w73KlmQnRp/oeMJ2YWO8NjN9yasU93tvB90DXInqlsCvCqzxmA1z3udjuW7E
         D8rN357uI3ZSKtrIbsWdyQ+9EROkXh3SSbA9XnoAX0mC1Yw72W7b09zYJFHnIypL7tC5
         biYg==
X-Gm-Message-State: AOJu0Yz1fYtx72+rc4+npNnlwF3TnARB/VeZ4vnTsR0oIX4+aswiv4Xl
	vftVBHXRz3Y3pos00XTDBFBA8S5VPNS6IJpebNi0/OePjk09sRzKuXIDFG6taJp39SDw0XP5FND
	35fDjTmOiQerqxsJbL6F6JSeCxbprUAn0ZwN/wtf5fFwrcjqPcCBYbmw=
X-Gm-Gg: ASbGncs8nWa7n6Mw8G/Sc2V2rQBuku5OVC5Aaw21fKibYAEYBuK4sBCcGSR06xzN2o4
	mX60D9cIEswG7eToCVqhLzjgWAGBsGxmKv5MpAex/kScc5B0D6RafiqL/CT45ulDlJ/340LLEdW
	Aj8iEAi7b1/k6HNv/QMWAK7/iXGG0cYqs8Cr/aaeYmpdXpzMQbVR4KrBQ=
X-Google-Smtp-Source: AGHT+IHJC1Pv5X0E431WwxEhgIgJc8iiqdlIrKoTpZ/T0clkN02QwfmvZZtxt0sqPjGUJGPFIV/xXPIH8smfAe45evY=
X-Received: by 2002:a05:6214:2344:b0:6f8:b4aa:2a4d with SMTP id
 6a1803df08f44-6fb3e604d8bmr40326486d6.31.1749816692043; Fri, 13 Jun 2025
 05:11:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250612200747.683635-1-jesse@rivosinc.com> <20250613-68a39013932d854741a41c4c@orel>
In-Reply-To: <20250613-68a39013932d854741a41c4c@orel>
From: Jesse Taube <jesse@rivosinc.com>
Date: Fri, 13 Jun 2025 05:11:19 -0700
X-Gm-Features: AX0GCFuHUtGMaKg3_RCQsNQ4SX_YAxCzufMbBr9KEFIhZ7lDuZSYG-Ra67cDYtc
Message-ID: <CALSpo=Y1uq6zAJYgJOTnVxzaNMmms7-eVSF4U_Z2rJ1zNVU9+w@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH 1/2] riscv: Allow SBI_CONSOLE with no uart
 in device tree
To: Andrew Jones <andrew.jones@linux.dev>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-kselftest@vger.kernel.org, Atish Patra <atish.patra@linux.dev>, 
	Anup Patel <anup@brainfault.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
	=?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>, 
	Himanshu Chauhan <hchauhan@ventanamicro.com>, Charlie Jenkins <charlie@rivosinc.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 13, 2025 at 12:53=E2=80=AFAM Andrew Jones <andrew.jones@linux.d=
ev> wrote:
>
> On Thu, Jun 12, 2025 at 01:07:47PM -0700, Jesse Taube wrote:
> > When CONFIG_SBI_CONSOLE is enabled and there is no uart defined in the
> > device tree kvm-unit-tests fails to start.
> >
> > Only check if uart exists in device tree if SBI_CONSOLE is false.
> >
> > Signed-off-by: Jesse Taube <jesse@rivosinc.com>
> > ---
> >  lib/riscv/io.c | 2 ++
> >  1 file changed, 2 insertions(+)
> >
> > diff --git a/lib/riscv/io.c b/lib/riscv/io.c
> > index fb40adb7..96a3c048 100644
> > --- a/lib/riscv/io.c
> > +++ b/lib/riscv/io.c
> > @@ -104,6 +104,7 @@ static void uart0_init_acpi(void)
> >
> >  void io_init(void)
> >  {
> > +#ifndef CONFIG_SBI_CONSOLE
> >       if (dt_available())
> >               uart0_init_fdt();
> >       else
> > @@ -114,6 +115,7 @@ void io_init(void)
> >                      "Found uart at %p, but early base is %p.\n",
> >                      uart0_base, UART_EARLY_BASE);
> >       }
> > +#endif
>
> Doesn't this generate uart0_init_fdt/acpi defined but not used types of
> warnings?

No, but it should have, I'll fix it.

> We need to put everything unused under the #ifndef
> CONFIG_SBI_CONSOLE, just as uart0_read/write already are. Alternatively,
> we can keep everything out of the #ifndef and export.

The problem is uart0_init_fdt panics if no compatible uart was found.

Thanks,
Jesse Taube
> void sbi_puts(const char *s);
> void uart0_puts(const char *s);
>
> then just have a single use of the #ifdef,
>
> void puts(const char *s)
> {
> #ifdef CONFIG_SBI_CONSOLE
>     sbi_puts(s);
> #else
>     uart0_puts(s);
> #endif
> }
>
> I think I like that better since it will ensure all code gets compile
> tested all the time and allow an SBI console using unit test to also
> access its uart if it has one, just because...
>
> Thanks,
> drew
>
>
> >  }
> >
> >  #ifdef CONFIG_SBI_CONSOLE
> > --
> > 2.43.0
> >
> >
> > --
> > kvm-riscv mailing list
> > kvm-riscv@lists.infradead.org
> > http://lists.infradead.org/mailman/listinfo/kvm-riscv

