Return-Path: <kvm+bounces-23034-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6FF8E945DC8
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 14:24:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 25C78284087
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 12:24:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC0401E287D;
	Fri,  2 Aug 2024 12:24:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="m81Wx4s5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E0A414A0A0
	for <kvm@vger.kernel.org>; Fri,  2 Aug 2024 12:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722601461; cv=none; b=Wr6s680kzxJELdiGVqO1ETPeAQVx82x5ZAVxbfwT5zE/mM6ZZpH1KHkctVBqUfwSRxr1JTBN0F+/a80iiHM44062NKdWzMSyTtrIoBCibF1LWvJss3Uox3VuSeGyp9edBjPSRfsBJvttJE7nOyiF5L91qYaVRm85+1x2Mxi2nBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722601461; c=relaxed/simple;
	bh=lvo5+6UsKAFynNqRe05TJZGMuyygOKXKkhlB514CkG4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TPqhVB/puSWArmySheW8zV6FGtK/47HvnnElcRvdcUKIROsWkocHH4bRCIOCsM28v29ixAoGyLV6Td5D7tfvakLcESyXbznimFELFWLYi2ucvgrV2IEsGtTfTMXDvL1f/giDUvf7faQhledyZbYuh/Lsa+Qr2ngXMDWUUFTzO+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=m81Wx4s5; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-a7b2dbd81e3so1042813066b.1
        for <kvm@vger.kernel.org>; Fri, 02 Aug 2024 05:24:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1722601458; x=1723206258; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BJNZqF0Zh3k5jzM/AvOUZoBe5/Mkh0ubv/iX2ObJz9Q=;
        b=m81Wx4s5s21ZgJRErF2+BSzveZn+Ga0djLcSkNiD9haMuWzwk5nXv3dVnumYo128fh
         /A52NzabqQwCr+gyIyvkqPtxPY/D+Hm/mq0xp0epJNt7AKmLbO/2yj+lYe71thtopIm9
         N5gUoc9WVYOOZSSly6UmdBo8+HGmG7flbpgsL+U2pWOkYNJioGF+XiIYS5LiaOVKRsRo
         hk1D0are/6cNOgCunEnClh3lMP/OlLOBO2NjIi55dAkrVpx3s+Tz68WZAX0UzTdFtge3
         7Yp7Hz0Ask7qLUSPrU3rt93YhcKvuzZYV9F79WbA0sYBdIrJaZ/YAaoSaz0bigS9kPep
         Q+pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722601458; x=1723206258;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BJNZqF0Zh3k5jzM/AvOUZoBe5/Mkh0ubv/iX2ObJz9Q=;
        b=ObVNcuxxXD15gTM1ujxXHXDTVAS+w6sVnhcY7oBmmhlmnDcTKevTrXBQdpPX6HOVQQ
         q8k82mRPqnhOgBEQd9bCeclsgXnIQ3O+zctn2kjpRYxDFVIjKNvCEz7yYnPCUTXJ3c1J
         IIS6WCBvW2POjn1M5OwyH3UOBUwAvxRk/PkGNPaKUhEBWGyiNXTVKFJ2IGRRlwm4FURX
         Poha9Qm29mQCcK/JXKniGZVbZ3nChR4W+kmLfoTs26o3tXIrRWL+Wm02yIo9JSooF1Kg
         09NajfK38ikg/N8BytG/QPZX/3jRVTzf/zrXT514yCYQncm+UbKAvVBYptSzBHkcO1VD
         D2pw==
X-Gm-Message-State: AOJu0YxWWOltZbw+4ejYBh8Et1I9wq7LRFh5m/PM0r13o/rxKxoLk6zB
	NDheChdH5fhk08LIlV5nflZh0ypN2XddzR8EFV1GX0FFfkxLRRV0lWtJjmgKXJYa7hWfgieeEuP
	p7nmVac82CQfPEXak9F6p0QBivpw=
X-Google-Smtp-Source: AGHT+IGgbFOw+/SRWfhrFaBaQrhRBAiotBxESwEGCCWTe6BuBaR+vrrsoxZJIn00Cj1nFImdNijpQeHnLbkyAjeyIb8=
X-Received: by 2002:a17:907:e8a:b0:a7a:a212:be48 with SMTP id
 a640c23a62f3a-a7dc50feb22mr204121366b.56.1722601457186; Fri, 02 Aug 2024
 05:24:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240730061821.43811-1-jamestiotio@gmail.com> <20240730061821.43811-6-jamestiotio@gmail.com>
 <20240802-e1bd80fc34bfd2caaf52d0b8@orel>
In-Reply-To: <20240802-e1bd80fc34bfd2caaf52d0b8@orel>
From: James R T <jamestiotio@gmail.com>
Date: Fri, 2 Aug 2024 20:23:37 +0800
Message-ID: <CAA_Li+uGHLsAzW_Ba1TVQZVoAmM7MWec3Bi5W1ms5Vnh05xbgQ@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH v6 5/5] riscv: sbi: Add test for timer extension
To: Andrew Jones <andrew.jones@linux.dev>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, atishp@rivosinc.com, 
	cade.richard@berkeley.edu
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 2, 2024 at 4:36=E2=80=AFPM Andrew Jones <andrew.jones@linux.dev=
> wrote:
>
> On Tue, Jul 30, 2024 at 02:18:20PM GMT, James Raphael Tiovalen wrote:
> > Add a test for the set_timer function of the time extension. The test
> > checks that:
> > - The time extension is available
> > - The installed timer interrupt handler is called
> > - The timer interrupt is received within a reasonable time interval
> > - The timer interrupt pending bit is cleared after the set_timer SBI
> >   call is made
> > - The timer interrupt can be cleared either by requesting a timer
> >   interrupt infinitely far into the future or by masking the timer
> >   interrupt
>
> I've modified the "or by masking the timer interrupt" test to work as I'd
> expect it to based on a bit more thought about what the SBI TIME extensio=
n
> spec is trying to say (we should clarify the spec with the PR you've
> written). I also added a test for ensuring a timer is pending immediately
> when setting the time with a value of zero. All tests pass.
>

Sure, I will reopen the clarification PR and work on it.

> I also moved some code around a bit and a couple other minor cleanups.
>
> And (drum roll, please), it's now merged!

Awesome, thanks Andrew!

>
> Thanks,
> drew

Best regards,
James Raphael Tiovalen

