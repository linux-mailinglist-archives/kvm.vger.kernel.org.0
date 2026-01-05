Return-Path: <kvm+bounces-67032-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 2AF47CF2B5D
	for <lists+kvm@lfdr.de>; Mon, 05 Jan 2026 10:23:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 56A00301918C
	for <lists+kvm@lfdr.de>; Mon,  5 Jan 2026 09:17:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBC13335564;
	Mon,  5 Jan 2026 09:06:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="mcs1xwLw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-f45.google.com (mail-oo1-f45.google.com [209.85.161.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3F0933291C
	for <kvm@vger.kernel.org>; Mon,  5 Jan 2026 09:06:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767603996; cv=none; b=TAK7Lqne8sKnHnqPhkQ5CJ0aposFrAOs/qnCkhLii/bhtxygEFygOLV5erfw9WXrtz9kvdUUAYh+mMo5jRwewGGnhA05rGvKmAf3l2rmAQ+KLxU0+gm+keK3mhX9K1Z+vrtjGDUGLp9FhW+pwSszjm2VP3VlScN/Ku6YLZ2RUcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767603996; c=relaxed/simple;
	bh=MLxZuPSMtRL816eTodfHWi9P1buz0/azYjgJOrc0bYY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SXkU9ElADVIonkaKDD1g2TqsWybYCgu2WivEBUM+IPH2N0dR7hKBrkTXPVNgYsRt8WsBMKwXgCEC1XgzoxJ1R7eWn5U1flvohZ0DA5g4jnGCVLWIIoIjFxmRlvVLd3VyTuE36cE4j4d3rvd16hg8lgPXJFsmq8SmrzbYUFNvBXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=mcs1xwLw; arc=none smtp.client-ip=209.85.161.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-oo1-f45.google.com with SMTP id 006d021491bc7-65cf050a5cdso888091eaf.1
        for <kvm@vger.kernel.org>; Mon, 05 Jan 2026 01:06:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1767603982; x=1768208782; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rx0r6U43GKweZQq7AZ8Mrd0bllWyzHYWweaavwJCSZc=;
        b=mcs1xwLwhsIyjQKWusMeSRxxBCfEfEKeH1GSy7vdEfmI3S+TLkluEZA/5AWeiY7mJB
         ob/xJH1Gc2zqulIBljXRl/6RVJ2Q+b1ZXUx/t6Hcrzs6Uf970Hj8y6O5op3742Tu/qC0
         w0suuMcVDL3vztkZv5ZY+tlxiIR5EqHGTEGwiX7e3oQFVWxSYCpJqI2a7ym/dgE44Iyh
         ZwN7/pBp3O3+TT9TZ5hVoodyzVYC9erSguz4o2ThxkwWJ//ReRqGAWX7odYILmUYDo+l
         ipHtQDBVicszpBZfYdUDnQp5EPOE6Ux52iioAnz5z8HZXegXtk68/pBy3uvPNC3BHTf1
         Wc+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767603982; x=1768208782;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rx0r6U43GKweZQq7AZ8Mrd0bllWyzHYWweaavwJCSZc=;
        b=GUgJvdCemueYAeSVi9W6lCb2CDr0sywwmlFCu4fa0cnwpVbXQNPQUfOs2Oo29kwG5b
         4+CxFgSGwFjqow43Xvby+PoDJisVKhcRC9Z3JdSqnxYmiLMBnNi1w0M50LAfKnTkHYns
         1qYo9aNwu0x80F15UhuBF92qC6RivMa7qD04e0ePk/yXto1GDnxjxcbt4hJTE0keHcj3
         i5UkwPZFKCBPufqusOBYNhtuGL4h2CWS2WUcj2Xk9FxrzcPS0f3jgHKmlgoFk+EQwhdD
         OQ5kVDAn6SJ4ZijJfVqPqHWqdWvRvL2mErgPcKacWyIygwjoJaWJkrUoIJvT1zXb6hvi
         nRKg==
X-Forwarded-Encrypted: i=1; AJvYcCUIzvzh7bQ8zukrwetIUEztAKiA3LsDq87htGd1IxSY8fP5gpcvC/uvBl20CAFrivqtyQE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyx4aSMXfaDaeAX9YPLYjPB7n2Wf8ZssVHBqrqPXNHM2CVB7jW+
	lvRjUk9+w04VFFiMCl5SPzW5YM066UT32hDn04gOH89bEDWptWHdpz0kTRSnHhP7nT5QF5eDVgS
	/yUxphvwkDCA/92mhA5nsY+WfHGI8V3VJUM/6UWA5RQ==
X-Gm-Gg: AY/fxX7SH8GozofzCoTqZLBp5eAKx/ZGmnVMCDDt5EghXIdhXmddAY0EiOkmKpdjjRm
	Ls1bo/OIhMXY7ea1QqU4UJj29Wdt8UnbToJOd3XrZc9O3rm6A/6wmU8tYu1xht9Ifg69c9ed2xs
	oZr+dCXI6w+q62ngThOrwIWyogVuo0namjcjzTH4iT1PYQ4w+PauD6K2WGvGqyAxJLYuOgUw7NX
	xbmEu2hU0zozeyz1OYpJMqSLjCYZ8f9DPZZdM6GnXhtjpIPsHv/jvHQXDULz2THtq1Ew7D/j3UN
	v2HFZtMB/1ls/x1WrQgQ46WYzb6bc3cyB2SAdfOoqkrn/E3YmqPouO4rSw==
