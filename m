Return-Path: <kvm+bounces-33368-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B88959EA425
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 02:16:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C4324164601
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 01:16:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A7DA45009;
	Tue, 10 Dec 2024 01:16:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="LqNq6CA8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FE81EEB1
	for <kvm@vger.kernel.org>; Tue, 10 Dec 2024 01:16:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733793403; cv=none; b=hLU9AqwjaIRUOFRh+volF6WHjT+vGNIBxoMBksLSb7pkpoXTZF8j/XlfAXSrulnvOlAfSYGMH7kEXfw6gYZqrVlWDkHyYurTPM6EC27k3LHmf1Md0iUUCqN4TwAD1ABv06e0XZZfecCgv2DCu+HNtJLmbaUZvL3Al78b+/QXfPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733793403; c=relaxed/simple;
	bh=RbBYDPUngiUug0d2E6VY5eeahM3y44jfxkqGWgMNm7E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Qtru8r/yWRTX7bbeyPtGiNylJwbfphUCqpu5+HS0Lw92JT38fblzYPkyoZdNKy4D49CrcfShAhLnAcjbsVM0fL3Wvt53lzuPDbQASSkHoMTcLPWhWpTeIewDV+o4pn1golX9mKZGffVrMuohVV3gB8dD9hwBEV1UFSmoo93+ErY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=LqNq6CA8; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-725d9f57d90so1711730b3a.1
        for <kvm@vger.kernel.org>; Mon, 09 Dec 2024 17:16:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1733793400; x=1734398200; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7J7kgWgBG7zDr62P+Eop70r3Co12mfVgVIEm97IsjBc=;
        b=LqNq6CA8ruy7JcmTsPx5ExkqMuPLIf5GcZMpy0/sL+hFH9NfvK1ljWIZoPWIBEF6+J
         oBvDo++kJC6zvjtvSkLN2PQtuKeaCaiWn/+spk2QjoeLTwcFuAWClbHDCQEUIoU+kV/4
         r5XwCMEY1NxofD61Lx2aZ1ySO3iuXB6PhDN4yUqoEciCsQdcx+w3GZqqdquIKtSbrcz1
         oejAwxzZ6rbdReoGshyiPsmNPmaYgDUnr8XjpLGBCUB8m952gA4Od2F7eEvZlV9rBqpS
         e2W7YeN4qUxmeCc8ICAK790xYDaU5oK9/c+2INADokqpXfcol9L4UaCiozngeLAdwCwR
         MdTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733793400; x=1734398200;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7J7kgWgBG7zDr62P+Eop70r3Co12mfVgVIEm97IsjBc=;
        b=Gx4Uh9Z/zWzuoYLxyfWc4P6uwvbOfno/turnwuo77fOu32mq16KjT3eQbIlwpchIdt
         CXRtJiSCkPjzg6pDFPZSFXuzGDtlVWv3pZHHn3YJ47en5itNQc1SxpAFvLuZSEkWCDnE
         88qo8YkS6opnONqW3kHR7luOIhvXEyRZ72byacaNSfppD+ptaEpryomZW1RHnGMMzSS6
         5PaAcIblPEJhmgSN4o+k/SExeHQ+7QdKSOuL1eOF6LFvrKEO3yeLTpEO7gmcC9w6pDqq
         J5Wg13x0PLeopWNgUgfbmv8vzEgBYFkdWNBQUlbWkxlbDGtFOJ9QX1qbkcwKS65XsHEk
         s+HQ==
X-Forwarded-Encrypted: i=1; AJvYcCUJiobUW2ZYo9x+VqiRc7/0U590M7R5yQNKS3sxWkl24O0shbYsK8ZK72MF95hmEYsphP0=@vger.kernel.org
X-Gm-Message-State: AOJu0YyPOqnGZHKZklxHvSirX3jkcCBA4n0adBH+uxOvDheITzPxh579
	HNpzCjRacDTdIr5nd2SQS1lS2gxhtPSpVf7+34oIChfy+DU6RC72HHgMRTQFcdBejFCdUuAz60Q
	7UgdYnot/4sPq7iYX38MdkXzOs+gMudoJeVZylw==
X-Gm-Gg: ASbGncuBbof2QjH5jTrXzp/k8PVGt4HPZPzZd/b4xlm0GcHmB/+g8I5ZIM41eridyYv
	tjIVk36qGoMnHUXUbEZQ7msH/mKarKIUWEQ==
