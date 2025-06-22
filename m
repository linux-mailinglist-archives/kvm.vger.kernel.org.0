Return-Path: <kvm+bounces-50256-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B836BAE2F4D
	for <lists+kvm@lfdr.de>; Sun, 22 Jun 2025 12:12:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CD3913ACBCD
	for <lists+kvm@lfdr.de>; Sun, 22 Jun 2025 10:11:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E46431D5142;
	Sun, 22 Jun 2025 10:12:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="T+ig0bEd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C3521B0402
	for <kvm@vger.kernel.org>; Sun, 22 Jun 2025 10:12:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750587123; cv=none; b=AJf1smYJzCpQckE7jIuQwGKmvqD1Kjgr0SfCk0snY+NSihh0Juew5I2tDAtZD9lFY6QZJg+RSRQSVKUIgXqMUFHlNj5aq4mQS909FZsTKwI+ncwf6cAaPOLvHIRRWfTJP5GDFV/i2E+0+or7xLD9NghcacTv49hrUMbwJZPEn1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750587123; c=relaxed/simple;
	bh=U8KbW8H1OPS3k6Kxz+b5VWjIpb6jrU+NjTsn2OmpZ9Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qlTfQAa/euyaY/F9a7cCHcex3sB0klsAID8Ls1Ojk+9U8EXekdkFxU/NQwxyBZNR+LJmCkZafj0CcjjAyyt/DZUSSjWNCnoWOICdBAG65FKqc4WpZKiLmAgL+prSoY6A9xsiFFfI8TlwAu2zo026IUqooQNV2LHz+qFQv0YGtUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=T+ig0bEd; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2360ff7ac1bso21896965ad.3
        for <kvm@vger.kernel.org>; Sun, 22 Jun 2025 03:12:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1750587120; x=1751191920; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mhd7Psksfo9MLj/RnU9tn25T95OkdzIn/rvFvguRfxI=;
        b=T+ig0bEdY6Tbzg3DaGYcQetGJ5zfsIj/anjO7ZoM8Yb/tLb1+C3Hc8IniRmxK1uxBT
         A3f4YU5G/mu3E+Fc7dFurgHCqyWAM8QRck9Y+IapCLeujyHqu4O8y3CLDRW8tEIxV6Im
         2ra6xdqDICnJxcnnQGezEVLWZPEJuXQIIamlmt60wtnxOLXuSaUmw6PbquZHY2OtMpnr
         svFXa6r5OkWcTZQTZQa80ZzwXKuyn8BSarOeDDyCx3erXGMzAGYuXSXgU+ew/O96E4GH
         BjtTWOAAdHF7dN/0ZmIMLhvGAfiKVgLsOZBCwcT6iEuFQ51RzQGGXt0TJfzWvaCumcAo
         MGYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750587120; x=1751191920;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mhd7Psksfo9MLj/RnU9tn25T95OkdzIn/rvFvguRfxI=;
        b=iG2YomoSFb043cRmcjzDZbdjvV3bLoWb85S95eOX7b/QagLzOUN8Xh3UrS/aN3i0Mn
         Efi1rjKzkyxpUkjwGGnydI4HlV7uoMyqCSUf61YudvpD492o3TUiVJpvIUxyZvpcxUsY
         uWlF9amvCj9apEhbmofFvuclECWSRYT1N02ruOAYYcurpBKEwYOjfB5e9XpwzqlTw4Di
         Wnc4syRWebWqRBcUtueX3LS+czXH6jyRYzpbUtK9iG+MKADxxTz7RnVv076k4M032cjQ
         ubRmosrQswaLhu5TNLoco+v99eZdP9YDM6YwWlnFuvgeKsACUxREp7AdY/Fid3sDf2lE
         jjCg==
