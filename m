Return-Path: <kvm+bounces-4475-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D033D812FE0
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 13:16:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D78661C218D0
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 12:16:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51F6E41771;
	Thu, 14 Dec 2023 12:16:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="PNL+oBMm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BCA911A
	for <kvm@vger.kernel.org>; Thu, 14 Dec 2023 04:16:29 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id d9443c01a7336-1d3536cd414so14948655ad.2
        for <kvm@vger.kernel.org>; Thu, 14 Dec 2023 04:16:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1702556189; x=1703160989; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2tiT7wfNqaw2vJLSE5DYIhR3c6v+dX+na4nc8HEVIgQ=;
        b=PNL+oBMmA4ybqQboMcw6INWYK/fcxPF0zMNCA8vSPOyZuOEEbPqUskBN+6QjVPdmfA
         dBLac9j5SRDcIfvBJxtN7/A4pTYdAzulqVtgiS8TOVLehRDRS+ZdvUYU6z5hB9kdWm1W
         pxfxZpfLHT7cKR2sD8dlLnOLwovGg5HDZNcCCaiPaF3HcePlD+FKvz641wghA4EPoL3w
         97n8lb/AvOYXoJ+5tGQBEdCWKINSHZjuz/xv+ZypR9fDidFX7K5zbNwiVH7guwMPovBn
         xXKC07k0jTDbuABa97QJATQtdo7CyW9VRr755E0HWB5OQPib8M7OcWgELZjY8ordvwoe
         Yxgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702556189; x=1703160989;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2tiT7wfNqaw2vJLSE5DYIhR3c6v+dX+na4nc8HEVIgQ=;
        b=fXU3gWM7gjGSfGH5eYCgUoWCIDXdBDkvoraXmAd8WLBdpA8I+WU3fMZq/q4O4VZV+i
         /7qqzDznSQ+kk5AvHvcKZ7WfLcyoMP9pK9OJ7z6w3w9sIKvH+/3szBbg9gf7B64/wdwG
         JHsXTus1QTWfWjjFCKxY+y8XDnbNau3xGmQ9AXbvBRRu5B8AEa1J4x0RC4wK15N/X0c4
         hEVOMO50PbkwcXcqNH6t5xOrkTBHzOlTpOXj8DjIwyyEcpa5vCMkdSh96t+LRL9mZAjb
         UEr+dKfBtiXV2Vha6NeZx9nCPYWDqD6j8toILRgjAH3dfaErWihW35Kk9oTK9eilHHPF
         zxvw==
X-Gm-Message-State: AOJu0YyrUpNe45sfeddIujIis3NHq5OABJBVZpDNvKI22cQT3E7Mtfo3
	00ykaq/5HfKc8ew0plqJim3jZCdQnYFkhORKBu81iw==
X-Google-Smtp-Source: AGHT+IEthyLwcbpFlS0nGuCTagq11nyWQP0JyD3gThdiIWZOLD3HKt6owX5IozE98AMNclf4HsOdhasFFYWjQPb1jH0=
X-Received: by 2002:a17:903:2351:b0:1d3:60f7:4620 with SMTP id
 c17-20020a170903235100b001d360f74620mr1427318plh.128.1702556188931; Thu, 14
 Dec 2023 04:16:28 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231205024310.1593100-1-atishp@rivosinc.com> <20231205024310.1593100-4-atishp@rivosinc.com>
In-Reply-To: <20231205024310.1593100-4-atishp@rivosinc.com>
From: Anup Patel <anup@brainfault.org>
Date: Thu, 14 Dec 2023 17:46:17 +0530
Message-ID: <CAAhSdy0_DdCeFdzzJgoWhnrMz1-UqQXKLWNBAAXB6SQ_eJ2gyg@mail.gmail.com>
Subject: Re: [RFC 3/9] RISC-V: Add FIRMWARE_READ_HI definition
To: Atish Patra <atishp@rivosinc.com>
Cc: linux-kernel@vger.kernel.org, Alexandre Ghiti <alexghiti@rivosinc.com>, 
	Andrew Jones <ajones@ventanamicro.com>, Atish Patra <atishp@atishpatra.org>, 
	Conor Dooley <conor.dooley@microchip.com>, Guo Ren <guoren@kernel.org>, 
	Icenowy Zheng <uwu@icenowy.me>, kvm-riscv@lists.infradead.org, kvm@vger.kernel.org, 
	linux-riscv@lists.infradead.org, Mark Rutland <mark.rutland@arm.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Will Deacon <will@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 5, 2023 at 8:13=E2=80=AFAM Atish Patra <atishp@rivosinc.com> wr=
ote:
>
> SBI v2.0 added another function to SBI PMU extension to read
> the upper bits of a counter with width larger than XLEN.
>
> Add the definition for that function.
>
> Signed-off-by: Atish Patra <atishp@rivosinc.com>

LGTM.

Reviewed-by: Anup Patel <anup@brainfault.org>

Regards,
Anup

> ---
>  arch/riscv/include/asm/sbi.h | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/arch/riscv/include/asm/sbi.h b/arch/riscv/include/asm/sbi.h
> index 0892f4421bc4..f3eeca79a02d 100644
> --- a/arch/riscv/include/asm/sbi.h
> +++ b/arch/riscv/include/asm/sbi.h
> @@ -121,6 +121,7 @@ enum sbi_ext_pmu_fid {
>         SBI_EXT_PMU_COUNTER_START,
>         SBI_EXT_PMU_COUNTER_STOP,
>         SBI_EXT_PMU_COUNTER_FW_READ,
> +       SBI_EXT_PMU_COUNTER_FW_READ_HI,
>  };
>
>  union sbi_pmu_ctr_info {
> --
> 2.34.1
>

