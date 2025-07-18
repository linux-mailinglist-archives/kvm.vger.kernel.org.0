Return-Path: <kvm+bounces-52849-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B5C0B09A98
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 06:40:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 523B8A60360
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 04:40:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 079D91DC997;
	Fri, 18 Jul 2025 04:40:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="V5TS1EEM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f178.google.com (mail-il1-f178.google.com [209.85.166.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAB0F17A2FC
	for <kvm@vger.kernel.org>; Fri, 18 Jul 2025 04:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752813650; cv=none; b=m9CiZ7P4FJu4phTBI3ln7/tFuP0FTkh7DLt27Cto455Q4q7pnzJC/d4s3kOEJDL2XbZxVT8B1g0Y9JgOLcCdGEnzcc2NWZXnDJR2vlk8NlWK+XlleNLIn94yKd19izGWucrP/UJu/FyvwCfq7bVueTCrTUYhOJFwGwvJQab4xT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752813650; c=relaxed/simple;
	bh=5zM8DCe1lBw38qNyO5y7XCt1O6HiCZVd2nvimi22HCI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BrpXxa0r70k6K4nPdGcYraWWg/hOhczTSTnKiJrL445/GZVs67J7AeCZ+3K7tYnQp09gpvLDgB59H0v7h1qNXh4wHS3tr7rXyqg6KRUnbxruB4LCvIiwJ9wyvSlrvegGe0dZXWFWiuJNJUR+dAEOgh8GbQQfU38qO+DCJp/5jAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=V5TS1EEM; arc=none smtp.client-ip=209.85.166.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-il1-f178.google.com with SMTP id e9e14a558f8ab-3df2f937370so7147745ab.3
        for <kvm@vger.kernel.org>; Thu, 17 Jul 2025 21:40:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1752813648; x=1753418448; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Nk5P6Goql09+zLhT4UFf1bxLMW3kkptTgrc0lcznfeI=;
        b=V5TS1EEM/jU7RSBbsMAkyD86s/zQ0sOKa7y5DI1iuIImuP9IQHvemz4INiIDaSaAgX
         nPpazDTNOJV4M4ZV6vtqg/WvgjrafqQf0l91HRiJe0cDbT/dmPSFXd1D5vRhoiGIjYVH
         tSOInHw/SZMEQADakdBqlNjWd9PddGgd+QykckAK4aiR/cGYVbCrUbfMd0wvW1GWdHgu
         1szaVBrJ9RCQo3AWrSlPMtjyMfiWRmUZIL9j96jkzii6W4AVr1QcOZTT0RTUf+3Ydzv9
         L12zXe2xUEeVZBApqjch9XF4neiK4WjiPTI+zKdFWQaNLkSGVF12F1v66QlXawFoJi9D
         kYmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752813648; x=1753418448;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Nk5P6Goql09+zLhT4UFf1bxLMW3kkptTgrc0lcznfeI=;
        b=rpo3yXAwBHarPiKMPp1wTbDwCIyY8pYVtx9IAI2y1XWpKDK71Leo89ia8F4GHQrt4A
         nCgnXfrHARBN0mJfq+SCUFS2gFQB5kioK16vi+DK3V/lHsYUJzvSl7ABubXvXGELmDSK
         sf9Aiifm7/qP+lZw3WHKuNg3FvzI5vfDMAPZUWq5deHPurv+TvUalQBHQpGfAhqM2NKS
         mLyD6oxT5Y1Cstls0EVI+8+AJn7mvXINYlxbzi54hiD75fpPozK/H6ZftGlktkmhn370
         gmannSYoA8uj+6iM7RTbd/N8+LRRqQ74iA+FcOwqWx6PZ1euy9v3vC01SHmbHTFt3hbt
         deRA==
X-Forwarded-Encrypted: i=1; AJvYcCWc+T/I2V2MwUPA8tURrx6u4AHDIOaPH1uJrE2Trl6Uwzu6zCHOLLCkN/EiEiBKy1d9plg=@vger.kernel.org
X-Gm-Message-State: AOJu0YxPqK2AwhQs4IMj6SaciztC+BtXJaAKArojv+MjpADqjj86OoaX
	nrOZKtl//32PGTmFZxVwH+TsR2u5D1jnqoP1VDzXadx9Y1AXS3TmGMClNUDZkdiZCCGUyows7eX
	g/jdoVp6/C/qUOau5tXnY6Bo7ASURayqcrJpiw983vw==
X-Gm-Gg: ASbGncuXwGObHr53reM8yIDqEAQJ1pIonleCihp1DtEgj3A1lMv3gMpigxuIfC2q6Lk
	p1djSIgLI563TveaTFcxvFJH+5DIWdpJ5MWW6GF2F6o2E2A4Zu8igFV9pqMRnx3UGQaWw8d91kJ
	vIF/ZTbg4e8r0uOMB1Ggp5yJzg1A5TMQWDiP7uQo9MX3Jo13Ji3EWV8TnM+8c85XjIv9dE3kpnV
	JudrPEp