X-Forwarded-Encrypted: i=1; AJvYcCU0bD4vWrmmy8Kld6A0e2PF8rcVax11XbFWmJ/w9RgdEkRu0YG4dLga95XgPI7OuVv6zQA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw7cCjqZ0BgAcwsqTZslk/pvolJsFKqEo3x7XEQAMEUt1pXFNMa
	a2Aq1GfserLnKgtGEcrNGH1GqFG+asXtoj2PH7QfA18rvNLPqydDYanMZqVTx8D0WVsBQTPlZvq
	wJRvF4Yw+W4CNsDgrpJ0SuBKTq0ZRmCBhVkewR3yhJw==
X-Gm-Gg: ASbGncuh010dlzZmEK1ZclDczJA3x057rBMwIkkDiGCmXzN1Ilfy3GuFEmbYeBXrzFo
	davd4YEUXnCOPYkcXC6+SbzR5jhw+wUV4+oY7j5eSCj1ZTYuVBJ42Kffme41XJWlTvnvMa33NWU
	Gg8ORLhJEuUKzsHJRxvr5aVWuUrDtBlm0p9oJKXyaYnd0Hz/vSD5elC1lN
X-Google-Smtp-Source: AGHT+IGsWzTP6/gbvQ/CA0ejRIYXVE3ACO/w0NVroX/xY0eGzRwP6PYHlp4erxCJ+zZG6ZfDl+/adXC35SQaJWcaE8g=
X-Received: by 2002:a17:902:c405:b0:235:e8da:8d6 with SMTP id
 d9443c01a7336-237d97c3b5bmr151787145ad.2.1750587120557; Sun, 22 Jun 2025
 03:12:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250620091720.85633-1-luxu.kernel@bytedance.com> <DARCHDIZG7IP.2VTEVNMVX8R1E@ventanamicro.com>
In-Reply-To: <DARCHDIZG7IP.2VTEVNMVX8R1E@ventanamicro.com>
From: Xu Lu <luxu.kernel@bytedance.com>
Date: Sun, 22 Jun 2025 18:11:49 +0800
X-Gm-Features: AX0GCFsb818yKyl7dINvhKYBkJJnEFckaB0ZfIHP1lNH7P09XFDmloWPadWx7s8
Message-ID: <CAPYmKFvcnDJWXAUEX8oY6seQrgwKiZjDqrJ_R2rJ4kWq7RQUSg@mail.gmail.com>
Subject: Re: [External] Re: [PATCH] RISC-V: KVM: Delegate illegal instruction fault
To: =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@ventanamicro.com>
Cc: anup@brainfault.org, atish.patra@linux.dev, paul.walmsley@sifive.com, 
	palmer@dabbelt.com, aou@eecs.berkeley.edu, alex@ghiti.fr, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, 
	linux-riscv <linux-riscv-bounces@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Radim,

On Fri, Jun 20, 2025 at 8:04=E2=80=AFPM Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcma=
r@ventanamicro.com> wrote:
>
> 2025-06-20T17:17:20+08:00, Xu Lu <luxu.kernel@bytedance.com>:
> > Delegate illegal instruction fault to VS mode in default to avoid such
> > exceptions being trapped to HS and redirected back to VS.
> >
> > Signed-off-by: Xu Lu <luxu.kernel@bytedance.com>
> > ---
> > diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm=
/kvm_host.h
> > @@ -48,6 +48,7 @@
> > +                                      BIT(EXC_INST_ILLEGAL)    | \
>
> You should also remove the dead code in kvm_riscv_vcpu_exit.

I only want to delegate it by default. And KVM may still want to
delegate different exceptions for different VMs like what it does for
EXC_BREAKPOINT. So maybe it is better to reserve these codes?

>
> And why not delegate the others as well?
> (EXC_LOAD_MISALIGNED, EXC_STORE_MISALIGNED, EXC_LOAD_ACCESS,
>  EXC_STORE_ACCESS, and EXC_INST_ACCESS.)

Thanks for the reminder. I will have a test and resend the patch if it work=
s.

>
> Thanks.

Best Regards,
Xu Lu

