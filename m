Return-Path: <kvm+bounces-5335-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C99788203F4
	for <lists+kvm@lfdr.de>; Sat, 30 Dec 2023 09:00:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3373F2822DF
	for <lists+kvm@lfdr.de>; Sat, 30 Dec 2023 08:00:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9AEFA79C2;
	Sat, 30 Dec 2023 08:00:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="flLaUQ+i"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f50.google.com (mail-io1-f50.google.com [209.85.166.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABC377487
	for <kvm@vger.kernel.org>; Sat, 30 Dec 2023 08:00:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-io1-f50.google.com with SMTP id ca18e2360f4ac-7baa8097064so274543539f.3
        for <kvm@vger.kernel.org>; Sat, 30 Dec 2023 00:00:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1703923228; x=1704528028; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CsK9GSl9KoT/t/1u9XM1rWvytVRiMpi1HhinaJeAPjc=;
        b=flLaUQ+indYQpCSzUm8CKHN0+pXpLX74NWmqVUrbAD/ddiGQGa4YkxZ2A9g0/GkTc+
         3lqhgomG0h+I7KhQtAwZDcDrkEkUNIXCJ87ghZR85iPs4jGqYmiNV1EBtDVAPlaeBld3
         ZkS0jTKWb5i3QYAPnk/AUoX1FiQs4BhFDtA0e1pbiAwiMyDqZFT60VvRg3sp0VYJmENX
         smI85CKUyWbHyi7Z4t1Hj0DuVrJkg83EusnkL+qOFnDybYuC8WXYVXsJCNtSkg8ZrhVV
         YUNGY0bgCsp43kZeZ1hGYzBGTIGae0d/Z+vn15U2ZOXyWeTda/cX2No16HzN3FuWB2xU
         hQmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703923228; x=1704528028;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CsK9GSl9KoT/t/1u9XM1rWvytVRiMpi1HhinaJeAPjc=;
        b=Syiic1p9O4L1NH4kwfoDYMufzr9F3qV7QJk/aW0pcghnvBnF/28NRrUrwBa/PNQ9sU
         YpQ2dseHjwiMf/I339zvl6Kd/rNIQ6FMFxW+pX4buLXJKoQMxQ43gb8VpT69VEispxY2
         CYSC5Lb/RT2d2D3aXCvKrQi7hyYS41geBzSedfJlqvotNBeSBxG9sHS/4Ecum4YVXDcV
         IYBMimOS6HniVkxgrsSSj9f4djcA8CFqISJwkfWCXfJvAFIhXPc/C3UZifv8SoF3hhkj
         0olefL5jLrZBj2LPubAfngyWJiX0dkhVEYL/dRQs8ht9qOwT16lFH46DC1GksBASPGwf
         z2og==
X-Gm-Message-State: AOJu0YwM27ERNpHXK9MIoJZuI894afE5DTpjwc0cwT4168AJ8b3L+xpu
	Tqb87YbJEkK4Gs26zHr0fGnNBDThmvy+cWWES2p2Cd52+OzkSA==
X-Google-Smtp-Source: AGHT+IGu2cUegqoSzVonPWO03edgnNv/GRIV30A6bBS7SKvohHEYUnxkoxharU9wnyCuzq/VdjOsac56Up2x+iMOOJU=
X-Received: by 2002:a92:cda6:0:b0:35f:f007:e904 with SMTP id
 g6-20020a92cda6000000b0035ff007e904mr11167470ild.50.1703923227751; Sat, 30
 Dec 2023 00:00:27 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231229214950.4061381-1-atishp@rivosinc.com> <20231229214950.4061381-7-atishp@rivosinc.com>
In-Reply-To: <20231229214950.4061381-7-atishp@rivosinc.com>
From: Anup Patel <anup@brainfault.org>
Date: Sat, 30 Dec 2023 13:30:17 +0530
Message-ID: <CAAhSdy2sce_joq3g230npQ5mHOL48bekzS2ChTsvtT=wGZVCvw@mail.gmail.com>
Subject: Re: [v2 06/10] RISC-V: KVM: No need to update the counter value
 during reset
To: Atish Patra <atishp@rivosinc.com>
Cc: linux-kernel@vger.kernel.org, Albert Ou <aou@eecs.berkeley.edu>, 
	Alexandre Ghiti <alexghiti@rivosinc.com>, Andrew Jones <ajones@ventanamicro.com>, 
	Atish Patra <atishp@atishpatra.org>, Conor Dooley <conor.dooley@microchip.com>, 
	Guo Ren <guoren@kernel.org>, Heiko Stuebner <heiko@sntech.de>, kvm-riscv@lists.infradead.org, 
	kvm@vger.kernel.org, linux-riscv@lists.infradead.org, 
	Mark Rutland <mark.rutland@arm.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Will Deacon <will@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Dec 30, 2023 at 3:20=E2=80=AFAM Atish Patra <atishp@rivosinc.com> w=
rote:
>
> The virtual counter value is updated during pmu_ctr_read. There is no nee=
d
> to update it in reset case. Otherwise, it will be counted twice which is
> incorrect.
>
> Fixes: 0cb74b65d2e5 ("RISC-V: KVM: Implement perf support without samplin=
g")
> Signed-off-by: Atish Patra <atishp@rivosinc.com>

LGTM.

Reviewed-by: Anup Patel <anup@brainfault.org>

Regards,
Anup

> ---
>  arch/riscv/kvm/vcpu_pmu.c | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)
>
> diff --git a/arch/riscv/kvm/vcpu_pmu.c b/arch/riscv/kvm/vcpu_pmu.c
> index 86391a5061dd..8c44f26e754d 100644
> --- a/arch/riscv/kvm/vcpu_pmu.c
> +++ b/arch/riscv/kvm/vcpu_pmu.c
> @@ -432,12 +432,9 @@ int kvm_riscv_vcpu_pmu_ctr_stop(struct kvm_vcpu *vcp=
u, unsigned long ctr_base,
>                                 sbiret =3D SBI_ERR_ALREADY_STOPPED;
>                         }
>
> -                       if (flags & SBI_PMU_STOP_FLAG_RESET) {
> -                               /* Relase the counter if this is a reset =
request */
> -                               pmc->counter_val +=3D perf_event_read_val=
ue(pmc->perf_event,
> -                                                                        =
 &enabled, &running);
> +                       if (flags & SBI_PMU_STOP_FLAG_RESET)
> +                               /* Release the counter if this is a reset=
 request */
>                                 kvm_pmu_release_perf_event(pmc);
> -                       }
>                 } else {
>                         sbiret =3D SBI_ERR_INVALID_PARAM;
>                 }
> --
> 2.34.1
>

