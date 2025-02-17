Return-Path: <kvm+bounces-38360-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2AEE2A3804E
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2025 11:36:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F1E21164880
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2025 10:36:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CFF631A5B8C;
	Mon, 17 Feb 2025 10:36:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="deL/tFec"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f52.google.com (mail-io1-f52.google.com [209.85.166.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 572F71917D7
	for <kvm@vger.kernel.org>; Mon, 17 Feb 2025 10:36:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739788599; cv=none; b=muYDMHl80n2PCBhXGTDImuYjrH7F4fhVhgU0t9+xVsG51E75NDdwKUxRR48Ba01J1HAQAlsBAgAzZAgrRE+TNFmF17nfjrQukiHIq0aFy835eaWAX+mE8n2oHUQ0Ij86JnBcxngVi/CkZi2EZQRfBfg/jV1wAFP/7sIVbSYabs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739788599; c=relaxed/simple;
	bh=ZhfaGtlvZqWXgNva+NYSmoolTHk2KiOLJE52OgXB5sk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=M7Pbd95CBRLEXoA8gLXKUn/c5KVbUbpfO+HE5R5poo5tD5R6RcnaaZnvj/5kaVPKhrMIklk/9gc8fnLbFVNRlG+2X7i8/f791+wjbsyXjvMptD1r3iA0Tag8xjzX6Vv3+7PX3PXE29YVhTJZMcHEXnYpY7x84WXSIuz8KS+X3/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=deL/tFec; arc=none smtp.client-ip=209.85.166.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-io1-f52.google.com with SMTP id ca18e2360f4ac-84a012f7232so149761539f.0
        for <kvm@vger.kernel.org>; Mon, 17 Feb 2025 02:36:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1739788597; x=1740393397; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JXuIrr0uZbsvb+1H4q1P/dQZuaUoc6czcr9gRmWyKlc=;
        b=deL/tFecVDEJIZlrLLq+rhcpwOytGywXaqtUqVDvnQDkyYC1esodHmiQhidBa/ZtDi
         J92UEou9+8wUhLII+DwEmg4/OcBv1PVKcqRTweYR/9QsO9pOdT7Hb6TojB9KXn/KdiP1
         q8dwCykjA9ZJ3isZ/RpXgSQSyc1IHpRVx4AneqWp6f85dGLQKYV96X9mEeGpofTJJ1Ax
         YbvAFyZo/t4WQOy4SZlZ66EgtHCa7Ory1jB81OEw3IDi546Nj/QSM7Xz7HGE5wavH+xO
         L6CYa99MmIDLljxqKzvOu1krkDXqDrPoXF9neebdNZ93TKtKjI+hVjy7Ean18AMUIOTt
         o8iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739788597; x=1740393397;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JXuIrr0uZbsvb+1H4q1P/dQZuaUoc6czcr9gRmWyKlc=;
        b=i2g5cOxpG7JYaB9DvHHLSoxBBzX3Zbuv2xl6Ktl5YD8/POI4B7aujuONpqjrgKsrUT
         Sq0StylLuLWlyDZFAd3/gMG5J5bcjr0U1OLxzcimChJfSxcDRM4jR0SFHfiR/GMPl3yd
         wXcpn8BpVQwswzWYTpXcbbNaJszR8v6KJBVmgxsYycfJc5hcwKODLYsq679z+Nj+PnEO
         Fjkq9CFwhRX4GjefLxlC0XD8ECSEGa4bCoSGs8JR0pr1buo3d/iqkqLlAEU5KfoZQ7Uh
         Y1yMH9aLCXe1e5pQjPf/DVbCz1sZnparg5aUU7vqmDbA1oqwcbWxZgmZF4zTb2GKsd7v
         8hPw==
X-Gm-Message-State: AOJu0Yy1sNZrf2gXkbMsleQeLBs75RPCA1bMLl7vG5eBKEaNBACYBBD+
	JerDolt/K+tkD4k1L3Svz+PZLONw4bc50g8KxDl/bB9su5sZVgZy6f92u+TF/6QYoqUjIqygb2v
	K+rjEUfsYi26etItadVjH8r2b+4480A01pLpoww==
X-Gm-Gg: ASbGncvM/gTaIFNx4e6iB3DaheNKyoS6lNb7AcyVeNETHurvh7LdSLRgPWZ3CN4Mgaj
	pWA0YxZJBE02d9BVKYJP8pKhJFDMCyvSv9JzQpl19bHpkny8OrvKge0kMXqkwYofhftYkds084w
	==
X-Google-Smtp-Source: AGHT+IEw269iT/y4krWNO0LRo2RLfVtDkGsMXcWgAorAmpNUQzvjAfq/Q6R4P+Rr0miTce5VQs94e89cnvKhqhjf5ic=
X-Received: by 2002:a05:6e02:184d:b0:3cf:b2ca:39b7 with SMTP id
 e9e14a558f8ab-3d281e294f4mr66755685ab.3.1739788597288; Mon, 17 Feb 2025
 02:36:37 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250217084506.18763-7-ajones@ventanamicro.com> <20250217084506.18763-8-ajones@ventanamicro.com>
In-Reply-To: <20250217084506.18763-8-ajones@ventanamicro.com>
From: Anup Patel <anup@brainfault.org>
Date: Mon, 17 Feb 2025 16:06:26 +0530
X-Gm-Features: AWEUYZkeJbANn3o67oIBgEtVLiGAHW5hziZFAcMUSpUUnQ4RfYuy1apwMnNIRW0
Message-ID: <CAAhSdy14rpAPQcv0nuhZ6DRhABa38cBq3oB7y28X6Fe8_adCbw@mail.gmail.com>
Subject: Re: [PATCH 1/5] riscv: KVM: Fix hart suspend status check
To: Andrew Jones <ajones@ventanamicro.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	atishp@atishpatra.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, cleger@rivosinc.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 17, 2025 at 2:15=E2=80=AFPM Andrew Jones <ajones@ventanamicro.c=
om> wrote:
>
> "Not stopped" means started or suspended so we need to check for
> a single state in order to have a chance to check for each state.
> Also, we need to use target_vcpu when checking for the suspend
> state.
>
> Fixes: 763c8bed8c05 ("RISC-V: KVM: Implement SBI HSM suspend call")
> Signed-off-by: Andrew Jones <ajones@ventanamicro.com>

LGTM.

Reviewed-by: Anup Patel <anup@brainfault.org>

Regards,
Anup

> ---
>  arch/riscv/kvm/vcpu_sbi_hsm.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/arch/riscv/kvm/vcpu_sbi_hsm.c b/arch/riscv/kvm/vcpu_sbi_hsm.=
c
> index dce667f4b6ab..13a35eb77e8e 100644
> --- a/arch/riscv/kvm/vcpu_sbi_hsm.c
> +++ b/arch/riscv/kvm/vcpu_sbi_hsm.c
> @@ -79,12 +79,12 @@ static int kvm_sbi_hsm_vcpu_get_status(struct kvm_vcp=
u *vcpu)
>         target_vcpu =3D kvm_get_vcpu_by_id(vcpu->kvm, target_vcpuid);
>         if (!target_vcpu)
>                 return SBI_ERR_INVALID_PARAM;
> -       if (!kvm_riscv_vcpu_stopped(target_vcpu))
> -               return SBI_HSM_STATE_STARTED;
> -       else if (vcpu->stat.generic.blocking)
> +       if (kvm_riscv_vcpu_stopped(target_vcpu))
> +               return SBI_HSM_STATE_STOPPED;
> +       else if (target_vcpu->stat.generic.blocking)
>                 return SBI_HSM_STATE_SUSPENDED;
>         else
> -               return SBI_HSM_STATE_STOPPED;
> +               return SBI_HSM_STATE_STARTED;
>  }
>
>  static int kvm_sbi_ext_hsm_handler(struct kvm_vcpu *vcpu, struct kvm_run=
 *run,
> --
> 2.48.1
>

