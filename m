Return-Path: <kvm+bounces-52853-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3451AB09AFE
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 07:44:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5C4C8588028
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 05:44:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D15381E8837;
	Fri, 18 Jul 2025 05:44:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="OzZnqVp6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f54.google.com (mail-io1-f54.google.com [209.85.166.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 812F51A8F97
	for <kvm@vger.kernel.org>; Fri, 18 Jul 2025 05:44:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752817478; cv=none; b=rfJW+lqFQc754obIoyOEd9zyOn+j3OYohsIshPOw5oERLfGN+QpNrDb8a5GAVdlylbcxEjPmZWKEEUIF73WDE7EAMBdiNR2tb9dwp+2t3T/emsQ+apXJIrsXmFi74QpAA1JF6QxUvD4Y3w645PTWDum4phCfC0mf+EiLtYZN9RU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752817478; c=relaxed/simple;
	bh=uOfllG7doj7a1aHdRHQDBCELugIwaJECvLRp7gS+K1U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=B3yrlSiScqMQ69T7dYfErIXf3qpDOQz8oMdtuNgUnEWvDNBz2Kz1BT7tbTH45EVEwYRD8HtemQ5Co32tBwgA5/Xv4Aw18ap2yvEC4XPVIm6SlD5192Bt2m7vzuLUVN+1tj/v/vveEpp4veCZ6gF5sKOw6N1QnB32LYoU4NB/1kk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=OzZnqVp6; arc=none smtp.client-ip=209.85.166.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-io1-f54.google.com with SMTP id ca18e2360f4ac-876231b81d5so123213939f.2
        for <kvm@vger.kernel.org>; Thu, 17 Jul 2025 22:44:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1752817473; x=1753422273; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UbgPp2KhOfq0y4Sok/APrDX9m8Fb2lQ6Dd/Lb1wol6E=;
        b=OzZnqVp6gjnorGvETkBollneFqqWmu1MSW5+CNV8NhutJSgPq0pY7p8CcxzWzK/aO1
         H6ZCI1pz1NwsFLnTelx4tJq0OE4aIqyZNztWsl6mW2kPoLVWCY1SmZDsXtMk8aTFb0tH
         YO6h8XOAFs6gNc0GzGPORadOGtzS3XotODbEhSztYn9vwBGZt6TunbK43ehP6xHFXllK
         /UbrWmlL2eLSpf3yXpKFor0piZn5j2gDZcEEhC1pTXEvf4f5t10yN1KpwXBIpl+6e/Rk
         JTW/k1mnh4qTVoLajqZrEBUqW17bxZzf4qNaX5zlLBRYIDcgUG9zNlEnmsZ41AFhcfRO
         Ueqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752817473; x=1753422273;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UbgPp2KhOfq0y4Sok/APrDX9m8Fb2lQ6Dd/Lb1wol6E=;
        b=gOupK2vc6WlWthcz6zpt1YalCC35ywrCHsFt6q68MVZ/QJI/ltKnYqS68CevQ+/w/r
         W19jGm++U5m00bFpIuBlHAl9pFKedDOyoEx7aviUIoCv8JjfZ0tDbd6W77pISUyPS5JK
         CfK+FBeWroX7ynRVIoC0U8V5agSIBUgF35FhZVJT8NgdsPsOJ6Nqd1FgPCZ3zQMjZwsC
         RjmZ1iRDzouoWzJ8jTTgb1DYpjHFLlsHdejoi4fZRs0/w0s2aS/K4+mEqyxIXZx3lR8a
         39Kpk7v8KVuTY1WDt7BbkoTTAKf9fVruuuDQUtA+llTZS9obINm5kmAd787zTkftQYNO
         IfeQ==
X-Forwarded-Encrypted: i=1; AJvYcCW7zJUbj/ni27lQ1zX8PMDXbZkMWNEU3QN4kpBmmCa6meHEbnZdPUBXnIXtvpMbHsMsKnM=@vger.kernel.org
X-Gm-Message-State: AOJu0YzeFXmbc937JXONZrVEmVMvzbteNC63ERK8vkcmunjYoRWwYjeb
	DcwnmRU3wifA8Xqbx0ON185rlekZlmu5zagJ9ZvMU7Y5ngO+VsZ5/6KA6EEzQeHAbcEeq1pxBup
	F/0ZSjViw3NODEb9o/nZPaEyHuxIBAKEkgEvwZoZHcQ==