X-Google-Smtp-Source: AGHT+IEaxS0XjYOehQPTaQpINVNdrhTY0WgdZfr1X928tkogrZyS3xluTJGJB4k36Lrfe/UfgaiC4ceggmbdl7StqFo=
X-Received: by 2002:a05:6e02:440e:10b0:3e2:91bb:c075 with SMTP id
 e9e14a558f8ab-3e291bbc1c1mr30213165ab.22.1752813647913; Thu, 17 Jul 2025
 21:40:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250522-pmu_event_info-v3-0-f7bba7fd9cfe@rivosinc.com> <20250522-pmu_event_info-v3-7-f7bba7fd9cfe@rivosinc.com>
In-Reply-To: <20250522-pmu_event_info-v3-7-f7bba7fd9cfe@rivosinc.com>
From: Anup Patel <anup@brainfault.org>
Date: Fri, 18 Jul 2025 10:10:36 +0530
X-Gm-Features: Ac12FXxfH_kRUff1qKzc565myWI6pwy0mWoGInqqgjbhV1vA028RQkFxaIa9Vtg
Message-ID: <CAAhSdy08d8DJL_kurFwHSTEm3i+0wv=Nfd0xP+kKR=6rFdm27w@mail.gmail.com>
Subject: Re: [PATCH v3 7/9] RISC-V: KVM: Use the new gpa range validate helper function
To: Atish Patra <atishp@rivosinc.com>
Cc: Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Mayuresh Chitale <mchitale@ventanamicro.com>, linux-riscv@lists.infradead.org, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Palmer Dabbelt <palmer@rivosinc.com>, kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 23, 2025 at 12:33=E2=80=AFAM Atish Patra <atishp@rivosinc.com> =
wrote:
>
> Remove the duplicate code and use the new helper function to validate
> the shared memory gpa address.
>
> Signed-off-by: Atish Patra <atishp@rivosinc.com>

LGTM.

Reviewed-by: Anup Patel <anup@brainfault.org>

Regards,
Anup

> ---
>  arch/riscv/kvm/vcpu_pmu.c     | 5 +----
>  arch/riscv/kvm/vcpu_sbi_sta.c | 6 ++----
>  2 files changed, 3 insertions(+), 8 deletions(-)
>
> diff --git a/arch/riscv/kvm/vcpu_pmu.c b/arch/riscv/kvm/vcpu_pmu.c
> index 15d71a7b75ba..163bd4403fd0 100644
> --- a/arch/riscv/kvm/vcpu_pmu.c
> +++ b/arch/riscv/kvm/vcpu_pmu.c
> @@ -409,8 +409,6 @@ int kvm_riscv_vcpu_pmu_snapshot_set_shmem(struct kvm_=
vcpu *vcpu, unsigned long s
>         int snapshot_area_size =3D sizeof(struct riscv_pmu_snapshot_data)=
;
>         int sbiret =3D 0;
>         gpa_t saddr;
> -       unsigned long hva;
> -       bool writable;
>
>         if (!kvpmu || flags) {
>                 sbiret =3D SBI_ERR_INVALID_PARAM;
> @@ -432,8 +430,7 @@ int kvm_riscv_vcpu_pmu_snapshot_set_shmem(struct kvm_=
vcpu *vcpu, unsigned long s
>                 goto out;
>         }
>
> -       hva =3D kvm_vcpu_gfn_to_hva_prot(vcpu, saddr >> PAGE_SHIFT, &writ=
able);
> -       if (kvm_is_error_hva(hva) || !writable) {
> +       if (kvm_vcpu_validate_gpa_range(vcpu, saddr, PAGE_SIZE, true)) {
>                 sbiret =3D SBI_ERR_INVALID_ADDRESS;
>                 goto out;
>         }
> diff --git a/arch/riscv/kvm/vcpu_sbi_sta.c b/arch/riscv/kvm/vcpu_sbi_sta.=
c
> index 5f35427114c1..67dfb613df6a 100644
> --- a/arch/riscv/kvm/vcpu_sbi_sta.c
> +++ b/arch/riscv/kvm/vcpu_sbi_sta.c
> @@ -85,8 +85,6 @@ static int kvm_sbi_sta_steal_time_set_shmem(struct kvm_=
vcpu *vcpu)
>         unsigned long shmem_phys_hi =3D cp->a1;
>         u32 flags =3D cp->a2;
>         struct sbi_sta_struct zero_sta =3D {0};
> -       unsigned long hva;
> -       bool writable;
>         gpa_t shmem;
>         int ret;
>
> @@ -111,8 +109,8 @@ static int kvm_sbi_sta_steal_time_set_shmem(struct kv=
m_vcpu *vcpu)
>                         return SBI_ERR_INVALID_ADDRESS;
>         }
>
> -       hva =3D kvm_vcpu_gfn_to_hva_prot(vcpu, shmem >> PAGE_SHIFT, &writ=
able);
> -       if (kvm_is_error_hva(hva) || !writable)
> +       /* The spec requires the shmem to be 64-byte aligned. */
> +       if (kvm_vcpu_validate_gpa_range(vcpu, shmem, 64, true))
>                 return SBI_ERR_INVALID_ADDRESS;
>
>         ret =3D kvm_vcpu_write_guest(vcpu, shmem, &zero_sta, sizeof(zero_=
sta));
>
> --
> 2.43.0
>

