Return-Path: <kvm+bounces-66984-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id A390FCF0F2C
	for <lists+kvm@lfdr.de>; Sun, 04 Jan 2026 13:47:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id BF96E30115CD
	for <lists+kvm@lfdr.de>; Sun,  4 Jan 2026 12:47:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 862542DECBF;
	Sun,  4 Jan 2026 12:47:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="iNeksPCz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ot1-f43.google.com (mail-ot1-f43.google.com [209.85.210.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26121283FD9
	for <kvm@vger.kernel.org>; Sun,  4 Jan 2026 12:47:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767530858; cv=none; b=WHOUvJgGjQN7zhpx4mtNl/mqLW7zFfNghYkQzPyxgWJcz8gHW/yxLRnO/leu3b5SH7XCQYmQabkqLVEGINS+LXsfgAbKjp+iRfR+q1syK7PEzptQNF7bLGXBMgQwNZNtaYWTSnmxm+1hOaSj0F4fCHrtWgp8ej1rE/KVSq+8b3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767530858; c=relaxed/simple;
	bh=AecSDfEUb7T3Zi5OBdjCKvuALwR//QsL0tPk1E3dN1w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hMPJFRijpavfkngoQeYu0J6chEbdSkFg27Li2aCpdDyQIYtnVFGF9DOJ1AA914+kAsvyIpw6DBbsw1aMxUYDHTDEbaToi+HUcyx+21H+AsYJtNp1ddLWZSJkW8Eq8qZgl98gCTwgd6mRh873Eii8uLJQa/B4UKOot5rONtRpasE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=iNeksPCz; arc=none smtp.client-ip=209.85.210.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-ot1-f43.google.com with SMTP id 46e09a7af769-7c76f65feb5so10135169a34.0
        for <kvm@vger.kernel.org>; Sun, 04 Jan 2026 04:47:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1767530856; x=1768135656; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UBR94AA+E+xBOJnVfHQAl63HlInJovxw9TDKKyfWGlQ=;
        b=iNeksPCzvzv/y6E8UDv9EIoY9lhRGEl5Q1LK+GeLEH6v96lesec0e0ujtcyKuTJ28r
         9JMvJFOEWRDJkx97/PfCIT/GxlMOgBRU+W/gLdfo0OCS9MiXLH5ErnTPJqp78euuUQgJ
         1BO4eAM5A+DfKZ5/PMU8GZEqBAwfDLc26GkGtEYPXOsqsfs73532HdOluhFsZDxCZVXu
         gD8XZTDXCnKQOshYlXJ7z2cUIJYeXT4YYMxdRHGXc4kOjUnnmFrmWmm+jgyP2Vk9QrVz
         +lVGuEzW0CX4CBe6D2yXHXBPX/mmC4erixWKvXqi0uWj8nSpmLOLyqK8igLxFuONDWH0
         XGXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767530856; x=1768135656;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=UBR94AA+E+xBOJnVfHQAl63HlInJovxw9TDKKyfWGlQ=;
        b=S2z2l+xCpwS9TTq8+rSwc47wJcSGtv6OmIWGczBn4zB95HYAmq7UgLvNHM6OgFL65F
         Y+nfNgJXDcZbqZZlrcEjxmLJGSZr9SMomWT9zVsPS9TZnvhHQ/vx8Q+Amld1iV5LGDiv
         CtWeocuuXhT9QeIFRTtQpMmY8nMFiBoiZDWYqRCiyMRtBwh0JxaK2xvHlMXJep7dByYa
         7HbXBIY1FpumnEmbEhCnQVi0Rc89WzT78sFj/rluk8k4Iwga40MVsIsVI+DWYWXXjhJM
         ZNsMI7MR19/TWv8sm78FHkw77+zXlzmnAA3TSZREvcfgjJLJhbcorBLmaFoLkwQATOFK
         towQ==
X-Forwarded-Encrypted: i=1; AJvYcCUJRrDevEm5TdgFyOhgeg6eT/FCd4xz/T7R4zwi0a49/3jvszj45EoaHa7ULMZRCaEQm2I=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw44c7Pp/f4Ad6vpoacKV6bnzqYs6v9Ac2kM0aLgjzZkPWgN1/e
	3QMUE4DcsHr5xvtW/z7N4qKGYcQUtsPeMIKZPYllgVDYWojbTfFyRe+7Us5f8TI8Ua8C+Clgnny
	MqkvrQFubr6MVRX/UONpHF0CzU7ReoMfFaCGvDl6L1Q==
