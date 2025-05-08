Return-Path: <kvm+bounces-45831-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 717B1AAF28E
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 07:08:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1DAA83BB5ED
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 05:07:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 805BF218E83;
	Thu,  8 May 2025 05:02:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="pHtgHv+w"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f172.google.com (mail-il1-f172.google.com [209.85.166.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E96FD217733
	for <kvm@vger.kernel.org>; Thu,  8 May 2025 05:02:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746680547; cv=none; b=K/0PQ/fvfII8mjSej4ectQLkx+lEYwCkL3i25/8p1cTc0o9m54a5iJGYZCul6TbgDGVND+vAqu3dMB5HynzmQlzqplukvZFOxk7MICfs+HLM8pNu7XNOgyMJZux0y3I0h1IucgnSkUxG0erbo5h5CbMax06NkONnG5UWMVHa7uk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746680547; c=relaxed/simple;
	bh=PBaYHCI3R5a14dKpofwQ0+w1aMgMX35JFi2xWoglqTw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QSE/EsChSoYyhkjuz7DjZwz9vrXvIra+mYgGuBZ9xbKm235yj7J7wFtqlSpvVOkbi7vVSwLaxq6tM+lrE+VappP2z0VG2mF4Bzst9ppNhPd+1qa56xD3EKwT7zB2dqDlP7h+ueTGpNanOoZsZ6/IZZOsK+DL2ZotYHCxwrwDje0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=pHtgHv+w; arc=none smtp.client-ip=209.85.166.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-il1-f172.google.com with SMTP id e9e14a558f8ab-3d8fc9dbce4so6571155ab.0
        for <kvm@vger.kernel.org>; Wed, 07 May 2025 22:02:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1746680544; x=1747285344; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o4O7+nQ6u5XMVEZ9olWj3Ht9QPAgJnl5lq5fX/yAqRY=;
        b=pHtgHv+wd9g1qYZKWnLIu7gkjzwY8BrrEU/Su6AYG9MwLpFhkYPnICAYp0T/Yho4F2
         Lqa5ySPKFP/ezcGBayW5sWxic/4D3Bu4PTs6kv0wLz+zo5yRWdQoWBCYMIoztQFkWCFK
         G+ZwHkJUmJ2JcJF7QqrjNwBLeQwMHYc16fNq2ncqwyesUc2F9awjpcfxsp8nsDK12kzm
         YgSwB02N7/OS1nkpJjqgW8AdyDQyVOgAUKvM1eJ4xBsbPKqhQduexXyQqrktMM5Yz0C/
         3OKfH1IORKGdlHpJOROM8i6MxRDX6Vd9gmKh9HAmM+R/NGqYWtOAvyVJdDJ+m50ZmVLd
         61fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746680544; x=1747285344;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=o4O7+nQ6u5XMVEZ9olWj3Ht9QPAgJnl5lq5fX/yAqRY=;
        b=noS7vLpeFt/sQaC5PjqG+JGE4MNzyU4rgFlVj9k4VQOwuXFVdG00zIfEgb/4I9AYmL
         VlIoUo+dSlLVAAuPwYy3CsxlVB7+EqyqHSxPU2IS8MDfD4MUzEGjQ2r1+7eR/IZwEo99
         /0jZNQ0Apq4QFOD8g+gBS2Bo+TnW5ljVKt0SgikhHUPeTHxkTJ8LjeYXMLTx5J2nXbwa
         S+MA5NmeEPTrZTXfFSPKHaBCt0njDwzbiU2wLgiXSBXOQAbKitsWR5Mw/Xw7JNPj+0JR
         AepGHGJKDtoHZnC00Tv3iEayZsU7gW29llo2zfYbnvUxVeHK6MjZ8qX1Ge/2gvJMX7/8
         3NoQ==
X-Forwarded-Encrypted: i=1; AJvYcCW9BbQHIxzZQUJODXcVF/woBjuIqew8fqBmxLb78hd1e1GZTo2z5nF6LoG0vPtmO9K27Jk=@vger.kernel.org
X-Gm-Message-State: AOJu0YwBP7v0e1/WuD7wjwtc5BhoBR6ocAr2kE3nokUZKRZF/YmLREvE
	CRJlWF1lmzN5tkxTesb7FDJhHxhvVb8t7RXnkIJbFmxHpBNpfSgRafyf2p2LnKXlLZO5aSrMdPC
	fFEYemYLYgMD5i4g76UU7LrHyZpZZE6hqC4aZrg==
X-Gm-Gg: ASbGncvXFprIeY+miJojQSYsTY8cIdMrzB2MoDPtFeEKc+8YiVUzY9SyMBS6fd0/7ys
	UMlrRsqd/ct7m8vnqgxJnFtLic3PjfLHN488UFOlAT6fHT7ly43iln0yrRMsJlgnnI6WvDohN99
	mQ5TbL+y1RxwnjEYpw9J8I
X-Google-Smtp-Source: AGHT+IECR9VWWp5sM9ekT0izdpJvnXGhLFrUYyeXvUgiyjcyi/z8ERS2MGNabEsCST5MXjtN+VKccxirLbFB93wPSAg=
X-Received: by 2002:a05:6e02:33a1:b0:3d2:af0b:6e2a with SMTP id
 e9e14a558f8ab-3da7854d904mr27339085ab.5.1746680543894; Wed, 07 May 2025
 22:02:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250403112522.1566629-3-rkrcmar@ventanamicro.com>
 <20250403112522.1566629-5-rkrcmar@ventanamicro.com> <CAAhSdy0v7Cw+aGF8DDWh1gjTBXA23=H01KRK8R2LTQHLRHo5Kw@mail.gmail.com>
 <D9Q3TKPXTPMO.39LSPFEO587XO@ventanamicro.com>
In-Reply-To: <D9Q3TKPXTPMO.39LSPFEO587XO@ventanamicro.com>
From: Anup Patel <anup@brainfault.org>
Date: Thu, 8 May 2025 10:32:13 +0530
X-Gm-Features: ATxdqUHAtn3fdoGp6jzvIyBGtoq6BWz_b3EO39aBJbq4imtAWzXWd7ChbJprOwA
Message-ID: <CAAhSdy0tb5Su_4ydBx1eSt6_1PPpgt1gE=nx53mwum=5DPzMRw@mail.gmail.com>
Subject: Re: [PATCH 2/5] KVM: RISC-V: refactor sbi reset request
To: =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@ventanamicro.com>
Cc: kvm-riscv@lists.infradead.org, kvm@vger.kernel.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Atish Patra <atishp@atishpatra.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Alexandre Ghiti <alex@ghiti.fr>, Andrew Jones <ajones@ventanamicro.com>, 
	Mayuresh Chitale <mchitale@ventanamicro.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 7, 2025 at 10:58=E2=80=AFPM Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcma=
r@ventanamicro.com> wrote:
>
> 2025-05-07T17:31:33+05:30, Anup Patel <anup@brainfault.org>:
> > On Thu, Apr 3, 2025 at 5:02=E2=80=AFPM Radim Kr=C4=8Dm=C3=A1=C5=99 <rkr=
cmar@ventanamicro.com> wrote:
> >> diff --git a/arch/riscv/include/asm/kvm_vcpu_sbi.h b/arch/riscv/includ=
e/asm/kvm_vcpu_sbi.h
> >> @@ -55,6 +55,8 @@ void kvm_riscv_vcpu_sbi_forward(struct kvm_vcpu *vcp=
u, struct kvm_run *run);
> >>  void kvm_riscv_vcpu_sbi_system_reset(struct kvm_vcpu *vcpu,
> >>                                      struct kvm_run *run,
> >>                                      u32 type, u64 flags);
> >> +void kvm_riscv_vcpu_sbi_request_reset(struct kvm_vcpu *vcpu,
> >> +                                      unsigned long pc, unsigned long=
 a1);
> >
> > Use tabs for alignment instead of spaces.
>
> Oops, I totally forgot that linux uses tabs even for alignment.
>
> > Otherwise, it looks good to me.
> > I have taken care of the above comment at the time
> > of merging this patch.
>
> Thanks, I'll post v2 without the three patches.

Base your v2 upon riscv_kvm_queue branch at
https://github.com/kvm-riscv/linux.git

Regards,
Anup

