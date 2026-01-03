Return-Path: <kvm+bounces-66974-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 79649CF01DF
	for <lists+kvm@lfdr.de>; Sat, 03 Jan 2026 16:29:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C55653026B1A
	for <lists+kvm@lfdr.de>; Sat,  3 Jan 2026 15:28:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2439B30E830;
	Sat,  3 Jan 2026 15:28:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kLmTPJ4P"
X-Original-To: kvm@vger.kernel.org
Received: from mail-vk1-f181.google.com (mail-vk1-f181.google.com [209.85.221.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC9BF2C0F83
	for <kvm@vger.kernel.org>; Sat,  3 Jan 2026 15:27:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767454081; cv=none; b=uwzMZj4Ua1f9BIsp2pKgEzRi3FNKFo1Wf+f0wcRNaftH4QaCDQZjjEVzwQ5AgR37qN7wLWGxAl7dKO1kZ+kMXHPmtbv7P0NEYYil8aB1HnGgkp/+nXKF7danPGAvNLs2b7ekVb7LiXcYPy/kQhh/6GeZFq/Ur4pn+14CH+hm7m4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767454081; c=relaxed/simple;
	bh=nBOroY1wUfLzoRQnLoQmf/ehNz2a6Xa1YibQINSAspM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=X8W3a3uWpYp0n763OtqLMjI1FwUXNOooOiRiQ14JYpqkrAYbyA0MW/shMlRYfI5xi2hioPBRBRj9VIb2pkIM83frstd58qPLXxYH3a9E5xAunBfpRJWXm+nIo5gw8ur/KCIKxe+dkmoFIzLTCi3PR1ZzJTERIHk9+k5gUVcPbnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kLmTPJ4P; arc=none smtp.client-ip=209.85.221.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-vk1-f181.google.com with SMTP id 71dfb90a1353d-5599688d574so3447000e0c.2
        for <kvm@vger.kernel.org>; Sat, 03 Jan 2026 07:27:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767454079; x=1768058879; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ruX6hkZHpdO19qjzRbCVwQHVnwKXr2Vj+4KOiXtfqv4=;
        b=kLmTPJ4PR9bn9QzKGcvQZhGzwRlCY+BluLeM01BCDbCxoTw06goezvsFzFgRBxiloH
         4GdgnTuGQXwWWruwUrAwx8Kcep3oXZapjUanQosVr80BAAqhVCM5+QzOTcGW2WxzrvXb
         CmZXubztrN0ljmPxwC0PbngoJDbw6u3C00xwOsSXzb5AHRMEhryGW9GYsLn9INfdcbLl
         AsGYtgqhG1R58NpMHowY54A71SvIzrlsIi9OO5lXOu+rWFkSykVu+ARDvlGsnF+bJPjd
         F40e52hOn2vSzch/TEfWhSIVf1JXsr4XGvb5uaovbTx85v6M/KF3rmqUbhWcnh4fVpVe
         VjeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767454079; x=1768058879;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ruX6hkZHpdO19qjzRbCVwQHVnwKXr2Vj+4KOiXtfqv4=;
        b=pd173W6JdvW9Ydi8SDd9Jvg4zBrcI1Y0fZ+eDgIw77aDrS2Ae53uX980/i+o9Zvk+g
         LZDIFPucNOOUOUi+j8/laVcmsPSndJ8876mqbmjsQb2KcP94ivq2s78hcdni1P56/j/W
         GH4vdhR2TbB6zk9afVIcP7JcN9RfioHTIVnzdThx8iokACoOLX/O5evF6q8+9vjTQRUe
         cAYLe6T2mvmdBMmKt3nfPg8sTOR9PkTJb59re2Mm4XplAvUYmnarcMaSnbRGr/DAxx/C
         XDrFzNpLmbCtyUrhxDnrzQjmjYkrXDip9FqPJIlj6bH4V2ta39ALNfy0+hK4HgmESokw
         ZsRg==
X-Forwarded-Encrypted: i=1; AJvYcCWvQojV2j8TrTM/6UBd9iJpxc/t+gJUs8vNWMIbq76/fvVHtGtY/kkIdbE5EJwximqTu3Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YyZsM0eEY17WDqktLFqzvJXehZRi273SIsFij5HQ7usp59BTNl9
	b8ZFt3ZAl8vJDKixshN6nGQj0wmVo46Y31ThUXqieMIEjwCnAD/zb7zHXFVYRW4k9TOiW8CEQ1e
	OMLKiJWmUlIO7NkTtXXzZbFB+y00ilko=
X-Gm-Gg: AY/fxX4tTYxqWcANNs5y1NCtg10R1//EHSCr1QsIRWu5VCuCH1uTeaES6uN5P8iJvxI
	qK6Nv+4P2af1bD/LaqpmfJ79Bf8EyMUlak2HwCrBzNObff9xPpU49S7k5MBFZwQBL8GpaQ8l+Tw
	/xNGuKniWXfJui91dWVYq9gPgHXyJoDoIHZ+M3nD3+GkqlTMwfZEEWUqO8cr3Zp9hNPlfs8nLgD
	HhhdYWte0BRY7hOPHWzKkL0PrXLQubAs4llQyWpC7UWmEMYKX85Mp64M6fqhu9mduzidkeBHVv7
	SahsIkbBQMAMWVY7+UgZdkS1512TkQ==
X-Google-Smtp-Source: AGHT+IH4gY4RfbC6mCW6a26ygEBFnWc5dKuuMqfKZP9/F7nbOwJpx2ZHveFzv9IC2z6uJv1SWOQB2aZTEup8AesAsu8=
X-Received: by 2002:a05:6122:1d06:b0:559:6d5c:9722 with SMTP id
 71dfb90a1353d-5615bbaa53bmr12417664e0c.0.1767454078672; Sat, 03 Jan 2026
 07:27:58 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260103094501.5625-1-naohiko.shimizu@gmail.com>
 <20260103094501.5625-2-naohiko.shimizu@gmail.com> <CAK9=C2XTi9Gjy0oJExGyaVvPbh2+cJzmeea5JnMR4d3kbvDJDA@mail.gmail.com>
In-Reply-To: <CAK9=C2XTi9Gjy0oJExGyaVvPbh2+cJzmeea5JnMR4d3kbvDJDA@mail.gmail.com>
From: Naohiko Shimizu <naohiko.shimizu@gmail.com>
Date: Sun, 4 Jan 2026 00:27:49 +0900
X-Gm-Features: AQt7F2rlTBHoChBm3AeMEsf79WeYBG_gY4U7DCYfbuqICMO-T2SE5U5F85_BEa0
Message-ID: <CAA7_YY_WuAR7-VUEuu8D5=aZZSqASGwShawxbC-jKp+S2WRd5Q@mail.gmail.com>
Subject: Re: [PATCH 1/3] riscv: clocksource: Fix stimecmp update hazard on RV32
To: Anup Patel <apatel@ventanamicro.com>
Cc: pjw@kernel.org, palmer@dabbelt.com, aou@eecs.berkeley.edu, alex@ghiti.fr, 
	anup@brainfault.org, atish.patra@linux.dev, daniel.lezcano@linaro.org, 
	tglx@linutronix.de, nick.hu@sifive.com, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Anup,

I have just submitted the v2 series with the detailed descriptions as
you suggested.

v2 link: https://lore.kernel.org/lkml/20260103152400.552-1-naohiko.shimizu@=
gmail.com/T/#u

Regards, Naohiko Shimizu


On Sat, Jan 3, 2026 at 11:46=E2=80=AFPM Anup Patel <apatel@ventanamicro.com=
> wrote:
>
> On Sat, Jan 3, 2026 at 3:16=E2=80=AFPM Naohiko Shimizu
> <naohiko.shimizu@gmail.com> wrote:
>
> Please add a detailed commit description about why the
> new way of programming stimecmp is better. Also, explain
> what the current Priv spec says in this context.
>
> >
> > Signed-off-by: Naohiko Shimizu <naohiko.shimizu@gmail.com>
> > ---
> >  drivers/clocksource/timer-riscv.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/clocksource/timer-riscv.c b/drivers/clocksource/ti=
mer-riscv.c
> > index 4d7cf338824a..cfc4d83c42c0 100644
> > --- a/drivers/clocksource/timer-riscv.c
> > +++ b/drivers/clocksource/timer-riscv.c
> > @@ -50,8 +50,9 @@ static int riscv_clock_next_event(unsigned long delta=
,
> >
> >         if (static_branch_likely(&riscv_sstc_available)) {
> >  #if defined(CONFIG_32BIT)
> > -               csr_write(CSR_STIMECMP, next_tval & 0xFFFFFFFF);
> > +               csr_write(CSR_STIMECMP, ULONG_MAX);
> >                 csr_write(CSR_STIMECMPH, next_tval >> 32);
> > +               csr_write(CSR_STIMECMP, next_tval & 0xFFFFFFFF);
> >  #else
> >                 csr_write(CSR_STIMECMP, next_tval);
> >  #endif
> > --
> > 2.39.5
> >
> >
>
> Regards,
> Anup