X-Google-Smtp-Source: AGHT+IFHWG7f/jrba0MmMIk74bj4FLvJsvbUDpvVWZRJa41JQQnsmT4zcuqnPTsbFg31v4fSgu0FSerblu+cl90/X5I=
X-Received: by 2002:a05:6a20:12cc:b0:1e0:ca95:3cb3 with SMTP id
 adf61e73a8af0-1e18713c3d0mr22123398637.37.1733793400400; Mon, 09 Dec 2024
 17:16:40 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241119-pmu_event_info-v1-0-a4f9691421f8@rivosinc.com>
 <20241119-pmu_event_info-v1-7-a4f9691421f8@rivosinc.com> <8dc7e94c-4bf2-4367-8561-166bec6ec315@sifive.com>
In-Reply-To: <8dc7e94c-4bf2-4367-8561-166bec6ec315@sifive.com>
From: Atish Kumar Patra <atishp@rivosinc.com>
Date: Mon, 9 Dec 2024 17:16:29 -0800
Message-ID: <CAHBxVyF73ZEuPk+skhr6jJbdUYWS6cm4=vneV8jrd=7Lh0H6vQ@mail.gmail.com>
Subject: Re: [PATCH 7/8] RISC-V: KVM: Implement get event info function
To: Samuel Holland <samuel.holland@sifive.com>
Cc: linux-riscv@lists.infradead.org, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Palmer Dabbelt <palmer@rivosinc.com>, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, Anup Patel <anup@brainfault.org>, 
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Mayuresh Chitale <mchitale@ventanamicro.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 2, 2024 at 3:02=E2=80=AFPM Samuel Holland <samuel.holland@sifiv=
e.com> wrote:
>
> Hi Atish,
>
> On 2024-11-19 2:29 PM, Atish Patra wrote:
> > The new get_event_info funciton allows the guest to query the presence
> > of multiple events with single SBI call. Currently, the perf driver
> > in linux guest invokes it for all the standard SBI PMU events. Support
> > the SBI function implementation in KVM as well.
> >
> > Signed-off-by: Atish Patra <atishp@rivosinc.com>
> > ---
> >  arch/riscv/include/asm/kvm_vcpu_pmu.h |  3 ++
> >  arch/riscv/kvm/vcpu_pmu.c             | 67 +++++++++++++++++++++++++++=
++++++++
> >  arch/riscv/kvm/vcpu_sbi_pmu.c         |  3 ++
> >  3 files changed, 73 insertions(+)
> >
> > diff --git a/arch/riscv/include/asm/kvm_vcpu_pmu.h b/arch/riscv/include=
/asm/kvm_vcpu_pmu.h
> > index 1d85b6617508..9a930afc8f57 100644
> > --- a/arch/riscv/include/asm/kvm_vcpu_pmu.h
> > +++ b/arch/riscv/include/asm/kvm_vcpu_pmu.h
> > @@ -98,6 +98,9 @@ void kvm_riscv_vcpu_pmu_init(struct kvm_vcpu *vcpu);
> >  int kvm_riscv_vcpu_pmu_snapshot_set_shmem(struct kvm_vcpu *vcpu, unsig=
ned long saddr_low,
> >                                     unsigned long saddr_high, unsigned =
long flags,
> >                                     struct kvm_vcpu_sbi_return *retdata=
);
> > +int kvm_riscv_vcpu_pmu_event_info(struct kvm_vcpu *vcpu, unsigned long=
 saddr_low,
> > +                               unsigned long saddr_high, unsigned long=
 num_events,
> > +                               unsigned long flags, struct kvm_vcpu_sb=
i_return *retdata);
> >  void kvm_riscv_vcpu_pmu_deinit(struct kvm_vcpu *vcpu);
> >  void kvm_riscv_vcpu_pmu_reset(struct kvm_vcpu *vcpu);
> >
> > diff --git a/arch/riscv/kvm/vcpu_pmu.c b/arch/riscv/kvm/vcpu_pmu.c
> > index efd66835c2b8..a30f7ec31479 100644
> > --- a/arch/riscv/kvm/vcpu_pmu.c
> > +++ b/arch/riscv/kvm/vcpu_pmu.c
> > @@ -456,6 +456,73 @@ int kvm_riscv_vcpu_pmu_snapshot_set_shmem(struct k=
vm_vcpu *vcpu, unsigned long s
> >       return 0;
> >  }
> >
> > +int kvm_riscv_vcpu_pmu_event_info(struct kvm_vcpu *vcpu, unsigned long=
 saddr_low,
> > +                               unsigned long saddr_high, unsigned long=
 num_events,
> > +                               unsigned long flags, struct kvm_vcpu_sb=
i_return *retdata)
> > +{
> > +     unsigned long hva;
> > +     struct riscv_pmu_event_info *einfo;
> > +     int shmem_size =3D num_events * sizeof(*einfo);
> > +     bool writable;
> > +     gpa_t shmem;
> > +     u32 eidx, etype;
> > +     u64 econfig;
> > +     int ret;
> > +
> > +     if (flags !=3D 0 || (saddr_low & (SZ_16 - 1))) {
> > +             ret =3D SBI_ERR_INVALID_PARAM;
> > +             goto out;
> > +     }
> > +
> > +     shmem =3D saddr_low;
> > +     if (saddr_high !=3D 0) {
> > +             if (IS_ENABLED(CONFIG_32BIT)) {
> > +                     shmem |=3D ((gpa_t)saddr_high << 32);
> > +             } else {
> > +                     ret =3D SBI_ERR_INVALID_ADDRESS;
> > +                     goto out;
> > +             }
> > +     }
> > +
> > +     hva =3D kvm_vcpu_gfn_to_hva_prot(vcpu, shmem >> PAGE_SHIFT, &writ=
able);
> > +     if (kvm_is_error_hva(hva) || !writable) {
> > +             ret =3D SBI_ERR_INVALID_ADDRESS;
>
> This only checks the first page if the address crosses a page boundary. M=
aybe
> that is okay since kvm_vcpu_read_guest()/kvm_vcpu_write_guest() will fail=
 if a
> later page is inaccessible?
>

That's my assumption as well.
We can invoke kvm_vcpu_gfn_to_hva_prot in a loop to validate all the
pages starting with shmem though.
The difference would be the error code returned
(SBI_ERR_INVALID_ADDRESS vs SBI_ERR_FAILURE)
which the specification allows anyways.

Let me know if you think KVM must validate the entire range. I can add in v=
2.

> > +             goto out;
> > +     }
> > +
> > +     einfo =3D kzalloc(shmem_size, GFP_KERNEL);
> > +     if (!einfo)
> > +             return -ENOMEM;
> > +
> > +     ret =3D kvm_vcpu_read_guest(vcpu, shmem, einfo, shmem_size);
> > +     if (ret) {
> > +             ret =3D SBI_ERR_FAILURE;
> > +             goto free_mem;
> > +     }
> > +
> > +     for (int i =3D 0; i < num_events; i++) {
> > +             eidx =3D einfo[i].event_idx;
> > +             etype =3D kvm_pmu_get_perf_event_type(eidx);
> > +             econfig =3D kvm_pmu_get_perf_event_config(eidx, einfo[i].=
event_data);
> > +             ret =3D riscv_pmu_get_event_info(etype, econfig, NULL);
> > +             if (ret > 0)
> > +                     einfo[i].output =3D 1;
>
> This also needs to write `output` in the else case to indicate that the e=
vent is
> not supported; the spec does not require the caller to initialize bit 0 o=
f
> output to zero.
>

Sure. Added.

> Regards,
> Samuel
>
> > +     }
> > +
> > +     kvm_vcpu_write_guest(vcpu, shmem, einfo, shmem_size);
> > +     if (ret) {
> > +             ret =3D SBI_ERR_FAILURE;
> > +             goto free_mem;
> > +     }
> > +
> > +free_mem:
> > +     kfree(einfo);
> > +out:
> > +     retdata->err_val =3D ret;
> > +
> > +     return 0;
> > +}
> > +
> >  int kvm_riscv_vcpu_pmu_num_ctrs(struct kvm_vcpu *vcpu,
> >                               struct kvm_vcpu_sbi_return *retdata)
> >  {
> > diff --git a/arch/riscv/kvm/vcpu_sbi_pmu.c b/arch/riscv/kvm/vcpu_sbi_pm=
u.c
> > index e4be34e03e83..a020d979d179 100644
> > --- a/arch/riscv/kvm/vcpu_sbi_pmu.c
> > +++ b/arch/riscv/kvm/vcpu_sbi_pmu.c
> > @@ -73,6 +73,9 @@ static int kvm_sbi_ext_pmu_handler(struct kvm_vcpu *v=
cpu, struct kvm_run *run,
> >       case SBI_EXT_PMU_SNAPSHOT_SET_SHMEM:
> >               ret =3D kvm_riscv_vcpu_pmu_snapshot_set_shmem(vcpu, cp->a=
0, cp->a1, cp->a2, retdata);
> >               break;
> > +     case SBI_EXT_PMU_EVENT_GET_INFO:
> > +             ret =3D kvm_riscv_vcpu_pmu_event_info(vcpu, cp->a0, cp->a=
1, cp->a2, cp->a3, retdata);
> > +             break;
> >       default:
> >               retdata->err_val =3D SBI_ERR_NOT_SUPPORTED;
> >       }
> >
>