X-Gm-Gg: AY/fxX63l6/OQZ9ElAlICjYwvt4Qwnhks8jzsJsWp4bBE1yiSWXhCuP1Abi6vh3/qkZ
	0AtmYuxg88CpWOO2mNsW5df43RzwZK7mImTymY4ZJ88ajSZzSRV8wdh53cki12QYdtF7CleLuwX
	I6wUssQmedq+rfHLAEBmBriAWpygCsx2AnVTaxgvi2ZErUsYBJvPrzsvbKX3vYX0c0jDDMFynzH
	AHgX4JdJwAWCyJt9A+jSkbuFByZNoTuqm/Vqc5V7Dd4eAXFAIENRGFWNQSPsxl0A/1ftuzEXk5o
	6Drzn88pqWdelLS+Ib+KqD0in8LyAs9pkXICy4pfwz6EdSjbtbcpSJNVuw==
X-Google-Smtp-Source: AGHT+IECPen7zcw66duYFJVMDMXNIgOGjSV9WYBIHgME1nUXUInP9aO+nmllavOhiMWoxzZo2zi2xGJh9M2MH0LN4iA=
X-Received: by 2002:a4a:ead6:0:b0:65d:163:3f3 with SMTP id 006d021491bc7-65d0eac5c3cmr17185222eaf.56.1767530855865;
 Sun, 04 Jan 2026 04:47:35 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251229072530.3075496-1-maqianga@uniontech.com>
In-Reply-To: <20251229072530.3075496-1-maqianga@uniontech.com>
From: Anup Patel <anup@brainfault.org>
Date: Sun, 4 Jan 2026 18:17:24 +0530
X-Gm-Features: AQt7F2oslKyeGGWLcGF1wus_STNTXspuscmibPNIQSPFMw_t6obj9SIrjq9AInM
Message-ID: <CAAhSdy25eSUF1w5cUzT0N0seYuLEVz66k89SQK=Qu+4gZKtURQ@mail.gmail.com>
Subject: Re: [PATCH] RISC-V: KVM: Remove unnecessary 'ret' assignments
To: Qiang Ma <maqianga@uniontech.com>
Cc: pjw@kernel.org, palmer@dabbelt.com, aou@eecs.berkeley.edu, 
	atish.patra@linux.dev, alex@ghiti.fr, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 29, 2025 at 12:56=E2=80=AFPM Qiang Ma <maqianga@uniontech.com> =
wrote:
>
> If the program can execute up to this point, indicating that
> kvm_vcpu_write_guest() returns 0, and the actual value of
> SBI_SUCCESS is also 0. At this time, ret does not need to be
> assigned a value of 0.
>
> Fixes: e309fd113b9f ("RISC-V: KVM: Implement get event info function")
>
> Signed-off-by: Qiang Ma <maqianga@uniontech.com>

Simplified commit description and queued it for Linux-6.19 fixes.

Reviewed-by: Anup Patel <anup@brainfault.org>

Thanks,
Anup

> ---
>  arch/riscv/kvm/vcpu_pmu.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
>
> diff --git a/arch/riscv/kvm/vcpu_pmu.c b/arch/riscv/kvm/vcpu_pmu.c
> index a2fae70ee174..4d8d5e9aa53d 100644
> --- a/arch/riscv/kvm/vcpu_pmu.c
> +++ b/arch/riscv/kvm/vcpu_pmu.c
> @@ -494,12 +494,9 @@ int kvm_riscv_vcpu_pmu_event_info(struct kvm_vcpu *v=
cpu, unsigned long saddr_low
>         }
>
>         ret =3D kvm_vcpu_write_guest(vcpu, shmem, einfo, shmem_size);
> -       if (ret) {
> +       if (ret)
>                 ret =3D SBI_ERR_INVALID_ADDRESS;
> -               goto free_mem;
> -       }
>
> -       ret =3D 0;
>  free_mem:
>         kfree(einfo);
>  out:
> --
> 2.20.1
>