X-Google-Smtp-Source: AGHT+IEmhIQ5RKOo2b6b7OL5O1/QlwNjLPOmq/Ngn48EMDTkEYgit3hHMFtHAFIg6wOswhZTAnGu6/YK4U65b6YmqR4=
X-Received: by 2002:a05:6820:a245:b0:65b:295f:ee08 with SMTP id
 006d021491bc7-65f2684a98emr2359335eaf.10.1767603982348; Mon, 05 Jan 2026
 01:06:22 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250826162939.1494021-1-pincheng.plct@isrc.iscas.ac.cn> <20250826162939.1494021-6-pincheng.plct@isrc.iscas.ac.cn>
In-Reply-To: <20250826162939.1494021-6-pincheng.plct@isrc.iscas.ac.cn>
From: Anup Patel <anup@brainfault.org>
Date: Mon, 5 Jan 2026 14:36:11 +0530
X-Gm-Features: AQt7F2o7aUCslFOKh9Z8QzWPpfr1ehdXhDGDtgLd_0uBy1pmifoh4VGOHYQoZdM
Message-ID: <CAAhSdy3OXBexhB_csqJasQoQJ8QnsE=q7dHXgWtyig28eJGL3g@mail.gmail.com>
Subject: Re: [PATCH v2 5/5] KVM: riscv: selftests: add Zilsd and Zclsd
 extension to get-reg-list test
To: Pincheng Wang <pincheng.plct@isrc.iscas.ac.cn>
Cc: paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu, 
	alex@ghiti.fr, robh@kernel.org, krzk+dt@kernel.org, conor+dt@kernel.org, 
	pbonzini@redhat.com, shuah@kernel.org, cyan.yang@sifive.com, 
	cleger@rivosinc.com, charlie@rivosinc.com, cuiyunhui@bytedance.com, 
	samuel.holland@sifive.com, namcao@linutronix.de, jesse@rivosinc.com, 
	inochiama@gmail.com, yongxuan.wang@sifive.com, ajones@ventanamicro.com, 
	parri.andrea@gmail.com, mikisabate@gmail.com, yikming2222@gmail.com, 
	thomas.weissschuh@linutronix.de, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	devicetree@vger.kernel.org, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 26, 2025 at 10:00=E2=80=AFPM Pincheng Wang
<pincheng.plct@isrc.iscas.ac.cn> wrote:
>
> The KVM RISC-V allows Zilsd and Zclsd extensions for Guest/VM so add
> this extension to get-reg-list test.
>
> Signed-off-by: Pincheng Wang <pincheng.plct@isrc.iscas.ac.cn>
> ---
>  tools/testing/selftests/kvm/riscv/get-reg-list.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/tools/testing/selftests/kvm/riscv/get-reg-list.c b/tools/tes=
ting/selftests/kvm/riscv/get-reg-list.c
> index a0b7dabb5040..477bd386265f 100644
> --- a/tools/testing/selftests/kvm/riscv/get-reg-list.c
> +++ b/tools/testing/selftests/kvm/riscv/get-reg-list.c
> @@ -78,7 +78,9 @@ bool filter_reg(__u64 reg)
>         case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV=
_ISA_EXT_ZCB:
>         case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV=
_ISA_EXT_ZCD:
>         case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV=
_ISA_EXT_ZCF:
> +       case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV=
_ISA_EXT_ZCLSD:
>         case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV=
_ISA_EXT_ZCMOP:
> +       case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV=
_ISA_EXT_ZILSD:

KVM_RISCV_ISA_EXT_ZILSD case must be inserted in alphabetical order.

>         case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV=
_ISA_EXT_ZFA:
>         case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV=
_ISA_EXT_ZFH:
>         case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV=
_ISA_EXT_ZFHMIN:
> @@ -530,7 +532,9 @@ static const char *isa_ext_single_id_to_str(__u64 reg=
_off)
>                 KVM_ISA_EXT_ARR(ZCB),
>                 KVM_ISA_EXT_ARR(ZCD),
>                 KVM_ISA_EXT_ARR(ZCF),
> +               KVM_ISA_EXT_ARR(ZCLSD),
>                 KVM_ISA_EXT_ARR(ZCMOP),
> +               KVM_ISA_EXT_ARR(ZILSD),
>                 KVM_ISA_EXT_ARR(ZFA),
>                 KVM_ISA_EXT_ARR(ZFH),
>                 KVM_ISA_EXT_ARR(ZFHMIN),

KVM_ISA_EXT_ARR(ZILSD) must be inserted in alphabetical order.

> @@ -1199,7 +1203,9 @@ struct vcpu_reg_list *vcpu_configs[] =3D {
>         &config_zcb,
>         &config_zcd,
>         &config_zcf,
> +       &config_zclsd,
>         &config_zcmop,
> +       &config_zclsd,

Both config_zclsd and config_zclsd must be defined before
vcpu_configs[] using KVM_ISA_EXT_SIMPLE_CONFIG().

Also, config_zilsd is not added in alphabetical order.

>         &config_zfa,
>         &config_zfh,
>         &config_zfhmin,
> --
> 2.39.5
>

I have taken care of the above comments at the time of merging.

Reviewed-by: Anup Patel <anup@brainfault.org>

Queued this patch for Linux-6.20

Thanks,
Anup