X-Gm-Gg: ASbGncty1QGepphI4Jhtv+eC1200fmLiizuV+D8F1lY5uOEMu8cvfsoqM4VWZk2W8ij
	NY1rQJ59XuwiiKjwz1DmVNIPyB1oBtB3O9wL92AKe4QkUWHv8znfP7ryhLRBmIJOOgFuzltlP/v
	xDzLk+VKlLtlq/eS+WOFAYZv9hw50tJzUE/4KTwuZ4et69ZcQCZkhEkrr6wzfT58l5AoTODP48X
	VUCT0dJ
X-Google-Smtp-Source: AGHT+IHDgWzcXCwj/DOJpP3ymIG8gmYK7y1xVWQRaZZ4+bN0CjPQTQhbKC7oNlsGD5d5wHcvIALI0L6dBMD+3efHuLc=
X-Received: by 2002:a05:6602:140e:b0:86a:256e:12df with SMTP id
 ca18e2360f4ac-879c08918d9mr1244420739f.2.1752817473316; Thu, 17 Jul 2025
 22:44:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250522-pmu_event_info-v3-0-f7bba7fd9cfe@rivosinc.com> <20250522-pmu_event_info-v3-8-f7bba7fd9cfe@rivosinc.com>
In-Reply-To: <20250522-pmu_event_info-v3-8-f7bba7fd9cfe@rivosinc.com>
From: Anup Patel <anup@brainfault.org>
Date: Fri, 18 Jul 2025 11:14:21 +0530
X-Gm-Features: Ac12FXyXbFx3oQHSVcqGrTUnY6wqlJWgBpkN376n7_oc300BjXLNazpUiw8OmFU
Message-ID: <CAAhSdy1Ca4pYDjTPz2YfgWx2R-N3GPdEGjoqksJi1Bc_xRdF-w@mail.gmail.com>
Subject: Re: [PATCH v3 8/9] RISC-V: KVM: Implement get event info function
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
> The new get_event_info funciton allows the guest to query the presence
> of multiple events with single SBI call. Currently, the perf driver
> in linux guest invokes it for all the standard SBI PMU events. Support
> the SBI function implementation in KVM as well.
>
> Signed-off-by: Atish Patra <atishp@rivosinc.com>

LGTM.

Reviewed-by: Anup Patel <anup@brainfault.org>

Regards,
Anup

