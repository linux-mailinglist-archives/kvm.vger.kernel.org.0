Return-Path: <kvm+bounces-53569-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0CE7FB140C2
	for <lists+kvm@lfdr.de>; Mon, 28 Jul 2025 18:54:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3225517FE74
	for <lists+kvm@lfdr.de>; Mon, 28 Jul 2025 16:54:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F174F274B49;
	Mon, 28 Jul 2025 16:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="qbbECP+B"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f50.google.com (mail-io1-f50.google.com [209.85.166.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 772BB212B2F
	for <kvm@vger.kernel.org>; Mon, 28 Jul 2025 16:54:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753721653; cv=none; b=mmorWbdxeFABOzAZwNpl4ZKSpI55/1PZQu0L8IJhKZ2HMMVy5u1YltKrUcc9piBNQv1gPCpWok9T08OQcvPFlKCq49TLIXywd/LdH1NeAfa2/3siGihQMhuFJwxYIaRDUaccOKaQ6HoTRxymVYvF0XQbTp3dCj4E9fYaYQUFYEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753721653; c=relaxed/simple;
	bh=WH510oq+ddwKySjTSU7h7Mjv+8k1DlfRXXv65SCkRG8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Tp9WNxGYUQhsn9rKenbKBT4v7O6QrB073rj7yctlNWT7YLF11ahWk2HU+7k39Jen0DNtscKACHYRobPhkYxSILFGAZtSAnTFoFWFHZuIKJgcQ5WEXUtCcXz0hRhGw1f8Y65eP+WZ0MKyTDp7NY/iQFY+YAQslPoxvljpNP7feYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=qbbECP+B; arc=none smtp.client-ip=209.85.166.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-io1-f50.google.com with SMTP id ca18e2360f4ac-879c737bcebso4402639f.0
        for <kvm@vger.kernel.org>; Mon, 28 Jul 2025 09:54:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1753721650; x=1754326450; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WH510oq+ddwKySjTSU7h7Mjv+8k1DlfRXXv65SCkRG8=;
        b=qbbECP+BPjjAIiJLR0d0QPtd9+DU1rFl2T9G6g/AuBoF+/kaTQDfSNQrqYN3Lojiyo
         zaDSFiVS2z/d5DxPgzXceIu+8l43rZwLXNXJzmZndb/poD0aS2BJ6rfs92hc1DmYE7qw
         OJKSPAYcuy/er6Xef4uGvNMP6YdR/sTQG/oMx5BfzLHBhd6WPs4rF4QdXlQyHYaifhEX
         fgViBh4xyK+jDjxY6GQ6T6jEbhwlA4bzoZ2oEnr22yz8Lg1ZDNSLGhK7GxI6R9BQIfS6
         v5Wp9rUO2XWMtjMtm0f2CzoJso3G7+wFlkSVBFvzZqKiYmTrX60rC9u4QKNcTCcAam8r
         yhfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753721650; x=1754326450;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WH510oq+ddwKySjTSU7h7Mjv+8k1DlfRXXv65SCkRG8=;
        b=VewwjxAZvEQ+pjskqJP9Ksas5cIwcG49RBNIDBYHox4Ajf83/MH6HvQBYMNYOiY6Ih
         HWTphmMJCslKzrVU6bPq2fNDd/XKfFODYPn7rD/ckJ7CBsc/NuC6tEFs3DninEF4PwBj
         cyeDTZh3dvg6LhssssgbZQHElurzA9fMSIWa4J0Mq1sQ26kM5V4oktSFUZNvWTBGUDTc
         XqfgLoWATEDfZOpo66nuJ12oKSEdYoAbrjv0Mk+MQcAxfOoRpUsfASgi1jy3h69GKicp
         QGXcSbNVIDc4gNUoHFYkcM3ISIbpL2dHOo6h2n8DmvHVT5a8IdmH49jGP01Ql8JLtqL5
         SV5g==
X-Forwarded-Encrypted: i=1; AJvYcCXgzazjrdt9/zu0tIoMhLTCnPR0211Wu/LODU8ry5ZXxlLj548plOVOC4RoT3XmQfGvM8o=@vger.kernel.org
X-Gm-Message-State: AOJu0YwYPP7sC8F0iPFkUYFsPBukRnnm9vjDxiV6RwsTuJx9CzZVnaav
	LaJZQkPb7TuWtnGqzB/zduv4dL0tNCE/9hJWEhlPCnODaVq5JdmxV+01zldS4aD4aGjJZ5xnh5i
	pm2sItE6O5sU3tPEhOCPsbuxXv7+LBjWj5rAwOGzVkw==
X-Gm-Gg: ASbGnct1prFbyt4ssevR2yc2iNfWk6DHHkIuV3NcQDZ+G7F78PHpt2XyEc3d6IQ4SAB
	yvF2tf2KJHTRVFpxNmPkkftCx1mqz5LimlU6LnGXe1M3Qj/63b0Ed60FEP6WRft0EX/wgI/4oDH
	qXFoPrZRv2MYJ/5gnnYRNNL3+Fyq1zfnC63iaGjiZ5Nfc0c/i3z19rjbKFmSbMAPtYLsvfTL4Yd
	DSrwIU=
X-Google-Smtp-Source: AGHT+IE+ydlz1plQs5mKi/9M5YsolsQYwMvbn08BrO7ssd3p+pPCWkkLDRp1BiPYqlxZY55TBMCm6/WMQ6hV8/3ATig=
X-Received: by 2002:a05:6e02:3389:b0:3e2:9f5c:520f with SMTP id
 e9e14a558f8ab-3e3e92d90f2mr5397125ab.3.1753721650328; Mon, 28 Jul 2025
 09:54:10 -0700 (PDT)
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
 <CAK9=C2VamSz4ySKc6JKjrLv9ugcTOONAL4+NmKAexoUgw7kP6w@mail.gmail.com> <CABgObfZu2fPFaSy2EHzpD_MUwYYeYMfz6BfXmTw_h3ob1q2=yg@mail.gmail.com>
In-Reply-To: <CABgObfZu2fPFaSy2EHzpD_MUwYYeYMfz6BfXmTw_h3ob1q2=yg@mail.gmail.com>
From: Anup Patel <anup@brainfault.org>
Date: Mon, 28 Jul 2025 22:23:57 +0530
X-Gm-Features: Ac12FXxqhCPoLRJ1O8eU-7ZYNbb9bkJ8jT__-z9EkgKxYTzx-2nDiU9AnbLeyyY
Message-ID: <CAAhSdy11ZTi60=sNXT+8VcA=NtNk_AQNWvPEUUh-ov_fnciH5Q@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/riscv changes for 6.17
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Anup Patel <apatel@ventanamicro.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Andrew Jones <ajones@ventanamicro.com>, Atish Patra <atishp@rivosinc.com>, 
	Atish Patra <atish.patra@linux.dev>, 
	"open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" <kvm-riscv@lists.infradead.org>, KVM General <kvm@vger.kernel.org>, 
	linux-riscv <linux-riscv@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 28, 2025 at 10:20=E2=80=AFPM Paolo Bonzini <pbonzini@redhat.com=
> wrote:
>
> Il lun 28 lug 2025, 18:21 Anup Patel <apatel@ventanamicro.com> ha scritto=
:
> >
> > Currently, userspace only has a way to enable/disable the entire
> > SBI FWFT extension. We definitely need to extend ONE_REG
> > interface to allow userspace save/restore SBI FWFT state. I am
> > sure this will happen pretty soon (probably next merge window).
> >
> > At the moment, I am not sure whether userspace also needs a
> > way to enable/disable individual features of SBI FWFT extension.
> > What do you think ?
>
> Yes, you do. FWFT extensions are equivalent to CPU extensions. But all
> this should have been done before including Clement's work. Without it
> userspace has no way to support FWFT.
>
> Drew, I see you have Reviewed-by on the patches; please keep an eye on
> this stuff.
>
> Can you respin with the fix to the SoB line and no FWFT support?

Sure, I will send v2 PR.

Regards,
Anup

