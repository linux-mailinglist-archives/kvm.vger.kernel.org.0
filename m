Return-Path: <kvm+bounces-52746-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 326E5B09044
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 17:12:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2C8ED3A3AE4
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 15:11:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7266B2F8C45;
	Thu, 17 Jul 2025 15:11:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="jWApNJbl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3F942F85F2
	for <kvm@vger.kernel.org>; Thu, 17 Jul 2025 15:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752765096; cv=none; b=MiCVUGXDIzCe6PwXpA4PFZJD0A3+xSFPoGwnJItg1PyZ9lBIroaeJ1rdK2aiovTLJLwnksE0feBhnbBRkZOeCeynnb74BXaaeqiplNJhrRXlMJUEj6eYYOtkBEKEiNssIldTsaoB1EiIQlqb8uVPxJvnutMrOJJ/6us3vDxbus0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752765096; c=relaxed/simple;
	bh=UAuHwhH12FUgc3erk5hSuHGsnlMGDgzeXnW9mobVYE8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Wbg6GhiXAJBChiLOjnlpOTznx5W5HS8DWj9BV+cS6YbTTJGwD5i58x7WhH9vWxRWGnCj4JjAZ8l+MmkbZvjHkQKpYdDnHzyyfJmINdheQxJkd0L+CRCkPxoHbz53mJWJhDsq7163p1Sn1T2njtRgv0cSyaq4D6MZLV/3zVE/TNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=jWApNJbl; arc=none smtp.client-ip=209.85.222.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-7e34493ecb4so106877585a.1
        for <kvm@vger.kernel.org>; Thu, 17 Jul 2025 08:11:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1752765093; x=1753369893; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bCn0C31hN22UugwY+nNOxL0Cz8wHEu8jqXWG+wcYuqQ=;
        b=jWApNJblOot3gPeA+BPH679b0KsTgKUAtjtFfNgzUjFD2jAPV01/OaX4cY1LQISHte
         rKWkOyH8rqtieQciEKjneUTESKxdUyqPqGEtOIL3xuE5nsq9eXomd3BVmPA2E8M2w9O/
         49Gr29s00GFHeAs+7n7NPPDK6Hf5fhgc1zHjcdX0ypDNt5HcED6F1kyxnU+rOigcdnhz
         l6gF3YqvZQYNlr46SLC/rtl7XnrlFvQpW2KbgPUjN9noF1OoXxUzyINjnEFlAyP7ip2u
         4X++OfjW0/dJ1/f2Ct9a4uYYv7/o3KrK8ynfkyJ1VndNT2zN0QMEmjTm3Kgxwi48NfCa
         zOzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752765093; x=1753369893;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bCn0C31hN22UugwY+nNOxL0Cz8wHEu8jqXWG+wcYuqQ=;
        b=jce/ufap71k0TAc0R//3PH3YU7w5Tcc9N0bMciQ6UYcAicl9URcYocaSH3AIaQvH8j
         jNSLUEk9UkMUwBumXDnEKXUv3wTm+3idfox5xCFaPYBZQq6VOawOnqwQXC1/5h6SFlO4
         fZqym7fgYs4BLmG4Wsa6lngIXcp+7bIwhdAxtH+86UXjEOE5GlrjBulXR5iLncZLRUBP
         IM8o340RHc51Ls0e0Axu43W8xKNGo0PZkF+UUM3KS/RKXbBKjP7knLR+LJaoJprmzQPw
         iiSftRG1clgaqkDTNj6lwHfqpsdQ4HBDtmaD+YM3X6HfpAXI+G9DmhyoCTt50rGrEB/4
         rSCA==
X-Forwarded-Encrypted: i=1; AJvYcCXtK6tMHUmhoryi69w0mKCF1sl3WVhNbDnYasAIwAj1Av0pv10EVexBstE6/wY/4v1TpZs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy+HWNhB7lOLP2I+C6xy9RHk7nsBVPfQBOho4vm3sQtFas/sEtR
	GKcFjysAb/bngjl3emw6EH7VmyHqDgep76nS94ybm9xhMMtHaCcnaGN8ugEvrm6nS9iq+Jwytho
	fxxsbPknuDRwuPMSC1tGFLvUjBqAh+bq62qKOuLIWGA==