> ---
>  arch/riscv/include/asm/kvm_vcpu_pmu.h |  3 ++
>  arch/riscv/kvm/vcpu_pmu.c             | 66 +++++++++++++++++++++++++++++=
++++++
>  arch/riscv/kvm/vcpu_sbi_pmu.c         |  3 ++
>  3 files changed, 72 insertions(+)
>
> diff --git a/arch/riscv/include/asm/kvm_vcpu_pmu.h b/arch/riscv/include/a=
sm/kvm_vcpu_pmu.h
> index 1d85b6617508..9a930afc8f57 100644
> --- a/arch/riscv/include/asm/kvm_vcpu_pmu.h
> +++ b/arch/riscv/include/asm/kvm_vcpu_pmu.h
> @@ -98,6 +98,9 @@ void kvm_riscv_vcpu_pmu_init(struct kvm_vcpu *vcpu);
>  int kvm_riscv_vcpu_pmu_snapshot_set_shmem(struct kvm_vcpu *vcpu, unsigne=
d long saddr_low,
>                                       unsigned long saddr_high, unsigned =
long flags,
>                                       struct kvm_vcpu_sbi_return *retdata=
);
> +int kvm_riscv_vcpu_pmu_event_info(struct kvm_vcpu *vcpu, unsigned long s=
addr_low,
> +                                 unsigned long saddr_high, unsigned long=
 num_events,
> +                                 unsigned long flags, struct kvm_vcpu_sb=
i_return *retdata);
>  void kvm_riscv_vcpu_pmu_deinit(struct kvm_vcpu *vcpu);
>  void kvm_riscv_vcpu_pmu_reset(struct kvm_vcpu *vcpu);
>
> diff --git a/arch/riscv/kvm/vcpu_pmu.c b/arch/riscv/kvm/vcpu_pmu.c
> index 163bd4403fd0..70a6bdfc42f5 100644
> --- a/arch/riscv/kvm/vcpu_pmu.c
> +++ b/arch/riscv/kvm/vcpu_pmu.c
> @@ -453,6 +453,72 @@ int kvm_riscv_vcpu_pmu_snapshot_set_shmem(struct kvm=
_vcpu *vcpu, unsigned long s
>         return 0;
>  }
>
> +int kvm_riscv_vcpu_pmu_event_info(struct kvm_vcpu *vcpu, unsigned long s=
addr_low,
> +                                 unsigned long saddr_high, unsigned long=
 num_events,
> +                                 unsigned long flags, struct kvm_vcpu_sb=
i_return *retdata)
> +{
> +       struct riscv_pmu_event_info *einfo;
> +       int shmem_size =3D num_events * sizeof(*einfo);
> +       gpa_t shmem;
> +       u32 eidx, etype;
> +       u64 econfig;
> +       int ret;
> +
> +       if (flags !=3D 0 || (saddr_low & (SZ_16 - 1))) {
> +               ret =3D SBI_ERR_INVALID_PARAM;
> +               goto out;
> +       }
> +
> +       shmem =3D saddr_low;
> +       if (saddr_high !=3D 0) {
> +               if (IS_ENABLED(CONFIG_32BIT)) {
> +                       shmem |=3D ((gpa_t)saddr_high << 32);
> +               } else {
> +                       ret =3D SBI_ERR_INVALID_ADDRESS;
> +                       goto out;
> +               }
> +       }
> +
> +       if (kvm_vcpu_validate_gpa_range(vcpu, shmem, shmem_size, true)) {
> +               ret =3D SBI_ERR_INVALID_ADDRESS;
> +               goto out;
> +       }
> +
> +       einfo =3D kzalloc(shmem_size, GFP_KERNEL);
> +       if (!einfo)
> +               return -ENOMEM;
> +
> +       ret =3D kvm_vcpu_read_guest(vcpu, shmem, einfo, shmem_size);
> +       if (ret) {
> +               ret =3D SBI_ERR_FAILURE;
> +               goto free_mem;
> +       }
> +
> +       for (int i =3D 0; i < num_events; i++) {
> +               eidx =3D einfo[i].event_idx;
> +               etype =3D kvm_pmu_get_perf_event_type(eidx);
> +               econfig =3D kvm_pmu_get_perf_event_config(eidx, einfo[i].=
event_data);
> +               ret =3D riscv_pmu_get_event_info(etype, econfig, NULL);
> +               if (ret > 0)
> +                       einfo[i].output =3D 1;
> +               else
> +                       einfo[i].output =3D 0;
> +       }
> +
> +       kvm_vcpu_write_guest(vcpu, shmem, einfo, shmem_size);
> +       if (ret) {
> +               ret =3D SBI_ERR_FAILURE;
> +               goto free_mem;
> +       }
> +
> +free_mem:
> +       kfree(einfo);
> +out:
> +       retdata->err_val =3D ret;
> +
> +       return 0;
> +}
> +
>  int kvm_riscv_vcpu_pmu_num_ctrs(struct kvm_vcpu *vcpu,
>                                 struct kvm_vcpu_sbi_return *retdata)
>  {
> diff --git a/arch/riscv/kvm/vcpu_sbi_pmu.c b/arch/riscv/kvm/vcpu_sbi_pmu.=
c
> index e4be34e03e83..a020d979d179 100644
> --- a/arch/riscv/kvm/vcpu_sbi_pmu.c
> +++ b/arch/riscv/kvm/vcpu_sbi_pmu.c
> @@ -73,6 +73,9 @@ static int kvm_sbi_ext_pmu_handler(struct kvm_vcpu *vcp=
u, struct kvm_run *run,
>         case SBI_EXT_PMU_SNAPSHOT_SET_SHMEM:
>                 ret =3D kvm_riscv_vcpu_pmu_snapshot_set_shmem(vcpu, cp->a=
0, cp->a1, cp->a2, retdata);
>                 break;
> +       case SBI_EXT_PMU_EVENT_GET_INFO:
> +               ret =3D kvm_riscv_vcpu_pmu_event_info(vcpu, cp->a0, cp->a=
1, cp->a2, cp->a3, retdata);
> +               break;
>         default:
>                 retdata->err_val =3D SBI_ERR_NOT_SUPPORTED;
>         }
>
> --
> 2.43.0
>

