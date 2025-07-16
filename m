Return-Path: <kvm+bounces-52567-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C9375B06D1B
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 07:20:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ABF343B5774
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 05:20:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABF192797BE;
	Wed, 16 Jul 2025 05:20:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="ZQwB5Pdq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f175.google.com (mail-il1-f175.google.com [209.85.166.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBB6A215F6B
	for <kvm@vger.kernel.org>; Wed, 16 Jul 2025 05:20:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752643219; cv=none; b=V9L/Okdy+0Cn2aMA9Zyxtkd2wBvTnFDVepLVDbyJSBZ5khYaYEsswqvBfJMAIt+T66whmuedWcQSeA5qKDjLX5MXSRGdadJI1VaYvNuDemE77G1oRiBMLm7ocU0ep+uy6fGpbz1O6wbfw8cZ091BFA9/IHH0LaG8sePmLg9U+SY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752643219; c=relaxed/simple;
	bh=/ktSjyUZX0dfbAs7P4VFPYdLWMzAPv8W3aDVhnylNsQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RD3ddi7CF+LsPFilORNxMOdI6p8z1dd5OBmofFR4dStrv/Qr86zYUkE0jeIxJxZzFSR6y/6RHxM5DJGeoCh32nV6zQovjUKYYYVQg5YWtFFPdxSp94tAgIqHRO2vgXDVogglwAnhLyKJsVPTlKQQDUiyJPnsMA/1OYAVBToEoRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=ZQwB5Pdq; arc=none smtp.client-ip=209.85.166.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-il1-f175.google.com with SMTP id e9e14a558f8ab-3e28058c18cso7575105ab.0
        for <kvm@vger.kernel.org>; Tue, 15 Jul 2025 22:20:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1752643217; x=1753248017; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7pr0CgkuBDoCBojEhq3SOwjdkjudDtqxy7ZuiK0Se4o=;
        b=ZQwB5Pdq4vJHgFysY0APTd6kt8YEFn2dLjZfKMCPeKy+wAJx/6s+ka87efhvbXn02D
         0Pp1BlNjf2dgR9i892l7XI20jExfW0bqj+wMqkJwsLZF1Ku9h2wTNEbi2TfA4PGc1ulh
         nFED4houCN2fi5B90m0wnt+q8ufPMWOC2hWZ+Px8MKdG7qh+StYJYcb8AaScVTo6hly1
         JZRSlirkouBPh6fwY9O5xX859cO/4DkVTTmcxwzDgMuXpS4WR4szvN1833symUG9OSdm
         kIpVAzuq3lRjz8oQezaOmVnJg2sb+/QJFL4DHyaURlJsjQbWestJeXEAghbgvWnbyAag
         IIFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752643217; x=1753248017;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7pr0CgkuBDoCBojEhq3SOwjdkjudDtqxy7ZuiK0Se4o=;
        b=xJzjFlBRZq5DPTv3ht9GI+OqmZcLfsqeT/zd2aWaC++BWhPnPMMti49IEV/VEkIbwa
         f3a6Y6Da8gD67Btbq8llIZHJadKFGye1VV466FqrRwaaElw0qawb/a7B3b2QLUU6NX8t
         /IDvNEpL9xavoufY9rsdoz+TCBvpVfmbzbRdRWACv1SQk6vA3qdL4jVYUidBZvyo7+Ts
         8TJZmWHoSOjtfZNVSGlS21ztOKANVXCnMsCJc4xoe1kyCJhYOj6n4ojF0EeM/qO2Os0H
         ZhUaxSGMUyInV0dAXs00G20yajQh4ZuAnNLQA2ewfvqN7GOZdNqXIkMsteE3O8F14Osk
         AiEA==
X-Forwarded-Encrypted: i=1; AJvYcCXfZnHK8Mgq9n7GbUzxcd+VzsQN37Qcdk42q9lFam1gGYJE6jcLPMeb7D0pl/8AYS+vK8g=@vger.kernel.org
X-Gm-Message-State: AOJu0YwMqB4RN87HC/vAeCpL981Rou7JaRkAI8DLIJf5KIsquKRhtE9l
	BAKJMKOPw1cROdrvGLjfauzi1opHmepzWLWZVWi7VlEx3o1qkHvjEfwZ6KDCUW0NkTEBHDeqWQ/
	zrT98RrkhSHr0sb2FDSeXXEwFRLO835HtdVurx76Kmg==