X-Gm-Gg: ASbGncsQCauu8hiLAT5IZLUWd9W7wA4aW9SLGHhvvMMp7yfhEd5gNkuNkrjMUDgygR3
	UwV9Ii7INrrVS6vYm8ti0W+CxKYhKPJzhy2w14zon3POXqtMnnhPBtjIQCJrpeym9hbDAkOlGdy
	hp4pQT/afEOkGNtMni44Y9raMeyilBf7FVY50Tr34xTm9/anKyLpRjx9A1XohJ/XJTDsk/5LNQ3
	ItsFiUN
X-Google-Smtp-Source: AGHT+IHaFJ1sfqQyWiG9DiWncsz3p3oF6sF6SWaO0rxigj/urXDCJiahMXJIk9SDxHRXku+eh2bgCplK2qeaMk0aX54=
X-Received: by 2002:a05:620a:28c6:b0:7e2:77d0:f33d with SMTP id
 af79cd13be357-7e34356b8admr1012854085a.14.1752765092470; Thu, 17 Jul 2025
 08:11:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250522-pmu_event_info-v3-0-f7bba7fd9cfe@rivosinc.com> <20250522-pmu_event_info-v3-1-f7bba7fd9cfe@rivosinc.com>
In-Reply-To: <20250522-pmu_event_info-v3-1-f7bba7fd9cfe@rivosinc.com>
From: Anup Patel <anup@brainfault.org>
Date: Thu, 17 Jul 2025 20:41:21 +0530
X-Gm-Features: Ac12FXzdth30OveMxtaGx1W5ZBrjzTJj5_mIPZDmwmxiXuGuVRtL8fMgmMv9bXQ
Message-ID: <CAAhSdy1LVhWUovNLwfv2Y2eOzjewM005+gUENFDg-gqUaBuBgg@mail.gmail.com>
Subject: Re: [PATCH v3 1/9] drivers/perf: riscv: Add SBI v3.0 flag
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
> There are new PMU related features introduced in SBI v3.0.
> 1. Raw Event v2 which allows mhpmeventX value to be 56 bit wide.
> 2. Get Event info function to do a bulk query at one shot.
>
> Signed-off-by: Atish Patra <atishp@rivosinc.com>

LGTM.

Reviewed-by: Anup Patel <anup@brainfault.org>

Regards,
Anup

> ---
>  drivers/perf/riscv_pmu_sbi.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/drivers/perf/riscv_pmu_sbi.c b/drivers/perf/riscv_pmu_sbi.c
> index 698de8ddf895..cfd6946fca42 100644
> --- a/drivers/perf/riscv_pmu_sbi.c
> +++ b/drivers/perf/riscv_pmu_sbi.c
> @@ -63,6 +63,7 @@ PMU_FORMAT_ATTR(event, "config:0-47");
>  PMU_FORMAT_ATTR(firmware, "config:62-63");
>
>  static bool sbi_v2_available;
> +static bool sbi_v3_available;
>  static DEFINE_STATIC_KEY_FALSE(sbi_pmu_snapshot_available);
>  #define sbi_pmu_snapshot_available() \
>         static_branch_unlikely(&sbi_pmu_snapshot_available)
> @@ -1452,6 +1453,9 @@ static int __init pmu_sbi_devinit(void)
>         if (sbi_spec_version >=3D sbi_mk_version(2, 0))
>                 sbi_v2_available =3D true;
>
> +       if (sbi_spec_version >=3D sbi_mk_version(3, 0))
> +               sbi_v3_available =3D true;
> +
>         ret =3D cpuhp_setup_state_multi(CPUHP_AP_PERF_RISCV_STARTING,
>                                       "perf/riscv/pmu:starting",
>                                       pmu_sbi_starting_cpu, pmu_sbi_dying=
_cpu);
>
> --
> 2.43.0
>

