Return-Path: <kvm+bounces-57106-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C0F8B4FC17
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 15:09:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2EDB717A41D
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 13:09:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63F3333EB1F;
	Tue,  9 Sep 2025 13:09:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="KMjCUR2h"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f173.google.com (mail-il1-f173.google.com [209.85.166.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13DC928643C
	for <kvm@vger.kernel.org>; Tue,  9 Sep 2025 13:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757423380; cv=none; b=Trq6L2zQ1zxlV0MhLFgU2VTWuemhWg5Dqf8O8m7R7zfyx/NfqKtZMskxBnufyOJJYTnQGesVMA5yAmngqhk8PAxGoKf0X7ltEa28NiHLReljqbhhDTwu/+Ul3enuRCh5pCtn5gyHXRGcr99Gva+HXiXpne8uYtJCfqdd4k5gr6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757423380; c=relaxed/simple;
	bh=FnSWFJ1pbHXDKqOlAEXuCuVJQvXmVpKWv/TnXXH9psY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=H7IvlTiSnceDToL9EB9i879qB2iLT6L7z/+bsELB0PjCKw1K7asvAyB/obYmDObUuLAI/O9z9HkaSIRbLp0jz+cZPOz02xLt2faALqPIO6ZGFTSy7OJ08rsW5GKdlg6AtwCIjGeZ9LyFRYEmHdFGM4nbQd3wC/6QlxtQHSJCasM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=KMjCUR2h; arc=none smtp.client-ip=209.85.166.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-il1-f173.google.com with SMTP id e9e14a558f8ab-4135366c152so2010505ab.0
        for <kvm@vger.kernel.org>; Tue, 09 Sep 2025 06:09:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1757423378; x=1758028178; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Et6v9MZbTk1pFS1bUNfiOVICylxCPX59YZSHQ0yE1r8=;
        b=KMjCUR2hJ+x0DshN2kN+Y+s86POdZomKT+KU/HEFIoqnNQduk9520ZHqw8ROWr/MN+
         R8NJO8hQ/fexh3GJv0iHzzVxNl/hbkKhi8XLq6i7u/hq0qdIoeVkhHANSPQw78+DE3JX
         azoo6PLfre+trB5Ig0nJt54qU2LfZblKkwq8tdgrjRZ96YW8Bl+PrPZQfmWw+xd2YfBX
         UTfOdG/2UoLrTxN58G/zzsaxwHfC0RCM4O5P8ysa7kLan61R5687TQneTPOmGjh+5X8Y
         J/769M/il7cioBsfjUGnvQFwGvWr5jus9vxgn6reh4FENfHhN4MW/p+oU7CHrh4rUYql
         xFpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757423378; x=1758028178;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Et6v9MZbTk1pFS1bUNfiOVICylxCPX59YZSHQ0yE1r8=;
        b=s0MEm571tmOValOqdkSMMah0b5FCc7xx69SzQqrhBkp69+/YfFWbEr4VU3XB7lBXKq
         c4XrO1gz6yyQqqqjNsfof+rc/rxIShTqyd/AmBaoZeXZCui5IqW1MieLB/kVyv04+LR7
         CbhS5O/2MgtZ8XugRbADZ+mh/3SUvwjLxxgHDK+uHHKzRojU8iWmLalmA8v8l7KhI446
         Mx8XSyoUSrmmBcZANhgtsxOb0J1+Zza0KNFYJxNxGozvt/0gBtbG64rfJ3tqqdeX2Ygc
         3kSebZL0bPR3yttdFc0xnCM5OD4tKgc9WIk3IctYAg3AcgNTp9YAzPO704YuLAlHR1jd
         qV1Q==
X-Forwarded-Encrypted: i=1; AJvYcCWPSefhtv7/b46CMKapC0PzKxdM3cUU7yNXe6zaGeKJXAV1dcj6uGZCkHgVOhXzRhOxm8w=@vger.kernel.org
X-Gm-Message-State: AOJu0YxS6ZgkLGpg2xxMaYCgZ6ACYNcyHs8X7NrYCtkJg10DBzwA4E+n
	s7ChlsbHjImYYwUqGcXgfKq3/OzLvvktkxcX/c2I0XZv32+WWNT28UGUzJ8RDM5OGq3kTU51MT2
	QFltQaSibyK3+WGPqASD4ENFx3AROPHjgEdJCZ3UVjw==
X-Gm-Gg: ASbGncvTXRjKOu0EuOMwng7maFLUqL+7kfAbvXhXv0HO0N+L4ZV3ianGPjlyT6OrUUa
	FkmS3GP6zyhtsVC73NKfhbhqs3jv2URB3TkSKQLIyvc5GEBQx/OPiKufid7MaI82/RcOD7BtRZs
	XETGSxA6O8MXQrDIZ0PlfKkGbKcy81O+n2PizHVEM/yGzA5XZH+r9NKLSsTfTHs7S/IBxhcfiOT
	rFm6+96W5Zkgu2LKuh5tmRYax6HE1d1JAApUFUs+xIeoXUiGpw=
X-Google-Smtp-Source: AGHT+IFiVfiLe6MDTgLYfQVJM+7bIAvkNGpPq9pKFcNmWNcz88mlHx0Ry1czmNGFbXc2GRPs/CcX2si0gv35Hm7838E=
X-Received: by 2002:a92:ca0a:0:b0:3f6:5e42:9ec3 with SMTP id
 e9e14a558f8ab-3fd8e3d3a50mr168551415ab.11.1757423377758; Tue, 09 Sep 2025
 06:09:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250909-pmu_event_info-v6-0-d8f80cacb884@rivosinc.com> <20250909-pmu_event_info-v6-6-d8f80cacb884@rivosinc.com>
In-Reply-To: <20250909-pmu_event_info-v6-6-d8f80cacb884@rivosinc.com>
From: Anup Patel <anup@brainfault.org>
Date: Tue, 9 Sep 2025 18:39:26 +0530
X-Gm-Features: Ac12FXwwmRiHCZkeiCDOhDongtd-pqDmF7dqaj5xnX2k1zEPMqCjDokehycy2ss
Message-ID: <CAAhSdy3d31yEBM3rpy4N3jmL0PovU_VSYuo7niGduuqknXdmGQ@mail.gmail.com>
Subject: Re: [PATCH v6 6/8] RISC-V: KVM: No need of explicit writable slot check
To: Atish Patra <atishp@rivosinc.com>
Cc: Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Mayuresh Chitale <mchitale@ventanamicro.com>, linux-riscv@lists.infradead.org, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 9, 2025 at 12:33=E2=80=AFPM Atish Patra <atishp@rivosinc.com> w=
rote:
>
> There is not much value in checking if a memslot is writable explicitly
> before a write as it may change underneath after the check. Rather, retur=
n
> invalid address error when write_guest fails as it checks if the slot
> is writable anyways.
>
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Atish Patra <atishp@rivosinc.com>

LGTM.

Reviewed-by: Anup Patel <anup@brainfault.org>

Regards,
Anup

> ---
>  arch/riscv/kvm/vcpu_pmu.c     | 11 ++---------
>  arch/riscv/kvm/vcpu_sbi_sta.c |  9 ++-------
>  2 files changed, 4 insertions(+), 16 deletions(-)
>
> diff --git a/arch/riscv/kvm/vcpu_pmu.c b/arch/riscv/kvm/vcpu_pmu.c
> index 15d71a7b75ba..f8514086bd6b 100644
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
> @@ -432,19 +430,14 @@ int kvm_riscv_vcpu_pmu_snapshot_set_shmem(struct kv=
m_vcpu *vcpu, unsigned long s
>                 goto out;
>         }
>
> -       hva =3D kvm_vcpu_gfn_to_hva_prot(vcpu, saddr >> PAGE_SHIFT, &writ=
able);
> -       if (kvm_is_error_hva(hva) || !writable) {
> -               sbiret =3D SBI_ERR_INVALID_ADDRESS;
> -               goto out;
> -       }
> -
>         kvpmu->sdata =3D kzalloc(snapshot_area_size, GFP_ATOMIC);
>         if (!kvpmu->sdata)
>                 return -ENOMEM;
>
> +       /* No need to check writable slot explicitly as kvm_vcpu_write_gu=
est does it internally */
>         if (kvm_vcpu_write_guest(vcpu, saddr, kvpmu->sdata, snapshot_area=
_size)) {
>                 kfree(kvpmu->sdata);
> -               sbiret =3D SBI_ERR_FAILURE;
> +               sbiret =3D SBI_ERR_INVALID_ADDRESS;
>                 goto out;
>         }
>
> diff --git a/arch/riscv/kvm/vcpu_sbi_sta.c b/arch/riscv/kvm/vcpu_sbi_sta.=
c
> index cc6cb7c8f0e4..caaa28460ca4 100644
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
> @@ -111,13 +109,10 @@ static int kvm_sbi_sta_steal_time_set_shmem(struct =
kvm_vcpu *vcpu)
>                         return SBI_ERR_INVALID_ADDRESS;
>         }
>
> -       hva =3D kvm_vcpu_gfn_to_hva_prot(vcpu, shmem >> PAGE_SHIFT, &writ=
able);
> -       if (kvm_is_error_hva(hva) || !writable)
> -               return SBI_ERR_INVALID_ADDRESS;
> -
> +       /* No need to check writable slot explicitly as kvm_vcpu_write_gu=
est does it internally */
>         ret =3D kvm_vcpu_write_guest(vcpu, shmem, &zero_sta, sizeof(zero_=
sta));
>         if (ret)
> -               return SBI_ERR_FAILURE;
> +               return SBI_ERR_INVALID_ADDRESS;
>
>         vcpu->arch.sta.shmem =3D shmem;
>         vcpu->arch.sta.last_steal =3D current->sched_info.run_delay;
>
> --
> 2.43.0
>