X-Gm-Gg: ASbGnctfL+5Fs4Xw7OaishWKxgSpfshTuls4Zt3xj1aJjsiJXWYfVPLgids4Kfc2oDL
	IL+YDgt3hhjp3xJReiVM0zhHWj8P+g/IQ8d2n8mibXQR2iIDo/RQXBJ7cDiHcEx45tO88MoKS7k
	iraJFXIueVFh5rmZ/01XUwaZk11Kdale4yaUWudcnQ+ZgefTy4ALxSV9NGlhBfV1u53Fki2gB6O
	oqKZW+jUfkhh3Nn
X-Google-Smtp-Source: AGHT+IG8QMvIrF4Nh6TtjPYY/OImrdrVsXWR40Aodp+LssWG0nbwGxcm5vyJpoaN8ajvyQHU4KVCDRQEYdjX4PMmHto=
X-Received: by 2002:a05:6e02:1c07:b0:3df:29c5:2972 with SMTP id
 e9e14a558f8ab-3e282da9cd2mr14405455ab.9.1752643216752; Tue, 15 Jul 2025
 22:20:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250714094554.89151-1-luxu.kernel@bytedance.com>
In-Reply-To: <20250714094554.89151-1-luxu.kernel@bytedance.com>
From: Anup Patel <anup@brainfault.org>
Date: Wed, 16 Jul 2025 10:50:05 +0530
X-Gm-Features: Ac12FXys72h69btMJ897A7pa9H69kTczP7dldA--hcTTkswEbCjKDSzqpxxAxFs
Message-ID: <CAAhSdy2XEyphi5K1xk29JXY991aie0LA5YF2zRbgA_8imSjXQQ@mail.gmail.com>
Subject: Re: [PATCH v4] RISC-V: KVM: Delegate illegal instruction fault to VS mode
To: Xu Lu <luxu.kernel@bytedance.com>
Cc: rkrcmar@ventanamicro.com, cleger@rivosinc.com, atish.patra@linux.dev, 
	paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu, 
	alex@ghiti.fr, kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 14, 2025 at 3:16=E2=80=AFPM Xu Lu <luxu.kernel@bytedance.com> w=
rote:
>
> Delegate illegal instruction fault to VS mode by default to avoid such
> exceptions being trapped to HS and redirected back to VS.
>
> The delegation of illegal instruction fault is particularly important
> to guest applications that use vector instructions frequently. In such
> cases, an illegal instruction fault will be raised when guest user thread
> uses vector instruction the first time and then guest kernel will enable
> user thread to execute following vector instructions.
>
> The fw pmu event counter remains undeleted so that guest can still query
> illegal instruction events via sbi call. Guest will only see zero count
> on illegal instruction faults and know 'firmware' has delegated it.
>
> Signed-off-by: Xu Lu <luxu.kernel@bytedance.com>

LGTM.

Reviewed-by: Anup Patel <anup@brainfault.org>

Queued this patch for Linux-6.17

Thanks,
Anup

> ---
>  arch/riscv/include/asm/kvm_host.h | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/k=
vm_host.h
> index 85cfebc32e4cf..3f6b9270f366a 100644
> --- a/arch/riscv/include/asm/kvm_host.h
> +++ b/arch/riscv/include/asm/kvm_host.h
> @@ -44,6 +44,7 @@
>  #define KVM_REQ_STEAL_UPDATE           KVM_ARCH_REQ(6)
>
>  #define KVM_HEDELEG_DEFAULT            (BIT(EXC_INST_MISALIGNED) | \
> +                                        BIT(EXC_INST_ILLEGAL)     | \
>                                          BIT(EXC_BREAKPOINT)      | \
>                                          BIT(EXC_SYSCALL)         | \
>                                          BIT(EXC_INST_PAGE_FAULT) | \
> --
> 2.20.1
>

